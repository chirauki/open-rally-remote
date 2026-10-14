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

The letters are diagnostic keys and may trigger actions in a navigation app. Do not test this firmware in an app while riding. The target app profiles are not implemented in this sketch. BLE updates work on the bench; see [BLE OTA update](#ble-ota-update).

## Build check

The sketch was compiled on 2026-10-10 with `arduino-cli` and Seeed nRF52 Boards 1.1.13 for `Seeeduino:nrf52:xiaonRF52840`, in both center modes, with no warnings from the sketch. The package's own GCC 9 toolchain is an Intel binary and did not run on the Apple Silicon build machine without Rosetta, so the check used Arm GNU Toolchain 13.3. The Arduino IDE on a machine that runs the package toolchain may still report something different.

The chord logic was also run on the host against mocked switch timelines (tilt, short tilt, diagonal, staggered push, long and double push, slow push, opposite pair).

The package's `adafruit-nrfutil` upload tool is also an Intel binary. On an Apple Silicon Mac without Rosetta, install the Python version (`pip install adafruit-nrfutil`, 0.5.3 was used) and point the package at it with a `platform.local.txt` next to its `platform.txt`:

```text
tools.nrfutil.cmd.macosx=/path/to/venv/bin/adafruit-nrfutil
```

The board's factory firmware did not answer the upload tool's reset request. Opening the serial port at 1200 baud put it into the bootloader, after which `adafruit-nrfutil dfu serial -pkg <sketch>.zip -p <port> -b 115200 --singlebank` programmed it.

## Bench test

Run on 2026-10-13 on a pre-soldered XIAO nRF52840, with the 6×6 mm switches on a breadboard, in chord mode, paired with a phone:

- Buttons A, B and C gave the expected short, long and double letters (A–I).
- The four directions sent arrow keys.
- The center chord, made by pressing three or four direction switches with a flat object, gave J (short), K (long) and L (double). A double press needs the second chord within 300 ms of releasing all directions of the first; the logged gaps were about 120 ms.

The board's bootloader reports itself as "XIAO nRF52840 Sense" (USB PID 0x0045), so the board used may be the Sense variant. The sketch was built for the plain XIAO nRF52840; D0–D10 are the same on both.

The advertised name was cut to `Open Rally Remo`: the advertising packet holds 15 name characters after the flags, TX power, appearance and HID service fields. The sketch now sends the name in the scan response, and the phone showed the full `Open Rally Remote` after pairing again.

## BLE OTA update

The sketch includes the Bluefruit `BLEDfu` service. A phone app writes to it, and the board restarts into the bootloader's legacy BLE OTA mode, where it advertises as `AdaDFU`. The bootloader is not changed.

The factory bootloader of the board used was read from flash on 2026-10-14:

- Adafruit UF2 bootloader 0.6.1, built 2021-11-12, Board-ID `Seeed_XIAO_nRF52840_Sense`.
- SoftDevice S140 7.3.0 (firmware ID `0x0123`).

The package is the `.zip` that `arduino-cli compile` writes next to the `.hex`. To update from an Android phone with nRF Connect for Mobile:

1. In **Settings > DFU options**, turn on **Disable MTU Request**, **Packet receipt notification** with 8 packets, and **Scan for bootloader in Legacy DFU**.
2. Disconnect the remote in the phone's Bluetooth settings, then connect to it from nRF Connect.
3. Tap **DFU**, choose "Distribution packet (ZIP)" and select the package.
4. After the update, refresh the services and read Software Revision in Device Information.

On 2026-10-14 this updated the application from `0.3.0-diagnostic` to a test build, `0.3.0-ota-test`, with the board on a USB charger and no computer. The phone then reconnected as a keyboard without pairing again. iOS has not been tested.

Known failure modes, all seen in this test:

- **MTU.** By default the app raises the MTU to 247, and each data packet carries up to 244 bytes. The 0.6.1 bootloader then loses data: with packet receipt notifications the transfer stalled at 1 %; without them it reached 100 % and failed validation. With the MTU request disabled, packets carry 20 bytes and the transfer completed. This matches [Adafruit bootloader issue #306](https://github.com/adafruit/Adafruit_nRF52_Bootloader/issues/306), a receive buffer that is too small.
- **Failed transfer.** The update is single bank: the bootloader erases the application first. After a failed transfer the board starts in the bootloader with no application. It then shows on USB as "XIAO nRF52840 Sense", and a USB upload restores it.
- **App still running.** After a cancelled update, nRF Connect's DFU service kept running on the phone. When the board was powered again, the phone sent it back into the bootloader, and the board did not advertise as `Open Rally Remote`. Force-stop the app after a cancelled update.
- **GATT cache.** Android caches the attribute table of a bonded device. After a build adds or moves a service, the phone reads the wrong handles. In nRF Connect, use **Refresh services**. A HID host with a stale cache may also fail; pair again if it does. Keep the attribute table the same between releases.
- **No authentication.** `BLEDfu` needs no pairing, and the bootloader accepts unsigned images. Anyone in range can reprogram the board. This is acceptable on the bench only.

The [OTAFIX fork of the bootloader](https://github.com/oltaco/Adafruit_nRF52_Bootloader_OTAFIX) also reports that older bootloaders do not start the new application after an OTA update while USB is connected to a computer. That case was not tested here.
