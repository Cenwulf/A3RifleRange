params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

_bool = true;

{
	if !(missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _x select 1) exitWith {_bool = false};
} forEach _laneIndecies;

_bool