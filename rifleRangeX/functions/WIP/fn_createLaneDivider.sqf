params [["_pos",[0,0,0],[[]],[2,3]],["_dir",0,[0]]];

_pos = [_pos select 0, _pos select 1, -0.1];
_obj = createVehicle ["Land_Obstacle_Saddle_F", _pos, [], 0, "CAN_COLLIDE"];
_obj setDir _dir;
_obj setVectorUp surfaceNormal position _nul;

for "_i" from 1 to 99 do {
	_modelPos = _obj modelToWorld [0,4*_i,0];
	_pos = [_modelPos select 0, _modelPos select 1, -0.1];
	_nul = createVehicle [typeOf _obj, _pos, [], 0, "CAN_COLLIDE"];
	_nul setDir _dir;
	_nul setVectorUp surfaceNormal position _nul;
};
