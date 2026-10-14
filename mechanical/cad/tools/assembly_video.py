#!/usr/bin/env python3
"""Open Rally Remote V0.26 assembly video: frames, collision check and MP4.

Drives mechanical/cad/assembly-video-v0.26.scad with OpenSCAD. Python standard library only.
See docs/superpowers/specs/2026-10-14-assembly-video-design.md.
"""
import json
import math
import re
import os
import struct
import subprocess
import tempfile
import textwrap
import uuid
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

CAD = Path(__file__).resolve().parent.parent
REPO = CAD.parent.parent
SCAD = CAD / "assembly-video-v0.26.scad"
BUILD = CAD / "build"
OPENSCAD = os.environ.get("OPENSCAD", "openscad")

PARTS = ["housing", "cover", "keypad", "joy_plate", "button_plate", "stick", "knob",
         "battery_cap", "cap_gasket", "control_board", "xiao", "xiao_foam", "joy_board",
         "usbc_board", "pouch", "cable_joy", "cable_usb", "cable_bat", "vent_label"]


class ScadError(RuntimeError):
    """OpenSCAD failed, warned, or rendered nothing."""


def run_scad(defs, out, body=None, allow_empty=False, args=(), scad=None):
    """Render the video file with the variables in defs to out (.stl, .png or .echo).

    body, if given, is OpenSCAD code appended after the include; pass mode "none" with it.
    scad replaces the video file. Returns OpenSCAD's stderr. Raises ScadError on an error,
    any warning, or an empty result unless allow_empty, and then leaves no file at out; an
    empty allowed result leaves an empty file at out.
    """
    scad = Path(scad or SCAD)
    out = Path(out)
    out.parent.mkdir(parents=True, exist_ok=True)
    if out.exists():
        out.unlink()
    src = scad
    tmp = None
    if body is not None:
        tmp = tempfile.NamedTemporaryFile("w", suffix=".scad", dir=out.parent, delete=False)
        tmp.write("include <%s>\n%s\n" % (scad, body))
        tmp.close()
        src = Path(tmp.name)
    cmd = [OPENSCAD, "-o", str(out)]
    for k, v in defs.items():
        cmd += ["-D", "%s=%s" % (k, json.dumps(v))]
    cmd += list(args) + [str(src)]
    try:
        p = subprocess.run(cmd, capture_output=True, text=True)
    finally:
        if tmp:
            os.unlink(tmp.name)
    err = p.stderr
    bad = [l for l in err.splitlines() if l.startswith(("WARNING:", "ERROR:"))]
    empty = "top level object is empty" in err.lower() or not out.exists()
    # OpenSCAD exits with 1 when the result is empty.
    if (p.returncode != 0 and not empty) or bad:
        out.unlink(missing_ok=True)
        raise ScadError("%s\n%s" % (" ".join(cmd), "\n".join(bad) or err[-2000:]))
    if empty:
        if not allow_empty:
            raise ScadError("empty render: %s" % " ".join(cmd))
        out.write_bytes(b"")
    return err


def _triangles(path):
    data = Path(path).read_bytes()
    if not data:
        return
    if data[:5] == b"solid" and b"facet" in data[:400]:
        v = []
        for line in data.decode().splitlines():
            s = line.split()
            if s and s[0] == "vertex":
                v.append(tuple(float(x) for x in s[1:4]))
                if len(v) == 3:
                    yield v
                    v = []
        return
    n = struct.unpack_from("<I", data, 80)[0]
    for i in range(n):
        f = struct.unpack_from("<12f", data, 84 + 50 * i)
        yield [f[3:6], f[6:9], f[9:12]]


def stl_volume(path):
    """Enclosed volume of a closed STL, in mm^3 (0 for an empty file)."""
    vol = 0.0
    for a, b, c in _triangles(path):
        vol += (a[0] * (b[1] * c[2] - b[2] * c[1])
                - a[1] * (b[0] * c[2] - b[2] * c[0])
                + a[2] * (b[0] * c[1] - b[1] * c[0]))
    return abs(vol) / 6.0


