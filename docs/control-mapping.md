# Control Mapping — Draft

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

Tested on Android on 2026-10-14 (see the [firmware README](../firmware/xiao-nrf52840/README.md#app-profiles)). The firmware's TerraPirata profile sends:

| Input | Key sent | TerraPirata action | Status |
|---|---|---|---|
| Joystick up/down | Up/Down Arrow, held | Scroll the roadbook | Works |
| Joystick left/right | Left/Right Arrow, held | Trip − / + ; faster when held | Works |
| Button A | Play/Pause, held | Reset the total trip | Works |
| Button B | Volume +, held | Trip + ; faster when held | Works |
| Button C | Volume −, held | Trip − ; faster when held | Works |
| Joystick center | Nothing | — | Held 5 s, it switches the profile |

Not found: the keys for the partial trip reset, the screen lock and hiding the hundreds digits. Holding Play/Pause only makes the total trip blink. TerraPirata's dedicated remote mode is not documented publicly; its key map would have to come from the author or from a remote that has the mode.

The volume and Play/Pause keys are media keys: they also change the phone's volume or playback when another app is in front. TerraPirata recommends its dedicated remote mode, and on iOS requires that mode or the app's compatibility mode. iOS is deferred.

### OsmAnd (Android and iOS)

OsmAnd supports external keyboard/controller inputs and lets users assign keys to actions. A proposed starting map uses documented keyboard actions:

| Input | Proposed HID key | Proposed OsmAnd action |
|---|---|---|
| Joystick up/down/left/right | Arrow keys | Pan map up/down/left/right |
| Joystick center — short | `C` | Move to current position / center map |
| Button A — short | `D` | Change map orientation |
| Button B — short | `+` | Zoom in |
| Button C — short | `-` | Zoom out |
| Button A — long | `N` | Show/hide navigation view |
| Button B — long | `S` | Show/hide search view |
| Button C — long | `M` | Show/hide side menu |
| Double presses | User-configurable keys/actions | Assign in OsmAnd's external-device settings only if the app recognizes the emitted key event as expected. |
| Joystick center — long/double | User-configurable keys/actions | Validate on current Android and iOS releases. |

OsmAnd does not accept media keys in its key assignment (tested 2026-10-14), so it uses the firmware's keyboard profile: Buttons A, B and C hold `A`, `B` and `C`, the center taps `D`, and the joystick sends arrows. That gives one action per button; the long and double rows above need a profile with firmware gestures, which does not exist yet. This is a candidate map based on OsmAnd's published keyboard assignments. Confirm the actual received key events and configurable actions on both operating systems before calling it a supported preset.

### DMD² / DMD Next (Android only)

| Input | Proposed action | Status |
|---|---|---|
| Joystick directions | Pan map | DMD² documents pan actions for generic HID remotes. |
| Joystick center | `D` tap, if assigned | Avoid duplicating Button A's map-follow toggle; can be user-configured. |
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
| BLE pairing and automatic reconnect | Pass, including after a profile switch | Pending |
| TerraPirata dedicated mode / compatibility mode | Not tested: keys of the dedicated mode unknown | Pending |
| TerraPirata odometer +/−, third-button reset, screen lock | Trip +/−, total trip reset and roadbook scroll pass; partial reset and screen lock not found | Pending |
| OsmAnd arrows, `C`, `D`, `N`, `S`, `M`, `+`, `-` | Media keys rejected; keyboard profile pending | Pending |
| OsmAnd user-assigned keys and Quick Actions | Pending | Pending |
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
