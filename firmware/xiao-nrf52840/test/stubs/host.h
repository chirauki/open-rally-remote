// Host stand-ins for the Arduino core, Bluefruit, TinyUSB and LittleFS APIs the
// sketch uses, so it compiles and runs on a computer under test/test_sketch.cpp.
// Pins, the clock, the BLE link and the flash are simulated; the HID reports
// the sketch sends are recorded in `host`.
#pragma once

#include <cstdarg>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <map>
#include <string>
#include <vector>

// ---------- Simulated state ----------

struct HidEvent {
  uint32_t at;
  bool consumer;           // consumer-control (media) report
  uint8_t keys[6];         // keyboard report
  uint16_t usage;          // consumer report; 0 is a release
};

struct HostState {
  uint32_t now = 0;
  int pinLevel[64];        // what digitalRead returns
  int pinWritten[64];      // last digitalWrite
  bool connected = false;
  bool usbPresent = true;
  uint16_t adcRaw = 2000;
  std::vector<HidEvent> events;
  std::map<std::string, std::vector<uint8_t>> files;
  std::string log;
  // BLE security of the one simulated connection, and what the sketch did.
  bool peerSecured = false;
  bool peerBonded = false;
  bool bondRemoved = false;
  bool peerDisconnected = false;
  bool (*dfuAllowCb)(uint16_t conn_hdl) = nullptr;
  void (*pairCompleteCb)(uint16_t conn_hdl, uint8_t auth_status) = nullptr;
  // Advertising: the library's open advertising and orr_whitelist's.
  int openAdvStarts = 0;
  int advStops = 0;
  bool restartOnDisconnect = false;
  uint8_t bondedPeers = 0;     // bonds orr_whitelist finds in the flash
  bool whitelistFails = false; // the SoftDevice refuses the lists
  int whitelistStarts = 0;     // calls of orrStartWhitelistAdvertising
  HostState() {
    for (int &p : pinLevel) p = 1;     // pull-ups: released reads HIGH
    for (int &p : pinWritten) p = -1;
  }
};
inline HostState host;

struct HostRestart {};     // NVIC_SystemReset
struct HostSystemOff {};   // sd_power_system_off

// ---------- Arduino core ----------

constexpr int LOW = 0, HIGH = 1;
constexpr int INPUT = 0, OUTPUT = 1, INPUT_PULLUP = 2;
constexpr int D0 = 0, D1 = 1, D2 = 2, D3 = 3, D4 = 4, D5 = 5, D6 = 6, D7 = 7,
              D8 = 8, D9 = 9, D10 = 10;
constexpr int A0 = D0;
constexpr int LED_RED = 11, LED_GREEN = 12, LED_BLUE = 13;
constexpr int VBAT_ENABLE = 14, PIN_VBAT = 32, PIN_CHARGING_CURRENT = 22;
constexpr int AR_INTERNAL = 0;

inline uint32_t millis() { return host.now; }
inline void delay(uint32_t ms) { host.now += ms; }
inline void pinMode(int, int) {}
inline int digitalRead(int pin) { return host.pinLevel[pin]; }
inline void digitalWrite(int pin, int level) { host.pinWritten[pin] = level; }
inline int analogRead(int) { return host.adcRaw; }
inline void analogReference(int) {}
inline void analogReadResolution(int) {}
inline void analogSampleTime(int) {}

struct HostSerial {
  void begin(unsigned long) {}
  explicit operator bool() const { return true; }
  void flush() {}
  void print(const char *s) { host.log += s; }
  void print(int v) { host.log += std::to_string(v); }
  template <typename T> void println(T v) { print(v); host.log += "\n"; }
  void println() { host.log += "\n"; }
  void printf(const char *fmt, ...) __attribute__((format(printf, 2, 3))) {
    char buf[256];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(buf, sizeof(buf), fmt, ap);
    va_end(ap);
    host.log += buf;
  }
};
inline HostSerial Serial;

// ---------- nRF52 SDK ----------

constexpr uint32_t POWER_USBREGSTATUS_VBUSDETECT_Msk = 1;
inline uint32_t sd_power_usbregstatus_get(uint32_t *status) {
  *status = host.usbPresent ? POWER_USBREGSTATUS_VBUSDETECT_Msk : 0;
  return 0;
}
[[noreturn]] inline void sd_power_system_off() { throw HostSystemOff(); }
[[noreturn]] inline void NVIC_SystemReset() { throw HostRestart(); }
constexpr int NRF_GPIO_PIN_NOPULL = 0, NRF_GPIO_PIN_PULLUP = 1;
constexpr int NRF_GPIO_PIN_SENSE_LOW = 0, NRF_GPIO_PIN_SENSE_HIGH = 1;
inline void nrf_gpio_cfg_sense_input(uint32_t, int, int) {}
inline const uint32_t g_ADigitalPinMap[64] = {};

// ---------- TinyUSB HID usages ----------

