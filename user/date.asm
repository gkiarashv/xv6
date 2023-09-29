
user/_date:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "gelibs/time.h"



int main(){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32

	time_t time;

	gettime(&time);
   8:	fe840513          	addi	a0,s0,-24
   c:	00000097          	auipc	ra,0x0
  10:	394080e7          	jalr	916(ra) # 3a0 <gettime>

	tick_to_time("Started",time*100);
  14:	06400793          	li	a5,100
  18:	fe843703          	ld	a4,-24(s0)
  1c:	02e787b3          	mul	a5,a5,a4
  20:	663d                	lui	a2,0xf
  22:	a6060613          	addi	a2,a2,-1440 # ea60 <base+0xda50>
  26:	02c7f5b3          	remu	a1,a5,a2
  2a:	3e800693          	li	a3,1000
  2e:	02d5f733          	remu	a4,a1,a3
  32:	02d5d6b3          	divu	a3,a1,a3
  36:	02c7d633          	divu	a2,a5,a2
  3a:	00001597          	auipc	a1,0x1
  3e:	c8658593          	addi	a1,a1,-890 # cc0 <get_time_perf+0x5c>
  42:	00001517          	auipc	a0,0x1
  46:	c8650513          	addi	a0,a0,-890 # cc8 <get_time_perf+0x64>
  4a:	00000097          	auipc	ra,0x0
  4e:	638080e7          	jalr	1592(ra) # 682 <printf>
}
  52:	60e2                	ld	ra,24(sp)
  54:	6442                	ld	s0,16(sp)
  56:	6105                	addi	sp,sp,32
  58:	8082                	ret

000000000000005a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  5a:	1141                	addi	sp,sp,-16
  5c:	e406                	sd	ra,8(sp)
  5e:	e022                	sd	s0,0(sp)
  60:	0800                	addi	s0,sp,16
  extern int main();
  main();
  62:	00000097          	auipc	ra,0x0
  66:	f9e080e7          	jalr	-98(ra) # 0 <main>
  exit(0);
  6a:	4501                	li	a0,0
  6c:	00000097          	auipc	ra,0x0
  70:	274080e7          	jalr	628(ra) # 2e0 <exit>

0000000000000074 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  74:	1141                	addi	sp,sp,-16
  76:	e422                	sd	s0,8(sp)
  78:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	87aa                	mv	a5,a0
  7c:	0585                	addi	a1,a1,1
  7e:	0785                	addi	a5,a5,1
  80:	fff5c703          	lbu	a4,-1(a1)
  84:	fee78fa3          	sb	a4,-1(a5)
  88:	fb75                	bnez	a4,7c <strcpy+0x8>
    ;
  return os;
}
  8a:	6422                	ld	s0,8(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret

0000000000000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	1141                	addi	sp,sp,-16
  92:	e422                	sd	s0,8(sp)
  94:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	cb91                	beqz	a5,ae <strcmp+0x1e>
  9c:	0005c703          	lbu	a4,0(a1)
  a0:	00f71763          	bne	a4,a5,ae <strcmp+0x1e>
    p++, q++;
  a4:	0505                	addi	a0,a0,1
  a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	fbe5                	bnez	a5,9c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ae:	0005c503          	lbu	a0,0(a1)
}
  b2:	40a7853b          	subw	a0,a5,a0
  b6:	6422                	ld	s0,8(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strlen>:

uint
strlen(const char *s)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	cf91                	beqz	a5,e2 <strlen+0x26>
  c8:	0505                	addi	a0,a0,1
  ca:	87aa                	mv	a5,a0
  cc:	4685                	li	a3,1
  ce:	9e89                	subw	a3,a3,a0
  d0:	00f6853b          	addw	a0,a3,a5
  d4:	0785                	addi	a5,a5,1
  d6:	fff7c703          	lbu	a4,-1(a5)
  da:	fb7d                	bnez	a4,d0 <strlen+0x14>
    ;
  return n;
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret
  for(n = 0; s[n]; n++)
  e2:	4501                	li	a0,0
  e4:	bfe5                	j	dc <strlen+0x20>

00000000000000e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e422                	sd	s0,8(sp)
  ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ec:	ca19                	beqz	a2,102 <memset+0x1c>
  ee:	87aa                	mv	a5,a0
  f0:	1602                	slli	a2,a2,0x20
  f2:	9201                	srli	a2,a2,0x20
  f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fc:	0785                	addi	a5,a5,1
  fe:	fee79de3          	bne	a5,a4,f8 <memset+0x12>
  }
  return dst;
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret

0000000000000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 10e:	00054783          	lbu	a5,0(a0)
 112:	cb99                	beqz	a5,128 <strchr+0x20>
    if(*s == c)
 114:	00f58763          	beq	a1,a5,122 <strchr+0x1a>
  for(; *s; s++)
 118:	0505                	addi	a0,a0,1
 11a:	00054783          	lbu	a5,0(a0)
 11e:	fbfd                	bnez	a5,114 <strchr+0xc>
      return (char*)s;
  return 0;
 120:	4501                	li	a0,0
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret
  return 0;
 128:	4501                	li	a0,0
 12a:	bfe5                	j	122 <strchr+0x1a>

000000000000012c <gets>:

char*
gets(char *buf, int max)
{
 12c:	711d                	addi	sp,sp,-96
 12e:	ec86                	sd	ra,88(sp)
 130:	e8a2                	sd	s0,80(sp)
 132:	e4a6                	sd	s1,72(sp)
 134:	e0ca                	sd	s2,64(sp)
 136:	fc4e                	sd	s3,56(sp)
 138:	f852                	sd	s4,48(sp)
 13a:	f456                	sd	s5,40(sp)
 13c:	f05a                	sd	s6,32(sp)
 13e:	ec5e                	sd	s7,24(sp)
 140:	1080                	addi	s0,sp,96
 142:	8baa                	mv	s7,a0
 144:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 146:	892a                	mv	s2,a0
 148:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14a:	4aa9                	li	s5,10
 14c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 14e:	89a6                	mv	s3,s1
 150:	2485                	addiw	s1,s1,1
 152:	0344d863          	bge	s1,s4,182 <gets+0x56>
    cc = read(0, &c, 1);
 156:	4605                	li	a2,1
 158:	faf40593          	addi	a1,s0,-81
 15c:	4501                	li	a0,0
 15e:	00000097          	auipc	ra,0x0
 162:	19a080e7          	jalr	410(ra) # 2f8 <read>
    if(cc < 1)
 166:	00a05e63          	blez	a0,182 <gets+0x56>
    buf[i++] = c;
 16a:	faf44783          	lbu	a5,-81(s0)
 16e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 172:	01578763          	beq	a5,s5,180 <gets+0x54>
 176:	0905                	addi	s2,s2,1
 178:	fd679be3          	bne	a5,s6,14e <gets+0x22>
  for(i=0; i+1 < max; ){
 17c:	89a6                	mv	s3,s1
 17e:	a011                	j	182 <gets+0x56>
 180:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 182:	99de                	add	s3,s3,s7
 184:	00098023          	sb	zero,0(s3)
  return buf;
}
 188:	855e                	mv	a0,s7
 18a:	60e6                	ld	ra,88(sp)
 18c:	6446                	ld	s0,80(sp)
 18e:	64a6                	ld	s1,72(sp)
 190:	6906                	ld	s2,64(sp)
 192:	79e2                	ld	s3,56(sp)
 194:	7a42                	ld	s4,48(sp)
 196:	7aa2                	ld	s5,40(sp)
 198:	7b02                	ld	s6,32(sp)
 19a:	6be2                	ld	s7,24(sp)
 19c:	6125                	addi	sp,sp,96
 19e:	8082                	ret

00000000000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	1101                	addi	sp,sp,-32
 1a2:	ec06                	sd	ra,24(sp)
 1a4:	e822                	sd	s0,16(sp)
 1a6:	e426                	sd	s1,8(sp)
 1a8:	e04a                	sd	s2,0(sp)
 1aa:	1000                	addi	s0,sp,32
 1ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ae:	4581                	li	a1,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	170080e7          	jalr	368(ra) # 320 <open>
  if(fd < 0)
 1b8:	02054563          	bltz	a0,1e2 <stat+0x42>
 1bc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1be:	85ca                	mv	a1,s2
 1c0:	00000097          	auipc	ra,0x0
 1c4:	178080e7          	jalr	376(ra) # 338 <fstat>
 1c8:	892a                	mv	s2,a0
  close(fd);
 1ca:	8526                	mv	a0,s1
 1cc:	00000097          	auipc	ra,0x0
 1d0:	13c080e7          	jalr	316(ra) # 308 <close>
  return r;
}
 1d4:	854a                	mv	a0,s2
 1d6:	60e2                	ld	ra,24(sp)
 1d8:	6442                	ld	s0,16(sp)
 1da:	64a2                	ld	s1,8(sp)
 1dc:	6902                	ld	s2,0(sp)
 1de:	6105                	addi	sp,sp,32
 1e0:	8082                	ret
    return -1;
 1e2:	597d                	li	s2,-1
 1e4:	bfc5                	j	1d4 <stat+0x34>

