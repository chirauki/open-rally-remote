// Open Rally Remote — complete remote assembly, V0.1
// Units: mm. Open with OpenSCAD. F5 previews the assembly; F6 renders it.
// Components are envelopes for packaging, not supplier STEP models.

$fn = 64;
show_internals = true;
show_fasteners = true;
part_to_render = "assembly";         // assembly, cover, housing, clamp_lower, liner_upper, liner_lower

// Published / project dimensions
bar_diameter = 22.0;               // project nominal control-bar size
bar_liner_radial_thickness = 1.0;   // replaceable TPU insert
apem_button_cutout = 13.6;
apem_reduced_bezel = 15.0;
apem_button_rear_depth = 13.0;
mhs_nominal_cutout = 15.80;         // Ø0.622 in in MHS drawing; profile caveat in guide
mhs_body_diameter = 20.1;           // Ø0.79 in envelope
mhs_rear_depth = 13.5;              // 0.53 in drawing envelope
xiao_length = 21.0;
xiao_width = 17.8;
xiao_board_thickness = 1.6;         // nominal bare PCB envelope; verify bought board
xiao_header_projection = 6.0;      // presoldered-header envelope target; measure actual board
xiao_component_height = 2.0;       // top-side envelope target; confirm on purchased board

// Enclosure and layout design dimensions
face_width = 20.5;                  // front control field
case_width = 25.0;
case_length = 90.0;
cover_thickness = 2.5;              // within APEM and MHS panel ranges
case_depth = 28.5;                  // stack target for controls + XIAO headers + rear clearance
case_wall = 1.8;
case_floor = 2.0;
corner_radius = 3.0;
button_pitch = 20.0;
button_first_from_top = 10.25;
control_y = [case_length/2-button_first_from_top,
             case_length/2-button_first_from_top-button_pitch,
             case_length/2-button_first_from_top-2*button_pitch,
             case_length/2-button_first_from_top-3*button_pitch];

// Serviceable enclosure fasteners and seal (design targets; validate print fit)
cover_screw_clearance = 3.2;        // M3 clearance
boss_thread_pilot = 2.6;            // for M3 self-tapping screw or insert selection
boss_diameter = 5.6;
cover_screw_seal_od = 6.5;
cover_screw_seal_id = 3.2;
cover_screw_seal_depth = 0.6;        // annular seal groove target; choose matching elastomer
gasket_width = 1.5;
gasket_depth = 1.1;
gasket_cross_section = 1.5;         // silicone / EPDM cord
cable_gland_hole = 8.2;              // M8 gland clearance target; confirm against selected gland
cable_gland_boss_diameter = 14.0;
cable_gland_boss_length = 5.0;

// Split clamp: 24 mm bore + 1 mm TPU liner per side gives 22 mm nominal bar fit.
clamp_bore_diameter = bar_diameter + 2*bar_liner_radial_thickness;
clamp_outer_diameter = 30.0;
clamp_width = 24.0;
clamp_center_z = -case_depth - clamp_bore_diameter/2;
clamp_lug_offset_y = 18.0;           // ears sit outside the 22 mm bar liner
clamp_screw_diameter = 3.4;         // M3 clamp screws; inserts in upper half
clamp_tab_height = 4.0;
clamp_insert_diameter = 4.1;        // nominal heat-set M3 insert pocket; select matching insert

// Face coordinate: front surface z=+2.5, inside face z=0, rear case floor z=-28.5.
// Cover occupies z=0..2.5; the rear tub occupies z=-28.5..0.

module rounded_prism(w, l, h, r) {
    linear_extrude(height=h) {
        hull() {
            for (x=[-w/2+r, w/2-r])
                for (y=[-l/2+r, l/2-r])
                    translate([x,y]) circle(r=r);
        }
    }
}

module rounded_ring(ow, ol, iw, il, h, outer_r, inner_r) {
    difference() {
        rounded_prism(ow, ol, h, outer_r);
        translate([0,0,-0.1]) rounded_prism(iw, il, h+0.2, inner_r);
    }
}

