
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
  20:	ce450513          	addi	a0,a0,-796 # d00 <close_file+0x1e>
  24:	00000097          	auipc	ra,0x0
  28:	770080e7          	jalr	1904(ra) # 794 <printf>

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
  4a:	d12b8b93          	addi	s7,s7,-750 # d58 <close_file+0x76>
				printf("[ERR] opening the file '%s' failed \n",*passedFiles);
  4e:	00001c17          	auipc	s8,0x1
  52:	ce2c0c13          	addi	s8,s8,-798 # d30 <close_file+0x4e>
  56:	a805                	j	86 <head_usermode+0x86>
  58:	00093583          	ld	a1,0(s2)
  5c:	8562                	mv	a0,s8
  5e:	00000097          	auipc	ra,0x0
  62:	736080e7          	jalr	1846(ra) # 794 <printf>
  66:	a039                	j	74 <head_usermode+0x74>
				
				head_run(fd , lineCount);
  68:	85d2                	mv	a1,s4
  6a:	8526                	mv	a0,s1
  6c:	00001097          	auipc	ra,0x1
  70:	8c6080e7          	jalr	-1850(ra) # 932 <head_run>
			}
			close_file(fd);
  74:	8526                	mv	a0,s1
  76:	00001097          	auipc	ra,0x1
  7a:	c6c080e7          	jalr	-916(ra) # ce2 <close_file>
			passedFiles++;
  7e:	0921                	addi	s2,s2,8
		while (*passedFiles){
  80:	00093503          	ld	a0,0(s2)
  84:	c90d                	beqz	a0,b6 <head_usermode+0xb6>
			int fd = open_file(*passedFiles, RDONLY);
  86:	4581                	li	a1,0
  88:	00001097          	auipc	ra,0x1
  8c:	be0080e7          	jalr	-1056(ra) # c68 <open_file>
  90:	84aa                	mv	s1,a0
			if (fd == OPEN_FILE_ERROR)
  92:	fd5503e3          	beq	a0,s5,58 <head_usermode+0x58>
				if (numOfFiles > 1) 
  96:	fd3b59e3          	bge	s6,s3,68 <head_usermode+0x68>
					printf("==> %s <==\n",*passedFiles);
  9a:	00093583          	ld	a1,0(s2)
  9e:	855e                	mv	a0,s7
  a0:	00000097          	auipc	ra,0x0
  a4:	6f4080e7          	jalr	1780(ra) # 794 <printf>
  a8:	b7c1                	j	68 <head_usermode+0x68>
		head_run(STDIN, lineCount);
  aa:	85d2                	mv	a1,s4
  ac:	4501                	li	a0,0
  ae:	00001097          	auipc	ra,0x1
  b2:	884080e7          	jalr	-1916(ra) # 932 <head_run>
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
  ce:	7139                	addi	sp,sp,-64
  d0:	fc06                	sd	ra,56(sp)
  d2:	f822                	sd	s0,48(sp)
  d4:	f426                	sd	s1,40(sp)
  d6:	f04a                	sd	s2,32(sp)
  d8:	ec4e                	sd	s3,24(sp)
  da:	e852                	sd	s4,16(sp)
  dc:	e456                	sd	s5,8(sp)
  de:	e05a                	sd	s6,0(sp)
  e0:	0080                	addi	s0,sp,64
  e2:	892e                	mv	s2,a1

	/* Default value for lineCount */
	*lineCount = NUM_OF_LINES;

	/* Total number of files is maximum argc-1 requiring argc size storage for the last NULL*/
	char ** passedFiles = malloc(sizeof(char *) * (argc));
  e4:	0035151b          	slliw	a0,a0,0x3
  e8:	00000097          	auipc	ra,0x0
  ec:	764080e7          	jalr	1892(ra) # 84c <malloc>

	if (!passedFiles){
  f0:	c141                	beqz	a0,170 <main+0xa2>
  f2:	8a2a                	mv	s4,a0
		return NULL;
	}


	int fileIdx = 0;
	cmd++;  // Skipping the program's name
  f4:	00890493          	addi	s1,s2,8
	
	while(*cmd){
  f8:	00893503          	ld	a0,8(s2)
  fc:	c139                	beqz	a0,142 <main+0x74>
	*lineCount = NUM_OF_LINES;
  fe:	4ab9                	li	s5,14
	int fileIdx = 0;
 100:	4981                	li	s3,0
		if (!compare_str(cmd[0], "-n")){
 102:	00001b17          	auipc	s6,0x1
 106:	c66b0b13          	addi	s6,s6,-922 # d68 <close_file+0x86>
 10a:	a829                	j	124 <main+0x56>
			cmd++;
			*lineCount = atoi(cmd[0]);
		}
		else
			passedFiles[fileIdx++] = cmd[0];
 10c:	6098                	ld	a4,0(s1)
 10e:	00399793          	slli	a5,s3,0x3
 112:	97d2                	add	a5,a5,s4
 114:	e398                	sd	a4,0(a5)
 116:	2985                	addiw	s3,s3,1
 118:	8926                	mv	s2,s1
			
		cmd++;
 11a:	00890493          	addi	s1,s2,8
	while(*cmd){
 11e:	00893503          	ld	a0,8(s2)
 122:	c115                	beqz	a0,146 <main+0x78>
		if (!compare_str(cmd[0], "-n")){
 124:	85da                	mv	a1,s6
 126:	00001097          	auipc	ra,0x1
 12a:	ab8080e7          	jalr	-1352(ra) # bde <compare_str>
 12e:	fd79                	bnez	a0,10c <main+0x3e>
			cmd++;
 130:	00848913          	addi	s2,s1,8
			*lineCount = atoi(cmd[0]);
 134:	6488                	ld	a0,8(s1)
 136:	00000097          	auipc	ra,0x0
 13a:	1da080e7          	jalr	474(ra) # 310 <atoi>
 13e:	8aaa                	mv	s5,a0
 140:	bfe9                	j	11a <main+0x4c>
	*lineCount = NUM_OF_LINES;
 142:	4ab9                	li	s5,14
	int fileIdx = 0;
 144:	4981                	li	s3,0
	}

	passedFiles[fileIdx]=NULL;
 146:	098e                	slli	s3,s3,0x3
 148:	99d2                	add	s3,s3,s4
 14a:	0009b023          	sd	zero,0(s3)
	head_usermode(passedFiles, lineCount);
 14e:	85d6                	mv	a1,s5
 150:	8552                	mv	a0,s4
 152:	00000097          	auipc	ra,0x0
 156:	eae080e7          	jalr	-338(ra) # 0 <head_usermode>
	return 0;
 15a:	4501                	li	a0,0
}
 15c:	70e2                	ld	ra,56(sp)
 15e:	7442                	ld	s0,48(sp)
 160:	74a2                	ld	s1,40(sp)
 162:	7902                	ld	s2,32(sp)
 164:	69e2                	ld	s3,24(sp)
 166:	6a42                	ld	s4,16(sp)
 168:	6aa2                	ld	s5,8(sp)
 16a:	6b02                	ld	s6,0(sp)
 16c:	6121                	addi	sp,sp,64
 16e:	8082                	ret
		printf("[ERR] Cannot parse the issued command\n");
 170:	00001517          	auipc	a0,0x1
 174:	c0050513          	addi	a0,a0,-1024 # d70 <close_file+0x8e>
 178:	00000097          	auipc	ra,0x0
 17c:	61c080e7          	jalr	1564(ra) # 794 <printf>
		return 1;
 180:	4505                	li	a0,1
 182:	bfe9                	j	15c <main+0x8e>

0000000000000184 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 184:	1141                	addi	sp,sp,-16
 186:	e406                	sd	ra,8(sp)
 188:	e022                	sd	s0,0(sp)
 18a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 18c:	00000097          	auipc	ra,0x0
 190:	f42080e7          	jalr	-190(ra) # ce <main>
  exit(0);
 194:	4501                	li	a0,0
 196:	00000097          	auipc	ra,0x0
 19a:	274080e7          	jalr	628(ra) # 40a <exit>

000000000000019e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e422                	sd	s0,8(sp)
 1a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a4:	87aa                	mv	a5,a0
 1a6:	0585                	addi	a1,a1,1
 1a8:	0785                	addi	a5,a5,1
 1aa:	fff5c703          	lbu	a4,-1(a1)
 1ae:	fee78fa3          	sb	a4,-1(a5)
 1b2:	fb75                	bnez	a4,1a6 <strcpy+0x8>
    ;
  return os;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cb91                	beqz	a5,1d8 <strcmp+0x1e>
 1c6:	0005c703          	lbu	a4,0(a1)
 1ca:	00f71763          	bne	a4,a5,1d8 <strcmp+0x1e>
    p++, q++;
 1ce:	0505                	addi	a0,a0,1
 1d0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	fbe5                	bnez	a5,1c6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d8:	0005c503          	lbu	a0,0(a1)
}
 1dc:	40a7853b          	subw	a0,a5,a0
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret

00000000000001e6 <strlen>:

uint
strlen(const char *s)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ec:	00054783          	lbu	a5,0(a0)
 1f0:	cf91                	beqz	a5,20c <strlen+0x26>
 1f2:	0505                	addi	a0,a0,1
 1f4:	87aa                	mv	a5,a0
 1f6:	4685                	li	a3,1
 1f8:	9e89                	subw	a3,a3,a0
 1fa:	00f6853b          	addw	a0,a3,a5
 1fe:	0785                	addi	a5,a5,1
 200:	fff7c703          	lbu	a4,-1(a5)
 204:	fb7d                	bnez	a4,1fa <strlen+0x14>
    ;
  return n;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret
  for(n = 0; s[n]; n++)
 20c:	4501                	li	a0,0
 20e:	bfe5                	j	206 <strlen+0x20>

0000000000000210 <memset>:

void*
memset(void *dst, int c, uint n)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 216:	ca19                	beqz	a2,22c <memset+0x1c>
 218:	87aa                	mv	a5,a0
 21a:	1602                	slli	a2,a2,0x20
 21c:	9201                	srli	a2,a2,0x20
 21e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 222:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 226:	0785                	addi	a5,a5,1
 228:	fee79de3          	bne	a5,a4,222 <memset+0x12>
  }
  return dst;
}
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret

