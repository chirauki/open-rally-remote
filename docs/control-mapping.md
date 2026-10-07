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

| Input | Proposed action | Basis / status |
|---|---|---|
| Button A — short | Main odometer + one increment | The app documents remote +/− controls; confirm which key event the TerraPirata profile expects. |
| Button A — long | Faster main odometer increase, if supported | The app says holding an adjustment button can increase the adjustment speed; validate with the selected remote mode. |
| Button B — short | Main odometer − one increment | Same as above. |
| Button B — long | Faster main odometer decrease, if supported | Same as above. |
| Button C — short | Reset partial odometer | The app documents this action for the third button. |
| Button C — long | Lock/unlock screen | The app documents a long press on the third button for screen lock. |
| Button C — double | Unassigned initially | Avoid conflicting with the short reset or long screen-lock behavior until tested. |
| Joystick directions and center | To be determined during TerraPirata-mode validation | Do not assume generic arrow keys map to roadbook actions. |

TerraPirata recommends its dedicated remote mode. On iOS it requires that mode or the app's compatibility mode. The event mapping for this DIY device must be verified on both Android and iOS.

### OsmAnd (Android and iOS)

OsmAnd supports external keyboard/controller inputs and lets users assign keys to actions. A proposed starting map uses documented keyboard actions:

| Input | Proposed HID key | Proposed OsmAnd action |
|---|---|---|
| Joystick up/down/left/right | Arrow keys | Pan map up/down/left/right |
| Joystick center — short | `C` | Move to current position |
| Button A — short | `+` | Zoom in |
| Button B — short | `-` | Zoom out |
| Button C — short | `D` | Change map orientation |
| Button A — long | `N` | Show/hide navigation view |
| Button B — long | `S` | Show/hide search view |
| Button C — long | `M` | Show/hide side menu |
| Double presses | User-configurable keys/actions | Assign in OsmAnd's external-device settings only if the app recognizes the emitted key event as expected. |
| Joystick center — long/double | User-configurable keys/actions | Validate on current Android and iOS releases. |

This is a candidate map based on OsmAnd's published keyboard assignments. Confirm the actual received key events and configurable actions on both operating systems before calling it a supported preset.

### DMD² / DMD Next (Android only)

| Input | Proposed action | Status |
|---|---|---|
| Joystick directions | Pan map | DMD² documents pan actions for generic HID remotes. |
| Joystick center | Follow/current-position action | Candidate; assign and verify in DMD² settings. |
| Buttons A/B short | Zoom in / zoom out | Candidate; configure in DMD²'s Generic Remote mapping. |
| Button C short | Map follow toggle | Candidate; configure in DMD². |
| Long press | One configurable long-press action per supported control | DMD² documents long-press mapping for generic remotes. Validate per key. |
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
| BLE pairing and automatic reconnect | Pending | Pending |
| TerraPirata dedicated mode / compatibility mode | Pending | Pending |
| TerraPirata odometer +/−, third-button reset, screen lock | Pending | Pending |
| OsmAnd arrows, `C`, `D`, `N`, `S`, `M`, `+`, `-` | Pending | Pending |
| OsmAnd user-assigned keys and Quick Actions | Pending | Pending |
| DMD² Generic Remote mapping and long press | Pending | Not applicable: DMD² navigation is Android-only |
| Short/long/double event distinction and repeat behavior | Pending | Pending |
| Joystick center-switch variant and no-center variant | Pending | Pending |

## References

- [TerraPirata Rally Roadbooks: remote controls, odometer, partial odometer, and screen lock](https://terrapirata.com/rally-roadbooks/)
- [TerraPirata Bluetooth remote compatibility notes](https://terrapirata.com/bluetooth-remotes/)
- [OsmAnd: external input devices and keyboard actions](https://www.osmand.net/docs/user/map/interact-with-map/)
- [OsmAnd: Quick Actions for external keys](https://osmand.net/docs/user/widgets/quick-action/)
- [DMD²: devices and generic remotes](https://docs.dmdnavigation.com/dmdnext/devices/)
- [DMD² FAQ: generic-remote limitations and iOS availability](https://docs.dmdnavigation.com/faq/)
