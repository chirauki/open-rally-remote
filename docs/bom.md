# Bill of Materials — V0.32

This is the single parts list for the project: the bench prototype and the V0.32 removable, battery-powered remote with its base. V0.32 is V0.26 with the joystick board rev C, one base for both bar sizes, the vent in the battery cap, no heat-set inserts, foam seals on the cover and the battery cap, and fewer different parts to buy (V0.32). The three circuit boards are joined with bought cables ([design](superpowers/specs/2026-10-14-no-solder-assembly-design.md)). They can be ordered assembled, so the build needs no soldering, or bare, for the builder to solder by hand at a much lower cost: see [Ordering the boards](#ordering-the-boards). Design details stay in the linked documents; this page lists what to buy.

**Status:** nothing in the V0.32 list has been built or tested. The V0.25 list is in the git history.

Sourcing preference: parts that builders can buy from mainstream retailers (for example Amazon) come first. Distributor-only parts are used only where no retail part meets the requirement, and the reason is given.

## Estimated cost

Rough figures for one remote and one base, in euros including VAT, before shipping unless a line says otherwise. They were checked on 2026-10-13 where a source is given; the rest are estimates that have not been checked against a shop. Many parts only come in packs or kits, so the first build costs much more than each one after it.

| Section | Estimate | Basis |
|---|---:|---|
| [Bench prototype](#bench-prototype) | €22–29 | Checked on 2026-10-07; see the section. |
| [Remote: electronics](#electronics) | €75–110 with bare boards soldered by hand; €110–170 assembled | JLCPCB quotes and JLCPCB library prices on 2026-10-15; parts shipping not checked. |
| [Remote: hardware](#hardware) | €30–60, plus the vent label | Kit prices checked; single-size packs not checked. No retail price found for the vent label. |
| [Remote: printed parts](#printed-parts) | €20–50 | Not checked: needs a quote from a print service with the exported files. |
| [Base](#base-one-per-bike) | €25–60 | Not checked; much of the hardware comes from the kits bought for the remote. |
| [Consumables](#consumables) | €30–45, plus €15–30 of soldering supplies for bare boards | Conformal coating checked; the rest not checked. |
| **First remote and base, without the bench parts** | **about €195–385** | |

With assembled boards, the board order (mostly fixed fees, extended-part fees and shipping) is the largest item.

## Bench prototype

For firmware and BLE experiments on a breadboard; see the [breadboard assembly guide](breadboard-assembly.md). Prices and stock were checked on 2026-10-07, in Spain, including VAT where the shop shows it and excluding shipping.

| Qty | Part | Example source | Price checked | Notes |
|---:|---|---|---:|---|
| 1 | Seeed XIAO nRF52840, pre-soldered headers (MPN `102010631`) | [Kiwi Electronics](https://www.kiwi-electronics.com/en/seeed-studio-xiao-nrf52840-pre-soldered-20402) | €9.99 before VAT | The non-Sense model. The same board goes into the remote. |
| 1 | 400-point solderless breadboard | [Conectrol](https://conectrol.com/producto/placa-protoboard-400-puntos-84x55x85mm/) | €2.00 | With side power rails. |
| 1 set | 40 Dupont jumper wires, male-to-female, 20 cm | [Conectrol](https://conectrol.com/producto/kit-cables-dupont-1p-para-protoboard-m-h-40-unds/) | €3.00 | Nine needed: eight GPIO and one GND. |
| 1 set | 65 Dupont jumper wires, male-to-male | [Conectrol](https://conectrol.com/producto/kit-cables-dupont-1p-para-protoboard-m-m-65-unds/) | €3.00 | Eight needed, to the ground rail. |
| 8 | 6 × 6 × 5 mm normally-open tactile switch, through-hole | [Conectrol](https://conectrol.com/producto/pulsador-tactil-off-on-no-6x6x5mm-pcb-rojo/) | €0.20 each | Bench stand-ins only. They do **not** fit the joystick PCB: it needs the sealed SMD C&K KSC2 (below), 3.5 mm tall instead of 5 mm. |
| 1 | USB-A to USB-C data cable | [Conectrol](https://conectrol.com/producto/cable-usb-3-0-tipo-a-usb-tipo-c-3-1-m-m-1mt/) | €6.90 | Optional; any data-capable cable works. |

Estimated total: about €21.69 without the USB cable, or €28.59 with it, before shipping; the XIAO figure adds an estimated 21 % VAT to the seller's €9.99.

A cheaper alternative is the unheadered XIAO (MPN `102010448`), listed at €9.56 including VAT by [Reichelt Spain](https://www.reichelt.com/es/es/shop/producto/xiao_nrf52840_bt5_0_sin_cabezal-358357); it needs 2 × 7 headers soldered on.

## Remote

See the [mechanical notes](mechanical-concept.md) for where each part goes and the [assembly steps](mechanical-concept.md#assembly).

### Electronics

| Qty | Part | Source | Notes |
|---:|---|---|---|
| 1 | Seeed XIAO nRF52840 **with pre-soldered pins** (MPN `102010631`) | [Kiwi Electronics](https://www.kiwi-electronics.com/en/seeed-studio-xiao-nrf52840-pre-soldered-20402), €9.99 before VAT | Plugs into the control board's headers. The same board as on the breadboard. |
| 1 | LiPo pouch with protection board and a JST-PH 2.0 lead, at most 6 × 20 × 54 mm including the protection board | Retail (for example Amazon) | The pouch goes in with its protection board up; the lead must leave that end and be at least about 35 mm long (29 mm in the CAD with a 46.8 mm cell). 600 mAh class (602045, 602050); a 602045 cell measured 6.1 × 19.7 × 46.8 mm with a 43.5 mm lead from one corner, and fits. The control board protects against a reversed plug; check the polarity anyway. |
| 1 | [Control board](../electronics/control-pcb/README.md), 21.4 × 49 × 1.6 mm | JLCPCB, bare or assembled | Three KSC2 buttons, XIAO headers, MCP73831 charger, TPS70933 regulator, sockets. Gerbers, BOM and placement in `electronics/control-pcb/fab/`. Parts on both sides; the headers are through-hole. |
| 1 | [Joystick board rev C](../electronics/joystick-pcb-rev-c/README.md), 20.6 × 22.4 × 1.6 mm | JLCPCB, bare or assembled | Four KSC2 switches and one socket. Files in `electronics/joystick-pcb-rev-c/fab/`. Rev B (V0.26) does not let the housing close. |
| 1 | [USB-C board rev B](../electronics/usbc-pcb-rev-b/README.md), 19 × 16 × **1.2** mm | JLCPCB, bare or assembled | Order at 1.2 mm. Files in `electronics/usbc-pcb-rev-b/fab/`. |
| 1 | GCT USB4736-GF-A-KIT: the sealed USB-C receptacle with its USBTJ-06 gasket | [TME](https://www.tme.com/in/en/details/usb4736-gf-a-kit/usb-ieee1394-connectors/gct/) or [DigiKey](https://www.digikey.sg/en/products/detail/gct/USB4736-GF-A-KIT/26795952), about USD 1.7–1.8 | Soldered by hand on the USB-C board; the gasket goes on after soldering. JLCPCB's part C9900206672 is the USB4736-GF-A **without** the gasket, and JLCPCB could not source it on 2026-10-15. |
| 1 | JST SH-style cable, 5-pin, female–female, 1 mm pitch, straight (pin 1 to pin 1), 10 cm | [Pololu](https://www.pololu.com/category/350/5-pin-jst-sh-style-cables) | Joystick board to control board. Not found on Amazon by web search. |
| 1 | JST SH-style cable, 3-pin, female–female, 1 mm pitch, straight, 10 cm | Pololu | USB-C board to control board. |

The board parts with their LCSC numbers are in each board's README and `fab/*-bom.csv`. The KSC221JLFS switches (LCSC C221726) are distributor parts: no retail sealed switch with this footprint was found.

#### Ordering the boards

JLCPCB makes at least 5 of each board and assembles at least 2. Three ways to order, with JLCPCB quotes from 2026-10-15. They include VAT but not shipping, about €10 more (so about €30 for the bare boards):

| Option | JLCPCB order | The builder solders | Quote |
|---|---|---|---|
| **Bare boards** (cheapest) | The three `fab/*-gerbers.zip`, no assembly | Every part, from [`electronics/lcsc-parts.csv`](../electronics/lcsc-parts.csv), plus the USB4736 kit | €22.86 for the three boards |
| Economic assembly, bottom side only | Control and joystick with `fab/economic-bottom/`; the USB-C board's top side with its `fab/` files, J1 left unselected | The 7 KSC2 switches, the 2 XIAO headers and the USB4736 kit | €86.27 for the three boards |
| Standard double-sided assembly | Control and joystick as the [panel](../electronics/panel-ctrl-joy/README.md) | Nothing, except the USB4736 if JLCPCB cannot source it | About €134 for control and joystick alone |

`electronics/lcsc-parts.csv` loads into LCSC's BOM tool. Its `Quantity` column covers two remotes with spares, because small parts get lost; `Per remote` gives the exact count. LCSC rounds some quantities up to its minimum order. Two lines with `Per remote` 0 are alternatives, bought now to avoid a second order: the 8.5 mm XIAO headers, if the XIAO's pins do not suit the 5.7 mm ones (see the [control board](../electronics/control-pcb/README.md)), and a 6.8 kΩ R1 for about 150 mA charge current (the 5.1 kΩ in the list gives about 200 mA). Since 1 July 2026 the EU charges €3 customs duty per tariff class on parcels under €150 from outside the EU, not per part; LCSC's checkout charged €21 for this list on 2026-10-19, with or without the two alternatives, so more parts of a class already in the order add no duty; a later order pays it again. LCSC's checkout total for the list on 2026-10-19 was €55.02: €24.63 parts, €10.07 shipping, €21.00 duty, less a €0.68 discount. That is about €28 per remote. The checkout charged no VAT, so the carrier may collect import VAT (21 % in Spain) and a handling fee on delivery; not checked. The USB4736 kit is not at LCSC.

Hand soldering needs a fine-tipped iron, no-clean flux, 0.5–0.8 mm flux-cored solder and desoldering braid (see [Consumables](#consumables)). The hard parts are the four 1.0 mm-pitch JST SH sockets, the side-looking LED and the USB4736; the 0603 parts and the SOT-23 packages need flux. Solder a spare board first; the joystick board, with four switches and one socket, is the easiest. Check BAT, 5V and 3V3 against GND with a meter before the first power-up.

Estimated cost: about €75–110 with bare boards, €110–170 assembled.

- XIAO with pins: €9.99 before VAT at Kiwi Electronics.
- LiPo: €5–10.
- Boards: the quotes above, plus about €10 shipping.
- Parts from LCSC: about €28 per remote with shipping and duty (see above).
- USB4736 kit from TME or DigiKey: about €2 per remote plus shipping; shipping not checked. DigiKey Spain charges €25 shipping below €75 (2026-10-19).
- Two Pololu cables: about USD 2–3 each plus shipping; not checked.

### Hardware

| Qty | Part | Source | Notes |
|---:|---|---|---|
| 10 | M2 × 10 countersunk screw, ISO 10642 | Retail | Cover, through the button plate (upper facet) and the joystick plate (lower facet). They cut their own thread in Ø1.6 mm pilots in the bosses. |
| 3 | M2 × 8 countersunk screw, ISO 10642 | Retail | Battery cap, into Ø1.6 mm pilots in the housing. |
| 2 | M2 × 8 button-head screw, head at most Ø3.5 × 1.1 mm (ISO 7380 style) | Retail | Joystick board to the joystick plate standoffs. |
| 4 | M2 × 4 button-head screw, head at most Ø3.5 × 1.1 mm (ISO 7380 style) | Retail | Two hold the control board to the button plate standoffs (2.4 mm of thread in a 3.7 mm pilot; M2 × 6 would stand 0.7 mm out of the plate's front). Two hold the USB-C board to its rib. |
| 1 | Ø3 × 12 mm steel dowel pin, ISO 8734 | Retail | Joystick stick. |
| 1 | M2 × 4 grub screw | Retail | Joystick knob. |
| 1 | M2 square nut, DIN 562 (4 × 1.2 mm) | Retail | Joystick knob, in the slot under it, for the grub screw. |
| 1 | Adhesive ePTFE vent label, Ø7.6 mm (Takachi VE8 size), for a Ø3 mm hole | Retail | Inside the battery cap (V0.28). Check the hole size the chosen vent needs. |
| 1 | Closed-cell foam sheet, EPDM or neoprene, self-adhesive, 1.5 mm thick, about 150 × 150 mm | Retail (sheet or wide roll) | Both seals and the three pads (V0.32), from one piece: the cover strip, cut 2 mm wide and about 25 cm long in all, on the housing rim (V0.30), and the battery cap gasket (V0.31), cut round a paper template printed at 100 % from `mechanical/cad/tools/cap-gasket-template.scad` (its 40 mm bar checks the scale). Soft grade; firm foam needs more screw force. The pads are layers of the same sheet: four on the battery cap, one on the rear wall, and six between the XIAO and the pouch, which hold the XIAO in its headers. |

Estimated cost: about €30–60, plus the vent label.

- M2 screws: an M2 stainless assortment with countersunk heads is about €36 at [ManoMano](https://www.manomano.es/p/kit-surtido-de-250-piezas-de-tornillos-pernos-y-llaves-de-vaso-hexagonales-de-cabeza-avellanada-planas-abombadas-y-cilindricas-de-acero-inoxidable-a2-con-tuercas-m2-x-468101216-mm-cabeza-p-94605084). The listing does not state ISO 10642. Packs of single sizes are likely cheaper; not checked.
- Dowel pin, grub screw and foam sheet: €5–10, not checked.
- Vent label: no single-unit retail price was found. Gore adhesive vents come in packs of 50 at about £213 before VAT ([RS UK](https://uk.rs-online.com/web/p/enclosure-ventilation/2842971)), which is too many for one build. Generic ePTFE vent stickers sold in small packs need checking for an IP67 rating before use. Takachi sells its VE8 (Ø7.6 mm) [online](https://takachi-enclosure.com/products/VE8); the price and pack size for one build are not checked.

### Printed parts

| Qty | Part | Material | Print mode |
|---:|---|---|---|
| 1 | Housing | PETG or ASA | `print_housing` |
| 1 | Control cover | PETG or ASA | `print_cover` |
| 1 | Joystick plate | PETG | `print_joy_plate` |
| 1 | Ball and disc | PETG | `print_ball_disc` |
| 1 | Joystick knob | PETG or ASA | `print_knob` |
| 1 | Keypad and gasket, one piece with the three keys | Soft TPU (85A or softer); it can no longer be cut from sheet, because the keys stand on it | `print_gasket` |
| 1 | Button plate | PETG | `print_button_plate` |
| 1 | Battery cap | PETG or ASA | `print_battery_cap` |

Print settings and orientations are in the [mechanical notes](mechanical-concept.md#printing).

Estimated cost: about €20–50 from a print service, including shipping. **Not checked.** [JLC3DP](https://jlc3dp.com/fr) lists FDM parts from USD 1 each, but does not list PETG. Get a quote with the exported STL files.

## Base, one per bike

| Qty | Part | Source | Notes |
|---:|---|---|---|
| 2 | M4 × 16 socket-head screw, ISO 4762 | Retail | Clamp. Cuts its own thread in Ø3.4 mm pilots in the base front. |
| 1 | M3 × 20 socket-head screw, ISO 4762 | Retail | Its head is the lock pin. V0.31 asked for M3 × 22, which is not a standard length. |
| 1 | Compression spring 0.5 × 5 × 10 mm, stainless (wire × outside diameter × free length) | Retail (spring assortments; cut a longer one to length if needed) | Lock. About 3.4 N locked, estimated. |
| 2 | Ø1.5 × 4 mm steel dowel pin, ISO 8734 | Retail | Quarter-turn lock knob. |
| 1 | M3 nut, ISO 4032 | Retail | Lock knob, in its hex pocket; fixed on the thread with the clear epoxy (V0.32: no lock nut). |
| 1 | Bike inner tube, butyl, about 0.8–1.2 mm wall; an old one will do | Retail or a used tube | Two anti-rattle strips, 4 × 50 mm, glued into the platform pockets with the clear epoxy. Optionally the two liner halves, 23 × 43 mm, instead of the printed TPU. Measure the wall and set `strip_t` (and `liner_radial`) before printing the base front. |
| 1 | Base front | PETG or ASA, `print_base_front` | One part for both bar sizes (V0.28). |
| 1 | Base cap | PETG or ASA, `print_base_cap` | |
| 2 | Bar liner half | TPU 95A, `liner_main`, `liner_cap`, or cut from the inner tube | Fits a 25.4 mm bar or the sleeve. |
| 2 | Sleeve half, bars under 25.4 mm only | PETG, `print_sleeve`, with `bar_diameter` set to the bar measured with a caliper | Between the bar and the liner. Painted 7/8 in bars can measure 0.3 mm over 22.2 mm. |
| 1 | Lock knob, Ø16 mm quarter turn | PETG, `print_lock_knob` | Top face on the bed. |

Estimated cost: about €25–60. **Not checked.**

- Printed parts: €15–35 from a print service.
- Hardware: €10–25. This includes a spring assortment, the M3 and M4 screws and the nuts.

## Consumables

| Part | Use |
|---|---|
| Conformal coating, acrylic or silicone | The three boards and the XIAO. Keep it off the USB-C sockets, the JST sockets and headers, the switch actuators, the pouch and the vent. |
| Clear two-part epoxy | Potting the back of the charging USB-C receptacle, filling the charge LED window, fixing the lock knob's nut on its screw and gluing the anti-rattle strips. One clear epoxy does all four. |
| No-clean flux (syringe), 0.5–0.8 mm flux-cored solder, 2 mm desoldering braid, isopropyl alcohol | Bare boards only: hand soldering, and cleaning the flux off before the conformal coating. |

Estimated cost: about €30–45, plus €15–30 for the soldering supplies (not checked).

- Acrylic conformal coating, 200 ml aerosol: €21.11 with VAT at [RS Netherlands](https://nl.rs-online.com/web/p/conformal-coatings/0714462).
- Clear two-part epoxy: about €5–10. **Not checked.**

## Ordering notes

- The three boards can share one JLCPCB order. The USB-C board is 1.2 mm thick and the other two 1.6 mm, so they are separate boards in the order.
- For assembly: the control and joystick boards have parts on both sides, so full assembly is double-sided. Check each part's rotation in JLCPCB's placement preview: the CPL files use KiCad's rotations.
- The cables are straight: pin 1 of one end goes to pin 1 of the other. Check the bought cables before fitting them.
- LCSC numbers and stock were checked in the JLCPCB library on 2026-10-14; stock and prices change.
