scriptName "fn_targetHit";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Function to be called from an on hit event handler attached to a target object.

	Parameter(s):
	_this select 0: Object - Target the EH is attached to.
	_this select 1: Object - Object which caused the hit, usually player object.
	_this select 2: Number - Damage delt to target.

	Returns:
	Bool - True when done
*/
#define SELF RR_fnc_targetHit

// Debug
// "fn_targetHit" remoteExec ["systemChat",0,false];
//

params [["_targ",objNull,[objNull]],["_shooter",objNull,[objNull]],["_damage",0,[0]]];

_targ setDamage 0;

if (_targ getVariable ["isActive",false]) then {

	_targ setVariable ["hitNumber",(_targ getVariable ["hitNumber",0]) + 1];

	if (_targ getVariable ["isScoring",false]) then {

		private _targVarName = vehicleVarName _targ;

		private _rangeID = _targ getVariable ["rangeID",""];

		private _scoreGroup =  _targ getVariable ["scoreGroup",-1];

		Private _scoreGroupIndex = _scoreGroup - 1;

		private _distIndex = if (1 > _scoreGroup || _scoreGroup > 5) then {_targ getVariable ["distIndex",0]} else {_scoreGroupIndex};

		private _laneIndex = _targ getVariable ["laneIndex",0];

		if (missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 0) then {
			[_rangeID,_laneIndex,_distIndex,1] call RR_fnc_addScore;
		};
	};
};
