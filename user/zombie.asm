
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	2a0080e7          	jalr	672(ra) # 2a8 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	29a080e7          	jalr	666(ra) # 2b0 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	320080e7          	jalr	800(ra) # 340 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	274080e7          	jalr	628(ra) # 2b0 <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4a:	87aa                	mv	a5,a0
  4c:	0585                	addi	a1,a1,1
  4e:	0785                	addi	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0x8>
    ;
  return os;
}
  5a:	6422                	ld	s0,8(sp)
  5c:	0141                	addi	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  66:	00054783          	lbu	a5,0(a0)
  6a:	cb91                	beqz	a5,7e <strcmp+0x1e>
  6c:	0005c703          	lbu	a4,0(a1)
  70:	00f71763          	bne	a4,a5,7e <strcmp+0x1e>
    p++, q++;
  74:	0505                	addi	a0,a0,1
  76:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  78:	00054783          	lbu	a5,0(a0)
  7c:	fbe5                	bnez	a5,6c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7e:	0005c503          	lbu	a0,0(a1)
}
  82:	40a7853b          	subw	a0,a5,a0
  86:	6422                	ld	s0,8(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strlen>:

uint
strlen(const char *s)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  92:	00054783          	lbu	a5,0(a0)
  96:	cf91                	beqz	a5,b2 <strlen+0x26>
  98:	0505                	addi	a0,a0,1
  9a:	87aa                	mv	a5,a0
  9c:	4685                	li	a3,1
  9e:	9e89                	subw	a3,a3,a0
  a0:	00f6853b          	addw	a0,a3,a5
  a4:	0785                	addi	a5,a5,1
  a6:	fff7c703          	lbu	a4,-1(a5)
  aa:	fb7d                	bnez	a4,a0 <strlen+0x14>
    ;
  return n;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret
  for(n = 0; s[n]; n++)
  b2:	4501                	li	a0,0
  b4:	bfe5                	j	ac <strlen+0x20>

00000000000000b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  bc:	ca19                	beqz	a2,d2 <memset+0x1c>
  be:	87aa                	mv	a5,a0
  c0:	1602                	slli	a2,a2,0x20
  c2:	9201                	srli	a2,a2,0x20
  c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  cc:	0785                	addi	a5,a5,1
  ce:	fee79de3          	bne	a5,a4,c8 <memset+0x12>
  }
  return dst;
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char*
strchr(const char *s, char c)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb99                	beqz	a5,f8 <strchr+0x20>
    if(*s == c)
  e4:	00f58763          	beq	a1,a5,f2 <strchr+0x1a>
  for(; *s; s++)
  e8:	0505                	addi	a0,a0,1
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbfd                	bnez	a5,e4 <strchr+0xc>
      return (char*)s;
  return 0;
  f0:	4501                	li	a0,0
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  return 0;
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strchr+0x1a>

00000000000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	711d                	addi	sp,sp,-96
  fe:	ec86                	sd	ra,88(sp)
 100:	e8a2                	sd	s0,80(sp)
 102:	e4a6                	sd	s1,72(sp)
 104:	e0ca                	sd	s2,64(sp)
 106:	fc4e                	sd	s3,56(sp)
 108:	f852                	sd	s4,48(sp)
 10a:	f456                	sd	s5,40(sp)
 10c:	f05a                	sd	s6,32(sp)
 10e:	ec5e                	sd	s7,24(sp)
 110:	1080                	addi	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11a:	4aa9                	li	s5,10
 11c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11e:	89a6                	mv	s3,s1
 120:	2485                	addiw	s1,s1,1
 122:	0344d863          	bge	s1,s4,152 <gets+0x56>
    cc = read(0, &c, 1);
 126:	4605                	li	a2,1
 128:	faf40593          	addi	a1,s0,-81
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	19a080e7          	jalr	410(ra) # 2c8 <read>
    if(cc < 1)
 136:	00a05e63          	blez	a0,152 <gets+0x56>
    buf[i++] = c;
 13a:	faf44783          	lbu	a5,-81(s0)
 13e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 142:	01578763          	beq	a5,s5,150 <gets+0x54>
 146:	0905                	addi	s2,s2,1
 148:	fd679be3          	bne	a5,s6,11e <gets+0x22>
  for(i=0; i+1 < max; ){
 14c:	89a6                	mv	s3,s1
 14e:	a011                	j	152 <gets+0x56>
 150:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 152:	99de                	add	s3,s3,s7
 154:	00098023          	sb	zero,0(s3)
  return buf;
}
 158:	855e                	mv	a0,s7
 15a:	60e6                	ld	ra,88(sp)
 15c:	6446                	ld	s0,80(sp)
 15e:	64a6                	ld	s1,72(sp)
 160:	6906                	ld	s2,64(sp)
 162:	79e2                	ld	s3,56(sp)
 164:	7a42                	ld	s4,48(sp)
 166:	7aa2                	ld	s5,40(sp)
 168:	7b02                	ld	s6,32(sp)
 16a:	6be2                	ld	s7,24(sp)
 16c:	6125                	addi	sp,sp,96
 16e:	8082                	ret

0000000000000170 <stat>:

int
stat(const char *n, struct stat *st)
{
 170:	1101                	addi	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e426                	sd	s1,8(sp)
 178:	e04a                	sd	s2,0(sp)
 17a:	1000                	addi	s0,sp,32
 17c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17e:	4581                	li	a1,0
 180:	00000097          	auipc	ra,0x0
 184:	170080e7          	jalr	368(ra) # 2f0 <open>
  if(fd < 0)
 188:	02054563          	bltz	a0,1b2 <stat+0x42>
 18c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18e:	85ca                	mv	a1,s2
 190:	00000097          	auipc	ra,0x0
 194:	178080e7          	jalr	376(ra) # 308 <fstat>
 198:	892a                	mv	s2,a0
  close(fd);
 19a:	8526                	mv	a0,s1
 19c:	00000097          	auipc	ra,0x0
 1a0:	13c080e7          	jalr	316(ra) # 2d8 <close>
  return r;
}
 1a4:	854a                	mv	a0,s2
 1a6:	60e2                	ld	ra,24(sp)
 1a8:	6442                	ld	s0,16(sp)
 1aa:	64a2                	ld	s1,8(sp)
 1ac:	6902                	ld	s2,0(sp)
 1ae:	6105                	addi	sp,sp,32
 1b0:	8082                	ret
    return -1;
 1b2:	597d                	li	s2,-1
 1b4:	bfc5                	j	1a4 <stat+0x34>

00000000000001b6 <atoi>:

