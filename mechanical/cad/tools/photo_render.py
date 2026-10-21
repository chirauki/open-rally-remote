#!/usr/bin/env python3
"""Photo-like renders of the newest remote: exports the visible parts to STL with OpenSCAD and
renders a front and a side view with Blender (photo_scene.py). See "Photo renders" in
docs/mechanical-concept.md.

Run from the repository root:
  python3 mechanical/cad/tools/photo_render.py [samples]
Output: mechanical/cad/build/photo/front.png and side.png. BLENDER overrides the Blender binary.
"""
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import assembly_video as av  # noqa: E402

SCAD = av.CAD / ("complete-remote-v%s.scad" % av.VERSION)
OUT = av.BUILD / "photo"
BLENDER = os.environ.get("BLENDER", "blender")

# M2 countersunk head with a hex socket, flush with the cover face.
HEAD = ("difference() { translate([0,0,0.05]) cylinder(d1=3.8,d2=2.0,h=0.9,$fn=32); "
        "translate([0,0,-0.1]) cylinder(d=1.6,h=0.9,$fn=6); }")
PARTS = {
    "housing": "housing();", "cover": "face_cover();", "keypad": "gasket();", "knob": "knob();",
    "stick": "stick();", "battery_cap": "battery_cap();", "base_front": "base_front();",
    "base_cap": "base_cap();", "bolts": "clamp_bolts();", "lock": "lock_parts(lock_out);",
    "strips": "strips();", "liners": "liner_half(false); liner_half(true);",
    "sleeves": "sleeve_half(false); sleeve_half(true);",
    "screws": "at_cover_screws() %s for (s=cap_screws) translate([s[0],pod_bottom_y,s[1]]) "
              "rotate([-90,0,0]) %s" % (HEAD, HEAD),
}


def export(name):
    av.run_scad({"part_to_render": "none"}, OUT / "stl" / (name + ".stl"), body=PARTS[name],
                allow_empty=True, scad=SCAD, args=("--export-format", "binstl"))


def main():
    samples = sys.argv[1] if len(sys.argv) > 1 else "256"
    (OUT / "stl").mkdir(parents=True, exist_ok=True)
    with ThreadPoolExecutor(8) as ex:
        list(ex.map(export, PARTS))
    scene = Path(__file__).with_name("photo_scene.py")
    subprocess.run([BLENDER, "-b", "-P", str(scene), "--", str(OUT / "stl"), str(OUT), samples],
                   check=True, stdout=subprocess.DEVNULL)
    print(OUT / "front.png", OUT / "side.png")


if __name__ == "__main__":
    main()
