if (!isServer || time > 30) exitWith {};

while {true} do {
	sleep 3;
	_serverFPS = round(diag_fps);
	WF_Logic setVariable ["serverFPS",_serverFPS,true];
};
