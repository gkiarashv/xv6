
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	02091793          	slli	a5,s2,0x20
  20:	01d7d913          	srli	s2,a5,0x1d
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	33c080e7          	jalr	828(ra) # 366 <mkdir>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
    fprintf(2, "Usage: mkdir files...\n");
  3e:	00001597          	auipc	a1,0x1
  42:	cc258593          	addi	a1,a1,-830 # d00 <get_time_perf+0x66>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	642080e7          	jalr	1602(ra) # 68a <fprintf>
    exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	2ac080e7          	jalr	684(ra) # 2fe <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00001597          	auipc	a1,0x1
  60:	cbc58593          	addi	a1,a1,-836 # d18 <get_time_perf+0x7e>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	624080e7          	jalr	1572(ra) # 68a <fprintf>
      break;
    }
  }

  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	28e080e7          	jalr	654(ra) # 2fe <exit>

0000000000000078 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  80:	00000097          	auipc	ra,0x0
  84:	f80080e7          	jalr	-128(ra) # 0 <main>
  exit(0);
  88:	4501                	li	a0,0
  8a:	00000097          	auipc	ra,0x0
  8e:	274080e7          	jalr	628(ra) # 2fe <exit>

0000000000000092 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  98:	87aa                	mv	a5,a0
  9a:	0585                	addi	a1,a1,1
  9c:	0785                	addi	a5,a5,1
  9e:	fff5c703          	lbu	a4,-1(a1)
  a2:	fee78fa3          	sb	a4,-1(a5)
  a6:	fb75                	bnez	a4,9a <strcpy+0x8>
    ;
  return os;
}
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cb91                	beqz	a5,cc <strcmp+0x1e>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71763          	bne	a4,a5,cc <strcmp+0x1e>
    p++, q++;
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbe5                	bnez	a5,ba <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  cc:	0005c503          	lbu	a0,0(a1)
}
  d0:	40a7853b          	subw	a0,a5,a0
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strlen>:

