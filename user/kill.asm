
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
  4c:	ca858593          	addi	a1,a1,-856 # cf0 <get_time_perf+0x6a>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	624080e7          	jalr	1572(ra) # 676 <fprintf>
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

00000000000003b2 <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 3b2:	48ed                	li	a7,27
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 3ba:	48f1                	li	a7,28
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 3c2:	48f5                	li	a7,29
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ca:	1101                	addi	sp,sp,-32
 3cc:	ec06                	sd	ra,24(sp)
 3ce:	e822                	sd	s0,16(sp)
 3d0:	1000                	addi	s0,sp,32
 3d2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d6:	4605                	li	a2,1
 3d8:	fef40593          	addi	a1,s0,-17
 3dc:	00000097          	auipc	ra,0x0
 3e0:	f2e080e7          	jalr	-210(ra) # 30a <write>
}
 3e4:	60e2                	ld	ra,24(sp)
 3e6:	6442                	ld	s0,16(sp)
 3e8:	6105                	addi	sp,sp,32
 3ea:	8082                	ret

00000000000003ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ec:	7139                	addi	sp,sp,-64
 3ee:	fc06                	sd	ra,56(sp)
 3f0:	f822                	sd	s0,48(sp)
 3f2:	f426                	sd	s1,40(sp)
 3f4:	f04a                	sd	s2,32(sp)
 3f6:	ec4e                	sd	s3,24(sp)
 3f8:	0080                	addi	s0,sp,64
 3fa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fc:	c299                	beqz	a3,402 <printint+0x16>
 3fe:	0805c963          	bltz	a1,490 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 402:	2581                	sext.w	a1,a1
  neg = 0;
 404:	4881                	li	a7,0
 406:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 40a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 40c:	2601                	sext.w	a2,a2
 40e:	00001517          	auipc	a0,0x1
 412:	95a50513          	addi	a0,a0,-1702 # d68 <digits>
 416:	883a                	mv	a6,a4
 418:	2705                	addiw	a4,a4,1
 41a:	02c5f7bb          	remuw	a5,a1,a2
 41e:	1782                	slli	a5,a5,0x20
 420:	9381                	srli	a5,a5,0x20
 422:	97aa                	add	a5,a5,a0
 424:	0007c783          	lbu	a5,0(a5)
 428:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 42c:	0005879b          	sext.w	a5,a1
 430:	02c5d5bb          	divuw	a1,a1,a2
 434:	0685                	addi	a3,a3,1
 436:	fec7f0e3          	bgeu	a5,a2,416 <printint+0x2a>
  if(neg)
 43a:	00088c63          	beqz	a7,452 <printint+0x66>
    buf[i++] = '-';
 43e:	fd070793          	addi	a5,a4,-48
 442:	00878733          	add	a4,a5,s0
 446:	02d00793          	li	a5,45
 44a:	fef70823          	sb	a5,-16(a4)
 44e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 452:	02e05863          	blez	a4,482 <printint+0x96>
 456:	fc040793          	addi	a5,s0,-64
 45a:	00e78933          	add	s2,a5,a4
 45e:	fff78993          	addi	s3,a5,-1
 462:	99ba                	add	s3,s3,a4
 464:	377d                	addiw	a4,a4,-1
 466:	1702                	slli	a4,a4,0x20
 468:	9301                	srli	a4,a4,0x20
 46a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 46e:	fff94583          	lbu	a1,-1(s2)
 472:	8526                	mv	a0,s1
 474:	00000097          	auipc	ra,0x0
 478:	f56080e7          	jalr	-170(ra) # 3ca <putc>
  while(--i >= 0)
 47c:	197d                	addi	s2,s2,-1
 47e:	ff3918e3          	bne	s2,s3,46e <printint+0x82>
}
 482:	70e2                	ld	ra,56(sp)
 484:	7442                	ld	s0,48(sp)
 486:	74a2                	ld	s1,40(sp)
 488:	7902                	ld	s2,32(sp)
 48a:	69e2                	ld	s3,24(sp)
 48c:	6121                	addi	sp,sp,64
 48e:	8082                	ret
    x = -xx;
 490:	40b005bb          	negw	a1,a1
    neg = 1;
 494:	4885                	li	a7,1
    x = -xx;
 496:	bf85                	j	406 <printint+0x1a>

