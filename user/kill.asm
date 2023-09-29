
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7dd63          	bge	a5,a0,48 <main+0x48>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1c8080e7          	jalr	456(ra) # 1f0 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	2ea080e7          	jalr	746(ra) # 31a <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2aa080e7          	jalr	682(ra) # 2ea <exit>
    fprintf(2, "usage: kill pid...\n");
  48:	00001597          	auipc	a1,0x1
  4c:	c8858593          	addi	a1,a1,-888 # cd0 <get_time_perf+0x62>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	60c080e7          	jalr	1548(ra) # 65e <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	28e080e7          	jalr	654(ra) # 2ea <exit>

0000000000000064 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <main>
  exit(0);
  74:	4501                	li	a0,0
  76:	00000097          	auipc	ra,0x0
  7a:	274080e7          	jalr	628(ra) # 2ea <exit>

000000000000007e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  84:	87aa                	mv	a5,a0
  86:	0585                	addi	a1,a1,1
  88:	0785                	addi	a5,a5,1
  8a:	fff5c703          	lbu	a4,-1(a1)
  8e:	fee78fa3          	sb	a4,-1(a5)
  92:	fb75                	bnez	a4,86 <strcpy+0x8>
    ;
  return os;
}
  94:	6422                	ld	s0,8(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret

000000000000009a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	cb91                	beqz	a5,b8 <strcmp+0x1e>
  a6:	0005c703          	lbu	a4,0(a1)
  aa:	00f71763          	bne	a4,a5,b8 <strcmp+0x1e>
    p++, q++;
  ae:	0505                	addi	a0,a0,1
  b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	fbe5                	bnez	a5,a6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b8:	0005c503          	lbu	a0,0(a1)
}
  bc:	40a7853b          	subw	a0,a5,a0
  c0:	6422                	ld	s0,8(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strlen>:

uint
strlen(const char *s)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cf91                	beqz	a5,ec <strlen+0x26>
  d2:	0505                	addi	a0,a0,1
  d4:	87aa                	mv	a5,a0
  d6:	4685                	li	a3,1
  d8:	9e89                	subw	a3,a3,a0
  da:	00f6853b          	addw	a0,a3,a5
  de:	0785                	addi	a5,a5,1
  e0:	fff7c703          	lbu	a4,-1(a5)
  e4:	fb7d                	bnez	a4,da <strlen+0x14>
    ;
  return n;
}
  e6:	6422                	ld	s0,8(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret
  for(n = 0; s[n]; n++)
  ec:	4501                	li	a0,0
  ee:	bfe5                	j	e6 <strlen+0x20>

00000000000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f6:	ca19                	beqz	a2,10c <memset+0x1c>
  f8:	87aa                	mv	a5,a0
  fa:	1602                	slli	a2,a2,0x20
  fc:	9201                	srli	a2,a2,0x20
  fe:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 102:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 106:	0785                	addi	a5,a5,1
 108:	fee79de3          	bne	a5,a4,102 <memset+0x12>
  }
  return dst;
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strchr>:

char*
strchr(const char *s, char c)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  for(; *s; s++)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cb99                	beqz	a5,132 <strchr+0x20>
    if(*s == c)
 11e:	00f58763          	beq	a1,a5,12c <strchr+0x1a>
  for(; *s; s++)
 122:	0505                	addi	a0,a0,1
 124:	00054783          	lbu	a5,0(a0)
 128:	fbfd                	bnez	a5,11e <strchr+0xc>
      return (char*)s;
  return 0;
 12a:	4501                	li	a0,0
}
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret
  return 0;
 132:	4501                	li	a0,0
 134:	bfe5                	j	12c <strchr+0x1a>

0000000000000136 <gets>:

char*
gets(char *buf, int max)
{
 136:	711d                	addi	sp,sp,-96
 138:	ec86                	sd	ra,88(sp)
 13a:	e8a2                	sd	s0,80(sp)
 13c:	e4a6                	sd	s1,72(sp)
 13e:	e0ca                	sd	s2,64(sp)
 140:	fc4e                	sd	s3,56(sp)
 142:	f852                	sd	s4,48(sp)
 144:	f456                	sd	s5,40(sp)
 146:	f05a                	sd	s6,32(sp)
 148:	ec5e                	sd	s7,24(sp)
 14a:	1080                	addi	s0,sp,96
 14c:	8baa                	mv	s7,a0
 14e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 150:	892a                	mv	s2,a0
 152:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 154:	4aa9                	li	s5,10
 156:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 158:	89a6                	mv	s3,s1
 15a:	2485                	addiw	s1,s1,1
 15c:	0344d863          	bge	s1,s4,18c <gets+0x56>
    cc = read(0, &c, 1);
 160:	4605                	li	a2,1
 162:	faf40593          	addi	a1,s0,-81
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	19a080e7          	jalr	410(ra) # 302 <read>
    if(cc < 1)
 170:	00a05e63          	blez	a0,18c <gets+0x56>
    buf[i++] = c;
 174:	faf44783          	lbu	a5,-81(s0)
 178:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17c:	01578763          	beq	a5,s5,18a <gets+0x54>
 180:	0905                	addi	s2,s2,1
 182:	fd679be3          	bne	a5,s6,158 <gets+0x22>
  for(i=0; i+1 < max; ){
 186:	89a6                	mv	s3,s1
 188:	a011                	j	18c <gets+0x56>
 18a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 18c:	99de                	add	s3,s3,s7
 18e:	00098023          	sb	zero,0(s3)
  return buf;
}
 192:	855e                	mv	a0,s7
 194:	60e6                	ld	ra,88(sp)
 196:	6446                	ld	s0,80(sp)
 198:	64a6                	ld	s1,72(sp)
 19a:	6906                	ld	s2,64(sp)
 19c:	79e2                	ld	s3,56(sp)
 19e:	7a42                	ld	s4,48(sp)
 1a0:	7aa2                	ld	s5,40(sp)
 1a2:	7b02                	ld	s6,32(sp)
 1a4:	6be2                	ld	s7,24(sp)
 1a6:	6125                	addi	sp,sp,96
 1a8:	8082                	ret

00000000000001aa <stat>:

int
stat(const char *n, struct stat *st)
{
 1aa:	1101                	addi	sp,sp,-32
 1ac:	ec06                	sd	ra,24(sp)
 1ae:	e822                	sd	s0,16(sp)
 1b0:	e426                	sd	s1,8(sp)
 1b2:	e04a                	sd	s2,0(sp)
 1b4:	1000                	addi	s0,sp,32
 1b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b8:	4581                	li	a1,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	170080e7          	jalr	368(ra) # 32a <open>
  if(fd < 0)
 1c2:	02054563          	bltz	a0,1ec <stat+0x42>
 1c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	178080e7          	jalr	376(ra) # 342 <fstat>
 1d2:	892a                	mv	s2,a0
  close(fd);
 1d4:	8526                	mv	a0,s1
 1d6:	00000097          	auipc	ra,0x0
 1da:	13c080e7          	jalr	316(ra) # 312 <close>
  return r;
}
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	64a2                	ld	s1,8(sp)
 1e6:	6902                	ld	s2,0(sp)
 1e8:	6105                	addi	sp,sp,32
 1ea:	8082                	ret
    return -1;
 1ec:	597d                	li	s2,-1
 1ee:	bfc5                	j	1de <stat+0x34>

00000000000001f0 <atoi>:

int
atoi(const char *s)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f6:	00054683          	lbu	a3,0(a0)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	4625                	li	a2,9
 204:	02f66863          	bltu	a2,a5,234 <atoi+0x44>
 208:	872a                	mv	a4,a0
  n = 0;
 20a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20c:	0705                	addi	a4,a4,1
 20e:	0025179b          	slliw	a5,a0,0x2
 212:	9fa9                	addw	a5,a5,a0
 214:	0017979b          	slliw	a5,a5,0x1
 218:	9fb5                	addw	a5,a5,a3
 21a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21e:	00074683          	lbu	a3,0(a4)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	fef671e3          	bgeu	a2,a5,20c <atoi+0x1c>
  return n;
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  n = 0;
 234:	4501                	li	a0,0
 236:	bfe5                	j	22e <atoi+0x3e>

0000000000000238 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23e:	02b57463          	bgeu	a0,a1,266 <memmove+0x2e>
    while(n-- > 0)
 242:	00c05f63          	blez	a2,260 <memmove+0x28>
 246:	1602                	slli	a2,a2,0x20
 248:	9201                	srli	a2,a2,0x20
 24a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24e:	872a                	mv	a4,a0
      *dst++ = *src++;
 250:	0585                	addi	a1,a1,1
 252:	0705                	addi	a4,a4,1
 254:	fff5c683          	lbu	a3,-1(a1)
 258:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
    dst += n;
 266:	00c50733          	add	a4,a0,a2
    src += n;
 26a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26c:	fec05ae3          	blez	a2,260 <memmove+0x28>
 270:	fff6079b          	addiw	a5,a2,-1
 274:	1782                	slli	a5,a5,0x20
 276:	9381                	srli	a5,a5,0x20
 278:	fff7c793          	not	a5,a5
 27c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27e:	15fd                	addi	a1,a1,-1
 280:	177d                	addi	a4,a4,-1
 282:	0005c683          	lbu	a3,0(a1)
 286:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 28a:	fee79ae3          	bne	a5,a4,27e <memmove+0x46>
 28e:	bfc9                	j	260 <memmove+0x28>

0000000000000290 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 296:	ca05                	beqz	a2,2c6 <memcmp+0x36>
 298:	fff6069b          	addiw	a3,a2,-1
 29c:	1682                	slli	a3,a3,0x20
 29e:	9281                	srli	a3,a3,0x20
 2a0:	0685                	addi	a3,a3,1
 2a2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	0005c703          	lbu	a4,0(a1)
 2ac:	00e79863          	bne	a5,a4,2bc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2b0:	0505                	addi	a0,a0,1
    p2++;
 2b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b4:	fed518e3          	bne	a0,a3,2a4 <memcmp+0x14>
  }
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	a019                	j	2c0 <memcmp+0x30>
      return *p1 - *p2;
 2bc:	40e7853b          	subw	a0,a5,a4
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <memcmp+0x30>

