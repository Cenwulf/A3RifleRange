scriptName "fn_initCommon";
/*
	Author: Alasdair Scott [16AA] <http://16aa.net/>

	Description:
	Initialise all common global variables used by all rifle ranges in the mission, such as the drill programs.

	Parameter(s):
	None

	Returns:
	Nothing
*/
#define SELF RR_fnc_initCommon

// initialise client side common scripts and variables
if !isDedicated then {
	RR_HEADSET_CLASSES = [
		"G_WirelessEarpiece_F",
		"H_WirelessEarpiece_F",
		"H_Cap_oli_hs",
		"H_Cap_headphones",
		"H_Cap_marshal",
		"H_Bandanna_khk_hs",
		"H_Booniehat_khk_hs",
		"H_Watchcap_blk",
		"H_Watchcap_khk",
		"H_Watchcap_camo",
		"H_Watchcap_cbr",
		"H_Shemag_olive_hs",
		"H_MilCap_blue",
		"H_MilCap_gen_F",
		"H_MilCap_ghex_F",
		"H_MilCap_gry",
		"H_MilCap_ocamo",
		"H_MilCap_mcamo",
		"H_MilCap_tna_F",
		"H_MilCap_dgtl",
		"H_HeadSet_black_F",
		"H_HeadSet_orange_F",
		"H_HeadSet_red_F",
		"H_HeadSet_white_F",
		"H_HeadSet_yellow_F",
		"16aa_Helmet_Hivis_Yellow"
	];
	[] call RR_fnc_addRangeManual;
};

// initialise common server based scripts and variables
if isServer then {
	RR_RANGE_IDS = [];
	RR_DRILLS = [] call RR_fnc_compileFiringDrills;
};

// signal init common complete
RR_INIT_COMMON_DONE = true;
