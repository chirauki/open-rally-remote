# XIAO nRF52840 Bench Firmware

This folder contains the first diagnostic firmware for the Seeed XIAO nRF52840. It reads the temporary switches and acts as a BLE HID keyboard. It is for bench testing only; it does not implement the final TerraPirata, OsmAnd, or DMD2 profiles and is not suitable for use while riding.

## Upload

Follow the [development environment guide](../../docs/development-environment.md), then open `open-rally-remote.ino` in Arduino IDE 2. Select **Seeed XIAO nRF52840** and the XIAO's USB port, then click **Verify** and **Upload**.

The sketch uses the `Seeed nRF52 Boards` package and its bundled Adafruit Bluefruit BLE HID library. It also includes `Adafruit_TinyUSB.h` to support the XIAO's USB serial diagnostics with this board package.

## Wiring

Wire each normally-open switch between its GPIO and GND:

| XIAO pin | Input | Diagnostic output |
|---|---|---|
| D0 | Button A | Short `A`, long `B`, double `C` |
| D1 | Button B | Short `D`, long `E`, double `F` |
| D2 | Button C | Short `G`, long `H`, double `I` |
| D3 | Joystick up | Hold Up Arrow |
| D4 | Joystick down | Hold Down Arrow |
| D5 | Joystick left | Hold Left Arrow |
| D6 | Joystick right | Hold Right Arrow |
| D7 | Optional joystick center | Short `J`, long `K`, double `L` |

All connected pins use `INPUT_PULLUP`: open/released reads HIGH, pressed reads LOW. Do not connect an input to 3.3 V or 5 V. If the center switch is not fitted, set `CENTER_SWITCH_FITTED` to `false` near the top of the sketch.

## First test

1. Upload the sketch and open the Serial Monitor at 115200 baud.
2. Pair **Open Rally Remote** from the phone's Bluetooth settings.
3. Open a keyboard tester or a harmless text field, then press each control. Letters identify discrete gestures; joystick directions send held arrow-key reports.
4. Confirm short presses, long presses, double presses, release behavior, and the optional center-switch variant.

The short event is intentionally delayed by the 300 ms double-press window. Initial timings are set near 30 ms debounce, 600 ms long press, 300 ms double press, and 50 ms key-down duration.

The letters are diagnostic keys and may trigger actions in a navigation app. Do not test this firmware in an app while riding. The target app profiles and BLE firmware update/OTA support are not implemented in this sketch.
