enableSaving [false, false];

// initialise common variable for rifle range script
[] spawn RR_fnc_initCommon;

// initialise each preplaced rifle range in the mission
// [<RangeID>,<DrillTypes>,<NumberOfLanes>,<NumberOfDigits>,<DisplayName>,<Description>,<RangeImage>,<Marker>,<MarkerPos>,<MarkerType>,<MarkerColour>] spawn RR_fnc_initRifleRange
["ETR",nil,nil,nil,"Almyra Salt Flats ETR",nil,nil,true,getMarkerPos "ETR_Marker_1"] spawn RR_fnc_initRifleRange;
["ETR2",["LMG","ETR"],8,3,"AAC Airfield LMG ETR","An 8 lane electric target range (ETR) with targets placed at 100, 200, 300 and 400 meters. Three firing positions per lane are placed at 50, 100 and 200 meters distance from the first row of targets. Each set of targets consists of figure 11s standing three abreast that can be operated independently or as one. This range is suitable for a wide array of weapon systems and drills including light machineguns, medium machineguns, assault rifles and marksman rifles.",nil,true,getMarkerPos "ETR_Marker_0"] spawn RR_fnc_initRifleRange;
