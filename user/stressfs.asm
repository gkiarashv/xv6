
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
  1a:	caa78793          	addi	a5,a5,-854 # cc0 <close_file+0x4a>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	c6450513          	addi	a0,a0,-924 # c90 <close_file+0x1a>
  34:	00000097          	auipc	ra,0x0
  38:	6e8080e7          	jalr	1768(ra) # 71c <printf>
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
  6c:	c4050513          	addi	a0,a0,-960 # ca8 <close_file+0x32>
  70:	00000097          	auipc	ra,0x0
  74:	6ac080e7          	jalr	1708(ra) # 71c <printf>

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
  ba:	c0250513          	addi	a0,a0,-1022 # cb8 <close_file+0x42>
  be:	00000097          	auipc	ra,0x0
  c2:	65e080e7          	jalr	1630(ra) # 71c <printf>

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

0000000000000442 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 442:	1101                	addi	sp,sp,-32
 444:	ec06                	sd	ra,24(sp)
 446:	e822                	sd	s0,16(sp)
 448:	1000                	addi	s0,sp,32
 44a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44e:	4605                	li	a2,1
 450:	fef40593          	addi	a1,s0,-17
 454:	00000097          	auipc	ra,0x0
 458:	f5e080e7          	jalr	-162(ra) # 3b2 <write>
}
 45c:	60e2                	ld	ra,24(sp)
 45e:	6442                	ld	s0,16(sp)
 460:	6105                	addi	sp,sp,32
 462:	8082                	ret

0000000000000464 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 464:	7139                	addi	sp,sp,-64
 466:	fc06                	sd	ra,56(sp)
 468:	f822                	sd	s0,48(sp)
 46a:	f426                	sd	s1,40(sp)
 46c:	f04a                	sd	s2,32(sp)
 46e:	ec4e                	sd	s3,24(sp)
 470:	0080                	addi	s0,sp,64
 472:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 474:	c299                	beqz	a3,47a <printint+0x16>
 476:	0805c963          	bltz	a1,508 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 47a:	2581                	sext.w	a1,a1
  neg = 0;
 47c:	4881                	li	a7,0
 47e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 482:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 484:	2601                	sext.w	a2,a2
 486:	00001517          	auipc	a0,0x1
 48a:	8aa50513          	addi	a0,a0,-1878 # d30 <digits>
 48e:	883a                	mv	a6,a4
 490:	2705                	addiw	a4,a4,1
 492:	02c5f7bb          	remuw	a5,a1,a2
 496:	1782                	slli	a5,a5,0x20
 498:	9381                	srli	a5,a5,0x20
 49a:	97aa                	add	a5,a5,a0
 49c:	0007c783          	lbu	a5,0(a5)
 4a0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a4:	0005879b          	sext.w	a5,a1
 4a8:	02c5d5bb          	divuw	a1,a1,a2
 4ac:	0685                	addi	a3,a3,1
 4ae:	fec7f0e3          	bgeu	a5,a2,48e <printint+0x2a>
  if(neg)
 4b2:	00088c63          	beqz	a7,4ca <printint+0x66>
    buf[i++] = '-';
 4b6:	fd070793          	addi	a5,a4,-48
 4ba:	00878733          	add	a4,a5,s0
 4be:	02d00793          	li	a5,45
 4c2:	fef70823          	sb	a5,-16(a4)
 4c6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ca:	02e05863          	blez	a4,4fa <printint+0x96>
 4ce:	fc040793          	addi	a5,s0,-64
 4d2:	00e78933          	add	s2,a5,a4
 4d6:	fff78993          	addi	s3,a5,-1
 4da:	99ba                	add	s3,s3,a4
 4dc:	377d                	addiw	a4,a4,-1
 4de:	1702                	slli	a4,a4,0x20
 4e0:	9301                	srli	a4,a4,0x20
 4e2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e6:	fff94583          	lbu	a1,-1(s2)
 4ea:	8526                	mv	a0,s1
 4ec:	00000097          	auipc	ra,0x0
 4f0:	f56080e7          	jalr	-170(ra) # 442 <putc>
  while(--i >= 0)
 4f4:	197d                	addi	s2,s2,-1
 4f6:	ff3918e3          	bne	s2,s3,4e6 <printint+0x82>
}
 4fa:	70e2                	ld	ra,56(sp)
 4fc:	7442                	ld	s0,48(sp)
 4fe:	74a2                	ld	s1,40(sp)
 500:	7902                	ld	s2,32(sp)
 502:	69e2                	ld	s3,24(sp)
 504:	6121                	addi	sp,sp,64
 506:	8082                	ret
    x = -xx;
 508:	40b005bb          	negw	a1,a1
    neg = 1;
 50c:	4885                	li	a7,1
    x = -xx;
 50e:	bf85                	j	47e <printint+0x1a>