enum : uint8_t {
  HID_KEY_NONE = 0x00,
  HID_KEY_A = 0x04, HID_KEY_B, HID_KEY_C, HID_KEY_D, HID_KEY_E, HID_KEY_F, HID_KEY_G,
  HID_KEY_H, HID_KEY_I, HID_KEY_J, HID_KEY_K, HID_KEY_L, HID_KEY_M, HID_KEY_N, HID_KEY_O,
  HID_KEY_P, HID_KEY_Q, HID_KEY_R, HID_KEY_S, HID_KEY_T, HID_KEY_U, HID_KEY_V, HID_KEY_W,
  HID_KEY_X, HID_KEY_Y, HID_KEY_Z,
  HID_KEY_MINUS = 0x2D, HID_KEY_EQUAL = 0x2E,
  HID_KEY_ARROW_RIGHT = 0x4F, HID_KEY_ARROW_LEFT = 0x50, HID_KEY_ARROW_DOWN = 0x51,
  HID_KEY_ARROW_UP = 0x52
};
constexpr uint16_t HID_USAGE_CONSUMER_PLAY_PAUSE = 0xCD;
constexpr uint16_t HID_USAGE_CONSUMER_VOLUME_INCREMENT = 0xE9;
constexpr uint16_t HID_USAGE_CONSUMER_VOLUME_DECREMENT = 0xEA;

// ---------- Bluefruit ----------

constexpr int BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE = 0;
constexpr int BLE_APPEARANCE_HID_KEYBOARD = 0;

constexpr uint8_t BLE_GAP_SEC_STATUS_SUCCESS = 0;

struct BLEService { void begin() {} };
// orr_dfu.h: the DFU service with the sketch's check.
struct OrrDfu : BLEService {
  void setAllowCallback(bool (*fp)(uint16_t)) { host.dfuAllowCb = fp; }
};
struct BLEDis : BLEService {
  void setManufacturer(const char *) {}
  void setModel(const char *) {}
  void setSoftwareRev(const char *) {}
};
struct BLEBas : BLEService { void write(uint8_t) {} };
struct BLEHidAdafruit : BLEService {
  bool keyboardReport(uint8_t, const uint8_t keys[6]) {
    HidEvent e{host.now, false, {}, 0};
    memcpy(e.keys, keys, 6);
    host.events.push_back(e);
    return true;
  }
  void keyRelease() {
    const uint8_t none[6] = {};
    keyboardReport(0, none);
  }
  void consumerKeyPress(uint16_t usage) { host.events.push_back({host.now, true, {}, usage}); }
  void consumerKeyRelease() { host.events.push_back({host.now, true, {}, 0}); }
};

struct HostAdvertising {
  void addFlags(int) {}
  void addTxPower() {}
  void addAppearance(int) {}
  void addService(BLEService &) {}
  void addName() {}
  void restartOnDisconnect(bool enable) { host.restartOnDisconnect = enable; }
  void setInterval(int, int) {}
  void setFastTimeout(int) {}
  void start(int) { ++host.openAdvStarts; }
  void stop() { ++host.advStops; }
};
// orr_whitelist.h: advertising that only bonded phones can connect to.
enum OrrWhitelistResult : uint8_t { ORR_WHITELIST_STARTED, ORR_WHITELIST_NO_BONDS, ORR_WHITELIST_FAILED };
inline OrrWhitelistResult orrStartWhitelistAdvertising(uint16_t) {
  ++host.whitelistStarts;
  if (host.bondedPeers == 0) return ORR_WHITELIST_NO_BONDS;
  return host.whitelistFails ? ORR_WHITELIST_FAILED : ORR_WHITELIST_STARTED;
}
inline const char *orrWhitelistFailure() { return "whitelist_set 0x0010"; }
struct HostConnection {
  bool secured() const { return host.peerSecured; }
  bool bonded() const { return host.peerBonded; }
  bool removeBondKey() { host.bondRemoved = true; return true; }
  bool disconnect() { host.peerDisconnected = true; return true; }
};
struct HostSecurity {
  void setPairCompleteCallback(void (*fp)(uint16_t, uint8_t)) { host.pairCompleteCb = fp; }
};
struct HostBluefruit {
  HostAdvertising Advertising, ScanResponse;
  HostSecurity Security;
  HostConnection *Connection(uint16_t) { static HostConnection c; return &c; }
  void begin() {}
  void setTxPower(int) {}
  void autoConnLed(bool) {}
  void setName(const char *) {}
  bool connected() const { return host.connected; }
  void getAddr(uint8_t mac[6]) { memset(mac, 0, 6); }
};
inline HostBluefruit Bluefruit;

// ---------- LittleFS ----------

constexpr int FILE_O_READ = 0, FILE_O_WRITE = 1;
namespace Adafruit_LittleFS_Namespace {
struct HostFS {
  void begin() {}
  void remove(const char *name) { host.files.erase(name); }
};
struct File {
  explicit File(HostFS &) {}
  bool open(const char *name, int mode) {
    name_ = name;
    if (mode == FILE_O_READ) return host.files.count(name_) != 0;
    host.files[name_].clear();
    return true;
  }
  int read(uint8_t *buf, int n) {
    const auto &data = host.files[name_];
    const int count = n < (int)data.size() ? n : (int)data.size();
    memcpy(buf, data.data(), count);
    return count;
  }
  int write(const uint8_t *buf, int n) {
    host.files[name_].insert(host.files[name_].end(), buf, buf + n);
    return n;
  }
  void close() {}
  std::string name_;
};
}  // namespace Adafruit_LittleFS_Namespace
inline Adafruit_LittleFS_Namespace::HostFS InternalFS;
