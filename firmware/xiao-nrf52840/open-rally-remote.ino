/*
 * Open Rally Remote - XIAO nRF52840 bench firmware
 *
 * Purpose: read the active-low switches (three buttons, four joystick
 * directions) and send keyboard keys over BLE HID, in a TerraPirata,
 * keyboard (held keys) or gestures profile. The joystick center press is the
 * chord of three or more directions.
 * This is a desk prototype, not riding firmware.
 *
 * Board package: Seeed nRF52 Boards
 * Board: Seeed XIAO nRF52840
 * BLE HID API: Adafruit Bluefruit nRF52 library bundled with the Seeed package
 * BLE OTA: the legacy DFU service, only from a bonded phone with USB power,
 * and new bonds only in the first PAIRING_WINDOW_MS; see README.md, "BLE OTA update"
 */

#include <Adafruit_TinyUSB.h>
#include <bluefruit.h>
#include <Adafruit_LittleFS.h>
#include <InternalFileSystem.h>
#include "orr_dfu.h"

using namespace Adafruit_LittleFS_Namespace;

// ---------- Build options ----------

// Board. false: the XIAO on its own, as on the breadboard and in V0.25 (its
// charger, BAT pads and P0.31 divider). true: the V0.26 control board
// (electronics/control-pcb), which has its own charger and feeds the XIAO's
// 3V3 pin; buttons on D1-D3, joystick on D4-D7, battery on A0, charger
// status on D8 and VBUS on D9.
constexpr bool BOARD_V026 = false;

// Enable Serial Monitor diagnostics while developing.
constexpr bool SERIAL_DEBUG = true;

// ---------- Timing (initial prototype values) ----------

constexpr uint32_t DEBOUNCE_MS = 30;
constexpr uint32_t LONG_PRESS_MS = 600;
// TerraPirata's long presses reset a trip: longer, so a bump or a glove does
// not reset one by accident.
constexpr uint32_t RESET_LONG_PRESS_MS = 2000;
constexpr uint32_t DOUBLE_PRESS_MS = 300;
constexpr uint32_t TAP_HOLD_MS = 50;
// Direction key-down is held back this long after the first direction closes,
// so a straight push is reported as the center and not as a direction.
constexpr uint32_t CHORD_WINDOW_MS = 40;

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

// The joystick has no centre switch: the centre is the chord of three or
// more directions, so its entry is a placeholder, never read.
constexpr uint8_t NO_PIN = 0xFF;
const uint8_t CONTROL_PINS[CONTROL_COUNT] = {
  BOARD_V026 ? D1 : D0, BOARD_V026 ? D2 : D1, BOARD_V026 ? D3 : D2,
  BOARD_V026 ? D4 : D3, BOARD_V026 ? D5 : D4, BOARD_V026 ? D6 : D5, BOARD_V026 ? D7 : D6,
  NO_PIN
};

const char *const CONTROL_NAMES[CONTROL_COUNT] = {
  "Button A", "Button B", "Button C", "Joystick up", "Joystick down",
  "Joystick left", "Joystick right", "Joystick center"
};

// A key is a keyboard key code, or a consumer-control usage (media keys)
// marked with CONSUMER. No profile sends media keys since 0.9.0: they reach
// whichever app is in front.
constexpr uint16_t CONSUMER = 0x8000;

// ---------- Profiles (see docs/control-mapping.md) ----------
//
// The joystick directions send held arrow keys in every profile. Holding the
// joystick center for PROFILE_SWITCH_MS and releasing it enters profile
// selection: the release of a lone button then chooses A TerraPirata, B
// keyboard or C gestures, saves it and restarts the board (no restart for
// the current profile). Selection ends with no change after
// PROFILE_SELECT_MS, on two buttons, or on a disconnect, and sends no key. The LED shows the profile with a short blink every
// PROFILE_BLINK_PERIOD_MS: green for TerraPirata, blue for keyboard, white
// for gestures. The BLE name stays the same: Android keeps the name it saw
// when pairing.
enum Profile : uint8_t {
  PROFILE_TERRAPIRATA = 0,
  PROFILE_KEYBOARD = 1,
  PROFILE_GESTURES = 2,
  PROFILE_COUNT
};

const char *const PROFILE_NAMES[PROFILE_COUNT] = {
  "TerraPirata", "keyboard", "gestures"
};

constexpr uint8_t LED_R = 1, LED_G = 2, LED_B = 4;
const uint8_t LED_PINS[3] = { LED_RED, LED_GREEN, LED_BLUE };
const uint8_t PROFILE_LEDS[PROFILE_COUNT] = { LED_G, LED_B, LED_R | LED_G | LED_B };

