
user/_t1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <delay>:
#include "kernel/elibs/flags.h"
#include "kernel/elibs/sched.h"
#include "gelibs/string.h"


void delay(){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
	time_t f ;
	gettime(&f);
   a:	fd840513          	addi	a0,s0,-40
   e:	00000097          	auipc	ra,0x0
  12:	3b6080e7          	jalr	950(ra) # 3c4 <gettime>
	time_t l=f;
  16:	fd843783          	ld	a5,-40(s0)
  1a:	fcf43823          	sd	a5,-48(s0)
	while(l-f<5){
  1e:	4491                	li	s1,4
		gettime(&l);
  20:	fd040513          	addi	a0,s0,-48
  24:	00000097          	auipc	ra,0x0
  28:	3a0080e7          	jalr	928(ra) # 3c4 <gettime>
	while(l-f<5){
  2c:	fd043783          	ld	a5,-48(s0)
  30:	fd843703          	ld	a4,-40(s0)
  34:	8f99                	sub	a5,a5,a4
  36:	fef4f5e3          	bgeu	s1,a5,20 <delay+0x20>
	};
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6145                	addi	sp,sp,48
  42:	8082                	ret

0000000000000044 <main>:


int main(){
  44:	7179                	addi	sp,sp,-48
  46:	f406                	sd	ra,40(sp)
  48:	f022                	sd	s0,32(sp)
  4a:	ec26                	sd	s1,24(sp)
  4c:	e84a                	sd	s2,16(sp)
  4e:	e44e                	sd	s3,8(sp)
  50:	1800                	addi	s0,sp,48
	for (int i=0;i<10;i++){
  52:	4481                	li	s1,0
		printf("T1: %d\n",i);
  54:	00001997          	auipc	s3,0x1
  58:	cac98993          	addi	s3,s3,-852 # d00 <get_time_perf+0x60>
	for (int i=0;i<10;i++){
  5c:	4929                	li	s2,10
		printf("T1: %d\n",i);
  5e:	85a6                	mv	a1,s1
  60:	854e                	mv	a0,s3
  62:	00000097          	auipc	ra,0x0
  66:	65c080e7          	jalr	1628(ra) # 6be <printf>
	for (int i=0;i<10;i++){
  6a:	2485                	addiw	s1,s1,1
  6c:	ff2499e3          	bne	s1,s2,5e <main+0x1a>
		// delay();
	}
}
  70:	70a2                	ld	ra,40(sp)
  72:	7402                	ld	s0,32(sp)
  74:	64e2                	ld	s1,24(sp)
  76:	6942                	ld	s2,16(sp)
  78:	69a2                	ld	s3,8(sp)
  7a:	6145                	addi	sp,sp,48
  7c:	8082                	ret

000000000000007e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  extern int main();
  main();
  86:	00000097          	auipc	ra,0x0
  8a:	fbe080e7          	jalr	-66(ra) # 44 <main>
  exit(0);
  8e:	4501                	li	a0,0
  90:	00000097          	auipc	ra,0x0
  94:	274080e7          	jalr	628(ra) # 304 <exit>

0000000000000098 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  98:	1141                	addi	sp,sp,-16
  9a:	e422                	sd	s0,8(sp)
  9c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9e:	87aa                	mv	a5,a0
  a0:	0585                	addi	a1,a1,1
  a2:	0785                	addi	a5,a5,1
  a4:	fff5c703          	lbu	a4,-1(a1)
  a8:	fee78fa3          	sb	a4,-1(a5)
  ac:	fb75                	bnez	a4,a0 <strcpy+0x8>
    ;
  return os;
}
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ba:	00054783          	lbu	a5,0(a0)
  be:	cb91                	beqz	a5,d2 <strcmp+0x1e>
  c0:	0005c703          	lbu	a4,0(a1)
  c4:	00f71763          	bne	a4,a5,d2 <strcmp+0x1e>
    p++, q++;
  c8:	0505                	addi	a0,a0,1
  ca:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	fbe5                	bnez	a5,c0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d2:	0005c503          	lbu	a0,0(a1)
}
  d6:	40a7853b          	subw	a0,a5,a0
  da:	6422                	ld	s0,8(sp)
  dc:	0141                	addi	sp,sp,16
  de:	8082                	ret

00000000000000e0 <strlen>:

uint
strlen(const char *s)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e422                	sd	s0,8(sp)
  e4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e6:	00054783          	lbu	a5,0(a0)
  ea:	cf91                	beqz	a5,106 <strlen+0x26>
  ec:	0505                	addi	a0,a0,1
  ee:	87aa                	mv	a5,a0
  f0:	4685                	li	a3,1
  f2:	9e89                	subw	a3,a3,a0
  f4:	00f6853b          	addw	a0,a3,a5
  f8:	0785                	addi	a5,a5,1
  fa:	fff7c703          	lbu	a4,-1(a5)
  fe:	fb7d                	bnez	a4,f4 <strlen+0x14>
    ;
  return n;
}
 100:	6422                	ld	s0,8(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret
  for(n = 0; s[n]; n++)
 106:	4501                	li	a0,0
 108:	bfe5                	j	100 <strlen+0x20>

000000000000010a <memset>:

void*
memset(void *dst, int c, uint n)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e422                	sd	s0,8(sp)
 10e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 110:	ca19                	beqz	a2,126 <memset+0x1c>
 112:	87aa                	mv	a5,a0
 114:	1602                	slli	a2,a2,0x20
 116:	9201                	srli	a2,a2,0x20
 118:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 120:	0785                	addi	a5,a5,1
 122:	fee79de3          	bne	a5,a4,11c <memset+0x12>
  }
  return dst;
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strchr>:

char*
strchr(const char *s, char c)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e422                	sd	s0,8(sp)
 130:	0800                	addi	s0,sp,16
  for(; *s; s++)
 132:	00054783          	lbu	a5,0(a0)
 136:	cb99                	beqz	a5,14c <strchr+0x20>
    if(*s == c)
 138:	00f58763          	beq	a1,a5,146 <strchr+0x1a>
  for(; *s; s++)
 13c:	0505                	addi	a0,a0,1
 13e:	00054783          	lbu	a5,0(a0)
 142:	fbfd                	bnez	a5,138 <strchr+0xc>
      return (char*)s;
  return 0;
 144:	4501                	li	a0,0
}
 146:	6422                	ld	s0,8(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret
  return 0;
 14c:	4501                	li	a0,0
 14e:	bfe5                	j	146 <strchr+0x1a>

0000000000000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	711d                	addi	sp,sp,-96
 152:	ec86                	sd	ra,88(sp)
 154:	e8a2                	sd	s0,80(sp)
 156:	e4a6                	sd	s1,72(sp)
 158:	e0ca                	sd	s2,64(sp)
 15a:	fc4e                	sd	s3,56(sp)
 15c:	f852                	sd	s4,48(sp)
 15e:	f456                	sd	s5,40(sp)
 160:	f05a                	sd	s6,32(sp)
 162:	ec5e                	sd	s7,24(sp)
 164:	1080                	addi	s0,sp,96
 166:	8baa                	mv	s7,a0
 168:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16a:	892a                	mv	s2,a0
 16c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16e:	4aa9                	li	s5,10
 170:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 172:	89a6                	mv	s3,s1
 174:	2485                	addiw	s1,s1,1
 176:	0344d863          	bge	s1,s4,1a6 <gets+0x56>
    cc = read(0, &c, 1);
 17a:	4605                	li	a2,1
 17c:	faf40593          	addi	a1,s0,-81
 180:	4501                	li	a0,0
 182:	00000097          	auipc	ra,0x0
 186:	19a080e7          	jalr	410(ra) # 31c <read>
    if(cc < 1)
 18a:	00a05e63          	blez	a0,1a6 <gets+0x56>
    buf[i++] = c;
 18e:	faf44783          	lbu	a5,-81(s0)
 192:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 196:	01578763          	beq	a5,s5,1a4 <gets+0x54>
 19a:	0905                	addi	s2,s2,1
 19c:	fd679be3          	bne	a5,s6,172 <gets+0x22>
  for(i=0; i+1 < max; ){
 1a0:	89a6                	mv	s3,s1
 1a2:	a011                	j	1a6 <gets+0x56>
 1a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a6:	99de                	add	s3,s3,s7
 1a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ac:	855e                	mv	a0,s7
 1ae:	60e6                	ld	ra,88(sp)
 1b0:	6446                	ld	s0,80(sp)
 1b2:	64a6                	ld	s1,72(sp)
 1b4:	6906                	ld	s2,64(sp)
 1b6:	79e2                	ld	s3,56(sp)
 1b8:	7a42                	ld	s4,48(sp)
 1ba:	7aa2                	ld	s5,40(sp)
 1bc:	7b02                	ld	s6,32(sp)
 1be:	6be2                	ld	s7,24(sp)
 1c0:	6125                	addi	sp,sp,96
 1c2:	8082                	ret

00000000000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e426                	sd	s1,8(sp)
 1cc:	e04a                	sd	s2,0(sp)
 1ce:	1000                	addi	s0,sp,32
 1d0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d2:	4581                	li	a1,0
 1d4:	00000097          	auipc	ra,0x0
 1d8:	170080e7          	jalr	368(ra) # 344 <open>
  if(fd < 0)
 1dc:	02054563          	bltz	a0,206 <stat+0x42>
 1e0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e2:	85ca                	mv	a1,s2
 1e4:	00000097          	auipc	ra,0x0
 1e8:	178080e7          	jalr	376(ra) # 35c <fstat>
 1ec:	892a                	mv	s2,a0
  close(fd);
 1ee:	8526                	mv	a0,s1
 1f0:	00000097          	auipc	ra,0x0
 1f4:	13c080e7          	jalr	316(ra) # 32c <close>
  return r;
}
 1f8:	854a                	mv	a0,s2
 1fa:	60e2                	ld	ra,24(sp)
 1fc:	6442                	ld	s0,16(sp)
 1fe:	64a2                	ld	s1,8(sp)
 200:	6902                	ld	s2,0(sp)
 202:	6105                	addi	sp,sp,32
 204:	8082                	ret
    return -1;
 206:	597d                	li	s2,-1
 208:	bfc5                	j	1f8 <stat+0x34>

000000000000020a <atoi>:

int
atoi(const char *s)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 210:	00054683          	lbu	a3,0(a0)
 214:	fd06879b          	addiw	a5,a3,-48
 218:	0ff7f793          	zext.b	a5,a5
 21c:	4625                	li	a2,9
 21e:	02f66863          	bltu	a2,a5,24e <atoi+0x44>
 222:	872a                	mv	a4,a0
  n = 0;
 224:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 226:	0705                	addi	a4,a4,1
 228:	0025179b          	slliw	a5,a0,0x2
 22c:	9fa9                	addw	a5,a5,a0
 22e:	0017979b          	slliw	a5,a5,0x1
 232:	9fb5                	addw	a5,a5,a3
 234:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 238:	00074683          	lbu	a3,0(a4)
 23c:	fd06879b          	addiw	a5,a3,-48
 240:	0ff7f793          	zext.b	a5,a5
 244:	fef671e3          	bgeu	a2,a5,226 <atoi+0x1c>
  return n;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  n = 0;
 24e:	4501                	li	a0,0
 250:	bfe5                	j	248 <atoi+0x3e>

0000000000000252 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 258:	02b57463          	bgeu	a0,a1,280 <memmove+0x2e>
    while(n-- > 0)
 25c:	00c05f63          	blez	a2,27a <memmove+0x28>
 260:	1602                	slli	a2,a2,0x20
 262:	9201                	srli	a2,a2,0x20
 264:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 268:	872a                	mv	a4,a0
      *dst++ = *src++;
 26a:	0585                	addi	a1,a1,1
 26c:	0705                	addi	a4,a4,1
 26e:	fff5c683          	lbu	a3,-1(a1)
 272:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 276:	fee79ae3          	bne	a5,a4,26a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27a:	6422                	ld	s0,8(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
    dst += n;
 280:	00c50733          	add	a4,a0,a2
    src += n;
 284:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 286:	fec05ae3          	blez	a2,27a <memmove+0x28>
 28a:	fff6079b          	addiw	a5,a2,-1
 28e:	1782                	slli	a5,a5,0x20
 290:	9381                	srli	a5,a5,0x20
 292:	fff7c793          	not	a5,a5
 296:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 298:	15fd                	addi	a1,a1,-1
 29a:	177d                	addi	a4,a4,-1
 29c:	0005c683          	lbu	a3,0(a1)
 2a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a4:	fee79ae3          	bne	a5,a4,298 <memmove+0x46>
 2a8:	bfc9                	j	27a <memmove+0x28>

00000000000002aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b0:	ca05                	beqz	a2,2e0 <memcmp+0x36>
 2b2:	fff6069b          	addiw	a3,a2,-1
 2b6:	1682                	slli	a3,a3,0x20
 2b8:	9281                	srli	a3,a3,0x20
 2ba:	0685                	addi	a3,a3,1
 2bc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	0005c703          	lbu	a4,0(a1)
 2c6:	00e79863          	bne	a5,a4,2d6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ca:	0505                	addi	a0,a0,1
    p2++;
 2cc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ce:	fed518e3          	bne	a0,a3,2be <memcmp+0x14>
  }
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	a019                	j	2da <memcmp+0x30>
      return *p1 - *p2;
 2d6:	40e7853b          	subw	a0,a5,a4
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  return 0;
 2e0:	4501                	li	a0,0
 2e2:	bfe5                	j	2da <memcmp+0x30>

00000000000002e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e406                	sd	ra,8(sp)
 2e8:	e022                	sd	s0,0(sp)
 2ea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ec:	00000097          	auipc	ra,0x0
 2f0:	f66080e7          	jalr	-154(ra) # 252 <memmove>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <head>:
.global head
head:
 li a7, SYS_head
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 3ac:	48dd                	li	a7,23
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <ps>:
.global ps
ps:
 li a7, SYS_ps
 3b4:	48e1                	li	a7,24
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <times>:
.global times
times:
 li a7, SYS_times
 3bc:	48e5                	li	a7,25
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 3c4:	48e9                	li	a7,26
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 3cc:	48ed                	li	a7,27
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 3d4:	48f1                	li	a7,28
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 3dc:	48f5                	li	a7,29
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e4:	1101                	addi	sp,sp,-32
 3e6:	ec06                	sd	ra,24(sp)
 3e8:	e822                	sd	s0,16(sp)
 3ea:	1000                	addi	s0,sp,32
 3ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f0:	4605                	li	a2,1
 3f2:	fef40593          	addi	a1,s0,-17
 3f6:	00000097          	auipc	ra,0x0
 3fa:	f2e080e7          	jalr	-210(ra) # 324 <write>
}
 3fe:	60e2                	ld	ra,24(sp)
 400:	6442                	ld	s0,16(sp)
 402:	6105                	addi	sp,sp,32
 404:	8082                	ret

