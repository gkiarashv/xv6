#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "gelibs/file.h"

extern int read_line(int fd, char * buffer);

void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
			printf("[ERR] Error reading from the file \n");
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);

	}
}






