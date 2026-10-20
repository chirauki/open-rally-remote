# Key Probe

> Spanish version: [README.es.md](README.es.md).

A bench sketch for the XIAO nRF52840 that sends one candidate key at a time over BLE HID. It finds which keys an app reacts to; TerraPirata's screen lock and partial trip reset are the first targets ([control mapping](../../docs/control-mapping.md)).

The candidates are the keys a commercial rally remote sends (the "offroad Zone V1.4" firmware), each on its own, plus two of its combinations:

| # | Sends |
|---:|---|
| 1 | F6 |
| 2 | F7 |
| 3 | `c` |
| 4 | `z` |
| 5 | `k` |
| 6 | `x` |
| 7 | `r` |
| 8 | Volume −, then F6 |
| 9 | Play/Pause, then `z` |
| 10 | Volume + |
| 11 | Volume − |
| 12 | Right Arrow |
| 13 | Left Arrow |

Candidates 10 to 13 move the trip, to set it away from zero before a reset test.

## Wiring and use

The bench breadboard of the main sketch: Button A on D0, B on D1, C on D2, each to GND.

- **A** sends the selected candidate: key down, 50 ms, key up.
- **B** selects the next candidate, **C** the previous one.
- After each selection, the blue LED blinks the candidate's number. A send flashes the green LED. The buttons are not read while the LED blinks (5 s for candidate 13), so wait for it to finish; the serial log is the reliable record.
- With the Serial Monitor open at 115200 baud, the sketch also prints each selection and send.

It advertises as **ORR Key Probe**. If the phone still has the bench board paired as "Open Rally Remote", it may not connect: forget that device and pair again. Flash the main sketch back afterwards, and pair it again too.

## Test

1. Open TerraPirata with a roadbook and both trips running.
2. Send each candidate once, from 1 to 9. After each one, note what the app did: nothing, screen lock, partial or total trip reset, or anything else.
3. Send each one again to undo it, for example to unlock the screen.

Record the results in [control-mapping.md](../../docs/control-mapping.md).

## Results

Run on 2026-10-20 with an Android phone and TerraPirata. A first pass was guided by the LED and its results were offset by one candidate; they were discarded. The second pass, below, was checked against the serial log, which names every key sent.

| # | Key | TerraPirata |
|---:|---|---|
| 1 | F6 | Scrolls the roadbook down |
| 2 | F7 | Scrolls the roadbook up |
| 3 | `c` | Nothing |
| 4 | `z` | Resets the total |
| 5 | `k` | Nothing |
| 6 | `x` | Locks the screen; a second `x` unlocks it |
| 7 | `r` | Opens the "reset odometer" dialog; accepting it sets the trip to zero |
| 8 | Volume −, then F6 | Scrolls the roadbook down (the trip was at zero) |
| 9 | Play/Pause, then `z` | Resets the total |
| 10 | Volume + | Trip + |
| 11 | Volume − | Trip − |
| 12 | Right Arrow | Trip +, 10 m a tap |
| 13 | Left Arrow | Nothing, with the trip at zero |

## Build

As for the main sketch; see its [README](../xiao-nrf52840/README.md). It compiled on 2026-10-20 with Seeed nRF52 Boards 1.1.13, with no warnings from the sketch, and ran on the bench XIAO for the results above.
