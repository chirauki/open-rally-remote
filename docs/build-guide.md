# Build Guide — V0.34

> Spanish version: [build-guide.es.md](build-guide.es.md).

This guide takes a builder from this repository to a finished remote and base on the bike. It gives the order of the work, the decisions to make and the catches found so far. The details stay in the linked documents: the [bill of materials](bom.md), the [electronics assembly guide](electronics-assembly.md), the [mechanical notes](mechanical-concept.md) and the [firmware README](../firmware/xiao-nrf52840/README.md).

**Status: no remote has been built yet.** Every step below comes from the CAD, the datasheets and bench tests of single parts. None has been tried on a complete build. This guide will be corrected after the first one.

## Contents

0. [Before you start](#before-you-start)
1. [Orders](#orders)
2. [While the orders arrive](#while-the-orders-arrive)
3. [Electronics](#electronics)
4. [Preparing the parts](#preparing-the-parts)
5. [Remote assembly](#remote-assembly)
6. [Base on the bike](#base-on-the-bike)
7. [First use](#first-use)
8. [Catches and open points](#catches-and-open-points)

## Before you start

### Cost

The first remote and base cost about €470–510, without the bench prototype parts ([estimate](bom.md#estimated-cost)). A commercial rally remote costs about €150 (price not checked here). About €275 of the first build is paid once: minimum orders, packs, shipping and customs duty. Each further remote costs about €187–214, mostly the printed parts. A DIY build is cheaper than a commercial remote only when several remotes share one order, for example a group buy ([cost by number of remotes](bom.md#cost-by-number-of-remotes)).

### Skills and tools

- **Soldering**, if you order bare boards: 0603 parts, SOT-23 packages and 1.0 mm pitch sockets. The [electronics guide](electronics-assembly.md#tools) lists the tools.
- **OpenSCAD 2026.x**, to set your measurements and export the print files. There is no ready-made print package yet.
- **Arduino IDE 2**, to upload the firmware ([development environment](development-environment.md)). No compiled firmware file is published.
- **Hand tools:**
  - a multimeter;
  - a caliper;
  - a sharp knife and a steel ruler, for the foam;
  - 1.6 mm and 3.4 mm drills, turned by hand;
  - a straight 1.3 mm hex driver with about 75 mm of reach, for the USB-C board screws;
  - a 0.9 mm hex key, for the knob's grub screw.

  The two hex sizes follow from the screw standards (ISO 7380 M2 and DIN 913 M2). They are not checked on the bought screws yet.

### Decisions

- **Boards: bare or assembled.** This guide follows bare boards soldered by hand, the cheapest way. Board makers also assemble boards, at a much higher price; see [Orders](#orders).
- **Print material.** It is not chosen yet. The [materials study](materials-study.md#recommendation) recommends PA11 by MJF for the remote (ASA by FDM is the alternative), PA12 by MJF for the base and TPU near 85A for the keypad.

## Orders

The suppliers below are the ones we used or quoted, with the prices we found in October 2026. They are a suggestion, not a requirement: any supplier that meets the specification will do. Prices, stock and import charges change.

Place all the orders at once. Some come from outside the EU and take weeks. Order the printed parts last (see [While the orders arrive](#while-the-orders-arrive)).

| What | Specification | What we used | Catches |
|---|---|---|---|
| Three circuit boards | 2 layers. Control and joystick boards 1.6 mm; USB-C board **1.2 mm**. Files in each board's `fab/` folder | JLCPCB, bare: €22.86 for the three, plus about €10 shipping and €31.56 import charges | JLCPCB makes at least 5 of each board, so one order covers 5 remotes. The EU makers checked (Eurocircuits, Aisler) do not make the 1.2 mm board at a sensible price ([open unknowns](mechanical-concept.md#open-unknowns-before-printing)). |
| Board parts | [`electronics/lcsc-parts.csv`](../electronics/lcsc-parts.csv), loaded into LCSC's BOM tool | LCSC: €55.02 with shipping and duty, for two remotes with spares | LCSC rounds some quantities up to its minimum order. The EU charges €3 customs duty per tariff class on each parcel, and a second order pays it again. The carrier may collect import VAT on delivery. The KSC221JLFS sealed switches are sold only by distributors. |
| Sealed USB-C receptacle | GCT USB4736-GF-A-**KIT**, with its USBTJ-06 gasket | TME: three for €18.63, mostly shipping | Not at LCSC. JLCPCB's part is the receptacle without the gasket. DigiKey Spain charges €25 shipping below €75. |
| Two cables | JST SH-style, 1 mm pitch, female–female, straight (pin 1 to pin 1), 10 cm: one 5-pin, one 3-pin | AliExpress: 10 of each for €12.53 | Choose `same direction`. Check each cable with a meter for pin 1 to pin 1. |
| XIAO | Seeed XIAO nRF52840 **with pre-soldered pins** (`102010631`), not the Sense model | Kiwi Electronics, €9.99 before VAT | |
| Battery | LiPo pouch with protection board and a JST PH 2.0 lead, at most 6 × 20 × 54 mm, 600 mAh class (602045, 602050) | Retail, €5–10 | The lead must leave the protection board end and be at least about 35 mm long. Check its polarity before you plug it in. |
| Screws, nuts and pins | The [hardware list](bom.md#hardware), remote and base | AliExpress: 11 single-size packs, €35.47 with import charges after a promotion | Each pack holds 10–100 pieces and covers at least five remotes. The import charges appeared to be per listing, not per tariff class (not confirmed): without the promotion the order would cost about €63. |
| Foam sheet | Closed-cell neoprene or EPDM, self-adhesive, soft | Amazon.es, 300 mm × 3 m, €19.99 | Sold as 1.5 mm, measured about 1.15 mm. The seals use two layers of it. Measure yours (see below). |
| Vent label | Adhesive ePTFE, Ø7.6–8 mm, breathable area at least Ø3 mm | AliExpress, 100 for €15.89 plus about €3 import charges | No single labels found. The IP67 rating is the seller's claim. |
| Lock spring | 0.5 × 5 × 10 mm, stainless | Amazon.es, 5 for €6.49 | A 6 mm outside diameter does not fit. |
| Consumables | Conformal coating, clear two-part epoxy; for bare boards, flux, 0.5 mm solder, braid and isopropyl alcohol | Plastik 70 €22.27, fischer epoxy €8.86 (Amazon.es) | |
| Bike inner tube | Butyl, about 0.8–1.2 mm wall | An old one | For the base's anti-rattle strips and, optionally, its bar liner. |

**Assembled boards instead.** JLCPCB assembles at least 2 of each board ([ordering the boards](bom.md#ordering-the-boards)). Quotes of 2026-10-15, before shipping and import charges:
- **Economic assembly, one side:** €86.27 for the three boards. You still solder the 7 switches, the two XIAO headers and the USB4736.
- **Full double-sided assembly:** about €134 for the control and joystick boards alone. Nothing to solder, except the USB4736 if JLCPCB cannot source it.

Other board makers also assemble boards; they were not compared.

## While the orders arrive

### Measure

| Measure | With | Sets | Why |
|---|---|---|---|
| The bar at the clamp | Caliper | `bar_diameter` | Bars under 25.4 mm take the printed sleeve. Painted 7/8 in bars can measure 0.3 mm over 22.2 mm. |
| The inner tube's wall | Caliper | `strip_t`, and `liner_radial` if the liner is cut from the tube | The pocket depth for the anti-rattle strips follows `strip_t`. A tube from 0.78 mm fits. |
| The foam sheet | Caliper, on a stack of five | Nothing yet; compare with 1.15 mm | The seals are sized for two layers of a 1.15 mm sheet ([two-layer foam](mechanical-concept.md#two-layer-foam)). A different thickness needs the CAD checked. |

### Export the print files

Set the measurements in `mechanical/cad/complete-remote-v0.34.scad`, or pass them with `-D`, and export each part with its `part_to_render` mode. For example:

```sh
openscad -o housing.stl -D 'part_to_render="print_housing"' mechanical/cad/complete-remote-v0.34.scad
openscad -o base_front.stl -D 'part_to_render="print_base_front"' -D 'strip_t=0.9' mechanical/cad/complete-remote-v0.34.scad
```

The parts, modes, orientations and print notes are in [Printing](mechanical-concept.md#printing). No part needs supports. The housing and the cover need a brim.

### Order the printed parts

The printed parts are the largest cost of each remote: €170–196 for the remote and the base, from EU workshops ([printed parts](bom.md#printed-parts)). Order them once the electronics work (step 3), so a board problem does not leave you with parts you cannot use.
- **Rigid parts:** ask for solid walls: 100 % infill, or at least five perimeters in FDM. The housing walls must keep water out.
- **Keypad:** soft TPU (85A or softer). Its 0.8 mm sheet is under the 1 mm minimum wall that FDM TPU services give: ask the workshop first.
- **Workshops outside the EU** quoted less but add import duties.

## Electronics

Follow the [electronics assembly guide](electronics-assembly.md). It covers, in this order:
1. soldering the joystick, control and USB-C boards;
2. the cables;
3. power tests without the XIAO;
4. the XIAO, the firmware upload and a function test;
5. the conformal coating, last, once everything works.

Upload the firmware from Arduino IDE 2 ([firmware README](../firmware/xiao-nrf52840/README.md#upload)). On Apple Silicon Macs without Rosetta, the board package's compiler and upload tool do not run; the [firmware README](../firmware/xiao-nrf52840/README.md#build-check) gives a workaround.

**The firmware is bench firmware.** Its README says it is not suitable for use while riding. It is the only firmware so far.

## Preparing the parts

1. **Check the prints.** Look for gaps between layers, holes in the walls and warped faces. Test the pin's press fit in the ball (Ø2.95 mm bore).
2. **Clear the pilot holes** with the drills turned by hand: ten Ø1.6 mm holes in the housing screw bosses, and two Ø3.4 mm holes in the base front. Printed holes come out undersize.
3. **Cut the foam.** Print `mechanical/cad/tools/foam-templates-v0.34.scad` at 100 % on A4. Check its 40 mm bar with a ruler. It has every foam piece and how many of each to cut. Cut the cover seal as one ring: bend it over the fold, do not cut it there.
4. **Leak test, optional.** Before you fit the electronics, close the housing with only the USB-C board, the cover with the keypad and both plates, the foam seals and the battery cap. Hold it a few centimetres under water for 30 minutes with a dry paper towel inside ([the test](mechanical-concept.md#open-unknowns-before-printing)). If you skip it, you do not know whether the USB-C receptacle needs potting, and a leak reaches the coated electronics on the bike. The first build of the project will do it, to check the design.

## Remote assembly

Follow [Assembly](mechanical-concept.md#assembly), steps 1 to 11. The [assembly video](videos/complete-remote-v0.34-assembly.mp4) shows the order. The [USB-C fitting video](videos/usbc-mount-v0.34.mp4) shows step 2 in detail. Catches:
- **USB-C board (step 2).** Push the board toward the wall until its gasket resists, then tighten the two screws. The gasket sets its own squeeze. How hard to push is not measured.
- **Epoxy on the receptacle.** Pot the back of the receptacle only if the leak test shows water coming through it. Potting makes the board unrepairable.
- **Battery (step 8).** Plug the pouch into J5 before you close the housing. The lead should reach with the housing about 14 mm off its seat; this is an estimate. Check the polarity first.
- **Cover screws (step 9).** They cut their own thread. Drive them slowly the first time and tighten in a cross pattern.

## Base on the bike

Follow the base steps in [Assembly](mechanical-concept.md#assembly). The lock knob's nut is fixed with epoxy: check the pull and the release before you glue it. On a 22.2 mm bar, fit the sleeve halves round the bar first.

To fit the remote, pull the lock knob, press the remote onto the platform 9 mm below its working position, and slide it up until the lock clicks in.

## First use

1. Charge the remote with any USB-C charger. The red LED beside the charging port lights while the cell charges.
2. Pair **Open Rally Remote** from the phone's Bluetooth settings.
3. Choose a profile: hold the joystick center for 5 s, release it, then press A (TerraPirata), B (keyboard, for DMD2) or C (gestures, for OsmAnd) ([profiles](../firmware/xiao-nrf52840/README.md#profiles)). The board keeps the profile after power off.
4. The keys each profile sends are in the [control mapping](control-mapping.md).

Firmware updates go over BLE from the phone ([BLE OTA update](../firmware/xiao-nrf52840/README.md#ble-ota-update)), so the remote does not need to be opened. Opening it disturbs the seals.

## Catches and open points

- Nothing has been built yet. The open points of the design are listed in [Open unknowns before printing](mechanical-concept.md#open-unknowns-before-printing).
- Minimum orders and packs cover about five remotes: one builder pays for parts that four more remotes could use.
- The USB-C board's 1.2 mm thickness keeps it at makers outside the EU. A 1.6 mm board is planned for its next revision, not designed yet.
- The 1.3 mm and 0.9 mm hex sizes are not checked on the bought screws.
- The battery lead's reach in step 8 is an estimate.
- The foam's softness and its adhesive on two layers are not checked.
- The vent label's IP67 rating is the seller's claim.
- The firmware is bench firmware, not checked while riding.
- The XIAO's profile LED is inside the housing, so the rider cannot see which profile is active. The profile is chosen directly with a button (see [First use](#first-use)), so the rider knows which one was chosen.
