#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int main(){
	char * p = (char *)0x3000;
	printf("%d\n",*p);
}