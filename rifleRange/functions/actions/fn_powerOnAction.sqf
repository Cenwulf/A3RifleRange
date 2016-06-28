scriptName "fn_powerOnAction:";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Power up the range, set all lanes to 'reset' state.

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who perforemed the action.
	_this select 2: Array - Custom params passed through ACE action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers refering to each lane to be modified by function.

	Returns:
	Nothing
*/
#define SELF _fnc_fn_powerOnAction

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

sleep 0.5;

if (typeOf (missionNamespace getVariable format ["%1_CONTROL_OBJ",_rangeID]) == "Land_Laptop_unfolded_F") then {
	missionNamespace getVariable format ["%1_CONTROL_OBJ",_rangeID] setObjectTextureGlobal [0,"rifleRange\textures\laptop5a.paa"];
};
/*
// display 00 on score board (100)
{
	if (_x < missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID]) then {
		missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _x set [0,100];
		missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _x set [1,100];
		[_rangeID,_x,true,true] spawn RR_fnc_refreshScores;
	} else {
		diag_log format ["ERROR: ""%1"" - Lane Index ""%2"" does not exist.",SELF,_x];
	};
} forEach _laneIndecies;

sleep ((random 1) + 0.5);

// display blank on scoreboard (-2)
{
	if (_x < missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID]) then {
		missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _x set [0,-2];
		missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _x set [1,-2];	};
	[_rangeID,_x,true,true] spawn RR_fnc_refreshScores;
} forEach _laneIndecies;

sleep ((random 1) + 0.5);
*/
// display -- on scoreboard (-1)
{
	if (_x < missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID]) then {
		missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _x set [0,-1];
		missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _x set [1,-1];
		[_rangeID,_x,true,true] spawn RR_fnc_refreshScores;
		missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [2,true];
		publicVariable format ["%1_STATES_ARRAY",_rangeID];
	};
} forEach _laneIndecies;

// lower all targets on range
{
	_x setDamage 0;
	_x animate ["Terc",1];
} forEach (missionNamespace getVariable format ["%1_ALL_TARGETS",_rangeID]);

missionNamespace setVariable [format ["%1_POWER_ON",_rangeID],true,true];