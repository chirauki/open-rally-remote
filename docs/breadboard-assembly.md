# XIAO nRF52840 Breadboard Assembly

**Status:** bench prototype instructions. This temporary switch fixture is for firmware and BLE experiments; it is not a riding-ready remote.

This guide uses a Seeed XIAO nRF52840 and eight momentary switches to represent the three buttons and a joystick with four directions and an optional center press. It keeps the XIAO off the breadboard and connects it with Dupont leads. Power and programming come from the XIAO's USB-C connector.

## Parts and Spain purchase options

Prices and stock were checked on 2026-10-07. Prices include VAT where the shop displays it, but exclude shipping. The total is a parts estimate across three shops; delivery charges and stock can change.

| Qty | Part | Example purchase | Price checked | Notes |
|---:|---|---|---:|---|
| 1 | Seeed XIAO nRF52840, standard model, no headers (MPN `102010448`) | [Reichelt Spain](https://www.reichelt.com/es/es/shop/producto/xiao_nrf52840_bt5_0_sin_cabezal-358357) | €9.56 | Available, 4–5 business days shown. This is the non-Sense board. |
| 1 | 1×40 male pin strip, 2.54 mm pitch | [Conectrol](https://conectrol.com/producto/tira-de-pines-macho-40p-x1-fila-2-54mm-redondo-recto-pcb/) | €1.60 | Cut two seven-pin sections and solder them to the XIAO. Requires a soldering iron. |
| 1 | 400-point solderless breadboard | [Electrocomponentes](https://www.electrocomponentes.es/placas/277-protoboard-400p-enlazable-con-lineas-400-puntos-blanco.html) | €1.69 | Includes side power rails. |
| 1 set | 40 Dupont jumper wires, male-to-female, 20 cm | [Conectrol](https://conectrol.com/producto/kit-cables-dupont-1p-para-protoboard-m-h-40-unds/) | €3.00 | The female ends fit the XIAO's soldered headers; male ends fit the breadboard. |
| 8 | 6×6×5 mm normally-open tactile switch, 4-pin | [Electrocomponentes](https://www.electrocomponentes.es/pulsadores-pcb/514-mini-pulsador-para-pcb-6x6x5mm-4-pines-spst-no-negro.html) | €0.15 each; €1.20 total | Three buttons, four joystick directions, and one center press. These tiny switches are only bench stand-ins. |
| 1 | USB-A to USB-C data cable | [Goobay 1 m cable, Reichelt Spain](https://www.reichelt.com/es/es/shop/producto/cable_de_carga_y_sincronizacion_usb-c_-_usb-a_60_w_1_-392707) | €6.09 | Optional if you already have a data-capable cable. A charge-only cable will not allow programming. |

**Estimated parts total:** €17.05 without a USB cable, or €23.14 with the listed cable, before shipping. If soldering headers is inconvenient, the pre-soldered XIAO variant (MPN `102010631`) was listed at €12.19 by Reichelt Spain but shown as unavailable when checked; confirm current stock before choosing it.

## Tools

- Soldering iron and solder, only if using the board without headers.
- Small side cutters to cut the pin strip.
- A USB data cable and a computer for programming.
- Optional multimeter to identify which two switch legs form each electrical side.

## Pin assignment

The firmware should configure these GPIOs as inputs with internal pull-ups. Each switch closes its GPIO to ground when pressed, so the released state reads HIGH and the pressed state reads LOW.

| XIAO pin | Breadboard switch | Function |
|---|---|---|
| D0 | SW1 | Button A |
| D1 | SW2 | Button B |
| D2 | SW3 | Button C |
| D3 | SW4 | Joystick up |
| D4 | SW5 | Joystick down |
| D5 | SW6 | Joystick left |
| D6 | SW7 | Joystick right |
| D7 | SW8 | Joystick center press (optional) |
| GND | Blue/negative rail | Shared switch ground |

If building the joystick-without-center variant, leave D7 disconnected and disable that input in firmware. No 3.3 V or 5 V rail connection is needed for this switch circuit.

## Breadboard wiring diagram

Keep the XIAO beside the breadboard rather than forcing the small board into it. Each switch straddles the breadboard's center trench. One electrical side goes to its GPIO row; the other side goes to the blue ground rail. On a standard breadboard, the five holes on each side of a numbered row are connected together, but the two groups across the center trench are separate.

```text
XIAO nRF52840 (kept beside the breadboard)
  D0 ───────────────────────────────────────────────────────┐
  D1 ────────────────────────────────────────────────────┐  │
  D2 ─────────────────────────────────────────────────┐  │  │
  D3 ──────────────────────────────────────────────┐  │  │  │
  D4 ───────────────────────────────────────────┐  │  │  │  │
  D5 ────────────────────────────────────────┐  │  │  │  │  │
  D6 ─────────────────────────────────────┐  │  │  │  │  │  │
  D7 ──────────────────────────────────┐  │  │  │  │  │  │  │
 GND ──────────────────────────────────┼──┼──┼──┼──┼──┼──┼──┼──── blue (−) rail

Breadboard rows (switches straddle the center trench):
                       a b c d e  ║  f g h i j
 Button A / D0 row:    GPIO ──────║───o/ o─────── GND ─── blue (−)
 Button B / D1 row:    GPIO ──────║───o/ o─────── GND ─── blue (−)
 Button C / D2 row:    GPIO ──────║───o/ o─────── GND ─── blue (−)
 Joystick UP / D3:     GPIO ──────║───o/ o─────── GND ─── blue (−)
 Joystick DOWN / D4:   GPIO ──────║───o/ o─────── GND ─── blue (−)
 Joystick LEFT / D5:   GPIO ──────║───o/ o─────── GND ─── blue (−)
 Joystick RIGHT / D6:  GPIO ──────║───o/ o─────── GND ─── blue (−)
 Center press / D7:    GPIO ──────║───o/ o─────── GND ─── blue (−)
                                     switch

USB-C on XIAO ── data cable ── computer / USB supply
```

The diagram is logical: place the eight switches in separate numbered rows and connect each switch's opposite side to the ground rail. The two five-hole groups in each row (a–e and f–j) are not connected across the center trench. Switch leg layout can vary, so check the switch drawing or use continuity mode to identify the internally joined pairs before wiring.

### Wiring steps

1. **Fit the headers.** Solder one 1×7 male header to each long edge of the XIAO, with the pins projecting downward. Avoid solder bridges between adjacent pads. If using a pre-soldered board, skip this step.
2. **Place the switches.** Insert all eight tactile switches across the breadboard's center trench, each on its own row. Keep them spaced and label the rows A, B, C, UP, DOWN, LEFT, RIGHT, and CENTER.
3. **Connect ground.** Use one jumper from a XIAO GND pin to the breadboard's blue/negative rail. If the rail is split halfway along its length, bridge the two rail sections with another jumper.
4. **Connect the GPIO leads.** Connect D0 through D7 to one electrical side of the corresponding switch. Use the pin map above. D7 is optional.
5. **Ground the other switch side.** From the opposite electrical side of each switch, run a jumper to the blue ground rail. These are eight separate ground jumpers unless you use additional breadboard rows as a shared ground bus.
6. **Inspect before power.** Check that no GPIO row is accidentally connected to the red rail. Check that the switch legs span the trench and that each GPIO and ground wire reaches opposite electrical sides of its switch.
7. **Power over USB.** Connect the XIAO's USB-C port to a computer or USB supply using a data-capable cable when programming. Do not feed 5 V into a GPIO, and do not connect a second supply to the breadboard while USB is connected.

## Scope and limitations

This assembly is intended for a desk or bench. Solderless breadboards, exposed Dupont leads, and small tactile switches are not vibration-proof, weatherproof, or glove-friendly. Do not mount or use this prototype on a moving motorcycle. The fixture tests button input and firmware behavior; it does not prove the final joystick mechanism, enclosure, USB power protection, or Android/iOS app compatibility.

## References

- [Seeed XIAO nRF52840 documentation: pinout, power, and board details](https://wiki.seeedstudio.com/XIAO_BLE/)
- [Seeed XIAO nRF52840 product page](https://www.seeedstudio.com/Seeed-XIAO-BLE-nRF52840-p-5201.html)
- [Reichelt Spain: standard XIAO nRF52840 without headers](https://www.reichelt.com/es/es/shop/producto/xiao_nrf52840_bt5_0_sin_cabezal-358357)
- [Conectrol: 40-pin male header strip](https://conectrol.com/producto/tira-de-pines-macho-40p-x1-fila-2-54mm-redondo-recto-pcb/)
- [Electrocomponentes: 400-point breadboard](https://www.electrocomponentes.es/placas/277-protoboard-400p-enlazable-con-lineas-400-puntos-blanco.html)
- [Conectrol: male-to-female Dupont jumper set](https://conectrol.com/producto/kit-cables-dupont-1p-para-protoboard-m-h-40-unds/)
- [Electrocomponentes: 6×6×5 mm tactile switch](https://www.electrocomponentes.es/pulsadores-pcb/514-mini-pulsador-para-pcb-6x6x5mm-4-pines-spst-no-negro.html)
- [Reichelt Spain: USB-A to USB-C data cable](https://www.reichelt.com/es/es/shop/producto/cable_de_carga_y_sincronizacion_usb-c_-_usb-a_60_w_1_-392707)