uint
strlen(const char *s)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cf91                	beqz	a5,100 <strlen+0x26>
  e6:	0505                	addi	a0,a0,1
  e8:	87aa                	mv	a5,a0
  ea:	4685                	li	a3,1
  ec:	9e89                	subw	a3,a3,a0
  ee:	00f6853b          	addw	a0,a3,a5
  f2:	0785                	addi	a5,a5,1
  f4:	fff7c703          	lbu	a4,-1(a5)
  f8:	fb7d                	bnez	a4,ee <strlen+0x14>
    ;
  return n;
}
  fa:	6422                	ld	s0,8(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret
  for(n = 0; s[n]; n++)
 100:	4501                	li	a0,0
 102:	bfe5                	j	fa <strlen+0x20>

0000000000000104 <memset>:

void*
memset(void *dst, int c, uint n)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10a:	ca19                	beqz	a2,120 <memset+0x1c>
 10c:	87aa                	mv	a5,a0
 10e:	1602                	slli	a2,a2,0x20
 110:	9201                	srli	a2,a2,0x20
 112:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 116:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11a:	0785                	addi	a5,a5,1
 11c:	fee79de3          	bne	a5,a4,116 <memset+0x12>
  }
  return dst;
}
 120:	6422                	ld	s0,8(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strchr>:

char*
strchr(const char *s, char c)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12c:	00054783          	lbu	a5,0(a0)
 130:	cb99                	beqz	a5,146 <strchr+0x20>
    if(*s == c)
 132:	00f58763          	beq	a1,a5,140 <strchr+0x1a>
  for(; *s; s++)
 136:	0505                	addi	a0,a0,1
 138:	00054783          	lbu	a5,0(a0)
 13c:	fbfd                	bnez	a5,132 <strchr+0xc>
      return (char*)s;
  return 0;
 13e:	4501                	li	a0,0
}
 140:	6422                	ld	s0,8(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
  return 0;
 146:	4501                	li	a0,0
 148:	bfe5                	j	140 <strchr+0x1a>

000000000000014a <gets>:

char*
gets(char *buf, int max)
{
 14a:	711d                	addi	sp,sp,-96
 14c:	ec86                	sd	ra,88(sp)
 14e:	e8a2                	sd	s0,80(sp)
 150:	e4a6                	sd	s1,72(sp)
 152:	e0ca                	sd	s2,64(sp)
 154:	fc4e                	sd	s3,56(sp)
 156:	f852                	sd	s4,48(sp)
 158:	f456                	sd	s5,40(sp)
 15a:	f05a                	sd	s6,32(sp)
 15c:	ec5e                	sd	s7,24(sp)
 15e:	1080                	addi	s0,sp,96
 160:	8baa                	mv	s7,a0
 162:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 164:	892a                	mv	s2,a0
 166:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 168:	4aa9                	li	s5,10
 16a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 16c:	89a6                	mv	s3,s1
 16e:	2485                	addiw	s1,s1,1
 170:	0344d863          	bge	s1,s4,1a0 <gets+0x56>
    cc = read(0, &c, 1);
 174:	4605                	li	a2,1
 176:	faf40593          	addi	a1,s0,-81
 17a:	4501                	li	a0,0
 17c:	00000097          	auipc	ra,0x0
 180:	19a080e7          	jalr	410(ra) # 316 <read>
    if(cc < 1)
 184:	00a05e63          	blez	a0,1a0 <gets+0x56>
    buf[i++] = c;
 188:	faf44783          	lbu	a5,-81(s0)
 18c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 190:	01578763          	beq	a5,s5,19e <gets+0x54>
 194:	0905                	addi	s2,s2,1
 196:	fd679be3          	bne	a5,s6,16c <gets+0x22>
  for(i=0; i+1 < max; ){
 19a:	89a6                	mv	s3,s1
 19c:	a011                	j	1a0 <gets+0x56>
 19e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a0:	99de                	add	s3,s3,s7
 1a2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a6:	855e                	mv	a0,s7
 1a8:	60e6                	ld	ra,88(sp)
 1aa:	6446                	ld	s0,80(sp)
 1ac:	64a6                	ld	s1,72(sp)
 1ae:	6906                	ld	s2,64(sp)
 1b0:	79e2                	ld	s3,56(sp)
 1b2:	7a42                	ld	s4,48(sp)
 1b4:	7aa2                	ld	s5,40(sp)
 1b6:	7b02                	ld	s6,32(sp)
 1b8:	6be2                	ld	s7,24(sp)
 1ba:	6125                	addi	sp,sp,96
 1bc:	8082                	ret

00000000000001be <stat>:

int
stat(const char *n, struct stat *st)
{
 1be:	1101                	addi	sp,sp,-32
 1c0:	ec06                	sd	ra,24(sp)
 1c2:	e822                	sd	s0,16(sp)
 1c4:	e426                	sd	s1,8(sp)
 1c6:	e04a                	sd	s2,0(sp)
 1c8:	1000                	addi	s0,sp,32
 1ca:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cc:	4581                	li	a1,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	170080e7          	jalr	368(ra) # 33e <open>
  if(fd < 0)
 1d6:	02054563          	bltz	a0,200 <stat+0x42>
 1da:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1dc:	85ca                	mv	a1,s2
 1de:	00000097          	auipc	ra,0x0
 1e2:	178080e7          	jalr	376(ra) # 356 <fstat>
 1e6:	892a                	mv	s2,a0
  close(fd);
 1e8:	8526                	mv	a0,s1
 1ea:	00000097          	auipc	ra,0x0
 1ee:	13c080e7          	jalr	316(ra) # 326 <close>
  return r;
}
 1f2:	854a                	mv	a0,s2
 1f4:	60e2                	ld	ra,24(sp)
 1f6:	6442                	ld	s0,16(sp)
 1f8:	64a2                	ld	s1,8(sp)
 1fa:	6902                	ld	s2,0(sp)
 1fc:	6105                	addi	sp,sp,32
 1fe:	8082                	ret
    return -1;
 200:	597d                	li	s2,-1
 202:	bfc5                	j	1f2 <stat+0x34>

0000000000000204 <atoi>:

int
atoi(const char *s)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20a:	00054683          	lbu	a3,0(a0)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	4625                	li	a2,9
 218:	02f66863          	bltu	a2,a5,248 <atoi+0x44>
 21c:	872a                	mv	a4,a0
  n = 0;
 21e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 220:	0705                	addi	a4,a4,1
 222:	0025179b          	slliw	a5,a0,0x2
 226:	9fa9                	addw	a5,a5,a0
 228:	0017979b          	slliw	a5,a5,0x1
 22c:	9fb5                	addw	a5,a5,a3
 22e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 232:	00074683          	lbu	a3,0(a4)
 236:	fd06879b          	addiw	a5,a3,-48
 23a:	0ff7f793          	zext.b	a5,a5
 23e:	fef671e3          	bgeu	a2,a5,220 <atoi+0x1c>
  return n;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
  n = 0;
 248:	4501                	li	a0,0
 24a:	bfe5                	j	242 <atoi+0x3e>

000000000000024c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 252:	02b57463          	bgeu	a0,a1,27a <memmove+0x2e>
    while(n-- > 0)
 256:	00c05f63          	blez	a2,274 <memmove+0x28>
 25a:	1602                	slli	a2,a2,0x20
 25c:	9201                	srli	a2,a2,0x20
 25e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 262:	872a                	mv	a4,a0
      *dst++ = *src++;
 264:	0585                	addi	a1,a1,1
 266:	0705                	addi	a4,a4,1
 268:	fff5c683          	lbu	a3,-1(a1)
 26c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 270:	fee79ae3          	bne	a5,a4,264 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
    dst += n;
 27a:	00c50733          	add	a4,a0,a2
    src += n;
 27e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 280:	fec05ae3          	blez	a2,274 <memmove+0x28>
 284:	fff6079b          	addiw	a5,a2,-1
 288:	1782                	slli	a5,a5,0x20
 28a:	9381                	srli	a5,a5,0x20
 28c:	fff7c793          	not	a5,a5
 290:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 292:	15fd                	addi	a1,a1,-1
 294:	177d                	addi	a4,a4,-1
 296:	0005c683          	lbu	a3,0(a1)
 29a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 29e:	fee79ae3          	bne	a5,a4,292 <memmove+0x46>
 2a2:	bfc9                	j	274 <memmove+0x28>

00000000000002a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2aa:	ca05                	beqz	a2,2da <memcmp+0x36>
 2ac:	fff6069b          	addiw	a3,a2,-1
 2b0:	1682                	slli	a3,a3,0x20
 2b2:	9281                	srli	a3,a3,0x20
 2b4:	0685                	addi	a3,a3,1
 2b6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	0005c703          	lbu	a4,0(a1)
 2c0:	00e79863          	bne	a5,a4,2d0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c4:	0505                	addi	a0,a0,1
    p2++;
 2c6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c8:	fed518e3          	bne	a0,a3,2b8 <memcmp+0x14>
  }
  return 0;
 2cc:	4501                	li	a0,0
 2ce:	a019                	j	2d4 <memcmp+0x30>
      return *p1 - *p2;
 2d0:	40e7853b          	subw	a0,a5,a4
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  return 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <memcmp+0x30>

00000000000002de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e6:	00000097          	auipc	ra,0x0
 2ea:	f66080e7          	jalr	-154(ra) # 24c <memmove>
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f6:	4885                	li	a7,1
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 2fe:	4889                	li	a7,2
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <wait>:
.global wait
wait:
 li a7, SYS_wait
 306:	488d                	li	a7,3
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 30e:	4891                	li	a7,4
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <read>:
.global read
read:
 li a7, SYS_read
 316:	4895                	li	a7,5
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <write>:
.global write
write:
 li a7, SYS_write
 31e:	48c1                	li	a7,16
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <close>:
.global close
close:
 li a7, SYS_close
 326:	48d5                	li	a7,21
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <kill>:
.global kill
kill:
 li a7, SYS_kill
 32e:	4899                	li	a7,6
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <exec>:
.global exec
exec:
 li a7, SYS_exec
 336:	489d                	li	a7,7
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <open>:
.global open
open:
 li a7, SYS_open
 33e:	48bd                	li	a7,15
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 346:	48c5                	li	a7,17
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 34e:	48c9                	li	a7,18
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 356:	48a1                	li	a7,8
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <link>:
.global link
link:
 li a7, SYS_link
 35e:	48cd                	li	a7,19
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 366:	48d1                	li	a7,20
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 36e:	48a5                	li	a7,9
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <dup>:
.global dup
dup:
 li a7, SYS_dup
 376:	48a9                	li	a7,10
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 37e:	48ad                	li	a7,11
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 386:	48b1                	li	a7,12
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 38e:	48b5                	li	a7,13
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 396:	48b9                	li	a7,14
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <head>:
.global head
head:
 li a7, SYS_head
 39e:	48d9                	li	a7,22
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 3a6:	48dd                	li	a7,23
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <ps>:
.global ps
ps:
 li a7, SYS_ps
 3ae:	48e1                	li	a7,24
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <times>:
.global times
times:
 li a7, SYS_times
 3b6:	48e5                	li	a7,25
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 3be:	48e9                	li	a7,26
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 3c6:	48ed                	li	a7,27
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 3ce:	48f1                	li	a7,28
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 3d6:	48f5                	li	a7,29
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3de:	1101                	addi	sp,sp,-32
 3e0:	ec06                	sd	ra,24(sp)
 3e2:	e822                	sd	s0,16(sp)
 3e4:	1000                	addi	s0,sp,32
 3e6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ea:	4605                	li	a2,1
 3ec:	fef40593          	addi	a1,s0,-17
 3f0:	00000097          	auipc	ra,0x0
 3f4:	f2e080e7          	jalr	-210(ra) # 31e <write>
}
 3f8:	60e2                	ld	ra,24(sp)
 3fa:	6442                	ld	s0,16(sp)
 3fc:	6105                	addi	sp,sp,32
 3fe:	8082                	ret

0000000000000400 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 400:	7139                	addi	sp,sp,-64
 402:	fc06                	sd	ra,56(sp)
 404:	f822                	sd	s0,48(sp)
 406:	f426                	sd	s1,40(sp)
 408:	f04a                	sd	s2,32(sp)
 40a:	ec4e                	sd	s3,24(sp)
 40c:	0080                	addi	s0,sp,64
 40e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 410:	c299                	beqz	a3,416 <printint+0x16>
 412:	0805c963          	bltz	a1,4a4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 416:	2581                	sext.w	a1,a1
  neg = 0;
 418:	4881                	li	a7,0
 41a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 41e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 420:	2601                	sext.w	a2,a2
 422:	00001517          	auipc	a0,0x1
 426:	97650513          	addi	a0,a0,-1674 # d98 <digits>
 42a:	883a                	mv	a6,a4
 42c:	2705                	addiw	a4,a4,1
 42e:	02c5f7bb          	remuw	a5,a1,a2
 432:	1782                	slli	a5,a5,0x20
 434:	9381                	srli	a5,a5,0x20
 436:	97aa                	add	a5,a5,a0
 438:	0007c783          	lbu	a5,0(a5)
 43c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 440:	0005879b          	sext.w	a5,a1
 444:	02c5d5bb          	divuw	a1,a1,a2
 448:	0685                	addi	a3,a3,1
 44a:	fec7f0e3          	bgeu	a5,a2,42a <printint+0x2a>
  if(neg)
 44e:	00088c63          	beqz	a7,466 <printint+0x66>
    buf[i++] = '-';
 452:	fd070793          	addi	a5,a4,-48
 456:	00878733          	add	a4,a5,s0
 45a:	02d00793          	li	a5,45
 45e:	fef70823          	sb	a5,-16(a4)
 462:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 466:	02e05863          	blez	a4,496 <printint+0x96>
 46a:	fc040793          	addi	a5,s0,-64
 46e:	00e78933          	add	s2,a5,a4
 472:	fff78993          	addi	s3,a5,-1
 476:	99ba                	add	s3,s3,a4
 478:	377d                	addiw	a4,a4,-1
 47a:	1702                	slli	a4,a4,0x20
 47c:	9301                	srli	a4,a4,0x20
 47e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 482:	fff94583          	lbu	a1,-1(s2)
 486:	8526                	mv	a0,s1
 488:	00000097          	auipc	ra,0x0
 48c:	f56080e7          	jalr	-170(ra) # 3de <putc>
  while(--i >= 0)
 490:	197d                	addi	s2,s2,-1
 492:	ff3918e3          	bne	s2,s3,482 <printint+0x82>
}
 496:	70e2                	ld	ra,56(sp)
 498:	7442                	ld	s0,48(sp)
 49a:	74a2                	ld	s1,40(sp)
 49c:	7902                	ld	s2,32(sp)
 49e:	69e2                	ld	s3,24(sp)
 4a0:	6121                	addi	sp,sp,64
 4a2:	8082                	ret
    x = -xx;
 4a4:	40b005bb          	negw	a1,a1
    neg = 1;
 4a8:	4885                	li	a7,1
    x = -xx;
 4aa:	bf85                	j	41a <printint+0x1a>

