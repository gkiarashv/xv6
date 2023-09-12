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









