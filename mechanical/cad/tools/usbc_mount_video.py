#!/usr/bin/env python3
"""V0.34 USB-C board fitting video: the sliding board on square nuts, step by step.

Drives mechanical/cad/usbc-mount-v0.34.scad with OpenSCAD. Each frame has three panels: a
cut-away 3D view through one screw, and two flat sections, on the receptacle axis (the gasket)
and on the screw axis (screw and nut). A caption per step is drawn on the frame, in English
and Spanish.

Run from the repository root:
  python3 mechanical/cad/tools/usbc_mount_video.py [en|es ...]
Output: docs/videos/usbc-mount-v0.34.mp4 (en) and usbc-mount-v0.34.es.mp4 (es). Frames go
to mechanical/cad/build/usbc-mount/. Needs ImageMagick (magick) and ffmpeg.
"""
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import assembly_video as av  # noqa: E402

SCAD = av.CAD / "usbc-mount-v0.34.scad"
WORK = av.BUILD / "usbc-mount"
VIDEOS = av.REPO / "docs" / "videos"
FPS = 24
SECONDS = 40
FRAMES = FPS * SECONDS
FONT = av.FONT

# Phase starts, as in T in the .scad file; a caption per phase.
T = [0.00, 0.06, 0.16, 0.24, 0.40, 0.50, 0.60, 0.68, 0.79, 0.90]
CAPTIONS = {
    "en": [
        "The rib above the USB-C board, cut through one screw; the board goes in upside down. "
        "A channel for a square nut, open toward the front, and a slot for the screw.",
        "1. Slide a DIN 562 M2 square nut into each channel from the front of the rib.",
        "2. Fit the USBTJ-06 gasket over the receptacle's nose, flat against its body.",
        "3. Hold the board upside down, receptacle below, against the rib's underside, and slide "
        "it toward the wall until the nose enters the slot.",
        "4. Start the two M2 x 4 button-head screws by hand from below, through the board into "
        "the nuts. Leave them loose.",
        "5. Push the board toward the wall with a finger until the gasket resists.",
        "6. Hold it there. Pass a driver for the screw heads (1.3 mm hex, about 75 mm long) up "
        "through the battery cap opening, tilted slightly toward the rear.",
        "7. Tighten the first screw: its nut pulls the board against the rib.",
        "8. Move the driver to the second screw and tighten it.",
        "Done. The slots allow 1 mm each way, so the gasket, not the holes, sets where the board "
        "sits. The leak test checks the seal.",
    ],
    "es": [
        "El nervio sobre la placa USB-C, cortado por un tornillo; la placa va boca abajo. Un "
        "canal para una tuerca cuadrada, abierto hacia delante, y una ranura para el tornillo.",
        "1. Mete una tuerca cuadrada M2 DIN 562 en cada canal, desde la parte delantera del nervio.",
        "2. Pon la junta USBTJ-06 en la boca del conector, plana contra el cuerpo.",
        "3. Sujeta la placa boca abajo, con el conector debajo, contra la cara inferior del "
        "nervio, y deslízala hacia la pared hasta que la boca entre en la ranura.",
        "4. Pon a mano, desde abajo, los dos tornillos M2 x 4 de cabeza redonda, a través de la "
        "placa hasta las tuercas. Déjalos flojos.",
        "5. Empuja la placa con el dedo hacia la pared hasta que notes que la junta resiste.",
        "6. Mantenla así. Mete un destornillador para las cabezas (hexagonal de 1,3 mm, de unos "
        "75 mm) por la abertura de la tapa de la batería, un poco inclinado hacia atrás.",
        "7. Aprieta el primer tornillo: su tuerca sube la placa contra el nervio.",
        "8. Pasa el destornillador al segundo tornillo y apriétalo.",
        "Hecho. Las ranuras dan 1 mm a cada lado, así que es la junta, no los taladros, la que "
        "fija la placa. La prueba de estanqueidad comprueba el sellado.",
    ],
}
LABELS = {
    "en": ["Cut through a screw; driver in blue", "Gasket (black)", "Screw, nut (orange) and driver"],
    "es": ["Corte por un tornillo; destornillador en azul", "Junta (negra)", "Tornillo, tuerca (naranja) y destornillador"],
}

