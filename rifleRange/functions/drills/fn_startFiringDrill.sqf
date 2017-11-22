scriptName "fn_startFiringDrill";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	A list of different firing drills to be called for different types of ranges.

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who performed the action.
	_this select 2: Array - Custom params passed through ACE action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers referring to each lane to be modified by function.

	Returns:
	Nothing

	Notes:
	EXAMPLE PROGRAM:
	_program = [
		[_distIndex,_targIndex,_upTime,_interval,_buzzer,_scoreGroup (OPTIONAL)] // Target 1
		[_distIndex,_targIndex,_upTime,_interval,_buzzer,_scoreGroup (OPTIONAL)] // Target 2
		[_distIndex,_targIndex,_upTime,_interval,_buzzer,_scoreGroup (OPTIONAL)] // Target 3
		[_distIndex,_targIndex,_upTime,_interval,_buzzer,_scoreGroup (OPTIONAL)] // Target n...
		[_distIndex,_targIndex,_upTime,_interval,_buzzer,_scoreGroup (OPTIONAL)]  // Final target
	];

	_distIndex - targets are grouped, 0 = 100m targets, 1 = 200m targets, 2 = 300m targets
	_targIndext - only used if there are multiple targets at each distance (current range design only has 1 target at each distance so this is not used)
	_hitsPerTarg - number of hits before target goes down
	_upTime - amount of time target stays up for
	_interval - amount of time before next target once _upTime has elapsed
	_buzzer - dictates whether the buzzer should sound at the end of this targets _upTime (used to signal shooter to move or change stance)
	_scoreGroup - dictates which score group the target will score for, must be a number between 1 and 4. By default the score group is assigned based on the tagets vehicleVarName given in the editor. eg ETR_l1_g1_0 defines a target belonging to the a range with RangeID "ETR" on lane 1 ("l1") and score group 1 ("g1") g1 defines the distance group which by default defines the score group.
*/
#define SELF RR_fnc_startFiringDrill

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

private ["_drill","_program"];

_drill = missionNamespace getVariable format ["%1_CURRENT_DRILL",_rangeID];

_program = [];

_startTime = time;
_exposureDefault = 8; 		// time a target is raised for
_intervalDefault = 2; 		// time before next target
_intervalP2KDefault = 5; 	// time before next target when switching from prone to kneeling
_interval50Default = 14; 	// time before next target when advancing 50m
_interval100Default = 26; 	// time before next target when advancing 100m

_targIndex = if (count (missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select 0 select 0) > 1) then {-1} else {0}; // If a lane has multiple targets in the same distance grouping (close, medium, long) a random one from that group will be selected by default, if it is necessary to select a specific target the target index for that target can be defined in the program bellow in place of the default value "_targIndex". A targets index in this case is simply the index of it's position within the corresponding distanace array within the "missionNamespace getVariable [format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID]]" array. (See fn_initRifleRange.sqf for reference on how that array is created and how targets are sorted into that array).

