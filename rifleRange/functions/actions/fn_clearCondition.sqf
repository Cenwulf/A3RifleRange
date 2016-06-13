params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

_laneIndecies params [["_laneIndex",0,[0]]];

!(missionNamespace getVariable format ["%1_SCORES_ARRAY",_rangeID] select _laneIndex select 3 == -1)