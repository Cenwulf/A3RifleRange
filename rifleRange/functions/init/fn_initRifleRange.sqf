scriptName "fn_initRifleRange";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Initialises a firing range.

	Parameter(s):
	_this select 0: String - Unique Range ID used to identify the range and all its components, passed to all subsequent functions.
	_this select 1: String - Range type, needs to match one of the standard range types listed below. More can be added later
	_this select 2: Number - Number of lanes on range.

	Returns:
	String - RangeID in case of modification.

	Notes:
	Range types:	"ETR" - Electronic Target Range - Narrow, multi-lane range with 3 targets per lane spaced 100m appart.
					"IBSR" - Individual Battle Skills Range - Large range suitable for single firer or firer + spotter.
					"QBSR" - Questionably Bull-Shit Range - An odd combination of the above that most people (myself included) first think of when they hear the words rifle range.
					"SAPR" - Sidearm Proficiency Range	- Not a real acronym, intended for use with pistol range designed by Schilly of TF2031
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
params [["_rangeID","ETR",[""]],["_rangeType","ETR",[""]],["_laneCount",5,[0]]];

sleep random 0.1;

if (isNil "RR_RANGE_IDS") then {
	RR_RANGE_IDS = [];
};

if (_rangeID in RR_RANGE_IDS) then {
	for "_i" from 0 to 99 do {
		_rangeID = format ["%1_%2", _rangeID, _i];
		if !(_rangeID in RR_RANGE_IDS) exitWith {};
	};
};

RR_RANGE_IDS pushBack _rangeID;
publicVariable "RR_RANGE_IDS";

// Define available drills based on rangeType (Fomat: [["DISPLAY NAME","DRILL ID"]])
// NOTE: Define name only, string will be used to select specific drill predefined in fn_startFiringDrill.sqf

_drills = switch (_rangeType) do { // Defines the default drills to be used for the range based on type. Drills are definied in fn_startFiringDrill.sqf. See range type definitions in header. To add your own type of range define a rangeType here and then at least one program in fn_startFiringDrill.sqf switch do.
	// Array format: [<NAME>,<DRILL_ID>]; <NAME>: String - Will appear to the player when selecting drill through ACE actions; <DRILL_ID>: String - Passed to the fn_startFiringDrill function and used to select the correct program.
	case "ETR": {[["ACMT (Rapid)","ETR_rapidfire"],["ACMT (Snap)","ETR_snapcombo"]]};
	case "IBSR": {[["IBSR (Default)","IBSR_default"]]};
	case "QBSR": {[["QBSR (Default)","QBSR_default"]]};
	case "SAPR": {[["SAPT (Default)","ETRP_default"]]};
};

missionNamespace setVariable [format ["%1_DRILLS",_rangeID],_drills,true];

// Define range properties

missionNamespace setVariable [format ["%1_RANGE_TYPE",_rangeID],_rangeType];
missionNamespace setVariable [format ["%1_CURRENT_DRILL",_rangeID],missionNamespace getVariable format ["%1_DRILLS",_rangeID] select 0 select 1,true];

missionNamespace setVariable [format ["%1_LANE_COUNT",_rangeID],_laneCount,true];

missionNamespace setVariable [format ["%1_SCORES_ARRAY",_rangeID],[]];
missionNamespace setVariable [format ["%1_STATES_ARRAY",_rangeID],[]];
missionNamespace setVariable [format ["%1_DIGITS_ARRAY",_rangeID], []];
missionNamespace setVariable [format ["%1_UNUSED_DIGITS_ARRAY",_rangeID], []];
missionNamespace setVariable [format ["%1_TARGETS_BY_LANE",_rangeID],[]];
missionNamespace setVariable [format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID],[]];
missionNamespace setVariable [format ["%1_ALL_TARGETS",_rangeID],[]];

missionNamespace setVariable [format ["%1_RANGE_FLAGS",_rangeID],[]];

private _flags = missionNamespace getVariable format ["%1_RANGE_FLAGS",_rangeID];

for "_i" from 0 to 999 do { // Check flag variable names and add them to array if they exist
	private _flagVarName = format ["%1_rangeFlag_%2",_rangeID,_i];
	if !(isNil _flagVarName) then {
		_flags pushBack (missionNamespace getVariable _flagVarName);
	};
};

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
				_targ setVariable ["scoreGroupIndex",-1];
				_targ setObjectTextureGlobal [0,"rifleRange\textures\figure11.paa"];
			};
		};
	};
};


// If whiteboard object exists set texture for current firing drill

if (!isNull (missionNamespace getVariable [format ["%1_WHITEBOARD_OBJECT", _rangeID], objNull])) then {
	[_rangeID, missionNamespace getVariable format ["%1_CURRENT_DRILL",_rangeID]] call RR_fnc_setWhiteboardTexture;
};

// publivVariable variables required by client
publicVariable format ["%1_STATES_ARRAY",_rangeID];

// finalise init
missionNamespace setVariable [format ["%1_POWER_ON",_rangeID],false,true];

missionNamespace setVariable [format ["%1_INIT_DONE", _rangeID],true,true];
