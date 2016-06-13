params [["_rangeID","",[""]],["_laneIndex",0,[0]],["_updateScore",true,[true]],["_updateHighScore",false,[true]]];

if (_updateScore && {missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 0 != missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 2}) then {
	_textureArray = missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 0 call RR_fnc_numberToTexture;
	[_rangeID,_laneIndex,0,_textureArray] call RR_fnc_setNumberTextures;
	missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex set [2,missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 0];
};

if (_updateHighScore && {missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 1 != missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 3}) then {
	_textureArray = missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 1 call RR_fnc_numberToTexture;
	[_rangeID,_laneIndex,1,_textureArray] call RR_fnc_setNumberTextures;
	missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex set [3,missionNamespace getVariable format ["%1_SCORES_ARRAY", _rangeID] select _laneIndex select 1];
};