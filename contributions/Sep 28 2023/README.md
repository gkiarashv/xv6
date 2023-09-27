# Summary
Level | Description |
| --- | --- |
| Kernel | File manipulation API has been extended, Two new system calls have been added  |
| User | Shell has been extended |

### Extension Libraries (elibs)
Path | Files |
| --- | --- |
| Kernel/elibs/ | times.c, times.h, ps.c  |
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


# File manipulation API extended

The previous `sys_open()` system call had not provided any mode for appending to a file. In the current version, we have added a new mode `O_APPEND` to `fcntl.h` that provides this ability.

FIGURE

The modification to `sys_open()` was to set the file's offset to the size of the file when the mode is `O_APPEND`. This has been done using the file's inode structure `ip->size`.

FIGURE

This phase was necessary for the functionality of other new updates of the xv6 OS.





