
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	d5250513          	addi	a0,a0,-686 # d60 <get_time_perf+0x5e>
  16:	00000097          	auipc	ra,0x0
  1a:	3a8080e7          	jalr	936(ra) # 3be <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3d2080e7          	jalr	978(ra) # 3f6 <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3c8080e7          	jalr	968(ra) # 3f6 <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	d3290913          	addi	s2,s2,-718 # d68 <get_time_perf+0x66>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6e0080e7          	jalr	1760(ra) # 720 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	32e080e7          	jalr	814(ra) # 376 <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	32c080e7          	jalr	812(ra) # 386 <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	d4e50513          	addi	a0,a0,-690 # db8 <get_time_perf+0xb6>
  72:	00000097          	auipc	ra,0x0
  76:	6ae080e7          	jalr	1710(ra) # 720 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	302080e7          	jalr	770(ra) # 37e <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	cd850513          	addi	a0,a0,-808 # d60 <get_time_perf+0x5e>
  90:	00000097          	auipc	ra,0x0
  94:	336080e7          	jalr	822(ra) # 3c6 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	cc650513          	addi	a0,a0,-826 # d60 <get_time_perf+0x5e>
  a2:	00000097          	auipc	ra,0x0
  a6:	31c080e7          	jalr	796(ra) # 3be <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	cd450513          	addi	a0,a0,-812 # d80 <get_time_perf+0x7e>
  b4:	00000097          	auipc	ra,0x0
  b8:	66c080e7          	jalr	1644(ra) # 720 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2c0080e7          	jalr	704(ra) # 37e <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f3a58593          	addi	a1,a1,-198 # 1000 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	cca50513          	addi	a0,a0,-822 # d98 <get_time_perf+0x96>
  d6:	00000097          	auipc	ra,0x0
  da:	2e0080e7          	jalr	736(ra) # 3b6 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	cc250513          	addi	a0,a0,-830 # da0 <get_time_perf+0x9e>
  e6:	00000097          	auipc	ra,0x0
  ea:	63a080e7          	jalr	1594(ra) # 720 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	28e080e7          	jalr	654(ra) # 37e <exit>

00000000000000f8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  extern int main();
  main();
 100:	00000097          	auipc	ra,0x0
 104:	f00080e7          	jalr	-256(ra) # 0 <main>
  exit(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	274080e7          	jalr	628(ra) # 37e <exit>

0000000000000112 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 118:	87aa                	mv	a5,a0
 11a:	0585                	addi	a1,a1,1
 11c:	0785                	addi	a5,a5,1
 11e:	fff5c703          	lbu	a4,-1(a1)
 122:	fee78fa3          	sb	a4,-1(a5)
 126:	fb75                	bnez	a4,11a <strcpy+0x8>
    ;
  return os;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb91                	beqz	a5,14c <strcmp+0x1e>
 13a:	0005c703          	lbu	a4,0(a1)
 13e:	00f71763          	bne	a4,a5,14c <strcmp+0x1e>
    p++, q++;
 142:	0505                	addi	a0,a0,1
 144:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbe5                	bnez	a5,13a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14c:	0005c503          	lbu	a0,0(a1)
}
 150:	40a7853b          	subw	a0,a5,a0
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <strlen>:

uint
strlen(const char *s)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 160:	00054783          	lbu	a5,0(a0)
 164:	cf91                	beqz	a5,180 <strlen+0x26>
 166:	0505                	addi	a0,a0,1
 168:	87aa                	mv	a5,a0
 16a:	4685                	li	a3,1
 16c:	9e89                	subw	a3,a3,a0
 16e:	00f6853b          	addw	a0,a3,a5
 172:	0785                	addi	a5,a5,1
 174:	fff7c703          	lbu	a4,-1(a5)
 178:	fb7d                	bnez	a4,16e <strlen+0x14>
    ;
  return n;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret
  for(n = 0; s[n]; n++)
 180:	4501                	li	a0,0
 182:	bfe5                	j	17a <strlen+0x20>

0000000000000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18a:	ca19                	beqz	a2,1a0 <memset+0x1c>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	slli	a2,a2,0x20
 190:	9201                	srli	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19a:	0785                	addi	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x12>
  }
  return dst;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strchr>:

char*
strchr(const char *s, char c)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cb99                	beqz	a5,1c6 <strchr+0x20>
    if(*s == c)
 1b2:	00f58763          	beq	a1,a5,1c0 <strchr+0x1a>
  for(; *s; s++)
 1b6:	0505                	addi	a0,a0,1
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbfd                	bnez	a5,1b2 <strchr+0xc>
      return (char*)s;
  return 0;
 1be:	4501                	li	a0,0
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret
  return 0;
 1c6:	4501                	li	a0,0
 1c8:	bfe5                	j	1c0 <strchr+0x1a>

00000000000001ca <gets>:

