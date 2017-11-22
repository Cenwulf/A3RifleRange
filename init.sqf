enableSaving [false, false];

if isServer then {
	["ETR"] spawn RR_fnc_initRifleRange;
	["ETR2","ETR",8] spawn RR_fnc_initRifleRange;
};
