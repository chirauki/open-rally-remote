# Battery Power and Removable Remote — Study

This study looks at battery power for the remote and at [issue #1](https://github.com/chirauki/open-rally-remote/issues/1), a removable remote on a fixed handlebar base. It starts from V0.23 ([mechanical notes](mechanical-concept.md), [joystick PCB](../electronics/joystick-pcb/README.md)). No CAD has changed yet; the fits below are 2D checks against the V0.23 geometry.

**Status:** study only. Nothing here has been built or measured.

## Summary

- The V0.23 cavity has no room for a swappable cell. The free spaces are about 14 × 19 × 20.6 mm behind buttons A and B, and a 13 × 26 mm strip (in the plane of the clamp) in the solid shoulder between the cavity and the clamp ring.
- A flat 6 × 20 × 22 mm LiPo, not swappable, fits in V0.23 without growing the housing. It crosses the cavity rear wall into the shoulder.
- A swappable 16340 (RCR123A) cell needs a 20 × 44 mm footprint, including its tube and cap. That fits only if the upper end of the pod grows from 44 to about 64 mm above the bar axis, which makes the pod 20 mm longer.
- The XIAO nRF52840 already has a LiPo charger and battery pads. It cannot take a primary cell (CR2450, CR123A) safely, because it would try to charge it.
- A removable remote (issue #1) and a battery inside it fit together: the battery tube sits in the shoulder, which would move from the housing to the remote.

The choices still open are listed at the end.

## What the XIAO nRF52840 provides

From Seeed's XIAO nRF52840 V1.2 KiCad project, exported to a netlist with KiCad 10:

| Function | Circuit |
|---|---|
| Charger | TI BQ25101 linear charger, from VBUS. ISET is 2.7 kΩ, about 50 mA, with a second 2.7 kΩ to P0.13 (`HICHG`): drive P0.13 low for about 100 mA. Seeed lists 50/100 mA. |
| Battery pads | `BAT` pad, on the BQ25101 output. |
| Power path | A MOSFET (LP0404N3T5G) with its gate on VBUS connects the battery to VIN when VBUS is absent. With VBUS present, VIN comes from VBUS through a Schottky diode (SDM20U40), and the battery only charges. |
| Regulator | SGM2040 3.3 V LDO, 250 mA, from VIN. |
| Battery voltage | 1 MΩ / 510 kΩ divider from VBAT to P0.31 (AIN7), switched by P0.14 (`READ_BAT`, active low). |
| Charge status | BQ25101 `CHG` to P0.17, and a charge LED. |
| 5V header pin | Same net as USB-C VBUS, with nothing between them (see the [joystick PCB notes](../electronics/joystick-pcb/README.md#circuit)). |

Consequences:
- **A rechargeable Li-ion or LiPo cell on the `BAT` pad is charged whenever the 5V pin or USB-C has power.** The charger enable is not wired to a GPIO, so the firmware cannot turn charging off.
- **A primary lithium cell (CR2450, CR2477, CR123A) must not go on the `BAT` pad.** The charger would try to charge it whenever 5 V is present. A coin-cell design like the Remotek One needs its own board without a charger.
- With 5 V present (bike cable or base contacts), the remote runs from 5 V and charges the cell at the same time.

## Battery options

| Cell | Size | Capacity | Swappable | Fits V0.23 | Pod growth |
|---|---|---|---|---|---|
| LiPo pouch with protection board (for example 602020) | about 6 × 20 × 22 mm | about 180–250 mAh in listings | No | Yes, across the cavity rear wall | None |
| 16340 / RCR123A Li-ion, protected | Ø16.5–17 × 33.8–36 mm | 650–950 mAh in manufacturer listings | Yes | No | Top end 44 → about 64 mm |
| 14250 Li-ion (½ AA) | Ø14–14.5 × 25–26 mm | 300–600 mAh, vendor claims only; no manufacturer datasheet found | Yes | No | Top end 44 → about 56 mm |
| 10440 Li-ion (AAA size) | Ø10.5 × 44.5 mm | about 350 mAh (typical, not verified) | Yes | No | Top end 44 → about 64 mm |
| CR2450 coin cell | Ø24.5 × 5 mm | about 620 mAh (typical, not verified) | Yes | No | Not usable with the XIAO |

The 16340 is the chosen candidate:
- **Capacity.** It holds three to four times the energy of the pouch that fits.
- **Supply.** Protected 16340 cells and their chargers are sold for flashlights.
- **Sealing.** A screw cap with an O-ring, as on a flashlight, is a well-proven sealed battery closure.

The 16340 is the same size as the primary CR123A (3 V). A CR123A in the remote would be charged by the XIAO; see [Risks](#risks).

### Fit method

The checks use the V0.23 2D profiles in the plane of the clamp, with these keep-outs:
- a 1 mm outer wall;
- 1.5 mm around the clamp ring;
- the XIAO with its pins and rails;
- the buttons, plus 5 mm behind them for wires;
- everything below the fold.

The cell's footprint, including its tube and cap, is searched over positions and angles in 5° steps. The cell's diameter runs along the bar. A 17–20 mm tube fits in the 23 mm width, leaving 1.5–3 mm of wall on each side.

![V0.23 profile with a 6 × 20 × 22 mm LiPo pouch (red, 8 × 24 mm footprint with clearance) in the free space behind the XIAO pins, crossing the cavity rear wall into the shoulder. Buttons in orange, XIAO and joystick PCB in green.](images/battery-study-lipo-v0.23.png)

![The same profile with the top end raised to 64 mm: a 16340 tube (red, 20 × 44 mm footprint) runs diagonally from behind button A into the upper shoulder. The cap end can open on the shoulder face.](images/battery-study-16340-tube.png)

The 16340 tube runs diagonally, at 50° to the bar-to-cover direction, from the top of the cavity into the upper shoulder. The cap end can open on the shoulder face, where it can be reached with the remote on the bar. Growing the top end by 20 mm has not been checked against the bike: mirrors, brake reservoir and switchgear. It needs measuring before CAD work.

## Power architecture for a 16340

Two ways to connect the cell:

| | A: cell on the XIAO `BAT` pad | B: cell into the 5V pin through a diode |
|---|---|---|
| Charging | On board, at 50 or 100 mA, from the bike cable, the base contacts or USB-C; also in an external 16340 charger | External charger only |
| Voltage loss | Only the MOSFET | Two Schottky drops, ours and the XIAO's (about 0.4–0.6 V together). At 3.0 V the 3.3 V rail falls to about 2.5 V. |
| Primary CR123A | Unsafe: it gets charged | Allowed, but only with a diode that blocks any charge current |
| Battery voltage reading | Built-in divider on AIN7 | Needs a divider on another pin |

**Recommendation: A, with rechargeable cells only.** It needs no extra parts and keeps the full voltage. A 900 mAh cell takes about 18 h at 50 mA or 9 h at 100 mA. That is acceptable because the remote charges whenever the bike is on, and a spare cell can be charged outside.

The 100 mA rate should be checked against the cell's maximum charge current. The listings above do not all give a maximum charge current; check the chosen cell's datasheet.

## Runtime estimate

There is no measurement on this firmware yet; the BLE current of the XIAO with Bluefruit is the main unknown. The published figures found:
- XIAO with Arduino/Bluefruit sleep: about 22 µA, measured by a forum user.
- System OFF: 2–3 µA.
- An nRF52840 connected over BLE: from about 0.2 mA (power-profiler estimate at a 40 ms interval) to about 1 mA (a forum report).

| Average current | 250 mAh pouch | 900 mAh 16340 |
|---|---|---|
| 1 mA (connected, short interval) | 10 days | 37 days |
| 0.3 mA (connected, with peripheral latency) | 35 days | 125 days |

These are continuous-connection figures. With the firmware sleeping while the bike is parked and reconnecting on a press, the runtime would be much longer. Measure before choosing a cell; see [Firmware](#firmware).

## Sealing

| Opening | Seal | Risk |
|---|---|---|
| Battery tube cap (new) | Radial O-ring on a smooth land inside the tube mouth, not on the thread | An FDM bore is rough and slightly oval; the land may need reaming, a glued-in sleeve, or a printed and sanded land. Measure leakage on a test piece. |
| Cap electrical contact | Spring in the cap on the cell's negative end, closing through a contact ring at the tube mouth inside the O-ring | The contact and its wire stay inside the seal. Contacts corrode if water gets past the O-ring. |
| Cable gland (current) | Unchanged, if the cable stays | — |

The tube is a separate sealed volume from the electronics cavity. Only two wires pass from the tube into the cavity, sealed when printed or potted. A leak at the cap then wets the cell and its contacts, not the boards.

## Removable remote (issue #1)

A concept, not yet modelled.

**Split.**
- The base is the full clamp ring: both halves and the two M4 bolts, as now.
- The remote is the pod plus the two shoulders. Its back is a saddle over the front half of the ring, wrapping no more than 180°, so it pulls off away from the bar.
- The 16340 tube sits in the upper shoulder, so it stays with the remote.

**Location and lock.**
- A radial key on the ring at the bar-axis height locates the remote and stops it turning around the bar.
- A spring latch holds it on.
- The pull-off direction is the direction button presses push the remote onto the base. So presses load the seat, not the latch.

**Power.**
- The base takes the bike cable and the 5 V protection, and moves the gland to the base.
- Two spring pins in the base meet two flat pads on the remote's saddle. The pads are the XIAO 5V pin and GND.
- With the remote fitted, the bike powers it and charges the cell. Off the bike it runs on the cell.
- A second base with a USB cable charges it at home.

**Points to solve.**
- **Base pins are live when the remote is off.** In rain, 5 V on exposed pins corrodes them. Switch the pins on only when the remote is present, for example with a magnet in the remote and a reed or Hall switch with a load switch in the base. Or use a sealed magnetic pogo connector.
- **USB-C and base power together.** The 5V pin is also USB-C VBUS (see above). With the remote on the base, USB-C must not be connected; in practice the remote is off the base when its cover is opened.
- **Latch strength.** A printed spring latch wears and creeps. Use a steel spring plunger, or a steel pin with a printed lever, and test release force and vibration.
- **Width.** The base and remote must stay within 23 mm along the bar, as now.
- **Sealing.** The saddle pads are a new sealed feature on the remote's back wall. They replace the cable gland on the remote.

The saddle adds material between the ring and the pod. Whether this moves the pod away from the bar has not been checked; it would affect reach to the turn-signal switch, which set the 20° fold.

## Firmware

- **Battery level.** Read AIN7 with P0.14 low. Report it over the BLE Battery Service; Bluefruit has `BLEBas`. Warn below about 3.5 V. Go to System OFF below about 3.3 V, ahead of the cell's protection cut-off.
- **Charging.** Read P0.17 (`CHG`). Drive P0.13 low for 100 mA only if the cell allows it.
- **Base or cable power.** The nRF52840 VBUS pin is on the same net as the 5V pin. Its USB power events can tell the firmware that external power is present, for example that the remote is on a powered base and the bike is on.
- **Sleep and wake.** When parked, or idle for a set time, go to System OFF and wake on any button or joystick switch through GPIO sense. Measure how long a bonded phone takes to reconnect, and whether the first press after wake is lost.
- **Connection parameters.** Measure average current against connection interval and peripheral latency, against the input delay the rider notices.

## Risks

- **Primary CR123A in the 16340 tube.** It is the same size as the RCR123A, and with architecture A the XIAO would charge it whenever 5 V is present. Charging a primary lithium cell can make it vent or catch fire. Mark the tube "Li-ion 3.7 V only", and document it in the assembly and user notes. There is no electrical way to refuse a CR123A with architecture A.
- **Unprotected cells.** The BQ25101 is a charger, not a protection circuit. Use protected 16340 cells only.
- **Heat.** A black remote in the sun can pass 45 °C, the usual maximum for charging Li-ion. The BQ25101 TS input is fixed by a resistor on the XIAO, so the XIAO has no cell temperature cut-off. Check the cell's charge temperature range.

## Decisions needed

1. Accept the pod growth for a swappable 16340 (top end 44 → about 64 mm, after checking the bike), or use the fixed pouch that fits now.
2. Battery architecture A (on-board charging, Li-ion only) or B (external charging, primary cells allowed, lower voltage).
3. Whether to go ahead with the removable remote, and keep the cable variant through the base contacts.

## Sources

- Seeed XIAO nRF52840 [wiki](https://wiki.seeedstudio.com/XIAO_BLE/) and [V1.2 KiCad project](https://files.seeedstudio.com/wiki/XIAO-BLE/Res/260828_Seeed_Studio_XIAO_nRF52840_v1.2.zip) (charger, power path, divider and pin nets).
- 16340 cells:
  - [Keeppower ICR16340 datasheet (NKON)](https://www.nkon.nl/en/amfile/file/download/file/138/product/4135);
  - [Keeppower RCR123A 950 mAh](https://illumn.com/16340-keeppower-950mah-rcr123a2-protected-button-top.html);
  - [Nitecore NL169](https://www.batteryjunction.com/nitecore-nl169);
  - [Olight 16340 test](https://budgetlightforum.com/t/test-review-of-olight-16340-rcr123a-650mah-cyan/38182).
- 14250 cells:
  - [1/2 AA vs 14250](https://batteryequivalents.com/1-2-aa-battery-vs-14250-battery.html);
  - [14250 3.7 V listing](https://makerselectronics.com/product/rechargeable-li-ion-battery-14250-1-2-aa-3-7v-600mah/).
- LiPo pouch listings:
  - [502030, 250 mAh](https://probots.co.in/3-7v-250mah-lipo-battery-502030-open-ended.html);
  - [402025, 150 mAh](https://probots.co.in/3-7v-150mah-lipo-battery-402025-open-ended.html).
- Current figures:
  - [XIAO BLE drawing 570 µA with Zephyr (Nordic DevZone)](https://devzone.nordicsemi.com/f/nordic-q-a/97377/xiao-ble-drawing-570ua-with-zephyr);
  - [nRF52840 battery life estimation (Nordic DevZone)](https://devzone.nordicsemi.com/f/nordic-q-a/63521/nrf52840-battery-life-estimation);
  - [Current consumption for BLE nRF52840 (Nordic DevZone)](https://devzone.nordicsemi.com/f/nordic-q-a/122135/current-consumption-for-ble-nrf52840);
  - [Zephyr XIAO nRF52840 low power](https://github.com/qarnet/Zephyr-XIAO-nRF52840-Ultra-Low-Power).
- [Remotek One](https://www.remotek.no/product-page/remote1) (CR2450, "will last for years"; no current or interval published).
