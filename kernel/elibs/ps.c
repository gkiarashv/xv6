#include "kernel/types.h"
#include "kernel/riscv.h"
#include "kernel/defs.h"
#include "kernel/param.h"
#include "kernel/stat.h"
#include "kernel/spinlock.h"
#include "kernel/proc.h"
#include "kernel/fs.h"
#include "kernel/sleeplock.h"
#include "kernel/file.h"
#include "kernel/fcntl.h"


#include "kernel/memlayout.h"
#include "gelibs/string.h"



extern struct proc proc[NPROC];
extern struct spinlock wait_lock;
extern uint64 sys_uptime(void);


#define tick2time(tick) {\
            printf("%d min %d sec %d ms" ,(tick)/60000, ((tick)%60000)/1000,((tick)%60000)%1000);\
           }


/*
Prints the status of all the processes in the system
*/
void get_process_status(int tpid, int tppid, int tstatus, uint64 pName){


	struct proc *pp;
	int havekids, pid;
	struct proc *p = myproc();

	// For PID specific option
	int foundPID = 0;

	// For process name specific option
	int namesIDx = 0;

	acquire(&wait_lock);


	printf("PID\tPPID\t  STAT\t          STIME\t\t         ETIME\t\t     TTIME\t     NAME\n");
	printf("---\t----\t--------   --------------------\t-------------------- --------------------  ---------\n");


	for (int i=0;i<NPROC;i++){
		
		struct proc * p = &proc[i];

		acquire(&p->lock);

		/* Skipping the processes if their pid does not match the target pid */
		if (tpid >= 0 &&  tpid != p->pid){
			release(&p->lock);
			foundPID = 1;
			continue;
		}


		/* Checking for the process name */
		if (pName!=0){
			char processName [100];
			fetchstr(pName, processName, 100);
			if (check_substr(processName, p->name)==-1){
				release(&p->lock);
				continue;
			}
		}

		/* Skipping the processes if their ppid does not match the target ppid */
		int parentID = (p->parent) ? p->parent->pid : 0;

		if (tppid >=0 && tppid!=parentID){
			release(&p->lock);
			continue;
		}

		if (tstatus >= 0 && p->state != tstatus){
			release(&p->lock);
			continue;
		}

		time_t time = sys_uptime();


		if (p->state == SLEEPING){
			printf("%d\t %d\t%s     ",p->pid, parentID, "Sleeping");
			tick2time(p->execTime.creationTime*100);
			printf("      In progress        ");
			tick2time(time*100);
			printf("     %s\n",p->name);
		}

		else if (p->state == RUNNABLE){
			printf("%d\t %d\t%s     ",p->pid, parentID, "Ready");
			tick2time(p->execTime.creationTime*100);
			printf("      In progress       ");
			tick2time(time*100);
			printf("     %s\n",p->name);
		}
		
		else if (p->state == RUNNING){
			printf("%d\t %d\t%s     ",p->pid, parentID, "Running");
			tick2time(p->execTime.creationTime*100);
			printf("      In progress        ");
			tick2time(time*100);
			printf("     %s\n",p->name);
		}
		
		else if (p->state == ZOMBIE ){
			printf("%d\t %d\t%s     ",p->pid, parentID, "ZOMBIE");
			tick2time(p->execTime.creationTime*100);
			tick2time(p->execTime.endTime*100);
			tick2time(p->execTime.totalTime*100);
		}
		else if (p->state == USED){
			printf("%d\t %d\t%s     ",p->pid, parentID, "USED");
			tick2time(p->execTime.creationTime*100);
			tick2time(p->execTime.endTime*100);
			tick2time(p->execTime.totalTime*100);
		}

		release(&p->lock);

		if (foundPID){
			break;
		}
	}
	release(&wait_lock);
}



