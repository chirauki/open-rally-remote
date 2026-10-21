# Print Materials — Study

> Spanish version: [materials-study.es.md](materials-study.es.md).

This study compares the print materials before a print service is chosen. Until V0.32 the docs said "PETG or ASA", which came from what one service listed, not from the conditions on the bike. The study started from V0.32 and led to the 2 mm walls of V0.33; see [With 2 mm walls](#with-2-mm-walls-v033).

**Status:** desk study, 2026-10-20 and 2026-10-21. Values come from datasheets and published tests, cited below. Nothing here has been printed or measured. The material is not chosen yet: the [quotes](#quotes) are in, and the choice is open.

## Conditions

Agreed on 2026-10-20:

- Spanish summer sun: air up to about 40 °C; a dark part in the sun up to about 70 °C. The 70 °C is an estimate: dark parts run 20–30 °C over the air ([QIDI](https://qidi3d.com/en-br/blogs/print-lab/best-filament-car-interiors-abs-asa)).
- Rain, mud and a hose without pressure (about IPX5/6).
- Down to about −5 °C.
- Splashes of fuel, chain oil, cleaners and sunscreen.
- Vibration, knocks, and gloved hands.

The inner parts sit in a dark, sealed box. In the sun they can get almost as hot as the outer parts, so this study does not give them an easier temperature.

## What each part needs

| Part group | Parts | Needs |
|---|---|---|
| Base | base front, base cap, lock knob, sleeve halves | No creep under the clamp preload in the sun; M4 self-tapping threads (Ø3.4 mm pilots); the 0.2 mm dovetail clearance (`dt_c`); knocks |
| Housing | housing | UV; watertight walls (`case_wall`, 2 mm since V0.33, 1 mm before); M2 self-tapping threads (Ø1.6 mm pilots); knocks |
| Covers | control cover, battery cap | UV; flat lands for the foam seals; M2 threads |
| Knobs | joystick knob | UV; knocks |
| Inner plates | joystick plate, button plate | Stiffness; M2 threads; heat inside the box |
| Joystick ball | ball and disc | Wear; the pin press fit in the Ø2.95 mm bore |
| Keypad | keypad and gasket | Soft TPU, 85–88A preferred; 0.8 mm sheet; flexes in the cold; UV on the three keys |

## Rigid candidates

| Material, process | HDT 0.45 MPa | HDT 1.8 MPa | Notes | Source |
|---|---:|---:|---|---|
| PETG, FDM | 68–78 °C | — | Charpy notched 2.6–11.6 kJ/m² by brand | Prusament TDS; [Polymaker](https://wiki.polymaker.com/polymaker-products/polymaker-filaments/technical-data-at-a-glance) |
| ASA, FDM | 92–103 °C | — | Charpy notched 10.3 kJ/m² (Polymaker ASA) | [Polymaker](https://wiki.polymaker.com/polymaker-products/polymaker-filaments/technical-data-at-a-glance), other brands |
| ABS, FDM | 100 °C | — | Charpy notched 18 kJ/m² | [Polymaker](https://wiki.polymaker.com/polymaker-products/polymaker-filaments/technical-data-at-a-glance) |
| PC, PC-ABS, FDM | 111–112 °C | — | Charpy notched 4.1 (PC), 25.8 (PC-ABS) kJ/m² | [Polymaker](https://wiki.polymaker.com/polymaker-products/polymaker-filaments/technical-data-at-a-glance) |
| PA12, MJF | 175 °C | 95 °C | Elongation 12 % XY, 5–9 % Z; water 0.5 % at 50 % RH | [Protolabs](https://www.protolabs.com/media/1010893/2019-mjf-datasheet-pa-12-black.pdf), [JLC3DP](https://jlc3dp.com/help/article/pa12s-hp-nylon) |
| PA11, MJF | 183–185 °C | 50 °C | Elongation 50 %; notched Izod 5–6 kJ/m² | [HP 4AA7-0715EEP](https://3dprinting.com/wp-content/uploads/2019/02/4AA7-0715EEP.pdf), [JLC3DP](https://jlc3dp.com/help/article/pa11-hp-nylon) |
| PP, MJF | 100 °C | — | Elongation 20 %; Charpy notched 3.5 kJ/m² | [Forward AM](https://forward-am.com/material-portfolio/ultrasint-powders-for-powder-bed-fusion-pbf/pp-line/hp-3d-high-reusability-pp-enabled-by-forward-am/) |

Impact values come from different tests (Charpy, Izod) and different processes, so they do not compare across rows.

### Heat and creep

At 70 °C, PETG is at or above its HDT at the low load. The base holds the clamp preload all day in the sun, so PETG would creep and the clamp would loosen. ASA, ABS and PC keep 20–40 °C of margin at 0.45 MPa. PA12 keeps about 100 °C at 0.45 MPa and still 25 °C at 1.8 MPa. PA11 drops to 50 °C at 1.8 MPa, below the 70 °C part, so it is the weaker nylon for the clamp.

### Sun

- ASA is made for outdoor use and resists UV ageing ([INEOS Styrolution, Luran S](https://www.ineos-styrolution.com/Product/Luran-S_ID40070019.html)).
- PA12 loses strength and elongation in UV when it is not dyed. Dyed black, it kept its tensile strength after 1,500 h of ISO 4892-3 UV, with about 15 % embrittlement ([Stratasys, SAF PA12](https://stratasys.co.jp/contentassets/155355c980974a9a9aa809b498f13001/wp_saf_pa12--pp-uv--weathering-exposure_0425a.pdf)). The same paper puts 1,500 h at about 1.5–3 years outdoors. That test used SAF, not MJF. MJF parts are grey outside and black inside ([3DPRINTUK](https://www.3dprint-uk.co.uk/hp-mjf-pa12-nylon-material)); whether an undyed MJF part behaves like the dyed SAF part is not known.
- PP kept its properties after 1,500 h in the same test.
- PETG and PC resist UV moderately.

### Fuel, oil, cleaners and sunscreen

- ASA resists low-aromatic petrol and oils. Aromatic hydrocarbons, esters, ketones and some alcohols attack it ([Wikipedia, citing a datasheet](https://en.wikipedia.org/wiki/Acrylonitrile_styrene_acrylate)). Petrol can contain many aromatics, so ASA is only conditionally resistant to it.
- ABS cracks under stress when petrol, brake fluid or oil reach it ([US patent 5093419](https://image-ppubs.uspto.gov/dirsearch-public/print/downloadPdf/5093419)). Sunscreen also cracks ABS and PC under stress ([SAE 2011-01-0037](https://saemobilus.sae.org/content/2011-01-0037); [ASM IMAT 2025](https://asm.confex.com/asm/imat2025/webprogram/Paper63600.html)).
- Strained PC breaks within seconds in petrol ([SAE 760726](https://saemobilus.sae.org/papers/stress-cracking-plastics-gasoline-760726)).
- PA12 resists oils, greases, aliphatic hydrocarbons and alkalis ([UL Prospector, HP PA12](https://betaplastics.ulprospector.com/plastics/en/datasheet/398134/hp-3d-high-reusability-pa-12)); one table lists diesel and fuel oil ([ARRK](https://media.arrk.com/pdf/eu/es/fichas-tecnicas/tabla-comparativa-materiales-sls-mjf.pdf)). No source names petrol.
- PETG sheet is rated stable in petrol, diesel, engine oil and ethanol at 20 °C, and unstable in acetone (Brett Martin PETG chemical resistance, 2024, via [Sunclear](https://www.sunclear.fr/img/medias/bt/POLYESTER_PETG_INCOLORE_Chemical%20Resistance.pdf)). That is sheet data, not a print.
- No source on sunscreen and polyamide was found.

The threads are where these chemicals do harm: a self-tapping screw leaves the boss under constant stress.

### Watertight walls

FDM layers can leak through a 1 mm wall with two perimeters; this is open point 8 in the [mechanical notes](mechanical-concept.md#sealing). V0.33 makes every housing wall 2 mm, four perimeters with a 0.4 mm nozzle; with 100 % infill or five perimeters the wall is solid. MJF PA12 is sold as "water- and airproof without further treatment" ([Protolabs](https://www.protolabs.com/media/1010893/2019-mjf-datasheet-pa-12-black.pdf)). This is a vendor claim; it is not checked for these walls.

### Tolerances

JLC3DP gives ±0.3 mm up to 100 mm for MJF PA12, and recommends walls over 1.0 mm ([JLC3DP](https://jlc3dp.com/help/article/pa12s-hp-nylon)). The design has features of the same size: the 0.2 mm dovetail clearance, the 0.3 mm key rest gap, and the Ø1.6 mm pilots. A worst-case ±0.3 mm is not compatible with those values, but it is a limit, not the typical error. FDM services do not publish one figure; it depends on the printer. Either way, these features need a check on the first print.

### Impact

Falls are common on tracks and trails, so the remote must take knocks. Two cases differ by about three orders of magnitude.

- **The remote is dropped.** The printed parts of the remote come to 29.7 cm³ in the V0.33 CAD (housing, cover, battery cap, knob, plates, ball; 24.5 cm³ in V0.32), about 30 g in nylon, plus 4 g of keypad. With the boards, the XIAO, the cell and the screws, which are not weighed, the remote is perhaps 50–70 g. A fall from 1.5 m onto rock is then about 1 J. A tough material can absorb that.
- **The bike falls on the remote.** A bike of 150–200 kg falling on its side releases hundreds of joules. If the remote is the first thing to touch the ground, no plastic survives that. The protection there is geometry, not material; see [Crash design](#crash-design).

Comparable values. Notched Charpy is ISO 179/1eA unless stated; notched Izod (ASTM D256) does not compare with it.

| Material, process | Elongation at break XY / Z | Notched impact, 23 °C | Notched impact, −30 °C | Source |
|---|---|---|---|---|
| ASA, FDM (Polymaker) | 6.7 % / 1.65 % | Charpy 10.3 (XY), 6.7 (Z) kJ/m² | — | [Polymaker ASA](https://wiki.polymaker.com/polymaker-wiki-pt/produtos-polymaker/mais-sobre-nossos-produtos/documentos/fichas-tecnicas/abs-asa/polymaker-tm-asa) |
| PA12, MJF (HP) | 18 % / 10 % | Izod 4.5 (XY), 4.4 (Z) kJ/m² | — | HP 3D HR PA 12 sheet, via [MatterHackers](https://www.matterhackers.com/r/V5DB6y) |
| PA12, MJF (JLC3DP) | 12 % / 5 % | Izod 2–2.5 kJ/m² | — | [JLC3DP](https://jlc3dp.com/help/article/pa12s-hp-nylon) |
| PA12, SLS (EOS PA 2200) | 18 % / 4 % | Charpy 4.8 kJ/m²; unnotched 53 kJ/m² | Charpy 4.8 kJ/m² (X) | [EOS PA 2200](https://www.eos.info/polymer-solutions/data-sheets/pds-pa-2200-balance) |
| PA11, MJF (HP) | 50 % / 50 % | Izod 6 (XY), 5 (Z) kJ/m² | — | [HP 4AA7-0715EEP](https://3dprinting.com/wp-content/uploads/2019/02/4AA7-0715EEP.pdf), [JLC3DP](https://jlc3dp.com/help/article/pa11-hp-nylon) |
| PA11, SLS (EOS PA 1101) | 30 % / 15 % | Charpy 6.9–7.3 (XY), 5.5 (Z); unnotched no break (XY), 85 (Z) kJ/m² | Charpy 5.8–6.3 (XY), 5.1 (Z); unnotched 70 (Z) kJ/m² | [EOS PA 1101](https://www.eos.info/fr/solutions-polymeres/materiaux-polymeres/fiches-techniques/mds-pa-1101) |

What the table says:

- **ASA by FDM is tough along the layers and brittle across them.** It breaks at 1.65 % strain in Z. A knock on a corner of the housing splits it along a layer line, and those layers are the walls round the cell.
- **PA12 is notch-sensitive.** Its notched values are the lowest of the nylons, and screw bosses, corners and the dovetail groove are notches. Sintered PA12 also loses impact strength in the cold: laser-sintered specimens gained 20–47 % from −25 °C to 60 °C in Izod ([Korea Science](https://www.koreascience.or.kr/article/JAKO201835372298728.page)).
- **PA11 is the tough one.** It stretches 50 % before it breaks (HP), keeps most of its impact strength at −30 °C (EOS), and does not break unnotched in XY. HP calls it a material of "exceptionally high ductility and impact strength". Its weak point is the 50 °C HDT at 1.8 MPa.

The split follows from that: the remote takes the knocks and carries no sustained load; the base carries the clamp preload all day in the sun.

### Crash design

Material only covers the dropped remote and small knocks. For a fall of the bike, these matter more; none is checked yet:

- **Stay inside the protected envelope.** The remote should sit behind the handguard or the bar end, so the ground touches them first. Where it sits depends on the bike and the handguards; this is an open point.
- **Let the clamp slip.** The clamp holds about 3.3 N·m (an estimate; see [Base](mechanical-concept.md#v028-changes-from-v027-still-current)). In a fall the remote then turns round the bar instead of breaking, like a lever clamp set loose. Do not tighten the clamp more than the controls need.
- **Protect the cell.** The LiPo pouch sits behind 2 mm walls (1 mm until V0.32). A cracked housing can crush or puncture it. A ductile housing that dents is safer than one that shatters.
- **The knob is a spare.** It stands 5.7 mm out of the cover on a Ø3 mm steel pin. A side hit breaks the knob or bends the pin; both are cheap to replace.
- **The bolt heads bear on the plastic.** The M4 heads seat on a Ø7.0 mm face round the Ø4.3 mm hole, about 24 mm². At the assumed 500 N preload that is about 21 MPa, with no washer. This affects creep in any plastic, not only impact; it is an open point for the base.

### Rejected

- **PETG:** at its HDT in the sun, and it would creep under the clamp. It stays possible only if nothing hot and loaded is made of it, which leaves too few parts to be worth a second material.
- **ABS:** poor UV, and cracks with petrol and sunscreen.
- **PC and PC blends:** crack with petrol and sunscreen.
- **PA11 for the base:** its HDT at 1.8 MPa is 50 °C, below a 70 °C part, and the base holds the clamp preload. PA11 is kept for the remote; see [Impact](#impact).
- **PP:** best UV and chemical resistance, but the design glues to the plastic in three places: the foam strip, the vent label, and the epoxy on the lock screw. PP is hard to bond. Few services offer it.
- **Carbon-filled nylon (FDM):** still FDM layers, and the fibres make it more brittle. It solves nothing that PA12 MJF does not.
- **Resins (SLA):** not studied further. General-purpose resins age in UV and are brittle.

### With 2 mm walls (V0.33)

The first version of this study assumed the 1 mm walls of V0.32. Those walls were set by the NAVCOMM manual's 23 mm of free bar, which is a reference, not a requirement. V0.33 grows them to 2 mm, outward, so the remote is 25 mm wide and 2 mm taller and the cavity does not change. What that changes here:

- **Watertight walls:** with four perimeters, or a solid wall, FDM is no longer a clear leak risk. The leak test decides for any material.
- **Knocks:** a wall's bending strength grows with the square of its thickness, so a 2 mm wall takes about four times the load of a 1 mm wall, in every material. ASA still breaks across its layers at 1.65 % strain, but it needs much more load to get there.
- **Unchanged:** petrol, the heat under the clamp (PA12 for the base), and the sun (ASA is the best).

The gap between PA11 by MJF and ASA by FDM for the remote is smaller than with 1 mm walls. Only a drop test says whether a 2 mm ASA wall is enough for a real fall.

## Flexible candidates (keypad)

| Material, process | Hardness | Notes | Source |
|---|---|---|---|
| Ultrasint TPU 88A, SLS | 88–90A | Tg −48 °C; Charpy notched −10 °C 58–60 kJ/m²; "good UV and hydrolysis resistance"; elongation 270 % XY, 130 % Z | [BASF TDS 2.0](https://info.sculpteo.com/hubfs/Material%20documentation/TPU%2088A/TDS%20Ultrasint%20TPU%2088A_V2.0.pdf) |
| HP TPU, MJF | 88–90A | Similar to the SLS powder | HP; not checked in detail |
| FDM TPU, for example Filaflex 82A | 82A | Elongation 650 % | Recreus |
| FDM TPU 90A / 95A | 90–95A | Elongation 550–590 % | [Polymaker](https://wiki.polymaker.com/polymaker-products/polymaker-filaments/technical-data-at-a-glance) |

A −5 °C morning is far above the −48 °C glass transition of the BASF powder, so cold is not a limit for TPU. The keypad wants 85–88A for the key feel. The powder TPUs are 88–90A, just above that, and the keypad sheet is 0.8 mm, under the 1.0 mm wall that powder services recommend for PA12; their TPU limit is not checked. An FDM TPU near 85A prints a 0.8 mm sheet without that limit.

## Recommendation

Not decided yet. The recommendation as it stands:

- **Remote (housing, cover, battery cap, knob, plates, ball): PA11 by MJF, dyed black if the service offers it.** It is the toughest rigid candidate, also in the cold, and these parts carry no sustained load.
- **Base (base front, base cap, lock knob, sleeve halves): PA12 by MJF.** It has the widest heat margin under the clamp preload. The base is cheap to reprint after a fall.
- Both come from the same process and can go in one order. PA11 for every part would be one material less, but its 50 °C HDT at 1.8 MPa is a risk for the clamp; PA12 for every part would make the remote notch-sensitive.
- **Alternative for the remote: ASA by FDM.** With 2 mm walls it is a reasonable choice: better in the sun, more services, and cheaper on its own. It is still brittle across the layers, so it is the weaker choice for falls. Ask for 100 % infill or at least five perimeters, and wipe off petrol; do not leave it to dry on the part. The base stays PA12 by MJF.
- **Keypad: FDM TPU, 85A or as close as the service offers.** Powder TPU (88–90A) only if the service prints the 0.8 mm sheet.
- **Liners and anti-rattle strips:** bike inner tube, as in V0.32.

## Quotes

Craftcloud quotes of 2026-10-21 for the V0.33 STL files, the sleeve bored for a 22.5 mm bar. Only workshops in the EU are listed, because orders from outside the EU pay import duties. Prices include shipping to Spain; whether they include VAT is not checked. They are a snapshot: Craftcloud prices change with each workshop's load.

| Order | Material | Workshop (country) | Total |
|---|---|---|---:|
| 11 rigid parts | PA12 MJF, dyed black | WAITKUS 360° (Germany) | €143.84 |
| 11 rigid parts | PA11 MJF, dyed black | WAITKUS 360° (Germany) | €161.49 |
| 7 remote parts | PA11 MJF, dyed black | WAITKUS 360° (Germany) | €136.60 |
| 7 remote parts | PA12 MJF, dyed black | STURM Industries (Germany) | €133.32 |
| 7 remote parts | ASA FDM, black, 20 % infill | Ľubomír Pavliš (Slovakia) | €56.99 |
| 4 base parts | PA12 MJF, grey | Smart Factory (Lithuania) | €91.97 |
| 11 rigid parts | ASA FDM, black, 20 % infill | Ľubomír Pavliš (Slovakia) | €76.40 |
| Keypad | TPU FDM, Shore 81–90A, black | Amber Layer (Lithuania) | €26.14 |
| Keypad | TPU FDM, Shore 81–90A, black | Imagination 3D (Romania) | €30.19 |

What the quotes say:

- **The base costs most in MJF.** Ordered apart, it adds a second shipping fee and a second minimum order: PA11 remote plus PA12 base from two workshops comes to €228.57.
- **One MJF workshop for everything costs €144–161.** The best plan for the recommendation is the PA11 remote and the PA12 base in one WAITKUS order. Craftcloud allows a material per part, but this mix is not quoted; it should fall between the two totals above.
- **ASA remote plus PA12 base costs about the same, €149–166,** because the base is PA12 either way. 100 % infill adds about €17 to the ASA remote.
- **All ASA costs half,** but ASA for the base is what the [heat](#heat-and-creep) rules out.
- WAITKUS had one review on Craftcloud on 2026-10-21.
- The keypad adds €26–30. Craftcloud groups Shore 81–90A, so the exact filament has to be asked; the 0.8 mm sheet is under the 1 mm FDM minimum wall Craftcloud gives for TPU.
- Not quoted: the PA11 and PA12 mix in one order, the keypad in MJF TPU from the nylon workshop, and INNOVATIA3D in Spain (its calculator needs a manual upload). Weerg and Sculpteo were not checked. Offers from Singapore, China and India started at about €115 for all parts, before duties.

## Open points

- Whether the chosen service dyes MJF nylon black, and how undyed MJF PA11 and PA12 age in the sun. No UV data for PA11 was found.
- Petrol on PA11 and PA12: no source names it.
- Tolerances on the first print: the dovetail clearance, the key rest gap, the Ø2.95 mm pin bore press fit, and the Ø1.6 mm and Ø3.4 mm pilots.
- Whether the foam strip adhesive and the vent label hold on the rough MJF surface.
- Impact of MJF PA11 and PA12 at −5 °C: only SLS data was found.
- Whether a 2 mm wall is watertight, in MJF nylon or in FDM.
- Where the remote sits against the handguard and the bar end on each bike.
- The bolt head bearing stress on the base cap, with no washer.
- A drop test of the first remote: 1.5 m onto concrete, on each face, at room temperature and after a night in a home freezer (about −18 °C), as the [project brief](project-brief.md) plans. It also says whether 2 mm of ASA is enough.
- The quotes still missing (see [Quotes](#quotes)), and the exact keypad filament.
