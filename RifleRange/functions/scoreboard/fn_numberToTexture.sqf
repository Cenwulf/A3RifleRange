scriptName "fn_numberToTexture";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Converts the last 2 digits of a number into an array containt textures when applied to a set of two "UserTexture1m_F" objects will display the passed number.

	Parameter(s):
	_this select 0: Number - Number to be representied in world space as two textures.

	Returns:
	Array - of no more than two strings refering to the paths of the textures for the first 2 digits of passed number.
*/
#define SELF RR_fnc_numberToTexture

params [["_number",0,[0]],["_texPrefix","",[""]],["_reverse",true,[true]]];

private ["_str","_array","_count"];

_array = switch _number do {
	case -1: {["dash","dash"]};
	case -2: {["blank","blank"]};
	default {[_number] call RR_fnc_numberToArray};
};

if _reverse then {
	reverse _array;
};

_count = count _array;

if (_count > 2) then{
	_array resize 2;
};

if (_count == 1 && {_texPrefix == ""}) then {
	_array pushback "blank";
};

{
	_array set [_forEachIndex, format ["rifleRange\textures\%1%2.paa", _texPrefix, _array select _forEachIndex]];
} forEach _array;

_array
