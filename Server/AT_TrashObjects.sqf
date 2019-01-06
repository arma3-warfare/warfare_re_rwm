while {true} do {
_UsedAT = WF_Logic getVariable "UsedAT";
{
		deleteVehicle _x; 
		_UsedAT2 = (WF_Logic getVariable "UsedAT") - [_x] - [objNull];
		WF_Logic setVariable ["UsedAT",_UsedAT2,true];
	
} forEach _UsedAT;
    uiSleep 5;
};