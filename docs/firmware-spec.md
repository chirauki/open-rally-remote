# Firmware Specification — First BLE HID Prototype

> Spanish version: [firmware-spec.es.md](firmware-spec.es.md).

**Status:** proposed implementation contract for the bench prototype. BLE pairing, key delivery, gesture timings, and every app profile remain unvalidated until tested with the purchased XIAO and real phones.

## 1. Purpose and scope

The first firmware should prove that the XIAO nRF52840 can read the temporary switches and operate as a Bluetooth remote with Android and iOS. It will expose standard keyboard input so supported apps can receive familiar key events. It will not depend on a companion phone app or a project-specific GATT service.

This is a bench prototype. It is not riding-ready and does not establish weather resistance, vibration resistance, or app compatibility.

## Product requirement: wireless firmware updates

The released remote must be updateable by the owner from an Android or iOS phone over Bluetooth LE, without connecting the remote to a computer. USB remains the power input; it must not be required as a data connection for routine updates.

The final hardware and firmware architecture must provide:

- A BLE DFU bootloader and a phone-based update workflow that is documented for both Android and iOS.
- A deliberate way to enter update mode, with the ordinary HID remote connection suspended during the update.
- Signed update packages, version/product checks, and a rollback-safe update design (preferably dual-bank: retain the last working image until the new image boots successfully).
- Recovery behavior for interrupted transfer or power loss. The device must not be left unusable if an update is interrupted; verify this experimentally before release.
- Publicly downloadable firmware packages and clear release notes. A dedicated companion app is not yet a requirement if an existing, maintained DFU app works on both phone platforms with the chosen bootloader.

### Important XIAO bootloader check

The XIAO is the right board for the first HID prototype, but do not assume its factory bootloader can perform BLE OTA updates. In a 2025 public response, Seeed said it did not have an official solution or documentation for Bluetooth DFU on the XIAO nRF52840. Treat OTA on this purchased XIAO as an investigation, not an available feature. Before choosing the final controller, verify the bootloader, update package format, Android app, iOS app, image authentication, and recovery path together.

