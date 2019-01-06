_tent = _this select 0;
_side = _this select 1;

waitUntil {!isNil 'commonInitComplete'};
sleep 1;

if (isNull _tent) exitWith {};
if !(local player) exitWith {};
if (_side != side player) exitWith {};

sleep 0.5;

if (_side == sideJoined) then {

//start marker
	if (isNil "markerIDR") then {markerIDR = 1};

	_markerVar = name player;
	_markerName = Format ["RMash%1n%2",_markerVar,markerIDR];
	createMarkerLocal [_markerName, getpos _tent];
		
	_uptime = Call GetTime; 	 	

	_markerName setMarkerText "MASH";
	_markerName setMarkerTypeLocal "loc_Hospital";
	_markerName setMarkerColorLocal "ColorYellow";
		
	_markerName setMarkerSizeLocal [0.7,0.7];
	markerIDR = markerIDR + 1;
//end marker add

waitUntil { sleep 1; !alive _tent };

deleteMarkerLocal _markerName;
};