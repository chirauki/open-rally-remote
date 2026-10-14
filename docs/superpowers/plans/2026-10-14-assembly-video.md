# V0.26 Assembly Video Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A chaptered MP4 of the V0.26 assembly, steps 1–11, plus a collision report for the part paths at key poses.

**Architecture:** An OpenSCAD file holds the part list and the timeline and draws one pose (`step`, `u`). A Python script renders frames in parallel, runs the collision check through the same file, and builds the MP4 with ffmpeg.

**Tech Stack:** OpenSCAD 2026.x (manifold), Python 3 standard library (`unittest`, `subprocess`, `concurrent.futures`), ffmpeg/ffprobe.

**Spec:** `docs/superpowers/specs/2026-10-14-assembly-video-design.md`

## Global Constraints

- Video: 1280 × 720, 24 fps, one chapter per step, 11 chapters, about 4–6 s per step, file about 5 MB at most.
- Collision: five poses per move, `u` = 0, 0.25, 0.5, 0.75, 1 of the move's interval; a volume over 0.01 mm³ is a collision.
- Both step 8–9 variants are checked: `"documented"` and `"battery_first"`.
- Cables are not animated: a short straight stub before their plug goes in, the final position after. Cable collisions are checked only in the final position.
- Python standard library only. No Blender.
- Do not edit `complete-remote-v0.26.scad`, except to fix header notes. The video file includes it.
- Docs, comments and commits in English; commits `git commit -S -s`, no AI attribution. After every `.scad` change: `/bin/cp -f mechanical/cad/*-v0.26.scad ~/Downloads/`.
- Build output (frames, STLs, temp files) goes in `mechanical/cad/build/`, git-ignored.

## Review Focus

1. **Contacts by design at the final pose** (the gasket against the cover, the keys in their holes, the screws in the bosses): the check must not report them as collisions. Expected: a named allowlist, with a reason for each pair, and the final-pose overlap of each pair measured and printed. Test in Task 3.
2. **Step joins:** the last pose of step N must equal the first pose of step N+1, or the video jumps. Test in Task 2.
3. **A part missing from the timeline** never shows in the video and is never checked. Expected: every name in `PARTS` is placed in step 11. Test in Task 2.
4. **An OpenSCAD error in one frame** (a warning or an empty render) must stop the run, not leave a black frame. Test in Task 4.
5. **Step titles** come from `docs/mechanical-concept.md`. If the assembly list there changes length, the run must fail. Test in Task 4.

---

### Task 1: Part list and final pose

**Files:**
- Create: `mechanical/cad/assembly-video-v0.26.scad`
- Create: `mechanical/cad/tools/assembly_video.py`
- Create: `mechanical/cad/tools/test_assembly_video.py`
- Modify: `.gitignore` (add `mechanical/cad/build/`)

**Interfaces:**
- Produces (scad): variables `step` (1–11), `u` (0–1), `variant` (`"documented"` | `"battery_first"`), `red` (list of names), `mode` (`"pose"` | `"only"` | `"others"` | `"info"`), `target` (one part name). `module part(name)` draws one part at the origin of its final position. `module pose_view()` draws every part per the timeline.
- Produces (Python): `PARTS: list[str]`; `run_scad(defs: dict, out: Path) -> str` (returns stderr; raises `ScadError` on any `WARNING:` or `ERROR:` line, or an empty output file); `stl_volume(path: Path) -> float` (mm³, signed tetrahedra over an ASCII or binary STL).

Part names, one `part()` branch each, wrapping the existing modules:
`housing`, `cover` (`face_cover`), `keypad` (`gasket`, which includes the keys), `joy_plate`, `button_plate`, `stick`, `knob`, `battery_cap`, `cap_gasket`, `control_board` (`control_board_envelope`), `xiao` (`xiao_envelope`), `xiao_foam`, `joy_board` (`joy_envelope`), `usbc_board` (`usbc_envelope`), `pouch`, `cable_joy`, `cable_usb`, `cable_bat`, `vent_label`.

- [ ] **Step 1: Write the failing tests** in `test_assembly_video.py`:
  - `test_stl_volume_cube`: a 10 mm cube rendered by `run_scad` measures 1000 ± 0.01 mm³.
  - `test_final_pose_matches_model`: at `step=11, u=1`, `pose_view()` minus `vent_label` against `remote_parts(); controls_and_board();` from the model. Both `difference()` directions measure ≤ 0.01 mm³.
  - `test_run_scad_raises_on_warning`: a file with `undefined_var;` raises `ScadError`.
