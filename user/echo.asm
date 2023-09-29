
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
  2e:	cc6a0a13          	addi	s4,s4,-826 # cf0 <get_time_perf+0x62>
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
  6c:	c9058593          	addi	a1,a1,-880 # cf8 <get_time_perf+0x6a>
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

00000000000003d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d2:	1101                	addi	sp,sp,-32
 3d4:	ec06                	sd	ra,24(sp)
 3d6:	e822                	sd	s0,16(sp)
 3d8:	1000                	addi	s0,sp,32
 3da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3de:	4605                	li	a2,1
 3e0:	fef40593          	addi	a1,s0,-17
 3e4:	00000097          	auipc	ra,0x0
 3e8:	f46080e7          	jalr	-186(ra) # 32a <write>
}
 3ec:	60e2                	ld	ra,24(sp)
 3ee:	6442                	ld	s0,16(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret

00000000000003f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f4:	7139                	addi	sp,sp,-64
 3f6:	fc06                	sd	ra,56(sp)
 3f8:	f822                	sd	s0,48(sp)
 3fa:	f426                	sd	s1,40(sp)
 3fc:	f04a                	sd	s2,32(sp)
 3fe:	ec4e                	sd	s3,24(sp)
 400:	0080                	addi	s0,sp,64
 402:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 404:	c299                	beqz	a3,40a <printint+0x16>
 406:	0805c963          	bltz	a1,498 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 40a:	2581                	sext.w	a1,a1
  neg = 0;
 40c:	4881                	li	a7,0
 40e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 412:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 414:	2601                	sext.w	a2,a2
 416:	00001517          	auipc	a0,0x1
 41a:	94a50513          	addi	a0,a0,-1718 # d60 <digits>
 41e:	883a                	mv	a6,a4
 420:	2705                	addiw	a4,a4,1
 422:	02c5f7bb          	remuw	a5,a1,a2
 426:	1782                	slli	a5,a5,0x20
 428:	9381                	srli	a5,a5,0x20
 42a:	97aa                	add	a5,a5,a0
 42c:	0007c783          	lbu	a5,0(a5)
 430:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 434:	0005879b          	sext.w	a5,a1
 438:	02c5d5bb          	divuw	a1,a1,a2
 43c:	0685                	addi	a3,a3,1
 43e:	fec7f0e3          	bgeu	a5,a2,41e <printint+0x2a>
  if(neg)
 442:	00088c63          	beqz	a7,45a <printint+0x66>
    buf[i++] = '-';
 446:	fd070793          	addi	a5,a4,-48
 44a:	00878733          	add	a4,a5,s0
 44e:	02d00793          	li	a5,45
 452:	fef70823          	sb	a5,-16(a4)
 456:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 45a:	02e05863          	blez	a4,48a <printint+0x96>
 45e:	fc040793          	addi	a5,s0,-64
 462:	00e78933          	add	s2,a5,a4
 466:	fff78993          	addi	s3,a5,-1
 46a:	99ba                	add	s3,s3,a4
 46c:	377d                	addiw	a4,a4,-1
 46e:	1702                	slli	a4,a4,0x20
 470:	9301                	srli	a4,a4,0x20
 472:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 476:	fff94583          	lbu	a1,-1(s2)
 47a:	8526                	mv	a0,s1
 47c:	00000097          	auipc	ra,0x0
 480:	f56080e7          	jalr	-170(ra) # 3d2 <putc>
  while(--i >= 0)
 484:	197d                	addi	s2,s2,-1
 486:	ff3918e3          	bne	s2,s3,476 <printint+0x82>
}
 48a:	70e2                	ld	ra,56(sp)
 48c:	7442                	ld	s0,48(sp)
 48e:	74a2                	ld	s1,40(sp)
 490:	7902                	ld	s2,32(sp)
 492:	69e2                	ld	s3,24(sp)
 494:	6121                	addi	sp,sp,64
 496:	8082                	ret
    x = -xx;
 498:	40b005bb          	negw	a1,a1
    neg = 1;
 49c:	4885                	li	a7,1
    x = -xx;
 49e:	bf85                	j	40e <printint+0x1a>