0000000000000498 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 498:	7119                	addi	sp,sp,-128
 49a:	fc86                	sd	ra,120(sp)
 49c:	f8a2                	sd	s0,112(sp)
 49e:	f4a6                	sd	s1,104(sp)
 4a0:	f0ca                	sd	s2,96(sp)
 4a2:	ecce                	sd	s3,88(sp)
 4a4:	e8d2                	sd	s4,80(sp)
 4a6:	e4d6                	sd	s5,72(sp)
 4a8:	e0da                	sd	s6,64(sp)
 4aa:	fc5e                	sd	s7,56(sp)
 4ac:	f862                	sd	s8,48(sp)
 4ae:	f466                	sd	s9,40(sp)
 4b0:	f06a                	sd	s10,32(sp)
 4b2:	ec6e                	sd	s11,24(sp)
 4b4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b6:	0005c903          	lbu	s2,0(a1)
 4ba:	18090f63          	beqz	s2,658 <vprintf+0x1c0>
 4be:	8aaa                	mv	s5,a0
 4c0:	8b32                	mv	s6,a2
 4c2:	00158493          	addi	s1,a1,1
  state = 0;
 4c6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c8:	02500a13          	li	s4,37
 4cc:	4c55                	li	s8,21
 4ce:	00001c97          	auipc	s9,0x1
 4d2:	842c8c93          	addi	s9,s9,-1982 # d10 <get_time_perf+0x8a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4d6:	02800d93          	li	s11,40
  putc(fd, 'x');
 4da:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4dc:	00001b97          	auipc	s7,0x1
 4e0:	88cb8b93          	addi	s7,s7,-1908 # d68 <digits>
 4e4:	a839                	j	502 <vprintf+0x6a>
        putc(fd, c);
 4e6:	85ca                	mv	a1,s2
 4e8:	8556                	mv	a0,s5
 4ea:	00000097          	auipc	ra,0x0
 4ee:	ee0080e7          	jalr	-288(ra) # 3ca <putc>
 4f2:	a019                	j	4f8 <vprintf+0x60>
    } else if(state == '%'){
 4f4:	01498d63          	beq	s3,s4,50e <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4f8:	0485                	addi	s1,s1,1
 4fa:	fff4c903          	lbu	s2,-1(s1)
 4fe:	14090d63          	beqz	s2,658 <vprintf+0x1c0>
    if(state == 0){
 502:	fe0999e3          	bnez	s3,4f4 <vprintf+0x5c>
      if(c == '%'){
 506:	ff4910e3          	bne	s2,s4,4e6 <vprintf+0x4e>
        state = '%';
 50a:	89d2                	mv	s3,s4
 50c:	b7f5                	j	4f8 <vprintf+0x60>
      if(c == 'd'){
 50e:	11490c63          	beq	s2,s4,626 <vprintf+0x18e>
 512:	f9d9079b          	addiw	a5,s2,-99
 516:	0ff7f793          	zext.b	a5,a5
 51a:	10fc6e63          	bltu	s8,a5,636 <vprintf+0x19e>
 51e:	f9d9079b          	addiw	a5,s2,-99
 522:	0ff7f713          	zext.b	a4,a5
 526:	10ec6863          	bltu	s8,a4,636 <vprintf+0x19e>
 52a:	00271793          	slli	a5,a4,0x2
 52e:	97e6                	add	a5,a5,s9
 530:	439c                	lw	a5,0(a5)
 532:	97e6                	add	a5,a5,s9
 534:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 536:	008b0913          	addi	s2,s6,8
 53a:	4685                	li	a3,1
 53c:	4629                	li	a2,10
 53e:	000b2583          	lw	a1,0(s6)
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	ea8080e7          	jalr	-344(ra) # 3ec <printint>
 54c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 54e:	4981                	li	s3,0
 550:	b765                	j	4f8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 552:	008b0913          	addi	s2,s6,8
 556:	4681                	li	a3,0
 558:	4629                	li	a2,10
 55a:	000b2583          	lw	a1,0(s6)
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	e8c080e7          	jalr	-372(ra) # 3ec <printint>
 568:	8b4a                	mv	s6,s2
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b771                	j	4f8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 56e:	008b0913          	addi	s2,s6,8
 572:	4681                	li	a3,0
 574:	866a                	mv	a2,s10
 576:	000b2583          	lw	a1,0(s6)
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	e70080e7          	jalr	-400(ra) # 3ec <printint>
 584:	8b4a                	mv	s6,s2
      state = 0;
 586:	4981                	li	s3,0
 588:	bf85                	j	4f8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 58a:	008b0793          	addi	a5,s6,8
 58e:	f8f43423          	sd	a5,-120(s0)
 592:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 596:	03000593          	li	a1,48
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	e2e080e7          	jalr	-466(ra) # 3ca <putc>
  putc(fd, 'x');
 5a4:	07800593          	li	a1,120
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	e20080e7          	jalr	-480(ra) # 3ca <putc>
 5b2:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b4:	03c9d793          	srli	a5,s3,0x3c
 5b8:	97de                	add	a5,a5,s7
 5ba:	0007c583          	lbu	a1,0(a5)
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e0a080e7          	jalr	-502(ra) # 3ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5c8:	0992                	slli	s3,s3,0x4
 5ca:	397d                	addiw	s2,s2,-1
 5cc:	fe0914e3          	bnez	s2,5b4 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5d0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b70d                	j	4f8 <vprintf+0x60>
        s = va_arg(ap, char*);
 5d8:	008b0913          	addi	s2,s6,8
 5dc:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5e0:	02098163          	beqz	s3,602 <vprintf+0x16a>
        while(*s != 0){
 5e4:	0009c583          	lbu	a1,0(s3)
 5e8:	c5ad                	beqz	a1,652 <vprintf+0x1ba>
          putc(fd, *s);
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	dde080e7          	jalr	-546(ra) # 3ca <putc>
          s++;
 5f4:	0985                	addi	s3,s3,1
        while(*s != 0){
 5f6:	0009c583          	lbu	a1,0(s3)
 5fa:	f9e5                	bnez	a1,5ea <vprintf+0x152>
        s = va_arg(ap, char*);
 5fc:	8b4a                	mv	s6,s2
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bde5                	j	4f8 <vprintf+0x60>
          s = "(null)";
 602:	00000997          	auipc	s3,0x0
 606:	70698993          	addi	s3,s3,1798 # d08 <get_time_perf+0x82>
        while(*s != 0){
 60a:	85ee                	mv	a1,s11
 60c:	bff9                	j	5ea <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 60e:	008b0913          	addi	s2,s6,8
 612:	000b4583          	lbu	a1,0(s6)
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	db2080e7          	jalr	-590(ra) # 3ca <putc>
 620:	8b4a                	mv	s6,s2
      state = 0;
 622:	4981                	li	s3,0
 624:	bdd1                	j	4f8 <vprintf+0x60>
        putc(fd, c);
 626:	85d2                	mv	a1,s4
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	da0080e7          	jalr	-608(ra) # 3ca <putc>
      state = 0;
 632:	4981                	li	s3,0
 634:	b5d1                	j	4f8 <vprintf+0x60>
        putc(fd, '%');
 636:	85d2                	mv	a1,s4
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	d90080e7          	jalr	-624(ra) # 3ca <putc>
        putc(fd, c);
 642:	85ca                	mv	a1,s2
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	d84080e7          	jalr	-636(ra) # 3ca <putc>
      state = 0;
 64e:	4981                	li	s3,0
 650:	b565                	j	4f8 <vprintf+0x60>
        s = va_arg(ap, char*);
 652:	8b4a                	mv	s6,s2
      state = 0;
 654:	4981                	li	s3,0
 656:	b54d                	j	4f8 <vprintf+0x60>
    }
  }
}
 658:	70e6                	ld	ra,120(sp)
 65a:	7446                	ld	s0,112(sp)
 65c:	74a6                	ld	s1,104(sp)
 65e:	7906                	ld	s2,96(sp)
 660:	69e6                	ld	s3,88(sp)
 662:	6a46                	ld	s4,80(sp)
 664:	6aa6                	ld	s5,72(sp)
 666:	6b06                	ld	s6,64(sp)
 668:	7be2                	ld	s7,56(sp)
 66a:	7c42                	ld	s8,48(sp)
 66c:	7ca2                	ld	s9,40(sp)
 66e:	7d02                	ld	s10,32(sp)
 670:	6de2                	ld	s11,24(sp)
 672:	6109                	addi	sp,sp,128
 674:	8082                	ret

0000000000000676 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 676:	715d                	addi	sp,sp,-80
 678:	ec06                	sd	ra,24(sp)
 67a:	e822                	sd	s0,16(sp)
 67c:	1000                	addi	s0,sp,32
 67e:	e010                	sd	a2,0(s0)
 680:	e414                	sd	a3,8(s0)
 682:	e818                	sd	a4,16(s0)
 684:	ec1c                	sd	a5,24(s0)
 686:	03043023          	sd	a6,32(s0)
 68a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 68e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 692:	8622                	mv	a2,s0
 694:	00000097          	auipc	ra,0x0
 698:	e04080e7          	jalr	-508(ra) # 498 <vprintf>
}
 69c:	60e2                	ld	ra,24(sp)
 69e:	6442                	ld	s0,16(sp)
 6a0:	6161                	addi	sp,sp,80
 6a2:	8082                	ret

00000000000006a4 <printf>:

void
printf(const char *fmt, ...)
{
 6a4:	711d                	addi	sp,sp,-96
 6a6:	ec06                	sd	ra,24(sp)
 6a8:	e822                	sd	s0,16(sp)
 6aa:	1000                	addi	s0,sp,32
 6ac:	e40c                	sd	a1,8(s0)
 6ae:	e810                	sd	a2,16(s0)
 6b0:	ec14                	sd	a3,24(s0)
 6b2:	f018                	sd	a4,32(s0)
 6b4:	f41c                	sd	a5,40(s0)
 6b6:	03043823          	sd	a6,48(s0)
 6ba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6be:	00840613          	addi	a2,s0,8
 6c2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c6:	85aa                	mv	a1,a0
 6c8:	4505                	li	a0,1
 6ca:	00000097          	auipc	ra,0x0
 6ce:	dce080e7          	jalr	-562(ra) # 498 <vprintf>
}
 6d2:	60e2                	ld	ra,24(sp)
 6d4:	6442                	ld	s0,16(sp)
 6d6:	6125                	addi	sp,sp,96
 6d8:	8082                	ret

00000000000006da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6da:	1141                	addi	sp,sp,-16
 6dc:	e422                	sd	s0,8(sp)
 6de:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e4:	00001797          	auipc	a5,0x1
 6e8:	91c7b783          	ld	a5,-1764(a5) # 1000 <freep>
 6ec:	a02d                	j	716 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ee:	4618                	lw	a4,8(a2)
 6f0:	9f2d                	addw	a4,a4,a1
 6f2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f6:	6398                	ld	a4,0(a5)
 6f8:	6310                	ld	a2,0(a4)
 6fa:	a83d                	j	738 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6fc:	ff852703          	lw	a4,-8(a0)
 700:	9f31                	addw	a4,a4,a2
 702:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 704:	ff053683          	ld	a3,-16(a0)
 708:	a091                	j	74c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70a:	6398                	ld	a4,0(a5)
 70c:	00e7e463          	bltu	a5,a4,714 <free+0x3a>
 710:	00e6ea63          	bltu	a3,a4,724 <free+0x4a>
{
 714:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	fed7fae3          	bgeu	a5,a3,70a <free+0x30>
 71a:	6398                	ld	a4,0(a5)
 71c:	00e6e463          	bltu	a3,a4,724 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	fee7eae3          	bltu	a5,a4,714 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 724:	ff852583          	lw	a1,-8(a0)
 728:	6390                	ld	a2,0(a5)
 72a:	02059813          	slli	a6,a1,0x20
 72e:	01c85713          	srli	a4,a6,0x1c
 732:	9736                	add	a4,a4,a3
 734:	fae60de3          	beq	a2,a4,6ee <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 738:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 73c:	4790                	lw	a2,8(a5)
 73e:	02061593          	slli	a1,a2,0x20
 742:	01c5d713          	srli	a4,a1,0x1c
 746:	973e                	add	a4,a4,a5
 748:	fae68ae3          	beq	a3,a4,6fc <free+0x22>
    p->s.ptr = bp->s.ptr;
 74c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 74e:	00001717          	auipc	a4,0x1
 752:	8af73923          	sd	a5,-1870(a4) # 1000 <freep>
}
 756:	6422                	ld	s0,8(sp)
 758:	0141                	addi	sp,sp,16
 75a:	8082                	ret

000000000000075c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 75c:	7139                	addi	sp,sp,-64
 75e:	fc06                	sd	ra,56(sp)
 760:	f822                	sd	s0,48(sp)
 762:	f426                	sd	s1,40(sp)
 764:	f04a                	sd	s2,32(sp)
 766:	ec4e                	sd	s3,24(sp)
 768:	e852                	sd	s4,16(sp)
 76a:	e456                	sd	s5,8(sp)
 76c:	e05a                	sd	s6,0(sp)
 76e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 770:	02051493          	slli	s1,a0,0x20
 774:	9081                	srli	s1,s1,0x20
 776:	04bd                	addi	s1,s1,15
 778:	8091                	srli	s1,s1,0x4
 77a:	0014899b          	addiw	s3,s1,1
 77e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 780:	00001517          	auipc	a0,0x1
 784:	88053503          	ld	a0,-1920(a0) # 1000 <freep>
 788:	c515                	beqz	a0,7b4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78c:	4798                	lw	a4,8(a5)
 78e:	02977f63          	bgeu	a4,s1,7cc <malloc+0x70>
 792:	8a4e                	mv	s4,s3
 794:	0009871b          	sext.w	a4,s3
 798:	6685                	lui	a3,0x1
 79a:	00d77363          	bgeu	a4,a3,7a0 <malloc+0x44>
 79e:	6a05                	lui	s4,0x1
 7a0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a8:	00001917          	auipc	s2,0x1
 7ac:	85890913          	addi	s2,s2,-1960 # 1000 <freep>
  if(p == (char*)-1)
 7b0:	5afd                	li	s5,-1
 7b2:	a895                	j	826 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7b4:	00001797          	auipc	a5,0x1
 7b8:	85c78793          	addi	a5,a5,-1956 # 1010 <base>
 7bc:	00001717          	auipc	a4,0x1
 7c0:	84f73223          	sd	a5,-1980(a4) # 1000 <freep>
 7c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ca:	b7e1                	j	792 <malloc+0x36>
      if(p->s.size == nunits)
 7cc:	02e48c63          	beq	s1,a4,804 <malloc+0xa8>
        p->s.size -= nunits;
 7d0:	4137073b          	subw	a4,a4,s3
 7d4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d6:	02071693          	slli	a3,a4,0x20
 7da:	01c6d713          	srli	a4,a3,0x1c
 7de:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7e0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e4:	00001717          	auipc	a4,0x1
 7e8:	80a73e23          	sd	a0,-2020(a4) # 1000 <freep>
      return (void*)(p + 1);
 7ec:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7f0:	70e2                	ld	ra,56(sp)
 7f2:	7442                	ld	s0,48(sp)
 7f4:	74a2                	ld	s1,40(sp)
 7f6:	7902                	ld	s2,32(sp)
 7f8:	69e2                	ld	s3,24(sp)
 7fa:	6a42                	ld	s4,16(sp)
 7fc:	6aa2                	ld	s5,8(sp)
 7fe:	6b02                	ld	s6,0(sp)
 800:	6121                	addi	sp,sp,64
 802:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 804:	6398                	ld	a4,0(a5)
 806:	e118                	sd	a4,0(a0)
 808:	bff1                	j	7e4 <malloc+0x88>
  hp->s.size = nu;
 80a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80e:	0541                	addi	a0,a0,16
 810:	00000097          	auipc	ra,0x0
 814:	eca080e7          	jalr	-310(ra) # 6da <free>
  return freep;
 818:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 81c:	d971                	beqz	a0,7f0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 820:	4798                	lw	a4,8(a5)
 822:	fa9775e3          	bgeu	a4,s1,7cc <malloc+0x70>
    if(p == freep)
 826:	00093703          	ld	a4,0(s2)
 82a:	853e                	mv	a0,a5
 82c:	fef719e3          	bne	a4,a5,81e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 830:	8552                	mv	a0,s4
 832:	00000097          	auipc	ra,0x0
 836:	b40080e7          	jalr	-1216(ra) # 372 <sbrk>
  if(p == (char*)-1)
 83a:	fd5518e3          	bne	a0,s5,80a <malloc+0xae>
        return 0;
 83e:	4501                	li	a0,0
 840:	bf45                	j	7f0 <malloc+0x94>

0000000000000842 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 842:	c1d9                	beqz	a1,8c8 <head_run+0x86>
void head_run(int fd, int numOfLines){
 844:	dd010113          	addi	sp,sp,-560
 848:	22113423          	sd	ra,552(sp)
 84c:	22813023          	sd	s0,544(sp)
 850:	20913c23          	sd	s1,536(sp)
 854:	21213823          	sd	s2,528(sp)
 858:	21313423          	sd	s3,520(sp)
 85c:	21413023          	sd	s4,512(sp)
 860:	1c00                	addi	s0,sp,560
 862:	892a                	mv	s2,a0
 864:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 868:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 86a:	00000a17          	auipc	s4,0x0
 86e:	53ea0a13          	addi	s4,s4,1342 # da8 <digits+0x40>
		readStatus = read_line(fd, line);
 872:	dd840593          	addi	a1,s0,-552
 876:	854a                	mv	a0,s2
 878:	00000097          	auipc	ra,0x0
 87c:	394080e7          	jalr	916(ra) # c0c <read_line>
		if (readStatus == READ_ERROR){
 880:	01350d63          	beq	a0,s3,89a <head_run+0x58>
		if (readStatus == READ_EOF)
 884:	c11d                	beqz	a0,8aa <head_run+0x68>
		printf("%s",line);
 886:	dd840593          	addi	a1,s0,-552
 88a:	8552                	mv	a0,s4
 88c:	00000097          	auipc	ra,0x0
 890:	e18080e7          	jalr	-488(ra) # 6a4 <printf>
	while(numOfLines--){
 894:	34fd                	addiw	s1,s1,-1
 896:	fcf1                	bnez	s1,872 <head_run+0x30>
 898:	a809                	j	8aa <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 89a:	00000517          	auipc	a0,0x0
 89e:	4e650513          	addi	a0,a0,1254 # d80 <digits+0x18>
 8a2:	00000097          	auipc	ra,0x0
 8a6:	e02080e7          	jalr	-510(ra) # 6a4 <printf>

	}
}
 8aa:	22813083          	ld	ra,552(sp)
 8ae:	22013403          	ld	s0,544(sp)
 8b2:	21813483          	ld	s1,536(sp)
 8b6:	21013903          	ld	s2,528(sp)
 8ba:	20813983          	ld	s3,520(sp)
 8be:	20013a03          	ld	s4,512(sp)
 8c2:	23010113          	addi	sp,sp,560
 8c6:	8082                	ret
 8c8:	8082                	ret

00000000000008ca <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 8ca:	ba010113          	addi	sp,sp,-1120
 8ce:	44113c23          	sd	ra,1112(sp)
 8d2:	44813823          	sd	s0,1104(sp)
 8d6:	44913423          	sd	s1,1096(sp)
 8da:	45213023          	sd	s2,1088(sp)
 8de:	43313c23          	sd	s3,1080(sp)
 8e2:	43413823          	sd	s4,1072(sp)
 8e6:	43513423          	sd	s5,1064(sp)
 8ea:	43613023          	sd	s6,1056(sp)
 8ee:	41713c23          	sd	s7,1048(sp)
 8f2:	41813823          	sd	s8,1040(sp)
 8f6:	41913423          	sd	s9,1032(sp)
 8fa:	41a13023          	sd	s10,1024(sp)
 8fe:	3fb13c23          	sd	s11,1016(sp)
 902:	46010413          	addi	s0,sp,1120
 906:	89aa                	mv	s3,a0
 908:	8aae                	mv	s5,a1
 90a:	8c32                	mv	s8,a2
 90c:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 90e:	d9840593          	addi	a1,s0,-616
 912:	00000097          	auipc	ra,0x0
 916:	2fa080e7          	jalr	762(ra) # c0c <read_line>


  if (readStatus == READ_ERROR)
 91a:	57fd                	li	a5,-1
 91c:	04f50163          	beq	a0,a5,95e <uniq_run+0x94>
 920:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 922:	ed21                	bnez	a0,97a <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 924:	45813083          	ld	ra,1112(sp)
 928:	45013403          	ld	s0,1104(sp)
 92c:	44813483          	ld	s1,1096(sp)
 930:	44013903          	ld	s2,1088(sp)
 934:	43813983          	ld	s3,1080(sp)
 938:	43013a03          	ld	s4,1072(sp)
 93c:	42813a83          	ld	s5,1064(sp)
 940:	42013b03          	ld	s6,1056(sp)
 944:	41813b83          	ld	s7,1048(sp)
 948:	41013c03          	ld	s8,1040(sp)
 94c:	40813c83          	ld	s9,1032(sp)
 950:	40013d03          	ld	s10,1024(sp)
 954:	3f813d83          	ld	s11,1016(sp)
 958:	46010113          	addi	sp,sp,1120
 95c:	8082                	ret
    printf("[ERR] Error reading from the file ");
 95e:	00000517          	auipc	a0,0x0
 962:	45250513          	addi	a0,a0,1106 # db0 <digits+0x48>
 966:	00000097          	auipc	ra,0x0
 96a:	d3e080e7          	jalr	-706(ra) # 6a4 <printf>
 96e:	bf5d                	j	924 <uniq_run+0x5a>
 970:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 972:	8926                	mv	s2,s1
 974:	84be                	mv	s1,a5
        lineCount = 1;
 976:	8b6a                	mv	s6,s10
 978:	a8ed                	j	a72 <uniq_run+0x1a8>
    int lineCount=1;
 97a:	4b05                	li	s6,1
  char * line2 = buffer2;
 97c:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 980:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 984:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 986:	4d05                	li	s10,1
              printf("%s",line1);
 988:	00000d97          	auipc	s11,0x0
 98c:	420d8d93          	addi	s11,s11,1056 # da8 <digits+0x40>
 990:	a0cd                	j	a72 <uniq_run+0x1a8>
            if (repeatedLines){
 992:	020a0b63          	beqz	s4,9c8 <uniq_run+0xfe>
                if (isRepeated){
 996:	f80b87e3          	beqz	s7,924 <uniq_run+0x5a>
                    if (showCount)
 99a:	000c0d63          	beqz	s8,9b4 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 99e:	864a                	mv	a2,s2
 9a0:	85da                	mv	a1,s6
 9a2:	00000517          	auipc	a0,0x0
 9a6:	43650513          	addi	a0,a0,1078 # dd8 <digits+0x70>
 9aa:	00000097          	auipc	ra,0x0
 9ae:	cfa080e7          	jalr	-774(ra) # 6a4 <printf>
 9b2:	bf8d                	j	924 <uniq_run+0x5a>
                      printf("%s",line1);
 9b4:	85ca                	mv	a1,s2
 9b6:	00000517          	auipc	a0,0x0
 9ba:	3f250513          	addi	a0,a0,1010 # da8 <digits+0x40>
 9be:	00000097          	auipc	ra,0x0
 9c2:	ce6080e7          	jalr	-794(ra) # 6a4 <printf>
 9c6:	bfb9                	j	924 <uniq_run+0x5a>
                if (showCount)
 9c8:	000c0d63          	beqz	s8,9e2 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 9cc:	864a                	mv	a2,s2
 9ce:	85da                	mv	a1,s6
 9d0:	00000517          	auipc	a0,0x0
 9d4:	40850513          	addi	a0,a0,1032 # dd8 <digits+0x70>
 9d8:	00000097          	auipc	ra,0x0
 9dc:	ccc080e7          	jalr	-820(ra) # 6a4 <printf>
 9e0:	b791                	j	924 <uniq_run+0x5a>
                  printf("%s",line1);
 9e2:	85ca                	mv	a1,s2
 9e4:	00000517          	auipc	a0,0x0
 9e8:	3c450513          	addi	a0,a0,964 # da8 <digits+0x40>
 9ec:	00000097          	auipc	ra,0x0
 9f0:	cb8080e7          	jalr	-840(ra) # 6a4 <printf>
 9f4:	bf05                	j	924 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 9f6:	00000517          	auipc	a0,0x0
 9fa:	3ea50513          	addi	a0,a0,1002 # de0 <digits+0x78>
 9fe:	00000097          	auipc	ra,0x0
 a02:	ca6080e7          	jalr	-858(ra) # 6a4 <printf>
          break;
 a06:	bf39                	j	924 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 a08:	85a6                	mv	a1,s1
 a0a:	854a                	mv	a0,s2
 a0c:	00000097          	auipc	ra,0x0
 a10:	110080e7          	jalr	272(ra) # b1c <compare_str_ic>
 a14:	a041                	j	a94 <uniq_run+0x1ca>
                  printf("%s",line1);
 a16:	85ca                	mv	a1,s2
 a18:	856e                	mv	a0,s11
 a1a:	00000097          	auipc	ra,0x0
 a1e:	c8a080e7          	jalr	-886(ra) # 6a4 <printf>
        lineCount = 1;
 a22:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 a24:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a26:	8926                	mv	s2,s1
                  printf("%s",line1);
 a28:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a2a:	4b81                	li	s7,0
 a2c:	a099                	j	a72 <uniq_run+0x1a8>
            if (showCount)
 a2e:	020c0263          	beqz	s8,a52 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 a32:	864a                	mv	a2,s2
 a34:	85da                	mv	a1,s6
 a36:	00000517          	auipc	a0,0x0
 a3a:	3a250513          	addi	a0,a0,930 # dd8 <digits+0x70>
 a3e:	00000097          	auipc	ra,0x0
 a42:	c66080e7          	jalr	-922(ra) # 6a4 <printf>
 a46:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a48:	8926                	mv	s2,s1
 a4a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a4c:	4b81                	li	s7,0
        lineCount = 1;
 a4e:	8b6a                	mv	s6,s10
 a50:	a00d                	j	a72 <uniq_run+0x1a8>
              printf("%s",line1);
 a52:	85ca                	mv	a1,s2
 a54:	856e                	mv	a0,s11
 a56:	00000097          	auipc	ra,0x0
 a5a:	c4e080e7          	jalr	-946(ra) # 6a4 <printf>
 a5e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a60:	8926                	mv	s2,s1
              printf("%s",line1);
 a62:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a64:	4b81                	li	s7,0
        lineCount = 1;
 a66:	8b6a                	mv	s6,s10
 a68:	a029                	j	a72 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 a6a:	000a0363          	beqz	s4,a70 <uniq_run+0x1a6>
 a6e:	8bea                	mv	s7,s10
          lineCount++;
 a70:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 a72:	85a6                	mv	a1,s1
 a74:	854e                	mv	a0,s3
 a76:	00000097          	auipc	ra,0x0
 a7a:	196080e7          	jalr	406(ra) # c0c <read_line>
        if (readStatus == READ_EOF){
 a7e:	d911                	beqz	a0,992 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 a80:	f7950be3          	beq	a0,s9,9f6 <uniq_run+0x12c>
        if (!ignoreCase)
 a84:	f80a92e3          	bnez	s5,a08 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 a88:	85a6                	mv	a1,s1
 a8a:	854a                	mv	a0,s2
 a8c:	00000097          	auipc	ra,0x0
 a90:	062080e7          	jalr	98(ra) # aee <compare_str>
        if (compareStatus != 0){ 
 a94:	d979                	beqz	a0,a6a <uniq_run+0x1a0>
          if (repeatedLines){
 a96:	f80a0ce3          	beqz	s4,a2e <uniq_run+0x164>
            if (isRepeated){
 a9a:	ec0b8be3          	beqz	s7,970 <uniq_run+0xa6>
                if (showCount)
 a9e:	f60c0ce3          	beqz	s8,a16 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 aa2:	864a                	mv	a2,s2
 aa4:	85da                	mv	a1,s6
 aa6:	00000517          	auipc	a0,0x0
 aaa:	33250513          	addi	a0,a0,818 # dd8 <digits+0x70>
 aae:	00000097          	auipc	ra,0x0
 ab2:	bf6080e7          	jalr	-1034(ra) # 6a4 <printf>
        lineCount = 1;
 ab6:	8b5e                	mv	s6,s7
 ab8:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 aba:	8926                	mv	s2,s1
 abc:	84be                	mv	s1,a5
        isRepeated = 0 ;
 abe:	4b81                	li	s7,0
 ac0:	bf4d                	j	a72 <uniq_run+0x1a8>

0000000000000ac2 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 ac2:	1141                	addi	sp,sp,-16
 ac4:	e422                	sd	s0,8(sp)
 ac6:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 ac8:	00054783          	lbu	a5,0(a0)
 acc:	cf99                	beqz	a5,aea <get_strlen+0x28>
 ace:	00150713          	addi	a4,a0,1
 ad2:	87ba                	mv	a5,a4
 ad4:	4685                	li	a3,1
 ad6:	9e99                	subw	a3,a3,a4
 ad8:	00f6853b          	addw	a0,a3,a5
 adc:	0785                	addi	a5,a5,1
 ade:	fff7c703          	lbu	a4,-1(a5)
 ae2:	fb7d                	bnez	a4,ad8 <get_strlen+0x16>
	return len;
}
 ae4:	6422                	ld	s0,8(sp)
 ae6:	0141                	addi	sp,sp,16
 ae8:	8082                	ret
	int len = 0;
 aea:	4501                	li	a0,0
 aec:	bfe5                	j	ae4 <get_strlen+0x22>

0000000000000aee <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 aee:	1141                	addi	sp,sp,-16
 af0:	e422                	sd	s0,8(sp)
 af2:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 af4:	00054783          	lbu	a5,0(a0)
 af8:	cb91                	beqz	a5,b0c <compare_str+0x1e>
 afa:	0005c703          	lbu	a4,0(a1)
 afe:	c719                	beqz	a4,b0c <compare_str+0x1e>
		if (*s1++ != *s2++)
 b00:	0505                	addi	a0,a0,1
 b02:	0585                	addi	a1,a1,1
 b04:	fee788e3          	beq	a5,a4,af4 <compare_str+0x6>
			return 1;
 b08:	4505                	li	a0,1
 b0a:	a031                	j	b16 <compare_str+0x28>
	}
	if (*s1 == *s2)
 b0c:	0005c503          	lbu	a0,0(a1)
 b10:	8d1d                	sub	a0,a0,a5
			return 1;
 b12:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b16:	6422                	ld	s0,8(sp)
 b18:	0141                	addi	sp,sp,16
 b1a:	8082                	ret

0000000000000b1c <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 b1c:	1141                	addi	sp,sp,-16
 b1e:	e422                	sd	s0,8(sp)
 b20:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b22:	4665                	li	a2,25
	while(*s1 && *s2){
 b24:	a019                	j	b2a <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b26:	04e79763          	bne	a5,a4,b74 <compare_str_ic+0x58>
	while(*s1 && *s2){
 b2a:	00054783          	lbu	a5,0(a0)
 b2e:	cb9d                	beqz	a5,b64 <compare_str_ic+0x48>
 b30:	0005c703          	lbu	a4,0(a1)
 b34:	cb05                	beqz	a4,b64 <compare_str_ic+0x48>
		char b1 = *s1++;
 b36:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 b38:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b3a:	fbf7869b          	addiw	a3,a5,-65
 b3e:	0ff6f693          	zext.b	a3,a3
 b42:	00d66663          	bltu	a2,a3,b4e <compare_str_ic+0x32>
			b1 += 32;
 b46:	0207879b          	addiw	a5,a5,32
 b4a:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 b4e:	fbf7069b          	addiw	a3,a4,-65
 b52:	0ff6f693          	zext.b	a3,a3
 b56:	fcd668e3          	bltu	a2,a3,b26 <compare_str_ic+0xa>
			b2 += 32;
 b5a:	0207071b          	addiw	a4,a4,32
 b5e:	0ff77713          	zext.b	a4,a4
 b62:	b7d1                	j	b26 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 b64:	0005c503          	lbu	a0,0(a1)
 b68:	8d1d                	sub	a0,a0,a5
			return 1;
 b6a:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b6e:	6422                	ld	s0,8(sp)
 b70:	0141                	addi	sp,sp,16
 b72:	8082                	ret
			return 1;
 b74:	4505                	li	a0,1
 b76:	bfe5                	j	b6e <compare_str_ic+0x52>

0000000000000b78 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 b78:	7179                	addi	sp,sp,-48
 b7a:	f406                	sd	ra,40(sp)
 b7c:	f022                	sd	s0,32(sp)
 b7e:	ec26                	sd	s1,24(sp)
 b80:	e84a                	sd	s2,16(sp)
 b82:	e44e                	sd	s3,8(sp)
 b84:	1800                	addi	s0,sp,48
 b86:	89aa                	mv	s3,a0
 b88:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 b8a:	00000097          	auipc	ra,0x0
 b8e:	f38080e7          	jalr	-200(ra) # ac2 <get_strlen>
 b92:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 b94:	854a                	mv	a0,s2
 b96:	00000097          	auipc	ra,0x0
 b9a:	f2c080e7          	jalr	-212(ra) # ac2 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 b9e:	409505bb          	subw	a1,a0,s1
 ba2:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 ba4:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 ba6:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 ba8:	0005da63          	bgez	a1,bbc <check_substr+0x44>
 bac:	a81d                	j	be2 <check_substr+0x6a>
        if (j == M)
 bae:	02f48a63          	beq	s1,a5,be2 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 bb2:	0885                	addi	a7,a7,1
 bb4:	0008879b          	sext.w	a5,a7
 bb8:	02f5cc63          	blt	a1,a5,bf0 <check_substr+0x78>
 bbc:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 bc0:	011906b3          	add	a3,s2,a7
 bc4:	874e                	mv	a4,s3
 bc6:	879a                	mv	a5,t1
 bc8:	fe9053e3          	blez	s1,bae <check_substr+0x36>
            if (s2[i + j] != s1[j])
 bcc:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 bd0:	00074603          	lbu	a2,0(a4)
 bd4:	fcc81de3          	bne	a6,a2,bae <check_substr+0x36>
        for (j = 0; j < M; j++)
 bd8:	2785                	addiw	a5,a5,1
 bda:	0685                	addi	a3,a3,1
 bdc:	0705                	addi	a4,a4,1
 bde:	fef497e3          	bne	s1,a5,bcc <check_substr+0x54>
}
 be2:	70a2                	ld	ra,40(sp)
 be4:	7402                	ld	s0,32(sp)
 be6:	64e2                	ld	s1,24(sp)
 be8:	6942                	ld	s2,16(sp)
 bea:	69a2                	ld	s3,8(sp)
 bec:	6145                	addi	sp,sp,48
 bee:	8082                	ret
    return -1;
 bf0:	557d                	li	a0,-1
 bf2:	bfc5                	j	be2 <check_substr+0x6a>

0000000000000bf4 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 bf4:	1141                	addi	sp,sp,-16
 bf6:	e406                	sd	ra,8(sp)
 bf8:	e022                	sd	s0,0(sp)
 bfa:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 bfc:	fffff097          	auipc	ra,0xfffff
 c00:	72e080e7          	jalr	1838(ra) # 32a <open>
	return fd;
}
 c04:	60a2                	ld	ra,8(sp)
 c06:	6402                	ld	s0,0(sp)
 c08:	0141                	addi	sp,sp,16
 c0a:	8082                	ret

0000000000000c0c <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 c0c:	7139                	addi	sp,sp,-64
 c0e:	fc06                	sd	ra,56(sp)
 c10:	f822                	sd	s0,48(sp)
 c12:	f426                	sd	s1,40(sp)
 c14:	f04a                	sd	s2,32(sp)
 c16:	ec4e                	sd	s3,24(sp)
 c18:	e852                	sd	s4,16(sp)
 c1a:	0080                	addi	s0,sp,64
 c1c:	89aa                	mv	s3,a0
 c1e:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c20:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 c22:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c24:	4605                	li	a2,1
 c26:	fcf40593          	addi	a1,s0,-49
 c2a:	854e                	mv	a0,s3
 c2c:	fffff097          	auipc	ra,0xfffff
 c30:	6d6080e7          	jalr	1750(ra) # 302 <read>
		if (readStatus == 0){
 c34:	c505                	beqz	a0,c5c <read_line+0x50>
		*buffer++ = readByte;
 c36:	0485                	addi	s1,s1,1
 c38:	fcf44783          	lbu	a5,-49(s0)
 c3c:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c40:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c42:	ff4791e3          	bne	a5,s4,c24 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c46:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 c4a:	854a                	mv	a0,s2
 c4c:	70e2                	ld	ra,56(sp)
 c4e:	7442                	ld	s0,48(sp)
 c50:	74a2                	ld	s1,40(sp)
 c52:	7902                	ld	s2,32(sp)
 c54:	69e2                	ld	s3,24(sp)
 c56:	6a42                	ld	s4,16(sp)
 c58:	6121                	addi	sp,sp,64
 c5a:	8082                	ret
			if (byteCount!=0){
 c5c:	fe0907e3          	beqz	s2,c4a <read_line+0x3e>
				*buffer = '\n';
 c60:	47a9                	li	a5,10
 c62:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 c66:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 c6a:	2905                	addiw	s2,s2,1
 c6c:	bff9                	j	c4a <read_line+0x3e>

0000000000000c6e <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c6e:	1141                	addi	sp,sp,-16
 c70:	e406                	sd	ra,8(sp)
 c72:	e022                	sd	s0,0(sp)
 c74:	0800                	addi	s0,sp,16
	close(fd);
 c76:	fffff097          	auipc	ra,0xfffff
 c7a:	69c080e7          	jalr	1692(ra) # 312 <close>
}
 c7e:	60a2                	ld	ra,8(sp)
 c80:	6402                	ld	s0,0(sp)
 c82:	0141                	addi	sp,sp,16
 c84:	8082                	ret

0000000000000c86 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 c86:	7139                	addi	sp,sp,-64
 c88:	fc06                	sd	ra,56(sp)
 c8a:	f822                	sd	s0,48(sp)
 c8c:	f426                	sd	s1,40(sp)
 c8e:	f04a                	sd	s2,32(sp)
 c90:	0080                	addi	s0,sp,64
 c92:	84aa                	mv	s1,a0
 c94:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 c96:	fffff097          	auipc	ra,0xfffff
 c9a:	64c080e7          	jalr	1612(ra) # 2e2 <fork>
 c9e:	ed19                	bnez	a0,cbc <get_time_perf+0x36>
		exec(argv[0],argv);
 ca0:	85ca                	mv	a1,s2
 ca2:	00093503          	ld	a0,0(s2)
 ca6:	fffff097          	auipc	ra,0xfffff
 caa:	67c080e7          	jalr	1660(ra) # 322 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 cae:	8526                	mv	a0,s1
 cb0:	70e2                	ld	ra,56(sp)
 cb2:	7442                	ld	s0,48(sp)
 cb4:	74a2                	ld	s1,40(sp)
 cb6:	7902                	ld	s2,32(sp)
 cb8:	6121                	addi	sp,sp,64
 cba:	8082                	ret
		times(pid , &time);
 cbc:	fc040593          	addi	a1,s0,-64
 cc0:	fffff097          	auipc	ra,0xfffff
 cc4:	6e2080e7          	jalr	1762(ra) # 3a2 <times>
		return time;
 cc8:	fc043783          	ld	a5,-64(s0)
 ccc:	e09c                	sd	a5,0(s1)
 cce:	fc843783          	ld	a5,-56(s0)
 cd2:	e49c                	sd	a5,8(s1)
 cd4:	fd043783          	ld	a5,-48(s0)
 cd8:	e89c                	sd	a5,16(s1)
 cda:	fd843783          	ld	a5,-40(s0)
 cde:	ec9c                	sd	a5,24(s1)
 ce0:	b7f9                	j	cae <get_time_perf+0x28>
