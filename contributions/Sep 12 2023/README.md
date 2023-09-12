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
| get_strlen() | returns the length of a given string  |
| compare_str() | compares two string considering their case |
| compare_str_ic() | compares two string ignoring their case |


#### Kernel/elibs/file.c
Contains the following functionalites for file manipualtion

Functionality | Description |
| --- | --- |
| open_file() | opens a file and returns a file descriptor  |
| read_line() | reads a line from the given file |


-----
### Commands
The added commands are as follows:

#### head
```
head [-n numOfLines] [file ...]
```
The head command prints the first numOfLines lines of each of the specified files, or of the standard input if no files are specified.  If numOfLines is omitted it defaults to 14.


#### uniq
```
uniq [-i | -c | -d] [file ...]
```
The uniq command reads the specified files and compare adjacent lines, and writes a copy of each unique input line to the standard output.
It support three options where "-i" ignores the case for comaparison, "-c" displays the number of times a line has been repeated, and "-d" only shows the repeated lines.




### System calls
The added system calls are as follows:

#### head
```
int head(char ** passedFiles, int numOfLines)
```
"passedFiles" is an array of files that have been provided and "numOfLines" is the number of lines to be printed.


#### uniq
```
int uniq(char ** passedFiles, char options)
```
"passedFiles" is an array of files that have been provided and "options" is the options that have been passed in the command line.

