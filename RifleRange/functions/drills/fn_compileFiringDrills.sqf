scriptName "fn_compileFiringDrills";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Define and firing drills to be for different types of ranges. Drills are compiled and passed as an array to be read by other functions.

	Parameter(s):
	Nothing

	Returns:
	Array - Compiled list of all firing drills that have a _drillType defined.

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
	_targIndex - number or array, selects a target from a group 0 being the first target in the distance grouping in the case of an array it selects each target listed (e.g. [0,1,2] will the first three targets of that distance group provided that group has at least three targets listed)
	_hitsPerTarg - number of hits before target stops scoring (-1 will make it continue to score for the entire exposure time)
	_hitsRequired - number of hits required to score any points
	_targScore - number of points awarded each time a score is triggered
	_targScoreMax - max score before target stops scoring (NOT CURRENTLY IMPLEMENTED - probably never will be as the same can be achieved with _hitsPerTarg)
	_exposure - amount of time target stays up for
	_interval - amount of time before next target once _exposure time has elapsed
	_buzzer - dictates whether the buzzer should sound at the end of this targets _exposure time (used to signal shooter to move or change stance) (default false)
	_scoreGroup - dictates which score group the target will score for, must be a number between 1 and 4. By default the score group is assigned based on the tagets vehicleVarName given in the editor. eg ETR_l1_g1_0 defines a target belonging to the a range with RangeID "ETR" on lane 1 ("l1") and score group 1 ("g1") g1 defines the distance group which by default defines the score group.
	_fall - bool should it fall when max _hitsPerTarg reached? (default true)
*/
#define SELF RR_fnc_compileFiringDrills

private ["_displayName","_program","_drillType","_instructions","_image"];

private _drills = [];
private _exposureDefault = 8; 		// time a target is raised for
private _intervalDefault = 2; 		// time before next target
private _intervalP2KDefault = 5; 	// time before next target when switching from prone to kneeling
private _interval50Default = 14; 	// time before next target when advancing 50m
private _interval100Default = 26; 	// time before next target when advancing 100m

// Define Drill prgrams and compile them into _drills array

// ETR Default 		======================================================================================
_displayName = "ETR (Default)";			// string displayed in the ACE3 actions drill selection
_description = "";						// slightly more detailed desctiption for use in diary record
_drillType = ""; 						// drill type - at range creation an array of drill types is passed to RR_fnc_initRifleRange defined by the user who designed the rifle range, all drills with a given type are made available to that range (this drill will not be compiled if this value is "")
_image = "";							// image path to be used for diary record
_instructions = "";						// structured text in createDirayRecord format intended to give a detailed overview of the drill (Optional)

if (_drillType != "") then {			// skip if there is no drill type defined
	_targIndex = 0;						// element to select from target array grouped by lane and distance
	_exposure = _exposureDefault;		// time a target is raised for
	_interval = _intervalDefault;		// time before next target
	_intervalP2K = _intervalP2KDefault;	// time before next target when the player would need to switch from prone to kneeling
	_interval50 = _interval50Default;	// time before next target when the player would need to advance 50m
	_interval100 = _interval100Default;	// time before next target when the player would need to advance 100m

	_hitsPerTarg = 5;					// number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
	_hitsRequired = 1;					// number of hits required to trigger a score
	_targScore = 1;						// number of points a score is worth

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

	_drills pushBack [_displayName,_program,_drillType,_instructions,_image];
};

// =======================================================================================================

// ETR Ironsights	======================================================================================

_displayName = "ETR (Ironsights)";		// string displayed in the ACE3 actions drill selection
_description = "";						// slightly more detailed desctiption for use in diary record
_drillType = ""; 						// drill type - at range creation an array of drill types is passed to RR_fnc_initRifleRange defined by the user who designed the rifle range, all drills with a given type are made available to that range (this drill will not be compiled if this value is "")
_image = "";							// image path to be used for diary record
_instructions = "";						// structured text in createDirayRecord format intended to give a detailed overview of the drill (Optional)

