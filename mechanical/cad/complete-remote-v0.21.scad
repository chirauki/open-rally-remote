// Open Rally Remote — concept, V0.21
// Units: mm. Ring lies in XY; handlebar axis is Z. Controls are on the side face (YZ).
//
// V0.20 folds the control face between button C and the lower control: the upper facet (A, B, C)
// stays normal to X, the lower facet turns fold_angle toward the bar so the lower end of the
// pod clears the thumb's path to the turn-signal switch.
//
// V0.21 replaces the panel joystick with a four-key direction pad: four round printed keys in a
// diamond, each over its own sealed SMT tact switch (C&K KSC2) on a small PCB. On the lower
// facet the gasket becomes a full sheet: it seals the cover joint and is the membrane under the
// keys. A printed keypad plate behind the sheet clamps it under the same four cover screws and
// carries the PCB.
//
// One outer silhouette (convex hull of the pod outline and the Ø44 clamp circle) is cut into
// printed parts by offsets of the folded front and by the diametral clamp split:
//   - face cover:  0 .. face_cover_thickness behind the folded front
//   - gasket:      the next gasket_gap (compressed thickness); wall land on the upper facet,
//                  a full sheet on the lower facet
//   - keypad plate: behind the lower-facet sheet, keypad_plate_t thick
//   - housing:     behind that, up to the split plane X = body_face_x
//   - clamp cap:   X >= cap_face_x
//
// Values marked MEASURE are supplier or purchase unknowns; check them on the real parts.

$fn = 96;
part_to_render = "assembly"; // assembly, interior, section, housing, clamp_cap, cover, gasket, keys,
                             // keypad_plate, liner_main, liner_cap, print_housing, print_cap,
                             // print_cover, print_gasket, print_keys, print_keypad_plate
show_internals = true;       // component envelopes in section

// --- Handlebar and clamp -------------------------------------------------------------
bar_diameter = 22.0;         // MEASURE the straight section of the bar
liner_radial = 1.0;          // TPU liner; tune to measured bar and print process
clamp_bore = bar_diameter + 2*liner_radial;
clamp_outer = 44.0;
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

// --- Pod and folded front --------------------------------------------------------------
case_wall = 1.0;             // axial and end walls
face_cover_thickness = 2.5;  // panel range: APEM IS 1.5-4 mm
gasket_gap = 0.6;            // compressed gasket thickness between cover and housing
gasket_print_thickness = 0.8;// printed or cut thickness; 25 % compression
cover_front_x = -57.5;       // upper facet outer plane
fold_y = -12.5;              // fold line on the outer surface, between button C and the direction pad
fold_angle = 20;             // lower facet turns this far toward the bar; 30 deg needs the gland at the top
                             // (V0.20 joystick values: centre 16.5, lower_facet_length 32, lower screws at 5 and 27.6)
lower_facet_length = 30.0;   // outer surface, fold to lower end; sized for the corner cover screws
pod_top_y = 44.0;
pod_max_x = -15.0;
pod_rear_corner = 7.0;       // sets the tangent diagonals to the clamp ring
pod_front_corner = 3.0;
pod_cavity_x1 = pod_max_x-case_wall-6.0;
pod_cavity_front_corner = 2.0;
pod_cavity_rear_corner = 6.0;
lip_width = 3.0;             // gasket land added inside the axial walls along the upper facet
lip_depth = 2.0;

fold_d = [sin(fold_angle), -cos(fold_angle)];   // down the lower facet
fold_n = [cos(fold_angle), sin(fold_angle)];    // inward normal of the lower facet
fold_p = [cover_front_x, fold_y];
pod_end = fold_p + lower_facet_length*fold_d;   // outer lower corner before rounding
pod_bottom_y = pod_end[1];

cover_back_off = face_cover_thickness;
housing_front_off = face_cover_thickness+gasket_gap;

