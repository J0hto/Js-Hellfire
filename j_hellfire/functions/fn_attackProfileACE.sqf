/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * J's Hellfire standalone adaptation of ACE3 Hellfire fnc_attackProfile.sqf and
 * fnc_getAttackProfileSettings.sqf.
 * Upstream author: PabstMirror.
 *
 * Stages:
 * 1 LAUNCH, 2 SEEK_CRUISE, 3 ATTACK_CRUISE, 4 TERMINAL.
 * This path normally has a live coded-laser object when this function runs,
 * so SEEK_CRUISE is retained for completeness but normally skipped.
 */
params [
    "_missile", "_seekerTargetPos", "_launchPos", "_launchDir",
    "_profile", "_state"
];

private _STAGE_LAUNCH = 1;
private _STAGE_SEEK_CRUISE = 2;
private _STAGE_ATTACK_CRUISE = 3;
private _STAGE_TERMINAL = 4;

private _clearHeight = switch (_profile) do {
    case "LOAL-HI": {304.8};
    case "LOAL-LOW": {91.5};
    default {0};
};

if (_state isEqualTo []) then {
    private _startStage = if (_clearHeight > 0) then {_STAGE_LAUNCH} else {_STAGE_ATTACK_CRUISE};
    _state pushBack _startStage;
    _state pushBack _clearHeight;
    _state pushBack [
        (getPosASL _missile) # 2,
        _seekerTargetPos distance2D (getPosASL _missile)
    ];
};

_state params ["_stage", "_configLaunchHeightClear", "_missileStateData"];
private _projectilePos = getPosASL _missile;
private _heightAboveLaunch = (_projectilePos # 2) - (_launchPos # 2);
private _returnTargetPos = +_seekerTargetPos;

if (_returnTargetPos isEqualTo [0,0,0]) then {
    _returnTargetPos = _launchPos vectorAdd (_launchDir vectorMultiply 8000);
};

private _closingRate = vectorMagnitude velocity _missile;
private _timeToGo = if (_closingRate > 0) then {
    ((_projectilePos distance2D _seekerTargetPos) - 500) / _closingRate
} else {999};

private _los = _projectilePos vectorFromTo _seekerTargetPos;
private _angleToTarget = acos ((vectorDir _missile) vectorCos _los);
private _atMinRotationAngle = _angleToTarget >= (30 * _timeToGo);

switch (_stage) do {
    case 1: {
        _missileStateData params ["_heightBeforeStateSwitch","_initialDistanceToTarget"];
        _returnTargetPos set [2,_heightBeforeStateSwitch + (_initialDistanceToTarget * sin 20)];

        if (_heightAboveLaunch > _configLaunchHeightClear) then {
            _state set [0,_STAGE_SEEK_CRUISE];
            _state set [2,[_projectilePos # 2,_seekerTargetPos distance2D _projectilePos]];
        };

        if (_atMinRotationAngle) then {
            _state set [0,_STAGE_TERMINAL];
            _state set [2,[_projectilePos # 2,_seekerTargetPos distance2D _projectilePos]];
        };
    };

    case 2: {
        _missileStateData params ["_heightBeforeStateSwitch","_initialDistanceToTarget"];
        _returnTargetPos set [2,_heightBeforeStateSwitch + (_initialDistanceToTarget * sin 5.7)];

        if (_seekerTargetPos isNotEqualTo [0,0,0]) then {
            _state set [0,_STAGE_ATTACK_CRUISE];
            _state set [2,[_projectilePos # 2,_seekerTargetPos distance2D _projectilePos]];
        };
    };

    case 3: {
        _missileStateData params ["_heightBeforeStateSwitch","_initialDistanceToTarget"];
        private _heightOverTarget = (_projectilePos # 2) - (_seekerTargetPos # 2);
        private _distance2D = _seekerTargetPos distance2D _projectilePos;

        _returnTargetPos set [2,_heightBeforeStateSwitch + (_initialDistanceToTarget * sin 7)];

        if (_atMinRotationAngle || {(_heightOverTarget atan2 _distance2D) > 15}) then {
            _state set [0,_STAGE_TERMINAL];
            _state set [2,[_projectilePos # 2,_seekerTargetPos distance2D _projectilePos]];
        };
    };

    case 4: {};
};

[_returnTargetPos, _state # 0]
