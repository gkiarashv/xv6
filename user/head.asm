
user/_head:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <head_usermode>:

[OUTPUT]: 

[ERROR]:
*/
void head_usermode(char **passedFiles, int lineCount){
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	e85a                	sd	s6,16(sp)
  12:	e45e                	sd	s7,8(sp)
  14:	e062                	sd	s8,0(sp)
  16:	0880                	addi	s0,sp,80
  18:	892a                	mv	s2,a0
  1a:	8a2e                	mv	s4,a1

	printf("Head command is getting executed in user mode\n");
  1c:	00001517          	auipc	a0,0x1
  20:	e3450513          	addi	a0,a0,-460 # e50 <get_time_perf+0x68>
  24:	00000097          	auipc	ra,0x0
  28:	7e2080e7          	jalr	2018(ra) # 806 <printf>

	/* Get number of files passed as argument*/
	char ** files = passedFiles;
	int numOfFiles=0;
	while(*files++){numOfFiles++;};
  2c:	00093503          	ld	a0,0(s2)
  30:	cd2d                	beqz	a0,aa <head_usermode+0xaa>
  32:	00890793          	addi	a5,s2,8
	int numOfFiles=0;
  36:	4981                	li	s3,0
	while(*files++){numOfFiles++;};
  38:	2985                	addiw	s3,s3,1
  3a:	07a1                	addi	a5,a5,8
  3c:	ff87b703          	ld	a4,-8(a5)
  40:	ff65                	bnez	a4,38 <head_usermode+0x38>
		head_run(STDIN, lineCount);
	else{
		while (*passedFiles){
			int fd = open_file(*passedFiles, RDONLY);

			if (fd == OPEN_FILE_ERROR)
  42:	5afd                	li	s5,-1
				printf("[ERR] opening the file '%s' failed \n",*passedFiles);
			else{
				/* Only print the header if number of files is more than 1 */
				if (numOfFiles > 1) 
  44:	4b05                	li	s6,1
					printf("==> %s <==\n",*passedFiles);
  46:	00001b97          	auipc	s7,0x1
  4a:	e62b8b93          	addi	s7,s7,-414 # ea8 <get_time_perf+0xc0>
				printf("[ERR] opening the file '%s' failed \n",*passedFiles);
  4e:	00001c17          	auipc	s8,0x1
  52:	e32c0c13          	addi	s8,s8,-462 # e80 <get_time_perf+0x98>
  56:	a805                	j	86 <head_usermode+0x86>
  58:	00093583          	ld	a1,0(s2)
  5c:	8562                	mv	a0,s8
  5e:	00000097          	auipc	ra,0x0
  62:	7a8080e7          	jalr	1960(ra) # 806 <printf>
  66:	a039                	j	74 <head_usermode+0x74>
				
				head_run(fd , lineCount);
  68:	85d2                	mv	a1,s4
  6a:	8526                	mv	a0,s1
  6c:	00001097          	auipc	ra,0x1
  70:	938080e7          	jalr	-1736(ra) # 9a4 <head_run>
			}
			close_file(fd);
  74:	8526                	mv	a0,s1
  76:	00001097          	auipc	ra,0x1
  7a:	d5a080e7          	jalr	-678(ra) # dd0 <close_file>
			passedFiles++;
  7e:	0921                	addi	s2,s2,8
		while (*passedFiles){
  80:	00093503          	ld	a0,0(s2)
  84:	c90d                	beqz	a0,b6 <head_usermode+0xb6>
			int fd = open_file(*passedFiles, RDONLY);
  86:	4581                	li	a1,0
  88:	00001097          	auipc	ra,0x1
  8c:	cce080e7          	jalr	-818(ra) # d56 <open_file>
  90:	84aa                	mv	s1,a0
			if (fd == OPEN_FILE_ERROR)
  92:	fd5503e3          	beq	a0,s5,58 <head_usermode+0x58>
				if (numOfFiles > 1) 
  96:	fd3b59e3          	bge	s6,s3,68 <head_usermode+0x68>
					printf("==> %s <==\n",*passedFiles);
  9a:	00093583          	ld	a1,0(s2)
  9e:	855e                	mv	a0,s7
  a0:	00000097          	auipc	ra,0x0
  a4:	766080e7          	jalr	1894(ra) # 806 <printf>
  a8:	b7c1                	j	68 <head_usermode+0x68>
		head_run(STDIN, lineCount);
  aa:	85d2                	mv	a1,s4
  ac:	4501                	li	a0,0
  ae:	00001097          	auipc	ra,0x1
  b2:	8f6080e7          	jalr	-1802(ra) # 9a4 <head_run>
		}
	}

	return 0;

}
  b6:	60a6                	ld	ra,72(sp)
  b8:	6406                	ld	s0,64(sp)
  ba:	74e2                	ld	s1,56(sp)
  bc:	7942                	ld	s2,48(sp)
  be:	79a2                	ld	s3,40(sp)
  c0:	7a02                	ld	s4,32(sp)
  c2:	6ae2                	ld	s5,24(sp)
  c4:	6b42                	ld	s6,16(sp)
  c6:	6ba2                	ld	s7,8(sp)
  c8:	6c02                	ld	s8,0(sp)
  ca:	6161                	addi	sp,sp,80
  cc:	8082                	ret

00000000000000ce <main>:
int main(int argc, char ** argv){
  ce:	711d                	addi	sp,sp,-96
  d0:	ec86                	sd	ra,88(sp)
  d2:	e8a2                	sd	s0,80(sp)
  d4:	e4a6                	sd	s1,72(sp)
  d6:	e0ca                	sd	s2,64(sp)
  d8:	fc4e                	sd	s3,56(sp)
  da:	f852                	sd	s4,48(sp)
  dc:	f456                	sd	s5,40(sp)
  de:	f05a                	sd	s6,32(sp)
  e0:	ec5e                	sd	s7,24(sp)
  e2:	e862                	sd	s8,16(sp)
  e4:	e466                	sd	s9,8(sp)
  e6:	1080                	addi	s0,sp,96
  e8:	892e                	mv	s2,a1

	/* Default value for lineCount */
	*lineCount = NUM_OF_LINES;

	/* Total number of files is maximum argc-1 requiring argc size storage for the last NULL*/
	char ** passedFiles = malloc(sizeof(char *) * (argc));
  ea:	0035151b          	slliw	a0,a0,0x3
  ee:	00000097          	auipc	ra,0x0
  f2:	7d0080e7          	jalr	2000(ra) # 8be <malloc>

	if (!passedFiles)
  f6:	c15d                	beqz	a0,19c <main+0xce>
  f8:	8b2a                	mv	s6,a0
		return NULL;
	


	int fileIdx = 0;
	cmd++;  // Skipping the program's name
  fa:	00890493          	addi	s1,s2,8
	
	while(*cmd){
  fe:	00893503          	ld	a0,8(s2)
 102:	c55d                	beqz	a0,1b0 <main+0xe2>
	char runInKernel = 0;
 104:	4b81                	li	s7,0
	*lineCount = NUM_OF_LINES;
 106:	49b9                	li	s3,14
	int fileIdx = 0;
 108:	4a01                	li	s4,0
		if (!compare_str(cmd[0], "-n")){
 10a:	00001a97          	auipc	s5,0x1
 10e:	daea8a93          	addi	s5,s5,-594 # eb8 <get_time_perf+0xd0>
			cmd++;
			*lineCount = atoi(cmd[0]);
		}else if (!compare_str(cmd[0], "-k"))
 112:	00001c17          	auipc	s8,0x1
 116:	daec0c13          	addi	s8,s8,-594 # ec0 <get_time_perf+0xd8>
			*runInKernel = 1;
 11a:	4c85                	li	s9,1
 11c:	a03d                	j	14a <main+0x7c>
		}else if (!compare_str(cmd[0], "-k"))
 11e:	85e2                	mv	a1,s8
 120:	6088                	ld	a0,0(s1)
 122:	00001097          	auipc	ra,0x1
 126:	b2e080e7          	jalr	-1234(ra) # c50 <compare_str>
 12a:	c909                	beqz	a0,13c <main+0x6e>
		else
			passedFiles[fileIdx++] = cmd[0];
 12c:	6098                	ld	a4,0(s1)
 12e:	003a1793          	slli	a5,s4,0x3
 132:	97da                	add	a5,a5,s6
 134:	e398                	sd	a4,0(a5)
 136:	2a05                	addiw	s4,s4,1
 138:	8926                	mv	s2,s1
 13a:	a019                	j	140 <main+0x72>
 13c:	8926                	mv	s2,s1
			*runInKernel = 1;
 13e:	8be6                	mv	s7,s9
			
		cmd++;
 140:	00890493          	addi	s1,s2,8
	while(*cmd){
 144:	00893503          	ld	a0,8(s2)
 148:	c105                	beqz	a0,168 <main+0x9a>
		if (!compare_str(cmd[0], "-n")){
 14a:	85d6                	mv	a1,s5
 14c:	00001097          	auipc	ra,0x1
 150:	b04080e7          	jalr	-1276(ra) # c50 <compare_str>
 154:	f569                	bnez	a0,11e <main+0x50>
			cmd++;
 156:	00848913          	addi	s2,s1,8
			*lineCount = atoi(cmd[0]);
 15a:	6488                	ld	a0,8(s1)
 15c:	00000097          	auipc	ra,0x0
 160:	1f6080e7          	jalr	502(ra) # 352 <atoi>
 164:	89aa                	mv	s3,a0
 166:	bfe9                	j	140 <main+0x72>
	}

	passedFiles[fileIdx]=NULL;
 168:	0a0e                	slli	s4,s4,0x3
 16a:	9a5a                	add	s4,s4,s6
 16c:	000a3023          	sd	zero,0(s4)
	if (runInKernel)
 170:	040b8363          	beqz	s7,1b6 <main+0xe8>
		head(passedFiles, lineCount);
 174:	85ce                	mv	a1,s3
 176:	855a                	mv	a0,s6
 178:	00000097          	auipc	ra,0x0
 17c:	374080e7          	jalr	884(ra) # 4ec <head>
	return 0;
 180:	4501                	li	a0,0
}
 182:	60e6                	ld	ra,88(sp)
 184:	6446                	ld	s0,80(sp)
 186:	64a6                	ld	s1,72(sp)
 188:	6906                	ld	s2,64(sp)
 18a:	79e2                	ld	s3,56(sp)
 18c:	7a42                	ld	s4,48(sp)
 18e:	7aa2                	ld	s5,40(sp)
 190:	7b02                	ld	s6,32(sp)
 192:	6be2                	ld	s7,24(sp)
 194:	6c42                	ld	s8,16(sp)
 196:	6ca2                	ld	s9,8(sp)
 198:	6125                	addi	sp,sp,96
 19a:	8082                	ret
		printf("[ERR] Cannot parse the issued command\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	d2c50513          	addi	a0,a0,-724 # ec8 <get_time_perf+0xe0>
 1a4:	00000097          	auipc	ra,0x0
 1a8:	662080e7          	jalr	1634(ra) # 806 <printf>
		return 1;
 1ac:	4505                	li	a0,1
 1ae:	bfd1                	j	182 <main+0xb4>
	passedFiles[fileIdx]=NULL;
 1b0:	000b3023          	sd	zero,0(s6)
	*lineCount = NUM_OF_LINES;
 1b4:	49b9                	li	s3,14
		head_usermode(passedFiles, lineCount);
 1b6:	85ce                	mv	a1,s3
 1b8:	855a                	mv	a0,s6
 1ba:	00000097          	auipc	ra,0x0
 1be:	e46080e7          	jalr	-442(ra) # 0 <head_usermode>
	return 0;
 1c2:	4501                	li	a0,0
 1c4:	bf7d                	j	182 <main+0xb4>

00000000000001c6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e406                	sd	ra,8(sp)
 1ca:	e022                	sd	s0,0(sp)
 1cc:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1ce:	00000097          	auipc	ra,0x0
 1d2:	f00080e7          	jalr	-256(ra) # ce <main>
  exit(0);
 1d6:	4501                	li	a0,0
 1d8:	00000097          	auipc	ra,0x0
 1dc:	274080e7          	jalr	628(ra) # 44c <exit>

00000000000001e0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e422                	sd	s0,8(sp)
 1e4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1e6:	87aa                	mv	a5,a0
 1e8:	0585                	addi	a1,a1,1
 1ea:	0785                	addi	a5,a5,1
 1ec:	fff5c703          	lbu	a4,-1(a1)
 1f0:	fee78fa3          	sb	a4,-1(a5)
 1f4:	fb75                	bnez	a4,1e8 <strcpy+0x8>
    ;
  return os;
}
 1f6:	6422                	ld	s0,8(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret

00000000000001fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 202:	00054783          	lbu	a5,0(a0)
 206:	cb91                	beqz	a5,21a <strcmp+0x1e>
 208:	0005c703          	lbu	a4,0(a1)
 20c:	00f71763          	bne	a4,a5,21a <strcmp+0x1e>
    p++, q++;
 210:	0505                	addi	a0,a0,1
 212:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 214:	00054783          	lbu	a5,0(a0)
 218:	fbe5                	bnez	a5,208 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 21a:	0005c503          	lbu	a0,0(a1)
}
 21e:	40a7853b          	subw	a0,a5,a0
 222:	6422                	ld	s0,8(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret

0000000000000228 <strlen>:

uint
strlen(const char *s)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e422                	sd	s0,8(sp)
 22c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 22e:	00054783          	lbu	a5,0(a0)
 232:	cf91                	beqz	a5,24e <strlen+0x26>
 234:	0505                	addi	a0,a0,1
 236:	87aa                	mv	a5,a0
 238:	4685                	li	a3,1
 23a:	9e89                	subw	a3,a3,a0
 23c:	00f6853b          	addw	a0,a3,a5
 240:	0785                	addi	a5,a5,1
 242:	fff7c703          	lbu	a4,-1(a5)
 246:	fb7d                	bnez	a4,23c <strlen+0x14>
    ;
  return n;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  for(n = 0; s[n]; n++)
 24e:	4501                	li	a0,0
 250:	bfe5                	j	248 <strlen+0x20>

0000000000000252 <memset>:

void*
memset(void *dst, int c, uint n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 258:	ca19                	beqz	a2,26e <memset+0x1c>
 25a:	87aa                	mv	a5,a0
 25c:	1602                	slli	a2,a2,0x20
 25e:	9201                	srli	a2,a2,0x20
 260:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 264:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 268:	0785                	addi	a5,a5,1
 26a:	fee79de3          	bne	a5,a4,264 <memset+0x12>
  }
  return dst;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret

0000000000000274 <strchr>:

char*
strchr(const char *s, char c)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  for(; *s; s++)
 27a:	00054783          	lbu	a5,0(a0)
 27e:	cb99                	beqz	a5,294 <strchr+0x20>
    if(*s == c)
 280:	00f58763          	beq	a1,a5,28e <strchr+0x1a>
  for(; *s; s++)
 284:	0505                	addi	a0,a0,1
 286:	00054783          	lbu	a5,0(a0)
 28a:	fbfd                	bnez	a5,280 <strchr+0xc>
      return (char*)s;
  return 0;
 28c:	4501                	li	a0,0
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
  return 0;
 294:	4501                	li	a0,0
 296:	bfe5                	j	28e <strchr+0x1a>

0000000000000298 <gets>:

char*
gets(char *buf, int max)
{
 298:	711d                	addi	sp,sp,-96
 29a:	ec86                	sd	ra,88(sp)
 29c:	e8a2                	sd	s0,80(sp)
 29e:	e4a6                	sd	s1,72(sp)
 2a0:	e0ca                	sd	s2,64(sp)
 2a2:	fc4e                	sd	s3,56(sp)
 2a4:	f852                	sd	s4,48(sp)
 2a6:	f456                	sd	s5,40(sp)
 2a8:	f05a                	sd	s6,32(sp)
 2aa:	ec5e                	sd	s7,24(sp)
 2ac:	1080                	addi	s0,sp,96
 2ae:	8baa                	mv	s7,a0
 2b0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b2:	892a                	mv	s2,a0
 2b4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2b6:	4aa9                	li	s5,10
 2b8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2ba:	89a6                	mv	s3,s1
 2bc:	2485                	addiw	s1,s1,1
 2be:	0344d863          	bge	s1,s4,2ee <gets+0x56>
    cc = read(0, &c, 1);
 2c2:	4605                	li	a2,1
 2c4:	faf40593          	addi	a1,s0,-81
 2c8:	4501                	li	a0,0
 2ca:	00000097          	auipc	ra,0x0
 2ce:	19a080e7          	jalr	410(ra) # 464 <read>
    if(cc < 1)
 2d2:	00a05e63          	blez	a0,2ee <gets+0x56>
    buf[i++] = c;
 2d6:	faf44783          	lbu	a5,-81(s0)
 2da:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2de:	01578763          	beq	a5,s5,2ec <gets+0x54>
 2e2:	0905                	addi	s2,s2,1
 2e4:	fd679be3          	bne	a5,s6,2ba <gets+0x22>
  for(i=0; i+1 < max; ){
 2e8:	89a6                	mv	s3,s1
 2ea:	a011                	j	2ee <gets+0x56>
 2ec:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ee:	99de                	add	s3,s3,s7
 2f0:	00098023          	sb	zero,0(s3)
  return buf;
}
 2f4:	855e                	mv	a0,s7
 2f6:	60e6                	ld	ra,88(sp)
 2f8:	6446                	ld	s0,80(sp)
 2fa:	64a6                	ld	s1,72(sp)
 2fc:	6906                	ld	s2,64(sp)
 2fe:	79e2                	ld	s3,56(sp)
 300:	7a42                	ld	s4,48(sp)
 302:	7aa2                	ld	s5,40(sp)
 304:	7b02                	ld	s6,32(sp)
 306:	6be2                	ld	s7,24(sp)
 308:	6125                	addi	sp,sp,96
 30a:	8082                	ret

000000000000030c <stat>:

int
stat(const char *n, struct stat *st)
{
 30c:	1101                	addi	sp,sp,-32
 30e:	ec06                	sd	ra,24(sp)
 310:	e822                	sd	s0,16(sp)
 312:	e426                	sd	s1,8(sp)
 314:	e04a                	sd	s2,0(sp)
 316:	1000                	addi	s0,sp,32
 318:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 31a:	4581                	li	a1,0
 31c:	00000097          	auipc	ra,0x0
 320:	170080e7          	jalr	368(ra) # 48c <open>
  if(fd < 0)
 324:	02054563          	bltz	a0,34e <stat+0x42>
 328:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 32a:	85ca                	mv	a1,s2
 32c:	00000097          	auipc	ra,0x0
 330:	178080e7          	jalr	376(ra) # 4a4 <fstat>
 334:	892a                	mv	s2,a0
  close(fd);
 336:	8526                	mv	a0,s1
 338:	00000097          	auipc	ra,0x0
 33c:	13c080e7          	jalr	316(ra) # 474 <close>
  return r;
}
 340:	854a                	mv	a0,s2
 342:	60e2                	ld	ra,24(sp)
 344:	6442                	ld	s0,16(sp)
 346:	64a2                	ld	s1,8(sp)
 348:	6902                	ld	s2,0(sp)
 34a:	6105                	addi	sp,sp,32
 34c:	8082                	ret
    return -1;
 34e:	597d                	li	s2,-1
 350:	bfc5                	j	340 <stat+0x34>

0000000000000352 <atoi>:

int
atoi(const char *s)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 358:	00054683          	lbu	a3,0(a0)
 35c:	fd06879b          	addiw	a5,a3,-48
 360:	0ff7f793          	zext.b	a5,a5
 364:	4625                	li	a2,9
 366:	02f66863          	bltu	a2,a5,396 <atoi+0x44>
 36a:	872a                	mv	a4,a0
  n = 0;
 36c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 36e:	0705                	addi	a4,a4,1
 370:	0025179b          	slliw	a5,a0,0x2
 374:	9fa9                	addw	a5,a5,a0
 376:	0017979b          	slliw	a5,a5,0x1
 37a:	9fb5                	addw	a5,a5,a3
 37c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 380:	00074683          	lbu	a3,0(a4)
 384:	fd06879b          	addiw	a5,a3,-48
 388:	0ff7f793          	zext.b	a5,a5
 38c:	fef671e3          	bgeu	a2,a5,36e <atoi+0x1c>
  return n;
}
 390:	6422                	ld	s0,8(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret
  n = 0;
 396:	4501                	li	a0,0
 398:	bfe5                	j	390 <atoi+0x3e>

000000000000039a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e422                	sd	s0,8(sp)
 39e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3a0:	02b57463          	bgeu	a0,a1,3c8 <memmove+0x2e>
    while(n-- > 0)
 3a4:	00c05f63          	blez	a2,3c2 <memmove+0x28>
 3a8:	1602                	slli	a2,a2,0x20
 3aa:	9201                	srli	a2,a2,0x20
 3ac:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3b0:	872a                	mv	a4,a0
      *dst++ = *src++;
 3b2:	0585                	addi	a1,a1,1
 3b4:	0705                	addi	a4,a4,1
 3b6:	fff5c683          	lbu	a3,-1(a1)
 3ba:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3be:	fee79ae3          	bne	a5,a4,3b2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3c2:	6422                	ld	s0,8(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret
    dst += n;
 3c8:	00c50733          	add	a4,a0,a2
    src += n;
 3cc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ce:	fec05ae3          	blez	a2,3c2 <memmove+0x28>
 3d2:	fff6079b          	addiw	a5,a2,-1
 3d6:	1782                	slli	a5,a5,0x20
 3d8:	9381                	srli	a5,a5,0x20
 3da:	fff7c793          	not	a5,a5
 3de:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3e0:	15fd                	addi	a1,a1,-1
 3e2:	177d                	addi	a4,a4,-1
 3e4:	0005c683          	lbu	a3,0(a1)
 3e8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ec:	fee79ae3          	bne	a5,a4,3e0 <memmove+0x46>
 3f0:	bfc9                	j	3c2 <memmove+0x28>

00000000000003f2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e422                	sd	s0,8(sp)
 3f6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f8:	ca05                	beqz	a2,428 <memcmp+0x36>
 3fa:	fff6069b          	addiw	a3,a2,-1
 3fe:	1682                	slli	a3,a3,0x20
 400:	9281                	srli	a3,a3,0x20
 402:	0685                	addi	a3,a3,1
 404:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 406:	00054783          	lbu	a5,0(a0)
 40a:	0005c703          	lbu	a4,0(a1)
 40e:	00e79863          	bne	a5,a4,41e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 412:	0505                	addi	a0,a0,1
    p2++;
 414:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 416:	fed518e3          	bne	a0,a3,406 <memcmp+0x14>
  }
  return 0;
 41a:	4501                	li	a0,0
 41c:	a019                	j	422 <memcmp+0x30>
      return *p1 - *p2;
 41e:	40e7853b          	subw	a0,a5,a4
}
 422:	6422                	ld	s0,8(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret
  return 0;
 428:	4501                	li	a0,0
 42a:	bfe5                	j	422 <memcmp+0x30>

000000000000042c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 42c:	1141                	addi	sp,sp,-16
 42e:	e406                	sd	ra,8(sp)
 430:	e022                	sd	s0,0(sp)
 432:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 434:	00000097          	auipc	ra,0x0
 438:	f66080e7          	jalr	-154(ra) # 39a <memmove>
}
 43c:	60a2                	ld	ra,8(sp)
 43e:	6402                	ld	s0,0(sp)
 440:	0141                	addi	sp,sp,16
 442:	8082                	ret

0000000000000444 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 444:	4885                	li	a7,1
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <exit>:
.global exit
exit:
 li a7, SYS_exit
 44c:	4889                	li	a7,2
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <wait>:
.global wait
wait:
 li a7, SYS_wait
 454:	488d                	li	a7,3
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 45c:	4891                	li	a7,4
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <read>:
.global read
read:
 li a7, SYS_read
 464:	4895                	li	a7,5
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <write>:
.global write
write:
 li a7, SYS_write
 46c:	48c1                	li	a7,16
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <close>:
.global close
close:
 li a7, SYS_close
 474:	48d5                	li	a7,21
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <kill>:
.global kill
kill:
 li a7, SYS_kill
 47c:	4899                	li	a7,6
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <exec>:
.global exec
exec:
 li a7, SYS_exec
 484:	489d                	li	a7,7
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <open>:
.global open
open:
 li a7, SYS_open
 48c:	48bd                	li	a7,15
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 494:	48c5                	li	a7,17
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 49c:	48c9                	li	a7,18
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a4:	48a1                	li	a7,8
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <link>:
.global link
link:
 li a7, SYS_link
 4ac:	48cd                	li	a7,19
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b4:	48d1                	li	a7,20
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4bc:	48a5                	li	a7,9
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c4:	48a9                	li	a7,10
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4cc:	48ad                	li	a7,11
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4d4:	48b1                	li	a7,12
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4dc:	48b5                	li	a7,13
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e4:	48b9                	li	a7,14
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <head>:
.global head
head:
 li a7, SYS_head
 4ec:	48d9                	li	a7,22
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 4f4:	48dd                	li	a7,23
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <ps>:
.global ps
ps:
 li a7, SYS_ps
 4fc:	48e1                	li	a7,24
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <times>:
.global times
times:
 li a7, SYS_times
 504:	48e5                	li	a7,25
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 50c:	48e9                	li	a7,26
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 514:	48ed                	li	a7,27
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 51c:	48f1                	li	a7,28
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 524:	48f5                	li	a7,29
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 52c:	1101                	addi	sp,sp,-32
 52e:	ec06                	sd	ra,24(sp)
 530:	e822                	sd	s0,16(sp)
 532:	1000                	addi	s0,sp,32
 534:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 538:	4605                	li	a2,1
 53a:	fef40593          	addi	a1,s0,-17
 53e:	00000097          	auipc	ra,0x0
 542:	f2e080e7          	jalr	-210(ra) # 46c <write>
}
 546:	60e2                	ld	ra,24(sp)
 548:	6442                	ld	s0,16(sp)
 54a:	6105                	addi	sp,sp,32
 54c:	8082                	ret

000000000000054e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 54e:	7139                	addi	sp,sp,-64
 550:	fc06                	sd	ra,56(sp)
 552:	f822                	sd	s0,48(sp)
 554:	f426                	sd	s1,40(sp)
 556:	f04a                	sd	s2,32(sp)
 558:	ec4e                	sd	s3,24(sp)
 55a:	0080                	addi	s0,sp,64
 55c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 55e:	c299                	beqz	a3,564 <printint+0x16>
 560:	0805c963          	bltz	a1,5f2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 564:	2581                	sext.w	a1,a1
  neg = 0;
 566:	4881                	li	a7,0
 568:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 56c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 56e:	2601                	sext.w	a2,a2
 570:	00001517          	auipc	a0,0x1
 574:	9e050513          	addi	a0,a0,-1568 # f50 <digits>
 578:	883a                	mv	a6,a4
 57a:	2705                	addiw	a4,a4,1
 57c:	02c5f7bb          	remuw	a5,a1,a2
 580:	1782                	slli	a5,a5,0x20
 582:	9381                	srli	a5,a5,0x20
 584:	97aa                	add	a5,a5,a0
 586:	0007c783          	lbu	a5,0(a5)
 58a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 58e:	0005879b          	sext.w	a5,a1
 592:	02c5d5bb          	divuw	a1,a1,a2
 596:	0685                	addi	a3,a3,1
 598:	fec7f0e3          	bgeu	a5,a2,578 <printint+0x2a>
  if(neg)
 59c:	00088c63          	beqz	a7,5b4 <printint+0x66>
    buf[i++] = '-';
 5a0:	fd070793          	addi	a5,a4,-48
 5a4:	00878733          	add	a4,a5,s0
 5a8:	02d00793          	li	a5,45
 5ac:	fef70823          	sb	a5,-16(a4)
 5b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5b4:	02e05863          	blez	a4,5e4 <printint+0x96>
 5b8:	fc040793          	addi	a5,s0,-64
 5bc:	00e78933          	add	s2,a5,a4
 5c0:	fff78993          	addi	s3,a5,-1
 5c4:	99ba                	add	s3,s3,a4
 5c6:	377d                	addiw	a4,a4,-1
 5c8:	1702                	slli	a4,a4,0x20
 5ca:	9301                	srli	a4,a4,0x20
 5cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5d0:	fff94583          	lbu	a1,-1(s2)
 5d4:	8526                	mv	a0,s1
 5d6:	00000097          	auipc	ra,0x0
 5da:	f56080e7          	jalr	-170(ra) # 52c <putc>
  while(--i >= 0)
 5de:	197d                	addi	s2,s2,-1
 5e0:	ff3918e3          	bne	s2,s3,5d0 <printint+0x82>
}
 5e4:	70e2                	ld	ra,56(sp)
 5e6:	7442                	ld	s0,48(sp)
 5e8:	74a2                	ld	s1,40(sp)
 5ea:	7902                	ld	s2,32(sp)
 5ec:	69e2                	ld	s3,24(sp)
 5ee:	6121                	addi	sp,sp,64
 5f0:	8082                	ret
    x = -xx;
 5f2:	40b005bb          	negw	a1,a1
    neg = 1;
 5f6:	4885                	li	a7,1
    x = -xx;
 5f8:	bf85                	j	568 <printint+0x1a>

00000000000005fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5fa:	7119                	addi	sp,sp,-128
 5fc:	fc86                	sd	ra,120(sp)
 5fe:	f8a2                	sd	s0,112(sp)
 600:	f4a6                	sd	s1,104(sp)
 602:	f0ca                	sd	s2,96(sp)
 604:	ecce                	sd	s3,88(sp)
 606:	e8d2                	sd	s4,80(sp)
 608:	e4d6                	sd	s5,72(sp)
 60a:	e0da                	sd	s6,64(sp)
 60c:	fc5e                	sd	s7,56(sp)
 60e:	f862                	sd	s8,48(sp)
 610:	f466                	sd	s9,40(sp)
 612:	f06a                	sd	s10,32(sp)
 614:	ec6e                	sd	s11,24(sp)
 616:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 618:	0005c903          	lbu	s2,0(a1)
 61c:	18090f63          	beqz	s2,7ba <vprintf+0x1c0>
 620:	8aaa                	mv	s5,a0
 622:	8b32                	mv	s6,a2
 624:	00158493          	addi	s1,a1,1
  state = 0;
 628:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 62a:	02500a13          	li	s4,37
 62e:	4c55                	li	s8,21
 630:	00001c97          	auipc	s9,0x1
 634:	8c8c8c93          	addi	s9,s9,-1848 # ef8 <get_time_perf+0x110>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 638:	02800d93          	li	s11,40
  putc(fd, 'x');
 63c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63e:	00001b97          	auipc	s7,0x1
 642:	912b8b93          	addi	s7,s7,-1774 # f50 <digits>
 646:	a839                	j	664 <vprintf+0x6a>
        putc(fd, c);
 648:	85ca                	mv	a1,s2
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	ee0080e7          	jalr	-288(ra) # 52c <putc>
 654:	a019                	j	65a <vprintf+0x60>
    } else if(state == '%'){
 656:	01498d63          	beq	s3,s4,670 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 65a:	0485                	addi	s1,s1,1
 65c:	fff4c903          	lbu	s2,-1(s1)
 660:	14090d63          	beqz	s2,7ba <vprintf+0x1c0>
    if(state == 0){
 664:	fe0999e3          	bnez	s3,656 <vprintf+0x5c>
      if(c == '%'){
 668:	ff4910e3          	bne	s2,s4,648 <vprintf+0x4e>
        state = '%';
 66c:	89d2                	mv	s3,s4
 66e:	b7f5                	j	65a <vprintf+0x60>
      if(c == 'd'){
 670:	11490c63          	beq	s2,s4,788 <vprintf+0x18e>
 674:	f9d9079b          	addiw	a5,s2,-99
 678:	0ff7f793          	zext.b	a5,a5
 67c:	10fc6e63          	bltu	s8,a5,798 <vprintf+0x19e>
 680:	f9d9079b          	addiw	a5,s2,-99
 684:	0ff7f713          	zext.b	a4,a5
 688:	10ec6863          	bltu	s8,a4,798 <vprintf+0x19e>
 68c:	00271793          	slli	a5,a4,0x2
 690:	97e6                	add	a5,a5,s9
 692:	439c                	lw	a5,0(a5)
 694:	97e6                	add	a5,a5,s9
 696:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 698:	008b0913          	addi	s2,s6,8
 69c:	4685                	li	a3,1
 69e:	4629                	li	a2,10
 6a0:	000b2583          	lw	a1,0(s6)
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	ea8080e7          	jalr	-344(ra) # 54e <printint>
 6ae:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b765                	j	65a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	008b0913          	addi	s2,s6,8
 6b8:	4681                	li	a3,0
 6ba:	4629                	li	a2,10
 6bc:	000b2583          	lw	a1,0(s6)
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e8c080e7          	jalr	-372(ra) # 54e <printint>
 6ca:	8b4a                	mv	s6,s2
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b771                	j	65a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6d0:	008b0913          	addi	s2,s6,8
 6d4:	4681                	li	a3,0
 6d6:	866a                	mv	a2,s10
 6d8:	000b2583          	lw	a1,0(s6)
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	e70080e7          	jalr	-400(ra) # 54e <printint>
 6e6:	8b4a                	mv	s6,s2
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bf85                	j	65a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6ec:	008b0793          	addi	a5,s6,8
 6f0:	f8f43423          	sd	a5,-120(s0)
 6f4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6f8:	03000593          	li	a1,48
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	e2e080e7          	jalr	-466(ra) # 52c <putc>
  putc(fd, 'x');
 706:	07800593          	li	a1,120
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	e20080e7          	jalr	-480(ra) # 52c <putc>
 714:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 716:	03c9d793          	srli	a5,s3,0x3c
 71a:	97de                	add	a5,a5,s7
 71c:	0007c583          	lbu	a1,0(a5)
 720:	8556                	mv	a0,s5
 722:	00000097          	auipc	ra,0x0
 726:	e0a080e7          	jalr	-502(ra) # 52c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 72a:	0992                	slli	s3,s3,0x4
 72c:	397d                	addiw	s2,s2,-1
 72e:	fe0914e3          	bnez	s2,716 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 732:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 736:	4981                	li	s3,0
 738:	b70d                	j	65a <vprintf+0x60>
        s = va_arg(ap, char*);
 73a:	008b0913          	addi	s2,s6,8
 73e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 742:	02098163          	beqz	s3,764 <vprintf+0x16a>
        while(*s != 0){
 746:	0009c583          	lbu	a1,0(s3)
 74a:	c5ad                	beqz	a1,7b4 <vprintf+0x1ba>
          putc(fd, *s);
 74c:	8556                	mv	a0,s5
 74e:	00000097          	auipc	ra,0x0
 752:	dde080e7          	jalr	-546(ra) # 52c <putc>
          s++;
 756:	0985                	addi	s3,s3,1
        while(*s != 0){
 758:	0009c583          	lbu	a1,0(s3)
 75c:	f9e5                	bnez	a1,74c <vprintf+0x152>
        s = va_arg(ap, char*);
 75e:	8b4a                	mv	s6,s2
      state = 0;
 760:	4981                	li	s3,0
 762:	bde5                	j	65a <vprintf+0x60>
          s = "(null)";
 764:	00000997          	auipc	s3,0x0
 768:	78c98993          	addi	s3,s3,1932 # ef0 <get_time_perf+0x108>
        while(*s != 0){
 76c:	85ee                	mv	a1,s11
 76e:	bff9                	j	74c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 770:	008b0913          	addi	s2,s6,8
 774:	000b4583          	lbu	a1,0(s6)
 778:	8556                	mv	a0,s5
 77a:	00000097          	auipc	ra,0x0
 77e:	db2080e7          	jalr	-590(ra) # 52c <putc>
 782:	8b4a                	mv	s6,s2
      state = 0;
 784:	4981                	li	s3,0
 786:	bdd1                	j	65a <vprintf+0x60>
        putc(fd, c);
 788:	85d2                	mv	a1,s4
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	da0080e7          	jalr	-608(ra) # 52c <putc>
      state = 0;
 794:	4981                	li	s3,0
 796:	b5d1                	j	65a <vprintf+0x60>
        putc(fd, '%');
 798:	85d2                	mv	a1,s4
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	d90080e7          	jalr	-624(ra) # 52c <putc>
        putc(fd, c);
 7a4:	85ca                	mv	a1,s2
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	d84080e7          	jalr	-636(ra) # 52c <putc>
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b565                	j	65a <vprintf+0x60>
        s = va_arg(ap, char*);
 7b4:	8b4a                	mv	s6,s2
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b54d                	j	65a <vprintf+0x60>
    }
  }
}
 7ba:	70e6                	ld	ra,120(sp)
 7bc:	7446                	ld	s0,112(sp)
 7be:	74a6                	ld	s1,104(sp)
 7c0:	7906                	ld	s2,96(sp)
 7c2:	69e6                	ld	s3,88(sp)
 7c4:	6a46                	ld	s4,80(sp)
 7c6:	6aa6                	ld	s5,72(sp)
 7c8:	6b06                	ld	s6,64(sp)
 7ca:	7be2                	ld	s7,56(sp)
 7cc:	7c42                	ld	s8,48(sp)
 7ce:	7ca2                	ld	s9,40(sp)
 7d0:	7d02                	ld	s10,32(sp)
 7d2:	6de2                	ld	s11,24(sp)
 7d4:	6109                	addi	sp,sp,128
 7d6:	8082                	ret

00000000000007d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d8:	715d                	addi	sp,sp,-80
 7da:	ec06                	sd	ra,24(sp)
 7dc:	e822                	sd	s0,16(sp)
 7de:	1000                	addi	s0,sp,32
 7e0:	e010                	sd	a2,0(s0)
 7e2:	e414                	sd	a3,8(s0)
 7e4:	e818                	sd	a4,16(s0)
 7e6:	ec1c                	sd	a5,24(s0)
 7e8:	03043023          	sd	a6,32(s0)
 7ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f4:	8622                	mv	a2,s0
 7f6:	00000097          	auipc	ra,0x0
 7fa:	e04080e7          	jalr	-508(ra) # 5fa <vprintf>
}
 7fe:	60e2                	ld	ra,24(sp)
 800:	6442                	ld	s0,16(sp)
 802:	6161                	addi	sp,sp,80
 804:	8082                	ret

0000000000000806 <printf>:

void
printf(const char *fmt, ...)
{
 806:	711d                	addi	sp,sp,-96
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e40c                	sd	a1,8(s0)
 810:	e810                	sd	a2,16(s0)
 812:	ec14                	sd	a3,24(s0)
 814:	f018                	sd	a4,32(s0)
 816:	f41c                	sd	a5,40(s0)
 818:	03043823          	sd	a6,48(s0)
 81c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 820:	00840613          	addi	a2,s0,8
 824:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 828:	85aa                	mv	a1,a0
 82a:	4505                	li	a0,1
 82c:	00000097          	auipc	ra,0x0
 830:	dce080e7          	jalr	-562(ra) # 5fa <vprintf>
}
 834:	60e2                	ld	ra,24(sp)
 836:	6442                	ld	s0,16(sp)
 838:	6125                	addi	sp,sp,96
 83a:	8082                	ret

000000000000083c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83c:	1141                	addi	sp,sp,-16
 83e:	e422                	sd	s0,8(sp)
 840:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 842:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 846:	00000797          	auipc	a5,0x0
 84a:	7ba7b783          	ld	a5,1978(a5) # 1000 <freep>
 84e:	a02d                	j	878 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 850:	4618                	lw	a4,8(a2)
 852:	9f2d                	addw	a4,a4,a1
 854:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 858:	6398                	ld	a4,0(a5)
 85a:	6310                	ld	a2,0(a4)
 85c:	a83d                	j	89a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 85e:	ff852703          	lw	a4,-8(a0)
 862:	9f31                	addw	a4,a4,a2
 864:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 866:	ff053683          	ld	a3,-16(a0)
 86a:	a091                	j	8ae <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	6398                	ld	a4,0(a5)
 86e:	00e7e463          	bltu	a5,a4,876 <free+0x3a>
 872:	00e6ea63          	bltu	a3,a4,886 <free+0x4a>
{
 876:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 878:	fed7fae3          	bgeu	a5,a3,86c <free+0x30>
 87c:	6398                	ld	a4,0(a5)
 87e:	00e6e463          	bltu	a3,a4,886 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 882:	fee7eae3          	bltu	a5,a4,876 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 886:	ff852583          	lw	a1,-8(a0)
 88a:	6390                	ld	a2,0(a5)
 88c:	02059813          	slli	a6,a1,0x20
 890:	01c85713          	srli	a4,a6,0x1c
 894:	9736                	add	a4,a4,a3
 896:	fae60de3          	beq	a2,a4,850 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 89a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 89e:	4790                	lw	a2,8(a5)
 8a0:	02061593          	slli	a1,a2,0x20
 8a4:	01c5d713          	srli	a4,a1,0x1c
 8a8:	973e                	add	a4,a4,a5
 8aa:	fae68ae3          	beq	a3,a4,85e <free+0x22>
    p->s.ptr = bp->s.ptr;
 8ae:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8b0:	00000717          	auipc	a4,0x0
 8b4:	74f73823          	sd	a5,1872(a4) # 1000 <freep>
}
 8b8:	6422                	ld	s0,8(sp)
 8ba:	0141                	addi	sp,sp,16
 8bc:	8082                	ret

00000000000008be <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8be:	7139                	addi	sp,sp,-64
 8c0:	fc06                	sd	ra,56(sp)
 8c2:	f822                	sd	s0,48(sp)
 8c4:	f426                	sd	s1,40(sp)
 8c6:	f04a                	sd	s2,32(sp)
 8c8:	ec4e                	sd	s3,24(sp)
 8ca:	e852                	sd	s4,16(sp)
 8cc:	e456                	sd	s5,8(sp)
 8ce:	e05a                	sd	s6,0(sp)
 8d0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d2:	02051493          	slli	s1,a0,0x20
 8d6:	9081                	srli	s1,s1,0x20
 8d8:	04bd                	addi	s1,s1,15
 8da:	8091                	srli	s1,s1,0x4
 8dc:	0014899b          	addiw	s3,s1,1
 8e0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8e2:	00000517          	auipc	a0,0x0
 8e6:	71e53503          	ld	a0,1822(a0) # 1000 <freep>
 8ea:	c515                	beqz	a0,916 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ee:	4798                	lw	a4,8(a5)
 8f0:	02977f63          	bgeu	a4,s1,92e <malloc+0x70>
 8f4:	8a4e                	mv	s4,s3
 8f6:	0009871b          	sext.w	a4,s3
 8fa:	6685                	lui	a3,0x1
 8fc:	00d77363          	bgeu	a4,a3,902 <malloc+0x44>
 900:	6a05                	lui	s4,0x1
 902:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 906:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 90a:	00000917          	auipc	s2,0x0
 90e:	6f690913          	addi	s2,s2,1782 # 1000 <freep>
  if(p == (char*)-1)
 912:	5afd                	li	s5,-1
 914:	a895                	j	988 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 916:	00000797          	auipc	a5,0x0
 91a:	6fa78793          	addi	a5,a5,1786 # 1010 <base>
 91e:	00000717          	auipc	a4,0x0
 922:	6ef73123          	sd	a5,1762(a4) # 1000 <freep>
 926:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 928:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 92c:	b7e1                	j	8f4 <malloc+0x36>
      if(p->s.size == nunits)
 92e:	02e48c63          	beq	s1,a4,966 <malloc+0xa8>
        p->s.size -= nunits;
 932:	4137073b          	subw	a4,a4,s3
 936:	c798                	sw	a4,8(a5)
        p += p->s.size;
 938:	02071693          	slli	a3,a4,0x20
 93c:	01c6d713          	srli	a4,a3,0x1c
 940:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 942:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 946:	00000717          	auipc	a4,0x0
 94a:	6aa73d23          	sd	a0,1722(a4) # 1000 <freep>
      return (void*)(p + 1);
 94e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 952:	70e2                	ld	ra,56(sp)
 954:	7442                	ld	s0,48(sp)
 956:	74a2                	ld	s1,40(sp)
 958:	7902                	ld	s2,32(sp)
 95a:	69e2                	ld	s3,24(sp)
 95c:	6a42                	ld	s4,16(sp)
 95e:	6aa2                	ld	s5,8(sp)
 960:	6b02                	ld	s6,0(sp)
 962:	6121                	addi	sp,sp,64
 964:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 966:	6398                	ld	a4,0(a5)
 968:	e118                	sd	a4,0(a0)
 96a:	bff1                	j	946 <malloc+0x88>
  hp->s.size = nu;
 96c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 970:	0541                	addi	a0,a0,16
 972:	00000097          	auipc	ra,0x0
 976:	eca080e7          	jalr	-310(ra) # 83c <free>
  return freep;
 97a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 97e:	d971                	beqz	a0,952 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 980:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 982:	4798                	lw	a4,8(a5)
 984:	fa9775e3          	bgeu	a4,s1,92e <malloc+0x70>
    if(p == freep)
 988:	00093703          	ld	a4,0(s2)
 98c:	853e                	mv	a0,a5
 98e:	fef719e3          	bne	a4,a5,980 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 992:	8552                	mv	a0,s4
 994:	00000097          	auipc	ra,0x0
 998:	b40080e7          	jalr	-1216(ra) # 4d4 <sbrk>
  if(p == (char*)-1)
 99c:	fd5518e3          	bne	a0,s5,96c <malloc+0xae>
        return 0;
 9a0:	4501                	li	a0,0
 9a2:	bf45                	j	952 <malloc+0x94>

00000000000009a4 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 9a4:	c1d9                	beqz	a1,a2a <head_run+0x86>
void head_run(int fd, int numOfLines){
 9a6:	dd010113          	addi	sp,sp,-560
 9aa:	22113423          	sd	ra,552(sp)
 9ae:	22813023          	sd	s0,544(sp)
 9b2:	20913c23          	sd	s1,536(sp)
 9b6:	21213823          	sd	s2,528(sp)
 9ba:	21313423          	sd	s3,520(sp)
 9be:	21413023          	sd	s4,512(sp)
 9c2:	1c00                	addi	s0,sp,560
 9c4:	892a                	mv	s2,a0
 9c6:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 9ca:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 9cc:	00000a17          	auipc	s4,0x0
 9d0:	5c4a0a13          	addi	s4,s4,1476 # f90 <digits+0x40>
		readStatus = read_line(fd, line);
 9d4:	dd840593          	addi	a1,s0,-552
 9d8:	854a                	mv	a0,s2
 9da:	00000097          	auipc	ra,0x0
 9de:	394080e7          	jalr	916(ra) # d6e <read_line>
		if (readStatus == READ_ERROR){
 9e2:	01350d63          	beq	a0,s3,9fc <head_run+0x58>
		if (readStatus == READ_EOF)
 9e6:	c11d                	beqz	a0,a0c <head_run+0x68>
		printf("%s",line);
 9e8:	dd840593          	addi	a1,s0,-552
 9ec:	8552                	mv	a0,s4
 9ee:	00000097          	auipc	ra,0x0
 9f2:	e18080e7          	jalr	-488(ra) # 806 <printf>
	while(numOfLines--){
 9f6:	34fd                	addiw	s1,s1,-1
 9f8:	fcf1                	bnez	s1,9d4 <head_run+0x30>
 9fa:	a809                	j	a0c <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 9fc:	00000517          	auipc	a0,0x0
 a00:	56c50513          	addi	a0,a0,1388 # f68 <digits+0x18>
 a04:	00000097          	auipc	ra,0x0
 a08:	e02080e7          	jalr	-510(ra) # 806 <printf>

	}
}
 a0c:	22813083          	ld	ra,552(sp)
 a10:	22013403          	ld	s0,544(sp)
 a14:	21813483          	ld	s1,536(sp)
 a18:	21013903          	ld	s2,528(sp)
 a1c:	20813983          	ld	s3,520(sp)
 a20:	20013a03          	ld	s4,512(sp)
 a24:	23010113          	addi	sp,sp,560
 a28:	8082                	ret
 a2a:	8082                	ret

0000000000000a2c <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 a2c:	ba010113          	addi	sp,sp,-1120
 a30:	44113c23          	sd	ra,1112(sp)
 a34:	44813823          	sd	s0,1104(sp)
 a38:	44913423          	sd	s1,1096(sp)
 a3c:	45213023          	sd	s2,1088(sp)
 a40:	43313c23          	sd	s3,1080(sp)
 a44:	43413823          	sd	s4,1072(sp)
 a48:	43513423          	sd	s5,1064(sp)
 a4c:	43613023          	sd	s6,1056(sp)
 a50:	41713c23          	sd	s7,1048(sp)
 a54:	41813823          	sd	s8,1040(sp)
 a58:	41913423          	sd	s9,1032(sp)
 a5c:	41a13023          	sd	s10,1024(sp)
 a60:	3fb13c23          	sd	s11,1016(sp)
 a64:	46010413          	addi	s0,sp,1120
 a68:	89aa                	mv	s3,a0
 a6a:	8aae                	mv	s5,a1
 a6c:	8c32                	mv	s8,a2
 a6e:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 a70:	d9840593          	addi	a1,s0,-616
 a74:	00000097          	auipc	ra,0x0
 a78:	2fa080e7          	jalr	762(ra) # d6e <read_line>


  if (readStatus == READ_ERROR)
 a7c:	57fd                	li	a5,-1
 a7e:	04f50163          	beq	a0,a5,ac0 <uniq_run+0x94>
 a82:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 a84:	ed21                	bnez	a0,adc <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 a86:	45813083          	ld	ra,1112(sp)
 a8a:	45013403          	ld	s0,1104(sp)
 a8e:	44813483          	ld	s1,1096(sp)
 a92:	44013903          	ld	s2,1088(sp)
 a96:	43813983          	ld	s3,1080(sp)
 a9a:	43013a03          	ld	s4,1072(sp)
 a9e:	42813a83          	ld	s5,1064(sp)
 aa2:	42013b03          	ld	s6,1056(sp)
 aa6:	41813b83          	ld	s7,1048(sp)
 aaa:	41013c03          	ld	s8,1040(sp)
 aae:	40813c83          	ld	s9,1032(sp)
 ab2:	40013d03          	ld	s10,1024(sp)
 ab6:	3f813d83          	ld	s11,1016(sp)
 aba:	46010113          	addi	sp,sp,1120
 abe:	8082                	ret
    printf("[ERR] Error reading from the file ");
 ac0:	00000517          	auipc	a0,0x0
 ac4:	4d850513          	addi	a0,a0,1240 # f98 <digits+0x48>
 ac8:	00000097          	auipc	ra,0x0
 acc:	d3e080e7          	jalr	-706(ra) # 806 <printf>
 ad0:	bf5d                	j	a86 <uniq_run+0x5a>
 ad2:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 ad4:	8926                	mv	s2,s1
 ad6:	84be                	mv	s1,a5
        lineCount = 1;
 ad8:	8b6a                	mv	s6,s10
 ada:	a8ed                	j	bd4 <uniq_run+0x1a8>
    int lineCount=1;
 adc:	4b05                	li	s6,1
  char * line2 = buffer2;
 ade:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 ae2:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 ae6:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 ae8:	4d05                	li	s10,1
              printf("%s",line1);
 aea:	00000d97          	auipc	s11,0x0
 aee:	4a6d8d93          	addi	s11,s11,1190 # f90 <digits+0x40>
 af2:	a0cd                	j	bd4 <uniq_run+0x1a8>
            if (repeatedLines){
 af4:	020a0b63          	beqz	s4,b2a <uniq_run+0xfe>
                if (isRepeated){
 af8:	f80b87e3          	beqz	s7,a86 <uniq_run+0x5a>
                    if (showCount)
 afc:	000c0d63          	beqz	s8,b16 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 b00:	864a                	mv	a2,s2
 b02:	85da                	mv	a1,s6
 b04:	00000517          	auipc	a0,0x0
 b08:	4bc50513          	addi	a0,a0,1212 # fc0 <digits+0x70>
 b0c:	00000097          	auipc	ra,0x0
 b10:	cfa080e7          	jalr	-774(ra) # 806 <printf>
 b14:	bf8d                	j	a86 <uniq_run+0x5a>
                      printf("%s",line1);
 b16:	85ca                	mv	a1,s2
 b18:	00000517          	auipc	a0,0x0
 b1c:	47850513          	addi	a0,a0,1144 # f90 <digits+0x40>
 b20:	00000097          	auipc	ra,0x0
 b24:	ce6080e7          	jalr	-794(ra) # 806 <printf>
 b28:	bfb9                	j	a86 <uniq_run+0x5a>
                if (showCount)
 b2a:	000c0d63          	beqz	s8,b44 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 b2e:	864a                	mv	a2,s2
 b30:	85da                	mv	a1,s6
 b32:	00000517          	auipc	a0,0x0
 b36:	48e50513          	addi	a0,a0,1166 # fc0 <digits+0x70>
 b3a:	00000097          	auipc	ra,0x0
 b3e:	ccc080e7          	jalr	-820(ra) # 806 <printf>
 b42:	b791                	j	a86 <uniq_run+0x5a>
                  printf("%s",line1);
 b44:	85ca                	mv	a1,s2
 b46:	00000517          	auipc	a0,0x0
 b4a:	44a50513          	addi	a0,a0,1098 # f90 <digits+0x40>
 b4e:	00000097          	auipc	ra,0x0
 b52:	cb8080e7          	jalr	-840(ra) # 806 <printf>
 b56:	bf05                	j	a86 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 b58:	00000517          	auipc	a0,0x0
 b5c:	47050513          	addi	a0,a0,1136 # fc8 <digits+0x78>
 b60:	00000097          	auipc	ra,0x0
 b64:	ca6080e7          	jalr	-858(ra) # 806 <printf>
          break;
 b68:	bf39                	j	a86 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 b6a:	85a6                	mv	a1,s1
 b6c:	854a                	mv	a0,s2
 b6e:	00000097          	auipc	ra,0x0
 b72:	110080e7          	jalr	272(ra) # c7e <compare_str_ic>
 b76:	a041                	j	bf6 <uniq_run+0x1ca>
                  printf("%s",line1);
 b78:	85ca                	mv	a1,s2
 b7a:	856e                	mv	a0,s11
 b7c:	00000097          	auipc	ra,0x0
 b80:	c8a080e7          	jalr	-886(ra) # 806 <printf>
        lineCount = 1;
 b84:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 b86:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b88:	8926                	mv	s2,s1
                  printf("%s",line1);
 b8a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b8c:	4b81                	li	s7,0
 b8e:	a099                	j	bd4 <uniq_run+0x1a8>
            if (showCount)
 b90:	020c0263          	beqz	s8,bb4 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 b94:	864a                	mv	a2,s2
 b96:	85da                	mv	a1,s6
 b98:	00000517          	auipc	a0,0x0
 b9c:	42850513          	addi	a0,a0,1064 # fc0 <digits+0x70>
 ba0:	00000097          	auipc	ra,0x0
 ba4:	c66080e7          	jalr	-922(ra) # 806 <printf>
 ba8:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 baa:	8926                	mv	s2,s1
 bac:	84be                	mv	s1,a5
        isRepeated = 0 ;
 bae:	4b81                	li	s7,0
        lineCount = 1;
 bb0:	8b6a                	mv	s6,s10
 bb2:	a00d                	j	bd4 <uniq_run+0x1a8>
              printf("%s",line1);
 bb4:	85ca                	mv	a1,s2
 bb6:	856e                	mv	a0,s11
 bb8:	00000097          	auipc	ra,0x0
 bbc:	c4e080e7          	jalr	-946(ra) # 806 <printf>
 bc0:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 bc2:	8926                	mv	s2,s1
              printf("%s",line1);
 bc4:	84be                	mv	s1,a5
        isRepeated = 0 ;
 bc6:	4b81                	li	s7,0
        lineCount = 1;
 bc8:	8b6a                	mv	s6,s10
 bca:	a029                	j	bd4 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 bcc:	000a0363          	beqz	s4,bd2 <uniq_run+0x1a6>
 bd0:	8bea                	mv	s7,s10
          lineCount++;
 bd2:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 bd4:	85a6                	mv	a1,s1
 bd6:	854e                	mv	a0,s3
 bd8:	00000097          	auipc	ra,0x0
 bdc:	196080e7          	jalr	406(ra) # d6e <read_line>
        if (readStatus == READ_EOF){
 be0:	d911                	beqz	a0,af4 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 be2:	f7950be3          	beq	a0,s9,b58 <uniq_run+0x12c>
        if (!ignoreCase)
 be6:	f80a92e3          	bnez	s5,b6a <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 bea:	85a6                	mv	a1,s1
 bec:	854a                	mv	a0,s2
 bee:	00000097          	auipc	ra,0x0
 bf2:	062080e7          	jalr	98(ra) # c50 <compare_str>
        if (compareStatus != 0){ 
 bf6:	d979                	beqz	a0,bcc <uniq_run+0x1a0>
          if (repeatedLines){
 bf8:	f80a0ce3          	beqz	s4,b90 <uniq_run+0x164>
            if (isRepeated){
 bfc:	ec0b8be3          	beqz	s7,ad2 <uniq_run+0xa6>
                if (showCount)
 c00:	f60c0ce3          	beqz	s8,b78 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 c04:	864a                	mv	a2,s2
 c06:	85da                	mv	a1,s6
 c08:	00000517          	auipc	a0,0x0
 c0c:	3b850513          	addi	a0,a0,952 # fc0 <digits+0x70>
 c10:	00000097          	auipc	ra,0x0
 c14:	bf6080e7          	jalr	-1034(ra) # 806 <printf>
        lineCount = 1;
 c18:	8b5e                	mv	s6,s7
 c1a:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 c1c:	8926                	mv	s2,s1
 c1e:	84be                	mv	s1,a5
        isRepeated = 0 ;
 c20:	4b81                	li	s7,0
 c22:	bf4d                	j	bd4 <uniq_run+0x1a8>

0000000000000c24 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 c24:	1141                	addi	sp,sp,-16
 c26:	e422                	sd	s0,8(sp)
 c28:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 c2a:	00054783          	lbu	a5,0(a0)
 c2e:	cf99                	beqz	a5,c4c <get_strlen+0x28>
 c30:	00150713          	addi	a4,a0,1
 c34:	87ba                	mv	a5,a4
 c36:	4685                	li	a3,1
 c38:	9e99                	subw	a3,a3,a4
 c3a:	00f6853b          	addw	a0,a3,a5
 c3e:	0785                	addi	a5,a5,1
 c40:	fff7c703          	lbu	a4,-1(a5)
 c44:	fb7d                	bnez	a4,c3a <get_strlen+0x16>
	return len;
}
 c46:	6422                	ld	s0,8(sp)
 c48:	0141                	addi	sp,sp,16
 c4a:	8082                	ret
	int len = 0;
 c4c:	4501                	li	a0,0
 c4e:	bfe5                	j	c46 <get_strlen+0x22>

0000000000000c50 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 c50:	1141                	addi	sp,sp,-16
 c52:	e422                	sd	s0,8(sp)
 c54:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 c56:	00054783          	lbu	a5,0(a0)
 c5a:	cb91                	beqz	a5,c6e <compare_str+0x1e>
 c5c:	0005c703          	lbu	a4,0(a1)
 c60:	c719                	beqz	a4,c6e <compare_str+0x1e>
		if (*s1++ != *s2++)
 c62:	0505                	addi	a0,a0,1
 c64:	0585                	addi	a1,a1,1
 c66:	fee788e3          	beq	a5,a4,c56 <compare_str+0x6>
			return 1;
 c6a:	4505                	li	a0,1
 c6c:	a031                	j	c78 <compare_str+0x28>
	}
	if (*s1 == *s2)
 c6e:	0005c503          	lbu	a0,0(a1)
 c72:	8d1d                	sub	a0,a0,a5
			return 1;
 c74:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 c78:	6422                	ld	s0,8(sp)
 c7a:	0141                	addi	sp,sp,16
 c7c:	8082                	ret

0000000000000c7e <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 c7e:	1141                	addi	sp,sp,-16
 c80:	e422                	sd	s0,8(sp)
 c82:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 c84:	4665                	li	a2,25
	while(*s1 && *s2){
 c86:	a019                	j	c8c <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 c88:	04e79763          	bne	a5,a4,cd6 <compare_str_ic+0x58>
	while(*s1 && *s2){
 c8c:	00054783          	lbu	a5,0(a0)
 c90:	cb9d                	beqz	a5,cc6 <compare_str_ic+0x48>
 c92:	0005c703          	lbu	a4,0(a1)
 c96:	cb05                	beqz	a4,cc6 <compare_str_ic+0x48>
		char b1 = *s1++;
 c98:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 c9a:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 c9c:	fbf7869b          	addiw	a3,a5,-65
 ca0:	0ff6f693          	zext.b	a3,a3
 ca4:	00d66663          	bltu	a2,a3,cb0 <compare_str_ic+0x32>
			b1 += 32;
 ca8:	0207879b          	addiw	a5,a5,32
 cac:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 cb0:	fbf7069b          	addiw	a3,a4,-65
 cb4:	0ff6f693          	zext.b	a3,a3
 cb8:	fcd668e3          	bltu	a2,a3,c88 <compare_str_ic+0xa>
			b2 += 32;
 cbc:	0207071b          	addiw	a4,a4,32
 cc0:	0ff77713          	zext.b	a4,a4
 cc4:	b7d1                	j	c88 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 cc6:	0005c503          	lbu	a0,0(a1)
 cca:	8d1d                	sub	a0,a0,a5
			return 1;
 ccc:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 cd0:	6422                	ld	s0,8(sp)
 cd2:	0141                	addi	sp,sp,16
 cd4:	8082                	ret
			return 1;
 cd6:	4505                	li	a0,1
 cd8:	bfe5                	j	cd0 <compare_str_ic+0x52>

0000000000000cda <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 cda:	7179                	addi	sp,sp,-48
 cdc:	f406                	sd	ra,40(sp)
 cde:	f022                	sd	s0,32(sp)
 ce0:	ec26                	sd	s1,24(sp)
 ce2:	e84a                	sd	s2,16(sp)
 ce4:	e44e                	sd	s3,8(sp)
 ce6:	1800                	addi	s0,sp,48
 ce8:	89aa                	mv	s3,a0
 cea:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 cec:	00000097          	auipc	ra,0x0
 cf0:	f38080e7          	jalr	-200(ra) # c24 <get_strlen>
 cf4:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 cf6:	854a                	mv	a0,s2
 cf8:	00000097          	auipc	ra,0x0
 cfc:	f2c080e7          	jalr	-212(ra) # c24 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 d00:	409505bb          	subw	a1,a0,s1
 d04:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 d06:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 d08:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 d0a:	0005da63          	bgez	a1,d1e <check_substr+0x44>
 d0e:	a81d                	j	d44 <check_substr+0x6a>
        if (j == M)
 d10:	02f48a63          	beq	s1,a5,d44 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 d14:	0885                	addi	a7,a7,1
 d16:	0008879b          	sext.w	a5,a7
 d1a:	02f5cc63          	blt	a1,a5,d52 <check_substr+0x78>
 d1e:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 d22:	011906b3          	add	a3,s2,a7
 d26:	874e                	mv	a4,s3
 d28:	879a                	mv	a5,t1
 d2a:	fe9053e3          	blez	s1,d10 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 d2e:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 d32:	00074603          	lbu	a2,0(a4)
 d36:	fcc81de3          	bne	a6,a2,d10 <check_substr+0x36>
        for (j = 0; j < M; j++)
 d3a:	2785                	addiw	a5,a5,1
 d3c:	0685                	addi	a3,a3,1
 d3e:	0705                	addi	a4,a4,1
 d40:	fef497e3          	bne	s1,a5,d2e <check_substr+0x54>
}
 d44:	70a2                	ld	ra,40(sp)
 d46:	7402                	ld	s0,32(sp)
 d48:	64e2                	ld	s1,24(sp)
 d4a:	6942                	ld	s2,16(sp)
 d4c:	69a2                	ld	s3,8(sp)
 d4e:	6145                	addi	sp,sp,48
 d50:	8082                	ret
    return -1;
 d52:	557d                	li	a0,-1
 d54:	bfc5                	j	d44 <check_substr+0x6a>

0000000000000d56 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 d56:	1141                	addi	sp,sp,-16
 d58:	e406                	sd	ra,8(sp)
 d5a:	e022                	sd	s0,0(sp)
 d5c:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 d5e:	fffff097          	auipc	ra,0xfffff
 d62:	72e080e7          	jalr	1838(ra) # 48c <open>
	return fd;
}
 d66:	60a2                	ld	ra,8(sp)
 d68:	6402                	ld	s0,0(sp)
 d6a:	0141                	addi	sp,sp,16
 d6c:	8082                	ret

0000000000000d6e <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 d6e:	7139                	addi	sp,sp,-64
 d70:	fc06                	sd	ra,56(sp)
 d72:	f822                	sd	s0,48(sp)
 d74:	f426                	sd	s1,40(sp)
 d76:	f04a                	sd	s2,32(sp)
 d78:	ec4e                	sd	s3,24(sp)
 d7a:	e852                	sd	s4,16(sp)
 d7c:	0080                	addi	s0,sp,64
 d7e:	89aa                	mv	s3,a0
 d80:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 d82:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 d84:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 d86:	4605                	li	a2,1
 d88:	fcf40593          	addi	a1,s0,-49
 d8c:	854e                	mv	a0,s3
 d8e:	fffff097          	auipc	ra,0xfffff
 d92:	6d6080e7          	jalr	1750(ra) # 464 <read>
		if (readStatus == 0){
 d96:	c505                	beqz	a0,dbe <read_line+0x50>
		*buffer++ = readByte;
 d98:	0485                	addi	s1,s1,1
 d9a:	fcf44783          	lbu	a5,-49(s0)
 d9e:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 da2:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 da4:	ff4791e3          	bne	a5,s4,d86 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 da8:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 dac:	854a                	mv	a0,s2
 dae:	70e2                	ld	ra,56(sp)
 db0:	7442                	ld	s0,48(sp)
 db2:	74a2                	ld	s1,40(sp)
 db4:	7902                	ld	s2,32(sp)
 db6:	69e2                	ld	s3,24(sp)
 db8:	6a42                	ld	s4,16(sp)
 dba:	6121                	addi	sp,sp,64
 dbc:	8082                	ret
			if (byteCount!=0){
 dbe:	fe0907e3          	beqz	s2,dac <read_line+0x3e>
				*buffer = '\n';
 dc2:	47a9                	li	a5,10
 dc4:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 dc8:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 dcc:	2905                	addiw	s2,s2,1
 dce:	bff9                	j	dac <read_line+0x3e>

0000000000000dd0 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 dd0:	1141                	addi	sp,sp,-16
 dd2:	e406                	sd	ra,8(sp)
 dd4:	e022                	sd	s0,0(sp)
 dd6:	0800                	addi	s0,sp,16
	close(fd);
 dd8:	fffff097          	auipc	ra,0xfffff
 ddc:	69c080e7          	jalr	1692(ra) # 474 <close>
}
 de0:	60a2                	ld	ra,8(sp)
 de2:	6402                	ld	s0,0(sp)
 de4:	0141                	addi	sp,sp,16
 de6:	8082                	ret

0000000000000de8 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 de8:	7139                	addi	sp,sp,-64
 dea:	fc06                	sd	ra,56(sp)
 dec:	f822                	sd	s0,48(sp)
 dee:	f426                	sd	s1,40(sp)
 df0:	f04a                	sd	s2,32(sp)
 df2:	0080                	addi	s0,sp,64
 df4:	84aa                	mv	s1,a0
 df6:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 df8:	fffff097          	auipc	ra,0xfffff
 dfc:	64c080e7          	jalr	1612(ra) # 444 <fork>
 e00:	ed19                	bnez	a0,e1e <get_time_perf+0x36>
		exec(argv[0],argv);
 e02:	85ca                	mv	a1,s2
 e04:	00093503          	ld	a0,0(s2)
 e08:	fffff097          	auipc	ra,0xfffff
 e0c:	67c080e7          	jalr	1660(ra) # 484 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 e10:	8526                	mv	a0,s1
 e12:	70e2                	ld	ra,56(sp)
 e14:	7442                	ld	s0,48(sp)
 e16:	74a2                	ld	s1,40(sp)
 e18:	7902                	ld	s2,32(sp)
 e1a:	6121                	addi	sp,sp,64
 e1c:	8082                	ret
		times(pid , &time);
 e1e:	fc040593          	addi	a1,s0,-64
 e22:	fffff097          	auipc	ra,0xfffff
 e26:	6e2080e7          	jalr	1762(ra) # 504 <times>
		return time;
 e2a:	fc043783          	ld	a5,-64(s0)
 e2e:	e09c                	sd	a5,0(s1)
 e30:	fc843783          	ld	a5,-56(s0)
 e34:	e49c                	sd	a5,8(s1)
 e36:	fd043783          	ld	a5,-48(s0)
 e3a:	e89c                	sd	a5,16(s1)
 e3c:	fd843783          	ld	a5,-40(s0)
 e40:	ec9c                	sd	a5,24(s1)
 e42:	b7f9                	j	e10 <get_time_perf+0x28>
