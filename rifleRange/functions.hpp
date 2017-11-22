class RifleRangeFunctions {
	tag = "RR";
	class ACE3Actions {
		file = "rifleRange\functions\actions";
		class addAceActions {};
		class addActions {};
		class clearCondition {};
		class clearHighScoreAction {};
		class connectHeadsetAction {};
		class connectHeadsetCondition {};
		//class disconnectHeadsetAction {};
		class disconnectHeadsetCondition {};
		class drillSelectAction {};
		class muteSpeakerAction {};
		class muteSpeakerCondition {};
		class powerCondition {};
		class powerOffAction {};
		class powerOnAction {};
		class resetAction {};
		class resetCondition {};
		class speakerSettingsCondition {};
		class speakerSettingsMutedCondition {};
		class setDelayAction {};
		class setDelayCondition {};
		class startAction {};
		class startCondition {};
		class stopAction {};
		class stopCondition {};
		class testSpeakerAction {};
		class testSpeakerCondition {};
		class unmuteSpeakerAction {};
		class unmuteSpeakerCondition {};
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
		class numberToArray {};
		class setWhiteboardTexture {};
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
		class playHeadsetSound {};
		class playMissionSound3D {};
	};
	class Targets {
		file = "rifleRange\functions\target";
		class targetHit {};
	};
};
