createFiringPosition
createControlPoint
[_pos,_centralObject or _dir,_initCode] call fn_createComposition

Lane -
0	pos or modelpos
1	dir or logic/obj
_pos = _logic modelToWorl _modelPos
[_pos,_dir] call RR_fnc_createFiringPosition
[_pos,_dir] call RR_fnc_createFiringPosition
[_pos,_dir] call RR_fnc_createFiringPosition
[_pos,_dir,_distance] call RR_fnc_createTarget

synchronizedObjects _logic



//

create central object

list objects aray

call create composition on objects array




for "_i" from 1 to _laneCount do {
	missionNamespace getVariable format ["%1_TARGETS_BY_LANE",_rangeID] pushBack [];
	missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] pushBack [[],[],[]]
	for "_j" from 0 to 2 do {
		switch _j do {
			case 0: {
				for "_k" from 0 to 99 do {
					if (isNil format ["%1_l%2_c_%3", _rangeID, _i, _k]) exitWith {};
					_targ = missionNamespace getVariable format ["%1_l%2_c_%3", _rangeID, _i, _k];
					missionNamespace getVariable format ["%1_ALL_TARGETS",_rangeID] pushBack _targ;
					missionNamespace getVariable format ["%1_TARGETS_BY_LANE",_rangeID] select _i pushBack _targ;
					missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _i select _j pushBack _targ;
					_targ addEventHandler ["hit", {_this call RR_fnc_targetHit;}];
					_targ setVariable ["hitNumber",0];
					_targ setObjectTextureGlobal [0,"rifleRange\textures\figure11.paa"];
				};
			};
			case 1: {
				for "_k" from 0 to 99 do {
					if (isNil format ["%1_l%2_m_%3", _rangeID, _i, _k]) exitWith {};
					missionNamespace getVariable format ["%1_ALL_TARGETS",_rangeID] pushBack _targ;
					missionNamespace getVariable format ["%1_TARGETS_BY_LANE",_rangeID] select _i pushBack _targ;
					missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _i select _j pushBack _targ;
					_targ addEventHandler ["hit", {_this call RR_fnc_targetHit;}];
					_targ setVariable ["hitNumber",0];
					_targ setObjectTextureGlobal [0,"rifleRange\textures\figure11.paa"];
				};
			};
			case 2: {
				for "_k" from 0 to 99 do {
					if (isNil format ["%1_l%2_f_%3", _rangeID, _i, _k]) exitWith {};
					missionNamespace getVariable format ["%1_ALL_TARGETS",_rangeID] pushBack _targ;
					missionNamespace getVariable format ["%1_TARGETS_BY_LANE",_rangeID] select _i pushBack _targ;
					missionNamespace getVariable format ["%1_TARGETS_BY_LANE_AND_DIST",_rangeID] select _i select _j pushBack _targ;
					_targ addEventHandler ["hit", {_this call RR_fnc_targetHit;}];
					_targ setVariable ["hitNumber",0];
					_targ setObjectTextureGlobal [0,"rifleRange\textures\figure11.paa"];
				};
			};
		};
	};
};
