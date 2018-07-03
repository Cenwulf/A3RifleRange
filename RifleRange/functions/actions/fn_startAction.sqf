scriptName "fn_startAction";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Starts the firing drill on each lane passed in _laneIndecies array.

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who performed the action.
	_this select 2: Array - Custom params passed through ACE action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers referring to each lane to be modified by function.

	Returns:
	Nothing
*/
#define SELF RR_fnc_startAction

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

private _laneCount = missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID];

sleep 0.5;

{
	if (_x < _laneCount) then {

		private _laneIndex = _x;

		if !(missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x select 0) then {

			missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [0,true]; // started = true
			missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [2,false]; // reset = false

			for "_i" from 0 to 4 do {
				missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select _i set [0,0]; // set score to 0
				[_rangeID,_laneIndex,_i,_laneIndex,_i] spawn RR_fnc_refreshScores; // refresh scoreboard to show the current scores
			};

			{
				if (_forEachIndex >= _laneCount) then {
					[_rangeID,_forEachIndex,_laneIndex,_laneIndex,4] call RR_fnc_refreshScores;
				};
			} forEach (missionNamespace getVariable format ["%1_DIGITS_ARRAY", _rangeID]); // refresh scores for all non lane specific scoreboards
			// TODO: this is all messy as balls, need to clean it up within the refresh scores function. With multiple scoreboards the current way scores are refreshed needs to be revised.
		};
		publicVariable format ["%1_STATES_ARRAY",_rangeID];
	} else {
		diag_log format ["ERROR: fn_startAction.sqf - Lane Index ""%1"" does not exist.",_x];
	};
} forEach _laneIndecies;

sleep 0.5;

_startTime = time;
_program = missionNamespace getVariable format ["%1_CURRENT_DRILL",_rangeID] select 1; // gets current program for currently selected drill

{
	private _primary = if (_forEachIndex == 0) then {true} else {false}; // designates one lane to control buzzer timing
	[_rangeID,_x,_startTime,_program,_primary] spawn RR_fnc_runProgram; // calls run program for each lane
} forEach _laneIndecies;
