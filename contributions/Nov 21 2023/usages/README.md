# Usages 
To illustrate the xv6 memory layout, we consider different cases in which we can place different segments. Through showing these cases, we have considered dummy programs 
which can illustrate where in the memory these segments reside. Moreover, we have designed a function `debug_pgt()` in the `kernel/vm.c` which print the page table for the memory segments up to `640KB`.


# Debugging program
The `debug_gpt()` function has been placed in 3 different places (commented): `exec.c/exec()` when the process's page table is created,`trap.c/usertrap()` when the stack is extended for the process, and `proc.c/growproc()` when memory is allocated from the heap.

![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/debugpgt.png)


# Dummy programs

## alloc.c
This program simply allocates memory from the heap to show the heap allocation from the virtual address space
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/alloc.png)


## stack.c
This program is designed to access an address beyond the currently allocate memory for the stack. 
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/stack.png)


## dummy.c
This program only is a dummy program which does nothing but printing. However, the intention behind this was to create a large program to illustrate the number
of pages which will be allocated for the `TEXT` segment in the memory. This program is large, hence we refuse to show an image.




# Usage 1:
In this example, we place the `TEXT` segment to start from address 0x3000. Then immediately after the code, we allocate 2 pages for stack (one is stack guard). Following the stack, we would have our heap. To compile the kernel with this setting, we can either compile it as default settings:
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

## alloc
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/allocva1.png)

## stack
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/stackva1.png)

## ps
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/psva11.png)
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/psva12.png)



# Usage 2:
In this example, we place the `TEXT` segment to start from address 0x3000. Then we allocate 2 pages for stack (one is stack guard). We put the stack at the end of the virtual address space. Following the code segment, we would have our heap. To compile the kernel with this setting, we should compile it as follows:

```
make STACK_VA=STACK_BEGIN_IN_MEMORY HEAP_VA=HEAP_BEGIN_AFTER_CODE
```
or leave the heap's setting untouched:
```
make STACK_VA=STACK_BEGIN_IN_MEMORY
```
The address of the stack can be configured in the `kernel/elibs/memlayout.h` file.

Now, considering different commands:

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
In this example, we place the `TEXT` segment to start from address 0x3000. Then we allocate 2 pages for stack (one is stack guard). We put the stack at the end of the virtual address space. Then, we will put the heap in a location specified in the `kernel/elibs/memlayout.h`. To compile the kernel with this setting, we should compile it as follows:

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
In this example, we place the `TEXT` segment to start from address 0x3000. Then we allocate 2 pages for stack (one is stack guard). We put the stack immediately aftet the code segment. Then, we will put the heap in a location specified in the `kernel/elibs/memlayout.h`. To compile the kernel with this setting, we should compile it as follows:

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



