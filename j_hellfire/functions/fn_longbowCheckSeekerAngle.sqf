/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * J's Hellfire adaptation of ACE missileguidance seeker-angle check.
 */
params ["_projectile","_targetPos",["_seekerAngle",70]];
private _toTarget = (getPosASLVisual _projectile) vectorFromTo _targetPos;
private _forward = vectorDirVisual _projectile;
private _dot = (_forward vectorDotProduct _toTarget) max -1 min 1;
(acos _dot) <= (_seekerAngle / 2)
