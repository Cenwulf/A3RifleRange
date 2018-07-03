scriptName "fn_drillSelectAction";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Sets the passed _drillID as the current firing drill for lane matching _laneID and also sets .

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who performed the action.
	_this select 2: Array - Custom params passed through action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers referring to each lane to be modified by function.
		_this select 2 select 2: String - ID of firing drill to be set as current firing drill.

	Returns:
	Nothing
*/
#define SELF RR_fnc_drillSelectAction

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]],["_drillIndex",0,[0]]];

missionNamespace setVariable [format ["%1_CURRENT_DRILL",_rangeID],missionNamespace getVariable format ["%1_DRILLS",_rangeID] select _drillIndex,true];
