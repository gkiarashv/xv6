
user/_echo:     file format elf64-littleriscv


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
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	06a7d463          	bge	a5,a0,7a <main+0x7a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	02099793          	slli	a5,s3,0x20
  22:	01d7d993          	srli	s3,a5,0x1d
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	ce6a0a13          	addi	s4,s4,-794 # d10 <get_time_perf+0x6a>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	0ae080e7          	jalr	174(ra) # e6 <strlen>
  40:	0005061b          	sext.w	a2,a0
  44:	85ca                	mv	a1,s2
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	2e2080e7          	jalr	738(ra) # 32a <write>
    if(i + 1 < argc){
  50:	04a1                	addi	s1,s1,8
  52:	01348a63          	beq	s1,s3,66 <main+0x66>
      write(1, " ", 1);
  56:	4605                	li	a2,1
  58:	85d2                	mv	a1,s4
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2ce080e7          	jalr	718(ra) # 32a <write>
  for(i = 1; i < argc; i++){
  64:	b7f9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	cb058593          	addi	a1,a1,-848 # d18 <get_time_perf+0x72>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	2b8080e7          	jalr	696(ra) # 32a <write>
    }
  }
  exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	28e080e7          	jalr	654(ra) # 30a <exit>

0000000000000084 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  8c:	00000097          	auipc	ra,0x0
  90:	f74080e7          	jalr	-140(ra) # 0 <main>
  exit(0);
  94:	4501                	li	a0,0
  96:	00000097          	auipc	ra,0x0
  9a:	274080e7          	jalr	628(ra) # 30a <exit>

000000000000009e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a4:	87aa                	mv	a5,a0
  a6:	0585                	addi	a1,a1,1
  a8:	0785                	addi	a5,a5,1
  aa:	fff5c703          	lbu	a4,-1(a1)
  ae:	fee78fa3          	sb	a4,-1(a5)
  b2:	fb75                	bnez	a4,a6 <strcpy+0x8>
    ;
  return os;
}
  b4:	6422                	ld	s0,8(sp)
  b6:	0141                	addi	sp,sp,16
  b8:	8082                	ret

00000000000000ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ba:	1141                	addi	sp,sp,-16
  bc:	e422                	sd	s0,8(sp)
  be:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	cb91                	beqz	a5,d8 <strcmp+0x1e>
  c6:	0005c703          	lbu	a4,0(a1)
  ca:	00f71763          	bne	a4,a5,d8 <strcmp+0x1e>
    p++, q++;
  ce:	0505                	addi	a0,a0,1
  d0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	fbe5                	bnez	a5,c6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d8:	0005c503          	lbu	a0,0(a1)
}
  dc:	40a7853b          	subw	a0,a5,a0
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret

00000000000000e6 <strlen>:

uint
strlen(const char *s)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e422                	sd	s0,8(sp)
  ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ec:	00054783          	lbu	a5,0(a0)
  f0:	cf91                	beqz	a5,10c <strlen+0x26>
  f2:	0505                	addi	a0,a0,1
  f4:	87aa                	mv	a5,a0
  f6:	4685                	li	a3,1
  f8:	9e89                	subw	a3,a3,a0
  fa:	00f6853b          	addw	a0,a3,a5
  fe:	0785                	addi	a5,a5,1
 100:	fff7c703          	lbu	a4,-1(a5)
 104:	fb7d                	bnez	a4,fa <strlen+0x14>
    ;
  return n;
}
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret
  for(n = 0; s[n]; n++)
 10c:	4501                	li	a0,0
 10e:	bfe5                	j	106 <strlen+0x20>

0000000000000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 116:	ca19                	beqz	a2,12c <memset+0x1c>
 118:	87aa                	mv	a5,a0
 11a:	1602                	slli	a2,a2,0x20
 11c:	9201                	srli	a2,a2,0x20
 11e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 122:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 126:	0785                	addi	a5,a5,1
 128:	fee79de3          	bne	a5,a4,122 <memset+0x12>
  }
  return dst;
}
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strchr>:

