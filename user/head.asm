
user/_head:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:





int main(int argc, char ** argv){
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
	char ** passedFiles = malloc(sizeof(char *) * (argc));
  16:	0035151b          	slliw	a0,a0,0x3
  1a:	00001097          	auipc	ra,0x1
  1e:	84a080e7          	jalr	-1974(ra) # 864 <malloc>

	if (!passedFiles){
  22:	c141                	beqz	a0,a2 <main+0xa2>
  24:	8a2a                	mv	s4,a0
		return NULL;
	}


	int fileIdx = 0;
	cmd++;  // Skipping the program's name
  26:	00890493          	addi	s1,s2,8
	
	while(*cmd){
  2a:	00893503          	ld	a0,8(s2)
  2e:	c139                	beqz	a0,74 <main+0x74>
	*lineCount = NUM_OF_LINES;
  30:	4ab9                	li	s5,14
	int fileIdx = 0;
  32:	4981                	li	s3,0
		if (!compare_str(cmd[0], "-n")){
  34:	00001b17          	auipc	s6,0x1
  38:	dbcb0b13          	addi	s6,s6,-580 # df0 <get_time_perf+0x62>
  3c:	a829                	j	56 <main+0x56>
			cmd++;
			*lineCount = atoi(cmd[0]);
		}
		else
			passedFiles[fileIdx++] = cmd[0];
  3e:	6098                	ld	a4,0(s1)
  40:	00399793          	slli	a5,s3,0x3
  44:	97d2                	add	a5,a5,s4
  46:	e398                	sd	a4,0(a5)
  48:	2985                	addiw	s3,s3,1
  4a:	8926                	mv	s2,s1
			
		cmd++;
  4c:	00890493          	addi	s1,s2,8
	while(*cmd){
  50:	00893503          	ld	a0,8(s2)
  54:	c115                	beqz	a0,78 <main+0x78>
		if (!compare_str(cmd[0], "-n")){
  56:	85da                	mv	a1,s6
  58:	00001097          	auipc	ra,0x1
  5c:	b9e080e7          	jalr	-1122(ra) # bf6 <compare_str>
  60:	fd79                	bnez	a0,3e <main+0x3e>
			cmd++;
  62:	00848913          	addi	s2,s1,8
			*lineCount = atoi(cmd[0]);
  66:	6488                	ld	a0,8(s1)
  68:	00000097          	auipc	ra,0x0
  6c:	2a8080e7          	jalr	680(ra) # 310 <atoi>
  70:	8aaa                	mv	s5,a0
  72:	bfe9                	j	4c <main+0x4c>
	*lineCount = NUM_OF_LINES;
  74:	4ab9                	li	s5,14
	int fileIdx = 0;
  76:	4981                	li	s3,0
	}

	passedFiles[fileIdx]=NULL;
  78:	098e                	slli	s3,s3,0x3
  7a:	99d2                	add	s3,s3,s4
  7c:	0009b023          	sd	zero,0(s3)
	head(passedFiles, lineCount);
  80:	85d6                	mv	a1,s5
  82:	8552                	mv	a0,s4
  84:	00000097          	auipc	ra,0x0
  88:	426080e7          	jalr	1062(ra) # 4aa <head>
	return 0;
  8c:	4501                	li	a0,0
}
  8e:	70e2                	ld	ra,56(sp)
  90:	7442                	ld	s0,48(sp)
  92:	74a2                	ld	s1,40(sp)
  94:	7902                	ld	s2,32(sp)
  96:	69e2                	ld	s3,24(sp)
  98:	6a42                	ld	s4,16(sp)
  9a:	6aa2                	ld	s5,8(sp)
  9c:	6b02                	ld	s6,0(sp)
  9e:	6121                	addi	sp,sp,64
  a0:	8082                	ret
		printf("[ERR] Cannot parse the issued command\n");
  a2:	00001517          	auipc	a0,0x1
  a6:	d5650513          	addi	a0,a0,-682 # df8 <get_time_perf+0x6a>
  aa:	00000097          	auipc	ra,0x0
  ae:	702080e7          	jalr	1794(ra) # 7ac <printf>
		return 1;
  b2:	4505                	li	a0,1
  b4:	bfe9                	j	8e <main+0x8e>

00000000000000b6 <head_usermode>:
void head_usermode(char **passedFiles, int lineCount){
  b6:	715d                	addi	sp,sp,-80
  b8:	e486                	sd	ra,72(sp)
  ba:	e0a2                	sd	s0,64(sp)
  bc:	fc26                	sd	s1,56(sp)
  be:	f84a                	sd	s2,48(sp)
  c0:	f44e                	sd	s3,40(sp)
  c2:	f052                	sd	s4,32(sp)
  c4:	ec56                	sd	s5,24(sp)
  c6:	e85a                	sd	s6,16(sp)
  c8:	e45e                	sd	s7,8(sp)
  ca:	e062                	sd	s8,0(sp)
  cc:	0880                	addi	s0,sp,80
  ce:	892a                	mv	s2,a0
  d0:	8a2e                	mv	s4,a1
	printf("Head command is getting executed in user mode\n");
  d2:	00001517          	auipc	a0,0x1
  d6:	d4e50513          	addi	a0,a0,-690 # e20 <get_time_perf+0x92>
  da:	00000097          	auipc	ra,0x0
  de:	6d2080e7          	jalr	1746(ra) # 7ac <printf>
	while(*files++){numOfFiles++;};
  e2:	00093503          	ld	a0,0(s2)
  e6:	cd2d                	beqz	a0,160 <head_usermode+0xaa>
  e8:	00890793          	addi	a5,s2,8
	int numOfFiles=0;
  ec:	4981                	li	s3,0
	while(*files++){numOfFiles++;};
  ee:	2985                	addiw	s3,s3,1
  f0:	07a1                	addi	a5,a5,8
  f2:	ff87b703          	ld	a4,-8(a5)
  f6:	ff65                	bnez	a4,ee <head_usermode+0x38>
			if (fd == OPEN_FILE_ERROR)
  f8:	5afd                	li	s5,-1
				if (numOfFiles > 1) 
  fa:	4b05                	li	s6,1
					printf("==> %s <==\n",*passedFiles);
  fc:	00001b97          	auipc	s7,0x1
 100:	d7cb8b93          	addi	s7,s7,-644 # e78 <get_time_perf+0xea>
				printf("[ERR] opening the file '%s' failed \n",*passedFiles);
 104:	00001c17          	auipc	s8,0x1
 108:	d4cc0c13          	addi	s8,s8,-692 # e50 <get_time_perf+0xc2>
 10c:	a805                	j	13c <head_usermode+0x86>
 10e:	00093583          	ld	a1,0(s2)
 112:	8562                	mv	a0,s8
 114:	00000097          	auipc	ra,0x0
 118:	698080e7          	jalr	1688(ra) # 7ac <printf>
 11c:	a039                	j	12a <head_usermode+0x74>
				head_run(fd , lineCount);
 11e:	85d2                	mv	a1,s4
 120:	8526                	mv	a0,s1
 122:	00001097          	auipc	ra,0x1
 126:	828080e7          	jalr	-2008(ra) # 94a <head_run>
			close_file(fd);
 12a:	8526                	mv	a0,s1
 12c:	00001097          	auipc	ra,0x1
 130:	c4a080e7          	jalr	-950(ra) # d76 <close_file>
			passedFiles++;
 134:	0921                	addi	s2,s2,8
		while (*passedFiles){
 136:	00093503          	ld	a0,0(s2)
 13a:	c90d                	beqz	a0,16c <head_usermode+0xb6>
			int fd = open_file(*passedFiles, RDONLY);
 13c:	4581                	li	a1,0
 13e:	00001097          	auipc	ra,0x1
 142:	bbe080e7          	jalr	-1090(ra) # cfc <open_file>
 146:	84aa                	mv	s1,a0
			if (fd == OPEN_FILE_ERROR)
 148:	fd5503e3          	beq	a0,s5,10e <head_usermode+0x58>
				if (numOfFiles > 1) 
 14c:	fd3b59e3          	bge	s6,s3,11e <head_usermode+0x68>
					printf("==> %s <==\n",*passedFiles);
 150:	00093583          	ld	a1,0(s2)
 154:	855e                	mv	a0,s7
 156:	00000097          	auipc	ra,0x0
 15a:	656080e7          	jalr	1622(ra) # 7ac <printf>
 15e:	b7c1                	j	11e <head_usermode+0x68>
		head_run(STDIN, lineCount);
 160:	85d2                	mv	a1,s4
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	7e6080e7          	jalr	2022(ra) # 94a <head_run>
}
 16c:	60a6                	ld	ra,72(sp)
 16e:	6406                	ld	s0,64(sp)
 170:	74e2                	ld	s1,56(sp)
 172:	7942                	ld	s2,48(sp)
 174:	79a2                	ld	s3,40(sp)
 176:	7a02                	ld	s4,32(sp)
 178:	6ae2                	ld	s5,24(sp)
 17a:	6b42                	ld	s6,16(sp)
 17c:	6ba2                	ld	s7,8(sp)
 17e:	6c02                	ld	s8,0(sp)
 180:	6161                	addi	sp,sp,80
 182:	8082                	ret

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
 190:	e74080e7          	jalr	-396(ra) # 0 <main>
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

00000000000004ba <ps>:
.global ps
ps:
 li a7, SYS_ps
 4ba:	48e1                	li	a7,24
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <times>:
.global times
times:
 li a7, SYS_times
 4c2:	48e5                	li	a7,25
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 4ca:	48e9                	li	a7,26
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d2:	1101                	addi	sp,sp,-32
 4d4:	ec06                	sd	ra,24(sp)
 4d6:	e822                	sd	s0,16(sp)
 4d8:	1000                	addi	s0,sp,32
 4da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4de:	4605                	li	a2,1
 4e0:	fef40593          	addi	a1,s0,-17
 4e4:	00000097          	auipc	ra,0x0
 4e8:	f46080e7          	jalr	-186(ra) # 42a <write>
}
 4ec:	60e2                	ld	ra,24(sp)
 4ee:	6442                	ld	s0,16(sp)
 4f0:	6105                	addi	sp,sp,32
 4f2:	8082                	ret

00000000000004f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f4:	7139                	addi	sp,sp,-64
 4f6:	fc06                	sd	ra,56(sp)
 4f8:	f822                	sd	s0,48(sp)
 4fa:	f426                	sd	s1,40(sp)
 4fc:	f04a                	sd	s2,32(sp)
 4fe:	ec4e                	sd	s3,24(sp)
 500:	0080                	addi	s0,sp,64
 502:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 504:	c299                	beqz	a3,50a <printint+0x16>
 506:	0805c963          	bltz	a1,598 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 50a:	2581                	sext.w	a1,a1
  neg = 0;
 50c:	4881                	li	a7,0
 50e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 512:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 514:	2601                	sext.w	a2,a2
 516:	00001517          	auipc	a0,0x1
 51a:	9d250513          	addi	a0,a0,-1582 # ee8 <digits>
 51e:	883a                	mv	a6,a4
 520:	2705                	addiw	a4,a4,1
 522:	02c5f7bb          	remuw	a5,a1,a2
 526:	1782                	slli	a5,a5,0x20
 528:	9381                	srli	a5,a5,0x20
 52a:	97aa                	add	a5,a5,a0
 52c:	0007c783          	lbu	a5,0(a5)
 530:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 534:	0005879b          	sext.w	a5,a1
 538:	02c5d5bb          	divuw	a1,a1,a2
 53c:	0685                	addi	a3,a3,1
 53e:	fec7f0e3          	bgeu	a5,a2,51e <printint+0x2a>
  if(neg)
 542:	00088c63          	beqz	a7,55a <printint+0x66>
    buf[i++] = '-';
 546:	fd070793          	addi	a5,a4,-48
 54a:	00878733          	add	a4,a5,s0
 54e:	02d00793          	li	a5,45
 552:	fef70823          	sb	a5,-16(a4)
 556:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 55a:	02e05863          	blez	a4,58a <printint+0x96>
 55e:	fc040793          	addi	a5,s0,-64
 562:	00e78933          	add	s2,a5,a4
 566:	fff78993          	addi	s3,a5,-1
 56a:	99ba                	add	s3,s3,a4
 56c:	377d                	addiw	a4,a4,-1
 56e:	1702                	slli	a4,a4,0x20
 570:	9301                	srli	a4,a4,0x20
 572:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 576:	fff94583          	lbu	a1,-1(s2)
 57a:	8526                	mv	a0,s1
 57c:	00000097          	auipc	ra,0x0
 580:	f56080e7          	jalr	-170(ra) # 4d2 <putc>
  while(--i >= 0)
 584:	197d                	addi	s2,s2,-1
 586:	ff3918e3          	bne	s2,s3,576 <printint+0x82>
}
 58a:	70e2                	ld	ra,56(sp)
 58c:	7442                	ld	s0,48(sp)
 58e:	74a2                	ld	s1,40(sp)
 590:	7902                	ld	s2,32(sp)
 592:	69e2                	ld	s3,24(sp)
 594:	6121                	addi	sp,sp,64
 596:	8082                	ret
    x = -xx;
 598:	40b005bb          	negw	a1,a1
    neg = 1;
 59c:	4885                	li	a7,1
    x = -xx;
 59e:	bf85                	j	50e <printint+0x1a>

00000000000005a0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a0:	7119                	addi	sp,sp,-128
 5a2:	fc86                	sd	ra,120(sp)
 5a4:	f8a2                	sd	s0,112(sp)
 5a6:	f4a6                	sd	s1,104(sp)
 5a8:	f0ca                	sd	s2,96(sp)
 5aa:	ecce                	sd	s3,88(sp)
 5ac:	e8d2                	sd	s4,80(sp)
 5ae:	e4d6                	sd	s5,72(sp)
 5b0:	e0da                	sd	s6,64(sp)
 5b2:	fc5e                	sd	s7,56(sp)
 5b4:	f862                	sd	s8,48(sp)
 5b6:	f466                	sd	s9,40(sp)
 5b8:	f06a                	sd	s10,32(sp)
 5ba:	ec6e                	sd	s11,24(sp)
 5bc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5be:	0005c903          	lbu	s2,0(a1)
 5c2:	18090f63          	beqz	s2,760 <vprintf+0x1c0>
 5c6:	8aaa                	mv	s5,a0
 5c8:	8b32                	mv	s6,a2
 5ca:	00158493          	addi	s1,a1,1
  state = 0;
 5ce:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5d0:	02500a13          	li	s4,37
 5d4:	4c55                	li	s8,21
 5d6:	00001c97          	auipc	s9,0x1
 5da:	8bac8c93          	addi	s9,s9,-1862 # e90 <get_time_perf+0x102>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5de:	02800d93          	li	s11,40
  putc(fd, 'x');
 5e2:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e4:	00001b97          	auipc	s7,0x1
 5e8:	904b8b93          	addi	s7,s7,-1788 # ee8 <digits>
 5ec:	a839                	j	60a <vprintf+0x6a>
        putc(fd, c);
 5ee:	85ca                	mv	a1,s2
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	ee0080e7          	jalr	-288(ra) # 4d2 <putc>
 5fa:	a019                	j	600 <vprintf+0x60>
    } else if(state == '%'){
 5fc:	01498d63          	beq	s3,s4,616 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 600:	0485                	addi	s1,s1,1
 602:	fff4c903          	lbu	s2,-1(s1)
 606:	14090d63          	beqz	s2,760 <vprintf+0x1c0>
    if(state == 0){
 60a:	fe0999e3          	bnez	s3,5fc <vprintf+0x5c>
      if(c == '%'){
 60e:	ff4910e3          	bne	s2,s4,5ee <vprintf+0x4e>
        state = '%';
 612:	89d2                	mv	s3,s4
 614:	b7f5                	j	600 <vprintf+0x60>
      if(c == 'd'){
 616:	11490c63          	beq	s2,s4,72e <vprintf+0x18e>
 61a:	f9d9079b          	addiw	a5,s2,-99
 61e:	0ff7f793          	zext.b	a5,a5
 622:	10fc6e63          	bltu	s8,a5,73e <vprintf+0x19e>
 626:	f9d9079b          	addiw	a5,s2,-99
 62a:	0ff7f713          	zext.b	a4,a5
 62e:	10ec6863          	bltu	s8,a4,73e <vprintf+0x19e>
 632:	00271793          	slli	a5,a4,0x2
 636:	97e6                	add	a5,a5,s9
 638:	439c                	lw	a5,0(a5)
 63a:	97e6                	add	a5,a5,s9
 63c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 63e:	008b0913          	addi	s2,s6,8
 642:	4685                	li	a3,1
 644:	4629                	li	a2,10
 646:	000b2583          	lw	a1,0(s6)
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	ea8080e7          	jalr	-344(ra) # 4f4 <printint>
 654:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 656:	4981                	li	s3,0
 658:	b765                	j	600 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	008b0913          	addi	s2,s6,8
 65e:	4681                	li	a3,0
 660:	4629                	li	a2,10
 662:	000b2583          	lw	a1,0(s6)
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e8c080e7          	jalr	-372(ra) # 4f4 <printint>
 670:	8b4a                	mv	s6,s2
      state = 0;
 672:	4981                	li	s3,0
 674:	b771                	j	600 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 676:	008b0913          	addi	s2,s6,8
 67a:	4681                	li	a3,0
 67c:	866a                	mv	a2,s10
 67e:	000b2583          	lw	a1,0(s6)
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e70080e7          	jalr	-400(ra) # 4f4 <printint>
 68c:	8b4a                	mv	s6,s2
      state = 0;
 68e:	4981                	li	s3,0
 690:	bf85                	j	600 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 692:	008b0793          	addi	a5,s6,8
 696:	f8f43423          	sd	a5,-120(s0)
 69a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 69e:	03000593          	li	a1,48
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	e2e080e7          	jalr	-466(ra) # 4d2 <putc>
  putc(fd, 'x');
 6ac:	07800593          	li	a1,120
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	e20080e7          	jalr	-480(ra) # 4d2 <putc>
 6ba:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6bc:	03c9d793          	srli	a5,s3,0x3c
 6c0:	97de                	add	a5,a5,s7
 6c2:	0007c583          	lbu	a1,0(a5)
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	e0a080e7          	jalr	-502(ra) # 4d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d0:	0992                	slli	s3,s3,0x4
 6d2:	397d                	addiw	s2,s2,-1
 6d4:	fe0914e3          	bnez	s2,6bc <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 6d8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	b70d                	j	600 <vprintf+0x60>
        s = va_arg(ap, char*);
 6e0:	008b0913          	addi	s2,s6,8
 6e4:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 6e8:	02098163          	beqz	s3,70a <vprintf+0x16a>
        while(*s != 0){
 6ec:	0009c583          	lbu	a1,0(s3)
 6f0:	c5ad                	beqz	a1,75a <vprintf+0x1ba>
          putc(fd, *s);
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	dde080e7          	jalr	-546(ra) # 4d2 <putc>
          s++;
 6fc:	0985                	addi	s3,s3,1
        while(*s != 0){
 6fe:	0009c583          	lbu	a1,0(s3)
 702:	f9e5                	bnez	a1,6f2 <vprintf+0x152>
        s = va_arg(ap, char*);
 704:	8b4a                	mv	s6,s2
      state = 0;
 706:	4981                	li	s3,0
 708:	bde5                	j	600 <vprintf+0x60>
          s = "(null)";
 70a:	00000997          	auipc	s3,0x0
 70e:	77e98993          	addi	s3,s3,1918 # e88 <get_time_perf+0xfa>
        while(*s != 0){
 712:	85ee                	mv	a1,s11
 714:	bff9                	j	6f2 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 716:	008b0913          	addi	s2,s6,8
 71a:	000b4583          	lbu	a1,0(s6)
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	db2080e7          	jalr	-590(ra) # 4d2 <putc>
 728:	8b4a                	mv	s6,s2
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bdd1                	j	600 <vprintf+0x60>
        putc(fd, c);
 72e:	85d2                	mv	a1,s4
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	da0080e7          	jalr	-608(ra) # 4d2 <putc>
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b5d1                	j	600 <vprintf+0x60>
        putc(fd, '%');
 73e:	85d2                	mv	a1,s4
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	d90080e7          	jalr	-624(ra) # 4d2 <putc>
        putc(fd, c);
 74a:	85ca                	mv	a1,s2
 74c:	8556                	mv	a0,s5
 74e:	00000097          	auipc	ra,0x0
 752:	d84080e7          	jalr	-636(ra) # 4d2 <putc>
      state = 0;
 756:	4981                	li	s3,0
 758:	b565                	j	600 <vprintf+0x60>
        s = va_arg(ap, char*);
 75a:	8b4a                	mv	s6,s2
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b54d                	j	600 <vprintf+0x60>
    }
  }
}
 760:	70e6                	ld	ra,120(sp)
 762:	7446                	ld	s0,112(sp)
 764:	74a6                	ld	s1,104(sp)
 766:	7906                	ld	s2,96(sp)
 768:	69e6                	ld	s3,88(sp)
 76a:	6a46                	ld	s4,80(sp)
 76c:	6aa6                	ld	s5,72(sp)
 76e:	6b06                	ld	s6,64(sp)
 770:	7be2                	ld	s7,56(sp)
 772:	7c42                	ld	s8,48(sp)
 774:	7ca2                	ld	s9,40(sp)
 776:	7d02                	ld	s10,32(sp)
 778:	6de2                	ld	s11,24(sp)
 77a:	6109                	addi	sp,sp,128
 77c:	8082                	ret

000000000000077e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 77e:	715d                	addi	sp,sp,-80
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e010                	sd	a2,0(s0)
 788:	e414                	sd	a3,8(s0)
 78a:	e818                	sd	a4,16(s0)
 78c:	ec1c                	sd	a5,24(s0)
 78e:	03043023          	sd	a6,32(s0)
 792:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 796:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79a:	8622                	mv	a2,s0
 79c:	00000097          	auipc	ra,0x0
 7a0:	e04080e7          	jalr	-508(ra) # 5a0 <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6161                	addi	sp,sp,80
 7aa:	8082                	ret

00000000000007ac <printf>:

void
printf(const char *fmt, ...)
{
 7ac:	711d                	addi	sp,sp,-96
 7ae:	ec06                	sd	ra,24(sp)
 7b0:	e822                	sd	s0,16(sp)
 7b2:	1000                	addi	s0,sp,32
 7b4:	e40c                	sd	a1,8(s0)
 7b6:	e810                	sd	a2,16(s0)
 7b8:	ec14                	sd	a3,24(s0)
 7ba:	f018                	sd	a4,32(s0)
 7bc:	f41c                	sd	a5,40(s0)
 7be:	03043823          	sd	a6,48(s0)
 7c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c6:	00840613          	addi	a2,s0,8
 7ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ce:	85aa                	mv	a1,a0
 7d0:	4505                	li	a0,1
 7d2:	00000097          	auipc	ra,0x0
 7d6:	dce080e7          	jalr	-562(ra) # 5a0 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6125                	addi	sp,sp,96
 7e0:	8082                	ret

00000000000007e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e2:	1141                	addi	sp,sp,-16
 7e4:	e422                	sd	s0,8(sp)
 7e6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ec:	00001797          	auipc	a5,0x1
 7f0:	8147b783          	ld	a5,-2028(a5) # 1000 <freep>
 7f4:	a02d                	j	81e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f6:	4618                	lw	a4,8(a2)
 7f8:	9f2d                	addw	a4,a4,a1
 7fa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fe:	6398                	ld	a4,0(a5)
 800:	6310                	ld	a2,0(a4)
 802:	a83d                	j	840 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 804:	ff852703          	lw	a4,-8(a0)
 808:	9f31                	addw	a4,a4,a2
 80a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 80c:	ff053683          	ld	a3,-16(a0)
 810:	a091                	j	854 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 812:	6398                	ld	a4,0(a5)
 814:	00e7e463          	bltu	a5,a4,81c <free+0x3a>
 818:	00e6ea63          	bltu	a3,a4,82c <free+0x4a>
{
 81c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	fed7fae3          	bgeu	a5,a3,812 <free+0x30>
 822:	6398                	ld	a4,0(a5)
 824:	00e6e463          	bltu	a3,a4,82c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	fee7eae3          	bltu	a5,a4,81c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 82c:	ff852583          	lw	a1,-8(a0)
 830:	6390                	ld	a2,0(a5)
 832:	02059813          	slli	a6,a1,0x20
 836:	01c85713          	srli	a4,a6,0x1c
 83a:	9736                	add	a4,a4,a3
 83c:	fae60de3          	beq	a2,a4,7f6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 840:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 844:	4790                	lw	a2,8(a5)
 846:	02061593          	slli	a1,a2,0x20
 84a:	01c5d713          	srli	a4,a1,0x1c
 84e:	973e                	add	a4,a4,a5
 850:	fae68ae3          	beq	a3,a4,804 <free+0x22>
    p->s.ptr = bp->s.ptr;
 854:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 856:	00000717          	auipc	a4,0x0
 85a:	7af73523          	sd	a5,1962(a4) # 1000 <freep>
}
 85e:	6422                	ld	s0,8(sp)
 860:	0141                	addi	sp,sp,16
 862:	8082                	ret

0000000000000864 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 864:	7139                	addi	sp,sp,-64
 866:	fc06                	sd	ra,56(sp)
 868:	f822                	sd	s0,48(sp)
 86a:	f426                	sd	s1,40(sp)
 86c:	f04a                	sd	s2,32(sp)
 86e:	ec4e                	sd	s3,24(sp)
 870:	e852                	sd	s4,16(sp)
 872:	e456                	sd	s5,8(sp)
 874:	e05a                	sd	s6,0(sp)
 876:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 878:	02051493          	slli	s1,a0,0x20
 87c:	9081                	srli	s1,s1,0x20
 87e:	04bd                	addi	s1,s1,15
 880:	8091                	srli	s1,s1,0x4
 882:	0014899b          	addiw	s3,s1,1
 886:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 888:	00000517          	auipc	a0,0x0
 88c:	77853503          	ld	a0,1912(a0) # 1000 <freep>
 890:	c515                	beqz	a0,8bc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 894:	4798                	lw	a4,8(a5)
 896:	02977f63          	bgeu	a4,s1,8d4 <malloc+0x70>
 89a:	8a4e                	mv	s4,s3
 89c:	0009871b          	sext.w	a4,s3
 8a0:	6685                	lui	a3,0x1
 8a2:	00d77363          	bgeu	a4,a3,8a8 <malloc+0x44>
 8a6:	6a05                	lui	s4,0x1
 8a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b0:	00000917          	auipc	s2,0x0
 8b4:	75090913          	addi	s2,s2,1872 # 1000 <freep>
  if(p == (char*)-1)
 8b8:	5afd                	li	s5,-1
 8ba:	a895                	j	92e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8bc:	00000797          	auipc	a5,0x0
 8c0:	75478793          	addi	a5,a5,1876 # 1010 <base>
 8c4:	00000717          	auipc	a4,0x0
 8c8:	72f73e23          	sd	a5,1852(a4) # 1000 <freep>
 8cc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ce:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d2:	b7e1                	j	89a <malloc+0x36>
      if(p->s.size == nunits)
 8d4:	02e48c63          	beq	s1,a4,90c <malloc+0xa8>
        p->s.size -= nunits;
 8d8:	4137073b          	subw	a4,a4,s3
 8dc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8de:	02071693          	slli	a3,a4,0x20
 8e2:	01c6d713          	srli	a4,a3,0x1c
 8e6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ec:	00000717          	auipc	a4,0x0
 8f0:	70a73a23          	sd	a0,1812(a4) # 1000 <freep>
      return (void*)(p + 1);
 8f4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8f8:	70e2                	ld	ra,56(sp)
 8fa:	7442                	ld	s0,48(sp)
 8fc:	74a2                	ld	s1,40(sp)
 8fe:	7902                	ld	s2,32(sp)
 900:	69e2                	ld	s3,24(sp)
 902:	6a42                	ld	s4,16(sp)
 904:	6aa2                	ld	s5,8(sp)
 906:	6b02                	ld	s6,0(sp)
 908:	6121                	addi	sp,sp,64
 90a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 90c:	6398                	ld	a4,0(a5)
 90e:	e118                	sd	a4,0(a0)
 910:	bff1                	j	8ec <malloc+0x88>
  hp->s.size = nu;
 912:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 916:	0541                	addi	a0,a0,16
 918:	00000097          	auipc	ra,0x0
 91c:	eca080e7          	jalr	-310(ra) # 7e2 <free>
  return freep;
 920:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 924:	d971                	beqz	a0,8f8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 926:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 928:	4798                	lw	a4,8(a5)
 92a:	fa9775e3          	bgeu	a4,s1,8d4 <malloc+0x70>
    if(p == freep)
 92e:	00093703          	ld	a4,0(s2)
 932:	853e                	mv	a0,a5
 934:	fef719e3          	bne	a4,a5,926 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 938:	8552                	mv	a0,s4
 93a:	00000097          	auipc	ra,0x0
 93e:	b58080e7          	jalr	-1192(ra) # 492 <sbrk>
  if(p == (char*)-1)
 942:	fd5518e3          	bne	a0,s5,912 <malloc+0xae>
        return 0;
 946:	4501                	li	a0,0
 948:	bf45                	j	8f8 <malloc+0x94>

000000000000094a <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 94a:	c1d9                	beqz	a1,9d0 <head_run+0x86>
void head_run(int fd, int numOfLines){
 94c:	dd010113          	addi	sp,sp,-560
 950:	22113423          	sd	ra,552(sp)
 954:	22813023          	sd	s0,544(sp)
 958:	20913c23          	sd	s1,536(sp)
 95c:	21213823          	sd	s2,528(sp)
 960:	21313423          	sd	s3,520(sp)
 964:	21413023          	sd	s4,512(sp)
 968:	1c00                	addi	s0,sp,560
 96a:	892a                	mv	s2,a0
 96c:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 970:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 972:	00000a17          	auipc	s4,0x0
 976:	5b6a0a13          	addi	s4,s4,1462 # f28 <digits+0x40>
		readStatus = read_line(fd, line);
 97a:	dd840593          	addi	a1,s0,-552
 97e:	854a                	mv	a0,s2
 980:	00000097          	auipc	ra,0x0
 984:	394080e7          	jalr	916(ra) # d14 <read_line>
		if (readStatus == READ_ERROR){
 988:	01350d63          	beq	a0,s3,9a2 <head_run+0x58>
		if (readStatus == READ_EOF)
 98c:	c11d                	beqz	a0,9b2 <head_run+0x68>
		printf("%s",line);
 98e:	dd840593          	addi	a1,s0,-552
 992:	8552                	mv	a0,s4
 994:	00000097          	auipc	ra,0x0
 998:	e18080e7          	jalr	-488(ra) # 7ac <printf>
	while(numOfLines--){
 99c:	34fd                	addiw	s1,s1,-1
 99e:	fcf1                	bnez	s1,97a <head_run+0x30>
 9a0:	a809                	j	9b2 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 9a2:	00000517          	auipc	a0,0x0
 9a6:	55e50513          	addi	a0,a0,1374 # f00 <digits+0x18>
 9aa:	00000097          	auipc	ra,0x0
 9ae:	e02080e7          	jalr	-510(ra) # 7ac <printf>

	}
}
 9b2:	22813083          	ld	ra,552(sp)
 9b6:	22013403          	ld	s0,544(sp)
 9ba:	21813483          	ld	s1,536(sp)
 9be:	21013903          	ld	s2,528(sp)
 9c2:	20813983          	ld	s3,520(sp)
 9c6:	20013a03          	ld	s4,512(sp)
 9ca:	23010113          	addi	sp,sp,560
 9ce:	8082                	ret
 9d0:	8082                	ret

00000000000009d2 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 9d2:	ba010113          	addi	sp,sp,-1120
 9d6:	44113c23          	sd	ra,1112(sp)
 9da:	44813823          	sd	s0,1104(sp)
 9de:	44913423          	sd	s1,1096(sp)
 9e2:	45213023          	sd	s2,1088(sp)
 9e6:	43313c23          	sd	s3,1080(sp)
 9ea:	43413823          	sd	s4,1072(sp)
 9ee:	43513423          	sd	s5,1064(sp)
 9f2:	43613023          	sd	s6,1056(sp)
 9f6:	41713c23          	sd	s7,1048(sp)
 9fa:	41813823          	sd	s8,1040(sp)
 9fe:	41913423          	sd	s9,1032(sp)
 a02:	41a13023          	sd	s10,1024(sp)
 a06:	3fb13c23          	sd	s11,1016(sp)
 a0a:	46010413          	addi	s0,sp,1120
 a0e:	89aa                	mv	s3,a0
 a10:	8aae                	mv	s5,a1
 a12:	8c32                	mv	s8,a2
 a14:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 a16:	d9840593          	addi	a1,s0,-616
 a1a:	00000097          	auipc	ra,0x0
 a1e:	2fa080e7          	jalr	762(ra) # d14 <read_line>


  if (readStatus == READ_ERROR)
 a22:	57fd                	li	a5,-1
 a24:	04f50163          	beq	a0,a5,a66 <uniq_run+0x94>
 a28:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 a2a:	ed21                	bnez	a0,a82 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 a2c:	45813083          	ld	ra,1112(sp)
 a30:	45013403          	ld	s0,1104(sp)
 a34:	44813483          	ld	s1,1096(sp)
 a38:	44013903          	ld	s2,1088(sp)
 a3c:	43813983          	ld	s3,1080(sp)
 a40:	43013a03          	ld	s4,1072(sp)
 a44:	42813a83          	ld	s5,1064(sp)
 a48:	42013b03          	ld	s6,1056(sp)
 a4c:	41813b83          	ld	s7,1048(sp)
 a50:	41013c03          	ld	s8,1040(sp)
 a54:	40813c83          	ld	s9,1032(sp)
 a58:	40013d03          	ld	s10,1024(sp)
 a5c:	3f813d83          	ld	s11,1016(sp)
 a60:	46010113          	addi	sp,sp,1120
 a64:	8082                	ret
    printf("[ERR] Error reading from the file ");
 a66:	00000517          	auipc	a0,0x0
 a6a:	4ca50513          	addi	a0,a0,1226 # f30 <digits+0x48>
 a6e:	00000097          	auipc	ra,0x0
 a72:	d3e080e7          	jalr	-706(ra) # 7ac <printf>
 a76:	bf5d                	j	a2c <uniq_run+0x5a>
 a78:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a7a:	8926                	mv	s2,s1
 a7c:	84be                	mv	s1,a5
        lineCount = 1;
 a7e:	8b6a                	mv	s6,s10
 a80:	a8ed                	j	b7a <uniq_run+0x1a8>
    int lineCount=1;
 a82:	4b05                	li	s6,1
  char * line2 = buffer2;
 a84:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 a88:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 a8c:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 a8e:	4d05                	li	s10,1
              printf("%s",line1);
 a90:	00000d97          	auipc	s11,0x0
 a94:	498d8d93          	addi	s11,s11,1176 # f28 <digits+0x40>
 a98:	a0cd                	j	b7a <uniq_run+0x1a8>
            if (repeatedLines){
 a9a:	020a0b63          	beqz	s4,ad0 <uniq_run+0xfe>
                if (isRepeated){
 a9e:	f80b87e3          	beqz	s7,a2c <uniq_run+0x5a>
                    if (showCount)
 aa2:	000c0d63          	beqz	s8,abc <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 aa6:	864a                	mv	a2,s2
 aa8:	85da                	mv	a1,s6
 aaa:	00000517          	auipc	a0,0x0
 aae:	4ae50513          	addi	a0,a0,1198 # f58 <digits+0x70>
 ab2:	00000097          	auipc	ra,0x0
 ab6:	cfa080e7          	jalr	-774(ra) # 7ac <printf>
 aba:	bf8d                	j	a2c <uniq_run+0x5a>
                      printf("%s",line1);
 abc:	85ca                	mv	a1,s2
 abe:	00000517          	auipc	a0,0x0
 ac2:	46a50513          	addi	a0,a0,1130 # f28 <digits+0x40>
 ac6:	00000097          	auipc	ra,0x0
 aca:	ce6080e7          	jalr	-794(ra) # 7ac <printf>
 ace:	bfb9                	j	a2c <uniq_run+0x5a>
                if (showCount)
 ad0:	000c0d63          	beqz	s8,aea <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 ad4:	864a                	mv	a2,s2
 ad6:	85da                	mv	a1,s6
 ad8:	00000517          	auipc	a0,0x0
 adc:	48050513          	addi	a0,a0,1152 # f58 <digits+0x70>
 ae0:	00000097          	auipc	ra,0x0
 ae4:	ccc080e7          	jalr	-820(ra) # 7ac <printf>
 ae8:	b791                	j	a2c <uniq_run+0x5a>
                  printf("%s",line1);
 aea:	85ca                	mv	a1,s2
 aec:	00000517          	auipc	a0,0x0
 af0:	43c50513          	addi	a0,a0,1084 # f28 <digits+0x40>
 af4:	00000097          	auipc	ra,0x0
 af8:	cb8080e7          	jalr	-840(ra) # 7ac <printf>
 afc:	bf05                	j	a2c <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 afe:	00000517          	auipc	a0,0x0
 b02:	46250513          	addi	a0,a0,1122 # f60 <digits+0x78>
 b06:	00000097          	auipc	ra,0x0
 b0a:	ca6080e7          	jalr	-858(ra) # 7ac <printf>
          break;
 b0e:	bf39                	j	a2c <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 b10:	85a6                	mv	a1,s1
 b12:	854a                	mv	a0,s2
 b14:	00000097          	auipc	ra,0x0
 b18:	110080e7          	jalr	272(ra) # c24 <compare_str_ic>
 b1c:	a041                	j	b9c <uniq_run+0x1ca>
                  printf("%s",line1);
 b1e:	85ca                	mv	a1,s2
 b20:	856e                	mv	a0,s11
 b22:	00000097          	auipc	ra,0x0
 b26:	c8a080e7          	jalr	-886(ra) # 7ac <printf>
        lineCount = 1;
 b2a:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 b2c:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b2e:	8926                	mv	s2,s1
                  printf("%s",line1);
 b30:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b32:	4b81                	li	s7,0
 b34:	a099                	j	b7a <uniq_run+0x1a8>
            if (showCount)
 b36:	020c0263          	beqz	s8,b5a <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 b3a:	864a                	mv	a2,s2
 b3c:	85da                	mv	a1,s6
 b3e:	00000517          	auipc	a0,0x0
 b42:	41a50513          	addi	a0,a0,1050 # f58 <digits+0x70>
 b46:	00000097          	auipc	ra,0x0
 b4a:	c66080e7          	jalr	-922(ra) # 7ac <printf>
 b4e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b50:	8926                	mv	s2,s1
 b52:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b54:	4b81                	li	s7,0
        lineCount = 1;
 b56:	8b6a                	mv	s6,s10
 b58:	a00d                	j	b7a <uniq_run+0x1a8>
              printf("%s",line1);
 b5a:	85ca                	mv	a1,s2
 b5c:	856e                	mv	a0,s11
 b5e:	00000097          	auipc	ra,0x0
 b62:	c4e080e7          	jalr	-946(ra) # 7ac <printf>
 b66:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b68:	8926                	mv	s2,s1
              printf("%s",line1);
 b6a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b6c:	4b81                	li	s7,0
        lineCount = 1;
 b6e:	8b6a                	mv	s6,s10
 b70:	a029                	j	b7a <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 b72:	000a0363          	beqz	s4,b78 <uniq_run+0x1a6>
 b76:	8bea                	mv	s7,s10
          lineCount++;
 b78:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 b7a:	85a6                	mv	a1,s1
 b7c:	854e                	mv	a0,s3
 b7e:	00000097          	auipc	ra,0x0
 b82:	196080e7          	jalr	406(ra) # d14 <read_line>
        if (readStatus == READ_EOF){
 b86:	d911                	beqz	a0,a9a <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 b88:	f7950be3          	beq	a0,s9,afe <uniq_run+0x12c>
        if (!ignoreCase)
 b8c:	f80a92e3          	bnez	s5,b10 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 b90:	85a6                	mv	a1,s1
 b92:	854a                	mv	a0,s2
 b94:	00000097          	auipc	ra,0x0
 b98:	062080e7          	jalr	98(ra) # bf6 <compare_str>
        if (compareStatus != 0){ 
 b9c:	d979                	beqz	a0,b72 <uniq_run+0x1a0>
          if (repeatedLines){
 b9e:	f80a0ce3          	beqz	s4,b36 <uniq_run+0x164>
            if (isRepeated){
 ba2:	ec0b8be3          	beqz	s7,a78 <uniq_run+0xa6>
                if (showCount)
 ba6:	f60c0ce3          	beqz	s8,b1e <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 baa:	864a                	mv	a2,s2
 bac:	85da                	mv	a1,s6
 bae:	00000517          	auipc	a0,0x0
 bb2:	3aa50513          	addi	a0,a0,938 # f58 <digits+0x70>
 bb6:	00000097          	auipc	ra,0x0
 bba:	bf6080e7          	jalr	-1034(ra) # 7ac <printf>
        lineCount = 1;
 bbe:	8b5e                	mv	s6,s7
 bc0:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 bc2:	8926                	mv	s2,s1
 bc4:	84be                	mv	s1,a5
        isRepeated = 0 ;
 bc6:	4b81                	li	s7,0
 bc8:	bf4d                	j	b7a <uniq_run+0x1a8>

0000000000000bca <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 bca:	1141                	addi	sp,sp,-16
 bcc:	e422                	sd	s0,8(sp)
 bce:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 bd0:	00054783          	lbu	a5,0(a0)
 bd4:	cf99                	beqz	a5,bf2 <get_strlen+0x28>
 bd6:	00150713          	addi	a4,a0,1
 bda:	87ba                	mv	a5,a4
 bdc:	4685                	li	a3,1
 bde:	9e99                	subw	a3,a3,a4
 be0:	00f6853b          	addw	a0,a3,a5
 be4:	0785                	addi	a5,a5,1
 be6:	fff7c703          	lbu	a4,-1(a5)
 bea:	fb7d                	bnez	a4,be0 <get_strlen+0x16>
	return len;
}
 bec:	6422                	ld	s0,8(sp)
 bee:	0141                	addi	sp,sp,16
 bf0:	8082                	ret
	int len = 0;
 bf2:	4501                	li	a0,0
 bf4:	bfe5                	j	bec <get_strlen+0x22>

0000000000000bf6 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 bf6:	1141                	addi	sp,sp,-16
 bf8:	e422                	sd	s0,8(sp)
 bfa:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 bfc:	00054783          	lbu	a5,0(a0)
 c00:	cb91                	beqz	a5,c14 <compare_str+0x1e>
 c02:	0005c703          	lbu	a4,0(a1)
 c06:	c719                	beqz	a4,c14 <compare_str+0x1e>
		if (*s1++ != *s2++)
 c08:	0505                	addi	a0,a0,1
 c0a:	0585                	addi	a1,a1,1
 c0c:	fee788e3          	beq	a5,a4,bfc <compare_str+0x6>
			return 1;
 c10:	4505                	li	a0,1
 c12:	a031                	j	c1e <compare_str+0x28>
	}
	if (*s1 == *s2)
 c14:	0005c503          	lbu	a0,0(a1)
 c18:	8d1d                	sub	a0,a0,a5
			return 1;
 c1a:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 c1e:	6422                	ld	s0,8(sp)
 c20:	0141                	addi	sp,sp,16
 c22:	8082                	ret

0000000000000c24 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 c24:	1141                	addi	sp,sp,-16
 c26:	e422                	sd	s0,8(sp)
 c28:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 c2a:	4665                	li	a2,25
	while(*s1 && *s2){
 c2c:	a019                	j	c32 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 c2e:	04e79763          	bne	a5,a4,c7c <compare_str_ic+0x58>
	while(*s1 && *s2){
 c32:	00054783          	lbu	a5,0(a0)
 c36:	cb9d                	beqz	a5,c6c <compare_str_ic+0x48>
 c38:	0005c703          	lbu	a4,0(a1)
 c3c:	cb05                	beqz	a4,c6c <compare_str_ic+0x48>
		char b1 = *s1++;
 c3e:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 c40:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 c42:	fbf7869b          	addiw	a3,a5,-65
 c46:	0ff6f693          	zext.b	a3,a3
 c4a:	00d66663          	bltu	a2,a3,c56 <compare_str_ic+0x32>
			b1 += 32;
 c4e:	0207879b          	addiw	a5,a5,32
 c52:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 c56:	fbf7069b          	addiw	a3,a4,-65
 c5a:	0ff6f693          	zext.b	a3,a3
 c5e:	fcd668e3          	bltu	a2,a3,c2e <compare_str_ic+0xa>
			b2 += 32;
 c62:	0207071b          	addiw	a4,a4,32
 c66:	0ff77713          	zext.b	a4,a4
 c6a:	b7d1                	j	c2e <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 c6c:	0005c503          	lbu	a0,0(a1)
 c70:	8d1d                	sub	a0,a0,a5
			return 1;
 c72:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 c76:	6422                	ld	s0,8(sp)
 c78:	0141                	addi	sp,sp,16
 c7a:	8082                	ret
			return 1;
 c7c:	4505                	li	a0,1
 c7e:	bfe5                	j	c76 <compare_str_ic+0x52>

0000000000000c80 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 c80:	7179                	addi	sp,sp,-48
 c82:	f406                	sd	ra,40(sp)
 c84:	f022                	sd	s0,32(sp)
 c86:	ec26                	sd	s1,24(sp)
 c88:	e84a                	sd	s2,16(sp)
 c8a:	e44e                	sd	s3,8(sp)
 c8c:	1800                	addi	s0,sp,48
 c8e:	89aa                	mv	s3,a0
 c90:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 c92:	00000097          	auipc	ra,0x0
 c96:	f38080e7          	jalr	-200(ra) # bca <get_strlen>
 c9a:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 c9c:	854a                	mv	a0,s2
 c9e:	00000097          	auipc	ra,0x0
 ca2:	f2c080e7          	jalr	-212(ra) # bca <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 ca6:	409505bb          	subw	a1,a0,s1
 caa:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 cac:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 cae:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 cb0:	0005da63          	bgez	a1,cc4 <check_substr+0x44>
 cb4:	a81d                	j	cea <check_substr+0x6a>
        if (j == M)
 cb6:	02f48a63          	beq	s1,a5,cea <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 cba:	0885                	addi	a7,a7,1
 cbc:	0008879b          	sext.w	a5,a7
 cc0:	02f5cc63          	blt	a1,a5,cf8 <check_substr+0x78>
 cc4:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 cc8:	011906b3          	add	a3,s2,a7
 ccc:	874e                	mv	a4,s3
 cce:	879a                	mv	a5,t1
 cd0:	fe9053e3          	blez	s1,cb6 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 cd4:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 cd8:	00074603          	lbu	a2,0(a4)
 cdc:	fcc81de3          	bne	a6,a2,cb6 <check_substr+0x36>
        for (j = 0; j < M; j++)
 ce0:	2785                	addiw	a5,a5,1
 ce2:	0685                	addi	a3,a3,1
 ce4:	0705                	addi	a4,a4,1
 ce6:	fef497e3          	bne	s1,a5,cd4 <check_substr+0x54>
}
 cea:	70a2                	ld	ra,40(sp)
 cec:	7402                	ld	s0,32(sp)
 cee:	64e2                	ld	s1,24(sp)
 cf0:	6942                	ld	s2,16(sp)
 cf2:	69a2                	ld	s3,8(sp)
 cf4:	6145                	addi	sp,sp,48
 cf6:	8082                	ret
    return -1;
 cf8:	557d                	li	a0,-1
 cfa:	bfc5                	j	cea <check_substr+0x6a>

0000000000000cfc <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 cfc:	1141                	addi	sp,sp,-16
 cfe:	e406                	sd	ra,8(sp)
 d00:	e022                	sd	s0,0(sp)
 d02:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 d04:	fffff097          	auipc	ra,0xfffff
 d08:	746080e7          	jalr	1862(ra) # 44a <open>
	return fd;
}
 d0c:	60a2                	ld	ra,8(sp)
 d0e:	6402                	ld	s0,0(sp)
 d10:	0141                	addi	sp,sp,16
 d12:	8082                	ret

0000000000000d14 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 d14:	7139                	addi	sp,sp,-64
 d16:	fc06                	sd	ra,56(sp)
 d18:	f822                	sd	s0,48(sp)
 d1a:	f426                	sd	s1,40(sp)
 d1c:	f04a                	sd	s2,32(sp)
 d1e:	ec4e                	sd	s3,24(sp)
 d20:	e852                	sd	s4,16(sp)
 d22:	0080                	addi	s0,sp,64
 d24:	89aa                	mv	s3,a0
 d26:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 d28:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 d2a:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 d2c:	4605                	li	a2,1
 d2e:	fcf40593          	addi	a1,s0,-49
 d32:	854e                	mv	a0,s3
 d34:	fffff097          	auipc	ra,0xfffff
 d38:	6ee080e7          	jalr	1774(ra) # 422 <read>
		if (readStatus == 0){
 d3c:	c505                	beqz	a0,d64 <read_line+0x50>
		*buffer++ = readByte;
 d3e:	0485                	addi	s1,s1,1
 d40:	fcf44783          	lbu	a5,-49(s0)
 d44:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 d48:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 d4a:	ff4791e3          	bne	a5,s4,d2c <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 d4e:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 d52:	854a                	mv	a0,s2
 d54:	70e2                	ld	ra,56(sp)
 d56:	7442                	ld	s0,48(sp)
 d58:	74a2                	ld	s1,40(sp)
 d5a:	7902                	ld	s2,32(sp)
 d5c:	69e2                	ld	s3,24(sp)
 d5e:	6a42                	ld	s4,16(sp)
 d60:	6121                	addi	sp,sp,64
 d62:	8082                	ret
			if (byteCount!=0){
 d64:	fe0907e3          	beqz	s2,d52 <read_line+0x3e>
				*buffer = '\n';
 d68:	47a9                	li	a5,10
 d6a:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 d6e:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 d72:	2905                	addiw	s2,s2,1
 d74:	bff9                	j	d52 <read_line+0x3e>

0000000000000d76 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 d76:	1141                	addi	sp,sp,-16
 d78:	e406                	sd	ra,8(sp)
 d7a:	e022                	sd	s0,0(sp)
 d7c:	0800                	addi	s0,sp,16
	close(fd);
 d7e:	fffff097          	auipc	ra,0xfffff
 d82:	6b4080e7          	jalr	1716(ra) # 432 <close>
}
 d86:	60a2                	ld	ra,8(sp)
 d88:	6402                	ld	s0,0(sp)
 d8a:	0141                	addi	sp,sp,16
 d8c:	8082                	ret

0000000000000d8e <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 d8e:	7139                	addi	sp,sp,-64
 d90:	fc06                	sd	ra,56(sp)
 d92:	f822                	sd	s0,48(sp)
 d94:	f426                	sd	s1,40(sp)
 d96:	f04a                	sd	s2,32(sp)
 d98:	0080                	addi	s0,sp,64
 d9a:	84aa                	mv	s1,a0
 d9c:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 d9e:	fffff097          	auipc	ra,0xfffff
 da2:	664080e7          	jalr	1636(ra) # 402 <fork>
 da6:	ed19                	bnez	a0,dc4 <get_time_perf+0x36>
		exec(argv[0],argv);
 da8:	85ca                	mv	a1,s2
 daa:	00093503          	ld	a0,0(s2)
 dae:	fffff097          	auipc	ra,0xfffff
 db2:	694080e7          	jalr	1684(ra) # 442 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 db6:	8526                	mv	a0,s1
 db8:	70e2                	ld	ra,56(sp)
 dba:	7442                	ld	s0,48(sp)
 dbc:	74a2                	ld	s1,40(sp)
 dbe:	7902                	ld	s2,32(sp)
 dc0:	6121                	addi	sp,sp,64
 dc2:	8082                	ret
		times(pid , &time);
 dc4:	fc840593          	addi	a1,s0,-56
 dc8:	fffff097          	auipc	ra,0xfffff
 dcc:	6fa080e7          	jalr	1786(ra) # 4c2 <times>
		return time;
 dd0:	fc843783          	ld	a5,-56(s0)
 dd4:	e09c                	sd	a5,0(s1)
 dd6:	fd043783          	ld	a5,-48(s0)
 dda:	e49c                	sd	a5,8(s1)
 ddc:	fd843783          	ld	a5,-40(s0)
 de0:	e89c                	sd	a5,16(s1)
 de2:	bfd1                	j	db6 <get_time_perf+0x28>
