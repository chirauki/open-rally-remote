// Paper templates for every V0.34 foam piece, at 1:1. Export to SVG, print at 100 % on A4 and
// check the 40 mm bar with a ruler. Stick the paper on the foam sheet (or hold it down) and cut
// along the lines with a sharp knife. Every piece is a stack of layers of the ~1.15 mm sheet;
// the label gives how many of each to cut.
//   openscad -o foam-templates-v0.34.svg mechanical/cad/tools/foam-templates-v0.34.scad
// Replaces cap-gasket-template.scad, which still draws the 23 mm wide V0.32 cap.
include <../complete-remote-v0.34.scad>
part_to_render = "none";

lbl = 3.2;   // label text size
module label(t, s=lbl) { text(t, size=s, font="Liberation Sans", halign="left", valign="top"); }

// Cover seal: the compressed foam band on the rim (foam_strip), unfolded into one flat ring.
// The fold is a straight line along Z, so the band unfolds without stretching. The band is split
// on the fold's bisector (fold_corner of its two faces); the lower part turns back by fold_angle
// about the sheet-side fold corner, so both facets lie in the plane normal to X.
fold_c0 = fold_corner(sheet_back_off);
fold_c1 = fold_corner(rim_off);
fold_v = (fold_c1-fold_c0)/norm(fold_c1-fold_c0);
module fold_side(s) {   // s = 1: upper facet side of the bisector, s = -1: lower
    linear_extrude(height=200, center=true)
        polygon([fold_c0-100*fold_v, fold_c0+100*fold_v, fold_c0+100*fold_v+[0,s*200], fold_c0-100*fold_v+[0,s*200]]);
}
module rim_flat() {
    projection() rotate([0,-90,0]) union() {
        intersection() { foam_strip(); fold_side(1); }
        translate([fold_c0[0],fold_c0[1],0]) rotate([0,0,-fold_angle]) translate([-fold_c0[0],-fold_c0[1],0])
            intersection() { foam_strip(); fold_side(-1); }
    }
}

// Battery cap gasket, seen from the housing side, as in cap-gasket-template.scad.
module cap_gasket_2d() { projection() rotate([90,0,0]) cap_gasket(); }

// Pads, as plain rectangles: [width, height] in mm.
xiao_pad = [xiao_length-4, xiao_width-8];                    // on the XIAO's components, 6 layers
cap_pad = [pod_cavity_x1-cap_open_x0-0.5, (axial_width-2*case_wall-vent_pad_d-1.4)/2];   // either side of the vent label, 4 layers
rear_pad = [pouch_l-1, pouch_w-1];                           // rear wall where the pouch lies, 1 layer

module piece(at, t) { translate(at) { children(); translate([0,-2]) label(t); } }

// A4 portrait, origin at the top-left margin; Y grows downward on the page.
module sheet() {
    translate([10,-12]) label("Open Rally Remote V0.34 - foam templates, print at 100 %", 4);
    translate([10,-20]) label("Check: the bar below is 40 mm. Sheet: about 1.15 mm closed-cell foam.", lbl);
    translate([10,-27]) square([40,1.5]);

    // Cover seal ring, both facets in one piece, 2 layers. Cut the outline, then the inside.
    translate([10,-40]) label("Cover seal: cut 2 (one per layer)");
    translate([10,-48]) rim_flat_placed();
    translate([40,-48-(bbox_rim[1][1]-fold_c0[1])]) label("fold", 2.5);

    translate([120,-40]) label("Battery cap gasket: cut 2");
    translate([120,-48]) cap_gasket_placed();

    translate([120,-110]) label("XIAO pad: cut 6");
    translate([120,-116-xiao_pad[1]]) square(xiao_pad);
    translate([160,-110]) label("Cap pad: cut 8");
    translate([160,-116-cap_pad[1]]) square(cap_pad);
    translate([160,-118-2*cap_pad[1]]) square(cap_pad);
    translate([120,-145]) label("Rear wall pad: cut 1");
    translate([120,-151-rear_pad[1]]) square(rear_pad);

    translate([10,-205]) for (i=[0:len(notes)-1]) translate([0,-6*i]) label(notes[i], 3.0);
}
notes = [
    "Cover seal: stick the two layers on top of each other first, then on the rim.",
    "Do not cut the ring at the fold: bend it over the fold. A joint would let water through.",
    "Cap gasket: two layers, stuck together, inside the cap's lip; prick the three screw holes.",
    "Cap pads: four layers on each side of the vent label, inside the cap; keep the label clear.",
    "XIAO pad: six layers on the XIAO's components. Rear wall pad: one layer where the pouch lies.",
];

// Each outline moved so its bounding box starts at the origin and extends to +X, -Y.
module rim_flat_placed() { bb = bbox_rim; translate([-bb[0][0], -bb[1][1]]) rim_flat(); }
module cap_gasket_placed() { bb = bbox_cap; translate([-bb[0][0], -bb[1][1]]) cap_gasket_2d(); }

// Bounding boxes of the projected outlines, [[min x, min y], [max x, max y]], measured from
// each outline exported alone (V0.34).
bbox_rim = [[-25.5, -44.15], [0.5, 46.5]];
bbox_cap = [[-34.3, -25.0], [-17.9, 0]];

sheet();
