# CLAUDE.md

Guidance for AI assistants working in this repository. The project state lives in the docs, not here: read `README.md` first, then the doc for the area you work on.

## Repository map

- `docs/`: the design record.
  - `mechanical-concept.md`: the current CAD version, its changes, the checks table, assembly steps and open unknowns.
  - `battery-study.md`, `bom.md`, `electronics-assembly.md`, `firmware-spec.md`, `control-mapping.md`, `breadboard-assembly.md`, `prototype-plan.md`, `project-brief.md`, `development-environment.md`.
  - `images/`: renders and photos named `<part>-v<version>-<view>.png`.
- `mechanical/cad/`: OpenSCAD models. `complete-remote-v0.N.scad` is the whole remote. Other files, such as `battery-assembly-v0.25.scad`, include it.
- `electronics/`: KiCad boards generated from Python (`design.py`, `gen_pcb.py`, `gen_sch.py`). V0.27 to V0.32 use `control-pcb/`, `joystick-pcb-rev-c/` and `usbc-pcb-rev-b/`, which share one generator and route with Freerouting; `panel-ctrl-joy/` panels the control and joystick boards for one order (KiKit, see its README); `joystick-pcb-rev-b/` is the V0.26 board, and `joystick-pcb/` and `usbc-pcb/` are the V0.23–V0.25 boards. Each README has a "Regenerating" section.
- `electronics/tools/assembly_images.py` draws the step images for `docs/electronics-assembly.md` (run with KiCad's Python).
- `firmware/xiao-nrf52840/`: the Arduino diagnostic sketch for the Seeed XIAO nRF52840. Its README covers the build, the upload and the bench test results.

## Working rules

- **Verify, do not assume.** Check fits, clearances and assembly paths in CAD before you claim them. Take part data from datasheets or listings, and cite them. If something cannot be verified, say so and record it as an open unknown in the docs.
- **Challenge requests** that go against good mechanical or electrical practice. Explain the risk; do not just comply.
- **Keep previous versions.** A design change makes a new file (`complete-remote-v0.N+1.scad`). Do not edit an older version, except to fix its header notes.
- **Update the docs with every change**, in the same commit:
  - `mechanical-concept.md`: the version title, "Changes from V0.N", the checks table, the assembly steps and the open unknowns;
  - `README.md` status lines;
  - `bom.md` parts and cost estimates;
  - new renders in `docs/images/`.
- **Prefer retail parts** that individual makers can buy (for example on Amazon) over distributor-only parts. Printed parts are ordered from a print service. Do not plan around test prints.
- **No personal build status in the repo.** Do not record which parts a contributor has bought or received.

## Writing style

- Docs are in English and Spanish. The English file (`name.md`) is the reference; the Spanish one sits beside it as `name.es.md`, links to it at the top and says so. Change both in the same commit. Code comments and commit messages stay in English only.
- Existing docs without a `.es.md` are not translated yet; translate a doc when it is next changed, or when asked.
- Use short sentences, one idea each, in the active voice. Use the same term for the same thing every time.
- Commit subjects use the imperative mood ("Add V0.25 ..."), about 50 characters. Wrap the body at 72 characters and explain why.
- Sign every commit (`git commit -S -s`). Do not add AI attribution or Co-Authored-By lines.

## Commands

OpenSCAD renders and checks (OpenSCAD 2026.x with the manifold backend):

```sh
openscad -o out.png --imgsize=1200,900 -D 'part_to_render="assembly"' mechanical/cad/complete-remote-v0.32.scad
openscad -o out.stl -D 'part_to_render="print_housing"' mechanical/cad/complete-remote-v0.32.scad
```

`part_to_render` lists every view and print part at the top of the file. For interference, render `intersection() { A(); B(); }` to STL and measure its volume; 0 mm³ means no overlap. Hulls give false collisions for non-convex parts moving along a path; check discrete poses instead. Animations use `--animate N`; `-D '$t=...'` is ignored.

KiCad: see "Regenerating" in each PCB README. Use KiCad's bundled Python and `kicad-cli` for ERC, DRC and exports. The V0.26 and V0.27 boards need Freerouting 1.9.0 (Java 17); 2.x needs Java 25.

Assembly video and path check (newest version; `ORR_VERSION=0.26` for V0.26): `python3 mechanical/cad/tools/assembly_video.py check|frames|video`, tests in `mechanical/cad/tools/test_assembly_video.py` and, for the V0.30 cover and V0.31 cap seals, `test_seal.py`, and for the V0.32 part changes, `test_v032.py`; see "Assembly video" in `docs/mechanical-concept.md`. Output goes to the git-ignored `mechanical/cad/build/`.

Firmware: see `firmware/xiao-nrf52840/README.md`. On Apple Silicon without Rosetta, the Seeed package's GCC and `adafruit-nrfutil` binaries do not run. Use Arm GNU Toolchain 13.3 and `pip install adafruit-nrfutil`, set in a `platform.local.txt`.
