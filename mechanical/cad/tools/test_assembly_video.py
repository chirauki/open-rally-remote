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

    def test_run_scad_empty_allowed(self):
        out = av.BUILD / "test" / "empty.stl"
        av.run_scad({"mode": "none"}, out, allow_empty=True,
                    body="intersection() { cube(1); translate([5, 0, 0]) cube(1); }")
        self.assertEqual(av.stl_volume(out), 0.0)
        with self.assertRaises(av.ScadError):
            av.run_scad({"mode": "none"}, out,
                        body="intersection() { cube(1); translate([5, 0, 0]) cube(1); }")

    def test_final_pose_matches_model(self):
        video = "pose_view(skip=[\"vent_label\"]);"
        model = "remote_parts(); controls_and_board();"
        for a, b, tag in ((video, model, "video_minus_model"), (model, video, "model_minus_video")):
            out = av.BUILD / "test" / (tag + ".stl")
            av.run_scad({"mode": "none", "step": 11, "u": 1},
                        out, body="difference() { union() { %s } union() { %s } }" % (a, b),
                        allow_empty=True)
            self.assertLessEqual(av.stl_volume(out), TOL, tag)


VARIANTS = ("documented", "battery_first")


class Task2(unittest.TestCase):
    def test_all_parts_placed(self):
        for v in VARIANTS:
            self.assertEqual(set(av.step_info(11, v)["placed"]), set(av.PARTS), v)

    def test_steps_join(self):
        for v in VARIANTS:
            for n in range(1, 11):
                a = "pose_at(%d, 1, \"%s\");" % (n, v)
                b = "pose_at(%d, 0, \"%s\");" % (n + 1, v)
                for x, y, tag in ((a, b, "end_minus_next"), (b, a, "next_minus_end")):
                    out = av.BUILD / "test" / ("join_%s_%d_%s.stl" % (v, n, tag))
                    av.run_scad({"mode": "none"}, out,
                                body="difference() { union() { %s } union() { %s } }" % (x, y),
                                allow_empty=True)
                    self.assertLessEqual(av.stl_volume(out), TOL, "%s step %d %s" % (v, n, tag))

    def test_every_step_renders(self):
        for v in VARIANTS:
            for n in range(1, 12):
                info = av.step_info(n, v)
                for u in (0, 0.5, 1):
                    out = av.BUILD / "test" / ("render_%s_%02d_%s.png" % (v, n, u))
                    av.run_scad({"mode": "pose", "step": n, "u": u, "variant": v}, out,
                                args=av.png_args(info["camera"]))
                    self.assertGreater(out.stat().st_size, 10000)


if __name__ == "__main__":
    unittest.main()
