#!/usr/bin/env python3
"""OpenSCAD images of the newest remote for docs/mechanical-concept.md: the still views and the
fitting animation. See "Doc images" in docs/mechanical-concept.md.

Run from the repository root:
  python3 mechanical/cad/tools/doc_images.py [name ...]
Output: mechanical/cad/build/doc-images/complete-remote-v<version>-<name>.png and -fit.gif.
Names: the keys of VIEWS, or "fit" for the animation; none renders everything. The GIF needs
ImageMagick (magick).
"""
import os
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import assembly_video as av  # noqa: E402

MAIN = av.CAD / ("complete-remote-v%s.scad" % av.VERSION)
EXTRA = av.CAD / ("doc-views-v%s.scad" % av.VERSION)
OUT = av.BUILD / "doc-images"

# A full render draws no % (background) parts and no colour on 2D cuts: the EXTRA views add a
# solid bar, and the 2D cuts render as previews.
PREVIEW = {"dovetail", "seal-section"}

# name: (file, view, camera, size). A camera of three values is a rotation "rx,ry,rz" framed
# with --viewall; six are "eye,centre"; seven are "translate,rotate,distance".
VIEWS = {
    "assembly":        (EXTRA, "assembly", "62,0,245", (1400, 1050)),
    "front":           (EXTRA, "assembly", "90,0,270", (1200, 800)),
    "side":            (MAIN, "assembly", "0,0,0", (1200, 900)),
    "joy":             (EXTRA, "assembly", "-150,-75,60,-53,-26,12.5", (1200, 900)),
    "rear":            (EXTRA, "assembly", "70,0,60", (1200, 900)),
    "entry":           (EXTRA, "entry", "70,0,60", (1200, 900)),
    "base":            (EXTRA, "base", "65,0,250", (1200, 900)),
    "base-sleeve":     (MAIN, "base", "65,0,60", (1200, 900)),
    "back":            (EXTRA, "back", "70,0,100", (1200, 700)),
    "dovetail":        (MAIN, "dovetail_section", "0,0,0", (1200, 900)),
    "interior":        (MAIN, "interior", "0,0,0", (1400, 1200)),
    "section":         (MAIN, "section", "0,0,0", (1400, 1200)),
    "seal-section":    (EXTRA, "seal_section", "-44,12.5,0,0,0,0,105", (1200, 900)),
    "foam":            (EXTRA, "foam", "60,0,240", (1400, 1000)),
    "battery-cap":     (EXTRA, "battery_cap", "59,0,335", (1200, 1100)),
    "cap-seal":        (EXTRA, "cap_seal", "20,40,80,-26,-40,12.5", (1200, 900)),
    "joy-section":     (EXTRA, "joy_section", "0,0,0", (1200, 900)),
    "print-cover":     (MAIN, "print_cover", "55,0,25", (1200, 900)),
    "gasket-flat":     (MAIN, "print_gasket", "0,0,0", (700, 1200)),
    "print-joy":       (EXTRA, "print_joy", "55,0,25", (1200, 800)),
    "print-joy-plate": (MAIN, "print_joy_plate", "55,0,25", (1200, 900)),
    "print-knobs":     (EXTRA, "print_knobs", "55,0,25", (1200, 900)),
    "print-sleeve":    (MAIN, "print_sleeve", "55,0,25", (1200, 900)),
}

# Fitting animation: two panels side by side, the 3D view and the mid-width cut.
FIT_FRAMES = 72
FIT_DELAY = 8                # GIF frame delay, 1/100 s
FIT_PANELS = (("anim", "-35,-8,12.5,70,0,60,420"), ("anim_section", "-42,-4,0,0,0,0,360"))
FIT_SIZE = (550, 440)


def image(name, ext="png"):
    return OUT / ("complete-remote-v%s-%s.%s" % (av.VERSION, name, ext))


def still(name):
    f, view, cam, size = VIEWS[name]
    args = ["openscad", "-q"]
    if name not in PREVIEW:
        args.append("--render")   # before -o: --render takes an optional value
    args += ["-o", str(image(name)), "--imgsize=%d,%d" % size, "--colorscheme=Tomorrow"]
    if f == EXTRA:
        args += ["-D", 'part_to_render="none"', "-D", 'view="%s"' % view]
    else:
        args += ["-D", 'part_to_render="%s"' % view]
    if cam.count(",") == 2:
        args += ["--viewall", "--autocenter", "--camera=0,0,0,%s,300" % cam]
    else:
        args.append("--camera=" + cam)
    r = subprocess.run(args + [str(f)], capture_output=True, text=True)
    if r.returncode:
        sys.exit("%s: openscad failed\n%s" % (name, r.stderr[-2000:]))
    return name


def fit():
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        for part, cam in FIT_PANELS:
            (tmp / part).mkdir()
            subprocess.run(["openscad", "-q", "-o", "f.png", "--animate", str(FIT_FRAMES),
                            "--imgsize=%d,%d" % FIT_SIZE, "--colorscheme=Tomorrow",
                            "--camera=" + cam, "-D", 'part_to_render="%s"' % part, str(MAIN)],
                           cwd=tmp / part, check=True)
        (tmp / "both").mkdir()
        for i in range(FIT_FRAMES):
            f = "f%05d.png" % i
            subprocess.run(["magick"] + [str(tmp / p / f) for p, _ in FIT_PANELS] +
                           ["+append", str(tmp / "both" / f)], check=True)
        subprocess.run(["magick", "-delay", str(FIT_DELAY), "-loop", "0"] +
                       sorted(str(p) for p in (tmp / "both").glob("f*.png")) +
                       ["-layers", "Optimize", "-colors", "128", str(image("fit", "gif"))],
                       check=True)
    return "fit"


def main(names):
    OUT.mkdir(parents=True, exist_ok=True)
    names = names or list(VIEWS) + ["fit"]
    bad = [n for n in names if n not in VIEWS and n != "fit"]
    if bad:
        sys.exit("unknown view: %s" % ", ".join(bad))
    with ThreadPoolExecutor(os.cpu_count()) as ex:
        for name in ex.map(lambda n: fit() if n == "fit" else still(n), names):
            print(name)


if __name__ == "__main__":
    main(sys.argv[1:])
