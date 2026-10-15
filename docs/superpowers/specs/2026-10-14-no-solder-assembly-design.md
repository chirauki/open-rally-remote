# No-Solder Assembly (V0.26) — Design

**Date:** 2026-10-14
**Status:** approved 2026-10-14.

## Goal

A builder assembles the remote without soldering. Every circuit board arrives assembled from a PCB assembly (PCBA) service. Every connection between boards is a bought, pre-crimped cable. The battery plugs in with the connector it is sold with. The only hot tool left is the soldering iron used to press in the heat-set inserts.

A pausable assembly video of the result is a separate, later project. It follows once V0.26 is modelled.

## What changes from V0.25

V0.25 needs about 25 hand-soldered joints: the XIAO pads (several under the rail lips), three APEM buttons, the joystick PCB wires, the USB-C board wires and the battery splice. V0.26 replaces them with three assembled boards and four cables.

| Item | V0.25 | V0.26 |
|---|---|---|
| Buttons | APEM ISR3SAD200, solder lugs, nuts | Three KSC2 on the control board, pressed through a one-piece TPU keypad |
| XIAO | Headerless, in housing rails, wires soldered to its pads | Pre-soldered XIAO (retail) plugged into two 1×7 female headers on the control board |
| Charger and battery level | XIAO's BQ25101 and P0.31 divider | Charger, 3.3 V regulator and battery divider on the control board |
| 5 V protection (PTC, TVS) | Joystick PCB | Control board |
| Joystick PCB | Switches, PTC, TVS, solder pads | Switches and one JST-SH connector |
| USB-C charging PCB | Receptacle, CC resistors, LED, solder pads | Same, plus one JST-SH connector |
| Battery | Leads spliced to wires from the XIAO BAT pads | Pouch's own JST-PH 2.0 lead, plugged straight into the control board; the pouch goes in protection board up |

Unchanged: the housing outside, the base, the dovetail and lock, the battery cap, the USB-C charging port position and its sealing, the joystick mechanism and the lower-facet sheet gasket.

## Electronics

```
 USB-C charging PCB (rear face)
   VBUS, GND, LED ──── JST-SH 3-pin cable ───┐
                                             │
 Joystick PCB: 4 × KSC2                      │
   U, D, L, R, GND ─── JST-SH 5-pin cable ───┤
                                             ▼
                CONTROL BOARD (assembled)
   front: 3 × KSC2 (buttons A, B, C)
   back:  2 × 1×7 female headers ──► XIAO with pins (retail)
          VBUS ─► PTC ─► TVS ─► LiPo charger ─► JST-PH (top entry) ◄── pouch lead
          battery ─► 3.3 V regulator ─► XIAO 3V3 pin
          battery divider ─► XIAO A0
          VBUS divider ─► XIAO D9 (charger present, wake)
          charger STAT ─► XIAO D8, and the charge LED cathode over the cable
```

### Pins

| XIAO pin | Use |
|---|---|
| D0 (A0) | Battery voltage, through a high-value divider |
| D1, D2, D3 | Buttons A, B, C |
| D4, D5, D6, D7 | Joystick up, down, left, right |
| D8 | Charger STAT (charging) |
| D9 | VBUS present |
| D10 | Spare |
| 3V3 | Supply in, from the control board regulator |
| GND | Ground |
| 5V | Not connected |

The XIAO's own charger and its P0.31 battery divider are not used. The P0.14 caution of the Seeed board no longer applies, because no battery reaches the XIAO's BAT pads.

### Charge LED

The LED on the USB-C charging PCB takes its anode from VBUS through its resistor. Its cathode goes over the cable to the charger's open-drain STAT output. It lights only while the charger charges and is powered by the charger, not the cell. No firmware is needed for it.

### Parts to choose

