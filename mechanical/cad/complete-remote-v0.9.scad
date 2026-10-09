// Open Rally Remote — rounded enclosure cavity and full-length clamp shoulders, V0.9 concept
// Units: mm. Ring lies in XY; handlebar axis is Z. Controls are on the side face (YZ),
// so each button's actuation axis is X, perpendicular to the handlebar.
// The pod cavity now follows the rounded outer profile to preserve the end walls.

$fn = 96;
part_to_render = "assembly"; // assembly, housing, clamp_cap, cover, liner_main, liner_cap
show_internals = true;

bar_diameter = 22.0;
liner_radial = 1.0;
clamp_bore = bar_diameter + 2*liner_radial;
clamp_outer = 50.0;
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

clamp_bolt_d = 4.3;
cap_half_angle = 55.0;
split_lug_d = 10.0;
split_lug_radius = clamp_outer/2-5.0;
shoulder_inner_y = clamp_bore/2+2.0;
shoulder_case_x_outer = pod_center_x+pod_width/2-pod_corner;
shoulder_case_x_inner = pod_max_x;
shoulder_tip_x = clamp_outer/2*cos(cap_half_angle);
shoulder_tip_y = clamp_outer/2*sin(cap_half_angle);

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

module sector_mask(angle_start,angle_end,r=60) {
    polygon(points=concat([[0,0]], [for (a=[angle_start:1:angle_end]) [r*cos(a),r*sin(a)]]));
}

module ring_main_2d() {
    intersection() {
        difference() { circle(d=clamp_outer); circle(d=clamp_bore); }
        sector_mask(cap_half_angle,360-cap_half_angle);
    }
}

module ring_cap_2d() {
    intersection() {
        difference() { circle(d=clamp_outer); circle(d=clamp_bore); }
        sector_mask(-cap_half_angle,cap_half_angle);
    }
}

module split_lugs_2d(cap=false) {
    for (a=[-cap_half_angle,cap_half_angle])
        intersection() {
            translate([split_lug_radius*cos(a),split_lug_radius*sin(a)]) circle(d=split_lug_d);
            if (cap) sector_mask(-cap_half_angle,cap_half_angle);
            else sector_mask(cap_half_angle,360-cap_half_angle);
        }
}

module case_clamp_shoulders_2d() {
    polygon(points=[
        [shoulder_case_x_outer,pod_length/2],
        [shoulder_tip_x,shoulder_tip_y],
        [shoulder_tip_x*(shoulder_inner_y/(clamp_outer/2)),shoulder_tip_y*(shoulder_inner_y/(clamp_outer/2))],
        [shoulder_case_x_inner,pod_length/2-pod_corner]
    ]);
    mirror([0,1,0])
        polygon(points=[
            [shoulder_case_x_outer,pod_length/2],
            [shoulder_tip_x,shoulder_tip_y],
            [shoulder_tip_x*(shoulder_inner_y/(clamp_outer/2)),shoulder_tip_y*(shoulder_inner_y/(clamp_outer/2))],
            [shoulder_case_x_inner,pod_length/2-pod_corner]
        ]);
}

module housing_profile_2d() {
    difference() {
        union() {
            ring_main_2d();
            translate([pod_center_x,0]) rounded_box_2d(pod_width,pod_length,pod_corner);
            case_clamp_shoulders_2d();
            split_lugs_2d(false);
        }
        circle(d=clamp_bore);
    }
}

module cap_profile_2d() {
    difference() {
        union() {
            ring_cap_2d();
            split_lugs_2d(true);
        }
        circle(d=clamp_bore);
    }
}

module clamp_bolt_holes() {
    for (a=[-cap_half_angle,cap_half_angle])
        translate([split_lug_radius*cos(a),split_lug_radius*sin(a),axial_width/2])
            rotate([90,0,a+180]) cylinder(d=clamp_bolt_d,h=split_lug_d+0.2,center=true);
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
        clamp_bolt_holes();
        translate([pod_center_x,-pod_length/2-0.1,axial_width/2])
            rotate([-90,0,0]) cylinder(d=8.2,h=case_wall+0.3);
    }
}

module clamp_cap() {
    difference() {
        linear_extrude(height=axial_width) cap_profile_2d();
        clamp_bolt_holes();
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
    control_heads();
    if (show_internals) controls_and_board();
    %color([0.5,0.5,0.5,0.35]) translate([0,0,axial_width/2]) cylinder(d=bar_diameter,h=100,center=true);
}

if (part_to_render=="assembly") assembly();
if (part_to_render=="housing") housing();
if (part_to_render=="clamp_cap") clamp_cap();
if (part_to_render=="cover") face_cover();
if (part_to_render=="liner_main") liner_half(false);
if (part_to_render=="liner_cap") liner_half(true);
