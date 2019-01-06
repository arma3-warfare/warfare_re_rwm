//*****************************************************************************************
//Description: Creates a small construction site.
//*****************************************************************************************
Private ["_construct","_constructed","_direction","_group","_index","_nearLogic","_objects","_position","_rlType","_side","_site","_siteName","_startTime","_structures","_structuresNames","_time","_timeNextUpdate","_type"];
_type = _this select 0;
_side = _this select 1;
_position = _this select 2;
_direction = _this select 3;
_index = _this select 4;

_time = ((Format ["WFBE_%1STRUCTURETIMES",str _side] Call GetNamespace) select _index) / 2;
	
_siteName = Format["WFBE_%1CONSTRUCTIONSITE",str _side] Call GetNamespace;

_structures = Format ['WFBE_%1STRUCTURES',str _side] Call GetNamespace;
_structuresNames = Format ['WFBE_%1STRUCTURENAMES',str _side] Call GetNamespace;
_rlType = _structures select (_structuresNames find _type);

_startTime = time;
_timeNextUpdate = _startTime + _time;

_objects = [];
_objects = [[_siteName,[0,0,-0.000230789],359.997,1,0],["Land_Bricks_V3_F",[0.416992,-5.62012,-0.305746],0.0130822,1,0],["Land_BarrelSand_grey_F",[-5.59448,3.26929,6.29425e-005],359.997,1,0],["Land_Pallet_F",[-2.62976,-6.04736,5.53131e-005],0.0130822,1,0],["Land_MetalBarrel_empty_F",[6.63696,0.694336,0.000753403],359.991,1,0],["Land_WorkStand_F",[6.41797,-2.52051,0.000915527],270,1,0],["Land_BarrelSand_grey_F",[-6.73267,2.06372,6.10352e-005],359.997,1,0],["MetalBarrel_burning_F",[7.19604,2.8855,0.00028801],0.0135841,1,0],["Land_MetalBarrel_F",[6.08984,5.5415,0.00028801],0.0135841,1,0],["Land_BarrelSand_grey_F",[-7.13452,4.40747,6.29425e-005],359.997,1,0],["RoadBarrier_F",[0.221924,-8.58496,0.00206566],0.0130822,1,0],["Land_BarrelSand_grey_F",[-8.27271,2.80054,6.10352e-005],359.997,1,0],["Land_WoodenCrate_01_stack_x5_F",[-7.91895,-4.09668,0.00037384],0.0128253,1,0],["Land_Bricks_V1_F",[6.40332,-7.16162,0.000520706],0.0130822,1,0],["Land_Bricks_V1_F",[-6.18384,-8.09961,0.000535965],50.0093,1,0],["RoadCone_F",[-10.4381,-8.94336,0.000131607],0.0119093,1,0],["RoadCone_F",[11.1655,-8.79932,0.00034523],359.991,1,0],["RoadCone_F",[-10.5692,12.6655,0.000509262],359.948,1,0],["RoadCone_F",[11.0276,12.3904,0.000509262],359.948,1,0]];
_construct = Compile PreprocessFile "Server\Functions\Server_ObjectMapper.sqf";
_constructed = ([_position,_direction,_objects] Call _construct);

//--- Create the logic.
(createGroup sideLogic) createUnit ["LocationOutpost_F",_position,[],0,"NONE"];

_nearLogic = objNull;
if !(paramUseWorkers) then {
	//--- Grab the logic.
	_nearLogic = _position nearEntities [["LocationOutpost_F"],15];
	if (count _nearLogic > 0) then {_nearLogic = ([_position, _nearLogic] Call SortByDistance) select 0} else {_nearLogic = objNull};
	
	if (isNull _nearLogic) exitWith {};
	
	//--- Position the logic.
	_nearLogic setPos _position;
	
	_nearLogic setVariable ["WFBE_B_Type", _rlType];

	waitUntil {time >= _timeNextUpdate};
	_timeNextUpdate = _startTime + _time * 2;
} else {
	//--- Grab the logic.
	_nearLogic = _position nearEntities [["LocationOutpost_F"],15];
	if (count _nearLogic > 0) then {_nearLogic = ([_position, _nearLogic] Call SortByDistance) select 0} else {_nearLogic = objNull};
	
	if (isNull _nearLogic) exitWith {};
	
	//--- Position the logic.
	_nearLogic setPos _position;
	
	//--- Instanciate the logic.
	_nearLogic setVariable ["WFBE_B_Completion", 0];
	_nearLogic setVariable ["WFBE_B_CompletionRatio", 1.1];
	_nearLogic setVariable ["WFBE_B_Direction", _direction];
	_nearLogic setVariable ["WFBE_B_Position", _position];
	_nearLogic setVariable ["WFBE_B_Repair", false];
	_nearLogic setVariable ["WFBE_B_Type", _rlType];
	
	//--- Add the logic to the list.
	[Format ["WFBE_WORKERS_%1LOGIC",str _side],((Format ["WFBE_WORKERS_%1LOGIC",str _side]) Call GetNamespace) + [_nearLogic],true] Call SetNamespace;
	
	//--- Awaits for 50% of completion.
	while {true} do {
		sleep 1;
		if ((_nearLogic getVariable "WFBE_B_Completion") >= 50) exitWith {};
	};
};

