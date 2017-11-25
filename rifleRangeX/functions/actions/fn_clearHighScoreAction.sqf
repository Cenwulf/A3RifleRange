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

private _laneCount = missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID];

Sleep 0.5;

{
	if (_x < _laneCount) then {

		private _laneIndex = _x;

		for "_i" from 0 to 4 do {
			missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select _i set [1,-1]; // set highscore to -1
			[_rangeID,_laneIndex,_i,_laneIndex,_i,false,true] spawn RR_fnc_refreshScores; // refresh scoreboard to show the current high scores
		};

		{
			if (_forEachIndex >= _laneCount) then {
				[_rangeID,_forEachIndex,_laneIndex,_laneIndex,4,false,true] call RR_fnc_refreshScores;
			};
		} forEach (missionNamespace getVariable format ["%1_DIGITS_ARRAY", _rangeID]); // refresh high scores for all non lane specific scoreboards
		// TODO: this is all messy as balls, need to clean it up within the refresh scores function. With multiple scoreboards the current way scores are refreshed needs to be revised.
	} else {
		diag_log format ["ERROR: fn_ClearHighScoreAction.sqf - Lane Index ""%1"" does not exist.",_x];
	};
} forEach _laneIndecies;
