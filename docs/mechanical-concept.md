# Complete Mechanical CAD — V0.25 Removable Remote

V0.25 drops the XIAO's pin headers and fits a 6 × 20 × 50 mm pouch (602050, 600 mAh in the listing) instead of the 602030. The pouch now slides in from below, through a separate battery cap in the bottom end: an assembly study showed that no 20 mm wide pouch, the V0.24 one included, can pass the front opening. The changes are listed under [Changes from V0.24](#changes-from-v024).

V0.24 makes the remote removable and battery powered, following the [battery study](battery-study.md) and issue #1. A base stays clamped on each bike; the remote slides onto it on an interrupted dovetail and is held by a spring-loaded lock. A fixed LiPo pouch powers it, and it is charged off the bike through a sealed USB-C receptacle on its back, with a charge LED beside it. Everything in front of the remote's rear face is the V0.23 pod, unchanged. The changes are listed under [Changes from V0.23](#v024-changes-from-v023-still-current).

V0.23 fitted the V0.22 joystick to a real PCB, designed in KiCad: the [joystick PCB](../electronics/joystick-pcb/README.md) carries the four switches and the 5 V input protection. V0.22 put a joystick back on the lower facet, built from low-cost parts, and widened the control end of the pod from 23 to 26 mm. The base and the rear of the pod stay 23 mm wide along the bar.

The joystick is a steel pin with a printed ball. The ball pivots against a seat in a printed joystick plate. Under the ball, a cross-shaped disc rests on four C&K KSC2 sealed tact switches, whose springs centre the stick. Tilting the stick presses one switch; pushing it straight in presses all four, which the firmware reads as the centre press. The parts cost a few euros. The Ruffy MHS of V0.20 was listed at about £149, and the APEM NV, the closest commercial alternative found, at $143.

The remote's printed parts are slices of one outer solid: the pod outline cut flat at the rear face, 23 mm wide along the bar, plus the 26 mm control end. Offsets of the folded front cut the cover and gasket from it. The base is two separate halves split through the bar axis. Supplier and purchase unknowns remain open and are listed at the end; they are marked `MEASURE` in the CAD.

The remote mounts on the left side of the bar only, never the right. The turn-signal switch that the folded front clears is on the left switchgear.

**Current parametric concept:** [complete-remote-v0.25.scad](../mechanical/cad/complete-remote-v0.25.scad)

![V0.25 battery cap, exploded from below: the housing with its bottom opening and the cap gasket land, the pouch envelope (red), the cap gasket and the cap with its three countersunk screw holes. The vent hole is in front of the opening.](images/complete-remote-v0.25-battery-cap.png)

![V0.25 section through the middle of the pod and the base: the 50 mm pouch behind the XIAO, and the cap at the rear of the bottom end with the front screw boss.](images/complete-remote-v0.25-section.png)

![V0.25 interior with the upper axial wall removed: the pouch envelope (red) behind the XIAO, from the cap up to Y = 17.5 mm.](images/complete-remote-v0.25-interior.png)

![V0.25 remote seen from the bar side. The bottom band (left) is 26 mm wide for the cap gasket.](images/complete-remote-v0.25-back.png)

The renders below are of V0.24; apart from the bottom end, the remote and the base are unchanged.

![V0.24 on its base, from the control side.](images/complete-remote-v0.24-iso.png)

