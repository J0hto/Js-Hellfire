/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * J's Hellfire ACE Zero-Effort-Miss adaptation.
 * targetData = [targetDirection, attackProfileDirection, targetRange,
 *               targetVelocity, targetAcceleration]
 */
params ["_projectile","_targetData",["_navigationGain",3.5]];
_targetData params ["_targetDirection","_attackProfileDirection","_targetRange",
                    "_targetVelocity","_targetAcceleration"];

private _vectorToTarget = _attackProfileDirection vectorMultiply _targetRange;
private _closingVelocity = _targetVelocity vectorDiff velocity _projectile;
private _closingMagnitude = vectorMagnitude _closingVelocity;
private _timeToGo = if (_closingMagnitude == 0) then {0.001} else {_targetRange / _closingMagnitude};
if (_timeToGo == 0) then {_timeToGo = 0.001};

private _zeroEffortMiss = _vectorToTarget vectorAdd (_closingVelocity vectorMultiply _timeToGo);
private _zeroEffortMissProjected =
    _attackProfileDirection vectorMultiply (_zeroEffortMiss vectorDotProduct _attackProfileDirection);
private _zeroEffortMissNormal = _zeroEffortMiss vectorDiff _zeroEffortMissProjected;
_zeroEffortMissNormal vectorMultiply (_navigationGain / (_timeToGo * _timeToGo))
