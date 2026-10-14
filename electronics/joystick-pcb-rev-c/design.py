"""Shared data for gen_pcb.py and gen_sch.py: the V0.27 joystick board (rev C).

Rev C is rev B (electronics/joystick-pcb-rev-b) with three changes, so the V0.27 housing can
close onto the board in a straight line along the remote's X axis (docs/mechanical-concept.md):
  - the two notches toward the fold (-y) become slots running SLOT mm down the facet (+y);
  - the standoff holes move to the lower half, at (+-6.5, 6.4);
  - J1 moves to the centre line, (0.0, 7.4), to pass between the screw heads.

Board coordinates: mm from the board centre (stick axis), seen from the front (switch side,
facing the cover), +x to the rider's right, +y down the facet (away from button C).
Joystick frame in the OpenSCAD model: X = -x, Y = -y.
"""
import importlib.util
import math
import os
import uuid

_spec = importlib.util.spec_from_file_location(
    "joystick_rev_a", os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "joystick-pcb", "design.py"))
_a = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_a)

NS = uuid.UUID("8a2f6c3d-1e4b-4b7a-9c5d-6e0f1a2b3c4d")


def uid(name):
    return str(uuid.uuid5(NS, name))


ROOT_UUID = uid("root")
PROJECT = "joystick"
TITLE = "Open Rally Remote - joystick board, rev C"
SUBTITLE = "Four C&K KSC2 switches under the stick disc, one socket to the control board"
THICKNESS = 1.6

# Outline: the rev A rectangle with a notch round each lower cover-screw boss; the two notches
# toward the fold (y = -11.0) run SLOT down the facet as slots. CAD: joy_pcb_slot.
HX, HY = _a.HX, _a.HY
NOTCH_R = _a.NOTCH_R
SLOT = 3.0
_NX, _NT, _NB = 9.75, -11.0, 10.8          # notch centres: x = +-_NX, y = _NT (top), _NB (bottom)
NOTCH_CENTRES = [(sx * _NX, y) for sx in (-1, 1) for y in (_NT, _NT + SLOT, _NB)]


def _pt(c, deg):
    return (c[0] + NOTCH_R * math.cos(math.radians(deg)), c[1] + NOTCH_R * math.sin(math.radians(deg)))


def _arc(c, a0, a1):
    """Arc on the notch circle round c from angle a0 to a1 (degrees, y down)."""
    return ("arc", _pt(c, a0), _pt(c, (a0 + a1) / 2), _pt(c, a1), c, a0, a1)


def _outline():
    """Clockwise on screen (y down): top edge, TR slot, right edge, BR notch, bottom edge, BL
    notch, left edge, TL slot."""
    r = NOTCH_R
    a_top = math.degrees(math.asin((HY + _NT) / r))           # circle at y = _NT meets y = -HY
    a_side = math.degrees(math.acos((HX - _NX) / r))          # circles meet x = +-HX
    a_bot = math.degrees(math.asin((HY - _NB) / r))           # circle at y = _NB meets y = HY
    tr1, tr2 = (_NX, _NT), (_NX, _NT + SLOT)
    tl1, tl2 = (-_NX, _NT), (-_NX, _NT + SLOT)
    br, bl = (_NX, _NB), (-_NX, _NB)
    items = [
        _arc(tr1, 180 + a_top, 180),                           # from the top edge down to the slot side
        ("seg", (_NX - r, _NT), (_NX - r, _NT + SLOT)),
        _arc(tr2, 180, a_side),                                # round the slot end to the right edge
        ("seg", _pt(tr2, a_side), _pt(br, -a_side)),
        _arc(br, -a_side, -180 - a_bot),                       # BR notch to the bottom edge
        ("seg", _pt(br, -180 - a_bot), _pt(bl, a_bot)),
        _arc(bl, a_bot, -180 + a_side),                        # BL notch to the left edge
        ("seg", _pt(bl, -180 + a_side), _pt(tl2, 180 - a_side)),
        _arc(tl2, 180 - a_side, 0),                            # round the slot end to the slot side
        ("seg", (-_NX + r, _NT + SLOT), (-_NX + r, _NT)),
        _arc(tl1, 0, -a_top),                                  # up to the top edge
        ("seg", _pt(tl1, -a_top), _pt(tr1, 180 + a_top)),
    ]
    return items