char*
strchr(const char *s, char c)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  for(; *s; s++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cb99                	beqz	a5,152 <strchr+0x20>
    if(*s == c)
 13e:	00f58763          	beq	a1,a5,14c <strchr+0x1a>
  for(; *s; s++)
 142:	0505                	addi	a0,a0,1
 144:	00054783          	lbu	a5,0(a0)
 148:	fbfd                	bnez	a5,13e <strchr+0xc>
      return (char*)s;
  return 0;
 14a:	4501                	li	a0,0
}
 14c:	6422                	ld	s0,8(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret
  return 0;
 152:	4501                	li	a0,0
 154:	bfe5                	j	14c <strchr+0x1a>

0000000000000156 <gets>:

char*
gets(char *buf, int max)
{
 156:	711d                	addi	sp,sp,-96
 158:	ec86                	sd	ra,88(sp)
 15a:	e8a2                	sd	s0,80(sp)
 15c:	e4a6                	sd	s1,72(sp)
 15e:	e0ca                	sd	s2,64(sp)
 160:	fc4e                	sd	s3,56(sp)
 162:	f852                	sd	s4,48(sp)
 164:	f456                	sd	s5,40(sp)
 166:	f05a                	sd	s6,32(sp)
 168:	ec5e                	sd	s7,24(sp)
 16a:	1080                	addi	s0,sp,96
 16c:	8baa                	mv	s7,a0
 16e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 170:	892a                	mv	s2,a0
 172:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 174:	4aa9                	li	s5,10
 176:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 178:	89a6                	mv	s3,s1
 17a:	2485                	addiw	s1,s1,1
 17c:	0344d863          	bge	s1,s4,1ac <gets+0x56>
    cc = read(0, &c, 1);
 180:	4605                	li	a2,1
 182:	faf40593          	addi	a1,s0,-81
 186:	4501                	li	a0,0
 188:	00000097          	auipc	ra,0x0
 18c:	19a080e7          	jalr	410(ra) # 322 <read>
    if(cc < 1)
 190:	00a05e63          	blez	a0,1ac <gets+0x56>
    buf[i++] = c;
 194:	faf44783          	lbu	a5,-81(s0)
 198:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 19c:	01578763          	beq	a5,s5,1aa <gets+0x54>
 1a0:	0905                	addi	s2,s2,1
 1a2:	fd679be3          	bne	a5,s6,178 <gets+0x22>
  for(i=0; i+1 < max; ){
 1a6:	89a6                	mv	s3,s1
 1a8:	a011                	j	1ac <gets+0x56>
 1aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1ac:	99de                	add	s3,s3,s7
 1ae:	00098023          	sb	zero,0(s3)
  return buf;
}
 1b2:	855e                	mv	a0,s7
 1b4:	60e6                	ld	ra,88(sp)
 1b6:	6446                	ld	s0,80(sp)
 1b8:	64a6                	ld	s1,72(sp)
 1ba:	6906                	ld	s2,64(sp)
 1bc:	79e2                	ld	s3,56(sp)
 1be:	7a42                	ld	s4,48(sp)
 1c0:	7aa2                	ld	s5,40(sp)
 1c2:	7b02                	ld	s6,32(sp)
 1c4:	6be2                	ld	s7,24(sp)
 1c6:	6125                	addi	sp,sp,96
 1c8:	8082                	ret

00000000000001ca <stat>:

int
stat(const char *n, struct stat *st)
{
 1ca:	1101                	addi	sp,sp,-32
 1cc:	ec06                	sd	ra,24(sp)
 1ce:	e822                	sd	s0,16(sp)
 1d0:	e426                	sd	s1,8(sp)
 1d2:	e04a                	sd	s2,0(sp)
 1d4:	1000                	addi	s0,sp,32
 1d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d8:	4581                	li	a1,0
 1da:	00000097          	auipc	ra,0x0
 1de:	170080e7          	jalr	368(ra) # 34a <open>
  if(fd < 0)
 1e2:	02054563          	bltz	a0,20c <stat+0x42>
 1e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e8:	85ca                	mv	a1,s2
 1ea:	00000097          	auipc	ra,0x0
 1ee:	178080e7          	jalr	376(ra) # 362 <fstat>
 1f2:	892a                	mv	s2,a0
  close(fd);
 1f4:	8526                	mv	a0,s1
 1f6:	00000097          	auipc	ra,0x0
 1fa:	13c080e7          	jalr	316(ra) # 332 <close>
  return r;
}
 1fe:	854a                	mv	a0,s2
 200:	60e2                	ld	ra,24(sp)
 202:	6442                	ld	s0,16(sp)
 204:	64a2                	ld	s1,8(sp)
 206:	6902                	ld	s2,0(sp)
 208:	6105                	addi	sp,sp,32
 20a:	8082                	ret
    return -1;
 20c:	597d                	li	s2,-1
 20e:	bfc5                	j	1fe <stat+0x34>

0000000000000210 <atoi>:

int
atoi(const char *s)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 216:	00054683          	lbu	a3,0(a0)
 21a:	fd06879b          	addiw	a5,a3,-48
 21e:	0ff7f793          	zext.b	a5,a5
 222:	4625                	li	a2,9
 224:	02f66863          	bltu	a2,a5,254 <atoi+0x44>
 228:	872a                	mv	a4,a0
  n = 0;
 22a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 22c:	0705                	addi	a4,a4,1
 22e:	0025179b          	slliw	a5,a0,0x2
 232:	9fa9                	addw	a5,a5,a0
 234:	0017979b          	slliw	a5,a5,0x1
 238:	9fb5                	addw	a5,a5,a3
 23a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 23e:	00074683          	lbu	a3,0(a4)
 242:	fd06879b          	addiw	a5,a3,-48
 246:	0ff7f793          	zext.b	a5,a5
 24a:	fef671e3          	bgeu	a2,a5,22c <atoi+0x1c>
  return n;
}
 24e:	6422                	ld	s0,8(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret
  n = 0;
 254:	4501                	li	a0,0
 256:	bfe5                	j	24e <atoi+0x3e>

0000000000000258 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25e:	02b57463          	bgeu	a0,a1,286 <memmove+0x2e>
    while(n-- > 0)
 262:	00c05f63          	blez	a2,280 <memmove+0x28>
 266:	1602                	slli	a2,a2,0x20
 268:	9201                	srli	a2,a2,0x20
 26a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 26e:	872a                	mv	a4,a0
      *dst++ = *src++;
 270:	0585                	addi	a1,a1,1
 272:	0705                	addi	a4,a4,1
 274:	fff5c683          	lbu	a3,-1(a1)
 278:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 27c:	fee79ae3          	bne	a5,a4,270 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 280:	6422                	ld	s0,8(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
    dst += n;
 286:	00c50733          	add	a4,a0,a2
    src += n;
 28a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 28c:	fec05ae3          	blez	a2,280 <memmove+0x28>
 290:	fff6079b          	addiw	a5,a2,-1
 294:	1782                	slli	a5,a5,0x20
 296:	9381                	srli	a5,a5,0x20
 298:	fff7c793          	not	a5,a5
 29c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29e:	15fd                	addi	a1,a1,-1
 2a0:	177d                	addi	a4,a4,-1
 2a2:	0005c683          	lbu	a3,0(a1)
 2a6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2aa:	fee79ae3          	bne	a5,a4,29e <memmove+0x46>
 2ae:	bfc9                	j	280 <memmove+0x28>

00000000000002b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e422                	sd	s0,8(sp)
 2b4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b6:	ca05                	beqz	a2,2e6 <memcmp+0x36>
 2b8:	fff6069b          	addiw	a3,a2,-1
 2bc:	1682                	slli	a3,a3,0x20
 2be:	9281                	srli	a3,a3,0x20
 2c0:	0685                	addi	a3,a3,1
 2c2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	00e79863          	bne	a5,a4,2dc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2d0:	0505                	addi	a0,a0,1
    p2++;
 2d2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d4:	fed518e3          	bne	a0,a3,2c4 <memcmp+0x14>
  }
  return 0;
 2d8:	4501                	li	a0,0
 2da:	a019                	j	2e0 <memcmp+0x30>
      return *p1 - *p2;
 2dc:	40e7853b          	subw	a0,a5,a4
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	bfe5                	j	2e0 <memcmp+0x30>

00000000000002ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f2:	00000097          	auipc	ra,0x0
 2f6:	f66080e7          	jalr	-154(ra) # 258 <memmove>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 302:	4885                	li	a7,1
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <exit>:
.global exit
exit:
 li a7, SYS_exit
 30a:	4889                	li	a7,2
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <wait>:
.global wait
wait:
 li a7, SYS_wait
 312:	488d                	li	a7,3
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31a:	4891                	li	a7,4
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <read>:
.global read
read:
 li a7, SYS_read
 322:	4895                	li	a7,5
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <write>:
.global write
write:
 li a7, SYS_write
 32a:	48c1                	li	a7,16
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <close>:
.global close
close:
 li a7, SYS_close
 332:	48d5                	li	a7,21
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <kill>:
.global kill
kill:
 li a7, SYS_kill
 33a:	4899                	li	a7,6
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <exec>:
.global exec
exec:
 li a7, SYS_exec
 342:	489d                	li	a7,7
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <open>:
.global open
open:
 li a7, SYS_open
 34a:	48bd                	li	a7,15
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 352:	48c5                	li	a7,17
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35a:	48c9                	li	a7,18
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 362:	48a1                	li	a7,8
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <link>:
.global link
link:
 li a7, SYS_link
 36a:	48cd                	li	a7,19
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 372:	48d1                	li	a7,20
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37a:	48a5                	li	a7,9
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <dup>:
.global dup
dup:
 li a7, SYS_dup
 382:	48a9                	li	a7,10
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38a:	48ad                	li	a7,11
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 392:	48b1                	li	a7,12
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 39a:	48b5                	li	a7,13
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a2:	48b9                	li	a7,14
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <head>:
.global head
head:
 li a7, SYS_head
 3aa:	48d9                	li	a7,22
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 3b2:	48dd                	li	a7,23
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <ps>:
.global ps
ps:
 li a7, SYS_ps
 3ba:	48e1                	li	a7,24
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <times>:
.global times
times:
 li a7, SYS_times
 3c2:	48e5                	li	a7,25
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 3ca:	48e9                	li	a7,26
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 3d2:	48ed                	li	a7,27
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 3da:	48f1                	li	a7,28
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 3e2:	48f5                	li	a7,29
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	1000                	addi	s0,sp,32
 3f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f6:	4605                	li	a2,1
 3f8:	fef40593          	addi	a1,s0,-17
 3fc:	00000097          	auipc	ra,0x0
 400:	f2e080e7          	jalr	-210(ra) # 32a <write>
}
 404:	60e2                	ld	ra,24(sp)
 406:	6442                	ld	s0,16(sp)
 408:	6105                	addi	sp,sp,32
 40a:	8082                	ret

000000000000040c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40c:	7139                	addi	sp,sp,-64
 40e:	fc06                	sd	ra,56(sp)
 410:	f822                	sd	s0,48(sp)
 412:	f426                	sd	s1,40(sp)
 414:	f04a                	sd	s2,32(sp)
 416:	ec4e                	sd	s3,24(sp)
 418:	0080                	addi	s0,sp,64
 41a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41c:	c299                	beqz	a3,422 <printint+0x16>
 41e:	0805c963          	bltz	a1,4b0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 422:	2581                	sext.w	a1,a1
  neg = 0;
 424:	4881                	li	a7,0
 426:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 42a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 42c:	2601                	sext.w	a2,a2
 42e:	00001517          	auipc	a0,0x1
 432:	95250513          	addi	a0,a0,-1710 # d80 <digits>
 436:	883a                	mv	a6,a4
 438:	2705                	addiw	a4,a4,1
 43a:	02c5f7bb          	remuw	a5,a1,a2
 43e:	1782                	slli	a5,a5,0x20
 440:	9381                	srli	a5,a5,0x20
 442:	97aa                	add	a5,a5,a0
 444:	0007c783          	lbu	a5,0(a5)
 448:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 44c:	0005879b          	sext.w	a5,a1
 450:	02c5d5bb          	divuw	a1,a1,a2
 454:	0685                	addi	a3,a3,1
 456:	fec7f0e3          	bgeu	a5,a2,436 <printint+0x2a>
  if(neg)
 45a:	00088c63          	beqz	a7,472 <printint+0x66>
    buf[i++] = '-';
 45e:	fd070793          	addi	a5,a4,-48
 462:	00878733          	add	a4,a5,s0
 466:	02d00793          	li	a5,45
 46a:	fef70823          	sb	a5,-16(a4)
 46e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 472:	02e05863          	blez	a4,4a2 <printint+0x96>
 476:	fc040793          	addi	a5,s0,-64
 47a:	00e78933          	add	s2,a5,a4
 47e:	fff78993          	addi	s3,a5,-1
 482:	99ba                	add	s3,s3,a4
 484:	377d                	addiw	a4,a4,-1
 486:	1702                	slli	a4,a4,0x20
 488:	9301                	srli	a4,a4,0x20
 48a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48e:	fff94583          	lbu	a1,-1(s2)
 492:	8526                	mv	a0,s1
 494:	00000097          	auipc	ra,0x0
 498:	f56080e7          	jalr	-170(ra) # 3ea <putc>
  while(--i >= 0)
 49c:	197d                	addi	s2,s2,-1
 49e:	ff3918e3          	bne	s2,s3,48e <printint+0x82>
}
 4a2:	70e2                	ld	ra,56(sp)
 4a4:	7442                	ld	s0,48(sp)
 4a6:	74a2                	ld	s1,40(sp)
 4a8:	7902                	ld	s2,32(sp)
 4aa:	69e2                	ld	s3,24(sp)
 4ac:	6121                	addi	sp,sp,64
 4ae:	8082                	ret
    x = -xx;
 4b0:	40b005bb          	negw	a1,a1
    neg = 1;
 4b4:	4885                	li	a7,1
    x = -xx;
 4b6:	bf85                	j	426 <printint+0x1a>

