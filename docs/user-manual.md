# User Manual — firmware 0.11.1

> Spanish version: [user-manual.es.md](user-manual.es.md).

This manual is for the rider: how to use the remote once it is built. To build one, see the [build guide](build-guide.md).

**Status:** the firmware is bench firmware. Its README says it is not suitable for use while riding. The timings below are prototype values and may change. No complete remote has been used on a bike yet. This manual follows the firmware version in its title.

## Contents

1. [Controls](#controls)
2. [On the bike](#on-the-bike)
3. [Charging](#charging)
4. [Pairing](#pairing)
5. [Switching on and off](#switching-on-and-off)
6. [Profiles](#profiles)
7. [What each control does](#what-each-control-does)
8. [Setting up the apps](#setting-up-the-apps)
9. [Firmware updates](#firmware-updates)
10. [Care](#care)
11. [Problems](#problems)
12. [Known limits](#known-limits)

## Controls

![The remote from the rider's side: keys A, B and C on the upper face, the joystick on the lower face.](images/complete-remote-v0.34-side.png)

- **Buttons A, B and C**, from top to bottom, on the upper face.
- **Joystick** on the lower face. Tilt it up, down, left or right.
- **Joystick center:** push the stick straight in.

A button knows three gestures: a short press, a long press (held 0.6 s; 2 s for the TerraPirata resets) and a double press (two presses within 0.3 s). Each profile uses only some of them.

## On the bike

**To fit:**
1. Pull the lock knob under the base and hold it.
2. Press the remote onto the platform, 9 mm below its working position.
3. Slide it up until it stops.
4. Release the knob. The lock clicks in.

**To remove:** pull the lock knob, slide the remote down and lift it off.

![Fitting: the remote held off the platform, 9 mm below its working position, with the lock knob pulled.](images/complete-remote-v0.34-entry.png)

## Charging

1. Take the remote off the base. The charging port is in its rear face, under the platform.
2. Plug in any USB-C charger and cable.
3. The red LED beside the port lights while the battery charges and goes out when it is full.

A charge from empty takes an estimated 3–4 hours (not measured). The remote works while it charges. It does not switch off on USB power.

The remote reports its battery level over Bluetooth. Some phones show it in the Bluetooth settings; an app that reads the Bluetooth battery level shows it too. Which phones show it is not checked. When the battery falls very low, the remote switches itself off.

## Pairing

1. Wake the remote: press any button.
2. On the phone, open the Bluetooth settings and pair **Open Rally Remote**. It pairs as a keyboard.
3. Open the app. Each profile suits one app; see [Profiles](#profiles).

After that, the phone reconnects by itself, about 1 s after the remote wakes.

## Switching on and off

- **On:** press any button or tilt the joystick. That press only wakes the remote; it is not sent to the app.
- **Off:** hold A, B and C together for 3 s, then release them. The remote sleeps.
- **Auto-off:** after 6 hours without a press.
- **Low battery:** the remote switches off by itself.
- **On USB power** the remote never switches off.

## Profiles

The remote has three profiles. It keeps the chosen one when it switches off. The first start uses TerraPirata.

| Button | Profile | For |
|---|---|---|
| A | TerraPirata | TerraPirata Rally Roadbooks |
| B | Keyboard | DMD² and other apps that let you assign keys |
| C | Gestures | OsmAnd |

**To choose a profile:**
1. Hold the joystick center for 5 s, then release it.
2. Within 5 s, press and release A, B or C.
3. The remote restarts in that profile. The phone reconnects without pairing again.

If you press nothing, or two buttons together, nothing changes. Choosing the profile already in use changes nothing either. While you choose, no key goes to the app.

## What each control does

Short / long / double press. A dash means nothing.

| Control | TerraPirata | Keyboard | Gestures (OsmAnd) |
|---|---|---|---|
| A | — / reset the trip (2 s; confirm on the screen) / — | holds `A` | map orientation / navigation / next OsmAnd profile |
| B | — / reset the total (2 s) / — | holds `B` | zoom out / search / — |
| C | lock or unlock the screen / — / — | holds `C` | zoom in / screen lock / — |
| Joystick up, down | scroll the roadbook | arrow keys | pan the map |
| Joystick left, right | trip − / + | arrow keys | pan the map |
| Joystick center | — | `D` on a short or double press | my position |

- **TerraPirata:** short presses of A and B do nothing, so a stray press resets nothing. The trip reset opens TerraPirata's dialog; tap the screen to accept it.
- **Keyboard:** each button holds its key while you press it. The app times short and long presses itself.
- **Gestures:** a press of A waits 0.3 s, in case a second press follows. B and C act at once.

The keys behind each action are in the [control mapping](control-mapping.md).

## Setting up the apps

- **TerraPirata:** nothing to set up. Tested on Android; iOS not tested.
- **OsmAnd:** in each OsmAnd profile used on the bike, open *External input devices*:
  - Android: *Menu → Configure profile → General settings → Other → External input devices*.
  - iOS: *Menu → Settings → App profiles → General settings → External input devices*.

  Choose the built-in "Keyboard" type, and everything works except the screen lock. For the screen lock too, create a custom type and assign each key of the [OsmAnd table](control-mapping.md#osmand-android-and-ios), and `x` to "Touch screen lock". iOS is not tested.
- **DMD²:** use the keyboard profile and assign the keys in DMD²'s Generic Remote settings. DMD² may need a licence for it. The assignments are not tested yet.

## Firmware updates

Updates go over Bluetooth from an Android phone with nRF Connect for Mobile. The remote does not need to be opened. The steps are in the [firmware README](../firmware/xiao-nrf52840/README.md#ble-ota-update). There is no published firmware file yet.

## Care

- **Do not open the remote** unless you must. Each opening disturbs the seals.
- **Water:** the remote is sealed against rain. Do not use a pressure washer on it. Its rating is not tested.
- **Cleaning:** a damp cloth. Keep solvents and fuel off the keys.
- **Charging port:** let it dry before you charge. On the bike the base covers it.
- **Battery:**
  - Store the remote charged to about half if you do not ride for months.
  - Do not leave it in a closed car in the sun.
  - If the case swells or gets hot, stop using it.

## Problems

| Problem | Try |
|---|---|
| The phone does not connect | Press a button to wake the remote. If it still does not connect, remove **Open Rally Remote** from the phone's Bluetooth devices and pair again. |
| A press does nothing | Check the profile: choose it again (see [Profiles](#profiles)). Check the app's key settings. |
| The remote does not wake | Charge it. |
| After a cancelled update the remote does not reconnect | Force-stop nRF Connect on the phone, then wake the remote. |
| The red LED stays on for many hours | The charger may not end the charge (an open point of the design). Unplug the charger. |

## Known limits

- **No status light in use.** The remote's only status light is inside the case. Low battery and power off cannot be seen. Check the battery level on the phone. A status light on the charging LED is proposed for a later board revision; it needs new boards.
- **No password on updates.** Anyone in Bluetooth range can update the firmware. This is acceptable on the bench only.
- **Bench firmware**, not tested while riding.
