params [["_logic",[],[objNull,[]]],["_rangeID","",[""]],["_rangeType","ETR",[""]],["_laneCount",5,[0]],["_inverted",false,[true]]];

[getPos _logic, getDir _logic] call RR_fnc_createLaneDivider;

private ["_objArray","_invert"];

_objArray = [
	["Land_Rampart_F",[-2.88867,-4.58496,0],-1.8,90.48,{_this setVectorUp (_this modelToWorld [-0.228516,-0.0820313,0.120117] vectorDiff getPos _this)}],
	["Land_BagFence_Short_F",[-1.25,-1.8,0],-0.25,0],
	["Land_BagFence_Short_F",[-3,-1.8,0],-0.25,0],
	["Land_BagFence_Short_F",[-4.77148,-1.8,0],-0.25,0],
	["Land_Rampart_F",[-2.88672,-0.817383,0],-1.7,-90,{_this setVectorUp (_this modelToWorld [-0.228516,-0.113281,0.122559] vectorDiff getPos _this)}],
	["Land_Rampart_F",[-2.88672,95.417,0],-1.8,90.48,{_this setVectorUp (_this modelToWorld [-0.228516,-0.0820313,0.120117] vectorDiff getPos _this)}],
	["Land_BagFence_Short_F",[-1.25195,98.2109,0],-0.25,0],
	["Land_BagFence_Short_F",[-3.01172,98.2109,0],-0.25,0],
	["Land_BagFence_Short_F",[-4.77148,98.2109,0],-0.25,0],
	["Land_Rampart_F",[-2.88672,99.1826,0],-1.7,-90,{_this setVectorUp (_this modelToWorld [-0.228516,-0.113281,0.122559] vectorDiff getPos _this)}],
	["Land_Rampart_F",[-2.88672,145.416,0],-1.8,90.48,{_this setVectorUp (_this modelToWorld [-0.228516,-0.0820313,0.120117] vectorDiff getPos _this)}],
	["Land_BagFence_Short_F",[-1.25,148.21,0],-0.25,0],
	["Land_BagFence_Short_F",[-3.01172,148.21,0],-0.25,0],
	["Land_BagFence_Short_F",[-4.77148,148.21,0],-0.25,0],
	["Land_Rampart_F",[-2.88672,149.183,0],-1.7,-90,{_this setVectorUp (_this modelToWorld [-0.228516,-0.113281,0.122559] vectorDiff getPos _this)}],
	["TargetP_Inf1_NoPop_F",[-3,198,0],0,0,[0,0,0]],
	["TargetP_Inf1_NoPop_F",[-4,298,0],0,0],
	["TargetP_Inf1_NoPop_F",[-3,398,0],0,0],
	["Land_Rampart_F",[-3,403.429,0],0,90],
	["SignAd_Sponsor_F",[-3,403.594,0],-0.867458,0]
];

_invert = if _inverted then {1} else {-1};

for "_i" from 1 to _laneCount do {
	_targCount = 0;
	{
		_x params [["_objClass","",[""]],["_modelPos",[],[[]],[2,3]],["_zPos",0,[0]],["_relDir",0,[0]],["_code",{},[{}]]];
		_modelPos = [_invert * ((_modelPos select 0) + ((_i + 1) * 6)), _modelPos select 1, 0];
		_worldPos = _logic modelToWorld _modelPos;
		_objPos = [_worldPos select 0, _worldPos select 1, _zPos];
		_objDir = if _inverted then {_relDir + getDir _logic} else {(_relDir * -1) + getDir _logic};
		_obj = createVehicle [_objClass,_objPos,[],0,"CAN_COLLIDE"];
		_obj setDir _objDir;

		// setVectorUp
		if (_objClass == "Land_Rampart_F" && count _x == 5) then {
			_obj call _code;
		} else {
			switch _objClass do {
				case "TargetP_Inf1_NoPop_F";
				case "Land_Rampart_F": {
					_obj setVectorUp surfaceNormal getPos _obj;
				};
			};
		};
		_laneIndex = if _inverted then {6 - _i} else {_i};

		// Add targets to target arrays
		if (_objClass == "TargetP_Inf1_NoPop_F") then {
			missionNamespace getVariable format ["%1_TARGETS_BY_LANE",_rangeID] select _laneIndex pushBack _obj;
			_targCount = _targCount + 1;
			missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _laneIndex select _targCount pushBack _obj;
		};

		// Apply number texture to lane markers
		if (_objClass == "SignAd_Sponsor_F") then {
			_obj setObjectTextureGlobal [0,format ["rifleRange\textures\laneSign%1.paa",_laneIndex]];
		};
		[[_invert * ((getPos _logic select 0) + ((_i + 1) * 6)),getPos _logic select 1, 0],getDir _logic] call RR_fnc_createLaneDivider; /// fix this
	} forEach _objArray;
};

