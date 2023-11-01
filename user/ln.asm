
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
  14:	cd058593          	addi	a1,a1,-816 # ce0 <get_time_perf+0x5e>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	658080e7          	jalr	1624(ra) # 672 <fprintf>
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
  50:	cac58593          	addi	a1,a1,-852 # cf8 <get_time_perf+0x76>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	61c080e7          	jalr	1564(ra) # 672 <fprintf>
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

00000000000003ae <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 3ae:	48ed                	li	a7,27
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 3b6:	48f1                	li	a7,28
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 3be:	48f5                	li	a7,29
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c6:	1101                	addi	sp,sp,-32
 3c8:	ec06                	sd	ra,24(sp)
 3ca:	e822                	sd	s0,16(sp)
 3cc:	1000                	addi	s0,sp,32
 3ce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d2:	4605                	li	a2,1
 3d4:	fef40593          	addi	a1,s0,-17
 3d8:	00000097          	auipc	ra,0x0
 3dc:	f2e080e7          	jalr	-210(ra) # 306 <write>
}
 3e0:	60e2                	ld	ra,24(sp)
 3e2:	6442                	ld	s0,16(sp)
 3e4:	6105                	addi	sp,sp,32
 3e6:	8082                	ret

00000000000003e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e8:	7139                	addi	sp,sp,-64
 3ea:	fc06                	sd	ra,56(sp)
 3ec:	f822                	sd	s0,48(sp)
 3ee:	f426                	sd	s1,40(sp)
 3f0:	f04a                	sd	s2,32(sp)
 3f2:	ec4e                	sd	s3,24(sp)
 3f4:	0080                	addi	s0,sp,64
 3f6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f8:	c299                	beqz	a3,3fe <printint+0x16>
 3fa:	0805c963          	bltz	a1,48c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3fe:	2581                	sext.w	a1,a1
  neg = 0;
 400:	4881                	li	a7,0
 402:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 406:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 408:	2601                	sext.w	a2,a2
 40a:	00001517          	auipc	a0,0x1
 40e:	96650513          	addi	a0,a0,-1690 # d70 <digits>
 412:	883a                	mv	a6,a4
 414:	2705                	addiw	a4,a4,1
 416:	02c5f7bb          	remuw	a5,a1,a2
 41a:	1782                	slli	a5,a5,0x20
 41c:	9381                	srli	a5,a5,0x20
 41e:	97aa                	add	a5,a5,a0
 420:	0007c783          	lbu	a5,0(a5)
 424:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 428:	0005879b          	sext.w	a5,a1
 42c:	02c5d5bb          	divuw	a1,a1,a2
 430:	0685                	addi	a3,a3,1
 432:	fec7f0e3          	bgeu	a5,a2,412 <printint+0x2a>
  if(neg)
 436:	00088c63          	beqz	a7,44e <printint+0x66>
    buf[i++] = '-';
 43a:	fd070793          	addi	a5,a4,-48
 43e:	00878733          	add	a4,a5,s0
 442:	02d00793          	li	a5,45
 446:	fef70823          	sb	a5,-16(a4)
 44a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 44e:	02e05863          	blez	a4,47e <printint+0x96>
 452:	fc040793          	addi	a5,s0,-64
 456:	00e78933          	add	s2,a5,a4
 45a:	fff78993          	addi	s3,a5,-1
 45e:	99ba                	add	s3,s3,a4
 460:	377d                	addiw	a4,a4,-1
 462:	1702                	slli	a4,a4,0x20
 464:	9301                	srli	a4,a4,0x20
 466:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 46a:	fff94583          	lbu	a1,-1(s2)
 46e:	8526                	mv	a0,s1
 470:	00000097          	auipc	ra,0x0
 474:	f56080e7          	jalr	-170(ra) # 3c6 <putc>
  while(--i >= 0)
 478:	197d                	addi	s2,s2,-1
 47a:	ff3918e3          	bne	s2,s3,46a <printint+0x82>
}
 47e:	70e2                	ld	ra,56(sp)
 480:	7442                	ld	s0,48(sp)
 482:	74a2                	ld	s1,40(sp)
 484:	7902                	ld	s2,32(sp)
 486:	69e2                	ld	s3,24(sp)
 488:	6121                	addi	sp,sp,64
 48a:	8082                	ret
    x = -xx;
 48c:	40b005bb          	negw	a1,a1
    neg = 1;
 490:	4885                	li	a7,1
    x = -xx;
 492:	bf85                	j	402 <printint+0x1a>

