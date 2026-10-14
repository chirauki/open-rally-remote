#!/usr/bin/env python3
"""Generate an Open Rally Remote V0.26 board (<PROJECT>.kicad_pcb) and its schematic.

Run with KiCad's bundled Python, from this directory:
  /Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3 gen_pcb.py

Placement and nets are in design.py. The script routes the board with Freerouting
(FREEROUTING_JAR, default ~/.arduino-orr/tools/freerouting-1.9.0.jar, Java 17), then fills
the ground pours and writes control.kicad_sch (gen_sch.py).
"""
import os
import subprocess

import pcbnew
import wx

import design as d
import gen_sch

HERE = os.path.dirname(os.path.abspath(__file__))
STOCK = "/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints"
JAR = os.environ.get("FREEROUTING_JAR", os.path.expanduser("~/.arduino-orr/tools/freerouting-1.9.0.jar"))
OX, OY = 100.0, 100.0  # board centre on the KiCad sheet


def P(x, y):
    return pcbnew.VECTOR2I(pcbnew.FromMM(OX + x), pcbnew.FromMM(OY + y))


_app = wx.App(False)  # footprint Flip() needs a wxApp
board = pcbnew.CreateEmptyBoard()
board.SetCopperLayerCount(2)

ds = board.GetDesignSettings()
ds.SetBoardThickness(pcbnew.FromMM(d.THICKNESS))
ds.m_TrackMinWidth = pcbnew.FromMM(0.2)
ds.m_ViasMinSize = pcbnew.FromMM(0.6)
ds.m_MinThroughDrill = pcbnew.FromMM(0.3)
ds.m_CopperEdgeClearance = pcbnew.FromMM(0.3)
ds.m_MinClearance = pcbnew.FromMM(0.2)
nc = ds.m_NetSettings.GetDefaultNetclass()
nc.SetClearance(pcbnew.FromMM(0.2))
nc.SetTrackWidth(pcbnew.FromMM(0.25))
nc.SetViaDiameter(pcbnew.FromMM(0.6))
nc.SetViaDrill(pcbnew.FromMM(0.3))

nets = {}
for name in d.NETS:
    n = pcbnew.NETINFO_ITEM(board, name)
    board.Add(n)
    nets[name] = n

# --- Outline -------------------------------------------------------------------------
for it in d.edge_items():
    s = pcbnew.PCB_SHAPE(board)
    if it[0] == "seg":
        s.SetShape(pcbnew.SHAPE_T_SEGMENT)
        s.SetStart(P(*it[1]))
        s.SetEnd(P(*it[2]))
    else:
        s.SetShape(pcbnew.SHAPE_T_ARC)
        s.SetArcGeometry(P(*it[1]), P(*it[2]), P(*it[3]))
    s.SetLayer(pcbnew.Edge_Cuts)
    s.SetWidth(pcbnew.FromMM(0.1))
    board.Add(s)

# --- Footprints ----------------------------------------------------------------------
fps = {}


def place(ref, fpid, x, y, rot, back, board_only=False, value=None):
    lib, name = fpid.split(":")
    libpath = os.path.join(HERE, "orr.pretty") if lib == "orr" else os.path.join(STOCK, lib + ".pretty")
    fp = pcbnew.FootprintLoad(libpath, name)
    fp.SetFPID(pcbnew.LIB_ID(lib, name))
    fp.SetReference(ref)
    fp.SetPosition(P(x, y))
    fp.SetOrientationDegrees(rot)
    if board_only:
        fp.SetValue(value or name)
        fp.SetBoardOnly(True)
        fp.SetExcludedFromBOM(True)
        fp.SetExcludedFromPosFiles(True)
    else:
        sym = d.SYMBOLS[ref]
        fp.SetPath(pcbnew.KIID_PATH("/" + d.ROOT_UUID + "/" + sym["uuid"]))
        fp.SetValue(sym["value"])
        for k, v in sym.get("fields", {}).items():
            fp.SetField(k, v)
    for f in fp.GetFields():
        f.SetLayer(pcbnew.F_Fab)
        f.SetTextSize(pcbnew.VECTOR2I(pcbnew.FromMM(0.6), pcbnew.FromMM(0.6)))
        f.SetTextThickness(pcbnew.FromMM(0.1))
        if not f.IsReference():
            f.SetVisible(False)
    board.Add(fp)
    if back:
        fp.Flip(P(x, y), pcbnew.FLIP_DIRECTION_LEFT_RIGHT)
    fps[ref] = fp
    return fp


for ref, (x, y, rot, side) in d.PLACE.items():
    place(ref, d.SYMBOLS[ref]["footprint"], x, y, rot, side == "B")
for i, (x, y) in enumerate(d.STANDOFFS):
    place("H%d" % (i + 1), getattr(d, "HOLE_FP", "orr:Standoff_M2_PCB"), x, y, 0, False, board_only=True, value="M2")


def pad_xy(pad):
    p = pad.GetPosition()
    return (round(pcbnew.ToMM(p.x) - OX, 3), round(pcbnew.ToMM(p.y) - OY, 3))


pinmap = {}
for ref, fp in fps.items():
    if ref not in d.SYMBOLS:
        continue
    for pad in fp.Pads():
        num = pad.GetNumber()
        net = d.CONN[ref].get(num)
        if net:
            pad.SetNet(nets[net])
        elif num and num != "MP":
            pin = d.NC_PIN_NAMES.get((ref, num))
            name = "unconnected-(%s-%sPad%s)" % (ref, pin + "-" if pin else "", num)
            n = pcbnew.NETINFO_ITEM(board, name)
            board.Add(n)
            pad.SetNet(n)
        if num and num != "MP":
            pinmap.setdefault(ref, {})[num] = (net, pad_xy(pad))