0000000000000510 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 510:	7119                	addi	sp,sp,-128
 512:	fc86                	sd	ra,120(sp)
 514:	f8a2                	sd	s0,112(sp)
 516:	f4a6                	sd	s1,104(sp)
 518:	f0ca                	sd	s2,96(sp)
 51a:	ecce                	sd	s3,88(sp)
 51c:	e8d2                	sd	s4,80(sp)
 51e:	e4d6                	sd	s5,72(sp)
 520:	e0da                	sd	s6,64(sp)
 522:	fc5e                	sd	s7,56(sp)
 524:	f862                	sd	s8,48(sp)
 526:	f466                	sd	s9,40(sp)
 528:	f06a                	sd	s10,32(sp)
 52a:	ec6e                	sd	s11,24(sp)
 52c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52e:	0005c903          	lbu	s2,0(a1)
 532:	18090f63          	beqz	s2,6d0 <vprintf+0x1c0>
 536:	8aaa                	mv	s5,a0
 538:	8b32                	mv	s6,a2
 53a:	00158493          	addi	s1,a1,1
  state = 0;
 53e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 540:	02500a13          	li	s4,37
 544:	4c55                	li	s8,21
 546:	00000c97          	auipc	s9,0x0
 54a:	792c8c93          	addi	s9,s9,1938 # cd8 <close_file+0x62>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 54e:	02800d93          	li	s11,40
  putc(fd, 'x');
 552:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 554:	00000b97          	auipc	s7,0x0
 558:	7dcb8b93          	addi	s7,s7,2012 # d30 <digits>
 55c:	a839                	j	57a <vprintf+0x6a>
        putc(fd, c);
 55e:	85ca                	mv	a1,s2
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	ee0080e7          	jalr	-288(ra) # 442 <putc>
 56a:	a019                	j	570 <vprintf+0x60>
    } else if(state == '%'){
 56c:	01498d63          	beq	s3,s4,586 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 570:	0485                	addi	s1,s1,1
 572:	fff4c903          	lbu	s2,-1(s1)
 576:	14090d63          	beqz	s2,6d0 <vprintf+0x1c0>
    if(state == 0){
 57a:	fe0999e3          	bnez	s3,56c <vprintf+0x5c>
      if(c == '%'){
 57e:	ff4910e3          	bne	s2,s4,55e <vprintf+0x4e>
        state = '%';
 582:	89d2                	mv	s3,s4
 584:	b7f5                	j	570 <vprintf+0x60>
      if(c == 'd'){
 586:	11490c63          	beq	s2,s4,69e <vprintf+0x18e>
 58a:	f9d9079b          	addiw	a5,s2,-99
 58e:	0ff7f793          	zext.b	a5,a5
 592:	10fc6e63          	bltu	s8,a5,6ae <vprintf+0x19e>
 596:	f9d9079b          	addiw	a5,s2,-99
 59a:	0ff7f713          	zext.b	a4,a5
 59e:	10ec6863          	bltu	s8,a4,6ae <vprintf+0x19e>
 5a2:	00271793          	slli	a5,a4,0x2
 5a6:	97e6                	add	a5,a5,s9
 5a8:	439c                	lw	a5,0(a5)
 5aa:	97e6                	add	a5,a5,s9
 5ac:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5ae:	008b0913          	addi	s2,s6,8
 5b2:	4685                	li	a3,1
 5b4:	4629                	li	a2,10
 5b6:	000b2583          	lw	a1,0(s6)
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	ea8080e7          	jalr	-344(ra) # 464 <printint>
 5c4:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b765                	j	570 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	008b0913          	addi	s2,s6,8
 5ce:	4681                	li	a3,0
 5d0:	4629                	li	a2,10
 5d2:	000b2583          	lw	a1,0(s6)
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e8c080e7          	jalr	-372(ra) # 464 <printint>
 5e0:	8b4a                	mv	s6,s2
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b771                	j	570 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5e6:	008b0913          	addi	s2,s6,8
 5ea:	4681                	li	a3,0
 5ec:	866a                	mv	a2,s10
 5ee:	000b2583          	lw	a1,0(s6)
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e70080e7          	jalr	-400(ra) # 464 <printint>
 5fc:	8b4a                	mv	s6,s2
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bf85                	j	570 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 602:	008b0793          	addi	a5,s6,8
 606:	f8f43423          	sd	a5,-120(s0)
 60a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 60e:	03000593          	li	a1,48
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	e2e080e7          	jalr	-466(ra) # 442 <putc>
  putc(fd, 'x');
 61c:	07800593          	li	a1,120
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	e20080e7          	jalr	-480(ra) # 442 <putc>
 62a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 62c:	03c9d793          	srli	a5,s3,0x3c
 630:	97de                	add	a5,a5,s7
 632:	0007c583          	lbu	a1,0(a5)
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e0a080e7          	jalr	-502(ra) # 442 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 640:	0992                	slli	s3,s3,0x4
 642:	397d                	addiw	s2,s2,-1
 644:	fe0914e3          	bnez	s2,62c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 648:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 64c:	4981                	li	s3,0
 64e:	b70d                	j	570 <vprintf+0x60>
        s = va_arg(ap, char*);
 650:	008b0913          	addi	s2,s6,8
 654:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 658:	02098163          	beqz	s3,67a <vprintf+0x16a>
        while(*s != 0){
 65c:	0009c583          	lbu	a1,0(s3)
 660:	c5ad                	beqz	a1,6ca <vprintf+0x1ba>
          putc(fd, *s);
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	dde080e7          	jalr	-546(ra) # 442 <putc>
          s++;
 66c:	0985                	addi	s3,s3,1
        while(*s != 0){
 66e:	0009c583          	lbu	a1,0(s3)
 672:	f9e5                	bnez	a1,662 <vprintf+0x152>
        s = va_arg(ap, char*);
 674:	8b4a                	mv	s6,s2
      state = 0;
 676:	4981                	li	s3,0
 678:	bde5                	j	570 <vprintf+0x60>
          s = "(null)";
 67a:	00000997          	auipc	s3,0x0
 67e:	65698993          	addi	s3,s3,1622 # cd0 <close_file+0x5a>
        while(*s != 0){
 682:	85ee                	mv	a1,s11
 684:	bff9                	j	662 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 686:	008b0913          	addi	s2,s6,8
 68a:	000b4583          	lbu	a1,0(s6)
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	db2080e7          	jalr	-590(ra) # 442 <putc>
 698:	8b4a                	mv	s6,s2
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bdd1                	j	570 <vprintf+0x60>
        putc(fd, c);
 69e:	85d2                	mv	a1,s4
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	da0080e7          	jalr	-608(ra) # 442 <putc>
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b5d1                	j	570 <vprintf+0x60>
        putc(fd, '%');
 6ae:	85d2                	mv	a1,s4
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	d90080e7          	jalr	-624(ra) # 442 <putc>
        putc(fd, c);
 6ba:	85ca                	mv	a1,s2
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	d84080e7          	jalr	-636(ra) # 442 <putc>
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b565                	j	570 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ca:	8b4a                	mv	s6,s2
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b54d                	j	570 <vprintf+0x60>
    }
  }
}
 6d0:	70e6                	ld	ra,120(sp)
 6d2:	7446                	ld	s0,112(sp)
 6d4:	74a6                	ld	s1,104(sp)
 6d6:	7906                	ld	s2,96(sp)
 6d8:	69e6                	ld	s3,88(sp)
 6da:	6a46                	ld	s4,80(sp)
 6dc:	6aa6                	ld	s5,72(sp)
 6de:	6b06                	ld	s6,64(sp)
 6e0:	7be2                	ld	s7,56(sp)
 6e2:	7c42                	ld	s8,48(sp)
 6e4:	7ca2                	ld	s9,40(sp)
 6e6:	7d02                	ld	s10,32(sp)
 6e8:	6de2                	ld	s11,24(sp)
 6ea:	6109                	addi	sp,sp,128
 6ec:	8082                	ret

00000000000006ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ee:	715d                	addi	sp,sp,-80
 6f0:	ec06                	sd	ra,24(sp)
 6f2:	e822                	sd	s0,16(sp)
 6f4:	1000                	addi	s0,sp,32
 6f6:	e010                	sd	a2,0(s0)
 6f8:	e414                	sd	a3,8(s0)
 6fa:	e818                	sd	a4,16(s0)
 6fc:	ec1c                	sd	a5,24(s0)
 6fe:	03043023          	sd	a6,32(s0)
 702:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 706:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70a:	8622                	mv	a2,s0
 70c:	00000097          	auipc	ra,0x0
 710:	e04080e7          	jalr	-508(ra) # 510 <vprintf>
}
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6161                	addi	sp,sp,80
 71a:	8082                	ret

000000000000071c <printf>:

void
printf(const char *fmt, ...)
{
 71c:	711d                	addi	sp,sp,-96
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e40c                	sd	a1,8(s0)
 726:	e810                	sd	a2,16(s0)
 728:	ec14                	sd	a3,24(s0)
 72a:	f018                	sd	a4,32(s0)
 72c:	f41c                	sd	a5,40(s0)
 72e:	03043823          	sd	a6,48(s0)
 732:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 736:	00840613          	addi	a2,s0,8
 73a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73e:	85aa                	mv	a1,a0
 740:	4505                	li	a0,1
 742:	00000097          	auipc	ra,0x0
 746:	dce080e7          	jalr	-562(ra) # 510 <vprintf>
}
 74a:	60e2                	ld	ra,24(sp)
 74c:	6442                	ld	s0,16(sp)
 74e:	6125                	addi	sp,sp,96
 750:	8082                	ret

0000000000000752 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 752:	1141                	addi	sp,sp,-16
 754:	e422                	sd	s0,8(sp)
 756:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 758:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75c:	00001797          	auipc	a5,0x1
 760:	8a47b783          	ld	a5,-1884(a5) # 1000 <freep>
 764:	a02d                	j	78e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 766:	4618                	lw	a4,8(a2)
 768:	9f2d                	addw	a4,a4,a1
 76a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 76e:	6398                	ld	a4,0(a5)
 770:	6310                	ld	a2,0(a4)
 772:	a83d                	j	7b0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 774:	ff852703          	lw	a4,-8(a0)
 778:	9f31                	addw	a4,a4,a2
 77a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 77c:	ff053683          	ld	a3,-16(a0)
 780:	a091                	j	7c4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 782:	6398                	ld	a4,0(a5)
 784:	00e7e463          	bltu	a5,a4,78c <free+0x3a>
 788:	00e6ea63          	bltu	a3,a4,79c <free+0x4a>
{
 78c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	fed7fae3          	bgeu	a5,a3,782 <free+0x30>
 792:	6398                	ld	a4,0(a5)
 794:	00e6e463          	bltu	a3,a4,79c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 798:	fee7eae3          	bltu	a5,a4,78c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 79c:	ff852583          	lw	a1,-8(a0)
 7a0:	6390                	ld	a2,0(a5)
 7a2:	02059813          	slli	a6,a1,0x20
 7a6:	01c85713          	srli	a4,a6,0x1c
 7aa:	9736                	add	a4,a4,a3
 7ac:	fae60de3          	beq	a2,a4,766 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7b0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b4:	4790                	lw	a2,8(a5)
 7b6:	02061593          	slli	a1,a2,0x20
 7ba:	01c5d713          	srli	a4,a1,0x1c
 7be:	973e                	add	a4,a4,a5
 7c0:	fae68ae3          	beq	a3,a4,774 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7c4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c6:	00001717          	auipc	a4,0x1
 7ca:	82f73d23          	sd	a5,-1990(a4) # 1000 <freep>
}
 7ce:	6422                	ld	s0,8(sp)
 7d0:	0141                	addi	sp,sp,16
 7d2:	8082                	ret

00000000000007d4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d4:	7139                	addi	sp,sp,-64
 7d6:	fc06                	sd	ra,56(sp)
 7d8:	f822                	sd	s0,48(sp)
 7da:	f426                	sd	s1,40(sp)
 7dc:	f04a                	sd	s2,32(sp)
 7de:	ec4e                	sd	s3,24(sp)
 7e0:	e852                	sd	s4,16(sp)
 7e2:	e456                	sd	s5,8(sp)
 7e4:	e05a                	sd	s6,0(sp)
 7e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e8:	02051493          	slli	s1,a0,0x20
 7ec:	9081                	srli	s1,s1,0x20
 7ee:	04bd                	addi	s1,s1,15
 7f0:	8091                	srli	s1,s1,0x4
 7f2:	0014899b          	addiw	s3,s1,1
 7f6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7f8:	00001517          	auipc	a0,0x1
 7fc:	80853503          	ld	a0,-2040(a0) # 1000 <freep>
 800:	c515                	beqz	a0,82c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 802:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 804:	4798                	lw	a4,8(a5)
 806:	02977f63          	bgeu	a4,s1,844 <malloc+0x70>
 80a:	8a4e                	mv	s4,s3
 80c:	0009871b          	sext.w	a4,s3
 810:	6685                	lui	a3,0x1
 812:	00d77363          	bgeu	a4,a3,818 <malloc+0x44>
 816:	6a05                	lui	s4,0x1
 818:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 81c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 820:	00000917          	auipc	s2,0x0
 824:	7e090913          	addi	s2,s2,2016 # 1000 <freep>
  if(p == (char*)-1)
 828:	5afd                	li	s5,-1
 82a:	a895                	j	89e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 82c:	00000797          	auipc	a5,0x0
 830:	7e478793          	addi	a5,a5,2020 # 1010 <base>
 834:	00000717          	auipc	a4,0x0
 838:	7cf73623          	sd	a5,1996(a4) # 1000 <freep>
 83c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 842:	b7e1                	j	80a <malloc+0x36>
      if(p->s.size == nunits)
 844:	02e48c63          	beq	s1,a4,87c <malloc+0xa8>
        p->s.size -= nunits;
 848:	4137073b          	subw	a4,a4,s3
 84c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 84e:	02071693          	slli	a3,a4,0x20
 852:	01c6d713          	srli	a4,a3,0x1c
 856:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 858:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 85c:	00000717          	auipc	a4,0x0
 860:	7aa73223          	sd	a0,1956(a4) # 1000 <freep>
      return (void*)(p + 1);
 864:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 868:	70e2                	ld	ra,56(sp)
 86a:	7442                	ld	s0,48(sp)
 86c:	74a2                	ld	s1,40(sp)
 86e:	7902                	ld	s2,32(sp)
 870:	69e2                	ld	s3,24(sp)
 872:	6a42                	ld	s4,16(sp)
 874:	6aa2                	ld	s5,8(sp)
 876:	6b02                	ld	s6,0(sp)
 878:	6121                	addi	sp,sp,64
 87a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 87c:	6398                	ld	a4,0(a5)
 87e:	e118                	sd	a4,0(a0)
 880:	bff1                	j	85c <malloc+0x88>
  hp->s.size = nu;
 882:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 886:	0541                	addi	a0,a0,16
 888:	00000097          	auipc	ra,0x0
 88c:	eca080e7          	jalr	-310(ra) # 752 <free>
  return freep;
 890:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 894:	d971                	beqz	a0,868 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 896:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 898:	4798                	lw	a4,8(a5)
 89a:	fa9775e3          	bgeu	a4,s1,844 <malloc+0x70>
    if(p == freep)
 89e:	00093703          	ld	a4,0(s2)
 8a2:	853e                	mv	a0,a5
 8a4:	fef719e3          	bne	a4,a5,896 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8a8:	8552                	mv	a0,s4
 8aa:	00000097          	auipc	ra,0x0
 8ae:	b70080e7          	jalr	-1168(ra) # 41a <sbrk>
  if(p == (char*)-1)
 8b2:	fd5518e3          	bne	a0,s5,882 <malloc+0xae>
        return 0;
 8b6:	4501                	li	a0,0
 8b8:	bf45                	j	868 <malloc+0x94>

00000000000008ba <head_run>:
#include "user/user.h"
#include "gelibs/file.h"

extern int read_line(int fd, char * buffer);

void head_run(int fd, int numOfLines){
 8ba:	dc010113          	addi	sp,sp,-576
 8be:	22113c23          	sd	ra,568(sp)
 8c2:	22813823          	sd	s0,560(sp)
 8c6:	22913423          	sd	s1,552(sp)
 8ca:	23213023          	sd	s2,544(sp)
 8ce:	21313c23          	sd	s3,536(sp)
 8d2:	21413823          	sd	s4,528(sp)
 8d6:	21513423          	sd	s5,520(sp)
 8da:	0480                	addi	s0,sp,576
 8dc:	89aa                	mv	s3,a0
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 8de:	892e                	mv	s2,a1

		readStatus = read_line(fd, line);
		
		if (readStatus == READ_ERROR){
 8e0:	5a7d                	li	s4,-1
			printf("[ERR] Error reading from the file \n");
			break;
		}

		printf("%s",line);
 8e2:	00000a97          	auipc	s5,0x0
 8e6:	48ea8a93          	addi	s5,s5,1166 # d70 <digits+0x40>
	while(numOfLines--){
 8ea:	02090e63          	beqz	s2,926 <head_run+0x6c>
		readStatus = read_line(fd, line);
 8ee:	dc840593          	addi	a1,s0,-568
 8f2:	854e                	mv	a0,s3
 8f4:	00000097          	auipc	ra,0x0
 8f8:	324080e7          	jalr	804(ra) # c18 <read_line>
 8fc:	84aa                	mv	s1,a0
		if (readStatus == READ_ERROR){
 8fe:	01450c63          	beq	a0,s4,916 <head_run+0x5c>
		printf("%s",line);
 902:	dc840593          	addi	a1,s0,-568
 906:	8556                	mv	a0,s5
 908:	00000097          	auipc	ra,0x0
 90c:	e14080e7          	jalr	-492(ra) # 71c <printf>

		if (readStatus == READ_EOF )
 910:	397d                	addiw	s2,s2,-1
 912:	fce1                	bnez	s1,8ea <head_run+0x30>
 914:	a809                	j	926 <head_run+0x6c>
			printf("[ERR] Error reading from the file \n");
 916:	00000517          	auipc	a0,0x0
 91a:	43250513          	addi	a0,a0,1074 # d48 <digits+0x18>
 91e:	00000097          	auipc	ra,0x0
 922:	dfe080e7          	jalr	-514(ra) # 71c <printf>
			break;
	}
}
 926:	23813083          	ld	ra,568(sp)
 92a:	23013403          	ld	s0,560(sp)
 92e:	22813483          	ld	s1,552(sp)
 932:	22013903          	ld	s2,544(sp)
 936:	21813983          	ld	s3,536(sp)
 93a:	21013a03          	ld	s4,528(sp)
 93e:	20813a83          	ld	s5,520(sp)
 942:	24010113          	addi	sp,sp,576
 946:	8082                	ret

0000000000000948 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 948:	ba010113          	addi	sp,sp,-1120
 94c:	44113c23          	sd	ra,1112(sp)
 950:	44813823          	sd	s0,1104(sp)
 954:	44913423          	sd	s1,1096(sp)
 958:	45213023          	sd	s2,1088(sp)
 95c:	43313c23          	sd	s3,1080(sp)
 960:	43413823          	sd	s4,1072(sp)
 964:	43513423          	sd	s5,1064(sp)
 968:	43613023          	sd	s6,1056(sp)
 96c:	41713c23          	sd	s7,1048(sp)
 970:	41813823          	sd	s8,1040(sp)
 974:	41913423          	sd	s9,1032(sp)
 978:	41a13023          	sd	s10,1024(sp)
 97c:	3fb13c23          	sd	s11,1016(sp)
 980:	46010413          	addi	s0,sp,1120
 984:	8aaa                	mv	s5,a0
 986:	8bae                	mv	s7,a1
 988:	8db2                	mv	s11,a2
 98a:	8c36                	mv	s8,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 98c:	d9840593          	addi	a1,s0,-616
 990:	00000097          	auipc	ra,0x0
 994:	288080e7          	jalr	648(ra) # c18 <read_line>

  if (readStatus == READ_ERROR)
 998:	57fd                	li	a5,-1
 99a:	04f50163          	beq	a0,a5,9dc <uniq_run+0x94>
 99e:	4b01                	li	s6,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 9a0:	ed21                	bnez	a0,9f8 <uniq_run+0xb0>





}
 9a2:	45813083          	ld	ra,1112(sp)
 9a6:	45013403          	ld	s0,1104(sp)
 9aa:	44813483          	ld	s1,1096(sp)
 9ae:	44013903          	ld	s2,1088(sp)
 9b2:	43813983          	ld	s3,1080(sp)
 9b6:	43013a03          	ld	s4,1072(sp)
 9ba:	42813a83          	ld	s5,1064(sp)
 9be:	42013b03          	ld	s6,1056(sp)
 9c2:	41813b83          	ld	s7,1048(sp)
 9c6:	41013c03          	ld	s8,1040(sp)
 9ca:	40813c83          	ld	s9,1032(sp)
 9ce:	40013d03          	ld	s10,1024(sp)
 9d2:	3f813d83          	ld	s11,1016(sp)
 9d6:	46010113          	addi	sp,sp,1120
 9da:	8082                	ret
    printf("[ERR] Error reading from the file ");
 9dc:	00000517          	auipc	a0,0x0
 9e0:	39c50513          	addi	a0,a0,924 # d78 <digits+0x48>
 9e4:	00000097          	auipc	ra,0x0
 9e8:	d38080e7          	jalr	-712(ra) # 71c <printf>
 9ec:	bf5d                	j	9a2 <uniq_run+0x5a>
 9ee:	87ca                	mv	a5,s2
 9f0:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 9f2:	84be                	mv	s1,a5
        lineCount = 1;
 9f4:	89ea                	mv	s3,s10
 9f6:	a8fd                	j	af4 <uniq_run+0x1ac>
    int isEof = 0;
 9f8:	4a01                	li	s4,0
    int lineCount=1;
 9fa:	4985                	li	s3,1
  char * line2 = buffer2;
 9fc:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 a00:	d9840913          	addi	s2,s0,-616
      if (readStatus == READ_ERROR){
 a04:	5cfd                	li	s9,-1
        isEof = 1;
 a06:	4d05                	li	s10,1
 a08:	a0f5                	j	af4 <uniq_run+0x1ac>
        printf("[ERR] Error reading from the file");
 a0a:	00000517          	auipc	a0,0x0
 a0e:	39650513          	addi	a0,a0,918 # da0 <digits+0x70>
 a12:	00000097          	auipc	ra,0x0
 a16:	d0a080e7          	jalr	-758(ra) # 71c <printf>
        break;
 a1a:	b761                	j	9a2 <uniq_run+0x5a>
        compareStatus = compare_str_ic(line1, line2);
 a1c:	85a6                	mv	a1,s1
 a1e:	854a                	mv	a0,s2
 a20:	00000097          	auipc	ra,0x0
 a24:	184080e7          	jalr	388(ra) # ba4 <compare_str_ic>
 a28:	a8d5                	j	b1c <uniq_run+0x1d4>
                  printf("%s",line1);
 a2a:	85ca                	mv	a1,s2
 a2c:	00000517          	auipc	a0,0x0
 a30:	34450513          	addi	a0,a0,836 # d70 <digits+0x40>
 a34:	00000097          	auipc	ra,0x0
 a38:	ce8080e7          	jalr	-792(ra) # 71c <printf>
        lineCount = 1;
 a3c:	89da                	mv	s3,s6
                  printf("%s",line1);
 a3e:	87ca                	mv	a5,s2
 a40:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 a42:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a44:	4b01                	li	s6,0
 a46:	a07d                	j	af4 <uniq_run+0x1ac>
            if (showCount){
 a48:	040d8b63          	beqz	s11,a9e <uniq_run+0x156>
              printf("<%d> %s",lineCount,line1);
 a4c:	864a                	mv	a2,s2
 a4e:	85ce                	mv	a1,s3
 a50:	00000517          	auipc	a0,0x0
 a54:	37850513          	addi	a0,a0,888 # dc8 <digits+0x98>
 a58:	00000097          	auipc	ra,0x0
 a5c:	cc4080e7          	jalr	-828(ra) # 71c <printf>
              if (isEof && get_strlen(line2)){
 a60:	000a1863          	bnez	s4,a70 <uniq_run+0x128>
        isRepeated = 0 ;
 a64:	8b52                	mv	s6,s4
 a66:	87ca                	mv	a5,s2
 a68:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 a6a:	84be                	mv	s1,a5
        lineCount = 1;
 a6c:	89ea                	mv	s3,s10
 a6e:	a059                	j	af4 <uniq_run+0x1ac>
              if (isEof && get_strlen(line2)){
 a70:	8526                	mv	a0,s1
 a72:	00000097          	auipc	ra,0x0
 a76:	0d8080e7          	jalr	216(ra) # b4a <get_strlen>
 a7a:	8b2a                	mv	s6,a0
 a7c:	e511                	bnez	a0,a88 <uniq_run+0x140>
        lineCount = 1;
 a7e:	89d2                	mv	s3,s4
 a80:	87ca                	mv	a5,s2
 a82:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 a84:	84be                	mv	s1,a5
 a86:	a0bd                	j	af4 <uniq_run+0x1ac>
                printf("<%d> %s",lineCount,line2); 
 a88:	8626                	mv	a2,s1
 a8a:	85ce                	mv	a1,s3
 a8c:	00000517          	auipc	a0,0x0
 a90:	33c50513          	addi	a0,a0,828 # dc8 <digits+0x98>
 a94:	00000097          	auipc	ra,0x0
 a98:	c88080e7          	jalr	-888(ra) # 71c <printf>
                break;
 a9c:	b719                	j	9a2 <uniq_run+0x5a>
              printf("%s",line1);
 a9e:	85ca                	mv	a1,s2
 aa0:	00000517          	auipc	a0,0x0
 aa4:	2d050513          	addi	a0,a0,720 # d70 <digits+0x40>
 aa8:	00000097          	auipc	ra,0x0
 aac:	c74080e7          	jalr	-908(ra) # 71c <printf>
              if (isEof && get_strlen(line2)){
 ab0:	000a1863          	bnez	s4,ac0 <uniq_run+0x178>
        isRepeated = 0 ;
 ab4:	8b52                	mv	s6,s4
 ab6:	87ca                	mv	a5,s2
 ab8:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 aba:	84be                	mv	s1,a5
        lineCount = 1;
 abc:	89ea                	mv	s3,s10
 abe:	a81d                	j	af4 <uniq_run+0x1ac>
              if (isEof && get_strlen(line2)){
 ac0:	8526                	mv	a0,s1
 ac2:	00000097          	auipc	ra,0x0
 ac6:	088080e7          	jalr	136(ra) # b4a <get_strlen>
 aca:	8b2a                	mv	s6,a0
 acc:	e511                	bnez	a0,ad8 <uniq_run+0x190>
        lineCount = 1;
 ace:	89d2                	mv	s3,s4
 ad0:	87ca                	mv	a5,s2
 ad2:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 ad4:	84be                	mv	s1,a5
 ad6:	a839                	j	af4 <uniq_run+0x1ac>
                printf("%s",line2);
 ad8:	85a6                	mv	a1,s1
 ada:	00000517          	auipc	a0,0x0
 ade:	29650513          	addi	a0,a0,662 # d70 <digits+0x40>
 ae2:	00000097          	auipc	ra,0x0
 ae6:	c3a080e7          	jalr	-966(ra) # 71c <printf>
                break;
 aea:	bd65                	j	9a2 <uniq_run+0x5a>
          if (repeatedLines && !isRepeated){
 aec:	000c0363          	beqz	s8,af2 <uniq_run+0x1aa>
 af0:	8b6a                	mv	s6,s10
          lineCount++;
 af2:	2985                	addiw	s3,s3,1
      readStatus = read_line(fd, line2);
 af4:	85a6                	mv	a1,s1
 af6:	8556                	mv	a0,s5
 af8:	00000097          	auipc	ra,0x0
 afc:	120080e7          	jalr	288(ra) # c18 <read_line>
      if (readStatus == READ_ERROR){
 b00:	f19505e3          	beq	a0,s9,a0a <uniq_run+0xc2>
      if (readStatus == READ_EOF){
 b04:	e501                	bnez	a0,b0c <uniq_run+0x1c4>
        if (isEof)
 b06:	e80a1ee3          	bnez	s4,9a2 <uniq_run+0x5a>
        isEof = 1;
 b0a:	8a6a                	mv	s4,s10
      if (!ignoreCase)
 b0c:	f00b98e3          	bnez	s7,a1c <uniq_run+0xd4>
        compareStatus = compare_str(line1, line2);
 b10:	85a6                	mv	a1,s1
 b12:	854a                	mv	a0,s2
 b14:	00000097          	auipc	ra,0x0
 b18:	062080e7          	jalr	98(ra) # b76 <compare_str>
      if (compareStatus != 0){ // Not equal
 b1c:	d961                	beqz	a0,aec <uniq_run+0x1a4>
          if (repeatedLines){
 b1e:	f20c05e3          	beqz	s8,a48 <uniq_run+0x100>
            if (isRepeated){
 b22:	ec0b06e3          	beqz	s6,9ee <uniq_run+0xa6>
                if (showCount)
 b26:	f00d82e3          	beqz	s11,a2a <uniq_run+0xe2>
                  printf("<%d> %s",lineCount,line1);
 b2a:	864a                	mv	a2,s2
 b2c:	85ce                	mv	a1,s3
 b2e:	00000517          	auipc	a0,0x0
 b32:	29a50513          	addi	a0,a0,666 # dc8 <digits+0x98>
 b36:	00000097          	auipc	ra,0x0
 b3a:	be6080e7          	jalr	-1050(ra) # 71c <printf>
        lineCount = 1;
 b3e:	89da                	mv	s3,s6
 b40:	87ca                	mv	a5,s2
 b42:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 b44:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b46:	4b01                	li	s6,0
 b48:	b775                	j	af4 <uniq_run+0x1ac>

0000000000000b4a <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 b4a:	1141                	addi	sp,sp,-16
 b4c:	e422                	sd	s0,8(sp)
 b4e:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 b50:	00054783          	lbu	a5,0(a0)
 b54:	cf99                	beqz	a5,b72 <get_strlen+0x28>
 b56:	00150713          	addi	a4,a0,1
 b5a:	87ba                	mv	a5,a4
 b5c:	4685                	li	a3,1
 b5e:	9e99                	subw	a3,a3,a4
 b60:	00f6853b          	addw	a0,a3,a5
 b64:	0785                	addi	a5,a5,1
 b66:	fff7c703          	lbu	a4,-1(a5)
 b6a:	fb7d                	bnez	a4,b60 <get_strlen+0x16>
	return len;
}
 b6c:	6422                	ld	s0,8(sp)
 b6e:	0141                	addi	sp,sp,16
 b70:	8082                	ret
	int len = 0;
 b72:	4501                	li	a0,0
 b74:	bfe5                	j	b6c <get_strlen+0x22>

0000000000000b76 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 b76:	1141                	addi	sp,sp,-16
 b78:	e422                	sd	s0,8(sp)
 b7a:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 b7c:	00054783          	lbu	a5,0(a0)
 b80:	cb91                	beqz	a5,b94 <compare_str+0x1e>
 b82:	0005c703          	lbu	a4,0(a1)
 b86:	c719                	beqz	a4,b94 <compare_str+0x1e>
		if (*s1++ != *s2++)
 b88:	0505                	addi	a0,a0,1
 b8a:	0585                	addi	a1,a1,1
 b8c:	fee788e3          	beq	a5,a4,b7c <compare_str+0x6>
			return 1;
 b90:	4505                	li	a0,1
 b92:	a031                	j	b9e <compare_str+0x28>
	}
	if (*s1 == *s2)
 b94:	0005c503          	lbu	a0,0(a1)
 b98:	8d1d                	sub	a0,a0,a5
			return 1;
 b9a:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b9e:	6422                	ld	s0,8(sp)
 ba0:	0141                	addi	sp,sp,16
 ba2:	8082                	ret

0000000000000ba4 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 ba4:	1141                	addi	sp,sp,-16
 ba6:	e422                	sd	s0,8(sp)
 ba8:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 baa:	4665                	li	a2,25
	while(*s1 && *s2){
 bac:	a019                	j	bb2 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 bae:	04e79763          	bne	a5,a4,bfc <compare_str_ic+0x58>
	while(*s1 && *s2){
 bb2:	00054783          	lbu	a5,0(a0)
 bb6:	cb9d                	beqz	a5,bec <compare_str_ic+0x48>
 bb8:	0005c703          	lbu	a4,0(a1)
 bbc:	cb05                	beqz	a4,bec <compare_str_ic+0x48>
		char b1 = *s1++;
 bbe:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 bc0:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 bc2:	fbf7869b          	addiw	a3,a5,-65
 bc6:	0ff6f693          	zext.b	a3,a3
 bca:	00d66663          	bltu	a2,a3,bd6 <compare_str_ic+0x32>
			b1 += 32;
 bce:	0207879b          	addiw	a5,a5,32
 bd2:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 bd6:	fbf7069b          	addiw	a3,a4,-65
 bda:	0ff6f693          	zext.b	a3,a3
 bde:	fcd668e3          	bltu	a2,a3,bae <compare_str_ic+0xa>
			b2 += 32;
 be2:	0207071b          	addiw	a4,a4,32
 be6:	0ff77713          	zext.b	a4,a4
 bea:	b7d1                	j	bae <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 bec:	0005c503          	lbu	a0,0(a1)
 bf0:	8d1d                	sub	a0,a0,a5
			return 1;
 bf2:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 bf6:	6422                	ld	s0,8(sp)
 bf8:	0141                	addi	sp,sp,16
 bfa:	8082                	ret
			return 1;
 bfc:	4505                	li	a0,1
 bfe:	bfe5                	j	bf6 <compare_str_ic+0x52>

0000000000000c00 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 c00:	1141                	addi	sp,sp,-16
 c02:	e406                	sd	ra,8(sp)
 c04:	e022                	sd	s0,0(sp)
 c06:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 c08:	fffff097          	auipc	ra,0xfffff
 c0c:	7ca080e7          	jalr	1994(ra) # 3d2 <open>
	return fd;
}
 c10:	60a2                	ld	ra,8(sp)
 c12:	6402                	ld	s0,0(sp)
 c14:	0141                	addi	sp,sp,16
 c16:	8082                	ret

0000000000000c18 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 c18:	7139                	addi	sp,sp,-64
 c1a:	fc06                	sd	ra,56(sp)
 c1c:	f822                	sd	s0,48(sp)
 c1e:	f426                	sd	s1,40(sp)
 c20:	f04a                	sd	s2,32(sp)
 c22:	ec4e                	sd	s3,24(sp)
 c24:	e852                	sd	s4,16(sp)
 c26:	0080                	addi	s0,sp,64
 c28:	89aa                	mv	s3,a0
 c2a:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c2c:	4901                	li	s2,0
			return byteCount; 
		}
		*buffer++ = readByte;
		byteCount++;

		if (readByte == '\n'){
 c2e:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c30:	4605                	li	a2,1
 c32:	fcf40593          	addi	a1,s0,-49
 c36:	854e                	mv	a0,s3
 c38:	fffff097          	auipc	ra,0xfffff
 c3c:	772080e7          	jalr	1906(ra) # 3aa <read>
		if (readStatus <= 0){
 c40:	02a05563          	blez	a0,c6a <read_line+0x52>
		*buffer++ = readByte;
 c44:	0485                	addi	s1,s1,1
 c46:	fcf44783          	lbu	a5,-49(s0)
 c4a:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c4e:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c50:	ff4790e3          	bne	a5,s4,c30 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c54:	00048023          	sb	zero,0(s1)
		byteCount++;
 c58:	854a                	mv	a0,s2
			return byteCount;
		}
	}
}
 c5a:	70e2                	ld	ra,56(sp)
 c5c:	7442                	ld	s0,48(sp)
 c5e:	74a2                	ld	s1,40(sp)
 c60:	7902                	ld	s2,32(sp)
 c62:	69e2                	ld	s3,24(sp)
 c64:	6a42                	ld	s4,16(sp)
 c66:	6121                	addi	sp,sp,64
 c68:	8082                	ret
			*buffer = 0;  // Nullifying the end of the string
 c6a:	00048023          	sb	zero,0(s1)
			if (byteCount == 0)
 c6e:	fe0906e3          	beqz	s2,c5a <read_line+0x42>
 c72:	854a                	mv	a0,s2
 c74:	b7dd                	j	c5a <read_line+0x42>

0000000000000c76 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c76:	1141                	addi	sp,sp,-16
 c78:	e406                	sd	ra,8(sp)
 c7a:	e022                	sd	s0,0(sp)
 c7c:	0800                	addi	s0,sp,16
	close(fd);
 c7e:	fffff097          	auipc	ra,0xfffff
 c82:	73c080e7          	jalr	1852(ra) # 3ba <close>
}
 c86:	60a2                	ld	ra,8(sp)
 c88:	6402                	ld	s0,0(sp)
 c8a:	0141                	addi	sp,sp,16
 c8c:	8082                	ret
