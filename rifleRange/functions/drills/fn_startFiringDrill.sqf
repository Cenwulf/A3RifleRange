params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

private ["_drill","_program"];

_drill = missionNamespace getVariable format ["%1_CURRENT_DRILL",_rangeID];

_program = [];

_startTime = serverTime;

switch (_drill) do {
	case "ETR_default": {
		_targTime = 8; 			// time a target is raised for
		_targInterval = 2; 		// time before next target
		_targIntervalP2K = 5; 	// time before next target when switching from prone to kneeling
		_targInterval50 = 20; 	// time before next target when advancing 50m
		_targInterval100 = 40; 	// time before next target when advancing 100m

		_hitsPerTarg = 5;

		_program = [
			[2,0,_hitsPerTarg,_targTime,_targInterval100,true],	// 400m prone, advance to main firing position
			[2,0,_hitsPerTarg,_targTime,_targInterval,false],	// 300m prone
			[1,0,_hitsPerTarg,_targTime,_targInterval,false],	// 200m prone
			[0,0,_hitsPerTarg,_targTime,_targIntervalP2K,true],	// 100m prone, switch to kneeling
			[2,0,_hitsPerTarg,_targTime,_targInterval,false],	// 300m kneeling
			[1,0,_hitsPerTarg,_targTime,_targInterval,false],	// 200m kneeling
			[0,0,_hitsPerTarg,_targTime,_targInterval50,true],	// 100m kneeling, advance to 50m firing position
			[0,0,_hitsPerTarg,_targTime,_targIntervalP2K,true],	// 50m prone, switch to kneeling
			[0,0,_hitsPerTarg,_targTime,_targInterval,false]	// 50m kneeling
		];

		_startTime = serverTime + 2;
	};
};

{
	private "_primary";
	_primary = if (_forEachIndex == 0) then {true} else {false}; // designates one lane to control buzzer timing
	[_rangeID,_x,_startTime,_program,_primary] spawn RR_fnc_runProgram;
} forEach _laneIndecies;