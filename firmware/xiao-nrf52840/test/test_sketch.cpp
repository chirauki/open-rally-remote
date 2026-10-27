// Host tests for the bench sketch: switch timelines in, HID reports out.
// Build and run with `make` in this folder; see README.md. Each test runs in
// its own process, so the sketch's globals start fresh every time.

#include <sys/wait.h>
#include <unistd.h>

#include <functional>

#include "host.h"
#include SKETCH

// ---------- Test framework ----------

struct Test {
  const char *name;
  std::function<void()> run;
};
std::vector<Test> &tests() {
  static std::vector<Test> all;
  return all;
}
struct Register {
  Register(const char *name, std::function<void()> run) { tests().push_back({name, run}); }
};
#define TEST(name)                                     \
  void name();                                         \
  static Register register_##name(#name, name);        \
  void name()

#define EXPECT(cond)                                                         \
  do {                                                                       \
    if (!(cond)) {                                                           \
      fprintf(stderr, "  %s:%d: expected %s\n", __FILE__, __LINE__, #cond);  \
      _exit(1);                                                              \
    }                                                                        \
  } while (0)

// ---------- Simulation helpers ----------

uint8_t pinOf(uint8_t control) { return CONTROL_PINS[control]; }
void press(uint8_t control) { host.pinLevel[pinOf(control)] = LOW; }
void release(uint8_t control) { host.pinLevel[pinOf(control)] = HIGH; }

// Runs the sketch's loop for `ms` of simulated time; loop() itself waits 5 ms.
void run(uint32_t ms) {
  const uint32_t end = host.now + ms;
  while (host.now < end) loop();
}

void setBatteryMv(float mv) {
  host.adcRaw = (uint16_t)(mv / (3600.0f / 4096.0f * VBAT_DIVIDER) + 0.5f);
}

// Boots the sketch in `selected`, connected to a phone, and clears the events.
void start(Profile selected) {
  host.files["/profile"] = { (uint8_t)selected };
  setBatteryMv(3900);
  setup();
  host.connected = true;
  run(100);
  host.events.clear();
  host.log.clear();
}

struct KeyDown {
  uint32_t at;
  uint16_t key;  // keyboard usage, or CONSUMER | usage
};

// Key-down edges in the recorded reports, in order.
std::vector<KeyDown> keyDowns() {
  std::vector<KeyDown> downs;
  uint8_t previous[6] = {};
  for (const HidEvent &e : host.events) {
    if (e.consumer) {
      if (e.usage) downs.push_back({e.at, (uint16_t)(CONSUMER | e.usage)});
      continue;
    }
    for (uint8_t k : e.keys) {
      if (k && !memchr(previous, k, 6)) downs.push_back({e.at, k});
    }
    memcpy(previous, e.keys, 6);
  }
  return downs;
}

// Whether `key` is down in the last keyboard report.
bool keyHeld(uint8_t key) {
  for (auto e = host.events.rbegin(); e != host.events.rend(); ++e) {
    if (!e->consumer) return memchr(e->keys, key, 6) != nullptr;
  }
  return false;
}

bool onlyKey(const std::vector<KeyDown> &downs, uint16_t key) {
  return downs.size() == 1 && downs[0].key == key;
}

void tap(uint8_t control, uint32_t heldMs) {
  press(control);
  run(heldMs);
  release(control);
}

// The center chord: three directions closed together, as a straight push.
void pushCenter(uint32_t heldMs) {
  press(JOYSTICK_UP);
  press(JOYSTICK_LEFT);
  press(JOYSTICK_RIGHT);
  run(heldMs);
  release(JOYSTICK_UP);
  release(JOYSTICK_LEFT);
  release(JOYSTICK_RIGHT);
}

// ---------- TerraPirata profile ----------

TEST(terrapirata_c_short_sends_x_on_release) {
  start(PROFILE_TERRAPIRATA);
  press(BUTTON_C);
  run(200);
  EXPECT(keyDowns().empty());
  const uint32_t releasedAt = host.now;
  release(BUTTON_C);
  run(100);
  const auto downs = keyDowns();
  EXPECT(onlyKey(downs, HID_KEY_X));
  EXPECT(downs[0].at - releasedAt <= 50);  // no double-press wait
  EXPECT(!keyHeld(HID_KEY_X));
}

TEST(terrapirata_a_long_sends_r_at_two_seconds) {
  start(PROFILE_TERRAPIRATA);
  const uint32_t pressedAt = host.now;
  press(BUTTON_A);
  run(1900);
  EXPECT(keyDowns().empty());
  run(300);
  const auto downs = keyDowns();
  EXPECT(onlyKey(downs, HID_KEY_R));
  EXPECT(downs[0].at - pressedAt >= RESET_LONG_PRESS_MS);
  release(BUTTON_A);
  run(500);
  EXPECT(keyDowns().size() == 1);  // nothing more on release
}

TEST(terrapirata_b_long_sends_z) {
  start(PROFILE_TERRAPIRATA);
  tap(BUTTON_B, 2200);
  run(500);
  EXPECT(onlyKey(keyDowns(), HID_KEY_Z));
}

TEST(terrapirata_a_and_b_short_and_double_send_nothing) {
  start(PROFILE_TERRAPIRATA);
  for (uint8_t button : { BUTTON_A, BUTTON_B }) {
    tap(button, 100);
    run(500);
    tap(button, 100);
    run(100);
    tap(button, 100);
    run(500);
    tap(button, 1500);  // long, but short of 2 s
    run(500);
  }
  EXPECT(keyDowns().empty());
}

TEST(terrapirata_joystick_holds_arrows) {
  start(PROFILE_TERRAPIRATA);
  press(JOYSTICK_RIGHT);
  run(300);
  EXPECT(keyHeld(HID_KEY_ARROW_RIGHT));
  release(JOYSTICK_RIGHT);
  run(100);
  EXPECT(!keyHeld(HID_KEY_ARROW_RIGHT));
  press(JOYSTICK_UP);
  run(300);
  EXPECT(keyHeld(HID_KEY_ARROW_UP));
  release(JOYSTICK_UP);
  run(100);
  const auto downs = keyDowns();
  EXPECT(downs.size() == 2 && downs[0].key == HID_KEY_ARROW_RIGHT &&
         downs[1].key == HID_KEY_ARROW_UP);
}

TEST(terrapirata_center_sends_nothing) {
  start(PROFILE_TERRAPIRATA);
  pushCenter(200);
  run(500);
  EXPECT(keyDowns().empty());
}

TEST(terrapirata_sends_no_media_keys) {
  start(PROFILE_TERRAPIRATA);
  for (uint8_t c = BUTTON_A; c <= JOYSTICK_RIGHT; ++c) {
    tap(c, 100);
    run(500);
    tap(c, 2200);
    run(500);
  }
  for (const HidEvent &e : host.events) EXPECT(!e.consumer || e.usage == 0);
}

// ---------- Keyboard profile ----------

TEST(keyboard_buttons_hold_letters) {
  start(PROFILE_KEYBOARD);
  press(BUTTON_B);
  run(1500);
  EXPECT(keyHeld(HID_KEY_B));
  release(BUTTON_B);
  run(100);
  EXPECT(!keyHeld(HID_KEY_B));
  EXPECT(onlyKey(keyDowns(), HID_KEY_B));
}

TEST(keyboard_center_short_and_double_send_d) {
  start(PROFILE_KEYBOARD);
  pushCenter(100);
  run(500);
  EXPECT(onlyKey(keyDowns(), HID_KEY_D));
  host.events.clear();
  pushCenter(100);
  run(100);
  pushCenter(100);
  run(500);
  EXPECT(onlyKey(keyDowns(), HID_KEY_D));
}

// ---------- Gestures profile ----------

TEST(gestures_a_short_long_double_send_osmand_keys) {
  start(PROFILE_GESTURES);
  tap(BUTTON_A, 100);
  run(200);
  EXPECT(keyDowns().empty());  // waiting out the double-press window
  run(300);
  EXPECT(onlyKey(keyDowns(), HID_KEY_D));  // map orientation
  host.events.clear();
  tap(BUTTON_A, 800);
  run(500);
  EXPECT(onlyKey(keyDowns(), HID_KEY_N));  // navigation view
  host.events.clear();
  tap(BUTTON_A, 100);
  run(100);
  tap(BUTTON_A, 100);
  run(500);
  EXPECT(onlyKey(keyDowns(), HID_KEY_P));  // next app profile
}

TEST(gestures_b_zooms_out_and_c_zooms_in_on_release) {
  start(PROFILE_GESTURES);
  tap(BUTTON_B, 100);
  run(50);
  EXPECT(onlyKey(keyDowns(), HID_KEY_MINUS));  // no double-press wait
  host.events.clear();
  tap(BUTTON_C, 100);
  run(50);
  EXPECT(onlyKey(keyDowns(), HID_KEY_EQUAL));
  host.events.clear();
  tap(BUTTON_B, 100);
  run(100);
  tap(BUTTON_B, 100);
  run(100);
  EXPECT(keyDowns().size() == 2 && keyDowns()[1].key == HID_KEY_MINUS);  // two zoom steps
}

TEST(gestures_b_long_searches_and_c_long_locks) {
  start(PROFILE_GESTURES);
  tap(BUTTON_B, 800);
  run(500);
  EXPECT(onlyKey(keyDowns(), HID_KEY_S));
  host.events.clear();
  tap(BUTTON_C, 800);
  run(500);
  EXPECT(onlyKey(keyDowns(), HID_KEY_X));  // assigned to "Touch screen lock" in OsmAnd
}

TEST(gestures_center_sends_c_on_release) {
  start(PROFILE_GESTURES);
  pushCenter(100);
  run(50);
  EXPECT(onlyKey(keyDowns(), HID_KEY_C));  // my position, no double-press wait
}

// ---------- Joystick, every profile ----------

TEST(joystick_opposite_directions_send_nothing) {
  start(PROFILE_TERRAPIRATA);
  press(JOYSTICK_LEFT);
  press(JOYSTICK_RIGHT);
  run(300);
  release(JOYSTICK_LEFT);
  release(JOYSTICK_RIGHT);
  run(100);
  EXPECT(keyDowns().empty());
}

TEST(joystick_chord_sends_no_arrows) {
  start(PROFILE_GESTURES);
  pushCenter(300);
  run(500);
  for (const KeyDown &d : keyDowns()) {
    EXPECT(d.key != HID_KEY_ARROW_UP && d.key != HID_KEY_ARROW_LEFT &&
           d.key != HID_KEY_ARROW_RIGHT);
  }
}

TEST(joystick_short_tilt_is_one_arrow_tap) {
  start(PROFILE_TERRAPIRATA);
  // Longer than the 30 ms debounce, released inside the 40 ms chord window
  // that starts once the press is stable.
  tap(JOYSTICK_DOWN, 35);
  run(200);
  EXPECT(onlyKey(keyDowns(), HID_KEY_ARROW_DOWN));
  EXPECT(!keyHeld(HID_KEY_ARROW_DOWN));
}

// ---------- Profiles, power and connection ----------

// ---------- Profile selection ----------

// Center held 5 s and released enters selection.
void enterSelection() {
  pushCenter(5200);
  run(100);
}

// Taps a button in selection; true if the board restarted.
bool chooseWith(uint8_t button) {
  try {
    tap(button, 100);
    run(100);
  } catch (const HostRestart &) {
    return true;
  }
  return false;
}

uint8_t storedProfile() { return host.files["/profile"].at(0); }

TEST(select_each_profile_by_button) {
  start(PROFILE_TERRAPIRATA);
  enterSelection();
  EXPECT(chooseWith(BUTTON_B));
  EXPECT(storedProfile() == PROFILE_KEYBOARD);
  EXPECT(keyDowns().empty());
}

TEST(select_gestures_with_c) {
  start(PROFILE_TERRAPIRATA);
  enterSelection();
  EXPECT(chooseWith(BUTTON_C));
  EXPECT(storedProfile() == PROFILE_GESTURES);
  EXPECT(keyDowns().empty());
}

TEST(select_terrapirata_with_a) {
  start(PROFILE_GESTURES);
  enterSelection();
  EXPECT(chooseWith(BUTTON_A));
  EXPECT(storedProfile() == PROFILE_TERRAPIRATA);
  EXPECT(keyDowns().empty());
}

TEST(select_current_profile_does_not_restart) {
  start(PROFILE_TERRAPIRATA);
  enterSelection();
  EXPECT(!chooseWith(BUTTON_A));
  EXPECT(storedProfile() == PROFILE_TERRAPIRATA);
  EXPECT(keyDowns().empty());
  tap(BUTTON_C, 100);
  run(100);
  EXPECT(onlyKey(keyDowns(), HID_KEY_X));  // back to normal at once
}

TEST(center_released_early_does_not_select) {
  start(PROFILE_TERRAPIRATA);
  pushCenter(4500);
  run(100);
  EXPECT(!chooseWith(BUTTON_C));
  EXPECT(onlyKey(keyDowns(), HID_KEY_X));
}

TEST(center_held_without_release_does_not_switch) {
  start(PROFILE_TERRAPIRATA);
  press(JOYSTICK_UP);
  press(JOYSTICK_LEFT);
  press(JOYSTICK_RIGHT);
  bool restarted = false;
  try {
    run(6000);
  } catch (const HostRestart &) {
    restarted = true;
  }
  EXPECT(!restarted);
  EXPECT(storedProfile() == PROFILE_TERRAPIRATA);
}

TEST(selection_times_out) {
  start(PROFILE_TERRAPIRATA);
  enterSelection();
  run(5100);
  EXPECT(!chooseWith(BUTTON_C));
  EXPECT(onlyKey(keyDowns(), HID_KEY_X));
  EXPECT(storedProfile() == PROFILE_TERRAPIRATA);
}

TEST(no_keys_during_selection) {
  start(PROFILE_TERRAPIRATA);
  enterSelection();
  press(JOYSTICK_RIGHT);
  run(300);
  release(JOYSTICK_RIGHT);
  run(100);
  EXPECT(keyDowns().empty());
  EXPECT(!chooseWith(BUTTON_A));
  press(JOYSTICK_RIGHT);
  run(300);
  EXPECT(keyHeld(HID_KEY_ARROW_RIGHT));
}

TEST(two_buttons_cancel_selection) {
  start(PROFILE_TERRAPIRATA);
  enterSelection();
  bool restarted = false;
  try {
    press(BUTTON_A);
    run(50);
    press(BUTTON_B);
    run(100);
    release(BUTTON_A);
    release(BUTTON_B);
    run(100);
  } catch (const HostRestart &) {
    restarted = true;
  }
  EXPECT(!restarted);
  EXPECT(keyDowns().empty());
  EXPECT(!chooseWith(BUTTON_C));
  EXPECT(onlyKey(keyDowns(), HID_KEY_X));
}

TEST(power_off_combo_during_selection_still_works) {
  start(PROFILE_TERRAPIRATA);
  enterSelection();
  press(BUTTON_C);
  run(50);
  press(BUTTON_B);
  run(50);
  press(BUTTON_A);
  run(3200);
  EXPECT(powerOffArmed);
  bool off = false;
  try {
    release(BUTTON_A);
    release(BUTTON_B);
    release(BUTTON_C);
    run(200);
  } catch (const HostSystemOff &) {
    off = true;
  }
  EXPECT(off);
  EXPECT(storedProfile() == PROFILE_TERRAPIRATA);
  EXPECT(keyDowns().empty());
}

TEST(button_pressed_in_time_chooses_however_long_held) {
  start(PROFILE_TERRAPIRATA);
  enterSelection();
  bool restarted = false;
  try {
    press(BUTTON_B);
    run(5200);
    release(BUTTON_B);
    run(100);
  } catch (const HostRestart &) {
    restarted = true;
  }
  EXPECT(restarted);
  EXPECT(storedProfile() == PROFILE_KEYBOARD);
  EXPECT(keyDowns().empty());
}

TEST(button_pressed_after_window_does_nothing) {
  start(PROFILE_TERRAPIRATA);
  enterSelection();
  run(5100);
  EXPECT(!chooseWith(BUTTON_B));
  EXPECT(storedProfile() == PROFILE_TERRAPIRATA);
}

TEST(press_at_end_of_window_still_chooses) {
  start(PROFILE_TERRAPIRATA);
  enterSelection();  // selection entered 100 ms ago
  run(4800);
  bool restarted = false;
  try {
    press(BUTTON_C);
    run(300);  // released after the 5 s window
    release(BUTTON_C);
    run(100);
  } catch (const HostRestart &) {
    restarted = true;
  }
  EXPECT(restarted);
  EXPECT(storedProfile() == PROFILE_GESTURES);
}

TEST(direction_held_across_selection_end_sends_nothing) {
  start(PROFILE_TERRAPIRATA);
  enterSelection();
  press(JOYSTICK_RIGHT);
  run(5300);  // selection times out while Right is held
  EXPECT(keyDowns().empty());
  release(JOYSTICK_RIGHT);
  run(100);
  EXPECT(keyDowns().empty());
  press(JOYSTICK_RIGHT);
  run(300);
  EXPECT(keyHeld(HID_KEY_ARROW_RIGHT));
}

TEST(keyboard_key_held_at_selection_entry_is_released) {
  start(PROFILE_KEYBOARD);
  press(BUTTON_B);
  run(100);
  EXPECT(keyHeld(HID_KEY_B));
  pushCenter(5200);
  run(100);
  EXPECT(!keyHeld(HID_KEY_B));
  release(BUTTON_B);
  run(5300);  // selection times out
  EXPECT(!keyHeld(HID_KEY_B));
}

TEST(disconnect_ends_selection) {
  start(PROFILE_TERRAPIRATA);
  enterSelection();
  host.connected = false;
  run(50);
  host.connected = true;
  run(100);
  EXPECT(!chooseWith(BUTTON_B));
  EXPECT(storedProfile() == PROFILE_TERRAPIRATA);
}

TEST(unknown_stored_profile_starts_terrapirata) {
  host.files["/profile"] = { 7 };
  setBatteryMv(3900);
  setup();
  EXPECT(profile == PROFILE_TERRAPIRATA);
}

TEST(power_off_combination_sends_nothing_in_terrapirata) {
  start(PROFILE_TERRAPIRATA);
  press(BUTTON_C);
  run(50);
  press(BUTTON_B);
  run(50);
  press(BUTTON_A);
  run(3200);
  EXPECT(powerOffArmed);
  release(BUTTON_A);
  release(BUTTON_B);
  bool off = false;
  try {
    release(BUTTON_C);
    run(200);
  } catch (const HostSystemOff &) {
    off = true;
  }
  EXPECT(off);
  EXPECT(keyDowns().empty());
}

TEST(nothing_is_sent_while_disconnected) {
  start(PROFILE_TERRAPIRATA);
  host.connected = false;
  run(50);
  host.events.clear();
  tap(BUTTON_C, 100);
  tap(BUTTON_A, 2200);
  press(JOYSTICK_RIGHT);
  run(300);
  release(JOYSTICK_RIGHT);
  run(100);
  EXPECT(host.events.empty());
}

TEST(control_held_at_reconnect_is_ignored_until_released) {
  start(PROFILE_TERRAPIRATA);
  host.connected = false;
  run(50);
  press(JOYSTICK_RIGHT);
  run(100);
  host.connected = true;
  run(300);
  EXPECT(!keyHeld(HID_KEY_ARROW_RIGHT));
  release(JOYSTICK_RIGHT);
  run(100);
  press(JOYSTICK_RIGHT);
  run(300);
  EXPECT(keyHeld(HID_KEY_ARROW_RIGHT));
}

TEST(startup_log_describes_the_terrapirata_profile) {
  host.files["/profile"] = { PROFILE_TERRAPIRATA };
  setBatteryMv(3900);
  setup();
  EXPECT(host.log.find("Play/Pause") == std::string::npos);
  EXPECT(host.log.find("x = screen lock") != std::string::npos);
  EXPECT(host.log.find("A/B/C to choose") != std::string::npos);
}

// ---------- BLE update and pairing ----------

void setUsb(bool present) {
  host.usbPresent = present;
  host.pinLevel[PIN_VBUS_SENSE] = present ? HIGH : LOW;
}

void setPeer(bool secured, bool bonded) {
  host.peerSecured = secured;
  host.peerBonded = bonded;
}

TEST(setup_registers_the_update_and_pairing_checks) {
  start(PROFILE_TERRAPIRATA);
  EXPECT(host.dfuAllowCb != nullptr);
  EXPECT(host.pairCompleteCb != nullptr);
}

TEST(update_allowed_from_a_bonded_phone_on_usb) {
  start(PROFILE_TERRAPIRATA);
  setUsb(true);
  setPeer(true, true);
  EXPECT(host.dfuAllowCb(0));
}

TEST(update_refused_without_usb) {
  start(PROFILE_TERRAPIRATA);
  setUsb(false);
  setPeer(true, true);
  EXPECT(!host.dfuAllowCb(0));
}

TEST(update_refused_from_an_unbonded_phone) {
  start(PROFILE_TERRAPIRATA);
  setUsb(true);
  setPeer(true, false);
  EXPECT(!host.dfuAllowCb(0));
}

TEST(update_refused_on_an_unencrypted_link) {
  start(PROFILE_TERRAPIRATA);
  setUsb(true);
  setPeer(false, true);
  EXPECT(!host.dfuAllowCb(0));
}

TEST(new_bond_kept_inside_the_pairing_window) {
  start(PROFILE_TERRAPIRATA);
  run(PAIRING_WINDOW_MS - 1000);
  host.pairCompleteCb(0, BLE_GAP_SEC_STATUS_SUCCESS);
  EXPECT(!host.bondRemoved);
  EXPECT(!host.peerDisconnected);
}

TEST(new_bond_removed_after_the_pairing_window) {
  start(PROFILE_TERRAPIRATA);
  run(PAIRING_WINDOW_MS + 1000);
  host.pairCompleteCb(0, BLE_GAP_SEC_STATUS_SUCCESS);
  EXPECT(host.bondRemoved);
  EXPECT(host.peerDisconnected);
}

TEST(failed_pairing_after_the_window_is_left_alone) {
  start(PROFILE_TERRAPIRATA);
  run(PAIRING_WINDOW_MS + 1000);
  host.pairCompleteCb(0, 0x85);  // pairing failed: no bond to remove
  EXPECT(!host.bondRemoved);
  EXPECT(!host.peerDisconnected);
}

// ---------- Runner ----------

int main(int argc, char **argv) {
  int failed = 0;
  for (const Test &t : tests()) {
    if (argc > 1 && !strstr(t.name, argv[1])) continue;
    fflush(stdout);
    const pid_t pid = fork();
    if (pid == 0) {
      t.run();
      _exit(0);
    }
    int status = 0;
    waitpid(pid, &status, 0);
    const bool ok = WIFEXITED(status) && WEXITSTATUS(status) == 0;
    printf("%s %s\n", ok ? "PASS" : "FAIL", t.name);
    if (!ok) ++failed;
  }
  printf("%s: %d failed\n", SKETCH, failed);
  return failed ? 1 : 0;
}
