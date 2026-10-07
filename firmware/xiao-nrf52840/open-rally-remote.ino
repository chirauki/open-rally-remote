/*
 * Open Rally Remote - XIAO nRF52840 bench firmware
 *
 * Purpose: read the eight temporary active-low switches and send diagnostic
 * keyboard events over BLE HID. This is a desk prototype, not riding firmware.
 *
 * Board package: Seeed nRF52 Boards
 * Board: Seeed XIAO nRF52840
 * BLE HID API: Adafruit Bluefruit nRF52 library bundled with the Seeed package
 */

#include <Adafruit_TinyUSB.h>
#include <bluefruit.h>

// ---------- Build options ----------

// Set false to build the joystick variant without a center switch.
constexpr bool CENTER_SWITCH_FITTED = true;

// Enable Serial Monitor diagnostics while developing.
constexpr bool SERIAL_DEBUG = true;

// ---------- Timing (initial prototype values) ----------

constexpr uint32_t DEBOUNCE_MS = 30;
constexpr uint32_t LONG_PRESS_MS = 600;
constexpr uint32_t DOUBLE_PRESS_MS = 300;
constexpr uint32_t TAP_HOLD_MS = 50;

// ---------- Hardware mapping ----------

enum ControlIndex : uint8_t {
  BUTTON_A = 0,
  BUTTON_B,
  BUTTON_C,
  JOYSTICK_UP,
  JOYSTICK_DOWN,
  JOYSTICK_LEFT,
  JOYSTICK_RIGHT,
  JOYSTICK_CENTER,
  CONTROL_COUNT
};

const uint8_t CONTROL_PINS[CONTROL_COUNT] = {
  D0, D1, D2, D3, D4, D5, D6, D7
};

const char *const CONTROL_NAMES[CONTROL_COUNT] = {
  "Button A", "Button B", "Button C", "Joystick up", "Joystick down",
  "Joystick left", "Joystick right", "Joystick center"
};

// Diagnostic-only key assignments:
// A: short/long/double = A/B/C
// B: short/long/double = D/E/F
// C: short/long/double = G/H/I
// Center: short/long/double = J/K/L
const uint8_t GESTURE_KEYS[4][3] = {
  { HID_KEY_A, HID_KEY_B, HID_KEY_C },
  { HID_KEY_D, HID_KEY_E, HID_KEY_F },
  { HID_KEY_G, HID_KEY_H, HID_KEY_I },
  { HID_KEY_J, HID_KEY_K, HID_KEY_L }
};

enum GestureType : uint8_t {
  GESTURE_SHORT = 0,
  GESTURE_LONG = 1,
  GESTURE_DOUBLE = 2
};

BLEDis deviceInfo;
BLEHidAdafruit bleHid;

struct DebouncedInput {
  uint8_t pin;
  bool rawPressed;
  bool stablePressed;
  uint32_t rawChangedAt;
};

struct GestureState {
  bool isDown;
  bool longSent;
  bool hasPendingShort;
  bool secondPressCandidate;
  uint32_t pressedAt;
  uint32_t pendingShortAt;
};

DebouncedInput inputs[CONTROL_COUNT];
GestureState gestures[CONTROL_COUNT] = {};

constexpr uint8_t TAP_QUEUE_SIZE = 16;
uint8_t tapQueue[TAP_QUEUE_SIZE];
uint8_t tapQueueHead = 0;
uint8_t tapQueueTail = 0;
uint8_t droppedTapCount = 0;

bool tapIsActive = false;
uint8_t activeTapKey = HID_KEY_NONE;
uint32_t activeTapStartedAt = 0;

bool previousBleConnected = false;
bool lastReportValid = false;
uint8_t lastReportKeys[6] = {};
bool ignoreUntilRelease[CONTROL_COUNT] = {};

bool centerInstalled() {
  return CENTER_SWITCH_FITTED;
}