def png_args(camera, size=(1280, 720)):
    """OpenSCAD arguments for one video frame seen from camera (the --camera vector)."""
    return ["--render", "--camera=" + ",".join("%g" % c for c in camera),
            "--imgsize=%d,%d" % size, "--projection=p", "--colorscheme=Tomorrow"]


def step_info(step, variant):
    """The timeline data of one step: duration (s), camera, parts placed by its end, parts
    that move in it."""
    out = BUILD / "info" / ("%s_%02d.echo" % (variant, step))
    run_scad({"mode": "info", "step": step, "variant": variant}, out)
    for line in out.read_text().splitlines():
        if line.startswith("ECHO: info = "):
            s, duration, camera, placed, moving, moves = json.loads(line[len("ECHO: info = "):])
            return {"duration": duration, "camera": camera, "placed": placed, "moving": moving,
                    "moves": moves}
    raise ScadError("no info echo for step %d" % step)


# --- Collision check ------------------------------------------------------------------

TOL = 0.01          # mm^3; a larger overlap is a collision
POSES = (0, 0.25, 0.5, 0.75, 1)
CABLES = {"cable_joy", "cable_usb", "cable_bat"}
VARIANTS = ("documented", "battery_first")
NSTEPS = 11

# Pairs that overlap in the final assembly by design, with the reason. Their final
# overlap is measured and printed in the report; they are not collisions.
ALLOWED_CONTACT = {
    frozenset(("keypad", "stick")): "the sheet hole (Ø2.4) is stretched over the stick pin",
    frozenset(("xiao_foam", "pouch")): "the foam pad fills the pouch envelope's 0.5 mm "
                                       "clearance and presses on the cell",
    frozenset(("control_board", "cable_bat")): "the PH plug sits in J5",
    frozenset(("control_board", "cable_joy")): "the SH plug sits in J4",
    frozenset(("control_board", "cable_usb")): "the SH plug sits in J3",
    frozenset(("joy_board", "cable_joy")): "the SH plug sits in J1",
    frozenset(("pouch", "cable_bat")): "the lead leaves the pouch's protection board",
    frozenset(("cable_usb", "cable_bat")): "flexible cables, modelled as fixed tubes, cross",
}


# Findings from the check and from one-off sweeps run on 2026-10-14 with this tool's
# run_scad and stl_volume. Written into the report as they are.
FINDINGS = [
    "**Housing onto the stack (step 8), and the cover off (step 9).** The lower-facet "
    "cover-screw bosses (Ø6, axis along the facet normal, 20° from X) pass through R3.3 "
    "notches in the joystick board: 0.3 mm clearance. Moving the housing straight along X, "
    "the bosses hit the board from about 10 mm before the housing seats (19.4 mm³ at "
    "6.6 mm). Straight paths from -5° to 25° from X, in 5° steps (the facet normal is at "
    "20°), all collided (largest overlap 6.4-22.6 mm³ in the last 12 mm). Fitting the "
    "joystick group to the housing first, along its axis, and then closing the housing and "
    "the group onto the cover along X does not clear either: the stick pin then crosses the "
    "cover hole sideways (2.7 mm³ at 6 mm) and drags the sheet. The V0.26 check \"lifted "
    "out with the cover\" did not include the joystick board. Not solved; see "
    "\"Open unknowns\" in docs/mechanical-concept.md.",
    "**Vent label.** The Ø10 mm label envelope at X = -41 runs 3.2 mm into the lower-facet "
    "stack at the bottom wall: cover 1.2 mm³, joystick plate 2.0 mm³, keypad 1.3 mm³.",
    "**Joystick board J1 against the housing.** 0.015 mm³ (about 0.1 mm deep) at X = -35.5, "
    "Y = -31.2. Within the accuracy of the socket envelope (2.9 mm tall, assumed).",
    "**USB-C board path (step 2).** Slid straight along its rib from the cavity opening, "
    "the board's edges hit the upper cover-screw bosses at Y = 24 (19 mm³). Carried 1.5 mm "
    "above the rib past the bosses, lowered onto the rib 8 mm short of the rear wall, and "
    "slid in, it clears. The margin is small: 1 mm above the rib still overlaps 0.2 mm³. "
    "The video uses this path.",
]


