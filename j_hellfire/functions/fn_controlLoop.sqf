// Keep the J's Hellfire actions available on whichever character the local player is
// currently operating. This covers Zeus/scripted remote control as well as
// normal player control without changing vanilla control mechanics.
while {hasInterface} do {
    if (!isNull player) then {
        [player] call J_fnc_addActions;

        private _remote = remoteControlled player;
        if (!isNull _remote) then {
            [_remote] call J_fnc_addActions;
        };

        private _uavUnit = getConnectedUAVUnit player;
        if (!isNull _uavUnit) then {
            [_uavUnit] call J_fnc_addActions;
        };
    };

    sleep 0.5;
};
