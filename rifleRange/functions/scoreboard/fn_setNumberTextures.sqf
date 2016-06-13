params [["_rangeID","",[""]],["_laneIndex",0,[0]],["_scoreColumn",0,[0]],["_texArray",[],[[]]]];

for "_i" from 0 to 1 do {
	missionNamespace getVariable format ["%1_DIGITS_ARRAY", _rangeID] select _laneIndex select _scoreColumn select _i setObjectTextureGlobal [0,_texArray select _i];
};