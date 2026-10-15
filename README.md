# Open Rally Remote

> **Designed entirely with AI.** This project, including its requirements, CAD models, electronics, firmware and documentation, has been designed with AI assistants (ChatGPT and Claude). Review it accordingly before building or riding with it.

An open-source Bluetooth handlebar remote for motorcycle navigation and digital roadbooks. The project aims to keep the unit compact, rugged, affordable, and buildable one unit at a time by individual makers.

## Project status

Requirements and the first-version concept are being defined. No hardware design or compatibility claim has been validated yet.

See the [project brief](docs/project-brief.md) for the current goals, proposed design, constraints, and development plan. The current [control mapping draft](docs/control-mapping.md) records proposed app profiles and the compatibility checks still needed. The [prototype plan](docs/prototype-plan.md) compares controller candidates and lays out a bench proof of concept. The [XIAO breadboard assembly guide](docs/breadboard-assembly.md) gives the wiring diagram for the temporary input fixture.

The proposed [firmware specification](docs/firmware-spec.md) defines the first BLE HID approach, input and gesture behavior, app-profile boundaries, bench validation, and the product requirement for phone-based BLE firmware updates.

The [development environment guide](docs/development-environment.md) explains how to set up Arduino IDE 2 for the purchased XIAO nRF52840, upload a smoke-test sketch, and use the Serial Monitor. The [mechanical CAD notes](docs/mechanical-concept.md) document the current NAVCOMM-referenced concept: a battery-powered remote that slides onto a base clamped to the bar, raised external controls, and a 23 mm target width along the bar. V0.26 is built without soldering: assembled boards, bought cables, a TPU keypad and a plug-in XIAO. V0.27 changes the joystick board so the housing closes onto the stack in a straight line, which V0.26's [path check](docs/assembly-video-v0.26-checks.md) found it could not. V0.28 fits one base to both bar sizes and moves the vent to the battery cap. V0.29 drops the heat-set inserts, so the build needs no hot tool. V0.30 seals the cover with a foam strip, because the keypad sheet could not be squeezed enough by M2 screws. An [assembly video](docs/videos/complete-remote-v0.30-assembly.mp4) with a [path check](docs/assembly-video-v0.30-checks.md) shows the V0.30 steps, with no collisions.

The [battery study](docs/battery-study.md) compares battery options and settles on a removable remote with a fixed LiPo pouch, shared between bikes on a sliding dovetail base and charged off the bike (issue #1). V0.24 models it, V0.25 moves the pouch to a battery cap in the bottom end, and V0.26 fits it protection board up so its lead plugs straight into the control board; see the [mechanical CAD notes](docs/mechanical-concept.md). Nothing of it has been built or measured.

The [bill of materials](docs/bom.md) lists every part for the bench prototype, the remote and the base, with sources.

V0.30 has three KiCad boards, each with Gerbers, a BOM and a placement file for assembly: the [control board](electronics/control-pcb/README.md) (buttons, plug-in XIAO, charger, regulator, sockets), the [joystick board rev C](electronics/joystick-pcb-rev-c/README.md) and the [USB-C charging board rev B](electronics/usbc-pcb-rev-b/README.md). The [joystick board rev B](electronics/joystick-pcb-rev-b/README.md) belongs to V0.26, and the rev A [joystick](electronics/joystick-pcb/README.md) and [USB-C](electronics/usbc-pcb/README.md) boards to V0.23–V0.25. None has been built yet.

The [XIAO bench firmware](firmware/xiao-nrf52840/README.md) reads the breadboard switches and sends BLE HID keyboard and media keys. It reads the joystick center as a chord of the direction switches. It has three profiles, tested on Android: TerraPirata, a keyboard profile with held keys for DMD2, and a gestures profile for OsmAnd; holding the joystick center switches between them. It has passed a first bench test on a XIAO with breadboard switches, paired with a phone. It has also been updated over BLE from an Android phone with the XIAO's factory bootloader, which accepts unsigned images and is not yet the product's update path. The battery firmware (level, charging, power off, auto-off and wake) is written and partly tested on USB; it has not run on a cell yet.
