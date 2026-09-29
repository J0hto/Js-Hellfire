/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * Standalone namespace adaptation of ACE3
 * addons/hellfire/functions/fnc_attackProfile.sqf
 * Upstream author: PabstMirror.
 *
 * Stages are the ACE Hellfire stages:
 * 1 LAUNCH, 2 SEEK_CRUISE, 3 ATTACK_CRUISE, 4 ATTACK_TERMINAL.
 */
params ["_seekerTargetPos", "_args", "_attackProfileStateParams"];
_args params ["_firedEH", "_launchParams", "_flightParams", "", "_stateParams"];
_stateParams params ["", "_seekerStateParams"];
_launchParams params ["", "_targetLaunchParams", "_seekerType"];
_targetLaunchParams params ["", "", "_launchPos", "_launchDir"];
_firedEH params ["", "", "", "", "", "", "_projectile"];

if (_attackProfileStateParams isEqualTo []) then {
    [_seekerTargetPos, _args, _attackProfileStateParams] call J_fnc_aceHellfireGetAttackProfileSettings;
};
_attackProfileStateParams params ["_attackStage", "_configLaunchHeightClear", "_missileStateData"];

private _projectilePos = getPosASL _projectile;
private _distanceFromLaunch2d = _launchPos distance2D _projectilePos;
private _heightAboveLaunch = (_projectilePos select 2) - (_launchPos select 2);
private _returnTargetPos = _seekerTargetPos;
if (_returnTargetPos isEqualTo [0,0,0]) then {
    private _initialDistanceToTarget = 8000;
    _returnTargetPos = _launchPos vectorAdd (_launchDir vectorMultiply _initialDistanceToTarget);
};

private _closingRate = vectorMagnitude velocity _projectile;
private _timeToGo = ((_projectilePos distance2D _seekerTargetPos) - 500) / _closingRate;
private _los = _projectilePos vectorFromTo _seekerTargetPos;

_flightParams params ["_pitchRate", "_yawRate"];
private _angleToTarget = acos ((vectorDir _projectile) vectorCos _los);
private _atMinRotationAngle = _angleToTarget >= (_pitchRate * _timeToGo);

switch (_attackStage) do {
    case 1: {
        _missileStateData params ["_heightBeforeStateSwitch", "_initialDistanceToTarget"];
        _returnTargetPos set [2, _heightBeforeStateSwitch + (_initialDistanceToTarget * sin 20)];
        if (_heightAboveLaunch > _configLaunchHeightClear) then {
            _attackProfileStateParams set [0, 2];
            _attackProfileStateParams set [2, [_projectilePos select 2, _seekerTargetPos distance2D _projectilePos]];
        };
        if (_atMinRotationAngle) then {
            _attackProfileStateParams set [0, 4];
            _attackProfileStateParams set [2, [_projectilePos select 2, _seekerTargetPos distance2D _projectilePos]];
        };
    };
    case 2: {
        _missileStateData params ["_heightBeforeStateSwitch", "_initialDistanceToTarget"];
        _returnTargetPos set [2, _heightBeforeStateSwitch + (_initialDistanceToTarget * sin 5.7)];
        if (_seekerTargetPos isNotEqualTo [0,0,0]) then {
            _attackProfileStateParams set [0, 3];
            _attackProfileStateParams set [2, [_projectilePos select 2, _seekerTargetPos distance2D _projectilePos]];
        };
    };
    case 3: {
        _missileStateData params ["_heightBeforeStateSwitch", "_initialDistanceToTarget"];
        private _currentHeightOverTarget = (_projectilePos select 2) - (_seekerTargetPos select 2);
        private _distanceToTarget2d = _seekerTargetPos distance2D _projectilePos;
        _returnTargetPos set [2, _heightBeforeStateSwitch + (_initialDistanceToTarget * sin 7)];
        if (_atMinRotationAngle || {(_currentHeightOverTarget atan2 _distanceToTarget2d) > 15}) then {
            _attackProfileStateParams set [0, 4];
            _attackProfileStateParams set [2, [_projectilePos select 2, _seekerTargetPos distance2D _projectilePos]];
        };
    };
    case 4: {};
};

_returnTargetPos
