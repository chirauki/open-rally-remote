"""Shared data for gen_pcb.py and gen_sch.py: parts, placement, nets and routing.

Board coordinates: mm from the board centre (stick axis), seen from the front (switch side,
facing the cover), +x to the rider's right, +y down the facet (away from button C).
Joystick frame in the OpenSCAD model: X = -x, Y = -y.
"""
import math
import uuid

NS = uuid.UUID("6f1d2c1e-3b7a-4f0e-9a51-0e5a0c7d2b10")


def uid(name):
    return str(uuid.uuid5(NS, name))


ROOT_UUID = uid("root")

# --- Outline (matches joy_pcb_hx, joy_pcb_hy, joy_pcb_notch_r, joy_boss_xy() in the CAD) --
HX, HY = 10.3, 11.2
NOTCH_R = 3.3
# Lower cover-screw bosses, frame (+-9.75, 11.0) and (+-9.75, -10.8).
NOTCHES = {(-1, -1): (-9.75, -11.0), (1, -1): (9.75, -11.0), (1, 1): (9.75, 10.8), (-1, 1): (-9.75, 10.8)}


def _corner_points(sx, sy):
    cx, cy = NOTCHES[(sx, sy)]
    dy = math.sqrt(NOTCH_R ** 2 - (HX - abs(cx)) ** 2)
    dx = math.sqrt(NOTCH_R ** 2 - (HY - abs(cy)) ** 2)
    on_side = (sx * HX, cy - sy * dy)       # on the x = +-HX edge
    on_end = (cx - sx * dx, sy * HY)        # on the y = +-HY edge
    a0 = math.atan2(on_side[1] - cy, on_side[0] - cx)
    a1 = math.atan2(on_end[1] - cy, on_end[0] - cx)
    # The arc runs on the board side, i.e. the short way between the two angles.
    da = (a1 - a0 + math.pi) % (2 * math.pi) - math.pi
    return on_side, on_end, (cx, cy), a0, da


def _arc(c, start_on_side):
    side, end, ctr, a0, da = _corner_points(*c)
    if start_on_side:
        return side, end, ctr, a0, da
    return end, side, ctr, a0 + da, -da


def outline_path():
    """Edge.Cuts as ('seg', (a, b)) and ('arc', (start, mid, end)), clockwise on screen."""
    # Corner order TL, TR, BR, BL (y down); each arc starts on the edge we arrive along.
    corners = [((-1, -1), True), ((1, -1), False), ((1, 1), True), ((-1, 1), False)]
    arcs = []
    for c, from_side in corners:
        st, en, ctr, a0, da = _arc(c, from_side)
        am = a0 + da / 2
        arcs.append((st, (ctr[0] + NOTCH_R * math.cos(am), ctr[1] + NOTCH_R * math.sin(am)), en, ctr, a0, da))
    path = []
    for i, arc in enumerate(arcs):
        path.append(("arc", arc[:3]))
        path.append(("seg", (arc[2], arcs[(i + 1) % 4][0])))
    return path, arcs


def outline_polygon(steps=12):
    path, arcs = outline_path()
    poly = []
    for st, mid, en, ctr, a0, da in arcs:
        for k in range(steps + 1):
            t = a0 + da * k / steps
            poly.append((ctr[0] + NOTCH_R * math.cos(t), ctr[1] + NOTCH_R * math.sin(t)))
    return poly


# --- Parts ---------------------------------------------------------------------------
SW_R = 6.75
SWITCHES = {"SW1": (0.0, -SW_R), "SW2": (0.0, SW_R), "SW3": (-SW_R, 0.0), "SW4": (SW_R, 0.0)}
SW_NAMES = {"SW1": "UP", "SW2": "DOWN", "SW3": "LEFT", "SW4": "RIGHT"}
F1_XY = (-4.2, -6.9)
D1_XY = (-4.4, -2.6)
J1_XY = (-8.6, 2.4)
J2_XY = (0.0, -10.0)
# Standoffs: frame (-6.0, 6.4) and (6.0, -6.4) in the CAD.
STANDOFFS_K = [(6.0, -6.4), (-6.0, 6.4)]

NETS = ["GND", "+5V", "/VIN", "/UP", "/DOWN", "/LEFT", "/RIGHT"]

LCSC = {"KSC222JLFS": "C221728", "MF-MSMF050-2": "C17313", "SMBJ5.0A": "C83333"}
SYMBOLS = {}
for ref in SWITCHES:
    SYMBOLS[ref] = {"lib_id": "orr:KSC222JLFS", "value": "KSC222JLFS", "footprint": "orr:KSC2_SMD_6.2x6.2mm",
                    "fields": {"Manufacturer": "C&K", "MPN": "KSC222JLFS", "LCSC": "C221728"}}
SYMBOLS["F1"] = {"lib_id": "Device:Polyfuse", "value": "MF-MSMF050-2", "footprint": "Fuse:Fuse_1812_4532Metric",
                 "fields": {"Manufacturer": "Bourns", "MPN": "MF-MSMF050-2", "LCSC": "C17313",
                            "Description": "PTC resettable fuse, 0.5 A hold, 1 A trip, 15 V, 1812"}}
