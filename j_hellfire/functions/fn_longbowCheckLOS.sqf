/*
 * Lightweight J's Hellfire LOS equivalent for ACE MWR scan.
 * Two geometry passes are performed by the caller (VIEW/FIRE).
 */
params ["_projectile","_target",["_geometry","VIEW"]];
if (isNull _target) exitWith {false};
private _from = getPosASLVisual _projectile;
private _center = getCenterOfMass _target;
private _to = _target modelToWorldVisualWorld _center;
private _hits = lineIntersectsSurfaces [_from,_to,_projectile,_target,true,1,_geometry,"NONE"];
_hits isEqualTo []
