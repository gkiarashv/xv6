
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	39c080e7          	jalr	924(ra) # 3bc <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	390080e7          	jalr	912(ra) # 3c4 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	d6058593          	addi	a1,a1,-672 # da0 <get_time_perf+0x60>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	6e6080e7          	jalr	1766(ra) # 730 <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	350080e7          	jalr	848(ra) # 3a4 <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	d4a58593          	addi	a1,a1,-694 # db8 <get_time_perf+0x78>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	6b8080e7          	jalr	1720(ra) # 730 <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	322080e7          	jalr	802(ra) # 3a4 <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	e052                	sd	s4,0(sp)
  98:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9a:	4785                	li	a5,1
  9c:	04a7d763          	bge	a5,a0,ea <main+0x60>
  a0:	00858913          	addi	s2,a1,8
  a4:	ffe5099b          	addiw	s3,a0,-2
  a8:	02099793          	slli	a5,s3,0x20
  ac:	01d7d993          	srli	s3,a5,0x1d
  b0:	05c1                	addi	a1,a1,16
  b2:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b4:	4581                	li	a1,0
  b6:	00093503          	ld	a0,0(s2) # 1010 <buf>
  ba:	00000097          	auipc	ra,0x0
  be:	32a080e7          	jalr	810(ra) # 3e4 <open>
  c2:	84aa                	mv	s1,a0
  c4:	02054d63          	bltz	a0,fe <main+0x74>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c8:	00000097          	auipc	ra,0x0
  cc:	f38080e7          	jalr	-200(ra) # 0 <cat>
    close(fd);
  d0:	8526                	mv	a0,s1
  d2:	00000097          	auipc	ra,0x0
  d6:	2fa080e7          	jalr	762(ra) # 3cc <close>
  for(i = 1; i < argc; i++){
  da:	0921                	addi	s2,s2,8
  dc:	fd391ce3          	bne	s2,s3,b4 <main+0x2a>
  }
  exit(0);
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	2c2080e7          	jalr	706(ra) # 3a4 <exit>
    cat(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	f14080e7          	jalr	-236(ra) # 0 <cat>
    exit(0);
  f4:	4501                	li	a0,0
  f6:	00000097          	auipc	ra,0x0
  fa:	2ae080e7          	jalr	686(ra) # 3a4 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  fe:	00093603          	ld	a2,0(s2)
 102:	00001597          	auipc	a1,0x1
 106:	cce58593          	addi	a1,a1,-818 # dd0 <get_time_perf+0x90>
 10a:	4509                	li	a0,2
 10c:	00000097          	auipc	ra,0x0
 110:	624080e7          	jalr	1572(ra) # 730 <fprintf>
      exit(1);
 114:	4505                	li	a0,1
 116:	00000097          	auipc	ra,0x0
 11a:	28e080e7          	jalr	654(ra) # 3a4 <exit>

000000000000011e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  extern int main();
  main();
 126:	00000097          	auipc	ra,0x0
 12a:	f64080e7          	jalr	-156(ra) # 8a <main>
  exit(0);
 12e:	4501                	li	a0,0
 130:	00000097          	auipc	ra,0x0
 134:	274080e7          	jalr	628(ra) # 3a4 <exit>

0000000000000138 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e422                	sd	s0,8(sp)
 13c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13e:	87aa                	mv	a5,a0
 140:	0585                	addi	a1,a1,1
 142:	0785                	addi	a5,a5,1
 144:	fff5c703          	lbu	a4,-1(a1)
 148:	fee78fa3          	sb	a4,-1(a5)
 14c:	fb75                	bnez	a4,140 <strcpy+0x8>
    ;
  return os;
}
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 154:	1141                	addi	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cb91                	beqz	a5,172 <strcmp+0x1e>
 160:	0005c703          	lbu	a4,0(a1)
 164:	00f71763          	bne	a4,a5,172 <strcmp+0x1e>
    p++, q++;
 168:	0505                	addi	a0,a0,1
 16a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 16c:	00054783          	lbu	a5,0(a0)
 170:	fbe5                	bnez	a5,160 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 172:	0005c503          	lbu	a0,0(a1)
}
 176:	40a7853b          	subw	a0,a5,a0
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret

0000000000000180 <strlen>:

uint
strlen(const char *s)
{
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 186:	00054783          	lbu	a5,0(a0)
 18a:	cf91                	beqz	a5,1a6 <strlen+0x26>
 18c:	0505                	addi	a0,a0,1
 18e:	87aa                	mv	a5,a0
 190:	4685                	li	a3,1
 192:	9e89                	subw	a3,a3,a0
 194:	00f6853b          	addw	a0,a3,a5
 198:	0785                	addi	a5,a5,1
 19a:	fff7c703          	lbu	a4,-1(a5)
 19e:	fb7d                	bnez	a4,194 <strlen+0x14>
    ;
  return n;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret
  for(n = 0; s[n]; n++)
 1a6:	4501                	li	a0,0
 1a8:	bfe5                	j	1a0 <strlen+0x20>

00000000000001aa <memset>:

void*
memset(void *dst, int c, uint n)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b0:	ca19                	beqz	a2,1c6 <memset+0x1c>
 1b2:	87aa                	mv	a5,a0
 1b4:	1602                	slli	a2,a2,0x20
 1b6:	9201                	srli	a2,a2,0x20
 1b8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c0:	0785                	addi	a5,a5,1
 1c2:	fee79de3          	bne	a5,a4,1bc <memset+0x12>
  }
  return dst;
}
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <strchr>:

char*
strchr(const char *s, char c)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cb99                	beqz	a5,1ec <strchr+0x20>
    if(*s == c)
 1d8:	00f58763          	beq	a1,a5,1e6 <strchr+0x1a>
  for(; *s; s++)
 1dc:	0505                	addi	a0,a0,1
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	fbfd                	bnez	a5,1d8 <strchr+0xc>
      return (char*)s;
  return 0;
 1e4:	4501                	li	a0,0
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret
  return 0;
 1ec:	4501                	li	a0,0
 1ee:	bfe5                	j	1e6 <strchr+0x1a>

00000000000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	711d                	addi	sp,sp,-96
 1f2:	ec86                	sd	ra,88(sp)
 1f4:	e8a2                	sd	s0,80(sp)
 1f6:	e4a6                	sd	s1,72(sp)
 1f8:	e0ca                	sd	s2,64(sp)
 1fa:	fc4e                	sd	s3,56(sp)
 1fc:	f852                	sd	s4,48(sp)
 1fe:	f456                	sd	s5,40(sp)
 200:	f05a                	sd	s6,32(sp)
 202:	ec5e                	sd	s7,24(sp)
 204:	1080                	addi	s0,sp,96
 206:	8baa                	mv	s7,a0
 208:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20a:	892a                	mv	s2,a0
 20c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 20e:	4aa9                	li	s5,10
 210:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 212:	89a6                	mv	s3,s1
 214:	2485                	addiw	s1,s1,1
 216:	0344d863          	bge	s1,s4,246 <gets+0x56>
    cc = read(0, &c, 1);
 21a:	4605                	li	a2,1
 21c:	faf40593          	addi	a1,s0,-81
 220:	4501                	li	a0,0
 222:	00000097          	auipc	ra,0x0
 226:	19a080e7          	jalr	410(ra) # 3bc <read>
    if(cc < 1)
 22a:	00a05e63          	blez	a0,246 <gets+0x56>
    buf[i++] = c;
 22e:	faf44783          	lbu	a5,-81(s0)
 232:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 236:	01578763          	beq	a5,s5,244 <gets+0x54>
 23a:	0905                	addi	s2,s2,1
 23c:	fd679be3          	bne	a5,s6,212 <gets+0x22>
  for(i=0; i+1 < max; ){
 240:	89a6                	mv	s3,s1
 242:	a011                	j	246 <gets+0x56>
 244:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 246:	99de                	add	s3,s3,s7
 248:	00098023          	sb	zero,0(s3)
  return buf;
}
 24c:	855e                	mv	a0,s7
 24e:	60e6                	ld	ra,88(sp)
 250:	6446                	ld	s0,80(sp)
 252:	64a6                	ld	s1,72(sp)
 254:	6906                	ld	s2,64(sp)
 256:	79e2                	ld	s3,56(sp)
 258:	7a42                	ld	s4,48(sp)
 25a:	7aa2                	ld	s5,40(sp)
 25c:	7b02                	ld	s6,32(sp)
 25e:	6be2                	ld	s7,24(sp)
 260:	6125                	addi	sp,sp,96
 262:	8082                	ret