char*
gets(char *buf, int max)
{
 1ca:	711d                	addi	sp,sp,-96
 1cc:	ec86                	sd	ra,88(sp)
 1ce:	e8a2                	sd	s0,80(sp)
 1d0:	e4a6                	sd	s1,72(sp)
 1d2:	e0ca                	sd	s2,64(sp)
 1d4:	fc4e                	sd	s3,56(sp)
 1d6:	f852                	sd	s4,48(sp)
 1d8:	f456                	sd	s5,40(sp)
 1da:	f05a                	sd	s6,32(sp)
 1dc:	ec5e                	sd	s7,24(sp)
 1de:	1080                	addi	s0,sp,96
 1e0:	8baa                	mv	s7,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e8:	4aa9                	li	s5,10
 1ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ec:	89a6                	mv	s3,s1
 1ee:	2485                	addiw	s1,s1,1
 1f0:	0344d863          	bge	s1,s4,220 <gets+0x56>
    cc = read(0, &c, 1);
 1f4:	4605                	li	a2,1
 1f6:	faf40593          	addi	a1,s0,-81
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	19a080e7          	jalr	410(ra) # 396 <read>
    if(cc < 1)
 204:	00a05e63          	blez	a0,220 <gets+0x56>
    buf[i++] = c;
 208:	faf44783          	lbu	a5,-81(s0)
 20c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 210:	01578763          	beq	a5,s5,21e <gets+0x54>
 214:	0905                	addi	s2,s2,1
 216:	fd679be3          	bne	a5,s6,1ec <gets+0x22>
  for(i=0; i+1 < max; ){
 21a:	89a6                	mv	s3,s1
 21c:	a011                	j	220 <gets+0x56>
 21e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 220:	99de                	add	s3,s3,s7
 222:	00098023          	sb	zero,0(s3)
  return buf;
}
 226:	855e                	mv	a0,s7
 228:	60e6                	ld	ra,88(sp)
 22a:	6446                	ld	s0,80(sp)
 22c:	64a6                	ld	s1,72(sp)
 22e:	6906                	ld	s2,64(sp)
 230:	79e2                	ld	s3,56(sp)
 232:	7a42                	ld	s4,48(sp)
 234:	7aa2                	ld	s5,40(sp)
 236:	7b02                	ld	s6,32(sp)
 238:	6be2                	ld	s7,24(sp)
 23a:	6125                	addi	sp,sp,96
 23c:	8082                	ret

000000000000023e <stat>:

int
stat(const char *n, struct stat *st)
{
 23e:	1101                	addi	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	e426                	sd	s1,8(sp)
 246:	e04a                	sd	s2,0(sp)
 248:	1000                	addi	s0,sp,32
 24a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24c:	4581                	li	a1,0
 24e:	00000097          	auipc	ra,0x0
 252:	170080e7          	jalr	368(ra) # 3be <open>
  if(fd < 0)
 256:	02054563          	bltz	a0,280 <stat+0x42>
 25a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25c:	85ca                	mv	a1,s2
 25e:	00000097          	auipc	ra,0x0
 262:	178080e7          	jalr	376(ra) # 3d6 <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	00000097          	auipc	ra,0x0
 26e:	13c080e7          	jalr	316(ra) # 3a6 <close>
  return r;
}
 272:	854a                	mv	a0,s2
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	64a2                	ld	s1,8(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	addi	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	597d                	li	s2,-1
 282:	bfc5                	j	272 <stat+0x34>

0000000000000284 <atoi>:

int
atoi(const char *s)
{
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28a:	00054683          	lbu	a3,0(a0)
 28e:	fd06879b          	addiw	a5,a3,-48
 292:	0ff7f793          	zext.b	a5,a5
 296:	4625                	li	a2,9
 298:	02f66863          	bltu	a2,a5,2c8 <atoi+0x44>
 29c:	872a                	mv	a4,a0
  n = 0;
 29e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a0:	0705                	addi	a4,a4,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb5                	addw	a5,a5,a3
 2ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b2:	00074683          	lbu	a3,0(a4)
 2b6:	fd06879b          	addiw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	fef671e3          	bgeu	a2,a5,2a0 <atoi+0x1c>
  return n;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  n = 0;
 2c8:	4501                	li	a0,0
 2ca:	bfe5                	j	2c2 <atoi+0x3e>

00000000000002cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d2:	02b57463          	bgeu	a0,a1,2fa <memmove+0x2e>
    while(n-- > 0)
 2d6:	00c05f63          	blez	a2,2f4 <memmove+0x28>
 2da:	1602                	slli	a2,a2,0x20
 2dc:	9201                	srli	a2,a2,0x20
 2de:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e4:	0585                	addi	a1,a1,1
 2e6:	0705                	addi	a4,a4,1
 2e8:	fff5c683          	lbu	a3,-1(a1)
 2ec:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f0:	fee79ae3          	bne	a5,a4,2e4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
    dst += n;
 2fa:	00c50733          	add	a4,a0,a2
    src += n;
 2fe:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 300:	fec05ae3          	blez	a2,2f4 <memmove+0x28>
 304:	fff6079b          	addiw	a5,a2,-1
 308:	1782                	slli	a5,a5,0x20
 30a:	9381                	srli	a5,a5,0x20
 30c:	fff7c793          	not	a5,a5
 310:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 312:	15fd                	addi	a1,a1,-1
 314:	177d                	addi	a4,a4,-1
 316:	0005c683          	lbu	a3,0(a1)
 31a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31e:	fee79ae3          	bne	a5,a4,312 <memmove+0x46>
 322:	bfc9                	j	2f4 <memmove+0x28>

0000000000000324 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 32a:	ca05                	beqz	a2,35a <memcmp+0x36>
 32c:	fff6069b          	addiw	a3,a2,-1
 330:	1682                	slli	a3,a3,0x20
 332:	9281                	srli	a3,a3,0x20
 334:	0685                	addi	a3,a3,1
 336:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 338:	00054783          	lbu	a5,0(a0)
 33c:	0005c703          	lbu	a4,0(a1)
 340:	00e79863          	bne	a5,a4,350 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 344:	0505                	addi	a0,a0,1
    p2++;
 346:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 348:	fed518e3          	bne	a0,a3,338 <memcmp+0x14>
  }
  return 0;
 34c:	4501                	li	a0,0
 34e:	a019                	j	354 <memcmp+0x30>
      return *p1 - *p2;
 350:	40e7853b          	subw	a0,a5,a4
}
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret
  return 0;
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <memcmp+0x30>

000000000000035e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e406                	sd	ra,8(sp)
 362:	e022                	sd	s0,0(sp)
 364:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 366:	00000097          	auipc	ra,0x0
 36a:	f66080e7          	jalr	-154(ra) # 2cc <memmove>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 376:	4885                	li	a7,1
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <exit>:
.global exit
exit:
 li a7, SYS_exit
 37e:	4889                	li	a7,2
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <wait>:
.global wait
wait:
 li a7, SYS_wait
 386:	488d                	li	a7,3
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38e:	4891                	li	a7,4
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <read>:
.global read
read:
 li a7, SYS_read
 396:	4895                	li	a7,5
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <write>:
.global write
write:
 li a7, SYS_write
 39e:	48c1                	li	a7,16
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <close>:
.global close
close:
 li a7, SYS_close
 3a6:	48d5                	li	a7,21
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ae:	4899                	li	a7,6
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b6:	489d                	li	a7,7
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <open>:
.global open
open:
 li a7, SYS_open
 3be:	48bd                	li	a7,15
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c6:	48c5                	li	a7,17
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ce:	48c9                	li	a7,18
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d6:	48a1                	li	a7,8
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <link>:
.global link
link:
 li a7, SYS_link
 3de:	48cd                	li	a7,19
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e6:	48d1                	li	a7,20
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ee:	48a5                	li	a7,9
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f6:	48a9                	li	a7,10
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fe:	48ad                	li	a7,11
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 406:	48b1                	li	a7,12
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 40e:	48b5                	li	a7,13
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 416:	48b9                	li	a7,14
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <head>:
.global head
head:
 li a7, SYS_head
 41e:	48d9                	li	a7,22
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 426:	48dd                	li	a7,23
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <ps>:
.global ps
ps:
 li a7, SYS_ps
 42e:	48e1                	li	a7,24
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <times>:
.global times
times:
 li a7, SYS_times
 436:	48e5                	li	a7,25
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 43e:	48e9                	li	a7,26
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 446:	1101                	addi	sp,sp,-32
 448:	ec06                	sd	ra,24(sp)
 44a:	e822                	sd	s0,16(sp)
 44c:	1000                	addi	s0,sp,32
 44e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 452:	4605                	li	a2,1
 454:	fef40593          	addi	a1,s0,-17
 458:	00000097          	auipc	ra,0x0
 45c:	f46080e7          	jalr	-186(ra) # 39e <write>
}
 460:	60e2                	ld	ra,24(sp)
 462:	6442                	ld	s0,16(sp)
 464:	6105                	addi	sp,sp,32
 466:	8082                	ret