if (_drillType != "") then {			// skip if there is no drill type defined
	_targIndex = 0;						// element to select from target array grouped by lane and distance
	_exposure = _exposureDefault;		// time a target is raised for
	_interval = _intervalDefault;		// time before next target
	_intervalP2K = _intervalP2KDefault;	// time before next target when the player would need to switch from prone to kneeling
	_interval50 = _interval50Default;	// time before next target when the player would need to advance 50m
	_interval100 = _interval100Default;	// time before next target when the player would need to advance 100m

	_hitsPerTarg = 5;					// number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
	_hitsRequired = 1;					// number of hits required to trigger a score
	_targScore = 1;						// number of points a score is worth

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

	_drills pushBack [_displayName,_program,_drillType,_instructions,_image];
};

// =======================================================================================================

// ETR Sidearm		======================================================================================

_displayName = "ETR (Sidearm)";		// string displayed in the ACE3 actions drill selection
_description = "";					// slightly more detailed desctiption for use in diary record
_drillType = "ETRP"; 				// drill type - at range creation an array of drill types is passed to RR_fnc_initRifleRange defined by the user who designed the rifle range, all drills with a given type are made available to that range (this drill will not be compiled if this value is "")
_image = "";						// image path to be used for diary record
_instructions = "";					// structured text in createDirayRecord format intended to give a detailed overview of the drill (Optional)

if (_drillType != "") then {		// skip if there is no drill type defined
	_targIndex = 0;					// element to select from target array grouped by lane and distance
	_exposure = 8; 					// time a target is raised for
	_interval = 2; 					// time before next target
	_intervalP2K = 5; 				// time before next target when the player would need to switch from prone to kneeling
	_interval50 = 20; 				// time before next target when the player would need to advance 50m
	_interval100 = 40; 				// time before next target when the player would need to advance 100m

	_hitsPerTarg = 5; 				// number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
	_hitsRequired = 1; 				// number of hits required to trigger a score
	_targScore = 1; 				// number of points a score is with

	_program = [
		[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],
		[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],
		[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],
		[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],
		[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,_interval],
		[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,2]
	];

	_drills pushBack [_displayName,_program,_drillType,_instructions,_image];
};

// =======================================================================================================

// ACTM (Rapid)		======================================================================================

_displayName = "ACTM (Rapid)";		// string displayed in the ACE3 actions drill selection
_description = "Annual Combat Marksmanship Test - Rapid-Fire Module";// slightly more detailed desctiption for use in diary record
_drillType = "ETR";					// drill type - at range creation an array of drill types is passed to RR_fnc_initRifleRange defined by the user who designed the rifle range, all drills with a given type are made available to that range (this drill will not be compiled if this value is "")
_image = "";						// image path to be used for diary record

