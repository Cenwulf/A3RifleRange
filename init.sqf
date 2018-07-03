enableSaving [false, false];

// initialise common variable for rifle range script
[] spawn RR_fnc_initCommon;

// initialise each preplaced rifle range in the mission
// [<RangeID>,<DrillTypes>(Optional),<NumberOfLanes>(Optional),<DisplayName>(Optional),<Description>(Optional),<RangeImage>(Optional),<Marker>(Optional),<MarkerPos>,<MarkerType>(Optional),<MarkerColour>(Optional)] spawn RR_fnc_initRifleRange
["ETR",nil,nil,nil,"Almyra Salt Flats ETR",nil,nil,true,getMarkerPos "ETR_Marker_1"] spawn RR_fnc_initRifleRange;
["ETR2",["LMG","ETR"],8,3,"AAC Airfield LMG ETR","An 8 lane electric target range (ETR) with targets placed at 100, 200, 300 and 400 meters. Three firing positions placed at 50, 100 and 200 meters distance from the first row of targets. Each set of targets consists of three fig. 11 that can be operated independantly or as one. This range is suitable for a wide array of weapon systems and drills including machineguns, infantry rifles and marksman rifles.",nil,true,getMarkerPos "ETR_Marker_0"] spawn RR_fnc_initRifleRange;
