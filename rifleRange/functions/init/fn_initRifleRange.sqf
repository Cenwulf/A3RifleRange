scriptName "fn_initRifleRange:";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Initialises a firing range.

	Parameter(s):
	_this select 0: String - Unique Range ID used to identify the range and all its components, passed to all subsequent functions.
	_this select 1: String - Range type, need to match one of the standard range types listed below.

	Returns:
	Nothing

	Notes:
	Range types:	"ETR" - Electronic Training Range - Narrow, multi-lane range with few targets per range.
					"IBSR" - Idividual Battle Skills Range - Large range suitable for single firer or firer + spotter.
					"HBSR" - Hollywood Bull-Shit Range - An odd combination of the above that most people (myself included) first think of when they hear the phrase rifle range.
*/
#define SELF _fnc_fn_initRifleRange

/*
todo: macro.hpp (maybe)
#define getVarName(ID,VARNAME) missionNamespace getVariable format ["%1_VARNAME", ID]
#define setVarName(ID,VARNAME,VALUE) missionNamespace setVariable [format ["%1_VARNAME", ID],VALUE]
#define setVarNamePub(ID,VARNAME,VALUE) missionNamespace setVariable [format ["%1_VARNAME", ID],VALUE,true]
*/

if !(isServer) exitWith {};

params [["_rangeID","",[""]],["_rangeType","ETR",[""]]];

if (isNil "RR_RANGE_IDS") then {
	RR_RANGE_IDS = [];
};

RR_RANGE_IDS pushBack _rangeID;
publicVariable "RR_RANGE_IDS";

missionNamespace setVariable [format ["%1_CURRENT_DRILL",_rangeID],format ["%1_default",_rangeType]];

missionNamespace setVariable [format ["%1_LANE_COUNT",_rangeID],5,true]; // lane count subject to change

missionNamespace setVariable [format ["%1_SCORES_ARRAY",_rangeID],[]];
missionNamespace setVariable [format ["%1_STATES_ARRAY",_rangeID],[]];
missionNamespace setVariable [format ["%1_TARGETS_BY_LANE",_rangeID],[]];
missionNamespace setVariable [format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID],[]];
missionNamespace setVariable [format ["%1_ALL_TARGETS",_rangeID],[]];

for "_i" from 1 to (missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID]) do {
	missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] pushBack [0,0,0,0];
	missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] pushBack [false,false,false,false];
	missionNamespace getVariable format ["%1_DIGITS_ARRAY",_rangeID] pushBack [];
	missionNamespace getVariable format ["%1_TARGETS_BY_LANE",_rangeID] pushBack [];
	missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] pushBack [[],[],[]];
	if !(isNil format ["%1_l%2_sign",_rangeID,_i]) then {
		missionNamespace getVariable format ["%1_l%2_sign",_rangeID,_i] setObjectTextureGlobal [0,format ["rifleRange\textures\laneSign%1.paa",_i]];
	};
};

{
	_varName = vehicleVarName _x;
	if (_varName != "") then {
		_array = _varName splitString "_";

		if (count _array != 4) then {
			diag_log format ["ERROR: ""%1"" - Target ""%2"" incorrect vehicleVarName format.",SELF,_x];
		};

		_rangeIDTarg = _array select 0;
		_laneIDTarg = _array select 1;

		_laneIDArray = _laneIDTarg splitString "";

		if (_rangeID == _rangeIDTarg && {count _laneIDArray == 2 && {_laneIDArray select 0 == "l"}}) then {
			_x addEventHandler ["hit", {_this call RR_fnc_targetHit;}];
			_x setVariable ["hitNumber",0];
			_x setObjectTextureGlobal [0,"rifleRange\textures\figure11.paa"];

			missionNamespace getVariable format ["%1_ALL_TARGETS",_rangeID] pushBack _x;

			_laneNumber = parseNumber (_laneIDArray select 1);
			_index = _laneNumber - 1;
			missionNamespace getVariable format ["%1_TARGETS_BY_LANE",_rangeID] select _index pushBack _x;
			_distTarg = switch (_array select 2) do {
				case "c": {0};
				case "m": {1};
				case "f": {2};
			};
			missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _index select _distTarg pushBack _x;
		};
	};
} forEach (allMissionObjects "TargetBase");

// TODO: sorting for multi target lanes
/*
{
	{
		_sortedTargets = [_x,[],{(reverse ((vehicleVarName _x) splitString "_")) select 0},"ASCEND"] call BIS_fnc_sortBy;
		_x set [_forEachIndex,_sortedTargets];
	} forEach _x;
} forEach (missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID]);
*/

publicVariable format ["%1_STATES_ARRAY",_rangeID];

missionNamespace setVariable [format ["%1_POWER_ON",_rangeID],false];

missionNamespace setVariable [format ["%1_INIT_DONE", _rangeID],true,true];