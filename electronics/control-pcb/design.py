"""Shared data for gen_pcb.py and gen_sch.py: outline, parts, placement and nets.

Board coordinates: mm, seen from the front (F, the switch side, facing the cover). x runs
along the bar: x = Z - 11.5 in mechanical/cad/complete-remote-v0.26.scad. y runs down the
upper facet: y = 16.5 - Y, so the board (Y = -8 to 41) spans y = -24.5 to 24.5.
The back (B) carries the XIAO headers, the power parts and the sockets.
"""
import math
import uuid

NS = uuid.UUID("3c9d1e52-7a4b-4c1f-8e6d-2b5a9f0c7e13")


def uid(name):
    return str(uuid.uuid5(NS, name))


ROOT_UUID = uid("root")
PROJECT = "control"
TITLE = "Open Rally Remote - control board"
SUBTITLE = "Buttons, plug-in XIAO, LiPo charger, 3.3 V regulator and sockets"
SCH_ORDER = ["J3", "F1", "D1", "U1", "C1", "R1", "C2", "J5", "Q1", "U2", "C3", "C4",
             "R2", "R3", "R4", "R5", "R6", "R7", "C5", "J1", "J2", "J4", "SW1", "SW2", "SW3"]
PWR_FLAG_NETS = ["GND", "/VBUS", "/VBUS_IN", "/BAT"]
SCH_NOTE = ("Power: USB-C VBUS_IN -> F1 -> VBUS (D1 clamps) -> U1 MCP73831 charger, 100 mA (R1).\n"
            "Battery: J5 -> Q1 (reverse polarity) -> BAT_SYS -> U2 TPS70933 -> +3V3 -> XIAO 3V3 pin.\n"
            "Sense: BAT_SYS / 2 -> D0 (A0); STAT x 2/3 -> D8 (high when charging is done); VBUS x 2/3 -> D9.\n"
            "STAT also sinks the charge LED on the USB-C board (J3 pin 3), lit only while charging.\n"
            "XIAO headers J1 (D0-D6) and J2 (5V, GND, 3V3, D10, D9, D8, D7); 5V and D10 open.")

# --- Outline (matches ctrl_pcb_y, ctrl_pcb_clear and the upper cover bosses in the CAD) --
HX = 10.7                     # (22 mm cavity - 2 x 0.3) / 2
Y0, Y1 = -24.5, 24.5
NOTCH_R = 3.3                 # boss radius 3.0 + 0.3
NOTCH_X = 9.75                # boss axes, Z = 1.75 and 21.25
NOTCH_Y = [-24.0, -7.5, 22.5]  # bosses at Y = 40.5, 24, -6
THICKNESS = 1.6


def y_of(Y):
    return 16.5 - Y


# --- Placement: ref -> (x, y, rotation, side) -------------------------------------------
PLACE = {
    # front: button switches under the keys (Y = 33, 15, -3)
    "SW1": (0.0, y_of(33.0), 90, "F"),
    "SW2": (0.0, y_of(15.0), 90, "F"),
    "SW3": (0.0, y_of(-3.0), 90, "F"),
    # back: XIAO headers, pin 1 at the USB-C end (Y = 1.38), D0-D6 on the -Z side
    "J1": (-7.62, y_of(1.38), 180, "B"),
    "J2": (7.62, y_of(1.38), 180, "B"),
    # back: sockets
    "J3": (-3.0, -20.5, 180, "B"),      # USB-C board, opening toward +Y (top)
    "J4": (0.0, 20.0, 0, "B"),          # joystick, opening toward -Y (fold)
    "J5": (5.6, -16.0, 270, "B"),       # battery, opening toward +Z
    # back: 5 V input protection
    "F1": (-4.0, -14.0, 0, "B"),
    "D1": (-3.0, -7.9, 90, "B"),
    # back, under the XIAO: charger, regulator, reverse-polarity FET, dividers
    "U1": (-3.6, 2.0, 0, "B"),
    "C1": (0.2, 0.9, 0, "B"),
    "C2": (0.2, 2.9, 0, "B"),
    "R1": (-3.6, -0.6, 0, "B"),
    "Q1": (3.9, 3.4, 0, "B"),
    "U2": (-3.6, 6.4, 0, "B"),
    "C3": (0.2, 5.4, 0, "B"),
    "C4": (0.2, 7.4, 0, "B"),
    "R2": (3.7, 6.0, 0, "B"),
    "R3": (3.7, 7.8, 0, "B"),
    "R4": (-0.2, 12.4, 0, "B"),
    "R5": (-0.2, 14.2, 0, "B"),
    "R6": (3.7, 12.4, 0, "B"),
    "R7": (3.7, 14.2, 0, "B"),
    "C5": (3.7, 10.6, 0, "B"),
}
STANDOFFS = [(3.95, y_of(24.0)), (-3.95, y_of(6.0))]
FULL_ZONE_REFS = ["J1", "J2"]   # XIAO header pins: solid connection to the pours   # btn_standoffs in the CAD (Z offset = x)

