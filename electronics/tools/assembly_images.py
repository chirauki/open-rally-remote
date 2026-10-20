"""Draw the step-by-step images for docs/electronics-assembly.md.

Run with KiCad's bundled Python (it needs pcbnew) from the repository root:

    /Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3 \
        electronics/tools/assembly_images.py

For each step it exports the board side from KiCad as an SVG (outline, silkscreen and the
exposed pads), draws the parts of that step over it in orange with their reference and value,
the parts of earlier steps in grey, and a red dot on pin 1 of every polarised part. The back
side is drawn mirrored, as seen when the board is turned over. rsvg-convert turns the SVG into
a PNG in docs/images/. It also writes 3D renders of each finished side with kicad-cli.
"""

import os
import re
import subprocess
import sys
import tempfile

import pcbnew

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
OUT = os.path.join(ROOT, "docs", "images")
KICAD_CLI = "/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli"
PX_PER_MM = 40
MARGIN = 1.5          # mm round the board
TITLE_H = 3.2         # mm band above the board for the title
VERSION = "v0.32"     # the remote version these boards belong to

BOARDS = {
    "control": ("electronics/control-pcb/control.kicad_pcb", "control-pcb", "Control board"),
    "joystick": ("electronics/joystick-pcb-rev-c/joystick.kicad_pcb", "joystick-pcb-rev-c",
                 "Joystick board rev C"),
    "usbc": ("electronics/usbc-pcb-rev-b/usbc.kicad_pcb", "usbc-pcb-rev-b", "USB-C board rev B"),
}

# Short part names for the labels; resistors and capacitors show their value.
LABEL = {
    ("control", "U1"): "MCP73831", ("control", "U2"): "TPS70933", ("control", "Q1"): "AO3401A",
    ("control", "D1"): "SMBJ5.0A", ("control", "F1"): "PTC fuse", ("control", "J1"): "XIAO D0-D6",
    ("control", "J2"): "XIAO 5V-D7", ("control", "J3"): "3-pin", ("control", "J4"): "5-pin",
    ("control", "J5"): "battery", ("joystick", "J1"): "5-pin", ("usbc", "J1"): "USB4736",
    ("usbc", "J2"): "3-pin", ("usbc", "D1"): "",
}

# (board, side, image suffix, title, parts of this step). Earlier steps on the same board and
# side are drawn in grey. "back" is B.Cu, seen from that side (mirrored); "front"/"top" is F.Cu.
STEPS = [
    ("joystick", "front", "asm-j1-switches", "Joystick board, front: step J1, switches",
     ["SW1", "SW2", "SW3", "SW4"]),
    ("joystick", "back", "asm-j2-socket", "Joystick board, back: step J2, socket",
     ["J1"]),
    ("control", "back", "asm-c1-ics", "Control board, back: step C1, U1, U2, Q1",
     ["U1", "U2", "Q1"]),
    ("control", "back", "asm-c2-resistors", "Control board, back: step C2, resistors",
     ["R1", "R2", "R3", "R4", "R5", "R6", "R7"]),
    ("control", "back", "asm-c3-capacitors", "Control board, back: step C3, capacitors",
     ["C1", "C2", "C3", "C4", "C5"]),
    ("control", "back", "asm-c4-fuse-tvs", "Control board, back: step C4, F1 and D1",
     ["F1", "D1"]),
    ("control", "front", "asm-c5-switches", "Control board, front: step C5, switches",
     ["SW1", "SW2", "SW3"]),
    ("control", "back", "asm-c6-sockets", "Control board, back: step C6, sockets",
     ["J3", "J4", "J5"]),
    ("control", "back", "asm-c7-headers", "Control board, back: step C7, XIAO headers",
     ["J1", "J2"]),
    ("usbc", "top", "asm-u1-resistors", "USB-C board, top: step U1, resistors",
     ["R1", "R2", "R3"]),
    ("usbc", "top", "asm-u2-socket", "USB-C board, top: step U2, socket",
     ["J2"]),
    ("usbc", "top", "asm-u3-receptacle", "USB-C board, top: step U3, receptacle",
     ["J1"]),
    ("usbc", "top", "asm-u4-led", "USB-C board, top: step U4, charge LED",
     ["D1"]),
]

