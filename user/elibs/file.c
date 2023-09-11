#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#include "user/etypes.h"

/* Opening a file 
[INPUT]: File's name
		 Manipulation mode

[OUTPUT]: File descriptor, -1 on error
*/
s32 open_file(u8 * filePath, s32 flag){
	s32 fd = open(filePath, flag);
	return fd;
}




s64 read_line(s32 fd, u8 * buffer){

	u8 readByte;
	s64 byteCount = 0;
	s64 readStatus;


	while((readStatus = read(fd,&readByte,1))){

		/* Error or End of File */
		if (readStatus <= 0L){
			if (byteCount == 0)
				return readStatus;
			return byteCount;
		}

		*buffer++ = readByte;
		byteCount++;

		if (readByte == '\n')
			return byteCount;
	}

	return byteCount;
}


void close_file(s32 fd){
	close(fd);
}













