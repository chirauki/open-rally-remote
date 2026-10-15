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
TOL = 0.01  # mm^3
OUT = av.BUILD / "seal"


def vol(body, name, defs=None):
    """Volume (mm^3) of body rendered with the V0.30 model included."""
    d = {"part_to_render": "none"}
    d.update(defs or {})
    out = OUT / (name + ".stl")
    av.run_scad(d, out, body=body, allow_empty=True, scad=SCAD30)
    return av.stl_volume(out)


def echo(expr, name, defs=None):
    """Value of an OpenSCAD expression in the V0.30 model, through an echo."""
    d = {"part_to_render": "none"}
    d.update(defs or {})
    out = OUT / (name + ".echo")
    av.run_scad(d, out, body="echo(val=%s); cube(0.01);" % expr, scad=SCAD30)
    for line in out.read_text().splitlines():
        if line.startswith("ECHO: val = "):
            return float(line[len("ECHO: val = "):])
    raise AssertionError("no echo for " + expr)


class Task1(unittest.TestCase):
    def test_sheet_loose(self):
        self.assertLessEqual(vol("intersection() { gasket(); union() { button_plate(); joy_plate(); housing(); } }",
                                 "sheet_loose"), TOL)

    def test_sheet_loose_when_thick(self):
        # A sheet printed 0.1 mm thick on its back face, on each facet along its normal, with
        # the model's nominal geometry: it may touch the plates but not be squeezed.
        thick = ("union() { gasket(); translate([0.1, 0, 0]) gasket(); "
                 "translate(0.1*[fold_n[0], fold_n[1], 0]) gasket(); }")
        self.assertLessEqual(vol("intersection() { %s union() { button_plate(); joy_plate(); housing(); } }" % thick,
                                 "sheet_loose_thick"), TOL)

    def test_rim_dropped(self):
        self.assertLessEqual(vol("intersection() { housing(); full_z() front_band_2d(cover_back_off, rim_off-0.01); }",
                                 "rim_dropped"), TOL)

    def test_key_rest_gap(self):
        self.assertAlmostEqual(echo("btn_ksc_top_off-sheet_back_off", "key_gap"), 0.3, places=6)

    def test_knob_on_pin(self):
        # Length of pin inside the knob bore: the bore ends knob_gap off the cover face.
        self.assertGreaterEqual(echo("-knob_gap-pin_top_off", "knob_pin"), 3.0)


if __name__ == "__main__":
    unittest.main()
