
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
  2e:	be6a0a13          	addi	s4,s4,-1050 # c10 <close_file+0x22>
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
  6c:	bb058593          	addi	a1,a1,-1104 # c18 <close_file+0x2a>
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

00000000000003ba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ba:	1101                	addi	sp,sp,-32
 3bc:	ec06                	sd	ra,24(sp)
 3be:	e822                	sd	s0,16(sp)
 3c0:	1000                	addi	s0,sp,32
 3c2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c6:	4605                	li	a2,1
 3c8:	fef40593          	addi	a1,s0,-17
 3cc:	00000097          	auipc	ra,0x0
 3d0:	f5e080e7          	jalr	-162(ra) # 32a <write>
}
 3d4:	60e2                	ld	ra,24(sp)
 3d6:	6442                	ld	s0,16(sp)
 3d8:	6105                	addi	sp,sp,32
 3da:	8082                	ret

00000000000003dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3dc:	7139                	addi	sp,sp,-64
 3de:	fc06                	sd	ra,56(sp)
 3e0:	f822                	sd	s0,48(sp)
 3e2:	f426                	sd	s1,40(sp)
 3e4:	f04a                	sd	s2,32(sp)
 3e6:	ec4e                	sd	s3,24(sp)
 3e8:	0080                	addi	s0,sp,64
 3ea:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ec:	c299                	beqz	a3,3f2 <printint+0x16>
 3ee:	0805c963          	bltz	a1,480 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f2:	2581                	sext.w	a1,a1
  neg = 0;
 3f4:	4881                	li	a7,0
 3f6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3fa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3fc:	2601                	sext.w	a2,a2
 3fe:	00001517          	auipc	a0,0x1
 402:	88250513          	addi	a0,a0,-1918 # c80 <digits>
 406:	883a                	mv	a6,a4
 408:	2705                	addiw	a4,a4,1
 40a:	02c5f7bb          	remuw	a5,a1,a2
 40e:	1782                	slli	a5,a5,0x20
 410:	9381                	srli	a5,a5,0x20
 412:	97aa                	add	a5,a5,a0
 414:	0007c783          	lbu	a5,0(a5)
 418:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 41c:	0005879b          	sext.w	a5,a1
 420:	02c5d5bb          	divuw	a1,a1,a2
 424:	0685                	addi	a3,a3,1
 426:	fec7f0e3          	bgeu	a5,a2,406 <printint+0x2a>
  if(neg)
 42a:	00088c63          	beqz	a7,442 <printint+0x66>
    buf[i++] = '-';
 42e:	fd070793          	addi	a5,a4,-48
 432:	00878733          	add	a4,a5,s0
 436:	02d00793          	li	a5,45
 43a:	fef70823          	sb	a5,-16(a4)
 43e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 442:	02e05863          	blez	a4,472 <printint+0x96>
 446:	fc040793          	addi	a5,s0,-64
 44a:	00e78933          	add	s2,a5,a4
 44e:	fff78993          	addi	s3,a5,-1
 452:	99ba                	add	s3,s3,a4
 454:	377d                	addiw	a4,a4,-1
 456:	1702                	slli	a4,a4,0x20
 458:	9301                	srli	a4,a4,0x20
 45a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 45e:	fff94583          	lbu	a1,-1(s2)
 462:	8526                	mv	a0,s1
 464:	00000097          	auipc	ra,0x0
 468:	f56080e7          	jalr	-170(ra) # 3ba <putc>
  while(--i >= 0)
 46c:	197d                	addi	s2,s2,-1
 46e:	ff3918e3          	bne	s2,s3,45e <printint+0x82>
}
 472:	70e2                	ld	ra,56(sp)
 474:	7442                	ld	s0,48(sp)
 476:	74a2                	ld	s1,40(sp)
 478:	7902                	ld	s2,32(sp)
 47a:	69e2                	ld	s3,24(sp)
 47c:	6121                	addi	sp,sp,64
 47e:	8082                	ret
    x = -xx;
 480:	40b005bb          	negw	a1,a1
    neg = 1;
 484:	4885                	li	a7,1
    x = -xx;
 486:	bf85                	j	3f6 <printint+0x1a>

