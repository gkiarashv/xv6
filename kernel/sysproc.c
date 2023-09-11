#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

// #include "fcntl.h"
// #include "stat.h"
// // #include "file.h"
// #include "fs.h"

// struct inode {
//   uint dev;           // Device number
//   uint inum;          // Inode number
//   int ref;            // Reference count
//   struct sleeplock lock; // protects everything below here
//   int valid;          // inode has been read from disk?

//   short type;         // copy of disk inode
//   short major;
//   short minor;
//   short nlink;
//   uint size;
//   uint addrs[NDIRECT+1];
// };



// static void head_kernel_run(int fd, int lineCount){
//   printf("running on file \n");
// }



extern int open_file(char * path, int omode);

extern int read_line(int fd, char * buffer);

extern void head_run(int fd, int numOfLines);

int uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines);

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


  uint64 fileAddr;

  fetchaddr(passedFiles, &fileAddr);

  /* Reading from STDIN */
  if(!fileAddr){
    head_run(0, lineCount);
    printf("Reading from stdin");
  }
  else{
    printf("here %x\n",fileAddr);
    
    while(fileAddr){

      char fileName[100];
      fetchstr(fileAddr, fileName, 100);

      // Open the given file
      // struct file * f;
      // printf("%s\n",fileName);
      int fd = open_file(fileName, 0);
      
      head_run(fd, lineCount);

      // printf(">> %d\n",fd);

      // char line[200]={0};

      // int x = read_line(fd,line);
      // line[x]=0;
      // // head_kernel_run(12,12);
      // printf(">> %s\n",line);

      // x=read_line(fd,line);
      // line[x]=0;
      // // head_kernel_run(12,12);
      // printf(">> %s\n",line);


      // printf("%d\n",fd);

      // Fetching the next file name
      passedFiles+=8;
      fetchaddr(passedFiles, &fileAddr);

    }

  }

// while (*passedFiles){

//       u32 fd = open_file(*passedFiles, RDONLY);
      
//       if (fd == OPEN_FILE_ERROR)
//         printf("Error opening the file \n");
//       else
//         head_run(fd , lineCount);

//       passedFiles++;
//     }


  // Checking the 


  // uint64 p;
  // argaddr(0, &p);

  // // char ** argv = (char **)p;

  // char path[100];
  // int fd, omode;
  // struct file *f;
  // struct inode *ip;
  // int n;

  // // argint(1, &omode);
  // // argstr(0, path, 100);
  
  // uint64 addr;
  // // argaddr(n, &addr);
  // fetchaddr(p+8,&addr);
  // fetchstr(addr, path, 100);


  // printf("%s,\n",path);


  // hh(path);


  // printf("%s",((char **)p)[0] );
  return 0;
}

/*

Head syscall 

  head(char ** files , int numOfLines);


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

  printf("%d\n",options);

  uint64 fileAddr;

  fetchaddr(passedFiles, &fileAddr);

  /* Reading from STDIN */
  if(!fileAddr){
    // head_run(0, lineCount);
    printf("Reading from stdin");
  }
  else{

    
    while(fileAddr){

      char fileName[100];
      fetchstr(fileAddr, fileName, 100);

      // Open the given file
      // struct file * f;
      // printf("%s\n",fileName);
      int fd = open_file(fileName, 0);

      uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
      // printf(">> %s\n",fileName);
      // head_run(fd, lineCount);

      // printf(">> %d\n",fd);

      // char line[200]={0};

      // int x = read_line(fd,line);
      // line[x]=0;
      // // head_kernel_run(12,12);
      // printf(">> %s\n",line);

      // x=read_line(fd,line);
      // line[x]=0;
      // // head_kernel_run(12,12);
      // printf(">> %s\n",line);


      // printf("%d\n",fd);

      // Fetching the next file name
      passedFiles+=8;
      fetchaddr(passedFiles, &fileAddr);

    }

  }

// while (*passedFiles){

//       u32 fd = open_file(*passedFiles, RDONLY);
      
//       if (fd == OPEN_FILE_ERROR)
//         printf("Error opening the file \n");
//       else
//         head_run(fd , lineCount);

//       passedFiles++;
//     }


  // Checking the 


  // uint64 p;
  // argaddr(0, &p);

  // // char ** argv = (char **)p;

  // char path[100];
  // int fd, omode;
  // struct file *f;
  // struct inode *ip;
  // int n;

  // // argint(1, &omode);
  // // argstr(0, path, 100);
  
  // uint64 addr;
  // // argaddr(n, &addr);
  // fetchaddr(p+8,&addr);
  // fetchstr(addr, path, 100);


  // printf("%s,\n",path);


  // hh(path);


  // printf("%s",((char **)p)[0] );
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
