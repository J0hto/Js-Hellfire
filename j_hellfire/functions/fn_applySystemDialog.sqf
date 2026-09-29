private _display = uiNamespace getVariable ["J_SystemDialog_Display", displayNull];
if (isNull _display) exitWith {};

private _platform = uiNamespace getVariable ["J_System_Platform", objNull];
private _hasLaser = uiNamespace getVariable ["J_System_HasLaser", false];
private _hasMissiles = uiNamespace getVariable ["J_System_HasMissiles", false];
if (isNull _platform) exitWith {closeDialog 0};

private _validate = {
    params ["_raw"];
    private _chars = toArray _raw;
    (count _chars == 4) && {(_chars findIf {_x < 48 || _x > 57}) == -1}
};

if (_hasLaser) then {
    private _rawLaser = ctrlText (_display displayCtrl 1400);
    if !([_rawLaser] call _validate) exitWith {};
    [_platform, parseNumber _rawLaser] call J_fnc_setEmitterCode;
};

if (_hasMissiles) then {
    private _rawMissile = ctrlText (_display displayCtrl 1401);
    if !([_rawMissile] call _validate) exitWith {};
    [_platform, parseNumber _rawMissile] call J_fnc_setMissileCode;
};

closeDialog 0;
