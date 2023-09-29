#ifndef GETIME_H
#define GETIME_H


typedef struct e_time{

	uint64 creationTime; 	// Upon process creation, this time is set

	uint64 endTime;			// Upon process termination, this time is set

	uint64 totalTime;		// Upon process termination, this time is calculate as: endTime-creationTime

}e_time_t;


typedef uint64 time_t;




#define tick_to_time(type, tick) {\
            printf("%s: %d min %d sec %d ms  %l(ticks)\n",type ,(tick)/60000, ((tick)%60000)/1000,((tick)%60000)%1000,tick);\
           }


#endif

           