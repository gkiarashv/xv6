#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "user/etypes.h"



/* Opening a file 
[INPUT]: 
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
	int fd = open(filePath, flag);
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

	char readByte;
	int byteCount = 0;
	int readStatus;

	while(1){

		readStatus = read(fd,&readByte,1);

		if (readStatus == 0){
			if (byteCount!=0){
				*buffer = '\n';
				*(buffer+1)=0;
				return byteCount+1;
			}
			return 0;
		}


		// /* Error or End of File */
		// if (readStatus <= 0){
		// 	// *buffer++ = '\n';  
		// 	// *buffer = 0; // Nullifying the end of the string
		// 	/* If we encounter EOF or error and we have not read anything, return the status code.
		// 	It represents the EOF and error itself.*/
		// 	if (byteCount == 0)
		// 		return readStatus; 
			
		// 	*buffer = '\n';
		// 	*(buffer+1)=0;
		// 	return byteCount; 
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
			*buffer = 0;  // Nullifying the end of the string
			return byteCount;
		}
	}
}



/* Closes the file
[INPUT]: 
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
	close(fd);
}













