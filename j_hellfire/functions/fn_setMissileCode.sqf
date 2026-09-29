params ["_platform", ["_code", 1111]];
if (isNull _platform) exitWith {false};

_platform setVariable ["J_Hellfire_MissileCode", _code, true];
true
