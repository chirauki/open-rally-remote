Open Rally Remote firmware {{VERSION}} for the Seeed XIAO nRF52840.

**Bench firmware.** It is not suitable for use while riding. A BLE update needs the paired phone and the remote on USB power; once in the bootloader, the board accepts unsigned images.

## Which file

| Board | File |
|---|---|
| V0.26 and later control board (the remote) | `open-rally-remote-fw-{{VERSION}}-board-v026.*` |
| Breadboard prototype | `open-rally-remote-fw-{{VERSION}}-breadboard.*` |

Each board has three files:
- `.uf2`: copy it to the XIAO's USB drive (below).
- `.zip`: DFU package, for an update over BLE from a phone or over USB with `adafruit-nrfutil`.
- `.hex`: the plain image, for other tools.

`SHA256SUMS` holds the checksums.

## Upload

- **Over BLE, the remote closed:** with nRF Connect for Mobile on Android and the `.zip`. The steps are in the [firmware README](https://github.com/chirauki/open-rally-remote/blob/{{TAG}}/firmware/xiao-nrf52840/README.md#ble-ota-update). The board must already run this firmware, which has the BLE update service: a new XIAO gets its first upload over USB.
- **Over USB, drag and drop:** the XIAO's USB-C port is inside the remote, so the cover comes off ([assembly](https://github.com/chirauki/open-rally-remote/blob/{{TAG}}/docs/mechanical-concept.md#assembly)). Connect the XIAO with a data cable and press its reset button twice quickly. A USB drive appears. Copy the `.uf2` onto it. The board restarts with the new firmware. This path is not tested yet.
- **Over USB, command line:** `adafruit-nrfutil dfu serial -pkg <file>.zip -p <port> -b 115200 --singlebank`, after a 1200-baud touch on the port or a double press of reset.

Built by the `firmware` workflow from tag `{{TAG}}`, with Seeed nRF52 Boards {{CORE}}.
