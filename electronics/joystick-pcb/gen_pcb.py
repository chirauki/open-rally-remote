#!/usr/bin/env python3
"""Generate the Open Rally Remote joystick PCB (joystick.kicad_pcb).

Run with KiCad's bundled Python, from this directory:
  /Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3 gen_pcb.py

Board coordinates are mm from the board centre (the stick axis), seen from the front
(component side, facing the cover): +x is the rider's right, +y is down the facet, away
from button C. The joystick frame in mechanical/cad/complete-remote-v0.23.scad has
X = -x and Y = -y. The outline numbers match joy_pcb_hx, joy_pcb_hy, joy_pcb_notch_r and
joy_boss_xy() there.

The script also writes joystick.kicad_sch (gen_sch.py) so the schematic matches the board.
"""
import os

import pcbnew
import wx

import design as d
import gen_sch

HERE = os.path.dirname(os.path.abspath(__file__))
STOCK = "/Applications/KiCad/KiCad.app/Contents/SharedSupport/footprints"
OX, OY = 100.0, 100.0  # board centre on the KiCad sheet


def P(x, y):
    return pcbnew.VECTOR2I(pcbnew.FromMM(OX + x), pcbnew.FromMM(OY + y))


_app = wx.App(False)  # footprint Flip() needs a wxApp
board = pcbnew.CreateEmptyBoard()
board.SetCopperLayerCount(2)

ds = board.GetDesignSettings()
ds.SetBoardThickness(pcbnew.FromMM(1.6))
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
def edge_seg(a, b):
    s = pcbnew.PCB_SHAPE(board)
    s.SetShape(pcbnew.SHAPE_T_SEGMENT)
    s.SetStart(P(*a))
    s.SetEnd(P(*b))
    s.SetLayer(pcbnew.Edge_Cuts)
    s.SetWidth(pcbnew.FromMM(0.1))
    board.Add(s)


def edge_arc(a, m, b):
    s = pcbnew.PCB_SHAPE(board)
    s.SetShape(pcbnew.SHAPE_T_ARC)
    s.SetArcGeometry(P(*a), P(*m), P(*b))
    s.SetLayer(pcbnew.Edge_Cuts)
    s.SetWidth(pcbnew.FromMM(0.1))
    board.Add(s)


outline, _ = d.outline_path()
for kind, pts in outline:
    if kind == "seg":
        edge_seg(*pts)
    else:
        edge_arc(*pts)

# --- Footprints ----------------------------------------------------------------------
fps = {}


def place(ref, lib, name, x, y, rot=0, back=False, value=None, board_only=False):
    libpath = os.path.join(HERE, "orr.pretty") if lib == "orr" else os.path.join(STOCK, lib + ".pretty")
    fp = pcbnew.FootprintLoad(libpath, name)
    fp.SetFPID(pcbnew.LIB_ID(lib, name))
    fp.SetReference(ref)
    fp.SetValue(value or name)
    fp.SetPosition(P(x, y))
    fp.SetOrientationDegrees(rot)
    if board_only:
        fp.SetBoardOnly(True)
        fp.SetExcludedFromBOM(True)
        fp.SetExcludedFromPosFiles(True)
    else:
        sym = d.SYMBOLS[ref]
        fp.SetPath(pcbnew.KIID_PATH("/" + d.ROOT_UUID + "/" + sym["uuid"]))
        fp.SetValue(sym["value"])
        for k, v in sym.get("fields", {}).items():
            fp.SetField(k, v)
    # Reference on the fab layer; every other field hidden on the fab layer too.
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


for ref, (x, y) in d.SWITCHES.items():
    place(ref, "orr", "KSC2_SMD_6.2x6.2mm", x, y, rot=90)
f1 = place("F1", "Fuse", "Fuse_1812_4532Metric", *d.F1_XY, rot=180, back=True)
# The fuse outline would collide with the wire-pad labels; the part has no polarity.
for item in list(f1.GraphicalItems()):
    if item.GetLayer() in (pcbnew.F_SilkS, pcbnew.B_SilkS):
        f1.Remove(item)
