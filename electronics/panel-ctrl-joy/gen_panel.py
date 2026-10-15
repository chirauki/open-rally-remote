#!/usr/bin/env python3
"""Panel of the V0.31 control board and joystick board rev C, for one JLCPCB order.

Both boards are 1.6 mm and assembled on both sides, so one panel pays one double-sided
assembly setup instead of two. The USB-C board (1.2 mm, one side) is ordered on its own.

Run with KiKit 1.8 in a venv on KiCad's Python (see README.md):
  ~/.arduino-orr/kikit-venv/bin/python gen_panel.py

Writes panel.kicad_pcb. The control board lies rotated 90 degrees beside the joystick board;
5 mm rails top and bottom carry three fiducials and four tooling holes; mouse-bite tabs join
the boards to the rails. The joystick board's references move to the 100s (J1 -> J101) so
they do not clash with the control board's in the BOM and CPL.
"""
import os
import re

import pcbnew
from kikit import panelize
from kikit.units import mm, deg
from kikit.panelize_ui_impl import polygonToSubstrate
from shapely.geometry import box, Point
from kikit.annotations import TabAnnotation

HERE = os.path.dirname(os.path.abspath(__file__))
CTRL = os.path.join(HERE, "..", "control-pcb", "control.kicad_pcb")
JOY = os.path.join(HERE, "..", "joystick-pcb-rev-c", "joystick.kicad_pcb")
OUT = os.path.join(HERE, "panel.kicad_pcb")

GAP = 2.0 * mm          # between the boards and to the rails
RAIL = 5.0 * mm         # JLCPCB asks for >= 5 mm rails on assembly panels
TAB_W = 3.0 * mm
JOY_TAB_W = 2.4 * mm
CTRL_W, CTRL_H = 49.0 * mm, 21.4 * mm   # rotated 90 degrees
JOY_W, JOY_H = 20.6 * mm, 22.4 * mm   # rotated 90 degrees: JOY_H along the panel


def ref_renamer(n, ref):
    if n == 0:
        return ref
    m = re.match(r"([A-Za-z]+)(\d+)$", ref)
    return "%s%d" % (m.group(1), int(m.group(2)) + 100) if m else ref


