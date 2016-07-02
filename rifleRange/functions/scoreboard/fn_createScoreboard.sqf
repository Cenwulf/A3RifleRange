scriptName "fn_createScoreboard";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Called for an appropriate sign board object, applies the scoreboard background texture then creates a "UserTexture1M_F" object for each digit by calling RR_fnc_createSBDigit.

	Parameter(s):
	_this select 0: Object - Scoreboard object

	Returns:
	Nothing

	NOTES: Unique ranges are created by passing a unique string with all functions called. This string is the RangeID. To ascociate targets with a particular range they should be named in the following format:
	rangeID_laneID_distanceID

	rangeID can be any string as long as it is executed consitantly (see below)
	laneID must be in the format lN (eg l1, l2, l3, etc)

	The init script should be called as follows from the init.sqf in mission folder:
	[rangeID] call RR_fnc_initRifleRange

	The scorboard (if you want one) should be called as follow from the init field of the scorboard object in the editor or from init.sqf (NOT BOTH):
	[<SCORBOARD_OBJECT>,rangeID] call RR_fnc_createScoreBoard

	The fn_addAceActions.sqf should be called as follow from the init field of the scorboard object in the editor or from init.sqf (NOT BOTH):
	[<CONTROL_OBJECT>,rangeID] call RR_fnc_addAceActions
*/
#define SELF RR_fnc_createScoreboard

if !isServer exitWith {};

params [["_scoreboardObj",objNull,[objNull]],["_rangeID","",[""]]];

private "_scoreboardDir";

_scoreboardDir = getDir _scoreboardObj;

_scoreboardObj setObjectTextureGlobal [0,"rifleRange\textures\board5A.paa"];

// old

_score1_x = 0.196289;
_score10_x = 0.0742188;
_highScore1_x = 0.7460932;
_highScore10_x = 0.624023;

_depth_y = -0.034;

_lane1_z = 1.158946;
_lane2_z = 0.982946;
_lane3_z = 0.806946;
_lane4_z = 0.630946;
_lane5_z = 0.454946;

_l1Score1_relPos =		[_score1_x,			_depth_y,	_lane1_z];
_l1Score10_relPos =		[_score10_x,		_depth_y,	_lane1_z];
_l1HighScore1_relPos =	[_highScore1_x,		_depth_y,	_lane1_z];
_l1HighScore10_relPos =	[_highScore10_x,	_depth_y,	_lane1_z];

_l2Score1_relPos =		[_score1_x,			_depth_y,	_lane2_z];
_l2Score10_relPos =		[_score10_x,		_depth_y,	_lane2_z];
_l2HighScore1_relPos =	[_highScore1_x,		_depth_y,	_lane2_z];
_l2HighScore10_relPos =	[_highScore10_x,	_depth_y,	_lane2_z];

_l3Score1_relPos =		[_score1_x,			_depth_y,	_lane3_z];
_l3Score10_relPos =		[_score10_x,		_depth_y,	_lane3_z];
_l3HighScore1_relPos =	[_highScore1_x,		_depth_y,	_lane3_z];
_l3HighScore10_relPos =	[_highScore10_x,	_depth_y,	_lane3_z];

_l4Score1_relPos =		[_score1_x,			_depth_y,	_lane4_z];
_l4Score10_relPos =		[_score10_x,		_depth_y,	_lane4_z];
_l4HighScore1_relPos =	[_highScore1_x,		_depth_y,	_lane4_z];
_l4HighScore10_relPos =	[_highScore10_x,	_depth_y,	_lane4_z];

_l5Score1_relPos =		[_score1_x,			_depth_y,	_lane5_z];
_l5Score10_relPos =		[_score10_x,		_depth_y,	_lane5_z];
_l5HighScore1_relPos =	[_highScore1_x,		_depth_y,	_lane5_z];
_l5HighScore10_relPos =	[_highScore10_x,	_depth_y,	_lane5_z];

