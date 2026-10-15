#!/usr/bin/env python3
"""JLCPCB files for panel.kicad_pcb: Gerbers and drill (zip), BOM and CPL.

Run with KiCad's Python (or the KiKit venv) after gen_panel.py:
  ~/.arduino-orr/kikit-venv/bin/python gen_fab.py

The panel has no schematic, so the BOM comes from the footprints' LCSC, MPN and value fields,
as the source boards' generators set them. KiKit's own footprints (fiducials, tooling holes,
mouse bites) and board-only footprints are left out.
"""
import csv
import os
import subprocess
import zipfile

import pcbnew

HERE = os.path.dirname(os.path.abspath(__file__))
FAB = os.path.join(HERE, "fab")
PCB = os.path.join(HERE, "panel.kicad_pcb")
K = "/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli"


def run(*args):
    subprocess.run([K, *args], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def main():
    gb = os.path.join(FAB, "gerbers")
    os.makedirs(gb, exist_ok=True)
    run("pcb", "export", "gerbers", "--layers", "F.Cu,B.Cu,F.Paste,B.Paste,F.SilkS,B.SilkS,F.Mask,B.Mask,Edge.Cuts",
        "--subtract-soldermask", "-o", gb + "/", PCB)
    run("pcb", "export", "drill", "--format", "excellon", "--excellon-separate-th", "--generate-map",
        "--map-format", "gerberx2", "-o", gb + "/", PCB)
    with zipfile.ZipFile(os.path.join(FAB, "panel-gerbers.zip"), "w", zipfile.ZIP_DEFLATED) as z:
        for f in sorted(os.listdir(gb)):
            z.write(os.path.join(gb, f), f)

    board = pcbnew.LoadBoard(PCB)
    groups = {}
    for fp in board.GetFootprints():
        ref = fp.GetReference()
        if ref.startswith("KiKit") or fp.IsExcludedFromBOM() or fp.IsExcludedFromPosFiles():
            continue
        lcsc = fp.GetFieldText("LCSC") if fp.HasField("LCSC") else ""
        if not lcsc:
            raise SystemExit("no LCSC field on " + ref)
        # One row per part: the same LCSC part on both boards (J4, J101) shares a row.
        g = groups.setdefault((str(fp.GetFPID().GetLibItemName()), lcsc), {"value": fp.GetValue(), "refs": []})
        g["refs"].append(ref)
    with open(os.path.join(FAB, "panel-bom.csv"), "w", newline="") as f:
        w = csv.writer(f, lineterminator="\n")
        w.writerow(["Comment", "Designator", "Footprint", "LCSC"])
        for (footprint, lcsc), g in sorted(groups.items(), key=lambda kv: sorted(kv[1]["refs"])[0]):
            w.writerow([g["value"], ",".join(sorted(g["refs"])), footprint, lcsc])
    placed = {r for g in groups.values() for r in g["refs"]}

    # Placement from kicad-cli, as for the single boards (fab/jlc_cpl.py there).
    pos = os.path.join(FAB, "panel-pos.csv")
    run("pcb", "export", "pos", "--format", "csv", "--units", "mm", "--side", "both", "--exclude-dnp", "-o", pos, PCB)
    with open(pos) as f, open(os.path.join(FAB, "panel-cpl.csv"), "w", newline="") as g:
        w = csv.writer(g, lineterminator="\n")
        w.writerow(["Designator", "Mid X", "Mid Y", "Layer", "Rotation"])
        for r in csv.DictReader(f):
            if r["Ref"] in placed:
                w.writerow([r["Ref"], "%.3fmm" % float(r["PosX"]), "%.3fmm" % float(r["PosY"]),
                            "Top" if r["Side"] == "top" else "Bottom", "%.0f" % float(r["Rot"])])


if __name__ == "__main__":
    main()
