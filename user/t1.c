#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/elibs/flags.h"
#include "kernel/elibs/sched.h"
#include "gelibs/string.h"


void delay(){
	time_t f ;
	gettime(&f);
	time_t l=f;
	while(l-f<5){
		gettime(&l);
	};
}


int main(){
	for (int i=0;i<10;i++){
		printf("T1: %d\n",i);
		// delay();
	}
}





