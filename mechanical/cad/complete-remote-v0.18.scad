// Open Rally Remote — diametral clamp split with parallel M4 bolts, V0.18
// Units: mm. Ring lies in XY; handlebar axis is Z. Controls are on the side face (YZ),
// so each button's actuation axis is X, perpendicular to the handlebar.
// The outer silhouette is the convex hull of the pod outline and the Ø44 clamp circle:
// its upper and lower edges run tangentially from the pod end corners to the ring.
// The silhouette is split by the plane through the bar axis perpendicular to X, so each
// half wraps exactly 180° (minus the clamping gap) and the bar can enter the body.
// Body = pod side (X < 0); rear cap = X > 0. Two M4 bolts run along X on either side of
// the bar: heads seat in the rear cap, threads engage heat-set inserts in the body.

$fn = 96;
part_to_render = "assembly"; // assembly, section, cutaway, housing, clamp_cap, cover, liner_main, liner_cap
show_internals = false;

bar_diameter = 22.0;
liner_radial = 1.0;
clamp_bore = bar_diameter + 2*liner_radial;
clamp_outer = 44.0;
clamp_radial_section = (clamp_outer-clamp_bore)/2; // 10 mm at Ø44/Ø24 comparison target
axial_width = 23.0;
case_wall = 1.0;
face_cover_thickness = 2.5;
button_head_projection = 1.8;
button_head_diameter = 10.0;
joystick_head_projection = 5.0;
joystick_head_diameter = 9.0;

pod_center_x = -35.0;
pod_width = 40.0;
pod_length = 82.0;
pod_corner = 7.0;
pod_min_x = pod_center_x-pod_width/2;
pod_max_x = pod_center_x+pod_width/2;
pod_cavity_x0 = pod_min_x-0.1;
pod_cavity_x1 = pod_max_x-case_wall-6.0;
pod_cavity_width = pod_cavity_x1-pod_cavity_x0;
pod_cavity_length = pod_length-2*case_wall;
pod_cavity_corner = pod_corner-case_wall;
button_cutout = 13.6;
joystick_cutout = 15.8;
control_y = [27.0, 9.0, -9.0, -27.0];
switch_depth = 13.0;
joystick_depth = 13.5;
xiao_x = pod_cavity_x1-10.0;
xiao_y = 0;
xiao_length = 21.0;
xiao_width = 17.8;
xiao_header_projection = 6.0;

split_gap = 0.8;         // total gap between body and cap faces; closes as bolts clamp the liner
clamp_bolt_y = 17.0;     // bolt axes at Y = ±17, outside the Ø24 bore
clamp_bolt_d = 4.3;      // M4 clearance
bolt_length = 16.0;      // ISO 4762 M4 x 16 socket head
bolt_head_d = 7.0;       // ISO 4762 M4 head Ø7.0
bolt_head_h = 4.0;
bolt_head_clear_d = 7.6; // counterbore for the head
cap_seat_x = 8.0;        // head bearing face in the rear cap (X from bar axis)
insert_hole_d = 5.6;     // M4 heat-set insert hole; check against the chosen insert's datasheet
insert_depth = 8.1;
bolt_tip_clearance = 2.0;

cap_face_x = split_gap/2;
body_face_x = -split_gap/2;
bolt_tip_x = cap_seat_x-bolt_length;
bolt_engagement = body_face_x-bolt_tip_x;
cap_grip = cap_seat_x-cap_face_x;
bore_wall_at_bolt = clamp_bolt_y-clamp_bore/2-clamp_bolt_d/2;
// Bolt tip must stay inside the insert hole, and the clearance hole must not break into the bore.
assert(bolt_tip_x >= body_face_x-insert_depth, "Bolt is longer than the insert hole");
assert(bore_wall_at_bolt >= 2.0, "Bolt hole too close to the clamp bore");

echo(str("Pod cavity envelope (mm): ",pod_cavity_width," x ",pod_cavity_length," x ",axial_width-2*case_wall));
echo(str("Clamp radial section (mm): ",clamp_radial_section));
echo(str("Clamp bolts M4x",bolt_length," at Y=±",clamp_bolt_y,"; cap grip ",cap_grip,
    " mm, insert engagement ",bolt_engagement," mm, wall to bore ",bore_wall_at_bolt," mm"));

module rounded_box_2d(w,l,r) {
    offset(r=r) square([w-2*r,l-2*r],center=true);
}

