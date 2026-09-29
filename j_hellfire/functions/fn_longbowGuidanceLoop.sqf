/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * v0.8.3 - ACE MWR / target-data / navigation-state lifecycle.
 * K/N do not enter this controller.
 */
params ["_missile","_target",["_shooter",objNull]];
if (isNull _missile) exitWith {};

private _start=time;
private _lastTick=diag_tickTime;
private _launchPos=getPosASL _missile;
private _launchDir=vectorDirVisual _missile;
private _profileState=[];
private _guidanceParameters=[];
private _seekerState=[];
private _navigationState=0; // ACE Hellfire initial=Direct, terminal=ZEM
private _targetData=[[0,0,0],[0,0,0],0,[0,0,0],[0,0,0]];
private _enableAt=diag_tickTime+0.12;

while {!isNull _missile && {alive _missile} && {(time-_start)<40}} do {
    private _now=diag_tickTime;
    private _dt=((_now-_lastTick) max 0.001) min 0.05;
    _lastTick=_now;

    if (_now>=_enableAt) then {
        private _seek=[
            _missile,_shooter,_target,_seekerState,_dt
        ] call J_fnc_longbowSeeker;
        _seek params [
            "_hasTrack","_seekerTargetPos","_targetVelocity",
            "_targetAcceleration","_targetRange","_trackedTarget","_newSeekerState"
        ];
        _seekerState=_newSeekerState;
        if (!isNull _trackedTarget) then {_target=_trackedTarget};

        if (_hasTrack && {_seekerTargetPos isNotEqualTo [0,0,0]}) then {
            // ACE guidancePFH order: seeker -> profile -> targetData -> nav state -> nav -> servo.
            _seekerTargetPos=AGLToASL ASLToAGL _seekerTargetPos;
            private _profileResult=[
                _missile,_seekerTargetPos,_launchPos,_launchDir,"LOBL",_profileState
            ] call J_fnc_attackProfileACE;
            _profileResult params ["_profileAdjustedTargetPos","_stage"];

            private _projectilePos=getPosASLVisual _missile;
            _targetData set [0,_projectilePos vectorFromTo _seekerTargetPos];
            _targetData set [1,_projectilePos vectorFromTo _profileAdjustedTargetPos];
            _targetData set [2,_targetRange];
            _targetData set [3,_targetVelocity];
            _targetData set [4,_targetAcceleration];

            // Exact ACE Hellfire state transition condition:
            // attack profile reaches STAGE_ATTACK_TERMINAL.
            if (_navigationState==0 && {_stage==4}) then {
                _navigationState=1;
            };

            private _commandedAcceleration=
                if (_navigationState==0) then {
                    [_missile,_profileAdjustedTargetPos,_dt,30,30]
                        call J_fnc_longbowDirect
                } else {
                    [_missile,_targetData,3.5] call J_fnc_longbowZEM
                };

            if (!isGamePaused && {accTime>0}) then {
                _guidanceParameters=[
                    _missile,_commandedAcceleration,_dt,_guidanceParameters,
                    30,30,0.25,false
                ] call J_fnc_longbowAutopilot;
            };
        };
    };
    sleep 0.01;
};
