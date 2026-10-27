#include "orr_whitelist.h"

#include <InternalFileSystem.h>

using namespace Adafruit_LittleFS_Namespace;

namespace {

constexpr uint8_t MAX_PEERS = BLE_GAP_WHITELIST_ADDR_MAX_COUNT;
static_assert(MAX_PEERS <= BLE_GAP_DEVICE_IDENTITIES_MAX_COUNT, "one identity per whitelist entry");

// The SoftDevice keeps pointers to these while the lists are in use.
ble_gap_id_key_t peers[MAX_PEERS];
ble_gap_adv_data_t advData;
uint8_t advBytes[BLE_GAP_ADV_SET_DATA_SIZE_MAX];
char failure[64] = "";
uint8_t peerCount = 0;
uint8_t idCount = 0;

OrrWhitelistResult fail(const char *step, uint32_t err) {
  snprintf(failure, sizeof(failure), "%s 0x%04lX, %u bonds, %u IRKs, type %u", step, (unsigned long)err,
           peerCount, idCount, peerCount ? peers[0].id_addr_info.addr_type : 0);
  return ORR_WHITELIST_FAILED;
}

// The library's advertising data with the flags changed to "not
// discoverable": the SoftDevice refuses a whitelist with a discoverable mode
// (BLE_ERROR_GAP_DISCOVERABLE_WITH_WHITELIST). Bonded phones still reconnect;
// a new phone no longer lists the remote.
uint8_t copyAdvertisingData() {
  const uint8_t length = Bluefruit.Advertising.count();
  memcpy(advBytes, Bluefruit.Advertising.getData(), length);
  for (uint8_t i = 0; i + 2 < length && advBytes[i] != 0; i += advBytes[i] + 1) {
    if (advBytes[i + 1] == BLE_GAP_AD_TYPE_FLAGS && advBytes[i] == 2) {
      advBytes[i + 2] = BLE_GAP_ADV_FLAG_BR_EDR_NOT_SUPPORTED;
    }
  }
  return length;
}

bool irkIsSet(const ble_gap_irk_t &irk) {
  for (uint8_t b : irk.irk) {
    if (b != 0) return true;
  }
  return false;
}

// Reads the identity of each bond file, in the library's layout: a length
// byte, then the bond_keys_t (see utility/bonding.cpp).
uint8_t loadPeers() {
  uint8_t count = 0;
  File dir(BOND_DIR_PRPH, FILE_O_READ, InternalFS);
  if (!dir) return 0;
  File file(InternalFS);
  while (count < MAX_PEERS && (file = dir.openNextFile(FILE_O_READ))) {
    bond_keys_t keys;
    if (file.read() == sizeof(keys) && file.read((uint8_t *)&keys, sizeof(keys)) == sizeof(keys)) {
      peers[count++] = keys.peer_id;
    }
    file.close();
  }
  dir.close();
  return count;
}

}  // namespace

OrrWhitelistResult orrStartWhitelistAdvertising(uint16_t interval) {
  const uint8_t count = peerCount = loadPeers();
  idCount = 0;
  if (count == 0) return ORR_WHITELIST_NO_BONDS;

  // Phones advertise with resolvable private addresses: their IRKs let the
  // SoftDevice match them to the whitelisted identity addresses. A peer
  // without an IRK uses its identity address and needs no entry here.
  const ble_gap_id_key_t *ids[MAX_PEERS];
  const ble_gap_addr_t *addrs[MAX_PEERS];
  for (uint8_t i = 0; i < count; ++i) {
    addrs[i] = &peers[i].id_addr_info;
    if (irkIsSet(peers[i].id_info)) ids[idCount++] = &peers[i];
  }
  uint32_t err = sd_ble_gap_device_identities_set(idCount ? ids : nullptr, nullptr, idCount);
  if (err != NRF_SUCCESS) return fail("device_identities_set", err);
  err = sd_ble_gap_whitelist_set(addrs, count);
  if (err != NRF_SUCCESS) return fail("whitelist_set", err);

  advData.adv_data = { advBytes, copyAdvertisingData() };
  advData.scan_rsp_data = { Bluefruit.ScanResponse.getData(), Bluefruit.ScanResponse.count() };

  ble_gap_adv_params_t params = {};
  params.properties.type = BLE_GAP_ADV_TYPE_CONNECTABLE_SCANNABLE_UNDIRECTED;
  params.interval = interval;
  params.duration = BLE_GAP_ADV_TIMEOUT_GENERAL_UNLIMITED;
  // Anyone may scan (the name stays visible); only the whitelist may connect.
  params.filter_policy = BLE_GAP_ADV_FP_FILTER_CONNREQ;
  params.primary_phy = BLE_GAP_PHY_AUTO;
  params.secondary_phy = BLE_GAP_PHY_AUTO;

  // S140 has one advertising set. The library configured it first, so the
  // SoftDevice gave it handle 0; configuring handle 0 replaces its parameters.
  uint8_t handle = 0;
  err = sd_ble_gap_adv_set_configure(&handle, &advData, &params);
  if (err != NRF_SUCCESS) return fail("adv_set_configure", err);
  err = sd_ble_gap_tx_power_set(BLE_GAP_TX_POWER_ROLE_ADV, handle, Bluefruit.getTxPower());
  if (err != NRF_SUCCESS) return fail("tx_power_set", err);
  err = sd_ble_gap_adv_start(handle, CONN_CFG_PERIPHERAL);
  if (err != NRF_SUCCESS) return fail("adv_start", err);
  return ORR_WHITELIST_STARTED;
}

const char *orrWhitelistFailure() { return failure; }
