#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"


#include "gelibs/file.h"
#include "efunctions/head.h"
#include "efunctions/uniq.h"





/*

Head syscall 

  
  head(char ** files , int numOfLines);
  
*/
uint64 sys_head(void){

  printf("Head command is getting executed in kernel mode\n");


  uint64 passedFiles;
  uint64 lineCount;

  /* Fetching the first and the second arguments */
  argaddr(0, &passedFiles);
  argint(1, &lineCount);

  /* Get number of files passed as argument*/
  uint64 files = passedFiles;
  uint64 fileAddr;
  uint32 numOfFiles=0;
  fetchaddr(files, &fileAddr);
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};


  /* Fetching the first file */
  fetchaddr(passedFiles, &fileAddr);

  /* Reading from STDIN */
  if(!fileAddr)
    head_run(0, lineCount);
  else{
    
    while(fileAddr){

      char fileName[MAX_FILE_NAME_LEN];

      fetchstr(fileAddr, fileName, MAX_FILE_NAME_LEN);

      /* Open the given file */
      int fd = open_file(fileName, 0);
      
      if (fd == OPEN_FILE_ERROR)
        printf("[ERR] opening the file '%s' failed \n",fileName);
      else{
        /* Only print the header if number of files is more than 1 */
        if (numOfFiles > 1) 
          printf("==> %s <==\n",fileName);
        
        head_run(fd , lineCount);
      }

      // close_file(fd);

      passedFiles+=8;
      fetchaddr(passedFiles, &fileAddr);
    }

  }
  return 0;
}








/*

uniq syscall 

  head(char ** files , char options);


*/


#define OPT_IGNORE_CASE 1
#define OPT_SHOW_COUNT 2
#define OPT_SHOW_REPEATED_LINES 4




uint64 sys_uniq(void){

  printf("Uniq command is getting executed in kernel mode\n");


  uint64 passedFiles;
  uint64 options;

  /* Fetching the first and the second arguments */
  argaddr(0, &passedFiles);
  argint(1, &options);


  /* Get number of files passed as argument*/
  uint64 files = passedFiles;
  uint64 fileAddr;
  uint32 numOfFiles=0;
  fetchaddr(files, &fileAddr);
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};



  /* Fetching the first file */
  fetchaddr(passedFiles, &fileAddr);




  /* Reading from STDIN */
  if(!fileAddr)
    uniq_run(0, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
  else{

    while(fileAddr){

      char fileName[MAX_FILE_NAME_LEN];
      
      fetchstr(fileAddr, fileName, MAX_FILE_NAME_LEN);

      // Open the given file

      int fd = open_file(fileName, 0);

      if (fd == OPEN_FILE_ERROR)
        printf("[ERR] Error opening the file '%s' \n", fileName);
      else{
        if (numOfFiles > 1) 
          printf("==> %s <==\n",fileName);
        
        uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
      }

      // close_file(fd);

      /* Fetching the next file name */
      passedFiles+=8; // TODO
      fetchaddr(passedFiles, &fileAddr);

    }

  }
  return 0;
}















uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
