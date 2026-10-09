// Open Rally Remote — print-ready concept, V0.19
// Units: mm. Ring lies in XY; handlebar axis is Z. Controls are on the side face (YZ),
// so each button's actuation axis is X, perpendicular to the handlebar.
//
// One outer silhouette (convex hull of the pod outline and the Ø44 clamp circle) is cut
// into three printed parts by two planes normal to X:
//   - face cover:  pod front slab, X in [cover_front_x, pod_min_x]
//   - housing:     X in [pod_min_x, body_face_x], with the pod cavity and front half of the clamp
//   - clamp cap:   X >= cap_face_x, the rear half of the clamp
// Because every part is a slice of the same extruded silhouette, the cover matches the box.
//
// Values marked MEASURE are supplier or purchase unknowns; check them on the real parts.

$fn = 96;
part_to_render = "assembly"; // assembly, interior, section, housing, clamp_cap, cover, liner_main, liner_cap,
                             // print_housing, print_cap, print_cover
show_internals = true;       // component envelopes in assembly/section

// --- Handlebar and clamp -------------------------------------------------------------
bar_diameter = 22.0;         // MEASURE the straight section of the bar
liner_radial = 1.0;          // TPU liner; tune to measured bar and print process
clamp_bore = bar_diameter + 2*liner_radial;
clamp_outer = 44.0;
clamp_radial_section = (clamp_outer-clamp_bore)/2;
axial_width = 23.0;          // NAVCOMM manual: at least 23 mm free between grip and switchgear

split_gap = 0.8;             // total gap between body and cap faces; closes as bolts clamp the liner
clamp_bolt_y = 17.0;
clamp_bolt_d = 4.3;          // M4 clearance
bolt_length = 16.0;          // ISO 4762 M4 x 16
bolt_head_d = 7.0;
bolt_head_h = 4.0;
bolt_head_clear_d = 7.6;
cap_seat_x = 8.0;
insert_hole_d = 5.6;         // M4 heat-set insert hole; MEASURE against insert datasheet
insert_depth = 8.1;
bolt_tip_clearance = 2.0;

// --- Pod -------------------------------------------------------------------------------
case_wall = 1.0;             // axial and end walls; limited by the 20.1 mm joystick candidate
face_cover_thickness = 2.5;  // panel range: APEM IS 1.5-4 mm, MHS 2-3 mm
pod_center_x = -35.0;
pod_width = 40.0;            // housing part only, excluding the cover
pod_length = 82.0;
pod_rear_corner = 7.0;       // sets the tangent diagonals to the clamp ring
pod_front_corner = 3.0;      // small enough to leave a flat cover face for the corner screws
pod_min_x = pod_center_x-pod_width/2;        // housing front face = cover rear face
pod_max_x = pod_center_x+pod_width/2;
cover_front_x = pod_min_x-face_cover_thickness;

pod_cavity_x0 = pod_min_x-0.1;
pod_cavity_x1 = pod_max_x-case_wall-6.0;
pod_cavity_half_length = pod_length/2-case_wall;
pod_cavity_front_corner = 2.0;
pod_cavity_rear_corner = 6.0;

// --- Controls (envelopes from supplier drawings; MEASURE exact order codes) ------------
button_cutout = 13.6;        // APEM IS
joystick_cutout = 15.8;      // Ruffy MHS nominal M16
control_y = [29.0, 11.0, -7.0, -25.0]; // 18 mm pitch, centred so both pod ends keep margin
button_body_d = 12.0;
switch_depth = 13.0;
joystick_body_d = 20.1;
joystick_depth = 13.5;
button_head_projection = 1.8;
button_head_diameter = 10.0;
joystick_head_projection = 5.0;
joystick_head_diameter = 9.0;

