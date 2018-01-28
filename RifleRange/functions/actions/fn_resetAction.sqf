scriptName "fn_resetAction";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Resets score and target positions for each lane passed in _laneIndecies array.

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who performed the action.
	_this select 2: Array - Custom params passed through ACE action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers referring to each lane to be modified by function.

	Returns:
	Nothing
*/
#define SELF RR_fnc_resetAction

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

private _laneCount = missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID];

Sleep 0.5;

{
	if (_x < _laneCount) then {

		private _laneIndex = _x;

		if !(missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x select 3) then {

			{
				_x setDamage 0;
				_x animate ["Terc",1];
			} forEach (missionNamespace getVariable format ["%1_TARGETS_BY_LANE",_rangeID] select _x);

			missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [0,false]; // started = false
			missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [1,false]; // stopped = false
			missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [2,true]; // reset = true
			missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [3,false]; // pause = false

			for "_i" from 0 to 4 do {
				missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select _i set [0,-1]; // set score to -1
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
		diag_log format ["ERROR: fn_resetAction.sqf - Lane Index ""%1"" does not exist.",_x];
	};
} forEach _laneIndecies;
