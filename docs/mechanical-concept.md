# Complete Mechanical CAD — V0.33 No-Solder Remote

> Spanish version: [mechanical-concept.es.md](mechanical-concept.es.md).

V0.33 thickens the remote's 1 mm walls to 2 mm: the axial walls of the narrow part and the two end walls. They grow outward, so the remote is 25 mm wide along the bar instead of 23 mm and 2 mm taller, and the cavity and everything in it stay as in V0.32. The base is 25 mm wide too. The thicker walls follow the [materials study](materials-study.md): falls are common on tracks, and 1 mm walls with two FDM perimeters can leak. The print material is not chosen yet. See [Changes from V0.32](#changes-from-v032).

V0.32 cuts the number of different parts to buy. The lock takes a standard M3 × 20 screw fixed with epoxy instead of an M3 × 22 and a lock nut. The anti-rattle strips, and optionally the clamp liner, are cut from a bike inner tube, and the foam pads come from the seal foam. The joystick knob keeps its square nut: a hex nut does not fit. See [V0.32 changes from V0.31](#v032-changes-from-v031-still-current).

V0.31 seals the battery cap the way V0.30 seals the cover: a die-cut closed-cell foam gasket, cut from the same foam sheet, compressed by a rigid lip on the cap. See [V0.31 changes from V0.30](#v031-changes-from-v030-still-current).

V0.30 changes how the two control facets seal against rain and mud. The keypad sheet becomes a loose membrane, and a bought closed-cell foam strip on the housing rim seals the perimeter ([spec](superpowers/specs/2026-10-15-cover-seal-design.md)). See [V0.30 changes from V0.29](#v030-changes-from-v029-still-current).

V0.29 drops the heat-set inserts, so the build needs no hot tool at all. The screws cut their own thread in pilot holes, and nuts sit in printed pockets where a screw needs metal threads. See [V0.29 changes from V0.28](#v029-changes-from-v028-still-current).

V0.28 makes the base universal and moves the vent. One base fits both bar sizes: its bore is always 25.4 mm plus the TPU liner, and a 22.2 mm bar takes a printed split sleeve. The vent goes to the battery cap, because in V0.27 its label ran into the cover and the joystick plate. See [V0.28 changes from V0.27](#v028-changes-from-v027-still-current).

V0.27 lets the housing close onto the stack, and the cover come off, in a straight line. In V0.26 the [assembly path check](assembly-video-v0.26-checks.md) found the lower cover bosses hitting the joystick board on that path. V0.27 changes only the joystick board (rev C) and the joystick plate's standoffs; see [V0.27 changes from V0.26](#v027-changes-from-v026-still-current).

V0.26 removes the builder's soldering ([design](superpowers/specs/2026-10-14-no-solder-assembly-design.md)). The buttons become three sealed tact switches on an assembled control board, pressed through a one-piece TPU keypad that is also the gasket. The XIAO, bought with its pins, plugs into female headers on the back of that board, which also carries the charger and the 3.3 V regulator. The joystick and USB-C boards connect to it with bought JST SH cables, and the pouch, fitted protection board up, plugs its own lead into it. The changes are listed under [V0.26 changes from V0.25](#v026-changes-from-v025-still-current).

V0.25 drops the XIAO's pin headers and fits a 6 × 20 × 50 mm pouch (602050, 600 mAh in the listing) instead of the 602030. The pouch now slides in from below, through a separate battery cap in the bottom end: an assembly study showed that no 20 mm wide pouch, the V0.24 one included, can pass the front opening. The changes are listed under [Changes from V0.24](#changes-from-v024).

V0.24 makes the remote removable and battery powered, following the [battery study](battery-study.md) and issue #1. A base stays clamped on each bike; the remote slides onto it on an interrupted dovetail and is held by a spring-loaded lock. A fixed LiPo pouch powers it, and it is charged off the bike through a sealed USB-C receptacle on its back, with a charge LED beside it. Everything in front of the remote's rear face is the V0.23 pod, unchanged. The changes are listed under [Changes from V0.23](#v024-changes-from-v023-still-current).

V0.23 fitted the V0.22 joystick to a real PCB, designed in KiCad: the [joystick PCB](../electronics/joystick-pcb/README.md) carries the four switches and the 5 V input protection. V0.22 put a joystick back on the lower facet, built from low-cost parts, and widened the control end of the pod from 23 to 26 mm. The base and the rear of the pod stay 23 mm wide along the bar.

The joystick is a steel pin with a printed ball. The ball pivots against a seat in a printed joystick plate. Under the ball, a cross-shaped disc rests on four C&K KSC2 sealed tact switches, whose springs centre the stick. Tilting the stick presses one switch; pushing it straight in presses all four, which the firmware reads as the centre press. The parts cost a few euros. The Ruffy MHS of V0.20 was listed at about £149, and the APEM NV, the closest commercial alternative found, at $143.

The remote's printed parts are slices of one outer solid: the pod outline cut flat at the rear face, 25 mm wide along the bar (23 mm before V0.33), plus the 26 mm control end. Offsets of the folded front cut the cover and gasket from it. The base is two separate halves split through the bar axis. Supplier and purchase unknowns remain open and are listed at the end; they are marked `MEASURE` in the CAD.

The remote mounts on the left side of the bar only, never the right. The turn-signal switch that the folded front clears is on the left switchgear.

**Current parametric concept:** [complete-remote-v0.33.scad](../mechanical/cad/complete-remote-v0.33.scad)

![V0.33 on its base, from the rider's side: a Blender render of the CAD with the remote in dyed black nylon and the base in grey nylon. The material is not chosen yet.](images/complete-remote-v0.33-photo-front.png)

![V0.33 seen along the bar: the folded control face, the 2 mm walls and the base with its lock knob.](images/complete-remote-v0.33-photo-side.png)

![V0.33 on its base, from the rider's side: the three TPU keys stand 3 mm out of the cover through Ø13 mm holes, and the joystick sits on the lower facet.](images/complete-remote-v0.33-assembly.png)

![V0.33 control cover seen straight from the rider's side.](images/complete-remote-v0.33-front.png)

![V0.33 seen along the bar: the upper facet with keys A, B, C and the lower facet with the joystick, turned 20 degrees toward the bar.](images/complete-remote-v0.33-side.png)

![V0.33 joystick knob on the lower facet, between the four lower cover screws.](images/complete-remote-v0.33-joy.png)

![V0.33 on its base, from behind the bar: the base platform under the remote's rear face, and the lock knob below the clamp ring.](images/complete-remote-v0.33-rear.png)

![V0.33 entry position: the remote held off the platform, 9 mm below its working position, with the lock knob pulled.](images/complete-remote-v0.33-entry.png)

![V0.33 fitting and removal, animated. Left: pull the knob, press the remote onto the platform 9 mm low, slide it up to the stop, release the knob; then pull the knob, slide down and lift off. Right: the same, cut at mid-width and seen along the bar, with the rails in the groove and the lock head (orange) in its hole.](images/complete-remote-v0.33-fit.gif)

![V0.33 base on the bar: the clamp ring, the platform with two dovetail rail segments, the two black anti-rattle strips, and the lock knob.](images/complete-remote-v0.33-base.png)

![V0.33 base on a 22.2 mm bar, without the bar: the liner and the printed sleeve inside the one 25.4 mm bore.](images/complete-remote-v0.33-base-sleeve.png)

![V0.33 remote seen from the bar side: the rear face with the lock hole, the interrupted dovetail groove and the USB-C opening.](images/complete-remote-v0.33-back.png)

![V0.33 dovetail section through the lower rail: the 45-degree rail on the base (right) inside the groove in the remote's rear wall (left), and the anti-rattle strips (black) either side, drawn at their uncompressed thickness.](images/complete-remote-v0.33-dovetail.png)

![V0.33 interior with the upper axial wall removed: the control board behind the upper facet with the XIAO on its headers, the pouch (red) behind them, the USB-C board at the top, the joystick board on the lower facet, and the cables.](images/complete-remote-v0.33-interior.png)

![V0.33 section through the middle of the pod and the base: cover, keypad sheet, button plate, switches, control board, XIAO and pouch.](images/complete-remote-v0.33-section.png)

![V0.33 section through the upper cover screws (Y = 24 mm), the axis of the bar up the page: cover (left), loose keypad sheet (black), foam strip (blue) on the housing rim, button plate (ochre), the two screws (red) in their bosses, and the control board (green).](images/complete-remote-v0.33-seal-section.png)

![V0.33 housing seen from the cover side: the foam strip (black) runs on the rim along both side walls and through the fold, with the cover screw bosses just inside it.](images/complete-remote-v0.33-foam.png)

![V0.33 battery cap, exploded from below: the housing with its bottom opening, the pouch envelope (red), the die-cut foam cap gasket and the cap with its three countersunk screw holes.](images/complete-remote-v0.33-battery-cap.png)

![V0.33 battery cap from inside: the die-cut foam gasket (black) inside the cap's 0.5 mm lip, and the vent label in the opening.](images/complete-remote-v0.33-cap-seal.png)

![V0.33 section through the joystick axis, drawn with the knob at the bottom: knob, cover, keypad sheet, joystick plate with the ball seat, ball and cross disc, switches, and the joystick board on its standoffs.](images/complete-remote-v0.33-joy-section.png)

![V0.33 cover in its print orientation, on its axial face.](images/complete-remote-v0.33-print-cover.png)

![V0.33 keypad sheet unfolded flat in its print orientation, seen from the key side.](images/complete-remote-v0.33-gasket-flat.png)

![V0.33 joystick parts in their print orientations: the plate on its sheet side with the two PCB standoffs up, the ball and disc on the disc, the knob on its top face, and the Ø3 × 12 mm steel pin (bought).](images/complete-remote-v0.33-print-joy.png)

![V0.33 joystick plate in its print orientation: both PCB standoffs in the lower half, below the seat hole.](images/complete-remote-v0.33-print-joy-plate.png)

![V0.33 sleeve halves in their print orientation, on an end face. Each stops 0.5 mm short of the split.](images/complete-remote-v0.33-print-sleeve.png)

The two photo images are Blender renders of the CAD (see [Photo renders](#photo-renders)). The others are direct OpenSCAD renders of the V0.33 file. Images of earlier versions stay in `docs/images/`. The PCB images are on the [joystick PCB page](../electronics/joystick-pcb-rev-c/README.md).

## Changes from V0.32

### 2 mm walls

In V0.32 the narrow part of the remote, up to 38 mm from the bar axis, had 1 mm axial walls, and both end walls were 1 mm. With a 0.4 mm nozzle that is two FDM perimeters, which can leak (see [Sealing](#sealing), point 8). The [materials study](materials-study.md) also found that falls on tracks are common, and a wall's bending strength grows with the square of its thickness.

The 23 mm width came from the NAVCOMM manual's free space on the bar between grip and switchgear. NAVCOMM is a reference, not a requirement, and the switchgear can usually be moved along the bar.

V0.33:
- **Axial walls.** `case_wall` grows from 1 to 2 mm, outward: `axial_width` goes from 23 to 25 mm. The cavity stays 21 mm wide, so the pouch, the XIAO and the boards do not move.
- **End walls.** They grow 1 mm outward at each end: the top end rises to Y = 46.5 mm (`pod_top_y`) and the bottom end drops 1 mm (`lower_facet_length` = 30 + 1/cos 20°). The remote is 88.2 mm tall instead of 86.2 mm. The cavity is unchanged: 54,540 mm³ behind the cover band in both versions.
- **Control end.** It stays 26 mm wide with 2 mm walls; the chamfer to the narrow part (`pod_step`) shrinks from 1.5 to 0.5 mm.
- **Base.** It is 25 mm wide too, since the base and the remote share `axial_width`. The clamp gains 2 mm of contact with the bar. The liner pieces are cut 25 mm wide.
- **Battery cap.** 3.0 mm thick under its foam instead of 2.0 mm, because the bottom end dropped and the housing face over the cap (`cap_y`) did not move. The M2 × 8 screws keep 4.0 mm of thread in the housing instead of 5.0 mm, and the front boss is 1 mm shorter.
- **Foam strip.** At the end walls it now lies fully on the 2 mm wall; in V0.30–V0.32 the rim there widened inward from 1 to 2 mm.
- **Mass.** The housing grows from 16.4 to 20.9 cm³, about 4.5 g in nylon; the cap from 0.9 to 1.3 cm³.
- **Anti-rattle strips.** With the groove 1 mm further from each side face, more of each strip bears on the rear face: 218 mm³ of squeeze in the CAD instead of 196 mm³. The squeeze depth is unchanged.

## V0.32 changes from V0.31, still current

### Fewer parts to buy

- **Lock screw.** V0.31 asked for an M3 × 22, which is not an ISO 4762 length (M3: 16, 20, 25, 30 mm). An M3 × 20 (`lock_screw_length`) passes 1.0 mm through the nut in the knob's pocket and ends 0.8 mm inside the knob's outer face (`lock_tip`), with no room for a lock nut. When the head stands 2 mm proud, a drop of the clear epoxy on the thread fixes the nut. This makes the setting permanent: to change the spring, heat or cut the joint. An M3 × 25 with a nylon-insert nut was the other option. That nut is 4 mm tall, and a pocket for it would leave no wall over the 4 mm bore, so it would sit on the face, 4 mm proud, with 1.8 mm of thread past it.
- **Anti-rattle strips.** Cut from a bike inner tube. Measure the rubber and set `strip_t` before printing the base front. The pocket depth follows it (`strip_pocket` = `strip_t` − 0.48 − `strip_squeeze_set`), so the strips are always compressed 0.3 mm with the flanks seated. A 1.0 mm tube gives a 0.2 mm pocket; a tube down to 0.78 mm fits, with no pocket. In V0.31 the strips were 1.4 mm TPU in 0.6 mm pockets.
- **Clamp liner.** The liner is a plain half ring, so the same inner tube can replace the printed TPU: two pieces 23 mm wide and about 43 mm long (25 mm wide since V0.33). Set `liner_radial` to the tube's thickness before printing the base; the bore follows. From 0.8 to 1.2 mm the platform keeps 3.7–3.3 mm in front of the bore.
- **Foam pads.** The pads on the battery cap, on the rear wall and on the XIAO come from the 1.5 mm closed-cell seal foam, in layers. The CAD gaps to the cell are 5.7 mm from the cap, 1.3 mm from the rear wall and 7.4 mm from the XIAO's components. That gives 4 layers on the cap (6.0 mm), and 1 on the rear wall with 6 on the XIAO (10.5 mm across a gap of 8.7 mm, about 17 % compression). The pads are not modelled.
- **Joystick knob nut: unchanged.** An M2 hex nut, which comes in the M2 screw assortments, does not fit. With a corner toward the knob top, so that it cannot turn in the slot, it needs 4.62 mm plus 0.2 mm clearance and 0.5 mm skin. The knob has 4.8 mm between its hub face and its top, so the nut would stand 0.6 mm out of the hub toward the cover. With a flat toward the top, the slot must be 4.62 mm wide and the nut turns in it. A countersunk screw in place of the grub screw was dropped too: its head stops at a fixed depth, so it cannot be set against the pin.

## V0.31 changes from V0.30, still current

### Battery cap seal

The cap's flat gasket had the cover's old problem: 0.8 mm of TPU squeezed to 0.6 mm on 2.5–3.8 mm lands needs about 4 kN (estimate, as in [V0.30](#v030-changes-from-v029-still-current)), and three M2 screws give a few hundred newtons. The V0.30 strip does not fit here: the screws sit in the lands, 0.7–0.9 mm from the opening, so a 2 mm strip inside them has no room, and one outside them would leave the screw holes inside the seal.

V0.31:
- **Foam gasket.** A frame of the same closed-cell foam as the cover strip, 1.5 mm thick, cut to the old gasket's outline, fills the lands: 200 mm² in the CAD. At 20–70 kPa (catalogue values for soft closed-cell foam at 25–33 %) it needs 4–14 N. The screws pass through it, and its Ø1.4 mm holes grip them, so the screw holes are sealed wherever they are.
- **Lip.** A rigid lip, 0.5 mm wide (`cap_lip_w`), runs round the cap's outer edge and bears on the housing face. It stops the cap 1.0 mm (`cap_gap` = `foam_comp`) from the housing, so the foam is always compressed 33 %, however hard the screws are tightened.
- **Cap.** 2.0 mm thick under the foam instead of 2.4 mm. The screws keep 5.0 mm of thread in the housing. The vent label sits on the cap's face in the opening, clear of the foam.
- **Template.** `print_cap_gasket` now prints a 0.8 mm template to cut the foam frame round.

## V0.30 changes from V0.29, still current

### Cover seal

The V0.29 keypad sheet was the gasket: 0.8 mm printed, squeezed to 0.6 mm over the button plate, the joystick plate and the rim. The CAD gives 847 mm² of squeezed sheet on the upper facet and 678 mm² on the lower one. A thin TPU sheet squeezed between rigid faces cannot spread sideways: with strips about 2.7 mm wide, the shape factor is about 1.7 and the sheet behaves about 4.5 times stiffer than its Young's modulus (13 MPa for 85A TPU, from Gent's relation, approximate). At 25 % compression that is about 15 MPa, some 12 kN on the upper facet, against perhaps 1 kN from six M2 screws in PETG. The sheet would have compressed a few hundredths of a millimetre, less than the flatness of an FDM print. A bead printed on the sheet would need 3–5 N/mm, and the cover between the upper screws, 30 mm apart, would bend about as much as the bead compresses.

V0.30 seals for rain, mud and a hose without pressure, about IPX5/IPX6:

- **Loose sheet.** The sheet keeps its 0.8 mm and is no longer squeezed: the plates sit `sheet_clear` (0.1 mm) behind it. The keys are unchanged; their rest gap stays 0.3 mm with the sheet against the cover.
- **Foam strip.** A closed-cell foam strip, 1.5 mm thick (`foam_t`), compressed to 1.0 mm (`foam_comp`), 2 mm wide (`foam_w`), lies on the housing rim under the sheet's edge, round both facets and through the fold: 443 mm², about 221 mm of strip, 99.7 % of it on housing material. The rim drops to `rim_off` = 4.3 mm behind the cover face, and at the two end walls it widens inward from 1 mm to 2 mm. At catalogue values for soft closed-cell foam (0.05–0.1 N/mm), the strip needs under 30 N, and the cover bends about 0.015–0.07 mm between the upper screws, against 0.5 mm of foam travel.
- **Stop pads.** A Ø4 mm ring round each cover screw on the plates' front faces stands 0.15 mm proud and pinches the sheet 0.05 mm: about 8.5 N per screw (estimate, `pad_load`). Tightened harder, the sheet meets the plates 0.1 mm further in.
- **Screw holes.** The sheet's screw holes shrink from Ø2.4 to Ø1.4 mm so it grips the M2 shank, as it grips the joystick pin. Water may follow the thread; the countersunk head in the cover is the first barrier, and the leak test decides.
- **Knock-on.** The plates, switches, bosses, control board and XIAO move about 0.3 mm back: the XIAO is 7.0 mm from the pouch envelope (was 7.2), the control board standoffs are 2.2 mm (2.3). The joystick pivot moves back too, so the knob's pin hole is 3.7 mm deep instead of 4.0 and the 3 × 12 mm pin still reaches it. The button plate's end at the fold is 0.2 mm shorter.

## V0.29 changes from V0.28, still current

### No heat-set inserts

The design kept heat-set inserts in the hope that the print service would fit them. No service found fits M2 inserts: JLC3DP fits M3 to M5 only and asks for a 3 mm wall round the hole, and the others do not list the option. So V0.29 replaces every insert:

| Where | V0.28 | V0.29 |
|---|---|---|
| Cover screws (10) | M2 inserts in Ø3.2 × 6 mm holes | The M2 × 10 screws cut their own thread in Ø1.6 × 6 mm pilots (`cover_pilot_d`), as the battery cap screws already do |
| Clamp (2) | M4 inserts in Ø5.6 × 8.1 mm holes | The M4 × 16 bolts cut their own thread in Ø3.4 × 8.1 mm pilots (`base_pilot_d`). A nut would sit on the platform, under the remote. A thread-forming screw for plastics has a head of about 8 mm, too big for the Ø7.6 mm counterbores |
| Joystick knob | Radial M2 insert for the grub screw | An M2 square nut (DIN 562, 4 × 1.2 mm) in a slot open toward the cover (`knob_nut`), 0.65 mm from the pin bore. The engraved cross starts 4.9 mm from the centre so it clears the slot |
| Lock knob | M3 insert from inside the cup | An M3 nut in a hex pocket on the knob's outer face (`lock_nut`). Screw tension pulls the nut onto the pocket floor, and the lock nut jams against it. V0.32: no lock nut; epoxy on the thread fixes the nut |

![V0.33 joystick knob from below, with the square-nut slot beside the pin bore, and the lock knob with its M3 nut pocket.](images/complete-remote-v0.33-print-knobs.png)

The engraved cross on the joystick knob shrinks to four 0.6 mm ticks at the rim. Cost: printed threads in PETG wear with each opening. The cover and the clamp are rarely undone; the battery cap screws were already like this. The pilot sizes are first estimates and need a check on the first print.

### Battery cap boss

The cap's front screw boss is 0.3 mm lower, so the joystick board's J1 no longer touches it ([V0.28 path check](assembly-video-v0.28-checks.md)). It still stands 1.3 mm past the M2 × 8 screw tip.

## V0.28 changes from V0.27, still current

### One base for every bar

The clamp bore is always 25.4 mm plus the 1 mm TPU liner (Ø27.4 mm). A 25.4 mm (1 in) bar takes the liner alone. A 22.2 mm (7/8 in) bar takes two printed PETG sleeve halves, 1.6 mm thick (`sleeve_t`), between the bar and the liner. Each half stops 0.5 mm short of the split (`sleeve_gap`), so the halves close onto a bar a little under size instead of meeting edge to edge as a rigid ring. The sleeve is printed for the measured bar: set `bar_diameter` to the caliper reading at the clamp. A painted bar measured 22.5 mm, 0.3 mm over the nominal 22.2 mm; a sleeve bored to 22.2 would bear only on its edges there. At 22.5 mm the wall is 1.45 mm, and the checks below pass the same. Tapered 28.6 mm bars come down to 22.2 mm at the controls.

A single thick rubber liner (2.6 mm for a 22.2 mm bar) was considered and dropped: it would let the remote turn a little at each press and lose preload with time. The rigid sleeve sets the size; the thin liner gives the grip and takes up the tolerance. The bolts, the insert holes and the platform were already sized for the 25.4 mm bore, so nothing else changes.

Torque estimate, to check on the bike. All three inputs are assumed, not measured: a 20 N gloved press on button A, 33 mm off the bar axis, makes about 0.7 N·m; two M4 bolts preloaded to about 500 N each in heat-set inserts; and a friction coefficient of 0.3 at the smoothest interface (PETG on the bar). With these, the clamp holds about μ × 1000 N × 11.1 mm = 3.3 N·m, so the margin is about 4.7.

### Vent in the battery cap

In V0.27 the Ø10 mm vent label sat on the housing's bottom wall at X = −41 mm. It ran 3.2 mm into the cover, the keypad and the joystick plate, and only 7.3 mm of that wall is free between them and the cap's front block. The vent now goes through the battery cap, centred in the cap opening (`vent_x` = −26.1 mm). The label sits on the cap's inner face, facing down. Takachi advises against vents on top faces, where rain collects on the filter. The label is now a Ø7.6 mm adhesive ePTFE vent (`vent_pad_d`, the size of [Takachi's VE8](https://takachi-enclosure.com/products/VE8)). It leaves 1.1 mm to the opening's edges, and the foam pad on the cap gets a hole round it. The housing loses its vent hole.

## V0.27 changes from V0.26, still current

### Joystick board rev C

The lower cover bosses stand on the lower facet, 20° from the upper ones. Their Ø6 mm columns pass through notches in the joystick board with 0.3 mm clearance and reach the joystick plate. When the housing moves along X, as it must for the upper bosses, the XIAO and the control board, each lower boss also slides 0.34 mm down the facet for every millimetre along X. In V0.26 it hit the board from about 10 mm out (19 mm³ at 6.6 mm). No straight direction worked, and fitting the joystick group to the housing first did not either ([V0.26 path check](assembly-video-v0.26-checks.md)).

[Joystick board rev C](../electronics/joystick-pcb-rev-c/README.md):

- **Slots.** The two notches toward the fold run 3 mm down the facet as slots (`joy_pcb_slot`), the way the bosses slide. 2 mm still overlapped (1.7 mm³). At 3.5 mm the slot came within 0.17 mm of a switch pad, under the 0.3 mm board-edge clearance; at 3 mm it is 0.67 mm away. The notches away from the fold stay round: there the bosses slide off the board edge.
- **Screws.** The two PCB screws and the plate standoffs move to the lower half, at (∓6.5, −6.4) mm in the joystick frame (`joy_standoffs`). In V0.26 one screw sat at (−6.0, 6.4), in the path of a sliding boss, and the upper half has no room left between the switches and the slots. The new places keep the standoff courtyards 0.2 mm clear of the side switches and of J1. They are 0.82 mm from the switch pads and 0.37 mm from the lower notches.
- **J1** moves 1 mm to the centre line (`joy_j1`), to pass between the two screw heads (0.35 mm each side).

The housing then moves along X from 45 mm out to its seat without an overlap over 0.01 mm³ (0 to 15 mm in 0.25 mm steps), except the 0.015 mm³ contact of J1 at the seat that V0.26 already had. The cover comes off the same way. The [V0.27 path check](assembly-video-v0.27-checks.md) agrees.

**Cost.** Both screws now sit on one line below the stick axis, so the upper half of the board is held only by the board itself. The up switch pushes on it when the stick tilts up. Treated as a 20.6 mm wide, 1.6 mm FR4 cantilever clamped on the screw line and loaded at the up switch, 13.2 mm away, it bends about 0.011 mm under 2 N (E = 20 GPa), against the 0.05 mm rest gap (`joy_rest_gap`). This is a hand estimate that leaves out the printed standoffs; check it on the first print.

## V0.26 changes from V0.25, still current

### Control board and keypad

- **Buttons.** Three C&K KSC221JLFS sealed tact switches on the front of the [control board](../electronics/control-pcb/README.md), at Y = 33, 15 and −3 mm, replace the APEM buttons, their nuts and their wires.
- **Keypad.** The gasket becomes one printed TPU part: a full sheet on both facets, with three Ø12 mm keys standing 3 mm out of the cover through Ø13 mm holes. Behind each key the sheet presses the switch actuator directly, 0.3 mm away at rest (`key_rest_gap`), which covers about 0.25 mm of print and sheet tolerance. The sheet's back is flat, so it prints keys up without support. The upper-facet wall-land gasket and the gasket lip are gone.
- **Button plate.** A 1.5 mm printed plate behind the upper sheet, like the joystick plate on the lower facet. The six upper cover screws clamp it against the sheet. Ø15.8 mm holes round the keys let the sheet flex and hold the switch bodies; two 2.3 mm standoffs, 3.95 mm either side of the centre line between the keys, carry the control board.
- **Stack** (from the cover face): cover 2.5, sheet 0.6, plate 1.5, switch actuators at 3.4, control board 6.9–8.5, 5.7 mm headers and the XIAO's 2.5 mm pin spacer, XIAO board at 16.7, its components to 21.3 mm (X = −36.2 mm), 7.2 mm from the pouch envelope. (V0.28 with the measured XIAO: the board sits at 17.1 in the worst case and its 3.0 mm components still end at 21.3; see "Open unknowns".)
- **XIAO.** Bought with pins (102010631) and plugged into two 1 × 7 female headers on the back of the control board, component side toward the pouch. The housing rails and the XIAO's path in from below are gone. A foam pad between the XIAO and the pouch holds it in its headers.
- **Cover screws.** The upper bosses start behind the button plate, like the lower ones, and pass through notches in the control board, so the board, the XIAO and the plate lift out with the cover. All ten cover screws are M2 × 10. The upper screw at Y = 6 mm moved to −6 mm, because the XIAO cannot pass bosses at Y = 6 when it lifts out; the span between the upper screws at 24 and −6 mm is now 30 mm.

### Cables and battery

- **Joystick board rev B** ([board](../electronics/joystick-pcb-rev-b/README.md)): the PTC fuse and TVS move to the control board; a 5-pin JST SH socket on the rear, below the stick axis, takes a 5-pin cable that runs round the board's top edge to the control board.
- **USB-C board rev B** ([board](../electronics/usbc-pcb-rev-b/README.md)): 16 mm deep instead of 13.6 mm, holes at ±7 mm; a 3-pin socket behind the receptacle. The charge LED hangs from VBUS and the charger's STAT switches it.
- **Pouch.** Fitted protection board up. Its own JST PH lead leaves the top end below the USB-C board's rib and runs forward and up to a top-entry socket on the control board: 27 mm in the CAD. No splice, no extension. Changing the pouch needs the cover off as well as the battery cap. A design with an extension and a junction by the cap was checked and dropped: the junction (about 16 × 6 × 4.5 mm) does not fit in the 4.2 mm under the pouch, and no 5–6 cm retail extension was found.

## V0.25 changes from V0.24, still current

The XIAO rails, the battery wires and the pouch orientation below were replaced in V0.26 (see above).

### Why the pouch moved to a bottom cap

V0.24 left the pouch to go in through the front with the cover off. That was never checked, and it does not work. A sweep of the pouch from the front to its place, run on the meshes with the cell 0.2 mm larger than nominal, shows:
- The gasket lip leaves 16.4 mm across the front opening along the upper facet, less than the 20 mm pouch. Edge-first, the pouch passes the lip (0 mm³), but turning it flat inside always meets the lower cover-screw bosses (at best 26 mm³ in V0.24).
- Flat, through the lower facet opening (no lip there) at about 23° and then back: 0.02 mm³ with the V0.24 bosses, and a clean path with 0.4 mm per side only after lengthening the lower facet by 2 mm and moving the lowest screw 2 mm down; 6 of 112 path variants pass. With the 50 mm pouch the XIAO rails are also in the way (about 470 mm³).
- Through the bottom end, straight up along +Y: no overlap with the rails, bosses, USB-C rib, XIAO or joystick. Only the bottom wall and the R6 inner rear-bottom corner are in the way (95 mm³; 13 mm³ at R3, 0.7 at R1.5, 0.01 at R1).

Two ways to close the bottom were compared. Extending the cover round the bottom end would need one rigid cover to squeeze gaskets facing X and Y at once: fitted along X, it would not compress the bottom face at all, and fitted at 45° it would give about 71 % on each face with as much sliding. It would also reach the rear face next to the lock hole. A separate cap squeezes its own flat gasket along Y, and a strip of housing between the two openings keeps the two gaskets apart, with no T-joint. V0.25 uses the cap.

### XIAO without headers

- **Board.** The XIAO without headers (Seeed 102010448). The signal wires solder to the front of its pads, the battery wires to the `BAT` pads on the rear. The rear keeps 1.0 mm for joints and leads (`xiao_rear_h`) instead of the 2.5 mm spacer and 6 mm pins, between the rail lips.
- **Rails.** The slot drops the spacer room and keeps 0.3 mm each side for solder on the edge pads under the lips (`xiao_fillet`).
- **Bench board.** The pre-soldered XIAO stays on the breadboard; the remote needs a second, unheadered one.

### Pouch and battery cap

- **Pouch.** A 6 × 20 × 50 mm pouch (602050; 600 mAh in the [listing](https://es.aliexpress.com/item/32878657347.html), not verified; €4.69 there on 2026-10-13 before shipping). Envelope X = −29 to −22, Y = −33.5 to 17.5 mm, behind the XIAO, 2.4 mm from its rear joints to the cell. Cells up to 54 mm long, protection board included, fit (checked at 50, 52, 53 and 54 mm; 12 mm³ at 55). With the V0.24 pins a 50 mm cell would overlap them (101 mm³), and an 8 mm thick one does not fit.
- **Opening.** The pouch slides in along +Y through an opening in the bottom end from X = −31 mm (`cap_open_x0`) to the cavity rear wall, the full 21 mm cavity width. The inner rear-bottom corner drops from R6 to R1 (`cavity_rear_bottom_corner`) and the outer one from R7 to R2 (`pod_rear_bottom_corner`), so the cell slides past and the cap's rear edge is not a feather.
- **Cap.** The pod below Y = −37.7 mm (`cap_y`) from X = −35 mm (`cap_front_x`) back is a separate printed cap, 2.4 mm thick, held by three M2 × 8 countersunk screws along Y into Ø1.6 mm pilots: one in a Ø5 mm boss on the front block, two in the rear wall 7 mm either side of the centre, clear of the lock hole. The screws take 5.0 mm of thread in the housing.
- **Gasket.** A flat gasket, 0.8 mm printed or cut, squeezed to 0.6 mm like the cover gasket (`gasket_gap`). Its lands: 3.8 mm on the front block, 3.8 mm on the rear wall and 2.5 mm on each side.
- **Wider bottom band.** Below Y = −36 mm (`cap_wide_y`) the pod is 26 mm wide, with a 45° chamfer back to 23 mm, so the side walls there are 2.5 mm and carry the gasket. This band is 44 mm or more from the bar axis, like the 26 mm control end; check it against the switchgear on the bike.
- **Front block.** A block across the cavity from X = −35.5 to −31 mm carries the front land and the screw boss. Its −X face bridges the cavity width when the housing prints, like the rear wall.
- **Lock.** The cap face is 2.8 mm below the lock hole.
- **Vent.** It moves to X = −41 mm, in front of the cap; its Ø10 mm label area is clear of the block and the bosses. (V0.28 moves it into the cap: the V0.26 lower-facet stack overlaps that area.)
- **Battery wires.** The `BAT` pads face the pouch once the XIAO is in. Solder two wires to them before sliding the XIAO in, run them down past the pouch to the opening, and splice them to the pouch leads there. The protection board end of the pouch goes down; the leads and the splice sit in the 5 mm between the cell and the cap.
- **Holding the pouch.** It slides, so it cannot go in on adhesive tape. A foam pad on the cap holds it up and a foam strip on the rear wall holds it against the XIAO side.
- **Battery change.** The cap comes off with the remote on the bench, without opening the cover.

## V0.24 changes from V0.23, still current

The pouch, vent and rear-bottom corner below were changed again in V0.25 (see above).

### Base and remote

- **Base.** The clamp ring stays on the bar: two halves split through the bar axis, two M4 × 16 bolts, M4 inserts in the front half (V0.29: pilots, no inserts), a 1 mm TPU liner. Its outside grows from Ø44 to Ø46 mm, and the bolts move from ±17 to ±18.5 mm, so the same layout suits a 25.4 mm bore. In front of the bar the base is cut flat at X = −17.2 mm (`platform_x`), 3.5 mm in front of the 25.4 mm bore with its liner. That flat platform runs from Y = −41 to +33.5 mm.
- **Bar sizes.** One base per bar size: `bar_diameter` = 22.2 (7/8 in) or 25.4 (1 in). (V0.28: one base for both, with a sleeve for 22.2 mm.) The bore changes; nothing that meets the remote does. Tapered 28.6 mm bars come down to 22.2 mm at the controls.
- **Remote.** The V0.23 pod without the ring and the shoulders, cut flat at X = −17.4 mm (`rear_x`). The cavity's rear wall moves from X = −22 to −21.2 mm, which gives the XIAO pins 2.2 mm instead of 1.4 mm.

### Why a sliding dovetail, not a bayonet around the bar

The [battery study](battery-study.md) first proposed a bayonet turning around the bar. Modelling showed that the clamp bolts at about ±17 mm stand where the remote's saddle would have to turn: the remote could only turn through about ±25°, with short lugs. A dovetail that slides along the pod's long axis keeps clear of the bolts, needs no ring around the bar inside the remote, and leaves the pod where it was.

### Dovetail and fitting

- **Rails.** Two 8 mm rail segments on the platform, at Y = −12.5 to −4.5 and 4.5 to 12.5 mm, with a 9 mm gap. Each is 10 mm wide at the platform and 15 mm at its top, 2.5 mm high, with 45° flanks.
- **Groove.** In the remote's rear face, the dovetail grown by 0.2 mm (`dt_c`). Two 7 mm lip segments hold the rails. Between and beyond the lips the opening is as wide as the rail heads.
- **Fitting.**
  1. Pull the lock knob.
  2. Hold the remote 9 mm (`slide`) below its working position and press it onto the platform; the rails pass through the wide openings.
  3. Slide it up (+Y) until the lower rail meets the closed end of the groove. The lock drops into its hole.
- **Removal.** Pull the knob, slide the remote 9 mm down, and lift it off.
- **Loads.**
  - Button presses push the remote onto the platform.
  - A joystick push has an upward component (sin 20° of the push, from the 20° lower facet), which drives the remote against the stop.
  - Pulls away from the platform load the dovetail lips.
  - Only forces that slide the remote down load the lock: tilting the joystick down, shocks, and gravity, depending on how the unit is mounted.
- **Anti-rattle.** Two rubber strips, 4 × 50 mm, sit in pockets on the platform either side of the rails and stand 0.8 mm proud (V0.32: cut from an inner tube, the pocket depth set by the tube's thickness). They push the remote off the platform until the dovetail flanks seat, with the rear face 0.48 mm off the platform, which leaves the strips about 0.3 mm compressed. A firm press moves the remote back onto the platform by up to 0.48 mm. Whether that feels loose on the buttons needs a test.

### Buttons

Replaced in V0.26 by the keypad and the control board (see above).

- **APEM ISR3SAD200.** Sealed IP67 pushbutton: round curved black actuator, normally open, solder lugs, gold-plated contacts, standard Ø17.5 mm bezel with a flat seal, M12 × 0.75 bushing and a 14 mm A/F hex nut. The datasheet gives 4 ± 3 N, 1.7 mm travel, 10 g vibration and 100 g shock.
- **Cut-out.** Ø13.6 mm with APEM's anti-rotation flat, 12.9 mm across, in place of the round cut-out with a 45° top.
- **Layout.** The bezels need a flat seat on the upper facet, so the buttons move up 1 mm to Y = 33, 15 and −3 mm, the pod top from 44 to 45.5 mm, and the upper-facet cover screws to 40.5, 24 and 6 mm. Each bezel stays 0.75 mm from the fold and from the top corner radius. The pitch stays 18 mm; APEM recommends 20 mm.
- **Nuts.** A hex nut can stop at any angle, so the CAD checks a Ø16.2 mm circle (its corners) behind each button: clear of the housing, the gasket, the joystick and each other once the gasket lip is 2.8 mm wide instead of 3 mm. There are 1.8 mm between nut corners at 18 mm pitch, so the nuts need an open-end wrench, not a socket.

### Lock

- An M3 × 20 ISO 4762 screw (V0.24–V0.31: M3 × 22) is the lock pin: its Ø5.5 × 3 mm head runs in a Ø6 mm pocket in the platform at Y = −32 mm, below the clamp ring and clear of the lower bolt.
- A 0.5 × 5 × 10 mm stainless compression spring (wire × outside diameter × free length) under the head pushes it 2 mm out of the platform, with about 3.4 N (estimated, not measured), into a Ø5.8 mm hole in the remote's rear face. A positive stop, not a detent: the remote cannot slide down until the head is pulled in.
- The shank runs back through the base to a Ø16 × 8 mm printed knob with an M3 insert (V0.29: an M3 nut in a pocket), locked by a nut. The knob rests on the back of the platform block (X = −5 mm) and sets how far the head stands out.
- **Quarter turn.** The knob is a cup over a Ø9 × 3.5 mm boss on the back of the block. Two Ø1.5 × 4 mm steel dowel pins through the cup wall run in L-slots in the boss. Locked, the pins sit in the circumferential part of the slots and the knob cannot be pulled; turning it 90° brings them to the axial part, and then it pulls out 2 mm. The CAD checks the knob locked, turned 45° and 90°, and pulled, with no overlap, and that it cannot be pulled while locked or half-turned.
- **Vibration.** Vibration alone should not pull the head in: the moving parts weigh about 2.5 g, so the 3.4 N spring needs about 140 g along the pin axis to be overcome (an estimate). The quarter turn is against a branch or a strap pulling the knob.
- Turning the knob 90° and pulling it 2 mm pulls the head flush. When the remote is pressed on at the entry position, its rear face pushes the head in; the head springs out when the hole comes over it.
- Only 1 mm of the head stays in its pocket when locked. The shank, guided over 5 mm in the base, takes the moment.

### Battery, charging and vent

- **LiPo pouch.** Replaced in V0.25. A fixed pouch in the lower rear of the cavity, below the XIAO and behind the USB-C plug zone: envelope X = −29 to −22, Y = −33.5 to −2.5 mm, 21 mm along the bar. It takes a 6 × 20 × 30 mm pouch (602030, about 300 mAh in listings, not verified) with 0.5 mm all round. That space was free in V0.23 apart from the cable route; the earlier fit search had excluded everything below the fold. The pouch is held with foam tape and wired to the XIAO `BAT` pads.
- **USB-C charging.** A GCT USB4736-GF-A charge-only (6-contact) USB-C receptacle in the rear face, IP67 with its USBTJ-06 silicone gasket (both in the kit USB4736-GF-A-KIT), centred at Y = 29.5 mm with its long side along the bar. It sits above the groove, so the platform (to Y = +33.5 mm) covers it on the bike; any USB-C cable charges the remote off the bike, and no charging dock is needed. The receptacle is on a small breakout PCB with the two 5.1 kΩ CC pull-downs, without which a USB-C charger supplies no 5 V. VBUS and GND go to the joystick PCB 5 V input, through its PTC fuse and TVS diode. This port only charges: the XIAO's own USB-C stays for programming. The CAD follows GCT's drawing (USB4736, revision A, 9 April 2025, via SnapEDA): the wall is thinned from inside to GCT's 1.80 mm panel, with a 9.14 × 3.36 mm slot (R1.43) and an 11.00 × 5.90 mm gasket pocket (R1.60) 0.60 mm deep. The 0.90 mm USBTJ-06 gasket is squeezed to about 0.53 mm (41 %; GCT asks for 35–45 %). The receptacle's 1.20 mm nose sits in the slot, 0.53 mm back from the rear face. It is soldered to the [USB-C charging PCB](../electronics/usbc-pcb/README.md), a 19 × 13.6 × 1.2 mm board that lies flat on a rib spanning the cavity and is held by two M2 × 4 button-head screws that cut their own thread; the screws fix where the receptacle squeezes its gasket. It is the only part found that is sealed and keeps the CC lines; the waterproof USB-C parts sold on Amazon either lack CC pins (so USB-C chargers give no power) or are too large for the 23 mm rear face. It is sold by DigiKey, Mouser, Farnell and TME, not on Amazon. Earlier in this branch the charge path was two brass contacts and a charging dock; USB-C replaced them because it needs no dock, is keyed, and is a standard.
- **Charge LED.** A red side-looking LED (Lite-On LTST-S270KRKT) on the same PCB, at its front edge 7.5 mm to the +Z side of the receptacle axis, shines through a Ø1.6 mm hole in the panel (`usbc_led_*`). The hole is on the emitter axis, 0.30 mm above the board, 1.2 mm beside the gasket pocket and 0.5 mm beside a 12.4 mm plug overmold, so it stays visible with the cable in. It is filled with clear two-part epoxy, flush outside. The firmware lights it while the cell charges and turns it off when charging ends; see the [battery study](battery-study.md#firmware). On the bike the platform covers it. The board grew from 14 to 19 mm wide to carry it, and leaves 1.0 mm to each axial wall. There is no power switch: the remote sleeps (System OFF) after 6 h without input or when A, B and C are held for 3 s, and any button wakes it.
- **No cable gland.** The bike cable, the gland and its lock nut are gone.
- **Vent.** It moves from the axial wall to the bottom end wall at X = −32 mm, where the gland was, so the pouch does not cover it. V0.25 moves it to X = −41 mm, in front of the battery cap.

### Joystick switches

- **Part.** The joystick PCB now uses the C&K KSC221JLFS (LCSC C221726). The KSC222JLFS (C221728) was out of stock at LCSC on 2026-10-13. Both have 2 ± 0.5 N force, the same body and the same J-bend land pattern, so the PCB layout is unchanged. The KSC221J has standard silver contacts instead of long-life silver: 500,000 operations instead of 1,000,000.
- **Knob.** The KSC221J can travel up to 0.65 mm instead of 0.5 mm, so the knob push gap grows from 0.7 to 0.9 mm (`knob_gap`) and the knob from 5.5 to 5.7 mm proud (`knob_proud`). The knob keeps 0.8 mm over the pin. The radial insert moves to 3.2 mm below the knob top (`knob_insert_z`, was 2.9 mm), between the rim underside and the engraved cross.
- **Checks.** A direction trips at no more than 5.9° of tilt (4.7° before); the knob stop stays at 8.2°. The knob tilted to the stop in four directions and on a diagonal, and pushed to the stop, stays clear of the cover, housing, plate and button heads. The only overlap, 0.04 mm³, is the faceted ball on its seat.

## V0.23 changes from V0.22, still current

The LCSC land pattern for the KSC222JLFS (C221728) puts its pads 0.95 mm outside the switch body, on two opposite sides. The V0.22 layout had not allowed for that.
- **Switch orientation.** All four switches turn 90°. The pad rows of the up and down switches run along the facet; those of the two bar-axis switches run across it. The nearest pads of neighbouring switches are then 1.55 mm apart.
- **Standoffs.** They move from (∓5.6, ±5.4) to (∓6.0, ±6.4) mm in the joystick frame, 0.55 mm clear of the switch pads.
- **PCB outline.** A 20.6 × 22.4 mm rectangle with a 3.3 mm radius notch around each lower cover-screw boss. The boss ends reach 0.25 mm past the PCB front face, so the board must clear them. The CAD and the KiCad board use the same numbers.
- **Rear zone.** 1.0 mm behind the whole board for solder joints, vias and screw heads, and 3.0 mm in the upper half and in the two side strips for the TVS diode (2.45 mm maximum), the PTC fuse and the soldered wires. The lower middle stays at 1.0 mm because a USB-C plug in the XIAO passes close behind it when the cover is off.
- **PCB screws.** M2 × 8 button heads, at most Ø3.5 × 1.1 mm. A pan head (1.6 mm) would touch the 12 mm wide USB-C overmold envelope with the cover off.
- **Power input.** The 5 V input goes to the joystick PCB, through a PTC fuse and a TVS diode, and the PCB feeds the XIAO's 5V pin. In V0.24 that input comes from the charging USB-C receptacle instead of the bike cable.
- **Firmware.** The specification now describes the four-switch chord as the centre press; D7 is unused. The diagnostic sketch implements the chord. (A separate centre switch on D7 stayed as a breadboard build option until firmware 0.11.1.)

## V0.22 changes from V0.21, still current

V0.21 replaced the joystick with four Ø7 mm keys. That direction was dropped, for three reasons:
- Ø7 mm keys with 1.6 mm between them are too small for gloves; a reference guideline asks for at least Ø10 mm for a bare fingertip.
- On the 20° lower facet, flat keys are hard to see, and the thumb has to press them from below.
- A joystick sticks out and is pushed sideways, so it works on that facet.

V0.22 keeps from V0.21 the sheet gasket and the plate that clamps it, and replaces the keys with a joystick.

- **Joystick mechanism.** In the joystick frame, from the outside in:
  - A Ø16 mm knob stands 5.7 mm proud. A Ø9.2 mm hub on its underside is 0.9 mm above the cover; its rim is 1.15 mm above. (5.5 and 0.7 mm before the V0.24 switch change.)
  - The stick is a Ø3 × 12 mm steel dowel pin (ISO 8734). It passes through a Ø5.6 mm hole in the cover, and the sheet gasket grips it through a Ø2.4 mm hole. Steel is stronger than a printed Ø3 mm stick, and its smooth surface seals better against the sheet.
  - A printed Ø6 mm ball bears against the back edge of a Ø3.6 mm hole in the 1.5 mm joystick plate. That edge is the pivot, 7.0 mm behind the outer face. The pin is pressed into a bore through the ball and disc.
  - A cross disc, 1.2 mm thick, under the ball rests 0.05 mm above the actuators of four KSC2 switches. The switches are 6.75 mm from the axis, two along the facet (up toward button C, down) and two along the bar.
  - The PCB screws to two standoffs on the plate. Its front face is 10.85 mm behind the outer face; the rear zone ends at 13.45 mm, or 15.45 mm where the rear parts are (V0.23). The MHS body reached 16 mm.
  - The ball and disc are one printed part. The knob slides onto the pin from outside after assembly, and an M2 × 4 grub screw in a radial M2 heat-set insert clamps it (V0.29: in an M2 square nut). It comes off with a hex key; nothing is glued.
- **Feel and limits.**
  - A direction trips at no more than 5.9° of tilt. At that point the knob top has moved at most 1.3 mm.
  - The knob rim meets the cover at 8.2° of tilt, and the hub at 0.9 mm of push. That is past the switches' 0.70 mm worst case (0.05 mm rest gap plus the KSC221J's 0.65 mm maximum travel), so every switch has tripped before the knob stops.
  - With switches nearer the 0.35 mm nominal travel, the disc reaches the bottom of the switch travel before the knob stop, and a hard press loads the switches. The datasheet gives no overtravel or maximum force for the soft actuator; check on the bench whether the knob stop is reached and whether the gap should close.
  - The disc has room to tilt 9.5° before it meets the plate.
  - The switches' own springs centre the stick and hold the ball on its seat. There is no separate spring.
- **Centre press.** Pushing the stick straight in presses all four switches. The firmware reads that chord as the centre press (three or more switches within a short window) and otherwise reports the held directions. A fifth switch would have to sit on the axis, where the ball and disc are.
- **Wider control end.** For X below −38 mm, which covers the cover, the buttons and the joystick, the pod is 26 mm wide with 2 mm axial walls, leaving a 22 mm cavity. A 45° chamfer of 1.5 mm per side (`pod_step`) joins it to the 23 mm part; the walls in the chamfer are at least 1.1 mm thick, and the chamfer faces up when the housing prints. The clamp ring, the shoulders and the XIAO area keep 23 mm with 1 mm walls. The 23 mm comes from the NAVCOMM manual's minimum free space on the bar between grip and switchgear. It applies to what sits on the bar, not to the control end 40–60 mm from the bar axis. The 2 mm walls give four perimeters instead of two, which seals and prints better. The cover screws stay 3.25 mm from the outer faces, so their bosses intrude 1 mm less into the cavity.
- **Joystick plate.** It is the V0.21 keypad plate with a seat hole, a 0.6 mm pocket in front so the sheet can follow the stick, and 6.25 mm standoffs for the PCB. The four lower cover screws (M2 × 10) still clamp it and the sheet.

### V0.21 changes, still current

- **Sheet gasket on the lower facet.** On the lower facet the gasket is a full sheet between the cover and the plate. It seals the cover joint and the joystick opening. The upper facet keeps its wall land.
- **Lower cover screws.** M2 × 10 through the plate, 5.4 mm into the inserts (V0.29: into pilots); their bosses start behind the plate. The six upper-facet screws stay M2 × 8.

### V0.20 changes, still current

- **Folded front.** The fold line is 12.5 mm below the bar axis, between button C and the joystick. The lower facet is 30 mm long and turns 20° toward the bar (`fold_angle`), so its lower end sits 10.3 mm closer to the bar. This clears the thumb's path to the turn-signal switch, which the straight V0.19 face obstructed. The joystick axis is 14.5 mm below the fold.
- **Why 20° and not 30°.** At 30° the end wall becomes too short for the gland lock nut beside the corner screw bosses. The 30° values are noted next to `fold_angle` in the CAD.
- **Pod length.** In V0.24 the buttons are at Y = 33, 15, −3 mm and the pod spans Y = −40.7 to 45.5 mm (86.2 mm), 1.5 mm longer than in V0.23 (32, 14, −4; 44 mm), to fit the real APEM bezels. The axis-to-button-C distance is 57.5 mm perpendicular to the bar.
- **Cover gasket.** 0.6 mm when compressed: printed 0.8 mm thick in a soft TPU, or cut from 0.8–1 mm silicone or EPDM sheet using the flat model as a template. On the upper facet the housing land is the wall plus a 3 mm lip inside both axial walls, and a Ø6 mm pad around every screw.
- **Cover screws.** Ten countersunk M2 screws in pairs at five positions. The largest spacing along the perimeter is 21.8 mm.
- **Cover printing.** The cover prints on its axial face, because the fold would need support face down.
- **Cable gland.** Removed in V0.24; it was in the bottom end wall at X = −32 mm.
- **Vent.** In V0.24, a Ø3 mm hole in the bottom end wall at X = −32 mm takes an adhesive ePTFE vent label inside.
- **XIAO.** At Y = 10 mm, so a USB-C plug clears the lower screw bosses when the cover is off.

## Interior space check

The OpenSCAD console reports these values; the boolean checks below were run on the rendered meshes. The V0.24 checks cover the base, the dovetail, the lock, the pouch and the USB-C receptacle. The control-end checks were run on V0.23 and not repeated: nothing in front of the remote's rear face changed except the rear wall, which moved 0.8 mm away from the controls.

V0.26 (cables are modelled as Ø2.5 mm bundles, plugs as boxes from the connector drawings):

| Check | Result |
|---|---|
| Control board, its switches, back parts and sockets, XIAO and headers vs housing, cover, gasket, joystick, USB-C board, pouch envelope, cover screws | No overlap; the board rests on the plate standoffs |
| Button plate vs housing, cover, joystick plate; keys vs cover and plate; switches vs plate | No overlap or contact only |
| Cover screw bosses vs control board | No overlap: the board is notched round them |
| Control board, XIAO, plate and keys lifted out with the cover, 1–20 mm along −X | No overlap |
| Joystick board and plate lifted out with the cover, along −X (added by the [assembly path check](assembly-video-v0.26-checks.md)) | Overlap with the lower cover bosses from about 10 mm out (19 mm³ at 6.6 mm); no straight path found. Fixed in V0.27 |
| XIAO components to the pouch envelope | 7.2 mm |
| Joystick, USB-C and battery cables and plugs vs housing, plates, gasket, cover, XIAO, USB-C board, pouch, each other | No overlap; each plug enters its own socket courtyard by 0.05 mm, the joystick plug rests on its board's rear face, and the pouch lead starts inside the pouch clearance by design |
| USB-C board (16 mm deep) vs housing, control stack, pouch | No overlap; it rests on its rib |
| Battery lead, J5 plug to the pouch's top end | 27 mm |

V0.27 (joystick board rev C; the rest as V0.26):

| Check | Result |
|---|---|
| Housing moved along X onto the stack, 0–45 mm (0.25 mm steps to 15 mm), against the joystick board and plate, button plate, control board, XIAO, keypad, cover, stick, foam pad and joystick cable | No overlap over 0.01 mm³, except the J1 contact at the seat (0.015 mm³, as V0.26) |
| Joystick board vs lower cover bosses, at the seat | No overlap |
| PCB screw heads vs J1 | No overlap; 0.35 mm each side |
| Plate standoffs vs switch bodies and pads; standoffs and heads vs the board edge | 1.35 mm to the bodies, 0.82 mm to the pads, at least 0.3 mm inside the edge |
| Stick and knob tilted to the knob stop, four directions and four diagonals | Same overlaps as V0.26 (plate 0.051 mm³, cover and housing 0.43 mm³, joystick board 15.8 mm³) |
| Joystick cable and plug vs board, J1 and the rest | Same as V0.26 |
| Joystick board rev C, ERC and DRC with schematic parity | 0 errors, 0 unconnected pads |

V0.28 (base and vent; the rest as V0.27):

| Check | Result |
|---|---|
| Sleeve halves vs bar (22.2 and 22.5 mm), liner, base front, base cap, bolts | Contact only (0.00 mm³) with the bar and the liner; no overlap with the base |
| Liner vs base, 22.2 mm and 25.4 mm bars | Contact only |
| Remote vs base, locked | Only the anti-rattle strips, compressed by design (202 mm³, as V0.27) |
| Vent label (Ø7.6 mm) vs pouch, cap gasket, housing, the whole stack | No overlap; 1 mm or more to the gasket opening |
| Vent hole vs cap screws and countersinks | No overlap |
| Assembly path check, both orders of steps 8 and 9 | Only the J1 contact at the seat (0.015 mm³) |

V0.30 (cover seal; `mechanical/cad/tools/test_seal.py` runs the first six rows):

| Check | Result |
|---|---|
| Loose sheet vs plates and housing, also with the sheet 0.1 mm thick | Touches only the stop pads |
| Housing in front of `rim_off` | None |
| Foam strip on the rim | 99.7 % of its area on housing material |
| Foam strip vs plates, control board, joystick board, XIAO, bosses, cover, sheet | No overlap; contact with the sheet |
| Widened end rims vs plates, boards, XIAO, USB-C board | No overlap |
| Stop pads vs foam and key web holes; sheet holes vs a Ø1.35 mm probe | No overlap |
| Assembly path check, both orders | No collision; the pads' pinch on the sheet (2.98 mm³) is a contact by design |

V0.33 (`mechanical/cad/tools/test_v033.py` runs the first six rows):

| Check | Result |
|---|---|
| Wall thickness, width, height | 2.0 mm walls; 25 mm along the bar; 2 mm taller than V0.32 |
| Cavity | 21 mm wide and the same ends as V0.32; 54,540 mm³ behind the cover band, as V0.32 |
| Boards, XIAO, plates, USB-C board, pouch envelope vs housing and battery cap | No overlap |
| Battery cap screw thread in the housing | 4.0 mm |
| Foam strip on the rim | At least 98 % of its area on housing material |
| Remote vs base, locked | Only the anti-rattle strips, compressed by design (218 mm³) |
| Remote at the entry position (flush, 1 and 1.5 mm off the platform) and along the slide (2, 4.5 and 7 mm) | No overlap with the base or the flush lock |
| Battery cap, cover, keypad vs housing | Contact only |
| Every print part | A closed solid |
| Assembly path check, both orders | No collision ([report](assembly-video-v0.33-checks.md)) |

V0.32 (`test_v032.py`):

| Check | Result |
|---|---|
| Lock screw | M3 × 20, a standard length; 1.0 mm past the nut, its tip 0.8 mm inside the knob face |
| Strip squeeze for a 0.8, 1.0 and 1.2 mm tube | 0.3 mm each; the pocket is 0 mm for 0.8 mm |
| Clamp with a 0.8 and 1.2 mm liner | Every base check passes; platform wall 3.7 and 3.3 mm |
| Square nut in the knob | Inside the knob, nothing below the hub face; no overlap with the knob |
| Hex nut in the knob | Does not fit: 5.32 mm needed, 4.8 mm available |
| Assembly path check | Not rerun: V0.32 changes no remote part |

V0.31 (battery cap; `test_seal.py`, class `CapSeal`):

| Check | Result |
|---|---|
| Cap vs housing | Contact only; the lip touches the housing face |
| Foam gasket vs cap and housing | Contact only; 200 mm² of foam |
| Foam gasket vs the screws | It grips them (Ø1.4 mm holes) |
| Screw thread in the housing | 5.0 mm, as before |
| Vent label vs foam and housing | No overlap; it sits on the cap |
| Assembly path check, both orders | No collision |
| V0.26-era stack, removal (2–20 mm) and joystick tilt checks | As V0.29; the knob rim's contact with the cover at the stop grows from 0.43 to 0.47 mm³ |

V0.25:

| Check | Result |
|---|---|
| Pouch (6 × 20 × 50 mm envelope) vs housing, battery cap and its gasket, XIAO, USB-C receptacle and plug, joystick, XIAO USB-C plug, vent label | No overlap |
| Pouch slid straight up from below the cap opening into place | No overlap with the housing |
| XIAO envelope (rear joint zone 1.0 mm) vs housing | No overlap in place, nor 11 and 22 mm along its slide-in path |
| XIAO put in from below: up through the cap opening 7.5 mm behind the rails to a lower end at Y = −28 mm, forward 7.5 mm, up 27.5 mm (0.5–1 mm steps) | No overlap; 2.0 mm in front and 2.2 mm behind in the opening. With the lower end at −31.5 mm it would hit the cap's front block (28 mm³) |
| XIAO put in through the front instead: edge-first (60–90°), turned flat at X = −40 mm, back to the rails, slid up 22 mm | No overlap (0.0007 mm³ in the turn, faceting); flat, it would hit the lips (128 mm³) |
| XIAO rear joints to the pouch cell | 2.4 mm |
| Battery cap vs housing; cap gasket vs cap and housing | Contact only |
| Remote with cap vs base front, base cap, lock (locked) | No overlap; the TPU strips overlap by design as in V0.24 |
| Remote with cap at the entry position | No overlap with the base |
| Housing vs cover, gasket, joystick plate | Contact only, as in V0.24 |
| Vent label area vs housing | No overlap |
| Cap face to lock hole; cap thickness; screw thread in the housing | 2.8 mm; 2.4 mm; 5.0 mm |

V0.24:

| Check | Result |
|---|---|
| Remote vs base front, base cap, liners, bolts, lock (locked) | No overlap |
| Remote at the entry position, pressed on (lock pushed flush) | No overlap with the base |
| Remote at the entry position, 1 and 1.5 mm before it reaches the platform | No overlap: the rails pass through the wide openings |
| Remote part way along the slide (2, 4.5 and 7 mm from the stop) | No overlap with the base or the flush lock |
| TPU strips vs remote | Overlap by design: the strips are compressed |
| Lock knob vs base and bolts, locked and pulled | Contact only, where it rests on the platform block |
| Pouch envelope vs housing, XIAO, USB-C plug (cover off), joystick, cover bosses, USB-C receptacle and PCB, vent label | No overlap |
| USB-C receptacle, gasket, PCB (19 mm wide), charge LED, its wire zone and screw heads vs housing, XIAO, its rails, cover bosses, cover, gasket, buttons and nuts, joystick, XIAO USB-C plug, base and lock | No overlap; the gasket only touches its land |
| Charge LED window | Ø1.6 mm through the panel; 1.2 mm beside the gasket pocket, 0.5 mm beside the 12.4 mm plug overmold; the LED shows through it (rear-view render) |
| USB-C cable plug (12.4 × 6.5 mm overmold) vs housing, remote off the base | No overlap |
| USB-C PCB rib vs XIAO, its rails and slide-in path, pouch, buttons, USB-C plug (cover off) | No overlap |
| XIAO envelope vs housing | No overlap in place, nor 11 and 22 mm along its slide-in path |
| XIAO pin tips to cavity rear wall | 2.2 mm |
| Groove floor to cavity; lock hole bottom to cavity | 1.3 mm; 1.6 mm |
| Platform in front of the 25.4 mm bore with its liner | 3.5 mm |
| M4 bolt hole to the 25.4 mm bore; insert hole to the base outside | 2.65 mm; 1.7 mm |
| 25.4 mm base variant: remote vs base | No overlap |
| Housing, base front, base cap | Each one closed solid |

V0.23, control end, unchanged:

| Check | Result |
|---|---|
| Button bodies vs housing, cover, gasket | No overlap |
| Joystick switches, pads and PCB with its rear zone vs housing, cover, gasket, stick | No overlap |
| Joystick switches and PCB vs joystick plate | Contact only (PCB on the standoffs) |
| Stick and knob vs cover, plate, housing at rest | No overlap; the ball touches its seat |
| Stick vs gasket | 1.5 mm³ overlap by design: the Ø2.4 mm sheet hole is stretched over the Ø3 mm stick |
| Stick and knob tilted to the knob stop (8.2°), four directions and one diagonal | Clear of the plate, cover and housing; the disc only meets the switch actuators, the rim only touches the cover |
| Knob (also tilted) vs button bezels and caps | No overlap |
| Pin vs ball and disc | 0.67 mm³ overlap by design: press fit in the Ø2.95 mm bore |
| Stick and knob pushed to the knob stop (0.9 mm) | Clear of the plate, cover and housing |
| Joystick plate vs housing, cover | No overlap; contact with the shortened bosses |
| PCB rear zone and screw heads vs USB-C plug (cover off) | Contact only (0.00 mm³) at the lower screw head |
| Cover screws vs joystick, buttons, XIAO; countersinks vs knob | No overlap |
| Wiring space between button rear ends and XIAO component side | 5.5 mm |
| Cover vs housing; gasket vs cover and housing | Contact only, no overlap |

The tightest points are now:
- the 0.2 mm dovetail clearance (`dt_c`). Printed tolerances decide whether the remote slides on freely or rattles; the strips take up some play, but the first print may need `dt_c` adjusted;
- 1 mm of the lock head left in its pocket when locked;
- the lower PCB screw head against the USB-C plug envelope with the cover off (contact). With a plug wider than 12 mm, lift the joystick plate out first; it is loose once the cover is off;
- 0.55 mm between the PCB standoffs and the switch pads, and 0.3 mm between the PCB notches and the lower cover-screw bosses;
- the stack that sets the 0.05 mm rest gap under the disc: switch height, printed plate, ball and disc, and the standoffs. If the stick rattles or a switch is pressed at rest, shim or sand under the PCB standoffs.

## Sealing

V0.24 aims for rain and spray resistance, not an IP rating. It has not been tested.

1. **Buttons.** APEM ISR3SAD200, IP67 front-panel sealing (IEC 60529) with the flat seal under the bezel. The Ø17.5 mm bezel and its seal sit on the flat upper facet, 0.75 mm from the fold and from the top corner radius.
2. **Joystick.** The cover hole is open to the outside. The sheet gasket is the seal there: it is clamped all round the hole and grips the stick. A printed TPU sheet that flexes with every stick movement may tear or creep; a cast silicone sheet would last longer.
3. **Cover joint.** V0.30: a closed-cell foam strip on the housing rim under the loose keypad sheet's edge, round both facets; the sheet grips each cover screw's shank. (Before V0.30 the sheet itself was squeezed over the whole facet, which M2 screws cannot do; see [V0.30 changes from V0.29](#v030-changes-from-v029-still-current).)
4. **USB-C.** The GCT USB4736 is rated IP67 with its USBTJ-06 gasket compressed on the thinned land; GCT says the gasket is fitted after the receptacle is soldered. Pot the back of the receptacle and its PCB with epoxy as a second barrier. The charge LED window beside it is a Ø1.6 mm hole filled flush with clear two-part epoxy. On the bike the platform covers both. The groove and the lock hole are blind and do not open into the cavity.
5. **Vent.** An adhesive ePTFE vent label over the Ø3 mm hole in the battery cap, inside (V0.28; before, in the bottom end wall). Without it, temperature cycles pump humid air into a sealed box, and the water condenses inside. Mount the base so the vent faces down or sideways, not into spray.
6. **Battery cap.** V0.31: a die-cut closed-cell foam gasket on the lands (3.8 mm front and rear, 2.5 mm at the sides), compressed to 1.0 mm by a rigid lip on the cap; the screws pass through the foam. A 3.8 mm strip of housing separates it from the cover seal. The cap faces down and gets spray from the wheel; this joint is untested.
7. **Electronics.** Coat the XIAO, the joystick PCB and all solder joints with conformal coating (acrylic or silicone). Keep it off the USB-C socket, the switch actuators, the pouch, and the vent membrane.
8. **Printed walls.** V0.33: every wall of the housing is at least 2 mm, four perimeters with a 0.4 mm nozzle (V0.32 and earlier: 1 mm in the narrow part and at the ends, two perimeters). In FDM, ask for 100 % infill or at least five perimeters, so the walls are solid. MJF nylon is sold as watertight without treatment; this is not checked for these walls. The leak test decides.

## Printing

| Part | Mode | Orientation | Material group |
|---|---|---|---|
| Housing | `print_housing` | Upper facet on the bed | Remote, rigid |
| Base front | `print_base_front` | Axial face on the bed | Base, rigid |
| Base cap | `print_base_cap` | Axial face on the bed | Base, rigid |
| Lock knob | `print_lock_knob` | Flat face on the bed | Base, rigid |
| Control cover | `print_cover` | Axial face on the bed | Remote, rigid |
| Joystick plate | `print_joy_plate` | Sheet side on the bed | Remote, rigid |
| Ball and disc | `print_ball_disc` | Disc on the bed | Remote, rigid |
| Knob | `print_knob` | Top face on the bed | Remote, rigid |
| Keypad and gasket | `print_gasket` | Flat, 0.8 mm sheet on its housing side, keys up | Keypad, soft TPU (85A or softer); not cut from sheet, because of the keys |
| Button plate | `print_button_plate` | Sheet side on the bed, standoffs up | Remote, rigid |
| Battery cap | `print_battery_cap` | Outer face on the bed | Remote, rigid |
| Cap gasket template (V0.31) | `print_cap_gasket` | Flat, 0.8 mm | Any plastic; a template to cut the foam gasket. A paper template does the same: print `mechanical/cad/tools/cap-gasket-template.scad` at 100 % |
| Liners ×2 | `liner_main`, `liner_cap` | Axial face on the bed | TPU 95A, or cut from the inner tube (V0.32), 25 × 43 mm (V0.33), with `liner_radial` set to its thickness |
| Sleeve halves ×2 (22.2 mm bar only) | `print_sleeve` | End face on the bed | Base, rigid |
| Anti-rattle strips ×2 | not printed (V0.32) | 4 × 50 mm, `strip_t` thick | Cut from a bike inner tube |

The materials are not chosen yet. The [materials study](materials-study.md) compares them for each group: the remote's rigid parts (PA11 by MJF or ASA by FDM), the base's rigid parts (PA12 by MJF) and the keypad (TPU near 85A). It also lists the print quotes found so far.

No part needs supports.
- **Housing:** the walls are vertical, the lower facet is an open edge in the air, the lower screw bosses lean 20°, and the cavity's rear wall and the battery cap's front block bridge 21 mm. The groove is at the top: its lips narrow upward at 45°, and the lock hole and the USB-C slot open upward; the gasket land is a shallow recess in the bridged rear wall. It stands on its thin front rim, so use a brim.
- **Base front:** the rail flanks are at 45° to the bed. The lock pocket and the bolt holes run horizontally and are small enough to bridge.
- **Cover:** the Ø5 mm stick hole is small enough to bridge. It stands on a 2.5 mm edge, so use a brim.
- **Ball and disc:** the ball above the disc narrows upward. Test the press fit of the pin in the Ø2.95 mm bore (`pin_bore`) before assembly.
- **Knob:** the radial grub-screw hole is horizontal and small enough to bridge; the nut slot opens upward.
- **Battery cap:** the countersinks open toward the bed at 45°.
- **Screw pilots:** use 100% infill or at least four perimeters round the M4 pilots in the base front and the M2 pilots in the bosses, where the screws cut their thread.
- **Keypad sheet:** since V0.30 it does not seal by compression, so the hardness sets the key feel and how the sheet grips the stick and the screws. Softer TPU (85–88A) is still preferred. If you cut the sheet, punch the Ø2.4 mm stick hole and Ø1.4 mm screw holes.

## Assembly

Remote (V0.33, the same as V0.31 and V0.32; nothing to solder, no hot tool):
1. Clear the ten Ø1.6 mm pilot holes in the housing screw bosses with a 1.6 mm drill held by hand; printed holes come out undersize.
2. Fit the USB-C board rev B: fit the receptacle's gasket, carry the board in 1.5 mm above its rib past the upper cover bosses, lower it onto the rib 8 mm short of the rear wall, and slide it along the rib until the nose enters the slot and the gasket sits in its pocket. Fix it with two M2 × 4 button-head screws, which cut their own thread in the Ø1.6 mm pilots. Pot the back of the receptacle with epoxy, keeping it out of the opening and the socket. Fill the LED window from outside with the same clear epoxy. Plug the 3-pin cable into its socket.
3. Joystick: push the stick through the joystick plate from the back, so the ball sits in its seat. Screw the joystick board rev C onto the plate standoffs with two M2 × 8 button-head screws; the disc rests on the switches. Plug the 5-pin cable into its socket.
4. Screw the control board onto the button plate standoffs with two M2 × 4 button-head screws, switches toward the plate. Plug the XIAO into its headers, components away from the board, USB-C toward the joystick end.
5. Lay the cover face down and the keypad on it, keys through the cover holes, folded at the fold line. Push the stick through the sheet hole and the cover hole, and lay the joystick plate on the lower-facet sheet. Lay the button plate with the control board on the upper-facet sheet.
6. Plug the joystick cable into J4 and the USB-C cable (from the housing) into J3 on the control board. Stick a pad of six layers of the seal foam on the XIAO's components.
7. Stick the foam strip on the housing rim round both facets, with butt joints at the end corners, and one layer of the same foam on the rear wall where the pouch lies.
8. Lower the housing onto the stack, guiding the cables; its walls locate the plates. Turn it over and fit the ten M2 × 10 screws; they cut their own thread, so drive them slowly the first time. Tighten evenly in a cross pattern.
9. Slide the pouch up through the bottom opening, protection board and lead first. With the cover off, plug its lead into J5 on the control board, then close the cover as in step 8. Check the polarity before connecting the charger.
10. Stick the vent label on the inside of the battery cap, over its vent hole, and a pad of four layers of the seal foam with a hole round the label. Stick the foam cap gasket inside the cap's lip, then fit the cap with three M2 × 8 countersunk screws; the lip meets the housing when they are tight.
11. Drop the M2 square nut into the slot under the knob and start the M2 × 4 grub screw in it from the rim. Slide the knob onto the pin with a 0.9 mm shim between the hub and the cover, and tighten the M2 × 4 grub screw.

The order of steps 8 and 9 is open: the pouch can go in before the cover is closed if its lead is long enough to reach J5 with the stack beside the housing.

Base:
1. Clear the two Ø3.4 mm pilot holes in the base front's split face with a 3.4 mm drill held by hand.
2. Press the two Ø1.5 × 4 mm dowel pins into the lock knob, and an M3 nut into the hex pocket on its outer face. Drop the lock spring into the pocket and push the M3 × 20 screw through it from the platform side. Fit the knob over the boss with the pins in the axial slots, thread it onto the shank until the head stands 2 mm proud with the knob on the block, and turn it to the locked position. Check the pull and the release, then put a drop of the clear epoxy on the thread at the nut and leave it to cure.
3. Cut the two strips from the inner tube and glue them into their pockets.
4. On a 22.2 mm bar, fit the two sleeve halves round the bar first. Fit the liner halves, place the base on the bar with the platform where the remote should sit, fit the cap from behind, set the angle, and tighten the two M4 × 16 bolts evenly.

Fitting: pull the lock knob, press the remote onto the platform 9 mm below its working position, and slide it up until it stops and the lock clicks in. Removal is the reverse.

To program over USB, remove the remote from the base and its cover. Take the knob off first by loosening its grub screw. The control board, the XIAO and the button plate come out with the cover, still joined to the housing by the cables, and the XIAO's USB-C is free. In V0.26 the XIAO's USB-C and the charging port are separate supplies; the control board's regulator blocks current from the XIAO's own regulator. Each opening disturbs the gasket, so BLE firmware updates (working on the bench) remain the normal path.

## Assembly video

[`complete-remote-v0.33-assembly.mp4`](videos/complete-remote-v0.33-assembly.mp4) shows the remote steps 1–11 above, one chapter per step (56 s; QuickTime and VLC list the chapters). It is for design review, not a builder's guide. Parts that collide on their path show in red. Cables are not animated: each appears in place once both its ends are fitted. The video shows the documented order of steps 8 and 9.

[`assembly-video-v0.33-checks.md`](assembly-video-v0.33-checks.md) is the path check behind it. In V0.33 it finds no collision, as in [V0.31](assembly-video-v0.31-checks.md). Each move is checked at five poses against the parts in place, and every pair of parts in the final pose. Both orders of steps 8 and 9 are checked. Findings:

- The housing closes onto the stack along X (since V0.27; in [V0.26](assembly-video-v0.26-checks.md) it hit the joystick board).
- The vent label, on the battery cap since V0.28, clears everything ([V0.27](assembly-video-v0.27-checks.md): it ran into the lower-facet stack).
- The USB-C board reaches its rib by a path above the upper bosses (assembly step 2).

The [V0.26](videos/complete-remote-v0.26-assembly.mp4), [V0.27](videos/complete-remote-v0.27-assembly.mp4) and [V0.28](videos/complete-remote-v0.28-assembly.mp4) videos stay as the record of their collisions.

Regenerate, from the repository root (OpenSCAD 2026.x, Python 3, ffmpeg; about 4 min on an 11-core Mac):

```sh
python3 mechanical/cad/tools/assembly_video.py check    # report and build/collisions.json
python3 mechanical/cad/tools/assembly_video.py frames   # or --step N for one step
python3 mechanical/cad/tools/assembly_video.py video
python3 -m unittest mechanical/cad/tools/test_assembly_video.py
```

V0.32 changed no remote part and has no video of its own.

The timeline, the staging offsets and the cameras are in `mechanical/cad/assembly-video-v0.33.scad`. The tool uses the newest version; `ORR_VERSION=0.26` to `0.31` selects an older file, but its captions need that version's assembly list, which is now in the git history. The step captions come from the assembly steps above, so rerun `video` after editing them.

## Photo renders

The two V0.33 photo renders come from Blender (Cycles), not from OpenSCAD. `mechanical/cad/tools/photo_render.py` exports the parts to STL with OpenSCAD and runs Blender on them, with the remote in dyed black nylon, the base in grey nylon, a TPU keypad, stainless screws and an aluminium bar. The materials are a guess at the look; the print material is not chosen. No grip is drawn, because the side of the grip is not modelled. From the repository root (Blender 5.x; a few minutes on an 11-core Mac):

```sh
python3 mechanical/cad/tools/photo_render.py
```

The images go to `mechanical/cad/build/photo/`; copy them to `docs/images/` by hand.

## Hardware

All parts for the remote and the base, with sources, are in the [bill of materials](bom.md).

The KSC2 J-bend terminals sit under the switch body. The LCSC land pattern used on the PCB extends 0.95 mm beyond the body, so a fine iron tip or hot air can reach the joints; having the board assembled is the easier option. The gull-wing version (`G`) has a different land pattern and does not fit this PCB.

## NAVCOMM reference

The [NAVCOMM product page](https://hesaparts.com/product/navcomm/) is the project's stated reference. Its [official user manual](https://hesaparts.com/wp-content/uploads/2025/02/EN/NAVCOMM%20USER%20MANUAL.pdf) specifies a 22 mm handlebar, at least 23 mm of space between the grip and the motorcycle's switchgear, rotation of the unit to suit the rider's reach, and fixing with two M4 screws and a flange. The control arrangement is one function button, two function/zoom buttons, and a lower four-way joystick.

V0.8 follows those functional and packaging cues while keeping original geometry. The CAD used 23 mm as the target width along the bar until V0.32, matching the manual's minimum installation gap; V0.33 uses 25 mm, because NAVCOMM is a reference, not a requirement; the manual does not publish the NAVCOMM's own overall width. Two parallel M4 bolts on either side of the bar close the rear clamp cap; ten M2 screws hold the control cover. The side panel keeps button presses perpendicular to the bar and can rotate around the bar before tightening.

## Sourced dimensions and design targets

| Feature | CAD value | Basis |
|---|---:|---|
| XIAO nRF52840 board outline | 21 × 17.8 mm | Seeed Studio published dimensions |
| APEM ISR3SAD200 panel cut-out | Ø13.6 mm with an anti-rotation flat 12.9 mm across | APEM IS series datasheet (16/08/2024); the flat is at the cover's print top, where it bridges |
| APEM ISR3SAD200 head and nut | Ø12 mm actuator, Ø17.5 mm bezel, 5.0 mm above the panel; M12 × 0.75 bushing, 13 mm behind the panel; 14 mm A/F hex nut | APEM IS series datasheet; the reduced Ø15 mm bezel (option 234) was not found at distributors |
| KSC2 switch | KSC221JLFS: 6.2 (+0.3) × 6.2 (+0.3) mm body, 3.5 mm to the actuator top, Ø2.9 mm actuator; 2 ± 0.5 N, 0.35 +0.3/−0.1 mm travel, 500,000 operations | C&K KSC datasheet (B-52, 1 Mar 2017); modelled at 6.5 mm |
| Handlebar | Ø22.2 mm (7/8 in) or Ø25.4 mm (1 in) | One base for both (V0.28); a 22.2 mm bar takes the printed sleeve. Measure the actual section |
| Base clamp | Ø46 mm outer diameter, Ø27.4 mm bore for every bar (V0.28; before, Ø24.2 mm for a 22.2 mm bar), flat platform at X = −17.2 mm from Y = −41 to +33.5 mm | Diametral split into two halves with a 0.8 mm clamping gap; not strength-validated |
| Remote rear face | Flat at X = −17.4 mm | 0.2 mm clear of the platform |
| Dovetail | Rails 10 mm wide at the platform, 15 mm at the top, 2.5 mm high, 45° flanks; two 8 mm segments with a 9 mm gap; 7 mm lips; 0.2 mm clearance; 9 mm slide | Prints without supports on both parts; clearance to tune on the first print |
| Lock | M3 × 20 ISO 4762 (V0.32) head (Ø5.5 × 3 mm) 2 mm proud, in a Ø6 mm pocket at Y = −32 mm; Ø5.8 mm hole in the remote; 0.5 × 5 × 10 mm spring; Ø16 × 8 mm quarter-turn knob on a Ø9 × 3.5 mm boss, two Ø1.5 × 4 mm pins | ISO 4762 head size; spring force estimated |
| USB-C receptacle | GCT USB4736-GF-A; shell axis at Y = 29.5 mm in the rear face, long side along the bar; 1.80 mm panel, 9.14 × 3.36 mm slot, 11.00 × 5.90 × 0.60 mm gasket pocket; USBTJ-06 gasket 10.64 × 4.86 × 0.90 mm; body 9.99 wide, 4.61 mm above its PCB, 8.60 mm long | GCT drawing USB4736 rev. A (9 April 2025) |
| LiPo pouch | 6.1 × 19.7 × 46.8 mm with 0.5 mm clearance, X = −29.1 to −22, Y = −33.5 to 14.3 mm (V0.31) | Measured on a 602045 cell, 600 mAh on its label (2026-10-15): the protection board end is 5.6 mm long and 4.1 mm thick; the 43.5 mm lead leaves one corner of that end. Cells up to 6 × 20 × 54 mm fit |
| Battery cap | Pod below Y = −37.7 mm from X = −35 mm back, 3.0 mm thick (V0.33); opening X = −31 to −21.2 mm, 21 mm wide; three M2 × 8 countersunk screws, 4.0 mm of thread; 1.0 mm foam gasket (V0.31) | Assembly study (V0.25); 2.8 mm below the lock hole |
| Pod front corners | 3 mm radius | Leaves a flat cover face for the M2 screws |
| Folded front | Upper facet normal to the pod axis; lower facet turned 20° toward the bar, fold 12.5 mm below the bar axis | Clears the thumb's path to the turn-signal switch; the angle is a parameter |
| Pod cavity corners | 2 mm front, 6 mm rear | Inset from the outer corners by the wall, 2 mm since V0.33 |
| Clamp liner | 1 mm radial TPU liner, or a bike inner tube (V0.32) | Parametric target; set `liner_radial` to the measured tube, or tune to the bar and the print process |
| Remote envelope | 40.1 × 88.2 mm in the plane of the clamp (X = −57.5 to −17.4 mm); 25 mm along the bar at the rear, 26 mm at the control end (V0.33) | 23 mm until V0.32, from the NAVCOMM manual's installation clearance, which is a reference only |
| Button direction | Button axes perpendicular to the handlebar axis | Layout requirement |
| Case wall / cover | 2.0 mm everywhere (V0.33; 1.0 mm in the narrow part and at the ends before) / 2.5 mm cover | Cover within the APEM IS panel range |
| Control layout | Buttons at Y = 33, 15, −3 mm (18 mm pitch) on the upper facet; joystick axis 14.5 mm below the fold on the lower facet, 24 mm from button C measured over the surface | APEM recommends 20 mm between IS buttons; 18 mm leaves 0.5 mm between bezels and 1.8 mm between nut corners, so the nuts need an open-end wrench. To judge on the first print |
| Clamp fasteners | Two parallel M4 × 16 ISO 4762 bolts at ±18.5 mm from the bar axis; Ø7.6 mm counterbores 8 mm from the split face; Ø3.4 × 8.1 mm pilots, the bolts cutting their own thread (V0.29) | 7.6 mm grip, 7.6 mm engagement, 2.65 mm wall to the 25.4 mm bore; confirm against the bought bolts and inserts |
| Cover fasteners | Six M2 × 8 (upper facet) and four M2 × 10 (lower facet, through the joystick plate) ISO 10642 countersunk screws; Ø1.6 × 6 mm pilots in Ø6 mm bosses, the screws cutting their own thread (V0.29) | Spaced 16.5–21.8 mm along the perimeter to compress the gasket; confirm against the bought inserts |
| Cover gasket | 0.6 mm compressed (0.8 mm printed or cut) | Upper facet: 1 mm on the walls, 3.8 mm with the lip (4 mm before V0.24; the APEM nuts need the room), Ø6 mm around each screw. Lower facet: full sheet on the joystick plate, Ø2.4 mm hole stretched over the stick |
| Pod width | 25 mm along the bar at the base and the rear of the pod (V0.33); 26 mm for X < −38 mm | 25 mm for 2 mm walls round the 21 mm cavity; the NAVCOMM manual's 23 mm is a reference, and the switchgear can move. The control end is 40–60 mm from the bar axis |
| Joystick | Ø16 mm knob 5.7 mm proud, hub 0.9 mm and rim 1.15 mm above the cover; Ø3 × 12 mm steel pin; Ø6 mm ball on a Ø3.6 mm seat edge, pivot 7.0 mm behind the face; 1.2 mm cross disc 0.05 mm above four KSC2 at 6.75 mm | Trips at ≤ 5.9° tilt; knob stop at 8.2° or 0.9 mm push; disc room 9.5° |
| Joystick plate | 1.5 mm, behind the sheet; Ø3.6 mm seat hole opening to Ø4.8 mm at the front; Ø10 × 0.6 mm sheet pocket; two Ø3.6 mm standoffs, 6.25 mm tall, at (∓6.0, ±6.4) mm from the stick axis | Printed; clamped by the four lower cover screws |
| Joystick PCB | 20.6 × 22.4 mm with four R3.3 mm boss notches; front face 10.85 mm behind the outer face, 1.6 mm thick; rear zone 1.0 mm, 3.0 mm in the upper half and the side strips | KiCad design in electronics/joystick-pcb; switch land pattern from LCSC C221728, the same C&K J-bend layout as the KSC221J (C221726) |
| Vent | Ø3 mm hole through the battery cap at X = −26.1 mm, Ø7.6 mm label on its inner face (V0.28) | For an adhesive ePTFE vent such as Takachi VE8; verify the hole size against the chosen vent |
| XIAO PCB / rear joint zone | 1.2 / 1.0 mm | No headers in V0.25; measure the bought board and the joints |

Seeed lists the XIAO board at 21 × 17.8 mm and provides a [2D DXF drawing](https://wiki.seeedstudio.com/XIAO_BLE/). The purchased variant has pre-soldered headers; V0.22 keeps the board parallel to the control cover, behind the control bodies, with the header pins pointing away from the controls. The 2.5 mm spacer and 6 mm pin length are allowances, not supplier dimensions. The [Kiwi listing](https://www.kiwi-electronics.com/en/seeed-studio-xiao-nrf52840-pre-soldered-20402) confirms the headers are pre-soldered. Check the actual header, USB-C, antenna, and component clearances against the printed cavity before finalizing it.

The C&K KSC series datasheet ([copy at LCSC](https://wmsc.lcsc.com/wmsc/upload/file/pdf/v2/lcsc/1809211731_C-K-KSC221JLFS_C221726.pdf), pages B-49 to B-52) gives the 6.2 × 6.2 mm body with +0.3 mm tolerance, the 3.5 mm soft-actuator height, a Ø2.9 mm actuator, the IP67 rating, and per type the force, life and travel: KSC201 1.6 N, 5,000,000 operations, 0.3 ± 0.2 mm; KSC221 2 N, 500,000, 0.35 +0.3/−0.1 mm; KSC222 2 N, 1,000,000, 0.35 ± 0.15 mm; KSC241 and KSC251 3.5 and 5.5 N, 300,000, 0.5 ± 0.2 mm. The knob stop at 0.9 mm of push covers every type up to 0.85 mm of maximum travel, so all of these. V0.20's Ruffy MHS joystick was listed at about £149 for one unit at Farnell UK, and the APEM NV 5-way (NVH1D1C1CP2S) at $143.34 at Mouser.

APEM's [IS series page](https://www.apem.com/panel-switches/pushbutton-switches/is) gives the Ø13.6 mm panel cutout, 13 mm behind-panel depth, 1.5–4 mm panel range, and 15 mm reduced-bezel option. Order-code availability and the reduced-bezel variant's exact drawing must be confirmed before selecting the production switch.

## Open unknowns before printing

These are the only items that block a confident first print. Each is a parameter in the CAD.

- **Keypad:** the press and travel of a KSC2 behind a TPU sheet, with gloves (0.3 mm rest gap plus 0.35–0.65 mm travel, against 1.7 mm for the APEM buttons); whether the printed sheet seals round the keys and at the fold; whether the 0.3 mm rest gap needs shims.
- **Upper cover screws:** the span between the screws at Y = 24 and −6 mm is 30 mm. With the V0.30 foam strip the cover bends an estimated 0.015–0.07 mm there, against 0.5 mm of foam travel; the leak test confirms it.
- **Foam strip (V0.30):** its real compression force and recovery after the cover is opened, the two butt joints at the end corners, and whether the adhesive holds on the printed surface (rough on MJF nylon).
- **Joystick:** measure the KSC2 height and the printed plate, ball and disc; together with the standoffs they set the 0.05 mm rest gap (`joy_rest_gap`). The feel (5.9° to trip, 2 N per direction, about 8 N for the centre chord) and the Ø16 mm knob need a check with gloves.
- **XIAO:** measured on a pre-soldered XIAO nRF52840 (2026-10-15): PCB 1.2 mm, components 3.0 mm, pin spacer 2.5 mm, pins 6.1 mm below it, USB-C 1.8 mm past the PCB edge, pin rows centred on the board. The depth of the 5.7 mm female socket (C55218877) is not published, so the model assumes the worst case: the 6.1 mm pin bottoms and the XIAO sits 0.4 mm above its spacer. Its components then end where they did with the 3.4 mm assumption, 7.2 mm from the pouch envelope; the stack, removal and path checks give the same results. Still open: the real seat height, and whether the foam pad holds the XIAO in its headers under vibration. If the XIAO's pins do not hold in the 5.7 mm socket, the 8.5 mm alternative (C54876729) also clears in the CAD (`header_h` = 8.5, checked 2026-10-20): the XIAO sits 2.4 mm higher, 4.5 mm from the pouch envelope instead of 6.9 mm, and its foam pad takes 4 layers instead of 6. The assembly path checks were not run again for it.
- **Cables:** where the spare length of 10 cm cables goes (the routes need about 3 and 4 cm); whether bought cables are straight (pin 1 to pin 1); whether the SH-compatible sockets latch the Pololu plugs.
- **Pouch lead:** it must leave the protection-board end and reach about 29 mm to J5 (V0.31, with the measured 46.8 mm cell). The measured cell's 43.5 mm lead leaves a corner; fitted with that corner on J5's side (low Z), about 15 mm of lead is spare and has to be tucked above the cell.
- **Screw pilots (V0.29):** Ø1.6 mm for the M2 screws and Ø3.4 mm for the M4 clamp bolts are first estimates for PETG; the chosen material may need other sizes. Check on the first print that the screws cut a thread that holds, and how many openings it survives.
- **Leak test:** test the first assembled remote for water tightness before fitting the electronics, for example under water at a few centimetres for 30 minutes with a dry paper towel inside. It checks the keypad gasket, the cap gasket, the USB-C receptacle and the vent together.
- **Handlebar, sleeve and liner:** the bar diameter measured with a caliper at the clamp, in two directions, which sets the sleeve bore; the 0.8 mm clamping gap tuned to the printed TPU liner; and whether the clamp holds a hard gloved press without turning (estimate 3.3 N·m against 0.7 N·m).
- **Dovetail:** the 0.2 mm clearance (`dt_c`) against the printer, and the inner tube's thickness for the strips (V0.32; measure it and set `strip_t`), and whether the clear epoxy holds the butyl rubber in the printed pockets (rubber glues poorly; roughen it first). Whether the 0.48 mm the remote can move toward the platform feels loose on the buttons.
- **Lock:** whether the epoxy on the M3 thread (V0.32) holds the setting with the knob turned at each fitting; the pull force, and whether 1 mm of head in the pocket is enough. The 0.5 × 5 × 10 mm spring in the [BOM](bom.md) fits: its 5 mm outside diameter in the Ø6 mm pocket and its 4 mm inside diameter over the Ø3 mm shank. Still open: its solid length, which must be under the 4.0 mm of `lock_spring_solid` (at most about 7 coils of 0.5 mm wire), or the head cannot go fully in and the lock cannot release; count the coils of the bought spring.
- **Pouch:** the measured 602045 cell fits (6.1 × 19.7 × 46.8 mm, see "Sourced dimensions"). Still open: its real capacity, its maximum charge current against the control board's 100 mA (R1 on the MCP73831), and the polarity. Its plug, looked at from the mating end with the latch up, has red on the right; SparkFun documents that convention as pin 1 = +, which matches J5 (pin 1 BAT, pin 2 GND), but this is not checked against JST's drawing. Check with a meter before plugging it in; Q1 protects the board if it is reversed.
- **Battery cap:** whether the foam gasket (V0.31) seals on the 2.5 mm side lands and recovers after battery changes, whether M2 screws hold with 4.0 mm of thread in Ø1.6 mm pilots after a few battery changes (V0.33), and whether the 26 mm bottom band clears the switchgear on the bike.
- **USB-C PCB:** the hand-drawn USB4736 footprint now matches GCT's recommended layout ([check](../electronics/usbc-pcb-rev-b/README.md#receptacle-footprint); the signal pads moved 0.10 mm). The receptacle is soldered by hand in every ordering option (JLCPCB could not source it), so JLCPCB's footprint for the part does not matter. Check the Ø1.6 mm screw pilots against the chosen screws; in V0.26 the holes are at ±7 mm. How the board gets onto its rib was not solved in V0.24 and V0.25. For V0.26 the assembly path check found a clear path: carried 1.5 mm above the rib past the upper cover bosses at Y = 24, lowered onto the rib 8 mm short of the rear wall, then slid in. The margin is small (1 mm above the rib still overlaps 0.2 mm³), so check it on the first print ([assembly path check](assembly-video-v0.28-checks.md)).
- **USB-C gasket squeeze:** the USBTJ-06 gasket is squeezed between the pocket floor and the receptacle body's front face (GCT drawing, sheet 2), and the two M2 screws fix that distance. GCT asks for 0.315–0.405 mm (35–45 % of 0.90 mm), a 0.09 mm window. Against it stand about ±0.3 mm of print tolerance (see the [materials study](materials-study.md#tolerances)) and the receptacle's own tolerances (3.10 ± 0.15 mm from the nose to the shell tabs, ±0.25 mm general). Fixed pilots cannot guarantee the window. Rigid shims under the gasket do not help: each adds a rigid-to-rigid joint that does not seal. Options: silicone sheet rings as compliant shims, a board that slides on the rib and is clamped with nuts, or a neutral-cure silicone (RTV) bead outside the gasket with a leak test. Not decided: measure the soldered board first (body face to the centre of the M2 holes, with a Ø2 mm pin in each hole; design 11.10 mm).
- **USB-C PCB edge (V0.33):** the edge sits 0.43 mm behind the panel's inside face. On the first JLCPCB boards the same receptacle stood 1.5–1.9 mm past the edge (design 1.70), so the milled outline varies by about ±0.2 mm. In the CAD the board touches the wall once it is 0.43–0.45 mm forward of its design position. A recess in front of the edge would take the board tolerance and the print tolerance; it waits for the gasket decision.
- **Foam thickness (V0.33):** the foam seals assume a 1.5 mm sheet compressed to 1.0 mm (`foam_comp`, 33 %). The sheet listed in the [BOM](bom.md#hardware) measures about 1.15 mm, which leaves 0.15 mm of squeeze (13 %), less than the print tolerance. Planned for V0.34, together with the USB-C gasket change: two layers of the sheet (about 2.3 mm) compressed to `foam_comp` about 1.5 mm (35 %). With ±0.3 mm on the printed parts (see the [materials study](materials-study.md#tolerances)), two layers stay at 22–48 % compression; one layer at 0.77 mm would range from 7 to 59 %. To check in the V0.34 CAD: a strip 2 mm wide and 2.3 mm high may roll over when squeezed, so widen `foam_w` to about 3 mm if the rim allows it; the battery cap lip rises to match. The second layer's adhesive must bond all along the first, or water passes between the layers. How firm the foam is was not measured; check the cover and the battery cap in the submersion test.
- **USB-C board thickness:** the 1.2 mm board keeps the USB-C board out of the EU board services checked on 2026-10-22: Eurocircuits makes 1.2 mm only outside its pooled service (about €543 net for one board), and Aisler lists 2-layer boards at 1.6 mm only. GCT's drawing gives 1.20 ± 0.10 mm as the *recommended* thickness; it matches the 1.20 ± 0.15 mm the shell tabs reach below the body, and the receptacle is a top-mount SMT part. On a 1.6 mm board the tabs end 0.25–0.55 mm inside their plated slots, so they still solder but hold less against the 5–20 N mating force. Plan for the next USB-C board revision: a 1.6 mm board, with the rib lowered 0.4 mm so the nose stays at the same height. Not confirmed with GCT. Other sealed receptacles checked (GCT USB4715 mid-mount, GCT USB4750 vertical, threaded panel-mount USB-C) need a larger redesign or do not fit the 25 mm width. This does not change the gasket squeeze problem above.
- **Joystick board support (V0.27):** both PCB screws are now in the lower half. A hand estimate gives 0.011 mm of bending under the up switch at 2 N, against the 0.05 mm rest gap; check on the first print that the up direction trips like the others and that the board does not rock.
- **Charge LED:** whether the LED shows well enough through the filled Ø1.6 mm window (`usbc_led_hole_d`), and whether the printed hole needs drilling out to size.
- **Vent:** the label is sized for a Ø7.6 mm Takachi VE8 class vent, in the battery cap, over a Ø3 mm hole. A Ø8 mm label with a Ø4 mm breathable area, sold in packs of 100 (see the [BOM](bom.md#hardware)), also clears the cap gasket and the housing (CAD check, 2026-10-20), with 0.9 mm to the opening's edges. Still open: whether it seals; its IP67 rating is the seller's claim. The leak test checks it.
- **Keypad sheet:** the key feel with a loose sheet, how long a printed TPU sheet lasts flexing with the stick, and whether it seals round the screw threads.
- **Print material:** not chosen. The [materials study](materials-study.md) compares PA11 by MJF and ASA by FDM for the remote, PA12 by MJF for the base and TPU near 85A for the keypad, with quotes from EU print services.
- **Width (V0.33):** the remote and the base are 25 mm along the bar. Check on each bike that the switchgear can move to leave 25 mm, or more with the handguard.
- **Fold angle:** 20° is chosen to clear the turn-signal switch. The gland that kept it from 30° is gone in V0.24, but 30° has not been rechecked, and neither angle has been checked on a bike.

Not addressed by this concept: IP rating, impact, vibration, and fatigue strength. The materials study weighs impact on paper only. These need physical testing, including a drop test.

## Earlier versions

V0.1–V0.32 remain available for comparison. V0.32 and earlier have 1 mm walls in the narrow part and at the ends. V0.30's battery cap gasket cannot be squeezed enough by its screws. V0.29's keypad sheet cannot be squeezed enough by its screws to seal. V0.28 needs heat-set inserts, and its battery cap boss touches the joystick board's J1. V0.27's vent label runs into the cover and the joystick plate; build V0.28. V0.26 should not be built: its housing cannot close onto the joystick board (see [V0.27 changes from V0.26](#v027-changes-from-v026-still-current)). V0.23 is the fixed, cable-powered version: its clamp ring and shoulders are part of the housing. V0.22's PCB standoffs would overlap the pads of the real KSC2 land pattern; build V0.23 or later. V0.24 places a 602030 pouch that cannot be put in through the front opening (see [Changes from V0.24](#changes-from-v024)); build V0.25. V0.21 should not be built: its Ø7 mm keys are too small for gloves and hard to press on the folded facet. V0.20 uses the Ruffy MHS panel joystick, which costs about £149 and fills the 23 mm pod width. V0.19 has a straight control face that gets in the way of the turn-signal switch, and no gasket. V0.18 is installable, but its cover does not match the housing and it has no cover, board, or gland mounting. V0.17 should not be printed: its 250-degree body cannot pass the handlebar. V0.13–V0.16 are superseded attempts at the shoulder silhouette and should not be printed. V0.13 left gaps at the shoulders. V0.14 dropped most of the pod through an incorrectly closed polygon. In V0.15 and V0.16 the same polygon traced the clamp arc as an inner boundary, so the fixed 250-degree ring was missing and only the removable cap surrounded the bar.