_objects = [["Land_Obstacle_Ramp_F",[-2.45703,-0.593262,0.357508],270,1,0],["Land_Obstacle_Ramp_F",[-2.5083,1.3811,0.357508],270,1,0],[_siteName,[4.6333,0.338135,0.00393867],90,1,0],["Land_Excavator_01_wreck_F",[-0.587891,8.57935,0.00207901],359.967,1,0],["Land_Bulldozer_01_wreck_F",[-3.97363,-8.49219,-4.57764e-005],29.9804,1,0],["Land_Obstacle_Ramp_F",[8.8335,-0.125977,0.403545],90,1,0]];
_constructed = _constructed + ([_position,_direction,_objects] Call _construct);

if !(paramUseWorkers) then {
	waitUntil {time >= _timeNextUpdate};
	
	if !(isNull _nearLogic) then {
		_group = group _nearLogic;
		deleteVehicle _nearLogic;
		deleteGroup _group;
	};
} else {
	//--- Awaits for 100%
	while {true} do {
		sleep 1;
		if ((_nearLogic getVariable "WFBE_B_Completion") >= 100) exitWith {};
	};
	
	//--- Remove the logic from the list since it's built. Add it back if destroyed.
	[Format ["WFBE_WORKERS_%1LOGIC",str _side],((Format ["WFBE_WORKERS_%1LOGIC",str _side]) Call GetNamespace) - [_nearLogic],true] Call SetNamespace;
};
	
{if !(isNull _x) then {DeleteVehicle _x}} ForEach _constructed;

_site = _type CreateVehicle _position;
_site SetDir _direction;
_site SetPos _position;

["Constructed",_type,_side] Spawn SideMessage;

  
	
_flag = if (_side == east) then {"rhs_Flag_Russia_F"} else {"Flag_US_F"};;
_cargo = "Misc_cargo_cont_net3";
_flagPole = _flag CreateVehicle [(getPos _site select 0)-1,(getPos _site select 1)-1,0];
//WF_Logic setVariable [Format["%1SPFlag",str _side],_flagPole];

_cargocrate = _cargo CreateVehicle [(getPos _site select 0)+5,(getPos _site select 1)+5,0];
//_flagpole addEventHandler ['handleDamage',{[_this select 0, _this select 2] Call HandleBuildingDamage}];
//_power addEventHandler ['handleDamage',{[_this select 0, _this select 2] Call HandleBuildingDamage}];

//_power SetDir _direction;
	//WF_Logic setVariable [Format["%1HQFlag",str _side],_flagPole];

if (!IsNull _site) then {
	Call Compile Format ["%1BaseStructures = %1BaseStructures + [_site]; publicVariable '%1BaseStructures';",str _side];

	//ok _site SetVehicleInit Format["[this,false,%1] ExecVM 'Client\Init\Init_BaseStructure.sqf'",_side];
	[[[_site,false,_side], "Client\Init\Init_BaseStructure.sqf"], "BIS_fnc_execVM", true, true] call BIS_fnc_MP;
	//ProcessInitCommands;

	_site addEventHandler ["hit",{_this Spawn BuildingDamaged}];
	if (paramHandleFF) then {
		Call Compile Format ["_site addEventHandler ['handleDamage',{[_this select 0,_this select 2,_this select 3, %1] Call BuildingHandleDamages}]",_side];
	} else {
		_site addEventHandler ['handleDamage',{[_this select 0, _this select 2] Call HandleBuildingDamage}];
	};
	Call Compile Format ["_site AddEventHandler ['killed',{[_this select 0,_this select 1,%1,'%2'] Spawn BuildingKilled}];",_side,_type];
	_site addEventHandler ["Killed",{_this select 0 Spawn TrashObject}];
	_cargocrate addEventHandler ["Killed",{_this select 0 Spawn TrashObject}];
	_flagPole addEventHandler ["Killed",{_this select 0 Spawn TrashObject}];
	
	diag_log Format["[WFRE (INFORMATION)][frameno:%3 | ticktime:%4] Construction_SmallSite: A %1 %2 has been constructed",str _side,_type,diag_frameno,diag_tickTime];
};

//--- Base Patrols.
if ((_type == WESTBAR || _type == EASTBAR) && paramBasePatrols) then {
	[_site, _side] ExecFSM 'Server\FSM\basepatrol.fsm';
	diag_log Format["[WFRE (INFORMATION)][frameno:%2 | ticktime:%3] Construction_SmallSite: A %1 Base Patrol Module has been launched",str _side,diag_frameno,diag_tickTime];
};

	//_get = WF_Logic getVariable Format["%1SPFlag",str _side];
	//if (!isNil '_get') then {deleteVehicle _get};
