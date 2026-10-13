// Open Rally Remote — concept, V0.25
// Units: mm. Ring lies in XY; handlebar axis is Z. Controls are on the side face (YZ).
//
// V0.25 drops the XIAO's pin headers and fits a longer pouch behind the board:
//   - XIAO without headers (Seeed 102010448): the signal wires solder to the front of its pads,
//     the pouch leads to the BAT pads on the rear. The rear keeps 1.0 mm for joints and leads
//     instead of the 2.5 mm spacer and 6 mm pins.
//   - the freed space takes a 602050 pouch (6 x 20 x 50 mm, 600 mAh in the listing) instead of
//     the 602030: the pouch envelope now runs up behind the XIAO to Y = 17.5 mm.
//   - the rails' slot loses the header spacer room and keeps 0.3 mm each side for solder on the
//     edge pads.
//   - battery cap: the pouch cannot pass the front opening (the gasket lip leaves 16.4 mm and the
//     lower cover bosses are in the way), so it slides in from below. The rear part of the
//     bottom end, X = cap_front_x to the rear face, is a separate cap with a flat gasket and
//     three M2 screws along Y. A housing strip in front of it keeps the cap gasket apart from
//     the cover gasket. The bottom band of the pod widens to pod_width (2.5 mm walls) so the
//     gasket has a land on the sides. The inner rear-bottom corner drops to R1 and the outer one
//     to R2, so the pouch slides straight up past them.
//   - the vent moves forward to X = vent_x, in front of the cap.
// Everything else is V0.24.
//
// V0.24 makes the remote removable and battery powered (docs/battery-study.md, issue #1):
//   - base: the clamp ring stays on the bar, bolted as before, with a flat platform in front
//     of the bar at X = platform_x. One base per bar size (bar_diameter 22.2 or 25.4).
//   - remote: the V0.23 pod without the ring and shoulders; its rear is a flat face at
//     X = rear_x with an interrupted dovetail groove.
//   - fitting: two dovetail rail segments on the platform pass through gaps between two lip
//     segments in the groove. Press the remote onto the platform 'slide' mm low, then slide it
//     up (+Y) against the stop at the groove end. A spring-loaded M3 screw head in the base
//     (the lock) drops into a hole in the remote's rear face. Pull its knob to release.
//   - TPU strips on the platform push the remote off the platform, so the dovetail flanks
//     seat without play.
//   - a fixed LiPo pouch in the lower rear of the cavity, freed by removing the cable gland;
//     a sealed, charge-only USB-C receptacle in the rear face, above the groove, covered by the
//     base on the bike. Any USB-C cable charges it off the bike.
//   - the vent moves to the bottom end wall, where the gland was.
//   - APEM ISR3SAD200 buttons: cut-out with APEM's anti-rotation flat, real bezel, actuator and nut;
//     the buttons move up 1 mm and the pod top 1.5 mm so the Ø17.5 bezels sit on the flat facet.
//   - the lock knob is a quarter-turn cup with two steel pins in L-slots: it cannot be pulled until
//     it is turned 90 degrees.
//   - a charge LED: a side-looking LED on the USB-C PCB shines through a Ø1.6 mm hole beside the
//     receptacle, filled with clear epoxy. The firmware lights it while the cell charges.
//   - joystick switches: KSC221JLFS instead of the KSC222JLFS, which is out of stock at LCSC.
//     Same force and land pattern, but up to 0.65 mm travel, so the knob push gap grows from
//     0.7 to 0.9 mm and the knob from 5.5 to 5.7 mm above the cover.
// Everything else in front of the remote's rear face is the V0.23 pod, unchanged.
//
// V0.20 folds the control face between button C and the lower control: the upper facet (A, B, C)
// stays normal to X, the lower facet turns fold_angle toward the bar so the lower end of the
// pod clears the thumb's path to the turn-signal switch.
//
// V0.22 puts a joystick back on the lower facet, built from low-cost parts: a printed stick
// with a ball that pivots in a seat in the joystick plate, and a cross-shaped disc under the
// ball resting on four C&K KSC2 sealed tact switches. The switches' own springs centre the
// stick. Pushing the stick straight in presses all four; the firmware reads that as the centre
// press. The gasket's lower-facet sheet (from V0.21) grips the stick and seals the opening.
//
// V0.23 fits the joystick to a real PCB: the KSC2 land pattern (LCSC C221728) puts its pads
// 0.95 mm outside the body, so all four switches turn 90 degrees (pad rows radial for up/down,
// tangential for the bar-axis pair), the standoffs move to clear the pads, the PCB becomes an
// octagon shared with the KiCad board (electronics/joystick-pcb), and the rear keeps
// joy_pcb_rear for the input protection parts (PTC fuse, SMB TVS) and the wire pads.
//
// V0.22 also widens the control end of the pod to pod_width with pod_wall walls, while the
// clamp ring and everything within pod_wide_x of the bar keep axial_width.
//
// One outer solid (convex hull of the pod outline and the Ø44 clamp circle, axial_width wide,
// plus the pod_width front part) is cut into printed parts by offsets of the folded front and
// by the diametral clamp split:
//   - face cover:  0 .. face_cover_thickness behind the folded front
//   - gasket:      the next gasket_gap (compressed thickness); wall land on the upper facet,
//                  a full sheet on the lower facet
//   - joystick plate: behind the lower-facet sheet, joy_plate_t thick
//   - housing:     behind that, up to the split plane X = body_face_x
//   - clamp cap:   X >= cap_face_x
//
// Values marked MEASURE are supplier or purchase unknowns; check them on the real parts.

$fn = 96;
part_to_render = "assembly"; // assembly, entry, base, interior, section, housing, base_front, base_cap,
                             // cover, gasket, stick, ball_disc, knob, joy_plate, lock_knob, liner_main,
                             // liner_cap, print_housing, print_base_front, print_base_cap, print_cover,
                             // print_gasket, print_ball_disc, print_knob, print_joy_plate, print_lock_knob,
                             // battery_cap, cap_gasket, print_battery_cap, print_cap_gasket
show_internals = true;       // component envelopes in section

// --- Handlebar and base clamp ----------------------------------------------------------
bar_diameter = 22.2;         // base variant: 22.2 (7/8 in) or 25.4 (1 in); MEASURE the bar
liner_radial = 1.0;          // TPU liner; tune to measured bar and print process
clamp_bore = bar_diameter + 2*liner_radial;
clamp_bore_max = 25.4 + 2*liner_radial;   // largest base variant; the shared geometry must suit it
clamp_outer = 46.0;          // base ring
axial_width = 23.0;          // clamp and rear pod; NAVCOMM manual: at least 23 mm free between grip and switchgear
pod_width = 26.0;            // control end of the pod, beyond pod_wide_x from the bar
pod_wall = 2.0;              // axial walls of the wide part
pod_wide_x = -38.0;          // the pod is pod_width wide for X below this
pod_step = 1.5;              // 45-degree chamfer from pod_width down to axial_width ending at pod_wide_x
pod_z0 = (axial_width-pod_width)/2;
pod_z1 = pod_z0+pod_width;
pod_in0 = pod_z0+pod_wall;   // inner faces of the wide part's axial walls
pod_in1 = pod_z1-pod_wall;

split_gap = 0.8;             // total gap between body and cap faces; closes as bolts clamp the liner
clamp_bolt_y = 18.5;         // 17 in V0.23; moved out for the 25.4 mm bore
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
case_wall = 1.0;             // end walls, and axial walls of the narrow part
face_cover_thickness = 2.5;  // panel range: APEM IS 1.5-4 mm
gasket_gap = 0.6;            // compressed gasket thickness between cover and housing
gasket_print_thickness = 0.8;// printed or cut thickness; 25 % compression
cover_front_x = -57.5;       // upper facet outer plane
fold_y = -12.5;              // fold line on the outer surface, between button C and the joystick
fold_angle = 20;             // lower facet turns this far toward the bar; the gland that limited it to
                             // 20 deg is gone in V0.24, but 30 deg has not been rechecked
                             // (V0.20 joystick values: centre 16.5, lower_facet_length 32, lower screws at 5 and 27.6)
lower_facet_length = 30.0;   // outer surface, fold to lower end; sized for the corner cover screws
pod_top_y = 45.5;           // 44 until the APEM bezels were modelled
pod_max_x = -15.0;
pod_rear_corner = 7.0;       // sets the tangent diagonals to the clamp ring
pod_front_corner = 3.0;

// --- Base platform and interrupted dovetail ---------------------------------------------
// The base platform is the plane X = platform_x; the remote's rear face sits dt_c behind it.
// Rails and groove are dovetails in the XZ section with 45-degree flanks, centred on Z.
platform_x = -17.2;          // 3.5 mm in front of the 25.4 mm bore with its liner
dt_c = 0.2;                  // dovetail clearance, normal to every face
rear_x = platform_x-dt_c;    // remote rear face
dt_h = 2.5;                  // rail height
dt_neck = 10.0;              // rail width at the platform
dt_head = dt_neck+2*dt_h;    // rail width at its top (45-degree flanks)
rail_seg = 8.0;              // length of each rail segment along Y
rail_gap = 9.0;              // gap between the two segments
slide = rail_seg+1.0;        // slide from the entry position to the stop
lip_seg = rail_seg-1.0;      // lip segments in the groove, 0.5 mm shorter at each end
rail_y = [[-rail_gap/2-rail_seg,-rail_gap/2],[rail_gap/2,rail_gap/2+rail_seg]];  // base frame
lip_y = [for (r=rail_y) [r[0]+0.5,r[1]-0.5]];                                   // remote frame
groove_y0 = rail_y[0][0];    // stop: the lower rail's end bears here
groove_y1 = rail_y[1][1]+slide+0.5;
groove_floor_x = platform_x-dt_h-dt_c;
floor_wall = 1.3;            // groove floor to cavity
base_y0 = -41.0;             // platform extent along Y; covers the lock knob
base_y1 = 33.5;             // covers the USB-C receptacle
base_back_x = -5.0;          // rear face of the platform block below and above the ring
// Anti-rattle: TPU strips in pockets on the platform, either side of the rails.
strip_z = [1.5,5.5];         // from the Z = 0 face; mirrored for the other side
strip_y = [-30.0,20.0];
strip_pocket = 0.6;
strip_t = 1.4;               // proud by strip_t-strip_pocket; compressed when the flanks seat

