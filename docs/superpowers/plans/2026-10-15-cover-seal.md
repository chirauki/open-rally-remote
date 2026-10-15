# Cover Seal (V0.30) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** V0.30 of the remote seals both control facets with a foam strip on a lowered housing rim, a loose keypad sheet, stop pads and stretch-sealed screw holes.

**Architecture:** A new `complete-remote-v0.30.scad`, copied from V0.29, with new stack parameters for the loose sheet, the foam and the pads. Tests in a new `mechanical/cad/tools/test_seal.py` render intersections with `assembly_video.run_scad(..., scad=...)` and measure STL volumes, as the assembly video tests do. The assembly video tool moves to V0.30.

**Tech Stack:** OpenSCAD 2026.x (manifold), Python 3 standard library, ffmpeg.

**Spec:** `docs/superpowers/specs/2026-10-15-cover-seal-design.md`

## Global Constraints

- Sheet printed 0.8 mm (`gasket_print_thickness`), loose over the plates: 0.1 mm clearance (`sheet_clear`).
- Foam: 1.5 mm thick (`foam_t`), compressed to 1.0 mm (`foam_comp`), 2 mm wide (`foam_w`); load 0.05–0.1 N/mm, catalogue values.
- Rim: drops so the foam under the sheet's edge compresses to `foam_comp`; end walls widen inward to 2 mm.
- Stop pads: Ø4 mm, one per cover screw, on the side away from the rim, pinching the sheet 0.05 mm (`pad_pinch`).
- Sheet screw holes: Ø1.4 mm (`sheet_screw_hole`).
- `key_rest_gap` stays 0.3 mm with the sheet against the cover.
- `gasket_gap` (0.6) stays: the battery cap gasket uses it. The cover-sheet stack gets its own parameters.
- Keep V0.29 unchanged except its header notes. Copy the scad files to `~/Downloads` with `/bin/cp -f` after each change. Docs, comments and commits in English; `git commit -S -s`.

## Review Focus

1. **A sheet printed thick** (0.9 mm, the upper print tolerance) must still not be squeezed over the plates: only the pads touch it. Test in Task 1.
2. **The lower facet is tilted 20°.** Every new band (sheet, rim drop, foam, pads) must follow its normal, not X. Tests in Tasks 1–3 cover both facets separately.
3. **The foam must sit fully on the rim,** with no overhang into the cavity at the widened ends or through the fold. Test in Task 2.
4. **The joystick pivot moves back about 0.3 mm with the plate.** The knob must still reach the pin and keep its stops. The existing asserts and a pin engagement test in Task 1.
5. **Pads near the rim** must not cut into the foam strip. Test in Task 3.

---

### Task 1: Loose sheet stack

**Files:**
- Create: `mechanical/cad/complete-remote-v0.30.scad` (copy of V0.29)
- Create: `mechanical/cad/tools/test_seal.py`

**Interfaces:**
- Produces (scad): `sheet_clear = 0.1`, `foam_t = 1.5`, `foam_comp = 1.0`, `foam_w = 2.0`. Offsets from the cover's outer face: `sheet_back_off = cover_back_off + gasket_print_thickness` (3.3), `plate_front_off = btn_plate_front_off = sheet_back_off + sheet_clear` (3.4), `btn_ksc_top_off = sheet_back_off + key_rest_gap` (3.6), `rim_off = sheet_back_off + foam_comp` (4.3), and `housing_front_off = rim_off`. `gasket()` draws the sheet from `cover_back_off` to `sheet_back_off`. The cover bosses use the plate offsets, not `gasket_gap`. `echo("Seal stack: ", [...])` prints these values.
- Produces (Python): `SCAD30` (path of `complete-remote-v0.30.scad`); `vol(body, name, defs={})`, a helper over `run_scad` and `stl_volume`.

- [ ] **Step 1: Write the failing tests** in `test_seal.py`:
  - `test_sheet_loose`: `intersection(gasket(), union(button_plate(), joy_plate(), housing()))` measures ≤ 0.01 mm³.
  - `test_sheet_loose_when_thick`: the same with `gasket_print_thickness = 0.9`: ≤ 0.01 mm³ (it only touches).
  - `test_rim_dropped`: `intersection(housing(), front band from cover_back_off to rim_off on both facets)` measures ≤ 0.01 mm³.
  - `test_key_rest_gap`: the echoed `btn_ksc_top_off − sheet_back_off` equals 0.3.
  - `test_knob_on_pin`: `intersection(knob(), pin)` grown 0.05 mm is non-empty, and every existing assert passes (no `WARNING` or `ERROR`).
- [ ] **Step 2: Run** `python3 -m unittest mechanical/cad/tools/test_seal.py -v`. Expected: FAIL (no V0.30 file).
- [ ] **Step 3: Implement** the V0.30 copy, the header note, the parameters and the derived offsets above.
- [ ] **Step 4: Run** the tests. Expected: PASS. Also run `mechanical/cad/tools/test_assembly_video.py` with `ORR_VERSION=0.29`. Expected: PASS (V0.29 untouched).
- [ ] **Step 5: Commit** "Loosen the keypad sheet in V0.30".

### Task 2: Foam strip and widened end rims

**Files:**
- Modify: `mechanical/cad/complete-remote-v0.30.scad`, `mechanical/cad/tools/test_seal.py`

