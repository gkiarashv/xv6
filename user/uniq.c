#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#include "gelibs/etypes.h"
#include "gelibs/string.h"
#include "gelibs/file.h"
#include "efunctions/uniq.h"


#define OPT_IGNORE_CASE 1
#define OPT_SHOW_COUNT 2
#define OPT_SHOW_REPEATED_LINES 4


#define swap_pointers(x, y) {\
            void * t= x;\
            x=y;\
            y=t;\
           }




static void uniq_start(char **passedFiles, char options);
static char ** parse_cmd(int argc, char ** cmd, char * options);





int main(int argc, char ** argv){

	char options;
	char ** passedFiles = parse_cmd(argc, argv, &options);

	if (!passedFiles){
		printf("[ERR] Cannot parse the cmd");
		return 1;
	}

	/* Kernel mode */
	uniq(passedFiles,options);
	
	/* User mode */
	// uniq_start(passedFiles, options);

	return 0;

}







/* Running the usermode implementation of the head command 

[INPUT]: 
   passFiles: Passed files to the command
   options: Passed options to the command

[OUTPUT]: 

[ERROR]:
	NULL is returned.

*/
static void uniq_start(char **passedFiles, char options){

	printf("Uniq command is getting executed in user mode\n");

	/* Get number of files passed as argument*/
	char ** files = passedFiles;
	int numOfFiles=0;
	while(*files++){numOfFiles++;};

	/* Reading from STDIN */
	if(!*passedFiles)
		uniq_run(STDIN, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
	else{
		while (*passedFiles){
			int fd = open_file(*passedFiles, RDONLY);
				
			if (fd == OPEN_FILE_ERROR)
				printf("[ERR] Error opening the file \n");
			else{
				if (numOfFiles > 1) 
					printf("==> %s <==\n",*passedFiles);
				
				uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
			}
			passedFiles++;
		}
	}
}






// /* Running the actual uniq function on the file 

// [INPUT]: 
//    fd: File descriptor
//    ignoreCase: Ignore the case while comapring two lines
//    showCount: Displays the number of times a line is repeated
//    repeatedLines: Shows only repeated lines

// [OUTPUT]: 

// */
// static void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){


// 	char * line1 = malloc(MAX_LINE_LEN);
// 	char * line2 = malloc(MAX_LINE_LEN);
	
// 	int readStatus;
// 	readStatus = read_line(fd, line1);
// 	if (readStatus == READ_EOF || readStatus == READ_ERROR)
// 		return 0;

// 	int lineCount=1;
// 	int isRepeated;

// 	while(1){

// 		readStatus = read_line(fd, line2);
		
// 		if (readStatus == READ_EOF || readStatus == READ_ERROR){

// 			if (!repeatedLines){
// 				   if (showCount)
//           			printf("<%d> %s",lineCount,line1);
//         			else
//           			printf("%s",line1);
// 			}

//         break;
// 		}

// 		/* Comparing two lines */
// 		char compareStatus;

// 		if (!ignoreCase)
// 			compareStatus = compare_str(line1, line2);
// 		else
// 			compareStatus = compare_str_ic(line1, line2);


// 		/* Compare two lines */
// 		if (compareStatus != 0){ // Not equal
			
// 			if (repeatedLines){

// 				if (isRepeated){
// 						if (showCount)
// 							printf("<%d> %s",lineCount,line1);
// 						else
// 							printf("%s",line1);
// 				}
			
// 			}else{
				
// 				if (showCount)
// 					printf("<%d> %s",lineCount,line1);
// 				else
// 					printf("%s",line1);
// 			}

// 			isRepeated = 0 ;

// 			/* Reset the line count */
// 			lineCount = 1;

// 			// Swap the lines
// 			swap_pointers(line1, line2);

// 		}else	{  // Equal lines

// 			if (repeatedLines && !isRepeated){
// 				// printf("%s",line1);
// 				isRepeated=1;
// 			}

// 			lineCount++;

// 		}		
// 	}

// 	free(line1);
// 	free(line2);
// }






/* Parsing the issued command and extracting the passed arguments 

[INPUT]: 


[OUTPUT]: 

[ERROR]:

*/
static char ** parse_cmd(int argc, char ** cmd, char * options){


	/* Total number of files is maximum argc-1 requiring argc size storage for the last NULL*/
	char ** passedFiles = malloc(sizeof(char *) * (argc));

	if (!passedFiles)
		return NULL;


	*options = 0;
	int fileIdx = 0;

	cmd++;  // Skipping the program's name
	
	while(*cmd){
		if (!compare_str(cmd[0], "-c"))
			*options |= OPT_SHOW_COUNT;
		else if (!compare_str(cmd[0], "-i"))
			*options |= OPT_IGNORE_CASE;
		else if (!compare_str(cmd[0], "-d"))
			*options |= OPT_SHOW_REPEATED_LINES;
		else
			passedFiles[fileIdx++] = cmd[0];
			
		cmd++;
	}

	return passedFiles;

}







