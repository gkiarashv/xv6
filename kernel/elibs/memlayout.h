#ifndef KEMEMLAYOUT_H
#define KEMEMLAYOUT_H

#include "kernel/riscv.h"

/*

 Adjusting the memory layout needs a careful attention. Incorrect setting, leads to 
 overllaping segments which causes unexpected exception to be made by the OS.

*/


/* Maximum addressabale virtual address (640KB) */
#define USERTOP 0xa0000

/* Base address of the loaded program
Remember to adjust the start of the TEXT segment in the user.ld as well. 
*/
#define TEXT_OFFSET 0x3000


/* Parameters to control the stack memory layout 

STACK_DEFAULT_SIZE: Minimum number of pages to allocate for the stack
STACK_MEMORY_ADDR: Memory address from which it points to the stack pages.
MAX_STACK_PAGES: Maximum number of stack pages
STACK_MIN_BASE: Minimum address for the stack (minimum top)
*/
#define STACK_DEFAULT_SIZE 2
#define STACK_MEMORY_ADDR (USERTOP - STACK_DEFAULT_SIZE * PGSIZE)
#define MAX_STACK_PAGES 10
#define STACK_MIN_BASE USERTOP - MAX_STACK_PAGES * PGSIZE


/* Parameters to control the heap memory layout 

HEAP_MEMORY_ADDR: Memory address from which it points to the heap pages.
HEAP_MEMORY_MAX_ADDR: Maximum address that heap can extend to (Leaving 5 pages gap between heap and stack)
*/
#define HEAP_MEMORY_ADDR USERTOP - 50 * PGSIZE
#define HEAP_MEMORY_MAX_ADDR STACK_MIN_BASE - 5 * PGSIZE


#endif







