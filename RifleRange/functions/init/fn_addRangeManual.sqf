scriptName "fn_addRangeManual";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Adds diary records covering in game operation of the range using the range control object (usually a laptop)

	Parameter(s):
	None

	Returns:
	Nothing
*/
#define SELF RR_fnc_addRangeManual

waitUntil {!isNull player};

player createDiarySubject ["RR_RifleRangeManual","Rifle Range Manual"];

// diary records appear in reverse order so create the last record first this also allows the first record to link to all subsequent records
private _recordText5 = [
	"<font size='18'>5. Start Delay</font>",
	"<br />",
	"<br />",
	"A start delay can be set to allow users to operate the rifle range without the assistance of a range master. It is also recommended that the user utilise the audio receiver functionality or loudspeaker when operating without a range master."
] joinString "";

RR_DIARYRECORD_5 = player createDiaryRecord ["RR_RifleRangeManual",["5. Start Delay",_recordText5]];

private _recordText4 = [
	"<font size='18'>4. Speaker Settings</font>",
	"<br />",
	"<br />",
	"This section documents the commands and functionality of the loudspeaker and headset audio alerts.<br />",
	"<br />",
	"The loudspeaker serves as a warning system to alert nearby personnel and drill participants of status of the firing exercise. A short sounding of the loudspeaker indicates the start of an exercise or the transitioning between phases of an in-progress exercise. A long sounding of the loudspeaker indicates the end of a drill, all participants are to cease fire immediately and make safe their weapons.<br />",
	"<br />",
	"In circumstances where it is not practical to have the loudspeaker sound (e.g. when multiple rifle ranges are in close proximity but being operated independently), range instructors and marshals have the option to connect a headset receiver in order to receive personal audio cues regarding the status of a firing exercise. Two short pips followed by a long pip indicates the start of an exercise. A short pip indicates the transitioning between phases of an in-progress exercise. A single long pip indicates the end of an exercise, all participants should be instructed to cease fire immediately and make safe their weapons.<br />",
	"<br />",
	"The commands available in the category are:<br />",
	"<font color='#FFC300'>Test Loudspeaker (Long)</font> - Test loudspeaker functionality with a long sounding of the loudspeaker.<br />",
	"<font color='#FFC300'>Test Loudspeaker (Short)</font> - Test loudspeaker functionality with a short sounding of the loudspeaker.<br />",
	"<font color='#FFC300'>Connect Receiver</font> - If the user is wearing an appropriate audio receiver such as a Bluetooth earpiece or a range master's headset, the device can be connected to the range computer. The user will then receive audio status cues through the receiver.<br />",
	"<font color='#FFC300'>Disconnect Receiver</font> - Disconnect the user's current headset receiver from the range computer.<br />",
	"<font color='#FFC300'>Mute Loudspeaker</font> - Prevent all sounding of the loudspeaker under any circumstances.<br />",
	"<font color='#FFC300'>Unmute Loudspeaker</font> - Unmutes the loudspeaker.",
	"<br/>",
	"<br/>",
	"<font color='#ff0000'>WARNING: ENSURE ALL PERSONNEL COMPLY WITH LOCAL HEALTH AND SAFETY REGULATIONS AND HAVE COMPLETED A RANGE INDUCTION COURSE BEFORE PARTICIPATING IN A FIRING EXERCISE. THE LOUDSPEAKER ALERT FUNCTIONALITY SHOULD ONLY BE DISABLE WITH EXPRESS PERMISSION FROM THE LOCAL AUTHORITY.</font>"
] joinString "";

RR_DIARYRECORD_4 = player createDiaryRecord ["RR_RifleRangeManual",["4. Speaker Settings",_recordText4]];

private _recordText3 = [
	"<font size='18'>3. Drill Select</font>",
	"<br />",
	"<br />",
	"All available drills are displayed in a list, the currently selected drill is indicated by a checked box. To switch between them, simply select the desired drill using the mouse cursor."
] joinString "";