# --- Nets by pad number -------------------------------------------------------------------
CONN = {
    "SW1": {"1": "/BTN_A", "4": "GND"},
    "SW2": {"1": "/BTN_B", "4": "GND"},
    "SW3": {"1": "/BTN_C", "4": "GND"},
    # XIAO D0-D6 column
    "J1": {"1": "/VBAT_SENSE", "2": "/BTN_A", "3": "/BTN_B", "4": "/BTN_C",
           "5": "/JOY_UP", "6": "/JOY_DOWN", "7": "/JOY_LEFT"},
    # XIAO 5V, GND, 3V3, D10, D9, D8, D7 column
    "J2": {"1": None, "2": "GND", "3": "+3V3", "4": None, "5": "/VBUS_SENSE", "6": "/CHG_SENSE",
           "7": "/JOY_RIGHT"},
    "J3": {"1": "/VBUS_IN", "2": "GND", "3": "/STAT"},
    "J4": {"1": "/JOY_UP", "2": "/JOY_DOWN", "3": "/JOY_LEFT", "4": "/JOY_RIGHT", "5": "GND"},
    "J5": {"1": "/BAT", "2": "GND"},
    "F1": {"1": "/VBUS_IN", "2": "/VBUS"},
    "D1": {"1": "/VBUS", "2": "GND"},
    "U1": {"1": "/STAT", "2": "GND", "3": "/BAT_SYS", "4": "/VBUS", "5": "/PROG"},
    "C1": {"1": "/VBUS", "2": "GND"},
    "C2": {"1": "/BAT_SYS", "2": "GND"},
    "R1": {"1": "/PROG", "2": "GND"},
    "Q1": {"1": "GND", "2": "/BAT_SYS", "3": "/BAT"},
    "U2": {"1": "/BAT_SYS", "2": "GND", "3": "/BAT_SYS", "4": None, "5": "+3V3"},
    "C3": {"1": "/BAT_SYS", "2": "GND"},
    "C4": {"1": "+3V3", "2": "GND"},
    "R2": {"1": "/STAT", "2": "/CHG_SENSE"},
    "R3": {"1": "/CHG_SENSE", "2": "GND"},
    "R4": {"1": "/VBUS", "2": "/VBUS_SENSE"},
    "R5": {"1": "/VBUS_SENSE", "2": "GND"},
    "R6": {"1": "/BAT_SYS", "2": "/VBAT_SENSE"},
    "R7": {"1": "/VBAT_SENSE", "2": "GND"},
    "C5": {"1": "/VBAT_SENSE", "2": "GND"},
}
NETS = sorted({n for pads in CONN.values() for n in pads.values() if n})
POWER_NETS = {"/VBUS": 0.4, "/VBUS_IN": 0.4, "/BAT": 0.4, "/BAT_SYS": 0.4, "+3V3": 0.3, "GND": 0.3}

R0603, C0603 = "Resistor_SMD:R_0603_1608Metric", "Capacitor_SMD:C_0603_1608Metric"


def res(value, mpn, lcsc):
    return {"lib_id": "Device:R", "value": value, "footprint": R0603,
            "fields": {"Manufacturer": "UNI-ROYAL", "MPN": mpn, "LCSC": lcsc}}


def cap(value, mpn, lcsc):
    return {"lib_id": "Device:C", "value": value, "footprint": C0603,
            "fields": {"Manufacturer": "Samsung", "MPN": mpn, "LCSC": lcsc}}


KSC = {"lib_id": "orr:KSC221JLFS", "value": "KSC221JLFS", "footprint": "orr:KSC2_SMD_6.2x6.2mm",
       "fields": {"Manufacturer": "C&K", "MPN": "KSC221JLFS", "LCSC": "C221726"}}
