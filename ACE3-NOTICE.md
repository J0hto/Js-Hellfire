# ACE3 Attribution and Source Map

J's Hellfire contains source adapted from **ACE3 (Advanced Combat Environment 3)**, licensed under **GNU GPL version 2 or, at your option, any later version**.

Upstream project: <https://github.com/acemod/ACE3>

J's Hellfire is an independent derivative project and is **not** an official ACE3 release. Full ACE3 PBOs are not redistributed by this source package. CBA_A3 remains a runtime dependency.

## AGM-114K / AGM-114N guidance

The v0.10.0 K/N path uses standalone J-namespace adaptations of ACE3 Hellfire and missile-guidance components, including:

- `addons/missileguidance/functions/fnc_guidancePFH.sqf`
- `addons/missileguidance/functions/fnc_doSeekerSearch.sqf`
- `addons/missileguidance/functions/fnc_seekerType_SALH.sqf`
- `addons/missileguidance/functions/fnc_doAttackProfile.sqf`
- `addons/missileguidance/functions/fnc_navigationType_direct.sqf`
- `addons/missileguidance/functions/fnc_navigationType_zeroEffortMiss.sqf`
- `addons/missileguidance/functions/fnc_onFiredGetArgs.sqf`
- `addons/missileguidance/functions/fnc_proNav_onFired.sqf`
- `addons/missileguidance/CfgMissileTypesNato.hpp` (`type_Hellfire`)
- `addons/missileguidance/ACE_GuidanceConfig.hpp`
- `addons/hellfire/functions/fnc_attackProfile.sqf`
- `addons/hellfire/functions/fnc_getAttackProfileSettings.sqf`
- `addons/hellfire/functions/fnc_midCourseTransition.sqf`
- `addons/hellfire/ACE_GuidanceConfig.hpp`
- `addons/hellfire/CfgAmmo.hpp`
- `addons/laser/functions/fnc_seekerFindLaserSpot.sqf`

### Standalone integration changes

Modified for J's Hellfire by Johto, 2026-09-29:

- ACE config-registry values used by the Hellfire path are instantiated locally in `J_fnc_aceCoreInit`.
- ACE's `ace_laser` emitter registry is not imported. J's Hellfire uses Arma `LaserTarget` objects plus user-set four-digit codes, then applies the adapted seeker FOV/range/clustering/LOS selection logic to the reflected points.
- ACE event/debug hooks that require unrelated ACE modules are omitted.
- K/N launch-profile selection, HUD, pylon classes, and code-control UI remain J's Hellfire systems.

## AGM-114L Longbow path

AGM-114L remains on J's pre-v0.10 standalone Longbow path. That path also contains ACE-derived/adapted concepts and code, including Hellfire attack-profile behavior, Direct/ZEM navigation, MWR seeker lifecycle concepts, and the missile-guidance attitude/servo controller. The active source files carry modification notices where ACE-derived code is present.

## Upstream authors

Where known, upstream authors are retained in the headers of the adapted source files. The original ACE3 project and its contributors remain the source of the adapted ACE3 code.

See `LICENSE` for the full GPL terms.