0000000000000232 <strchr>:

char*
strchr(const char *s, char c)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  for(; *s; s++)
 238:	00054783          	lbu	a5,0(a0)
 23c:	cb99                	beqz	a5,252 <strchr+0x20>
    if(*s == c)
 23e:	00f58763          	beq	a1,a5,24c <strchr+0x1a>
  for(; *s; s++)
 242:	0505                	addi	a0,a0,1
 244:	00054783          	lbu	a5,0(a0)
 248:	fbfd                	bnez	a5,23e <strchr+0xc>
      return (char*)s;
  return 0;
 24a:	4501                	li	a0,0
}
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret
  return 0;
 252:	4501                	li	a0,0
 254:	bfe5                	j	24c <strchr+0x1a>

0000000000000256 <gets>:

char*
gets(char *buf, int max)
{
 256:	711d                	addi	sp,sp,-96
 258:	ec86                	sd	ra,88(sp)
 25a:	e8a2                	sd	s0,80(sp)
 25c:	e4a6                	sd	s1,72(sp)
 25e:	e0ca                	sd	s2,64(sp)
 260:	fc4e                	sd	s3,56(sp)
 262:	f852                	sd	s4,48(sp)
 264:	f456                	sd	s5,40(sp)
 266:	f05a                	sd	s6,32(sp)
 268:	ec5e                	sd	s7,24(sp)
 26a:	1080                	addi	s0,sp,96
 26c:	8baa                	mv	s7,a0
 26e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 270:	892a                	mv	s2,a0
 272:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 274:	4aa9                	li	s5,10
 276:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 278:	89a6                	mv	s3,s1
 27a:	2485                	addiw	s1,s1,1
 27c:	0344d863          	bge	s1,s4,2ac <gets+0x56>
    cc = read(0, &c, 1);
 280:	4605                	li	a2,1
 282:	faf40593          	addi	a1,s0,-81
 286:	4501                	li	a0,0
 288:	00000097          	auipc	ra,0x0
 28c:	19a080e7          	jalr	410(ra) # 422 <read>
    if(cc < 1)
 290:	00a05e63          	blez	a0,2ac <gets+0x56>
    buf[i++] = c;
 294:	faf44783          	lbu	a5,-81(s0)
 298:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 29c:	01578763          	beq	a5,s5,2aa <gets+0x54>
 2a0:	0905                	addi	s2,s2,1
 2a2:	fd679be3          	bne	a5,s6,278 <gets+0x22>
  for(i=0; i+1 < max; ){
 2a6:	89a6                	mv	s3,s1
 2a8:	a011                	j	2ac <gets+0x56>
 2aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ac:	99de                	add	s3,s3,s7
 2ae:	00098023          	sb	zero,0(s3)
  return buf;
}
 2b2:	855e                	mv	a0,s7
 2b4:	60e6                	ld	ra,88(sp)
 2b6:	6446                	ld	s0,80(sp)
 2b8:	64a6                	ld	s1,72(sp)
 2ba:	6906                	ld	s2,64(sp)
 2bc:	79e2                	ld	s3,56(sp)
 2be:	7a42                	ld	s4,48(sp)
 2c0:	7aa2                	ld	s5,40(sp)
 2c2:	7b02                	ld	s6,32(sp)
 2c4:	6be2                	ld	s7,24(sp)
 2c6:	6125                	addi	sp,sp,96
 2c8:	8082                	ret

00000000000002ca <stat>:

int
stat(const char *n, struct stat *st)
{
 2ca:	1101                	addi	sp,sp,-32
 2cc:	ec06                	sd	ra,24(sp)
 2ce:	e822                	sd	s0,16(sp)
 2d0:	e426                	sd	s1,8(sp)
 2d2:	e04a                	sd	s2,0(sp)
 2d4:	1000                	addi	s0,sp,32
 2d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d8:	4581                	li	a1,0
 2da:	00000097          	auipc	ra,0x0
 2de:	170080e7          	jalr	368(ra) # 44a <open>
  if(fd < 0)
 2e2:	02054563          	bltz	a0,30c <stat+0x42>
 2e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e8:	85ca                	mv	a1,s2
 2ea:	00000097          	auipc	ra,0x0
 2ee:	178080e7          	jalr	376(ra) # 462 <fstat>
 2f2:	892a                	mv	s2,a0
  close(fd);
 2f4:	8526                	mv	a0,s1
 2f6:	00000097          	auipc	ra,0x0
 2fa:	13c080e7          	jalr	316(ra) # 432 <close>
  return r;
}
 2fe:	854a                	mv	a0,s2
 300:	60e2                	ld	ra,24(sp)
 302:	6442                	ld	s0,16(sp)
 304:	64a2                	ld	s1,8(sp)
 306:	6902                	ld	s2,0(sp)
 308:	6105                	addi	sp,sp,32
 30a:	8082                	ret
    return -1;
 30c:	597d                	li	s2,-1
 30e:	bfc5                	j	2fe <stat+0x34>

0000000000000310 <atoi>:

int
atoi(const char *s)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 316:	00054683          	lbu	a3,0(a0)
 31a:	fd06879b          	addiw	a5,a3,-48
 31e:	0ff7f793          	zext.b	a5,a5
 322:	4625                	li	a2,9
 324:	02f66863          	bltu	a2,a5,354 <atoi+0x44>
 328:	872a                	mv	a4,a0
  n = 0;
 32a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 32c:	0705                	addi	a4,a4,1
 32e:	0025179b          	slliw	a5,a0,0x2
 332:	9fa9                	addw	a5,a5,a0
 334:	0017979b          	slliw	a5,a5,0x1
 338:	9fb5                	addw	a5,a5,a3
 33a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 33e:	00074683          	lbu	a3,0(a4)
 342:	fd06879b          	addiw	a5,a3,-48
 346:	0ff7f793          	zext.b	a5,a5
 34a:	fef671e3          	bgeu	a2,a5,32c <atoi+0x1c>
  return n;
}
 34e:	6422                	ld	s0,8(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret
  n = 0;
 354:	4501                	li	a0,0
 356:	bfe5                	j	34e <atoi+0x3e>

0000000000000358 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 35e:	02b57463          	bgeu	a0,a1,386 <memmove+0x2e>
    while(n-- > 0)
 362:	00c05f63          	blez	a2,380 <memmove+0x28>
 366:	1602                	slli	a2,a2,0x20
 368:	9201                	srli	a2,a2,0x20
 36a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 36e:	872a                	mv	a4,a0
      *dst++ = *src++;
 370:	0585                	addi	a1,a1,1
 372:	0705                	addi	a4,a4,1
 374:	fff5c683          	lbu	a3,-1(a1)
 378:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 37c:	fee79ae3          	bne	a5,a4,370 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 380:	6422                	ld	s0,8(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret
    dst += n;
 386:	00c50733          	add	a4,a0,a2
    src += n;
 38a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 38c:	fec05ae3          	blez	a2,380 <memmove+0x28>
 390:	fff6079b          	addiw	a5,a2,-1
 394:	1782                	slli	a5,a5,0x20
 396:	9381                	srli	a5,a5,0x20
 398:	fff7c793          	not	a5,a5
 39c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 39e:	15fd                	addi	a1,a1,-1
 3a0:	177d                	addi	a4,a4,-1
 3a2:	0005c683          	lbu	a3,0(a1)
 3a6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3aa:	fee79ae3          	bne	a5,a4,39e <memmove+0x46>
 3ae:	bfc9                	j	380 <memmove+0x28>

00000000000003b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b0:	1141                	addi	sp,sp,-16
 3b2:	e422                	sd	s0,8(sp)
 3b4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3b6:	ca05                	beqz	a2,3e6 <memcmp+0x36>
 3b8:	fff6069b          	addiw	a3,a2,-1
 3bc:	1682                	slli	a3,a3,0x20
 3be:	9281                	srli	a3,a3,0x20
 3c0:	0685                	addi	a3,a3,1
 3c2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3c4:	00054783          	lbu	a5,0(a0)
 3c8:	0005c703          	lbu	a4,0(a1)
 3cc:	00e79863          	bne	a5,a4,3dc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3d0:	0505                	addi	a0,a0,1
    p2++;
 3d2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3d4:	fed518e3          	bne	a0,a3,3c4 <memcmp+0x14>
  }
  return 0;
 3d8:	4501                	li	a0,0
 3da:	a019                	j	3e0 <memcmp+0x30>
      return *p1 - *p2;
 3dc:	40e7853b          	subw	a0,a5,a4
}
 3e0:	6422                	ld	s0,8(sp)
 3e2:	0141                	addi	sp,sp,16
 3e4:	8082                	ret
  return 0;
 3e6:	4501                	li	a0,0
 3e8:	bfe5                	j	3e0 <memcmp+0x30>

