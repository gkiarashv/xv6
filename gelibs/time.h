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
            printf("%s: %d min %d sec %d ms  %l(ticks)\n",type , (tick)/6000000 , ((tick)%6000000)/100000 , ((tick)%600000000000)/10000,tick);\
           }


#endif

// 14500
           