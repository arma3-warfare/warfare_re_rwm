disableSerialization;

_display = _this select 0;
displayUpgrade = "";

Warfare_MenuAction = -1;
mouseX = -1;
mouseY = -1;

_requiredFunds = 0;
_requiredSupply = 0;

_tooltip = _display DisplayCtrl 18998;
_tooltip_text = _display DisplayCtrl 18999;

_controls = [];
_u = 18001;
_curIDC = _display DisplayCtrl _u;
while {!isNull _curIDC} do {_controls = _controls + [_curIDC];_u = _u + 1;_curIDC = _display DisplayCtrl _u};

_level = 0;
_val = 0;
_time = 0;
_name = '';
_tooltip_text_content = '';
_canUpgrade = false;
_dependent = false;
_isUpgrading = false;
_lastTimerUpdate = -5;
_upgr = 'WFBE_UPGRADELABELS' Call GetNamespace;
_upgrlev = 'WFBE_UPGRADELEVELS' Call GetNamespace;
_upgrdep = 'WFBE_UPGRADEDEPENDENCIES' Call GetNamespace;
_upgrcond = 'WFBE_UPGRADECONDITION' Call GetNamespace;
_upgrdesc = 'WFBE_UPGRADEDESCRIPTION' Call GetNamespace; //---added MrNiceGuy


