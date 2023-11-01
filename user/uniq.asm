
user/_uniq:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
static char ** parse_cmd(int argc, char ** cmd, char * options, char * runInKernel);




int main(int argc, char ** argv){
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
  18:	e06a                	sd	s10,0(sp)
  1a:	1080                	addi	s0,sp,96
  1c:	892e                	mv	s2,a1
*/
static char ** parse_cmd(int argc, char ** cmd, char * options, char * runInKernel){


	/* Total number of files is maximum argc-1 requiring argc size storage for the last NULL*/
	char ** passedFiles = malloc(sizeof(char *) * (argc));
  1e:	0035151b          	slliw	a0,a0,0x3
  22:	00001097          	auipc	ra,0x1
  26:	884080e7          	jalr	-1916(ra) # 8a6 <malloc>

	if (!passedFiles)
  2a:	14050163          	beqz	a0,16c <main+0x16c>
  2e:	89aa                	mv	s3,a0


	*options = 0;
	int fileIdx = 0;

	cmd++;  // Skipping the program's name
  30:	00890493          	addi	s1,s2,8
	
	while(*cmd){
  34:	00893503          	ld	a0,8(s2)
  38:	c551                	beqz	a0,c4 <main+0xc4>
	char runInKernel = 0;
  3a:	4b01                	li	s6,0
	*options = 0;
  3c:	4901                	li	s2,0
	int fileIdx = 0;
  3e:	4c01                	li	s8,0
		if (!compare_str(cmd[0], "-c"))
  40:	00001a17          	auipc	s4,0x1
  44:	df0a0a13          	addi	s4,s4,-528 # e30 <get_time_perf+0x60>
			*options |= OPT_SHOW_COUNT;
		else if (!compare_str(cmd[0], "-i"))
  48:	00001a97          	auipc	s5,0x1
  4c:	df0a8a93          	addi	s5,s5,-528 # e38 <get_time_perf+0x68>
			*options |= OPT_IGNORE_CASE;
		else if (!compare_str(cmd[0], "-d"))
  50:	00001b97          	auipc	s7,0x1
  54:	df0b8b93          	addi	s7,s7,-528 # e40 <get_time_perf+0x70>
			*options |= OPT_SHOW_REPEATED_LINES;
		else if (!compare_str(cmd[0], "-k"))
  58:	00001c97          	auipc	s9,0x1
  5c:	df0c8c93          	addi	s9,s9,-528 # e48 <get_time_perf+0x78>
			*runInKernel=1;
  60:	4d05                	li	s10,1
  62:	a039                	j	70 <main+0x70>
			*options |= OPT_SHOW_COUNT;
  64:	00296913          	ori	s2,s2,2
		else
			passedFiles[fileIdx++] = cmd[0];
			
		cmd++;
  68:	04a1                	addi	s1,s1,8
	while(*cmd){
  6a:	6088                	ld	a0,0(s1)
  6c:	10050a63          	beqz	a0,180 <main+0x180>
		if (!compare_str(cmd[0], "-c"))
  70:	85d2                	mv	a1,s4
  72:	00001097          	auipc	ra,0x1
  76:	bc6080e7          	jalr	-1082(ra) # c38 <compare_str>
  7a:	d56d                	beqz	a0,64 <main+0x64>
		else if (!compare_str(cmd[0], "-i"))
  7c:	85d6                	mv	a1,s5
  7e:	6088                	ld	a0,0(s1)
  80:	00001097          	auipc	ra,0x1
  84:	bb8080e7          	jalr	-1096(ra) # c38 <compare_str>
  88:	e501                	bnez	a0,90 <main+0x90>
			*options |= OPT_IGNORE_CASE;
  8a:	00196913          	ori	s2,s2,1
  8e:	bfe9                	j	68 <main+0x68>
		else if (!compare_str(cmd[0], "-d"))
  90:	85de                	mv	a1,s7
  92:	6088                	ld	a0,0(s1)
  94:	00001097          	auipc	ra,0x1
  98:	ba4080e7          	jalr	-1116(ra) # c38 <compare_str>
  9c:	e501                	bnez	a0,a4 <main+0xa4>
			*options |= OPT_SHOW_REPEATED_LINES;
  9e:	00496913          	ori	s2,s2,4
  a2:	b7d9                	j	68 <main+0x68>
		else if (!compare_str(cmd[0], "-k"))
  a4:	85e6                	mv	a1,s9
  a6:	6088                	ld	a0,0(s1)
  a8:	00001097          	auipc	ra,0x1
  ac:	b90080e7          	jalr	-1136(ra) # c38 <compare_str>
  b0:	c901                	beqz	a0,c0 <main+0xc0>
			passedFiles[fileIdx++] = cmd[0];
  b2:	6098                	ld	a4,0(s1)
  b4:	003c1793          	slli	a5,s8,0x3
  b8:	97ce                	add	a5,a5,s3
  ba:	e398                	sd	a4,0(a5)
  bc:	2c05                	addiw	s8,s8,1
  be:	b76d                	j	68 <main+0x68>
			*runInKernel=1;
  c0:	8b6a                	mv	s6,s10
  c2:	b75d                	j	68 <main+0x68>
	*options = 0;
  c4:	4901                	li	s2,0
	printf("Uniq command is getting executed in user mode\n");
  c6:	00001517          	auipc	a0,0x1
  ca:	d8a50513          	addi	a0,a0,-630 # e50 <get_time_perf+0x80>
  ce:	00000097          	auipc	ra,0x0
  d2:	720080e7          	jalr	1824(ra) # 7ee <printf>
	while(*files++){numOfFiles++;};
  d6:	00898793          	addi	a5,s3,8
  da:	0009b503          	ld	a0,0(s3)
  de:	c935                	beqz	a0,152 <main+0x152>
	int numOfFiles=0;
  e0:	4a01                	li	s4,0
	while(*files++){numOfFiles++;};
  e2:	2a05                	addiw	s4,s4,1
  e4:	07a1                	addi	a5,a5,8
  e6:	ff87b703          	ld	a4,-8(a5)
  ea:	ff65                	bnez	a4,e2 <main+0xe2>
			if (fd == OPEN_FILE_ERROR)
  ec:	5afd                	li	s5,-1
				if (numOfFiles > 1) 
  ee:	4c05                	li	s8,1
				uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
  f0:	00497b93          	andi	s7,s2,4
  f4:	00297b13          	andi	s6,s2,2
  f8:	00197913          	andi	s2,s2,1
  fc:	a081                	j	13c <main+0x13c>
				printf("[ERR] Error opening the file \n");
  fe:	00001517          	auipc	a0,0x1
 102:	d8250513          	addi	a0,a0,-638 # e80 <get_time_perf+0xb0>
 106:	00000097          	auipc	ra,0x0
 10a:	6e8080e7          	jalr	1768(ra) # 7ee <printf>
 10e:	a01d                	j	134 <main+0x134>
					printf("==> %s <==\n",*passedFiles);
 110:	0009b583          	ld	a1,0(s3)
 114:	00001517          	auipc	a0,0x1
 118:	d8c50513          	addi	a0,a0,-628 # ea0 <get_time_perf+0xd0>
 11c:	00000097          	auipc	ra,0x0
 120:	6d2080e7          	jalr	1746(ra) # 7ee <printf>
				uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
 124:	86de                	mv	a3,s7
 126:	865a                	mv	a2,s6
 128:	85ca                	mv	a1,s2
 12a:	8526                	mv	a0,s1
 12c:	00001097          	auipc	ra,0x1
 130:	8e8080e7          	jalr	-1816(ra) # a14 <uniq_run>
			passedFiles++;
 134:	09a1                	addi	s3,s3,8
		while (*passedFiles){
 136:	0009b503          	ld	a0,0(s3)
 13a:	cd21                	beqz	a0,192 <main+0x192>
			int fd = open_file(*passedFiles, RDONLY);
 13c:	4581                	li	a1,0
 13e:	00001097          	auipc	ra,0x1
 142:	c00080e7          	jalr	-1024(ra) # d3e <open_file>
 146:	84aa                	mv	s1,a0
			if (fd == OPEN_FILE_ERROR)
 148:	fb550be3          	beq	a0,s5,fe <main+0xfe>
				if (numOfFiles > 1) 
 14c:	fd4c5ce3          	bge	s8,s4,124 <main+0x124>
 150:	b7c1                	j	110 <main+0x110>
		uniq_run(STDIN, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
 152:	00497693          	andi	a3,s2,4
 156:	00297613          	andi	a2,s2,2
 15a:	00197593          	andi	a1,s2,1
 15e:	4501                	li	a0,0
 160:	00001097          	auipc	ra,0x1
 164:	8b4080e7          	jalr	-1868(ra) # a14 <uniq_run>
	return 0;
 168:	4501                	li	a0,0
 16a:	a025                	j	192 <main+0x192>
		printf("[ERR] Cannot parse the cmd");
 16c:	00001517          	auipc	a0,0x1
 170:	d4450513          	addi	a0,a0,-700 # eb0 <get_time_perf+0xe0>
 174:	00000097          	auipc	ra,0x0
 178:	67a080e7          	jalr	1658(ra) # 7ee <printf>
		return 1;
 17c:	4505                	li	a0,1
 17e:	a811                	j	192 <main+0x192>
	if (runInKernel)
 180:	f40b03e3          	beqz	s6,c6 <main+0xc6>
		uniq(passedFiles,options);
 184:	85ca                	mv	a1,s2
 186:	854e                	mv	a0,s3
 188:	00000097          	auipc	ra,0x0
 18c:	354080e7          	jalr	852(ra) # 4dc <uniq>
	return 0;
 190:	4501                	li	a0,0
}
 192:	60e6                	ld	ra,88(sp)
 194:	6446                	ld	s0,80(sp)
 196:	64a6                	ld	s1,72(sp)
 198:	6906                	ld	s2,64(sp)
 19a:	79e2                	ld	s3,56(sp)
 19c:	7a42                	ld	s4,48(sp)
 19e:	7aa2                	ld	s5,40(sp)
 1a0:	7b02                	ld	s6,32(sp)
 1a2:	6be2                	ld	s7,24(sp)
 1a4:	6c42                	ld	s8,16(sp)
 1a6:	6ca2                	ld	s9,8(sp)
 1a8:	6d02                	ld	s10,0(sp)
 1aa:	6125                	addi	sp,sp,96
 1ac:	8082                	ret

00000000000001ae <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e406                	sd	ra,8(sp)
 1b2:	e022                	sd	s0,0(sp)
 1b4:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1b6:	00000097          	auipc	ra,0x0
 1ba:	e4a080e7          	jalr	-438(ra) # 0 <main>
  exit(0);
 1be:	4501                	li	a0,0
 1c0:	00000097          	auipc	ra,0x0
 1c4:	274080e7          	jalr	628(ra) # 434 <exit>

00000000000001c8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ce:	87aa                	mv	a5,a0
 1d0:	0585                	addi	a1,a1,1
 1d2:	0785                	addi	a5,a5,1
 1d4:	fff5c703          	lbu	a4,-1(a1)
 1d8:	fee78fa3          	sb	a4,-1(a5)
 1dc:	fb75                	bnez	a4,1d0 <strcpy+0x8>
    ;
  return os;
}
 1de:	6422                	ld	s0,8(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret

00000000000001e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1ea:	00054783          	lbu	a5,0(a0)
 1ee:	cb91                	beqz	a5,202 <strcmp+0x1e>
 1f0:	0005c703          	lbu	a4,0(a1)
 1f4:	00f71763          	bne	a4,a5,202 <strcmp+0x1e>
    p++, q++;
 1f8:	0505                	addi	a0,a0,1
 1fa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1fc:	00054783          	lbu	a5,0(a0)
 200:	fbe5                	bnez	a5,1f0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 202:	0005c503          	lbu	a0,0(a1)
}
 206:	40a7853b          	subw	a0,a5,a0
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret

0000000000000210 <strlen>:

uint
strlen(const char *s)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 216:	00054783          	lbu	a5,0(a0)
 21a:	cf91                	beqz	a5,236 <strlen+0x26>
 21c:	0505                	addi	a0,a0,1
 21e:	87aa                	mv	a5,a0
 220:	4685                	li	a3,1
 222:	9e89                	subw	a3,a3,a0
 224:	00f6853b          	addw	a0,a3,a5
 228:	0785                	addi	a5,a5,1
 22a:	fff7c703          	lbu	a4,-1(a5)
 22e:	fb7d                	bnez	a4,224 <strlen+0x14>
    ;
  return n;
}
 230:	6422                	ld	s0,8(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
  for(n = 0; s[n]; n++)
 236:	4501                	li	a0,0
 238:	bfe5                	j	230 <strlen+0x20>

000000000000023a <memset>:

void*
memset(void *dst, int c, uint n)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 240:	ca19                	beqz	a2,256 <memset+0x1c>
 242:	87aa                	mv	a5,a0
 244:	1602                	slli	a2,a2,0x20
 246:	9201                	srli	a2,a2,0x20
 248:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 24c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 250:	0785                	addi	a5,a5,1
 252:	fee79de3          	bne	a5,a4,24c <memset+0x12>
  }
  return dst;
}
 256:	6422                	ld	s0,8(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret

000000000000025c <strchr>:

char*
strchr(const char *s, char c)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  for(; *s; s++)
 262:	00054783          	lbu	a5,0(a0)
 266:	cb99                	beqz	a5,27c <strchr+0x20>
    if(*s == c)
 268:	00f58763          	beq	a1,a5,276 <strchr+0x1a>
  for(; *s; s++)
 26c:	0505                	addi	a0,a0,1
 26e:	00054783          	lbu	a5,0(a0)
 272:	fbfd                	bnez	a5,268 <strchr+0xc>
      return (char*)s;
  return 0;
 274:	4501                	li	a0,0
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
  return 0;
 27c:	4501                	li	a0,0
 27e:	bfe5                	j	276 <strchr+0x1a>

0000000000000280 <gets>:

char*
gets(char *buf, int max)
{
 280:	711d                	addi	sp,sp,-96
 282:	ec86                	sd	ra,88(sp)
 284:	e8a2                	sd	s0,80(sp)
 286:	e4a6                	sd	s1,72(sp)
 288:	e0ca                	sd	s2,64(sp)
 28a:	fc4e                	sd	s3,56(sp)
 28c:	f852                	sd	s4,48(sp)
 28e:	f456                	sd	s5,40(sp)
 290:	f05a                	sd	s6,32(sp)
 292:	ec5e                	sd	s7,24(sp)
 294:	1080                	addi	s0,sp,96
 296:	8baa                	mv	s7,a0
 298:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 29a:	892a                	mv	s2,a0
 29c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 29e:	4aa9                	li	s5,10
 2a0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2a2:	89a6                	mv	s3,s1
 2a4:	2485                	addiw	s1,s1,1
 2a6:	0344d863          	bge	s1,s4,2d6 <gets+0x56>
    cc = read(0, &c, 1);
 2aa:	4605                	li	a2,1
 2ac:	faf40593          	addi	a1,s0,-81
 2b0:	4501                	li	a0,0
 2b2:	00000097          	auipc	ra,0x0
 2b6:	19a080e7          	jalr	410(ra) # 44c <read>
    if(cc < 1)
 2ba:	00a05e63          	blez	a0,2d6 <gets+0x56>
    buf[i++] = c;
 2be:	faf44783          	lbu	a5,-81(s0)
 2c2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2c6:	01578763          	beq	a5,s5,2d4 <gets+0x54>
 2ca:	0905                	addi	s2,s2,1
 2cc:	fd679be3          	bne	a5,s6,2a2 <gets+0x22>
  for(i=0; i+1 < max; ){
 2d0:	89a6                	mv	s3,s1
 2d2:	a011                	j	2d6 <gets+0x56>
 2d4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2d6:	99de                	add	s3,s3,s7
 2d8:	00098023          	sb	zero,0(s3)
  return buf;
}
 2dc:	855e                	mv	a0,s7
 2de:	60e6                	ld	ra,88(sp)
 2e0:	6446                	ld	s0,80(sp)
 2e2:	64a6                	ld	s1,72(sp)
 2e4:	6906                	ld	s2,64(sp)
 2e6:	79e2                	ld	s3,56(sp)
 2e8:	7a42                	ld	s4,48(sp)
 2ea:	7aa2                	ld	s5,40(sp)
 2ec:	7b02                	ld	s6,32(sp)
 2ee:	6be2                	ld	s7,24(sp)
 2f0:	6125                	addi	sp,sp,96
 2f2:	8082                	ret

00000000000002f4 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f4:	1101                	addi	sp,sp,-32
 2f6:	ec06                	sd	ra,24(sp)
 2f8:	e822                	sd	s0,16(sp)
 2fa:	e426                	sd	s1,8(sp)
 2fc:	e04a                	sd	s2,0(sp)
 2fe:	1000                	addi	s0,sp,32
 300:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 302:	4581                	li	a1,0
 304:	00000097          	auipc	ra,0x0
 308:	170080e7          	jalr	368(ra) # 474 <open>
  if(fd < 0)
 30c:	02054563          	bltz	a0,336 <stat+0x42>
 310:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 312:	85ca                	mv	a1,s2
 314:	00000097          	auipc	ra,0x0
 318:	178080e7          	jalr	376(ra) # 48c <fstat>
 31c:	892a                	mv	s2,a0
  close(fd);
 31e:	8526                	mv	a0,s1
 320:	00000097          	auipc	ra,0x0
 324:	13c080e7          	jalr	316(ra) # 45c <close>
  return r;
}
 328:	854a                	mv	a0,s2
 32a:	60e2                	ld	ra,24(sp)
 32c:	6442                	ld	s0,16(sp)
 32e:	64a2                	ld	s1,8(sp)
 330:	6902                	ld	s2,0(sp)
 332:	6105                	addi	sp,sp,32
 334:	8082                	ret
    return -1;
 336:	597d                	li	s2,-1
 338:	bfc5                	j	328 <stat+0x34>

000000000000033a <atoi>:

int
atoi(const char *s)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 340:	00054683          	lbu	a3,0(a0)
 344:	fd06879b          	addiw	a5,a3,-48
 348:	0ff7f793          	zext.b	a5,a5
 34c:	4625                	li	a2,9
 34e:	02f66863          	bltu	a2,a5,37e <atoi+0x44>
 352:	872a                	mv	a4,a0
  n = 0;
 354:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 356:	0705                	addi	a4,a4,1
 358:	0025179b          	slliw	a5,a0,0x2
 35c:	9fa9                	addw	a5,a5,a0
 35e:	0017979b          	slliw	a5,a5,0x1
 362:	9fb5                	addw	a5,a5,a3
 364:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 368:	00074683          	lbu	a3,0(a4)
 36c:	fd06879b          	addiw	a5,a3,-48
 370:	0ff7f793          	zext.b	a5,a5
 374:	fef671e3          	bgeu	a2,a5,356 <atoi+0x1c>
  return n;
}
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
  n = 0;
 37e:	4501                	li	a0,0
 380:	bfe5                	j	378 <atoi+0x3e>

0000000000000382 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 382:	1141                	addi	sp,sp,-16
 384:	e422                	sd	s0,8(sp)
 386:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 388:	02b57463          	bgeu	a0,a1,3b0 <memmove+0x2e>
    while(n-- > 0)
 38c:	00c05f63          	blez	a2,3aa <memmove+0x28>
 390:	1602                	slli	a2,a2,0x20
 392:	9201                	srli	a2,a2,0x20
 394:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 398:	872a                	mv	a4,a0
      *dst++ = *src++;
 39a:	0585                	addi	a1,a1,1
 39c:	0705                	addi	a4,a4,1
 39e:	fff5c683          	lbu	a3,-1(a1)
 3a2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3a6:	fee79ae3          	bne	a5,a4,39a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3aa:	6422                	ld	s0,8(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret
    dst += n;
 3b0:	00c50733          	add	a4,a0,a2
    src += n;
 3b4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3b6:	fec05ae3          	blez	a2,3aa <memmove+0x28>
 3ba:	fff6079b          	addiw	a5,a2,-1
 3be:	1782                	slli	a5,a5,0x20
 3c0:	9381                	srli	a5,a5,0x20
 3c2:	fff7c793          	not	a5,a5
 3c6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3c8:	15fd                	addi	a1,a1,-1
 3ca:	177d                	addi	a4,a4,-1
 3cc:	0005c683          	lbu	a3,0(a1)
 3d0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3d4:	fee79ae3          	bne	a5,a4,3c8 <memmove+0x46>
 3d8:	bfc9                	j	3aa <memmove+0x28>

00000000000003da <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3da:	1141                	addi	sp,sp,-16
 3dc:	e422                	sd	s0,8(sp)
 3de:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3e0:	ca05                	beqz	a2,410 <memcmp+0x36>
 3e2:	fff6069b          	addiw	a3,a2,-1
 3e6:	1682                	slli	a3,a3,0x20
 3e8:	9281                	srli	a3,a3,0x20
 3ea:	0685                	addi	a3,a3,1
 3ec:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ee:	00054783          	lbu	a5,0(a0)
 3f2:	0005c703          	lbu	a4,0(a1)
 3f6:	00e79863          	bne	a5,a4,406 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3fa:	0505                	addi	a0,a0,1
    p2++;
 3fc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3fe:	fed518e3          	bne	a0,a3,3ee <memcmp+0x14>
  }
  return 0;
 402:	4501                	li	a0,0
 404:	a019                	j	40a <memcmp+0x30>
      return *p1 - *p2;
 406:	40e7853b          	subw	a0,a5,a4
}
 40a:	6422                	ld	s0,8(sp)
 40c:	0141                	addi	sp,sp,16
 40e:	8082                	ret
  return 0;
 410:	4501                	li	a0,0
 412:	bfe5                	j	40a <memcmp+0x30>

0000000000000414 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 414:	1141                	addi	sp,sp,-16
 416:	e406                	sd	ra,8(sp)
 418:	e022                	sd	s0,0(sp)
 41a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 41c:	00000097          	auipc	ra,0x0
 420:	f66080e7          	jalr	-154(ra) # 382 <memmove>
}
 424:	60a2                	ld	ra,8(sp)
 426:	6402                	ld	s0,0(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret

000000000000042c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 42c:	4885                	li	a7,1
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <exit>:
.global exit
exit:
 li a7, SYS_exit
 434:	4889                	li	a7,2
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <wait>:
.global wait
wait:
 li a7, SYS_wait
 43c:	488d                	li	a7,3
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 444:	4891                	li	a7,4
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <read>:
.global read
read:
 li a7, SYS_read
 44c:	4895                	li	a7,5
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <write>:
.global write
write:
 li a7, SYS_write
 454:	48c1                	li	a7,16
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <close>:
.global close
close:
 li a7, SYS_close
 45c:	48d5                	li	a7,21
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <kill>:
.global kill
kill:
 li a7, SYS_kill
 464:	4899                	li	a7,6
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <exec>:
.global exec
exec:
 li a7, SYS_exec
 46c:	489d                	li	a7,7
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <open>:
.global open
open:
 li a7, SYS_open
 474:	48bd                	li	a7,15
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 47c:	48c5                	li	a7,17
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 484:	48c9                	li	a7,18
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 48c:	48a1                	li	a7,8
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <link>:
.global link
link:
 li a7, SYS_link
 494:	48cd                	li	a7,19
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 49c:	48d1                	li	a7,20
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4a4:	48a5                	li	a7,9
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ac:	48a9                	li	a7,10
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4b4:	48ad                	li	a7,11
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4bc:	48b1                	li	a7,12
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4c4:	48b5                	li	a7,13
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4cc:	48b9                	li	a7,14
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <head>:
.global head
head:
 li a7, SYS_head
 4d4:	48d9                	li	a7,22
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 4dc:	48dd                	li	a7,23
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <ps>:
.global ps
ps:
 li a7, SYS_ps
 4e4:	48e1                	li	a7,24
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <times>:
.global times
times:
 li a7, SYS_times
 4ec:	48e5                	li	a7,25
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 4f4:	48e9                	li	a7,26
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 4fc:	48ed                	li	a7,27
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 504:	48f1                	li	a7,28
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 50c:	48f5                	li	a7,29
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 514:	1101                	addi	sp,sp,-32
 516:	ec06                	sd	ra,24(sp)
 518:	e822                	sd	s0,16(sp)
 51a:	1000                	addi	s0,sp,32
 51c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 520:	4605                	li	a2,1
 522:	fef40593          	addi	a1,s0,-17
 526:	00000097          	auipc	ra,0x0
 52a:	f2e080e7          	jalr	-210(ra) # 454 <write>
}
 52e:	60e2                	ld	ra,24(sp)
 530:	6442                	ld	s0,16(sp)
 532:	6105                	addi	sp,sp,32
 534:	8082                	ret

