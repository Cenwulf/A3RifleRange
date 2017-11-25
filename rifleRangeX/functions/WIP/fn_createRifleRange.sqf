
if !isServer exitWith {};
params [["_logic",objNull,[objNull,[]],[2,3]],["_rangeID","",[""]],["_rangeType","ETR",[""]],["_laneCount",1,[0]],["_inverted",false,[true]],["_dir",0,[0]]];

_handle = [_rangeID,_rangeType,_laneCount] spawn RR_fnc_initRifleRange;

waitUntil {scriptDone _handle};

if (missionNamespace getVariable [format ["%1_NEW", _rangeID],_rangeID] != _rangeID) then {
	_rangeID = missionNamespace getVariable format ["%1_NEW", _rangeID];
};

if (typeName _logic == typeName []) then {
	_logic resize 2;
	_pos = +_logic;
	_pos pushBack 0;
	_grp = createGroup sideLogic;
    _logic = _grp createUnit ["Logic",_pos,[],0,"CAN_COLLIDE"];
	_logic setDir _dir;
};

switch _rangeType do {
	case "ETR": {
		[_logic,_rangeID,_rangeType,_laneCount,_inverted] call RR_fnc_createRifleRangeETR;
	};
};
