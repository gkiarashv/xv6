
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	addi	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	0880                	addi	s0,sp,80
 130:	89aa                	mv	s3,a0
 132:	8b2e                	mv	s6,a1
  m = 0;
 134:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 136:	3ff00b93          	li	s7,1023
 13a:	00002a97          	auipc	s5,0x2
 13e:	ed6a8a93          	addi	s5,s5,-298 # 2010 <buf>
 142:	a0a1                	j	18a <grep+0x70>
      p = q+1;
 144:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 148:	45a9                	li	a1,10
 14a:	854a                	mv	a0,s2
 14c:	00000097          	auipc	ra,0x0
 150:	200080e7          	jalr	512(ra) # 34c <strchr>
 154:	84aa                	mv	s1,a0
 156:	c905                	beqz	a0,186 <grep+0x6c>
      *q = 0;
 158:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15c:	85ca                	mv	a1,s2
 15e:	854e                	mv	a0,s3
 160:	00000097          	auipc	ra,0x0
 164:	f6c080e7          	jalr	-148(ra) # cc <match>
 168:	dd71                	beqz	a0,144 <grep+0x2a>
        *q = '\n';
 16a:	47a9                	li	a5,10
 16c:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 170:	00148613          	addi	a2,s1,1
 174:	4126063b          	subw	a2,a2,s2
 178:	85ca                	mv	a1,s2
 17a:	4505                	li	a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	3c8080e7          	jalr	968(ra) # 544 <write>
 184:	b7c1                	j	144 <grep+0x2a>
    if(m > 0){
 186:	03404563          	bgtz	s4,1b0 <grep+0x96>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18a:	414b863b          	subw	a2,s7,s4
 18e:	014a85b3          	add	a1,s5,s4
 192:	855a                	mv	a0,s6
 194:	00000097          	auipc	ra,0x0
 198:	3a8080e7          	jalr	936(ra) # 53c <read>
 19c:	02a05663          	blez	a0,1c8 <grep+0xae>
    m += n;
 1a0:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 1a4:	014a87b3          	add	a5,s5,s4
 1a8:	00078023          	sb	zero,0(a5)
    p = buf;
 1ac:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1ae:	bf69                	j	148 <grep+0x2e>
      m -= p - buf;
 1b0:	415907b3          	sub	a5,s2,s5
 1b4:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 1b8:	8652                	mv	a2,s4
 1ba:	85ca                	mv	a1,s2
 1bc:	8556                	mv	a0,s5
 1be:	00000097          	auipc	ra,0x0
 1c2:	2b4080e7          	jalr	692(ra) # 472 <memmove>
 1c6:	b7d1                	j	18a <grep+0x70>
}
 1c8:	60a6                	ld	ra,72(sp)
 1ca:	6406                	ld	s0,64(sp)
 1cc:	74e2                	ld	s1,56(sp)
 1ce:	7942                	ld	s2,48(sp)
 1d0:	79a2                	ld	s3,40(sp)
 1d2:	7a02                	ld	s4,32(sp)
 1d4:	6ae2                	ld	s5,24(sp)
 1d6:	6b42                	ld	s6,16(sp)
 1d8:	6ba2                	ld	s7,8(sp)
 1da:	6161                	addi	sp,sp,80
 1dc:	8082                	ret

