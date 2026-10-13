# Open Rally Remote

> **Designed entirely with AI.** This project, including its requirements, CAD models, electronics, firmware and documentation, has been designed with AI assistants (ChatGPT and Claude). Review it accordingly before building or riding with it.

An open-source Bluetooth handlebar remote for motorcycle navigation and digital roadbooks. The project aims to keep the unit compact, rugged, affordable, and buildable one unit at a time by individual makers.

## Project status

Requirements and the first-version concept are being defined. No hardware design or compatibility claim has been validated yet.

See the [project brief](docs/project-brief.md) for the current goals, proposed design, constraints, and development plan. The current [control mapping draft](docs/control-mapping.md) records proposed app profiles and the compatibility checks still needed. The [prototype plan](docs/prototype-plan.md) compares controller candidates and lays out a bench proof of concept. The [XIAO breadboard assembly guide](docs/breadboard-assembly.md) gives the wiring diagram for the temporary input fixture.

The proposed [firmware specification](docs/firmware-spec.md) defines the first BLE HID approach, input and gesture behavior, app-profile boundaries, bench validation, and the product requirement for phone-based BLE firmware updates.

The [development environment guide](docs/development-environment.md) explains how to set up Arduino IDE 2 for the purchased XIAO nRF52840, upload a smoke-test sketch, and use the Serial Monitor. The [mechanical CAD notes](docs/mechanical-concept.md) document the current NAVCOMM-referenced concept: a battery-powered remote that slides onto a base clamped to the bar (V0.25), raised external controls, and a 23 mm target width along the bar.

The [battery study](docs/battery-study.md) compares battery options and settles on a removable remote with a fixed LiPo pouch, shared between bikes on a sliding dovetail base and charged off the bike (issue #1). V0.24 models it and V0.25 moves the pouch to a battery cap in the bottom end; see the [mechanical CAD notes](docs/mechanical-concept.md). Nothing of it has been built or measured.

The [bill of materials](docs/bom.md) lists every part for the bench prototype, the remote and the base, with sources.

The [joystick PCB](electronics/joystick-pcb/README.md) is a KiCad design for the four joystick switches and the 5 V input protection, with Gerbers and a BOM; it has not been built yet. The [USB-C charging PCB](electronics/usbc-pcb/README.md) carries the sealed charge-only receptacle of V0.24 and V0.25 and its CC pull-downs; it has not been built either.

The first [XIAO diagnostic firmware](firmware/xiao-nrf52840/README.md) reads the breadboard switches and sends BLE HID keyboard events. It reads the joystick center as a chord of the direction switches. It has passed a first bench test on a XIAO with breadboard switches, paired with a phone; app profiles, battery support and mobile OTA updates remain future work.