if (_drillType != "") then {		// skip if there is no drill type defined
	_targIndex = 0;					// element to select from target array grouped by lane and distance
	_exposure = 10;					// time a target is raised for
	_interval = 5;					// time before next target
	_intervalSwitch = 12;			// time before next target when the player would need to switch stance or reload

	_hitsPerTarg = -1;				// number of hits before target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
	_hitsRequired = 1; 				// number of hits required to trigger a score
	_targScore = 1;					// number of points a score is worth

	_fall = false;					// dictate if target should fall when _hitsPerTarg limit reached

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

	_instructions =	[				// structured text in createDirayRecord format intended to give a detailed overview of the drill (Optional)
		"<font color='#FFC300'>Drill ID:</font> ", _displayName, "<br />",
		"<br />",
		"<font color='#FFC300'>Description:</font> ", _description, "<br />",
		"<br />",
		"<font color='#FFC300'>Ammunition Issued:</font> 3x 20 round magazine<br />",
		"<br />",
		"<font color='#FFC300'>Number of Exposures:</font> 12<br />",
		 "<br />",
		"<font color='#FFC300'>Engagement:</font> 5x single round per exposure<br />",
		 "<br />",
		"<font color='#FFC300'>Maximum Score:</font> 60<br />",
		"<br />",
		"<font color='#FFC300'>Exposure Time:</font> 10 seconds<br />",
		"<br />",
		"<font color='#FFC300'>Target Interval:</font> 5 seconds<br />",
		"<br />",
		"<font color='#FFC300'>Phase Transition Interval:</font> 12 seconds<br />",
		"<br />",
		"<font color='#FFC300'>Instructions:</font><br />",
		"The rapid-fire module consists of three identical phases. Phase 1 should be taken from prone with weapon supported or unsupported, phase 2 from kneeling with weapon unsupported, phase 3 from standing with weapon unsupported.<br />",
		"<br />",
		"Each phase consists of a single exposure at each distance in the order: 100m, 200m, 300m, 400m.<br />",
		"<br />",
		"The beginning of the exercise is marked by a short sounding of the loudspeaker. Subsequent short soundings of the loudspeaker indicate the transition between phases, participants should adjust their stance and reload their weapon.<br />",
		"<br />",
		"Participants should aim down the sights of the weapon for the duration of the exercise and engage each target with 5x single round shots per exposure.<br />",
		"<br />",
		"A long sounding of the loudspeaker indicates the end of the exercise. Participants should cease fire immediately and make safe their weapon."
	] joinString "";

	_drills pushBack [_displayName,_program,_drillType,_instructions,_image];
};

// =======================================================================================================

// ACTM (Snap)		======================================================================================

_displayName = "ACTM (Snap)";		// string displayed in the ACE3 actions drill selection
_description = "Annual Combat Marksmanship Test - Snap Shoot Module";						// slightly more detailed desctiption for use in diary record
_drillType = "ETR";					// drill type - at range creation an array of drill types is passed to RR_fnc_initRifleRange defined by the user who designed the rifle range, all drills with a given type are made available to that range (this drill will not be compiled if this value is "")
_image = "";						// image path to be used for diary record

if (_drillType != "") then {		// skip if there is no drill type defined
	_targIndex = 0;					// element to select from target array grouped by lane and distance
	_exposure = 3; 					// time a target is raised for
	_intervalMin = 0.5;				// min time interval
	_intervalMax = 12;				// max interval
	_interval = {_intervalMin + random (_intervalMax - _intervalMin)}; // random interval between min and max (interval must be called in prgram array)
	_intervalSwitch = 12; 			// time before next target when the player would need to switch stance or reload

	_hitsPerTarg = -1; 				// number of hits befroe target falls and stops scoring (-1 means it will not fall when hit until _exposure time expires)
	_hitsRequired = 1; 				// number of hits required to trigger a score
	_targScore = 1; 				// number of points a score is worth

	_fall = false;					// dictate if target should fall when _hitsPerTarg limit reached

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

	_instructions =	[				// structured text in createDirayRecord format intended to give a detailed overview of the drill (Optional)
		"<font color='#FFC300'>Drill ID:</font> ", _displayName, "<br />",
		"<br />",
		"<font color='#FFC300'>Description:</font> ", _description, "<br />",
		"<br />",
		"<font color='#FFC300'>Ammunition Issued:</font> 4x 10 round magazine<br />",
		"<br />",
		"<font color='#FFC300'>Number of Exposures:</font> 31<br />",
		"<br />",
		"<font color='#FFC300'>Engagement:</font> 1x single round per exposure (Phases 1 to 3); 10x single round rapid for 1 exposure (Phase 4)<br />",
		"<br />",
		"<font color='#FFC300'>Maximum Score:</font> 40<br />",
		"<br />",
		"<font color='#FFC300'>Exposure Time:</font> 3 seconds (Phases 1 to 3); 10 seconds (Phase 4)<br />",
		"<br />",
		"<font color='#FFC300'>Target Interval:</font> Between 0.5 and 12 seconds<br />",
		 "<br />",
		"<font color='#FFC300'>Phase Transition Interval:</font> 12 seconds<br />",
		"<br />",
		"<font color='#FFC300'>Instructions:</font><br />",
		"The snap shoot module consists of three identical phases consisting of semi randomised exposures and an additional phase consisting of a CQB exposure. Phase 1 should be taken from prone with weapon supported or unsupported, phase 2 from kneeling with weapon unsupported, phase 3 from standing with weapon unsupported, phase 4 from standing while advancing towards the target at walking pace.<br />",
		"<br />",
		"Phases 1 to 3 consist of a semi-random set of 10 exposures. 2 exposures at 100m, 3 exposures at 200m, 3 exposures at 300m and 2 exposures at 400m.<br />",
		"<br />",
		"Phase 4 consists of a single CQM exposure at 100m.<br />",
		"<br />",
		"The beginning of the exercise is marked by a short sounding of the loudspeaker. Subsequent short soundings of the loudspeaker indicate the transition between phases, participants should adjust their stance and reload their weapon.<br />",
		"<br />",
		"During phases 2 and 3 (kneeling and standing), participants should have their weapon lowered at all times. When a target appears, participants should aim down the sights of the weapon, acquire the target, engage the target with 1x single round shot and lower their weapon.<br />",
		"<br />",
		"During phase 4 (CQB), participants should aim down their alternative short-range sight (red dot) if available, advance towards the target at walking pace and engage the target with 10x single round shots in rapid succession.<br />",
		"<br />",
		"A long sounding of the loudspeaker indicates the end of the exercise. Participants should cease fire immediately and make safe their weapon.<br />",
		"<br />",
		"NOTE: Difficulty of the CQB exposure can be increased by increasing the speed of the advance and/or switching to fully automatic fire."
	] joinString "";

	_drills pushBack [_displayName,_program,_drillType,_instructions,_image];
};

