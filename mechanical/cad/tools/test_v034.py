#!/usr/bin/env python3
"""Tests for V0.34: the sliding USB-C board on square nuts, upside down so a driver reaches its
screws from the battery cap opening, and the two-layer foam seals.

Run from the repository root:
  python3 -m unittest mechanical/cad/tools/test_v034.py -v
"""
import math
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import assembly_video as av  # noqa: E402
import test_seal as ts  # noqa: E402
import test_v033 as t33  # noqa: E402

SCAD33 = av.CAD / "complete-remote-v0.33.scad"
SCAD34 = av.CAD / "complete-remote-v0.34.scad"
TOL = ts.TOL


def echo(expr, name, defs=None, scad=SCAD34):
    return ts.echo(expr, "v34_" + name, defs, scad=scad)


def vol(body, name, defs=None, scad=SCAD34):
    return ts.vol(body, "v34_" + name, defs, scad=scad)


# The shank of each USB-C screw past the PCB, with the hole d mm toward the wall (+X).
def shanks(d):
    return "usbc_screw_shanks(%g);" % d


class UsbcSlide(unittest.TestCase):
    def test_nuts_fit_over_travel(self):
        for d in (-1.0, 0.0, 1.0):
            with self.subTest(d=d):
                v = vol("intersection() { housing(); usbc_nuts(%g); }" % d, "nuts_%g" % d)
                self.assertLessEqual(v, TOL)

    def test_screws_fit_over_travel(self):
        for d in (-1.0, 0.0, 1.0):
            with self.subTest(d=d):
                v = vol("intersection() { housing(); %s }" % shanks(d), "shanks_%g" % d)
                self.assertLessEqual(v, TOL)

    def test_screws_held_at_travel_limits(self):
        # Past the slot ends, the shank hits the rib: the slot stops at usbc_slide.
        v = vol("intersection() { housing(); %s }" % shanks(1.6), "shanks_out")
        self.assertGreater(v, 0.1)

    def test_nut_enters_from_rib_front(self):
        # Each nut slides in along X from in front of the rib to the far end of its travel.
        # The hull spans both nuts, so keep only the two bands the nuts move in.
        bands = ("for (h=usbc_pcb_holes) let(p=usbc_hole_xz(h)) "
                 "translate([-200,-200,p[1]-usbc_nut[0]/2]) cube([400,400,usbc_nut[0]]);")
        body = ("intersection() { housing(); hull() { translate([-12,0,0]) usbc_nuts(-1); "
                "usbc_nuts(1); } union() { %s } }" % bands)
        self.assertLessEqual(vol(body, "nut_path"), TOL)

    def test_nut_cannot_turn(self):
        w = echo("usbc_nut_w", "nut_w")
        self.assertLess(w, 4.0 * math.sqrt(2) - 0.5)

    def test_nut_under_skin(self):
        # The nut sits under rib material, so the screw clamps the board on the rib.
        body = "intersection() { housing(); translate([0,usbc_s*(usbc_nut[1]+0.1),0]) usbc_nuts(1); }"
        self.assertGreater(vol(body, "nut_skin"), 0.5)

    def test_screw_passes_through_nut(self):
        self.assertGreaterEqual(echo("usbc_tip-usbc_skin-usbc_nut[1]", "engage"), 0.0)

    def test_board_upside_down(self):
        # The rib is above the board, so the screw heads face the battery cap opening.
        self.assertGreater(echo("usbc_away(usbc_rib_h)-usbc_pcb_back_y", "rib_up"), 0)
        self.assertLess(echo("usbc_y-usbc_s*usbc_axis_h+usbc_s*usbc_screw[1]", "head_y"),
                        echo("usbc_pcb_back_y", "back_y"))

    def test_driver_reaches_from_cap_opening(self):
        # At step 2 the housing is empty: a driver tilted to X = -28 at the cap face clears it.
        for i in (0, 1):
            with self.subTest(screw=i):
                self.assertLessEqual(vol("intersection() { housing(); usbc_driver(%d); }" % i, "drv%d" % i), TOL)

    def test_driver_needs_the_tilt(self):
        # Straight up from below, the Ø4 mm shank hits the cap opening's front edge.
        v = vol("intersection() { housing(); usbc_driver(0); }", "drv_straight",
                defs={"usbc_driver_x": -30.23})
        self.assertGreater(v, 0.1)

    def test_pcb_edge_clearance_kept(self):
        expr = "usbc_pcb_edge-usbc_panel_t"
        self.assertAlmostEqual(echo(expr, "edge"), echo(expr, "edge33", scad=SCAD33), places=6)


class Foam(unittest.TestCase):
    def test_two_layers_compression(self):
        c = 1 - echo("foam_comp/foam_t", "ratio")
        self.assertGreaterEqual(c, 0.30)
        self.assertLessEqual(c, 0.40)

    def test_rim_clear_of_plates(self):
        v = vol("intersection() { union() { housing(); foam_strip(); } union() { button_plate(); joy_plate(); } }",
                "rim_plates")
        self.assertLessEqual(v, TOL)

    def test_cap_gap_follows_foam(self):
        self.assertAlmostEqual(echo("cap_gap", "cap_gap"), echo("foam_comp", "fc"), places=6)

    def test_cap_screw_thread(self):
        self.assertGreaterEqual(echo("cap_screw[2]-cap_t-cap_gap", "cap_thread"), 4.0)

    def test_foam_on_rim(self):
        area = vol("foam_strip();", "foam") / echo("foam_comp", "foam_comp")
        moved = ("union() { translate([0.1, 0, 0]) %s translate(0.1*[fold_n[0], fold_n[1], 0]) %s }"
                 % (ts.FOAM_UP, ts.FOAM_LO))
        on = vol("intersection() { %s housing(); }" % moved, "foam_on_rim")
        self.assertGreaterEqual(on, 0.98 * area * 0.1)

    def test_foam_clear_of_contents(self):
        v = vol("intersection() { foam_strip(); %s }" % t33.ENVELOPES, "foam_contents")
        self.assertLessEqual(v, TOL)


class Fit(unittest.TestCase):
    def test_contents_clear_housing(self):
        v = vol("intersection() { housing(); union() { %s usbc_nuts(); } }" % t33.ENVELOPES, "contents")
        self.assertLessEqual(v, TOL)

    def test_contents_clear_cap(self):
        self.assertLessEqual(vol("intersection() { battery_cap(); %s }" % t33.ENVELOPES, "contents_cap"), TOL)

    def test_cover_screw_thread_kept(self):
        # The rim drops 0.5 mm with foam_comp; the cover screws keep their thread in the bosses.
        for expr in ("cover_screw_thread", "cover_screw_thread_lower"):
            with self.subTest(expr=expr):
                self.assertAlmostEqual(echo(expr, expr), echo(expr, expr + "33", scad=SCAD33), places=6)


if __name__ == "__main__":
    unittest.main()
