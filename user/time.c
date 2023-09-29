#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){

	int pid;

	if ((pid=fork())==0){
		exec(argv[0],argv);
	}else{

		e_time_t time;

		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
}