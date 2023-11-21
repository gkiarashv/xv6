#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"


int main(){ 
	char buff[5000]; // 5000 > 4096(Page size)

	for(int i=0;i<5000;i++)
		buff[i]=i%10+1;

	printf("%d\n",buff[100]);
}




