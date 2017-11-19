scriptName "fn_setWhiteboardTexture";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Sets the whiteboard texture to match the passed drillID.

	Parameter(s):
	_this select 0: String - Unique Range ID, first defined when creating a rifle range with RR_fnc_iniRifleRange and passed to all subsequent functions.
	_this select 1: String - ID of firing drill to be used to set texture.

	Returns:
	Nothing
*/
#define SELF RR_fnc_setWhiteboardTexture

params [["_rangeID","",[""]],["_drillID","",[""]]];

private ["_texture"];

_texture = switch (_drillID) do
{
	case "ETR_default";
	case "ETR_classic":	{"rifleRange\Textures\Whiteboard_ETR_default.paa"};
	case "ETR_ironsights":	{"rifleRange\Textures\Whiteboard_ETR_ironsights.paa"};
	default	{"a3\structures_f\civ\infoboards\data\mapboard_default_co.paa"};
};

if (!isNull (missionNamespace getVariable [format ["%1_WHITEBOARD_OBJECT", _rangeID],objNull])) then {
	missionNamespace getVariable [format ["%1_WHITEBOARD_OBJECT", _rangeID],objNull] setObjectTextureGlobal [0,_texture];
};