POLARISED = ("U", "Q", "D", "J")


def mm(v):
    return pcbnew.ToMM(v)


def board_data(key):
    path = os.path.join(ROOT, BOARDS[key][0])
    board = pcbnew.LoadBoard(path)
    parts = {}
    for fp in board.GetFootprints():
        ref = fp.GetReference()
        if ref.startswith("H"):
            continue
        box = fp.GetBoundingBox(False)
        pad1 = None
        for pad in fp.Pads():
            if pad.GetNumber() in ("1", "A5"):
                p = pad.GetPosition()
                pad1 = (mm(p.x), mm(p.y))
                break
        parts[ref] = {
            "side": "back" if fp.GetLayer() == pcbnew.B_Cu else "front",
            "box": (mm(box.GetX()), mm(box.GetY()), mm(box.GetWidth()), mm(box.GetHeight())),
            "value": fp.GetValue(),
            "pad1": pad1,
            "pos": (mm(fp.GetPosition().x), mm(fp.GetPosition().y)),
            "angle": fp.GetOrientationDegrees(),
        }
    edges = board.GetBoardEdgesBoundingBox()
    return path, parts, (mm(edges.GetX()), mm(edges.GetY()), mm(edges.GetWidth()),
                         mm(edges.GetHeight()))


def export_base(path, side, tmp):
    """KiCad SVG of one side: outline, silkscreen and pads, in black and white."""
    layer = "B" if side == "back" else "F"
    out = os.path.join(tmp, f"base-{os.path.basename(path)}-{side}.svg")
    cmd = [KICAD_CLI, "pcb", "export", "svg", "--mode-single", "--black-and-white",
           "--layers", f"Edge.Cuts,{layer}.SilkS,{layer}.Mask", "--page-size-mode", "2",
           "--exclude-drawing-sheet", "-o", out, path]
    if side == "back":
        cmd.insert(5, "--mirror")
    subprocess.run(cmd, check=True, capture_output=True)
    with open(out) as f:
        svg = f.read()
    w, h = (float(v) for v in re.search(r'viewBox="0\.0000 0\.0000 ([\d.]+) ([\d.]+)"', svg).groups())
    body = svg[svg.index("<g "):svg.rindex("</svg>")]
    return body, w, h


class Frame:
    """Board millimetres to drawing millimetres (mirrored for the back)."""

    def __init__(self, edges, w, h, side):
        ex, ey, ew, eh = edges
        self.left = ex + (ew - w) / 2
        self.top = ey + (eh - h) / 2
        self.w, self.h, self.mirror = w, h, side == "back"

    def x(self, bx):
        return (self.left + self.w - bx if self.mirror else bx - self.left) + MARGIN

    def y(self, by):
        return by - self.top + MARGIN + TITLE_H

    def box(self, b):
        bx, by, bw, bh = b
        x0, x1 = sorted((self.x(bx), self.x(bx + bw)))
        return x0, self.y(by), x1 - x0, bh


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def label_for(key, ref, part):
    name = LABEL.get((key, ref))
    if name is None:
        name = part["value"] if ref[0] in "RC" else ""
    return f"{ref} {name}".strip()


def text(x, y, s, size, rotate=False, color="#000", weight="bold"):
    t = f'translate({x:.3f} {y:.3f})' + (" rotate(-90)" if rotate else "")
    return (f'<text transform="{t}" font-family="Helvetica, Arial, sans-serif" '
            f'font-size="{size:.3f}" font-weight="{weight}" fill="{color}" '
            f'text-anchor="middle" dominant-baseline="central" paint-order="stroke" '
            f'stroke="#fff" stroke-width="{size * 0.18:.3f}" stroke-opacity="0.8">{esc(s)}</text>')


