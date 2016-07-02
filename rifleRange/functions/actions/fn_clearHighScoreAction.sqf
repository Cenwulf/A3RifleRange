scriptName "fn_clearHighScoreAction";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Clears the high score of each lane passed in _laneIndecies array.

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who performed the action.
	_this select 2: Array - Custom params passed through ACE action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers referring to each lane to be modified by function.

	Returns:
	Nothing
*/
#define SELF RR_fnc_clearHighScoreAction

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

Sleep 0.5;

{
	if (_x < missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID]) then {
		missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _x set [1, -1];
		[_rangeID,_x,false,true] call RR_fnc_refreshScores;
	} else {
		diag_log format ["ERROR: ""%1"" - Lane index ""%2"" does not exist.",SELF,_x];
	};
} forEach _laneIndecies;