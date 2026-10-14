# No-Solder Assembly (V0.26) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn V0.25 into V0.26, which a builder assembles without soldering: three assembled boards, bought cables, a TPU keypad and a plug-in XIAO.

**Architecture:** A new control board behind the upper facet carries the three button switches, the XIAO in female headers, the charger, the 3.3 V regulator and the connectors. The joystick and USB-C boards get a connector each and lose their solder pads. The CAD gets a new version file; the firmware gets a new pin map and power handling.

**Tech Stack:** OpenSCAD 2026.x (manifold), KiCad 9 with its bundled Python and `kicad-cli`, Arduino `arduino-cli` with Seeed nRF52 Boards 1.1.13 (environment in `~/.arduino-orr`).

**Spec:** `docs/superpowers/specs/2026-10-14-no-solder-assembly-design.md`

## Global Constraints

- No hand soldering by the builder; every board is assembled by JLCPCB (PCBA). Heat-set inserts stay.
- Prefer parts JLCPCB can assemble from its library; prefer retail cables (Amazon) over distributor-only parts.
- Keep previous versions: V0.25 files are not edited; new files are `complete-remote-v0.26.scad`, `electronics/control-pcb/`, `electronics/joystick-pcb-rev-b/`, `electronics/usbc-pcb-rev-b/`.
- Docs, code comments and commit messages in English, short active sentences; update the docs in the same commit as the change.
- Every commit needs the user's explicit approval; `git commit -S -s`, no AI attribution, `git push origin main`.
- Copy changed `.scad` files to `~/Downloads` with `/bin/cp -f`.
- Interference checks: render `intersection()` to STL and measure its volume; 0 mm³ means no overlap. Check discrete poses, not hulls.
- XIAO pin map (spec): D0/A0 battery, D1–D3 buttons A–C, D4–D7 joystick up/down/left/right, D8 charger STAT, D9 VBUS present, D10 spare, 3V3 supply in, 5V not connected.

## Review Focus

1. **Battery plugged in reversed.** JST-PH pouch leads have no common polarity. Expect: nothing is damaged. Owner: Task 4 (reverse-polarity protection on the battery input, checked in the schematic review step).
2. **XIAO USB-C connected for programming with the battery in.** Two supplies meet on 3V3. Expect: no current into the board regulator, no damage. Owner: Tasks 1 and 4.
3. **Charger connected with no battery.** Expect: the board does not oscillate or brown out the XIAO; the charge LED does not flicker in a way that suggests charging. Owner: Task 4 (charger datasheet check, recorded in the README).
4. **Stack tolerances press a key at rest.** Expect: no KSC2 closed with the cover screwed down. Owner: Task 3 (rest-gap check at the extreme of the tolerance stack).
5. **Cable plugged into the wrong socket.** Expect: impossible (different pin counts) or harmless. Owner: Task 4 (socket pin counts differ; recorded in the README).

---

### Task 1: Decide how the XIAO is powered

**Files:**
- Modify: `docs/superpowers/specs/2026-10-14-no-solder-assembly-design.md` (Verification item 1: result and source)

**Interfaces:**
- Produces: the supply pin for the XIAO (3V3, or 5V through a diode) and whether the board regulator must block reverse current. Task 4 uses both.

- [ ] **Step 1:** Get Seeed's XIAO nRF52840 (Sense) schematic PDF from the Seeed wiki; record its URL and revision.
- [ ] **Step 2:** From it, record: the 3.3 V regulator part, what feeds it (VBUS, BAT, power path), and what sits between its output and the 3V3 pin.
- [ ] **Step 3:** Decide. 3V3 input is acceptable only if the regulator tolerates a powered output with no input and the USB path does not back-feed. Otherwise choose 5V input through a Schottky diode from the battery rail, and note the dropout margin at 3.3 V cell voltage.
- [ ] **Step 4:** Write the result, the evidence and the source into the spec. Ask the user to approve the commit; commit.

### Task 2: Choose parts and cables

**Files:**
- Create: `electronics/control-pcb/README.md` (section "Parts", one table)

