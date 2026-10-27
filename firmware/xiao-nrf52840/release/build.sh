#!/usr/bin/env bash
# Builds the release files of the XIAO firmware for both boards: the V0.26
# control board (BOARD_V026 true) and the breadboard (false). For each it writes
# the .hex, the DFU .zip (BLE or serial update) and a .uf2 (USB drag and drop),
# plus SHA256SUMS. Used by .github/workflows/firmware.yml; it runs locally too.
#   firmware/xiao-nrf52840/release/build.sh <out dir>
# ARDUINO_CLI picks the arduino-cli binary, ARDUINO_CONFIG an optional config file.
# Needs the Seeeduino:nrf52 core and adafruit-nrfutil on the PATH.
set -euo pipefail

out=${1:?usage: build.sh <out dir>}
here=$(cd "$(dirname "$0")/.." && pwd)
sketch="$here/open-rally-remote.ino"
cli=(${ARDUINO_CLI:-arduino-cli})
[ -n "${ARDUINO_CONFIG:-}" ] && cli+=(--config-file "$ARDUINO_CONFIG")
fqbn=Seeeduino:nrf52:xiaonRF52840

version=$(sed -n 's/^const char \*const FIRMWARE_VERSION = "\(.*\)";/\1/p' "$sketch")
[ -n "$version" ] || { echo "FIRMWARE_VERSION not found in $sketch" >&2; exit 1; }

data=$("${cli[@]}" config get directories.data)
uf2conv=$(find "$data/packages/Seeeduino/hardware/nrf52" -path '*tools/uf2conv/uf2conv.py' | sort | tail -1)
[ -n "$uf2conv" ] || { echo "uf2conv.py not found in the Seeeduino core" >&2; exit 1; }

mkdir -p "$out"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for variant in board-v026:true breadboard:false; do
    name=${variant%%:*}
    flag=${variant##*:}
    src="$work/$name/open-rally-remote"
    mkdir -p "$src"
    sed "s/^constexpr bool BOARD_V026 = false;/constexpr bool BOARD_V026 = $flag;/" "$sketch" > "$src/open-rally-remote.ino"
    grep -q "^constexpr bool BOARD_V026 = $flag;" "$src/open-rally-remote.ino"
    "${cli[@]}" compile -b "$fqbn" --warnings default --output-dir "$work/$name/build" "$src"
    base="$out/open-rally-remote-fw-$version-$name"
    cp "$work/$name/build/open-rally-remote.ino.hex" "$base.hex"
    cp "$work/$name/build/open-rally-remote.ino.zip" "$base.zip"
    # The app starts after the S140 SoftDevice; the hex carries its addresses.
    python3 "$uf2conv" -f 0xADA52840 -c -o "$base.uf2" "$base.hex"
done

(cd "$out" && shasum -a 256 open-rally-remote-fw-"$version"-* > SHA256SUMS)
echo "$version"
