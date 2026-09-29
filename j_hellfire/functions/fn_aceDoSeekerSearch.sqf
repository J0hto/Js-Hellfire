/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * Standalone namespace adaptation of ACE3
 * addons/missileguidance/functions/fnc_doSeekerSearch.sqf
 * Upstream authors: jaynus / nou, PabstMirror.
 */
params ["_unused", "_args", "_seekerStateParams", "_lastKnownPosState", "_timestep"];
_lastKnownPosState params ["_seekLastTargetPos", "_lastKnownPos"];

private _seekerTargetPos = [_args, _seekerStateParams, _timestep] call J_fnc_aceSeekerSALH;

if ((isNil "_seekerTargetPos") || {_seekerTargetPos isEqualTo [0,0,0]}) then {
    if (_seekLastTargetPos && {_lastKnownPos isNotEqualTo [0,0,0]}) then {
        _seekerTargetPos = _lastKnownPos;
    } else {
        _seekerTargetPos = [0,0,0];
    };
} else {
    if (_seekLastTargetPos) then {
        _lastKnownPosState set [1, _seekerTargetPos];
    };
};

_seekerTargetPos