// --- Cover fasteners: M2 x 6 ISO 10642 countersunk into M2 heat-set inserts ------------
cover_screw_y = 35.5;
cover_screw_z = [3.25, axial_width-3.25];
cover_screw_clear_d = 2.4;
cover_csk_d = 4.4;
cover_boss_d = 6.0;
cover_boss_depth = 8.0;
cover_insert_hole_d = 3.2;   // MEASURE against insert datasheet
cover_insert_depth = 5.0;

// --- XIAO nRF52840 (pre-soldered headers) ----------------------------------------------
xiao_length = 21.0;          // along Y; USB-C at the -Y end
xiao_width = 17.8;           // along Z
xiao_pcb = 1.2;              // MEASURE
xiao_x = -32.5;              // PCB mid-plane; component side faces the controls (-X)
xiao_y = 0;
xiao_component_h = 3.4;      // USB-C and shield height above PCB; MEASURE
xiao_header_plastic = 2.5;   // header spacer on the +X side; MEASURE
xiao_pin_length = 6.0;       // pin length beyond the spacer; MEASURE
xiao_pin_inset = 1.27;       // pin row centre from the long PCB edge
xiao_rail_lip = 0.8;         // how much the slot overlaps the PCB edge
xiao_rail_wall = 1.2;
xiao_clear = 0.15;

// --- Cable entry -----------------------------------------------------------------------
cable_x = pod_center_x;
cable_hole_d = 8.2;          // M8 gland clearance; MEASURE chosen gland
gland_boss_thickness = 2.0;  // added to the 1 mm end wall around the gland
gland_boss_w = 14.0;

// --- Derived values and checks ---------------------------------------------------------
cap_face_x = split_gap/2;
body_face_x = -split_gap/2;
bolt_tip_x = cap_seat_x-bolt_length;
bolt_engagement = body_face_x-bolt_tip_x;
cap_grip = cap_seat_x-cap_face_x;
bore_wall_at_bolt = clamp_bolt_y-clamp_bore/2-clamp_bolt_d/2;
assert(bolt_tip_x >= body_face_x-insert_depth, "Bolt is longer than the insert hole");
assert(bore_wall_at_bolt >= 2.0, "Bolt hole too close to the clamp bore");

xiao_pcb_x0 = xiao_x-xiao_pcb/2;
xiao_pcb_x1 = xiao_x+xiao_pcb/2;
xiao_pin_tip_x = xiao_pcb_x1+xiao_header_plastic+xiao_pin_length;
xiao_component_x = xiao_pcb_x0-xiao_component_h;
xiao_z0 = axial_width/2-xiao_width/2;
control_rear_x = pod_min_x+max(switch_depth,joystick_depth);
wire_gap = xiao_component_x-control_rear_x;
joy_axial_clear = (axial_width-2*case_wall-joystick_body_d)/2;
joy_end_clear = (control_y[3]-joystick_body_d/2)-(-pod_cavity_half_length);
assert(xiao_pin_tip_x <= pod_cavity_x1-0.5, "XIAO pins reach the cavity rear wall");

echo(str("Pod cavity (mm): ",pod_cavity_x1-pod_cavity_x0," x ",2*pod_cavity_half_length," x ",axial_width-2*case_wall));
echo(str("Clamp bolts M4x",bolt_length," at Y=±",clamp_bolt_y,"; cap grip ",cap_grip,
    " mm, insert engagement ",bolt_engagement," mm, wall to bore ",bore_wall_at_bolt," mm"));
echo(str("Wiring gap control rear to XIAO component side (mm): ",wire_gap));
echo(str("XIAO pin tips to cavity rear wall (mm): ",pod_cavity_x1-xiao_pin_tip_x));
echo(str("Joystick clearance: axial ",joy_axial_clear," mm per side, to end wall ",joy_end_clear," mm"));

// ======================================================================================
// 2D profiles
// ======================================================================================

module rounded_box_2d(w,l,r) {
    offset(r=r) square([w-2*r,l-2*r],center=true);
}

