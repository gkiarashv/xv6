#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "gelibs/time.h"



int main(){


	int pid;
	if((pid=fork())==0){
		printf("CHILD");
		while(1){};
	}
	else{
		printf("parent\n");
		wait(0);
	}

	exit(0);

	time_t time;

	gettime(&time);

	tick_to_time("Started",time*100);
}