00000000000002ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e406                	sd	ra,8(sp)
 2ce:	e022                	sd	s0,0(sp)
 2d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d2:	00000097          	auipc	ra,0x0
 2d6:	f66080e7          	jalr	-154(ra) # 238 <memmove>
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e2:	4885                	li	a7,1
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ea:	4889                	li	a7,2
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f2:	488d                	li	a7,3
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fa:	4891                	li	a7,4
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <read>:
.global read
read:
 li a7, SYS_read
 302:	4895                	li	a7,5
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <write>:
.global write
write:
 li a7, SYS_write
 30a:	48c1                	li	a7,16
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <close>:
.global close
close:
 li a7, SYS_close
 312:	48d5                	li	a7,21
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <kill>:
.global kill
kill:
 li a7, SYS_kill
 31a:	4899                	li	a7,6
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exec>:
.global exec
exec:
 li a7, SYS_exec
 322:	489d                	li	a7,7
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <open>:
.global open
open:
 li a7, SYS_open
 32a:	48bd                	li	a7,15
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 332:	48c5                	li	a7,17
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33a:	48c9                	li	a7,18
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 342:	48a1                	li	a7,8
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <link>:
.global link
link:
 li a7, SYS_link
 34a:	48cd                	li	a7,19
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 352:	48d1                	li	a7,20
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35a:	48a5                	li	a7,9
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <dup>:
.global dup
dup:
 li a7, SYS_dup
 362:	48a9                	li	a7,10
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36a:	48ad                	li	a7,11
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 372:	48b1                	li	a7,12
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 37a:	48b5                	li	a7,13
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 382:	48b9                	li	a7,14
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <head>:
.global head
head:
 li a7, SYS_head
 38a:	48d9                	li	a7,22
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 392:	48dd                	li	a7,23
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <ps>:
.global ps
ps:
 li a7, SYS_ps
 39a:	48e1                	li	a7,24
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <times>:
.global times
times:
 li a7, SYS_times
 3a2:	48e5                	li	a7,25
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 3aa:	48e9                	li	a7,26
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b2:	1101                	addi	sp,sp,-32
 3b4:	ec06                	sd	ra,24(sp)
 3b6:	e822                	sd	s0,16(sp)
 3b8:	1000                	addi	s0,sp,32
 3ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3be:	4605                	li	a2,1
 3c0:	fef40593          	addi	a1,s0,-17
 3c4:	00000097          	auipc	ra,0x0
 3c8:	f46080e7          	jalr	-186(ra) # 30a <write>
}
 3cc:	60e2                	ld	ra,24(sp)
 3ce:	6442                	ld	s0,16(sp)
 3d0:	6105                	addi	sp,sp,32
 3d2:	8082                	ret

