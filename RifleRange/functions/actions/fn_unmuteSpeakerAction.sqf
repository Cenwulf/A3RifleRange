scriptName "fn_unmuteSpeakerAction";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Stops the firing drill currently running on each lane passed in _laneIndecies array.

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who performed the action.
	_this select 2: Array - Custom params passed through ACE action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers referring to each lane to be modified by function.

	Returns:
	Nothing
*/
#define SELF RR_fnc_unmuteSpeakerAction

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]]];

missionNamespace setVariable [format ["%1_SPEAKER_MUTED",_rangeID],false,true];