0000000000000468 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 468:	7139                	addi	sp,sp,-64
 46a:	fc06                	sd	ra,56(sp)
 46c:	f822                	sd	s0,48(sp)
 46e:	f426                	sd	s1,40(sp)
 470:	f04a                	sd	s2,32(sp)
 472:	ec4e                	sd	s3,24(sp)
 474:	0080                	addi	s0,sp,64
 476:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 478:	c299                	beqz	a3,47e <printint+0x16>
 47a:	0805c963          	bltz	a1,50c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 47e:	2581                	sext.w	a1,a1
  neg = 0;
 480:	4881                	li	a7,0
 482:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 486:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 488:	2601                	sext.w	a2,a2
 48a:	00001517          	auipc	a0,0x1
 48e:	9ae50513          	addi	a0,a0,-1618 # e38 <digits>
 492:	883a                	mv	a6,a4
 494:	2705                	addiw	a4,a4,1
 496:	02c5f7bb          	remuw	a5,a1,a2
 49a:	1782                	slli	a5,a5,0x20
 49c:	9381                	srli	a5,a5,0x20
 49e:	97aa                	add	a5,a5,a0
 4a0:	0007c783          	lbu	a5,0(a5)
 4a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a8:	0005879b          	sext.w	a5,a1
 4ac:	02c5d5bb          	divuw	a1,a1,a2
 4b0:	0685                	addi	a3,a3,1
 4b2:	fec7f0e3          	bgeu	a5,a2,492 <printint+0x2a>
  if(neg)
 4b6:	00088c63          	beqz	a7,4ce <printint+0x66>
    buf[i++] = '-';
 4ba:	fd070793          	addi	a5,a4,-48
 4be:	00878733          	add	a4,a5,s0
 4c2:	02d00793          	li	a5,45
 4c6:	fef70823          	sb	a5,-16(a4)
 4ca:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ce:	02e05863          	blez	a4,4fe <printint+0x96>
 4d2:	fc040793          	addi	a5,s0,-64
 4d6:	00e78933          	add	s2,a5,a4
 4da:	fff78993          	addi	s3,a5,-1
 4de:	99ba                	add	s3,s3,a4
 4e0:	377d                	addiw	a4,a4,-1
 4e2:	1702                	slli	a4,a4,0x20
 4e4:	9301                	srli	a4,a4,0x20
 4e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ea:	fff94583          	lbu	a1,-1(s2)
 4ee:	8526                	mv	a0,s1
 4f0:	00000097          	auipc	ra,0x0
 4f4:	f56080e7          	jalr	-170(ra) # 446 <putc>
  while(--i >= 0)
 4f8:	197d                	addi	s2,s2,-1
 4fa:	ff3918e3          	bne	s2,s3,4ea <printint+0x82>
}
 4fe:	70e2                	ld	ra,56(sp)
 500:	7442                	ld	s0,48(sp)
 502:	74a2                	ld	s1,40(sp)
 504:	7902                	ld	s2,32(sp)
 506:	69e2                	ld	s3,24(sp)
 508:	6121                	addi	sp,sp,64
 50a:	8082                	ret
    x = -xx;
 50c:	40b005bb          	negw	a1,a1
    neg = 1;
 510:	4885                	li	a7,1
    x = -xx;
 512:	bf85                	j	482 <printint+0x1a>

