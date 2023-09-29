
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  if(argc != 3){
   a:	478d                	li	a5,3
   c:	02f50063          	beq	a0,a5,2c <main+0x2c>
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	cb058593          	addi	a1,a1,-848 # cc0 <get_time_perf+0x56>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	640080e7          	jalr	1600(ra) # 65a <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2c2080e7          	jalr	706(ra) # 2e6 <exit>
  2c:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  2e:	698c                	ld	a1,16(a1)
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	314080e7          	jalr	788(ra) # 346 <link>
  3a:	00054763          	bltz	a0,48 <main+0x48>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2a6080e7          	jalr	678(ra) # 2e6 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	6894                	ld	a3,16(s1)
  4a:	6490                	ld	a2,8(s1)
  4c:	00001597          	auipc	a1,0x1
  50:	c8c58593          	addi	a1,a1,-884 # cd8 <get_time_perf+0x6e>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	604080e7          	jalr	1540(ra) # 65a <fprintf>
  5e:	b7c5                	j	3e <main+0x3e>

0000000000000060 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  60:	1141                	addi	sp,sp,-16
  62:	e406                	sd	ra,8(sp)
  64:	e022                	sd	s0,0(sp)
  66:	0800                	addi	s0,sp,16
  extern int main();
  main();
  68:	00000097          	auipc	ra,0x0
  6c:	f98080e7          	jalr	-104(ra) # 0 <main>
  exit(0);
  70:	4501                	li	a0,0
  72:	00000097          	auipc	ra,0x0
  76:	274080e7          	jalr	628(ra) # 2e6 <exit>

000000000000007a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e422                	sd	s0,8(sp)
  7e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	87aa                	mv	a5,a0
  82:	0585                	addi	a1,a1,1
  84:	0785                	addi	a5,a5,1
  86:	fff5c703          	lbu	a4,-1(a1)
  8a:	fee78fa3          	sb	a4,-1(a5)
  8e:	fb75                	bnez	a4,82 <strcpy+0x8>
    ;
  return os;
}
  90:	6422                	ld	s0,8(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	1141                	addi	sp,sp,-16
  98:	e422                	sd	s0,8(sp)
  9a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9c:	00054783          	lbu	a5,0(a0)
  a0:	cb91                	beqz	a5,b4 <strcmp+0x1e>
  a2:	0005c703          	lbu	a4,0(a1)
  a6:	00f71763          	bne	a4,a5,b4 <strcmp+0x1e>
    p++, q++;
  aa:	0505                	addi	a0,a0,1
  ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	fbe5                	bnez	a5,a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b4:	0005c503          	lbu	a0,0(a1)
}
  b8:	40a7853b          	subw	a0,a5,a0
  bc:	6422                	ld	s0,8(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strlen>:

uint
strlen(const char *s)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e422                	sd	s0,8(sp)
  c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cf91                	beqz	a5,e8 <strlen+0x26>
  ce:	0505                	addi	a0,a0,1
  d0:	87aa                	mv	a5,a0
  d2:	4685                	li	a3,1
  d4:	9e89                	subw	a3,a3,a0
  d6:	00f6853b          	addw	a0,a3,a5
  da:	0785                	addi	a5,a5,1
  dc:	fff7c703          	lbu	a4,-1(a5)
  e0:	fb7d                	bnez	a4,d6 <strlen+0x14>
    ;
  return n;
}
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret
  for(n = 0; s[n]; n++)
  e8:	4501                	li	a0,0
  ea:	bfe5                	j	e2 <strlen+0x20>

00000000000000ec <memset>:

