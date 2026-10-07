# Prototype Plan — BLE Input Proof of Concept

**Status:** recommendation; no board or component has been purchased or selected for the final design.

## Why prototype before the custom PCB

The main unknown is whether the selected BLE HID reports and press gestures reach the intended actions in TerraPirata, OsmAnd, and DMD² on the target operating systems. A temporary wired-on-bench input fixture lets us answer that without committing to a small enclosure or production PCB.

## Controller candidates

| Candidate | Current reference | Strengths | Trade-offs / checks |
|---|---|---|---|
| Seeed XIAO nRF52840 development board | Listed at $9.99 by Seeed; 21 × 17.8 mm board | Small complete board with integrated antenna, 5 V input, GPIO for the controls, low-power BLE, and published board files. Good candidate for the first HID compatibility prototype. | Costs more than a bare module; verify BLE HID pairing and app behavior on an iPhone and Android device before choosing it for the final unit. |
| ESP32-C3-WROOM-02 module on a custom breakout | Espressif lists a sample reference price around $1.90; module body is 18 × 20 mm | Potentially lower final electronics cost; Espressif's ESP-IDF includes a BLE HID device example that supports ESP32-C3. | The $1.90 figure is a sample reference, not a landed or single-unit total. Requires a carrier PCB and more firmware integration. Verify iOS BLE HID behavior and reconnection before selecting it. |

**Recommended first bench prototype:** use a complete nRF52840 board to reduce bring-up work. Keep ESP32-C3 as the cost-down candidate for the custom PCB, subject to the same app compatibility checks. This is a prototype convenience choice, not a final MCU decision.

Prices above were checked on 2026-10-07 and can change. They exclude shipping, taxes, headers, wiring, and any additional components.

## Purchase options for the nRF52840 prototype board (Spain)

The exact board to search for is Seeed part **102010448**, the standard XIAO nRF52840 without the Sense microphone/IMU. Prices and stock below were checked on 2026-10-07:

| Store | Listing | Price / stock shown | Notes |
|---|---|---|---|
| [Reichelt Spain](https://www.reichelt.com/es/es/shop/producto/xiao_nrf52840_bt5_0_sin_cabezal-358357) | XIAO nRF52840, no headers | €9.56 including VAT, plus shipping; available, estimated 4–5 business days | Lowest verified price found for the standard board. |
| [RS Spain](https://es.rs-online.com/web/p/placas-y-kits-compatibles-con-arduino/2500967) | Manufacturer part 102010448 | €14.59 including VAT; 1,046 units shown available | Higher price, with the exact manufacturer part number and stock clearly listed. |
| [Tiendatec](https://www.tiendatec.es/maker-zone/microcontroladores/xiao/2253-seeed-xiao-nrf52840-ble-8472496026444.html) | Standard XIAO nRF52840 BLE | €11.04; out of stock when checked | Tiendatec identifies itself as an official Seeed distributor in Spain. The Sense variant was listed separately at €18.95 and available, but its extra sensors are unnecessary for this project. |

Amazon.es search results did not provide a reliably verified listing for the exact standard part, so verify the seller, board variant, and manufacturer number **102010448** before ordering there. The links above are direct product pages; stock and prices may change.

## Temporary input fixture

An ordinary solderless breadboard is suitable for the first bench prototype. The XIAO has small castellated pads, so solder 2.54 mm pin headers to the board or use a compatible XIAO breakout adapter before plugging it into the breadboard. Do not try to force the bare board into the breadboard.

Use a USB-powered development board with these inputs on a temporary wiring fixture:

- Three momentary switches for Buttons A, B, and C.
- Four directional momentary contacts for the joystick directions.
- A separate center switch, with a removable jumper/configuration option to simulate the no-center variant.
- A USB 5 V bench supply or ordinary USB power source.

For the easiest digital-input prototype, the four joystick directions can be represented by four separate momentary switches arranged as a directional pad, plus a center switch. Wire each switch between a GPIO and ground and enable the microcontroller's internal pull-up; do not apply 5 V to a GPIO. A candidate analog joystick module can be tried later if that matches the selected mechanical design, using its X/Y outputs on ADC pins and its center switch on a GPIO.

This fixture checks the electrical inputs and BLE behavior only. It is not an ergonomic or waterproof enclosure and should not be used while riding.

## Firmware proof-of-concept scope

1. Advertise and pair as a standard BLE HID keyboard.
2. Send distinct press and release events for each button and joystick direction.
3. Provide a test profile that sends visible, easy-to-identify keys.
4. Add the current TerraPirata, OsmAnd, and DMD² mappings from [control-mapping.md](control-mapping.md), keeping each app's limitations explicit.
5. Implement adjustable debounce and gesture timing only after confirming the app interaction model. Preserve key-release behavior across disconnects so a key cannot remain logically held.
6. Store profile selection and user mappings in a simple, documented way; a companion app is out of scope for this proof of concept.

## Manual validation sequence

1. Confirm the phone/tablet sees and pairs with the remote as a BLE keyboard.
2. Confirm every physical input produces one intended key press and release.
3. Pair with Android and iOS separately; record phone model, OS version, and app version.
4. Validate the published mapping draft in each app, including TerraPirata's required remote/compatibility mode.
5. Test reconnect after remote power loss and app background/foreground transitions.
6. Record unsupported gestures and any differences between Android and iOS; update the compatibility matrix before drawing conclusions.

Do not freeze the final HID key map, MCU, enclosure, or claimed app compatibility until this sequence has been completed on actual devices.

## After the proof of concept

- Choose the lower-cost controller only if it passes the same Android/iOS compatibility checks.
- Select full-size, glove-operable switches and a compact joystick mechanism based on mechanical samples, not on the tiny switches used in the temporary fixture.
- Build a 5 V input stage with suitable protection and cable strain relief.
- Measure the physical layout and available space before designing the compact handlebar enclosure and 22 mm mount.

## References

- [Seeed XIAO nRF52840 product page and current listed price](https://www.seeedstudio.com/Seeed-XIAO-BLE-nRF52840-p-5201.html)
- [Seeed XIAO nRF52840 technical guide, size, pinout, and board files](https://wiki.seeedstudio.com/XIAO_BLE/)
- [Reichelt Spain: XIAO nRF52840 listing](https://www.reichelt.com/es/es/shop/producto/xiao_nrf52840_bt5_0_sin_cabezal-358357)
- [RS Spain: XIAO nRF52840, manufacturer part 102010448](https://es.rs-online.com/web/p/placas-y-kits-compatibles-con-arduino/2500967)
- [Tiendatec: standard XIAO nRF52840 BLE](https://www.tiendatec.es/maker-zone/microcontroladores/xiao/2253-seeed-xiao-nrf52840-ble-8472496026444.html)
- [Espressif ESP32-C3 module options and sample reference prices](https://www.espressif.com/en/products/modules?id=ESP32-C3)
- [Espressif ESP-IDF BLE HID device example](https://github.com/espressif/esp-idf/tree/master/examples/bluetooth/bluedroid/ble/ble_hid_device_demo)