00000000000003ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ea:	1141                	addi	sp,sp,-16
 3ec:	e406                	sd	ra,8(sp)
 3ee:	e022                	sd	s0,0(sp)
 3f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3f2:	00000097          	auipc	ra,0x0
 3f6:	f66080e7          	jalr	-154(ra) # 358 <memmove>
}
 3fa:	60a2                	ld	ra,8(sp)
 3fc:	6402                	ld	s0,0(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret

0000000000000402 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 402:	4885                	li	a7,1
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <exit>:
.global exit
exit:
 li a7, SYS_exit
 40a:	4889                	li	a7,2
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <wait>:
.global wait
wait:
 li a7, SYS_wait
 412:	488d                	li	a7,3
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 41a:	4891                	li	a7,4
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <read>:
.global read
read:
 li a7, SYS_read
 422:	4895                	li	a7,5
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <write>:
.global write
write:
 li a7, SYS_write
 42a:	48c1                	li	a7,16
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <close>:
.global close
close:
 li a7, SYS_close
 432:	48d5                	li	a7,21
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <kill>:
.global kill
kill:
 li a7, SYS_kill
 43a:	4899                	li	a7,6
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <exec>:
.global exec
exec:
 li a7, SYS_exec
 442:	489d                	li	a7,7
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <open>:
.global open
open:
 li a7, SYS_open
 44a:	48bd                	li	a7,15
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 452:	48c5                	li	a7,17
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 45a:	48c9                	li	a7,18
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 462:	48a1                	li	a7,8
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <link>:
.global link
link:
 li a7, SYS_link
 46a:	48cd                	li	a7,19
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 472:	48d1                	li	a7,20
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 47a:	48a5                	li	a7,9
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <dup>:
.global dup
dup:
 li a7, SYS_dup
 482:	48a9                	li	a7,10
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 48a:	48ad                	li	a7,11
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 492:	48b1                	li	a7,12
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 49a:	48b5                	li	a7,13
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4a2:	48b9                	li	a7,14
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <head>:
.global head
head:
 li a7, SYS_head
 4aa:	48d9                	li	a7,22
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 4b2:	48dd                	li	a7,23
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ba:	1101                	addi	sp,sp,-32
 4bc:	ec06                	sd	ra,24(sp)
 4be:	e822                	sd	s0,16(sp)
 4c0:	1000                	addi	s0,sp,32
 4c2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c6:	4605                	li	a2,1
 4c8:	fef40593          	addi	a1,s0,-17
 4cc:	00000097          	auipc	ra,0x0
 4d0:	f5e080e7          	jalr	-162(ra) # 42a <write>
}
 4d4:	60e2                	ld	ra,24(sp)
 4d6:	6442                	ld	s0,16(sp)
 4d8:	6105                	addi	sp,sp,32
 4da:	8082                	ret

