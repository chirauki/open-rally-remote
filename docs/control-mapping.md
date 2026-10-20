# Control Mapping — Draft

> Spanish version: [control-mapping.es.md](control-mapping.es.md).

**Status:** proposed input model; app bindings and hardware behavior still require bench validation.

This document separates the physical gestures from each app's actions. The firmware should let builders select a profile and change key bindings; the table below is a starting point, not a claim that every app accepts every gesture.

## Physical input model

The proposed control order is three buttons above a lower joystick.

| Control | Inputs recognized by firmware |
|---|---|
| Button A (upper) | Short press, long press, double press |
| Button B (middle) | Short press, long press, double press |
| Button C (lower button) | Short press, long press, double press |
| Joystick | Up, down, left, right, and center press |
| Joystick center press | Short press, long press, double press, when the selected joystick includes a center switch |

Joystick directions are separate directional events, not button gestures. A joystick variant without a center switch simply omits those three center gestures.

## Proposed app profiles

### TerraPirata Rally Roadbooks

Tested on Android on 2026-10-20 with firmware 0.9.0 (see the [firmware README](../firmware/xiao-nrf52840/README.md#app-profiles)). TerraPirata shows two counters: the trip, which the remote adjusts, and the total. The firmware's TerraPirata profile sends:

| Input | Key sent | TerraPirata action | Status |
|---|---|---|---|
| Joystick up/down | Up/Down Arrow, held | Scroll the roadbook up/down | Works |
| Joystick left/right | Left/Right Arrow, held | Trip − / + (10 m a step); faster when held | Works |
| Button C, short | `x` tap | Lock or unlock the screen | Works |
| Button A, long (2 s) | `r` tap | Opens the "reset odometer" dialog; accepting it on the screen sets the trip to zero | Works |
| Button B, long (2 s) | `z` tap | Reset the total | Works |
| Buttons A and B, short or double | Nothing | — | By design, so a stray press resets nothing |
| Joystick center | Nothing | — | Held 5 s and released, then A/B/C: chooses the profile |

The long presses take 2 s (`RESET_LONG_PRESS_MS`), not the 600 ms of the other profiles, because both reset a counter. Firmware 0.8.0 sent media keys instead (Play/Pause on A, Volume +/− on B and C); they reach whichever app is in front, so 0.9.0 sends none.

#### Keys TerraPirata reacts to

Found on 2026-10-20 with the [key probe](../firmware/key-probe/README.md), which sends one key at a time, and checked against its serial log. The candidates are the keys a commercial rally remote sends. Its firmware ("offroad Zone V1.4", ESP32) was read for its key codes only: each of its buttons sends a fixed key, often a media key and a keyboard key together.

| Key | TerraPirata action |
|---|---|
| `x` | Lock or unlock the screen |
| `r` | Opens the "reset odometer" dialog; accepting it sets the trip to zero |
| `z` | Reset the total |
| Play/Pause (media) | Reset the total |
| F6 | Scroll the roadbook down |
| F7 | Scroll the roadbook up |
| Volume + / − (media) | Trip + / − |
| Right / Left Arrow | Trip + / − (Left does nothing while the trip is at zero) |
| `c`, `k` | Nothing |

The "reset odometer" dialog is confirmed with a tap on the screen, by choice: it is a large on-screen button, and Enter or Space would risk pressing whatever control has the focus. Not found yet: the key for hiding the hundreds digits. Not checked: whether these keys depend on a TerraPirata setting, and iOS. TerraPirata recommends its dedicated remote mode, and on iOS requires that mode or the app's compatibility mode; iOS is deferred.

### OsmAnd (Android and iOS)

Tested on Android on 2026-10-20 with firmware 0.10.0. The firmware's gestures profile sends the keys of OsmAnd's built-in "Keyboard" device type ([OsmAnd: external input devices](https://www.osmand.net/docs/user/map/interact-with-map/)), plus `x` for the screen lock:

| Input | Key sent | OsmAnd action | Status |
|---|---|---|---|
| Joystick up/down/left/right | Arrow keys, held | Pan the map | Works |
| Joystick center, short | `C`, on release | Move to my position | Works |
| Button A, short / long / double | `D` / `N` / `P` | Change map orientation / show or hide navigation / next app profile | Works |
| Button B, short / long | `-` on release / `S` | Zoom out / show or hide search | Works |
| Button C, short / long | `=` on release / `x` | Zoom in / touch screen lock | Works; `x` needs a custom device type, below |
| Joystick center, long | — | — | Held 5 s and released, then A/B/C: chooses the remote's profile |

B and C have no double press, so their zoom goes out on release, with no 300 ms wait; repeated taps zoom step by step. `=` is used for zoom in because `+` needs Shift.

Two ways to set OsmAnd up, in each app profile used on the bike (the settings are per app profile; there is no "apply to all", only copying or exporting a whole profile):

- **Built-in "Keyboard" type:** no assignment needed, but its actions cannot be changed, so `x` does nothing: everything works except the screen lock.
- **Custom type:** a new type starts empty. Assign each key above to its action, and `x` to the "Touch screen lock" quick action (Interface). Everything works.

Android: *Menu → Configure profile → General settings → Other → External input devices*. iOS: *Menu → Settings → App profiles → General settings → External input devices*. OsmAnd does not accept media keys in its key assignment (tested 2026-10-14). iOS is not tested.

### DMD² / DMD Next (Android only)

| Input | Proposed action | Status |
|---|---|---|
| Joystick directions | Pan map | DMD² documents pan actions for generic HID remotes. |
| Joystick center | `D` tap (keyboard profile), if assigned | Avoid duplicating Button A's map-follow toggle; can be user-configured. |
| Button A — short | Map follow toggle | Candidate; configure in DMD²'s Generic Remote mapping. |
| Button B — short | Zoom in | Candidate; configure in DMD²'s Generic Remote mapping. |
| Button C — short | Zoom out | Candidate; configure in DMD²'s Generic Remote mapping. |
| Long press | One configurable long-press action per supported control | DMD² times the long press itself: a separate key for the firmware's long press did not work (2026-10-14). The keyboard profile holds `A`, `B`, `C` while each button is pressed, and DMD² then recognized the long press. |
| Double press | Not assumed available as a generic-remote gesture | DMD² documentation says generic remotes do not get the native double-tap functions available to DMD remotes. A separate emitted key may work only if the app exposes a matching assignment. |

DMD²'s Generic Remote Controller may require a DMD license. The navigation app is Android-only.

### Generic keyboard profile

The generic profile should emit a simple, documented set of keyboard keys. Builders can remap these in apps that support external keyboard input. It cannot provide app actions that the receiving app does not expose.

## Gesture timing: prototype values to evaluate

- Debounce: begin testing around 20–40 ms.
- Long press threshold: begin testing around 600 ms.
- Double-press window: begin testing around 300 ms.

These are starting values for the prototype, not fixed requirements. Because a short press cannot be distinguished from the first half of a double press until the double-press window expires, measure the perceived delay and allow the thresholds to be adjusted in firmware if practical.

## Bench validation matrix

Record the phone/tablet model, OS version, app version, selected app profile, key event received, and resulting action.

| Test | Android | iOS |
|---|---|---|
| BLE pairing and automatic reconnect | Pass, including after a profile change | Pending |
| TerraPirata dedicated mode / compatibility mode | Not tested; the keys above work without changing a setting | Pending |
| TerraPirata trip +/−, trip and total reset, screen lock, roadbook scroll | Pass with firmware 0.9.0 (2026-10-20); the trip reset needs a tap on the screen to confirm | Pending |
| OsmAnd arrows, `C`, `D`, `N`, `=`, `-`, `x` (gestures profile) | Pass with firmware 0.10.0 (2026-10-20), `P` and `S` included, with a custom device type for `x` | Pending |
| OsmAnd user-assigned keys and Quick Actions | `x` assigned to "Touch screen lock" in a custom type: pass | Pending |
| DMD² Generic Remote mapping and long press | Pass with held keys (keyboard profile); a separate long-press key fails | Not applicable: DMD² navigation is Android-only |
| Short/long/double event distinction and repeat behavior | Pending | Pending |
| Joystick center-switch variant and no-center variant | Pending | Pending |

## References

- [TerraPirata Rally Roadbooks: remote controls, odometer, partial odometer, and screen lock](https://terrapirata.com/rally-roadbooks/)
- [TerraPirata Bluetooth remote compatibility notes](https://terrapirata.com/bluetooth-remotes/)
- [OsmAnd: external input devices and keyboard actions](https://www.osmand.net/docs/user/map/interact-with-map/)
- [OsmAnd: Quick Actions for external keys](https://osmand.net/docs/user/widgets/quick-action/)
- [DMD²: devices and generic remotes](https://docs.dmdnavigation.com/dmdnext/devices/)
- [DMD² FAQ: generic-remote limitations and iOS availability](https://docs.dmdnavigation.com/faq/)
