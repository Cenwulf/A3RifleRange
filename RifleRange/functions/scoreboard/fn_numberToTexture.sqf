scriptName "fn_numberToTexture";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Converts a number into an array containing textures paths that when applied to a set of "UserTexture1m_F" objects will display the number.

	Parameter(s):
	_this select 0: Number - Number to be representied in world space as two textures.
	_this select 1: String - Texture prefix that is used to diferentiate different styles of number textures in the textures folder
	_this select 2: Bool - Switch whether or not the number textures should be reversed

	Returns:
	Array - Array of strings refering to the paths of the textures for the all digits of passed number.
*/
#define SELF RR_fnc_numberToTexture

params [["_number",0,[0]],["_texPrefix","",[""]],["_reverse",true,[true]]];

private ["_str","_array","_count", "_digitCount"];

_array = switch _number do {
	case -1: {["dash"]};
	case -2: {["blank"]};
	default {[_number] call RR_fnc_numberToArray};
};

if _reverse then {
	reverse _array;
};

_count = count _array;

_digitCount = missionNamespace getVariable [format ["%1_DIGIT_COUNT", _rangeID], 1];

if (_texPrefix == "" && {_digitCount > _count}) then { // fill up remaining digits with blanks (or dashes if dashes are being used)
	private _texFiller = if (_number == -1) then {"dash"} else {"blank"};
	for "_i" from 1 to (_digitCount - _count) do {
		_array pushback _texFiller;
	};
};

{
	_array set [_forEachIndex, format ["rifleRange\textures\%1%2.paa", _texPrefix, _array select _forEachIndex]];
} forEach _array;

_array