RR_DIARYRECORD_3 = player createDiaryRecord ["RR_RifleRangeManual",["3. Drill Select",_recordText3]];

private _recordText2 = [
	"<font size='18'>2. Drill Control</font>",
	"<br />",
	"<br />",
	"This section documents the commands available for controlling a drill sequence.<br />",
	"<br />",
	"The full list of controls for this category are as follows:<br />",
	"<font color='#FFC300'>Start</font> - Initiate the currently selected drill (see section ", createDiaryLink ["RR_RifleRangeManual", RR_DIARYRECORD_3, "4. Drill Select"], "). After the currently selected start delay has elapsed (see section ", createDiaryLink ["RR_RifleRangeManual", RR_DIARYRECORD_5, "5. Start Delay"], ") target exposures will commence prompted by a short sounding of the loudspeaker or a count in over a connected headset receiver (see section ", createDiaryLink ["RR_RifleRangeManual", RR_DIARYRECORD_5, "4. Speaker Settings"], "). Target exposures will proceed in the sequenced defined within the program. The loudspeaker will sound at predefined points within the sequence to signal participants to switch positions if required by the drill. Once all targets exposures have been completed the drill will end prompted by a long sounding of the loudspeaker.<br />",
	"<font color='#FFC300'>Pause</font> - Pause the current drill in progress. Target exposures will not continue until the drill has been started again. Once the Start command is selected target exposures will continue from the point the sequence was paused.<br />",
	"<font color='#FFC300'>Stop</font> - The drill will immediately terminate prompted by a long sounding of the loudspeaker.<br />",
	"<font color='#FFC300'>Reset</font> - Target positions will be reset and scores displayed for the previous drill will be cleared.<br />",
	"<font color='#FFC300'>Reset High Scores</font> - Clear high scores. All high scores from previous drills will be cleared. This does not have any effect on the current score of a drill in progress.<br />",
	"<br />",
	"NOTE: These commands are context sensitive and, as such, are not always available."
] joinString "";

RR_DIARYRECORD_2 = player createDiaryRecord ["RR_RifleRangeManual",["2. Drill Control",_recordText2]];

private _recordText1 = [
	"<font size='18'>1. Introduction</font>",
	"<br />",
	"<br />",
	"All functions of this Electric Target Range (ETR) are controlled from the range computer located at the rear observation point. Start by booting the computer to initiate the range start up sequence.<br />",
	"When in the off state all targets will be in the upright position, once the start-up sequence is complete all targets will be lowered.<br />",
	"<br />",
	"NOTE: Any targets left standing after the range start up sequence is completed will indicate a coding error with the range, contact the range administrators office to have this resolved.<br />",
	"<br />",
	"The range computer functions are separated into a number of categories. These categories are:<br />",
	createDiaryLink ["RR_RifleRangeManual", RR_DIARYRECORD_2, "Drill Control"], " - Initiating and stopping a firing drill, resetting targets and scores, etc.<br />",
	createDiaryLink ["RR_RifleRangeManual", RR_DIARYRECORD_3, "Drill Select"], " - Selection of a drill from the list of available firing dirlls<br />",
	createDiaryLink ["RR_RifleRangeManual", RR_DIARYRECORD_4, "Speaker Settings"], " - Testing and control of the loudspeaker and headset reciever<br />",
	createDiaryLink ["RR_RifleRangeManual", RR_DIARYRECORD_5, "Start Delay"], " - Setting of a delayed start for solo operation of the range"
] joinString "";

RR_DIARYRECORD_1 = player createDiaryRecord ["RR_RifleRangeManual",["1. Introduction",_recordText1]];

publicVariable "RR_DIARYRECORD_1";

RR_RANGE_MANUAL_TEXT = [_recordText1,_recordText2,_recordText3,_recordText4,_recordText5] joinString "<br /><br />";
