
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

0000000000000360 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 360:	1101                	addi	sp,sp,-32
 362:	ec06                	sd	ra,24(sp)
 364:	e822                	sd	s0,16(sp)
 366:	1000                	addi	s0,sp,32
 368:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 36c:	4605                	li	a2,1
 36e:	fef40593          	addi	a1,s0,-17
 372:	00000097          	auipc	ra,0x0
 376:	f5e080e7          	jalr	-162(ra) # 2d0 <write>
}
 37a:	60e2                	ld	ra,24(sp)
 37c:	6442                	ld	s0,16(sp)
 37e:	6105                	addi	sp,sp,32
 380:	8082                	ret

0000000000000382 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 382:	7139                	addi	sp,sp,-64
 384:	fc06                	sd	ra,56(sp)
 386:	f822                	sd	s0,48(sp)
 388:	f426                	sd	s1,40(sp)
 38a:	f04a                	sd	s2,32(sp)
 38c:	ec4e                	sd	s3,24(sp)
 38e:	0080                	addi	s0,sp,64
 390:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 392:	c299                	beqz	a3,398 <printint+0x16>
 394:	0805c963          	bltz	a1,426 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 398:	2581                	sext.w	a1,a1
  neg = 0;
 39a:	4881                	li	a7,0
 39c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a2:	2601                	sext.w	a2,a2
 3a4:	00001517          	auipc	a0,0x1
 3a8:	85c50513          	addi	a0,a0,-1956 # c00 <digits>
 3ac:	883a                	mv	a6,a4
 3ae:	2705                	addiw	a4,a4,1
 3b0:	02c5f7bb          	remuw	a5,a1,a2
 3b4:	1782                	slli	a5,a5,0x20
 3b6:	9381                	srli	a5,a5,0x20
 3b8:	97aa                	add	a5,a5,a0
 3ba:	0007c783          	lbu	a5,0(a5)
 3be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c2:	0005879b          	sext.w	a5,a1
 3c6:	02c5d5bb          	divuw	a1,a1,a2
 3ca:	0685                	addi	a3,a3,1
 3cc:	fec7f0e3          	bgeu	a5,a2,3ac <printint+0x2a>
  if(neg)
 3d0:	00088c63          	beqz	a7,3e8 <printint+0x66>
    buf[i++] = '-';
 3d4:	fd070793          	addi	a5,a4,-48
 3d8:	00878733          	add	a4,a5,s0
 3dc:	02d00793          	li	a5,45
 3e0:	fef70823          	sb	a5,-16(a4)
 3e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e8:	02e05863          	blez	a4,418 <printint+0x96>
 3ec:	fc040793          	addi	a5,s0,-64
 3f0:	00e78933          	add	s2,a5,a4
 3f4:	fff78993          	addi	s3,a5,-1
 3f8:	99ba                	add	s3,s3,a4
 3fa:	377d                	addiw	a4,a4,-1
 3fc:	1702                	slli	a4,a4,0x20
 3fe:	9301                	srli	a4,a4,0x20
 400:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 404:	fff94583          	lbu	a1,-1(s2)
 408:	8526                	mv	a0,s1
 40a:	00000097          	auipc	ra,0x0
 40e:	f56080e7          	jalr	-170(ra) # 360 <putc>
  while(--i >= 0)
 412:	197d                	addi	s2,s2,-1
 414:	ff3918e3          	bne	s2,s3,404 <printint+0x82>
}
 418:	70e2                	ld	ra,56(sp)
 41a:	7442                	ld	s0,48(sp)
 41c:	74a2                	ld	s1,40(sp)
 41e:	7902                	ld	s2,32(sp)
 420:	69e2                	ld	s3,24(sp)
 422:	6121                	addi	sp,sp,64
 424:	8082                	ret
    x = -xx;
 426:	40b005bb          	negw	a1,a1
    neg = 1;
 42a:	4885                	li	a7,1
    x = -xx;
 42c:	bf85                	j	39c <printint+0x1a>

