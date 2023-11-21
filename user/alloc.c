#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"



int main(){

	int * x= malloc(sizeof(int)*10);
	x[0]=10;
	printf("%d\n",x[0]);
}

