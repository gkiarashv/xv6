#ifndef EFILE_H
#define EFILE_H

#include "kernel/fcntl.h"
#include "user/etypes.h"


#define RDONLY O_RDONLY 
#define READ_ERROR -1
#define READ_EOF 0


#define STDIN 0
#define STDOUT 1
#define STDERR 2

#define OPEN_FILE_ERROR -1

s32 open_file(u8 * filePath, s32 flag);
s64 read_line(s32 fd, u8 * buffer);


#endif
