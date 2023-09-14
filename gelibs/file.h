#ifndef EKFILE_H
#define EKFILE_H

// #include "kernel/file.h"


#define RDONLY 0 
#define READ_ERROR -1
#define READ_EOF 0

#define STDIN 0
#define STDOUT 1
#define STDERR 2


#define OPEN_FILE_ERROR -1
#define MAX_LINE_LEN 500
#define MAX_FILE_NAME_LEN 100


// struct file {
//   enum { FD_NONE, FD_PIPE, FD_INODE, FD_DEVICE } type;
//   int ref; // reference count
//   char readable;
//   char writable;
//   struct pipe *pipe; // FD_PIPE
//   struct inode *ip;  // FD_INODE and FD_DEVICE
//   uint off;          // FD_INODE
//   short major;       // FD_DEVICE
// };


int open_file(char * path, int omode);
int read_line(int fd, char * buffer);
void close_file(int fd);


#endif
