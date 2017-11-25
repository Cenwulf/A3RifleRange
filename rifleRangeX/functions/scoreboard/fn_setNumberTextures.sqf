scriptName "fn_setNumberTextures";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Sets the textures of a set of two scoreboard digits.

	Parameter(s):
	_this select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
	_this select 1: Number - Index of the lane which is being modified.
	_this select 2: Number - Index of the targets distance grouping, expects a number between 0 and 3.
	_this select 3: Number - 0 or 1 denoting the current score or high score columns of the scorebaord
	_this select 4: Array - Array created by RR_fnc_numberToTexture contains 2 texture paths of number textures

	Returns:
	Nothing
*/
#define SELF RR_fnc_setNumberTextures

// Debug
// "fn_setNumberTextures" remoteExec ["systemChat",0,false];
//

params [["_rangeID","",[""]],["_laneIndex",0,[0]],["_distIndex",0,[0]],["_scoreColumn",0,[0]],["_texArray",[],[[]]]];

{
	if (count (missionNamespace getVariable format ["%1_DIGITS_ARRAY", _rangeID] select _laneIndex) != 0) then {
		missionNamespace getVariable format ["%1_DIGITS_ARRAY", _rangeID] select _laneIndex select _distIndex select _scoreColumn select _forEachIndex setObjectTextureGlobal [0,_x];
	};
} forEach _texArray;