module ring_half_2d(right=false, liner=false) {
    difference() {
        intersection() {
            circle(d=liner ? clamp_bore : clamp_outer);
            if (right)
                translate([clamp_outer/4+0.5,0]) square([clamp_outer/2+1,clamp_outer+2],center=true);
            else
                translate([-clamp_outer/4-0.5,0]) square([clamp_outer/2+1,clamp_outer+2],center=true);
        }
        circle(d=liner ? bar_diameter : clamp_bore);
    }
}

module outer_silhouette_2d() {
    // Complete outer contour of the assembled housing (body + cap).
    hull() {
        translate([pod_center_x,0]) rounded_box_2d(pod_width,pod_length,pod_corner);
        circle(d=clamp_outer);
    }
}

module half_plane_2d(cap=false) {
    if (cap) translate([cap_face_x,-100]) square([200,200]);
    else translate([body_face_x-200,-100]) square([200,200]);
}

module housing_profile_2d() {
    difference() {
        intersection() { outer_silhouette_2d(); half_plane_2d(false); }
        circle(d=clamp_bore);
    }
}

module cap_profile_2d() {
    difference() {
        intersection() { outer_silhouette_2d(); half_plane_2d(true); }
        circle(d=clamp_bore);
    }
}

// Bolt axes run along X at Y = ±clamp_bolt_y, mid-width along the bar.
// Inside at_bolts(), local Z equals global X.
module at_bolts() {
    for (s=[-1,1]) translate([0,s*clamp_bolt_y,axial_width/2]) rotate([0,90,0]) children();
}

module cap_bolt_cuts() {
    // Clearance hole from the split face to the head seat, counterbore from the seat outward.
    at_bolts() {
        translate([0,0,-0.1]) cylinder(d=clamp_bolt_d,h=cap_seat_x+0.2);
        translate([0,0,cap_seat_x]) cylinder(d=bolt_head_clear_d,h=30);
    }
}

module body_bolt_cuts() {
    // Heat-set insert hole from the split face into the solid shoulder, plus tip clearance.
    at_bolts() {
        translate([0,0,body_face_x-insert_depth]) cylinder(d=insert_hole_d,h=insert_depth+0.1);
        translate([0,0,body_face_x-insert_depth-bolt_tip_clearance])
            cylinder(d=clamp_bolt_d,h=bolt_tip_clearance+0.1);
    }
}

module clamp_bolts() {
    color([0.25,0.25,0.27]) at_bolts() {
        translate([0,0,cap_seat_x]) cylinder(d=bolt_head_d,h=bolt_head_h);
        translate([0,0,bolt_tip_x]) cylinder(d=4.0,h=bolt_length);
    }
}

module pod_cavity_tool() {
    translate([0,0,case_wall])
        linear_extrude(height=axial_width-2*case_wall)
            translate([(pod_cavity_x0+pod_cavity_x1)/2,0])
                rounded_box_2d(pod_cavity_width,pod_cavity_length,pod_cavity_corner);
}

module housing() {
    difference() {
        linear_extrude(height=axial_width) housing_profile_2d();
        pod_cavity_tool();
        body_bolt_cuts();
        translate([pod_center_x,-pod_length/2-0.1,axial_width/2])
            rotate([-90,0,0]) cylinder(d=8.2,h=case_wall+0.3);
    }
}

module clamp_cap() {
    difference() {
        linear_extrude(height=axial_width) cap_profile_2d();
        cap_bolt_cuts();
    }
}

module face_cover() {
    difference() {
        translate([pod_min_x-face_cover_thickness,0,axial_width/2])
            rotate([0,90,0]) linear_extrude(height=face_cover_thickness)
                rounded_box_2d(axial_width,pod_length,pod_corner);
        for (i=[0:2])
            translate([pod_min_x-face_cover_thickness-0.1,control_y[i],axial_width/2]) rotate([0,90,0])
                cylinder(d=button_cutout,h=face_cover_thickness+0.2);
        translate([pod_min_x-face_cover_thickness-0.1,control_y[3],axial_width/2]) rotate([0,90,0])
            cylinder(d=joystick_cutout,h=face_cover_thickness+0.2);
        for (y=[-35,35], z=[4.5,axial_width-4.5])
            translate([pod_min_x-face_cover_thickness-0.1,y,z]) rotate([0,90,0])
                cylinder(d=3.2,h=face_cover_thickness+0.2);
    }
}

module liner_half(right=false) {
    linear_extrude(height=axial_width) ring_half_2d(right,true);
}

