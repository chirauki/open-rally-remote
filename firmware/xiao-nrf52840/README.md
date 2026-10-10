# XIAO nRF52840 Bench Firmware

This folder contains the first diagnostic firmware for the Seeed XIAO nRF52840. It reads the switches and acts as a BLE HID keyboard. It is for bench testing only; it does not implement the final TerraPirata, OsmAnd, or DMD2 profiles and is not suitable for use while riding.

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
| D7 | Joystick center switch, breadboard only | Short `J`, long `K`, double `L` |

The V0.22/V0.23 hardware has no D7 switch: pushing the stick straight in closes all four direction switches, and the sketch reads three or more closed together as the center press (see the [firmware specification](../../docs/firmware-spec.md#5-input-processing-and-gesture-rules)). This is the default, `CENTER_FROM_CHORD = true`, and D7 is then not read. For the breadboard, where a straight push cannot be made, set `CENTER_FROM_CHORD` to `false` near the top of the sketch to read a separate center switch on D7.

In chord mode, a direction key-down is held back for the 40 ms chord window (`CHORD_WINDOW_MS`) after the first direction closes:
- If three or more directions close inside the window, the sketch sends the center gesture and no arrow key until all directions are released.
- If two opposite directions are closed, no arrow key is sent.
- A tilt released inside the window is sent as one arrow tap.
- A push slower than the window first sends the arrow of the first switch, then releases it and sends the center gesture.

All connected pins use `INPUT_PULLUP`: open/released reads HIGH, pressed reads LOW. Do not connect an input to 3.3 V or 5 V.

## First test

1. Upload the sketch and open the Serial Monitor at 115200 baud.
2. Pair **Open Rally Remote** from the phone's Bluetooth settings.
3. Open a keyboard tester or a harmless text field, then press each control. Letters identify discrete gestures; joystick directions send held arrow-key reports.
4. Confirm short presses, long presses, double presses and release behavior. On the joystick, confirm that a straight push gives one center gesture and no arrow key, and that tilts and diagonals give no center gesture.

The short event is intentionally delayed by the 300 ms double-press window. Initial timings are set near 30 ms debounce, 600 ms long press, 300 ms double press, 40 ms chord window and 50 ms key-down duration. With the chord window, an arrow key-down follows the switch by about 70 ms.

The letters are diagnostic keys and may trigger actions in a navigation app. Do not test this firmware in an app while riding. The target app profiles and BLE firmware update/OTA support are not implemented in this sketch.

## Build check

The sketch was compiled on 2026-10-10 with `arduino-cli` and Seeed nRF52 Boards 1.1.13 for `Seeeduino:nrf52:xiaonRF52840`, in both center modes, with no warnings from the sketch. The package's own GCC 9 toolchain is an Intel binary and did not run on the Apple Silicon build machine without Rosetta, so the check used Arm GNU Toolchain 13.3. The Arduino IDE on a machine that runs the package toolchain may still report something different.

The chord logic was also run on the host against mocked switch timelines (tilt, short tilt, diagonal, staggered push, long and double push, slow push, opposite pair). It has not yet run on the XIAO or the real switches.
