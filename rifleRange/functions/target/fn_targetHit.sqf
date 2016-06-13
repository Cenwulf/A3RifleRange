params [["_targ",objNull,[objNull]],["_shooter",objNull,[objNull]],["_damage",0,[0]]];

_targ setDamage 0;

if (_targ getVariable ["isActive",false]) then {

	_targ setVariable ["hitNumber",(_targ getVariable ["hitNumber",0]) + 1];

	if (_targ getVariable ["isScoring",false]) then {

		_targVarName = vehicleVarName _targ;

		_varNameArray = _targVarName splitString "_";

		_rangeID = _varNameArray select 0;

		_laneIDArray = (_varNameArray select 1) splitString "";

		_laneNumb = parseNumber (_laneIDArray select 1);

		_laneIndex = _laneNumb - 1;

		if (missionNamespace getVariable format ["%1_STATES_ARRAY", _rangeID] select _laneIndex select 0) then {
			[_rangeID,_laneIndex,1] call RR_fnc_addScore;
		};
	};
};