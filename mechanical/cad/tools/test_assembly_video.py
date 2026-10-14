#!/usr/bin/env python3
"""Tests for assembly_video.py. They call OpenSCAD and take minutes.

Run from the repository root:
  python3 -m unittest mechanical/cad/tools/test_assembly_video.py -v
"""
import os
import sys
import unittest
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import assembly_video as av  # noqa: E402

TOL = 0.01  # mm^3


class Task1(unittest.TestCase):
    def test_stl_volume_cube(self):
        out = av.BUILD / "test" / "cube.stl"
        av.run_scad({"mode": "none"}, out, body="cube(10);")
        self.assertAlmostEqual(av.stl_volume(out), 1000.0, delta=TOL)

    def test_run_scad_raises_on_warning(self):
        with self.assertRaises(av.ScadError):
            av.run_scad({"mode": "none"}, av.BUILD / "test" / "warn.stl",
                        body="cube(1); echo(undefined_var);")

    def test_final_pose_matches_model(self):
        video = "pose_view(skip=[\"vent_label\"]);"
        model = "remote_parts(); controls_and_board();"
        for a, b, tag in ((video, model, "video_minus_model"), (model, video, "model_minus_video")):
            out = av.BUILD / "test" / (tag + ".stl")
            av.run_scad({"mode": "none", "step": 11, "u": 1},
                        out, body="difference() { union() { %s } union() { %s } }" % (a, b),
                        allow_empty=True)
            self.assertLessEqual(av.stl_volume(out), TOL, tag)


if __name__ == "__main__":
    unittest.main()