module four_corner_box_2d(x0,x1,half_l,rf,rr) {
    // Rectangle from x0 to x1 and ±half_l, front (x0) corners rf, rear (x1) corners rr.
    hull() for (s=[-1,1]) {
        translate([x0+rf,s*(half_l-rf)]) circle(r=rf);
        translate([x1-rr,s*(half_l-rr)]) circle(r=rr);
    }
}

module pod_outline_2d() {
    four_corner_box_2d(cover_front_x,pod_max_x,pod_length/2,pod_front_corner,pod_rear_corner);
}

module outer_silhouette_2d() {
    hull() { pod_outline_2d(); circle(d=clamp_outer); }
}

module x_band_2d(x0,x1) {
    translate([x0,-100]) square([x1-x0,200]);
}

module housing_profile_2d() {
    difference() {
        intersection() { outer_silhouette_2d(); x_band_2d(pod_min_x,body_face_x); }
        circle(d=clamp_bore);
    }
}

module cap_profile_2d() {
    difference() {
        intersection() { outer_silhouette_2d(); x_band_2d(cap_face_x,100); }
        circle(d=clamp_bore);
    }
}

module cover_profile_2d() {
    intersection() { outer_silhouette_2d(); x_band_2d(cover_front_x,pod_min_x); }
}

module cavity_profile_2d() {
    four_corner_box_2d(pod_cavity_x0,pod_cavity_x1,pod_cavity_half_length,
        pod_cavity_front_corner,pod_cavity_rear_corner);
}

module ring_half_2d(right=false) {
    difference() {
        intersection() {
            circle(d=clamp_bore);
            if (right) translate([0,-50]) square([100,100]);
            else translate([-100,-50]) square([100,100]);
        }
        circle(d=bar_diameter);
    }
}

// ======================================================================================
// Clamp fasteners
// ======================================================================================

// Bolt axes run along X; inside at_bolts(), local Z equals global X.
module at_bolts() {
    for (s=[-1,1]) translate([0,s*clamp_bolt_y,axial_width/2]) rotate([0,90,0]) children();
}

module cap_bolt_cuts() {
    at_bolts() {
        translate([0,0,-0.1]) cylinder(d=clamp_bolt_d,h=cap_seat_x+0.2);
        translate([0,0,cap_seat_x]) cylinder(d=bolt_head_clear_d,h=30);
    }
}