def part_box(fr, key, ref, part, style):
    x, y, w, h = fr.box(part["box"])
    fill, stroke, tcol, op = {
        "now": ("#ff8c1a", "#b35900", "#000", 0.55),
        "done": ("#9aa5a0", "#6b7570", "#2b2f2d", 0.45),
        "ghost": ("#9aa5a0", "#6b7570", "#2b2f2d", 0.35),
        "map": ("#7fc8f8", "#1f6fa8", "#000", 0.45),
    }[style]
    out = [f'<rect x="{x:.3f}" y="{y:.3f}" width="{w:.3f}" height="{h:.3f}" rx="0.25" '
           f'fill="{fill}" fill-opacity="{op}" stroke="{stroke}" stroke-width="0.12"/>']
    if style == "ghost":
        return out
    rotate = h > 1.3 * w
    s = label_for(key, ref, part) if style != "done" else ref
    long_side, short_side = (h, w) if rotate else (w, h)
    size = min(short_side * 0.45, long_side / max(len(s), 1) * 1.6, 1.3)
    size = max(size, 0.5)
    tx, ty = x + w / 2, y + h / 2
    marked = (style != "done" and ref.startswith(POLARISED) and part["pad1"]
              and (key, ref) != ("control", "D1"))     # D1 gets a drawn band instead
    if marked:
        px, py = fr.x(part["pad1"][0]), fr.y(part["pad1"][1])
        if min(w, h) < 2.0:             # small part: move the label off the pin-1 dot
            tx, ty = tx + (tx - px) * 0.5, ty + (ty - py) * 0.5
    out.append(text(tx, ty, s, size, rotate, tcol))
    if marked:
        out.append(f'<circle cx="{px:.3f}" cy="{py:.3f}" r="0.32" fill="#e00000" '
                   f'stroke="#fff" stroke-width="0.08"/>')
    return out


def extras(fr, key, refs, parts):
    """Notes drawn on particular steps: diode band, LED lens, XIAO outline."""
    out = []
    if key == "control" and "D1" in refs:
        px, py = fr.x(parts["D1"]["pad1"][0]), fr.y(parts["D1"]["pad1"][1])
        cx, cy = fr.x(parts["D1"]["pos"][0]), fr.y(parts["D1"]["pos"][1])
        bx = cx + (px - cx) * 0.62      # the band sits at the cathode (pad 1) end of the body
        out.append(f'<rect x="{bx - 0.3:.3f}" y="{cy - 1.6:.3f}" width="0.6" height="3.2" '
                   f'fill="#e00000" fill-opacity="0.85"/>')
        out.append(text(bx, cy + 2.9, "band (cathode)", 0.8, False, "#c00000"))
    if key == "usbc" and "D1" in refs:
        bx, by = parts["D1"]["pos"]
        x, y = fr.x(bx), fr.y(by)
        out.append(f'<path d="M {x:.3f} {y + 0.9:.3f} L {x:.3f} {y + 2.4:.3f}" '
                   f'stroke="#c00000" stroke-width="0.18" marker-end="url(#arrow)"/>')
        out.append(text(x, y + 3.2, "lens", 0.8, False, "#c00000"))
        px, py = parts["D1"]["pad1"]
        out.append(text(fr.x(px), fr.y(py) - 1.6, "cathode", 0.7, False, "#c00000"))
    return out


