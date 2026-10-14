#!/usr/bin/env python3
"""Write control.kicad_sch from design.py and the pad map that gen_pcb.py derives from the board.

gen_pcb.py calls main(pinmap); pinmap is {ref: {pin: (net or None, (x, y))}}. Every symbol pin
ends in a short wire with a net label, a power symbol or a no-connect flag.
"""
import os
import re

import design as d

HERE = os.path.dirname(os.path.abspath(__file__))
SYMDIR = "/Applications/KiCad/KiCad.app/Contents/SharedSupport/symbols"

_n = [0]


def uid(tag):
    _n[0] += 1
    return d.uid("sch-%s-%d" % (tag, _n[0]))


def lib_symbol(lib_id):
    lib, name = lib_id.split(":")
    path = os.path.join(HERE, "orr.kicad_sym") if lib == "orr" else os.path.join(SYMDIR, lib + ".kicad_sym")
    s = open(path).read()
    i = s.index('\n\t(symbol "%s"' % name) + 1
    depth = 0
    for j in range(i, len(s)):
        if s[j] == "(":
            depth += 1
        elif s[j] == ")":
            depth -= 1
            if depth == 0:
                break
    block = s[i:j + 1]
    block = block.replace('(symbol "%s"' % name, '(symbol "%s"' % lib_id, 1)
    pins = {}
    for m in re.finditer(r'\(pin \w+ \w+\s*\(at ([-\d.]+) ([-\d.]+) (\d+)\).*?\(number "(\w*)"', block, re.S):
        pins[m.group(4)] = (float(m.group(1)), float(m.group(2)), int(m.group(3)))
    return block, pins


def eff(hide=False, justify=None):
    j = " (justify %s)" % justify if justify else ""
    h = " (hide yes)" if hide else ""
    return "(effects (font (size 1.27 1.27))%s%s)" % (j, h)


class Sheet:
    def __init__(self):
        self.items = []
        self.libs = {}
        self.pwr = 0

    def symbol(self, lib_id, ref, x, y, value, footprint="", fields=None, power=False, in_bom=True, side=False):
        if lib_id not in self.libs:
            self.libs[lib_id] = lib_symbol(lib_id)
        pins = self.libs[lib_id][1]
        u = d.SYMBOLS[ref]["uuid"] if ref in d.SYMBOLS else uid("pwr")
        if power:
            below = lib_id == "power:GND"
            rp, vp, vj = (x, y + 3.81), (x, y + 5.08 if below else y - 3.81), None
        elif side:
            # Vertical two-pin parts: reference and value to the left.
            rp, vp, vj = (x - 2.54, y - 1.27), (x - 2.54, y + 1.27), "right"
        else:
            low = 12.7 if lib_id.startswith("Connector_Generic") else 7.62
            rp, vp, vj = (x, y - 7.62 if low > 10 else y - 6.35), (x, y + low), None
        props = [
            '(property "Reference" "%s" (at %.2f %.2f 0) %s)' % (ref, rp[0], rp[1], eff(hide=power, justify=vj)),
            '(property "Value" "%s" (at %.2f %.2f 0) %s)' % (value, vp[0], vp[1], eff(justify=vj)),
            '(property "Footprint" "%s" (at %.2f %.2f 0) %s)' % (footprint, x, y, eff(hide=True)),
            '(property "Datasheet" "" (at %.2f %.2f 0) %s)' % (x, y, eff(hide=True)),
        ]
        for k, v in (fields or {}).items():
            props.append('(property "%s" "%s" (at %.2f %.2f 0) %s)' % (k, v, x, y, eff(hide=True)))
        pin_s = " ".join('(pin "%s" (uuid "%s"))' % (p, uid("pin")) for p in pins)
        self.items.append(
            '(symbol (lib_id "%s") (at %.2f %.2f 0) (unit 1) (exclude_from_sim no) (in_bom %s) (on_board %s) (dnp no)'
            ' (uuid "%s") %s %s (instances (project "control" (path "/%s" (reference "%s") (unit 1)))))'
            % (lib_id, x, y, "yes" if in_bom and not power else "no", "no" if power else "yes", u, " ".join(props), pin_s,
               d.ROOT_UUID, ref))
        # Pin end points in sheet coordinates (symbol Y is up, sheet Y is down).
        return {p: (x + px, y - py, a) for p, (px, py, a) in pins.items()}

    def power(self, kind, x, y):
        self.pwr += 1
        ref = "#PWR%02d" % self.pwr if kind != "PWR_FLAG" else "#FLG%02d" % self.pwr
        self.symbol("power:" + kind, ref, x, y, kind, power=True)

    def wire(self, a, b):
        self.items.append('(wire (pts (xy %.2f %.2f) (xy %.2f %.2f)) (stroke (width 0) (type default)) (uuid "%s"))'
                          % (a[0], a[1], b[0], b[1], uid("w")))

    def junction(self, p):
        self.items.append('(junction (at %.2f %.2f) (diameter 0) (color 0 0 0 0) (uuid "%s"))' % (p[0], p[1], uid("j")))

    def label(self, name, p, left):
        ang, just = (180, "right bottom") if left else (0, "left bottom")
        self.items.append('(label "%s" (at %.2f %.2f %d) %s (uuid "%s"))' % (name, p[0], p[1], ang, eff(justify=just), uid("l")))

    def nc(self, p):
        self.items.append('(no_connect (at %.2f %.2f) (uuid "%s"))' % (p[0], p[1], uid("nc")))

    def text(self, s, x, y):
        s = s.replace('"', '\\"').replace("\n", "\\n")
        self.items.append('(text "%s" (exclude_from_sim no) (at %.2f %.2f 0) %s (uuid "%s"))'
                          % (s, x, y, eff(justify="left top"), uid("t")))

    def stub(self, pin, net, length=2.54):
        """Wire out of a pin away from the symbol, ending in a label or a power symbol."""
        x, y, a = pin
        dx, dy = {0: (-1, 0), 180: (1, 0), 90: (0, 1), 270: (0, -1)}[a]
        e = (x + dx * length, y + dy * length)
        self.wire((x, y), e)
        if net == "GND":
            self.power("GND", *e)
        elif net == "+3V3":
            self.power("+3V3", *e)
        else:
            self.label(net.lstrip("/"), e, left=dx < 0)
        return e

    def write(self, path):
        libs = "\n".join(b for b, _ in self.libs.values())
        body = "\n".join(self.items)
        s = ('(kicad_sch (version 20250114) (generator "eeschema") (generator_version "9.0") (uuid "%s") (paper "A3")\n'
             '(title_block (title "Open Rally Remote - control board") (date "2026-10-14") (rev "V0.26")'
             ' (comment 1 "Buttons, plug-in XIAO, LiPo charger, 3.3 V regulator and sockets"))\n'
             '(lib_symbols\n%s\n)\n%s\n(sheet_instances (path "/" (page "1")))\n(embedded_fonts no)\n)\n'
             % (d.ROOT_UUID, libs, body))
        open(path, "w").write(s)


