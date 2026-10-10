# Open Rally Remote

An open-source Bluetooth handlebar remote for motorcycle navigation and digital roadbooks. The project aims to keep the unit compact, rugged, affordable, and buildable one unit at a time by individual makers.

## Project status

Requirements and the first-version concept are being defined. No hardware design or compatibility claim has been validated yet.

See the [project brief](docs/project-brief.md) for the current goals, proposed design, constraints, and development plan. The current [control mapping draft](docs/control-mapping.md) records proposed app profiles and the compatibility checks still needed. The [prototype plan](docs/prototype-plan.md) compares controller candidates and lays out a bench proof of concept. The [XIAO breadboard assembly guide](docs/breadboard-assembly.md) gives a Spain-sourced bill of materials and wiring diagram for the temporary input fixture.

The proposed [firmware specification](docs/firmware-spec.md) defines the first BLE HID approach, input and gesture behavior, app-profile boundaries, bench validation, and the product requirement for phone-based BLE firmware updates.

The [development environment guide](docs/development-environment.md) explains how to set up Arduino IDE 2 for the purchased XIAO nRF52840, upload a smoke-test sketch, and use the Serial Monitor. The [mechanical CAD notes](docs/mechanical-concept.md) document the current NAVCOMM-referenced split-ring concept, with broad tapered shoulders joining the control pod to the clamp, raised external controls, and a 23 mm target width along the bar.

The [battery study](docs/battery-study.md) compares battery options and settles on a removable remote with a fixed LiPo pouch, shared between bikes on a bayonet base and charged off the bike (issue #1). It waits on bench and bike measurements; no CAD has changed yet.

The [joystick PCB](electronics/joystick-pcb/README.md) is a KiCad design for the four joystick switches and the 5 V input protection, with Gerbers and a BOM; it has not been built yet.

The first [XIAO diagnostic firmware](firmware/xiao-nrf52840/README.md) reads the breadboard switches and sends BLE HID keyboard events. It compiles and reads the joystick center as a chord of the direction switches, but has not yet been tested on the purchased hardware; app profiles and mobile OTA updates remain future work.
