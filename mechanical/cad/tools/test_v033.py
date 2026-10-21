#!/usr/bin/env python3
"""Tests for the V0.33 walls: the narrow part's axial walls and the two end walls grow from
1 mm to 2 mm, outward, so the cavity and everything in it stay as in V0.32.

Run from the repository root:
  python3 -m unittest mechanical/cad/tools/test_v033.py -v
"""
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import assembly_video as av  # noqa: E402
import test_seal as ts  # noqa: E402

SCAD32 = av.CAD / "complete-remote-v0.32.scad"
SCAD33 = av.CAD / "complete-remote-v0.33.scad"
TOL = ts.TOL

# The cavity the housing keeps once the front band is cut off, the way housing() cuts it.
CAVITY = "difference() { cavity_solid(); full_z() front_band_2d(-10, housing_front_off); }"
ENVELOPES = ("union() { button_plate(); joy_plate(); control_board_envelope(); joy_envelope(); "
             "xiao_envelope(); usbc_envelope(); pouch_envelope(); }")


def echo(expr, name, defs=None, scad=SCAD33):
    return ts.echo(expr, "v33_" + name, defs, scad=scad)


def vol(body, name, defs=None, scad=SCAD33):
    return ts.vol(body, "v33_" + name, defs, scad=scad)


class Walls(unittest.TestCase):
    def test_wall_thickness(self):
        self.assertAlmostEqual(echo("case_wall", "wall"), 2.0, places=6)

    def test_width(self):
        self.assertAlmostEqual(echo("axial_width", "width"), 25.0, places=6)

    def test_cavity_width_kept(self):
        self.assertAlmostEqual(echo("axial_width-2*case_wall", "cav_w"),
                               echo("axial_width-2*case_wall", "cav_w32", scad=SCAD32), places=6)

    def test_height_grows_2mm(self):
        expr = "pod_top_y-pod_bottom_y"
        self.assertAlmostEqual(echo(expr, "height") - echo(expr, "height32", scad=SCAD32), 2.0, places=3)

    def test_cavity_ends_kept(self):
        for expr in ("pod_top_y-case_wall", "pod_bottom_y+case_wall"):
            self.assertAlmostEqual(echo(expr, "end"), echo(expr, "end32", scad=SCAD32), places=3)

    def test_cavity_volume_kept(self):
        self.assertAlmostEqual(vol(CAVITY, "cavity"), vol(CAVITY, "cavity32", scad=SCAD32), delta=1.0)


class Fit(unittest.TestCase):
    def test_contents_clear_housing(self):
        self.assertLessEqual(vol("intersection() { housing(); %s }" % ENVELOPES, "contents"), TOL)

    def test_contents_clear_cap(self):
        self.assertLessEqual(vol("intersection() { battery_cap(); %s }" % ENVELOPES, "contents_cap"), TOL)

    def test_cap_screw_thread(self):
        # Thread of the M2 x 8 cap screws in the housing, with the thicker cap.
        self.assertGreaterEqual(echo("cap_screw[2]-cap_t-cap_gap", "cap_thread"), 4.0)

    def test_foam_on_rim(self):
        # As test_seal: pushed 0.1 mm toward the housing, the foam lies on housing material.
        area = vol("foam_strip();", "foam") / echo("foam_comp", "foam_comp")
        moved = ("union() { translate([0.1, 0, 0]) %s translate(0.1*[fold_n[0], fold_n[1], 0]) %s }"
                 % (ts.FOAM_UP, ts.FOAM_LO))
        on = vol("intersection() { %s housing(); }" % moved, "foam_on_rim")
        self.assertGreaterEqual(on, 0.98 * area * 0.1)


if __name__ == "__main__":
    unittest.main()
