Private ['_difficulty','_factor','_infAssign','_minInfSpawnRatio','_minVehSpawnRatio','_poolInf','_poolVeh','_ratioInfantry','_ranArr','_ratioVehicle','_teams','_try','_vehAssign'];

_difficulty = _this select 0;

_factor = 'WFBE_TOWNRESISTANCEDIFFICULTY' Call GetNamespace;


_teams = [];
///-- START of Hard Resistance
if (_factor == 1 ) then { 
switch (_difficulty) do {
	case 'light1': {
				
		_teams = ['Group','Patrol1','Militia','ATTeam'];
		_teams = _teams + ['MotorizedGroup','LightArmor','MechanizedPatrol'];
	};
	case 'light2': {
			
		_teams = ['Group','GroupWeapons','ATTeam','Patrol2'];
		_teams = _teams + ['Technical','MechanizedPatrol','LightArmor'];
	};
	case 'medium1': {
			
		_teams = ['Group','GroupWeapons','ATTeam','GroupAssault','SniperTeam'];
		_teams = _teams + ['Technical','MechanizedPatrol','LightArmor'];
	};
	case 'medium2': {
			
		_teams = ['Group','GroupWeapons','ATTeam','GroupAssault','AATeam'];
		_teams = _teams + ['MechanizedGroup','Technical','LightArmor'];
	};
	case 'medium3': {
			
		_teams = ['Group','GroupWeapons','ATTeam','GroupAssault','SniperTeam'];
		_teams = _teams + ['MechanizedGroup','MotorizedAATeam','LightArmor'];
	};
	case 'medium4': {
			
		_teams = ['Group','GroupWeapons','ATTeam','GroupAssault','SniperTeam'];
		_teams = _teams + ['MotorizedAATeam','LightArmor','HeavyArmor'];
	};
	case 'large1': {
				
		_teams = ['GroupWeapons','ATTeam','GroupAssault','SniperTeam','AATeam','ATTeam'];
		_teams = _teams + ['MechanizedGroup','LightArmor','HeavyArmor','Technical'];
	};
	case 'large2': {
			
		_teams = ['Group','GroupWeapons','ATTeam','GroupAssault','SniperTeam','ATTeam'];
		_teams = _teams + ['MechanizedGroup','MechanizedPatrol','MotorizedAATeam','LightArmor'];
	};
	case 'huge1': {
				
		_teams = ['Group','GroupWeapons','ATTeam','GroupWeapons','AATeam','SniperTeam'];
		_teams = _teams + ['MechanizedPatrol','MotorizedAATeam','MotorizedAATeam','HeavyArmor','HeavyArmor'];
	};
	case 'huge2': {
				
		_teams = ['Group','GroupWeapons','ATTeam','ATTeam','GroupAssault','AATeam','SniperTeam'];
		_teams = _teams + ['MotorizedAATeam','MechanizedGroup','MechanizedPatrol','HeavyArmor','HeavyArmor'];
	};
	case 'central1': {
				
		_teams = ['GroupWeapons','ATTeam','GroupAssault','AATeam','SniperTeam','GroupWeapons','ATTeam','AATeam','SniperTeam'];
		_teams = _teams + ['MotorizedAATeam','HeavyArmor','CentralArmor'];
	};
	case 'central2': {
				
		_teams = ['GroupWeapons','ATTeam','GroupAssault','AATeam','SniperTeam','ATTeam','GroupAssault','AATeam','SniperTeam'];
		_teams = _teams + ['MotorizedAATeam','HeavyArmor','CentralArmor'];
	};
};
}; ///-- END of Default Resistance