// Point on the folded front: facet 0 = upper (u is Y), facet 1 = lower (u is distance from fold).
function front_point(facet,u) = facet==0 ? [cover_front_x,u] : fold_p+u*fold_d;
function front_normal(facet) = facet==0 ? [1,0] : fold_n;

// --- Controls (envelopes from supplier drawings; MEASURE exact order codes) ------------
button_cutout = 13.6;        // APEM IS
button_y = [32.0, 14.0, -4.0];  // A, B, C on the upper facet, 18 mm pitch
button_body_d = 12.0;
switch_depth = 13.0;
button_head_projection = 1.8;
button_head_diameter = 10.0;
teardrop_cap = 0.0;          // flat cutout top this far above the circle (cover prints on its side)

// --- Direction pad: four printed keys over C&K KSC2 sealed SMT tact switches -----------
// Pad frame (at_pad): origin on the outer cover face, +Z into the pod along the lower-facet
// normal, +Y up the facet toward button C, X along the bar.
pad_s = 14.75;               // pad centre from the fold along the lower facet
key_xy = [[0,7.0],[0,-7.0],[-5.0,0],[5.0,0]];   // up (toward C), down, and the two bar-axis keys
key_d = 7.0;                 // round key cap
key_clear = 0.25;            // radial, key to window
key_window_d = key_d+2*key_clear;
key_flange_d = key_window_d+0.8;  // retains the key; 0.4 mm overlap per side
key_pocket_d = key_flange_d+0.6;  // flange pocket in the cover back
key_pocket_depth = 1.3;      // cover is 1.2 mm thick over the pockets
key_flange_t = 0.6;
key_proud = 1.5;             // key top above the cover face
key_nub_d = 3.0;             // presses the sheet onto the switch actuator
key_nub_clear = 0.05;        // nub to uncompressed sheet at rest
key_arrow_depth = 0.4;       // engraved arrow on the key top
ksc_body = 6.5;              // KSC2 6.2 +0.3 / 0 mm
ksc_h = 3.5;                 // soft actuator top above the PCB
ksc_body_h = 2.9;
ksc_actuator_d = 2.9;
pad_pcb_t = 1.6;
pad_pcb_rear = 1.0;          // solder joints and wires behind the PCB
keypad_plate_t = 1.5;
keypad_plate_u0 = 1.0;       // plate and full sheet start this far below the fold
plate_switch_hole = 6.7;
pad_standoffs = [[-5.6,5.4],[5.6,-5.4]];
pad_standoff_d = 3.6;        // M2 thread-forming screw for plastics; MEASURE pilot for chosen screw
pad_standoff_pilot = 1.6;
pad_pcb_hole_d = 2.2;

// --- Cover fasteners: M2 ISO 10642 countersunk into M2 heat-set inserts ----------------
// [facet, u]; each position has a screw near both axial walls. Lower-facet screws also pass
// through the keypad plate, so they are longer and their bosses start behind the plate.
cover_screws = [[0,39.5],[0,23.0],[0,5.0],[1,3.5],[1,25.3]];
cover_screw_z = [3.25, axial_width-3.25];
cover_screw_length = 8.0;
cover_screw_length_lower = 10.0;
cover_screw_clear_d = 2.4;
cover_csk_d = 4.4;
cover_boss_d = 6.0;
cover_boss_depth = 8.0;
cover_insert_hole_d = 3.2;   // MEASURE against insert datasheet
cover_insert_depth = 6.0;

// --- XIAO nRF52840 (pre-soldered headers) ----------------------------------------------
xiao_length = 21.0;          // along Y; USB-C at the -Y end
xiao_width = 17.8;           // along Z
xiao_pcb = 1.2;              // MEASURE
xiao_x = -32.5;              // PCB mid-plane; component side faces the controls (-X)
xiao_y = 10.0;               // raised so a USB-C plug clears the lower cover-screw bosses
xiao_component_h = 3.4;      // USB-C and shield height above PCB; MEASURE
xiao_header_plastic = 2.5;   // header spacer on the +X side; MEASURE
xiao_pin_length = 6.0;       // pin length beyond the spacer; MEASURE
xiao_pin_inset = 1.27;       // pin row centre from the long PCB edge
xiao_rail_lip = 0.8;         // how much the slot overlaps the PCB edge
xiao_rail_wall = 1.2;
xiao_clear = 0.15;

