# Firmware Specification — First BLE HID Prototype

**Status:** proposed implementation contract for the bench prototype. BLE pairing, key delivery, gesture timings, and every app profile remain unvalidated until tested with the purchased XIAO and real phones.

## 1. Purpose and scope

The first firmware should prove that the XIAO nRF52840 can read the temporary switches and operate as a Bluetooth remote with Android and iOS. It will expose standard keyboard input so supported apps can receive familiar key events. It will not depend on a companion phone app or a project-specific GATT service.

This is a bench prototype. It is not riding-ready and does not establish weather resistance, vibration resistance, or app compatibility.

## 2. Bluetooth transport

- Implement the Bluetooth SIG **HID over GATT Profile (HOGP)** as a BLE peripheral.
- Present as a standard keyboard HID device; phones act as the BLE central and HID host.
- Use the standard keyboard report protocol with key-down and key-up reports. Do not send text strings or app-specific proprietary packets.
- Start with one bonded phone at a time. Reconnect to the last bonded host after power-up. Provide a documented way to clear the bond during development; choose the physical reset gesture after the first bench test.
- Use a stable, recognizable device name such as `Open Rally Remote` and a distinct manufacturer/product string if the selected library supports it.
- Do not add Consumer Control/media reports, gamepad reports, or a custom GATT service to the first build. Add another HID collection only if app tests show keyboard reports cannot express a required action.

