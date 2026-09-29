/*
 * v0.3.3
 * Determine which controls make sense for the currently controlled platform.
 *
 * Return: [platform, hasLaserCapability, hasJHKNMissiles]
 */
params [["_caller", player]];
private _platform = [_caller] call J_fnc_getControlPlatform;
if (isNull _platform) exitWith {[objNull, false, false]};

private _hasMissiles = false;
private _hasLaser = false;

private _weaponPool = +weapons _platform;
{
    _weaponPool append (_platform weaponsTurret _x);
} forEach (allTurrets [_platform, true]);

_weaponPool = _weaponPool arrayIntersect _weaponPool;

if (
    "J_Hellfire_Launcher_K" in _weaponPool
    || {"J_Hellfire_Launcher_N" in _weaponPool}
    || {"J_Hellfire_Launcher" in _weaponPool}
) then {
    _hasMissiles = true;
};

{
    private _weapon = _x;
    private _mags = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");

    {
        private _ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
        private _sim = toLower getText (configFile >> "CfgAmmo" >> _ammo >> "simulation");
        if (_sim find "laser" >= 0) exitWith {_hasLaser = true};
    } forEach _mags;

    if (_hasLaser) exitWith {};
} forEach _weaponPool;

if (!isNull (laserTarget _platform)) then {_hasLaser = true};

private _remote = remoteControlled player;
if (!_hasLaser && {!isNull _remote} && {_remote isKindOf "Man"}) then {
    {
        private _mags = getArray (configFile >> "CfgWeapons" >> _x >> "magazines");
        {
            private _ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
            private _sim = toLower getText (configFile >> "CfgAmmo" >> _ammo >> "simulation");
            if (_sim find "laser" >= 0) exitWith {_hasLaser = true};
        } forEach _mags;
        if (_hasLaser) exitWith {};
    } forEach weapons _remote;
};

[_platform, _hasLaser, _hasMissiles]