// --- Cable entry and vent --------------------------------------------------------------
cable_at_bottom = true;      // false puts the gland in the top end wall
cable_x = cable_at_bottom ? -32.0 : -34.0;
cable_hole_d = 8.2;          // M8 gland clearance; MEASURE chosen gland
gland_boss_thickness = 2.0;  // added to the 1 mm end wall around the gland
gland_boss_w = 14.0;
gland_nut_d = 15.0;          // M8 lock nut across corners; MEASURE
gland_nut_h = 4.0;
vent_hole_d = 3.0;           // behind an adhesive ePTFE vent; MEASURE chosen vent
vent_pad_d = 10.0;           // flat area kept free inside the Z = 0 wall for the vent label
vent_x = -27.0;              // low end of the pod, behind the direction pad
vent_y = -31.0;

// --- Derived values and checks ---------------------------------------------------------
cap_face_x = split_gap/2;
body_face_x = -split_gap/2;
bolt_tip_x = cap_seat_x-bolt_length;
bolt_engagement = body_face_x-bolt_tip_x;
cap_grip = cap_seat_x-cap_face_x;
bore_wall_at_bolt = clamp_bolt_y-clamp_bore/2-clamp_bolt_d/2;
assert(bolt_tip_x >= body_face_x-insert_depth, "Bolt is longer than the insert hole");
assert(bore_wall_at_bolt >= 2.0, "Bolt hole too close to the clamp bore");

cover_back_x = cover_front_x+face_cover_thickness;
housing_front_x = cover_front_x+housing_front_off;
pad_p = front_point(1,pad_s);
plate_front_off = housing_front_off;                  // keypad plate front, on the sheet
plate_back_off = plate_front_off+keypad_plate_t;
ksc_top_off = cover_back_off+gasket_print_thickness;  // actuator touches the uncompressed sheet
pad_pcb_off = ksc_top_off+ksc_h;                      // PCB front face
pad_rear_off = pad_pcb_off+pad_pcb_t+pad_pcb_rear;
key_flange_off = cover_back_off-key_pocket_depth;
key_nub_off = key_flange_off+key_flange_t;
key_relief = cover_back_off-key_nub_clear-key_nub_off; // key travel before the flange meets the sheet
pad_standoff_h = pad_pcb_off-plate_back_off;
key_reach_y = max([for (k=key_xy) abs(k[1])])+key_pocket_d/2;
key_reach_x = max([for (k=key_xy) abs(k[0])])+key_pocket_d/2;
xiao_pcb_x0 = xiao_x-xiao_pcb/2;
xiao_pcb_x1 = xiao_x+xiao_pcb/2;
xiao_pin_tip_x = xiao_pcb_x1+xiao_header_plastic+xiao_pin_length;
xiao_component_x = xiao_pcb_x0-xiao_component_h;
xiao_z0 = axial_width/2-xiao_width/2;
wire_gap = xiao_component_x-(cover_back_x+switch_depth);
cover_screw_thread = cover_screw_length-housing_front_off;
cover_screw_thread_lower = cover_screw_length_lower-plate_back_off;
assert(xiao_pin_tip_x <= pod_cavity_x1-0.5, "XIAO pins reach the cavity rear wall");
assert(cover_screw_thread <= cover_insert_depth-0.5, "Cover screw bottoms in the insert hole");
assert(cover_screw_thread_lower <= cover_insert_depth-0.5, "Lower cover screw bottoms in the insert hole");
assert(key_relief >= 0.5, "Key flange meets the sheet before a KSC2 reaches full travel (0.5 mm max)");
assert(key_flange_off >= 1.0, "Cover too thin over the key pockets");