// --- Lock: M3 socket head screw, spring, printed knob ------------------------------------
// The screw head is the lock pin. A spring under the head, in a pocket in the platform,
// pushes it out into a hole in the remote's rear face. The shank runs back through the base
// to a knob with an M3 insert, locked by a nut; the knob bears on base_back_x and sets how far
// the head stands out. Pull the knob to release.
lock_y = -32.0;              // below the ring, clear of the lower clamp bolt; the Ø16 knob clears the ring
lock_head_d = 5.5;           // ISO 4762 M3
lock_head_h = 3.0;
lock_out = 2.0;              // head proud of the platform when locked
lock_pocket_d = 6.0;
lock_spring_solid = 4.0;     // spring length with the head fully in. Spring 0.5 x 5 x 10 mm (wire x OD x free
                             // length), stainless: about 3.4 N locked, 5 N pulled; MEASURE the one bought
lock_pocket_depth = lock_head_h+lock_spring_solid;
lock_shank_hole = 3.4;
lock_hole_d = 5.8;           // in the remote
lock_hole_depth = lock_out+0.4;
// Quarter-turn knob: a cup over a boss on the back of the platform block. Two Ø1.5 steel pins
// through the cup wall run in L-slots in the boss. Locked, the pins sit in the circumferential
// slots and the knob cannot be pulled; turn it 90 degrees to bring them to the axial slots, then
// pull. This stops a branch or a strap pulling the knob by accident.
lock_knob_d = 16.0;
lock_knob_h = 8.0;
lock_boss_d = 9.0;
lock_boss_h = 3.5;
lock_bore_d = 9.4;           // in the knob, over the boss
lock_bore_h = 4.0;
lock_pin_d = 1.5;            // ISO 8734 dowel pin, 1.5 x 4
lock_pin_len = 4.0;
lock_pin_z = 1.2;            // pin axis from the knob rim
lock_pin_r_in = 3.7;         // inner end of the pin, radius
lock_slot_r = 3.3;           // slot floor radius in the boss
lock_slot_w = 1.9;           // slot width for the pin
lock_screw_length = 22.0;    // M3 x 22: through the boss and the knob insert, 2.8 mm left for a lock nut; MEASURE

// --- Charging: sealed USB-C receptacle in the rear face ---------------------------------
// GCT USB4736-GF-A: a charge-only (6-contact) USB-C receptacle, top mount, horizontal, IP67 with
// its USBTJ-06 silicone gasket (kit USB4736-GF-A-KIT). It sits on a small PCB that carries the
// two 5.1 kohm CC pull-downs, so USB-C chargers supply 5 V. VBUS and GND go to the joystick PCB
// input. It sits above the groove, where the platform covers it on the bike.
// Dimensions from GCT drawing USB4736, revision A, 9 April 2025:
//   - recommended panel: 1.80 mm thick; through slot 9.14 x 3.36 mm, R1.43; on the inside a
//     gasket pocket 11.00 x 5.90 mm, R1.60, 0.60 mm deep;
//   - gasket USBTJ-06: 10.64 x 4.86 x 0.90 mm, R1.60; compress 35-45 % (0.315 mm minimum);
//   - receptacle: nose 8.94 x 3.16 mm, 1.20 mm long; body 9.99 wide, 4.61 mm above the PCB,
//     8.60 mm long overall; shell axis 2.38 mm above the PCB; PCB 1.20 mm thick.
// The wall is thinned from inside to the 1.80 mm panel over a clearance pocket for the body
// and the PCB.
usbc_y = 29.5;               // shell axis; long side along the bar
usbc_panel_t = 1.80;
usbc_slot = [9.14,3.36];     // along Z, along Y
usbc_slot_r = 1.43;
usbc_pocket = [11.00,5.90];
usbc_pocket_r = 1.60;
usbc_pocket_depth = 0.60;
usbc_gasket = [10.64,4.86];
usbc_gasket_t = 0.90;
usbc_gasket_r = 1.60;
usbc_nose = [8.94,3.16,1.20];   // along Z, along Y, along X
usbc_body = [9.99,4.61,8.60];   // width, height above the PCB, overall length
usbc_axis_h = 2.38;          // shell axis above the PCB top
usbc_pcb = [19.0,13.6,1.20]; // receptacle PCB (electronics/usbc-pcb): along Z, along X, thickness
usbc_pcb_edge = 0.53+1.70;   // PCB front edge behind the outer face: nose recess + nose overhang (GCT)
usbc_pcb_holes = [[-5.4,10.6],[5.4,10.6]];  // M2 holes: Z offset, distance from the PCB front edge
usbc_rib_h = 3.5;            // rib under the PCB, full cavity width, for M2 thread-forming screws
usbc_pilot_d = 1.6;          // MEASURE pilot for the chosen screw
usbc_screw = [3.5,1.1,4.0];  // M2 x 4 button head: head diameter, head height, length
usbc_squeeze = 0.37;         // gasket compression, about 41 %
usbc_plug = [12.4,6.5,20.0]; // cable plug overmold envelope: along Z, along Y, length
// Charge LED: Lite-On LTST-S270KRKT, side-looking, on the PCB top beside the receptacle (D1 in
// electronics/usbc-pcb), lens facing the wall. Datasheet DS22-2000-210 rev G: body 1.65 long,
// 1.15 deep with the lens, 0.60 tall; emitter about 0.30 above the PCB.
usbc_led_x = 7.5;            // Z offset from the receptacle axis (+Z)
usbc_led = [1.65,0.60,1.15]; // along Z, height above the PCB, depth along X
usbc_led_set = 0.10;         // lens behind the PCB front edge
usbc_led_h = 0.30;           // emitter above the PCB top
usbc_led_hole_d = 1.6;       // through the 1.80 mm panel; filled with clear epoxy

// --- LiPo pouch, fixed (MEASURE the bought cell) -----------------------------------------
pouch_t = 6.0;               // 602050 listing: 6 x 20 x 50 mm, 600 mAh claimed (not verified)
pouch_l = 50.0;              // along Y; cells up to 54 mm long, protection board included, fit
pouch_w = 20.0;              // along Z
pouch_clear = 0.5;           // all round, for swelling and foam tape
pouch_y0 = -33.5;

pod_cavity_x1 = groove_floor_x-floor_wall;
pod_cavity_front_corner = 2.0;
pod_cavity_rear_corner = 6.0;
lip_width = 2.8;             // gasket land added inside the axial walls along the upper facet;
                             // 3.0 until V0.24: the APEM nuts (16.2 across corners) need the room
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
// APEM ISR3SAD200 (IS series datasheet, 16/08/2024): sealed IP67 pushbutton, round curved
// actuator, NO, solder lugs, M12 x 0.75 bushing, standard Ø17.5 bezel with flat seal, 14 mm A/F
// hex nut behind the panel.
button_cutout = 13.6;        // panel cut-out diameter
button_cutout_flat = 12.9;   // across the anti-rotation flat
button_y = [33.0, 15.0, -3.0];  // A, B, C on the upper facet, 18 mm pitch (APEM matrix: 20 mm);
                             // the Ø17.5 bezels keep 0.75 mm from the fold and from the top corner radius
button_body_d = 12.0;        // M12 bushing and body behind the panel
switch_depth = 13.0;         // behind the panel, terminals included
button_head_projection = 5.0;   // actuator top above the panel
button_head_diameter = 12.0;    // actuator
button_bezel_d = 17.5;
button_bezel_h = 3.8;        // bezel and flat seal; the actuator stands 1.2 above it
button_nut_af = 14.0;        // U166 hex nut
button_nut_h = 2.5;          // MEASURE the nut supplied

