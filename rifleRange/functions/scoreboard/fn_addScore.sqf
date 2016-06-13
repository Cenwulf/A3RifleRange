params [["_rangeID","",[""]],["_laneIndex",0,[0]],["_score",0,[0]]];

missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex set [0,(missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select 0) + _score];
if (missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select 0 > missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select 1) then {
	missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex set [1,missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select 0];
};

[_rangeID,_laneIndex] call RR_fnc_refreshScores;