# Panels: view, size, camera, extra arguments.
P3D = ("anim3d", (600, 900), "-82,-235,22,-33,-10,4", ["--render"])
PGASKET = ("gasket2d", (600, 450), "-19.8,29.5,0,0,0,0,17", ["--projection=ortho"])
PSCREW = ("screw2d", (600, 450), "-30.5,30.0,0,0,0,0,24", ["--projection=ortho"])
PANELS = (P3D, PGASKET, PSCREW)


def housing_stl():
    out = WORK / "housing-cut.stl"
    av.run_scad({"part_to_render": "none", "view": "housing_cut"}, out, scad=SCAD)
    return out


def render(job):
    i, stl = job
    t = i / (FRAMES - 1)
    for view, size, cam, extra in PANELS:
        out = WORK / view / ("f%04d.png" % i)
        av.run_scad({"part_to_render": "none", "view": view, "housing_stl": str(stl), "anim_t": t},
                    out, args=extra + ["--imgsize=%d,%d" % size, "--colorscheme=Tomorrow",
                                       "--camera=" + cam], scad=SCAD)   # --render takes an optional value
    return i


def ease(t, a, b):
    u = min(1.0, max(0.0, (t - a) / (b - a)))
    return u * u * (3 - 2 * u)


def gasket_mm(i):
    """Gasket thickness at frame i, as gasket_th in the .scad file (0.90 free, 0.53 squeezed)."""
    t = i / (FRAMES - 1)
    back = 22 - 21 * ease(t, T[3], T[4]) - 1.0 * ease(t, T[5], T[6])
    return min(0.90, 0.53 + back)


def phase(i):
    t = i / (FRAMES - 1)
    return sum(1 for x in T[1:] if t >= x)


def compose(job):
    lang, i = job
    d = WORK / lang
    p = [WORK / v / ("f%04d.png" % i) for v, _, _, _ in PANELS]
    lab = list(LABELS[lang])
    g = "%.2f mm" % gasket_mm(i)
    lab[1] += ": " + (g if lang == "en" else g.replace(".", ","))
    cap = WORK / ("caption-%s-%d.txt" % (lang, phase(i)))
    subprocess.run(
        ["magick",
         "(", str(p[0]), "-font", FONT, "-pointsize", "20", "-fill", "black",
         "-gravity", "southwest", "-annotate", "+12+10", lab[0], ")",
         "(", "(", str(p[1]), "-gravity", "northwest", "-font", FONT, "-pointsize", "18",
         "-undercolor", "white", "-annotate", "+10+8", lab[1], ")",
         "(", str(p[2]), "-gravity", "northwest", "-font", FONT, "-pointsize", "18",
         "-undercolor", "white", "-annotate", "+10+8", lab[2], ")", "-append", ")",
         "+append",
         "-gravity", "north", "-background", "white", "-splice", "0x96",
         "(", "-size", "1160x88", "-background", "white", "-fill", "black", "-font", FONT,
         "-pointsize", "24", "caption:@" + str(cap), ")",
         "-gravity", "northwest", "-geometry", "+20+6", "-composite",
         str(d / ("f%04d.png" % i))], check=True)
    return i


def video(lang):
    out = VIDEOS / ("usbc-mount-v0.34%s.mp4" % ("" if lang == "en" else "." + lang))
    subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-framerate", str(FPS),
                    "-i", str(WORK / lang / "f%04d.png"), "-c:v", "libx264", "-crf", "24",
                    "-preset", "slow", "-pix_fmt", "yuv420p", "-movflags", "+faststart",
                    str(out)], check=True)
    return out


def main(langs):
    langs = langs or ["en", "es"]
    for v, _, _, _ in PANELS:
        (WORK / v).mkdir(parents=True, exist_ok=True)
    stl = housing_stl()
    with ThreadPoolExecutor(os.cpu_count()) as ex:
        list(ex.map(render, [(i, stl) for i in range(FRAMES)]))
        for lang in langs:
            (WORK / lang).mkdir(parents=True, exist_ok=True)
            for k, text in enumerate(CAPTIONS[lang]):
                (WORK / ("caption-%s-%d.txt" % (lang, k))).write_text(text)
            list(ex.map(compose, [(lang, i) for i in range(FRAMES)]))
    for lang in langs:
        print(video(lang))


if __name__ == "__main__":
    main(sys.argv[1:])
