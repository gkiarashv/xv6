#ifndef GETIME_H
#define GETIME_H


typedef struct e_time{

	uint64 creationTime; 	// Upon process creation, this time is set

	uint64 endTime;			// Upon process termination, this time is set

	uint64 totalTime;		// Upon process termination, this time is calculate as: endTime-creationTime

	uint64 runningTime; 	// Upon state change from RUNNABLE -> RUNNING, this time is set
}e_time_t;


typedef uint64 time_t;



// 1 tick 1 ms
// 1 min = 60 * 1000
#define tick_to_time(type, tick) {\
            printf("%s: %d min %d sec %d ms  %l(ticks)\n",type , (tick/100000000000)/60 , (tick/10000000) , ((tick/10000000)%60) ,tick);\
           }


#endif

// 14500
           