/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * J's Hellfire v0.10.0 - ACE core transplant initializer.
 *
 * This builds the same guidance argument/state layout used by ACE3
 * missileguidance::fnc_onFiredGetArgs for the ACE Hellfire type, while
 * adapting only the external integration points to J's standalone addon.
 *
 * ACE3 upstream references:
 * - addons/missileguidance/functions/fnc_onFiredGetArgs.sqf
 * - addons/missileguidance/CfgMissileTypesNato.hpp (type_Hellfire)
 * - addons/missileguidance/ACE_GuidanceConfig.hpp
 *
 * ACE3 is GPL-2.0-or-later. See project notices in the source archive.
 */
params [
    ["_projectile", objNull],
    ["_laserCode", 1111],
    ["_requestedProfile", "LOBL"],
    ["_shooter", objNull]
];

if (isNull _projectile) exitWith {};
if (isNull _shooter) then {
    _shooter = _projectile getVariable ["J_Hellfire_Platform", objNull];
};
if (isNull _shooter) exitWith {};

private _ammo = typeOf _projectile;

private _attackProfile = switch (_requestedProfile) do {
    case "LOAL-HI":  {"hellfire_hi"};
    case "LOAL-LOW": {"hellfire_lo"};
    default           {"hellfire"};
};
private _lockMode = if (_requestedProfile isEqualTo "LOBL") then {"LOBL"} else {"LOAL"};

private _launchPos = getPosASL (vehicle _shooter);
private _launchDir = vectorDirVisual (vehicle _shooter);
private _launchTime = CBA_missionTime;

private _firedEH = [_shooter, "", "", "", _ammo, "", _projectile];
private _targetLaunchParams = [objNull, [0,0,0], _launchPos, _launchDir, _launchTime];
private _laserInfo = [_laserCode, 1550, 1550];
private _launchParams = [
    _shooter,
    _targetLaunchParams,
    "SALH",
    _attackProfile,
    _lockMode,
    _laserInfo,
    "Direct"
];

private _flightParams = [
    30,
    30,
    false,
    0,
    false
];
private _seekerParams = [
    70,
    1,
    8000,
    1
];

private _seekLastTargetPos = true;
private _lastKnownPosState = [_seekLastTargetPos, [0,0,0]];

private _yawRollPitch = (vectorDir _projectile) call CBA_fnc_vect2Polar;
private _guidanceParameters = [
    _yawRollPitch param [1, 0],
    0,
    _yawRollPitch param [2, 0]
];

private _navigationParameters = [];
private _stateParams = [
    diag_tickTime,
    [],
    [],
    _lastKnownPosState,
    _navigationParameters,
    _guidanceParameters
];

private _targetData = [
    [0,0,0],
    [0,0,0],
    0,
    [0,0,0],
    [0,0,0]
];

private _navigationStateData = [
    ["J_fnc_aceHellfireMidCourseTransition", "Direct", []],
    ["", "ZeroEffortMiss", [[[0,0,0]], 3]]
];
private _navigationStateParams = [0, _navigationStateData];

private _args = [
    _firedEH,
    _launchParams,
    _flightParams,
    _seekerParams,
    _stateParams,
    _targetData,
    _navigationStateParams
];

[J_fnc_aceGuidancePFH, 0, _args] call CBA_fnc_addPerFrameHandler;
