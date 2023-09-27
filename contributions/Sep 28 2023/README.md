# Summary
Level | Description |
| --- | --- |
| Kernel | File manipulation API has been extended, Three new system calls have been added  |
| User | Shell has been extended |

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
| kernel/ | sysfile.c fcntl.h |


# GELIBS
The new extension to the `proc` structure of any process has been the timing criterias including the creation time, ending time, and the total time of the execution. These timining information has been defined in the `gelibs/time.h`:


FIG

The calculation of the time is based on the CPU ticks. Therefore, the macro function `tick_to_time()` converts the ticks to the human readable time based on the minutes, seconds, and milliseconds. The `type` input to this macro function defines a string that describes the type of the time that is being printed.


# File manipulation API extended

The previous `sys_open()` system call had not provided any mode for appending to a file. In the current version, we have added a new mode `O_APPEND` to `fcntl.h` that provides this ability.

FIGURE

The modification to `sys_open()` was to set the file's offset to the size of the file when the mode is `O_APPEND`. This has been done using the file's inode structure `ip->size`.

FIGURE

This phase was necessary for the functionality of other new updates of the xv6 OS.





# System calls
The newly added system calls are as follows:


## gettime
The `gettime` system call is called in the user space as follows:
```
gettime(time_t * time)
```
Where `time_t` is defined in `gelibs/time.h` as a 64-bit number.

The implementiation of the system call has been done in the `sysproc.c` file and is as follows:

FIG





## times
The `times` system call is called in the user space as follows:
```
times(int pid, e_time_t * time);
```
This system call returns the timing information for the process with process id of `pid` as the e_time_t structure into
`time` variable.


The implementation of `sys_times()` is given in `sysproc.c` as follows:

FIGURE


The `get_process_time()` function is exactly the `wait(0)` function with this difference that it only search for a ZOMBIE child that has a pid that
matches the `tpid`. When this child is found, the timing information is completed by computing the ending and total times. Then, it is returned(copyout) to the 
e_time_t structure in the user space.

FIG





## ps





# Shell extension
To compute the total time that an execution of a command or commands take, a new keyword `time` has been added to the shell of the xv6, defined in `user/sh.c`. Adding this keyword before each command, in pipe or not, will print the timing information.
```
time CMD
```
```
time CMD | time CMD | ...
```
```
CMD | time CMD | CMD | time CMD ...
```





