SYMBOLS = {
    "SW1": dict(KSC), "SW2": dict(KSC), "SW3": dict(KSC),
    "J1": {"lib_id": "Connector:Conn_01x07_Socket", "value": "XIAO D0-D6",
           "footprint": "Connector_PinSocket_2.54mm:PinSocket_1x07_P2.54mm_Vertical",
           "fields": {"MPN": "PM2.54-1x7PZZ-H5.7", "LCSC": "C55218877",
                      "Description": "1x7 female header, 5.7 mm high, for the XIAO's pins"}},
    "J2": {"lib_id": "Connector:Conn_01x07_Socket", "value": "XIAO 5V-D7",
           "footprint": "Connector_PinSocket_2.54mm:PinSocket_1x07_P2.54mm_Vertical",
           "fields": {"MPN": "PM2.54-1x7PZZ-H5.7", "LCSC": "C55218877",
                      "Description": "1x7 female header, 5.7 mm high, for the XIAO's pins"}},
    "J3": {"lib_id": "Connector_Generic:Conn_01x03", "value": "USB-C board",
           "footprint": "Connector_JST:JST_SH_SM03B-SRSS-TB_1x03-1MP_P1.00mm_Horizontal",
           "fields": {"MPN": "1.0-3P WT", "LCSC": "C2906269", "Description": "JST SH compatible, side entry"}},
    "J4": {"lib_id": "Connector_Generic:Conn_01x05", "value": "Joystick",
           "footprint": "Connector_JST:JST_SH_SM05B-SRSS-TB_1x05-1MP_P1.00mm_Horizontal",
           "fields": {"MPN": "1.0-5P WT", "LCSC": "C2906271", "Description": "JST SH compatible, side entry"}},
    "J5": {"lib_id": "Connector_Generic:Conn_01x02", "value": "Battery",
           "footprint": "Connector_JST:JST_PH_S2B-PH-SM4-TB_1x02-1MP_P2.00mm_Horizontal",
           "fields": {"Manufacturer": "JST", "MPN": "S2B-PH-SM4-TB(LF)(SN)", "LCSC": "C295747"}},
    "F1": {"lib_id": "Device:Polyfuse", "value": "MF-MSMF050-2", "footprint": "Fuse:Fuse_1812_4532Metric",
           "fields": {"Manufacturer": "Bourns", "MPN": "MF-MSMF050-2", "LCSC": "C17313"}},
    "D1": {"lib_id": "Device:D_Zener", "value": "SMBJ5.0A", "footprint": "Diode_SMD:D_SMB",
           "fields": {"Manufacturer": "Littelfuse", "MPN": "SMBJ5.0A", "LCSC": "C78423",
                      "Description": "5 V TVS, unidirectional"}},
    "U1": {"lib_id": "Battery_Management:MCP73831-2-OT", "value": "MCP73831T-2ACI/OT",
           "footprint": "Package_TO_SOT_SMD:SOT-23-5",
           "fields": {"Manufacturer": "Microchip", "MPN": "MCP73831T-2ACI/OT", "LCSC": "C424093"}},
    "U2": {"lib_id": "Regulator_Linear:MIC5504-3.3YM5", "value": "TPS70933DBVR",
           "footprint": "Package_TO_SOT_SMD:SOT-23-5",
           "fields": {"Manufacturer": "TI", "MPN": "TPS70933DBVR", "LCSC": "C89347",
                      "Description": "3.3 V LDO, 1 uA Iq, reverse current protection; same pinout as the symbol"}},
    "Q1": {"lib_id": "Transistor_FET:Q_PMOS_GSD", "value": "AO3401A", "footprint": "Package_TO_SOT_SMD:SOT-23",
           "fields": {"Manufacturer": "Alpha & Omega", "MPN": "AO3401A", "LCSC": "C15127",
                      "Description": "Battery reverse-polarity protection"}},
    "C1": cap("4.7u", "CL10A475KO8NNNC", "C19666"),
    "C2": cap("4.7u", "CL10A475KO8NNNC", "C19666"),
    "C3": cap("2.2u", "CL10A225KO8NNNC", "C23630"),
    "C4": cap("2.2u", "CL10A225KO8NNNC", "C23630"),
    "C5": {"lib_id": "Device:C", "value": "100n", "footprint": C0603,
           "fields": {"Manufacturer": "Yageo", "MPN": "CC0603KRX7R9BB104", "LCSC": "C14663"}},
    "R1": res("10k", "0603WAF1002T5E", "C25804"),
    "R2": res("100k", "0603WAF1003T5E", "C25803"),
    "R3": res("200k", "0603WAF2003T5E", "C25811"),
    "R4": res("100k", "0603WAF1003T5E", "C25803"),
    "R5": res("200k", "0603WAF2003T5E", "C25811"),
    "R6": res("1M", "0603WAF1004T5E", "C22935"),
    "R7": res("1M", "0603WAF1004T5E", "C22935"),
}
for ref, s in SYMBOLS.items():
    s["uuid"] = uid("sym-" + ref)

