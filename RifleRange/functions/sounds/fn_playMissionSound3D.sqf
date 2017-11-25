scriptName "fn_playMissionSound3D";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Custom function that executes the playSound3D command without needing to provide the full path to the mission folder.

	Parameter(s):
	See https://community.bistudio.com/wiki/playSound3D

	Returns:
	Nothing
*/
#define SELF RR_fnc_playMissionSound3D

params [["_soundPath","",[""]],["_source",objNull,[objNull]],["_isInside",false,[true]],["_soundPos",[0,0,0],[[]],[3]],["_volume",1,[0]],["_pitch",1,[1]],["_dist",0,[0]]];

private ["_missionPath","_soundToPlay"];

_soundPos = if (_soundPos isEqualTo [0,0,0]) then {getPos _source} else {_soundPos};

_missionPath = [str missionConfigFile, 0, -15] call BIS_fnc_trimString;

_soundToPlay = _missionPath + _soundPath;

playSound3D [_soundToPlay,_source,_isInside,_soundPos,_volume,_pitch,_dist];
