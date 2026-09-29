/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * J's Hellfire AGM-114L Longbow path.
 * Standalone adaptation based on ACE3 Hellfire / missileguidance behavior.
 * ACE3 GPLv2-or-later. Full ACE3 is not required at runtime.
 */
private _missile = _this param [0,objNull];
if (isNull _missile) exitWith {};
if ((typeOf _missile) != "J_Hellfire_AGM114L") exitWith {};
private _target = missileTarget _missile;
private _parents = getShotParents _missile;
private _shooter = _parents param [0,objNull];
private _platform = _shooter;
if (!isNull _shooter && {_shooter isKindOf "Man"}) then {_platform = vehicle _shooter};
_missile setVariable ["J_Longbow_Platform",_platform];
_missile setVariable ["J_Longbow_Target",_target];
if (!isNull _target && {alive _target}) then {
    [_missile,_target,_shooter] spawn J_fnc_longbowGuidanceLoop;
};
