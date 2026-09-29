params ["_unit"];
if (isNull _unit) exitWith {};
if (_unit getVariable ["J_Hellfire_ActionsAdded", false]) exitWith {};
_unit setVariable ["J_Hellfire_ActionsAdded", true, false];

_unit addAction [
    "J's Hellfire System",
    {
        params ["_target", "_caller"];
        [_caller] call J_fnc_openSystemDialog;
    },
    nil,
    1.5,
    false,
    true,
    "",
    "J_LWinHeld && {private _c = [_this] call J_fnc_getCapabilities; (_c # 1) || (_c # 2)}"
];
