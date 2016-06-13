params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

_bool = false;

{
	if (missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _x select 0) exitWith {_bool = true};
} forEach _laneIndecies;

_bool