0000000000000406 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 406:	7139                	addi	sp,sp,-64
 408:	fc06                	sd	ra,56(sp)
 40a:	f822                	sd	s0,48(sp)
 40c:	f426                	sd	s1,40(sp)
 40e:	f04a                	sd	s2,32(sp)
 410:	ec4e                	sd	s3,24(sp)
 412:	0080                	addi	s0,sp,64
 414:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 416:	c299                	beqz	a3,41c <printint+0x16>
 418:	0805c963          	bltz	a1,4aa <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 41c:	2581                	sext.w	a1,a1
  neg = 0;
 41e:	4881                	li	a7,0
 420:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 424:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 426:	2601                	sext.w	a2,a2
 428:	00001517          	auipc	a0,0x1
 42c:	94050513          	addi	a0,a0,-1728 # d68 <digits>
 430:	883a                	mv	a6,a4
 432:	2705                	addiw	a4,a4,1
 434:	02c5f7bb          	remuw	a5,a1,a2
 438:	1782                	slli	a5,a5,0x20
 43a:	9381                	srli	a5,a5,0x20
 43c:	97aa                	add	a5,a5,a0
 43e:	0007c783          	lbu	a5,0(a5)
 442:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 446:	0005879b          	sext.w	a5,a1
 44a:	02c5d5bb          	divuw	a1,a1,a2
 44e:	0685                	addi	a3,a3,1
 450:	fec7f0e3          	bgeu	a5,a2,430 <printint+0x2a>
  if(neg)
 454:	00088c63          	beqz	a7,46c <printint+0x66>
    buf[i++] = '-';
 458:	fd070793          	addi	a5,a4,-48
 45c:	00878733          	add	a4,a5,s0
 460:	02d00793          	li	a5,45
 464:	fef70823          	sb	a5,-16(a4)
 468:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 46c:	02e05863          	blez	a4,49c <printint+0x96>
 470:	fc040793          	addi	a5,s0,-64
 474:	00e78933          	add	s2,a5,a4
 478:	fff78993          	addi	s3,a5,-1
 47c:	99ba                	add	s3,s3,a4
 47e:	377d                	addiw	a4,a4,-1
 480:	1702                	slli	a4,a4,0x20
 482:	9301                	srli	a4,a4,0x20
 484:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 488:	fff94583          	lbu	a1,-1(s2)
 48c:	8526                	mv	a0,s1
 48e:	00000097          	auipc	ra,0x0
 492:	f56080e7          	jalr	-170(ra) # 3e4 <putc>
  while(--i >= 0)
 496:	197d                	addi	s2,s2,-1
 498:	ff3918e3          	bne	s2,s3,488 <printint+0x82>
}
 49c:	70e2                	ld	ra,56(sp)
 49e:	7442                	ld	s0,48(sp)
 4a0:	74a2                	ld	s1,40(sp)
 4a2:	7902                	ld	s2,32(sp)
 4a4:	69e2                	ld	s3,24(sp)
 4a6:	6121                	addi	sp,sp,64
 4a8:	8082                	ret
    x = -xx;
 4aa:	40b005bb          	negw	a1,a1
    neg = 1;
 4ae:	4885                	li	a7,1
    x = -xx;
 4b0:	bf85                	j	420 <printint+0x1a>

