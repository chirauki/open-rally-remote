// Open Rally Remote — V0.25 battery and XIAO assembly, animated.
// Render with OpenSCAD --animate; $t runs 0..1. Seen from the front and below, through a
// see-through housing, cover off. The XIAO's BAT pad position and the wire routing are drawn
// schematically.
//
//   openscad -o frame.png --animate 96 --imgsize=700,1000 --projection=p \
//            --camera=-22,-40,11.5,-20,-65,0,360 --colorscheme=Tomorrow battery-assembly-v0.25.scad
//
// The step captions are added to the frames afterwards.

include <complete-remote-v0.25.scad>
part_to_render = "none";
$fn = 24;

zc = axial_width/2;
wire_d = 1.0;
red = [0.85,0.15,0.12];
black = [0.12,0.12,0.12];
pad_y = xiao_y+6;                       // schematic: BAT pads on the XIAO rear
pad_dz = 2.0;                           // BAT+ at +Z, BAT- at -Z
gap_x = xiao_rear_x+0.6;                // wire run between the XIAO rear joints and the pouch
cell = [pouch_t,pouch_l,pouch_w];
cell_x = (pouch_x0+pouch_x1)/2;
cell_y_final = pouch_y0+pouch_clear+pouch_l/2;
tuck = [cell_x-0.5,cell_y_final-pouch_l/2-3.2];   // splice under the cell

function lerp(a,b,u) = a+(b-a)*u;
function ph(a,b) = ramp($t,a,b);

// --- Timeline --------------------------------------------------------------------------
// XIAO: up through the bottom opening 7.5 mm behind its rails, forward to them, up to the stop.
xi_in = ph(0.04,0.16); xi_back = ph(0.16,0.21); xi_up = ph(0.21,0.33);
xi_shift = 7.5;
xi_low = -28-(xiao_y-xiao_length/2);    // dy with the board's lower end at Y = -28
pouch_show = $t>=0.43;
splice_join = ph(0.45,0.52);
shrink_slide = ph(0.53,0.58); shrink = ph(0.58,0.62);
pouch_under = ph(0.64,0.70); pouch_up = ph(0.70,0.82);
cap_up = ph(0.84,0.93); screws_in = ph(0.93,0.97);

xiao_dx = lerp(xi_shift,0,xi_back);
xiao_dy = xi_back<1 ? lerp(xi_low-57,xi_low,xi_in) : lerp(xi_low,0,xi_up);
xiao_a = 0;
wire_tail = -56;                        // free ends of the battery wires, below the remote

// --- Helpers ---------------------------------------------------------------------------
module wire(pts,c,d=wire_d) color(c) for (i=[0:len(pts)-2]) hull() { translate(pts[i]) sphere(d=d); translate(pts[i+1]) sphere(d=d); }
function rot_y(p,a,c) = [c[0]+(p[0]-c[0])*cos(a)+(p[2]-c[2])*sin(a), p[1], c[2]-(p[0]-c[0])*sin(a)+(p[2]-c[2])*cos(a)];
function xiao_tf(p) = let(q = rot_y(p,xiao_a,[xiao_x,0,zc])) [q[0]+xiao_dx,q[1]+xiao_dy,q[2]];
module xiao_moved() translate([xiao_dx,xiao_dy,0]) translate([xiao_x,0,zc]) rotate([0,xiao_a,0]) translate([-xiao_x,0,-zc]) xiao_envelope();

// Cell position: beside the housing, then under the opening, then up into place.
cell_out = [12,-100];
cell_low = [cell_x,-95];
cell_pos = pouch_up>0 ? [cell_x,lerp(cell_low[1],cell_y_final,pouch_up)] : [lerp(cell_out[0],cell_low[0],pouch_under),lerp(cell_out[1],cell_low[1],pouch_under)];
cell_bottom = [cell_pos[0],cell_pos[1]-pouch_l/2];

