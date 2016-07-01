/*
Possible action structures:

going with 1
1:	LaneN					Action					Condition										Comments
		Start				_startAction			Reset
		Stop  				_stopAction				Started
		Reset Lane			_resetAction			None
		Reset High Score	_clearHighScoreActiom	Stopped


	All Lanes
		Start				_startAction			All Lanes Stopped
		Stop  				_stopAction				Started
		Reset Lane			_resetAction			Stopped
		Reset High Score	_clearHighScoreActiom	Stopped

	Power on				_powerOn

	Shutdown
		Confirm				_shutDownAction



2:	LaneN
		Activate Lane		_activateAction			Inactive
		Deactivate Lane		_deactivateAction		Active
		Start				_startAction			Stopped & Active
		Stop				_stopAction				Started
		Reset Lane			_resetAction			Active
		Reset Highscore		_clearHighScoreActiom	Active, Stopped	& High Score != 0 or -1

	All Active Lanes
		Start/Stop
		Reset Lanes
		Reset Highscore

	Power on				_powerOn				Off

	Shutdown
		Confirm				_shutDownAction			On

*/

params [["_obj",objNull,[objNull]],["_rangeID","",[""]]]; // range that the object will control

private ["_laneIndecies","_actionLane","_actionStart","_actionStop","_actionReset","_actionClearHighScore","_actionPowerOn","_actionPowerOff","_actionName"];

if (isNull _obj) exitWith {};

waitUntil {missionNamespace getVariable [format ["%1_INIT_DONE",_rangeID],false]};

if (typeOf _obj == "Land_Laptop_unfolded_F") then {
	_obj setObjectTexture [0,"rifleRange\textures\blk.paa"];
};

missionNameSpace setVariable [format ["%1_CONTROL_OBJ",_rangeID], _obj];

waitUntil {missionNamespace getVariable [format ["%1_INIT_DONE",_rangeID],false]};

_laneIndecies = [];

// Lanes 1 to n

for "_n" from 1 to (missionNameSpace getVariable format ["%1_LANE_COUNT",_rangeID]) do {
	_index = _n - 1;

	_laneIndecies pushBack _index;

//	_actionLane = [format ["%1%2",_rangeID,_n],format ["Lane %1",_n],"",{},{_this call RR_fnc_powerCondition},{},[_rangeID]] call ace_interact_menu_fnc_createAction;

//	_actionStart = [format ["%1%2Start",_rangeID,_n],"Start","",{_this remoteExec ["RR_fnc_StartAction",2];},{_this call RR_fnc_startCondition},{},[_rangeID,[_index]]] call ace_interact_menu_fnc_createAction;

//	_actionStop = [format ["%1%2Stop",_rangeID,_n],"Stop","",{_this remoteExec ["RR_fnc_StopAction",2]},{_this call RR_fnc_stopCondition},{},[_rangeID,[_index]]] call ace_interact_menu_fnc_createAction;

//	_actionReset = [format ["%1%2Reset",_rangeID,_n],"Reset","",{_this remoteExec ["RR_fnc_ResetAction",2]},{_this call RR_fnc_resetCondition},{},[_rangeID,[_index]]] call ace_interact_menu_fnc_createAction;

//	_actionClearHighScore = [format ["%1%2Clear",_rangeID,_n],"Clear Highscore","",{_this remoteExec ["RR_fnc_clearHighScoreAction",2]},{_this call RR_fnc_clearCondition},{},[_rangeID,[_index]]] call ace_interact_menu_fnc_createAction;

//	[_obj,0,["ACE_MainActions"],_actionLane] call ace_interact_menu_fnc_addActionToObject;

//	[_obj,0,["ACE_MainActions",format ["%1%2",_rangeID,_n]],_actionStart] call ace_interact_menu_fnc_addActionToObject;

//	[_obj,0,["ACE_MainActions",format ["%1%2",_rangeID,_n]],_actionStop] call ace_interact_menu_fnc_addActionToObject;

//	[_obj,0,["ACE_MainActions",format ["%1%2",_rangeID,_n]],_actionReset] call ace_interact_menu_fnc_addActionToObject;

//	[_obj,0,["ACE_MainActions",format ["%1%2",_rangeID,_n]],_actionClearHighScore] call ace_interact_menu_fnc_addActionToObject;
};

