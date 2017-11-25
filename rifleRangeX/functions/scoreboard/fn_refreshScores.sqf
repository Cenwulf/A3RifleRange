scriptName "fn_refreshScores";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Refreshes scores shown on scoreboard for score, high score or both. Checks the current score against the score currently displayed on scoreboard, if they are different then it calls RR_fnc_numberToTexture to get the texture representation of the current score then applies that to the scoreboard by calling RR_fnc_setNumberTextures.

	Parameter(s):
	_this select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
	_this select 1: Number - Index of lane scorebaord being updated. each lane has it's own scoreboard whos index matches the lane index and show scores broken down by target distance. Any additional scorebaords whos index does not match a lane index show the total scores for all lanes.
	_this select 2: Number - Index of the scoreboard row being updated. 0 is the top row, 4 is the bottom row.
	_this select 3: Number - Index of lane being scored.
	_this select 4: Number - Index of the targets distance grouping, expects a number between 0 and 3.
	_this select 5: Bool - Update score column.
	_this select 6: Bool - Update high score column.

	Returns:
	Nothing
*/
#define SELF RR_fnc_refreshScores

// Debug
// "fn_refreshScores" remoteExec ["systemChat",0,false];
//

params [["_rangeID","",[""]],["_scoreboardIndex",0,[0]],["_scoreboardRowIndex",0,[0]],["_laneIndex",0,[0]],["_distIndex",0,[0]],["_updateScore",true,[true]],["_updateHighScore",false,[true]]];

private _scoresArray = missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select _distIndex;

if (_updateScore/* && {_scoresArray select 0 != _scoresArray select 2}*/) then {

	_textureArray = [_scoresArray select 0] call RR_fnc_numberToTexture;

	// [_rangeID,_scoreboardIndex,_scoreboardRowIndex,0,_textureArray] remoteExec ["RR_fnc_setNumberTextures",0,format ["%1_%2_%3_score_display",_rangeID,_scoreboardIndex,_scoreboardRowIndex]]; // NOTE: Use this if UserTextureObject_1m_F ever stops propergating over the network again

	[_rangeID,_scoreboardIndex,_scoreboardRowIndex,0,_textureArray] call RR_fnc_setNumberTextures; // NOTE: Remove this if UserTextureObject_1m_F ever stops propergating over the network again

	_scoresArray set [2,_scoresArray select 0];

};

if (_updateHighScore/* && {_scoresArray select 1 != _scoresArray select 3}*/) then {

	_textureArray = [_scoresArray select 1] call RR_fnc_numberToTexture;

	// [_rangeID,_scoreboardIndex,_scoreboardRowIndex,1,_textureArray] remoteExec ["RR_fnc_setNumberTextures",0,format ["%1_%2_%3_score_display",_rangeID,_scoreboardIndex,_scoreboardRowIndex]]; // NOTE: Use this if UserTextureObject_1m_F ever stops propergating over the network again

	[_rangeID,_scoreboardIndex,_scoreboardRowIndex,1,_textureArray] call RR_fnc_setNumberTextures; // NOTE: Remove this if UserTextureObject_1m_F ever stops propergating over the network again

	_scoresArray set [3,_scoresArray select 1];
};
