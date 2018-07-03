scriptName "fn_initCommon";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Initialise all common global variables used by all rifle ranges in the mission, such as the drill programs.

	Parameter(s):
	None

	Returns:
	Nothing
*/
#define SELF RR_fnc_initCommon

// initialise client side common scripts
if !isDedicated then {
	[] call RR_fnc_addRangeManual;

// TODO: Move firing drill specific diary records to fn_compileFiringDrills.sqf
/*	player createDiaryRecord [
		"RR_Drills",
		[
			"LMG/GPMG LR (Defence)",
			"<font color='#FFC300'>Drill ID:</font> LMG/GPMG LR (Defence)<br />"
			+ "<br />"
			+ "<font color='#FFC300'>Description:</font> Light Machinegun/General Purpose Machinegun - Defensive Fire Module<br />"
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
			+ "The first half of the drill consists of a number of exposure at each distance advancing towards the firing position in the order: 400m, 300m, 200m, 100m. The second half consists of a number of exposures at each distance withdrawing from the firing position in the order: 100m, 200m, 300m, 400m.<br />"
			+ "<br />"
			+ "Participants should aim down the sights of the weapon for the duration of the exercise and engage each target with a single 3-5 round burst per exposure.<br />"
			+ "<br />"
			+ "A long sounding of the loudspeaker indicates the end of the exercise. Participants should cease fire immediately and make safe their weapon.";

		]
	];
	player createDiaryRecord [
		"RR_Drills",
		[
			"LMG/GPMG LR (Rapid)",
			"<font color='#FFC300'>Drill ID:</font> LMG/GPMG LR (Rapid)<br />"
			+ "<br />"
			+ "<font color='#FFC300'>Description:</font> Light Machinegun/General Purpose Machinegun - Rapid Fire Module<br />"
			+ "<br />"
			+ "<font color='#FFC300'>Ammunition Issued:</font> 3x 60 round belt<br />"
			+ "<br />"
			+ "<font color='#FFC300'>Number of Exposures:</font> 12<br />"
			+ "<br />"
			+ "<font color='#FFC300'>Engagement:</font> 3x 3-5 round burst per exposure<br />"
			+ "<br />"
			+ "<font color='#FFC300'>Maximum Score:</font> 108 to 180<br />"
			+ "<br />"
			+ "<font color='#FFC300'>Exposure Time:</font> 8 seconds<br />"
			+ "<br />"
			+ "<font color='#FFC300'>Target Interval:</font> 3 seconds<br />"
			+ "<br />"
			+ "<font color='#FFC300'>Phase Transition Interval:</font> 20 seconds<br />"
			+ "<br />"
			+ "<font color='#FFC300'>Instructions:</font><br />"
			+ "The rapid-fire module consists of three identical phases. Phase 1 should be taken from prone with weapon supported, phase 2 from kneeling with weapon unsupported, phase 3 from standing with weapon unsupported.<br />"
			+ "<br />"
			+ "Each phase consists of a single exposure at each distance in the order: 100m, 200m, 300m, 400m.<br />"
			+ "<br />"
			+ "A short sounding of the loudspeaker indicates the transition between phases, participants should adjust their stance and reload their weapon.<br />"
			+ "<br />"
			+ "Participants should aim down the sights of the weapon for the duration of the exercise and engage each target with 3x 3-5 round bursts per exposure.<br />"
			+ "<br />"
			+ "A long sounding of the loudspeaker indicates the end of the exercise. Participants should cease fire immediately and make safe their weapon."
		]
	];
	player createDiaryRecord [
		"RR_Drills",
		[
			"ACTM (Snap)",
			"<font color='#FFC300'>Drill ID:</font> ACTM (Snap)<br />"
			+ "<br />"
			+"<font color='#FFC300'>Description:</font> Annual Combat Marksmanship Test - Snap Shoot Module<br />"
			+ "<br />"
			+"<font color='#FFC300'>Ammunition Issued:</font> 4x 10 round magazine<br />"
			+ "<br />"
			+"<font color='#FFC300'>Number of Exposures:</font> 31<br />"
			+ "<br />"
			+"<font color='#FFC300'>Engagement:</font> 1x single round per exposure (Phases 1 to 3); 10x single round rapid for 1 exposure (Phase 4)<br />"
			+ "<br />"
			+"<font color='#FFC300'>Maximum Score:</font> 40<br />"
			+ "<br />"
			+"<font color='#FFC300'>Exposure Time:</font> 3 seconds (Phases 1 to 3); 10 seconds (Phase 4)<br />"
			+ "<br />"
			+"<font color='#FFC300'>Target Interval:</font> Between 0.5 and 12 seconds<br />"
			+ "<br />"
			+"<font color='#FFC300'>Phase Transition Interval:</font> 12 seconds<br />"
			+ "<br />"
			+"<font color='#FFC300'>Instructions:</font><br />"
			+"The snap shoot module consists of three identical phases consisting of semi randomised exposures and an additional phase consisting of a CQB exposure. Phase 1 should be taken from prone with weapon supported or unsupported, phase 2 from kneeling with weapon unsupported, phase 3 from standing with weapon unsupported, phase 4 from standing while advancing towards the target at walking pace.<br />"
			+ "<br />"
			+"Phases 1 to 3 consist of a semi-random set of 10 exposures. 2 exposures at 100m, 3 exposures at 200m, 3 exposures at 300m and 2 exposures at 400m.<br />"
			+ "<br />"
			+"Phase 4 consists of a single CQM exposure at 100m.<br />"
			+ "<br />"
			+"A short sounding of the loudspeaker indicates the transition between phases, participants should adjust their stance and reload their weapon.<br />"
			+ "<br />"
			+"During phases 2 and 3 (kneeling and standing), participants should have their weapon lowered at all times. When a target appears, participants should aim down the sights of the weapon, acquire the target, engage the target with a single 1 round shot and lower their weapon.<br />"
			+ "<br />"
			+"During phase 4 (CQB), participants should aim down their alternative short-range sight (red dot) if available, advance towards the target at walking pace and engage the target with 10x single round shots in rapid succession.<br />"
			+ "<br />"
			+"A long sounding of the loudspeaker indicates the end of the exercise. Participants should cease fire immediately and make safe their weapon.<br />"
			+ "<br />"
			+"NOTE: Difficulty of the CQB exposure can be increased by increasing the speed of the advance and/or switching to fully automatic fire."
		]
	];
	player createDiaryRecord [
		"RR_Drills",
		[
			"ACTM (Rapid)",
			"<font color='#FFC300'>Drill ID:</font> ACTM (Rapid)<br />"
			+ "<br />"
			+"<font color='#FFC300'>Description:</font> Annual Combat Marksmanship Test - Rapid-Fire Module<br />"
			+ "<br />"
			+"<font color='#FFC300'>Ammunition Issued:</font> 3x 20 round magazine<br />"
			+ "<br />"
			+"<font color='#FFC300'>Number of Exposures:</font> 12<br />"
			+ "<br />"
			+"<font color='#FFC300'>Engagement:</font> 5x single round per exposure<br />"
			+ "<br />"
			+"<font color='#FFC300'>Maximum Score:</font> 60<br />"
			+ "<br />"
			+"<font color='#FFC300'>Exposure Time:</font> 10 seconds<br />"
			+ "<br />"
			+"<font color='#FFC300'>Target Interval:</font> 5 seconds<br />"
			+ "<br />"
			+"<font color='#FFC300'>Phase Transition Interval:</font> 12 seconds<br />"
			+ "<br />"
			+"<font color='#FFC300'>Instructions:</font><br />"
			+"The rapid-fire module consists of three identical phases. Phase 1 should be taken from prone with weapon supported or unsupported, phase 2 from kneeling with weapon unsupported, phase 3 from standing with weapon unsupported.<br />"
			+ "<br />"
			+"Each phase consists of a single exposure at each distance in the order: 100m, 200m, 300m, 400m.<br />"
			+ "<br />"
			+"A short sounding of the loudspeaker indicates the transition between phases, participants should adjust their stance and reload their weapon.<br />"
			+ "<br />"
			+"Participants should aim down the sights of the weapon for the duration of the exercise and engage each target with 5x 1 round shot per exposure.<br />"
			+ "<br />"
			+"A long sounding of the loudspeaker indicates the end of the exercise. Participants should cease fire immediately and make safe their weapon."
		]
	];*/
};

// initialise common server based scripts
if isServer then {
	RR_RANGE_IDS = [];
	RR_DRILLS = [] call RR_fnc_compileFiringDrills;
};

// signal init common complete
RR_INIT_COMMON_DONE = true;
