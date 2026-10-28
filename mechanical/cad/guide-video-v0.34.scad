// Open Rally Remote — V0.34 assembly guide video: one frame of the guide.
// tools/guide_video.py animates it: for each frame it passes the list of items to draw, each
// with an offset and its own parameters, the frame of reference and the cut. This file only
// draws. A draft for review: it is not regenerated with every design change.
//
//   items  [[name, [dx, dy, dz], [q...]], ...]   q: per-item parameters, see item()
//   frame  "remote": the model's +X up (the remote is assembled cover face down);
//          "model": the model's own axes (base on the bar, bar axis up)
//   cut    "none", "wall" (upper axial wall removed), "half" (Z below mid-width kept) or
//          "z" (Z below cut_z kept)
include <complete-remote-v0.34.scad>
part_to_render = "none";

items = [];
frame = "remote";
cut = "none";
cut_z = 12.5;                // for cut = "z": Z below this is kept

function clamp01(x) = min(1,max(0,x));
function ease(x) = let(u=clamp01(x)) u*u*(3-2*u);

// --- Placement frames: local +Z into the material, origin where the head seats ----------
cover_list = [for (s=cover_screws, z=cover_screw_z) [s, z]];
module at_cover_k(k) { c = cover_list[k]; along(front_point(c[0][0],c[0][1]),front_normal(c[0][0]),c[1]) children(); }
module at_cap_k(k) { s = cap_screws[k]; translate([s[0],pod_bottom_y,s[1]]) rotate([-90,0,0]) children(); }
module at_joyscrew_k(k) { p = joy_standoffs[k]; at_joy() translate([p[0],p[1],joy_pcb_off+joy_pcb_t]) rotate([180,0,0]) children(); }
module at_ctrlscrew_k(k) { st = btn_standoffs[k]; translate([cover_front_x+ctrl_back_off,st[0],axial_width/2+st[1]]) rotate([0,-90,0]) children(); }
module at_bolt_k(k) { translate([0,(2*k-1)*clamp_bolt_y,axial_width/2]) rotate([0,90,0]) translate([0,0,cap_seat_x]) rotate([180,0,0]) children(); }
// Grub screw in the knob: radial along the knob's +X, from the rim inward.
module at_grub() { at_joy() translate([knob_d/2,0,knob_insert_z]) rotate([0,-90,0]) children(); }

// Cross pattern for the ten cover screws, and the order for the others.
cover_order = [0,9,4,5,1,8,3,6,2,7];
function nth(order, i) = [for (j=[0:len(order)-1]) if (order[j]==i) j][0];

// --- Hardware shapes ---------------------------------------------------------------------
C_STEEL = [0.62,0.63,0.66];
C_TOOL = [0.20,0.35,0.80];
C_HANDLE = [0.85,0.25,0.15];
// Each cable and its plugs share a colour: joystick light grey, USB-C blue, battery red.
C_USB = [0.15,0.30,0.70];
C_USB_PLUG = [0.45,0.62,0.95];
// Cap pads: X along the opening, Z across it, Y four layers of the ~1.15 mm seal foam.
cap_pad = [8.0, 6.0, 4.6];
cap_pad_in = vent_pad_d/2+0.5;   // from the vent axis to each pad's inner edge
module screw_cs(L, hd=3.8, hh=1.2) {   // countersunk: head in the countersink, z 0..hh
    cylinder(d1=hd,d2=2.0,h=hh,$fn=24); cylinder(d=2.0,h=L,$fn=16);
}
module screw_btn(L, hd=3.5, hh=1.1, d=2.0) {   // button or socket head outside, z -hh..0
    translate([0,0,-hh]) difference() { cylinder(d=hd,h=hh,$fn=24); translate([0,0,-0.01]) cylinder(d=hd*0.37,h=0.7,$fn=6); }
    cylinder(d=d,h=L,$fn=16);
}
// A screw driven by progress p: backed out by out*(1-p) along -Z, turned 720 degrees.
module driven(p, out) { translate([0,0,-out*(1-clamp01(p))]) rotate([0,0,720*clamp01(p)]) children(); }
// A screwdriver on a head: shaft d along -Z from the head, handle at its end, turning with p.
module driver(p, len=40, d=2.0, back=1.2) {
    translate([0,0,-back]) rotate([0,0,1080*clamp01(p)]) mirror([0,0,1]) {
        color(C_TOOL) cylinder(d=d,h=len,$fn=12);
        color(C_HANDLE) translate([0,0,len]) difference() { cylinder(d=10,h=26,$fn=32); translate([4,-0.6,-1]) cube([2,1.2,28]); }
    }
}
// Hand drill bit for the pilots: Ø1.6 into the hole by depth along +Z.
module drill_bit(depth) {
    translate([0,0,-12+depth]) { color(C_STEEL) cylinder(d=1.6,h=12,$fn=12); color(C_HANDLE) translate([0,0,-24]) cylinder(d=9,h=24,$fn=24); }
}
// L-shaped hex key: short arm along +Z into the socket, long arm along +X.
module hex_key(d, short, long, turn=0) {
    rotate([0,0,turn]) color(C_TOOL) {
        translate([0,0,-short]) cylinder(d=d*1.12,h=short,$fn=6);
        translate([0,0,-short]) rotate([0,90,0]) cylinder(d=d*1.12,h=long,$fn=6);
    }
}