00000000000004b8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b8:	7119                	addi	sp,sp,-128
 4ba:	fc86                	sd	ra,120(sp)
 4bc:	f8a2                	sd	s0,112(sp)
 4be:	f4a6                	sd	s1,104(sp)
 4c0:	f0ca                	sd	s2,96(sp)
 4c2:	ecce                	sd	s3,88(sp)
 4c4:	e8d2                	sd	s4,80(sp)
 4c6:	e4d6                	sd	s5,72(sp)
 4c8:	e0da                	sd	s6,64(sp)
 4ca:	fc5e                	sd	s7,56(sp)
 4cc:	f862                	sd	s8,48(sp)
 4ce:	f466                	sd	s9,40(sp)
 4d0:	f06a                	sd	s10,32(sp)
 4d2:	ec6e                	sd	s11,24(sp)
 4d4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d6:	0005c903          	lbu	s2,0(a1)
 4da:	18090f63          	beqz	s2,678 <vprintf+0x1c0>
 4de:	8aaa                	mv	s5,a0
 4e0:	8b32                	mv	s6,a2
 4e2:	00158493          	addi	s1,a1,1
  state = 0;
 4e6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e8:	02500a13          	li	s4,37
 4ec:	4c55                	li	s8,21
 4ee:	00001c97          	auipc	s9,0x1
 4f2:	83ac8c93          	addi	s9,s9,-1990 # d28 <get_time_perf+0x82>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4f6:	02800d93          	li	s11,40
  putc(fd, 'x');
 4fa:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4fc:	00001b97          	auipc	s7,0x1
 500:	884b8b93          	addi	s7,s7,-1916 # d80 <digits>
 504:	a839                	j	522 <vprintf+0x6a>
        putc(fd, c);
 506:	85ca                	mv	a1,s2
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	ee0080e7          	jalr	-288(ra) # 3ea <putc>
 512:	a019                	j	518 <vprintf+0x60>
    } else if(state == '%'){
 514:	01498d63          	beq	s3,s4,52e <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 518:	0485                	addi	s1,s1,1
 51a:	fff4c903          	lbu	s2,-1(s1)
 51e:	14090d63          	beqz	s2,678 <vprintf+0x1c0>
    if(state == 0){
 522:	fe0999e3          	bnez	s3,514 <vprintf+0x5c>
      if(c == '%'){
 526:	ff4910e3          	bne	s2,s4,506 <vprintf+0x4e>
        state = '%';
 52a:	89d2                	mv	s3,s4
 52c:	b7f5                	j	518 <vprintf+0x60>
      if(c == 'd'){
 52e:	11490c63          	beq	s2,s4,646 <vprintf+0x18e>
 532:	f9d9079b          	addiw	a5,s2,-99
 536:	0ff7f793          	zext.b	a5,a5
 53a:	10fc6e63          	bltu	s8,a5,656 <vprintf+0x19e>
 53e:	f9d9079b          	addiw	a5,s2,-99
 542:	0ff7f713          	zext.b	a4,a5
 546:	10ec6863          	bltu	s8,a4,656 <vprintf+0x19e>
 54a:	00271793          	slli	a5,a4,0x2
 54e:	97e6                	add	a5,a5,s9
 550:	439c                	lw	a5,0(a5)
 552:	97e6                	add	a5,a5,s9
 554:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 556:	008b0913          	addi	s2,s6,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000b2583          	lw	a1,0(s6)
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	ea8080e7          	jalr	-344(ra) # 40c <printint>
 56c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 56e:	4981                	li	s3,0
 570:	b765                	j	518 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 572:	008b0913          	addi	s2,s6,8
 576:	4681                	li	a3,0
 578:	4629                	li	a2,10
 57a:	000b2583          	lw	a1,0(s6)
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	e8c080e7          	jalr	-372(ra) # 40c <printint>
 588:	8b4a                	mv	s6,s2
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b771                	j	518 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 58e:	008b0913          	addi	s2,s6,8
 592:	4681                	li	a3,0
 594:	866a                	mv	a2,s10
 596:	000b2583          	lw	a1,0(s6)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	e70080e7          	jalr	-400(ra) # 40c <printint>
 5a4:	8b4a                	mv	s6,s2
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	bf85                	j	518 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5aa:	008b0793          	addi	a5,s6,8
 5ae:	f8f43423          	sd	a5,-120(s0)
 5b2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5b6:	03000593          	li	a1,48
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e2e080e7          	jalr	-466(ra) # 3ea <putc>
  putc(fd, 'x');
 5c4:	07800593          	li	a1,120
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	e20080e7          	jalr	-480(ra) # 3ea <putc>
 5d2:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d4:	03c9d793          	srli	a5,s3,0x3c
 5d8:	97de                	add	a5,a5,s7
 5da:	0007c583          	lbu	a1,0(a5)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e0a080e7          	jalr	-502(ra) # 3ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e8:	0992                	slli	s3,s3,0x4
 5ea:	397d                	addiw	s2,s2,-1
 5ec:	fe0914e3          	bnez	s2,5d4 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5f0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b70d                	j	518 <vprintf+0x60>
        s = va_arg(ap, char*);
 5f8:	008b0913          	addi	s2,s6,8
 5fc:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 600:	02098163          	beqz	s3,622 <vprintf+0x16a>
        while(*s != 0){
 604:	0009c583          	lbu	a1,0(s3)
 608:	c5ad                	beqz	a1,672 <vprintf+0x1ba>
          putc(fd, *s);
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	dde080e7          	jalr	-546(ra) # 3ea <putc>
          s++;
 614:	0985                	addi	s3,s3,1
        while(*s != 0){
 616:	0009c583          	lbu	a1,0(s3)
 61a:	f9e5                	bnez	a1,60a <vprintf+0x152>
        s = va_arg(ap, char*);
 61c:	8b4a                	mv	s6,s2
      state = 0;
 61e:	4981                	li	s3,0
 620:	bde5                	j	518 <vprintf+0x60>
          s = "(null)";
 622:	00000997          	auipc	s3,0x0
 626:	6fe98993          	addi	s3,s3,1790 # d20 <get_time_perf+0x7a>
        while(*s != 0){
 62a:	85ee                	mv	a1,s11
 62c:	bff9                	j	60a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 62e:	008b0913          	addi	s2,s6,8
 632:	000b4583          	lbu	a1,0(s6)
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	db2080e7          	jalr	-590(ra) # 3ea <putc>
 640:	8b4a                	mv	s6,s2
      state = 0;
 642:	4981                	li	s3,0
 644:	bdd1                	j	518 <vprintf+0x60>
        putc(fd, c);
 646:	85d2                	mv	a1,s4
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	da0080e7          	jalr	-608(ra) # 3ea <putc>
      state = 0;
 652:	4981                	li	s3,0
 654:	b5d1                	j	518 <vprintf+0x60>
        putc(fd, '%');
 656:	85d2                	mv	a1,s4
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	d90080e7          	jalr	-624(ra) # 3ea <putc>
        putc(fd, c);
 662:	85ca                	mv	a1,s2
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	d84080e7          	jalr	-636(ra) # 3ea <putc>
      state = 0;
 66e:	4981                	li	s3,0
 670:	b565                	j	518 <vprintf+0x60>
        s = va_arg(ap, char*);
 672:	8b4a                	mv	s6,s2
      state = 0;
 674:	4981                	li	s3,0
 676:	b54d                	j	518 <vprintf+0x60>
    }
  }
}
 678:	70e6                	ld	ra,120(sp)
 67a:	7446                	ld	s0,112(sp)
 67c:	74a6                	ld	s1,104(sp)
 67e:	7906                	ld	s2,96(sp)
 680:	69e6                	ld	s3,88(sp)
 682:	6a46                	ld	s4,80(sp)
 684:	6aa6                	ld	s5,72(sp)
 686:	6b06                	ld	s6,64(sp)
 688:	7be2                	ld	s7,56(sp)
 68a:	7c42                	ld	s8,48(sp)
 68c:	7ca2                	ld	s9,40(sp)
 68e:	7d02                	ld	s10,32(sp)
 690:	6de2                	ld	s11,24(sp)
 692:	6109                	addi	sp,sp,128
 694:	8082                	ret

0000000000000696 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 696:	715d                	addi	sp,sp,-80
 698:	ec06                	sd	ra,24(sp)
 69a:	e822                	sd	s0,16(sp)
 69c:	1000                	addi	s0,sp,32
 69e:	e010                	sd	a2,0(s0)
 6a0:	e414                	sd	a3,8(s0)
 6a2:	e818                	sd	a4,16(s0)
 6a4:	ec1c                	sd	a5,24(s0)
 6a6:	03043023          	sd	a6,32(s0)
 6aa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ae:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b2:	8622                	mv	a2,s0
 6b4:	00000097          	auipc	ra,0x0
 6b8:	e04080e7          	jalr	-508(ra) # 4b8 <vprintf>
}
 6bc:	60e2                	ld	ra,24(sp)
 6be:	6442                	ld	s0,16(sp)
 6c0:	6161                	addi	sp,sp,80
 6c2:	8082                	ret

00000000000006c4 <printf>:

void
printf(const char *fmt, ...)
{
 6c4:	711d                	addi	sp,sp,-96
 6c6:	ec06                	sd	ra,24(sp)
 6c8:	e822                	sd	s0,16(sp)
 6ca:	1000                	addi	s0,sp,32
 6cc:	e40c                	sd	a1,8(s0)
 6ce:	e810                	sd	a2,16(s0)
 6d0:	ec14                	sd	a3,24(s0)
 6d2:	f018                	sd	a4,32(s0)
 6d4:	f41c                	sd	a5,40(s0)
 6d6:	03043823          	sd	a6,48(s0)
 6da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6de:	00840613          	addi	a2,s0,8
 6e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e6:	85aa                	mv	a1,a0
 6e8:	4505                	li	a0,1
 6ea:	00000097          	auipc	ra,0x0
 6ee:	dce080e7          	jalr	-562(ra) # 4b8 <vprintf>
}
 6f2:	60e2                	ld	ra,24(sp)
 6f4:	6442                	ld	s0,16(sp)
 6f6:	6125                	addi	sp,sp,96
 6f8:	8082                	ret

00000000000006fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fa:	1141                	addi	sp,sp,-16
 6fc:	e422                	sd	s0,8(sp)
 6fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 700:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 704:	00001797          	auipc	a5,0x1
 708:	8fc7b783          	ld	a5,-1796(a5) # 1000 <freep>
 70c:	a02d                	j	736 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70e:	4618                	lw	a4,8(a2)
 710:	9f2d                	addw	a4,a4,a1
 712:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 716:	6398                	ld	a4,0(a5)
 718:	6310                	ld	a2,0(a4)
 71a:	a83d                	j	758 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 71c:	ff852703          	lw	a4,-8(a0)
 720:	9f31                	addw	a4,a4,a2
 722:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 724:	ff053683          	ld	a3,-16(a0)
 728:	a091                	j	76c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72a:	6398                	ld	a4,0(a5)
 72c:	00e7e463          	bltu	a5,a4,734 <free+0x3a>
 730:	00e6ea63          	bltu	a3,a4,744 <free+0x4a>
{
 734:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 736:	fed7fae3          	bgeu	a5,a3,72a <free+0x30>
 73a:	6398                	ld	a4,0(a5)
 73c:	00e6e463          	bltu	a3,a4,744 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 740:	fee7eae3          	bltu	a5,a4,734 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 744:	ff852583          	lw	a1,-8(a0)
 748:	6390                	ld	a2,0(a5)
 74a:	02059813          	slli	a6,a1,0x20
 74e:	01c85713          	srli	a4,a6,0x1c
 752:	9736                	add	a4,a4,a3
 754:	fae60de3          	beq	a2,a4,70e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 758:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 75c:	4790                	lw	a2,8(a5)
 75e:	02061593          	slli	a1,a2,0x20
 762:	01c5d713          	srli	a4,a1,0x1c
 766:	973e                	add	a4,a4,a5
 768:	fae68ae3          	beq	a3,a4,71c <free+0x22>
    p->s.ptr = bp->s.ptr;
 76c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 76e:	00001717          	auipc	a4,0x1
 772:	88f73923          	sd	a5,-1902(a4) # 1000 <freep>
}
 776:	6422                	ld	s0,8(sp)
 778:	0141                	addi	sp,sp,16
 77a:	8082                	ret

000000000000077c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 77c:	7139                	addi	sp,sp,-64
 77e:	fc06                	sd	ra,56(sp)
 780:	f822                	sd	s0,48(sp)
 782:	f426                	sd	s1,40(sp)
 784:	f04a                	sd	s2,32(sp)
 786:	ec4e                	sd	s3,24(sp)
 788:	e852                	sd	s4,16(sp)
 78a:	e456                	sd	s5,8(sp)
 78c:	e05a                	sd	s6,0(sp)
 78e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 790:	02051493          	slli	s1,a0,0x20
 794:	9081                	srli	s1,s1,0x20
 796:	04bd                	addi	s1,s1,15
 798:	8091                	srli	s1,s1,0x4
 79a:	0014899b          	addiw	s3,s1,1
 79e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7a0:	00001517          	auipc	a0,0x1
 7a4:	86053503          	ld	a0,-1952(a0) # 1000 <freep>
 7a8:	c515                	beqz	a0,7d4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ac:	4798                	lw	a4,8(a5)
 7ae:	02977f63          	bgeu	a4,s1,7ec <malloc+0x70>
 7b2:	8a4e                	mv	s4,s3
 7b4:	0009871b          	sext.w	a4,s3
 7b8:	6685                	lui	a3,0x1
 7ba:	00d77363          	bgeu	a4,a3,7c0 <malloc+0x44>
 7be:	6a05                	lui	s4,0x1
 7c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c8:	00001917          	auipc	s2,0x1
 7cc:	83890913          	addi	s2,s2,-1992 # 1000 <freep>
  if(p == (char*)-1)
 7d0:	5afd                	li	s5,-1
 7d2:	a895                	j	846 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7d4:	00001797          	auipc	a5,0x1
 7d8:	83c78793          	addi	a5,a5,-1988 # 1010 <base>
 7dc:	00001717          	auipc	a4,0x1
 7e0:	82f73223          	sd	a5,-2012(a4) # 1000 <freep>
 7e4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ea:	b7e1                	j	7b2 <malloc+0x36>
      if(p->s.size == nunits)
 7ec:	02e48c63          	beq	s1,a4,824 <malloc+0xa8>
        p->s.size -= nunits;
 7f0:	4137073b          	subw	a4,a4,s3
 7f4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f6:	02071693          	slli	a3,a4,0x20
 7fa:	01c6d713          	srli	a4,a3,0x1c
 7fe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 800:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 804:	00000717          	auipc	a4,0x0
 808:	7ea73e23          	sd	a0,2044(a4) # 1000 <freep>
      return (void*)(p + 1);
 80c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 810:	70e2                	ld	ra,56(sp)
 812:	7442                	ld	s0,48(sp)
 814:	74a2                	ld	s1,40(sp)
 816:	7902                	ld	s2,32(sp)
 818:	69e2                	ld	s3,24(sp)
 81a:	6a42                	ld	s4,16(sp)
 81c:	6aa2                	ld	s5,8(sp)
 81e:	6b02                	ld	s6,0(sp)
 820:	6121                	addi	sp,sp,64
 822:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 824:	6398                	ld	a4,0(a5)
 826:	e118                	sd	a4,0(a0)
 828:	bff1                	j	804 <malloc+0x88>
  hp->s.size = nu;
 82a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 82e:	0541                	addi	a0,a0,16
 830:	00000097          	auipc	ra,0x0
 834:	eca080e7          	jalr	-310(ra) # 6fa <free>
  return freep;
 838:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 83c:	d971                	beqz	a0,810 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 840:	4798                	lw	a4,8(a5)
 842:	fa9775e3          	bgeu	a4,s1,7ec <malloc+0x70>
    if(p == freep)
 846:	00093703          	ld	a4,0(s2)
 84a:	853e                	mv	a0,a5
 84c:	fef719e3          	bne	a4,a5,83e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 850:	8552                	mv	a0,s4
 852:	00000097          	auipc	ra,0x0
 856:	b40080e7          	jalr	-1216(ra) # 392 <sbrk>
  if(p == (char*)-1)
 85a:	fd5518e3          	bne	a0,s5,82a <malloc+0xae>
        return 0;
 85e:	4501                	li	a0,0
 860:	bf45                	j	810 <malloc+0x94>

0000000000000862 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 862:	c1d9                	beqz	a1,8e8 <head_run+0x86>
void head_run(int fd, int numOfLines){
 864:	dd010113          	addi	sp,sp,-560
 868:	22113423          	sd	ra,552(sp)
 86c:	22813023          	sd	s0,544(sp)
 870:	20913c23          	sd	s1,536(sp)
 874:	21213823          	sd	s2,528(sp)
 878:	21313423          	sd	s3,520(sp)
 87c:	21413023          	sd	s4,512(sp)
 880:	1c00                	addi	s0,sp,560
 882:	892a                	mv	s2,a0
 884:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 888:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 88a:	00000a17          	auipc	s4,0x0
 88e:	536a0a13          	addi	s4,s4,1334 # dc0 <digits+0x40>
		readStatus = read_line(fd, line);
 892:	dd840593          	addi	a1,s0,-552
 896:	854a                	mv	a0,s2
 898:	00000097          	auipc	ra,0x0
 89c:	394080e7          	jalr	916(ra) # c2c <read_line>
		if (readStatus == READ_ERROR){
 8a0:	01350d63          	beq	a0,s3,8ba <head_run+0x58>
		if (readStatus == READ_EOF)
 8a4:	c11d                	beqz	a0,8ca <head_run+0x68>
		printf("%s",line);
 8a6:	dd840593          	addi	a1,s0,-552
 8aa:	8552                	mv	a0,s4
 8ac:	00000097          	auipc	ra,0x0
 8b0:	e18080e7          	jalr	-488(ra) # 6c4 <printf>
	while(numOfLines--){
 8b4:	34fd                	addiw	s1,s1,-1
 8b6:	fcf1                	bnez	s1,892 <head_run+0x30>
 8b8:	a809                	j	8ca <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 8ba:	00000517          	auipc	a0,0x0
 8be:	4de50513          	addi	a0,a0,1246 # d98 <digits+0x18>
 8c2:	00000097          	auipc	ra,0x0
 8c6:	e02080e7          	jalr	-510(ra) # 6c4 <printf>

	}
}
 8ca:	22813083          	ld	ra,552(sp)
 8ce:	22013403          	ld	s0,544(sp)
 8d2:	21813483          	ld	s1,536(sp)
 8d6:	21013903          	ld	s2,528(sp)
 8da:	20813983          	ld	s3,520(sp)
 8de:	20013a03          	ld	s4,512(sp)
 8e2:	23010113          	addi	sp,sp,560
 8e6:	8082                	ret
 8e8:	8082                	ret

00000000000008ea <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 8ea:	ba010113          	addi	sp,sp,-1120
 8ee:	44113c23          	sd	ra,1112(sp)
 8f2:	44813823          	sd	s0,1104(sp)
 8f6:	44913423          	sd	s1,1096(sp)
 8fa:	45213023          	sd	s2,1088(sp)
 8fe:	43313c23          	sd	s3,1080(sp)
 902:	43413823          	sd	s4,1072(sp)
 906:	43513423          	sd	s5,1064(sp)
 90a:	43613023          	sd	s6,1056(sp)
 90e:	41713c23          	sd	s7,1048(sp)
 912:	41813823          	sd	s8,1040(sp)
 916:	41913423          	sd	s9,1032(sp)
 91a:	41a13023          	sd	s10,1024(sp)
 91e:	3fb13c23          	sd	s11,1016(sp)
 922:	46010413          	addi	s0,sp,1120
 926:	89aa                	mv	s3,a0
 928:	8aae                	mv	s5,a1
 92a:	8c32                	mv	s8,a2
 92c:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 92e:	d9840593          	addi	a1,s0,-616
 932:	00000097          	auipc	ra,0x0
 936:	2fa080e7          	jalr	762(ra) # c2c <read_line>


  if (readStatus == READ_ERROR)
 93a:	57fd                	li	a5,-1
 93c:	04f50163          	beq	a0,a5,97e <uniq_run+0x94>
 940:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 942:	ed21                	bnez	a0,99a <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 944:	45813083          	ld	ra,1112(sp)
 948:	45013403          	ld	s0,1104(sp)
 94c:	44813483          	ld	s1,1096(sp)
 950:	44013903          	ld	s2,1088(sp)
 954:	43813983          	ld	s3,1080(sp)
 958:	43013a03          	ld	s4,1072(sp)
 95c:	42813a83          	ld	s5,1064(sp)
 960:	42013b03          	ld	s6,1056(sp)
 964:	41813b83          	ld	s7,1048(sp)
 968:	41013c03          	ld	s8,1040(sp)
 96c:	40813c83          	ld	s9,1032(sp)
 970:	40013d03          	ld	s10,1024(sp)
 974:	3f813d83          	ld	s11,1016(sp)
 978:	46010113          	addi	sp,sp,1120
 97c:	8082                	ret
    printf("[ERR] Error reading from the file ");
 97e:	00000517          	auipc	a0,0x0
 982:	44a50513          	addi	a0,a0,1098 # dc8 <digits+0x48>
 986:	00000097          	auipc	ra,0x0
 98a:	d3e080e7          	jalr	-706(ra) # 6c4 <printf>
 98e:	bf5d                	j	944 <uniq_run+0x5a>
 990:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 992:	8926                	mv	s2,s1
 994:	84be                	mv	s1,a5
        lineCount = 1;
 996:	8b6a                	mv	s6,s10
 998:	a8ed                	j	a92 <uniq_run+0x1a8>
    int lineCount=1;
 99a:	4b05                	li	s6,1
  char * line2 = buffer2;
 99c:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 9a0:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 9a4:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 9a6:	4d05                	li	s10,1
              printf("%s",line1);
 9a8:	00000d97          	auipc	s11,0x0
 9ac:	418d8d93          	addi	s11,s11,1048 # dc0 <digits+0x40>
 9b0:	a0cd                	j	a92 <uniq_run+0x1a8>
            if (repeatedLines){
 9b2:	020a0b63          	beqz	s4,9e8 <uniq_run+0xfe>
                if (isRepeated){
 9b6:	f80b87e3          	beqz	s7,944 <uniq_run+0x5a>
                    if (showCount)
 9ba:	000c0d63          	beqz	s8,9d4 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 9be:	864a                	mv	a2,s2
 9c0:	85da                	mv	a1,s6
 9c2:	00000517          	auipc	a0,0x0
 9c6:	42e50513          	addi	a0,a0,1070 # df0 <digits+0x70>
 9ca:	00000097          	auipc	ra,0x0
 9ce:	cfa080e7          	jalr	-774(ra) # 6c4 <printf>
 9d2:	bf8d                	j	944 <uniq_run+0x5a>
                      printf("%s",line1);
 9d4:	85ca                	mv	a1,s2
 9d6:	00000517          	auipc	a0,0x0
 9da:	3ea50513          	addi	a0,a0,1002 # dc0 <digits+0x40>
 9de:	00000097          	auipc	ra,0x0
 9e2:	ce6080e7          	jalr	-794(ra) # 6c4 <printf>
 9e6:	bfb9                	j	944 <uniq_run+0x5a>
                if (showCount)
 9e8:	000c0d63          	beqz	s8,a02 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 9ec:	864a                	mv	a2,s2
 9ee:	85da                	mv	a1,s6
 9f0:	00000517          	auipc	a0,0x0
 9f4:	40050513          	addi	a0,a0,1024 # df0 <digits+0x70>
 9f8:	00000097          	auipc	ra,0x0
 9fc:	ccc080e7          	jalr	-820(ra) # 6c4 <printf>
 a00:	b791                	j	944 <uniq_run+0x5a>
                  printf("%s",line1);
 a02:	85ca                	mv	a1,s2
 a04:	00000517          	auipc	a0,0x0
 a08:	3bc50513          	addi	a0,a0,956 # dc0 <digits+0x40>
 a0c:	00000097          	auipc	ra,0x0
 a10:	cb8080e7          	jalr	-840(ra) # 6c4 <printf>
 a14:	bf05                	j	944 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 a16:	00000517          	auipc	a0,0x0
 a1a:	3e250513          	addi	a0,a0,994 # df8 <digits+0x78>
 a1e:	00000097          	auipc	ra,0x0
 a22:	ca6080e7          	jalr	-858(ra) # 6c4 <printf>
          break;
 a26:	bf39                	j	944 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 a28:	85a6                	mv	a1,s1
 a2a:	854a                	mv	a0,s2
 a2c:	00000097          	auipc	ra,0x0
 a30:	110080e7          	jalr	272(ra) # b3c <compare_str_ic>
 a34:	a041                	j	ab4 <uniq_run+0x1ca>
                  printf("%s",line1);
 a36:	85ca                	mv	a1,s2
 a38:	856e                	mv	a0,s11
 a3a:	00000097          	auipc	ra,0x0
 a3e:	c8a080e7          	jalr	-886(ra) # 6c4 <printf>
        lineCount = 1;
 a42:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 a44:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a46:	8926                	mv	s2,s1
                  printf("%s",line1);
 a48:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a4a:	4b81                	li	s7,0
 a4c:	a099                	j	a92 <uniq_run+0x1a8>
            if (showCount)
 a4e:	020c0263          	beqz	s8,a72 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 a52:	864a                	mv	a2,s2
 a54:	85da                	mv	a1,s6
 a56:	00000517          	auipc	a0,0x0
 a5a:	39a50513          	addi	a0,a0,922 # df0 <digits+0x70>
 a5e:	00000097          	auipc	ra,0x0
 a62:	c66080e7          	jalr	-922(ra) # 6c4 <printf>
 a66:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a68:	8926                	mv	s2,s1
 a6a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a6c:	4b81                	li	s7,0
        lineCount = 1;
 a6e:	8b6a                	mv	s6,s10
 a70:	a00d                	j	a92 <uniq_run+0x1a8>
              printf("%s",line1);
 a72:	85ca                	mv	a1,s2
 a74:	856e                	mv	a0,s11
 a76:	00000097          	auipc	ra,0x0
 a7a:	c4e080e7          	jalr	-946(ra) # 6c4 <printf>
 a7e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a80:	8926                	mv	s2,s1
              printf("%s",line1);
 a82:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a84:	4b81                	li	s7,0
        lineCount = 1;
 a86:	8b6a                	mv	s6,s10
 a88:	a029                	j	a92 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 a8a:	000a0363          	beqz	s4,a90 <uniq_run+0x1a6>
 a8e:	8bea                	mv	s7,s10
          lineCount++;
 a90:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 a92:	85a6                	mv	a1,s1
 a94:	854e                	mv	a0,s3
 a96:	00000097          	auipc	ra,0x0
 a9a:	196080e7          	jalr	406(ra) # c2c <read_line>
        if (readStatus == READ_EOF){
 a9e:	d911                	beqz	a0,9b2 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 aa0:	f7950be3          	beq	a0,s9,a16 <uniq_run+0x12c>
        if (!ignoreCase)
 aa4:	f80a92e3          	bnez	s5,a28 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 aa8:	85a6                	mv	a1,s1
 aaa:	854a                	mv	a0,s2
 aac:	00000097          	auipc	ra,0x0
 ab0:	062080e7          	jalr	98(ra) # b0e <compare_str>
        if (compareStatus != 0){ 
 ab4:	d979                	beqz	a0,a8a <uniq_run+0x1a0>
          if (repeatedLines){
 ab6:	f80a0ce3          	beqz	s4,a4e <uniq_run+0x164>
            if (isRepeated){
 aba:	ec0b8be3          	beqz	s7,990 <uniq_run+0xa6>
                if (showCount)
 abe:	f60c0ce3          	beqz	s8,a36 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 ac2:	864a                	mv	a2,s2
 ac4:	85da                	mv	a1,s6
 ac6:	00000517          	auipc	a0,0x0
 aca:	32a50513          	addi	a0,a0,810 # df0 <digits+0x70>
 ace:	00000097          	auipc	ra,0x0
 ad2:	bf6080e7          	jalr	-1034(ra) # 6c4 <printf>
        lineCount = 1;
 ad6:	8b5e                	mv	s6,s7
 ad8:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 ada:	8926                	mv	s2,s1
 adc:	84be                	mv	s1,a5
        isRepeated = 0 ;
 ade:	4b81                	li	s7,0
 ae0:	bf4d                	j	a92 <uniq_run+0x1a8>

0000000000000ae2 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 ae2:	1141                	addi	sp,sp,-16
 ae4:	e422                	sd	s0,8(sp)
 ae6:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 ae8:	00054783          	lbu	a5,0(a0)
 aec:	cf99                	beqz	a5,b0a <get_strlen+0x28>
 aee:	00150713          	addi	a4,a0,1
 af2:	87ba                	mv	a5,a4
 af4:	4685                	li	a3,1
 af6:	9e99                	subw	a3,a3,a4
 af8:	00f6853b          	addw	a0,a3,a5
 afc:	0785                	addi	a5,a5,1
 afe:	fff7c703          	lbu	a4,-1(a5)
 b02:	fb7d                	bnez	a4,af8 <get_strlen+0x16>
	return len;
}
 b04:	6422                	ld	s0,8(sp)
 b06:	0141                	addi	sp,sp,16
 b08:	8082                	ret
	int len = 0;
 b0a:	4501                	li	a0,0
 b0c:	bfe5                	j	b04 <get_strlen+0x22>

0000000000000b0e <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 b0e:	1141                	addi	sp,sp,-16
 b10:	e422                	sd	s0,8(sp)
 b12:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 b14:	00054783          	lbu	a5,0(a0)
 b18:	cb91                	beqz	a5,b2c <compare_str+0x1e>
 b1a:	0005c703          	lbu	a4,0(a1)
 b1e:	c719                	beqz	a4,b2c <compare_str+0x1e>
		if (*s1++ != *s2++)
 b20:	0505                	addi	a0,a0,1
 b22:	0585                	addi	a1,a1,1
 b24:	fee788e3          	beq	a5,a4,b14 <compare_str+0x6>
			return 1;
 b28:	4505                	li	a0,1
 b2a:	a031                	j	b36 <compare_str+0x28>
	}
	if (*s1 == *s2)
 b2c:	0005c503          	lbu	a0,0(a1)
 b30:	8d1d                	sub	a0,a0,a5
			return 1;
 b32:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b36:	6422                	ld	s0,8(sp)
 b38:	0141                	addi	sp,sp,16
 b3a:	8082                	ret

0000000000000b3c <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 b3c:	1141                	addi	sp,sp,-16
 b3e:	e422                	sd	s0,8(sp)
 b40:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b42:	4665                	li	a2,25
	while(*s1 && *s2){
 b44:	a019                	j	b4a <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b46:	04e79763          	bne	a5,a4,b94 <compare_str_ic+0x58>
	while(*s1 && *s2){
 b4a:	00054783          	lbu	a5,0(a0)
 b4e:	cb9d                	beqz	a5,b84 <compare_str_ic+0x48>
 b50:	0005c703          	lbu	a4,0(a1)
 b54:	cb05                	beqz	a4,b84 <compare_str_ic+0x48>
		char b1 = *s1++;
 b56:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 b58:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b5a:	fbf7869b          	addiw	a3,a5,-65
 b5e:	0ff6f693          	zext.b	a3,a3
 b62:	00d66663          	bltu	a2,a3,b6e <compare_str_ic+0x32>
			b1 += 32;
 b66:	0207879b          	addiw	a5,a5,32
 b6a:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 b6e:	fbf7069b          	addiw	a3,a4,-65
 b72:	0ff6f693          	zext.b	a3,a3
 b76:	fcd668e3          	bltu	a2,a3,b46 <compare_str_ic+0xa>
			b2 += 32;
 b7a:	0207071b          	addiw	a4,a4,32
 b7e:	0ff77713          	zext.b	a4,a4
 b82:	b7d1                	j	b46 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 b84:	0005c503          	lbu	a0,0(a1)
 b88:	8d1d                	sub	a0,a0,a5
			return 1;
 b8a:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b8e:	6422                	ld	s0,8(sp)
 b90:	0141                	addi	sp,sp,16
 b92:	8082                	ret
			return 1;
 b94:	4505                	li	a0,1
 b96:	bfe5                	j	b8e <compare_str_ic+0x52>

0000000000000b98 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 b98:	7179                	addi	sp,sp,-48
 b9a:	f406                	sd	ra,40(sp)
 b9c:	f022                	sd	s0,32(sp)
 b9e:	ec26                	sd	s1,24(sp)
 ba0:	e84a                	sd	s2,16(sp)
 ba2:	e44e                	sd	s3,8(sp)
 ba4:	1800                	addi	s0,sp,48
 ba6:	89aa                	mv	s3,a0
 ba8:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 baa:	00000097          	auipc	ra,0x0
 bae:	f38080e7          	jalr	-200(ra) # ae2 <get_strlen>
 bb2:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 bb4:	854a                	mv	a0,s2
 bb6:	00000097          	auipc	ra,0x0
 bba:	f2c080e7          	jalr	-212(ra) # ae2 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 bbe:	409505bb          	subw	a1,a0,s1
 bc2:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 bc4:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 bc6:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 bc8:	0005da63          	bgez	a1,bdc <check_substr+0x44>
 bcc:	a81d                	j	c02 <check_substr+0x6a>
        if (j == M)
 bce:	02f48a63          	beq	s1,a5,c02 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 bd2:	0885                	addi	a7,a7,1
 bd4:	0008879b          	sext.w	a5,a7
 bd8:	02f5cc63          	blt	a1,a5,c10 <check_substr+0x78>
 bdc:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 be0:	011906b3          	add	a3,s2,a7
 be4:	874e                	mv	a4,s3
 be6:	879a                	mv	a5,t1
 be8:	fe9053e3          	blez	s1,bce <check_substr+0x36>
            if (s2[i + j] != s1[j])
 bec:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 bf0:	00074603          	lbu	a2,0(a4)
 bf4:	fcc81de3          	bne	a6,a2,bce <check_substr+0x36>
        for (j = 0; j < M; j++)
 bf8:	2785                	addiw	a5,a5,1
 bfa:	0685                	addi	a3,a3,1
 bfc:	0705                	addi	a4,a4,1
 bfe:	fef497e3          	bne	s1,a5,bec <check_substr+0x54>
}
 c02:	70a2                	ld	ra,40(sp)
 c04:	7402                	ld	s0,32(sp)
 c06:	64e2                	ld	s1,24(sp)
 c08:	6942                	ld	s2,16(sp)
 c0a:	69a2                	ld	s3,8(sp)
 c0c:	6145                	addi	sp,sp,48
 c0e:	8082                	ret
    return -1;
 c10:	557d                	li	a0,-1
 c12:	bfc5                	j	c02 <check_substr+0x6a>

0000000000000c14 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 c14:	1141                	addi	sp,sp,-16
 c16:	e406                	sd	ra,8(sp)
 c18:	e022                	sd	s0,0(sp)
 c1a:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 c1c:	fffff097          	auipc	ra,0xfffff
 c20:	72e080e7          	jalr	1838(ra) # 34a <open>
	return fd;
}
 c24:	60a2                	ld	ra,8(sp)
 c26:	6402                	ld	s0,0(sp)
 c28:	0141                	addi	sp,sp,16
 c2a:	8082                	ret

0000000000000c2c <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 c2c:	7139                	addi	sp,sp,-64
 c2e:	fc06                	sd	ra,56(sp)
 c30:	f822                	sd	s0,48(sp)
 c32:	f426                	sd	s1,40(sp)
 c34:	f04a                	sd	s2,32(sp)
 c36:	ec4e                	sd	s3,24(sp)
 c38:	e852                	sd	s4,16(sp)
 c3a:	0080                	addi	s0,sp,64
 c3c:	89aa                	mv	s3,a0
 c3e:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c40:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 c42:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c44:	4605                	li	a2,1
 c46:	fcf40593          	addi	a1,s0,-49
 c4a:	854e                	mv	a0,s3
 c4c:	fffff097          	auipc	ra,0xfffff
 c50:	6d6080e7          	jalr	1750(ra) # 322 <read>
		if (readStatus == 0){
 c54:	c505                	beqz	a0,c7c <read_line+0x50>
		*buffer++ = readByte;
 c56:	0485                	addi	s1,s1,1
 c58:	fcf44783          	lbu	a5,-49(s0)
 c5c:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c60:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c62:	ff4791e3          	bne	a5,s4,c44 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c66:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 c6a:	854a                	mv	a0,s2
 c6c:	70e2                	ld	ra,56(sp)
 c6e:	7442                	ld	s0,48(sp)
 c70:	74a2                	ld	s1,40(sp)
 c72:	7902                	ld	s2,32(sp)
 c74:	69e2                	ld	s3,24(sp)
 c76:	6a42                	ld	s4,16(sp)
 c78:	6121                	addi	sp,sp,64
 c7a:	8082                	ret
			if (byteCount!=0){
 c7c:	fe0907e3          	beqz	s2,c6a <read_line+0x3e>
				*buffer = '\n';
 c80:	47a9                	li	a5,10
 c82:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 c86:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 c8a:	2905                	addiw	s2,s2,1
 c8c:	bff9                	j	c6a <read_line+0x3e>

0000000000000c8e <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c8e:	1141                	addi	sp,sp,-16
 c90:	e406                	sd	ra,8(sp)
 c92:	e022                	sd	s0,0(sp)
 c94:	0800                	addi	s0,sp,16
	close(fd);
 c96:	fffff097          	auipc	ra,0xfffff
 c9a:	69c080e7          	jalr	1692(ra) # 332 <close>
}
 c9e:	60a2                	ld	ra,8(sp)
 ca0:	6402                	ld	s0,0(sp)
 ca2:	0141                	addi	sp,sp,16
 ca4:	8082                	ret

0000000000000ca6 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 ca6:	7139                	addi	sp,sp,-64
 ca8:	fc06                	sd	ra,56(sp)
 caa:	f822                	sd	s0,48(sp)
 cac:	f426                	sd	s1,40(sp)
 cae:	f04a                	sd	s2,32(sp)
 cb0:	0080                	addi	s0,sp,64
 cb2:	84aa                	mv	s1,a0
 cb4:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 cb6:	fffff097          	auipc	ra,0xfffff
 cba:	64c080e7          	jalr	1612(ra) # 302 <fork>
 cbe:	ed19                	bnez	a0,cdc <get_time_perf+0x36>
		exec(argv[0],argv);
 cc0:	85ca                	mv	a1,s2
 cc2:	00093503          	ld	a0,0(s2)
 cc6:	fffff097          	auipc	ra,0xfffff
 cca:	67c080e7          	jalr	1660(ra) # 342 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 cce:	8526                	mv	a0,s1
 cd0:	70e2                	ld	ra,56(sp)
 cd2:	7442                	ld	s0,48(sp)
 cd4:	74a2                	ld	s1,40(sp)
 cd6:	7902                	ld	s2,32(sp)
 cd8:	6121                	addi	sp,sp,64
 cda:	8082                	ret
		times(pid , &time);
 cdc:	fc040593          	addi	a1,s0,-64
 ce0:	fffff097          	auipc	ra,0xfffff
 ce4:	6e2080e7          	jalr	1762(ra) # 3c2 <times>
		return time;
 ce8:	fc043783          	ld	a5,-64(s0)
 cec:	e09c                	sd	a5,0(s1)
 cee:	fc843783          	ld	a5,-56(s0)
 cf2:	e49c                	sd	a5,8(s1)
 cf4:	fd043783          	ld	a5,-48(s0)
 cf8:	e89c                	sd	a5,16(s1)
 cfa:	fd843783          	ld	a5,-40(s0)
 cfe:	ec9c                	sd	a5,24(s1)
 d00:	b7f9                	j	cce <get_time_perf+0x28>
