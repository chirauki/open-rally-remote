// Open Rally Remote — V0.26 assembly video: the parts and the assembly timeline.
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

include <complete-remote-v0.26.scad>
part_to_render = "none";

step = 11;
u = 1;
variant = "documented";
red = [];
mode = "pose";
target = "";

// One name per drawn part. The video and the collision check use the same names.
PARTS = ["housing", "cover", "keypad", "joy_plate", "button_plate", "stick", "knob",
         "battery_cap", "cap_gasket", "control_board", "xiao", "xiao_foam", "joy_board",
         "usbc_board", "pouch", "cable_joy", "cable_usb", "cable_bat", "vent_label"];

// Each part in its final position, with the model's colours.
module part(name) {
    if (name == "housing") color([0.67,0.73,0.77]) housing();
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
    else if (name == "pouch") color([0.75,0.2,0.2]) pouch_envelope();
    else if (name == "cable_joy") color([0.2,0.2,0.2]) cable_joy();
    else if (name == "cable_usb") color([0.2,0.2,0.2]) cable_usb();
    else if (name == "cable_bat") color([0.6,0.1,0.1]) cable_bat();
    else if (name == "vent_label") color([0.95,0.95,0.95]) vent_label_envelope();
    else assert(false, str("unknown part ", name));
}

function has(list, x) = len([for (y=list) if (y==x) 1]) > 0;

// Every part, at its pose for (step, u).
module pose_view(skip=[]) {
    for (n=PARTS) if (!has(skip, n)) part(n);
}

if (mode == "pose") pose_view();
else if (mode == "only") part(target);
else if (mode == "others") pose_view(skip=[target]);
