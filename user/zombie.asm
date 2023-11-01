
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

0000000000000378 <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 378:	48ed                	li	a7,27
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 380:	48f1                	li	a7,28
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 388:	48f5                	li	a7,29
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 390:	1101                	addi	sp,sp,-32
 392:	ec06                	sd	ra,24(sp)
 394:	e822                	sd	s0,16(sp)
 396:	1000                	addi	s0,sp,32
 398:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39c:	4605                	li	a2,1
 39e:	fef40593          	addi	a1,s0,-17
 3a2:	00000097          	auipc	ra,0x0
 3a6:	f2e080e7          	jalr	-210(ra) # 2d0 <write>
}
 3aa:	60e2                	ld	ra,24(sp)
 3ac:	6442                	ld	s0,16(sp)
 3ae:	6105                	addi	sp,sp,32
 3b0:	8082                	ret

00000000000003b2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b2:	7139                	addi	sp,sp,-64
 3b4:	fc06                	sd	ra,56(sp)
 3b6:	f822                	sd	s0,48(sp)
 3b8:	f426                	sd	s1,40(sp)
 3ba:	f04a                	sd	s2,32(sp)
 3bc:	ec4e                	sd	s3,24(sp)
 3be:	0080                	addi	s0,sp,64
 3c0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c2:	c299                	beqz	a3,3c8 <printint+0x16>
 3c4:	0805c963          	bltz	a1,456 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c8:	2581                	sext.w	a1,a1
  neg = 0;
 3ca:	4881                	li	a7,0
 3cc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3d0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d2:	2601                	sext.w	a2,a2
 3d4:	00001517          	auipc	a0,0x1
 3d8:	93c50513          	addi	a0,a0,-1732 # d10 <digits>
 3dc:	883a                	mv	a6,a4
 3de:	2705                	addiw	a4,a4,1
 3e0:	02c5f7bb          	remuw	a5,a1,a2
 3e4:	1782                	slli	a5,a5,0x20
 3e6:	9381                	srli	a5,a5,0x20
 3e8:	97aa                	add	a5,a5,a0
 3ea:	0007c783          	lbu	a5,0(a5)
 3ee:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f2:	0005879b          	sext.w	a5,a1
 3f6:	02c5d5bb          	divuw	a1,a1,a2
 3fa:	0685                	addi	a3,a3,1
 3fc:	fec7f0e3          	bgeu	a5,a2,3dc <printint+0x2a>
  if(neg)
 400:	00088c63          	beqz	a7,418 <printint+0x66>
    buf[i++] = '-';
 404:	fd070793          	addi	a5,a4,-48
 408:	00878733          	add	a4,a5,s0
 40c:	02d00793          	li	a5,45
 410:	fef70823          	sb	a5,-16(a4)
 414:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 418:	02e05863          	blez	a4,448 <printint+0x96>
 41c:	fc040793          	addi	a5,s0,-64
 420:	00e78933          	add	s2,a5,a4
 424:	fff78993          	addi	s3,a5,-1
 428:	99ba                	add	s3,s3,a4
 42a:	377d                	addiw	a4,a4,-1
 42c:	1702                	slli	a4,a4,0x20
 42e:	9301                	srli	a4,a4,0x20
 430:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 434:	fff94583          	lbu	a1,-1(s2)
 438:	8526                	mv	a0,s1
 43a:	00000097          	auipc	ra,0x0
 43e:	f56080e7          	jalr	-170(ra) # 390 <putc>
  while(--i >= 0)
 442:	197d                	addi	s2,s2,-1
 444:	ff3918e3          	bne	s2,s3,434 <printint+0x82>
}
 448:	70e2                	ld	ra,56(sp)
 44a:	7442                	ld	s0,48(sp)
 44c:	74a2                	ld	s1,40(sp)
 44e:	7902                	ld	s2,32(sp)
 450:	69e2                	ld	s3,24(sp)
 452:	6121                	addi	sp,sp,64
 454:	8082                	ret
    x = -xx;
 456:	40b005bb          	negw	a1,a1
    neg = 1;
 45a:	4885                	li	a7,1
    x = -xx;
 45c:	bf85                	j	3cc <printint+0x1a>

