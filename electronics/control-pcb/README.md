# Control Board (V0.26)

The control board sits behind the upper facet of the V0.26 remote. Its front carries the three button switches; its back carries the XIAO nRF52840 in two female headers, the LiPo charger, the 3.3 V regulator and the connectors for the joystick board, the USB-C charging board and the battery. It is ordered assembled, so the builder does not solder. The design is in the [no-solder assembly spec](../../docs/superpowers/specs/2026-10-14-no-solder-assembly-design.md).

## Parts

Checked in the JLCPCB parts library on 2026-10-14. Stock and prices change; check again before ordering. "Extended" parts add JLCPCB's extended-part fee per unique part.

| Function | Part | LCSC | Library | Stock | Notes |
|---|---|---|---|---|---|
| Button switches ×3 | C&K KSC221JLFS | C221726 | Extended | 17,354 | Same switch as the joystick board |
| LiPo charger | Microchip MCP73831T-2ACI/OT, SOT-23-5 | C424093 | Extended | 11,479 | 4.20 V. Charge current 1000 V / R_PROG: 10 kΩ gives 100 mA. STAT is low while charging, high when done, high-impedance with no input |
| 3.3 V regulator | TI TPS70933DBVR, SOT-23-5 | C89347 | Extended | 45,791 | 1 µA quiescent, 2.7–30 V input, reverse current protection ([TI](https://www.ti.com/product/TPS709)), 300 mV typical dropout |
| Battery reverse-polarity protection | AO3401A P-MOSFET, SOT-23 | C15127 | Basic | 605,007 | In the battery line, conducting both ways when the cell is the right way round |
| 5 V input fuse | Bourns MF-MSMF050-2, 1812 PTC | C17313 | — | — | As on the V0.23 joystick board |
| 5 V input TVS | Littelfuse SMBJ5.0A | C83333 | — | — | As on the V0.23 joystick board |
| Joystick socket (5-pin) | JST SH-compatible "1.0-5P WT", side entry, SMD | C2906271 | Extended | 14,999 | Genuine SM05B-SRSS-TB: C136657, 158 in stock |
| USB-C board socket (3-pin) | JST SH-compatible "1.0-3P WT", side entry, SMD | C2906269 | Extended | 13,209 | Genuine SM03B-SRSS-TB: none in stock |
| Battery socket (2-pin) | JST S2B-PH-SM4-TB(LF)(SN), side entry, SMD | C295747 | Extended | 39,414 | |
| XIAO headers ×2 | 2.54 mm 1×7 female, 5.7 mm high, through hole | C55218877 | Extended | 644 | Standard 8.5 mm alternative: C54876729, 2,409 in stock |

The XIAO nRF52840 is in the JLCPCB library (C37327670 and others) with no stock, so the XIAO is bought separately with pins and plugged in. The PTC and TVS stock was not rechecked.

### USB-C charging receptacle

The GCT USB4736-GF-A is listed in the JLCPCB library only through global sourcing (C9900206672), with no JLCPCB stock on 2026-10-14. JLCPCB buys such parts from a distributor for the order. No other sealed receptacle that keeps the CC pins was found in the library.

### Cables

Retail, pre-crimped at both ends. Amazon listings were not found through web search; that does not mean there are none.

| Cable | Source found | Length |
|---|---|---|
| JST SH-style 5-pin, female–female, 1 mm | [Pololu 5-pin JST SH-style cables](https://www.pololu.com/category/350/5-pin-jst-sh-style-cables) | 10 cm shortest |
| JST SH-style 3-pin, female–female, 1 mm | Pololu's 3-pin range (not checked) | 10 cm shortest |
| JST PH 2-pin extension, male–female | [BerryBase](https://www.berrybase.de/en/extension-cable-2-pin-jst-ph-2.0mm-male-female-awg24-50cm) | 50 cm; shorter not found |

The routes need about 3 cm (joystick) and 4 cm (USB-C). The spare length of a 10 cm cable has to be stowed inside; the CAD checks this. The "1.0 WT" sockets are sold as JST SH compatible; check that a Pololu plug latches in one before ordering the board.

### XIAO pins

The board position depends on the pre-soldered XIAO's header: the plastic spacer height and the pin length below it. Neither is published by Seeed; measure them on the bench XIAO. A pin longer than the 5.7 mm socket is deep holds the XIAO higher than the spacer would.

## Circuit decisions

- **STAT to the XIAO.** The MCP73831 drives STAT up to its input voltage (5 V from USB-C) when charging ends. D8 reads it through a 100 kΩ / 200 kΩ divider, which gives 3.3 V at most. The charge LED on the USB-C board hangs from VBUS to STAT through its resistor, so it lights only while STAT is low (charging).
- **VBUS to the XIAO.** D9 reads VBUS through a 100 kΩ / 200 kΩ divider.
- **Battery voltage.** A0 reads the cell through a 1 MΩ / 1 MΩ divider with 100 nF to ground: 2.1 V at 4.2 V, about 2 µA drawn from the cell.
- **Different socket sizes.** The joystick socket has 5 pins, the USB-C one 3 and the battery one is a 2-pin PH: no cable fits the wrong socket.