// --- Items ----------------------------------------------------------------------------
module item(n, q) {
    if (n == "housing") color([0.67,0.73,0.77]) housing();
    else if (n == "cover") color([0.84,0.87,0.89]) face_cover();
    else if (n == "keypad") color([0.15,0.15,0.15]) gasket();
    else if (n == "joy_plate") color([0.95,0.75,0.25]) joy_plate();
    else if (n == "button_plate") color([0.95,0.75,0.25]) button_plate();
    else if (n == "stick") color([0.85,0.85,0.85]) stick();
    else if (n == "knob") color([0.14,0.18,0.20]) knob();
    else if (n == "battery_cap") color([0.60,0.66,0.70]) battery_cap();
    else if (n == "cap_gasket") color([0.12,0.12,0.12]) cap_gasket();
    else if (n == "control_board") control_board_envelope();
    else if (n == "xiao") xiao_envelope();
    else if (n == "xiao_foam") xiao_foam_envelope();
    else if (n == "joy_board") joy_envelope();
    else if (n == "usbc_board") translate([-q[0],0,0]) usbc_envelope();
    else if (n == "pouch") color([0.78,0.78,0.82]) pouch_envelope();
    else if (n == "cable_joy") color([0.2,0.2,0.2]) cable_joy();
    else if (n == "cable_usb") color(C_USB) cable_usb();
    else if (n == "cable_bat") color([0.6,0.1,0.1]) cable_bat();
    else if (n == "vent_label") color([0.95,0.95,0.95]) vent_label_envelope();
    // Lighter than the black keypad sheet it lies on, so it shows.
    else if (n == "foam_strip") color([0.45,0.45,0.50]) rim_band(sheet_back_off,rim_off);
    else if (n == "rear_foam") color([0.2,0.2,0.22]) translate([pouch_x1, pouch_y0, axial_width/2-8]) cube([0.8, pouch_l, 16]);
    // Two pads of four foam layers on the cap's inner face, one on each side of the vent label.
    else if (n == "cap_pad") color([0.2,0.2,0.22]) for (s=[-1,1])
        translate([vent_x-cap_pad[0]/2,cap_y-cap_gap,axial_width/2+s*(cap_pad_in+cap_pad[1]/2)-cap_pad[1]/2]) cube([cap_pad[0],cap_pad[2],cap_pad[1]]);
    // q = [s]: screws done; tool on the current one
    else if (n == "drill") { k = floor(q[0]); f = q[0]-k; if (k < len(cover_list)) at_cover_k(k) drill_bit(6*sin(180*f)); }
    else if (n == "usbc_nuts") color([0.85,0.62,0.15]) usbc_nuts(q[0]);
    else if (n == "usbc_screws") translate([-q[0],0,0]) at_usbc() for (h=usbc_pcb_holes)
        translate([h[0],-usbc_axis_h+q[1],usbc_pcb_edge+h[1]]) rotate([0,q[2],0]) color(C_STEEL) {
            rotate([-90,0,0]) cylinder(d=usbc_screw[0],h=usbc_screw[1],$fn=24);
            translate([0,-usbc_tip-usbc_pcb[2],0]) rotate([-90,0,0]) cylinder(d=2.0,h=usbc_tip+usbc_pcb[2],$fn=16);
        }
    else if (n == "usbc_driver") translate([0,-q[1],0]) color(C_TOOL) usbc_driver(q[0]);
    // The receptacle's back end, where its contacts meet the board, not its front at the panel.
    else if (n == "epoxy_back") color([0.95,0.85,0.35,0.85]) at_usbc() let(z1 = usbc_panel_t-usbc_pocket_depth+usbc_gasket_t-usbc_squeeze+usbc_body[2]-usbc_nose[2])
        translate([-usbc_body[0]/2-0.5,-usbc_axis_h,z1-1.0]) cube([usbc_body[0]+1,(usbc_body[1]+0.5)*clamp01(q[0])+0.01,2.5]);
    else if (n == "epoxy_led") color([0.95,0.85,0.35,0.85]) at_usbc(rear_x+0.05) translate([usbc_led_x,-usbc_axis_h+usbc_led_h,0]) cylinder(d=usbc_led_hole_d+0.05,h=usbc_panel_t*clamp01(q[0])+0.01,$fn=24);
    else if (n == "knob_nut") color(C_STEEL) at_joy() translate([knob_nut_r0,-knob_nut[0]/2,knob_insert_z-knob_nut[0]/2+8*(1-clamp01(q[0]))]) cube([knob_nut[1],knob_nut[0],knob_nut[0]]);
    else if (n == "grub") color(C_STEEL) at_grub() driven(q[0], 4) cylinder(d=2.0,h=4,$fn=16);
    else if (n == "grub_key") at_grub() translate([0,0,-4*(1-clamp01(q[0]))]) hex_key(1.0, 4, 30, 720*clamp01(q[0]));
    else if (n == "shim") color([0.9,0.2,0.6]) at_joy(-knob_gap) difference() { cylinder(d=knob_hub_d+6,h=knob_gap,$fn=32); translate([0,0,-1]) cylinder(d=4,h=3,$fn=16); translate([-1,0,-1]) cube([2,10,3]); }
    else if (n == "base_front") color([0.53,0.60,0.64]) base_front();
    else if (n == "base_cap") color([0.45,0.52,0.56]) base_cap();
    else if (n == "liner_main") color([0.72,0.48,0.22]) liner_half(false);
    else if (n == "liner_cap") color([0.72,0.48,0.22]) liner_half(true);
    else if (n == "sleeve_a") color([0.85,0.85,0.80]) sleeve_half(false);
    else if (n == "sleeve_b") color([0.85,0.85,0.80]) sleeve_half(true);
    else if (n == "strips") strips();
    else if (n == "bar") color([0.78,0.78,0.78]) translate([0,0,axial_width/2]) cylinder(d=bar_diameter,h=120,center=true,$fn=64);
    else if (n == "bar_drill") { f = q[0]-floor(q[0]); if (q[0] < 2) color(C_STEEL) at_bolt_k(floor(q[0])) translate([0,0,-4-30+8*sin(180*f)]) { cylinder(d=3.4,h=30,$fn=12); color(C_HANDLE) translate([0,0,-24]) cylinder(d=12,h=24,$fn=24); } }
    else if (n == "m4_bolts") { for (k=[0,1]) { p = q[0]-k; if (p > -0.999) at_bolt_k(k) driven(p, 18) color([0.25,0.25,0.27]) screw_btn(bolt_length, bolt_head_d, bolt_head_h, 4.0); } }
    else if (n == "m4_key") { k = min(1,floor(q[0])); f = q[0]-floor(q[0]); if (q[0] < 2) at_bolt_k(k) translate([0,0,-bolt_head_h+2.5]) hex_key(3.0, 8, 60, 720*f); }
    // Lock parts, each along the lock axis (model +X toward the knob): q = [x offset]
    else if (n == "lock_spring") color([0.8,0.8,0.8]) translate([q[0],0,0]) at_x_minus(lock_pocket_floor_x,lock_y,axial_width/2)
        difference() { cylinder(d=5.0,h=lock_pocket_depth-lock_head_h+lock_out,$fn=24); translate([0,0,-1]) cylinder(d=3.4,h=20,$fn=24); }
    else if (n == "lock_screw") color([0.25,0.25,0.27]) translate([q[0],0,0]) at_x_minus(platform_x+lock_head_h-lock_out,lock_y,axial_width/2) {
        cylinder(d=lock_head_d,h=lock_head_h); translate([0,0,-lock_screw_length]) cylinder(d=3.0,h=lock_screw_length,$fn=24); }
    else if (n == "lock_knob") translate([base_back_x+q[0],lock_y,axial_width/2]) rotate([0,90,0]) rotate(q[1]) color([0.85,0.45,0.15]) lock_knob_shape();
    else if (n == "lock_pins") translate([base_back_x+q[0],lock_y,axial_width/2]) rotate([0,90,0]) rotate(q[1]) color(C_STEEL)
        for (a=[0,180]) rotate(a) translate([lock_pin_r_in+6*(1-clamp01(q[2])),0,lock_pin_z]) rotate([0,90,0]) cylinder(d=lock_pin_d,h=lock_pin_len,$fn=16);
    else if (n == "lock_nut") translate([base_back_x+q[0],lock_y,axial_width/2]) rotate([0,90,0]) rotate(q[1]) color(C_STEEL)
        translate([0,0,lock_knob_h-lock_nut_m+6*(1-clamp01(q[2]))]) difference() { cylinder(d=5.5/cos(30),h=lock_nut_m,$fn=6); translate([0,0,-1]) cylinder(d=3,h=5,$fn=16); }
    else if (n == "threadlock") color([0.20,0.40,0.90,0.85]) translate([base_back_x+lock_knob_h+0.3,lock_y,axial_width/2]) rotate([0,90,0]) cylinder(d=4.5,h=0.8*clamp01(q[0])+0.01,$fn=24);
    // Cable plugs, out = q[0] mm out of their sockets along the plug axis (0 = seated).
    else if (n == "plug_j1") { jd = -fold_d; jn = fold_n; u = [jd[0],jd[1],0];
        color([0.9,0.9,0.85]) plug(joy_to_global(joy_j1_mouth)+q[0]*u, u, [0,0,1], [jn[0],jn[1],0], sh_plug[1]); }
    else if (n == "plug_j4") color([0.9,0.9,0.85]) plug(j4_mouth+q[0]*[0,-1,0], [0,-1,0], [0,0,1], [1,0,0], sh_plug[1]);
    else if (n == "plug_j2") color(C_USB_PLUG) plug(usbc_j2_mouth+q[0]*[-1,0,0], [-1,0,0], [0,0,1], [0,usbc_s,0], sh_plug[0]);
    else if (n == "plug_j3") color(C_USB_PLUG) plug(j3_mouth+q[0]*[0,-1,0], [0,-1,0], [0,0,1], [1,0,0], sh_plug[0]);
    else if (n == "plug_j5") { c = ctrl_global(j5_xy[0],j5_xy[1]);
        color([0.85,0.30,0.25]) translate([c[0]+q[0],c[1]-ph_plug[1]/2,c[2]-ph_plug[0]/2]) cube([ph_plug[2],ph_plug[1],ph_plug[0]]); }
    else if (n == "arrow") color([0.85,0.10,0.10]) translate([q[0],q[1],q[2]]) rotate([q[3],q[4],q[5]]) { cylinder(d=1.6,h=10,$fn=12); translate([0,0,10]) cylinder(d1=4,d2=0,h=4,$fn=16); }
    else if (family_item(n)) family_draw(n, q);
    else assert(false, str("unknown item ", n));
}

