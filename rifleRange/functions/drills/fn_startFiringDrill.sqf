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
	Bool - True when done
*/
#define SELF RR_fnc_startFiringDrill

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

private ["_drill","_program"];

_drill = missionNamespace getVariable format ["%1_CURRENT_DRILL",_rangeID];

_program = [];

_startTime = time;

_targTimeDefault = 8; 			// time a target is raised for
_targIntervalDefault = 2; 		// time before next target
_targIntervalP2KDefault = 5; 	// time before next target when switching from prone to kneeling
_targInterval50Default = 14; 	// time before next target when advancing 50m
_targInterval100Default = 26; 	// time before next target when advancing 100m

_targIndex = if (count (missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select 0 select 0) > 1) then {-1} else {0};

// Define custom drills here with a unique string for each case, add this string to the drills array fn_initRifleRange function.
// NOTE: User is unable to switch drill in game without using ACE3 actions, if using vanilla only modify the "ETR_default" drill

switch (_drill) do {
	case "ETR_default": {
		_targTime = _targTimeDefault;
		_targInterval = _targIntervalDefault;
		_targIntervalP2K = _targIntervalP2KDefault;
		_targInterval50 = _targInterval50Default;
		_targInterval100 = _targInterval100Default;

		_hitsPerTarg = 5;

		// _distIndex - targets are grouped, 0 = 100m targets, 1 = 200m targets, 2 = 300m targets
		// _targIndext - only used if there are multiple targets at each distance (current range design only has 1 target at each distance so this is not used)
		// _hitsPerTarg - number of hits before target goes down
		// _upTime - amount of time target stays up for
		// _interval - amount of time before next target once _upTime has elapsed
		// _buzzer - dictates whether the buzzer should sound at the end of this targets _upTime (used to signal shooter to move or change stance)

		_program = [
		//	[_distIndex,_targIndex,_upTime,_interval,_buzzer]
			[2,_targIndex,_hitsPerTarg,_targTime,_targInterval100,true],			// 400m prone, advance to main firing position
			[2,_targIndex,_hitsPerTarg,_targTime-1,_targInterval,false],			// 300m prone
			[1,_targIndex,_hitsPerTarg,_targTime-2,_targInterval,false],			// 200m prone
			[0,_targIndex,_hitsPerTarg,_targTime-3,_targIntervalP2K,true],		// 100m prone, switch to kneeling
			[2,_targIndex,_hitsPerTarg,_targTime-1,_targInterval,false],			// 300m kneeling
			[1,_targIndex,_hitsPerTarg,_targTime-2,_targInterval,false],			// 200m kneeling
			[0,_targIndex,_hitsPerTarg,_targTime-3,_targInterval50,true],		// 100m kneeling, advance to 50m firing position
			[0,_targIndex,_hitsPerTarg,_targTime-5,_targIntervalP2K,true],		// 50m prone, switch to kneeling
			[0,_targIndex,_hitsPerTarg,_targTime-5,_targInterval,false]			// 50m kneeling
		];

		_startTime = time + 2;
	};
	case "ETR_ironsights": {
		_targTime = _targTimeDefault;
		_targInterval = _targIntervalDefault;
		_targIntervalP2K = _targIntervalP2KDefault;
		_targInterval50 = _targInterval50Default;
		_targInterval100 = _targInterval100Default;

		_hitsPerTarg = 5;

		_program = [
			[2,_targIndex,10,_targTime-1,_targInterval,false],			// 300m prone
			[1,_targIndex,_hitsPerTarg,_targTime-2,_targInterval,false],			// 200m prone
			[0,_targIndex,_hitsPerTarg,_targTime-3,_targIntervalP2K,true],		// 100m prone, switch to kneeling
			[2,_targIndex,_hitsPerTarg,_targTime-1,_targInterval,false],			// 300m kneeling
			[1,_targIndex,_hitsPerTarg,_targTime-2,_targInterval,false],			// 200m kneeling
			[0,_targIndex,_hitsPerTarg,_targTime-3,_targInterval50,true],		// 100m kneeling, advance to 50m firing position
			[0,_targIndex,_hitsPerTarg,_targTime-5,_targIntervalP2K,true],		// 50m prone, switch to kneeling
			[0,_targIndex,_hitsPerTarg,_targTime-5,_targInterval,false]			// 50m kneeling
		];

		_startTime = time + 2;
	};
	case "ETR_phase1": {
		_targTime = _targTimeDefault;
		_targInterval = _targIntervalDefault;
		_targIntervalP2K = _targIntervalP2KDefault;
		_targInterval50 = _targInterval50Default;
		_targInterval100 = _targInterval100Default;

		_hitsPerTarg = 5;

		_program = [
			[2,_targIndex,_hitsPerTarg,_targTime,_targInterval100,true],			// 400m prone, advance to main firing position
			[2,_targIndex,_hitsPerTarg,_targTime-1,_targInterval,false],			// 300m prone
			[1,_targIndex,_hitsPerTarg,_targTime-2,_targInterval,false],			// 200m prone
			[0,_targIndex,_hitsPerTarg,_targTime-3,_targIntervalP2K,true],		// 100m prone, switch to kneeling
			[2,_targIndex,_hitsPerTarg,_targTime-1,_targInterval,false],			// 300m kneeling
			[1,_targIndex,_hitsPerTarg,_targTime-2,_targInterval,false],			// 200m kneeling
			[0,_targIndex,_hitsPerTarg,_targTime-3,_targInterval50,true],		// 100m kneeling, advance to 50m firing position
			[1,_targIndex,_hitsPerTarg,_targTime-5,_targIntervalP2K,true],		// 150m Standing, switch to kneeling
			[2,_targIndex,_hitsPerTarg,_targTime-5,_targInterval,false]			// 250m kneeling
		];

		_startTime = time + 2;
	};
	case "ETR_classic": {
		_targTime = 8; 			// time a target is raised for
		_targInterval = 2; 		// time before next target
		_targIntervalP2K = 5; 	// time before next target when switching from prone to kneeling
		_targInterval50 = 20; 	// time before next target when advancing 50m
		_targInterval100 = 40; 	// time before next target when advancing 100m

		_hitsPerTarg = 5;

		_program = [
			[2,_targIndex,_hitsPerTarg,_targTime,_targInterval100,true],			// 400m prone, advance to main firing position
			[2,_targIndex,_hitsPerTarg,_targTime,_targInterval,false],			// 300m prone
			[1,_targIndex,_hitsPerTarg,_targTime,_targInterval,false],			// 200m prone
			[0,_targIndex,_hitsPerTarg,_targTime,_targIntervalP2K,true],			// 100m prone, switch to kneeling
			[2,_targIndex,_hitsPerTarg,_targTime,_targInterval,false],			// 300m kneeling
			[1,_targIndex,_hitsPerTarg,_targTime,_targInterval,false],			// 200m kneeling
			[0,_targIndex,_hitsPerTarg,_targTime,_targInterval50,true],			// 100m kneeling, advance to 50m firing position
			[0,_targIndex,_hitsPerTarg,_targTime,_targIntervalP2K,true],			// 150m standing, switch to kneeling
			[0,_targIndex,_hitsPerTarg,_targTime,_targInterval,false]			// 250m kneeling
		];

		_startTime = time + 2;
	};
};

{
	private "_primary";
	_primary = if (_forEachIndex == 0) then {true} else {false}; // designates one lane to control buzzer timing
	[_rangeID,_x,_startTime,_program,_primary] spawn RR_fnc_runProgram;
} forEach _laneIndecies;