// --- Joystick: steel pin stick, printed ball and disc, four C&K KSC2 sealed tact switches -
// Joystick frame (at_joy): origin on the outer cover face at the stick axis, +Z into the pod
// along the lower-facet normal, +Y up the facet toward button C, X along the bar.
// Stack from the outside in: knob, cover, sheet gasket (grips the stick), joystick plate (its
// back face is the ball seat), ball and cross disc, switches, PCB on two plate standoffs.
joy_s = 14.5;                // stick axis from the fold along the lower facet
joy_sw_r = 6.75;             // switch centres from the axis; 6.5 mm bodies need at least 6.5
joy_sw_xy = [[0,joy_sw_r],[0,-joy_sw_r],[-joy_sw_r,0],[joy_sw_r,0]];  // up (toward C), down, bar-axis pair
ksc_body = 6.5;              // KSC2 6.2 +0.3 / 0 mm
ksc_h = 3.5;                 // soft actuator top above the PCB
ksc_body_h = 2.9;
ksc_actuator_d = 2.9;
ksc_travel_max = 0.65;       // KSC221J: 0.35 +0.3/-0.1 mm to trip (KSC222J: 0.35 +/- 0.15)
joy_rest_gap = 0.05;         // disc to actuators at rest; tune with shims under the PCB
stick_d = 3.0;               // ISO 8734 steel dowel pin, through the cover and the sheet
stick_len = 12.0;            // pin length: from the disc underside into the knob
pin_bore = 2.95;             // press fit in the printed ball and disc; MEASURE and tune
ball_d = 6.0;
seat_d = 3.6;                // hole in the joystick plate; its back edge is the ball seat
disc_t = 1.2;
disc_arm_w = 5.0;            // cross arms over the actuators
disc_reach = joy_sw_r+ksc_actuator_d/2+0.8;
disc_top_clear = 1.5;        // disc top below the plate back, room to tilt
knob_d = 16.0;
knob_proud = 5.7;            // knob top above the cover face
knob_hub_d = 9.2;            // central boss on the knob underside: push stop
knob_gap = 0.9;              // knob hub to cover: push stop
knob_edge_gap = 1.15;        // knob rim to cover: tilt stop
knob_bore = 4.0;             // depth of the pin hole in the knob
knob_insert_d = 3.2;         // radial M2 heat-set insert for an M2 x 4 grub screw; MEASURE
knob_insert_len = 4.0;
knob_insert_z = -3.2;         // centred between the rim underside and the engraved top
cover_stick_hole = 5.6;
sheet_stick_hole = 2.4;      // stretched over the stick
plate_sheet_pocket_d = 10.0; // room for the sheet to follow the stick in the plate front
plate_sheet_pocket_depth = 0.6;
joy_pcb_t = 1.6;
joy_pcb_rear = 1.0;          // solder joints, vias and low rear parts over the whole PCB
joy_pcb_rear_tall = 3.0;     // SMB TVS (2.45 max), 1812 PTC and the wire pads: only above joy_rear_tall_y0,
joy_rear_tall_y0 = 0.5;      // or outside joy_rear_tall_x0, so the zone stays clear of a USB-C plug in the XIAO
joy_screw_head = [3.5,1.1];  // M2x8 button head (ISO 7380 style) on the PCB rear: diameter, height;
                             // a pan head (k 1.6) hits a 12 mm wide USB-C overmold with the cover off
// PCB outline (joystick frame, mm): the rectangle |X| <= joy_pcb_hx, |Y| <= joy_pcb_hy less a
// notch of radius joy_pcb_notch_r round each lower cover-screw boss (their ends reach 0.25 mm
// past the PCB front). electronics/joystick-pcb/gen_pcb.py uses the same numbers.
joy_pcb_hx = 10.3;
joy_pcb_hy = 11.2;
joy_pcb_notch_r = 3.3;       // boss radius 3.0 + 0.3
joy_rear_tall_x0 = 6.3;      // the tall rear zone also covers |X| >= this (outside the USB-C plug)
// KSC2 land pattern turned 90 degrees: pad centres from the switch centre, and pad size.
ksc_pad_xy = [[-2,-3],[2,-3],[-2,3],[2,3]];
ksc_pad_size = [1.2,2.1];
joy_plate_t = 1.5;
joy_plate_u0 = 1.0;          // plate starts this far below the fold
joy_standoffs = [[-6.0,6.4],[6.0,-6.4]];  // clear of the KSC2 pads and the lower cover bosses
joy_standoff_d = 3.6;        // M2 thread-forming screw for plastics; MEASURE pilot for chosen screw
joy_standoff_pilot = 1.6;

// --- Cover fasteners: M2 ISO 10642 countersunk into M2 heat-set inserts ----------------
// [facet, u]; each position has a screw near both axial walls. Lower-facet screws also pass
// through the joystick plate, so they are longer and their bosses start behind the plate.
cover_screws = [[0,40.5],[0,24.0],[0,6.0],[1,3.5],[1,25.3]];
cover_screw_z = [pod_z0+3.25, pod_z1-3.25];
cover_screw_length = 8.0;
cover_screw_length_lower = 10.0;
cover_screw_clear_d = 2.4;
cover_csk_d = 4.4;
cover_boss_d = 6.0;
cover_boss_depth = 8.0;
cover_insert_hole_d = 3.2;   // MEASURE against insert datasheet
cover_insert_depth = 6.0;

// --- XIAO nRF52840, without headers (V0.25) -------------------------------------------
xiao_length = 21.0;          // along Y; USB-C at the -Y end
xiao_width = 17.8;           // along Z
xiao_pcb = 1.2;              // MEASURE
xiao_x = -32.5;              // PCB mid-plane; component side faces the controls (-X)
xiao_y = 10.0;               // raised so a USB-C plug clears the lower cover-screw bosses
xiao_component_h = 3.4;      // USB-C and shield height above PCB; MEASURE
xiao_rear_h = 1.0;           // solder joints and leads on the +X (rear) side; no headers
xiao_fillet = 0.3;           // solder on the edge pads, inside the rail slot, each side
xiao_pin_inset = 1.27;       // pin row centre from the long PCB edge
xiao_rail_lip = 0.8;         // how much the slot overlaps the PCB edge
xiao_rail_wall = 1.2;
xiao_clear = 0.15;

// --- Vent: in the bottom end wall, in front of the battery cap --------------------------
vent_hole_d = 3.0;           // behind an adhesive ePTFE vent; MEASURE chosen vent
vent_pad_d = 10.0;           // flat area kept free inside the bottom wall for the vent label
vent_x = -41.0;

// --- Battery cap: the rear part of the bottom end (V0.25) ------------------------------
// The pouch slides in along +Y through an opening from cap_open_x0 to the cavity rear wall.
// The housing ends at Y = cap_y over the cap; a flat gasket (gasket_gap compressed) seals the
// cap to that face. Lands: the front block (cap_front_x to cap_open_x0), the rear wall and the
// 2.5 mm side walls of the widened bottom band.
cap_y = -37.7;               // housing face over the cap; 2.8 mm below the lock hole
cap_front_x = -35.0;         // front edge of the cap
cap_open_x0 = -31.0;         // front edge of the opening; the pouch envelope starts at X = -29
cap_clear = 0.2;             // cap to housing at its front edge
cap_wide_y = -36.0;          // the bottom band is pod_width wide below this, 45 degrees up to axial_width
cap_block_x0 = cap_front_x-0.5;
cap_block_h = 1.5;           // front block above cap_y
cap_screws = [[-33.0,axial_width/2],[-19.3,axial_width/2-7],[-19.3,axial_width/2+7]];   // X, Z
cap_screw = [3.8,1.2,8.0];   // M2 x 8 ISO 10642: head diameter, head height, length
cap_screw_clear_d = 2.4;
cap_pilot_d = 1.6;           // M2 thread into PETG; MEASURE pilot for the chosen screw
cap_boss_d = 5.0;
cavity_rear_bottom_corner = 1.0;
pod_rear_bottom_corner = 2.0;

// --- Derived values and checks ---------------------------------------------------------
cap_face_x = split_gap/2;
body_face_x = -split_gap/2;
bolt_tip_x = cap_seat_x-bolt_length;
bolt_engagement = body_face_x-bolt_tip_x;
cap_grip = cap_seat_x-cap_face_x;
bore_wall_at_bolt = clamp_bolt_y-clamp_bore_max/2-clamp_bolt_d/2;
assert(bolt_tip_x >= body_face_x-insert_depth, "Bolt is longer than the insert hole");
assert(bore_wall_at_bolt >= 2.0, "Bolt hole too close to the clamp bore");

platform_wall = -platform_x-clamp_bore_max/2;          // in front of the largest bore
seat_gap = dt_c*sqrt(2);                               // remote moves this far off the platform to seat the flanks
strip_squeeze = strip_t-strip_pocket-(dt_c+seat_gap);  // strip compression with the flanks seated
lock_pocket_floor_x = platform_x+lock_pocket_depth;
lock_head_x = platform_x-lock_out;                     // outer face of the head when locked
pouch_x1 = pod_cavity_x1-0.8;                          // pouch envelope, with clearance
pouch_x0 = pouch_x1-pouch_t-2*pouch_clear;
assert(platform_wall >= 3.0, "Platform too close to the largest bore");
assert(lock_pocket_floor_x < base_back_x-3, "Lock pocket leaves no wall in front of the knob");
assert(lock_y-lock_pocket_d/2 >= base_y0+2, "Lock pocket too close to the base end");
// At the entry position (remote 'slide' lower) the upper lip sits in the gap between the rails
// and the lower lip below the lower rail.
assert(lip_y[1][0]-slide >= rail_y[0][1]+0.5 && lip_y[1][1]-slide <= rail_y[1][0]-0.5,
    "Upper lip does not pass between the rails at the entry position");
assert(lip_y[0][1]-slide <= rail_y[0][0]-0.5, "Lower lip does not clear the lower rail at the entry position");
assert(strip_squeeze > 0.1, "Anti-rattle strips do not preload the dovetail");