echo(str("Pod Y ",pod_bottom_y," .. ",pod_top_y," (length ",pod_top_y-pod_bottom_y,"); lower end set back ",
    pod_end[0]-cover_front_x," mm"));
echo(str("Pad centre on the cover face ",pad_p,", set back ",pad_p[0]-cover_front_x," mm"));
echo(str("Pad sheet seal: fold side ",pad_s-key_reach_y-keypad_plate_u0," mm, lower end to u ",pad_s+key_reach_y,
    " of ",lower_facet_length,"; across ",axial_width/2-key_reach_x," mm to the outer edge"));
echo(str("Keys d",key_d,", proud ",key_proud,", relief ",key_relief,"; PCB front at ",pad_pcb_off,
    ", pad rear at ",pad_rear_off," mm behind the face"));
echo(str("Bar axis to button C face ",-cover_front_x," mm perpendicular, ",norm([cover_front_x,button_y[2]])," mm direct"));
echo(str("Clamp bolts M4x",bolt_length,"; cap grip ",cap_grip," mm, insert engagement ",bolt_engagement,
    " mm, wall to bore ",bore_wall_at_bolt," mm"));
echo(str("Cover screws M2x",cover_screw_length,", thread into insert ",cover_screw_thread," mm; lower M2x",
    cover_screw_length_lower,", ",cover_screw_thread_lower," mm"));
echo(str("Wiring gap button rear to XIAO component side (mm): ",wire_gap));
echo(str("XIAO pin tips to cavity rear wall (mm): ",pod_cavity_x1-xiao_pin_tip_x));

// ======================================================================================
// 2D profiles
// ======================================================================================

// Pod outline, inset from the outer surface. Front corners rf, rear corners rr at x_rear.
module pod_shape_2d(inset,rf,x_rear,rr) {
    xr = x_rear-rr;
    hull() {
        offset(r=rf) offset(delta=-rf) offset(delta=-inset)
            polygon([[cover_front_x,pod_top_y],fold_p,pod_end,[xr,pod_bottom_y],[xr,pod_top_y]]);
        translate([xr,pod_top_y-inset-rr]) circle(r=rr);
        translate([xr,pod_bottom_y+inset+rr]) circle(r=rr);
    }
}

module pod_outline_2d() { pod_shape_2d(0,pod_front_corner,pod_max_x,pod_rear_corner); }
module cavity_profile_2d() { pod_shape_2d(case_wall,pod_cavity_front_corner,pod_cavity_x1,pod_cavity_rear_corner); }

module outer_silhouette_2d() {
    hull() { pod_outline_2d(); circle(d=clamp_outer); }
}

// Fold corner of the front offset by t: where the two offset facet lines meet.
function fold_corner(t) = fold_p+t*fold_n+t*tan(fold_angle/2)*fold_d;

// Region between offsets t0 and t1 behind the folded front, extended past the pod ends.
module front_band_2d(t0,t1) {
    polygon([[cover_front_x+t0,100],fold_corner(t0),fold_corner(t0)+80*fold_d,
             fold_corner(t1)+80*fold_d,fold_corner(t1),[cover_front_x+t1,100]]);
}

module x_band_2d(x0,x1) {
    translate([x0,-100]) square([x1-x0,200]);
}