00000000000001e6 <atoi>:

int
atoi(const char *s)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ec:	00054683          	lbu	a3,0(a0)
 1f0:	fd06879b          	addiw	a5,a3,-48
 1f4:	0ff7f793          	zext.b	a5,a5
 1f8:	4625                	li	a2,9
 1fa:	02f66863          	bltu	a2,a5,22a <atoi+0x44>
 1fe:	872a                	mv	a4,a0
  n = 0;
 200:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 202:	0705                	addi	a4,a4,1
 204:	0025179b          	slliw	a5,a0,0x2
 208:	9fa9                	addw	a5,a5,a0
 20a:	0017979b          	slliw	a5,a5,0x1
 20e:	9fb5                	addw	a5,a5,a3
 210:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 214:	00074683          	lbu	a3,0(a4)
 218:	fd06879b          	addiw	a5,a3,-48
 21c:	0ff7f793          	zext.b	a5,a5
 220:	fef671e3          	bgeu	a2,a5,202 <atoi+0x1c>
  return n;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
  n = 0;
 22a:	4501                	li	a0,0
 22c:	bfe5                	j	224 <atoi+0x3e>

000000000000022e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 234:	02b57463          	bgeu	a0,a1,25c <memmove+0x2e>
    while(n-- > 0)
 238:	00c05f63          	blez	a2,256 <memmove+0x28>
 23c:	1602                	slli	a2,a2,0x20
 23e:	9201                	srli	a2,a2,0x20
 240:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 244:	872a                	mv	a4,a0
      *dst++ = *src++;
 246:	0585                	addi	a1,a1,1
 248:	0705                	addi	a4,a4,1
 24a:	fff5c683          	lbu	a3,-1(a1)
 24e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 252:	fee79ae3          	bne	a5,a4,246 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 256:	6422                	ld	s0,8(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
    dst += n;
 25c:	00c50733          	add	a4,a0,a2
    src += n;
 260:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 262:	fec05ae3          	blez	a2,256 <memmove+0x28>
 266:	fff6079b          	addiw	a5,a2,-1
 26a:	1782                	slli	a5,a5,0x20
 26c:	9381                	srli	a5,a5,0x20
 26e:	fff7c793          	not	a5,a5
 272:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 274:	15fd                	addi	a1,a1,-1
 276:	177d                	addi	a4,a4,-1
 278:	0005c683          	lbu	a3,0(a1)
 27c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 280:	fee79ae3          	bne	a5,a4,274 <memmove+0x46>
 284:	bfc9                	j	256 <memmove+0x28>

0000000000000286 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28c:	ca05                	beqz	a2,2bc <memcmp+0x36>
 28e:	fff6069b          	addiw	a3,a2,-1
 292:	1682                	slli	a3,a3,0x20
 294:	9281                	srli	a3,a3,0x20
 296:	0685                	addi	a3,a3,1
 298:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 29a:	00054783          	lbu	a5,0(a0)
 29e:	0005c703          	lbu	a4,0(a1)
 2a2:	00e79863          	bne	a5,a4,2b2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2a6:	0505                	addi	a0,a0,1
    p2++;
 2a8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2aa:	fed518e3          	bne	a0,a3,29a <memcmp+0x14>
  }
  return 0;
 2ae:	4501                	li	a0,0
 2b0:	a019                	j	2b6 <memcmp+0x30>
      return *p1 - *p2;
 2b2:	40e7853b          	subw	a0,a5,a4
}
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
  return 0;
 2bc:	4501                	li	a0,0
 2be:	bfe5                	j	2b6 <memcmp+0x30>

00000000000002c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e406                	sd	ra,8(sp)
 2c4:	e022                	sd	s0,0(sp)
 2c6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c8:	00000097          	auipc	ra,0x0
 2cc:	f66080e7          	jalr	-154(ra) # 22e <memmove>
}
 2d0:	60a2                	ld	ra,8(sp)
 2d2:	6402                	ld	s0,0(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret

00000000000002d8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d8:	4885                	li	a7,1
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e0:	4889                	li	a7,2
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e8:	488d                	li	a7,3
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f0:	4891                	li	a7,4
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <read>:
.global read
read:
 li a7, SYS_read
 2f8:	4895                	li	a7,5
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <write>:
.global write
write:
 li a7, SYS_write
 300:	48c1                	li	a7,16
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <close>:
.global close
close:
 li a7, SYS_close
 308:	48d5                	li	a7,21
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <kill>:
.global kill
kill:
 li a7, SYS_kill
 310:	4899                	li	a7,6
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <exec>:
.global exec
exec:
 li a7, SYS_exec
 318:	489d                	li	a7,7
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <open>:
.global open
open:
 li a7, SYS_open
 320:	48bd                	li	a7,15
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 328:	48c5                	li	a7,17
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 330:	48c9                	li	a7,18
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 338:	48a1                	li	a7,8
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <link>:
.global link
link:
 li a7, SYS_link
 340:	48cd                	li	a7,19
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 348:	48d1                	li	a7,20
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 350:	48a5                	li	a7,9
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <dup>:
.global dup
dup:
 li a7, SYS_dup
 358:	48a9                	li	a7,10
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 360:	48ad                	li	a7,11
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 368:	48b1                	li	a7,12
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 370:	48b5                	li	a7,13
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 378:	48b9                	li	a7,14
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <head>:
.global head
head:
 li a7, SYS_head
 380:	48d9                	li	a7,22
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 388:	48dd                	li	a7,23
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <ps>:
.global ps
ps:
 li a7, SYS_ps
 390:	48e1                	li	a7,24
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <times>:
.global times
times:
 li a7, SYS_times
 398:	48e5                	li	a7,25
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 3a0:	48e9                	li	a7,26
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a8:	1101                	addi	sp,sp,-32
 3aa:	ec06                	sd	ra,24(sp)
 3ac:	e822                	sd	s0,16(sp)
 3ae:	1000                	addi	s0,sp,32
 3b0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b4:	4605                	li	a2,1
 3b6:	fef40593          	addi	a1,s0,-17
 3ba:	00000097          	auipc	ra,0x0
 3be:	f46080e7          	jalr	-186(ra) # 300 <write>
}
 3c2:	60e2                	ld	ra,24(sp)
 3c4:	6442                	ld	s0,16(sp)
 3c6:	6105                	addi	sp,sp,32
 3c8:	8082                	ret

