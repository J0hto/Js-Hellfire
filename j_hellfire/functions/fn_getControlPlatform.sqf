params ["_caller"];
if (isNull _caller) exitWith {objNull};

// First priority: an AI unit actively remote-controlled by this client.
// remoteControlled player returns the controlled unit (Arma 3 2.14+).
private _remote = remoteControlled player;
if (!isNull _remote) exitWith {
    private _remoteVeh = vehicle _remote;
    if (_remoteVeh != _remote) then {_remoteVeh} else {_remote}
};

// Second priority: UAV connected through a terminal.
private _uav = getConnectedUAV _caller;
if (!isNull _uav) exitWith {_uav};

// Normal occupied vehicle / aircraft.
private _veh = vehicle _caller;
if (_veh != _caller) exitWith {_veh};

_caller
