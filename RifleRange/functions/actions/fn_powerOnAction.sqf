scriptName "fn_powerOnAction";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Power up the range, set all lanes to 'reset' state.

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who performed the action.
	_this select 2: Array - Custom params passed through ACE action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers referring to each lane to be modified by function.

	Returns:
	Nothing
*/
#define SELF RR_fnc_powerOnAction

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

private _laneCount = missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID];

sleep 0.5;

if (typeOf (missionNamespace getVariable format ["%1_CONTROL_OBJ",_rangeID]) == "Land_Laptop_unfolded_F") then {
	missionNamespace getVariable format ["%1_CONTROL_OBJ",_rangeID] setObjectTextureGlobal [0,"rifleRange\textures\laptop5a.paa"];
};

// display -- on scoreboard (-1)
{
	if (_x < _laneCount) then {

		private _laneIndex = _x;


		missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [2,true];

		publicVariable format ["%1_STATES_ARRAY",_rangeID];

		for "_i" from 0 to 4 do {
			missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select _i set [0,-1]; // set score to -1
			missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select _i set [1,-1]; // set highscore to -1
			[_rangeID,_laneIndex,_i,_laneIndex,_i,true,true] spawn RR_fnc_refreshScores; // refresh scoreboard to show the current scores

		};

		{
			if (_forEachIndex >= _laneCount) then {
				[_rangeID,_forEachIndex,_laneIndex,_laneIndex,4,true,true] call RR_fnc_refreshScores;
			};
		} forEach (missionNamespace getVariable format ["%1_DIGITS_ARRAY", _rangeID]); // refresh scores for all non lane specific scoreboards
		// TODO: this is all messy as balls, need to clean it up within the refresh scores function. With multiple scoreboards the current way scores are refreshed needs to be revised.
	};
} forEach _laneIndecies;

// display x on all unused lanes
{
	_x setObjectTextureGlobal [0,"rifleRange\textures\x.paa"];
} forEach (missionNamespace getVariable format ["%1_UNUSED_DIGITS_ARRAY", _rangeID]);

// lower all targets on range
{
	_x setDamage 0;
	_x animate ["Terc",1];
} forEach (missionNamespace getVariable format ["%1_ALL_TARGETS",_rangeID]);

missionNamespace setVariable [format ["%1_POWER_ON",_rangeID],true,true];
