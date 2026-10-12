"""Shared data for gen_pcb.py and gen_sch.py: parts, placement, nets and routing.

Board coordinates: mm, seen from the top (component side). x runs along the bar (Z in the
OpenSCAD model, x = Z - 11.5), y = 0 is the front edge under the receptacle nose and -y runs
into the remote (-X in the model). The front edge sits at X = -19.63 in
mechanical/cad/complete-remote-v0.24.scad (usbc_pcb_* values there).
"""
import uuid

NS = uuid.UUID("2b8e6f47-5d1c-4a39-9e0b-7c3f1a6d4e21")


def uid(name):
    return str(uuid.uuid5(NS, name))


ROOT_UUID = uid("root")

# --- Outline and holes (match usbc_pcb in the CAD) -----------------------------------
W = 19.0          # along x; wide enough for the charge LED beside the receptacle
L = 13.6          # along -y
THICKNESS = 1.2   # GCT's recommended PCB thickness for the USB4736
OUTLINE = [(-W / 2, 0.0), (W / 2, 0.0), (W / 2, -L), (-W / 2, -L)]
MOUNT_HOLES = [(-5.4, -10.6), (5.4, -10.6)]   # M2 thread-forming screws into the rib in the housing

# --- Parts ---------------------------------------------------------------------------
J1_XY = (0.0, 0.0)       # GCT USB4736, origin on the front edge
R1_XY = (-1.0, -9.5)     # CC1 pull-down, along y
R2_XY = (1.0, -9.5)      # CC2 pull-down, along y
J2_XY = (0.0, -12.1)     # wire pads to the joystick PCB input, along x
D1_XY = (7.5, -0.91)     # charge LED, side-looking, lens 0.1 mm behind the front edge
R3_XY = (8.5, -3.7)      # LED series resistor, along y
J3_XY = (8.2, -7.0)      # LED wire pad, to a XIAO GPIO

NETS = ["GND", "VBUS", "/CC1", "/CC2", "/LED", "/LED_A"]

SYMBOLS = {
    "J1": {"lib_id": "Connector:USB_C_Receptacle_PowerOnly_6P", "value": "USB4736-GF-A",
           "footprint": "orr:GCT_USB4736",
           "fields": {"Manufacturer": "GCT", "MPN": "USB4736-GF-A-KIT",
                      "Description": "USB-C receptacle, 6 contacts, power only, IP67 with USBTJ-06 gasket"}},
    "R1": {"lib_id": "Device:R", "value": "5.1k", "footprint": "Resistor_SMD:R_0603_1608Metric",
           "fields": {"MPN": "0603WAF5101T5E", "Manufacturer": "UNI-ROYAL", "LCSC": "C23186"}},
    "R2": {"lib_id": "Device:R", "value": "5.1k", "footprint": "Resistor_SMD:R_0603_1608Metric",
           "fields": {"MPN": "0603WAF5101T5E", "Manufacturer": "UNI-ROYAL", "LCSC": "C23186"}},
    "J2": {"lib_id": "Connector_Generic:Conn_01x02", "value": "To joystick PCB", "footprint": "orr:WirePads_1x02_P2.4mm",
           "fields": {}, "in_bom": False},
    "D1": {"lib_id": "Device:LED", "value": "Red", "footprint": "orr:LED_LiteOn_LTST-S270",
           "fields": {"Manufacturer": "Lite-On", "MPN": "LTST-S270KRKT", "LCSC": "C125114",
                      "Description": "Red side-looking chip LED, charge indicator"}},
    "R3": {"lib_id": "Device:R", "value": "1k", "footprint": "Resistor_SMD:R_0603_1608Metric",
           "fields": {"MPN": "0603WAF1001T5E", "Manufacturer": "UNI-ROYAL", "LCSC": "C21190"}},
    "J3": {"lib_id": "Connector_Generic:Conn_01x01", "value": "To XIAO D8", "footprint": "orr:WirePad_1x01",
           "fields": {}, "in_bom": False},
}
for ref, s in SYMBOLS.items():
    s["uuid"] = uid("sym-" + ref)

# Pad nets by board position.
PADNETS = {
    "J1": {(-2.75, -6.35): "GND", (-1.52, -6.35): "VBUS", (-0.5, -6.35): "/CC1",
           (0.5, -6.35): "/CC2", (1.52, -6.35): "VBUS", (2.75, -6.35): "GND",
           (-4.895, -1.4): "GND", (-4.895, -4.3): "GND", (4.895, -1.4): "GND", (4.895, -4.3): "GND"},
    "R1": {(-1.0, -8.675): "/CC1", (-1.0, -10.325): "GND"},
    "R2": {(1.0, -8.675): "/CC2", (1.0, -10.325): "GND"},
    "J2": {(-1.2, -12.1): "VBUS", (1.2, -12.1): "GND"},
    "D1": {(6.5, -0.91): "GND", (8.5, -0.91): "/LED_A"},
    "R3": {(8.5, -2.875): "/LED_A", (8.5, -4.525): "/LED"},
    "J3": {(8.2, -7.0): "/LED"},
}


def net_at(ref, xy):
    for (x, y), net in PADNETS.get(ref, {}).items():
        if abs(x - xy[0]) < 0.01 and abs(y - xy[1]) < 0.01:
            return net
    return None


# --- Routing: (net, layer F/B, width, points) -------------------------------------------
TRACKS = [
    ("/CC1", "F", 0.25, [(-0.5, -7.3), (-0.5, -7.75), (-1.0, -8.25), (-1.0, -8.675)]),
    ("/CC2", "F", 0.25, [(0.5, -7.3), (0.5, -7.75), (1.0, -8.25), (1.0, -8.675)]),
    ("VBUS", "F", 0.4, [(-1.52, -7.3), (-1.52, -7.7), (-2.6, -8.4), (-2.6, -12.1), (-1.2, -12.1)]),
    ("VBUS", "F", 0.4, [(1.52, -7.3), (1.52, -7.7), (2.6, -8.4), (2.6, -10.5)]),
    ("VBUS", "B", 0.4, [(2.6, -10.5), (-2.6, -10.5)]),
    ("/LED_A", "F", 0.25, [(8.5, -0.91), (8.5, -2.875)]),
    ("/LED", "F", 0.25, [(8.5, -4.525), (8.5, -5.3), (8.2, -5.6), (8.2, -7.0)]),
]
VIAS = [
    ("VBUS", (2.6, -10.5)), ("VBUS", (-2.6, -10.5)),
    ("GND", (-4.0, -8.3)), ("GND", (4.0, -8.3)), ("GND", (-3.9, -12.9)), ("GND", (3.9, -12.9)),
    ("GND", (0.0, -9.2)),
]

# --- Silkscreen: (text, x, y, layer, size) ----------------------------------------------
TEXTS = [
    ("VBUS", -4.9, -12.6, "F", 0.8), ("GND", 4.9, -12.6, "F", 0.8),
    ("ORR USB-C V0.24", 0.0, -12.9, "B", 0.8), ("LED", 8.2, -8.6, "F", 0.8),
]