// Define custom drills here with a unique string for each case, add this string to the drills array fn_initRifleRange function.
// NOTE: User is unable to switch drill in game without using ACE3 actions, if using vanilla only modify the "ETR_default" drill
switch (_drill) do {
	case "ETR_default": {
		_exposure = _exposureDefault;		// time a target is raised for
		_interval = _intervalDefault;		// time before next target
		_intervalP2K = _intervalP2KDefault;	// time before next target when the player would need to switch from prone to kneeling
		_interval50 = _interval50Default;	// time before next target when the player would need to advance 50m
		_interval100 = _interval100Default;	// time before next target when the player would need to advance 100m

		_hitsPerTarg = 5; // Maximum number of hits able to be scored per target, target will drop if number of hits reaches max hits or the _exposure is exceeded.

		_program = [
			[2,_targIndex,_hitsPerTarg,_exposure,_interval100,true],		// 400m prone, advance to main firing position
			[2,_targIndex,_hitsPerTarg,_exposure-1,_interval,false],		// 300m prone
			[1,_targIndex,_hitsPerTarg,_exposure-2,_interval,false],		// 200m prone
			[0,_targIndex,_hitsPerTarg,_exposure-3,_intervalP2K,true],		// 100m prone, switch to kneeling
			[2,_targIndex,_hitsPerTarg,_exposure-1,_interval,false],		// 300m kneeling
			[1,_targIndex,_hitsPerTarg,_exposure-2,_interval,false],		// 200m kneeling
			[0,_targIndex,_hitsPerTarg,_exposure-3,_interval50,true],		// 100m kneeling, advance to 50m firing position
			[0,_targIndex,_hitsPerTarg,_exposure-5,_intervalP2K,true],		// 50m prone, switch to kneeling
			[0,_targIndex,_hitsPerTarg,_exposure-5,0,false]					// 50m kneeling
		];
	};
	case "ETR_ironsights": {
		_exposure = _exposureDefault;		// time a target is raised for
		_interval = _intervalDefault;		// time before next target
		_intervalP2K = _intervalP2KDefault;	// time before next target when the player would need to switch from prone to kneeling
		_interval50 = _interval50Default;	// time before next target when the player would need to advance 50m
		_interval100 = _interval100Default;	// time before next target when the player would need to advance 100m

		_hitsPerTarg = 5;

		_program = [
			[2,_targIndex,10,_exposure - 1,_interval,false],				// 300m prone
			[1,_targIndex,_hitsPerTarg,_exposure - 2,_interval,false],		// 200m prone
			[0,_targIndex,_hitsPerTarg,_exposure - 3,_intervalP2K,true],	// 100m prone, switch to kneeling
			[2,_targIndex,_hitsPerTarg,_exposure - 1,_interval,false],		// 300m kneeling
			[1,_targIndex,_hitsPerTarg,_exposure - 2,_interval,false],		// 200m kneeling
			[0,_targIndex,_hitsPerTarg,_exposure - 3,_interval50,true],		// 100m kneeling, advance to 50m firing position
			[0,_targIndex,_hitsPerTarg,_exposure - 5,_intervalP2K,true],	// 50m prone, switch to kneeling
			[0,_targIndex,_hitsPerTarg,_exposure - 5,0,false]				// 50m kneeling
		];
	};
	case "ETR_classic": { // no longer used
		_exposure = 8; 			// time a target is raised for
		_interval = 2; 		// time before next target
		_intervalP2K = 5; 	// time before next target when the player would need to switch from prone to kneeling
		_interval50 = 20; 	// time before next target when the player would need to advance 50m
		_interval100 = 40; 	// time before next target when the player would need to advance 100m

		_hitsPerTarg = 5;

		_program = [
			[2,_targIndex,_hitsPerTarg,_exposure,_interval100,true],	// 400m prone, advance to main firing position
			[2,_targIndex,_hitsPerTarg,_exposure,_interval,false],		// 300m prone
			[1,_targIndex,_hitsPerTarg,_exposure,_interval,false],		// 200m prone
			[0,_targIndex,_hitsPerTarg,_exposure,_intervalP2K,true],	// 100m prone, switch to kneeling
			[2,_targIndex,_hitsPerTarg,_exposure,_interval,false],		// 300m kneeling
			[1,_targIndex,_hitsPerTarg,_exposure,_interval,false],		// 200m kneeling
			[0,_targIndex,_hitsPerTarg,_exposure,_interval50,true],		// 100m kneeling, advance to 50m firing position
			[0,_targIndex,_hitsPerTarg,_exposure,_intervalP2K,true],	// 150m standing, switch to kneeling
			[0,_targIndex,_hitsPerTarg,_exposure,0,false]				// 250m kneeling
		];
	};

	case "ETRP_default": { 	// default pistol range program
		_exposure = 8; 		// time a target is raised for
		_interval = 2; 		// time before next target
		_intervalP2K = 5; 	// time before next target when the player would need to switch from prone to kneeling
		_interval50 = 20; 	// time before next target when the player would need to advance 50m
		_interval100 = 40; 	// time before next target when the player would need to advance 100m

		_hitsPerTarg = 5;

		_program = [
			[0,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[0,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[0,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[0,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[0,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[0,_targIndex,_hitsPerTarg,_exposure,0,false]
		];
	};

	case "ETR_rapidfire": {
		_exposure = 10;			// time a target is raised for
		_interval = 5;			// time before next target
		_intervalSwitch = 10;	// time before next target when the player would need to switch stance

		_hitsPerTarg = 1000;	// Number of hits befroe target falls

		_program = [
			[0,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[1,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[2,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[3,_targIndex,_hitsPerTarg,_exposure,_intervalSwitch,true],
			[0,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[1,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[2,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[3,_targIndex,_hitsPerTarg,_exposure,_intervalSwitch,true],
			[0,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[1,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[2,_targIndex,_hitsPerTarg,_exposure,_interval,false],
			[3,_targIndex,_hitsPerTarg,_exposure,0,false]
		];
	};

	case "ETR_snapcombo": {


		_distIndex = 0;
		_exposure = 3; // time a target is raised for
		_interval = {0.5 + linearConversion [0,115,floor random 116,0,11.5]}; // randome interval between 0.5 and 12 seconds
		_intervalSwitch = 10; // time before next target when the player would need to switch stance

		_hitsPerTarg = 1000; // Number of hits befroe target falls and stops scoring

		_program = [
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,1],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,1],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,1],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,1],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,1],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,1],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,1],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,1],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,1],
			[0,_targIndex,_hitsPerTarg,_exposure,_intervalSwitch,true,1], 	// prone 10 shots at random targets
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,2],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,2],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,2],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,2],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,2],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,2],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,2],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,2],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,2],
			[0,_targIndex,_hitsPerTarg,_exposure,_intervalSwitch,true,2], 	// kneeling 10 shots at random targets
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,3],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,3],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,3],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,3],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,3],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,3],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,3],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,3],
			[0,_targIndex,_hitsPerTarg,_exposure,call _interval,false,3],
			[0,_targIndex,_hitsPerTarg,_exposure,_intervalSwitch,true,3], 	// standing 10 shots at random targets
			[0,_targIndex,_hitsPerTarg,10,0,false,4] 										// CQM exposure
		];

		_distIndexArray = [0,0,1,1,1,2,2,2,3,3];

		for "_i" from 0 to 2 do {
			_array = _distIndexArray call BIS_fnc_arrayShuffle;
			{
				_element = _forEachIndex + (_i * 10);
				_program select _element set [0,_x];
			} forEach _array;
		};
	};
};

_startTime = time + 2;

{
	private "_primary";
	_primary = if (_forEachIndex == 0) then {true} else {false}; // designates one lane to control buzzer timing
	[_rangeID,_x,_startTime,_program,_primary] spawn RR_fnc_runProgram;
} forEach _laneIndecies;
