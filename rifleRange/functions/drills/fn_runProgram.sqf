scriptName "fn_runProgram";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Describe your function

	Parameter(s):
	_this select 0: String - Unique Range ID, first defined when creating  rifle range RR_fnc_iniRifleRange and passed to all subsequent functions.
	_this select 1: Number - Index of lane being modified.
	_this select 2: Number - Server time used to sync all lanes.
	_this select 3: Array - Array of arrays, each element is defines a number of values for a specific target in a sequence.
	_this select 4: Bool - RR_fnc_runProgram is called individually for each lane in a range, this argument defines a single lane to be designated primaray lane and is used to controll timing of the buzzer sound.

	Returns:
	Nothing
*/
#define SELF RR_fnc_runProgram

params [["_rangeID","",[""]],["_laneIndex",0,[0]],["_time",0,[0]],["_program",[],[[]]],["_primary",false,[true]]];

_primary = if (isNil format ["%1_loudspeaker", _rangeID]) then {false} else {_primary};

if (_primary) then {
	["rifleRange\sounds\BUZZER_ARENA_SHORT.wav",missionNamespace getVariable format ["%1_loudspeaker",_rangeID],false,missionNamespace getVariable format ["%1_loudspeaker",_rangeID] modelToWorld [0,0.00390625,3.96981],3] call RR_fnc_PlayMissionSound3D;
};

{
	_x params [["_distIndex",0,[0]],["_targIndex",0,[0]],["_hits",0,[0]],["_upTime",0,[0]],["_interval",0,[0]],["_buzzer",false,[true]]];

	private ["_targ"];

	_time = _time + _upTime;

	_targ = if (_targIndex == -1) then {missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _laneIndex select _distIndex select floor random count (missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _laneIndex select _distIndex)} else {missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _laneIndex select _distIndex select _targIndex};

	_targ setVariable ["hitNumber",0]; // reset hit counter on target

	_targ animate ["Terc",0]; // raise target

	_targ setVariable ["isActive",true]; // now registers hits
	_targ setVariable ["isScoring",true]; // hits add to score

	waitUntil {_targ getVariable "hitNumber" >= _hits || time >= _time || !(missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 0)};

	if !(missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 0) exitWith {
		_targ setVariable ["hitNumber",0]; // reset hit counter on target
	};

	_targ setVariable ["isActive",false]; // stop registering hits
	_targ setVariable ["isScoring",false]; // hits do not add to score

	_targ animate ["Terc",1]; // lower target

	waitUntil {time >= _time || !(missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 0)};

	if !(missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 0) exitWith {
		_targ setVariable ["hitNumber",0]; // reset hit counter on target
	};

	if (_primary && _buzzer) then {
		["rifleRange\sounds\BUZZER_ARENA_SHORT.wav",missionNamespace getVariable format ["%1_loudspeaker",_rangeID],false,missionNamespace getVariable format ["%1_loudspeaker",_rangeID] modelToWorld [0,0.00390625,3.96981],3] call RR_fnc_playMissionSound3D;
	};

	_time = _time + _interval;

	waitUntil {time >= _time || !(missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 0)};

	if !(missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 0) exitWith {
		_targ setVariable ["hitNumber",0]; // reset hit counter on target
	};
} forEach _program;

missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _laneIndex set [0,false]; // started = false
missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _laneIndex set [1,true]; // stopped = true
missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _laneIndex set [2,false]; // reset = false

if (_primary) then {
	["rifleRange\sounds\BUZZER_ARENA_LONG.wav",missionNamespace getVariable format ["%1_loudspeaker",_rangeID],false,missionNamespace getVariable format ["%1_loudspeaker",_rangeID] modelToWorld [0,0.00390625,3.96981],3] call RR_fnc_playMissionSound3D;
};

// update high score
sleep 0.5;

[_rangeID,_laneIndex,false,true] call RR_fnc_refreshScores;