while {alive player && dialog} do {
	if (Side player != sideJoined) exitWith {closeDialog 0};
	if !(dialog) exitWith {};
	
	_upgrades = (sideJoinedText) Call GetSideUpgrades;
	
	if (time - _lastTimerUpdate > 1) then {_lastTimerUpdate = time;_isUpgrading = Call Compile Format ["WFBE_%1_Upgrading",sideJoinedText]};
	
	_u = 0;
	{
		_level = _upgrades select _u;
		_maxLevel = _upgrlev select _u;
		_dependencie = _upgrdep select _u;
		_condition = _upgrcond select _u;
		//if (_level == _maxLevel) then {_x ctrlSetTextColor [0, 0.75, 0.25, 1]};
		switch (_level) do {
			case 0: {_x ctrlSetTextColor [0.99, 0.99, 0.99, 0.6];};
			case 1: {_x ctrlSetTextColor [0.96, 0.93, 0.0, 0.9];};
			case 2: {_x ctrlSetTextColor [0.55, 0.75, 0.0, 0.9];};
			case 3: {_x ctrlSetTextColor [0, 0.78, 0.10, 1];};
			default {};
			
		};
		if (!_condition) then {_x ctrlSetTextColor [1, 0, 0, 1]};
		/*if (count _dependencie > 0 && _level != _maxLevel && _condition) then {
			if (_upgrades select (_dependencie select 0) < (_dependencie select 1)) then {
				_x ctrlSetTextColor [1, 0, 0, 1];
			} else {
				if (_level != _maxLevel) then {
					_x ctrlSetTextColor [0.75,0.75,0.75,1];
				};
			};
		};*/
		_u = _u + 1;
	} forEach _controls;
	
	//--- Tooltips.
	if (displayUpgrade != "") then {
		
		switch (displayUpgrade) do {
			case "infantry": {_val = 0};
			case "light": {_val = 1};
			case "heavy": {_val = 2};
			case "air": {_val = 3};
			//case "parachutist": {_val = 4};
			//case "uav": {_val = 5};
			//case "supply": {_val = 6};
			//case "ambuSpawn": {_val = 7};
			//case "airlift": {_val = 8};
			//case "flares": {_val = 9};
			//case "artillery": {_val = 10};
			//case "icbm": {_val = 5};
			//case "fasttravel": {_val = 6};
			//case "gear": {_val = 13};
			//case "ammo": {_val = 14};
			//case "easa": {_val = 15};
			//case "paradrop": {_val = 16};
			//case "shells": {_val = 17};
		};

		ctrlSetFocus (_controls select _val);
		
		_dependencie = _upgrdep select _val;
		_condition = _upgrcond select _val;
		_maxLevel = _upgrlev select _val;
		_name = _upgr select _val;
		_level = _upgrades select _val;
		_desc = _upgrdesc select _val; //---added MrNiceGuy

		
		_enabled = true;
		if (!_condition) then {_enabled = false};
		if (count _dependencie > 0 && _enabled) then {
			if (_upgrades select (_dependencie select 0) < (_dependencie select 1)) then {
				_dependent = true;
			} else {_dependent = false};
		} else {_dependent = false};
		
		_bpath = if (_level == _maxLevel) then {_level} else {_level + 1};
		_time = (Format["WFBE_UPGRADETIMESLEVEL%1",_bpath] Call GetNamespace) select _val;
		_needed = (Format["WFBE_UPGRADEPRICESLEVEL%1",_bpath] Call GetNamespace) select _val;
		_requiredSupply = _needed select 0;
		_requiredFunds = _needed select 1;

		_currentSupply = (sideJoined) Call GetSideSupply;
		_currentFunds = Call GetPlayerfunds;
		
		_colorSupply = "'#ff9900'";
		_colorFunds = "'#90ee90'";
		_hasFunds = true;
		if !(paramMoneyOnly) then {if (_currentSupply < _requiredSupply) then {_colorSupply = "'#ff0033'";_hasFunds = false}};
		if (_currentFunds < _requiredFunds) then {_colorFunds = "'#ff0033'";_hasFunds = false};
		
		if (!_isUpgrading && _level < _maxLevel && !_dependent && _enabled && _hasFunds) then {_canUpgrade = true} else {_canUpgrade = false};
		
		_tooltip_w = 0.30;
		_tooltip_h = 0.50;
		_tooltip_x = if ((1 - mouseX) < _tooltip_w) then {mouseX - _tooltip_w - 0.02} else {mouseX + 0.02};
		_tooltip_y = if (mouseY > 0.5) then {mouseY - _tooltip_h - 0.02} else {mouseY + 0.02};
		
		if (_level != _maxLevel) then {
			_supplyCd = if !(paramMoneyOnly) then {Format ["<t size='0.8' color='#bfbfbf' font='PuristaMedium'>%1</t><br />",Format [localize 'STR_WF_UPGRADE_Cost',"<t color=" + _colorSupply + ">" + str(_requiredSupply) + '</t>' + '/' + "<t color='#ff9900'>" + str(_currentSupply) + '</t> S']]} else {""};
			_tooltip_text_content = parsetext (
				Format ["<t size='1.2' color='#338dcc' shadow='0'>%1:</t><br />",_name] +
				Format ["<t size='0.8' color='#bfbfbf' font='PuristaMedium'>%1</t><br /><br />",Format [localize 'STR_WF_UPGRADE_Level',"<t color='#ff9900'>" + str(_level) + '</t>' + "/<t color='#ff9900'>" + str(_maxLevel) + '</t>']] +
				_supplyCd +
				Format ["<t size='0.8' color='#bfbfbf' font='PuristaMedium'>%1</t><br />",Format [localize 'STR_WF_UPGRADE_Cost',"<t color=" + _colorFunds + ">" + str(_requiredFunds) + '</t>' + '/' + "<t color='#90ee90'>" + str(_currentFunds) + '</t> $']] +
				Format ["<t size='0.8' color='#bfbfbf' font='PuristaMedium'>%1</t><br /><br />",Format [localize 'STR_WF_UPGRADE_Duration',"<t color='#ff9900'>" + str(_time) + ' </t>' + localize 'STR_WF_Seconds']] +
				Format ["<t size='0.8' color='#ff9900' shadow='0'>%1</t><br />",localize 'STR_WF_UPGRADE_Description'] + /* added MrNiceGuy */
				Format ["<t size='0.8' color='#338dcc' shadow='2'>%1</t><br />",_desc] /* added MrNiceGuy */
			);

			if (_isUpgrading) then {
				//_tooltip_h = 0.12;
				_tooltip_text_content = parsetext (
					Format ["<t size='1.2' color='#338dcc' shadow='0'>%1:</t><br />",_name] +
					Format ["<t size='0.8' color='#bfbfbf' font='PuristaMedium'>%1</t><br /><br />",Format [localize 'STR_WF_UPGRADE_Level',"<t color='#ff9900'>" + str(_level) + '</t>' + "/<t color='#ff9900'>" + str(_maxLevel) + '</t>']] + /* added MrNiceGuy */
					Format ["<t size='0.8' color='#ff9900' font='PuristaMedium'>%1</t><br /><br />",localize 'STR_WF_UPGRADE_AlreadyRunning']+
					Format ["<t size='0.8' color='#ff9900' shadow='0'>%1</t><br />",localize 'STR_WF_UPGRADE_Description'] + /* added MrNiceGuy */
					Format ["<t size='0.8' color='#338dcc' shadow='0'>%1</t><br />",_desc] /* added MrNiceGuy */
				);
			};
			if (!_enabled) then {
				//_tooltip_h = 0.12; /* added MrNiceGuy */
				_tooltip_text_content = parsetext (
					Format ["<t size='1.2' color='#338dcc' shadow='0'>%1:</t><br />",_name] +
					Format ["<t size='0.8' color='#ff0033' font='PuristaMedium'>%1</t><br /><br />",localize 'STR_WF_UPGRADE_Condition'] +
					Format ["<t size='0.8' color='#ff9900' shadow='0'>%1</t><br />",localize 'STR_WF_UPGRADE_Description'] + /* added MrNiceGuy */
					Format ["<t size='0.8' color='#338dcc' shadow='0'>%1</t><br />",_desc] /* added MrNiceGuy */
				);			
			};
			if (_dependent && !_isUpgrading && _enabled) then {
				_tooltip_text_content = parsetext (
					Format ["<t size='1.2' color='#338dcc' shadow='0'>%1:</t><br />",_name] +
					Format ["<t size='0.8' color='#bfbfbf' font='PuristaMedium'>%1</t><br /><br />",Format [localize 'STR_WF_UPGRADE_Level',"<t color='#ff9900'>" + str(_level) + '</t>' + "/<t color='#ff9900'>" + str(_maxLevel) + '</t>']] + /* added MrNiceGuy */
					Format ["<t size='0.8' color='#ff9900' font='PuristaMedium'>%1</t><br /><br />",Format[localize 'STR_WF_UPGRADE_Dependent',_upgr select (_dependencie select 0),_dependencie select 1]] +
					Format ["<t size='0.8' color='#ff9900' shadow='0'>%1</t><br />",localize 'STR_WF_UPGRADE_Description'] + /* added MrNiceGuy */
					Format ["<t size='0.8' color='#338dcc' shadow='0'>%1</t><br />",_desc] /* added MrNiceGuy */
				);			
			};
		} else {
			//_tooltip_h = 0.12;
			_tooltip_text_content = parsetext (
				Format ["<t size='1.2' color='#338dcc' shadow='0'>%1:</t><br />",_name] +
				Format ["<t size='0.8' color='#bfbfbf' font='PuristaMedium'>%1</t><br /><br />",Format [localize 'STR_WF_UPGRADE_Level',"<t color='#ff9900'>" + str(_level) + '</t>' + "/<t color='#ff9900'>" + str(_maxLevel) + '</t>']] + /* added MrNiceGuy */
				Format ["<t size='0.8' color='#00ff33' font='PuristaMedium'>%1</t><br /><br />",localize 'STR_WF_UPGRADE_Maximum'] +
				Format ["<t size='0.8' color='#ff9900' shadow='0'>%1</t><br />",localize 'STR_WF_UPGRADE_Description'] + /* added MrNiceGuy */
				Format ["<t size='0.8' color='#338dcc' shadow='0'>%1</t><br />",_desc] /* added MrNiceGuy */

			);
		};
		
		if ((ctrlPosition _tooltip select 0) == 0 || true) then {_tooltip ctrlSetPosition [_tooltip_x,_tooltip_y,_tooltip_w,_tooltip_h]};
		_tooltip ctrlCommit 0;
		
		_tooltip_text ctrlSetStructuredText _tooltip_text_content;
		if ((ctrlPosition _tooltip_text select 0) == 0 || true) then {_tooltip_text ctrlSetPosition [_tooltip_x,_tooltip_y,_tooltip_w,_tooltip_h]};
		_tooltip_text ctrlCommit 0;
		
	} else {
		if ((ctrlPosition _tooltip select 0) != 0) then {_tooltip ctrlSetPosition [0,0,0,0];_tooltip ctrlCommit 0};
		if ((ctrlPosition _tooltip_text select 0) != 0) then {_tooltip_text ctrlSetPosition [0,0,0,0];_tooltip_text ctrlCommit 0};
	};
	
	_commander = false;
	if (!isNull(commanderTeam)) then {
		if (commanderTeam == group player) then {_commander = true};
	};
	
	if (Warfare_MenuAction == 1 && _canUpgrade && _commander) then {
		Warfare_MenuAction = -1;
		-(_requiredFunds) Call ChangePlayerFunds;
		if !(paramMoneyOnly) then {[sideJoined, -_requiredSupply] Call ChangeSideSupply};
		
		WFBE_RequestUpgrade = ['SRVFNCREQUESTUPGRADE',[_time,_level,_val,_name,sideJoined]];
		publicVariable 'WFBE_RequestUpgrade';
		if (isHostedServer) then {['SRVFNCREQUESTUPGRADE',[_time,_level,_val,_name,sideJoined]] Spawn HandleSPVF};
		
		Call Compile Format ["WFBE_%1_Upgrading = true;",sideJoinedText];
		_isUpgrading = true;
		hint Format [localize "STR_WF_INFO_Upgrade_Start",_name];
	} else {Warfare_MenuAction = -1};
	
	_txt = if (_isUpgrading) then {localize "STR_WF_UPGRADE_RunningInfo" + "..."} else {""};
	ctrlSetText[18802,_txt];
	
	_levelB = _upgrades select 0;
	_levelLF = _upgrades select 1;
	_levelHF = _upgrades select 2;
	_levelAF = _upgrades select 3;
	
	_imgB =_display displayCtrl 18021;
	_imgLF =_display displayCtrl 18022;
	_imgHF =_display displayCtrl 18023;
	_imgAF =_display displayCtrl 18024;
	
	switch (_levelB) do {
	case 1 : { _imgB ctrlSetText "\rwm_core_ui\Images\gui\upglevel1.paa";};
	case 2 : { _imgB ctrlSetText "\rwm_core_ui\Images\gui\upglevel2.paa";};
	case 3 : { _imgB ctrlSetText "\rwm_core_ui\Images\gui\upglevel3.paa";};
	};
	switch (_levelLF) do {
	case 1 : { _imgLF ctrlSetText "\rwm_core_ui\Images\gui\upglevel1.paa";};
	case 2 : { _imgLF ctrlSetText "\rwm_core_ui\Images\gui\upglevel2.paa";};
	case 3 : { _imgLF ctrlSetText "\rwm_core_ui\Images\gui\upglevel3.paa";};
	};
	switch (_levelHF) do {
	case 1 : { _imgHF ctrlSetText "\rwm_core_ui\Images\gui\upglevel1.paa";};
	case 2 : { _imgHF ctrlSetText "\rwm_core_ui\Images\gui\upglevel2.paa";};
	case 3 : { _imgHF ctrlSetText "\rwm_core_ui\Images\gui\upglevel3.paa";};
	};
	switch (_levelAF) do {
	case 1 : { _imgAF ctrlSetText "\rwm_core_ui\Images\gui\upglevel1.paa";};
	case 2 : { _imgAF ctrlSetText "\rwm_core_ui\Images\gui\upglevel2.paa";};
	case 3 : { _imgAF ctrlSetText "\rwm_core_ui\Images\gui\upglevel3.paa";};
	};
	sleep 0.05;
	
	//--- Back Button.
	if (Warfare_MenuAction == 2) exitWith { //---added-MrNiceGuy
		Warfare_MenuAction = -1;
		closeDialog 0;
		createDialog "WF_Menu";
	};
};