void*
memset(void *dst, int c, uint n)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e422                	sd	s0,8(sp)
  f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f2:	ca19                	beqz	a2,108 <memset+0x1c>
  f4:	87aa                	mv	a5,a0
  f6:	1602                	slli	a2,a2,0x20
  f8:	9201                	srli	a2,a2,0x20
  fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 102:	0785                	addi	a5,a5,1
 104:	fee79de3          	bne	a5,a4,fe <memset+0x12>
  }
  return dst;
}
 108:	6422                	ld	s0,8(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret

000000000000010e <strchr>:

char*
strchr(const char *s, char c)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  for(; *s; s++)
 114:	00054783          	lbu	a5,0(a0)
 118:	cb99                	beqz	a5,12e <strchr+0x20>
    if(*s == c)
 11a:	00f58763          	beq	a1,a5,128 <strchr+0x1a>
  for(; *s; s++)
 11e:	0505                	addi	a0,a0,1
 120:	00054783          	lbu	a5,0(a0)
 124:	fbfd                	bnez	a5,11a <strchr+0xc>
      return (char*)s;
  return 0;
 126:	4501                	li	a0,0
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret
  return 0;
 12e:	4501                	li	a0,0
 130:	bfe5                	j	128 <strchr+0x1a>

0000000000000132 <gets>:

char*
gets(char *buf, int max)
{
 132:	711d                	addi	sp,sp,-96
 134:	ec86                	sd	ra,88(sp)
 136:	e8a2                	sd	s0,80(sp)
 138:	e4a6                	sd	s1,72(sp)
 13a:	e0ca                	sd	s2,64(sp)
 13c:	fc4e                	sd	s3,56(sp)
 13e:	f852                	sd	s4,48(sp)
 140:	f456                	sd	s5,40(sp)
 142:	f05a                	sd	s6,32(sp)
 144:	ec5e                	sd	s7,24(sp)
 146:	1080                	addi	s0,sp,96
 148:	8baa                	mv	s7,a0
 14a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14c:	892a                	mv	s2,a0
 14e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 150:	4aa9                	li	s5,10
 152:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 154:	89a6                	mv	s3,s1
 156:	2485                	addiw	s1,s1,1
 158:	0344d863          	bge	s1,s4,188 <gets+0x56>
    cc = read(0, &c, 1);
 15c:	4605                	li	a2,1
 15e:	faf40593          	addi	a1,s0,-81
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	19a080e7          	jalr	410(ra) # 2fe <read>
    if(cc < 1)
 16c:	00a05e63          	blez	a0,188 <gets+0x56>
    buf[i++] = c;
 170:	faf44783          	lbu	a5,-81(s0)
 174:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 178:	01578763          	beq	a5,s5,186 <gets+0x54>
 17c:	0905                	addi	s2,s2,1
 17e:	fd679be3          	bne	a5,s6,154 <gets+0x22>
  for(i=0; i+1 < max; ){
 182:	89a6                	mv	s3,s1
 184:	a011                	j	188 <gets+0x56>
 186:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 188:	99de                	add	s3,s3,s7
 18a:	00098023          	sb	zero,0(s3)
  return buf;
}
 18e:	855e                	mv	a0,s7
 190:	60e6                	ld	ra,88(sp)
 192:	6446                	ld	s0,80(sp)
 194:	64a6                	ld	s1,72(sp)
 196:	6906                	ld	s2,64(sp)
 198:	79e2                	ld	s3,56(sp)
 19a:	7a42                	ld	s4,48(sp)
 19c:	7aa2                	ld	s5,40(sp)
 19e:	7b02                	ld	s6,32(sp)
 1a0:	6be2                	ld	s7,24(sp)
 1a2:	6125                	addi	sp,sp,96
 1a4:	8082                	ret

00000000000001a6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a6:	1101                	addi	sp,sp,-32
 1a8:	ec06                	sd	ra,24(sp)
 1aa:	e822                	sd	s0,16(sp)
 1ac:	e426                	sd	s1,8(sp)
 1ae:	e04a                	sd	s2,0(sp)
 1b0:	1000                	addi	s0,sp,32
 1b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b4:	4581                	li	a1,0
 1b6:	00000097          	auipc	ra,0x0
 1ba:	170080e7          	jalr	368(ra) # 326 <open>
  if(fd < 0)
 1be:	02054563          	bltz	a0,1e8 <stat+0x42>
 1c2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c4:	85ca                	mv	a1,s2
 1c6:	00000097          	auipc	ra,0x0
 1ca:	178080e7          	jalr	376(ra) # 33e <fstat>
 1ce:	892a                	mv	s2,a0
  close(fd);
 1d0:	8526                	mv	a0,s1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	13c080e7          	jalr	316(ra) # 30e <close>
  return r;
}
 1da:	854a                	mv	a0,s2
 1dc:	60e2                	ld	ra,24(sp)
 1de:	6442                	ld	s0,16(sp)
 1e0:	64a2                	ld	s1,8(sp)
 1e2:	6902                	ld	s2,0(sp)
 1e4:	6105                	addi	sp,sp,32
 1e6:	8082                	ret
    return -1;
 1e8:	597d                	li	s2,-1
 1ea:	bfc5                	j	1da <stat+0x34>

00000000000001ec <atoi>:

int
atoi(const char *s)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f2:	00054683          	lbu	a3,0(a0)
 1f6:	fd06879b          	addiw	a5,a3,-48
 1fa:	0ff7f793          	zext.b	a5,a5
 1fe:	4625                	li	a2,9
 200:	02f66863          	bltu	a2,a5,230 <atoi+0x44>
 204:	872a                	mv	a4,a0
  n = 0;
 206:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 208:	0705                	addi	a4,a4,1
 20a:	0025179b          	slliw	a5,a0,0x2
 20e:	9fa9                	addw	a5,a5,a0
 210:	0017979b          	slliw	a5,a5,0x1
 214:	9fb5                	addw	a5,a5,a3
 216:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21a:	00074683          	lbu	a3,0(a4)
 21e:	fd06879b          	addiw	a5,a3,-48
 222:	0ff7f793          	zext.b	a5,a5
 226:	fef671e3          	bgeu	a2,a5,208 <atoi+0x1c>
  return n;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
  n = 0;
 230:	4501                	li	a0,0
 232:	bfe5                	j	22a <atoi+0x3e>

0000000000000234 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23a:	02b57463          	bgeu	a0,a1,262 <memmove+0x2e>
    while(n-- > 0)
 23e:	00c05f63          	blez	a2,25c <memmove+0x28>
 242:	1602                	slli	a2,a2,0x20
 244:	9201                	srli	a2,a2,0x20
 246:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24a:	872a                	mv	a4,a0
      *dst++ = *src++;
 24c:	0585                	addi	a1,a1,1
 24e:	0705                	addi	a4,a4,1
 250:	fff5c683          	lbu	a3,-1(a1)
 254:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 258:	fee79ae3          	bne	a5,a4,24c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
    dst += n;
 262:	00c50733          	add	a4,a0,a2
    src += n;
 266:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 268:	fec05ae3          	blez	a2,25c <memmove+0x28>
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x46>
 28a:	bfc9                	j	25c <memmove+0x28>

000000000000028c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 292:	ca05                	beqz	a2,2c2 <memcmp+0x36>
 294:	fff6069b          	addiw	a3,a2,-1
 298:	1682                	slli	a3,a3,0x20
 29a:	9281                	srli	a3,a3,0x20
 29c:	0685                	addi	a3,a3,1
 29e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00e79863          	bne	a5,a4,2b8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ac:	0505                	addi	a0,a0,1
    p2++;
 2ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b0:	fed518e3          	bne	a0,a3,2a0 <memcmp+0x14>
  }
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	a019                	j	2bc <memcmp+0x30>
      return *p1 - *p2;
 2b8:	40e7853b          	subw	a0,a5,a4
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  return 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <memcmp+0x30>

00000000000002c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ce:	00000097          	auipc	ra,0x0
 2d2:	f66080e7          	jalr	-154(ra) # 234 <memmove>
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2de:	4885                	li	a7,1
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e6:	4889                	li	a7,2
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ee:	488d                	li	a7,3
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f6:	4891                	li	a7,4
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <read>:
.global read
read:
 li a7, SYS_read
 2fe:	4895                	li	a7,5
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <write>:
.global write
write:
 li a7, SYS_write
 306:	48c1                	li	a7,16
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <close>:
.global close
close:
 li a7, SYS_close
 30e:	48d5                	li	a7,21
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <kill>:
.global kill
kill:
 li a7, SYS_kill
 316:	4899                	li	a7,6
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <exec>:
.global exec
exec:
 li a7, SYS_exec
 31e:	489d                	li	a7,7
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <open>:
.global open
open:
 li a7, SYS_open
 326:	48bd                	li	a7,15
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 32e:	48c5                	li	a7,17
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 336:	48c9                	li	a7,18
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33e:	48a1                	li	a7,8
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <link>:
.global link
link:
 li a7, SYS_link
 346:	48cd                	li	a7,19
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 34e:	48d1                	li	a7,20
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 356:	48a5                	li	a7,9
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <dup>:
.global dup
dup:
 li a7, SYS_dup
 35e:	48a9                	li	a7,10
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 366:	48ad                	li	a7,11
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 36e:	48b1                	li	a7,12
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 376:	48b5                	li	a7,13
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 37e:	48b9                	li	a7,14
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <head>:
.global head
head:
 li a7, SYS_head
 386:	48d9                	li	a7,22
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 38e:	48dd                	li	a7,23
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <ps>:
.global ps
ps:
 li a7, SYS_ps
 396:	48e1                	li	a7,24
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <times>:
.global times
times:
 li a7, SYS_times
 39e:	48e5                	li	a7,25
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 3a6:	48e9                	li	a7,26
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ae:	1101                	addi	sp,sp,-32
 3b0:	ec06                	sd	ra,24(sp)
 3b2:	e822                	sd	s0,16(sp)
 3b4:	1000                	addi	s0,sp,32
 3b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ba:	4605                	li	a2,1
 3bc:	fef40593          	addi	a1,s0,-17
 3c0:	00000097          	auipc	ra,0x0
 3c4:	f46080e7          	jalr	-186(ra) # 306 <write>
}
 3c8:	60e2                	ld	ra,24(sp)
 3ca:	6442                	ld	s0,16(sp)
 3cc:	6105                	addi	sp,sp,32
 3ce:	8082                	ret

