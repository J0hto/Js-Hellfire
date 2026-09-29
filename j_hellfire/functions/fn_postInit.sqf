J_Hellfire_registry = [];
[] spawn J_fnc_registryLoop;

if (!hasInterface) exitWith {};

J_LWinHeld = false;

waitUntil {!isNull player};
waitUntil {!isNull findDisplay 46};

private _display = findDisplay 46;

_display displayAddEventHandler ["KeyDown", {
    params ["_displayOrControl", "_key"];
    if (_key == 219) then {
        J_LWinHeld = true;
    };
    false
}];

_display displayAddEventHandler ["KeyUp", {
    params ["_displayOrControl", "_key"];
    if (_key == 219) then {
        J_LWinHeld = false;
    };
    false
}];

[player] call J_fnc_addActions;
[] spawn J_fnc_controlLoop;
[] spawn J_fnc_hudLoop;

_display displayAddEventHandler ["KeyDown", {
    params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];

    if (_key == 33 && {_ctrl} && {!_shift} && {!_alt}) then {
        private _platform = [player] call J_fnc_getControlPlatform;
        if (!isNull _platform && {currentWeapon _platform in ["J_Hellfire_Launcher_K","J_Hellfire_Launcher_N","J_Hellfire_Launcher"]}) then {
            [_platform] call J_fnc_cycleAttackProfile;
            true
        } else {
            false
        };
    } else {
        false
    };
}];

player addEventHandler ["Respawn", {
    params ["_unit"];
    [_unit] call J_fnc_addActions;
}];
