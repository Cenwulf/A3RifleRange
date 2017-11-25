scriptName "fn_addScore";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Adds the passed number to the score for the passed lane.

	Parameter(s):
	_this select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
	_this select 1: Number - Index of lane being modified.
	_this select 2: Number - Index of the targets distance grouping, expects a number between 0 and 3.
	_this select 3: Number - Score to be added.

	Returns:
	Nothing
*/
#define SELF RR_fnc_addScore

// Debug
// "fn_addScore" remoteExec ["systemChat",0,false];
//

params [["_rangeID","",[""]],["_laneIndex",0,[0]],["_distIndex",0,[0]],["_score",0,[0]]];

private _scoresArray = missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex;

private _laneCount = missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID];

_scoresArray select _distIndex set [0,(_scoresArray select _distIndex select 0) + _score]; // update the score for the lane at that distance
_scoresArray select 4 set [0,(_scoresArray select 4 select 0) + _score]; // update the total score for that lane

// if high score is lower than score for specific distance grouping then update the high score
if (_scoresArray select _distIndex select 0 > _scoresArray select _distIndex  select 1) then {
	_scoresArray select _distIndex set [1, _scoresArray select _distIndex select 0];
};
 // if total high score is lower than total score then update the total high score
if (_scoresArray select 4 select 0 > _scoresArray select 4  select 1) then {
	_scoresArray select 4 set [1, _scoresArray select 4 select 0];
};

[_rangeID,_laneIndex,_distIndex,_laneIndex,_distIndex] call RR_fnc_refreshScores; // refresh distance scores
[_rangeID,_laneIndex,4,_laneIndex,4] call RR_fnc_refreshScores; // refresh total scores
{
	if (_forEachIndex >= _laneCount) then {
		[_rangeID,_forEachIndex,_laneIndex,_laneIndex,4] call RR_fnc_refreshScores;
	};
} forEach (missionNamespace getVariable format ["%1_DIGITS_ARRAY", _rangeID]); // refresh scores for all non lane specific scoreboards
