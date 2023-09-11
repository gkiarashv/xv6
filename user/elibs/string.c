#include "user/etypes.h"


/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
u32 get_strlen(const u8 * str){
	u32 len = 0;
	while(*str++){len++;};
	return len;
}


/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
u8 compare_str(const u8 * s1 , const u8 * s2){

	while(*s1 && *s2){
		if (*s1++ != *s2++)
			return 1;
	}
	if (*s1 == *s2)
		return 0;
	return 1;
}



/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
u8 compare_str_ic(const u8 * s1 , const u8 * s2){

	while(*s1 && *s2){

		u8 b1 = *s1++;
		u8 b2 = *s2++;

		if (b1>='A' && b1<='Z'){
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
			return 1;
		}
	}
	if (*s1 == *s2)
		return 0;
	return 1;
}






