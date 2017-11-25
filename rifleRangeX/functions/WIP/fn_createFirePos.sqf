params [["_centre",objNull,[objNull]]];

private ["_pos","_dir","_centreDirAndUp","_composition","_zCorrection"];

_pos = getPos _centre;
_dir = getDir _centre;
_centreDirAndUp = [vectorDirVisual _centre, vectorUpVisual _centre];

deleteVehicle _centre;

_centre = createVehicle ["Sign_Arrow_Direction_Blue_F",[0,0,1000],[],0,"CAN_COLLIDE"];

_zCorrection = 0.844;

_composition = [
	["Land_BagFence_Corner_F",[0.5,-0.5,-0.25 + _zCorrection],[[-1,0,0],[0,0,1]]],
	["Land_BagFence_Corner_F",[1.5,-3.75,-0.25 + _zCorrection],[[0,1,0],[0,0,1]]],
	["Land_BagFence_Short_F",[1.875,-1.75,-0.25 + _zCorrection],[[1,0,0],[0,0,1]]],
	["Land_BagFence_Short_F",[0.25,-1.875,-0.25 + _zCorrection],[[-1,0,0],[0,0,1]]],
	["ShootingPos_F",[0.25,-1.875,-0.25 + _zCorrection],[[0,1,0],[0,0,1]]],
	["ShootingPos_F",[0.25,-1.875,-0.25 + _zCorrection],[[0,1,0],[0,0,1]]],
	["Land_WoodenWall_01_m_pole_F",[-3,0,0.5 + _zCorrection],[[0,1,0],[0,0,1]]],
	["Land_Rampart_F",[1.375,0.75,-1.75 + _zCorrection],[[-1,0,0],[0,-0.325,0.945]]],
	["Land_Rampart_F",[2.875,-1.75,-1.75 + _zCorrection],[[0,1,0],[-0.325,0,0.945]]],
	["Land_Rampart_F",[0.5,-3.625,-1.75 + _zCorrection],[[1,0,0],[0,0.325,0.945]]],
	["Land_Rampart_F",[-2.375,-1.625,-1.75 + _zCorrection],[[0,1,0],[-0.358,0,0.933]]],
	["UserTexture1m_F",[-3,-0.045,2 + _zCorrection],[[0,1,0],[0,0,1]]]
];

{
	_x params ["_objType","_relPos","_vectorDirAndUp"];
	_obj = _objType createVehicle [0,0,0];
	_obj attachTo [_centre,_relPos];
	_obj setVectorDirAndUp _vectorDirAndUp;
} forEach _composition;

// _centre setVectorDirAndUp _centreDirAndUp;

_centre setDir _dir;

_centre setPos _pos;


// NOTE: SHOULD WORK BUT IT FUCKING DOESN'T, WHEN CALLED INDIVIDUALLY EACH OBJECT IS POSITIONED CORRECTLY, WHEN CALLED TOGETHER THEY'RE ALL OVER THE PLACE. WTFFFFFFFFFF????!!!!!



{_vectorDirAndUp = [vectorDir _x, vectorUp _x]; _x attachTo [centre1]; _x setVectorDirAndUp _vectorDirAndUp;} forEach (centre1 nearObjects 10);

objectsArray1 = []; {objectsArray1 pushBack [typeOf _x,getPos _x, [vectorDir _x,vectorUp _x]];} forEach (centre1 nearObjects 10);


centre1 = createVehicle ["Sign_Arrow_Direction_Blue_F",[0,0,0],[],0,"CAN_COLLIDE"];

composition = [
	["Land_BagFence_Corner_F",[0.5,-0.5,-0.25],[[-1,0,0],[0,0,1]]],
	["Land_BagFence_Corner_F",[1.5,-3.75,-0.25],[[0,1,0],[0,0,1]]],
	["Land_BagFence_Short_F",[1.875,-1.75,-0.25],[[1,0,0],[0,0,1]]],
	["Land_BagFence_Short_F",[0.25,-1.875,-0.25],[[-1,0,0],[0,0,1]]],
	//["ShootingPos_F",[0.25,-1.875,-0.25],[[0,1,0],[0,0,1]]],
	//["ShootingPos_F",[0.25,-1.875,-0.25],[[0,1,0],[0,0,1]]],
	["Land_WoodenWall_01_m_pole_F",[-3,0,0.5],[[0,1,0],[0,0,1]]],
	//["Land_Rampart_F",[1.375,0.75,-1.75],[[-1,0,0],[0,-0.325,0.945]]],
	//["Land_Rampart_F",[2.875,-1.75,-1.75],[[0,1,0],[-0.325,0,0.945]]],
	//["Land_Rampart_F",[0.5,-3.625,-1.75],[[1,0,0],[0,0.325,0.945]]],
	//["Land_Rampart_F",[-2.375,-1.625,-1.75],[[0,1,0],[-0.358,0,0.933]]],
	["UserTexture1m_F",[-3,-0.045,2],[[0,1,0],[0,0,1]]]
];

{_x params ["_type","_pos","_vectorDirAndUp"]; _obj = createVehicle [_type,_pos,[],0,"CAN_COLLIDE"]; _obj attachTo [centre1]; _obj setVectorDirAndUp _vectorDirAndUp;} forEach composition;

// EVEN THE ABOVE DOESN'T WORK. I FUCKING GIVE UP. FUCK FUCKING CUSTOM COMPOSITIONS IN THE FUCKING ARSE!