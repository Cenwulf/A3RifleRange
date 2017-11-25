scriptName "fn_testSpeakerAction";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Demonstrate the speakers functionality while in game, used for familiarisation to the range.

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who performed the action.
	_this select 2: Array - Custom params passed through ACE action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers referring to each lane to be modified by function.

	Returns:
	Nothing
*/
#define SELF RR_fnc_testSpeakerAction


params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_soundPath","",[""]]];

[_soundPath,missionNamespace getVariable format ["%1_loudspeaker",_rangeID],false,missionNamespace getVariable format ["%1_loudspeaker",_rangeID] modelToWorld [0,0.00390625,3.96981],3] call RR_fnc_playMissionSound3D;
