#!/usr/bin/env python3
"""Open Rally Remote V0.26 assembly video: frames, collision check and MP4.

Drives mechanical/cad/assembly-video-v0.26.scad with OpenSCAD. Python standard library only.
See docs/superpowers/specs/2026-10-14-assembly-video-design.md.
"""
import json
import os
import struct
import subprocess
import tempfile
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


def run_scad(defs, out, body=None, allow_empty=False, args=()):
    """Render the video file with the variables in defs to out (.stl, .png or .echo).

    body, if given, is OpenSCAD code appended after the include; pass mode "none" with it.
    Returns OpenSCAD's stderr. Raises ScadError on an error, any warning, or an empty
    result unless allow_empty; an empty allowed result leaves an empty file at out.
    """
    out = Path(out)
    out.parent.mkdir(parents=True, exist_ok=True)
    if out.exists():
        out.unlink()
    src = SCAD
    tmp = None
    if body is not None:
        tmp = tempfile.NamedTemporaryFile("w", suffix=".scad", dir=out.parent, delete=False)
        tmp.write("include <%s>\n%s\n" % (SCAD, body))
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
    if p.returncode != 0 or bad:
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
