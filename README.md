# xv6 operating system updates

A repository that contributes to the existing [xv6](https://pdos.csail.mit.edu/6.828/2012/xv6.html) operating system. Particularly, we have contributed to the RISC-V based implementation of this ([xv6-riscv](https://github.com/mit-pdos/xv6-riscv)). 


# Table of contents

- [XV6](#xv6)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

# xv6

xv6 is a re-implementation of Dennis Ritchie's and Ken Thompson's Unix
Version 6 (v6).  xv6 loosely follows the structure and style of v6,
but is implemented for a modern RISC-V multiprocessor using ANSI C.

ACKNOWLEDGMENTS

xv6 is inspired by John Lions's Commentary on UNIX 6th Edition (Peer
to Peer Communications; ISBN: 1-57398-013-7; 1st edition (June 14,
2000)).  See also https://pdos.csail.mit.edu/6.1810/, which provides
pointers to on-line resources for v6.

The following people have made contributions: Russ Cox (context switching,
locking), Cliff Frey (MP), Xiao Yu (MP), Nickolai Zeldovich, and Austin
Clements.

We are also grateful for the bug reports and patches contributed by
Takahiro Aoyagi, Silas Boyd-Wickizer, Anton Burtsev, carlclone, Ian
Chen, Dan Cross, Cody Cutler, Mike CAT, Tej Chajed, Asami Doi,
eyalz800, Nelson Elhage, Saar Ettinger, Alice Ferrazzi, Nathaniel
Filardo, flespark, Peter Froehlich, Yakir Goaron, Shivam Handa, Matt
Harvey, Bryan Henry, jaichenhengjie, Jim Huang, Matúš Jókay, John
Jolly, Alexander Kapshuk, Anders Kaseorg, kehao95, Wolfgang Keller,
Jungwoo Kim, Jonathan Kimmitt, Eddie Kohler, Vadim Kolontsov, Austin
Liew, l0stman, Pavan Maddamsetti, Imbar Marinescu, Yandong Mao, Matan
Shabtay, Hitoshi Mitake, Carmi Merimovich, Mark Morrissey, mtasm, Joel
Nider, Hayato Ohhashi, OptimisticSide, Harry Porter, Greg Price, Jude
Rich, segfault, Ayan Shafqat, Eldar Sehayek, Yongming Shen, Fumiya
Shigemitsu, Cam Tenny, tyfkda, Warren Toomey, Stephen Tu, Rafael Ubal,
Amane Uehara, Pablo Ventura, Xi Wang, WaheedHafez, Keiichi Watanabe,
Nicolas Wolovick, wxdao, Grant Wu, Jindong Zhang, Icenowy Zheng,
ZhUyU1997, and Zou Chang Wei.



# Installation

1. Installing QEMU (Quick Emulator)
   ```sh
   sudo apt-get install qemu-system-arm qemu-efi
   ```

2. Update the virtual/physical Linux OS
   ```sh
   sudo apt update
   sudo apt upgrade -y
   ```
3. Installing required tools
   ```sh
   sudo apt install git wget curl vim qemu build-essential gdb-multiarch qemu-system-misc \
   gcc-riscv64-linux-gnu \ 
   binutils-riscv64-linux-gnu
   ```

4. Clonning the xv6 repository
   ```sh
   git clone https :// github .com/mit -pdos/xv6 -riscv
   cd xv6 -riscv
   ```
5. Building the kernel
   ```sh
   make
   ```

6. Booting xv6
   ```sh
   make qemu
   ```
If every previous step is successul, the xv6 is running and you can issue `ls`.




# Contributions
All the previous contributions have been classified by their date of accomplishment.


## Sep 12 2023

### Summary
Level | Description |
| --- | --- |
| Kernel | Two new system calls, uniq and head, have been added  |
| User | Two new commands, uniq and head, have been added |

### Extension libraries (elibs)
Level | Files |
| --- | --- |
| Kernel/elibs/ | string.c, file.c  |
| User/elibs/ | string.c, file.c |

#### User/elibs/string.c
Contains the following functionalites regarding strings

Functionality | Description |
| --- | --- |
| get_strlen() | returns the length of a given string  |
| compare_str() | compares two string considering their case |
| compare_str_ic() | compares two string ignoring their case |


#### User/elibs/string.c
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


#### Kernel/elibs/string.c
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




# Usage



# Contributing
Your contributions are always welcome! Please have a look at the [contribution guidelines](CONTRIBUTING.md) first. :tada:

# License
The MIT License (MIT) 2017 - [Athitya Kumar](https://github.com/athityakumar/). Please have a look at the [LICENSE.md](LICENSE.md) for more details.



You will need a RISC-V "newlib" tool chain from
https://github.com/riscv/riscv-gnu-toolchain, and qemu compiled for
riscv64-softmmu.  Once they are installed, and in your shell
search path, you can run "make qemu".
