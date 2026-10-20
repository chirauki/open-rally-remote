# XIAO nRF52840 Bench Firmware

> Spanish version: [README.es.md](README.es.md).

This folder contains the bench firmware for the Seeed XIAO nRF52840. It reads the switches and acts as a BLE HID keyboard, with a TerraPirata profile, a keyboard profile with held keys for DMD2, and a gestures profile for OsmAnd. It is for bench testing only and is not suitable for use while riding.

## Upload

Follow the [development environment guide](../../docs/development-environment.md), then open `open-rally-remote.ino` in Arduino IDE 2. Select **Seeed XIAO nRF52840** and the XIAO's USB port, then click **Verify** and **Upload**.

The sketch uses the `Seeed nRF52 Boards` package and its bundled Adafruit Bluefruit BLE HID library. It also includes `Adafruit_TinyUSB.h` to support the XIAO's USB serial diagnostics with this board package.

## Wiring

Wire each normally-open switch between its GPIO and GND:

| XIAO pin | Input | TerraPirata profile (short / long, 2 s) | Keyboard profile | Gestures profile, for OsmAnd (short / long / double) |
|---|---|---|---|---|
| D0 | Button A | — / `r` (trip reset dialog) | Hold `A` | `D` orientation / `N` navigation / `P` next app profile |
| D1 | Button B | — / `z` (reset the total) | Hold `B` | `-` zoom out / `S` search / — |
| D2 | Button C | `x` (lock or unlock the screen) / — | Hold `C` | `=` zoom in / `x` screen lock / — |
| D3 | Joystick up | Hold Up Arrow | Hold Up Arrow | Hold Up Arrow |
| D4 | Joystick down | Hold Down Arrow | Hold Down Arrow | Hold Down Arrow |
| D5 | Joystick left | Hold Left Arrow | Hold Left Arrow | Hold Left Arrow |
| D6 | Joystick right | Hold Right Arrow | Hold Right Arrow | Hold Right Arrow |
| D7 | Joystick center switch, breadboard only | Nothing | `D` on a short or double press | `C` my position |

In the keyboard profile and on the joystick, a held key goes down when the switch closes and up when it opens; the app times short and long presses itself. In the TerraPirata and gestures profiles, the firmware sends a 50 ms tap of a separate key for each button gesture. In the TerraPirata profile a long press takes 2 s (`RESET_LONG_PRESS_MS`), because both long presses reset a counter. A control with no double press sends its short tap as soon as it is released (TerraPirata's C; the gestures profile's B, C and center); the others wait out the 300 ms double-press window. The gestures profile sends the keys of OsmAnd's built-in "Keyboard" device type, plus `x`, which needs a custom type in OsmAnd; see the [control mapping](../../docs/control-mapping.md#osmand-android-and-ios). Holding the joystick center for 5 s switches the profile; see [Profiles](#profiles).