// =======================================================================================================

// LMG/GPMG LR (Rapid)	==================================================================================

_displayName = "LMG/GPMG LR (Rapid)";	// string displayed in the ACE3 actions drill selection
_description = "Light Machinegun/General Purpose Machinegun - Rapid Fire Module";// slightly more detailed desctiption for use in diary record
_drillType = "LMG"; 					// drill type that - at range creation an arrat of drill types is passed to RR_fnc_initRifleRange defined by the user who designed the rifle range, all drills with a given type are made available to that range (drill will not be compiled if this value is "")
_image = "";							// image path to be used for diary record

if (_drillType != "") then {			// skip if there is no drill type defined
	_targIndex = [0,1,2];				// elements to select from target array grouped by lane and distance
	_exposure = 8;						// time a target is raised for
	_interval = 3;						// time before next target
	_intervalSwitch = 20;				// time before next target when the player would need to switch stance

	_hitsPerTarg = -1;					// number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
	_hitsRequired = 1; 					// number of hits required to trigger a score
	_targScore = 1;						// number of points a score is worth

	_fall = false;						// dictate if target should fall when _hitsPerTarg limit reached

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

	_instructions =	[					// structured text in createDirayRecord format intended to give a detailed overview of the drill (Optional)
		"<font color='#FFC300'>Drill ID:</font> ", _displayName, "<br />",
		"<br />",
		"<font color='#FFC300'>Description:</font> ", _description, "<br />",
		"<br />",
		"<font color='#FFC300'>Ammunition Issued:</font> 3x 60 round belt<br />",
		"<br />",
		"<font color='#FFC300'>Number of Exposures:</font> 12<br />",
		"<br />",
		"<font color='#FFC300'>Engagement:</font> 3x 3-5 round burst per exposure<br />",
		"<br />",
		"<font color='#FFC300'>Maximum Score:</font> 108 to 180<br />",
		"<br />",
		"<font color='#FFC300'>Exposure Time:</font> 8 seconds<br />",
		"<br />",
		"<font color='#FFC300'>Target Interval:</font> 3 seconds<br />",
		"<br />",
		"<font color='#FFC300'>Phase Transition Interval:</font> 20 seconds<br />",
		"<br />",
		"<font color='#FFC300'>Instructions:</font><br />",
		"The rapid-fire module consists of three identical phases. Phase 1 should be taken from prone with weapon supported, phase 2 from kneeling with weapon unsupported, phase 3 from standing with weapon unsupported.<br />",
		"<br />",
		"Each phase consists of a single exposure at each distance in the order: 100m, 200m, 300m, 400m.<br />",
		"<br />",
		"The beginning of the exercise is marked by a short sounding of the loudspeaker. Subsequent short soundings of the loudspeaker indicate the transition between phases, participants should adjust their stance and reload their weapon.<br />",
		"<br />",
		"Participants should aim down the sights of the weapon for the duration of the exercise and engage each target with 3x 3-5 round bursts per exposure.<br />",
		"<br />",
		"A long sounding of the loudspeaker indicates the end of the exercise. Participants should cease fire immediately and make safe their weapon."
	] joinString "";

	_drills pushBack [_displayName,_program,_drillType,_instructions,_image];
};

