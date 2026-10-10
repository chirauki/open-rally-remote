# Firmware Specification — First BLE HID Prototype

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

Do not replace or modify the XIAO bootloader during the initial BLE HID bring-up. First establish the input and navigation behavior, then test OTA on a spare development board so a failed bootloader experiment cannot interrupt the main prototype.

## 2. Development setup and upload workflow

The first firmware will be written and uploaded with **Arduino IDE 2** on a computer. The XIAO connects over a USB-C data cable; no separate programmer is required. Arduino IDE compiles the sketch for the selected XIAO board and uploads it over USB. Its Serial Monitor can show GPIO and BLE diagnostics during development.

1. Install and open [Arduino IDE](https://www.arduino.cc/en/software/).
2. In the IDE settings, add Seeed's board index URL: `https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json`.
3. Open Boards Manager, search for **Seeed nRF52 Boards**, and install it. Seeed recommends this board package for the XIAO's Bluetooth functions; use the standard nRF52 package rather than the mbed-enabled package for this BLE prototype.
4. Connect the pre-soldered XIAO to the computer with a USB-C **data** cable.
5. Select **Seeed XIAO nRF52840** under the Seeed nRF52 boards and choose the port that appears for the board.
6. Open the project's `.ino` sketch, use **Verify** to compile, then **Upload** to flash it. Pair the remote from the phone's Bluetooth settings after the HID firmware is running.

An initial diagnostic sketch is now available at [firmware/xiao-nrf52840/open-rally-remote.ino](../firmware/xiao-nrf52840/open-rally-remote.ino). It uses the Seeed nRF52 board package and its bundled Bluefruit HID keyboard API. It is a starting point. It compiles and implements the center chord below, but has not yet been checked on the purchased hardware.

Seeed's [XIAO nRF52840 guide](https://wiki.seeedstudio.com/XIAO_BLE/) documents Arduino IDE setup and the board package. Arduino's [IDE 2 board manager tutorial](https://docs.arduino.cc/software/ide-v2/tutorials/ide-v2-board-manager/) explains installing board support packages.

## 3. Bluetooth transport

- Implement the Bluetooth SIG **HID over GATT Profile (HOGP)** as a BLE peripheral.
- Present as a standard keyboard HID device; phones act as the BLE central and HID host.
- Use the standard keyboard report protocol with key-down and key-up reports. Do not send text strings or app-specific proprietary packets.
- Start with one bonded phone at a time. Reconnect to the last bonded host after power-up. Provide a documented way to clear the bond during development; choose the physical reset gesture after the first bench test.
- Use a stable, recognizable device name such as `Open Rally Remote` and a distinct manufacturer/product string if the selected library supports it.
- The current Seeed/Bluefruit `BLEHidAdafruit` convenience class uses a stock HID descriptor that includes keyboard, Consumer Control, and mouse collections. The diagnostic sketch sends keyboard reports only; it does not send media, mouse, or gamepad data. If the extra advertised collections affect phone pairing or app compatibility, replace this helper with a keyboard-only HID descriptor before treating the transport as validated. Do not add a custom GATT service to the first build.

HOGP is the Bluetooth SIG profile for exposing HID input over BLE/GATT. Android documents BLE central/GATT support, and OsmAnd documents keyboard input on Android and iOS. Those facts make this a sensible first path, but they do not guarantee every key or gesture works identically on every phone. See [Bluetooth SIG HOGP](https://www.bluetooth.com/specifications/specs/hid-over-gatt-profile-hogp/), [Android BLE overview](https://developer.android.com/develop/connectivity/bluetooth/ble/ble-overview), and [OsmAnd external input devices](https://www.osmand.net/docs/user/map/interact-with-map/).

## 4. Inputs and electrical behavior

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

Configure every connected input as `INPUT_PULLUP`. A closed switch joins the input to GND. Do not connect a switch input to 3.3 V or 5 V. D7 is not connected in the V0.22/V0.23 hardware and must be ignored.

The joystick has no separate center switch. Its stick sits on four C&K KSC2 switches (see the [joystick PCB](../electronics/joystick-pcb/README.md)); tilting closes one switch, or two adjacent ones on a diagonal, and pushing the stick straight in closes all four. The knob reaches its push stop only after every switch has tripped, so a full push always closes all four. The firmware derives the center input from this chord (section 5).

The final hardware may use a different pin map. Keep the pin assignments in one configuration table so they can be changed without rewriting input and HID logic.

## 5. Input processing and gesture rules

These values are initial tunable settings, not final ergonomic decisions:

| Setting | Initial value | Behavior |
|---|---:|---|
| Scan interval | 5–10 ms | Sample all inputs from one non-blocking loop or equivalent task. |
| Debounce | 30 ms | Accept a new stable state only after it remains unchanged for this interval. |
| Long-press threshold | 600 ms | Emit one long-press action when the control remains pressed for this duration. |
| Double-press window | 300 ms | Two short presses of the same control inside the window produce one double-press action. |

Gesture state machine for Buttons A, B, C, and the derived center input:

1. On a debounced press, record the start time; do not emit a key yet when short/double discrimination is active.
2. If the control is still down at the long-press threshold, emit its long action once. Suppress short and double actions for that press.
3. If it is released before the threshold, wait for the double-press window. A second debounced press of the same control inside the window cancels the pending short action and emits one double action after that second press is released (unless it becomes a long press).
4. If the window expires without a second press, emit one short action.
5. A second press of a different control does not cancel the first control's pending short action.

This means a short action can be delayed by up to the double-press window. Profiles that do not use double press may disable double recognition for the affected control and emit short actions on release. Record any profile-specific exception in the mapping table.

Center chord: treat the center as pressed when at least three direction inputs are closed, and released when none is. When a direction first closes, hold its key-down for a chord window (initially 40 ms, tunable). If three or more directions close inside the window, report the center press instead and send no direction keys until all four are released. Otherwise send the held directions as usual. Two opposite directions closed together can only come from a push, so they also suppress direction keys. The window delays direction key-down by up to its length; measure whether that is noticeable on hardware.

Joystick directions are held inputs: send the mapped key-down while the direction is held and the matching key-up on release. Do not synthesize repeated key-down reports in firmware. The host/app may repeat a held key; test whether this produces useful map panning and document device-specific behavior. Opposite directions pressed together should cancel each other. Other simultaneous directions must not corrupt the HID report.

Do not block the input scan while waiting for a gesture timeout. Keep a separate state and timer for each gesture-capable control so buttons can be used independently.

## 6. HID report behavior and reliability

- Every discrete action is a complete key press followed by a key release. Never leave a key logically held after a tap.
- Send a release report after each discrete press. Send an all-keys-released report after disconnect, profile change, reset, or any input-state recovery event.
- For held joystick directions, track each held direction and send the current set of keys, not unrelated successive key presses.
- Use a standard keyboard report with at least six-key rollover. The controls should not normally require more than four simultaneous direction keys, but verify combinations and gracefully handle the report limit.
- Do not emit a key repeatedly while a physical button remains held unless a tested app profile explicitly requires host key repeat.
- Ignore input events while BLE is disconnected, then resume cleanly after reconnect. Do not queue old actions for later delivery.
- Avoid unnecessary flash writes. Store profile/configuration only when it changes.

## 7. Profiles and mappings

The semantic app assignments below follow the project’s [control-mapping draft](control-mapping.md). A semantic action (for example, “reset partial odometer”) is not itself a HID keycode. The concrete HID usage for each action must be selected from the target app’s documented input options or discovered in a key tester, then verified on both phone platforms where the app is available.

| Profile | Button A | Button B | Button C | Joystick |
|---|---|---|---|---|
| TerraPirata | Short: reset partial odometer; long: lock/unlock screen | Short: increase the main odometer | Short: decrease the main odometer | Directions/center remain configurable pending TerraPirata mode validation. |
| OsmAnd | Short: change orientation (`D`) | Short: zoom in (`+`) | Short: zoom out (`-`) | Up/down/left/right: arrow keys; center short: current position (`C`). |
| DMD² / DMD Next | Short: map-follow toggle | Short: zoom in | Short: zoom out | Directions: pan; center initially unassigned. Configure emitted keyboard keys and any supported long-press action in DMD’s Generic Remote mapping. |
| Diagnostic | Short/long/double: `A`/`B`/`C` | Short/long/double: `D`/`E`/`F` | Short/long/double: `G`/`H`/`I` | Arrows while held; center short/long/double: `J`/`K`/`L`. |

The diagnostic profile uses ordinary letter keys only to make event identities easy to see in a keyboard tester. Do not use it while a navigation app is active because those letters may trigger app actions.

### Mapping limits to preserve

- **TerraPirata:** its official material recommends its dedicated remote mode or app compatibility mode, including for iOS. Do not claim generic HID equivalence until the physical events and mode have been tested. Its dedicated mode’s exact key usages for this DIY remote are currently unknown.
- **OsmAnd:** its current docs list `C` for current position, `D` for map orientation, arrow keys for map movement, `+`/`=` for zoom in, and `-` for zoom out. A `+` may be represented by the HID `Equal` usage with Shift, depending on keyboard layout; validate the actual output on Android and iOS. The long-press `N`/`S`/`M` actions proposed in the mapping draft are candidates only, not defaults in this first implementation. Double actions remain configurable and have no default mapping.
- **DMD² / DMD Next:** the project mapping is A follow toggle, B zoom in, and C zoom out. DMD documents generic keyboard/HID remote mapping, but generic remotes do not receive all features of its own remotes; in particular, do not promise native double-tap behavior. DMD² is Android-only according to its current FAQ.

For the first firmware build, compile-time profile selection is sufficient. Do not implement a mode-change gesture until a physical UI has been agreed and tested; this avoids accidental mode changes while riding. The diagnostic profile should be available even if app-specific mappings are unfinished.

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
| TerraPirata | Required remote/compatibility mode accepts each mapped action | Pending | Pending |
| OsmAnd | A/D, B/+, C/−, arrows, and center/C perform the intended actions | Pending | Pending |
| DMD² | A follow, B zoom in, C zoom out, and joystick pan work through Generic Remote mapping | Pending | N/A |
| Center chord | A straight push gives one center event and no direction keys; tilts and diagonals give no center event | Pending | Pending |

## Product OTA validation checklist

| Test | Pass condition | Android | iOS |
|---|---|---|---|
| Phone-only update | Install a published update package over BLE without a computer or USB data connection | Pending | Pending |
| Image authentication | Reject an unsigned, corrupted, or wrong-product image | Pending | Pending |
| Interrupted transfer | Disconnect BLE or remove power during transfer; recover automatically to the existing or update-ready state | Pending | Pending |
| Failed first boot | A broken new application image rolls back to the previous working firmware | Pending | Pending |
| Version handling | Reject downgrade or incompatible version unless a deliberate recovery procedure is used | Pending | Pending |
| Normal use after update | Reconnect as a HID remote and retain the user's selected profile and settings | Pending | Pending |

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
