#!/usr/bin/env python3
"""Convert KiCad's position file (fab/control-pos.csv) to JLCPCB's CPL format (fab/control-cpl.csv).

JLCPCB's rotation convention can differ from KiCad's for some packages; check every part in
JLCPCB's placement preview before ordering.
"""
import csv
import os

HERE = os.path.dirname(os.path.abspath(__file__))
src = os.path.join(HERE, "fab", "control-pos.csv")
dst = os.path.join(HERE, "fab", "control-cpl.csv")
with open(src) as f, open(dst, "w", newline="") as g:
    w = csv.writer(g)
    w.writerow(["Designator", "Mid X", "Mid Y", "Layer", "Rotation"])
    for r in csv.DictReader(f):
        w.writerow([r["Ref"], "%.3fmm" % float(r["PosX"]), "%.3fmm" % float(r["PosY"]),
                    "Top" if r["Side"] == "top" else "Bottom", "%.0f" % float(r["Rot"])])
