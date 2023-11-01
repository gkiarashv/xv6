
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	fe3d8d93          	addi	s11,s11,-29 # 1011 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	de8a0a13          	addi	s4,s4,-536 # e20 <get_time_perf+0x68>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1fe080e7          	jalr	510(ra) # 244 <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
      c++;
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	f9a58593          	addi	a1,a1,-102 # 1010 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	3b2080e7          	jalr	946(ra) # 434 <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	f8248493          	addi	s1,s1,-126 # 1010 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	d8250513          	addi	a0,a0,-638 # e38 <get_time_perf+0x80>
  be:	00000097          	auipc	ra,0x0
  c2:	718080e7          	jalr	1816(ra) # 7d6 <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	d4450513          	addi	a0,a0,-700 # e28 <get_time_perf+0x70>
  ec:	00000097          	auipc	ra,0x0
  f0:	6ea080e7          	jalr	1770(ra) # 7d6 <printf>
    exit(1);
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	326080e7          	jalr	806(ra) # 41c <exit>

00000000000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	7179                	addi	sp,sp,-48
 100:	f406                	sd	ra,40(sp)
 102:	f022                	sd	s0,32(sp)
 104:	ec26                	sd	s1,24(sp)
 106:	e84a                	sd	s2,16(sp)
 108:	e44e                	sd	s3,8(sp)
 10a:	e052                	sd	s4,0(sp)
 10c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 10e:	4785                	li	a5,1
 110:	04a7d763          	bge	a5,a0,15e <main+0x60>
 114:	00858493          	addi	s1,a1,8
 118:	ffe5099b          	addiw	s3,a0,-2
 11c:	02099793          	slli	a5,s3,0x20
 120:	01d7d993          	srli	s3,a5,0x1d
 124:	05c1                	addi	a1,a1,16
 126:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 128:	4581                	li	a1,0
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	330080e7          	jalr	816(ra) # 45c <open>
 134:	892a                	mv	s2,a0
 136:	04054263          	bltz	a0,17a <main+0x7c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 13a:	608c                	ld	a1,0(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <wc>
    close(fd);
 144:	854a                	mv	a0,s2
 146:	00000097          	auipc	ra,0x0
 14a:	2fe080e7          	jalr	766(ra) # 444 <close>
  for(i = 1; i < argc; i++){
 14e:	04a1                	addi	s1,s1,8
 150:	fd349ce3          	bne	s1,s3,128 <main+0x2a>
  }
  exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	2c6080e7          	jalr	710(ra) # 41c <exit>
    wc(0, "");
 15e:	00001597          	auipc	a1,0x1
 162:	cea58593          	addi	a1,a1,-790 # e48 <get_time_perf+0x90>
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	e98080e7          	jalr	-360(ra) # 0 <wc>
    exit(0);
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	2aa080e7          	jalr	682(ra) # 41c <exit>
      printf("wc: cannot open %s\n", argv[i]);
 17a:	608c                	ld	a1,0(s1)
 17c:	00001517          	auipc	a0,0x1
 180:	cd450513          	addi	a0,a0,-812 # e50 <get_time_perf+0x98>
 184:	00000097          	auipc	ra,0x0
 188:	652080e7          	jalr	1618(ra) # 7d6 <printf>
      exit(1);
 18c:	4505                	li	a0,1
 18e:	00000097          	auipc	ra,0x0
 192:	28e080e7          	jalr	654(ra) # 41c <exit>

0000000000000196 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 196:	1141                	addi	sp,sp,-16
 198:	e406                	sd	ra,8(sp)
 19a:	e022                	sd	s0,0(sp)
 19c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 19e:	00000097          	auipc	ra,0x0
 1a2:	f60080e7          	jalr	-160(ra) # fe <main>
  exit(0);
 1a6:	4501                	li	a0,0
 1a8:	00000097          	auipc	ra,0x0
 1ac:	274080e7          	jalr	628(ra) # 41c <exit>

00000000000001b0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b6:	87aa                	mv	a5,a0
 1b8:	0585                	addi	a1,a1,1
 1ba:	0785                	addi	a5,a5,1
 1bc:	fff5c703          	lbu	a4,-1(a1)
 1c0:	fee78fa3          	sb	a4,-1(a5)
 1c4:	fb75                	bnez	a4,1b8 <strcpy+0x8>
    ;
  return os;
}
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cb91                	beqz	a5,1ea <strcmp+0x1e>
 1d8:	0005c703          	lbu	a4,0(a1)
 1dc:	00f71763          	bne	a4,a5,1ea <strcmp+0x1e>
    p++, q++;
 1e0:	0505                	addi	a0,a0,1
 1e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	fbe5                	bnez	a5,1d8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ea:	0005c503          	lbu	a0,0(a1)
}
 1ee:	40a7853b          	subw	a0,a5,a0
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret

00000000000001f8 <strlen>:

uint
strlen(const char *s)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1fe:	00054783          	lbu	a5,0(a0)
 202:	cf91                	beqz	a5,21e <strlen+0x26>
 204:	0505                	addi	a0,a0,1
 206:	87aa                	mv	a5,a0
 208:	4685                	li	a3,1
 20a:	9e89                	subw	a3,a3,a0
 20c:	00f6853b          	addw	a0,a3,a5
 210:	0785                	addi	a5,a5,1
 212:	fff7c703          	lbu	a4,-1(a5)
 216:	fb7d                	bnez	a4,20c <strlen+0x14>
    ;
  return n;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
  for(n = 0; s[n]; n++)
 21e:	4501                	li	a0,0
 220:	bfe5                	j	218 <strlen+0x20>

0000000000000222 <memset>:

void*
memset(void *dst, int c, uint n)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 228:	ca19                	beqz	a2,23e <memset+0x1c>
 22a:	87aa                	mv	a5,a0
 22c:	1602                	slli	a2,a2,0x20
 22e:	9201                	srli	a2,a2,0x20
 230:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 234:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 238:	0785                	addi	a5,a5,1
 23a:	fee79de3          	bne	a5,a4,234 <memset+0x12>
  }
  return dst;
}
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret

0000000000000244 <strchr>:

char*
strchr(const char *s, char c)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  for(; *s; s++)
 24a:	00054783          	lbu	a5,0(a0)
 24e:	cb99                	beqz	a5,264 <strchr+0x20>
    if(*s == c)
 250:	00f58763          	beq	a1,a5,25e <strchr+0x1a>
  for(; *s; s++)
 254:	0505                	addi	a0,a0,1
 256:	00054783          	lbu	a5,0(a0)
 25a:	fbfd                	bnez	a5,250 <strchr+0xc>
      return (char*)s;
  return 0;
 25c:	4501                	li	a0,0
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  return 0;
 264:	4501                	li	a0,0
 266:	bfe5                	j	25e <strchr+0x1a>

0000000000000268 <gets>:

