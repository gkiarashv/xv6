
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
  12:	c7250513          	addi	a0,a0,-910 # c80 <close_file+0x1e>
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
  3a:	c5290913          	addi	s2,s2,-942 # c88 <close_file+0x26>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6c8080e7          	jalr	1736(ra) # 708 <printf>
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
  6e:	c6e50513          	addi	a0,a0,-914 # cd8 <close_file+0x76>
  72:	00000097          	auipc	ra,0x0
  76:	696080e7          	jalr	1686(ra) # 708 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	302080e7          	jalr	770(ra) # 37e <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	bf850513          	addi	a0,a0,-1032 # c80 <close_file+0x1e>
  90:	00000097          	auipc	ra,0x0
  94:	336080e7          	jalr	822(ra) # 3c6 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	be650513          	addi	a0,a0,-1050 # c80 <close_file+0x1e>
  a2:	00000097          	auipc	ra,0x0
  a6:	31c080e7          	jalr	796(ra) # 3be <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	bf450513          	addi	a0,a0,-1036 # ca0 <close_file+0x3e>
  b4:	00000097          	auipc	ra,0x0
  b8:	654080e7          	jalr	1620(ra) # 708 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2c0080e7          	jalr	704(ra) # 37e <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f3a58593          	addi	a1,a1,-198 # 1000 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	bea50513          	addi	a0,a0,-1046 # cb8 <close_file+0x56>
  d6:	00000097          	auipc	ra,0x0
  da:	2e0080e7          	jalr	736(ra) # 3b6 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	be250513          	addi	a0,a0,-1054 # cc0 <close_file+0x5e>
  e6:	00000097          	auipc	ra,0x0
  ea:	622080e7          	jalr	1570(ra) # 708 <printf>
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

000000000000042e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 42e:	1101                	addi	sp,sp,-32
 430:	ec06                	sd	ra,24(sp)
 432:	e822                	sd	s0,16(sp)
 434:	1000                	addi	s0,sp,32
 436:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 43a:	4605                	li	a2,1
 43c:	fef40593          	addi	a1,s0,-17
 440:	00000097          	auipc	ra,0x0
 444:	f5e080e7          	jalr	-162(ra) # 39e <write>
}
 448:	60e2                	ld	ra,24(sp)
 44a:	6442                	ld	s0,16(sp)
 44c:	6105                	addi	sp,sp,32
 44e:	8082                	ret

0000000000000450 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 450:	7139                	addi	sp,sp,-64
 452:	fc06                	sd	ra,56(sp)
 454:	f822                	sd	s0,48(sp)
 456:	f426                	sd	s1,40(sp)
 458:	f04a                	sd	s2,32(sp)
 45a:	ec4e                	sd	s3,24(sp)
 45c:	0080                	addi	s0,sp,64
 45e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 460:	c299                	beqz	a3,466 <printint+0x16>
 462:	0805c963          	bltz	a1,4f4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 466:	2581                	sext.w	a1,a1
  neg = 0;
 468:	4881                	li	a7,0
 46a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 46e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 470:	2601                	sext.w	a2,a2
 472:	00001517          	auipc	a0,0x1
 476:	8e650513          	addi	a0,a0,-1818 # d58 <digits>
 47a:	883a                	mv	a6,a4
 47c:	2705                	addiw	a4,a4,1
 47e:	02c5f7bb          	remuw	a5,a1,a2
 482:	1782                	slli	a5,a5,0x20
 484:	9381                	srli	a5,a5,0x20
 486:	97aa                	add	a5,a5,a0
 488:	0007c783          	lbu	a5,0(a5)
 48c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 490:	0005879b          	sext.w	a5,a1
 494:	02c5d5bb          	divuw	a1,a1,a2
 498:	0685                	addi	a3,a3,1
 49a:	fec7f0e3          	bgeu	a5,a2,47a <printint+0x2a>
  if(neg)
 49e:	00088c63          	beqz	a7,4b6 <printint+0x66>
    buf[i++] = '-';
 4a2:	fd070793          	addi	a5,a4,-48
 4a6:	00878733          	add	a4,a5,s0
 4aa:	02d00793          	li	a5,45
 4ae:	fef70823          	sb	a5,-16(a4)
 4b2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4b6:	02e05863          	blez	a4,4e6 <printint+0x96>
 4ba:	fc040793          	addi	a5,s0,-64
 4be:	00e78933          	add	s2,a5,a4
 4c2:	fff78993          	addi	s3,a5,-1
 4c6:	99ba                	add	s3,s3,a4
 4c8:	377d                	addiw	a4,a4,-1
 4ca:	1702                	slli	a4,a4,0x20
 4cc:	9301                	srli	a4,a4,0x20
 4ce:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d2:	fff94583          	lbu	a1,-1(s2)
 4d6:	8526                	mv	a0,s1
 4d8:	00000097          	auipc	ra,0x0
 4dc:	f56080e7          	jalr	-170(ra) # 42e <putc>
  while(--i >= 0)
 4e0:	197d                	addi	s2,s2,-1
 4e2:	ff3918e3          	bne	s2,s3,4d2 <printint+0x82>
}
 4e6:	70e2                	ld	ra,56(sp)
 4e8:	7442                	ld	s0,48(sp)
 4ea:	74a2                	ld	s1,40(sp)
 4ec:	7902                	ld	s2,32(sp)
 4ee:	69e2                	ld	s3,24(sp)
 4f0:	6121                	addi	sp,sp,64
 4f2:	8082                	ret
    x = -xx;
 4f4:	40b005bb          	negw	a1,a1
    neg = 1;
 4f8:	4885                	li	a7,1
    x = -xx;
 4fa:	bf85                	j	46a <printint+0x1a>