// All Lanes

_actionName = if (isNil "_actionLane") then {"Drill Control"} else {"All Lanes"};

_actionLane = [format ["%1All",_rangeID],_actionName,"",{},{_this call RR_fnc_powerCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

_actionStart = [format ["%1AllStart",_rangeID],"Start","",{_this remoteExec ["RR_fnc_StartAction",2]},{_this call RR_fnc_startCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

_actionStop = [format ["%1AllStop",_rangeID],"Stop","",{_this remoteExec ["RR_fnc_StopAction",2]},{_this call RR_fnc_stopCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

_actionReset = [format ["%1AllReset",_rangeID],"Reset","",{_this remoteExec ["RR_fnc_ResetAction",2]},{_this call RR_fnc_resetCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

_actionClearHighScore = [format ["%1AllClear",_rangeID],"Clear Highscores","",{_this remoteExec ["RR_fnc_clearHighScoreAction",2]},{true},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

[_obj,0,["ACE_MainActions"],_actionLane] call ace_interact_menu_fnc_addActionToObject;

[_obj,0,["ACE_MainActions",format ["%1All",_rangeID]],_actionStart] call ace_interact_menu_fnc_addActionToObject;

[_obj,0,["ACE_MainActions",format ["%1All",_rangeID]],_actionStop] call ace_interact_menu_fnc_addActionToObject;

[_obj,0,["ACE_MainActions",format ["%1All",_rangeID]],_actionReset] call ace_interact_menu_fnc_addActionToObject;

[_obj,0,["ACE_MainActions",format ["%1All",_rangeID]],_actionClearHighScore] call ace_interact_menu_fnc_addActionToObject;

// Power On

_actionPowerOn = [format ["%1PowerOn",_rangeID],"Boot Up","",{_this remoteExec ["RR_fnc_powerOnAction",2]},{!(_this call RR_fnc_powerCondition)},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

[_obj,0,["ACE_MainActions"],_actionPowerOn] call ace_interact_menu_fnc_addActionToObject;

// Power Off

_actionPowerOff = [format ["%1PowerOff",_rangeID],"Shutdown","",{_this remoteExec ["RR_fnc_powerOffAction",2]},{_this call RR_fnc_powerCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

[_obj,0,["ACE_MainActions"],_actionPowerOff] call ace_interact_menu_fnc_addActionToObject;

// Test Loudspeaker

_actionTestSpeaker = [format ["%1TestSpeaker",_rangeID],"Test Loudspeaker","",{},{_this call RR_fnc_testSpeakerCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

_actionTestLong = [format ["%1TestLong",_rangeID],"Long Sound","",{_this remoteExec ["RR_fnc_testSpeakerAction",2]},{true},{},[_rangeID,"rifleRange\sounds\BUZZER_ARENA_LONG.wav"]] call ace_interact_menu_fnc_createAction;

_actionTestShort = [format ["%1TestShort",_rangeID],"Short Sound","",{_this remoteExec ["RR_fnc_testSpeakerAction",2]},{true},{},[_rangeID,"rifleRange\sounds\BUZZER_ARENA_SHORT.wav"]] call ace_interact_menu_fnc_createAction;

[_obj,0,["ACE_MainActions"],_actionTestSpeaker] call ace_interact_menu_fnc_addActionToObject;

[_obj,0,["ACE_MainActions",format ["%1TestSpeaker",_rangeID]],_actionTestLong] call ace_interact_menu_fnc_addActionToObject;

[_obj,0,["ACE_MainActions",format ["%1TestSpeaker",_rangeID]],_actionTestShort] call ace_interact_menu_fnc_addActionToObject;
