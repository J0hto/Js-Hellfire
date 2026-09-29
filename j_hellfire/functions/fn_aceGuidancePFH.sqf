/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * J's Hellfire v0.10.0 core guidance loop.
 * Standalone namespace/dependency adaptation of ACE3
 * addons/missileguidance/functions/fnc_guidancePFH.sqf
 * Upstream authors: jaynus / nou.
 *
 * The actual guidance state ordering, Direct/ZEM dispatch, servo clamping,
 * directional-stability formulation, quaternion reconstruction and
 * setVectorDirAndUp control are retained from ACE. Removed portions are ACE
 * debug/event hooks that depend on unrelated ACE modules.
 */
params ["_args", "_pfID"];
_args params ["_firedEH", "_launchParams", "_flightParams", "_seekerParams", "_stateParams", "_targetData", "_navigationStateParams"];
_firedEH params ["_shooter", "", "", "", "_ammo", "", "_projectile"];
_launchParams params ["", "_targetLaunchParams", "", "", "", "", "_navigationType"];
_stateParams params ["_lastRunTime", "_seekerStateParams", "_attackProfileStateParams", "_lastKnownPosState", "_navigationParameters", "_guidanceParameters"];
_navigationStateParams params ["_currentState", "_navigationStateData"];
_flightParams params ["_pitchRate", "_yawRate", "_isBangBangGuidance", "_stabilityCoefficient", "_showTrail"];

if (!alive _projectile || {isNull _projectile} || {isNull _shooter}) exitWith {
    [_pfID] call CBA_fnc_removePerFrameHandler;
};

private _timestep = diag_deltaTime * accTime;

private _seekerTargetPos = [
    [0,0,0],
    _args,
    _seekerStateParams,
    _lastKnownPosState,
    _timestep
] call J_fnc_aceDoSeekerSearch;

_seekerTargetPos = AGLToASL ASLToAGL _seekerTargetPos;
private _profileAdjustedTargetPos = [
    _seekerTargetPos,
    _args,
    _attackProfileStateParams,
    _timestep
] call J_fnc_aceDoAttackProfile;

private _projectilePos = getPosASLVisual _projectile;
_targetData set [1, _projectilePos vectorFromTo _profileAdjustedTargetPos];

if ((_pitchRate != 0 || {_yawRate != 0}) && {_profileAdjustedTargetPos isNotEqualTo [0,0,0]}) then {
    private _navigationFunction = if (_navigationType isEqualTo "ZeroEffortMiss") then {
        "J_fnc_aceNavigationZEM"
    } else {
        "J_fnc_aceNavigationDirect"
    };

    if (_navigationStateData isNotEqualTo []) then {
        (_navigationStateData select _currentState) params ["_transitionCondition"];
        private _transition = false;
        if (_transitionCondition isNotEqualTo "") then {
            _transition = [_args, _timestep] call (missionNamespace getVariable [_transitionCondition, {false}]);
        };
        if (_transition) then {
            _currentState = _currentState + 1;
            _navigationStateParams set [0, _currentState];
        };

        _navigationType = (_navigationStateData select _currentState) select 1;
        _navigationFunction = if (_navigationType isEqualTo "ZeroEffortMiss") then {
            "J_fnc_aceNavigationZEM"
        } else {
            "J_fnc_aceNavigationDirect"
        };
        _navigationParameters = (_navigationStateData select _currentState) select 2;
        _stateParams set [4, _navigationParameters];
    };

    private _commandedAcceleration = [
        _args,
        _timestep,
        _seekerTargetPos,
        _profileAdjustedTargetPos,
        _targetData,
        _navigationParameters
    ] call (missionNamespace getVariable _navigationFunction);

    if (!isNil "_commandedAcceleration") then {
        if (!isGamePaused && {accTime > 0}) then {
            _guidanceParameters params ["_yaw", "_roll", "_pitch"];

            _commandedAcceleration = _projectile vectorWorldToModelVisual _commandedAcceleration;
            _commandedAcceleration params ["_yawChange", "", "_pitchChange"];
            if (isNil "_yawChange") then {_yawChange = 0};
            if (isNil "_pitchChange") then {_pitchChange = 0};

            private _clampedPitch = (_pitchChange min _pitchRate) max -_pitchRate;
            private _clampedYaw = (_yawChange min _yawRate) max -_yawRate;

            if (_isBangBangGuidance) then {
                private _pitchSign = if (_clampedPitch == 0) then {0} else {_clampedPitch / abs _clampedPitch};
                private _yawSign = if (_clampedYaw == 0) then {0} else {_clampedYaw / abs _clampedYaw};
                _clampedPitch = _pitchSign * _pitchRate;
                _clampedYaw = _yawSign * _yawRate;
            };

            private _localVelocity = _projectile vectorWorldToModelVisual (velocity _projectile);
            private _velocityAngleYaw = (_localVelocity select 0) atan2 (_localVelocity select 1);
            private _velocityAnglePitch = (_localVelocity select 2) atan2 (_localVelocity select 1);
            private _forceYaw = _stabilityCoefficient * _velocityAngleYaw + _clampedYaw;
            private _forcePitch = _stabilityCoefficient * _velocityAnglePitch + _clampedPitch;

            _pitch = _pitch + _forcePitch * _timestep;
            _yaw = _yaw + _forceYaw * _timestep;

            private _multiplyQuat = {
                params ["_qLHS", "_qRHS"];
                _qLHS params ["_lhsX", "_lhsY", "_lhsZ", "_lhsW"];
                _qRHS params ["_rhsX", "_rhsY", "_rhsZ", "_rhsW"];
                private _lhsImaginary = [_lhsX, _lhsY, _lhsZ];
                private _rhsImaginary = [_rhsX, _rhsY, _rhsZ];
                private _scalar = _lhsW * _rhsW - (_lhsImaginary vectorDotProduct _rhsImaginary);
                private _imaginary = (_rhsImaginary vectorMultiply _lhsW)
                    vectorAdd (_lhsImaginary vectorMultiply _rhsW)
                    vectorAdd (_lhsImaginary vectorCrossProduct _rhsImaginary);
                _imaginary + [_scalar]
            };

            private _multiplyVector = {
                params ["_quaternion", "_vector"];
                private _real = _quaternion select 3;
                private _imaginary = [
                    _quaternion select 0,
                    _quaternion select 1,
                    _quaternion select 2
                ];
                _vector vectorAdd ((
                    _imaginary vectorCrossProduct (
                        (_imaginary vectorCrossProduct _vector)
                        vectorAdd (_vector vectorMultiply _real)
                    )
                ) vectorMultiply 2)
            };

            private _quaternion = [0,0,0,1];
            private _temp = [0,0,sin (-_yaw / 2),cos (-_yaw / 2)];
            _quaternion = [_quaternion, _temp] call _multiplyQuat;
            _temp = [sin (_pitch / 2),0,0,cos (_pitch / 2)];
            _quaternion = [_quaternion, _temp] call _multiplyQuat;

            private _dir = [_quaternion, [0,1,0]] call _multiplyVector;
            private _up = [_quaternion, [0,0,1]] call _multiplyVector;
            _projectile setVectorDirAndUp [_dir, _up];

            _guidanceParameters set [0, _yaw];
            _guidanceParameters set [2, _pitch];
            _stateParams set [5, _guidanceParameters];
        };

        _stateParams set [4, _navigationParameters];
        _args set [4, _stateParams];
    };
};

_stateParams set [0, diag_tickTime];