module annular_prism(od,id,h) {
    difference() {
        cylinder(d=od,h=h);
        translate([0,0,-0.1]) cylinder(d=id,h=h+0.2);
    }
}

module face_cover() {
    difference() {
        translate([0,0,0]) rounded_prism(case_width, case_length, cover_thickness, corner_radius);
        // Switches A, B, C and lower joystick
        for (i=[0:2])
            translate([0,control_y[i],-0.1]) cylinder(d=apem_button_cutout,h=cover_thickness+0.2);
        // MHS nominal round opening only; manufacturer drawing has an additional 0.291 in profile detail.
        translate([0,control_y[3],-0.1]) cylinder(d=mhs_nominal_cutout,h=cover_thickness+0.2);
        // Four M3 cover screws, each with a small sealing-ring groove.
        for (x=[-9.0,9.0], y=[-41.5,41.5]) {
            translate([x,y,-0.1]) cylinder(d=cover_screw_clearance,h=cover_thickness+0.2);
            translate([x,y,cover_thickness-cover_screw_seal_depth])
                annular_prism(cover_screw_seal_od,cover_screw_seal_id,cover_screw_seal_depth+0.1);
        }
    }
}

module clamp_upper_ring() {
    // Upper half of split collar; cylinder axis is the handlebar axis (X).
    difference() {
        union() {
            intersection() {
                translate([-clamp_width/2,0,clamp_center_z]) rotate([0,90,0]) cylinder(d=clamp_outer_diameter,h=clamp_width);
                translate([-clamp_width, -clamp_outer_diameter, clamp_center_z])
                    cube([2*clamp_width,2*clamp_outer_diameter,clamp_outer_diameter]);
            }
            for (y=[-clamp_lug_offset_y,clamp_lug_offset_y])
                translate([0,y,clamp_center_z]) cylinder(d=7.5,h=4.0);
        }
        intersection() {
            translate([-clamp_width/2-0.1,0,clamp_center_z]) rotate([0,90,0]) cylinder(d=clamp_bore_diameter,h=clamp_width+0.2);
            translate([-clamp_width, -clamp_outer_diameter, clamp_center_z])
                cube([2*clamp_width,2*clamp_outer_diameter,clamp_outer_diameter]);
        }
        // Blind M3 screw pilots from the split plane into the upper clamp half.
        for (y=[-clamp_lug_offset_y,clamp_lug_offset_y])
            translate([0,y,clamp_center_z-0.1]) cylinder(d=clamp_insert_diameter,h=clamp_tab_height+0.2);
    }
}

module rear_housing() {
    difference() {
        union() {
            // Rear tub with its cavity and cable exit removed first.
            difference() {
                translate([0,0,-case_depth]) rounded_prism(case_width,case_length,case_depth,corner_radius);
                translate([0,0,-case_depth+case_floor])
                    rounded_prism(case_width-2*case_wall,case_length-2*case_wall,case_depth-case_floor+0.2,corner_radius-0.7);
                translate([0,0,-gasket_depth])
                rounded_ring(case_width-2.0,case_length-2.0,case_width-2.0-2*gasket_width,case_length-2.0-2*gasket_width,gasket_depth+0.1,corner_radius-0.8,corner_radius-1.6);
                translate([0,-case_length/2-0.1,-11]) rotate([-90,0,0]) cylinder(d=cable_gland_hole,h=case_wall+0.3);
            }
            // Reinforced inner seat for an M8 cable gland and its locknut.
            translate([0,-case_length/2+case_wall,-11]) rotate([-90,0,0])
                difference() {
                    cylinder(d=cable_gland_boss_diameter,h=cable_gland_boss_length);
                    translate([0,0,-0.1]) cylinder(d=cable_gland_hole,h=cable_gland_boss_length+0.2);
                }
            // Add internal supports after carving the cavity so they remain intact.
            for (x=[-9.0,9.0], y=[-41.5,41.5])
                translate([x,y,-case_depth+case_floor]) cylinder(d=boss_diameter,h=case_depth-case_floor-1.0);
            // Board edge ledges and rails; header pins remain clear underneath the board.
            for (x=[-1,1]) {
                translate([x*(xiao_width/2+0.55),-24.5,-19.5]) cube([1.5,xiao_length+1.6,0.8],center=true);
                translate([x*(xiao_width/2+1.3),-24.5,(-case_depth+case_floor-17.0)/2])
                    cube([1.4,xiao_length+1.6,(-17.0)-(-case_depth+case_floor)],center=true);
            }
            // Integral upper clamp saddle is printed with the rear housing; no narrow neck joins it.
            // The outer shell overlaps the case rear by 3 mm, then two side webs reinforce the joint.
            clamp_upper_ring();
            web_bottom = clamp_center_z + 10.0;
            web_top = -case_depth + 1.0;
            web_height = web_top - web_bottom;
            for (y=[-9.0,9.0])
                translate([0,y,web_bottom]) rounded_prism(20,3.2,web_height,1.0);
        }
        // Boss pilots, terminate before the outside floor.
        for (x=[-9.0,9.0], y=[-41.5,41.5])
            translate([x,y,-case_depth+case_floor-0.1]) cylinder(d=boss_thread_pilot,h=case_depth-case_floor+0.1);
    }
}