00000000000003d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	7139                	addi	sp,sp,-64
 3d2:	fc06                	sd	ra,56(sp)
 3d4:	f822                	sd	s0,48(sp)
 3d6:	f426                	sd	s1,40(sp)
 3d8:	f04a                	sd	s2,32(sp)
 3da:	ec4e                	sd	s3,24(sp)
 3dc:	0080                	addi	s0,sp,64
 3de:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e0:	c299                	beqz	a3,3e6 <printint+0x16>
 3e2:	0805c963          	bltz	a1,474 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e6:	2581                	sext.w	a1,a1
  neg = 0;
 3e8:	4881                	li	a7,0
 3ea:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3ee:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f0:	2601                	sext.w	a2,a2
 3f2:	00001517          	auipc	a0,0x1
 3f6:	95e50513          	addi	a0,a0,-1698 # d50 <digits>
 3fa:	883a                	mv	a6,a4
 3fc:	2705                	addiw	a4,a4,1
 3fe:	02c5f7bb          	remuw	a5,a1,a2
 402:	1782                	slli	a5,a5,0x20
 404:	9381                	srli	a5,a5,0x20
 406:	97aa                	add	a5,a5,a0
 408:	0007c783          	lbu	a5,0(a5)
 40c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 410:	0005879b          	sext.w	a5,a1
 414:	02c5d5bb          	divuw	a1,a1,a2
 418:	0685                	addi	a3,a3,1
 41a:	fec7f0e3          	bgeu	a5,a2,3fa <printint+0x2a>
  if(neg)
 41e:	00088c63          	beqz	a7,436 <printint+0x66>
    buf[i++] = '-';
 422:	fd070793          	addi	a5,a4,-48
 426:	00878733          	add	a4,a5,s0
 42a:	02d00793          	li	a5,45
 42e:	fef70823          	sb	a5,-16(a4)
 432:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 436:	02e05863          	blez	a4,466 <printint+0x96>
 43a:	fc040793          	addi	a5,s0,-64
 43e:	00e78933          	add	s2,a5,a4
 442:	fff78993          	addi	s3,a5,-1
 446:	99ba                	add	s3,s3,a4
 448:	377d                	addiw	a4,a4,-1
 44a:	1702                	slli	a4,a4,0x20
 44c:	9301                	srli	a4,a4,0x20
 44e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 452:	fff94583          	lbu	a1,-1(s2)
 456:	8526                	mv	a0,s1
 458:	00000097          	auipc	ra,0x0
 45c:	f56080e7          	jalr	-170(ra) # 3ae <putc>
  while(--i >= 0)
 460:	197d                	addi	s2,s2,-1
 462:	ff3918e3          	bne	s2,s3,452 <printint+0x82>
}
 466:	70e2                	ld	ra,56(sp)
 468:	7442                	ld	s0,48(sp)
 46a:	74a2                	ld	s1,40(sp)
 46c:	7902                	ld	s2,32(sp)
 46e:	69e2                	ld	s3,24(sp)
 470:	6121                	addi	sp,sp,64
 472:	8082                	ret
    x = -xx;
 474:	40b005bb          	negw	a1,a1
    neg = 1;
 478:	4885                	li	a7,1
    x = -xx;
 47a:	bf85                	j	3ea <printint+0x1a>

