# Profile Selection Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the cycling profile switch with a direct choice: hold the joystick center 5 s, release, then press and release A, B or C.

**Architecture:** A small selection state in `open-rally-remote.ino`, entered when the center chord is released after 5 s held, ended by a lone button release, a 5 s timeout, two buttons, or a disconnect. While it is active, no key leaves the board. Everything else in the sketch is unchanged.

**Tech Stack:** Arduino C++ (Seeed nRF52 / Bluefruit), host tests in `firmware/xiao-nrf52840/test` (C++17, `make`).

**Spec:** `docs/superpowers/specs/2026-10-20-profile-selection-design.md`

## Global Constraints

- `PROFILE_SWITCH_MS` = 5000 (hold to enter); `PROFILE_SELECT_MS` = 5000 (time to choose, from the center release).
- A = `PROFILE_TERRAPIRATA`, B = `PROFILE_KEYBOARD`, C = `PROFILE_GESTURES`.
- The choice is taken on the button's release, only if no other button was pressed during that press.
- A different profile: `saveProfile()`, then restart as today (`publishAllKeysReleased()`, `delay(100)`, `NVIC_SystemReset()`). The current profile: leave selection, no restart.
- No HID key (keyboard or consumer) is sent while selecting, nor by the choosing button's release.
- Firmware version becomes `"0.11.0"`.
- Docs in English and Spanish; commits signed (`git commit -S -s`), no AI attribution, ask the user before each commit.

## Review Focus

- A + B + C pressed during selection: no profile change, and power off still arms and sleeps on release (test `power_off_combo_during_selection_still_works`, Task 1).
- The center held past 5 s but not released: nothing happens until release, and no restart (test `center_held_without_release_does_not_switch`, Task 1).
- A button held when selection times out: its later release must not choose and must not send its normal gesture (test `button_held_across_timeout_does_nothing`, Task 1).
- The joystick moved during selection: no arrow reaches the phone, and after selection the joystick works again (test `no_keys_during_selection`, Task 1).
- Reconnect during selection: the selection is dropped; a later button acts normally (test `disconnect_ends_selection`, Task 1).

---

### Task 1: Selection state and its host tests

**Files:**
- Modify: `firmware/xiao-nrf52840/open-rally-remote.ino` (constants near `PROFILE_SWITCH_MS`; `checkProfileSwitch()`; `handleStableTransition()`; `buildCurrentReport()`/`enqueueTap()`; `loop()` disconnect branch; startup log; `FIRMWARE_VERSION`)
- Test: `firmware/xiao-nrf52840/test/test_sketch.cpp`

**Interfaces:**
- Produces: `constexpr uint32_t PROFILE_SELECT_MS = 5000;` `bool profileSelecting;` `void beginProfileSelection(uint32_t now);` `void endProfileSelection();` `void chooseProfile(Profile next);` `void updateProfileSelection(uint32_t now);` (timeout, called from `loop()`).

- [ ] **Step 1: Replace `center_held_five_seconds_switches_profile` and add the selection tests.** Helpers in the test file: `enterSelection()` = `pushCenter(5200)` then `run(100)`; `chooseWith(button)` = `tap(button, 100)` then `run(100)`, catching `HostRestart` and returning whether it was thrown.

  - `select_each_profile_by_button`: for A, B, C from TerraPirata, B and C restart and store `PROFILE_KEYBOARD` / `PROFILE_GESTURES` in `host.files["/profile"]`; `keyDowns()` is empty.
  - `select_current_profile_does_not_restart`: TerraPirata, `enterSelection()`, A → no restart, the file still holds `PROFILE_TERRAPIRATA`; then `tap(BUTTON_C, 100); run(100);` gives `onlyKey(keyDowns(), HID_KEY_X)`.
  - `center_released_early_does_not_select`: `pushCenter(4500); run(100);` then `tap(BUTTON_C, 100); run(100);` → `onlyKey(keyDowns(), HID_KEY_X)`, no restart.
  - `center_held_without_release_does_not_switch`: hold the chord 6000 ms → no `HostRestart`, file unchanged.
  - `selection_times_out`: `enterSelection(); run(5100);` then C → `HID_KEY_X`, no restart.
  - `no_keys_during_selection`: `enterSelection()`; joystick right held 300 ms, released; `keyDowns().empty()`; after `chooseWith(BUTTON_A)` (current profile), joystick right held 300 ms → `keyHeld(HID_KEY_ARROW_RIGHT)`.
  - `two_buttons_cancel_selection`: `enterSelection()`; press A, `run(50)`, press B, `run(100)`, release both, `run(100)` → no restart, no keys; then C → `HID_KEY_X`.
  - `power_off_combo_during_selection_still_works`: `enterSelection()`; press C, B, A (50 ms apart), `run(3200)` → `powerOffArmed`; releasing all → `HostSystemOff`; file unchanged; `keyDowns().empty()`.
  - `button_held_across_timeout_does_nothing`: `enterSelection()`; press B, `run(5200)`, release, `run(100)` → no restart, `keyDowns().empty()`.
  - `disconnect_ends_selection`: `enterSelection()`; `host.connected = false; run(50); host.connected = true; run(100);` then `tap(BUTTON_B, 100); run(100);` → no restart.
  - In `startup_log_describes_the_terrapirata_profile`, also expect `"A/B/C to choose"` in `host.log`.

