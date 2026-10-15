#!/usr/bin/env python3
"""Tests for the V0.30 cover seal (docs/superpowers/specs/2026-10-15-cover-seal-design.md).

Run from the repository root:
  python3 -m unittest mechanical/cad/tools/test_seal.py -v
"""
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import assembly_video as av  # noqa: E402

SCAD30 = av.CAD / "complete-remote-v0.30.scad"
SCAD31 = av.CAD / "complete-remote-v0.31.scad"   # V0.31: battery cap seal
TOL = 0.01  # mm^3
OUT = av.BUILD / "seal"


def vol(body, name, defs=None, scad=SCAD30):
    """Volume (mm^3) of body rendered with the V0.30 model (or scad) included."""
    d = {"part_to_render": "none"}
    d.update(defs or {})
    out = OUT / (name + ".stl")
    av.run_scad(d, out, body=body, allow_empty=True, scad=scad)
    return av.stl_volume(out)


def echo(expr, name, defs=None, scad=SCAD30):
    """Value of an OpenSCAD expression in the V0.30 model, through an echo."""
    d = {"part_to_render": "none"}
    d.update(defs or {})
    out = OUT / (name + ".echo")
    av.run_scad(d, out, body="echo(val=%s); cube(0.01);" % expr, scad=scad)
    for line in out.read_text().splitlines():
        if line.startswith("ECHO: val = "):
            return float(line[len("ECHO: val = "):])
    raise AssertionError("no echo for " + expr)


class Task1(unittest.TestCase):
    def test_sheet_loose(self):
        # The sheet touches only the stop pads (Task 3): all its overlap is with them.
        allv = vol("intersection() { gasket(); union() { button_plate(); joy_plate(); housing(); } }", "sheet_loose")
        pads = vol("intersection() { gasket(); stop_pads(); }", "sheet_loose_pads")
        self.assertLessEqual(allv - pads, TOL)

    def test_sheet_loose_when_thick(self):
        # A sheet printed 0.1 mm thick on its back face, on each facet along its normal, with
        # the model's nominal geometry: it may touch the plates but not be squeezed.
        thick = ("union() { gasket(); translate([0.1, 0, 0]) gasket(); "
                 "translate(0.1*[fold_n[0], fold_n[1], 0]) gasket(); }")
        allv = vol("intersection() { %s union() { button_plate(); joy_plate(); housing(); } }" % thick,
                   "sheet_loose_thick")
        pads = vol("intersection() { %s stop_pads(); }" % thick, "sheet_loose_thick_pads")
        self.assertLessEqual(allv - pads, TOL)

    def test_rim_dropped(self):
        self.assertLessEqual(vol("intersection() { housing(); full_z() front_band_2d(cover_back_off, rim_off-0.01); }",
                                 "rim_dropped"), TOL)

    def test_key_rest_gap(self):
        self.assertAlmostEqual(echo("btn_ksc_top_off-sheet_back_off", "key_gap"), 0.3, places=6)

    def test_knob_on_pin(self):
        # Length of pin inside the knob bore: the bore ends knob_gap off the cover face.
        self.assertGreaterEqual(echo("-knob_gap-pin_top_off", "knob_pin"), 3.0)


UPPER = "intersection() { children(); translate([-200, fold_y, -50]) cube([400, 200, 200]); }"
FOAM_UP = "intersection() { foam_strip(); translate([-200, fold_y, -50]) cube([400, 200, 200]); }"
FOAM_LO = "intersection() { foam_strip(); translate([-200, fold_y-200, -50]) cube([400, 200, 200]); }"


