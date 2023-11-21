# Summary
Level | Description |
| --- | --- |
| Kernel | Adjustable memory layout has been added |
| User | Testing commands have been added (deref, dummy, stack, and alloc) |

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



# Compilation
To compile the extensions and integrate them with the xv6 OS, in the main folder of the xv6 project, run the `make` commands as follows:


`make clean`:
![makeclean](https://github.com/gkiarashv/xv6/blob/main/images/makeclean4.png)

`make [SCHED=(FCFS|PS|DEF)] STACK_VA=(STACK_BEGIN_AFTER_CODE|STACK_BEGIN_IN_MEMORY) HEAP_VA=(HEAP_BEGIN_AFTER_CODE|HEAP_BEGIN_IN_MEMORY)]`:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/make4.png)

`make qemu`:
![makeqemu](https://github.com/gkiarashv/xv6/blob/main/images/makeqemu4.png)



# Note
xv6 RISCV uses 3 levels for the implementation of the page table:
![makeqemu](https://github.com/gkiarashv/xv6/blob/main/images/xv6pgtlvls.png)




# Dereferencing null pointer

To illustrate the effects of dereferencing a null pointer, we create the following code (`deref.c`):
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/linudxcode.png)


If we check the `deref.o` using `riscv64-linux-gnu-objdump -D -j .text deref.o`, we will see:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/derefobjdump.png)

If we run the `deref` in xv6, we would get exactly the same bytes we got from objdump. The `main` is the entry point and is mapped to address 0:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/deref10.png)

However, despite xv6, Linux uses a different memory map. Hence, running the same code will result in a segmentation fault:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/linuxrun.png)




# Changing the memory layout
To facilitate different memory layouts in xv6, where segments like text, stack, and heap are located in various positions, we have expanded xv6's capabilities. This enhancement requires careful examination of several files. Below, we will explain each file that has been modified or added. For the usages, check the [folder](https://github.com/gkiarashv/xv6/tree/main/contributions/Nov%2021%202023/usages).



## kernel/elibs/memlayout.h (Added)
This file specifies the necessary parameters to delineate the boundaries for each segment type. For instance, it sets the parameters for the last accessible address in the virtual address space, indicated by `USERTOP`. Additionally, it outlines the starting and ending points of the code segment as `TEXT_OFFSET` along with stack and heap, as well as the minimum number of pages that might need to be allocated.
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/memlayout.png)


## proc.h (Modified)
The process structure has been updated to include five new field members. These additional fields store information regarding the size of the code segment, the starting addresses of the heap and stack, and the number of pages allocated for both the heap and stack segments.
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/procva.png)


## exec.c (Modified)
The key file to update is `exec.c`, where the page table for the process is established and replaces its previous page table (as in the case of forking, for example). The initial modification involves setting the `sz` variable's initial value to `TEXT_OFFSET`. This adjustment indicates that the process's initial size commences from `TEXT_OFFSET`. However, the first set of pages will remain unmapped:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/execva1.png)

Following that, we determine the starting points of the stack and heap based on the flags used during the kernel compilation. It's important to note that the stack and heap can either directly follow the text segment or be located in a different area of the memory, depending on these compilation flags.
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/execva22.png)

Ultimately, the size of the process is updated, and the old page table is discarded using the newly implemented `free_proc_vm()` function. This function will be examined in more detail when we discuss the modifications made to the `vm.c` file.
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/execva3.png)




## vm.c (Modified)
In `vm.c`, a new function, `free_proc_vm()`, has been introduced to free the page table of a process. The rationale for creating this new function, rather than using the existing `proc_freepagetable()`, stems from the fact that the current function can only free contiguous memory allocations within the page table. Given that the allocated pages for different segments may be dispersed across multiple locations in memory, there is a clear need for this new function to handle such non-contiguous memory allocations.
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/freeprocvm2.png)

Additionally, for the same reason, we have developed the `fork_pgt()` function. This is in addition to the `uvmcopy()` function which is only used for copying the text segment. `fork_pgt()` is specifically designed to copy page tables between two processes (parent and child) and will be utilized in the `fork()` system call. 
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/forkpgt.png)

Furthermore, it's necessary to modify the `uvmcopy()` function so that it begins copying the text segment from the `TEXT_OFFSET`.
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/uvmcopy.png)

In addition, a new function called `uvmunclear()`, as a counterpart to `uvmclear()`, has been introduced. The purpose of `uvmunclear()` is to make a Page Table Entry (PTE) accessible in the page table.
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/uvmunclear.png)



## proc.c (Modified)
When forking a process, the parent's page table is copied into the child's page table. Given that the allocated memory in the parent can be non-contiguous, it's crucial to have a function that considers this while copying the page tables. To address this need, we utilize the `fork_pgt()` function within the `fork()` function. 
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/forkva1.png)

Additionally, when a process structure is being freed (`freeproc()`), it's essential to free its page table using the `free_proc_vm()` function.
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/freeproc.png)

In the final aspect, concerning the allocation of heap space, the `malloc()` function is implemented using the `sys_sbrk()` system call. However, there's a slight modification in `sys_sbrk()`: instead of starting the allocation from the end of the process's code segment, it begins at the address indicated by the `heapva` field in the process structure.
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/sysbrk.png)

Moreover, the `growproc()` function, which is responsible for allocating memory from the virtual address space, needs to be changed as follows to make sure the allocation is made from the space pointed by `heapva`:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/growproc.png)


## trap.c (Modified)
Occasionally, a process accessing an invalid address can signify that it requires additional memory. For example, when a process reaches the stack guard, it typically indicates a need for more stack memory. To accommodate this requirement, we must manage the page fault caused by the invalid address in the following manner:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/trap.png)


## syscall.c (Modified)
One of the minor changes is the `fetchaddr()` function. Since the memory layout has been changed, the address from which it is fetching should be changed as well:
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/fetchaddr.png)









