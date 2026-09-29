params ["_emitter", ["_code", 1111]];
if (isNull _emitter) exitWith {false};

_emitter setVariable ["J_LaserCode", _code, true];
true