000000000000047c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47c:	7119                	addi	sp,sp,-128
 47e:	fc86                	sd	ra,120(sp)
 480:	f8a2                	sd	s0,112(sp)
 482:	f4a6                	sd	s1,104(sp)
 484:	f0ca                	sd	s2,96(sp)
 486:	ecce                	sd	s3,88(sp)
 488:	e8d2                	sd	s4,80(sp)
 48a:	e4d6                	sd	s5,72(sp)
 48c:	e0da                	sd	s6,64(sp)
 48e:	fc5e                	sd	s7,56(sp)
 490:	f862                	sd	s8,48(sp)
 492:	f466                	sd	s9,40(sp)
 494:	f06a                	sd	s10,32(sp)
 496:	ec6e                	sd	s11,24(sp)
 498:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 49a:	0005c903          	lbu	s2,0(a1)
 49e:	18090f63          	beqz	s2,63c <vprintf+0x1c0>
 4a2:	8aaa                	mv	s5,a0
 4a4:	8b32                	mv	s6,a2
 4a6:	00158493          	addi	s1,a1,1
  state = 0;
 4aa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ac:	02500a13          	li	s4,37
 4b0:	4c55                	li	s8,21
 4b2:	00001c97          	auipc	s9,0x1
 4b6:	846c8c93          	addi	s9,s9,-1978 # cf8 <get_time_perf+0x8e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4ba:	02800d93          	li	s11,40
  putc(fd, 'x');
 4be:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4c0:	00001b97          	auipc	s7,0x1
 4c4:	890b8b93          	addi	s7,s7,-1904 # d50 <digits>
 4c8:	a839                	j	4e6 <vprintf+0x6a>
        putc(fd, c);
 4ca:	85ca                	mv	a1,s2
 4cc:	8556                	mv	a0,s5
 4ce:	00000097          	auipc	ra,0x0
 4d2:	ee0080e7          	jalr	-288(ra) # 3ae <putc>
 4d6:	a019                	j	4dc <vprintf+0x60>
    } else if(state == '%'){
 4d8:	01498d63          	beq	s3,s4,4f2 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4dc:	0485                	addi	s1,s1,1
 4de:	fff4c903          	lbu	s2,-1(s1)
 4e2:	14090d63          	beqz	s2,63c <vprintf+0x1c0>
    if(state == 0){
 4e6:	fe0999e3          	bnez	s3,4d8 <vprintf+0x5c>
      if(c == '%'){
 4ea:	ff4910e3          	bne	s2,s4,4ca <vprintf+0x4e>
        state = '%';
 4ee:	89d2                	mv	s3,s4
 4f0:	b7f5                	j	4dc <vprintf+0x60>
      if(c == 'd'){
 4f2:	11490c63          	beq	s2,s4,60a <vprintf+0x18e>
 4f6:	f9d9079b          	addiw	a5,s2,-99
 4fa:	0ff7f793          	zext.b	a5,a5
 4fe:	10fc6e63          	bltu	s8,a5,61a <vprintf+0x19e>
 502:	f9d9079b          	addiw	a5,s2,-99
 506:	0ff7f713          	zext.b	a4,a5
 50a:	10ec6863          	bltu	s8,a4,61a <vprintf+0x19e>
 50e:	00271793          	slli	a5,a4,0x2
 512:	97e6                	add	a5,a5,s9
 514:	439c                	lw	a5,0(a5)
 516:	97e6                	add	a5,a5,s9
 518:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 51a:	008b0913          	addi	s2,s6,8
 51e:	4685                	li	a3,1
 520:	4629                	li	a2,10
 522:	000b2583          	lw	a1,0(s6)
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	ea8080e7          	jalr	-344(ra) # 3d0 <printint>
 530:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 532:	4981                	li	s3,0
 534:	b765                	j	4dc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 536:	008b0913          	addi	s2,s6,8
 53a:	4681                	li	a3,0
 53c:	4629                	li	a2,10
 53e:	000b2583          	lw	a1,0(s6)
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e8c080e7          	jalr	-372(ra) # 3d0 <printint>
 54c:	8b4a                	mv	s6,s2
      state = 0;
 54e:	4981                	li	s3,0
 550:	b771                	j	4dc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 552:	008b0913          	addi	s2,s6,8
 556:	4681                	li	a3,0
 558:	866a                	mv	a2,s10
 55a:	000b2583          	lw	a1,0(s6)
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	e70080e7          	jalr	-400(ra) # 3d0 <printint>
 568:	8b4a                	mv	s6,s2
      state = 0;
 56a:	4981                	li	s3,0
 56c:	bf85                	j	4dc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 56e:	008b0793          	addi	a5,s6,8
 572:	f8f43423          	sd	a5,-120(s0)
 576:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 57a:	03000593          	li	a1,48
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	e2e080e7          	jalr	-466(ra) # 3ae <putc>
  putc(fd, 'x');
 588:	07800593          	li	a1,120
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	e20080e7          	jalr	-480(ra) # 3ae <putc>
 596:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 598:	03c9d793          	srli	a5,s3,0x3c
 59c:	97de                	add	a5,a5,s7
 59e:	0007c583          	lbu	a1,0(a5)
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	e0a080e7          	jalr	-502(ra) # 3ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ac:	0992                	slli	s3,s3,0x4
 5ae:	397d                	addiw	s2,s2,-1
 5b0:	fe0914e3          	bnez	s2,598 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5b4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b70d                	j	4dc <vprintf+0x60>
        s = va_arg(ap, char*);
 5bc:	008b0913          	addi	s2,s6,8
 5c0:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5c4:	02098163          	beqz	s3,5e6 <vprintf+0x16a>
        while(*s != 0){
 5c8:	0009c583          	lbu	a1,0(s3)
 5cc:	c5ad                	beqz	a1,636 <vprintf+0x1ba>
          putc(fd, *s);
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	dde080e7          	jalr	-546(ra) # 3ae <putc>
          s++;
 5d8:	0985                	addi	s3,s3,1
        while(*s != 0){
 5da:	0009c583          	lbu	a1,0(s3)
 5de:	f9e5                	bnez	a1,5ce <vprintf+0x152>
        s = va_arg(ap, char*);
 5e0:	8b4a                	mv	s6,s2
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	bde5                	j	4dc <vprintf+0x60>
          s = "(null)";
 5e6:	00000997          	auipc	s3,0x0
 5ea:	70a98993          	addi	s3,s3,1802 # cf0 <get_time_perf+0x86>
        while(*s != 0){
 5ee:	85ee                	mv	a1,s11
 5f0:	bff9                	j	5ce <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5f2:	008b0913          	addi	s2,s6,8
 5f6:	000b4583          	lbu	a1,0(s6)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	db2080e7          	jalr	-590(ra) # 3ae <putc>
 604:	8b4a                	mv	s6,s2
      state = 0;
 606:	4981                	li	s3,0
 608:	bdd1                	j	4dc <vprintf+0x60>
        putc(fd, c);
 60a:	85d2                	mv	a1,s4
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	da0080e7          	jalr	-608(ra) # 3ae <putc>
      state = 0;
 616:	4981                	li	s3,0
 618:	b5d1                	j	4dc <vprintf+0x60>
        putc(fd, '%');
 61a:	85d2                	mv	a1,s4
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	d90080e7          	jalr	-624(ra) # 3ae <putc>
        putc(fd, c);
 626:	85ca                	mv	a1,s2
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	d84080e7          	jalr	-636(ra) # 3ae <putc>
      state = 0;
 632:	4981                	li	s3,0
 634:	b565                	j	4dc <vprintf+0x60>
        s = va_arg(ap, char*);
 636:	8b4a                	mv	s6,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	b54d                	j	4dc <vprintf+0x60>
    }
  }
}
 63c:	70e6                	ld	ra,120(sp)
 63e:	7446                	ld	s0,112(sp)
 640:	74a6                	ld	s1,104(sp)
 642:	7906                	ld	s2,96(sp)
 644:	69e6                	ld	s3,88(sp)
 646:	6a46                	ld	s4,80(sp)
 648:	6aa6                	ld	s5,72(sp)
 64a:	6b06                	ld	s6,64(sp)
 64c:	7be2                	ld	s7,56(sp)
 64e:	7c42                	ld	s8,48(sp)
 650:	7ca2                	ld	s9,40(sp)
 652:	7d02                	ld	s10,32(sp)
 654:	6de2                	ld	s11,24(sp)
 656:	6109                	addi	sp,sp,128
 658:	8082                	ret

000000000000065a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 65a:	715d                	addi	sp,sp,-80
 65c:	ec06                	sd	ra,24(sp)
 65e:	e822                	sd	s0,16(sp)
 660:	1000                	addi	s0,sp,32
 662:	e010                	sd	a2,0(s0)
 664:	e414                	sd	a3,8(s0)
 666:	e818                	sd	a4,16(s0)
 668:	ec1c                	sd	a5,24(s0)
 66a:	03043023          	sd	a6,32(s0)
 66e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 672:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 676:	8622                	mv	a2,s0
 678:	00000097          	auipc	ra,0x0
 67c:	e04080e7          	jalr	-508(ra) # 47c <vprintf>
}
 680:	60e2                	ld	ra,24(sp)
 682:	6442                	ld	s0,16(sp)
 684:	6161                	addi	sp,sp,80
 686:	8082                	ret

0000000000000688 <printf>:

void
printf(const char *fmt, ...)
{
 688:	711d                	addi	sp,sp,-96
 68a:	ec06                	sd	ra,24(sp)
 68c:	e822                	sd	s0,16(sp)
 68e:	1000                	addi	s0,sp,32
 690:	e40c                	sd	a1,8(s0)
 692:	e810                	sd	a2,16(s0)
 694:	ec14                	sd	a3,24(s0)
 696:	f018                	sd	a4,32(s0)
 698:	f41c                	sd	a5,40(s0)
 69a:	03043823          	sd	a6,48(s0)
 69e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a2:	00840613          	addi	a2,s0,8
 6a6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6aa:	85aa                	mv	a1,a0
 6ac:	4505                	li	a0,1
 6ae:	00000097          	auipc	ra,0x0
 6b2:	dce080e7          	jalr	-562(ra) # 47c <vprintf>
}
 6b6:	60e2                	ld	ra,24(sp)
 6b8:	6442                	ld	s0,16(sp)
 6ba:	6125                	addi	sp,sp,96
 6bc:	8082                	ret

00000000000006be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6be:	1141                	addi	sp,sp,-16
 6c0:	e422                	sd	s0,8(sp)
 6c2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c8:	00001797          	auipc	a5,0x1
 6cc:	9387b783          	ld	a5,-1736(a5) # 1000 <freep>
 6d0:	a02d                	j	6fa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d2:	4618                	lw	a4,8(a2)
 6d4:	9f2d                	addw	a4,a4,a1
 6d6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6da:	6398                	ld	a4,0(a5)
 6dc:	6310                	ld	a2,0(a4)
 6de:	a83d                	j	71c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6e0:	ff852703          	lw	a4,-8(a0)
 6e4:	9f31                	addw	a4,a4,a2
 6e6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6e8:	ff053683          	ld	a3,-16(a0)
 6ec:	a091                	j	730 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ee:	6398                	ld	a4,0(a5)
 6f0:	00e7e463          	bltu	a5,a4,6f8 <free+0x3a>
 6f4:	00e6ea63          	bltu	a3,a4,708 <free+0x4a>
{
 6f8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fa:	fed7fae3          	bgeu	a5,a3,6ee <free+0x30>
 6fe:	6398                	ld	a4,0(a5)
 700:	00e6e463          	bltu	a3,a4,708 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 704:	fee7eae3          	bltu	a5,a4,6f8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 708:	ff852583          	lw	a1,-8(a0)
 70c:	6390                	ld	a2,0(a5)
 70e:	02059813          	slli	a6,a1,0x20
 712:	01c85713          	srli	a4,a6,0x1c
 716:	9736                	add	a4,a4,a3
 718:	fae60de3          	beq	a2,a4,6d2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 71c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 720:	4790                	lw	a2,8(a5)
 722:	02061593          	slli	a1,a2,0x20
 726:	01c5d713          	srli	a4,a1,0x1c
 72a:	973e                	add	a4,a4,a5
 72c:	fae68ae3          	beq	a3,a4,6e0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 730:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 732:	00001717          	auipc	a4,0x1
 736:	8cf73723          	sd	a5,-1842(a4) # 1000 <freep>
}
 73a:	6422                	ld	s0,8(sp)
 73c:	0141                	addi	sp,sp,16
 73e:	8082                	ret

0000000000000740 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 740:	7139                	addi	sp,sp,-64
 742:	fc06                	sd	ra,56(sp)
 744:	f822                	sd	s0,48(sp)
 746:	f426                	sd	s1,40(sp)
 748:	f04a                	sd	s2,32(sp)
 74a:	ec4e                	sd	s3,24(sp)
 74c:	e852                	sd	s4,16(sp)
 74e:	e456                	sd	s5,8(sp)
 750:	e05a                	sd	s6,0(sp)
 752:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 754:	02051493          	slli	s1,a0,0x20
 758:	9081                	srli	s1,s1,0x20
 75a:	04bd                	addi	s1,s1,15
 75c:	8091                	srli	s1,s1,0x4
 75e:	0014899b          	addiw	s3,s1,1
 762:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 764:	00001517          	auipc	a0,0x1
 768:	89c53503          	ld	a0,-1892(a0) # 1000 <freep>
 76c:	c515                	beqz	a0,798 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 770:	4798                	lw	a4,8(a5)
 772:	02977f63          	bgeu	a4,s1,7b0 <malloc+0x70>
 776:	8a4e                	mv	s4,s3
 778:	0009871b          	sext.w	a4,s3
 77c:	6685                	lui	a3,0x1
 77e:	00d77363          	bgeu	a4,a3,784 <malloc+0x44>
 782:	6a05                	lui	s4,0x1
 784:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 788:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 78c:	00001917          	auipc	s2,0x1
 790:	87490913          	addi	s2,s2,-1932 # 1000 <freep>
  if(p == (char*)-1)
 794:	5afd                	li	s5,-1
 796:	a895                	j	80a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 798:	00001797          	auipc	a5,0x1
 79c:	87878793          	addi	a5,a5,-1928 # 1010 <base>
 7a0:	00001717          	auipc	a4,0x1
 7a4:	86f73023          	sd	a5,-1952(a4) # 1000 <freep>
 7a8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7aa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ae:	b7e1                	j	776 <malloc+0x36>
      if(p->s.size == nunits)
 7b0:	02e48c63          	beq	s1,a4,7e8 <malloc+0xa8>
        p->s.size -= nunits;
 7b4:	4137073b          	subw	a4,a4,s3
 7b8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7ba:	02071693          	slli	a3,a4,0x20
 7be:	01c6d713          	srli	a4,a3,0x1c
 7c2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7c4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7c8:	00001717          	auipc	a4,0x1
 7cc:	82a73c23          	sd	a0,-1992(a4) # 1000 <freep>
      return (void*)(p + 1);
 7d0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7d4:	70e2                	ld	ra,56(sp)
 7d6:	7442                	ld	s0,48(sp)
 7d8:	74a2                	ld	s1,40(sp)
 7da:	7902                	ld	s2,32(sp)
 7dc:	69e2                	ld	s3,24(sp)
 7de:	6a42                	ld	s4,16(sp)
 7e0:	6aa2                	ld	s5,8(sp)
 7e2:	6b02                	ld	s6,0(sp)
 7e4:	6121                	addi	sp,sp,64
 7e6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7e8:	6398                	ld	a4,0(a5)
 7ea:	e118                	sd	a4,0(a0)
 7ec:	bff1                	j	7c8 <malloc+0x88>
  hp->s.size = nu;
 7ee:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f2:	0541                	addi	a0,a0,16
 7f4:	00000097          	auipc	ra,0x0
 7f8:	eca080e7          	jalr	-310(ra) # 6be <free>
  return freep;
 7fc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 800:	d971                	beqz	a0,7d4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 802:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 804:	4798                	lw	a4,8(a5)
 806:	fa9775e3          	bgeu	a4,s1,7b0 <malloc+0x70>
    if(p == freep)
 80a:	00093703          	ld	a4,0(s2)
 80e:	853e                	mv	a0,a5
 810:	fef719e3          	bne	a4,a5,802 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 814:	8552                	mv	a0,s4
 816:	00000097          	auipc	ra,0x0
 81a:	b58080e7          	jalr	-1192(ra) # 36e <sbrk>
  if(p == (char*)-1)
 81e:	fd5518e3          	bne	a0,s5,7ee <malloc+0xae>
        return 0;
 822:	4501                	li	a0,0
 824:	bf45                	j	7d4 <malloc+0x94>

0000000000000826 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 826:	c1d9                	beqz	a1,8ac <head_run+0x86>
void head_run(int fd, int numOfLines){
 828:	dd010113          	addi	sp,sp,-560
 82c:	22113423          	sd	ra,552(sp)
 830:	22813023          	sd	s0,544(sp)
 834:	20913c23          	sd	s1,536(sp)
 838:	21213823          	sd	s2,528(sp)
 83c:	21313423          	sd	s3,520(sp)
 840:	21413023          	sd	s4,512(sp)
 844:	1c00                	addi	s0,sp,560
 846:	892a                	mv	s2,a0
 848:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 84c:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 84e:	00000a17          	auipc	s4,0x0
 852:	542a0a13          	addi	s4,s4,1346 # d90 <digits+0x40>
		readStatus = read_line(fd, line);
 856:	dd840593          	addi	a1,s0,-552
 85a:	854a                	mv	a0,s2
 85c:	00000097          	auipc	ra,0x0
 860:	394080e7          	jalr	916(ra) # bf0 <read_line>
		if (readStatus == READ_ERROR){
 864:	01350d63          	beq	a0,s3,87e <head_run+0x58>
		if (readStatus == READ_EOF)
 868:	c11d                	beqz	a0,88e <head_run+0x68>
		printf("%s",line);
 86a:	dd840593          	addi	a1,s0,-552
 86e:	8552                	mv	a0,s4
 870:	00000097          	auipc	ra,0x0
 874:	e18080e7          	jalr	-488(ra) # 688 <printf>
	while(numOfLines--){
 878:	34fd                	addiw	s1,s1,-1
 87a:	fcf1                	bnez	s1,856 <head_run+0x30>
 87c:	a809                	j	88e <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 87e:	00000517          	auipc	a0,0x0
 882:	4ea50513          	addi	a0,a0,1258 # d68 <digits+0x18>
 886:	00000097          	auipc	ra,0x0
 88a:	e02080e7          	jalr	-510(ra) # 688 <printf>

	}
}
 88e:	22813083          	ld	ra,552(sp)
 892:	22013403          	ld	s0,544(sp)
 896:	21813483          	ld	s1,536(sp)
 89a:	21013903          	ld	s2,528(sp)
 89e:	20813983          	ld	s3,520(sp)
 8a2:	20013a03          	ld	s4,512(sp)
 8a6:	23010113          	addi	sp,sp,560
 8aa:	8082                	ret
 8ac:	8082                	ret

00000000000008ae <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 8ae:	ba010113          	addi	sp,sp,-1120
 8b2:	44113c23          	sd	ra,1112(sp)
 8b6:	44813823          	sd	s0,1104(sp)
 8ba:	44913423          	sd	s1,1096(sp)
 8be:	45213023          	sd	s2,1088(sp)
 8c2:	43313c23          	sd	s3,1080(sp)
 8c6:	43413823          	sd	s4,1072(sp)
 8ca:	43513423          	sd	s5,1064(sp)
 8ce:	43613023          	sd	s6,1056(sp)
 8d2:	41713c23          	sd	s7,1048(sp)
 8d6:	41813823          	sd	s8,1040(sp)
 8da:	41913423          	sd	s9,1032(sp)
 8de:	41a13023          	sd	s10,1024(sp)
 8e2:	3fb13c23          	sd	s11,1016(sp)
 8e6:	46010413          	addi	s0,sp,1120
 8ea:	89aa                	mv	s3,a0
 8ec:	8aae                	mv	s5,a1
 8ee:	8c32                	mv	s8,a2
 8f0:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 8f2:	d9840593          	addi	a1,s0,-616
 8f6:	00000097          	auipc	ra,0x0
 8fa:	2fa080e7          	jalr	762(ra) # bf0 <read_line>


  if (readStatus == READ_ERROR)
 8fe:	57fd                	li	a5,-1
 900:	04f50163          	beq	a0,a5,942 <uniq_run+0x94>
 904:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 906:	ed21                	bnez	a0,95e <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 908:	45813083          	ld	ra,1112(sp)
 90c:	45013403          	ld	s0,1104(sp)
 910:	44813483          	ld	s1,1096(sp)
 914:	44013903          	ld	s2,1088(sp)
 918:	43813983          	ld	s3,1080(sp)
 91c:	43013a03          	ld	s4,1072(sp)
 920:	42813a83          	ld	s5,1064(sp)
 924:	42013b03          	ld	s6,1056(sp)
 928:	41813b83          	ld	s7,1048(sp)
 92c:	41013c03          	ld	s8,1040(sp)
 930:	40813c83          	ld	s9,1032(sp)
 934:	40013d03          	ld	s10,1024(sp)
 938:	3f813d83          	ld	s11,1016(sp)
 93c:	46010113          	addi	sp,sp,1120
 940:	8082                	ret
    printf("[ERR] Error reading from the file ");
 942:	00000517          	auipc	a0,0x0
 946:	45650513          	addi	a0,a0,1110 # d98 <digits+0x48>
 94a:	00000097          	auipc	ra,0x0
 94e:	d3e080e7          	jalr	-706(ra) # 688 <printf>
 952:	bf5d                	j	908 <uniq_run+0x5a>
 954:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 956:	8926                	mv	s2,s1
 958:	84be                	mv	s1,a5
        lineCount = 1;
 95a:	8b6a                	mv	s6,s10
 95c:	a8ed                	j	a56 <uniq_run+0x1a8>
    int lineCount=1;
 95e:	4b05                	li	s6,1
  char * line2 = buffer2;
 960:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 964:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 968:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 96a:	4d05                	li	s10,1
              printf("%s",line1);
 96c:	00000d97          	auipc	s11,0x0
 970:	424d8d93          	addi	s11,s11,1060 # d90 <digits+0x40>
 974:	a0cd                	j	a56 <uniq_run+0x1a8>
            if (repeatedLines){
 976:	020a0b63          	beqz	s4,9ac <uniq_run+0xfe>
                if (isRepeated){
 97a:	f80b87e3          	beqz	s7,908 <uniq_run+0x5a>
                    if (showCount)
 97e:	000c0d63          	beqz	s8,998 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 982:	864a                	mv	a2,s2
 984:	85da                	mv	a1,s6
 986:	00000517          	auipc	a0,0x0
 98a:	43a50513          	addi	a0,a0,1082 # dc0 <digits+0x70>
 98e:	00000097          	auipc	ra,0x0
 992:	cfa080e7          	jalr	-774(ra) # 688 <printf>
 996:	bf8d                	j	908 <uniq_run+0x5a>
                      printf("%s",line1);
 998:	85ca                	mv	a1,s2
 99a:	00000517          	auipc	a0,0x0
 99e:	3f650513          	addi	a0,a0,1014 # d90 <digits+0x40>
 9a2:	00000097          	auipc	ra,0x0
 9a6:	ce6080e7          	jalr	-794(ra) # 688 <printf>
 9aa:	bfb9                	j	908 <uniq_run+0x5a>
                if (showCount)
 9ac:	000c0d63          	beqz	s8,9c6 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 9b0:	864a                	mv	a2,s2
 9b2:	85da                	mv	a1,s6
 9b4:	00000517          	auipc	a0,0x0
 9b8:	40c50513          	addi	a0,a0,1036 # dc0 <digits+0x70>
 9bc:	00000097          	auipc	ra,0x0
 9c0:	ccc080e7          	jalr	-820(ra) # 688 <printf>
 9c4:	b791                	j	908 <uniq_run+0x5a>
                  printf("%s",line1);
 9c6:	85ca                	mv	a1,s2
 9c8:	00000517          	auipc	a0,0x0
 9cc:	3c850513          	addi	a0,a0,968 # d90 <digits+0x40>
 9d0:	00000097          	auipc	ra,0x0
 9d4:	cb8080e7          	jalr	-840(ra) # 688 <printf>
 9d8:	bf05                	j	908 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 9da:	00000517          	auipc	a0,0x0
 9de:	3ee50513          	addi	a0,a0,1006 # dc8 <digits+0x78>
 9e2:	00000097          	auipc	ra,0x0
 9e6:	ca6080e7          	jalr	-858(ra) # 688 <printf>
          break;
 9ea:	bf39                	j	908 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 9ec:	85a6                	mv	a1,s1
 9ee:	854a                	mv	a0,s2
 9f0:	00000097          	auipc	ra,0x0
 9f4:	110080e7          	jalr	272(ra) # b00 <compare_str_ic>
 9f8:	a041                	j	a78 <uniq_run+0x1ca>
                  printf("%s",line1);
 9fa:	85ca                	mv	a1,s2
 9fc:	856e                	mv	a0,s11
 9fe:	00000097          	auipc	ra,0x0
 a02:	c8a080e7          	jalr	-886(ra) # 688 <printf>
        lineCount = 1;
 a06:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 a08:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a0a:	8926                	mv	s2,s1
                  printf("%s",line1);
 a0c:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a0e:	4b81                	li	s7,0
 a10:	a099                	j	a56 <uniq_run+0x1a8>
            if (showCount)
 a12:	020c0263          	beqz	s8,a36 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 a16:	864a                	mv	a2,s2
 a18:	85da                	mv	a1,s6
 a1a:	00000517          	auipc	a0,0x0
 a1e:	3a650513          	addi	a0,a0,934 # dc0 <digits+0x70>
 a22:	00000097          	auipc	ra,0x0
 a26:	c66080e7          	jalr	-922(ra) # 688 <printf>
 a2a:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a2c:	8926                	mv	s2,s1
 a2e:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a30:	4b81                	li	s7,0
        lineCount = 1;
 a32:	8b6a                	mv	s6,s10
 a34:	a00d                	j	a56 <uniq_run+0x1a8>
              printf("%s",line1);
 a36:	85ca                	mv	a1,s2
 a38:	856e                	mv	a0,s11
 a3a:	00000097          	auipc	ra,0x0
 a3e:	c4e080e7          	jalr	-946(ra) # 688 <printf>
 a42:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a44:	8926                	mv	s2,s1
              printf("%s",line1);
 a46:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a48:	4b81                	li	s7,0
        lineCount = 1;
 a4a:	8b6a                	mv	s6,s10
 a4c:	a029                	j	a56 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 a4e:	000a0363          	beqz	s4,a54 <uniq_run+0x1a6>
 a52:	8bea                	mv	s7,s10
          lineCount++;
 a54:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 a56:	85a6                	mv	a1,s1
 a58:	854e                	mv	a0,s3
 a5a:	00000097          	auipc	ra,0x0
 a5e:	196080e7          	jalr	406(ra) # bf0 <read_line>
        if (readStatus == READ_EOF){
 a62:	d911                	beqz	a0,976 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 a64:	f7950be3          	beq	a0,s9,9da <uniq_run+0x12c>
        if (!ignoreCase)
 a68:	f80a92e3          	bnez	s5,9ec <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 a6c:	85a6                	mv	a1,s1
 a6e:	854a                	mv	a0,s2
 a70:	00000097          	auipc	ra,0x0
 a74:	062080e7          	jalr	98(ra) # ad2 <compare_str>
        if (compareStatus != 0){ 
 a78:	d979                	beqz	a0,a4e <uniq_run+0x1a0>
          if (repeatedLines){
 a7a:	f80a0ce3          	beqz	s4,a12 <uniq_run+0x164>
            if (isRepeated){
 a7e:	ec0b8be3          	beqz	s7,954 <uniq_run+0xa6>
                if (showCount)
 a82:	f60c0ce3          	beqz	s8,9fa <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 a86:	864a                	mv	a2,s2
 a88:	85da                	mv	a1,s6
 a8a:	00000517          	auipc	a0,0x0
 a8e:	33650513          	addi	a0,a0,822 # dc0 <digits+0x70>
 a92:	00000097          	auipc	ra,0x0
 a96:	bf6080e7          	jalr	-1034(ra) # 688 <printf>
        lineCount = 1;
 a9a:	8b5e                	mv	s6,s7
 a9c:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a9e:	8926                	mv	s2,s1
 aa0:	84be                	mv	s1,a5
        isRepeated = 0 ;
 aa2:	4b81                	li	s7,0
 aa4:	bf4d                	j	a56 <uniq_run+0x1a8>

0000000000000aa6 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 aa6:	1141                	addi	sp,sp,-16
 aa8:	e422                	sd	s0,8(sp)
 aaa:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 aac:	00054783          	lbu	a5,0(a0)
 ab0:	cf99                	beqz	a5,ace <get_strlen+0x28>
 ab2:	00150713          	addi	a4,a0,1
 ab6:	87ba                	mv	a5,a4
 ab8:	4685                	li	a3,1
 aba:	9e99                	subw	a3,a3,a4
 abc:	00f6853b          	addw	a0,a3,a5
 ac0:	0785                	addi	a5,a5,1
 ac2:	fff7c703          	lbu	a4,-1(a5)
 ac6:	fb7d                	bnez	a4,abc <get_strlen+0x16>
	return len;
}
 ac8:	6422                	ld	s0,8(sp)
 aca:	0141                	addi	sp,sp,16
 acc:	8082                	ret
	int len = 0;
 ace:	4501                	li	a0,0
 ad0:	bfe5                	j	ac8 <get_strlen+0x22>

0000000000000ad2 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 ad2:	1141                	addi	sp,sp,-16
 ad4:	e422                	sd	s0,8(sp)
 ad6:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 ad8:	00054783          	lbu	a5,0(a0)
 adc:	cb91                	beqz	a5,af0 <compare_str+0x1e>
 ade:	0005c703          	lbu	a4,0(a1)
 ae2:	c719                	beqz	a4,af0 <compare_str+0x1e>
		if (*s1++ != *s2++)
 ae4:	0505                	addi	a0,a0,1
 ae6:	0585                	addi	a1,a1,1
 ae8:	fee788e3          	beq	a5,a4,ad8 <compare_str+0x6>
			return 1;
 aec:	4505                	li	a0,1
 aee:	a031                	j	afa <compare_str+0x28>
	}
	if (*s1 == *s2)
 af0:	0005c503          	lbu	a0,0(a1)
 af4:	8d1d                	sub	a0,a0,a5
			return 1;
 af6:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 afa:	6422                	ld	s0,8(sp)
 afc:	0141                	addi	sp,sp,16
 afe:	8082                	ret

0000000000000b00 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 b00:	1141                	addi	sp,sp,-16
 b02:	e422                	sd	s0,8(sp)
 b04:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b06:	4665                	li	a2,25
	while(*s1 && *s2){
 b08:	a019                	j	b0e <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b0a:	04e79763          	bne	a5,a4,b58 <compare_str_ic+0x58>
	while(*s1 && *s2){
 b0e:	00054783          	lbu	a5,0(a0)
 b12:	cb9d                	beqz	a5,b48 <compare_str_ic+0x48>
 b14:	0005c703          	lbu	a4,0(a1)
 b18:	cb05                	beqz	a4,b48 <compare_str_ic+0x48>
		char b1 = *s1++;
 b1a:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 b1c:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b1e:	fbf7869b          	addiw	a3,a5,-65
 b22:	0ff6f693          	zext.b	a3,a3
 b26:	00d66663          	bltu	a2,a3,b32 <compare_str_ic+0x32>
			b1 += 32;
 b2a:	0207879b          	addiw	a5,a5,32
 b2e:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 b32:	fbf7069b          	addiw	a3,a4,-65
 b36:	0ff6f693          	zext.b	a3,a3
 b3a:	fcd668e3          	bltu	a2,a3,b0a <compare_str_ic+0xa>
			b2 += 32;
 b3e:	0207071b          	addiw	a4,a4,32
 b42:	0ff77713          	zext.b	a4,a4
 b46:	b7d1                	j	b0a <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 b48:	0005c503          	lbu	a0,0(a1)
 b4c:	8d1d                	sub	a0,a0,a5
			return 1;
 b4e:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b52:	6422                	ld	s0,8(sp)
 b54:	0141                	addi	sp,sp,16
 b56:	8082                	ret
			return 1;
 b58:	4505                	li	a0,1
 b5a:	bfe5                	j	b52 <compare_str_ic+0x52>

0000000000000b5c <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 b5c:	7179                	addi	sp,sp,-48
 b5e:	f406                	sd	ra,40(sp)
 b60:	f022                	sd	s0,32(sp)
 b62:	ec26                	sd	s1,24(sp)
 b64:	e84a                	sd	s2,16(sp)
 b66:	e44e                	sd	s3,8(sp)
 b68:	1800                	addi	s0,sp,48
 b6a:	89aa                	mv	s3,a0
 b6c:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 b6e:	00000097          	auipc	ra,0x0
 b72:	f38080e7          	jalr	-200(ra) # aa6 <get_strlen>
 b76:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 b78:	854a                	mv	a0,s2
 b7a:	00000097          	auipc	ra,0x0
 b7e:	f2c080e7          	jalr	-212(ra) # aa6 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 b82:	409505bb          	subw	a1,a0,s1
 b86:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 b88:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 b8a:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 b8c:	0005da63          	bgez	a1,ba0 <check_substr+0x44>
 b90:	a81d                	j	bc6 <check_substr+0x6a>
        if (j == M)
 b92:	02f48a63          	beq	s1,a5,bc6 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 b96:	0885                	addi	a7,a7,1
 b98:	0008879b          	sext.w	a5,a7
 b9c:	02f5cc63          	blt	a1,a5,bd4 <check_substr+0x78>
 ba0:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 ba4:	011906b3          	add	a3,s2,a7
 ba8:	874e                	mv	a4,s3
 baa:	879a                	mv	a5,t1
 bac:	fe9053e3          	blez	s1,b92 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 bb0:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 bb4:	00074603          	lbu	a2,0(a4)
 bb8:	fcc81de3          	bne	a6,a2,b92 <check_substr+0x36>
        for (j = 0; j < M; j++)
 bbc:	2785                	addiw	a5,a5,1
 bbe:	0685                	addi	a3,a3,1
 bc0:	0705                	addi	a4,a4,1
 bc2:	fef497e3          	bne	s1,a5,bb0 <check_substr+0x54>
}
 bc6:	70a2                	ld	ra,40(sp)
 bc8:	7402                	ld	s0,32(sp)
 bca:	64e2                	ld	s1,24(sp)
 bcc:	6942                	ld	s2,16(sp)
 bce:	69a2                	ld	s3,8(sp)
 bd0:	6145                	addi	sp,sp,48
 bd2:	8082                	ret
    return -1;
 bd4:	557d                	li	a0,-1
 bd6:	bfc5                	j	bc6 <check_substr+0x6a>

0000000000000bd8 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 bd8:	1141                	addi	sp,sp,-16
 bda:	e406                	sd	ra,8(sp)
 bdc:	e022                	sd	s0,0(sp)
 bde:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 be0:	fffff097          	auipc	ra,0xfffff
 be4:	746080e7          	jalr	1862(ra) # 326 <open>
	return fd;
}
 be8:	60a2                	ld	ra,8(sp)
 bea:	6402                	ld	s0,0(sp)
 bec:	0141                	addi	sp,sp,16
 bee:	8082                	ret

0000000000000bf0 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 bf0:	7139                	addi	sp,sp,-64
 bf2:	fc06                	sd	ra,56(sp)
 bf4:	f822                	sd	s0,48(sp)
 bf6:	f426                	sd	s1,40(sp)
 bf8:	f04a                	sd	s2,32(sp)
 bfa:	ec4e                	sd	s3,24(sp)
 bfc:	e852                	sd	s4,16(sp)
 bfe:	0080                	addi	s0,sp,64
 c00:	89aa                	mv	s3,a0
 c02:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c04:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 c06:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c08:	4605                	li	a2,1
 c0a:	fcf40593          	addi	a1,s0,-49
 c0e:	854e                	mv	a0,s3
 c10:	fffff097          	auipc	ra,0xfffff
 c14:	6ee080e7          	jalr	1774(ra) # 2fe <read>
		if (readStatus == 0){
 c18:	c505                	beqz	a0,c40 <read_line+0x50>
		*buffer++ = readByte;
 c1a:	0485                	addi	s1,s1,1
 c1c:	fcf44783          	lbu	a5,-49(s0)
 c20:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c24:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c26:	ff4791e3          	bne	a5,s4,c08 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c2a:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 c2e:	854a                	mv	a0,s2
 c30:	70e2                	ld	ra,56(sp)
 c32:	7442                	ld	s0,48(sp)
 c34:	74a2                	ld	s1,40(sp)
 c36:	7902                	ld	s2,32(sp)
 c38:	69e2                	ld	s3,24(sp)
 c3a:	6a42                	ld	s4,16(sp)
 c3c:	6121                	addi	sp,sp,64
 c3e:	8082                	ret
			if (byteCount!=0){
 c40:	fe0907e3          	beqz	s2,c2e <read_line+0x3e>
				*buffer = '\n';
 c44:	47a9                	li	a5,10
 c46:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 c4a:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 c4e:	2905                	addiw	s2,s2,1
 c50:	bff9                	j	c2e <read_line+0x3e>

0000000000000c52 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c52:	1141                	addi	sp,sp,-16
 c54:	e406                	sd	ra,8(sp)
 c56:	e022                	sd	s0,0(sp)
 c58:	0800                	addi	s0,sp,16
	close(fd);
 c5a:	fffff097          	auipc	ra,0xfffff
 c5e:	6b4080e7          	jalr	1716(ra) # 30e <close>
}
 c62:	60a2                	ld	ra,8(sp)
 c64:	6402                	ld	s0,0(sp)
 c66:	0141                	addi	sp,sp,16
 c68:	8082                	ret

0000000000000c6a <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 c6a:	7139                	addi	sp,sp,-64
 c6c:	fc06                	sd	ra,56(sp)
 c6e:	f822                	sd	s0,48(sp)
 c70:	f426                	sd	s1,40(sp)
 c72:	f04a                	sd	s2,32(sp)
 c74:	0080                	addi	s0,sp,64
 c76:	84aa                	mv	s1,a0
 c78:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 c7a:	fffff097          	auipc	ra,0xfffff
 c7e:	664080e7          	jalr	1636(ra) # 2de <fork>
 c82:	ed19                	bnez	a0,ca0 <get_time_perf+0x36>
		exec(argv[0],argv);
 c84:	85ca                	mv	a1,s2
 c86:	00093503          	ld	a0,0(s2)
 c8a:	fffff097          	auipc	ra,0xfffff
 c8e:	694080e7          	jalr	1684(ra) # 31e <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 c92:	8526                	mv	a0,s1
 c94:	70e2                	ld	ra,56(sp)
 c96:	7442                	ld	s0,48(sp)
 c98:	74a2                	ld	s1,40(sp)
 c9a:	7902                	ld	s2,32(sp)
 c9c:	6121                	addi	sp,sp,64
 c9e:	8082                	ret
		times(pid , &time);
 ca0:	fc840593          	addi	a1,s0,-56
 ca4:	fffff097          	auipc	ra,0xfffff
 ca8:	6fa080e7          	jalr	1786(ra) # 39e <times>
		return time;
 cac:	fc843783          	ld	a5,-56(s0)
 cb0:	e09c                	sd	a5,0(s1)
 cb2:	fd043783          	ld	a5,-48(s0)
 cb6:	e49c                	sd	a5,8(s1)
 cb8:	fd843783          	ld	a5,-40(s0)
 cbc:	e89c                	sd	a5,16(s1)
 cbe:	bfd1                	j	c92 <get_time_perf+0x28>
