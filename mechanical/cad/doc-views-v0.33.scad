// Open Rally Remote — V0.33 doc views: the image views that complete-remote-v0.33.scad has no
// part_to_render for. tools/doc_images.py renders them, with part_to_render="none", for
// docs/mechanical-concept.md.
include <complete-remote-v0.33.scad>

view = "none";

// Flat cut at Y = y, +X right and +Z up.
module cut_y(y) { mirror([0,1]) projection(cut=true) rotate([90,0,0]) translate([0,-y,0]) children(); }

module cover_screw_bodies() {
    at_cover_screws() { cylinder(d=2.0,h=cover_screw_length); translate([0,0,-0.01]) cylinder(d1=3.8,d2=2.0,h=0.9); }
}

if (view=="seal_section") {
    y = cover_screws[1][1];
    color([0.67,0.70,0.72]) cut_y(y) face_cover();
    color([0.53,0.58,0.62]) cut_y(y) housing();
    color([0.12,0.12,0.12]) cut_y(y) gasket();
    color([0.25,0.25,0.75]) cut_y(y) foam_strip();
    color([0.74,0.58,0.20]) cut_y(y) button_plate();
    color([0.65,0.08,0.08]) cut_y(y) cover_screw_bodies();
    color([0.12,0.38,0.25]) cut_y(y) control_board_envelope();
}
if (view=="foam") {
    color([0.67,0.73,0.77]) housing();
    foam_strip();
}
if (view=="cap_seal") {
    color([0.60,0.66,0.70]) battery_cap();
    color([0.12,0.12,0.12]) cap_gasket();
    color([0.85,0.85,0.85]) vent_label_envelope();
}
if (view=="battery_cap") {
    color([0.67,0.73,0.77]) housing();
    color([0.75,0.2,0.2]) translate([0,-30,0]) pouch_envelope();
    color([0.12,0.12,0.12]) translate([0,-62,0]) cap_gasket();
    color([0.60,0.66,0.70]) translate([0,-72,0]) battery_cap();
}
if (view=="back") {
    color([0.67,0.73,0.77]) housing();
    color([0.60,0.66,0.70]) battery_cap();
}
if (view=="print_joy") {
    color([0.95,0.75,0.25]) print_joy_plate();
    color([0.85,0.85,0.85]) translate([30,0,0]) print_ball_disc();
    color([0.14,0.18,0.20]) translate([52,0,0]) print_knob();
    color([0.6,0.6,0.62]) translate([30,16,1.5]) rotate([0,90,0]) cylinder(d=3,h=12,center=true);
}
if (view=="print_knobs") {
    color([0.14,0.18,0.20]) print_knob();
    color([0.85,0.45,0.15]) translate([22,0,0]) print_lock_knob();
}
// Around the joystick only, turned so the knob points down the page.
if (view=="joy_section") rotate([0,0,70]) intersection() {
    union() { remote_parts(m=2); intersection() { controls_and_board(); section_clip(); } }
    translate([joy_p[0]-2,joy_p[1],0]) cube([44,40,200],center=true);
}

// bar_ghost() uses %, which a full render drops: a solid bar instead.
module bar_solid() { color([0.78,0.78,0.78]) translate([0,0,axial_width/2]) cylinder(d=bar_diameter,h=100,center=true); }
if (view=="assembly") { remote_parts(); base_parts(); bar_solid(); }
if (view=="entry") { remote_parts([-12,-slide,0]); base_parts(0); bar_solid(); }
if (view=="base") { base_parts(); bar_solid(); }
