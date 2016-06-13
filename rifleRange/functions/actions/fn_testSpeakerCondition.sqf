params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_laneIndecies",[],[[]]]];

(missionNamespace getVariable [format ["%1_POWER_ON", _rangeID],false] && !(isNil format ["%1_loudspeaker",_rangeID]))