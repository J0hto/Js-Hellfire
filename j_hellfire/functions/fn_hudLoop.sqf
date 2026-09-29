/*
 * J's Hellfire contextual HUD.
 * K/N: attack profile + seeker code.
 * L: no custom HUD; vanilla radar/weapon-lock symbology is authoritative.
 * Laser designator: emitter code.
 */
while {hasInterface} do {
    private _platform = [player] call J_fnc_getControlPlatform;
    private _mode = "";
    private _selectedWeapon = "";

    if (!isNull _platform) then {
        _selectedWeapon = currentWeapon _platform;

        {
            private _tw = _platform currentWeaponTurret _x;
            if (_tw != "") exitWith {_selectedWeapon = _tw};
        } forEach [[-1],[0],[0,0],[1]];

        if (_selectedWeapon in [
            "J_Hellfire_Launcher_K",
            "J_Hellfire_Launcher_N",
            "J_Hellfire_Launcher"
        ]) then {
            _mode = "MISSILE";
        } else {
            private _mags = getArray (configFile >> "CfgWeapons" >> _selectedWeapon >> "magazines");
            {
                private _ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
                private _sim = toLower getText (configFile >> "CfgAmmo" >> _ammo >> "simulation");
                if (_sim find "laser" >= 0) exitWith {_mode = "LASER"};
            } forEach _mags;

            if (_mode == "" && {!isNull (laserTarget _platform)}) then {
                _mode = "LASER";
            };
        };
    };

    if (_mode != "") then {
        89141 cutRsc ["J_Hellfire_HUD", "PLAIN", 0, false];
        private _disp = uiNamespace getVariable ["J_Hellfire_HUD_Display", displayNull];

        if (!isNull _disp) then {
            switch (_mode) do {
                case "MISSILE": {
                    private _code = _platform getVariable ["J_Hellfire_MissileCode",1111];
                    private _profile = _platform getVariable ["J_Hellfire_CurrentProfile","LOBL"];
                    (_disp displayCtrl 89142) ctrlSetText
                        format ["%2   |   SEEKER CODE: %1",_code,_profile];
                };

                case "LASER": {
                    private _code = _platform getVariable ["J_LaserCode",1111];
                    (_disp displayCtrl 89142) ctrlSetText
                        format ["LASER CODE: %1",_code];
                };
            };
        };
    } else {
        89141 cutText ["","PLAIN"];
    };

    sleep 0.20;
};