**Interfaces:**
- Consumes: `rim_off`, `foam_comp`, `foam_w`, `sheet_back_off`.
- Produces: `module rim_2d()` (the housing rim footprint in each facet's plane: pod outline less cavity, with the end walls widened to `foam_w`); `module foam_strip()` (the compressed foam, `foam_comp` thick, on `rim_2d()`, on both facets, continuous through the fold); `foam_length` echoed in mm.

- [ ] **Step 1: Write the failing tests:**
  - `test_foam_on_rim`: `foam_strip()` moved 0.1 mm toward the housing, intersected with `housing()`, measures foam area × 0.1 within 2 %; the foam's area is echoed.
  - `test_foam_clear`: `foam_strip()` against the plates, the control board, the joystick board, the XIAO and the cover bosses: ≤ 0.01 mm³.
  - `test_foam_under_sheet`: `foam_strip()` against `gasket()`: contact only (≤ 0.01 mm³), and against `face_cover()`: ≤ 0.01 mm³.
  - `test_widened_ends_clear`: `housing()` against the plates, the control board, the joystick board and the button plate standoffs: ≤ 0.01 mm³.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement** `rim_2d()`, the widened end walls in `housing()` (2 mm deep behind `rim_off`, enough to carry the foam), and `foam_strip()`. Add `foam_strip()` to `controls_and_board()` so the views show it.
- [ ] **Step 4: Run** the tests. Expected: PASS. Echo `foam_length`. Expected: about 220 mm.
- [ ] **Step 5: Commit** "Add the V0.30 foam strip on a widened rim".

### Task 3: Stop pads and screw holes

**Files:**
- Modify: `mechanical/cad/complete-remote-v0.30.scad`, `mechanical/cad/tools/test_seal.py`

**Interfaces:**
- Produces: `pad_d = 4.0`, `pad_pinch = 0.05`, `sheet_screw_hole = 1.4`; `module stop_pads()`, drawn as part of `button_plate()` and `joy_plate()`, one per cover screw, offset away from the rim so they clear `foam_strip()`. An echo gives the pads' contact area and the load at `pad_pinch`, from the spec's model (E = 13 MPa, the shape factor of a Ø4 mm pad, 0.8 mm sheet).

- [ ] **Step 1: Write the failing tests:**
  - `test_pads_pinch`: `intersection(gasket(), union(button_plate(), joy_plate()))` measures 10 × pad area × 0.05 within 10 %.
  - `test_pads_clear`: `stop_pads()` against `foam_strip()`, the key web holes (`at_buttons() cylinder(d=key_web_d)`) and the plate edges: ≤ 0.01 mm³.
  - `test_sheet_screw_holes`: `gasket()` against `at_cover_screws() cylinder(d=1.4)` measures ≤ 0.01 mm³, and against `cylinder(d=2.0)` > 0 (the sheet grips the M2 shank).
  - `test_pad_load`: the echoed load per pad is between 20 and 100 N.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement** the pads and the Ø1.4 holes.
- [ ] **Step 4: Run** the tests. Expected: PASS.
- [ ] **Step 5: Commit** "Add the V0.30 stop pads and stretch-sealed screw holes".

### Task 4: Regression checks and the assembly video

**Files:**
- Create: `mechanical/cad/assembly-video-v0.30.scad` (copy of V0.29's, with `foam_strip` added as a part placed in step 7 on the housing)
- Modify: `mechanical/cad/tools/assembly_video.py` (`VERSION` "0.30", `FINDINGS["0.30"]`, `PARTS` gains `foam_strip`), `test_assembly_video.py`
- Create: `docs/assembly-video-v0.30-checks.md`, `docs/videos/complete-remote-v0.30-assembly.mp4` (generated)

- [ ] **Step 1: Write the failing test** `test_foam_in_parts`: `"foam_strip" in av.PARTS`, and the final pose of step 11 still matches the V0.30 model (`test_final_pose_matches_model` now includes `foam_strip()`).
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.** Assembly step 7 in `docs/mechanical-concept.md`: "Stick the foam strip on the housing rim round both facets, butt joints at the end corners, and a thin foam strip on the rear wall where the pouch lies."
- [ ] **Step 4: Run** `check`, `frames`, `video` and all tests. Expected: no collision, beyond contacts by design that the report lists with a reason. Re-run the V0.26-era stack, removal and tilt checks against V0.30 (stack vs housing, cover, gasket, plate, joystick, USB-C, pouch, screws; removal 1–25 mm; tilt to the knob stop). Expected: the same results as V0.29, with the XIAO-to-pouch gap reported.
- [ ] **Step 5: Commit** "Add the V0.30 assembly video".

### Task 5: Docs

**Files:**
- Modify: `docs/mechanical-concept.md` (title V0.30, "Changes from V0.29" with the spec's numbers and the CAD results, the checks table, the printing notes for the pads, the open unknowns: the leak test, the foam's real force, the key feel), `docs/bom.md` (foam tape row), `README.md`, `CLAUDE.md` (V0.30 commands).

- [ ] **Step 1: Write** the sections, with images of the foam strip and pads (`docs/images/complete-remote-v0.30-*.png`).
- [ ] **Step 2: Run** both test files. Expected: all PASS.
- [ ] **Step 3: Commit** "Document V0.30".
