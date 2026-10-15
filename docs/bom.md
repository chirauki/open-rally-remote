# Bill of Materials — V0.29

This is the single parts list for the project: the bench prototype and the V0.29 removable, battery-powered remote with its base. V0.29 is V0.26 with the joystick board rev C, one base for both bar sizes, the vent in the battery cap and no heat-set inserts. It is built without soldering or any hot tool: the three circuit boards are ordered assembled and joined with bought cables ([design](superpowers/specs/2026-10-14-no-solder-assembly-design.md)). Design details stay in the linked documents; this page lists what to buy.

**Status:** nothing in the V0.29 list has been built or tested. The V0.25 list is in the git history.

Sourcing preference: parts that builders can buy from mainstream retailers (for example Amazon) come first. Distributor-only parts are used only where no retail part meets the requirement, and the reason is given.

## Estimated cost

Rough figures for one remote and one base, in euros including VAT, before shipping unless a line says otherwise. They were checked on 2026-10-13 where a source is given; the rest are estimates that have not been checked against a shop. Many parts only come in packs or kits, so the first build costs much more than each one after it.

| Section | Estimate | Basis |
|---|---:|---|
| [Bench prototype](#bench-prototype) | €22–29 | Checked on 2026-10-07; see the section. |
| [Remote: electronics](#electronics) | €110–170 | Parts checked in the JLCPCB library; the assembled boards are an estimate from the JLCPCB fee table, not a quote. |
| [Remote: hardware](#hardware) | €30–60, plus the vent label | Kit prices checked; single-size packs not checked. No retail price found for the vent label. |
| [Remote: printed parts](#printed-parts) | €20–50 | Not checked: needs a quote from a print service with the exported files. |
| [Base](#base-one-per-bike) | €25–60 | Not checked; much of the hardware comes from the kits bought for the remote. |
| [Consumables](#consumables) | €35–55 | Conformal coating checked; the rest not checked. |
| **First remote and base, without the bench parts** | **about €220–395** | |

The assembled-board order (about €80–120, mostly fixed fees, extended-part fees and shipping) is the largest item.

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
| 1 | LiPo pouch with protection board and a JST-PH 2.0 lead, at most 6 × 20 × 54 mm including the protection board | Retail (for example Amazon) | The pouch goes in with its protection board up; the lead must leave that end and be at least about 40 mm long (27 mm in the CAD). 600 mAh class (602045, 602050). The control board protects against a reversed plug; check the polarity anyway. |
| 1 | [Control board](../electronics/control-pcb/README.md), 21.4 × 49 × 1.6 mm, assembled | JLCPCB | Three KSC2 buttons, XIAO headers, MCP73831 charger, TPS70933 regulator, sockets. Gerbers, BOM and placement in `electronics/control-pcb/fab/`. Parts on both sides; the headers are through-hole. |
| 1 | [Joystick board rev C](../electronics/joystick-pcb-rev-c/README.md), 20.6 × 22.4 × 1.6 mm, assembled | JLCPCB | Four KSC2 switches and one socket. Files in `electronics/joystick-pcb-rev-c/fab/`. Rev B (V0.26) does not let the housing close. |
| 1 | [USB-C board rev B](../electronics/usbc-pcb-rev-b/README.md), 19 × 16 × **1.2** mm, assembled | JLCPCB | Order at 1.2 mm. The GCT USB4736-GF-A receptacle is bought through JLCPCB's global sourcing (C9900206672); its USBTJ-06 gasket comes in the kit and is fitted after soldering. Files in `electronics/usbc-pcb-rev-b/fab/`. |
| 1 | JST SH-style cable, 5-pin, female–female, 1 mm pitch, straight (pin 1 to pin 1), 10 cm | [Pololu](https://www.pololu.com/category/350/5-pin-jst-sh-style-cables) | Joystick board to control board. Not found on Amazon by web search. |
| 1 | JST SH-style cable, 3-pin, female–female, 1 mm pitch, straight, 10 cm | Pololu | USB-C board to control board. |

The board parts with their LCSC numbers are in each board's README and `fab/*-bom.csv`. The KSC221JLFS switches (LCSC C221726) are distributor parts: no retail sealed switch with this footprint was found.

Estimated cost: about €110–170. **The board order is an estimate, not a quote.**

- XIAO with pins: €9.99 before VAT at Kiwi Electronics.
- LiPo: €5–10.
- Three assembled boards, one JLCPCB order, at least 2 of each: about €80–120 with shipping and import VAT. From the [JLCPCB assembly fee table](https://jlcpcb.com/help/article/pcb-assembly-price) dated 2025-09-01: USD 8 setup and USD 1.50 stencil per board and side, USD 3 per unique extended part (about 14 across the three boards), through-hole soldering for the headers, and the parts. Get the live quote with the `fab/` files.
- GCT receptacle through global sourcing: about USD 2 plus JLCPCB's sourcing fee; not checked.
- Two Pololu cables: about USD 2–3 each plus shipping; not checked.

### Hardware

| Qty | Part | Source | Notes |
|---:|---|---|---|
| 10 | M2 × 10 countersunk screw, ISO 10642 | Retail | Cover, through the button plate (upper facet) and the joystick plate (lower facet). They cut their own thread in Ø1.6 mm pilots in the bosses. |
| 3 | M2 × 8 countersunk screw, ISO 10642 | Retail | Battery cap, into Ø1.6 mm pilots in the housing. |
| 2 | M2 × 8 button-head screw, head at most Ø3.5 × 1.1 mm (ISO 7380 style) | Retail | Joystick board to the joystick plate standoffs. |
| 2 | M2 × 5 thread-forming button-head screw, head at most Ø3.5 × 1.1 mm | Retail | Control board to the button plate standoffs. |
| 2 | M2 × 4 thread-forming button-head screw, head at most Ø3.5 × 1.1 mm | Retail | USB-C board to its rib. |
| 1 | Ø3 × 12 mm steel dowel pin, ISO 8734 | Retail | Joystick stick. |
| 1 | M2 × 4 grub screw | Retail | Joystick knob. |
| 1 | M2 square nut, DIN 562 (4 × 1.2 mm) | Retail | Joystick knob, in the slot under it, for the grub screw. |
| 1 | Adhesive ePTFE vent label, Ø7.6 mm (Takachi VE8 size), for a Ø3 mm hole | Retail | Inside the battery cap (V0.28). Check the hole size the chosen vent needs. |
| — | Thin foam sheet (about 1–5 mm, EVA or similar) | Retail | Pad on the battery cap, strip on the rear wall, and a pad between the XIAO and the pouch that holds the XIAO in its headers. |

Estimated cost: about €30–60, plus the vent label.

- M2 screws: an M2 stainless assortment with countersunk heads is about €36 at [ManoMano](https://www.manomano.es/p/kit-surtido-de-250-piezas-de-tornillos-pernos-y-llaves-de-vaso-hexagonales-de-cabeza-avellanada-planas-abombadas-y-cilindricas-de-acero-inoxidable-a2-con-tuercas-m2-x-468101216-mm-cabeza-p-94605084). The listing does not state ISO 10642. Packs of single sizes are likely cheaper; not checked.
- Dowel pin, grub screw and foam tape: €5–10, not checked.
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
| 1 | Battery cap gasket | As the cover gasket | `print_cap_gasket` |

Print settings and orientations are in the [mechanical notes](mechanical-concept.md#printing).

Estimated cost: about €20–50 from a print service, including shipping. **Not checked.** [JLC3DP](https://jlc3dp.com/fr) lists FDM parts from USD 1 each, but does not list PETG. Get a quote with the exported STL files.

## Base, one per bike

| Qty | Part | Source | Notes |
|---:|---|---|---|
| 2 | M4 × 16 socket-head screw, ISO 4762 | Retail | Clamp. Cuts its own thread in Ø3.4 mm pilots in the base front. |
| 1 | M3 × 22 socket-head screw, ISO 4762 | Retail | Its head is the lock pin. |
| 1 | Compression spring 0.5 × 5 × 10 mm, stainless (wire × outside diameter × free length) | Retail (spring assortments; cut a longer one to length if needed) | Lock. About 3.4 N locked, estimated. |
| 2 | Ø1.5 × 4 mm steel dowel pin, ISO 8734 | Retail | Quarter-turn lock knob. |
| 2 | M3 nut, ISO 4032 | Retail | Lock knob: one in its hex pocket, one as the lock nut. |
| 2 | TPU strip, 4 × 50 × 1.4 mm | Printed TPU, or cut from rubber sheet | Anti-rattle, glued into the platform pockets. |
| 1 | Base front | PETG or ASA, `print_base_front` | One part for both bar sizes (V0.28). |
| 1 | Base cap | PETG or ASA, `print_base_cap` | |
| 2 | Bar liner half | TPU 95A, `liner_main`, `liner_cap` | Fits a 25.4 mm bar or the sleeve. |
| 2 | Sleeve half, bars under 25.4 mm only | PETG, `print_sleeve`, with `bar_diameter` set to the bar measured with a caliper | Between the bar and the liner. Painted 7/8 in bars can measure 0.3 mm over 22.2 mm. |
| 1 | Lock knob, Ø16 mm quarter turn | PETG, `print_lock_knob` | Top face on the bed. |

Estimated cost: about €25–60. **Not checked.**

- Printed parts: €15–35 from a print service.
- Hardware: €10–25. This includes a spring assortment, the M3 and M4 screws and the nuts.

## Consumables

| Part | Use |
|---|---|
| Conformal coating, acrylic or silicone | The three boards and the XIAO. Keep it off the USB-C sockets, the JST sockets and headers, the switch actuators, the pouch and the vent. |
| Two-part epoxy | Potting the back of the charging USB-C receptacle. |
| Clear epoxy or UV-cure resin | Filling the charge LED window. |
| Neutral-cure silicone | Sealing where the notes call for it. |

Estimated cost: about €35–55.

- Acrylic conformal coating, 200 ml aerosol: €21.11 with VAT at [RS Netherlands](https://nl.rs-online.com/web/p/conformal-coatings/0714462).
- Epoxy, UV resin and neutral-cure silicone: about €5–10 each. **Not checked.**

## Ordering notes

- The three boards can share one JLCPCB order. The USB-C board is 1.2 mm thick and the other two 1.6 mm, so they are separate boards in the order.
- The control and joystick boards have parts on both sides, so they need double-sided assembly. Check each part's rotation in JLCPCB's placement preview: the CPL files use KiCad's rotations.
- The cables are straight: pin 1 of one end goes to pin 1 of the other. Check the bought cables before fitting them.
- LCSC numbers and stock were checked in the JLCPCB library on 2026-10-14; stock and prices change.