TEXTS = [
    ("ORR CONTROL V0.26", 0.0, -11.0, "F", 0.8),
]

# Schematic pin names of the open pins, for the no-connect net names in the parity check.
NC_PIN_NAMES = {("J2", "1"): "Pin_1", ("J2", "4"): "Pin_4", ("U2", "4"): "NC"}


def _arc(cx, cy, p0, p1):
    """Notch arc from p0 to p1 round (cx, cy), through the board side (towards x = 0)."""
    a0 = math.atan2(p0[1] - cy, p0[0] - cx)
    a1 = math.atan2(p1[1] - cy, p1[0] - cx)
    for da in ((a1 - a0) % (2 * math.pi), (a1 - a0) % (2 * math.pi) - 2 * math.pi):
        am = a0 + da / 2
        mid = (cx + NOTCH_R * math.cos(am), cy + NOTCH_R * math.sin(am))
        if abs(mid[0]) < abs(cx):
            return ("arc", p0, mid, p1)
    raise ValueError("no notch arc")


def edge_items():
    """Edge.Cuts as ('seg', a, b) and ('arc', start, mid, end), one closed loop, clockwise on screen.

    The top and bottom notches cut the board corners; the middle one cuts the sides."""
    dy = math.sqrt(NOTCH_R ** 2 - (HX - NOTCH_X) ** 2)      # half chord on a side edge
    top, mid, bot = sorted(NOTCH_Y)
    dxt = math.sqrt(NOTCH_R ** 2 - (top - Y0) ** 2)          # half chord on the top edge
    dxb = math.sqrt(NOTCH_R ** 2 - (Y1 - bot) ** 2)          # half chord on the bottom edge
    loop = [
        ("seg", (-NOTCH_X + dxt, Y0), (NOTCH_X - dxt, Y0)),
        _arc(NOTCH_X, top, (NOTCH_X - dxt, Y0), (HX, top + dy)),
        ("seg", (HX, top + dy), (HX, mid - dy)),
        _arc(NOTCH_X, mid, (HX, mid - dy), (HX, mid + dy)),
        ("seg", (HX, mid + dy), (HX, bot - dy)),
        _arc(NOTCH_X, bot, (HX, bot - dy), (NOTCH_X - dxb, Y1)),
        ("seg", (NOTCH_X - dxb, Y1), (-NOTCH_X + dxb, Y1)),
        _arc(-NOTCH_X, bot, (-NOTCH_X + dxb, Y1), (-HX, bot - dy)),
        ("seg", (-HX, bot - dy), (-HX, mid + dy)),
        _arc(-NOTCH_X, mid, (-HX, mid + dy), (-HX, mid - dy)),
        ("seg", (-HX, mid - dy), (-HX, top + dy)),
        _arc(-NOTCH_X, top, (-HX, top + dy), (-NOTCH_X + dxt, Y0)),
    ]
    return loop


def outline_polygon(step_deg=10):
    """The outline as a polygon, for the copper pours."""
    poly = []
    for it in edge_items():
        if it[0] == "seg":
            poly.append(it[1])
        else:
            _, a, m, b = it
            # circle through a, m, b
            ax, ay = a; mx, my = m; bx, by = b
            d = 2 * (ax * (my - by) + mx * (by - ay) + bx * (ay - my))
            ux = ((ax * ax + ay * ay) * (my - by) + (mx * mx + my * my) * (by - ay) + (bx * bx + by * by) * (ay - my)) / d
            uy = ((ax * ax + ay * ay) * (bx - mx) + (mx * mx + my * my) * (ax - bx) + (bx * bx + by * by) * (mx - ax)) / d
            r = math.hypot(ax - ux, ay - uy)
            a0 = math.atan2(ay - uy, ax - ux); a1 = math.atan2(my - uy, mx - ux); a2 = math.atan2(by - uy, bx - ux)
            def norm(t): return (t - a0) % (2 * math.pi)
            ccw = norm(a1) < norm(a2)
            span = norm(a2) if ccw else -((a0 - a2) % (2 * math.pi))
            n = max(2, int(abs(math.degrees(span)) / step_deg))
            for k in range(n):
                t = a0 + span * k / n
                poly.append((ux + r * math.cos(t), uy + r * math.sin(t)))
    return poly
