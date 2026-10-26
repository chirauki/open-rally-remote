// Open Rally Remote — V0.34 assembly video: the parts and the assembly timeline.
// Draws one pose of the assembly, steps 1-11 of docs/mechanical-concept.md "Assembly".
// tools/assembly_video.py drives it: it renders the frames, checks the part paths for
// collisions and builds the MP4. See docs/superpowers/specs/2026-10-14-assembly-video-design.md.
//
//   step     1..11, the assembly step
//   u        0..1 within the step
//   variant  "documented" or "battery_first" (the open order of steps 8 and 9)
//   red      part names drawn in red (collisions)
//   mode     "pose" (everything), "only" (target alone), "others" (all placed but target),
//            "info" (echo the step data), "none" (draw nothing; for wrapper files)
//   target   one part name, for "only" and "others"

include <complete-remote-v0.34.scad>
part_to_render = "none";

step = 11;
u = 1;
variant = "documented";
red = [];
mode = "pose";
target = "";
usbc_in_dy = 0;              // V0.34: the USB-C board comes in this far below the rib (Y); 0 clears

// One name per drawn part. The video and the collision check use the same names.
PARTS = ["housing", "cover", "keypad", "joy_plate", "button_plate", "stick", "knob",
         "battery_cap", "cap_gasket", "control_board", "xiao", "xiao_foam", "joy_board",
         "usbc_board", "pouch", "cable_joy", "cable_usb", "cable_bat", "vent_label", "foam_strip"];

// Each part in its final position, with the model's colours.
module part(name) {
    // V0.34: the USB-C board's square nuts go into the rib first, so they ride with the housing
    if (name == "housing") { color([0.67,0.73,0.77]) housing(); color([0.85,0.62,0.15]) usbc_nuts(); }
    else if (name == "cover") color([0.84,0.87,0.89]) face_cover();
    else if (name == "keypad") color([0.15,0.15,0.15]) gasket();
    else if (name == "joy_plate") color([0.95,0.75,0.25]) joy_plate();
    else if (name == "button_plate") color([0.95,0.75,0.25]) button_plate();
    else if (name == "stick") color([0.85,0.85,0.85]) stick();
    else if (name == "knob") color([0.14,0.18,0.20]) knob();
    else if (name == "battery_cap") color([0.60,0.66,0.70]) battery_cap();
    else if (name == "cap_gasket") color([0.15,0.15,0.15]) cap_gasket();
    else if (name == "control_board") control_board_envelope();
    else if (name == "xiao") xiao_envelope();
    else if (name == "xiao_foam") xiao_foam_envelope();
    else if (name == "joy_board") joy_envelope();
    else if (name == "usbc_board") usbc_envelope();
    // silver, not the model's red: red marks collisions in the video
    else if (name == "pouch") color([0.78,0.78,0.82]) pouch_envelope();
    else if (name == "cable_joy") color([0.2,0.2,0.2]) cable_joy();
    else if (name == "cable_usb") color([0.2,0.2,0.2]) cable_usb();
    else if (name == "cable_bat") color([0.6,0.1,0.1]) cable_bat();
    else if (name == "vent_label") color([0.95,0.95,0.95]) vent_label_envelope();
    else if (name == "foam_strip") foam_strip();   // V0.30
    else assert(false, str("unknown part ", name));
}

function has(list, x) = len([for (y=list) if (y==x) 1]) > 0;

// --- Timeline ---------------------------------------------------------------------------
// The remote is assembled cover face down: +X is up. Groups wait at staging offsets and
// move into place. Events, in time order within a step:
//   ["move", names, from, to, u0, u1]   offset from -> to, eased, over u0..u1; shows the parts
//   ["show", names, u0]                  shows the parts at their current offset
//   ["hide", names, u0]
//   ["mark", mark, part, u0, u1]         a flashing marker, carried with the part's offset
// A part is hidden until its first event. Step entry: [duration_s, camera, events, cut], where
// camera is OpenSCAD's --camera vector in the view frame (view_frame) and cut lists the parts
// drawn with their upper axial wall removed, to see inside.

fn = [cos(fold_angle), sin(fold_angle), 0];   // joystick axis, inward (the model's fold_n)
H = [45, 0, 0];                               // housing staged above the stack
JA = 22*fn;                                   // joystick group above its seat
JS = JA+[0, 0, 45];                           // joystick group staged beside the cover
CA = [22, 0, 0];                              // button plate group above its seat
CS = CA+[0, 0, -45];                          // button plate group staged beside the cover
PO = [0, -60, 0];                             // pouch below the bottom opening
HG = ["housing", "usbc_board", "foam_strip"];
JG = ["stick", "joy_plate", "joy_board"];
CG = ["button_plate", "control_board", "xiao"];
O = [0, 0, 0];

