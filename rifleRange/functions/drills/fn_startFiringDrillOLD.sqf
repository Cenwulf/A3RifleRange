private ["_rangeID","_laneIndex","_targets","_close","_medium","_long","_program","_varName","_array","_targetDist"];

_rangeID = param [0,"",[""]];

_laneIndex = param [1,0,[0]];

_drill

_targets = missionNamespace getVariable format ["%1_TARGETS_BY_LANE", _laneIndex] select _laneIndex;

if (count _targets == 0) exitWith {};

_close = [];
_medium = [];
_long = [];

// sort targets by range
{
	_varName = vehicleVarName _x;
	_array = _varName splitString "_";
	_targetDist = (_array select 2) splitString "" select 0;

	switch (_targetDist) do {
		case "c": {
			_close pushBack _x;
		};
		case "m": {
			_medium pushBack _x;
		};
		case "l": {
			_long pushBack _x;
		};
		default {};
	};
} forEach _targets;

_program = [];

for "_i" from 0 to 9 do {
	_program pushback (_close call BIS_fnc_selectRandom);
	_program pushback (_medium call BIS_fnc_selectRandom);
	_program pushback (_long call BIS_fnc_selectRandom);
};

_program = _program call BIS_fnc_arrayShuffle;

// buzer sound
// TODO

// run program
{
	_x animate ["Terc",0];
	_x setVariable ["isActive",true];
	sleep 2;
	_x setVariable ["isActive",false];
	_x animate ["Terc",1];
	sleep (5 + (random 5));
} forEach _program;

// buzzer sound
// TODO

// update high score
sleep 0.5;

[_laneIndex,false,true] call RR_fnc_refreshScores;