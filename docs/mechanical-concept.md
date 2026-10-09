# Mechanical CAD — Button Carrier V0.1

The first CAD part is a dimensioned fit plate for three panel-mounted APEM IS-series pushbuttons. It is based on the manufacturer's published dimensions rather than an illustrative enclosure concept.

**CAD source:** [button-carrier-v0.1.scad](../mechanical/cad/button-carrier-v0.1.scad)

## Dimensions used

| Feature | Dimension | Basis |
|---|---:|---|
| Switch panel cutout | Ø13.6 mm | APEM IS series specification |
| Switch bezel | Ø17.5 mm | APEM IS standard bezel |
| Button center spacing | 20 mm | APEM IS standard matrix spacing |
| Switch rear depth | 13 mm | APEM IS series specification; keepout reference |
| Carrier thickness | 2.5 mm | Within APEM's 1.5–4 mm panel range |
| Carrier outline | 23.5 × 63.5 mm | Bezel envelope plus an explicit 3 mm edge margin |

The three Ø13.6 mm openings are in a straight column at 20 mm pitch. The 3 mm outline margin is a provisional fabrication allowance, not a manufacturer requirement. The outline is only for checking button fit and spacing; it does not define the final remote envelope.

## Component reference

APEM's [IS series](https://www.apem.com/panel-switches/pushbutton-switches/is) provides the dimensional basis. `ISP3SAD2` is a candidate configuration reference (round flat actuator, momentary normally-open contact, solder lugs, black actuator); confirm availability and the exact order code before buying. The manufacturer lists IP67 sealing and a 1,000,000-cycle mechanical life for the series.

The joystick remains unmodeled. Ruffy Controls' [MHS-5-1 datasheet](https://www.farnell.com/datasheets/4534112.pdf) describes a five-way joystick with a top press, M16 × 1 mounting, and a 2–3 mm panel range. Farnell's listing is around €94.67 before VAT, so this is a dimensional reference, not a cost-viable selection. The exact panel opening and rear clearance must be verified from the manufacturer's drawing before adding that cutout.

## Scope and next CAD inputs

This part is not the final enclosure, joystick support, cable entry, PCB carrier, or handlebar clamp. Those features depend on selected components and physical fit constraints. The next CAD revision needs:

- a cost-viable joystick choice and its exact mounting drawing;
- the actual usable 22 mm handlebar section and available length at the intended position;
- the selected PCB, connector, cable gland, and their measured clearances.

Treat this as a first fit-check part only. It does not establish water resistance, impact resistance, glove usability, or road suitability; those require the complete assembly and physical testing.
