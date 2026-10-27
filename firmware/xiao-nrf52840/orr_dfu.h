// The legacy BLE DFU service of the Adafruit nRF52 bootloader, with a check
// before the board restarts into the bootloader. It keeps the UUIDs and the
// characteristics of Bluefruit's BLEDfu, so phone apps still find it; see
// orr_dfu.cpp.
#pragma once

#include <bluefruit.h>

class OrrDfu : public BLEService {
 public:
  OrrDfu();
  err_t begin() override;
  // Called on a write of "start DFU"; the update starts only if it returns true.
  void setAllowCallback(bool (*fp)(uint16_t conn_hdl));

 private:
  BLECharacteristic _chr_control;
};
