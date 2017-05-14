scriptName "fn_addActions";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Adds vanilla actions to an object to control rifle range with matching Range ID.

	Parameter(s):
	_this select 0: Object - Object actions are to be added to.
	_this select 1: String - Unique Range ID, first defined when creating a rifle range with RR_fnc_iniRifleRange and passed to all subsequent functions.

	Returns:
	Nothing
*/
#define SELF RR_fnc_addActions

params [["_obj",objNull,[objNull]],["_rangeID","",[""]]];

private ["_laneIndecies","_actionLane","_actionStart","_actionStop","_actionReset","_actionClearHighScore","_actionPowerOn","_actionPowerOff","_actionName","_radius"];

if (isNull _obj) exitWith {};

waitUntil {missionNamespace getVariable [format ["%1_INIT_DONE",_rangeID],false]};

if (typeOf _obj == "Land_Laptop_unfolded_F") then {
	_obj setObjectTexture [0,"rifleRange\textures\blk.paa"];
};

missionNameSpace setVariable [format ["%1_CONTROL_OBJ",_rangeID], _obj];

waitUntil {missionNamespace getVariable [format ["%1_INIT_DONE",_rangeID],false]};

_laneIndecies = [];

_actionLane = nil;

// Lanes 1 to n

for "_n" from 1 to (missionNameSpace getVariable format ["%1_LANE_COUNT",_rangeID]) do {
	_index = _n - 1;

	_laneIndecies pushBack _index;
};

_radius = 1;

// All Lanes

_actionStart = _obj addAction ["Start Firing Drill", {[_this select 0, _this select 1, _this select 3] remoteExec ["RR_fnc_startAction",2]}, [_rangeID,_laneIndecies], 199, false, true, "", "", _radius];

_actionReset = _obj addAction ["Stop Firing Drill", {[_this select 0, _this select 1, _this select 3] remoteExec ["RR_fnc_resetAction",2]}, [_rangeID,_laneIndecies], 199, false, true, "", "", _radius];

_actionClearHighScore = _obj addAction ["Clear High-scores", {[_this select 0, _this select 1, _this select 3] remoteExec ["RR_fnc_clearHighScoreAction",2]}, [_rangeID,_laneIndecies], 198, false, true, "", "", _radius];

// Test Loudspeaker

_actionTestShort = _obj addAction ["Test Speaker: Short Sound", {[_this select 0, _this select 1, _this select 3] remoteExec ["RR_fnc_testSpeakerAction",2]}, [_rangeID,"rifleRange\sounds\BUZZER_ARENA_SHORT.wav"], 197, false, true, "", "", _radius];

_actionTestLong = _obj addAction ["Test Speaker: Long Sound", {[_this select 0, _this select 1, _this select 3] remoteExec ["RR_fnc_testSpeakerAction",2]}, [_rangeID,"rifleRange\sounds\BUZZER_ARENA_LONG.wav"], 196, false, true, "", "", _radius];

// Power On

waitUntil {missionNamespace getVariable [format ["%1_INIT_DONE", _rangeID],false]};

[_obj, nil, [_rangeID,_laneIndecies]] remoteExec ["RR_fnc_powerOnAction",2];