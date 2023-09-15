#include "kernel/types.h"
#include "kernel/riscv.h"
#include "kernel/defs.h"
#include "kernel/param.h"
#include "kernel/stat.h"
#include "kernel/spinlock.h"
#include "kernel/proc.h"
#include "kernel/fs.h"
#include "kernel/sleeplock.h"
#include "kernel/file.h"
#include "kernel/fcntl.h"


extern int read_pipe(struct pipe *pi, uint64 addr, int n);


// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *p = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] == 0){
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}


static struct inode*
create(char *path, short type, short major, short minor)
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;

  ilock(dp);

  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      goto fail;
  }

  if(dirlink(dp, name, ip->inum) < 0)
    goto fail;

  if(type == T_DIR){
    // now that success is guaranteed:
    dp->nlink++;  // for ".."
    iupdate(dp);
  }

  iunlockput(dp);

  return ip;

 fail:
  // something went wrong. de-allocate ip.
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}






/* Opening a file 
[INPUT]: 
  filePath: File's path
  omode: Manipulation mode

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * path, int omode){

  int fd;
  struct file *f;
  struct inode *ip;
  int n;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
      iunlockput(ip);
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    f->off = 0;
  }
  f->ip = ip;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  if((omode & O_TRUNC) && ip->type == T_FILE){
    itrunc(ip);
  }

  iunlock(ip);
  end_op();

  return fd;


}




/* Reads a line from the given file
[INPUT]: 
  fd: File discriptor
  buffer: Buffer for writing the line into


[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){

  struct file *f;

  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    return -1;

  char readByte;
  int byteCount = 0;
  int readStatus;

  /* Reading from STDIN as a special case. There are two cases for reading:
    1: Reading from the pipe
    2: Reading from stdin (not piped)
   */
  if (!fd){ 

    int idx = 0;
    int newLine = 0;
    int readStatus;

    if (f->pipe){

      while(1){
        readStatus = read_pipe(f->pipe,(uint64)buffer+idx,1);

        if (readStatus<= 0){
          if (idx!=0){
            buffer[idx] = '\n';
            buffer[idx+1]=0;
            return idx+1;
          }
          return 0;
        }

        if (buffer[idx]=='\n'){
          buffer[idx+1]=0;
          newLine = 1;
          return idx+1;
        }
        idx++;
      }

    }else{


      while((readStatus=devsw[f->major].read(0, (uint64)buffer+idx, 1)) == 1){ // The first 0 indicates kernel address
        
        if (buffer[idx]=='\n'){
          buffer[idx+1]=0;
          newLine = 1;
          break;
        }
        idx++;
      }
      if (!newLine)
        buffer[idx]=0;

    }

  }else{

      while(1){

        readStatus = readi(f->ip, 0, (uint64)&readByte, f->off, 1);

        if (readStatus > 0)
          f->off += readStatus;
        
        else {         /* Error or End of File */
          
          if (byteCount!=0){
            *buffer = '\n';
            *(buffer+1)=0;
            return byteCount+1;
          }
          return 0; 
        }

        *buffer++ = readByte;
        byteCount++;

        if (readByte == '\n'){
            *(buffer)=0; // Nullifying the end of the string
          return byteCount;
        }

    }

  }

}

/* Closes the file
[INPUT]: 
  fd: File discriptor

[OUTPUT]:

*/
void close_file(struct file *f){
  fileclose(f);
}