_syncObjs = synchronizedObjects _logic;


_speakerObj = objNull;
_scoreObj = objNull;

{
	if (typeOf _x == "SignAd_Sponsor_F") then {
		_scoreObj = _x;
		_syncObjs deleteAt _forEachIndex;
	};
	if (typeOF _x == "Land_Loudspeakers_F") then {
		_speakerObj = _x;
		_syncObjs deleteAt _forEachIndex;
	};
} forEach _syncObjs;

_controlObj = if (count _syncObjs == 1) then {_syncObjs select 0} else {objNull};

if (isNull _scoreObj) then { // TODO Functionalise this for range control and speaker
	{
		_x params [["_objClass","",[""]],["_modelPos",[],[[]],[2,3]],["_zPos",0,[0]],["_relDir",0,[0]],["_code",{},[{}]]];
		_worldPos = _logic modelToWorld _modelPos;
		_objPos = [_worldPos select 0, _worldPos select 1, _zPos];
		_objDir = if _inverted then {_relDir + getDir _logic} else {(_relDir * -1) + getDir _logic};
		_obj = createVehicle [_objClass,_objPos,[],0,"CAN_COLLIDE"];
		_obj setDir _objDir;
	} forEach [["SignAd_Sponsor_F",[17.1387,75.6074,0],0,134.605]];
};

//Defalt Range Control Point Pos
if (isNull _controlObj) then {
	{
		_x params [["_objClass","",[""]],["_modelPos",[],[[]],[2,3]],["_zPos",0,[0]],["_relDir",0,[0]],["_code",{},[{}]]];
		_worldPos = _logic modelToWorld _modelPos;
		_objPos = [_worldPos select 0, _worldPos select 1, _zPos];
		_objDir = if _inverted then {_relDir + getDir _logic} else {(_relDir * -1) + getDir _logic};
		_obj = createVehicle [_objClass,_objPos,[],0,"CAN_COLLIDE"];
		_obj setDir _objDir;
		_obj setVectorUp surfaceNormal getPos _obj;
		if (_objClass == "Land_CampingTable_F") then {
			_objPos = _obj modelToWorld [0.234375,-0.046875,-0.406503];
			_objDir = if _inverted then {123.648 + getDir _logic} else {(123.648 * -1) + getDir _logic};
			_controlObj = createVehicle ["Land_Laptop_unfolded_F",_objPos,[],0,"CAN_COLLIDE"];
			_controlObj setDir _objDir;
			_controlObj setVectorUp surfaceNormal getPos _obj;
			_controlObj enableSimulation false;
		};
	} forEach [
		["Land_CampingTable_F",[16.4512,83.1709,0],0,134.605],
		["Land_CampingChair_V1_F",[17.6953,82.7813,0],0,96],
		["Land_BagBunker_Small_F",[16.8984,82.9131,0],0,134.605]
	];
};

// Default loudspeaker
if (isNull _speakerObj) then {
	{
		_x params [["_objClass","",[""]],["_modelPos",[],[[]],[2,3]],["_zPos",0,[0]],["_relDir",0,[0]],["_code",{},[{}]]];
		_worldPos = _logic modelToWorld _modelPos;
		_objPos = [_invert * (_worldPos select 0), _worldPos select 1, _zPos];
		_objDir = if _inverted then {_relDir + getDir _logic} else {(_relDir * -1) + getDir _logic};
		_obj = createVehicle [_objClass,_objPos,[],0,"CAN_COLLIDE"];
		_obj setDir _objDir;
	} forEach [["Land_Loudspeakers_F",[20.3438,84.1465,0],0,134.605]];
};

[_scoreObj,_rangeID] spawn RR_fnc_createScoreboard; //may need to remote exec if i cant fiugure out why user textrue is only created on the server
missionNamespace setVariable [format ["%1_loudspeaker",_rangeID],_speakerObj];

/*

diag_log [typeOf cursorObject, [(thingPrime worldToModel getPos cursorObject) select 0, (thingPrime worldToModel getPos cursorObject) select 1, 0], (getPos cursorObject) select 2, getDir cursorObject - getDir thingPrime, vectorUp cursorObject]; systemChat str ([typeOf cursorObject, [(thingPrime worldToModel getPos cursorObject) select 0, (thingPrime worldToModel getPos cursorObject) select 1, 0], (getPos cursorObject) select 2, getDir cursorObject - getDir thingPrime, vectorUp cursorObject]);