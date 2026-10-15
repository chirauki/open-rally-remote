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


class Task3(unittest.TestCase):
    def test_known_collision_found(self):
        hits = av.check("test_collision", steps=[4])
        vols = [h[4] for h in hits if {h[1], h[3]} == {"xiao", "button_plate"}]
        self.assertTrue(vols, hits)
        self.assertGreater(max(vols), TOL)

    def test_no_collision_without_overlap(self):
        # The documented step 4 seats the XIAO without passing through the plate.
        hits = av.check("documented", steps=[4])
        self.assertFalse([h for h in hits if {h[1], h[3]} == {"xiao", "button_plate"}], hits)

    def test_check_jobs_unique(self):
        # Step 5 moves the joystick group twice, meeting at u = 0.45: one job per pose, or
        # two threads write the same STL.
        jobs = av.check_jobs("documented", [5])
        keys = [(j[1], j[3], round(j[2], 6)) for j in jobs]
        self.assertEqual(len(keys), len(set(keys)))
        self.assertIn((5, "stick", 0.45), keys)

    def test_allowed_contacts_measured(self):
        for pair, reason in av.ALLOWED_CONTACT.items():
            self.assertEqual(len(pair), 2)
            self.assertTrue(reason.strip(), pair)
        path = av.BUILD / "test" / "report.md"
        av.write_report({"documented": []}, path)
        text = path.read_text()
        for pair in av.ALLOWED_CONTACT:
            a, b = sorted(pair)
            self.assertIn("%s / %s" % (a, b), text)


DOC = av.REPO / "docs" / "mechanical-concept.md"
VIDEO = av.VIDEO


class Task4(unittest.TestCase):
    def test_step_titles(self):
        titles = av.step_titles(DOC)
        self.assertEqual(len(titles), 11)
        self.assertTrue(titles[0].startswith("Clear the ten"), titles[0])

    def test_step_titles_wrong_count(self):
        text = DOC.read_text()
        bad = av.BUILD / "test" / "ten-steps.md"
        bad.parent.mkdir(parents=True, exist_ok=True)
        bad.write_text(text.replace("\n11. ", "\nEleven. ", 1))
        with self.assertRaises(ValueError):
            av.step_titles(bad)

    def test_frames_stop_on_error(self):
        broken = av.BUILD / "test" / "broken.scad"
        broken.write_text("include <%s>\nif (u > 0.4 && u < 0.6) echo(undefined_var);\n" % av.SCAD)
        out = av.BUILD / "test" / "frames"
        with self.assertRaises(av.ScadError):
            av.frames(steps=[1], scad=broken, out_dir=out)
        n = av.frame_count(av.step_info(1, "documented")["duration"])
        for i in range(n):
            if 0.4 < i / (n - 1) < 0.6:
                self.assertFalse((out / "s01" / ("f%04d.png" % i)).exists(), i)

    def test_video_chapters(self):
        import json
        import subprocess
        p = subprocess.run(["ffprobe", "-v", "error", "-show_chapters", "-of", "json", str(VIDEO)],
                           capture_output=True, text=True, check=True)
        chapters = json.loads(p.stdout)["chapters"]
        titles = av.step_titles(DOC)
        self.assertEqual([c["tags"]["title"] for c in chapters],
                         ["Step %d: %s" % (i + 1, t) for i, t in enumerate(titles)])
        self.assertLessEqual(VIDEO.stat().st_size, 6 * 1024 * 1024)


if __name__ == "__main__":
    unittest.main()
