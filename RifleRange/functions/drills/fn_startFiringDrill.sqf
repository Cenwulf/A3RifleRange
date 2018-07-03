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
		[_distIndex,_hitsPerTarg,_hitsRequired,_targScore,_targIndex,_exposure,_interval,_buzzer(OPTIONAL),_scoreGroup (OPTIONAL),_fall (OPTIONAL)],	// Target exposure 1
		[_distIndex,_hitsPerTarg,_hitsRequired,_targScore,_targIndex,_exposure,_interval,_buzzer(OPTIONAL),_scoreGroup (OPTIONAL),_fall (OPTIONAL)],	// Target exposure 2
		[_distIndex,_hitsPerTarg,_hitsRequired,_targScore,_targIndex,_exposure,_interval,_buzzer(OPTIONAL),_scoreGroup (OPTIONAL),_fall (OPTIONAL)],	// Target exposure 3
		[_distIndex,_hitsPerTarg,_hitsRequired,_targScore,_targIndex,_exposure,_interval,_buzzer(OPTIONAL),_scoreGroup (OPTIONAL),_fall (OPTIONAL)],	// Target exposure n...
		[_distIndex,_hitsPerTarg,_hitsRequired,_targScore,_targIndex,_exposure,_interval,_buzzer(OPTIONAL),_scoreGroup (OPTIONAL),_fall (OPTIONAL)]		// Final target exposure
	];

	_distIndex - targets are grouped by distance, for rifle ranges with the default layout 0 = 100m targets, 1 = 200m targets, 2 = 300m targets, 3 = 400m targets
	_targIndex - only used if there are multiple targets at each distance (current range design only has 1 target at each distance so this is not used but)
	_hitsPerTarg - number of hits before target stops scoring (-1 will make it continue to score for the entire exposure time)
	_hitsRequired - number of hits before target is scored
	_targScore - max number of hits before target stops scoring (-1 makes it infinite, hits will keep scoring as long as it stays up)
	_exposure - amount of time target stays up for
	_interval - amount of time before next target once _exposure time has elapsed
	_buzzer - dictates whether the buzzer should sound at the end of this targets _exposure time (used to signal shooter to move or change stance) (default false)
	_scoreGroup - dictates which score group the target will score for, must be a number between 1 and 4. By default the score group is assigned based on the tagets vehicleVarName given in the editor. eg ETR_l1_g1_0 defines a target belonging to the a range with RangeID "ETR" on lane 1 ("l1") and score group 1 ("g1") g1 defines the distance group which by default defines the score group.
	_fall - bool should it fall when max _hitsPerTarg reached? (default true)
*/
#define SELF RR_fnc_startFiringDrill

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

private ["_drill","_program"];

_drill = missionNamespace getVariable format ["%1_CURRENT_DRILL",_rangeID];

private _program = [];
private _exposureDefault = 8; 		// time a target is raised for
private _intervalDefault = 2; 		// time before next target
private _intervalP2KDefault = 5; 	// time before next target when switching from prone to kneeling
private _interval50Default = 14; 	// time before next target when advancing 50m
private _interval100Default = 26; 	// time before next target when advancing 100m

private _targIndexDefault = if (count (missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select 0 select 0) > 1) then {-1} else {0}; // if there is only one target the default is the index of that target (0) else it is -1 which will select a random target by default (see  fn_runProgram.sqf)