00000000000003d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d4:	7139                	addi	sp,sp,-64
 3d6:	fc06                	sd	ra,56(sp)
 3d8:	f822                	sd	s0,48(sp)
 3da:	f426                	sd	s1,40(sp)
 3dc:	f04a                	sd	s2,32(sp)
 3de:	ec4e                	sd	s3,24(sp)
 3e0:	0080                	addi	s0,sp,64
 3e2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e4:	c299                	beqz	a3,3ea <printint+0x16>
 3e6:	0805c963          	bltz	a1,478 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ea:	2581                	sext.w	a1,a1
  neg = 0;
 3ec:	4881                	li	a7,0
 3ee:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f4:	2601                	sext.w	a2,a2
 3f6:	00001517          	auipc	a0,0x1
 3fa:	95250513          	addi	a0,a0,-1710 # d48 <digits>
 3fe:	883a                	mv	a6,a4
 400:	2705                	addiw	a4,a4,1
 402:	02c5f7bb          	remuw	a5,a1,a2
 406:	1782                	slli	a5,a5,0x20
 408:	9381                	srli	a5,a5,0x20
 40a:	97aa                	add	a5,a5,a0
 40c:	0007c783          	lbu	a5,0(a5)
 410:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 414:	0005879b          	sext.w	a5,a1
 418:	02c5d5bb          	divuw	a1,a1,a2
 41c:	0685                	addi	a3,a3,1
 41e:	fec7f0e3          	bgeu	a5,a2,3fe <printint+0x2a>
  if(neg)
 422:	00088c63          	beqz	a7,43a <printint+0x66>
    buf[i++] = '-';
 426:	fd070793          	addi	a5,a4,-48
 42a:	00878733          	add	a4,a5,s0
 42e:	02d00793          	li	a5,45
 432:	fef70823          	sb	a5,-16(a4)
 436:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 43a:	02e05863          	blez	a4,46a <printint+0x96>
 43e:	fc040793          	addi	a5,s0,-64
 442:	00e78933          	add	s2,a5,a4
 446:	fff78993          	addi	s3,a5,-1
 44a:	99ba                	add	s3,s3,a4
 44c:	377d                	addiw	a4,a4,-1
 44e:	1702                	slli	a4,a4,0x20
 450:	9301                	srli	a4,a4,0x20
 452:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 456:	fff94583          	lbu	a1,-1(s2)
 45a:	8526                	mv	a0,s1
 45c:	00000097          	auipc	ra,0x0
 460:	f56080e7          	jalr	-170(ra) # 3b2 <putc>
  while(--i >= 0)
 464:	197d                	addi	s2,s2,-1
 466:	ff3918e3          	bne	s2,s3,456 <printint+0x82>
}
 46a:	70e2                	ld	ra,56(sp)
 46c:	7442                	ld	s0,48(sp)
 46e:	74a2                	ld	s1,40(sp)
 470:	7902                	ld	s2,32(sp)
 472:	69e2                	ld	s3,24(sp)
 474:	6121                	addi	sp,sp,64
 476:	8082                	ret
    x = -xx;
 478:	40b005bb          	negw	a1,a1
    neg = 1;
 47c:	4885                	li	a7,1
    x = -xx;
 47e:	bf85                	j	3ee <printint+0x1a>