bool controlIsInstalled(uint8_t control) {
  return control != JOYSTICK_CENTER || centerInstalled();
}

void printControlEvent(uint8_t control, const char *eventName) {
  if (!SERIAL_DEBUG) return;
  Serial.print(CONTROL_NAMES[control]);
  Serial.print(": ");
  Serial.println(eventName);
}

void resetGestureState() {
  for (uint8_t i = 0; i < CONTROL_COUNT; ++i) {
    gestures[i] = {};
  }
}

void clearTapQueue() {
  tapQueueHead = 0;
  tapQueueTail = 0;
  tapIsActive = false;
  activeTapKey = HID_KEY_NONE;
}

bool enqueueTap(uint8_t keyCode) {
  if (!Bluefruit.connected()) return false;

  const uint8_t nextTail = (tapQueueTail + 1) % TAP_QUEUE_SIZE;
  if (nextTail == tapQueueHead) {
    if (droppedTapCount < 255) ++droppedTapCount;
    return false;
  }

  tapQueue[tapQueueTail] = keyCode;
  tapQueueTail = nextTail;
  return true;
}

void addKey(uint8_t keys[6], uint8_t keyCode) {
  if (keyCode == HID_KEY_NONE) return;

  for (uint8_t i = 0; i < 6; ++i) {
    if (keys[i] == keyCode) return;
  }
  for (uint8_t i = 0; i < 6; ++i) {
    if (keys[i] == HID_KEY_NONE) {
      keys[i] = keyCode;
      return;
    }
  }
}

void buildCurrentReport(uint8_t keys[6]) {
  memset(keys, HID_KEY_NONE, 6);

  const bool up = inputs[JOYSTICK_UP].stablePressed;
  const bool down = inputs[JOYSTICK_DOWN].stablePressed;
  const bool left = inputs[JOYSTICK_LEFT].stablePressed;
  const bool right = inputs[JOYSTICK_RIGHT].stablePressed;

  // Opposing directions cancel; perpendicular directions may be held together.
  if (up && !down && !ignoreUntilRelease[JOYSTICK_UP]) addKey(keys, HID_KEY_ARROW_UP);
  if (down && !up && !ignoreUntilRelease[JOYSTICK_DOWN]) addKey(keys, HID_KEY_ARROW_DOWN);
  if (left && !right && !ignoreUntilRelease[JOYSTICK_LEFT]) addKey(keys, HID_KEY_ARROW_LEFT);
  if (right && !left && !ignoreUntilRelease[JOYSTICK_RIGHT]) addKey(keys, HID_KEY_ARROW_RIGHT);

  if (tapIsActive) addKey(keys, activeTapKey);
}

void publishReport() {
  if (!Bluefruit.connected()) return;

  uint8_t keys[6];
  buildCurrentReport(keys);

  if (lastReportValid && memcmp(keys, lastReportKeys, sizeof(keys)) == 0) {
    return;
  }

  if (bleHid.keyboardReport(0, keys)) {
    memcpy(lastReportKeys, keys, sizeof(keys));
    lastReportValid = true;
  }
}

void publishAllKeysReleased() {
  if (!Bluefruit.connected()) return;
  uint8_t releasedKeys[6] = {};
  if (bleHid.keyboardReport(0, releasedKeys)) {
    memset(lastReportKeys, HID_KEY_NONE, sizeof(lastReportKeys));
    lastReportValid = true;
  } else {
    lastReportValid = false;
  }
}

void emitGesture(uint8_t control, GestureType gesture) {
  uint8_t tableRow;
  if (control <= BUTTON_C) {
    tableRow = control;
  } else if (control == JOYSTICK_CENTER && centerInstalled()) {
    tableRow = 3;
  } else {
    return;
  }

  const uint8_t keyCode = GESTURE_KEYS[tableRow][gesture];
  if (enqueueTap(keyCode)) {
    if (SERIAL_DEBUG) {
      Serial.print(CONTROL_NAMES[control]);
      Serial.print(" gesture: ");
      Serial.print(gesture == GESTURE_SHORT ? "short" :
                   gesture == GESTURE_LONG ? "long" : "double");
      Serial.print(" -> HID key ");
      Serial.println((char)('A' + keyCode - HID_KEY_A));
    }
  }
}

