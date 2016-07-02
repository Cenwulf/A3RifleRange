scriptName "fn_numberToTexture";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Converts the last 2 digits of a number into an array containt textures when applied to a set of two "UserTexture1m_F" objects will display the passed number.

	Parameter(s):
	_this select 0: Number - Number to be representied in world space as two textures.

	Returns:
	Array - Two strings refering to the paths of the texstures
*/
#define SELF RR_fnc_numberToTexture

private ["_number","_str","_array","_count"];

_number = param [0,0,[0]];

_str = str (_number);

_array = _str splitString "";

if (_number == -1) then {
	_array = ["dash","dash"];
};

if (_number == -2) then {
	_array = ["blank","blank"];
};

_count = (count _array) - 1;

for "_n" from 0 to _count do {
	_array set [_n, format ["rifleRange\textures\%1.paa",_array select _n]];
};

reverse _array;

if (_count == 0) then {
	_array pushBack "rifleRange\textures\blank.paa";
};

_array