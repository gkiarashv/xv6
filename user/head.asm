
user/_head:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
static u8 ** parse_cmd(u32 argc, u8 ** cmd, u32 *lineCount);
u32 head_usermode(u8 **passedFiles, u32 lineCount);
void head_run(s32 fd, u32 numOfLines);


s32 main(s32 argc, u8 ** argv){
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  14:	892e                	mv	s2,a1

	/* Default value for lineCount */
	*lineCount = NUM_OF_LINES;

	/* Total number of files is maximum argc-1 requiring argc size storage for the last NULL*/
	u8 ** passedFiles = malloc(sizeof(u8 *) * (argc));
  16:	0035151b          	slliw	a0,a0,0x3
  1a:	00001097          	auipc	ra,0x1
  1e:	860080e7          	jalr	-1952(ra) # 87a <malloc>

	if (!passedFiles){
  22:	c549                	beqz	a0,ac <main+0xac>
  24:	8a2a                	mv	s4,a0
		return NULL;
	}


	u32 fileIdx = 0;
	cmd++;  // Skipping the program's name
  26:	00890493          	addi	s1,s2,8
	
	while(*cmd){
  2a:	00893503          	ld	a0,8(s2)
  2e:	c531                	beqz	a0,7a <main+0x7a>
	*lineCount = NUM_OF_LINES;
  30:	4ab9                	li	s5,14
	u32 fileIdx = 0;
  32:	4981                	li	s3,0
		if (!compare_str(cmd[0], "-n")){
  34:	00001b17          	auipc	s6,0x1
  38:	accb0b13          	addi	s6,s6,-1332 # b00 <compare_str_ic+0x62>
  3c:	a839                	j	5a <main+0x5a>
			cmd++;
			*lineCount = atoi(cmd[0]);
		}
		else
			passedFiles[fileIdx++] = cmd[0];
  3e:	6098                	ld	a4,0(s1)
  40:	02099693          	slli	a3,s3,0x20
  44:	01d6d793          	srli	a5,a3,0x1d
  48:	97d2                	add	a5,a5,s4
  4a:	e398                	sd	a4,0(a5)
  4c:	2985                	addiw	s3,s3,1
  4e:	8926                	mv	s2,s1
			
		cmd++;
  50:	00890493          	addi	s1,s2,8
	while(*cmd){
  54:	00893503          	ld	a0,8(s2)
  58:	c11d                	beqz	a0,7e <main+0x7e>
		if (!compare_str(cmd[0], "-n")){
  5a:	85da                	mv	a1,s6
  5c:	00001097          	auipc	ra,0x1
  60:	a14080e7          	jalr	-1516(ra) # a70 <compare_str>
  64:	fd69                	bnez	a0,3e <main+0x3e>
			cmd++;
  66:	00848913          	addi	s2,s1,8
			*lineCount = atoi(cmd[0]);
  6a:	6488                	ld	a0,8(s1)
  6c:	00000097          	auipc	ra,0x0
  70:	2d2080e7          	jalr	722(ra) # 33e <atoi>
  74:	00050a9b          	sext.w	s5,a0
  78:	bfe1                	j	50 <main+0x50>
	*lineCount = NUM_OF_LINES;
  7a:	4ab9                	li	s5,14
	u32 fileIdx = 0;
  7c:	4981                	li	s3,0
	}

	passedFiles[fileIdx]=NULL;
  7e:	02099793          	slli	a5,s3,0x20
  82:	01d7d993          	srli	s3,a5,0x1d
  86:	99d2                	add	s3,s3,s4
  88:	0009b023          	sd	zero,0(s3)
	head(passedFiles, lineCount);
  8c:	85d6                	mv	a1,s5
  8e:	8552                	mv	a0,s4
  90:	00000097          	auipc	ra,0x0
  94:	448080e7          	jalr	1096(ra) # 4d8 <head>
}
  98:	70e2                	ld	ra,56(sp)
  9a:	7442                	ld	s0,48(sp)
  9c:	74a2                	ld	s1,40(sp)
  9e:	7902                	ld	s2,32(sp)
  a0:	69e2                	ld	s3,24(sp)
  a2:	6a42                	ld	s4,16(sp)
  a4:	6aa2                	ld	s5,8(sp)
  a6:	6b02                	ld	s6,0(sp)
  a8:	6121                	addi	sp,sp,64
  aa:	8082                	ret
		print("[ERR] Cannot parse the cmd");
  ac:	00001517          	auipc	a0,0x1
  b0:	a5c50513          	addi	a0,a0,-1444 # b08 <compare_str_ic+0x6a>
  b4:	00001097          	auipc	ra,0x1
  b8:	8d8080e7          	jalr	-1832(ra) # 98c <print>
		return 1;
  bc:	4505                	li	a0,1
  be:	bfe9                	j	98 <main+0x98>

00000000000000c0 <head_run>:
void head_run(s32 fd, u32 numOfLines){
  c0:	7139                	addi	sp,sp,-64
  c2:	fc06                	sd	ra,56(sp)
  c4:	f822                	sd	s0,48(sp)
  c6:	f426                	sd	s1,40(sp)
  c8:	f04a                	sd	s2,32(sp)
  ca:	ec4e                	sd	s3,24(sp)
  cc:	e852                	sd	s4,16(sp)
  ce:	e456                	sd	s5,8(sp)
  d0:	e05a                	sd	s6,0(sp)
  d2:	0080                	addi	s0,sp,64
  d4:	89aa                	mv	s3,a0
  d6:	8a2e                	mv	s4,a1
	u8 * line = malloc(500);
  d8:	1f400513          	li	a0,500
  dc:	00000097          	auipc	ra,0x0
  e0:	79e080e7          	jalr	1950(ra) # 87a <malloc>
	while(numOfLines--){
  e4:	040a0a63          	beqz	s4,138 <head_run+0x78>
  e8:	84aa                	mv	s1,a0
  ea:	fffa091b          	addiw	s2,s4,-1
		if (readStatus == READ_EOF || readStatus == READ_ERROR){
  ee:	4a05                	li	s4,1
		printf("%s",line);
  f0:	00001b17          	auipc	s6,0x1
  f4:	a58b0b13          	addi	s6,s6,-1448 # b48 <compare_str_ic+0xaa>
	while(numOfLines--){
  f8:	5afd                	li	s5,-1
		readStatus = read_line(fd, line);
  fa:	85a6                	mv	a1,s1
  fc:	854e                	mv	a0,s3
  fe:	00001097          	auipc	ra,0x1
 102:	8d4080e7          	jalr	-1836(ra) # 9d2 <read_line>
		if (readStatus == READ_EOF || readStatus == READ_ERROR){
 106:	00150793          	addi	a5,a0,1
 10a:	00fa7f63          	bgeu	s4,a5,128 <head_run+0x68>
		line[readStatus]=0;
 10e:	9526                	add	a0,a0,s1
 110:	00050023          	sb	zero,0(a0)
		printf("%s",line);
 114:	85a6                	mv	a1,s1
 116:	855a                	mv	a0,s6
 118:	00000097          	auipc	ra,0x0
 11c:	6aa080e7          	jalr	1706(ra) # 7c2 <printf>
	while(numOfLines--){
 120:	397d                	addiw	s2,s2,-1
 122:	fd591ce3          	bne	s2,s5,fa <head_run+0x3a>
 126:	a809                	j	138 <head_run+0x78>
			printf("Error reading from the file \n");
 128:	00001517          	auipc	a0,0x1
 12c:	a0050513          	addi	a0,a0,-1536 # b28 <compare_str_ic+0x8a>
 130:	00000097          	auipc	ra,0x0
 134:	692080e7          	jalr	1682(ra) # 7c2 <printf>
}
 138:	70e2                	ld	ra,56(sp)
 13a:	7442                	ld	s0,48(sp)
 13c:	74a2                	ld	s1,40(sp)
 13e:	7902                	ld	s2,32(sp)
 140:	69e2                	ld	s3,24(sp)
 142:	6a42                	ld	s4,16(sp)
 144:	6aa2                	ld	s5,8(sp)
 146:	6b02                	ld	s6,0(sp)
 148:	6121                	addi	sp,sp,64
 14a:	8082                	ret

000000000000014c <head_usermode>:
u32 head_usermode(u8 **passedFiles, u32 lineCount){
 14c:	7179                	addi	sp,sp,-48
 14e:	f406                	sd	ra,40(sp)
 150:	f022                	sd	s0,32(sp)
 152:	ec26                	sd	s1,24(sp)
 154:	e84a                	sd	s2,16(sp)
 156:	e44e                	sd	s3,8(sp)
 158:	e052                	sd	s4,0(sp)
 15a:	1800                	addi	s0,sp,48
 15c:	84aa                	mv	s1,a0
 15e:	89ae                	mv	s3,a1
	if(!passedFiles[0])
 160:	6108                	ld	a0,0(a0)
			if (fd == OPEN_FILE_ERROR)
 162:	597d                	li	s2,-1
				printf("Error opening the file \n");
 164:	00001a17          	auipc	s4,0x1
 168:	9eca0a13          	addi	s4,s4,-1556 # b50 <compare_str_ic+0xb2>
	if(!passedFiles[0])
 16c:	e515                	bnez	a0,198 <head_usermode+0x4c>
		head_run(STDIN, lineCount);
 16e:	00000097          	auipc	ra,0x0
 172:	f52080e7          	jalr	-174(ra) # c0 <head_run>
}
 176:	4501                	li	a0,0
 178:	70a2                	ld	ra,40(sp)
 17a:	7402                	ld	s0,32(sp)
 17c:	64e2                	ld	s1,24(sp)
 17e:	6942                	ld	s2,16(sp)
 180:	69a2                	ld	s3,8(sp)
 182:	6a02                	ld	s4,0(sp)
 184:	6145                	addi	sp,sp,48
 186:	8082                	ret
				head_run(fd , lineCount);
 188:	85ce                	mv	a1,s3
 18a:	00000097          	auipc	ra,0x0
 18e:	f36080e7          	jalr	-202(ra) # c0 <head_run>
			passedFiles++;
 192:	04a1                	addi	s1,s1,8
		while (*passedFiles){
 194:	6088                	ld	a0,0(s1)
 196:	d165                	beqz	a0,176 <head_usermode+0x2a>
			u32 fd = open_file(*passedFiles, RDONLY);
 198:	4581                	li	a1,0
 19a:	00001097          	auipc	ra,0x1
 19e:	820080e7          	jalr	-2016(ra) # 9ba <open_file>
			if (fd == OPEN_FILE_ERROR)
 1a2:	ff2513e3          	bne	a0,s2,188 <head_usermode+0x3c>
				printf("Error opening the file \n");
 1a6:	8552                	mv	a0,s4
 1a8:	00000097          	auipc	ra,0x0
 1ac:	61a080e7          	jalr	1562(ra) # 7c2 <printf>
 1b0:	b7cd                	j	192 <head_usermode+0x46>

00000000000001b2 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e406                	sd	ra,8(sp)
 1b6:	e022                	sd	s0,0(sp)
 1b8:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1ba:	00000097          	auipc	ra,0x0
 1be:	e46080e7          	jalr	-442(ra) # 0 <main>
  exit(0);
 1c2:	4501                	li	a0,0
 1c4:	00000097          	auipc	ra,0x0
 1c8:	274080e7          	jalr	628(ra) # 438 <exit>

00000000000001cc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d2:	87aa                	mv	a5,a0
 1d4:	0585                	addi	a1,a1,1
 1d6:	0785                	addi	a5,a5,1
 1d8:	fff5c703          	lbu	a4,-1(a1)
 1dc:	fee78fa3          	sb	a4,-1(a5)
 1e0:	fb75                	bnez	a4,1d4 <strcpy+0x8>
    ;
  return os;
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret

00000000000001e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	cb91                	beqz	a5,206 <strcmp+0x1e>
 1f4:	0005c703          	lbu	a4,0(a1)
 1f8:	00f71763          	bne	a4,a5,206 <strcmp+0x1e>
    p++, q++;
 1fc:	0505                	addi	a0,a0,1
 1fe:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 200:	00054783          	lbu	a5,0(a0)
 204:	fbe5                	bnez	a5,1f4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 206:	0005c503          	lbu	a0,0(a1)
}
 20a:	40a7853b          	subw	a0,a5,a0
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret

0000000000000214 <strlen>:

uint
strlen(const char *s)
{
 214:	1141                	addi	sp,sp,-16
 216:	e422                	sd	s0,8(sp)
 218:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 21a:	00054783          	lbu	a5,0(a0)
 21e:	cf91                	beqz	a5,23a <strlen+0x26>
 220:	0505                	addi	a0,a0,1
 222:	87aa                	mv	a5,a0
 224:	4685                	li	a3,1
 226:	9e89                	subw	a3,a3,a0
 228:	00f6853b          	addw	a0,a3,a5
 22c:	0785                	addi	a5,a5,1
 22e:	fff7c703          	lbu	a4,-1(a5)
 232:	fb7d                	bnez	a4,228 <strlen+0x14>
    ;
  return n;
}
 234:	6422                	ld	s0,8(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret
  for(n = 0; s[n]; n++)
 23a:	4501                	li	a0,0
 23c:	bfe5                	j	234 <strlen+0x20>

000000000000023e <memset>:

void*
memset(void *dst, int c, uint n)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 244:	ca19                	beqz	a2,25a <memset+0x1c>
 246:	87aa                	mv	a5,a0
 248:	1602                	slli	a2,a2,0x20
 24a:	9201                	srli	a2,a2,0x20
 24c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 250:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 254:	0785                	addi	a5,a5,1
 256:	fee79de3          	bne	a5,a4,250 <memset+0x12>
  }
  return dst;
}
 25a:	6422                	ld	s0,8(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret

0000000000000260 <strchr>:

char*
strchr(const char *s, char c)
{
 260:	1141                	addi	sp,sp,-16
 262:	e422                	sd	s0,8(sp)
 264:	0800                	addi	s0,sp,16
  for(; *s; s++)
 266:	00054783          	lbu	a5,0(a0)
 26a:	cb99                	beqz	a5,280 <strchr+0x20>
    if(*s == c)
 26c:	00f58763          	beq	a1,a5,27a <strchr+0x1a>
  for(; *s; s++)
 270:	0505                	addi	a0,a0,1
 272:	00054783          	lbu	a5,0(a0)
 276:	fbfd                	bnez	a5,26c <strchr+0xc>
      return (char*)s;
  return 0;
 278:	4501                	li	a0,0
}
 27a:	6422                	ld	s0,8(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
  return 0;
 280:	4501                	li	a0,0
 282:	bfe5                	j	27a <strchr+0x1a>

0000000000000284 <gets>:

char*
gets(char *buf, int max)
{
 284:	711d                	addi	sp,sp,-96
 286:	ec86                	sd	ra,88(sp)
 288:	e8a2                	sd	s0,80(sp)
 28a:	e4a6                	sd	s1,72(sp)
 28c:	e0ca                	sd	s2,64(sp)
 28e:	fc4e                	sd	s3,56(sp)
 290:	f852                	sd	s4,48(sp)
 292:	f456                	sd	s5,40(sp)
 294:	f05a                	sd	s6,32(sp)
 296:	ec5e                	sd	s7,24(sp)
 298:	1080                	addi	s0,sp,96
 29a:	8baa                	mv	s7,a0
 29c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 29e:	892a                	mv	s2,a0
 2a0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2a2:	4aa9                	li	s5,10
 2a4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2a6:	89a6                	mv	s3,s1
 2a8:	2485                	addiw	s1,s1,1
 2aa:	0344d863          	bge	s1,s4,2da <gets+0x56>
    cc = read(0, &c, 1);
 2ae:	4605                	li	a2,1
 2b0:	faf40593          	addi	a1,s0,-81
 2b4:	4501                	li	a0,0
 2b6:	00000097          	auipc	ra,0x0
 2ba:	19a080e7          	jalr	410(ra) # 450 <read>
    if(cc < 1)
 2be:	00a05e63          	blez	a0,2da <gets+0x56>
    buf[i++] = c;
 2c2:	faf44783          	lbu	a5,-81(s0)
 2c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ca:	01578763          	beq	a5,s5,2d8 <gets+0x54>
 2ce:	0905                	addi	s2,s2,1
 2d0:	fd679be3          	bne	a5,s6,2a6 <gets+0x22>
  for(i=0; i+1 < max; ){
 2d4:	89a6                	mv	s3,s1
 2d6:	a011                	j	2da <gets+0x56>
 2d8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2da:	99de                	add	s3,s3,s7
 2dc:	00098023          	sb	zero,0(s3)
  return buf;
}
 2e0:	855e                	mv	a0,s7
 2e2:	60e6                	ld	ra,88(sp)
 2e4:	6446                	ld	s0,80(sp)
 2e6:	64a6                	ld	s1,72(sp)
 2e8:	6906                	ld	s2,64(sp)
 2ea:	79e2                	ld	s3,56(sp)
 2ec:	7a42                	ld	s4,48(sp)
 2ee:	7aa2                	ld	s5,40(sp)
 2f0:	7b02                	ld	s6,32(sp)
 2f2:	6be2                	ld	s7,24(sp)
 2f4:	6125                	addi	sp,sp,96
 2f6:	8082                	ret

00000000000002f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f8:	1101                	addi	sp,sp,-32
 2fa:	ec06                	sd	ra,24(sp)
 2fc:	e822                	sd	s0,16(sp)
 2fe:	e426                	sd	s1,8(sp)
 300:	e04a                	sd	s2,0(sp)
 302:	1000                	addi	s0,sp,32
 304:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 306:	4581                	li	a1,0
 308:	00000097          	auipc	ra,0x0
 30c:	170080e7          	jalr	368(ra) # 478 <open>
  if(fd < 0)
 310:	02054563          	bltz	a0,33a <stat+0x42>
 314:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 316:	85ca                	mv	a1,s2
 318:	00000097          	auipc	ra,0x0
 31c:	178080e7          	jalr	376(ra) # 490 <fstat>
 320:	892a                	mv	s2,a0
  close(fd);
 322:	8526                	mv	a0,s1
 324:	00000097          	auipc	ra,0x0
 328:	13c080e7          	jalr	316(ra) # 460 <close>
  return r;
}
 32c:	854a                	mv	a0,s2
 32e:	60e2                	ld	ra,24(sp)
 330:	6442                	ld	s0,16(sp)
 332:	64a2                	ld	s1,8(sp)
 334:	6902                	ld	s2,0(sp)
 336:	6105                	addi	sp,sp,32
 338:	8082                	ret
    return -1;
 33a:	597d                	li	s2,-1
 33c:	bfc5                	j	32c <stat+0x34>

000000000000033e <atoi>:

int
atoi(const char *s)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 344:	00054683          	lbu	a3,0(a0)
 348:	fd06879b          	addiw	a5,a3,-48
 34c:	0ff7f793          	zext.b	a5,a5
 350:	4625                	li	a2,9
 352:	02f66863          	bltu	a2,a5,382 <atoi+0x44>
 356:	872a                	mv	a4,a0
  n = 0;
 358:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 35a:	0705                	addi	a4,a4,1
 35c:	0025179b          	slliw	a5,a0,0x2
 360:	9fa9                	addw	a5,a5,a0
 362:	0017979b          	slliw	a5,a5,0x1
 366:	9fb5                	addw	a5,a5,a3
 368:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 36c:	00074683          	lbu	a3,0(a4)
 370:	fd06879b          	addiw	a5,a3,-48
 374:	0ff7f793          	zext.b	a5,a5
 378:	fef671e3          	bgeu	a2,a5,35a <atoi+0x1c>
  return n;
}
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret
  n = 0;
 382:	4501                	li	a0,0
 384:	bfe5                	j	37c <atoi+0x3e>

0000000000000386 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 386:	1141                	addi	sp,sp,-16
 388:	e422                	sd	s0,8(sp)
 38a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 38c:	02b57463          	bgeu	a0,a1,3b4 <memmove+0x2e>
    while(n-- > 0)
 390:	00c05f63          	blez	a2,3ae <memmove+0x28>
 394:	1602                	slli	a2,a2,0x20
 396:	9201                	srli	a2,a2,0x20
 398:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 39c:	872a                	mv	a4,a0
      *dst++ = *src++;
 39e:	0585                	addi	a1,a1,1
 3a0:	0705                	addi	a4,a4,1
 3a2:	fff5c683          	lbu	a3,-1(a1)
 3a6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3aa:	fee79ae3          	bne	a5,a4,39e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
    dst += n;
 3b4:	00c50733          	add	a4,a0,a2
    src += n;
 3b8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ba:	fec05ae3          	blez	a2,3ae <memmove+0x28>
 3be:	fff6079b          	addiw	a5,a2,-1
 3c2:	1782                	slli	a5,a5,0x20
 3c4:	9381                	srli	a5,a5,0x20
 3c6:	fff7c793          	not	a5,a5
 3ca:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3cc:	15fd                	addi	a1,a1,-1
 3ce:	177d                	addi	a4,a4,-1
 3d0:	0005c683          	lbu	a3,0(a1)
 3d4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3d8:	fee79ae3          	bne	a5,a4,3cc <memmove+0x46>
 3dc:	bfc9                	j	3ae <memmove+0x28>

00000000000003de <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e422                	sd	s0,8(sp)
 3e2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3e4:	ca05                	beqz	a2,414 <memcmp+0x36>
 3e6:	fff6069b          	addiw	a3,a2,-1
 3ea:	1682                	slli	a3,a3,0x20
 3ec:	9281                	srli	a3,a3,0x20
 3ee:	0685                	addi	a3,a3,1
 3f0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3f2:	00054783          	lbu	a5,0(a0)
 3f6:	0005c703          	lbu	a4,0(a1)
 3fa:	00e79863          	bne	a5,a4,40a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3fe:	0505                	addi	a0,a0,1
    p2++;
 400:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 402:	fed518e3          	bne	a0,a3,3f2 <memcmp+0x14>
  }
  return 0;
 406:	4501                	li	a0,0
 408:	a019                	j	40e <memcmp+0x30>
      return *p1 - *p2;
 40a:	40e7853b          	subw	a0,a5,a4
}
 40e:	6422                	ld	s0,8(sp)
 410:	0141                	addi	sp,sp,16
 412:	8082                	ret
  return 0;
 414:	4501                	li	a0,0
 416:	bfe5                	j	40e <memcmp+0x30>

0000000000000418 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 418:	1141                	addi	sp,sp,-16
 41a:	e406                	sd	ra,8(sp)
 41c:	e022                	sd	s0,0(sp)
 41e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 420:	00000097          	auipc	ra,0x0
 424:	f66080e7          	jalr	-154(ra) # 386 <memmove>
}
 428:	60a2                	ld	ra,8(sp)
 42a:	6402                	ld	s0,0(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret

0000000000000430 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 430:	4885                	li	a7,1
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <exit>:
.global exit
exit:
 li a7, SYS_exit
 438:	4889                	li	a7,2
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <wait>:
.global wait
wait:
 li a7, SYS_wait
 440:	488d                	li	a7,3
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 448:	4891                	li	a7,4
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <read>:
.global read
read:
 li a7, SYS_read
 450:	4895                	li	a7,5
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <write>:
.global write
write:
 li a7, SYS_write
 458:	48c1                	li	a7,16
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <close>:
.global close
close:
 li a7, SYS_close
 460:	48d5                	li	a7,21
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <kill>:
.global kill
kill:
 li a7, SYS_kill
 468:	4899                	li	a7,6
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <exec>:
.global exec
exec:
 li a7, SYS_exec
 470:	489d                	li	a7,7
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <open>:
.global open
open:
 li a7, SYS_open
 478:	48bd                	li	a7,15
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 480:	48c5                	li	a7,17
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 488:	48c9                	li	a7,18
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 490:	48a1                	li	a7,8
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <link>:
.global link
link:
 li a7, SYS_link
 498:	48cd                	li	a7,19
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4a0:	48d1                	li	a7,20
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4a8:	48a5                	li	a7,9
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4b0:	48a9                	li	a7,10
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4b8:	48ad                	li	a7,11
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4c0:	48b1                	li	a7,12
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4c8:	48b5                	li	a7,13
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4d0:	48b9                	li	a7,14
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <head>:
.global head
head:
 li a7, SYS_head
 4d8:	48d9                	li	a7,22
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 4e0:	48dd                	li	a7,23
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4e8:	1101                	addi	sp,sp,-32
 4ea:	ec06                	sd	ra,24(sp)
 4ec:	e822                	sd	s0,16(sp)
 4ee:	1000                	addi	s0,sp,32
 4f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f4:	4605                	li	a2,1
 4f6:	fef40593          	addi	a1,s0,-17
 4fa:	00000097          	auipc	ra,0x0
 4fe:	f5e080e7          	jalr	-162(ra) # 458 <write>
}
 502:	60e2                	ld	ra,24(sp)
 504:	6442                	ld	s0,16(sp)
 506:	6105                	addi	sp,sp,32
 508:	8082                	ret

000000000000050a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 50a:	7139                	addi	sp,sp,-64
 50c:	fc06                	sd	ra,56(sp)
 50e:	f822                	sd	s0,48(sp)
 510:	f426                	sd	s1,40(sp)
 512:	f04a                	sd	s2,32(sp)
 514:	ec4e                	sd	s3,24(sp)
 516:	0080                	addi	s0,sp,64
 518:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 51a:	c299                	beqz	a3,520 <printint+0x16>
 51c:	0805c963          	bltz	a1,5ae <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 520:	2581                	sext.w	a1,a1
  neg = 0;
 522:	4881                	li	a7,0
 524:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 528:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 52a:	2601                	sext.w	a2,a2
 52c:	00000517          	auipc	a0,0x0
 530:	6a450513          	addi	a0,a0,1700 # bd0 <digits>
 534:	883a                	mv	a6,a4
 536:	2705                	addiw	a4,a4,1
 538:	02c5f7bb          	remuw	a5,a1,a2
 53c:	1782                	slli	a5,a5,0x20
 53e:	9381                	srli	a5,a5,0x20
 540:	97aa                	add	a5,a5,a0
 542:	0007c783          	lbu	a5,0(a5)
 546:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 54a:	0005879b          	sext.w	a5,a1
 54e:	02c5d5bb          	divuw	a1,a1,a2
 552:	0685                	addi	a3,a3,1
 554:	fec7f0e3          	bgeu	a5,a2,534 <printint+0x2a>
  if(neg)
 558:	00088c63          	beqz	a7,570 <printint+0x66>
    buf[i++] = '-';
 55c:	fd070793          	addi	a5,a4,-48
 560:	00878733          	add	a4,a5,s0
 564:	02d00793          	li	a5,45
 568:	fef70823          	sb	a5,-16(a4)
 56c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 570:	02e05863          	blez	a4,5a0 <printint+0x96>
 574:	fc040793          	addi	a5,s0,-64
 578:	00e78933          	add	s2,a5,a4
 57c:	fff78993          	addi	s3,a5,-1
 580:	99ba                	add	s3,s3,a4
 582:	377d                	addiw	a4,a4,-1
 584:	1702                	slli	a4,a4,0x20
 586:	9301                	srli	a4,a4,0x20
 588:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 58c:	fff94583          	lbu	a1,-1(s2)
 590:	8526                	mv	a0,s1
 592:	00000097          	auipc	ra,0x0
 596:	f56080e7          	jalr	-170(ra) # 4e8 <putc>
  while(--i >= 0)
 59a:	197d                	addi	s2,s2,-1
 59c:	ff3918e3          	bne	s2,s3,58c <printint+0x82>
}
 5a0:	70e2                	ld	ra,56(sp)
 5a2:	7442                	ld	s0,48(sp)
 5a4:	74a2                	ld	s1,40(sp)
 5a6:	7902                	ld	s2,32(sp)
 5a8:	69e2                	ld	s3,24(sp)
 5aa:	6121                	addi	sp,sp,64
 5ac:	8082                	ret
    x = -xx;
 5ae:	40b005bb          	negw	a1,a1
    neg = 1;
 5b2:	4885                	li	a7,1
    x = -xx;
 5b4:	bf85                	j	524 <printint+0x1a>

00000000000005b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b6:	7119                	addi	sp,sp,-128
 5b8:	fc86                	sd	ra,120(sp)
 5ba:	f8a2                	sd	s0,112(sp)
 5bc:	f4a6                	sd	s1,104(sp)
 5be:	f0ca                	sd	s2,96(sp)
 5c0:	ecce                	sd	s3,88(sp)
 5c2:	e8d2                	sd	s4,80(sp)
 5c4:	e4d6                	sd	s5,72(sp)
 5c6:	e0da                	sd	s6,64(sp)
 5c8:	fc5e                	sd	s7,56(sp)
 5ca:	f862                	sd	s8,48(sp)
 5cc:	f466                	sd	s9,40(sp)
 5ce:	f06a                	sd	s10,32(sp)
 5d0:	ec6e                	sd	s11,24(sp)
 5d2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5d4:	0005c903          	lbu	s2,0(a1)
 5d8:	18090f63          	beqz	s2,776 <vprintf+0x1c0>
 5dc:	8aaa                	mv	s5,a0
 5de:	8b32                	mv	s6,a2
 5e0:	00158493          	addi	s1,a1,1
  state = 0;
 5e4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5e6:	02500a13          	li	s4,37
 5ea:	4c55                	li	s8,21
 5ec:	00000c97          	auipc	s9,0x0
 5f0:	58cc8c93          	addi	s9,s9,1420 # b78 <compare_str_ic+0xda>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f4:	02800d93          	li	s11,40
  putc(fd, 'x');
 5f8:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fa:	00000b97          	auipc	s7,0x0
 5fe:	5d6b8b93          	addi	s7,s7,1494 # bd0 <digits>
 602:	a839                	j	620 <vprintf+0x6a>
        putc(fd, c);
 604:	85ca                	mv	a1,s2
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	ee0080e7          	jalr	-288(ra) # 4e8 <putc>
 610:	a019                	j	616 <vprintf+0x60>
    } else if(state == '%'){
 612:	01498d63          	beq	s3,s4,62c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 616:	0485                	addi	s1,s1,1
 618:	fff4c903          	lbu	s2,-1(s1)
 61c:	14090d63          	beqz	s2,776 <vprintf+0x1c0>
    if(state == 0){
 620:	fe0999e3          	bnez	s3,612 <vprintf+0x5c>
      if(c == '%'){
 624:	ff4910e3          	bne	s2,s4,604 <vprintf+0x4e>
        state = '%';
 628:	89d2                	mv	s3,s4
 62a:	b7f5                	j	616 <vprintf+0x60>
      if(c == 'd'){
 62c:	11490c63          	beq	s2,s4,744 <vprintf+0x18e>
 630:	f9d9079b          	addiw	a5,s2,-99
 634:	0ff7f793          	zext.b	a5,a5
 638:	10fc6e63          	bltu	s8,a5,754 <vprintf+0x19e>
 63c:	f9d9079b          	addiw	a5,s2,-99
 640:	0ff7f713          	zext.b	a4,a5
 644:	10ec6863          	bltu	s8,a4,754 <vprintf+0x19e>
 648:	00271793          	slli	a5,a4,0x2
 64c:	97e6                	add	a5,a5,s9
 64e:	439c                	lw	a5,0(a5)
 650:	97e6                	add	a5,a5,s9
 652:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 654:	008b0913          	addi	s2,s6,8
 658:	4685                	li	a3,1
 65a:	4629                	li	a2,10
 65c:	000b2583          	lw	a1,0(s6)
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	ea8080e7          	jalr	-344(ra) # 50a <printint>
 66a:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b765                	j	616 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 670:	008b0913          	addi	s2,s6,8
 674:	4681                	li	a3,0
 676:	4629                	li	a2,10
 678:	000b2583          	lw	a1,0(s6)
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	e8c080e7          	jalr	-372(ra) # 50a <printint>
 686:	8b4a                	mv	s6,s2
      state = 0;
 688:	4981                	li	s3,0
 68a:	b771                	j	616 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 68c:	008b0913          	addi	s2,s6,8
 690:	4681                	li	a3,0
 692:	866a                	mv	a2,s10
 694:	000b2583          	lw	a1,0(s6)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	e70080e7          	jalr	-400(ra) # 50a <printint>
 6a2:	8b4a                	mv	s6,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bf85                	j	616 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6a8:	008b0793          	addi	a5,s6,8
 6ac:	f8f43423          	sd	a5,-120(s0)
 6b0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6b4:	03000593          	li	a1,48
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	e2e080e7          	jalr	-466(ra) # 4e8 <putc>
  putc(fd, 'x');
 6c2:	07800593          	li	a1,120
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	e20080e7          	jalr	-480(ra) # 4e8 <putc>
 6d0:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d2:	03c9d793          	srli	a5,s3,0x3c
 6d6:	97de                	add	a5,a5,s7
 6d8:	0007c583          	lbu	a1,0(a5)
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	e0a080e7          	jalr	-502(ra) # 4e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e6:	0992                	slli	s3,s3,0x4
 6e8:	397d                	addiw	s2,s2,-1
 6ea:	fe0914e3          	bnez	s2,6d2 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 6ee:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	b70d                	j	616 <vprintf+0x60>
        s = va_arg(ap, char*);
 6f6:	008b0913          	addi	s2,s6,8
 6fa:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 6fe:	02098163          	beqz	s3,720 <vprintf+0x16a>
        while(*s != 0){
 702:	0009c583          	lbu	a1,0(s3)
 706:	c5ad                	beqz	a1,770 <vprintf+0x1ba>
          putc(fd, *s);
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	dde080e7          	jalr	-546(ra) # 4e8 <putc>
          s++;
 712:	0985                	addi	s3,s3,1
        while(*s != 0){
 714:	0009c583          	lbu	a1,0(s3)
 718:	f9e5                	bnez	a1,708 <vprintf+0x152>
        s = va_arg(ap, char*);
 71a:	8b4a                	mv	s6,s2
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bde5                	j	616 <vprintf+0x60>
          s = "(null)";
 720:	00000997          	auipc	s3,0x0
 724:	45098993          	addi	s3,s3,1104 # b70 <compare_str_ic+0xd2>
        while(*s != 0){
 728:	85ee                	mv	a1,s11
 72a:	bff9                	j	708 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 72c:	008b0913          	addi	s2,s6,8
 730:	000b4583          	lbu	a1,0(s6)
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	db2080e7          	jalr	-590(ra) # 4e8 <putc>
 73e:	8b4a                	mv	s6,s2
      state = 0;
 740:	4981                	li	s3,0
 742:	bdd1                	j	616 <vprintf+0x60>
        putc(fd, c);
 744:	85d2                	mv	a1,s4
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	da0080e7          	jalr	-608(ra) # 4e8 <putc>
      state = 0;
 750:	4981                	li	s3,0
 752:	b5d1                	j	616 <vprintf+0x60>
        putc(fd, '%');
 754:	85d2                	mv	a1,s4
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	d90080e7          	jalr	-624(ra) # 4e8 <putc>
        putc(fd, c);
 760:	85ca                	mv	a1,s2
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	d84080e7          	jalr	-636(ra) # 4e8 <putc>
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b565                	j	616 <vprintf+0x60>
        s = va_arg(ap, char*);
 770:	8b4a                	mv	s6,s2
      state = 0;
 772:	4981                	li	s3,0
 774:	b54d                	j	616 <vprintf+0x60>
    }
  }
}
 776:	70e6                	ld	ra,120(sp)
 778:	7446                	ld	s0,112(sp)
 77a:	74a6                	ld	s1,104(sp)
 77c:	7906                	ld	s2,96(sp)
 77e:	69e6                	ld	s3,88(sp)
 780:	6a46                	ld	s4,80(sp)
 782:	6aa6                	ld	s5,72(sp)
 784:	6b06                	ld	s6,64(sp)
 786:	7be2                	ld	s7,56(sp)
 788:	7c42                	ld	s8,48(sp)
 78a:	7ca2                	ld	s9,40(sp)
 78c:	7d02                	ld	s10,32(sp)
 78e:	6de2                	ld	s11,24(sp)
 790:	6109                	addi	sp,sp,128
 792:	8082                	ret

0000000000000794 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 794:	715d                	addi	sp,sp,-80
 796:	ec06                	sd	ra,24(sp)
 798:	e822                	sd	s0,16(sp)
 79a:	1000                	addi	s0,sp,32
 79c:	e010                	sd	a2,0(s0)
 79e:	e414                	sd	a3,8(s0)
 7a0:	e818                	sd	a4,16(s0)
 7a2:	ec1c                	sd	a5,24(s0)
 7a4:	03043023          	sd	a6,32(s0)
 7a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b0:	8622                	mv	a2,s0
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e04080e7          	jalr	-508(ra) # 5b6 <vprintf>
}
 7ba:	60e2                	ld	ra,24(sp)
 7bc:	6442                	ld	s0,16(sp)
 7be:	6161                	addi	sp,sp,80
 7c0:	8082                	ret

00000000000007c2 <printf>:

void
printf(const char *fmt, ...)
{
 7c2:	711d                	addi	sp,sp,-96
 7c4:	ec06                	sd	ra,24(sp)
 7c6:	e822                	sd	s0,16(sp)
 7c8:	1000                	addi	s0,sp,32
 7ca:	e40c                	sd	a1,8(s0)
 7cc:	e810                	sd	a2,16(s0)
 7ce:	ec14                	sd	a3,24(s0)
 7d0:	f018                	sd	a4,32(s0)
 7d2:	f41c                	sd	a5,40(s0)
 7d4:	03043823          	sd	a6,48(s0)
 7d8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7dc:	00840613          	addi	a2,s0,8
 7e0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7e4:	85aa                	mv	a1,a0
 7e6:	4505                	li	a0,1
 7e8:	00000097          	auipc	ra,0x0
 7ec:	dce080e7          	jalr	-562(ra) # 5b6 <vprintf>
}
 7f0:	60e2                	ld	ra,24(sp)
 7f2:	6442                	ld	s0,16(sp)
 7f4:	6125                	addi	sp,sp,96
 7f6:	8082                	ret

00000000000007f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f8:	1141                	addi	sp,sp,-16
 7fa:	e422                	sd	s0,8(sp)
 7fc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7fe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 802:	00000797          	auipc	a5,0x0
 806:	7fe7b783          	ld	a5,2046(a5) # 1000 <freep>
 80a:	a02d                	j	834 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 80c:	4618                	lw	a4,8(a2)
 80e:	9f2d                	addw	a4,a4,a1
 810:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 814:	6398                	ld	a4,0(a5)
 816:	6310                	ld	a2,0(a4)
 818:	a83d                	j	856 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 81a:	ff852703          	lw	a4,-8(a0)
 81e:	9f31                	addw	a4,a4,a2
 820:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 822:	ff053683          	ld	a3,-16(a0)
 826:	a091                	j	86a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	6398                	ld	a4,0(a5)
 82a:	00e7e463          	bltu	a5,a4,832 <free+0x3a>
 82e:	00e6ea63          	bltu	a3,a4,842 <free+0x4a>
{
 832:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 834:	fed7fae3          	bgeu	a5,a3,828 <free+0x30>
 838:	6398                	ld	a4,0(a5)
 83a:	00e6e463          	bltu	a3,a4,842 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83e:	fee7eae3          	bltu	a5,a4,832 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 842:	ff852583          	lw	a1,-8(a0)
 846:	6390                	ld	a2,0(a5)
 848:	02059813          	slli	a6,a1,0x20
 84c:	01c85713          	srli	a4,a6,0x1c
 850:	9736                	add	a4,a4,a3
 852:	fae60de3          	beq	a2,a4,80c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 856:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 85a:	4790                	lw	a2,8(a5)
 85c:	02061593          	slli	a1,a2,0x20
 860:	01c5d713          	srli	a4,a1,0x1c
 864:	973e                	add	a4,a4,a5
 866:	fae68ae3          	beq	a3,a4,81a <free+0x22>
    p->s.ptr = bp->s.ptr;
 86a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 86c:	00000717          	auipc	a4,0x0
 870:	78f73a23          	sd	a5,1940(a4) # 1000 <freep>
}
 874:	6422                	ld	s0,8(sp)
 876:	0141                	addi	sp,sp,16
 878:	8082                	ret

000000000000087a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 87a:	7139                	addi	sp,sp,-64
 87c:	fc06                	sd	ra,56(sp)
 87e:	f822                	sd	s0,48(sp)
 880:	f426                	sd	s1,40(sp)
 882:	f04a                	sd	s2,32(sp)
 884:	ec4e                	sd	s3,24(sp)
 886:	e852                	sd	s4,16(sp)
 888:	e456                	sd	s5,8(sp)
 88a:	e05a                	sd	s6,0(sp)
 88c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88e:	02051493          	slli	s1,a0,0x20
 892:	9081                	srli	s1,s1,0x20
 894:	04bd                	addi	s1,s1,15
 896:	8091                	srli	s1,s1,0x4
 898:	0014899b          	addiw	s3,s1,1
 89c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 89e:	00000517          	auipc	a0,0x0
 8a2:	76253503          	ld	a0,1890(a0) # 1000 <freep>
 8a6:	c515                	beqz	a0,8d2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8aa:	4798                	lw	a4,8(a5)
 8ac:	02977f63          	bgeu	a4,s1,8ea <malloc+0x70>
 8b0:	8a4e                	mv	s4,s3
 8b2:	0009871b          	sext.w	a4,s3
 8b6:	6685                	lui	a3,0x1
 8b8:	00d77363          	bgeu	a4,a3,8be <malloc+0x44>
 8bc:	6a05                	lui	s4,0x1
 8be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c6:	00000917          	auipc	s2,0x0
 8ca:	73a90913          	addi	s2,s2,1850 # 1000 <freep>
  if(p == (char*)-1)
 8ce:	5afd                	li	s5,-1
 8d0:	a895                	j	944 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8d2:	00000797          	auipc	a5,0x0
 8d6:	73e78793          	addi	a5,a5,1854 # 1010 <base>
 8da:	00000717          	auipc	a4,0x0
 8de:	72f73323          	sd	a5,1830(a4) # 1000 <freep>
 8e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e8:	b7e1                	j	8b0 <malloc+0x36>
      if(p->s.size == nunits)
 8ea:	02e48c63          	beq	s1,a4,922 <malloc+0xa8>
        p->s.size -= nunits;
 8ee:	4137073b          	subw	a4,a4,s3
 8f2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f4:	02071693          	slli	a3,a4,0x20
 8f8:	01c6d713          	srli	a4,a3,0x1c
 8fc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8fe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 902:	00000717          	auipc	a4,0x0
 906:	6ea73f23          	sd	a0,1790(a4) # 1000 <freep>
      return (void*)(p + 1);
 90a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 90e:	70e2                	ld	ra,56(sp)
 910:	7442                	ld	s0,48(sp)
 912:	74a2                	ld	s1,40(sp)
 914:	7902                	ld	s2,32(sp)
 916:	69e2                	ld	s3,24(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
 91e:	6121                	addi	sp,sp,64
 920:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 922:	6398                	ld	a4,0(a5)
 924:	e118                	sd	a4,0(a0)
 926:	bff1                	j	902 <malloc+0x88>
  hp->s.size = nu;
 928:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 92c:	0541                	addi	a0,a0,16
 92e:	00000097          	auipc	ra,0x0
 932:	eca080e7          	jalr	-310(ra) # 7f8 <free>
  return freep;
 936:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 93a:	d971                	beqz	a0,90e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93e:	4798                	lw	a4,8(a5)
 940:	fa9775e3          	bgeu	a4,s1,8ea <malloc+0x70>
    if(p == freep)
 944:	00093703          	ld	a4,0(s2)
 948:	853e                	mv	a0,a5
 94a:	fef719e3          	bne	a4,a5,93c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 94e:	8552                	mv	a0,s4
 950:	00000097          	auipc	ra,0x0
 954:	b70080e7          	jalr	-1168(ra) # 4c0 <sbrk>
  if(p == (char*)-1)
 958:	fd5518e3          	bne	a0,s5,928 <malloc+0xae>
        return 0;
 95c:	4501                	li	a0,0
 95e:	bf45                	j	90e <malloc+0x94>

0000000000000960 <str_len>:
 960:	1141                	addi	sp,sp,-16
 962:	e422                	sd	s0,8(sp)
 964:	0800                	addi	s0,sp,16
 966:	00054783          	lbu	a5,0(a0)
 96a:	cf99                	beqz	a5,988 <str_len+0x28>
 96c:	00150713          	addi	a4,a0,1
 970:	87ba                	mv	a5,a4
 972:	4685                	li	a3,1
 974:	9e99                	subw	a3,a3,a4
 976:	00f6853b          	addw	a0,a3,a5
 97a:	0785                	addi	a5,a5,1
 97c:	fff7c703          	lbu	a4,-1(a5)
 980:	fb7d                	bnez	a4,976 <str_len+0x16>
 982:	6422                	ld	s0,8(sp)
 984:	0141                	addi	sp,sp,16
 986:	8082                	ret
 988:	4501                	li	a0,0
 98a:	bfe5                	j	982 <str_len+0x22>

000000000000098c <print>:
 98c:	1101                	addi	sp,sp,-32
 98e:	ec06                	sd	ra,24(sp)
 990:	e822                	sd	s0,16(sp)
 992:	e426                	sd	s1,8(sp)
 994:	1000                	addi	s0,sp,32
 996:	84aa                	mv	s1,a0
 998:	00000097          	auipc	ra,0x0
 99c:	fc8080e7          	jalr	-56(ra) # 960 <str_len>
 9a0:	0005061b          	sext.w	a2,a0
 9a4:	85a6                	mv	a1,s1
 9a6:	4505                	li	a0,1
 9a8:	00000097          	auipc	ra,0x0
 9ac:	ab0080e7          	jalr	-1360(ra) # 458 <write>
 9b0:	60e2                	ld	ra,24(sp)
 9b2:	6442                	ld	s0,16(sp)
 9b4:	64a2                	ld	s1,8(sp)
 9b6:	6105                	addi	sp,sp,32
 9b8:	8082                	ret

00000000000009ba <open_file>:
[INPUT]: File's name
		 Manipulation mode

[OUTPUT]: File descriptor, -1 on error
*/
s32 open_file(u8 * filePath, s32 flag){
 9ba:	1141                	addi	sp,sp,-16
 9bc:	e406                	sd	ra,8(sp)
 9be:	e022                	sd	s0,0(sp)
 9c0:	0800                	addi	s0,sp,16
	s32 fd = open(filePath, flag);
 9c2:	00000097          	auipc	ra,0x0
 9c6:	ab6080e7          	jalr	-1354(ra) # 478 <open>
	return fd;
}
 9ca:	60a2                	ld	ra,8(sp)
 9cc:	6402                	ld	s0,0(sp)
 9ce:	0141                	addi	sp,sp,16
 9d0:	8082                	ret

00000000000009d2 <read_line>:




s64 read_line(s32 fd, u8 * buffer){
 9d2:	7139                	addi	sp,sp,-64
 9d4:	fc06                	sd	ra,56(sp)
 9d6:	f822                	sd	s0,48(sp)
 9d8:	f426                	sd	s1,40(sp)
 9da:	f04a                	sd	s2,32(sp)
 9dc:	ec4e                	sd	s3,24(sp)
 9de:	e852                	sd	s4,16(sp)
 9e0:	0080                	addi	s0,sp,64
 9e2:	892a                	mv	s2,a0
 9e4:	89ae                	mv	s3,a1

	u8 readByte;
	s64 byteCount = 0;
 9e6:	4481                	li	s1,0
		}

		*buffer++ = readByte;
		byteCount++;

		if (readByte == '\n')
 9e8:	4a29                	li	s4,10
	while((readStatus = read(fd,&readByte,1))){
 9ea:	4605                	li	a2,1
 9ec:	fcf40593          	addi	a1,s0,-49
 9f0:	854a                	mv	a0,s2
 9f2:	00000097          	auipc	ra,0x0
 9f6:	a5e080e7          	jalr	-1442(ra) # 450 <read>
 9fa:	87aa                	mv	a5,a0
 9fc:	cd01                	beqz	a0,a14 <read_line+0x42>
		if (readStatus <= 0L){
 9fe:	02f05463          	blez	a5,a26 <read_line+0x54>
		*buffer++ = readByte;
 a02:	fcf44783          	lbu	a5,-49(s0)
 a06:	00998733          	add	a4,s3,s1
 a0a:	00f70023          	sb	a5,0(a4)
		byteCount++;
 a0e:	0485                	addi	s1,s1,1
		if (readByte == '\n')
 a10:	fd479de3          	bne	a5,s4,9ea <read_line+0x18>
			return byteCount;
	}

	return byteCount;
}
 a14:	8526                	mv	a0,s1
 a16:	70e2                	ld	ra,56(sp)
 a18:	7442                	ld	s0,48(sp)
 a1a:	74a2                	ld	s1,40(sp)
 a1c:	7902                	ld	s2,32(sp)
 a1e:	69e2                	ld	s3,24(sp)
 a20:	6a42                	ld	s4,16(sp)
 a22:	6121                	addi	sp,sp,64
 a24:	8082                	ret
			if (byteCount == 0)
 a26:	f4fd                	bnez	s1,a14 <read_line+0x42>
	while((readStatus = read(fd,&readByte,1))){
 a28:	84aa                	mv	s1,a0
 a2a:	b7ed                	j	a14 <read_line+0x42>

0000000000000a2c <close_file>:


void close_file(s32 fd){
 a2c:	1141                	addi	sp,sp,-16
 a2e:	e406                	sd	ra,8(sp)
 a30:	e022                	sd	s0,0(sp)
 a32:	0800                	addi	s0,sp,16
	close(fd);
 a34:	00000097          	auipc	ra,0x0
 a38:	a2c080e7          	jalr	-1492(ra) # 460 <close>
}
 a3c:	60a2                	ld	ra,8(sp)
 a3e:	6402                	ld	s0,0(sp)
 a40:	0141                	addi	sp,sp,16
 a42:	8082                	ret

0000000000000a44 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
u32 get_strlen(const u8 * str){
 a44:	1141                	addi	sp,sp,-16
 a46:	e422                	sd	s0,8(sp)
 a48:	0800                	addi	s0,sp,16
	u32 len = 0;
	while(*str++){len++;};
 a4a:	00054783          	lbu	a5,0(a0)
 a4e:	cf99                	beqz	a5,a6c <get_strlen+0x28>
 a50:	00150713          	addi	a4,a0,1
 a54:	87ba                	mv	a5,a4
 a56:	4685                	li	a3,1
 a58:	9e99                	subw	a3,a3,a4
 a5a:	00f6853b          	addw	a0,a3,a5
 a5e:	0785                	addi	a5,a5,1
 a60:	fff7c703          	lbu	a4,-1(a5)
 a64:	fb7d                	bnez	a4,a5a <get_strlen+0x16>
	return len;
}
 a66:	6422                	ld	s0,8(sp)
 a68:	0141                	addi	sp,sp,16
 a6a:	8082                	ret
	u32 len = 0;
 a6c:	4501                	li	a0,0
 a6e:	bfe5                	j	a66 <get_strlen+0x22>

0000000000000a70 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
u8 compare_str(const u8 * s1 , const u8 * s2){
 a70:	1141                	addi	sp,sp,-16
 a72:	e422                	sd	s0,8(sp)
 a74:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 a76:	00054783          	lbu	a5,0(a0)
 a7a:	cb91                	beqz	a5,a8e <compare_str+0x1e>
 a7c:	0005c703          	lbu	a4,0(a1)
 a80:	c719                	beqz	a4,a8e <compare_str+0x1e>
		if (*s1++ != *s2++)
 a82:	0505                	addi	a0,a0,1
 a84:	0585                	addi	a1,a1,1
 a86:	fee788e3          	beq	a5,a4,a76 <compare_str+0x6>
			return 1;
 a8a:	4505                	li	a0,1
 a8c:	a031                	j	a98 <compare_str+0x28>
	}
	if (*s1 == *s2)
 a8e:	0005c503          	lbu	a0,0(a1)
 a92:	8d1d                	sub	a0,a0,a5
			return 1;
 a94:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 a98:	6422                	ld	s0,8(sp)
 a9a:	0141                	addi	sp,sp,16
 a9c:	8082                	ret

0000000000000a9e <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
u8 compare_str_ic(const u8 * s1 , const u8 * s2){
 a9e:	1141                	addi	sp,sp,-16
 aa0:	e422                	sd	s0,8(sp)
 aa2:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		u8 b1 = *s1++;
		u8 b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 aa4:	4665                	li	a2,25
	while(*s1 && *s2){
 aa6:	a019                	j	aac <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 aa8:	04e79763          	bne	a5,a4,af6 <compare_str_ic+0x58>
	while(*s1 && *s2){
 aac:	00054783          	lbu	a5,0(a0)
 ab0:	cb9d                	beqz	a5,ae6 <compare_str_ic+0x48>
 ab2:	0005c703          	lbu	a4,0(a1)
 ab6:	cb05                	beqz	a4,ae6 <compare_str_ic+0x48>
		u8 b1 = *s1++;
 ab8:	0505                	addi	a0,a0,1
		u8 b2 = *s2++;
 aba:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 abc:	fbf7869b          	addiw	a3,a5,-65
 ac0:	0ff6f693          	zext.b	a3,a3
 ac4:	00d66663          	bltu	a2,a3,ad0 <compare_str_ic+0x32>
			b1 += 32;
 ac8:	0207879b          	addiw	a5,a5,32
 acc:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 ad0:	fbf7069b          	addiw	a3,a4,-65
 ad4:	0ff6f693          	zext.b	a3,a3
 ad8:	fcd668e3          	bltu	a2,a3,aa8 <compare_str_ic+0xa>
			b2 += 32;
 adc:	0207071b          	addiw	a4,a4,32
 ae0:	0ff77713          	zext.b	a4,a4
 ae4:	b7d1                	j	aa8 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 ae6:	0005c503          	lbu	a0,0(a1)
 aea:	8d1d                	sub	a0,a0,a5
			return 1;
 aec:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 af0:	6422                	ld	s0,8(sp)
 af2:	0141                	addi	sp,sp,16
 af4:	8082                	ret
			return 1;
 af6:	4505                	li	a0,1
 af8:	bfe5                	j	af0 <compare_str_ic+0x52>
