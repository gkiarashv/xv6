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