HOGP is the Bluetooth SIG profile for exposing HID input over BLE/GATT. Android documents BLE central/GATT support, and OsmAnd documents keyboard input on Android and iOS. Those facts make this a sensible first path, but they do not guarantee every key or gesture works identically on every phone. See [Bluetooth SIG HOGP](https://www.bluetooth.com/specifications/specs/hid-over-gatt-profile-hogp/), [Android BLE overview](https://developer.android.com/develop/connectivity/bluetooth/ble/ble-overview), and [OsmAnd external input devices](https://www.osmand.net/docs/user/map/interact-with-map/).

## 3. Inputs and electrical behavior

| XIAO pin | Input | Released | Pressed |
|---|---|---|---|
| D0 | Button A | HIGH | LOW |
| D1 | Button B | HIGH | LOW |
| D2 | Button C | HIGH | LOW |
| D3 | Joystick up | HIGH | LOW |
| D4 | Joystick down | HIGH | LOW |
| D5 | Joystick left | HIGH | LOW |
| D6 | Joystick right | HIGH | LOW |
| D7 | Joystick center (optional) | HIGH | LOW |

Configure every connected input as `INPUT_PULLUP`. A closed switch joins the input to GND. Do not connect a switch input to 3.3 V or 5 V. When the center-switch option is absent, D7 must be ignored and must not generate phantom events.

The final hardware may use a different pin map. Keep the pin assignments in one configuration table so they can be changed without rewriting input and HID logic.

## 4. Input processing and gesture rules

These values are initial tunable settings, not final ergonomic decisions:

| Setting | Initial value | Behavior |
|---|---:|---|
| Scan interval | 5–10 ms | Sample all inputs from one non-blocking loop or equivalent task. |
| Debounce | 30 ms | Accept a new stable state only after it remains unchanged for this interval. |
| Long-press threshold | 600 ms | Emit one long-press action when the control remains pressed for this duration. |
| Double-press window | 300 ms | Two short presses of the same control inside the window produce one double-press action. |

Gesture state machine for Buttons A, B, C, and the optional center switch:

1. On a debounced press, record the start time; do not emit a key yet when short/double discrimination is active.
2. If the control is still down at the long-press threshold, emit its long action once. Suppress short and double actions for that press.
3. If it is released before the threshold, wait for the double-press window. A second debounced press of the same control inside the window cancels the pending short action and emits one double action after that second press is released (unless it becomes a long press).
4. If the window expires without a second press, emit one short action.
5. A second press of a different control does not cancel the first control's pending short action.

This means a short action can be delayed by up to the double-press window. Profiles that do not use double press may disable double recognition for the affected control and emit short actions on release. Record any profile-specific exception in the mapping table.

Joystick directions are held inputs: send the mapped key-down while the direction is held and the matching key-up on release. Do not synthesize repeated key-down reports in firmware. The host/app may repeat a held key; test whether this produces useful map panning and document device-specific behavior. Opposite directions pressed together should cancel each other. Other simultaneous directions must not corrupt the HID report.

Do not block the input scan while waiting for a gesture timeout. Keep a separate state and timer for each gesture-capable control so buttons can be used independently.

## 5. HID report behavior and reliability

- Every discrete action is a complete key press followed by a key release. Never leave a key logically held after a tap.
- Send a release report after each discrete press. Send an all-keys-released report after disconnect, profile change, reset, or any input-state recovery event.
- For held joystick directions, track each held direction and send the current set of keys, not unrelated successive key presses.
- Use a standard keyboard report with at least six-key rollover. The controls should not normally require more than four simultaneous direction keys, but verify combinations and gracefully handle the report limit.
- Do not emit a key repeatedly while a physical button remains held unless a tested app profile explicitly requires host key repeat.
- Ignore input events while BLE is disconnected, then resume cleanly after reconnect. Do not queue old actions for later delivery.
- Avoid unnecessary flash writes. Store profile/configuration only when it changes.

## 6. Profiles and mappings

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

## 7. Initial implementation phases

1. **GPIO proof:** read the eight inputs, debounce them, and print state changes to the development serial monitor. Confirm active-low behavior and the optional D7 variant.
2. **BLE keyboard proof:** advertise HOGP; pair Android and iOS separately; send a simple test key press/release for each input. Confirm no stuck keys after quick taps, long holds, disconnects, and reconnects.
3. **Gesture proof:** add the per-input short/long/double state machine with adjustable thresholds. Confirm timing and that short actions are not lost or duplicated.
4. **App mapping:** implement the semantic profile table and bind tested HID usages to each action. Keep unverified bindings marked experimental.
5. **Bench compatibility:** complete the [validation matrix](control-mapping.md#bench-validation-matrix) and record phone, OS, app version, profile, actual key event, and action result.

## 8. Validation checklist

| Area | Pass condition | Android | iOS |
|---|---|---|---|
| Pairing | Appears as a keyboard/HID remote, pairs, and reconnects to the bonded phone | Pending | Pending |
| Input scan | Each of D0–D6 works once; D7 works only on the center-switch build | Pending | Pending |
| Debounce | One press produces one event; switch bounce produces no duplicates | Pending | Pending |
| HID release | Every discrete key has a matching release; disconnect cannot leave a key stuck | Pending | Pending |
| Directions | Held arrows pan as expected; release stops movement; opposing directions cancel | Pending | Pending |
| Gestures | Short, long, and double are distinct at the chosen thresholds; no dropped/doubled action | Pending | Pending |
| TerraPirata | Required remote/compatibility mode accepts each mapped action | Pending | Pending |
| OsmAnd | A/D, B/+, C/−, arrows, and center/C perform the intended actions | Pending | Pending |
| DMD² | A follow, B zoom in, C zoom out, and joystick pan work through Generic Remote mapping | Pending | N/A |
| Center variants | With and without D7 hardware, behavior and profile configuration are correct | Pending | Pending |

## References

- [Bluetooth SIG: HID over GATT Profile](https://www.bluetooth.com/specifications/specs/hid-over-gatt-profile-hogp/)
- [Android Developers: Bluetooth Low Energy overview](https://developer.android.com/develop/connectivity/bluetooth/ble/ble-overview)
- [OsmAnd: external input devices and keyboard key assignments](https://www.osmand.net/docs/user/map/interact-with-map/)
- [TerraPirata: Bluetooth remote compatibility](https://terrapirata.com/bluetooth-remotes/)
- [HesaParts NAVCOMM user manual](https://hesaparts.com/wp-content/uploads/2025/02/EN/NAVCOMM%20USER%20MANUAL.pdf)
- [DMD²: devices and generic remotes](https://docs.dmdnavigation.com/dmdnext/devices/)
- [DMD² FAQ: generic-remote behavior](https://docs.dmdnavigation.com/faq/)
