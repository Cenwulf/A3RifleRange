class RifleRangeFunctions {
	tag = "RR";
	class ACE3Actions {
		file = "rifleRange\functions\actions";
		class addAceActions {};
		class clearCondition {};
		class clearHighScoreAction {};
		class powerCondition {};
		class powerOffAction {};
		class powerOnAction {};
		class resetAction {};
		class resetCondition {};
		class startAction {};
		class startCondition {};
		class stopAction {};
		class stopCondition {};
		class testSpeakerAction {};
		class testSpeakerCondition {};
	};
	class Drills {
		file = "rifleRange\functions\drills";
		class runProgram {};
		class startFiringDrill {};
	};
	class Init {
		file = "rifleRange\functions\init";
		class initRifleRange {};
	};
	class Misc {
		file = "rifleRange\functions\misc";
	};
	class Scoreboard {
		file = "rifleRange\functions\scoreboard";
		class addScore {};
		class createSBDigit {};
		class createScoreboard {};
		class numberToTexture {};
		class refreshScores {};
		class setNumberTextures {};
	};
	class Sound {
		file = "rifleRange\functions\sounds";
		class playMissionSound3D {};
	};
	class Targets {
		file = "rifleRange\functions\target";
		class targetHit {};
	};
};