// In the keyboard profile, Buttons A, B and C hold one key each for as long
// as they are pressed, with no gestures: DMD2 times long presses and repeats
// itself. Letters, for apps that let the user assign keys.
// Space, Enter and Tab are avoided in every profile: Android uses them to
// press the focused on-screen control.
const uint16_t HOLD_KEYS[3] = { HID_KEY_A, HID_KEY_B, HID_KEY_C };

// Button gestures, one tap per gesture. Rows: Button A, B, C. Columns:
// short, long, double.
// TerraPirata (keys found with firmware/key-probe, 2026-10-20): A long `r`
// opens the trip reset (confirm on screen), B long `z` resets the total
// trip, C `x` locks or unlocks the screen. The trip is on the joystick.
// Gestures, for OsmAnd: its default "Keyboard" keys. A: D map orientation, N
// navigation view, P next app profile. B: - zoom out, S search. C: = zoom
// in, x screen lock (the one key to assign in OsmAnd, to "Touch screen
// lock"; the same key as in TerraPirata). B and C have no double press, so
// their zoom goes out on release.
const uint16_t BUTTON_GESTURE_KEYS[PROFILE_COUNT][3][3] = {
  { { HID_KEY_NONE, HID_KEY_R, HID_KEY_NONE },
    { HID_KEY_NONE, HID_KEY_Z, HID_KEY_NONE },
    { HID_KEY_X, HID_KEY_NONE, HID_KEY_NONE } },
  {}, // keyboard: held, see HOLD_KEYS
  { { HID_KEY_D, HID_KEY_N, HID_KEY_P },
    { HID_KEY_MINUS, HID_KEY_S, HID_KEY_NONE },
    { HID_KEY_EQUAL, HID_KEY_X, HID_KEY_NONE } }
};

// The joystick center has no long action: a 5 s hold enters profile selection.
// Columns: short, long, double.
const uint16_t CENTER_KEYS[PROFILE_COUNT][3] = {
  { HID_KEY_NONE, HID_KEY_NONE, HID_KEY_NONE },
  { HID_KEY_D, HID_KEY_NONE, HID_KEY_D },
  { HID_KEY_C, HID_KEY_NONE, HID_KEY_NONE } // OsmAnd: move to my position
};

constexpr uint32_t PROFILE_SWITCH_MS = 5000;
constexpr uint32_t PROFILE_SELECT_MS = 5000;  // to choose, from the center release
const Profile SELECT_PROFILES[3] = { PROFILE_TERRAPIRATA, PROFILE_KEYBOARD, PROFILE_GESTURES };
constexpr uint32_t PROFILE_BLINK_PERIOD_MS = 10000;
constexpr uint32_t PROFILE_BLINK_MS = 100;

// ---------- Power and battery (see docs/battery-study.md#firmware) ----------

// Bench option: let power-off and auto-off sleep while USB powers the board.
// With false, the board stays awake while a charger or computer is connected.
constexpr bool SLEEP_ON_USB = false;

constexpr uint32_t PAIRING_WINDOW_MS = 120000;     // new bonds accepted after a start
constexpr uint32_t POWER_OFF_HOLD_MS = 3000;          // A + B + C held
constexpr uint32_t AUTO_OFF_MS = 6UL * 60 * 60 * 1000; // no input, no charger
constexpr uint32_t BATTERY_READ_PERIOD_MS = 60000;
constexpr uint16_t BATTERY_LOW_MV = 3500;   // LED blinks red instead
constexpr uint16_t BATTERY_EMPTY_MV = 3300; // System OFF, ahead of the PCM

// Battery divider. XIAO: BAT to P0.31, 1 MOhm over 510 kOhm (Seeed XIAO
// nRF52840 v1.1 schematic). V0.26: BAT_SYS to A0, 1 MOhm over 1 MOhm.
// Calibrate against a multimeter on the cell.
constexpr float VBAT_DIVIDER = BOARD_V026 ? 2.0f : (1000.0f + 510.0f) / 510.0f;
constexpr uint8_t PIN_BATTERY = BOARD_V026 ? A0 : PIN_VBAT;

// Charge current: false = about 50 mA (P0.13 high impedance), true = about
// 100 mA (P0.13 low). Choose after checking the cell's maximum charge rate.
constexpr bool HIGH_CHARGE_CURRENT = false;

// XIAO charger (BOARD_V026 false).
constexpr uint8_t PIN_CHG = 23;        // P0.17, BQ25101 CHG, low while charging
constexpr uint8_t PIN_CHARGE_LED = D8; // charge LED on the V0.24/V0.25 USB-C PCB
// V0.26 control board (BOARD_V026 true). The charger's STAT drives the charge
// LED itself; D8 sees STAT through a divider: low while charging, high when done.
constexpr uint8_t PIN_CHG_SENSE = D8;
constexpr uint8_t PIN_VBUS_SENSE = D9;   // VBUS through a divider