module controls_and_board() {
    for (i=[0:2])
        translate([pod_min_x,control_y[i],axial_width/2]) rotate([0,90,0]) cylinder(d=12,h=switch_depth);
    translate([pod_min_x,control_y[3],axial_width/2]) rotate([0,90,0]) cylinder(d=20.1,h=joystick_depth);
    color([0.15,0.48,0.32,0.8])
        translate([xiao_x,xiao_y,axial_width/2]) cube([1.6,xiao_length,xiao_width],center=true);
    color([0.2,0.58,0.38,0.25])
        translate([xiao_x+1.6/2+xiao_header_projection/2,xiao_y,axial_width/2])
            cube([xiao_header_projection,xiao_length,xiao_width],center=true);
}

module control_heads() {
    panel_x=pod_min_x-face_cover_thickness;
    for (i=[0:2]) {
        color([0.30,0.36,0.39])
            translate([panel_x-0.8,control_y[i],axial_width/2]) rotate([0,90,0])
                difference() { cylinder(d=15,h=0.8); translate([0,0,-0.1]) cylinder(d=button_head_diameter+0.8,h=1.0); }
        color([0.16,0.21,0.24])
            translate([panel_x-button_head_projection,control_y[i],axial_width/2])
                rotate([0,90,0]) cylinder(d=button_head_diameter,h=face_cover_thickness+button_head_projection);
    }
    color([0.30,0.36,0.39])
        translate([panel_x-0.8,control_y[3],axial_width/2]) rotate([0,90,0])
            difference() { cylinder(d=16,h=0.8); translate([0,0,-0.1]) cylinder(d=5.3,h=1.0); }
    color([0.14,0.18,0.20])
        translate([panel_x-joystick_head_projection,control_y[3],axial_width/2])
            rotate([0,90,0]) cylinder(d=4.5,h=face_cover_thickness+joystick_head_projection);
    color([0.12,0.16,0.18])
        translate([panel_x-joystick_head_projection,control_y[3],axial_width/2])
            rotate([0,90,0]) cylinder(d=joystick_head_diameter,h=1.5);
}

module assembly() {
    color([0.67,0.73,0.77]) housing();
    color([0.53,0.60,0.64]) clamp_cap();
    color([0.84,0.87,0.89]) face_cover();
    color([0.72,0.48,0.22,0.8]) liner_half(false);
    color([0.72,0.48,0.22,0.8]) liner_half(true);
    clamp_bolts();
    control_heads();
    if (show_internals) controls_and_board();
    %color([0.5,0.5,0.5,0.35]) translate([0,0,axial_width/2]) cylinder(d=bar_diameter,h=100,center=true);
}

module cutaway() {
    // Omit the outer face cover so the component envelopes and available pod cavity are visible.
    color([0.67,0.73,0.77]) housing();
    color([0.53,0.60,0.64]) clamp_cap();
    color([0.72,0.48,0.22,0.8]) liner_half(false);
    color([0.72,0.48,0.22,0.8]) liner_half(true);
    clamp_bolts();
    if (show_internals) controls_and_board();
    %color([0.5,0.5,0.5,0.35]) translate([0,0,axial_width/2]) cylinder(d=bar_diameter,h=100,center=true);
}

module section_clip() {
    // Keep one axial half; the cut plane exposes the cavity and ring cross-section.
    translate([-200,-200,-1]) cube([400,400,axial_width/2+1]);
}

module section_view() {
    intersection() { color([0.67,0.73,0.77]) housing(); section_clip(); }
    intersection() { color([0.53,0.60,0.64]) clamp_cap(); section_clip(); }
    intersection() { color([0.72,0.48,0.22,0.8]) liner_half(false); section_clip(); }
    intersection() { color([0.72,0.48,0.22,0.8]) liner_half(true); section_clip(); }
    intersection() { clamp_bolts(); section_clip(); }
    if (show_internals)
        intersection() { controls_and_board(); section_clip(); }
    %intersection() {
        translate([0,0,axial_width/2]) cylinder(d=bar_diameter,h=100,center=true);
        section_clip();
    }
}

if (part_to_render=="section") section_view();
if (part_to_render=="cutaway") cutaway();
if (part_to_render=="assembly") assembly();
if (part_to_render=="housing") housing();
if (part_to_render=="clamp_cap") clamp_cap();
if (part_to_render=="cover") face_cover();
if (part_to_render=="liner_main") liner_half(false);
if (part_to_render=="liner_cap") liner_half(true);
