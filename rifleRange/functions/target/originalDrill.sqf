private ["_easy", "_med", "_hard", "_prog","_allTargets","_count","_targ","_targnum","_ticktock","_timer"];
private ["set1","set2","set3","set4","set5","set6","set7","set8","set9","set10","set11","set12","set13","set14","set15","set16","set17","set18","set19","set20"];

//Define Target Groups
	set1 = [L1_C1,L1_C2,L1_M1,L1_M2,L1_L1]; set2 = [L1_C1,L1_C3,L1_M1,L1_M3,L1_L2];
	set3 = [L1_C2,L1_C3,L1_M1,L1_M3,L1_L3]; set4 = [L1_C1,L1_C2,L1_M2,L1_M4,L1_L3];
	set5 = [L1_C1,L1_C3,L1_M2,L1_M3,L1_L1]; set6 = [L1_C2,L1_C3,L1_M3,L1_M4,L1_L3];
	set7 = [L1_C1,L1_M1,L1_M2,L1_M3,L1_L1]; set8 = [L1_C2,L1_M1,L1_M3,L1_M4,L1_L2];
	set9 = [L1_C3,L1_M1,L1_M2,L1_M4,L1_L3]; set10 = [L1_C1,L1_M2,L1_M3,L1_M4,L1_L2];
	set11 = [L1_C1,L1_M1,L1_M2,L1_M3,L1_L1]; set12 = [L1_C2,L1_M1,L1_M3,L1_M4,L1_L2];
	set13 = [L1_C3,L1_M2,L1_M3,L1_M4,L1_L3]; set14 = [L1_M1,L1_M2,L1_M3,L1_L1,L1_L2];
	set15 = [L1_M1,L1_M3,L1_M4,L1_L1,L1_L3]; set16 = [L1_M2,L1_M3,L1_M4,L1_L2,L1_L3];
	set17 = [L1_M1,L1_M2,L1_M4,L1_L1,L1_L2]; set18 = [L1_M1,L1_M3,L1_L1,L1_L2,L1_L3];
	set19 = [L1_M2,L1_M3,L1_L1,L1_L2,L1_L3]; set20 = [L1_M1,L1_M2,L1_L1,L1_L2,L1_L3];

	_easy = [set1,set2,set3,set4,set5,set6];
	_med = [set7,set8,set9,set10,set11,set12,set13];
	_hard = [set14,set15,set16,set17,set18,set19,set20];

	_allTargets = [L1_C1,L1_C2,L1_C3,L1_M1,L1_M2,L1_M3,L1_M4,L1_L1,L1_L2,L1_L3];

//Define Key Variables for Test
	_timer = 5;
	_count = 1;
	_ticktock = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
	_targ = [];
	_targnum = 0;
	_prog = [];
	LaneLogic_1 setVariable ["LaneScore1",0,true];

//Construct test target set and drop all targets in lane
	_prog = _prog + (_easy call BIS_fnc_selectRandom);
	_prog = _prog + (_easy call BIS_fnc_selectRandom);
	_prog = _prog + (_med call BIS_fnc_selectRandom);
	_prog = _prog + (_med call BIS_fnc_selectRandom);
	_prog = _prog + (_hard call BIS_fnc_selectRandom);
	_prog = _prog + (_hard call BIS_fnc_selectRandom);

	{_x animate ["terc",1]} forEach _allTargets;


//Execute Test
	sleep 5;

	hint "Command Recruit to WATCH AND SHOOT";
	sleep 3;
	hint "Test begins in...";
	Sleep 3;

	while {_timer > 0} do {
		hint format ["%1...",_timer];
		_timer = _timer - 1;
		sleep 1;
	};

	hint "TEST BEGUN";
	sleep 10;

	while {_count < 31} do {

		_targnum = _ticktock call BIS_fnc_selectRandom;
		_ticktock = _ticktock - [_targnum];
		_targ = _prog select _targnum;

		hint format ["Target %1 of 30",_count];
		_count = _count + 1;

		_targ animate ["terc",0];
		sleep 2;
		_targ animate ["terc",1];
		sleep 5;
		sleep random 5;

	};

	hint "Test Complete";
	sleep 10;
	{_x animate ["terc",0]} forEach _allTargets;