void startGesture(uint8_t control, uint32_t now) {
  GestureState &state = gestures[control];
  if (state.hasPendingShort &&
      (uint32_t)(now - state.pendingShortAt) >= DOUBLE_PRESS_MS) {
    state.hasPendingShort = false;
    emitGesture(control, GESTURE_SHORT);
  }
  state.isDown = true;
  state.longSent = false;
  state.pressedAt = now;
  state.secondPressCandidate = state.hasPendingShort &&
      (uint32_t)(now - state.pendingShortAt) < DOUBLE_PRESS_MS;
  printControlEvent(control, "pressed");
}

void finishGesture(uint8_t control, uint32_t now) {
  GestureState &state = gestures[control];
  state.isDown = false;
  printControlEvent(control, "released");

  if (state.longSent) {
    state.secondPressCandidate = false;
    return;
  }

  if (state.secondPressCandidate) {
    state.hasPendingShort = false;
    state.secondPressCandidate = false;
    emitGesture(control, GESTURE_DOUBLE);
    return;
  }

  state.hasPendingShort = true;
  state.pendingShortAt = now;
}

void handleStableTransition(uint8_t control, bool pressed, uint32_t now) {
  if (!controlIsInstalled(control)) return;

  if (ignoreUntilRelease[control]) {
    if (!pressed) ignoreUntilRelease[control] = false;
    printControlEvent(control, "input synchronized; event ignored until released");
    return;
  }

  if (control <= BUTTON_C || control == JOYSTICK_CENTER) {
    if (pressed) startGesture(control, now);
    else finishGesture(control, now);
    return;
  }

  // The current diagnostic profile maps joystick directions to held arrow keys.
  (void)pressed;
  publishReport();
  printControlEvent(control, pressed ? "direction held" : "direction released");
}

void synchronizeInputs(uint32_t now) {
  for (uint8_t i = 0; i < CONTROL_COUNT; ++i) {
    if (!controlIsInstalled(i)) continue;
    const bool pressed = digitalRead(inputs[i].pin) == LOW;
    inputs[i].rawPressed = pressed;
    inputs[i].stablePressed = pressed;
    inputs[i].rawChangedAt = now;
    ignoreUntilRelease[i] = pressed;
  }
  resetGestureState();
}

void scanInputs(uint32_t now) {
  for (uint8_t i = 0; i < CONTROL_COUNT; ++i) {
    if (!controlIsInstalled(i)) continue;

    const bool rawPressed = digitalRead(inputs[i].pin) == LOW;
    if (rawPressed != inputs[i].rawPressed) {
      inputs[i].rawPressed = rawPressed;
      inputs[i].rawChangedAt = now;
    }

    if (inputs[i].stablePressed != inputs[i].rawPressed &&
        (uint32_t)(now - inputs[i].rawChangedAt) >= DEBOUNCE_MS) {
      inputs[i].stablePressed = inputs[i].rawPressed;
      handleStableTransition(i, inputs[i].stablePressed, now);
    }
  }
}

void processGestureTimers(uint32_t now) {
  if (!Bluefruit.connected()) return;

  for (uint8_t i = 0; i < CONTROL_COUNT; ++i) {
    if (!controlIsInstalled(i)) continue;
    GestureState &state = gestures[i];

    if (state.isDown && !state.longSent &&
        (uint32_t)(now - state.pressedAt) >= LONG_PRESS_MS) {
      state.longSent = true;
      state.secondPressCandidate = false;
      state.hasPendingShort = false;
      emitGesture(i, GESTURE_LONG);
    }

    if (!state.isDown && state.hasPendingShort &&
        (uint32_t)(now - state.pendingShortAt) >= DOUBLE_PRESS_MS) {
      state.hasPendingShort = false;
      emitGesture(i, GESTURE_SHORT);
    }
  }
}

