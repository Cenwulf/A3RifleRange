scriptName "fn_addDrillInstructions";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Add a diary subject specific to the range ID passed as an argument and then adds diary records to that subject detailing each of the drills available in that range's <RANGEID>_DRILLS array.

	Parameter(s):
	_this select 0: String	- A unique subject ID string used for the createDiarySubject command.
	_this select 1: Array	- Nested array passed from initRifleRange used to build drill instruction diary records.
	_this select 2: String	- (Optional) Range display name used for map marker and diary records.
	_this select 3: String	- (Optional) Description of the range intended to be used in the diary record.
	_this select 4: String	- (Optional) Path to image file to be used for range specific diary subject.
	_this select 5: String	- (Optional) Map marker name for the range, used to identify an existing marker and link it to the diary record.

	Returns:
	Nothing
*/
#define SELF RR_fnc_addDrillInstructions

waitUntil {!isNull player};

params [["_subject","DrillInstructions",[""]],["_compiledInstructions",[],[[]]],["_displayName","Firing Drills",[""]],["_rangeDescription","No data available.",[""]],["_imageRange","",[""]],["_markerName",[""],[""]]];

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

reverse _diaryRecords; // diary records are added in reverse order above so the _diaryRecords array must first be reversed to get it back in correct order

{
	_text = [_text, "<br />", createDiaryLink _x] joinString "";
} forEach _diaryRecords;

player createDiaryRecord [_subject,[_displayName,_text]];
