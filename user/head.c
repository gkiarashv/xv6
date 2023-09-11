#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#include "user/etypes.h"
#include "user/elibs/io.h"
#include "user/elibs/string.h"
#include "user/elibs/file.h"


#define NUM_OF_LINES 14



static u8 ** parse_cmd(u32 argc, u8 ** cmd, u32 *lineCount);
u32 head_usermode(u8 **passedFiles, u32 lineCount);
void head_run(s32 fd, u32 numOfLines);


s32 main(s32 argc, u8 ** argv){




	u32 lineCount;
	u8 ** passedFiles = parse_cmd(argc,argv,&lineCount);

		
	if (!passedFiles){
		print("[ERR] Cannot parse the cmd");
		return 1;
	}


	head(passedFiles, lineCount);

	// return head_usermode(passedFiles, lineCount);



}








u32 head_usermode(u8 **passedFiles, u32 lineCount){


	/* Reading from STDIN */
	if(!passedFiles[0])
		head_run(STDIN, lineCount);
	else{
		while (*passedFiles){

			u32 fd = open_file(*passedFiles, RDONLY);
			
			if (fd == OPEN_FILE_ERROR)
				printf("Error opening the file \n");
			else
				head_run(fd , lineCount);

			passedFiles++;
		}
	}

	return 0;

}


void head_run(s32 fd, u32 numOfLines){
	
	u8 * line = malloc(500);
	s64 readStatus;

	while(numOfLines--){
		readStatus = read_line(fd, line);

		if (readStatus == READ_EOF || readStatus == READ_ERROR){
			printf("Error reading from the file \n");
			break;
		}
		line[readStatus]=0;
		printf("%s",line);
	}

}




/* Parsing the issued command and extracting the passed arguments 

[INPUT]: 
   cmd: Passed arguments to the program
   argc: Number of passed arguments to the program

[OUTPUT]: 
	lineCount: Number of lines to be printed

	Array of passed files

[ERROR]:
	NULL is returned.

*/
static u8 ** parse_cmd(u32 argc, u8 ** cmd, u32 *lineCount){

	/* Default value for lineCount */
	*lineCount = NUM_OF_LINES;

	/* Total number of files is maximum argc-1 requiring argc size storage for the last NULL*/
	u8 ** passedFiles = malloc(sizeof(u8 *) * (argc));

	if (!passedFiles){
		// *lineCount = -1;
		return NULL;
	}


	u32 fileIdx = 0;
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