place("D1", "Diode_SMD", "D_SMB", *d.D1_XY, back=True)
place("J1", "orr", "WirePads_1x02_P2.4mm", *d.J1_XY, back=True)
place("J2", "orr", "WirePads_1x06_P2.1mm", *d.J2_XY, back=True)
for i, (x, y) in enumerate(d.STANDOFFS_K):
    place("H%d" % (i + 1), "orr", "Standoff_M2_PCB", x, y, value="M2 standoff", board_only=True)


def pad_xy(pad):
    p = pad.GetPosition()
    return (round(pcbnew.ToMM(p.x) - OX, 3), round(pcbnew.ToMM(p.y) - OY, 3))


# Nets by pad position, so the assignment follows the geometry after rotation and flipping.
# Switches: the signal and ground pads are diagonal, so the internal pairing (1-2 or 1-3)
# does not matter; the other two pads are soldered but left unconnected.
pinmap = {}
for ref, fp in fps.items():
    for pad in fp.Pads():
        xy = pad_xy(pad)
        net = d.net_at(ref, xy)
        if net:
            pad.SetNet(nets[net])
        elif ref in d.SYMBOLS:
            # Open pads get the schematic's no-connect net name, for the parity check.
            name = "unconnected-(%s-Pad%s)" % (ref, pad.GetNumber())
            n = pcbnew.NETINFO_ITEM(board, name)
            board.Add(n)
            pad.SetNet(n)
        pinmap.setdefault(ref, {})[pad.GetNumber()] = (net, xy)

# --- Tracks and vias -----------------------------------------------------------------
def track(net, pts, w, layer=pcbnew.B_Cu):
    for a, b in zip(pts, pts[1:]):
        t = pcbnew.PCB_TRACK(board)
        t.SetStart(P(*a))
        t.SetEnd(P(*b))
        t.SetWidth(pcbnew.FromMM(w))
        t.SetLayer(layer)
        t.SetNet(nets[net])
        board.Add(t)


def via(net, xy):
    v = pcbnew.PCB_VIA(board)
    v.SetPosition(P(*xy))
    v.SetDrill(pcbnew.FromMM(0.3))
    v.SetWidth(pcbnew.FromMM(0.6))
    v.SetNet(nets[net])
    board.Add(v)


for net, layer, w, pts in d.TRACKS:
    track(net, pts, w, pcbnew.F_Cu if layer == "F" else pcbnew.B_Cu)
for net, xy in d.VIAS:
    via(net, xy)

# --- Ground pours on both layers ------------------------------------------------------
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

# --- Text ----------------------------------------------------------------------------
def text(s, x, y, layer, size=0.7, just=None):
    t = pcbnew.PCB_TEXT(board)
    t.SetText(s)
    t.SetPosition(P(x, y))
    t.SetLayer(layer)
    t.SetTextSize(pcbnew.VECTOR2I(pcbnew.FromMM(size), pcbnew.FromMM(size)))
    t.SetTextThickness(pcbnew.FromMM(0.12 if size < 0.9 else 0.15))
    if layer == pcbnew.B_SilkS:
        t.SetMirrored(True)
    if just is not None:
        t.SetHorizJustify(just)
    board.Add(t)


for s, x, y, layer, size in d.TEXTS:
    text(s, x, y, {"F": pcbnew.F_SilkS, "B": pcbnew.B_SilkS}[layer], size)

filler = pcbnew.ZONE_FILLER(board)
filler.Fill(board.Zones())

out = os.path.join(HERE, "joystick.kicad_pcb")
board.SetFileName(out)
pcbnew.SaveBoard(out, board)

for ref in sorted(pinmap):
    print(ref, {k: v for k, v in sorted(pinmap[ref].items())})

gen_sch.main(pinmap)
