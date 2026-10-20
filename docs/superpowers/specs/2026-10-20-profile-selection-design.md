# Profile Selection — Design

> Spanish version: [2026-10-20-profile-selection-design.es.md](2026-10-20-profile-selection-design.es.md).

**Date:** 2026-10-20
**Status:** approved 2026-10-20.

## Goal

The rider knows which profile the remote is in after changing it, without seeing it and with gloves on.

## The problem

Firmware 0.10.0 cycles the profile: holding the joystick center for 5 s selects the next one (TerraPirata, keyboard, gestures, then TerraPirata again), stores it and restarts the board. The only indication is the XIAO's RGB LED, which blinks the profile's colour every 10 s, inside the housing. The rider cannot see it, so after a switch the rider does not know which profile was reached.

The charge LED cannot help: the charger's STAT pin drives it, not the firmware, and the base platform covers its window on the bike. A new LED on the control board would need a board revision; the boards are already ordered.

The rider changes profile rarely: following a roadbook means TerraPirata for the whole ride, following a track means OsmAnd. So the profile needs to be known when it is changed, not at a glance while riding.

## Design

The profile is chosen directly, not cycled, so the button pressed tells the rider which profile was set.

### Behaviour

1. **Enter.** Hold the joystick center for 5 s (`PROFILE_SWITCH_MS`) and release it. Releasing it then enters profile selection. Released earlier, it is an ordinary center long press, which has no action in any profile.
2. **Choose.** Within 5 s of the release (`PROFILE_SELECT_MS`), press a button:
   - A: TerraPirata;
   - B: keyboard (DMD2);
   - C: gestures (OsmAnd).

   The press takes effect when the button is pressed, not when it is released.
3. **Apply.** A different profile is stored and the board restarts, as in 0.10.0. The current profile leaves selection without a restart: the BLE link stays up, and the controls work at once.
4. **Cancel.** With no button within 5 s, selection ends and nothing changes.

### During selection

- No key is sent, by the buttons or the joystick. The button that chooses sends nothing either.
- Two or more buttons closed together end selection with no change; the A + B + C power off then works as before.
- Joystick directions are ignored; they neither choose nor cancel.
- A BLE disconnect ends selection with no change.
- The LED keeps its profile blink.

### Start-up

The board starts in the stored profile, as in 0.10.0. An unknown stored value starts TerraPirata.

### Known limit

There is no sign that the 5 s hold has passed. Released too early, the center does nothing and selection is not entered; hold it a little longer than 5 s. Accepted: a profile change is made at rest, before a ride.

## Testing

Host tests (`firmware/xiao-nrf52840/test`), on both boards:

- Center held 5 s and released, then A, B or C: the matching profile is stored and the board restarts; for the current profile it does not restart.
- Center released before 5 s: no selection; a button then sends its normal key.
- Selection with no button for 5 s: it ends, no profile is stored, and a button then sends its normal key.
- During selection no HID report carries a key, including from the choosing button and the joystick.
- Two buttons during selection: no profile change, no key.
- The choosing button's release after a same-profile choice sends nothing.

Bench: on the XIAO, choose each profile and check the LED colour after the restart and that the phone reconnects.

## Documentation

English and Spanish: the firmware README (profiles, wiring notes, first test), the firmware specification (profiles section), the control mapping (joystick center rows), and the mechanical notes' "Profile LED" open unknown, which this design closes.
