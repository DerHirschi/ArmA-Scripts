#define true 1
#define false 0
/*
	╔══════════════════════════════════════════════════╗
	║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║
	║░░░░░░░█▀▀▀▄░▄░░░░░░░█░░░░▄░░░░░░░░░░░░░░░░░░░░░░░║
	║░░░░░░░█░░░█░░░█▀▀▀░░█░░░░░░░█▀▀▀▀█░█▀▀▀█░░░░░░░░░║
	║░░░░░░░█░░░█░█░█▀▀▀░░█░░░░█░░█░░░░█░█░░░█░░░░░░░░░║
	║░░░░░░░▀▀▀▀░░▀░▀▀▀▀░░▀▀▀▀░▀░░▀▀▀▀▀█░▀▀▀▀█░░░░░░░░░║
	║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▄▄▄█░░░░░░░░░░░░░░░║
	║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║
	╠══════════════════════════════════════════════════╝
	║	File: Scheduler.hpp	
	║		
	║	Author:  Hirschi - Die Liga	
	║	
	║	Loop	= Wiederholungen in Minuten. -1 Aus
	║	
	╚══════════════════════════════════════════════════╝
*/

class Server_Events {
	
	class Restart_1 {	
						
		StartTime[]	= {	07,	59,	00	}; 		//	erster Start	HH,MM,SS
		StartDate[]	= {				}; 		//	{	{2017,	4,	17} };	YY DD MM			
		Loop		= -1;					//	wird in x Minuten wiederholt. -1 Disabled
		
		cond		= "";					//	Bedingung
		exec		= "0 spawn{ []call TON_fnc_cleanup;[] call TON_fnc_RestartClean; }";	// 	Executed String
		
		LogRpt		= " Restart Cleanup gestartet";					
	};
	
	class Restart_2:Restart_1 {							
		StartTime[]	= {	17,	59,	00	}; 		//	erster Start	HH,MM,SS					
	};
	
	class Restart_3:Restart_1 {							
		StartTime[]	= {	23,	59,	00	}; 		//	erster Start	HH,MM,SS					
	};

	class Lotto {	
						
		StartTime[]	= {	18,30,00}; 		
		StartDate[]	= {			}; 					
		Loop		= -1;				
		
		cond		= "";					
		exec		= "[]spawn TON_fnc_LottoZieh";	// 	Executed String
		
		LogRpt		= "Lottoziehung";					
	};
		
	class Event_3 {	
						
		StartTime[]	= {				}; 		//	erster Start	HH,MM,SS
		StartDate[]	= {	
						{2018, 5, 1},
						{2018, 5, 2}
					}; 		//	{	{2017,	4,	17} };	YY DD MM			
		Loop		= 2;					//	wird in x Minuten wiederholt. -1 Disabled
		
		cond		= "";					//	Bedingung
		exec		= " 0 call { diag_log 'Event 3';}";	// 	Executed String
		
		LogRpt		= "Test Timer Event 3";					
	};
		
};