000000000000042e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 42e:	7119                	addi	sp,sp,-128
 430:	fc86                	sd	ra,120(sp)
 432:	f8a2                	sd	s0,112(sp)
 434:	f4a6                	sd	s1,104(sp)
 436:	f0ca                	sd	s2,96(sp)
 438:	ecce                	sd	s3,88(sp)
 43a:	e8d2                	sd	s4,80(sp)
 43c:	e4d6                	sd	s5,72(sp)
 43e:	e0da                	sd	s6,64(sp)
 440:	fc5e                	sd	s7,56(sp)
 442:	f862                	sd	s8,48(sp)
 444:	f466                	sd	s9,40(sp)
 446:	f06a                	sd	s10,32(sp)
 448:	ec6e                	sd	s11,24(sp)
 44a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 44c:	0005c903          	lbu	s2,0(a1)
 450:	18090f63          	beqz	s2,5ee <vprintf+0x1c0>
 454:	8aaa                	mv	s5,a0
 456:	8b32                	mv	s6,a2
 458:	00158493          	addi	s1,a1,1
  state = 0;
 45c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45e:	02500a13          	li	s4,37
 462:	4c55                	li	s8,21
 464:	00000c97          	auipc	s9,0x0
 468:	744c8c93          	addi	s9,s9,1860 # ba8 <close_file+0x20>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 46c:	02800d93          	li	s11,40
  putc(fd, 'x');
 470:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 472:	00000b97          	auipc	s7,0x0
 476:	78eb8b93          	addi	s7,s7,1934 # c00 <digits>
 47a:	a839                	j	498 <vprintf+0x6a>
        putc(fd, c);
 47c:	85ca                	mv	a1,s2
 47e:	8556                	mv	a0,s5
 480:	00000097          	auipc	ra,0x0
 484:	ee0080e7          	jalr	-288(ra) # 360 <putc>
 488:	a019                	j	48e <vprintf+0x60>
    } else if(state == '%'){
 48a:	01498d63          	beq	s3,s4,4a4 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 48e:	0485                	addi	s1,s1,1
 490:	fff4c903          	lbu	s2,-1(s1)
 494:	14090d63          	beqz	s2,5ee <vprintf+0x1c0>
    if(state == 0){
 498:	fe0999e3          	bnez	s3,48a <vprintf+0x5c>
      if(c == '%'){
 49c:	ff4910e3          	bne	s2,s4,47c <vprintf+0x4e>
        state = '%';
 4a0:	89d2                	mv	s3,s4
 4a2:	b7f5                	j	48e <vprintf+0x60>
      if(c == 'd'){
 4a4:	11490c63          	beq	s2,s4,5bc <vprintf+0x18e>
 4a8:	f9d9079b          	addiw	a5,s2,-99
 4ac:	0ff7f793          	zext.b	a5,a5
 4b0:	10fc6e63          	bltu	s8,a5,5cc <vprintf+0x19e>
 4b4:	f9d9079b          	addiw	a5,s2,-99
 4b8:	0ff7f713          	zext.b	a4,a5
 4bc:	10ec6863          	bltu	s8,a4,5cc <vprintf+0x19e>
 4c0:	00271793          	slli	a5,a4,0x2
 4c4:	97e6                	add	a5,a5,s9
 4c6:	439c                	lw	a5,0(a5)
 4c8:	97e6                	add	a5,a5,s9
 4ca:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4cc:	008b0913          	addi	s2,s6,8
 4d0:	4685                	li	a3,1
 4d2:	4629                	li	a2,10
 4d4:	000b2583          	lw	a1,0(s6)
 4d8:	8556                	mv	a0,s5
 4da:	00000097          	auipc	ra,0x0
 4de:	ea8080e7          	jalr	-344(ra) # 382 <printint>
 4e2:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e4:	4981                	li	s3,0
 4e6:	b765                	j	48e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4e8:	008b0913          	addi	s2,s6,8
 4ec:	4681                	li	a3,0
 4ee:	4629                	li	a2,10
 4f0:	000b2583          	lw	a1,0(s6)
 4f4:	8556                	mv	a0,s5
 4f6:	00000097          	auipc	ra,0x0
 4fa:	e8c080e7          	jalr	-372(ra) # 382 <printint>
 4fe:	8b4a                	mv	s6,s2
      state = 0;
 500:	4981                	li	s3,0
 502:	b771                	j	48e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 504:	008b0913          	addi	s2,s6,8
 508:	4681                	li	a3,0
 50a:	866a                	mv	a2,s10
 50c:	000b2583          	lw	a1,0(s6)
 510:	8556                	mv	a0,s5
 512:	00000097          	auipc	ra,0x0
 516:	e70080e7          	jalr	-400(ra) # 382 <printint>
 51a:	8b4a                	mv	s6,s2
      state = 0;
 51c:	4981                	li	s3,0
 51e:	bf85                	j	48e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 520:	008b0793          	addi	a5,s6,8
 524:	f8f43423          	sd	a5,-120(s0)
 528:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 52c:	03000593          	li	a1,48
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	e2e080e7          	jalr	-466(ra) # 360 <putc>
  putc(fd, 'x');
 53a:	07800593          	li	a1,120
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	e20080e7          	jalr	-480(ra) # 360 <putc>
 548:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 54a:	03c9d793          	srli	a5,s3,0x3c
 54e:	97de                	add	a5,a5,s7
 550:	0007c583          	lbu	a1,0(a5)
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	e0a080e7          	jalr	-502(ra) # 360 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 55e:	0992                	slli	s3,s3,0x4
 560:	397d                	addiw	s2,s2,-1
 562:	fe0914e3          	bnez	s2,54a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 566:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b70d                	j	48e <vprintf+0x60>
        s = va_arg(ap, char*);
 56e:	008b0913          	addi	s2,s6,8
 572:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 576:	02098163          	beqz	s3,598 <vprintf+0x16a>
        while(*s != 0){
 57a:	0009c583          	lbu	a1,0(s3)
 57e:	c5ad                	beqz	a1,5e8 <vprintf+0x1ba>
          putc(fd, *s);
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	dde080e7          	jalr	-546(ra) # 360 <putc>
          s++;
 58a:	0985                	addi	s3,s3,1
        while(*s != 0){
 58c:	0009c583          	lbu	a1,0(s3)
 590:	f9e5                	bnez	a1,580 <vprintf+0x152>
        s = va_arg(ap, char*);
 592:	8b4a                	mv	s6,s2
      state = 0;
 594:	4981                	li	s3,0
 596:	bde5                	j	48e <vprintf+0x60>
          s = "(null)";
 598:	00000997          	auipc	s3,0x0
 59c:	60898993          	addi	s3,s3,1544 # ba0 <close_file+0x18>
        while(*s != 0){
 5a0:	85ee                	mv	a1,s11
 5a2:	bff9                	j	580 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5a4:	008b0913          	addi	s2,s6,8
 5a8:	000b4583          	lbu	a1,0(s6)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	db2080e7          	jalr	-590(ra) # 360 <putc>
 5b6:	8b4a                	mv	s6,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	bdd1                	j	48e <vprintf+0x60>
        putc(fd, c);
 5bc:	85d2                	mv	a1,s4
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	da0080e7          	jalr	-608(ra) # 360 <putc>
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	b5d1                	j	48e <vprintf+0x60>
        putc(fd, '%');
 5cc:	85d2                	mv	a1,s4
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	d90080e7          	jalr	-624(ra) # 360 <putc>
        putc(fd, c);
 5d8:	85ca                	mv	a1,s2
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	d84080e7          	jalr	-636(ra) # 360 <putc>
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b565                	j	48e <vprintf+0x60>
        s = va_arg(ap, char*);
 5e8:	8b4a                	mv	s6,s2
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b54d                	j	48e <vprintf+0x60>
    }
  }
}
 5ee:	70e6                	ld	ra,120(sp)
 5f0:	7446                	ld	s0,112(sp)
 5f2:	74a6                	ld	s1,104(sp)
 5f4:	7906                	ld	s2,96(sp)
 5f6:	69e6                	ld	s3,88(sp)
 5f8:	6a46                	ld	s4,80(sp)
 5fa:	6aa6                	ld	s5,72(sp)
 5fc:	6b06                	ld	s6,64(sp)
 5fe:	7be2                	ld	s7,56(sp)
 600:	7c42                	ld	s8,48(sp)
 602:	7ca2                	ld	s9,40(sp)
 604:	7d02                	ld	s10,32(sp)
 606:	6de2                	ld	s11,24(sp)
 608:	6109                	addi	sp,sp,128
 60a:	8082                	ret

000000000000060c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 60c:	715d                	addi	sp,sp,-80
 60e:	ec06                	sd	ra,24(sp)
 610:	e822                	sd	s0,16(sp)
 612:	1000                	addi	s0,sp,32
 614:	e010                	sd	a2,0(s0)
 616:	e414                	sd	a3,8(s0)
 618:	e818                	sd	a4,16(s0)
 61a:	ec1c                	sd	a5,24(s0)
 61c:	03043023          	sd	a6,32(s0)
 620:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 624:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 628:	8622                	mv	a2,s0
 62a:	00000097          	auipc	ra,0x0
 62e:	e04080e7          	jalr	-508(ra) # 42e <vprintf>
}
 632:	60e2                	ld	ra,24(sp)
 634:	6442                	ld	s0,16(sp)
 636:	6161                	addi	sp,sp,80
 638:	8082                	ret

000000000000063a <printf>:

void
printf(const char *fmt, ...)
{
 63a:	711d                	addi	sp,sp,-96
 63c:	ec06                	sd	ra,24(sp)
 63e:	e822                	sd	s0,16(sp)
 640:	1000                	addi	s0,sp,32
 642:	e40c                	sd	a1,8(s0)
 644:	e810                	sd	a2,16(s0)
 646:	ec14                	sd	a3,24(s0)
 648:	f018                	sd	a4,32(s0)
 64a:	f41c                	sd	a5,40(s0)
 64c:	03043823          	sd	a6,48(s0)
 650:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 654:	00840613          	addi	a2,s0,8
 658:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 65c:	85aa                	mv	a1,a0
 65e:	4505                	li	a0,1
 660:	00000097          	auipc	ra,0x0
 664:	dce080e7          	jalr	-562(ra) # 42e <vprintf>
}
 668:	60e2                	ld	ra,24(sp)
 66a:	6442                	ld	s0,16(sp)
 66c:	6125                	addi	sp,sp,96
 66e:	8082                	ret

0000000000000670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 670:	1141                	addi	sp,sp,-16
 672:	e422                	sd	s0,8(sp)
 674:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 676:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67a:	00001797          	auipc	a5,0x1
 67e:	9867b783          	ld	a5,-1658(a5) # 1000 <freep>
 682:	a02d                	j	6ac <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 684:	4618                	lw	a4,8(a2)
 686:	9f2d                	addw	a4,a4,a1
 688:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 68c:	6398                	ld	a4,0(a5)
 68e:	6310                	ld	a2,0(a4)
 690:	a83d                	j	6ce <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 692:	ff852703          	lw	a4,-8(a0)
 696:	9f31                	addw	a4,a4,a2
 698:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 69a:	ff053683          	ld	a3,-16(a0)
 69e:	a091                	j	6e2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a0:	6398                	ld	a4,0(a5)
 6a2:	00e7e463          	bltu	a5,a4,6aa <free+0x3a>
 6a6:	00e6ea63          	bltu	a3,a4,6ba <free+0x4a>
{
 6aa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ac:	fed7fae3          	bgeu	a5,a3,6a0 <free+0x30>
 6b0:	6398                	ld	a4,0(a5)
 6b2:	00e6e463          	bltu	a3,a4,6ba <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b6:	fee7eae3          	bltu	a5,a4,6aa <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6ba:	ff852583          	lw	a1,-8(a0)
 6be:	6390                	ld	a2,0(a5)
 6c0:	02059813          	slli	a6,a1,0x20
 6c4:	01c85713          	srli	a4,a6,0x1c
 6c8:	9736                	add	a4,a4,a3
 6ca:	fae60de3          	beq	a2,a4,684 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6ce:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6d2:	4790                	lw	a2,8(a5)
 6d4:	02061593          	slli	a1,a2,0x20
 6d8:	01c5d713          	srli	a4,a1,0x1c
 6dc:	973e                	add	a4,a4,a5
 6de:	fae68ae3          	beq	a3,a4,692 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6e2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6e4:	00001717          	auipc	a4,0x1
 6e8:	90f73e23          	sd	a5,-1764(a4) # 1000 <freep>
}
 6ec:	6422                	ld	s0,8(sp)
 6ee:	0141                	addi	sp,sp,16
 6f0:	8082                	ret

00000000000006f2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6f2:	7139                	addi	sp,sp,-64
 6f4:	fc06                	sd	ra,56(sp)
 6f6:	f822                	sd	s0,48(sp)
 6f8:	f426                	sd	s1,40(sp)
 6fa:	f04a                	sd	s2,32(sp)
 6fc:	ec4e                	sd	s3,24(sp)
 6fe:	e852                	sd	s4,16(sp)
 700:	e456                	sd	s5,8(sp)
 702:	e05a                	sd	s6,0(sp)
 704:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 706:	02051493          	slli	s1,a0,0x20
 70a:	9081                	srli	s1,s1,0x20
 70c:	04bd                	addi	s1,s1,15
 70e:	8091                	srli	s1,s1,0x4
 710:	0014899b          	addiw	s3,s1,1
 714:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 716:	00001517          	auipc	a0,0x1
 71a:	8ea53503          	ld	a0,-1814(a0) # 1000 <freep>
 71e:	c515                	beqz	a0,74a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 720:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 722:	4798                	lw	a4,8(a5)
 724:	02977f63          	bgeu	a4,s1,762 <malloc+0x70>
 728:	8a4e                	mv	s4,s3
 72a:	0009871b          	sext.w	a4,s3
 72e:	6685                	lui	a3,0x1
 730:	00d77363          	bgeu	a4,a3,736 <malloc+0x44>
 734:	6a05                	lui	s4,0x1
 736:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 73a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 73e:	00001917          	auipc	s2,0x1
 742:	8c290913          	addi	s2,s2,-1854 # 1000 <freep>
  if(p == (char*)-1)
 746:	5afd                	li	s5,-1
 748:	a895                	j	7bc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 74a:	00001797          	auipc	a5,0x1
 74e:	8c678793          	addi	a5,a5,-1850 # 1010 <base>
 752:	00001717          	auipc	a4,0x1
 756:	8af73723          	sd	a5,-1874(a4) # 1000 <freep>
 75a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 75c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 760:	b7e1                	j	728 <malloc+0x36>
      if(p->s.size == nunits)
 762:	02e48c63          	beq	s1,a4,79a <malloc+0xa8>
        p->s.size -= nunits;
 766:	4137073b          	subw	a4,a4,s3
 76a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 76c:	02071693          	slli	a3,a4,0x20
 770:	01c6d713          	srli	a4,a3,0x1c
 774:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 776:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 77a:	00001717          	auipc	a4,0x1
 77e:	88a73323          	sd	a0,-1914(a4) # 1000 <freep>
      return (void*)(p + 1);
 782:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 786:	70e2                	ld	ra,56(sp)
 788:	7442                	ld	s0,48(sp)
 78a:	74a2                	ld	s1,40(sp)
 78c:	7902                	ld	s2,32(sp)
 78e:	69e2                	ld	s3,24(sp)
 790:	6a42                	ld	s4,16(sp)
 792:	6aa2                	ld	s5,8(sp)
 794:	6b02                	ld	s6,0(sp)
 796:	6121                	addi	sp,sp,64
 798:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 79a:	6398                	ld	a4,0(a5)
 79c:	e118                	sd	a4,0(a0)
 79e:	bff1                	j	77a <malloc+0x88>
  hp->s.size = nu;
 7a0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7a4:	0541                	addi	a0,a0,16
 7a6:	00000097          	auipc	ra,0x0
 7aa:	eca080e7          	jalr	-310(ra) # 670 <free>
  return freep;
 7ae:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7b2:	d971                	beqz	a0,786 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b6:	4798                	lw	a4,8(a5)
 7b8:	fa9775e3          	bgeu	a4,s1,762 <malloc+0x70>
    if(p == freep)
 7bc:	00093703          	ld	a4,0(s2)
 7c0:	853e                	mv	a0,a5
 7c2:	fef719e3          	bne	a4,a5,7b4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7c6:	8552                	mv	a0,s4
 7c8:	00000097          	auipc	ra,0x0
 7cc:	b70080e7          	jalr	-1168(ra) # 338 <sbrk>
  if(p == (char*)-1)
 7d0:	fd5518e3          	bne	a0,s5,7a0 <malloc+0xae>
        return 0;
 7d4:	4501                	li	a0,0
 7d6:	bf45                	j	786 <malloc+0x94>

00000000000007d8 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 7d8:	c1d9                	beqz	a1,85e <head_run+0x86>
void head_run(int fd, int numOfLines){
 7da:	dd010113          	addi	sp,sp,-560
 7de:	22113423          	sd	ra,552(sp)
 7e2:	22813023          	sd	s0,544(sp)
 7e6:	20913c23          	sd	s1,536(sp)
 7ea:	21213823          	sd	s2,528(sp)
 7ee:	21313423          	sd	s3,520(sp)
 7f2:	21413023          	sd	s4,512(sp)
 7f6:	1c00                	addi	s0,sp,560
 7f8:	892a                	mv	s2,a0
 7fa:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 7fe:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 800:	00000a17          	auipc	s4,0x0
 804:	440a0a13          	addi	s4,s4,1088 # c40 <digits+0x40>
		readStatus = read_line(fd, line);
 808:	dd840593          	addi	a1,s0,-552
 80c:	854a                	mv	a0,s2
 80e:	00000097          	auipc	ra,0x0
 812:	318080e7          	jalr	792(ra) # b26 <read_line>
		if (readStatus == READ_ERROR){
 816:	01350d63          	beq	a0,s3,830 <head_run+0x58>
		if (readStatus == READ_EOF)
 81a:	c11d                	beqz	a0,840 <head_run+0x68>
		printf("%s",line);
 81c:	dd840593          	addi	a1,s0,-552
 820:	8552                	mv	a0,s4
 822:	00000097          	auipc	ra,0x0
 826:	e18080e7          	jalr	-488(ra) # 63a <printf>
	while(numOfLines--){
 82a:	34fd                	addiw	s1,s1,-1
 82c:	fcf1                	bnez	s1,808 <head_run+0x30>
 82e:	a809                	j	840 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 830:	00000517          	auipc	a0,0x0
 834:	3e850513          	addi	a0,a0,1000 # c18 <digits+0x18>
 838:	00000097          	auipc	ra,0x0
 83c:	e02080e7          	jalr	-510(ra) # 63a <printf>

	}
}
 840:	22813083          	ld	ra,552(sp)
 844:	22013403          	ld	s0,544(sp)
 848:	21813483          	ld	s1,536(sp)
 84c:	21013903          	ld	s2,528(sp)
 850:	20813983          	ld	s3,520(sp)
 854:	20013a03          	ld	s4,512(sp)
 858:	23010113          	addi	sp,sp,560
 85c:	8082                	ret
 85e:	8082                	ret

0000000000000860 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 860:	ba010113          	addi	sp,sp,-1120
 864:	44113c23          	sd	ra,1112(sp)
 868:	44813823          	sd	s0,1104(sp)
 86c:	44913423          	sd	s1,1096(sp)
 870:	45213023          	sd	s2,1088(sp)
 874:	43313c23          	sd	s3,1080(sp)
 878:	43413823          	sd	s4,1072(sp)
 87c:	43513423          	sd	s5,1064(sp)
 880:	43613023          	sd	s6,1056(sp)
 884:	41713c23          	sd	s7,1048(sp)
 888:	41813823          	sd	s8,1040(sp)
 88c:	41913423          	sd	s9,1032(sp)
 890:	41a13023          	sd	s10,1024(sp)
 894:	3fb13c23          	sd	s11,1016(sp)
 898:	46010413          	addi	s0,sp,1120
 89c:	89aa                	mv	s3,a0
 89e:	8aae                	mv	s5,a1
 8a0:	8c32                	mv	s8,a2
 8a2:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 8a4:	d9840593          	addi	a1,s0,-616
 8a8:	00000097          	auipc	ra,0x0
 8ac:	27e080e7          	jalr	638(ra) # b26 <read_line>


  if (readStatus == READ_ERROR)
 8b0:	57fd                	li	a5,-1
 8b2:	04f50163          	beq	a0,a5,8f4 <uniq_run+0x94>
 8b6:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 8b8:	ed21                	bnez	a0,910 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 8ba:	45813083          	ld	ra,1112(sp)
 8be:	45013403          	ld	s0,1104(sp)
 8c2:	44813483          	ld	s1,1096(sp)
 8c6:	44013903          	ld	s2,1088(sp)
 8ca:	43813983          	ld	s3,1080(sp)
 8ce:	43013a03          	ld	s4,1072(sp)
 8d2:	42813a83          	ld	s5,1064(sp)
 8d6:	42013b03          	ld	s6,1056(sp)
 8da:	41813b83          	ld	s7,1048(sp)
 8de:	41013c03          	ld	s8,1040(sp)
 8e2:	40813c83          	ld	s9,1032(sp)
 8e6:	40013d03          	ld	s10,1024(sp)
 8ea:	3f813d83          	ld	s11,1016(sp)
 8ee:	46010113          	addi	sp,sp,1120
 8f2:	8082                	ret
    printf("[ERR] Error reading from the file ");
 8f4:	00000517          	auipc	a0,0x0
 8f8:	35450513          	addi	a0,a0,852 # c48 <digits+0x48>
 8fc:	00000097          	auipc	ra,0x0
 900:	d3e080e7          	jalr	-706(ra) # 63a <printf>
 904:	bf5d                	j	8ba <uniq_run+0x5a>
 906:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 908:	8926                	mv	s2,s1
 90a:	84be                	mv	s1,a5
        lineCount = 1;
 90c:	8b6a                	mv	s6,s10
 90e:	a8ed                	j	a08 <uniq_run+0x1a8>
    int lineCount=1;
 910:	4b05                	li	s6,1
  char * line2 = buffer2;
 912:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 916:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 91a:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 91c:	4d05                	li	s10,1
              printf("%s",line1);
 91e:	00000d97          	auipc	s11,0x0
 922:	322d8d93          	addi	s11,s11,802 # c40 <digits+0x40>
 926:	a0cd                	j	a08 <uniq_run+0x1a8>
            if (repeatedLines){
 928:	020a0b63          	beqz	s4,95e <uniq_run+0xfe>
                if (isRepeated){
 92c:	f80b87e3          	beqz	s7,8ba <uniq_run+0x5a>
                    if (showCount)
 930:	000c0d63          	beqz	s8,94a <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 934:	864a                	mv	a2,s2
 936:	85da                	mv	a1,s6
 938:	00000517          	auipc	a0,0x0
 93c:	33850513          	addi	a0,a0,824 # c70 <digits+0x70>
 940:	00000097          	auipc	ra,0x0
 944:	cfa080e7          	jalr	-774(ra) # 63a <printf>
 948:	bf8d                	j	8ba <uniq_run+0x5a>
                      printf("%s",line1);
 94a:	85ca                	mv	a1,s2
 94c:	00000517          	auipc	a0,0x0
 950:	2f450513          	addi	a0,a0,756 # c40 <digits+0x40>
 954:	00000097          	auipc	ra,0x0
 958:	ce6080e7          	jalr	-794(ra) # 63a <printf>
 95c:	bfb9                	j	8ba <uniq_run+0x5a>
                if (showCount)
 95e:	000c0d63          	beqz	s8,978 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 962:	864a                	mv	a2,s2
 964:	85da                	mv	a1,s6
 966:	00000517          	auipc	a0,0x0
 96a:	30a50513          	addi	a0,a0,778 # c70 <digits+0x70>
 96e:	00000097          	auipc	ra,0x0
 972:	ccc080e7          	jalr	-820(ra) # 63a <printf>
 976:	b791                	j	8ba <uniq_run+0x5a>
                  printf("%s",line1);
 978:	85ca                	mv	a1,s2
 97a:	00000517          	auipc	a0,0x0
 97e:	2c650513          	addi	a0,a0,710 # c40 <digits+0x40>
 982:	00000097          	auipc	ra,0x0
 986:	cb8080e7          	jalr	-840(ra) # 63a <printf>
 98a:	bf05                	j	8ba <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 98c:	00000517          	auipc	a0,0x0
 990:	2ec50513          	addi	a0,a0,748 # c78 <digits+0x78>
 994:	00000097          	auipc	ra,0x0
 998:	ca6080e7          	jalr	-858(ra) # 63a <printf>
          break;
 99c:	bf39                	j	8ba <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 99e:	85a6                	mv	a1,s1
 9a0:	854a                	mv	a0,s2
 9a2:	00000097          	auipc	ra,0x0
 9a6:	110080e7          	jalr	272(ra) # ab2 <compare_str_ic>
 9aa:	a041                	j	a2a <uniq_run+0x1ca>
                  printf("%s",line1);
 9ac:	85ca                	mv	a1,s2
 9ae:	856e                	mv	a0,s11
 9b0:	00000097          	auipc	ra,0x0
 9b4:	c8a080e7          	jalr	-886(ra) # 63a <printf>
        lineCount = 1;
 9b8:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 9ba:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 9bc:	8926                	mv	s2,s1
                  printf("%s",line1);
 9be:	84be                	mv	s1,a5
        isRepeated = 0 ;
 9c0:	4b81                	li	s7,0
 9c2:	a099                	j	a08 <uniq_run+0x1a8>
            if (showCount)
 9c4:	020c0263          	beqz	s8,9e8 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 9c8:	864a                	mv	a2,s2
 9ca:	85da                	mv	a1,s6
 9cc:	00000517          	auipc	a0,0x0
 9d0:	2a450513          	addi	a0,a0,676 # c70 <digits+0x70>
 9d4:	00000097          	auipc	ra,0x0
 9d8:	c66080e7          	jalr	-922(ra) # 63a <printf>
 9dc:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 9de:	8926                	mv	s2,s1
 9e0:	84be                	mv	s1,a5
        isRepeated = 0 ;
 9e2:	4b81                	li	s7,0
        lineCount = 1;
 9e4:	8b6a                	mv	s6,s10
 9e6:	a00d                	j	a08 <uniq_run+0x1a8>
              printf("%s",line1);
 9e8:	85ca                	mv	a1,s2
 9ea:	856e                	mv	a0,s11
 9ec:	00000097          	auipc	ra,0x0
 9f0:	c4e080e7          	jalr	-946(ra) # 63a <printf>
 9f4:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 9f6:	8926                	mv	s2,s1
              printf("%s",line1);
 9f8:	84be                	mv	s1,a5
        isRepeated = 0 ;
 9fa:	4b81                	li	s7,0
        lineCount = 1;
 9fc:	8b6a                	mv	s6,s10
 9fe:	a029                	j	a08 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 a00:	000a0363          	beqz	s4,a06 <uniq_run+0x1a6>
 a04:	8bea                	mv	s7,s10
          lineCount++;
 a06:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 a08:	85a6                	mv	a1,s1
 a0a:	854e                	mv	a0,s3
 a0c:	00000097          	auipc	ra,0x0
 a10:	11a080e7          	jalr	282(ra) # b26 <read_line>
        if (readStatus == READ_EOF){
 a14:	d911                	beqz	a0,928 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 a16:	f7950be3          	beq	a0,s9,98c <uniq_run+0x12c>
        if (!ignoreCase)
 a1a:	f80a92e3          	bnez	s5,99e <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 a1e:	85a6                	mv	a1,s1
 a20:	854a                	mv	a0,s2
 a22:	00000097          	auipc	ra,0x0
 a26:	062080e7          	jalr	98(ra) # a84 <compare_str>
        if (compareStatus != 0){ 
 a2a:	d979                	beqz	a0,a00 <uniq_run+0x1a0>
          if (repeatedLines){
 a2c:	f80a0ce3          	beqz	s4,9c4 <uniq_run+0x164>
            if (isRepeated){
 a30:	ec0b8be3          	beqz	s7,906 <uniq_run+0xa6>
                if (showCount)
 a34:	f60c0ce3          	beqz	s8,9ac <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 a38:	864a                	mv	a2,s2
 a3a:	85da                	mv	a1,s6
 a3c:	00000517          	auipc	a0,0x0
 a40:	23450513          	addi	a0,a0,564 # c70 <digits+0x70>
 a44:	00000097          	auipc	ra,0x0
 a48:	bf6080e7          	jalr	-1034(ra) # 63a <printf>
        lineCount = 1;
 a4c:	8b5e                	mv	s6,s7
 a4e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a50:	8926                	mv	s2,s1
 a52:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a54:	4b81                	li	s7,0
 a56:	bf4d                	j	a08 <uniq_run+0x1a8>

0000000000000a58 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 a58:	1141                	addi	sp,sp,-16
 a5a:	e422                	sd	s0,8(sp)
 a5c:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 a5e:	00054783          	lbu	a5,0(a0)
 a62:	cf99                	beqz	a5,a80 <get_strlen+0x28>
 a64:	00150713          	addi	a4,a0,1
 a68:	87ba                	mv	a5,a4
 a6a:	4685                	li	a3,1
 a6c:	9e99                	subw	a3,a3,a4
 a6e:	00f6853b          	addw	a0,a3,a5
 a72:	0785                	addi	a5,a5,1
 a74:	fff7c703          	lbu	a4,-1(a5)
 a78:	fb7d                	bnez	a4,a6e <get_strlen+0x16>
	return len;
}
 a7a:	6422                	ld	s0,8(sp)
 a7c:	0141                	addi	sp,sp,16
 a7e:	8082                	ret
	int len = 0;
 a80:	4501                	li	a0,0
 a82:	bfe5                	j	a7a <get_strlen+0x22>

0000000000000a84 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 a84:	1141                	addi	sp,sp,-16
 a86:	e422                	sd	s0,8(sp)
 a88:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 a8a:	00054783          	lbu	a5,0(a0)
 a8e:	cb91                	beqz	a5,aa2 <compare_str+0x1e>
 a90:	0005c703          	lbu	a4,0(a1)
 a94:	c719                	beqz	a4,aa2 <compare_str+0x1e>
		if (*s1++ != *s2++)
 a96:	0505                	addi	a0,a0,1
 a98:	0585                	addi	a1,a1,1
 a9a:	fee788e3          	beq	a5,a4,a8a <compare_str+0x6>
			return 1;
 a9e:	4505                	li	a0,1
 aa0:	a031                	j	aac <compare_str+0x28>
	}
	if (*s1 == *s2)
 aa2:	0005c503          	lbu	a0,0(a1)
 aa6:	8d1d                	sub	a0,a0,a5
			return 1;
 aa8:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 aac:	6422                	ld	s0,8(sp)
 aae:	0141                	addi	sp,sp,16
 ab0:	8082                	ret

0000000000000ab2 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 ab2:	1141                	addi	sp,sp,-16
 ab4:	e422                	sd	s0,8(sp)
 ab6:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 ab8:	4665                	li	a2,25
	while(*s1 && *s2){
 aba:	a019                	j	ac0 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 abc:	04e79763          	bne	a5,a4,b0a <compare_str_ic+0x58>
	while(*s1 && *s2){
 ac0:	00054783          	lbu	a5,0(a0)
 ac4:	cb9d                	beqz	a5,afa <compare_str_ic+0x48>
 ac6:	0005c703          	lbu	a4,0(a1)
 aca:	cb05                	beqz	a4,afa <compare_str_ic+0x48>
		char b1 = *s1++;
 acc:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 ace:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 ad0:	fbf7869b          	addiw	a3,a5,-65
 ad4:	0ff6f693          	zext.b	a3,a3
 ad8:	00d66663          	bltu	a2,a3,ae4 <compare_str_ic+0x32>
			b1 += 32;
 adc:	0207879b          	addiw	a5,a5,32
 ae0:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 ae4:	fbf7069b          	addiw	a3,a4,-65
 ae8:	0ff6f693          	zext.b	a3,a3
 aec:	fcd668e3          	bltu	a2,a3,abc <compare_str_ic+0xa>
			b2 += 32;
 af0:	0207071b          	addiw	a4,a4,32
 af4:	0ff77713          	zext.b	a4,a4
 af8:	b7d1                	j	abc <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 afa:	0005c503          	lbu	a0,0(a1)
 afe:	8d1d                	sub	a0,a0,a5
			return 1;
 b00:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b04:	6422                	ld	s0,8(sp)
 b06:	0141                	addi	sp,sp,16
 b08:	8082                	ret
			return 1;
 b0a:	4505                	li	a0,1
 b0c:	bfe5                	j	b04 <compare_str_ic+0x52>

0000000000000b0e <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 b0e:	1141                	addi	sp,sp,-16
 b10:	e406                	sd	ra,8(sp)
 b12:	e022                	sd	s0,0(sp)
 b14:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 b16:	fffff097          	auipc	ra,0xfffff
 b1a:	7da080e7          	jalr	2010(ra) # 2f0 <open>
	return fd;
}
 b1e:	60a2                	ld	ra,8(sp)
 b20:	6402                	ld	s0,0(sp)
 b22:	0141                	addi	sp,sp,16
 b24:	8082                	ret

0000000000000b26 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 b26:	7139                	addi	sp,sp,-64
 b28:	fc06                	sd	ra,56(sp)
 b2a:	f822                	sd	s0,48(sp)
 b2c:	f426                	sd	s1,40(sp)
 b2e:	f04a                	sd	s2,32(sp)
 b30:	ec4e                	sd	s3,24(sp)
 b32:	e852                	sd	s4,16(sp)
 b34:	0080                	addi	s0,sp,64
 b36:	89aa                	mv	s3,a0
 b38:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 b3a:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 b3c:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 b3e:	4605                	li	a2,1
 b40:	fcf40593          	addi	a1,s0,-49
 b44:	854e                	mv	a0,s3
 b46:	fffff097          	auipc	ra,0xfffff
 b4a:	782080e7          	jalr	1922(ra) # 2c8 <read>
		if (readStatus == 0){
 b4e:	c505                	beqz	a0,b76 <read_line+0x50>
		*buffer++ = readByte;
 b50:	0485                	addi	s1,s1,1
 b52:	fcf44783          	lbu	a5,-49(s0)
 b56:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 b5a:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 b5c:	ff4791e3          	bne	a5,s4,b3e <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 b60:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 b64:	854a                	mv	a0,s2
 b66:	70e2                	ld	ra,56(sp)
 b68:	7442                	ld	s0,48(sp)
 b6a:	74a2                	ld	s1,40(sp)
 b6c:	7902                	ld	s2,32(sp)
 b6e:	69e2                	ld	s3,24(sp)
 b70:	6a42                	ld	s4,16(sp)
 b72:	6121                	addi	sp,sp,64
 b74:	8082                	ret
			if (byteCount!=0){
 b76:	fe0907e3          	beqz	s2,b64 <read_line+0x3e>
				*buffer = '\n';
 b7a:	47a9                	li	a5,10
 b7c:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 b80:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 b84:	2905                	addiw	s2,s2,1
 b86:	bff9                	j	b64 <read_line+0x3e>

0000000000000b88 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 b88:	1141                	addi	sp,sp,-16
 b8a:	e406                	sd	ra,8(sp)
 b8c:	e022                	sd	s0,0(sp)
 b8e:	0800                	addi	s0,sp,16
	close(fd);
 b90:	fffff097          	auipc	ra,0xfffff
 b94:	748080e7          	jalr	1864(ra) # 2d8 <close>
}
 b98:	60a2                	ld	ra,8(sp)
 b9a:	6402                	ld	s0,0(sp)
 b9c:	0141                	addi	sp,sp,16
 b9e:	8082                	ret
