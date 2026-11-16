#!/usr/bin/env python3
"""Tests for V0.35: the keypad sheet is thinned to key_web_t in the ring round each key, from
the cover side, so a soft TPU key trips the switch with a light press.

Run from the repository root:
  python3 -m unittest mechanical/cad/tools/test_v035.py -v
"""
import math
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import assembly_video as av  # noqa: E402
import test_seal as ts  # noqa: E402

SCAD34 = av.CAD / "complete-remote-v0.34.scad"
SCAD35 = av.CAD / "complete-remote-v0.35.scad"
TOL = ts.TOL
KEYS = 3
RING_AREA = math.pi / 4 * (16.4 ** 2 - 12.0 ** 2)   # key_groove_d and key_d
BACK = math.pi / 4 * (16.38 ** 2 - 12.02 ** 2)


def echo(expr, name, defs=None, scad=SCAD35):
    return ts.echo(expr, "v35_" + name, defs, scad=scad)


def vol(body, name, defs=None, scad=SCAD35):
    return ts.vol(body, "v35_" + name, defs, scad=scad)


# The web ring round each key, in the button frame, from off to off + h into the pod.
def ring(off, h):
    return ("at_buttons(%s) difference() { cylinder(d=key_groove_d-0.02,h=%s); "
            "translate([0,0,-1]) cylinder(d=key_d+0.02,h=%s+2); }" % (off, h, h))


class KeyWeb(unittest.TestCase):
    def test_web_thickness(self):
        self.assertAlmostEqual(echo("key_web_t", "web_t"), 0.6, places=3)
        self.assertAlmostEqual(echo("gasket_print_thickness", "sheet_t"), 0.8, places=3)

    def test_ring_removed_from_sheet(self):
        # Each ring loses (sheet - web) of thickness over the ring between the key and the plate hole.
        v34 = ts.vol("gasket();", "v34_gasket", scad=SCAD34)
        v35 = vol("gasket();", "gasket")
        self.assertAlmostEqual(v34 - v35, KEYS * RING_AREA * 0.2, delta=1.0)

    def test_groove_on_cover_side(self):
        # The cover side of the ring is cut; the back, toward the switch, stays full.
        front = vol("intersection() { gasket(); %s }" % ring("cover_back_off+0.01", "0.18"), "front")
        back = vol("intersection() { gasket(); %s }" % ring("sheet_back_off-key_web_t+0.01", "key_web_t-0.02"),
                   "back")
        self.assertLessEqual(front, TOL)
        self.assertAlmostEqual(back, KEYS * BACK * 0.58, delta=1.0)

    def test_groove_past_plate_hole(self):
        # The cut's step sits on the plate, not on the hole edge where the ring bends most.
        self.assertGreaterEqual(echo("(key_groove_d-key_web_d)/2", "step_off"), 0.25)

    def test_rest_gap_kept(self):
        # The switch actuators stay key_rest_gap behind the sheet's back face.
        self.assertAlmostEqual(echo("btn_ksc_top_off-sheet_back_off", "rest_gap"), 0.3, places=3)

    def test_print_keeps_groove(self):
        # Flat print: the groove is on top, round each key; the bed side is flat.
        v34 = ts.vol("print_gasket();", "v34_print", scad=SCAD34)
        v35 = vol("print_gasket();", "print")
        self.assertAlmostEqual(v34 - v35, KEYS * RING_AREA * 0.2, delta=1.5)
        rings = ("for (y=button_y) translate([-axial_width/2,y,%s]) difference() { "
                 "cylinder(d=key_groove_d-0.02,h=%s); translate([0,0,-1]) cylinder(d=key_d+0.02,h=%s+2); }")
        top = vol("intersection() { print_gasket(); %s }" % (rings % ("key_web_t+0.01", "0.18", "0.18")),
                  "print_top")
        bed = vol("intersection() { print_gasket(); %s }" % (rings % ("0.01", "key_web_t-0.02", "key_web_t-0.02")),
                  "print_bed")
        self.assertLessEqual(top, TOL)
        self.assertAlmostEqual(bed, KEYS * BACK * 0.58, delta=1.5)


if __name__ == "__main__":
    unittest.main()
