# Extending xv6 OS

A repository that contributes to the existing [xv6](https://pdos.csail.mit.edu/6.828/2012/xv6.html) operating system. Particularly, we have contributed to the RISC-V based implementation of this ([xv6-riscv](https://github.com/mit-pdos/xv6-riscv)) ran on Ubuntu 22.04 ARM64.




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
   git clone https://github.com/mit-pdos/xv6-riscv
   cd xv6-riscv
   ```
5. Building the kernel
   ```sh
   make clean
   make
   ```

6. Booting xv6
   ```sh
   make qemu
   ```
If every previous step is successful, the xv6 is running and you can issue `ls`.


# Contributions and Usages
All the previous contributions have been classified by their date of accomplishment and can be found in the contributions [folder](https://github.com/gkiarashv/xv6/tree/main/contributions/Sep%2012%202023).


# Authors
- Name: Kiarash Sedghi ([Website](https://gkiarashv.github.io))
- Email: kiarashs@usf.edu

# Team
- Kiarash Sedghi
- Moloud Esmaeili
- Parsa Khorrmi

# Resources
- https://github.com/zamanighazaleh/xv6-kernel-system-call


# License
The MIT License (MIT) 2017 - [Athitya Kumar](https://github.com/athityakumar/). Please have a look at the [LICENSE.md](LICENSE.md) for more details.