0000000000000264 <stat>:

int
stat(const char *n, struct stat *st)
{
 264:	1101                	addi	sp,sp,-32
 266:	ec06                	sd	ra,24(sp)
 268:	e822                	sd	s0,16(sp)
 26a:	e426                	sd	s1,8(sp)
 26c:	e04a                	sd	s2,0(sp)
 26e:	1000                	addi	s0,sp,32
 270:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 272:	4581                	li	a1,0
 274:	00000097          	auipc	ra,0x0
 278:	170080e7          	jalr	368(ra) # 3e4 <open>
  if(fd < 0)
 27c:	02054563          	bltz	a0,2a6 <stat+0x42>
 280:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 282:	85ca                	mv	a1,s2
 284:	00000097          	auipc	ra,0x0
 288:	178080e7          	jalr	376(ra) # 3fc <fstat>
 28c:	892a                	mv	s2,a0
  close(fd);
 28e:	8526                	mv	a0,s1
 290:	00000097          	auipc	ra,0x0
 294:	13c080e7          	jalr	316(ra) # 3cc <close>
  return r;
}
 298:	854a                	mv	a0,s2
 29a:	60e2                	ld	ra,24(sp)
 29c:	6442                	ld	s0,16(sp)
 29e:	64a2                	ld	s1,8(sp)
 2a0:	6902                	ld	s2,0(sp)
 2a2:	6105                	addi	sp,sp,32
 2a4:	8082                	ret
    return -1;
 2a6:	597d                	li	s2,-1
 2a8:	bfc5                	j	298 <stat+0x34>

00000000000002aa <atoi>:

int
atoi(const char *s)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b0:	00054683          	lbu	a3,0(a0)
 2b4:	fd06879b          	addiw	a5,a3,-48
 2b8:	0ff7f793          	zext.b	a5,a5
 2bc:	4625                	li	a2,9
 2be:	02f66863          	bltu	a2,a5,2ee <atoi+0x44>
 2c2:	872a                	mv	a4,a0
  n = 0;
 2c4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2c6:	0705                	addi	a4,a4,1
 2c8:	0025179b          	slliw	a5,a0,0x2
 2cc:	9fa9                	addw	a5,a5,a0
 2ce:	0017979b          	slliw	a5,a5,0x1
 2d2:	9fb5                	addw	a5,a5,a3
 2d4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d8:	00074683          	lbu	a3,0(a4)
 2dc:	fd06879b          	addiw	a5,a3,-48
 2e0:	0ff7f793          	zext.b	a5,a5
 2e4:	fef671e3          	bgeu	a2,a5,2c6 <atoi+0x1c>
  return n;
}
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
  n = 0;
 2ee:	4501                	li	a0,0
 2f0:	bfe5                	j	2e8 <atoi+0x3e>

00000000000002f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f8:	02b57463          	bgeu	a0,a1,320 <memmove+0x2e>
    while(n-- > 0)
 2fc:	00c05f63          	blez	a2,31a <memmove+0x28>
 300:	1602                	slli	a2,a2,0x20
 302:	9201                	srli	a2,a2,0x20
 304:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 308:	872a                	mv	a4,a0
      *dst++ = *src++;
 30a:	0585                	addi	a1,a1,1
 30c:	0705                	addi	a4,a4,1
 30e:	fff5c683          	lbu	a3,-1(a1)
 312:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 316:	fee79ae3          	bne	a5,a4,30a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
    dst += n;
 320:	00c50733          	add	a4,a0,a2
    src += n;
 324:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 326:	fec05ae3          	blez	a2,31a <memmove+0x28>
 32a:	fff6079b          	addiw	a5,a2,-1
 32e:	1782                	slli	a5,a5,0x20
 330:	9381                	srli	a5,a5,0x20
 332:	fff7c793          	not	a5,a5
 336:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 338:	15fd                	addi	a1,a1,-1
 33a:	177d                	addi	a4,a4,-1
 33c:	0005c683          	lbu	a3,0(a1)
 340:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 344:	fee79ae3          	bne	a5,a4,338 <memmove+0x46>
 348:	bfc9                	j	31a <memmove+0x28>

000000000000034a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 350:	ca05                	beqz	a2,380 <memcmp+0x36>
 352:	fff6069b          	addiw	a3,a2,-1
 356:	1682                	slli	a3,a3,0x20
 358:	9281                	srli	a3,a3,0x20
 35a:	0685                	addi	a3,a3,1
 35c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 35e:	00054783          	lbu	a5,0(a0)
 362:	0005c703          	lbu	a4,0(a1)
 366:	00e79863          	bne	a5,a4,376 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 36a:	0505                	addi	a0,a0,1
    p2++;
 36c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 36e:	fed518e3          	bne	a0,a3,35e <memcmp+0x14>
  }
  return 0;
 372:	4501                	li	a0,0
 374:	a019                	j	37a <memcmp+0x30>
      return *p1 - *p2;
 376:	40e7853b          	subw	a0,a5,a4
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
  return 0;
 380:	4501                	li	a0,0
 382:	bfe5                	j	37a <memcmp+0x30>

0000000000000384 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 38c:	00000097          	auipc	ra,0x0
 390:	f66080e7          	jalr	-154(ra) # 2f2 <memmove>
}
 394:	60a2                	ld	ra,8(sp)
 396:	6402                	ld	s0,0(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret

000000000000039c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 39c:	4885                	li	a7,1
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a4:	4889                	li	a7,2
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ac:	488d                	li	a7,3
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b4:	4891                	li	a7,4
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <read>:
.global read
read:
 li a7, SYS_read
 3bc:	4895                	li	a7,5
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <write>:
.global write
write:
 li a7, SYS_write
 3c4:	48c1                	li	a7,16
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <close>:
.global close
close:
 li a7, SYS_close
 3cc:	48d5                	li	a7,21
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d4:	4899                	li	a7,6
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3dc:	489d                	li	a7,7
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <open>:
.global open
open:
 li a7, SYS_open
 3e4:	48bd                	li	a7,15
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ec:	48c5                	li	a7,17
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f4:	48c9                	li	a7,18
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3fc:	48a1                	li	a7,8
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <link>:
.global link
link:
 li a7, SYS_link
 404:	48cd                	li	a7,19
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 40c:	48d1                	li	a7,20
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 414:	48a5                	li	a7,9
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <dup>:
.global dup
dup:
 li a7, SYS_dup
 41c:	48a9                	li	a7,10
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 424:	48ad                	li	a7,11
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 42c:	48b1                	li	a7,12
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 434:	48b5                	li	a7,13
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 43c:	48b9                	li	a7,14
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <head>:
.global head
head:
 li a7, SYS_head
 444:	48d9                	li	a7,22
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 44c:	48dd                	li	a7,23
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <ps>:
.global ps
ps:
 li a7, SYS_ps
 454:	48e1                	li	a7,24
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <times>:
.global times
times:
 li a7, SYS_times
 45c:	48e5                	li	a7,25
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 464:	48e9                	li	a7,26
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 46c:	48ed                	li	a7,27
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 474:	48f1                	li	a7,28
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 47c:	48f5                	li	a7,29
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 484:	1101                	addi	sp,sp,-32
 486:	ec06                	sd	ra,24(sp)
 488:	e822                	sd	s0,16(sp)
 48a:	1000                	addi	s0,sp,32
 48c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 490:	4605                	li	a2,1
 492:	fef40593          	addi	a1,s0,-17
 496:	00000097          	auipc	ra,0x0
 49a:	f2e080e7          	jalr	-210(ra) # 3c4 <write>
}
 49e:	60e2                	ld	ra,24(sp)
 4a0:	6442                	ld	s0,16(sp)
 4a2:	6105                	addi	sp,sp,32
 4a4:	8082                	ret