cover_back_x = cover_front_x+face_cover_thickness;
housing_front_x = cover_front_x+housing_front_off;
joy_p = front_point(1,joy_s);
plate_front_off = housing_front_off;                  // joystick plate front, on the sheet
plate_back_off = plate_front_off+joy_plate_t;         // seat edge for the ball
ball_z = plate_back_off+sqrt(pow(ball_d/2,2)-pow(seat_d/2,2));  // ball centre = pivot
disc_top_off = plate_back_off+disc_top_clear;
disc_bot_off = disc_top_off+disc_t;
ksc_top_off = disc_bot_off+joy_rest_gap;
joy_pcb_off = ksc_top_off+ksc_h;                      // PCB front face
joy_rear_off = joy_pcb_off+joy_pcb_t+joy_pcb_rear_tall;
joy_standoff_h = joy_pcb_off-plate_back_off;
trip_angle = atan((joy_rest_gap+ksc_travel_max)/joy_sw_r);  // worst-case tilt to trip a direction
knob_stop_angle = min(atan(knob_edge_gap/(knob_d/2)),atan(knob_gap/(knob_hub_d/2)));
pin_top_off = disc_bot_off-stick_len;
disc_tilt_room = atan(disc_top_clear/disc_reach);
xiao_pcb_x0 = xiao_x-xiao_pcb/2;
xiao_pcb_x1 = xiao_x+xiao_pcb/2;
xiao_rear_x = xiao_pcb_x1+xiao_rear_h;
xiao_component_x = xiao_pcb_x0-xiao_component_h;
xiao_z0 = axial_width/2-xiao_width/2;
wire_gap = xiao_component_x-(cover_back_x+switch_depth);
cover_screw_thread = cover_screw_length-housing_front_off;
cover_screw_thread_lower = cover_screw_length_lower-plate_back_off;
assert(xiao_rear_x <= pouch_x0, "XIAO rear joints reach the pouch envelope");
assert(cover_screw_thread <= cover_insert_depth-0.5, "Cover screw bottoms in the insert hole");
assert(cover_screw_thread_lower <= cover_insert_depth-0.5, "Lower cover screw bottoms in the insert hole");
assert(knob_stop_angle > trip_angle+1, "Knob stops the tilt before a direction switch trips");
assert(knob_gap > joy_rest_gap+ksc_travel_max, "Knob stops the push before the switches trip");
assert(disc_tilt_room > knob_stop_angle, "Disc reaches the joystick plate before the knob stop");
assert(ball_z-ball_d/2 < plate_back_off, "Ball does not reach the seat");
assert(pin_top_off <= -knob_gap-knob_bore+0.3, "Pin too short for the knob bore");
assert(knob_proud-knob_gap-knob_bore >= 0.79, "Knob top too thin over the pin");

echo(str("Base: bar ",bar_diameter," mm, bore ",clamp_bore,"; platform ",platform_wall," mm in front of the 25.4 mm bore; dovetail ",
    dt_neck,"/",dt_head," x ",dt_h," mm, rails ",rail_y,", lips ",lip_y,", slide ",slide," mm"));
echo(str("Base: remote seats ",seat_gap," mm off the platform; strip compression ",strip_squeeze,
    " mm; groove floor ",floor_wall," mm, cavity rear at X ",pod_cavity_x1));
echo(str("Lock: head ",lock_out," mm proud, pocket floor X ",lock_pocket_floor_x,", knob seat X ",base_back_x,
    ", shank in the base ",base_back_x-lock_pocket_floor_x," mm"));
echo(str("Pouch envelope X ",pouch_x0," .. ",pouch_x1,", Y ",pouch_y0," .. ",pouch_y0+pouch_l+2*pouch_clear));
echo(str("Pod Y ",pod_bottom_y," .. ",pod_top_y," (length ",pod_top_y-pod_bottom_y,"); lower end set back ",
    pod_end[0]-cover_front_x," mm"));
echo(str("Joystick axis on the cover face ",joy_p,", set back ",joy_p[0]-cover_front_x," mm"));
echo(str("Joystick: pivot ",ball_z," mm behind the face, knob top ",knob_proud+ball_z," mm above the pivot; tilt to trip <= ",
    trip_angle," deg, knob stop ",knob_stop_angle," deg, disc room ",disc_tilt_room," deg; pin top at ",pin_top_off));
echo(str("Joystick: knob travel at the top to trip ",(knob_proud+ball_z)*tan(trip_angle)," mm; PCB front at ",joy_pcb_off,
    ", rear at ",joy_rear_off," mm behind the face; standoffs ",joy_standoff_h," mm"));
echo(str("Joystick PCB notch centres (frame X,Y): ",joy_boss_xy()));
echo(str("Wide pod: ",pod_width," mm with ",pod_wall," mm walls (cavity ",pod_in1-pod_in0," mm) for X < ",pod_wide_x));
echo(str("Bar axis to button C face ",-cover_front_x," mm perpendicular, ",norm([cover_front_x,button_y[2]])," mm direct"));
echo(str("Clamp bolts M4x",bolt_length,"; cap grip ",cap_grip," mm, insert engagement ",bolt_engagement,
    " mm, wall to bore ",bore_wall_at_bolt," mm"));
echo(str("Cover screws M2x",cover_screw_length,", thread into insert ",cover_screw_thread," mm; lower M2x",
    cover_screw_length_lower,", ",cover_screw_thread_lower," mm"));
echo(str("Wiring gap button rear to XIAO component side (mm): ",wire_gap));
echo(str("XIAO rear joint zone to pouch envelope (mm): ",pouch_x0-xiao_rear_x,"; to the cell: ",pouch_x0+pouch_clear-xiao_rear_x));
led_hole_to_pocket = usbc_led_x-usbc_led_hole_d/2-usbc_pocket[0]/2;
led_hole_to_plug = usbc_led_x-usbc_led_hole_d/2-usbc_plug[0]/2;
led_pcb_side = usbc_pcb[0]/2-(axial_width/2-case_wall);
echo(str("Charge LED window: ",led_hole_to_pocket," mm beside the gasket pocket, ",led_hole_to_plug,
    " mm beside the plug overmold; USB-C PCB edge to the axial wall ",-led_pcb_side," mm"));
assert(led_hole_to_pocket >= 0.8, "LED window too close to the gasket pocket");
assert(led_pcb_side <= -0.5, "USB-C PCB too wide for the cavity");
cap_lock_margin = (lock_y-lock_hole_d/2)-cap_y;
cap_land_side = (pod_width-axial_width)/2+case_wall;
echo(str("Battery cap: ",cap_t," mm thick; housing face at Y ",cap_y,", ",cap_lock_margin," mm below the lock hole; ",
    "lands front ",cap_open_x0-cap_front_x-cap_clear,", rear ",rear_x-pod_cavity_x1,", sides ",cap_land_side," mm; opening X ",
    cap_open_x0," .. ",pod_cavity_x1,"; screw thread in the housing ",cap_screw[2]-cap_t-gasket_gap," mm"));
assert(cap_lock_margin >= 2.5, "Battery cap face too close to the lock hole");
assert(cap_open_x0 <= pouch_x0-1.5, "Battery cap opening too short for the pouch");
assert(cap_y < cap_wide_y, "Battery cap face above the widened band");

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
        rb = inset==0 ? pod_rear_bottom_corner : (inset==case_wall ? cavity_rear_bottom_corner : rr);
        translate([x_rear-rb,pod_bottom_y+inset+rb]) circle(r=rb);
    }
}

module pod_outline_2d() { pod_shape_2d(0,pod_front_corner,pod_max_x,pod_rear_corner); }
module cavity_profile_2d() { pod_shape_2d(case_wall,pod_cavity_front_corner,pod_cavity_x1,pod_cavity_rear_corner); }

