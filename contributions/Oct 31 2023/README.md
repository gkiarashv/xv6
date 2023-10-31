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
| kernel/ | sysfile.c, fcntl.h |
| gelibs/ | time.h |



# System calls

## setpr
The `setpr` system calls sets a priority for a process with process ID of `pid`:

```
setpr(int pid, int priority);
```

The implementation of `setpr` system call is given in the `sysproc.c` and is as follows:
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/sys_times.png)

The `change_priority()` function has been defined in the `kernel/elibs/sched.c` file and is as follows:
![cmd](https://github.com/gkiarashv/xv6/blob/main/images/sys_times.png)












