# Cover Seal (V0.30) — Design

**Date:** 2026-10-15
**Status:** approved 2026-10-15.

## Goal

The remote's two control facets keep out rain and mud: heavy rain, splashes, and a hose without pressure, about IPX5/IPX6. Brief immersion and pressure washing are not targets.

## The problem with V0.29

In V0.29 the one-piece TPU keypad sheet is the gasket. It is printed 0.8 mm thick and squeezed to 0.6 mm over everything behind it: the button plate and the housing rim on the upper facet (847 mm², measured in CAD), and the joystick plate and the rim on the lower facet (678 mm²).

Estimate:
- TPU stiffness from its Shore hardness (Gent's relation, approximate): E ≈ 13 MPa at 85A, 17 MPa at 88A, 44 MPa at 95A.
- A thin sheet squeezed between rigid faces cannot spread sideways. With strips about 2.7 mm wide and 0.8 mm thick, the shape factor is S ≈ 1.7, and the apparent compression modulus is about 4.5 E.
- At 25 % compression this needs about 15 MPa with 85A TPU: about 12 kN on the upper facet. Even ignoring the shape factor, about 3 kN.
- Six M2 screws cutting their own thread in PETG give perhaps 0.6–1.2 kN (100–200 N each, assumed).

So the sheet would compress only a few hundredths of a millimetre, less than the flatness of an FDM print, and would probably not seal. A gasket bead printed on the sheet would need about 3–5 N/mm. Under that load, the cover between the upper screws, 30 mm apart, bends 0.1–0.6 mm, about as much as such a bead compresses.

The user chose the target (rain and mud) and accepted a bought gasket, if it is sold retail.

## Design

### Principle

The sheet becomes a membrane only. It no longer seals by being squeezed against the plates. A soft closed-cell foam strip on the housing rim seals the perimeter under the sheet's edge. Small pads near the screws set where the cover sits. The sheet seals round each screw by stretching over it.

### Keypad sheet

- Printed 0.8 mm thick, as now. It is not compressed over the plates: 0–0.1 mm clearance.
- Its outer edge still reaches the pod outline, over the housing rim.
- Screw holes: Ø1.4 mm instead of Ø2.4 mm. The M2 screw passes through and the sheet grips its shank, as it already grips the joystick pin.
- Risk: water may follow the screw's thread past the sheet. The countersunk head in the cover is the first barrier. The leak test decides.

### Button plate and joystick plate

- Their front faces move back so the sheet lies free: 0.8 mm sheet plus 0.1 mm clearance, instead of 0.6 mm compressed. On the upper facet this is 0.3 mm; on the lower facet the same along its normal.
- Each has a stop pad next to each cover screw, on the side away from the rim: Ø4 mm, standing so it pinches the sheet 0.05 mm. The pads set the cover's position. Estimated load: about 50 N per screw.
- The switches move back with the plates. The keys' rest gap becomes 0.3–0.4 mm, depending on where the loose sheet lies; `key_rest_gap` stays 0.3 mm with the sheet against the cover.

### Housing

- The rim of the walls, under the sheet's edge, drops 1.2 mm round both facets for the foam: 1.5 mm thick, compressed to 1.0 mm (33 %).
- The rim's two end walls (top of the upper facet, bottom of the lower facet), now 1.0–1.2 mm wide, widen inward to 2 mm so the strip sits fully on them.
- The cover screw bosses move back with the plates.

### Foam strip (new, bought)

- Closed-cell EPDM or neoprene adhesive foam tape, 1.5 mm thick, cut to 2 mm wide. Retail, by the roll.
- One continuous loop round both facets, about 220 mm, with two butt joints at the end corners. The sides run on through the fold.
- Load: about 0.05–0.1 N/mm, under 30 N in all (catalogue values for soft closed-cell foam, not measured).
- With that load, the cover between the upper screws bends about 0.015–0.07 mm, against 0.5 mm of foam travel.

### Knock-on effects

- The whole inner stack moves back about 0.3 mm: the XIAO-to-pouch gap falls from 7.2 to about 6.9 mm.
- The cover is unchanged outside.

## Checks (in CAD, before the design is final)

- The widened end rims clear the plates, the bosses, the control board and the joystick board.
- The stop pads clear the foam strip, the key web holes and the plate edges.
- Keys: rest gap and travel; joystick: rest gap and tilt, as in the V0.26 checks.
- The assembly path check and video, with no new collision.
- Contact area and force of the new sheet and pads, measured from the CAD as in this spec's estimate.

## Open, checked only on the first print

- The leak test (the cover sealed, no electronics, a few centimetres under water for 30 minutes, a dry paper towel inside): it checks the foam, the joints, the screw seals, the keys and the stick together.
- The foam's real compression force and how it recovers after being opened.
- The key feel with a loose sheet.

## Out of scope

- The battery cap gasket and the USB-C receptacle seal (unchanged).
- Immersion or pressure washing.