SYMBOLS["D1"] = {"lib_id": "Device:D_Zener", "value": "SMBJ5.0A", "footprint": "Diode_SMD:D_SMB",
                 "fields": {"Manufacturer": "Littelfuse", "MPN": "SMBJ5.0A", "LCSC": "C83333",
                            "Description": "Unidirectional TVS, 600 W, 5.0 V stand-off, SMB"}}
SYMBOLS["J1"] = {"lib_id": "Connector_Generic:Conn_01x02", "value": "Supply in", "footprint": "orr:WirePads_1x02_P2.4mm",
                 "fields": {}, "in_bom": False}
SYMBOLS["J2"] = {"lib_id": "Connector_Generic:Conn_01x06", "value": "To XIAO", "footprint": "orr:WirePads_1x06_P2.1mm",
                 "fields": {}, "in_bom": False}
for ref, s in SYMBOLS.items():
    s["uuid"] = uid("sym-" + ref)

# Pad nets by board position. Switch signal and ground pads are diagonal opposites.
PADNETS = {
    "SW1": {(2.0, -3.75): "/UP", (-2.0, -9.75): "GND"},
    "SW2": {(2.0, 3.75): "/DOWN", (-2.0, 9.75): "GND"},
    "SW3": {(-8.75, -3.0): "/LEFT", (-4.75, 3.0): "GND"},
    "SW4": {(4.75, -3.0): "/RIGHT", (8.75, 3.0): "GND"},
    "F1": {(-6.338, -6.9): "/VIN", (-2.062, -6.9): "+5V"},
    "D1": {(-6.55, -2.6): "GND", (-2.25, -2.6): "+5V"},
    "J1": {(-8.6, 1.2): "/VIN", (-8.6, 3.6): "GND"},
    "J2": {(-5.25, -10.0): "/LEFT", (-3.15, -10.0): "GND", (-1.05, -10.0): "+5V",
           (1.05, -10.0): "/UP", (3.15, -10.0): "/DOWN", (5.25, -10.0): "/RIGHT"},
}


def net_at(ref, xy):
    for (x, y), net in PADNETS.get(ref, {}).items():
        if abs(x - xy[0]) < 0.01 and abs(y - xy[1]) < 0.01:
            return net
    return None


# --- Routing: (net, layer F/B, width, points) -------------------------------------------
TRACKS = [
    ("/VIN", "B", 0.8, [(-8.6, 1.2), (-8.6, -4.6), (-6.338, -6.862), (-6.338, -6.9)]),
    ("+5V", "B", 0.8, [(-2.062, -6.9), (-2.25, -2.6)]),
    ("+5V", "B", 0.8, [(-2.062, -6.9), (-2.062, -8.9), (-1.05, -9.912), (-1.05, -10.0)]),
    ("/UP", "F", 0.25, [(2.0, -3.75), (2.0, -2.0)]),
    ("/UP", "B", 0.25, [(2.0, -2.0), (1.05, -2.95), (1.05, -10.0)]),
    ("/DOWN", "F", 0.25, [(2.0, 3.75), (2.0, 2.0)]),
    ("/DOWN", "B", 0.25, [(2.0, 2.0), (3.15, 0.85), (3.15, -10.0)]),
    ("/RIGHT", "F", 0.25, [(4.75, -3.0), (4.75, -4.75)]),
    ("/RIGHT", "B", 0.25, [(4.75, -4.75), (4.3, -5.2), (4.3, -8.15), (5.25, -9.1), (5.25, -10.0)]),
    ("/LEFT", "F", 0.25, [(-8.75, -3.0), (-8.75, -5.0), (-5.25, -8.5), (-5.25, -10.0)]),
]
VIAS = [
    ("/UP", (2.0, -2.0)), ("/DOWN", (2.0, 2.0)), ("/RIGHT", (4.75, -4.75)), ("/LEFT", (-5.25, -10.0)),
    ("GND", (0.0, 0.0)), ("GND", (-4.5, 8.5)), ("GND", (7.5, 7.0)), ("GND", (-7.5, -7.5)),
    ("GND", (-3.9, -8.6)), ("GND", (9.0, -5.5)),
]

# --- Silkscreen: (text, x, y, layer, size) ----------------------------------------------
TEXTS = [
    ("L", -5.25, -8.55, "B", 0.8), ("G", -3.15, -8.55, "B", 0.8), ("5V", -0.65, -8.55, "B", 0.8),
    ("U", 1.05, -8.55, "B", 0.8), ("D", 3.15, -8.55, "B", 0.8), ("R", 5.25, -8.55, "B", 0.8),
    ("VIN", -6.0, 1.2, "B", 0.8), ("GND", -6.0, 3.6, "B", 0.8),
    ("ORR JOY V0.23", 1.5, 8.2, "B", 0.8),
]