The V0.22/V0.23 hardware has no D7 switch: pushing the stick straight in closes all four direction switches, and the sketch reads three or more closed together as the center press (see the [firmware specification](../../docs/firmware-spec.md#5-input-processing-and-gesture-rules)). This is the default, `CENTER_FROM_CHORD = true`, and D7 is then not read. For the breadboard, where a straight push cannot be made, set `CENTER_FROM_CHORD` to `false` near the top of the sketch to read a separate center switch on D7.

In chord mode, a direction key-down is held back for the 40 ms chord window (`CHORD_WINDOW_MS`) after the first direction closes:
- If three or more directions close inside the window, the sketch reads the center press and sends no arrow key until all directions are released.
- If two opposite directions are closed, no arrow key is sent.
- A tilt released inside the window is sent as one arrow tap.
- A push slower than the window first sends the arrow of the first switch, then releases it and reads the center press.

All connected pins use `INPUT_PULLUP`: open/released reads HIGH, pressed reads LOW. Do not connect an input to 3.3 V or 5 V.

## First test

1. Upload the sketch and open the Serial Monitor at 115200 baud.
2. Pair **Open Rally Remote** from the phone's Bluetooth settings.
3. Switch to the gestures profile (white LED), open a keyboard tester or a harmless text field, then press each control. The keys identify the gestures; joystick directions send held arrow-key reports.
4. On the joystick, confirm that a straight push gives one center `C` and no arrow key, and that tilts and diagonals give no center press.

Short presses of controls with a double press are delayed by the 300 ms double-press window. Initial timings are set near 30 ms debounce, 600 ms long press, 300 ms double press, 40 ms chord window and 50 ms key-down duration for taps. With the chord window, an arrow key-down follows the switch by about 70 ms.

Do not test this firmware in an app while riding. BLE updates work on the bench; see [BLE OTA update](#ble-ota-update).

## Profiles

The profile is stored in the XIAO's flash (`/profile` in its internal file system) and survives a power cycle. The first start uses the TerraPirata profile.

- **Switch:** hold the joystick center for 5 s (`PROFILE_SWITCH_MS`). The board stores the next profile (TerraPirata, keyboard, gestures, then TerraPirata again) and restarts. The phone reconnects without pairing again.
- **Indication:** the XIAO's RGB LED, next to the USB-C connector, blinks 100 ms every 10 s: green for TerraPirata, blue for keyboard, white for gestures. The LED is active low.
- **Name:** all profiles advertise as `Open Rally Remote`. Android keeps the name it saw when pairing, so a per-profile name was not shown.

The Bluefruit library's connection LED is turned off: it drives the blue LED with the opposite polarity on this board, so it never lit.

The profile choices come from the app tests in the [firmware specification](../../docs/firmware-spec.md#7-profiles-and-mappings) and the [control mapping](../../docs/control-mapping.md).

## V0.26 control board

`BOARD_V026` (default `false`) selects the [V0.26 control board](../../electronics/control-pcb/README.md), on which the XIAO plugs into two female headers and takes its 3.3 V from the board's own regulator. The pin map moves:

| XIAO pin | BOARD_V026 = false (breadboard, V0.25) | BOARD_V026 = true (V0.26) |
|---|---|---|
| D0 | Button A | Battery voltage (A0, 1 MΩ / 1 MΩ divider) |
| D1–D3 | Button B, Button C, joystick up | Buttons A, B, C |
| D4–D6 | Joystick down, left, right | Joystick up, down, left |
| D7 | Centre switch (breadboard option) | Joystick right |
| D8 | Charge LED output | Charger STAT through a divider: low while charging, high when done |
| D9 | — | Charging-port VBUS through a divider; also a System OFF wake source |

With `BOARD_V026 = true` the firmware leaves P0.13, P0.14 and the XIAO's charger alone, does not drive a charge LED (the charger's STAT does), and reads "charger present" from D9 instead of the nRF52840's USB detection. The centre press must come from the chord (`CENTER_FROM_CHORD = true`); a compile-time check enforces it. Both settings compiled on 2026-10-14 with no warnings from the sketch; the `true` build has not run on a board yet.

From the 2026-10-15 board review: with no cell fitted, the charger's STAT is high impedance and the board's divider pulls D8 low, so `charging()` reads true; and the charger only ends a charge when the XIAO's average load stays under about 5.6 mA, because it measures its whole output current (see "Charge termination" in the [control board README](../../electronics/control-pcb/README.md)). Measure the awake current on USB before relying on the charge LED going out.

## Power and battery

These follow the [battery study](../../docs/battery-study.md#firmware). The constants are near the top of the sketch.

- **Battery level:** read every 60 s from P0.31 (AIN7) with P0.14 low, averaged over 8 samples. The divider is 1 MΩ over 510 kΩ (`VBAT_DIVIDER`, from Seeed's schematic); calibrate the reading with a multimeter. The level goes to the phone over the BLE Battery Service, added after the HID service so the existing attribute handles do not move. Below 3.5 V the profile blink turns red; below 3.3 V without USB, the board goes to System OFF.
- **P0.14:** kept low from the first line of `setup()`. The Seeed core drives it high at start, and Seeed warns that P0.31 can then reach its 3.6 V limit while charging.
- **Charging:** about 50 mA by default; `HIGH_CHARGE_CURRENT` selects about 100 mA. D8 drives the charge LED while USB is present and `CHG` (P0.17) is low.
- **Power off:** hold A, B and C together for 3 s. The LED turns steady red; the board sleeps when all three are released. While two or more are held, the buttons send nothing, but in the keyboard profile the first button's key is already sent. In the TerraPirata profile nothing is sent: A and B act only after 2 s, and C on release.
- **Auto-off:** after 6 h without input (`AUTO_OFF_MS`).
- **Wake:** any released switch, through GPIO sense, or a charger connection. The wake press is not sent.
- **USB:** while USB power is present, the board does not sleep (power off, auto-off or low battery). For bench tests, `SLEEP_ON_USB = true` lets it sleep on USB.

## Build check

The sketch was compiled on 2026-10-10 with `arduino-cli` and Seeed nRF52 Boards 1.1.13 for `Seeeduino:nrf52:xiaonRF52840`, in both center modes, with no warnings from the sketch. The package's own GCC 9 toolchain is an Intel binary and did not run on the Apple Silicon build machine without Rosetta, so the check used Arm GNU Toolchain 13.3. The Arduino IDE on a machine that runs the package toolchain may still report something different.

The sketch also builds and runs on a computer, with simulated switches, clock and BLE link: `make -C firmware/xiao-nrf52840/test` runs host tests of the profiles, gestures, joystick chord, profile switch, power off and reconnect on both boards. See the [test README](test/README.md).

The package's `adafruit-nrfutil` upload tool is also an Intel binary. On an Apple Silicon Mac without Rosetta, install the Python version (`pip install adafruit-nrfutil`, 0.5.3 was used) and point the package at it with a `platform.local.txt` next to its `platform.txt`:

```text
tools.nrfutil.cmd.macosx=/path/to/venv/bin/adafruit-nrfutil
```

The board's factory firmware did not answer the upload tool's reset request. Opening the serial port at 1200 baud put it into the bootloader, after which `adafruit-nrfutil dfu serial -pkg <sketch>.zip -p <port> -b 115200 --singlebank` programmed it.

## Bench tests

### Inputs and pairing

Run on 2026-10-13 on a pre-soldered XIAO nRF52840, with the 6×6 mm switches on a breadboard, in chord mode, paired with a phone:

- Buttons A, B and C gave the expected short, long and double letters (A–I) of the diagnostic key map used then.
- The four directions sent arrow keys.
- The center chord, made by pressing three or four direction switches with a flat object, gave J (short), K (long) and L (double). A double press needs the second chord within 300 ms of releasing all directions of the first; the logged gaps were about 120 ms.

The board's bootloader reports itself as "XIAO nRF52840 Sense" (USB PID 0x0045), but the board is the plain XIAO nRF52840: its shield label reads "Model: XIAO-nRF52840", with no "Sense", and the IMU footprint on the top is empty. Why the bootloader uses the Sense name was not found. The sketch is built for the plain XIAO nRF52840; D0–D10 are the same on both.

### App profiles

The TerraPirata profile changed in firmware 0.9.0; see [Firmware 0.9.0](#firmware-090). Run on 2026-10-14 with an Android phone. The firmware first sent a different candidate key for each gesture, then held keys on the buttons:

| Key | TerraPirata |
|---|---|
| Up / Down Arrow | Scrolls the roadbook |
| Left / Right Arrow | Adjusts the trip; faster when held |
| Volume + / − | Adjusts the trip; faster when held |
| Play/Pause | Resets the total trip |
| Next / Previous Track | Scrolls the roadbook down / up |
| Page Down / Page Up | Nothing |
| Mute | The phone muted and unmuted |
| Space | Opened the "Delete map data" dialog |

OsmAnd did not accept media keys in its key assignment; it accepted the letters of the gestures profile. DMD2 timed long presses itself, so a separate key for the firmware's long press could not be used; with the keyboard profile's held keys, DMD2 recognized the long press. Enter, Escape and Tab were not tried: like Space, they can press the focused on-screen control. The phone reconnected after each profile switch, and the LED showed the stored profile after a restart, in all three colors.

### Power off and wake

Run on 2026-10-14 on USB, without a cell, with `SLEEP_ON_USB = true` and `AUTO_OFF_MS` at 60 s:

- The auto-off entered System OFF 60 s after the last input.
- B + C + A held 3 s armed the power off (steady red LED), and the board slept when the buttons were released.
- A button or joystick switch woke the board; the press was not sent, and the phone reconnected within about 1 s of the restart.

Without a cell, the battery reading floats (3.7 to 4.1 V were logged) and means nothing.

### Firmware 0.8.0

Run on 2026-10-14 on the breadboard build (`BOARD_V026 = false`): the firmware still worked in the two profiles tried. Which inputs were pressed was not recorded, and the third profile was not tried.

### Firmware 0.9.0

Run on 2026-10-20 on the breadboard build (`BOARD_V026 = false`), in the TerraPirata profile, with an Android phone. The serial log showed each gesture and its key:

- Joystick left and right lowered and raised the trip; up and down scrolled the roadbook.
- C sent `x` and locked, then unlocked, the screen.
- A held 2 s sent `r` and opened the "reset odometer" dialog; accepting it on the screen set the trip to zero.
- B held 2 s sent `z` and reset the total.
- Short and double presses of A and B sent nothing.

The keys came from the [key probe](../key-probe/README.md); see the [control mapping](../../docs/control-mapping.md#terrapirata-rally-roadbooks). Both builds (`BOARD_V026` false and true) compiled with no warnings from the sketch.

### Firmware 0.10.0

Run on 2026-10-20 on the breadboard build, in the gestures profile, with OsmAnd on an Android phone and a custom external device type with the keys assigned. The serial log showed each key: B and C zoomed out and in, C held locked and unlocked the screen (`x` assigned to "Touch screen lock"), the center moved the map to the position, A short and long changed the orientation and showed the navigation, and the joystick panned the map. A double (`P`) switched to the next app profile and B long (`S`) opened the search, in an earlier run.

### BLE name

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

On 2026-10-14 this updated the application from `0.3.0-diagnostic` to a test build, `0.3.0-ota-test`, with the board on a USB charger and no computer. The phone then reconnected as a keyboard without pairing again. A second update, back to `0.3.0-diagnostic`, was made with the board connected to a computer over USB. The 115460-byte image took 35.8 s, about 3.2 kB/s; validation passed and the board started the new application without a manual reset. iOS has not been tested.

Known failure modes, all seen in this test:

- **MTU.** By default the app raises the MTU to 247, and each data packet carries up to 244 bytes. The 0.6.1 bootloader then loses data: with packet receipt notifications the transfer stalled at 1 %; without them it reached 100 % and failed validation. With the MTU request disabled, packets carry 20 bytes and the transfer completed. This matches [Adafruit bootloader issue #306](https://github.com/adafruit/Adafruit_nRF52_Bootloader/issues/306), a receive buffer that is too small.
- **Failed transfer.** The update is single bank: the bootloader erases the application first. After a failed transfer the board starts in the bootloader with no application. It then shows on USB as "XIAO nRF52840 Sense", and a USB upload restores it.
- **App still running.** After a cancelled update, nRF Connect's DFU service kept running on the phone. When the board was powered again, the phone sent it back into the bootloader, and the board did not advertise as `Open Rally Remote`. Force-stop the app after a cancelled update.
- **GATT cache.** Android caches the attribute table of a bonded device. After a build adds or moves a service, the phone reads the wrong handles. In nRF Connect, use **Refresh services**. A HID host with a stale cache may also fail; pair again if it does. Keep the attribute table the same between releases.
- **No authentication.** `BLEDfu` needs no pairing, and the bootloader accepts unsigned images. Anyone in range can reprogram the board. This is acceptable on the bench only.

The [OTAFIX fork of the bootloader](https://github.com/oltaco/Adafruit_nRF52_Bootloader_OTAFIX) also reports that older bootloaders do not start the new application after an OTA update while USB is connected to a computer. This did not happen with the 0.6.1 bootloader in the test above.