// Splice point: below the opening while it is made, then carried under the cell.
splice_out = [gap_x-8,-68];
splice = pouch_up>0 ? [lerp(splice_out[0],tuck[0],pouch_up),min(lerp(splice_out[1],tuck[1],pouch_up),cell_bottom[1]-3.2)]
                    : splice_out;

// --- Parts -----------------------------------------------------------------------------
color([0.70,0.76,0.80]) housing();
color([0.20,0.55,0.30]) usbc_envelope();
color([0.15,0.48,0.32]) xiao_moved();

// Battery wires from the XIAO: they hang out of the bottom opening while it goes in, then run
// down behind it, then to the splice.
for (k=[0,1]) {
    dz = k==0 ? pad_dz : -pad_dz;
    c = k==0 ? red : black;
    sx = k==0 ? -2.5 : 2.5;                       // the two splices sit side by side
    pad = [xiao_pcb_x1,pad_y,zc+dz];
    if (xi_up<1) {
        q = xiao_tf([pad[0]+1.4,pad[1],pad[2]]);
        wire([xiao_tf(pad),q,[q[0],min(q[1]-2,wire_tail),q[2]]],c);
    } else {
        top = [[pad[0],pad[1],pad[2]],[gap_x,pad[1],pad[2]],[gap_x,cell_y_final-pouch_l/2+2,pad[2]]];
        end = pouch_show ? [splice[0]+sx,splice[1]+(1-splice_join)*6,zc+dz*(1-pouch_up)] : [gap_x,wire_tail,zc+dz];
        wire(concat(top,[[gap_x,max(end[1]+4,pod_bottom_y-2),pad[2]],end]),c);
        // Heat-shrink sleeve, parked on the XIAO wire, then over the joint, then shrunk.
        if (pouch_show) {
            sl = lerp(10,0,shrink_slide);
            color(lerp([0.9,0.9,0.9,0.6],concat(c,[1]),shrink))
                translate([end[0],end[1]+sl,end[2]]) rotate([90,0,0])
                    cylinder(d=lerp(2.4,1.6,shrink),h=8,center=true);
        }
    }
    // Pouch lead from the protection board end to the splice.
    if (pouch_show) {
        lead0 = [cell_bottom[0]+(k==0?1.5:-1.5),cell_bottom[1],zc+dz];
        j = [splice[0]+sx,splice[1]-(1-splice_join)*6,zc+dz*(1-pouch_up)];
        wire([lead0,[lead0[0],lead0[1]-3,lead0[2]],j],c);
        if (splice_join>=1) color([0.75,0.75,0.78]) translate([splice[0]+sx,splice[1],zc+dz*(1-pouch_up)]) sphere(d=1.6);
    }
}

// The cell: protection board end (yellow) down.
if (pouch_show) translate([cell_pos[0],cell_pos[1],zc]) {
    color([0.85,0.25,0.20]) cube(cell,center=true);
    color([0.95,0.75,0.20]) translate([0,-pouch_l/2+2,0]) cube([pouch_t+0.1,4,pouch_w+0.1],center=true);
}

// Foam pad, gasket and cap come up together; the screws follow.
cap_dy = lerp(-45,0,cap_up);
if ($t>=0.83) translate([0,cap_dy,0]) {
    color([0.30,0.30,0.32]) translate([cell_x,cap_y-gasket_gap+1.0,zc]) cube([6,2,12],center=true);
    color([0.15,0.15,0.15]) cap_gasket();
    color([0.55,0.62,0.68]) battery_cap();
    for (s=cap_screws) color([0.70,0.70,0.72]) translate([s[0],pod_bottom_y-lerp(6,0,screws_in),s[1]]) rotate([-90,0,0]) {
        cylinder(d1=cap_screw[0],d2=1.9,h=cap_screw[1]);
        cylinder(d=1.9,h=cap_screw[2]);
    }
}