// The remote: the pod outline cut flat at its rear face. No ring and no shoulders.
module outer_silhouette_2d() {
    intersection() { pod_outline_2d(); x_band_2d(-100,rear_x); }
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

// Base, front half: the ring in front of the split, cut flat at the platform, plus the
// platform block that runs past the ring to base_y0 and base_y1.
module base_front_2d() {
    difference() {
        intersection() {
            union() {
                circle(d=clamp_outer);
                translate([platform_x,base_y0]) square([base_back_x-platform_x,base_y1-base_y0]);
            }
            x_band_2d(platform_x,body_face_x);
        }
        circle(d=clamp_bore);
    }
}

module cap_profile_2d() {
    difference() {
        intersection() { circle(d=clamp_outer); x_band_2d(cap_face_x,100); }
        circle(d=clamp_bore);
    }
}

// Dovetail section in the XZ plane, drawn as 2D (x, z): neck on the platform, head toward -X.
// 'grow' offsets every face (the groove is the rail grown by dt_c); 'into' extends the neck
// past the platform (+X), to join the rail to the base or to open the groove through the
// remote's rear face.
module dovetail_2d(grow=0,into=0) {
    zc = axial_width/2;
    offset(delta=grow) polygon([
        [platform_x+into,zc-dt_neck/2],[platform_x,zc-dt_neck/2],[platform_x-dt_h,zc-dt_head/2],
        [platform_x-dt_h,zc+dt_head/2],[platform_x,zc+dt_neck/2],[platform_x+into,zc+dt_neck/2]]);
}

// Extrude a 2D (x, z) section along Y from y0 to y1.
module along_y(y0,y1) {
    translate([0,y0,0]) rotate([-90,0,0]) linear_extrude(height=y1-y0) mirror([0,1]) children();
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

// Joystick frame: along() maps local X to global -Z and local Y to -fold_d (up the facet).
module at_joy(off=0) {
    along(joy_p+off*fold_n,fold_n,axial_width/2) children();
}

module at_switches(off=0) {
    at_joy(off) for (k=joy_sw_xy) translate([k[0],k[1],0]) children();
}

// Extrusion over every Z the parts can reach, for cutting with 2D bands.
module full_z() {
    translate([0,0,pod_z0-5]) linear_extrude(height=pod_width+10) children();
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
    // run 8 mm into the housing. Lower-facet bosses start behind the joystick plate, which they
    // clamp against the sheet. The end positions are joined to the nearest end wall.
    boss_end = cover_back_off+gasket_gap+cover_boss_depth;
    for (i=[0:len(cover_screws)-1], z=cover_screw_z) {
        s = cover_screws[i];
        p = front_point(s[0],s[1]);
        a = front_normal(s[0]);
        b0 = boss_start_off(s[0]);
        join = i==0 ? [0,6] : (i==len(cover_screws)-1 ? [0,-6] : [0,0]);
        // The joined copy keeps the V0.20 depth behind it, but never starts in front of b0
        // measured from the facet, so the lower end boss stays clear of the joystick plate.
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
        full_z() intersection() {
            front_band_2d(cover_back_off,housing_front_off+lip_depth);
            translate([-100,fold_corner(housing_front_off+lip_depth)[1]]) square([200,100]);
        }
        union() {
            translate([-100,-100,pod_in0-0.1]) cube([200,200,lip_width+0.1]);
            translate([-100,-100,pod_in1-lip_width]) cube([200,200,lip_width+0.1]);
        }
    }
}

module vent_hole() {
    translate([vent_x,pod_bottom_y-0.1,axial_width/2]) rotate([-90,0,0]) cylinder(d=vent_hole_d,h=case_wall+0.2);
}

// Points on an X-axis line at (y, z), with local +Z pointing to -X (out of the remote's rear,
// or into the base's platform from the remote side).
module at_x_minus(x,y,z) { translate([x,y,z]) rotate([0,-90,0]) children(); }

// Interrupted dovetail groove in the remote's rear face, in the remote frame at the stop.
// The dovetail runs the whole groove length; where there is no lip, the opening is as wide as
// the rail head, so the rails can be pressed in there.
module groove_cut() {
    zc = axial_width/2;
    along_y(groove_y0,groove_y1) dovetail_2d(dt_c,2);
    open_y = [[groove_y0,lip_y[0][0]],[lip_y[0][1],lip_y[1][0]],[lip_y[1][1],groove_y1]];
    for (r=open_y) along_y(r[0],r[1])
        translate([groove_floor_x,zc-dt_head/2-dt_c]) square([rear_x+1-groove_floor_x,dt_head+2*dt_c]);
}

module lock_hole() {
    lock_hole_bottom_x = lock_head_x-0.4;
    at_x_minus(rear_x+0.1,lock_y,axial_width/2) cylinder(d=lock_hole_d,h=rear_x+0.1-lock_hole_bottom_x);
}

// Rounded rectangle centred on the origin, w along Z (local X here) and h along Y.
module rrect_2d(w,h,r) { offset(r=r) square([w-2*r,h-2*r],center=true); }

// USB-C panel features cut into the rear wall, following GCT's recommended panel.
// Local frame at the outer face on the shell axis: +Z points into the remote (-X global).
module at_usbc(x=rear_x) { translate([x,usbc_y,axial_width/2]) rotate([0,-90,0]) children(); }   // local X = Z, local Y = Y
// Rib under the receptacle PCB, from the rear wall into the cavity, across its full width so
// its underside bridges between the axial walls when the housing prints.
module usbc_rib() {
    pcb_bottom = usbc_y-usbc_axis_h-usbc_pcb[2];
    x_end = rear_x-usbc_pcb_edge-max([for (h=usbc_pcb_holes) h[1]])-2.0;
    translate([x_end,pcb_bottom-usbc_rib_h,case_wall-0.1])
        cube([pod_cavity_x1+0.5-x_end,usbc_rib_h,axial_width-2*case_wall+0.2]);
}

module usbc_pilots() {
    for (h=usbc_pcb_holes) at_usbc() translate([h[0],-usbc_axis_h-usbc_pcb[2]+0.01,usbc_pcb_edge+h[1]])
        rotate([90,0,0]) cylinder(d=usbc_pilot_d,h=usbc_screw[2]-usbc_pcb[2]+0.5,$fn=24);
}

module usbc_cuts() {
    clear_y0 = -usbc_axis_h-usbc_pcb[2]-1.5;      // below the PCB, for its parts
    clear_y1 = usbc_body[1]-usbc_axis_h+0.4;
    at_usbc(rear_x+0.1) {
        linear_extrude(height=usbc_panel_t+0.2) rrect_2d(usbc_slot[0],usbc_slot[1],usbc_slot_r);
        translate([0,0,0.1+usbc_panel_t-usbc_pocket_depth])
            linear_extrude(height=usbc_pocket_depth+0.01) rrect_2d(usbc_pocket[0],usbc_pocket[1],usbc_pocket_r);
        translate([0,0,0.1+usbc_panel_t]) linear_extrude(height=10)
            translate([-usbc_pcb[0]/2-0.5,clear_y0]) square([usbc_pcb[0]+1,clear_y1-clear_y0]);
        // charge LED window, on the emitter axis
        translate([usbc_led_x,-usbc_axis_h+usbc_led_h,0]) cylinder(d=usbc_led_hole_d,h=usbc_panel_t+0.3,$fn=24);
    }
}

module xiao_rail() {
    // Slot holding one long PCB edge with room for solder on the edge pads; the board slides
    // in along +Y and stops against the closed +Y end.
    slot_x0 = xiao_pcb_x0-xiao_clear-xiao_fillet;
    slot_x1 = xiao_pcb_x1+xiao_clear+xiao_fillet;
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

// Battery cap land: a block across the cavity in front of the opening, with the front screw
// boss. Its -X face bridges the cavity width when the housing prints, like the rear wall.
module cap_land() {
    floor_y = pod_bottom_y+case_wall;
    translate([cap_block_x0,floor_y-0.1,case_wall-0.1])
        cube([cap_open_x0-cap_block_x0,cap_y+cap_block_h-floor_y+0.1,axial_width-2*case_wall+0.2]);
    s = cap_screws[0];
    translate([s[0],cap_y-0.1,s[1]]) rotate([-90,0,0]) cylinder(d=cap_boss_d,h=cap_screw[2]-cap_t-gasket_gap+1.6,$fn=32);
}

// Everything below cap_y behind cap_front_x belongs to the cap.
module cap_cut() {
    translate([cap_front_x,pod_bottom_y-5,pod_z0-1]) cube([rear_x+5-cap_front_x,cap_y-pod_bottom_y+5,pod_width+2]);
}

module cap_pilots() {
    for (s=cap_screws) translate([s[0],cap_y-0.1,s[1]]) rotate([-90,0,0])
        cylinder(d=cap_pilot_d,h=cap_screw[2]-cap_t-gasket_gap+0.6,$fn=24);
}

// The cap: the pod below cap_y-gasket_gap, from cap_front_x+cap_clear back. Countersunk M2
// screws from the bottom face.
cap_t = cap_y-gasket_gap-pod_bottom_y;
module battery_cap() {
    difference() {
        intersection() {
            outer_solid();
            translate([cap_front_x+cap_clear,pod_bottom_y-1,pod_z0-1])
                cube([rear_x+5-cap_front_x,cap_y-gasket_gap-pod_bottom_y+1,pod_width+2]);
        }
        for (s=cap_screws) translate([s[0],pod_bottom_y-0.01,s[1]]) rotate([-90,0,0]) {
            cylinder(d=cap_screw_clear_d,h=cap_t+0.1,$fn=24);
            cylinder(d1=cap_screw[0]+0.2,d2=cap_screw_clear_d,h=(cap_screw[0]+0.2-cap_screw_clear_d)/2,$fn=24);
        }
    }
}

// Flat gasket between the cap and the housing face at cap_y: the cap outline less the
// opening and the screw holes.
module cap_gasket() {
    difference() {
        intersection() {
            outer_solid();
            translate([cap_front_x+cap_clear,cap_y-gasket_gap,pod_z0-1])
                cube([rear_x+5-cap_front_x,gasket_gap,pod_width+2]);
        }
        translate([cap_open_x0,cap_y-1,case_wall]) cube([pod_cavity_x1-cap_open_x0,2,axial_width-2*case_wall]);
        for (s=cap_screws) translate([s[0],cap_y-1,s[1]]) rotate([-90,0,0]) cylinder(d=cap_screw_clear_d,h=2,$fn=24);
    }
}

// Housing material before the front band is removed: shell plus all land features.
module housing_body() {
    difference() {
        outer_solid();
        cavity_solid();
    }
    intersection() {
        union() { cover_bosses(); gasket_lip(); xiao_rails(); usbc_rib(); cap_land(); }
        outer_solid();
    }
}

// Rear pod axial_width wide; the control end (X < pod_wide_x) pod_width wide, with
// a 45-degree chamfer between them. Both outlines are convex, so a hull of the wide and the
// narrow slice gives the chamfer. The cavity steps the same way.
module outer_solid() {
    linear_extrude(height=axial_width) outer_silhouette_2d();
    // Bottom band, pod_width wide, for the battery cap gasket land.
    hull() {
        translate([0,0,pod_z0]) linear_extrude(height=pod_width)
            intersection() { outer_silhouette_2d(); translate([-100,-100]) square([200,100+cap_wide_y]); }
        linear_extrude(height=axial_width)
            intersection() { outer_silhouette_2d(); translate([-100,-100]) square([200,100+cap_wide_y+pod_step]); }
    }
    hull() {
        translate([0,0,pod_z0]) linear_extrude(height=pod_width)
            intersection() { outer_silhouette_2d(); x_band_2d(-100,pod_wide_x-pod_step); }
        linear_extrude(height=axial_width)
            intersection() { outer_silhouette_2d(); x_band_2d(-100,pod_wide_x); }
    }
}

module cavity_solid() {
    step_in = (axial_width-2*case_wall-(pod_in1-pod_in0))/2;   // negative: the wide cavity is larger
    translate([0,0,case_wall]) linear_extrude(height=axial_width-2*case_wall) cavity_profile_2d();
    hull() {
        translate([0,0,pod_in0]) linear_extrude(height=pod_in1-pod_in0)
            intersection() { cavity_profile_2d(); x_band_2d(-100,pod_wide_x+step_in); }
        translate([0,0,case_wall]) linear_extrude(height=axial_width-2*case_wall)
            intersection() { cavity_profile_2d(); x_band_2d(-100,pod_wide_x); }
    }
}

module housing() {
    difference() {
        housing_body();
        full_z() front_band_2d(-10,housing_front_off);
        cover_insert_holes();
        vent_hole();
        groove_cut();
        lock_hole();
        usbc_cuts();
        usbc_pilots();
        cap_cut();
        cap_pilots();
    }
}

// ======================================================================================
// Base: clamp ring, platform, rails, lock
// ======================================================================================

module rails() {
    for (r=rail_y) along_y(r[0],r[1]) dovetail_2d(0,0.5);
}

// Frame on the back of the platform block at the lock axis: local +Z points along +X (out of
// the block), local X along global -Z.
module at_lock_back() { translate([base_back_x,lock_y,axial_width/2]) rotate([0,90,0]) children(); }

module lock_cuts() {
    zc = axial_width/2;
    at_x_minus(lock_pocket_floor_x,lock_y,zc) cylinder(d=lock_pocket_d,h=lock_pocket_depth+0.1);
    at_x_minus(base_back_x+lock_boss_h+0.1,lock_y,zc)
        cylinder(d=lock_shank_hole,h=base_back_x+lock_boss_h+0.2-lock_pocket_floor_x,$fn=24);
    // L-slots in the boss: circumferential at the pin height from the locked angle (0, 180) to
    // the release angle (90, 270), then axial to the top of the boss.
    at_lock_back() for (a=[0,180]) rotate(a) {
        da = asin(lock_slot_w/2/lock_slot_r)+3;   // past the pin at both ends
        translate([0,0,lock_pin_z-lock_slot_w/2]) rotate(-da) rotate_extrude(angle=90+2*da)
            translate([lock_slot_r,0]) square([lock_boss_d/2-lock_slot_r+1,lock_slot_w]);
        rotate(90) translate([lock_slot_r,-lock_slot_w/2,lock_pin_z-lock_slot_w/2])
            cube([lock_boss_d/2-lock_slot_r+1,lock_slot_w,lock_boss_h+1]);
    }
}

module lock_boss() {
    at_lock_back() translate([0,0,-0.01]) cylinder(d=lock_boss_d,h=lock_boss_h+0.01);
}

module strip_pockets() {
    for (z=[strip_z, [axial_width-strip_z[1],axial_width-strip_z[0]]])
        translate([platform_x-0.1,strip_y[0],z[0]]) cube([strip_pocket+0.1,strip_y[1]-strip_y[0],z[1]-z[0]]);
}

module base_front() {
    difference() {
        union() {
            linear_extrude(height=axial_width) base_front_2d();
            rails();
            lock_boss();
        }
        body_bolt_cuts();
        lock_cuts();
        strip_pockets();
    }
}

module base_cap() {
    difference() {
        linear_extrude(height=axial_width) cap_profile_2d();
        cap_bolt_cuts();
    }
}

// Lock knob in its own frame: rim at z = 0 on the platform block, top at lock_knob_h. A cup over
// the boss; an M3 heat-set insert from inside the cup, a nut on top; two radial pin holes.
module lock_knob_shape() {
    difference() {
        cylinder(d=lock_knob_d,h=lock_knob_h);
        translate([0,0,-0.1]) cylinder(d=lock_bore_d,h=lock_bore_h+0.1);
        translate([0,0,-0.1]) cylinder(d=4.0,h=lock_knob_h+0.2,$fn=24);   // M3 insert hole; MEASURE
        for (a=[0,180]) rotate(a) translate([lock_pin_r_in,0,lock_pin_z]) rotate([0,90,0])
            cylinder(d=lock_pin_d-0.05,h=lock_knob_d,$fn=16);                 // press fit; MEASURE
        for (a=[0:30:330]) rotate(a) translate([lock_knob_d/2+0.6,0,-0.1]) cylinder(d=2,h=lock_knob_h+0.2,$fn=12);
    }
}

module lock_pins() {
    for (a=[0,180]) rotate(a) translate([lock_pin_r_in,0,lock_pin_z]) rotate([0,90,0]) cylinder(d=lock_pin_d,h=lock_pin_len,$fn=16);
}

// Lock parts in place: head proud of the platform (locked) or flush (pulled, 'out' = 0).
module lock_parts(out=lock_out) {
    zc = axial_width/2;
    dx = lock_out-out;   // how far the knob is pulled
    color([0.25,0.25,0.27]) at_x_minus(platform_x+lock_head_h-out,lock_y,zc) {
        cylinder(d=lock_head_d,h=lock_head_h);
        translate([0,0,-lock_screw_length]) cylinder(d=3.0,h=lock_screw_length,$fn=24);
    }
    color([0.8,0.8,0.8,0.6]) at_x_minus(lock_pocket_floor_x,lock_y,zc)
        difference() { cylinder(d=5.0,h=lock_pocket_depth-lock_head_h+out,$fn=24); translate([0,0,-1]) cylinder(d=3.4,h=20,$fn=24); }
    // Pulled, the knob has been turned 90 degrees to the release position first.
    translate([base_back_x+dx,lock_y,zc]) rotate([0,90,0]) rotate(out<lock_out ? 90 : 0) {
        color([0.85,0.45,0.15]) lock_knob_shape();
        color([0.7,0.7,0.72]) lock_pins();
    }
}

module strips() {
    color([0.15,0.15,0.15]) for (z=[strip_z, [axial_width-strip_z[1],axial_width-strip_z[0]]])
        translate([platform_x+strip_pocket-strip_t,strip_y[0],z[0]]) cube([strip_t,strip_y[1]-strip_y[0],z[1]-z[0]]);
}

// Upper facet: land on the walls, the lip and the screw bosses. Lower facet: a full sheet that
// grips the stick and seals the joystick opening; the joystick plate presses it on the cover.
module gasket() {
    difference() {
        union() {
            intersection() {
                housing_body();
                full_z() front_band_2d(cover_back_off,housing_front_off);
            }
            // Up to the print_gasket split plane, so the sheet joins the upper land without a slot.
            translate([0,0,pod_z0]) linear_extrude(height=pod_width) intersection() {
                pod_outline_2d();
                front_band_2d(cover_back_off,housing_front_off);
                translate([-100,fold_corner(cover_back_off)[1]+0.3-200]) square([200,200]);
            }
        }
        at_cover_screws() translate([0,0,-1]) cylinder(d=cover_screw_clear_d,h=10);
        at_joy(cover_back_off-0.1) cylinder(d=sheet_stick_hole,h=gasket_gap+0.2);
    }
}

// Joystick plate: fills the lower-facet cavity behind the sheet, clamped by the four lower
// cover screws against their bosses. The back edge of its centre hole is the ball seat; a
// shallow pocket in its front lets the sheet follow the stick. The joystick PCB screws to its
// two standoffs.
module joy_plate() {
    difference() {
        union() {
            translate([0,0,pod_in0+0.15]) linear_extrude(height=pod_in1-pod_in0-0.3) intersection() {
                front_band_2d(plate_front_off,plate_back_off);
                offset(delta=-0.15) cavity_profile_2d();
                lower_side_2d(joy_plate_u0);
            }
            at_joy() for (p=joy_standoffs) translate([p[0],p[1],plate_back_off-0.01])
                cylinder(d=joy_standoff_d,h=joy_standoff_h+0.01);
        }
        // Seat hole: its back edge holds the ball; it opens toward the front so the stick can
        // tilt to the knob stop.
        at_joy(plate_front_off-0.1) {
            cylinder(d=seat_d,h=joy_plate_t+0.2);
            cylinder(d=plate_sheet_pocket_d,h=plate_sheet_pocket_depth+0.1);
            cylinder(d1=seat_d+1.2,d2=seat_d,h=joy_plate_t+0.1);
        }
        at_joy() for (p=joy_standoffs) translate([p[0],p[1],plate_front_off+0.3])
            cylinder(d=joy_standoff_pilot,h=joy_plate_t+joy_standoff_h,$fn=24);
        for (s=cover_screws, z=cover_screw_z) if (s[0]==1)
            along(front_point(s[0],s[1]),front_normal(s[0]),z) cylinder(d=cover_screw_clear_d,h=10);
    }
}

// Ball and cross disc, printed as one part, in the joystick frame at rest. The ball is cut
// flat at the disc's underside; the disc arms rest on the four switch actuators. The steel
// pin is pressed in from the disc side, flush with the underside.
module ball_disc_shape() {
    difference() {
        union() {
            intersection() {
                translate([0,0,ball_z]) sphere(d=ball_d,$fn=64);
                translate([0,0,-50]) cylinder(d=ball_d+1,h=50+disc_bot_off);
            }
            translate([0,0,disc_top_off]) linear_extrude(height=disc_t) {
                square([2*disc_reach,disc_arm_w],center=true);
                square([disc_arm_w,2*disc_reach],center=true);
                circle(d=ball_d+1.0);
            }
        }
        translate([0,0,-1]) cylinder(d=pin_bore,h=disc_bot_off+2,$fn=32);
    }
}

module pin_shape() {
    translate([0,0,pin_top_off]) cylinder(d=stick_d,h=stick_len,$fn=32);
}

module stick_shape() { ball_disc_shape(); pin_shape(); }

// Knob in the joystick frame: Ø knob_d, knob_proud above the cover. A central hub on the
// underside stops the push knob_gap above the cover; the rim stops the tilt. A radial M2 grub
// screw in a heat-set insert clamps the pin, so the knob comes off for service. An engraved
// cross on the top shows the four directions.
module knob_shape() {
    difference() {
        union() {
            hull() {
                translate([0,0,-knob_proud]) cylinder(d=knob_d-2,h=0.01);
                translate([0,0,-knob_proud+1.0]) cylinder(d=knob_d,h=knob_proud-1.0-knob_edge_gap);
            }
            translate([0,0,-knob_edge_gap-0.01]) cylinder(d=knob_hub_d,h=knob_edge_gap-knob_gap+0.01);
        }
        translate([0,0,-knob_gap-knob_bore]) cylinder(d=stick_d+0.1,h=knob_bore+0.1,$fn=32);
        translate([0,0,knob_insert_z]) rotate([0,90,0]) {
            translate([0,0,knob_d/2-knob_insert_len]) cylinder(d=knob_insert_d,h=knob_insert_len+1,$fn=24);
            cylinder(d=2.0,h=knob_d,$fn=24);
        }
        translate([0,0,-knob_proud-0.01]) linear_extrude(height=0.41) {
            square([knob_d-5,1.0],center=true);
            square([1.0,knob_d-5],center=true);
        }
    }
}

module stick() { at_joy() stick_shape(); }
module ball_disc() { at_joy() ball_disc_shape(); }
module knob() { at_joy() knob_shape(); }

// APEM panel cut-out: Ø13.6 with an anti-rotation flat 12.9 across. The flat is at the top
// (+Z, the print direction of the cover), where it prints as a short bridge.
// Local frame of along(): local X is global -Z here.
module button_cut(h) {
    r = button_cutout/2;
    linear_extrude(height=h) intersection() {
        circle(d=button_cutout);
        translate([-(button_cutout_flat-r),-r-1]) square([button_cutout_flat+1,2*r+2]);
    }
}

module face_cover() {
    difference() {
        translate([0,0,pod_z0]) linear_extrude(height=pod_width) cover_profile_2d();
        at_buttons(-0.1) button_cut(face_cover_thickness+0.5);
        at_joy(-0.1) cylinder(d=cover_stick_hole,h=face_cover_thickness+0.5);
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
    // Solder joints and leads on the rear (+X), between the rail lips; the slot keeps
    // xiao_fillet for solder on the edge pads under the lips.
    color([0.85,0.7,0.2,0.5])
        translate([xiao_pcb_x1,xiao_y-xiao_length/2,xiao_z0+xiao_rail_lip+xiao_clear])
            cube([xiao_rear_h,xiao_length,xiao_width-2*(xiao_rail_lip+xiao_clear)]);
}

// USB-C plug used for programming with the cover off.
module usb_plug_envelope() {
    translate([xiao_pcb_x0-3.2/2-3.25,xiao_y-xiao_length/2-1.2-25,axial_width/2-6]) cube([6.5,25,12]);
}

module vent_label_envelope() {
    translate([vent_x,pod_bottom_y+case_wall,axial_width/2]) rotate([-90,0,0]) cylinder(d=vent_pad_d,h=0.3);
}

// LiPo pouch with its clearance; thickness along X, length along Y, width along the bar.
module pouch_envelope() {
    translate([pouch_x0,pouch_y0,axial_width/2-pouch_w/2-pouch_clear])
        cube([pouch_x1-pouch_x0,pouch_l+2*pouch_clear,pouch_w+2*pouch_clear]);
}

// USB-C receptacle, compressed gasket, charging PCB and its screws, in place.
module usbc_envelope() {
    nose_back = usbc_panel_t-usbc_pocket_depth+usbc_gasket_t-usbc_squeeze;  // from the outer face
    at_usbc() {
        color([0.75,0.75,0.78]) translate([0,0,nose_back-usbc_nose[2]])
            linear_extrude(height=usbc_nose[2]) rrect_2d(usbc_nose[0],usbc_nose[1],1.5);   // rounded shell ends
        color([0.15,0.15,0.15]) translate([0,0,usbc_panel_t-usbc_pocket_depth])
            linear_extrude(height=nose_back-(usbc_panel_t-usbc_pocket_depth))
                difference() { rrect_2d(usbc_gasket[0],usbc_gasket[1],usbc_gasket_r); rrect_2d(usbc_nose[0],usbc_nose[1],1.5); }
        color([0.2,0.2,0.2]) translate([-usbc_body[0]/2,-usbc_axis_h,nose_back])
            cube([usbc_body[0],usbc_body[1],usbc_body[2]-usbc_nose[2]]);
        color([0.15,0.48,0.32]) translate([-usbc_pcb[0]/2,-usbc_axis_h-usbc_pcb[2],usbc_pcb_edge])
            cube([usbc_pcb[0],usbc_pcb[2],usbc_pcb[1]]);
        // resistors, wire pads and wires on the top, behind the receptacle
        color([0.3,0.3,0.3]) translate([-3.5,-usbc_axis_h,usbc_pcb_edge+usbc_body[2]-1.70])
            cube([7.0,1.5,usbc_pcb[1]-(usbc_body[2]-1.70)]);
        // charge LED (D1), its resistor, wire pad and wire, on the top beside the receptacle
        color([0.85,0.15,0.1]) translate([usbc_led_x-usbc_led[0]/2,-usbc_axis_h,usbc_pcb_edge+usbc_led_set])
            cube([usbc_led[0],usbc_led[1],usbc_led[2]]);
        color([0.3,0.3,0.3]) translate([usbc_led_x-1.55,-usbc_axis_h,usbc_pcb_edge+usbc_led_set+usbc_led[2]+0.1])
            cube([usbc_pcb[0]/2-usbc_led_x+1.55,1.5,usbc_pcb[1]-usbc_led_set-usbc_led[2]-0.1]);
        // M2 screw heads
        color([0.25,0.25,0.27]) for (h=usbc_pcb_holes) translate([h[0],-usbc_axis_h,usbc_pcb_edge+h[1]])
            rotate([-90,0,0]) cylinder(d=usbc_screw[0],h=usbc_screw[1],$fn=24);
    }
}

// Cable plug in the receptacle (remote off the base).
module usbc_plug_envelope() {
    translate([rear_x,usbc_y-usbc_plug[1]/2,axial_width/2-usbc_plug[0]/2]) cube([usbc_plug[2],usbc_plug[1],usbc_plug[0]]);
}

module controls_and_board() {
    color([0.85,0.55,0.20]) at_buttons(cover_back_off) cylinder(d=button_body_d,h=switch_depth);
    button_nuts();
    joy_envelope();
    xiao_envelope();
    color([0.75,0.2,0.2]) pouch_envelope();
    usbc_envelope();
}

// Hex nuts behind the cover, flats facing the axial walls.
module button_nuts() {
    color([0.6,0.6,0.62]) at_buttons(cover_back_off) rotate(30) cylinder(d=button_nut_af/cos(30),h=button_nut_h,$fn=6);
}

module control_heads() {
    at_buttons() {
        color([0.30,0.36,0.39]) translate([0,0,-button_bezel_h])
            difference() { cylinder(d=button_bezel_d,h=button_bezel_h); translate([0,0,-0.1]) cylinder(d=button_head_diameter+0.6,h=button_bezel_h+0.2); }
        color([0.16,0.21,0.24]) translate([0,0,-button_head_projection]) {
            cylinder(d=button_head_diameter,h=button_head_projection+face_cover_thickness);
        }
    }
    color([0.14,0.18,0.20]) knob();
}

// Lower cover-screw axes in the joystick frame.
function joy_boss_xy() = [for (s=cover_screws, z=cover_screw_z) if (s[0]==1) [axial_width/2-z, joy_s-s[1]]];

module joy_pcb_2d() {
    difference() {
        square([2*joy_pcb_hx,2*joy_pcb_hy],center=true);
        for (p=joy_boss_xy()) translate(p) circle(r=joy_pcb_notch_r);
    }
}

// Joystick PCB with the four switches facing the cover, plus solder and wire space behind it.
module joy_envelope() {
    at_joy() {
        color([0.75,0.75,0.72]) for (k=joy_sw_xy) translate([k[0],k[1],0]) {
            translate([-ksc_body/2,-ksc_body/2,joy_pcb_off-ksc_body_h]) cube([ksc_body,ksc_body,ksc_body_h]);
            translate([0,0,ksc_top_off]) cylinder(d=ksc_actuator_d,h=ksc_h-ksc_body_h+0.01);
            for (q=ksc_pad_xy) translate([q[0]-ksc_pad_size[0]/2,q[1]-ksc_pad_size[1]/2,joy_pcb_off-0.3])
                cube([ksc_pad_size[0],ksc_pad_size[1],0.3]);
        }
        color([0.15,0.48,0.32]) translate([0,0,joy_pcb_off]) linear_extrude(height=joy_pcb_t) joy_pcb_2d();
        color([0.35,0.35,0.35,0.6]) translate([0,0,joy_pcb_off+joy_pcb_t]) {
            linear_extrude(height=joy_pcb_rear) offset(delta=-0.5) joy_pcb_2d();
            linear_extrude(height=joy_pcb_rear_tall) intersection() {
                offset(delta=-0.5) joy_pcb_2d();
                union() {
                    translate([-50,joy_rear_tall_y0]) square(100);
                    for (m=[0,1]) mirror([m,0]) translate([joy_rear_tall_x0,-50]) square(100);
                }
            }
            for (p=joy_standoffs) translate(p) cylinder(d=joy_screw_head[0],h=joy_screw_head[1]);
        }
    }
}

// ======================================================================================
// Views
// ======================================================================================

module bar_ghost() {
    %color([0.5,0.5,0.5,0.35]) translate([0,0,axial_width/2]) cylinder(d=bar_diameter,h=100,center=true);
}

// Cut modes for the views: 0 whole, 1 upper axial wall removed (interior), 2 half section.
module cut_mode(m) {
    if (m==1) difference() { children(); interior_cutter(); }
    else if (m==2) intersection() { children(); section_clip(); }
    else children();
}

module interior_cutter() {
    // Remove the upper axial wall only, so the cavity is seen from +Z with everything in place.
    translate([-200,-200,axial_width-case_wall-0.05]) cube([400,400,10]);   // just below the cavity top, no coplanar faces
}

module section_clip() {
    translate([-200,-200,-1]) cube([400,400,axial_width/2+1]);
}

// Remote parts, moved by d (the entry position is d = [0,-slide,0]).
module remote_parts(d=[0,0,0],m=0) {
    translate(d) {
        color([0.67,0.73,0.77]) cut_mode(m) housing();
        color([0.84,0.87,0.89]) cut_mode(m) face_cover();
        color([0.15,0.15,0.15]) cut_mode(m) gasket();
        color([0.95,0.75,0.25]) cut_mode(m) joy_plate();
        color([0.85,0.85,0.85]) cut_mode(m) stick();
        color([0.60,0.66,0.70]) cut_mode(m) battery_cap();
        color([0.15,0.15,0.15]) cut_mode(m) cap_gasket();
        control_heads();
    }
}

module base_parts(out=lock_out,m=0) {
    color([0.53,0.60,0.64]) cut_mode(m) base_front();
    color([0.45,0.52,0.56]) cut_mode(m) base_cap();
    color([0.72,0.48,0.22,0.8]) cut_mode(m) liner_half(false);
    color([0.72,0.48,0.22,0.8]) cut_mode(m) liner_half(true);
    cut_mode(m) clamp_bolts();
    cut_mode(m) lock_parts(out);
    cut_mode(m) strips();
}

module assembly() {
    remote_parts();
    base_parts();
    bar_ghost();
}

// Entry: the remote held off the platform at the entry position, lock pulled.
module entry_view() {
    remote_parts([-12,-slide,0]);
    base_parts(0);
    bar_ghost();
}

module base_view() {
    base_parts();
    bar_ghost();
}

module interior_view() {
    remote_parts(m=1);
    base_parts(m=1);
    controls_and_board();
}

module section_view() {
    remote_parts(m=2);
    base_parts(m=2);
    if (show_internals) intersection() { controls_and_board(); section_clip(); }
}

// Section across the dovetail at Y = section_y, seen from +Y.
section_y = (rail_y[0][0]+rail_y[0][1])/2;
// Flat cut at Y = section_y, drawn in 2D with +X to the right and +Z up.
module at_section_y() { rotate([90,0,0]) translate([0,-section_y,0]) children(); }
module dovetail_section_view() {
    color([0.67,0.73,0.77]) projection(cut=true) at_section_y() housing();
    color([0.53,0.60,0.64]) projection(cut=true) at_section_y() base_front();
    color([0.15,0.15,0.15]) projection(cut=true) at_section_y() strips();
}

// Fitting and removal, driven by $t (OpenSCAD --animate): pull the knob, press the remote
// onto the platform at the entry position, slide it up to the stop, release the knob; then
// pull the knob, slide down and lift off.
anim_lift = 30;              // how far off the platform the remote starts
function ramp(t,a,b) = t<=a ? 0 : (t>=b ? 1 : (1-cos(180*(t-a)/(b-a)))/2);
function anim_state(t) = [
    -anim_lift*(1-ramp(t,0.08,0.25)) - anim_lift*ramp(t,0.75,0.92),   // X offset
    -slide*(1-ramp(t,0.25,0.40)) - slide*ramp(t,0.60,0.75),           // Y offset
    lock_out*(ramp(t,0.40,0.45)-ramp(t,0.55,0.60))];                  // lock head out
module anim_view() {
    st = anim_state($t);
    remote_parts([st[0],st[1],0]);
    base_parts(st[2]);
    bar_ghost();
}
// The same, cut at mid-width and drawn flat, seen along the bar: rails, groove, stop and lock.
module mid_cut() { projection(cut=true) translate([0,0,-axial_width/2]) children(); }
module anim_section_view() {
    st = anim_state($t);
    translate([st[0],st[1]]) {
        color([0.36,0.56,0.74]) mid_cut() housing();
        color([0.80,0.84,0.87]) mid_cut() face_cover();
        color([0.95,0.75,0.25]) mid_cut() joy_plate();
    }
    color([0.30,0.36,0.42]) mid_cut() base_front();
    color([0.25,0.30,0.35]) mid_cut() base_cap();
    color([0.72,0.48,0.22]) mid_cut() { liner_half(false); liner_half(true); }
    color([0.85,0.45,0.15]) mid_cut() lock_parts(st[2]);
}

// Print orientations: no supports needed.
// Housing: upper facet down. Walls stay vertical; the lower facet is an open edge in the air;
// the lower bosses lean fold_angle; the cavity end at X = pod_cavity_x1 bridges 21 mm along Z.
module print_housing() { translate([0,0,-housing_front_x]) rotate([0,-90,0]) housing(); }
// Base halves: axial face down, so the bore prints as a true circle and the rail flanks at 45
// degrees. Lock knob: on its rear face.
module print_base_front() { base_front(); }
module print_base_cap() { base_cap(); }
module print_lock_knob() { translate([0,0,lock_knob_h]) mirror([0,0,1]) lock_knob_shape(); }   // top on the bed
// Cover: axial face down. The folded profile is an extrusion along Z; the control cutouts are
// horizontal and capped at 45 degrees (hidden under the bezels).
module print_cover() { face_cover(); }
// Ball and disc: disc underside on the bed, ball upward. Knob: top face on the bed.
module print_ball_disc() { translate([0,0,disc_bot_off]) mirror([0,0,1]) ball_disc_shape(); }
module print_knob() { translate([0,0,knob_proud]) knob_shape(); }
// Battery cap: outer (bottom) face on the bed; the countersinks open toward the bed at 45 degrees.
module print_battery_cap() { translate([0,0,-pod_bottom_y]) rotate([90,0,0]) battery_cap(); }
// Cap gasket: flat, printed or cut like the cover gasket.
module print_cap_gasket() { linear_extrude(height=gasket_print_thickness) projection() rotate([90,0,0]) cap_gasket(); }
// Joystick plate: sheet side on the bed, standoffs upward.
module print_joy_plate() { translate([0,0,-plate_front_off]) to_joy_frame() joy_plate(); }
// Inverse of at_joy(): global coordinates into the joystick frame.
module to_joy_frame() {
    rotate([0,-90,0]) rotate([0,0,-atan2(fold_n[1],fold_n[0])]) translate([-joy_p[0],-joy_p[1],-axial_width/2]) children();
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
    translate([-100,k[1]+0.3,pod_z0-1]) cube([200,200,pod_width+2]);
}

if (part_to_render=="assembly") assembly();
if (part_to_render=="interior") interior_view();
if (part_to_render=="section") section_view();
if (part_to_render=="entry") entry_view();
if (part_to_render=="anim") anim_view();
if (part_to_render=="anim_section") anim_section_view();
if (part_to_render=="base") base_view();
if (part_to_render=="dovetail_section") dovetail_section_view();
if (part_to_render=="housing") housing();
if (part_to_render=="base_front") base_front();
if (part_to_render=="base_cap") base_cap();
if (part_to_render=="lock_knob") lock_knob_shape();
if (part_to_render=="cover") face_cover();
if (part_to_render=="gasket") gasket();
if (part_to_render=="liner_main") liner_half(false);
if (part_to_render=="liner_cap") liner_half(true);
if (part_to_render=="print_housing") print_housing();
if (part_to_render=="print_base_front") print_base_front();
if (part_to_render=="print_base_cap") print_base_cap();
if (part_to_render=="print_lock_knob") print_lock_knob();
if (part_to_render=="print_cover") print_cover();
if (part_to_render=="print_gasket") print_gasket();
if (part_to_render=="stick") stick();
if (part_to_render=="knob") knob();
if (part_to_render=="joy_plate") joy_plate();
if (part_to_render=="ball_disc") ball_disc();
if (part_to_render=="print_ball_disc") print_ball_disc();
if (part_to_render=="print_knob") print_knob();
if (part_to_render=="print_joy_plate") print_joy_plate();
if (part_to_render=="battery_cap") battery_cap();
if (part_to_render=="cap_gasket") cap_gasket();
if (part_to_render=="print_battery_cap") print_battery_cap();
if (part_to_render=="print_cap_gasket") print_cap_gasket();