int
atoi(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1bc:	00054683          	lbu	a3,0(a0)
 1c0:	fd06879b          	addiw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	4625                	li	a2,9
 1ca:	02f66863          	bltu	a2,a5,1fa <atoi+0x44>
 1ce:	872a                	mv	a4,a0
  n = 0;
 1d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d2:	0705                	addi	a4,a4,1
 1d4:	0025179b          	slliw	a5,a0,0x2
 1d8:	9fa9                	addw	a5,a5,a0
 1da:	0017979b          	slliw	a5,a5,0x1
 1de:	9fb5                	addw	a5,a5,a3
 1e0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e4:	00074683          	lbu	a3,0(a4)
 1e8:	fd06879b          	addiw	a5,a3,-48
 1ec:	0ff7f793          	zext.b	a5,a5
 1f0:	fef671e3          	bgeu	a2,a5,1d2 <atoi+0x1c>
  return n;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
  n = 0;
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <atoi+0x3e>

00000000000001fe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 204:	02b57463          	bgeu	a0,a1,22c <memmove+0x2e>
    while(n-- > 0)
 208:	00c05f63          	blez	a2,226 <memmove+0x28>
 20c:	1602                	slli	a2,a2,0x20
 20e:	9201                	srli	a2,a2,0x20
 210:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 214:	872a                	mv	a4,a0
      *dst++ = *src++;
 216:	0585                	addi	a1,a1,1
 218:	0705                	addi	a4,a4,1
 21a:	fff5c683          	lbu	a3,-1(a1)
 21e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 222:	fee79ae3          	bne	a5,a4,216 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
    dst += n;
 22c:	00c50733          	add	a4,a0,a2
    src += n;
 230:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 232:	fec05ae3          	blez	a2,226 <memmove+0x28>
 236:	fff6079b          	addiw	a5,a2,-1
 23a:	1782                	slli	a5,a5,0x20
 23c:	9381                	srli	a5,a5,0x20
 23e:	fff7c793          	not	a5,a5
 242:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 244:	15fd                	addi	a1,a1,-1
 246:	177d                	addi	a4,a4,-1
 248:	0005c683          	lbu	a3,0(a1)
 24c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x46>
 254:	bfc9                	j	226 <memmove+0x28>

0000000000000256 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25c:	ca05                	beqz	a2,28c <memcmp+0x36>
 25e:	fff6069b          	addiw	a3,a2,-1
 262:	1682                	slli	a3,a3,0x20
 264:	9281                	srli	a3,a3,0x20
 266:	0685                	addi	a3,a3,1
 268:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 26a:	00054783          	lbu	a5,0(a0)
 26e:	0005c703          	lbu	a4,0(a1)
 272:	00e79863          	bne	a5,a4,282 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 276:	0505                	addi	a0,a0,1
    p2++;
 278:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27a:	fed518e3          	bne	a0,a3,26a <memcmp+0x14>
  }
  return 0;
 27e:	4501                	li	a0,0
 280:	a019                	j	286 <memcmp+0x30>
      return *p1 - *p2;
 282:	40e7853b          	subw	a0,a5,a4
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  return 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <memcmp+0x30>

0000000000000290 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 298:	00000097          	auipc	ra,0x0
 29c:	f66080e7          	jalr	-154(ra) # 1fe <memmove>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a8:	4885                	li	a7,1
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b0:	4889                	li	a7,2
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b8:	488d                	li	a7,3
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c0:	4891                	li	a7,4
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <read>:
.global read
read:
 li a7, SYS_read
 2c8:	4895                	li	a7,5
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <write>:
.global write
write:
 li a7, SYS_write
 2d0:	48c1                	li	a7,16
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <close>:
.global close
close:
 li a7, SYS_close
 2d8:	48d5                	li	a7,21
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e0:	4899                	li	a7,6
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e8:	489d                	li	a7,7
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <open>:
.global open
open:
 li a7, SYS_open
 2f0:	48bd                	li	a7,15
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f8:	48c5                	li	a7,17
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 300:	48c9                	li	a7,18
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 308:	48a1                	li	a7,8
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <link>:
.global link
link:
 li a7, SYS_link
 310:	48cd                	li	a7,19
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 318:	48d1                	li	a7,20
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 320:	48a5                	li	a7,9
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <dup>:
.global dup
dup:
 li a7, SYS_dup
 328:	48a9                	li	a7,10
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 330:	48ad                	li	a7,11
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 338:	48b1                	li	a7,12
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 340:	48b5                	li	a7,13
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 348:	48b9                	li	a7,14
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <head>:
.global head
head:
 li a7, SYS_head
 350:	48d9                	li	a7,22
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 358:	48dd                	li	a7,23
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <ps>:
.global ps
ps:
 li a7, SYS_ps
 360:	48e1                	li	a7,24
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <times>:
.global times
times:
 li a7, SYS_times
 368:	48e5                	li	a7,25
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 370:	48e9                	li	a7,26
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 378:	1101                	addi	sp,sp,-32
 37a:	ec06                	sd	ra,24(sp)
 37c:	e822                	sd	s0,16(sp)
 37e:	1000                	addi	s0,sp,32
 380:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 384:	4605                	li	a2,1
 386:	fef40593          	addi	a1,s0,-17
 38a:	00000097          	auipc	ra,0x0
 38e:	f46080e7          	jalr	-186(ra) # 2d0 <write>
}
 392:	60e2                	ld	ra,24(sp)
 394:	6442                	ld	s0,16(sp)
 396:	6105                	addi	sp,sp,32
 398:	8082                	ret

000000000000039a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39a:	7139                	addi	sp,sp,-64
 39c:	fc06                	sd	ra,56(sp)
 39e:	f822                	sd	s0,48(sp)
 3a0:	f426                	sd	s1,40(sp)
 3a2:	f04a                	sd	s2,32(sp)
 3a4:	ec4e                	sd	s3,24(sp)
 3a6:	0080                	addi	s0,sp,64
 3a8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3aa:	c299                	beqz	a3,3b0 <printint+0x16>
 3ac:	0805c963          	bltz	a1,43e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3b0:	2581                	sext.w	a1,a1
  neg = 0;
 3b2:	4881                	li	a7,0
 3b4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3b8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ba:	2601                	sext.w	a2,a2
 3bc:	00001517          	auipc	a0,0x1
 3c0:	93450513          	addi	a0,a0,-1740 # cf0 <digits>
 3c4:	883a                	mv	a6,a4
 3c6:	2705                	addiw	a4,a4,1
 3c8:	02c5f7bb          	remuw	a5,a1,a2
 3cc:	1782                	slli	a5,a5,0x20
 3ce:	9381                	srli	a5,a5,0x20
 3d0:	97aa                	add	a5,a5,a0
 3d2:	0007c783          	lbu	a5,0(a5)
 3d6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3da:	0005879b          	sext.w	a5,a1
 3de:	02c5d5bb          	divuw	a1,a1,a2
 3e2:	0685                	addi	a3,a3,1
 3e4:	fec7f0e3          	bgeu	a5,a2,3c4 <printint+0x2a>
  if(neg)
 3e8:	00088c63          	beqz	a7,400 <printint+0x66>
    buf[i++] = '-';
 3ec:	fd070793          	addi	a5,a4,-48
 3f0:	00878733          	add	a4,a5,s0
 3f4:	02d00793          	li	a5,45
 3f8:	fef70823          	sb	a5,-16(a4)
 3fc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 400:	02e05863          	blez	a4,430 <printint+0x96>
 404:	fc040793          	addi	a5,s0,-64
 408:	00e78933          	add	s2,a5,a4
 40c:	fff78993          	addi	s3,a5,-1
 410:	99ba                	add	s3,s3,a4
 412:	377d                	addiw	a4,a4,-1
 414:	1702                	slli	a4,a4,0x20
 416:	9301                	srli	a4,a4,0x20
 418:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 41c:	fff94583          	lbu	a1,-1(s2)
 420:	8526                	mv	a0,s1
 422:	00000097          	auipc	ra,0x0
 426:	f56080e7          	jalr	-170(ra) # 378 <putc>
  while(--i >= 0)
 42a:	197d                	addi	s2,s2,-1
 42c:	ff3918e3          	bne	s2,s3,41c <printint+0x82>
}
 430:	70e2                	ld	ra,56(sp)
 432:	7442                	ld	s0,48(sp)
 434:	74a2                	ld	s1,40(sp)
 436:	7902                	ld	s2,32(sp)
 438:	69e2                	ld	s3,24(sp)
 43a:	6121                	addi	sp,sp,64
 43c:	8082                	ret
    x = -xx;
 43e:	40b005bb          	negw	a1,a1
    neg = 1;
 442:	4885                	li	a7,1
    x = -xx;
 444:	bf85                	j	3b4 <printint+0x1a>