- [ ] **Step 2: Run the tests and watch the new ones fail.**
  Run: `make -C firmware/xiao-nrf52840/test`
  Expected: the selection tests FAIL (the sketch still cycles and restarts at 5 s held); the others PASS.

- [ ] **Step 3: Implement the selection in the sketch.**
  - `checkProfileSwitch()` no longer restarts at 5 s held. When the center chord is released (`finishGesture(JOYSTICK_CENTER, now)`) with `now - pressedAt >= PROFILE_SWITCH_MS`, call `beginProfileSelection(now)`.
  - In `handleStableTransition()`, before the combo and hold handling, while `profileSelecting`: a button press marks it the candidate if no other button is closed, otherwise clears the candidate and ends selection (then falls through to `handleButtonCombo()` so power off works); a button release that matches a still-valid candidate calls `chooseProfile()`. Mark the choosing button `ignoreUntilRelease` so no gesture fires. Directions are left to `updateJoystick()`.
  - While `profileSelecting`, `buildCurrentReport()` reports no keys and `enqueueTap()` drops taps.
  - `updateProfileSelection(now)` ends selection after `PROFILE_SELECT_MS` from entry; a button still held at that moment gets `ignoreUntilRelease`.
  - The `loop()` connection-change branch calls `endProfileSelection()`.
  - Startup log: replace "Hold the joystick center 5 s to switch profile." with "Hold the joystick center 5 s, release, then A/B/C to choose TerraPirata/keyboard/gestures."
  - `FIRMWARE_VERSION` = `"0.11.0"`.

- [ ] **Step 4: Run all host tests.**
  Run: `make -C firmware/xiao-nrf52840/test`
  Expected: `sketch-false.ino: 0 failed` and `sketch-true.ino: 0 failed`.

- [ ] **Step 5: Compile both boards for the XIAO.**
  Run the two `arduino-cli compile` builds as in `~/.arduino-orr/README.txt` (`BOARD_V026` false and true).
  Expected: both build, no warnings from the sketch.

### Task 2: Documentation, bench check and commit

**Files:**
- Modify (English and Spanish): `firmware/xiao-nrf52840/README.md` / `.es.md` (wiring note on the center, Profiles section, a "Firmware 0.11.0" bench entry), `docs/firmware-spec.md` / `.es.md` (section 7 profile switch paragraph), `docs/control-mapping.md` / `.es.md` (joystick center rows: "Held 5 s and released, then A/B/C: choose the profile"), `docs/mechanical-concept.md` / `.es.md` ("Profile LED" open unknown: closed by the direct choice), `firmware/xiao-nrf52840/test/README.md` / `.es.md` (coverage line).

**Interfaces:**
- Consumes: the behaviour and names from Task 1.

- [ ] **Step 1: Update the docs above.** Each change in both languages, same commit.
- [ ] **Step 2: Bench check.** Flash the breadboard build; with the serial log open, choose each profile and confirm the LED colour after the restart and the phone's reconnection; choose the current profile and confirm no restart.
  Expected: the log shows the stored profile after each restart; no key reaches the phone during selection.
- [ ] **Step 3: Ask the user, then commit and push.**
  ```bash
  git add firmware/xiao-nrf52840 docs
  git commit -S -s -m "Choose the profile directly in firmware 0.11.0"
  git push origin main
  ```