0000000000000488 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 488:	7119                	addi	sp,sp,-128
 48a:	fc86                	sd	ra,120(sp)
 48c:	f8a2                	sd	s0,112(sp)
 48e:	f4a6                	sd	s1,104(sp)
 490:	f0ca                	sd	s2,96(sp)
 492:	ecce                	sd	s3,88(sp)
 494:	e8d2                	sd	s4,80(sp)
 496:	e4d6                	sd	s5,72(sp)
 498:	e0da                	sd	s6,64(sp)
 49a:	fc5e                	sd	s7,56(sp)
 49c:	f862                	sd	s8,48(sp)
 49e:	f466                	sd	s9,40(sp)
 4a0:	f06a                	sd	s10,32(sp)
 4a2:	ec6e                	sd	s11,24(sp)
 4a4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a6:	0005c903          	lbu	s2,0(a1)
 4aa:	18090f63          	beqz	s2,648 <vprintf+0x1c0>
 4ae:	8aaa                	mv	s5,a0
 4b0:	8b32                	mv	s6,a2
 4b2:	00158493          	addi	s1,a1,1
  state = 0;
 4b6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b8:	02500a13          	li	s4,37
 4bc:	4c55                	li	s8,21
 4be:	00000c97          	auipc	s9,0x0
 4c2:	76ac8c93          	addi	s9,s9,1898 # c28 <close_file+0x3a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4c6:	02800d93          	li	s11,40
  putc(fd, 'x');
 4ca:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4cc:	00000b97          	auipc	s7,0x0
 4d0:	7b4b8b93          	addi	s7,s7,1972 # c80 <digits>
 4d4:	a839                	j	4f2 <vprintf+0x6a>
        putc(fd, c);
 4d6:	85ca                	mv	a1,s2
 4d8:	8556                	mv	a0,s5
 4da:	00000097          	auipc	ra,0x0
 4de:	ee0080e7          	jalr	-288(ra) # 3ba <putc>
 4e2:	a019                	j	4e8 <vprintf+0x60>
    } else if(state == '%'){
 4e4:	01498d63          	beq	s3,s4,4fe <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4e8:	0485                	addi	s1,s1,1
 4ea:	fff4c903          	lbu	s2,-1(s1)
 4ee:	14090d63          	beqz	s2,648 <vprintf+0x1c0>
    if(state == 0){
 4f2:	fe0999e3          	bnez	s3,4e4 <vprintf+0x5c>
      if(c == '%'){
 4f6:	ff4910e3          	bne	s2,s4,4d6 <vprintf+0x4e>
        state = '%';
 4fa:	89d2                	mv	s3,s4
 4fc:	b7f5                	j	4e8 <vprintf+0x60>
      if(c == 'd'){
 4fe:	11490c63          	beq	s2,s4,616 <vprintf+0x18e>
 502:	f9d9079b          	addiw	a5,s2,-99
 506:	0ff7f793          	zext.b	a5,a5
 50a:	10fc6e63          	bltu	s8,a5,626 <vprintf+0x19e>
 50e:	f9d9079b          	addiw	a5,s2,-99
 512:	0ff7f713          	zext.b	a4,a5
 516:	10ec6863          	bltu	s8,a4,626 <vprintf+0x19e>
 51a:	00271793          	slli	a5,a4,0x2
 51e:	97e6                	add	a5,a5,s9
 520:	439c                	lw	a5,0(a5)
 522:	97e6                	add	a5,a5,s9
 524:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 526:	008b0913          	addi	s2,s6,8
 52a:	4685                	li	a3,1
 52c:	4629                	li	a2,10
 52e:	000b2583          	lw	a1,0(s6)
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	ea8080e7          	jalr	-344(ra) # 3dc <printint>
 53c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 53e:	4981                	li	s3,0
 540:	b765                	j	4e8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 542:	008b0913          	addi	s2,s6,8
 546:	4681                	li	a3,0
 548:	4629                	li	a2,10
 54a:	000b2583          	lw	a1,0(s6)
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	e8c080e7          	jalr	-372(ra) # 3dc <printint>
 558:	8b4a                	mv	s6,s2
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b771                	j	4e8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 55e:	008b0913          	addi	s2,s6,8
 562:	4681                	li	a3,0
 564:	866a                	mv	a2,s10
 566:	000b2583          	lw	a1,0(s6)
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	e70080e7          	jalr	-400(ra) # 3dc <printint>
 574:	8b4a                	mv	s6,s2
      state = 0;
 576:	4981                	li	s3,0
 578:	bf85                	j	4e8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 57a:	008b0793          	addi	a5,s6,8
 57e:	f8f43423          	sd	a5,-120(s0)
 582:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 586:	03000593          	li	a1,48
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	e2e080e7          	jalr	-466(ra) # 3ba <putc>
  putc(fd, 'x');
 594:	07800593          	li	a1,120
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	e20080e7          	jalr	-480(ra) # 3ba <putc>
 5a2:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a4:	03c9d793          	srli	a5,s3,0x3c
 5a8:	97de                	add	a5,a5,s7
 5aa:	0007c583          	lbu	a1,0(a5)
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e0a080e7          	jalr	-502(ra) # 3ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5b8:	0992                	slli	s3,s3,0x4
 5ba:	397d                	addiw	s2,s2,-1
 5bc:	fe0914e3          	bnez	s2,5a4 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5c0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b70d                	j	4e8 <vprintf+0x60>
        s = va_arg(ap, char*);
 5c8:	008b0913          	addi	s2,s6,8
 5cc:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5d0:	02098163          	beqz	s3,5f2 <vprintf+0x16a>
        while(*s != 0){
 5d4:	0009c583          	lbu	a1,0(s3)
 5d8:	c5ad                	beqz	a1,642 <vprintf+0x1ba>
          putc(fd, *s);
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	dde080e7          	jalr	-546(ra) # 3ba <putc>
          s++;
 5e4:	0985                	addi	s3,s3,1
        while(*s != 0){
 5e6:	0009c583          	lbu	a1,0(s3)
 5ea:	f9e5                	bnez	a1,5da <vprintf+0x152>
        s = va_arg(ap, char*);
 5ec:	8b4a                	mv	s6,s2
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bde5                	j	4e8 <vprintf+0x60>
          s = "(null)";
 5f2:	00000997          	auipc	s3,0x0
 5f6:	62e98993          	addi	s3,s3,1582 # c20 <close_file+0x32>
        while(*s != 0){
 5fa:	85ee                	mv	a1,s11
 5fc:	bff9                	j	5da <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5fe:	008b0913          	addi	s2,s6,8
 602:	000b4583          	lbu	a1,0(s6)
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	db2080e7          	jalr	-590(ra) # 3ba <putc>
 610:	8b4a                	mv	s6,s2
      state = 0;
 612:	4981                	li	s3,0
 614:	bdd1                	j	4e8 <vprintf+0x60>
        putc(fd, c);
 616:	85d2                	mv	a1,s4
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	da0080e7          	jalr	-608(ra) # 3ba <putc>
      state = 0;
 622:	4981                	li	s3,0
 624:	b5d1                	j	4e8 <vprintf+0x60>
        putc(fd, '%');
 626:	85d2                	mv	a1,s4
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	d90080e7          	jalr	-624(ra) # 3ba <putc>
        putc(fd, c);
 632:	85ca                	mv	a1,s2
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	d84080e7          	jalr	-636(ra) # 3ba <putc>
      state = 0;
 63e:	4981                	li	s3,0
 640:	b565                	j	4e8 <vprintf+0x60>
        s = va_arg(ap, char*);
 642:	8b4a                	mv	s6,s2
      state = 0;
 644:	4981                	li	s3,0
 646:	b54d                	j	4e8 <vprintf+0x60>
    }
  }
}
 648:	70e6                	ld	ra,120(sp)
 64a:	7446                	ld	s0,112(sp)
 64c:	74a6                	ld	s1,104(sp)
 64e:	7906                	ld	s2,96(sp)
 650:	69e6                	ld	s3,88(sp)
 652:	6a46                	ld	s4,80(sp)
 654:	6aa6                	ld	s5,72(sp)
 656:	6b06                	ld	s6,64(sp)
 658:	7be2                	ld	s7,56(sp)
 65a:	7c42                	ld	s8,48(sp)
 65c:	7ca2                	ld	s9,40(sp)
 65e:	7d02                	ld	s10,32(sp)
 660:	6de2                	ld	s11,24(sp)
 662:	6109                	addi	sp,sp,128
 664:	8082                	ret

0000000000000666 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 666:	715d                	addi	sp,sp,-80
 668:	ec06                	sd	ra,24(sp)
 66a:	e822                	sd	s0,16(sp)
 66c:	1000                	addi	s0,sp,32
 66e:	e010                	sd	a2,0(s0)
 670:	e414                	sd	a3,8(s0)
 672:	e818                	sd	a4,16(s0)
 674:	ec1c                	sd	a5,24(s0)
 676:	03043023          	sd	a6,32(s0)
 67a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 67e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 682:	8622                	mv	a2,s0
 684:	00000097          	auipc	ra,0x0
 688:	e04080e7          	jalr	-508(ra) # 488 <vprintf>
}
 68c:	60e2                	ld	ra,24(sp)
 68e:	6442                	ld	s0,16(sp)
 690:	6161                	addi	sp,sp,80
 692:	8082                	ret

0000000000000694 <printf>:

void
printf(const char *fmt, ...)
{
 694:	711d                	addi	sp,sp,-96
 696:	ec06                	sd	ra,24(sp)
 698:	e822                	sd	s0,16(sp)
 69a:	1000                	addi	s0,sp,32
 69c:	e40c                	sd	a1,8(s0)
 69e:	e810                	sd	a2,16(s0)
 6a0:	ec14                	sd	a3,24(s0)
 6a2:	f018                	sd	a4,32(s0)
 6a4:	f41c                	sd	a5,40(s0)
 6a6:	03043823          	sd	a6,48(s0)
 6aa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ae:	00840613          	addi	a2,s0,8
 6b2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6b6:	85aa                	mv	a1,a0
 6b8:	4505                	li	a0,1
 6ba:	00000097          	auipc	ra,0x0
 6be:	dce080e7          	jalr	-562(ra) # 488 <vprintf>
}
 6c2:	60e2                	ld	ra,24(sp)
 6c4:	6442                	ld	s0,16(sp)
 6c6:	6125                	addi	sp,sp,96
 6c8:	8082                	ret

00000000000006ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ca:	1141                	addi	sp,sp,-16
 6cc:	e422                	sd	s0,8(sp)
 6ce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d4:	00001797          	auipc	a5,0x1
 6d8:	92c7b783          	ld	a5,-1748(a5) # 1000 <freep>
 6dc:	a02d                	j	706 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6de:	4618                	lw	a4,8(a2)
 6e0:	9f2d                	addw	a4,a4,a1
 6e2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e6:	6398                	ld	a4,0(a5)
 6e8:	6310                	ld	a2,0(a4)
 6ea:	a83d                	j	728 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ec:	ff852703          	lw	a4,-8(a0)
 6f0:	9f31                	addw	a4,a4,a2
 6f2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6f4:	ff053683          	ld	a3,-16(a0)
 6f8:	a091                	j	73c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fa:	6398                	ld	a4,0(a5)
 6fc:	00e7e463          	bltu	a5,a4,704 <free+0x3a>
 700:	00e6ea63          	bltu	a3,a4,714 <free+0x4a>
{
 704:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 706:	fed7fae3          	bgeu	a5,a3,6fa <free+0x30>
 70a:	6398                	ld	a4,0(a5)
 70c:	00e6e463          	bltu	a3,a4,714 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 710:	fee7eae3          	bltu	a5,a4,704 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 714:	ff852583          	lw	a1,-8(a0)
 718:	6390                	ld	a2,0(a5)
 71a:	02059813          	slli	a6,a1,0x20
 71e:	01c85713          	srli	a4,a6,0x1c
 722:	9736                	add	a4,a4,a3
 724:	fae60de3          	beq	a2,a4,6de <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 728:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 72c:	4790                	lw	a2,8(a5)
 72e:	02061593          	slli	a1,a2,0x20
 732:	01c5d713          	srli	a4,a1,0x1c
 736:	973e                	add	a4,a4,a5
 738:	fae68ae3          	beq	a3,a4,6ec <free+0x22>
    p->s.ptr = bp->s.ptr;
 73c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 73e:	00001717          	auipc	a4,0x1
 742:	8cf73123          	sd	a5,-1854(a4) # 1000 <freep>
}
 746:	6422                	ld	s0,8(sp)
 748:	0141                	addi	sp,sp,16
 74a:	8082                	ret

000000000000074c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 74c:	7139                	addi	sp,sp,-64
 74e:	fc06                	sd	ra,56(sp)
 750:	f822                	sd	s0,48(sp)
 752:	f426                	sd	s1,40(sp)
 754:	f04a                	sd	s2,32(sp)
 756:	ec4e                	sd	s3,24(sp)
 758:	e852                	sd	s4,16(sp)
 75a:	e456                	sd	s5,8(sp)
 75c:	e05a                	sd	s6,0(sp)
 75e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 760:	02051493          	slli	s1,a0,0x20
 764:	9081                	srli	s1,s1,0x20
 766:	04bd                	addi	s1,s1,15
 768:	8091                	srli	s1,s1,0x4
 76a:	0014899b          	addiw	s3,s1,1
 76e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 770:	00001517          	auipc	a0,0x1
 774:	89053503          	ld	a0,-1904(a0) # 1000 <freep>
 778:	c515                	beqz	a0,7a4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 77c:	4798                	lw	a4,8(a5)
 77e:	02977f63          	bgeu	a4,s1,7bc <malloc+0x70>
 782:	8a4e                	mv	s4,s3
 784:	0009871b          	sext.w	a4,s3
 788:	6685                	lui	a3,0x1
 78a:	00d77363          	bgeu	a4,a3,790 <malloc+0x44>
 78e:	6a05                	lui	s4,0x1
 790:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 794:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 798:	00001917          	auipc	s2,0x1
 79c:	86890913          	addi	s2,s2,-1944 # 1000 <freep>
  if(p == (char*)-1)
 7a0:	5afd                	li	s5,-1
 7a2:	a895                	j	816 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7a4:	00001797          	auipc	a5,0x1
 7a8:	86c78793          	addi	a5,a5,-1940 # 1010 <base>
 7ac:	00001717          	auipc	a4,0x1
 7b0:	84f73a23          	sd	a5,-1964(a4) # 1000 <freep>
 7b4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7b6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ba:	b7e1                	j	782 <malloc+0x36>
      if(p->s.size == nunits)
 7bc:	02e48c63          	beq	s1,a4,7f4 <malloc+0xa8>
        p->s.size -= nunits;
 7c0:	4137073b          	subw	a4,a4,s3
 7c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7c6:	02071693          	slli	a3,a4,0x20
 7ca:	01c6d713          	srli	a4,a3,0x1c
 7ce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7d4:	00001717          	auipc	a4,0x1
 7d8:	82a73623          	sd	a0,-2004(a4) # 1000 <freep>
      return (void*)(p + 1);
 7dc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7e0:	70e2                	ld	ra,56(sp)
 7e2:	7442                	ld	s0,48(sp)
 7e4:	74a2                	ld	s1,40(sp)
 7e6:	7902                	ld	s2,32(sp)
 7e8:	69e2                	ld	s3,24(sp)
 7ea:	6a42                	ld	s4,16(sp)
 7ec:	6aa2                	ld	s5,8(sp)
 7ee:	6b02                	ld	s6,0(sp)
 7f0:	6121                	addi	sp,sp,64
 7f2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7f4:	6398                	ld	a4,0(a5)
 7f6:	e118                	sd	a4,0(a0)
 7f8:	bff1                	j	7d4 <malloc+0x88>
  hp->s.size = nu;
 7fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7fe:	0541                	addi	a0,a0,16
 800:	00000097          	auipc	ra,0x0
 804:	eca080e7          	jalr	-310(ra) # 6ca <free>
  return freep;
 808:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 80c:	d971                	beqz	a0,7e0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 810:	4798                	lw	a4,8(a5)
 812:	fa9775e3          	bgeu	a4,s1,7bc <malloc+0x70>
    if(p == freep)
 816:	00093703          	ld	a4,0(s2)
 81a:	853e                	mv	a0,a5
 81c:	fef719e3          	bne	a4,a5,80e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 820:	8552                	mv	a0,s4
 822:	00000097          	auipc	ra,0x0
 826:	b70080e7          	jalr	-1168(ra) # 392 <sbrk>
  if(p == (char*)-1)
 82a:	fd5518e3          	bne	a0,s5,7fa <malloc+0xae>
        return 0;
 82e:	4501                	li	a0,0
 830:	bf45                	j	7e0 <malloc+0x94>

0000000000000832 <head_run>:
#include "user/user.h"
#include "gelibs/file.h"

extern int read_line(int fd, char * buffer);

void head_run(int fd, int numOfLines){
 832:	dc010113          	addi	sp,sp,-576
 836:	22113c23          	sd	ra,568(sp)
 83a:	22813823          	sd	s0,560(sp)
 83e:	22913423          	sd	s1,552(sp)
 842:	23213023          	sd	s2,544(sp)
 846:	21313c23          	sd	s3,536(sp)
 84a:	21413823          	sd	s4,528(sp)
 84e:	21513423          	sd	s5,520(sp)
 852:	0480                	addi	s0,sp,576
 854:	89aa                	mv	s3,a0
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 856:	892e                	mv	s2,a1

		readStatus = read_line(fd, line);
		
		if (readStatus == READ_ERROR){
 858:	5a7d                	li	s4,-1
			printf("[ERR] Error reading from the file \n");
			break;
		}

		printf("%s",line);
 85a:	00000a97          	auipc	s5,0x0
 85e:	466a8a93          	addi	s5,s5,1126 # cc0 <digits+0x40>
	while(numOfLines--){
 862:	02090e63          	beqz	s2,89e <head_run+0x6c>
		readStatus = read_line(fd, line);
 866:	dc840593          	addi	a1,s0,-568
 86a:	854e                	mv	a0,s3
 86c:	00000097          	auipc	ra,0x0
 870:	324080e7          	jalr	804(ra) # b90 <read_line>
 874:	84aa                	mv	s1,a0
		if (readStatus == READ_ERROR){
 876:	01450c63          	beq	a0,s4,88e <head_run+0x5c>
		printf("%s",line);
 87a:	dc840593          	addi	a1,s0,-568
 87e:	8556                	mv	a0,s5
 880:	00000097          	auipc	ra,0x0
 884:	e14080e7          	jalr	-492(ra) # 694 <printf>

		if (readStatus == READ_EOF )
 888:	397d                	addiw	s2,s2,-1
 88a:	fce1                	bnez	s1,862 <head_run+0x30>
 88c:	a809                	j	89e <head_run+0x6c>
			printf("[ERR] Error reading from the file \n");
 88e:	00000517          	auipc	a0,0x0
 892:	40a50513          	addi	a0,a0,1034 # c98 <digits+0x18>
 896:	00000097          	auipc	ra,0x0
 89a:	dfe080e7          	jalr	-514(ra) # 694 <printf>
			break;
	}
}
 89e:	23813083          	ld	ra,568(sp)
 8a2:	23013403          	ld	s0,560(sp)
 8a6:	22813483          	ld	s1,552(sp)
 8aa:	22013903          	ld	s2,544(sp)
 8ae:	21813983          	ld	s3,536(sp)
 8b2:	21013a03          	ld	s4,528(sp)
 8b6:	20813a83          	ld	s5,520(sp)
 8ba:	24010113          	addi	sp,sp,576
 8be:	8082                	ret

00000000000008c0 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 8c0:	ba010113          	addi	sp,sp,-1120
 8c4:	44113c23          	sd	ra,1112(sp)
 8c8:	44813823          	sd	s0,1104(sp)
 8cc:	44913423          	sd	s1,1096(sp)
 8d0:	45213023          	sd	s2,1088(sp)
 8d4:	43313c23          	sd	s3,1080(sp)
 8d8:	43413823          	sd	s4,1072(sp)
 8dc:	43513423          	sd	s5,1064(sp)
 8e0:	43613023          	sd	s6,1056(sp)
 8e4:	41713c23          	sd	s7,1048(sp)
 8e8:	41813823          	sd	s8,1040(sp)
 8ec:	41913423          	sd	s9,1032(sp)
 8f0:	41a13023          	sd	s10,1024(sp)
 8f4:	3fb13c23          	sd	s11,1016(sp)
 8f8:	46010413          	addi	s0,sp,1120
 8fc:	8aaa                	mv	s5,a0
 8fe:	8bae                	mv	s7,a1
 900:	8db2                	mv	s11,a2
 902:	8c36                	mv	s8,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 904:	d9840593          	addi	a1,s0,-616
 908:	00000097          	auipc	ra,0x0
 90c:	288080e7          	jalr	648(ra) # b90 <read_line>

  if (readStatus == READ_ERROR)
 910:	57fd                	li	a5,-1
 912:	04f50163          	beq	a0,a5,954 <uniq_run+0x94>
 916:	4b01                	li	s6,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 918:	ed21                	bnez	a0,970 <uniq_run+0xb0>





}
 91a:	45813083          	ld	ra,1112(sp)
 91e:	45013403          	ld	s0,1104(sp)
 922:	44813483          	ld	s1,1096(sp)
 926:	44013903          	ld	s2,1088(sp)
 92a:	43813983          	ld	s3,1080(sp)
 92e:	43013a03          	ld	s4,1072(sp)
 932:	42813a83          	ld	s5,1064(sp)
 936:	42013b03          	ld	s6,1056(sp)
 93a:	41813b83          	ld	s7,1048(sp)
 93e:	41013c03          	ld	s8,1040(sp)
 942:	40813c83          	ld	s9,1032(sp)
 946:	40013d03          	ld	s10,1024(sp)
 94a:	3f813d83          	ld	s11,1016(sp)
 94e:	46010113          	addi	sp,sp,1120
 952:	8082                	ret
    printf("[ERR] Error reading from the file ");
 954:	00000517          	auipc	a0,0x0
 958:	37450513          	addi	a0,a0,884 # cc8 <digits+0x48>
 95c:	00000097          	auipc	ra,0x0
 960:	d38080e7          	jalr	-712(ra) # 694 <printf>
 964:	bf5d                	j	91a <uniq_run+0x5a>
 966:	87ca                	mv	a5,s2
 968:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 96a:	84be                	mv	s1,a5
        lineCount = 1;
 96c:	89ea                	mv	s3,s10
 96e:	a8fd                	j	a6c <uniq_run+0x1ac>
    int isEof = 0;
 970:	4a01                	li	s4,0
    int lineCount=1;
 972:	4985                	li	s3,1
  char * line2 = buffer2;
 974:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 978:	d9840913          	addi	s2,s0,-616
      if (readStatus == READ_ERROR){
 97c:	5cfd                	li	s9,-1
        isEof = 1;
 97e:	4d05                	li	s10,1
 980:	a0f5                	j	a6c <uniq_run+0x1ac>
        printf("[ERR] Error reading from the file");
 982:	00000517          	auipc	a0,0x0
 986:	36e50513          	addi	a0,a0,878 # cf0 <digits+0x70>
 98a:	00000097          	auipc	ra,0x0
 98e:	d0a080e7          	jalr	-758(ra) # 694 <printf>
        break;
 992:	b761                	j	91a <uniq_run+0x5a>
        compareStatus = compare_str_ic(line1, line2);
 994:	85a6                	mv	a1,s1
 996:	854a                	mv	a0,s2
 998:	00000097          	auipc	ra,0x0
 99c:	184080e7          	jalr	388(ra) # b1c <compare_str_ic>
 9a0:	a8d5                	j	a94 <uniq_run+0x1d4>
                  printf("%s",line1);
 9a2:	85ca                	mv	a1,s2
 9a4:	00000517          	auipc	a0,0x0
 9a8:	31c50513          	addi	a0,a0,796 # cc0 <digits+0x40>
 9ac:	00000097          	auipc	ra,0x0
 9b0:	ce8080e7          	jalr	-792(ra) # 694 <printf>
        lineCount = 1;
 9b4:	89da                	mv	s3,s6
                  printf("%s",line1);
 9b6:	87ca                	mv	a5,s2
 9b8:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 9ba:	84be                	mv	s1,a5
        isRepeated = 0 ;
 9bc:	4b01                	li	s6,0
 9be:	a07d                	j	a6c <uniq_run+0x1ac>
            if (showCount){
 9c0:	040d8b63          	beqz	s11,a16 <uniq_run+0x156>
              printf("<%d> %s",lineCount,line1);
 9c4:	864a                	mv	a2,s2
 9c6:	85ce                	mv	a1,s3
 9c8:	00000517          	auipc	a0,0x0
 9cc:	35050513          	addi	a0,a0,848 # d18 <digits+0x98>
 9d0:	00000097          	auipc	ra,0x0
 9d4:	cc4080e7          	jalr	-828(ra) # 694 <printf>
              if (isEof && get_strlen(line2)){
 9d8:	000a1863          	bnez	s4,9e8 <uniq_run+0x128>
        isRepeated = 0 ;
 9dc:	8b52                	mv	s6,s4
 9de:	87ca                	mv	a5,s2
 9e0:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 9e2:	84be                	mv	s1,a5
        lineCount = 1;
 9e4:	89ea                	mv	s3,s10
 9e6:	a059                	j	a6c <uniq_run+0x1ac>
              if (isEof && get_strlen(line2)){
 9e8:	8526                	mv	a0,s1
 9ea:	00000097          	auipc	ra,0x0
 9ee:	0d8080e7          	jalr	216(ra) # ac2 <get_strlen>
 9f2:	8b2a                	mv	s6,a0
 9f4:	e511                	bnez	a0,a00 <uniq_run+0x140>
        lineCount = 1;
 9f6:	89d2                	mv	s3,s4
 9f8:	87ca                	mv	a5,s2
 9fa:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 9fc:	84be                	mv	s1,a5
 9fe:	a0bd                	j	a6c <uniq_run+0x1ac>
                printf("<%d> %s",lineCount,line2); 
 a00:	8626                	mv	a2,s1
 a02:	85ce                	mv	a1,s3
 a04:	00000517          	auipc	a0,0x0
 a08:	31450513          	addi	a0,a0,788 # d18 <digits+0x98>
 a0c:	00000097          	auipc	ra,0x0
 a10:	c88080e7          	jalr	-888(ra) # 694 <printf>
                break;
 a14:	b719                	j	91a <uniq_run+0x5a>
              printf("%s",line1);
 a16:	85ca                	mv	a1,s2
 a18:	00000517          	auipc	a0,0x0
 a1c:	2a850513          	addi	a0,a0,680 # cc0 <digits+0x40>
 a20:	00000097          	auipc	ra,0x0
 a24:	c74080e7          	jalr	-908(ra) # 694 <printf>
              if (isEof && get_strlen(line2)){
 a28:	000a1863          	bnez	s4,a38 <uniq_run+0x178>
        isRepeated = 0 ;
 a2c:	8b52                	mv	s6,s4
 a2e:	87ca                	mv	a5,s2
 a30:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 a32:	84be                	mv	s1,a5
        lineCount = 1;
 a34:	89ea                	mv	s3,s10
 a36:	a81d                	j	a6c <uniq_run+0x1ac>
              if (isEof && get_strlen(line2)){
 a38:	8526                	mv	a0,s1
 a3a:	00000097          	auipc	ra,0x0
 a3e:	088080e7          	jalr	136(ra) # ac2 <get_strlen>
 a42:	8b2a                	mv	s6,a0
 a44:	e511                	bnez	a0,a50 <uniq_run+0x190>
        lineCount = 1;
 a46:	89d2                	mv	s3,s4
 a48:	87ca                	mv	a5,s2
 a4a:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 a4c:	84be                	mv	s1,a5
 a4e:	a839                	j	a6c <uniq_run+0x1ac>
                printf("%s",line2);
 a50:	85a6                	mv	a1,s1
 a52:	00000517          	auipc	a0,0x0
 a56:	26e50513          	addi	a0,a0,622 # cc0 <digits+0x40>
 a5a:	00000097          	auipc	ra,0x0
 a5e:	c3a080e7          	jalr	-966(ra) # 694 <printf>
                break;
 a62:	bd65                	j	91a <uniq_run+0x5a>
          if (repeatedLines && !isRepeated){
 a64:	000c0363          	beqz	s8,a6a <uniq_run+0x1aa>
 a68:	8b6a                	mv	s6,s10
          lineCount++;
 a6a:	2985                	addiw	s3,s3,1
      readStatus = read_line(fd, line2);
 a6c:	85a6                	mv	a1,s1
 a6e:	8556                	mv	a0,s5
 a70:	00000097          	auipc	ra,0x0
 a74:	120080e7          	jalr	288(ra) # b90 <read_line>
      if (readStatus == READ_ERROR){
 a78:	f19505e3          	beq	a0,s9,982 <uniq_run+0xc2>
      if (readStatus == READ_EOF){
 a7c:	e501                	bnez	a0,a84 <uniq_run+0x1c4>
        if (isEof)
 a7e:	e80a1ee3          	bnez	s4,91a <uniq_run+0x5a>
        isEof = 1;
 a82:	8a6a                	mv	s4,s10
      if (!ignoreCase)
 a84:	f00b98e3          	bnez	s7,994 <uniq_run+0xd4>
        compareStatus = compare_str(line1, line2);
 a88:	85a6                	mv	a1,s1
 a8a:	854a                	mv	a0,s2
 a8c:	00000097          	auipc	ra,0x0
 a90:	062080e7          	jalr	98(ra) # aee <compare_str>
      if (compareStatus != 0){ // Not equal
 a94:	d961                	beqz	a0,a64 <uniq_run+0x1a4>
          if (repeatedLines){
 a96:	f20c05e3          	beqz	s8,9c0 <uniq_run+0x100>
            if (isRepeated){
 a9a:	ec0b06e3          	beqz	s6,966 <uniq_run+0xa6>
                if (showCount)
 a9e:	f00d82e3          	beqz	s11,9a2 <uniq_run+0xe2>
                  printf("<%d> %s",lineCount,line1);
 aa2:	864a                	mv	a2,s2
 aa4:	85ce                	mv	a1,s3
 aa6:	00000517          	auipc	a0,0x0
 aaa:	27250513          	addi	a0,a0,626 # d18 <digits+0x98>
 aae:	00000097          	auipc	ra,0x0
 ab2:	be6080e7          	jalr	-1050(ra) # 694 <printf>
        lineCount = 1;
 ab6:	89da                	mv	s3,s6
 ab8:	87ca                	mv	a5,s2
 aba:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 abc:	84be                	mv	s1,a5
        isRepeated = 0 ;
 abe:	4b01                	li	s6,0
 ac0:	b775                	j	a6c <uniq_run+0x1ac>

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

0000000000000b78 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 b78:	1141                	addi	sp,sp,-16
 b7a:	e406                	sd	ra,8(sp)
 b7c:	e022                	sd	s0,0(sp)
 b7e:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 b80:	fffff097          	auipc	ra,0xfffff
 b84:	7ca080e7          	jalr	1994(ra) # 34a <open>
	return fd;
}
 b88:	60a2                	ld	ra,8(sp)
 b8a:	6402                	ld	s0,0(sp)
 b8c:	0141                	addi	sp,sp,16
 b8e:	8082                	ret

0000000000000b90 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 b90:	7139                	addi	sp,sp,-64
 b92:	fc06                	sd	ra,56(sp)
 b94:	f822                	sd	s0,48(sp)
 b96:	f426                	sd	s1,40(sp)
 b98:	f04a                	sd	s2,32(sp)
 b9a:	ec4e                	sd	s3,24(sp)
 b9c:	e852                	sd	s4,16(sp)
 b9e:	0080                	addi	s0,sp,64
 ba0:	89aa                	mv	s3,a0
 ba2:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 ba4:	4901                	li	s2,0
			return byteCount; 
		}
		*buffer++ = readByte;
		byteCount++;

		if (readByte == '\n'){
 ba6:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 ba8:	4605                	li	a2,1
 baa:	fcf40593          	addi	a1,s0,-49
 bae:	854e                	mv	a0,s3
 bb0:	fffff097          	auipc	ra,0xfffff
 bb4:	772080e7          	jalr	1906(ra) # 322 <read>
		if (readStatus <= 0){
 bb8:	02a05563          	blez	a0,be2 <read_line+0x52>
		*buffer++ = readByte;
 bbc:	0485                	addi	s1,s1,1
 bbe:	fcf44783          	lbu	a5,-49(s0)
 bc2:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 bc6:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 bc8:	ff4790e3          	bne	a5,s4,ba8 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 bcc:	00048023          	sb	zero,0(s1)
		byteCount++;
 bd0:	854a                	mv	a0,s2
			return byteCount;
		}
	}
}
 bd2:	70e2                	ld	ra,56(sp)
 bd4:	7442                	ld	s0,48(sp)
 bd6:	74a2                	ld	s1,40(sp)
 bd8:	7902                	ld	s2,32(sp)
 bda:	69e2                	ld	s3,24(sp)
 bdc:	6a42                	ld	s4,16(sp)
 bde:	6121                	addi	sp,sp,64
 be0:	8082                	ret
			*buffer = 0;  // Nullifying the end of the string
 be2:	00048023          	sb	zero,0(s1)
			if (byteCount == 0)
 be6:	fe0906e3          	beqz	s2,bd2 <read_line+0x42>
 bea:	854a                	mv	a0,s2
 bec:	b7dd                	j	bd2 <read_line+0x42>

0000000000000bee <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 bee:	1141                	addi	sp,sp,-16
 bf0:	e406                	sd	ra,8(sp)
 bf2:	e022                	sd	s0,0(sp)
 bf4:	0800                	addi	s0,sp,16
	close(fd);
 bf6:	fffff097          	auipc	ra,0xfffff
 bfa:	73c080e7          	jalr	1852(ra) # 332 <close>
}
 bfe:	60a2                	ld	ra,8(sp)
 c00:	6402                	ld	s0,0(sp)
 c02:	0141                	addi	sp,sp,16
 c04:	8082                	ret
