# Open Rally Remote

An open-source Bluetooth handlebar remote for motorcycle navigation and digital roadbooks. The project aims to keep the unit compact, rugged, affordable, and buildable one unit at a time by individual makers.

## Project status

Requirements and the first-version concept are being defined. No hardware design or compatibility claim has been validated yet.

See the [project brief](docs/project-brief.md) for the current goals, proposed design, constraints, and development plan. The current [control mapping draft](docs/control-mapping.md) records proposed app profiles and the compatibility checks still needed. The [prototype plan](docs/prototype-plan.md) compares controller candidates and lays out a bench proof of concept. The [XIAO breadboard assembly guide](docs/breadboard-assembly.md) gives a Spain-sourced bill of materials and wiring diagram for the temporary input fixture.

The proposed [firmware specification](docs/firmware-spec.md) defines the first BLE HID approach, input and gesture behavior, app-profile boundaries, bench validation, and the product requirement for phone-based BLE firmware updates.

The [development environment guide](docs/development-environment.md) explains how to set up Arduino IDE 2 for the purchased XIAO nRF52840, upload a smoke-test sketch, and use the Serial Monitor. The [mechanical CAD notes](docs/mechanical-concept.md) document the complete parametric remote assembly: control cover, electronics housing, cable entry, gasket, and 22 mm handlebar clamp.

The first [XIAO diagnostic firmware](firmware/xiao-nrf52840/README.md) reads the breadboard switches and sends BLE HID keyboard events. It has not yet been compiled or tested on the purchased hardware; app profiles and mobile OTA updates remain future work.
