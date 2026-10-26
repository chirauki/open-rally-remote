// Open Rally Remote — V0.34 USB-C board fitting, animated over t = 0 .. 1.
// tools/usbc_mount_video.py renders it for docs/mechanical-concept.md: a cut-away 3D view and
// two flat sections. The housing comes from an STL that the tool cuts once
// (view = "housing_cut"); the moving parts are drawn here.
// Steps: square nuts into the rib's channels, gasket onto the nose, the board (upside down)
// slid along the rib's underside until the nose enters the slot, screws started by hand,
// board pushed until the gasket is squeezed, screws tightened with a driver from the battery
// cap opening.
include <complete-remote-v0.34.scad>

view = "anim3d";             // "anim3d", "gasket2d", "screw2d" or "housing_cut"
housing_stl = "";
anim_t = -1;                 // set by the tool for one frame; -1 uses $t (OpenSCAD --animate)
t = anim_t >= 0 ? anim_t : $t;

// The 3D view keeps Z below the axis of the +Z screw: the cut runs through that screw, its nut
// and the driver.
screw_z = max([for (h=usbc_pcb_holes) usbc_hole_xz(h)[1]]);
screw_i = [for (i=[0:len(usbc_pcb_holes)-1]) if (usbc_hole_xz(usbc_pcb_holes[i])[1] == screw_z) i][0];
other_i = 1-screw_i;
clip_box = [[-52,-50],[-15,48]];   // X and Y ranges
module clip() {
    translate([clip_box[0][0],clip_box[0][1],-1])
        cube([clip_box[1][0]-clip_box[0][0],clip_box[1][1]-clip_box[0][1],screw_z+1]);
}

// --- Timeline -------------------------------------------------------------------------
// Each phase runs over [T[i], T[i+1]]; ease() goes 0 .. 1 over it.
function ease(a,b) = let(u=min(1,max(0,(t-a)/(b-a)))) u*u*(3-2*u);
T = [0.00, 0.06, 0.16, 0.24, 0.40, 0.50, 0.60, 0.68, 0.79, 0.90, 1.00];
nut_in = ease(T[1],T[2]);          // nuts slide in from in front of the rib
gasket_on = ease(T[2],T[3]);       // gasket onto the nose
board_slide = ease(T[3],T[4]);     // board slid along the rib until the nose is in the slot
screws_in = ease(T[4],T[5]);       // screws started by hand from below
push = ease(T[5],T[6]);            // board pushed until the gasket resists
drv_in = ease(T[6],T[7]);          // driver up through the battery cap opening
turn_a = ease(T[7],T[8]);          // first screw tightened
turn_b = ease(T[8],T[9]);          // driver moved to the second screw, which is tightened
drv_out = ease(T[9],T[10]);        // driver out

// The board is held back from its final place along -X (into the remote): 22 mm before it
// slides in, 1.0 mm once the nose is in the slot, which the screw slots allow; 0 when pushed.
back = 22 - 21*board_slide - 1.0*push;
nose_back = usbc_panel_t-usbc_pocket_depth+usbc_gasket_t-usbc_squeeze;   // body face, final
pocket_floor = usbc_panel_t-usbc_pocket_depth;
gasket_th = min(usbc_gasket_t, nose_back+back-pocket_floor);
nut_x = -14*(1-nut_in);
gasket_off = 5*(1-gasket_on);      // gasket in front of the nose, along +X, before it goes on
// Screw i: how far its head stands off the board while loose, and how far it has turned.
function tight(i) = i == screw_i ? turn_a : turn_b;
function screw_off(i) = 8*(1-screws_in) + 0.3*(1-tight(i));
function screw_turn(i) = 720*screws_in + 360*tight(i);
// Driver: on screw_i, then on other_i; drv_drop lowers it out of the head.
drv_on = turn_b > 0 ? other_i : screw_i;
drv_drop = 40*(1-drv_in) + 40*drv_out + (turn_b > 0 && turn_b < 0.25 ? 6*sin(turn_b/0.25*180) : 0);
drv_turn = 1080*(drv_on == screw_i ? turn_a : turn_b);