def xiao_outline(fr, parts):
    """The XIAO over its headers, USB-C at the pin-1 end, seen from the back."""
    j1, j2 = parts["J1"]["pad1"], parts["J2"]["pad1"]
    cx = (j1[0] + j2[0]) / 2
    cy = j1[1] - 3 * 2.54          # pin rows centred on the XIAO
    x0, x1 = sorted((fr.x(cx - 8.9), fr.x(cx + 8.9)))
    y0, y1 = fr.y(cy - 10.5), fr.y(cy + 10.5)
    ux0, ux1 = sorted((fr.x(cx - 4.5), fr.x(cx + 4.5)))
    return [
        f'<rect x="{x0:.3f}" y="{y0:.3f}" width="{x1 - x0:.3f}" height="{y1 - y0:.3f}" rx="0.6" '
        f'fill="#2a6fdb" fill-opacity="0.18" stroke="#1d4fa0" stroke-width="0.2" '
        f'stroke-dasharray="0.6 0.4"/>',
        f'<rect x="{ux0:.3f}" y="{y1 - 7.2:.3f}" width="{ux1 - ux0:.3f}" height="{7.2 + 1.8:.3f}" '
        f'rx="1.2" fill="#c0c8d0" fill-opacity="0.7" stroke="#1d4fa0" stroke-width="0.15"/>',
        text((x0 + x1) / 2, y1 - 2.6, "XIAO USB-C", 0.85, False, "#1d4fa0"),
        text((x0 + x1) / 2, (y0 + y1) / 2 - 2.0, "XIAO", 1.2, False, "#1d4fa0"),
        text((x0 + x1) / 2, (y0 + y1) / 2, "components facing you", 0.85, False, "#1d4fa0"),
        text(fr.x(j1[0]), fr.y(j1[1]) + 1.9, "D0", 0.8, False, "#c00000"),
        text(fr.x(j2[0]), fr.y(j2[1]) + 1.9, "5V", 0.8, False, "#c00000"),
    ]


HEADER_PINS = {
    "J1": ["VBAT/2 (D0)", "BTN A (D1)", "BTN B (D2)", "BTN C (D3)", "JOY UP (D4)",
           "JOY DOWN (D5)", "JOY LEFT (D6)"],
    "J2": ["5V (n.c.)", "GND", "3V3", "n.c. (D10)", "VBUS sense (D9)", "CHG sense (D8)",
           "JOY RIGHT (D7)"],
}


def test_points(fr, parts):
    """Signal names beside each XIAO header socket, for the meter checks."""
    out = []
    for ref, names in HEADER_PINS.items():
        x1, y1 = parts[ref]["pad1"]
        for k, name in enumerate(names):
            px, py = fr.x(x1), fr.y(y1 - k * 2.54)
            inward = 1 if fr.x(100.0) > px else -1      # write toward the board centre
            out.append(f'<circle cx="{px:.3f}" cy="{py:.3f}" r="0.55" fill="none" '
                       f'stroke="#1d4fa0" stroke-width="0.15"/>')
            anchor = "start" if inward > 0 else "end"
            out.append(f'<text x="{px + inward * 1.1:.3f}" y="{py:.3f}" '
                       f'font-family="Helvetica, Arial, sans-serif" font-size="0.75" '
                       f'font-weight="bold" fill="#1d4fa0" text-anchor="{anchor}" '
                       f'dominant-baseline="central" paint-order="stroke" stroke="#fff" '
                       f'stroke-width="0.2">{k + 1} {esc(name)}</text>')
    return out


