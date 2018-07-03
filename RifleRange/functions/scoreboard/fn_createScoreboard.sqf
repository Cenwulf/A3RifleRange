scriptName "fn_createScoreboard";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Called for an appropriate sign board object, applies the scoreboard background texture then creates a "UserTexture1M_F" object for each digit by calling RR_fnc_createSBDigit. Must be called on all clients.

	Parameter(s):
	_this select 0: Object - Scoreboard object
	_this select 1: String - Range ID
	_this select 2: Number - Lane index
	_this select 3: Number - Digit count (can be 1, 2, 3 or 4)

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

if !isServer exitWith {}; // NOTE: Remove if UserTextureObject_1m_F ever stops propergating over the network again

params [["_scoreboardObj",objNull,[objNull]],["_rangeID","",[""]],["_scoreboardLaneID",-1,[0]]];

waitUntil {missionNamespace getVariable [format ["%1_INIT_DONE", _rangeID],false]};

private _scoreboardDir = getDir _scoreboardObj;

private _laneCount = missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID];

private _scoreboardObjArray = [_scoreboardObj];

private _digitCount = missionNamespace getVariable format ["%1_DIGIT_COUNT", _rangeID];

_scoreboardLaneID = if (_scoreboardLaneID > _laneCount) then {-1} else {_scoreboardLaneID};

