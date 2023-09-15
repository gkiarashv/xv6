#include "kernel/types.h"
#include "kernel/riscv.h"
#include "kernel/defs.h"
#include "gelibs/file.h"
#include "gelibs/string.h"


#define swap_pointers(x, y) {\
            void * t= x;\
            x=y;\
            y=t;\
           }


/* Running the actual uniq function on the file 

[INPUT]: 
   fd: File descriptor
   ignoreCase: Ignore case option which ignore the case while comapring two lines
   showCount: showCount option which displays the number of times a line is repeated
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){

  char buffer1[MAX_LINE_LEN];
  char buffer2[MAX_LINE_LEN];
  
  /* For later swapping the lines */
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);


  if (readStatus == READ_ERROR)
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){

    /* Holding number of times a line is repeated */
    int lineCount=1;

    /* Check if the previous line was repeated. This helps us to print
       the count of that line when reaching a different line.
     */
    int isRepeated; 

    while(1){

        readStatus = read_line(fd, line2);

        // printf(">> %s %d %d\n",line2, get_strlen(line2),readStatus);

        if (readStatus == READ_EOF){

            /* Decide for the last line */
                
            if (repeatedLines){
                
                /* Check if line1 was repeated */
                if (isRepeated){
                    if (showCount)
                      printf("<%d> %s",lineCount,line1);
                    else
                      printf("%s",line1);
                }

              }else{
                if (showCount)
                  printf("<%d> %s",lineCount,line1);
                else
                  printf("%s",line1);
            }
          break;
        }

        if (readStatus == READ_ERROR){
          printf("[ERR] Error reading from the file");
          break;
        }

        /* Comparing two lines */
        char compareStatus;
        if (!ignoreCase)
          compareStatus = compare_str(line1, line2);
        else
          compareStatus = compare_str_ic(line1, line2);

        /* Not equal lines (line1 != line2) */
        if (compareStatus != 0){ 
          
          if (repeatedLines){

            /* Check if line1 was repeated */
            if (isRepeated){
                if (showCount)
                  printf("<%d> %s",lineCount,line1);
                else
                  printf("%s",line1);
            }
          }else{

            if (showCount)
              printf("<%d> %s",lineCount,line1);
            else
              printf("%s",line1);
        }

        /* Disable isRepeated as we have encountered a new line in line2 */
        isRepeated = 0 ;

        /* Reset the line count */
        lineCount = 1;

        /* Swap the lines as we always read into line2. */
        swap_pointers(line1, line2);

        }else {  /* Equal lines */

          /* If repeatedLines is enabled, enable isRepeated for the line we are reading */
          if (repeatedLines && !isRepeated)
            isRepeated=1;
          lineCount++;
        }

      }
    }
}