# Power nets get wider tracks.
for name, w in d.POWER_NETS.items():
    ncl = pcbnew.NETCLASS("PWR_%s" % name.strip("/+"))
    ncl.SetTrackWidth(pcbnew.FromMM(w))
    ncl.SetClearance(pcbnew.FromMM(0.2))
    ncl.SetViaDiameter(pcbnew.FromMM(0.6))
    ncl.SetViaDrill(pcbnew.FromMM(0.3))
    ds.m_NetSettings.SetNetclass(ncl.GetName(), ncl)
    ds.m_NetSettings.SetNetclassPatternAssignment(name, ncl.GetName())
board.SynchronizeNetsAndNetClasses(True)

# Track keep-outs round the boss notches: Freerouting does not keep the board-edge
# clearance from the notch arcs.
import math
if hasattr(d, "NOTCH_CENTRES"):
    centres = d.NOTCH_CENTRES
else:
    centres = [(cx, cy) for cx in (-d.NOTCH_X, d.NOTCH_X) for cy in d.NOTCH_Y]
for cx, cy in centres:
    if True:
        k = pcbnew.ZONE(board)
        k.SetIsRuleArea(True)
        k.SetDoNotAllowTracks(True)
        k.SetDoNotAllowVias(True)
        k.SetDoNotAllowZoneFills(False)
        k.SetDoNotAllowPads(False)
        k.SetDoNotAllowFootprints(False)
        k.SetLayerSet(pcbnew.LSET.AllCuMask())
        ol = k.Outline()
        ol.NewOutline()
        r = d.NOTCH_R + 0.6
        for i in range(36):
            t = 2 * math.pi * i / 36
            ol.Append(pcbnew.FromMM(OX + cx + r * math.cos(t)), pcbnew.FromMM(OY + cy + r * math.sin(t)))
        board.Add(k)

# Track and via keep-out rectangles from the design, [x0, y0, x1, y1]: Freerouting does not
# keep the 0.3 mm board-edge clearance on its own.
for x0, y0, x1, y1 in getattr(d, "KEEPOUT_RECTS", []):
    k = pcbnew.ZONE(board)
    k.SetIsRuleArea(True)
    k.SetDoNotAllowTracks(True)
    k.SetDoNotAllowVias(True)
    k.SetDoNotAllowZoneFills(False)
    k.SetDoNotAllowPads(False)
    k.SetDoNotAllowFootprints(False)
    k.SetLayerSet(pcbnew.LSET.AllCuMask())
    ol = k.Outline()
    ol.NewOutline()
    for x, y in ((x0, y0), (x1, y0), (x1, y1), (x0, y1)):
        ol.Append(pcbnew.FromMM(OX + x), pcbnew.FromMM(OY + y))
    board.Add(k)

# Through-hole pins listed in the design connect to the pours without thermal relief.
for ref in getattr(d, "FULL_ZONE_REFS", []):
    for pad in fps[ref].Pads():
        pad.SetLocalZoneConnection(pcbnew.ZONE_CONNECTION_FULL)

# --- Text ----------------------------------------------------------------------------
for s, x, y, layer, size in d.TEXTS:
    t = pcbnew.PCB_TEXT(board)
    t.SetText(s)
    t.SetPosition(P(x, y))
    t.SetLayer(pcbnew.F_SilkS if layer == "F" else pcbnew.B_SilkS)
    t.SetTextSize(pcbnew.VECTOR2I(pcbnew.FromMM(size), pcbnew.FromMM(size)))
    t.SetTextThickness(pcbnew.FromMM(0.12))
    if layer == "B":
        t.SetMirrored(True)
    board.Add(t)

out = os.path.join(HERE, d.PROJECT + ".kicad_pcb")
board.SetFileName(out)

# --- Route with Freerouting ----------------------------------------------------------
dsn = os.path.join(HERE, "fab", d.PROJECT + ".dsn")
ses = os.path.join(HERE, "fab", d.PROJECT + ".ses")
os.makedirs(os.path.dirname(dsn), exist_ok=True)
pcbnew.ExportSpecctraDSN(board, dsn)
if os.path.exists(ses):
    os.remove(ses)
subprocess.run(["java", "-jar", JAR, "-de", dsn, "-do", ses, "-mp", "40", "-dct", "0"],
               check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=900)
pcbnew.ImportSpecctraSES(board, ses)
os.remove(dsn)
os.remove(ses)

# --- Ground pours on both layers, after routing -----------------------------------------
poly = d.outline_polygon()
for layer in (pcbnew.F_Cu, pcbnew.B_Cu):
    z = pcbnew.ZONE(board)
    z.SetLayer(layer)
    z.SetNet(nets["GND"])
    z.SetLocalClearance(pcbnew.FromMM(0.25))
    z.SetMinThickness(pcbnew.FromMM(0.25))
    z.SetPadConnection(pcbnew.ZONE_CONNECTION_THERMAL)
    z.SetThermalReliefGap(pcbnew.FromMM(0.3))
    z.SetThermalReliefSpokeWidth(pcbnew.FromMM(0.4))
    z.SetIslandRemovalMode(pcbnew.ISLAND_REMOVAL_MODE_ALWAYS)
    ol = z.Outline()
    ol.NewOutline()
    for x, y in poly:
        ol.Append(pcbnew.FromMM(OX + x), pcbnew.FromMM(OY + y))
    board.Add(z)
pcbnew.ZONE_FILLER(board).Fill(board.Zones())

pcbnew.SaveBoard(out, board)
gen_sch.main(pinmap)
