#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/etypes.h"
#include "user/user.h"


#define STDOUT 1

u32 str_len(const u8 * str){
	u32 len = 0;
	while(*str++){len++;};
	return len;
}


void print(u8 * mess){
	write(STDOUT,mess,str_len(mess));
}







