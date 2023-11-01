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

#include "kernel/elibs/sched.h"


extern struct proc proc[NPROC];
extern struct spinlock wait_lock;


/* This function changes the priority of the given process 
[Input]
	pid: Process ID of the process
	priority: New priority of the process

[Output]
	Returns 1 if sucessful, else 0
*/
int change_priority(int pid, int priority){

	if (!(priority>=MIN_PRIORITY && priority<=MAX_PRIORITY))
		return 0;

	struct proc *p;

	for (int i=0;i<NPROC;i++){
		
		struct proc * p = &proc[i];

		acquire(&p->lock);

		if(p->pid == pid) {
	    	p->priority = priority;
	    	release(&p->lock);
	    	return 1;
	    }
	    release(&p->lock);
	}
  	return 0;
}