_l1Score1 = [_scoreboardObj,_scoreboardDir,_l1Score1_relPos] call RR_fnc_createSBDigit;
_l1Score10 = [_scoreboardObj,_scoreboardDir,_l1Score10_relPos] call RR_fnc_createSBDigit;
_l1HighScore1 = [_scoreboardObj,_scoreboardDir,_l1HighScore1_relPos] call RR_fnc_createSBDigit;
_l1HighScore10 = [_scoreboardObj,_scoreboardDir,_l1HighScore10_relPos] call RR_fnc_createSBDigit;
_l2Score1 = [_scoreboardObj,_scoreboardDir,_l2Score1_relPos] call RR_fnc_createSBDigit;
_l2Score10 = [_scoreboardObj,_scoreboardDir,_l2Score10_relPos] call RR_fnc_createSBDigit;
_l2HighScore1 = [_scoreboardObj,_scoreboardDir,_l2HighScore1_relPos] call RR_fnc_createSBDigit;
_l2HighScore10 = [_scoreboardObj,_scoreboardDir,_l2HighScore10_relPos] call RR_fnc_createSBDigit;
_l3Score1 = [_scoreboardObj,_scoreboardDir,_l3Score1_relPos] call RR_fnc_createSBDigit;
_l3Score10 = [_scoreboardObj,_scoreboardDir,_l3Score10_relPos] call RR_fnc_createSBDigit;
_l3HighScore1 = [_scoreboardObj,_scoreboardDir,_l3HighScore1_relPos] call RR_fnc_createSBDigit;
_l3HighScore10 = [_scoreboardObj,_scoreboardDir,_l3HighScore10_relPos] call RR_fnc_createSBDigit;
_l4Score1 = [_scoreboardObj,_scoreboardDir,_l4Score1_relPos] call RR_fnc_createSBDigit;
_l4Score10 = [_scoreboardObj,_scoreboardDir,_l4Score10_relPos] call RR_fnc_createSBDigit;
_l4HighScore1 = [_scoreboardObj,_scoreboardDir,_l4HighScore1_relPos] call RR_fnc_createSBDigit;
_l4HighScore10 = [_scoreboardObj,_scoreboardDir,_l4HighScore10_relPos] call RR_fnc_createSBDigit;
_l5Score1 = [_scoreboardObj,_scoreboardDir,_l5Score1_relPos] call RR_fnc_createSBDigit;
_l5Score10 = [_scoreboardObj,_scoreboardDir,_l5Score10_relPos] call RR_fnc_createSBDigit;
_l5HighScore1 = [_scoreboardObj,_scoreboardDir,_l5HighScore1_relPos] call RR_fnc_createSBDigit;
_l5HighScore10 = [_scoreboardObj,_scoreboardDir,_l5HighScore10_relPos] call RR_fnc_createSBDigit;

waitUntil {missionNamespace getVariable [format ["%1_INIT_DONE", _rangeID],false]};

missionNamespace setVariable [format ["%1_DIGITS_ARRAY",_rangeID], [[[_l1Score1,_l1Score10],[_l1HighScore1,_l1HighScore10]],[[_l2Score1,_l2Score10],[_l2HighScore1,_l2HighScore10]],[[_l3Score1,_l3Score10],[_l3HighScore1,_l3HighScore10]],[[_l4Score1,_l4Score10],[_l4HighScore1,_l4HighScore10]],[[_l5Score1,_l5Score10],[_l5HighScore1,_l5HighScore10]]]]; // placeholder until dynamic scoreboard creation is up and running

publicVariable format ["%1_DIGITS_ARRAY",_rangeID];

// TODO1: Enable dynamic placement of between 1 and 5 lanes by selectively disabling lanes on scoreboard (make a number of different textures for taped over scoreboad digits).
// TODO2: Dynamic placement of scoreboard rows to allow for flexibility in number of lanes.