/*
 * v0.4.2
 * Cycle K/N attack profile. Called by Ctrl+F only.
 */
params [["_platform", objNull]];
if (isNull _platform) exitWith {};

private _caps = [player] call J_fnc_getCapabilities;
_caps params ["_capPlatform", "_hasLaser", "_hasMissiles"];

if (isNull _capPlatform || {_capPlatform != _platform} || {!_hasMissiles}) exitWith {};

private _profiles = ["LOBL","LOAL-DIR","LOAL-LOW","LOAL-HI"];
private _current = _platform getVariable ["J_Hellfire_CurrentProfile", "LOBL"];
private _idx = _profiles find _current;
if (_idx < 0) then {_idx = 0};
_idx = (_idx + 1) mod (count _profiles);

private _next = _profiles # _idx;
_platform setVariable ["J_Hellfire_CurrentProfile", _next, false];
