# J's Hellfire

Standalone Hellfire addon for **Arma 3** with coded SALH guidance for the AGM-114K/N and a Longbow fire-and-forget path for the AGM-114L.

## Requirements

- Arma 3
- CBA_A3

Full ACE3 is **not required**. Portions of the guidance source are adapted from ACE3 under GPL-2.0-or-later; see [`ACE3-NOTICE.md`](ACE3-NOTICE.md).

## Missiles

| Missile | Role | Guidance |
| --- | --- | --- |
| **AGM-114K** | Anti-armor | Coded SALH, LOBL / LOAL |
| **AGM-114N** | Blast / MAC | Coded SALH, LOBL / LOAL |
| **AGM-114L** | Longbow | Fire-and-forget; uses Arma sensor/lock mechanics for target handoff |

## Controls

- **Hold Left Windows + Mouse Wheel** — open **J's Hellfire System**
- **Ctrl + F** — cycle K/N launch profile
- The K/N HUD shows the active profile and **Seeker Code**
- A selected laser marker/designator shows its **Laser Code**
- AGM-114L uses normal Arma lock/sensor symbology and does not add a custom Hellfire HUD

Available K/N profiles:

`LOBL` · `LOAL-DIR` · `LOAL-LOW` · `LOAL-HI`

> **LOW / HI: 1.7 km+ recommended.** Shots inside 1.7 km can still work, but lofted profiles are less consistent at short range depending on launch altitude, target elevation, terrain, and designation geometry. Use **LOBL / DIR** for closer engagements.

For K/N coded SALH shots, the missile **Seeker Code** must match the designator **Laser Code**.

## Build

Pack the inner `j_hellfire` directory as `j_hellfire.pbo`. The PBO root should contain `config.cpp`, `$PBOPREFIX$`, `functions/`, `Dialog.hpp`, and the `Cfg*.hpp` files.

Load the resulting addon with CBA_A3.

## License & Credits

J's Hellfire is distributed under **GNU GPL version 2 or, at your option, any later version**.

Portions are adapted from **ACE3 (Advanced Combat Environment 3)**. J's Hellfire is an independent derivative project and is not an official ACE3 release. See [`ACE3-NOTICE.md`](ACE3-NOTICE.md) for attribution and the upstream source map, and [`LICENSE`](LICENSE) for the full license terms.
