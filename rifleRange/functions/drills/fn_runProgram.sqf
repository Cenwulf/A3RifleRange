scriptName "fn_runProgram";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Executes a specific drill passed as an argument, is executed once for each lane (this is a throw back to when lanes could be operated individually)

	Parameter(s):
	_this select 0: String - Unique Range ID, first defined when creating rifle range RR_fnc_initRifleRange and passed to all subsequent functions.
	_this select 1: Number - Index of lane being modified.
	_this select 2: Number - Server time used to sync all lanes.
	_this select 3: Array - Array of arrays, each element defines a number of values for a specific target in a sequence.
	_this select 4: Bool - RR_fnc_runProgram is called individually for each lane in a range, this parameter defines a single lane to be designated primaray lane and is used to control anything that should only be executed once like the buzzer sound.

	Returns:
	Nothing
*/
#define SELF RR_fnc_runProgram

params [["_rangeID","",[""]],["_laneIndex",0,[0]],["_time",0,[0]],["_program",[],[[]]],["_primary",false,[true]]];

private ["_flags","_flagVarName"];

private _flags = missionNamespace getVariable format ["%1_RANGE_FLAGS",_rangeID];

private _startDelay = missionNamespace getVariable [format ["%1_START_DELAY",_rangeID],0];

_time = _time + _startDelay;

waitUntil {time >= _time || !(missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 0)}; // cannot use sleep command as we need to be able to break out of it if the drill is stopped

// This entire function (fn_runProgram) is run once FOR EACH lane of the firing range, one lane is designated as the primary lane, use "if (_primary) then {WHATEVER};" to execute code that should only be run once per drill, in this case the buzzer sound.
if (_primary) then {
		[_rangeID,"RR_StartBeep"] remoteExec ["RR_fnc_playHeadsetSound"];
};

_time = _time + 3; // always a 3 second sleep to synchronise buzzer sound with headset beep sound

waitUntil {time >= _time || !(missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 0)};

if (_primary) then {
	if !(isNil format ["%1_loudspeaker", _rangeID] || missionNamespace getVariable [format ["%1_SPEAKER_MUTED",_rangeID],false]) then {
		["rifleRange\sounds\BUZZER_ARENA_SHORT.ogg",missionNamespace getVariable format ["%1_loudspeaker",_rangeID],false,missionNamespace getVariable format ["%1_loudspeaker",_rangeID] modelToWorld [0,0.00390625,3.96981],3] call RR_fnc_PlayMissionSound3D;
	};

	{
		_x spawn {
			[_this,0,0.1] call BIS_fnc_animateFlag;
			sleep 1.5;
			_this setFlagTexture "\A3\Data_F\Flags\Flag_red_CO.paa";
			sleep 0.5;
			[_this,1,0.1] call BIS_fnc_animateFlag;
		};
	} forEach _flags;
};

{
	_x params [["_distIndex",0,[0]],["_targIndex",0,[0]],["_hits",0,[0]],["_upTime",0,[0]],["_interval",0,[0]],["_buzzer",false,[true]],["_scoreGroup",-1,[0]]];

	if (count (missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _laneIndex select _distIndex) == 0) exitWith {remoteExec ["systemChat", format ["Error: RR_fnc_runProgram & RR_fnc_startFiringDrill - RangeID %1 Lane %2 missing target from group %3",_rangeID,_laneIndex + 1,_distIndex + 1]]};

	_time = _time + _upTime;

	private _targ = if (_targIndex == -1) then {missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _laneIndex select _distIndex select floor random count (missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _laneIndex select _distIndex)} else {missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _laneIndex select _distIndex select _targIndex};

	_targ setVariable ["hitNumber",0]; // reset hit counter on target

	_targ setVariable ["scoreGroup",_scoreGroup]; // set score group

	_targ animate ["Terc",0]; // raise target

	_targ setVariable ["isActive",true]; // now registers hits
	_targ setVariable ["isScoring",true]; // hits add to score

	waitUntil {_targ getVariable "hitNumber" >= _hits || time >= _time || !(missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 0)};

	if !(missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 0) exitWith {
		// exits if the range state changes (isn't "RUNNING")
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
		if !(isNil format ["%1_loudspeaker", _rangeID] || missionNamespace getVariable [format ["%1_SPEAKER_MUTED",_rangeID],false]) then {
			["rifleRange\sounds\BUZZER_ARENA_SHORT.ogg",missionNamespace getVariable format ["%1_loudspeaker",_rangeID],false,missionNamespace getVariable format ["%1_loudspeaker",_rangeID] modelToWorld [0,0.00390625,3.96981],3] call RR_fnc_PlayMissionSound3D;
		};

		[_rangeID,"RR_MidBeep"] remoteExec ["RR_fnc_playHeadsetSound"];
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

publicVariable format ["%1_STATES_ARRAY",_rangeID];

if (_primary) then {
	[_rangeID,"RR_EndBeep"] remoteExec ["RR_fnc_playHeadsetSound"];

	if !(isNil format ["%1_loudspeaker", _rangeID] || missionNamespace getVariable [format ["%1_SPEAKER_MUTED",_rangeID],false]) then {
		["rifleRange\sounds\BUZZER_ARENA_LONG.ogg",missionNamespace getVariable format ["%1_loudspeaker",_rangeID],false,missionNamespace getVariable format ["%1_loudspeaker",_rangeID] modelToWorld [0,0.00390625,3.96981],3] call RR_fnc_PlayMissionSound3D;
	};

	{
		_x spawn {
			[_this,0,0.1] call BIS_fnc_animateFlag;
			sleep 1.5;
			_this setFlagTexture "\A3\Data_F\Flags\Flag_green_CO.paa";
			sleep 0.5;
			[_this,1,0.1] call BIS_fnc_animateFlag;
		};
	} forEach _flags;
};

sleep 0.5;

// update high score
for "_i" from 0 to 4 do {
	[_rangeID,_laneIndex,_i,_laneIndex,_i,false,true] spawn RR_fnc_refreshScores; // refresh scoreboard to show the current high scores
};

private _laneCount = missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID];

if (_primary) then {
	{
		if (_forEachIndex >= _laneCount) then {
			for "_i" from 0 to (_laneCount - 1) do {
				[_rangeID,_forEachIndex,_i,_i,4,false,true] call RR_fnc_refreshScores;
			};
		};
	} forEach (missionNamespace getVariable format ["%1_DIGITS_ARRAY", _rangeID]); // refresh high scores for all non lane specific scoreboards
	// TODO: this is all messy as balls, need to clean it up within the refresh scores function. With multiple scoreboards the current way scores are refreshed needs to be revised.
};