module clamp_lower_ring() {
    difference() {
        union() {
            intersection() {
                translate([-clamp_width/2,0,clamp_center_z]) rotate([0,90,0]) cylinder(d=clamp_outer_diameter,h=clamp_width);
                translate([-clamp_width,-clamp_outer_diameter,clamp_center_z-clamp_outer_diameter])
                    cube([2*clamp_width,2*clamp_outer_diameter,clamp_outer_diameter]);
            }
            for (y=[-clamp_lug_offset_y,clamp_lug_offset_y])
                translate([0,y,clamp_center_z-clamp_tab_height]) cylinder(d=7.5,h=clamp_tab_height);
        }
        intersection() {
            translate([-clamp_width/2-0.1,0,clamp_center_z]) rotate([0,90,0]) cylinder(d=clamp_bore_diameter,h=clamp_width+0.2);
            translate([-clamp_width,-clamp_outer_diameter,clamp_center_z-clamp_outer_diameter])
                cube([2*clamp_width,2*clamp_outer_diameter,clamp_outer_diameter]);
        }
        for (y=[-clamp_lug_offset_y,clamp_lug_offset_y])
            translate([0,y,clamp_center_z-clamp_outer_diameter/2-0.1]) cylinder(d=clamp_screw_diameter,h=clamp_outer_diameter/2+0.3);
    }
}

module clamp_liner_half(upper=true) {
    liner_outer = clamp_bore_diameter;
    liner_inner = bar_diameter;
    difference() {
        intersection() {
            translate([-clamp_width/2,0,clamp_center_z]) rotate([0,90,0]) cylinder(d=liner_outer,h=clamp_width);
            if (upper)
                translate([-clamp_width,-clamp_outer_diameter,clamp_center_z]) cube([2*clamp_width,2*clamp_outer_diameter,clamp_outer_diameter]);
            else
                translate([-clamp_width,-clamp_outer_diameter,clamp_center_z-clamp_outer_diameter]) cube([2*clamp_width,2*clamp_outer_diameter,clamp_outer_diameter]);
        }
        intersection() {
            translate([-clamp_width/2-0.1,0,clamp_center_z]) rotate([0,90,0]) cylinder(d=liner_inner,h=clamp_width+0.2);
            if (upper)
                translate([-clamp_width,-clamp_outer_diameter,clamp_center_z]) cube([2*clamp_width,2*clamp_outer_diameter,clamp_outer_diameter]);
            else
                translate([-clamp_width,-clamp_outer_diameter,clamp_center_z-clamp_outer_diameter]) cube([2*clamp_width,2*clamp_outer_diameter,clamp_outer_diameter]);
        }
    }
}