module body_bolt_cuts() {
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

// ======================================================================================
// Housing internal features
// ======================================================================================

module at_cover_screws() {
    for (y=[-cover_screw_y,cover_screw_y], z=cover_screw_z)
        translate([0,y,z]) children();
}

module cover_bosses() {
    // Bosses along X from the housing front face, joined to the nearest end wall.
    for (s=[-1,1], z=cover_screw_z)
        hull() {
            translate([pod_min_x,s*cover_screw_y,z]) rotate([0,90,0]) cylinder(d=cover_boss_d,h=cover_boss_depth);
            translate([pod_min_x,s*(pod_cavity_half_length+0.5),z]) rotate([0,90,0])
                cylinder(d=cover_boss_d,h=cover_boss_depth);
        }
}

module cover_insert_holes() {
    at_cover_screws()
        translate([pod_min_x-0.1,0,0]) rotate([0,90,0]) cylinder(d=cover_insert_hole_d,h=cover_insert_depth+0.1);
}

module gland_boss() {
    translate([cable_x-gland_boss_w/2,-pod_cavity_half_length-0.1,case_wall-0.1])
        cube([gland_boss_w,gland_boss_thickness+0.1,axial_width-2*case_wall+0.2]);
}

module cable_hole() {
    translate([cable_x,-pod_length/2-0.1,axial_width/2]) rotate([-90,0,0])
        cylinder(d=cable_hole_d,h=case_wall+gland_boss_thickness+0.3);
}

module xiao_rail() {
    // Slot holding one long PCB edge plus its header spacer; the board slides in along +Y
    // and stops against the closed +Y end.
    slot_x0 = xiao_pcb_x0-xiao_clear;
    slot_x1 = xiao_pcb_x1+xiao_header_plastic+xiao_clear;
    edge_z = xiao_z0-xiao_clear;
    y0 = xiao_y-xiao_length/2-1.0;
    y1 = xiao_y+xiao_length/2+xiao_clear;
    // Cross-section in XZ with a 45-degree chamfer on the -X side, so the rail needs no
    // support when the housing prints front face down.
    zb = case_wall-0.1;
    zt = edge_z+xiao_rail_lip;
    xa = slot_x0-xiao_rail_wall;
    xb = slot_x1+xiao_rail_wall;
    difference() {
        translate([0,y1+xiao_rail_wall,0]) rotate([90,0,0])
            linear_extrude(height=y1+xiao_rail_wall-y0)
                polygon([[xa-(zt-zb),zb],[xb,zb],[xb,zt],[xa,zt]]);
        translate([slot_x0,y0-0.1,edge_z]) cube([slot_x1-slot_x0,y1-y0+0.1,xiao_rail_lip+1]);
    }
}

module xiao_rails() {
    xiao_rail();
    translate([0,0,axial_width]) mirror([0,0,1]) xiao_rail();
}

module housing() {
    difference() {
        union() {
            difference() {
                linear_extrude(height=axial_width) housing_profile_2d();
                translate([0,0,case_wall]) linear_extrude(height=axial_width-2*case_wall) cavity_profile_2d();
            }
            intersection() {
                union() { cover_bosses(); gland_boss(); xiao_rails(); }
                linear_extrude(height=axial_width) housing_profile_2d();
            }
        }
        body_bolt_cuts();
        cover_insert_holes();
        cable_hole();
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
        linear_extrude(height=axial_width) cover_profile_2d();
        for (i=[0:2])
            translate([cover_front_x-0.1,control_y[i],axial_width/2]) rotate([0,90,0])
                cylinder(d=button_cutout,h=face_cover_thickness+0.2);
        translate([cover_front_x-0.1,control_y[3],axial_width/2]) rotate([0,90,0])
            cylinder(d=joystick_cutout,h=face_cover_thickness+0.2);
        at_cover_screws() translate([cover_front_x,0,0]) rotate([0,90,0]) {
            translate([0,0,-0.1]) cylinder(d=cover_screw_clear_d,h=face_cover_thickness+0.2);
            translate([0,0,-0.01]) cylinder(d1=cover_csk_d,d2=cover_screw_clear_d,h=(cover_csk_d-cover_screw_clear_d)/2);
        }
    }
}

module liner_half(right=false) {
    linear_extrude(height=axial_width) ring_half_2d(right);
}

// ======================================================================================
// Component envelopes (not printed)
// ======================================================================================

module xiao_envelope() {
    color([0.15,0.48,0.32])
        translate([xiao_pcb_x0,xiao_y-xiao_length/2,xiao_z0]) cube([xiao_pcb,xiao_length,xiao_width]);
    // Shield and USB-C on the component side; USB-C at the -Y end.
    color([0.75,0.75,0.78])
        translate([xiao_component_x,xiao_y-xiao_length/2+3,xiao_z0+2.5]) cube([xiao_component_h,14,xiao_width-5]);
    color([0.6,0.6,0.62])
        translate([xiao_pcb_x0-3.2,xiao_y-xiao_length/2-1.2,axial_width/2-4.5]) cube([3.2,7.5,9.0]);
    // Header spacers and pins on the +X side, along both long edges.
    for (z=[xiao_z0+xiao_pin_inset, xiao_z0+xiao_width-xiao_pin_inset]) {
        color([0.1,0.1,0.1])
            translate([xiao_pcb_x1,xiao_y-7*2.54/2,z-1.27]) cube([xiao_header_plastic,7*2.54,2.54]);
        color([0.85,0.7,0.2])
            for (i=[0:6]) translate([xiao_pcb_x1,xiao_y-3*2.54+i*2.54,z]) rotate([0,90,0])
                translate([0,0,0]) cylinder(d=0.64,h=xiao_header_plastic+xiao_pin_length,$fn=8);
    }
}

module controls_and_board() {
    color([0.85,0.55,0.20])
        for (i=[0:2])
            translate([pod_min_x,control_y[i],axial_width/2]) rotate([0,90,0]) cylinder(d=button_body_d,h=switch_depth);
    color([0.80,0.35,0.20])
        translate([pod_min_x,control_y[3],axial_width/2]) rotate([0,90,0]) cylinder(d=joystick_body_d,h=joystick_depth);
    xiao_envelope();
}

module control_heads() {
    panel_x=cover_front_x;
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

// ======================================================================================
// Views
// ======================================================================================

module bar_ghost() {
    %color([0.5,0.5,0.5,0.35]) translate([0,0,axial_width/2]) cylinder(d=bar_diameter,h=100,center=true);
}

module assembly() {
    color([0.67,0.73,0.77]) housing();
    color([0.53,0.60,0.64]) clamp_cap();
    color([0.84,0.87,0.89]) face_cover();
    color([0.72,0.48,0.22,0.8]) liner_half(false);
    color([0.72,0.48,0.22,0.8]) liner_half(true);
    clamp_bolts();
    control_heads();
    bar_ghost();
}

module interior_cutter() {
    // Remove the upper axial wall only, so the cavity is seen from +Z with everything in place.
    translate([-200,-200,axial_width-case_wall]) cube([400,400,10]);
}

module interior_view() {
    color([0.67,0.73,0.77]) difference() { housing(); interior_cutter(); }
    color([0.53,0.60,0.64]) difference() { clamp_cap(); interior_cutter(); }
    color([0.84,0.87,0.89]) difference() { face_cover(); interior_cutter(); }
    color([0.72,0.48,0.22,0.8]) liner_half(false);
    color([0.72,0.48,0.22,0.8]) liner_half(true);
    clamp_bolts();
    control_heads();
    controls_and_board();
}

module section_clip() {
    translate([-200,-200,-1]) cube([400,400,axial_width/2+1]);
}

module section_view() {
    intersection() { color([0.67,0.73,0.77]) housing(); section_clip(); }
    intersection() { color([0.53,0.60,0.64]) clamp_cap(); section_clip(); }
    intersection() { color([0.84,0.87,0.89]) face_cover(); section_clip(); }
    intersection() { color([0.72,0.48,0.22,0.8]) liner_half(false); section_clip(); }
    intersection() { color([0.72,0.48,0.22,0.8]) liner_half(true); section_clip(); }
    intersection() { clamp_bolts(); section_clip(); }
    if (show_internals) intersection() { controls_and_board(); section_clip(); }
}

// Print orientations: no supports needed.
// Housing: front face down. The bore half and shoulders narrow upward; the cavity end at
// X = pod_cavity_x1 bridges 21 mm along Z.
module print_housing() { translate([0,0,-pod_min_x]) rotate([0,-90,0]) housing(); }
// Cap: axial face down, so the bore and bolt holes print as true circles.
module print_cap() { clamp_cap(); }
// Cover: outer face down.
module print_cover() { translate([0,0,-cover_front_x]) rotate([0,-90,0]) face_cover(); }

if (part_to_render=="assembly") assembly();
if (part_to_render=="interior") interior_view();
if (part_to_render=="section") section_view();
if (part_to_render=="housing") housing();
if (part_to_render=="clamp_cap") clamp_cap();
if (part_to_render=="cover") face_cover();
if (part_to_render=="liner_main") liner_half(false);
if (part_to_render=="liner_cap") liner_half(true);
if (part_to_render=="print_housing") print_housing();
if (part_to_render=="print_cap") print_cap();
if (part_to_render=="print_cover") print_cover();
