
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	daa78793          	addi	a5,a5,-598 # dc0 <get_time_perf+0x92>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	d6450513          	addi	a0,a0,-668 # d90 <get_time_perf+0x62>
  34:	00000097          	auipc	ra,0x0
  38:	718080e7          	jalr	1816(ra) # 74c <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	150080e7          	jalr	336(ra) # 198 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	336080e7          	jalr	822(ra) # 38a <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	d4050513          	addi	a0,a0,-704 # da8 <get_time_perf+0x7a>
  70:	00000097          	auipc	ra,0x0
  74:	6dc080e7          	jalr	1756(ra) # 74c <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9fa5                	addw	a5,a5,s1
  7e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	348080e7          	jalr	840(ra) # 3d2 <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	312080e7          	jalr	786(ra) # 3b2 <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	30c080e7          	jalr	780(ra) # 3ba <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	d0250513          	addi	a0,a0,-766 # db8 <get_time_perf+0x8a>
  be:	00000097          	auipc	ra,0x0
  c2:	68e080e7          	jalr	1678(ra) # 74c <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	306080e7          	jalr	774(ra) # 3d2 <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2c8080e7          	jalr	712(ra) # 3aa <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2ca080e7          	jalr	714(ra) # 3ba <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2a0080e7          	jalr	672(ra) # 39a <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	28e080e7          	jalr	654(ra) # 392 <exit>

000000000000010c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  extern int main();
  main();
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <main>
  exit(0);
 11c:	4501                	li	a0,0
 11e:	00000097          	auipc	ra,0x0
 122:	274080e7          	jalr	628(ra) # 392 <exit>

0000000000000126 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12c:	87aa                	mv	a5,a0
 12e:	0585                	addi	a1,a1,1
 130:	0785                	addi	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0x8>
    ;
  return os;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb91                	beqz	a5,160 <strcmp+0x1e>
 14e:	0005c703          	lbu	a4,0(a1)
 152:	00f71763          	bne	a4,a5,160 <strcmp+0x1e>
    p++, q++;
 156:	0505                	addi	a0,a0,1
 158:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	fbe5                	bnez	a5,14e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 160:	0005c503          	lbu	a0,0(a1)
}
 164:	40a7853b          	subw	a0,a5,a0
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strlen>:

uint
strlen(const char *s)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cf91                	beqz	a5,194 <strlen+0x26>
 17a:	0505                	addi	a0,a0,1
 17c:	87aa                	mv	a5,a0
 17e:	4685                	li	a3,1
 180:	9e89                	subw	a3,a3,a0
 182:	00f6853b          	addw	a0,a3,a5
 186:	0785                	addi	a5,a5,1
 188:	fff7c703          	lbu	a4,-1(a5)
 18c:	fb7d                	bnez	a4,182 <strlen+0x14>
    ;
  return n;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
  for(n = 0; s[n]; n++)
 194:	4501                	li	a0,0
 196:	bfe5                	j	18e <strlen+0x20>

0000000000000198 <memset>:

void*
memset(void *dst, int c, uint n)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19e:	ca19                	beqz	a2,1b4 <memset+0x1c>
 1a0:	87aa                	mv	a5,a0
 1a2:	1602                	slli	a2,a2,0x20
 1a4:	9201                	srli	a2,a2,0x20
 1a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ae:	0785                	addi	a5,a5,1
 1b0:	fee79de3          	bne	a5,a4,1aa <memset+0x12>
  }
  return dst;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strchr>:

char*
strchr(const char *s, char c)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cb99                	beqz	a5,1da <strchr+0x20>
    if(*s == c)
 1c6:	00f58763          	beq	a1,a5,1d4 <strchr+0x1a>
  for(; *s; s++)
 1ca:	0505                	addi	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	fbfd                	bnez	a5,1c6 <strchr+0xc>
      return (char*)s;
  return 0;
 1d2:	4501                	li	a0,0
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <strchr+0x1a>

00000000000001de <gets>:

