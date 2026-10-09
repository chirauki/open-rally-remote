// Open Rally Remote — button + joystick carrier, V0.2
// Based on APEM IS reduced-bezel buttons and Ruffy MHS joystick dimensions.
// The joystick's full profiled panel opening needs drawing/sample verification;
// this model shows the published Ø0.622 in (15.80 mm) nominal opening only.

$fn = 96;

button_cutout_diameter = 13.6;
button_bezel_diameter = 15.0; // APEM IS reduced-bezel option
button_pitch = 20.0;
panel_thickness = 2.5;        // APEM 1.5–4 mm; Ruffy MHS 2–3 mm
button_edge_margin = 2.75;    // derived from 20.5 mm width and 15 mm bezel
joystick_opening_diameter = 15.80; // Ruffy drawing: Ø0.622 in
control_pitch = 20.0;

button_count = 3;
control_count = button_count + 1;
panel_width = 20.5;
panel_length = button_bezel_diameter + 2 * button_edge_margin
             + control_pitch * (control_count - 1);

difference() {
    // Outline: 20.5 × 80.5 × 2.5 mm.
    translate([0, 0, panel_thickness / 2])
        cube([panel_width, panel_length, panel_thickness], center=true);

    // Buttons A, B, C. The lower joystick occupies the fourth control position.
    for (i = [0 : button_count - 1]) {
        y = -panel_length / 2 + button_edge_margin + button_bezel_diameter / 2
          + i * control_pitch;
        translate([0, y, -0.1])
            cylinder(d=button_cutout_diameter, h=panel_thickness + 0.2);
    }

    // Joystick mounting opening, centered 20 mm below button C.
    // See file header and mechanical guide: the manufacturer's drawing also
    // shows a 0.291 in profile detail not represented by this round opening.
    joystick_y = -panel_length / 2 + button_edge_margin + button_bezel_diameter / 2
               + button_count * control_pitch;
    translate([0, joystick_y, -0.1])
        cylinder(d=joystick_opening_diameter, h=panel_thickness + 0.2);
}
