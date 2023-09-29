#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#include "gelibs/string.h"
#include "gelibs/file.h"
#include "gelibs/etypes.h"
#include "gelibs/time.h"



#define NUM_OF_LINES 14


extern void head_run(int fd, int numOfLines);

static char ** parse_cmd(int argc, char ** cmd, int *lineCount);
void head_usermode(char **passedFiles, int lineCount);





int main(int argc, char ** argv){

	int lineCount;
	char ** passedFiles = parse_cmd(argc,argv,&lineCount);

	if (!passedFiles){
		printf("[ERR] Cannot parse the issued command\n");
		return 1;
	}

	/* Kernel mode */
	// head(passedFiles, lineCount);
	
	/* User mode */
	head_usermode(passedFiles, lineCount);

	return 0;
}







/* Running the usermode implementation of the head command 

[INPUT]: 
   passFiles: Passed files to the command
   lineCount: Number of lines to be printed

[OUTPUT]: 

[ERROR]:
*/
void head_usermode(char **passedFiles, int lineCount){

	printf("Head command is getting executed in user mode\n");

	/* Get number of files passed as argument*/
	char ** files = passedFiles;
	int numOfFiles=0;
	while(*files++){numOfFiles++;};


	/* Reading from STDIN */
	if(!*passedFiles)
		head_run(STDIN, lineCount);
	else{
		while (*passedFiles){
			int fd = open_file(*passedFiles, RDONLY);

			if (fd == OPEN_FILE_ERROR)
				printf("[ERR] opening the file '%s' failed \n",*passedFiles);
			else{
				/* Only print the header if number of files is more than 1 */
				if (numOfFiles > 1) 
					printf("==> %s <==\n",*passedFiles);
				
				head_run(fd , lineCount);
			}
			close_file(fd);
			passedFiles++;
		}
	}

	return 0;

}


/* Parsing the issued head command and extracting the passed arguments 

[INPUT]: 
   cmd: Passed arguments to the program
   argc: Number of passed arguments to the program

[OUTPUT]: 
	lineCount: Number of lines to be printed

	Array of passed files

[ERROR]:
	NULL is returned.

*/
static char ** parse_cmd(int argc, char ** cmd, int *lineCount){

	/* Default value for lineCount */
	*lineCount = NUM_OF_LINES;

	/* Total number of files is maximum argc-1 requiring argc size storage for the last NULL*/
	char ** passedFiles = malloc(sizeof(char *) * (argc));

	if (!passedFiles){
		// *lineCount = -1;
		return NULL;
	}


	int fileIdx = 0;
	cmd++;  // Skipping the program's name
	
	while(*cmd){
		if (!compare_str(cmd[0], "-n")){
			cmd++;
			*lineCount = atoi(cmd[0]);
		}
		else
			passedFiles[fileIdx++] = cmd[0];
			
		cmd++;
	}

	passedFiles[fileIdx]=NULL;

	return  passedFiles;
}