char*
gets(char *buf, int max)
{
 1de:	711d                	addi	sp,sp,-96
 1e0:	ec86                	sd	ra,88(sp)
 1e2:	e8a2                	sd	s0,80(sp)
 1e4:	e4a6                	sd	s1,72(sp)
 1e6:	e0ca                	sd	s2,64(sp)
 1e8:	fc4e                	sd	s3,56(sp)
 1ea:	f852                	sd	s4,48(sp)
 1ec:	f456                	sd	s5,40(sp)
 1ee:	f05a                	sd	s6,32(sp)
 1f0:	ec5e                	sd	s7,24(sp)
 1f2:	1080                	addi	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fc:	4aa9                	li	s5,10
 1fe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 200:	89a6                	mv	s3,s1
 202:	2485                	addiw	s1,s1,1
 204:	0344d863          	bge	s1,s4,234 <gets+0x56>
    cc = read(0, &c, 1);
 208:	4605                	li	a2,1
 20a:	faf40593          	addi	a1,s0,-81
 20e:	4501                	li	a0,0
 210:	00000097          	auipc	ra,0x0
 214:	19a080e7          	jalr	410(ra) # 3aa <read>
    if(cc < 1)
 218:	00a05e63          	blez	a0,234 <gets+0x56>
    buf[i++] = c;
 21c:	faf44783          	lbu	a5,-81(s0)
 220:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 224:	01578763          	beq	a5,s5,232 <gets+0x54>
 228:	0905                	addi	s2,s2,1
 22a:	fd679be3          	bne	a5,s6,200 <gets+0x22>
  for(i=0; i+1 < max; ){
 22e:	89a6                	mv	s3,s1
 230:	a011                	j	234 <gets+0x56>
 232:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 234:	99de                	add	s3,s3,s7
 236:	00098023          	sb	zero,0(s3)
  return buf;
}
 23a:	855e                	mv	a0,s7
 23c:	60e6                	ld	ra,88(sp)
 23e:	6446                	ld	s0,80(sp)
 240:	64a6                	ld	s1,72(sp)
 242:	6906                	ld	s2,64(sp)
 244:	79e2                	ld	s3,56(sp)
 246:	7a42                	ld	s4,48(sp)
 248:	7aa2                	ld	s5,40(sp)
 24a:	7b02                	ld	s6,32(sp)
 24c:	6be2                	ld	s7,24(sp)
 24e:	6125                	addi	sp,sp,96
 250:	8082                	ret

0000000000000252 <stat>:

int
stat(const char *n, struct stat *st)
{
 252:	1101                	addi	sp,sp,-32
 254:	ec06                	sd	ra,24(sp)
 256:	e822                	sd	s0,16(sp)
 258:	e426                	sd	s1,8(sp)
 25a:	e04a                	sd	s2,0(sp)
 25c:	1000                	addi	s0,sp,32
 25e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 260:	4581                	li	a1,0
 262:	00000097          	auipc	ra,0x0
 266:	170080e7          	jalr	368(ra) # 3d2 <open>
  if(fd < 0)
 26a:	02054563          	bltz	a0,294 <stat+0x42>
 26e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	00000097          	auipc	ra,0x0
 276:	178080e7          	jalr	376(ra) # 3ea <fstat>
 27a:	892a                	mv	s2,a0
  close(fd);
 27c:	8526                	mv	a0,s1
 27e:	00000097          	auipc	ra,0x0
 282:	13c080e7          	jalr	316(ra) # 3ba <close>
  return r;
}
 286:	854a                	mv	a0,s2
 288:	60e2                	ld	ra,24(sp)
 28a:	6442                	ld	s0,16(sp)
 28c:	64a2                	ld	s1,8(sp)
 28e:	6902                	ld	s2,0(sp)
 290:	6105                	addi	sp,sp,32
 292:	8082                	ret
    return -1;
 294:	597d                	li	s2,-1
 296:	bfc5                	j	286 <stat+0x34>

0000000000000298 <atoi>:

int
atoi(const char *s)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29e:	00054683          	lbu	a3,0(a0)
 2a2:	fd06879b          	addiw	a5,a3,-48
 2a6:	0ff7f793          	zext.b	a5,a5
 2aa:	4625                	li	a2,9
 2ac:	02f66863          	bltu	a2,a5,2dc <atoi+0x44>
 2b0:	872a                	mv	a4,a0
  n = 0;
 2b2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b4:	0705                	addi	a4,a4,1
 2b6:	0025179b          	slliw	a5,a0,0x2
 2ba:	9fa9                	addw	a5,a5,a0
 2bc:	0017979b          	slliw	a5,a5,0x1
 2c0:	9fb5                	addw	a5,a5,a3
 2c2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c6:	00074683          	lbu	a3,0(a4)
 2ca:	fd06879b          	addiw	a5,a3,-48
 2ce:	0ff7f793          	zext.b	a5,a5
 2d2:	fef671e3          	bgeu	a2,a5,2b4 <atoi+0x1c>
  return n;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  n = 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <atoi+0x3e>

00000000000002e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e6:	02b57463          	bgeu	a0,a1,30e <memmove+0x2e>
    while(n-- > 0)
 2ea:	00c05f63          	blez	a2,308 <memmove+0x28>
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f8:	0585                	addi	a1,a1,1
 2fa:	0705                	addi	a4,a4,1
 2fc:	fff5c683          	lbu	a3,-1(a1)
 300:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
    dst += n;
 30e:	00c50733          	add	a4,a0,a2
    src += n;
 312:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 314:	fec05ae3          	blez	a2,308 <memmove+0x28>
 318:	fff6079b          	addiw	a5,a2,-1
 31c:	1782                	slli	a5,a5,0x20
 31e:	9381                	srli	a5,a5,0x20
 320:	fff7c793          	not	a5,a5
 324:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 326:	15fd                	addi	a1,a1,-1
 328:	177d                	addi	a4,a4,-1
 32a:	0005c683          	lbu	a3,0(a1)
 32e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 332:	fee79ae3          	bne	a5,a4,326 <memmove+0x46>
 336:	bfc9                	j	308 <memmove+0x28>

0000000000000338 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33e:	ca05                	beqz	a2,36e <memcmp+0x36>
 340:	fff6069b          	addiw	a3,a2,-1
 344:	1682                	slli	a3,a3,0x20
 346:	9281                	srli	a3,a3,0x20
 348:	0685                	addi	a3,a3,1
 34a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34c:	00054783          	lbu	a5,0(a0)
 350:	0005c703          	lbu	a4,0(a1)
 354:	00e79863          	bne	a5,a4,364 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 358:	0505                	addi	a0,a0,1
    p2++;
 35a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35c:	fed518e3          	bne	a0,a3,34c <memcmp+0x14>
  }
  return 0;
 360:	4501                	li	a0,0
 362:	a019                	j	368 <memcmp+0x30>
      return *p1 - *p2;
 364:	40e7853b          	subw	a0,a5,a4
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret
  return 0;
 36e:	4501                	li	a0,0
 370:	bfe5                	j	368 <memcmp+0x30>

0000000000000372 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 372:	1141                	addi	sp,sp,-16
 374:	e406                	sd	ra,8(sp)
 376:	e022                	sd	s0,0(sp)
 378:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37a:	00000097          	auipc	ra,0x0
 37e:	f66080e7          	jalr	-154(ra) # 2e0 <memmove>
}
 382:	60a2                	ld	ra,8(sp)
 384:	6402                	ld	s0,0(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38a:	4885                	li	a7,1
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <exit>:
.global exit
exit:
 li a7, SYS_exit
 392:	4889                	li	a7,2
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <wait>:
.global wait
wait:
 li a7, SYS_wait
 39a:	488d                	li	a7,3
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a2:	4891                	li	a7,4
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <read>:
.global read
read:
 li a7, SYS_read
 3aa:	4895                	li	a7,5
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <write>:
.global write
write:
 li a7, SYS_write
 3b2:	48c1                	li	a7,16
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <close>:
.global close
close:
 li a7, SYS_close
 3ba:	48d5                	li	a7,21
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c2:	4899                	li	a7,6
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ca:	489d                	li	a7,7
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <open>:
.global open
open:
 li a7, SYS_open
 3d2:	48bd                	li	a7,15
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3da:	48c5                	li	a7,17
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e2:	48c9                	li	a7,18
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ea:	48a1                	li	a7,8
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <link>:
.global link
link:
 li a7, SYS_link
 3f2:	48cd                	li	a7,19
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fa:	48d1                	li	a7,20
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 402:	48a5                	li	a7,9
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <dup>:
.global dup
dup:
 li a7, SYS_dup
 40a:	48a9                	li	a7,10
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 412:	48ad                	li	a7,11
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41a:	48b1                	li	a7,12
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 422:	48b5                	li	a7,13
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42a:	48b9                	li	a7,14
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <head>:
.global head
head:
 li a7, SYS_head
 432:	48d9                	li	a7,22
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 43a:	48dd                	li	a7,23
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <ps>:
.global ps
ps:
 li a7, SYS_ps
 442:	48e1                	li	a7,24
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <times>:
.global times
times:
 li a7, SYS_times
 44a:	48e5                	li	a7,25
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 452:	48e9                	li	a7,26
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 45a:	48ed                	li	a7,27
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 462:	48f1                	li	a7,28
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 46a:	48f5                	li	a7,29
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 472:	1101                	addi	sp,sp,-32
 474:	ec06                	sd	ra,24(sp)
 476:	e822                	sd	s0,16(sp)
 478:	1000                	addi	s0,sp,32
 47a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47e:	4605                	li	a2,1
 480:	fef40593          	addi	a1,s0,-17
 484:	00000097          	auipc	ra,0x0
 488:	f2e080e7          	jalr	-210(ra) # 3b2 <write>
}
 48c:	60e2                	ld	ra,24(sp)
 48e:	6442                	ld	s0,16(sp)
 490:	6105                	addi	sp,sp,32
 492:	8082                	ret

