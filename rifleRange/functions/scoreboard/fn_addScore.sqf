scriptName "fn_addScore";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Adds the passed number to the score for the passed lane.

	Parameter(s):
	_this select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
	_this select 1: Number - Index of lane being modified.
	_this select 2: Number - Score to be added.

	Returns:
	Nothing
*/
#define SELF RR_fnc_addScore

// Debug
// "fn_addScore" remoteExec ["systemChat",0,false];
//

params [["_rangeID","",[""]],["_laneIndex",0,[0]],["_score",0,[0]]];

missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex set [0,(missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select 0) + _score];
if (missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select 0 > missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select 1) then {
	missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex set [1,missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select 0];
};

[_rangeID,_laneIndex] call RR_fnc_refreshScores;