0000000000000494 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 494:	7119                	addi	sp,sp,-128
 496:	fc86                	sd	ra,120(sp)
 498:	f8a2                	sd	s0,112(sp)
 49a:	f4a6                	sd	s1,104(sp)
 49c:	f0ca                	sd	s2,96(sp)
 49e:	ecce                	sd	s3,88(sp)
 4a0:	e8d2                	sd	s4,80(sp)
 4a2:	e4d6                	sd	s5,72(sp)
 4a4:	e0da                	sd	s6,64(sp)
 4a6:	fc5e                	sd	s7,56(sp)
 4a8:	f862                	sd	s8,48(sp)
 4aa:	f466                	sd	s9,40(sp)
 4ac:	f06a                	sd	s10,32(sp)
 4ae:	ec6e                	sd	s11,24(sp)
 4b0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b2:	0005c903          	lbu	s2,0(a1)
 4b6:	18090f63          	beqz	s2,654 <vprintf+0x1c0>
 4ba:	8aaa                	mv	s5,a0
 4bc:	8b32                	mv	s6,a2
 4be:	00158493          	addi	s1,a1,1
  state = 0;
 4c2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c4:	02500a13          	li	s4,37
 4c8:	4c55                	li	s8,21
 4ca:	00001c97          	auipc	s9,0x1
 4ce:	84ec8c93          	addi	s9,s9,-1970 # d18 <get_time_perf+0x96>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4d2:	02800d93          	li	s11,40
  putc(fd, 'x');
 4d6:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4d8:	00001b97          	auipc	s7,0x1
 4dc:	898b8b93          	addi	s7,s7,-1896 # d70 <digits>
 4e0:	a839                	j	4fe <vprintf+0x6a>
        putc(fd, c);
 4e2:	85ca                	mv	a1,s2
 4e4:	8556                	mv	a0,s5
 4e6:	00000097          	auipc	ra,0x0
 4ea:	ee0080e7          	jalr	-288(ra) # 3c6 <putc>
 4ee:	a019                	j	4f4 <vprintf+0x60>
    } else if(state == '%'){
 4f0:	01498d63          	beq	s3,s4,50a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4f4:	0485                	addi	s1,s1,1
 4f6:	fff4c903          	lbu	s2,-1(s1)
 4fa:	14090d63          	beqz	s2,654 <vprintf+0x1c0>
    if(state == 0){
 4fe:	fe0999e3          	bnez	s3,4f0 <vprintf+0x5c>
      if(c == '%'){
 502:	ff4910e3          	bne	s2,s4,4e2 <vprintf+0x4e>
        state = '%';
 506:	89d2                	mv	s3,s4
 508:	b7f5                	j	4f4 <vprintf+0x60>
      if(c == 'd'){
 50a:	11490c63          	beq	s2,s4,622 <vprintf+0x18e>
 50e:	f9d9079b          	addiw	a5,s2,-99
 512:	0ff7f793          	zext.b	a5,a5
 516:	10fc6e63          	bltu	s8,a5,632 <vprintf+0x19e>
 51a:	f9d9079b          	addiw	a5,s2,-99
 51e:	0ff7f713          	zext.b	a4,a5
 522:	10ec6863          	bltu	s8,a4,632 <vprintf+0x19e>
 526:	00271793          	slli	a5,a4,0x2
 52a:	97e6                	add	a5,a5,s9
 52c:	439c                	lw	a5,0(a5)
 52e:	97e6                	add	a5,a5,s9
 530:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 532:	008b0913          	addi	s2,s6,8
 536:	4685                	li	a3,1
 538:	4629                	li	a2,10
 53a:	000b2583          	lw	a1,0(s6)
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	ea8080e7          	jalr	-344(ra) # 3e8 <printint>
 548:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 54a:	4981                	li	s3,0
 54c:	b765                	j	4f4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 54e:	008b0913          	addi	s2,s6,8
 552:	4681                	li	a3,0
 554:	4629                	li	a2,10
 556:	000b2583          	lw	a1,0(s6)
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	e8c080e7          	jalr	-372(ra) # 3e8 <printint>
 564:	8b4a                	mv	s6,s2
      state = 0;
 566:	4981                	li	s3,0
 568:	b771                	j	4f4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 56a:	008b0913          	addi	s2,s6,8
 56e:	4681                	li	a3,0
 570:	866a                	mv	a2,s10
 572:	000b2583          	lw	a1,0(s6)
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	e70080e7          	jalr	-400(ra) # 3e8 <printint>
 580:	8b4a                	mv	s6,s2
      state = 0;
 582:	4981                	li	s3,0
 584:	bf85                	j	4f4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 586:	008b0793          	addi	a5,s6,8
 58a:	f8f43423          	sd	a5,-120(s0)
 58e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 592:	03000593          	li	a1,48
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e2e080e7          	jalr	-466(ra) # 3c6 <putc>
  putc(fd, 'x');
 5a0:	07800593          	li	a1,120
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e20080e7          	jalr	-480(ra) # 3c6 <putc>
 5ae:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b0:	03c9d793          	srli	a5,s3,0x3c
 5b4:	97de                	add	a5,a5,s7
 5b6:	0007c583          	lbu	a1,0(a5)
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e0a080e7          	jalr	-502(ra) # 3c6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5c4:	0992                	slli	s3,s3,0x4
 5c6:	397d                	addiw	s2,s2,-1
 5c8:	fe0914e3          	bnez	s2,5b0 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5cc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b70d                	j	4f4 <vprintf+0x60>
        s = va_arg(ap, char*);
 5d4:	008b0913          	addi	s2,s6,8
 5d8:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5dc:	02098163          	beqz	s3,5fe <vprintf+0x16a>
        while(*s != 0){
 5e0:	0009c583          	lbu	a1,0(s3)
 5e4:	c5ad                	beqz	a1,64e <vprintf+0x1ba>
          putc(fd, *s);
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	dde080e7          	jalr	-546(ra) # 3c6 <putc>
          s++;
 5f0:	0985                	addi	s3,s3,1
        while(*s != 0){
 5f2:	0009c583          	lbu	a1,0(s3)
 5f6:	f9e5                	bnez	a1,5e6 <vprintf+0x152>
        s = va_arg(ap, char*);
 5f8:	8b4a                	mv	s6,s2
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bde5                	j	4f4 <vprintf+0x60>
          s = "(null)";
 5fe:	00000997          	auipc	s3,0x0
 602:	71298993          	addi	s3,s3,1810 # d10 <get_time_perf+0x8e>
        while(*s != 0){
 606:	85ee                	mv	a1,s11
 608:	bff9                	j	5e6 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 60a:	008b0913          	addi	s2,s6,8
 60e:	000b4583          	lbu	a1,0(s6)
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	db2080e7          	jalr	-590(ra) # 3c6 <putc>
 61c:	8b4a                	mv	s6,s2
      state = 0;
 61e:	4981                	li	s3,0
 620:	bdd1                	j	4f4 <vprintf+0x60>
        putc(fd, c);
 622:	85d2                	mv	a1,s4
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	da0080e7          	jalr	-608(ra) # 3c6 <putc>
      state = 0;
 62e:	4981                	li	s3,0
 630:	b5d1                	j	4f4 <vprintf+0x60>
        putc(fd, '%');
 632:	85d2                	mv	a1,s4
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	d90080e7          	jalr	-624(ra) # 3c6 <putc>
        putc(fd, c);
 63e:	85ca                	mv	a1,s2
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	d84080e7          	jalr	-636(ra) # 3c6 <putc>
      state = 0;
 64a:	4981                	li	s3,0
 64c:	b565                	j	4f4 <vprintf+0x60>
        s = va_arg(ap, char*);
 64e:	8b4a                	mv	s6,s2
      state = 0;
 650:	4981                	li	s3,0
 652:	b54d                	j	4f4 <vprintf+0x60>
    }
  }
}
 654:	70e6                	ld	ra,120(sp)
 656:	7446                	ld	s0,112(sp)
 658:	74a6                	ld	s1,104(sp)
 65a:	7906                	ld	s2,96(sp)
 65c:	69e6                	ld	s3,88(sp)
 65e:	6a46                	ld	s4,80(sp)
 660:	6aa6                	ld	s5,72(sp)
 662:	6b06                	ld	s6,64(sp)
 664:	7be2                	ld	s7,56(sp)
 666:	7c42                	ld	s8,48(sp)
 668:	7ca2                	ld	s9,40(sp)
 66a:	7d02                	ld	s10,32(sp)
 66c:	6de2                	ld	s11,24(sp)
 66e:	6109                	addi	sp,sp,128
 670:	8082                	ret

0000000000000672 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 672:	715d                	addi	sp,sp,-80
 674:	ec06                	sd	ra,24(sp)
 676:	e822                	sd	s0,16(sp)
 678:	1000                	addi	s0,sp,32
 67a:	e010                	sd	a2,0(s0)
 67c:	e414                	sd	a3,8(s0)
 67e:	e818                	sd	a4,16(s0)
 680:	ec1c                	sd	a5,24(s0)
 682:	03043023          	sd	a6,32(s0)
 686:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 68a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 68e:	8622                	mv	a2,s0
 690:	00000097          	auipc	ra,0x0
 694:	e04080e7          	jalr	-508(ra) # 494 <vprintf>
}
 698:	60e2                	ld	ra,24(sp)
 69a:	6442                	ld	s0,16(sp)
 69c:	6161                	addi	sp,sp,80
 69e:	8082                	ret

00000000000006a0 <printf>:

void
printf(const char *fmt, ...)
{
 6a0:	711d                	addi	sp,sp,-96
 6a2:	ec06                	sd	ra,24(sp)
 6a4:	e822                	sd	s0,16(sp)
 6a6:	1000                	addi	s0,sp,32
 6a8:	e40c                	sd	a1,8(s0)
 6aa:	e810                	sd	a2,16(s0)
 6ac:	ec14                	sd	a3,24(s0)
 6ae:	f018                	sd	a4,32(s0)
 6b0:	f41c                	sd	a5,40(s0)
 6b2:	03043823          	sd	a6,48(s0)
 6b6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ba:	00840613          	addi	a2,s0,8
 6be:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c2:	85aa                	mv	a1,a0
 6c4:	4505                	li	a0,1
 6c6:	00000097          	auipc	ra,0x0
 6ca:	dce080e7          	jalr	-562(ra) # 494 <vprintf>
}
 6ce:	60e2                	ld	ra,24(sp)
 6d0:	6442                	ld	s0,16(sp)
 6d2:	6125                	addi	sp,sp,96
 6d4:	8082                	ret

00000000000006d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d6:	1141                	addi	sp,sp,-16
 6d8:	e422                	sd	s0,8(sp)
 6da:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6dc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e0:	00001797          	auipc	a5,0x1
 6e4:	9207b783          	ld	a5,-1760(a5) # 1000 <freep>
 6e8:	a02d                	j	712 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ea:	4618                	lw	a4,8(a2)
 6ec:	9f2d                	addw	a4,a4,a1
 6ee:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f2:	6398                	ld	a4,0(a5)
 6f4:	6310                	ld	a2,0(a4)
 6f6:	a83d                	j	734 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6f8:	ff852703          	lw	a4,-8(a0)
 6fc:	9f31                	addw	a4,a4,a2
 6fe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 700:	ff053683          	ld	a3,-16(a0)
 704:	a091                	j	748 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 706:	6398                	ld	a4,0(a5)
 708:	00e7e463          	bltu	a5,a4,710 <free+0x3a>
 70c:	00e6ea63          	bltu	a3,a4,720 <free+0x4a>
{
 710:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 712:	fed7fae3          	bgeu	a5,a3,706 <free+0x30>
 716:	6398                	ld	a4,0(a5)
 718:	00e6e463          	bltu	a3,a4,720 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71c:	fee7eae3          	bltu	a5,a4,710 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 720:	ff852583          	lw	a1,-8(a0)
 724:	6390                	ld	a2,0(a5)
 726:	02059813          	slli	a6,a1,0x20
 72a:	01c85713          	srli	a4,a6,0x1c
 72e:	9736                	add	a4,a4,a3
 730:	fae60de3          	beq	a2,a4,6ea <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 734:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 738:	4790                	lw	a2,8(a5)
 73a:	02061593          	slli	a1,a2,0x20
 73e:	01c5d713          	srli	a4,a1,0x1c
 742:	973e                	add	a4,a4,a5
 744:	fae68ae3          	beq	a3,a4,6f8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 748:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 74a:	00001717          	auipc	a4,0x1
 74e:	8af73b23          	sd	a5,-1866(a4) # 1000 <freep>
}
 752:	6422                	ld	s0,8(sp)
 754:	0141                	addi	sp,sp,16
 756:	8082                	ret

0000000000000758 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 758:	7139                	addi	sp,sp,-64
 75a:	fc06                	sd	ra,56(sp)
 75c:	f822                	sd	s0,48(sp)
 75e:	f426                	sd	s1,40(sp)
 760:	f04a                	sd	s2,32(sp)
 762:	ec4e                	sd	s3,24(sp)
 764:	e852                	sd	s4,16(sp)
 766:	e456                	sd	s5,8(sp)
 768:	e05a                	sd	s6,0(sp)
 76a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76c:	02051493          	slli	s1,a0,0x20
 770:	9081                	srli	s1,s1,0x20
 772:	04bd                	addi	s1,s1,15
 774:	8091                	srli	s1,s1,0x4
 776:	0014899b          	addiw	s3,s1,1
 77a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 77c:	00001517          	auipc	a0,0x1
 780:	88453503          	ld	a0,-1916(a0) # 1000 <freep>
 784:	c515                	beqz	a0,7b0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 786:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 788:	4798                	lw	a4,8(a5)
 78a:	02977f63          	bgeu	a4,s1,7c8 <malloc+0x70>
 78e:	8a4e                	mv	s4,s3
 790:	0009871b          	sext.w	a4,s3
 794:	6685                	lui	a3,0x1
 796:	00d77363          	bgeu	a4,a3,79c <malloc+0x44>
 79a:	6a05                	lui	s4,0x1
 79c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a4:	00001917          	auipc	s2,0x1
 7a8:	85c90913          	addi	s2,s2,-1956 # 1000 <freep>
  if(p == (char*)-1)
 7ac:	5afd                	li	s5,-1
 7ae:	a895                	j	822 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7b0:	00001797          	auipc	a5,0x1
 7b4:	86078793          	addi	a5,a5,-1952 # 1010 <base>
 7b8:	00001717          	auipc	a4,0x1
 7bc:	84f73423          	sd	a5,-1976(a4) # 1000 <freep>
 7c0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c6:	b7e1                	j	78e <malloc+0x36>
      if(p->s.size == nunits)
 7c8:	02e48c63          	beq	s1,a4,800 <malloc+0xa8>
        p->s.size -= nunits;
 7cc:	4137073b          	subw	a4,a4,s3
 7d0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d2:	02071693          	slli	a3,a4,0x20
 7d6:	01c6d713          	srli	a4,a3,0x1c
 7da:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7dc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e0:	00001717          	auipc	a4,0x1
 7e4:	82a73023          	sd	a0,-2016(a4) # 1000 <freep>
      return (void*)(p + 1);
 7e8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ec:	70e2                	ld	ra,56(sp)
 7ee:	7442                	ld	s0,48(sp)
 7f0:	74a2                	ld	s1,40(sp)
 7f2:	7902                	ld	s2,32(sp)
 7f4:	69e2                	ld	s3,24(sp)
 7f6:	6a42                	ld	s4,16(sp)
 7f8:	6aa2                	ld	s5,8(sp)
 7fa:	6b02                	ld	s6,0(sp)
 7fc:	6121                	addi	sp,sp,64
 7fe:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 800:	6398                	ld	a4,0(a5)
 802:	e118                	sd	a4,0(a0)
 804:	bff1                	j	7e0 <malloc+0x88>
  hp->s.size = nu;
 806:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80a:	0541                	addi	a0,a0,16
 80c:	00000097          	auipc	ra,0x0
 810:	eca080e7          	jalr	-310(ra) # 6d6 <free>
  return freep;
 814:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 818:	d971                	beqz	a0,7ec <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81c:	4798                	lw	a4,8(a5)
 81e:	fa9775e3          	bgeu	a4,s1,7c8 <malloc+0x70>
    if(p == freep)
 822:	00093703          	ld	a4,0(s2)
 826:	853e                	mv	a0,a5
 828:	fef719e3          	bne	a4,a5,81a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 82c:	8552                	mv	a0,s4
 82e:	00000097          	auipc	ra,0x0
 832:	b40080e7          	jalr	-1216(ra) # 36e <sbrk>
  if(p == (char*)-1)
 836:	fd5518e3          	bne	a0,s5,806 <malloc+0xae>
        return 0;
 83a:	4501                	li	a0,0
 83c:	bf45                	j	7ec <malloc+0x94>

000000000000083e <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 83e:	c1d9                	beqz	a1,8c4 <head_run+0x86>
void head_run(int fd, int numOfLines){
 840:	dd010113          	addi	sp,sp,-560
 844:	22113423          	sd	ra,552(sp)
 848:	22813023          	sd	s0,544(sp)
 84c:	20913c23          	sd	s1,536(sp)
 850:	21213823          	sd	s2,528(sp)
 854:	21313423          	sd	s3,520(sp)
 858:	21413023          	sd	s4,512(sp)
 85c:	1c00                	addi	s0,sp,560
 85e:	892a                	mv	s2,a0
 860:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 864:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 866:	00000a17          	auipc	s4,0x0
 86a:	54aa0a13          	addi	s4,s4,1354 # db0 <digits+0x40>
		readStatus = read_line(fd, line);
 86e:	dd840593          	addi	a1,s0,-552
 872:	854a                	mv	a0,s2
 874:	00000097          	auipc	ra,0x0
 878:	394080e7          	jalr	916(ra) # c08 <read_line>
		if (readStatus == READ_ERROR){
 87c:	01350d63          	beq	a0,s3,896 <head_run+0x58>
		if (readStatus == READ_EOF)
 880:	c11d                	beqz	a0,8a6 <head_run+0x68>
		printf("%s",line);
 882:	dd840593          	addi	a1,s0,-552
 886:	8552                	mv	a0,s4
 888:	00000097          	auipc	ra,0x0
 88c:	e18080e7          	jalr	-488(ra) # 6a0 <printf>
	while(numOfLines--){
 890:	34fd                	addiw	s1,s1,-1
 892:	fcf1                	bnez	s1,86e <head_run+0x30>
 894:	a809                	j	8a6 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 896:	00000517          	auipc	a0,0x0
 89a:	4f250513          	addi	a0,a0,1266 # d88 <digits+0x18>
 89e:	00000097          	auipc	ra,0x0
 8a2:	e02080e7          	jalr	-510(ra) # 6a0 <printf>

	}
}
 8a6:	22813083          	ld	ra,552(sp)
 8aa:	22013403          	ld	s0,544(sp)
 8ae:	21813483          	ld	s1,536(sp)
 8b2:	21013903          	ld	s2,528(sp)
 8b6:	20813983          	ld	s3,520(sp)
 8ba:	20013a03          	ld	s4,512(sp)
 8be:	23010113          	addi	sp,sp,560
 8c2:	8082                	ret
 8c4:	8082                	ret

00000000000008c6 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 8c6:	ba010113          	addi	sp,sp,-1120
 8ca:	44113c23          	sd	ra,1112(sp)
 8ce:	44813823          	sd	s0,1104(sp)
 8d2:	44913423          	sd	s1,1096(sp)
 8d6:	45213023          	sd	s2,1088(sp)
 8da:	43313c23          	sd	s3,1080(sp)
 8de:	43413823          	sd	s4,1072(sp)
 8e2:	43513423          	sd	s5,1064(sp)
 8e6:	43613023          	sd	s6,1056(sp)
 8ea:	41713c23          	sd	s7,1048(sp)
 8ee:	41813823          	sd	s8,1040(sp)
 8f2:	41913423          	sd	s9,1032(sp)
 8f6:	41a13023          	sd	s10,1024(sp)
 8fa:	3fb13c23          	sd	s11,1016(sp)
 8fe:	46010413          	addi	s0,sp,1120
 902:	89aa                	mv	s3,a0
 904:	8aae                	mv	s5,a1
 906:	8c32                	mv	s8,a2
 908:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 90a:	d9840593          	addi	a1,s0,-616
 90e:	00000097          	auipc	ra,0x0
 912:	2fa080e7          	jalr	762(ra) # c08 <read_line>


  if (readStatus == READ_ERROR)
 916:	57fd                	li	a5,-1
 918:	04f50163          	beq	a0,a5,95a <uniq_run+0x94>
 91c:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 91e:	ed21                	bnez	a0,976 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 920:	45813083          	ld	ra,1112(sp)
 924:	45013403          	ld	s0,1104(sp)
 928:	44813483          	ld	s1,1096(sp)
 92c:	44013903          	ld	s2,1088(sp)
 930:	43813983          	ld	s3,1080(sp)
 934:	43013a03          	ld	s4,1072(sp)
 938:	42813a83          	ld	s5,1064(sp)
 93c:	42013b03          	ld	s6,1056(sp)
 940:	41813b83          	ld	s7,1048(sp)
 944:	41013c03          	ld	s8,1040(sp)
 948:	40813c83          	ld	s9,1032(sp)
 94c:	40013d03          	ld	s10,1024(sp)
 950:	3f813d83          	ld	s11,1016(sp)
 954:	46010113          	addi	sp,sp,1120
 958:	8082                	ret
    printf("[ERR] Error reading from the file ");
 95a:	00000517          	auipc	a0,0x0
 95e:	45e50513          	addi	a0,a0,1118 # db8 <digits+0x48>
 962:	00000097          	auipc	ra,0x0
 966:	d3e080e7          	jalr	-706(ra) # 6a0 <printf>
 96a:	bf5d                	j	920 <uniq_run+0x5a>
 96c:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 96e:	8926                	mv	s2,s1
 970:	84be                	mv	s1,a5
        lineCount = 1;
 972:	8b6a                	mv	s6,s10
 974:	a8ed                	j	a6e <uniq_run+0x1a8>
    int lineCount=1;
 976:	4b05                	li	s6,1
  char * line2 = buffer2;
 978:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 97c:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 980:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 982:	4d05                	li	s10,1
              printf("%s",line1);
 984:	00000d97          	auipc	s11,0x0
 988:	42cd8d93          	addi	s11,s11,1068 # db0 <digits+0x40>
 98c:	a0cd                	j	a6e <uniq_run+0x1a8>
            if (repeatedLines){
 98e:	020a0b63          	beqz	s4,9c4 <uniq_run+0xfe>
                if (isRepeated){
 992:	f80b87e3          	beqz	s7,920 <uniq_run+0x5a>
                    if (showCount)
 996:	000c0d63          	beqz	s8,9b0 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 99a:	864a                	mv	a2,s2
 99c:	85da                	mv	a1,s6
 99e:	00000517          	auipc	a0,0x0
 9a2:	44250513          	addi	a0,a0,1090 # de0 <digits+0x70>
 9a6:	00000097          	auipc	ra,0x0
 9aa:	cfa080e7          	jalr	-774(ra) # 6a0 <printf>
 9ae:	bf8d                	j	920 <uniq_run+0x5a>
                      printf("%s",line1);
 9b0:	85ca                	mv	a1,s2
 9b2:	00000517          	auipc	a0,0x0
 9b6:	3fe50513          	addi	a0,a0,1022 # db0 <digits+0x40>
 9ba:	00000097          	auipc	ra,0x0
 9be:	ce6080e7          	jalr	-794(ra) # 6a0 <printf>
 9c2:	bfb9                	j	920 <uniq_run+0x5a>
                if (showCount)
 9c4:	000c0d63          	beqz	s8,9de <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 9c8:	864a                	mv	a2,s2
 9ca:	85da                	mv	a1,s6
 9cc:	00000517          	auipc	a0,0x0
 9d0:	41450513          	addi	a0,a0,1044 # de0 <digits+0x70>
 9d4:	00000097          	auipc	ra,0x0
 9d8:	ccc080e7          	jalr	-820(ra) # 6a0 <printf>
 9dc:	b791                	j	920 <uniq_run+0x5a>
                  printf("%s",line1);
 9de:	85ca                	mv	a1,s2
 9e0:	00000517          	auipc	a0,0x0
 9e4:	3d050513          	addi	a0,a0,976 # db0 <digits+0x40>
 9e8:	00000097          	auipc	ra,0x0
 9ec:	cb8080e7          	jalr	-840(ra) # 6a0 <printf>
 9f0:	bf05                	j	920 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 9f2:	00000517          	auipc	a0,0x0
 9f6:	3f650513          	addi	a0,a0,1014 # de8 <digits+0x78>
 9fa:	00000097          	auipc	ra,0x0
 9fe:	ca6080e7          	jalr	-858(ra) # 6a0 <printf>
          break;
 a02:	bf39                	j	920 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 a04:	85a6                	mv	a1,s1
 a06:	854a                	mv	a0,s2
 a08:	00000097          	auipc	ra,0x0
 a0c:	110080e7          	jalr	272(ra) # b18 <compare_str_ic>
 a10:	a041                	j	a90 <uniq_run+0x1ca>
                  printf("%s",line1);
 a12:	85ca                	mv	a1,s2
 a14:	856e                	mv	a0,s11
 a16:	00000097          	auipc	ra,0x0
 a1a:	c8a080e7          	jalr	-886(ra) # 6a0 <printf>
        lineCount = 1;
 a1e:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 a20:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a22:	8926                	mv	s2,s1
                  printf("%s",line1);
 a24:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a26:	4b81                	li	s7,0
 a28:	a099                	j	a6e <uniq_run+0x1a8>
            if (showCount)
 a2a:	020c0263          	beqz	s8,a4e <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 a2e:	864a                	mv	a2,s2
 a30:	85da                	mv	a1,s6
 a32:	00000517          	auipc	a0,0x0
 a36:	3ae50513          	addi	a0,a0,942 # de0 <digits+0x70>
 a3a:	00000097          	auipc	ra,0x0
 a3e:	c66080e7          	jalr	-922(ra) # 6a0 <printf>
 a42:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a44:	8926                	mv	s2,s1
 a46:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a48:	4b81                	li	s7,0
        lineCount = 1;
 a4a:	8b6a                	mv	s6,s10
 a4c:	a00d                	j	a6e <uniq_run+0x1a8>
              printf("%s",line1);
 a4e:	85ca                	mv	a1,s2
 a50:	856e                	mv	a0,s11
 a52:	00000097          	auipc	ra,0x0
 a56:	c4e080e7          	jalr	-946(ra) # 6a0 <printf>
 a5a:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a5c:	8926                	mv	s2,s1
              printf("%s",line1);
 a5e:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a60:	4b81                	li	s7,0
        lineCount = 1;
 a62:	8b6a                	mv	s6,s10
 a64:	a029                	j	a6e <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 a66:	000a0363          	beqz	s4,a6c <uniq_run+0x1a6>
 a6a:	8bea                	mv	s7,s10
          lineCount++;
 a6c:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 a6e:	85a6                	mv	a1,s1
 a70:	854e                	mv	a0,s3
 a72:	00000097          	auipc	ra,0x0
 a76:	196080e7          	jalr	406(ra) # c08 <read_line>
        if (readStatus == READ_EOF){
 a7a:	d911                	beqz	a0,98e <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 a7c:	f7950be3          	beq	a0,s9,9f2 <uniq_run+0x12c>
        if (!ignoreCase)
 a80:	f80a92e3          	bnez	s5,a04 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 a84:	85a6                	mv	a1,s1
 a86:	854a                	mv	a0,s2
 a88:	00000097          	auipc	ra,0x0
 a8c:	062080e7          	jalr	98(ra) # aea <compare_str>
        if (compareStatus != 0){ 
 a90:	d979                	beqz	a0,a66 <uniq_run+0x1a0>
          if (repeatedLines){
 a92:	f80a0ce3          	beqz	s4,a2a <uniq_run+0x164>
            if (isRepeated){
 a96:	ec0b8be3          	beqz	s7,96c <uniq_run+0xa6>
                if (showCount)
 a9a:	f60c0ce3          	beqz	s8,a12 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 a9e:	864a                	mv	a2,s2
 aa0:	85da                	mv	a1,s6
 aa2:	00000517          	auipc	a0,0x0
 aa6:	33e50513          	addi	a0,a0,830 # de0 <digits+0x70>
 aaa:	00000097          	auipc	ra,0x0
 aae:	bf6080e7          	jalr	-1034(ra) # 6a0 <printf>
        lineCount = 1;
 ab2:	8b5e                	mv	s6,s7
 ab4:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 ab6:	8926                	mv	s2,s1
 ab8:	84be                	mv	s1,a5
        isRepeated = 0 ;
 aba:	4b81                	li	s7,0
 abc:	bf4d                	j	a6e <uniq_run+0x1a8>

0000000000000abe <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 abe:	1141                	addi	sp,sp,-16
 ac0:	e422                	sd	s0,8(sp)
 ac2:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 ac4:	00054783          	lbu	a5,0(a0)
 ac8:	cf99                	beqz	a5,ae6 <get_strlen+0x28>
 aca:	00150713          	addi	a4,a0,1
 ace:	87ba                	mv	a5,a4
 ad0:	4685                	li	a3,1
 ad2:	9e99                	subw	a3,a3,a4
 ad4:	00f6853b          	addw	a0,a3,a5
 ad8:	0785                	addi	a5,a5,1
 ada:	fff7c703          	lbu	a4,-1(a5)
 ade:	fb7d                	bnez	a4,ad4 <get_strlen+0x16>
	return len;
}
 ae0:	6422                	ld	s0,8(sp)
 ae2:	0141                	addi	sp,sp,16
 ae4:	8082                	ret
	int len = 0;
 ae6:	4501                	li	a0,0
 ae8:	bfe5                	j	ae0 <get_strlen+0x22>

0000000000000aea <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 aea:	1141                	addi	sp,sp,-16
 aec:	e422                	sd	s0,8(sp)
 aee:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 af0:	00054783          	lbu	a5,0(a0)
 af4:	cb91                	beqz	a5,b08 <compare_str+0x1e>
 af6:	0005c703          	lbu	a4,0(a1)
 afa:	c719                	beqz	a4,b08 <compare_str+0x1e>
		if (*s1++ != *s2++)
 afc:	0505                	addi	a0,a0,1
 afe:	0585                	addi	a1,a1,1
 b00:	fee788e3          	beq	a5,a4,af0 <compare_str+0x6>
			return 1;
 b04:	4505                	li	a0,1
 b06:	a031                	j	b12 <compare_str+0x28>
	}
	if (*s1 == *s2)
 b08:	0005c503          	lbu	a0,0(a1)
 b0c:	8d1d                	sub	a0,a0,a5
			return 1;
 b0e:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b12:	6422                	ld	s0,8(sp)
 b14:	0141                	addi	sp,sp,16
 b16:	8082                	ret

0000000000000b18 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 b18:	1141                	addi	sp,sp,-16
 b1a:	e422                	sd	s0,8(sp)
 b1c:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b1e:	4665                	li	a2,25
	while(*s1 && *s2){
 b20:	a019                	j	b26 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b22:	04e79763          	bne	a5,a4,b70 <compare_str_ic+0x58>
	while(*s1 && *s2){
 b26:	00054783          	lbu	a5,0(a0)
 b2a:	cb9d                	beqz	a5,b60 <compare_str_ic+0x48>
 b2c:	0005c703          	lbu	a4,0(a1)
 b30:	cb05                	beqz	a4,b60 <compare_str_ic+0x48>
		char b1 = *s1++;
 b32:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 b34:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b36:	fbf7869b          	addiw	a3,a5,-65
 b3a:	0ff6f693          	zext.b	a3,a3
 b3e:	00d66663          	bltu	a2,a3,b4a <compare_str_ic+0x32>
			b1 += 32;
 b42:	0207879b          	addiw	a5,a5,32
 b46:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 b4a:	fbf7069b          	addiw	a3,a4,-65
 b4e:	0ff6f693          	zext.b	a3,a3
 b52:	fcd668e3          	bltu	a2,a3,b22 <compare_str_ic+0xa>
			b2 += 32;
 b56:	0207071b          	addiw	a4,a4,32
 b5a:	0ff77713          	zext.b	a4,a4
 b5e:	b7d1                	j	b22 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 b60:	0005c503          	lbu	a0,0(a1)
 b64:	8d1d                	sub	a0,a0,a5
			return 1;
 b66:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b6a:	6422                	ld	s0,8(sp)
 b6c:	0141                	addi	sp,sp,16
 b6e:	8082                	ret
			return 1;
 b70:	4505                	li	a0,1
 b72:	bfe5                	j	b6a <compare_str_ic+0x52>

0000000000000b74 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 b74:	7179                	addi	sp,sp,-48
 b76:	f406                	sd	ra,40(sp)
 b78:	f022                	sd	s0,32(sp)
 b7a:	ec26                	sd	s1,24(sp)
 b7c:	e84a                	sd	s2,16(sp)
 b7e:	e44e                	sd	s3,8(sp)
 b80:	1800                	addi	s0,sp,48
 b82:	89aa                	mv	s3,a0
 b84:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 b86:	00000097          	auipc	ra,0x0
 b8a:	f38080e7          	jalr	-200(ra) # abe <get_strlen>
 b8e:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 b90:	854a                	mv	a0,s2
 b92:	00000097          	auipc	ra,0x0
 b96:	f2c080e7          	jalr	-212(ra) # abe <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 b9a:	409505bb          	subw	a1,a0,s1
 b9e:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 ba0:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 ba2:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 ba4:	0005da63          	bgez	a1,bb8 <check_substr+0x44>
 ba8:	a81d                	j	bde <check_substr+0x6a>
        if (j == M)
 baa:	02f48a63          	beq	s1,a5,bde <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 bae:	0885                	addi	a7,a7,1
 bb0:	0008879b          	sext.w	a5,a7
 bb4:	02f5cc63          	blt	a1,a5,bec <check_substr+0x78>
 bb8:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 bbc:	011906b3          	add	a3,s2,a7
 bc0:	874e                	mv	a4,s3
 bc2:	879a                	mv	a5,t1
 bc4:	fe9053e3          	blez	s1,baa <check_substr+0x36>
            if (s2[i + j] != s1[j])
 bc8:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 bcc:	00074603          	lbu	a2,0(a4)
 bd0:	fcc81de3          	bne	a6,a2,baa <check_substr+0x36>
        for (j = 0; j < M; j++)
 bd4:	2785                	addiw	a5,a5,1
 bd6:	0685                	addi	a3,a3,1
 bd8:	0705                	addi	a4,a4,1
 bda:	fef497e3          	bne	s1,a5,bc8 <check_substr+0x54>
}
 bde:	70a2                	ld	ra,40(sp)
 be0:	7402                	ld	s0,32(sp)
 be2:	64e2                	ld	s1,24(sp)
 be4:	6942                	ld	s2,16(sp)
 be6:	69a2                	ld	s3,8(sp)
 be8:	6145                	addi	sp,sp,48
 bea:	8082                	ret
    return -1;
 bec:	557d                	li	a0,-1
 bee:	bfc5                	j	bde <check_substr+0x6a>

0000000000000bf0 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 bf0:	1141                	addi	sp,sp,-16
 bf2:	e406                	sd	ra,8(sp)
 bf4:	e022                	sd	s0,0(sp)
 bf6:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 bf8:	fffff097          	auipc	ra,0xfffff
 bfc:	72e080e7          	jalr	1838(ra) # 326 <open>
	return fd;
}
 c00:	60a2                	ld	ra,8(sp)
 c02:	6402                	ld	s0,0(sp)
 c04:	0141                	addi	sp,sp,16
 c06:	8082                	ret

0000000000000c08 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 c08:	7139                	addi	sp,sp,-64
 c0a:	fc06                	sd	ra,56(sp)
 c0c:	f822                	sd	s0,48(sp)
 c0e:	f426                	sd	s1,40(sp)
 c10:	f04a                	sd	s2,32(sp)
 c12:	ec4e                	sd	s3,24(sp)
 c14:	e852                	sd	s4,16(sp)
 c16:	0080                	addi	s0,sp,64
 c18:	89aa                	mv	s3,a0
 c1a:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c1c:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 c1e:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c20:	4605                	li	a2,1
 c22:	fcf40593          	addi	a1,s0,-49
 c26:	854e                	mv	a0,s3
 c28:	fffff097          	auipc	ra,0xfffff
 c2c:	6d6080e7          	jalr	1750(ra) # 2fe <read>
		if (readStatus == 0){
 c30:	c505                	beqz	a0,c58 <read_line+0x50>
		*buffer++ = readByte;
 c32:	0485                	addi	s1,s1,1
 c34:	fcf44783          	lbu	a5,-49(s0)
 c38:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c3c:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c3e:	ff4791e3          	bne	a5,s4,c20 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c42:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 c46:	854a                	mv	a0,s2
 c48:	70e2                	ld	ra,56(sp)
 c4a:	7442                	ld	s0,48(sp)
 c4c:	74a2                	ld	s1,40(sp)
 c4e:	7902                	ld	s2,32(sp)
 c50:	69e2                	ld	s3,24(sp)
 c52:	6a42                	ld	s4,16(sp)
 c54:	6121                	addi	sp,sp,64
 c56:	8082                	ret
			if (byteCount!=0){
 c58:	fe0907e3          	beqz	s2,c46 <read_line+0x3e>
				*buffer = '\n';
 c5c:	47a9                	li	a5,10
 c5e:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 c62:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 c66:	2905                	addiw	s2,s2,1
 c68:	bff9                	j	c46 <read_line+0x3e>

0000000000000c6a <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c6a:	1141                	addi	sp,sp,-16
 c6c:	e406                	sd	ra,8(sp)
 c6e:	e022                	sd	s0,0(sp)
 c70:	0800                	addi	s0,sp,16
	close(fd);
 c72:	fffff097          	auipc	ra,0xfffff
 c76:	69c080e7          	jalr	1692(ra) # 30e <close>
}
 c7a:	60a2                	ld	ra,8(sp)
 c7c:	6402                	ld	s0,0(sp)
 c7e:	0141                	addi	sp,sp,16
 c80:	8082                	ret

0000000000000c82 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 c82:	7139                	addi	sp,sp,-64
 c84:	fc06                	sd	ra,56(sp)
 c86:	f822                	sd	s0,48(sp)
 c88:	f426                	sd	s1,40(sp)
 c8a:	f04a                	sd	s2,32(sp)
 c8c:	0080                	addi	s0,sp,64
 c8e:	84aa                	mv	s1,a0
 c90:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 c92:	fffff097          	auipc	ra,0xfffff
 c96:	64c080e7          	jalr	1612(ra) # 2de <fork>
 c9a:	ed19                	bnez	a0,cb8 <get_time_perf+0x36>
		exec(argv[0],argv);
 c9c:	85ca                	mv	a1,s2
 c9e:	00093503          	ld	a0,0(s2)
 ca2:	fffff097          	auipc	ra,0xfffff
 ca6:	67c080e7          	jalr	1660(ra) # 31e <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 caa:	8526                	mv	a0,s1
 cac:	70e2                	ld	ra,56(sp)
 cae:	7442                	ld	s0,48(sp)
 cb0:	74a2                	ld	s1,40(sp)
 cb2:	7902                	ld	s2,32(sp)
 cb4:	6121                	addi	sp,sp,64
 cb6:	8082                	ret
		times(pid , &time);
 cb8:	fc040593          	addi	a1,s0,-64
 cbc:	fffff097          	auipc	ra,0xfffff
 cc0:	6e2080e7          	jalr	1762(ra) # 39e <times>
		return time;
 cc4:	fc043783          	ld	a5,-64(s0)
 cc8:	e09c                	sd	a5,0(s1)
 cca:	fc843783          	ld	a5,-56(s0)
 cce:	e49c                	sd	a5,8(s1)
 cd0:	fd043783          	ld	a5,-48(s0)
 cd4:	e89c                	sd	a5,16(s1)
 cd6:	fd843783          	ld	a5,-40(s0)
 cda:	ec9c                	sd	a5,24(s1)
 cdc:	b7f9                	j	caa <get_time_perf+0x28>