0000000000000494 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 494:	7139                	addi	sp,sp,-64
 496:	fc06                	sd	ra,56(sp)
 498:	f822                	sd	s0,48(sp)
 49a:	f426                	sd	s1,40(sp)
 49c:	f04a                	sd	s2,32(sp)
 49e:	ec4e                	sd	s3,24(sp)
 4a0:	0080                	addi	s0,sp,64
 4a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a4:	c299                	beqz	a3,4aa <printint+0x16>
 4a6:	0805c963          	bltz	a1,538 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4aa:	2581                	sext.w	a1,a1
  neg = 0;
 4ac:	4881                	li	a7,0
 4ae:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b4:	2601                	sext.w	a2,a2
 4b6:	00001517          	auipc	a0,0x1
 4ba:	97a50513          	addi	a0,a0,-1670 # e30 <digits>
 4be:	883a                	mv	a6,a4
 4c0:	2705                	addiw	a4,a4,1
 4c2:	02c5f7bb          	remuw	a5,a1,a2
 4c6:	1782                	slli	a5,a5,0x20
 4c8:	9381                	srli	a5,a5,0x20
 4ca:	97aa                	add	a5,a5,a0
 4cc:	0007c783          	lbu	a5,0(a5)
 4d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d4:	0005879b          	sext.w	a5,a1
 4d8:	02c5d5bb          	divuw	a1,a1,a2
 4dc:	0685                	addi	a3,a3,1
 4de:	fec7f0e3          	bgeu	a5,a2,4be <printint+0x2a>
  if(neg)
 4e2:	00088c63          	beqz	a7,4fa <printint+0x66>
    buf[i++] = '-';
 4e6:	fd070793          	addi	a5,a4,-48
 4ea:	00878733          	add	a4,a5,s0
 4ee:	02d00793          	li	a5,45
 4f2:	fef70823          	sb	a5,-16(a4)
 4f6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4fa:	02e05863          	blez	a4,52a <printint+0x96>
 4fe:	fc040793          	addi	a5,s0,-64
 502:	00e78933          	add	s2,a5,a4
 506:	fff78993          	addi	s3,a5,-1
 50a:	99ba                	add	s3,s3,a4
 50c:	377d                	addiw	a4,a4,-1
 50e:	1702                	slli	a4,a4,0x20
 510:	9301                	srli	a4,a4,0x20
 512:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 516:	fff94583          	lbu	a1,-1(s2)
 51a:	8526                	mv	a0,s1
 51c:	00000097          	auipc	ra,0x0
 520:	f56080e7          	jalr	-170(ra) # 472 <putc>
  while(--i >= 0)
 524:	197d                	addi	s2,s2,-1
 526:	ff3918e3          	bne	s2,s3,516 <printint+0x82>
}
 52a:	70e2                	ld	ra,56(sp)
 52c:	7442                	ld	s0,48(sp)
 52e:	74a2                	ld	s1,40(sp)
 530:	7902                	ld	s2,32(sp)
 532:	69e2                	ld	s3,24(sp)
 534:	6121                	addi	sp,sp,64
 536:	8082                	ret
    x = -xx;
 538:	40b005bb          	negw	a1,a1
    neg = 1;
 53c:	4885                	li	a7,1
    x = -xx;
 53e:	bf85                	j	4ae <printint+0x1a>

