#!/usr/bin/env python3
"""Write usbc.kicad_sch from design.py and the pad map that gen_pcb.py derives from the board.

gen_pcb.py calls main(pinmap); pinmap is {ref: {pin: (net or None, (x, y))}}.
"""
import importlib.util
import os

import design as d

HERE = os.path.dirname(os.path.abspath(__file__))

# Reuse the joystick PCB's schematic writer, pointed at this board's design data.
_spec = importlib.util.spec_from_file_location("joystick_gen_sch", os.path.join(HERE, "..", "joystick-pcb", "gen_sch.py"))
base = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(base)
base.d = d


class Sheet(base.Sheet):
    def stub(self, pin, net, length=2.54):
        if net != "VBUS":
            return super().stub(pin, net, length)
        x, y, a = pin
        dx, dy = {0: (-1, 0), 180: (1, 0), 90: (0, 1), 270: (0, -1)}[a]
        e = (x + dx * length, y + dy * length)
        self.wire((x, y), e)
        self.power("VBUS", *e)
        return e

    def write(self, path):
        libs = "\n".join(b for b, _ in self.libs.values())
        body = "\n".join(self.items)
        s = ('(kicad_sch (version 20250114) (generator "eeschema") (generator_version "9.0") (uuid "%s") (paper "A5")\n'
             '(title_block (title "Open Rally Remote - USB-C charging PCB") (date "2026-10-11") (rev "V0.24")'
             ' (comment 1 "GCT USB4736 charge-only receptacle with 5.1 k CC pull-downs"))\n'
             '(lib_symbols\n%s\n)\n%s\n(sheet_instances (path "/" (page "1")))\n(embedded_fonts no)\n)\n'
             % (d.ROOT_UUID, libs, body))
        s = s.replace('(project "joystick"', '(project "usbc"')
        open(path, "w").write(s)


def main(pinmap):
    sh = Sheet()
    sym = d.SYMBOLS

    def place(ref, x, y, side=False):
        s = sym[ref]
        return sh.symbol(s["lib_id"], ref, x, y, s["value"], s["footprint"], s.get("fields"),
                         in_bom=s.get("in_bom", True), side=side)

    def net(ref, pin):
        return pinmap[ref][pin][0]

    j1 = place("J1", 50.8, 60.96)
    # The USB-C symbol is tall: put its reference above it and its value below it.
    import re
    item = sh.items[-1]
    item = re.sub(r'\(property "Reference" "J1" \(at [-\d.]+ [-\d.]+ 0\)', '(property "Reference" "J1" (at 50.80 40.64 0)', item)
    item = re.sub(r'\(property "Value" "USB4736-GF-A" \(at [-\d.]+ [-\d.]+ 0\)', '(property "Value" "USB4736-GF-A" (at 50.80 43.18 0)', item)
    sh.items[-1] = item
    done = set()
    for p, pin in j1.items():
        n = net("J1", p)
        if pin[:2] in done:
            continue  # stacked VBUS and GND pins share one end point
        done.add(pin[:2])
        if n == "VBUS":
            sh.stub(pin, "VBUS", length=10.16)
        else:
            sh.stub(pin, n, length=5.08 if n == "GND" else 7.62)
    for i, ref in enumerate(["R1", "R2"]):
        pins = place(ref, 83.82 + 10.16 * i, 71.12, side=True)
        for p, pin in pins.items():
            n = net(ref, p)
            sh.stub(pin, n, length=2.54)
    j2 = place("J2", 111.76, 50.8)
    for p, pin in j2.items():
        n = net("J2", p)
        sh.stub(pin, n, length=5.08)
    # Power flags: the supply enters through J1 (or J2 from the other side).
    for kind, y in (("VBUS", 45.72), ("GND", 60.96)):
        sh.power(kind, 129.54, y)
        sh.wire((129.54, y), (139.70, y))
        sh.power("PWR_FLAG", 139.70, y)
    sh.text("Charge-only USB-C input. R1 and R2 pull CC1 and CC2 down to 5.1 k, which tells a USB-C\n"
            "charger to supply 5 V. VBUS and GND go by wire to the VIN and GND pads of the joystick PCB,\n"
            "which carries the PTC fuse and the TVS diode. Do not connect this port and the XIAO's own\n"
            "USB-C at the same time: both are the XIAO VBUS net.",
            25.4, 91.44)
    sh.write(os.path.join(HERE, "usbc.kicad_sch"))
