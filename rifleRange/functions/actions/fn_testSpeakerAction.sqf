params [["_obj",objNull,[objNull]],["_actor",objNull,[objNull]],["_customParams",[],[[]]]];

_customParams params [["_rangeID","",[""]],["_soundPath","",[""]]];

[_soundPath,missionNamespace getVariable format ["%1_loudspeaker",_rangeID],false,missionNamespace getVariable format ["%1_loudspeaker",_rangeID] modelToWorld [0,0.00390625,3.96981]] call RR_fnc_playMissionSound3D;