00000000000004a0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a0:	7119                	addi	sp,sp,-128
 4a2:	fc86                	sd	ra,120(sp)
 4a4:	f8a2                	sd	s0,112(sp)
 4a6:	f4a6                	sd	s1,104(sp)
 4a8:	f0ca                	sd	s2,96(sp)
 4aa:	ecce                	sd	s3,88(sp)
 4ac:	e8d2                	sd	s4,80(sp)
 4ae:	e4d6                	sd	s5,72(sp)
 4b0:	e0da                	sd	s6,64(sp)
 4b2:	fc5e                	sd	s7,56(sp)
 4b4:	f862                	sd	s8,48(sp)
 4b6:	f466                	sd	s9,40(sp)
 4b8:	f06a                	sd	s10,32(sp)
 4ba:	ec6e                	sd	s11,24(sp)
 4bc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4be:	0005c903          	lbu	s2,0(a1)
 4c2:	18090f63          	beqz	s2,660 <vprintf+0x1c0>
 4c6:	8aaa                	mv	s5,a0
 4c8:	8b32                	mv	s6,a2
 4ca:	00158493          	addi	s1,a1,1
  state = 0;
 4ce:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4d0:	02500a13          	li	s4,37
 4d4:	4c55                	li	s8,21
 4d6:	00001c97          	auipc	s9,0x1
 4da:	832c8c93          	addi	s9,s9,-1998 # d08 <get_time_perf+0x7a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4de:	02800d93          	li	s11,40
  putc(fd, 'x');
 4e2:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4e4:	00001b97          	auipc	s7,0x1
 4e8:	87cb8b93          	addi	s7,s7,-1924 # d60 <digits>
 4ec:	a839                	j	50a <vprintf+0x6a>
        putc(fd, c);
 4ee:	85ca                	mv	a1,s2
 4f0:	8556                	mv	a0,s5
 4f2:	00000097          	auipc	ra,0x0
 4f6:	ee0080e7          	jalr	-288(ra) # 3d2 <putc>
 4fa:	a019                	j	500 <vprintf+0x60>
    } else if(state == '%'){
 4fc:	01498d63          	beq	s3,s4,516 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 500:	0485                	addi	s1,s1,1
 502:	fff4c903          	lbu	s2,-1(s1)
 506:	14090d63          	beqz	s2,660 <vprintf+0x1c0>
    if(state == 0){
 50a:	fe0999e3          	bnez	s3,4fc <vprintf+0x5c>
      if(c == '%'){
 50e:	ff4910e3          	bne	s2,s4,4ee <vprintf+0x4e>
        state = '%';
 512:	89d2                	mv	s3,s4
 514:	b7f5                	j	500 <vprintf+0x60>
      if(c == 'd'){
 516:	11490c63          	beq	s2,s4,62e <vprintf+0x18e>
 51a:	f9d9079b          	addiw	a5,s2,-99
 51e:	0ff7f793          	zext.b	a5,a5
 522:	10fc6e63          	bltu	s8,a5,63e <vprintf+0x19e>
 526:	f9d9079b          	addiw	a5,s2,-99
 52a:	0ff7f713          	zext.b	a4,a5
 52e:	10ec6863          	bltu	s8,a4,63e <vprintf+0x19e>
 532:	00271793          	slli	a5,a4,0x2
 536:	97e6                	add	a5,a5,s9
 538:	439c                	lw	a5,0(a5)
 53a:	97e6                	add	a5,a5,s9
 53c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 53e:	008b0913          	addi	s2,s6,8
 542:	4685                	li	a3,1
 544:	4629                	li	a2,10
 546:	000b2583          	lw	a1,0(s6)
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	ea8080e7          	jalr	-344(ra) # 3f4 <printint>
 554:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 556:	4981                	li	s3,0
 558:	b765                	j	500 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 55a:	008b0913          	addi	s2,s6,8
 55e:	4681                	li	a3,0
 560:	4629                	li	a2,10
 562:	000b2583          	lw	a1,0(s6)
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	e8c080e7          	jalr	-372(ra) # 3f4 <printint>
 570:	8b4a                	mv	s6,s2
      state = 0;
 572:	4981                	li	s3,0
 574:	b771                	j	500 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 576:	008b0913          	addi	s2,s6,8
 57a:	4681                	li	a3,0
 57c:	866a                	mv	a2,s10
 57e:	000b2583          	lw	a1,0(s6)
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	e70080e7          	jalr	-400(ra) # 3f4 <printint>
 58c:	8b4a                	mv	s6,s2
      state = 0;
 58e:	4981                	li	s3,0
 590:	bf85                	j	500 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 592:	008b0793          	addi	a5,s6,8
 596:	f8f43423          	sd	a5,-120(s0)
 59a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 59e:	03000593          	li	a1,48
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	e2e080e7          	jalr	-466(ra) # 3d2 <putc>
  putc(fd, 'x');
 5ac:	07800593          	li	a1,120
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	e20080e7          	jalr	-480(ra) # 3d2 <putc>
 5ba:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5bc:	03c9d793          	srli	a5,s3,0x3c
 5c0:	97de                	add	a5,a5,s7
 5c2:	0007c583          	lbu	a1,0(a5)
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	e0a080e7          	jalr	-502(ra) # 3d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5d0:	0992                	slli	s3,s3,0x4
 5d2:	397d                	addiw	s2,s2,-1
 5d4:	fe0914e3          	bnez	s2,5bc <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5d8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b70d                	j	500 <vprintf+0x60>
        s = va_arg(ap, char*);
 5e0:	008b0913          	addi	s2,s6,8
 5e4:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5e8:	02098163          	beqz	s3,60a <vprintf+0x16a>
        while(*s != 0){
 5ec:	0009c583          	lbu	a1,0(s3)
 5f0:	c5ad                	beqz	a1,65a <vprintf+0x1ba>
          putc(fd, *s);
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	dde080e7          	jalr	-546(ra) # 3d2 <putc>
          s++;
 5fc:	0985                	addi	s3,s3,1
        while(*s != 0){
 5fe:	0009c583          	lbu	a1,0(s3)
 602:	f9e5                	bnez	a1,5f2 <vprintf+0x152>
        s = va_arg(ap, char*);
 604:	8b4a                	mv	s6,s2
      state = 0;
 606:	4981                	li	s3,0
 608:	bde5                	j	500 <vprintf+0x60>
          s = "(null)";
 60a:	00000997          	auipc	s3,0x0
 60e:	6f698993          	addi	s3,s3,1782 # d00 <get_time_perf+0x72>
        while(*s != 0){
 612:	85ee                	mv	a1,s11
 614:	bff9                	j	5f2 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 616:	008b0913          	addi	s2,s6,8
 61a:	000b4583          	lbu	a1,0(s6)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	db2080e7          	jalr	-590(ra) # 3d2 <putc>
 628:	8b4a                	mv	s6,s2
      state = 0;
 62a:	4981                	li	s3,0
 62c:	bdd1                	j	500 <vprintf+0x60>
        putc(fd, c);
 62e:	85d2                	mv	a1,s4
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	da0080e7          	jalr	-608(ra) # 3d2 <putc>
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b5d1                	j	500 <vprintf+0x60>
        putc(fd, '%');
 63e:	85d2                	mv	a1,s4
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	d90080e7          	jalr	-624(ra) # 3d2 <putc>
        putc(fd, c);
 64a:	85ca                	mv	a1,s2
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	d84080e7          	jalr	-636(ra) # 3d2 <putc>
      state = 0;
 656:	4981                	li	s3,0
 658:	b565                	j	500 <vprintf+0x60>
        s = va_arg(ap, char*);
 65a:	8b4a                	mv	s6,s2
      state = 0;
 65c:	4981                	li	s3,0
 65e:	b54d                	j	500 <vprintf+0x60>
    }
  }
}
 660:	70e6                	ld	ra,120(sp)
 662:	7446                	ld	s0,112(sp)
 664:	74a6                	ld	s1,104(sp)
 666:	7906                	ld	s2,96(sp)
 668:	69e6                	ld	s3,88(sp)
 66a:	6a46                	ld	s4,80(sp)
 66c:	6aa6                	ld	s5,72(sp)
 66e:	6b06                	ld	s6,64(sp)
 670:	7be2                	ld	s7,56(sp)
 672:	7c42                	ld	s8,48(sp)
 674:	7ca2                	ld	s9,40(sp)
 676:	7d02                	ld	s10,32(sp)
 678:	6de2                	ld	s11,24(sp)
 67a:	6109                	addi	sp,sp,128
 67c:	8082                	ret

000000000000067e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 67e:	715d                	addi	sp,sp,-80
 680:	ec06                	sd	ra,24(sp)
 682:	e822                	sd	s0,16(sp)
 684:	1000                	addi	s0,sp,32
 686:	e010                	sd	a2,0(s0)
 688:	e414                	sd	a3,8(s0)
 68a:	e818                	sd	a4,16(s0)
 68c:	ec1c                	sd	a5,24(s0)
 68e:	03043023          	sd	a6,32(s0)
 692:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 696:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 69a:	8622                	mv	a2,s0
 69c:	00000097          	auipc	ra,0x0
 6a0:	e04080e7          	jalr	-508(ra) # 4a0 <vprintf>
}
 6a4:	60e2                	ld	ra,24(sp)
 6a6:	6442                	ld	s0,16(sp)
 6a8:	6161                	addi	sp,sp,80
 6aa:	8082                	ret

00000000000006ac <printf>:

void
printf(const char *fmt, ...)
{
 6ac:	711d                	addi	sp,sp,-96
 6ae:	ec06                	sd	ra,24(sp)
 6b0:	e822                	sd	s0,16(sp)
 6b2:	1000                	addi	s0,sp,32
 6b4:	e40c                	sd	a1,8(s0)
 6b6:	e810                	sd	a2,16(s0)
 6b8:	ec14                	sd	a3,24(s0)
 6ba:	f018                	sd	a4,32(s0)
 6bc:	f41c                	sd	a5,40(s0)
 6be:	03043823          	sd	a6,48(s0)
 6c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c6:	00840613          	addi	a2,s0,8
 6ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ce:	85aa                	mv	a1,a0
 6d0:	4505                	li	a0,1
 6d2:	00000097          	auipc	ra,0x0
 6d6:	dce080e7          	jalr	-562(ra) # 4a0 <vprintf>
}
 6da:	60e2                	ld	ra,24(sp)
 6dc:	6442                	ld	s0,16(sp)
 6de:	6125                	addi	sp,sp,96
 6e0:	8082                	ret

00000000000006e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e2:	1141                	addi	sp,sp,-16
 6e4:	e422                	sd	s0,8(sp)
 6e6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ec:	00001797          	auipc	a5,0x1
 6f0:	9147b783          	ld	a5,-1772(a5) # 1000 <freep>
 6f4:	a02d                	j	71e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6f6:	4618                	lw	a4,8(a2)
 6f8:	9f2d                	addw	a4,a4,a1
 6fa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6fe:	6398                	ld	a4,0(a5)
 700:	6310                	ld	a2,0(a4)
 702:	a83d                	j	740 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 704:	ff852703          	lw	a4,-8(a0)
 708:	9f31                	addw	a4,a4,a2
 70a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 70c:	ff053683          	ld	a3,-16(a0)
 710:	a091                	j	754 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 712:	6398                	ld	a4,0(a5)
 714:	00e7e463          	bltu	a5,a4,71c <free+0x3a>
 718:	00e6ea63          	bltu	a3,a4,72c <free+0x4a>
{
 71c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	fed7fae3          	bgeu	a5,a3,712 <free+0x30>
 722:	6398                	ld	a4,0(a5)
 724:	00e6e463          	bltu	a3,a4,72c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	fee7eae3          	bltu	a5,a4,71c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 72c:	ff852583          	lw	a1,-8(a0)
 730:	6390                	ld	a2,0(a5)
 732:	02059813          	slli	a6,a1,0x20
 736:	01c85713          	srli	a4,a6,0x1c
 73a:	9736                	add	a4,a4,a3
 73c:	fae60de3          	beq	a2,a4,6f6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 740:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 744:	4790                	lw	a2,8(a5)
 746:	02061593          	slli	a1,a2,0x20
 74a:	01c5d713          	srli	a4,a1,0x1c
 74e:	973e                	add	a4,a4,a5
 750:	fae68ae3          	beq	a3,a4,704 <free+0x22>
    p->s.ptr = bp->s.ptr;
 754:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 756:	00001717          	auipc	a4,0x1
 75a:	8af73523          	sd	a5,-1878(a4) # 1000 <freep>
}
 75e:	6422                	ld	s0,8(sp)
 760:	0141                	addi	sp,sp,16
 762:	8082                	ret

0000000000000764 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 764:	7139                	addi	sp,sp,-64
 766:	fc06                	sd	ra,56(sp)
 768:	f822                	sd	s0,48(sp)
 76a:	f426                	sd	s1,40(sp)
 76c:	f04a                	sd	s2,32(sp)
 76e:	ec4e                	sd	s3,24(sp)
 770:	e852                	sd	s4,16(sp)
 772:	e456                	sd	s5,8(sp)
 774:	e05a                	sd	s6,0(sp)
 776:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 778:	02051493          	slli	s1,a0,0x20
 77c:	9081                	srli	s1,s1,0x20
 77e:	04bd                	addi	s1,s1,15
 780:	8091                	srli	s1,s1,0x4
 782:	0014899b          	addiw	s3,s1,1
 786:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 788:	00001517          	auipc	a0,0x1
 78c:	87853503          	ld	a0,-1928(a0) # 1000 <freep>
 790:	c515                	beqz	a0,7bc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 792:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 794:	4798                	lw	a4,8(a5)
 796:	02977f63          	bgeu	a4,s1,7d4 <malloc+0x70>
 79a:	8a4e                	mv	s4,s3
 79c:	0009871b          	sext.w	a4,s3
 7a0:	6685                	lui	a3,0x1
 7a2:	00d77363          	bgeu	a4,a3,7a8 <malloc+0x44>
 7a6:	6a05                	lui	s4,0x1
 7a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b0:	00001917          	auipc	s2,0x1
 7b4:	85090913          	addi	s2,s2,-1968 # 1000 <freep>
  if(p == (char*)-1)
 7b8:	5afd                	li	s5,-1
 7ba:	a895                	j	82e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7bc:	00001797          	auipc	a5,0x1
 7c0:	85478793          	addi	a5,a5,-1964 # 1010 <base>
 7c4:	00001717          	auipc	a4,0x1
 7c8:	82f73e23          	sd	a5,-1988(a4) # 1000 <freep>
 7cc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ce:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7d2:	b7e1                	j	79a <malloc+0x36>
      if(p->s.size == nunits)
 7d4:	02e48c63          	beq	s1,a4,80c <malloc+0xa8>
        p->s.size -= nunits;
 7d8:	4137073b          	subw	a4,a4,s3
 7dc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7de:	02071693          	slli	a3,a4,0x20
 7e2:	01c6d713          	srli	a4,a3,0x1c
 7e6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7ec:	00001717          	auipc	a4,0x1
 7f0:	80a73a23          	sd	a0,-2028(a4) # 1000 <freep>
      return (void*)(p + 1);
 7f4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7f8:	70e2                	ld	ra,56(sp)
 7fa:	7442                	ld	s0,48(sp)
 7fc:	74a2                	ld	s1,40(sp)
 7fe:	7902                	ld	s2,32(sp)
 800:	69e2                	ld	s3,24(sp)
 802:	6a42                	ld	s4,16(sp)
 804:	6aa2                	ld	s5,8(sp)
 806:	6b02                	ld	s6,0(sp)
 808:	6121                	addi	sp,sp,64
 80a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 80c:	6398                	ld	a4,0(a5)
 80e:	e118                	sd	a4,0(a0)
 810:	bff1                	j	7ec <malloc+0x88>
  hp->s.size = nu;
 812:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 816:	0541                	addi	a0,a0,16
 818:	00000097          	auipc	ra,0x0
 81c:	eca080e7          	jalr	-310(ra) # 6e2 <free>
  return freep;
 820:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 824:	d971                	beqz	a0,7f8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 826:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 828:	4798                	lw	a4,8(a5)
 82a:	fa9775e3          	bgeu	a4,s1,7d4 <malloc+0x70>
    if(p == freep)
 82e:	00093703          	ld	a4,0(s2)
 832:	853e                	mv	a0,a5
 834:	fef719e3          	bne	a4,a5,826 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 838:	8552                	mv	a0,s4
 83a:	00000097          	auipc	ra,0x0
 83e:	b58080e7          	jalr	-1192(ra) # 392 <sbrk>
  if(p == (char*)-1)
 842:	fd5518e3          	bne	a0,s5,812 <malloc+0xae>
        return 0;
 846:	4501                	li	a0,0
 848:	bf45                	j	7f8 <malloc+0x94>

000000000000084a <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 84a:	c1d9                	beqz	a1,8d0 <head_run+0x86>
void head_run(int fd, int numOfLines){
 84c:	dd010113          	addi	sp,sp,-560
 850:	22113423          	sd	ra,552(sp)
 854:	22813023          	sd	s0,544(sp)
 858:	20913c23          	sd	s1,536(sp)
 85c:	21213823          	sd	s2,528(sp)
 860:	21313423          	sd	s3,520(sp)
 864:	21413023          	sd	s4,512(sp)
 868:	1c00                	addi	s0,sp,560
 86a:	892a                	mv	s2,a0
 86c:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 870:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 872:	00000a17          	auipc	s4,0x0
 876:	52ea0a13          	addi	s4,s4,1326 # da0 <digits+0x40>
		readStatus = read_line(fd, line);
 87a:	dd840593          	addi	a1,s0,-552
 87e:	854a                	mv	a0,s2
 880:	00000097          	auipc	ra,0x0
 884:	394080e7          	jalr	916(ra) # c14 <read_line>
		if (readStatus == READ_ERROR){
 888:	01350d63          	beq	a0,s3,8a2 <head_run+0x58>
		if (readStatus == READ_EOF)
 88c:	c11d                	beqz	a0,8b2 <head_run+0x68>
		printf("%s",line);
 88e:	dd840593          	addi	a1,s0,-552
 892:	8552                	mv	a0,s4
 894:	00000097          	auipc	ra,0x0
 898:	e18080e7          	jalr	-488(ra) # 6ac <printf>
	while(numOfLines--){
 89c:	34fd                	addiw	s1,s1,-1
 89e:	fcf1                	bnez	s1,87a <head_run+0x30>
 8a0:	a809                	j	8b2 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 8a2:	00000517          	auipc	a0,0x0
 8a6:	4d650513          	addi	a0,a0,1238 # d78 <digits+0x18>
 8aa:	00000097          	auipc	ra,0x0
 8ae:	e02080e7          	jalr	-510(ra) # 6ac <printf>

	}
}
 8b2:	22813083          	ld	ra,552(sp)
 8b6:	22013403          	ld	s0,544(sp)
 8ba:	21813483          	ld	s1,536(sp)
 8be:	21013903          	ld	s2,528(sp)
 8c2:	20813983          	ld	s3,520(sp)
 8c6:	20013a03          	ld	s4,512(sp)
 8ca:	23010113          	addi	sp,sp,560
 8ce:	8082                	ret
 8d0:	8082                	ret

00000000000008d2 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 8d2:	ba010113          	addi	sp,sp,-1120
 8d6:	44113c23          	sd	ra,1112(sp)
 8da:	44813823          	sd	s0,1104(sp)
 8de:	44913423          	sd	s1,1096(sp)
 8e2:	45213023          	sd	s2,1088(sp)
 8e6:	43313c23          	sd	s3,1080(sp)
 8ea:	43413823          	sd	s4,1072(sp)
 8ee:	43513423          	sd	s5,1064(sp)
 8f2:	43613023          	sd	s6,1056(sp)
 8f6:	41713c23          	sd	s7,1048(sp)
 8fa:	41813823          	sd	s8,1040(sp)
 8fe:	41913423          	sd	s9,1032(sp)
 902:	41a13023          	sd	s10,1024(sp)
 906:	3fb13c23          	sd	s11,1016(sp)
 90a:	46010413          	addi	s0,sp,1120
 90e:	89aa                	mv	s3,a0
 910:	8aae                	mv	s5,a1
 912:	8c32                	mv	s8,a2
 914:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 916:	d9840593          	addi	a1,s0,-616
 91a:	00000097          	auipc	ra,0x0
 91e:	2fa080e7          	jalr	762(ra) # c14 <read_line>


  if (readStatus == READ_ERROR)
 922:	57fd                	li	a5,-1
 924:	04f50163          	beq	a0,a5,966 <uniq_run+0x94>
 928:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 92a:	ed21                	bnez	a0,982 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 92c:	45813083          	ld	ra,1112(sp)
 930:	45013403          	ld	s0,1104(sp)
 934:	44813483          	ld	s1,1096(sp)
 938:	44013903          	ld	s2,1088(sp)
 93c:	43813983          	ld	s3,1080(sp)
 940:	43013a03          	ld	s4,1072(sp)
 944:	42813a83          	ld	s5,1064(sp)
 948:	42013b03          	ld	s6,1056(sp)
 94c:	41813b83          	ld	s7,1048(sp)
 950:	41013c03          	ld	s8,1040(sp)
 954:	40813c83          	ld	s9,1032(sp)
 958:	40013d03          	ld	s10,1024(sp)
 95c:	3f813d83          	ld	s11,1016(sp)
 960:	46010113          	addi	sp,sp,1120
 964:	8082                	ret
    printf("[ERR] Error reading from the file ");
 966:	00000517          	auipc	a0,0x0
 96a:	44250513          	addi	a0,a0,1090 # da8 <digits+0x48>
 96e:	00000097          	auipc	ra,0x0
 972:	d3e080e7          	jalr	-706(ra) # 6ac <printf>
 976:	bf5d                	j	92c <uniq_run+0x5a>
 978:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 97a:	8926                	mv	s2,s1
 97c:	84be                	mv	s1,a5
        lineCount = 1;
 97e:	8b6a                	mv	s6,s10
 980:	a8ed                	j	a7a <uniq_run+0x1a8>
    int lineCount=1;
 982:	4b05                	li	s6,1
  char * line2 = buffer2;
 984:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 988:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 98c:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 98e:	4d05                	li	s10,1
              printf("%s",line1);
 990:	00000d97          	auipc	s11,0x0
 994:	410d8d93          	addi	s11,s11,1040 # da0 <digits+0x40>
 998:	a0cd                	j	a7a <uniq_run+0x1a8>
            if (repeatedLines){
 99a:	020a0b63          	beqz	s4,9d0 <uniq_run+0xfe>
                if (isRepeated){
 99e:	f80b87e3          	beqz	s7,92c <uniq_run+0x5a>
                    if (showCount)
 9a2:	000c0d63          	beqz	s8,9bc <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 9a6:	864a                	mv	a2,s2
 9a8:	85da                	mv	a1,s6
 9aa:	00000517          	auipc	a0,0x0
 9ae:	42650513          	addi	a0,a0,1062 # dd0 <digits+0x70>
 9b2:	00000097          	auipc	ra,0x0
 9b6:	cfa080e7          	jalr	-774(ra) # 6ac <printf>
 9ba:	bf8d                	j	92c <uniq_run+0x5a>
                      printf("%s",line1);
 9bc:	85ca                	mv	a1,s2
 9be:	00000517          	auipc	a0,0x0
 9c2:	3e250513          	addi	a0,a0,994 # da0 <digits+0x40>
 9c6:	00000097          	auipc	ra,0x0
 9ca:	ce6080e7          	jalr	-794(ra) # 6ac <printf>
 9ce:	bfb9                	j	92c <uniq_run+0x5a>
                if (showCount)
 9d0:	000c0d63          	beqz	s8,9ea <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 9d4:	864a                	mv	a2,s2
 9d6:	85da                	mv	a1,s6
 9d8:	00000517          	auipc	a0,0x0
 9dc:	3f850513          	addi	a0,a0,1016 # dd0 <digits+0x70>
 9e0:	00000097          	auipc	ra,0x0
 9e4:	ccc080e7          	jalr	-820(ra) # 6ac <printf>
 9e8:	b791                	j	92c <uniq_run+0x5a>
                  printf("%s",line1);
 9ea:	85ca                	mv	a1,s2
 9ec:	00000517          	auipc	a0,0x0
 9f0:	3b450513          	addi	a0,a0,948 # da0 <digits+0x40>
 9f4:	00000097          	auipc	ra,0x0
 9f8:	cb8080e7          	jalr	-840(ra) # 6ac <printf>
 9fc:	bf05                	j	92c <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 9fe:	00000517          	auipc	a0,0x0
 a02:	3da50513          	addi	a0,a0,986 # dd8 <digits+0x78>
 a06:	00000097          	auipc	ra,0x0
 a0a:	ca6080e7          	jalr	-858(ra) # 6ac <printf>
          break;
 a0e:	bf39                	j	92c <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 a10:	85a6                	mv	a1,s1
 a12:	854a                	mv	a0,s2
 a14:	00000097          	auipc	ra,0x0
 a18:	110080e7          	jalr	272(ra) # b24 <compare_str_ic>
 a1c:	a041                	j	a9c <uniq_run+0x1ca>
                  printf("%s",line1);
 a1e:	85ca                	mv	a1,s2
 a20:	856e                	mv	a0,s11
 a22:	00000097          	auipc	ra,0x0
 a26:	c8a080e7          	jalr	-886(ra) # 6ac <printf>
        lineCount = 1;
 a2a:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 a2c:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a2e:	8926                	mv	s2,s1
                  printf("%s",line1);
 a30:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a32:	4b81                	li	s7,0
 a34:	a099                	j	a7a <uniq_run+0x1a8>
            if (showCount)
 a36:	020c0263          	beqz	s8,a5a <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 a3a:	864a                	mv	a2,s2
 a3c:	85da                	mv	a1,s6
 a3e:	00000517          	auipc	a0,0x0
 a42:	39250513          	addi	a0,a0,914 # dd0 <digits+0x70>
 a46:	00000097          	auipc	ra,0x0
 a4a:	c66080e7          	jalr	-922(ra) # 6ac <printf>
 a4e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a50:	8926                	mv	s2,s1
 a52:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a54:	4b81                	li	s7,0
        lineCount = 1;
 a56:	8b6a                	mv	s6,s10
 a58:	a00d                	j	a7a <uniq_run+0x1a8>
              printf("%s",line1);
 a5a:	85ca                	mv	a1,s2
 a5c:	856e                	mv	a0,s11
 a5e:	00000097          	auipc	ra,0x0
 a62:	c4e080e7          	jalr	-946(ra) # 6ac <printf>
 a66:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a68:	8926                	mv	s2,s1
              printf("%s",line1);
 a6a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a6c:	4b81                	li	s7,0
        lineCount = 1;
 a6e:	8b6a                	mv	s6,s10
 a70:	a029                	j	a7a <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 a72:	000a0363          	beqz	s4,a78 <uniq_run+0x1a6>
 a76:	8bea                	mv	s7,s10
          lineCount++;
 a78:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 a7a:	85a6                	mv	a1,s1
 a7c:	854e                	mv	a0,s3
 a7e:	00000097          	auipc	ra,0x0
 a82:	196080e7          	jalr	406(ra) # c14 <read_line>
        if (readStatus == READ_EOF){
 a86:	d911                	beqz	a0,99a <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 a88:	f7950be3          	beq	a0,s9,9fe <uniq_run+0x12c>
        if (!ignoreCase)
 a8c:	f80a92e3          	bnez	s5,a10 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 a90:	85a6                	mv	a1,s1
 a92:	854a                	mv	a0,s2
 a94:	00000097          	auipc	ra,0x0
 a98:	062080e7          	jalr	98(ra) # af6 <compare_str>
        if (compareStatus != 0){ 
 a9c:	d979                	beqz	a0,a72 <uniq_run+0x1a0>
          if (repeatedLines){
 a9e:	f80a0ce3          	beqz	s4,a36 <uniq_run+0x164>
            if (isRepeated){
 aa2:	ec0b8be3          	beqz	s7,978 <uniq_run+0xa6>
                if (showCount)
 aa6:	f60c0ce3          	beqz	s8,a1e <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 aaa:	864a                	mv	a2,s2
 aac:	85da                	mv	a1,s6
 aae:	00000517          	auipc	a0,0x0
 ab2:	32250513          	addi	a0,a0,802 # dd0 <digits+0x70>
 ab6:	00000097          	auipc	ra,0x0
 aba:	bf6080e7          	jalr	-1034(ra) # 6ac <printf>
        lineCount = 1;
 abe:	8b5e                	mv	s6,s7
 ac0:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 ac2:	8926                	mv	s2,s1
 ac4:	84be                	mv	s1,a5
        isRepeated = 0 ;
 ac6:	4b81                	li	s7,0
 ac8:	bf4d                	j	a7a <uniq_run+0x1a8>

0000000000000aca <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 aca:	1141                	addi	sp,sp,-16
 acc:	e422                	sd	s0,8(sp)
 ace:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 ad0:	00054783          	lbu	a5,0(a0)
 ad4:	cf99                	beqz	a5,af2 <get_strlen+0x28>
 ad6:	00150713          	addi	a4,a0,1
 ada:	87ba                	mv	a5,a4
 adc:	4685                	li	a3,1
 ade:	9e99                	subw	a3,a3,a4
 ae0:	00f6853b          	addw	a0,a3,a5
 ae4:	0785                	addi	a5,a5,1
 ae6:	fff7c703          	lbu	a4,-1(a5)
 aea:	fb7d                	bnez	a4,ae0 <get_strlen+0x16>
	return len;
}
 aec:	6422                	ld	s0,8(sp)
 aee:	0141                	addi	sp,sp,16
 af0:	8082                	ret
	int len = 0;
 af2:	4501                	li	a0,0
 af4:	bfe5                	j	aec <get_strlen+0x22>

0000000000000af6 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 af6:	1141                	addi	sp,sp,-16
 af8:	e422                	sd	s0,8(sp)
 afa:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 afc:	00054783          	lbu	a5,0(a0)
 b00:	cb91                	beqz	a5,b14 <compare_str+0x1e>
 b02:	0005c703          	lbu	a4,0(a1)
 b06:	c719                	beqz	a4,b14 <compare_str+0x1e>
		if (*s1++ != *s2++)
 b08:	0505                	addi	a0,a0,1
 b0a:	0585                	addi	a1,a1,1
 b0c:	fee788e3          	beq	a5,a4,afc <compare_str+0x6>
			return 1;
 b10:	4505                	li	a0,1
 b12:	a031                	j	b1e <compare_str+0x28>
	}
	if (*s1 == *s2)
 b14:	0005c503          	lbu	a0,0(a1)
 b18:	8d1d                	sub	a0,a0,a5
			return 1;
 b1a:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b1e:	6422                	ld	s0,8(sp)
 b20:	0141                	addi	sp,sp,16
 b22:	8082                	ret

0000000000000b24 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 b24:	1141                	addi	sp,sp,-16
 b26:	e422                	sd	s0,8(sp)
 b28:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b2a:	4665                	li	a2,25
	while(*s1 && *s2){
 b2c:	a019                	j	b32 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b2e:	04e79763          	bne	a5,a4,b7c <compare_str_ic+0x58>
	while(*s1 && *s2){
 b32:	00054783          	lbu	a5,0(a0)
 b36:	cb9d                	beqz	a5,b6c <compare_str_ic+0x48>
 b38:	0005c703          	lbu	a4,0(a1)
 b3c:	cb05                	beqz	a4,b6c <compare_str_ic+0x48>
		char b1 = *s1++;
 b3e:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 b40:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b42:	fbf7869b          	addiw	a3,a5,-65
 b46:	0ff6f693          	zext.b	a3,a3
 b4a:	00d66663          	bltu	a2,a3,b56 <compare_str_ic+0x32>
			b1 += 32;
 b4e:	0207879b          	addiw	a5,a5,32
 b52:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 b56:	fbf7069b          	addiw	a3,a4,-65
 b5a:	0ff6f693          	zext.b	a3,a3
 b5e:	fcd668e3          	bltu	a2,a3,b2e <compare_str_ic+0xa>
			b2 += 32;
 b62:	0207071b          	addiw	a4,a4,32
 b66:	0ff77713          	zext.b	a4,a4
 b6a:	b7d1                	j	b2e <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 b6c:	0005c503          	lbu	a0,0(a1)
 b70:	8d1d                	sub	a0,a0,a5
			return 1;
 b72:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b76:	6422                	ld	s0,8(sp)
 b78:	0141                	addi	sp,sp,16
 b7a:	8082                	ret
			return 1;
 b7c:	4505                	li	a0,1
 b7e:	bfe5                	j	b76 <compare_str_ic+0x52>

0000000000000b80 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 b80:	7179                	addi	sp,sp,-48
 b82:	f406                	sd	ra,40(sp)
 b84:	f022                	sd	s0,32(sp)
 b86:	ec26                	sd	s1,24(sp)
 b88:	e84a                	sd	s2,16(sp)
 b8a:	e44e                	sd	s3,8(sp)
 b8c:	1800                	addi	s0,sp,48
 b8e:	89aa                	mv	s3,a0
 b90:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 b92:	00000097          	auipc	ra,0x0
 b96:	f38080e7          	jalr	-200(ra) # aca <get_strlen>
 b9a:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 b9c:	854a                	mv	a0,s2
 b9e:	00000097          	auipc	ra,0x0
 ba2:	f2c080e7          	jalr	-212(ra) # aca <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 ba6:	409505bb          	subw	a1,a0,s1
 baa:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 bac:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 bae:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 bb0:	0005da63          	bgez	a1,bc4 <check_substr+0x44>
 bb4:	a81d                	j	bea <check_substr+0x6a>
        if (j == M)
 bb6:	02f48a63          	beq	s1,a5,bea <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 bba:	0885                	addi	a7,a7,1
 bbc:	0008879b          	sext.w	a5,a7
 bc0:	02f5cc63          	blt	a1,a5,bf8 <check_substr+0x78>
 bc4:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 bc8:	011906b3          	add	a3,s2,a7
 bcc:	874e                	mv	a4,s3
 bce:	879a                	mv	a5,t1
 bd0:	fe9053e3          	blez	s1,bb6 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 bd4:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 bd8:	00074603          	lbu	a2,0(a4)
 bdc:	fcc81de3          	bne	a6,a2,bb6 <check_substr+0x36>
        for (j = 0; j < M; j++)
 be0:	2785                	addiw	a5,a5,1
 be2:	0685                	addi	a3,a3,1
 be4:	0705                	addi	a4,a4,1
 be6:	fef497e3          	bne	s1,a5,bd4 <check_substr+0x54>
}
 bea:	70a2                	ld	ra,40(sp)
 bec:	7402                	ld	s0,32(sp)
 bee:	64e2                	ld	s1,24(sp)
 bf0:	6942                	ld	s2,16(sp)
 bf2:	69a2                	ld	s3,8(sp)
 bf4:	6145                	addi	sp,sp,48
 bf6:	8082                	ret
    return -1;
 bf8:	557d                	li	a0,-1
 bfa:	bfc5                	j	bea <check_substr+0x6a>

0000000000000bfc <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 bfc:	1141                	addi	sp,sp,-16
 bfe:	e406                	sd	ra,8(sp)
 c00:	e022                	sd	s0,0(sp)
 c02:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 c04:	fffff097          	auipc	ra,0xfffff
 c08:	746080e7          	jalr	1862(ra) # 34a <open>
	return fd;
}
 c0c:	60a2                	ld	ra,8(sp)
 c0e:	6402                	ld	s0,0(sp)
 c10:	0141                	addi	sp,sp,16
 c12:	8082                	ret

0000000000000c14 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 c14:	7139                	addi	sp,sp,-64
 c16:	fc06                	sd	ra,56(sp)
 c18:	f822                	sd	s0,48(sp)
 c1a:	f426                	sd	s1,40(sp)
 c1c:	f04a                	sd	s2,32(sp)
 c1e:	ec4e                	sd	s3,24(sp)
 c20:	e852                	sd	s4,16(sp)
 c22:	0080                	addi	s0,sp,64
 c24:	89aa                	mv	s3,a0
 c26:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c28:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 c2a:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c2c:	4605                	li	a2,1
 c2e:	fcf40593          	addi	a1,s0,-49
 c32:	854e                	mv	a0,s3
 c34:	fffff097          	auipc	ra,0xfffff
 c38:	6ee080e7          	jalr	1774(ra) # 322 <read>
		if (readStatus == 0){
 c3c:	c505                	beqz	a0,c64 <read_line+0x50>
		*buffer++ = readByte;
 c3e:	0485                	addi	s1,s1,1
 c40:	fcf44783          	lbu	a5,-49(s0)
 c44:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c48:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c4a:	ff4791e3          	bne	a5,s4,c2c <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c4e:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 c52:	854a                	mv	a0,s2
 c54:	70e2                	ld	ra,56(sp)
 c56:	7442                	ld	s0,48(sp)
 c58:	74a2                	ld	s1,40(sp)
 c5a:	7902                	ld	s2,32(sp)
 c5c:	69e2                	ld	s3,24(sp)
 c5e:	6a42                	ld	s4,16(sp)
 c60:	6121                	addi	sp,sp,64
 c62:	8082                	ret
			if (byteCount!=0){
 c64:	fe0907e3          	beqz	s2,c52 <read_line+0x3e>
				*buffer = '\n';
 c68:	47a9                	li	a5,10
 c6a:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 c6e:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 c72:	2905                	addiw	s2,s2,1
 c74:	bff9                	j	c52 <read_line+0x3e>

0000000000000c76 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c76:	1141                	addi	sp,sp,-16
 c78:	e406                	sd	ra,8(sp)
 c7a:	e022                	sd	s0,0(sp)
 c7c:	0800                	addi	s0,sp,16
	close(fd);
 c7e:	fffff097          	auipc	ra,0xfffff
 c82:	6b4080e7          	jalr	1716(ra) # 332 <close>
}
 c86:	60a2                	ld	ra,8(sp)
 c88:	6402                	ld	s0,0(sp)
 c8a:	0141                	addi	sp,sp,16
 c8c:	8082                	ret

0000000000000c8e <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 c8e:	7139                	addi	sp,sp,-64
 c90:	fc06                	sd	ra,56(sp)
 c92:	f822                	sd	s0,48(sp)
 c94:	f426                	sd	s1,40(sp)
 c96:	f04a                	sd	s2,32(sp)
 c98:	0080                	addi	s0,sp,64
 c9a:	84aa                	mv	s1,a0
 c9c:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 c9e:	fffff097          	auipc	ra,0xfffff
 ca2:	664080e7          	jalr	1636(ra) # 302 <fork>
 ca6:	ed19                	bnez	a0,cc4 <get_time_perf+0x36>
		exec(argv[0],argv);
 ca8:	85ca                	mv	a1,s2
 caa:	00093503          	ld	a0,0(s2)
 cae:	fffff097          	auipc	ra,0xfffff
 cb2:	694080e7          	jalr	1684(ra) # 342 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 cb6:	8526                	mv	a0,s1
 cb8:	70e2                	ld	ra,56(sp)
 cba:	7442                	ld	s0,48(sp)
 cbc:	74a2                	ld	s1,40(sp)
 cbe:	7902                	ld	s2,32(sp)
 cc0:	6121                	addi	sp,sp,64
 cc2:	8082                	ret
		times(pid , &time);
 cc4:	fc840593          	addi	a1,s0,-56
 cc8:	fffff097          	auipc	ra,0xfffff
 ccc:	6fa080e7          	jalr	1786(ra) # 3c2 <times>
		return time;
 cd0:	fc843783          	ld	a5,-56(s0)
 cd4:	e09c                	sd	a5,0(s1)
 cd6:	fd043783          	ld	a5,-48(s0)
 cda:	e49c                	sd	a5,8(s1)
 cdc:	fd843783          	ld	a5,-40(s0)
 ce0:	e89c                	sd	a5,16(s1)
 ce2:	bfd1                	j	cb6 <get_time_perf+0x28>
