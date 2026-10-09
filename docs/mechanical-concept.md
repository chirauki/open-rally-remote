# Complete Mechanical CAD — V0.3 Integrated Clamp Concept

V0.3 keeps the split-ring body introduced in V0.2 and corrects the control orientation. The button panel sits on the radial side of the housing, so the buttons press perpendicular to the handlebar axis. The XIAO is turned behind this panel inside the pod. The rear enclosure and the main half of the clamp are one structural body; a removable opposite half closes the ring.

**Current parametric concept:** [complete-remote-v0.3.scad](../mechanical/cad/complete-remote-v0.3.scad)

![Integrated split-ring concept with controls on the radial side face, perpendicular to the handlebar axis.](images/complete-remote-v0.3.svg)

The OpenSCAD file builds the integrated main body, opposite clamp cap, radial control cover, split liner, and component envelopes. Set `show_internals = false` to hide the button and XIAO envelopes. Set `part_to_render` to `"housing"`, `"clamp_cap"`, `"cover"`, `"liner_main"`, or `"liner_cap"` to export a part. The SVG is a dimensioned concept view; the editable geometry is the SCAD file. Switches, joystick, and board are packaging envelopes rather than supplier STEP models.

## Assembly parts represented

1. **Integrated main body:** a C-shaped main clamp half joined directly to the control pod. Its annular wall is the rear structural housing around the bar.
2. **Removable clamp cap:** the opposite half ring closes the clamp and is secured by two transverse M4 through-bolts with locknuts in this initial concept. Verify bolt length, wrench access, and lug strength in a printed prototype.
3. **Radial control face:** A/B/C and joystick openings are on the pod's side face. Their actuation axes are perpendicular to the handlebar axis.
4. **Electronics pod:** the XIAO is turned 90 degrees behind the control bodies inside the pod; a preliminary cable entry is included at the lower end.
5. **Replaceable liner:** two semicircular TPU pieces fit between the Ø24 mm clamp bore and nominal Ø22 mm handlebar.

## Sourced dimensions and design targets

| Feature | CAD value | Basis |
|---|---:|---|
| XIAO nRF52840 board outline | 21 × 17.8 mm | Seeed Studio published dimensions |
| APEM IS button panel opening | Ø13.6 mm | APEM IS series drawing |
| APEM reduced bezel option | 15 mm | APEM IS series options; confirm exact ordered variant |
| MHS joystick thread / panel | M16 × 1 / 2–3 mm | Ruffy Controls MHS datasheet |
| MHS nominal panel opening | Ø15.80 mm | Ruffy drawing callout Ø0.622 in; full profile needs confirmation |
| Handlebar | Ø22 mm nominal | Project target; measure the actual straight section |
| Integrated clamp | Ø50 mm outer diameter, Ø24 mm bore | Parametric packaging target; currently a two-part split ring |
| Clamp liner | 1 mm radial TPU liner gives Ø22 mm nominal inner diameter | Parametric target; tune to measured bar and print process |
| Enclosure envelope | About 80 × 82 mm in the front plane; 27 mm clamp width + 2.5 mm face cover | Current concept target; verify against component samples |
| Button direction | Button axes perpendicular to the handlebar axis | Layout requirement; reflected in V0.3 coordinate system |
| Case wall / cover | 2.0 / 2.5 mm | Initial print design targets |
| Control pitch | 18 mm, four controls | Layout target; confirm glove access and supplier bezel sizes |
| Clamp fasteners | Two transverse M4 through-bolts | Initial target; choose length, washers, and locknuts after prototype fit |
| Cable gland seat | Ø8.2 mm pass-through, Ø14 × 5 mm inner reinforcement | M8 gland packaging target; verify selected product drawing |
| USB cable jacket | 3–5 mm range candidate | Hummel M8 gland example; measure actual cable |
| XIAO header projection | 6 mm | Packaging allowance for the pre-soldered version; measure the bought board |

Seeed lists the XIAO board at 21 × 17.8 mm and provides a [2D DXF drawing](https://wiki.seeedstudio.com/XIAO_BLE/). The purchased variant has pre-soldered headers; V0.3 places the board parallel to the radial control cover, behind the button bodies. The 6 mm header projection is an allowance, not a supplier dimension. The [Kiwi listing](https://www.kiwi-electronics.com/en/seeed-studio-xiao-nrf52840-pre-soldered-20402) confirms the headers are pre-soldered. Check the actual header, USB-C, antenna, and component clearances against the printed cavity before finalizing it.

The Ruffy [MHS datasheet](https://www.farnell.com/datasheets/4534112.pdf) specifies an M16 × 1 body, panel thickness 2–3 mm, and a nominal Ø0.622 in mounting callout. The drawing also contains a 0.291 in profile dimension and two rounded corners; V0.2 still models the nominal circle only. Do not use the joystick opening as a finished drilling template until the complete profile is checked against the full drawing or the actual part.

APEM's [IS series page](https://www.apem.com/panel-switches/pushbutton-switches/is) gives the Ø13.6 mm panel cutout, 13 mm behind-panel depth, 1.5–4 mm panel range, and 15 mm reduced-bezel option. Order-code availability and the reduced-bezel variant's exact drawing must be confirmed before selecting the production switch.

## Power cable and service access

The model includes a preliminary Ø8.2 mm cable entry through the lower end wall of the pod. It does not yet model a selected gland, its nut/seat, strain relief, or the complete wire route. One candidate is [Hummel's M8 × 1.25 gland](https://www.hummel.com/en/product-finder-cable-gland/products/metal-cable-glands/hsk-mini/1106080055-wadi-a-fpm-m8x1-25/), listed for 3–5 mm cable; select and measure the actual cable and gland before adding their mounting features to the CAD.

The cover and clamp have preliminary screw-clearance holes, but the mating bosses, nut traps/inserts, sealing features, and fastener lengths are not yet designed. The XIAO USB-C connector is inside the enclosure in this arrangement; the CAD does not yet define a sealed external programming port. Phone-based BLE firmware updates remain a firmware requirement.

## What is still required before fabrication

- Confirm button and joystick exact order codes and use the full supplier drawings or measured samples to model their bodies, nuts, terminals, leads, and complete panel cutouts.
- Measure the purchased XIAO including header projection, USB-C connector, component heights, and antenna keepout; verify the rotated board fit, pod cavity, and cable route against the actual board.
- Measure the bike's straight 22 mm handlebar section. Verify the liner, clamp installation direction, steering clearance, and control interference on the motorcycle.
- Print and load-test the split-ring body, cap, bolt lugs, and liner. This CAD expresses the integrated architecture but does not establish fatigue or impact strength without physical testing.
- Choose the actual cable gland, cover seal, clamp bolts/nuts or inserts, and service fasteners; add their seats and access to the CAD.
- Check printed-part tolerances, wall strength, fastener pull-out, glove reach, water ingress, vibration, and impact on physical prototypes. This concept does not establish an IP rating.

This is a **full-form CAD concept**, not yet a manufacturing release. Dimensions marked as sourced come from the linked supplier references; the enclosure, cable, clamp, and fastener dimensions are initial design targets for measurement and prototype revision. V0.1 and V0.2 remain available as earlier layouts for comparison.
