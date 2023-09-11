#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#include "user/etypes.h"
#include "user/elibs/io.h"
#include "user/elibs/string.h"
#include "user/elibs/file.h"



#define OPT_IGNORE_CASE 1
#define OPT_SHOW_COUNT 2
#define OPT_SHOW_REPEATED_LINES 4


u32 uniq_run(s32 fd, u8 ignoreCase, u8 showCount, u8 repeatedLines);
static u8 ** parse_cmd(u32 argc, u8 ** cmd, u8 * options);


s32 main(s32 argc, u8 ** argv){


	u8 options;
	u8 ** passedFiles = parse_cmd(argc, argv, &options);


	if (!passedFiles){
		print("[ERR] Cannot parse the cmd");
		return 1;
	}

	uniq(passedFiles,options);

	return 0;

}



u32 uniq_usermode(u8 **passedFiles, u8 options){

	printf("Uniq command is getting executed in user mode\n");

	/* Reading from STDIN */
	if(!passedFiles[0])
		uniq_run(STDIN, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
	else{
		while (*passedFiles){
			u32 fd = open_file(*passedFiles, RDONLY);
				
			if (fd == OPEN_FILE_ERROR)
				print("Error opening the file \n");
			else
				uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);

			passedFiles++;
		}
	}
}





/* Parsing the issued command and extracting the passed arguments 

[INPUT]: 


[OUTPUT]: 



[ERROR]:

*/
static u8 ** parse_cmd(u32 argc, u8 ** cmd, u8 * options){


	/* Total number of files is maximum argc-1 requiring argc size storage for the last NULL*/
	u8 ** passedFiles = malloc(sizeof(u8 *) * (argc));

	if (!passedFiles)
		return NULL;


	*options = 0;
	u32 fileIdx = 0;

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









u32 uniq_run(s32 fd, u8 ignoreCase, u8 showCount, u8 repeatedLines){


	u8 * line1 = malloc(500);
	u8 * line2 = malloc(500);
	
	s64 readStatus;

	readStatus = read_line(fd, line1);
	if (readStatus == READ_EOF || readStatus == READ_ERROR)
		return 0;
	line1[readStatus]=0;

	u8 first = 1;
	u32 count=1;

	while(1){

		readStatus = read_line(fd, line2);
		if (readStatus == READ_EOF || readStatus == READ_ERROR)
			break;
		line2[readStatus]=0;


		// Comparing two lines
		u8 compareStatus;

		if (!ignoreCase)
			compareStatus = compare_str(line1, line2);
		else
			compareStatus = compare_str_ic(line1, line2);


		/* Compare two lines */
		if (compareStatus != 0){

			if (first==1){

				if (showCount)
					printf("%d %s",count,line1);
				else
					printf("<> %s",line1);
				first=0;
			}
			if (showCount)
				printf("<%d> %s",count,line2);
			else
				printf("<> %s",line2);

			count = 1;


			void * t = line1;
			line1 = line2;
			line2 = t;
		}else{
			// print("EQ:\n");
			// print(line1);
			// print(line2);
			count++;
		}
	}
}