// --- Parts, without colour; each placed for t --------------------------------------------
module on_board() { translate([-back,0,0]) children(); }
module p_pcb() {
    on_board() at_usbc() difference() {
        translate([-usbc_pcb[0]/2,-usbc_axis_h-usbc_pcb[2],usbc_pcb_edge]) cube([usbc_pcb[0],usbc_pcb[2],usbc_pcb[1]]);
        for (h=usbc_pcb_holes) translate([h[0],0,usbc_pcb_edge+h[1]]) rotate([90,0,0]) cylinder(d=2.2,h=10,center=true,$fn=24);
    }
}
module p_receptacle() {
    on_board() at_usbc() {
        translate([0,0,nose_back-usbc_nose[2]]) linear_extrude(height=usbc_nose[2]) rrect_2d(usbc_nose[0],usbc_nose[1],1.5);
        translate([-usbc_body[0]/2,-usbc_axis_h,nose_back]) cube([usbc_body[0],usbc_body[1],usbc_body[2]-usbc_nose[2]]);
    }
}
module p_parts() {
    on_board() at_usbc() {
        translate([-3.5,-usbc_axis_h,usbc_pcb_edge+usbc_body[2]-1.70]) cube([7.0,1.5,usbc_pcb[1]-(usbc_body[2]-1.70)]);
        translate([usbc_led_x-usbc_led[0]/2,-usbc_axis_h,usbc_pcb_edge+usbc_led_set]) cube([usbc_led[0],usbc_led[1],usbc_led[2]]);
    }
}
module p_gasket() {
    on_board() translate([gasket_off,0,0]) at_usbc() translate([0,0,nose_back-gasket_th])
        linear_extrude(height=gasket_th) difference() {
            rrect_2d(usbc_gasket[0],usbc_gasket[1],usbc_gasket_r); rrect_2d(usbc_nose[0],usbc_nose[1],1.5);
        }
}
// M2 x 4 button-head screws on the parts side, in the board's local frame (head toward +y).
module p_screws() {
    if (screws_in > 0) on_board() at_usbc()
        for (i=[0:len(usbc_pcb_holes)-1]) let(h=usbc_pcb_holes[i])
            translate([h[0],-usbc_axis_h+screw_off(i),usbc_pcb_edge+h[1]]) rotate([0,screw_turn(i),0]) {
                rotate([-90,0,0]) difference() {
                    cylinder(d=usbc_screw[0],h=usbc_screw[1],$fn=32);
                    translate([0,0,usbc_screw[1]-0.6]) cylinder(d=1.3,h=1,$fn=6);
                }
                translate([0,-usbc_tip-usbc_pcb[2],0]) rotate([-90,0,0]) cylinder(d=2.0,h=usbc_tip+usbc_pcb[2],$fn=24);
            }
}
module p_nuts() { translate([nut_x,0,0]) usbc_nuts(-min(back,usbc_slide)); }
// The driver (from the model), with a handle below the cap face that shows it turning.
module p_driver() {
    if (drv_in > 0 && drv_out < 1) translate([0,-drv_drop,0]) {
        usbc_driver(drv_on);
        p = usbc_hole_xz(usbc_pcb_holes[drv_on]);
        translate([usbc_driver_x,pod_bottom_y-5,p[1]]) rotate([90,0,0]) rotate([0,0,drv_turn]) {
            cylinder(d=10,h=28,$fn=32);
            translate([-0.6,-5.2,0]) cube([1.2,1.2,28]);
        }
    }
}
module p_arrow() {
    if (push > 0 && push < 1)
        translate([-40-back,usbc_pcb_back_y+1.0,screw_z-3]) rotate([0,90,0]) {
            cylinder(d=1.0,h=6,$fn=12);
            translate([0,0,6]) cylinder(d1=2.6,d2=0,h=2.8,$fn=16);
        }
}

C_HOUSING = [0.70,0.75,0.79];
C_PCB = [0.15,0.48,0.32];
C_RECEPT = [0.55,0.56,0.60];
C_PARTS = [0.30,0.30,0.30];
C_GASKET = [0.08,0.08,0.08];
C_SCREW = [0.25,0.25,0.30];
C_NUT = [0.85,0.62,0.15];
C_DRIVER = [0.20,0.35,0.80];
C_ARROW = [0.85,0.10,0.10];

module scene3d() {
    color(C_HOUSING) import(housing_stl);
    color(C_PCB) intersection() { p_pcb(); clip(); }
    color(C_RECEPT) intersection() { p_receptacle(); clip(); }
    color(C_PARTS) intersection() { p_parts(); clip(); }
    color(C_GASKET) intersection() { p_gasket(); clip(); }
    color(C_SCREW) intersection() { p_screws(); clip(); }
    color(C_NUT) intersection() { p_nuts(); clip(); }
    color(C_DRIVER) p_driver();
    color(C_ARROW) p_arrow();
}

// Flat cut at Z = z, seen from +Z: X along the page (wall on the right), the remote's +Y up.
module cut_z(z) { projection(cut=true) translate([0,0,-z]) children(); }
module section(z) {
    color(C_HOUSING) cut_z(z) import(housing_stl);
    color(C_PCB) cut_z(z) p_pcb();
    color(C_RECEPT) cut_z(z) p_receptacle();
    color(C_GASKET) cut_z(z) p_gasket();
    color(C_SCREW) cut_z(z) p_screws();
    color(C_NUT) cut_z(z) p_nuts();
    color(C_DRIVER) cut_z(z) p_driver();
}

if (view=="housing_cut") intersection() { housing(); clip(); }
// OpenSCAD's camera keeps +Z up: turn the scene so the remote's +Y is up and the cut face
// looks toward -Y.
if (view=="anim3d") rotate([90,0,0]) scene3d();
if (view=="gasket2d") section(axial_width/2);
if (view=="screw2d") section(screw_z-0.05);