// Cameras as OpenSCAD's --camera eye and centre (6 values) in the view frame: looking at
// model point c from azimuth az and elevation el (degrees, view frame), d away.
function vp(p) = [-p[2], p[1], p[0]];
function cam(c, az, el, d) = let(v = vp(c)) concat(v+d*[cos(el)*cos(az), cos(el)*sin(az), sin(el)], v);
zc = axial_width/2;
CAM_HOUSING = cam(H+[-36, 2, zc], 215, -45, 240);
CAM_JOY = cam(JS+8*fn+[joy_p[0], joy_p[1], zc], 215, 30, 140);
CAM_CTRL = cam(CS+[-48, 16, zc], 325, 35, 130);
CAM_STACK = cam([-30, 5, zc], 300, 22, 270);
CAM_BOTTOM = cam([-26, -50, zc], 145, 20, 190);   // V0.28: sees the cap's inner face and the vent label
CAM_KNOB = cam([joy_p[0], joy_p[1], zc], 250, -40, 200);

step8 = variant == "battery_first" ? [5, CAM_STACK, [
        ["move", ["pouch"], H+PO, H, 0.05, 0.35],
        ["move", concat(HG, ["pouch"]), H, O, 0.4, 0.75],
        ["show", ["cable_usb", "cable_bat"], 0.8],
        ["mark", "cover_screws", "cover", 0.8, 1]], ["housing"]]
    : [5, CAM_STACK, [
        ["move", HG, H, O, 0.05, 0.6],
        ["show", ["cable_usb"], 0.65],
        ["mark", "cover_screws", "cover", 0.7, 1]], ["housing"]];

step9 = variant == "battery_first" ? [1.5, CAM_STACK, [], ["housing"]]
    : [7, CAM_STACK, [
        // documented: the pouch goes in with the cover on, then the cover comes off for J5
        ["move", ["pouch"], PO, O, 0.05, 0.35],
        ["hide", ["cable_usb"], 0.38],
        ["move", concat(HG, ["pouch"]), O, H, 0.4, 0.6],
        ["move", concat(HG, ["pouch"]), H, O, 0.65, 0.85],
        ["show", ["cable_usb", "cable_bat"], 0.88],
        ["mark", "cover_screws", "cover", 0.88, 1]], ["housing"]];

timeline = [
    // 1 clear the screw pilots in the housing bosses (V0.29: no inserts)
    [4, CAM_HOUSING, [
        ["move", ["housing"], H, H, 0, 0],
        ["mark", "inserts", "housing", 0.2, 0.9]], []],
    // 2 USB-C board: V0.34 upside down, its back against the rib's underside, slid straight
    // along the rib (+X) into the slot: its edges now pass above the cover-screw bosses at
    // Y 24 (V0.33: carried 1.5 mm above the rib past them, then lowered); then the epoxy
    [6, CAM_HOUSING, [
        ["move", ["usbc_board"], H+[-25, usbc_in_dy, 0], H+[-8, usbc_in_dy, 0], 0.05, 0.3],
        ["move", ["usbc_board"], H+[-8, usbc_in_dy, 0], H+[-8, 0, 0], 0.32, 0.4],
        ["move", ["usbc_board"], H+[-8, 0, 0], H, 0.42, 0.62],
        ["mark", "epoxy", "usbc_board", 0.65, 0.95]], ["housing"]],
    // 3 stick through the joystick plate from the back, then the joystick board
    [5, CAM_JOY, [
        ["move", ["joy_plate"], JS, JS, 0, 0],
        ["move", ["stick"], JS+15*fn, JS, 0.05, 0.45],
        ["move", ["joy_board"], JS+14*fn, JS, 0.5, 0.9]], []],
    // 4 control board onto the button plate, then the XIAO into its headers
    [5, CAM_CTRL, [
        ["move", ["button_plate"], CS, CS, 0, 0],
        ["move", ["control_board"], CS+[12, 0, 0], CS, 0.05, 0.45],
        // test_collision: the XIAO goes 14 mm too far, through the board and the plate
        ["move", ["xiao"], CS+[30, 0, 0], variant == "test_collision" ? CS+[-14, 0, 0] : CS, 0.5, 0.9]], []],
    // 5 cover face down, keypad, joystick group through the sheet, button plate group
    [8, CAM_STACK, [
        ["move", ["cover"], O, O, 0, 0],
        ["move", ["keypad"], [15, 0, 0], O, 0.05, 0.25],
        ["move", JG, JS, JA, 0.3, 0.45],
        ["move", JG, JA, O, 0.45, 0.6],
        ["move", CG, CS, CA, 0.65, 0.78],
        ["move", CG, CA, O, 0.78, 0.95]], []],
    // 6 joystick cable (the USB-C cable shows once the housing is on), foam pad
    [4, CAM_STACK, [
        ["show", ["cable_joy"], 0.1],
        ["move", ["xiao_foam"], [12, 0, 0], O, 0.4, 0.8]], []],
    // 7 V0.30: foam strip onto the housing rim, then the thin strip on the rear wall
    [5, CAM_HOUSING, [
        ["move", ["foam_strip"], H+[-10, 0, 0], H, 0.05, 0.5],
        ["mark", "rear_foam", "housing", 0.55, 0.95]], ["housing"]],
    step8,
    step9,
    // 10 vent label onto the cap's inner face, cap gasket, then the cap from below
    [5, CAM_BOTTOM, [
        ["move", ["battery_cap"], [0, -25, 0], [0, -25, 0], 0, 0],
        ["move", ["vent_label"], [0, -18, 0], [0, -25, 0], 0.05, 0.25],
        ["move", ["cap_gasket"], [0, -15, 0], O, 0.3, 0.5],
        ["move", ["battery_cap", "vent_label"], [0, -25, 0], O, 0.55, 0.8],
        ["mark", "cap_screws", "battery_cap", 0.8, 1]], []],
    // 11 knob onto the pin from outside, with the shim
    [4, CAM_KNOB, [
        ["move", ["knob"], -20*fn, O, 0.1, 0.6],
        ["mark", "shim", "knob", 0.65, 0.95]], []]];

