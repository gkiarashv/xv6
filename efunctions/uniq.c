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
  
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);

  if (readStatus == READ_ERROR)
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){

    int lineCount=1;
    int isRepeated;
    int isEof = 0;

    while(1){

      readStatus = read_line(fd, line2);


      if (readStatus == READ_ERROR){
        printf("[ERR] Error reading from the file");
        break;
      }
      if (readStatus == READ_EOF){

        if (isEof)
          break;
        isEof = 1;
      }
      
      /* Comparing two lines */
      char compareStatus;

      if (!ignoreCase)
        compareStatus = compare_str(line1, line2);
      else
        compareStatus = compare_str_ic(line1, line2);


      /* Compare two lines */
      if (compareStatus != 0){ // Not equal

          if (repeatedLines){
            if (isRepeated){
                if (showCount)
                  printf("<%d> %s",lineCount,line1);
                else
                  printf("%s",line1);
            }
          }else{

            if (showCount){
              printf("<%d> %s",lineCount,line1);
              if (isEof && get_strlen(line2)){
                printf("<%d> %s",lineCount,line2); 
                break;
              }
            }
            else{
              printf("%s",line1);
              if (isEof && get_strlen(line2)){
                printf("%s",line2);
                break;
              }
            }

        }

        isRepeated = 0 ;

        /* Reset the line count */
        lineCount = 1;

        // Swap the lines
        swap_pointers(line1, line2);

      }else {  // Equal lines

          if (repeatedLines && !isRepeated){
            isRepeated=1;
          }

          lineCount++;
      }
    }




  }

  





}

