# Bill of Materials — V0.34

> Spanish version: [bom.es.md](bom.es.md).

This is the single parts list for the project: the bench prototype and the V0.34 removable, battery-powered remote with its base. V0.34 is V0.26 with the joystick board rev C, one base for both bar sizes, the vent in the battery cap, no heat-set inserts, foam seals on the cover and the battery cap, fewer different parts to buy (V0.32), 2 mm walls, which make the remote and the base 25 mm wide (V0.33), and a sliding USB-C board on two square nuts with two-layer foam seals (V0.34). The three circuit boards are joined with bought cables ([design](superpowers/specs/2026-10-14-no-solder-assembly-design.md)). They can be ordered assembled, so the build needs no soldering, or bare, for the builder to solder by hand at a much lower cost: see [Ordering the boards](#ordering-the-boards). Design details stay in the linked documents; this page lists what to buy.

**Status:** nothing in the V0.34 list has been built or tested. The print material is not chosen yet ([materials study](materials-study.md)). The V0.25 list is in the git history.

Sourcing preference: parts that builders can buy from mainstream retailers (for example Amazon) come first. Distributor-only parts are used only where no retail part meets the requirement, and the reason is given.

## Estimated cost

Rough figures for the first remote and base, in euros including VAT. Lines marked checked include shipping and, where the shop charged it, customs duty; the rest are estimates that have not been checked against a shop. Many parts only come in packs, kits or minimum orders, so the first build costs much more than each one after it: see [Cost by number of remotes](#cost-by-number-of-remotes).

| Section | Estimate | Basis |
|---|---:|---|
| [Bench prototype](#bench-prototype) | €22–29 | Checked on 2026-10-07; see the section. |
| [Remote: electronics](#electronics) | about €170 with bare boards soldered by hand; more assembled | Bare boards, LCSC parts, USB4736 kits and cables checked on 2026-10-19 and 2026-10-20, with shipping and import charges. The assembled quotes (2026-10-15) do not include import charges. |
| [Remote: hardware](#hardware) | about €75 | Checked on 2026-10-20: AliExpress single-size packs for all the remote's and base's screws, nuts and pins (€35.47 with import charges, after a €27.90 promotion), and the foam sheet (€19.99), and 100 vent labels (€15.89 before import charges). |
| [Printed parts, remote and base](#printed-parts) | €170–196 | Craftcloud quotes of 2026-10-21, EU workshops, with shipping: MJF nylon from one workshop with an FDM TPU keypad, or an ASA remote, a PA12 base and the keypad from three. See [Printed parts](#printed-parts). |
| [Base](#base-one-per-bike) | €6.49 | The spring, checked. Its printed parts are in the line above; its screws, nuts and pins are in the remote's hardware packs. |
| [Consumables](#consumables) | about €31, plus €15–30 of soldering supplies for bare boards | Coating and epoxy checked on 2026-10-20; soldering supplies not checked. |
| **First remote and base, without the bench parts** | **about €470–510** | |

With assembled boards, the board order (mostly fixed fees, extended-part fees and shipping) is the largest item.

### Cost by number of remotes

About €275 of the first build is paid once, whatever the number of remotes: the board order (5 sets of bare boards), the LCSC minimum quantities, the customs duty and shipping on each order, the fastener packs and the consumables. Each further remote and base needs a XIAO (about €12), a LiPo (€5–10) and its printed parts (€170–192 for one set at the 2026-10-21 quotes; several sets in one order probably cost less each, not checked): about €187–214.

| Remotes and bases | Total | Per remote |
|---:|---:|---:|
| 1 | about €470–510 | €470–510 |
| 2 | about €660–720 | €330–360 |
| 5 | about €1,240–1,390 | €250–280 |

The 5-remote line adds an estimated €20 for the larger LCSC and USB4736 quantities (not checked); the fastener packs, the cables, the spring pack, the vent labels and the consumables cover five. The printed parts are the largest per-remote cost. For one remote, a DIY build costs more than a commercial rally remote, about €150 (price not checked here). It is cheaper only when several remotes share one order, for example a group buy.

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
| 1 | JST SH-style cable, 5-pin, female–female, 1 mm pitch, straight (pin 1 to pin 1), 10 cm | [Pololu](https://www.pololu.com/category/350/5-pin-jst-sh-style-cables), or [AliExpress](https://es.aliexpress.com/item/1005011797428966.html) | Joystick board to control board. On AliExpress choose `same direction` (`reverse direction` likely joins pin 1 to the last pin; `single head` has bare wires at one end), 100 mm. |
| 1 | JST SH-style cable, 3-pin, female–female, 1 mm pitch, straight, 10 cm | Pololu, or AliExpress as above | USB-C board to control board. |

The [build guide](build-guide.md) gives the order of the work from these orders to a finished remote.

The board parts with their LCSC numbers are in each board's README and `fab/*-bom.csv`. The KSC221JLFS switches (LCSC C221726) are distributor parts: no retail sealed switch with this footprint was found.

#### Ordering the boards

JLCPCB makes at least 5 of each board and assembles at least 2. Three ways to order, with JLCPCB quotes from 2026-10-15. They include VAT but not shipping, about €10 more. On 2026-10-20 a bare-board order for the three boards was charged a further €31.56 in import charges (breakdown not known), so the bare boards came to about €64:

| Option | JLCPCB order | The builder solders | Quote |
|---|---|---|---|
| **Bare boards** (cheapest) | The three `fab/*-gerbers.zip`, no assembly | Every part, from [`electronics/lcsc-parts.csv`](../electronics/lcsc-parts.csv), plus the USB4736 kit | €22.86 for the three boards |
| Economic assembly, bottom side only | Control and joystick with `fab/economic-bottom/`; the USB-C board's top side with its `fab/` files, J1 left unselected | The 7 KSC2 switches, the 2 XIAO headers and the USB4736 kit | €86.27 for the three boards |
| Standard double-sided assembly | Control and joystick as the [panel](../electronics/panel-ctrl-joy/README.md) | Nothing, except the USB4736 if JLCPCB cannot source it | About €134 for control and joystick alone |

The [electronics assembly guide](electronics-assembly.md) gives the soldering order and the tests for bare boards.

`electronics/lcsc-parts.csv` loads into LCSC's BOM tool. Its `Quantity` column covers two remotes with spares, because small parts get lost; `Per remote` gives the exact count. LCSC rounds some quantities up to its minimum order. Two lines with `Per remote` 0 are alternatives, bought now to avoid a second order: the 8.5 mm XIAO headers, if the XIAO's pins do not suit the 5.7 mm ones (see the [control board](../electronics/control-pcb/README.md)), and a 6.8 kΩ R1 for about 150 mA charge current (the 5.1 kΩ in the list gives about 200 mA). Since 1 July 2026 the EU charges €3 customs duty per tariff class on parcels under €150 from outside the EU, not per part; LCSC's checkout charged €21 for this list on 2026-10-19, with or without the two alternatives, so more parts of a class already in the order add no duty; a later order pays it again. LCSC's checkout total for the list on 2026-10-19 was €55.02: €24.63 parts, €10.07 shipping, €21.00 duty, less a €0.68 discount. That is about €28 per remote. The checkout charged no VAT, so the carrier may collect import VAT (21 % in Spain) and a handling fee on delivery; not checked. The USB4736 kit is not at LCSC.

Hand soldering needs a fine-tipped iron, no-clean flux, 0.5–0.8 mm flux-cored solder and desoldering braid (see [Consumables](#consumables)). The hard parts are the four 1.0 mm-pitch JST SH sockets, the side-looking LED and the USB4736; the 0603 parts and the SOT-23 packages need flux. Solder a spare board first; the joystick board, with four switches and one socket, is the easiest. Check BAT, 5V and 3V3 against GND with a meter before the first power-up.

Estimated cost: about €170 for the first remote with bare boards, including shipping and import charges; most of it also covers a second remote. Assembled boards cost more.

- XIAO with pins: €9.99 before VAT at Kiwi Electronics.
- LiPo: €5–10.
- Boards: the quotes above, plus about €10 shipping and import charges (€31.56 on the bare-board order; see [Ordering the boards](#ordering-the-boards)).
- Parts from LCSC: about €28 per remote with shipping and duty (see above).
- USB4736 kit: three cost €18.63 at TME on 2026-10-19, mostly shipping. Not from DigiKey alone: DigiKey Spain charges €25 shipping below €75.
- Cables, quotes from 2026-10-19 for 5 of each: Pololu USD 21.25 plus USD 26.45 shipping, before EU duty and VAT; DigiKey (Pololu marketplace) €20.25 plus €22.78 shipping. The AliExpress listing gave €12.53 for 10 of each, with shipping and duty. The AliExpress cables are not checked: test a few for pin 1 to pin 1 with a meter and check that they latch in the board sockets.

### Hardware

| Qty | Part | Source | Notes |
|---:|---|---|---|
| 10 | M2 × 10 countersunk screw, ISO 10642 | Retail | Cover, through the button plate (upper facet) and the joystick plate (lower facet). They cut their own thread in Ø1.6 mm pilots in the bosses. |
| 3 | M2 × 8 countersunk screw, ISO 10642 | Retail | Battery cap, into Ø1.6 mm pilots in the housing. |
| 2 | M2 × 8 button-head screw, head at most Ø3.5 × 1.1 mm (ISO 7380 style) | Retail | Joystick board to the joystick plate standoffs. |
| 4 | M2 × 4 button-head screw, head at most Ø3.5 × 1.1 mm (ISO 7380 style) | Retail | Two hold the control board to the button plate standoffs (2.4 mm of thread in a 3.7 mm pilot; M2 × 6 would stand 0.7 mm out of the plate's front). Two hold the USB-C board to its rib, into square nuts (V0.34). |
| 1 | Ø3 × 12 mm steel dowel pin, ISO 8734 | Retail | Joystick stick. |
| 1 | M2 × 4 grub screw | Retail | Joystick knob. |
| 3 | M2 square nut, DIN 562 (4 × 1.2 mm) | Retail | One in the joystick knob, in the slot under it, for the grub screw. Two in the USB-C board's rib, for its screws (V0.34). |
| 1 | Adhesive ePTFE vent label, Ø7.6–8 mm, breathable area at least Ø3 mm, for a Ø3 mm hole | Retail | Inside the battery cap (V0.28). Ø8 mm also clears the cap gasket and the housing (CAD check, 2026-10-20), with 0.9 mm to the opening's edges. |
| 1 | Closed-cell foam sheet, EPDM or neoprene, self-adhesive, 1.5 mm thick, about 150 × 150 mm | Retail (sheet or wide roll) | Both seals and the three pads (V0.32), from one piece: the cover strip, cut 2 mm wide and about 25 cm long in all, on the housing rim (V0.30), and the battery cap gasket (V0.31), each two layers thick since V0.34, cut round the paper templates printed at 100 % from `mechanical/cad/tools/foam-templates-v0.34.scad`, which has every foam piece (its 40 mm bar checks the scale). Soft grade; firm foam needs more screw force. The pads are layers of the same sheet: four on the battery cap, one on the rear wall, and six between the XIAO and the pouch, which hold the XIAO in its headers. |

Estimated cost: about €75.

- Screws, nuts and pins for the remote and the base: €28.10 for 11 single-size packs of 10–100 on AliExpress, all stainless, prices on 2026-10-20 with free shipping. AliExpress adds the import charges at checkout: on 2026-10-20 it estimated €35.27 for the 11 packs, more than the packs themselves (11 × €3 is €33, so it appears to charge per listing, not per tariff class; not confirmed), and took off a €27.90 AliExpress promotion, for a total of €35.47. Without the promotion the order would cost about €63. The packs cover at least five remotes and bases. The listings, by item number on `aliexpress.com/item/<number>.html`:
  - ISO 7380 M2 × 4 and M2 × 8, 50 each: 1005002136729466, €1.86 and €1.96.
  - DIN 7991 M2 × 8 and M2 × 10, 50 each: 32968097507 (HZYUEGOU), €2.06 and €1.96. DIN 7991 is the older standard for the ISO 10642 head.
  - DIN 913 M2 × 4 grub screw, 50: 33030596345 (HZYUEGOU), €2.42.
  - DIN 562 M2 thin square nut, 20: 1005001612157787, €2.69.
  - Dowel pins, Ø1.5 × 4 (100) and Ø3 × 12 (20): 1005012569139327 (HZYUEGOU), €2.69, and 1005007023343232, €2.47. They are GB 119, the Chinese standard for parallel pins, not ISO 8734; not checked against ISO 8734 tolerances.
  - DIN 912 M4 × 16, 10, black-coated stainless: 1005001785489704 (HZYUEGOU), €2.95.
  - DIN 912 M3 × 20, 50, A4 stainless: 1005012860629584, €4.69.
  - DIN 934 M3 nut, 50, black-coated stainless: 1005001639359312 (HZYUEGOU), €2.35. Some listings say "thickened"; the knob's pocket is 2.6 mm deep for a 2.4 mm nut.
- Kits are not worth it: three M2/M3/M4 assortments on Amazon.es came to about €68 on 2026-10-19 for some 2,400 pieces, and lacked the Ø1.5 × 4 pin and the square nut.
- Foam sheet: closed-cell neoprene, self-adhesive, 1.5 mm, 300 mm × 3 m, €19.99 on [Amazon.es](https://www.amazon.es/dp/B0HB4P5PN2) on 2026-10-20. The listing says high density; whether it is soft enough is not checked. Measured on 2026-10-22: about 1.15 mm thick with its adhesive (a stack of five, 5.8 mm), not 1.5 mm. V0.33 compresses the foam to 1.0 mm, so this sheet would seal with only 0.15 mm of squeeze; see the open unknowns in the [mechanical concept](mechanical-concept.md#open-unknowns-before-printing).
- Vent label: 100 ePTFE labels, Ø8 mm outside, Ø4 mm breathable, €15.89 with free shipping on AliExpress (item 1005008646960056, variant OD8 ID4MM 100PCS) on 2026-10-20; the checkout added just over €3 in import charges. Measured: about Ø7.5 mm outside and Ø4.6 mm breathable, which fits the CAD's Ø7.6 mm label and covers the Ø3 mm hole even 0.8 mm off centre. The listing claims IP67 and 120 mbar water entry pressure; not checked. No single-unit retail price was found. Gore adhesive vents come in packs of 50 at about £213 before VAT ([RS UK](https://uk.rs-online.com/web/p/enclosure-ventilation/2842971)), which is too many for one build. Generic ePTFE vent stickers sold in small packs need checking for an IP67 rating before use. Takachi sells its VE8 (Ø7.6 mm) [online](https://takachi-enclosure.com/products/VE8); the price and pack size for one build are not checked.

### Printed parts

| Qty | Part | Material group | Print mode |
|---:|---|---|---|
| 1 | Housing | Remote, rigid | `print_housing` |
| 1 | Control cover | Remote, rigid | `print_cover` |
| 1 | Joystick plate | Remote, rigid | `print_joy_plate` |
| 1 | Ball and disc | Remote, rigid | `print_ball_disc` |
| 1 | Joystick knob | Remote, rigid | `print_knob` |
| 1 | Keypad and gasket, one piece with the three keys | Keypad: soft TPU (85A or softer); it can no longer be cut from sheet, because the keys stand on it | `print_gasket` |
| 1 | Button plate | Remote, rigid | `print_button_plate` |
| 1 | Battery cap | Remote, rigid | `print_battery_cap` |

The base's printed parts are listed under [Base](#base-one-per-bike). Print settings and orientations are in the [mechanical notes](mechanical-concept.md#printing).

The materials are not chosen yet. The [materials study](materials-study.md) recommends PA11 by MJF for the remote's rigid parts (ASA by FDM is the alternative), PA12 by MJF for the base's and TPU near 85A for the keypad. PETG is ruled out: a dark part in the Spanish sun reaches its heat deflection temperature.

Estimated cost, from Craftcloud quotes of 2026-10-21 for the V0.33 files, EU workshops only, shipping to Spain included, VAT not checked:

- All 11 rigid parts of the remote and the base from one MJF workshop: €143.84 in dyed black PA12, €161.49 in dyed black PA11 (WAITKUS 360°, Germany). A PA11 remote with a PA12 base in one order should fall between them; not quoted.
- Remote in black ASA by FDM: €56.99 at 20 % infill (Ľubomír Pavliš, Slovakia), about €74 at 100 %. The base in PA12 apart: €91.97 (Smart Factory, Lithuania).
- Keypad in FDM TPU, Shore 81–90A: €26.14 (Amber Layer, Lithuania) or €30.19 (Imagination 3D, Romania). Ask for the exact filament; the 0.8 mm sheet is under the 1 mm minimum wall given for FDM TPU.

The full list is in the [materials study](materials-study.md#quotes). Orders from outside the EU were cheaper (from about €115 for the rigid parts) but pay import duties.

## Base, one per bike

| Qty | Part | Source | Notes |
|---:|---|---|---|
| 2 | M4 × 16 socket-head screw, ISO 4762 | Retail | Clamp. Cuts its own thread in Ø3.4 mm pilots in the base front. |
| 1 | M3 × 20 socket-head screw, ISO 4762 | Retail | Its head is the lock pin. V0.31 asked for M3 × 22, which is not a standard length. |
| 1 | Compression spring 0.5 × 5 × 10 mm, stainless (wire × outside diameter × free length) | Retail (spring assortments; cut a longer one to length if needed) | Lock. About 4–4.7 N locked and 6–7 N pulled, estimated from the spring measured below. |
| 2 | Ø1.5 × 4 mm steel dowel pin, ISO 8734 | Retail | Quarter-turn lock knob. |
| 1 | M3 nut, ISO 4032 | Retail | Lock knob, in its hex pocket; fixed on the thread with medium-strength threadlocker, or with the clear epoxy (V0.32: no lock nut). |
| 1 | Bike inner tube, butyl, about 0.8–1.2 mm wall; an old one will do | Retail or a used tube | Two anti-rattle strips, 4 × 50 mm, glued into the platform pockets with the clear epoxy. Optionally the two liner halves, 25 × 43 mm (V0.33), instead of the printed TPU. Measure the wall and set `strip_t` (and `liner_radial`) before printing the base front. |
| 1 | Base front | Base, rigid; `print_base_front` | One part for both bar sizes (V0.28). 25 mm wide since V0.33. |
| 1 | Base cap | Base, rigid; `print_base_cap` | |
| 2 | Bar liner half | TPU 95A, `liner_main`, `liner_cap`, or cut from the inner tube | Fits a 25.4 mm bar or the sleeve. |
| 2 | Sleeve half, bars under 25.4 mm only | Base, rigid; `print_sleeve`, with `bar_diameter` set to the bar measured with a caliper | Between the bar and the liner. Painted 7/8 in bars can measure 0.3 mm over 22.2 mm. |
| 1 | Lock knob, Ø16 mm quarter turn | Base, rigid; `print_lock_knob` | Top face on the bed. |

Estimated cost: €6.49 for the spring.

- Printed parts: quoted with the remote's (see [Printed parts](#printed-parts)); the base alone in PA12 by MJF was €91.97 on 2026-10-21.
- Spring: 5 × 0.5 × 5 × 10 mm, 304 stainless, €6.49 on [Amazon.es](https://www.amazon.es/dp/B0C77XC4WS) on 2026-10-20. Spring assortments checked did not have this size, and a 6 mm outside diameter does not fit the Ø6.0 mm pocket.
  Measured on 2026-10-22: 0.5 mm wire, 5 mm outside diameter, 10 mm free length, 7 coils with closed, unground ends (5–6 active), 3.6 mm solid. The lock compresses it to 4.0 mm (`lock_spring_solid`), so it never goes solid. Put the end with the cut tip against the pocket floor, so the tip does not rub the screw head as the knob turns.
- Screws, nut and pins: in the remote's AliExpress packs (see [Hardware](#hardware)).

## Consumables

| Part | Use |
|---|---|
| Conformal coating, acrylic or silicone | The three boards and the XIAO. Keep it off the USB-C sockets, the JST sockets and headers, the switch actuators, the pouch and the vent. |
| Clear two-part epoxy | Filling the charge LED window, potting the back of the charging USB-C receptacle if the leak test fails, fixing the lock knob's nut on its screw if there is no threadlocker, and gluing the anti-rattle strips. One clear epoxy does all four. |
| Medium-strength threadlocker (blue), optional | Fixing the lock knob's nut on its screw, so the setting can be undone. Keep it off the printed knob: Henkel's Loctite 243 data sheet (2008 edition) does not recommend it on plastics, because it can stress-crack thermoplastics. |
| No-clean flux (syringe), 0.5–0.8 mm flux-cored solder, 2 mm desoldering braid, isopropyl alcohol | Bare boards only: hand soldering, and cleaning the flux off before the conformal coating. |

Estimated cost: about €31, plus €15–30 for the soldering supplies (not checked) and €9.38 for the optional threadlocker. They last for many builds.

- Acrylic conformal coating: Kontakt Chemie Plastik 70, 400 ml aerosol, €22.27 on [Amazon.es](https://www.amazon.es/dp/B00VATOHMC) on 2026-10-20; or 200 ml, €21.11 with VAT at [RS Netherlands](https://nl.rs-online.com/web/p/conformal-coatings/0714462).
- Clear two-part epoxy: fischer, 25 ml, €8.86 on [Amazon.es](https://www.amazon.es/dp/B07TS8NX5K) on 2026-10-20.
- Threadlocker: Loctite 243, 5 ml, €9.38 with VAT at [RS Benelux](https://befr.rs-online.com/web/p/thread-lock/4423413), from a search listing on 2026-10-28; the page itself was not opened. Bike shops and hardware stores sell it too.

## Ordering notes

- The three boards can share one JLCPCB order. The USB-C board is 1.2 mm thick and the other two 1.6 mm, so they are separate boards in the order.
- For assembly: the control and joystick boards have parts on both sides, so full assembly is double-sided. Check each part's rotation in JLCPCB's placement preview: the CPL files use KiCad's rotations.
- The cables are straight: pin 1 of one end goes to pin 1 of the other. Check the bought cables before fitting them.
- LCSC numbers and stock were checked in the JLCPCB library on 2026-10-14; stock and prices change.
