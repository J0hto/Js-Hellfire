/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * v0.8.3 - ACE-derived Millimeter Wave Radar seeker lifecycle.
 * Derived from ACE3 missileguidance seekerType_MWR + mwr_onFired (GPLv2).
 *
 * State layout mirrors ACE:
 * [isActive, activeRadarDistance, timeWhenActive, expectedTargetPos,
 *  lastTargetPollTime, shooterHasRadar, wasActive, lastKnownVelocity,
 *  lastTimeSeen, doesntHaveTarget, lockTypes]
 *
 * Returns [hasTrack, seekerTargetPos, targetVelocity, targetAcceleration,
 *          targetRange, targetObject, state]
 */
params ["_missile","_shooter","_target","_state",["_dt",0.01]];

private _now = CBA_missionTime;
private _seekerAngle = 70;
private _seekerMaxRange = 2000;
private _activeRadarDistance = 1000;
private _pollFrequency = 1/7;
private _minimumScanArea = 30;
private _lockTypes = ["Air","LandVehicle","Ship"];

if (_state isEqualTo []) then {
    // ACE mwr_onFired launch handoff.
    private _handoff = missileTarget _missile;
    if (isNull _handoff) then {_handoff = _target};
    if (!isNull _handoff && {!(_handoff isKindOf "AllVehicles")}) then {
        _handoff = objNull;
    };

    private _shooterVehicle = if (isNull _shooter) then {objNull} else {vehicle _shooter};
    private _radarOn = !isNull _shooterVehicle && {isVehicleRadarOn _shooterVehicle};
    private _hasRadar = false;
    if (!isNull _shooterVehicle) then {
        {
            if ("ActiveRadarSensorComponent" in _x) exitWith {_hasRadar=true};
        } forEach listVehicleSensors _shooterVehicle;
    };

    private _velocityAtImpact = 250 * 2.5; // ACE L thrust * thrustTime
    private _timeToActive = 0;
    private _isActive = false;
    if (!isNull _handoff && {_velocityAtImpact > 0}) then {
        private _distanceUntilActive =
            ((getPosASL _shooterVehicle) vectorDistance (getPosASL _handoff))
            - _activeRadarDistance;
        _timeToActive = 0 max (_distanceUntilActive / _velocityAtImpact);
    } else {
        _isActive = true;
    };
    if (!_radarOn) then {_isActive=true};

    private _initialPos = if (isNull _handoff) then {[0,0,0]} else {
        _handoff modelToWorldVisualWorld (getCenterOfMass _handoff)
    };
    _state append [
        _isActive,_activeRadarDistance,_now+_timeToActive,_initialPos,_now,
        _hasRadar,false,[0,0,0],_now,isNull _handoff,_lockTypes
    ];
    _target = _handoff;

    // ACE clears vanilla missile target to emulate no launch warning / own seeker.
    _missile setMissileTarget objNull;
};

_state params [
    "_isActive","_activeDistance","_timeWhenActive","_expectedTargetPos",
    "_lastPoll","_shooterHasRadar","_wasActive","_lastKnownVelocity",
    "_lastTimeSeen","_doesntHaveTarget","_types"
];

private _targetVelocity = _lastKnownVelocity;
private _targetAcceleration = [0,0,0];
private _targetRange = (getPosASLVisual _missile) vectorDistance _expectedTargetPos;

