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

## Temporary input fixture

Use a USB-powered development board with these inputs on a temporary wiring fixture:

- Three momentary switches for Buttons A, B, and C.
- Four directional momentary contacts for the joystick directions.
- A separate center switch, with a removable jumper/configuration option to simulate the no-center variant.
- A USB 5 V bench supply or ordinary USB power source.

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
- [Espressif ESP32-C3 module options and sample reference prices](https://www.espressif.com/en/products/modules?id=ESP32-C3)
- [Espressif ESP-IDF BLE HID device example](https://github.com/espressif/esp-idf/tree/master/examples/bluetooth/bluedroid/ble/ble_hid_device_demo)
