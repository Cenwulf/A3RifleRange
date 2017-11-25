scriptName "fn_numberToArray";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Converts the last 2 digits of a number into an array containt each digit as a string.

	Parameter(s):
	_this select 0: Number - Number to be converted to array of strings.

	Returns:
	Array - each individual digit in the number as a string.
*/
#define SELF RR_fnc_numberToArray

private ["_number","_str","_array"];

_number = param [0,0,[0]];

_str = str _number;

_array = _str splitString "";

_array
