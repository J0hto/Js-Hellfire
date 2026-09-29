/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * Standalone namespace adaptation of ACE3 missileguidance
 * fnc_navigationType_direct.sqf. Upstream author: tcvm.
 */
params ["_args", "_timestep", "", "_profileAdjustedTargetPos"];
_args params ["_firedEH", "", "_flightParams"];
_flightParams params ["_pitchRate", "_yawRate"];
_firedEH params ["", "", "", "", "", "", "_projectile"];
private _projectilePos = getPosASLVisual _projectile;

private _targetDirection = _projectilePos vectorFromTo _profileAdjustedTargetPos;
private _projectileDirection = vectorNormalized velocity _projectile;
private _deltaDirection = _targetDirection vectorDiff _projectileDirection;
_deltaDirection = _projectile vectorWorldToModelVisual _deltaDirection;
_deltaDirection = _deltaDirection vectorMultiply [_yawRate, 0, _pitchRate];
_deltaDirection = _projectile vectorModelToWorldVisual _deltaDirection;
private _iTimestep = 0;
if (_timestep != 0) then {_iTimestep = 1 / _timestep};
_deltaDirection vectorMultiply _iTimestep
