# Summary
Level | Description |
| --- | --- |
| Kernel | Two new system calls, uniq and head, have been added  |
| User | Two new commands, uniq and head, have been added |

### Extension libraries (elibs)
Level | Files |
| --- | --- |
| Kernel/elibs/ | string.c, file.c  |
| User/elibs/ | string.c, file.c |


### ELIBS detail


#### User/elibs/string.c
Contains the following functionalites regarding strings

Functionality | Description |
| --- | --- |
| get_strlen() | returns the length of a given string  |
| compare_str() | compares two string considering their case |
| compare_str_ic() | compares two string ignoring their case |


#### User/elibs/file.c
Contains the following functionalites for file manipualtion

Functionality | Description |
| --- | --- |
| open_file() | opens a file and returns a file descriptor  |
| read_line() | reads a line from the given file |


#### Kernel/elibs/string.c
Contains the following functionalites regarding strings

Functionality | Description |
| --- | --- |
| get_strlen() | Returns the length of a given string  |
| compare_str() | Compares two string considering their case |
| compare_str_ic() | Compares two string ignoring their case |


#### Kernel/elibs/file.c
Contains the following functionalites for file manipualtion

Functionality | Description |
| --- | --- |
| open_file() | Opens a file and returns a file descriptor  |
| read_line() | Reads a line from the given file |
| close_file() | Closes the given file |


# Extensions
To use the extensions, in the main folder of the xv6 project, run the `make` commands as follows:


`make clean`:
![makeclean](https://github.com/gkiarashv/xv6/blob/main/images/makeclean.png)

`make`:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/makekernel.png)


`make qemu`:
![makeqemu](https://github.com/gkiarashv/xv6/blob/main/images/makeqemu.png)






## Head
 ```
  head [-n numOfLines] [file ...]
 ```
The head command prints the first numOfLines lines of each of the specified files, or the standard input if no files are specified. If numOfLines is omitted it defaults to 14.
User mode implementation


### User mode implementation

The user mode implementation of the head command has been given in the file `user/head.c` . This file contains 3 main functions:

Functionality | Description |
| --- | --- |
| head_usermode() | A wrapper for the actual head function   |
| head_run() | Actual implementation for the head function |
| parse_cmd() | Parses the issued head command and returns the list of files and options |

The `main` function is as follows:

![headusermain](https://github.com/gkiarashv/xv6/blob/main/images/headusermain.png)
 



### Kernel mode implementation

```int head(char ** passedFiles, int numOfLines)```

The kernel mode implementation of the head function has been given in the `kernel/sysproc.c` and `kernel/head.c`. The `kernel/sysproc.c` has the `sys_head()`
system call which is called upon the head system call. The passed files and the options are the arguments passed to this system call. The `kernel/head.c` contains the `head_run()` function which is the actual implementation of the head functionality in the kernel.

To use the head system call, edit the main function of the `user/head.c` as follows:


![headkernelmain](https://github.com/gkiarashv/xv6/blob/main/images/headkernelmain.png)
 

### Usage

See [usages]


In the following, there are examples of how to work with the head command in the xv6 environment executed once in user mode and once in kernel mode.
Considering two example files as follows:


File1:
![file1](https://github.com/gkiarashv/xv6/blob/main/images/file1.png)

File2:
![file2](https://github.com/gkiarashv/xv6/blob/main/images/file2.png)


User mode head command:

![headuserex](https://github.com/gkiarashv/xv6/blob/main/images/headuserex.png)
![headuserstdin](https://github.com/gkiarashv/xv6/blob/main/images/headuserexstdin.png)


Kernel mode head command:
![headkernelex](https://github.com/gkiarashv/xv6/blob/main/images/headkernelex.png)
![headkernelstdin](https://github.com/gkiarashv/xv6/blob/main/images/headkernelstdin.png)




# Uniq
```
uniq [-i | -c | -d] [file ...]
```
The uniq command reads the specified files and compare adjacent lines, and writes a copy of each unique input line to the standard output. It support three options where "-i" ignores the case for comaparison, "-c" displays the number of times a line has been repeated, and "-d" only shows the repeated lines.



### User mode implementation
The user mode implementation of the uniq command has been given in the `user/uniq.c` file. This file contains the following functions:

Functionality | Description |
| --- | --- |
| uniq_usermode() | A wrapper for the actual uniq function   |
| uniq_run() | Actual implementation for the uniq function |
| parse_cmd() | Parses the issued uniq command and returns the list of files and options (as a byte) |


The `main` function is as follows:

![uniqusermain](https://github.com/gkiarashv/xv6/blob/main/images/uniqusermain.png)




### Kernel mode implementation

The kernel mode implementation of the uniq function has been given in the `kernel/sysproc.c` and `kernel/uniq.c`. The `kernel/sysproc.c` has the `sys_uniq()`
system call which is called upon the uniq system call. The passed files and the options are the arguments passed to this system call. The `kernel/uniq.c` contains the `head_run()` function which is the actual implementation of the uniq functionality in the kernel.

To use the uniq system call, edit the main function of the `user/uniq.c` as follows:

![uniqusermain](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelmain.png)


### 

In the following, there are examples of how to work with the uniq command in the xv6 environment executed once in user mode and once in kernel mode.
Considering two example files as follows:


File3:
![file3](https://github.com/gkiarashv/xv6/blob/main/images/file3.png)

File4:
![file4](https://github.com/gkiarashv/xv6/blob/main/images/file4.png)


User mode uniq command:
![uniquserex1](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex1.png)
![uniquserex2](https://github.com/gkiarashv/xv6/blob/main/images/uniquserex2.png)




Kernel mode uniq command:
![headkernelex1](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex1.png)
![headkernelex2](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex2.png)
![headkernelex3](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex3.png)
![headkernelex4](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex4.png)
![headkernelex5](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex5.png)
![headkernelex6](https://github.com/gkiarashv/xv6/blob/main/images/uniqkernelex6.png)

















