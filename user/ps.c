#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "gelibs/string.h"
#include "gelibs/etypes.h"


enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };



void parse_cmd(char ** cmd, int * pid , int  * ppid, char ** name ,int * status);


int main(int argc, char **argv){


	char * pName = NULL;
	int status = -1;
	int pid = -1;
	int ppid = -1;

	parse_cmd(argv, &pid, &ppid, &pName, &status);

	ps(pid, ppid, status, pName);
}


void parse_cmd(char ** cmd, int * pid , int  * ppid, char ** name ,int * status){

	while(*cmd){

		if (!compare_str(*cmd,"-pid")){
			cmd++;
			*pid = atoi(*cmd);
		}else if (!compare_str(*cmd,"-ppid")){
			cmd++;
			*ppid = atoi(*cmd);

		}else if (!compare_str(*cmd,"-stat")){
			cmd++;
			if (!compare_str_ic(*cmd,"sleeping"))
				*status=SLEEPING;
			else if(!compare_str_ic(*cmd,"running"))
				*status=RUNNING;
			else if(!compare_str_ic(*cmd,"ready"))
				*status=RUNNABLE;
			else if(!compare_str_ic(*cmd,"zombie"))
				*status=ZOMBIE;
			else if(!compare_str_ic(*cmd,"used"))
				*status=USED;
			else{
				printf("[ERR] Invalid process state\n");
				exit(0);
			}
		}else if(!compare_str(*cmd,"-name")){
			cmd++;
			*name = *cmd;
		}
		cmd++;
	}
}