0000000000000536 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 536:	7139                	addi	sp,sp,-64
 538:	fc06                	sd	ra,56(sp)
 53a:	f822                	sd	s0,48(sp)
 53c:	f426                	sd	s1,40(sp)
 53e:	f04a                	sd	s2,32(sp)
 540:	ec4e                	sd	s3,24(sp)
 542:	0080                	addi	s0,sp,64
 544:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 546:	c299                	beqz	a3,54c <printint+0x16>
 548:	0805c963          	bltz	a1,5da <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 54c:	2581                	sext.w	a1,a1
  neg = 0;
 54e:	4881                	li	a7,0
 550:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 554:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 556:	2601                	sext.w	a2,a2
 558:	00001517          	auipc	a0,0x1
 55c:	9d850513          	addi	a0,a0,-1576 # f30 <digits>
 560:	883a                	mv	a6,a4
 562:	2705                	addiw	a4,a4,1
 564:	02c5f7bb          	remuw	a5,a1,a2
 568:	1782                	slli	a5,a5,0x20
 56a:	9381                	srli	a5,a5,0x20
 56c:	97aa                	add	a5,a5,a0
 56e:	0007c783          	lbu	a5,0(a5)
 572:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 576:	0005879b          	sext.w	a5,a1
 57a:	02c5d5bb          	divuw	a1,a1,a2
 57e:	0685                	addi	a3,a3,1
 580:	fec7f0e3          	bgeu	a5,a2,560 <printint+0x2a>
  if(neg)
 584:	00088c63          	beqz	a7,59c <printint+0x66>
    buf[i++] = '-';
 588:	fd070793          	addi	a5,a4,-48
 58c:	00878733          	add	a4,a5,s0
 590:	02d00793          	li	a5,45
 594:	fef70823          	sb	a5,-16(a4)
 598:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 59c:	02e05863          	blez	a4,5cc <printint+0x96>
 5a0:	fc040793          	addi	a5,s0,-64
 5a4:	00e78933          	add	s2,a5,a4
 5a8:	fff78993          	addi	s3,a5,-1
 5ac:	99ba                	add	s3,s3,a4
 5ae:	377d                	addiw	a4,a4,-1
 5b0:	1702                	slli	a4,a4,0x20
 5b2:	9301                	srli	a4,a4,0x20
 5b4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5b8:	fff94583          	lbu	a1,-1(s2)
 5bc:	8526                	mv	a0,s1
 5be:	00000097          	auipc	ra,0x0
 5c2:	f56080e7          	jalr	-170(ra) # 514 <putc>
  while(--i >= 0)
 5c6:	197d                	addi	s2,s2,-1
 5c8:	ff3918e3          	bne	s2,s3,5b8 <printint+0x82>
}
 5cc:	70e2                	ld	ra,56(sp)
 5ce:	7442                	ld	s0,48(sp)
 5d0:	74a2                	ld	s1,40(sp)
 5d2:	7902                	ld	s2,32(sp)
 5d4:	69e2                	ld	s3,24(sp)
 5d6:	6121                	addi	sp,sp,64
 5d8:	8082                	ret
    x = -xx;
 5da:	40b005bb          	negw	a1,a1
    neg = 1;
 5de:	4885                	li	a7,1
    x = -xx;
 5e0:	bf85                	j	550 <printint+0x1a>