const char *const FIRMWARE_VERSION = "0.12.0";

enum GestureType : uint8_t {
  GESTURE_SHORT = 0,
  GESTURE_LONG = 1,
  GESTURE_DOUBLE = 2
};

OrrDfu bleDfu;
BLEDis deviceInfo;
BLEHidAdafruit bleHid;
BLEBas batteryService;

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
uint16_t tapQueue[TAP_QUEUE_SIZE];
uint8_t tapQueueHead = 0;
uint8_t tapQueueTail = 0;
uint8_t droppedTapCount = 0;

bool tapIsActive = false;
uint16_t activeTapKey = HID_KEY_NONE;
uint32_t activeTapStartedAt = 0;

bool previousBleConnected = false;
bool lastReportValid = false;
uint8_t lastReportKeys[6] = {};
bool ignoreUntilRelease[CONTROL_COUNT] = {};
bool buttonHeld[3] = {};

Profile profile = PROFILE_TERRAPIRATA;

// Profile selection (see PROFILE_SELECT_MS).
bool profileSelecting = false;
uint32_t profileSelectSince = 0;
int8_t selectCandidate = -1;  // the lone button pressed, chosen on its release

// Power state.
uint32_t lastInputAt = 0;
bool comboActive = false;     // two or more of A, B, C held: no button keys
uint32_t allButtonsSince = 0; // when A, B and C were all closed, or 0
bool powerOffArmed = false;   // sleep once all three are released
uint16_t batteryMv = 0;
uint32_t batteryReadAt = 0;
bool batteryLow = false;

// Joystick direction handling (see docs/firmware-spec.md, section 5).
enum JoystickMode : uint8_t {
  JOY_IDLE,        // no direction closed
  JOY_PENDING,     // a direction closed; waiting out the chord window
  JOY_DIRECTIONS,  // reporting the held directions
  JOY_SUPPRESSED,  // opposite directions closed: no keys until a chord or release
  JOY_CENTER,      // chord: center held, no direction keys until all released
  JOY_BLOCKED      // held at (re)connect: ignored until all released
};

JoystickMode joyMode = JOY_IDLE;
uint32_t joyPendingSince = 0;
uint8_t joySeenMask = 0;

// Bits: up = 1, down = 2, left = 4, right = 8.
constexpr uint8_t DIR_VERTICAL = 0x3;
constexpr uint8_t DIR_HORIZONTAL = 0xC;
const uint8_t DIRECTION_KEYS[4] = {
  HID_KEY_ARROW_UP, HID_KEY_ARROW_DOWN, HID_KEY_ARROW_LEFT, HID_KEY_ARROW_RIGHT
};

// The first function definition: the Arduino builder puts its generated
// prototypes here, so every type they use must be declared above.
bool buttonsHold(Profile value) { return value == PROFILE_KEYBOARD; }