def _volume(variant, body, tag):
    out = BUILD / "check" / variant / (tag + ".stl")
    run_scad({"mode": "none", "variant": variant}, out, body=body, allow_empty=True)
    return stl_volume(out)


def _pair_volume(variant, a, b, s, u):
    tag = "s%02d_%s_%s_%.3f" % (s, a, b, u)
    return _volume(variant, 'intersection() { part_at("%s", %d, %g); part_at("%s", %d, %g); }'
                   % (a, s, u, b, s, u), tag)


def _visible(variant, s, u):
    return [n for n in PARTS if n in _placed_at(variant, s, u)]


def _placed_at(variant, s, u):
    # unique name: several threads ask for the same pose
    out = BUILD / "check" / variant / ("vis_s%02d_%.3f_%s.echo" % (s, u, uuid.uuid4().hex))
    run_scad({"mode": "none", "variant": variant}, out,
             body='echo(vis=[for (n=PARTS) if (part_state(n, %d, %g)[0]) n]); cube(0.01);' % (s, u))
    try:
        for line in out.read_text().splitlines():
            if line.startswith("ECHO: vis = "):
                return json.loads(line[len("ECHO: vis = "):])
        raise ScadError("no visibility echo")
    finally:
        out.unlink(missing_ok=True)


def _pose_hits(job):
    variant, s, u, name, group = job
    others = [n for n in _visible(variant, s, u)
              if n != name and n not in group and n not in CABLES
              and frozenset((name, n)) not in ALLOWED_CONTACT]
    if not others:
        return []
    union = " ".join('part_at("%s", %d, %g);' % (n, s, u) for n in others)
    total = _volume(variant, 'intersection() { part_at("%s", %d, %g); union() { %s } }'
                    % (name, s, u, union), "s%02d_%s_all_%.3f" % (s, name, u))
    if total <= TOL:
        return []
    hits = []
    for n in others:
        v = _pair_volume(variant, name, n, s, u)
        if v > TOL:
            hits.append((s, name, round(u, 4), n, round(v, 3)))
    return hits


def _final_hits(job):
    variant, a, b = job
    v = _pair_volume(variant, a, b, NSTEPS, 1)
    return (NSTEPS, a, 1, b, round(v, 3)) if v > TOL else None


def check_jobs(variant, steps=None):
    """The poses to check, as (variant, step, u, part, parts moving with it), one per
    (step, part, u): two moves that meet at the same u share a pose, and two threads must
    not write the same STL."""
    jobs = {}
    for s in steps or range(1, NSTEPS + 1):
        for names, u0, u1 in step_info(s, variant)["moves"]:
            for k in POSES:
                for n in names:
                    u = u0 + k * (u1 - u0)
                    jobs.setdefault((s, n, round(u, 6)), (variant, s, u, n, tuple(names)))
    return list(jobs.values())


def check(variant, steps=None):
    """Collisions of the moving parts at POSES of each move, and of every pair of parts in
    the final pose (cables included). Returns hits (step, name, u, other, volume_mm3).
    Parts that move together in one move are not checked against each other: they keep
    their final relative position. Allowed contacts are skipped."""
    jobs = check_jobs(variant, steps)
    with ThreadPoolExecutor(os.cpu_count()) as ex:
        hits = [h for hs in ex.map(_pose_hits, jobs) for h in hs]
        if steps is None:
            pairs = [(variant, a, b) for i, a in enumerate(PARTS) for b in PARTS[i + 1:]
                     if frozenset((a, b)) not in ALLOWED_CONTACT]
            hits += [h for h in ex.map(_final_hits, pairs) if h]
    return hits


def collision_intervals(variant, hits):
    """Colliding u intervals per (step, part), widened to the neighbouring poses."""
    out = []
    for s in sorted({h[0] for h in hits}):
        info = step_info(s, variant)
        for names, u0, u1 in info["moves"]:
            for n in names:
                us = sorted({h[2] for h in hits if h[0] == s and n in (h[1], h[3])
                             and u0 - 1e-6 <= h[2] <= u1 + 1e-6})
                d = (u1 - u0) / (len(POSES) - 1)
                for u in us:
                    out.append([s, n, max(u0, u - d), min(u1, u + d)])
    return out