0000000000000480 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 480:	7119                	addi	sp,sp,-128
 482:	fc86                	sd	ra,120(sp)
 484:	f8a2                	sd	s0,112(sp)
 486:	f4a6                	sd	s1,104(sp)
 488:	f0ca                	sd	s2,96(sp)
 48a:	ecce                	sd	s3,88(sp)
 48c:	e8d2                	sd	s4,80(sp)
 48e:	e4d6                	sd	s5,72(sp)
 490:	e0da                	sd	s6,64(sp)
 492:	fc5e                	sd	s7,56(sp)
 494:	f862                	sd	s8,48(sp)
 496:	f466                	sd	s9,40(sp)
 498:	f06a                	sd	s10,32(sp)
 49a:	ec6e                	sd	s11,24(sp)
 49c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 49e:	0005c903          	lbu	s2,0(a1)
 4a2:	18090f63          	beqz	s2,640 <vprintf+0x1c0>
 4a6:	8aaa                	mv	s5,a0
 4a8:	8b32                	mv	s6,a2
 4aa:	00158493          	addi	s1,a1,1
  state = 0;
 4ae:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b0:	02500a13          	li	s4,37
 4b4:	4c55                	li	s8,21
 4b6:	00001c97          	auipc	s9,0x1
 4ba:	83ac8c93          	addi	s9,s9,-1990 # cf0 <get_time_perf+0x82>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4be:	02800d93          	li	s11,40
  putc(fd, 'x');
 4c2:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4c4:	00001b97          	auipc	s7,0x1
 4c8:	884b8b93          	addi	s7,s7,-1916 # d48 <digits>
 4cc:	a839                	j	4ea <vprintf+0x6a>
        putc(fd, c);
 4ce:	85ca                	mv	a1,s2
 4d0:	8556                	mv	a0,s5
 4d2:	00000097          	auipc	ra,0x0
 4d6:	ee0080e7          	jalr	-288(ra) # 3b2 <putc>
 4da:	a019                	j	4e0 <vprintf+0x60>
    } else if(state == '%'){
 4dc:	01498d63          	beq	s3,s4,4f6 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4e0:	0485                	addi	s1,s1,1
 4e2:	fff4c903          	lbu	s2,-1(s1)
 4e6:	14090d63          	beqz	s2,640 <vprintf+0x1c0>
    if(state == 0){
 4ea:	fe0999e3          	bnez	s3,4dc <vprintf+0x5c>
      if(c == '%'){
 4ee:	ff4910e3          	bne	s2,s4,4ce <vprintf+0x4e>
        state = '%';
 4f2:	89d2                	mv	s3,s4
 4f4:	b7f5                	j	4e0 <vprintf+0x60>
      if(c == 'd'){
 4f6:	11490c63          	beq	s2,s4,60e <vprintf+0x18e>
 4fa:	f9d9079b          	addiw	a5,s2,-99
 4fe:	0ff7f793          	zext.b	a5,a5
 502:	10fc6e63          	bltu	s8,a5,61e <vprintf+0x19e>
 506:	f9d9079b          	addiw	a5,s2,-99
 50a:	0ff7f713          	zext.b	a4,a5
 50e:	10ec6863          	bltu	s8,a4,61e <vprintf+0x19e>
 512:	00271793          	slli	a5,a4,0x2
 516:	97e6                	add	a5,a5,s9
 518:	439c                	lw	a5,0(a5)
 51a:	97e6                	add	a5,a5,s9
 51c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 51e:	008b0913          	addi	s2,s6,8
 522:	4685                	li	a3,1
 524:	4629                	li	a2,10
 526:	000b2583          	lw	a1,0(s6)
 52a:	8556                	mv	a0,s5
 52c:	00000097          	auipc	ra,0x0
 530:	ea8080e7          	jalr	-344(ra) # 3d4 <printint>
 534:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 536:	4981                	li	s3,0
 538:	b765                	j	4e0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 53a:	008b0913          	addi	s2,s6,8
 53e:	4681                	li	a3,0
 540:	4629                	li	a2,10
 542:	000b2583          	lw	a1,0(s6)
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e8c080e7          	jalr	-372(ra) # 3d4 <printint>
 550:	8b4a                	mv	s6,s2
      state = 0;
 552:	4981                	li	s3,0
 554:	b771                	j	4e0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 556:	008b0913          	addi	s2,s6,8
 55a:	4681                	li	a3,0
 55c:	866a                	mv	a2,s10
 55e:	000b2583          	lw	a1,0(s6)
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	e70080e7          	jalr	-400(ra) # 3d4 <printint>
 56c:	8b4a                	mv	s6,s2
      state = 0;
 56e:	4981                	li	s3,0
 570:	bf85                	j	4e0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 572:	008b0793          	addi	a5,s6,8
 576:	f8f43423          	sd	a5,-120(s0)
 57a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 57e:	03000593          	li	a1,48
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	e2e080e7          	jalr	-466(ra) # 3b2 <putc>
  putc(fd, 'x');
 58c:	07800593          	li	a1,120
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	e20080e7          	jalr	-480(ra) # 3b2 <putc>
 59a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 59c:	03c9d793          	srli	a5,s3,0x3c
 5a0:	97de                	add	a5,a5,s7
 5a2:	0007c583          	lbu	a1,0(a5)
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	e0a080e7          	jalr	-502(ra) # 3b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5b0:	0992                	slli	s3,s3,0x4
 5b2:	397d                	addiw	s2,s2,-1
 5b4:	fe0914e3          	bnez	s2,59c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5b8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b70d                	j	4e0 <vprintf+0x60>
        s = va_arg(ap, char*);
 5c0:	008b0913          	addi	s2,s6,8
 5c4:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5c8:	02098163          	beqz	s3,5ea <vprintf+0x16a>
        while(*s != 0){
 5cc:	0009c583          	lbu	a1,0(s3)
 5d0:	c5ad                	beqz	a1,63a <vprintf+0x1ba>
          putc(fd, *s);
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	dde080e7          	jalr	-546(ra) # 3b2 <putc>
          s++;
 5dc:	0985                	addi	s3,s3,1
        while(*s != 0){
 5de:	0009c583          	lbu	a1,0(s3)
 5e2:	f9e5                	bnez	a1,5d2 <vprintf+0x152>
        s = va_arg(ap, char*);
 5e4:	8b4a                	mv	s6,s2
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	bde5                	j	4e0 <vprintf+0x60>
          s = "(null)";
 5ea:	00000997          	auipc	s3,0x0
 5ee:	6fe98993          	addi	s3,s3,1790 # ce8 <get_time_perf+0x7a>
        while(*s != 0){
 5f2:	85ee                	mv	a1,s11
 5f4:	bff9                	j	5d2 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5f6:	008b0913          	addi	s2,s6,8
 5fa:	000b4583          	lbu	a1,0(s6)
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	db2080e7          	jalr	-590(ra) # 3b2 <putc>
 608:	8b4a                	mv	s6,s2
      state = 0;
 60a:	4981                	li	s3,0
 60c:	bdd1                	j	4e0 <vprintf+0x60>
        putc(fd, c);
 60e:	85d2                	mv	a1,s4
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	da0080e7          	jalr	-608(ra) # 3b2 <putc>
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b5d1                	j	4e0 <vprintf+0x60>
        putc(fd, '%');
 61e:	85d2                	mv	a1,s4
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	d90080e7          	jalr	-624(ra) # 3b2 <putc>
        putc(fd, c);
 62a:	85ca                	mv	a1,s2
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	d84080e7          	jalr	-636(ra) # 3b2 <putc>
      state = 0;
 636:	4981                	li	s3,0
 638:	b565                	j	4e0 <vprintf+0x60>
        s = va_arg(ap, char*);
 63a:	8b4a                	mv	s6,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b54d                	j	4e0 <vprintf+0x60>
    }
  }
}
 640:	70e6                	ld	ra,120(sp)
 642:	7446                	ld	s0,112(sp)
 644:	74a6                	ld	s1,104(sp)
 646:	7906                	ld	s2,96(sp)
 648:	69e6                	ld	s3,88(sp)
 64a:	6a46                	ld	s4,80(sp)
 64c:	6aa6                	ld	s5,72(sp)
 64e:	6b06                	ld	s6,64(sp)
 650:	7be2                	ld	s7,56(sp)
 652:	7c42                	ld	s8,48(sp)
 654:	7ca2                	ld	s9,40(sp)
 656:	7d02                	ld	s10,32(sp)
 658:	6de2                	ld	s11,24(sp)
 65a:	6109                	addi	sp,sp,128
 65c:	8082                	ret

000000000000065e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 65e:	715d                	addi	sp,sp,-80
 660:	ec06                	sd	ra,24(sp)
 662:	e822                	sd	s0,16(sp)
 664:	1000                	addi	s0,sp,32
 666:	e010                	sd	a2,0(s0)
 668:	e414                	sd	a3,8(s0)
 66a:	e818                	sd	a4,16(s0)
 66c:	ec1c                	sd	a5,24(s0)
 66e:	03043023          	sd	a6,32(s0)
 672:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 676:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 67a:	8622                	mv	a2,s0
 67c:	00000097          	auipc	ra,0x0
 680:	e04080e7          	jalr	-508(ra) # 480 <vprintf>
}
 684:	60e2                	ld	ra,24(sp)
 686:	6442                	ld	s0,16(sp)
 688:	6161                	addi	sp,sp,80
 68a:	8082                	ret

000000000000068c <printf>:

void
printf(const char *fmt, ...)
{
 68c:	711d                	addi	sp,sp,-96
 68e:	ec06                	sd	ra,24(sp)
 690:	e822                	sd	s0,16(sp)
 692:	1000                	addi	s0,sp,32
 694:	e40c                	sd	a1,8(s0)
 696:	e810                	sd	a2,16(s0)
 698:	ec14                	sd	a3,24(s0)
 69a:	f018                	sd	a4,32(s0)
 69c:	f41c                	sd	a5,40(s0)
 69e:	03043823          	sd	a6,48(s0)
 6a2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a6:	00840613          	addi	a2,s0,8
 6aa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ae:	85aa                	mv	a1,a0
 6b0:	4505                	li	a0,1
 6b2:	00000097          	auipc	ra,0x0
 6b6:	dce080e7          	jalr	-562(ra) # 480 <vprintf>
}
 6ba:	60e2                	ld	ra,24(sp)
 6bc:	6442                	ld	s0,16(sp)
 6be:	6125                	addi	sp,sp,96
 6c0:	8082                	ret

00000000000006c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c2:	1141                	addi	sp,sp,-16
 6c4:	e422                	sd	s0,8(sp)
 6c6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6cc:	00001797          	auipc	a5,0x1
 6d0:	9347b783          	ld	a5,-1740(a5) # 1000 <freep>
 6d4:	a02d                	j	6fe <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d6:	4618                	lw	a4,8(a2)
 6d8:	9f2d                	addw	a4,a4,a1
 6da:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6de:	6398                	ld	a4,0(a5)
 6e0:	6310                	ld	a2,0(a4)
 6e2:	a83d                	j	720 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6e4:	ff852703          	lw	a4,-8(a0)
 6e8:	9f31                	addw	a4,a4,a2
 6ea:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6ec:	ff053683          	ld	a3,-16(a0)
 6f0:	a091                	j	734 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f2:	6398                	ld	a4,0(a5)
 6f4:	00e7e463          	bltu	a5,a4,6fc <free+0x3a>
 6f8:	00e6ea63          	bltu	a3,a4,70c <free+0x4a>
{
 6fc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fe:	fed7fae3          	bgeu	a5,a3,6f2 <free+0x30>
 702:	6398                	ld	a4,0(a5)
 704:	00e6e463          	bltu	a3,a4,70c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 708:	fee7eae3          	bltu	a5,a4,6fc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 70c:	ff852583          	lw	a1,-8(a0)
 710:	6390                	ld	a2,0(a5)
 712:	02059813          	slli	a6,a1,0x20
 716:	01c85713          	srli	a4,a6,0x1c
 71a:	9736                	add	a4,a4,a3
 71c:	fae60de3          	beq	a2,a4,6d6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 720:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 724:	4790                	lw	a2,8(a5)
 726:	02061593          	slli	a1,a2,0x20
 72a:	01c5d713          	srli	a4,a1,0x1c
 72e:	973e                	add	a4,a4,a5
 730:	fae68ae3          	beq	a3,a4,6e4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 734:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 736:	00001717          	auipc	a4,0x1
 73a:	8cf73523          	sd	a5,-1846(a4) # 1000 <freep>
}
 73e:	6422                	ld	s0,8(sp)
 740:	0141                	addi	sp,sp,16
 742:	8082                	ret

0000000000000744 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 744:	7139                	addi	sp,sp,-64
 746:	fc06                	sd	ra,56(sp)
 748:	f822                	sd	s0,48(sp)
 74a:	f426                	sd	s1,40(sp)
 74c:	f04a                	sd	s2,32(sp)
 74e:	ec4e                	sd	s3,24(sp)
 750:	e852                	sd	s4,16(sp)
 752:	e456                	sd	s5,8(sp)
 754:	e05a                	sd	s6,0(sp)
 756:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 758:	02051493          	slli	s1,a0,0x20
 75c:	9081                	srli	s1,s1,0x20
 75e:	04bd                	addi	s1,s1,15
 760:	8091                	srli	s1,s1,0x4
 762:	0014899b          	addiw	s3,s1,1
 766:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 768:	00001517          	auipc	a0,0x1
 76c:	89853503          	ld	a0,-1896(a0) # 1000 <freep>
 770:	c515                	beqz	a0,79c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 772:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 774:	4798                	lw	a4,8(a5)
 776:	02977f63          	bgeu	a4,s1,7b4 <malloc+0x70>
 77a:	8a4e                	mv	s4,s3
 77c:	0009871b          	sext.w	a4,s3
 780:	6685                	lui	a3,0x1
 782:	00d77363          	bgeu	a4,a3,788 <malloc+0x44>
 786:	6a05                	lui	s4,0x1
 788:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 78c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 790:	00001917          	auipc	s2,0x1
 794:	87090913          	addi	s2,s2,-1936 # 1000 <freep>
  if(p == (char*)-1)
 798:	5afd                	li	s5,-1
 79a:	a895                	j	80e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 79c:	00001797          	auipc	a5,0x1
 7a0:	87478793          	addi	a5,a5,-1932 # 1010 <base>
 7a4:	00001717          	auipc	a4,0x1
 7a8:	84f73e23          	sd	a5,-1956(a4) # 1000 <freep>
 7ac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ae:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7b2:	b7e1                	j	77a <malloc+0x36>
      if(p->s.size == nunits)
 7b4:	02e48c63          	beq	s1,a4,7ec <malloc+0xa8>
        p->s.size -= nunits;
 7b8:	4137073b          	subw	a4,a4,s3
 7bc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7be:	02071693          	slli	a3,a4,0x20
 7c2:	01c6d713          	srli	a4,a3,0x1c
 7c6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7c8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7cc:	00001717          	auipc	a4,0x1
 7d0:	82a73a23          	sd	a0,-1996(a4) # 1000 <freep>
      return (void*)(p + 1);
 7d4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7d8:	70e2                	ld	ra,56(sp)
 7da:	7442                	ld	s0,48(sp)
 7dc:	74a2                	ld	s1,40(sp)
 7de:	7902                	ld	s2,32(sp)
 7e0:	69e2                	ld	s3,24(sp)
 7e2:	6a42                	ld	s4,16(sp)
 7e4:	6aa2                	ld	s5,8(sp)
 7e6:	6b02                	ld	s6,0(sp)
 7e8:	6121                	addi	sp,sp,64
 7ea:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7ec:	6398                	ld	a4,0(a5)
 7ee:	e118                	sd	a4,0(a0)
 7f0:	bff1                	j	7cc <malloc+0x88>
  hp->s.size = nu;
 7f2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f6:	0541                	addi	a0,a0,16
 7f8:	00000097          	auipc	ra,0x0
 7fc:	eca080e7          	jalr	-310(ra) # 6c2 <free>
  return freep;
 800:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 804:	d971                	beqz	a0,7d8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 806:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 808:	4798                	lw	a4,8(a5)
 80a:	fa9775e3          	bgeu	a4,s1,7b4 <malloc+0x70>
    if(p == freep)
 80e:	00093703          	ld	a4,0(s2)
 812:	853e                	mv	a0,a5
 814:	fef719e3          	bne	a4,a5,806 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 818:	8552                	mv	a0,s4
 81a:	00000097          	auipc	ra,0x0
 81e:	b58080e7          	jalr	-1192(ra) # 372 <sbrk>
  if(p == (char*)-1)
 822:	fd5518e3          	bne	a0,s5,7f2 <malloc+0xae>
        return 0;
 826:	4501                	li	a0,0
 828:	bf45                	j	7d8 <malloc+0x94>

000000000000082a <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 82a:	c1d9                	beqz	a1,8b0 <head_run+0x86>
void head_run(int fd, int numOfLines){
 82c:	dd010113          	addi	sp,sp,-560
 830:	22113423          	sd	ra,552(sp)
 834:	22813023          	sd	s0,544(sp)
 838:	20913c23          	sd	s1,536(sp)
 83c:	21213823          	sd	s2,528(sp)
 840:	21313423          	sd	s3,520(sp)
 844:	21413023          	sd	s4,512(sp)
 848:	1c00                	addi	s0,sp,560
 84a:	892a                	mv	s2,a0
 84c:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 850:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 852:	00000a17          	auipc	s4,0x0
 856:	536a0a13          	addi	s4,s4,1334 # d88 <digits+0x40>
		readStatus = read_line(fd, line);
 85a:	dd840593          	addi	a1,s0,-552
 85e:	854a                	mv	a0,s2
 860:	00000097          	auipc	ra,0x0
 864:	394080e7          	jalr	916(ra) # bf4 <read_line>
		if (readStatus == READ_ERROR){
 868:	01350d63          	beq	a0,s3,882 <head_run+0x58>
		if (readStatus == READ_EOF)
 86c:	c11d                	beqz	a0,892 <head_run+0x68>
		printf("%s",line);
 86e:	dd840593          	addi	a1,s0,-552
 872:	8552                	mv	a0,s4
 874:	00000097          	auipc	ra,0x0
 878:	e18080e7          	jalr	-488(ra) # 68c <printf>
	while(numOfLines--){
 87c:	34fd                	addiw	s1,s1,-1
 87e:	fcf1                	bnez	s1,85a <head_run+0x30>
 880:	a809                	j	892 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 882:	00000517          	auipc	a0,0x0
 886:	4de50513          	addi	a0,a0,1246 # d60 <digits+0x18>
 88a:	00000097          	auipc	ra,0x0
 88e:	e02080e7          	jalr	-510(ra) # 68c <printf>

	}
}
 892:	22813083          	ld	ra,552(sp)
 896:	22013403          	ld	s0,544(sp)
 89a:	21813483          	ld	s1,536(sp)
 89e:	21013903          	ld	s2,528(sp)
 8a2:	20813983          	ld	s3,520(sp)
 8a6:	20013a03          	ld	s4,512(sp)
 8aa:	23010113          	addi	sp,sp,560
 8ae:	8082                	ret
 8b0:	8082                	ret

00000000000008b2 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 8b2:	ba010113          	addi	sp,sp,-1120
 8b6:	44113c23          	sd	ra,1112(sp)
 8ba:	44813823          	sd	s0,1104(sp)
 8be:	44913423          	sd	s1,1096(sp)
 8c2:	45213023          	sd	s2,1088(sp)
 8c6:	43313c23          	sd	s3,1080(sp)
 8ca:	43413823          	sd	s4,1072(sp)
 8ce:	43513423          	sd	s5,1064(sp)
 8d2:	43613023          	sd	s6,1056(sp)
 8d6:	41713c23          	sd	s7,1048(sp)
 8da:	41813823          	sd	s8,1040(sp)
 8de:	41913423          	sd	s9,1032(sp)
 8e2:	41a13023          	sd	s10,1024(sp)
 8e6:	3fb13c23          	sd	s11,1016(sp)
 8ea:	46010413          	addi	s0,sp,1120
 8ee:	89aa                	mv	s3,a0
 8f0:	8aae                	mv	s5,a1
 8f2:	8c32                	mv	s8,a2
 8f4:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 8f6:	d9840593          	addi	a1,s0,-616
 8fa:	00000097          	auipc	ra,0x0
 8fe:	2fa080e7          	jalr	762(ra) # bf4 <read_line>


  if (readStatus == READ_ERROR)
 902:	57fd                	li	a5,-1
 904:	04f50163          	beq	a0,a5,946 <uniq_run+0x94>
 908:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 90a:	ed21                	bnez	a0,962 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 90c:	45813083          	ld	ra,1112(sp)
 910:	45013403          	ld	s0,1104(sp)
 914:	44813483          	ld	s1,1096(sp)
 918:	44013903          	ld	s2,1088(sp)
 91c:	43813983          	ld	s3,1080(sp)
 920:	43013a03          	ld	s4,1072(sp)
 924:	42813a83          	ld	s5,1064(sp)
 928:	42013b03          	ld	s6,1056(sp)
 92c:	41813b83          	ld	s7,1048(sp)
 930:	41013c03          	ld	s8,1040(sp)
 934:	40813c83          	ld	s9,1032(sp)
 938:	40013d03          	ld	s10,1024(sp)
 93c:	3f813d83          	ld	s11,1016(sp)
 940:	46010113          	addi	sp,sp,1120
 944:	8082                	ret
    printf("[ERR] Error reading from the file ");
 946:	00000517          	auipc	a0,0x0
 94a:	44a50513          	addi	a0,a0,1098 # d90 <digits+0x48>
 94e:	00000097          	auipc	ra,0x0
 952:	d3e080e7          	jalr	-706(ra) # 68c <printf>
 956:	bf5d                	j	90c <uniq_run+0x5a>
 958:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 95a:	8926                	mv	s2,s1
 95c:	84be                	mv	s1,a5
        lineCount = 1;
 95e:	8b6a                	mv	s6,s10
 960:	a8ed                	j	a5a <uniq_run+0x1a8>
    int lineCount=1;
 962:	4b05                	li	s6,1
  char * line2 = buffer2;
 964:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 968:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 96c:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 96e:	4d05                	li	s10,1
              printf("%s",line1);
 970:	00000d97          	auipc	s11,0x0
 974:	418d8d93          	addi	s11,s11,1048 # d88 <digits+0x40>
 978:	a0cd                	j	a5a <uniq_run+0x1a8>
            if (repeatedLines){
 97a:	020a0b63          	beqz	s4,9b0 <uniq_run+0xfe>
                if (isRepeated){
 97e:	f80b87e3          	beqz	s7,90c <uniq_run+0x5a>
                    if (showCount)
 982:	000c0d63          	beqz	s8,99c <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 986:	864a                	mv	a2,s2
 988:	85da                	mv	a1,s6
 98a:	00000517          	auipc	a0,0x0
 98e:	42e50513          	addi	a0,a0,1070 # db8 <digits+0x70>
 992:	00000097          	auipc	ra,0x0
 996:	cfa080e7          	jalr	-774(ra) # 68c <printf>
 99a:	bf8d                	j	90c <uniq_run+0x5a>
                      printf("%s",line1);
 99c:	85ca                	mv	a1,s2
 99e:	00000517          	auipc	a0,0x0
 9a2:	3ea50513          	addi	a0,a0,1002 # d88 <digits+0x40>
 9a6:	00000097          	auipc	ra,0x0
 9aa:	ce6080e7          	jalr	-794(ra) # 68c <printf>
 9ae:	bfb9                	j	90c <uniq_run+0x5a>
                if (showCount)
 9b0:	000c0d63          	beqz	s8,9ca <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 9b4:	864a                	mv	a2,s2
 9b6:	85da                	mv	a1,s6
 9b8:	00000517          	auipc	a0,0x0
 9bc:	40050513          	addi	a0,a0,1024 # db8 <digits+0x70>
 9c0:	00000097          	auipc	ra,0x0
 9c4:	ccc080e7          	jalr	-820(ra) # 68c <printf>
 9c8:	b791                	j	90c <uniq_run+0x5a>
                  printf("%s",line1);
 9ca:	85ca                	mv	a1,s2
 9cc:	00000517          	auipc	a0,0x0
 9d0:	3bc50513          	addi	a0,a0,956 # d88 <digits+0x40>
 9d4:	00000097          	auipc	ra,0x0
 9d8:	cb8080e7          	jalr	-840(ra) # 68c <printf>
 9dc:	bf05                	j	90c <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 9de:	00000517          	auipc	a0,0x0
 9e2:	3e250513          	addi	a0,a0,994 # dc0 <digits+0x78>
 9e6:	00000097          	auipc	ra,0x0
 9ea:	ca6080e7          	jalr	-858(ra) # 68c <printf>
          break;
 9ee:	bf39                	j	90c <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 9f0:	85a6                	mv	a1,s1
 9f2:	854a                	mv	a0,s2
 9f4:	00000097          	auipc	ra,0x0
 9f8:	110080e7          	jalr	272(ra) # b04 <compare_str_ic>
 9fc:	a041                	j	a7c <uniq_run+0x1ca>
                  printf("%s",line1);
 9fe:	85ca                	mv	a1,s2
 a00:	856e                	mv	a0,s11
 a02:	00000097          	auipc	ra,0x0
 a06:	c8a080e7          	jalr	-886(ra) # 68c <printf>
        lineCount = 1;
 a0a:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 a0c:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a0e:	8926                	mv	s2,s1
                  printf("%s",line1);
 a10:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a12:	4b81                	li	s7,0
 a14:	a099                	j	a5a <uniq_run+0x1a8>
            if (showCount)
 a16:	020c0263          	beqz	s8,a3a <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 a1a:	864a                	mv	a2,s2
 a1c:	85da                	mv	a1,s6
 a1e:	00000517          	auipc	a0,0x0
 a22:	39a50513          	addi	a0,a0,922 # db8 <digits+0x70>
 a26:	00000097          	auipc	ra,0x0
 a2a:	c66080e7          	jalr	-922(ra) # 68c <printf>
 a2e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a30:	8926                	mv	s2,s1
 a32:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a34:	4b81                	li	s7,0
        lineCount = 1;
 a36:	8b6a                	mv	s6,s10
 a38:	a00d                	j	a5a <uniq_run+0x1a8>
              printf("%s",line1);
 a3a:	85ca                	mv	a1,s2
 a3c:	856e                	mv	a0,s11
 a3e:	00000097          	auipc	ra,0x0
 a42:	c4e080e7          	jalr	-946(ra) # 68c <printf>
 a46:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a48:	8926                	mv	s2,s1
              printf("%s",line1);
 a4a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a4c:	4b81                	li	s7,0
        lineCount = 1;
 a4e:	8b6a                	mv	s6,s10
 a50:	a029                	j	a5a <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 a52:	000a0363          	beqz	s4,a58 <uniq_run+0x1a6>
 a56:	8bea                	mv	s7,s10
          lineCount++;
 a58:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 a5a:	85a6                	mv	a1,s1
 a5c:	854e                	mv	a0,s3
 a5e:	00000097          	auipc	ra,0x0
 a62:	196080e7          	jalr	406(ra) # bf4 <read_line>
        if (readStatus == READ_EOF){
 a66:	d911                	beqz	a0,97a <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 a68:	f7950be3          	beq	a0,s9,9de <uniq_run+0x12c>
        if (!ignoreCase)
 a6c:	f80a92e3          	bnez	s5,9f0 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 a70:	85a6                	mv	a1,s1
 a72:	854a                	mv	a0,s2
 a74:	00000097          	auipc	ra,0x0
 a78:	062080e7          	jalr	98(ra) # ad6 <compare_str>
        if (compareStatus != 0){ 
 a7c:	d979                	beqz	a0,a52 <uniq_run+0x1a0>
          if (repeatedLines){
 a7e:	f80a0ce3          	beqz	s4,a16 <uniq_run+0x164>
            if (isRepeated){
 a82:	ec0b8be3          	beqz	s7,958 <uniq_run+0xa6>
                if (showCount)
 a86:	f60c0ce3          	beqz	s8,9fe <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 a8a:	864a                	mv	a2,s2
 a8c:	85da                	mv	a1,s6
 a8e:	00000517          	auipc	a0,0x0
 a92:	32a50513          	addi	a0,a0,810 # db8 <digits+0x70>
 a96:	00000097          	auipc	ra,0x0
 a9a:	bf6080e7          	jalr	-1034(ra) # 68c <printf>
        lineCount = 1;
 a9e:	8b5e                	mv	s6,s7
 aa0:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 aa2:	8926                	mv	s2,s1
 aa4:	84be                	mv	s1,a5
        isRepeated = 0 ;
 aa6:	4b81                	li	s7,0
 aa8:	bf4d                	j	a5a <uniq_run+0x1a8>

0000000000000aaa <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 aaa:	1141                	addi	sp,sp,-16
 aac:	e422                	sd	s0,8(sp)
 aae:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 ab0:	00054783          	lbu	a5,0(a0)
 ab4:	cf99                	beqz	a5,ad2 <get_strlen+0x28>
 ab6:	00150713          	addi	a4,a0,1
 aba:	87ba                	mv	a5,a4
 abc:	4685                	li	a3,1
 abe:	9e99                	subw	a3,a3,a4
 ac0:	00f6853b          	addw	a0,a3,a5
 ac4:	0785                	addi	a5,a5,1
 ac6:	fff7c703          	lbu	a4,-1(a5)
 aca:	fb7d                	bnez	a4,ac0 <get_strlen+0x16>
	return len;
}
 acc:	6422                	ld	s0,8(sp)
 ace:	0141                	addi	sp,sp,16
 ad0:	8082                	ret
	int len = 0;
 ad2:	4501                	li	a0,0
 ad4:	bfe5                	j	acc <get_strlen+0x22>

0000000000000ad6 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 ad6:	1141                	addi	sp,sp,-16
 ad8:	e422                	sd	s0,8(sp)
 ada:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 adc:	00054783          	lbu	a5,0(a0)
 ae0:	cb91                	beqz	a5,af4 <compare_str+0x1e>
 ae2:	0005c703          	lbu	a4,0(a1)
 ae6:	c719                	beqz	a4,af4 <compare_str+0x1e>
		if (*s1++ != *s2++)
 ae8:	0505                	addi	a0,a0,1
 aea:	0585                	addi	a1,a1,1
 aec:	fee788e3          	beq	a5,a4,adc <compare_str+0x6>
			return 1;
 af0:	4505                	li	a0,1
 af2:	a031                	j	afe <compare_str+0x28>
	}
	if (*s1 == *s2)
 af4:	0005c503          	lbu	a0,0(a1)
 af8:	8d1d                	sub	a0,a0,a5
			return 1;
 afa:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 afe:	6422                	ld	s0,8(sp)
 b00:	0141                	addi	sp,sp,16
 b02:	8082                	ret

0000000000000b04 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 b04:	1141                	addi	sp,sp,-16
 b06:	e422                	sd	s0,8(sp)
 b08:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b0a:	4665                	li	a2,25
	while(*s1 && *s2){
 b0c:	a019                	j	b12 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b0e:	04e79763          	bne	a5,a4,b5c <compare_str_ic+0x58>
	while(*s1 && *s2){
 b12:	00054783          	lbu	a5,0(a0)
 b16:	cb9d                	beqz	a5,b4c <compare_str_ic+0x48>
 b18:	0005c703          	lbu	a4,0(a1)
 b1c:	cb05                	beqz	a4,b4c <compare_str_ic+0x48>
		char b1 = *s1++;
 b1e:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 b20:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b22:	fbf7869b          	addiw	a3,a5,-65
 b26:	0ff6f693          	zext.b	a3,a3
 b2a:	00d66663          	bltu	a2,a3,b36 <compare_str_ic+0x32>
			b1 += 32;
 b2e:	0207879b          	addiw	a5,a5,32
 b32:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 b36:	fbf7069b          	addiw	a3,a4,-65
 b3a:	0ff6f693          	zext.b	a3,a3
 b3e:	fcd668e3          	bltu	a2,a3,b0e <compare_str_ic+0xa>
			b2 += 32;
 b42:	0207071b          	addiw	a4,a4,32
 b46:	0ff77713          	zext.b	a4,a4
 b4a:	b7d1                	j	b0e <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 b4c:	0005c503          	lbu	a0,0(a1)
 b50:	8d1d                	sub	a0,a0,a5
			return 1;
 b52:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b56:	6422                	ld	s0,8(sp)
 b58:	0141                	addi	sp,sp,16
 b5a:	8082                	ret
			return 1;
 b5c:	4505                	li	a0,1
 b5e:	bfe5                	j	b56 <compare_str_ic+0x52>

0000000000000b60 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 b60:	7179                	addi	sp,sp,-48
 b62:	f406                	sd	ra,40(sp)
 b64:	f022                	sd	s0,32(sp)
 b66:	ec26                	sd	s1,24(sp)
 b68:	e84a                	sd	s2,16(sp)
 b6a:	e44e                	sd	s3,8(sp)
 b6c:	1800                	addi	s0,sp,48
 b6e:	89aa                	mv	s3,a0
 b70:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 b72:	00000097          	auipc	ra,0x0
 b76:	f38080e7          	jalr	-200(ra) # aaa <get_strlen>
 b7a:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 b7c:	854a                	mv	a0,s2
 b7e:	00000097          	auipc	ra,0x0
 b82:	f2c080e7          	jalr	-212(ra) # aaa <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 b86:	409505bb          	subw	a1,a0,s1
 b8a:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 b8c:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 b8e:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 b90:	0005da63          	bgez	a1,ba4 <check_substr+0x44>
 b94:	a81d                	j	bca <check_substr+0x6a>
        if (j == M)
 b96:	02f48a63          	beq	s1,a5,bca <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 b9a:	0885                	addi	a7,a7,1
 b9c:	0008879b          	sext.w	a5,a7
 ba0:	02f5cc63          	blt	a1,a5,bd8 <check_substr+0x78>
 ba4:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 ba8:	011906b3          	add	a3,s2,a7
 bac:	874e                	mv	a4,s3
 bae:	879a                	mv	a5,t1
 bb0:	fe9053e3          	blez	s1,b96 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 bb4:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 bb8:	00074603          	lbu	a2,0(a4)
 bbc:	fcc81de3          	bne	a6,a2,b96 <check_substr+0x36>
        for (j = 0; j < M; j++)
 bc0:	2785                	addiw	a5,a5,1
 bc2:	0685                	addi	a3,a3,1
 bc4:	0705                	addi	a4,a4,1
 bc6:	fef497e3          	bne	s1,a5,bb4 <check_substr+0x54>
}
 bca:	70a2                	ld	ra,40(sp)
 bcc:	7402                	ld	s0,32(sp)
 bce:	64e2                	ld	s1,24(sp)
 bd0:	6942                	ld	s2,16(sp)
 bd2:	69a2                	ld	s3,8(sp)
 bd4:	6145                	addi	sp,sp,48
 bd6:	8082                	ret
    return -1;
 bd8:	557d                	li	a0,-1
 bda:	bfc5                	j	bca <check_substr+0x6a>

0000000000000bdc <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 bdc:	1141                	addi	sp,sp,-16
 bde:	e406                	sd	ra,8(sp)
 be0:	e022                	sd	s0,0(sp)
 be2:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 be4:	fffff097          	auipc	ra,0xfffff
 be8:	746080e7          	jalr	1862(ra) # 32a <open>
	return fd;
}
 bec:	60a2                	ld	ra,8(sp)
 bee:	6402                	ld	s0,0(sp)
 bf0:	0141                	addi	sp,sp,16
 bf2:	8082                	ret

0000000000000bf4 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 bf4:	7139                	addi	sp,sp,-64
 bf6:	fc06                	sd	ra,56(sp)
 bf8:	f822                	sd	s0,48(sp)
 bfa:	f426                	sd	s1,40(sp)
 bfc:	f04a                	sd	s2,32(sp)
 bfe:	ec4e                	sd	s3,24(sp)
 c00:	e852                	sd	s4,16(sp)
 c02:	0080                	addi	s0,sp,64
 c04:	89aa                	mv	s3,a0
 c06:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c08:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 c0a:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c0c:	4605                	li	a2,1
 c0e:	fcf40593          	addi	a1,s0,-49
 c12:	854e                	mv	a0,s3
 c14:	fffff097          	auipc	ra,0xfffff
 c18:	6ee080e7          	jalr	1774(ra) # 302 <read>
		if (readStatus == 0){
 c1c:	c505                	beqz	a0,c44 <read_line+0x50>
		*buffer++ = readByte;
 c1e:	0485                	addi	s1,s1,1
 c20:	fcf44783          	lbu	a5,-49(s0)
 c24:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c28:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c2a:	ff4791e3          	bne	a5,s4,c0c <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c2e:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 c32:	854a                	mv	a0,s2
 c34:	70e2                	ld	ra,56(sp)
 c36:	7442                	ld	s0,48(sp)
 c38:	74a2                	ld	s1,40(sp)
 c3a:	7902                	ld	s2,32(sp)
 c3c:	69e2                	ld	s3,24(sp)
 c3e:	6a42                	ld	s4,16(sp)
 c40:	6121                	addi	sp,sp,64
 c42:	8082                	ret
			if (byteCount!=0){
 c44:	fe0907e3          	beqz	s2,c32 <read_line+0x3e>
				*buffer = '\n';
 c48:	47a9                	li	a5,10
 c4a:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 c4e:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 c52:	2905                	addiw	s2,s2,1
 c54:	bff9                	j	c32 <read_line+0x3e>

0000000000000c56 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c56:	1141                	addi	sp,sp,-16
 c58:	e406                	sd	ra,8(sp)
 c5a:	e022                	sd	s0,0(sp)
 c5c:	0800                	addi	s0,sp,16
	close(fd);
 c5e:	fffff097          	auipc	ra,0xfffff
 c62:	6b4080e7          	jalr	1716(ra) # 312 <close>
}
 c66:	60a2                	ld	ra,8(sp)
 c68:	6402                	ld	s0,0(sp)
 c6a:	0141                	addi	sp,sp,16
 c6c:	8082                	ret

0000000000000c6e <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 c6e:	7139                	addi	sp,sp,-64
 c70:	fc06                	sd	ra,56(sp)
 c72:	f822                	sd	s0,48(sp)
 c74:	f426                	sd	s1,40(sp)
 c76:	f04a                	sd	s2,32(sp)
 c78:	0080                	addi	s0,sp,64
 c7a:	84aa                	mv	s1,a0
 c7c:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 c7e:	fffff097          	auipc	ra,0xfffff
 c82:	664080e7          	jalr	1636(ra) # 2e2 <fork>
 c86:	ed19                	bnez	a0,ca4 <get_time_perf+0x36>
		exec(argv[0],argv);
 c88:	85ca                	mv	a1,s2
 c8a:	00093503          	ld	a0,0(s2)
 c8e:	fffff097          	auipc	ra,0xfffff
 c92:	694080e7          	jalr	1684(ra) # 322 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 c96:	8526                	mv	a0,s1
 c98:	70e2                	ld	ra,56(sp)
 c9a:	7442                	ld	s0,48(sp)
 c9c:	74a2                	ld	s1,40(sp)
 c9e:	7902                	ld	s2,32(sp)
 ca0:	6121                	addi	sp,sp,64
 ca2:	8082                	ret
		times(pid , &time);
 ca4:	fc840593          	addi	a1,s0,-56
 ca8:	fffff097          	auipc	ra,0xfffff
 cac:	6fa080e7          	jalr	1786(ra) # 3a2 <times>
		return time;
 cb0:	fc843783          	ld	a5,-56(s0)
 cb4:	e09c                	sd	a5,0(s1)
 cb6:	fd043783          	ld	a5,-48(s0)
 cba:	e49c                	sd	a5,8(s1)
 cbc:	fd843783          	ld	a5,-40(s0)
 cc0:	e89c                	sd	a5,16(s1)
 cc2:	bfd1                	j	c96 <get_time_perf+0x28>