![V0.24 on its base, from behind the bar: the base platform under the remote's rear face, and the lock knob below the clamp ring.](images/complete-remote-v0.24-rear.png)

![V0.24 entry position: the remote held off the platform, 9 mm below its working position, with the lock knob pulled. The groove's wide openings line up with the two rail segments.](images/complete-remote-v0.24-entry.png)

![V0.24 fitting and removal, animated. Left: pull the knob, press the remote onto the platform 9 mm low, slide it up to the stop, release the knob; then pull the knob, slide down and lift off. Right: the same, cut at mid-width and seen along the bar, with the rails in the groove and the lock head (orange) in its hole.](images/complete-remote-v0.24-fit.gif)

![V0.24 base on the bar: the clamp ring, the platform with two dovetail rail segments, the two black TPU anti-rattle strips, and the lock screw head below the rails.](images/complete-remote-v0.24-base.png)

![V0.24 remote seen from the bar side: the rear face with the lock hole (left), the interrupted dovetail groove (centre) and the USB-C opening (right).](images/complete-remote-v0.24-back.png)

![V0.24 dovetail section through the lower rail: the 45-degree rail on the base (right) inside the groove in the remote's rear wall (left), and the TPU strips either side, drawn at their uncompressed thickness.](images/complete-remote-v0.24-dovetail.png)

![V0.24 section through the middle of the pod and the base.](images/complete-remote-v0.24-section.png)

![V0.24 interior with the upper axial wall removed: the LiPo pouch envelope (red) in the lower rear of the cavity, below the XIAO; the USB-C receptacle on its charging PCB (green), resting on its rib at the top of the rear wall.](images/complete-remote-v0.24-interior.png)

The control end is unchanged from V0.23. These V0.23 renders still show it:

![V0.23 joystick knob on the lower facet, between the four lower cover screws. The engraved cross shows the four directions.](images/complete-remote-v0.23-joy.png)

![V0.23 seen along the bar: the upper facet with buttons A, B, C and the lower facet with the joystick, turned 20 degrees toward the bar.](images/complete-remote-v0.23-side.png)

![V0.23 control cover seen from the rider's side.](images/complete-remote-v0.23-front.png)

![V0.23 section through the joystick axis, drawn with the cover at the bottom: knob, cover, sheet gasket gripping the stick, joystick plate with the ball seat, ball and cross disc, switches, PCB on its standoffs, and the rear component zone behind it.](images/complete-remote-v0.23-joy-section.png)

![V0.23 cover in its print orientation, on its axial face.](images/complete-remote-v0.23-print-cover.png)

![V0.23 joystick parts in their print orientations: the plate on its sheet side with the two PCB standoffs up, the ball and disc on the disc, the knob on its top face, and the Ø3 × 12 mm steel pin (bought).](images/complete-remote-v0.23-print-joy.png)

![V0.23 gasket unfolded flat: wall land on the upper facet, a full sheet with the stick hole on the lower facet.](images/complete-remote-v0.23-gasket-flat.png)

All images are direct OpenSCAD renders of the V0.25, V0.24 or V0.23 file. The PCB images are on the [joystick PCB page](../electronics/joystick-pcb/README.md).

## Changes from V0.24

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
- **Vent.** It moves to X = −41 mm, in front of the cap; its Ø10 mm label area is clear of the block and the bosses.
- **Battery wires.** The `BAT` pads face the pouch once the XIAO is in. Solder two wires to them before sliding the XIAO in, run them down past the pouch to the opening, and splice them to the pouch leads there. The protection board end of the pouch goes down; the leads and the splice sit in the 5 mm between the cell and the cap.
- **Holding the pouch.** It slides, so it cannot go in on adhesive tape. A foam pad on the cap holds it up and a foam strip on the rear wall holds it against the XIAO side.
- **Battery change.** The cap comes off with the remote on the bench, without opening the cover.

## V0.24 changes from V0.23, still current

The pouch, vent and rear-bottom corner below were changed again in V0.25 (see above).

### Base and remote

- **Base.** The clamp ring stays on the bar: two halves split through the bar axis, two M4 × 16 bolts, M4 inserts in the front half, a 1 mm TPU liner. Its outside grows from Ø44 to Ø46 mm, and the bolts move from ±17 to ±18.5 mm, so the same layout suits a 25.4 mm bore. In front of the bar the base is cut flat at X = −17.2 mm (`platform_x`), 3.5 mm in front of the 25.4 mm bore with its liner. That flat platform runs from Y = −41 to +33.5 mm.
- **Bar sizes.** One base per bar size: `bar_diameter` = 22.2 (7/8 in) or 25.4 (1 in). The bore changes; nothing that meets the remote does. Tapered 28.6 mm bars come down to 22.2 mm at the controls.
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
- **Anti-rattle.** Two TPU strips, 4 × 50 mm, sit in 0.6 mm pockets on the platform either side of the rails and stand 0.8 mm proud. They push the remote off the platform until the dovetail flanks seat, with the rear face 0.48 mm off the platform, which leaves the strips about 0.3 mm compressed. A firm press moves the remote back onto the platform by up to 0.48 mm. Whether that feels loose on the buttons needs a test.

### Buttons

- **APEM ISR3SAD200.** Sealed IP67 pushbutton: round curved black actuator, normally open, solder lugs, gold-plated contacts, standard Ø17.5 mm bezel with a flat seal, M12 × 0.75 bushing and a 14 mm A/F hex nut. The datasheet gives 4 ± 3 N, 1.7 mm travel, 10 g vibration and 100 g shock.
- **Cut-out.** Ø13.6 mm with APEM's anti-rotation flat, 12.9 mm across, in place of the round cut-out with a 45° top.
- **Layout.** The bezels need a flat seat on the upper facet, so the buttons move up 1 mm to Y = 33, 15 and −3 mm, the pod top from 44 to 45.5 mm, and the upper-facet cover screws to 40.5, 24 and 6 mm. Each bezel stays 0.75 mm from the fold and from the top corner radius. The pitch stays 18 mm; APEM recommends 20 mm.
- **Nuts.** A hex nut can stop at any angle, so the CAD checks a Ø16.2 mm circle (its corners) behind each button: clear of the housing, the gasket, the joystick and each other once the gasket lip is 2.8 mm wide instead of 3 mm. There are 1.8 mm between nut corners at 18 mm pitch, so the nuts need an open-end wrench, not a socket.

### Lock

- An M3 × 22 ISO 4762 screw is the lock pin: its Ø5.5 × 3 mm head runs in a Ø6 mm pocket in the platform at Y = −32 mm, below the clamp ring and clear of the lower bolt.
- A 0.5 × 5 × 10 mm stainless compression spring (wire × outside diameter × free length) under the head pushes it 2 mm out of the platform, with about 3.4 N (estimated, not measured), into a Ø5.8 mm hole in the remote's rear face. A positive stop, not a detent: the remote cannot slide down until the head is pulled in.
- The shank runs back through the base to a Ø16 × 8 mm printed knob with an M3 insert, locked by a nut. The knob rests on the back of the platform block (X = −5 mm) and sets how far the head stands out.
- **Quarter turn.** The knob is a cup over a Ø9 × 3.5 mm boss on the back of the block. Two Ø1.5 × 4 mm steel dowel pins through the cup wall run in L-slots in the boss. Locked, the pins sit in the circumferential part of the slots and the knob cannot be pulled; turning it 90° brings them to the axial part, and then it pulls out 2 mm. The CAD checks the knob locked, turned 45° and 90°, and pulled, with no overlap, and that it cannot be pulled while locked or half-turned.
- **Vibration.** Vibration alone should not pull the head in: the moving parts weigh about 2.5 g, so the 3.4 N spring needs about 140 g along the pin axis to be overcome (an estimate). The quarter turn is against a branch or a strap pulling the knob.
- Turning the knob 90° and pulling it 2 mm pulls the head flush. When the remote is pressed on at the entry position, its rear face pushes the head in; the head springs out when the hole comes over it.
- Only 1 mm of the head stays in its pocket when locked. The shank, guided over 5 mm in the base, takes the moment.

### Battery, charging and vent

- **LiPo pouch.** Replaced in V0.25. A fixed pouch in the lower rear of the cavity, below the XIAO and behind the USB-C plug zone: envelope X = −29 to −22, Y = −33.5 to −2.5 mm, 21 mm along the bar. It takes a 6 × 20 × 30 mm pouch (602030, about 300 mAh in listings, not verified) with 0.5 mm all round. That space was free in V0.23 apart from the cable route; the earlier fit search had excluded everything below the fold. The pouch is held with foam tape and wired to the XIAO `BAT` pads.
- **USB-C charging.** A GCT USB4736-GF-A charge-only (6-contact) USB-C receptacle in the rear face, IP67 with its USBTJ-06 silicone gasket (both in the kit USB4736-GF-A-KIT), centred at Y = 29.5 mm with its long side along the bar. It sits above the groove, so the platform (to Y = +33.5 mm) covers it on the bike; any USB-C cable charges the remote off the bike, and no charging dock is needed. The receptacle is on a small breakout PCB with the two 5.1 kΩ CC pull-downs, without which a USB-C charger supplies no 5 V. VBUS and GND go to the joystick PCB 5 V input, through its PTC fuse and TVS diode. This port only charges: the XIAO's own USB-C stays for programming. The CAD follows GCT's drawing (USB4736, revision A, 9 April 2025, via SnapEDA): the wall is thinned from inside to GCT's 1.80 mm panel, with a 9.14 × 3.36 mm slot (R1.43) and an 11.00 × 5.90 mm gasket pocket (R1.60) 0.60 mm deep. The 0.90 mm USBTJ-06 gasket is squeezed to about 0.53 mm (41 %; GCT asks for 35–45 %). The receptacle's 1.20 mm nose sits in the slot, 0.53 mm back from the rear face. It is soldered to the [USB-C charging PCB](../electronics/usbc-pcb/README.md), a 19 × 13.6 × 1.2 mm board that lies flat on a rib spanning the cavity and is held by two M2 × 4 thread-forming screws; the screws fix where the receptacle squeezes its gasket. It is the only part found that is sealed and keeps the CC lines; the waterproof USB-C parts sold on Amazon either lack CC pins (so USB-C chargers give no power) or are too large for the 23 mm rear face. It is sold by DigiKey, Mouser, Farnell and TME, not on Amazon. Earlier in this branch the charge path was two brass contacts and a charging dock; USB-C replaced them because it needs no dock, is keyed, and is a standard.
- **Charge LED.** A red side-looking LED (Lite-On LTST-S270KRKT) on the same PCB, at its front edge 7.5 mm to the +Z side of the receptacle axis, shines through a Ø1.6 mm hole in the panel (`usbc_led_*`). The hole is on the emitter axis, 0.30 mm above the board, 1.2 mm beside the gasket pocket and 0.5 mm beside a 12.4 mm plug overmold, so it stays visible with the cable in. It is filled with clear epoxy or UV resin, flush outside. The firmware lights it while the cell charges and turns it off when charging ends; see the [battery study](battery-study.md#firmware). On the bike the platform covers it. The board grew from 14 to 19 mm wide to carry it, and leaves 1.0 mm to each axial wall. There is no power switch: the remote sleeps (System OFF) after 6 h without input or when A, B and C are held for 3 s, and any button wakes it.
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
- **Firmware.** The specification now describes the four-switch chord as the centre press; D7 is unused. The diagnostic sketch implements the chord; a separate centre switch on D7 remains as a build option for the breadboard.

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
  - The ball and disc are one printed part. The knob slides onto the pin from outside after assembly, and an M2 × 4 grub screw in a radial M2 heat-set insert clamps it. It comes off with a hex key; nothing is glued.
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
- **Lower cover screws.** M2 × 10 through the plate, 5.4 mm into the inserts; their bosses start behind the plate. The six upper-facet screws stay M2 × 8.

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
3. **Cover joint.** The gasket and ten screws. On the lower facet the sheet is clamped over the whole facet. Elsewhere the land is the 2 mm wall of the wide part.
4. **USB-C.** The GCT USB4736 is rated IP67 with its USBTJ-06 gasket compressed on the thinned land; GCT says the gasket is fitted after the receptacle is soldered. Pot the back of the receptacle and its PCB with epoxy as a second barrier. The charge LED window beside it is a Ø1.6 mm hole filled flush with clear epoxy or UV resin. On the bike the platform covers both. The groove and the lock hole are blind and do not open into the cavity.
5. **Vent.** An adhesive ePTFE vent label over the Ø3 mm hole in the bottom end wall, inside. Without it, temperature cycles pump humid air into a sealed box, and the water condenses inside. Mount the base so the vent faces down or sideways, not into spray.
6. **Battery cap.** A flat gasket squeezed to 0.6 mm by three M2 screws, on 3.8 mm lands front and rear and 2.5 mm at the sides. A 3.8 mm strip of housing separates it from the cover gasket. The cap faces down and gets spray from the wheel; this joint is new and untested.
7. **Electronics.** Coat the XIAO, the joystick PCB and all solder joints with conformal coating (acrylic or silicone). Keep it off the USB-C socket, the switch actuators, the pouch, and the vent membrane.
8. **Printed walls.** The narrow rear part still has 1 mm axial walls, only two perimeters with a 0.4 mm nozzle, and FDM layers can leak. Print PETG hot and slow for good layer bonding, or seal the outside with a thin coat of epoxy or lacquer.

## Printing

| Part | Mode | Orientation | Material (suggested) |
|---|---|---|---|
| Housing | `print_housing` | Upper facet on the bed | PETG or ASA |
| Base front | `print_base_front` | Axial face on the bed | PETG or ASA |
| Base cap | `print_base_cap` | Axial face on the bed | PETG or ASA |
| Lock knob | `print_lock_knob` | Flat face on the bed | PETG |
| Control cover | `print_cover` | Axial face on the bed | PETG or ASA |
| Joystick plate | `print_joy_plate` | Sheet side on the bed | PETG |
| Ball and disc | `print_ball_disc` | Disc on the bed | PETG |
| Knob | `print_knob` | Top face on the bed | PETG or ASA |
| Gasket | `print_gasket` | Flat, 0.8 mm | Soft TPU (85A or softer), or cut from silicone/EPDM sheet |
| Battery cap | `print_battery_cap` | Outer face on the bed | PETG or ASA |
| Cap gasket | `print_cap_gasket` | Flat, 0.8 mm | As the cover gasket |
| Liners ×2 | `liner_main`, `liner_cap` | Axial face on the bed | TPU 95A |
| Anti-rattle strips ×2 | not modelled as print parts | 4 × 50 × 1.4 mm | TPU, or cut from rubber sheet |

No part needs supports.
- **Housing:** the walls are vertical, the lower facet is an open edge in the air, the lower screw bosses lean 20°, and the cavity's rear wall and the battery cap's front block bridge 21 mm. The XIAO rails have 45° chamfers. The groove is at the top: its lips narrow upward at 45°, and the lock hole and the USB-C slot open upward; the gasket land is a shallow recess in the bridged rear wall. It stands on its thin front rim, so use a brim.
- **Base front:** the rail flanks are at 45° to the bed. The lock pocket and the bolt holes run horizontally and are small enough to bridge.
- **Cover:** the Ø5 mm stick hole is small enough to bridge. It stands on a 2.5 mm edge, so use a brim.
- **Ball and disc:** the ball above the disc narrows upward. Test the press fit of the pin in the Ø2.95 mm bore (`pin_bore`) before assembly.
- **Knob:** the radial insert hole is horizontal and small enough to bridge.
- **Battery cap:** the countersinks open toward the bed at 45°.
- **Inserts:** use 100% infill or at least four perimeters around the M4 insert holes and the rails.
- **Gasket:** TPU 95A is probably too hard to seal at 0.2 mm compression; prefer a softer TPU or a cut sheet gasket. If you cut the sheet, punch the Ø2.4 mm stick hole.

## Assembly

Remote:
1. Press the ten M2 inserts into the housing screw bosses.
2. Mount the three buttons in the cover.
3. Solder the four KSC2 switches to the front of the joystick PCB, and the PTC fuse and TVS diode to the rear (or order the board assembled).
4. Push the stick through the joystick plate from the back, so the ball sits in its seat. Screw the PCB onto the plate standoffs with two M2 × 8 button-head screws (head at most Ø3.5 × 1.1 mm); the disc rests on the switches.
5. With the XIAO on the bench, solder its wires: the six joystick wires (U, D, L, R to D3–D6, G to GND, 5V to the 5V pin) and the button wires on the front of its pads, and two wires, about 60 mm long, to the `BAT+` and `BAT−` pads on its rear. Keep the joints small: the outer 0.8 mm of each pad is under a rail lip. Leave the other ends free: the XIAO goes in from below, so a wire already soldered at both ends would wrap round the housing.
6. Solder the receptacle to the USB-C charging PCB, then fit its gasket. Solder two wires from its VBUS and GND pads to the VIN and GND pads on the rear of the joystick PCB. Solder a wire to its LED pad and lead it out of the bottom opening. Slide the board along the rib until the nose enters the slot and the gasket sits in its pocket, and fix it with the two M2 × 4 screws. Pot the back of the receptacle with epoxy, keeping it out of the opening. With the housing rear face up, fill the LED window from outside with clear epoxy or UV resin, flush with the face; keep it off the USB-C opening and the gasket.
7. With the cover off, pass the free ends of the joystick and button wires up through the bottom opening and out of the front, and solder the LED wire from the USB-C PCB, hanging out of the bottom opening, to XIAO D8. Then put the XIAO in from below: up through the bottom opening 7.5 mm behind its rails, until its lower end is at about Y = −28 mm (fully inside, still below the rails); forward 7.5 mm to the rails; and up 27.5 mm along +Y until it stops. The battery wires hang out of the bottom opening behind it. Solder the free ends: the joystick wires to the rear pads of the joystick PCB (lead them away from its top edge) and the button wires to the buttons. (The XIAO can also go in through the front, edge-first, but the bottom is easier: it does not pass the 16.4 mm between the gasket lips flat.) Secure its free end with a drop of hot glue or silicone. Apply conformal coating to both boards.
8. Stick the vent label inside over the vent hole in the bottom end wall.
9. Stick a thin foam strip on the rear wall where the pouch lies. Splice the battery wires to the pouch leads outside the opening, red to `BAT+`, with heat-shrink over each joint. Slide the pouch up through the opening, protection board end down, and tuck the splice under it. Check the polarity before connecting either USB-C port.
10. Stick a foam pad on the inside of the battery cap, lay the cap gasket on the housing face, and fit the cap with three M2 × 8 countersunk screws. Tighten evenly.
11. Lay the cover face down and the gasket on it, folded at the fold line. Push the stick through the sheet hole and the cover hole, and lay the plate on the lower-facet sheet with its screw holes over the cover's.
12. Lower the housing onto the stack; its walls locate the plate. Turn the assembly over and fit the six M2 × 8 screws on the upper facet and the four M2 × 10 screws on the lower facet. Tighten evenly in a cross pattern.
13. Press the M2 insert into the knob. Slide the knob onto the pin with a 0.9 mm shim between the hub and the cover, and tighten the M2 × 4 grub screw on the pin.

The animation below shows steps 5 to 10. The position of the `BAT` pads on the XIAO's rear and the wire routing are drawn schematically; the source is [battery-assembly-v0.25.scad](../mechanical/cad/battery-assembly-v0.25.scad).

![V0.25 battery and XIAO assembly, animated: wires on the XIAO's BAT pads; the XIAO up through the bottom opening, forward to its rails and up to the stop; the battery wires run down behind it and out of the bottom opening; heat-shrink on, red spliced to red and black to black, sleeves shrunk (close-up); the pouch slid up with its protection board end down and the splice tucked under it; foam pad, gasket and cap with three screws.](images/complete-remote-v0.25-battery-assembly.gif)

Base:
1. Press the two M4 inserts into the base front's split face.
2. Press the two Ø1.5 × 4 mm dowel pins into the lock knob, and its M3 insert from inside the cup. Drop the lock spring into the pocket and push the M3 × 22 screw through it from the platform side. Fit the knob over the boss with the pins in the axial slots, thread it onto the shank until the head stands 2 mm proud with the knob on the block, turn it to the locked position, and lock it with an M3 nut.
3. Glue the two TPU strips into their pockets.
4. Fit the liner halves, place the base on the bar with the platform where the remote should sit, fit the cap from behind, set the angle, and tighten the two M4 × 16 bolts evenly.

Fitting: pull the lock knob, press the remote onto the platform 9 mm below its working position, and slide it up until it stops and the lock clicks in. Removal is the reverse.

To program over USB, remove the remote from the base and its cover. Take the knob off first by loosening its grub screw. The USB-C socket is on the component side at the lower end of the board and opens toward the bottom of the pod; a plug fits there with the cover off. The XIAO's USB-C and the charging USB-C are the same supply net: never connect both. Each opening disturbs the gasket, so BLE firmware updates remain a firmware requirement.

## Hardware

All parts for the remote and the base, with sources, are in the [bill of materials](bom.md).

The KSC2 J-bend terminals sit under the switch body. The LCSC land pattern used on the PCB extends 0.95 mm beyond the body, so a fine iron tip or hot air can reach the joints; having the board assembled is the easier option. The gull-wing version (`G`) has a different land pattern and does not fit this PCB.

## NAVCOMM reference

The [NAVCOMM product page](https://hesaparts.com/product/navcomm/) is the project's stated reference. Its [official user manual](https://hesaparts.com/wp-content/uploads/2025/02/EN/NAVCOMM%20USER%20MANUAL.pdf) specifies a 22 mm handlebar, at least 23 mm of space between the grip and the motorcycle's switchgear, rotation of the unit to suit the rider's reach, and fixing with two M4 screws and a flange. The control arrangement is one function button, two function/zoom buttons, and a lower four-way joystick.

V0.8 follows those functional and packaging cues while keeping original geometry. The CAD uses 23 mm as the target width along the bar, matching the manual's minimum installation gap; the manual does not publish the NAVCOMM's own overall width. Two parallel M4 bolts on either side of the bar close the rear clamp cap; ten M2 screws hold the control cover. The side panel keeps button presses perpendicular to the bar and can rotate around the bar before tightening.

## Sourced dimensions and design targets

| Feature | CAD value | Basis |
|---|---:|---|
| XIAO nRF52840 board outline | 21 × 17.8 mm | Seeed Studio published dimensions |
| APEM ISR3SAD200 panel cut-out | Ø13.6 mm with an anti-rotation flat 12.9 mm across | APEM IS series datasheet (16/08/2024); the flat is at the cover's print top, where it bridges |
| APEM ISR3SAD200 head and nut | Ø12 mm actuator, Ø17.5 mm bezel, 5.0 mm above the panel; M12 × 0.75 bushing, 13 mm behind the panel; 14 mm A/F hex nut | APEM IS series datasheet; the reduced Ø15 mm bezel (option 234) was not found at distributors |
| KSC2 switch | KSC221JLFS: 6.2 (+0.3) × 6.2 (+0.3) mm body, 3.5 mm to the actuator top, Ø2.9 mm actuator; 2 ± 0.5 N, 0.35 +0.3/−0.1 mm travel, 500,000 operations | C&K KSC datasheet (B-52, 1 Mar 2017); modelled at 6.5 mm |
| Handlebar | Ø22.2 mm (7/8 in) or Ø25.4 mm (1 in) | One base per bar size; measure the actual straight section |
| Base clamp | Ø46 mm outer diameter, Ø24.2 or Ø27.4 mm bore, flat platform at X = −17.2 mm from Y = −41 to +33.5 mm | Diametral split into two halves with a 0.8 mm clamping gap; not strength-validated |
| Remote rear face | Flat at X = −17.4 mm | 0.2 mm clear of the platform |
| Dovetail | Rails 10 mm wide at the platform, 15 mm at the top, 2.5 mm high, 45° flanks; two 8 mm segments with a 9 mm gap; 7 mm lips; 0.2 mm clearance; 9 mm slide | Prints without supports on both parts; clearance to tune on the first print |
| Lock | M3 × 22 ISO 4762 head (Ø5.5 × 3 mm) 2 mm proud, in a Ø6 mm pocket at Y = −32 mm; Ø5.8 mm hole in the remote; 0.5 × 5 × 10 mm spring; Ø16 × 8 mm quarter-turn knob on a Ø9 × 3.5 mm boss, two Ø1.5 × 4 mm pins | ISO 4762 head size; spring force estimated |
| USB-C receptacle | GCT USB4736-GF-A; shell axis at Y = 29.5 mm in the rear face, long side along the bar; 1.80 mm panel, 9.14 × 3.36 mm slot, 11.00 × 5.90 × 0.60 mm gasket pocket; USBTJ-06 gasket 10.64 × 4.86 × 0.90 mm; body 9.99 wide, 4.61 mm above its PCB, 8.60 mm long | GCT drawing USB4736 rev. A (9 April 2025) |
| LiPo pouch | 6 × 20 × 50 mm envelope with 0.5 mm clearance, X = −29 to −22, Y = −33.5 to 17.5 mm | 602050 listing; cells to 54 mm fit; measure the bought cell |
| Battery cap | Pod below Y = −37.7 mm from X = −35 mm back, 2.4 mm thick; opening X = −31 to −21.2 mm, 21 mm wide; three M2 × 8 countersunk screws; 0.6 mm gasket | Assembly study (V0.25); 2.8 mm below the lock hole |
| Pod front corners | 3 mm radius | Leaves a flat cover face for the M2 screws |
| Folded front | Upper facet normal to the pod axis; lower facet turned 20° toward the bar, fold 12.5 mm below the bar axis | Clears the thumb's path to the turn-signal switch; the angle is a parameter |
| Pod cavity corners | 2 mm front, 6 mm rear | 1 mm inset from the outer corners |
| Clamp liner | 1 mm radial TPU liner | Parametric target; tune to measured bar and print process |
| Remote envelope | 40.1 × 86.2 mm in the plane of the clamp (X = −57.5 to −17.4 mm); 23 mm along the bar at the rear, 26 mm at the control end | Bar footprint from the manual's 23 mm installation clearance |
| Button direction | Button axes perpendicular to the handlebar axis | Layout requirement |
| Case wall / cover | 2.0 mm axial walls at the control end, 1.0 mm in the narrow part and at the ends / 2.5 mm cover | Cover within the APEM IS panel range |
| Control layout | Buttons at Y = 33, 15, −3 mm (18 mm pitch) on the upper facet; joystick axis 14.5 mm below the fold on the lower facet, 24 mm from button C measured over the surface | APEM recommends 20 mm between IS buttons; 18 mm leaves 0.5 mm between bezels and 1.8 mm between nut corners, so the nuts need an open-end wrench. To judge on the first print |
| Clamp fasteners | Two parallel M4 × 16 ISO 4762 bolts at ±18.5 mm from the bar axis; Ø7.6 mm counterbores 8 mm from the split face; Ø5.6 × 8.1 mm insert holes | 7.6 mm grip, 7.6 mm engagement, 2.65 mm wall to the 25.4 mm bore; confirm against the bought bolts and inserts |
| Cover fasteners | Six M2 × 8 (upper facet) and four M2 × 10 (lower facet, through the joystick plate) ISO 10642 countersunk screws; Ø3.2 × 6 mm insert holes in Ø6 mm bosses | Spaced 16.5–21.8 mm along the perimeter to compress the gasket; confirm against the bought inserts |
| Cover gasket | 0.6 mm compressed (0.8 mm printed or cut) | Upper facet: 1 mm on the walls, 3.8 mm with the lip (4 mm before V0.24; the APEM nuts need the room), Ø6 mm around each screw. Lower facet: full sheet on the joystick plate, Ø2.4 mm hole stretched over the stick |
| Pod width | 23 mm along the bar at the base and the rear of the pod; 26 mm for X < −38 mm | 23 mm from the NAVCOMM manual's minimum free space on the bar; the control end is 40–60 mm from the bar axis |
| Joystick | Ø16 mm knob 5.7 mm proud, hub 0.9 mm and rim 1.15 mm above the cover; Ø3 × 12 mm steel pin; Ø6 mm ball on a Ø3.6 mm seat edge, pivot 7.0 mm behind the face; 1.2 mm cross disc 0.05 mm above four KSC2 at 6.75 mm | Trips at ≤ 5.9° tilt; knob stop at 8.2° or 0.9 mm push; disc room 9.5° |
| Joystick plate | 1.5 mm, behind the sheet; Ø3.6 mm seat hole opening to Ø4.8 mm at the front; Ø10 × 0.6 mm sheet pocket; two Ø3.6 mm standoffs, 6.25 mm tall, at (∓6.0, ±6.4) mm from the stick axis | Printed PETG; clamped by the four lower cover screws |
| Joystick PCB | 20.6 × 22.4 mm with four R3.3 mm boss notches; front face 10.85 mm behind the outer face, 1.6 mm thick; rear zone 1.0 mm, 3.0 mm in the upper half and the side strips | KiCad design in electronics/joystick-pcb; switch land pattern from LCSC C221728, the same C&K J-bend layout as the KSC221J (C221726) |
| Vent | Ø3 mm hole in the bottom end wall at X = −41 mm, Ø10 mm flat area inside | For an adhesive ePTFE vent; verify against the chosen vent |
| XIAO PCB / rear joint zone | 1.2 / 1.0 mm | No headers in V0.25; measure the bought board and the joints |

Seeed lists the XIAO board at 21 × 17.8 mm and provides a [2D DXF drawing](https://wiki.seeedstudio.com/XIAO_BLE/). The purchased variant has pre-soldered headers; V0.22 keeps the board parallel to the control cover, behind the control bodies, with the header pins pointing away from the controls. The 2.5 mm spacer and 6 mm pin length are allowances, not supplier dimensions. The [Kiwi listing](https://www.kiwi-electronics.com/en/seeed-studio-xiao-nrf52840-pre-soldered-20402) confirms the headers are pre-soldered. Check the actual header, USB-C, antenna, and component clearances against the printed cavity before finalizing it.

The C&K KSC series datasheet ([copy at LCSC](https://wmsc.lcsc.com/wmsc/upload/file/pdf/v2/lcsc/1809211731_C-K-KSC221JLFS_C221726.pdf), pages B-49 to B-52) gives the 6.2 × 6.2 mm body with +0.3 mm tolerance, the 3.5 mm soft-actuator height, a Ø2.9 mm actuator, the IP67 rating, and per type the force, life and travel: KSC201 1.6 N, 5,000,000 operations, 0.3 ± 0.2 mm; KSC221 2 N, 500,000, 0.35 +0.3/−0.1 mm; KSC222 2 N, 1,000,000, 0.35 ± 0.15 mm; KSC241 and KSC251 3.5 and 5.5 N, 300,000, 0.5 ± 0.2 mm. The knob stop at 0.9 mm of push covers every type up to 0.85 mm of maximum travel, so all of these. V0.20's Ruffy MHS joystick was listed at about £149 for one unit at Farnell UK, and the APEM NV 5-way (NVH1D1C1CP2S) at $143.34 at Mouser.

APEM's [IS series page](https://www.apem.com/panel-switches/pushbutton-switches/is) gives the Ø13.6 mm panel cutout, 13 mm behind-panel depth, 1.5–4 mm panel range, and 15 mm reduced-bezel option. Order-code availability and the reduced-bezel variant's exact drawing must be confirmed before selecting the production switch.

## Open unknowns before printing

These are the only items that block a confident first print. Each is a parameter in the CAD.

- **Buttons:** APEM ISR3SAD200 chosen; measure the nut thickness (`button_nut_h`, 2.5 mm assumed) and check the 18 mm pitch with gloves and a wrench on the first print.
- **Joystick:** measure the KSC2 height and the printed plate, ball and disc; together with the standoffs they set the 0.05 mm rest gap (`joy_rest_gap`). The feel (5.9° to trip, 2 N per direction, about 8 N for the centre chord) and the Ø16 mm knob need a check with gloves.
- **XIAO:** PCB thickness, component height and the height of the rear joints. Adjust `xiao_pcb`, `xiao_component_h` and `xiao_rear_h`; the render stops if the rear joints reach the pouch envelope.
- **Inserts:** hole diameters and depths for the actual M4 and M2 inserts.
- **Handlebar and liner:** measured bar diameter, and the 0.8 mm clamping gap tuned to the printed TPU liner.
- **Dovetail:** the 0.2 mm clearance (`dt_c`) against the printer, and the strip material and thickness for the preload. Whether the 0.48 mm the remote can move toward the platform feels loose on the buttons.
- **Lock:** a spring that fits a Ø6 mm pocket over a Ø3 mm shank and holds the head out firmly; its compressed length sets `lock_spring_solid`. The pull force, and whether 1 mm of head in the pocket is enough.
- **Pouch:** the bought cell's size (up to 54 mm long, 6 mm thick), its real capacity, protection board and lead exit, and its maximum charge current against the XIAO's 50 or 100 mA.
- **Battery cap:** whether the flat gasket seals on the 2.5 mm side lands, whether M2 screws hold in Ø1.6 mm pilots in PETG after a few battery changes, and whether the 26 mm bottom band clears the switchgear on the bike.
- **USB-C PCB:** check its hand-drawn USB4736 footprint against the real part or GCT's footprint files, and the Ø1.6 mm screw pilots against the chosen screws. How the board gets onto its rib is not solved (V0.24 and V0.25): slid straight in from the front, the 19 mm board meets the gasket lips and the upper cover bosses (46 mm³), and put in edge-first and turned flat it still overlaps by 7–60 mm³ in the paths tried. From below, the rib it sits on blocks the way.
- **Charge LED:** whether the LED shows well enough through the filled Ø1.6 mm window (`usbc_led_hole_d`), and whether the printed hole needs drilling out to size.
- **Profile LED:** the firmware shows the active profile on the XIAO's RGB LED (green or blue, a short blink every 10 s). The XIAO is enclosed, so the rider cannot see it. Options: blink the charge LED (D8) in a profile pattern, which needs no hardware change but has one color, or add a light pipe to the XIAO's LED, which needs a sealed window.
- **Vent:** label diameter and required hole size.
- **Gasket:** material, whether 0.2 mm of compression seals on a 1 mm land, and how long a printed TPU sheet lasts flexing with the stick.
- **Fold angle:** 20° is chosen to clear the turn-signal switch. The gland that kept it from 30° is gone in V0.24, but 30° has not been rechecked, and neither angle has been checked on a bike.

Not addressed by this concept: IP rating, impact, vibration, and fatigue strength. These need physical testing.

## Earlier versions

V0.1–V0.24 remain available for comparison. V0.23 is the fixed, cable-powered version: its clamp ring and shoulders are part of the housing. V0.22's PCB standoffs would overlap the pads of the real KSC2 land pattern; build V0.23 or later. V0.24 places a 602030 pouch that cannot be put in through the front opening (see [Changes from V0.24](#changes-from-v024)); build V0.25. V0.21 should not be built: its Ø7 mm keys are too small for gloves and hard to press on the folded facet. V0.20 uses the Ruffy MHS panel joystick, which costs about £149 and fills the 23 mm pod width. V0.19 has a straight control face that gets in the way of the turn-signal switch, and no gasket. V0.18 is installable, but its cover does not match the housing and it has no cover, board, or gland mounting. V0.17 should not be printed: its 250-degree body cannot pass the handlebar. V0.13–V0.16 are superseded attempts at the shoulder silhouette and should not be printed. V0.13 left gaps at the shoulders. V0.14 dropped most of the pod through an incorrectly closed polygon. In V0.15 and V0.16 the same polygon traced the clamp arc as an inner boundary, so the fixed 250-degree ring was missing and only the removable cap surrounded the bar.