def edge_items():
    return [it[:3] if it[0] == "seg" else it[:4] for it in _outline()]


def outline_polygon(steps=12):
    poly = []
    for it in _outline():
        if it[0] == "seg":
            poly.append(it[1])
        else:
            c, a0, a1 = it[4], it[5], it[6]
            poly += [_pt(c, a0 + (a1 - a0) * k / steps) for k in range(steps)]
    return poly


PLACE = {
    "SW1": (0.0, -_a.SW_R, 90, "F"),   # UP, toward button C
    "SW2": (0.0, _a.SW_R, 90, "F"),    # DOWN
    "SW3": (-_a.SW_R, 0.0, 90, "F"),   # LEFT
    "SW4": (_a.SW_R, 0.0, 90, "F"),    # RIGHT
    # Socket on the rear, below the stick axis, opening up the facet (-y) toward the control
    # board; its plug lies over the rear face.
    "J1": (0.0, 7.4, 180, "B"),
}
# Rev C: both in the lower half (CAD joy_standoffs (-+6.5, -6.4)), out of the lower cover
# bosses' sweep along the remote's X axis. Courtyards 0.2 mm clear of SW3, SW4 and J1.
STANDOFFS = [(6.5, 6.4), (-6.5, 6.4)]

# Signal on pad 1, ground on pad 4: diagonal pads, as in rev A.
CONN = {
    "SW1": {"1": "/UP", "4": "GND"},
    "SW2": {"1": "/DOWN", "4": "GND"},
    "SW3": {"1": "/LEFT", "4": "GND"},
    "SW4": {"1": "/RIGHT", "4": "GND"},
    # Same order as J4 on the control board, for a straight 5-pin cable.
    "J1": {"1": "/UP", "2": "/DOWN", "3": "/LEFT", "4": "/RIGHT", "5": "GND"},
}
NETS = sorted({n for pads in CONN.values() for n in pads.values() if n})
POWER_NETS = {"GND": 0.3}
NC_PIN_NAMES = {}

KSC = {"lib_id": "orr:KSC221JLFS", "value": "KSC221JLFS", "footprint": "orr:KSC2_SMD_6.2x6.2mm",
       "fields": {"Manufacturer": "C&K", "MPN": "KSC221JLFS", "LCSC": "C221726"}}
SYMBOLS = {
    "SW1": dict(KSC), "SW2": dict(KSC), "SW3": dict(KSC), "SW4": dict(KSC),
    "J1": {"lib_id": "Connector_Generic:Conn_01x05", "value": "To control board",
           "footprint": "Connector_JST:JST_SH_SM05B-SRSS-TB_1x05-1MP_P1.00mm_Horizontal",
           "fields": {"MPN": "1.0-5P WT", "LCSC": "C2906271", "Description": "JST SH compatible, side entry"}},
}
for ref, s in SYMBOLS.items():
    s["uuid"] = uid("sym-" + ref)

SCH_ORDER = ["J1", "SW1", "SW2", "SW3", "SW4"]
PWR_FLAG_NETS = ["GND"]
SCH_NOTE = ("Switches: UP, DOWN, LEFT, RIGHT seen by the rider. Each switch uses a diagonal pad pair.\n"
            "Pushing the stick straight in closes all four; the firmware reads that chord as the centre press.\n"
            "J1 goes to J4 on the control board through a straight 5-pin JST SH cable (pin 1 to pin 1).")

TEXTS = [("ORR JOY REV C", 0.0, -3.5, "B", 0.8)]

# Strips along the straight edges, kept free of tracks and vias.
_e = 0.7
KEEPOUT_RECTS = [(-_a.HX, -_a.HY, _a.HX, -_a.HY + _e), (-_a.HX, _a.HY - _e, _a.HX, _a.HY),
                 (-_a.HX, -_a.HY, -_a.HX + _e, _a.HY), (_a.HX - _e, -_a.HY, _a.HX, _a.HY)]

