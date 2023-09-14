

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
	int len = 0;
	while(*str++){len++;};
	return len;
}


/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){

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
char compare_str_ic(const char * s1 , const char * s2){

	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

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






