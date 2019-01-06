waitUntil {!isNil 'commonInitComplete'};
waitUntil {!isNil 'clientInitComplete'};
//buildingMarker = 0;

if (local player) then {
	Private["_allies","_color","_hq","_marker","_structure","_text","_type","_side","_voteTime"];
	
	_structure = _this Select 0;
	_hq = _this select 1;
	_side = _this select 2;
	_allies = if (count _this > 3) then {_this select 3} else {""};

	if (_side != side player) exitWith {};
	
	sleep random(3);
	
	while {_voteTime = WF_Logic getVariable "eastCommanderVoteTime";IsNil "_voteTime"} do {sleep 1};

	_marker = Format["BaseMarker%1",buildingMarker];
	buildingMarker = buildingMarker + 1;
	createMarkerLocal [_marker,getPos _structure];
	_type = "mil_box";
	if (sideJoined == west) then {_color = "ColorBlue"} else {_color = "ColorRed"};
	if (_hq) then {
	_type = "n_hq";
	_markerHQ = "HQundeployed";
	deleteMarkerLocal _markerHQ;
	};

	if (_allies != "") then {_type = "mil_box";_color = "ColorGreen"};
	_marker setMarkerTypeLocal _type;
	_text = "";
	if (!_hq && _allies == "") then {_text = [_structure] Call GetStructureMarkerLabel;_marker setMarkerSizeLocal [0.6,0.6]};
	if (_allies != "") then {_marker setMarkerSizeLocal [0.5,0.5];_text = _allies};
	if (_text != "") then {_marker setMarkerTextLocal _text};
	if (_hq) then {_marker setMarkerTextLocal "HQ"};
	_marker setMarkerColorLocal _color;

	while {!isNull _structure && alive _structure} do {sleep 2};

	deleteMarkerLocal _marker;
};