class Task2(unittest.TestCase):
    def test_foam_on_rim(self):
        # Pushed 0.1 mm toward the housing along each facet's normal, the foam lies wholly on
        # housing material: what is left outside the housing is under 2 % of that slab.
        area = vol("foam_strip();", "foam") / echo("foam_comp", "foam_comp")
        moved = ("union() { translate([0.1, 0, 0]) %s translate(0.1*[fold_n[0], fold_n[1], 0]) %s }"
                 % (FOAM_UP, FOAM_LO))
        on = vol("intersection() { %s housing(); }" % moved, "foam_on_rim")
        self.assertGreater(area, 150)
        self.assertGreaterEqual(on, 0.98 * area * 0.1)

    def test_foam_clear(self):
        others = ("union() { button_plate(); joy_plate(); control_board_envelope(); joy_envelope(); "
                  "xiao_envelope(); cover_bosses(); face_cover(); }")
        self.assertLessEqual(vol("intersection() { foam_strip(); %s }" % others, "foam_clear"), TOL)

    def test_foam_under_sheet(self):
        self.assertLessEqual(vol("intersection() { foam_strip(); gasket(); }", "foam_sheet"), TOL)

    def test_widened_ends_clear(self):
        others = ("union() { button_plate(); joy_plate(); control_board_envelope(); joy_envelope(); "
                  "xiao_envelope(); usbc_envelope(); }")
        self.assertLessEqual(vol("intersection() { housing(); %s }" % others, "ends_clear"), TOL)

    def test_foam_length(self):
        self.assertTrue(180 <= echo("foam_length", "foam_length") <= 260)


class Task3(unittest.TestCase):
    def test_pads_pinch(self):
        # The pads stand sheet_clear + pad_pinch (0.15 mm) proud; the sheet meets their top
        # pad_pinch (0.05 mm) deep, so the overlap is a third of the pads' volume.
        pads = vol("stop_pads();", "pads")
        pinch = vol("intersection() { gasket(); union() { button_plate(); joy_plate(); } }", "pads_pinch")
        self.assertGreater(pads, 0)
        self.assertAlmostEqual(pinch, pads / 3, delta=0.1 * pads / 3)

    def test_pads_clear(self):
        webs = "at_buttons(btn_plate_front_off-1) cylinder(d=key_web_d, h=5);"
        self.assertLessEqual(vol("intersection() { stop_pads(); union() { foam_strip(); %s } }" % webs,
                                 "pads_clear"), TOL)

    def test_sheet_screw_holes(self):
        self.assertLessEqual(vol("intersection() { gasket(); at_cover_screws() cylinder(d=1.35, h=20, $fn=24); }",
                                 "sheet_hole_14"), TOL)
        self.assertGreater(vol("intersection() { gasket(); at_cover_screws() cylinder(d=2.0, h=20); }",
                               "sheet_hole_20"), 0)

    def test_pad_load(self):
        self.assertTrue(5 <= echo("pad_load", "pad_load") <= 100)


def v31(body, name):
    return vol(body, "v31_" + name, scad=SCAD31)


class CapSeal(unittest.TestCase):
    """V0.31: a die-cut closed-cell foam gasket under the battery cap, compressed to foam_comp
    by a rigid lip on the cap's outer edge."""

    def test_cap_lip_on_housing(self):
        self.assertLessEqual(v31("intersection() { battery_cap(); housing(); }", "cap_housing"), TOL)
        self.assertGreater(v31("intersection() { translate([0, 0.05, 0]) battery_cap(); housing(); }",
                               "cap_lip_touch"), 0)

    def test_cap_foam_fills_gap(self):
        self.assertLessEqual(v31("intersection() { cap_gasket(); union() { battery_cap(); housing(); } }",
                                 "capfoam_clear"), TOL)
        area = v31("cap_gasket();", "capfoam") / echo("foam_comp", "v31_fc", scad=SCAD31)
        self.assertGreater(area, 100)

    def test_cap_foam_grips_screws(self):
        self.assertGreater(v31("intersection() { cap_gasket(); for (s=cap_screws) "
                               "translate([s[0], cap_y-2, s[1]]) rotate([-90, 0, 0]) cylinder(d=2.0, h=4); }",
                               "capfoam_screws"), 0)

    def test_cap_thread_unchanged(self):
        self.assertAlmostEqual(echo("cap_screw[2]-cap_t-cap_gap", "v31_thread", scad=SCAD31), 5.009, places=2)

    def test_vent_label_clear_of_foam(self):
        self.assertLessEqual(v31("intersection() { vent_label_envelope(); union() { cap_gasket(); housing(); } }",
                                 "vent_foam"), TOL)
        self.assertLessEqual(v31("intersection() { translate([0, 0.05, 0]) vent_label_envelope(); battery_cap(); }",
                                 "vent_on_cap"), TOL)


if __name__ == "__main__":
    unittest.main()
