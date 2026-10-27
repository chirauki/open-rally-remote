// Copied from BLEDfu.cpp in the Adafruit Bluefruit nRF52 library 0.21.0
// (Seeed nRF52 Boards 1.1.13), which has no hook to refuse an update. The
// changes are marked "Open Rally Remote": the allow callback, and its refusal.
/*
    Software License Agreement (BSD License)

    Copyright (c) 2018, Adafruit Industries (adafruit.com)
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
    3. Neither the name of the copyright holders nor the
    names of its contributors may be used to endorse or promote products
    derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ''AS IS'' AND ANY
    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "orr_dfu.h"

#define DFU_REV_APPMODE 0x0001

// DFU service 00001530-1212-EFDE-1523-785FEABCD123 and its characteristics.
static const uint8_t UUID128_SVC_DFU_OTA[16] = {
  0x23, 0xD1, 0xBC, 0xEA, 0x5F, 0x78, 0x23, 0x15, 0xDE, 0xEF, 0x12, 0x12, 0x30, 0x15, 0x00, 0x00
};
static const uint8_t UUID128_CHR_DFU_CONTROL[16] = {
  0x23, 0xD1, 0xBC, 0xEA, 0x5F, 0x78, 0x23, 0x15, 0xDE, 0xEF, 0x12, 0x12, 0x31, 0x15, 0x00, 0x00
};
static const uint8_t UUID128_CHR_DFU_PACKET[16] = {
  0x23, 0xD1, 0xBC, 0xEA, 0x5F, 0x78, 0x23, 0x15, 0xDE, 0xEF, 0x12, 0x12, 0x32, 0x15, 0x00, 0x00
};
static const uint8_t UUID128_CHR_DFU_REVISION[16] = {
  0x23, 0xD1, 0xBC, 0xEA, 0x5F, 0x78, 0x23, 0x15, 0xDE, 0xEF, 0x12, 0x12, 0x34, 0x15, 0x00, 0x00
};

extern "C" void bootloader_util_app_start(uint32_t start_addr);

// Open Rally Remote: the sketch's check.
static bool (*allow_cb)(uint16_t conn_hdl) = nullptr;

static uint16_t crc16(const uint8_t *data_p, uint8_t length) {
  uint8_t x;
  uint16_t crc = 0xFFFF;
  while (length--) {
    x = crc >> 8 ^ *data_p++;
    x ^= x >> 4;
    crc = (crc << 8) ^ ((uint16_t)(x << 12)) ^ ((uint16_t)(x << 5)) ^ ((uint16_t)x);
  }
  // As in BLEDfu.cpp: it returns 0, not crc. The bootloader then finds no valid
  // peer data and advertises as AdaDFU, which the tested update path relies on.
  (void)crc;
  return ERROR_NONE;
}

static void control_wr_authorize_cb(uint16_t conn_hdl, BLECharacteristic *chr,
                                    ble_gatts_evt_write_t *request) {
  if (request->handle != chr->handles().value_handle || request->op == BLE_GATTS_OP_PREP_WRITE_REQ ||
      request->op == BLE_GATTS_OP_EXEC_WRITE_REQ_NOW || request->op == BLE_GATTS_OP_EXEC_WRITE_REQ_CANCEL) {
    return;
  }
  BLEConnection *conn = Bluefruit.Connection(conn_hdl);
  ble_gatts_rw_authorize_reply_params_t reply = { .type = BLE_GATTS_AUTHORIZE_TYPE_WRITE };

  if (!chr->notifyEnabled(conn_hdl)) {
    reply.params.write.gatt_status = BLE_GATT_STATUS_ATTERR_CPS_CCCD_CONFIG_ERROR;
    sd_ble_gatts_rw_authorize_reply(conn_hdl, &reply);
    return;
  }

  enum { START_DFU = 1 };
  // Open Rally Remote: refuse the start unless the sketch allows it.
  if (request->data[0] == START_DFU && (allow_cb == nullptr || !allow_cb(conn_hdl))) {
    reply.params.write.gatt_status = BLE_GATT_STATUS_ATTERR_INSUF_AUTHORIZATION;
    sd_ble_gatts_rw_authorize_reply(conn_hdl, &reply);
    return;
  }

  reply.params.write.gatt_status = BLE_GATT_STATUS_SUCCESS;
  sd_ble_gatts_rw_authorize_reply(conn_hdl, &reply);

  if (request->data[0] != START_DFU) return;

  // Peer data, so that the bootloader can reconnect after the restart. Its
  // address is fixed in the bootloader's linker script, at 0x20007F80.
  typedef struct {
    ble_gap_addr_t addr;
    ble_gap_irk_t irk;
    ble_gap_enc_key_t enc_key;
    uint8_t sys_attr[8];
    uint16_t crc16;
  } peer_data_t;
  static_assert(offsetof(peer_data_t, crc16) == 60, "bootloader peer data layout");

  peer_data_t *peer_data = (peer_data_t *)(0x20007F80UL);
  varclr(peer_data);

  uint16_t sysattr_len = sizeof(peer_data->sys_attr);
  sd_ble_gatts_sys_attr_get(conn_hdl, peer_data->sys_attr, &sysattr_len, BLE_GATTS_SYS_ATTR_FLAG_SYS_SRVCS);

  peer_data->addr = conn->getPeerAddr();
  if (conn->secured()) {
    bond_keys_t bkeys;
    if (conn->loadBondKey(&bkeys)) {
      peer_data->addr = bkeys.peer_id.id_addr_info;
      peer_data->irk = bkeys.peer_id.id_info;
      peer_data->enc_key = bkeys.own_enc;
    }
  }
  peer_data->crc16 = crc16((uint8_t *)peer_data, offsetof(peer_data_t, crc16));

  // Restart into the bootloader's BLE OTA mode.
  Bluefruit.Advertising.restartOnDisconnect(false);
  conn->disconnect();

  enum { DFU_OTA_MAGIC = 0xB1 };
  sd_power_gpregret_clr(0, 0xFF);
  VERIFY_STATUS(sd_power_gpregret_set(0, DFU_OTA_MAGIC), );
  VERIFY_STATUS(sd_softdevice_disable(), );

  NVIC->ICER[0] = 0xFFFFFFFF;
  NVIC->ICPR[0] = 0xFFFFFFFF;
#if defined(__NRF_NVIC_ISER_COUNT) && __NRF_NVIC_ISER_COUNT == 2
  NVIC->ICER[1] = 0xFFFFFFFF;
  NVIC->ICPR[1] = 0xFFFFFFFF;
#endif

  VERIFY_STATUS(sd_softdevice_vector_table_base_set(NRF_UICR->NRFFW[0]), );
  __set_CONTROL(0);  // switch to MSP, needed with FreeRTOS
  bootloader_util_app_start(NRF_UICR->NRFFW[0]);
}

OrrDfu::OrrDfu() : BLEService(UUID128_SVC_DFU_OTA), _chr_control(UUID128_CHR_DFU_CONTROL) {}

void OrrDfu::setAllowCallback(bool (*fp)(uint16_t conn_hdl)) { allow_cb = fp; }

err_t OrrDfu::begin() {
  VERIFY_STATUS(BLEService::begin());

  // The packet and revision characteristics need not be kept.
  BLECharacteristic chr_packet(UUID128_CHR_DFU_PACKET);
  chr_packet.setTempMemory();
  chr_packet.setProperties(CHR_PROPS_WRITE_WO_RESP);
  chr_packet.setMaxLen(20);
  VERIFY_STATUS(chr_packet.begin());

  _chr_control.setProperties(CHR_PROPS_WRITE | CHR_PROPS_NOTIFY);
  // Open Rally Remote: writes need an encrypted link. The SoftDevice answers
  // "insufficient encryption" on a plain one, and a bonded phone then encrypts
  // the link with its stored keys and writes again.
  _chr_control.setPermission(SECMODE_OPEN, SECMODE_ENC_NO_MITM);
  _chr_control.setMaxLen(23);
  _chr_control.setWriteAuthorizeCallback(control_wr_authorize_cb);
  VERIFY_STATUS(_chr_control.begin());

  BLECharacteristic chr_revision(UUID128_CHR_DFU_REVISION);
  chr_revision.setTempMemory();
  chr_revision.setProperties(CHR_PROPS_READ);
  chr_revision.setFixedLen(2);
  VERIFY_STATUS(chr_revision.begin());
  chr_revision.write16(DFU_REV_APPMODE);

  return ERROR_NONE;
}
