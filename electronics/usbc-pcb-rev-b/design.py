"""Shared data for gen_pcb.py and gen_sch.py: the V0.26 USB-C charging board (rev B).

Rev B keeps the rev A receptacle, CC pull-downs, charge LED and mounting holes
(electronics/usbc-pcb). The wire pads become one JST SH-compatible socket, the LED now hangs
from VBUS and is switched by the charger's STAT pin on the control board, and the board grows
from 13.6 to 16.0 mm deep to make room for the socket behind the receptacle.

Board coordinates: mm, seen from the top (component side). x runs along the bar (Z in the
OpenSCAD model, x = Z - 11.5), y = 0 is the front edge under the receptacle nose and -y runs
into the remote (-X in the model).
"""
import uuid

NS = uuid.UUID("5d7e2a91-3c4f-4e6b-8a1d-9b0c2e3f4a5b")


def uid(name):
    return str(uuid.uuid5(NS, name))


ROOT_UUID = uid("root")
PROJECT = "usbc"
TITLE = "Open Rally Remote - USB-C charging board, rev B"
SUBTITLE = "Sealed charge-only receptacle, CC pull-downs, charge LED, socket to the control board"
THICKNESS = 1.2   # GCT's recommended PCB thickness for the USB4736

W = 19.0
L = 16.0
OUTLINE = [(-W / 2, 0.0), (W / 2, 0.0), (W / 2, -L), (-W / 2, -L)]


def edge_items():
    return [("seg", a, b) for a, b in zip(OUTLINE, OUTLINE[1:] + OUTLINE[:1])]


def outline_polygon():
    return OUTLINE


NOTCH_CENTRES = []
STANDOFFS = [(-7.0, -10.6), (7.0, -10.6)]   # M2 thread-forming screws into the rib; 5.4 in rev A, moved out for J2
HOLE_FP = "MountingHole:MountingHole_2.2mm_M2"

PLACE = {
    "J1": (0.0, 0.0, 0, "F"),        # GCT USB4736, origin on the front edge
    "R1": (-7.0, -7.2, 0, "F"),      # CC1 pull-down
    "R2": (7.0, -7.2, 0, "F"),       # CC2 pull-down
    "D1": (7.5, -0.91, 0, "F"),      # charge LED, side-looking, lens 0.1 mm behind the front edge
    "R3": (8.5, -3.7, 90, "F"),      # LED series resistor
    "J2": (0.0, -12.9, 180, "F"),    # socket to the control board, opening toward -y (into the remote)
}

CONN = {
    "J1": {"A12": "GND", "B12": "GND", "A9": "/VBUS", "B9": "/VBUS", "A5": "/CC1", "B5": "/CC2", "SH": "GND"},
    "R1": {"1": "/CC1", "2": "GND"},
    "R2": {"1": "/CC2", "2": "GND"},
    "D1": {"1": "/LED_K", "2": "/LED_A"},
    "R3": {"1": "/LED_A", "2": "/VBUS"},
    # Same order as J3 on the control board: VBUS, GND, LED cathode (to the charger's STAT).
    "J2": {"1": "/VBUS", "2": "GND", "3": "/LED_K"},
}
NETS = sorted({n for pads in CONN.values() for n in pads.values() if n})
POWER_NETS = {"/VBUS": 0.4, "GND": 0.4}
NC_PIN_NAMES = {}

SYMBOLS = {
    "J1": {"lib_id": "Connector:USB_C_Receptacle_PowerOnly_6P", "value": "USB4736-GF-A", "footprint": "orr:GCT_USB4736",
           "fields": {"Manufacturer": "GCT", "MPN": "USB4736-GF-A-KIT", "LCSC": "C9900206672",
                      "Description": "USB-C receptacle, 6 contacts, power only, IP67 with USBTJ-06 gasket"}},
    "R1": {"lib_id": "Device:R", "value": "5.1k", "footprint": "Resistor_SMD:R_0603_1608Metric",
           "fields": {"MPN": "0603WAF5101T5E", "Manufacturer": "UNI-ROYAL", "LCSC": "C23186"}},
    "R2": {"lib_id": "Device:R", "value": "5.1k", "footprint": "Resistor_SMD:R_0603_1608Metric",
           "fields": {"MPN": "0603WAF5101T5E", "Manufacturer": "UNI-ROYAL", "LCSC": "C23186"}},
    "D1": {"lib_id": "Device:LED", "value": "Red", "footprint": "orr:LED_LiteOn_LTST-S270",
           "fields": {"Manufacturer": "Lite-On", "MPN": "LTST-S270KRKT", "LCSC": "C125114",
                      "Description": "Red side-looking chip LED, charge indicator"}},
    "R3": {"lib_id": "Device:R", "value": "1k", "footprint": "Resistor_SMD:R_0603_1608Metric",
           "fields": {"MPN": "RC0603FR-071KL", "Manufacturer": "YAGEO", "LCSC": "C22548"}},
    "J2": {"lib_id": "Connector_Generic:Conn_01x03", "value": "To control board",
           "footprint": "Connector_JST:JST_SH_SM03B-SRSS-TB_1x03-1MP_P1.00mm_Horizontal",
           "fields": {"MPN": "1.0-3P WT", "LCSC": "C2906269", "Description": "JST SH compatible, side entry"}},
}
for ref, s in SYMBOLS.items():
    s["uuid"] = uid("sym-" + ref)

SCH_ORDER = ["J1", "R1", "R2", "D1", "R3", "J2"]
PWR_FLAG_NETS = ["GND", "/VBUS"]
SCH_NOTE = ("VBUS and GND go to the control board, which fuses, clamps and charges.\n"
            "The charge LED D1 hangs from VBUS through R3; the charger's STAT pin on the control board\n"
            "sinks its cathode (J2 pin 3) while charging, so it lights only then, from the charger supply.")
TEXTS = [("ORR USB-C REV B", 0.0, -15.2, "B", 0.8)]