0000000000000514 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 514:	7119                	addi	sp,sp,-128
 516:	fc86                	sd	ra,120(sp)
 518:	f8a2                	sd	s0,112(sp)
 51a:	f4a6                	sd	s1,104(sp)
 51c:	f0ca                	sd	s2,96(sp)
 51e:	ecce                	sd	s3,88(sp)
 520:	e8d2                	sd	s4,80(sp)
 522:	e4d6                	sd	s5,72(sp)
 524:	e0da                	sd	s6,64(sp)
 526:	fc5e                	sd	s7,56(sp)
 528:	f862                	sd	s8,48(sp)
 52a:	f466                	sd	s9,40(sp)
 52c:	f06a                	sd	s10,32(sp)
 52e:	ec6e                	sd	s11,24(sp)
 530:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 532:	0005c903          	lbu	s2,0(a1)
 536:	18090f63          	beqz	s2,6d4 <vprintf+0x1c0>
 53a:	8aaa                	mv	s5,a0
 53c:	8b32                	mv	s6,a2
 53e:	00158493          	addi	s1,a1,1
  state = 0;
 542:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 544:	02500a13          	li	s4,37
 548:	4c55                	li	s8,21
 54a:	00001c97          	auipc	s9,0x1
 54e:	896c8c93          	addi	s9,s9,-1898 # de0 <get_time_perf+0xde>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 552:	02800d93          	li	s11,40
  putc(fd, 'x');
 556:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 558:	00001b97          	auipc	s7,0x1
 55c:	8e0b8b93          	addi	s7,s7,-1824 # e38 <digits>
 560:	a839                	j	57e <vprintf+0x6a>
        putc(fd, c);
 562:	85ca                	mv	a1,s2
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	ee0080e7          	jalr	-288(ra) # 446 <putc>
 56e:	a019                	j	574 <vprintf+0x60>
    } else if(state == '%'){
 570:	01498d63          	beq	s3,s4,58a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 574:	0485                	addi	s1,s1,1
 576:	fff4c903          	lbu	s2,-1(s1)
 57a:	14090d63          	beqz	s2,6d4 <vprintf+0x1c0>
    if(state == 0){
 57e:	fe0999e3          	bnez	s3,570 <vprintf+0x5c>
      if(c == '%'){
 582:	ff4910e3          	bne	s2,s4,562 <vprintf+0x4e>
        state = '%';
 586:	89d2                	mv	s3,s4
 588:	b7f5                	j	574 <vprintf+0x60>
      if(c == 'd'){
 58a:	11490c63          	beq	s2,s4,6a2 <vprintf+0x18e>
 58e:	f9d9079b          	addiw	a5,s2,-99
 592:	0ff7f793          	zext.b	a5,a5
 596:	10fc6e63          	bltu	s8,a5,6b2 <vprintf+0x19e>
 59a:	f9d9079b          	addiw	a5,s2,-99
 59e:	0ff7f713          	zext.b	a4,a5
 5a2:	10ec6863          	bltu	s8,a4,6b2 <vprintf+0x19e>
 5a6:	00271793          	slli	a5,a4,0x2
 5aa:	97e6                	add	a5,a5,s9
 5ac:	439c                	lw	a5,0(a5)
 5ae:	97e6                	add	a5,a5,s9
 5b0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5b2:	008b0913          	addi	s2,s6,8
 5b6:	4685                	li	a3,1
 5b8:	4629                	li	a2,10
 5ba:	000b2583          	lw	a1,0(s6)
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	ea8080e7          	jalr	-344(ra) # 468 <printint>
 5c8:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b765                	j	574 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ce:	008b0913          	addi	s2,s6,8
 5d2:	4681                	li	a3,0
 5d4:	4629                	li	a2,10
 5d6:	000b2583          	lw	a1,0(s6)
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	e8c080e7          	jalr	-372(ra) # 468 <printint>
 5e4:	8b4a                	mv	s6,s2
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	b771                	j	574 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5ea:	008b0913          	addi	s2,s6,8
 5ee:	4681                	li	a3,0
 5f0:	866a                	mv	a2,s10
 5f2:	000b2583          	lw	a1,0(s6)
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e70080e7          	jalr	-400(ra) # 468 <printint>
 600:	8b4a                	mv	s6,s2
      state = 0;
 602:	4981                	li	s3,0
 604:	bf85                	j	574 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 606:	008b0793          	addi	a5,s6,8
 60a:	f8f43423          	sd	a5,-120(s0)
 60e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 612:	03000593          	li	a1,48
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	e2e080e7          	jalr	-466(ra) # 446 <putc>
  putc(fd, 'x');
 620:	07800593          	li	a1,120
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	e20080e7          	jalr	-480(ra) # 446 <putc>
 62e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 630:	03c9d793          	srli	a5,s3,0x3c
 634:	97de                	add	a5,a5,s7
 636:	0007c583          	lbu	a1,0(a5)
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	e0a080e7          	jalr	-502(ra) # 446 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 644:	0992                	slli	s3,s3,0x4
 646:	397d                	addiw	s2,s2,-1
 648:	fe0914e3          	bnez	s2,630 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 64c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 650:	4981                	li	s3,0
 652:	b70d                	j	574 <vprintf+0x60>
        s = va_arg(ap, char*);
 654:	008b0913          	addi	s2,s6,8
 658:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 65c:	02098163          	beqz	s3,67e <vprintf+0x16a>
        while(*s != 0){
 660:	0009c583          	lbu	a1,0(s3)
 664:	c5ad                	beqz	a1,6ce <vprintf+0x1ba>
          putc(fd, *s);
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	dde080e7          	jalr	-546(ra) # 446 <putc>
          s++;
 670:	0985                	addi	s3,s3,1
        while(*s != 0){
 672:	0009c583          	lbu	a1,0(s3)
 676:	f9e5                	bnez	a1,666 <vprintf+0x152>
        s = va_arg(ap, char*);
 678:	8b4a                	mv	s6,s2
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bde5                	j	574 <vprintf+0x60>
          s = "(null)";
 67e:	00000997          	auipc	s3,0x0
 682:	75a98993          	addi	s3,s3,1882 # dd8 <get_time_perf+0xd6>
        while(*s != 0){
 686:	85ee                	mv	a1,s11
 688:	bff9                	j	666 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 68a:	008b0913          	addi	s2,s6,8
 68e:	000b4583          	lbu	a1,0(s6)
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	db2080e7          	jalr	-590(ra) # 446 <putc>
 69c:	8b4a                	mv	s6,s2
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	bdd1                	j	574 <vprintf+0x60>
        putc(fd, c);
 6a2:	85d2                	mv	a1,s4
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	da0080e7          	jalr	-608(ra) # 446 <putc>
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b5d1                	j	574 <vprintf+0x60>
        putc(fd, '%');
 6b2:	85d2                	mv	a1,s4
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	d90080e7          	jalr	-624(ra) # 446 <putc>
        putc(fd, c);
 6be:	85ca                	mv	a1,s2
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	d84080e7          	jalr	-636(ra) # 446 <putc>
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b565                	j	574 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ce:	8b4a                	mv	s6,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b54d                	j	574 <vprintf+0x60>
    }
  }
}
 6d4:	70e6                	ld	ra,120(sp)
 6d6:	7446                	ld	s0,112(sp)
 6d8:	74a6                	ld	s1,104(sp)
 6da:	7906                	ld	s2,96(sp)
 6dc:	69e6                	ld	s3,88(sp)
 6de:	6a46                	ld	s4,80(sp)
 6e0:	6aa6                	ld	s5,72(sp)
 6e2:	6b06                	ld	s6,64(sp)
 6e4:	7be2                	ld	s7,56(sp)
 6e6:	7c42                	ld	s8,48(sp)
 6e8:	7ca2                	ld	s9,40(sp)
 6ea:	7d02                	ld	s10,32(sp)
 6ec:	6de2                	ld	s11,24(sp)
 6ee:	6109                	addi	sp,sp,128
 6f0:	8082                	ret

00000000000006f2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f2:	715d                	addi	sp,sp,-80
 6f4:	ec06                	sd	ra,24(sp)
 6f6:	e822                	sd	s0,16(sp)
 6f8:	1000                	addi	s0,sp,32
 6fa:	e010                	sd	a2,0(s0)
 6fc:	e414                	sd	a3,8(s0)
 6fe:	e818                	sd	a4,16(s0)
 700:	ec1c                	sd	a5,24(s0)
 702:	03043023          	sd	a6,32(s0)
 706:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 70a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70e:	8622                	mv	a2,s0
 710:	00000097          	auipc	ra,0x0
 714:	e04080e7          	jalr	-508(ra) # 514 <vprintf>
}
 718:	60e2                	ld	ra,24(sp)
 71a:	6442                	ld	s0,16(sp)
 71c:	6161                	addi	sp,sp,80
 71e:	8082                	ret

0000000000000720 <printf>:

void
printf(const char *fmt, ...)
{
 720:	711d                	addi	sp,sp,-96
 722:	ec06                	sd	ra,24(sp)
 724:	e822                	sd	s0,16(sp)
 726:	1000                	addi	s0,sp,32
 728:	e40c                	sd	a1,8(s0)
 72a:	e810                	sd	a2,16(s0)
 72c:	ec14                	sd	a3,24(s0)
 72e:	f018                	sd	a4,32(s0)
 730:	f41c                	sd	a5,40(s0)
 732:	03043823          	sd	a6,48(s0)
 736:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 73a:	00840613          	addi	a2,s0,8
 73e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 742:	85aa                	mv	a1,a0
 744:	4505                	li	a0,1
 746:	00000097          	auipc	ra,0x0
 74a:	dce080e7          	jalr	-562(ra) # 514 <vprintf>
}
 74e:	60e2                	ld	ra,24(sp)
 750:	6442                	ld	s0,16(sp)
 752:	6125                	addi	sp,sp,96
 754:	8082                	ret

0000000000000756 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 756:	1141                	addi	sp,sp,-16
 758:	e422                	sd	s0,8(sp)
 75a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 760:	00001797          	auipc	a5,0x1
 764:	8b07b783          	ld	a5,-1872(a5) # 1010 <freep>
 768:	a02d                	j	792 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 76a:	4618                	lw	a4,8(a2)
 76c:	9f2d                	addw	a4,a4,a1
 76e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 772:	6398                	ld	a4,0(a5)
 774:	6310                	ld	a2,0(a4)
 776:	a83d                	j	7b4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 778:	ff852703          	lw	a4,-8(a0)
 77c:	9f31                	addw	a4,a4,a2
 77e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 780:	ff053683          	ld	a3,-16(a0)
 784:	a091                	j	7c8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 786:	6398                	ld	a4,0(a5)
 788:	00e7e463          	bltu	a5,a4,790 <free+0x3a>
 78c:	00e6ea63          	bltu	a3,a4,7a0 <free+0x4a>
{
 790:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 792:	fed7fae3          	bgeu	a5,a3,786 <free+0x30>
 796:	6398                	ld	a4,0(a5)
 798:	00e6e463          	bltu	a3,a4,7a0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79c:	fee7eae3          	bltu	a5,a4,790 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7a0:	ff852583          	lw	a1,-8(a0)
 7a4:	6390                	ld	a2,0(a5)
 7a6:	02059813          	slli	a6,a1,0x20
 7aa:	01c85713          	srli	a4,a6,0x1c
 7ae:	9736                	add	a4,a4,a3
 7b0:	fae60de3          	beq	a2,a4,76a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7b4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b8:	4790                	lw	a2,8(a5)
 7ba:	02061593          	slli	a1,a2,0x20
 7be:	01c5d713          	srli	a4,a1,0x1c
 7c2:	973e                	add	a4,a4,a5
 7c4:	fae68ae3          	beq	a3,a4,778 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7c8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ca:	00001717          	auipc	a4,0x1
 7ce:	84f73323          	sd	a5,-1978(a4) # 1010 <freep>
}
 7d2:	6422                	ld	s0,8(sp)
 7d4:	0141                	addi	sp,sp,16
 7d6:	8082                	ret

00000000000007d8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d8:	7139                	addi	sp,sp,-64
 7da:	fc06                	sd	ra,56(sp)
 7dc:	f822                	sd	s0,48(sp)
 7de:	f426                	sd	s1,40(sp)
 7e0:	f04a                	sd	s2,32(sp)
 7e2:	ec4e                	sd	s3,24(sp)
 7e4:	e852                	sd	s4,16(sp)
 7e6:	e456                	sd	s5,8(sp)
 7e8:	e05a                	sd	s6,0(sp)
 7ea:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ec:	02051493          	slli	s1,a0,0x20
 7f0:	9081                	srli	s1,s1,0x20
 7f2:	04bd                	addi	s1,s1,15
 7f4:	8091                	srli	s1,s1,0x4
 7f6:	0014899b          	addiw	s3,s1,1
 7fa:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7fc:	00001517          	auipc	a0,0x1
 800:	81453503          	ld	a0,-2028(a0) # 1010 <freep>
 804:	c515                	beqz	a0,830 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 806:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 808:	4798                	lw	a4,8(a5)
 80a:	02977f63          	bgeu	a4,s1,848 <malloc+0x70>
 80e:	8a4e                	mv	s4,s3
 810:	0009871b          	sext.w	a4,s3
 814:	6685                	lui	a3,0x1
 816:	00d77363          	bgeu	a4,a3,81c <malloc+0x44>
 81a:	6a05                	lui	s4,0x1
 81c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 820:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 824:	00000917          	auipc	s2,0x0
 828:	7ec90913          	addi	s2,s2,2028 # 1010 <freep>
  if(p == (char*)-1)
 82c:	5afd                	li	s5,-1
 82e:	a895                	j	8a2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 830:	00000797          	auipc	a5,0x0
 834:	7f078793          	addi	a5,a5,2032 # 1020 <base>
 838:	00000717          	auipc	a4,0x0
 83c:	7cf73c23          	sd	a5,2008(a4) # 1010 <freep>
 840:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 842:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 846:	b7e1                	j	80e <malloc+0x36>
      if(p->s.size == nunits)
 848:	02e48c63          	beq	s1,a4,880 <malloc+0xa8>
        p->s.size -= nunits;
 84c:	4137073b          	subw	a4,a4,s3
 850:	c798                	sw	a4,8(a5)
        p += p->s.size;
 852:	02071693          	slli	a3,a4,0x20
 856:	01c6d713          	srli	a4,a3,0x1c
 85a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 85c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 860:	00000717          	auipc	a4,0x0
 864:	7aa73823          	sd	a0,1968(a4) # 1010 <freep>
      return (void*)(p + 1);
 868:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 86c:	70e2                	ld	ra,56(sp)
 86e:	7442                	ld	s0,48(sp)
 870:	74a2                	ld	s1,40(sp)
 872:	7902                	ld	s2,32(sp)
 874:	69e2                	ld	s3,24(sp)
 876:	6a42                	ld	s4,16(sp)
 878:	6aa2                	ld	s5,8(sp)
 87a:	6b02                	ld	s6,0(sp)
 87c:	6121                	addi	sp,sp,64
 87e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 880:	6398                	ld	a4,0(a5)
 882:	e118                	sd	a4,0(a0)
 884:	bff1                	j	860 <malloc+0x88>
  hp->s.size = nu;
 886:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88a:	0541                	addi	a0,a0,16
 88c:	00000097          	auipc	ra,0x0
 890:	eca080e7          	jalr	-310(ra) # 756 <free>
  return freep;
 894:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 898:	d971                	beqz	a0,86c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89c:	4798                	lw	a4,8(a5)
 89e:	fa9775e3          	bgeu	a4,s1,848 <malloc+0x70>
    if(p == freep)
 8a2:	00093703          	ld	a4,0(s2)
 8a6:	853e                	mv	a0,a5
 8a8:	fef719e3          	bne	a4,a5,89a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8ac:	8552                	mv	a0,s4
 8ae:	00000097          	auipc	ra,0x0
 8b2:	b58080e7          	jalr	-1192(ra) # 406 <sbrk>
  if(p == (char*)-1)
 8b6:	fd5518e3          	bne	a0,s5,886 <malloc+0xae>
        return 0;
 8ba:	4501                	li	a0,0
 8bc:	bf45                	j	86c <malloc+0x94>

00000000000008be <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 8be:	c1d9                	beqz	a1,944 <head_run+0x86>
void head_run(int fd, int numOfLines){
 8c0:	dd010113          	addi	sp,sp,-560
 8c4:	22113423          	sd	ra,552(sp)
 8c8:	22813023          	sd	s0,544(sp)
 8cc:	20913c23          	sd	s1,536(sp)
 8d0:	21213823          	sd	s2,528(sp)
 8d4:	21313423          	sd	s3,520(sp)
 8d8:	21413023          	sd	s4,512(sp)
 8dc:	1c00                	addi	s0,sp,560
 8de:	892a                	mv	s2,a0
 8e0:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 8e4:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 8e6:	00000a17          	auipc	s4,0x0
 8ea:	592a0a13          	addi	s4,s4,1426 # e78 <digits+0x40>
		readStatus = read_line(fd, line);
 8ee:	dd840593          	addi	a1,s0,-552
 8f2:	854a                	mv	a0,s2
 8f4:	00000097          	auipc	ra,0x0
 8f8:	394080e7          	jalr	916(ra) # c88 <read_line>
		if (readStatus == READ_ERROR){
 8fc:	01350d63          	beq	a0,s3,916 <head_run+0x58>
		if (readStatus == READ_EOF)
 900:	c11d                	beqz	a0,926 <head_run+0x68>
		printf("%s",line);
 902:	dd840593          	addi	a1,s0,-552
 906:	8552                	mv	a0,s4
 908:	00000097          	auipc	ra,0x0
 90c:	e18080e7          	jalr	-488(ra) # 720 <printf>
	while(numOfLines--){
 910:	34fd                	addiw	s1,s1,-1
 912:	fcf1                	bnez	s1,8ee <head_run+0x30>
 914:	a809                	j	926 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 916:	00000517          	auipc	a0,0x0
 91a:	53a50513          	addi	a0,a0,1338 # e50 <digits+0x18>
 91e:	00000097          	auipc	ra,0x0
 922:	e02080e7          	jalr	-510(ra) # 720 <printf>

	}
}
 926:	22813083          	ld	ra,552(sp)
 92a:	22013403          	ld	s0,544(sp)
 92e:	21813483          	ld	s1,536(sp)
 932:	21013903          	ld	s2,528(sp)
 936:	20813983          	ld	s3,520(sp)
 93a:	20013a03          	ld	s4,512(sp)
 93e:	23010113          	addi	sp,sp,560
 942:	8082                	ret
 944:	8082                	ret

0000000000000946 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 946:	ba010113          	addi	sp,sp,-1120
 94a:	44113c23          	sd	ra,1112(sp)
 94e:	44813823          	sd	s0,1104(sp)
 952:	44913423          	sd	s1,1096(sp)
 956:	45213023          	sd	s2,1088(sp)
 95a:	43313c23          	sd	s3,1080(sp)
 95e:	43413823          	sd	s4,1072(sp)
 962:	43513423          	sd	s5,1064(sp)
 966:	43613023          	sd	s6,1056(sp)
 96a:	41713c23          	sd	s7,1048(sp)
 96e:	41813823          	sd	s8,1040(sp)
 972:	41913423          	sd	s9,1032(sp)
 976:	41a13023          	sd	s10,1024(sp)
 97a:	3fb13c23          	sd	s11,1016(sp)
 97e:	46010413          	addi	s0,sp,1120
 982:	89aa                	mv	s3,a0
 984:	8aae                	mv	s5,a1
 986:	8c32                	mv	s8,a2
 988:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 98a:	d9840593          	addi	a1,s0,-616
 98e:	00000097          	auipc	ra,0x0
 992:	2fa080e7          	jalr	762(ra) # c88 <read_line>


  if (readStatus == READ_ERROR)
 996:	57fd                	li	a5,-1
 998:	04f50163          	beq	a0,a5,9da <uniq_run+0x94>
 99c:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 99e:	ed21                	bnez	a0,9f6 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 9a0:	45813083          	ld	ra,1112(sp)
 9a4:	45013403          	ld	s0,1104(sp)
 9a8:	44813483          	ld	s1,1096(sp)
 9ac:	44013903          	ld	s2,1088(sp)
 9b0:	43813983          	ld	s3,1080(sp)
 9b4:	43013a03          	ld	s4,1072(sp)
 9b8:	42813a83          	ld	s5,1064(sp)
 9bc:	42013b03          	ld	s6,1056(sp)
 9c0:	41813b83          	ld	s7,1048(sp)
 9c4:	41013c03          	ld	s8,1040(sp)
 9c8:	40813c83          	ld	s9,1032(sp)
 9cc:	40013d03          	ld	s10,1024(sp)
 9d0:	3f813d83          	ld	s11,1016(sp)
 9d4:	46010113          	addi	sp,sp,1120
 9d8:	8082                	ret
    printf("[ERR] Error reading from the file ");
 9da:	00000517          	auipc	a0,0x0
 9de:	4a650513          	addi	a0,a0,1190 # e80 <digits+0x48>
 9e2:	00000097          	auipc	ra,0x0
 9e6:	d3e080e7          	jalr	-706(ra) # 720 <printf>
 9ea:	bf5d                	j	9a0 <uniq_run+0x5a>
 9ec:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 9ee:	8926                	mv	s2,s1
 9f0:	84be                	mv	s1,a5
        lineCount = 1;
 9f2:	8b6a                	mv	s6,s10
 9f4:	a8ed                	j	aee <uniq_run+0x1a8>
    int lineCount=1;
 9f6:	4b05                	li	s6,1
  char * line2 = buffer2;
 9f8:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 9fc:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 a00:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 a02:	4d05                	li	s10,1
              printf("%s",line1);
 a04:	00000d97          	auipc	s11,0x0
 a08:	474d8d93          	addi	s11,s11,1140 # e78 <digits+0x40>
 a0c:	a0cd                	j	aee <uniq_run+0x1a8>
            if (repeatedLines){
 a0e:	020a0b63          	beqz	s4,a44 <uniq_run+0xfe>
                if (isRepeated){
 a12:	f80b87e3          	beqz	s7,9a0 <uniq_run+0x5a>
                    if (showCount)
 a16:	000c0d63          	beqz	s8,a30 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 a1a:	864a                	mv	a2,s2
 a1c:	85da                	mv	a1,s6
 a1e:	00000517          	auipc	a0,0x0
 a22:	48a50513          	addi	a0,a0,1162 # ea8 <digits+0x70>
 a26:	00000097          	auipc	ra,0x0
 a2a:	cfa080e7          	jalr	-774(ra) # 720 <printf>
 a2e:	bf8d                	j	9a0 <uniq_run+0x5a>
                      printf("%s",line1);
 a30:	85ca                	mv	a1,s2
 a32:	00000517          	auipc	a0,0x0
 a36:	44650513          	addi	a0,a0,1094 # e78 <digits+0x40>
 a3a:	00000097          	auipc	ra,0x0
 a3e:	ce6080e7          	jalr	-794(ra) # 720 <printf>
 a42:	bfb9                	j	9a0 <uniq_run+0x5a>
                if (showCount)
 a44:	000c0d63          	beqz	s8,a5e <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 a48:	864a                	mv	a2,s2
 a4a:	85da                	mv	a1,s6
 a4c:	00000517          	auipc	a0,0x0
 a50:	45c50513          	addi	a0,a0,1116 # ea8 <digits+0x70>
 a54:	00000097          	auipc	ra,0x0
 a58:	ccc080e7          	jalr	-820(ra) # 720 <printf>
 a5c:	b791                	j	9a0 <uniq_run+0x5a>
                  printf("%s",line1);
 a5e:	85ca                	mv	a1,s2
 a60:	00000517          	auipc	a0,0x0
 a64:	41850513          	addi	a0,a0,1048 # e78 <digits+0x40>
 a68:	00000097          	auipc	ra,0x0
 a6c:	cb8080e7          	jalr	-840(ra) # 720 <printf>
 a70:	bf05                	j	9a0 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 a72:	00000517          	auipc	a0,0x0
 a76:	43e50513          	addi	a0,a0,1086 # eb0 <digits+0x78>
 a7a:	00000097          	auipc	ra,0x0
 a7e:	ca6080e7          	jalr	-858(ra) # 720 <printf>
          break;
 a82:	bf39                	j	9a0 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 a84:	85a6                	mv	a1,s1
 a86:	854a                	mv	a0,s2
 a88:	00000097          	auipc	ra,0x0
 a8c:	110080e7          	jalr	272(ra) # b98 <compare_str_ic>
 a90:	a041                	j	b10 <uniq_run+0x1ca>
                  printf("%s",line1);
 a92:	85ca                	mv	a1,s2
 a94:	856e                	mv	a0,s11
 a96:	00000097          	auipc	ra,0x0
 a9a:	c8a080e7          	jalr	-886(ra) # 720 <printf>
        lineCount = 1;
 a9e:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 aa0:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 aa2:	8926                	mv	s2,s1
                  printf("%s",line1);
 aa4:	84be                	mv	s1,a5
        isRepeated = 0 ;
 aa6:	4b81                	li	s7,0
 aa8:	a099                	j	aee <uniq_run+0x1a8>
            if (showCount)
 aaa:	020c0263          	beqz	s8,ace <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 aae:	864a                	mv	a2,s2
 ab0:	85da                	mv	a1,s6
 ab2:	00000517          	auipc	a0,0x0
 ab6:	3f650513          	addi	a0,a0,1014 # ea8 <digits+0x70>
 aba:	00000097          	auipc	ra,0x0
 abe:	c66080e7          	jalr	-922(ra) # 720 <printf>
 ac2:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 ac4:	8926                	mv	s2,s1
 ac6:	84be                	mv	s1,a5
        isRepeated = 0 ;
 ac8:	4b81                	li	s7,0
        lineCount = 1;
 aca:	8b6a                	mv	s6,s10
 acc:	a00d                	j	aee <uniq_run+0x1a8>
              printf("%s",line1);
 ace:	85ca                	mv	a1,s2
 ad0:	856e                	mv	a0,s11
 ad2:	00000097          	auipc	ra,0x0
 ad6:	c4e080e7          	jalr	-946(ra) # 720 <printf>
 ada:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 adc:	8926                	mv	s2,s1
              printf("%s",line1);
 ade:	84be                	mv	s1,a5
        isRepeated = 0 ;
 ae0:	4b81                	li	s7,0
        lineCount = 1;
 ae2:	8b6a                	mv	s6,s10
 ae4:	a029                	j	aee <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 ae6:	000a0363          	beqz	s4,aec <uniq_run+0x1a6>
 aea:	8bea                	mv	s7,s10
          lineCount++;
 aec:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 aee:	85a6                	mv	a1,s1
 af0:	854e                	mv	a0,s3
 af2:	00000097          	auipc	ra,0x0
 af6:	196080e7          	jalr	406(ra) # c88 <read_line>
        if (readStatus == READ_EOF){
 afa:	d911                	beqz	a0,a0e <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 afc:	f7950be3          	beq	a0,s9,a72 <uniq_run+0x12c>
        if (!ignoreCase)
 b00:	f80a92e3          	bnez	s5,a84 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 b04:	85a6                	mv	a1,s1
 b06:	854a                	mv	a0,s2
 b08:	00000097          	auipc	ra,0x0
 b0c:	062080e7          	jalr	98(ra) # b6a <compare_str>
        if (compareStatus != 0){ 
 b10:	d979                	beqz	a0,ae6 <uniq_run+0x1a0>
          if (repeatedLines){
 b12:	f80a0ce3          	beqz	s4,aaa <uniq_run+0x164>
            if (isRepeated){
 b16:	ec0b8be3          	beqz	s7,9ec <uniq_run+0xa6>
                if (showCount)
 b1a:	f60c0ce3          	beqz	s8,a92 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 b1e:	864a                	mv	a2,s2
 b20:	85da                	mv	a1,s6
 b22:	00000517          	auipc	a0,0x0
 b26:	38650513          	addi	a0,a0,902 # ea8 <digits+0x70>
 b2a:	00000097          	auipc	ra,0x0
 b2e:	bf6080e7          	jalr	-1034(ra) # 720 <printf>
        lineCount = 1;
 b32:	8b5e                	mv	s6,s7
 b34:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b36:	8926                	mv	s2,s1
 b38:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b3a:	4b81                	li	s7,0
 b3c:	bf4d                	j	aee <uniq_run+0x1a8>

0000000000000b3e <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 b3e:	1141                	addi	sp,sp,-16
 b40:	e422                	sd	s0,8(sp)
 b42:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 b44:	00054783          	lbu	a5,0(a0)
 b48:	cf99                	beqz	a5,b66 <get_strlen+0x28>
 b4a:	00150713          	addi	a4,a0,1
 b4e:	87ba                	mv	a5,a4
 b50:	4685                	li	a3,1
 b52:	9e99                	subw	a3,a3,a4
 b54:	00f6853b          	addw	a0,a3,a5
 b58:	0785                	addi	a5,a5,1
 b5a:	fff7c703          	lbu	a4,-1(a5)
 b5e:	fb7d                	bnez	a4,b54 <get_strlen+0x16>
	return len;
}
 b60:	6422                	ld	s0,8(sp)
 b62:	0141                	addi	sp,sp,16
 b64:	8082                	ret
	int len = 0;
 b66:	4501                	li	a0,0
 b68:	bfe5                	j	b60 <get_strlen+0x22>

0000000000000b6a <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 b6a:	1141                	addi	sp,sp,-16
 b6c:	e422                	sd	s0,8(sp)
 b6e:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 b70:	00054783          	lbu	a5,0(a0)
 b74:	cb91                	beqz	a5,b88 <compare_str+0x1e>
 b76:	0005c703          	lbu	a4,0(a1)
 b7a:	c719                	beqz	a4,b88 <compare_str+0x1e>
		if (*s1++ != *s2++)
 b7c:	0505                	addi	a0,a0,1
 b7e:	0585                	addi	a1,a1,1
 b80:	fee788e3          	beq	a5,a4,b70 <compare_str+0x6>
			return 1;
 b84:	4505                	li	a0,1
 b86:	a031                	j	b92 <compare_str+0x28>
	}
	if (*s1 == *s2)
 b88:	0005c503          	lbu	a0,0(a1)
 b8c:	8d1d                	sub	a0,a0,a5
			return 1;
 b8e:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b92:	6422                	ld	s0,8(sp)
 b94:	0141                	addi	sp,sp,16
 b96:	8082                	ret

0000000000000b98 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 b98:	1141                	addi	sp,sp,-16
 b9a:	e422                	sd	s0,8(sp)
 b9c:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b9e:	4665                	li	a2,25
	while(*s1 && *s2){
 ba0:	a019                	j	ba6 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 ba2:	04e79763          	bne	a5,a4,bf0 <compare_str_ic+0x58>
	while(*s1 && *s2){
 ba6:	00054783          	lbu	a5,0(a0)
 baa:	cb9d                	beqz	a5,be0 <compare_str_ic+0x48>
 bac:	0005c703          	lbu	a4,0(a1)
 bb0:	cb05                	beqz	a4,be0 <compare_str_ic+0x48>
		char b1 = *s1++;
 bb2:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 bb4:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 bb6:	fbf7869b          	addiw	a3,a5,-65
 bba:	0ff6f693          	zext.b	a3,a3
 bbe:	00d66663          	bltu	a2,a3,bca <compare_str_ic+0x32>
			b1 += 32;
 bc2:	0207879b          	addiw	a5,a5,32
 bc6:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 bca:	fbf7069b          	addiw	a3,a4,-65
 bce:	0ff6f693          	zext.b	a3,a3
 bd2:	fcd668e3          	bltu	a2,a3,ba2 <compare_str_ic+0xa>
			b2 += 32;
 bd6:	0207071b          	addiw	a4,a4,32
 bda:	0ff77713          	zext.b	a4,a4
 bde:	b7d1                	j	ba2 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 be0:	0005c503          	lbu	a0,0(a1)
 be4:	8d1d                	sub	a0,a0,a5
			return 1;
 be6:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 bea:	6422                	ld	s0,8(sp)
 bec:	0141                	addi	sp,sp,16
 bee:	8082                	ret
			return 1;
 bf0:	4505                	li	a0,1
 bf2:	bfe5                	j	bea <compare_str_ic+0x52>

0000000000000bf4 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 bf4:	7179                	addi	sp,sp,-48
 bf6:	f406                	sd	ra,40(sp)
 bf8:	f022                	sd	s0,32(sp)
 bfa:	ec26                	sd	s1,24(sp)
 bfc:	e84a                	sd	s2,16(sp)
 bfe:	e44e                	sd	s3,8(sp)
 c00:	1800                	addi	s0,sp,48
 c02:	89aa                	mv	s3,a0
 c04:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 c06:	00000097          	auipc	ra,0x0
 c0a:	f38080e7          	jalr	-200(ra) # b3e <get_strlen>
 c0e:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 c10:	854a                	mv	a0,s2
 c12:	00000097          	auipc	ra,0x0
 c16:	f2c080e7          	jalr	-212(ra) # b3e <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 c1a:	409505bb          	subw	a1,a0,s1
 c1e:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 c20:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 c22:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 c24:	0005da63          	bgez	a1,c38 <check_substr+0x44>
 c28:	a81d                	j	c5e <check_substr+0x6a>
        if (j == M)
 c2a:	02f48a63          	beq	s1,a5,c5e <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 c2e:	0885                	addi	a7,a7,1
 c30:	0008879b          	sext.w	a5,a7
 c34:	02f5cc63          	blt	a1,a5,c6c <check_substr+0x78>
 c38:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 c3c:	011906b3          	add	a3,s2,a7
 c40:	874e                	mv	a4,s3
 c42:	879a                	mv	a5,t1
 c44:	fe9053e3          	blez	s1,c2a <check_substr+0x36>
            if (s2[i + j] != s1[j])
 c48:	0006c803          	lbu	a6,0(a3) # 1000 <argv>
 c4c:	00074603          	lbu	a2,0(a4)
 c50:	fcc81de3          	bne	a6,a2,c2a <check_substr+0x36>
        for (j = 0; j < M; j++)
 c54:	2785                	addiw	a5,a5,1
 c56:	0685                	addi	a3,a3,1
 c58:	0705                	addi	a4,a4,1
 c5a:	fef497e3          	bne	s1,a5,c48 <check_substr+0x54>
}
 c5e:	70a2                	ld	ra,40(sp)
 c60:	7402                	ld	s0,32(sp)
 c62:	64e2                	ld	s1,24(sp)
 c64:	6942                	ld	s2,16(sp)
 c66:	69a2                	ld	s3,8(sp)
 c68:	6145                	addi	sp,sp,48
 c6a:	8082                	ret
    return -1;
 c6c:	557d                	li	a0,-1
 c6e:	bfc5                	j	c5e <check_substr+0x6a>

0000000000000c70 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 c70:	1141                	addi	sp,sp,-16
 c72:	e406                	sd	ra,8(sp)
 c74:	e022                	sd	s0,0(sp)
 c76:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 c78:	fffff097          	auipc	ra,0xfffff
 c7c:	746080e7          	jalr	1862(ra) # 3be <open>
	return fd;
}
 c80:	60a2                	ld	ra,8(sp)
 c82:	6402                	ld	s0,0(sp)
 c84:	0141                	addi	sp,sp,16
 c86:	8082                	ret

0000000000000c88 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 c88:	7139                	addi	sp,sp,-64
 c8a:	fc06                	sd	ra,56(sp)
 c8c:	f822                	sd	s0,48(sp)
 c8e:	f426                	sd	s1,40(sp)
 c90:	f04a                	sd	s2,32(sp)
 c92:	ec4e                	sd	s3,24(sp)
 c94:	e852                	sd	s4,16(sp)
 c96:	0080                	addi	s0,sp,64
 c98:	89aa                	mv	s3,a0
 c9a:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c9c:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 c9e:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 ca0:	4605                	li	a2,1
 ca2:	fcf40593          	addi	a1,s0,-49
 ca6:	854e                	mv	a0,s3
 ca8:	fffff097          	auipc	ra,0xfffff
 cac:	6ee080e7          	jalr	1774(ra) # 396 <read>
		if (readStatus == 0){
 cb0:	c505                	beqz	a0,cd8 <read_line+0x50>
		*buffer++ = readByte;
 cb2:	0485                	addi	s1,s1,1
 cb4:	fcf44783          	lbu	a5,-49(s0)
 cb8:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 cbc:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 cbe:	ff4791e3          	bne	a5,s4,ca0 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 cc2:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 cc6:	854a                	mv	a0,s2
 cc8:	70e2                	ld	ra,56(sp)
 cca:	7442                	ld	s0,48(sp)
 ccc:	74a2                	ld	s1,40(sp)
 cce:	7902                	ld	s2,32(sp)
 cd0:	69e2                	ld	s3,24(sp)
 cd2:	6a42                	ld	s4,16(sp)
 cd4:	6121                	addi	sp,sp,64
 cd6:	8082                	ret
			if (byteCount!=0){
 cd8:	fe0907e3          	beqz	s2,cc6 <read_line+0x3e>
				*buffer = '\n';
 cdc:	47a9                	li	a5,10
 cde:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 ce2:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 ce6:	2905                	addiw	s2,s2,1
 ce8:	bff9                	j	cc6 <read_line+0x3e>

0000000000000cea <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 cea:	1141                	addi	sp,sp,-16
 cec:	e406                	sd	ra,8(sp)
 cee:	e022                	sd	s0,0(sp)
 cf0:	0800                	addi	s0,sp,16
	close(fd);
 cf2:	fffff097          	auipc	ra,0xfffff
 cf6:	6b4080e7          	jalr	1716(ra) # 3a6 <close>
}
 cfa:	60a2                	ld	ra,8(sp)
 cfc:	6402                	ld	s0,0(sp)
 cfe:	0141                	addi	sp,sp,16
 d00:	8082                	ret

0000000000000d02 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 d02:	7139                	addi	sp,sp,-64
 d04:	fc06                	sd	ra,56(sp)
 d06:	f822                	sd	s0,48(sp)
 d08:	f426                	sd	s1,40(sp)
 d0a:	f04a                	sd	s2,32(sp)
 d0c:	0080                	addi	s0,sp,64
 d0e:	84aa                	mv	s1,a0
 d10:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 d12:	fffff097          	auipc	ra,0xfffff
 d16:	664080e7          	jalr	1636(ra) # 376 <fork>
 d1a:	ed19                	bnez	a0,d38 <get_time_perf+0x36>
		exec(argv[0],argv);
 d1c:	85ca                	mv	a1,s2
 d1e:	00093503          	ld	a0,0(s2)
 d22:	fffff097          	auipc	ra,0xfffff
 d26:	694080e7          	jalr	1684(ra) # 3b6 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 d2a:	8526                	mv	a0,s1
 d2c:	70e2                	ld	ra,56(sp)
 d2e:	7442                	ld	s0,48(sp)
 d30:	74a2                	ld	s1,40(sp)
 d32:	7902                	ld	s2,32(sp)
 d34:	6121                	addi	sp,sp,64
 d36:	8082                	ret
		times(pid , &time);
 d38:	fc840593          	addi	a1,s0,-56
 d3c:	fffff097          	auipc	ra,0xfffff
 d40:	6fa080e7          	jalr	1786(ra) # 436 <times>
		return time;
 d44:	fc843783          	ld	a5,-56(s0)
 d48:	e09c                	sd	a5,0(s1)
 d4a:	fd043783          	ld	a5,-48(s0)
 d4e:	e49c                	sd	a5,8(s1)
 d50:	fd843783          	ld	a5,-40(s0)
 d54:	e89c                	sd	a5,16(s1)
 d56:	bfd1                	j	d2a <get_time_perf+0x28>