// Events of one part up to step s, as [type, T0, T1, from, to], with T = step + u.
function part_events(n, s) = [for (k=[1:s]) for (e=timeline[k-1][2])
    if (e[0] != "mark" && has(e[1], n))
        e[0] == "move" ? ["move", k+e[4], k+e[5], e[2], e[3]] : [e[0], k+e[2], k+e[2], O, O]];

// State [visible, offset] at time T, folding the events that started by then.
function fold_state(ev, T, i=0, acc=[false, [0, 0, 0]]) =
    i >= len(ev) || ev[i][1] > T ? acc :
    let(e = ev[i])
    fold_state(ev, T, i+1,
        e[0] == "move" ? [true, e[3]+(e[4]-e[3])*(e[2] > e[1] ? ramp(T, e[1], e[2]) : 1)] :
        e[0] == "show" ? [true, acc[1]] : [false, acc[1]]);

// Time is continuous: the end of step s is the start of step s+1, so the next step's
// events at u = 0 count too.
function part_state(n, s, uu) = fold_state(part_events(n, min(s+1, len(timeline))), s+uu);

module mark_shape(m) {
    if (m == "inserts") at_cover_screws() translate([0, 0, 2.5]) cylinder(d=3.6, h=4, $fn=16);
    else if (m == "epoxy") at_usbc() translate([-5, -3, usbc_panel_t+0.5]) cube([10, 6, 4]);
    else if (m == "rear_foam") translate([pouch_x1, pouch_y0, axial_width/2-8]) cube([0.8, pouch_l, 16]);
    else if (m == "cover_screws") at_cover_screws() translate([0, 0, -2]) cylinder(d=3.8, h=2, $fn=16);
    else if (m == "cap_screws") for (s=cap_screws) translate([s[0], cap_y-2.5, s[1]]) rotate([-90, 0, 0]) cylinder(d=3.8, h=2, $fn=16);
    else if (m == "shim") at_joy(-knob_gap) difference() { cylinder(d=knob_hub_d, h=knob_gap, $fn=32); translate([0, 0, -1]) cylinder(d=4, h=3, $fn=16); }
    else assert(false, str("unknown mark ", m));
}

// Upper axial wall removed, as the model's interior view.
module cut_open(on) {
    if (on) difference() { children(); interior_cutter(); } else children();
}

// Every part at its pose for (s, uu), in the model frame.
module pose_at(s, uu, v=variant, skip=[], redlist=[], cut=[]) {
    for (n=PARTS) if (!has(skip, n)) {
        st = part_state(n, s, uu);
        if (st[0]) translate(st[1]) cut_open(has(cut, n))
            if (has(redlist, n)) color([0.9, 0.1, 0.1]) render() part(n); else part(n);
    }
    for (e=timeline[s-1][2]) if (e[0] == "mark" && uu >= e[3] && uu <= e[4]
                                 && floor(6*(uu-e[3])/(e[4]-e[3]+1e-9)) % 2 == 0)
        translate(part_state(e[2], s, uu)[1]) color([1, 0.85, 0]) mark_shape(e[1]);
}

module pose_view(skip=[]) { pose_at(step, u, variant, skip, red, timeline[step-1][3]); }

// The view frame: the model's +X (up while assembling) becomes OpenSCAD's +Z.
module view_frame() { rotate([0, -90, 0]) children(); }

function placed(s) = [for (n=PARTS) if (part_state(n, s, 1)[0]) n];
function moving(s) = [for (n=PARTS) if (len([for (e=timeline[s-1][2]) if (e[0] == "move" && has(e[1], n) && e[2] != e[3]) 1]) > 0) n];

// Moves of step s that change an offset, as [names, u0, u1].
function moves(s) = [for (e=timeline[s-1][2]) if (e[0] == "move" && e[2] != e[3]) [e[1], e[4], e[5]]];

// One part at its pose, or nothing while it is hidden. The collision check uses it.
module part_at(n, s, uu) {
    st = part_state(n, s, uu);
    if (st[0]) translate(st[1]) part(n);
}

if (mode == "pose") view_frame() pose_view();
else if (mode == "only") part(target);
else if (mode == "others") pose_at(step, u, variant, skip=[target]);
else if (mode == "info") {
    echo(info=[step, timeline[step-1][0], timeline[step-1][1], placed(step), moving(step), moves(step)]);
    cube(0.01);
}