00000000000001de <main>:
{
 1de:	7139                	addi	sp,sp,-64
 1e0:	fc06                	sd	ra,56(sp)
 1e2:	f822                	sd	s0,48(sp)
 1e4:	f426                	sd	s1,40(sp)
 1e6:	f04a                	sd	s2,32(sp)
 1e8:	ec4e                	sd	s3,24(sp)
 1ea:	e852                	sd	s4,16(sp)
 1ec:	e456                	sd	s5,8(sp)
 1ee:	0080                	addi	s0,sp,64
  if(argc <= 1){
 1f0:	4785                	li	a5,1
 1f2:	04a7de63          	bge	a5,a0,24e <main+0x70>
  pattern = argv[1];
 1f6:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1fa:	4789                	li	a5,2
 1fc:	06a7d763          	bge	a5,a0,26a <main+0x8c>
 200:	01058913          	addi	s2,a1,16
 204:	ffd5099b          	addiw	s3,a0,-3
 208:	02099793          	slli	a5,s3,0x20
 20c:	01d7d993          	srli	s3,a5,0x1d
 210:	05e1                	addi	a1,a1,24
 212:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 214:	4581                	li	a1,0
 216:	00093503          	ld	a0,0(s2)
 21a:	00000097          	auipc	ra,0x0
 21e:	34a080e7          	jalr	842(ra) # 564 <open>
 222:	84aa                	mv	s1,a0
 224:	04054e63          	bltz	a0,280 <main+0xa2>
    grep(pattern, fd);
 228:	85aa                	mv	a1,a0
 22a:	8552                	mv	a0,s4
 22c:	00000097          	auipc	ra,0x0
 230:	eee080e7          	jalr	-274(ra) # 11a <grep>
    close(fd);
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	316080e7          	jalr	790(ra) # 54c <close>
  for(i = 2; i < argc; i++){
 23e:	0921                	addi	s2,s2,8
 240:	fd391ae3          	bne	s2,s3,214 <main+0x36>
  exit(0);
 244:	4501                	li	a0,0
 246:	00000097          	auipc	ra,0x0
 24a:	2de080e7          	jalr	734(ra) # 524 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 24e:	00001597          	auipc	a1,0x1
 252:	cd258593          	addi	a1,a1,-814 # f20 <get_time_perf+0x60>
 256:	4509                	li	a0,2
 258:	00000097          	auipc	ra,0x0
 25c:	658080e7          	jalr	1624(ra) # 8b0 <fprintf>
    exit(1);
 260:	4505                	li	a0,1
 262:	00000097          	auipc	ra,0x0
 266:	2c2080e7          	jalr	706(ra) # 524 <exit>
    grep(pattern, 0);
 26a:	4581                	li	a1,0
 26c:	8552                	mv	a0,s4
 26e:	00000097          	auipc	ra,0x0
 272:	eac080e7          	jalr	-340(ra) # 11a <grep>
    exit(0);
 276:	4501                	li	a0,0
 278:	00000097          	auipc	ra,0x0
 27c:	2ac080e7          	jalr	684(ra) # 524 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 280:	00093583          	ld	a1,0(s2)
 284:	00001517          	auipc	a0,0x1
 288:	cbc50513          	addi	a0,a0,-836 # f40 <get_time_perf+0x80>
 28c:	00000097          	auipc	ra,0x0
 290:	652080e7          	jalr	1618(ra) # 8de <printf>
      exit(1);
 294:	4505                	li	a0,1
 296:	00000097          	auipc	ra,0x0
 29a:	28e080e7          	jalr	654(ra) # 524 <exit>

000000000000029e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2a6:	00000097          	auipc	ra,0x0
 2aa:	f38080e7          	jalr	-200(ra) # 1de <main>
  exit(0);
 2ae:	4501                	li	a0,0
 2b0:	00000097          	auipc	ra,0x0
 2b4:	274080e7          	jalr	628(ra) # 524 <exit>

00000000000002b8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2be:	87aa                	mv	a5,a0
 2c0:	0585                	addi	a1,a1,1
 2c2:	0785                	addi	a5,a5,1
 2c4:	fff5c703          	lbu	a4,-1(a1)
 2c8:	fee78fa3          	sb	a4,-1(a5)
 2cc:	fb75                	bnez	a4,2c0 <strcpy+0x8>
    ;
  return os;
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret

00000000000002d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2da:	00054783          	lbu	a5,0(a0)
 2de:	cb91                	beqz	a5,2f2 <strcmp+0x1e>
 2e0:	0005c703          	lbu	a4,0(a1)
 2e4:	00f71763          	bne	a4,a5,2f2 <strcmp+0x1e>
    p++, q++;
 2e8:	0505                	addi	a0,a0,1
 2ea:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	fbe5                	bnez	a5,2e0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2f2:	0005c503          	lbu	a0,0(a1)
}
 2f6:	40a7853b          	subw	a0,a5,a0
 2fa:	6422                	ld	s0,8(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <strlen>:

uint
strlen(const char *s)
{
 300:	1141                	addi	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 306:	00054783          	lbu	a5,0(a0)
 30a:	cf91                	beqz	a5,326 <strlen+0x26>
 30c:	0505                	addi	a0,a0,1
 30e:	87aa                	mv	a5,a0
 310:	4685                	li	a3,1
 312:	9e89                	subw	a3,a3,a0
 314:	00f6853b          	addw	a0,a3,a5
 318:	0785                	addi	a5,a5,1
 31a:	fff7c703          	lbu	a4,-1(a5)
 31e:	fb7d                	bnez	a4,314 <strlen+0x14>
    ;
  return n;
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  for(n = 0; s[n]; n++)
 326:	4501                	li	a0,0
 328:	bfe5                	j	320 <strlen+0x20>

000000000000032a <memset>:

void*
memset(void *dst, int c, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e422                	sd	s0,8(sp)
 32e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 330:	ca19                	beqz	a2,346 <memset+0x1c>
 332:	87aa                	mv	a5,a0
 334:	1602                	slli	a2,a2,0x20
 336:	9201                	srli	a2,a2,0x20
 338:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 33c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 340:	0785                	addi	a5,a5,1
 342:	fee79de3          	bne	a5,a4,33c <memset+0x12>
  }
  return dst;
}
 346:	6422                	ld	s0,8(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret

000000000000034c <strchr>:

char*
strchr(const char *s, char c)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  for(; *s; s++)
 352:	00054783          	lbu	a5,0(a0)
 356:	cb99                	beqz	a5,36c <strchr+0x20>
    if(*s == c)
 358:	00f58763          	beq	a1,a5,366 <strchr+0x1a>
  for(; *s; s++)
 35c:	0505                	addi	a0,a0,1
 35e:	00054783          	lbu	a5,0(a0)
 362:	fbfd                	bnez	a5,358 <strchr+0xc>
      return (char*)s;
  return 0;
 364:	4501                	li	a0,0
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
  return 0;
 36c:	4501                	li	a0,0
 36e:	bfe5                	j	366 <strchr+0x1a>

0000000000000370 <gets>:

char*
gets(char *buf, int max)
{
 370:	711d                	addi	sp,sp,-96
 372:	ec86                	sd	ra,88(sp)
 374:	e8a2                	sd	s0,80(sp)
 376:	e4a6                	sd	s1,72(sp)
 378:	e0ca                	sd	s2,64(sp)
 37a:	fc4e                	sd	s3,56(sp)
 37c:	f852                	sd	s4,48(sp)
 37e:	f456                	sd	s5,40(sp)
 380:	f05a                	sd	s6,32(sp)
 382:	ec5e                	sd	s7,24(sp)
 384:	1080                	addi	s0,sp,96
 386:	8baa                	mv	s7,a0
 388:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 38a:	892a                	mv	s2,a0
 38c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 38e:	4aa9                	li	s5,10
 390:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 392:	89a6                	mv	s3,s1
 394:	2485                	addiw	s1,s1,1
 396:	0344d863          	bge	s1,s4,3c6 <gets+0x56>
    cc = read(0, &c, 1);
 39a:	4605                	li	a2,1
 39c:	faf40593          	addi	a1,s0,-81
 3a0:	4501                	li	a0,0
 3a2:	00000097          	auipc	ra,0x0
 3a6:	19a080e7          	jalr	410(ra) # 53c <read>
    if(cc < 1)
 3aa:	00a05e63          	blez	a0,3c6 <gets+0x56>
    buf[i++] = c;
 3ae:	faf44783          	lbu	a5,-81(s0)
 3b2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b6:	01578763          	beq	a5,s5,3c4 <gets+0x54>
 3ba:	0905                	addi	s2,s2,1
 3bc:	fd679be3          	bne	a5,s6,392 <gets+0x22>
  for(i=0; i+1 < max; ){
 3c0:	89a6                	mv	s3,s1
 3c2:	a011                	j	3c6 <gets+0x56>
 3c4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3c6:	99de                	add	s3,s3,s7
 3c8:	00098023          	sb	zero,0(s3)
  return buf;
}
 3cc:	855e                	mv	a0,s7
 3ce:	60e6                	ld	ra,88(sp)
 3d0:	6446                	ld	s0,80(sp)
 3d2:	64a6                	ld	s1,72(sp)
 3d4:	6906                	ld	s2,64(sp)
 3d6:	79e2                	ld	s3,56(sp)
 3d8:	7a42                	ld	s4,48(sp)
 3da:	7aa2                	ld	s5,40(sp)
 3dc:	7b02                	ld	s6,32(sp)
 3de:	6be2                	ld	s7,24(sp)
 3e0:	6125                	addi	sp,sp,96
 3e2:	8082                	ret

00000000000003e4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e4:	1101                	addi	sp,sp,-32
 3e6:	ec06                	sd	ra,24(sp)
 3e8:	e822                	sd	s0,16(sp)
 3ea:	e426                	sd	s1,8(sp)
 3ec:	e04a                	sd	s2,0(sp)
 3ee:	1000                	addi	s0,sp,32
 3f0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f2:	4581                	li	a1,0
 3f4:	00000097          	auipc	ra,0x0
 3f8:	170080e7          	jalr	368(ra) # 564 <open>
  if(fd < 0)
 3fc:	02054563          	bltz	a0,426 <stat+0x42>
 400:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 402:	85ca                	mv	a1,s2
 404:	00000097          	auipc	ra,0x0
 408:	178080e7          	jalr	376(ra) # 57c <fstat>
 40c:	892a                	mv	s2,a0
  close(fd);
 40e:	8526                	mv	a0,s1
 410:	00000097          	auipc	ra,0x0
 414:	13c080e7          	jalr	316(ra) # 54c <close>
  return r;
}
 418:	854a                	mv	a0,s2
 41a:	60e2                	ld	ra,24(sp)
 41c:	6442                	ld	s0,16(sp)
 41e:	64a2                	ld	s1,8(sp)
 420:	6902                	ld	s2,0(sp)
 422:	6105                	addi	sp,sp,32
 424:	8082                	ret
    return -1;
 426:	597d                	li	s2,-1
 428:	bfc5                	j	418 <stat+0x34>

000000000000042a <atoi>:

int
atoi(const char *s)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e422                	sd	s0,8(sp)
 42e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 430:	00054683          	lbu	a3,0(a0)
 434:	fd06879b          	addiw	a5,a3,-48
 438:	0ff7f793          	zext.b	a5,a5
 43c:	4625                	li	a2,9
 43e:	02f66863          	bltu	a2,a5,46e <atoi+0x44>
 442:	872a                	mv	a4,a0
  n = 0;
 444:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 446:	0705                	addi	a4,a4,1
 448:	0025179b          	slliw	a5,a0,0x2
 44c:	9fa9                	addw	a5,a5,a0
 44e:	0017979b          	slliw	a5,a5,0x1
 452:	9fb5                	addw	a5,a5,a3
 454:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 458:	00074683          	lbu	a3,0(a4)
 45c:	fd06879b          	addiw	a5,a3,-48
 460:	0ff7f793          	zext.b	a5,a5
 464:	fef671e3          	bgeu	a2,a5,446 <atoi+0x1c>
  return n;
}
 468:	6422                	ld	s0,8(sp)
 46a:	0141                	addi	sp,sp,16
 46c:	8082                	ret
  n = 0;
 46e:	4501                	li	a0,0
 470:	bfe5                	j	468 <atoi+0x3e>

0000000000000472 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 472:	1141                	addi	sp,sp,-16
 474:	e422                	sd	s0,8(sp)
 476:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 478:	02b57463          	bgeu	a0,a1,4a0 <memmove+0x2e>
    while(n-- > 0)
 47c:	00c05f63          	blez	a2,49a <memmove+0x28>
 480:	1602                	slli	a2,a2,0x20
 482:	9201                	srli	a2,a2,0x20
 484:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 488:	872a                	mv	a4,a0
      *dst++ = *src++;
 48a:	0585                	addi	a1,a1,1
 48c:	0705                	addi	a4,a4,1
 48e:	fff5c683          	lbu	a3,-1(a1)
 492:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 496:	fee79ae3          	bne	a5,a4,48a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 49a:	6422                	ld	s0,8(sp)
 49c:	0141                	addi	sp,sp,16
 49e:	8082                	ret
    dst += n;
 4a0:	00c50733          	add	a4,a0,a2
    src += n;
 4a4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4a6:	fec05ae3          	blez	a2,49a <memmove+0x28>
 4aa:	fff6079b          	addiw	a5,a2,-1
 4ae:	1782                	slli	a5,a5,0x20
 4b0:	9381                	srli	a5,a5,0x20
 4b2:	fff7c793          	not	a5,a5
 4b6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4b8:	15fd                	addi	a1,a1,-1
 4ba:	177d                	addi	a4,a4,-1
 4bc:	0005c683          	lbu	a3,0(a1)
 4c0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4c4:	fee79ae3          	bne	a5,a4,4b8 <memmove+0x46>
 4c8:	bfc9                	j	49a <memmove+0x28>

00000000000004ca <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ca:	1141                	addi	sp,sp,-16
 4cc:	e422                	sd	s0,8(sp)
 4ce:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4d0:	ca05                	beqz	a2,500 <memcmp+0x36>
 4d2:	fff6069b          	addiw	a3,a2,-1
 4d6:	1682                	slli	a3,a3,0x20
 4d8:	9281                	srli	a3,a3,0x20
 4da:	0685                	addi	a3,a3,1
 4dc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4de:	00054783          	lbu	a5,0(a0)
 4e2:	0005c703          	lbu	a4,0(a1)
 4e6:	00e79863          	bne	a5,a4,4f6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4ea:	0505                	addi	a0,a0,1
    p2++;
 4ec:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ee:	fed518e3          	bne	a0,a3,4de <memcmp+0x14>
  }
  return 0;
 4f2:	4501                	li	a0,0
 4f4:	a019                	j	4fa <memcmp+0x30>
      return *p1 - *p2;
 4f6:	40e7853b          	subw	a0,a5,a4
}
 4fa:	6422                	ld	s0,8(sp)
 4fc:	0141                	addi	sp,sp,16
 4fe:	8082                	ret
  return 0;
 500:	4501                	li	a0,0
 502:	bfe5                	j	4fa <memcmp+0x30>

0000000000000504 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 504:	1141                	addi	sp,sp,-16
 506:	e406                	sd	ra,8(sp)
 508:	e022                	sd	s0,0(sp)
 50a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 50c:	00000097          	auipc	ra,0x0
 510:	f66080e7          	jalr	-154(ra) # 472 <memmove>
}
 514:	60a2                	ld	ra,8(sp)
 516:	6402                	ld	s0,0(sp)
 518:	0141                	addi	sp,sp,16
 51a:	8082                	ret