// A physical input on its pin; the center has none (it is the chord).
bool controlIsInstalled(uint8_t control) {
  return control != JOYSTICK_CENTER;
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

bool enqueueTap(uint16_t keyCode) {
  if (!Bluefruit.connected() || profileSelecting) return false;

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

uint8_t directionMask() {
  uint8_t mask = 0;
  for (uint8_t i = 0; i < 4; ++i) {
    if (inputs[JOYSTICK_UP + i].stablePressed) mask |= 1 << i;
  }
  return mask;
}

// Opposing directions cancel; perpendicular directions may be held together.
uint8_t cancelOpposites(uint8_t mask) {
  if ((mask & DIR_VERTICAL) == DIR_VERTICAL) mask &= ~DIR_VERTICAL;
  if ((mask & DIR_HORIZONTAL) == DIR_HORIZONTAL) mask &= ~DIR_HORIZONTAL;
  return mask;
}

void buildCurrentReport(uint8_t keys[6]) {
  memset(keys, HID_KEY_NONE, 6);
  if (profileSelecting) return;

  if (joyMode == JOY_DIRECTIONS) {
    const uint8_t mask = cancelOpposites(directionMask());
    for (uint8_t i = 0; i < 4; ++i) {
      if (mask & (1 << i)) addKey(keys, DIRECTION_KEYS[i]);
    }
  }

  for (uint8_t i = 0; i < 3; ++i) {
    if (buttonHeld[i]) addKey(keys, (uint8_t)HOLD_KEYS[i]);
  }

  if (tapIsActive && !(activeTapKey & CONSUMER)) {
    addKey(keys, (uint8_t)activeTapKey);
  }
}

// Consumer-control taps use their own report, not the keyboard report.
void publishConsumerTap(bool pressed) {
  if (!Bluefruit.connected()) return;
  if (pressed) {
    bleHid.consumerKeyPress(activeTapKey & ~CONSUMER);
  } else {
    bleHid.consumerKeyRelease();
  }
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
  bleHid.consumerKeyRelease();
  if (bleHid.keyboardReport(0, releasedKeys)) {
    memset(lastReportKeys, HID_KEY_NONE, sizeof(lastReportKeys));
    lastReportValid = true;
  } else {
    lastReportValid = false;
  }
}

uint16_t gestureKey(uint8_t control, GestureType gesture) {
  if (control <= BUTTON_C) {
    if (buttonsHold(profile)) return HID_KEY_NONE; // see holdButton
    return BUTTON_GESTURE_KEYS[profile][control][gesture];
  }
  if (control == JOYSTICK_CENTER) return CENTER_KEYS[profile][gesture];
  return HID_KEY_NONE;
}

uint32_t longPressMs(uint8_t control) {
  return profile == PROFILE_TERRAPIRATA && control <= BUTTON_C ? RESET_LONG_PRESS_MS
                                                              : LONG_PRESS_MS;
}

void emitGesture(uint8_t control, GestureType gesture) {
  const uint16_t keyCode = gestureKey(control, gesture);
  if (keyCode == HID_KEY_NONE) return;
  if (enqueueTap(keyCode)) {
    if (SERIAL_DEBUG) {
      Serial.print(CONTROL_NAMES[control]);
      Serial.print(" gesture: ");
      Serial.print(gesture == GESTURE_SHORT ? "short" :
                   gesture == GESTURE_LONG ? "long" : "double");
      Serial.printf(" -> %s 0x%02X\n",
                    (keyCode & CONSUMER) ? "consumer usage" : "HID key",
                    keyCode & ~CONSUMER);
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

void beginProfileSelection(uint32_t now);

void finishGesture(uint8_t control, uint32_t now) {
  GestureState &state = gestures[control];
  state.isDown = false;
  printControlEvent(control, "released");

  if (control == JOYSTICK_CENTER && (uint32_t)(now - state.pressedAt) >= PROFILE_SWITCH_MS) {
    state = {};
    beginProfileSelection(now);
    return;
  }

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

  // No double press to wait for: send the short press now.
  if (gestureKey(control, GESTURE_DOUBLE) == HID_KEY_NONE) {
    emitGesture(control, GESTURE_SHORT);
    return;
  }

  state.hasPendingShort = true;
  state.pendingShortAt = now;
}

void holdButton(uint8_t control, bool pressed);
bool handleButtonCombo(uint32_t now);
bool handleProfileSelection(uint8_t control, bool pressed);
void enterSystemOff(const char *reason);

void handleStableTransition(uint8_t control, bool pressed, uint32_t now) {
  if (!controlIsInstalled(control)) return;

  if (ignoreUntilRelease[control]) {
    if (!pressed) ignoreUntilRelease[control] = false;
    printControlEvent(control, "input synchronized; event ignored until released");
    return;
  }

  lastInputAt = now;

  if (control <= BUTTON_C && handleProfileSelection(control, pressed)) return;
  if (control <= BUTTON_C && handleButtonCombo(now)) return;

  if (control <= BUTTON_C && buttonsHold(profile)) {
    holdButton(control, pressed);
    return;
  }

  if (control <= BUTTON_C || control == JOYSTICK_CENTER) {
    if (pressed) startGesture(control, now);
    else finishGesture(control, now);
    return;
  }

  // Directions are reported by updateJoystick().
  printControlEvent(control, pressed ? "direction closed" : "direction opened");
}

// Hold mode: the key goes down and up with the button.
void holdButton(uint8_t control, bool pressed) {
  printControlEvent(control, pressed ? "held" : "let go");
  buttonHeld[control] = pressed && Bluefruit.connected();
  publishReport();
}

void pressChordCenter(uint32_t now) {
  joyMode = JOY_CENTER;
  startGesture(JOYSTICK_CENTER, now);
}

// Turns the debounced direction switches into held arrow keys or, in chord
// mode, the center press. Runs every loop so the chord window can expire.
void updateJoystick(uint32_t now) {
  const uint8_t mask = directionMask();
  const uint8_t count = __builtin_popcount(mask);
  const bool opposite = mask != cancelOpposites(mask);

  switch (joyMode) {
    case JOY_IDLE:
      if (!mask) break;
      joyMode = JOY_PENDING;
      joyPendingSince = now;
      joySeenMask = 0;
      [[fallthrough]];

    case JOY_PENDING:
      joySeenMask |= mask;
      if (count >= 3) {
        pressChordCenter(now);
      } else if (!mask) {
        // Released inside the window: send the tilt as a tap so it is not lost.
        const uint8_t tapped = cancelOpposites(joySeenMask);
        for (uint8_t i = 0; i < 4; ++i) {
          if (tapped & (1 << i)) enqueueTap(DIRECTION_KEYS[i]);
        }
        joyMode = JOY_IDLE;
      } else if ((uint32_t)(now - joyPendingSince) >= CHORD_WINDOW_MS) {
        joyMode = opposite ? JOY_SUPPRESSED : JOY_DIRECTIONS;
      }
      break;

    case JOY_DIRECTIONS:
      if (!mask) {
        joyMode = JOY_IDLE;
      } else if (count >= 3) {
        // A slow push: direction keys already sent are released here.
        pressChordCenter(now);
      } else if (opposite) {
        joyMode = JOY_SUPPRESSED;
      }
      break;

    case JOY_SUPPRESSED:
      if (count >= 3) pressChordCenter(now);
      else if (!mask) joyMode = JOY_IDLE;
      break;

    case JOY_CENTER:
      if (!mask) {
        finishGesture(JOYSTICK_CENTER, now);
        joyMode = JOY_IDLE;
      }
      break;

    case JOY_BLOCKED:
      if (!mask) joyMode = JOY_IDLE;
      break;
  }

  publishReport();
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
  joyMode = directionMask() ? JOY_BLOCKED : JOY_IDLE;
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

  // Directions never start a gesture; the chord center has no pin but does.
  for (uint8_t i = 0; i < CONTROL_COUNT; ++i) {
    GestureState &state = gestures[i];

    if (state.isDown && !state.longSent &&
        (uint32_t)(now - state.pressedAt) >= longPressMs(i)) {
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
    const bool consumer = activeTapKey & CONSUMER;
    if (consumer) publishConsumerTap(false);
    tapIsActive = false;
    activeTapKey = HID_KEY_NONE;
    if (!consumer) publishReport(); // send the key-up report
    return; // leave a report interval before starting the next tap
  }

  if (!tapIsActive && tapQueueHead != tapQueueTail) {
    activeTapKey = tapQueue[tapQueueHead];
    tapQueueHead = (tapQueueHead + 1) % TAP_QUEUE_SIZE;
    tapIsActive = true;
    activeTapStartedAt = now;
    if (activeTapKey & CONSUMER) {
      publishConsumerTap(true);
    } else {
      publishReport(); // send the key-down report
    }
  }
}

// ---------- Power off, battery and charging ----------

uint8_t pressedButtonCount() {
  uint8_t count = 0;
  for (uint8_t i = BUTTON_A; i <= BUTTON_C; ++i) {
    if (inputs[i].stablePressed) ++count;
  }
  return count;
}

// Two or more of A, B and C held together are the power-off combination, not
// keys. The first button's key is already down when the second closes; it is
// released here. Returns true while button events must be ignored.
bool handleButtonCombo(uint32_t now) {
  const uint8_t count = pressedButtonCount();

  if (!comboActive && count >= 2) {
    comboActive = true;
    for (uint8_t i = BUTTON_A; i <= BUTTON_C; ++i) {
      if (buttonHeld[i]) holdButton(i, false);
      gestures[i] = {};
    }
    printControlEvent(BUTTON_A, "button combination: keys suppressed");
  }
  if (!comboActive) return false;

  allButtonsSince = count == 3 ? (allButtonsSince ? allButtonsSince : now) : 0;

  if (count == 0) {
    comboActive = false;
    if (powerOffArmed) enterSystemOff("power-off combination");
  }
  return true;
}

// A charger or computer on the charging port. On the V0.26 board the charging
// port is not the XIAO's USB-C, so its VBUS comes in on D9.
bool usbPowered() {
  if (BOARD_V026) return digitalRead(PIN_VBUS_SENSE) == HIGH;
  uint32_t status = 0;
  sd_power_usbregstatus_get(&status);
  return status & POWER_USBREGSTATUS_VBUSDETECT_Msk;
}

bool charging() {
  return usbPowered() && digitalRead(BOARD_V026 ? PIN_CHG_SENSE : PIN_CHG) == LOW;
}

bool mayDecideToSleep() { return SLEEP_ON_USB || !usbPowered(); }

// XIAO charger: P0.14 must stay low. The Seeed core drives it high at start,
// and with it high P0.31 can reach its 3.6 V limit while the cell charges.
// On the V0.26 board no cell reaches the XIAO's BAT pads, and P0.14 stays as
// the core leaves it.
void beginBattery() {
  if (BOARD_V026) {
    pinMode(PIN_CHG_SENSE, INPUT);
    pinMode(PIN_VBUS_SENSE, INPUT);
  } else {
    pinMode(VBAT_ENABLE, OUTPUT);
    digitalWrite(VBAT_ENABLE, LOW);
    if (HIGH_CHARGE_CURRENT) {
      pinMode(PIN_CHARGING_CURRENT, OUTPUT);
      digitalWrite(PIN_CHARGING_CURRENT, LOW);
    }
    pinMode(PIN_CHG, INPUT);
    pinMode(PIN_CHARGE_LED, OUTPUT);
    digitalWrite(PIN_CHARGE_LED, LOW);
  }
  analogReference(AR_INTERNAL); // 0 to 3.6 V
  analogReadResolution(12);
  analogSampleTime(40);         // the divider is a high-impedance source
}

uint16_t readBatteryMv() {
  uint32_t sum = 0;
  for (uint8_t i = 0; i < 8; ++i) sum += analogRead(PIN_BATTERY);
  return (uint16_t)(sum / 8.0f * 3600.0f / 4096.0f * VBAT_DIVIDER);
}

// Rough LiPo state of charge at rest; good enough for a level indication.
uint8_t batteryPercent(uint16_t mv) {
  static const uint16_t MV[] = { 3300, 3500, 3600, 3700, 3800, 3900, 4000, 4100, 4200 };
  static const uint8_t PCT[] = { 0, 5, 15, 30, 50, 65, 78, 90, 100 };
  if (mv <= MV[0]) return 0;
  for (uint8_t i = 1; i < 9; ++i) {
    if (mv <= MV[i]) {
      return PCT[i - 1] + (PCT[i] - PCT[i - 1]) * (mv - MV[i - 1]) / (MV[i] - MV[i - 1]);
    }
  }
  return 100;
}

void updateBattery(uint32_t now) {
  if (batteryReadAt && (uint32_t)(now - batteryReadAt) < BATTERY_READ_PERIOD_MS) return;
  batteryReadAt = now ? now : 1;
  batteryMv = readBatteryMv();
  batteryLow = batteryMv < BATTERY_LOW_MV;
  batteryService.write(batteryPercent(batteryMv));
  if (SERIAL_DEBUG) {
    Serial.printf("Battery: %u mV, %u %%, USB %s, CHG %s\n", batteryMv,
                  batteryPercent(batteryMv), usbPowered() ? "yes" : "no",
                  charging() ? "charging" : "not charging");
  }
  if (batteryMv < BATTERY_EMPTY_MV && mayDecideToSleep()) {
    enterSystemOff("battery empty");
  }
}

// XIAO charger: the charge LED is on only while a charger is connected and
// CHG shows charging. On the V0.26 board the charger drives it.
void updateChargeLed() {
  if (BOARD_V026) return;
  digitalWrite(PIN_CHARGE_LED, charging() ? HIGH : LOW);
}

void checkPowerOff(uint32_t now) {
  if (allButtonsSince && !powerOffArmed &&
      (uint32_t)(now - allButtonsSince) >= POWER_OFF_HOLD_MS) {
    powerOffArmed = true;
    if (SERIAL_DEBUG) Serial.println("Power off armed: release A, B and C");
  }
  if ((uint32_t)(now - lastInputAt) >= AUTO_OFF_MS && mayDecideToSleep()) {
    enterSystemOff("auto-off");
  }
}

// System OFF. Any released switch wakes the board, which then restarts;
// switches still closed are not armed, so a stuck one cannot wake it at
// once. A charger connection (VBUS) also wakes it.
void enterSystemOff(const char *reason) {
  if (SERIAL_DEBUG) {
    Serial.printf("System OFF: %s\n", reason);
    Serial.flush();
  }
  publishAllKeysReleased();
  for (uint8_t i = 0; i < 3; ++i) digitalWrite(LED_PINS[i], HIGH);
  if (BOARD_V026) {
    // The XIAO's USB VBUS detection does not see the charging port: wake on D9.
    if (!usbPowered()) {
      nrf_gpio_cfg_sense_input(g_ADigitalPinMap[PIN_VBUS_SENSE], NRF_GPIO_PIN_NOPULL, NRF_GPIO_PIN_SENSE_HIGH);
    }
  } else {
    digitalWrite(PIN_CHARGE_LED, LOW);
  }
  for (uint8_t i = 0; i < CONTROL_COUNT; ++i) {
    if (!controlIsInstalled(i) || inputs[i].stablePressed) continue;
    nrf_gpio_cfg_sense_input(g_ADigitalPinMap[inputs[i].pin],
                             NRF_GPIO_PIN_PULLUP, NRF_GPIO_PIN_SENSE_LOW);
  }
  delay(100);
  sd_power_system_off();
  while (true) {}
}

// ---------- Profile storage ----------

const char *const PROFILE_FILE = "/profile";

void loadProfile() {
  InternalFS.begin();
  File file(InternalFS);
  uint8_t stored = PROFILE_TERRAPIRATA;
  if (file.open(PROFILE_FILE, FILE_O_READ)) {
    file.read(&stored, 1);
    file.close();
  }
  profile = stored < PROFILE_COUNT ? (Profile)stored : PROFILE_TERRAPIRATA;
}

void saveProfile(Profile value) {
  InternalFS.remove(PROFILE_FILE);
  File file(InternalFS);
  if (file.open(PROFILE_FILE, FILE_O_WRITE)) {
    const uint8_t stored = value;
    file.write(&stored, 1);
    file.close();
  }
}

// The XIAO's RGB LED is active low. Called every loop.
// Red instead of the profile color: battery low, or power off armed (steady).
void showProfile(uint32_t now) {
  bool on = now % PROFILE_BLINK_PERIOD_MS < PROFILE_BLINK_MS;
  uint8_t leds = PROFILE_LEDS[profile];
  if (batteryLow) leds = LED_R;
  if (powerOffArmed) {
    leds = LED_R;
    on = true;
  }
  for (uint8_t i = 0; i < 3; ++i) {
    digitalWrite(LED_PINS[i], on && (leds & (1 << i)) ? LOW : HIGH);
  }
}

void beginProfileSelection(uint32_t now) {
  profileSelecting = true;
  profileSelectSince = now;
  selectCandidate = -1;
  // A button held now (a held key in the keyboard profile) is let go and
  // ignored until released, so it cannot come back down when selection ends.
  for (uint8_t i = BUTTON_A; i <= BUTTON_C; ++i) {
    buttonHeld[i] = false;
    gestures[i] = {};
    if (inputs[i].stablePressed) ignoreUntilRelease[i] = true;
  }
  clearTapQueue();
  publishReport(); // no keys while selecting
  if (SERIAL_DEBUG) Serial.println("Profile selection: A TerraPirata, B keyboard, C gestures");
}

void endProfileSelection() {
  if (!profileSelecting) return;
  if (SERIAL_DEBUG) Serial.println("Profile selection ended");
  profileSelecting = false;
  selectCandidate = -1;
  // A direction held during selection sends nothing until it is released.
  if (directionMask()) joyMode = JOY_BLOCKED;
}

void chooseProfile(Profile next) {
  endProfileSelection();
  if (next == profile) return;
  if (SERIAL_DEBUG) {
    Serial.print("Switching profile to: ");
    Serial.println(PROFILE_NAMES[next]);
    Serial.flush();
  }
  publishAllKeysReleased();
  saveProfile(next);
  delay(100);
  NVIC_SystemReset();
}

// Button events while selecting. Returns true when the event is used here. A
// second button ends selection and is handed on, so A + B + C still powers off.
bool handleProfileSelection(uint8_t control, bool pressed) {
  if (!profileSelecting) return false;
  if (pressed) {
    if (pressedButtonCount() == 1) {
      selectCandidate = control;
      return true;
    }
    endProfileSelection();
    return false;
  }
  if (selectCandidate == control && pressedButtonCount() == 0) {
    chooseProfile(SELECT_PROFILES[control]);
  }
  return true;
}

// Called every loop: selection ends with no change after PROFILE_SELECT_MS,
// unless a lone button pressed in time is still down: its release chooses.
void updateProfileSelection(uint32_t now) {
  if (!profileSelecting || selectCandidate >= 0 ||
      (uint32_t)(now - profileSelectSince) < PROFILE_SELECT_MS) {
    return;
  }
  endProfileSelection();
  for (uint8_t i = BUTTON_A; i <= BUTTON_C; ++i) {
    if (inputs[i].stablePressed) ignoreUntilRelease[i] = true;
  }
}

// An update needs a bonded phone on an encrypted link and USB power: the
// charging port is under the base, so the remote is off the bike.
bool dfuAllowed(uint16_t connHandle) {
  auto *conn = Bluefruit.Connection(connHandle);
  const bool allowed = conn != nullptr && conn->secured() && conn->bonded() && usbPowered();
  Serial.printf("BLE update %s\n", allowed ? "allowed" : "refused: needs a bonded phone and USB power");
  return allowed;
}

// A new bond is kept only in the first PAIRING_WINDOW_MS after a start, so a
// stranger cannot pair later. Reconnections of bonded phones do not come here.
void onPairComplete(uint16_t connHandle, uint8_t authStatus) {
  if (authStatus != BLE_GAP_SEC_STATUS_SUCCESS || millis() < PAIRING_WINDOW_MS) return;
  auto *conn = Bluefruit.Connection(connHandle);
  if (conn == nullptr) return;
  Serial.println("New pairing refused: pair within 2 min of waking the remote");
  conn->removeBondKey();
  conn->disconnect();
}

void beginBleKeyboard() {
  Bluefruit.begin();
  Bluefruit.setTxPower(4);
  Bluefruit.autoConnLed(false); // the LED shows the profile instead
  Bluefruit.setName("Open Rally Remote");

  // Legacy DFU service: a phone app writes to it and the board restarts
  // into the bootloader's BLE OTA mode, if dfuAllowed agrees. The bootloader
  // itself accepts any image once it runs.
  bleDfu.setAllowCallback(dfuAllowed);
  bleDfu.begin();
  Bluefruit.Security.setPairCompleteCallback(onPairComplete);

  deviceInfo.setManufacturer("Open Rally Remote Project");
  deviceInfo.setModel("XIAO nRF52840 Bench Prototype");
  deviceInfo.setSoftwareRev(FIRMWARE_VERSION);
  deviceInfo.begin();

  bleHid.begin();

  // Added after the HID service so the existing attribute handles do not
  // move for phones that cached them.
  batteryService.begin();

  Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);
  Bluefruit.Advertising.addTxPower();
  Bluefruit.Advertising.addAppearance(BLE_APPEARANCE_HID_KEYBOARD);
  Bluefruit.Advertising.addService(bleHid);
  // The advertising packet has room for 15 name characters only; the scan
  // response carries the full name.
  Bluefruit.ScanResponse.addName();
  Bluefruit.Advertising.restartOnDisconnect(true);
  Bluefruit.Advertising.setInterval(32, 244);
  Bluefruit.Advertising.setFastTimeout(30);
  Bluefruit.Advertising.start(0);
}

void setup() {
  beginBattery(); // first: P0.14 low as early as possible

  if (SERIAL_DEBUG) {
    Serial.begin(115200);
    const uint32_t serialWaitStarted = millis();
    while (!Serial && (uint32_t)(millis() - serialWaitStarted) < 2000) {
      delay(10);
    }
    Serial.printf("Open Rally Remote bench firmware %s\n", FIRMWARE_VERSION);
    Serial.println("Released switch = HIGH; pressed switch = LOW");
  }

  for (uint8_t i = 0; i < CONTROL_COUNT; ++i) {
    inputs[i].pin = CONTROL_PINS[i];
    if (!controlIsInstalled(i)) continue;
    pinMode(inputs[i].pin, INPUT_PULLUP);
  }

  loadProfile();
  for (uint8_t i = 0; i < 3; ++i) {
    pinMode(LED_PINS[i], OUTPUT);
    digitalWrite(LED_PINS[i], HIGH); // off
  }
  synchronizeInputs(millis());
  beginBleKeyboard();

  if (SERIAL_DEBUG) {
    Serial.println("BLE advertising as: Open Rally Remote");
    Serial.print("Profile: ");
    Serial.println(PROFILE_NAMES[profile]);
    uint8_t mac[6];
    Bluefruit.getAddr(mac); // little-endian
    Serial.printf("BLE address: %02X:%02X:%02X:%02X:%02X:%02X\n",
                  mac[5], mac[4], mac[3], mac[2], mac[1], mac[0]);
    if (profile == PROFILE_TERRAPIRATA) {
      Serial.println("TerraPirata: A long = r (trip reset), B long = z (total reset),");
      Serial.println("C = x = screen lock; arrows = joystick; center sends nothing.");
    } else if (profile == PROFILE_KEYBOARD) {
      Serial.println("Keyboard: A, B, C = Buttons A, B, C while held;");
      Serial.println("D = joystick center tap, arrows = joystick.");
    } else {
      Serial.println("Gestures (OsmAnd): A = D / N long / P double, B = - / S long,");
      Serial.println("C = = / x long (lock); center = C; arrows = joystick.");
    }
    Serial.println("Hold the joystick center 5 s, release, then A/B/C to choose");
    Serial.println("TerraPirata/keyboard/gestures.");
    Serial.println("Center: chord of three or more directions.");
  }
}

void loop() {
  const uint32_t now = millis();
  const bool connected = Bluefruit.connected();

  if (connected != previousBleConnected) {
    previousBleConnected = connected;
    clearTapQueue();
    endProfileSelection();
    memset(buttonHeld, 0, sizeof(buttonHeld));
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
  updateJoystick(now);
  processGestureTimers(now);
  updateProfileSelection(now);
  checkPowerOff(now);
  updateBattery(now);
  updateChargeLed();
  showProfile(now);
  processTapQueue(now);

  if (droppedTapCount && SERIAL_DEBUG) {
    Serial.print("Warning: diagnostic tap queue overflow count = ");
    Serial.println(droppedTapCount);
    droppedTapCount = 0;
  }

  delay(5);
}
