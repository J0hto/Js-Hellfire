while {true} do {
    private _newRegistry = [];

    {
        private _emitter = _x;
        if (!isNull _emitter && {alive _emitter}) then {
            private _lt = laserTarget _emitter;
            if (!isNull _lt) then {
                private _code = _emitter getVariable ["J_LaserCode", 1111];
                _newRegistry pushBack [_emitter, _lt, _code];
            };
        };
    } forEach allUnits;

    {
        private _veh = _x;
        if (!isNull _veh && {alive _veh}) then {
            private _lt = laserTarget _veh;
            if (!isNull _lt) then {
                private _code = _veh getVariable ["J_LaserCode", 1111];
                private _duplicate = _newRegistry findIf {(_x select 0) isEqualTo _veh && {(_x select 1) isEqualTo _lt}};
                if (_duplicate < 0) then {
                    _newRegistry pushBack [_veh, _lt, _code];
                };
            };
        };
    } forEach vehicles;

    J_Hellfire_registry = _newRegistry;
    sleep 0.10;
};
