scriptName "fn_powerOffAction:";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Power down the range, resets all lanes to initial state.

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who perforemed the action.
	_this select 2: Array - Custom params passed through ACE action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers refering to each lane to be modified by function.

	Returns:
	Nothing
*/
#define SELF _fnc_fn_powerOffAction

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

sleep 0.5;

missionNamespace setVariable [format ["%1_POWER_ON",_rangeID],false];

if (typeOf (missionNameSpace getVariable format ["%1_CONTROL_OBJ",_rangeID]) == "Land_Laptop_unfolded_F") then {
	missionNameSpace getVariable format ["%1_CONTROL_OBJ",_rangeID] setObjectTextureGlobal [0,"rifleRange\textures\blk.paa"];
};

// raise all targets on range
{
	_x setDamage 0;
	_x animate ["Terc",0];
} forEach (missionNamespace getVariable format ["%1_ALL_TARGETS",_rangeID]);

// display blank on scoreboard (-2)
{
	if (_x < missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID]) then {
		missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] set [_x,[false,false,false,false]]; // resets states array

		publicVariable format ["%1_STATES_ARRAY",_rangeID];

		missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _x set [0,-2]; // set score to -2
		missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _x set [1,-2]; // set highscore to -2
		[_rangeID,_x,true,true] spawn RR_fnc_refreshScores; // refresh scoreboard to show the current scores
	} else {
		diag_log format ["ERROR: ""%1"" - Lane Index ""%2"" does not exist.",SELF,_x];
	};
} forEach _laneIndecies;