00000000000004fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fc:	7119                	addi	sp,sp,-128
 4fe:	fc86                	sd	ra,120(sp)
 500:	f8a2                	sd	s0,112(sp)
 502:	f4a6                	sd	s1,104(sp)
 504:	f0ca                	sd	s2,96(sp)
 506:	ecce                	sd	s3,88(sp)
 508:	e8d2                	sd	s4,80(sp)
 50a:	e4d6                	sd	s5,72(sp)
 50c:	e0da                	sd	s6,64(sp)
 50e:	fc5e                	sd	s7,56(sp)
 510:	f862                	sd	s8,48(sp)
 512:	f466                	sd	s9,40(sp)
 514:	f06a                	sd	s10,32(sp)
 516:	ec6e                	sd	s11,24(sp)
 518:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 51a:	0005c903          	lbu	s2,0(a1)
 51e:	18090f63          	beqz	s2,6bc <vprintf+0x1c0>
 522:	8aaa                	mv	s5,a0
 524:	8b32                	mv	s6,a2
 526:	00158493          	addi	s1,a1,1
  state = 0;
 52a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 52c:	02500a13          	li	s4,37
 530:	4c55                	li	s8,21
 532:	00000c97          	auipc	s9,0x0
 536:	7cec8c93          	addi	s9,s9,1998 # d00 <close_file+0x9e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 53a:	02800d93          	li	s11,40
  putc(fd, 'x');
 53e:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 540:	00001b97          	auipc	s7,0x1
 544:	818b8b93          	addi	s7,s7,-2024 # d58 <digits>
 548:	a839                	j	566 <vprintf+0x6a>
        putc(fd, c);
 54a:	85ca                	mv	a1,s2
 54c:	8556                	mv	a0,s5
 54e:	00000097          	auipc	ra,0x0
 552:	ee0080e7          	jalr	-288(ra) # 42e <putc>
 556:	a019                	j	55c <vprintf+0x60>
    } else if(state == '%'){
 558:	01498d63          	beq	s3,s4,572 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 55c:	0485                	addi	s1,s1,1
 55e:	fff4c903          	lbu	s2,-1(s1)
 562:	14090d63          	beqz	s2,6bc <vprintf+0x1c0>
    if(state == 0){
 566:	fe0999e3          	bnez	s3,558 <vprintf+0x5c>
      if(c == '%'){
 56a:	ff4910e3          	bne	s2,s4,54a <vprintf+0x4e>
        state = '%';
 56e:	89d2                	mv	s3,s4
 570:	b7f5                	j	55c <vprintf+0x60>
      if(c == 'd'){
 572:	11490c63          	beq	s2,s4,68a <vprintf+0x18e>
 576:	f9d9079b          	addiw	a5,s2,-99
 57a:	0ff7f793          	zext.b	a5,a5
 57e:	10fc6e63          	bltu	s8,a5,69a <vprintf+0x19e>
 582:	f9d9079b          	addiw	a5,s2,-99
 586:	0ff7f713          	zext.b	a4,a5
 58a:	10ec6863          	bltu	s8,a4,69a <vprintf+0x19e>
 58e:	00271793          	slli	a5,a4,0x2
 592:	97e6                	add	a5,a5,s9
 594:	439c                	lw	a5,0(a5)
 596:	97e6                	add	a5,a5,s9
 598:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 59a:	008b0913          	addi	s2,s6,8
 59e:	4685                	li	a3,1
 5a0:	4629                	li	a2,10
 5a2:	000b2583          	lw	a1,0(s6)
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	ea8080e7          	jalr	-344(ra) # 450 <printint>
 5b0:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	b765                	j	55c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b6:	008b0913          	addi	s2,s6,8
 5ba:	4681                	li	a3,0
 5bc:	4629                	li	a2,10
 5be:	000b2583          	lw	a1,0(s6)
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	e8c080e7          	jalr	-372(ra) # 450 <printint>
 5cc:	8b4a                	mv	s6,s2
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b771                	j	55c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5d2:	008b0913          	addi	s2,s6,8
 5d6:	4681                	li	a3,0
 5d8:	866a                	mv	a2,s10
 5da:	000b2583          	lw	a1,0(s6)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e70080e7          	jalr	-400(ra) # 450 <printint>
 5e8:	8b4a                	mv	s6,s2
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	bf85                	j	55c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5ee:	008b0793          	addi	a5,s6,8
 5f2:	f8f43423          	sd	a5,-120(s0)
 5f6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5fa:	03000593          	li	a1,48
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	e2e080e7          	jalr	-466(ra) # 42e <putc>
  putc(fd, 'x');
 608:	07800593          	li	a1,120
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e20080e7          	jalr	-480(ra) # 42e <putc>
 616:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 618:	03c9d793          	srli	a5,s3,0x3c
 61c:	97de                	add	a5,a5,s7
 61e:	0007c583          	lbu	a1,0(a5)
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	e0a080e7          	jalr	-502(ra) # 42e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 62c:	0992                	slli	s3,s3,0x4
 62e:	397d                	addiw	s2,s2,-1
 630:	fe0914e3          	bnez	s2,618 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 634:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 638:	4981                	li	s3,0
 63a:	b70d                	j	55c <vprintf+0x60>
        s = va_arg(ap, char*);
 63c:	008b0913          	addi	s2,s6,8
 640:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 644:	02098163          	beqz	s3,666 <vprintf+0x16a>
        while(*s != 0){
 648:	0009c583          	lbu	a1,0(s3)
 64c:	c5ad                	beqz	a1,6b6 <vprintf+0x1ba>
          putc(fd, *s);
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	dde080e7          	jalr	-546(ra) # 42e <putc>
          s++;
 658:	0985                	addi	s3,s3,1
        while(*s != 0){
 65a:	0009c583          	lbu	a1,0(s3)
 65e:	f9e5                	bnez	a1,64e <vprintf+0x152>
        s = va_arg(ap, char*);
 660:	8b4a                	mv	s6,s2
      state = 0;
 662:	4981                	li	s3,0
 664:	bde5                	j	55c <vprintf+0x60>
          s = "(null)";
 666:	00000997          	auipc	s3,0x0
 66a:	69298993          	addi	s3,s3,1682 # cf8 <close_file+0x96>
        while(*s != 0){
 66e:	85ee                	mv	a1,s11
 670:	bff9                	j	64e <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 672:	008b0913          	addi	s2,s6,8
 676:	000b4583          	lbu	a1,0(s6)
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	db2080e7          	jalr	-590(ra) # 42e <putc>
 684:	8b4a                	mv	s6,s2
      state = 0;
 686:	4981                	li	s3,0
 688:	bdd1                	j	55c <vprintf+0x60>
        putc(fd, c);
 68a:	85d2                	mv	a1,s4
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	da0080e7          	jalr	-608(ra) # 42e <putc>
      state = 0;
 696:	4981                	li	s3,0
 698:	b5d1                	j	55c <vprintf+0x60>
        putc(fd, '%');
 69a:	85d2                	mv	a1,s4
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	d90080e7          	jalr	-624(ra) # 42e <putc>
        putc(fd, c);
 6a6:	85ca                	mv	a1,s2
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	d84080e7          	jalr	-636(ra) # 42e <putc>
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	b565                	j	55c <vprintf+0x60>
        s = va_arg(ap, char*);
 6b6:	8b4a                	mv	s6,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b54d                	j	55c <vprintf+0x60>
    }
  }
}
 6bc:	70e6                	ld	ra,120(sp)
 6be:	7446                	ld	s0,112(sp)
 6c0:	74a6                	ld	s1,104(sp)
 6c2:	7906                	ld	s2,96(sp)
 6c4:	69e6                	ld	s3,88(sp)
 6c6:	6a46                	ld	s4,80(sp)
 6c8:	6aa6                	ld	s5,72(sp)
 6ca:	6b06                	ld	s6,64(sp)
 6cc:	7be2                	ld	s7,56(sp)
 6ce:	7c42                	ld	s8,48(sp)
 6d0:	7ca2                	ld	s9,40(sp)
 6d2:	7d02                	ld	s10,32(sp)
 6d4:	6de2                	ld	s11,24(sp)
 6d6:	6109                	addi	sp,sp,128
 6d8:	8082                	ret

00000000000006da <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6da:	715d                	addi	sp,sp,-80
 6dc:	ec06                	sd	ra,24(sp)
 6de:	e822                	sd	s0,16(sp)
 6e0:	1000                	addi	s0,sp,32
 6e2:	e010                	sd	a2,0(s0)
 6e4:	e414                	sd	a3,8(s0)
 6e6:	e818                	sd	a4,16(s0)
 6e8:	ec1c                	sd	a5,24(s0)
 6ea:	03043023          	sd	a6,32(s0)
 6ee:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f6:	8622                	mv	a2,s0
 6f8:	00000097          	auipc	ra,0x0
 6fc:	e04080e7          	jalr	-508(ra) # 4fc <vprintf>
}
 700:	60e2                	ld	ra,24(sp)
 702:	6442                	ld	s0,16(sp)
 704:	6161                	addi	sp,sp,80
 706:	8082                	ret

0000000000000708 <printf>:

void
printf(const char *fmt, ...)
{
 708:	711d                	addi	sp,sp,-96
 70a:	ec06                	sd	ra,24(sp)
 70c:	e822                	sd	s0,16(sp)
 70e:	1000                	addi	s0,sp,32
 710:	e40c                	sd	a1,8(s0)
 712:	e810                	sd	a2,16(s0)
 714:	ec14                	sd	a3,24(s0)
 716:	f018                	sd	a4,32(s0)
 718:	f41c                	sd	a5,40(s0)
 71a:	03043823          	sd	a6,48(s0)
 71e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 722:	00840613          	addi	a2,s0,8
 726:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 72a:	85aa                	mv	a1,a0
 72c:	4505                	li	a0,1
 72e:	00000097          	auipc	ra,0x0
 732:	dce080e7          	jalr	-562(ra) # 4fc <vprintf>
}
 736:	60e2                	ld	ra,24(sp)
 738:	6442                	ld	s0,16(sp)
 73a:	6125                	addi	sp,sp,96
 73c:	8082                	ret

000000000000073e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 73e:	1141                	addi	sp,sp,-16
 740:	e422                	sd	s0,8(sp)
 742:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 744:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 748:	00001797          	auipc	a5,0x1
 74c:	8c87b783          	ld	a5,-1848(a5) # 1010 <freep>
 750:	a02d                	j	77a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 752:	4618                	lw	a4,8(a2)
 754:	9f2d                	addw	a4,a4,a1
 756:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 75a:	6398                	ld	a4,0(a5)
 75c:	6310                	ld	a2,0(a4)
 75e:	a83d                	j	79c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 760:	ff852703          	lw	a4,-8(a0)
 764:	9f31                	addw	a4,a4,a2
 766:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 768:	ff053683          	ld	a3,-16(a0)
 76c:	a091                	j	7b0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76e:	6398                	ld	a4,0(a5)
 770:	00e7e463          	bltu	a5,a4,778 <free+0x3a>
 774:	00e6ea63          	bltu	a3,a4,788 <free+0x4a>
{
 778:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77a:	fed7fae3          	bgeu	a5,a3,76e <free+0x30>
 77e:	6398                	ld	a4,0(a5)
 780:	00e6e463          	bltu	a3,a4,788 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 784:	fee7eae3          	bltu	a5,a4,778 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 788:	ff852583          	lw	a1,-8(a0)
 78c:	6390                	ld	a2,0(a5)
 78e:	02059813          	slli	a6,a1,0x20
 792:	01c85713          	srli	a4,a6,0x1c
 796:	9736                	add	a4,a4,a3
 798:	fae60de3          	beq	a2,a4,752 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 79c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7a0:	4790                	lw	a2,8(a5)
 7a2:	02061593          	slli	a1,a2,0x20
 7a6:	01c5d713          	srli	a4,a1,0x1c
 7aa:	973e                	add	a4,a4,a5
 7ac:	fae68ae3          	beq	a3,a4,760 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7b0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7b2:	00001717          	auipc	a4,0x1
 7b6:	84f73f23          	sd	a5,-1954(a4) # 1010 <freep>
}
 7ba:	6422                	ld	s0,8(sp)
 7bc:	0141                	addi	sp,sp,16
 7be:	8082                	ret

00000000000007c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c0:	7139                	addi	sp,sp,-64
 7c2:	fc06                	sd	ra,56(sp)
 7c4:	f822                	sd	s0,48(sp)
 7c6:	f426                	sd	s1,40(sp)
 7c8:	f04a                	sd	s2,32(sp)
 7ca:	ec4e                	sd	s3,24(sp)
 7cc:	e852                	sd	s4,16(sp)
 7ce:	e456                	sd	s5,8(sp)
 7d0:	e05a                	sd	s6,0(sp)
 7d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d4:	02051493          	slli	s1,a0,0x20
 7d8:	9081                	srli	s1,s1,0x20
 7da:	04bd                	addi	s1,s1,15
 7dc:	8091                	srli	s1,s1,0x4
 7de:	0014899b          	addiw	s3,s1,1
 7e2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7e4:	00001517          	auipc	a0,0x1
 7e8:	82c53503          	ld	a0,-2004(a0) # 1010 <freep>
 7ec:	c515                	beqz	a0,818 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f0:	4798                	lw	a4,8(a5)
 7f2:	02977f63          	bgeu	a4,s1,830 <malloc+0x70>
 7f6:	8a4e                	mv	s4,s3
 7f8:	0009871b          	sext.w	a4,s3
 7fc:	6685                	lui	a3,0x1
 7fe:	00d77363          	bgeu	a4,a3,804 <malloc+0x44>
 802:	6a05                	lui	s4,0x1
 804:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 808:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 80c:	00001917          	auipc	s2,0x1
 810:	80490913          	addi	s2,s2,-2044 # 1010 <freep>
  if(p == (char*)-1)
 814:	5afd                	li	s5,-1
 816:	a895                	j	88a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 818:	00001797          	auipc	a5,0x1
 81c:	80878793          	addi	a5,a5,-2040 # 1020 <base>
 820:	00000717          	auipc	a4,0x0
 824:	7ef73823          	sd	a5,2032(a4) # 1010 <freep>
 828:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 82a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 82e:	b7e1                	j	7f6 <malloc+0x36>
      if(p->s.size == nunits)
 830:	02e48c63          	beq	s1,a4,868 <malloc+0xa8>
        p->s.size -= nunits;
 834:	4137073b          	subw	a4,a4,s3
 838:	c798                	sw	a4,8(a5)
        p += p->s.size;
 83a:	02071693          	slli	a3,a4,0x20
 83e:	01c6d713          	srli	a4,a3,0x1c
 842:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 844:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 848:	00000717          	auipc	a4,0x0
 84c:	7ca73423          	sd	a0,1992(a4) # 1010 <freep>
      return (void*)(p + 1);
 850:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 854:	70e2                	ld	ra,56(sp)
 856:	7442                	ld	s0,48(sp)
 858:	74a2                	ld	s1,40(sp)
 85a:	7902                	ld	s2,32(sp)
 85c:	69e2                	ld	s3,24(sp)
 85e:	6a42                	ld	s4,16(sp)
 860:	6aa2                	ld	s5,8(sp)
 862:	6b02                	ld	s6,0(sp)
 864:	6121                	addi	sp,sp,64
 866:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 868:	6398                	ld	a4,0(a5)
 86a:	e118                	sd	a4,0(a0)
 86c:	bff1                	j	848 <malloc+0x88>
  hp->s.size = nu;
 86e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 872:	0541                	addi	a0,a0,16
 874:	00000097          	auipc	ra,0x0
 878:	eca080e7          	jalr	-310(ra) # 73e <free>
  return freep;
 87c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 880:	d971                	beqz	a0,854 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 882:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 884:	4798                	lw	a4,8(a5)
 886:	fa9775e3          	bgeu	a4,s1,830 <malloc+0x70>
    if(p == freep)
 88a:	00093703          	ld	a4,0(s2)
 88e:	853e                	mv	a0,a5
 890:	fef719e3          	bne	a4,a5,882 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 894:	8552                	mv	a0,s4
 896:	00000097          	auipc	ra,0x0
 89a:	b70080e7          	jalr	-1168(ra) # 406 <sbrk>
  if(p == (char*)-1)
 89e:	fd5518e3          	bne	a0,s5,86e <malloc+0xae>
        return 0;
 8a2:	4501                	li	a0,0
 8a4:	bf45                	j	854 <malloc+0x94>

00000000000008a6 <head_run>:
#include "user/user.h"
#include "gelibs/file.h"

extern int read_line(int fd, char * buffer);

void head_run(int fd, int numOfLines){
 8a6:	dc010113          	addi	sp,sp,-576
 8aa:	22113c23          	sd	ra,568(sp)
 8ae:	22813823          	sd	s0,560(sp)
 8b2:	22913423          	sd	s1,552(sp)
 8b6:	23213023          	sd	s2,544(sp)
 8ba:	21313c23          	sd	s3,536(sp)
 8be:	21413823          	sd	s4,528(sp)
 8c2:	21513423          	sd	s5,520(sp)
 8c6:	0480                	addi	s0,sp,576
 8c8:	89aa                	mv	s3,a0
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 8ca:	892e                	mv	s2,a1

		readStatus = read_line(fd, line);
		
		if (readStatus == READ_ERROR){
 8cc:	5a7d                	li	s4,-1
			printf("[ERR] Error reading from the file \n");
			break;
		}

		printf("%s",line);
 8ce:	00000a97          	auipc	s5,0x0
 8d2:	4caa8a93          	addi	s5,s5,1226 # d98 <digits+0x40>
	while(numOfLines--){
 8d6:	02090e63          	beqz	s2,912 <head_run+0x6c>
		readStatus = read_line(fd, line);
 8da:	dc840593          	addi	a1,s0,-568
 8de:	854e                	mv	a0,s3
 8e0:	00000097          	auipc	ra,0x0
 8e4:	324080e7          	jalr	804(ra) # c04 <read_line>
 8e8:	84aa                	mv	s1,a0
		if (readStatus == READ_ERROR){
 8ea:	01450c63          	beq	a0,s4,902 <head_run+0x5c>
		printf("%s",line);
 8ee:	dc840593          	addi	a1,s0,-568
 8f2:	8556                	mv	a0,s5
 8f4:	00000097          	auipc	ra,0x0
 8f8:	e14080e7          	jalr	-492(ra) # 708 <printf>

		if (readStatus == READ_EOF )
 8fc:	397d                	addiw	s2,s2,-1
 8fe:	fce1                	bnez	s1,8d6 <head_run+0x30>
 900:	a809                	j	912 <head_run+0x6c>
			printf("[ERR] Error reading from the file \n");
 902:	00000517          	auipc	a0,0x0
 906:	46e50513          	addi	a0,a0,1134 # d70 <digits+0x18>
 90a:	00000097          	auipc	ra,0x0
 90e:	dfe080e7          	jalr	-514(ra) # 708 <printf>
			break;
	}
}
 912:	23813083          	ld	ra,568(sp)
 916:	23013403          	ld	s0,560(sp)
 91a:	22813483          	ld	s1,552(sp)
 91e:	22013903          	ld	s2,544(sp)
 922:	21813983          	ld	s3,536(sp)
 926:	21013a03          	ld	s4,528(sp)
 92a:	20813a83          	ld	s5,520(sp)
 92e:	24010113          	addi	sp,sp,576
 932:	8082                	ret

0000000000000934 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 934:	ba010113          	addi	sp,sp,-1120
 938:	44113c23          	sd	ra,1112(sp)
 93c:	44813823          	sd	s0,1104(sp)
 940:	44913423          	sd	s1,1096(sp)
 944:	45213023          	sd	s2,1088(sp)
 948:	43313c23          	sd	s3,1080(sp)
 94c:	43413823          	sd	s4,1072(sp)
 950:	43513423          	sd	s5,1064(sp)
 954:	43613023          	sd	s6,1056(sp)
 958:	41713c23          	sd	s7,1048(sp)
 95c:	41813823          	sd	s8,1040(sp)
 960:	41913423          	sd	s9,1032(sp)
 964:	41a13023          	sd	s10,1024(sp)
 968:	3fb13c23          	sd	s11,1016(sp)
 96c:	46010413          	addi	s0,sp,1120
 970:	8aaa                	mv	s5,a0
 972:	8bae                	mv	s7,a1
 974:	8db2                	mv	s11,a2
 976:	8c36                	mv	s8,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 978:	d9840593          	addi	a1,s0,-616
 97c:	00000097          	auipc	ra,0x0
 980:	288080e7          	jalr	648(ra) # c04 <read_line>

  if (readStatus == READ_ERROR)
 984:	57fd                	li	a5,-1
 986:	04f50163          	beq	a0,a5,9c8 <uniq_run+0x94>
 98a:	4b01                	li	s6,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 98c:	ed21                	bnez	a0,9e4 <uniq_run+0xb0>





}
 98e:	45813083          	ld	ra,1112(sp)
 992:	45013403          	ld	s0,1104(sp)
 996:	44813483          	ld	s1,1096(sp)
 99a:	44013903          	ld	s2,1088(sp)
 99e:	43813983          	ld	s3,1080(sp)
 9a2:	43013a03          	ld	s4,1072(sp)
 9a6:	42813a83          	ld	s5,1064(sp)
 9aa:	42013b03          	ld	s6,1056(sp)
 9ae:	41813b83          	ld	s7,1048(sp)
 9b2:	41013c03          	ld	s8,1040(sp)
 9b6:	40813c83          	ld	s9,1032(sp)
 9ba:	40013d03          	ld	s10,1024(sp)
 9be:	3f813d83          	ld	s11,1016(sp)
 9c2:	46010113          	addi	sp,sp,1120
 9c6:	8082                	ret
    printf("[ERR] Error reading from the file ");
 9c8:	00000517          	auipc	a0,0x0
 9cc:	3d850513          	addi	a0,a0,984 # da0 <digits+0x48>
 9d0:	00000097          	auipc	ra,0x0
 9d4:	d38080e7          	jalr	-712(ra) # 708 <printf>
 9d8:	bf5d                	j	98e <uniq_run+0x5a>
 9da:	87ca                	mv	a5,s2
 9dc:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 9de:	84be                	mv	s1,a5
        lineCount = 1;
 9e0:	89ea                	mv	s3,s10
 9e2:	a8fd                	j	ae0 <uniq_run+0x1ac>
    int isEof = 0;
 9e4:	4a01                	li	s4,0
    int lineCount=1;
 9e6:	4985                	li	s3,1
  char * line2 = buffer2;
 9e8:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 9ec:	d9840913          	addi	s2,s0,-616
      if (readStatus == READ_ERROR){
 9f0:	5cfd                	li	s9,-1
        isEof = 1;
 9f2:	4d05                	li	s10,1
 9f4:	a0f5                	j	ae0 <uniq_run+0x1ac>
        printf("[ERR] Error reading from the file");
 9f6:	00000517          	auipc	a0,0x0
 9fa:	3d250513          	addi	a0,a0,978 # dc8 <digits+0x70>
 9fe:	00000097          	auipc	ra,0x0
 a02:	d0a080e7          	jalr	-758(ra) # 708 <printf>
        break;
 a06:	b761                	j	98e <uniq_run+0x5a>
        compareStatus = compare_str_ic(line1, line2);
 a08:	85a6                	mv	a1,s1
 a0a:	854a                	mv	a0,s2
 a0c:	00000097          	auipc	ra,0x0
 a10:	184080e7          	jalr	388(ra) # b90 <compare_str_ic>
 a14:	a8d5                	j	b08 <uniq_run+0x1d4>
                  printf("%s",line1);
 a16:	85ca                	mv	a1,s2
 a18:	00000517          	auipc	a0,0x0
 a1c:	38050513          	addi	a0,a0,896 # d98 <digits+0x40>
 a20:	00000097          	auipc	ra,0x0
 a24:	ce8080e7          	jalr	-792(ra) # 708 <printf>
        lineCount = 1;
 a28:	89da                	mv	s3,s6
                  printf("%s",line1);
 a2a:	87ca                	mv	a5,s2
 a2c:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 a2e:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a30:	4b01                	li	s6,0
 a32:	a07d                	j	ae0 <uniq_run+0x1ac>
            if (showCount){
 a34:	040d8b63          	beqz	s11,a8a <uniq_run+0x156>
              printf("<%d> %s",lineCount,line1);
 a38:	864a                	mv	a2,s2
 a3a:	85ce                	mv	a1,s3
 a3c:	00000517          	auipc	a0,0x0
 a40:	3b450513          	addi	a0,a0,948 # df0 <digits+0x98>
 a44:	00000097          	auipc	ra,0x0
 a48:	cc4080e7          	jalr	-828(ra) # 708 <printf>
              if (isEof && get_strlen(line2)){
 a4c:	000a1863          	bnez	s4,a5c <uniq_run+0x128>
        isRepeated = 0 ;
 a50:	8b52                	mv	s6,s4
 a52:	87ca                	mv	a5,s2
 a54:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 a56:	84be                	mv	s1,a5
        lineCount = 1;
 a58:	89ea                	mv	s3,s10
 a5a:	a059                	j	ae0 <uniq_run+0x1ac>
              if (isEof && get_strlen(line2)){
 a5c:	8526                	mv	a0,s1
 a5e:	00000097          	auipc	ra,0x0
 a62:	0d8080e7          	jalr	216(ra) # b36 <get_strlen>
 a66:	8b2a                	mv	s6,a0
 a68:	e511                	bnez	a0,a74 <uniq_run+0x140>
        lineCount = 1;
 a6a:	89d2                	mv	s3,s4
 a6c:	87ca                	mv	a5,s2
 a6e:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 a70:	84be                	mv	s1,a5
 a72:	a0bd                	j	ae0 <uniq_run+0x1ac>
                printf("<%d> %s",lineCount,line2); 
 a74:	8626                	mv	a2,s1
 a76:	85ce                	mv	a1,s3
 a78:	00000517          	auipc	a0,0x0
 a7c:	37850513          	addi	a0,a0,888 # df0 <digits+0x98>
 a80:	00000097          	auipc	ra,0x0
 a84:	c88080e7          	jalr	-888(ra) # 708 <printf>
                break;
 a88:	b719                	j	98e <uniq_run+0x5a>
              printf("%s",line1);
 a8a:	85ca                	mv	a1,s2
 a8c:	00000517          	auipc	a0,0x0
 a90:	30c50513          	addi	a0,a0,780 # d98 <digits+0x40>
 a94:	00000097          	auipc	ra,0x0
 a98:	c74080e7          	jalr	-908(ra) # 708 <printf>
              if (isEof && get_strlen(line2)){
 a9c:	000a1863          	bnez	s4,aac <uniq_run+0x178>
        isRepeated = 0 ;
 aa0:	8b52                	mv	s6,s4
 aa2:	87ca                	mv	a5,s2
 aa4:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 aa6:	84be                	mv	s1,a5
        lineCount = 1;
 aa8:	89ea                	mv	s3,s10
 aaa:	a81d                	j	ae0 <uniq_run+0x1ac>
              if (isEof && get_strlen(line2)){
 aac:	8526                	mv	a0,s1
 aae:	00000097          	auipc	ra,0x0
 ab2:	088080e7          	jalr	136(ra) # b36 <get_strlen>
 ab6:	8b2a                	mv	s6,a0
 ab8:	e511                	bnez	a0,ac4 <uniq_run+0x190>
        lineCount = 1;
 aba:	89d2                	mv	s3,s4
 abc:	87ca                	mv	a5,s2
 abe:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 ac0:	84be                	mv	s1,a5
 ac2:	a839                	j	ae0 <uniq_run+0x1ac>
                printf("%s",line2);
 ac4:	85a6                	mv	a1,s1
 ac6:	00000517          	auipc	a0,0x0
 aca:	2d250513          	addi	a0,a0,722 # d98 <digits+0x40>
 ace:	00000097          	auipc	ra,0x0
 ad2:	c3a080e7          	jalr	-966(ra) # 708 <printf>
                break;
 ad6:	bd65                	j	98e <uniq_run+0x5a>
          if (repeatedLines && !isRepeated){
 ad8:	000c0363          	beqz	s8,ade <uniq_run+0x1aa>
 adc:	8b6a                	mv	s6,s10
          lineCount++;
 ade:	2985                	addiw	s3,s3,1
      readStatus = read_line(fd, line2);
 ae0:	85a6                	mv	a1,s1
 ae2:	8556                	mv	a0,s5
 ae4:	00000097          	auipc	ra,0x0
 ae8:	120080e7          	jalr	288(ra) # c04 <read_line>
      if (readStatus == READ_ERROR){
 aec:	f19505e3          	beq	a0,s9,9f6 <uniq_run+0xc2>
      if (readStatus == READ_EOF){
 af0:	e501                	bnez	a0,af8 <uniq_run+0x1c4>
        if (isEof)
 af2:	e80a1ee3          	bnez	s4,98e <uniq_run+0x5a>
        isEof = 1;
 af6:	8a6a                	mv	s4,s10
      if (!ignoreCase)
 af8:	f00b98e3          	bnez	s7,a08 <uniq_run+0xd4>
        compareStatus = compare_str(line1, line2);
 afc:	85a6                	mv	a1,s1
 afe:	854a                	mv	a0,s2
 b00:	00000097          	auipc	ra,0x0
 b04:	062080e7          	jalr	98(ra) # b62 <compare_str>
      if (compareStatus != 0){ // Not equal
 b08:	d961                	beqz	a0,ad8 <uniq_run+0x1a4>
          if (repeatedLines){
 b0a:	f20c05e3          	beqz	s8,a34 <uniq_run+0x100>
            if (isRepeated){
 b0e:	ec0b06e3          	beqz	s6,9da <uniq_run+0xa6>
                if (showCount)
 b12:	f00d82e3          	beqz	s11,a16 <uniq_run+0xe2>
                  printf("<%d> %s",lineCount,line1);
 b16:	864a                	mv	a2,s2
 b18:	85ce                	mv	a1,s3
 b1a:	00000517          	auipc	a0,0x0
 b1e:	2d650513          	addi	a0,a0,726 # df0 <digits+0x98>
 b22:	00000097          	auipc	ra,0x0
 b26:	be6080e7          	jalr	-1050(ra) # 708 <printf>
        lineCount = 1;
 b2a:	89da                	mv	s3,s6
 b2c:	87ca                	mv	a5,s2
 b2e:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 b30:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b32:	4b01                	li	s6,0
 b34:	b775                	j	ae0 <uniq_run+0x1ac>

0000000000000b36 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 b36:	1141                	addi	sp,sp,-16
 b38:	e422                	sd	s0,8(sp)
 b3a:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 b3c:	00054783          	lbu	a5,0(a0)
 b40:	cf99                	beqz	a5,b5e <get_strlen+0x28>
 b42:	00150713          	addi	a4,a0,1
 b46:	87ba                	mv	a5,a4
 b48:	4685                	li	a3,1
 b4a:	9e99                	subw	a3,a3,a4
 b4c:	00f6853b          	addw	a0,a3,a5
 b50:	0785                	addi	a5,a5,1
 b52:	fff7c703          	lbu	a4,-1(a5)
 b56:	fb7d                	bnez	a4,b4c <get_strlen+0x16>
	return len;
}
 b58:	6422                	ld	s0,8(sp)
 b5a:	0141                	addi	sp,sp,16
 b5c:	8082                	ret
	int len = 0;
 b5e:	4501                	li	a0,0
 b60:	bfe5                	j	b58 <get_strlen+0x22>

0000000000000b62 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 b62:	1141                	addi	sp,sp,-16
 b64:	e422                	sd	s0,8(sp)
 b66:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 b68:	00054783          	lbu	a5,0(a0)
 b6c:	cb91                	beqz	a5,b80 <compare_str+0x1e>
 b6e:	0005c703          	lbu	a4,0(a1)
 b72:	c719                	beqz	a4,b80 <compare_str+0x1e>
		if (*s1++ != *s2++)
 b74:	0505                	addi	a0,a0,1
 b76:	0585                	addi	a1,a1,1
 b78:	fee788e3          	beq	a5,a4,b68 <compare_str+0x6>
			return 1;
 b7c:	4505                	li	a0,1
 b7e:	a031                	j	b8a <compare_str+0x28>
	}
	if (*s1 == *s2)
 b80:	0005c503          	lbu	a0,0(a1)
 b84:	8d1d                	sub	a0,a0,a5
			return 1;
 b86:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b8a:	6422                	ld	s0,8(sp)
 b8c:	0141                	addi	sp,sp,16
 b8e:	8082                	ret

0000000000000b90 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 b90:	1141                	addi	sp,sp,-16
 b92:	e422                	sd	s0,8(sp)
 b94:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b96:	4665                	li	a2,25
	while(*s1 && *s2){
 b98:	a019                	j	b9e <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b9a:	04e79763          	bne	a5,a4,be8 <compare_str_ic+0x58>
	while(*s1 && *s2){
 b9e:	00054783          	lbu	a5,0(a0)
 ba2:	cb9d                	beqz	a5,bd8 <compare_str_ic+0x48>
 ba4:	0005c703          	lbu	a4,0(a1)
 ba8:	cb05                	beqz	a4,bd8 <compare_str_ic+0x48>
		char b1 = *s1++;
 baa:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 bac:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 bae:	fbf7869b          	addiw	a3,a5,-65
 bb2:	0ff6f693          	zext.b	a3,a3
 bb6:	00d66663          	bltu	a2,a3,bc2 <compare_str_ic+0x32>
			b1 += 32;
 bba:	0207879b          	addiw	a5,a5,32
 bbe:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 bc2:	fbf7069b          	addiw	a3,a4,-65
 bc6:	0ff6f693          	zext.b	a3,a3
 bca:	fcd668e3          	bltu	a2,a3,b9a <compare_str_ic+0xa>
			b2 += 32;
 bce:	0207071b          	addiw	a4,a4,32
 bd2:	0ff77713          	zext.b	a4,a4
 bd6:	b7d1                	j	b9a <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 bd8:	0005c503          	lbu	a0,0(a1)
 bdc:	8d1d                	sub	a0,a0,a5
			return 1;
 bde:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 be2:	6422                	ld	s0,8(sp)
 be4:	0141                	addi	sp,sp,16
 be6:	8082                	ret
			return 1;
 be8:	4505                	li	a0,1
 bea:	bfe5                	j	be2 <compare_str_ic+0x52>

0000000000000bec <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 bec:	1141                	addi	sp,sp,-16
 bee:	e406                	sd	ra,8(sp)
 bf0:	e022                	sd	s0,0(sp)
 bf2:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 bf4:	fffff097          	auipc	ra,0xfffff
 bf8:	7ca080e7          	jalr	1994(ra) # 3be <open>
	return fd;
}
 bfc:	60a2                	ld	ra,8(sp)
 bfe:	6402                	ld	s0,0(sp)
 c00:	0141                	addi	sp,sp,16
 c02:	8082                	ret

0000000000000c04 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 c04:	7139                	addi	sp,sp,-64
 c06:	fc06                	sd	ra,56(sp)
 c08:	f822                	sd	s0,48(sp)
 c0a:	f426                	sd	s1,40(sp)
 c0c:	f04a                	sd	s2,32(sp)
 c0e:	ec4e                	sd	s3,24(sp)
 c10:	e852                	sd	s4,16(sp)
 c12:	0080                	addi	s0,sp,64
 c14:	89aa                	mv	s3,a0
 c16:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c18:	4901                	li	s2,0
			return byteCount; 
		}
		*buffer++ = readByte;
		byteCount++;

		if (readByte == '\n'){
 c1a:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c1c:	4605                	li	a2,1
 c1e:	fcf40593          	addi	a1,s0,-49
 c22:	854e                	mv	a0,s3
 c24:	fffff097          	auipc	ra,0xfffff
 c28:	772080e7          	jalr	1906(ra) # 396 <read>
		if (readStatus <= 0){
 c2c:	02a05563          	blez	a0,c56 <read_line+0x52>
		*buffer++ = readByte;
 c30:	0485                	addi	s1,s1,1
 c32:	fcf44783          	lbu	a5,-49(s0)
 c36:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c3a:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c3c:	ff4790e3          	bne	a5,s4,c1c <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c40:	00048023          	sb	zero,0(s1)
		byteCount++;
 c44:	854a                	mv	a0,s2
			return byteCount;
		}
	}
}
 c46:	70e2                	ld	ra,56(sp)
 c48:	7442                	ld	s0,48(sp)
 c4a:	74a2                	ld	s1,40(sp)
 c4c:	7902                	ld	s2,32(sp)
 c4e:	69e2                	ld	s3,24(sp)
 c50:	6a42                	ld	s4,16(sp)
 c52:	6121                	addi	sp,sp,64
 c54:	8082                	ret
			*buffer = 0;  // Nullifying the end of the string
 c56:	00048023          	sb	zero,0(s1)
			if (byteCount == 0)
 c5a:	fe0906e3          	beqz	s2,c46 <read_line+0x42>
 c5e:	854a                	mv	a0,s2
 c60:	b7dd                	j	c46 <read_line+0x42>

0000000000000c62 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c62:	1141                	addi	sp,sp,-16
 c64:	e406                	sd	ra,8(sp)
 c66:	e022                	sd	s0,0(sp)
 c68:	0800                	addi	s0,sp,16
	close(fd);
 c6a:	fffff097          	auipc	ra,0xfffff
 c6e:	73c080e7          	jalr	1852(ra) # 3a6 <close>
}
 c72:	60a2                	ld	ra,8(sp)
 c74:	6402                	ld	s0,0(sp)
 c76:	0141                	addi	sp,sp,16
 c78:	8082                	ret