- [ ] **Step 2: Run** `python3 -m unittest mechanical/cad/tools/test_assembly_video.py -v`. Expected: FAIL (module missing).
- [ ] **Step 3: Implement** the scad part list and `pose_view()`, with every part placed at its final position for now, plus `run_scad`, `stl_volume` and `PARTS`. `run_scad` writes a temporary wrapper `.scad` in `build/` with `include <../assembly-video-v0.26.scad>`; it does not use `-D` for strings.
- [ ] **Step 4: Run the tests.** Expected: 3/3 PASS.
- [ ] **Step 5: Commit** "Add the V0.26 assembly video part list". Copy the scad files to `~/Downloads`.

### Task 2: Timeline

**Files:**
- Modify: `mechanical/cad/assembly-video-v0.26.scad`
- Modify: `mechanical/cad/tools/assembly_video.py`, `test_assembly_video.py`

**Interfaces:**
- Consumes: `part`, `pose_view`, `run_scad`, `PARTS`.
- Produces (scad): `timeline(variant)`, one entry per step: `[duration_s, camera, moves, marks, see_through]`. A move is `[name, from_offset, to_offset, u0, u1]`, eased with the model's `ramp()`. A mark is `[name, u0, u1]`, a flash. `camera` is the `--camera` vector `[tx,ty,tz,rx,ry,rz,dist]`. The spec says `$vpr`/`$vpt`/`$vpd`. The plan passes the camera on the command line instead, because it is not verified that the OpenSCAD CLI honours `$vp*` set in the file. A part is hidden before the first step that moves or marks it; after that it stays at its last offset. In `mode="info"`, the file `echo`es `info=[step, duration_s, camera, names placed, names moving]`.
- Produces (Python): `step_info(step: int, variant: str) -> dict` with keys `duration`, `camera`, `placed`, `moving`.

Moves, from the "Assembly" steps of `docs/mechanical-concept.md`. Each direction comes from the model's frames and is recorded in a comment beside its move:
1. Housing in view; mark the ten insert bosses.
2. `usbc_board` along its rib into the slot (+X, toward `rear_x`); mark the epoxy area; `cable_usb` stub.
3. `stick` into `joy_plate` from the back; `joy_board` onto the plate standoffs; `cable_joy` stub.
4. `control_board` onto `button_plate`; `xiao` into the headers along +X.
5. `cover` face down; `keypad` into the cover; `stick` + `joy_plate` through the sheet; `button_plate` + board stack onto the upper-facet sheet.
6. `cable_joy` and `cable_usb` to final; `xiao_foam` on.
7. `vent_label`; foam strip as a mark.
8. `housing` lowered onto the stack (along −X onto the cover), then turned over; screws as marks.
9. `documented`: the cover stack lifted off (+X), `pouch` up through the bottom opening (+Y), `cable_bat` to final, the stack closed again. `battery_first`: in step 8, before the housing closes, the `pouch` goes in and `cable_bat` reaches J5 with the stack beside the housing; step 9 has no moves.
10. `cap_gasket`, then `battery_cap` from below (+Y).
11. `knob` onto the pin; shim as a mark.

- [ ] **Step 1: Write the failing tests:**
  - `test_steps_join`: for each variant and each step N in 1–10, every part at `(N, u=1)` and `(N+1, u=0)` has the same `difference()` volume, ≤ 0.01 mm³ both ways.
  - `test_all_parts_placed`: `step_info(11, v)["placed"]` equals `set(PARTS)` for both variants.
  - `test_every_step_renders`: each step at `u` = 0, 0.5, 1 renders a non-empty PNG with no warnings.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement** the timeline, `see_through` (drawn with `color(c, 0.25)`), the marks (an emissive yellow flash for `0.5 < sin(...)`) and `step_info`. Pick each camera so the moving part fills about half the frame.
- [ ] **Step 4: Run** all tests. Expected: PASS. Render the middle frame of every step into `build/preview/` and look at each one.
- [ ] **Step 5: Commit** "Add the V0.26 assembly timeline". Copy the scad files.

### Task 3: Collision check

**Files:**
- Modify: `mechanical/cad/tools/assembly_video.py`, `test_assembly_video.py`, `mechanical/cad/assembly-video-v0.26.scad` (a `variant="test_collision"` with one move: the `xiao` through the `button_plate` along −X at step 4)
- Create: `docs/assembly-video-v0.26-checks.md` (generated)