char*
gets(char *buf, int max)
{
 268:	711d                	addi	sp,sp,-96
 26a:	ec86                	sd	ra,88(sp)
 26c:	e8a2                	sd	s0,80(sp)
 26e:	e4a6                	sd	s1,72(sp)
 270:	e0ca                	sd	s2,64(sp)
 272:	fc4e                	sd	s3,56(sp)
 274:	f852                	sd	s4,48(sp)
 276:	f456                	sd	s5,40(sp)
 278:	f05a                	sd	s6,32(sp)
 27a:	ec5e                	sd	s7,24(sp)
 27c:	1080                	addi	s0,sp,96
 27e:	8baa                	mv	s7,a0
 280:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 282:	892a                	mv	s2,a0
 284:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 286:	4aa9                	li	s5,10
 288:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 28a:	89a6                	mv	s3,s1
 28c:	2485                	addiw	s1,s1,1
 28e:	0344d863          	bge	s1,s4,2be <gets+0x56>
    cc = read(0, &c, 1);
 292:	4605                	li	a2,1
 294:	faf40593          	addi	a1,s0,-81
 298:	4501                	li	a0,0
 29a:	00000097          	auipc	ra,0x0
 29e:	19a080e7          	jalr	410(ra) # 434 <read>
    if(cc < 1)
 2a2:	00a05e63          	blez	a0,2be <gets+0x56>
    buf[i++] = c;
 2a6:	faf44783          	lbu	a5,-81(s0)
 2aa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ae:	01578763          	beq	a5,s5,2bc <gets+0x54>
 2b2:	0905                	addi	s2,s2,1
 2b4:	fd679be3          	bne	a5,s6,28a <gets+0x22>
  for(i=0; i+1 < max; ){
 2b8:	89a6                	mv	s3,s1
 2ba:	a011                	j	2be <gets+0x56>
 2bc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2be:	99de                	add	s3,s3,s7
 2c0:	00098023          	sb	zero,0(s3)
  return buf;
}
 2c4:	855e                	mv	a0,s7
 2c6:	60e6                	ld	ra,88(sp)
 2c8:	6446                	ld	s0,80(sp)
 2ca:	64a6                	ld	s1,72(sp)
 2cc:	6906                	ld	s2,64(sp)
 2ce:	79e2                	ld	s3,56(sp)
 2d0:	7a42                	ld	s4,48(sp)
 2d2:	7aa2                	ld	s5,40(sp)
 2d4:	7b02                	ld	s6,32(sp)
 2d6:	6be2                	ld	s7,24(sp)
 2d8:	6125                	addi	sp,sp,96
 2da:	8082                	ret

00000000000002dc <stat>:

int
stat(const char *n, struct stat *st)
{
 2dc:	1101                	addi	sp,sp,-32
 2de:	ec06                	sd	ra,24(sp)
 2e0:	e822                	sd	s0,16(sp)
 2e2:	e426                	sd	s1,8(sp)
 2e4:	e04a                	sd	s2,0(sp)
 2e6:	1000                	addi	s0,sp,32
 2e8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ea:	4581                	li	a1,0
 2ec:	00000097          	auipc	ra,0x0
 2f0:	170080e7          	jalr	368(ra) # 45c <open>
  if(fd < 0)
 2f4:	02054563          	bltz	a0,31e <stat+0x42>
 2f8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2fa:	85ca                	mv	a1,s2
 2fc:	00000097          	auipc	ra,0x0
 300:	178080e7          	jalr	376(ra) # 474 <fstat>
 304:	892a                	mv	s2,a0
  close(fd);
 306:	8526                	mv	a0,s1
 308:	00000097          	auipc	ra,0x0
 30c:	13c080e7          	jalr	316(ra) # 444 <close>
  return r;
}
 310:	854a                	mv	a0,s2
 312:	60e2                	ld	ra,24(sp)
 314:	6442                	ld	s0,16(sp)
 316:	64a2                	ld	s1,8(sp)
 318:	6902                	ld	s2,0(sp)
 31a:	6105                	addi	sp,sp,32
 31c:	8082                	ret
    return -1;
 31e:	597d                	li	s2,-1
 320:	bfc5                	j	310 <stat+0x34>

0000000000000322 <atoi>:

int
atoi(const char *s)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 328:	00054683          	lbu	a3,0(a0)
 32c:	fd06879b          	addiw	a5,a3,-48
 330:	0ff7f793          	zext.b	a5,a5
 334:	4625                	li	a2,9
 336:	02f66863          	bltu	a2,a5,366 <atoi+0x44>
 33a:	872a                	mv	a4,a0
  n = 0;
 33c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 33e:	0705                	addi	a4,a4,1
 340:	0025179b          	slliw	a5,a0,0x2
 344:	9fa9                	addw	a5,a5,a0
 346:	0017979b          	slliw	a5,a5,0x1
 34a:	9fb5                	addw	a5,a5,a3
 34c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 350:	00074683          	lbu	a3,0(a4)
 354:	fd06879b          	addiw	a5,a3,-48
 358:	0ff7f793          	zext.b	a5,a5
 35c:	fef671e3          	bgeu	a2,a5,33e <atoi+0x1c>
  return n;
}
 360:	6422                	ld	s0,8(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
  n = 0;
 366:	4501                	li	a0,0
 368:	bfe5                	j	360 <atoi+0x3e>

000000000000036a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e422                	sd	s0,8(sp)
 36e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 370:	02b57463          	bgeu	a0,a1,398 <memmove+0x2e>
    while(n-- > 0)
 374:	00c05f63          	blez	a2,392 <memmove+0x28>
 378:	1602                	slli	a2,a2,0x20
 37a:	9201                	srli	a2,a2,0x20
 37c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 380:	872a                	mv	a4,a0
      *dst++ = *src++;
 382:	0585                	addi	a1,a1,1
 384:	0705                	addi	a4,a4,1
 386:	fff5c683          	lbu	a3,-1(a1)
 38a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 38e:	fee79ae3          	bne	a5,a4,382 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 392:	6422                	ld	s0,8(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret
    dst += n;
 398:	00c50733          	add	a4,a0,a2
    src += n;
 39c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 39e:	fec05ae3          	blez	a2,392 <memmove+0x28>
 3a2:	fff6079b          	addiw	a5,a2,-1
 3a6:	1782                	slli	a5,a5,0x20
 3a8:	9381                	srli	a5,a5,0x20
 3aa:	fff7c793          	not	a5,a5
 3ae:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3b0:	15fd                	addi	a1,a1,-1
 3b2:	177d                	addi	a4,a4,-1
 3b4:	0005c683          	lbu	a3,0(a1)
 3b8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3bc:	fee79ae3          	bne	a5,a4,3b0 <memmove+0x46>
 3c0:	bfc9                	j	392 <memmove+0x28>

00000000000003c2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e422                	sd	s0,8(sp)
 3c6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c8:	ca05                	beqz	a2,3f8 <memcmp+0x36>
 3ca:	fff6069b          	addiw	a3,a2,-1
 3ce:	1682                	slli	a3,a3,0x20
 3d0:	9281                	srli	a3,a3,0x20
 3d2:	0685                	addi	a3,a3,1
 3d4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3d6:	00054783          	lbu	a5,0(a0)
 3da:	0005c703          	lbu	a4,0(a1)
 3de:	00e79863          	bne	a5,a4,3ee <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3e2:	0505                	addi	a0,a0,1
    p2++;
 3e4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e6:	fed518e3          	bne	a0,a3,3d6 <memcmp+0x14>
  }
  return 0;
 3ea:	4501                	li	a0,0
 3ec:	a019                	j	3f2 <memcmp+0x30>
      return *p1 - *p2;
 3ee:	40e7853b          	subw	a0,a5,a4
}
 3f2:	6422                	ld	s0,8(sp)
 3f4:	0141                	addi	sp,sp,16
 3f6:	8082                	ret
  return 0;
 3f8:	4501                	li	a0,0
 3fa:	bfe5                	j	3f2 <memcmp+0x30>

00000000000003fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3fc:	1141                	addi	sp,sp,-16
 3fe:	e406                	sd	ra,8(sp)
 400:	e022                	sd	s0,0(sp)
 402:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 404:	00000097          	auipc	ra,0x0
 408:	f66080e7          	jalr	-154(ra) # 36a <memmove>
}
 40c:	60a2                	ld	ra,8(sp)
 40e:	6402                	ld	s0,0(sp)
 410:	0141                	addi	sp,sp,16
 412:	8082                	ret