module controls_and_pcb() {
    // APEM switch component envelopes behind the front panel.
    for (i=[0:2])
        translate([0,control_y[i],-apem_button_rear_depth/2]) cylinder(d=12,h=apem_button_rear_depth,center=true);
    // Ruffy MHS body envelope behind the face. Exact wires/nut are not supplier STEP geometry.
    translate([0,control_y[3],-mhs_rear_depth/2]) cylinder(d=mhs_body_diameter,h=mhs_rear_depth,center=true);
    // XIAO board, component-side envelope, and pre-soldered header pins.
    xiao_top_z = -(mhs_rear_depth + 2.0 + xiao_component_height);
    xiao_board_z = xiao_top_z - xiao_board_thickness/2;
    translate([0,-24.5,xiao_board_z]) cube([xiao_width,xiao_length,xiao_board_thickness],center=true);
    translate([0,-24.5,xiao_top_z+xiao_component_height/2])
        cube([xiao_width-2.0,xiao_length-2.0,xiao_component_height],center=true);
    for (x=[-7.62,7.62], y=[-7.62:2.54:7.62])
        translate([x,y-24.5,xiao_board_z-xiao_board_thickness/2-xiao_header_projection/2])
            cube([0.64,0.64,xiao_header_projection],center=true);
    // Flexible USB supply pigtail. Three short hulls provide a bent lead to the XIAO USB-C edge.
    cable_segment([0,-44,-11],[0,-40,-11],4.5);
    cable_segment([0,-40,-11],[0,-38,-13.5],4.5);
    cable_segment([0,-38,-13.5],[0,-36,-18.3],4.5);
}

module cable_segment(a,b,d) {
    hull() {
        translate(a) sphere(d=d);
        translate(b) sphere(d=d);
    }
}

module gasket_ring() {
    // Rectangular-section gasket envelope for a 1.5 mm cord in the tub's 1.1 mm channel.
    translate([0,0,-gasket_depth]) rounded_ring(case_width-2.2,case_length-2.2,
        case_width-2.2-2*gasket_width,case_length-2.2-2*gasket_width,
        gasket_cross_section,corner_radius-0.5,corner_radius-1.2);
}

module cover_fasteners() {
    color("silver") for (x=[-9.0,9.0], y=[-41.5,41.5]) {
        translate([x,y,2.5]) cylinder(d=5.5,h=0.8); // low-profile screw head
        translate([x,y,-9.2]) cylinder(d=2.8,h=11.7); // M3 x 12.5 shank
    }
    color([0.05,0.05,0.05]) for (x=[-9.0,9.0], y=[-41.5,41.5])
        translate([x,y,cover_thickness-cover_screw_seal_depth]) annular_prism(6.1,cover_screw_seal_id,0.55);
    color("silver") for (y=[-clamp_lug_offset_y,clamp_lug_offset_y]) {
        translate([0,y,clamp_center_z-clamp_tab_height-1.2]) cylinder(d=5.5,h=1.2);
        translate([0,y,clamp_center_z-clamp_tab_height]) cylinder(d=2.8,h=8.0);
    }
}

module handlebar_reference() {
    %color([0.5,0.5,0.5,0.35]) translate([-50,0,clamp_center_z]) rotate([0,90,0]) cylinder(d=bar_diameter,h=100);
}

module assembly() {
    color([0.18,0.28,0.34]) rear_housing();
    color([0.27,0.39,0.46]) face_cover();
    color([0.12,0.12,0.12]) clamp_lower_ring();
    color([0.35,0.25,0.15]) clamp_liner_half(true);
    color([0.35,0.25,0.15]) clamp_liner_half(false);
    handlebar_reference();
    if (show_internals) color([0.82,0.55,0.16]) controls_and_pcb();
    color([0.12,0.12,0.12]) gasket_ring();
    if (show_fasteners) cover_fasteners();
}

if (part_to_render == "assembly") assembly();
else if (part_to_render == "cover") face_cover();
else if (part_to_render == "housing") rear_housing();
else if (part_to_render == "clamp_lower") clamp_lower_ring();
else if (part_to_render == "liner_upper") clamp_liner_half(true);
else if (part_to_render == "liner_lower") clamp_liner_half(false);
