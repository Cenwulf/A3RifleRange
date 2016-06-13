params [["_scoreboardObj",objNull,[objNull]],["_scoreboardDir",0,[0]],["_pos",[0,0,0],[[]],[3]]];

private "_obj";

_obj = createVehicle ["UserTexture1m_F", [0,0,0], [], 0, "NONE"];
_obj setDir _scoreboardDir;
_obj attachTo [_scoreboardObj,_pos];
_obj setObjectTextureGlobal [0,"rifleRange\textures\blank.paa"];

_obj

// TODO: Dynamic digit creation, probably handle via new function in which case this one can be left as is.