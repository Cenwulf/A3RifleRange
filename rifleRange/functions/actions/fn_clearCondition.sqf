scriptName "fn_clearCondition";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Not for general use, simply created to simplify the writing and duplication of similar actions in RR_fnc_addAceActions.

	Parameter(s):
	_this select 0: Object - Object the action was attached to.
	_this select 1: Object - Player object who performed the action.
	_this select 2: Array - Custom params passed through ACE action.
		_this select 2 select 0: String - Unique Range ID, generated when creating rifle range and passed to all subsequent functions.
		_this select 2 select 1: Array - Array of numbers referring to each lane to be modified by function.

	Returns:
	Bool - True when condition passes, false if not.
*/
#define SELF RR_fnc_clearCondition

params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

private _condtion = false;

private _laneCount = missionNamespace getVariable format ["%1_LANE_COUNT", _rangeID];

private _missionPath = [str missionConfigFile, 0, -15] call BIS_fnc_trimString;

private _texturePath = _missionPath + "rifleRange\textures\dash.paa";

{
	_scoreBaordTemp = _x;
	if (_forEachIndex >= _laneCount) then {
		{
			if (getObjectTextures (_scoreBaordTemp select _x select 1 select 0) select 0 != _texturePath) exitWith {
				_condtion = true;
			};
		} forEach _laneIndecies;
	};
} forEach (missionNamespace getVariable [format ["%1_DIGITS_ARRAY",_rangeID],[]]);

_condtion
