# Summary
Level | Description |
| --- | --- |
| Kernel | Three system calls have been added (setpr, getpidtime, getsched) |
| User | New command has been added, Head and Uniq commands have been extended |

### Extension Libraries (elibs)
Path | Files |
| --- | --- |
| Kernel/elibs/ | sched.c |
| User/elibs/ |  - |

### Global Extension Libraries (gelibs)
Path | Files |
| --- | --- |
| gelibs/ | - |

### Extension Function (EFUNCTIONS)
Path | Files |
| --- | --- |
| efunctions/ | - |

### Extension Modifications (EMODIFICATIONS)
Path | Files |
| --- | --- |
| kernel/ | proc.c proc.h |
| gelibs/ | time.h |



# Compilation
To compile the extensions and integrate them with the xv6 OS, in the main folder of the xv6 project, run the `make` commands as follows:


`make clean`:
![makeclean](https://github.com/gkiarashv/xv6/blob/main/images/makeclean3.png)

`make SCHED=(FCFS | PS | DEF)]`:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/make3.png)


`make qemu`:
![makeqemu](https://github.com/gkiarashv/xv6/blob/main/images/makeqemu3.png)



# System calls

## setpr
The `setpr` system calls sets a priority for a process with process ID of `pid`:
```
setpr(int pid, int priority);
```

The implementation of `setpr` system call is given in the `sysproc.c` and is as follows:
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/setpr.png)

The `change_priority()` function has been defined in the `kernel/elibs/sched.c` file and is as follows:
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/changepriority.png)



## getpidtime
The `getpidtime` retrieves time information for a given process with the process ID of `pid`:
```
getpidtime(int pid, e_time_t * time);
```
The implementation of `getpidtime` has been given in the `sysproc.c` and is as follows:
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/getpidtime.png)



## getsched
The `getsched` retrieves the scheduling algorithm of the Kernel:
```
getsched(int * sch);
```
The implementation of `getsched` has been given in the `sysproc.c` and is as follows:
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/getsched.png)



# Shell new commands

## schedtest
The `schedtest` command tests the scheduling of the XV6 kernel with the following construction:
```
schedtest ([-p PRIORITY] (-c COMMAND)+)+
```
For instance:
```
$ schedtest -c CMD1 -c CMD2
```
```
$ schedtest -c CMD1 -p PRIORITY -c CMD2
```
```
$ schedtest -p PRIORTY -c CMD1 -p PRIORITY -c CMD2
```
The `schedtest` command first parses the passed command and extracts the passed commands along with their priorities. Then, based on the scheduling algorithm of the
kernel, these commands are executed. The logic to execute them is as follows:

### Scheduling is FCFS
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schedalgofcfs.png)

### Scheduling is Priority scheduling
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schedalgofcpd.png)

### Scheduling is Default
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/schedalgodef.png)


Note that the turnaround time is calculated as `endTime - creationTime` and the waiting time is computed as `runningTime - creationTime`.

### Usage
For the example usages, please check [here](https://github.com/gkiarashv/xv6/blob/main/contributions/Oct%2031%202023/schedtest_usage/README.md).





## Head and Uniq extensions
Both the `uniq` and `head` commands can now switched between user mode and kernel mode with the command line option `-k`.



# Extension modifications

## gelibs/time.h
To further extend the time information of a process, we have added a new field to the `e_time_t` structure for a process which is called `runningTime`. This field is set upon state change from RUNNABLE to RUNNING.
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timestruct.png)

The `runningTime` should only be set once when the process gets the chance to be executed for the first time. Therefore, this field is set to zero when the process is created (`proc.c/allocproc()`). Then, in the scheduler (`proc.c/scheduler()`), when the process is chosen for execution, this field is updated:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/runtimeset.png)





## proc.h
Each process in xv6 will now be having a new field in `struct proc` struct called `priority` which is needed for priority scheduling.
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/proch.png)

The default priority of a process is set to 10 in the `proc.c/allocproc()` function.





## proc.c
The scheduler of the XV6 kernel now supports three scheduling algorithms: `Default`, `FCFS`, and `PS`(Priority scheduling). The implementation of these three scheduling algorithms have been given in the `proc.c/scheduler()`:

### Priority scheduling
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/procps3.png)
The logic is to iterate over the processes and choose the one that is first runnable and has the lowest possible priority. If the creation times were equal, the one with the lowest priority will be chosen.


### FCFS
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/fcfssched.png)
The logic is to iterate over the processes and choose the one that is first runnable and has the lowest creation time. The creation time of a process indicates
when the process has arrived and can be useful to indicate the execution order. If the creation times were equal, the one with the lowest priority will be chosen.



### Default
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/defsched.png)
The `toRun` variable set first as `p` will be again assigned to `p` without any changes. This results in xv6 to follow its default scheduling algorithm.





