000000000000045e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 45e:	7119                	addi	sp,sp,-128
 460:	fc86                	sd	ra,120(sp)
 462:	f8a2                	sd	s0,112(sp)
 464:	f4a6                	sd	s1,104(sp)
 466:	f0ca                	sd	s2,96(sp)
 468:	ecce                	sd	s3,88(sp)
 46a:	e8d2                	sd	s4,80(sp)
 46c:	e4d6                	sd	s5,72(sp)
 46e:	e0da                	sd	s6,64(sp)
 470:	fc5e                	sd	s7,56(sp)
 472:	f862                	sd	s8,48(sp)
 474:	f466                	sd	s9,40(sp)
 476:	f06a                	sd	s10,32(sp)
 478:	ec6e                	sd	s11,24(sp)
 47a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 47c:	0005c903          	lbu	s2,0(a1)
 480:	18090f63          	beqz	s2,61e <vprintf+0x1c0>
 484:	8aaa                	mv	s5,a0
 486:	8b32                	mv	s6,a2
 488:	00158493          	addi	s1,a1,1
  state = 0;
 48c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 48e:	02500a13          	li	s4,37
 492:	4c55                	li	s8,21
 494:	00001c97          	auipc	s9,0x1
 498:	824c8c93          	addi	s9,s9,-2012 # cb8 <get_time_perf+0x6c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 49c:	02800d93          	li	s11,40
  putc(fd, 'x');
 4a0:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4a2:	00001b97          	auipc	s7,0x1
 4a6:	86eb8b93          	addi	s7,s7,-1938 # d10 <digits>
 4aa:	a839                	j	4c8 <vprintf+0x6a>
        putc(fd, c);
 4ac:	85ca                	mv	a1,s2
 4ae:	8556                	mv	a0,s5
 4b0:	00000097          	auipc	ra,0x0
 4b4:	ee0080e7          	jalr	-288(ra) # 390 <putc>
 4b8:	a019                	j	4be <vprintf+0x60>
    } else if(state == '%'){
 4ba:	01498d63          	beq	s3,s4,4d4 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4be:	0485                	addi	s1,s1,1
 4c0:	fff4c903          	lbu	s2,-1(s1)
 4c4:	14090d63          	beqz	s2,61e <vprintf+0x1c0>
    if(state == 0){
 4c8:	fe0999e3          	bnez	s3,4ba <vprintf+0x5c>
      if(c == '%'){
 4cc:	ff4910e3          	bne	s2,s4,4ac <vprintf+0x4e>
        state = '%';
 4d0:	89d2                	mv	s3,s4
 4d2:	b7f5                	j	4be <vprintf+0x60>
      if(c == 'd'){
 4d4:	11490c63          	beq	s2,s4,5ec <vprintf+0x18e>
 4d8:	f9d9079b          	addiw	a5,s2,-99
 4dc:	0ff7f793          	zext.b	a5,a5
 4e0:	10fc6e63          	bltu	s8,a5,5fc <vprintf+0x19e>
 4e4:	f9d9079b          	addiw	a5,s2,-99
 4e8:	0ff7f713          	zext.b	a4,a5
 4ec:	10ec6863          	bltu	s8,a4,5fc <vprintf+0x19e>
 4f0:	00271793          	slli	a5,a4,0x2
 4f4:	97e6                	add	a5,a5,s9
 4f6:	439c                	lw	a5,0(a5)
 4f8:	97e6                	add	a5,a5,s9
 4fa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4fc:	008b0913          	addi	s2,s6,8
 500:	4685                	li	a3,1
 502:	4629                	li	a2,10
 504:	000b2583          	lw	a1,0(s6)
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	ea8080e7          	jalr	-344(ra) # 3b2 <printint>
 512:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 514:	4981                	li	s3,0
 516:	b765                	j	4be <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 518:	008b0913          	addi	s2,s6,8
 51c:	4681                	li	a3,0
 51e:	4629                	li	a2,10
 520:	000b2583          	lw	a1,0(s6)
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	e8c080e7          	jalr	-372(ra) # 3b2 <printint>
 52e:	8b4a                	mv	s6,s2
      state = 0;
 530:	4981                	li	s3,0
 532:	b771                	j	4be <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 534:	008b0913          	addi	s2,s6,8
 538:	4681                	li	a3,0
 53a:	866a                	mv	a2,s10
 53c:	000b2583          	lw	a1,0(s6)
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e70080e7          	jalr	-400(ra) # 3b2 <printint>
 54a:	8b4a                	mv	s6,s2
      state = 0;
 54c:	4981                	li	s3,0
 54e:	bf85                	j	4be <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 550:	008b0793          	addi	a5,s6,8
 554:	f8f43423          	sd	a5,-120(s0)
 558:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 55c:	03000593          	li	a1,48
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e2e080e7          	jalr	-466(ra) # 390 <putc>
  putc(fd, 'x');
 56a:	07800593          	li	a1,120
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	e20080e7          	jalr	-480(ra) # 390 <putc>
 578:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 57a:	03c9d793          	srli	a5,s3,0x3c
 57e:	97de                	add	a5,a5,s7
 580:	0007c583          	lbu	a1,0(a5)
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	e0a080e7          	jalr	-502(ra) # 390 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 58e:	0992                	slli	s3,s3,0x4
 590:	397d                	addiw	s2,s2,-1
 592:	fe0914e3          	bnez	s2,57a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 596:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 59a:	4981                	li	s3,0
 59c:	b70d                	j	4be <vprintf+0x60>
        s = va_arg(ap, char*);
 59e:	008b0913          	addi	s2,s6,8
 5a2:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5a6:	02098163          	beqz	s3,5c8 <vprintf+0x16a>
        while(*s != 0){
 5aa:	0009c583          	lbu	a1,0(s3)
 5ae:	c5ad                	beqz	a1,618 <vprintf+0x1ba>
          putc(fd, *s);
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	dde080e7          	jalr	-546(ra) # 390 <putc>
          s++;
 5ba:	0985                	addi	s3,s3,1
        while(*s != 0){
 5bc:	0009c583          	lbu	a1,0(s3)
 5c0:	f9e5                	bnez	a1,5b0 <vprintf+0x152>
        s = va_arg(ap, char*);
 5c2:	8b4a                	mv	s6,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bde5                	j	4be <vprintf+0x60>
          s = "(null)";
 5c8:	00000997          	auipc	s3,0x0
 5cc:	6e898993          	addi	s3,s3,1768 # cb0 <get_time_perf+0x64>
        while(*s != 0){
 5d0:	85ee                	mv	a1,s11
 5d2:	bff9                	j	5b0 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5d4:	008b0913          	addi	s2,s6,8
 5d8:	000b4583          	lbu	a1,0(s6)
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	db2080e7          	jalr	-590(ra) # 390 <putc>
 5e6:	8b4a                	mv	s6,s2
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	bdd1                	j	4be <vprintf+0x60>
        putc(fd, c);
 5ec:	85d2                	mv	a1,s4
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	da0080e7          	jalr	-608(ra) # 390 <putc>
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b5d1                	j	4be <vprintf+0x60>
        putc(fd, '%');
 5fc:	85d2                	mv	a1,s4
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	d90080e7          	jalr	-624(ra) # 390 <putc>
        putc(fd, c);
 608:	85ca                	mv	a1,s2
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	d84080e7          	jalr	-636(ra) # 390 <putc>
      state = 0;
 614:	4981                	li	s3,0
 616:	b565                	j	4be <vprintf+0x60>
        s = va_arg(ap, char*);
 618:	8b4a                	mv	s6,s2
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b54d                	j	4be <vprintf+0x60>
    }
  }
}
 61e:	70e6                	ld	ra,120(sp)
 620:	7446                	ld	s0,112(sp)
 622:	74a6                	ld	s1,104(sp)
 624:	7906                	ld	s2,96(sp)
 626:	69e6                	ld	s3,88(sp)
 628:	6a46                	ld	s4,80(sp)
 62a:	6aa6                	ld	s5,72(sp)
 62c:	6b06                	ld	s6,64(sp)
 62e:	7be2                	ld	s7,56(sp)
 630:	7c42                	ld	s8,48(sp)
 632:	7ca2                	ld	s9,40(sp)
 634:	7d02                	ld	s10,32(sp)
 636:	6de2                	ld	s11,24(sp)
 638:	6109                	addi	sp,sp,128
 63a:	8082                	ret

000000000000063c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 63c:	715d                	addi	sp,sp,-80
 63e:	ec06                	sd	ra,24(sp)
 640:	e822                	sd	s0,16(sp)
 642:	1000                	addi	s0,sp,32
 644:	e010                	sd	a2,0(s0)
 646:	e414                	sd	a3,8(s0)
 648:	e818                	sd	a4,16(s0)
 64a:	ec1c                	sd	a5,24(s0)
 64c:	03043023          	sd	a6,32(s0)
 650:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 654:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 658:	8622                	mv	a2,s0
 65a:	00000097          	auipc	ra,0x0
 65e:	e04080e7          	jalr	-508(ra) # 45e <vprintf>
}
 662:	60e2                	ld	ra,24(sp)
 664:	6442                	ld	s0,16(sp)
 666:	6161                	addi	sp,sp,80
 668:	8082                	ret

000000000000066a <printf>:

void
printf(const char *fmt, ...)
{
 66a:	711d                	addi	sp,sp,-96
 66c:	ec06                	sd	ra,24(sp)
 66e:	e822                	sd	s0,16(sp)
 670:	1000                	addi	s0,sp,32
 672:	e40c                	sd	a1,8(s0)
 674:	e810                	sd	a2,16(s0)
 676:	ec14                	sd	a3,24(s0)
 678:	f018                	sd	a4,32(s0)
 67a:	f41c                	sd	a5,40(s0)
 67c:	03043823          	sd	a6,48(s0)
 680:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 684:	00840613          	addi	a2,s0,8
 688:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 68c:	85aa                	mv	a1,a0
 68e:	4505                	li	a0,1
 690:	00000097          	auipc	ra,0x0
 694:	dce080e7          	jalr	-562(ra) # 45e <vprintf>
}
 698:	60e2                	ld	ra,24(sp)
 69a:	6442                	ld	s0,16(sp)
 69c:	6125                	addi	sp,sp,96
 69e:	8082                	ret

00000000000006a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a0:	1141                	addi	sp,sp,-16
 6a2:	e422                	sd	s0,8(sp)
 6a4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6aa:	00001797          	auipc	a5,0x1
 6ae:	9567b783          	ld	a5,-1706(a5) # 1000 <freep>
 6b2:	a02d                	j	6dc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6b4:	4618                	lw	a4,8(a2)
 6b6:	9f2d                	addw	a4,a4,a1
 6b8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6bc:	6398                	ld	a4,0(a5)
 6be:	6310                	ld	a2,0(a4)
 6c0:	a83d                	j	6fe <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c2:	ff852703          	lw	a4,-8(a0)
 6c6:	9f31                	addw	a4,a4,a2
 6c8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6ca:	ff053683          	ld	a3,-16(a0)
 6ce:	a091                	j	712 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d0:	6398                	ld	a4,0(a5)
 6d2:	00e7e463          	bltu	a5,a4,6da <free+0x3a>
 6d6:	00e6ea63          	bltu	a3,a4,6ea <free+0x4a>
{
 6da:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6dc:	fed7fae3          	bgeu	a5,a3,6d0 <free+0x30>
 6e0:	6398                	ld	a4,0(a5)
 6e2:	00e6e463          	bltu	a3,a4,6ea <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e6:	fee7eae3          	bltu	a5,a4,6da <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6ea:	ff852583          	lw	a1,-8(a0)
 6ee:	6390                	ld	a2,0(a5)
 6f0:	02059813          	slli	a6,a1,0x20
 6f4:	01c85713          	srli	a4,a6,0x1c
 6f8:	9736                	add	a4,a4,a3
 6fa:	fae60de3          	beq	a2,a4,6b4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6fe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 702:	4790                	lw	a2,8(a5)
 704:	02061593          	slli	a1,a2,0x20
 708:	01c5d713          	srli	a4,a1,0x1c
 70c:	973e                	add	a4,a4,a5
 70e:	fae68ae3          	beq	a3,a4,6c2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 712:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 714:	00001717          	auipc	a4,0x1
 718:	8ef73623          	sd	a5,-1812(a4) # 1000 <freep>
}
 71c:	6422                	ld	s0,8(sp)
 71e:	0141                	addi	sp,sp,16
 720:	8082                	ret

0000000000000722 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 722:	7139                	addi	sp,sp,-64
 724:	fc06                	sd	ra,56(sp)
 726:	f822                	sd	s0,48(sp)
 728:	f426                	sd	s1,40(sp)
 72a:	f04a                	sd	s2,32(sp)
 72c:	ec4e                	sd	s3,24(sp)
 72e:	e852                	sd	s4,16(sp)
 730:	e456                	sd	s5,8(sp)
 732:	e05a                	sd	s6,0(sp)
 734:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 736:	02051493          	slli	s1,a0,0x20
 73a:	9081                	srli	s1,s1,0x20
 73c:	04bd                	addi	s1,s1,15
 73e:	8091                	srli	s1,s1,0x4
 740:	0014899b          	addiw	s3,s1,1
 744:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 746:	00001517          	auipc	a0,0x1
 74a:	8ba53503          	ld	a0,-1862(a0) # 1000 <freep>
 74e:	c515                	beqz	a0,77a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 750:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 752:	4798                	lw	a4,8(a5)
 754:	02977f63          	bgeu	a4,s1,792 <malloc+0x70>
 758:	8a4e                	mv	s4,s3
 75a:	0009871b          	sext.w	a4,s3
 75e:	6685                	lui	a3,0x1
 760:	00d77363          	bgeu	a4,a3,766 <malloc+0x44>
 764:	6a05                	lui	s4,0x1
 766:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 76a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 76e:	00001917          	auipc	s2,0x1
 772:	89290913          	addi	s2,s2,-1902 # 1000 <freep>
  if(p == (char*)-1)
 776:	5afd                	li	s5,-1
 778:	a895                	j	7ec <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 77a:	00001797          	auipc	a5,0x1
 77e:	89678793          	addi	a5,a5,-1898 # 1010 <base>
 782:	00001717          	auipc	a4,0x1
 786:	86f73f23          	sd	a5,-1922(a4) # 1000 <freep>
 78a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 78c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 790:	b7e1                	j	758 <malloc+0x36>
      if(p->s.size == nunits)
 792:	02e48c63          	beq	s1,a4,7ca <malloc+0xa8>
        p->s.size -= nunits;
 796:	4137073b          	subw	a4,a4,s3
 79a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 79c:	02071693          	slli	a3,a4,0x20
 7a0:	01c6d713          	srli	a4,a3,0x1c
 7a4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7a6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7aa:	00001717          	auipc	a4,0x1
 7ae:	84a73b23          	sd	a0,-1962(a4) # 1000 <freep>
      return (void*)(p + 1);
 7b2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7b6:	70e2                	ld	ra,56(sp)
 7b8:	7442                	ld	s0,48(sp)
 7ba:	74a2                	ld	s1,40(sp)
 7bc:	7902                	ld	s2,32(sp)
 7be:	69e2                	ld	s3,24(sp)
 7c0:	6a42                	ld	s4,16(sp)
 7c2:	6aa2                	ld	s5,8(sp)
 7c4:	6b02                	ld	s6,0(sp)
 7c6:	6121                	addi	sp,sp,64
 7c8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7ca:	6398                	ld	a4,0(a5)
 7cc:	e118                	sd	a4,0(a0)
 7ce:	bff1                	j	7aa <malloc+0x88>
  hp->s.size = nu;
 7d0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7d4:	0541                	addi	a0,a0,16
 7d6:	00000097          	auipc	ra,0x0
 7da:	eca080e7          	jalr	-310(ra) # 6a0 <free>
  return freep;
 7de:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7e2:	d971                	beqz	a0,7b6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e6:	4798                	lw	a4,8(a5)
 7e8:	fa9775e3          	bgeu	a4,s1,792 <malloc+0x70>
    if(p == freep)
 7ec:	00093703          	ld	a4,0(s2)
 7f0:	853e                	mv	a0,a5
 7f2:	fef719e3          	bne	a4,a5,7e4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7f6:	8552                	mv	a0,s4
 7f8:	00000097          	auipc	ra,0x0
 7fc:	b40080e7          	jalr	-1216(ra) # 338 <sbrk>
  if(p == (char*)-1)
 800:	fd5518e3          	bne	a0,s5,7d0 <malloc+0xae>
        return 0;
 804:	4501                	li	a0,0
 806:	bf45                	j	7b6 <malloc+0x94>

0000000000000808 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 808:	c1d9                	beqz	a1,88e <head_run+0x86>
void head_run(int fd, int numOfLines){
 80a:	dd010113          	addi	sp,sp,-560
 80e:	22113423          	sd	ra,552(sp)
 812:	22813023          	sd	s0,544(sp)
 816:	20913c23          	sd	s1,536(sp)
 81a:	21213823          	sd	s2,528(sp)
 81e:	21313423          	sd	s3,520(sp)
 822:	21413023          	sd	s4,512(sp)
 826:	1c00                	addi	s0,sp,560
 828:	892a                	mv	s2,a0
 82a:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 82e:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 830:	00000a17          	auipc	s4,0x0
 834:	520a0a13          	addi	s4,s4,1312 # d50 <digits+0x40>
		readStatus = read_line(fd, line);
 838:	dd840593          	addi	a1,s0,-552
 83c:	854a                	mv	a0,s2
 83e:	00000097          	auipc	ra,0x0
 842:	394080e7          	jalr	916(ra) # bd2 <read_line>
		if (readStatus == READ_ERROR){
 846:	01350d63          	beq	a0,s3,860 <head_run+0x58>
		if (readStatus == READ_EOF)
 84a:	c11d                	beqz	a0,870 <head_run+0x68>
		printf("%s",line);
 84c:	dd840593          	addi	a1,s0,-552
 850:	8552                	mv	a0,s4
 852:	00000097          	auipc	ra,0x0
 856:	e18080e7          	jalr	-488(ra) # 66a <printf>
	while(numOfLines--){
 85a:	34fd                	addiw	s1,s1,-1
 85c:	fcf1                	bnez	s1,838 <head_run+0x30>
 85e:	a809                	j	870 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 860:	00000517          	auipc	a0,0x0
 864:	4c850513          	addi	a0,a0,1224 # d28 <digits+0x18>
 868:	00000097          	auipc	ra,0x0
 86c:	e02080e7          	jalr	-510(ra) # 66a <printf>

	}
}
 870:	22813083          	ld	ra,552(sp)
 874:	22013403          	ld	s0,544(sp)
 878:	21813483          	ld	s1,536(sp)
 87c:	21013903          	ld	s2,528(sp)
 880:	20813983          	ld	s3,520(sp)
 884:	20013a03          	ld	s4,512(sp)
 888:	23010113          	addi	sp,sp,560
 88c:	8082                	ret
 88e:	8082                	ret

0000000000000890 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 890:	ba010113          	addi	sp,sp,-1120
 894:	44113c23          	sd	ra,1112(sp)
 898:	44813823          	sd	s0,1104(sp)
 89c:	44913423          	sd	s1,1096(sp)
 8a0:	45213023          	sd	s2,1088(sp)
 8a4:	43313c23          	sd	s3,1080(sp)
 8a8:	43413823          	sd	s4,1072(sp)
 8ac:	43513423          	sd	s5,1064(sp)
 8b0:	43613023          	sd	s6,1056(sp)
 8b4:	41713c23          	sd	s7,1048(sp)
 8b8:	41813823          	sd	s8,1040(sp)
 8bc:	41913423          	sd	s9,1032(sp)
 8c0:	41a13023          	sd	s10,1024(sp)
 8c4:	3fb13c23          	sd	s11,1016(sp)
 8c8:	46010413          	addi	s0,sp,1120
 8cc:	89aa                	mv	s3,a0
 8ce:	8aae                	mv	s5,a1
 8d0:	8c32                	mv	s8,a2
 8d2:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 8d4:	d9840593          	addi	a1,s0,-616
 8d8:	00000097          	auipc	ra,0x0
 8dc:	2fa080e7          	jalr	762(ra) # bd2 <read_line>


  if (readStatus == READ_ERROR)
 8e0:	57fd                	li	a5,-1
 8e2:	04f50163          	beq	a0,a5,924 <uniq_run+0x94>
 8e6:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 8e8:	ed21                	bnez	a0,940 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 8ea:	45813083          	ld	ra,1112(sp)
 8ee:	45013403          	ld	s0,1104(sp)
 8f2:	44813483          	ld	s1,1096(sp)
 8f6:	44013903          	ld	s2,1088(sp)
 8fa:	43813983          	ld	s3,1080(sp)
 8fe:	43013a03          	ld	s4,1072(sp)
 902:	42813a83          	ld	s5,1064(sp)
 906:	42013b03          	ld	s6,1056(sp)
 90a:	41813b83          	ld	s7,1048(sp)
 90e:	41013c03          	ld	s8,1040(sp)
 912:	40813c83          	ld	s9,1032(sp)
 916:	40013d03          	ld	s10,1024(sp)
 91a:	3f813d83          	ld	s11,1016(sp)
 91e:	46010113          	addi	sp,sp,1120
 922:	8082                	ret
    printf("[ERR] Error reading from the file ");
 924:	00000517          	auipc	a0,0x0
 928:	43450513          	addi	a0,a0,1076 # d58 <digits+0x48>
 92c:	00000097          	auipc	ra,0x0
 930:	d3e080e7          	jalr	-706(ra) # 66a <printf>
 934:	bf5d                	j	8ea <uniq_run+0x5a>
 936:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 938:	8926                	mv	s2,s1
 93a:	84be                	mv	s1,a5
        lineCount = 1;
 93c:	8b6a                	mv	s6,s10
 93e:	a8ed                	j	a38 <uniq_run+0x1a8>
    int lineCount=1;
 940:	4b05                	li	s6,1
  char * line2 = buffer2;
 942:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 946:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 94a:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 94c:	4d05                	li	s10,1
              printf("%s",line1);
 94e:	00000d97          	auipc	s11,0x0
 952:	402d8d93          	addi	s11,s11,1026 # d50 <digits+0x40>
 956:	a0cd                	j	a38 <uniq_run+0x1a8>
            if (repeatedLines){
 958:	020a0b63          	beqz	s4,98e <uniq_run+0xfe>
                if (isRepeated){
 95c:	f80b87e3          	beqz	s7,8ea <uniq_run+0x5a>
                    if (showCount)
 960:	000c0d63          	beqz	s8,97a <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 964:	864a                	mv	a2,s2
 966:	85da                	mv	a1,s6
 968:	00000517          	auipc	a0,0x0
 96c:	41850513          	addi	a0,a0,1048 # d80 <digits+0x70>
 970:	00000097          	auipc	ra,0x0
 974:	cfa080e7          	jalr	-774(ra) # 66a <printf>
 978:	bf8d                	j	8ea <uniq_run+0x5a>
                      printf("%s",line1);
 97a:	85ca                	mv	a1,s2
 97c:	00000517          	auipc	a0,0x0
 980:	3d450513          	addi	a0,a0,980 # d50 <digits+0x40>
 984:	00000097          	auipc	ra,0x0
 988:	ce6080e7          	jalr	-794(ra) # 66a <printf>
 98c:	bfb9                	j	8ea <uniq_run+0x5a>
                if (showCount)
 98e:	000c0d63          	beqz	s8,9a8 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 992:	864a                	mv	a2,s2
 994:	85da                	mv	a1,s6
 996:	00000517          	auipc	a0,0x0
 99a:	3ea50513          	addi	a0,a0,1002 # d80 <digits+0x70>
 99e:	00000097          	auipc	ra,0x0
 9a2:	ccc080e7          	jalr	-820(ra) # 66a <printf>
 9a6:	b791                	j	8ea <uniq_run+0x5a>
                  printf("%s",line1);
 9a8:	85ca                	mv	a1,s2
 9aa:	00000517          	auipc	a0,0x0
 9ae:	3a650513          	addi	a0,a0,934 # d50 <digits+0x40>
 9b2:	00000097          	auipc	ra,0x0
 9b6:	cb8080e7          	jalr	-840(ra) # 66a <printf>
 9ba:	bf05                	j	8ea <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 9bc:	00000517          	auipc	a0,0x0
 9c0:	3cc50513          	addi	a0,a0,972 # d88 <digits+0x78>
 9c4:	00000097          	auipc	ra,0x0
 9c8:	ca6080e7          	jalr	-858(ra) # 66a <printf>
          break;
 9cc:	bf39                	j	8ea <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 9ce:	85a6                	mv	a1,s1
 9d0:	854a                	mv	a0,s2
 9d2:	00000097          	auipc	ra,0x0
 9d6:	110080e7          	jalr	272(ra) # ae2 <compare_str_ic>
 9da:	a041                	j	a5a <uniq_run+0x1ca>
                  printf("%s",line1);
 9dc:	85ca                	mv	a1,s2
 9de:	856e                	mv	a0,s11
 9e0:	00000097          	auipc	ra,0x0
 9e4:	c8a080e7          	jalr	-886(ra) # 66a <printf>
        lineCount = 1;
 9e8:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 9ea:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 9ec:	8926                	mv	s2,s1
                  printf("%s",line1);
 9ee:	84be                	mv	s1,a5
        isRepeated = 0 ;
 9f0:	4b81                	li	s7,0
 9f2:	a099                	j	a38 <uniq_run+0x1a8>
            if (showCount)
 9f4:	020c0263          	beqz	s8,a18 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 9f8:	864a                	mv	a2,s2
 9fa:	85da                	mv	a1,s6
 9fc:	00000517          	auipc	a0,0x0
 a00:	38450513          	addi	a0,a0,900 # d80 <digits+0x70>
 a04:	00000097          	auipc	ra,0x0
 a08:	c66080e7          	jalr	-922(ra) # 66a <printf>
 a0c:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a0e:	8926                	mv	s2,s1
 a10:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a12:	4b81                	li	s7,0
        lineCount = 1;
 a14:	8b6a                	mv	s6,s10
 a16:	a00d                	j	a38 <uniq_run+0x1a8>
              printf("%s",line1);
 a18:	85ca                	mv	a1,s2
 a1a:	856e                	mv	a0,s11
 a1c:	00000097          	auipc	ra,0x0
 a20:	c4e080e7          	jalr	-946(ra) # 66a <printf>
 a24:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a26:	8926                	mv	s2,s1
              printf("%s",line1);
 a28:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a2a:	4b81                	li	s7,0
        lineCount = 1;
 a2c:	8b6a                	mv	s6,s10
 a2e:	a029                	j	a38 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 a30:	000a0363          	beqz	s4,a36 <uniq_run+0x1a6>
 a34:	8bea                	mv	s7,s10
          lineCount++;
 a36:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 a38:	85a6                	mv	a1,s1
 a3a:	854e                	mv	a0,s3
 a3c:	00000097          	auipc	ra,0x0
 a40:	196080e7          	jalr	406(ra) # bd2 <read_line>
        if (readStatus == READ_EOF){
 a44:	d911                	beqz	a0,958 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 a46:	f7950be3          	beq	a0,s9,9bc <uniq_run+0x12c>
        if (!ignoreCase)
 a4a:	f80a92e3          	bnez	s5,9ce <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 a4e:	85a6                	mv	a1,s1
 a50:	854a                	mv	a0,s2
 a52:	00000097          	auipc	ra,0x0
 a56:	062080e7          	jalr	98(ra) # ab4 <compare_str>
        if (compareStatus != 0){ 
 a5a:	d979                	beqz	a0,a30 <uniq_run+0x1a0>
          if (repeatedLines){
 a5c:	f80a0ce3          	beqz	s4,9f4 <uniq_run+0x164>
            if (isRepeated){
 a60:	ec0b8be3          	beqz	s7,936 <uniq_run+0xa6>
                if (showCount)
 a64:	f60c0ce3          	beqz	s8,9dc <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 a68:	864a                	mv	a2,s2
 a6a:	85da                	mv	a1,s6
 a6c:	00000517          	auipc	a0,0x0
 a70:	31450513          	addi	a0,a0,788 # d80 <digits+0x70>
 a74:	00000097          	auipc	ra,0x0
 a78:	bf6080e7          	jalr	-1034(ra) # 66a <printf>
        lineCount = 1;
 a7c:	8b5e                	mv	s6,s7
 a7e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a80:	8926                	mv	s2,s1
 a82:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a84:	4b81                	li	s7,0
 a86:	bf4d                	j	a38 <uniq_run+0x1a8>

0000000000000a88 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 a88:	1141                	addi	sp,sp,-16
 a8a:	e422                	sd	s0,8(sp)
 a8c:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 a8e:	00054783          	lbu	a5,0(a0)
 a92:	cf99                	beqz	a5,ab0 <get_strlen+0x28>
 a94:	00150713          	addi	a4,a0,1
 a98:	87ba                	mv	a5,a4
 a9a:	4685                	li	a3,1
 a9c:	9e99                	subw	a3,a3,a4
 a9e:	00f6853b          	addw	a0,a3,a5
 aa2:	0785                	addi	a5,a5,1
 aa4:	fff7c703          	lbu	a4,-1(a5)
 aa8:	fb7d                	bnez	a4,a9e <get_strlen+0x16>
	return len;
}
 aaa:	6422                	ld	s0,8(sp)
 aac:	0141                	addi	sp,sp,16
 aae:	8082                	ret
	int len = 0;
 ab0:	4501                	li	a0,0
 ab2:	bfe5                	j	aaa <get_strlen+0x22>

0000000000000ab4 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 ab4:	1141                	addi	sp,sp,-16
 ab6:	e422                	sd	s0,8(sp)
 ab8:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 aba:	00054783          	lbu	a5,0(a0)
 abe:	cb91                	beqz	a5,ad2 <compare_str+0x1e>
 ac0:	0005c703          	lbu	a4,0(a1)
 ac4:	c719                	beqz	a4,ad2 <compare_str+0x1e>
		if (*s1++ != *s2++)
 ac6:	0505                	addi	a0,a0,1
 ac8:	0585                	addi	a1,a1,1
 aca:	fee788e3          	beq	a5,a4,aba <compare_str+0x6>
			return 1;
 ace:	4505                	li	a0,1
 ad0:	a031                	j	adc <compare_str+0x28>
	}
	if (*s1 == *s2)
 ad2:	0005c503          	lbu	a0,0(a1)
 ad6:	8d1d                	sub	a0,a0,a5
			return 1;
 ad8:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 adc:	6422                	ld	s0,8(sp)
 ade:	0141                	addi	sp,sp,16
 ae0:	8082                	ret

0000000000000ae2 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 ae2:	1141                	addi	sp,sp,-16
 ae4:	e422                	sd	s0,8(sp)
 ae6:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 ae8:	4665                	li	a2,25
	while(*s1 && *s2){
 aea:	a019                	j	af0 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 aec:	04e79763          	bne	a5,a4,b3a <compare_str_ic+0x58>
	while(*s1 && *s2){
 af0:	00054783          	lbu	a5,0(a0)
 af4:	cb9d                	beqz	a5,b2a <compare_str_ic+0x48>
 af6:	0005c703          	lbu	a4,0(a1)
 afa:	cb05                	beqz	a4,b2a <compare_str_ic+0x48>
		char b1 = *s1++;
 afc:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 afe:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b00:	fbf7869b          	addiw	a3,a5,-65
 b04:	0ff6f693          	zext.b	a3,a3
 b08:	00d66663          	bltu	a2,a3,b14 <compare_str_ic+0x32>
			b1 += 32;
 b0c:	0207879b          	addiw	a5,a5,32
 b10:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 b14:	fbf7069b          	addiw	a3,a4,-65
 b18:	0ff6f693          	zext.b	a3,a3
 b1c:	fcd668e3          	bltu	a2,a3,aec <compare_str_ic+0xa>
			b2 += 32;
 b20:	0207071b          	addiw	a4,a4,32
 b24:	0ff77713          	zext.b	a4,a4
 b28:	b7d1                	j	aec <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 b2a:	0005c503          	lbu	a0,0(a1)
 b2e:	8d1d                	sub	a0,a0,a5
			return 1;
 b30:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b34:	6422                	ld	s0,8(sp)
 b36:	0141                	addi	sp,sp,16
 b38:	8082                	ret
			return 1;
 b3a:	4505                	li	a0,1
 b3c:	bfe5                	j	b34 <compare_str_ic+0x52>

0000000000000b3e <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 b3e:	7179                	addi	sp,sp,-48
 b40:	f406                	sd	ra,40(sp)
 b42:	f022                	sd	s0,32(sp)
 b44:	ec26                	sd	s1,24(sp)
 b46:	e84a                	sd	s2,16(sp)
 b48:	e44e                	sd	s3,8(sp)
 b4a:	1800                	addi	s0,sp,48
 b4c:	89aa                	mv	s3,a0
 b4e:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 b50:	00000097          	auipc	ra,0x0
 b54:	f38080e7          	jalr	-200(ra) # a88 <get_strlen>
 b58:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 b5a:	854a                	mv	a0,s2
 b5c:	00000097          	auipc	ra,0x0
 b60:	f2c080e7          	jalr	-212(ra) # a88 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 b64:	409505bb          	subw	a1,a0,s1
 b68:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 b6a:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 b6c:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 b6e:	0005da63          	bgez	a1,b82 <check_substr+0x44>
 b72:	a81d                	j	ba8 <check_substr+0x6a>
        if (j == M)
 b74:	02f48a63          	beq	s1,a5,ba8 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 b78:	0885                	addi	a7,a7,1
 b7a:	0008879b          	sext.w	a5,a7
 b7e:	02f5cc63          	blt	a1,a5,bb6 <check_substr+0x78>
 b82:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 b86:	011906b3          	add	a3,s2,a7
 b8a:	874e                	mv	a4,s3
 b8c:	879a                	mv	a5,t1
 b8e:	fe9053e3          	blez	s1,b74 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 b92:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 b96:	00074603          	lbu	a2,0(a4)
 b9a:	fcc81de3          	bne	a6,a2,b74 <check_substr+0x36>
        for (j = 0; j < M; j++)
 b9e:	2785                	addiw	a5,a5,1
 ba0:	0685                	addi	a3,a3,1
 ba2:	0705                	addi	a4,a4,1
 ba4:	fef497e3          	bne	s1,a5,b92 <check_substr+0x54>
}
 ba8:	70a2                	ld	ra,40(sp)
 baa:	7402                	ld	s0,32(sp)
 bac:	64e2                	ld	s1,24(sp)
 bae:	6942                	ld	s2,16(sp)
 bb0:	69a2                	ld	s3,8(sp)
 bb2:	6145                	addi	sp,sp,48
 bb4:	8082                	ret
    return -1;
 bb6:	557d                	li	a0,-1
 bb8:	bfc5                	j	ba8 <check_substr+0x6a>

0000000000000bba <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 bba:	1141                	addi	sp,sp,-16
 bbc:	e406                	sd	ra,8(sp)
 bbe:	e022                	sd	s0,0(sp)
 bc0:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 bc2:	fffff097          	auipc	ra,0xfffff
 bc6:	72e080e7          	jalr	1838(ra) # 2f0 <open>
	return fd;
}
 bca:	60a2                	ld	ra,8(sp)
 bcc:	6402                	ld	s0,0(sp)
 bce:	0141                	addi	sp,sp,16
 bd0:	8082                	ret

0000000000000bd2 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 bd2:	7139                	addi	sp,sp,-64
 bd4:	fc06                	sd	ra,56(sp)
 bd6:	f822                	sd	s0,48(sp)
 bd8:	f426                	sd	s1,40(sp)
 bda:	f04a                	sd	s2,32(sp)
 bdc:	ec4e                	sd	s3,24(sp)
 bde:	e852                	sd	s4,16(sp)
 be0:	0080                	addi	s0,sp,64
 be2:	89aa                	mv	s3,a0
 be4:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 be6:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 be8:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 bea:	4605                	li	a2,1
 bec:	fcf40593          	addi	a1,s0,-49
 bf0:	854e                	mv	a0,s3
 bf2:	fffff097          	auipc	ra,0xfffff
 bf6:	6d6080e7          	jalr	1750(ra) # 2c8 <read>
		if (readStatus == 0){
 bfa:	c505                	beqz	a0,c22 <read_line+0x50>
		*buffer++ = readByte;
 bfc:	0485                	addi	s1,s1,1
 bfe:	fcf44783          	lbu	a5,-49(s0)
 c02:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c06:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c08:	ff4791e3          	bne	a5,s4,bea <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c0c:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 c10:	854a                	mv	a0,s2
 c12:	70e2                	ld	ra,56(sp)
 c14:	7442                	ld	s0,48(sp)
 c16:	74a2                	ld	s1,40(sp)
 c18:	7902                	ld	s2,32(sp)
 c1a:	69e2                	ld	s3,24(sp)
 c1c:	6a42                	ld	s4,16(sp)
 c1e:	6121                	addi	sp,sp,64
 c20:	8082                	ret
			if (byteCount!=0){
 c22:	fe0907e3          	beqz	s2,c10 <read_line+0x3e>
				*buffer = '\n';
 c26:	47a9                	li	a5,10
 c28:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 c2c:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 c30:	2905                	addiw	s2,s2,1
 c32:	bff9                	j	c10 <read_line+0x3e>

0000000000000c34 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c34:	1141                	addi	sp,sp,-16
 c36:	e406                	sd	ra,8(sp)
 c38:	e022                	sd	s0,0(sp)
 c3a:	0800                	addi	s0,sp,16
	close(fd);
 c3c:	fffff097          	auipc	ra,0xfffff
 c40:	69c080e7          	jalr	1692(ra) # 2d8 <close>
}
 c44:	60a2                	ld	ra,8(sp)
 c46:	6402                	ld	s0,0(sp)
 c48:	0141                	addi	sp,sp,16
 c4a:	8082                	ret

0000000000000c4c <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 c4c:	7139                	addi	sp,sp,-64
 c4e:	fc06                	sd	ra,56(sp)
 c50:	f822                	sd	s0,48(sp)
 c52:	f426                	sd	s1,40(sp)
 c54:	f04a                	sd	s2,32(sp)
 c56:	0080                	addi	s0,sp,64
 c58:	84aa                	mv	s1,a0
 c5a:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 c5c:	fffff097          	auipc	ra,0xfffff
 c60:	64c080e7          	jalr	1612(ra) # 2a8 <fork>
 c64:	ed19                	bnez	a0,c82 <get_time_perf+0x36>
		exec(argv[0],argv);
 c66:	85ca                	mv	a1,s2
 c68:	00093503          	ld	a0,0(s2)
 c6c:	fffff097          	auipc	ra,0xfffff
 c70:	67c080e7          	jalr	1660(ra) # 2e8 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 c74:	8526                	mv	a0,s1
 c76:	70e2                	ld	ra,56(sp)
 c78:	7442                	ld	s0,48(sp)
 c7a:	74a2                	ld	s1,40(sp)
 c7c:	7902                	ld	s2,32(sp)
 c7e:	6121                	addi	sp,sp,64
 c80:	8082                	ret
		times(pid , &time);
 c82:	fc040593          	addi	a1,s0,-64
 c86:	fffff097          	auipc	ra,0xfffff
 c8a:	6e2080e7          	jalr	1762(ra) # 368 <times>
		return time;
 c8e:	fc043783          	ld	a5,-64(s0)
 c92:	e09c                	sd	a5,0(s1)
 c94:	fc843783          	ld	a5,-56(s0)
 c98:	e49c                	sd	a5,8(s1)
 c9a:	fd043783          	ld	a5,-48(s0)
 c9e:	e89c                	sd	a5,16(s1)
 ca0:	fd843783          	ld	a5,-40(s0)
 ca4:	ec9c                	sd	a5,24(s1)
 ca6:	b7f9                	j	c74 <get_time_perf+0x28>