// Define custom drills here with a unique string for each case, add this string to the drills array fn_initRifleRange function.
// NOTE: User is unable to switch drill in game without using ACE3 actions, if using the rifle range without ace3 only modify the "ETR_default" drill
switch (_drill) do {
	case "ETR_default": {
		_targIndex = 0;						// element to select from target array grouped by lane and distance
		_exposure = _exposureDefault;		// time a target is raised for
		_interval = _intervalDefault;		// time before next target
		_intervalP2K = _intervalP2KDefault;	// time before next target when the player would need to switch from prone to kneeling
		_interval50 = _interval50Default;	// time before next target when the player would need to advance 50m
		_interval100 = _interval100Default;	// time before next target when the player would need to advance 100m

		_hitsPerTarg = 5;					// Number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
		_hitsRequired = 1;					// Number of hits required to trigger a score
		_targScore = 1;						// Number of points a score is worth

		_program = [
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval100,true],		// 400m prone, advance to main firing position
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure-1,_interval],				// 300m prone
			[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure-2,_interval],				// 200m prone
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure-3,_intervalP2K,true],		// 100m prone, switch to kneeling
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure-1,_interval],				// 300m kneeling
			[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure-2,_interval],				// 200m kneeling
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure-3,_interval50,true],		// 100m kneeling, advance to 50m firing position
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure-5,_intervalP2K,true],		// 50m prone, switch to kneeling
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure-5,2]						// 50m kneeling
		];
	};
	case "ETR_ironsights": {
		_targIndex = 0;						// element to select from target array grouped by lane and distance
		_exposure = _exposureDefault;		// time a target is raised for
		_interval = _intervalDefault;		// time before next target
		_intervalP2K = _intervalP2KDefault;	// time before next target when the player would need to switch from prone to kneeling
		_interval50 = _interval50Default;	// time before next target when the player would need to advance 50m
		_interval100 = _interval100Default;	// time before next target when the player would need to advance 100m

		_hitsPerTarg = 5;					// Number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
		_hitsRequired = 1;					// Number of hits required to trigger a score
		_targScore = 1;						// Number of points a score is worth

		_program = [
			[2,_targIndex,10,_targScore,_exposure - 1,_interval],									// 300m prone
			[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure - 2,_interval],			// 200m prone
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure - 3,_intervalP2K,true],	// 100m prone, switch to kneeling
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure - 1,_interval],			// 300m kneeling
			[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure - 2,_interval],			// 200m kneeling
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure - 3,_interval50,true],	// 100m kneeling, advance to 50m firing position
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure - 5,_intervalP2K,true],	// 50m prone, switch to kneeling
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure - 5,2]					// 50m kneeling
		];
	};
	case "ETR_classic": { // no longer used
		_targIndex = 0;		// element to select from target array grouped by lane and distance
		_exposure = 8; 		// time a target is raised for
		_interval = 2; 		// time before next target
		_intervalP2K = 5; 	// time before next target when the player would need to switch from prone to kneeling
		_interval50 = 20; 	// time before next target when the player would need to advance 50m
		_interval100 = 40; 	// time before next target when the player would need to advance 100m

		_hitsPerTarg = 5; // Number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
		_hitsRequired = 1; // Number of hits required to trigger a score
		_targScore = 1; // Number of points a score is worth

		_program = [
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval100,true],	// 400m prone, advance to main firing position
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],			// 300m prone
			[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],			// 200m prone
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_intervalP2K,true],	// 100m prone, switch to kneeling
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],			// 300m kneeling
			[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],			// 200m kneeling
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval50,true],	// 100m kneeling, advance to 50m firing position
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_intervalP2K,true],	// 150m standing, switch to kneeling
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,2]					// 250m kneeling
		];
	};

	case "ETRP_default": { 	// default pistol range program
		_targIndex = 0;					// element to select from target array grouped by lane and distance
		_exposure = 8; 					// time a target is raised for
		_interval = 2; 					// time before next target
		_intervalP2K = 5; 				// time before next target when the player would need to switch from prone to kneeling
		_interval50 = 20; 				// time before next target when the player would need to advance 50m
		_interval100 = 40; 				// time before next target when the player would need to advance 100m

		_hitsPerTarg = 5; 				// Number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
		_hitsRequired = 1; 				// Number of hits required to trigger a score
		_targScore = 1; 				// Number of points a score is with

		_program = [
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,2]
		];
	};

	case "ETR_rapidfire": {
		_targIndex = 0;					// element to select from target array grouped by lane and distance
		_exposure = 10;					// time a target is raised for
		_interval = 5;					// time before next target
		_intervalSwitch = 12;			// time before next target when the player would need to switch stance or reload

		_hitsPerTarg = -1;				// Number of hits before target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
		_hitsRequired = 1; 				// Number of hits required to trigger a score
		_targScore = 1;					// Number of points a score is worth

		_fall = false;

		_program = [
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],		// phase 1 prone 20 shots at targets in sequence
			[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_intervalSwitch,true,nil,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],		// phase 2 prone 20 shots at targets in sequence
			[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_intervalSwitch,true,nil,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],		// phase 3 prone 20 shots at targets in sequence
			[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,2,false,nil,_fall]
		];
	};

	case "ETR_snapcombo": {
		_targIndex = 0;					// element to select from target array grouped by lane and distance
		_exposure = 3; 					// time a target is raised for
		_intervalMin = 0.5;				// min time interval
		_intervalMax = 12;				// max interval
		_interval = {_intervalMin + random (_intervalMax - _intervalMin)}; // random interval between min and max
		_intervalSwitch = 12; 			// time before next target when the player would need to switch stance or reload

		_hitsPerTarg = 5; 				// Number of hits befroe target falls and stops scoring (-1 means it will not fall when hit until _exposure time expires)
		_hitsRequired = 1; 				// Number of hits required to trigger a score
		_targScore = 1; 				// Number of points a score is worth

		_fall = false;

		_program = [
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,1,_fall],	// phase 1 prone 10 shots at semi random targets
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,1,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,1,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,1,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,1,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,1,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,1,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,1,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,1,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_intervalSwitch,true,1,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,2,_fall],	// phase 2 kneeling 10 shots at semi random targets
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,2,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,2,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,2,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,2,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,2,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,2,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,2,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,2,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_intervalSwitch,true,2,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,3,_fall],	// phase 3 standing 10 shots at semi random targets
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,3,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,3,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,3,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,3,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,3,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,3,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,3,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,3,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_intervalSwitch,true,3,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,10,2,false,4,_fall] 						// phase 4 CQM exposure 10 shots while advancing at walking pace
		];

		// randomise target distance but with a consistant number of exposures at each distance
		_distIndexArray = [0,0,1,1,1,2,2,2,3,3]; // 2 close, 3 mediuim, 3 far and 2 extreme

		// shuffle _distIndexArray and replace the
		for "_i" from 0 to 2 do {
			_array = _distIndexArray call BIS_fnc_arrayShuffle;
			{
				_element = _forEachIndex + (_i * 10);
				_program select _element set [0,_x];
			} forEach _array;
		};
	};

	case "ETR_lmg": {
		_targIndex = [0,1,2];			// elements to select from target array grouped by lane and distance
		_exposure = 10;					// time a target is raised for
		_interval = 5;					// time before next target
		_intervalSwitch = 10;			// time before next target when the player would need to switch stance

		_hitsPerTarg = 15;				// Number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
		_hitsRequired = 1; 				// Number of hits required to trigger a score
		_targScore = 1;					// Number of points a score is worth

		_fall = false;

		_program = [
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_intervalSwitch,true,nil,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_intervalSwitch,true,nil,_fall],
			[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,2,false,nil,_fall]
		];
	};

	case "ETR_p1lmg": {
		_targIndex = [0,1,2];			// elements to select from target array grouped by lane and distance
		_exposure = 8;					// time a target is raised for
		_interval = 3;					// time before next target
		_intervalSwitch = 20;			// time before next target when the player would need to switch stance

		_hitsPerTarg = 5;				// Number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
		_hitsRequired = 1; 				// Number of hits required to trigger a score
		_targScore = 1;					// Number of points a score is worth

		_fall = false;

		_program = [
			[0,0,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_intervalSwitch,true,nil,_fall],
			[0,0,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_intervalSwitch,true,nil,_fall],
			[0,0,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,2,false,nil,_fall]
		];
	};

	case "ETR_p2lmg": {
		_targIndex = [0,1,2];			// elements to select from target array grouped by lane and distance
		_exposure = 10;					// time a target is raised for
		_intervalMin = 3;				// min time interval
		_intervalMax = 6;				// max interval
		_interval = {_intervalMin + random (_intervalMax - _intervalMin)}; // random interval between min and max
		_intervalSwitch = 20;			// time before next target when the player would need to switch stance

		_hitsPerTarg = 5;				// Number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
		_hitsRequired = 1; 				// Number of hits required to trigger a score
		_targScore = 1;					// Number of points a score is worth

		_fall = false;

		_program = [
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[0,0,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall],
			[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval,false,nil,_fall]
		];
	};
};

_startTime = time;

{
	private "_primary";
	_primary = if (_forEachIndex == 0) then {true} else {false}; // designates one lane to control buzzer timing
	[_rangeID,_x,_startTime,_program,_primary] spawn RR_fnc_runProgram;
} forEach _laneIndecies;
