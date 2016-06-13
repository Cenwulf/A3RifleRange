scriptName "fn_resetAction:";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Resets score and target positions for each lane passed in _laneIndecies array.

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who perforemed the action.
	_this select 2: Array - Custom params passed through ACE action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers refering to each lane to be modified by function.

	Returns:
	Nothing
*/
#define SELF _fnc_fn_resetAction

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

Sleep 0.5;

{
	if (_x < missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID]) then {
		if !(missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x select 3) then {
			missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _x set [0,-1];
			[_rangeID,_x] call RR_fnc_refreshScores;

			{
				_x setDamage 0;
				_x animate ["Terc",1];
			} forEach (missionNamespace getVariable format ["%1_TARGETS_BY_LANE",_rangeID] select _x);

			missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [0,false]; // started = false
			missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [1,false]; // stopped = false
			missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _x set [2,true]; // reset = true

			publicVariable format ["%1_STATES_ARRAY",_rangeID];
		};
	} else {
		diag_log format ["ERROR: ""%1"" - Lane Index ""%2"" does not exist.",SELF,_x];
	};
} forEach _laneIndecies;

// TODO: Convert to new standard