**Interfaces:**
- Consumes: `run_scad`, `stl_volume`, `step_info`.
- Produces: `check(variant: str) -> list[Hit]`, where `Hit = (step, name, u, other, volume_mm3)`; `ALLOWED_CONTACT: dict[frozenset[str], str]` (pair to reason); `write_report(results: dict[str, list[Hit]], path: Path)`. The CLI command `python3 tools/assembly_video.py check` writes the report and `build/collisions.json`: `{variant: [[step, name, u0, u1], ...]}`.

For each moving part, at each pose: render `intersection() { part(name); part(other); }` for each other placed part, except pairs in `ALLOWED_CONTACT` and cable pairs before step 11. Run in parallel. A colliding interval is a run of colliding poses, widened to the neighbouring poses.

- [ ] **Step 1: Write the failing tests:**
  - `test_known_collision_found`: `check("test_collision")` returns a hit for `xiao` and `button_plate` with volume > 0.01.
  - `test_allowed_contacts_measured`: for each `ALLOWED_CONTACT` pair, the final-pose overlap is measured and printed into the report. The check passes only if every pair has a reason.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement** `check`, `ALLOWED_CONTACT` (start empty; add a pair only when its final-pose overlap is by design, with the reason) and `write_report`.
- [ ] **Step 4: Run** the tests, then `check` for both real variants. Expected: tests PASS. The report lists every hit. A real collision found here is a design finding: record it in the report and in the "Open unknowns" of `mechanical-concept.md`. Do not change the model in this plan.
- [ ] **Step 5: Commit** "Check the V0.26 assembly paths for collisions".

### Task 4: Frames and video

**Files:**
- Modify: `mechanical/cad/tools/assembly_video.py`, `test_assembly_video.py`
- Create: `docs/videos/complete-remote-v0.26-assembly.mp4`

**Interfaces:**
- Consumes: `step_info`, `run_scad`, `build/collisions.json`.
- Produces: `step_titles(doc: Path) -> list[str]` (the first sentence of each numbered item under "Remote (V0.26" in "## Assembly"; raises if it does not find 11 items); the CLI commands `frames [--step N]` and `video`.

- `frames`: renders `build/frames/sNN/fNNNN.png`, with `ceil(duration*24)` frames per step, `u = i/(n-1)`, `--camera` from `step_info`, `--imgsize=1280,720 --projection=p --colorscheme=Tomorrow`, and `red` set to the parts colliding at that `u` (documented variant). Uses all cores and stops on the first `ScadError`.
- `video`: one H.264 segment per step, with the caption `Step N — <title>` burned in by `drawtext` (Helvetica from `/System/Library/Fonts`). The segments are joined with the concat demuxer, and the chapters are written in an `FFMETADATA1` file, `-movflags +faststart`, CRF chosen to keep it about 5 MB.

- [ ] **Step 1: Write the failing tests:**
  - `test_step_titles`: 11 titles; title 1 starts "Press the ten M2 inserts".
  - `test_step_titles_wrong_count`: a doc with 10 items raises `ValueError`.
  - `test_frames_stop_on_error`: `frames` on a broken temp scad raises `ScadError` and leaves no PNG for that frame.
  - `test_video_chapters`: after `video`, `ffprobe -show_chapters -of json` lists 11 chapters whose titles match `step_titles`, and the size is ≤ 6 MB.
- [ ] **Step 2: Run** the first three. Expected: FAIL.
- [ ] **Step 3: Implement** `step_titles`, `frames` and `video`.
- [ ] **Step 4: Run** `frames`, `video`, then all tests. Expected: PASS. Watch the MP4 once from start to end.
- [ ] **Step 5: Commit** "Add the V0.26 assembly video".

### Task 5: Docs

**Files:**
- Modify: `docs/mechanical-concept.md` (an "Assembly video" section after "Assembly": a link to the MP4 and the report, the regenerate commands, and the findings), `README.md` (a status line), `CLAUDE.md` (the commands section: `tools/assembly_video.py`).
- Modify: `firmware/xiao-nrf52840/README.md`: the bench result on 2026-10-14. Firmware 0.8.0 (breadboard build) still works; two profiles were tried, the third was not.

- [ ] **Step 1: Write** the sections.
- [ ] **Step 2: Run** the whole suite: `python3 -m unittest mechanical/cad/tools/test_assembly_video.py -v`. Expected: all PASS.
- [ ] **Step 3: Commit** "Document the V0.26 assembly video".