if (_isActive || {_now >= _timeWhenActive}) then {
    if (!_isActive) then {_isActive=true; _state set [0,true]};
    if (!_wasActive) then {_wasActive=true; _state set [6,true]};

    // ACE polls internal MMW at 7 Hz rather than every guidance tick.
    if ((_lastPoll + _pollFrequency) <= _now) then {
        private _searchPos = _expectedTargetPos;
        if (_searchPos isEqualTo [0,0,0] || {_doesntHaveTarget}) then {
            _state set [9,true];
            _doesntHaveTarget=true;
            _searchPos = (getPosASL _missile) vectorAdd
                (_missile vectorModelToWorld [0,_seekerMaxRange,-((getPos _missile)#2)]);
        };

        _lastPoll=_now; _state set [4,_now];
        private _distanceExpected =
            _seekerMaxRange min ((getPosASL _missile) vectorDistance _searchPos);

        private _projDir=vectorDir _missile;
        private _projYaw=getDir _missile;
        private _rotatedYaw=(+(_projDir#0)*sin _projYaw)+(+(_projDir#1)*cos _projYaw);
        if (_rotatedYaw isEqualTo 0) then {_rotatedYaw=0.001};
        private _projPitch=atan ((_projDir#2)/_rotatedYaw);
        private _a1=abs _projPitch;
        private _a2=180-((_seekerAngle/2)+_a1);
        private _scanRadius =
            _minimumScanArea max (_distanceExpected / sin(_a2) * sin(_seekerAngle/2));
        private _adjustedRadius = linearConversion [
            0,_scanRadius,(_now-_lastTimeSeen)*vectorMagnitude _lastKnownVelocity,
            _minimumScanArea,_scanRadius,false
        ];
        if (_doesntHaveTarget) then {_adjustedRadius=_scanRadius};

        private _candidates=nearestObjects [ASLToAGL _searchPos,_types,_adjustedRadius,false];
        _candidates=_candidates select {
            private _obj=_x;
            private _center=_obj modelToWorldVisualWorld (getCenterOfMass _obj);
            [_missile,_center,_seekerAngle] call J_fnc_longbowCheckSeekerAngle
            && {
                [_missile,_obj,"VIEW"] call J_fnc_longbowCheckLOS
                || {[_missile,_obj,"FIRE"] call J_fnc_longbowCheckLOS}
            }
        };

        if (_candidates isEqualTo []) then {
            _target=objNull;
            _missile setMissileTarget objNull;
            _expectedTargetPos=_searchPos;
            _state set [3,_searchPos];
        } else {
            private _best=objNull;
            private _bestDist=_scanRadius;
            {
                private _d=_x distance2D _searchPos;
                if (_d < _bestDist) then {_bestDist=_d; _best=_x};
            } forEach _candidates;
            _target=_best;
        };
    };
} else {
    // ACE external-radar/datalink phase. If donor radar/LOS disappears,
    // immediately pitbull.
    private _sv=if (isNull _shooter) then {objNull} else {vehicle _shooter};
    private _keepExternal=!isNull _target && {!isNull _sv}
        && {_shooterHasRadar} && {isVehicleRadarOn _sv} && {alive _sv}
        && {
            [_sv,_target,"VIEW"] call J_fnc_longbowCheckLOS
            || {[_sv,_target,"FIRE"] call J_fnc_longbowCheckLOS}
        };
    if (!_keepExternal) then {
        _state set [0,true];
        _isActive=true;
        _target=objNull;
    };
};

if (!isNull _target) then {
    // This is the exact aim-point choice that matters: ACE uses center of mass.
    private _centerOfObject=getCenterOfMass _target;
    private _adjustedPos=_target modelToWorldVisualWorld _centerOfObject;
    _expectedTargetPos=_adjustedPos;

    _targetVelocity=velocity _target;
    if (_dt != 0) then {
        _targetAcceleration=(_targetVelocity vectorDiff _lastKnownVelocity)
            vectorMultiply (1/_dt);
    };
    _targetRange=_missile distance _target;

    _state set [3,_expectedTargetPos];
    _state set [7,_targetVelocity];
    _state set [8,_now];
    _state set [9,false];
    _missile setMissileTarget _target;
};

private _hasTrack=_expectedTargetPos isNotEqualTo [0,0,0];
[_hasTrack,_expectedTargetPos,_targetVelocity,_targetAcceleration,_targetRange,_target,_state]