// Screw families with a driver on the current screw: q = [s, tool].
function family_item(n) = n=="cover_screws" || n=="cap_screws" || n=="joy_screws" || n=="ctrl_screws";
module family_draw(n, q) {
    nn = n=="cover_screws" ? len(cover_list) : n=="cap_screws" ? 3 : 2;
    for (i=[0:nn-1]) {
        rank = n=="cover_screws" ? nth(cover_order,i) : i;
        p = q[0]-rank;
        if (p > -0.999) {
            if (n=="cover_screws") at_cover_k(i) { color(C_STEEL) driven(p, 12) screw_cs(cover_screw_length); if (q[1] > 0 && p >= 0 && p < 1) driver(p, 45, 2.0, 0); }
            if (n=="cap_screws") at_cap_k(i) { color(C_STEEL) driven(p, 10) screw_cs(cap_screw[2]); if (q[1] > 0 && p >= 0 && p < 1) driver(p, 45, 2.0, 0); }
            if (n=="joy_screws") at_joyscrew_k(i) { color(C_STEEL) driven(p, 10) screw_btn(8); if (q[1] > 0 && p >= 0 && p < 1) driver(p, 40, 1.3, 1.1); }
            if (n=="ctrl_screws") at_ctrlscrew_k(i) { color(C_STEEL) driven(p, 6) screw_btn(4); if (q[1] > 0 && p >= 0 && p < 1) driver(p, 40, 1.3, 1.1); }
        }
    }
}

module cut_apply() {
    if (cut == "wall") difference() { children(); interior_cutter(); }
    else if (cut == "half") intersection() { children(); section_clip(); }
    else if (cut == "z") intersection() { children(); translate([-200,-200,-1]) cube([400,400,cut_z+1]); }
    else children();
}

// Items listed in cut_items are cut; the rest are drawn whole.
cut_items = [];
function has(list, x) = len([for (y=list) if (y==x) 1]) > 0;
module scene() {
    for (it=items) translate(it[1])
        if (has(cut_items, it[0])) cut_apply() item(it[0], it[2]); else item(it[0], it[2]);
}

if (frame == "remote") rotate([0,-90,0]) scene();
else scene();