// =======================================================================================================

// LMG/GPMG LR (Defence)	==============================================================================

_displayName = "LMG/GPMG LR (Defense)";	// string displayed in the ACE3 actions drill selection
_description = "Light Machinegun/General Purpose Machinegun - Defensive Fire Module";// slightly more detailed desctiption for use in diary record
_drillType = "LMG"; 					// drill type - at range creation an array of drill types is passed to RR_fnc_initRifleRange defined by the user who designed the rifle range, all drills with a given type are made available to that range (this drill will not be compiled if this value is "")
_image = "";							// image path to be used for diary record

if (_drillType != "") then {			// skip if there is no drill type defined
	_targIndex = [0,1,2];				// elements to select from target array grouped by lane and distance
	_exposure = 8;						// time a target is raised for
	_intervalMin = 3;					// min time interval
	_intervalMax = 6;					// max interval
	_interval = {_intervalMin + random (_intervalMax - _intervalMin)}; // random interval between min and max (interval must be called in prgram array)
	_intervalSwitch = 20;				// time before next target when the player would need to switch stance

	_hitsPerTarg = -1;					// number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
	_hitsRequired = 1; 					// number of hits required to trigger a score
	_targScore = 1;						// number of points a score is worth

	_fall = false;						// dictate if target should fall when _hitsPerTarg limit reached

	_program = [
		[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[0,0,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[1,[0,1],_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall]
	];

	_instructions =	""					// structured text in createDirayRecord format intended to give a detailed overview of the drill (Optional)
	+ "<font color='#FFC300'>Drill ID:</font> " + _displayName + "<br />"
	+ "<br />"
	+ "<font color='#FFC300'>Description:</font> " + _description + "<br />"
	+ "<br />"
	+ "<font color='#FFC300'>Ammunition Issued:</font> 1x 100 round belt<br />"
	+ "<br />"
	+ "<font color='#FFC300'>Number of Exposures:</font> 20<br />"
	+ "<br />"
	+ "<font color='#FFC300'>Engagement:</font> 1x 3-5 round burst per exposure<br />"
	+ "<br />"
	+ "<font color='#FFC300'>Maximum Score:</font> 60 to 100<br />"
	+ "<br />"
	+ "<font color='#FFC300'>Exposure Time:</font> 8 seconds<br />"
	+ "<br />"
	+ "<font color='#FFC300'>Target Interval:</font> Between 3 and 6 seconds<br />"
	+ "<br />"
	+ "<font color='#FFC300'>Phase Transition Interval:</font> None<br />"
	+ "<br />"
	+ "<font color='#FFC300'>Instructions:</font><br />"
	+ "The defensive-fire module consists of a single phase designed to simulate an advancing and then retreating enemy force. The entire drill should be taken from the firing trench, kneeling with weapon supported.<br />"
	+ "<br />"
	+ "The beginning of the exercise is marked by a short sounding of the loudspeaker.<br />"
	+ "<br />"
	+ "The first half of the drill consists of a number of exposure at each distance advancing towards the firing position in the order: 400m, 300m, 200m, 100m. The second half consists of a number of exposures at each distance withdrawing from the firing position in the order: 100m, 200m, 300m, 400m.<br />"
	+ "<br />"
	+ "Participants should aim down the sights of the weapon for the duration of the exercise and engage each target with a single 3-5 round burst per exposure.<br />"
	+ "<br />"
	+ "A long sounding of the loudspeaker indicates the end of the exercise. Participants should cease fire immediately and make safe their weapon.";

	_drills pushBack [_displayName,_program,_drillType,_instructions,_image];
};

// =======================================================================================================

// Custom Drills
// copy and past the template below to create custom firing drills

// Custom Template	======================================================================================

_displayName = "My Drill";			// string displayed in the ACE3 actions drill selection
_description = "My Rifle Drill";	// slightly more detailed desctiption for use in diary record
_drillType = ""/*"MyRangeType"*/;	// drill type - at range creation an array of drill types is passed to RR_fnc_initRifleRange defined by the user who designed the rifle range, all drills with a given type are made available to that range (this drill will not be compiled if this value is "")
_image = "";						// image path to be used for diary record

if (_drillType != "") then {		// skip if there is no drill type defined
	_targIndex = 0;					// elements to select from target array grouped by lane and distance 0 is the default and will select the first element from the available list of targets
	_exposure = 10;					// time a target is raised for
	_intervalMin = 3;				// min time interval
	_intervalMax = 6;				// max interval
	_interval = {_intervalMin + random (_intervalMax - _intervalMin)}; // random interval between min and max (_interval must be called in prgram array)
	// _interval = 10				// use this if you want a fixed interval time rather than a randomised one (_interval does not need to be called)
	_intervalSwitch = 20;			// time before next target when the player would need to switch stance

	_hitsPerTarg = -1;				// number of hits befroe target falls and stops scoring (-1 means it will not fall when hit and will score for the duration of the _exposure time)
	_hitsRequired = 1; 				// number of hits required to trigger a score
	_targScore = 1;					// number of points a score is worth

	_fall = false;					// dictate if target should fall when _hitsPerTarg limit reached

	_program = [
		[0,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[1,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[2,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall],
		[3,_targIndex,_hitsPerTarg,_hitsRequired,_targScore,_exposure,call _interval,false,nil,_fall]
	];
	_instructions =	[""/*,			// structured text in createDirayRecord format intended to give a detailed overview of the drill (Optional)
	"<font color='#FFC300'>Drill ID:</font> ", _displayName, "<br />",
	"<br />",
	"<font color='#FFC300'>Description:</font> ", _description, "<br />",
	"<br />",
	"<font color='#FFC300'>Ammunition Issued:</font> 1x 100 round belt<br />",
	"<br />",
	"<font color='#FFC300'>Number of Exposures:</font> 20<br />",
	"<br />",
	"<font color='#FFC300'>Engagement:</font> 1x 3-5 round burst per exposure<br />",
	"<br />",
	"<font color='#FFC300'>Maximum Score:</font> 0<br />",
	"<br />",
	"<font color='#FFC300'>Exposure Time:</font> 10 seconds<br />",
	"<br />",
	"<font color='#FFC300'>Target Interval:</font> Between 3 and 6 seconds<br />",
	"<br />",
	"<font color='#FFC300'>Phase Transition Interval:</font> None<br />",
	"<br />",
	"<font color='#FFC300'>Instructions:</font><br />",
	"How you should stand, aim and shoot during this drill, when you should expect to change stance, etc."*/
	] joinString "";

	_drills pushBack [_displayName,_program,_drillType,_instructions,_image];
};

// =======================================================================================================

_drills
