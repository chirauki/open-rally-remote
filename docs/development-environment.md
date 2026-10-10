# Development Environment — XIAO nRF52840

**Status:** setup guide for the first bench prototype. An initial diagnostic sketch is available; it still needs to be uploaded and verified on the purchased hardware.

## What you need

- A computer running Windows, macOS, or Linux.
- [Arduino IDE 2](https://www.arduino.cc/en/software/).
- A USB-C cable that supports data transfer (a charge-only cable will power the XIAO but cannot upload code).
- The purchased Seeed Studio XIAO nRF52840 with its headers already soldered.
- An internet connection for the initial IDE and board-package installation.

No separate programmer, phone app, Python installation, or PlatformIO setup is needed for the first prototype. The phone is used later to test Bluetooth; firmware is uploaded from Arduino IDE over USB.

## Install Arduino IDE and Seeed board support

1. Install and open Arduino IDE 2 from the [Arduino software page](https://www.arduino.cc/en/software/).
2. Open the IDE settings/preferences and add this URL to **Additional Boards Manager URLs**:

   ```text
   https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json
   ```

3. Open **Boards Manager**, search for **Seeed nRF52 Boards**, and install the latest stable version offered by the manager. Record the installed version so firmware builds can later be reproduced.
4. Connect the XIAO to the computer with the USB-C data cable.
5. In **Tools → Board**, select **Seeed nRF52 Boards → Seeed XIAO nRF52840**. Do not select the Sense or Plus model; the purchased board is the standard nRF52840 model.
6. In **Tools → Port**, select the port that appears when the XIAO is connected. If unsure, note the list, unplug the board, and see which port disappears; reconnect it and select that port.

Seeed recommends its **Seeed nRF52 Boards** package for Bluetooth functions. Its package includes the Adafruit Bluefruit nRF52 examples, including a BLE HID keyboard example, so a separate BLE library should not be necessary for the first HID experiment. Seeed's [XIAO nRF52840 guide](https://wiki.seeedstudio.com/XIAO_BLE/) and [Bluetooth usage guide](https://wiki.seeedstudio.com/XIAO-BLE-Sense-Bluetooth_Usage/) describe this setup.

## Confirm the computer can upload code

Before wiring the switches, confirm the environment with a simple example:

1. In Arduino IDE, open **File → Examples → 01.Basics → Blink** (the exact menu grouping may vary slightly by IDE/package version).
2. Confirm the board and port are still set to **Seeed XIAO nRF52840** and the connected XIAO port.
3. Click **Verify** (checkmark). The IDE should compile the example without errors.
4. Click **Upload** (right arrow). Wait for the upload-complete message.
5. Confirm the onboard LED changes state. If the example uses a different LED pattern or polarity, the important result is that upload succeeds and the sketch runs.

Arduino IDE's [upload guide](https://docs.arduino.cc/software/ide-v2/tutorials/getting-started/ide-v2-uploading-a-sketch/) explains the Verify and Upload controls.

## Serial Monitor for debugging

The GPIO test firmware will print input changes to Arduino IDE's **Serial Monitor**. Use **Tools → Serial Monitor** and select the baud rate specified by the sketch (the prototype will start at 115200 baud). The serial monitor is optional for BLE HID operation; it is only a development aid.

If a sketch using `Serial` fails to compile with the Seeed nRF52 package, Seeed documents a package-specific workaround: add `#include <Adafruit_TinyUSB.h>` to the sketch. Try this only when the compiler reports that issue; do not switch to the mbed-enabled board package as a first workaround, since the project needs the Seeed nRF52 Bluetooth stack.

## Open the project firmware when it is added

The initial sketch is [open-rally-remote.ino](../firmware/xiao-nrf52840/open-rally-remote.ino). Open it in Arduino IDE, verify that the Seeed board package and XIAO model are selected, then use **Verify** and **Upload** as above. The [firmware folder README](../firmware/xiao-nrf52840/README.md) gives the pin map and diagnostic test procedure. The sketch compiles with `arduino-cli` (see the firmware README for the toolchain used); it has not yet run on the purchased hardware.

The first project sketch should be uploaded in this order:

1. GPIO input test with the switches wired as documented in the [breadboard assembly guide](breadboard-assembly.md).
2. BLE HID diagnostic profile that sends a simple, distinguishable key for each input.
3. Gesture handling and app-specific mappings after key press/release and reconnection behavior are confirmed.

## Troubleshooting

| Symptom | Check |
|---|---|
| The board does not appear under Ports | Try a known USB-C data cable, connect directly to another USB port, and reopen the Port menu. Charge-only cables are a common cause. |
| The board is missing from the board list | Confirm **Seeed nRF52 Boards** installed successfully in Boards Manager, then restart Arduino IDE. |
| Upload fails or the port disappears during upload | Double-press the XIAO's reset button to enter its USB bootloader, then reselect the port and retry. The board may appear as a USB drive while in bootloader mode. |
| Compilation cannot find a BLE HID header | Confirm the selected board is **Seeed XIAO nRF52840** and the Seeed nRF52 package is installed; then open the Bluefruit `blehid_keyboard` example to check the available library/API. |
| `Serial` does not compile | Follow the Serial note above and the current Seeed documentation for the installed package version. |

## References

- [Arduino IDE downloads](https://www.arduino.cc/en/software/)
- [Arduino IDE 2: board manager](https://docs.arduino.cc/software/ide-v2/tutorials/ide-v2-board-manager/)
- [Arduino IDE 2: upload a sketch](https://docs.arduino.cc/software/ide-v2/tutorials/getting-started/ide-v2-uploading-a-sketch/)
- [Seeed Studio: XIAO nRF52840 setup](https://wiki.seeedstudio.com/XIAO_BLE/)
- [Seeed Studio: Bluetooth HID keyboard example](https://wiki.seeedstudio.com/XIAO-BLE-Sense-Bluetooth_Usage/)
- [Firmware behavior and OTA requirement](firmware-spec.md)
- [Breadboard assembly](breadboard-assembly.md)
