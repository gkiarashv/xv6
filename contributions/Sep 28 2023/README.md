# Summary
Level | Description |
| --- | --- |
| Kernel | File manipulation API has been extended (File append mode), Three new system calls have been added (times, ps, gettime)  |
| User | Shell has been extended with one keyword (time) and two commands (ps, date) |

### Extension Libraries (elibs)
Path | Files |
| --- | --- |
| Kernel/elibs/ | times.c , ps.c  |
| User/elibs/ |  - |

### Global Extension Libraries (gelibs)
Path | Files |
| --- | --- |
| gelibs/ | time.h |

### Extension Function (EFUNCTIONS)
Path | Files |
| --- | --- |
| efunctions/ | - |

### Extension Modifications (EMODIFICATIONS)
Path | Files |
| --- | --- |
| kernel/ | sysfile.c, fcntl.h |



# Compilation
To compile the extensions and integrate them with the xv6 OS, in the main folder of the xv6 project, run the `make` commands as follows:


`make clean`:
![makeclean](https://github.com/gkiarashv/xv6/blob/main/images/makeclean2.png)

`make`:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/make2.png)


`make qemu`:
![makeqemu](https://github.com/gkiarashv/xv6/blob/main/images/makeqemu2.png)








# GELIBS
The latest addition to the `proc` structure of every process involves the inclusion of timing criteria such as creation time, completion time, and total execution duration. These timing details are specified in the `gelibs/time.h` file.

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/timeinfo.png)


The `e_time` struct fields are initialized as follows: `creationTime` is assigned at the execution of the `fork()` system call and when a process is allocated through the `allocproc()` function.

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/estructfp.png)


The other fields are set when the process execution is ended:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/exectime.png)


The time calculation relies on CPU ticks, with each tick assumed to be equivalent to 100 milliseconds. Consequently, the macro function `tick_to_time()` is employed to convert these ticks into human-readable time, representing minutes, seconds, and milliseconds. The type parameter in this macro function specifies a string indicating the type of time being displayed.











# File manipulation API extended

In the past, the `sys_open()` system call did not offer a mode for appending data to a file. In the updated version, we have introduced a new mode called `O_APPEND` in `fcntl.h`, enabling this functionality.

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/fcntlmodes.png)


The adjustment made to `sys_open()` involved setting the file's position to the file size when the `O_APPEND` mode is specified. This operation was achieved by utilizing the file's inode structure `ip->size`.

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/sysopen.png)


This phase was necessary for the functionality of other new updates of the xv6 OS.












# System calls
The newly added system calls are as follows:


## gettime
The `gettime` system call is called in the user space as follows:
```
gettime(time_t * time)
```
Where `time_t` is defined in `gelibs/time.h` as a 64-bit integer number.

The implementiation of the system call has been done in the `sysproc.c` file and is as follows:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/gettimeimp.png)

As it is clear, it returns the output of the `sys_uptime()` wich is the total number of ticks since the start of the OS.




## times
The `times` system call is called in the user space as follows:
```
times(int pid, e_time_t * time);
```
This system call returns the timing information for the process with process id of `pid` and stores it as `e_time_t` structure.

The implementation of `sys_times()` is given in `sysproc.c` as follows:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/sys_times.png)

The `get_process_time()` function functions similarly to `wait(0)`, but with a distinction: it specifically looks for a ZOMBIE child process that matches the target pid specified in `tpid`. Once this child process is identified, the function calculates ending and total times using the `sys_uptime()` function and completes the timing information. Subsequently, this information is copied out to the `e_time_t` structure in the user space before being returned.


![cmd](https://github.com/gkiarashv/xv6/blob/main/images/getprocesstime.png)






## ps
The `ps` system call prints out information about the processes of the system. The `ps` system call is as follows:
```
void ps(int pid, int ppid, int status, char * pName)
```

The parameters serve as filters for the ps output. `pid` restricts the output to processes with a particular process ID, `ppid` limits it to processes with a specific parent process ID, `status` narrows down to processes with specific statuses, and `pName` confines the output to processes with a specific string in their names.


The `ps` system call has been written in the `kernel/sysproc.c` and `kernel/elibs/ps.c`:

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/sysps.png)

![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psimp1.png)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psimp2.png)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psimp3.png)
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/psimp4.png)

In this approach, we go through the list of processes. If an option has been specified and we don't find a process that meets this criteria, we skip it using the `continue` statement within the loop's if condition.







# Shell extension

## time keyword
To calculate the overall duration of executing one or multiple commands, a new keyword, `time`, has been introduced into the xv6 shell. This keyword, defined in `user/sh.c`, can be placed before any command, whether in a pipeline or not, to display the timing information.
```
time CMD
```
```
time CMD | time CMD | ...
```
```
CMD | time CMD | CMD | time CMD ...
```

## date command
A new command has been introduced, enabling the display of the xv6 OS uptime as the primary time reference.


## ps command
The `ps` command is as follows:
```
ps [-pid PID | -ppid PPID | -stat STATUS | -name NAME]
```
Possible values for `STATUS` are: `sleeping`, `ready`, `running`, `zombie`, and `used`. Note that these options can be used simultaneously.


### Implementation
See [implementation](https://github.com/gkiarashv/xv6/tree/main/contributions/Sep%2028%202023/shell_implemenation) for the implementation details.


### Usages
See [usages](https://github.com/gkiarashv/xv6/tree/main/contributions/Sep%2028%202023/shell_usage) for the usage examples.




