00000000000004dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4dc:	7139                	addi	sp,sp,-64
 4de:	fc06                	sd	ra,56(sp)
 4e0:	f822                	sd	s0,48(sp)
 4e2:	f426                	sd	s1,40(sp)
 4e4:	f04a                	sd	s2,32(sp)
 4e6:	ec4e                	sd	s3,24(sp)
 4e8:	0080                	addi	s0,sp,64
 4ea:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ec:	c299                	beqz	a3,4f2 <printint+0x16>
 4ee:	0805c963          	bltz	a1,580 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4f2:	2581                	sext.w	a1,a1
  neg = 0;
 4f4:	4881                	li	a7,0
 4f6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4fa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4fc:	2601                	sext.w	a2,a2
 4fe:	00001517          	auipc	a0,0x1
 502:	8fa50513          	addi	a0,a0,-1798 # df8 <digits>
 506:	883a                	mv	a6,a4
 508:	2705                	addiw	a4,a4,1
 50a:	02c5f7bb          	remuw	a5,a1,a2
 50e:	1782                	slli	a5,a5,0x20
 510:	9381                	srli	a5,a5,0x20
 512:	97aa                	add	a5,a5,a0
 514:	0007c783          	lbu	a5,0(a5)
 518:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 51c:	0005879b          	sext.w	a5,a1
 520:	02c5d5bb          	divuw	a1,a1,a2
 524:	0685                	addi	a3,a3,1
 526:	fec7f0e3          	bgeu	a5,a2,506 <printint+0x2a>
  if(neg)
 52a:	00088c63          	beqz	a7,542 <printint+0x66>
    buf[i++] = '-';
 52e:	fd070793          	addi	a5,a4,-48
 532:	00878733          	add	a4,a5,s0
 536:	02d00793          	li	a5,45
 53a:	fef70823          	sb	a5,-16(a4)
 53e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 542:	02e05863          	blez	a4,572 <printint+0x96>
 546:	fc040793          	addi	a5,s0,-64
 54a:	00e78933          	add	s2,a5,a4
 54e:	fff78993          	addi	s3,a5,-1
 552:	99ba                	add	s3,s3,a4
 554:	377d                	addiw	a4,a4,-1
 556:	1702                	slli	a4,a4,0x20
 558:	9301                	srli	a4,a4,0x20
 55a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 55e:	fff94583          	lbu	a1,-1(s2)
 562:	8526                	mv	a0,s1
 564:	00000097          	auipc	ra,0x0
 568:	f56080e7          	jalr	-170(ra) # 4ba <putc>
  while(--i >= 0)
 56c:	197d                	addi	s2,s2,-1
 56e:	ff3918e3          	bne	s2,s3,55e <printint+0x82>
}
 572:	70e2                	ld	ra,56(sp)
 574:	7442                	ld	s0,48(sp)
 576:	74a2                	ld	s1,40(sp)
 578:	7902                	ld	s2,32(sp)
 57a:	69e2                	ld	s3,24(sp)
 57c:	6121                	addi	sp,sp,64
 57e:	8082                	ret
    x = -xx;
 580:	40b005bb          	negw	a1,a1
    neg = 1;
 584:	4885                	li	a7,1
    x = -xx;
 586:	bf85                	j	4f6 <printint+0x1a>

