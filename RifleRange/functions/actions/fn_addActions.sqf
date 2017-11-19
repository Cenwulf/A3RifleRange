scriptName "fn_addActions";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Adds vanilla actions to an object to control rifle range with matching Range ID. Can be called for player objects also. In this case only the start, reset and clear highscore actions are added for player objects and actions are restricted to the player they are added to.

	Parameter(s):
	_this select 0: Object - Object actions are to be added to.
	_this select 1: String - Unique Range ID, first defined when creating a rifle range with RR_fnc_iniRifleRange and passed to all subsequent functions.

	Returns:
	Nothing
*/
#define SELF RR_fnc_addActions

params [["_obj",objNull,[objNull]],["_rangeID","",[""]]];

private ["_laneIndecies","_actionLane","_actionStart","_actionStop","_actionReset","_actionClearHighScore","_actionPowerOn","_actionPowerOff","_actionName","_radius"];

waitUntil {!isNull player};

if (isNull _obj) exitWith {};

waitUntil {missionNamespace getVariable [format ["%1_INIT_DONE", _rangeID],false]};

if (typeOf _obj == "Land_Laptop_unfolded_F") then {
	_obj setObjectTexture [0,"rifleRange\textures\blk.paa"];
};

if !(_obj isKindOf "Man") then {
	missionNameSpace setVariable [format ["%1_CONTROL_OBJ",_rangeID], _obj];
};

waitUntil {missionNamespace getVariable [format ["%1_INIT_DONE",_rangeID],false]};

_laneIndecies = [];

// Lanes 1 to n
for "_n" from 1 to (missionNameSpace getVariable format ["%1_LANE_COUNT",_rangeID]) do {
	_index = _n - 1;

	_laneIndecies pushBack _index;
};

//_radius = if (isPlayer _obj) then {-1} else {2};
_radius = 2; // A radius of less than ~1.5 for actions added to player objects makes actions unavailable to that player (they are always 1.5 meters away from themselves...)

// All Lanes
_actionStart = _obj addAction ["Start Firing Drill", {[_this select 0, _this select 1, _this select 3] remoteExec ["RR_fnc_startAction",2]}, [_rangeID,_laneIndecies], 199, false, true, "", "if (isPlayer _target) then {_this == _target} else {true}", _radius];

_actionReset = _obj addAction ["Stop Firing Drill", {[_this select 0, _this select 1, _this select 3] remoteExec ["RR_fnc_resetAction",2]}, [_rangeID,_laneIndecies], 198, false, true, "", "if (isPlayer _target) then {_this == _target} else {true}", _radius];

_actionClearHighScore = _obj addAction ["Clear High-scores", {[_this select 0, _this select 1, _this select 3] remoteExec ["RR_fnc_clearHighScoreAction",2]}, [_rangeID,_laneIndecies], 197, false, true, "", "if (isPlayer _target) then {_this == _target} else {true}", _radius];

// Test Loudspeaker
if !(isPlayer _obj) then {
	_actionTestShort = _obj addAction ["Test Speaker: Short Sound", {[_this select 0, _this select 1, _this select 3] remoteExec ["RR_fnc_testSpeakerAction",2]}, [_rangeID,"rifleRange\sounds\BUZZER_ARENA_SHORT.wav"], 196, false, true, "", "", _radius];

	_actionTestLong = _obj addAction ["Test Speaker: Long Sound", {[_this select 0, _this select 1, _this select 3] remoteExec ["RR_fnc_testSpeakerAction",2]}, [_rangeID,"rifleRange\sounds\BUZZER_ARENA_LONG.wav"], 195, false, true, "", "", _radius];
};

// Power On
[_obj, nil, [_rangeID,_laneIndecies]] remoteExec ["RR_fnc_powerOnAction",2];
