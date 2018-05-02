/*
	Author: Hirschi - MG - PDL
	Blaaa
  Needs plugin from http://killzonekid.com/arma-extension-real_date-dll-v3-0/
*/
_loging = true;
diag_log "╠══════════════════════════════════════════════════";
diag_log "║ Server Scheduler Init ...";
diag_log "╠══════════════════════════════════════════════════";
waitUntil{ time > 0};
waitUntil{ sleep 0.5; sys_time =("real_date" callExtension "+"); !isNil "sys_time"};

sys_time = call compile sys_time;
sys_date = [sys_time select 0 ,sys_time select 1 ,sys_time select 2];
sys_time = [(sys_time select 3) * 3600, (sys_time select 4) * 60, sys_time select 5];
diag_log format["║ Time: %1", sys_time ];
_temp 	 = 0;
{
	_temp = _temp + _x;
}forEach sys_time;
sys_time  = _temp;
diag_log format["║ Time: %1", sys_time ];
diag_log format["║ Date: %1", sys_date ];
sys_time = sys_time - time;
start_delay = time;

diag_log "╠══════════════════════════════════════════════════";
diag_log "║ Server Scheduler gestartet ...";
diag_log "╠══════════════════════════════════════════════════";
private _time_conig = [];
private _loop_conig = [];
private _conig 		= "";
if (!hasInterface && !isServer) then {
    _conig 		= "HC_Events";
}else{
	if(isServer)then{
		_conig 	= "Server_Events";
	};
	if(hasInterface)then{
		_conig 	= "Client_Events";
	};	
};
_fn_getConfArray = {
	
	_time = getArray(missionConfigFile >> (_this select 0) >> (_this select 1) >> "StartTime");
	_loop = getNumber(missionConfigFile >> (_this select 0) >> (_this select 1) >> "Loop");	
	_cond = getText(missionConfigFile >> (_this select 0) >> (_this select 1) >> "cond");
	_exec = getText(missionConfigFile >> (_this select 0) >> (_this select 1) >> "exec");
	_log  = getText(missionConfigFile >> (_this select 0) >> (_this select 1) >> "LogRpt");
	_ret  = ["", _cond, _exec, _log];
	
	if(_loop isEqualTo -1) then {
		_time = (((_time select 0) * 3600) + ((_time select 1) * 60) + (_time select 2));
		
		if(_time < (sys_time + start_delay)) then{
			[[], []]
		}else{
			_ret set[0,_time];
			[_ret, []]
		};
				
	}else{
		_lt = (round (_loop * 60));
		_ret set[0,(sys_time + _lt)];
		_ret pushBack _lt;
		[[], _ret]
	};	
};
{	
	_cname = configName _x;
	_date  = getArray(missionConfigFile >> _conig >> _cname >> "StartDate");
	if((count _date) isEqualTo 0) then {
		_time_conig pushBack (([_conig, _cname] call _fn_getConfArray) select 0);
		_loop_conig pushBack (([_conig, _cname] call _fn_getConfArray) select 1);
	}else{
		if(sys_date in _date)then {
			_time_conig pushBack (([_conig, _cname] call _fn_getConfArray) select 0);
			_loop_conig pushBack (([_conig, _cname] call _fn_getConfArray) select 1);
		};
	};		
} forEach ("true" configClasses (missionConfigFile >> _conig));

_time_conig = _time_conig - [[]];
_loop_conig = _loop_conig - [[]];
if(_loging)then {
	_fnc_splitSec = {
		_Std	=	floor (_this	/	3600	);
		_Min	=	floor ((_this -	(	_Std * 3600))	/	60		);
		_Sek	=	floor ((_this -	(	_Std * 3600)	-	_Min * 60)		);
		[_Std,_Min,_Sek]
	};
	diag_log "║ Timer Aufgaben:";
	diag_log "║ ";
	{
		diag_log format["║ %1 > %2",((_x select 0) call _fnc_splitSec), (_x select 3)];
	}forEach _time_conig;
	
	diag_log "╠══════════════════════════════════════════════════ ";
	diag_log "║ Loop Aufgaben:";
	diag_log "║ ";
	{
		diag_log format["║ %1 > %2",round((_x select 0) / 60), (_x select 3)];
	}forEach _loop_conig;
	diag_log "║ ";
};

diag_log "╠══════════════════════════════════════════════════";
diag_log "║ Starte Loop ...";
diag_log "╠══════════════════════════════════════════════════";

_fn_execTask = {
	private _cond = ((_this select 0) select 1);
	if(_cond isEqualTo "") then {
		_cond = true;
	}else{		
		_cond = call compile _cond;
	};
	if(_cond) then {
		call compile ((_this select 0) select 2);
		diag_log ("║ " + (_this select 1) + "-Task: " + ((_this select 0) select 3) );
	};
};


while{true}do{
	_serv_time = sys_time + time;
	{
		if(_serv_time >= (_x select 0)) then {
			[_x, "Timer"]call _fn_execTask;
			_time_conig set[_forEachIndex,[]];
		};
	}forEach _time_conig;
	_time_conig = _time_conig - [[]];
	
	sleep 1;
	_serv_time = sys_time + time;
	{
		
		if(_serv_time >= (_x select 0) ) then {
			[_x, "Loop"]call _fn_execTask;
			_temp = _x;
			_temp set[0, (_serv_time + (_x select 4) )];
			_loop_conig set[_forEachIndex,_temp];
		};
	}forEach _loop_conig;
	
	sleep 1;
};
