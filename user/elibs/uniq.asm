
user/elibs/_uniq:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
static void uniq_run(s32 fd, u8 ignoreCase, u8 showCount, u8 repeatedLines){
   0:	711d                	addi	sp,sp,-96
   2:	ec86                	sd	ra,88(sp)
   4:	e8a2                	sd	s0,80(sp)
   6:	e4a6                	sd	s1,72(sp)
   8:	e0ca                	sd	s2,64(sp)
   a:	fc4e                	sd	s3,56(sp)
   c:	f852                	sd	s4,48(sp)
   e:	f456                	sd	s5,40(sp)
  10:	f05a                	sd	s6,32(sp)
  12:	ec5e                	sd	s7,24(sp)
  14:	e862                	sd	s8,16(sp)
  16:	e466                	sd	s9,8(sp)
  18:	1080                	addi	s0,sp,96
  1a:	8a2a                	mv	s4,a0
  1c:	8b2e                	mv	s6,a1
  1e:	8bb2                	mv	s7,a2


	u8 * line1 = malloc(MAX_LINE_LEN);
  20:	1f400513          	li	a0,500
  24:	00001097          	auipc	ra,0x1
  28:	928080e7          	jalr	-1752(ra) # 94c <malloc>
  2c:	892a                	mv	s2,a0
	u8 * line2 = malloc(MAX_LINE_LEN);
  2e:	1f400513          	li	a0,500
  32:	00001097          	auipc	ra,0x1
  36:	91a080e7          	jalr	-1766(ra) # 94c <malloc>
  3a:	84aa                	mv	s1,a0
	
	s64 readStatus;
	readStatus = read_line(fd, line1);
  3c:	85ca                	mv	a1,s2
  3e:	8552                	mv	a0,s4
  40:	00001097          	auipc	ra,0x1
  44:	a64080e7          	jalr	-1436(ra) # aa4 <read_line>
	if (readStatus == READ_EOF || readStatus == READ_ERROR)
  48:	0505                	addi	a0,a0,1
  4a:	4785                	li	a5,1
  4c:	04a7f063          	bgeu	a5,a0,8c <uniq_run+0x8c>
		return 0;

	u32 lineCount=1;
  50:	4985                	li	s3,1

	while(1){

		readStatus = read_line(fd, line2);
		if (readStatus == READ_EOF || readStatus == READ_ERROR){
  52:	4a85                	li	s5,1
		if (compareStatus != 0){ // Not equal

			if (showCount)
				printf("<%d> %s",lineCount,line1);
			else
				printf("%s",line1);
  54:	00001c97          	auipc	s9,0x1
  58:	b7cc8c93          	addi	s9,s9,-1156 # bd0 <compare_str_ic+0x60>
				printf("<%d> %s",lineCount,line1);
  5c:	00001c17          	auipc	s8,0x1
  60:	b7cc0c13          	addi	s8,s8,-1156 # bd8 <compare_str_ic+0x68>
  64:	a0a5                	j	cc <uniq_run+0xcc>
			printf("%s",line1);			
  66:	85ca                	mv	a1,s2
  68:	00001517          	auipc	a0,0x1
  6c:	b6850513          	addi	a0,a0,-1176 # bd0 <compare_str_ic+0x60>
  70:	00001097          	auipc	ra,0x1
  74:	824080e7          	jalr	-2012(ra) # 894 <printf>

		}else			// Equal lines
			lineCount++;
	}

	free(line1);
  78:	854a                	mv	a0,s2
  7a:	00001097          	auipc	ra,0x1
  7e:	850080e7          	jalr	-1968(ra) # 8ca <free>
	free(line2);
  82:	8526                	mv	a0,s1
  84:	00001097          	auipc	ra,0x1
  88:	846080e7          	jalr	-1978(ra) # 8ca <free>
}
  8c:	60e6                	ld	ra,88(sp)
  8e:	6446                	ld	s0,80(sp)
  90:	64a6                	ld	s1,72(sp)
  92:	6906                	ld	s2,64(sp)
  94:	79e2                	ld	s3,56(sp)
  96:	7a42                	ld	s4,48(sp)
  98:	7aa2                	ld	s5,40(sp)
  9a:	7b02                	ld	s6,32(sp)
  9c:	6be2                	ld	s7,24(sp)
  9e:	6c42                	ld	s8,16(sp)
  a0:	6ca2                	ld	s9,8(sp)
  a2:	6125                	addi	sp,sp,96
  a4:	8082                	ret
			compareStatus = compare_str_ic(line1, line2);
  a6:	85a6                	mv	a1,s1
  a8:	854a                	mv	a0,s2
  aa:	00001097          	auipc	ra,0x1
  ae:	ac6080e7          	jalr	-1338(ra) # b70 <compare_str_ic>
  b2:	a83d                	j	f0 <uniq_run+0xf0>
				printf("%s",line1);
  b4:	85ca                	mv	a1,s2
  b6:	8566                	mv	a0,s9
  b8:	00000097          	auipc	ra,0x0
  bc:	7dc080e7          	jalr	2012(ra) # 894 <printf>
  c0:	87ca                	mv	a5,s2
  c2:	8926                	mv	s2,s1
  c4:	84be                	mv	s1,a5
			lineCount = 1;
  c6:	89d6                	mv	s3,s5
  c8:	a011                	j	cc <uniq_run+0xcc>
			lineCount++;
  ca:	2985                	addiw	s3,s3,1
		readStatus = read_line(fd, line2);
  cc:	85a6                	mv	a1,s1
  ce:	8552                	mv	a0,s4
  d0:	00001097          	auipc	ra,0x1
  d4:	9d4080e7          	jalr	-1580(ra) # aa4 <read_line>
		if (readStatus == READ_EOF || readStatus == READ_ERROR){
  d8:	00150793          	addi	a5,a0,1
  dc:	f8faf5e3          	bgeu	s5,a5,66 <uniq_run+0x66>
		if (!ignoreCase)
  e0:	fc0b13e3          	bnez	s6,a6 <uniq_run+0xa6>
			compareStatus = compare_str(line1, line2);
  e4:	85a6                	mv	a1,s1
  e6:	854a                	mv	a0,s2
  e8:	00001097          	auipc	ra,0x1
  ec:	a5a080e7          	jalr	-1446(ra) # b42 <compare_str>
		if (compareStatus != 0){ // Not equal
  f0:	dd69                	beqz	a0,ca <uniq_run+0xca>
			if (showCount)
  f2:	fc0b81e3          	beqz	s7,b4 <uniq_run+0xb4>
				printf("<%d> %s",lineCount,line1);
  f6:	864a                	mv	a2,s2
  f8:	85ce                	mv	a1,s3
  fa:	8562                	mv	a0,s8
  fc:	00000097          	auipc	ra,0x0
 100:	798080e7          	jalr	1944(ra) # 894 <printf>
 104:	87ca                	mv	a5,s2
 106:	8926                	mv	s2,s1
 108:	84be                	mv	s1,a5
			lineCount = 1;
 10a:	89d6                	mv	s3,s5
 10c:	b7c1                	j	cc <uniq_run+0xcc>

000000000000010e <main>:
s32 main(s32 argc, u8 ** argv){
 10e:	715d                	addi	sp,sp,-80
 110:	e486                	sd	ra,72(sp)
 112:	e0a2                	sd	s0,64(sp)
 114:	fc26                	sd	s1,56(sp)
 116:	f84a                	sd	s2,48(sp)
 118:	f44e                	sd	s3,40(sp)
 11a:	f052                	sd	s4,32(sp)
 11c:	ec56                	sd	s5,24(sp)
 11e:	e85a                	sd	s6,16(sp)
 120:	e45e                	sd	s7,8(sp)
 122:	e062                	sd	s8,0(sp)
 124:	0880                	addi	s0,sp,80
 126:	89ae                	mv	s3,a1
*/
static u8 ** parse_cmd(u32 argc, u8 ** cmd, u8 * options){


	/* Total number of files is maximum argc-1 requiring argc size storage for the last NULL*/
	u8 ** passedFiles = malloc(sizeof(u8 *) * (argc));
 128:	0035151b          	slliw	a0,a0,0x3
 12c:	00001097          	auipc	ra,0x1
 130:	820080e7          	jalr	-2016(ra) # 94c <malloc>

	if (!passedFiles)
 134:	12050363          	beqz	a0,25a <main+0x14c>
 138:	892a                	mv	s2,a0


	*options = 0;
	u32 fileIdx = 0;

	cmd++;  // Skipping the program's name
 13a:	00898493          	addi	s1,s3,8
	
	while(*cmd){
 13e:	0089b503          	ld	a0,8(s3)
 142:	cd79                	beqz	a0,220 <main+0x112>
	*options = 0;
 144:	4981                	li	s3,0
	u32 fileIdx = 0;
 146:	4b01                	li	s6,0
		if (!compare_str(cmd[0], "-c"))
 148:	00001a17          	auipc	s4,0x1
 14c:	a98a0a13          	addi	s4,s4,-1384 # be0 <compare_str_ic+0x70>
			*options |= OPT_SHOW_COUNT;
		else if (!compare_str(cmd[0], "-i"))
 150:	00001a97          	auipc	s5,0x1
 154:	a98a8a93          	addi	s5,s5,-1384 # be8 <compare_str_ic+0x78>
			*options |= OPT_IGNORE_CASE;
		else if (!compare_str(cmd[0], "-d"))
 158:	00001b97          	auipc	s7,0x1
 15c:	a98b8b93          	addi	s7,s7,-1384 # bf0 <compare_str_ic+0x80>
 160:	a031                	j	16c <main+0x5e>
			*options |= OPT_SHOW_COUNT;
 162:	0029e993          	ori	s3,s3,2
			*options |= OPT_SHOW_REPEATED_LINES;
		else
			passedFiles[fileIdx++] = cmd[0];
			
		cmd++;
 166:	04a1                	addi	s1,s1,8
	while(*cmd){
 168:	6088                	ld	a0,0(s1)
 16a:	cd45                	beqz	a0,222 <main+0x114>
		if (!compare_str(cmd[0], "-c"))
 16c:	85d2                	mv	a1,s4
 16e:	00001097          	auipc	ra,0x1
 172:	9d4080e7          	jalr	-1580(ra) # b42 <compare_str>
 176:	d575                	beqz	a0,162 <main+0x54>
		else if (!compare_str(cmd[0], "-i"))
 178:	85d6                	mv	a1,s5
 17a:	6088                	ld	a0,0(s1)
 17c:	00001097          	auipc	ra,0x1
 180:	9c6080e7          	jalr	-1594(ra) # b42 <compare_str>
 184:	e501                	bnez	a0,18c <main+0x7e>
			*options |= OPT_IGNORE_CASE;
 186:	0019e993          	ori	s3,s3,1
 18a:	bff1                	j	166 <main+0x58>
		else if (!compare_str(cmd[0], "-d"))
 18c:	85de                	mv	a1,s7
 18e:	6088                	ld	a0,0(s1)
 190:	00001097          	auipc	ra,0x1
 194:	9b2080e7          	jalr	-1614(ra) # b42 <compare_str>
 198:	e501                	bnez	a0,1a0 <main+0x92>
			*options |= OPT_SHOW_REPEATED_LINES;
 19a:	0049e993          	ori	s3,s3,4
 19e:	b7e1                	j	166 <main+0x58>
			passedFiles[fileIdx++] = cmd[0];
 1a0:	6098                	ld	a4,0(s1)
 1a2:	020b1693          	slli	a3,s6,0x20
 1a6:	01d6d793          	srli	a5,a3,0x1d
 1aa:	97ca                	add	a5,a5,s2
 1ac:	e398                	sd	a4,0(a5)
 1ae:	2b05                	addiw	s6,s6,1
 1b0:	bf5d                	j	166 <main+0x58>
				printf("[ERR] Error opening the file \n");
 1b2:	00001517          	auipc	a0,0x1
 1b6:	a4650513          	addi	a0,a0,-1466 # bf8 <compare_str_ic+0x88>
 1ba:	00000097          	auipc	ra,0x0
 1be:	6da080e7          	jalr	1754(ra) # 894 <printf>
 1c2:	a809                	j	1d4 <main+0xc6>
				uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
 1c4:	86de                	mv	a3,s7
 1c6:	865a                	mv	a2,s6
 1c8:	85ce                	mv	a1,s3
 1ca:	8526                	mv	a0,s1
 1cc:	00000097          	auipc	ra,0x0
 1d0:	e34080e7          	jalr	-460(ra) # 0 <uniq_run>
			passedFiles++;
 1d4:	0921                	addi	s2,s2,8
		while (*passedFiles){
 1d6:	00093503          	ld	a0,0(s2)
 1da:	c949                	beqz	a0,26c <main+0x15e>
			u32 fd = open_file(*passedFiles, RDONLY);
 1dc:	4581                	li	a1,0
 1de:	00001097          	auipc	ra,0x1
 1e2:	8ae080e7          	jalr	-1874(ra) # a8c <open_file>
 1e6:	84aa                	mv	s1,a0
			if (fd == OPEN_FILE_ERROR)
 1e8:	fd5505e3          	beq	a0,s5,1b2 <main+0xa4>
				if (numOfFiles > 1) 
 1ec:	fd4c7ce3          	bgeu	s8,s4,1c4 <main+0xb6>
					printf("==> %s <==\n",*passedFiles);
 1f0:	00093583          	ld	a1,0(s2)
 1f4:	00001517          	auipc	a0,0x1
 1f8:	a2450513          	addi	a0,a0,-1500 # c18 <compare_str_ic+0xa8>
 1fc:	00000097          	auipc	ra,0x0
 200:	698080e7          	jalr	1688(ra) # 894 <printf>
 204:	b7c1                	j	1c4 <main+0xb6>
		uniq_run(STDIN, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
 206:	0049f693          	andi	a3,s3,4
 20a:	0029f613          	andi	a2,s3,2
 20e:	0019f593          	andi	a1,s3,1
 212:	4501                	li	a0,0
 214:	00000097          	auipc	ra,0x0
 218:	dec080e7          	jalr	-532(ra) # 0 <uniq_run>
	return 0;
 21c:	4501                	li	a0,0
 21e:	a0b9                	j	26c <main+0x15e>
	*options = 0;
 220:	4981                	li	s3,0
	printf("Uniq command is getting executed in user mode\n");
 222:	00001517          	auipc	a0,0x1
 226:	a0650513          	addi	a0,a0,-1530 # c28 <compare_str_ic+0xb8>
 22a:	00000097          	auipc	ra,0x0
 22e:	66a080e7          	jalr	1642(ra) # 894 <printf>
	while(*files++){numOfFiles++;};
 232:	00890793          	addi	a5,s2,8
 236:	00093503          	ld	a0,0(s2)
	u32 numOfFiles=0;
 23a:	4a01                	li	s4,0
	while(*files++){numOfFiles++;};
 23c:	d569                	beqz	a0,206 <main+0xf8>
 23e:	2a05                	addiw	s4,s4,1
 240:	07a1                	addi	a5,a5,8
 242:	ff87b703          	ld	a4,-8(a5)
 246:	ff65                	bnez	a4,23e <main+0x130>
			if (fd == OPEN_FILE_ERROR)
 248:	5afd                	li	s5,-1
				if (numOfFiles > 1) 
 24a:	4c05                	li	s8,1
				uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
 24c:	0049fb93          	andi	s7,s3,4
 250:	0029fb13          	andi	s6,s3,2
 254:	0019f993          	andi	s3,s3,1
 258:	b751                	j	1dc <main+0xce>
		printf("[ERR] Cannot parse the cmd");
 25a:	00001517          	auipc	a0,0x1
 25e:	9fe50513          	addi	a0,a0,-1538 # c58 <compare_str_ic+0xe8>
 262:	00000097          	auipc	ra,0x0
 266:	632080e7          	jalr	1586(ra) # 894 <printf>
		return 1;
 26a:	4505                	li	a0,1
}
 26c:	60a6                	ld	ra,72(sp)
 26e:	6406                	ld	s0,64(sp)
 270:	74e2                	ld	s1,56(sp)
 272:	7942                	ld	s2,48(sp)
 274:	79a2                	ld	s3,40(sp)
 276:	7a02                	ld	s4,32(sp)
 278:	6ae2                	ld	s5,24(sp)
 27a:	6b42                	ld	s6,16(sp)
 27c:	6ba2                	ld	s7,8(sp)
 27e:	6c02                	ld	s8,0(sp)
 280:	6161                	addi	sp,sp,80
 282:	8082                	ret

0000000000000284 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 28c:	00000097          	auipc	ra,0x0
 290:	e82080e7          	jalr	-382(ra) # 10e <main>
  exit(0);
 294:	4501                	li	a0,0
 296:	00000097          	auipc	ra,0x0
 29a:	274080e7          	jalr	628(ra) # 50a <exit>

000000000000029e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a4:	87aa                	mv	a5,a0
 2a6:	0585                	addi	a1,a1,1
 2a8:	0785                	addi	a5,a5,1
 2aa:	fff5c703          	lbu	a4,-1(a1)
 2ae:	fee78fa3          	sb	a4,-1(a5)
 2b2:	fb75                	bnez	a4,2a6 <strcpy+0x8>
    ;
  return os;
}
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cb91                	beqz	a5,2d8 <strcmp+0x1e>
 2c6:	0005c703          	lbu	a4,0(a1)
 2ca:	00f71763          	bne	a4,a5,2d8 <strcmp+0x1e>
    p++, q++;
 2ce:	0505                	addi	a0,a0,1
 2d0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	fbe5                	bnez	a5,2c6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2d8:	0005c503          	lbu	a0,0(a1)
}
 2dc:	40a7853b          	subw	a0,a5,a0
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <strlen>:

uint
strlen(const char *s)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e422                	sd	s0,8(sp)
 2ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	cf91                	beqz	a5,30c <strlen+0x26>
 2f2:	0505                	addi	a0,a0,1
 2f4:	87aa                	mv	a5,a0
 2f6:	4685                	li	a3,1
 2f8:	9e89                	subw	a3,a3,a0
 2fa:	00f6853b          	addw	a0,a3,a5
 2fe:	0785                	addi	a5,a5,1
 300:	fff7c703          	lbu	a4,-1(a5)
 304:	fb7d                	bnez	a4,2fa <strlen+0x14>
    ;
  return n;
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
  for(n = 0; s[n]; n++)
 30c:	4501                	li	a0,0
 30e:	bfe5                	j	306 <strlen+0x20>

0000000000000310 <memset>:

void*
memset(void *dst, int c, uint n)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 316:	ca19                	beqz	a2,32c <memset+0x1c>
 318:	87aa                	mv	a5,a0
 31a:	1602                	slli	a2,a2,0x20
 31c:	9201                	srli	a2,a2,0x20
 31e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 322:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 326:	0785                	addi	a5,a5,1
 328:	fee79de3          	bne	a5,a4,322 <memset+0x12>
  }
  return dst;
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret

0000000000000332 <strchr>:

char*
strchr(const char *s, char c)
{
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
  for(; *s; s++)
 338:	00054783          	lbu	a5,0(a0)
 33c:	cb99                	beqz	a5,352 <strchr+0x20>
    if(*s == c)
 33e:	00f58763          	beq	a1,a5,34c <strchr+0x1a>
  for(; *s; s++)
 342:	0505                	addi	a0,a0,1
 344:	00054783          	lbu	a5,0(a0)
 348:	fbfd                	bnez	a5,33e <strchr+0xc>
      return (char*)s;
  return 0;
 34a:	4501                	li	a0,0
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
  return 0;
 352:	4501                	li	a0,0
 354:	bfe5                	j	34c <strchr+0x1a>

0000000000000356 <gets>:

char*
gets(char *buf, int max)
{
 356:	711d                	addi	sp,sp,-96
 358:	ec86                	sd	ra,88(sp)
 35a:	e8a2                	sd	s0,80(sp)
 35c:	e4a6                	sd	s1,72(sp)
 35e:	e0ca                	sd	s2,64(sp)
 360:	fc4e                	sd	s3,56(sp)
 362:	f852                	sd	s4,48(sp)
 364:	f456                	sd	s5,40(sp)
 366:	f05a                	sd	s6,32(sp)
 368:	ec5e                	sd	s7,24(sp)
 36a:	1080                	addi	s0,sp,96
 36c:	8baa                	mv	s7,a0
 36e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 370:	892a                	mv	s2,a0
 372:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 374:	4aa9                	li	s5,10
 376:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 378:	89a6                	mv	s3,s1
 37a:	2485                	addiw	s1,s1,1
 37c:	0344d863          	bge	s1,s4,3ac <gets+0x56>
    cc = read(0, &c, 1);
 380:	4605                	li	a2,1
 382:	faf40593          	addi	a1,s0,-81
 386:	4501                	li	a0,0
 388:	00000097          	auipc	ra,0x0
 38c:	19a080e7          	jalr	410(ra) # 522 <read>
    if(cc < 1)
 390:	00a05e63          	blez	a0,3ac <gets+0x56>
    buf[i++] = c;
 394:	faf44783          	lbu	a5,-81(s0)
 398:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 39c:	01578763          	beq	a5,s5,3aa <gets+0x54>
 3a0:	0905                	addi	s2,s2,1
 3a2:	fd679be3          	bne	a5,s6,378 <gets+0x22>
  for(i=0; i+1 < max; ){
 3a6:	89a6                	mv	s3,s1
 3a8:	a011                	j	3ac <gets+0x56>
 3aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ac:	99de                	add	s3,s3,s7
 3ae:	00098023          	sb	zero,0(s3)
  return buf;
}
 3b2:	855e                	mv	a0,s7
 3b4:	60e6                	ld	ra,88(sp)
 3b6:	6446                	ld	s0,80(sp)
 3b8:	64a6                	ld	s1,72(sp)
 3ba:	6906                	ld	s2,64(sp)
 3bc:	79e2                	ld	s3,56(sp)
 3be:	7a42                	ld	s4,48(sp)
 3c0:	7aa2                	ld	s5,40(sp)
 3c2:	7b02                	ld	s6,32(sp)
 3c4:	6be2                	ld	s7,24(sp)
 3c6:	6125                	addi	sp,sp,96
 3c8:	8082                	ret

00000000000003ca <stat>:

int
stat(const char *n, struct stat *st)
{
 3ca:	1101                	addi	sp,sp,-32
 3cc:	ec06                	sd	ra,24(sp)
 3ce:	e822                	sd	s0,16(sp)
 3d0:	e426                	sd	s1,8(sp)
 3d2:	e04a                	sd	s2,0(sp)
 3d4:	1000                	addi	s0,sp,32
 3d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d8:	4581                	li	a1,0
 3da:	00000097          	auipc	ra,0x0
 3de:	170080e7          	jalr	368(ra) # 54a <open>
  if(fd < 0)
 3e2:	02054563          	bltz	a0,40c <stat+0x42>
 3e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3e8:	85ca                	mv	a1,s2
 3ea:	00000097          	auipc	ra,0x0
 3ee:	178080e7          	jalr	376(ra) # 562 <fstat>
 3f2:	892a                	mv	s2,a0
  close(fd);
 3f4:	8526                	mv	a0,s1
 3f6:	00000097          	auipc	ra,0x0
 3fa:	13c080e7          	jalr	316(ra) # 532 <close>
  return r;
}
 3fe:	854a                	mv	a0,s2
 400:	60e2                	ld	ra,24(sp)
 402:	6442                	ld	s0,16(sp)
 404:	64a2                	ld	s1,8(sp)
 406:	6902                	ld	s2,0(sp)
 408:	6105                	addi	sp,sp,32
 40a:	8082                	ret
    return -1;
 40c:	597d                	li	s2,-1
 40e:	bfc5                	j	3fe <stat+0x34>

0000000000000410 <atoi>:

int
atoi(const char *s)
{
 410:	1141                	addi	sp,sp,-16
 412:	e422                	sd	s0,8(sp)
 414:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 416:	00054683          	lbu	a3,0(a0)
 41a:	fd06879b          	addiw	a5,a3,-48
 41e:	0ff7f793          	zext.b	a5,a5
 422:	4625                	li	a2,9
 424:	02f66863          	bltu	a2,a5,454 <atoi+0x44>
 428:	872a                	mv	a4,a0
  n = 0;
 42a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 42c:	0705                	addi	a4,a4,1
 42e:	0025179b          	slliw	a5,a0,0x2
 432:	9fa9                	addw	a5,a5,a0
 434:	0017979b          	slliw	a5,a5,0x1
 438:	9fb5                	addw	a5,a5,a3
 43a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 43e:	00074683          	lbu	a3,0(a4)
 442:	fd06879b          	addiw	a5,a3,-48
 446:	0ff7f793          	zext.b	a5,a5
 44a:	fef671e3          	bgeu	a2,a5,42c <atoi+0x1c>
  return n;
}
 44e:	6422                	ld	s0,8(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret
  n = 0;
 454:	4501                	li	a0,0
 456:	bfe5                	j	44e <atoi+0x3e>

0000000000000458 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 458:	1141                	addi	sp,sp,-16
 45a:	e422                	sd	s0,8(sp)
 45c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 45e:	02b57463          	bgeu	a0,a1,486 <memmove+0x2e>
    while(n-- > 0)
 462:	00c05f63          	blez	a2,480 <memmove+0x28>
 466:	1602                	slli	a2,a2,0x20
 468:	9201                	srli	a2,a2,0x20
 46a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 46e:	872a                	mv	a4,a0
      *dst++ = *src++;
 470:	0585                	addi	a1,a1,1
 472:	0705                	addi	a4,a4,1
 474:	fff5c683          	lbu	a3,-1(a1)
 478:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 47c:	fee79ae3          	bne	a5,a4,470 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 480:	6422                	ld	s0,8(sp)
 482:	0141                	addi	sp,sp,16
 484:	8082                	ret
    dst += n;
 486:	00c50733          	add	a4,a0,a2
    src += n;
 48a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 48c:	fec05ae3          	blez	a2,480 <memmove+0x28>
 490:	fff6079b          	addiw	a5,a2,-1
 494:	1782                	slli	a5,a5,0x20
 496:	9381                	srli	a5,a5,0x20
 498:	fff7c793          	not	a5,a5
 49c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 49e:	15fd                	addi	a1,a1,-1
 4a0:	177d                	addi	a4,a4,-1
 4a2:	0005c683          	lbu	a3,0(a1)
 4a6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4aa:	fee79ae3          	bne	a5,a4,49e <memmove+0x46>
 4ae:	bfc9                	j	480 <memmove+0x28>

00000000000004b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e422                	sd	s0,8(sp)
 4b4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4b6:	ca05                	beqz	a2,4e6 <memcmp+0x36>
 4b8:	fff6069b          	addiw	a3,a2,-1
 4bc:	1682                	slli	a3,a3,0x20
 4be:	9281                	srli	a3,a3,0x20
 4c0:	0685                	addi	a3,a3,1
 4c2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4c4:	00054783          	lbu	a5,0(a0)
 4c8:	0005c703          	lbu	a4,0(a1)
 4cc:	00e79863          	bne	a5,a4,4dc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4d0:	0505                	addi	a0,a0,1
    p2++;
 4d2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4d4:	fed518e3          	bne	a0,a3,4c4 <memcmp+0x14>
  }
  return 0;
 4d8:	4501                	li	a0,0
 4da:	a019                	j	4e0 <memcmp+0x30>
      return *p1 - *p2;
 4dc:	40e7853b          	subw	a0,a5,a4
}
 4e0:	6422                	ld	s0,8(sp)
 4e2:	0141                	addi	sp,sp,16
 4e4:	8082                	ret
  return 0;
 4e6:	4501                	li	a0,0
 4e8:	bfe5                	j	4e0 <memcmp+0x30>

00000000000004ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ea:	1141                	addi	sp,sp,-16
 4ec:	e406                	sd	ra,8(sp)
 4ee:	e022                	sd	s0,0(sp)
 4f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4f2:	00000097          	auipc	ra,0x0
 4f6:	f66080e7          	jalr	-154(ra) # 458 <memmove>
}
 4fa:	60a2                	ld	ra,8(sp)
 4fc:	6402                	ld	s0,0(sp)
 4fe:	0141                	addi	sp,sp,16
 500:	8082                	ret

0000000000000502 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 502:	4885                	li	a7,1
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <exit>:
.global exit
exit:
 li a7, SYS_exit
 50a:	4889                	li	a7,2
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <wait>:
.global wait
wait:
 li a7, SYS_wait
 512:	488d                	li	a7,3
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 51a:	4891                	li	a7,4
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <read>:
.global read
read:
 li a7, SYS_read
 522:	4895                	li	a7,5
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <write>:
.global write
write:
 li a7, SYS_write
 52a:	48c1                	li	a7,16
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <close>:
.global close
close:
 li a7, SYS_close
 532:	48d5                	li	a7,21
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <kill>:
.global kill
kill:
 li a7, SYS_kill
 53a:	4899                	li	a7,6
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <exec>:
.global exec
exec:
 li a7, SYS_exec
 542:	489d                	li	a7,7
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <open>:
.global open
open:
 li a7, SYS_open
 54a:	48bd                	li	a7,15
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 552:	48c5                	li	a7,17
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 55a:	48c9                	li	a7,18
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 562:	48a1                	li	a7,8
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <link>:
.global link
link:
 li a7, SYS_link
 56a:	48cd                	li	a7,19
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 572:	48d1                	li	a7,20
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 57a:	48a5                	li	a7,9
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <dup>:
.global dup
dup:
 li a7, SYS_dup
 582:	48a9                	li	a7,10
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 58a:	48ad                	li	a7,11
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 592:	48b1                	li	a7,12
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 59a:	48b5                	li	a7,13
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a2:	48b9                	li	a7,14
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <head>:
.global head
head:
 li a7, SYS_head
 5aa:	48d9                	li	a7,22
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 5b2:	48dd                	li	a7,23
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ba:	1101                	addi	sp,sp,-32
 5bc:	ec06                	sd	ra,24(sp)
 5be:	e822                	sd	s0,16(sp)
 5c0:	1000                	addi	s0,sp,32
 5c2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c6:	4605                	li	a2,1
 5c8:	fef40593          	addi	a1,s0,-17
 5cc:	00000097          	auipc	ra,0x0
 5d0:	f5e080e7          	jalr	-162(ra) # 52a <write>
}
 5d4:	60e2                	ld	ra,24(sp)
 5d6:	6442                	ld	s0,16(sp)
 5d8:	6105                	addi	sp,sp,32
 5da:	8082                	ret

00000000000005dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5dc:	7139                	addi	sp,sp,-64
 5de:	fc06                	sd	ra,56(sp)
 5e0:	f822                	sd	s0,48(sp)
 5e2:	f426                	sd	s1,40(sp)
 5e4:	f04a                	sd	s2,32(sp)
 5e6:	ec4e                	sd	s3,24(sp)
 5e8:	0080                	addi	s0,sp,64
 5ea:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ec:	c299                	beqz	a3,5f2 <printint+0x16>
 5ee:	0805c963          	bltz	a1,680 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5f2:	2581                	sext.w	a1,a1
  neg = 0;
 5f4:	4881                	li	a7,0
 5f6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5fa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5fc:	2601                	sext.w	a2,a2
 5fe:	00000517          	auipc	a0,0x0
 602:	6da50513          	addi	a0,a0,1754 # cd8 <digits>
 606:	883a                	mv	a6,a4
 608:	2705                	addiw	a4,a4,1
 60a:	02c5f7bb          	remuw	a5,a1,a2
 60e:	1782                	slli	a5,a5,0x20
 610:	9381                	srli	a5,a5,0x20
 612:	97aa                	add	a5,a5,a0
 614:	0007c783          	lbu	a5,0(a5)
 618:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 61c:	0005879b          	sext.w	a5,a1
 620:	02c5d5bb          	divuw	a1,a1,a2
 624:	0685                	addi	a3,a3,1
 626:	fec7f0e3          	bgeu	a5,a2,606 <printint+0x2a>
  if(neg)
 62a:	00088c63          	beqz	a7,642 <printint+0x66>
    buf[i++] = '-';
 62e:	fd070793          	addi	a5,a4,-48
 632:	00878733          	add	a4,a5,s0
 636:	02d00793          	li	a5,45
 63a:	fef70823          	sb	a5,-16(a4)
 63e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 642:	02e05863          	blez	a4,672 <printint+0x96>
 646:	fc040793          	addi	a5,s0,-64
 64a:	00e78933          	add	s2,a5,a4
 64e:	fff78993          	addi	s3,a5,-1
 652:	99ba                	add	s3,s3,a4
 654:	377d                	addiw	a4,a4,-1
 656:	1702                	slli	a4,a4,0x20
 658:	9301                	srli	a4,a4,0x20
 65a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 65e:	fff94583          	lbu	a1,-1(s2)
 662:	8526                	mv	a0,s1
 664:	00000097          	auipc	ra,0x0
 668:	f56080e7          	jalr	-170(ra) # 5ba <putc>
  while(--i >= 0)
 66c:	197d                	addi	s2,s2,-1
 66e:	ff3918e3          	bne	s2,s3,65e <printint+0x82>
}
 672:	70e2                	ld	ra,56(sp)
 674:	7442                	ld	s0,48(sp)
 676:	74a2                	ld	s1,40(sp)
 678:	7902                	ld	s2,32(sp)
 67a:	69e2                	ld	s3,24(sp)
 67c:	6121                	addi	sp,sp,64
 67e:	8082                	ret
    x = -xx;
 680:	40b005bb          	negw	a1,a1
    neg = 1;
 684:	4885                	li	a7,1
    x = -xx;
 686:	bf85                	j	5f6 <printint+0x1a>

0000000000000688 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 688:	7119                	addi	sp,sp,-128
 68a:	fc86                	sd	ra,120(sp)
 68c:	f8a2                	sd	s0,112(sp)
 68e:	f4a6                	sd	s1,104(sp)
 690:	f0ca                	sd	s2,96(sp)
 692:	ecce                	sd	s3,88(sp)
 694:	e8d2                	sd	s4,80(sp)
 696:	e4d6                	sd	s5,72(sp)
 698:	e0da                	sd	s6,64(sp)
 69a:	fc5e                	sd	s7,56(sp)
 69c:	f862                	sd	s8,48(sp)
 69e:	f466                	sd	s9,40(sp)
 6a0:	f06a                	sd	s10,32(sp)
 6a2:	ec6e                	sd	s11,24(sp)
 6a4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6a6:	0005c903          	lbu	s2,0(a1)
 6aa:	18090f63          	beqz	s2,848 <vprintf+0x1c0>
 6ae:	8aaa                	mv	s5,a0
 6b0:	8b32                	mv	s6,a2
 6b2:	00158493          	addi	s1,a1,1
  state = 0;
 6b6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6b8:	02500a13          	li	s4,37
 6bc:	4c55                	li	s8,21
 6be:	00000c97          	auipc	s9,0x0
 6c2:	5c2c8c93          	addi	s9,s9,1474 # c80 <compare_str_ic+0x110>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c6:	02800d93          	li	s11,40
  putc(fd, 'x');
 6ca:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6cc:	00000b97          	auipc	s7,0x0
 6d0:	60cb8b93          	addi	s7,s7,1548 # cd8 <digits>
 6d4:	a839                	j	6f2 <vprintf+0x6a>
        putc(fd, c);
 6d6:	85ca                	mv	a1,s2
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	ee0080e7          	jalr	-288(ra) # 5ba <putc>
 6e2:	a019                	j	6e8 <vprintf+0x60>
    } else if(state == '%'){
 6e4:	01498d63          	beq	s3,s4,6fe <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6e8:	0485                	addi	s1,s1,1
 6ea:	fff4c903          	lbu	s2,-1(s1)
 6ee:	14090d63          	beqz	s2,848 <vprintf+0x1c0>
    if(state == 0){
 6f2:	fe0999e3          	bnez	s3,6e4 <vprintf+0x5c>
      if(c == '%'){
 6f6:	ff4910e3          	bne	s2,s4,6d6 <vprintf+0x4e>
        state = '%';
 6fa:	89d2                	mv	s3,s4
 6fc:	b7f5                	j	6e8 <vprintf+0x60>
      if(c == 'd'){
 6fe:	11490c63          	beq	s2,s4,816 <vprintf+0x18e>
 702:	f9d9079b          	addiw	a5,s2,-99
 706:	0ff7f793          	zext.b	a5,a5
 70a:	10fc6e63          	bltu	s8,a5,826 <vprintf+0x19e>
 70e:	f9d9079b          	addiw	a5,s2,-99
 712:	0ff7f713          	zext.b	a4,a5
 716:	10ec6863          	bltu	s8,a4,826 <vprintf+0x19e>
 71a:	00271793          	slli	a5,a4,0x2
 71e:	97e6                	add	a5,a5,s9
 720:	439c                	lw	a5,0(a5)
 722:	97e6                	add	a5,a5,s9
 724:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 726:	008b0913          	addi	s2,s6,8
 72a:	4685                	li	a3,1
 72c:	4629                	li	a2,10
 72e:	000b2583          	lw	a1,0(s6)
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	ea8080e7          	jalr	-344(ra) # 5dc <printint>
 73c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 73e:	4981                	li	s3,0
 740:	b765                	j	6e8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 742:	008b0913          	addi	s2,s6,8
 746:	4681                	li	a3,0
 748:	4629                	li	a2,10
 74a:	000b2583          	lw	a1,0(s6)
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	e8c080e7          	jalr	-372(ra) # 5dc <printint>
 758:	8b4a                	mv	s6,s2
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b771                	j	6e8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 75e:	008b0913          	addi	s2,s6,8
 762:	4681                	li	a3,0
 764:	866a                	mv	a2,s10
 766:	000b2583          	lw	a1,0(s6)
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	e70080e7          	jalr	-400(ra) # 5dc <printint>
 774:	8b4a                	mv	s6,s2
      state = 0;
 776:	4981                	li	s3,0
 778:	bf85                	j	6e8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 77a:	008b0793          	addi	a5,s6,8
 77e:	f8f43423          	sd	a5,-120(s0)
 782:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 786:	03000593          	li	a1,48
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	e2e080e7          	jalr	-466(ra) # 5ba <putc>
  putc(fd, 'x');
 794:	07800593          	li	a1,120
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	e20080e7          	jalr	-480(ra) # 5ba <putc>
 7a2:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a4:	03c9d793          	srli	a5,s3,0x3c
 7a8:	97de                	add	a5,a5,s7
 7aa:	0007c583          	lbu	a1,0(a5)
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	e0a080e7          	jalr	-502(ra) # 5ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b8:	0992                	slli	s3,s3,0x4
 7ba:	397d                	addiw	s2,s2,-1
 7bc:	fe0914e3          	bnez	s2,7a4 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7c0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	b70d                	j	6e8 <vprintf+0x60>
        s = va_arg(ap, char*);
 7c8:	008b0913          	addi	s2,s6,8
 7cc:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7d0:	02098163          	beqz	s3,7f2 <vprintf+0x16a>
        while(*s != 0){
 7d4:	0009c583          	lbu	a1,0(s3)
 7d8:	c5ad                	beqz	a1,842 <vprintf+0x1ba>
          putc(fd, *s);
 7da:	8556                	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	dde080e7          	jalr	-546(ra) # 5ba <putc>
          s++;
 7e4:	0985                	addi	s3,s3,1
        while(*s != 0){
 7e6:	0009c583          	lbu	a1,0(s3)
 7ea:	f9e5                	bnez	a1,7da <vprintf+0x152>
        s = va_arg(ap, char*);
 7ec:	8b4a                	mv	s6,s2
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	bde5                	j	6e8 <vprintf+0x60>
          s = "(null)";
 7f2:	00000997          	auipc	s3,0x0
 7f6:	48698993          	addi	s3,s3,1158 # c78 <compare_str_ic+0x108>
        while(*s != 0){
 7fa:	85ee                	mv	a1,s11
 7fc:	bff9                	j	7da <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7fe:	008b0913          	addi	s2,s6,8
 802:	000b4583          	lbu	a1,0(s6)
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	db2080e7          	jalr	-590(ra) # 5ba <putc>
 810:	8b4a                	mv	s6,s2
      state = 0;
 812:	4981                	li	s3,0
 814:	bdd1                	j	6e8 <vprintf+0x60>
        putc(fd, c);
 816:	85d2                	mv	a1,s4
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	da0080e7          	jalr	-608(ra) # 5ba <putc>
      state = 0;
 822:	4981                	li	s3,0
 824:	b5d1                	j	6e8 <vprintf+0x60>
        putc(fd, '%');
 826:	85d2                	mv	a1,s4
 828:	8556                	mv	a0,s5
 82a:	00000097          	auipc	ra,0x0
 82e:	d90080e7          	jalr	-624(ra) # 5ba <putc>
        putc(fd, c);
 832:	85ca                	mv	a1,s2
 834:	8556                	mv	a0,s5
 836:	00000097          	auipc	ra,0x0
 83a:	d84080e7          	jalr	-636(ra) # 5ba <putc>
      state = 0;
 83e:	4981                	li	s3,0
 840:	b565                	j	6e8 <vprintf+0x60>
        s = va_arg(ap, char*);
 842:	8b4a                	mv	s6,s2
      state = 0;
 844:	4981                	li	s3,0
 846:	b54d                	j	6e8 <vprintf+0x60>
    }
  }
}
 848:	70e6                	ld	ra,120(sp)
 84a:	7446                	ld	s0,112(sp)
 84c:	74a6                	ld	s1,104(sp)
 84e:	7906                	ld	s2,96(sp)
 850:	69e6                	ld	s3,88(sp)
 852:	6a46                	ld	s4,80(sp)
 854:	6aa6                	ld	s5,72(sp)
 856:	6b06                	ld	s6,64(sp)
 858:	7be2                	ld	s7,56(sp)
 85a:	7c42                	ld	s8,48(sp)
 85c:	7ca2                	ld	s9,40(sp)
 85e:	7d02                	ld	s10,32(sp)
 860:	6de2                	ld	s11,24(sp)
 862:	6109                	addi	sp,sp,128
 864:	8082                	ret

0000000000000866 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 866:	715d                	addi	sp,sp,-80
 868:	ec06                	sd	ra,24(sp)
 86a:	e822                	sd	s0,16(sp)
 86c:	1000                	addi	s0,sp,32
 86e:	e010                	sd	a2,0(s0)
 870:	e414                	sd	a3,8(s0)
 872:	e818                	sd	a4,16(s0)
 874:	ec1c                	sd	a5,24(s0)
 876:	03043023          	sd	a6,32(s0)
 87a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 87e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 882:	8622                	mv	a2,s0
 884:	00000097          	auipc	ra,0x0
 888:	e04080e7          	jalr	-508(ra) # 688 <vprintf>
}
 88c:	60e2                	ld	ra,24(sp)
 88e:	6442                	ld	s0,16(sp)
 890:	6161                	addi	sp,sp,80
 892:	8082                	ret

0000000000000894 <printf>:

void
printf(const char *fmt, ...)
{
 894:	711d                	addi	sp,sp,-96
 896:	ec06                	sd	ra,24(sp)
 898:	e822                	sd	s0,16(sp)
 89a:	1000                	addi	s0,sp,32
 89c:	e40c                	sd	a1,8(s0)
 89e:	e810                	sd	a2,16(s0)
 8a0:	ec14                	sd	a3,24(s0)
 8a2:	f018                	sd	a4,32(s0)
 8a4:	f41c                	sd	a5,40(s0)
 8a6:	03043823          	sd	a6,48(s0)
 8aa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ae:	00840613          	addi	a2,s0,8
 8b2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8b6:	85aa                	mv	a1,a0
 8b8:	4505                	li	a0,1
 8ba:	00000097          	auipc	ra,0x0
 8be:	dce080e7          	jalr	-562(ra) # 688 <vprintf>
}
 8c2:	60e2                	ld	ra,24(sp)
 8c4:	6442                	ld	s0,16(sp)
 8c6:	6125                	addi	sp,sp,96
 8c8:	8082                	ret

00000000000008ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ca:	1141                	addi	sp,sp,-16
 8cc:	e422                	sd	s0,8(sp)
 8ce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d4:	00000797          	auipc	a5,0x0
 8d8:	72c7b783          	ld	a5,1836(a5) # 1000 <freep>
 8dc:	a02d                	j	906 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8de:	4618                	lw	a4,8(a2)
 8e0:	9f2d                	addw	a4,a4,a1
 8e2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e6:	6398                	ld	a4,0(a5)
 8e8:	6310                	ld	a2,0(a4)
 8ea:	a83d                	j	928 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ec:	ff852703          	lw	a4,-8(a0)
 8f0:	9f31                	addw	a4,a4,a2
 8f2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8f4:	ff053683          	ld	a3,-16(a0)
 8f8:	a091                	j	93c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fa:	6398                	ld	a4,0(a5)
 8fc:	00e7e463          	bltu	a5,a4,904 <free+0x3a>
 900:	00e6ea63          	bltu	a3,a4,914 <free+0x4a>
{
 904:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 906:	fed7fae3          	bgeu	a5,a3,8fa <free+0x30>
 90a:	6398                	ld	a4,0(a5)
 90c:	00e6e463          	bltu	a3,a4,914 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 910:	fee7eae3          	bltu	a5,a4,904 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 914:	ff852583          	lw	a1,-8(a0)
 918:	6390                	ld	a2,0(a5)
 91a:	02059813          	slli	a6,a1,0x20
 91e:	01c85713          	srli	a4,a6,0x1c
 922:	9736                	add	a4,a4,a3
 924:	fae60de3          	beq	a2,a4,8de <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 928:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 92c:	4790                	lw	a2,8(a5)
 92e:	02061593          	slli	a1,a2,0x20
 932:	01c5d713          	srli	a4,a1,0x1c
 936:	973e                	add	a4,a4,a5
 938:	fae68ae3          	beq	a3,a4,8ec <free+0x22>
    p->s.ptr = bp->s.ptr;
 93c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 93e:	00000717          	auipc	a4,0x0
 942:	6cf73123          	sd	a5,1730(a4) # 1000 <freep>
}
 946:	6422                	ld	s0,8(sp)
 948:	0141                	addi	sp,sp,16
 94a:	8082                	ret

000000000000094c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 94c:	7139                	addi	sp,sp,-64
 94e:	fc06                	sd	ra,56(sp)
 950:	f822                	sd	s0,48(sp)
 952:	f426                	sd	s1,40(sp)
 954:	f04a                	sd	s2,32(sp)
 956:	ec4e                	sd	s3,24(sp)
 958:	e852                	sd	s4,16(sp)
 95a:	e456                	sd	s5,8(sp)
 95c:	e05a                	sd	s6,0(sp)
 95e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 960:	02051493          	slli	s1,a0,0x20
 964:	9081                	srli	s1,s1,0x20
 966:	04bd                	addi	s1,s1,15
 968:	8091                	srli	s1,s1,0x4
 96a:	0014899b          	addiw	s3,s1,1
 96e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 970:	00000517          	auipc	a0,0x0
 974:	69053503          	ld	a0,1680(a0) # 1000 <freep>
 978:	c515                	beqz	a0,9a4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 97c:	4798                	lw	a4,8(a5)
 97e:	02977f63          	bgeu	a4,s1,9bc <malloc+0x70>
 982:	8a4e                	mv	s4,s3
 984:	0009871b          	sext.w	a4,s3
 988:	6685                	lui	a3,0x1
 98a:	00d77363          	bgeu	a4,a3,990 <malloc+0x44>
 98e:	6a05                	lui	s4,0x1
 990:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 994:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 998:	00000917          	auipc	s2,0x0
 99c:	66890913          	addi	s2,s2,1640 # 1000 <freep>
  if(p == (char*)-1)
 9a0:	5afd                	li	s5,-1
 9a2:	a895                	j	a16 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9a4:	00000797          	auipc	a5,0x0
 9a8:	66c78793          	addi	a5,a5,1644 # 1010 <base>
 9ac:	00000717          	auipc	a4,0x0
 9b0:	64f73a23          	sd	a5,1620(a4) # 1000 <freep>
 9b4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9b6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ba:	b7e1                	j	982 <malloc+0x36>
      if(p->s.size == nunits)
 9bc:	02e48c63          	beq	s1,a4,9f4 <malloc+0xa8>
        p->s.size -= nunits;
 9c0:	4137073b          	subw	a4,a4,s3
 9c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c6:	02071693          	slli	a3,a4,0x20
 9ca:	01c6d713          	srli	a4,a3,0x1c
 9ce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d4:	00000717          	auipc	a4,0x0
 9d8:	62a73623          	sd	a0,1580(a4) # 1000 <freep>
      return (void*)(p + 1);
 9dc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9e0:	70e2                	ld	ra,56(sp)
 9e2:	7442                	ld	s0,48(sp)
 9e4:	74a2                	ld	s1,40(sp)
 9e6:	7902                	ld	s2,32(sp)
 9e8:	69e2                	ld	s3,24(sp)
 9ea:	6a42                	ld	s4,16(sp)
 9ec:	6aa2                	ld	s5,8(sp)
 9ee:	6b02                	ld	s6,0(sp)
 9f0:	6121                	addi	sp,sp,64
 9f2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9f4:	6398                	ld	a4,0(a5)
 9f6:	e118                	sd	a4,0(a0)
 9f8:	bff1                	j	9d4 <malloc+0x88>
  hp->s.size = nu;
 9fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9fe:	0541                	addi	a0,a0,16
 a00:	00000097          	auipc	ra,0x0
 a04:	eca080e7          	jalr	-310(ra) # 8ca <free>
  return freep;
 a08:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a0c:	d971                	beqz	a0,9e0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a10:	4798                	lw	a4,8(a5)
 a12:	fa9775e3          	bgeu	a4,s1,9bc <malloc+0x70>
    if(p == freep)
 a16:	00093703          	ld	a4,0(s2)
 a1a:	853e                	mv	a0,a5
 a1c:	fef719e3          	bne	a4,a5,a0e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a20:	8552                	mv	a0,s4
 a22:	00000097          	auipc	ra,0x0
 a26:	b70080e7          	jalr	-1168(ra) # 592 <sbrk>
  if(p == (char*)-1)
 a2a:	fd5518e3          	bne	a0,s5,9fa <malloc+0xae>
        return 0;
 a2e:	4501                	li	a0,0
 a30:	bf45                	j	9e0 <malloc+0x94>

0000000000000a32 <str_len>:
 a32:	1141                	addi	sp,sp,-16
 a34:	e422                	sd	s0,8(sp)
 a36:	0800                	addi	s0,sp,16
 a38:	00054783          	lbu	a5,0(a0)
 a3c:	cf99                	beqz	a5,a5a <str_len+0x28>
 a3e:	00150713          	addi	a4,a0,1
 a42:	87ba                	mv	a5,a4
 a44:	4685                	li	a3,1
 a46:	9e99                	subw	a3,a3,a4
 a48:	00f6853b          	addw	a0,a3,a5
 a4c:	0785                	addi	a5,a5,1
 a4e:	fff7c703          	lbu	a4,-1(a5)
 a52:	fb7d                	bnez	a4,a48 <str_len+0x16>
 a54:	6422                	ld	s0,8(sp)
 a56:	0141                	addi	sp,sp,16
 a58:	8082                	ret
 a5a:	4501                	li	a0,0
 a5c:	bfe5                	j	a54 <str_len+0x22>

0000000000000a5e <print>:
 a5e:	1101                	addi	sp,sp,-32
 a60:	ec06                	sd	ra,24(sp)
 a62:	e822                	sd	s0,16(sp)
 a64:	e426                	sd	s1,8(sp)
 a66:	1000                	addi	s0,sp,32
 a68:	84aa                	mv	s1,a0
 a6a:	00000097          	auipc	ra,0x0
 a6e:	fc8080e7          	jalr	-56(ra) # a32 <str_len>
 a72:	0005061b          	sext.w	a2,a0
 a76:	85a6                	mv	a1,s1
 a78:	4505                	li	a0,1
 a7a:	00000097          	auipc	ra,0x0
 a7e:	ab0080e7          	jalr	-1360(ra) # 52a <write>
 a82:	60e2                	ld	ra,24(sp)
 a84:	6442                	ld	s0,16(sp)
 a86:	64a2                	ld	s1,8(sp)
 a88:	6105                	addi	sp,sp,32
 a8a:	8082                	ret

0000000000000a8c <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
s32 open_file(u8 * filePath, s32 flag){
 a8c:	1141                	addi	sp,sp,-16
 a8e:	e406                	sd	ra,8(sp)
 a90:	e022                	sd	s0,0(sp)
 a92:	0800                	addi	s0,sp,16
	s32 fd = open(filePath, flag);
 a94:	00000097          	auipc	ra,0x0
 a98:	ab6080e7          	jalr	-1354(ra) # 54a <open>
	return fd;
}
 a9c:	60a2                	ld	ra,8(sp)
 a9e:	6402                	ld	s0,0(sp)
 aa0:	0141                	addi	sp,sp,16
 aa2:	8082                	ret

0000000000000aa4 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
s64 read_line(s32 fd, u8 * buffer){
 aa4:	7139                	addi	sp,sp,-64
 aa6:	fc06                	sd	ra,56(sp)
 aa8:	f822                	sd	s0,48(sp)
 aaa:	f426                	sd	s1,40(sp)
 aac:	f04a                	sd	s2,32(sp)
 aae:	ec4e                	sd	s3,24(sp)
 ab0:	e852                	sd	s4,16(sp)
 ab2:	0080                	addi	s0,sp,64
 ab4:	89aa                	mv	s3,a0
 ab6:	84ae                	mv	s1,a1

	u8 readByte;
	s64 byteCount = 0;
 ab8:	4901                	li	s2,0
			return byteCount; 
		}
		*buffer++ = readByte;
		byteCount++;

		if (readByte == '\n'){
 aba:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 abc:	4605                	li	a2,1
 abe:	fcf40593          	addi	a1,s0,-49
 ac2:	854e                	mv	a0,s3
 ac4:	00000097          	auipc	ra,0x0
 ac8:	a5e080e7          	jalr	-1442(ra) # 522 <read>
		if (readStatus <= 0){
 acc:	02a05563          	blez	a0,af6 <read_line+0x52>
		*buffer++ = readByte;
 ad0:	0485                	addi	s1,s1,1
 ad2:	fcf44783          	lbu	a5,-49(s0)
 ad6:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 ada:	0905                	addi	s2,s2,1
		if (readByte == '\n'){
 adc:	ff4790e3          	bne	a5,s4,abc <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 ae0:	00048023          	sb	zero,0(s1)
		byteCount++;
 ae4:	854a                	mv	a0,s2
			return byteCount;
		}
	
	}
}
 ae6:	70e2                	ld	ra,56(sp)
 ae8:	7442                	ld	s0,48(sp)
 aea:	74a2                	ld	s1,40(sp)
 aec:	7902                	ld	s2,32(sp)
 aee:	69e2                	ld	s3,24(sp)
 af0:	6a42                	ld	s4,16(sp)
 af2:	6121                	addi	sp,sp,64
 af4:	8082                	ret
			if (byteCount == 0)
 af6:	fe0908e3          	beqz	s2,ae6 <read_line+0x42>
 afa:	854a                	mv	a0,s2
 afc:	b7ed                	j	ae6 <read_line+0x42>

0000000000000afe <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(s32 fd){
 afe:	1141                	addi	sp,sp,-16
 b00:	e406                	sd	ra,8(sp)
 b02:	e022                	sd	s0,0(sp)
 b04:	0800                	addi	s0,sp,16
	close(fd);
 b06:	00000097          	auipc	ra,0x0
 b0a:	a2c080e7          	jalr	-1492(ra) # 532 <close>
}
 b0e:	60a2                	ld	ra,8(sp)
 b10:	6402                	ld	s0,0(sp)
 b12:	0141                	addi	sp,sp,16
 b14:	8082                	ret

0000000000000b16 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
u32 get_strlen(const u8 * str){
 b16:	1141                	addi	sp,sp,-16
 b18:	e422                	sd	s0,8(sp)
 b1a:	0800                	addi	s0,sp,16
	u32 len = 0;
	while(*str++){len++;};
 b1c:	00054783          	lbu	a5,0(a0)
 b20:	cf99                	beqz	a5,b3e <get_strlen+0x28>
 b22:	00150713          	addi	a4,a0,1
 b26:	87ba                	mv	a5,a4
 b28:	4685                	li	a3,1
 b2a:	9e99                	subw	a3,a3,a4
 b2c:	00f6853b          	addw	a0,a3,a5
 b30:	0785                	addi	a5,a5,1
 b32:	fff7c703          	lbu	a4,-1(a5)
 b36:	fb7d                	bnez	a4,b2c <get_strlen+0x16>
	return len;
}
 b38:	6422                	ld	s0,8(sp)
 b3a:	0141                	addi	sp,sp,16
 b3c:	8082                	ret
	u32 len = 0;
 b3e:	4501                	li	a0,0
 b40:	bfe5                	j	b38 <get_strlen+0x22>

0000000000000b42 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
u8 compare_str(const u8 * s1 , const u8 * s2){
 b42:	1141                	addi	sp,sp,-16
 b44:	e422                	sd	s0,8(sp)
 b46:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 b48:	00054783          	lbu	a5,0(a0)
 b4c:	cb91                	beqz	a5,b60 <compare_str+0x1e>
 b4e:	0005c703          	lbu	a4,0(a1)
 b52:	c719                	beqz	a4,b60 <compare_str+0x1e>
		if (*s1++ != *s2++)
 b54:	0505                	addi	a0,a0,1
 b56:	0585                	addi	a1,a1,1
 b58:	fee788e3          	beq	a5,a4,b48 <compare_str+0x6>
			return 1;
 b5c:	4505                	li	a0,1
 b5e:	a031                	j	b6a <compare_str+0x28>
	}
	if (*s1 == *s2)
 b60:	0005c503          	lbu	a0,0(a1)
 b64:	8d1d                	sub	a0,a0,a5
			return 1;
 b66:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b6a:	6422                	ld	s0,8(sp)
 b6c:	0141                	addi	sp,sp,16
 b6e:	8082                	ret

0000000000000b70 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
u8 compare_str_ic(const u8 * s1 , const u8 * s2){
 b70:	1141                	addi	sp,sp,-16
 b72:	e422                	sd	s0,8(sp)
 b74:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		u8 b1 = *s1++;
		u8 b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b76:	4665                	li	a2,25
	while(*s1 && *s2){
 b78:	a019                	j	b7e <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b7a:	04e79763          	bne	a5,a4,bc8 <compare_str_ic+0x58>
	while(*s1 && *s2){
 b7e:	00054783          	lbu	a5,0(a0)
 b82:	cb9d                	beqz	a5,bb8 <compare_str_ic+0x48>
 b84:	0005c703          	lbu	a4,0(a1)
 b88:	cb05                	beqz	a4,bb8 <compare_str_ic+0x48>
		u8 b1 = *s1++;
 b8a:	0505                	addi	a0,a0,1
		u8 b2 = *s2++;
 b8c:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b8e:	fbf7869b          	addiw	a3,a5,-65
 b92:	0ff6f693          	zext.b	a3,a3
 b96:	00d66663          	bltu	a2,a3,ba2 <compare_str_ic+0x32>
			b1 += 32;
 b9a:	0207879b          	addiw	a5,a5,32
 b9e:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 ba2:	fbf7069b          	addiw	a3,a4,-65
 ba6:	0ff6f693          	zext.b	a3,a3
 baa:	fcd668e3          	bltu	a2,a3,b7a <compare_str_ic+0xa>
			b2 += 32;
 bae:	0207071b          	addiw	a4,a4,32
 bb2:	0ff77713          	zext.b	a4,a4
 bb6:	b7d1                	j	b7a <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 bb8:	0005c503          	lbu	a0,0(a1)
 bbc:	8d1d                	sub	a0,a0,a5
			return 1;
 bbe:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 bc2:	6422                	ld	s0,8(sp)
 bc4:	0141                	addi	sp,sp,16
 bc6:	8082                	ret
			return 1;
 bc8:	4505                	li	a0,1
 bca:	bfe5                	j	bc2 <compare_str_ic+0x52>
