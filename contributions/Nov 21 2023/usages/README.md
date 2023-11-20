# Usages 
To illustrate the xv6 memory layout, we consider different cases in which we can place different segments. Through showing these cases, we have considered dummy programs 
which can illustrate where in the memory these segments reside. Moreover, we have designed a function `debug_pgt()` in the `kernel/vm.c` which print the page table for the memory
segments up to `640KB`.


# Debugging program
![makekernel](https://github.com/gkiarashv/xv6/blob/main/images/linuxrun.png)


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