0000000000000414 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 414:	4885                	li	a7,1
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <exit>:
.global exit
exit:
 li a7, SYS_exit
 41c:	4889                	li	a7,2
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <wait>:
.global wait
wait:
 li a7, SYS_wait
 424:	488d                	li	a7,3
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 42c:	4891                	li	a7,4
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <read>:
.global read
read:
 li a7, SYS_read
 434:	4895                	li	a7,5
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <write>:
.global write
write:
 li a7, SYS_write
 43c:	48c1                	li	a7,16
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <close>:
.global close
close:
 li a7, SYS_close
 444:	48d5                	li	a7,21
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <kill>:
.global kill
kill:
 li a7, SYS_kill
 44c:	4899                	li	a7,6
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <exec>:
.global exec
exec:
 li a7, SYS_exec
 454:	489d                	li	a7,7
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <open>:
.global open
open:
 li a7, SYS_open
 45c:	48bd                	li	a7,15
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 464:	48c5                	li	a7,17
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 46c:	48c9                	li	a7,18
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 474:	48a1                	li	a7,8
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <link>:
.global link
link:
 li a7, SYS_link
 47c:	48cd                	li	a7,19
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 484:	48d1                	li	a7,20
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 48c:	48a5                	li	a7,9
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <dup>:
.global dup
dup:
 li a7, SYS_dup
 494:	48a9                	li	a7,10
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 49c:	48ad                	li	a7,11
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4a4:	48b1                	li	a7,12
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4ac:	48b5                	li	a7,13
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4b4:	48b9                	li	a7,14
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <head>:
.global head
head:
 li a7, SYS_head
 4bc:	48d9                	li	a7,22
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 4c4:	48dd                	li	a7,23
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <ps>:
.global ps
ps:
 li a7, SYS_ps
 4cc:	48e1                	li	a7,24
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <times>:
.global times
times:
 li a7, SYS_times
 4d4:	48e5                	li	a7,25
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 4dc:	48e9                	li	a7,26
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 4e4:	48ed                	li	a7,27
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 4ec:	48f1                	li	a7,28
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 4f4:	48f5                	li	a7,29
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fc:	1101                	addi	sp,sp,-32
 4fe:	ec06                	sd	ra,24(sp)
 500:	e822                	sd	s0,16(sp)
 502:	1000                	addi	s0,sp,32
 504:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 508:	4605                	li	a2,1
 50a:	fef40593          	addi	a1,s0,-17
 50e:	00000097          	auipc	ra,0x0
 512:	f2e080e7          	jalr	-210(ra) # 43c <write>
}
 516:	60e2                	ld	ra,24(sp)
 518:	6442                	ld	s0,16(sp)
 51a:	6105                	addi	sp,sp,32
 51c:	8082                	ret

000000000000051e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51e:	7139                	addi	sp,sp,-64
 520:	fc06                	sd	ra,56(sp)
 522:	f822                	sd	s0,48(sp)
 524:	f426                	sd	s1,40(sp)
 526:	f04a                	sd	s2,32(sp)
 528:	ec4e                	sd	s3,24(sp)
 52a:	0080                	addi	s0,sp,64
 52c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 52e:	c299                	beqz	a3,534 <printint+0x16>
 530:	0805c963          	bltz	a1,5c2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 534:	2581                	sext.w	a1,a1
  neg = 0;
 536:	4881                	li	a7,0
 538:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 53c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 53e:	2601                	sext.w	a2,a2
 540:	00001517          	auipc	a0,0x1
 544:	98850513          	addi	a0,a0,-1656 # ec8 <digits>
 548:	883a                	mv	a6,a4
 54a:	2705                	addiw	a4,a4,1
 54c:	02c5f7bb          	remuw	a5,a1,a2
 550:	1782                	slli	a5,a5,0x20
 552:	9381                	srli	a5,a5,0x20
 554:	97aa                	add	a5,a5,a0
 556:	0007c783          	lbu	a5,0(a5)
 55a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 55e:	0005879b          	sext.w	a5,a1
 562:	02c5d5bb          	divuw	a1,a1,a2
 566:	0685                	addi	a3,a3,1
 568:	fec7f0e3          	bgeu	a5,a2,548 <printint+0x2a>
  if(neg)
 56c:	00088c63          	beqz	a7,584 <printint+0x66>
    buf[i++] = '-';
 570:	fd070793          	addi	a5,a4,-48
 574:	00878733          	add	a4,a5,s0
 578:	02d00793          	li	a5,45
 57c:	fef70823          	sb	a5,-16(a4)
 580:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 584:	02e05863          	blez	a4,5b4 <printint+0x96>
 588:	fc040793          	addi	a5,s0,-64
 58c:	00e78933          	add	s2,a5,a4
 590:	fff78993          	addi	s3,a5,-1
 594:	99ba                	add	s3,s3,a4
 596:	377d                	addiw	a4,a4,-1
 598:	1702                	slli	a4,a4,0x20
 59a:	9301                	srli	a4,a4,0x20
 59c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5a0:	fff94583          	lbu	a1,-1(s2)
 5a4:	8526                	mv	a0,s1
 5a6:	00000097          	auipc	ra,0x0
 5aa:	f56080e7          	jalr	-170(ra) # 4fc <putc>
  while(--i >= 0)
 5ae:	197d                	addi	s2,s2,-1
 5b0:	ff3918e3          	bne	s2,s3,5a0 <printint+0x82>
}
 5b4:	70e2                	ld	ra,56(sp)
 5b6:	7442                	ld	s0,48(sp)
 5b8:	74a2                	ld	s1,40(sp)
 5ba:	7902                	ld	s2,32(sp)
 5bc:	69e2                	ld	s3,24(sp)
 5be:	6121                	addi	sp,sp,64
 5c0:	8082                	ret
    x = -xx;
 5c2:	40b005bb          	negw	a1,a1
    neg = 1;
 5c6:	4885                	li	a7,1
    x = -xx;
 5c8:	bf85                	j	538 <printint+0x1a>