def allowed_volumes():
    with ThreadPoolExecutor(os.cpu_count()) as ex:
        vols = list(ex.map(lambda p: _pair_volume("documented", *sorted(p), NSTEPS, 1),
                           ALLOWED_CONTACT))
    return dict(zip(ALLOWED_CONTACT, vols))


def write_report(results, path, allowed=None):
    """Write the collision report for {variant: hits} to path (Markdown)."""
    allowed = allowed if allowed is not None else {p: None for p in ALLOWED_CONTACT}
    L = ["# V0.26 Assembly Path Check", "",
         "Generated by `mechanical/cad/tools/assembly_video.py check` from "
         "`mechanical/cad/assembly-video-v0.26.scad`. Do not edit by hand.", "",
         "Each move of the assembly timeline is checked at u = %s of its interval: the "
         "moving part against every other part in place, cables excepted. The final pose "
         "is checked for every pair of parts, cables included. An overlap over %g mm³ is "
         "a collision. Parts that move together are not checked against each other."
         % (", ".join("%g" % p for p in POSES), TOL), "",
         "## Findings", ""] + ["- " + f for f in FINDINGS] + ["", "## Contacts by design", ""]
    if allowed:
        L += ["| Pair | Final overlap (mm³) | Reason |", "|---|---|---|"]
        for pair, v in sorted(allowed.items(), key=lambda kv: sorted(kv[0])):
            a, b = sorted(pair)
            L.append("| %s / %s | %s | %s |" % (a, b, "—" if v is None else "%.3f" % v,
                                                ALLOWED_CONTACT[pair]))
    else:
        L.append("None.")
    for variant, hits in results.items():
        L += ["", "## Variant: %s" % variant, ""]
        if not hits:
            L.append("No collisions.")
            continue
        L += ["| Step | Moving part | u | Against | Overlap (mm³) |", "|---|---|---|---|---|"]
        for h in sorted(hits):
            L.append("| %d | %s | %g | %s | %.3f |" % h)
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    Path(path).write_text("\n".join(L) + "\n")


# --- Frames and video -----------------------------------------------------------------

FPS = 24
SIZE = (1280, 720)
VIDEO = REPO / "docs" / "videos" / "complete-remote-v0.26-assembly.mp4"
DOC = REPO / "docs" / "mechanical-concept.md"
FONT = "/System/Library/Fonts/Helvetica.ttc"


def frame_count(duration):
    return int(math.ceil(duration * FPS))


def step_titles(doc):
    """First sentence of each numbered remote assembly step in docs/mechanical-concept.md.
    Raises ValueError unless there are NSTEPS of them."""
    lines = Path(doc).read_text().splitlines()
    try:
        i = lines.index("## Assembly")
        i = next(k for k in range(i, len(lines)) if lines[k].startswith("Remote (V0.26"))
    except (ValueError, StopIteration):
        raise ValueError("no V0.26 remote assembly list in %s" % doc)
    titles = []
    for line in lines[i + 1:]:
        m = re.match(r"(\d+)\. (.*)", line)
        if m:
            if int(m.group(1)) != len(titles) + 1:
                break
            titles.append(re.split(r"(?<=[.!?])\s", m.group(2), maxsplit=1)[0].rstrip("."))
        elif titles and line.strip() == "":
            break
    if len(titles) != NSTEPS:
        raise ValueError("%d assembly steps in %s, expected %d" % (len(titles), doc, NSTEPS))
    return titles


def _red_at(coll, s, u):
    return sorted({n for cs, n, u0, u1 in coll if cs == s and u0 - 1e-6 <= u <= u1 + 1e-6})