def draw(key, side, suffix, title, now, done, base, w, h, edges, parts, extra=None,
         done_style="done"):
    fr = Frame(edges, w, h, side)
    W, H = w + 2 * MARGIN, h + 2 * MARGIN + TITLE_H
    for ref in list(now) + list(done):      # parts past the board edge, such as the USB-C nose
        x, y, bw, bh = fr.box(parts[ref]["box"])
        W = max(W, x + bw + MARGIN)
        H = max(H, y + bh + MARGIN + (3.0 if (key, ref) == ("usbc", "D1") else 0))
    els = [f'<rect width="{W:.3f}" height="{H:.3f}" fill="#fff"/>',
           f'<g transform="translate({MARGIN} {MARGIN + TITLE_H})" opacity="0.55">{base}</g>',
           text(W / 2, TITLE_H / 2 + 0.3, title, min(1.1, W / max(len(title), 1) * 1.75), False,
                "#000", "bold")]
    for ref in done:
        els += part_box(fr, key, ref, parts[ref], done_style)
    for ref in now:
        els += part_box(fr, key, ref, parts[ref], "map" if suffix.endswith("map") else "now")
    els += extras(fr, key, now, parts)
    if extra:
        els += extra(fr, parts)
    svg = (f'<svg xmlns="http://www.w3.org/2000/svg" width="{W * PX_PER_MM:.0f}" '
           f'height="{H * PX_PER_MM:.0f}" viewBox="0 0 {W:.3f} {H:.3f}">'
           '<defs><marker id="arrow" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="4" '
           'markerHeight="4" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" '
           'fill="#c00000"/></marker></defs>' + "".join(els) + "</svg>")
    name = f"{BOARDS[key][1]}-{VERSION}-{suffix}"
    with tempfile.NamedTemporaryFile("w", suffix=".svg", delete=False) as f:
        f.write(svg)
    subprocess.run(["rsvg-convert", "-o", os.path.join(OUT, name + ".png"), f.name], check=True)
    os.unlink(f.name)
    print(name + ".png")


def render_3d(key, side, tmp):
    """The bare board as it arrives: a 3D render with every part's model removed."""
    board = pcbnew.LoadBoard(os.path.join(ROOT, BOARDS[key][0]))
    for fp in board.GetFootprints():
        fp.Models().clear()
    bare = os.path.join(tmp, f"bare-{key}.kicad_pcb")
    board.Save(bare)
    raw = os.path.join(tmp, f"bare-{key}-{side}.png")
    subprocess.run([KICAD_CLI, "pcb", "render", "--side", "bottom" if side == "back" else "top",
                    "--quality", "high", "--width", "1600", "--height", "1600", "--zoom", "0.9",
                    "--background", "transparent", "-o", raw, bare],
                   check=True, capture_output=True)
    draw_side = "top" if key == "usbc" else side
    name = f"{BOARDS[key][1]}-{VERSION}-bare-{draw_side}.png"
    subprocess.run(["magick", raw, "-trim", "-bordercolor", "none", "-border", "30",
                    "-background", "white", "-flatten", "-resize", "900x900>",
                    os.path.join(OUT, name)], check=True)
    print(name)


def main():
    with tempfile.TemporaryDirectory() as tmp:
        cache = {}
        for key in BOARDS:
            path, parts, edges = board_data(key)
            sides = sorted({p["side"] for p in parts.values()})
            for side in sides:
                base, w, h = export_base(path, side, tmp)
                cache[(key, side)] = (base, w, h, edges, parts)
                draw_side = "top" if key == "usbc" else side
                refs = sorted(r for r, p in parts.items() if p["side"] == side)
                draw(key, side, f"asm-{draw_side}-map",
                     f"{BOARDS[key][2]}, {draw_side}: all parts", refs, [], base, w, h, edges,
                     parts)
                render_3d(key, side, tmp)
        placed = {}
        for key, side, suffix, title, refs in STEPS:
            side_key = "front" if side == "top" else side
            base, w, h, edges, parts = cache[(key, side_key)]
            done = placed.setdefault((key, side_key), [])
            draw(key, side_key, suffix, title, refs, list(done), base, w, h, edges, parts)
            done += refs
        base, w, h, edges, parts = cache[("control", "back")]
        draw("control", "back", "asm-xiao", "Control board, back: XIAO orientation",
             [], [r for r, p in parts.items() if p["side"] == "back"], base, w, h, edges, parts,
             xiao_outline, "ghost")
        draw("control", "back", "asm-test-points", "Control board, back: header test points",
             [], [r for r, p in parts.items() if p["side"] == "back"], base, w, h, edges, parts,
             test_points, "ghost")


if __name__ == "__main__":
    sys.exit(main())