Nordic provides a mobile DFU app for Android and iOS for nRF5 SDK bootloaders. Its documentation distinguishes that flow from nRF Connect SDK firmware, which uses the nRF Connect Device Manager app. Adafruit's nRF52 bootloader is another technical reference: it describes BLE OTA, signed updates, and optional dual-bank updates, but the XIAO is not listed among its officially supported boards. Porting a bootloader or changing the final controller may therefore be necessary. See [Nordic DFU mobile app](https://www.nordicsemi.com/Products/Development-tools/nRF-Device-Firmware-Update), [Nordic FOTA guide](https://nrfconnectdocs.nordicsemi.com/ncs/latest/nrf/app_dev/device_guides/nrf52/fota_update.html), [Seeed's XIAO bootloader discussion](https://github.com/Seeed-Studio/wiki-documents/discussions/2071), and [Adafruit nRF52 bootloader](https://github.com/adafruit/Adafruit_nRF52_Bootloader).

A bench test on 2026-10-14 checked the factory bootloader of the purchased board. It is the Adafruit UF2 bootloader 0.6.1 (built 2021-11-12, Board-ID `Seeed_XIAO_nRF52840_Sense`) with SoftDevice S140 7.3.0, and it contains Adafruit's legacy BLE OTA mode. With the sketch's `BLEDfu` service, nRF Connect for Android updated the application over BLE without a computer, after one setting change. The details, settings and failure modes are in the [firmware README](../firmware/xiao-nrf52840/README.md#ble-ota-update). This does not meet the product requirement above: the factory bootloader accepts unsigned images, updates in a single bank, and leaves the board without an application after a failed transfer. iOS has not been tested.

Do not replace or modify the XIAO bootloader during the initial BLE HID bring-up. First establish the input and navigation behavior, then test OTA on a spare development board so a failed bootloader experiment cannot interrupt the main prototype.

## 2. Development setup and upload workflow

The first firmware will be written and uploaded with **Arduino IDE 2** on a computer. The XIAO connects over a USB-C data cable; no separate programmer is required. Arduino IDE compiles the sketch for the selected XIAO board and uploads it over USB. Its Serial Monitor can show GPIO and BLE diagnostics during development.

1. Install and open [Arduino IDE](https://www.arduino.cc/en/software/).
2. In the IDE settings, add Seeed's board index URL: `https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json`.
3. Open Boards Manager, search for **Seeed nRF52 Boards**, and install it. Seeed recommends this board package for the XIAO's Bluetooth functions; use the standard nRF52 package rather than the mbed-enabled package for this BLE prototype.
4. Connect the pre-soldered XIAO to the computer with a USB-C **data** cable.
5. Select **Seeed XIAO nRF52840** under the Seeed nRF52 boards and choose the port that appears for the board.
6. Open the project's `.ino` sketch, use **Verify** to compile, then **Upload** to flash it. Pair the remote from the phone's Bluetooth settings after the HID firmware is running.

The bench sketch is at [firmware/xiao-nrf52840/open-rally-remote.ino](../firmware/xiao-nrf52840/open-rally-remote.ino). It uses the Seeed nRF52 board package and its bundled Bluefruit HID API. It implements the center chord and the three profiles of section 7, and has been tested on the purchased XIAO with an Android phone.

Seeed's [XIAO nRF52840 guide](https://wiki.seeedstudio.com/XIAO_BLE/) documents Arduino IDE setup and the board package. Arduino's [IDE 2 board manager tutorial](https://docs.arduino.cc/software/ide-v2/tutorials/ide-v2-board-manager/) explains installing board support packages.

## 3. Bluetooth transport

- Implement the Bluetooth SIG **HID over GATT Profile (HOGP)** as a BLE peripheral.
- Present as a standard keyboard HID device; phones act as the BLE central and HID host.
- Use the standard keyboard report protocol with key-down and key-up reports. Do not send text strings or app-specific proprietary packets.
- Start with one bonded phone at a time. Reconnect to the last bonded host after power-up. Provide a documented way to clear the bond during development; choose the physical reset gesture after the first bench test.
- Use a stable, recognizable device name such as `Open Rally Remote` and a distinct manufacturer/product string if the selected library supports it.
- The current Seeed/Bluefruit `BLEHidAdafruit` convenience class uses a stock HID descriptor that includes keyboard, Consumer Control, and mouse collections. The sketch sends keyboard reports only; since firmware 0.9.0 no profile sends Consumer Control (media) reports, and it does not send mouse or gamepad data. If the extra advertised collections affect phone pairing or app compatibility, replace this helper with a keyboard-only HID descriptor before treating the transport as validated. Do not add a custom GATT service to the first build.

HOGP is the Bluetooth SIG profile for exposing HID input over BLE/GATT. Android documents BLE central/GATT support, and OsmAnd documents keyboard input on Android and iOS. Those facts make this a sensible first path, but they do not guarantee every key or gesture works identically on every phone. See [Bluetooth SIG HOGP](https://www.bluetooth.com/specifications/specs/hid-over-gatt-profile-hogp/), [Android BLE overview](https://developer.android.com/develop/connectivity/bluetooth/ble/ble-overview), and [OsmAnd external input devices](https://www.osmand.net/docs/user/map/interact-with-map/).

## 4. Inputs and electrical behavior

V0.26 (the [control board](../electronics/control-pcb/README.md), firmware option `BOARD_V026`):

| XIAO pin | Use |
|---|---|
| D0 (A0) | Battery voltage, 1 MΩ / 1 MΩ divider |
| D1, D2, D3 | Buttons A, B, C (switch to GND) |
| D4, D5, D6, D7 | Joystick up, down, left, right (switch to GND) |
| D8 | Charger STAT through a divider: low while charging, high when done |
| D9 | Charging-port VBUS through a divider; System OFF wake source |
| D10 | Spare |
| 3V3 | Supply in, from the control board's regulator |

V0.25 and the breadboard:

| XIAO pin | Input | Released | Pressed |
|---|---|---|---|
| D0 | Button A | HIGH | LOW |
| D1 | Button B | HIGH | LOW |
| D2 | Button C | HIGH | LOW |
| D3 | Joystick up | HIGH | LOW |
| D4 | Joystick down | HIGH | LOW |
| D5 | Joystick left | HIGH | LOW |
| D6 | Joystick right | HIGH | LOW |
| D7 | Not used (reserved) | — | — |
| D8 | Charge LED output (V0.24), active high | — | — |

Configure every connected input as `INPUT_PULLUP`. A closed switch joins the input to GND. Do not connect a switch input to 3.3 V or 5 V. D7 is not connected in the V0.22/V0.23 hardware and must be ignored.

The joystick has no separate center switch. Its stick sits on four C&K KSC2 switches (see the [joystick PCB](../electronics/joystick-pcb/README.md)); tilting closes one switch, or two adjacent ones on a diagonal, and pushing the stick straight in closes all four. The knob reaches its push stop only after every switch has tripped, so a full push always closes all four. The firmware derives the center input from this chord (section 5).

D8 drives the charge LED on the [USB-C charging PCB](../electronics/usbc-pcb/README.md) through a 1 kΩ resistor; it is an output, not an input. It is high only while a charger is connected and the charger's `CHG` signal (P0.17, active low) shows charging. Power off, auto-off, wake and the charge LED are specified in the [battery study](battery-study.md#firmware).

The final hardware may use a different pin map. Keep the pin assignments in one configuration table so they can be changed without rewriting input and HID logic.

## 5. Input processing and gesture rules

These values are initial tunable settings, not final ergonomic decisions:

| Setting | Initial value | Behavior |
|---|---:|---|
| Scan interval | 5–10 ms | Sample all inputs from one non-blocking loop or equivalent task. |
| Debounce | 30 ms | Accept a new stable state only after it remains unchanged for this interval. |
| Long-press threshold | 600 ms; 2 s for the TerraPirata buttons | Emit one long-press action when the control remains pressed for this duration. TerraPirata's long presses reset a counter, so they take longer. |
| Double-press window | 300 ms | Two short presses of the same control inside the window produce one double-press action. |

In the keyboard profile, Buttons A, B and C do not use gestures: each holds one key for as long as it is pressed (section 7). DMD2 times short and long presses itself, and a firmware gesture sent as a separate key was not usable. The TerraPirata and gestures profiles, and the derived center input, use this state machine:

1. On a debounced press, record the start time; do not emit a key yet when short/double discrimination is active.
2. If the control is still down at the long-press threshold, emit its long action once. Suppress short and double actions for that press.
3. If it is released before the threshold, wait for the double-press window. A second debounced press of the same control inside the window cancels the pending short action and emits one double action after that second press is released (unless it becomes a long press).
4. If the window expires without a second press, emit one short action.
5. A second press of a different control does not cancel the first control's pending short action.

This means a short action can be delayed by up to the double-press window. A control with no double action in the selected profile emits its short action on release (TerraPirata's Button C). Record any profile-specific exception in the mapping table.

Center chord: treat the center as pressed when at least three direction inputs are closed, and released when none is. When a direction first closes, hold its key-down for a chord window (initially 40 ms, tunable). If three or more directions close inside the window, report the center press instead and send no direction keys until all four are released. Otherwise send the held directions as usual. Two opposite directions closed together can only come from a push, so they also suppress direction keys. The window delays direction key-down by up to its length; measure whether that is noticeable on hardware.

Joystick directions are held inputs: send the mapped key-down while the direction is held and the matching key-up on release. Do not synthesize repeated key-down reports in firmware. The host/app may repeat a held key; test whether this produces useful map panning and document device-specific behavior. Opposite directions pressed together should cancel each other. Other simultaneous directions must not corrupt the HID report.

Do not block the input scan while waiting for a gesture timeout. Keep a separate state and timer for each gesture-capable control so buttons can be used independently.

## 6. HID report behavior and reliability

- Every discrete action is a complete key press followed by a key release. Never leave a key logically held after a tap.
- Send a release report after each discrete press. Send an all-keys-released report after disconnect, profile change, reset, or any input-state recovery event.
- For held joystick directions, track each held direction and send the current set of keys, not unrelated successive key presses.
- Use a standard keyboard report with at least six-key rollover. The controls should not normally require more than four simultaneous direction keys, but verify combinations and gracefully handle the report limit.
- Do not emit a key repeatedly while a physical button or direction remains held. A held key is one key-down report; the host may repeat it, and TerraPirata uses that to adjust the trip faster with the joystick.
- Ignore input events while BLE is disconnected, then resume cleanly after reconnect. Do not queue old actions for later delivery.
- Avoid unnecessary flash writes. Store profile/configuration only when it changes.

## 7. Profiles and mappings

Bench tests on 2026-10-14 and 2026-10-20 with Android showed that one key map cannot serve every app:

- TerraPirata reacts to arrow keys, to media keys (Consumer Control) and to some letters and function keys: `x` locks the screen, `r` opens the trip reset, `z` and Play/Pause reset the total, F6/F7 scroll the roadbook, Volume +/− adjust the trip (see the [control mapping](control-mapping.md#keys-terrapirata-reacts-to)). It ignored Page Up/Down. Space opened its "Delete map data" dialog.
- OsmAnd accepts only keyboard keys for its key assignments, not media keys.
- DMD2 times long presses itself: it needs the key held, not a separate key for the long press.

The firmware therefore has three profiles. The joystick directions send held arrow keys in all of them.

| Profile | LED | Buttons A, B, C | Joystick center |
|---|---|---|---|
| TerraPirata | Green | A long (2 s): `r` (trip reset, confirmed on the screen); B long (2 s): `z` (reset the total); C short: `x` (screen lock); short and double presses of A and B send nothing | Nothing |
| Keyboard, for DMD2 | Blue | Held: `A`, `B`, `C`; the app times short and long | `D` on a short or double press |
| Gestures, for OsmAnd | White | Short/long/double: `A`/`B`/`C`, `D`/`E`/`F`, `G`/`H`/`I` | Short `J`, double `L` |

Holding the joystick center for 5 s selects the next profile (green, blue, white, then green again), stores it in flash and restarts the board. The center has no long action in any profile, because a long hold switches the profile. The XIAO's LED blinks 100 ms every 10 s in the profile's color. The BLE name does not change: Android keeps the name it saw when pairing, so a per-profile name was not visible.

In the TerraPirata profile the joystick adjusts the trip (left/right) and scrolls the roadbook (up/down) with held arrows.

Avoid Space, Enter and Tab in any profile: Android uses them to press the focused on-screen control. Avoid media keys too: they reach whichever app is in front and change the phone's volume or playback. Firmware 0.8.0 used them in the TerraPirata profile; 0.9.0 does not.

### Mapping limits to preserve

- **TerraPirata:** the trip reset opens a dialog that is accepted on the screen; no key that accepts it has been found. The key for hiding the hundreds digits is unknown. TerraPirata's dedicated remote mode is not documented publicly; the keys used here work without changing a setting.
- **OsmAnd:** it assigns one action per key, so the gestures profile sends a separate letter for each gesture. The short press is delayed by the 300 ms double-press window. With held keys, Android repeats the key and a toggle action may repeat; use the gestures profile instead.
- **DMD² / DMD Next:** short and long actions per key are set in DMD's Generic Remote mapping; with held keys, DMD² recognized the long press on the bench. Do not promise native double-tap behavior. DMD² is Android-only according to its current FAQ.
- **iOS** is deferred. It may need different keys: iOS handles the volume keys itself, which is likely why TerraPirata asks iPhone users for a dedicated remote mode or its compatibility mode.

The profile switch was agreed for the bench prototype. A 5 s hold is hard to trigger by accident, but test it on the bike before treating it as safe while riding. The enclosure must let the LED show, or the rider cannot see the profile; see the [mechanical notes](mechanical-concept.md).

## 8. Initial implementation phases

1. **GPIO and BLE proof:** upload the [initial diagnostic sketch](../firmware/xiao-nrf52840/README.md), pair Android and iOS separately, and confirm every connected switch reports the expected key. Validate active-low behavior, the center chord, and key release.
2. **Gesture proof:** measure short/long/double recognition with the temporary switches. Adjust timings only after the initial values have been observed on hardware.
3. **Reliability check:** test reconnect, held arrows, opposing direction cancellation, and release behavior after disconnect.
4. **App mapping:** implement semantic profiles and bind tested HID usages to each action. Keep unverified bindings marked experimental.
5. **Bench compatibility:** complete the [validation matrix](control-mapping.md#bench-validation-matrix) and record phone, OS, app version, profile, actual key event, and action result.

## 9. Validation checklist

| Area | Pass condition | Android | iOS |
|---|---|---|---|
| Pairing | Appears as a keyboard/HID remote, pairs, and reconnects to the bonded phone | Pending | Pending |
| Input scan | Each of D0–D6 works once; D7 is ignored | Pending | Pending |
| Debounce | One press produces one event; switch bounce produces no duplicates | Pending | Pending |
| HID release | Every discrete key has a matching release; disconnect cannot leave a key stuck | Pending | Pending |
| Directions | Held arrows pan as expected; release stops movement; opposing directions cancel | Pending | Pending |
| Gestures | Short, long, and double are distinct at the chosen thresholds; no dropped/doubled action | Pending | Pending |
| TerraPirata | Each mapped action works | Pass, firmware 0.9.0 (2026-10-20) | Pending |
| OsmAnd | A/D, B/+, C/−, arrows, and center/C perform the intended actions | Pending | Pending |
| DMD² | A follow, B zoom in, C zoom out, and joystick pan work through Generic Remote mapping | Pending | N/A |
| Center chord | A straight push gives one center event and no direction keys; tilts and diagonals give no center event | Pending | Pending |
| Power off | A + B + C held 3 s sleeps after release, with no gesture events; any button then wakes it | Bench pass on USB, 2026-10-14; the first button's key is sent in the keyboard profile (held keys) | Pending |
| Auto-off | Sleeps after 6 h without input and without a charger (test with a shortened timeout) | Bench pass on USB with a 60 s timeout, 2026-10-14 | Pending |
| Charge LED | Charger in: wakes from System OFF and the LED lights; LED goes out when charging ends and when the charger is removed | Pending | Pending |

## Product OTA validation checklist

| Test | Pass condition | Android | iOS |
|---|---|---|---|
| Phone-only update | Install a published update package over BLE without a computer or USB data connection | Bench pass with the factory bootloader, 2026-10-14 | Pending |
| Image authentication | Reject an unsigned, corrupted, or wrong-product image | Fail with the factory bootloader: it accepted an unsigned image | Pending |
| Interrupted transfer | Disconnect BLE or remove power during transfer; recover automatically to the existing or update-ready state | Fail with the factory bootloader: two stalled transfers left no application; recovered over USB | Pending |
| Failed first boot | A broken new application image rolls back to the previous working firmware | Pending | Pending |
| Version handling | Reject downgrade or incompatible version unless a deliberate recovery procedure is used | Pending | Pending |
| Normal use after update | Reconnect as a HID remote and retain the user's selected profile and settings | HID reconnected without pairing again; profile retention after OTA not yet tested | Pending |

## References

- [Seeed Studio: XIAO nRF52840 Arduino setup and examples](https://wiki.seeedstudio.com/XIAO_BLE/)
- [Arduino: IDE 2 board manager tutorial](https://docs.arduino.cc/software/ide-v2/tutorials/ide-v2-board-manager/)
- [Nordic: nRF Device Firmware Update mobile app](https://www.nordicsemi.com/Products/Development-tools/nRF-Device-Firmware-Update)
- [Nordic: FOTA update on nRF52](https://nrfconnectdocs.nordicsemi.com/ncs/latest/nrf/app_dev/device_guides/nrf52/fota_update.html)
- [Seeed: public XIAO nRF52840 Bluetooth DFU discussion](https://github.com/Seeed-Studio/wiki-documents/discussions/2071)
- [Adafruit: nRF52 bootloader and OTA features](https://github.com/adafruit/Adafruit_nRF52_Bootloader)
- [Bluetooth SIG: HID over GATT Profile](https://www.bluetooth.com/specifications/specs/hid-over-gatt-profile-hogp/)
- [Android Developers: Bluetooth Low Energy overview](https://developer.android.com/develop/connectivity/bluetooth/ble/ble-overview)
- [OsmAnd: external input devices and keyboard key assignments](https://www.osmand.net/docs/user/map/interact-with-map/)
- [TerraPirata: Bluetooth remote compatibility](https://terrapirata.com/bluetooth-remotes/)
- [HesaParts NAVCOMM user manual](https://hesaparts.com/wp-content/uploads/2025/02/EN/NAVCOMM%20USER%20MANUAL.pdf)
- [DMD²: devices and generic remotes](https://docs.dmdnavigation.com/dmdnext/devices/)
- [DMD² FAQ: generic-remote behavior](https://docs.dmdnavigation.com/faq/)
