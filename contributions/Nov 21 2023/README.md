# Summary
Level | Description |
| --- | --- |
| Kernel | Adjustable memory layout has been added |
| User | - |

### Extension Libraries (elibs)
Path | Files |
| --- | --- |
| Kernel/elibs/ | memlayout.h |
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
| kernel/ | syscall.c exec.c proc.c proc.h vm.c trap.c |
| gelibs/ | - |




# Dereferencing null pointer

To illustrate the effects of dereferencing a null pointer, we create the following code (`deref,c`):
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/deref10.png)

If we check the `deref.o` using `riscv64-linux-gnu-objdump -D -j .text deref.o`, we will see:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/derefobjdump.png)

Now, if we run the `deref` in xv6, we would get (exactly the same bytes we got from objdump):
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/linudxcode.png)

However, despite xv6, Linux uses a different memory map. Hence, running the same code will result in a segmentation fault:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/linuxrun.png)




# Changing the memory layout
To enable xv6 to have different memory layouts in which (text, stack, and heap) segments reside in different places, we have extended the functionality of xv6. This extension need a close look at various files. In the following, each modified/added file will be explained.


## kernel/elibs/memlayout.h
This file defines the parameters required to show the boundary for each segment type.

![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/memlayout.png)


## proc.h
The process structure of a process now holds 5 new field members.
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/procva.png)



## exec.c
The most important file to modify is the `exec.c` in which the page table of the process is created and is replaced with its old page table (if forked, for instance). First change is:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/execva1.png)

In the above, we have set `sz` to `TEXT_OFFSET`. This indicates that the size of the process is `TEXT_OFFSET`. Next, we set the start of the stack and heap based on the flags passed when compiling
the kernel. Note that stack and heap can come immediately after the text segment or can reside in a different place in the memory.

![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/execva2.png)


Finally, the size of the process is updated and the old page table is removed using the new `free_proc_vm()` function. This function will be discussed further while considering the `vm.c` file.
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/execva3.png)














