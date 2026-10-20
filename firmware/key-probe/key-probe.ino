// Open Rally Remote key probe, bench only.
//
// Sends one candidate key at a time over BLE HID, to find which keys an app
// (TerraPirata first) reacts to. The candidates come from the keys a
// commercial rally remote sends (see docs/control-mapping.md). Wiring is the
// bench breadboard's: Button A on D0, B on D1, C on D2, each to GND.
//
//   A: send the selected candidate (key down, 50 ms, key up)
//   B: select the next candidate
//   C: select the previous candidate
//
// After each selection the blue LED blinks the candidate's number; a send
// flashes the green LED. With the Serial Monitor open (115200 baud) the
// sketch also prints each selection and send.

#include <Adafruit_TinyUSB.h>
#include <bluefruit.h>

struct Candidate {
  const char *name;
  uint8_t key;         // HID keyboard usage, 0 for none
  uint16_t consumer;   // HID consumer usage sent first, 0 for none
};

const Candidate CANDIDATES[] = {
  { "F6", 0x3F, 0 },
  { "F7", 0x40, 0 },
  { "c", 0x06, 0 },
  { "z", 0x1D, 0 },
  { "k", 0x0E, 0 },
  { "x", 0x1B, 0 },
  { "r", 0x15, 0 },
  // The commercial remote's own combinations: a media key, then a key.
  { "Volume - then F6", 0x3F, HID_USAGE_CONSUMER_VOLUME_DECREMENT },
  { "Play/Pause then z", 0x1D, HID_USAGE_CONSUMER_PLAY_PAUSE },
  // Keys that change the trip, to set it away from zero before a reset test.
  { "Volume +", 0, HID_USAGE_CONSUMER_VOLUME_INCREMENT },
  { "Volume -", 0, HID_USAGE_CONSUMER_VOLUME_DECREMENT },
  { "Right arrow", 0x4F, 0 },
  { "Left arrow", 0x50, 0 },
};
const uint8_t CANDIDATE_COUNT = sizeof(CANDIDATES) / sizeof(CANDIDATES[0]);

const uint8_t PIN_SEND = D0;
const uint8_t PIN_NEXT = D1;
const uint8_t PIN_PREV = D2;
const uint8_t BUTTON_PINS[3] = { PIN_SEND, PIN_NEXT, PIN_PREV };
const uint32_t DEBOUNCE_MS = 30;
const uint32_t TAP_MS = 50;

BLEDis deviceInfo;
BLEHidAdafruit bleHid;

uint8_t selected = 0;
bool stableState[3] = { HIGH, HIGH, HIGH };
bool lastRead[3] = { HIGH, HIGH, HIGH };
uint32_t changedAt[3] = { 0, 0, 0 };

void led(uint8_t pin, bool on) {
  digitalWrite(pin, on ? LOW : HIGH);   // the XIAO's RGB LED is active low
}

void blinkSelection() {
  for (uint8_t i = 0; i <= selected; ++i) {
    led(LED_BLUE, true);
    delay(150);
    led(LED_BLUE, false);
    delay(250);
  }
}

void printSelection() {
  Serial.printf("Selected %u/%u: %s\n", selected + 1, CANDIDATE_COUNT,
                CANDIDATES[selected].name);
}

void sendSelected() {
  const Candidate &c = CANDIDATES[selected];
  if (!Bluefruit.connected()) {
    Serial.println("Not connected: nothing sent");
    return;
  }
  led(LED_GREEN, true);
  if (c.consumer) {
    bleHid.consumerKeyPress(c.consumer);
    delay(TAP_MS);
    bleHid.consumerKeyRelease();
    delay(TAP_MS);
  }
  if (c.key) {
    uint8_t keys[6] = { c.key, 0, 0, 0, 0, 0 };
    bleHid.keyboardReport(0, keys);
    delay(TAP_MS);
    bleHid.keyRelease();
  }
  led(LED_GREEN, false);
  Serial.printf("Sent %s\n", c.name);
}

void onPress(uint8_t button) {
  if (BUTTON_PINS[button] == PIN_SEND) {
    sendSelected();
    return;
  }
  if (BUTTON_PINS[button] == PIN_NEXT) selected = (selected + 1) % CANDIDATE_COUNT;
  else selected = (selected + CANDIDATE_COUNT - 1) % CANDIDATE_COUNT;
  printSelection();
  blinkSelection();
}

void setup() {
  pinMode(VBAT_ENABLE, OUTPUT);     // as in the main sketch: keep P0.31 within its limit
  digitalWrite(VBAT_ENABLE, LOW);

  const uint8_t ledPins[3] = { LED_RED, LED_GREEN, LED_BLUE };
  for (uint8_t pin : ledPins) {
    pinMode(pin, OUTPUT);
    led(pin, false);
  }
  for (uint8_t i = 0; i < 3; ++i) pinMode(BUTTON_PINS[i], INPUT_PULLUP);

  Serial.begin(115200);
  const uint32_t started = millis();
  while (!Serial && millis() - started < 2000) delay(10);
  Serial.println("Open Rally Remote key probe");

  Bluefruit.begin();
  Bluefruit.setTxPower(4);
  Bluefruit.setName("ORR Key Probe");
  deviceInfo.setManufacturer("Open Rally Remote Project");
  deviceInfo.setModel("Key probe");
  deviceInfo.begin();
  bleHid.begin();

  Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);
  Bluefruit.Advertising.addTxPower();
  Bluefruit.Advertising.addAppearance(BLE_APPEARANCE_HID_KEYBOARD);
  Bluefruit.Advertising.addService(bleHid);
  Bluefruit.ScanResponse.addName();
  Bluefruit.Advertising.restartOnDisconnect(true);
  Bluefruit.Advertising.setInterval(32, 244);
  Bluefruit.Advertising.setFastTimeout(30);
  Bluefruit.Advertising.start(0);

  printSelection();
  blinkSelection();
}

void loop() {
  const uint32_t now = millis();
  for (uint8_t i = 0; i < 3; ++i) {
    const bool reading = digitalRead(BUTTON_PINS[i]);
    if (reading != lastRead[i]) {
      lastRead[i] = reading;
      changedAt[i] = now;
    }
    if (reading != stableState[i] && now - changedAt[i] >= DEBOUNCE_MS) {
      stableState[i] = reading;
      if (reading == LOW) onPress(i);
    }
  }
  delay(5);
}
