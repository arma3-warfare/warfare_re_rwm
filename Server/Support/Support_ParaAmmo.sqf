Private['_args','_bd','_cargo','_grp','_pilot','_playerTeam','_positionCoord','_ran','_ranDir','_ranPos','_side','_timeStart','_vehicle','_vehicleCoord'];

_args = _this;
_side = _args select 1;

_playerTeam = (_args select 3);
diag_log Format["[WFRE (INFORMATION)][frameno:%4 | ticktime:%5] Server_HandleSpecial: The %1 %2 Team (Leader: %3) has called an Ammunition Paradroping",str _side,_playerTeam,name (leader _playerTeam),diag_frameno,diag_tickTime];
_ranPos = [];
_ranDir = [];

_bdfull = 'WFBE_BOUNDARIESXY' Call GetNamespace;
_bd = ( _bdfull / 2.5 );

if !(isNil '_bd') then {
	_ranPos = [
		[0+random(80),0+random(80),400+random(80)],
		[0+random(80),_bd-random(80),400+random(80)],
		[_bd-random(80),_bd-random(80),400+random(80)],
		[_bd-random(80),0+random(80),400+random(80)]
	];
	_ranDir = [45,145,225,315];
} else {
	_ranPos = [[0+random(80),0+random(80),400+random(80)],[12000+random(80),0+random(80),400+random(80)]];
	_ranDir = [45,315];
};

_timeStart = time;
_ran = round(random((count _ranPos)-1));
_grp = createGroup _side;
_vehicle = createVehicle [Format ["WFBE_%1PARAVEHI",str _side] Call GetNamespace,(_ranPos select _ran), [], (_ranDir select _ran), "FLY"];
_vehicle setCaptive true;
_pilot = [Format ["WFBE_%1PILOT",str _side] Call GetNamespace,_grp,[100,12000,0],_side] Call CreateMan;
[str _side,'VehiclesCreated',1] Call UpdateStatistics;
[str _side,'UnitsCreated',1] Call UpdateStatistics;
_pilot moveInDriver _vehicle;
_pilot setCaptive true;
_grp setBehaviour 'CARELESS';
_grp setCombatMode 'STEALTH';
_pilot disableAI 'AUTOTARGET';
_pilot disableAI 'TARGET';
[_grp,(_args select 2),"MOVE",10] Call AIMoveTo;
Call Compile Format ["_vehicle addEventHandler ['Killed',{[_this select 0,_this select 1,%1] Spawn UnitKilled}]",_side];
[[[_vehicle,_side], "Common\Common_InitUnit.sqf"], "BIS_fnc_execVM", true, true] call BIS_fnc_MP;
//ok _vehicle setVehicleInit Format["[this,%1] ExecVM 'Common\Common_InitUnit.sqf';",_side];
//ProcessInitCommands;
_vehicle flyInHeight (200 + random(20));
_cargo = (crew _vehicle) - [driver _vehicle, gunner _vehicle, commander _vehicle];

while {true} do {
	uiSleep 1;
	if (!alive _pilot || !alive _vehicle || isNull _vehicle || isNull _pilot) exitWith {};
	if (!(isPlayer (leader _playerTeam)) || time - _timeStart > 500) exitWith {{_x setDammage 1} forEach (_cargo+[_pilot,_vehicle]);deleteGroup _grp};
	_vehicleCoord = [getPos _pilot select 0,getpos _pilot select 1];
	_positionCoord = [(_args select 2) select 0,(_args select 2) select 1];
	if (_vehicleCoord distance _positionCoord < 100) exitWith {};
};

[_vehicle,_side] Spawn {
	Private ['_ammo','_ammos','_chopper','_chute','_side'];
	_chopper = _this select 0;
	_side = _this select 1;
	
	_ammos = Format["WFBE_%1PARAAMMO",_side] Call GetNamespace;
	if (typeName _ammos != 'ARRAY') exitWith {diag_log Format["[WFRE (INFORMATION)] Server_HandleSpecial: Expected array, given %1 for ammunitions.",typeName _ammos]};
	{
		_chopper flyInHeight 400;
		_ammo = _x createVehicle [0,0,0];
		sleep 3;
		[_chopper,_ammo,_side] Spawn {
			Private ['_ammo','_chopper','_chute','_pos','_side','_type'];
			_chopper = _this select 0;
			_ammo = _this select 1;
			_side = _this select 2;
			_chute = createVehicle [(Format['WFBE_%1PARACHUTE',str _side] Call GetNamespace), position _chopper, [], 0, "FLY"];
//			_chute setPos [getPos _chopper select 0, getPos _chopper select 1, (getPos _chopper select 2) - 40];
			_chute setDir (getDir _chopper);

			_ammo attachTo [_chute,[0,0,-1.3]];
			waitUntil {getPos _ammo select 2 < 3};
			detach _ammo;

			Call Compile Format ["_ammo addEventHandler ['Killed',{[_this select 0,_this select 1,%1] Spawn UnitKilled}]",_side];
			sleep 5;
			deleteVehicle _chute;
		};
	} forEach _ammos;
};

[_grp,(_ranPos select _ran),"MOVE",10] Call AIMoveTo;

while {true} do {
	uiSleep 1;
	if (!alive _pilot || !alive _vehicle || isNull _vehicle || isNull _pilot) exitWith {};
	_vehicleCoord = [getPos _pilot select 0,getpos _pilot select 1];
	_positionCoord = [(_ranPos select _ran) select 0,(_ranPos select _ran) select 1];
	if (_vehicleCoord distance _positionCoord < 200) exitWith {};
};

deleteVehicle _pilot;
deleteVehicle _vehicle;
deleteGroup _grp;