void processTapQueue(uint32_t now) {
  if (!Bluefruit.connected()) {
    clearTapQueue();
    return;
  }

  if (tapIsActive && (uint32_t)(now - activeTapStartedAt) >= TAP_HOLD_MS) {
    tapIsActive = false;
    activeTapKey = HID_KEY_NONE;
    publishReport(); // send the key-up report
    return;           // leave a report interval before starting the next tap
  }

  if (!tapIsActive && tapQueueHead != tapQueueTail) {
    activeTapKey = tapQueue[tapQueueHead];
    tapQueueHead = (tapQueueHead + 1) % TAP_QUEUE_SIZE;
    tapIsActive = true;
    activeTapStartedAt = now;
    publishReport(); // send the key-down report
  }
}

void beginBleKeyboard() {
  Bluefruit.begin();
  Bluefruit.setTxPower(4);
  Bluefruit.setName("Open Rally Remote");

  deviceInfo.setManufacturer("Open Rally Remote Project");
  deviceInfo.setModel("XIAO nRF52840 Bench Prototype");
  deviceInfo.setSoftwareRev("0.1.0-diagnostic");
  deviceInfo.begin();

  bleHid.begin();

  Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);
  Bluefruit.Advertising.addTxPower();
  Bluefruit.Advertising.addAppearance(BLE_APPEARANCE_HID_KEYBOARD);
  Bluefruit.Advertising.addService(bleHid);
  Bluefruit.Advertising.addName();
  Bluefruit.Advertising.restartOnDisconnect(true);
  Bluefruit.Advertising.setInterval(32, 244);
  Bluefruit.Advertising.setFastTimeout(30);
  Bluefruit.Advertising.start(0);
}

void setup() {
  if (SERIAL_DEBUG) {
    Serial.begin(115200);
    const uint32_t serialWaitStarted = millis();
    while (!Serial && (uint32_t)(millis() - serialWaitStarted) < 2000) {
      delay(10);
    }
    Serial.println("Open Rally Remote diagnostic firmware 0.1.0");
    Serial.println("Released switch = HIGH; pressed switch = LOW");
  }

  for (uint8_t i = 0; i < CONTROL_COUNT; ++i) {
    inputs[i].pin = CONTROL_PINS[i];
    if (!controlIsInstalled(i)) continue;
    pinMode(inputs[i].pin, INPUT_PULLUP);
  }

  synchronizeInputs(millis());
  beginBleKeyboard();

  if (SERIAL_DEBUG) {
    Serial.println("BLE advertising as: Open Rally Remote");
    Serial.println("Diagnostic letters: A-C = Button A, D-F = Button B,");
    Serial.println("G-I = Button C, arrows = joystick, J-L = center switch.");
  }
}

void loop() {
  const uint32_t now = millis();
  const bool connected = Bluefruit.connected();

  if (connected != previousBleConnected) {
    previousBleConnected = connected;
    clearTapQueue();
    synchronizeInputs(now); // do not turn a held control into a reconnect event
    lastReportValid = false;
    if (connected) {
      publishAllKeysReleased(); // held controls are ignored until released
      if (SERIAL_DEBUG) Serial.println("BLE HID host connected");
    } else if (SERIAL_DEBUG) {
      Serial.println("BLE HID host disconnected");
    }
  }

  scanInputs(now);
  processGestureTimers(now);
  processTapQueue(now);

  if (droppedTapCount && SERIAL_DEBUG) {
    Serial.print("Warning: diagnostic tap queue overflow count = ");
    Serial.println(droppedTapCount);
    droppedTapCount = 0;
  }

  delay(5);
}
