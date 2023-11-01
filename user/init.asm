
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
  12:	d7250513          	addi	a0,a0,-654 # d80 <get_time_perf+0x66>
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
  3a:	d5290913          	addi	s2,s2,-686 # d88 <get_time_perf+0x6e>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6f8080e7          	jalr	1784(ra) # 738 <printf>
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
  6e:	d6e50513          	addi	a0,a0,-658 # dd8 <get_time_perf+0xbe>
  72:	00000097          	auipc	ra,0x0
  76:	6c6080e7          	jalr	1734(ra) # 738 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	302080e7          	jalr	770(ra) # 37e <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	cf850513          	addi	a0,a0,-776 # d80 <get_time_perf+0x66>
  90:	00000097          	auipc	ra,0x0
  94:	336080e7          	jalr	822(ra) # 3c6 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	ce650513          	addi	a0,a0,-794 # d80 <get_time_perf+0x66>
  a2:	00000097          	auipc	ra,0x0
  a6:	31c080e7          	jalr	796(ra) # 3be <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	cf450513          	addi	a0,a0,-780 # da0 <get_time_perf+0x86>
  b4:	00000097          	auipc	ra,0x0
  b8:	684080e7          	jalr	1668(ra) # 738 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2c0080e7          	jalr	704(ra) # 37e <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f3a58593          	addi	a1,a1,-198 # 1000 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	cea50513          	addi	a0,a0,-790 # db8 <get_time_perf+0x9e>
  d6:	00000097          	auipc	ra,0x0
  da:	2e0080e7          	jalr	736(ra) # 3b6 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	ce250513          	addi	a0,a0,-798 # dc0 <get_time_perf+0xa6>
  e6:	00000097          	auipc	ra,0x0
  ea:	652080e7          	jalr	1618(ra) # 738 <printf>
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

0000000000000446 <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 446:	48ed                	li	a7,27
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 44e:	48f1                	li	a7,28
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 456:	48f5                	li	a7,29
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45e:	1101                	addi	sp,sp,-32
 460:	ec06                	sd	ra,24(sp)
 462:	e822                	sd	s0,16(sp)
 464:	1000                	addi	s0,sp,32
 466:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46a:	4605                	li	a2,1
 46c:	fef40593          	addi	a1,s0,-17
 470:	00000097          	auipc	ra,0x0
 474:	f2e080e7          	jalr	-210(ra) # 39e <write>
}
 478:	60e2                	ld	ra,24(sp)
 47a:	6442                	ld	s0,16(sp)
 47c:	6105                	addi	sp,sp,32
 47e:	8082                	ret

0000000000000480 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 480:	7139                	addi	sp,sp,-64
 482:	fc06                	sd	ra,56(sp)
 484:	f822                	sd	s0,48(sp)
 486:	f426                	sd	s1,40(sp)
 488:	f04a                	sd	s2,32(sp)
 48a:	ec4e                	sd	s3,24(sp)
 48c:	0080                	addi	s0,sp,64
 48e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 490:	c299                	beqz	a3,496 <printint+0x16>
 492:	0805c963          	bltz	a1,524 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 496:	2581                	sext.w	a1,a1
  neg = 0;
 498:	4881                	li	a7,0
 49a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 49e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a0:	2601                	sext.w	a2,a2
 4a2:	00001517          	auipc	a0,0x1
 4a6:	9b650513          	addi	a0,a0,-1610 # e58 <digits>
 4aa:	883a                	mv	a6,a4
 4ac:	2705                	addiw	a4,a4,1
 4ae:	02c5f7bb          	remuw	a5,a1,a2
 4b2:	1782                	slli	a5,a5,0x20
 4b4:	9381                	srli	a5,a5,0x20
 4b6:	97aa                	add	a5,a5,a0
 4b8:	0007c783          	lbu	a5,0(a5)
 4bc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c0:	0005879b          	sext.w	a5,a1
 4c4:	02c5d5bb          	divuw	a1,a1,a2
 4c8:	0685                	addi	a3,a3,1
 4ca:	fec7f0e3          	bgeu	a5,a2,4aa <printint+0x2a>
  if(neg)
 4ce:	00088c63          	beqz	a7,4e6 <printint+0x66>
    buf[i++] = '-';
 4d2:	fd070793          	addi	a5,a4,-48
 4d6:	00878733          	add	a4,a5,s0
 4da:	02d00793          	li	a5,45
 4de:	fef70823          	sb	a5,-16(a4)
 4e2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e6:	02e05863          	blez	a4,516 <printint+0x96>
 4ea:	fc040793          	addi	a5,s0,-64
 4ee:	00e78933          	add	s2,a5,a4
 4f2:	fff78993          	addi	s3,a5,-1
 4f6:	99ba                	add	s3,s3,a4
 4f8:	377d                	addiw	a4,a4,-1
 4fa:	1702                	slli	a4,a4,0x20
 4fc:	9301                	srli	a4,a4,0x20
 4fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 502:	fff94583          	lbu	a1,-1(s2)
 506:	8526                	mv	a0,s1
 508:	00000097          	auipc	ra,0x0
 50c:	f56080e7          	jalr	-170(ra) # 45e <putc>
  while(--i >= 0)
 510:	197d                	addi	s2,s2,-1
 512:	ff3918e3          	bne	s2,s3,502 <printint+0x82>
}
 516:	70e2                	ld	ra,56(sp)
 518:	7442                	ld	s0,48(sp)
 51a:	74a2                	ld	s1,40(sp)
 51c:	7902                	ld	s2,32(sp)
 51e:	69e2                	ld	s3,24(sp)
 520:	6121                	addi	sp,sp,64
 522:	8082                	ret
    x = -xx;
 524:	40b005bb          	negw	a1,a1
    neg = 1;
 528:	4885                	li	a7,1
    x = -xx;
 52a:	bf85                	j	49a <printint+0x1a>