0000000000000540 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 540:	7119                	addi	sp,sp,-128
 542:	fc86                	sd	ra,120(sp)
 544:	f8a2                	sd	s0,112(sp)
 546:	f4a6                	sd	s1,104(sp)
 548:	f0ca                	sd	s2,96(sp)
 54a:	ecce                	sd	s3,88(sp)
 54c:	e8d2                	sd	s4,80(sp)
 54e:	e4d6                	sd	s5,72(sp)
 550:	e0da                	sd	s6,64(sp)
 552:	fc5e                	sd	s7,56(sp)
 554:	f862                	sd	s8,48(sp)
 556:	f466                	sd	s9,40(sp)
 558:	f06a                	sd	s10,32(sp)
 55a:	ec6e                	sd	s11,24(sp)
 55c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 55e:	0005c903          	lbu	s2,0(a1)
 562:	18090f63          	beqz	s2,700 <vprintf+0x1c0>
 566:	8aaa                	mv	s5,a0
 568:	8b32                	mv	s6,a2
 56a:	00158493          	addi	s1,a1,1
  state = 0;
 56e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 570:	02500a13          	li	s4,37
 574:	4c55                	li	s8,21
 576:	00001c97          	auipc	s9,0x1
 57a:	862c8c93          	addi	s9,s9,-1950 # dd8 <get_time_perf+0xaa>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 57e:	02800d93          	li	s11,40
  putc(fd, 'x');
 582:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 584:	00001b97          	auipc	s7,0x1
 588:	8acb8b93          	addi	s7,s7,-1876 # e30 <digits>
 58c:	a839                	j	5aa <vprintf+0x6a>
        putc(fd, c);
 58e:	85ca                	mv	a1,s2
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	ee0080e7          	jalr	-288(ra) # 472 <putc>
 59a:	a019                	j	5a0 <vprintf+0x60>
    } else if(state == '%'){
 59c:	01498d63          	beq	s3,s4,5b6 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 5a0:	0485                	addi	s1,s1,1
 5a2:	fff4c903          	lbu	s2,-1(s1)
 5a6:	14090d63          	beqz	s2,700 <vprintf+0x1c0>
    if(state == 0){
 5aa:	fe0999e3          	bnez	s3,59c <vprintf+0x5c>
      if(c == '%'){
 5ae:	ff4910e3          	bne	s2,s4,58e <vprintf+0x4e>
        state = '%';
 5b2:	89d2                	mv	s3,s4
 5b4:	b7f5                	j	5a0 <vprintf+0x60>
      if(c == 'd'){
 5b6:	11490c63          	beq	s2,s4,6ce <vprintf+0x18e>
 5ba:	f9d9079b          	addiw	a5,s2,-99
 5be:	0ff7f793          	zext.b	a5,a5
 5c2:	10fc6e63          	bltu	s8,a5,6de <vprintf+0x19e>
 5c6:	f9d9079b          	addiw	a5,s2,-99
 5ca:	0ff7f713          	zext.b	a4,a5
 5ce:	10ec6863          	bltu	s8,a4,6de <vprintf+0x19e>
 5d2:	00271793          	slli	a5,a4,0x2
 5d6:	97e6                	add	a5,a5,s9
 5d8:	439c                	lw	a5,0(a5)
 5da:	97e6                	add	a5,a5,s9
 5dc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5de:	008b0913          	addi	s2,s6,8
 5e2:	4685                	li	a3,1
 5e4:	4629                	li	a2,10
 5e6:	000b2583          	lw	a1,0(s6)
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	ea8080e7          	jalr	-344(ra) # 494 <printint>
 5f4:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b765                	j	5a0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fa:	008b0913          	addi	s2,s6,8
 5fe:	4681                	li	a3,0
 600:	4629                	li	a2,10
 602:	000b2583          	lw	a1,0(s6)
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	e8c080e7          	jalr	-372(ra) # 494 <printint>
 610:	8b4a                	mv	s6,s2
      state = 0;
 612:	4981                	li	s3,0
 614:	b771                	j	5a0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 616:	008b0913          	addi	s2,s6,8
 61a:	4681                	li	a3,0
 61c:	866a                	mv	a2,s10
 61e:	000b2583          	lw	a1,0(s6)
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	e70080e7          	jalr	-400(ra) # 494 <printint>
 62c:	8b4a                	mv	s6,s2
      state = 0;
 62e:	4981                	li	s3,0
 630:	bf85                	j	5a0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 632:	008b0793          	addi	a5,s6,8
 636:	f8f43423          	sd	a5,-120(s0)
 63a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 63e:	03000593          	li	a1,48
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	e2e080e7          	jalr	-466(ra) # 472 <putc>
  putc(fd, 'x');
 64c:	07800593          	li	a1,120
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	e20080e7          	jalr	-480(ra) # 472 <putc>
 65a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65c:	03c9d793          	srli	a5,s3,0x3c
 660:	97de                	add	a5,a5,s7
 662:	0007c583          	lbu	a1,0(a5)
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e0a080e7          	jalr	-502(ra) # 472 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 670:	0992                	slli	s3,s3,0x4
 672:	397d                	addiw	s2,s2,-1
 674:	fe0914e3          	bnez	s2,65c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 678:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 67c:	4981                	li	s3,0
 67e:	b70d                	j	5a0 <vprintf+0x60>
        s = va_arg(ap, char*);
 680:	008b0913          	addi	s2,s6,8
 684:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 688:	02098163          	beqz	s3,6aa <vprintf+0x16a>
        while(*s != 0){
 68c:	0009c583          	lbu	a1,0(s3)
 690:	c5ad                	beqz	a1,6fa <vprintf+0x1ba>
          putc(fd, *s);
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	dde080e7          	jalr	-546(ra) # 472 <putc>
          s++;
 69c:	0985                	addi	s3,s3,1
        while(*s != 0){
 69e:	0009c583          	lbu	a1,0(s3)
 6a2:	f9e5                	bnez	a1,692 <vprintf+0x152>
        s = va_arg(ap, char*);
 6a4:	8b4a                	mv	s6,s2
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bde5                	j	5a0 <vprintf+0x60>
          s = "(null)";
 6aa:	00000997          	auipc	s3,0x0
 6ae:	72698993          	addi	s3,s3,1830 # dd0 <get_time_perf+0xa2>
        while(*s != 0){
 6b2:	85ee                	mv	a1,s11
 6b4:	bff9                	j	692 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 6b6:	008b0913          	addi	s2,s6,8
 6ba:	000b4583          	lbu	a1,0(s6)
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	db2080e7          	jalr	-590(ra) # 472 <putc>
 6c8:	8b4a                	mv	s6,s2
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bdd1                	j	5a0 <vprintf+0x60>
        putc(fd, c);
 6ce:	85d2                	mv	a1,s4
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	da0080e7          	jalr	-608(ra) # 472 <putc>
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b5d1                	j	5a0 <vprintf+0x60>
        putc(fd, '%');
 6de:	85d2                	mv	a1,s4
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	d90080e7          	jalr	-624(ra) # 472 <putc>
        putc(fd, c);
 6ea:	85ca                	mv	a1,s2
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	d84080e7          	jalr	-636(ra) # 472 <putc>
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b565                	j	5a0 <vprintf+0x60>
        s = va_arg(ap, char*);
 6fa:	8b4a                	mv	s6,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b54d                	j	5a0 <vprintf+0x60>
    }
  }
}
 700:	70e6                	ld	ra,120(sp)
 702:	7446                	ld	s0,112(sp)
 704:	74a6                	ld	s1,104(sp)
 706:	7906                	ld	s2,96(sp)
 708:	69e6                	ld	s3,88(sp)
 70a:	6a46                	ld	s4,80(sp)
 70c:	6aa6                	ld	s5,72(sp)
 70e:	6b06                	ld	s6,64(sp)
 710:	7be2                	ld	s7,56(sp)
 712:	7c42                	ld	s8,48(sp)
 714:	7ca2                	ld	s9,40(sp)
 716:	7d02                	ld	s10,32(sp)
 718:	6de2                	ld	s11,24(sp)
 71a:	6109                	addi	sp,sp,128
 71c:	8082                	ret

000000000000071e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71e:	715d                	addi	sp,sp,-80
 720:	ec06                	sd	ra,24(sp)
 722:	e822                	sd	s0,16(sp)
 724:	1000                	addi	s0,sp,32
 726:	e010                	sd	a2,0(s0)
 728:	e414                	sd	a3,8(s0)
 72a:	e818                	sd	a4,16(s0)
 72c:	ec1c                	sd	a5,24(s0)
 72e:	03043023          	sd	a6,32(s0)
 732:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 736:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73a:	8622                	mv	a2,s0
 73c:	00000097          	auipc	ra,0x0
 740:	e04080e7          	jalr	-508(ra) # 540 <vprintf>
}
 744:	60e2                	ld	ra,24(sp)
 746:	6442                	ld	s0,16(sp)
 748:	6161                	addi	sp,sp,80
 74a:	8082                	ret

000000000000074c <printf>:

void
printf(const char *fmt, ...)
{
 74c:	711d                	addi	sp,sp,-96
 74e:	ec06                	sd	ra,24(sp)
 750:	e822                	sd	s0,16(sp)
 752:	1000                	addi	s0,sp,32
 754:	e40c                	sd	a1,8(s0)
 756:	e810                	sd	a2,16(s0)
 758:	ec14                	sd	a3,24(s0)
 75a:	f018                	sd	a4,32(s0)
 75c:	f41c                	sd	a5,40(s0)
 75e:	03043823          	sd	a6,48(s0)
 762:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 766:	00840613          	addi	a2,s0,8
 76a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 76e:	85aa                	mv	a1,a0
 770:	4505                	li	a0,1
 772:	00000097          	auipc	ra,0x0
 776:	dce080e7          	jalr	-562(ra) # 540 <vprintf>
}
 77a:	60e2                	ld	ra,24(sp)
 77c:	6442                	ld	s0,16(sp)
 77e:	6125                	addi	sp,sp,96
 780:	8082                	ret

0000000000000782 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 782:	1141                	addi	sp,sp,-16
 784:	e422                	sd	s0,8(sp)
 786:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 788:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78c:	00001797          	auipc	a5,0x1
 790:	8747b783          	ld	a5,-1932(a5) # 1000 <freep>
 794:	a02d                	j	7be <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 796:	4618                	lw	a4,8(a2)
 798:	9f2d                	addw	a4,a4,a1
 79a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 79e:	6398                	ld	a4,0(a5)
 7a0:	6310                	ld	a2,0(a4)
 7a2:	a83d                	j	7e0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7a4:	ff852703          	lw	a4,-8(a0)
 7a8:	9f31                	addw	a4,a4,a2
 7aa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ac:	ff053683          	ld	a3,-16(a0)
 7b0:	a091                	j	7f4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	6398                	ld	a4,0(a5)
 7b4:	00e7e463          	bltu	a5,a4,7bc <free+0x3a>
 7b8:	00e6ea63          	bltu	a3,a4,7cc <free+0x4a>
{
 7bc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	fed7fae3          	bgeu	a5,a3,7b2 <free+0x30>
 7c2:	6398                	ld	a4,0(a5)
 7c4:	00e6e463          	bltu	a3,a4,7cc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	fee7eae3          	bltu	a5,a4,7bc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7cc:	ff852583          	lw	a1,-8(a0)
 7d0:	6390                	ld	a2,0(a5)
 7d2:	02059813          	slli	a6,a1,0x20
 7d6:	01c85713          	srli	a4,a6,0x1c
 7da:	9736                	add	a4,a4,a3
 7dc:	fae60de3          	beq	a2,a4,796 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7e4:	4790                	lw	a2,8(a5)
 7e6:	02061593          	slli	a1,a2,0x20
 7ea:	01c5d713          	srli	a4,a1,0x1c
 7ee:	973e                	add	a4,a4,a5
 7f0:	fae68ae3          	beq	a3,a4,7a4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7f4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7f6:	00001717          	auipc	a4,0x1
 7fa:	80f73523          	sd	a5,-2038(a4) # 1000 <freep>
}
 7fe:	6422                	ld	s0,8(sp)
 800:	0141                	addi	sp,sp,16
 802:	8082                	ret

0000000000000804 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 804:	7139                	addi	sp,sp,-64
 806:	fc06                	sd	ra,56(sp)
 808:	f822                	sd	s0,48(sp)
 80a:	f426                	sd	s1,40(sp)
 80c:	f04a                	sd	s2,32(sp)
 80e:	ec4e                	sd	s3,24(sp)
 810:	e852                	sd	s4,16(sp)
 812:	e456                	sd	s5,8(sp)
 814:	e05a                	sd	s6,0(sp)
 816:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 818:	02051493          	slli	s1,a0,0x20
 81c:	9081                	srli	s1,s1,0x20
 81e:	04bd                	addi	s1,s1,15
 820:	8091                	srli	s1,s1,0x4
 822:	0014899b          	addiw	s3,s1,1
 826:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 828:	00000517          	auipc	a0,0x0
 82c:	7d853503          	ld	a0,2008(a0) # 1000 <freep>
 830:	c515                	beqz	a0,85c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 834:	4798                	lw	a4,8(a5)
 836:	02977f63          	bgeu	a4,s1,874 <malloc+0x70>
 83a:	8a4e                	mv	s4,s3
 83c:	0009871b          	sext.w	a4,s3
 840:	6685                	lui	a3,0x1
 842:	00d77363          	bgeu	a4,a3,848 <malloc+0x44>
 846:	6a05                	lui	s4,0x1
 848:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 84c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 850:	00000917          	auipc	s2,0x0
 854:	7b090913          	addi	s2,s2,1968 # 1000 <freep>
  if(p == (char*)-1)
 858:	5afd                	li	s5,-1
 85a:	a895                	j	8ce <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 85c:	00000797          	auipc	a5,0x0
 860:	7b478793          	addi	a5,a5,1972 # 1010 <base>
 864:	00000717          	auipc	a4,0x0
 868:	78f73e23          	sd	a5,1948(a4) # 1000 <freep>
 86c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 86e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 872:	b7e1                	j	83a <malloc+0x36>
      if(p->s.size == nunits)
 874:	02e48c63          	beq	s1,a4,8ac <malloc+0xa8>
        p->s.size -= nunits;
 878:	4137073b          	subw	a4,a4,s3
 87c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 87e:	02071693          	slli	a3,a4,0x20
 882:	01c6d713          	srli	a4,a3,0x1c
 886:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 888:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 88c:	00000717          	auipc	a4,0x0
 890:	76a73a23          	sd	a0,1908(a4) # 1000 <freep>
      return (void*)(p + 1);
 894:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 898:	70e2                	ld	ra,56(sp)
 89a:	7442                	ld	s0,48(sp)
 89c:	74a2                	ld	s1,40(sp)
 89e:	7902                	ld	s2,32(sp)
 8a0:	69e2                	ld	s3,24(sp)
 8a2:	6a42                	ld	s4,16(sp)
 8a4:	6aa2                	ld	s5,8(sp)
 8a6:	6b02                	ld	s6,0(sp)
 8a8:	6121                	addi	sp,sp,64
 8aa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8ac:	6398                	ld	a4,0(a5)
 8ae:	e118                	sd	a4,0(a0)
 8b0:	bff1                	j	88c <malloc+0x88>
  hp->s.size = nu;
 8b2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b6:	0541                	addi	a0,a0,16
 8b8:	00000097          	auipc	ra,0x0
 8bc:	eca080e7          	jalr	-310(ra) # 782 <free>
  return freep;
 8c0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c4:	d971                	beqz	a0,898 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c8:	4798                	lw	a4,8(a5)
 8ca:	fa9775e3          	bgeu	a4,s1,874 <malloc+0x70>
    if(p == freep)
 8ce:	00093703          	ld	a4,0(s2)
 8d2:	853e                	mv	a0,a5
 8d4:	fef719e3          	bne	a4,a5,8c6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8d8:	8552                	mv	a0,s4
 8da:	00000097          	auipc	ra,0x0
 8de:	b40080e7          	jalr	-1216(ra) # 41a <sbrk>
  if(p == (char*)-1)
 8e2:	fd5518e3          	bne	a0,s5,8b2 <malloc+0xae>
        return 0;
 8e6:	4501                	li	a0,0
 8e8:	bf45                	j	898 <malloc+0x94>

00000000000008ea <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 8ea:	c1d9                	beqz	a1,970 <head_run+0x86>
void head_run(int fd, int numOfLines){
 8ec:	dd010113          	addi	sp,sp,-560
 8f0:	22113423          	sd	ra,552(sp)
 8f4:	22813023          	sd	s0,544(sp)
 8f8:	20913c23          	sd	s1,536(sp)
 8fc:	21213823          	sd	s2,528(sp)
 900:	21313423          	sd	s3,520(sp)
 904:	21413023          	sd	s4,512(sp)
 908:	1c00                	addi	s0,sp,560
 90a:	892a                	mv	s2,a0
 90c:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 910:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 912:	00000a17          	auipc	s4,0x0
 916:	55ea0a13          	addi	s4,s4,1374 # e70 <digits+0x40>
		readStatus = read_line(fd, line);
 91a:	dd840593          	addi	a1,s0,-552
 91e:	854a                	mv	a0,s2
 920:	00000097          	auipc	ra,0x0
 924:	394080e7          	jalr	916(ra) # cb4 <read_line>
		if (readStatus == READ_ERROR){
 928:	01350d63          	beq	a0,s3,942 <head_run+0x58>
		if (readStatus == READ_EOF)
 92c:	c11d                	beqz	a0,952 <head_run+0x68>
		printf("%s",line);
 92e:	dd840593          	addi	a1,s0,-552
 932:	8552                	mv	a0,s4
 934:	00000097          	auipc	ra,0x0
 938:	e18080e7          	jalr	-488(ra) # 74c <printf>
	while(numOfLines--){
 93c:	34fd                	addiw	s1,s1,-1
 93e:	fcf1                	bnez	s1,91a <head_run+0x30>
 940:	a809                	j	952 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 942:	00000517          	auipc	a0,0x0
 946:	50650513          	addi	a0,a0,1286 # e48 <digits+0x18>
 94a:	00000097          	auipc	ra,0x0
 94e:	e02080e7          	jalr	-510(ra) # 74c <printf>

	}
}
 952:	22813083          	ld	ra,552(sp)
 956:	22013403          	ld	s0,544(sp)
 95a:	21813483          	ld	s1,536(sp)
 95e:	21013903          	ld	s2,528(sp)
 962:	20813983          	ld	s3,520(sp)
 966:	20013a03          	ld	s4,512(sp)
 96a:	23010113          	addi	sp,sp,560
 96e:	8082                	ret
 970:	8082                	ret

0000000000000972 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 972:	ba010113          	addi	sp,sp,-1120
 976:	44113c23          	sd	ra,1112(sp)
 97a:	44813823          	sd	s0,1104(sp)
 97e:	44913423          	sd	s1,1096(sp)
 982:	45213023          	sd	s2,1088(sp)
 986:	43313c23          	sd	s3,1080(sp)
 98a:	43413823          	sd	s4,1072(sp)
 98e:	43513423          	sd	s5,1064(sp)
 992:	43613023          	sd	s6,1056(sp)
 996:	41713c23          	sd	s7,1048(sp)
 99a:	41813823          	sd	s8,1040(sp)
 99e:	41913423          	sd	s9,1032(sp)
 9a2:	41a13023          	sd	s10,1024(sp)
 9a6:	3fb13c23          	sd	s11,1016(sp)
 9aa:	46010413          	addi	s0,sp,1120
 9ae:	89aa                	mv	s3,a0
 9b0:	8aae                	mv	s5,a1
 9b2:	8c32                	mv	s8,a2
 9b4:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 9b6:	d9840593          	addi	a1,s0,-616
 9ba:	00000097          	auipc	ra,0x0
 9be:	2fa080e7          	jalr	762(ra) # cb4 <read_line>


  if (readStatus == READ_ERROR)
 9c2:	57fd                	li	a5,-1
 9c4:	04f50163          	beq	a0,a5,a06 <uniq_run+0x94>
 9c8:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 9ca:	ed21                	bnez	a0,a22 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 9cc:	45813083          	ld	ra,1112(sp)
 9d0:	45013403          	ld	s0,1104(sp)
 9d4:	44813483          	ld	s1,1096(sp)
 9d8:	44013903          	ld	s2,1088(sp)
 9dc:	43813983          	ld	s3,1080(sp)
 9e0:	43013a03          	ld	s4,1072(sp)
 9e4:	42813a83          	ld	s5,1064(sp)
 9e8:	42013b03          	ld	s6,1056(sp)
 9ec:	41813b83          	ld	s7,1048(sp)
 9f0:	41013c03          	ld	s8,1040(sp)
 9f4:	40813c83          	ld	s9,1032(sp)
 9f8:	40013d03          	ld	s10,1024(sp)
 9fc:	3f813d83          	ld	s11,1016(sp)
 a00:	46010113          	addi	sp,sp,1120
 a04:	8082                	ret
    printf("[ERR] Error reading from the file ");
 a06:	00000517          	auipc	a0,0x0
 a0a:	47250513          	addi	a0,a0,1138 # e78 <digits+0x48>
 a0e:	00000097          	auipc	ra,0x0
 a12:	d3e080e7          	jalr	-706(ra) # 74c <printf>
 a16:	bf5d                	j	9cc <uniq_run+0x5a>
 a18:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a1a:	8926                	mv	s2,s1
 a1c:	84be                	mv	s1,a5
        lineCount = 1;
 a1e:	8b6a                	mv	s6,s10
 a20:	a8ed                	j	b1a <uniq_run+0x1a8>
    int lineCount=1;
 a22:	4b05                	li	s6,1
  char * line2 = buffer2;
 a24:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 a28:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 a2c:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 a2e:	4d05                	li	s10,1
              printf("%s",line1);
 a30:	00000d97          	auipc	s11,0x0
 a34:	440d8d93          	addi	s11,s11,1088 # e70 <digits+0x40>
 a38:	a0cd                	j	b1a <uniq_run+0x1a8>
            if (repeatedLines){
 a3a:	020a0b63          	beqz	s4,a70 <uniq_run+0xfe>
                if (isRepeated){
 a3e:	f80b87e3          	beqz	s7,9cc <uniq_run+0x5a>
                    if (showCount)
 a42:	000c0d63          	beqz	s8,a5c <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 a46:	864a                	mv	a2,s2
 a48:	85da                	mv	a1,s6
 a4a:	00000517          	auipc	a0,0x0
 a4e:	45650513          	addi	a0,a0,1110 # ea0 <digits+0x70>
 a52:	00000097          	auipc	ra,0x0
 a56:	cfa080e7          	jalr	-774(ra) # 74c <printf>
 a5a:	bf8d                	j	9cc <uniq_run+0x5a>
                      printf("%s",line1);
 a5c:	85ca                	mv	a1,s2
 a5e:	00000517          	auipc	a0,0x0
 a62:	41250513          	addi	a0,a0,1042 # e70 <digits+0x40>
 a66:	00000097          	auipc	ra,0x0
 a6a:	ce6080e7          	jalr	-794(ra) # 74c <printf>
 a6e:	bfb9                	j	9cc <uniq_run+0x5a>
                if (showCount)
 a70:	000c0d63          	beqz	s8,a8a <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 a74:	864a                	mv	a2,s2
 a76:	85da                	mv	a1,s6
 a78:	00000517          	auipc	a0,0x0
 a7c:	42850513          	addi	a0,a0,1064 # ea0 <digits+0x70>
 a80:	00000097          	auipc	ra,0x0
 a84:	ccc080e7          	jalr	-820(ra) # 74c <printf>
 a88:	b791                	j	9cc <uniq_run+0x5a>
                  printf("%s",line1);
 a8a:	85ca                	mv	a1,s2
 a8c:	00000517          	auipc	a0,0x0
 a90:	3e450513          	addi	a0,a0,996 # e70 <digits+0x40>
 a94:	00000097          	auipc	ra,0x0
 a98:	cb8080e7          	jalr	-840(ra) # 74c <printf>
 a9c:	bf05                	j	9cc <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 a9e:	00000517          	auipc	a0,0x0
 aa2:	40a50513          	addi	a0,a0,1034 # ea8 <digits+0x78>
 aa6:	00000097          	auipc	ra,0x0
 aaa:	ca6080e7          	jalr	-858(ra) # 74c <printf>
          break;
 aae:	bf39                	j	9cc <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 ab0:	85a6                	mv	a1,s1
 ab2:	854a                	mv	a0,s2
 ab4:	00000097          	auipc	ra,0x0
 ab8:	110080e7          	jalr	272(ra) # bc4 <compare_str_ic>
 abc:	a041                	j	b3c <uniq_run+0x1ca>
                  printf("%s",line1);
 abe:	85ca                	mv	a1,s2
 ac0:	856e                	mv	a0,s11
 ac2:	00000097          	auipc	ra,0x0
 ac6:	c8a080e7          	jalr	-886(ra) # 74c <printf>
        lineCount = 1;
 aca:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 acc:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 ace:	8926                	mv	s2,s1
                  printf("%s",line1);
 ad0:	84be                	mv	s1,a5
        isRepeated = 0 ;
 ad2:	4b81                	li	s7,0
 ad4:	a099                	j	b1a <uniq_run+0x1a8>
            if (showCount)
 ad6:	020c0263          	beqz	s8,afa <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 ada:	864a                	mv	a2,s2
 adc:	85da                	mv	a1,s6
 ade:	00000517          	auipc	a0,0x0
 ae2:	3c250513          	addi	a0,a0,962 # ea0 <digits+0x70>
 ae6:	00000097          	auipc	ra,0x0
 aea:	c66080e7          	jalr	-922(ra) # 74c <printf>
 aee:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 af0:	8926                	mv	s2,s1
 af2:	84be                	mv	s1,a5
        isRepeated = 0 ;
 af4:	4b81                	li	s7,0
        lineCount = 1;
 af6:	8b6a                	mv	s6,s10
 af8:	a00d                	j	b1a <uniq_run+0x1a8>
              printf("%s",line1);
 afa:	85ca                	mv	a1,s2
 afc:	856e                	mv	a0,s11
 afe:	00000097          	auipc	ra,0x0
 b02:	c4e080e7          	jalr	-946(ra) # 74c <printf>
 b06:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b08:	8926                	mv	s2,s1
              printf("%s",line1);
 b0a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b0c:	4b81                	li	s7,0
        lineCount = 1;
 b0e:	8b6a                	mv	s6,s10
 b10:	a029                	j	b1a <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 b12:	000a0363          	beqz	s4,b18 <uniq_run+0x1a6>
 b16:	8bea                	mv	s7,s10
          lineCount++;
 b18:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 b1a:	85a6                	mv	a1,s1
 b1c:	854e                	mv	a0,s3
 b1e:	00000097          	auipc	ra,0x0
 b22:	196080e7          	jalr	406(ra) # cb4 <read_line>
        if (readStatus == READ_EOF){
 b26:	d911                	beqz	a0,a3a <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 b28:	f7950be3          	beq	a0,s9,a9e <uniq_run+0x12c>
        if (!ignoreCase)
 b2c:	f80a92e3          	bnez	s5,ab0 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 b30:	85a6                	mv	a1,s1
 b32:	854a                	mv	a0,s2
 b34:	00000097          	auipc	ra,0x0
 b38:	062080e7          	jalr	98(ra) # b96 <compare_str>
        if (compareStatus != 0){ 
 b3c:	d979                	beqz	a0,b12 <uniq_run+0x1a0>
          if (repeatedLines){
 b3e:	f80a0ce3          	beqz	s4,ad6 <uniq_run+0x164>
            if (isRepeated){
 b42:	ec0b8be3          	beqz	s7,a18 <uniq_run+0xa6>
                if (showCount)
 b46:	f60c0ce3          	beqz	s8,abe <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 b4a:	864a                	mv	a2,s2
 b4c:	85da                	mv	a1,s6
 b4e:	00000517          	auipc	a0,0x0
 b52:	35250513          	addi	a0,a0,850 # ea0 <digits+0x70>
 b56:	00000097          	auipc	ra,0x0
 b5a:	bf6080e7          	jalr	-1034(ra) # 74c <printf>
        lineCount = 1;
 b5e:	8b5e                	mv	s6,s7
 b60:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b62:	8926                	mv	s2,s1
 b64:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b66:	4b81                	li	s7,0
 b68:	bf4d                	j	b1a <uniq_run+0x1a8>

0000000000000b6a <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 b6a:	1141                	addi	sp,sp,-16
 b6c:	e422                	sd	s0,8(sp)
 b6e:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 b70:	00054783          	lbu	a5,0(a0)
 b74:	cf99                	beqz	a5,b92 <get_strlen+0x28>
 b76:	00150713          	addi	a4,a0,1
 b7a:	87ba                	mv	a5,a4
 b7c:	4685                	li	a3,1
 b7e:	9e99                	subw	a3,a3,a4
 b80:	00f6853b          	addw	a0,a3,a5
 b84:	0785                	addi	a5,a5,1
 b86:	fff7c703          	lbu	a4,-1(a5)
 b8a:	fb7d                	bnez	a4,b80 <get_strlen+0x16>
	return len;
}
 b8c:	6422                	ld	s0,8(sp)
 b8e:	0141                	addi	sp,sp,16
 b90:	8082                	ret
	int len = 0;
 b92:	4501                	li	a0,0
 b94:	bfe5                	j	b8c <get_strlen+0x22>

0000000000000b96 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 b96:	1141                	addi	sp,sp,-16
 b98:	e422                	sd	s0,8(sp)
 b9a:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 b9c:	00054783          	lbu	a5,0(a0)
 ba0:	cb91                	beqz	a5,bb4 <compare_str+0x1e>
 ba2:	0005c703          	lbu	a4,0(a1)
 ba6:	c719                	beqz	a4,bb4 <compare_str+0x1e>
		if (*s1++ != *s2++)
 ba8:	0505                	addi	a0,a0,1
 baa:	0585                	addi	a1,a1,1
 bac:	fee788e3          	beq	a5,a4,b9c <compare_str+0x6>
			return 1;
 bb0:	4505                	li	a0,1
 bb2:	a031                	j	bbe <compare_str+0x28>
	}
	if (*s1 == *s2)
 bb4:	0005c503          	lbu	a0,0(a1)
 bb8:	8d1d                	sub	a0,a0,a5
			return 1;
 bba:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 bbe:	6422                	ld	s0,8(sp)
 bc0:	0141                	addi	sp,sp,16
 bc2:	8082                	ret

0000000000000bc4 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 bc4:	1141                	addi	sp,sp,-16
 bc6:	e422                	sd	s0,8(sp)
 bc8:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 bca:	4665                	li	a2,25
	while(*s1 && *s2){
 bcc:	a019                	j	bd2 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 bce:	04e79763          	bne	a5,a4,c1c <compare_str_ic+0x58>
	while(*s1 && *s2){
 bd2:	00054783          	lbu	a5,0(a0)
 bd6:	cb9d                	beqz	a5,c0c <compare_str_ic+0x48>
 bd8:	0005c703          	lbu	a4,0(a1)
 bdc:	cb05                	beqz	a4,c0c <compare_str_ic+0x48>
		char b1 = *s1++;
 bde:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 be0:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 be2:	fbf7869b          	addiw	a3,a5,-65
 be6:	0ff6f693          	zext.b	a3,a3
 bea:	00d66663          	bltu	a2,a3,bf6 <compare_str_ic+0x32>
			b1 += 32;
 bee:	0207879b          	addiw	a5,a5,32
 bf2:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 bf6:	fbf7069b          	addiw	a3,a4,-65
 bfa:	0ff6f693          	zext.b	a3,a3
 bfe:	fcd668e3          	bltu	a2,a3,bce <compare_str_ic+0xa>
			b2 += 32;
 c02:	0207071b          	addiw	a4,a4,32
 c06:	0ff77713          	zext.b	a4,a4
 c0a:	b7d1                	j	bce <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 c0c:	0005c503          	lbu	a0,0(a1)
 c10:	8d1d                	sub	a0,a0,a5
			return 1;
 c12:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 c16:	6422                	ld	s0,8(sp)
 c18:	0141                	addi	sp,sp,16
 c1a:	8082                	ret
			return 1;
 c1c:	4505                	li	a0,1
 c1e:	bfe5                	j	c16 <compare_str_ic+0x52>

0000000000000c20 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 c20:	7179                	addi	sp,sp,-48
 c22:	f406                	sd	ra,40(sp)
 c24:	f022                	sd	s0,32(sp)
 c26:	ec26                	sd	s1,24(sp)
 c28:	e84a                	sd	s2,16(sp)
 c2a:	e44e                	sd	s3,8(sp)
 c2c:	1800                	addi	s0,sp,48
 c2e:	89aa                	mv	s3,a0
 c30:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 c32:	00000097          	auipc	ra,0x0
 c36:	f38080e7          	jalr	-200(ra) # b6a <get_strlen>
 c3a:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 c3c:	854a                	mv	a0,s2
 c3e:	00000097          	auipc	ra,0x0
 c42:	f2c080e7          	jalr	-212(ra) # b6a <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 c46:	409505bb          	subw	a1,a0,s1
 c4a:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 c4c:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 c4e:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 c50:	0005da63          	bgez	a1,c64 <check_substr+0x44>
 c54:	a81d                	j	c8a <check_substr+0x6a>
        if (j == M)
 c56:	02f48a63          	beq	s1,a5,c8a <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 c5a:	0885                	addi	a7,a7,1
 c5c:	0008879b          	sext.w	a5,a7
 c60:	02f5cc63          	blt	a1,a5,c98 <check_substr+0x78>
 c64:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 c68:	011906b3          	add	a3,s2,a7
 c6c:	874e                	mv	a4,s3
 c6e:	879a                	mv	a5,t1
 c70:	fe9053e3          	blez	s1,c56 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 c74:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 c78:	00074603          	lbu	a2,0(a4)
 c7c:	fcc81de3          	bne	a6,a2,c56 <check_substr+0x36>
        for (j = 0; j < M; j++)
 c80:	2785                	addiw	a5,a5,1
 c82:	0685                	addi	a3,a3,1
 c84:	0705                	addi	a4,a4,1
 c86:	fef497e3          	bne	s1,a5,c74 <check_substr+0x54>
}
 c8a:	70a2                	ld	ra,40(sp)
 c8c:	7402                	ld	s0,32(sp)
 c8e:	64e2                	ld	s1,24(sp)
 c90:	6942                	ld	s2,16(sp)
 c92:	69a2                	ld	s3,8(sp)
 c94:	6145                	addi	sp,sp,48
 c96:	8082                	ret
    return -1;
 c98:	557d                	li	a0,-1
 c9a:	bfc5                	j	c8a <check_substr+0x6a>

0000000000000c9c <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 c9c:	1141                	addi	sp,sp,-16
 c9e:	e406                	sd	ra,8(sp)
 ca0:	e022                	sd	s0,0(sp)
 ca2:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 ca4:	fffff097          	auipc	ra,0xfffff
 ca8:	72e080e7          	jalr	1838(ra) # 3d2 <open>
	return fd;
}
 cac:	60a2                	ld	ra,8(sp)
 cae:	6402                	ld	s0,0(sp)
 cb0:	0141                	addi	sp,sp,16
 cb2:	8082                	ret

0000000000000cb4 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 cb4:	7139                	addi	sp,sp,-64
 cb6:	fc06                	sd	ra,56(sp)
 cb8:	f822                	sd	s0,48(sp)
 cba:	f426                	sd	s1,40(sp)
 cbc:	f04a                	sd	s2,32(sp)
 cbe:	ec4e                	sd	s3,24(sp)
 cc0:	e852                	sd	s4,16(sp)
 cc2:	0080                	addi	s0,sp,64
 cc4:	89aa                	mv	s3,a0
 cc6:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 cc8:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 cca:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 ccc:	4605                	li	a2,1
 cce:	fcf40593          	addi	a1,s0,-49
 cd2:	854e                	mv	a0,s3
 cd4:	fffff097          	auipc	ra,0xfffff
 cd8:	6d6080e7          	jalr	1750(ra) # 3aa <read>
		if (readStatus == 0){
 cdc:	c505                	beqz	a0,d04 <read_line+0x50>
		*buffer++ = readByte;
 cde:	0485                	addi	s1,s1,1
 ce0:	fcf44783          	lbu	a5,-49(s0)
 ce4:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 ce8:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 cea:	ff4791e3          	bne	a5,s4,ccc <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 cee:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 cf2:	854a                	mv	a0,s2
 cf4:	70e2                	ld	ra,56(sp)
 cf6:	7442                	ld	s0,48(sp)
 cf8:	74a2                	ld	s1,40(sp)
 cfa:	7902                	ld	s2,32(sp)
 cfc:	69e2                	ld	s3,24(sp)
 cfe:	6a42                	ld	s4,16(sp)
 d00:	6121                	addi	sp,sp,64
 d02:	8082                	ret
			if (byteCount!=0){
 d04:	fe0907e3          	beqz	s2,cf2 <read_line+0x3e>
				*buffer = '\n';
 d08:	47a9                	li	a5,10
 d0a:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 d0e:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 d12:	2905                	addiw	s2,s2,1
 d14:	bff9                	j	cf2 <read_line+0x3e>

0000000000000d16 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 d16:	1141                	addi	sp,sp,-16
 d18:	e406                	sd	ra,8(sp)
 d1a:	e022                	sd	s0,0(sp)
 d1c:	0800                	addi	s0,sp,16
	close(fd);
 d1e:	fffff097          	auipc	ra,0xfffff
 d22:	69c080e7          	jalr	1692(ra) # 3ba <close>
}
 d26:	60a2                	ld	ra,8(sp)
 d28:	6402                	ld	s0,0(sp)
 d2a:	0141                	addi	sp,sp,16
 d2c:	8082                	ret

0000000000000d2e <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 d2e:	7139                	addi	sp,sp,-64
 d30:	fc06                	sd	ra,56(sp)
 d32:	f822                	sd	s0,48(sp)
 d34:	f426                	sd	s1,40(sp)
 d36:	f04a                	sd	s2,32(sp)
 d38:	0080                	addi	s0,sp,64
 d3a:	84aa                	mv	s1,a0
 d3c:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 d3e:	fffff097          	auipc	ra,0xfffff
 d42:	64c080e7          	jalr	1612(ra) # 38a <fork>
 d46:	ed19                	bnez	a0,d64 <get_time_perf+0x36>
		exec(argv[0],argv);
 d48:	85ca                	mv	a1,s2
 d4a:	00093503          	ld	a0,0(s2)
 d4e:	fffff097          	auipc	ra,0xfffff
 d52:	67c080e7          	jalr	1660(ra) # 3ca <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 d56:	8526                	mv	a0,s1
 d58:	70e2                	ld	ra,56(sp)
 d5a:	7442                	ld	s0,48(sp)
 d5c:	74a2                	ld	s1,40(sp)
 d5e:	7902                	ld	s2,32(sp)
 d60:	6121                	addi	sp,sp,64
 d62:	8082                	ret
		times(pid , &time);
 d64:	fc040593          	addi	a1,s0,-64
 d68:	fffff097          	auipc	ra,0xfffff
 d6c:	6e2080e7          	jalr	1762(ra) # 44a <times>
		return time;
 d70:	fc043783          	ld	a5,-64(s0)
 d74:	e09c                	sd	a5,0(s1)
 d76:	fc843783          	ld	a5,-56(s0)
 d7a:	e49c                	sd	a5,8(s1)
 d7c:	fd043783          	ld	a5,-48(s0)
 d80:	e89c                	sd	a5,16(s1)
 d82:	fd843783          	ld	a5,-40(s0)
 d86:	ec9c                	sd	a5,24(s1)
 d88:	b7f9                	j	d56 <get_time_perf+0x28>