00000000000004ac <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ac:	7119                	addi	sp,sp,-128
 4ae:	fc86                	sd	ra,120(sp)
 4b0:	f8a2                	sd	s0,112(sp)
 4b2:	f4a6                	sd	s1,104(sp)
 4b4:	f0ca                	sd	s2,96(sp)
 4b6:	ecce                	sd	s3,88(sp)
 4b8:	e8d2                	sd	s4,80(sp)
 4ba:	e4d6                	sd	s5,72(sp)
 4bc:	e0da                	sd	s6,64(sp)
 4be:	fc5e                	sd	s7,56(sp)
 4c0:	f862                	sd	s8,48(sp)
 4c2:	f466                	sd	s9,40(sp)
 4c4:	f06a                	sd	s10,32(sp)
 4c6:	ec6e                	sd	s11,24(sp)
 4c8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ca:	0005c903          	lbu	s2,0(a1)
 4ce:	18090f63          	beqz	s2,66c <vprintf+0x1c0>
 4d2:	8aaa                	mv	s5,a0
 4d4:	8b32                	mv	s6,a2
 4d6:	00158493          	addi	s1,a1,1
  state = 0;
 4da:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4dc:	02500a13          	li	s4,37
 4e0:	4c55                	li	s8,21
 4e2:	00001c97          	auipc	s9,0x1
 4e6:	85ec8c93          	addi	s9,s9,-1954 # d40 <get_time_perf+0xa6>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4ea:	02800d93          	li	s11,40
  putc(fd, 'x');
 4ee:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4f0:	00001b97          	auipc	s7,0x1
 4f4:	8a8b8b93          	addi	s7,s7,-1880 # d98 <digits>
 4f8:	a839                	j	516 <vprintf+0x6a>
        putc(fd, c);
 4fa:	85ca                	mv	a1,s2
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	ee0080e7          	jalr	-288(ra) # 3de <putc>
 506:	a019                	j	50c <vprintf+0x60>
    } else if(state == '%'){
 508:	01498d63          	beq	s3,s4,522 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 50c:	0485                	addi	s1,s1,1
 50e:	fff4c903          	lbu	s2,-1(s1)
 512:	14090d63          	beqz	s2,66c <vprintf+0x1c0>
    if(state == 0){
 516:	fe0999e3          	bnez	s3,508 <vprintf+0x5c>
      if(c == '%'){
 51a:	ff4910e3          	bne	s2,s4,4fa <vprintf+0x4e>
        state = '%';
 51e:	89d2                	mv	s3,s4
 520:	b7f5                	j	50c <vprintf+0x60>
      if(c == 'd'){
 522:	11490c63          	beq	s2,s4,63a <vprintf+0x18e>
 526:	f9d9079b          	addiw	a5,s2,-99
 52a:	0ff7f793          	zext.b	a5,a5
 52e:	10fc6e63          	bltu	s8,a5,64a <vprintf+0x19e>
 532:	f9d9079b          	addiw	a5,s2,-99
 536:	0ff7f713          	zext.b	a4,a5
 53a:	10ec6863          	bltu	s8,a4,64a <vprintf+0x19e>
 53e:	00271793          	slli	a5,a4,0x2
 542:	97e6                	add	a5,a5,s9
 544:	439c                	lw	a5,0(a5)
 546:	97e6                	add	a5,a5,s9
 548:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 54a:	008b0913          	addi	s2,s6,8
 54e:	4685                	li	a3,1
 550:	4629                	li	a2,10
 552:	000b2583          	lw	a1,0(s6)
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	ea8080e7          	jalr	-344(ra) # 400 <printint>
 560:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 562:	4981                	li	s3,0
 564:	b765                	j	50c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 566:	008b0913          	addi	s2,s6,8
 56a:	4681                	li	a3,0
 56c:	4629                	li	a2,10
 56e:	000b2583          	lw	a1,0(s6)
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	e8c080e7          	jalr	-372(ra) # 400 <printint>
 57c:	8b4a                	mv	s6,s2
      state = 0;
 57e:	4981                	li	s3,0
 580:	b771                	j	50c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 582:	008b0913          	addi	s2,s6,8
 586:	4681                	li	a3,0
 588:	866a                	mv	a2,s10
 58a:	000b2583          	lw	a1,0(s6)
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	e70080e7          	jalr	-400(ra) # 400 <printint>
 598:	8b4a                	mv	s6,s2
      state = 0;
 59a:	4981                	li	s3,0
 59c:	bf85                	j	50c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 59e:	008b0793          	addi	a5,s6,8
 5a2:	f8f43423          	sd	a5,-120(s0)
 5a6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5aa:	03000593          	li	a1,48
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e2e080e7          	jalr	-466(ra) # 3de <putc>
  putc(fd, 'x');
 5b8:	07800593          	li	a1,120
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e20080e7          	jalr	-480(ra) # 3de <putc>
 5c6:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c8:	03c9d793          	srli	a5,s3,0x3c
 5cc:	97de                	add	a5,a5,s7
 5ce:	0007c583          	lbu	a1,0(a5)
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	e0a080e7          	jalr	-502(ra) # 3de <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5dc:	0992                	slli	s3,s3,0x4
 5de:	397d                	addiw	s2,s2,-1
 5e0:	fe0914e3          	bnez	s2,5c8 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5e4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	b70d                	j	50c <vprintf+0x60>
        s = va_arg(ap, char*);
 5ec:	008b0913          	addi	s2,s6,8
 5f0:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5f4:	02098163          	beqz	s3,616 <vprintf+0x16a>
        while(*s != 0){
 5f8:	0009c583          	lbu	a1,0(s3)
 5fc:	c5ad                	beqz	a1,666 <vprintf+0x1ba>
          putc(fd, *s);
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	dde080e7          	jalr	-546(ra) # 3de <putc>
          s++;
 608:	0985                	addi	s3,s3,1
        while(*s != 0){
 60a:	0009c583          	lbu	a1,0(s3)
 60e:	f9e5                	bnez	a1,5fe <vprintf+0x152>
        s = va_arg(ap, char*);
 610:	8b4a                	mv	s6,s2
      state = 0;
 612:	4981                	li	s3,0
 614:	bde5                	j	50c <vprintf+0x60>
          s = "(null)";
 616:	00000997          	auipc	s3,0x0
 61a:	72298993          	addi	s3,s3,1826 # d38 <get_time_perf+0x9e>
        while(*s != 0){
 61e:	85ee                	mv	a1,s11
 620:	bff9                	j	5fe <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 622:	008b0913          	addi	s2,s6,8
 626:	000b4583          	lbu	a1,0(s6)
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	db2080e7          	jalr	-590(ra) # 3de <putc>
 634:	8b4a                	mv	s6,s2
      state = 0;
 636:	4981                	li	s3,0
 638:	bdd1                	j	50c <vprintf+0x60>
        putc(fd, c);
 63a:	85d2                	mv	a1,s4
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	da0080e7          	jalr	-608(ra) # 3de <putc>
      state = 0;
 646:	4981                	li	s3,0
 648:	b5d1                	j	50c <vprintf+0x60>
        putc(fd, '%');
 64a:	85d2                	mv	a1,s4
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	d90080e7          	jalr	-624(ra) # 3de <putc>
        putc(fd, c);
 656:	85ca                	mv	a1,s2
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	d84080e7          	jalr	-636(ra) # 3de <putc>
      state = 0;
 662:	4981                	li	s3,0
 664:	b565                	j	50c <vprintf+0x60>
        s = va_arg(ap, char*);
 666:	8b4a                	mv	s6,s2
      state = 0;
 668:	4981                	li	s3,0
 66a:	b54d                	j	50c <vprintf+0x60>
    }
  }
}
 66c:	70e6                	ld	ra,120(sp)
 66e:	7446                	ld	s0,112(sp)
 670:	74a6                	ld	s1,104(sp)
 672:	7906                	ld	s2,96(sp)
 674:	69e6                	ld	s3,88(sp)
 676:	6a46                	ld	s4,80(sp)
 678:	6aa6                	ld	s5,72(sp)
 67a:	6b06                	ld	s6,64(sp)
 67c:	7be2                	ld	s7,56(sp)
 67e:	7c42                	ld	s8,48(sp)
 680:	7ca2                	ld	s9,40(sp)
 682:	7d02                	ld	s10,32(sp)
 684:	6de2                	ld	s11,24(sp)
 686:	6109                	addi	sp,sp,128
 688:	8082                	ret

000000000000068a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68a:	715d                	addi	sp,sp,-80
 68c:	ec06                	sd	ra,24(sp)
 68e:	e822                	sd	s0,16(sp)
 690:	1000                	addi	s0,sp,32
 692:	e010                	sd	a2,0(s0)
 694:	e414                	sd	a3,8(s0)
 696:	e818                	sd	a4,16(s0)
 698:	ec1c                	sd	a5,24(s0)
 69a:	03043023          	sd	a6,32(s0)
 69e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a6:	8622                	mv	a2,s0
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e04080e7          	jalr	-508(ra) # 4ac <vprintf>
}
 6b0:	60e2                	ld	ra,24(sp)
 6b2:	6442                	ld	s0,16(sp)
 6b4:	6161                	addi	sp,sp,80
 6b6:	8082                	ret

00000000000006b8 <printf>:

void
printf(const char *fmt, ...)
{
 6b8:	711d                	addi	sp,sp,-96
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e40c                	sd	a1,8(s0)
 6c2:	e810                	sd	a2,16(s0)
 6c4:	ec14                	sd	a3,24(s0)
 6c6:	f018                	sd	a4,32(s0)
 6c8:	f41c                	sd	a5,40(s0)
 6ca:	03043823          	sd	a6,48(s0)
 6ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d2:	00840613          	addi	a2,s0,8
 6d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6da:	85aa                	mv	a1,a0
 6dc:	4505                	li	a0,1
 6de:	00000097          	auipc	ra,0x0
 6e2:	dce080e7          	jalr	-562(ra) # 4ac <vprintf>
}
 6e6:	60e2                	ld	ra,24(sp)
 6e8:	6442                	ld	s0,16(sp)
 6ea:	6125                	addi	sp,sp,96
 6ec:	8082                	ret

00000000000006ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ee:	1141                	addi	sp,sp,-16
 6f0:	e422                	sd	s0,8(sp)
 6f2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f8:	00001797          	auipc	a5,0x1
 6fc:	9087b783          	ld	a5,-1784(a5) # 1000 <freep>
 700:	a02d                	j	72a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 702:	4618                	lw	a4,8(a2)
 704:	9f2d                	addw	a4,a4,a1
 706:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 70a:	6398                	ld	a4,0(a5)
 70c:	6310                	ld	a2,0(a4)
 70e:	a83d                	j	74c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 710:	ff852703          	lw	a4,-8(a0)
 714:	9f31                	addw	a4,a4,a2
 716:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 718:	ff053683          	ld	a3,-16(a0)
 71c:	a091                	j	760 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71e:	6398                	ld	a4,0(a5)
 720:	00e7e463          	bltu	a5,a4,728 <free+0x3a>
 724:	00e6ea63          	bltu	a3,a4,738 <free+0x4a>
{
 728:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72a:	fed7fae3          	bgeu	a5,a3,71e <free+0x30>
 72e:	6398                	ld	a4,0(a5)
 730:	00e6e463          	bltu	a3,a4,738 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 734:	fee7eae3          	bltu	a5,a4,728 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 738:	ff852583          	lw	a1,-8(a0)
 73c:	6390                	ld	a2,0(a5)
 73e:	02059813          	slli	a6,a1,0x20
 742:	01c85713          	srli	a4,a6,0x1c
 746:	9736                	add	a4,a4,a3
 748:	fae60de3          	beq	a2,a4,702 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 74c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 750:	4790                	lw	a2,8(a5)
 752:	02061593          	slli	a1,a2,0x20
 756:	01c5d713          	srli	a4,a1,0x1c
 75a:	973e                	add	a4,a4,a5
 75c:	fae68ae3          	beq	a3,a4,710 <free+0x22>
    p->s.ptr = bp->s.ptr;
 760:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 762:	00001717          	auipc	a4,0x1
 766:	88f73f23          	sd	a5,-1890(a4) # 1000 <freep>
}
 76a:	6422                	ld	s0,8(sp)
 76c:	0141                	addi	sp,sp,16
 76e:	8082                	ret

0000000000000770 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 770:	7139                	addi	sp,sp,-64
 772:	fc06                	sd	ra,56(sp)
 774:	f822                	sd	s0,48(sp)
 776:	f426                	sd	s1,40(sp)
 778:	f04a                	sd	s2,32(sp)
 77a:	ec4e                	sd	s3,24(sp)
 77c:	e852                	sd	s4,16(sp)
 77e:	e456                	sd	s5,8(sp)
 780:	e05a                	sd	s6,0(sp)
 782:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 784:	02051493          	slli	s1,a0,0x20
 788:	9081                	srli	s1,s1,0x20
 78a:	04bd                	addi	s1,s1,15
 78c:	8091                	srli	s1,s1,0x4
 78e:	0014899b          	addiw	s3,s1,1
 792:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 794:	00001517          	auipc	a0,0x1
 798:	86c53503          	ld	a0,-1940(a0) # 1000 <freep>
 79c:	c515                	beqz	a0,7c8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a0:	4798                	lw	a4,8(a5)
 7a2:	02977f63          	bgeu	a4,s1,7e0 <malloc+0x70>
 7a6:	8a4e                	mv	s4,s3
 7a8:	0009871b          	sext.w	a4,s3
 7ac:	6685                	lui	a3,0x1
 7ae:	00d77363          	bgeu	a4,a3,7b4 <malloc+0x44>
 7b2:	6a05                	lui	s4,0x1
 7b4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7b8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7bc:	00001917          	auipc	s2,0x1
 7c0:	84490913          	addi	s2,s2,-1980 # 1000 <freep>
  if(p == (char*)-1)
 7c4:	5afd                	li	s5,-1
 7c6:	a895                	j	83a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7c8:	00001797          	auipc	a5,0x1
 7cc:	84878793          	addi	a5,a5,-1976 # 1010 <base>
 7d0:	00001717          	auipc	a4,0x1
 7d4:	82f73823          	sd	a5,-2000(a4) # 1000 <freep>
 7d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7de:	b7e1                	j	7a6 <malloc+0x36>
      if(p->s.size == nunits)
 7e0:	02e48c63          	beq	s1,a4,818 <malloc+0xa8>
        p->s.size -= nunits;
 7e4:	4137073b          	subw	a4,a4,s3
 7e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7ea:	02071693          	slli	a3,a4,0x20
 7ee:	01c6d713          	srli	a4,a3,0x1c
 7f2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7f4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7f8:	00001717          	auipc	a4,0x1
 7fc:	80a73423          	sd	a0,-2040(a4) # 1000 <freep>
      return (void*)(p + 1);
 800:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 804:	70e2                	ld	ra,56(sp)
 806:	7442                	ld	s0,48(sp)
 808:	74a2                	ld	s1,40(sp)
 80a:	7902                	ld	s2,32(sp)
 80c:	69e2                	ld	s3,24(sp)
 80e:	6a42                	ld	s4,16(sp)
 810:	6aa2                	ld	s5,8(sp)
 812:	6b02                	ld	s6,0(sp)
 814:	6121                	addi	sp,sp,64
 816:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 818:	6398                	ld	a4,0(a5)
 81a:	e118                	sd	a4,0(a0)
 81c:	bff1                	j	7f8 <malloc+0x88>
  hp->s.size = nu;
 81e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 822:	0541                	addi	a0,a0,16
 824:	00000097          	auipc	ra,0x0
 828:	eca080e7          	jalr	-310(ra) # 6ee <free>
  return freep;
 82c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 830:	d971                	beqz	a0,804 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 834:	4798                	lw	a4,8(a5)
 836:	fa9775e3          	bgeu	a4,s1,7e0 <malloc+0x70>
    if(p == freep)
 83a:	00093703          	ld	a4,0(s2)
 83e:	853e                	mv	a0,a5
 840:	fef719e3          	bne	a4,a5,832 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 844:	8552                	mv	a0,s4
 846:	00000097          	auipc	ra,0x0
 84a:	b40080e7          	jalr	-1216(ra) # 386 <sbrk>
  if(p == (char*)-1)
 84e:	fd5518e3          	bne	a0,s5,81e <malloc+0xae>
        return 0;
 852:	4501                	li	a0,0
 854:	bf45                	j	804 <malloc+0x94>

0000000000000856 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 856:	c1d9                	beqz	a1,8dc <head_run+0x86>
void head_run(int fd, int numOfLines){
 858:	dd010113          	addi	sp,sp,-560
 85c:	22113423          	sd	ra,552(sp)
 860:	22813023          	sd	s0,544(sp)
 864:	20913c23          	sd	s1,536(sp)
 868:	21213823          	sd	s2,528(sp)
 86c:	21313423          	sd	s3,520(sp)
 870:	21413023          	sd	s4,512(sp)
 874:	1c00                	addi	s0,sp,560
 876:	892a                	mv	s2,a0
 878:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 87c:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 87e:	00000a17          	auipc	s4,0x0
 882:	55aa0a13          	addi	s4,s4,1370 # dd8 <digits+0x40>
		readStatus = read_line(fd, line);
 886:	dd840593          	addi	a1,s0,-552
 88a:	854a                	mv	a0,s2
 88c:	00000097          	auipc	ra,0x0
 890:	394080e7          	jalr	916(ra) # c20 <read_line>
		if (readStatus == READ_ERROR){
 894:	01350d63          	beq	a0,s3,8ae <head_run+0x58>
		if (readStatus == READ_EOF)
 898:	c11d                	beqz	a0,8be <head_run+0x68>
		printf("%s",line);
 89a:	dd840593          	addi	a1,s0,-552
 89e:	8552                	mv	a0,s4
 8a0:	00000097          	auipc	ra,0x0
 8a4:	e18080e7          	jalr	-488(ra) # 6b8 <printf>
	while(numOfLines--){
 8a8:	34fd                	addiw	s1,s1,-1
 8aa:	fcf1                	bnez	s1,886 <head_run+0x30>
 8ac:	a809                	j	8be <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 8ae:	00000517          	auipc	a0,0x0
 8b2:	50250513          	addi	a0,a0,1282 # db0 <digits+0x18>
 8b6:	00000097          	auipc	ra,0x0
 8ba:	e02080e7          	jalr	-510(ra) # 6b8 <printf>

	}
}
 8be:	22813083          	ld	ra,552(sp)
 8c2:	22013403          	ld	s0,544(sp)
 8c6:	21813483          	ld	s1,536(sp)
 8ca:	21013903          	ld	s2,528(sp)
 8ce:	20813983          	ld	s3,520(sp)
 8d2:	20013a03          	ld	s4,512(sp)
 8d6:	23010113          	addi	sp,sp,560
 8da:	8082                	ret
 8dc:	8082                	ret

00000000000008de <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 8de:	ba010113          	addi	sp,sp,-1120
 8e2:	44113c23          	sd	ra,1112(sp)
 8e6:	44813823          	sd	s0,1104(sp)
 8ea:	44913423          	sd	s1,1096(sp)
 8ee:	45213023          	sd	s2,1088(sp)
 8f2:	43313c23          	sd	s3,1080(sp)
 8f6:	43413823          	sd	s4,1072(sp)
 8fa:	43513423          	sd	s5,1064(sp)
 8fe:	43613023          	sd	s6,1056(sp)
 902:	41713c23          	sd	s7,1048(sp)
 906:	41813823          	sd	s8,1040(sp)
 90a:	41913423          	sd	s9,1032(sp)
 90e:	41a13023          	sd	s10,1024(sp)
 912:	3fb13c23          	sd	s11,1016(sp)
 916:	46010413          	addi	s0,sp,1120
 91a:	89aa                	mv	s3,a0
 91c:	8aae                	mv	s5,a1
 91e:	8c32                	mv	s8,a2
 920:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 922:	d9840593          	addi	a1,s0,-616
 926:	00000097          	auipc	ra,0x0
 92a:	2fa080e7          	jalr	762(ra) # c20 <read_line>


  if (readStatus == READ_ERROR)
 92e:	57fd                	li	a5,-1
 930:	04f50163          	beq	a0,a5,972 <uniq_run+0x94>
 934:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 936:	ed21                	bnez	a0,98e <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 938:	45813083          	ld	ra,1112(sp)
 93c:	45013403          	ld	s0,1104(sp)
 940:	44813483          	ld	s1,1096(sp)
 944:	44013903          	ld	s2,1088(sp)
 948:	43813983          	ld	s3,1080(sp)
 94c:	43013a03          	ld	s4,1072(sp)
 950:	42813a83          	ld	s5,1064(sp)
 954:	42013b03          	ld	s6,1056(sp)
 958:	41813b83          	ld	s7,1048(sp)
 95c:	41013c03          	ld	s8,1040(sp)
 960:	40813c83          	ld	s9,1032(sp)
 964:	40013d03          	ld	s10,1024(sp)
 968:	3f813d83          	ld	s11,1016(sp)
 96c:	46010113          	addi	sp,sp,1120
 970:	8082                	ret
    printf("[ERR] Error reading from the file ");
 972:	00000517          	auipc	a0,0x0
 976:	46e50513          	addi	a0,a0,1134 # de0 <digits+0x48>
 97a:	00000097          	auipc	ra,0x0
 97e:	d3e080e7          	jalr	-706(ra) # 6b8 <printf>
 982:	bf5d                	j	938 <uniq_run+0x5a>
 984:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 986:	8926                	mv	s2,s1
 988:	84be                	mv	s1,a5
        lineCount = 1;
 98a:	8b6a                	mv	s6,s10
 98c:	a8ed                	j	a86 <uniq_run+0x1a8>
    int lineCount=1;
 98e:	4b05                	li	s6,1
  char * line2 = buffer2;
 990:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 994:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 998:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 99a:	4d05                	li	s10,1
              printf("%s",line1);
 99c:	00000d97          	auipc	s11,0x0
 9a0:	43cd8d93          	addi	s11,s11,1084 # dd8 <digits+0x40>
 9a4:	a0cd                	j	a86 <uniq_run+0x1a8>
            if (repeatedLines){
 9a6:	020a0b63          	beqz	s4,9dc <uniq_run+0xfe>
                if (isRepeated){
 9aa:	f80b87e3          	beqz	s7,938 <uniq_run+0x5a>
                    if (showCount)
 9ae:	000c0d63          	beqz	s8,9c8 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 9b2:	864a                	mv	a2,s2
 9b4:	85da                	mv	a1,s6
 9b6:	00000517          	auipc	a0,0x0
 9ba:	45250513          	addi	a0,a0,1106 # e08 <digits+0x70>
 9be:	00000097          	auipc	ra,0x0
 9c2:	cfa080e7          	jalr	-774(ra) # 6b8 <printf>
 9c6:	bf8d                	j	938 <uniq_run+0x5a>
                      printf("%s",line1);
 9c8:	85ca                	mv	a1,s2
 9ca:	00000517          	auipc	a0,0x0
 9ce:	40e50513          	addi	a0,a0,1038 # dd8 <digits+0x40>
 9d2:	00000097          	auipc	ra,0x0
 9d6:	ce6080e7          	jalr	-794(ra) # 6b8 <printf>
 9da:	bfb9                	j	938 <uniq_run+0x5a>
                if (showCount)
 9dc:	000c0d63          	beqz	s8,9f6 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 9e0:	864a                	mv	a2,s2
 9e2:	85da                	mv	a1,s6
 9e4:	00000517          	auipc	a0,0x0
 9e8:	42450513          	addi	a0,a0,1060 # e08 <digits+0x70>
 9ec:	00000097          	auipc	ra,0x0
 9f0:	ccc080e7          	jalr	-820(ra) # 6b8 <printf>
 9f4:	b791                	j	938 <uniq_run+0x5a>
                  printf("%s",line1);
 9f6:	85ca                	mv	a1,s2
 9f8:	00000517          	auipc	a0,0x0
 9fc:	3e050513          	addi	a0,a0,992 # dd8 <digits+0x40>
 a00:	00000097          	auipc	ra,0x0
 a04:	cb8080e7          	jalr	-840(ra) # 6b8 <printf>
 a08:	bf05                	j	938 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 a0a:	00000517          	auipc	a0,0x0
 a0e:	40650513          	addi	a0,a0,1030 # e10 <digits+0x78>
 a12:	00000097          	auipc	ra,0x0
 a16:	ca6080e7          	jalr	-858(ra) # 6b8 <printf>
          break;
 a1a:	bf39                	j	938 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 a1c:	85a6                	mv	a1,s1
 a1e:	854a                	mv	a0,s2
 a20:	00000097          	auipc	ra,0x0
 a24:	110080e7          	jalr	272(ra) # b30 <compare_str_ic>
 a28:	a041                	j	aa8 <uniq_run+0x1ca>
                  printf("%s",line1);
 a2a:	85ca                	mv	a1,s2
 a2c:	856e                	mv	a0,s11
 a2e:	00000097          	auipc	ra,0x0
 a32:	c8a080e7          	jalr	-886(ra) # 6b8 <printf>
        lineCount = 1;
 a36:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 a38:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a3a:	8926                	mv	s2,s1
                  printf("%s",line1);
 a3c:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a3e:	4b81                	li	s7,0
 a40:	a099                	j	a86 <uniq_run+0x1a8>
            if (showCount)
 a42:	020c0263          	beqz	s8,a66 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 a46:	864a                	mv	a2,s2
 a48:	85da                	mv	a1,s6
 a4a:	00000517          	auipc	a0,0x0
 a4e:	3be50513          	addi	a0,a0,958 # e08 <digits+0x70>
 a52:	00000097          	auipc	ra,0x0
 a56:	c66080e7          	jalr	-922(ra) # 6b8 <printf>
 a5a:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a5c:	8926                	mv	s2,s1
 a5e:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a60:	4b81                	li	s7,0
        lineCount = 1;
 a62:	8b6a                	mv	s6,s10
 a64:	a00d                	j	a86 <uniq_run+0x1a8>
              printf("%s",line1);
 a66:	85ca                	mv	a1,s2
 a68:	856e                	mv	a0,s11
 a6a:	00000097          	auipc	ra,0x0
 a6e:	c4e080e7          	jalr	-946(ra) # 6b8 <printf>
 a72:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a74:	8926                	mv	s2,s1
              printf("%s",line1);
 a76:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a78:	4b81                	li	s7,0
        lineCount = 1;
 a7a:	8b6a                	mv	s6,s10
 a7c:	a029                	j	a86 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 a7e:	000a0363          	beqz	s4,a84 <uniq_run+0x1a6>
 a82:	8bea                	mv	s7,s10
          lineCount++;
 a84:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 a86:	85a6                	mv	a1,s1
 a88:	854e                	mv	a0,s3
 a8a:	00000097          	auipc	ra,0x0
 a8e:	196080e7          	jalr	406(ra) # c20 <read_line>
        if (readStatus == READ_EOF){
 a92:	d911                	beqz	a0,9a6 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 a94:	f7950be3          	beq	a0,s9,a0a <uniq_run+0x12c>
        if (!ignoreCase)
 a98:	f80a92e3          	bnez	s5,a1c <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 a9c:	85a6                	mv	a1,s1
 a9e:	854a                	mv	a0,s2
 aa0:	00000097          	auipc	ra,0x0
 aa4:	062080e7          	jalr	98(ra) # b02 <compare_str>
        if (compareStatus != 0){ 
 aa8:	d979                	beqz	a0,a7e <uniq_run+0x1a0>
          if (repeatedLines){
 aaa:	f80a0ce3          	beqz	s4,a42 <uniq_run+0x164>
            if (isRepeated){
 aae:	ec0b8be3          	beqz	s7,984 <uniq_run+0xa6>
                if (showCount)
 ab2:	f60c0ce3          	beqz	s8,a2a <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 ab6:	864a                	mv	a2,s2
 ab8:	85da                	mv	a1,s6
 aba:	00000517          	auipc	a0,0x0
 abe:	34e50513          	addi	a0,a0,846 # e08 <digits+0x70>
 ac2:	00000097          	auipc	ra,0x0
 ac6:	bf6080e7          	jalr	-1034(ra) # 6b8 <printf>
        lineCount = 1;
 aca:	8b5e                	mv	s6,s7
 acc:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 ace:	8926                	mv	s2,s1
 ad0:	84be                	mv	s1,a5
        isRepeated = 0 ;
 ad2:	4b81                	li	s7,0
 ad4:	bf4d                	j	a86 <uniq_run+0x1a8>

0000000000000ad6 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 ad6:	1141                	addi	sp,sp,-16
 ad8:	e422                	sd	s0,8(sp)
 ada:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 adc:	00054783          	lbu	a5,0(a0)
 ae0:	cf99                	beqz	a5,afe <get_strlen+0x28>
 ae2:	00150713          	addi	a4,a0,1
 ae6:	87ba                	mv	a5,a4
 ae8:	4685                	li	a3,1
 aea:	9e99                	subw	a3,a3,a4
 aec:	00f6853b          	addw	a0,a3,a5
 af0:	0785                	addi	a5,a5,1
 af2:	fff7c703          	lbu	a4,-1(a5)
 af6:	fb7d                	bnez	a4,aec <get_strlen+0x16>
	return len;
}
 af8:	6422                	ld	s0,8(sp)
 afa:	0141                	addi	sp,sp,16
 afc:	8082                	ret
	int len = 0;
 afe:	4501                	li	a0,0
 b00:	bfe5                	j	af8 <get_strlen+0x22>

0000000000000b02 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 b02:	1141                	addi	sp,sp,-16
 b04:	e422                	sd	s0,8(sp)
 b06:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 b08:	00054783          	lbu	a5,0(a0)
 b0c:	cb91                	beqz	a5,b20 <compare_str+0x1e>
 b0e:	0005c703          	lbu	a4,0(a1)
 b12:	c719                	beqz	a4,b20 <compare_str+0x1e>
		if (*s1++ != *s2++)
 b14:	0505                	addi	a0,a0,1
 b16:	0585                	addi	a1,a1,1
 b18:	fee788e3          	beq	a5,a4,b08 <compare_str+0x6>
			return 1;
 b1c:	4505                	li	a0,1
 b1e:	a031                	j	b2a <compare_str+0x28>
	}
	if (*s1 == *s2)
 b20:	0005c503          	lbu	a0,0(a1)
 b24:	8d1d                	sub	a0,a0,a5
			return 1;
 b26:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b2a:	6422                	ld	s0,8(sp)
 b2c:	0141                	addi	sp,sp,16
 b2e:	8082                	ret

0000000000000b30 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 b30:	1141                	addi	sp,sp,-16
 b32:	e422                	sd	s0,8(sp)
 b34:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b36:	4665                	li	a2,25
	while(*s1 && *s2){
 b38:	a019                	j	b3e <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b3a:	04e79763          	bne	a5,a4,b88 <compare_str_ic+0x58>
	while(*s1 && *s2){
 b3e:	00054783          	lbu	a5,0(a0)
 b42:	cb9d                	beqz	a5,b78 <compare_str_ic+0x48>
 b44:	0005c703          	lbu	a4,0(a1)
 b48:	cb05                	beqz	a4,b78 <compare_str_ic+0x48>
		char b1 = *s1++;
 b4a:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 b4c:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b4e:	fbf7869b          	addiw	a3,a5,-65
 b52:	0ff6f693          	zext.b	a3,a3
 b56:	00d66663          	bltu	a2,a3,b62 <compare_str_ic+0x32>
			b1 += 32;
 b5a:	0207879b          	addiw	a5,a5,32
 b5e:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 b62:	fbf7069b          	addiw	a3,a4,-65
 b66:	0ff6f693          	zext.b	a3,a3
 b6a:	fcd668e3          	bltu	a2,a3,b3a <compare_str_ic+0xa>
			b2 += 32;
 b6e:	0207071b          	addiw	a4,a4,32
 b72:	0ff77713          	zext.b	a4,a4
 b76:	b7d1                	j	b3a <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 b78:	0005c503          	lbu	a0,0(a1)
 b7c:	8d1d                	sub	a0,a0,a5
			return 1;
 b7e:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b82:	6422                	ld	s0,8(sp)
 b84:	0141                	addi	sp,sp,16
 b86:	8082                	ret
			return 1;
 b88:	4505                	li	a0,1
 b8a:	bfe5                	j	b82 <compare_str_ic+0x52>

0000000000000b8c <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 b8c:	7179                	addi	sp,sp,-48
 b8e:	f406                	sd	ra,40(sp)
 b90:	f022                	sd	s0,32(sp)
 b92:	ec26                	sd	s1,24(sp)
 b94:	e84a                	sd	s2,16(sp)
 b96:	e44e                	sd	s3,8(sp)
 b98:	1800                	addi	s0,sp,48
 b9a:	89aa                	mv	s3,a0
 b9c:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 b9e:	00000097          	auipc	ra,0x0
 ba2:	f38080e7          	jalr	-200(ra) # ad6 <get_strlen>
 ba6:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 ba8:	854a                	mv	a0,s2
 baa:	00000097          	auipc	ra,0x0
 bae:	f2c080e7          	jalr	-212(ra) # ad6 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 bb2:	409505bb          	subw	a1,a0,s1
 bb6:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 bb8:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 bba:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 bbc:	0005da63          	bgez	a1,bd0 <check_substr+0x44>
 bc0:	a81d                	j	bf6 <check_substr+0x6a>
        if (j == M)
 bc2:	02f48a63          	beq	s1,a5,bf6 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 bc6:	0885                	addi	a7,a7,1
 bc8:	0008879b          	sext.w	a5,a7
 bcc:	02f5cc63          	blt	a1,a5,c04 <check_substr+0x78>
 bd0:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 bd4:	011906b3          	add	a3,s2,a7
 bd8:	874e                	mv	a4,s3
 bda:	879a                	mv	a5,t1
 bdc:	fe9053e3          	blez	s1,bc2 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 be0:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 be4:	00074603          	lbu	a2,0(a4)
 be8:	fcc81de3          	bne	a6,a2,bc2 <check_substr+0x36>
        for (j = 0; j < M; j++)
 bec:	2785                	addiw	a5,a5,1
 bee:	0685                	addi	a3,a3,1
 bf0:	0705                	addi	a4,a4,1
 bf2:	fef497e3          	bne	s1,a5,be0 <check_substr+0x54>
}
 bf6:	70a2                	ld	ra,40(sp)
 bf8:	7402                	ld	s0,32(sp)
 bfa:	64e2                	ld	s1,24(sp)
 bfc:	6942                	ld	s2,16(sp)
 bfe:	69a2                	ld	s3,8(sp)
 c00:	6145                	addi	sp,sp,48
 c02:	8082                	ret
    return -1;
 c04:	557d                	li	a0,-1
 c06:	bfc5                	j	bf6 <check_substr+0x6a>

0000000000000c08 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 c08:	1141                	addi	sp,sp,-16
 c0a:	e406                	sd	ra,8(sp)
 c0c:	e022                	sd	s0,0(sp)
 c0e:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 c10:	fffff097          	auipc	ra,0xfffff
 c14:	72e080e7          	jalr	1838(ra) # 33e <open>
	return fd;
}
 c18:	60a2                	ld	ra,8(sp)
 c1a:	6402                	ld	s0,0(sp)
 c1c:	0141                	addi	sp,sp,16
 c1e:	8082                	ret

0000000000000c20 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 c20:	7139                	addi	sp,sp,-64
 c22:	fc06                	sd	ra,56(sp)
 c24:	f822                	sd	s0,48(sp)
 c26:	f426                	sd	s1,40(sp)
 c28:	f04a                	sd	s2,32(sp)
 c2a:	ec4e                	sd	s3,24(sp)
 c2c:	e852                	sd	s4,16(sp)
 c2e:	0080                	addi	s0,sp,64
 c30:	89aa                	mv	s3,a0
 c32:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c34:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 c36:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c38:	4605                	li	a2,1
 c3a:	fcf40593          	addi	a1,s0,-49
 c3e:	854e                	mv	a0,s3
 c40:	fffff097          	auipc	ra,0xfffff
 c44:	6d6080e7          	jalr	1750(ra) # 316 <read>
		if (readStatus == 0){
 c48:	c505                	beqz	a0,c70 <read_line+0x50>
		*buffer++ = readByte;
 c4a:	0485                	addi	s1,s1,1
 c4c:	fcf44783          	lbu	a5,-49(s0)
 c50:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c54:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c56:	ff4791e3          	bne	a5,s4,c38 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c5a:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 c5e:	854a                	mv	a0,s2
 c60:	70e2                	ld	ra,56(sp)
 c62:	7442                	ld	s0,48(sp)
 c64:	74a2                	ld	s1,40(sp)
 c66:	7902                	ld	s2,32(sp)
 c68:	69e2                	ld	s3,24(sp)
 c6a:	6a42                	ld	s4,16(sp)
 c6c:	6121                	addi	sp,sp,64
 c6e:	8082                	ret
			if (byteCount!=0){
 c70:	fe0907e3          	beqz	s2,c5e <read_line+0x3e>
				*buffer = '\n';
 c74:	47a9                	li	a5,10
 c76:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 c7a:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 c7e:	2905                	addiw	s2,s2,1
 c80:	bff9                	j	c5e <read_line+0x3e>

0000000000000c82 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c82:	1141                	addi	sp,sp,-16
 c84:	e406                	sd	ra,8(sp)
 c86:	e022                	sd	s0,0(sp)
 c88:	0800                	addi	s0,sp,16
	close(fd);
 c8a:	fffff097          	auipc	ra,0xfffff
 c8e:	69c080e7          	jalr	1692(ra) # 326 <close>
}
 c92:	60a2                	ld	ra,8(sp)
 c94:	6402                	ld	s0,0(sp)
 c96:	0141                	addi	sp,sp,16
 c98:	8082                	ret

0000000000000c9a <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 c9a:	7139                	addi	sp,sp,-64
 c9c:	fc06                	sd	ra,56(sp)
 c9e:	f822                	sd	s0,48(sp)
 ca0:	f426                	sd	s1,40(sp)
 ca2:	f04a                	sd	s2,32(sp)
 ca4:	0080                	addi	s0,sp,64
 ca6:	84aa                	mv	s1,a0
 ca8:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 caa:	fffff097          	auipc	ra,0xfffff
 cae:	64c080e7          	jalr	1612(ra) # 2f6 <fork>
 cb2:	ed19                	bnez	a0,cd0 <get_time_perf+0x36>
		exec(argv[0],argv);
 cb4:	85ca                	mv	a1,s2
 cb6:	00093503          	ld	a0,0(s2)
 cba:	fffff097          	auipc	ra,0xfffff
 cbe:	67c080e7          	jalr	1660(ra) # 336 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 cc2:	8526                	mv	a0,s1
 cc4:	70e2                	ld	ra,56(sp)
 cc6:	7442                	ld	s0,48(sp)
 cc8:	74a2                	ld	s1,40(sp)
 cca:	7902                	ld	s2,32(sp)
 ccc:	6121                	addi	sp,sp,64
 cce:	8082                	ret
		times(pid , &time);
 cd0:	fc040593          	addi	a1,s0,-64
 cd4:	fffff097          	auipc	ra,0xfffff
 cd8:	6e2080e7          	jalr	1762(ra) # 3b6 <times>
		return time;
 cdc:	fc043783          	ld	a5,-64(s0)
 ce0:	e09c                	sd	a5,0(s1)
 ce2:	fc843783          	ld	a5,-56(s0)
 ce6:	e49c                	sd	a5,8(s1)
 ce8:	fd043783          	ld	a5,-48(s0)
 cec:	e89c                	sd	a5,16(s1)
 cee:	fd843783          	ld	a5,-40(s0)
 cf2:	ec9c                	sd	a5,24(s1)
 cf4:	b7f9                	j	cc2 <get_time_perf+0x28>
