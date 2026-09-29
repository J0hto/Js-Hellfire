/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * v0.8.1 - ACE guidance servo adaptation.
 * Derived from ACE3 missileguidance fnc_guidancePFH.sqf (GPLv2).
 * Keeps ACE directional-stability and quaternion attitude math.
 *
 * State: [yaw, roll, pitch]
 */
params ["_projectile","_commandedAcceleration","_timestep","_guidanceParameters",
        ["_pitchRate",30],["_yawRate",30],["_stabilityCoefficient",0.25],
        ["_isBangBangGuidance",false]];

if (_guidanceParameters isEqualTo []) then {
    private _dir = vectorDirVisual _projectile;
    private _yaw0 = (_dir # 0) atan2 (_dir # 1);
    private _pitch0 = (_dir # 2) atan2 sqrt (((_dir # 0)^2) + ((_dir # 1)^2));
    _guidanceParameters = [_yaw0,0,_pitch0];
};

_guidanceParameters params ["_yaw","_roll","_pitch"];

_commandedAcceleration = _projectile vectorWorldToModelVisual _commandedAcceleration;
_commandedAcceleration params ["_yawChange","", "_pitchChange"];
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
private _velocityAngleYaw = (_localVelocity # 0) atan2 (_localVelocity # 1);
private _velocityAnglePitch = (_localVelocity # 2) atan2 (_localVelocity # 1);
private _forceYaw = _stabilityCoefficient * _velocityAngleYaw + _clampedYaw;
private _forcePitch = _stabilityCoefficient * _velocityAnglePitch + _clampedPitch;

_pitch = _pitch + _forcePitch * _timestep;
_yaw = _yaw + _forceYaw * _timestep;

private _multiplyQuat = {
    params ["_qLHS","_qRHS"];
    _qLHS params ["_lhsX","_lhsY","_lhsZ","_lhsW"];
    _qRHS params ["_rhsX","_rhsY","_rhsZ","_rhsW"];
    private _lhsImaginary = [_lhsX,_lhsY,_lhsZ];
    private _rhsImaginary = [_rhsX,_rhsY,_rhsZ];
    private _scalar = _lhsW * _rhsW - (_lhsImaginary vectorDotProduct _rhsImaginary);
    private _imaginary =
        (_rhsImaginary vectorMultiply _lhsW)
        vectorAdd (_lhsImaginary vectorMultiply _rhsW)
        vectorAdd (_lhsImaginary vectorCrossProduct _rhsImaginary);
    _imaginary + [_scalar]
};
private _multiplyVector = {
    params ["_quaternion","_vector"];
    private _real = _quaternion # 3;
    private _imaginary = [_quaternion#0,_quaternion#1,_quaternion#2];
    _vector vectorAdd ((
        _imaginary vectorCrossProduct (
            (_imaginary vectorCrossProduct _vector)
            vectorAdd (_vector vectorMultiply _real)
        )
    ) vectorMultiply 2)
};

private _quaternion = [0,0,0,1];
private _temp = [0,0,sin (-_yaw/2),cos (-_yaw/2)];
_quaternion = [_quaternion,_temp] call _multiplyQuat;
_temp = [sin (_pitch/2),0,0,cos (_pitch/2)];
_quaternion = [_quaternion,_temp] call _multiplyQuat;

private _dir = [_quaternion,[0,1,0]] call _multiplyVector;
private _up = [_quaternion,[0,0,1]] call _multiplyVector;
_projectile setVectorDirAndUp [_dir,_up];

_guidanceParameters set [0,_yaw];
_guidanceParameters set [2,_pitch];
_guidanceParameters