0000000000000446 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 446:	7119                	addi	sp,sp,-128
 448:	fc86                	sd	ra,120(sp)
 44a:	f8a2                	sd	s0,112(sp)
 44c:	f4a6                	sd	s1,104(sp)
 44e:	f0ca                	sd	s2,96(sp)
 450:	ecce                	sd	s3,88(sp)
 452:	e8d2                	sd	s4,80(sp)
 454:	e4d6                	sd	s5,72(sp)
 456:	e0da                	sd	s6,64(sp)
 458:	fc5e                	sd	s7,56(sp)
 45a:	f862                	sd	s8,48(sp)
 45c:	f466                	sd	s9,40(sp)
 45e:	f06a                	sd	s10,32(sp)
 460:	ec6e                	sd	s11,24(sp)
 462:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 464:	0005c903          	lbu	s2,0(a1)
 468:	18090f63          	beqz	s2,606 <vprintf+0x1c0>
 46c:	8aaa                	mv	s5,a0
 46e:	8b32                	mv	s6,a2
 470:	00158493          	addi	s1,a1,1
  state = 0;
 474:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 476:	02500a13          	li	s4,37
 47a:	4c55                	li	s8,21
 47c:	00001c97          	auipc	s9,0x1
 480:	81cc8c93          	addi	s9,s9,-2020 # c98 <get_time_perf+0x64>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 484:	02800d93          	li	s11,40
  putc(fd, 'x');
 488:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 48a:	00001b97          	auipc	s7,0x1
 48e:	866b8b93          	addi	s7,s7,-1946 # cf0 <digits>
 492:	a839                	j	4b0 <vprintf+0x6a>
        putc(fd, c);
 494:	85ca                	mv	a1,s2
 496:	8556                	mv	a0,s5
 498:	00000097          	auipc	ra,0x0
 49c:	ee0080e7          	jalr	-288(ra) # 378 <putc>
 4a0:	a019                	j	4a6 <vprintf+0x60>
    } else if(state == '%'){
 4a2:	01498d63          	beq	s3,s4,4bc <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4a6:	0485                	addi	s1,s1,1
 4a8:	fff4c903          	lbu	s2,-1(s1)
 4ac:	14090d63          	beqz	s2,606 <vprintf+0x1c0>
    if(state == 0){
 4b0:	fe0999e3          	bnez	s3,4a2 <vprintf+0x5c>
      if(c == '%'){
 4b4:	ff4910e3          	bne	s2,s4,494 <vprintf+0x4e>
        state = '%';
 4b8:	89d2                	mv	s3,s4
 4ba:	b7f5                	j	4a6 <vprintf+0x60>
      if(c == 'd'){
 4bc:	11490c63          	beq	s2,s4,5d4 <vprintf+0x18e>
 4c0:	f9d9079b          	addiw	a5,s2,-99
 4c4:	0ff7f793          	zext.b	a5,a5
 4c8:	10fc6e63          	bltu	s8,a5,5e4 <vprintf+0x19e>
 4cc:	f9d9079b          	addiw	a5,s2,-99
 4d0:	0ff7f713          	zext.b	a4,a5
 4d4:	10ec6863          	bltu	s8,a4,5e4 <vprintf+0x19e>
 4d8:	00271793          	slli	a5,a4,0x2
 4dc:	97e6                	add	a5,a5,s9
 4de:	439c                	lw	a5,0(a5)
 4e0:	97e6                	add	a5,a5,s9
 4e2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4e4:	008b0913          	addi	s2,s6,8
 4e8:	4685                	li	a3,1
 4ea:	4629                	li	a2,10
 4ec:	000b2583          	lw	a1,0(s6)
 4f0:	8556                	mv	a0,s5
 4f2:	00000097          	auipc	ra,0x0
 4f6:	ea8080e7          	jalr	-344(ra) # 39a <printint>
 4fa:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4fc:	4981                	li	s3,0
 4fe:	b765                	j	4a6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 500:	008b0913          	addi	s2,s6,8
 504:	4681                	li	a3,0
 506:	4629                	li	a2,10
 508:	000b2583          	lw	a1,0(s6)
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	e8c080e7          	jalr	-372(ra) # 39a <printint>
 516:	8b4a                	mv	s6,s2
      state = 0;
 518:	4981                	li	s3,0
 51a:	b771                	j	4a6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 51c:	008b0913          	addi	s2,s6,8
 520:	4681                	li	a3,0
 522:	866a                	mv	a2,s10
 524:	000b2583          	lw	a1,0(s6)
 528:	8556                	mv	a0,s5
 52a:	00000097          	auipc	ra,0x0
 52e:	e70080e7          	jalr	-400(ra) # 39a <printint>
 532:	8b4a                	mv	s6,s2
      state = 0;
 534:	4981                	li	s3,0
 536:	bf85                	j	4a6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 538:	008b0793          	addi	a5,s6,8
 53c:	f8f43423          	sd	a5,-120(s0)
 540:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 544:	03000593          	li	a1,48
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	e2e080e7          	jalr	-466(ra) # 378 <putc>
  putc(fd, 'x');
 552:	07800593          	li	a1,120
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	e20080e7          	jalr	-480(ra) # 378 <putc>
 560:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 562:	03c9d793          	srli	a5,s3,0x3c
 566:	97de                	add	a5,a5,s7
 568:	0007c583          	lbu	a1,0(a5)
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	e0a080e7          	jalr	-502(ra) # 378 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 576:	0992                	slli	s3,s3,0x4
 578:	397d                	addiw	s2,s2,-1
 57a:	fe0914e3          	bnez	s2,562 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 57e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 582:	4981                	li	s3,0
 584:	b70d                	j	4a6 <vprintf+0x60>
        s = va_arg(ap, char*);
 586:	008b0913          	addi	s2,s6,8
 58a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 58e:	02098163          	beqz	s3,5b0 <vprintf+0x16a>
        while(*s != 0){
 592:	0009c583          	lbu	a1,0(s3)
 596:	c5ad                	beqz	a1,600 <vprintf+0x1ba>
          putc(fd, *s);
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	dde080e7          	jalr	-546(ra) # 378 <putc>
          s++;
 5a2:	0985                	addi	s3,s3,1
        while(*s != 0){
 5a4:	0009c583          	lbu	a1,0(s3)
 5a8:	f9e5                	bnez	a1,598 <vprintf+0x152>
        s = va_arg(ap, char*);
 5aa:	8b4a                	mv	s6,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	bde5                	j	4a6 <vprintf+0x60>
          s = "(null)";
 5b0:	00000997          	auipc	s3,0x0
 5b4:	6e098993          	addi	s3,s3,1760 # c90 <get_time_perf+0x5c>
        while(*s != 0){
 5b8:	85ee                	mv	a1,s11
 5ba:	bff9                	j	598 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5bc:	008b0913          	addi	s2,s6,8
 5c0:	000b4583          	lbu	a1,0(s6)
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	db2080e7          	jalr	-590(ra) # 378 <putc>
 5ce:	8b4a                	mv	s6,s2
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bdd1                	j	4a6 <vprintf+0x60>
        putc(fd, c);
 5d4:	85d2                	mv	a1,s4
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	da0080e7          	jalr	-608(ra) # 378 <putc>
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b5d1                	j	4a6 <vprintf+0x60>
        putc(fd, '%');
 5e4:	85d2                	mv	a1,s4
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	d90080e7          	jalr	-624(ra) # 378 <putc>
        putc(fd, c);
 5f0:	85ca                	mv	a1,s2
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	d84080e7          	jalr	-636(ra) # 378 <putc>
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b565                	j	4a6 <vprintf+0x60>
        s = va_arg(ap, char*);
 600:	8b4a                	mv	s6,s2
      state = 0;
 602:	4981                	li	s3,0
 604:	b54d                	j	4a6 <vprintf+0x60>
    }
  }
}
 606:	70e6                	ld	ra,120(sp)
 608:	7446                	ld	s0,112(sp)
 60a:	74a6                	ld	s1,104(sp)
 60c:	7906                	ld	s2,96(sp)
 60e:	69e6                	ld	s3,88(sp)
 610:	6a46                	ld	s4,80(sp)
 612:	6aa6                	ld	s5,72(sp)
 614:	6b06                	ld	s6,64(sp)
 616:	7be2                	ld	s7,56(sp)
 618:	7c42                	ld	s8,48(sp)
 61a:	7ca2                	ld	s9,40(sp)
 61c:	7d02                	ld	s10,32(sp)
 61e:	6de2                	ld	s11,24(sp)
 620:	6109                	addi	sp,sp,128
 622:	8082                	ret

0000000000000624 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 624:	715d                	addi	sp,sp,-80
 626:	ec06                	sd	ra,24(sp)
 628:	e822                	sd	s0,16(sp)
 62a:	1000                	addi	s0,sp,32
 62c:	e010                	sd	a2,0(s0)
 62e:	e414                	sd	a3,8(s0)
 630:	e818                	sd	a4,16(s0)
 632:	ec1c                	sd	a5,24(s0)
 634:	03043023          	sd	a6,32(s0)
 638:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 63c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 640:	8622                	mv	a2,s0
 642:	00000097          	auipc	ra,0x0
 646:	e04080e7          	jalr	-508(ra) # 446 <vprintf>
}
 64a:	60e2                	ld	ra,24(sp)
 64c:	6442                	ld	s0,16(sp)
 64e:	6161                	addi	sp,sp,80
 650:	8082                	ret

0000000000000652 <printf>:

void
printf(const char *fmt, ...)
{
 652:	711d                	addi	sp,sp,-96
 654:	ec06                	sd	ra,24(sp)
 656:	e822                	sd	s0,16(sp)
 658:	1000                	addi	s0,sp,32
 65a:	e40c                	sd	a1,8(s0)
 65c:	e810                	sd	a2,16(s0)
 65e:	ec14                	sd	a3,24(s0)
 660:	f018                	sd	a4,32(s0)
 662:	f41c                	sd	a5,40(s0)
 664:	03043823          	sd	a6,48(s0)
 668:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 66c:	00840613          	addi	a2,s0,8
 670:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 674:	85aa                	mv	a1,a0
 676:	4505                	li	a0,1
 678:	00000097          	auipc	ra,0x0
 67c:	dce080e7          	jalr	-562(ra) # 446 <vprintf>
}
 680:	60e2                	ld	ra,24(sp)
 682:	6442                	ld	s0,16(sp)
 684:	6125                	addi	sp,sp,96
 686:	8082                	ret

0000000000000688 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 688:	1141                	addi	sp,sp,-16
 68a:	e422                	sd	s0,8(sp)
 68c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 692:	00001797          	auipc	a5,0x1
 696:	96e7b783          	ld	a5,-1682(a5) # 1000 <freep>
 69a:	a02d                	j	6c4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 69c:	4618                	lw	a4,8(a2)
 69e:	9f2d                	addw	a4,a4,a1
 6a0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a4:	6398                	ld	a4,0(a5)
 6a6:	6310                	ld	a2,0(a4)
 6a8:	a83d                	j	6e6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6aa:	ff852703          	lw	a4,-8(a0)
 6ae:	9f31                	addw	a4,a4,a2
 6b0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6b2:	ff053683          	ld	a3,-16(a0)
 6b6:	a091                	j	6fa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b8:	6398                	ld	a4,0(a5)
 6ba:	00e7e463          	bltu	a5,a4,6c2 <free+0x3a>
 6be:	00e6ea63          	bltu	a3,a4,6d2 <free+0x4a>
{
 6c2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c4:	fed7fae3          	bgeu	a5,a3,6b8 <free+0x30>
 6c8:	6398                	ld	a4,0(a5)
 6ca:	00e6e463          	bltu	a3,a4,6d2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ce:	fee7eae3          	bltu	a5,a4,6c2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6d2:	ff852583          	lw	a1,-8(a0)
 6d6:	6390                	ld	a2,0(a5)
 6d8:	02059813          	slli	a6,a1,0x20
 6dc:	01c85713          	srli	a4,a6,0x1c
 6e0:	9736                	add	a4,a4,a3
 6e2:	fae60de3          	beq	a2,a4,69c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6e6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6ea:	4790                	lw	a2,8(a5)
 6ec:	02061593          	slli	a1,a2,0x20
 6f0:	01c5d713          	srli	a4,a1,0x1c
 6f4:	973e                	add	a4,a4,a5
 6f6:	fae68ae3          	beq	a3,a4,6aa <free+0x22>
    p->s.ptr = bp->s.ptr;
 6fa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6fc:	00001717          	auipc	a4,0x1
 700:	90f73223          	sd	a5,-1788(a4) # 1000 <freep>
}
 704:	6422                	ld	s0,8(sp)
 706:	0141                	addi	sp,sp,16
 708:	8082                	ret

000000000000070a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 70a:	7139                	addi	sp,sp,-64
 70c:	fc06                	sd	ra,56(sp)
 70e:	f822                	sd	s0,48(sp)
 710:	f426                	sd	s1,40(sp)
 712:	f04a                	sd	s2,32(sp)
 714:	ec4e                	sd	s3,24(sp)
 716:	e852                	sd	s4,16(sp)
 718:	e456                	sd	s5,8(sp)
 71a:	e05a                	sd	s6,0(sp)
 71c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71e:	02051493          	slli	s1,a0,0x20
 722:	9081                	srli	s1,s1,0x20
 724:	04bd                	addi	s1,s1,15
 726:	8091                	srli	s1,s1,0x4
 728:	0014899b          	addiw	s3,s1,1
 72c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 72e:	00001517          	auipc	a0,0x1
 732:	8d253503          	ld	a0,-1838(a0) # 1000 <freep>
 736:	c515                	beqz	a0,762 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 738:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 73a:	4798                	lw	a4,8(a5)
 73c:	02977f63          	bgeu	a4,s1,77a <malloc+0x70>
 740:	8a4e                	mv	s4,s3
 742:	0009871b          	sext.w	a4,s3
 746:	6685                	lui	a3,0x1
 748:	00d77363          	bgeu	a4,a3,74e <malloc+0x44>
 74c:	6a05                	lui	s4,0x1
 74e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 752:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 756:	00001917          	auipc	s2,0x1
 75a:	8aa90913          	addi	s2,s2,-1878 # 1000 <freep>
  if(p == (char*)-1)
 75e:	5afd                	li	s5,-1
 760:	a895                	j	7d4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 762:	00001797          	auipc	a5,0x1
 766:	8ae78793          	addi	a5,a5,-1874 # 1010 <base>
 76a:	00001717          	auipc	a4,0x1
 76e:	88f73b23          	sd	a5,-1898(a4) # 1000 <freep>
 772:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 774:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 778:	b7e1                	j	740 <malloc+0x36>
      if(p->s.size == nunits)
 77a:	02e48c63          	beq	s1,a4,7b2 <malloc+0xa8>
        p->s.size -= nunits;
 77e:	4137073b          	subw	a4,a4,s3
 782:	c798                	sw	a4,8(a5)
        p += p->s.size;
 784:	02071693          	slli	a3,a4,0x20
 788:	01c6d713          	srli	a4,a3,0x1c
 78c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 78e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 792:	00001717          	auipc	a4,0x1
 796:	86a73723          	sd	a0,-1938(a4) # 1000 <freep>
      return (void*)(p + 1);
 79a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 79e:	70e2                	ld	ra,56(sp)
 7a0:	7442                	ld	s0,48(sp)
 7a2:	74a2                	ld	s1,40(sp)
 7a4:	7902                	ld	s2,32(sp)
 7a6:	69e2                	ld	s3,24(sp)
 7a8:	6a42                	ld	s4,16(sp)
 7aa:	6aa2                	ld	s5,8(sp)
 7ac:	6b02                	ld	s6,0(sp)
 7ae:	6121                	addi	sp,sp,64
 7b0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7b2:	6398                	ld	a4,0(a5)
 7b4:	e118                	sd	a4,0(a0)
 7b6:	bff1                	j	792 <malloc+0x88>
  hp->s.size = nu;
 7b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7bc:	0541                	addi	a0,a0,16
 7be:	00000097          	auipc	ra,0x0
 7c2:	eca080e7          	jalr	-310(ra) # 688 <free>
  return freep;
 7c6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7ca:	d971                	beqz	a0,79e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ce:	4798                	lw	a4,8(a5)
 7d0:	fa9775e3          	bgeu	a4,s1,77a <malloc+0x70>
    if(p == freep)
 7d4:	00093703          	ld	a4,0(s2)
 7d8:	853e                	mv	a0,a5
 7da:	fef719e3          	bne	a4,a5,7cc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7de:	8552                	mv	a0,s4
 7e0:	00000097          	auipc	ra,0x0
 7e4:	b58080e7          	jalr	-1192(ra) # 338 <sbrk>
  if(p == (char*)-1)
 7e8:	fd5518e3          	bne	a0,s5,7b8 <malloc+0xae>
        return 0;
 7ec:	4501                	li	a0,0
 7ee:	bf45                	j	79e <malloc+0x94>

00000000000007f0 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 7f0:	c1d9                	beqz	a1,876 <head_run+0x86>
void head_run(int fd, int numOfLines){
 7f2:	dd010113          	addi	sp,sp,-560
 7f6:	22113423          	sd	ra,552(sp)
 7fa:	22813023          	sd	s0,544(sp)
 7fe:	20913c23          	sd	s1,536(sp)
 802:	21213823          	sd	s2,528(sp)
 806:	21313423          	sd	s3,520(sp)
 80a:	21413023          	sd	s4,512(sp)
 80e:	1c00                	addi	s0,sp,560
 810:	892a                	mv	s2,a0
 812:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 816:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 818:	00000a17          	auipc	s4,0x0
 81c:	518a0a13          	addi	s4,s4,1304 # d30 <digits+0x40>
		readStatus = read_line(fd, line);
 820:	dd840593          	addi	a1,s0,-552
 824:	854a                	mv	a0,s2
 826:	00000097          	auipc	ra,0x0
 82a:	394080e7          	jalr	916(ra) # bba <read_line>
		if (readStatus == READ_ERROR){
 82e:	01350d63          	beq	a0,s3,848 <head_run+0x58>
		if (readStatus == READ_EOF)
 832:	c11d                	beqz	a0,858 <head_run+0x68>
		printf("%s",line);
 834:	dd840593          	addi	a1,s0,-552
 838:	8552                	mv	a0,s4
 83a:	00000097          	auipc	ra,0x0
 83e:	e18080e7          	jalr	-488(ra) # 652 <printf>
	while(numOfLines--){
 842:	34fd                	addiw	s1,s1,-1
 844:	fcf1                	bnez	s1,820 <head_run+0x30>
 846:	a809                	j	858 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 848:	00000517          	auipc	a0,0x0
 84c:	4c050513          	addi	a0,a0,1216 # d08 <digits+0x18>
 850:	00000097          	auipc	ra,0x0
 854:	e02080e7          	jalr	-510(ra) # 652 <printf>

	}
}
 858:	22813083          	ld	ra,552(sp)
 85c:	22013403          	ld	s0,544(sp)
 860:	21813483          	ld	s1,536(sp)
 864:	21013903          	ld	s2,528(sp)
 868:	20813983          	ld	s3,520(sp)
 86c:	20013a03          	ld	s4,512(sp)
 870:	23010113          	addi	sp,sp,560
 874:	8082                	ret
 876:	8082                	ret

0000000000000878 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 878:	ba010113          	addi	sp,sp,-1120
 87c:	44113c23          	sd	ra,1112(sp)
 880:	44813823          	sd	s0,1104(sp)
 884:	44913423          	sd	s1,1096(sp)
 888:	45213023          	sd	s2,1088(sp)
 88c:	43313c23          	sd	s3,1080(sp)
 890:	43413823          	sd	s4,1072(sp)
 894:	43513423          	sd	s5,1064(sp)
 898:	43613023          	sd	s6,1056(sp)
 89c:	41713c23          	sd	s7,1048(sp)
 8a0:	41813823          	sd	s8,1040(sp)
 8a4:	41913423          	sd	s9,1032(sp)
 8a8:	41a13023          	sd	s10,1024(sp)
 8ac:	3fb13c23          	sd	s11,1016(sp)
 8b0:	46010413          	addi	s0,sp,1120
 8b4:	89aa                	mv	s3,a0
 8b6:	8aae                	mv	s5,a1
 8b8:	8c32                	mv	s8,a2
 8ba:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 8bc:	d9840593          	addi	a1,s0,-616
 8c0:	00000097          	auipc	ra,0x0
 8c4:	2fa080e7          	jalr	762(ra) # bba <read_line>


  if (readStatus == READ_ERROR)
 8c8:	57fd                	li	a5,-1
 8ca:	04f50163          	beq	a0,a5,90c <uniq_run+0x94>
 8ce:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 8d0:	ed21                	bnez	a0,928 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 8d2:	45813083          	ld	ra,1112(sp)
 8d6:	45013403          	ld	s0,1104(sp)
 8da:	44813483          	ld	s1,1096(sp)
 8de:	44013903          	ld	s2,1088(sp)
 8e2:	43813983          	ld	s3,1080(sp)
 8e6:	43013a03          	ld	s4,1072(sp)
 8ea:	42813a83          	ld	s5,1064(sp)
 8ee:	42013b03          	ld	s6,1056(sp)
 8f2:	41813b83          	ld	s7,1048(sp)
 8f6:	41013c03          	ld	s8,1040(sp)
 8fa:	40813c83          	ld	s9,1032(sp)
 8fe:	40013d03          	ld	s10,1024(sp)
 902:	3f813d83          	ld	s11,1016(sp)
 906:	46010113          	addi	sp,sp,1120
 90a:	8082                	ret
    printf("[ERR] Error reading from the file ");
 90c:	00000517          	auipc	a0,0x0
 910:	42c50513          	addi	a0,a0,1068 # d38 <digits+0x48>
 914:	00000097          	auipc	ra,0x0
 918:	d3e080e7          	jalr	-706(ra) # 652 <printf>
 91c:	bf5d                	j	8d2 <uniq_run+0x5a>
 91e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 920:	8926                	mv	s2,s1
 922:	84be                	mv	s1,a5
        lineCount = 1;
 924:	8b6a                	mv	s6,s10
 926:	a8ed                	j	a20 <uniq_run+0x1a8>
    int lineCount=1;
 928:	4b05                	li	s6,1
  char * line2 = buffer2;
 92a:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 92e:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 932:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 934:	4d05                	li	s10,1
              printf("%s",line1);
 936:	00000d97          	auipc	s11,0x0
 93a:	3fad8d93          	addi	s11,s11,1018 # d30 <digits+0x40>
 93e:	a0cd                	j	a20 <uniq_run+0x1a8>
            if (repeatedLines){
 940:	020a0b63          	beqz	s4,976 <uniq_run+0xfe>
                if (isRepeated){
 944:	f80b87e3          	beqz	s7,8d2 <uniq_run+0x5a>
                    if (showCount)
 948:	000c0d63          	beqz	s8,962 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 94c:	864a                	mv	a2,s2
 94e:	85da                	mv	a1,s6
 950:	00000517          	auipc	a0,0x0
 954:	41050513          	addi	a0,a0,1040 # d60 <digits+0x70>
 958:	00000097          	auipc	ra,0x0
 95c:	cfa080e7          	jalr	-774(ra) # 652 <printf>
 960:	bf8d                	j	8d2 <uniq_run+0x5a>
                      printf("%s",line1);
 962:	85ca                	mv	a1,s2
 964:	00000517          	auipc	a0,0x0
 968:	3cc50513          	addi	a0,a0,972 # d30 <digits+0x40>
 96c:	00000097          	auipc	ra,0x0
 970:	ce6080e7          	jalr	-794(ra) # 652 <printf>
 974:	bfb9                	j	8d2 <uniq_run+0x5a>
                if (showCount)
 976:	000c0d63          	beqz	s8,990 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 97a:	864a                	mv	a2,s2
 97c:	85da                	mv	a1,s6
 97e:	00000517          	auipc	a0,0x0
 982:	3e250513          	addi	a0,a0,994 # d60 <digits+0x70>
 986:	00000097          	auipc	ra,0x0
 98a:	ccc080e7          	jalr	-820(ra) # 652 <printf>
 98e:	b791                	j	8d2 <uniq_run+0x5a>
                  printf("%s",line1);
 990:	85ca                	mv	a1,s2
 992:	00000517          	auipc	a0,0x0
 996:	39e50513          	addi	a0,a0,926 # d30 <digits+0x40>
 99a:	00000097          	auipc	ra,0x0
 99e:	cb8080e7          	jalr	-840(ra) # 652 <printf>
 9a2:	bf05                	j	8d2 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 9a4:	00000517          	auipc	a0,0x0
 9a8:	3c450513          	addi	a0,a0,964 # d68 <digits+0x78>
 9ac:	00000097          	auipc	ra,0x0
 9b0:	ca6080e7          	jalr	-858(ra) # 652 <printf>
          break;
 9b4:	bf39                	j	8d2 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 9b6:	85a6                	mv	a1,s1
 9b8:	854a                	mv	a0,s2
 9ba:	00000097          	auipc	ra,0x0
 9be:	110080e7          	jalr	272(ra) # aca <compare_str_ic>
 9c2:	a041                	j	a42 <uniq_run+0x1ca>
                  printf("%s",line1);
 9c4:	85ca                	mv	a1,s2
 9c6:	856e                	mv	a0,s11
 9c8:	00000097          	auipc	ra,0x0
 9cc:	c8a080e7          	jalr	-886(ra) # 652 <printf>
        lineCount = 1;
 9d0:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 9d2:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 9d4:	8926                	mv	s2,s1
                  printf("%s",line1);
 9d6:	84be                	mv	s1,a5
        isRepeated = 0 ;
 9d8:	4b81                	li	s7,0
 9da:	a099                	j	a20 <uniq_run+0x1a8>
            if (showCount)
 9dc:	020c0263          	beqz	s8,a00 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 9e0:	864a                	mv	a2,s2
 9e2:	85da                	mv	a1,s6
 9e4:	00000517          	auipc	a0,0x0
 9e8:	37c50513          	addi	a0,a0,892 # d60 <digits+0x70>
 9ec:	00000097          	auipc	ra,0x0
 9f0:	c66080e7          	jalr	-922(ra) # 652 <printf>
 9f4:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 9f6:	8926                	mv	s2,s1
 9f8:	84be                	mv	s1,a5
        isRepeated = 0 ;
 9fa:	4b81                	li	s7,0
        lineCount = 1;
 9fc:	8b6a                	mv	s6,s10
 9fe:	a00d                	j	a20 <uniq_run+0x1a8>
              printf("%s",line1);
 a00:	85ca                	mv	a1,s2
 a02:	856e                	mv	a0,s11
 a04:	00000097          	auipc	ra,0x0
 a08:	c4e080e7          	jalr	-946(ra) # 652 <printf>
 a0c:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a0e:	8926                	mv	s2,s1
              printf("%s",line1);
 a10:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a12:	4b81                	li	s7,0
        lineCount = 1;
 a14:	8b6a                	mv	s6,s10
 a16:	a029                	j	a20 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 a18:	000a0363          	beqz	s4,a1e <uniq_run+0x1a6>
 a1c:	8bea                	mv	s7,s10
          lineCount++;
 a1e:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 a20:	85a6                	mv	a1,s1
 a22:	854e                	mv	a0,s3
 a24:	00000097          	auipc	ra,0x0
 a28:	196080e7          	jalr	406(ra) # bba <read_line>
        if (readStatus == READ_EOF){
 a2c:	d911                	beqz	a0,940 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 a2e:	f7950be3          	beq	a0,s9,9a4 <uniq_run+0x12c>
        if (!ignoreCase)
 a32:	f80a92e3          	bnez	s5,9b6 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 a36:	85a6                	mv	a1,s1
 a38:	854a                	mv	a0,s2
 a3a:	00000097          	auipc	ra,0x0
 a3e:	062080e7          	jalr	98(ra) # a9c <compare_str>
        if (compareStatus != 0){ 
 a42:	d979                	beqz	a0,a18 <uniq_run+0x1a0>
          if (repeatedLines){
 a44:	f80a0ce3          	beqz	s4,9dc <uniq_run+0x164>
            if (isRepeated){
 a48:	ec0b8be3          	beqz	s7,91e <uniq_run+0xa6>
                if (showCount)
 a4c:	f60c0ce3          	beqz	s8,9c4 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 a50:	864a                	mv	a2,s2
 a52:	85da                	mv	a1,s6
 a54:	00000517          	auipc	a0,0x0
 a58:	30c50513          	addi	a0,a0,780 # d60 <digits+0x70>
 a5c:	00000097          	auipc	ra,0x0
 a60:	bf6080e7          	jalr	-1034(ra) # 652 <printf>
        lineCount = 1;
 a64:	8b5e                	mv	s6,s7
 a66:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a68:	8926                	mv	s2,s1
 a6a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a6c:	4b81                	li	s7,0
 a6e:	bf4d                	j	a20 <uniq_run+0x1a8>

0000000000000a70 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 a70:	1141                	addi	sp,sp,-16
 a72:	e422                	sd	s0,8(sp)
 a74:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 a76:	00054783          	lbu	a5,0(a0)
 a7a:	cf99                	beqz	a5,a98 <get_strlen+0x28>
 a7c:	00150713          	addi	a4,a0,1
 a80:	87ba                	mv	a5,a4
 a82:	4685                	li	a3,1
 a84:	9e99                	subw	a3,a3,a4
 a86:	00f6853b          	addw	a0,a3,a5
 a8a:	0785                	addi	a5,a5,1
 a8c:	fff7c703          	lbu	a4,-1(a5)
 a90:	fb7d                	bnez	a4,a86 <get_strlen+0x16>
	return len;
}
 a92:	6422                	ld	s0,8(sp)
 a94:	0141                	addi	sp,sp,16
 a96:	8082                	ret
	int len = 0;
 a98:	4501                	li	a0,0
 a9a:	bfe5                	j	a92 <get_strlen+0x22>

0000000000000a9c <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 a9c:	1141                	addi	sp,sp,-16
 a9e:	e422                	sd	s0,8(sp)
 aa0:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 aa2:	00054783          	lbu	a5,0(a0)
 aa6:	cb91                	beqz	a5,aba <compare_str+0x1e>
 aa8:	0005c703          	lbu	a4,0(a1)
 aac:	c719                	beqz	a4,aba <compare_str+0x1e>
		if (*s1++ != *s2++)
 aae:	0505                	addi	a0,a0,1
 ab0:	0585                	addi	a1,a1,1
 ab2:	fee788e3          	beq	a5,a4,aa2 <compare_str+0x6>
			return 1;
 ab6:	4505                	li	a0,1
 ab8:	a031                	j	ac4 <compare_str+0x28>
	}
	if (*s1 == *s2)
 aba:	0005c503          	lbu	a0,0(a1)
 abe:	8d1d                	sub	a0,a0,a5
			return 1;
 ac0:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 ac4:	6422                	ld	s0,8(sp)
 ac6:	0141                	addi	sp,sp,16
 ac8:	8082                	ret

0000000000000aca <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 aca:	1141                	addi	sp,sp,-16
 acc:	e422                	sd	s0,8(sp)
 ace:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 ad0:	4665                	li	a2,25
	while(*s1 && *s2){
 ad2:	a019                	j	ad8 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 ad4:	04e79763          	bne	a5,a4,b22 <compare_str_ic+0x58>
	while(*s1 && *s2){
 ad8:	00054783          	lbu	a5,0(a0)
 adc:	cb9d                	beqz	a5,b12 <compare_str_ic+0x48>
 ade:	0005c703          	lbu	a4,0(a1)
 ae2:	cb05                	beqz	a4,b12 <compare_str_ic+0x48>
		char b1 = *s1++;
 ae4:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 ae6:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 ae8:	fbf7869b          	addiw	a3,a5,-65
 aec:	0ff6f693          	zext.b	a3,a3
 af0:	00d66663          	bltu	a2,a3,afc <compare_str_ic+0x32>
			b1 += 32;
 af4:	0207879b          	addiw	a5,a5,32
 af8:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 afc:	fbf7069b          	addiw	a3,a4,-65
 b00:	0ff6f693          	zext.b	a3,a3
 b04:	fcd668e3          	bltu	a2,a3,ad4 <compare_str_ic+0xa>
			b2 += 32;
 b08:	0207071b          	addiw	a4,a4,32
 b0c:	0ff77713          	zext.b	a4,a4
 b10:	b7d1                	j	ad4 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 b12:	0005c503          	lbu	a0,0(a1)
 b16:	8d1d                	sub	a0,a0,a5
			return 1;
 b18:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b1c:	6422                	ld	s0,8(sp)
 b1e:	0141                	addi	sp,sp,16
 b20:	8082                	ret
			return 1;
 b22:	4505                	li	a0,1
 b24:	bfe5                	j	b1c <compare_str_ic+0x52>

0000000000000b26 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 b26:	7179                	addi	sp,sp,-48
 b28:	f406                	sd	ra,40(sp)
 b2a:	f022                	sd	s0,32(sp)
 b2c:	ec26                	sd	s1,24(sp)
 b2e:	e84a                	sd	s2,16(sp)
 b30:	e44e                	sd	s3,8(sp)
 b32:	1800                	addi	s0,sp,48
 b34:	89aa                	mv	s3,a0
 b36:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 b38:	00000097          	auipc	ra,0x0
 b3c:	f38080e7          	jalr	-200(ra) # a70 <get_strlen>
 b40:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 b42:	854a                	mv	a0,s2
 b44:	00000097          	auipc	ra,0x0
 b48:	f2c080e7          	jalr	-212(ra) # a70 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 b4c:	409505bb          	subw	a1,a0,s1
 b50:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 b52:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 b54:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 b56:	0005da63          	bgez	a1,b6a <check_substr+0x44>
 b5a:	a81d                	j	b90 <check_substr+0x6a>
        if (j == M)
 b5c:	02f48a63          	beq	s1,a5,b90 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 b60:	0885                	addi	a7,a7,1
 b62:	0008879b          	sext.w	a5,a7
 b66:	02f5cc63          	blt	a1,a5,b9e <check_substr+0x78>
 b6a:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 b6e:	011906b3          	add	a3,s2,a7
 b72:	874e                	mv	a4,s3
 b74:	879a                	mv	a5,t1
 b76:	fe9053e3          	blez	s1,b5c <check_substr+0x36>
            if (s2[i + j] != s1[j])
 b7a:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 b7e:	00074603          	lbu	a2,0(a4)
 b82:	fcc81de3          	bne	a6,a2,b5c <check_substr+0x36>
        for (j = 0; j < M; j++)
 b86:	2785                	addiw	a5,a5,1
 b88:	0685                	addi	a3,a3,1
 b8a:	0705                	addi	a4,a4,1
 b8c:	fef497e3          	bne	s1,a5,b7a <check_substr+0x54>
}
 b90:	70a2                	ld	ra,40(sp)
 b92:	7402                	ld	s0,32(sp)
 b94:	64e2                	ld	s1,24(sp)
 b96:	6942                	ld	s2,16(sp)
 b98:	69a2                	ld	s3,8(sp)
 b9a:	6145                	addi	sp,sp,48
 b9c:	8082                	ret
    return -1;
 b9e:	557d                	li	a0,-1
 ba0:	bfc5                	j	b90 <check_substr+0x6a>

0000000000000ba2 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 ba2:	1141                	addi	sp,sp,-16
 ba4:	e406                	sd	ra,8(sp)
 ba6:	e022                	sd	s0,0(sp)
 ba8:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 baa:	fffff097          	auipc	ra,0xfffff
 bae:	746080e7          	jalr	1862(ra) # 2f0 <open>
	return fd;
}
 bb2:	60a2                	ld	ra,8(sp)
 bb4:	6402                	ld	s0,0(sp)
 bb6:	0141                	addi	sp,sp,16
 bb8:	8082                	ret

0000000000000bba <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 bba:	7139                	addi	sp,sp,-64
 bbc:	fc06                	sd	ra,56(sp)
 bbe:	f822                	sd	s0,48(sp)
 bc0:	f426                	sd	s1,40(sp)
 bc2:	f04a                	sd	s2,32(sp)
 bc4:	ec4e                	sd	s3,24(sp)
 bc6:	e852                	sd	s4,16(sp)
 bc8:	0080                	addi	s0,sp,64
 bca:	89aa                	mv	s3,a0
 bcc:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 bce:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 bd0:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 bd2:	4605                	li	a2,1
 bd4:	fcf40593          	addi	a1,s0,-49
 bd8:	854e                	mv	a0,s3
 bda:	fffff097          	auipc	ra,0xfffff
 bde:	6ee080e7          	jalr	1774(ra) # 2c8 <read>
		if (readStatus == 0){
 be2:	c505                	beqz	a0,c0a <read_line+0x50>
		*buffer++ = readByte;
 be4:	0485                	addi	s1,s1,1
 be6:	fcf44783          	lbu	a5,-49(s0)
 bea:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 bee:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 bf0:	ff4791e3          	bne	a5,s4,bd2 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 bf4:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 bf8:	854a                	mv	a0,s2
 bfa:	70e2                	ld	ra,56(sp)
 bfc:	7442                	ld	s0,48(sp)
 bfe:	74a2                	ld	s1,40(sp)
 c00:	7902                	ld	s2,32(sp)
 c02:	69e2                	ld	s3,24(sp)
 c04:	6a42                	ld	s4,16(sp)
 c06:	6121                	addi	sp,sp,64
 c08:	8082                	ret
			if (byteCount!=0){
 c0a:	fe0907e3          	beqz	s2,bf8 <read_line+0x3e>
				*buffer = '\n';
 c0e:	47a9                	li	a5,10
 c10:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 c14:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 c18:	2905                	addiw	s2,s2,1
 c1a:	bff9                	j	bf8 <read_line+0x3e>

0000000000000c1c <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c1c:	1141                	addi	sp,sp,-16
 c1e:	e406                	sd	ra,8(sp)
 c20:	e022                	sd	s0,0(sp)
 c22:	0800                	addi	s0,sp,16
	close(fd);
 c24:	fffff097          	auipc	ra,0xfffff
 c28:	6b4080e7          	jalr	1716(ra) # 2d8 <close>
}
 c2c:	60a2                	ld	ra,8(sp)
 c2e:	6402                	ld	s0,0(sp)
 c30:	0141                	addi	sp,sp,16
 c32:	8082                	ret

0000000000000c34 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 c34:	7139                	addi	sp,sp,-64
 c36:	fc06                	sd	ra,56(sp)
 c38:	f822                	sd	s0,48(sp)
 c3a:	f426                	sd	s1,40(sp)
 c3c:	f04a                	sd	s2,32(sp)
 c3e:	0080                	addi	s0,sp,64
 c40:	84aa                	mv	s1,a0
 c42:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 c44:	fffff097          	auipc	ra,0xfffff
 c48:	664080e7          	jalr	1636(ra) # 2a8 <fork>
 c4c:	ed19                	bnez	a0,c6a <get_time_perf+0x36>
		exec(argv[0],argv);
 c4e:	85ca                	mv	a1,s2
 c50:	00093503          	ld	a0,0(s2)
 c54:	fffff097          	auipc	ra,0xfffff
 c58:	694080e7          	jalr	1684(ra) # 2e8 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 c5c:	8526                	mv	a0,s1
 c5e:	70e2                	ld	ra,56(sp)
 c60:	7442                	ld	s0,48(sp)
 c62:	74a2                	ld	s1,40(sp)
 c64:	7902                	ld	s2,32(sp)
 c66:	6121                	addi	sp,sp,64
 c68:	8082                	ret
		times(pid , &time);
 c6a:	fc840593          	addi	a1,s0,-56
 c6e:	fffff097          	auipc	ra,0xfffff
 c72:	6fa080e7          	jalr	1786(ra) # 368 <times>
		return time;
 c76:	fc843783          	ld	a5,-56(s0)
 c7a:	e09c                	sd	a5,0(s1)
 c7c:	fd043783          	ld	a5,-48(s0)
 c80:	e49c                	sd	a5,8(s1)
 c82:	fd843783          	ld	a5,-40(s0)
 c86:	e89c                	sd	a5,16(s1)
 c88:	bfd1                	j	c5c <get_time_perf+0x28>
