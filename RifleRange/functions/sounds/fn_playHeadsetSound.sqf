scriptName "fn_playHeadsetSound:";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Checks to see if player is connected to the rifle range and if they are wearing wireless reciever, if they are then it plays the sound passed as an argument.

	Parameter(s):
	_this select 0: String - Range ID
	_this select 1: String - Sound name defined in CfgSounds

	Returns:
	Nothing
*/
#define SELF RR_fnc_playHeadsetSound

params [["_rangeID","",[""]],["_sound","",[""]]];

if !hasInterface exitWith {};

private _playerItems = [headgear player, goggles player];

if (player getVariable ["RR_connectedRange",""] == _rangeID && {count (RR_HEADSET_CLASSES arrayIntersect _playerItems) > 0}) then {
	playSound _sound;
};
