/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * Dependency-boundary adaptation of ACE3 laser::fnc_seekerFindLaserSpot.
 * Upstream author: Nou.
 *
 * ACE normally owns a laser-emitter hashmap and computes the reflected point
 * by shooting the emitter ray. J's standalone addon instead registers the
 * vanilla LaserTarget object that Arma already creates for each active
 * designator. From that reflected point onward this retains ACE's seeker FOV,
 * range, 10 m clustering, LOS filtering and best-bucket selection behavior.
 */
params [
    "_posASL",
    "_dir",
    "_seekerFov",
    "_seekerMaxDistance",
    "_seekerWavelengths",
    "_seekerCode",
    ["_ignoreObj1", objNull],
    ["_ignoreObj2", objNull]
];

_dir = vectorNormalized _dir;
private _seekerCos = cos _seekerFov;
private _seekerMaxDistSq = _seekerMaxDistance ^ 2;
private _spots = [];
private _finalPos = nil;
private _finalOwner = objNull;

{
    _x params ["_emitter", "_laserTarget", "_laserCode"];
    if (!isNull _laserTarget && {_laserCode == _seekerCode}) then {
        private _resultPos = getPosASLVisual _laserTarget;
        private _testPointVector = _posASL vectorFromTo _resultPos;
        private _testDotProduct = _dir vectorDotProduct _testPointVector;
        if ((_testDotProduct > _seekerCos) && {(_resultPos vectorDistanceSqr _posASL) < _seekerMaxDistSq}) then {
            _spots pushBack [_resultPos, _emitter];
        };
    };
} forEach (missionNamespace getVariable ["J_Hellfire_registry", []]);

if (_spots isNotEqualTo []) then {
    private _bucketList = nil;
    private _bucketPos = nil;
    private _c = 0;
    private _buckets = [];
    private _excludes = [];

    while {count _spots != count _excludes && {_c < count _spots}} do {
        scopeName "mainSearch";
        {
            if !(_forEachIndex in _excludes) then {
                private _index = _buckets pushBack [_x, [_x]];
                _excludes pushBack _forEachIndex;
                _bucketPos = _x select 0;
                _bucketList = (_buckets select _index) select 1;
                breakTo "mainSearch";
            };
        } forEach _spots;
        {
            if !(_forEachIndex in _excludes) then {
                private _testPos = _x select 0;
                if ((_testPos vectorDistanceSqr _bucketPos) <= 100) then {
                    _bucketList pushBack _x;
                    _excludes pushBack _forEachIndex;
                };
            };
        } forEach _spots;
        _c = _c + 1;
    };

    private _finalBuckets = [];
    private _largest = -1;
    private _largestIndex = 0;
    {
        private _index = _finalBuckets pushBack [];
        _bucketList = _finalBuckets select _index;
        {
            private _testPos = (_x select 0) vectorAdd [0,0,0.05];
            private _testIntersections = lineIntersectsSurfaces [_posASL, _testPos, _ignoreObj1, _ignoreObj2];
            _testIntersections = _testIntersections select {
                _x params ["_intersectPosASL"];
                (_intersectPosASL vectorDistanceSqr _testPos) > 0.01
            };
            if ([] isEqualTo _testIntersections) then {
                _bucketList pushBack _x;
            };
        } forEach (_x select 1);
        if ((count _bucketList) > _largest) then {
            _largest = count _bucketList;
            _largestIndex = _index;
        };
    } forEach _buckets;

    private _finalBucket = _finalBuckets select _largestIndex;
    private _ownersHash = createHashMap;
    if (count _finalBucket > 0) then {
        _finalPos = [0,0,0];
        {
            _x params ["_xPos", "_owner"];
            _finalPos = _finalPos vectorAdd _xPos;
            private _value = _ownersHash getOrDefault [hashValue _owner, [0, _owner]];
            _value set [0, 1 + (_value select 0)];
            _ownersHash set [hashValue _owner, _value];
        } forEach _finalBucket;
        _finalPos = _finalPos vectorMultiply (1 / count _finalBucket);

        private _maxOwnerCount = -1;
        {
            _y params ["_count", "_owner"];
            if (_count > _maxOwnerCount) then {
                _maxOwnerCount = _count;
                _finalOwner = _owner;
            };
        } forEach _ownersHash;
    };
};

if (isNil "_finalPos") exitWith {[nil, _finalOwner]};
[_finalPos, _finalOwner]
