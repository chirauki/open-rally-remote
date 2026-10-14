# V0.26 Assembly Video — Design

**Date:** 2026-10-14
**Status:** approved 2026-10-14.

## Goal

A video of the whole V0.26 remote assembly, used for design review. It shows that every assembly step is possible: the paths the parts take, the order, and the clearances. It is not a builder's guide and does not aim to look good.

Alongside the video, a script checks the assembly paths for collisions at key poses. The video shows a part in red over the intervals where it collides.

## Agreed with the user

- Audience: design review.
- Format: one MP4 with one chapter per assembly step. It opens in QuickTime or VLC, which can pause, rewind and jump between chapters.
- Collisions: checked at key poses of each move, reported in text, and shown in red in the video.

## Approach

OpenSCAD renders the frames; a Python script drives it. Only tools already installed are used: OpenSCAD 2026.x (manifold backend), Python 3 and ffmpeg. The geometry is the same model the other CAD checks use.

Rejected:
- **Blender:** better images, but a second pipeline and an STL export for every part. Collision checks would still run in OpenSCAD. Not worth it for a design review. It stays possible later, from the same timeline.
- **`openscad --animate` alone:** renders frames one after another. About 1,400 frames would take hours, and per-step cameras are awkward. `-D '$t=...'` is ignored, so frames cannot be split across processes that way.

## Parts

### `mechanical/cad/assembly-video-v0.26.scad`

- Includes `complete-remote-v0.26.scad` with `part_to_render = "none"`.
- Takes `step` (1–11), `u` (0–1 within the step), `variant` (`"documented"` or `"battery_first"`, see steps 8 and 9) and `red` (a list of part names to draw in red).
- Holds the timeline: for each step, the parts already in place, the parts that move, each move as a start offset, an end offset and a sub-interval of `u`, and the camera.
- Draws each part through one module, `part(name)`, so that the video and the collision check use the same names and the same geometry.
- Draws the housing, the cover and the battery cap see-through in the steps where they hide the parts that move.
- Has a mode that renders one named part, or everything except one named part, at a given `step` and `u`. The collision check uses it.

The camera is fixed within a step. It goes in the timeline as OpenSCAD's `$vpr`, `$vpt` and `$vpd` values.

### `mechanical/cad/tools/assembly_video.py`

- `frames`: renders every frame, 1280 × 720, 24 fps, with one `openscad` process per frame, spread over all cores. Each step renders on its own (`--step N`), so one step can be redone without the others.
- `check`: for each move, takes five poses (`u` = 0, 0.25, 0.5, 0.75, 1 of the move's interval). For each pose, it renders `intersection() { moving part; everything fixed in that step }` to STL and measures its volume. A volume over 0.01 mm³ is a collision. Writes the report and a list of `(step, part, u0, u1)` intervals that collide.
- `video`: renders the colliding intervals again with `red` set, burns in the step caption (step number and the step's first sentence) with ffmpeg `drawtext`, joins the steps, and writes the chapters into the MP4 metadata.
- Python standard library only.

## Sequence

The chapters follow the "Assembly" steps 1–11 of `docs/mechanical-concept.md`, about 4–6 s each, about 60 s in all.

- **Step 1 (inserts) and the epoxy in step 2** are marks: the insert or the area flashes, it does not move.
- **Cables:** cables are flexible and are not animated realistically. A cable shows in its final position as soon as its plug goes in. Before that, it hangs from its board as a short straight stub. Cable collisions are checked only in the final position, as the V0.26 checks already do.
- **Steps 8 and 9:** their order is open in the docs. The video shows the documented order: close the cover, open it, plug in J5, close it again. The `check` step also checks the `battery_first` variant, in which the pouch goes in before the cover closes, and reports both.
- **Knob (step 11):** the knob slides onto the pin; the shim shows as a mark.

## Outputs

- `docs/videos/complete-remote-v0.26-assembly.mp4`, about 5 MB at most.
- `docs/assembly-video-v0.26-checks.md`: the collision report, per step, move and pose, with volumes, for both step 8–9 variants.
- `docs/mechanical-concept.md`: a short "Assembly video" section with a link to the video and the report, and the commands to regenerate them.
- Frames and STLs stay in a git-ignored build directory.

## Testing

- The `check` script finds a known collision: a test move that pushes the XIAO through the button plate must report a volume over 0.01 mm³.
- Every part in the final pose of step 11 matches the `assembly` render of `complete-remote-v0.26.scad`: the difference of the two, in both directions, has zero volume.
- `ffprobe` lists 11 chapters with the expected titles.

## Out of scope

- The base assembly. The V0.24 fitting animation covers the base.
- A voice-over.
- Builder-quality renders.
- Moving the cables realistically.