000000000000051c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 51c:	4885                	li	a7,1
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <exit>:
.global exit
exit:
 li a7, SYS_exit
 524:	4889                	li	a7,2
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <wait>:
.global wait
wait:
 li a7, SYS_wait
 52c:	488d                	li	a7,3
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 534:	4891                	li	a7,4
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <read>:
.global read
read:
 li a7, SYS_read
 53c:	4895                	li	a7,5
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <write>:
.global write
write:
 li a7, SYS_write
 544:	48c1                	li	a7,16
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <close>:
.global close
close:
 li a7, SYS_close
 54c:	48d5                	li	a7,21
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <kill>:
.global kill
kill:
 li a7, SYS_kill
 554:	4899                	li	a7,6
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <exec>:
.global exec
exec:
 li a7, SYS_exec
 55c:	489d                	li	a7,7
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <open>:
.global open
open:
 li a7, SYS_open
 564:	48bd                	li	a7,15
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 56c:	48c5                	li	a7,17
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 574:	48c9                	li	a7,18
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 57c:	48a1                	li	a7,8
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <link>:
.global link
link:
 li a7, SYS_link
 584:	48cd                	li	a7,19
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 58c:	48d1                	li	a7,20
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 594:	48a5                	li	a7,9
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <dup>:
.global dup
dup:
 li a7, SYS_dup
 59c:	48a9                	li	a7,10
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a4:	48ad                	li	a7,11
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ac:	48b1                	li	a7,12
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b4:	48b5                	li	a7,13
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5bc:	48b9                	li	a7,14
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <head>:
.global head
head:
 li a7, SYS_head
 5c4:	48d9                	li	a7,22
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 5cc:	48dd                	li	a7,23
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <ps>:
.global ps
ps:
 li a7, SYS_ps
 5d4:	48e1                	li	a7,24
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <times>:
.global times
times:
 li a7, SYS_times
 5dc:	48e5                	li	a7,25
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 5e4:	48e9                	li	a7,26
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 5ec:	48ed                	li	a7,27
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 5f4:	48f1                	li	a7,28
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 5fc:	48f5                	li	a7,29
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 604:	1101                	addi	sp,sp,-32
 606:	ec06                	sd	ra,24(sp)
 608:	e822                	sd	s0,16(sp)
 60a:	1000                	addi	s0,sp,32
 60c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 610:	4605                	li	a2,1
 612:	fef40593          	addi	a1,s0,-17
 616:	00000097          	auipc	ra,0x0
 61a:	f2e080e7          	jalr	-210(ra) # 544 <write>
}
 61e:	60e2                	ld	ra,24(sp)
 620:	6442                	ld	s0,16(sp)
 622:	6105                	addi	sp,sp,32
 624:	8082                	ret

0000000000000626 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 626:	7139                	addi	sp,sp,-64
 628:	fc06                	sd	ra,56(sp)
 62a:	f822                	sd	s0,48(sp)
 62c:	f426                	sd	s1,40(sp)
 62e:	f04a                	sd	s2,32(sp)
 630:	ec4e                	sd	s3,24(sp)
 632:	0080                	addi	s0,sp,64
 634:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 636:	c299                	beqz	a3,63c <printint+0x16>
 638:	0805c963          	bltz	a1,6ca <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 63c:	2581                	sext.w	a1,a1
  neg = 0;
 63e:	4881                	li	a7,0
 640:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 644:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 646:	2601                	sext.w	a2,a2
 648:	00001517          	auipc	a0,0x1
 64c:	97050513          	addi	a0,a0,-1680 # fb8 <digits>
 650:	883a                	mv	a6,a4
 652:	2705                	addiw	a4,a4,1
 654:	02c5f7bb          	remuw	a5,a1,a2
 658:	1782                	slli	a5,a5,0x20
 65a:	9381                	srli	a5,a5,0x20
 65c:	97aa                	add	a5,a5,a0
 65e:	0007c783          	lbu	a5,0(a5)
 662:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 666:	0005879b          	sext.w	a5,a1
 66a:	02c5d5bb          	divuw	a1,a1,a2
 66e:	0685                	addi	a3,a3,1
 670:	fec7f0e3          	bgeu	a5,a2,650 <printint+0x2a>
  if(neg)
 674:	00088c63          	beqz	a7,68c <printint+0x66>
    buf[i++] = '-';
 678:	fd070793          	addi	a5,a4,-48
 67c:	00878733          	add	a4,a5,s0
 680:	02d00793          	li	a5,45
 684:	fef70823          	sb	a5,-16(a4)
 688:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 68c:	02e05863          	blez	a4,6bc <printint+0x96>
 690:	fc040793          	addi	a5,s0,-64
 694:	00e78933          	add	s2,a5,a4
 698:	fff78993          	addi	s3,a5,-1
 69c:	99ba                	add	s3,s3,a4
 69e:	377d                	addiw	a4,a4,-1
 6a0:	1702                	slli	a4,a4,0x20
 6a2:	9301                	srli	a4,a4,0x20
 6a4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6a8:	fff94583          	lbu	a1,-1(s2)
 6ac:	8526                	mv	a0,s1
 6ae:	00000097          	auipc	ra,0x0
 6b2:	f56080e7          	jalr	-170(ra) # 604 <putc>
  while(--i >= 0)
 6b6:	197d                	addi	s2,s2,-1
 6b8:	ff3918e3          	bne	s2,s3,6a8 <printint+0x82>
}
 6bc:	70e2                	ld	ra,56(sp)
 6be:	7442                	ld	s0,48(sp)
 6c0:	74a2                	ld	s1,40(sp)
 6c2:	7902                	ld	s2,32(sp)
 6c4:	69e2                	ld	s3,24(sp)
 6c6:	6121                	addi	sp,sp,64
 6c8:	8082                	ret
    x = -xx;
 6ca:	40b005bb          	negw	a1,a1
    neg = 1;
 6ce:	4885                	li	a7,1
    x = -xx;
 6d0:	bf85                	j	640 <printint+0x1a>

