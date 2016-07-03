scriptName "fn_refreshScores";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Refreshes scores shown on scoreboard for score, high score or both. Checks the current score against the score currently displayed on scoreboard, if they are different then it calls RR_fnc_numberToTexture to get the texture representation of the current score then applies that to the scoreboard by calling RR_fnc_setNumberTextures.

	Parameter(s):
	_this select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
	_this select 1: Number - Index of lane being modified.
	_this select 2: Bool - Update score column.
	_this select 3: Bool - Update high score column.

	Returns:
	Nothing
*/
#define SELF RR_fnc_refreshScores

// Debug
// "fn_refreshScores" remoteExec ["systemChat",0,false];
//

params [["_rangeID","",[""]],["_laneIndex",0,[0]],["_updateScore",true,[true]],["_updateHighScore",false,[true]]];

if (_updateScore && {missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 0 != missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 2}) then {
	_textureArray = missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 0 call RR_fnc_numberToTexture;
	[_rangeID,_laneIndex,0,_textureArray] remoteExec ["RR_fnc_setNumberTextures",0,format ["%1_%2_score_display",_rangeID,_laneIndex]];
	missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex set [2,missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 0];
};

if (_updateHighScore && {missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 1 != missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 3}) then {
	_textureArray = missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 1 call RR_fnc_numberToTexture;
	[_rangeID,_laneIndex,1,_textureArray] remoteExec ["RR_fnc_setNumberTextures",0,format ["%1_%2_highscore_display",_rangeID,_laneIndex]];
	missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex set [3,missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 1];
};