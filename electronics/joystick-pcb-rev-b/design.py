"""Shared data for gen_pcb.py and gen_sch.py: the V0.26 joystick board (rev B).

Rev B keeps the rev A outline, switches and standoffs (electronics/joystick-pcb). The 5 V input
protection moves to the control board, and the wire pads become one JST SH-compatible socket.

Board coordinates: mm from the board centre (stick axis), seen from the front (switch side,
facing the cover), +x to the rider's right, +y down the facet (away from button C).
Joystick frame in the OpenSCAD model: X = -x, Y = -y.
"""
import importlib.util
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
TITLE = "Open Rally Remote - joystick board, rev B"
SUBTITLE = "Four C&K KSC2 switches under the stick disc, one socket to the control board"
THICKNESS = 1.6

# Rev A outline: rectangle with a notch round each lower cover-screw boss.
NOTCH_R = _a.NOTCH_R
NOTCH_CENTRES = list(_a.NOTCHES.values())


def edge_items():
    path, _ = _a.outline_path()
    return [("seg", it[1][0], it[1][1]) if it[0] == "seg" else ("arc",) + tuple(it[1]) for it in path]


def outline_polygon():
    return _a.outline_polygon()


PLACE = {
    "SW1": (0.0, -_a.SW_R, 90, "F"),   # UP, toward button C
    "SW2": (0.0, _a.SW_R, 90, "F"),    # DOWN
    "SW3": (-_a.SW_R, 0.0, 90, "F"),   # LEFT
    "SW4": (_a.SW_R, 0.0, 90, "F"),    # RIGHT
    # Socket on the rear, in the tall rear zone (y <= -0.5), opening up the facet (-y)
    # toward the control board.
    "J1": (-0.5, -7.4, 180, "B"),
}
STANDOFFS = _a.STANDOFFS_K

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

TEXTS = [("ORR JOY REV B", 1.5, 8.2, "B", 0.8)]

