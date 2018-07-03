scriptName "fn_initRifleRange";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Initialises a firing range.

	Parameter(s):
	_this select 0: String	- Unique Range ID used to identify the range and all its components, passed to all subsequent functions.
	_this select 1: Array	- (Optional) Drill types, array of strings defining the type of drills that can be run on this range, can be anything but must have at least 1 firing drill defined in fn_compileFiringDrill.sqf that has a matching drill type. Default = ["ETR"].
	_this select 2: Number	- (Optional) Number of lanes on range. Default = 5.
	_this select 3: Number	- (Optional) Number digits on scoreboard (e.g. 1 results in a max displayable score of 9, 2 is 99 and 3 is 999). Default = 2.
	_this select 4: String	- (Optional) Range display name used for map marker and diary records.
	_this select 5: String	- (Optional) Description of the range intended to be used in the diary record.
	_this select 6: String	- (Optional) Path to image file to be used for range specific diary subject.
	_this select 7: Bool	- (Optional) Defines whether a map marker should be placed for the range marker is placed over the range control object.
	_this select 8: Array	- Marker position 2d or 3d.
	_this select 9: String	- (Optional) Marker type see CfgMarkers (https://community.bistudio.com/wiki/cfgMarkers).
	_this select 10: String	- (Optional) Marker colour see CfgMarkerColors (https://community.bistudio.com/wiki/CfgMarkerColors_Arma_3). Does not need to be defined will take colour side from marker type by default.

	Returns:
	Nothing
*/
#define SELF RR_fnc_initRifleRange

// TODO: Macros
/*
#include rifleRange\macro.hpp
	#define RRGVAR(ID,VARNAME) missionNamespace getVariable format ["%1_%2",ID,VARNAME]
	#define RRSVAR(ID,VARNAME,VALUE) missionNamespace setVariable [format ["%1_%2",ID,VARNAME],VALUE]
	#define RRSPUBVAR(ID,VARNAME,VALUE) missionNamespace setVariable [format ["%1_%2",ID,VARNAME],VALUE,true]
*/

if !isServer exitWith {};

waitUntil {missionNamespace getVariable ["RR_INIT_COMMON_DONE", false]};

params [["_rangeID","ETR",[""]],["_drillTypes",["ETR"],[[]]],["_laneCount",5,[0]],["_digitCount",2,[0]],["_displayName","Firing Drills",[""]],["_rangeDescription","No data available.",[""]],["_imageRange","",[""]],["_marker",false,[true]],["_markerPos",[0,0,0],[[]],[2,3]],["_markerType","b_installation",[""]],["_markerColour","",[""]]];

// Check for Range ID conflicts and exit if range id already exists
sleep random 0.1;
if (_rangeID in RR_RANGE_IDS) exitWith {[format ["Error: RR_fnc_initRifleRange - RangeID %1 already exists",_rangeID]] remoteExec ["systemChat"]};

// add _rangeID to global range ID array
RR_RANGE_IDS pushBack _rangeID;

// Fetch available drills based on rangeType (Fomat: [["DISPLAY NAME",_program array]])
_drills = [];

{ // compare _drillType of each drill to the _drillTypes array if they match add the drill to the list of avaivle drills for this firing range
	_x params ["_displayName","_program","_drillType","_instructions","_image"];
	if (_drillType in _drillTypes) then {
		_drills pushBack _x;
	};
} forEach RR_DRILLS;

// global varialbe drills array and set current drill
missionNamespace setVariable [format ["%1_DRILLS",_rangeID],_drills,true];
missionNamespace setVariable [format ["%1_CURRENT_DRILL",_rangeID],missionNamespace getVariable format ["%1_DRILLS",_rangeID] select 0,true];

// add drill instructions diary entries
_this spawn RR_fnc_addDrillInstructions;

// Define range properties by prepending _rangeID and publishing as global variable
missionNamespace setVariable [format ["%1_LANE_COUNT",_rangeID],_laneCount,true];
missionNamespace setVariable [format ["%1_DIGIT_COUNT", _rangeID], _digitCount, true];
missionNamespace setVariable [format ["%1_SCORES_ARRAY",_rangeID],[]];
missionNamespace setVariable [format ["%1_STATES_ARRAY",_rangeID],[]];
missionNamespace setVariable [format ["%1_DIGITS_ARRAY",_rangeID], []];
missionNamespace setVariable [format ["%1_UNUSED_DIGITS_ARRAY",_rangeID], []];
missionNamespace setVariable [format ["%1_TARGETS_BY_LANE",_rangeID],[]];
missionNamespace setVariable [format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID],[]];
missionNamespace setVariable [format ["%1_ALL_TARGETS",_rangeID],[]];

missionNamespace setVariable [format ["%1_RANGE_FLAGS",_rangeID],[]];

// Check for range flag objects and add them to array
private _flags = missionNamespace getVariable format ["%1_RANGE_FLAGS",_rangeID];

for "_i" from 0 to 999 do { // Check flag variable names and add them to array if they exist
	private _flagVarName = format ["%1_rangeFlag_%2",_rangeID,_i];
	if !(isNil _flagVarName) then {
		_flags pushBack (missionNamespace getVariable _flagVarName);
	};
};

// create score arrays for each lane and search for range targets based on vehicle variable name
for "_l" from 1 to _laneCount do {
	_laneIndex = _l - 1;

	missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] pushBack [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]];
	missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] pushBack [false,false,false,false];
	missionNamespace getVariable format ["%1_DIGITS_ARRAY",_rangeID] pushBack [];
	missionNamespace getVariable format ["%1_TARGETS_BY_LANE",_rangeID] pushBack [];
	missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] pushBack [[],[],[],[]];

	if !(isNil format ["%1_l%2_sign",_rangeID,_l]) then {
		missionNamespace getVariable format ["%1_l%2_sign",_rangeID,_l] setObjectTextureGlobal [0,format ["rifleRange\textures\laneSign%1.paa",_l]];
	};

	// find targets, object assign variables describing position/function and set fig. 11 texture
	for "_g" from 1 to 4 do {
		_distIndex = _g - 1;
		for "_n" from 0 to 99 do {
			if !(isNil format ["%1_l%2_g%3_%4", _rangeID, _l, _g, _n]) then {
				_targ = missionNamespace getVariable format ["%1_l%2_g%3_%4", _rangeID, _l, _g, _n];
				missionNamespace getVariable format ["%1_ALL_TARGETS",_rangeID] pushBack _targ;
				missionNamespace getVariable format ["%1_TARGETS_BY_LANE",_rangeID] select _laneIndex pushBack _targ;
				missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _laneIndex select _distIndex pushBack _targ;
				_targ addEventHandler ["hit", {_this call RR_fnc_targetHit;}];
				_targ setVariable ["hitNumber",0];
				_targ setVariable ["rangeID",_rangeID];
				_targ setVariable ["laneIndex",_laneIndex];
				_targ setVariable ["distIndex",_distIndex];
				_targ setVariable ["scoreGroup",-1];
				_targ setVariable ["isActive",false];
				_targ setVariable ["isScoring",false];
				_targ setObjectTextureGlobal [0,"rifleRange\textures\figure11.paa"];
			};
		};
	};
};

// publivVariable variables required by client
publicVariable format ["%1_STATES_ARRAY",_rangeID];

// finalise init
missionNamespace setVariable [format ["%1_POWER_ON",_rangeID],false,true];

missionNamespace setVariable [format ["%1_INIT_DONE", _rangeID],true,true];
