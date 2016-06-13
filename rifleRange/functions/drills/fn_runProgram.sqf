params [["_rangeID","",[""]],["_laneIndex",0,[0]],["_time",0,[0]],["_program",[],[[]]],["_primary",false,[true]]];

private ["_distIndex","_targIndex","_hits","_interval","_buzzer","_targ"];

_primary = if (isNil format ["%1_loudspeaker", _rangeID]) then {false} else {true};

if (_primary) then {
	["rifleRange\sounds\BUZZER_ARENA_SHORT.wav",missionNamespace getVariable format ["%1_loudspeaker",_rangeID],false,missionNamespace getVariable format ["%1_loudspeaker",_rangeID] modelToWorld [0,0.00390625,3.96981]] call RR_fnc_PlayMissionSound3D;
};

{
	_distIndex = _x select 0;
	_targIndex = _x select 1;
	_hits = _x select 2;
	_upTime = _x select 3;
	_interval = _x select 4;
	_buzzer = _x select 5;

	_time = _time + _upTime;

	_targ = missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _laneIndex select _distIndex select _targIndex;

	_targ setVariable ["hitNumber",0]; // reset hit counter on target

	_targ animate ["Terc",0]; // raise target

	_targ setVariable ["isActive",true]; // now registers hits
	_targ setVariable ["isScoring",true]; // hits add to score

	waitUntil {(_targ getVariable "hitNumber" >= 5 || serverTime >= _time)};

	_targ setVariable ["isActive",false]; // stop registering hits
	_targ setVariable ["isScoring",false]; // hits do not add to score

	_targ animate ["Terc",1]; // lower target

	waitUntil {serverTime >= _time};

	if (missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 1 || !(missionNamespace getVariable format ["%1_POWER_ON",_rangeID])) exitWith {
		_targ setVariable ["hitNumber",0]; // reset hit counter on target
	};

	if (_primary && _buzzer) then {
		["rifleRange\sounds\BUZZER_ARENA_SHORT.wav",missionNamespace getVariable format ["%1_loudspeaker",_rangeID],false,missionNamespace getVariable format ["%1_loudspeaker",_rangeID] modelToWorld [0,0.00390625,3.96981]] call RR_fnc_playMissionSound3D;
	};

	_time = _time + _interval;

	waitUntil {serverTime >= _time};

	if (missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 1 || !(missionNamespace getVariable format ["%1_POWER_ON",_rangeID])) exitWith {
		_targ setVariable ["hitNumber",0]; // reset hit counter on target
	};
} forEach _program;

missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _laneIndex set [0,false]; // started = false
missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _laneIndex set [1,true]; // stopped = true
missionNamespace getVariable format ["%1_STATES_ARRAY",_rangeID] select _laneIndex set [2,false]; // reset = false

if (_primary) then {
	["rifleRange\sounds\BUZZER_ARENA_LONG.wav",missionNamespace getVariable format ["%1_loudspeaker",_rangeID],false,missionNamespace getVariable format ["%1_loudspeaker",_rangeID] modelToWorld [0,0.00390625,3.96981]] call RR_fnc_playMissionSound3D;
};

// update high score
sleep 0.5;

[_rangeID,_laneIndex,false,true] call RR_fnc_refreshScores;