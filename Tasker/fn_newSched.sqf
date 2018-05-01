/*
	Author: Hirschi - MG - PDL
	Blaaa
*/

_loging = true;
diag_log "╠══════════════════════════════════════════════════";
diag_log "║ Server Scheduler gestartet ...";
diag_log "╠══════════════════════════════════════════════════";
private _time_conig = [];
private _loop_conig = [];

_fn_getConfArray = {
	
	_time = getArray(missionConfigFile >> "Server_Events" >> _this >> "StartTime");
	_loop = getNumber(missionConfigFile >> "Server_Events" >> _this >> "Loop");	
	_cond = getText(missionConfigFile >> "Server_Events" >> _this >> "cond");
	_exec = getText(missionConfigFile >> "Server_Events" >> _this >> "exec");
	_log  = getText(missionConfigFile >> "Server_Events" >> _this >> "LogRpt");
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
	_date  = getArray(missionConfigFile >> "Server_Events" >> _cname >> "StartDate");
	if((count _date) isEqualTo 0) then {
		_time_conig pushBack ((_cname call _fn_getConfArray) select 0);
		_loop_conig pushBack ((_cname call _fn_getConfArray) select 1);
	}else{
		if(sys_date in _date)then {
			_time_conig pushBack ((_cname call _fn_getConfArray) select 0);
			_loop_conig pushBack ((_cname call _fn_getConfArray) select 1);
		};
	};
	
	
} forEach ("true" configClasses (missionConfigFile >> "Server_Events"));

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
		diag_log format["║ %1 > %2",(_x select 0), (_x select 3)];
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
