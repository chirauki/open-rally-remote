# Host Tests for the Bench Firmware

> Spanish version: [README.es.md](README.es.md).

These tests build `open-rally-remote.ino` on a computer and run it against simulated switches, clock, BLE link and flash. Each test presses and releases controls over time and checks the HID reports the sketch sends. They run on every change, with no board or phone.

```sh
make -C firmware/xiao-nrf52840/test            # all tests, both boards
make -C firmware/xiao-nrf52840/test TEST=terrapirata   # tests whose name has "terrapirata"
```

`make` builds the sketch twice, with `BOARD_V026` false (breadboard) and true (V0.26 control board), and runs every test on each. Each test runs in its own process, so the sketch's globals start fresh. It needs only a C++17 compiler; on macOS the Xcode command line tools.

## What is covered

- **TerraPirata profile:** C sends `x` on release, with no double-press wait; A and B held 2 s send `r` and `z`; their short and double presses, and holds under 2 s, send nothing; the joystick holds arrows; the center sends nothing; no media keys.
- **Keyboard profile:** buttons hold `A`, `B`, `C`; the center sends `D` on a short or double press.
- **Gestures profile (OsmAnd):** A's short, long and double presses send `D`, `N`, `P`, the short one after the 300 ms double-press window; B and C send `-` and `=` on release, `S` and `x` when held; the center sends `C` on release.
- **Joystick:** opposite directions send nothing; the center chord sends no arrows; a tilt released inside the chord window is one arrow tap.
- **Profiles, power and connection:** profile selection: the center held 5 s and released, then a lone button stores its profile and restarts (no restart for the current one), and selection ends with no change on a timeout, two buttons, a disconnect or a release before 5 s, sending no key; an unknown stored profile starts TerraPirata; the A + B + C power off sends no key in TerraPirata; nothing is sent while disconnected; a control held at reconnect is ignored until released; the startup log describes the current TerraPirata map.

Not covered: the battery reading and charging, the LED, BLE OTA, and anything the stubs in `stubs/host.h` do not model. The stubs stand in for the Arduino core, Bluefruit, TinyUSB and LittleFS APIs the sketch calls; a new API call in the sketch needs a stub here.

## Checks

There are 37 tests per board since 0.11.0's profile selection (20 when they were added, 22 with the 0.10.0 gestures profile). On 2026-10-20 all passed on both boards, with no compiler warnings. The first run found a stale startup message, which still described the 0.8.0 TerraPirata keys; it was fixed. Three bugs injected by hand into a copy of the sketch were each caught: a 600 ms reset hold (2 tests failed), a double action on C (1 failed), and held keys in the TerraPirata profile (5 failed).