00000000000005e2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5e2:	7119                	addi	sp,sp,-128
 5e4:	fc86                	sd	ra,120(sp)
 5e6:	f8a2                	sd	s0,112(sp)
 5e8:	f4a6                	sd	s1,104(sp)
 5ea:	f0ca                	sd	s2,96(sp)
 5ec:	ecce                	sd	s3,88(sp)
 5ee:	e8d2                	sd	s4,80(sp)
 5f0:	e4d6                	sd	s5,72(sp)
 5f2:	e0da                	sd	s6,64(sp)
 5f4:	fc5e                	sd	s7,56(sp)
 5f6:	f862                	sd	s8,48(sp)
 5f8:	f466                	sd	s9,40(sp)
 5fa:	f06a                	sd	s10,32(sp)
 5fc:	ec6e                	sd	s11,24(sp)
 5fe:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 600:	0005c903          	lbu	s2,0(a1)
 604:	18090f63          	beqz	s2,7a2 <vprintf+0x1c0>
 608:	8aaa                	mv	s5,a0
 60a:	8b32                	mv	s6,a2
 60c:	00158493          	addi	s1,a1,1
  state = 0;
 610:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 612:	02500a13          	li	s4,37
 616:	4c55                	li	s8,21
 618:	00001c97          	auipc	s9,0x1
 61c:	8c0c8c93          	addi	s9,s9,-1856 # ed8 <get_time_perf+0x108>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 620:	02800d93          	li	s11,40
  putc(fd, 'x');
 624:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 626:	00001b97          	auipc	s7,0x1
 62a:	90ab8b93          	addi	s7,s7,-1782 # f30 <digits>
 62e:	a839                	j	64c <vprintf+0x6a>
        putc(fd, c);
 630:	85ca                	mv	a1,s2
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	ee0080e7          	jalr	-288(ra) # 514 <putc>
 63c:	a019                	j	642 <vprintf+0x60>
    } else if(state == '%'){
 63e:	01498d63          	beq	s3,s4,658 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 642:	0485                	addi	s1,s1,1
 644:	fff4c903          	lbu	s2,-1(s1)
 648:	14090d63          	beqz	s2,7a2 <vprintf+0x1c0>
    if(state == 0){
 64c:	fe0999e3          	bnez	s3,63e <vprintf+0x5c>
      if(c == '%'){
 650:	ff4910e3          	bne	s2,s4,630 <vprintf+0x4e>
        state = '%';
 654:	89d2                	mv	s3,s4
 656:	b7f5                	j	642 <vprintf+0x60>
      if(c == 'd'){
 658:	11490c63          	beq	s2,s4,770 <vprintf+0x18e>
 65c:	f9d9079b          	addiw	a5,s2,-99
 660:	0ff7f793          	zext.b	a5,a5
 664:	10fc6e63          	bltu	s8,a5,780 <vprintf+0x19e>
 668:	f9d9079b          	addiw	a5,s2,-99
 66c:	0ff7f713          	zext.b	a4,a5
 670:	10ec6863          	bltu	s8,a4,780 <vprintf+0x19e>
 674:	00271793          	slli	a5,a4,0x2
 678:	97e6                	add	a5,a5,s9
 67a:	439c                	lw	a5,0(a5)
 67c:	97e6                	add	a5,a5,s9
 67e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 680:	008b0913          	addi	s2,s6,8
 684:	4685                	li	a3,1
 686:	4629                	li	a2,10
 688:	000b2583          	lw	a1,0(s6)
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	ea8080e7          	jalr	-344(ra) # 536 <printint>
 696:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 698:	4981                	li	s3,0
 69a:	b765                	j	642 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	008b0913          	addi	s2,s6,8
 6a0:	4681                	li	a3,0
 6a2:	4629                	li	a2,10
 6a4:	000b2583          	lw	a1,0(s6)
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	e8c080e7          	jalr	-372(ra) # 536 <printint>
 6b2:	8b4a                	mv	s6,s2
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b771                	j	642 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6b8:	008b0913          	addi	s2,s6,8
 6bc:	4681                	li	a3,0
 6be:	866a                	mv	a2,s10
 6c0:	000b2583          	lw	a1,0(s6)
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	e70080e7          	jalr	-400(ra) # 536 <printint>
 6ce:	8b4a                	mv	s6,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bf85                	j	642 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6d4:	008b0793          	addi	a5,s6,8
 6d8:	f8f43423          	sd	a5,-120(s0)
 6dc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6e0:	03000593          	li	a1,48
 6e4:	8556                	mv	a0,s5
 6e6:	00000097          	auipc	ra,0x0
 6ea:	e2e080e7          	jalr	-466(ra) # 514 <putc>
  putc(fd, 'x');
 6ee:	07800593          	li	a1,120
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	e20080e7          	jalr	-480(ra) # 514 <putc>
 6fc:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fe:	03c9d793          	srli	a5,s3,0x3c
 702:	97de                	add	a5,a5,s7
 704:	0007c583          	lbu	a1,0(a5)
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	e0a080e7          	jalr	-502(ra) # 514 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 712:	0992                	slli	s3,s3,0x4
 714:	397d                	addiw	s2,s2,-1
 716:	fe0914e3          	bnez	s2,6fe <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 71a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 71e:	4981                	li	s3,0
 720:	b70d                	j	642 <vprintf+0x60>
        s = va_arg(ap, char*);
 722:	008b0913          	addi	s2,s6,8
 726:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 72a:	02098163          	beqz	s3,74c <vprintf+0x16a>
        while(*s != 0){
 72e:	0009c583          	lbu	a1,0(s3)
 732:	c5ad                	beqz	a1,79c <vprintf+0x1ba>
          putc(fd, *s);
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	dde080e7          	jalr	-546(ra) # 514 <putc>
          s++;
 73e:	0985                	addi	s3,s3,1
        while(*s != 0){
 740:	0009c583          	lbu	a1,0(s3)
 744:	f9e5                	bnez	a1,734 <vprintf+0x152>
        s = va_arg(ap, char*);
 746:	8b4a                	mv	s6,s2
      state = 0;
 748:	4981                	li	s3,0
 74a:	bde5                	j	642 <vprintf+0x60>
          s = "(null)";
 74c:	00000997          	auipc	s3,0x0
 750:	78498993          	addi	s3,s3,1924 # ed0 <get_time_perf+0x100>
        while(*s != 0){
 754:	85ee                	mv	a1,s11
 756:	bff9                	j	734 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 758:	008b0913          	addi	s2,s6,8
 75c:	000b4583          	lbu	a1,0(s6)
 760:	8556                	mv	a0,s5
 762:	00000097          	auipc	ra,0x0
 766:	db2080e7          	jalr	-590(ra) # 514 <putc>
 76a:	8b4a                	mv	s6,s2
      state = 0;
 76c:	4981                	li	s3,0
 76e:	bdd1                	j	642 <vprintf+0x60>
        putc(fd, c);
 770:	85d2                	mv	a1,s4
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	da0080e7          	jalr	-608(ra) # 514 <putc>
      state = 0;
 77c:	4981                	li	s3,0
 77e:	b5d1                	j	642 <vprintf+0x60>
        putc(fd, '%');
 780:	85d2                	mv	a1,s4
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	d90080e7          	jalr	-624(ra) # 514 <putc>
        putc(fd, c);
 78c:	85ca                	mv	a1,s2
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	d84080e7          	jalr	-636(ra) # 514 <putc>
      state = 0;
 798:	4981                	li	s3,0
 79a:	b565                	j	642 <vprintf+0x60>
        s = va_arg(ap, char*);
 79c:	8b4a                	mv	s6,s2
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	b54d                	j	642 <vprintf+0x60>
    }
  }
}
 7a2:	70e6                	ld	ra,120(sp)
 7a4:	7446                	ld	s0,112(sp)
 7a6:	74a6                	ld	s1,104(sp)
 7a8:	7906                	ld	s2,96(sp)
 7aa:	69e6                	ld	s3,88(sp)
 7ac:	6a46                	ld	s4,80(sp)
 7ae:	6aa6                	ld	s5,72(sp)
 7b0:	6b06                	ld	s6,64(sp)
 7b2:	7be2                	ld	s7,56(sp)
 7b4:	7c42                	ld	s8,48(sp)
 7b6:	7ca2                	ld	s9,40(sp)
 7b8:	7d02                	ld	s10,32(sp)
 7ba:	6de2                	ld	s11,24(sp)
 7bc:	6109                	addi	sp,sp,128
 7be:	8082                	ret

00000000000007c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c0:	715d                	addi	sp,sp,-80
 7c2:	ec06                	sd	ra,24(sp)
 7c4:	e822                	sd	s0,16(sp)
 7c6:	1000                	addi	s0,sp,32
 7c8:	e010                	sd	a2,0(s0)
 7ca:	e414                	sd	a3,8(s0)
 7cc:	e818                	sd	a4,16(s0)
 7ce:	ec1c                	sd	a5,24(s0)
 7d0:	03043023          	sd	a6,32(s0)
 7d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7dc:	8622                	mv	a2,s0
 7de:	00000097          	auipc	ra,0x0
 7e2:	e04080e7          	jalr	-508(ra) # 5e2 <vprintf>
}
 7e6:	60e2                	ld	ra,24(sp)
 7e8:	6442                	ld	s0,16(sp)
 7ea:	6161                	addi	sp,sp,80
 7ec:	8082                	ret

00000000000007ee <printf>:

void
printf(const char *fmt, ...)
{
 7ee:	711d                	addi	sp,sp,-96
 7f0:	ec06                	sd	ra,24(sp)
 7f2:	e822                	sd	s0,16(sp)
 7f4:	1000                	addi	s0,sp,32
 7f6:	e40c                	sd	a1,8(s0)
 7f8:	e810                	sd	a2,16(s0)
 7fa:	ec14                	sd	a3,24(s0)
 7fc:	f018                	sd	a4,32(s0)
 7fe:	f41c                	sd	a5,40(s0)
 800:	03043823          	sd	a6,48(s0)
 804:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 808:	00840613          	addi	a2,s0,8
 80c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 810:	85aa                	mv	a1,a0
 812:	4505                	li	a0,1
 814:	00000097          	auipc	ra,0x0
 818:	dce080e7          	jalr	-562(ra) # 5e2 <vprintf>
}
 81c:	60e2                	ld	ra,24(sp)
 81e:	6442                	ld	s0,16(sp)
 820:	6125                	addi	sp,sp,96
 822:	8082                	ret

0000000000000824 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 824:	1141                	addi	sp,sp,-16
 826:	e422                	sd	s0,8(sp)
 828:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 82a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82e:	00000797          	auipc	a5,0x0
 832:	7d27b783          	ld	a5,2002(a5) # 1000 <freep>
 836:	a02d                	j	860 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 838:	4618                	lw	a4,8(a2)
 83a:	9f2d                	addw	a4,a4,a1
 83c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 840:	6398                	ld	a4,0(a5)
 842:	6310                	ld	a2,0(a4)
 844:	a83d                	j	882 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 846:	ff852703          	lw	a4,-8(a0)
 84a:	9f31                	addw	a4,a4,a2
 84c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 84e:	ff053683          	ld	a3,-16(a0)
 852:	a091                	j	896 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 854:	6398                	ld	a4,0(a5)
 856:	00e7e463          	bltu	a5,a4,85e <free+0x3a>
 85a:	00e6ea63          	bltu	a3,a4,86e <free+0x4a>
{
 85e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 860:	fed7fae3          	bgeu	a5,a3,854 <free+0x30>
 864:	6398                	ld	a4,0(a5)
 866:	00e6e463          	bltu	a3,a4,86e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86a:	fee7eae3          	bltu	a5,a4,85e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 86e:	ff852583          	lw	a1,-8(a0)
 872:	6390                	ld	a2,0(a5)
 874:	02059813          	slli	a6,a1,0x20
 878:	01c85713          	srli	a4,a6,0x1c
 87c:	9736                	add	a4,a4,a3
 87e:	fae60de3          	beq	a2,a4,838 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 882:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 886:	4790                	lw	a2,8(a5)
 888:	02061593          	slli	a1,a2,0x20
 88c:	01c5d713          	srli	a4,a1,0x1c
 890:	973e                	add	a4,a4,a5
 892:	fae68ae3          	beq	a3,a4,846 <free+0x22>
    p->s.ptr = bp->s.ptr;
 896:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 898:	00000717          	auipc	a4,0x0
 89c:	76f73423          	sd	a5,1896(a4) # 1000 <freep>
}
 8a0:	6422                	ld	s0,8(sp)
 8a2:	0141                	addi	sp,sp,16
 8a4:	8082                	ret

00000000000008a6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a6:	7139                	addi	sp,sp,-64
 8a8:	fc06                	sd	ra,56(sp)
 8aa:	f822                	sd	s0,48(sp)
 8ac:	f426                	sd	s1,40(sp)
 8ae:	f04a                	sd	s2,32(sp)
 8b0:	ec4e                	sd	s3,24(sp)
 8b2:	e852                	sd	s4,16(sp)
 8b4:	e456                	sd	s5,8(sp)
 8b6:	e05a                	sd	s6,0(sp)
 8b8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ba:	02051493          	slli	s1,a0,0x20
 8be:	9081                	srli	s1,s1,0x20
 8c0:	04bd                	addi	s1,s1,15
 8c2:	8091                	srli	s1,s1,0x4
 8c4:	0014899b          	addiw	s3,s1,1
 8c8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8ca:	00000517          	auipc	a0,0x0
 8ce:	73653503          	ld	a0,1846(a0) # 1000 <freep>
 8d2:	c515                	beqz	a0,8fe <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d6:	4798                	lw	a4,8(a5)
 8d8:	02977f63          	bgeu	a4,s1,916 <malloc+0x70>
 8dc:	8a4e                	mv	s4,s3
 8de:	0009871b          	sext.w	a4,s3
 8e2:	6685                	lui	a3,0x1
 8e4:	00d77363          	bgeu	a4,a3,8ea <malloc+0x44>
 8e8:	6a05                	lui	s4,0x1
 8ea:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ee:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f2:	00000917          	auipc	s2,0x0
 8f6:	70e90913          	addi	s2,s2,1806 # 1000 <freep>
  if(p == (char*)-1)
 8fa:	5afd                	li	s5,-1
 8fc:	a895                	j	970 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8fe:	00000797          	auipc	a5,0x0
 902:	71278793          	addi	a5,a5,1810 # 1010 <base>
 906:	00000717          	auipc	a4,0x0
 90a:	6ef73d23          	sd	a5,1786(a4) # 1000 <freep>
 90e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 910:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 914:	b7e1                	j	8dc <malloc+0x36>
      if(p->s.size == nunits)
 916:	02e48c63          	beq	s1,a4,94e <malloc+0xa8>
        p->s.size -= nunits;
 91a:	4137073b          	subw	a4,a4,s3
 91e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 920:	02071693          	slli	a3,a4,0x20
 924:	01c6d713          	srli	a4,a3,0x1c
 928:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 92a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92e:	00000717          	auipc	a4,0x0
 932:	6ca73923          	sd	a0,1746(a4) # 1000 <freep>
      return (void*)(p + 1);
 936:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 93a:	70e2                	ld	ra,56(sp)
 93c:	7442                	ld	s0,48(sp)
 93e:	74a2                	ld	s1,40(sp)
 940:	7902                	ld	s2,32(sp)
 942:	69e2                	ld	s3,24(sp)
 944:	6a42                	ld	s4,16(sp)
 946:	6aa2                	ld	s5,8(sp)
 948:	6b02                	ld	s6,0(sp)
 94a:	6121                	addi	sp,sp,64
 94c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 94e:	6398                	ld	a4,0(a5)
 950:	e118                	sd	a4,0(a0)
 952:	bff1                	j	92e <malloc+0x88>
  hp->s.size = nu;
 954:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 958:	0541                	addi	a0,a0,16
 95a:	00000097          	auipc	ra,0x0
 95e:	eca080e7          	jalr	-310(ra) # 824 <free>
  return freep;
 962:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 966:	d971                	beqz	a0,93a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96a:	4798                	lw	a4,8(a5)
 96c:	fa9775e3          	bgeu	a4,s1,916 <malloc+0x70>
    if(p == freep)
 970:	00093703          	ld	a4,0(s2)
 974:	853e                	mv	a0,a5
 976:	fef719e3          	bne	a4,a5,968 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 97a:	8552                	mv	a0,s4
 97c:	00000097          	auipc	ra,0x0
 980:	b40080e7          	jalr	-1216(ra) # 4bc <sbrk>
  if(p == (char*)-1)
 984:	fd5518e3          	bne	a0,s5,954 <malloc+0xae>
        return 0;
 988:	4501                	li	a0,0
 98a:	bf45                	j	93a <malloc+0x94>

000000000000098c <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 98c:	c1d9                	beqz	a1,a12 <head_run+0x86>
void head_run(int fd, int numOfLines){
 98e:	dd010113          	addi	sp,sp,-560
 992:	22113423          	sd	ra,552(sp)
 996:	22813023          	sd	s0,544(sp)
 99a:	20913c23          	sd	s1,536(sp)
 99e:	21213823          	sd	s2,528(sp)
 9a2:	21313423          	sd	s3,520(sp)
 9a6:	21413023          	sd	s4,512(sp)
 9aa:	1c00                	addi	s0,sp,560
 9ac:	892a                	mv	s2,a0
 9ae:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 9b2:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 9b4:	00000a17          	auipc	s4,0x0
 9b8:	5bca0a13          	addi	s4,s4,1468 # f70 <digits+0x40>
		readStatus = read_line(fd, line);
 9bc:	dd840593          	addi	a1,s0,-552
 9c0:	854a                	mv	a0,s2
 9c2:	00000097          	auipc	ra,0x0
 9c6:	394080e7          	jalr	916(ra) # d56 <read_line>
		if (readStatus == READ_ERROR){
 9ca:	01350d63          	beq	a0,s3,9e4 <head_run+0x58>
		if (readStatus == READ_EOF)
 9ce:	c11d                	beqz	a0,9f4 <head_run+0x68>
		printf("%s",line);
 9d0:	dd840593          	addi	a1,s0,-552
 9d4:	8552                	mv	a0,s4
 9d6:	00000097          	auipc	ra,0x0
 9da:	e18080e7          	jalr	-488(ra) # 7ee <printf>
	while(numOfLines--){
 9de:	34fd                	addiw	s1,s1,-1
 9e0:	fcf1                	bnez	s1,9bc <head_run+0x30>
 9e2:	a809                	j	9f4 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 9e4:	00000517          	auipc	a0,0x0
 9e8:	56450513          	addi	a0,a0,1380 # f48 <digits+0x18>
 9ec:	00000097          	auipc	ra,0x0
 9f0:	e02080e7          	jalr	-510(ra) # 7ee <printf>

	}
}
 9f4:	22813083          	ld	ra,552(sp)
 9f8:	22013403          	ld	s0,544(sp)
 9fc:	21813483          	ld	s1,536(sp)
 a00:	21013903          	ld	s2,528(sp)
 a04:	20813983          	ld	s3,520(sp)
 a08:	20013a03          	ld	s4,512(sp)
 a0c:	23010113          	addi	sp,sp,560
 a10:	8082                	ret
 a12:	8082                	ret

0000000000000a14 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 a14:	ba010113          	addi	sp,sp,-1120
 a18:	44113c23          	sd	ra,1112(sp)
 a1c:	44813823          	sd	s0,1104(sp)
 a20:	44913423          	sd	s1,1096(sp)
 a24:	45213023          	sd	s2,1088(sp)
 a28:	43313c23          	sd	s3,1080(sp)
 a2c:	43413823          	sd	s4,1072(sp)
 a30:	43513423          	sd	s5,1064(sp)
 a34:	43613023          	sd	s6,1056(sp)
 a38:	41713c23          	sd	s7,1048(sp)
 a3c:	41813823          	sd	s8,1040(sp)
 a40:	41913423          	sd	s9,1032(sp)
 a44:	41a13023          	sd	s10,1024(sp)
 a48:	3fb13c23          	sd	s11,1016(sp)
 a4c:	46010413          	addi	s0,sp,1120
 a50:	89aa                	mv	s3,a0
 a52:	8aae                	mv	s5,a1
 a54:	8c32                	mv	s8,a2
 a56:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 a58:	d9840593          	addi	a1,s0,-616
 a5c:	00000097          	auipc	ra,0x0
 a60:	2fa080e7          	jalr	762(ra) # d56 <read_line>


  if (readStatus == READ_ERROR)
 a64:	57fd                	li	a5,-1
 a66:	04f50163          	beq	a0,a5,aa8 <uniq_run+0x94>
 a6a:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 a6c:	ed21                	bnez	a0,ac4 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 a6e:	45813083          	ld	ra,1112(sp)
 a72:	45013403          	ld	s0,1104(sp)
 a76:	44813483          	ld	s1,1096(sp)
 a7a:	44013903          	ld	s2,1088(sp)
 a7e:	43813983          	ld	s3,1080(sp)
 a82:	43013a03          	ld	s4,1072(sp)
 a86:	42813a83          	ld	s5,1064(sp)
 a8a:	42013b03          	ld	s6,1056(sp)
 a8e:	41813b83          	ld	s7,1048(sp)
 a92:	41013c03          	ld	s8,1040(sp)
 a96:	40813c83          	ld	s9,1032(sp)
 a9a:	40013d03          	ld	s10,1024(sp)
 a9e:	3f813d83          	ld	s11,1016(sp)
 aa2:	46010113          	addi	sp,sp,1120
 aa6:	8082                	ret
    printf("[ERR] Error reading from the file ");
 aa8:	00000517          	auipc	a0,0x0
 aac:	4d050513          	addi	a0,a0,1232 # f78 <digits+0x48>
 ab0:	00000097          	auipc	ra,0x0
 ab4:	d3e080e7          	jalr	-706(ra) # 7ee <printf>
 ab8:	bf5d                	j	a6e <uniq_run+0x5a>
 aba:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 abc:	8926                	mv	s2,s1
 abe:	84be                	mv	s1,a5
        lineCount = 1;
 ac0:	8b6a                	mv	s6,s10
 ac2:	a8ed                	j	bbc <uniq_run+0x1a8>
    int lineCount=1;
 ac4:	4b05                	li	s6,1
  char * line2 = buffer2;
 ac6:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 aca:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 ace:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 ad0:	4d05                	li	s10,1
              printf("%s",line1);
 ad2:	00000d97          	auipc	s11,0x0
 ad6:	49ed8d93          	addi	s11,s11,1182 # f70 <digits+0x40>
 ada:	a0cd                	j	bbc <uniq_run+0x1a8>
            if (repeatedLines){
 adc:	020a0b63          	beqz	s4,b12 <uniq_run+0xfe>
                if (isRepeated){
 ae0:	f80b87e3          	beqz	s7,a6e <uniq_run+0x5a>
                    if (showCount)
 ae4:	000c0d63          	beqz	s8,afe <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 ae8:	864a                	mv	a2,s2
 aea:	85da                	mv	a1,s6
 aec:	00000517          	auipc	a0,0x0
 af0:	4b450513          	addi	a0,a0,1204 # fa0 <digits+0x70>
 af4:	00000097          	auipc	ra,0x0
 af8:	cfa080e7          	jalr	-774(ra) # 7ee <printf>
 afc:	bf8d                	j	a6e <uniq_run+0x5a>
                      printf("%s",line1);
 afe:	85ca                	mv	a1,s2
 b00:	00000517          	auipc	a0,0x0
 b04:	47050513          	addi	a0,a0,1136 # f70 <digits+0x40>
 b08:	00000097          	auipc	ra,0x0
 b0c:	ce6080e7          	jalr	-794(ra) # 7ee <printf>
 b10:	bfb9                	j	a6e <uniq_run+0x5a>
                if (showCount)
 b12:	000c0d63          	beqz	s8,b2c <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 b16:	864a                	mv	a2,s2
 b18:	85da                	mv	a1,s6
 b1a:	00000517          	auipc	a0,0x0
 b1e:	48650513          	addi	a0,a0,1158 # fa0 <digits+0x70>
 b22:	00000097          	auipc	ra,0x0
 b26:	ccc080e7          	jalr	-820(ra) # 7ee <printf>
 b2a:	b791                	j	a6e <uniq_run+0x5a>
                  printf("%s",line1);
 b2c:	85ca                	mv	a1,s2
 b2e:	00000517          	auipc	a0,0x0
 b32:	44250513          	addi	a0,a0,1090 # f70 <digits+0x40>
 b36:	00000097          	auipc	ra,0x0
 b3a:	cb8080e7          	jalr	-840(ra) # 7ee <printf>
 b3e:	bf05                	j	a6e <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 b40:	00000517          	auipc	a0,0x0
 b44:	46850513          	addi	a0,a0,1128 # fa8 <digits+0x78>
 b48:	00000097          	auipc	ra,0x0
 b4c:	ca6080e7          	jalr	-858(ra) # 7ee <printf>
          break;
 b50:	bf39                	j	a6e <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 b52:	85a6                	mv	a1,s1
 b54:	854a                	mv	a0,s2
 b56:	00000097          	auipc	ra,0x0
 b5a:	110080e7          	jalr	272(ra) # c66 <compare_str_ic>
 b5e:	a041                	j	bde <uniq_run+0x1ca>
                  printf("%s",line1);
 b60:	85ca                	mv	a1,s2
 b62:	856e                	mv	a0,s11
 b64:	00000097          	auipc	ra,0x0
 b68:	c8a080e7          	jalr	-886(ra) # 7ee <printf>
        lineCount = 1;
 b6c:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 b6e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b70:	8926                	mv	s2,s1
                  printf("%s",line1);
 b72:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b74:	4b81                	li	s7,0
 b76:	a099                	j	bbc <uniq_run+0x1a8>
            if (showCount)
 b78:	020c0263          	beqz	s8,b9c <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 b7c:	864a                	mv	a2,s2
 b7e:	85da                	mv	a1,s6
 b80:	00000517          	auipc	a0,0x0
 b84:	42050513          	addi	a0,a0,1056 # fa0 <digits+0x70>
 b88:	00000097          	auipc	ra,0x0
 b8c:	c66080e7          	jalr	-922(ra) # 7ee <printf>
 b90:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b92:	8926                	mv	s2,s1
 b94:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b96:	4b81                	li	s7,0
        lineCount = 1;
 b98:	8b6a                	mv	s6,s10
 b9a:	a00d                	j	bbc <uniq_run+0x1a8>
              printf("%s",line1);
 b9c:	85ca                	mv	a1,s2
 b9e:	856e                	mv	a0,s11
 ba0:	00000097          	auipc	ra,0x0
 ba4:	c4e080e7          	jalr	-946(ra) # 7ee <printf>
 ba8:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 baa:	8926                	mv	s2,s1
              printf("%s",line1);
 bac:	84be                	mv	s1,a5
        isRepeated = 0 ;
 bae:	4b81                	li	s7,0
        lineCount = 1;
 bb0:	8b6a                	mv	s6,s10
 bb2:	a029                	j	bbc <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 bb4:	000a0363          	beqz	s4,bba <uniq_run+0x1a6>
 bb8:	8bea                	mv	s7,s10
          lineCount++;
 bba:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 bbc:	85a6                	mv	a1,s1
 bbe:	854e                	mv	a0,s3
 bc0:	00000097          	auipc	ra,0x0
 bc4:	196080e7          	jalr	406(ra) # d56 <read_line>
        if (readStatus == READ_EOF){
 bc8:	d911                	beqz	a0,adc <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 bca:	f7950be3          	beq	a0,s9,b40 <uniq_run+0x12c>
        if (!ignoreCase)
 bce:	f80a92e3          	bnez	s5,b52 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 bd2:	85a6                	mv	a1,s1
 bd4:	854a                	mv	a0,s2
 bd6:	00000097          	auipc	ra,0x0
 bda:	062080e7          	jalr	98(ra) # c38 <compare_str>
        if (compareStatus != 0){ 
 bde:	d979                	beqz	a0,bb4 <uniq_run+0x1a0>
          if (repeatedLines){
 be0:	f80a0ce3          	beqz	s4,b78 <uniq_run+0x164>
            if (isRepeated){
 be4:	ec0b8be3          	beqz	s7,aba <uniq_run+0xa6>
                if (showCount)
 be8:	f60c0ce3          	beqz	s8,b60 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 bec:	864a                	mv	a2,s2
 bee:	85da                	mv	a1,s6
 bf0:	00000517          	auipc	a0,0x0
 bf4:	3b050513          	addi	a0,a0,944 # fa0 <digits+0x70>
 bf8:	00000097          	auipc	ra,0x0
 bfc:	bf6080e7          	jalr	-1034(ra) # 7ee <printf>
        lineCount = 1;
 c00:	8b5e                	mv	s6,s7
 c02:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 c04:	8926                	mv	s2,s1
 c06:	84be                	mv	s1,a5
        isRepeated = 0 ;
 c08:	4b81                	li	s7,0
 c0a:	bf4d                	j	bbc <uniq_run+0x1a8>

0000000000000c0c <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 c0c:	1141                	addi	sp,sp,-16
 c0e:	e422                	sd	s0,8(sp)
 c10:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 c12:	00054783          	lbu	a5,0(a0)
 c16:	cf99                	beqz	a5,c34 <get_strlen+0x28>
 c18:	00150713          	addi	a4,a0,1
 c1c:	87ba                	mv	a5,a4
 c1e:	4685                	li	a3,1
 c20:	9e99                	subw	a3,a3,a4
 c22:	00f6853b          	addw	a0,a3,a5
 c26:	0785                	addi	a5,a5,1
 c28:	fff7c703          	lbu	a4,-1(a5)
 c2c:	fb7d                	bnez	a4,c22 <get_strlen+0x16>
	return len;
}
 c2e:	6422                	ld	s0,8(sp)
 c30:	0141                	addi	sp,sp,16
 c32:	8082                	ret
	int len = 0;
 c34:	4501                	li	a0,0
 c36:	bfe5                	j	c2e <get_strlen+0x22>

0000000000000c38 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 c38:	1141                	addi	sp,sp,-16
 c3a:	e422                	sd	s0,8(sp)
 c3c:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 c3e:	00054783          	lbu	a5,0(a0)
 c42:	cb91                	beqz	a5,c56 <compare_str+0x1e>
 c44:	0005c703          	lbu	a4,0(a1)
 c48:	c719                	beqz	a4,c56 <compare_str+0x1e>
		if (*s1++ != *s2++)
 c4a:	0505                	addi	a0,a0,1
 c4c:	0585                	addi	a1,a1,1
 c4e:	fee788e3          	beq	a5,a4,c3e <compare_str+0x6>
			return 1;
 c52:	4505                	li	a0,1
 c54:	a031                	j	c60 <compare_str+0x28>
	}
	if (*s1 == *s2)
 c56:	0005c503          	lbu	a0,0(a1)
 c5a:	8d1d                	sub	a0,a0,a5
			return 1;
 c5c:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 c60:	6422                	ld	s0,8(sp)
 c62:	0141                	addi	sp,sp,16
 c64:	8082                	ret

0000000000000c66 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 c66:	1141                	addi	sp,sp,-16
 c68:	e422                	sd	s0,8(sp)
 c6a:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 c6c:	4665                	li	a2,25
	while(*s1 && *s2){
 c6e:	a019                	j	c74 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 c70:	04e79763          	bne	a5,a4,cbe <compare_str_ic+0x58>
	while(*s1 && *s2){
 c74:	00054783          	lbu	a5,0(a0)
 c78:	cb9d                	beqz	a5,cae <compare_str_ic+0x48>
 c7a:	0005c703          	lbu	a4,0(a1)
 c7e:	cb05                	beqz	a4,cae <compare_str_ic+0x48>
		char b1 = *s1++;
 c80:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 c82:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 c84:	fbf7869b          	addiw	a3,a5,-65
 c88:	0ff6f693          	zext.b	a3,a3
 c8c:	00d66663          	bltu	a2,a3,c98 <compare_str_ic+0x32>
			b1 += 32;
 c90:	0207879b          	addiw	a5,a5,32
 c94:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 c98:	fbf7069b          	addiw	a3,a4,-65
 c9c:	0ff6f693          	zext.b	a3,a3
 ca0:	fcd668e3          	bltu	a2,a3,c70 <compare_str_ic+0xa>
			b2 += 32;
 ca4:	0207071b          	addiw	a4,a4,32
 ca8:	0ff77713          	zext.b	a4,a4
 cac:	b7d1                	j	c70 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 cae:	0005c503          	lbu	a0,0(a1)
 cb2:	8d1d                	sub	a0,a0,a5
			return 1;
 cb4:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 cb8:	6422                	ld	s0,8(sp)
 cba:	0141                	addi	sp,sp,16
 cbc:	8082                	ret
			return 1;
 cbe:	4505                	li	a0,1
 cc0:	bfe5                	j	cb8 <compare_str_ic+0x52>

0000000000000cc2 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 cc2:	7179                	addi	sp,sp,-48
 cc4:	f406                	sd	ra,40(sp)
 cc6:	f022                	sd	s0,32(sp)
 cc8:	ec26                	sd	s1,24(sp)
 cca:	e84a                	sd	s2,16(sp)
 ccc:	e44e                	sd	s3,8(sp)
 cce:	1800                	addi	s0,sp,48
 cd0:	89aa                	mv	s3,a0
 cd2:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 cd4:	00000097          	auipc	ra,0x0
 cd8:	f38080e7          	jalr	-200(ra) # c0c <get_strlen>
 cdc:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 cde:	854a                	mv	a0,s2
 ce0:	00000097          	auipc	ra,0x0
 ce4:	f2c080e7          	jalr	-212(ra) # c0c <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 ce8:	409505bb          	subw	a1,a0,s1
 cec:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 cee:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 cf0:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 cf2:	0005da63          	bgez	a1,d06 <check_substr+0x44>
 cf6:	a81d                	j	d2c <check_substr+0x6a>
        if (j == M)
 cf8:	02f48a63          	beq	s1,a5,d2c <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 cfc:	0885                	addi	a7,a7,1
 cfe:	0008879b          	sext.w	a5,a7
 d02:	02f5cc63          	blt	a1,a5,d3a <check_substr+0x78>
 d06:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 d0a:	011906b3          	add	a3,s2,a7
 d0e:	874e                	mv	a4,s3
 d10:	879a                	mv	a5,t1
 d12:	fe9053e3          	blez	s1,cf8 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 d16:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 d1a:	00074603          	lbu	a2,0(a4)
 d1e:	fcc81de3          	bne	a6,a2,cf8 <check_substr+0x36>
        for (j = 0; j < M; j++)
 d22:	2785                	addiw	a5,a5,1
 d24:	0685                	addi	a3,a3,1
 d26:	0705                	addi	a4,a4,1
 d28:	fef497e3          	bne	s1,a5,d16 <check_substr+0x54>
}
 d2c:	70a2                	ld	ra,40(sp)
 d2e:	7402                	ld	s0,32(sp)
 d30:	64e2                	ld	s1,24(sp)
 d32:	6942                	ld	s2,16(sp)
 d34:	69a2                	ld	s3,8(sp)
 d36:	6145                	addi	sp,sp,48
 d38:	8082                	ret
    return -1;
 d3a:	557d                	li	a0,-1
 d3c:	bfc5                	j	d2c <check_substr+0x6a>

0000000000000d3e <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 d3e:	1141                	addi	sp,sp,-16
 d40:	e406                	sd	ra,8(sp)
 d42:	e022                	sd	s0,0(sp)
 d44:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 d46:	fffff097          	auipc	ra,0xfffff
 d4a:	72e080e7          	jalr	1838(ra) # 474 <open>
	return fd;
}
 d4e:	60a2                	ld	ra,8(sp)
 d50:	6402                	ld	s0,0(sp)
 d52:	0141                	addi	sp,sp,16
 d54:	8082                	ret

0000000000000d56 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 d56:	7139                	addi	sp,sp,-64
 d58:	fc06                	sd	ra,56(sp)
 d5a:	f822                	sd	s0,48(sp)
 d5c:	f426                	sd	s1,40(sp)
 d5e:	f04a                	sd	s2,32(sp)
 d60:	ec4e                	sd	s3,24(sp)
 d62:	e852                	sd	s4,16(sp)
 d64:	0080                	addi	s0,sp,64
 d66:	89aa                	mv	s3,a0
 d68:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 d6a:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 d6c:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 d6e:	4605                	li	a2,1
 d70:	fcf40593          	addi	a1,s0,-49
 d74:	854e                	mv	a0,s3
 d76:	fffff097          	auipc	ra,0xfffff
 d7a:	6d6080e7          	jalr	1750(ra) # 44c <read>
		if (readStatus == 0){
 d7e:	c505                	beqz	a0,da6 <read_line+0x50>
		*buffer++ = readByte;
 d80:	0485                	addi	s1,s1,1
 d82:	fcf44783          	lbu	a5,-49(s0)
 d86:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 d8a:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 d8c:	ff4791e3          	bne	a5,s4,d6e <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 d90:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 d94:	854a                	mv	a0,s2
 d96:	70e2                	ld	ra,56(sp)
 d98:	7442                	ld	s0,48(sp)
 d9a:	74a2                	ld	s1,40(sp)
 d9c:	7902                	ld	s2,32(sp)
 d9e:	69e2                	ld	s3,24(sp)
 da0:	6a42                	ld	s4,16(sp)
 da2:	6121                	addi	sp,sp,64
 da4:	8082                	ret
			if (byteCount!=0){
 da6:	fe0907e3          	beqz	s2,d94 <read_line+0x3e>
				*buffer = '\n';
 daa:	47a9                	li	a5,10
 dac:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 db0:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 db4:	2905                	addiw	s2,s2,1
 db6:	bff9                	j	d94 <read_line+0x3e>

0000000000000db8 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 db8:	1141                	addi	sp,sp,-16
 dba:	e406                	sd	ra,8(sp)
 dbc:	e022                	sd	s0,0(sp)
 dbe:	0800                	addi	s0,sp,16
	close(fd);
 dc0:	fffff097          	auipc	ra,0xfffff
 dc4:	69c080e7          	jalr	1692(ra) # 45c <close>
}
 dc8:	60a2                	ld	ra,8(sp)
 dca:	6402                	ld	s0,0(sp)
 dcc:	0141                	addi	sp,sp,16
 dce:	8082                	ret

0000000000000dd0 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 dd0:	7139                	addi	sp,sp,-64
 dd2:	fc06                	sd	ra,56(sp)
 dd4:	f822                	sd	s0,48(sp)
 dd6:	f426                	sd	s1,40(sp)
 dd8:	f04a                	sd	s2,32(sp)
 dda:	0080                	addi	s0,sp,64
 ddc:	84aa                	mv	s1,a0
 dde:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 de0:	fffff097          	auipc	ra,0xfffff
 de4:	64c080e7          	jalr	1612(ra) # 42c <fork>
 de8:	ed19                	bnez	a0,e06 <get_time_perf+0x36>
		exec(argv[0],argv);
 dea:	85ca                	mv	a1,s2
 dec:	00093503          	ld	a0,0(s2)
 df0:	fffff097          	auipc	ra,0xfffff
 df4:	67c080e7          	jalr	1660(ra) # 46c <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 df8:	8526                	mv	a0,s1
 dfa:	70e2                	ld	ra,56(sp)
 dfc:	7442                	ld	s0,48(sp)
 dfe:	74a2                	ld	s1,40(sp)
 e00:	7902                	ld	s2,32(sp)
 e02:	6121                	addi	sp,sp,64
 e04:	8082                	ret
		times(pid , &time);
 e06:	fc040593          	addi	a1,s0,-64
 e0a:	fffff097          	auipc	ra,0xfffff
 e0e:	6e2080e7          	jalr	1762(ra) # 4ec <times>
		return time;
 e12:	fc043783          	ld	a5,-64(s0)
 e16:	e09c                	sd	a5,0(s1)
 e18:	fc843783          	ld	a5,-56(s0)
 e1c:	e49c                	sd	a5,8(s1)
 e1e:	fd043783          	ld	a5,-48(s0)
 e22:	e89c                	sd	a5,16(s1)
 e24:	fd843783          	ld	a5,-40(s0)
 e28:	ec9c                	sd	a5,24(s1)
 e2a:	b7f9                	j	df8 <get_time_perf+0x28>
