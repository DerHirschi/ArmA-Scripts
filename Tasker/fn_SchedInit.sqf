/*
	Author: Hirschi - MG - PDL
	Blaaa
  Needs plugin from http://killzonekid.com/arma-extension-real_date-dll-v3-0/
*/
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

0 spawn TON_fnc_newSched;
