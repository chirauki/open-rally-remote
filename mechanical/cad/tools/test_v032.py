#!/usr/bin/env python3
"""Tests for the V0.32 part changes: the M3 x 20 lock screw, the anti-rattle strips cut from
a bike inner tube, and why the joystick knob keeps its square nut.

Run from the repository root:
  python3 -m unittest mechanical/cad/tools/test_v032.py -v
"""
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import assembly_video as av  # noqa: E402
import test_seal as ts  # noqa: E402

SCAD32 = av.CAD / "complete-remote-v0.32.scad"
TOL = ts.TOL


def echo(expr, name, defs=None):
    return ts.echo(expr, "v32_" + name, defs, scad=SCAD32)


def vol(body, name, defs=None):
    return ts.vol(body, "v32_" + name, defs, scad=SCAD32)


# DIN 562 M2 square nut, 4.0 x 1.2 mm, in the knob slot. ISO 4032 M2 hex nut: e 4.62 nominal.
SQUARE_NUT = ("translate([knob_nut_r0, -knob_nut[0]/2, knob_insert_z-knob_nut[0]/2]) "
              "cube([knob_nut[1], knob_nut[0], knob_nut[0]]);")
HEX_E = 4.0 / 0.8660254


class KnobNut(unittest.TestCase):
    """V0.32 keeps the square nut in the joystick knob: an M2 hex nut does not fit."""

    def test_square_nut_inside_knob(self):
        # Nothing of the nut stands below the hub face, toward the cover.
        self.assertLessEqual(vol("intersection() { %s translate([-10, -10, -knob_gap]) cube(20); }"
                                 % SQUARE_NUT, "nut_below_hub"), TOL)
        self.assertLessEqual(vol("intersection() { knob_shape(); %s }" % SQUARE_NUT, "nut_fit"), TOL)

    def test_hex_nut_too_tall(self):
        # A hex nut, corner up so it cannot spin, with 0.2 mm clearance and 0.5 mm skin.
        self.assertGreater(HEX_E + 0.2 + 0.5, echo("knob_proud-knob_gap", "knob_height"))


class LockScrew(unittest.TestCase):
    """V0.32: an M3 x 20 lock screw (ISO 4762 length) through one nut, fixed with epoxy;
    V0.31 asked for M3 x 22, not a standard length."""

    def test_standard_length(self):
        self.assertIn(echo("lock_screw_length", "lock_len"), (16.0, 20.0, 25.0))

    def test_full_nut_engagement(self):
        self.assertGreaterEqual(echo("lock_tip-(lock_knob_h-lock_nut[1]+lock_nut_m)", "lock_engage"), 0.5)

    def test_tip_near_knob_face(self):
        self.assertLessEqual(echo("lock_tip-lock_knob_h", "lock_proud"), 1.0)


class InnerTube(unittest.TestCase):
    """V0.32: the anti-rattle strips, and optionally the clamp liner, are cut from a bike inner
    tube. The strip pocket follows the measured rubber thickness, so the squeeze stays the
    same; the clamp bore follows the liner thickness."""

    def test_default_thickness(self):
        self.assertAlmostEqual(echo("strip_t", "strip_t"), 1.0, places=3)

    def test_squeeze_follows_thickness(self):
        for t in (0.8, 1.0, 1.2):
            self.assertAlmostEqual(echo("strip_squeeze", "sq_%d" % int(t * 10), {"strip_t": t}),
                                   0.3, places=3)

    def test_thin_tube_fits(self):
        # Road tubes are about 0.8 mm: the pocket gets shallow but not negative.
        self.assertGreaterEqual(echo("strip_pocket", "pocket", {"strip_t": 0.8}), 0)

    def test_liner_from_tube(self):
        # The base keeps its platform wall (assert >= 3.0 mm) for tubes 0.8 to 1.2 mm thick.
        for t in (0.8, 1.2):
            self.assertGreaterEqual(echo("platform_wall", "wall_%d" % int(t * 10), {"liner_radial": t}), 3.0)


if __name__ == "__main__":
    unittest.main()
