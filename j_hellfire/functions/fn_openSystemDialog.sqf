params [["_caller", player]];

private _caps = [_caller] call J_fnc_getCapabilities;
_caps params ["_platform", "_hasLaser", "_hasMissiles"];
if (isNull _platform) exitWith {};
if (!_hasLaser && !_hasMissiles) exitWith {
};

uiNamespace setVariable ["J_System_Platform", _platform];
uiNamespace setVariable ["J_System_HasLaser", _hasLaser];
uiNamespace setVariable ["J_System_HasMissiles", _hasMissiles];

createDialog "J_SystemDialog";
private _display = uiNamespace getVariable ["J_SystemDialog_Display", displayNull];
if (isNull _display) exitWith {};

private _name = getText (configFile >> "CfgVehicles" >> typeOf _platform >> "displayName");
if (_platform isKindOf "Man") then {_name = name _platform};
(_display displayCtrl 1001) ctrlSetText format ["J'S HELLFIRE SYSTEM - %1", _name];

private _laserCtrls = [1100,1101,1400];
private _missileCtrls = [1200,1201,1401,1300];

{
    (_display displayCtrl _x) ctrlShow _hasLaser;
} forEach _laserCtrls;

{
    (_display displayCtrl _x) ctrlShow _hasMissiles;
} forEach _missileCtrls;

if (_hasLaser) then {
    (_display displayCtrl 1400) ctrlSetText str (_platform getVariable ["J_LaserCode", 1111]);
};

if (_hasMissiles) then {
    (_display displayCtrl 1401) ctrlSetText str (_platform getVariable ["J_Hellfire_MissileCode", 1111]);
};

if (_hasLaser) then {
    ctrlSetFocus (_display displayCtrl 1400);
} else {
    ctrlSetFocus (_display displayCtrl 1401);
};
