# Summary
Level | Description |
| --- | --- |
| Kernel | Two new system calls, uniq and head, have been added  |
| User | Two new commands, uniq and head, have been added |

### Extension Libraries (elibs)
Path | Files |
| --- | --- |
| Kernel/elibs/ | file.c  |
| User/elibs/ |  file.c |

### Global Extension Libraries (gelibs)
Path | Files |
| --- | --- |
| gelibs/ | string.c, file.h, string.h, etypes.h |

### Extension Function (EFUNCTIONS)
Path | Files |
| --- | --- |
| efunctions/ | head.c, uniq.c |

### Extension Modifications (EMODIFICATIONS)
Path | Files |
| --- | --- |
| kernel/ | pipe.c |





# ELIBS details

#### User/elibs/file.c:

Functionality | Description |
| --- | --- |
| open_file() | Opens a file and returns a file descriptor  |
| read_line() | Reads a line from the given file |


#### Kernel/elibs/file.c:

Functionality | Description |
| --- | --- |
| open_file() | Opens a file and returns a file descriptor  |
| read_line() | Reads a line from the given file |
| close_file() | Closes the given file |



# GELIBS details

#### gelibs/string.c:

Functionality | Description |
| --- | --- |
| get_strlen() | returns the length of a given string  |
| compare_str() | compares two strings considering their case |
| compare_str_ic() | compares two strings ignoring their case |


# EFUNCTIONS details
Functionality | Description |
| --- | --- |
| head_run() | Actual implementation of the head functionality  |
| uniq_run() | Actual implementation of the uniq functionality |


# EMODIFICATIONS details
Functionality | Description |
| --- | --- |
| read_pipe() | Reading from pipe in the kernel mode  |



# Extensions
To compile the extensions and integrate them with the xv6 OS, in the main folder of the xv6 project, run the `make` commands as follows:


`make clean`:
![makeclean](https://github.com/gkiarashv/xv6/blob/main/images/makeclean.png)

`make`:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/makekernel.png)


`make qemu`:
![makeqemu](https://github.com/gkiarashv/xv6/blob/main/images/makeqemu.png)



## Extension 1: Head
 ```
  head [-n numOfLines] [file ...]
 ```
The head command prints the first `numOfLines` lines of each of the specified files, or the standard input if no files are specified. If numOfLines is omitted it defaults to 14.



### User mode implementation

The user mode implementation of the head command has been given in the files `user/head.c` and efunction `efunctions/head.c`. `user/head.c` file contains two functions:

Functionality | Description |
| --- | --- |
| head_usermode() | A wrapper for the actual head function |
| parse_cmd() | Parses the issued head command and returns the list of files and options |

The `main` function is as follows:

![headusermain](https://github.com/gkiarashv/xv6/blob/main/images/headusermain.png)
 



### Kernel mode implementation

```int head(char ** passedFiles, int numOfLines)```

The kernel mode implementation of the head function has been given in the `kernel/sysproc.c` and `efunctions/head.c`. The `kernel/sysproc.c` has the `sys_head()`
system call which is called upon the head system call. The passed files and the options are the arguments passed to this system call. The `efunctions/head.c` contains the `head_run()` function which is the actual implementation of the head functionality in the kernel.

To use the head system call, edit the main function of the `user/head.c` as follows:

![headkernelmain](https://github.com/gkiarashv/xv6/blob/main/images/headkernelmain.png)
 

### Usage
See [usages](https://github.com/gkiarashv/xv6/edit/main/contributions/Sep%2012%202023/head_usage/).

### Implementation Logic
See [logic](https://github.com/gkiarashv/xv6/edit/main/contributions/Sep%2012%202023/head_logic/).











# Uniq
```
uniq [-i | -c | -d] [file ...]
```
The uniq command reads the specified files and compares adjacent lines, and writes a copy of each unique input line to the standard output. It supports three options where "-i" ignores the case for comparison, "-c" displays the number of times a line has been repeated, and "-d" only shows the repeated lines.



### User mode implementation
The user mode implementation of the uniq command has been given in the files `user/uniq.c` and `efunctions/uniq.c`. `user/uniq.c` contains the following functions:

Functionality | Description |
| --- | --- |
| uniq_usermode() | A wrapper for the actual uniq function   |
| parse_cmd() | Parses the issued uniq command and returns the list of files and options (as a byte) |


The `main` function is as follows:

![uniqusermain](https://github.com/gkiarashv/xv6/blob/main/images/uniqusermain.png)




### Kernel mode implementation

The kernel mode implementation of the uniq function has been given in the `kernel/sysproc.c` and `efunctions/uniq.c`. The `kernel/sysproc.c` has the `sys_uniq()`
system call which is called upon the uniq system call. The passed files and the options are the arguments passed to this system call. The `efunctions/uniq.c` contains the `head_run()` function which is the actual implementation of the uniq functionality in the kernel.

To use the uniq system call, edit the main function of the `user/uniq.c` as follows:

![uniqusermain](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelmain.png)



### Usage

See [usages](https://github.com/gkiarashv/xv6/edit/main/contributions/Sep%2012%202023/uniq_usage/).

### Logic
See [logic](https://github.com/gkiarashv/xv6/edit/main/contributions/Sep%2012%202023/uniq_logic/).