00000000000003ca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ca:	7139                	addi	sp,sp,-64
 3cc:	fc06                	sd	ra,56(sp)
 3ce:	f822                	sd	s0,48(sp)
 3d0:	f426                	sd	s1,40(sp)
 3d2:	f04a                	sd	s2,32(sp)
 3d4:	ec4e                	sd	s3,24(sp)
 3d6:	0080                	addi	s0,sp,64
 3d8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3da:	c299                	beqz	a3,3e0 <printint+0x16>
 3dc:	0805c963          	bltz	a1,46e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e0:	2581                	sext.w	a1,a1
  neg = 0;
 3e2:	4881                	li	a7,0
 3e4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3e8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ea:	2601                	sext.w	a2,a2
 3ec:	00001517          	auipc	a0,0x1
 3f0:	96450513          	addi	a0,a0,-1692 # d50 <digits>
 3f4:	883a                	mv	a6,a4
 3f6:	2705                	addiw	a4,a4,1
 3f8:	02c5f7bb          	remuw	a5,a1,a2
 3fc:	1782                	slli	a5,a5,0x20
 3fe:	9381                	srli	a5,a5,0x20
 400:	97aa                	add	a5,a5,a0
 402:	0007c783          	lbu	a5,0(a5)
 406:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 40a:	0005879b          	sext.w	a5,a1
 40e:	02c5d5bb          	divuw	a1,a1,a2
 412:	0685                	addi	a3,a3,1
 414:	fec7f0e3          	bgeu	a5,a2,3f4 <printint+0x2a>
  if(neg)
 418:	00088c63          	beqz	a7,430 <printint+0x66>
    buf[i++] = '-';
 41c:	fd070793          	addi	a5,a4,-48
 420:	00878733          	add	a4,a5,s0
 424:	02d00793          	li	a5,45
 428:	fef70823          	sb	a5,-16(a4)
 42c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 430:	02e05863          	blez	a4,460 <printint+0x96>
 434:	fc040793          	addi	a5,s0,-64
 438:	00e78933          	add	s2,a5,a4
 43c:	fff78993          	addi	s3,a5,-1
 440:	99ba                	add	s3,s3,a4
 442:	377d                	addiw	a4,a4,-1
 444:	1702                	slli	a4,a4,0x20
 446:	9301                	srli	a4,a4,0x20
 448:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 44c:	fff94583          	lbu	a1,-1(s2)
 450:	8526                	mv	a0,s1
 452:	00000097          	auipc	ra,0x0
 456:	f56080e7          	jalr	-170(ra) # 3a8 <putc>
  while(--i >= 0)
 45a:	197d                	addi	s2,s2,-1
 45c:	ff3918e3          	bne	s2,s3,44c <printint+0x82>
}
 460:	70e2                	ld	ra,56(sp)
 462:	7442                	ld	s0,48(sp)
 464:	74a2                	ld	s1,40(sp)
 466:	7902                	ld	s2,32(sp)
 468:	69e2                	ld	s3,24(sp)
 46a:	6121                	addi	sp,sp,64
 46c:	8082                	ret
    x = -xx;
 46e:	40b005bb          	negw	a1,a1
    neg = 1;
 472:	4885                	li	a7,1
    x = -xx;
 474:	bf85                	j	3e4 <printint+0x1a>