def frames(steps=None, variant="documented", scad=None, out_dir=None):
    """Render the frames of the steps to out_dir/sNN/fNNNN.png, on all cores. Parts in a
    colliding interval of build/collisions.json are red. Stops at the first ScadError."""
    out_dir = Path(out_dir or BUILD / "frames")
    cj = BUILD / "collisions.json"
    coll = json.loads(cj.read_text()).get(variant, []) if cj.exists() else []
    jobs = []
    for s in steps or range(1, NSTEPS + 1):
        info = step_info(s, variant)
        n = frame_count(info["duration"])
        d = out_dir / ("s%02d" % s)
        if d.exists():
            for f in d.glob("*.png"):
                f.unlink()
        for i in range(n):
            u = i / (n - 1)
            jobs.append(({"mode": "pose", "step": s, "u": u, "variant": variant,
                          "red": _red_at(coll, s, u)}, d / ("f%04d.png" % i), info["camera"]))
    ex = ThreadPoolExecutor(os.cpu_count())
    try:
        futs = [ex.submit(run_scad, defs, out, None, False, png_args(cam, SIZE), scad)
                for defs, out, cam in jobs]
        for f in futs:
            f.result()
    finally:
        ex.shutdown(wait=True, cancel_futures=True)


def video(variant="documented", frames_dir=None, out=None):
    """Join the frames into the chaptered MP4, with each step's caption burned in."""
    frames_dir = Path(frames_dir or BUILD / "frames")
    out = Path(out or VIDEO)
    work = BUILD / "video"
    work.mkdir(parents=True, exist_ok=True)
    titles = step_titles(DOC)
    segs, meta, t = [], [";FFMETADATA1"], 0
    for s in range(1, NSTEPS + 1):
        n = len(list((frames_dir / ("s%02d" % s)).glob("f*.png")))
        if n != frame_count(step_info(s, variant)["duration"]):
            raise ScadError("step %d: %d frames, expected %d; run frames first" % (
                s, n, frame_count(step_info(s, variant)["duration"])))
        cap = work / ("caption%02d.txt" % s)
        cap.write_text("\n".join(["Step %d" % s] + textwrap.wrap(titles[s - 1], 80)))
        seg = work / ("s%02d.mp4" % s)
        draw = ("drawtext=fontfile=%s:textfile=%s:x=24:y=20:fontsize=24:fontcolor=black:"
                "line_spacing=6:box=1:boxcolor=white@0.8:boxborderw=8" % (FONT, cap))
        subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-framerate", str(FPS),
                        "-i", str(frames_dir / ("s%02d" % s) / "f%04d.png"), "-vf", draw,
                        "-c:v", "libx264", "-crf", "23", "-preset", "slow",
                        "-pix_fmt", "yuv420p", str(seg)], check=True)
        segs.append(seg)
        ms = int(round(1000 * n / FPS))
        meta += ["[CHAPTER]", "TIMEBASE=1/1000", "START=%d" % t, "END=%d" % (t + ms),
                 "title=Step %d: %s" % (s, titles[s - 1].replace("=", "\\=")
                                        .replace(";", "\\;").replace("#", "\\#"))]
        t += ms
    lst = work / "list.txt"
    lst.write_text("".join("file '%s'\n" % p for p in segs))
    (work / "chapters.txt").write_text("\n".join(meta) + "\n")
    out.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-f", "concat", "-safe", "0",
                    "-i", str(lst), "-i", str(work / "chapters.txt"), "-map", "0",
                    "-map_metadata", "1", "-map_chapters", "1", "-c", "copy",
                    "-movflags", "+faststart", str(out)], check=True)
    return out


def main(argv=None):
    import argparse
    ap = argparse.ArgumentParser(description=__doc__)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("check", help="check the assembly paths; write the report")
    fp = sub.add_parser("frames", help="render the video frames")
    fp.add_argument("--step", type=int, action="append", help="only this step (repeatable)")
    sub.add_parser("video", help="build the MP4 from the frames")
    a = ap.parse_args(argv)
    if a.cmd == "frames":
        frames(a.step)
    elif a.cmd == "video":
        print(video())
    if a.cmd == "check":
        results = {v: check(v) for v in VARIANTS}
        write_report(results, REPO / "docs" / "assembly-video-v0.26-checks.md", allowed_volumes())
        coll = {v: collision_intervals(v, h) for v, h in results.items()}
        (BUILD / "collisions.json").write_text(json.dumps(coll, indent=1))
        for v, h in results.items():
            print("%s: %d hits" % (v, len(h)))


if __name__ == "__main__":
    main()