0000000000000588 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 588:	7119                	addi	sp,sp,-128
 58a:	fc86                	sd	ra,120(sp)
 58c:	f8a2                	sd	s0,112(sp)
 58e:	f4a6                	sd	s1,104(sp)
 590:	f0ca                	sd	s2,96(sp)
 592:	ecce                	sd	s3,88(sp)
 594:	e8d2                	sd	s4,80(sp)
 596:	e4d6                	sd	s5,72(sp)
 598:	e0da                	sd	s6,64(sp)
 59a:	fc5e                	sd	s7,56(sp)
 59c:	f862                	sd	s8,48(sp)
 59e:	f466                	sd	s9,40(sp)
 5a0:	f06a                	sd	s10,32(sp)
 5a2:	ec6e                	sd	s11,24(sp)
 5a4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5a6:	0005c903          	lbu	s2,0(a1)
 5aa:	18090f63          	beqz	s2,748 <vprintf+0x1c0>
 5ae:	8aaa                	mv	s5,a0
 5b0:	8b32                	mv	s6,a2
 5b2:	00158493          	addi	s1,a1,1
  state = 0;
 5b6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5b8:	02500a13          	li	s4,37
 5bc:	4c55                	li	s8,21
 5be:	00000c97          	auipc	s9,0x0
 5c2:	7e2c8c93          	addi	s9,s9,2018 # da0 <close_file+0xbe>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5c6:	02800d93          	li	s11,40
  putc(fd, 'x');
 5ca:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5cc:	00001b97          	auipc	s7,0x1
 5d0:	82cb8b93          	addi	s7,s7,-2004 # df8 <digits>
 5d4:	a839                	j	5f2 <vprintf+0x6a>
        putc(fd, c);
 5d6:	85ca                	mv	a1,s2
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	ee0080e7          	jalr	-288(ra) # 4ba <putc>
 5e2:	a019                	j	5e8 <vprintf+0x60>
    } else if(state == '%'){
 5e4:	01498d63          	beq	s3,s4,5fe <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 5e8:	0485                	addi	s1,s1,1
 5ea:	fff4c903          	lbu	s2,-1(s1)
 5ee:	14090d63          	beqz	s2,748 <vprintf+0x1c0>
    if(state == 0){
 5f2:	fe0999e3          	bnez	s3,5e4 <vprintf+0x5c>
      if(c == '%'){
 5f6:	ff4910e3          	bne	s2,s4,5d6 <vprintf+0x4e>
        state = '%';
 5fa:	89d2                	mv	s3,s4
 5fc:	b7f5                	j	5e8 <vprintf+0x60>
      if(c == 'd'){
 5fe:	11490c63          	beq	s2,s4,716 <vprintf+0x18e>
 602:	f9d9079b          	addiw	a5,s2,-99
 606:	0ff7f793          	zext.b	a5,a5
 60a:	10fc6e63          	bltu	s8,a5,726 <vprintf+0x19e>
 60e:	f9d9079b          	addiw	a5,s2,-99
 612:	0ff7f713          	zext.b	a4,a5
 616:	10ec6863          	bltu	s8,a4,726 <vprintf+0x19e>
 61a:	00271793          	slli	a5,a4,0x2
 61e:	97e6                	add	a5,a5,s9
 620:	439c                	lw	a5,0(a5)
 622:	97e6                	add	a5,a5,s9
 624:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 626:	008b0913          	addi	s2,s6,8
 62a:	4685                	li	a3,1
 62c:	4629                	li	a2,10
 62e:	000b2583          	lw	a1,0(s6)
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	ea8080e7          	jalr	-344(ra) # 4dc <printint>
 63c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 63e:	4981                	li	s3,0
 640:	b765                	j	5e8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 642:	008b0913          	addi	s2,s6,8
 646:	4681                	li	a3,0
 648:	4629                	li	a2,10
 64a:	000b2583          	lw	a1,0(s6)
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	e8c080e7          	jalr	-372(ra) # 4dc <printint>
 658:	8b4a                	mv	s6,s2
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b771                	j	5e8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 65e:	008b0913          	addi	s2,s6,8
 662:	4681                	li	a3,0
 664:	866a                	mv	a2,s10
 666:	000b2583          	lw	a1,0(s6)
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	e70080e7          	jalr	-400(ra) # 4dc <printint>
 674:	8b4a                	mv	s6,s2
      state = 0;
 676:	4981                	li	s3,0
 678:	bf85                	j	5e8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 67a:	008b0793          	addi	a5,s6,8
 67e:	f8f43423          	sd	a5,-120(s0)
 682:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 686:	03000593          	li	a1,48
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	e2e080e7          	jalr	-466(ra) # 4ba <putc>
  putc(fd, 'x');
 694:	07800593          	li	a1,120
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	e20080e7          	jalr	-480(ra) # 4ba <putc>
 6a2:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a4:	03c9d793          	srli	a5,s3,0x3c
 6a8:	97de                	add	a5,a5,s7
 6aa:	0007c583          	lbu	a1,0(a5)
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	e0a080e7          	jalr	-502(ra) # 4ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b8:	0992                	slli	s3,s3,0x4
 6ba:	397d                	addiw	s2,s2,-1
 6bc:	fe0914e3          	bnez	s2,6a4 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 6c0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b70d                	j	5e8 <vprintf+0x60>
        s = va_arg(ap, char*);
 6c8:	008b0913          	addi	s2,s6,8
 6cc:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 6d0:	02098163          	beqz	s3,6f2 <vprintf+0x16a>
        while(*s != 0){
 6d4:	0009c583          	lbu	a1,0(s3)
 6d8:	c5ad                	beqz	a1,742 <vprintf+0x1ba>
          putc(fd, *s);
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	dde080e7          	jalr	-546(ra) # 4ba <putc>
          s++;
 6e4:	0985                	addi	s3,s3,1
        while(*s != 0){
 6e6:	0009c583          	lbu	a1,0(s3)
 6ea:	f9e5                	bnez	a1,6da <vprintf+0x152>
        s = va_arg(ap, char*);
 6ec:	8b4a                	mv	s6,s2
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bde5                	j	5e8 <vprintf+0x60>
          s = "(null)";
 6f2:	00000997          	auipc	s3,0x0
 6f6:	6a698993          	addi	s3,s3,1702 # d98 <close_file+0xb6>
        while(*s != 0){
 6fa:	85ee                	mv	a1,s11
 6fc:	bff9                	j	6da <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 6fe:	008b0913          	addi	s2,s6,8
 702:	000b4583          	lbu	a1,0(s6)
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	db2080e7          	jalr	-590(ra) # 4ba <putc>
 710:	8b4a                	mv	s6,s2
      state = 0;
 712:	4981                	li	s3,0
 714:	bdd1                	j	5e8 <vprintf+0x60>
        putc(fd, c);
 716:	85d2                	mv	a1,s4
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	da0080e7          	jalr	-608(ra) # 4ba <putc>
      state = 0;
 722:	4981                	li	s3,0
 724:	b5d1                	j	5e8 <vprintf+0x60>
        putc(fd, '%');
 726:	85d2                	mv	a1,s4
 728:	8556                	mv	a0,s5
 72a:	00000097          	auipc	ra,0x0
 72e:	d90080e7          	jalr	-624(ra) # 4ba <putc>
        putc(fd, c);
 732:	85ca                	mv	a1,s2
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	d84080e7          	jalr	-636(ra) # 4ba <putc>
      state = 0;
 73e:	4981                	li	s3,0
 740:	b565                	j	5e8 <vprintf+0x60>
        s = va_arg(ap, char*);
 742:	8b4a                	mv	s6,s2
      state = 0;
 744:	4981                	li	s3,0
 746:	b54d                	j	5e8 <vprintf+0x60>
    }
  }
}
 748:	70e6                	ld	ra,120(sp)
 74a:	7446                	ld	s0,112(sp)
 74c:	74a6                	ld	s1,104(sp)
 74e:	7906                	ld	s2,96(sp)
 750:	69e6                	ld	s3,88(sp)
 752:	6a46                	ld	s4,80(sp)
 754:	6aa6                	ld	s5,72(sp)
 756:	6b06                	ld	s6,64(sp)
 758:	7be2                	ld	s7,56(sp)
 75a:	7c42                	ld	s8,48(sp)
 75c:	7ca2                	ld	s9,40(sp)
 75e:	7d02                	ld	s10,32(sp)
 760:	6de2                	ld	s11,24(sp)
 762:	6109                	addi	sp,sp,128
 764:	8082                	ret

0000000000000766 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 766:	715d                	addi	sp,sp,-80
 768:	ec06                	sd	ra,24(sp)
 76a:	e822                	sd	s0,16(sp)
 76c:	1000                	addi	s0,sp,32
 76e:	e010                	sd	a2,0(s0)
 770:	e414                	sd	a3,8(s0)
 772:	e818                	sd	a4,16(s0)
 774:	ec1c                	sd	a5,24(s0)
 776:	03043023          	sd	a6,32(s0)
 77a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 77e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 782:	8622                	mv	a2,s0
 784:	00000097          	auipc	ra,0x0
 788:	e04080e7          	jalr	-508(ra) # 588 <vprintf>
}
 78c:	60e2                	ld	ra,24(sp)
 78e:	6442                	ld	s0,16(sp)
 790:	6161                	addi	sp,sp,80
 792:	8082                	ret

0000000000000794 <printf>:

void
printf(const char *fmt, ...)
{
 794:	711d                	addi	sp,sp,-96
 796:	ec06                	sd	ra,24(sp)
 798:	e822                	sd	s0,16(sp)
 79a:	1000                	addi	s0,sp,32
 79c:	e40c                	sd	a1,8(s0)
 79e:	e810                	sd	a2,16(s0)
 7a0:	ec14                	sd	a3,24(s0)
 7a2:	f018                	sd	a4,32(s0)
 7a4:	f41c                	sd	a5,40(s0)
 7a6:	03043823          	sd	a6,48(s0)
 7aa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ae:	00840613          	addi	a2,s0,8
 7b2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7b6:	85aa                	mv	a1,a0
 7b8:	4505                	li	a0,1
 7ba:	00000097          	auipc	ra,0x0
 7be:	dce080e7          	jalr	-562(ra) # 588 <vprintf>
}
 7c2:	60e2                	ld	ra,24(sp)
 7c4:	6442                	ld	s0,16(sp)
 7c6:	6125                	addi	sp,sp,96
 7c8:	8082                	ret

00000000000007ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ca:	1141                	addi	sp,sp,-16
 7cc:	e422                	sd	s0,8(sp)
 7ce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d4:	00001797          	auipc	a5,0x1
 7d8:	82c7b783          	ld	a5,-2004(a5) # 1000 <freep>
 7dc:	a02d                	j	806 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7de:	4618                	lw	a4,8(a2)
 7e0:	9f2d                	addw	a4,a4,a1
 7e2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e6:	6398                	ld	a4,0(a5)
 7e8:	6310                	ld	a2,0(a4)
 7ea:	a83d                	j	828 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ec:	ff852703          	lw	a4,-8(a0)
 7f0:	9f31                	addw	a4,a4,a2
 7f2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7f4:	ff053683          	ld	a3,-16(a0)
 7f8:	a091                	j	83c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fa:	6398                	ld	a4,0(a5)
 7fc:	00e7e463          	bltu	a5,a4,804 <free+0x3a>
 800:	00e6ea63          	bltu	a3,a4,814 <free+0x4a>
{
 804:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 806:	fed7fae3          	bgeu	a5,a3,7fa <free+0x30>
 80a:	6398                	ld	a4,0(a5)
 80c:	00e6e463          	bltu	a3,a4,814 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	fee7eae3          	bltu	a5,a4,804 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 814:	ff852583          	lw	a1,-8(a0)
 818:	6390                	ld	a2,0(a5)
 81a:	02059813          	slli	a6,a1,0x20
 81e:	01c85713          	srli	a4,a6,0x1c
 822:	9736                	add	a4,a4,a3
 824:	fae60de3          	beq	a2,a4,7de <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 828:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 82c:	4790                	lw	a2,8(a5)
 82e:	02061593          	slli	a1,a2,0x20
 832:	01c5d713          	srli	a4,a1,0x1c
 836:	973e                	add	a4,a4,a5
 838:	fae68ae3          	beq	a3,a4,7ec <free+0x22>
    p->s.ptr = bp->s.ptr;
 83c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 83e:	00000717          	auipc	a4,0x0
 842:	7cf73123          	sd	a5,1986(a4) # 1000 <freep>
}
 846:	6422                	ld	s0,8(sp)
 848:	0141                	addi	sp,sp,16
 84a:	8082                	ret

000000000000084c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 84c:	7139                	addi	sp,sp,-64
 84e:	fc06                	sd	ra,56(sp)
 850:	f822                	sd	s0,48(sp)
 852:	f426                	sd	s1,40(sp)
 854:	f04a                	sd	s2,32(sp)
 856:	ec4e                	sd	s3,24(sp)
 858:	e852                	sd	s4,16(sp)
 85a:	e456                	sd	s5,8(sp)
 85c:	e05a                	sd	s6,0(sp)
 85e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 860:	02051493          	slli	s1,a0,0x20
 864:	9081                	srli	s1,s1,0x20
 866:	04bd                	addi	s1,s1,15
 868:	8091                	srli	s1,s1,0x4
 86a:	0014899b          	addiw	s3,s1,1
 86e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 870:	00000517          	auipc	a0,0x0
 874:	79053503          	ld	a0,1936(a0) # 1000 <freep>
 878:	c515                	beqz	a0,8a4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87c:	4798                	lw	a4,8(a5)
 87e:	02977f63          	bgeu	a4,s1,8bc <malloc+0x70>
 882:	8a4e                	mv	s4,s3
 884:	0009871b          	sext.w	a4,s3
 888:	6685                	lui	a3,0x1
 88a:	00d77363          	bgeu	a4,a3,890 <malloc+0x44>
 88e:	6a05                	lui	s4,0x1
 890:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 894:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 898:	00000917          	auipc	s2,0x0
 89c:	76890913          	addi	s2,s2,1896 # 1000 <freep>
  if(p == (char*)-1)
 8a0:	5afd                	li	s5,-1
 8a2:	a895                	j	916 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8a4:	00000797          	auipc	a5,0x0
 8a8:	76c78793          	addi	a5,a5,1900 # 1010 <base>
 8ac:	00000717          	auipc	a4,0x0
 8b0:	74f73a23          	sd	a5,1876(a4) # 1000 <freep>
 8b4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ba:	b7e1                	j	882 <malloc+0x36>
      if(p->s.size == nunits)
 8bc:	02e48c63          	beq	s1,a4,8f4 <malloc+0xa8>
        p->s.size -= nunits;
 8c0:	4137073b          	subw	a4,a4,s3
 8c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c6:	02071693          	slli	a3,a4,0x20
 8ca:	01c6d713          	srli	a4,a3,0x1c
 8ce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d4:	00000717          	auipc	a4,0x0
 8d8:	72a73623          	sd	a0,1836(a4) # 1000 <freep>
      return (void*)(p + 1);
 8dc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8e0:	70e2                	ld	ra,56(sp)
 8e2:	7442                	ld	s0,48(sp)
 8e4:	74a2                	ld	s1,40(sp)
 8e6:	7902                	ld	s2,32(sp)
 8e8:	69e2                	ld	s3,24(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
 8f0:	6121                	addi	sp,sp,64
 8f2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8f4:	6398                	ld	a4,0(a5)
 8f6:	e118                	sd	a4,0(a0)
 8f8:	bff1                	j	8d4 <malloc+0x88>
  hp->s.size = nu;
 8fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8fe:	0541                	addi	a0,a0,16
 900:	00000097          	auipc	ra,0x0
 904:	eca080e7          	jalr	-310(ra) # 7ca <free>
  return freep;
 908:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 90c:	d971                	beqz	a0,8e0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 910:	4798                	lw	a4,8(a5)
 912:	fa9775e3          	bgeu	a4,s1,8bc <malloc+0x70>
    if(p == freep)
 916:	00093703          	ld	a4,0(s2)
 91a:	853e                	mv	a0,a5
 91c:	fef719e3          	bne	a4,a5,90e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 920:	8552                	mv	a0,s4
 922:	00000097          	auipc	ra,0x0
 926:	b70080e7          	jalr	-1168(ra) # 492 <sbrk>
  if(p == (char*)-1)
 92a:	fd5518e3          	bne	a0,s5,8fa <malloc+0xae>
        return 0;
 92e:	4501                	li	a0,0
 930:	bf45                	j	8e0 <malloc+0x94>

0000000000000932 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 932:	c1d9                	beqz	a1,9b8 <head_run+0x86>
void head_run(int fd, int numOfLines){
 934:	dd010113          	addi	sp,sp,-560
 938:	22113423          	sd	ra,552(sp)
 93c:	22813023          	sd	s0,544(sp)
 940:	20913c23          	sd	s1,536(sp)
 944:	21213823          	sd	s2,528(sp)
 948:	21313423          	sd	s3,520(sp)
 94c:	21413023          	sd	s4,512(sp)
 950:	1c00                	addi	s0,sp,560
 952:	892a                	mv	s2,a0
 954:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 958:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 95a:	00000a17          	auipc	s4,0x0
 95e:	4dea0a13          	addi	s4,s4,1246 # e38 <digits+0x40>
		readStatus = read_line(fd, line);
 962:	dd840593          	addi	a1,s0,-552
 966:	854a                	mv	a0,s2
 968:	00000097          	auipc	ra,0x0
 96c:	318080e7          	jalr	792(ra) # c80 <read_line>
		if (readStatus == READ_ERROR){
 970:	01350d63          	beq	a0,s3,98a <head_run+0x58>
		if (readStatus == READ_EOF)
 974:	c11d                	beqz	a0,99a <head_run+0x68>
		printf("%s",line);
 976:	dd840593          	addi	a1,s0,-552
 97a:	8552                	mv	a0,s4
 97c:	00000097          	auipc	ra,0x0
 980:	e18080e7          	jalr	-488(ra) # 794 <printf>
	while(numOfLines--){
 984:	34fd                	addiw	s1,s1,-1
 986:	fcf1                	bnez	s1,962 <head_run+0x30>
 988:	a809                	j	99a <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 98a:	00000517          	auipc	a0,0x0
 98e:	48650513          	addi	a0,a0,1158 # e10 <digits+0x18>
 992:	00000097          	auipc	ra,0x0
 996:	e02080e7          	jalr	-510(ra) # 794 <printf>

	}
}
 99a:	22813083          	ld	ra,552(sp)
 99e:	22013403          	ld	s0,544(sp)
 9a2:	21813483          	ld	s1,536(sp)
 9a6:	21013903          	ld	s2,528(sp)
 9aa:	20813983          	ld	s3,520(sp)
 9ae:	20013a03          	ld	s4,512(sp)
 9b2:	23010113          	addi	sp,sp,560
 9b6:	8082                	ret
 9b8:	8082                	ret

00000000000009ba <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 9ba:	ba010113          	addi	sp,sp,-1120
 9be:	44113c23          	sd	ra,1112(sp)
 9c2:	44813823          	sd	s0,1104(sp)
 9c6:	44913423          	sd	s1,1096(sp)
 9ca:	45213023          	sd	s2,1088(sp)
 9ce:	43313c23          	sd	s3,1080(sp)
 9d2:	43413823          	sd	s4,1072(sp)
 9d6:	43513423          	sd	s5,1064(sp)
 9da:	43613023          	sd	s6,1056(sp)
 9de:	41713c23          	sd	s7,1048(sp)
 9e2:	41813823          	sd	s8,1040(sp)
 9e6:	41913423          	sd	s9,1032(sp)
 9ea:	41a13023          	sd	s10,1024(sp)
 9ee:	3fb13c23          	sd	s11,1016(sp)
 9f2:	46010413          	addi	s0,sp,1120
 9f6:	89aa                	mv	s3,a0
 9f8:	8aae                	mv	s5,a1
 9fa:	8c32                	mv	s8,a2
 9fc:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 9fe:	d9840593          	addi	a1,s0,-616
 a02:	00000097          	auipc	ra,0x0
 a06:	27e080e7          	jalr	638(ra) # c80 <read_line>


  if (readStatus == READ_ERROR)
 a0a:	57fd                	li	a5,-1
 a0c:	04f50163          	beq	a0,a5,a4e <uniq_run+0x94>
 a10:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 a12:	ed21                	bnez	a0,a6a <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 a14:	45813083          	ld	ra,1112(sp)
 a18:	45013403          	ld	s0,1104(sp)
 a1c:	44813483          	ld	s1,1096(sp)
 a20:	44013903          	ld	s2,1088(sp)
 a24:	43813983          	ld	s3,1080(sp)
 a28:	43013a03          	ld	s4,1072(sp)
 a2c:	42813a83          	ld	s5,1064(sp)
 a30:	42013b03          	ld	s6,1056(sp)
 a34:	41813b83          	ld	s7,1048(sp)
 a38:	41013c03          	ld	s8,1040(sp)
 a3c:	40813c83          	ld	s9,1032(sp)
 a40:	40013d03          	ld	s10,1024(sp)
 a44:	3f813d83          	ld	s11,1016(sp)
 a48:	46010113          	addi	sp,sp,1120
 a4c:	8082                	ret
    printf("[ERR] Error reading from the file ");
 a4e:	00000517          	auipc	a0,0x0
 a52:	3f250513          	addi	a0,a0,1010 # e40 <digits+0x48>
 a56:	00000097          	auipc	ra,0x0
 a5a:	d3e080e7          	jalr	-706(ra) # 794 <printf>
 a5e:	bf5d                	j	a14 <uniq_run+0x5a>
 a60:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a62:	8926                	mv	s2,s1
 a64:	84be                	mv	s1,a5
        lineCount = 1;
 a66:	8b6a                	mv	s6,s10
 a68:	a8ed                	j	b62 <uniq_run+0x1a8>
    int lineCount=1;
 a6a:	4b05                	li	s6,1
  char * line2 = buffer2;
 a6c:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 a70:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 a74:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 a76:	4d05                	li	s10,1
              printf("%s",line1);
 a78:	00000d97          	auipc	s11,0x0
 a7c:	3c0d8d93          	addi	s11,s11,960 # e38 <digits+0x40>
 a80:	a0cd                	j	b62 <uniq_run+0x1a8>
            if (repeatedLines){
 a82:	020a0b63          	beqz	s4,ab8 <uniq_run+0xfe>
                if (isRepeated){
 a86:	f80b87e3          	beqz	s7,a14 <uniq_run+0x5a>
                    if (showCount)
 a8a:	000c0d63          	beqz	s8,aa4 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 a8e:	864a                	mv	a2,s2
 a90:	85da                	mv	a1,s6
 a92:	00000517          	auipc	a0,0x0
 a96:	3d650513          	addi	a0,a0,982 # e68 <digits+0x70>
 a9a:	00000097          	auipc	ra,0x0
 a9e:	cfa080e7          	jalr	-774(ra) # 794 <printf>
 aa2:	bf8d                	j	a14 <uniq_run+0x5a>
                      printf("%s",line1);
 aa4:	85ca                	mv	a1,s2
 aa6:	00000517          	auipc	a0,0x0
 aaa:	39250513          	addi	a0,a0,914 # e38 <digits+0x40>
 aae:	00000097          	auipc	ra,0x0
 ab2:	ce6080e7          	jalr	-794(ra) # 794 <printf>
 ab6:	bfb9                	j	a14 <uniq_run+0x5a>
                if (showCount)
 ab8:	000c0d63          	beqz	s8,ad2 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 abc:	864a                	mv	a2,s2
 abe:	85da                	mv	a1,s6
 ac0:	00000517          	auipc	a0,0x0
 ac4:	3a850513          	addi	a0,a0,936 # e68 <digits+0x70>
 ac8:	00000097          	auipc	ra,0x0
 acc:	ccc080e7          	jalr	-820(ra) # 794 <printf>
 ad0:	b791                	j	a14 <uniq_run+0x5a>
                  printf("%s",line1);
 ad2:	85ca                	mv	a1,s2
 ad4:	00000517          	auipc	a0,0x0
 ad8:	36450513          	addi	a0,a0,868 # e38 <digits+0x40>
 adc:	00000097          	auipc	ra,0x0
 ae0:	cb8080e7          	jalr	-840(ra) # 794 <printf>
 ae4:	bf05                	j	a14 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 ae6:	00000517          	auipc	a0,0x0
 aea:	38a50513          	addi	a0,a0,906 # e70 <digits+0x78>
 aee:	00000097          	auipc	ra,0x0
 af2:	ca6080e7          	jalr	-858(ra) # 794 <printf>
          break;
 af6:	bf39                	j	a14 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 af8:	85a6                	mv	a1,s1
 afa:	854a                	mv	a0,s2
 afc:	00000097          	auipc	ra,0x0
 b00:	110080e7          	jalr	272(ra) # c0c <compare_str_ic>
 b04:	a041                	j	b84 <uniq_run+0x1ca>
                  printf("%s",line1);
 b06:	85ca                	mv	a1,s2
 b08:	856e                	mv	a0,s11
 b0a:	00000097          	auipc	ra,0x0
 b0e:	c8a080e7          	jalr	-886(ra) # 794 <printf>
        lineCount = 1;
 b12:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 b14:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b16:	8926                	mv	s2,s1
                  printf("%s",line1);
 b18:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b1a:	4b81                	li	s7,0
 b1c:	a099                	j	b62 <uniq_run+0x1a8>
            if (showCount)
 b1e:	020c0263          	beqz	s8,b42 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 b22:	864a                	mv	a2,s2
 b24:	85da                	mv	a1,s6
 b26:	00000517          	auipc	a0,0x0
 b2a:	34250513          	addi	a0,a0,834 # e68 <digits+0x70>
 b2e:	00000097          	auipc	ra,0x0
 b32:	c66080e7          	jalr	-922(ra) # 794 <printf>
 b36:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b38:	8926                	mv	s2,s1
 b3a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b3c:	4b81                	li	s7,0
        lineCount = 1;
 b3e:	8b6a                	mv	s6,s10
 b40:	a00d                	j	b62 <uniq_run+0x1a8>
              printf("%s",line1);
 b42:	85ca                	mv	a1,s2
 b44:	856e                	mv	a0,s11
 b46:	00000097          	auipc	ra,0x0
 b4a:	c4e080e7          	jalr	-946(ra) # 794 <printf>
 b4e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b50:	8926                	mv	s2,s1
              printf("%s",line1);
 b52:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b54:	4b81                	li	s7,0
        lineCount = 1;
 b56:	8b6a                	mv	s6,s10
 b58:	a029                	j	b62 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 b5a:	000a0363          	beqz	s4,b60 <uniq_run+0x1a6>
 b5e:	8bea                	mv	s7,s10
          lineCount++;
 b60:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 b62:	85a6                	mv	a1,s1
 b64:	854e                	mv	a0,s3
 b66:	00000097          	auipc	ra,0x0
 b6a:	11a080e7          	jalr	282(ra) # c80 <read_line>
        if (readStatus == READ_EOF){
 b6e:	d911                	beqz	a0,a82 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 b70:	f7950be3          	beq	a0,s9,ae6 <uniq_run+0x12c>
        if (!ignoreCase)
 b74:	f80a92e3          	bnez	s5,af8 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 b78:	85a6                	mv	a1,s1
 b7a:	854a                	mv	a0,s2
 b7c:	00000097          	auipc	ra,0x0
 b80:	062080e7          	jalr	98(ra) # bde <compare_str>
        if (compareStatus != 0){ 
 b84:	d979                	beqz	a0,b5a <uniq_run+0x1a0>
          if (repeatedLines){
 b86:	f80a0ce3          	beqz	s4,b1e <uniq_run+0x164>
            if (isRepeated){
 b8a:	ec0b8be3          	beqz	s7,a60 <uniq_run+0xa6>
                if (showCount)
 b8e:	f60c0ce3          	beqz	s8,b06 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 b92:	864a                	mv	a2,s2
 b94:	85da                	mv	a1,s6
 b96:	00000517          	auipc	a0,0x0
 b9a:	2d250513          	addi	a0,a0,722 # e68 <digits+0x70>
 b9e:	00000097          	auipc	ra,0x0
 ba2:	bf6080e7          	jalr	-1034(ra) # 794 <printf>
        lineCount = 1;
 ba6:	8b5e                	mv	s6,s7
 ba8:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 baa:	8926                	mv	s2,s1
 bac:	84be                	mv	s1,a5
        isRepeated = 0 ;
 bae:	4b81                	li	s7,0
 bb0:	bf4d                	j	b62 <uniq_run+0x1a8>

0000000000000bb2 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 bb2:	1141                	addi	sp,sp,-16
 bb4:	e422                	sd	s0,8(sp)
 bb6:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 bb8:	00054783          	lbu	a5,0(a0)
 bbc:	cf99                	beqz	a5,bda <get_strlen+0x28>
 bbe:	00150713          	addi	a4,a0,1
 bc2:	87ba                	mv	a5,a4
 bc4:	4685                	li	a3,1
 bc6:	9e99                	subw	a3,a3,a4
 bc8:	00f6853b          	addw	a0,a3,a5
 bcc:	0785                	addi	a5,a5,1
 bce:	fff7c703          	lbu	a4,-1(a5)
 bd2:	fb7d                	bnez	a4,bc8 <get_strlen+0x16>
	return len;
}
 bd4:	6422                	ld	s0,8(sp)
 bd6:	0141                	addi	sp,sp,16
 bd8:	8082                	ret
	int len = 0;
 bda:	4501                	li	a0,0
 bdc:	bfe5                	j	bd4 <get_strlen+0x22>

0000000000000bde <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 bde:	1141                	addi	sp,sp,-16
 be0:	e422                	sd	s0,8(sp)
 be2:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 be4:	00054783          	lbu	a5,0(a0)
 be8:	cb91                	beqz	a5,bfc <compare_str+0x1e>
 bea:	0005c703          	lbu	a4,0(a1)
 bee:	c719                	beqz	a4,bfc <compare_str+0x1e>
		if (*s1++ != *s2++)
 bf0:	0505                	addi	a0,a0,1
 bf2:	0585                	addi	a1,a1,1
 bf4:	fee788e3          	beq	a5,a4,be4 <compare_str+0x6>
			return 1;
 bf8:	4505                	li	a0,1
 bfa:	a031                	j	c06 <compare_str+0x28>
	}
	if (*s1 == *s2)
 bfc:	0005c503          	lbu	a0,0(a1)
 c00:	8d1d                	sub	a0,a0,a5
			return 1;
 c02:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 c06:	6422                	ld	s0,8(sp)
 c08:	0141                	addi	sp,sp,16
 c0a:	8082                	ret

0000000000000c0c <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 c0c:	1141                	addi	sp,sp,-16
 c0e:	e422                	sd	s0,8(sp)
 c10:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 c12:	4665                	li	a2,25
	while(*s1 && *s2){
 c14:	a019                	j	c1a <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 c16:	04e79763          	bne	a5,a4,c64 <compare_str_ic+0x58>
	while(*s1 && *s2){
 c1a:	00054783          	lbu	a5,0(a0)
 c1e:	cb9d                	beqz	a5,c54 <compare_str_ic+0x48>
 c20:	0005c703          	lbu	a4,0(a1)
 c24:	cb05                	beqz	a4,c54 <compare_str_ic+0x48>
		char b1 = *s1++;
 c26:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 c28:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 c2a:	fbf7869b          	addiw	a3,a5,-65
 c2e:	0ff6f693          	zext.b	a3,a3
 c32:	00d66663          	bltu	a2,a3,c3e <compare_str_ic+0x32>
			b1 += 32;
 c36:	0207879b          	addiw	a5,a5,32
 c3a:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 c3e:	fbf7069b          	addiw	a3,a4,-65
 c42:	0ff6f693          	zext.b	a3,a3
 c46:	fcd668e3          	bltu	a2,a3,c16 <compare_str_ic+0xa>
			b2 += 32;
 c4a:	0207071b          	addiw	a4,a4,32
 c4e:	0ff77713          	zext.b	a4,a4
 c52:	b7d1                	j	c16 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 c54:	0005c503          	lbu	a0,0(a1)
 c58:	8d1d                	sub	a0,a0,a5
			return 1;
 c5a:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 c5e:	6422                	ld	s0,8(sp)
 c60:	0141                	addi	sp,sp,16
 c62:	8082                	ret
			return 1;
 c64:	4505                	li	a0,1
 c66:	bfe5                	j	c5e <compare_str_ic+0x52>

0000000000000c68 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 c68:	1141                	addi	sp,sp,-16
 c6a:	e406                	sd	ra,8(sp)
 c6c:	e022                	sd	s0,0(sp)
 c6e:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 c70:	fffff097          	auipc	ra,0xfffff
 c74:	7da080e7          	jalr	2010(ra) # 44a <open>
	return fd;
}
 c78:	60a2                	ld	ra,8(sp)
 c7a:	6402                	ld	s0,0(sp)
 c7c:	0141                	addi	sp,sp,16
 c7e:	8082                	ret

0000000000000c80 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 c80:	7139                	addi	sp,sp,-64
 c82:	fc06                	sd	ra,56(sp)
 c84:	f822                	sd	s0,48(sp)
 c86:	f426                	sd	s1,40(sp)
 c88:	f04a                	sd	s2,32(sp)
 c8a:	ec4e                	sd	s3,24(sp)
 c8c:	e852                	sd	s4,16(sp)
 c8e:	0080                	addi	s0,sp,64
 c90:	89aa                	mv	s3,a0
 c92:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c94:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 c96:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c98:	4605                	li	a2,1
 c9a:	fcf40593          	addi	a1,s0,-49
 c9e:	854e                	mv	a0,s3
 ca0:	fffff097          	auipc	ra,0xfffff
 ca4:	782080e7          	jalr	1922(ra) # 422 <read>
		if (readStatus == 0){
 ca8:	c505                	beqz	a0,cd0 <read_line+0x50>
		*buffer++ = readByte;
 caa:	0485                	addi	s1,s1,1
 cac:	fcf44783          	lbu	a5,-49(s0)
 cb0:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 cb4:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 cb6:	ff4791e3          	bne	a5,s4,c98 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 cba:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 cbe:	854a                	mv	a0,s2
 cc0:	70e2                	ld	ra,56(sp)
 cc2:	7442                	ld	s0,48(sp)
 cc4:	74a2                	ld	s1,40(sp)
 cc6:	7902                	ld	s2,32(sp)
 cc8:	69e2                	ld	s3,24(sp)
 cca:	6a42                	ld	s4,16(sp)
 ccc:	6121                	addi	sp,sp,64
 cce:	8082                	ret
			if (byteCount!=0){
 cd0:	fe0907e3          	beqz	s2,cbe <read_line+0x3e>
				*buffer = '\n';
 cd4:	47a9                	li	a5,10
 cd6:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 cda:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 cde:	2905                	addiw	s2,s2,1
 ce0:	bff9                	j	cbe <read_line+0x3e>

0000000000000ce2 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 ce2:	1141                	addi	sp,sp,-16
 ce4:	e406                	sd	ra,8(sp)
 ce6:	e022                	sd	s0,0(sp)
 ce8:	0800                	addi	s0,sp,16
	close(fd);
 cea:	fffff097          	auipc	ra,0xfffff
 cee:	748080e7          	jalr	1864(ra) # 432 <close>
}
 cf2:	60a2                	ld	ra,8(sp)
 cf4:	6402                	ld	s0,0(sp)
 cf6:	0141                	addi	sp,sp,16
 cf8:	8082                	ret
