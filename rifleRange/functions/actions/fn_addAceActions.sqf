scriptName "fn_addAceActions";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Adds ace actions to an object to control rifle range with matching Range ID.

	Parameter(s):
	_this select 0: Object - Object actions are to be added to.
	_this select 1: String - Unique Range ID, first defined when creating a rifle range with RR_fnc_iniRifleRange and passed to all subsequent functions.

	Returns:
	Nothing
*/
#define SELF RR_fnc_addAceActions

params [["_obj",objNull,[objNull]],["_rangeID","",[""]]];

private ["_laneIndecies","_actionLane","_actionStart","_actionStop","_actionReset","_actionClearHighScore","_actionPowerOn","_actionPowerOff","_actionName"];

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

	if (missionNamespace getVariable [format ["%1_RANGE_TYPE",_rangeID],"ETR"] == "QBSR") then {

		_actionLane = [format ["%1%2",_rangeID,_n],format ["Lane %1",_n],"",{},{_this call RR_fnc_powerCondition},{},[_rangeID]] call ace_interact_menu_fnc_createAction;

		_actionStart = [format ["%1%2Start",_rangeID,_n],"Start","rifleRange\textures\icons\start.paa",{_this remoteExec ["RR_fnc_StartAction",2];},{_this call RR_fnc_startCondition},{},[_rangeID,[_index]]] call ace_interact_menu_fnc_createAction;

		_actionStop = [format ["%1%2Stop",_rangeID,_n],"Stop","rifleRange\textures\icons\stop.paa",{_this remoteExec ["RR_fnc_StopAction",2]},{_this call RR_fnc_stopCondition},{},[_rangeID,[_index]]] call ace_interact_menu_fnc_createAction;

		_actionReset = [format ["%1%2Reset",_rangeID,_n],"Reset","rifleRange\textures\icons\reset.paa",{_this remoteExec ["RR_fnc_ResetAction",2]},{_this call RR_fnc_resetCondition},{},[_rangeID,[_index]]] call ace_interact_menu_fnc_createAction;

		_actionClearHighScore = [format ["%1%2Clear",_rangeID,_n],"Clear Highscore","rifleRange\textures\icons\clear.paa",{_this remoteExec ["RR_fnc_clearHighScoreAction",2]},{_this call RR_fnc_clearCondition},{},[_rangeID,[_index]]] call ace_interact_menu_fnc_createAction;

		[_obj,0,["ACE_MainActions"],_actionLane] call ace_interact_menu_fnc_addActionToObject;

		[_obj,0,["ACE_MainActions",format ["%1%2",_rangeID,_n]],_actionStart] call ace_interact_menu_fnc_addActionToObject;

		[_obj,0,["ACE_MainActions",format ["%1%2",_rangeID,_n]],_actionStop] call ace_interact_menu_fnc_addActionToObject;

		[_obj,0,["ACE_MainActions",format ["%1%2",_rangeID,_n]],_actionReset] call ace_interact_menu_fnc_addActionToObject;

		[_obj,0,["ACE_MainActions",format ["%1%2",_rangeID,_n]],_actionClearHighScore] call ace_interact_menu_fnc_addActionToObject;
	};
};

// All Lanes

_actionName = if (missionNamespace getVariable [format ["%1_RANGE_TYPE",_rangeID],"ETR"] != "QBSR") then {"Drill Control"} else {"All Lanes"};