00000000000004b2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b2:	7119                	addi	sp,sp,-128
 4b4:	fc86                	sd	ra,120(sp)
 4b6:	f8a2                	sd	s0,112(sp)
 4b8:	f4a6                	sd	s1,104(sp)
 4ba:	f0ca                	sd	s2,96(sp)
 4bc:	ecce                	sd	s3,88(sp)
 4be:	e8d2                	sd	s4,80(sp)
 4c0:	e4d6                	sd	s5,72(sp)
 4c2:	e0da                	sd	s6,64(sp)
 4c4:	fc5e                	sd	s7,56(sp)
 4c6:	f862                	sd	s8,48(sp)
 4c8:	f466                	sd	s9,40(sp)
 4ca:	f06a                	sd	s10,32(sp)
 4cc:	ec6e                	sd	s11,24(sp)
 4ce:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d0:	0005c903          	lbu	s2,0(a1)
 4d4:	18090f63          	beqz	s2,672 <vprintf+0x1c0>
 4d8:	8aaa                	mv	s5,a0
 4da:	8b32                	mv	s6,a2
 4dc:	00158493          	addi	s1,a1,1
  state = 0;
 4e0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e2:	02500a13          	li	s4,37
 4e6:	4c55                	li	s8,21
 4e8:	00001c97          	auipc	s9,0x1
 4ec:	828c8c93          	addi	s9,s9,-2008 # d10 <get_time_perf+0x70>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4f0:	02800d93          	li	s11,40
  putc(fd, 'x');
 4f4:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4f6:	00001b97          	auipc	s7,0x1
 4fa:	872b8b93          	addi	s7,s7,-1934 # d68 <digits>
 4fe:	a839                	j	51c <vprintf+0x6a>
        putc(fd, c);
 500:	85ca                	mv	a1,s2
 502:	8556                	mv	a0,s5
 504:	00000097          	auipc	ra,0x0
 508:	ee0080e7          	jalr	-288(ra) # 3e4 <putc>
 50c:	a019                	j	512 <vprintf+0x60>
    } else if(state == '%'){
 50e:	01498d63          	beq	s3,s4,528 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 512:	0485                	addi	s1,s1,1
 514:	fff4c903          	lbu	s2,-1(s1)
 518:	14090d63          	beqz	s2,672 <vprintf+0x1c0>
    if(state == 0){
 51c:	fe0999e3          	bnez	s3,50e <vprintf+0x5c>
      if(c == '%'){
 520:	ff4910e3          	bne	s2,s4,500 <vprintf+0x4e>
        state = '%';
 524:	89d2                	mv	s3,s4
 526:	b7f5                	j	512 <vprintf+0x60>
      if(c == 'd'){
 528:	11490c63          	beq	s2,s4,640 <vprintf+0x18e>
 52c:	f9d9079b          	addiw	a5,s2,-99
 530:	0ff7f793          	zext.b	a5,a5
 534:	10fc6e63          	bltu	s8,a5,650 <vprintf+0x19e>
 538:	f9d9079b          	addiw	a5,s2,-99
 53c:	0ff7f713          	zext.b	a4,a5
 540:	10ec6863          	bltu	s8,a4,650 <vprintf+0x19e>
 544:	00271793          	slli	a5,a4,0x2
 548:	97e6                	add	a5,a5,s9
 54a:	439c                	lw	a5,0(a5)
 54c:	97e6                	add	a5,a5,s9
 54e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 550:	008b0913          	addi	s2,s6,8
 554:	4685                	li	a3,1
 556:	4629                	li	a2,10
 558:	000b2583          	lw	a1,0(s6)
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	ea8080e7          	jalr	-344(ra) # 406 <printint>
 566:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 568:	4981                	li	s3,0
 56a:	b765                	j	512 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56c:	008b0913          	addi	s2,s6,8
 570:	4681                	li	a3,0
 572:	4629                	li	a2,10
 574:	000b2583          	lw	a1,0(s6)
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e8c080e7          	jalr	-372(ra) # 406 <printint>
 582:	8b4a                	mv	s6,s2
      state = 0;
 584:	4981                	li	s3,0
 586:	b771                	j	512 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 588:	008b0913          	addi	s2,s6,8
 58c:	4681                	li	a3,0
 58e:	866a                	mv	a2,s10
 590:	000b2583          	lw	a1,0(s6)
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	e70080e7          	jalr	-400(ra) # 406 <printint>
 59e:	8b4a                	mv	s6,s2
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	bf85                	j	512 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5a4:	008b0793          	addi	a5,s6,8
 5a8:	f8f43423          	sd	a5,-120(s0)
 5ac:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5b0:	03000593          	li	a1,48
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e2e080e7          	jalr	-466(ra) # 3e4 <putc>
  putc(fd, 'x');
 5be:	07800593          	li	a1,120
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	e20080e7          	jalr	-480(ra) # 3e4 <putc>
 5cc:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ce:	03c9d793          	srli	a5,s3,0x3c
 5d2:	97de                	add	a5,a5,s7
 5d4:	0007c583          	lbu	a1,0(a5)
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	e0a080e7          	jalr	-502(ra) # 3e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e2:	0992                	slli	s3,s3,0x4
 5e4:	397d                	addiw	s2,s2,-1
 5e6:	fe0914e3          	bnez	s2,5ce <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5ea:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	b70d                	j	512 <vprintf+0x60>
        s = va_arg(ap, char*);
 5f2:	008b0913          	addi	s2,s6,8
 5f6:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5fa:	02098163          	beqz	s3,61c <vprintf+0x16a>
        while(*s != 0){
 5fe:	0009c583          	lbu	a1,0(s3)
 602:	c5ad                	beqz	a1,66c <vprintf+0x1ba>
          putc(fd, *s);
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	dde080e7          	jalr	-546(ra) # 3e4 <putc>
          s++;
 60e:	0985                	addi	s3,s3,1
        while(*s != 0){
 610:	0009c583          	lbu	a1,0(s3)
 614:	f9e5                	bnez	a1,604 <vprintf+0x152>
        s = va_arg(ap, char*);
 616:	8b4a                	mv	s6,s2
      state = 0;
 618:	4981                	li	s3,0
 61a:	bde5                	j	512 <vprintf+0x60>
          s = "(null)";
 61c:	00000997          	auipc	s3,0x0
 620:	6ec98993          	addi	s3,s3,1772 # d08 <get_time_perf+0x68>
        while(*s != 0){
 624:	85ee                	mv	a1,s11
 626:	bff9                	j	604 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 628:	008b0913          	addi	s2,s6,8
 62c:	000b4583          	lbu	a1,0(s6)
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	db2080e7          	jalr	-590(ra) # 3e4 <putc>
 63a:	8b4a                	mv	s6,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bdd1                	j	512 <vprintf+0x60>
        putc(fd, c);
 640:	85d2                	mv	a1,s4
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	da0080e7          	jalr	-608(ra) # 3e4 <putc>
      state = 0;
 64c:	4981                	li	s3,0
 64e:	b5d1                	j	512 <vprintf+0x60>
        putc(fd, '%');
 650:	85d2                	mv	a1,s4
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	d90080e7          	jalr	-624(ra) # 3e4 <putc>
        putc(fd, c);
 65c:	85ca                	mv	a1,s2
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	d84080e7          	jalr	-636(ra) # 3e4 <putc>
      state = 0;
 668:	4981                	li	s3,0
 66a:	b565                	j	512 <vprintf+0x60>
        s = va_arg(ap, char*);
 66c:	8b4a                	mv	s6,s2
      state = 0;
 66e:	4981                	li	s3,0
 670:	b54d                	j	512 <vprintf+0x60>
    }
  }
}
 672:	70e6                	ld	ra,120(sp)
 674:	7446                	ld	s0,112(sp)
 676:	74a6                	ld	s1,104(sp)
 678:	7906                	ld	s2,96(sp)
 67a:	69e6                	ld	s3,88(sp)
 67c:	6a46                	ld	s4,80(sp)
 67e:	6aa6                	ld	s5,72(sp)
 680:	6b06                	ld	s6,64(sp)
 682:	7be2                	ld	s7,56(sp)
 684:	7c42                	ld	s8,48(sp)
 686:	7ca2                	ld	s9,40(sp)
 688:	7d02                	ld	s10,32(sp)
 68a:	6de2                	ld	s11,24(sp)
 68c:	6109                	addi	sp,sp,128
 68e:	8082                	ret

0000000000000690 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 690:	715d                	addi	sp,sp,-80
 692:	ec06                	sd	ra,24(sp)
 694:	e822                	sd	s0,16(sp)
 696:	1000                	addi	s0,sp,32
 698:	e010                	sd	a2,0(s0)
 69a:	e414                	sd	a3,8(s0)
 69c:	e818                	sd	a4,16(s0)
 69e:	ec1c                	sd	a5,24(s0)
 6a0:	03043023          	sd	a6,32(s0)
 6a4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ac:	8622                	mv	a2,s0
 6ae:	00000097          	auipc	ra,0x0
 6b2:	e04080e7          	jalr	-508(ra) # 4b2 <vprintf>
}
 6b6:	60e2                	ld	ra,24(sp)
 6b8:	6442                	ld	s0,16(sp)
 6ba:	6161                	addi	sp,sp,80
 6bc:	8082                	ret

00000000000006be <printf>:

void
printf(const char *fmt, ...)
{
 6be:	711d                	addi	sp,sp,-96
 6c0:	ec06                	sd	ra,24(sp)
 6c2:	e822                	sd	s0,16(sp)
 6c4:	1000                	addi	s0,sp,32
 6c6:	e40c                	sd	a1,8(s0)
 6c8:	e810                	sd	a2,16(s0)
 6ca:	ec14                	sd	a3,24(s0)
 6cc:	f018                	sd	a4,32(s0)
 6ce:	f41c                	sd	a5,40(s0)
 6d0:	03043823          	sd	a6,48(s0)
 6d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d8:	00840613          	addi	a2,s0,8
 6dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e0:	85aa                	mv	a1,a0
 6e2:	4505                	li	a0,1
 6e4:	00000097          	auipc	ra,0x0
 6e8:	dce080e7          	jalr	-562(ra) # 4b2 <vprintf>
}
 6ec:	60e2                	ld	ra,24(sp)
 6ee:	6442                	ld	s0,16(sp)
 6f0:	6125                	addi	sp,sp,96
 6f2:	8082                	ret

00000000000006f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f4:	1141                	addi	sp,sp,-16
 6f6:	e422                	sd	s0,8(sp)
 6f8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fe:	00001797          	auipc	a5,0x1
 702:	9027b783          	ld	a5,-1790(a5) # 1000 <freep>
 706:	a02d                	j	730 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 708:	4618                	lw	a4,8(a2)
 70a:	9f2d                	addw	a4,a4,a1
 70c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 710:	6398                	ld	a4,0(a5)
 712:	6310                	ld	a2,0(a4)
 714:	a83d                	j	752 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 716:	ff852703          	lw	a4,-8(a0)
 71a:	9f31                	addw	a4,a4,a2
 71c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 71e:	ff053683          	ld	a3,-16(a0)
 722:	a091                	j	766 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	6398                	ld	a4,0(a5)
 726:	00e7e463          	bltu	a5,a4,72e <free+0x3a>
 72a:	00e6ea63          	bltu	a3,a4,73e <free+0x4a>
{
 72e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	fed7fae3          	bgeu	a5,a3,724 <free+0x30>
 734:	6398                	ld	a4,0(a5)
 736:	00e6e463          	bltu	a3,a4,73e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73a:	fee7eae3          	bltu	a5,a4,72e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 73e:	ff852583          	lw	a1,-8(a0)
 742:	6390                	ld	a2,0(a5)
 744:	02059813          	slli	a6,a1,0x20
 748:	01c85713          	srli	a4,a6,0x1c
 74c:	9736                	add	a4,a4,a3
 74e:	fae60de3          	beq	a2,a4,708 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 752:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 756:	4790                	lw	a2,8(a5)
 758:	02061593          	slli	a1,a2,0x20
 75c:	01c5d713          	srli	a4,a1,0x1c
 760:	973e                	add	a4,a4,a5
 762:	fae68ae3          	beq	a3,a4,716 <free+0x22>
    p->s.ptr = bp->s.ptr;
 766:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 768:	00001717          	auipc	a4,0x1
 76c:	88f73c23          	sd	a5,-1896(a4) # 1000 <freep>
}
 770:	6422                	ld	s0,8(sp)
 772:	0141                	addi	sp,sp,16
 774:	8082                	ret

0000000000000776 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 776:	7139                	addi	sp,sp,-64
 778:	fc06                	sd	ra,56(sp)
 77a:	f822                	sd	s0,48(sp)
 77c:	f426                	sd	s1,40(sp)
 77e:	f04a                	sd	s2,32(sp)
 780:	ec4e                	sd	s3,24(sp)
 782:	e852                	sd	s4,16(sp)
 784:	e456                	sd	s5,8(sp)
 786:	e05a                	sd	s6,0(sp)
 788:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78a:	02051493          	slli	s1,a0,0x20
 78e:	9081                	srli	s1,s1,0x20
 790:	04bd                	addi	s1,s1,15
 792:	8091                	srli	s1,s1,0x4
 794:	0014899b          	addiw	s3,s1,1
 798:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 79a:	00001517          	auipc	a0,0x1
 79e:	86653503          	ld	a0,-1946(a0) # 1000 <freep>
 7a2:	c515                	beqz	a0,7ce <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a6:	4798                	lw	a4,8(a5)
 7a8:	02977f63          	bgeu	a4,s1,7e6 <malloc+0x70>
 7ac:	8a4e                	mv	s4,s3
 7ae:	0009871b          	sext.w	a4,s3
 7b2:	6685                	lui	a3,0x1
 7b4:	00d77363          	bgeu	a4,a3,7ba <malloc+0x44>
 7b8:	6a05                	lui	s4,0x1
 7ba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7be:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c2:	00001917          	auipc	s2,0x1
 7c6:	83e90913          	addi	s2,s2,-1986 # 1000 <freep>
  if(p == (char*)-1)
 7ca:	5afd                	li	s5,-1
 7cc:	a895                	j	840 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7ce:	00001797          	auipc	a5,0x1
 7d2:	84278793          	addi	a5,a5,-1982 # 1010 <base>
 7d6:	00001717          	auipc	a4,0x1
 7da:	82f73523          	sd	a5,-2006(a4) # 1000 <freep>
 7de:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e4:	b7e1                	j	7ac <malloc+0x36>
      if(p->s.size == nunits)
 7e6:	02e48c63          	beq	s1,a4,81e <malloc+0xa8>
        p->s.size -= nunits;
 7ea:	4137073b          	subw	a4,a4,s3
 7ee:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f0:	02071693          	slli	a3,a4,0x20
 7f4:	01c6d713          	srli	a4,a3,0x1c
 7f8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7fa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7fe:	00001717          	auipc	a4,0x1
 802:	80a73123          	sd	a0,-2046(a4) # 1000 <freep>
      return (void*)(p + 1);
 806:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 80a:	70e2                	ld	ra,56(sp)
 80c:	7442                	ld	s0,48(sp)
 80e:	74a2                	ld	s1,40(sp)
 810:	7902                	ld	s2,32(sp)
 812:	69e2                	ld	s3,24(sp)
 814:	6a42                	ld	s4,16(sp)
 816:	6aa2                	ld	s5,8(sp)
 818:	6b02                	ld	s6,0(sp)
 81a:	6121                	addi	sp,sp,64
 81c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 81e:	6398                	ld	a4,0(a5)
 820:	e118                	sd	a4,0(a0)
 822:	bff1                	j	7fe <malloc+0x88>
  hp->s.size = nu;
 824:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 828:	0541                	addi	a0,a0,16
 82a:	00000097          	auipc	ra,0x0
 82e:	eca080e7          	jalr	-310(ra) # 6f4 <free>
  return freep;
 832:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 836:	d971                	beqz	a0,80a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83a:	4798                	lw	a4,8(a5)
 83c:	fa9775e3          	bgeu	a4,s1,7e6 <malloc+0x70>
    if(p == freep)
 840:	00093703          	ld	a4,0(s2)
 844:	853e                	mv	a0,a5
 846:	fef719e3          	bne	a4,a5,838 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 84a:	8552                	mv	a0,s4
 84c:	00000097          	auipc	ra,0x0
 850:	b40080e7          	jalr	-1216(ra) # 38c <sbrk>
  if(p == (char*)-1)
 854:	fd5518e3          	bne	a0,s5,824 <malloc+0xae>
        return 0;
 858:	4501                	li	a0,0
 85a:	bf45                	j	80a <malloc+0x94>

000000000000085c <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 85c:	c1d9                	beqz	a1,8e2 <head_run+0x86>
void head_run(int fd, int numOfLines){
 85e:	dd010113          	addi	sp,sp,-560
 862:	22113423          	sd	ra,552(sp)
 866:	22813023          	sd	s0,544(sp)
 86a:	20913c23          	sd	s1,536(sp)
 86e:	21213823          	sd	s2,528(sp)
 872:	21313423          	sd	s3,520(sp)
 876:	21413023          	sd	s4,512(sp)
 87a:	1c00                	addi	s0,sp,560
 87c:	892a                	mv	s2,a0
 87e:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 882:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 884:	00000a17          	auipc	s4,0x0
 888:	524a0a13          	addi	s4,s4,1316 # da8 <digits+0x40>
		readStatus = read_line(fd, line);
 88c:	dd840593          	addi	a1,s0,-552
 890:	854a                	mv	a0,s2
 892:	00000097          	auipc	ra,0x0
 896:	394080e7          	jalr	916(ra) # c26 <read_line>
		if (readStatus == READ_ERROR){
 89a:	01350d63          	beq	a0,s3,8b4 <head_run+0x58>
		if (readStatus == READ_EOF)
 89e:	c11d                	beqz	a0,8c4 <head_run+0x68>
		printf("%s",line);
 8a0:	dd840593          	addi	a1,s0,-552
 8a4:	8552                	mv	a0,s4
 8a6:	00000097          	auipc	ra,0x0
 8aa:	e18080e7          	jalr	-488(ra) # 6be <printf>
	while(numOfLines--){
 8ae:	34fd                	addiw	s1,s1,-1
 8b0:	fcf1                	bnez	s1,88c <head_run+0x30>
 8b2:	a809                	j	8c4 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 8b4:	00000517          	auipc	a0,0x0
 8b8:	4cc50513          	addi	a0,a0,1228 # d80 <digits+0x18>
 8bc:	00000097          	auipc	ra,0x0
 8c0:	e02080e7          	jalr	-510(ra) # 6be <printf>

	}
}
 8c4:	22813083          	ld	ra,552(sp)
 8c8:	22013403          	ld	s0,544(sp)
 8cc:	21813483          	ld	s1,536(sp)
 8d0:	21013903          	ld	s2,528(sp)
 8d4:	20813983          	ld	s3,520(sp)
 8d8:	20013a03          	ld	s4,512(sp)
 8dc:	23010113          	addi	sp,sp,560
 8e0:	8082                	ret
 8e2:	8082                	ret

00000000000008e4 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 8e4:	ba010113          	addi	sp,sp,-1120
 8e8:	44113c23          	sd	ra,1112(sp)
 8ec:	44813823          	sd	s0,1104(sp)
 8f0:	44913423          	sd	s1,1096(sp)
 8f4:	45213023          	sd	s2,1088(sp)
 8f8:	43313c23          	sd	s3,1080(sp)
 8fc:	43413823          	sd	s4,1072(sp)
 900:	43513423          	sd	s5,1064(sp)
 904:	43613023          	sd	s6,1056(sp)
 908:	41713c23          	sd	s7,1048(sp)
 90c:	41813823          	sd	s8,1040(sp)
 910:	41913423          	sd	s9,1032(sp)
 914:	41a13023          	sd	s10,1024(sp)
 918:	3fb13c23          	sd	s11,1016(sp)
 91c:	46010413          	addi	s0,sp,1120
 920:	89aa                	mv	s3,a0
 922:	8aae                	mv	s5,a1
 924:	8c32                	mv	s8,a2
 926:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 928:	d9840593          	addi	a1,s0,-616
 92c:	00000097          	auipc	ra,0x0
 930:	2fa080e7          	jalr	762(ra) # c26 <read_line>


  if (readStatus == READ_ERROR)
 934:	57fd                	li	a5,-1
 936:	04f50163          	beq	a0,a5,978 <uniq_run+0x94>
 93a:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 93c:	ed21                	bnez	a0,994 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 93e:	45813083          	ld	ra,1112(sp)
 942:	45013403          	ld	s0,1104(sp)
 946:	44813483          	ld	s1,1096(sp)
 94a:	44013903          	ld	s2,1088(sp)
 94e:	43813983          	ld	s3,1080(sp)
 952:	43013a03          	ld	s4,1072(sp)
 956:	42813a83          	ld	s5,1064(sp)
 95a:	42013b03          	ld	s6,1056(sp)
 95e:	41813b83          	ld	s7,1048(sp)
 962:	41013c03          	ld	s8,1040(sp)
 966:	40813c83          	ld	s9,1032(sp)
 96a:	40013d03          	ld	s10,1024(sp)
 96e:	3f813d83          	ld	s11,1016(sp)
 972:	46010113          	addi	sp,sp,1120
 976:	8082                	ret
    printf("[ERR] Error reading from the file ");
 978:	00000517          	auipc	a0,0x0
 97c:	43850513          	addi	a0,a0,1080 # db0 <digits+0x48>
 980:	00000097          	auipc	ra,0x0
 984:	d3e080e7          	jalr	-706(ra) # 6be <printf>
 988:	bf5d                	j	93e <uniq_run+0x5a>
 98a:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 98c:	8926                	mv	s2,s1
 98e:	84be                	mv	s1,a5
        lineCount = 1;
 990:	8b6a                	mv	s6,s10
 992:	a8ed                	j	a8c <uniq_run+0x1a8>
    int lineCount=1;
 994:	4b05                	li	s6,1
  char * line2 = buffer2;
 996:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 99a:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 99e:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 9a0:	4d05                	li	s10,1
              printf("%s",line1);
 9a2:	00000d97          	auipc	s11,0x0
 9a6:	406d8d93          	addi	s11,s11,1030 # da8 <digits+0x40>
 9aa:	a0cd                	j	a8c <uniq_run+0x1a8>
            if (repeatedLines){
 9ac:	020a0b63          	beqz	s4,9e2 <uniq_run+0xfe>
                if (isRepeated){
 9b0:	f80b87e3          	beqz	s7,93e <uniq_run+0x5a>
                    if (showCount)
 9b4:	000c0d63          	beqz	s8,9ce <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 9b8:	864a                	mv	a2,s2
 9ba:	85da                	mv	a1,s6
 9bc:	00000517          	auipc	a0,0x0
 9c0:	41c50513          	addi	a0,a0,1052 # dd8 <digits+0x70>
 9c4:	00000097          	auipc	ra,0x0
 9c8:	cfa080e7          	jalr	-774(ra) # 6be <printf>
 9cc:	bf8d                	j	93e <uniq_run+0x5a>
                      printf("%s",line1);
 9ce:	85ca                	mv	a1,s2
 9d0:	00000517          	auipc	a0,0x0
 9d4:	3d850513          	addi	a0,a0,984 # da8 <digits+0x40>
 9d8:	00000097          	auipc	ra,0x0
 9dc:	ce6080e7          	jalr	-794(ra) # 6be <printf>
 9e0:	bfb9                	j	93e <uniq_run+0x5a>
                if (showCount)
 9e2:	000c0d63          	beqz	s8,9fc <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 9e6:	864a                	mv	a2,s2
 9e8:	85da                	mv	a1,s6
 9ea:	00000517          	auipc	a0,0x0
 9ee:	3ee50513          	addi	a0,a0,1006 # dd8 <digits+0x70>
 9f2:	00000097          	auipc	ra,0x0
 9f6:	ccc080e7          	jalr	-820(ra) # 6be <printf>
 9fa:	b791                	j	93e <uniq_run+0x5a>
                  printf("%s",line1);
 9fc:	85ca                	mv	a1,s2
 9fe:	00000517          	auipc	a0,0x0
 a02:	3aa50513          	addi	a0,a0,938 # da8 <digits+0x40>
 a06:	00000097          	auipc	ra,0x0
 a0a:	cb8080e7          	jalr	-840(ra) # 6be <printf>
 a0e:	bf05                	j	93e <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 a10:	00000517          	auipc	a0,0x0
 a14:	3d050513          	addi	a0,a0,976 # de0 <digits+0x78>
 a18:	00000097          	auipc	ra,0x0
 a1c:	ca6080e7          	jalr	-858(ra) # 6be <printf>
          break;
 a20:	bf39                	j	93e <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 a22:	85a6                	mv	a1,s1
 a24:	854a                	mv	a0,s2
 a26:	00000097          	auipc	ra,0x0
 a2a:	110080e7          	jalr	272(ra) # b36 <compare_str_ic>
 a2e:	a041                	j	aae <uniq_run+0x1ca>
                  printf("%s",line1);
 a30:	85ca                	mv	a1,s2
 a32:	856e                	mv	a0,s11
 a34:	00000097          	auipc	ra,0x0
 a38:	c8a080e7          	jalr	-886(ra) # 6be <printf>
        lineCount = 1;
 a3c:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 a3e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a40:	8926                	mv	s2,s1
                  printf("%s",line1);
 a42:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a44:	4b81                	li	s7,0
 a46:	a099                	j	a8c <uniq_run+0x1a8>
            if (showCount)
 a48:	020c0263          	beqz	s8,a6c <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 a4c:	864a                	mv	a2,s2
 a4e:	85da                	mv	a1,s6
 a50:	00000517          	auipc	a0,0x0
 a54:	38850513          	addi	a0,a0,904 # dd8 <digits+0x70>
 a58:	00000097          	auipc	ra,0x0
 a5c:	c66080e7          	jalr	-922(ra) # 6be <printf>
 a60:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a62:	8926                	mv	s2,s1
 a64:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a66:	4b81                	li	s7,0
        lineCount = 1;
 a68:	8b6a                	mv	s6,s10
 a6a:	a00d                	j	a8c <uniq_run+0x1a8>
              printf("%s",line1);
 a6c:	85ca                	mv	a1,s2
 a6e:	856e                	mv	a0,s11
 a70:	00000097          	auipc	ra,0x0
 a74:	c4e080e7          	jalr	-946(ra) # 6be <printf>
 a78:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a7a:	8926                	mv	s2,s1
              printf("%s",line1);
 a7c:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a7e:	4b81                	li	s7,0
        lineCount = 1;
 a80:	8b6a                	mv	s6,s10
 a82:	a029                	j	a8c <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 a84:	000a0363          	beqz	s4,a8a <uniq_run+0x1a6>
 a88:	8bea                	mv	s7,s10
          lineCount++;
 a8a:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 a8c:	85a6                	mv	a1,s1
 a8e:	854e                	mv	a0,s3
 a90:	00000097          	auipc	ra,0x0
 a94:	196080e7          	jalr	406(ra) # c26 <read_line>
        if (readStatus == READ_EOF){
 a98:	d911                	beqz	a0,9ac <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 a9a:	f7950be3          	beq	a0,s9,a10 <uniq_run+0x12c>
        if (!ignoreCase)
 a9e:	f80a92e3          	bnez	s5,a22 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 aa2:	85a6                	mv	a1,s1
 aa4:	854a                	mv	a0,s2
 aa6:	00000097          	auipc	ra,0x0
 aaa:	062080e7          	jalr	98(ra) # b08 <compare_str>
        if (compareStatus != 0){ 
 aae:	d979                	beqz	a0,a84 <uniq_run+0x1a0>
          if (repeatedLines){
 ab0:	f80a0ce3          	beqz	s4,a48 <uniq_run+0x164>
            if (isRepeated){
 ab4:	ec0b8be3          	beqz	s7,98a <uniq_run+0xa6>
                if (showCount)
 ab8:	f60c0ce3          	beqz	s8,a30 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 abc:	864a                	mv	a2,s2
 abe:	85da                	mv	a1,s6
 ac0:	00000517          	auipc	a0,0x0
 ac4:	31850513          	addi	a0,a0,792 # dd8 <digits+0x70>
 ac8:	00000097          	auipc	ra,0x0
 acc:	bf6080e7          	jalr	-1034(ra) # 6be <printf>
        lineCount = 1;
 ad0:	8b5e                	mv	s6,s7
 ad2:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 ad4:	8926                	mv	s2,s1
 ad6:	84be                	mv	s1,a5
        isRepeated = 0 ;
 ad8:	4b81                	li	s7,0
 ada:	bf4d                	j	a8c <uniq_run+0x1a8>

0000000000000adc <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 adc:	1141                	addi	sp,sp,-16
 ade:	e422                	sd	s0,8(sp)
 ae0:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 ae2:	00054783          	lbu	a5,0(a0)
 ae6:	cf99                	beqz	a5,b04 <get_strlen+0x28>
 ae8:	00150713          	addi	a4,a0,1
 aec:	87ba                	mv	a5,a4
 aee:	4685                	li	a3,1
 af0:	9e99                	subw	a3,a3,a4
 af2:	00f6853b          	addw	a0,a3,a5
 af6:	0785                	addi	a5,a5,1
 af8:	fff7c703          	lbu	a4,-1(a5)
 afc:	fb7d                	bnez	a4,af2 <get_strlen+0x16>
	return len;
}
 afe:	6422                	ld	s0,8(sp)
 b00:	0141                	addi	sp,sp,16
 b02:	8082                	ret
	int len = 0;
 b04:	4501                	li	a0,0
 b06:	bfe5                	j	afe <get_strlen+0x22>

0000000000000b08 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 b08:	1141                	addi	sp,sp,-16
 b0a:	e422                	sd	s0,8(sp)
 b0c:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 b0e:	00054783          	lbu	a5,0(a0)
 b12:	cb91                	beqz	a5,b26 <compare_str+0x1e>
 b14:	0005c703          	lbu	a4,0(a1)
 b18:	c719                	beqz	a4,b26 <compare_str+0x1e>
		if (*s1++ != *s2++)
 b1a:	0505                	addi	a0,a0,1
 b1c:	0585                	addi	a1,a1,1
 b1e:	fee788e3          	beq	a5,a4,b0e <compare_str+0x6>
			return 1;
 b22:	4505                	li	a0,1
 b24:	a031                	j	b30 <compare_str+0x28>
	}
	if (*s1 == *s2)
 b26:	0005c503          	lbu	a0,0(a1)
 b2a:	8d1d                	sub	a0,a0,a5
			return 1;
 b2c:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b30:	6422                	ld	s0,8(sp)
 b32:	0141                	addi	sp,sp,16
 b34:	8082                	ret

0000000000000b36 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 b36:	1141                	addi	sp,sp,-16
 b38:	e422                	sd	s0,8(sp)
 b3a:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b3c:	4665                	li	a2,25
	while(*s1 && *s2){
 b3e:	a019                	j	b44 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b40:	04e79763          	bne	a5,a4,b8e <compare_str_ic+0x58>
	while(*s1 && *s2){
 b44:	00054783          	lbu	a5,0(a0)
 b48:	cb9d                	beqz	a5,b7e <compare_str_ic+0x48>
 b4a:	0005c703          	lbu	a4,0(a1)
 b4e:	cb05                	beqz	a4,b7e <compare_str_ic+0x48>
		char b1 = *s1++;
 b50:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 b52:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b54:	fbf7869b          	addiw	a3,a5,-65
 b58:	0ff6f693          	zext.b	a3,a3
 b5c:	00d66663          	bltu	a2,a3,b68 <compare_str_ic+0x32>
			b1 += 32;
 b60:	0207879b          	addiw	a5,a5,32
 b64:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 b68:	fbf7069b          	addiw	a3,a4,-65
 b6c:	0ff6f693          	zext.b	a3,a3
 b70:	fcd668e3          	bltu	a2,a3,b40 <compare_str_ic+0xa>
			b2 += 32;
 b74:	0207071b          	addiw	a4,a4,32
 b78:	0ff77713          	zext.b	a4,a4
 b7c:	b7d1                	j	b40 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 b7e:	0005c503          	lbu	a0,0(a1)
 b82:	8d1d                	sub	a0,a0,a5
			return 1;
 b84:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b88:	6422                	ld	s0,8(sp)
 b8a:	0141                	addi	sp,sp,16
 b8c:	8082                	ret
			return 1;
 b8e:	4505                	li	a0,1
 b90:	bfe5                	j	b88 <compare_str_ic+0x52>

0000000000000b92 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 b92:	7179                	addi	sp,sp,-48
 b94:	f406                	sd	ra,40(sp)
 b96:	f022                	sd	s0,32(sp)
 b98:	ec26                	sd	s1,24(sp)
 b9a:	e84a                	sd	s2,16(sp)
 b9c:	e44e                	sd	s3,8(sp)
 b9e:	1800                	addi	s0,sp,48
 ba0:	89aa                	mv	s3,a0
 ba2:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 ba4:	00000097          	auipc	ra,0x0
 ba8:	f38080e7          	jalr	-200(ra) # adc <get_strlen>
 bac:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 bae:	854a                	mv	a0,s2
 bb0:	00000097          	auipc	ra,0x0
 bb4:	f2c080e7          	jalr	-212(ra) # adc <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 bb8:	409505bb          	subw	a1,a0,s1
 bbc:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 bbe:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 bc0:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 bc2:	0005da63          	bgez	a1,bd6 <check_substr+0x44>
 bc6:	a81d                	j	bfc <check_substr+0x6a>
        if (j == M)
 bc8:	02f48a63          	beq	s1,a5,bfc <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 bcc:	0885                	addi	a7,a7,1
 bce:	0008879b          	sext.w	a5,a7
 bd2:	02f5cc63          	blt	a1,a5,c0a <check_substr+0x78>
 bd6:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 bda:	011906b3          	add	a3,s2,a7
 bde:	874e                	mv	a4,s3
 be0:	879a                	mv	a5,t1
 be2:	fe9053e3          	blez	s1,bc8 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 be6:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 bea:	00074603          	lbu	a2,0(a4)
 bee:	fcc81de3          	bne	a6,a2,bc8 <check_substr+0x36>
        for (j = 0; j < M; j++)
 bf2:	2785                	addiw	a5,a5,1
 bf4:	0685                	addi	a3,a3,1
 bf6:	0705                	addi	a4,a4,1
 bf8:	fef497e3          	bne	s1,a5,be6 <check_substr+0x54>
}
 bfc:	70a2                	ld	ra,40(sp)
 bfe:	7402                	ld	s0,32(sp)
 c00:	64e2                	ld	s1,24(sp)
 c02:	6942                	ld	s2,16(sp)
 c04:	69a2                	ld	s3,8(sp)
 c06:	6145                	addi	sp,sp,48
 c08:	8082                	ret
    return -1;
 c0a:	557d                	li	a0,-1
 c0c:	bfc5                	j	bfc <check_substr+0x6a>

0000000000000c0e <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 c0e:	1141                	addi	sp,sp,-16
 c10:	e406                	sd	ra,8(sp)
 c12:	e022                	sd	s0,0(sp)
 c14:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 c16:	fffff097          	auipc	ra,0xfffff
 c1a:	72e080e7          	jalr	1838(ra) # 344 <open>
	return fd;
}
 c1e:	60a2                	ld	ra,8(sp)
 c20:	6402                	ld	s0,0(sp)
 c22:	0141                	addi	sp,sp,16
 c24:	8082                	ret

0000000000000c26 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 c26:	7139                	addi	sp,sp,-64
 c28:	fc06                	sd	ra,56(sp)
 c2a:	f822                	sd	s0,48(sp)
 c2c:	f426                	sd	s1,40(sp)
 c2e:	f04a                	sd	s2,32(sp)
 c30:	ec4e                	sd	s3,24(sp)
 c32:	e852                	sd	s4,16(sp)
 c34:	0080                	addi	s0,sp,64
 c36:	89aa                	mv	s3,a0
 c38:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c3a:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 c3c:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c3e:	4605                	li	a2,1
 c40:	fcf40593          	addi	a1,s0,-49
 c44:	854e                	mv	a0,s3
 c46:	fffff097          	auipc	ra,0xfffff
 c4a:	6d6080e7          	jalr	1750(ra) # 31c <read>
		if (readStatus == 0){
 c4e:	c505                	beqz	a0,c76 <read_line+0x50>
		*buffer++ = readByte;
 c50:	0485                	addi	s1,s1,1
 c52:	fcf44783          	lbu	a5,-49(s0)
 c56:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c5a:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c5c:	ff4791e3          	bne	a5,s4,c3e <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c60:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 c64:	854a                	mv	a0,s2
 c66:	70e2                	ld	ra,56(sp)
 c68:	7442                	ld	s0,48(sp)
 c6a:	74a2                	ld	s1,40(sp)
 c6c:	7902                	ld	s2,32(sp)
 c6e:	69e2                	ld	s3,24(sp)
 c70:	6a42                	ld	s4,16(sp)
 c72:	6121                	addi	sp,sp,64
 c74:	8082                	ret
			if (byteCount!=0){
 c76:	fe0907e3          	beqz	s2,c64 <read_line+0x3e>
				*buffer = '\n';
 c7a:	47a9                	li	a5,10
 c7c:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 c80:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 c84:	2905                	addiw	s2,s2,1
 c86:	bff9                	j	c64 <read_line+0x3e>

0000000000000c88 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c88:	1141                	addi	sp,sp,-16
 c8a:	e406                	sd	ra,8(sp)
 c8c:	e022                	sd	s0,0(sp)
 c8e:	0800                	addi	s0,sp,16
	close(fd);
 c90:	fffff097          	auipc	ra,0xfffff
 c94:	69c080e7          	jalr	1692(ra) # 32c <close>
}
 c98:	60a2                	ld	ra,8(sp)
 c9a:	6402                	ld	s0,0(sp)
 c9c:	0141                	addi	sp,sp,16
 c9e:	8082                	ret

0000000000000ca0 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 ca0:	7139                	addi	sp,sp,-64
 ca2:	fc06                	sd	ra,56(sp)
 ca4:	f822                	sd	s0,48(sp)
 ca6:	f426                	sd	s1,40(sp)
 ca8:	f04a                	sd	s2,32(sp)
 caa:	0080                	addi	s0,sp,64
 cac:	84aa                	mv	s1,a0
 cae:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 cb0:	fffff097          	auipc	ra,0xfffff
 cb4:	64c080e7          	jalr	1612(ra) # 2fc <fork>
 cb8:	ed19                	bnez	a0,cd6 <get_time_perf+0x36>
		exec(argv[0],argv);
 cba:	85ca                	mv	a1,s2
 cbc:	00093503          	ld	a0,0(s2)
 cc0:	fffff097          	auipc	ra,0xfffff
 cc4:	67c080e7          	jalr	1660(ra) # 33c <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 cc8:	8526                	mv	a0,s1
 cca:	70e2                	ld	ra,56(sp)
 ccc:	7442                	ld	s0,48(sp)
 cce:	74a2                	ld	s1,40(sp)
 cd0:	7902                	ld	s2,32(sp)
 cd2:	6121                	addi	sp,sp,64
 cd4:	8082                	ret
		times(pid , &time);
 cd6:	fc040593          	addi	a1,s0,-64
 cda:	fffff097          	auipc	ra,0xfffff
 cde:	6e2080e7          	jalr	1762(ra) # 3bc <times>
		return time;
 ce2:	fc043783          	ld	a5,-64(s0)
 ce6:	e09c                	sd	a5,0(s1)
 ce8:	fc843783          	ld	a5,-56(s0)
 cec:	e49c                	sd	a5,8(s1)
 cee:	fd043783          	ld	a5,-48(s0)
 cf2:	e89c                	sd	a5,16(s1)
 cf4:	fd843783          	ld	a5,-40(s0)
 cf8:	ec9c                	sd	a5,24(s1)
 cfa:	b7f9                	j	cc8 <get_time_perf+0x28>