00000000000004a6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a6:	7139                	addi	sp,sp,-64
 4a8:	fc06                	sd	ra,56(sp)
 4aa:	f822                	sd	s0,48(sp)
 4ac:	f426                	sd	s1,40(sp)
 4ae:	f04a                	sd	s2,32(sp)
 4b0:	ec4e                	sd	s3,24(sp)
 4b2:	0080                	addi	s0,sp,64
 4b4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b6:	c299                	beqz	a3,4bc <printint+0x16>
 4b8:	0805c963          	bltz	a1,54a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4bc:	2581                	sext.w	a1,a1
  neg = 0;
 4be:	4881                	li	a7,0
 4c0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4c4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4c6:	2601                	sext.w	a2,a2
 4c8:	00001517          	auipc	a0,0x1
 4cc:	98050513          	addi	a0,a0,-1664 # e48 <digits>
 4d0:	883a                	mv	a6,a4
 4d2:	2705                	addiw	a4,a4,1
 4d4:	02c5f7bb          	remuw	a5,a1,a2
 4d8:	1782                	slli	a5,a5,0x20
 4da:	9381                	srli	a5,a5,0x20
 4dc:	97aa                	add	a5,a5,a0
 4de:	0007c783          	lbu	a5,0(a5)
 4e2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4e6:	0005879b          	sext.w	a5,a1
 4ea:	02c5d5bb          	divuw	a1,a1,a2
 4ee:	0685                	addi	a3,a3,1
 4f0:	fec7f0e3          	bgeu	a5,a2,4d0 <printint+0x2a>
  if(neg)
 4f4:	00088c63          	beqz	a7,50c <printint+0x66>
    buf[i++] = '-';
 4f8:	fd070793          	addi	a5,a4,-48
 4fc:	00878733          	add	a4,a5,s0
 500:	02d00793          	li	a5,45
 504:	fef70823          	sb	a5,-16(a4)
 508:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 50c:	02e05863          	blez	a4,53c <printint+0x96>
 510:	fc040793          	addi	a5,s0,-64
 514:	00e78933          	add	s2,a5,a4
 518:	fff78993          	addi	s3,a5,-1
 51c:	99ba                	add	s3,s3,a4
 51e:	377d                	addiw	a4,a4,-1
 520:	1702                	slli	a4,a4,0x20
 522:	9301                	srli	a4,a4,0x20
 524:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 528:	fff94583          	lbu	a1,-1(s2)
 52c:	8526                	mv	a0,s1
 52e:	00000097          	auipc	ra,0x0
 532:	f56080e7          	jalr	-170(ra) # 484 <putc>
  while(--i >= 0)
 536:	197d                	addi	s2,s2,-1
 538:	ff3918e3          	bne	s2,s3,528 <printint+0x82>
}
 53c:	70e2                	ld	ra,56(sp)
 53e:	7442                	ld	s0,48(sp)
 540:	74a2                	ld	s1,40(sp)
 542:	7902                	ld	s2,32(sp)
 544:	69e2                	ld	s3,24(sp)
 546:	6121                	addi	sp,sp,64
 548:	8082                	ret
    x = -xx;
 54a:	40b005bb          	negw	a1,a1
    neg = 1;
 54e:	4885                	li	a7,1
    x = -xx;
 550:	bf85                	j	4c0 <printint+0x1a>

