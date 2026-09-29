/*
 * v0.10.0 K/N entry point.
 * Projectile init is only standalone glue; all flight guidance after this call
 * is handled by the transplanted ACE core functions.
 */
private _missile = _this param [0, objNull];
if (isNull _missile) exitWith {};

private _ammoType = typeOf _missile;
if !(_ammoType in ["J_Hellfire_AGM114K", "J_Hellfire_AGM114N"]) exitWith {};

private _shooter = objNull;
private _parents = getShotParents _missile;
if ((count _parents) > 0) then {
    _shooter = _parents param [0, objNull];
};

private _platform = _shooter;
if (!isNull _shooter && {_shooter isKindOf "Man"}) then {
    _platform = vehicle _shooter;
};
if (isNull _platform) exitWith {};

private _code = _platform getVariable ["J_Hellfire_MissileCode", 1111];
private _profile = _platform getVariable ["J_Hellfire_CurrentProfile", "LOBL"];

_missile setVariable ["J_Hellfire_Code", _code];
_missile setVariable ["J_Hellfire_Platform", _platform];
_missile setVariable ["J_Hellfire_AttackProfile", _profile];

[_missile, _code, _profile, _platform] call J_fnc_aceCoreInit;
