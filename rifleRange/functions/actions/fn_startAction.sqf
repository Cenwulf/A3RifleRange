scriptName "fn_startAction:";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Starts the firing drill on each lane passed in _laneIndecies array.

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who perforemed the action.
	_this select 2: Array - Custom params passed through ACE action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers refering to each lane to be modified by function.

	Returns:
	Nothing
*/
#define SELF _fnc_fn_startAction

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

sleep 0.5;

{
	if (_x < missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID]) then {
		if !(missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x select 0) then {
			missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _x set [0,0];
			[_rangeID,_x] call RR_fnc_refreshScores;

			missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [0,true]; // started = true
			missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [1,false]; // stopped = false
			missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [2,false]; // reset = false

			publicVariable format ["%1_STATES_ARRAY",_rangeID];
		};
	} else {
		diag_log format ["ERROR: ""%1"" - Lane Index ""%2"" does not exist.",SELF,_x];
	};
} forEach _laneIndecies;

sleep 0.5;

_this spawn RR_fnc_startFiringDrill;