0000000000000476 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 476:	7119                	addi	sp,sp,-128
 478:	fc86                	sd	ra,120(sp)
 47a:	f8a2                	sd	s0,112(sp)
 47c:	f4a6                	sd	s1,104(sp)
 47e:	f0ca                	sd	s2,96(sp)
 480:	ecce                	sd	s3,88(sp)
 482:	e8d2                	sd	s4,80(sp)
 484:	e4d6                	sd	s5,72(sp)
 486:	e0da                	sd	s6,64(sp)
 488:	fc5e                	sd	s7,56(sp)
 48a:	f862                	sd	s8,48(sp)
 48c:	f466                	sd	s9,40(sp)
 48e:	f06a                	sd	s10,32(sp)
 490:	ec6e                	sd	s11,24(sp)
 492:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 494:	0005c903          	lbu	s2,0(a1)
 498:	18090f63          	beqz	s2,636 <vprintf+0x1c0>
 49c:	8aaa                	mv	s5,a0
 49e:	8b32                	mv	s6,a2
 4a0:	00158493          	addi	s1,a1,1
  state = 0;
 4a4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4a6:	02500a13          	li	s4,37
 4aa:	4c55                	li	s8,21
 4ac:	00001c97          	auipc	s9,0x1
 4b0:	84cc8c93          	addi	s9,s9,-1972 # cf8 <get_time_perf+0x94>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4b4:	02800d93          	li	s11,40
  putc(fd, 'x');
 4b8:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4ba:	00001b97          	auipc	s7,0x1
 4be:	896b8b93          	addi	s7,s7,-1898 # d50 <digits>
 4c2:	a839                	j	4e0 <vprintf+0x6a>
        putc(fd, c);
 4c4:	85ca                	mv	a1,s2
 4c6:	8556                	mv	a0,s5
 4c8:	00000097          	auipc	ra,0x0
 4cc:	ee0080e7          	jalr	-288(ra) # 3a8 <putc>
 4d0:	a019                	j	4d6 <vprintf+0x60>
    } else if(state == '%'){
 4d2:	01498d63          	beq	s3,s4,4ec <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4d6:	0485                	addi	s1,s1,1
 4d8:	fff4c903          	lbu	s2,-1(s1)
 4dc:	14090d63          	beqz	s2,636 <vprintf+0x1c0>
    if(state == 0){
 4e0:	fe0999e3          	bnez	s3,4d2 <vprintf+0x5c>
      if(c == '%'){
 4e4:	ff4910e3          	bne	s2,s4,4c4 <vprintf+0x4e>
        state = '%';
 4e8:	89d2                	mv	s3,s4
 4ea:	b7f5                	j	4d6 <vprintf+0x60>
      if(c == 'd'){
 4ec:	11490c63          	beq	s2,s4,604 <vprintf+0x18e>
 4f0:	f9d9079b          	addiw	a5,s2,-99
 4f4:	0ff7f793          	zext.b	a5,a5
 4f8:	10fc6e63          	bltu	s8,a5,614 <vprintf+0x19e>
 4fc:	f9d9079b          	addiw	a5,s2,-99
 500:	0ff7f713          	zext.b	a4,a5
 504:	10ec6863          	bltu	s8,a4,614 <vprintf+0x19e>
 508:	00271793          	slli	a5,a4,0x2
 50c:	97e6                	add	a5,a5,s9
 50e:	439c                	lw	a5,0(a5)
 510:	97e6                	add	a5,a5,s9
 512:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 514:	008b0913          	addi	s2,s6,8
 518:	4685                	li	a3,1
 51a:	4629                	li	a2,10
 51c:	000b2583          	lw	a1,0(s6)
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	ea8080e7          	jalr	-344(ra) # 3ca <printint>
 52a:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 52c:	4981                	li	s3,0
 52e:	b765                	j	4d6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 530:	008b0913          	addi	s2,s6,8
 534:	4681                	li	a3,0
 536:	4629                	li	a2,10
 538:	000b2583          	lw	a1,0(s6)
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	e8c080e7          	jalr	-372(ra) # 3ca <printint>
 546:	8b4a                	mv	s6,s2
      state = 0;
 548:	4981                	li	s3,0
 54a:	b771                	j	4d6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 54c:	008b0913          	addi	s2,s6,8
 550:	4681                	li	a3,0
 552:	866a                	mv	a2,s10
 554:	000b2583          	lw	a1,0(s6)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e70080e7          	jalr	-400(ra) # 3ca <printint>
 562:	8b4a                	mv	s6,s2
      state = 0;
 564:	4981                	li	s3,0
 566:	bf85                	j	4d6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 568:	008b0793          	addi	a5,s6,8
 56c:	f8f43423          	sd	a5,-120(s0)
 570:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 574:	03000593          	li	a1,48
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e2e080e7          	jalr	-466(ra) # 3a8 <putc>
  putc(fd, 'x');
 582:	07800593          	li	a1,120
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	e20080e7          	jalr	-480(ra) # 3a8 <putc>
 590:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 592:	03c9d793          	srli	a5,s3,0x3c
 596:	97de                	add	a5,a5,s7
 598:	0007c583          	lbu	a1,0(a5)
 59c:	8556                	mv	a0,s5
 59e:	00000097          	auipc	ra,0x0
 5a2:	e0a080e7          	jalr	-502(ra) # 3a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5a6:	0992                	slli	s3,s3,0x4
 5a8:	397d                	addiw	s2,s2,-1
 5aa:	fe0914e3          	bnez	s2,592 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5ae:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	b70d                	j	4d6 <vprintf+0x60>
        s = va_arg(ap, char*);
 5b6:	008b0913          	addi	s2,s6,8
 5ba:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5be:	02098163          	beqz	s3,5e0 <vprintf+0x16a>
        while(*s != 0){
 5c2:	0009c583          	lbu	a1,0(s3)
 5c6:	c5ad                	beqz	a1,630 <vprintf+0x1ba>
          putc(fd, *s);
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	dde080e7          	jalr	-546(ra) # 3a8 <putc>
          s++;
 5d2:	0985                	addi	s3,s3,1
        while(*s != 0){
 5d4:	0009c583          	lbu	a1,0(s3)
 5d8:	f9e5                	bnez	a1,5c8 <vprintf+0x152>
        s = va_arg(ap, char*);
 5da:	8b4a                	mv	s6,s2
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bde5                	j	4d6 <vprintf+0x60>
          s = "(null)";
 5e0:	00000997          	auipc	s3,0x0
 5e4:	71098993          	addi	s3,s3,1808 # cf0 <get_time_perf+0x8c>
        while(*s != 0){
 5e8:	85ee                	mv	a1,s11
 5ea:	bff9                	j	5c8 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5ec:	008b0913          	addi	s2,s6,8
 5f0:	000b4583          	lbu	a1,0(s6)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	db2080e7          	jalr	-590(ra) # 3a8 <putc>
 5fe:	8b4a                	mv	s6,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	bdd1                	j	4d6 <vprintf+0x60>
        putc(fd, c);
 604:	85d2                	mv	a1,s4
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	da0080e7          	jalr	-608(ra) # 3a8 <putc>
      state = 0;
 610:	4981                	li	s3,0
 612:	b5d1                	j	4d6 <vprintf+0x60>
        putc(fd, '%');
 614:	85d2                	mv	a1,s4
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	d90080e7          	jalr	-624(ra) # 3a8 <putc>
        putc(fd, c);
 620:	85ca                	mv	a1,s2
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	d84080e7          	jalr	-636(ra) # 3a8 <putc>
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b565                	j	4d6 <vprintf+0x60>
        s = va_arg(ap, char*);
 630:	8b4a                	mv	s6,s2
      state = 0;
 632:	4981                	li	s3,0
 634:	b54d                	j	4d6 <vprintf+0x60>
    }
  }
}
 636:	70e6                	ld	ra,120(sp)
 638:	7446                	ld	s0,112(sp)
 63a:	74a6                	ld	s1,104(sp)
 63c:	7906                	ld	s2,96(sp)
 63e:	69e6                	ld	s3,88(sp)
 640:	6a46                	ld	s4,80(sp)
 642:	6aa6                	ld	s5,72(sp)
 644:	6b06                	ld	s6,64(sp)
 646:	7be2                	ld	s7,56(sp)
 648:	7c42                	ld	s8,48(sp)
 64a:	7ca2                	ld	s9,40(sp)
 64c:	7d02                	ld	s10,32(sp)
 64e:	6de2                	ld	s11,24(sp)
 650:	6109                	addi	sp,sp,128
 652:	8082                	ret

0000000000000654 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 654:	715d                	addi	sp,sp,-80
 656:	ec06                	sd	ra,24(sp)
 658:	e822                	sd	s0,16(sp)
 65a:	1000                	addi	s0,sp,32
 65c:	e010                	sd	a2,0(s0)
 65e:	e414                	sd	a3,8(s0)
 660:	e818                	sd	a4,16(s0)
 662:	ec1c                	sd	a5,24(s0)
 664:	03043023          	sd	a6,32(s0)
 668:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 66c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 670:	8622                	mv	a2,s0
 672:	00000097          	auipc	ra,0x0
 676:	e04080e7          	jalr	-508(ra) # 476 <vprintf>
}
 67a:	60e2                	ld	ra,24(sp)
 67c:	6442                	ld	s0,16(sp)
 67e:	6161                	addi	sp,sp,80
 680:	8082                	ret

0000000000000682 <printf>:

void
printf(const char *fmt, ...)
{
 682:	711d                	addi	sp,sp,-96
 684:	ec06                	sd	ra,24(sp)
 686:	e822                	sd	s0,16(sp)
 688:	1000                	addi	s0,sp,32
 68a:	e40c                	sd	a1,8(s0)
 68c:	e810                	sd	a2,16(s0)
 68e:	ec14                	sd	a3,24(s0)
 690:	f018                	sd	a4,32(s0)
 692:	f41c                	sd	a5,40(s0)
 694:	03043823          	sd	a6,48(s0)
 698:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 69c:	00840613          	addi	a2,s0,8
 6a0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6a4:	85aa                	mv	a1,a0
 6a6:	4505                	li	a0,1
 6a8:	00000097          	auipc	ra,0x0
 6ac:	dce080e7          	jalr	-562(ra) # 476 <vprintf>
}
 6b0:	60e2                	ld	ra,24(sp)
 6b2:	6442                	ld	s0,16(sp)
 6b4:	6125                	addi	sp,sp,96
 6b6:	8082                	ret

00000000000006b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b8:	1141                	addi	sp,sp,-16
 6ba:	e422                	sd	s0,8(sp)
 6bc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6be:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c2:	00001797          	auipc	a5,0x1
 6c6:	93e7b783          	ld	a5,-1730(a5) # 1000 <freep>
 6ca:	a02d                	j	6f4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6cc:	4618                	lw	a4,8(a2)
 6ce:	9f2d                	addw	a4,a4,a1
 6d0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d4:	6398                	ld	a4,0(a5)
 6d6:	6310                	ld	a2,0(a4)
 6d8:	a83d                	j	716 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6da:	ff852703          	lw	a4,-8(a0)
 6de:	9f31                	addw	a4,a4,a2
 6e0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6e2:	ff053683          	ld	a3,-16(a0)
 6e6:	a091                	j	72a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e8:	6398                	ld	a4,0(a5)
 6ea:	00e7e463          	bltu	a5,a4,6f2 <free+0x3a>
 6ee:	00e6ea63          	bltu	a3,a4,702 <free+0x4a>
{
 6f2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f4:	fed7fae3          	bgeu	a5,a3,6e8 <free+0x30>
 6f8:	6398                	ld	a4,0(a5)
 6fa:	00e6e463          	bltu	a3,a4,702 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fe:	fee7eae3          	bltu	a5,a4,6f2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 702:	ff852583          	lw	a1,-8(a0)
 706:	6390                	ld	a2,0(a5)
 708:	02059813          	slli	a6,a1,0x20
 70c:	01c85713          	srli	a4,a6,0x1c
 710:	9736                	add	a4,a4,a3
 712:	fae60de3          	beq	a2,a4,6cc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 716:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 71a:	4790                	lw	a2,8(a5)
 71c:	02061593          	slli	a1,a2,0x20
 720:	01c5d713          	srli	a4,a1,0x1c
 724:	973e                	add	a4,a4,a5
 726:	fae68ae3          	beq	a3,a4,6da <free+0x22>
    p->s.ptr = bp->s.ptr;
 72a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 72c:	00001717          	auipc	a4,0x1
 730:	8cf73a23          	sd	a5,-1836(a4) # 1000 <freep>
}
 734:	6422                	ld	s0,8(sp)
 736:	0141                	addi	sp,sp,16
 738:	8082                	ret

000000000000073a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 73a:	7139                	addi	sp,sp,-64
 73c:	fc06                	sd	ra,56(sp)
 73e:	f822                	sd	s0,48(sp)
 740:	f426                	sd	s1,40(sp)
 742:	f04a                	sd	s2,32(sp)
 744:	ec4e                	sd	s3,24(sp)
 746:	e852                	sd	s4,16(sp)
 748:	e456                	sd	s5,8(sp)
 74a:	e05a                	sd	s6,0(sp)
 74c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74e:	02051493          	slli	s1,a0,0x20
 752:	9081                	srli	s1,s1,0x20
 754:	04bd                	addi	s1,s1,15
 756:	8091                	srli	s1,s1,0x4
 758:	0014899b          	addiw	s3,s1,1
 75c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 75e:	00001517          	auipc	a0,0x1
 762:	8a253503          	ld	a0,-1886(a0) # 1000 <freep>
 766:	c515                	beqz	a0,792 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 768:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 76a:	4798                	lw	a4,8(a5)
 76c:	02977f63          	bgeu	a4,s1,7aa <malloc+0x70>
 770:	8a4e                	mv	s4,s3
 772:	0009871b          	sext.w	a4,s3
 776:	6685                	lui	a3,0x1
 778:	00d77363          	bgeu	a4,a3,77e <malloc+0x44>
 77c:	6a05                	lui	s4,0x1
 77e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 782:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 786:	00001917          	auipc	s2,0x1
 78a:	87a90913          	addi	s2,s2,-1926 # 1000 <freep>
  if(p == (char*)-1)
 78e:	5afd                	li	s5,-1
 790:	a895                	j	804 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 792:	00001797          	auipc	a5,0x1
 796:	87e78793          	addi	a5,a5,-1922 # 1010 <base>
 79a:	00001717          	auipc	a4,0x1
 79e:	86f73323          	sd	a5,-1946(a4) # 1000 <freep>
 7a2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7a4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7a8:	b7e1                	j	770 <malloc+0x36>
      if(p->s.size == nunits)
 7aa:	02e48c63          	beq	s1,a4,7e2 <malloc+0xa8>
        p->s.size -= nunits;
 7ae:	4137073b          	subw	a4,a4,s3
 7b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7b4:	02071693          	slli	a3,a4,0x20
 7b8:	01c6d713          	srli	a4,a3,0x1c
 7bc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7be:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7c2:	00001717          	auipc	a4,0x1
 7c6:	82a73f23          	sd	a0,-1986(a4) # 1000 <freep>
      return (void*)(p + 1);
 7ca:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ce:	70e2                	ld	ra,56(sp)
 7d0:	7442                	ld	s0,48(sp)
 7d2:	74a2                	ld	s1,40(sp)
 7d4:	7902                	ld	s2,32(sp)
 7d6:	69e2                	ld	s3,24(sp)
 7d8:	6a42                	ld	s4,16(sp)
 7da:	6aa2                	ld	s5,8(sp)
 7dc:	6b02                	ld	s6,0(sp)
 7de:	6121                	addi	sp,sp,64
 7e0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7e2:	6398                	ld	a4,0(a5)
 7e4:	e118                	sd	a4,0(a0)
 7e6:	bff1                	j	7c2 <malloc+0x88>
  hp->s.size = nu;
 7e8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ec:	0541                	addi	a0,a0,16
 7ee:	00000097          	auipc	ra,0x0
 7f2:	eca080e7          	jalr	-310(ra) # 6b8 <free>
  return freep;
 7f6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7fa:	d971                	beqz	a0,7ce <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7fe:	4798                	lw	a4,8(a5)
 800:	fa9775e3          	bgeu	a4,s1,7aa <malloc+0x70>
    if(p == freep)
 804:	00093703          	ld	a4,0(s2)
 808:	853e                	mv	a0,a5
 80a:	fef719e3          	bne	a4,a5,7fc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 80e:	8552                	mv	a0,s4
 810:	00000097          	auipc	ra,0x0
 814:	b58080e7          	jalr	-1192(ra) # 368 <sbrk>
  if(p == (char*)-1)
 818:	fd5518e3          	bne	a0,s5,7e8 <malloc+0xae>
        return 0;
 81c:	4501                	li	a0,0
 81e:	bf45                	j	7ce <malloc+0x94>

0000000000000820 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 820:	c1d9                	beqz	a1,8a6 <head_run+0x86>
void head_run(int fd, int numOfLines){
 822:	dd010113          	addi	sp,sp,-560
 826:	22113423          	sd	ra,552(sp)
 82a:	22813023          	sd	s0,544(sp)
 82e:	20913c23          	sd	s1,536(sp)
 832:	21213823          	sd	s2,528(sp)
 836:	21313423          	sd	s3,520(sp)
 83a:	21413023          	sd	s4,512(sp)
 83e:	1c00                	addi	s0,sp,560
 840:	892a                	mv	s2,a0
 842:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 846:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 848:	00000a17          	auipc	s4,0x0
 84c:	548a0a13          	addi	s4,s4,1352 # d90 <digits+0x40>
		readStatus = read_line(fd, line);
 850:	dd840593          	addi	a1,s0,-552
 854:	854a                	mv	a0,s2
 856:	00000097          	auipc	ra,0x0
 85a:	394080e7          	jalr	916(ra) # bea <read_line>
		if (readStatus == READ_ERROR){
 85e:	01350d63          	beq	a0,s3,878 <head_run+0x58>
		if (readStatus == READ_EOF)
 862:	c11d                	beqz	a0,888 <head_run+0x68>
		printf("%s",line);
 864:	dd840593          	addi	a1,s0,-552
 868:	8552                	mv	a0,s4
 86a:	00000097          	auipc	ra,0x0
 86e:	e18080e7          	jalr	-488(ra) # 682 <printf>
	while(numOfLines--){
 872:	34fd                	addiw	s1,s1,-1
 874:	fcf1                	bnez	s1,850 <head_run+0x30>
 876:	a809                	j	888 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 878:	00000517          	auipc	a0,0x0
 87c:	4f050513          	addi	a0,a0,1264 # d68 <digits+0x18>
 880:	00000097          	auipc	ra,0x0
 884:	e02080e7          	jalr	-510(ra) # 682 <printf>

	}
}
 888:	22813083          	ld	ra,552(sp)
 88c:	22013403          	ld	s0,544(sp)
 890:	21813483          	ld	s1,536(sp)
 894:	21013903          	ld	s2,528(sp)
 898:	20813983          	ld	s3,520(sp)
 89c:	20013a03          	ld	s4,512(sp)
 8a0:	23010113          	addi	sp,sp,560
 8a4:	8082                	ret
 8a6:	8082                	ret

00000000000008a8 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 8a8:	ba010113          	addi	sp,sp,-1120
 8ac:	44113c23          	sd	ra,1112(sp)
 8b0:	44813823          	sd	s0,1104(sp)
 8b4:	44913423          	sd	s1,1096(sp)
 8b8:	45213023          	sd	s2,1088(sp)
 8bc:	43313c23          	sd	s3,1080(sp)
 8c0:	43413823          	sd	s4,1072(sp)
 8c4:	43513423          	sd	s5,1064(sp)
 8c8:	43613023          	sd	s6,1056(sp)
 8cc:	41713c23          	sd	s7,1048(sp)
 8d0:	41813823          	sd	s8,1040(sp)
 8d4:	41913423          	sd	s9,1032(sp)
 8d8:	41a13023          	sd	s10,1024(sp)
 8dc:	3fb13c23          	sd	s11,1016(sp)
 8e0:	46010413          	addi	s0,sp,1120
 8e4:	89aa                	mv	s3,a0
 8e6:	8aae                	mv	s5,a1
 8e8:	8c32                	mv	s8,a2
 8ea:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 8ec:	d9840593          	addi	a1,s0,-616
 8f0:	00000097          	auipc	ra,0x0
 8f4:	2fa080e7          	jalr	762(ra) # bea <read_line>


  if (readStatus == READ_ERROR)
 8f8:	57fd                	li	a5,-1
 8fa:	04f50163          	beq	a0,a5,93c <uniq_run+0x94>
 8fe:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 900:	ed21                	bnez	a0,958 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 902:	45813083          	ld	ra,1112(sp)
 906:	45013403          	ld	s0,1104(sp)
 90a:	44813483          	ld	s1,1096(sp)
 90e:	44013903          	ld	s2,1088(sp)
 912:	43813983          	ld	s3,1080(sp)
 916:	43013a03          	ld	s4,1072(sp)
 91a:	42813a83          	ld	s5,1064(sp)
 91e:	42013b03          	ld	s6,1056(sp)
 922:	41813b83          	ld	s7,1048(sp)
 926:	41013c03          	ld	s8,1040(sp)
 92a:	40813c83          	ld	s9,1032(sp)
 92e:	40013d03          	ld	s10,1024(sp)
 932:	3f813d83          	ld	s11,1016(sp)
 936:	46010113          	addi	sp,sp,1120
 93a:	8082                	ret
    printf("[ERR] Error reading from the file ");
 93c:	00000517          	auipc	a0,0x0
 940:	45c50513          	addi	a0,a0,1116 # d98 <digits+0x48>
 944:	00000097          	auipc	ra,0x0
 948:	d3e080e7          	jalr	-706(ra) # 682 <printf>
 94c:	bf5d                	j	902 <uniq_run+0x5a>
 94e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 950:	8926                	mv	s2,s1
 952:	84be                	mv	s1,a5
        lineCount = 1;
 954:	8b6a                	mv	s6,s10
 956:	a8ed                	j	a50 <uniq_run+0x1a8>
    int lineCount=1;
 958:	4b05                	li	s6,1
  char * line2 = buffer2;
 95a:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 95e:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 962:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 964:	4d05                	li	s10,1
              printf("%s",line1);
 966:	00000d97          	auipc	s11,0x0
 96a:	42ad8d93          	addi	s11,s11,1066 # d90 <digits+0x40>
 96e:	a0cd                	j	a50 <uniq_run+0x1a8>
            if (repeatedLines){
 970:	020a0b63          	beqz	s4,9a6 <uniq_run+0xfe>
                if (isRepeated){
 974:	f80b87e3          	beqz	s7,902 <uniq_run+0x5a>
                    if (showCount)
 978:	000c0d63          	beqz	s8,992 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 97c:	864a                	mv	a2,s2
 97e:	85da                	mv	a1,s6
 980:	00000517          	auipc	a0,0x0
 984:	44050513          	addi	a0,a0,1088 # dc0 <digits+0x70>
 988:	00000097          	auipc	ra,0x0
 98c:	cfa080e7          	jalr	-774(ra) # 682 <printf>
 990:	bf8d                	j	902 <uniq_run+0x5a>
                      printf("%s",line1);
 992:	85ca                	mv	a1,s2
 994:	00000517          	auipc	a0,0x0
 998:	3fc50513          	addi	a0,a0,1020 # d90 <digits+0x40>
 99c:	00000097          	auipc	ra,0x0
 9a0:	ce6080e7          	jalr	-794(ra) # 682 <printf>
 9a4:	bfb9                	j	902 <uniq_run+0x5a>
                if (showCount)
 9a6:	000c0d63          	beqz	s8,9c0 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 9aa:	864a                	mv	a2,s2
 9ac:	85da                	mv	a1,s6
 9ae:	00000517          	auipc	a0,0x0
 9b2:	41250513          	addi	a0,a0,1042 # dc0 <digits+0x70>
 9b6:	00000097          	auipc	ra,0x0
 9ba:	ccc080e7          	jalr	-820(ra) # 682 <printf>
 9be:	b791                	j	902 <uniq_run+0x5a>
                  printf("%s",line1);
 9c0:	85ca                	mv	a1,s2
 9c2:	00000517          	auipc	a0,0x0
 9c6:	3ce50513          	addi	a0,a0,974 # d90 <digits+0x40>
 9ca:	00000097          	auipc	ra,0x0
 9ce:	cb8080e7          	jalr	-840(ra) # 682 <printf>
 9d2:	bf05                	j	902 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 9d4:	00000517          	auipc	a0,0x0
 9d8:	3f450513          	addi	a0,a0,1012 # dc8 <digits+0x78>
 9dc:	00000097          	auipc	ra,0x0
 9e0:	ca6080e7          	jalr	-858(ra) # 682 <printf>
          break;
 9e4:	bf39                	j	902 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 9e6:	85a6                	mv	a1,s1
 9e8:	854a                	mv	a0,s2
 9ea:	00000097          	auipc	ra,0x0
 9ee:	110080e7          	jalr	272(ra) # afa <compare_str_ic>
 9f2:	a041                	j	a72 <uniq_run+0x1ca>
                  printf("%s",line1);
 9f4:	85ca                	mv	a1,s2
 9f6:	856e                	mv	a0,s11
 9f8:	00000097          	auipc	ra,0x0
 9fc:	c8a080e7          	jalr	-886(ra) # 682 <printf>
        lineCount = 1;
 a00:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 a02:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a04:	8926                	mv	s2,s1
                  printf("%s",line1);
 a06:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a08:	4b81                	li	s7,0
 a0a:	a099                	j	a50 <uniq_run+0x1a8>
            if (showCount)
 a0c:	020c0263          	beqz	s8,a30 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 a10:	864a                	mv	a2,s2
 a12:	85da                	mv	a1,s6
 a14:	00000517          	auipc	a0,0x0
 a18:	3ac50513          	addi	a0,a0,940 # dc0 <digits+0x70>
 a1c:	00000097          	auipc	ra,0x0
 a20:	c66080e7          	jalr	-922(ra) # 682 <printf>
 a24:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a26:	8926                	mv	s2,s1
 a28:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a2a:	4b81                	li	s7,0
        lineCount = 1;
 a2c:	8b6a                	mv	s6,s10
 a2e:	a00d                	j	a50 <uniq_run+0x1a8>
              printf("%s",line1);
 a30:	85ca                	mv	a1,s2
 a32:	856e                	mv	a0,s11
 a34:	00000097          	auipc	ra,0x0
 a38:	c4e080e7          	jalr	-946(ra) # 682 <printf>
 a3c:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a3e:	8926                	mv	s2,s1
              printf("%s",line1);
 a40:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a42:	4b81                	li	s7,0
        lineCount = 1;
 a44:	8b6a                	mv	s6,s10
 a46:	a029                	j	a50 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 a48:	000a0363          	beqz	s4,a4e <uniq_run+0x1a6>
 a4c:	8bea                	mv	s7,s10
          lineCount++;
 a4e:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 a50:	85a6                	mv	a1,s1
 a52:	854e                	mv	a0,s3
 a54:	00000097          	auipc	ra,0x0
 a58:	196080e7          	jalr	406(ra) # bea <read_line>
        if (readStatus == READ_EOF){
 a5c:	d911                	beqz	a0,970 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 a5e:	f7950be3          	beq	a0,s9,9d4 <uniq_run+0x12c>
        if (!ignoreCase)
 a62:	f80a92e3          	bnez	s5,9e6 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 a66:	85a6                	mv	a1,s1
 a68:	854a                	mv	a0,s2
 a6a:	00000097          	auipc	ra,0x0
 a6e:	062080e7          	jalr	98(ra) # acc <compare_str>
        if (compareStatus != 0){ 
 a72:	d979                	beqz	a0,a48 <uniq_run+0x1a0>
          if (repeatedLines){
 a74:	f80a0ce3          	beqz	s4,a0c <uniq_run+0x164>
            if (isRepeated){
 a78:	ec0b8be3          	beqz	s7,94e <uniq_run+0xa6>
                if (showCount)
 a7c:	f60c0ce3          	beqz	s8,9f4 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 a80:	864a                	mv	a2,s2
 a82:	85da                	mv	a1,s6
 a84:	00000517          	auipc	a0,0x0
 a88:	33c50513          	addi	a0,a0,828 # dc0 <digits+0x70>
 a8c:	00000097          	auipc	ra,0x0
 a90:	bf6080e7          	jalr	-1034(ra) # 682 <printf>
        lineCount = 1;
 a94:	8b5e                	mv	s6,s7
 a96:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a98:	8926                	mv	s2,s1
 a9a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a9c:	4b81                	li	s7,0
 a9e:	bf4d                	j	a50 <uniq_run+0x1a8>

0000000000000aa0 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 aa0:	1141                	addi	sp,sp,-16
 aa2:	e422                	sd	s0,8(sp)
 aa4:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 aa6:	00054783          	lbu	a5,0(a0)
 aaa:	cf99                	beqz	a5,ac8 <get_strlen+0x28>
 aac:	00150713          	addi	a4,a0,1
 ab0:	87ba                	mv	a5,a4
 ab2:	4685                	li	a3,1
 ab4:	9e99                	subw	a3,a3,a4
 ab6:	00f6853b          	addw	a0,a3,a5
 aba:	0785                	addi	a5,a5,1
 abc:	fff7c703          	lbu	a4,-1(a5)
 ac0:	fb7d                	bnez	a4,ab6 <get_strlen+0x16>
	return len;
}
 ac2:	6422                	ld	s0,8(sp)
 ac4:	0141                	addi	sp,sp,16
 ac6:	8082                	ret
	int len = 0;
 ac8:	4501                	li	a0,0
 aca:	bfe5                	j	ac2 <get_strlen+0x22>

0000000000000acc <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 acc:	1141                	addi	sp,sp,-16
 ace:	e422                	sd	s0,8(sp)
 ad0:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 ad2:	00054783          	lbu	a5,0(a0)
 ad6:	cb91                	beqz	a5,aea <compare_str+0x1e>
 ad8:	0005c703          	lbu	a4,0(a1)
 adc:	c719                	beqz	a4,aea <compare_str+0x1e>
		if (*s1++ != *s2++)
 ade:	0505                	addi	a0,a0,1
 ae0:	0585                	addi	a1,a1,1
 ae2:	fee788e3          	beq	a5,a4,ad2 <compare_str+0x6>
			return 1;
 ae6:	4505                	li	a0,1
 ae8:	a031                	j	af4 <compare_str+0x28>
	}
	if (*s1 == *s2)
 aea:	0005c503          	lbu	a0,0(a1)
 aee:	8d1d                	sub	a0,a0,a5
			return 1;
 af0:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 af4:	6422                	ld	s0,8(sp)
 af6:	0141                	addi	sp,sp,16
 af8:	8082                	ret

0000000000000afa <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 afa:	1141                	addi	sp,sp,-16
 afc:	e422                	sd	s0,8(sp)
 afe:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b00:	4665                	li	a2,25
	while(*s1 && *s2){
 b02:	a019                	j	b08 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b04:	04e79763          	bne	a5,a4,b52 <compare_str_ic+0x58>
	while(*s1 && *s2){
 b08:	00054783          	lbu	a5,0(a0)
 b0c:	cb9d                	beqz	a5,b42 <compare_str_ic+0x48>
 b0e:	0005c703          	lbu	a4,0(a1)
 b12:	cb05                	beqz	a4,b42 <compare_str_ic+0x48>
		char b1 = *s1++;
 b14:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 b16:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b18:	fbf7869b          	addiw	a3,a5,-65
 b1c:	0ff6f693          	zext.b	a3,a3
 b20:	00d66663          	bltu	a2,a3,b2c <compare_str_ic+0x32>
			b1 += 32;
 b24:	0207879b          	addiw	a5,a5,32
 b28:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 b2c:	fbf7069b          	addiw	a3,a4,-65
 b30:	0ff6f693          	zext.b	a3,a3
 b34:	fcd668e3          	bltu	a2,a3,b04 <compare_str_ic+0xa>
			b2 += 32;
 b38:	0207071b          	addiw	a4,a4,32
 b3c:	0ff77713          	zext.b	a4,a4
 b40:	b7d1                	j	b04 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 b42:	0005c503          	lbu	a0,0(a1)
 b46:	8d1d                	sub	a0,a0,a5
			return 1;
 b48:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b4c:	6422                	ld	s0,8(sp)
 b4e:	0141                	addi	sp,sp,16
 b50:	8082                	ret
			return 1;
 b52:	4505                	li	a0,1
 b54:	bfe5                	j	b4c <compare_str_ic+0x52>

0000000000000b56 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 b56:	7179                	addi	sp,sp,-48
 b58:	f406                	sd	ra,40(sp)
 b5a:	f022                	sd	s0,32(sp)
 b5c:	ec26                	sd	s1,24(sp)
 b5e:	e84a                	sd	s2,16(sp)
 b60:	e44e                	sd	s3,8(sp)
 b62:	1800                	addi	s0,sp,48
 b64:	89aa                	mv	s3,a0
 b66:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 b68:	00000097          	auipc	ra,0x0
 b6c:	f38080e7          	jalr	-200(ra) # aa0 <get_strlen>
 b70:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 b72:	854a                	mv	a0,s2
 b74:	00000097          	auipc	ra,0x0
 b78:	f2c080e7          	jalr	-212(ra) # aa0 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 b7c:	409505bb          	subw	a1,a0,s1
 b80:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 b82:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 b84:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 b86:	0005da63          	bgez	a1,b9a <check_substr+0x44>
 b8a:	a81d                	j	bc0 <check_substr+0x6a>
        if (j == M)
 b8c:	02f48a63          	beq	s1,a5,bc0 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 b90:	0885                	addi	a7,a7,1
 b92:	0008879b          	sext.w	a5,a7
 b96:	02f5cc63          	blt	a1,a5,bce <check_substr+0x78>
 b9a:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 b9e:	011906b3          	add	a3,s2,a7
 ba2:	874e                	mv	a4,s3
 ba4:	879a                	mv	a5,t1
 ba6:	fe9053e3          	blez	s1,b8c <check_substr+0x36>
            if (s2[i + j] != s1[j])
 baa:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 bae:	00074603          	lbu	a2,0(a4)
 bb2:	fcc81de3          	bne	a6,a2,b8c <check_substr+0x36>
        for (j = 0; j < M; j++)
 bb6:	2785                	addiw	a5,a5,1
 bb8:	0685                	addi	a3,a3,1
 bba:	0705                	addi	a4,a4,1
 bbc:	fef497e3          	bne	s1,a5,baa <check_substr+0x54>
}
 bc0:	70a2                	ld	ra,40(sp)
 bc2:	7402                	ld	s0,32(sp)
 bc4:	64e2                	ld	s1,24(sp)
 bc6:	6942                	ld	s2,16(sp)
 bc8:	69a2                	ld	s3,8(sp)
 bca:	6145                	addi	sp,sp,48
 bcc:	8082                	ret
    return -1;
 bce:	557d                	li	a0,-1
 bd0:	bfc5                	j	bc0 <check_substr+0x6a>

0000000000000bd2 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 bd2:	1141                	addi	sp,sp,-16
 bd4:	e406                	sd	ra,8(sp)
 bd6:	e022                	sd	s0,0(sp)
 bd8:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 bda:	fffff097          	auipc	ra,0xfffff
 bde:	746080e7          	jalr	1862(ra) # 320 <open>
	return fd;
}
 be2:	60a2                	ld	ra,8(sp)
 be4:	6402                	ld	s0,0(sp)
 be6:	0141                	addi	sp,sp,16
 be8:	8082                	ret

0000000000000bea <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 bea:	7139                	addi	sp,sp,-64
 bec:	fc06                	sd	ra,56(sp)
 bee:	f822                	sd	s0,48(sp)
 bf0:	f426                	sd	s1,40(sp)
 bf2:	f04a                	sd	s2,32(sp)
 bf4:	ec4e                	sd	s3,24(sp)
 bf6:	e852                	sd	s4,16(sp)
 bf8:	0080                	addi	s0,sp,64
 bfa:	89aa                	mv	s3,a0
 bfc:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 bfe:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 c00:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c02:	4605                	li	a2,1
 c04:	fcf40593          	addi	a1,s0,-49
 c08:	854e                	mv	a0,s3
 c0a:	fffff097          	auipc	ra,0xfffff
 c0e:	6ee080e7          	jalr	1774(ra) # 2f8 <read>
		if (readStatus == 0){
 c12:	c505                	beqz	a0,c3a <read_line+0x50>
		*buffer++ = readByte;
 c14:	0485                	addi	s1,s1,1
 c16:	fcf44783          	lbu	a5,-49(s0)
 c1a:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c1e:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c20:	ff4791e3          	bne	a5,s4,c02 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c24:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 c28:	854a                	mv	a0,s2
 c2a:	70e2                	ld	ra,56(sp)
 c2c:	7442                	ld	s0,48(sp)
 c2e:	74a2                	ld	s1,40(sp)
 c30:	7902                	ld	s2,32(sp)
 c32:	69e2                	ld	s3,24(sp)
 c34:	6a42                	ld	s4,16(sp)
 c36:	6121                	addi	sp,sp,64
 c38:	8082                	ret
			if (byteCount!=0){
 c3a:	fe0907e3          	beqz	s2,c28 <read_line+0x3e>
				*buffer = '\n';
 c3e:	47a9                	li	a5,10
 c40:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 c44:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 c48:	2905                	addiw	s2,s2,1
 c4a:	bff9                	j	c28 <read_line+0x3e>

0000000000000c4c <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c4c:	1141                	addi	sp,sp,-16
 c4e:	e406                	sd	ra,8(sp)
 c50:	e022                	sd	s0,0(sp)
 c52:	0800                	addi	s0,sp,16
	close(fd);
 c54:	fffff097          	auipc	ra,0xfffff
 c58:	6b4080e7          	jalr	1716(ra) # 308 <close>
}
 c5c:	60a2                	ld	ra,8(sp)
 c5e:	6402                	ld	s0,0(sp)
 c60:	0141                	addi	sp,sp,16
 c62:	8082                	ret

0000000000000c64 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 c64:	7139                	addi	sp,sp,-64
 c66:	fc06                	sd	ra,56(sp)
 c68:	f822                	sd	s0,48(sp)
 c6a:	f426                	sd	s1,40(sp)
 c6c:	f04a                	sd	s2,32(sp)
 c6e:	0080                	addi	s0,sp,64
 c70:	84aa                	mv	s1,a0
 c72:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 c74:	fffff097          	auipc	ra,0xfffff
 c78:	664080e7          	jalr	1636(ra) # 2d8 <fork>
 c7c:	ed19                	bnez	a0,c9a <get_time_perf+0x36>
		exec(argv[0],argv);
 c7e:	85ca                	mv	a1,s2
 c80:	00093503          	ld	a0,0(s2)
 c84:	fffff097          	auipc	ra,0xfffff
 c88:	694080e7          	jalr	1684(ra) # 318 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 c8c:	8526                	mv	a0,s1
 c8e:	70e2                	ld	ra,56(sp)
 c90:	7442                	ld	s0,48(sp)
 c92:	74a2                	ld	s1,40(sp)
 c94:	7902                	ld	s2,32(sp)
 c96:	6121                	addi	sp,sp,64
 c98:	8082                	ret
		times(pid , &time);
 c9a:	fc840593          	addi	a1,s0,-56
 c9e:	fffff097          	auipc	ra,0xfffff
 ca2:	6fa080e7          	jalr	1786(ra) # 398 <times>
		return time;
 ca6:	fc843783          	ld	a5,-56(s0)
 caa:	e09c                	sd	a5,0(s1)
 cac:	fd043783          	ld	a5,-48(s0)
 cb0:	e49c                	sd	a5,8(s1)
 cb2:	fd843783          	ld	a5,-40(s0)
 cb6:	e89c                	sd	a5,16(s1)
 cb8:	bfd1                	j	c8c <get_time_perf+0x28>