**Interfaces:**
- Consumes: Task 1 decision.
- Produces: LCSC numbers and footprints for: LiPo charger (open-drain STAT, resistor-set current, about 100 mA), 3.3 V regulator (nanoamp Iq, reverse-current blocking if Task 1 needs it), battery reverse-polarity protection, PTC, TVS, JST-SH 1.0 mm side-entry SMD 3-pin and 5-pin sockets, JST-PH 2.0 mm 2-pin socket, low-profile 2.54 mm 1×7 female header (lowest available height), KSC221J. Retail links for: double-ended JST-SH 3-pin and 5-pin cables, JST-PH male-female extension. A sealed USB-C receptacle with CC pins that JLCPCB can assemble, or the GCT USB4736 through JLCPCB global sourcing.

- [ ] **Step 1:** For each part, record LCSC number, stock on the date checked, Basic/Extended, and the datasheet link. Reject parts out of stock.
- [ ] **Step 2:** Record the female header height and the XIAO pin length that sets the XIAO PCB position (Task 3 uses it).
- [ ] **Step 3:** Record cable lengths available against the routes in the spec (joystick about 30 mm, USB-C about 40 mm, battery extension to the cap).
- [ ] **Step 4:** Ask the user to approve the commit; commit.

### Task 3: CAD fit study of the upper-facet stack (gate)

**Files:**
- Create: `mechanical/cad/complete-remote-v0.26.scad` (copied from v0.25, header notes updated)

**Interfaces:**
- Consumes: Task 2 heights (header, KSC2 3.5 mm, board 1.6 mm).
- Produces: parameters `keypad_*`, `button_plate_*`, `ctrl_pcb_*` (`ctrl_pcb_x`, `ctrl_pcb_t = 1.6`, `ctrl_pcb_size`), `header_h`, `xiao_x` (new), and `part_to_render` views `"stack_section"` and `"control_stack"`. Task 7 builds on them.

- [ ] **Step 1:** Remove the XIAO rails and the APEM button bodies, nuts and cut-outs; add Ø13 mm key holes at `button_y`.
- [ ] **Step 2:** Model the keypad (Ø12 mm keys, 0.6 mm compressed sheet over the upper facet), the button plate with key-nub holes and two standoffs, the control board with three KSC2, the headers and the XIAO.
- [ ] **Step 3:** Check, and record each result in the console with `echo`: XIAO components to pouch envelope (target ≥ 1.5 mm); stack vs housing, cover, cover bosses and screws, joystick plate and PCB, USB-C PCB and rib: 0 mm³; key nub to KSC2 actuator rest gap with all stack tolerances at their maximum: > 0.
- [ ] **Step 4:** Check the cover coming off with the stack attached: discrete poses 0, 5, 10, 20 mm along −X, stack clear of the housing.
- [ ] **Step 5:** If the clearance target fails with standard headers and with the Task 2 low-profile header, stop and report to the user (spec fallback: XIAO soldered by JLCPCB).
- [ ] **Step 6:** Render `stack_section` to `docs/images/complete-remote-v0.26-stack-section.png`. Copy the `.scad` to `~/Downloads`. Ask the user to approve the commit; commit.

### Task 4: Control board

**Files:**
- Create: `electronics/control-pcb/design.py`, `gen_pcb.py`, `gen_sch.py` (same structure as `electronics/joystick-pcb/`), `control.kicad_*`, `fab/`, README sections "Board", "Regenerating", "Checks".

**Interfaces:**
- Consumes: Task 1 supply decision; Task 2 parts; Task 3 `ctrl_pcb_size`, switch positions, standoff holes, header positions.
- Produces: the battery divider ratio and the VBUS divider ratio (Task 6 uses them); connector pinouts J1 joystick (U, D, L, R, GND), J2 USB-C (VBUS, GND, LED cathode), J3 battery (BAT+, BAT−).

- [ ] **Step 1:** Write `design.py` with outline, placement and nets from Task 3 and the spec's pin map.
- [ ] **Step 2:** Generate; run `kicad-cli sch erc --severity-all` and `pcb drc --schematic-parity --severity-all`. Expected: 0 errors.
- [ ] **Step 3:** Review the schematic against the Review Focus items 1, 2, 3 and 5; record each in "Checks".
- [ ] **Step 4:** Export Gerbers, drill, JLCPCB BOM and CPL into `fab/`; check that the CPL rotations of the KSC2, sockets and charger match the footprints in the KiCad 3D view.
- [ ] **Step 5:** Ask the user to approve the commit; commit.

