/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * ACE Direct navigation adaptation for v0.8 Longbow.
 * Output is world-space guidance command consumed by the autopilot.
 */
params ["_missile","_aimPos","_dt",["_pitchRate",30],["_yawRate",30]];
private _pos = getPosASLVisual _missile;
private _vel = velocity _missile;
if ((vectorMagnitude _vel) < 0.1) exitWith {[0,0,0]};
private _targetDirection = _pos vectorFromTo _aimPos;
private _projectileDirection = vectorNormalized _vel;
private _deltaDirection = _targetDirection vectorDiff _projectileDirection;
_deltaDirection = _missile vectorWorldToModelVisual _deltaDirection;
_deltaDirection = _deltaDirection vectorMultiply [_yawRate,0,_pitchRate];
_deltaDirection = _missile vectorModelToWorldVisual _deltaDirection;
_deltaDirection vectorMultiply (1 / (_dt max 0.001))
