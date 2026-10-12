# Bill of Materials — V0.24

This is the single parts list for the project: the bench prototype and the V0.24 removable, battery-powered remote with its base. Design details stay in the linked documents; this page lists what to buy.

**Status:** nothing in the V0.24 list has been built or tested.

Sourcing preference: parts that builders can buy from mainstream retailers (for example Amazon) come first. Distributor-only parts are used only where no retail part meets the requirement, and the reason is given.

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
| 1 | Seeed XIAO nRF52840 | As in the bench list | Header spacer and pin length are `MEASURE` values in the CAD. |
| 1 | LiPo pouch with protection board, 6 × 20 × 30 mm (602030), about 300 mAh in listings | Retail | Capacity varies by seller; check the size, the protection board and the maximum charge current (the XIAO charges at 50 or 100 mA). Rechargeable Li-ion/LiPo only. |
| 1 | [Joystick PCB](../electronics/joystick-pcb/README.md), 20.6 × 22.4 × 1.6 mm | JLCPCB or another board house | Gerbers, BOM and placement file in `electronics/joystick-pcb/fab/`. |
| 4 | C&K KSC222JLFS sealed tact switch, 2 N, J-bend | LCSC C221728 | On the joystick PCB. Distributor part: no retail sealed switch with this footprint was found. The gull-wing `G` version does not fit. |
| 1 | Bourns MF-MSMF050-2 PTC fuse, 1812 | LCSC C17313 | On the joystick PCB. |
| 1 | Littelfuse SMBJ5.0A TVS diode, SMB | LCSC C83333 | On the joystick PCB. |
| 1 | [USB-C charging PCB](../electronics/usbc-pcb/README.md), 19 × 13.6 × **1.2** mm | JLCPCB or another board house | Order at 1.2 mm. Files in `electronics/usbc-pcb/fab/`. |
| 1 | GCT USB4736-GF-A-KIT: USB-C receptacle, 6 contacts, charge only, IP67 with USBTJ-06 gasket | DigiKey, Mouser, Farnell, TME | Distributor part: the sealed USB-C parts sold on Amazon either lack the CC pins or are too large for the rear face. |
| 2 | 5.1 kΩ 1 % resistor, 0603 (UNI-ROYAL 0603WAF5101T5E) | LCSC C23186 | On the USB-C PCB. |
| 1 | Lite-On LTST-S270KRKT red side-looking chip LED | LCSC C125114 | Charge LED, on the USB-C PCB. Extended part at JLCPCB. |
| 1 | 1 kΩ 1 % resistor, 0603 (UNI-ROYAL 0603WAF1001T5E) | LCSC C21190 | Charge LED resistor, on the USB-C PCB. |
| 3 | APEM ISR3SAD200 sealed pushbutton: round curved black actuator, NO, solder lugs, IP67, standard bezel, nut and flat seal supplied | DigiKey, RS, L'impulsion | Buttons A, B, C. Distributor part: no retail sealed button with a datasheet was found. About USD 11 each at DigiKey (2026-10-11). |
| — | Hook-up wire, about 28–30 AWG, silicone insulated | Retail | Buttons, joystick PCB and USB-C PCB to the XIAO. |

### Hardware

| Qty | Part | Source | Notes |
|---:|---|---|---|
| 6 | M2 × 8 countersunk screw, ISO 10642 | Retail | Cover, upper facet. |
| 4 | M2 × 10 countersunk screw, ISO 10642 | Retail | Cover, lower facet, through the joystick plate. |
| 10 | M2 heat-set insert, about 4 mm long | Retail | Cover screw bosses. Hole Ø3.2 × 6 mm in the CAD; check against the insert bought. |
| 2 | M2 × 8 button-head screw, head at most Ø3.5 × 1.1 mm (ISO 7380 style) | Retail | Joystick PCB to the plate standoffs. A pan head is too tall. |
| 2 | M2 × 4 thread-forming button-head screw, head at most Ø3.5 × 1.1 mm | Retail | USB-C PCB to its rib. |
| 1 | Ø3 × 12 mm steel dowel pin, ISO 8734 | Retail | Joystick stick. |
| 1 | M2 × 4 grub screw | Retail | Joystick knob. |
| 1 | M2 heat-set insert | Retail | Joystick knob. |
| 1 | Adhesive ePTFE vent label, about Ø10 mm, for a Ø3 mm hole | Retail | Inside the bottom end wall. |
| — | Double-sided foam tape | Retail | Holds the pouch. |

### Printed parts

| Qty | Part | Material | Print mode |
|---:|---|---|---|
| 1 | Housing | PETG or ASA | `print_housing` |
| 1 | Control cover | PETG or ASA | `print_cover` |
| 1 | Joystick plate | PETG | `print_joy_plate` |
| 1 | Ball and disc | PETG | `print_ball_disc` |
| 1 | Joystick knob | PETG or ASA | `print_knob` |
| 1 | Cover gasket | Soft TPU (85A or softer), or cut from silicone or EPDM sheet | `print_gasket` |

Print settings and orientations are in the [mechanical notes](mechanical-concept.md#printing).

## Base, one per bike

| Qty | Part | Source | Notes |
|---:|---|---|---|
| 2 | M4 × 16 socket-head screw, ISO 4762 | Retail | Clamp. |
| 2 | M4 heat-set insert, short | Retail | Hole Ø5.6 × 8.1 mm in the CAD; check against the insert bought. |
| 1 | M3 × 22 socket-head screw, ISO 4762 | Retail | Its head is the lock pin. |
| 1 | Compression spring 0.5 × 5 × 10 mm, stainless (wire × outside diameter × free length) | Retail (spring assortments; cut a longer one to length if needed) | Lock. About 3.4 N locked, estimated. |
| 2 | Ø1.5 × 4 mm steel dowel pin, ISO 8734 | Retail | Quarter-turn lock knob. |
| 1 | M3 heat-set insert | Retail | Lock knob. |
| 1 | M3 nut | Retail | Locks the knob on the screw. |
| 2 | TPU strip, 4 × 50 × 1.4 mm | Printed TPU, or cut from rubber sheet | Anti-rattle, glued into the platform pockets. |
| 1 | Base front | PETG or ASA, `print_base_front` | Set `bar_diameter` to 22.2 or 25.4 mm before exporting. |
| 1 | Base cap | PETG or ASA, `print_base_cap` | |
| 2 | Bar liner half | TPU 95A, `liner_main`, `liner_cap` | |
| 1 | Lock knob, Ø16 mm quarter turn | PETG, `print_lock_knob` | Top face on the bed. |

## Consumables

| Part | Use |
|---|---|
| Conformal coating, acrylic or silicone | XIAO, joystick PCB and solder joints. Keep it off the USB-C sockets, the switch actuators, the pouch and the vent. |
| Two-part epoxy | Potting the back of the charging USB-C receptacle. |
| Clear epoxy or UV-cure resin | Filling the charge LED window. |
| Neutral-cure silicone | Sealing where the notes call for it. |
| Hot glue or silicone | Holding the XIAO's free end in its rails. |

## Ordering notes

- The two PCBs can share one board-house order. The USB-C PCB is 1.2 mm thick and the joystick PCB 1.6 mm, so they are two separate boards in the order.
- The cheapest route for both is to have the small SMD parts assembled (switches, resistors, the charge LED) and to hand-solder the rest: F1 and D1 on the joystick PCB, and the USB4736 on the USB-C PCB.
- LCSC numbers and GCT availability were checked on 2026-10-10, 2026-10-11 and 2026-10-12; stock and prices change.