### Task 5: Joystick and USB-C boards, rev B

**Files:**
- Create: `electronics/joystick-pcb-rev-b/` (from `joystick-pcb/`), `electronics/usbc-pcb-rev-b/` (from `usbc-pcb/`)

**Interfaces:**
- Consumes: Task 4 J1 and J2 pinouts; Task 2 socket footprints.
- Produces: socket positions, which Task 7 uses for the cable routes.

- [ ] **Step 1:** Joystick rev B: remove PTC, TVS, VIN and wire pads; add a JST-SH 5-pin socket in the rear zone, clear of the XIAO USB-C plug zone (`joy_rear_tall_*`).
- [ ] **Step 2:** USB-C rev B: LED anode to VBUS through its resistor, LED cathode to the socket; add a JST-SH 3-pin socket; keep the outline 19 × 13.6 mm.
- [ ] **Step 3:** ERC and DRC on both: 0 errors. Export fab outputs with BOM and CPL.
- [ ] **Step 4:** Ask the user to approve the commit; commit.

### Task 6: Firmware for the control board

**Files:**
- Modify: `firmware/xiao-nrf52840/open-rally-remote.ino`, `firmware/xiao-nrf52840/README.md`

**Interfaces:**
- Consumes: Task 4 divider ratios and pin map.
- Produces: build option `BOARD_V026` (true: control board pin map and power; false: breadboard and V0.25, unchanged behaviour).

- [ ] **Step 1:** Add `BOARD_V026`. With it: pins from the spec; battery on A0 with Task 4's ratio; charger present from D9 (also armed as a System OFF wake source); charging from D8; no P0.14, P0.13 or D8 charge-LED output.
- [ ] **Step 2:** Compile both values of `BOARD_V026` with `arduino-cli` (see `~/.arduino-orr/README.txt`). Expected: no warnings from the sketch.
- [ ] **Step 3:** Flash `BOARD_V026 = false` to the bench XIAO and confirm the three profiles still work (regression).
- [ ] **Step 4:** Update the README pin table; ask the user to approve the commit; commit.

### Task 7: Complete V0.26 CAD

**Files:**
- Modify: `mechanical/cad/complete-remote-v0.26.scad`

**Interfaces:**
- Consumes: Task 3 stack; Task 5 socket positions.
- Produces: print modes `print_keypad`, `print_button_plate`; views `assembly`, `interior`, `section`; the parameters the assembly video will animate.

- [ ] **Step 1:** Remove the upper-facet wall-land gasket where the keypad sheet replaces it; keep the lower-facet sheet.
- [ ] **Step 2:** Add cable route envelopes (JST-SH plugs and cable, JST-PH extension) and the foam pad between XIAO and pouch.
- [ ] **Step 3:** Run the V0.25 check table again plus: cables vs everything (0 mm³ except their own sockets), battery extension plug in the cap space, pouch slide-in path. Record results.
- [ ] **Step 4:** Render the views to `docs/images/complete-remote-v0.26-*.png`; copy the `.scad` to `~/Downloads`; ask the user to approve the commit; commit.

### Task 8: Documentation

**Files:**
- Modify: `docs/mechanical-concept.md` (V0.26 title, "Changes from V0.25", checks table, assembly steps, open unknowns), `docs/bom.md`, `docs/battery-study.md` (firmware and power architecture), `docs/firmware-spec.md` (pins), `README.md` (status lines)

- [ ] **Step 1:** Write the V0.26 sections from Tasks 1–7 results. Assembly steps follow the spec's target sequence, corrected by what Task 7 found.
- [ ] **Step 2:** BOM: remove APEM buttons, nuts and wire; add the three boards with PCBA costs (quote date), cables, female headers, pre-soldered XIAO, keypad TPU print.
- [ ] **Step 3:** Open unknowns: keypad feel with gloves, TPU sheet sealing, header retention under vibration, insert installation by the print service.
- [ ] **Step 4:** Ask the user to approve the commit; commit and push.
