/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * Standalone namespace adaptation of ACE3 Hellfire
 * fnc_getAttackProfileSettings.sqf. Upstream author: PabstMirror.
 */
params ["_seekerTargetPos", "_args", "_attackProfileStateParams"];
_args params ["_firedEH", "_launchParams"];
_launchParams params ["", "", "", "_attackProfile"];
_firedEH params ["", "", "", "", "", "", "_projectile"];

private _configLaunchHeightClear = switch (_attackProfile) do {
    case "hellfire_hi": {304.8};
    case "hellfire_lo": {91.5};
    default {0};
};

private _projectilePos = getPosASL _projectile;
private _startingStage = if (_configLaunchHeightClear > 0) then {
    1
} else {
    [3, 2] select (_seekerTargetPos isEqualTo [0,0,0])
};

_attackProfileStateParams set [0, _startingStage];
_attackProfileStateParams set [1, _configLaunchHeightClear];
_attackProfileStateParams set [2, [
    _projectilePos select 2,
    _seekerTargetPos distance2D _projectilePos
]];