///-- START of NORMAL Resistance
if (_factor == 2 ) then { 
switch (_difficulty) do {
	case 'light1': {
				
		_teams = ['Group','Patrol1','ATTeam','SniperTeam','ATTeam'];
		_teams = _teams + ['MechanizedGroup','MotorizedAATeam'];
	};
	case 'light2': {
			
		_teams = ['Group','ATTeam','Patrol2','SniperTeam','ATTeam'];
		_teams = _teams + ['LightArmor','MechanizedPatrol'];
	};
	case 'medium1': {
			
		_teams = ['Group','ATTeam','GroupAssault','SniperTeam','SniperTeam','ATTeam'];
		_teams = _teams + ['Technical','LightArmor'];
	};
	case 'medium2': {
			
		_teams = ['Group','GroupWeapons','ATTeam','AATeam','SniperTeam','ATTeam'];
		_teams = _teams + ['LightArmor','MotorizedAATeam'];
	};
	case 'medium3': {
			
		_teams = ['Group','ATTeam','GroupAssault','SniperTeam','SniperTeam','ATTeam'];
		_teams = _teams + ['LightArmor','MotorizedAATeam'];
	};
	case 'medium4': {
			
		_teams = ['Group','ATTeam','GroupAssault','SniperTeam','SniperTeam','ATTeam'];
		_teams = _teams + ['LightArmor','MotorizedAATeam'];
	};
	case 'large1': {
				
		_teams = ['Group','ATTeam','GroupAssault','SniperTeam','AATeam','SniperTeam','ATTeam'];
		_teams = _teams + ['LightArmor','MotorizedAATeam','HeavyArmor'];
	};
	case 'large2': {
			
		_teams = ['Group','GroupWeapons','ATTeam','GroupAssault','SniperTeam','ATTeam'];
		_teams = _teams + ['LightArmor','MotorizedAATeam','HeavyArmor'];
	};
	case 'huge1': {
				
		_teams = ['GroupAssault','GroupWeapons','ATTeam','AATeam','SniperTeam','ATTeam'];
		_teams = _teams + ['MechanizedPatrol','MotorizedAATeam','HeavyArmor'];
	};
	case 'huge2': {
				
		_teams = ['GroupWeapons','ATTeam','GroupAssault','AATeam','SniperTeam','ATTeam'];
		_teams = _teams + ['MotorizedAATeam','LightArmor'];
	};
	case 'central1': {
				
		_teams = ['GroupWeapons','GroupAssault','AATeam','SniperTeam','GroupWeapons','SniperTeam'];
		_teams = _teams + ['HeavyArmor','CentralArmor','LightArmor'];
	};
	case 'central2': {
				
		_teams = ['GroupWeapons','GroupAssault','AATeam','SniperTeam','AATeam','SniperTeam'];
		_teams = _teams + ['CentralArmor','HeavyArmor','LightArmor'];
	};
};
}; ///-- END of NORMAL Resistance

///-- START of LITE Resistance
if (_factor == 3 ) then { 
switch (_difficulty) do {
	case 'light1': {
				
		_teams = ['Group','Patrol1'];
		_teams = _teams + ['Technical'];
	};
	case 'light2': {
			
		_teams = ['Group','Patrol2'];
		_teams = _teams + ['MechanizedGroup'];
	};
	case 'medium1': {
			
		_teams = ['Group','ATTeam','SniperTeam'];
		_teams = _teams + ['MechanizedPatrol'];
	};
	case 'medium2': {
			
		_teams = ['Group','GroupWeapons','ATTeam'];
		_teams = _teams + ['MotorizedAATeam'];
	};
	case 'medium3': {
			
		_teams = ['Group','ATTeam','GroupAssault'];
		_teams = _teams + ['LightArmor'];
	};
	case 'medium4': {
			
		_teams = ['Group','GroupAssault','SniperTeam'];
		_teams = _teams + ['HeavyArmor'];
	};
	case 'large1': {
				
		_teams = ['GroupWeapons','ATTeam','GroupAssault','AATeam'];
		_teams = _teams + ['LightArmor'];
	};
	case 'large2': {
			
		_teams = ['GroupWeapons','ATTeam','GroupAssault','SniperTeam'];
		_teams = _teams + ['HeavyArmor'];
	};
	case 'huge1': {
				
		_teams = ['GroupWeapons','ATTeam','AATeam','SniperTeam'];
		_teams = _teams + ['MechanizedPatrol','HeavyArmor'];
	};
	case 'huge2': {
				
		_teams = ['ATTeam','GroupAssault','AATeam','SniperTeam'];
		_teams = _teams + ['MotorizedAATeam','HeavyArmor'];
	};
	case 'central1': {
				
		_teams = ['GroupAssault','GroupWeapons','ATTeam','AATeam','SniperTeam'];
		_teams = _teams + ['MotorizedAATeam','HeavyArmor','CentralArmor'];
	};
	case 'central2': {
				
		_teams = ['GroupWeapons','ATTeam','GroupAssault','AATeam','SniperTeam'];
		_teams = _teams + ['MotorizedAATeam','HeavyArmor','CentralArmor'];
	};
};
}; ///-- END of LITE Resistance

if (count _teams < 1) then {_teams = ['Group','Patrol1','AATeam','ATTeam','LightArmor']};

_teams