module housing_profile_2d() {
    difference() {
        intersection() { outer_silhouette_2d(); x_band_2d(-100,body_face_x); }
        front_band_2d(-10,housing_front_off);
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
    intersection() { outer_silhouette_2d(); front_band_2d(0,face_cover_thickness); }
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
// Placement helpers
// ======================================================================================

// Local +Z along direction a (in XY) at point p (XY) and height z.
module along(p,a,z) {
    translate([p[0],p[1],z]) rotate([0,0,atan2(a[1],a[0])]) rotate([0,90,0]) children();
}

// Cover screws: local +Z points into the part, origin on the outer cover face.
module at_cover_screws() {
    for (s=cover_screws, z=cover_screw_z)
        along(front_point(s[0],s[1]),front_normal(s[0]),z) children();
}

module at_buttons(off=0) {
    for (y=button_y) along([cover_front_x+off,y],[1,0],axial_width/2) children();
}

// Pad frame: along() maps local X to global -Z and local Y to -fold_d (up the facet).
module at_pad(off=0) {
    along(pad_p+off*fold_n,fold_n,axial_width/2) children();
}

module at_keys(off=0) {
    at_pad(off) for (k=key_xy) translate([k[0],k[1],0]) children();
}

// Lower-facet side of the line u = u0 (u measured from the fold along the outer facet).
module lower_side_2d(u0) {
    p = fold_p+u0*fold_d;
    translate(p) rotate(atan2(fold_d[1],fold_d[0])) translate([0,-100]) square([100,200]);
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

module cover_bosses() {
    // Upper-facet bosses start at the cover back face (so the gasket gets the same land) and
    // run 8 mm into the housing. Lower-facet bosses start behind the keypad plate, which they
    // clamp against the sheet. The end positions are joined to the nearest end wall.
    boss_end = cover_back_off+gasket_gap+cover_boss_depth;
    for (i=[0:len(cover_screws)-1], z=cover_screw_z) {
        s = cover_screws[i];
        p = front_point(s[0],s[1]);
        a = front_normal(s[0]);
        b0 = boss_start_off(s[0]);
        join = i==0 ? [0,6] : (i==len(cover_screws)-1 ? [0,-6] : [0,0]);
        // The joined copy keeps the V0.20 depth behind it, but never starts in front of b0
        // measured from the facet, so the lower end boss stays clear of the keypad plate.
        hull() for (j=[[0,0],join]) {
            d0 = b0-(j*a);
            along(p+j,a,z) translate([0,0,d0]) cylinder(d=cover_boss_d,h=boss_end-d0);
        }
    }
}

// The upper bosses' gasket land is cut away again with the front band.
function boss_start_off(facet) = facet==1 ? plate_back_off : cover_back_off;

module cover_insert_holes() {
    for (s=cover_screws, z=cover_screw_z) along(front_point(s[0],s[1]),front_normal(s[0]),z)
        translate([0,0,max(housing_front_off,boss_start_off(s[0]))-0.1])
            cylinder(d=cover_insert_hole_d,h=cover_insert_depth+0.1);
}

module gasket_lip() {
    // Extra land inside both axial walls behind the upper facet; the buttons start at Z 5.5.
    intersection() {
        linear_extrude(height=axial_width) intersection() {
            front_band_2d(cover_back_off,housing_front_off+lip_depth);
            translate([-100,fold_corner(housing_front_off+lip_depth)[1]]) square([200,100]);
        }
        union() {
            translate([-100,-100,case_wall-0.1]) cube([200,200,lip_width+0.1]);
            translate([-100,-100,axial_width-case_wall-lip_width]) cube([200,200,lip_width+0.1]);
        }
    }
}

// Gland end wall: local frame with +Y pointing into the cavity from the outer wall face.
module at_gland_wall() {
    if (cable_at_bottom) translate([0,pod_bottom_y,0]) children();
    else translate([0,pod_top_y,0]) mirror([0,1,0]) children();
}

module gland_boss() {
    at_gland_wall() translate([cable_x-gland_boss_w/2,case_wall-0.1,case_wall-0.1])
        cube([gland_boss_w,gland_boss_thickness+0.1,axial_width-2*case_wall+0.2]);
}

module cable_hole() {
    at_gland_wall() translate([cable_x,-0.1,axial_width/2]) rotate([-90,0,0])
        cylinder(d=cable_hole_d,h=case_wall+gland_boss_thickness+0.3);
}

module vent_hole() {
    translate([vent_x,vent_y,-0.1]) cylinder(d=vent_hole_d,h=case_wall+0.2);
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

// Housing material before the front band is removed: shell plus all land features.
module housing_body() {
    difference() {
        linear_extrude(height=axial_width) intersection() {
            outer_silhouette_2d(); x_band_2d(-100,body_face_x);
        }
        translate([0,0,case_wall]) linear_extrude(height=axial_width-2*case_wall) cavity_profile_2d();
        linear_extrude(height=axial_width) circle(d=clamp_bore);
    }
    intersection() {
        union() { cover_bosses(); gasket_lip(); gland_boss(); xiao_rails(); }
        linear_extrude(height=axial_width) outer_silhouette_2d();
    }
}

module housing() {
    difference() {
        housing_body();
        linear_extrude(height=axial_width) front_band_2d(-10,housing_front_off);
        body_bolt_cuts();
        cover_insert_holes();
        cable_hole();
        vent_hole();
    }
}

// Upper facet: land on the walls, the lip and the screw bosses. Lower facet: a full sheet that
// is also the membrane under the keys; the keypad plate presses it against the cover.
module gasket() {
    difference() {
        union() {
            intersection() {
                housing_body();
                linear_extrude(height=axial_width) front_band_2d(cover_back_off,housing_front_off);
            }
            // Up to the print_gasket split plane, so the sheet joins the upper land without a slot.
            linear_extrude(height=axial_width) intersection() {
                pod_outline_2d();
                front_band_2d(cover_back_off,housing_front_off);
                translate([-100,fold_corner(cover_back_off)[1]+0.3-200]) square([200,200]);
            }
        }
        at_cover_screws() translate([0,0,-1]) cylinder(d=cover_screw_clear_d,h=10);
    }
}

// Keypad plate: fills the lower-facet cavity behind the sheet, clamped by the four lower
// cover screws against their bosses. The switch bodies sit in its square holes; the pad PCB
// screws to its two standoffs.
module keypad_plate() {
    difference() {
        union() {
            translate([0,0,case_wall+0.15]) linear_extrude(height=axial_width-2*case_wall-0.3) intersection() {
                front_band_2d(plate_front_off,plate_back_off);
                offset(delta=-0.15) cavity_profile_2d();
                lower_side_2d(keypad_plate_u0);
            }
            at_pad() for (p=pad_standoffs) translate([p[0],p[1],plate_back_off-0.01])
                cylinder(d=pad_standoff_d,h=pad_standoff_h+0.01);
        }
        at_keys(plate_front_off-0.1) translate([-plate_switch_hole/2,-plate_switch_hole/2,0])
            cube([plate_switch_hole,plate_switch_hole,keypad_plate_t+0.2]);
        at_pad() for (p=pad_standoffs) translate([p[0],p[1],plate_front_off+0.3])
            cylinder(d=pad_standoff_pilot,h=keypad_plate_t+pad_standoff_h,$fn=24);
        for (s=cover_screws, z=cover_screw_z) if (s[0]==1)
            along(front_point(s[0],s[1]),front_normal(s[0]),z) cylinder(d=cover_screw_clear_d,h=10);
    }
}

// One key in the pad frame, arrow pointing away from the pad centre.
module key(k) {
    a = atan2(k[1],k[0]);
    difference() {
        union() {
            hull() {
                translate([0,0,-key_proud]) cylinder(d=key_d-0.8,h=0.01);
                translate([0,0,-key_proud+0.4]) cylinder(d=key_d,h=key_proud-0.4+key_flange_off+0.01);
            }
            translate([0,0,key_flange_off]) cylinder(d=key_flange_d,h=key_flange_t);
            translate([0,0,key_nub_off-0.01]) cylinder(d=key_nub_d,h=cover_back_off-key_nub_clear-key_nub_off+0.01);
        }
        translate([0,0,-key_proud-0.01]) rotate(a) linear_extrude(height=key_arrow_depth+0.01)
            polygon([[2.0,0],[-1.0,1.9],[-1.0,-1.9]]);
    }
}

module keys() {
    at_pad() for (k=key_xy) translate([k[0],k[1],0]) key(k);
}

module clamp_cap() {
    difference() {
        linear_extrude(height=axial_width) cap_profile_2d();
        cap_bolt_cuts();
    }
}

// Round cutout with its top (+Z, the print direction of the cover) capped at 45 degrees,
// so it prints without support. Local frame of along(): local X is global -Z here.
module teardrop_cut(d,h) {
    r = d/2;
    linear_extrude(height=h) hull() {
        circle(d=d);
        intersection() {
            rotate(135) square(r);
            translate([-r-teardrop_cap,-r]) square([r+teardrop_cap,2*r]);
        }
    }
}

module face_cover() {
    difference() {
        linear_extrude(height=axial_width) cover_profile_2d();
        at_buttons(-0.1) teardrop_cut(button_cutout,face_cover_thickness+0.5);
        // Key windows stay round (visible around the keys; a 7.5 mm hole bridges when the cover
        // prints on its side). The flange pockets behind them are teardrops.
        at_keys(-0.1) cylinder(d=key_window_d,h=face_cover_thickness+0.5);
        at_keys(key_flange_off) teardrop_cut(key_pocket_d,key_pocket_depth+0.1);
        at_cover_screws() {
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
                cylinder(d=0.64,h=xiao_header_plastic+xiao_pin_length,$fn=8);
    }
}

// USB-C plug used for programming with the cover off.
module usb_plug_envelope() {
    translate([xiao_pcb_x0-3.2/2-3.25,xiao_y-xiao_length/2-1.2-25,axial_width/2-6]) cube([6.5,25,12]);
}

module gland_nut_envelope() {
    at_gland_wall() translate([cable_x,case_wall+gland_boss_thickness,axial_width/2]) rotate([-90,0,0])
        cylinder(d=gland_nut_d,h=gland_nut_h);
}

module vent_label_envelope() {
    translate([vent_x,vent_y,case_wall]) cylinder(d=vent_pad_d,h=0.3);
}

module controls_and_board() {
    color([0.85,0.55,0.20]) at_buttons(cover_back_off) cylinder(d=button_body_d,h=switch_depth);
    pad_envelope();
    xiao_envelope();
    color([0.2,0.2,0.2]) gland_nut_envelope();
}

module control_heads() {
    at_buttons() {
        color([0.30,0.36,0.39])
            translate([0,0,-0.8]) difference() { cylinder(d=15,h=0.8); translate([0,0,-0.1]) cylinder(d=button_head_diameter+0.8,h=1.0); }
        color([0.16,0.21,0.24])
            translate([0,0,-button_head_projection]) cylinder(d=button_head_diameter,h=face_cover_thickness+button_head_projection);
    }
    color([0.20,0.22,0.24]) keys();
}

module pad_pcb_2d() {
    hull() {
        for (k=key_xy) translate(k) square(ksc_body+0.6,center=true);
        for (p=pad_standoffs) translate(p) circle(d=pad_standoff_d+1.0);
    }
}

// Pad PCB with the four switches facing the cover, plus solder and wire space behind it.
module pad_envelope() {
    at_pad() {
        color([0.75,0.75,0.72]) for (k=key_xy) translate([k[0],k[1],0]) {
            translate([-ksc_body/2,-ksc_body/2,pad_pcb_off-ksc_body_h]) cube([ksc_body,ksc_body,ksc_body_h]);
            translate([0,0,ksc_top_off]) cylinder(d=ksc_actuator_d,h=ksc_h-ksc_body_h+0.01);
        }
        color([0.15,0.48,0.32]) translate([0,0,pad_pcb_off]) linear_extrude(height=pad_pcb_t) pad_pcb_2d();
        color([0.35,0.35,0.35,0.6]) translate([0,0,pad_pcb_off+pad_pcb_t]) linear_extrude(height=pad_pcb_rear)
            offset(delta=-1) pad_pcb_2d();
    }
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
    color([0.15,0.15,0.15]) gasket();
    color([0.95,0.75,0.25]) keypad_plate();
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
    color([0.15,0.15,0.15]) difference() { gasket(); interior_cutter(); }
    color([0.95,0.75,0.25]) difference() { keypad_plate(); interior_cutter(); }
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
    intersection() { color([0.15,0.15,0.15]) gasket(); section_clip(); }
    intersection() { color([0.95,0.75,0.25]) keypad_plate(); section_clip(); }
    intersection() { color([0.72,0.48,0.22,0.8]) liner_half(false); section_clip(); }
    intersection() { color([0.72,0.48,0.22,0.8]) liner_half(true); section_clip(); }
    intersection() { clamp_bolts(); section_clip(); }
    control_heads();
    if (show_internals) intersection() { controls_and_board(); section_clip(); }
}

// Print orientations: no supports needed.
// Housing: upper facet down. Walls stay vertical; the lower facet is an open edge in the air;
// the lower bosses lean fold_angle; the cavity end at X = pod_cavity_x1 bridges 21 mm along Z.
module print_housing() { translate([0,0,-housing_front_x]) rotate([0,-90,0]) housing(); }
// Cap: axial face down, so the bore and bolt holes print as true circles.
module print_cap() { clamp_cap(); }
// Cover: axial face down. The folded profile is an extrusion along Z; the control cutouts are
// horizontal and capped at 45 degrees (hidden under the bezels).
module print_cover() { face_cover(); }
// Keys: top face on the bed (engraved arrow in the first layers), flange and nub upward. The
// flange overhangs the stem by 0.65 mm.
module print_keys() {
    for (i=[0:len(key_xy)-1]) translate([i*(key_flange_d+3),0,key_proud]) key(key_xy[i]);
}
// Keypad plate: sheet side on the bed, standoffs upward.
module print_keypad_plate() { translate([0,0,-plate_front_off]) to_pad_frame() keypad_plate(); }
// Inverse of at_pad(): global coordinates into the pad frame.
module to_pad_frame() {
    rotate([0,-90,0]) rotate([0,0,-atan2(fold_n[1],fold_n[0])]) translate([-pad_p[0],-pad_p[1],-axial_width/2]) children();
}
// Gasket: unfolded flat. Each facet's part is projected onto its own plane, the lower one after
// turning back about the fold, and the outline is extruded to the printed thickness.
module print_gasket() {
    k = fold_corner(cover_back_off);
    // A morphological close joins the 0.02 mm seam left at the fold.
    linear_extrude(height=gasket_print_thickness) offset(delta=-0.1) offset(delta=0.1) union() {
        projection() rotate([0,-90,0]) intersection() { gasket(); fold_upper_side(k); }
        projection() rotate([0,-90,0])
            translate([k[0],k[1],0]) rotate([0,0,-fold_angle]) translate([-k[0],-k[1],0])
                difference() { gasket(); fold_upper_side(k); }
    }
}

// Upper-facet side of the fold: above a plane 0.3 mm over the fold corner k, so the screw pads
// next to the fold stay whole with the lower facet. The projection removes the small tilt this
// gives the 0.3 mm strip of upper-facet gasket that turns with the lower part.
module fold_upper_side(k) {
    translate([-100,k[1]+0.3,-1]) cube([200,200,axial_width+2]);
}

if (part_to_render=="assembly") assembly();
if (part_to_render=="interior") interior_view();
if (part_to_render=="section") section_view();
if (part_to_render=="housing") housing();
if (part_to_render=="clamp_cap") clamp_cap();
if (part_to_render=="cover") face_cover();
if (part_to_render=="gasket") gasket();
if (part_to_render=="liner_main") liner_half(false);
if (part_to_render=="liner_cap") liner_half(true);
if (part_to_render=="print_housing") print_housing();
if (part_to_render=="print_cap") print_cap();
if (part_to_render=="print_cover") print_cover();
if (part_to_render=="print_gasket") print_gasket();
if (part_to_render=="keys") keys();
if (part_to_render=="keypad_plate") keypad_plate();
if (part_to_render=="print_keys") print_keys();
if (part_to_render=="print_keypad_plate") print_keypad_plate();