def main():
    panel = panelize.Panel(OUT)
    src = pcbnew.LoadBoard(CTRL)
    panel.inheritDesignSettings(src)
    panel.inheritProperties(src)
    panel.inheritTitleBlock(src)
    panel.inheritCopperLayers(src)

    x0 = 0
    panel.appendBoard(CTRL, pcbnew.VECTOR2I(int(x0 + CTRL_W / 2), 0), origin=panelize.Origin.Center,
                      rotationAngle=pcbnew.EDA_ANGLE(90, pcbnew.DEGREES_T), tolerance=1 * mm,
                      refRenamer=ref_renamer, inheritDrc=False)
    # Rotated so its J1 edge faces the panel's open right edge: no tab next to the socket.
    global JOY_CX
    JOY_CX = x0 + CTRL_W + GAP + JOY_H / 2
    panel.appendBoard(JOY, pcbnew.VECTOR2I(int(JOY_CX), 0), origin=panelize.Origin.Center,
                      rotationAngle=pcbnew.EDA_ANGLE(90, pcbnew.DEGREES_T), tolerance=1 * mm,
                      refRenamer=ref_renamer, inheritDrc=False)

    # Ghost rails at twice the gap, so the partition line (half way) sits where the real rails
    # will be and the tabs reach them; the same trick as KiKit's own CLI.
    minx, miny, maxx, maxy = panel.boardsBBox()
    w = 1 * mm
    ghosts = [polygonToSubstrate(box(minx, miny - 2 * GAP - w, maxx, miny - 2 * GAP)),
              polygonToSubstrate(box(minx, maxy + 2 * GAP, maxx, maxy + 2 * GAP + w))]
    panel.buildPartitionLineFromBB(ghosts)
    # Tabs only to the rails, only where the board's outline runs straight along its top or
    # bottom bounding edge for the tab width plus 1 mm each side: never in a notch or in the
    # joystick board's slots. No tab between the boards (it would sit at the control board's J4).
    # Joystick board (substrate 1): its rail-facing edges are its side edges (rotated 90 degrees),
    # straight only from the side switch's body (3.1 mm from its centre line) to the notch (7.55 mm).
    # A 2.4 mm tab centred 5.45 mm along, with the mouse bites' 0.25 mm run-out, keeps the holes
    # clear of the switch body and about 0.5 mm from the notch. The holes still fall inside the switches' generous courtyards.
    joy = panel.substrates[1]
    jminx, jminy, jmaxx, jmaxy = joy.bounds()
    jcx = JOY_CX + 5.45 * mm
    joy.annotations.append(TabAnnotation(None, (jcx, jminy), (0, 1), JOY_TAB_W))
    joy.annotations.append(TabAnnotation(None, (jcx, jmaxy), (0, -1), JOY_TAB_W))
    for sub in panel.substrates[:1]:
        geom = sub.substrates
        minx, miny, maxx, maxy = sub.bounds()
        for yedge, d in ((miny, (0, 1)), (maxy, (0, -1))):
            probe = yedge + d[1] * 0.05 * mm
            step = int(0.25 * mm)
            # Keep tabs away from parts: drop edge stretches where a courtyard comes within 1 mm.
            banned = []
            for fp in panel.board.GetFootprints():
                for layer in (pcbnew.F_CrtYd, pcbnew.B_CrtYd):
                    poly = fp.GetCourtyard(layer)
                    if poly.OutlineCount() == 0:
                        continue
                    bb = poly.BBox()
                    near = (bb.GetTop() <= yedge + 1 * mm) if d[1] > 0 else (bb.GetBottom() >= yedge - 1 * mm)
                    if near and bb.GetRight() > minx and bb.GetLeft() < maxx:
                        banned.append((bb.GetLeft() - TAB_W / 2 - 0.5 * mm, bb.GetRight() + TAB_W / 2 + 0.5 * mm))
            xs = [x for x in range(int(minx), int(maxx), step) if geom.contains(Point(x, probe))
                  and not any(a <= x <= b for a, b in banned)]
            runs, run = [], []
            for x in xs:
                if run and x - run[-1] > step:
                    runs.append(run); run = []
                run.append(x)
            if run:
                runs.append(run)
            need = TAB_W + 2 * mm
            for r in runs:
                a, b = r[0], r[-1]
                if b - a < need:
                    continue
                n = 2 if b - a > 3 * need else 1
                for k in range(n):
                    x = a + (b - a) * (k + 1) / (n + 1)
                    sub.annotations.append(TabAnnotation(None, (x, yedge), d, TAB_W))
    cuts = panel.buildTabsFromAnnotations(fillet=0.5 * mm)
    panel.makeRailsTb(RAIL, vspace=GAP)
    # Holes centred on the board edge (offset 0): they reach at most 0.25 mm into the board, clear of
    # the joystick's side switches 0.3 mm from its edge.
    panel.makeMouseBites(cuts, diameter=0.5 * mm, spacing=0.8 * mm, offset=0, prolongation=0.25 * mm)
    panel.addMillFillets(0.5 * mm)

    # Fiducials and tooling holes on the rails (JLCPCB assembly panels).
    panel.addCornerFiducials(3, horizontalOffset=4 * mm, verticalOffset=RAIL / 2,
                             copperDiameter=1 * mm, openingDiameter=2 * mm)
    panel.addCornerTooling(4, horizontalOffset=8 * mm, verticalOffset=RAIL / 2, diameter=1.152 * mm)
    panel.save(refillAllZones=True)   # pours clear the mouse-bite holes


if __name__ == "__main__":
    main()
