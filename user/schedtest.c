#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/elibs/flags.h"
#include "kernel/elibs/sched.h"
#include "gelibs/string.h"


int parse_cmd(char ** cmd, char * schedAlgo, char ** commands, int * priority, int * nextCmd);
void prase_cmd_summary(int cmdCount, char ** commands,  int * priority , int * nextCmd);



int main(int argc, char ** argv){

	int kernelScheduler;
	getsched(&kernelScheduler);


	char sched = kernelScheduler;
	int * commands[100];
	int priority[20];
	int nextCmd[20];
	int cmdCount = parse_cmd(argv, &sched , commands, priority, nextCmd);

	// Allocate space for PIDs for later fetching the timing information
	int * pids = malloc(sizeof(int) * cmdCount);
	int pidIdx = 0 ;

	if (kernelScheduler == SCH_FCFS){
		if (sched == SCH_PS){
			printf("[ERR] Kernel is running FCFS\n");
			exit(-1);
		}else {
			int pid;
			
			/* Creating the child processes for the commands */
			for(int i=0;i<cmdCount;i++){
				char ** cmds = &commands[nextCmd[i]];
				pid = fork();
				if (!pid){ // Child
					exec(cmds[0],cmds);
					break;
				}
				pids[pidIdx++]=pid;
			}
			if (pid){ // Parent
				
				for(int i=0;i<cmdCount;i++)
					wait(0);
				
				time_t turnATime=0;
				time_t wTime=0;

				/* Getting the time of execution */
				for(int i=0;i<cmdCount;i++){
					e_time_t time;
					getpidtime(pids[i],&time);

					printf("creationTime: %d  endTime: %d   totalTime: %d   runningTime: %d (ticks) \n",time.creationTime,
																					time.endTime,time.totalTime,time.runningTime);
					turnATime += time.totalTime;
					wTime += time.runningTime-time.creationTime;
				}
				printf("------------------------------------------------------------------\n");
				printf("AVGTurnAroundTime: %d ticks   AVGWaitingTime: %d ticks\n",turnATime/cmdCount, wTime/cmdCount);
			}
		}
	}else if (kernelScheduler == SCH_PS){
		if (sched == SCH_FCFS){
			printf("[ERR] Kernel is running Priority scheduling\n");
			exit(-1);
		}else{
			int pid;
			for(int i=0;i<cmdCount;i++){
				char ** cmds = &commands[nextCmd[i]];
				pid=fork();
				if (!pid){ // Child
					exec(cmds[0],cmds);
					break;
				}
				pids[pidIdx++]=pid;
				setpr(pid, priority[i]);
			}
			if (pid){ // Parent
				
				for(int i=0;i<cmdCount;i++)
					wait(0);
				
				time_t turnATime=0;
				time_t wTime=0;

				/* Getting the time of execution */
				for(int i=0;i<cmdCount;i++){
					e_time_t time;
					getpidtime(pids[i],&time);
					turnATime += time.totalTime;
					wTime += time.runningTime-time.creationTime;

					printf("creationTime: %d  endTime: %d   totalTime: %d   runningTime: %d (ticks) \n",time.creationTime,
																						time.endTime,time.totalTime,time.runningTime);
				}
				printf("------------------------------------------------------------------\n");
				printf("AVGTurnAroundTime: %d ticks   AVGWaitingTime: %d ticks\n",turnATime/cmdCount, wTime/cmdCount);
			}
		}
	}else {
		if (sched != SCH_DEF){
			printf("[ERR] Kernel is running default scheduling\n");
			exit(-1);
		}else{
			int pid;
			for(int i=0;i<cmdCount;i++){
				char ** cmds = &commands[nextCmd[i]];
				pid=fork();
				if (!pid){
					exec(cmds[0],cmds);
					break;
				}
				pids[pidIdx++]=pid;
			}
			if (pid){
				for(int i=0;i<cmdCount;i++)
					wait(0);
				
				time_t turnATime=0;
				time_t wTime=0;

				/* Getting the time of execution */
				for(int i=0;i<cmdCount;i++){
					e_time_t time;
					getpidtime(pids[i],&time);
					turnATime += time.totalTime;
					wTime += time.runningTime-time.creationTime;
					printf("creationTime: %d  endTime: %d   totalTime: %d   runningTime: %d (ticks) \n",time.creationTime,
																						time.endTime,time.totalTime,time.runningTime);
				}
				printf("------------------------------------------------------------------\n");
				printf("AVGTurnAroundTime: %d ticks   AVGWaitingTime: %d ticks\n",turnATime/cmdCount, wTime/cmdCount);
			}
		}
	}		


	return 0;
}


int parse_cmd(char ** cmd, char * schedAlgo, char ** commands, int * priority, int * nextCmd){

	cmd++;  // Skipping the program's name
	

	int priorityIdx = 0;
	int commandsIdx = 0;
	int nextCmdIdx = 0;
	int cmdCount=0;

	while(*cmd){
		if (!compare_str(cmd[0], "-fcfs"))
			*schedAlgo = SCH_FCFS;
		
		else if (!compare_str(cmd[0], "-ps"))
			*schedAlgo = SCH_PS;		
		
		else if (!compare_str(cmd[0], "-p")){
		
			priority[priorityIdx++]=atoi(cmd[1]);
			nextCmd[nextCmdIdx++] = commandsIdx;
			cmd+=3;
			/* Command */

			while(*cmd && !( !compare_str(cmd[0], "-ps") || !compare_str(cmd[0], "-fcfs") || !compare_str(cmd[0], "-p") || !compare_str(cmd[0], "-c") )){
				commands[commandsIdx++]=*cmd;

				cmd++;
			}
			if (*cmd) // for handling - if sth exists
				cmd--;
			commands[commandsIdx++]=0;

			cmdCount++;
		}
		
		else if (!compare_str(cmd[0], "-c")){

			cmd++;

			priority[priorityIdx++]=10;
			nextCmd[nextCmdIdx++] = commandsIdx;
			while(*cmd && !( !compare_str(cmd[0], "-ps") || !compare_str(cmd[0], "-fcfs") || !compare_str(cmd[0], "-p") || !compare_str(cmd[0], "-c") )){
				commands[commandsIdx++]=*cmd;
				cmd++;
			}
			if (*cmd) // for handling - if sth exists
				cmd--;
			commands[commandsIdx++]=0;
			cmdCount++;
		}
		if (!*cmd)
			break;	
		cmd++;
	}
	return cmdCount;
}