000000000000052c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52c:	7119                	addi	sp,sp,-128
 52e:	fc86                	sd	ra,120(sp)
 530:	f8a2                	sd	s0,112(sp)
 532:	f4a6                	sd	s1,104(sp)
 534:	f0ca                	sd	s2,96(sp)
 536:	ecce                	sd	s3,88(sp)
 538:	e8d2                	sd	s4,80(sp)
 53a:	e4d6                	sd	s5,72(sp)
 53c:	e0da                	sd	s6,64(sp)
 53e:	fc5e                	sd	s7,56(sp)
 540:	f862                	sd	s8,48(sp)
 542:	f466                	sd	s9,40(sp)
 544:	f06a                	sd	s10,32(sp)
 546:	ec6e                	sd	s11,24(sp)
 548:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 54a:	0005c903          	lbu	s2,0(a1)
 54e:	18090f63          	beqz	s2,6ec <vprintf+0x1c0>
 552:	8aaa                	mv	s5,a0
 554:	8b32                	mv	s6,a2
 556:	00158493          	addi	s1,a1,1
  state = 0;
 55a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 55c:	02500a13          	li	s4,37
 560:	4c55                	li	s8,21
 562:	00001c97          	auipc	s9,0x1
 566:	89ec8c93          	addi	s9,s9,-1890 # e00 <get_time_perf+0xe6>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 56a:	02800d93          	li	s11,40
  putc(fd, 'x');
 56e:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 570:	00001b97          	auipc	s7,0x1
 574:	8e8b8b93          	addi	s7,s7,-1816 # e58 <digits>
 578:	a839                	j	596 <vprintf+0x6a>
        putc(fd, c);
 57a:	85ca                	mv	a1,s2
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	ee0080e7          	jalr	-288(ra) # 45e <putc>
 586:	a019                	j	58c <vprintf+0x60>
    } else if(state == '%'){
 588:	01498d63          	beq	s3,s4,5a2 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 58c:	0485                	addi	s1,s1,1
 58e:	fff4c903          	lbu	s2,-1(s1)
 592:	14090d63          	beqz	s2,6ec <vprintf+0x1c0>
    if(state == 0){
 596:	fe0999e3          	bnez	s3,588 <vprintf+0x5c>
      if(c == '%'){
 59a:	ff4910e3          	bne	s2,s4,57a <vprintf+0x4e>
        state = '%';
 59e:	89d2                	mv	s3,s4
 5a0:	b7f5                	j	58c <vprintf+0x60>
      if(c == 'd'){
 5a2:	11490c63          	beq	s2,s4,6ba <vprintf+0x18e>
 5a6:	f9d9079b          	addiw	a5,s2,-99
 5aa:	0ff7f793          	zext.b	a5,a5
 5ae:	10fc6e63          	bltu	s8,a5,6ca <vprintf+0x19e>
 5b2:	f9d9079b          	addiw	a5,s2,-99
 5b6:	0ff7f713          	zext.b	a4,a5
 5ba:	10ec6863          	bltu	s8,a4,6ca <vprintf+0x19e>
 5be:	00271793          	slli	a5,a4,0x2
 5c2:	97e6                	add	a5,a5,s9
 5c4:	439c                	lw	a5,0(a5)
 5c6:	97e6                	add	a5,a5,s9
 5c8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5ca:	008b0913          	addi	s2,s6,8
 5ce:	4685                	li	a3,1
 5d0:	4629                	li	a2,10
 5d2:	000b2583          	lw	a1,0(s6)
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	ea8080e7          	jalr	-344(ra) # 480 <printint>
 5e0:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b765                	j	58c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e6:	008b0913          	addi	s2,s6,8
 5ea:	4681                	li	a3,0
 5ec:	4629                	li	a2,10
 5ee:	000b2583          	lw	a1,0(s6)
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e8c080e7          	jalr	-372(ra) # 480 <printint>
 5fc:	8b4a                	mv	s6,s2
      state = 0;
 5fe:	4981                	li	s3,0
 600:	b771                	j	58c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 602:	008b0913          	addi	s2,s6,8
 606:	4681                	li	a3,0
 608:	866a                	mv	a2,s10
 60a:	000b2583          	lw	a1,0(s6)
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	e70080e7          	jalr	-400(ra) # 480 <printint>
 618:	8b4a                	mv	s6,s2
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bf85                	j	58c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 61e:	008b0793          	addi	a5,s6,8
 622:	f8f43423          	sd	a5,-120(s0)
 626:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 62a:	03000593          	li	a1,48
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	e2e080e7          	jalr	-466(ra) # 45e <putc>
  putc(fd, 'x');
 638:	07800593          	li	a1,120
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	e20080e7          	jalr	-480(ra) # 45e <putc>
 646:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 648:	03c9d793          	srli	a5,s3,0x3c
 64c:	97de                	add	a5,a5,s7
 64e:	0007c583          	lbu	a1,0(a5)
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	e0a080e7          	jalr	-502(ra) # 45e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65c:	0992                	slli	s3,s3,0x4
 65e:	397d                	addiw	s2,s2,-1
 660:	fe0914e3          	bnez	s2,648 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 664:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 668:	4981                	li	s3,0
 66a:	b70d                	j	58c <vprintf+0x60>
        s = va_arg(ap, char*);
 66c:	008b0913          	addi	s2,s6,8
 670:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 674:	02098163          	beqz	s3,696 <vprintf+0x16a>
        while(*s != 0){
 678:	0009c583          	lbu	a1,0(s3)
 67c:	c5ad                	beqz	a1,6e6 <vprintf+0x1ba>
          putc(fd, *s);
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	dde080e7          	jalr	-546(ra) # 45e <putc>
          s++;
 688:	0985                	addi	s3,s3,1
        while(*s != 0){
 68a:	0009c583          	lbu	a1,0(s3)
 68e:	f9e5                	bnez	a1,67e <vprintf+0x152>
        s = va_arg(ap, char*);
 690:	8b4a                	mv	s6,s2
      state = 0;
 692:	4981                	li	s3,0
 694:	bde5                	j	58c <vprintf+0x60>
          s = "(null)";
 696:	00000997          	auipc	s3,0x0
 69a:	76298993          	addi	s3,s3,1890 # df8 <get_time_perf+0xde>
        while(*s != 0){
 69e:	85ee                	mv	a1,s11
 6a0:	bff9                	j	67e <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 6a2:	008b0913          	addi	s2,s6,8
 6a6:	000b4583          	lbu	a1,0(s6)
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	db2080e7          	jalr	-590(ra) # 45e <putc>
 6b4:	8b4a                	mv	s6,s2
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	bdd1                	j	58c <vprintf+0x60>
        putc(fd, c);
 6ba:	85d2                	mv	a1,s4
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	da0080e7          	jalr	-608(ra) # 45e <putc>
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b5d1                	j	58c <vprintf+0x60>
        putc(fd, '%');
 6ca:	85d2                	mv	a1,s4
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	d90080e7          	jalr	-624(ra) # 45e <putc>
        putc(fd, c);
 6d6:	85ca                	mv	a1,s2
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	d84080e7          	jalr	-636(ra) # 45e <putc>
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b565                	j	58c <vprintf+0x60>
        s = va_arg(ap, char*);
 6e6:	8b4a                	mv	s6,s2
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	b54d                	j	58c <vprintf+0x60>
    }
  }
}
 6ec:	70e6                	ld	ra,120(sp)
 6ee:	7446                	ld	s0,112(sp)
 6f0:	74a6                	ld	s1,104(sp)
 6f2:	7906                	ld	s2,96(sp)
 6f4:	69e6                	ld	s3,88(sp)
 6f6:	6a46                	ld	s4,80(sp)
 6f8:	6aa6                	ld	s5,72(sp)
 6fa:	6b06                	ld	s6,64(sp)
 6fc:	7be2                	ld	s7,56(sp)
 6fe:	7c42                	ld	s8,48(sp)
 700:	7ca2                	ld	s9,40(sp)
 702:	7d02                	ld	s10,32(sp)
 704:	6de2                	ld	s11,24(sp)
 706:	6109                	addi	sp,sp,128
 708:	8082                	ret

000000000000070a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 70a:	715d                	addi	sp,sp,-80
 70c:	ec06                	sd	ra,24(sp)
 70e:	e822                	sd	s0,16(sp)
 710:	1000                	addi	s0,sp,32
 712:	e010                	sd	a2,0(s0)
 714:	e414                	sd	a3,8(s0)
 716:	e818                	sd	a4,16(s0)
 718:	ec1c                	sd	a5,24(s0)
 71a:	03043023          	sd	a6,32(s0)
 71e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 722:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 726:	8622                	mv	a2,s0
 728:	00000097          	auipc	ra,0x0
 72c:	e04080e7          	jalr	-508(ra) # 52c <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6161                	addi	sp,sp,80
 736:	8082                	ret

0000000000000738 <printf>:

void
printf(const char *fmt, ...)
{
 738:	711d                	addi	sp,sp,-96
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	addi	s0,sp,32
 740:	e40c                	sd	a1,8(s0)
 742:	e810                	sd	a2,16(s0)
 744:	ec14                	sd	a3,24(s0)
 746:	f018                	sd	a4,32(s0)
 748:	f41c                	sd	a5,40(s0)
 74a:	03043823          	sd	a6,48(s0)
 74e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	00840613          	addi	a2,s0,8
 756:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75a:	85aa                	mv	a1,a0
 75c:	4505                	li	a0,1
 75e:	00000097          	auipc	ra,0x0
 762:	dce080e7          	jalr	-562(ra) # 52c <vprintf>
}
 766:	60e2                	ld	ra,24(sp)
 768:	6442                	ld	s0,16(sp)
 76a:	6125                	addi	sp,sp,96
 76c:	8082                	ret

000000000000076e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76e:	1141                	addi	sp,sp,-16
 770:	e422                	sd	s0,8(sp)
 772:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 774:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 778:	00001797          	auipc	a5,0x1
 77c:	8987b783          	ld	a5,-1896(a5) # 1010 <freep>
 780:	a02d                	j	7aa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 782:	4618                	lw	a4,8(a2)
 784:	9f2d                	addw	a4,a4,a1
 786:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 78a:	6398                	ld	a4,0(a5)
 78c:	6310                	ld	a2,0(a4)
 78e:	a83d                	j	7cc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 790:	ff852703          	lw	a4,-8(a0)
 794:	9f31                	addw	a4,a4,a2
 796:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 798:	ff053683          	ld	a3,-16(a0)
 79c:	a091                	j	7e0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79e:	6398                	ld	a4,0(a5)
 7a0:	00e7e463          	bltu	a5,a4,7a8 <free+0x3a>
 7a4:	00e6ea63          	bltu	a3,a4,7b8 <free+0x4a>
{
 7a8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	fed7fae3          	bgeu	a5,a3,79e <free+0x30>
 7ae:	6398                	ld	a4,0(a5)
 7b0:	00e6e463          	bltu	a3,a4,7b8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	fee7eae3          	bltu	a5,a4,7a8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7b8:	ff852583          	lw	a1,-8(a0)
 7bc:	6390                	ld	a2,0(a5)
 7be:	02059813          	slli	a6,a1,0x20
 7c2:	01c85713          	srli	a4,a6,0x1c
 7c6:	9736                	add	a4,a4,a3
 7c8:	fae60de3          	beq	a2,a4,782 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7d0:	4790                	lw	a2,8(a5)
 7d2:	02061593          	slli	a1,a2,0x20
 7d6:	01c5d713          	srli	a4,a1,0x1c
 7da:	973e                	add	a4,a4,a5
 7dc:	fae68ae3          	beq	a3,a4,790 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7e0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e2:	00001717          	auipc	a4,0x1
 7e6:	82f73723          	sd	a5,-2002(a4) # 1010 <freep>
}
 7ea:	6422                	ld	s0,8(sp)
 7ec:	0141                	addi	sp,sp,16
 7ee:	8082                	ret

00000000000007f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f0:	7139                	addi	sp,sp,-64
 7f2:	fc06                	sd	ra,56(sp)
 7f4:	f822                	sd	s0,48(sp)
 7f6:	f426                	sd	s1,40(sp)
 7f8:	f04a                	sd	s2,32(sp)
 7fa:	ec4e                	sd	s3,24(sp)
 7fc:	e852                	sd	s4,16(sp)
 7fe:	e456                	sd	s5,8(sp)
 800:	e05a                	sd	s6,0(sp)
 802:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 804:	02051493          	slli	s1,a0,0x20
 808:	9081                	srli	s1,s1,0x20
 80a:	04bd                	addi	s1,s1,15
 80c:	8091                	srli	s1,s1,0x4
 80e:	0014899b          	addiw	s3,s1,1
 812:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 814:	00000517          	auipc	a0,0x0
 818:	7fc53503          	ld	a0,2044(a0) # 1010 <freep>
 81c:	c515                	beqz	a0,848 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 820:	4798                	lw	a4,8(a5)
 822:	02977f63          	bgeu	a4,s1,860 <malloc+0x70>
 826:	8a4e                	mv	s4,s3
 828:	0009871b          	sext.w	a4,s3
 82c:	6685                	lui	a3,0x1
 82e:	00d77363          	bgeu	a4,a3,834 <malloc+0x44>
 832:	6a05                	lui	s4,0x1
 834:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 838:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83c:	00000917          	auipc	s2,0x0
 840:	7d490913          	addi	s2,s2,2004 # 1010 <freep>
  if(p == (char*)-1)
 844:	5afd                	li	s5,-1
 846:	a895                	j	8ba <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 848:	00000797          	auipc	a5,0x0
 84c:	7d878793          	addi	a5,a5,2008 # 1020 <base>
 850:	00000717          	auipc	a4,0x0
 854:	7cf73023          	sd	a5,1984(a4) # 1010 <freep>
 858:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 85a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85e:	b7e1                	j	826 <malloc+0x36>
      if(p->s.size == nunits)
 860:	02e48c63          	beq	s1,a4,898 <malloc+0xa8>
        p->s.size -= nunits;
 864:	4137073b          	subw	a4,a4,s3
 868:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86a:	02071693          	slli	a3,a4,0x20
 86e:	01c6d713          	srli	a4,a3,0x1c
 872:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 874:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 878:	00000717          	auipc	a4,0x0
 87c:	78a73c23          	sd	a0,1944(a4) # 1010 <freep>
      return (void*)(p + 1);
 880:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 884:	70e2                	ld	ra,56(sp)
 886:	7442                	ld	s0,48(sp)
 888:	74a2                	ld	s1,40(sp)
 88a:	7902                	ld	s2,32(sp)
 88c:	69e2                	ld	s3,24(sp)
 88e:	6a42                	ld	s4,16(sp)
 890:	6aa2                	ld	s5,8(sp)
 892:	6b02                	ld	s6,0(sp)
 894:	6121                	addi	sp,sp,64
 896:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 898:	6398                	ld	a4,0(a5)
 89a:	e118                	sd	a4,0(a0)
 89c:	bff1                	j	878 <malloc+0x88>
  hp->s.size = nu;
 89e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a2:	0541                	addi	a0,a0,16
 8a4:	00000097          	auipc	ra,0x0
 8a8:	eca080e7          	jalr	-310(ra) # 76e <free>
  return freep;
 8ac:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8b0:	d971                	beqz	a0,884 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b4:	4798                	lw	a4,8(a5)
 8b6:	fa9775e3          	bgeu	a4,s1,860 <malloc+0x70>
    if(p == freep)
 8ba:	00093703          	ld	a4,0(s2)
 8be:	853e                	mv	a0,a5
 8c0:	fef719e3          	bne	a4,a5,8b2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8c4:	8552                	mv	a0,s4
 8c6:	00000097          	auipc	ra,0x0
 8ca:	b40080e7          	jalr	-1216(ra) # 406 <sbrk>
  if(p == (char*)-1)
 8ce:	fd5518e3          	bne	a0,s5,89e <malloc+0xae>
        return 0;
 8d2:	4501                	li	a0,0
 8d4:	bf45                	j	884 <malloc+0x94>

00000000000008d6 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 8d6:	c1d9                	beqz	a1,95c <head_run+0x86>
void head_run(int fd, int numOfLines){
 8d8:	dd010113          	addi	sp,sp,-560
 8dc:	22113423          	sd	ra,552(sp)
 8e0:	22813023          	sd	s0,544(sp)
 8e4:	20913c23          	sd	s1,536(sp)
 8e8:	21213823          	sd	s2,528(sp)
 8ec:	21313423          	sd	s3,520(sp)
 8f0:	21413023          	sd	s4,512(sp)
 8f4:	1c00                	addi	s0,sp,560
 8f6:	892a                	mv	s2,a0
 8f8:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 8fc:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 8fe:	00000a17          	auipc	s4,0x0
 902:	59aa0a13          	addi	s4,s4,1434 # e98 <digits+0x40>
		readStatus = read_line(fd, line);
 906:	dd840593          	addi	a1,s0,-552
 90a:	854a                	mv	a0,s2
 90c:	00000097          	auipc	ra,0x0
 910:	394080e7          	jalr	916(ra) # ca0 <read_line>
		if (readStatus == READ_ERROR){
 914:	01350d63          	beq	a0,s3,92e <head_run+0x58>
		if (readStatus == READ_EOF)
 918:	c11d                	beqz	a0,93e <head_run+0x68>
		printf("%s",line);
 91a:	dd840593          	addi	a1,s0,-552
 91e:	8552                	mv	a0,s4
 920:	00000097          	auipc	ra,0x0
 924:	e18080e7          	jalr	-488(ra) # 738 <printf>
	while(numOfLines--){
 928:	34fd                	addiw	s1,s1,-1
 92a:	fcf1                	bnez	s1,906 <head_run+0x30>
 92c:	a809                	j	93e <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 92e:	00000517          	auipc	a0,0x0
 932:	54250513          	addi	a0,a0,1346 # e70 <digits+0x18>
 936:	00000097          	auipc	ra,0x0
 93a:	e02080e7          	jalr	-510(ra) # 738 <printf>

	}
}
 93e:	22813083          	ld	ra,552(sp)
 942:	22013403          	ld	s0,544(sp)
 946:	21813483          	ld	s1,536(sp)
 94a:	21013903          	ld	s2,528(sp)
 94e:	20813983          	ld	s3,520(sp)
 952:	20013a03          	ld	s4,512(sp)
 956:	23010113          	addi	sp,sp,560
 95a:	8082                	ret
 95c:	8082                	ret

000000000000095e <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 95e:	ba010113          	addi	sp,sp,-1120
 962:	44113c23          	sd	ra,1112(sp)
 966:	44813823          	sd	s0,1104(sp)
 96a:	44913423          	sd	s1,1096(sp)
 96e:	45213023          	sd	s2,1088(sp)
 972:	43313c23          	sd	s3,1080(sp)
 976:	43413823          	sd	s4,1072(sp)
 97a:	43513423          	sd	s5,1064(sp)
 97e:	43613023          	sd	s6,1056(sp)
 982:	41713c23          	sd	s7,1048(sp)
 986:	41813823          	sd	s8,1040(sp)
 98a:	41913423          	sd	s9,1032(sp)
 98e:	41a13023          	sd	s10,1024(sp)
 992:	3fb13c23          	sd	s11,1016(sp)
 996:	46010413          	addi	s0,sp,1120
 99a:	89aa                	mv	s3,a0
 99c:	8aae                	mv	s5,a1
 99e:	8c32                	mv	s8,a2
 9a0:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 9a2:	d9840593          	addi	a1,s0,-616
 9a6:	00000097          	auipc	ra,0x0
 9aa:	2fa080e7          	jalr	762(ra) # ca0 <read_line>


  if (readStatus == READ_ERROR)
 9ae:	57fd                	li	a5,-1
 9b0:	04f50163          	beq	a0,a5,9f2 <uniq_run+0x94>
 9b4:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 9b6:	ed21                	bnez	a0,a0e <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 9b8:	45813083          	ld	ra,1112(sp)
 9bc:	45013403          	ld	s0,1104(sp)
 9c0:	44813483          	ld	s1,1096(sp)
 9c4:	44013903          	ld	s2,1088(sp)
 9c8:	43813983          	ld	s3,1080(sp)
 9cc:	43013a03          	ld	s4,1072(sp)
 9d0:	42813a83          	ld	s5,1064(sp)
 9d4:	42013b03          	ld	s6,1056(sp)
 9d8:	41813b83          	ld	s7,1048(sp)
 9dc:	41013c03          	ld	s8,1040(sp)
 9e0:	40813c83          	ld	s9,1032(sp)
 9e4:	40013d03          	ld	s10,1024(sp)
 9e8:	3f813d83          	ld	s11,1016(sp)
 9ec:	46010113          	addi	sp,sp,1120
 9f0:	8082                	ret
    printf("[ERR] Error reading from the file ");
 9f2:	00000517          	auipc	a0,0x0
 9f6:	4ae50513          	addi	a0,a0,1198 # ea0 <digits+0x48>
 9fa:	00000097          	auipc	ra,0x0
 9fe:	d3e080e7          	jalr	-706(ra) # 738 <printf>
 a02:	bf5d                	j	9b8 <uniq_run+0x5a>
 a04:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a06:	8926                	mv	s2,s1
 a08:	84be                	mv	s1,a5
        lineCount = 1;
 a0a:	8b6a                	mv	s6,s10
 a0c:	a8ed                	j	b06 <uniq_run+0x1a8>
    int lineCount=1;
 a0e:	4b05                	li	s6,1
  char * line2 = buffer2;
 a10:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 a14:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 a18:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 a1a:	4d05                	li	s10,1
              printf("%s",line1);
 a1c:	00000d97          	auipc	s11,0x0
 a20:	47cd8d93          	addi	s11,s11,1148 # e98 <digits+0x40>
 a24:	a0cd                	j	b06 <uniq_run+0x1a8>
            if (repeatedLines){
 a26:	020a0b63          	beqz	s4,a5c <uniq_run+0xfe>
                if (isRepeated){
 a2a:	f80b87e3          	beqz	s7,9b8 <uniq_run+0x5a>
                    if (showCount)
 a2e:	000c0d63          	beqz	s8,a48 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 a32:	864a                	mv	a2,s2
 a34:	85da                	mv	a1,s6
 a36:	00000517          	auipc	a0,0x0
 a3a:	49250513          	addi	a0,a0,1170 # ec8 <digits+0x70>
 a3e:	00000097          	auipc	ra,0x0
 a42:	cfa080e7          	jalr	-774(ra) # 738 <printf>
 a46:	bf8d                	j	9b8 <uniq_run+0x5a>
                      printf("%s",line1);
 a48:	85ca                	mv	a1,s2
 a4a:	00000517          	auipc	a0,0x0
 a4e:	44e50513          	addi	a0,a0,1102 # e98 <digits+0x40>
 a52:	00000097          	auipc	ra,0x0
 a56:	ce6080e7          	jalr	-794(ra) # 738 <printf>
 a5a:	bfb9                	j	9b8 <uniq_run+0x5a>
                if (showCount)
 a5c:	000c0d63          	beqz	s8,a76 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 a60:	864a                	mv	a2,s2
 a62:	85da                	mv	a1,s6
 a64:	00000517          	auipc	a0,0x0
 a68:	46450513          	addi	a0,a0,1124 # ec8 <digits+0x70>
 a6c:	00000097          	auipc	ra,0x0
 a70:	ccc080e7          	jalr	-820(ra) # 738 <printf>
 a74:	b791                	j	9b8 <uniq_run+0x5a>
                  printf("%s",line1);
 a76:	85ca                	mv	a1,s2
 a78:	00000517          	auipc	a0,0x0
 a7c:	42050513          	addi	a0,a0,1056 # e98 <digits+0x40>
 a80:	00000097          	auipc	ra,0x0
 a84:	cb8080e7          	jalr	-840(ra) # 738 <printf>
 a88:	bf05                	j	9b8 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 a8a:	00000517          	auipc	a0,0x0
 a8e:	44650513          	addi	a0,a0,1094 # ed0 <digits+0x78>
 a92:	00000097          	auipc	ra,0x0
 a96:	ca6080e7          	jalr	-858(ra) # 738 <printf>
          break;
 a9a:	bf39                	j	9b8 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 a9c:	85a6                	mv	a1,s1
 a9e:	854a                	mv	a0,s2
 aa0:	00000097          	auipc	ra,0x0
 aa4:	110080e7          	jalr	272(ra) # bb0 <compare_str_ic>
 aa8:	a041                	j	b28 <uniq_run+0x1ca>
                  printf("%s",line1);
 aaa:	85ca                	mv	a1,s2
 aac:	856e                	mv	a0,s11
 aae:	00000097          	auipc	ra,0x0
 ab2:	c8a080e7          	jalr	-886(ra) # 738 <printf>
        lineCount = 1;
 ab6:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 ab8:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 aba:	8926                	mv	s2,s1
                  printf("%s",line1);
 abc:	84be                	mv	s1,a5
        isRepeated = 0 ;
 abe:	4b81                	li	s7,0
 ac0:	a099                	j	b06 <uniq_run+0x1a8>
            if (showCount)
 ac2:	020c0263          	beqz	s8,ae6 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 ac6:	864a                	mv	a2,s2
 ac8:	85da                	mv	a1,s6
 aca:	00000517          	auipc	a0,0x0
 ace:	3fe50513          	addi	a0,a0,1022 # ec8 <digits+0x70>
 ad2:	00000097          	auipc	ra,0x0
 ad6:	c66080e7          	jalr	-922(ra) # 738 <printf>
 ada:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 adc:	8926                	mv	s2,s1
 ade:	84be                	mv	s1,a5
        isRepeated = 0 ;
 ae0:	4b81                	li	s7,0
        lineCount = 1;
 ae2:	8b6a                	mv	s6,s10
 ae4:	a00d                	j	b06 <uniq_run+0x1a8>
              printf("%s",line1);
 ae6:	85ca                	mv	a1,s2
 ae8:	856e                	mv	a0,s11
 aea:	00000097          	auipc	ra,0x0
 aee:	c4e080e7          	jalr	-946(ra) # 738 <printf>
 af2:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 af4:	8926                	mv	s2,s1
              printf("%s",line1);
 af6:	84be                	mv	s1,a5
        isRepeated = 0 ;
 af8:	4b81                	li	s7,0
        lineCount = 1;
 afa:	8b6a                	mv	s6,s10
 afc:	a029                	j	b06 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 afe:	000a0363          	beqz	s4,b04 <uniq_run+0x1a6>
 b02:	8bea                	mv	s7,s10
          lineCount++;
 b04:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 b06:	85a6                	mv	a1,s1
 b08:	854e                	mv	a0,s3
 b0a:	00000097          	auipc	ra,0x0
 b0e:	196080e7          	jalr	406(ra) # ca0 <read_line>
        if (readStatus == READ_EOF){
 b12:	d911                	beqz	a0,a26 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 b14:	f7950be3          	beq	a0,s9,a8a <uniq_run+0x12c>
        if (!ignoreCase)
 b18:	f80a92e3          	bnez	s5,a9c <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 b1c:	85a6                	mv	a1,s1
 b1e:	854a                	mv	a0,s2
 b20:	00000097          	auipc	ra,0x0
 b24:	062080e7          	jalr	98(ra) # b82 <compare_str>
        if (compareStatus != 0){ 
 b28:	d979                	beqz	a0,afe <uniq_run+0x1a0>
          if (repeatedLines){
 b2a:	f80a0ce3          	beqz	s4,ac2 <uniq_run+0x164>
            if (isRepeated){
 b2e:	ec0b8be3          	beqz	s7,a04 <uniq_run+0xa6>
                if (showCount)
 b32:	f60c0ce3          	beqz	s8,aaa <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 b36:	864a                	mv	a2,s2
 b38:	85da                	mv	a1,s6
 b3a:	00000517          	auipc	a0,0x0
 b3e:	38e50513          	addi	a0,a0,910 # ec8 <digits+0x70>
 b42:	00000097          	auipc	ra,0x0
 b46:	bf6080e7          	jalr	-1034(ra) # 738 <printf>
        lineCount = 1;
 b4a:	8b5e                	mv	s6,s7
 b4c:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b4e:	8926                	mv	s2,s1
 b50:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b52:	4b81                	li	s7,0
 b54:	bf4d                	j	b06 <uniq_run+0x1a8>

0000000000000b56 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 b56:	1141                	addi	sp,sp,-16
 b58:	e422                	sd	s0,8(sp)
 b5a:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 b5c:	00054783          	lbu	a5,0(a0)
 b60:	cf99                	beqz	a5,b7e <get_strlen+0x28>
 b62:	00150713          	addi	a4,a0,1
 b66:	87ba                	mv	a5,a4
 b68:	4685                	li	a3,1
 b6a:	9e99                	subw	a3,a3,a4
 b6c:	00f6853b          	addw	a0,a3,a5
 b70:	0785                	addi	a5,a5,1
 b72:	fff7c703          	lbu	a4,-1(a5)
 b76:	fb7d                	bnez	a4,b6c <get_strlen+0x16>
	return len;
}
 b78:	6422                	ld	s0,8(sp)
 b7a:	0141                	addi	sp,sp,16
 b7c:	8082                	ret
	int len = 0;
 b7e:	4501                	li	a0,0
 b80:	bfe5                	j	b78 <get_strlen+0x22>

0000000000000b82 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 b82:	1141                	addi	sp,sp,-16
 b84:	e422                	sd	s0,8(sp)
 b86:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 b88:	00054783          	lbu	a5,0(a0)
 b8c:	cb91                	beqz	a5,ba0 <compare_str+0x1e>
 b8e:	0005c703          	lbu	a4,0(a1)
 b92:	c719                	beqz	a4,ba0 <compare_str+0x1e>
		if (*s1++ != *s2++)
 b94:	0505                	addi	a0,a0,1
 b96:	0585                	addi	a1,a1,1
 b98:	fee788e3          	beq	a5,a4,b88 <compare_str+0x6>
			return 1;
 b9c:	4505                	li	a0,1
 b9e:	a031                	j	baa <compare_str+0x28>
	}
	if (*s1 == *s2)
 ba0:	0005c503          	lbu	a0,0(a1)
 ba4:	8d1d                	sub	a0,a0,a5
			return 1;
 ba6:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 baa:	6422                	ld	s0,8(sp)
 bac:	0141                	addi	sp,sp,16
 bae:	8082                	ret

0000000000000bb0 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 bb0:	1141                	addi	sp,sp,-16
 bb2:	e422                	sd	s0,8(sp)
 bb4:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 bb6:	4665                	li	a2,25
	while(*s1 && *s2){
 bb8:	a019                	j	bbe <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 bba:	04e79763          	bne	a5,a4,c08 <compare_str_ic+0x58>
	while(*s1 && *s2){
 bbe:	00054783          	lbu	a5,0(a0)
 bc2:	cb9d                	beqz	a5,bf8 <compare_str_ic+0x48>
 bc4:	0005c703          	lbu	a4,0(a1)
 bc8:	cb05                	beqz	a4,bf8 <compare_str_ic+0x48>
		char b1 = *s1++;
 bca:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 bcc:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 bce:	fbf7869b          	addiw	a3,a5,-65
 bd2:	0ff6f693          	zext.b	a3,a3
 bd6:	00d66663          	bltu	a2,a3,be2 <compare_str_ic+0x32>
			b1 += 32;
 bda:	0207879b          	addiw	a5,a5,32
 bde:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 be2:	fbf7069b          	addiw	a3,a4,-65
 be6:	0ff6f693          	zext.b	a3,a3
 bea:	fcd668e3          	bltu	a2,a3,bba <compare_str_ic+0xa>
			b2 += 32;
 bee:	0207071b          	addiw	a4,a4,32
 bf2:	0ff77713          	zext.b	a4,a4
 bf6:	b7d1                	j	bba <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 bf8:	0005c503          	lbu	a0,0(a1)
 bfc:	8d1d                	sub	a0,a0,a5
			return 1;
 bfe:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 c02:	6422                	ld	s0,8(sp)
 c04:	0141                	addi	sp,sp,16
 c06:	8082                	ret
			return 1;
 c08:	4505                	li	a0,1
 c0a:	bfe5                	j	c02 <compare_str_ic+0x52>

0000000000000c0c <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 c0c:	7179                	addi	sp,sp,-48
 c0e:	f406                	sd	ra,40(sp)
 c10:	f022                	sd	s0,32(sp)
 c12:	ec26                	sd	s1,24(sp)
 c14:	e84a                	sd	s2,16(sp)
 c16:	e44e                	sd	s3,8(sp)
 c18:	1800                	addi	s0,sp,48
 c1a:	89aa                	mv	s3,a0
 c1c:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 c1e:	00000097          	auipc	ra,0x0
 c22:	f38080e7          	jalr	-200(ra) # b56 <get_strlen>
 c26:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 c28:	854a                	mv	a0,s2
 c2a:	00000097          	auipc	ra,0x0
 c2e:	f2c080e7          	jalr	-212(ra) # b56 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 c32:	409505bb          	subw	a1,a0,s1
 c36:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 c38:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 c3a:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 c3c:	0005da63          	bgez	a1,c50 <check_substr+0x44>
 c40:	a81d                	j	c76 <check_substr+0x6a>
        if (j == M)
 c42:	02f48a63          	beq	s1,a5,c76 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 c46:	0885                	addi	a7,a7,1
 c48:	0008879b          	sext.w	a5,a7
 c4c:	02f5cc63          	blt	a1,a5,c84 <check_substr+0x78>
 c50:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 c54:	011906b3          	add	a3,s2,a7
 c58:	874e                	mv	a4,s3
 c5a:	879a                	mv	a5,t1
 c5c:	fe9053e3          	blez	s1,c42 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 c60:	0006c803          	lbu	a6,0(a3) # 1000 <argv>
 c64:	00074603          	lbu	a2,0(a4)
 c68:	fcc81de3          	bne	a6,a2,c42 <check_substr+0x36>
        for (j = 0; j < M; j++)
 c6c:	2785                	addiw	a5,a5,1
 c6e:	0685                	addi	a3,a3,1
 c70:	0705                	addi	a4,a4,1
 c72:	fef497e3          	bne	s1,a5,c60 <check_substr+0x54>
}
 c76:	70a2                	ld	ra,40(sp)
 c78:	7402                	ld	s0,32(sp)
 c7a:	64e2                	ld	s1,24(sp)
 c7c:	6942                	ld	s2,16(sp)
 c7e:	69a2                	ld	s3,8(sp)
 c80:	6145                	addi	sp,sp,48
 c82:	8082                	ret
    return -1;
 c84:	557d                	li	a0,-1
 c86:	bfc5                	j	c76 <check_substr+0x6a>

0000000000000c88 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 c88:	1141                	addi	sp,sp,-16
 c8a:	e406                	sd	ra,8(sp)
 c8c:	e022                	sd	s0,0(sp)
 c8e:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 c90:	fffff097          	auipc	ra,0xfffff
 c94:	72e080e7          	jalr	1838(ra) # 3be <open>
	return fd;
}
 c98:	60a2                	ld	ra,8(sp)
 c9a:	6402                	ld	s0,0(sp)
 c9c:	0141                	addi	sp,sp,16
 c9e:	8082                	ret

0000000000000ca0 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 ca0:	7139                	addi	sp,sp,-64
 ca2:	fc06                	sd	ra,56(sp)
 ca4:	f822                	sd	s0,48(sp)
 ca6:	f426                	sd	s1,40(sp)
 ca8:	f04a                	sd	s2,32(sp)
 caa:	ec4e                	sd	s3,24(sp)
 cac:	e852                	sd	s4,16(sp)
 cae:	0080                	addi	s0,sp,64
 cb0:	89aa                	mv	s3,a0
 cb2:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 cb4:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 cb6:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 cb8:	4605                	li	a2,1
 cba:	fcf40593          	addi	a1,s0,-49
 cbe:	854e                	mv	a0,s3
 cc0:	fffff097          	auipc	ra,0xfffff
 cc4:	6d6080e7          	jalr	1750(ra) # 396 <read>
		if (readStatus == 0){
 cc8:	c505                	beqz	a0,cf0 <read_line+0x50>
		*buffer++ = readByte;
 cca:	0485                	addi	s1,s1,1
 ccc:	fcf44783          	lbu	a5,-49(s0)
 cd0:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 cd4:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 cd6:	ff4791e3          	bne	a5,s4,cb8 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 cda:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 cde:	854a                	mv	a0,s2
 ce0:	70e2                	ld	ra,56(sp)
 ce2:	7442                	ld	s0,48(sp)
 ce4:	74a2                	ld	s1,40(sp)
 ce6:	7902                	ld	s2,32(sp)
 ce8:	69e2                	ld	s3,24(sp)
 cea:	6a42                	ld	s4,16(sp)
 cec:	6121                	addi	sp,sp,64
 cee:	8082                	ret
			if (byteCount!=0){
 cf0:	fe0907e3          	beqz	s2,cde <read_line+0x3e>
				*buffer = '\n';
 cf4:	47a9                	li	a5,10
 cf6:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 cfa:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 cfe:	2905                	addiw	s2,s2,1
 d00:	bff9                	j	cde <read_line+0x3e>

0000000000000d02 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 d02:	1141                	addi	sp,sp,-16
 d04:	e406                	sd	ra,8(sp)
 d06:	e022                	sd	s0,0(sp)
 d08:	0800                	addi	s0,sp,16
	close(fd);
 d0a:	fffff097          	auipc	ra,0xfffff
 d0e:	69c080e7          	jalr	1692(ra) # 3a6 <close>
}
 d12:	60a2                	ld	ra,8(sp)
 d14:	6402                	ld	s0,0(sp)
 d16:	0141                	addi	sp,sp,16
 d18:	8082                	ret

0000000000000d1a <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 d1a:	7139                	addi	sp,sp,-64
 d1c:	fc06                	sd	ra,56(sp)
 d1e:	f822                	sd	s0,48(sp)
 d20:	f426                	sd	s1,40(sp)
 d22:	f04a                	sd	s2,32(sp)
 d24:	0080                	addi	s0,sp,64
 d26:	84aa                	mv	s1,a0
 d28:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 d2a:	fffff097          	auipc	ra,0xfffff
 d2e:	64c080e7          	jalr	1612(ra) # 376 <fork>
 d32:	ed19                	bnez	a0,d50 <get_time_perf+0x36>
		exec(argv[0],argv);
 d34:	85ca                	mv	a1,s2
 d36:	00093503          	ld	a0,0(s2)
 d3a:	fffff097          	auipc	ra,0xfffff
 d3e:	67c080e7          	jalr	1660(ra) # 3b6 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 d42:	8526                	mv	a0,s1
 d44:	70e2                	ld	ra,56(sp)
 d46:	7442                	ld	s0,48(sp)
 d48:	74a2                	ld	s1,40(sp)
 d4a:	7902                	ld	s2,32(sp)
 d4c:	6121                	addi	sp,sp,64
 d4e:	8082                	ret
		times(pid , &time);
 d50:	fc040593          	addi	a1,s0,-64
 d54:	fffff097          	auipc	ra,0xfffff
 d58:	6e2080e7          	jalr	1762(ra) # 436 <times>
		return time;
 d5c:	fc043783          	ld	a5,-64(s0)
 d60:	e09c                	sd	a5,0(s1)
 d62:	fc843783          	ld	a5,-56(s0)
 d66:	e49c                	sd	a5,8(s1)
 d68:	fd043783          	ld	a5,-48(s0)
 d6c:	e89c                	sd	a5,16(s1)
 d6e:	fd843783          	ld	a5,-40(s0)
 d72:	ec9c                	sd	a5,24(s1)
 d74:	b7f9                	j	d42 <get_time_perf+0x28>