Chosen in the implementation plan, from parts that JLCPCB can assemble:
- LiPo charger with a STAT output and a set charge current of about 100 mA, programmable by a resistor. (The chosen MCP73831's STAT is push-pull, not open-drain; the LED circuit works the same, see the control board README.)
- 3.3 V regulator with nanoamp quiescent current and reverse-current blocking.
- PTC fuse and TVS diode, as on the V0.23 joystick PCB.
- JST-SH 1.0 mm side-entry SMD sockets (3-pin, 5-pin) and a JST-PH 2.0 mm socket.
- Low-profile 2.54 mm 1×7 female headers. The lower they are, the more room in front of the pouch.

### Cables

Retail, pre-crimped at both ends:
- JST-SH 1.0 mm, 5-pin, joystick to control board.
- JST-SH 1.0 mm, 3-pin, USB-C charging PCB to control board.
- None for the battery: the pouch's own JST-PH lead plugs into the control board. (Changed 2026-10-14, see below.)

## Mechanics

### Upper facet stack

From the outside in, along X, starting at the cover's outer plane (X = −57.5 mm):

| Layer | Thickness (mm) |
|---|---|
| Cover | 2.5 |
| TPU keypad sheet (compressed) | 0.6 |
| Button plate (printed) | 1.5 |
| Gap and plate holes for the key nubs | ~1 |
| KSC2 | 3.5 |
| Control board | 1.6 |
| Female header + XIAO header spacer | 8.5 + 2.5 (standard) or ~5 + 2.5 (low-profile) |
| XIAO PCB + components | 1.2 + 3.4 |
| Clearance to the pouch (X = −29) | ~2.2 (standard) or ~5.7 (low-profile) |

These are first estimates and are checked in the CAD before anything else.

### Keypad

- One printed TPU part (about 85A): three Ø12 mm keys joined by a 0.6 mm compressed sheet.
- The keys stand out through Ø13 mm holes in the cover.
- The sheet covers the whole upper facet and is its gasket, like the joystick sheet on the lower facet. It replaces the upper-facet wall-land gasket.
- A nub on the back of each key reaches its KSC2 through a hole in the button plate.
- The button plate clamps the sheet against the cover, like the joystick plate, and carries the control board on two standoffs with two screws.

### XIAO retention

The XIAO stays in its headers by friction. A foam pad between the XIAO components and the pouch presses it into the headers. The housing loses the XIAO rails and the XIAO's path in from below.

### Opening and programming

The keypad, the button plate, the control board and the XIAO come off with the cover, still joined to the housing by the cables. The XIAO's USB-C is then free for programming. BLE updates make this rare.

### Cable routes

- Joystick: about 30 mm, inside the cover between the two plates.
- USB-C charging PCB: from its rib at the top of the rear wall, along the upper wall, to the control board.
- Battery: the pouch goes in with its protection board at the top. Its lead leaves the top end, below the USB-C board's rib, and runs forward and up in front of the USB-C board to the top-entry socket on the control board: about 27 mm in the CAD, so a 40–50 mm lead is enough.

  **Changed 2026-10-14 (agreed with the user).** The first design used a JST-PH extension with its junction by the battery cap, so the pouch could be changed through the cap alone. The CAD showed the junction (about 16 × 6 × 4.5 mm) does not fit under the pouch (4.2 mm), sits above the cap's front block in front of it, and needs a 5–6 cm extension, which was not found in retail. With the pouch upside down the lead reaches the board directly. Changing the pouch now needs the cover off as well as the battery cap.

## Firmware

- New pin map (table above).
- Battery voltage on A0 through the board divider, with its ratio from the schematic.
- Charger present from D9 instead of the nRF52840 USB power events. D9 is also a System OFF wake source.
- Charging state from D8. The firmware no longer drives the charge LED.
- Remove the P0.14 and P0.13 handling, which belonged to the XIAO's charger.

## Assembly (target sequence)

1. Press the heat-set inserts into the housing and the base.
2. Fit the USB-C charging PCB on its rib (two screws). Pot the back of the receptacle and fill the LED window.
3. Joystick: stick through the plate, PCB onto the standoffs, knob later.
4. Lay the keypad in the cover, the button plate over it, the control board on the plate (two screws), and plug the XIAO into its headers.
5. Plug the joystick cable and the USB-C cable into the control board.
6. Fit the vent label and the foam pad.
7. Close the cover (ten screws).
8. Slide the pouch in from below, protection board and lead first, plug its lead into the control board, fit the cap.
9. Fit the knob.

## Verification before building

1. **XIAO 3V3 input.** Confirm from Seeed's XIAO nRF52840 schematic that the board runs when powered only on its 3V3 pin, and what happens when its USB-C is connected at the same time. Fallback: power the XIAO's 5V pin from the battery through a diode.

   **Result (2026-10-14):** 3V3 input is used. Source: [Seeed Studio XIAO nRF52840 v1.1 schematic](https://files.seeedstudio.com/wiki/XIAO-BLE/Seeed-Studio-XIAO-nRF52840-Sense-v1.1.pdf), dated 2022-06-24. What it shows:
   - The 3V3 pin is the output of U6, a 3.3 V regulator (part number not printed) with EN tied to IN. U6's input VIN comes from BAT through PMOS Q1, whose gate is VBUS with a 100 kΩ pull-down, or from VBUS through diode D1.
   - The 3V3 pin has no switch or diode after U6. Fed from the control board, the rail reaches the nRF52840 directly.
   - With no USB, Q1's gate is low. If U6 has a reverse path from OUT to IN, the external 3V3 reaches VIN and, through Q1, the BQ25100 output and the BAT pads, which are empty. The only steady load there is the 1 MΩ + 510 kΩ battery divider when P0.14 is low (about 2 µA); the V0.26 firmware leaves P0.14 high, which the divider then sees at about 3 V, under P0.31's 3.6 V limit.
   - With the XIAO's USB-C plugged in, VBUS reaches VIN through D1 and U6 drives 3V3 too. The control board regulator must therefore block reverse current, and its output must not fight U6: a regulator that turns off its pass device when its output is above its set point.
   - The 5V pin is VBUS: feeding the battery there would power the BQ25100 input, the nRF52840 USB detection and the 100 kΩ pull-down, and add a diode drop before U6. It is rejected.
   - The XIAO's battery divider is 1 MΩ over 510 kΩ, as assumed in firmware 0.7.0.
2. **CAD fit.** Model the stack and check the XIAO-to-pouch clearance, the cable routes, the cover with the stack coming off, and the keypad against the cover screws.
3. **Parts.** Stock at LCSC/JLCPCB for the charger, regulator, sockets, headers and KSC2. The GCT USB4736 was not found at JLCPCB; source it through JLCPCB's global sourcing or choose another sealed USB-C receptacle that keeps the CC pins.
4. **Cables.** Retail availability of double-ended JST-SH 1.0 mm cables in 3 and 5 pins, and of a JST-PH extension, in the needed lengths.
5. **Keypad feel and sealing.** KSC2 travel is 0.35 mm against 1.7 mm for the APEM buttons. Check the press with gloves, and whether the printed TPU sheet seals. Bench prints are not planned, so this is first checked on the first ordered print.
6. **Inserts.** Ask the print service whether it installs heat-set inserts (M2 and M4).

## Out of scope

- The assembly video (next project).
- iOS.
- A secure bootloader and signed updates.
