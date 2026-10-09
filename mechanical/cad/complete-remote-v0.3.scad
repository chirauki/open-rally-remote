// Open Rally Remote — integrated split-ring enclosure, V0.3 concept
// Units: mm. Ring lies in XY; handlebar axis is Z. Controls are on the side face (YZ),
// so each button's actuation axis is X, perpendicular to the handlebar.
// The enclosure and main clamp half are one part. The right semicircle is a removable cap.
// Envelopes and clearances remain prototype targets, not manufacturing dimensions.

$fn = 96;
part_to_render = "assembly"; // assembly, housing, clamp_cap, cover, liner_main, liner_cap
show_internals = true;

bar_diameter = 22.0;
liner_radial = 1.0;
clamp_bore = bar_diameter + 2*liner_radial; // 24 mm nominal; liner ID is 22 mm
clamp_outer = 50.0;
axial_width = 27.0;                        // along the handlebar
case_wall = 2.0;
face_cover_thickness = 2.5;

pod_center_x = -35.0;
pod_width = 40.0;
pod_length = 82.0;
pod_corner = 7.0;
pod_min_x = pod_center_x-pod_width/2;
pod_max_x = pod_center_x+pod_width/2;
pod_cavity_x0 = pod_min_x-0.1;            // side opening closed by the removable control cover
pod_cavity_x1 = pod_max_x-case_wall-6.0;  // retain a substantial structural web into the clamp ring
pod_cavity_width = pod_cavity_x1-pod_cavity_x0;
pod_cavity_length = pod_length-2*case_wall;
button_cutout = 13.6;
joystick_cutout = 15.8;                     // nominal MHS circle; check full profile drawing
control_y = [27.0, 9.0, -9.0, -27.0];       // A, B, C, joystick; 18 mm pitch
switch_depth = 13.0;
joystick_depth = 13.5;
xiao_x = pod_cavity_x1-10.0;              // PCB plane; header envelope projects toward the rear wall
xiao_y = 0;
xiao_length = 21.0;
xiao_width = 17.8;
xiao_header_projection = 6.0;              // bought board has pre-soldered headers; measure before print

clamp_bolt_y = [-22.0,22.0];
clamp_bolt_d = 4.3;                         // M4 clearance; through-bolt and locknut are the current concept
lug_width = 16.0;                           // each half extends from the split to its accessible outer end
lug_length = 8.0;

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

module lug_pair_2d(right=false) {
    for (y=clamp_bolt_y)
        translate([right ? lug_width/2 : -lug_width/2,y])
            square([lug_width,lug_length],center=true);
}

module housing_profile_2d() {
    difference() {
        union() {
            ring_half_2d(false,false);
            translate([pod_center_x,0]) rounded_box_2d(pod_width,pod_length,pod_corner);
            lug_pair_2d(false);
        }
        // Keep the handlebar opening continuous through the main clamp half.
        circle(d=clamp_bore);
    }
}

module cap_profile_2d() {
    difference() {
        union() {
            ring_half_2d(true,false);
            lug_pair_2d(true);
        }
        circle(d=clamp_bore);
    }
}

module transverse_bolt_holes() {
    for (y=clamp_bolt_y)
        translate([-lug_width-0.1,y,axial_width/2]) rotate([0,90,0])
            cylinder(d=clamp_bolt_d,h=2*lug_width+0.2);
}

module housing() {
    difference() {
        linear_extrude(height=axial_width) housing_profile_2d();
        // Open the control pod from its radial side. The removable side cover closes this face.
        translate([pod_cavity_x0, -pod_cavity_length/2, case_wall])
            cube([pod_cavity_width,pod_cavity_length,axial_width-2*case_wall]);
        transverse_bolt_holes();
        // Cable entry through the lower end of the control pod.
        translate([pod_center_x,-pod_length/2-0.1,axial_width/2])
            rotate([-90,0,0]) cylinder(d=8.2,h=case_wall+0.3);
    }
}

module clamp_cap() {
    difference() {
        linear_extrude(height=axial_width) cap_profile_2d();
        transverse_bolt_holes();
    }
}

module face_cover() {
    difference() {
        // Side cover lies in the YZ plane; button axes point radially inward along +X.
        translate([pod_min_x-face_cover_thickness,0,axial_width/2])
            rotate([0,90,0]) linear_extrude(height=face_cover_thickness)
                rounded_box_2d(axial_width,pod_length,5.0);
        for (i=[0:2])
            translate([pod_min_x-0.1,control_y[i],axial_width/2]) rotate([0,90,0])
                cylinder(d=button_cutout,h=face_cover_thickness+0.2);
        translate([pod_min_x-0.1,control_y[3],axial_width/2]) rotate([0,90,0])
            cylinder(d=joystick_cutout,h=face_cover_thickness+0.2);
        // Four service screw holes on the side panel.
        for (y=[-35,35], z=[4.5,axial_width-4.5])
            translate([pod_min_x-0.1,y,z]) rotate([0,90,0])
                cylinder(d=3.2,h=face_cover_thickness+0.2);
    }
}

module liner_half(right=false) {
    linear_extrude(height=axial_width)
        ring_half_2d(right,true);
}

module controls_and_board() {
    // Switch and joystick envelopes extend inward from the side face; check real parts.
    for (i=[0:2])
        translate([pod_min_x,control_y[i],axial_width/2]) rotate([0,90,0])
            cylinder(d=12,h=switch_depth);
    translate([pod_min_x,control_y[3],axial_width/2]) rotate([0,90,0])
        cylinder(d=20,h=joystick_depth);
    // XIAO board is also turned 90 degrees, parallel to the control cover.
    color([0.15,0.48,0.32,0.8])
        translate([xiao_x,xiao_y,axial_width/2]) cube([1.6,xiao_length,xiao_width],center=true);
    // Pre-soldered header clearance envelope; verify its direction and USB connector on the real board.
    color([0.2,0.58,0.38,0.25])
        translate([xiao_x+1.6/2+ xiao_header_projection/2,xiao_y,axial_width/2])
            cube([xiao_header_projection,xiao_length,xiao_width],center=true);
}

module assembly() {
    color([0.67,0.73,0.77]) housing();
    color([0.53,0.60,0.64]) clamp_cap();
    color([0.84,0.87,0.89]) face_cover();
    color([0.72,0.48,0.22,0.8]) liner_half(false);
    color([0.72,0.48,0.22,0.8]) liner_half(true);
    if (show_internals) controls_and_board();
    %color([0.5,0.5,0.5,0.35]) translate([0,0,axial_width/2]) cylinder(d=bar_diameter,h=100,center=true);
}

if (part_to_render=="assembly") assembly();
if (part_to_render=="housing") housing();
if (part_to_render=="clamp_cap") clamp_cap();
if (part_to_render=="cover") face_cover();
if (part_to_render=="liner_main") liner_half(false);
if (part_to_render=="liner_cap") liner_half(true);
