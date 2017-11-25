scriptName "fn_createSBDigit";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Creates a texture object for each digit of the scoreboard.

	Parameter(s):
	_this select 0: Object - Scoreboard object defined by naming it in the format <RANGE_ID>_SCOREBOARD (eg ETR_SCOREBOARD).
	_this select 1: Number - Scoreboard direction.
	_this select 2: Array - Object space cordinates to attach tecture object to scoreboard object.

	Returns:
	Object - Texture object
*/
#define SELF RR_fnc_createSBDigit

// Debug
// "fn_createSBDigit" remoteExec ["systemChat",0,false];
//

params [["_scoreboardObj",objNull,[objNull]],["_scoreboardDir",0,[0]],["_pos",[0,0,0],[[]],[3]]];

private "_obj";

_obj = createVehicle ["UserTexture1m_F", [0,0,0], [], 0, "NONE"];
_obj setDir _scoreboardDir;
_obj attachTo [_scoreboardObj,_pos];
_obj setObjectTextureGlobal [0,"rifleRange\textures\blank.paa"];

_obj
