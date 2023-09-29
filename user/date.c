#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "gelibs/time.h"



int main(){

	time_t time;

	gettime(&time);

	tick_to_time("Started",time*100);
}