def main(pinmap):
    sh = Sheet()
    order = ["J3", "F1", "D1", "U1", "C1", "R1", "C2", "J5", "Q1", "U2", "C3", "C4",
             "R2", "R3", "R4", "R5", "R6", "R7", "C5", "J1", "J2", "J4", "SW1", "SW2", "SW3"]
    for i, ref in enumerate(order):
        s = d.SYMBOLS[ref]
        x = 38.1 + 38.1 * (i % 7)
        y = 38.1 + 40.64 * (i // 7)
        pins = sh.symbol(s["lib_id"], ref, x, y, s["value"], s["footprint"], s.get("fields"))
        for p, pin in pins.items():
            n = pinmap[ref].get(p, (None, None))[0]
            if n:
                sh.stub(pin, n)
            else:
                sh.nc(pin[:2])
    # Power flags on the nets that only passive parts or inputs drive.
    for i, n in enumerate(["GND", "/VBUS", "/VBUS_IN", "/BAT"]):
        x, y = 38.1 + 25.4 * i, 210.82
        sh.power("PWR_FLAG", x, y)
        if n == "GND":
            sh.power("GND", x, y)
        else:
            sh.label(n.lstrip("/"), (x, y), left=False)
    sh.text("Power: USB-C VBUS_IN -> F1 -> VBUS (D1 clamps) -> U1 MCP73831 charger, 100 mA (R1).\n"
            "Battery: J5 -> Q1 (reverse polarity) -> BAT_SYS -> U2 TPS70933 -> +3V3 -> XIAO 3V3 pin.\n"
            "Sense: BAT_SYS / 2 -> D0 (A0); STAT x 2/3 -> D8; VBUS x 2/3 -> D9. STAT also sinks the\n"
            "charge LED on the USB-C board (J3 pin 3), lit only while charging.\n"
            "XIAO headers J1 (D0-D6) and J2 (5V, GND, 3V3, D10, D9, D8, D7); 5V and D10 open.",
            30.48, 220.98)
    sh.write(os.path.join(HERE, "control.kicad_sch"))
