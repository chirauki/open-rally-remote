// Open Rally Remote — three-button carrier fit plate, V0.1
// Dimensions use the APEM IS series published panel cutout and spacing.
// This is a fit-check plate, not the complete enclosure or handlebar clamp.

$fn = 96;

switch_cutout_diameter = 13.6;
switch_bezel_diameter = 17.5;
switch_pitch = 20.0;
panel_thickness = 2.5; // APEM IS specified panel range: 1.5–4.0 mm
edge_margin = 3.0;     // Explicit design allowance beyond bezel edge
button_count = 3;

panel_width = switch_bezel_diameter + 2 * edge_margin;
panel_length = switch_bezel_diameter + 2 * edge_margin
             + switch_pitch * (button_count - 1);

difference() {
    // XY outline is 23.5 × 63.5 mm; bottom face is at Z=0.
    translate([0, 0, panel_thickness / 2])
        cube([panel_width, panel_length, panel_thickness], center=true);

    // One column of three Ø13.6 mm panel cutouts, on 20 mm centers.
    for (i = [0 : button_count - 1]) {
        y = -panel_length / 2 + edge_margin + switch_bezel_diameter / 2
          + i * switch_pitch;
        translate([0, y, -0.1])
            cylinder(d=switch_cutout_diameter, h=panel_thickness + 0.2);
    }
}
