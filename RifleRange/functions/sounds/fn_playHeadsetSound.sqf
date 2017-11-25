scriptName "fn_playHeadsetSound:";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Checks to see if player is wearing wireless reciever, if they are then it plays the sound passed with the function.

	Parameter(s):
	_this: String - Sound name defined in CfgSounds

	Returns:
	Nothing
*/
#define SELF RR_fnc_playHeadsetSound

params [["_rangeID","",[""]],["_sound","",[""]]];

if !hasInterface exitWith {};

if (player getVariable ["RR_connectedRange",""] == _rangeID && {missionNamespace getVariable [format ["%1_CONTROL_OBJ",_rangeID],objNull] distance player < 500 && {goggles player == "G_WirelessEarpiece_F" || headgear player == "H_WirelessEarpiece_F" || headgear player == "H_Cap_oli_hs" || headgear player == "H_Cap_headphones"}}) then {
	playSound _sound;
};
// TODO: Move headset enable classnames to a separate list in initRifleRange function