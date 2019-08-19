scriptName "fn_addDrillInstructions";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Add a diary subject specific to the range ID passed as an argument and then adds diary records to that subject detailing each of the drills available in that range's <RANGEID>_DRILLS array.

	Parameter(s):
	_this select 0: String	- Unique Range ID used to identify the range and all its components, passed to all subsequent functions.
	_this select 1: Array	- (Optional) Drill types, array of strings defining the type of drills that can be run on this range, can be anything but must have at least 1 firing drill defined in fn_compileFiringDrill.sqf that has a matching drill type. Default = ["ETR"].
	_this select 2: Number	- (Optional) Number of lanes on range. Default = 5.
	_this select 3: Number	- (Optional) Number digits on scoreboard (e.g. 1 results in a max displayable score of 9, 2 is 99 and 3 is 999). Default = 2.
	_this select 4: String	- (Optional) Range display name used for map marker and diary records.
	_this select 5: String	- (Optional) Description of the range intended to be used in the diary record.
	_this select 6: String	- (Optional) Path to image file to be used for range specific diary subject.
	_this select 7: Bool	- (Optional) Defines whether a map marker should be placed for the range marker is placed over the range control object.
	_this select 8: Array	- Marker position 2d or 3d.
	_this select 9: String	- (Optional) Marker type see CfgMarkers (https://community.bistudio.com/wiki/cfgMarkers).
	_this select 10: String	- (Optional) Marker colour see CfgMarkerColors (https://community.bistudio.com/wiki/CfgMarkerColors_Arma_3). Does not need to be defined will take colour side from marker type by default.

	Returns:
	Nothing
*/
#define SELF RR_fnc_addDrillInstructions

params [["_subject","DrillInstructions",[""]],["_displayName","Firing Drills",[""]],["_rangeDescription","No data available.",[""]],["_imageRange","",[""]],["_compiledInstructions",["No data available."],[[]]],["_markerName",[""],[""]]];

player createDiarySubject [_subject,_displayName,_imageRange];

// add all diary records to an array so they can be used to add links in the main range discription diary record
private _diaryRecords = [];

// add diary records
{
	_x params ["_subject","_details"];
	_details params ["_drillName","_instructions"];
	private _record = player createDiaryRecord _x;
	_diaryRecords pushBack [_subject,_record,_drillName];
} forEach _compiledInstructions;

// finally add the range description with link to marker if added and add links for availbe drill instruction diary records
private _text = ["<font size='18'><marker name='", _markerName, "'>", _displayName, "</marker></font><br /><br />", _rangeDescription, "<br /><br />Available firing drills:"] joinString "";

reverse _diaryRecords; // diary records are added in revers order above so the _diary record array must first be reversed to get it back in correct order

{
	_text = [_text, "<br />", createDiaryLink _x] joinString "";
} forEach _diaryRecords;

[player,[_subject,[_displayName,_text]]] remoteExecCall ["createDiaryRecord",0,true];