_actionLane = [format ["%1All",_rangeID],_actionName,"\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa",{},{_this call RR_fnc_powerCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

_actionStart = [format ["%1AllStart",_rangeID],"Start","rifleRange\textures\icons\start.paa",{_this remoteExec ["RR_fnc_StartAction",2]},{_this call RR_fnc_startCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

_actionStop = [format ["%1AllStop",_rangeID],"Stop","rifleRange\textures\icons\stop.paa",{_this remoteExec ["RR_fnc_StopAction",2]},{_this call RR_fnc_stopCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

_actionReset = [format ["%1AllReset",_rangeID],"Reset","rifleRange\textures\icons\reset.paa",{_this remoteExec ["RR_fnc_ResetAction",2]},{_this call RR_fnc_resetCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

_actionClearHighScore = [format ["%1AllClear",_rangeID],"Clear Highscores","rifleRange\textures\icons\clear.paa",{_this remoteExec ["RR_fnc_clearHighScoreAction",2]},{_this call RR_fnc_clearCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

[_obj,0,["ACE_MainActions"],_actionLane] call ace_interact_menu_fnc_addActionToObject;

[_obj,0,["ACE_MainActions",format ["%1All",_rangeID]],_actionStart] call ace_interact_menu_fnc_addActionToObject;

[_obj,0,["ACE_MainActions",format ["%1All",_rangeID]],_actionStop] call ace_interact_menu_fnc_addActionToObject;

[_obj,0,["ACE_MainActions",format ["%1All",_rangeID]],_actionReset] call ace_interact_menu_fnc_addActionToObject;

[_obj,0,["ACE_MainActions",format ["%1All",_rangeID]],_actionClearHighScore] call ace_interact_menu_fnc_addActionToObject;

// Select Firing Drill

_actionSelectDrill = [format ["%1SelectDrill",_rangeID],"Select Firing Drill","\a3\Ui_f\data\IGUI\Cfg\WeaponIcons\srifle_ca.paa",{},{count (missionNamespace getVariable format ["%1_DRILLS",_this select 2 select 0]) > 1 && _this call RR_fnc_powerCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

[_obj,0,["ACE_MainActions"],_actionSelectDrill] call ace_interact_menu_fnc_addActionToObject;

{
	_x params [["_actionName","",[""]],["_drillID","",[""]]];

	_actionDrill = [format ["%1_%2",_rangeID,_drillID],_actionName,"rifleRange\textures\icons\checkempty.paa",{missionNamespace setVariable [format ["%1_CURRENT_DRILL",_this select 2 select 0],_this select 2 select 2,true]},{missionNamespace getVariable format ["%1_CURRENT_DRILL",_this select 2 select 0] != _this select 2 select 2},{},[_rangeID,_laneIndecies,_drillID]] call ace_interact_menu_fnc_createAction;

	_actionDrillCurrent = [format ["%1_%2_c",_rangeID,_drillID],/*format ["<t color='#008000'>%1</t>",_actionName]*/_actionName,"rifleRange\textures\icons\check.paa",{missionNamespace setVariable [format ["%1_CURRENT_DRILL",_this select 2 select 0,true],_this select 2 select 2]},{missionNamespace getVariable format ["%1_CURRENT_DRILL",_this select 2 select 0] == _this select 2 select 2},{},[_rangeID,_laneIndecies,_drillID]] call ace_interact_menu_fnc_createAction;

	[_obj,0,["ACE_MainActions",format ["%1SelectDrill",_rangeID]],_actionDrill] call ace_interact_menu_fnc_addActionToObject;

	[_obj,0,["ACE_MainActions",format ["%1SelectDrill",_rangeID]],_actionDrillCurrent] call ace_interact_menu_fnc_addActionToObject;
} forEach (missionNamespace getVariable format ["%1_DRILLS",_rangeID]);

// Test Loudspeaker

_actionTestSpeaker = [format ["%1TestSpeaker",_rangeID],"Test Loudspeaker","rifleRange\textures\icons\speaker.paa",{},{_this call RR_fnc_testSpeakerCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

_actionTestLong = [format ["%1TestLong",_rangeID],"Long Sound","",{_this remoteExec ["RR_fnc_testSpeakerAction",2]},{true},{},[_rangeID,"rifleRange\sounds\BUZZER_ARENA_LONG.wav"]] call ace_interact_menu_fnc_createAction;

_actionTestShort = [format ["%1TestShort",_rangeID],"Short Sound","",{_this remoteExec ["RR_fnc_testSpeakerAction",2]},{true},{},[_rangeID,"rifleRange\sounds\BUZZER_ARENA_SHORT.wav"]] call ace_interact_menu_fnc_createAction;

[_obj,0,["ACE_MainActions"],_actionTestSpeaker] call ace_interact_menu_fnc_addActionToObject;

[_obj,0,["ACE_MainActions",format ["%1TestSpeaker",_rangeID]],_actionTestLong] call ace_interact_menu_fnc_addActionToObject;

[_obj,0,["ACE_MainActions",format ["%1TestSpeaker",_rangeID]],_actionTestShort] call ace_interact_menu_fnc_addActionToObject;

// Power On

_actionPowerOn = [format ["%1PowerOn",_rangeID],"Power On","rifleRange\textures\icons\power.paa",{_this remoteExec ["RR_fnc_powerOnAction",2]},{!(_this call RR_fnc_powerCondition)},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

[_obj,0,["ACE_MainActions"],_actionPowerOn] call ace_interact_menu_fnc_addActionToObject;

// Power Off

_actionPowerOff = [format ["%1PowerOff",_rangeID],"Shutdown","rifleRange\textures\icons\power.paa",{_this remoteExec ["RR_fnc_powerOffAction",2]},{_this call RR_fnc_powerCondition},{},[_rangeID,_laneIndecies]] call ace_interact_menu_fnc_createAction;

[_obj,0,["ACE_MainActions"],_actionPowerOff] call ace_interact_menu_fnc_addActionToObject;