/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * Standalone namespace adaptation of ACE3
 * addons/missileguidance/functions/fnc_doAttackProfile.sqf
 * Upstream authors: jaynus / nou, PabstMirror.
 */
params ["_seekerTargetPos", "_args", "_attackProfileStateParams", "_timestep"];

private _attackProfilePos = [
    _seekerTargetPos,
    _args,
    _attackProfileStateParams
] call J_fnc_aceHellfireAttackProfile;

if ((isNil "_attackProfilePos") || {_attackProfilePos isEqualTo [0,0,0]}) exitWith {[0,0,0]};
_attackProfilePos
