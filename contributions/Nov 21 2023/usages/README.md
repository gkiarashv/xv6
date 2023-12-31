# Usages 
To demonstrate the memory layout in xv6, we explore scenarios where different memory segments can be positioned. This is illustrated using dummy programs that help visualize the placement of these segments within the memory. Additionally, we have developed a function named `debug_pgt()` in `kernel/vm.c`. This function is designed to print the page table for the memory segments up to `640KB`, providing a clear and detailed view of how the segments are arranged and occupy the virtual memory space. 

Careful attention is needed when adjusting the boundaries of the different segments. The main configuration files are `kernel/elibs/memlayout.h` and `user/user.ld` (for the entry address of compiled programs).

Compilation flags for the stack and heap placement are: `STACK_BEGIN_AFTER_CODE` and `HEAP_BEGIN_AFTER_CODE` which put stack and heap immediately after the code, and `STACK_BEGIN_IN_MEMORY` and `HEAP_BEGIN_IN_MEMORY` which put stack and heap in memory locations specified in the `kernel/elibs/memlayout.h`.




# Debugging program
The `debug_pgt()` function is strategically inserted in three sections of the xv6 code, each commented in the xv6's code. These sections are: `exec.c/exec()` when the process's page table is created, `trap.c/usertrap()` when the stack is extended for the process, and `proc.c/growproc()` when memory is allocated from the heap.
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/debugpgt.png)



# Dummy programs

## alloc.c
This program simply allocates memory from the heap to show the heap allocation from the virtual address space
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/alloc.png)


## stack.c
This program is designed to access an address beyond the currently allocated memory for the stack. 
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/stack.png)


## dummy.c
This program is only a dummy program that only prints a message. However, the intention behind this was to create a large program to illustrate the number
of pages allocated for the `TEXT` segment in the memory. This program is large, hence we refuse to show an image.




# Usage 1:
In this example, we place the text segment to start from the address `TEXT_OFFSET=0x3000`. Then immediately after the code, we allocate 2 pages for stack (one is stack guard). Following the stack, we would have our heap. To compile the kernel with this setting, we can either compile it as default settings:
```
make
```
or 
```
make STACK_VA=STACK_BEGIN_AFTER_CODE HEAP_VA=HEAP_BEGIN_AFTER_CODE
```

Now, considering different commands:

## ls
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/lsva1.png)

## head file1
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/headva1.png)

## uniq file1
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/uniqva1.png)

## dummy
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/dummyva1.png)
Check the number of pages allocated for the text segment.

## alloc
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/allocva1.png)

## stack
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/stackva1.png)

## ps
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/psva11.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/psva12.png)



# Usage 2:
In this example, we place the text segment to start from the address `TEXT_OFFSET=0x3000`. Then we allocate 2 pages for stack (one is stack guard). We put the stack at the end of the virtual address space. Following the code segment, we would have our heap. To compile the kernel with this setting, we should compile it as follows:

```
make STACK_VA=STACK_BEGIN_IN_MEMORY HEAP_VA=HEAP_BEGIN_AFTER_CODE
```
or leave the heap's setting untouched:
```
make STACK_VA=STACK_BEGIN_IN_MEMORY
```
The address of the stack can be configured in the `kernel/elibs/memlayout.h` file.

## ls
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/lsva3.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/lsva2.png)


## head file1
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/headva21.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/headva22.png)


## uniq file1
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/uniqva21.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/uniqva22.png)

## dummy
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/dummyva21.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/dummyva22.png)


## alloc
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/allocva21.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/allocva22.png)


## stack
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/stackva21.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/stackva22.png)

## ps
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/psva21.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/psva22.png)




# Usage 3:
In this example, we place the text segment to start from the address `TEXT_OFFSET=0x3000`. Then we allocate 2 pages for stack (one is stack guard). We put the stack at the end of the virtual address space. Then, we will put the heap in a location specified in the `kernel/elibs/memlayout.h`. To compile the kernel with this setting, we should compile it as follows:

```
make STACK_VA=STACK_BEGIN_IN_MEMORY HEAP_VA=HEAP_BEGIN_IN_MEMORY
```

Now, considering different commands:

## ls
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/lsva31.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/lsva32.png)


## head file1
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/headva31.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/headva32.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/headva33.png)


## uniq file1
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/uniqva31.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/uniqva32.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/headva33.png)

## dummy
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/dummyva31.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/dummyva32.png)

## alloc
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/allocva31.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/allocva32.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/allocva33.png)


## stack
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/stackva31.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/stackva32.png)

## ps
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/psva31.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/psva32.png)



# Usage 4:
In this example, we place the text segment to start from the address `TEXT_OFFSET=0x3000`. Then we allocate 2 pages for stack (one is stack guard). We put the stack immediately after the code segment. Then, we will put the heap in a location specified in the `kernel/elibs/memlayout.h`. To compile the kernel with this setting, we should compile it as follows:

```
make HEAP_VA=HEAP_BEGIN_IN_MEMORY
```

Now, considering different commands:

## ls
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/lsva41.png)


## head file1
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/headva41.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/headva42.png)


## uniq file1
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/uniqva41.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/uniqva42.png)


## dummy
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/dummyva41.png)


## alloc
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/allocva41.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/allocva42.png)


## stack
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/stackva41.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/stackva42.png)



## ps
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/psva41.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/psva42.png)




# Usage 5
The kernel can be compiled with more options. In the previous updates to xv6, we added the support for scheduling algorithms of FCFS, Priority scheduling, and default xv6. The `SCHED` option can be used along with `STACK_VA` and `HEAP_VA` as well. For instance:

```
make STACK_VA=STACK_BEGIN_IN_MEMORY HEAP_VA=HEAP_BEGIN_IN_MEMORY SCHED=FCFS
```

```
make STACK_VA=STACK_BEGIN_IN_MEMORY SCHED=PS
```

The slight change in the program's execution time compared to previous runs in the latest update is understandable, given the introduction of new functions for tasks like copying page tables and allocating additional memory for the stack. However, it's important to note that, in general, memory layout management and CPU scheduling are distinct aspects and do not directly influence each other. Additionally, the xv6 loads the whole program into memory in the `exec.c/exec()`, and hence no page swapping is happened that can be affected by the scheduling algorithm.