00000000000006d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6d2:	7119                	addi	sp,sp,-128
 6d4:	fc86                	sd	ra,120(sp)
 6d6:	f8a2                	sd	s0,112(sp)
 6d8:	f4a6                	sd	s1,104(sp)
 6da:	f0ca                	sd	s2,96(sp)
 6dc:	ecce                	sd	s3,88(sp)
 6de:	e8d2                	sd	s4,80(sp)
 6e0:	e4d6                	sd	s5,72(sp)
 6e2:	e0da                	sd	s6,64(sp)
 6e4:	fc5e                	sd	s7,56(sp)
 6e6:	f862                	sd	s8,48(sp)
 6e8:	f466                	sd	s9,40(sp)
 6ea:	f06a                	sd	s10,32(sp)
 6ec:	ec6e                	sd	s11,24(sp)
 6ee:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6f0:	0005c903          	lbu	s2,0(a1)
 6f4:	18090f63          	beqz	s2,892 <vprintf+0x1c0>
 6f8:	8aaa                	mv	s5,a0
 6fa:	8b32                	mv	s6,a2
 6fc:	00158493          	addi	s1,a1,1
  state = 0;
 700:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 702:	02500a13          	li	s4,37
 706:	4c55                	li	s8,21
 708:	00001c97          	auipc	s9,0x1
 70c:	858c8c93          	addi	s9,s9,-1960 # f60 <get_time_perf+0xa0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 710:	02800d93          	li	s11,40
  putc(fd, 'x');
 714:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 716:	00001b97          	auipc	s7,0x1
 71a:	8a2b8b93          	addi	s7,s7,-1886 # fb8 <digits>
 71e:	a839                	j	73c <vprintf+0x6a>
        putc(fd, c);
 720:	85ca                	mv	a1,s2
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	ee0080e7          	jalr	-288(ra) # 604 <putc>
 72c:	a019                	j	732 <vprintf+0x60>
    } else if(state == '%'){
 72e:	01498d63          	beq	s3,s4,748 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 732:	0485                	addi	s1,s1,1
 734:	fff4c903          	lbu	s2,-1(s1)
 738:	14090d63          	beqz	s2,892 <vprintf+0x1c0>
    if(state == 0){
 73c:	fe0999e3          	bnez	s3,72e <vprintf+0x5c>
      if(c == '%'){
 740:	ff4910e3          	bne	s2,s4,720 <vprintf+0x4e>
        state = '%';
 744:	89d2                	mv	s3,s4
 746:	b7f5                	j	732 <vprintf+0x60>
      if(c == 'd'){
 748:	11490c63          	beq	s2,s4,860 <vprintf+0x18e>
 74c:	f9d9079b          	addiw	a5,s2,-99
 750:	0ff7f793          	zext.b	a5,a5
 754:	10fc6e63          	bltu	s8,a5,870 <vprintf+0x19e>
 758:	f9d9079b          	addiw	a5,s2,-99
 75c:	0ff7f713          	zext.b	a4,a5
 760:	10ec6863          	bltu	s8,a4,870 <vprintf+0x19e>
 764:	00271793          	slli	a5,a4,0x2
 768:	97e6                	add	a5,a5,s9
 76a:	439c                	lw	a5,0(a5)
 76c:	97e6                	add	a5,a5,s9
 76e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 770:	008b0913          	addi	s2,s6,8
 774:	4685                	li	a3,1
 776:	4629                	li	a2,10
 778:	000b2583          	lw	a1,0(s6)
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	ea8080e7          	jalr	-344(ra) # 626 <printint>
 786:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 788:	4981                	li	s3,0
 78a:	b765                	j	732 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 78c:	008b0913          	addi	s2,s6,8
 790:	4681                	li	a3,0
 792:	4629                	li	a2,10
 794:	000b2583          	lw	a1,0(s6)
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	e8c080e7          	jalr	-372(ra) # 626 <printint>
 7a2:	8b4a                	mv	s6,s2
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b771                	j	732 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7a8:	008b0913          	addi	s2,s6,8
 7ac:	4681                	li	a3,0
 7ae:	866a                	mv	a2,s10
 7b0:	000b2583          	lw	a1,0(s6)
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	e70080e7          	jalr	-400(ra) # 626 <printint>
 7be:	8b4a                	mv	s6,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	bf85                	j	732 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7c4:	008b0793          	addi	a5,s6,8
 7c8:	f8f43423          	sd	a5,-120(s0)
 7cc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7d0:	03000593          	li	a1,48
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	e2e080e7          	jalr	-466(ra) # 604 <putc>
  putc(fd, 'x');
 7de:	07800593          	li	a1,120
 7e2:	8556                	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	e20080e7          	jalr	-480(ra) # 604 <putc>
 7ec:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ee:	03c9d793          	srli	a5,s3,0x3c
 7f2:	97de                	add	a5,a5,s7
 7f4:	0007c583          	lbu	a1,0(a5)
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	e0a080e7          	jalr	-502(ra) # 604 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 802:	0992                	slli	s3,s3,0x4
 804:	397d                	addiw	s2,s2,-1
 806:	fe0914e3          	bnez	s2,7ee <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 80a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 80e:	4981                	li	s3,0
 810:	b70d                	j	732 <vprintf+0x60>
        s = va_arg(ap, char*);
 812:	008b0913          	addi	s2,s6,8
 816:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 81a:	02098163          	beqz	s3,83c <vprintf+0x16a>
        while(*s != 0){
 81e:	0009c583          	lbu	a1,0(s3)
 822:	c5ad                	beqz	a1,88c <vprintf+0x1ba>
          putc(fd, *s);
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	dde080e7          	jalr	-546(ra) # 604 <putc>
          s++;
 82e:	0985                	addi	s3,s3,1
        while(*s != 0){
 830:	0009c583          	lbu	a1,0(s3)
 834:	f9e5                	bnez	a1,824 <vprintf+0x152>
        s = va_arg(ap, char*);
 836:	8b4a                	mv	s6,s2
      state = 0;
 838:	4981                	li	s3,0
 83a:	bde5                	j	732 <vprintf+0x60>
          s = "(null)";
 83c:	00000997          	auipc	s3,0x0
 840:	71c98993          	addi	s3,s3,1820 # f58 <get_time_perf+0x98>
        while(*s != 0){
 844:	85ee                	mv	a1,s11
 846:	bff9                	j	824 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 848:	008b0913          	addi	s2,s6,8
 84c:	000b4583          	lbu	a1,0(s6)
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	db2080e7          	jalr	-590(ra) # 604 <putc>
 85a:	8b4a                	mv	s6,s2
      state = 0;
 85c:	4981                	li	s3,0
 85e:	bdd1                	j	732 <vprintf+0x60>
        putc(fd, c);
 860:	85d2                	mv	a1,s4
 862:	8556                	mv	a0,s5
 864:	00000097          	auipc	ra,0x0
 868:	da0080e7          	jalr	-608(ra) # 604 <putc>
      state = 0;
 86c:	4981                	li	s3,0
 86e:	b5d1                	j	732 <vprintf+0x60>
        putc(fd, '%');
 870:	85d2                	mv	a1,s4
 872:	8556                	mv	a0,s5
 874:	00000097          	auipc	ra,0x0
 878:	d90080e7          	jalr	-624(ra) # 604 <putc>
        putc(fd, c);
 87c:	85ca                	mv	a1,s2
 87e:	8556                	mv	a0,s5
 880:	00000097          	auipc	ra,0x0
 884:	d84080e7          	jalr	-636(ra) # 604 <putc>
      state = 0;
 888:	4981                	li	s3,0
 88a:	b565                	j	732 <vprintf+0x60>
        s = va_arg(ap, char*);
 88c:	8b4a                	mv	s6,s2
      state = 0;
 88e:	4981                	li	s3,0
 890:	b54d                	j	732 <vprintf+0x60>
    }
  }
}
 892:	70e6                	ld	ra,120(sp)
 894:	7446                	ld	s0,112(sp)
 896:	74a6                	ld	s1,104(sp)
 898:	7906                	ld	s2,96(sp)
 89a:	69e6                	ld	s3,88(sp)
 89c:	6a46                	ld	s4,80(sp)
 89e:	6aa6                	ld	s5,72(sp)
 8a0:	6b06                	ld	s6,64(sp)
 8a2:	7be2                	ld	s7,56(sp)
 8a4:	7c42                	ld	s8,48(sp)
 8a6:	7ca2                	ld	s9,40(sp)
 8a8:	7d02                	ld	s10,32(sp)
 8aa:	6de2                	ld	s11,24(sp)
 8ac:	6109                	addi	sp,sp,128
 8ae:	8082                	ret

00000000000008b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b0:	715d                	addi	sp,sp,-80
 8b2:	ec06                	sd	ra,24(sp)
 8b4:	e822                	sd	s0,16(sp)
 8b6:	1000                	addi	s0,sp,32
 8b8:	e010                	sd	a2,0(s0)
 8ba:	e414                	sd	a3,8(s0)
 8bc:	e818                	sd	a4,16(s0)
 8be:	ec1c                	sd	a5,24(s0)
 8c0:	03043023          	sd	a6,32(s0)
 8c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8cc:	8622                	mv	a2,s0
 8ce:	00000097          	auipc	ra,0x0
 8d2:	e04080e7          	jalr	-508(ra) # 6d2 <vprintf>
}
 8d6:	60e2                	ld	ra,24(sp)
 8d8:	6442                	ld	s0,16(sp)
 8da:	6161                	addi	sp,sp,80
 8dc:	8082                	ret

00000000000008de <printf>:

void
printf(const char *fmt, ...)
{
 8de:	711d                	addi	sp,sp,-96
 8e0:	ec06                	sd	ra,24(sp)
 8e2:	e822                	sd	s0,16(sp)
 8e4:	1000                	addi	s0,sp,32
 8e6:	e40c                	sd	a1,8(s0)
 8e8:	e810                	sd	a2,16(s0)
 8ea:	ec14                	sd	a3,24(s0)
 8ec:	f018                	sd	a4,32(s0)
 8ee:	f41c                	sd	a5,40(s0)
 8f0:	03043823          	sd	a6,48(s0)
 8f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f8:	00840613          	addi	a2,s0,8
 8fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 900:	85aa                	mv	a1,a0
 902:	4505                	li	a0,1
 904:	00000097          	auipc	ra,0x0
 908:	dce080e7          	jalr	-562(ra) # 6d2 <vprintf>
}
 90c:	60e2                	ld	ra,24(sp)
 90e:	6442                	ld	s0,16(sp)
 910:	6125                	addi	sp,sp,96
 912:	8082                	ret

0000000000000914 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 914:	1141                	addi	sp,sp,-16
 916:	e422                	sd	s0,8(sp)
 918:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 91a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91e:	00001797          	auipc	a5,0x1
 922:	6e27b783          	ld	a5,1762(a5) # 2000 <freep>
 926:	a02d                	j	950 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 928:	4618                	lw	a4,8(a2)
 92a:	9f2d                	addw	a4,a4,a1
 92c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 930:	6398                	ld	a4,0(a5)
 932:	6310                	ld	a2,0(a4)
 934:	a83d                	j	972 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 936:	ff852703          	lw	a4,-8(a0)
 93a:	9f31                	addw	a4,a4,a2
 93c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 93e:	ff053683          	ld	a3,-16(a0)
 942:	a091                	j	986 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 944:	6398                	ld	a4,0(a5)
 946:	00e7e463          	bltu	a5,a4,94e <free+0x3a>
 94a:	00e6ea63          	bltu	a3,a4,95e <free+0x4a>
{
 94e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 950:	fed7fae3          	bgeu	a5,a3,944 <free+0x30>
 954:	6398                	ld	a4,0(a5)
 956:	00e6e463          	bltu	a3,a4,95e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95a:	fee7eae3          	bltu	a5,a4,94e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 95e:	ff852583          	lw	a1,-8(a0)
 962:	6390                	ld	a2,0(a5)
 964:	02059813          	slli	a6,a1,0x20
 968:	01c85713          	srli	a4,a6,0x1c
 96c:	9736                	add	a4,a4,a3
 96e:	fae60de3          	beq	a2,a4,928 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 972:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 976:	4790                	lw	a2,8(a5)
 978:	02061593          	slli	a1,a2,0x20
 97c:	01c5d713          	srli	a4,a1,0x1c
 980:	973e                	add	a4,a4,a5
 982:	fae68ae3          	beq	a3,a4,936 <free+0x22>
    p->s.ptr = bp->s.ptr;
 986:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 988:	00001717          	auipc	a4,0x1
 98c:	66f73c23          	sd	a5,1656(a4) # 2000 <freep>
}
 990:	6422                	ld	s0,8(sp)
 992:	0141                	addi	sp,sp,16
 994:	8082                	ret

0000000000000996 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 996:	7139                	addi	sp,sp,-64
 998:	fc06                	sd	ra,56(sp)
 99a:	f822                	sd	s0,48(sp)
 99c:	f426                	sd	s1,40(sp)
 99e:	f04a                	sd	s2,32(sp)
 9a0:	ec4e                	sd	s3,24(sp)
 9a2:	e852                	sd	s4,16(sp)
 9a4:	e456                	sd	s5,8(sp)
 9a6:	e05a                	sd	s6,0(sp)
 9a8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9aa:	02051493          	slli	s1,a0,0x20
 9ae:	9081                	srli	s1,s1,0x20
 9b0:	04bd                	addi	s1,s1,15
 9b2:	8091                	srli	s1,s1,0x4
 9b4:	0014899b          	addiw	s3,s1,1
 9b8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9ba:	00001517          	auipc	a0,0x1
 9be:	64653503          	ld	a0,1606(a0) # 2000 <freep>
 9c2:	c515                	beqz	a0,9ee <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c6:	4798                	lw	a4,8(a5)
 9c8:	02977f63          	bgeu	a4,s1,a06 <malloc+0x70>
 9cc:	8a4e                	mv	s4,s3
 9ce:	0009871b          	sext.w	a4,s3
 9d2:	6685                	lui	a3,0x1
 9d4:	00d77363          	bgeu	a4,a3,9da <malloc+0x44>
 9d8:	6a05                	lui	s4,0x1
 9da:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9de:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9e2:	00001917          	auipc	s2,0x1
 9e6:	61e90913          	addi	s2,s2,1566 # 2000 <freep>
  if(p == (char*)-1)
 9ea:	5afd                	li	s5,-1
 9ec:	a895                	j	a60 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9ee:	00002797          	auipc	a5,0x2
 9f2:	a2278793          	addi	a5,a5,-1502 # 2410 <base>
 9f6:	00001717          	auipc	a4,0x1
 9fa:	60f73523          	sd	a5,1546(a4) # 2000 <freep>
 9fe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a00:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a04:	b7e1                	j	9cc <malloc+0x36>
      if(p->s.size == nunits)
 a06:	02e48c63          	beq	s1,a4,a3e <malloc+0xa8>
        p->s.size -= nunits;
 a0a:	4137073b          	subw	a4,a4,s3
 a0e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a10:	02071693          	slli	a3,a4,0x20
 a14:	01c6d713          	srli	a4,a3,0x1c
 a18:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a1a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a1e:	00001717          	auipc	a4,0x1
 a22:	5ea73123          	sd	a0,1506(a4) # 2000 <freep>
      return (void*)(p + 1);
 a26:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a2a:	70e2                	ld	ra,56(sp)
 a2c:	7442                	ld	s0,48(sp)
 a2e:	74a2                	ld	s1,40(sp)
 a30:	7902                	ld	s2,32(sp)
 a32:	69e2                	ld	s3,24(sp)
 a34:	6a42                	ld	s4,16(sp)
 a36:	6aa2                	ld	s5,8(sp)
 a38:	6b02                	ld	s6,0(sp)
 a3a:	6121                	addi	sp,sp,64
 a3c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a3e:	6398                	ld	a4,0(a5)
 a40:	e118                	sd	a4,0(a0)
 a42:	bff1                	j	a1e <malloc+0x88>
  hp->s.size = nu;
 a44:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a48:	0541                	addi	a0,a0,16
 a4a:	00000097          	auipc	ra,0x0
 a4e:	eca080e7          	jalr	-310(ra) # 914 <free>
  return freep;
 a52:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a56:	d971                	beqz	a0,a2a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a58:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a5a:	4798                	lw	a4,8(a5)
 a5c:	fa9775e3          	bgeu	a4,s1,a06 <malloc+0x70>
    if(p == freep)
 a60:	00093703          	ld	a4,0(s2)
 a64:	853e                	mv	a0,a5
 a66:	fef719e3          	bne	a4,a5,a58 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a6a:	8552                	mv	a0,s4
 a6c:	00000097          	auipc	ra,0x0
 a70:	b40080e7          	jalr	-1216(ra) # 5ac <sbrk>
  if(p == (char*)-1)
 a74:	fd5518e3          	bne	a0,s5,a44 <malloc+0xae>
        return 0;
 a78:	4501                	li	a0,0
 a7a:	bf45                	j	a2a <malloc+0x94>

0000000000000a7c <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 a7c:	c1d9                	beqz	a1,b02 <head_run+0x86>
void head_run(int fd, int numOfLines){
 a7e:	dd010113          	addi	sp,sp,-560
 a82:	22113423          	sd	ra,552(sp)
 a86:	22813023          	sd	s0,544(sp)
 a8a:	20913c23          	sd	s1,536(sp)
 a8e:	21213823          	sd	s2,528(sp)
 a92:	21313423          	sd	s3,520(sp)
 a96:	21413023          	sd	s4,512(sp)
 a9a:	1c00                	addi	s0,sp,560
 a9c:	892a                	mv	s2,a0
 a9e:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 aa2:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 aa4:	00000a17          	auipc	s4,0x0
 aa8:	554a0a13          	addi	s4,s4,1364 # ff8 <digits+0x40>
		readStatus = read_line(fd, line);
 aac:	dd840593          	addi	a1,s0,-552
 ab0:	854a                	mv	a0,s2
 ab2:	00000097          	auipc	ra,0x0
 ab6:	394080e7          	jalr	916(ra) # e46 <read_line>
		if (readStatus == READ_ERROR){
 aba:	01350d63          	beq	a0,s3,ad4 <head_run+0x58>
		if (readStatus == READ_EOF)
 abe:	c11d                	beqz	a0,ae4 <head_run+0x68>
		printf("%s",line);
 ac0:	dd840593          	addi	a1,s0,-552
 ac4:	8552                	mv	a0,s4
 ac6:	00000097          	auipc	ra,0x0
 aca:	e18080e7          	jalr	-488(ra) # 8de <printf>
	while(numOfLines--){
 ace:	34fd                	addiw	s1,s1,-1
 ad0:	fcf1                	bnez	s1,aac <head_run+0x30>
 ad2:	a809                	j	ae4 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 ad4:	00000517          	auipc	a0,0x0
 ad8:	4fc50513          	addi	a0,a0,1276 # fd0 <digits+0x18>
 adc:	00000097          	auipc	ra,0x0
 ae0:	e02080e7          	jalr	-510(ra) # 8de <printf>

	}
}
 ae4:	22813083          	ld	ra,552(sp)
 ae8:	22013403          	ld	s0,544(sp)
 aec:	21813483          	ld	s1,536(sp)
 af0:	21013903          	ld	s2,528(sp)
 af4:	20813983          	ld	s3,520(sp)
 af8:	20013a03          	ld	s4,512(sp)
 afc:	23010113          	addi	sp,sp,560
 b00:	8082                	ret
 b02:	8082                	ret

0000000000000b04 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 b04:	ba010113          	addi	sp,sp,-1120
 b08:	44113c23          	sd	ra,1112(sp)
 b0c:	44813823          	sd	s0,1104(sp)
 b10:	44913423          	sd	s1,1096(sp)
 b14:	45213023          	sd	s2,1088(sp)
 b18:	43313c23          	sd	s3,1080(sp)
 b1c:	43413823          	sd	s4,1072(sp)
 b20:	43513423          	sd	s5,1064(sp)
 b24:	43613023          	sd	s6,1056(sp)
 b28:	41713c23          	sd	s7,1048(sp)
 b2c:	41813823          	sd	s8,1040(sp)
 b30:	41913423          	sd	s9,1032(sp)
 b34:	41a13023          	sd	s10,1024(sp)
 b38:	3fb13c23          	sd	s11,1016(sp)
 b3c:	46010413          	addi	s0,sp,1120
 b40:	89aa                	mv	s3,a0
 b42:	8aae                	mv	s5,a1
 b44:	8c32                	mv	s8,a2
 b46:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 b48:	d9840593          	addi	a1,s0,-616
 b4c:	00000097          	auipc	ra,0x0
 b50:	2fa080e7          	jalr	762(ra) # e46 <read_line>


  if (readStatus == READ_ERROR)
 b54:	57fd                	li	a5,-1
 b56:	04f50163          	beq	a0,a5,b98 <uniq_run+0x94>
 b5a:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 b5c:	ed21                	bnez	a0,bb4 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 b5e:	45813083          	ld	ra,1112(sp)
 b62:	45013403          	ld	s0,1104(sp)
 b66:	44813483          	ld	s1,1096(sp)
 b6a:	44013903          	ld	s2,1088(sp)
 b6e:	43813983          	ld	s3,1080(sp)
 b72:	43013a03          	ld	s4,1072(sp)
 b76:	42813a83          	ld	s5,1064(sp)
 b7a:	42013b03          	ld	s6,1056(sp)
 b7e:	41813b83          	ld	s7,1048(sp)
 b82:	41013c03          	ld	s8,1040(sp)
 b86:	40813c83          	ld	s9,1032(sp)
 b8a:	40013d03          	ld	s10,1024(sp)
 b8e:	3f813d83          	ld	s11,1016(sp)
 b92:	46010113          	addi	sp,sp,1120
 b96:	8082                	ret
    printf("[ERR] Error reading from the file ");
 b98:	00000517          	auipc	a0,0x0
 b9c:	46850513          	addi	a0,a0,1128 # 1000 <digits+0x48>
 ba0:	00000097          	auipc	ra,0x0
 ba4:	d3e080e7          	jalr	-706(ra) # 8de <printf>
 ba8:	bf5d                	j	b5e <uniq_run+0x5a>
 baa:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 bac:	8926                	mv	s2,s1
 bae:	84be                	mv	s1,a5
        lineCount = 1;
 bb0:	8b6a                	mv	s6,s10
 bb2:	a8ed                	j	cac <uniq_run+0x1a8>
    int lineCount=1;
 bb4:	4b05                	li	s6,1
  char * line2 = buffer2;
 bb6:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 bba:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 bbe:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 bc0:	4d05                	li	s10,1
              printf("%s",line1);
 bc2:	00000d97          	auipc	s11,0x0
 bc6:	436d8d93          	addi	s11,s11,1078 # ff8 <digits+0x40>
 bca:	a0cd                	j	cac <uniq_run+0x1a8>
            if (repeatedLines){
 bcc:	020a0b63          	beqz	s4,c02 <uniq_run+0xfe>
                if (isRepeated){
 bd0:	f80b87e3          	beqz	s7,b5e <uniq_run+0x5a>
                    if (showCount)
 bd4:	000c0d63          	beqz	s8,bee <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 bd8:	864a                	mv	a2,s2
 bda:	85da                	mv	a1,s6
 bdc:	00000517          	auipc	a0,0x0
 be0:	44c50513          	addi	a0,a0,1100 # 1028 <digits+0x70>
 be4:	00000097          	auipc	ra,0x0
 be8:	cfa080e7          	jalr	-774(ra) # 8de <printf>
 bec:	bf8d                	j	b5e <uniq_run+0x5a>
                      printf("%s",line1);
 bee:	85ca                	mv	a1,s2
 bf0:	00000517          	auipc	a0,0x0
 bf4:	40850513          	addi	a0,a0,1032 # ff8 <digits+0x40>
 bf8:	00000097          	auipc	ra,0x0
 bfc:	ce6080e7          	jalr	-794(ra) # 8de <printf>
 c00:	bfb9                	j	b5e <uniq_run+0x5a>
                if (showCount)
 c02:	000c0d63          	beqz	s8,c1c <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 c06:	864a                	mv	a2,s2
 c08:	85da                	mv	a1,s6
 c0a:	00000517          	auipc	a0,0x0
 c0e:	41e50513          	addi	a0,a0,1054 # 1028 <digits+0x70>
 c12:	00000097          	auipc	ra,0x0
 c16:	ccc080e7          	jalr	-820(ra) # 8de <printf>
 c1a:	b791                	j	b5e <uniq_run+0x5a>
                  printf("%s",line1);
 c1c:	85ca                	mv	a1,s2
 c1e:	00000517          	auipc	a0,0x0
 c22:	3da50513          	addi	a0,a0,986 # ff8 <digits+0x40>
 c26:	00000097          	auipc	ra,0x0
 c2a:	cb8080e7          	jalr	-840(ra) # 8de <printf>
 c2e:	bf05                	j	b5e <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 c30:	00000517          	auipc	a0,0x0
 c34:	40050513          	addi	a0,a0,1024 # 1030 <digits+0x78>
 c38:	00000097          	auipc	ra,0x0
 c3c:	ca6080e7          	jalr	-858(ra) # 8de <printf>
          break;
 c40:	bf39                	j	b5e <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 c42:	85a6                	mv	a1,s1
 c44:	854a                	mv	a0,s2
 c46:	00000097          	auipc	ra,0x0
 c4a:	110080e7          	jalr	272(ra) # d56 <compare_str_ic>
 c4e:	a041                	j	cce <uniq_run+0x1ca>
                  printf("%s",line1);
 c50:	85ca                	mv	a1,s2
 c52:	856e                	mv	a0,s11
 c54:	00000097          	auipc	ra,0x0
 c58:	c8a080e7          	jalr	-886(ra) # 8de <printf>
        lineCount = 1;
 c5c:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 c5e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 c60:	8926                	mv	s2,s1
                  printf("%s",line1);
 c62:	84be                	mv	s1,a5
        isRepeated = 0 ;
 c64:	4b81                	li	s7,0
 c66:	a099                	j	cac <uniq_run+0x1a8>
            if (showCount)
 c68:	020c0263          	beqz	s8,c8c <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 c6c:	864a                	mv	a2,s2
 c6e:	85da                	mv	a1,s6
 c70:	00000517          	auipc	a0,0x0
 c74:	3b850513          	addi	a0,a0,952 # 1028 <digits+0x70>
 c78:	00000097          	auipc	ra,0x0
 c7c:	c66080e7          	jalr	-922(ra) # 8de <printf>
 c80:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 c82:	8926                	mv	s2,s1
 c84:	84be                	mv	s1,a5
        isRepeated = 0 ;
 c86:	4b81                	li	s7,0
        lineCount = 1;
 c88:	8b6a                	mv	s6,s10
 c8a:	a00d                	j	cac <uniq_run+0x1a8>
              printf("%s",line1);
 c8c:	85ca                	mv	a1,s2
 c8e:	856e                	mv	a0,s11
 c90:	00000097          	auipc	ra,0x0
 c94:	c4e080e7          	jalr	-946(ra) # 8de <printf>
 c98:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 c9a:	8926                	mv	s2,s1
              printf("%s",line1);
 c9c:	84be                	mv	s1,a5
        isRepeated = 0 ;
 c9e:	4b81                	li	s7,0
        lineCount = 1;
 ca0:	8b6a                	mv	s6,s10
 ca2:	a029                	j	cac <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 ca4:	000a0363          	beqz	s4,caa <uniq_run+0x1a6>
 ca8:	8bea                	mv	s7,s10
          lineCount++;
 caa:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 cac:	85a6                	mv	a1,s1
 cae:	854e                	mv	a0,s3
 cb0:	00000097          	auipc	ra,0x0
 cb4:	196080e7          	jalr	406(ra) # e46 <read_line>
        if (readStatus == READ_EOF){
 cb8:	d911                	beqz	a0,bcc <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 cba:	f7950be3          	beq	a0,s9,c30 <uniq_run+0x12c>
        if (!ignoreCase)
 cbe:	f80a92e3          	bnez	s5,c42 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 cc2:	85a6                	mv	a1,s1
 cc4:	854a                	mv	a0,s2
 cc6:	00000097          	auipc	ra,0x0
 cca:	062080e7          	jalr	98(ra) # d28 <compare_str>
        if (compareStatus != 0){ 
 cce:	d979                	beqz	a0,ca4 <uniq_run+0x1a0>
          if (repeatedLines){
 cd0:	f80a0ce3          	beqz	s4,c68 <uniq_run+0x164>
            if (isRepeated){
 cd4:	ec0b8be3          	beqz	s7,baa <uniq_run+0xa6>
                if (showCount)
 cd8:	f60c0ce3          	beqz	s8,c50 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 cdc:	864a                	mv	a2,s2
 cde:	85da                	mv	a1,s6
 ce0:	00000517          	auipc	a0,0x0
 ce4:	34850513          	addi	a0,a0,840 # 1028 <digits+0x70>
 ce8:	00000097          	auipc	ra,0x0
 cec:	bf6080e7          	jalr	-1034(ra) # 8de <printf>
        lineCount = 1;
 cf0:	8b5e                	mv	s6,s7
 cf2:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 cf4:	8926                	mv	s2,s1
 cf6:	84be                	mv	s1,a5
        isRepeated = 0 ;
 cf8:	4b81                	li	s7,0
 cfa:	bf4d                	j	cac <uniq_run+0x1a8>

0000000000000cfc <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 cfc:	1141                	addi	sp,sp,-16
 cfe:	e422                	sd	s0,8(sp)
 d00:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 d02:	00054783          	lbu	a5,0(a0)
 d06:	cf99                	beqz	a5,d24 <get_strlen+0x28>
 d08:	00150713          	addi	a4,a0,1
 d0c:	87ba                	mv	a5,a4
 d0e:	4685                	li	a3,1
 d10:	9e99                	subw	a3,a3,a4
 d12:	00f6853b          	addw	a0,a3,a5
 d16:	0785                	addi	a5,a5,1
 d18:	fff7c703          	lbu	a4,-1(a5)
 d1c:	fb7d                	bnez	a4,d12 <get_strlen+0x16>
	return len;
}
 d1e:	6422                	ld	s0,8(sp)
 d20:	0141                	addi	sp,sp,16
 d22:	8082                	ret
	int len = 0;
 d24:	4501                	li	a0,0
 d26:	bfe5                	j	d1e <get_strlen+0x22>

0000000000000d28 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 d28:	1141                	addi	sp,sp,-16
 d2a:	e422                	sd	s0,8(sp)
 d2c:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 d2e:	00054783          	lbu	a5,0(a0)
 d32:	cb91                	beqz	a5,d46 <compare_str+0x1e>
 d34:	0005c703          	lbu	a4,0(a1)
 d38:	c719                	beqz	a4,d46 <compare_str+0x1e>
		if (*s1++ != *s2++)
 d3a:	0505                	addi	a0,a0,1
 d3c:	0585                	addi	a1,a1,1
 d3e:	fee788e3          	beq	a5,a4,d2e <compare_str+0x6>
			return 1;
 d42:	4505                	li	a0,1
 d44:	a031                	j	d50 <compare_str+0x28>
	}
	if (*s1 == *s2)
 d46:	0005c503          	lbu	a0,0(a1)
 d4a:	8d1d                	sub	a0,a0,a5
			return 1;
 d4c:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 d50:	6422                	ld	s0,8(sp)
 d52:	0141                	addi	sp,sp,16
 d54:	8082                	ret

0000000000000d56 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 d56:	1141                	addi	sp,sp,-16
 d58:	e422                	sd	s0,8(sp)
 d5a:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 d5c:	4665                	li	a2,25
	while(*s1 && *s2){
 d5e:	a019                	j	d64 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 d60:	04e79763          	bne	a5,a4,dae <compare_str_ic+0x58>
	while(*s1 && *s2){
 d64:	00054783          	lbu	a5,0(a0)
 d68:	cb9d                	beqz	a5,d9e <compare_str_ic+0x48>
 d6a:	0005c703          	lbu	a4,0(a1)
 d6e:	cb05                	beqz	a4,d9e <compare_str_ic+0x48>
		char b1 = *s1++;
 d70:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 d72:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 d74:	fbf7869b          	addiw	a3,a5,-65
 d78:	0ff6f693          	zext.b	a3,a3
 d7c:	00d66663          	bltu	a2,a3,d88 <compare_str_ic+0x32>
			b1 += 32;
 d80:	0207879b          	addiw	a5,a5,32
 d84:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 d88:	fbf7069b          	addiw	a3,a4,-65
 d8c:	0ff6f693          	zext.b	a3,a3
 d90:	fcd668e3          	bltu	a2,a3,d60 <compare_str_ic+0xa>
			b2 += 32;
 d94:	0207071b          	addiw	a4,a4,32
 d98:	0ff77713          	zext.b	a4,a4
 d9c:	b7d1                	j	d60 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 d9e:	0005c503          	lbu	a0,0(a1)
 da2:	8d1d                	sub	a0,a0,a5
			return 1;
 da4:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 da8:	6422                	ld	s0,8(sp)
 daa:	0141                	addi	sp,sp,16
 dac:	8082                	ret
			return 1;
 dae:	4505                	li	a0,1
 db0:	bfe5                	j	da8 <compare_str_ic+0x52>

0000000000000db2 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 db2:	7179                	addi	sp,sp,-48
 db4:	f406                	sd	ra,40(sp)
 db6:	f022                	sd	s0,32(sp)
 db8:	ec26                	sd	s1,24(sp)
 dba:	e84a                	sd	s2,16(sp)
 dbc:	e44e                	sd	s3,8(sp)
 dbe:	1800                	addi	s0,sp,48
 dc0:	89aa                	mv	s3,a0
 dc2:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 dc4:	00000097          	auipc	ra,0x0
 dc8:	f38080e7          	jalr	-200(ra) # cfc <get_strlen>
 dcc:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 dce:	854a                	mv	a0,s2
 dd0:	00000097          	auipc	ra,0x0
 dd4:	f2c080e7          	jalr	-212(ra) # cfc <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 dd8:	409505bb          	subw	a1,a0,s1
 ddc:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 dde:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 de0:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 de2:	0005da63          	bgez	a1,df6 <check_substr+0x44>
 de6:	a81d                	j	e1c <check_substr+0x6a>
        if (j == M)
 de8:	02f48a63          	beq	s1,a5,e1c <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 dec:	0885                	addi	a7,a7,1
 dee:	0008879b          	sext.w	a5,a7
 df2:	02f5cc63          	blt	a1,a5,e2a <check_substr+0x78>
 df6:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 dfa:	011906b3          	add	a3,s2,a7
 dfe:	874e                	mv	a4,s3
 e00:	879a                	mv	a5,t1
 e02:	fe9053e3          	blez	s1,de8 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 e06:	0006c803          	lbu	a6,0(a3) # 1000 <digits+0x48>
 e0a:	00074603          	lbu	a2,0(a4)
 e0e:	fcc81de3          	bne	a6,a2,de8 <check_substr+0x36>
        for (j = 0; j < M; j++)
 e12:	2785                	addiw	a5,a5,1
 e14:	0685                	addi	a3,a3,1
 e16:	0705                	addi	a4,a4,1
 e18:	fef497e3          	bne	s1,a5,e06 <check_substr+0x54>
}
 e1c:	70a2                	ld	ra,40(sp)
 e1e:	7402                	ld	s0,32(sp)
 e20:	64e2                	ld	s1,24(sp)
 e22:	6942                	ld	s2,16(sp)
 e24:	69a2                	ld	s3,8(sp)
 e26:	6145                	addi	sp,sp,48
 e28:	8082                	ret
    return -1;
 e2a:	557d                	li	a0,-1
 e2c:	bfc5                	j	e1c <check_substr+0x6a>

0000000000000e2e <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 e2e:	1141                	addi	sp,sp,-16
 e30:	e406                	sd	ra,8(sp)
 e32:	e022                	sd	s0,0(sp)
 e34:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 e36:	fffff097          	auipc	ra,0xfffff
 e3a:	72e080e7          	jalr	1838(ra) # 564 <open>
	return fd;
}
 e3e:	60a2                	ld	ra,8(sp)
 e40:	6402                	ld	s0,0(sp)
 e42:	0141                	addi	sp,sp,16
 e44:	8082                	ret

0000000000000e46 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 e46:	7139                	addi	sp,sp,-64
 e48:	fc06                	sd	ra,56(sp)
 e4a:	f822                	sd	s0,48(sp)
 e4c:	f426                	sd	s1,40(sp)
 e4e:	f04a                	sd	s2,32(sp)
 e50:	ec4e                	sd	s3,24(sp)
 e52:	e852                	sd	s4,16(sp)
 e54:	0080                	addi	s0,sp,64
 e56:	89aa                	mv	s3,a0
 e58:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 e5a:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 e5c:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 e5e:	4605                	li	a2,1
 e60:	fcf40593          	addi	a1,s0,-49
 e64:	854e                	mv	a0,s3
 e66:	fffff097          	auipc	ra,0xfffff
 e6a:	6d6080e7          	jalr	1750(ra) # 53c <read>
		if (readStatus == 0){
 e6e:	c505                	beqz	a0,e96 <read_line+0x50>
		*buffer++ = readByte;
 e70:	0485                	addi	s1,s1,1
 e72:	fcf44783          	lbu	a5,-49(s0)
 e76:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 e7a:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 e7c:	ff4791e3          	bne	a5,s4,e5e <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 e80:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 e84:	854a                	mv	a0,s2
 e86:	70e2                	ld	ra,56(sp)
 e88:	7442                	ld	s0,48(sp)
 e8a:	74a2                	ld	s1,40(sp)
 e8c:	7902                	ld	s2,32(sp)
 e8e:	69e2                	ld	s3,24(sp)
 e90:	6a42                	ld	s4,16(sp)
 e92:	6121                	addi	sp,sp,64
 e94:	8082                	ret
			if (byteCount!=0){
 e96:	fe0907e3          	beqz	s2,e84 <read_line+0x3e>
				*buffer = '\n';
 e9a:	47a9                	li	a5,10
 e9c:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 ea0:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 ea4:	2905                	addiw	s2,s2,1
 ea6:	bff9                	j	e84 <read_line+0x3e>

0000000000000ea8 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 ea8:	1141                	addi	sp,sp,-16
 eaa:	e406                	sd	ra,8(sp)
 eac:	e022                	sd	s0,0(sp)
 eae:	0800                	addi	s0,sp,16
	close(fd);
 eb0:	fffff097          	auipc	ra,0xfffff
 eb4:	69c080e7          	jalr	1692(ra) # 54c <close>
}
 eb8:	60a2                	ld	ra,8(sp)
 eba:	6402                	ld	s0,0(sp)
 ebc:	0141                	addi	sp,sp,16
 ebe:	8082                	ret

0000000000000ec0 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 ec0:	7139                	addi	sp,sp,-64
 ec2:	fc06                	sd	ra,56(sp)
 ec4:	f822                	sd	s0,48(sp)
 ec6:	f426                	sd	s1,40(sp)
 ec8:	f04a                	sd	s2,32(sp)
 eca:	0080                	addi	s0,sp,64
 ecc:	84aa                	mv	s1,a0
 ece:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 ed0:	fffff097          	auipc	ra,0xfffff
 ed4:	64c080e7          	jalr	1612(ra) # 51c <fork>
 ed8:	ed19                	bnez	a0,ef6 <get_time_perf+0x36>
		exec(argv[0],argv);
 eda:	85ca                	mv	a1,s2
 edc:	00093503          	ld	a0,0(s2)
 ee0:	fffff097          	auipc	ra,0xfffff
 ee4:	67c080e7          	jalr	1660(ra) # 55c <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 ee8:	8526                	mv	a0,s1
 eea:	70e2                	ld	ra,56(sp)
 eec:	7442                	ld	s0,48(sp)
 eee:	74a2                	ld	s1,40(sp)
 ef0:	7902                	ld	s2,32(sp)
 ef2:	6121                	addi	sp,sp,64
 ef4:	8082                	ret
		times(pid , &time);
 ef6:	fc040593          	addi	a1,s0,-64
 efa:	fffff097          	auipc	ra,0xfffff
 efe:	6e2080e7          	jalr	1762(ra) # 5dc <times>
		return time;
 f02:	fc043783          	ld	a5,-64(s0)
 f06:	e09c                	sd	a5,0(s1)
 f08:	fc843783          	ld	a5,-56(s0)
 f0c:	e49c                	sd	a5,8(s1)
 f0e:	fd043783          	ld	a5,-48(s0)
 f12:	e89c                	sd	a5,16(s1)
 f14:	fd843783          	ld	a5,-40(s0)
 f18:	ec9c                	sd	a5,24(s1)
 f1a:	b7f9                	j	ee8 <get_time_perf+0x28>