00000000000005ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ca:	7119                	addi	sp,sp,-128
 5cc:	fc86                	sd	ra,120(sp)
 5ce:	f8a2                	sd	s0,112(sp)
 5d0:	f4a6                	sd	s1,104(sp)
 5d2:	f0ca                	sd	s2,96(sp)
 5d4:	ecce                	sd	s3,88(sp)
 5d6:	e8d2                	sd	s4,80(sp)
 5d8:	e4d6                	sd	s5,72(sp)
 5da:	e0da                	sd	s6,64(sp)
 5dc:	fc5e                	sd	s7,56(sp)
 5de:	f862                	sd	s8,48(sp)
 5e0:	f466                	sd	s9,40(sp)
 5e2:	f06a                	sd	s10,32(sp)
 5e4:	ec6e                	sd	s11,24(sp)
 5e6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5e8:	0005c903          	lbu	s2,0(a1)
 5ec:	18090f63          	beqz	s2,78a <vprintf+0x1c0>
 5f0:	8aaa                	mv	s5,a0
 5f2:	8b32                	mv	s6,a2
 5f4:	00158493          	addi	s1,a1,1
  state = 0;
 5f8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5fa:	02500a13          	li	s4,37
 5fe:	4c55                	li	s8,21
 600:	00001c97          	auipc	s9,0x1
 604:	870c8c93          	addi	s9,s9,-1936 # e70 <get_time_perf+0xb8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 608:	02800d93          	li	s11,40
  putc(fd, 'x');
 60c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60e:	00001b97          	auipc	s7,0x1
 612:	8bab8b93          	addi	s7,s7,-1862 # ec8 <digits>
 616:	a839                	j	634 <vprintf+0x6a>
        putc(fd, c);
 618:	85ca                	mv	a1,s2
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	ee0080e7          	jalr	-288(ra) # 4fc <putc>
 624:	a019                	j	62a <vprintf+0x60>
    } else if(state == '%'){
 626:	01498d63          	beq	s3,s4,640 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 62a:	0485                	addi	s1,s1,1
 62c:	fff4c903          	lbu	s2,-1(s1)
 630:	14090d63          	beqz	s2,78a <vprintf+0x1c0>
    if(state == 0){
 634:	fe0999e3          	bnez	s3,626 <vprintf+0x5c>
      if(c == '%'){
 638:	ff4910e3          	bne	s2,s4,618 <vprintf+0x4e>
        state = '%';
 63c:	89d2                	mv	s3,s4
 63e:	b7f5                	j	62a <vprintf+0x60>
      if(c == 'd'){
 640:	11490c63          	beq	s2,s4,758 <vprintf+0x18e>
 644:	f9d9079b          	addiw	a5,s2,-99
 648:	0ff7f793          	zext.b	a5,a5
 64c:	10fc6e63          	bltu	s8,a5,768 <vprintf+0x19e>
 650:	f9d9079b          	addiw	a5,s2,-99
 654:	0ff7f713          	zext.b	a4,a5
 658:	10ec6863          	bltu	s8,a4,768 <vprintf+0x19e>
 65c:	00271793          	slli	a5,a4,0x2
 660:	97e6                	add	a5,a5,s9
 662:	439c                	lw	a5,0(a5)
 664:	97e6                	add	a5,a5,s9
 666:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 668:	008b0913          	addi	s2,s6,8
 66c:	4685                	li	a3,1
 66e:	4629                	li	a2,10
 670:	000b2583          	lw	a1,0(s6)
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	ea8080e7          	jalr	-344(ra) # 51e <printint>
 67e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 680:	4981                	li	s3,0
 682:	b765                	j	62a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 684:	008b0913          	addi	s2,s6,8
 688:	4681                	li	a3,0
 68a:	4629                	li	a2,10
 68c:	000b2583          	lw	a1,0(s6)
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e8c080e7          	jalr	-372(ra) # 51e <printint>
 69a:	8b4a                	mv	s6,s2
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b771                	j	62a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6a0:	008b0913          	addi	s2,s6,8
 6a4:	4681                	li	a3,0
 6a6:	866a                	mv	a2,s10
 6a8:	000b2583          	lw	a1,0(s6)
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	e70080e7          	jalr	-400(ra) # 51e <printint>
 6b6:	8b4a                	mv	s6,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bf85                	j	62a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6bc:	008b0793          	addi	a5,s6,8
 6c0:	f8f43423          	sd	a5,-120(s0)
 6c4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6c8:	03000593          	li	a1,48
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e2e080e7          	jalr	-466(ra) # 4fc <putc>
  putc(fd, 'x');
 6d6:	07800593          	li	a1,120
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	e20080e7          	jalr	-480(ra) # 4fc <putc>
 6e4:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e6:	03c9d793          	srli	a5,s3,0x3c
 6ea:	97de                	add	a5,a5,s7
 6ec:	0007c583          	lbu	a1,0(a5)
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	e0a080e7          	jalr	-502(ra) # 4fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fa:	0992                	slli	s3,s3,0x4
 6fc:	397d                	addiw	s2,s2,-1
 6fe:	fe0914e3          	bnez	s2,6e6 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 702:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 706:	4981                	li	s3,0
 708:	b70d                	j	62a <vprintf+0x60>
        s = va_arg(ap, char*);
 70a:	008b0913          	addi	s2,s6,8
 70e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 712:	02098163          	beqz	s3,734 <vprintf+0x16a>
        while(*s != 0){
 716:	0009c583          	lbu	a1,0(s3)
 71a:	c5ad                	beqz	a1,784 <vprintf+0x1ba>
          putc(fd, *s);
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	dde080e7          	jalr	-546(ra) # 4fc <putc>
          s++;
 726:	0985                	addi	s3,s3,1
        while(*s != 0){
 728:	0009c583          	lbu	a1,0(s3)
 72c:	f9e5                	bnez	a1,71c <vprintf+0x152>
        s = va_arg(ap, char*);
 72e:	8b4a                	mv	s6,s2
      state = 0;
 730:	4981                	li	s3,0
 732:	bde5                	j	62a <vprintf+0x60>
          s = "(null)";
 734:	00000997          	auipc	s3,0x0
 738:	73498993          	addi	s3,s3,1844 # e68 <get_time_perf+0xb0>
        while(*s != 0){
 73c:	85ee                	mv	a1,s11
 73e:	bff9                	j	71c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 740:	008b0913          	addi	s2,s6,8
 744:	000b4583          	lbu	a1,0(s6)
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	db2080e7          	jalr	-590(ra) # 4fc <putc>
 752:	8b4a                	mv	s6,s2
      state = 0;
 754:	4981                	li	s3,0
 756:	bdd1                	j	62a <vprintf+0x60>
        putc(fd, c);
 758:	85d2                	mv	a1,s4
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	da0080e7          	jalr	-608(ra) # 4fc <putc>
      state = 0;
 764:	4981                	li	s3,0
 766:	b5d1                	j	62a <vprintf+0x60>
        putc(fd, '%');
 768:	85d2                	mv	a1,s4
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	d90080e7          	jalr	-624(ra) # 4fc <putc>
        putc(fd, c);
 774:	85ca                	mv	a1,s2
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	d84080e7          	jalr	-636(ra) # 4fc <putc>
      state = 0;
 780:	4981                	li	s3,0
 782:	b565                	j	62a <vprintf+0x60>
        s = va_arg(ap, char*);
 784:	8b4a                	mv	s6,s2
      state = 0;
 786:	4981                	li	s3,0
 788:	b54d                	j	62a <vprintf+0x60>
    }
  }
}
 78a:	70e6                	ld	ra,120(sp)
 78c:	7446                	ld	s0,112(sp)
 78e:	74a6                	ld	s1,104(sp)
 790:	7906                	ld	s2,96(sp)
 792:	69e6                	ld	s3,88(sp)
 794:	6a46                	ld	s4,80(sp)
 796:	6aa6                	ld	s5,72(sp)
 798:	6b06                	ld	s6,64(sp)
 79a:	7be2                	ld	s7,56(sp)
 79c:	7c42                	ld	s8,48(sp)
 79e:	7ca2                	ld	s9,40(sp)
 7a0:	7d02                	ld	s10,32(sp)
 7a2:	6de2                	ld	s11,24(sp)
 7a4:	6109                	addi	sp,sp,128
 7a6:	8082                	ret

00000000000007a8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a8:	715d                	addi	sp,sp,-80
 7aa:	ec06                	sd	ra,24(sp)
 7ac:	e822                	sd	s0,16(sp)
 7ae:	1000                	addi	s0,sp,32
 7b0:	e010                	sd	a2,0(s0)
 7b2:	e414                	sd	a3,8(s0)
 7b4:	e818                	sd	a4,16(s0)
 7b6:	ec1c                	sd	a5,24(s0)
 7b8:	03043023          	sd	a6,32(s0)
 7bc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c4:	8622                	mv	a2,s0
 7c6:	00000097          	auipc	ra,0x0
 7ca:	e04080e7          	jalr	-508(ra) # 5ca <vprintf>
}
 7ce:	60e2                	ld	ra,24(sp)
 7d0:	6442                	ld	s0,16(sp)
 7d2:	6161                	addi	sp,sp,80
 7d4:	8082                	ret

00000000000007d6 <printf>:

void
printf(const char *fmt, ...)
{
 7d6:	711d                	addi	sp,sp,-96
 7d8:	ec06                	sd	ra,24(sp)
 7da:	e822                	sd	s0,16(sp)
 7dc:	1000                	addi	s0,sp,32
 7de:	e40c                	sd	a1,8(s0)
 7e0:	e810                	sd	a2,16(s0)
 7e2:	ec14                	sd	a3,24(s0)
 7e4:	f018                	sd	a4,32(s0)
 7e6:	f41c                	sd	a5,40(s0)
 7e8:	03043823          	sd	a6,48(s0)
 7ec:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f0:	00840613          	addi	a2,s0,8
 7f4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f8:	85aa                	mv	a1,a0
 7fa:	4505                	li	a0,1
 7fc:	00000097          	auipc	ra,0x0
 800:	dce080e7          	jalr	-562(ra) # 5ca <vprintf>
}
 804:	60e2                	ld	ra,24(sp)
 806:	6442                	ld	s0,16(sp)
 808:	6125                	addi	sp,sp,96
 80a:	8082                	ret

000000000000080c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80c:	1141                	addi	sp,sp,-16
 80e:	e422                	sd	s0,8(sp)
 810:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 812:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 816:	00000797          	auipc	a5,0x0
 81a:	7ea7b783          	ld	a5,2026(a5) # 1000 <freep>
 81e:	a02d                	j	848 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 820:	4618                	lw	a4,8(a2)
 822:	9f2d                	addw	a4,a4,a1
 824:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 828:	6398                	ld	a4,0(a5)
 82a:	6310                	ld	a2,0(a4)
 82c:	a83d                	j	86a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 82e:	ff852703          	lw	a4,-8(a0)
 832:	9f31                	addw	a4,a4,a2
 834:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 836:	ff053683          	ld	a3,-16(a0)
 83a:	a091                	j	87e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83c:	6398                	ld	a4,0(a5)
 83e:	00e7e463          	bltu	a5,a4,846 <free+0x3a>
 842:	00e6ea63          	bltu	a3,a4,856 <free+0x4a>
{
 846:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 848:	fed7fae3          	bgeu	a5,a3,83c <free+0x30>
 84c:	6398                	ld	a4,0(a5)
 84e:	00e6e463          	bltu	a3,a4,856 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 852:	fee7eae3          	bltu	a5,a4,846 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 856:	ff852583          	lw	a1,-8(a0)
 85a:	6390                	ld	a2,0(a5)
 85c:	02059813          	slli	a6,a1,0x20
 860:	01c85713          	srli	a4,a6,0x1c
 864:	9736                	add	a4,a4,a3
 866:	fae60de3          	beq	a2,a4,820 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 86a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 86e:	4790                	lw	a2,8(a5)
 870:	02061593          	slli	a1,a2,0x20
 874:	01c5d713          	srli	a4,a1,0x1c
 878:	973e                	add	a4,a4,a5
 87a:	fae68ae3          	beq	a3,a4,82e <free+0x22>
    p->s.ptr = bp->s.ptr;
 87e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 880:	00000717          	auipc	a4,0x0
 884:	78f73023          	sd	a5,1920(a4) # 1000 <freep>
}
 888:	6422                	ld	s0,8(sp)
 88a:	0141                	addi	sp,sp,16
 88c:	8082                	ret

000000000000088e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 88e:	7139                	addi	sp,sp,-64
 890:	fc06                	sd	ra,56(sp)
 892:	f822                	sd	s0,48(sp)
 894:	f426                	sd	s1,40(sp)
 896:	f04a                	sd	s2,32(sp)
 898:	ec4e                	sd	s3,24(sp)
 89a:	e852                	sd	s4,16(sp)
 89c:	e456                	sd	s5,8(sp)
 89e:	e05a                	sd	s6,0(sp)
 8a0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a2:	02051493          	slli	s1,a0,0x20
 8a6:	9081                	srli	s1,s1,0x20
 8a8:	04bd                	addi	s1,s1,15
 8aa:	8091                	srli	s1,s1,0x4
 8ac:	0014899b          	addiw	s3,s1,1
 8b0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b2:	00000517          	auipc	a0,0x0
 8b6:	74e53503          	ld	a0,1870(a0) # 1000 <freep>
 8ba:	c515                	beqz	a0,8e6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8be:	4798                	lw	a4,8(a5)
 8c0:	02977f63          	bgeu	a4,s1,8fe <malloc+0x70>
 8c4:	8a4e                	mv	s4,s3
 8c6:	0009871b          	sext.w	a4,s3
 8ca:	6685                	lui	a3,0x1
 8cc:	00d77363          	bgeu	a4,a3,8d2 <malloc+0x44>
 8d0:	6a05                	lui	s4,0x1
 8d2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8da:	00000917          	auipc	s2,0x0
 8de:	72690913          	addi	s2,s2,1830 # 1000 <freep>
  if(p == (char*)-1)
 8e2:	5afd                	li	s5,-1
 8e4:	a895                	j	958 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8e6:	00001797          	auipc	a5,0x1
 8ea:	92a78793          	addi	a5,a5,-1750 # 1210 <base>
 8ee:	00000717          	auipc	a4,0x0
 8f2:	70f73923          	sd	a5,1810(a4) # 1000 <freep>
 8f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fc:	b7e1                	j	8c4 <malloc+0x36>
      if(p->s.size == nunits)
 8fe:	02e48c63          	beq	s1,a4,936 <malloc+0xa8>
        p->s.size -= nunits;
 902:	4137073b          	subw	a4,a4,s3
 906:	c798                	sw	a4,8(a5)
        p += p->s.size;
 908:	02071693          	slli	a3,a4,0x20
 90c:	01c6d713          	srli	a4,a3,0x1c
 910:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 912:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 916:	00000717          	auipc	a4,0x0
 91a:	6ea73523          	sd	a0,1770(a4) # 1000 <freep>
      return (void*)(p + 1);
 91e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 922:	70e2                	ld	ra,56(sp)
 924:	7442                	ld	s0,48(sp)
 926:	74a2                	ld	s1,40(sp)
 928:	7902                	ld	s2,32(sp)
 92a:	69e2                	ld	s3,24(sp)
 92c:	6a42                	ld	s4,16(sp)
 92e:	6aa2                	ld	s5,8(sp)
 930:	6b02                	ld	s6,0(sp)
 932:	6121                	addi	sp,sp,64
 934:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 936:	6398                	ld	a4,0(a5)
 938:	e118                	sd	a4,0(a0)
 93a:	bff1                	j	916 <malloc+0x88>
  hp->s.size = nu;
 93c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 940:	0541                	addi	a0,a0,16
 942:	00000097          	auipc	ra,0x0
 946:	eca080e7          	jalr	-310(ra) # 80c <free>
  return freep;
 94a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 94e:	d971                	beqz	a0,922 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 950:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 952:	4798                	lw	a4,8(a5)
 954:	fa9775e3          	bgeu	a4,s1,8fe <malloc+0x70>
    if(p == freep)
 958:	00093703          	ld	a4,0(s2)
 95c:	853e                	mv	a0,a5
 95e:	fef719e3          	bne	a4,a5,950 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 962:	8552                	mv	a0,s4
 964:	00000097          	auipc	ra,0x0
 968:	b40080e7          	jalr	-1216(ra) # 4a4 <sbrk>
  if(p == (char*)-1)
 96c:	fd5518e3          	bne	a0,s5,93c <malloc+0xae>
        return 0;
 970:	4501                	li	a0,0
 972:	bf45                	j	922 <malloc+0x94>

0000000000000974 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 974:	c1d9                	beqz	a1,9fa <head_run+0x86>
void head_run(int fd, int numOfLines){
 976:	dd010113          	addi	sp,sp,-560
 97a:	22113423          	sd	ra,552(sp)
 97e:	22813023          	sd	s0,544(sp)
 982:	20913c23          	sd	s1,536(sp)
 986:	21213823          	sd	s2,528(sp)
 98a:	21313423          	sd	s3,520(sp)
 98e:	21413023          	sd	s4,512(sp)
 992:	1c00                	addi	s0,sp,560
 994:	892a                	mv	s2,a0
 996:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 99a:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 99c:	00000a17          	auipc	s4,0x0
 9a0:	56ca0a13          	addi	s4,s4,1388 # f08 <digits+0x40>
		readStatus = read_line(fd, line);
 9a4:	dd840593          	addi	a1,s0,-552
 9a8:	854a                	mv	a0,s2
 9aa:	00000097          	auipc	ra,0x0
 9ae:	394080e7          	jalr	916(ra) # d3e <read_line>
		if (readStatus == READ_ERROR){
 9b2:	01350d63          	beq	a0,s3,9cc <head_run+0x58>
		if (readStatus == READ_EOF)
 9b6:	c11d                	beqz	a0,9dc <head_run+0x68>
		printf("%s",line);
 9b8:	dd840593          	addi	a1,s0,-552
 9bc:	8552                	mv	a0,s4
 9be:	00000097          	auipc	ra,0x0
 9c2:	e18080e7          	jalr	-488(ra) # 7d6 <printf>
	while(numOfLines--){
 9c6:	34fd                	addiw	s1,s1,-1
 9c8:	fcf1                	bnez	s1,9a4 <head_run+0x30>
 9ca:	a809                	j	9dc <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 9cc:	00000517          	auipc	a0,0x0
 9d0:	51450513          	addi	a0,a0,1300 # ee0 <digits+0x18>
 9d4:	00000097          	auipc	ra,0x0
 9d8:	e02080e7          	jalr	-510(ra) # 7d6 <printf>

	}
}
 9dc:	22813083          	ld	ra,552(sp)
 9e0:	22013403          	ld	s0,544(sp)
 9e4:	21813483          	ld	s1,536(sp)
 9e8:	21013903          	ld	s2,528(sp)
 9ec:	20813983          	ld	s3,520(sp)
 9f0:	20013a03          	ld	s4,512(sp)
 9f4:	23010113          	addi	sp,sp,560
 9f8:	8082                	ret
 9fa:	8082                	ret

00000000000009fc <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 9fc:	ba010113          	addi	sp,sp,-1120
 a00:	44113c23          	sd	ra,1112(sp)
 a04:	44813823          	sd	s0,1104(sp)
 a08:	44913423          	sd	s1,1096(sp)
 a0c:	45213023          	sd	s2,1088(sp)
 a10:	43313c23          	sd	s3,1080(sp)
 a14:	43413823          	sd	s4,1072(sp)
 a18:	43513423          	sd	s5,1064(sp)
 a1c:	43613023          	sd	s6,1056(sp)
 a20:	41713c23          	sd	s7,1048(sp)
 a24:	41813823          	sd	s8,1040(sp)
 a28:	41913423          	sd	s9,1032(sp)
 a2c:	41a13023          	sd	s10,1024(sp)
 a30:	3fb13c23          	sd	s11,1016(sp)
 a34:	46010413          	addi	s0,sp,1120
 a38:	89aa                	mv	s3,a0
 a3a:	8aae                	mv	s5,a1
 a3c:	8c32                	mv	s8,a2
 a3e:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 a40:	d9840593          	addi	a1,s0,-616
 a44:	00000097          	auipc	ra,0x0
 a48:	2fa080e7          	jalr	762(ra) # d3e <read_line>


  if (readStatus == READ_ERROR)
 a4c:	57fd                	li	a5,-1
 a4e:	04f50163          	beq	a0,a5,a90 <uniq_run+0x94>
 a52:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 a54:	ed21                	bnez	a0,aac <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 a56:	45813083          	ld	ra,1112(sp)
 a5a:	45013403          	ld	s0,1104(sp)
 a5e:	44813483          	ld	s1,1096(sp)
 a62:	44013903          	ld	s2,1088(sp)
 a66:	43813983          	ld	s3,1080(sp)
 a6a:	43013a03          	ld	s4,1072(sp)
 a6e:	42813a83          	ld	s5,1064(sp)
 a72:	42013b03          	ld	s6,1056(sp)
 a76:	41813b83          	ld	s7,1048(sp)
 a7a:	41013c03          	ld	s8,1040(sp)
 a7e:	40813c83          	ld	s9,1032(sp)
 a82:	40013d03          	ld	s10,1024(sp)
 a86:	3f813d83          	ld	s11,1016(sp)
 a8a:	46010113          	addi	sp,sp,1120
 a8e:	8082                	ret
    printf("[ERR] Error reading from the file ");
 a90:	00000517          	auipc	a0,0x0
 a94:	48050513          	addi	a0,a0,1152 # f10 <digits+0x48>
 a98:	00000097          	auipc	ra,0x0
 a9c:	d3e080e7          	jalr	-706(ra) # 7d6 <printf>
 aa0:	bf5d                	j	a56 <uniq_run+0x5a>
 aa2:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 aa4:	8926                	mv	s2,s1
 aa6:	84be                	mv	s1,a5
        lineCount = 1;
 aa8:	8b6a                	mv	s6,s10
 aaa:	a8ed                	j	ba4 <uniq_run+0x1a8>
    int lineCount=1;
 aac:	4b05                	li	s6,1
  char * line2 = buffer2;
 aae:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 ab2:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 ab6:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 ab8:	4d05                	li	s10,1
              printf("%s",line1);
 aba:	00000d97          	auipc	s11,0x0
 abe:	44ed8d93          	addi	s11,s11,1102 # f08 <digits+0x40>
 ac2:	a0cd                	j	ba4 <uniq_run+0x1a8>
            if (repeatedLines){
 ac4:	020a0b63          	beqz	s4,afa <uniq_run+0xfe>
                if (isRepeated){
 ac8:	f80b87e3          	beqz	s7,a56 <uniq_run+0x5a>
                    if (showCount)
 acc:	000c0d63          	beqz	s8,ae6 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 ad0:	864a                	mv	a2,s2
 ad2:	85da                	mv	a1,s6
 ad4:	00000517          	auipc	a0,0x0
 ad8:	46450513          	addi	a0,a0,1124 # f38 <digits+0x70>
 adc:	00000097          	auipc	ra,0x0
 ae0:	cfa080e7          	jalr	-774(ra) # 7d6 <printf>
 ae4:	bf8d                	j	a56 <uniq_run+0x5a>
                      printf("%s",line1);
 ae6:	85ca                	mv	a1,s2
 ae8:	00000517          	auipc	a0,0x0
 aec:	42050513          	addi	a0,a0,1056 # f08 <digits+0x40>
 af0:	00000097          	auipc	ra,0x0
 af4:	ce6080e7          	jalr	-794(ra) # 7d6 <printf>
 af8:	bfb9                	j	a56 <uniq_run+0x5a>
                if (showCount)
 afa:	000c0d63          	beqz	s8,b14 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 afe:	864a                	mv	a2,s2
 b00:	85da                	mv	a1,s6
 b02:	00000517          	auipc	a0,0x0
 b06:	43650513          	addi	a0,a0,1078 # f38 <digits+0x70>
 b0a:	00000097          	auipc	ra,0x0
 b0e:	ccc080e7          	jalr	-820(ra) # 7d6 <printf>
 b12:	b791                	j	a56 <uniq_run+0x5a>
                  printf("%s",line1);
 b14:	85ca                	mv	a1,s2
 b16:	00000517          	auipc	a0,0x0
 b1a:	3f250513          	addi	a0,a0,1010 # f08 <digits+0x40>
 b1e:	00000097          	auipc	ra,0x0
 b22:	cb8080e7          	jalr	-840(ra) # 7d6 <printf>
 b26:	bf05                	j	a56 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 b28:	00000517          	auipc	a0,0x0
 b2c:	41850513          	addi	a0,a0,1048 # f40 <digits+0x78>
 b30:	00000097          	auipc	ra,0x0
 b34:	ca6080e7          	jalr	-858(ra) # 7d6 <printf>
          break;
 b38:	bf39                	j	a56 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 b3a:	85a6                	mv	a1,s1
 b3c:	854a                	mv	a0,s2
 b3e:	00000097          	auipc	ra,0x0
 b42:	110080e7          	jalr	272(ra) # c4e <compare_str_ic>
 b46:	a041                	j	bc6 <uniq_run+0x1ca>
                  printf("%s",line1);
 b48:	85ca                	mv	a1,s2
 b4a:	856e                	mv	a0,s11
 b4c:	00000097          	auipc	ra,0x0
 b50:	c8a080e7          	jalr	-886(ra) # 7d6 <printf>
        lineCount = 1;
 b54:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 b56:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b58:	8926                	mv	s2,s1
                  printf("%s",line1);
 b5a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b5c:	4b81                	li	s7,0
 b5e:	a099                	j	ba4 <uniq_run+0x1a8>
            if (showCount)
 b60:	020c0263          	beqz	s8,b84 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 b64:	864a                	mv	a2,s2
 b66:	85da                	mv	a1,s6
 b68:	00000517          	auipc	a0,0x0
 b6c:	3d050513          	addi	a0,a0,976 # f38 <digits+0x70>
 b70:	00000097          	auipc	ra,0x0
 b74:	c66080e7          	jalr	-922(ra) # 7d6 <printf>
 b78:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b7a:	8926                	mv	s2,s1
 b7c:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b7e:	4b81                	li	s7,0
        lineCount = 1;
 b80:	8b6a                	mv	s6,s10
 b82:	a00d                	j	ba4 <uniq_run+0x1a8>
              printf("%s",line1);
 b84:	85ca                	mv	a1,s2
 b86:	856e                	mv	a0,s11
 b88:	00000097          	auipc	ra,0x0
 b8c:	c4e080e7          	jalr	-946(ra) # 7d6 <printf>
 b90:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b92:	8926                	mv	s2,s1
              printf("%s",line1);
 b94:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b96:	4b81                	li	s7,0
        lineCount = 1;
 b98:	8b6a                	mv	s6,s10
 b9a:	a029                	j	ba4 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 b9c:	000a0363          	beqz	s4,ba2 <uniq_run+0x1a6>
 ba0:	8bea                	mv	s7,s10
          lineCount++;
 ba2:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 ba4:	85a6                	mv	a1,s1
 ba6:	854e                	mv	a0,s3
 ba8:	00000097          	auipc	ra,0x0
 bac:	196080e7          	jalr	406(ra) # d3e <read_line>
        if (readStatus == READ_EOF){
 bb0:	d911                	beqz	a0,ac4 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 bb2:	f7950be3          	beq	a0,s9,b28 <uniq_run+0x12c>
        if (!ignoreCase)
 bb6:	f80a92e3          	bnez	s5,b3a <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 bba:	85a6                	mv	a1,s1
 bbc:	854a                	mv	a0,s2
 bbe:	00000097          	auipc	ra,0x0
 bc2:	062080e7          	jalr	98(ra) # c20 <compare_str>
        if (compareStatus != 0){ 
 bc6:	d979                	beqz	a0,b9c <uniq_run+0x1a0>
          if (repeatedLines){
 bc8:	f80a0ce3          	beqz	s4,b60 <uniq_run+0x164>
            if (isRepeated){
 bcc:	ec0b8be3          	beqz	s7,aa2 <uniq_run+0xa6>
                if (showCount)
 bd0:	f60c0ce3          	beqz	s8,b48 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 bd4:	864a                	mv	a2,s2
 bd6:	85da                	mv	a1,s6
 bd8:	00000517          	auipc	a0,0x0
 bdc:	36050513          	addi	a0,a0,864 # f38 <digits+0x70>
 be0:	00000097          	auipc	ra,0x0
 be4:	bf6080e7          	jalr	-1034(ra) # 7d6 <printf>
        lineCount = 1;
 be8:	8b5e                	mv	s6,s7
 bea:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 bec:	8926                	mv	s2,s1
 bee:	84be                	mv	s1,a5
        isRepeated = 0 ;
 bf0:	4b81                	li	s7,0
 bf2:	bf4d                	j	ba4 <uniq_run+0x1a8>

0000000000000bf4 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 bf4:	1141                	addi	sp,sp,-16
 bf6:	e422                	sd	s0,8(sp)
 bf8:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 bfa:	00054783          	lbu	a5,0(a0)
 bfe:	cf99                	beqz	a5,c1c <get_strlen+0x28>
 c00:	00150713          	addi	a4,a0,1
 c04:	87ba                	mv	a5,a4
 c06:	4685                	li	a3,1
 c08:	9e99                	subw	a3,a3,a4
 c0a:	00f6853b          	addw	a0,a3,a5
 c0e:	0785                	addi	a5,a5,1
 c10:	fff7c703          	lbu	a4,-1(a5)
 c14:	fb7d                	bnez	a4,c0a <get_strlen+0x16>
	return len;
}
 c16:	6422                	ld	s0,8(sp)
 c18:	0141                	addi	sp,sp,16
 c1a:	8082                	ret
	int len = 0;
 c1c:	4501                	li	a0,0
 c1e:	bfe5                	j	c16 <get_strlen+0x22>

0000000000000c20 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 c20:	1141                	addi	sp,sp,-16
 c22:	e422                	sd	s0,8(sp)
 c24:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 c26:	00054783          	lbu	a5,0(a0)
 c2a:	cb91                	beqz	a5,c3e <compare_str+0x1e>
 c2c:	0005c703          	lbu	a4,0(a1)
 c30:	c719                	beqz	a4,c3e <compare_str+0x1e>
		if (*s1++ != *s2++)
 c32:	0505                	addi	a0,a0,1
 c34:	0585                	addi	a1,a1,1
 c36:	fee788e3          	beq	a5,a4,c26 <compare_str+0x6>
			return 1;
 c3a:	4505                	li	a0,1
 c3c:	a031                	j	c48 <compare_str+0x28>
	}
	if (*s1 == *s2)
 c3e:	0005c503          	lbu	a0,0(a1)
 c42:	8d1d                	sub	a0,a0,a5
			return 1;
 c44:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 c48:	6422                	ld	s0,8(sp)
 c4a:	0141                	addi	sp,sp,16
 c4c:	8082                	ret

0000000000000c4e <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 c4e:	1141                	addi	sp,sp,-16
 c50:	e422                	sd	s0,8(sp)
 c52:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 c54:	4665                	li	a2,25
	while(*s1 && *s2){
 c56:	a019                	j	c5c <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 c58:	04e79763          	bne	a5,a4,ca6 <compare_str_ic+0x58>
	while(*s1 && *s2){
 c5c:	00054783          	lbu	a5,0(a0)
 c60:	cb9d                	beqz	a5,c96 <compare_str_ic+0x48>
 c62:	0005c703          	lbu	a4,0(a1)
 c66:	cb05                	beqz	a4,c96 <compare_str_ic+0x48>
		char b1 = *s1++;
 c68:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 c6a:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 c6c:	fbf7869b          	addiw	a3,a5,-65
 c70:	0ff6f693          	zext.b	a3,a3
 c74:	00d66663          	bltu	a2,a3,c80 <compare_str_ic+0x32>
			b1 += 32;
 c78:	0207879b          	addiw	a5,a5,32
 c7c:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 c80:	fbf7069b          	addiw	a3,a4,-65
 c84:	0ff6f693          	zext.b	a3,a3
 c88:	fcd668e3          	bltu	a2,a3,c58 <compare_str_ic+0xa>
			b2 += 32;
 c8c:	0207071b          	addiw	a4,a4,32
 c90:	0ff77713          	zext.b	a4,a4
 c94:	b7d1                	j	c58 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 c96:	0005c503          	lbu	a0,0(a1)
 c9a:	8d1d                	sub	a0,a0,a5
			return 1;
 c9c:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 ca0:	6422                	ld	s0,8(sp)
 ca2:	0141                	addi	sp,sp,16
 ca4:	8082                	ret
			return 1;
 ca6:	4505                	li	a0,1
 ca8:	bfe5                	j	ca0 <compare_str_ic+0x52>

0000000000000caa <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 caa:	7179                	addi	sp,sp,-48
 cac:	f406                	sd	ra,40(sp)
 cae:	f022                	sd	s0,32(sp)
 cb0:	ec26                	sd	s1,24(sp)
 cb2:	e84a                	sd	s2,16(sp)
 cb4:	e44e                	sd	s3,8(sp)
 cb6:	1800                	addi	s0,sp,48
 cb8:	89aa                	mv	s3,a0
 cba:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 cbc:	00000097          	auipc	ra,0x0
 cc0:	f38080e7          	jalr	-200(ra) # bf4 <get_strlen>
 cc4:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 cc6:	854a                	mv	a0,s2
 cc8:	00000097          	auipc	ra,0x0
 ccc:	f2c080e7          	jalr	-212(ra) # bf4 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 cd0:	409505bb          	subw	a1,a0,s1
 cd4:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 cd6:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 cd8:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 cda:	0005da63          	bgez	a1,cee <check_substr+0x44>
 cde:	a81d                	j	d14 <check_substr+0x6a>
        if (j == M)
 ce0:	02f48a63          	beq	s1,a5,d14 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 ce4:	0885                	addi	a7,a7,1
 ce6:	0008879b          	sext.w	a5,a7
 cea:	02f5cc63          	blt	a1,a5,d22 <check_substr+0x78>
 cee:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 cf2:	011906b3          	add	a3,s2,a7
 cf6:	874e                	mv	a4,s3
 cf8:	879a                	mv	a5,t1
 cfa:	fe9053e3          	blez	s1,ce0 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 cfe:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 d02:	00074603          	lbu	a2,0(a4)
 d06:	fcc81de3          	bne	a6,a2,ce0 <check_substr+0x36>
        for (j = 0; j < M; j++)
 d0a:	2785                	addiw	a5,a5,1
 d0c:	0685                	addi	a3,a3,1
 d0e:	0705                	addi	a4,a4,1
 d10:	fef497e3          	bne	s1,a5,cfe <check_substr+0x54>
}
 d14:	70a2                	ld	ra,40(sp)
 d16:	7402                	ld	s0,32(sp)
 d18:	64e2                	ld	s1,24(sp)
 d1a:	6942                	ld	s2,16(sp)
 d1c:	69a2                	ld	s3,8(sp)
 d1e:	6145                	addi	sp,sp,48
 d20:	8082                	ret
    return -1;
 d22:	557d                	li	a0,-1
 d24:	bfc5                	j	d14 <check_substr+0x6a>

0000000000000d26 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 d26:	1141                	addi	sp,sp,-16
 d28:	e406                	sd	ra,8(sp)
 d2a:	e022                	sd	s0,0(sp)
 d2c:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 d2e:	fffff097          	auipc	ra,0xfffff
 d32:	72e080e7          	jalr	1838(ra) # 45c <open>
	return fd;
}
 d36:	60a2                	ld	ra,8(sp)
 d38:	6402                	ld	s0,0(sp)
 d3a:	0141                	addi	sp,sp,16
 d3c:	8082                	ret

0000000000000d3e <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 d3e:	7139                	addi	sp,sp,-64
 d40:	fc06                	sd	ra,56(sp)
 d42:	f822                	sd	s0,48(sp)
 d44:	f426                	sd	s1,40(sp)
 d46:	f04a                	sd	s2,32(sp)
 d48:	ec4e                	sd	s3,24(sp)
 d4a:	e852                	sd	s4,16(sp)
 d4c:	0080                	addi	s0,sp,64
 d4e:	89aa                	mv	s3,a0
 d50:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 d52:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 d54:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 d56:	4605                	li	a2,1
 d58:	fcf40593          	addi	a1,s0,-49
 d5c:	854e                	mv	a0,s3
 d5e:	fffff097          	auipc	ra,0xfffff
 d62:	6d6080e7          	jalr	1750(ra) # 434 <read>
		if (readStatus == 0){
 d66:	c505                	beqz	a0,d8e <read_line+0x50>
		*buffer++ = readByte;
 d68:	0485                	addi	s1,s1,1
 d6a:	fcf44783          	lbu	a5,-49(s0)
 d6e:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 d72:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 d74:	ff4791e3          	bne	a5,s4,d56 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 d78:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 d7c:	854a                	mv	a0,s2
 d7e:	70e2                	ld	ra,56(sp)
 d80:	7442                	ld	s0,48(sp)
 d82:	74a2                	ld	s1,40(sp)
 d84:	7902                	ld	s2,32(sp)
 d86:	69e2                	ld	s3,24(sp)
 d88:	6a42                	ld	s4,16(sp)
 d8a:	6121                	addi	sp,sp,64
 d8c:	8082                	ret
			if (byteCount!=0){
 d8e:	fe0907e3          	beqz	s2,d7c <read_line+0x3e>
				*buffer = '\n';
 d92:	47a9                	li	a5,10
 d94:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 d98:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 d9c:	2905                	addiw	s2,s2,1
 d9e:	bff9                	j	d7c <read_line+0x3e>

0000000000000da0 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 da0:	1141                	addi	sp,sp,-16
 da2:	e406                	sd	ra,8(sp)
 da4:	e022                	sd	s0,0(sp)
 da6:	0800                	addi	s0,sp,16
	close(fd);
 da8:	fffff097          	auipc	ra,0xfffff
 dac:	69c080e7          	jalr	1692(ra) # 444 <close>
}
 db0:	60a2                	ld	ra,8(sp)
 db2:	6402                	ld	s0,0(sp)
 db4:	0141                	addi	sp,sp,16
 db6:	8082                	ret

0000000000000db8 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 db8:	7139                	addi	sp,sp,-64
 dba:	fc06                	sd	ra,56(sp)
 dbc:	f822                	sd	s0,48(sp)
 dbe:	f426                	sd	s1,40(sp)
 dc0:	f04a                	sd	s2,32(sp)
 dc2:	0080                	addi	s0,sp,64
 dc4:	84aa                	mv	s1,a0
 dc6:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 dc8:	fffff097          	auipc	ra,0xfffff
 dcc:	64c080e7          	jalr	1612(ra) # 414 <fork>
 dd0:	ed19                	bnez	a0,dee <get_time_perf+0x36>
		exec(argv[0],argv);
 dd2:	85ca                	mv	a1,s2
 dd4:	00093503          	ld	a0,0(s2)
 dd8:	fffff097          	auipc	ra,0xfffff
 ddc:	67c080e7          	jalr	1660(ra) # 454 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 de0:	8526                	mv	a0,s1
 de2:	70e2                	ld	ra,56(sp)
 de4:	7442                	ld	s0,48(sp)
 de6:	74a2                	ld	s1,40(sp)
 de8:	7902                	ld	s2,32(sp)
 dea:	6121                	addi	sp,sp,64
 dec:	8082                	ret
		times(pid , &time);
 dee:	fc040593          	addi	a1,s0,-64
 df2:	fffff097          	auipc	ra,0xfffff
 df6:	6e2080e7          	jalr	1762(ra) # 4d4 <times>
		return time;
 dfa:	fc043783          	ld	a5,-64(s0)
 dfe:	e09c                	sd	a5,0(s1)
 e00:	fc843783          	ld	a5,-56(s0)
 e04:	e49c                	sd	a5,8(s1)
 e06:	fd043783          	ld	a5,-48(s0)
 e0a:	e89c                	sd	a5,16(s1)
 e0c:	fd843783          	ld	a5,-40(s0)
 e10:	ec9c                	sd	a5,24(s1)
 e12:	b7f9                	j	de0 <get_time_perf+0x28>