if (_scoreboardLaneID < 1 && {_laneCount / 5 > 1}) then {
	for "_i" from 1 to ((ceil (_laneCount / 5)) - 1) do {
		_obj = createVehicle ["SignAd_Sponsor_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		_obj setDir _scoreboardDir;
		_obj attachTo [_scoreboardObj, [0,0,_i]];
		_obj setVectorUp (vectorUp _scoreboardObj);
		_scoreboardObjArray pushBack _obj;
	};
};

reverse _scoreboardObjArray;

// new

// Build scoreboard coordinates
/*// x old
private _score1_x = 0.1351996444; // First digit (from righ to left) of the score column
private _score10_x = 0.01312944444; // Second digit (from righ to left) of the score column
private _score100_x = -0.10894075552; // Third digit (from righ to left) of the score column
private _highScore1_x = 0.6905574222; // First digit (from righ to left) of the high score column
private _highScore10_x = 0.5684872222; // Second digit (from righ to left) of the high score column
private _highScore100_x = 0.4464170222; // Third digit (from righ to left) of the high score column
*/
// x new
private _digitSpacing_x = 0.12;
private _scoreCentre_x = 0.07416454442;
private _highScoreCentre_x = 0.629522322;

// y
private _depth_y = -0.03; // depth

// z old
private _lane1_z = 1.120967053; // Lane 1 row hight
private _lane2_z = 0.9514512632; // Lane 2 row hight
private _lane3_z = 0.7819354737; // Lane 3 row hight
private _lane4_z = 0.6124196842; // Lane 4 row hight
private _lane5_z = 0.4429038947; // Lane 5 row hight

private _xArray = [[_scoreCentre_x],[_highScoreCentre_x]];

{
	private _xSubarray = _x;

	private _centre_x = _xSubarray select 0;

	for "_i" from 1 to (_digitCount - 1) do {
		_xSubarray pushBack (_centre_x + (_digitSpacing_x * _i));
	};

	private _total = 0;

	{
		_total = _total + _x;
	} forEach _xSubarray;

	private _average = _total / _digitCount;

	private _offset = _average - (_x select 0);

	_xSubarray = _xSubarray apply {_x - _offset};

	reverse _xSubarray;

	_xArray set [_forEachIndex,_xSubarray];

} forEach _xArray;
/*
private _xArray = switch _digitCount do {
	case 1:	{[[_score1_x],[_highScore1_x]]};
	case 2:	{[[_score1_x,_score10_x],[_highScore1_x,_highScore10_x]]};
	case 3:	{[[_score1_x,_score10_x,_score100_x],[_highScore1_x,_highScore10_x,_highScore100_x]]};
};
*/
_zArray = [_lane1_z,_lane2_z,_lane3_z,_lane4_z,_lane5_z];

_rowLabel_x1 = -0.3747496593;
_rowLabel_x2 = -0.2784876444;

_label_x1 = -0.6079999259; // First digit of single lane scoreboard lane label x coord
_label_x2 = -0.5617201111; // Second digit of single lane scoreboard lane label x coord
_label_z = 1.238609158; // Single lane scoreboard lane label z coord

// build scoreboard array
_scoreboardArray = [];

// populate scoreboard array with digit texture objects


{
	private _scoreboardObj = _x;

	_scoreboardArrayTemp = [];

	_scoreBoardObjIndex = _forEachIndex;

	for "_i" from 1 to 5 do {
		_scoreboardArrayTemp pushBack [[],[]];
	};

	{
		_zPos = _x;
		_laneIndex = _forEachIndex;
		{
			_scoreColumnIndex = _forEachIndex;
			{
				_pos = [_x,_depth_y,_zPos];
				_scoreboardDigit = [_scoreboardObj,_scoreboardDir,_pos] call RR_fnc_createSBDigit;
				_scoreboardArrayTemp select _laneIndex select _scoreColumnIndex pushBack _scoreboardDigit;
				_pos = [_x,_depth_y + 0.002,_zPos];
				_background = [_scoreboardObj,_scoreboardDir,_pos] call RR_fnc_createSBDigit;
				_background setObjectTextureGlobal [0,"rifleRange\textures\blackbox.paa"];
				if (_scoreboardLaneID < 1 && (_scoreBoardObjIndex * 5) + _laneIndex >= _laneCount) then {
					missionNamespace getVariable format ["%1_UNUSED_DIGITS_ARRAY", _rangeID] pushBack _scoreboardDigit;
				};
			} forEach _x;
		} forEach _xArray;

		// If a multilane scoreboard create lane labels for each row
		if (_scoreboardLaneID < 1) then {

			_laneNumber = (_scoreBoardObjIndex * 5) + _laneIndex + 1;

			_texArray = [_laneNumber,"Label",false] call RR_fnc_numberToTexture;

			_laneLabelArray = [
				[_scoreboardObj,_scoreboardDir,[_rowLabel_x1,_depth_y,_zPos]] call RR_fnc_createSBDigit,
				[_scoreboardObj,_scoreboardDir,[_rowLabel_x2,_depth_y,_zPos]] call RR_fnc_createSBDigit
			];

			{
				_x setObjectTextureGlobal [0,""];
			} forEach _laneLabelArray;

			{
				_laneLabelArray select _forEachIndex setObjectTextureGlobal [0,_x];
			} forEach _texArray;
		};
	} forEach _zArray;

	{
		_scoreboardArray pushBack _x;
	} forEach _scoreboardArrayTemp;

	_x setObjectTextureGlobal [0,"rifleRange\textures\board5a.paa"];
} forEach _scoreboardObjArray;

private _digitsArray = missionNamespace getVariable format ["%1_DIGITS_ARRAY",_rangeID];

if (_scoreboardLaneID < 1) then {
	_digitsArray pushBack _scoreboardArray;
} else {
	_scoreboardObj setObjectTextureGlobal [0,"rifleRange\textures\board5b.paa"];
	_digitsArray set [_scoreboardLaneID - 1, _scoreboardArray];

	// Create lane label for single lane scoreboard
	_texArray = [_scoreboardLaneID,"LabelSmall",false] call RR_fnc_numberToTexture;

	_labelDigitArray = [
		[_scoreboardObj,_scoreboardDir,[_label_x1,_depth_y,_label_z]] call RR_fnc_createSBDigit,
		[_scoreboardObj,_scoreboardDir,[_label_x2,_depth_y,_label_z]] call RR_fnc_createSBDigit
	];

	{
		_x setObjectTextureGlobal [0,""];
	} forEach _labelDigitArray;

	{
		_labelDigitArray select _forEachIndex setObjectTextureGlobal [0, _x];
	} forEach _texArray;
};

publicVariable format ["%1_DIGITS_ARRAY",_rangeID];