0000000000000552 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 552:	7119                	addi	sp,sp,-128
 554:	fc86                	sd	ra,120(sp)
 556:	f8a2                	sd	s0,112(sp)
 558:	f4a6                	sd	s1,104(sp)
 55a:	f0ca                	sd	s2,96(sp)
 55c:	ecce                	sd	s3,88(sp)
 55e:	e8d2                	sd	s4,80(sp)
 560:	e4d6                	sd	s5,72(sp)
 562:	e0da                	sd	s6,64(sp)
 564:	fc5e                	sd	s7,56(sp)
 566:	f862                	sd	s8,48(sp)
 568:	f466                	sd	s9,40(sp)
 56a:	f06a                	sd	s10,32(sp)
 56c:	ec6e                	sd	s11,24(sp)
 56e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 570:	0005c903          	lbu	s2,0(a1)
 574:	18090f63          	beqz	s2,712 <vprintf+0x1c0>
 578:	8aaa                	mv	s5,a0
 57a:	8b32                	mv	s6,a2
 57c:	00158493          	addi	s1,a1,1
  state = 0;
 580:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 582:	02500a13          	li	s4,37
 586:	4c55                	li	s8,21
 588:	00001c97          	auipc	s9,0x1
 58c:	868c8c93          	addi	s9,s9,-1944 # df0 <get_time_perf+0xb0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 590:	02800d93          	li	s11,40
  putc(fd, 'x');
 594:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 596:	00001b97          	auipc	s7,0x1
 59a:	8b2b8b93          	addi	s7,s7,-1870 # e48 <digits>
 59e:	a839                	j	5bc <vprintf+0x6a>
        putc(fd, c);
 5a0:	85ca                	mv	a1,s2
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	ee0080e7          	jalr	-288(ra) # 484 <putc>
 5ac:	a019                	j	5b2 <vprintf+0x60>
    } else if(state == '%'){
 5ae:	01498d63          	beq	s3,s4,5c8 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 5b2:	0485                	addi	s1,s1,1
 5b4:	fff4c903          	lbu	s2,-1(s1)
 5b8:	14090d63          	beqz	s2,712 <vprintf+0x1c0>
    if(state == 0){
 5bc:	fe0999e3          	bnez	s3,5ae <vprintf+0x5c>
      if(c == '%'){
 5c0:	ff4910e3          	bne	s2,s4,5a0 <vprintf+0x4e>
        state = '%';
 5c4:	89d2                	mv	s3,s4
 5c6:	b7f5                	j	5b2 <vprintf+0x60>
      if(c == 'd'){
 5c8:	11490c63          	beq	s2,s4,6e0 <vprintf+0x18e>
 5cc:	f9d9079b          	addiw	a5,s2,-99
 5d0:	0ff7f793          	zext.b	a5,a5
 5d4:	10fc6e63          	bltu	s8,a5,6f0 <vprintf+0x19e>
 5d8:	f9d9079b          	addiw	a5,s2,-99
 5dc:	0ff7f713          	zext.b	a4,a5
 5e0:	10ec6863          	bltu	s8,a4,6f0 <vprintf+0x19e>
 5e4:	00271793          	slli	a5,a4,0x2
 5e8:	97e6                	add	a5,a5,s9
 5ea:	439c                	lw	a5,0(a5)
 5ec:	97e6                	add	a5,a5,s9
 5ee:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5f0:	008b0913          	addi	s2,s6,8
 5f4:	4685                	li	a3,1
 5f6:	4629                	li	a2,10
 5f8:	000b2583          	lw	a1,0(s6)
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	ea8080e7          	jalr	-344(ra) # 4a6 <printint>
 606:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 608:	4981                	li	s3,0
 60a:	b765                	j	5b2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 60c:	008b0913          	addi	s2,s6,8
 610:	4681                	li	a3,0
 612:	4629                	li	a2,10
 614:	000b2583          	lw	a1,0(s6)
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e8c080e7          	jalr	-372(ra) # 4a6 <printint>
 622:	8b4a                	mv	s6,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	b771                	j	5b2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 628:	008b0913          	addi	s2,s6,8
 62c:	4681                	li	a3,0
 62e:	866a                	mv	a2,s10
 630:	000b2583          	lw	a1,0(s6)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	e70080e7          	jalr	-400(ra) # 4a6 <printint>
 63e:	8b4a                	mv	s6,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	bf85                	j	5b2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 644:	008b0793          	addi	a5,s6,8
 648:	f8f43423          	sd	a5,-120(s0)
 64c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 650:	03000593          	li	a1,48
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e2e080e7          	jalr	-466(ra) # 484 <putc>
  putc(fd, 'x');
 65e:	07800593          	li	a1,120
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	e20080e7          	jalr	-480(ra) # 484 <putc>
 66c:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66e:	03c9d793          	srli	a5,s3,0x3c
 672:	97de                	add	a5,a5,s7
 674:	0007c583          	lbu	a1,0(a5)
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	e0a080e7          	jalr	-502(ra) # 484 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 682:	0992                	slli	s3,s3,0x4
 684:	397d                	addiw	s2,s2,-1
 686:	fe0914e3          	bnez	s2,66e <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 68a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 68e:	4981                	li	s3,0
 690:	b70d                	j	5b2 <vprintf+0x60>
        s = va_arg(ap, char*);
 692:	008b0913          	addi	s2,s6,8
 696:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 69a:	02098163          	beqz	s3,6bc <vprintf+0x16a>
        while(*s != 0){
 69e:	0009c583          	lbu	a1,0(s3)
 6a2:	c5ad                	beqz	a1,70c <vprintf+0x1ba>
          putc(fd, *s);
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	dde080e7          	jalr	-546(ra) # 484 <putc>
          s++;
 6ae:	0985                	addi	s3,s3,1
        while(*s != 0){
 6b0:	0009c583          	lbu	a1,0(s3)
 6b4:	f9e5                	bnez	a1,6a4 <vprintf+0x152>
        s = va_arg(ap, char*);
 6b6:	8b4a                	mv	s6,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bde5                	j	5b2 <vprintf+0x60>
          s = "(null)";
 6bc:	00000997          	auipc	s3,0x0
 6c0:	72c98993          	addi	s3,s3,1836 # de8 <get_time_perf+0xa8>
        while(*s != 0){
 6c4:	85ee                	mv	a1,s11
 6c6:	bff9                	j	6a4 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 6c8:	008b0913          	addi	s2,s6,8
 6cc:	000b4583          	lbu	a1,0(s6)
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	db2080e7          	jalr	-590(ra) # 484 <putc>
 6da:	8b4a                	mv	s6,s2
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bdd1                	j	5b2 <vprintf+0x60>
        putc(fd, c);
 6e0:	85d2                	mv	a1,s4
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	da0080e7          	jalr	-608(ra) # 484 <putc>
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	b5d1                	j	5b2 <vprintf+0x60>
        putc(fd, '%');
 6f0:	85d2                	mv	a1,s4
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	d90080e7          	jalr	-624(ra) # 484 <putc>
        putc(fd, c);
 6fc:	85ca                	mv	a1,s2
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	d84080e7          	jalr	-636(ra) # 484 <putc>
      state = 0;
 708:	4981                	li	s3,0
 70a:	b565                	j	5b2 <vprintf+0x60>
        s = va_arg(ap, char*);
 70c:	8b4a                	mv	s6,s2
      state = 0;
 70e:	4981                	li	s3,0
 710:	b54d                	j	5b2 <vprintf+0x60>
    }
  }
}
 712:	70e6                	ld	ra,120(sp)
 714:	7446                	ld	s0,112(sp)
 716:	74a6                	ld	s1,104(sp)
 718:	7906                	ld	s2,96(sp)
 71a:	69e6                	ld	s3,88(sp)
 71c:	6a46                	ld	s4,80(sp)
 71e:	6aa6                	ld	s5,72(sp)
 720:	6b06                	ld	s6,64(sp)
 722:	7be2                	ld	s7,56(sp)
 724:	7c42                	ld	s8,48(sp)
 726:	7ca2                	ld	s9,40(sp)
 728:	7d02                	ld	s10,32(sp)
 72a:	6de2                	ld	s11,24(sp)
 72c:	6109                	addi	sp,sp,128
 72e:	8082                	ret

0000000000000730 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 730:	715d                	addi	sp,sp,-80
 732:	ec06                	sd	ra,24(sp)
 734:	e822                	sd	s0,16(sp)
 736:	1000                	addi	s0,sp,32
 738:	e010                	sd	a2,0(s0)
 73a:	e414                	sd	a3,8(s0)
 73c:	e818                	sd	a4,16(s0)
 73e:	ec1c                	sd	a5,24(s0)
 740:	03043023          	sd	a6,32(s0)
 744:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 748:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74c:	8622                	mv	a2,s0
 74e:	00000097          	auipc	ra,0x0
 752:	e04080e7          	jalr	-508(ra) # 552 <vprintf>
}
 756:	60e2                	ld	ra,24(sp)
 758:	6442                	ld	s0,16(sp)
 75a:	6161                	addi	sp,sp,80
 75c:	8082                	ret

000000000000075e <printf>:

void
printf(const char *fmt, ...)
{
 75e:	711d                	addi	sp,sp,-96
 760:	ec06                	sd	ra,24(sp)
 762:	e822                	sd	s0,16(sp)
 764:	1000                	addi	s0,sp,32
 766:	e40c                	sd	a1,8(s0)
 768:	e810                	sd	a2,16(s0)
 76a:	ec14                	sd	a3,24(s0)
 76c:	f018                	sd	a4,32(s0)
 76e:	f41c                	sd	a5,40(s0)
 770:	03043823          	sd	a6,48(s0)
 774:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 778:	00840613          	addi	a2,s0,8
 77c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 780:	85aa                	mv	a1,a0
 782:	4505                	li	a0,1
 784:	00000097          	auipc	ra,0x0
 788:	dce080e7          	jalr	-562(ra) # 552 <vprintf>
}
 78c:	60e2                	ld	ra,24(sp)
 78e:	6442                	ld	s0,16(sp)
 790:	6125                	addi	sp,sp,96
 792:	8082                	ret

0000000000000794 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 794:	1141                	addi	sp,sp,-16
 796:	e422                	sd	s0,8(sp)
 798:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	00001797          	auipc	a5,0x1
 7a2:	8627b783          	ld	a5,-1950(a5) # 1000 <freep>
 7a6:	a02d                	j	7d0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7a8:	4618                	lw	a4,8(a2)
 7aa:	9f2d                	addw	a4,a4,a1
 7ac:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b0:	6398                	ld	a4,0(a5)
 7b2:	6310                	ld	a2,0(a4)
 7b4:	a83d                	j	7f2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7b6:	ff852703          	lw	a4,-8(a0)
 7ba:	9f31                	addw	a4,a4,a2
 7bc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7be:	ff053683          	ld	a3,-16(a0)
 7c2:	a091                	j	806 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c4:	6398                	ld	a4,0(a5)
 7c6:	00e7e463          	bltu	a5,a4,7ce <free+0x3a>
 7ca:	00e6ea63          	bltu	a3,a4,7de <free+0x4a>
{
 7ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d0:	fed7fae3          	bgeu	a5,a3,7c4 <free+0x30>
 7d4:	6398                	ld	a4,0(a5)
 7d6:	00e6e463          	bltu	a3,a4,7de <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7da:	fee7eae3          	bltu	a5,a4,7ce <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7de:	ff852583          	lw	a1,-8(a0)
 7e2:	6390                	ld	a2,0(a5)
 7e4:	02059813          	slli	a6,a1,0x20
 7e8:	01c85713          	srli	a4,a6,0x1c
 7ec:	9736                	add	a4,a4,a3
 7ee:	fae60de3          	beq	a2,a4,7a8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7f2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7f6:	4790                	lw	a2,8(a5)
 7f8:	02061593          	slli	a1,a2,0x20
 7fc:	01c5d713          	srli	a4,a1,0x1c
 800:	973e                	add	a4,a4,a5
 802:	fae68ae3          	beq	a3,a4,7b6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 806:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 808:	00000717          	auipc	a4,0x0
 80c:	7ef73c23          	sd	a5,2040(a4) # 1000 <freep>
}
 810:	6422                	ld	s0,8(sp)
 812:	0141                	addi	sp,sp,16
 814:	8082                	ret

0000000000000816 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 816:	7139                	addi	sp,sp,-64
 818:	fc06                	sd	ra,56(sp)
 81a:	f822                	sd	s0,48(sp)
 81c:	f426                	sd	s1,40(sp)
 81e:	f04a                	sd	s2,32(sp)
 820:	ec4e                	sd	s3,24(sp)
 822:	e852                	sd	s4,16(sp)
 824:	e456                	sd	s5,8(sp)
 826:	e05a                	sd	s6,0(sp)
 828:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82a:	02051493          	slli	s1,a0,0x20
 82e:	9081                	srli	s1,s1,0x20
 830:	04bd                	addi	s1,s1,15
 832:	8091                	srli	s1,s1,0x4
 834:	0014899b          	addiw	s3,s1,1
 838:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 83a:	00000517          	auipc	a0,0x0
 83e:	7c653503          	ld	a0,1990(a0) # 1000 <freep>
 842:	c515                	beqz	a0,86e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 844:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 846:	4798                	lw	a4,8(a5)
 848:	02977f63          	bgeu	a4,s1,886 <malloc+0x70>
 84c:	8a4e                	mv	s4,s3
 84e:	0009871b          	sext.w	a4,s3
 852:	6685                	lui	a3,0x1
 854:	00d77363          	bgeu	a4,a3,85a <malloc+0x44>
 858:	6a05                	lui	s4,0x1
 85a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 85e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 862:	00000917          	auipc	s2,0x0
 866:	79e90913          	addi	s2,s2,1950 # 1000 <freep>
  if(p == (char*)-1)
 86a:	5afd                	li	s5,-1
 86c:	a895                	j	8e0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 86e:	00001797          	auipc	a5,0x1
 872:	9a278793          	addi	a5,a5,-1630 # 1210 <base>
 876:	00000717          	auipc	a4,0x0
 87a:	78f73523          	sd	a5,1930(a4) # 1000 <freep>
 87e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 880:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 884:	b7e1                	j	84c <malloc+0x36>
      if(p->s.size == nunits)
 886:	02e48c63          	beq	s1,a4,8be <malloc+0xa8>
        p->s.size -= nunits;
 88a:	4137073b          	subw	a4,a4,s3
 88e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 890:	02071693          	slli	a3,a4,0x20
 894:	01c6d713          	srli	a4,a3,0x1c
 898:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 89a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 89e:	00000717          	auipc	a4,0x0
 8a2:	76a73123          	sd	a0,1890(a4) # 1000 <freep>
      return (void*)(p + 1);
 8a6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8aa:	70e2                	ld	ra,56(sp)
 8ac:	7442                	ld	s0,48(sp)
 8ae:	74a2                	ld	s1,40(sp)
 8b0:	7902                	ld	s2,32(sp)
 8b2:	69e2                	ld	s3,24(sp)
 8b4:	6a42                	ld	s4,16(sp)
 8b6:	6aa2                	ld	s5,8(sp)
 8b8:	6b02                	ld	s6,0(sp)
 8ba:	6121                	addi	sp,sp,64
 8bc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8be:	6398                	ld	a4,0(a5)
 8c0:	e118                	sd	a4,0(a0)
 8c2:	bff1                	j	89e <malloc+0x88>
  hp->s.size = nu;
 8c4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c8:	0541                	addi	a0,a0,16
 8ca:	00000097          	auipc	ra,0x0
 8ce:	eca080e7          	jalr	-310(ra) # 794 <free>
  return freep;
 8d2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8d6:	d971                	beqz	a0,8aa <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8da:	4798                	lw	a4,8(a5)
 8dc:	fa9775e3          	bgeu	a4,s1,886 <malloc+0x70>
    if(p == freep)
 8e0:	00093703          	ld	a4,0(s2)
 8e4:	853e                	mv	a0,a5
 8e6:	fef719e3          	bne	a4,a5,8d8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8ea:	8552                	mv	a0,s4
 8ec:	00000097          	auipc	ra,0x0
 8f0:	b40080e7          	jalr	-1216(ra) # 42c <sbrk>
  if(p == (char*)-1)
 8f4:	fd5518e3          	bne	a0,s5,8c4 <malloc+0xae>
        return 0;
 8f8:	4501                	li	a0,0
 8fa:	bf45                	j	8aa <malloc+0x94>

00000000000008fc <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 8fc:	c1d9                	beqz	a1,982 <head_run+0x86>
void head_run(int fd, int numOfLines){
 8fe:	dd010113          	addi	sp,sp,-560
 902:	22113423          	sd	ra,552(sp)
 906:	22813023          	sd	s0,544(sp)
 90a:	20913c23          	sd	s1,536(sp)
 90e:	21213823          	sd	s2,528(sp)
 912:	21313423          	sd	s3,520(sp)
 916:	21413023          	sd	s4,512(sp)
 91a:	1c00                	addi	s0,sp,560
 91c:	892a                	mv	s2,a0
 91e:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 922:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 924:	00000a17          	auipc	s4,0x0
 928:	564a0a13          	addi	s4,s4,1380 # e88 <digits+0x40>
		readStatus = read_line(fd, line);
 92c:	dd840593          	addi	a1,s0,-552
 930:	854a                	mv	a0,s2
 932:	00000097          	auipc	ra,0x0
 936:	394080e7          	jalr	916(ra) # cc6 <read_line>
		if (readStatus == READ_ERROR){
 93a:	01350d63          	beq	a0,s3,954 <head_run+0x58>
		if (readStatus == READ_EOF)
 93e:	c11d                	beqz	a0,964 <head_run+0x68>
		printf("%s",line);
 940:	dd840593          	addi	a1,s0,-552
 944:	8552                	mv	a0,s4
 946:	00000097          	auipc	ra,0x0
 94a:	e18080e7          	jalr	-488(ra) # 75e <printf>
	while(numOfLines--){
 94e:	34fd                	addiw	s1,s1,-1
 950:	fcf1                	bnez	s1,92c <head_run+0x30>
 952:	a809                	j	964 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 954:	00000517          	auipc	a0,0x0
 958:	50c50513          	addi	a0,a0,1292 # e60 <digits+0x18>
 95c:	00000097          	auipc	ra,0x0
 960:	e02080e7          	jalr	-510(ra) # 75e <printf>

	}
}
 964:	22813083          	ld	ra,552(sp)
 968:	22013403          	ld	s0,544(sp)
 96c:	21813483          	ld	s1,536(sp)
 970:	21013903          	ld	s2,528(sp)
 974:	20813983          	ld	s3,520(sp)
 978:	20013a03          	ld	s4,512(sp)
 97c:	23010113          	addi	sp,sp,560
 980:	8082                	ret
 982:	8082                	ret

0000000000000984 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 984:	ba010113          	addi	sp,sp,-1120
 988:	44113c23          	sd	ra,1112(sp)
 98c:	44813823          	sd	s0,1104(sp)
 990:	44913423          	sd	s1,1096(sp)
 994:	45213023          	sd	s2,1088(sp)
 998:	43313c23          	sd	s3,1080(sp)
 99c:	43413823          	sd	s4,1072(sp)
 9a0:	43513423          	sd	s5,1064(sp)
 9a4:	43613023          	sd	s6,1056(sp)
 9a8:	41713c23          	sd	s7,1048(sp)
 9ac:	41813823          	sd	s8,1040(sp)
 9b0:	41913423          	sd	s9,1032(sp)
 9b4:	41a13023          	sd	s10,1024(sp)
 9b8:	3fb13c23          	sd	s11,1016(sp)
 9bc:	46010413          	addi	s0,sp,1120
 9c0:	89aa                	mv	s3,a0
 9c2:	8aae                	mv	s5,a1
 9c4:	8c32                	mv	s8,a2
 9c6:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 9c8:	d9840593          	addi	a1,s0,-616
 9cc:	00000097          	auipc	ra,0x0
 9d0:	2fa080e7          	jalr	762(ra) # cc6 <read_line>


  if (readStatus == READ_ERROR)
 9d4:	57fd                	li	a5,-1
 9d6:	04f50163          	beq	a0,a5,a18 <uniq_run+0x94>
 9da:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 9dc:	ed21                	bnez	a0,a34 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 9de:	45813083          	ld	ra,1112(sp)
 9e2:	45013403          	ld	s0,1104(sp)
 9e6:	44813483          	ld	s1,1096(sp)
 9ea:	44013903          	ld	s2,1088(sp)
 9ee:	43813983          	ld	s3,1080(sp)
 9f2:	43013a03          	ld	s4,1072(sp)
 9f6:	42813a83          	ld	s5,1064(sp)
 9fa:	42013b03          	ld	s6,1056(sp)
 9fe:	41813b83          	ld	s7,1048(sp)
 a02:	41013c03          	ld	s8,1040(sp)
 a06:	40813c83          	ld	s9,1032(sp)
 a0a:	40013d03          	ld	s10,1024(sp)
 a0e:	3f813d83          	ld	s11,1016(sp)
 a12:	46010113          	addi	sp,sp,1120
 a16:	8082                	ret
    printf("[ERR] Error reading from the file ");
 a18:	00000517          	auipc	a0,0x0
 a1c:	47850513          	addi	a0,a0,1144 # e90 <digits+0x48>
 a20:	00000097          	auipc	ra,0x0
 a24:	d3e080e7          	jalr	-706(ra) # 75e <printf>
 a28:	bf5d                	j	9de <uniq_run+0x5a>
 a2a:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a2c:	8926                	mv	s2,s1
 a2e:	84be                	mv	s1,a5
        lineCount = 1;
 a30:	8b6a                	mv	s6,s10
 a32:	a8ed                	j	b2c <uniq_run+0x1a8>
    int lineCount=1;
 a34:	4b05                	li	s6,1
  char * line2 = buffer2;
 a36:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 a3a:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 a3e:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 a40:	4d05                	li	s10,1
              printf("%s",line1);
 a42:	00000d97          	auipc	s11,0x0
 a46:	446d8d93          	addi	s11,s11,1094 # e88 <digits+0x40>
 a4a:	a0cd                	j	b2c <uniq_run+0x1a8>
            if (repeatedLines){
 a4c:	020a0b63          	beqz	s4,a82 <uniq_run+0xfe>
                if (isRepeated){
 a50:	f80b87e3          	beqz	s7,9de <uniq_run+0x5a>
                    if (showCount)
 a54:	000c0d63          	beqz	s8,a6e <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 a58:	864a                	mv	a2,s2
 a5a:	85da                	mv	a1,s6
 a5c:	00000517          	auipc	a0,0x0
 a60:	45c50513          	addi	a0,a0,1116 # eb8 <digits+0x70>
 a64:	00000097          	auipc	ra,0x0
 a68:	cfa080e7          	jalr	-774(ra) # 75e <printf>
 a6c:	bf8d                	j	9de <uniq_run+0x5a>
                      printf("%s",line1);
 a6e:	85ca                	mv	a1,s2
 a70:	00000517          	auipc	a0,0x0
 a74:	41850513          	addi	a0,a0,1048 # e88 <digits+0x40>
 a78:	00000097          	auipc	ra,0x0
 a7c:	ce6080e7          	jalr	-794(ra) # 75e <printf>
 a80:	bfb9                	j	9de <uniq_run+0x5a>
                if (showCount)
 a82:	000c0d63          	beqz	s8,a9c <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 a86:	864a                	mv	a2,s2
 a88:	85da                	mv	a1,s6
 a8a:	00000517          	auipc	a0,0x0
 a8e:	42e50513          	addi	a0,a0,1070 # eb8 <digits+0x70>
 a92:	00000097          	auipc	ra,0x0
 a96:	ccc080e7          	jalr	-820(ra) # 75e <printf>
 a9a:	b791                	j	9de <uniq_run+0x5a>
                  printf("%s",line1);
 a9c:	85ca                	mv	a1,s2
 a9e:	00000517          	auipc	a0,0x0
 aa2:	3ea50513          	addi	a0,a0,1002 # e88 <digits+0x40>
 aa6:	00000097          	auipc	ra,0x0
 aaa:	cb8080e7          	jalr	-840(ra) # 75e <printf>
 aae:	bf05                	j	9de <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 ab0:	00000517          	auipc	a0,0x0
 ab4:	41050513          	addi	a0,a0,1040 # ec0 <digits+0x78>
 ab8:	00000097          	auipc	ra,0x0
 abc:	ca6080e7          	jalr	-858(ra) # 75e <printf>
          break;
 ac0:	bf39                	j	9de <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 ac2:	85a6                	mv	a1,s1
 ac4:	854a                	mv	a0,s2
 ac6:	00000097          	auipc	ra,0x0
 aca:	110080e7          	jalr	272(ra) # bd6 <compare_str_ic>
 ace:	a041                	j	b4e <uniq_run+0x1ca>
                  printf("%s",line1);
 ad0:	85ca                	mv	a1,s2
 ad2:	856e                	mv	a0,s11
 ad4:	00000097          	auipc	ra,0x0
 ad8:	c8a080e7          	jalr	-886(ra) # 75e <printf>
        lineCount = 1;
 adc:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 ade:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 ae0:	8926                	mv	s2,s1
                  printf("%s",line1);
 ae2:	84be                	mv	s1,a5
        isRepeated = 0 ;
 ae4:	4b81                	li	s7,0
 ae6:	a099                	j	b2c <uniq_run+0x1a8>
            if (showCount)
 ae8:	020c0263          	beqz	s8,b0c <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 aec:	864a                	mv	a2,s2
 aee:	85da                	mv	a1,s6
 af0:	00000517          	auipc	a0,0x0
 af4:	3c850513          	addi	a0,a0,968 # eb8 <digits+0x70>
 af8:	00000097          	auipc	ra,0x0
 afc:	c66080e7          	jalr	-922(ra) # 75e <printf>
 b00:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b02:	8926                	mv	s2,s1
 b04:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b06:	4b81                	li	s7,0
        lineCount = 1;
 b08:	8b6a                	mv	s6,s10
 b0a:	a00d                	j	b2c <uniq_run+0x1a8>
              printf("%s",line1);
 b0c:	85ca                	mv	a1,s2
 b0e:	856e                	mv	a0,s11
 b10:	00000097          	auipc	ra,0x0
 b14:	c4e080e7          	jalr	-946(ra) # 75e <printf>
 b18:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b1a:	8926                	mv	s2,s1
              printf("%s",line1);
 b1c:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b1e:	4b81                	li	s7,0
        lineCount = 1;
 b20:	8b6a                	mv	s6,s10
 b22:	a029                	j	b2c <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 b24:	000a0363          	beqz	s4,b2a <uniq_run+0x1a6>
 b28:	8bea                	mv	s7,s10
          lineCount++;
 b2a:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 b2c:	85a6                	mv	a1,s1
 b2e:	854e                	mv	a0,s3
 b30:	00000097          	auipc	ra,0x0
 b34:	196080e7          	jalr	406(ra) # cc6 <read_line>
        if (readStatus == READ_EOF){
 b38:	d911                	beqz	a0,a4c <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 b3a:	f7950be3          	beq	a0,s9,ab0 <uniq_run+0x12c>
        if (!ignoreCase)
 b3e:	f80a92e3          	bnez	s5,ac2 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 b42:	85a6                	mv	a1,s1
 b44:	854a                	mv	a0,s2
 b46:	00000097          	auipc	ra,0x0
 b4a:	062080e7          	jalr	98(ra) # ba8 <compare_str>
        if (compareStatus != 0){ 
 b4e:	d979                	beqz	a0,b24 <uniq_run+0x1a0>
          if (repeatedLines){
 b50:	f80a0ce3          	beqz	s4,ae8 <uniq_run+0x164>
            if (isRepeated){
 b54:	ec0b8be3          	beqz	s7,a2a <uniq_run+0xa6>
                if (showCount)
 b58:	f60c0ce3          	beqz	s8,ad0 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 b5c:	864a                	mv	a2,s2
 b5e:	85da                	mv	a1,s6
 b60:	00000517          	auipc	a0,0x0
 b64:	35850513          	addi	a0,a0,856 # eb8 <digits+0x70>
 b68:	00000097          	auipc	ra,0x0
 b6c:	bf6080e7          	jalr	-1034(ra) # 75e <printf>
        lineCount = 1;
 b70:	8b5e                	mv	s6,s7
 b72:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b74:	8926                	mv	s2,s1
 b76:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b78:	4b81                	li	s7,0
 b7a:	bf4d                	j	b2c <uniq_run+0x1a8>

0000000000000b7c <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 b7c:	1141                	addi	sp,sp,-16
 b7e:	e422                	sd	s0,8(sp)
 b80:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 b82:	00054783          	lbu	a5,0(a0)
 b86:	cf99                	beqz	a5,ba4 <get_strlen+0x28>
 b88:	00150713          	addi	a4,a0,1
 b8c:	87ba                	mv	a5,a4
 b8e:	4685                	li	a3,1
 b90:	9e99                	subw	a3,a3,a4
 b92:	00f6853b          	addw	a0,a3,a5
 b96:	0785                	addi	a5,a5,1
 b98:	fff7c703          	lbu	a4,-1(a5)
 b9c:	fb7d                	bnez	a4,b92 <get_strlen+0x16>
	return len;
}
 b9e:	6422                	ld	s0,8(sp)
 ba0:	0141                	addi	sp,sp,16
 ba2:	8082                	ret
	int len = 0;
 ba4:	4501                	li	a0,0
 ba6:	bfe5                	j	b9e <get_strlen+0x22>

0000000000000ba8 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 ba8:	1141                	addi	sp,sp,-16
 baa:	e422                	sd	s0,8(sp)
 bac:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 bae:	00054783          	lbu	a5,0(a0)
 bb2:	cb91                	beqz	a5,bc6 <compare_str+0x1e>
 bb4:	0005c703          	lbu	a4,0(a1)
 bb8:	c719                	beqz	a4,bc6 <compare_str+0x1e>
		if (*s1++ != *s2++)
 bba:	0505                	addi	a0,a0,1
 bbc:	0585                	addi	a1,a1,1
 bbe:	fee788e3          	beq	a5,a4,bae <compare_str+0x6>
			return 1;
 bc2:	4505                	li	a0,1
 bc4:	a031                	j	bd0 <compare_str+0x28>
	}
	if (*s1 == *s2)
 bc6:	0005c503          	lbu	a0,0(a1)
 bca:	8d1d                	sub	a0,a0,a5
			return 1;
 bcc:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 bd0:	6422                	ld	s0,8(sp)
 bd2:	0141                	addi	sp,sp,16
 bd4:	8082                	ret

0000000000000bd6 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 bd6:	1141                	addi	sp,sp,-16
 bd8:	e422                	sd	s0,8(sp)
 bda:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 bdc:	4665                	li	a2,25
	while(*s1 && *s2){
 bde:	a019                	j	be4 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 be0:	04e79763          	bne	a5,a4,c2e <compare_str_ic+0x58>
	while(*s1 && *s2){
 be4:	00054783          	lbu	a5,0(a0)
 be8:	cb9d                	beqz	a5,c1e <compare_str_ic+0x48>
 bea:	0005c703          	lbu	a4,0(a1)
 bee:	cb05                	beqz	a4,c1e <compare_str_ic+0x48>
		char b1 = *s1++;
 bf0:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 bf2:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 bf4:	fbf7869b          	addiw	a3,a5,-65
 bf8:	0ff6f693          	zext.b	a3,a3
 bfc:	00d66663          	bltu	a2,a3,c08 <compare_str_ic+0x32>
			b1 += 32;
 c00:	0207879b          	addiw	a5,a5,32
 c04:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 c08:	fbf7069b          	addiw	a3,a4,-65
 c0c:	0ff6f693          	zext.b	a3,a3
 c10:	fcd668e3          	bltu	a2,a3,be0 <compare_str_ic+0xa>
			b2 += 32;
 c14:	0207071b          	addiw	a4,a4,32
 c18:	0ff77713          	zext.b	a4,a4
 c1c:	b7d1                	j	be0 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 c1e:	0005c503          	lbu	a0,0(a1)
 c22:	8d1d                	sub	a0,a0,a5
			return 1;
 c24:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 c28:	6422                	ld	s0,8(sp)
 c2a:	0141                	addi	sp,sp,16
 c2c:	8082                	ret
			return 1;
 c2e:	4505                	li	a0,1
 c30:	bfe5                	j	c28 <compare_str_ic+0x52>

0000000000000c32 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 c32:	7179                	addi	sp,sp,-48
 c34:	f406                	sd	ra,40(sp)
 c36:	f022                	sd	s0,32(sp)
 c38:	ec26                	sd	s1,24(sp)
 c3a:	e84a                	sd	s2,16(sp)
 c3c:	e44e                	sd	s3,8(sp)
 c3e:	1800                	addi	s0,sp,48
 c40:	89aa                	mv	s3,a0
 c42:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 c44:	00000097          	auipc	ra,0x0
 c48:	f38080e7          	jalr	-200(ra) # b7c <get_strlen>
 c4c:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 c4e:	854a                	mv	a0,s2
 c50:	00000097          	auipc	ra,0x0
 c54:	f2c080e7          	jalr	-212(ra) # b7c <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 c58:	409505bb          	subw	a1,a0,s1
 c5c:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 c5e:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 c60:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 c62:	0005da63          	bgez	a1,c76 <check_substr+0x44>
 c66:	a81d                	j	c9c <check_substr+0x6a>
        if (j == M)
 c68:	02f48a63          	beq	s1,a5,c9c <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 c6c:	0885                	addi	a7,a7,1
 c6e:	0008879b          	sext.w	a5,a7
 c72:	02f5cc63          	blt	a1,a5,caa <check_substr+0x78>
 c76:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 c7a:	011906b3          	add	a3,s2,a7
 c7e:	874e                	mv	a4,s3
 c80:	879a                	mv	a5,t1
 c82:	fe9053e3          	blez	s1,c68 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 c86:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 c8a:	00074603          	lbu	a2,0(a4)
 c8e:	fcc81de3          	bne	a6,a2,c68 <check_substr+0x36>
        for (j = 0; j < M; j++)
 c92:	2785                	addiw	a5,a5,1
 c94:	0685                	addi	a3,a3,1
 c96:	0705                	addi	a4,a4,1
 c98:	fef497e3          	bne	s1,a5,c86 <check_substr+0x54>
}
 c9c:	70a2                	ld	ra,40(sp)
 c9e:	7402                	ld	s0,32(sp)
 ca0:	64e2                	ld	s1,24(sp)
 ca2:	6942                	ld	s2,16(sp)
 ca4:	69a2                	ld	s3,8(sp)
 ca6:	6145                	addi	sp,sp,48
 ca8:	8082                	ret
    return -1;
 caa:	557d                	li	a0,-1
 cac:	bfc5                	j	c9c <check_substr+0x6a>

0000000000000cae <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 cae:	1141                	addi	sp,sp,-16
 cb0:	e406                	sd	ra,8(sp)
 cb2:	e022                	sd	s0,0(sp)
 cb4:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 cb6:	fffff097          	auipc	ra,0xfffff
 cba:	72e080e7          	jalr	1838(ra) # 3e4 <open>
	return fd;
}
 cbe:	60a2                	ld	ra,8(sp)
 cc0:	6402                	ld	s0,0(sp)
 cc2:	0141                	addi	sp,sp,16
 cc4:	8082                	ret

0000000000000cc6 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 cc6:	7139                	addi	sp,sp,-64
 cc8:	fc06                	sd	ra,56(sp)
 cca:	f822                	sd	s0,48(sp)
 ccc:	f426                	sd	s1,40(sp)
 cce:	f04a                	sd	s2,32(sp)
 cd0:	ec4e                	sd	s3,24(sp)
 cd2:	e852                	sd	s4,16(sp)
 cd4:	0080                	addi	s0,sp,64
 cd6:	89aa                	mv	s3,a0
 cd8:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 cda:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 cdc:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 cde:	4605                	li	a2,1
 ce0:	fcf40593          	addi	a1,s0,-49
 ce4:	854e                	mv	a0,s3
 ce6:	fffff097          	auipc	ra,0xfffff
 cea:	6d6080e7          	jalr	1750(ra) # 3bc <read>
		if (readStatus == 0){
 cee:	c505                	beqz	a0,d16 <read_line+0x50>
		*buffer++ = readByte;
 cf0:	0485                	addi	s1,s1,1
 cf2:	fcf44783          	lbu	a5,-49(s0)
 cf6:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 cfa:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 cfc:	ff4791e3          	bne	a5,s4,cde <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 d00:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 d04:	854a                	mv	a0,s2
 d06:	70e2                	ld	ra,56(sp)
 d08:	7442                	ld	s0,48(sp)
 d0a:	74a2                	ld	s1,40(sp)
 d0c:	7902                	ld	s2,32(sp)
 d0e:	69e2                	ld	s3,24(sp)
 d10:	6a42                	ld	s4,16(sp)
 d12:	6121                	addi	sp,sp,64
 d14:	8082                	ret
			if (byteCount!=0){
 d16:	fe0907e3          	beqz	s2,d04 <read_line+0x3e>
				*buffer = '\n';
 d1a:	47a9                	li	a5,10
 d1c:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 d20:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 d24:	2905                	addiw	s2,s2,1
 d26:	bff9                	j	d04 <read_line+0x3e>

0000000000000d28 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 d28:	1141                	addi	sp,sp,-16
 d2a:	e406                	sd	ra,8(sp)
 d2c:	e022                	sd	s0,0(sp)
 d2e:	0800                	addi	s0,sp,16
	close(fd);
 d30:	fffff097          	auipc	ra,0xfffff
 d34:	69c080e7          	jalr	1692(ra) # 3cc <close>
}
 d38:	60a2                	ld	ra,8(sp)
 d3a:	6402                	ld	s0,0(sp)
 d3c:	0141                	addi	sp,sp,16
 d3e:	8082                	ret

0000000000000d40 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 d40:	7139                	addi	sp,sp,-64
 d42:	fc06                	sd	ra,56(sp)
 d44:	f822                	sd	s0,48(sp)
 d46:	f426                	sd	s1,40(sp)
 d48:	f04a                	sd	s2,32(sp)
 d4a:	0080                	addi	s0,sp,64
 d4c:	84aa                	mv	s1,a0
 d4e:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 d50:	fffff097          	auipc	ra,0xfffff
 d54:	64c080e7          	jalr	1612(ra) # 39c <fork>
 d58:	ed19                	bnez	a0,d76 <get_time_perf+0x36>
		exec(argv[0],argv);
 d5a:	85ca                	mv	a1,s2
 d5c:	00093503          	ld	a0,0(s2)
 d60:	fffff097          	auipc	ra,0xfffff
 d64:	67c080e7          	jalr	1660(ra) # 3dc <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 d68:	8526                	mv	a0,s1
 d6a:	70e2                	ld	ra,56(sp)
 d6c:	7442                	ld	s0,48(sp)
 d6e:	74a2                	ld	s1,40(sp)
 d70:	7902                	ld	s2,32(sp)
 d72:	6121                	addi	sp,sp,64
 d74:	8082                	ret
		times(pid , &time);
 d76:	fc040593          	addi	a1,s0,-64
 d7a:	fffff097          	auipc	ra,0xfffff
 d7e:	6e2080e7          	jalr	1762(ra) # 45c <times>
		return time;
 d82:	fc043783          	ld	a5,-64(s0)
 d86:	e09c                	sd	a5,0(s1)
 d88:	fc843783          	ld	a5,-56(s0)
 d8c:	e49c                	sd	a5,8(s1)
 d8e:	fd043783          	ld	a5,-48(s0)
 d92:	e89c                	sd	a5,16(s1)
 d94:	fd843783          	ld	a5,-40(s0)
 d98:	ec9c                	sd	a5,24(s1)
 d9a:	b7f9                	j	d68 <get_time_perf+0x28>
