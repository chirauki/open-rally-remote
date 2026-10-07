# Open Rally Remote — Initial Project Brief

## Goal

Design a wireless motorcycle handlebar remote for navigation and roadbook use that is repairable and reproducible by individual makers. The project will publish a complete set of designs so anyone can build one unit for themselves; it is not intended for large-batch production.

Priorities are reliable operation with riding gloves, resistance to rain, dust, and vibration, compatibility with Android and iOS where supported by each app, minimal handlebar space, and low cost without sacrificing reliability.

The Hesa Parts NAVCOMM is a functional reference for a Bluetooth navigation/roadbook remote. This project will create an original design and will not copy its industrial design or firmware.

## Proposed first version (V0)

- Three physical buttons and a joystick as the lowest control. The joystick provides directional input for map or roadbook interaction and has a center press. To preserve a lower-cost option, evaluate two build variants: a joystick with center press and one without. The PCB and firmware should support both variants, with the center-press function disabled when the switch is absent, subject to finding compatible parts and comparing their cost and durability.
- Each of the three buttons supports distinct short-press, long-press, and double-press actions. The joystick center press, when fitted, can also be configured for all three gestures. Joystick directions are separate events.
- Standard BLE HID keyboard input with firmware key profiles. One key map cannot guarantee compatibility with every app, so evaluate profiles for TerraPirata, OsmAnd, DMD² on Android, and a generic keyboard profile, with remapping where feasible.
- A low-power BLE microcontroller module with an integrated antenna. Compare nRF52 and ESP32-C3 options before selecting components.
- Main power from a motorcycle USB outlet at 5 V. The USB connector stays at the outlet end of a cable that enters the remote through a sealed cable gland, avoiding an exposed USB port on the enclosure. Include suitable input protection. A replaceable battery may be considered as a standalone variant after measuring actual power use and runtime. Direct 12 V input may be considered for a future variant.
- A simple two-layer PCB, locking connectors, and mechanical strain relief.
- A two-piece printable enclosure for prototypes; a final design should use a perimeter gasket and sealed buttons. A 3D-printed enclosure alone is not proof of waterproofing.
- A modular handlebar mount for a 22 mm tube in the control area. Builders will need to check clearance with their stock controls and levers.

## Expected compatibility and known limits

| App | Platform | Integration to validate | Scope note |
|---|---|---|---|
| TerraPirata Rally Roadbooks | Android and iOS | Dedicated TerraPirata profile and short/long/double press events | The app documentation describes broad remote compatibility and recommends TerraPirata mode. On iOS, it calls for that mode or the app's compatibility mode. |
| OsmAnd | Android and iOS | Configurable keyboard/external-device profile | OsmAnd documents external keys and custom assignments on both platforms. Available actions and behavior must be checked by app version and OS. |
| DMD² / DMD Next | Android | Generic HID keyboard profile and in-app key mapping | DMD² documents support for generic keyboard/HID remotes. The DMD² navigation app is Android-only; do not claim iOS navigation support. |
| Other apps | Android and iOS | Generic BLE HID keyboard profile; additional community profiles | Each app decides which input events it accepts. Universal app control cannot be guaranteed. |

The remote will interpret short, long, and double presses locally and emit clear HID events. Validation must check that gestures do not generate duplicate or conflicting events.

## Installation requirement

The remote project does not include or install the motorcycle's USB outlet. The builder must provide a suitable 5 V USB outlet; the remote receives power through its sealed cable.

## Design and component selection criteria

1. Prefer parts available from more than one supplier and backed by public datasheets.
2. Compare total BOM cost, including 5 V input protection, cable and sealed cable gland, enclosure sealing, mount, and assembly—not just the microcontroller.
3. Minimize the remote's width and volume on the handlebar while avoiding interference with stock controls and keeping it usable with gloves.
4. Keep the design buildable with common tools: two-layer PCB, hand soldering, and a printable enclosure.
5. Design for rain, dust, vibration, and gloved operation. Define tests before claiming an IP rating.
6. Keep electronics replaceable and publish editable source files, manufacturing files, and a BOM with alternatives.

## Planned open deliverables

- Editable schematic and PCB files, Gerbers, and a BOM with alternatives.
- Firmware, build and update instructions, and button-remapping guidance.
- Parametric CAD for the enclosure, buttons, and mount, plus printable STL files.
- Assembly, verification, and troubleshooting guides.
- Single-unit build instructions covering tools, part alternatives, solder points, and step-by-step checks.
- Explicit licenses for hardware, firmware, and documentation.

## Individual build and fit

The project targets individual builders: anyone should be able to assemble one unit from the published files and guide. The process will not be designed around mass production.

The variety of gloves, handlebars, and stock control assemblies is open-ended and cannot be captured by one fixed requirement. The design will aim for a compact shape and controls usable with motorcycle gloves. Published dimensions and editable models will let each builder check fit on their own bike and adapt the mount. Ergonomics will be evaluated against representative examples without claiming universal fit.

## Development plan

1. Review the [draft control mapping](control-mapping.md) and validate app-specific button actions.
2. Compare BLE modules, switches, sealed cable entry, and input protection using current prices and availability.
3. Prototype BLE HID profiles and validate them on real Android and iPhone devices with TerraPirata, OsmAnd, and DMD².
4. Design the PCB and 22 mm mount/enclosure; check ergonomics and installation on a motorcycle.
5. Iterate through water, dust, vibration, drop, and USB power tests. Document results and limits before making any protection rating claim.

## Reference documentation

- [Hesa Parts NAVCOMM](https://hesaparts.com/product/navcomm/)
- [TerraPirata Rally Roadbooks](https://terrapirata.com/rally-roadbooks/)
- [OsmAnd external input devices](https://www.osmand.net/docs/user/map/interact-with-map/)
- [DMD² devices and generic remotes](https://docs.dmdnavigation.com/dmdnext/devices/)
- [DMD² FAQ: iOS support](https://docs.dmdnavigation.com/faq/)
