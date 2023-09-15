
user/_uniq:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:





int main(int argc, char ** argv){
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	e85a                	sd	s6,16(sp)
  12:	e45e                	sd	s7,8(sp)
  14:	0880                	addi	s0,sp,80
  16:	892e                	mv	s2,a1
*/
static char ** parse_cmd(int argc, char ** cmd, char * options){


	/* Total number of files is maximum argc-1 requiring argc size storage for the last NULL*/
	char ** passedFiles = malloc(sizeof(char *) * (argc));
  18:	0035151b          	slliw	a0,a0,0x3
  1c:	00000097          	auipc	ra,0x0
  20:	782080e7          	jalr	1922(ra) # 79e <malloc>

	if (!passedFiles)
  24:	cd59                	beqz	a0,c2 <main+0xc2>
  26:	8a2a                	mv	s4,a0


	*options = 0;
	int fileIdx = 0;

	cmd++;  // Skipping the program's name
  28:	00890493          	addi	s1,s2,8
	
	while(*cmd){
  2c:	00893503          	ld	a0,8(s2)
  30:	c535                	beqz	a0,9c <main+0x9c>
	*options = 0;
  32:	4901                	li	s2,0
	int fileIdx = 0;
  34:	4b01                	li	s6,0
		if (!compare_str(cmd[0], "-c"))
  36:	00001997          	auipc	s3,0x1
  3a:	c1a98993          	addi	s3,s3,-998 # c50 <close_file+0x1c>
			*options |= OPT_SHOW_COUNT;
		else if (!compare_str(cmd[0], "-i"))
  3e:	00001a97          	auipc	s5,0x1
  42:	c1aa8a93          	addi	s5,s5,-998 # c58 <close_file+0x24>
			*options |= OPT_IGNORE_CASE;
		else if (!compare_str(cmd[0], "-d"))
  46:	00001b97          	auipc	s7,0x1
  4a:	c1ab8b93          	addi	s7,s7,-998 # c60 <close_file+0x2c>
  4e:	a031                	j	5a <main+0x5a>
			*options |= OPT_SHOW_COUNT;
  50:	00296913          	ori	s2,s2,2
			*options |= OPT_SHOW_REPEATED_LINES;
		else
			passedFiles[fileIdx++] = cmd[0];
			
		cmd++;
  54:	04a1                	addi	s1,s1,8
	while(*cmd){
  56:	6088                	ld	a0,0(s1)
  58:	c139                	beqz	a0,9e <main+0x9e>
		if (!compare_str(cmd[0], "-c"))
  5a:	85ce                	mv	a1,s3
  5c:	00001097          	auipc	ra,0x1
  60:	ad4080e7          	jalr	-1324(ra) # b30 <compare_str>
  64:	d575                	beqz	a0,50 <main+0x50>
		else if (!compare_str(cmd[0], "-i"))
  66:	85d6                	mv	a1,s5
  68:	6088                	ld	a0,0(s1)
  6a:	00001097          	auipc	ra,0x1
  6e:	ac6080e7          	jalr	-1338(ra) # b30 <compare_str>
  72:	e501                	bnez	a0,7a <main+0x7a>
			*options |= OPT_IGNORE_CASE;
  74:	00196913          	ori	s2,s2,1
  78:	bff1                	j	54 <main+0x54>
		else if (!compare_str(cmd[0], "-d"))
  7a:	85de                	mv	a1,s7
  7c:	6088                	ld	a0,0(s1)
  7e:	00001097          	auipc	ra,0x1
  82:	ab2080e7          	jalr	-1358(ra) # b30 <compare_str>
  86:	e501                	bnez	a0,8e <main+0x8e>
			*options |= OPT_SHOW_REPEATED_LINES;
  88:	00496913          	ori	s2,s2,4
  8c:	b7e1                	j	54 <main+0x54>
			passedFiles[fileIdx++] = cmd[0];
  8e:	6098                	ld	a4,0(s1)
  90:	003b1793          	slli	a5,s6,0x3
  94:	97d2                	add	a5,a5,s4
  96:	e398                	sd	a4,0(a5)
  98:	2b05                	addiw	s6,s6,1
  9a:	bf6d                	j	54 <main+0x54>
	*options = 0;
  9c:	4901                	li	s2,0
	uniq(passedFiles,options);
  9e:	85ca                	mv	a1,s2
  a0:	8552                	mv	a0,s4
  a2:	00000097          	auipc	ra,0x0
  a6:	362080e7          	jalr	866(ra) # 404 <uniq>
	return 0;
  aa:	4501                	li	a0,0
}
  ac:	60a6                	ld	ra,72(sp)
  ae:	6406                	ld	s0,64(sp)
  b0:	74e2                	ld	s1,56(sp)
  b2:	7942                	ld	s2,48(sp)
  b4:	79a2                	ld	s3,40(sp)
  b6:	7a02                	ld	s4,32(sp)
  b8:	6ae2                	ld	s5,24(sp)
  ba:	6b42                	ld	s6,16(sp)
  bc:	6ba2                	ld	s7,8(sp)
  be:	6161                	addi	sp,sp,80
  c0:	8082                	ret
		printf("[ERR] Cannot parse the cmd");
  c2:	00001517          	auipc	a0,0x1
  c6:	ba650513          	addi	a0,a0,-1114 # c68 <close_file+0x34>
  ca:	00000097          	auipc	ra,0x0
  ce:	61c080e7          	jalr	1564(ra) # 6e6 <printf>
		return 1;
  d2:	4505                	li	a0,1
  d4:	bfe1                	j	ac <main+0xac>

00000000000000d6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e406                	sd	ra,8(sp)
  da:	e022                	sd	s0,0(sp)
  dc:	0800                	addi	s0,sp,16
  extern int main();
  main();
  de:	00000097          	auipc	ra,0x0
  e2:	f22080e7          	jalr	-222(ra) # 0 <main>
  exit(0);
  e6:	4501                	li	a0,0
  e8:	00000097          	auipc	ra,0x0
  ec:	274080e7          	jalr	628(ra) # 35c <exit>

00000000000000f0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f6:	87aa                	mv	a5,a0
  f8:	0585                	addi	a1,a1,1
  fa:	0785                	addi	a5,a5,1
  fc:	fff5c703          	lbu	a4,-1(a1)
 100:	fee78fa3          	sb	a4,-1(a5)
 104:	fb75                	bnez	a4,f8 <strcpy+0x8>
    ;
  return os;
}
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 112:	00054783          	lbu	a5,0(a0)
 116:	cb91                	beqz	a5,12a <strcmp+0x1e>
 118:	0005c703          	lbu	a4,0(a1)
 11c:	00f71763          	bne	a4,a5,12a <strcmp+0x1e>
    p++, q++;
 120:	0505                	addi	a0,a0,1
 122:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 124:	00054783          	lbu	a5,0(a0)
 128:	fbe5                	bnez	a5,118 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 12a:	0005c503          	lbu	a0,0(a1)
}
 12e:	40a7853b          	subw	a0,a5,a0
 132:	6422                	ld	s0,8(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret

0000000000000138 <strlen>:

uint
strlen(const char *s)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e422                	sd	s0,8(sp)
 13c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 13e:	00054783          	lbu	a5,0(a0)
 142:	cf91                	beqz	a5,15e <strlen+0x26>
 144:	0505                	addi	a0,a0,1
 146:	87aa                	mv	a5,a0
 148:	4685                	li	a3,1
 14a:	9e89                	subw	a3,a3,a0
 14c:	00f6853b          	addw	a0,a3,a5
 150:	0785                	addi	a5,a5,1
 152:	fff7c703          	lbu	a4,-1(a5)
 156:	fb7d                	bnez	a4,14c <strlen+0x14>
    ;
  return n;
}
 158:	6422                	ld	s0,8(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret
  for(n = 0; s[n]; n++)
 15e:	4501                	li	a0,0
 160:	bfe5                	j	158 <strlen+0x20>

0000000000000162 <memset>:

void*
memset(void *dst, int c, uint n)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 168:	ca19                	beqz	a2,17e <memset+0x1c>
 16a:	87aa                	mv	a5,a0
 16c:	1602                	slli	a2,a2,0x20
 16e:	9201                	srli	a2,a2,0x20
 170:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 174:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 178:	0785                	addi	a5,a5,1
 17a:	fee79de3          	bne	a5,a4,174 <memset+0x12>
  }
  return dst;
}
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strchr>:

char*
strchr(const char *s, char c)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  for(; *s; s++)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cb99                	beqz	a5,1a4 <strchr+0x20>
    if(*s == c)
 190:	00f58763          	beq	a1,a5,19e <strchr+0x1a>
  for(; *s; s++)
 194:	0505                	addi	a0,a0,1
 196:	00054783          	lbu	a5,0(a0)
 19a:	fbfd                	bnez	a5,190 <strchr+0xc>
      return (char*)s;
  return 0;
 19c:	4501                	li	a0,0
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret
  return 0;
 1a4:	4501                	li	a0,0
 1a6:	bfe5                	j	19e <strchr+0x1a>

00000000000001a8 <gets>:

char*
gets(char *buf, int max)
{
 1a8:	711d                	addi	sp,sp,-96
 1aa:	ec86                	sd	ra,88(sp)
 1ac:	e8a2                	sd	s0,80(sp)
 1ae:	e4a6                	sd	s1,72(sp)
 1b0:	e0ca                	sd	s2,64(sp)
 1b2:	fc4e                	sd	s3,56(sp)
 1b4:	f852                	sd	s4,48(sp)
 1b6:	f456                	sd	s5,40(sp)
 1b8:	f05a                	sd	s6,32(sp)
 1ba:	ec5e                	sd	s7,24(sp)
 1bc:	1080                	addi	s0,sp,96
 1be:	8baa                	mv	s7,a0
 1c0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c2:	892a                	mv	s2,a0
 1c4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c6:	4aa9                	li	s5,10
 1c8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ca:	89a6                	mv	s3,s1
 1cc:	2485                	addiw	s1,s1,1
 1ce:	0344d863          	bge	s1,s4,1fe <gets+0x56>
    cc = read(0, &c, 1);
 1d2:	4605                	li	a2,1
 1d4:	faf40593          	addi	a1,s0,-81
 1d8:	4501                	li	a0,0
 1da:	00000097          	auipc	ra,0x0
 1de:	19a080e7          	jalr	410(ra) # 374 <read>
    if(cc < 1)
 1e2:	00a05e63          	blez	a0,1fe <gets+0x56>
    buf[i++] = c;
 1e6:	faf44783          	lbu	a5,-81(s0)
 1ea:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ee:	01578763          	beq	a5,s5,1fc <gets+0x54>
 1f2:	0905                	addi	s2,s2,1
 1f4:	fd679be3          	bne	a5,s6,1ca <gets+0x22>
  for(i=0; i+1 < max; ){
 1f8:	89a6                	mv	s3,s1
 1fa:	a011                	j	1fe <gets+0x56>
 1fc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1fe:	99de                	add	s3,s3,s7
 200:	00098023          	sb	zero,0(s3)
  return buf;
}
 204:	855e                	mv	a0,s7
 206:	60e6                	ld	ra,88(sp)
 208:	6446                	ld	s0,80(sp)
 20a:	64a6                	ld	s1,72(sp)
 20c:	6906                	ld	s2,64(sp)
 20e:	79e2                	ld	s3,56(sp)
 210:	7a42                	ld	s4,48(sp)
 212:	7aa2                	ld	s5,40(sp)
 214:	7b02                	ld	s6,32(sp)
 216:	6be2                	ld	s7,24(sp)
 218:	6125                	addi	sp,sp,96
 21a:	8082                	ret

000000000000021c <stat>:

int
stat(const char *n, struct stat *st)
{
 21c:	1101                	addi	sp,sp,-32
 21e:	ec06                	sd	ra,24(sp)
 220:	e822                	sd	s0,16(sp)
 222:	e426                	sd	s1,8(sp)
 224:	e04a                	sd	s2,0(sp)
 226:	1000                	addi	s0,sp,32
 228:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22a:	4581                	li	a1,0
 22c:	00000097          	auipc	ra,0x0
 230:	170080e7          	jalr	368(ra) # 39c <open>
  if(fd < 0)
 234:	02054563          	bltz	a0,25e <stat+0x42>
 238:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23a:	85ca                	mv	a1,s2
 23c:	00000097          	auipc	ra,0x0
 240:	178080e7          	jalr	376(ra) # 3b4 <fstat>
 244:	892a                	mv	s2,a0
  close(fd);
 246:	8526                	mv	a0,s1
 248:	00000097          	auipc	ra,0x0
 24c:	13c080e7          	jalr	316(ra) # 384 <close>
  return r;
}
 250:	854a                	mv	a0,s2
 252:	60e2                	ld	ra,24(sp)
 254:	6442                	ld	s0,16(sp)
 256:	64a2                	ld	s1,8(sp)
 258:	6902                	ld	s2,0(sp)
 25a:	6105                	addi	sp,sp,32
 25c:	8082                	ret
    return -1;
 25e:	597d                	li	s2,-1
 260:	bfc5                	j	250 <stat+0x34>

0000000000000262 <atoi>:

int
atoi(const char *s)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 268:	00054683          	lbu	a3,0(a0)
 26c:	fd06879b          	addiw	a5,a3,-48
 270:	0ff7f793          	zext.b	a5,a5
 274:	4625                	li	a2,9
 276:	02f66863          	bltu	a2,a5,2a6 <atoi+0x44>
 27a:	872a                	mv	a4,a0
  n = 0;
 27c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 27e:	0705                	addi	a4,a4,1
 280:	0025179b          	slliw	a5,a0,0x2
 284:	9fa9                	addw	a5,a5,a0
 286:	0017979b          	slliw	a5,a5,0x1
 28a:	9fb5                	addw	a5,a5,a3
 28c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 290:	00074683          	lbu	a3,0(a4)
 294:	fd06879b          	addiw	a5,a3,-48
 298:	0ff7f793          	zext.b	a5,a5
 29c:	fef671e3          	bgeu	a2,a5,27e <atoi+0x1c>
  return n;
}
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
  n = 0;
 2a6:	4501                	li	a0,0
 2a8:	bfe5                	j	2a0 <atoi+0x3e>

00000000000002aa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b0:	02b57463          	bgeu	a0,a1,2d8 <memmove+0x2e>
    while(n-- > 0)
 2b4:	00c05f63          	blez	a2,2d2 <memmove+0x28>
 2b8:	1602                	slli	a2,a2,0x20
 2ba:	9201                	srli	a2,a2,0x20
 2bc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c2:	0585                	addi	a1,a1,1
 2c4:	0705                	addi	a4,a4,1
 2c6:	fff5c683          	lbu	a3,-1(a1)
 2ca:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ce:	fee79ae3          	bne	a5,a4,2c2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
    dst += n;
 2d8:	00c50733          	add	a4,a0,a2
    src += n;
 2dc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2de:	fec05ae3          	blez	a2,2d2 <memmove+0x28>
 2e2:	fff6079b          	addiw	a5,a2,-1
 2e6:	1782                	slli	a5,a5,0x20
 2e8:	9381                	srli	a5,a5,0x20
 2ea:	fff7c793          	not	a5,a5
 2ee:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f0:	15fd                	addi	a1,a1,-1
 2f2:	177d                	addi	a4,a4,-1
 2f4:	0005c683          	lbu	a3,0(a1)
 2f8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2fc:	fee79ae3          	bne	a5,a4,2f0 <memmove+0x46>
 300:	bfc9                	j	2d2 <memmove+0x28>

0000000000000302 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 308:	ca05                	beqz	a2,338 <memcmp+0x36>
 30a:	fff6069b          	addiw	a3,a2,-1
 30e:	1682                	slli	a3,a3,0x20
 310:	9281                	srli	a3,a3,0x20
 312:	0685                	addi	a3,a3,1
 314:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 316:	00054783          	lbu	a5,0(a0)
 31a:	0005c703          	lbu	a4,0(a1)
 31e:	00e79863          	bne	a5,a4,32e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 322:	0505                	addi	a0,a0,1
    p2++;
 324:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 326:	fed518e3          	bne	a0,a3,316 <memcmp+0x14>
  }
  return 0;
 32a:	4501                	li	a0,0
 32c:	a019                	j	332 <memcmp+0x30>
      return *p1 - *p2;
 32e:	40e7853b          	subw	a0,a5,a4
}
 332:	6422                	ld	s0,8(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret
  return 0;
 338:	4501                	li	a0,0
 33a:	bfe5                	j	332 <memcmp+0x30>

000000000000033c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e406                	sd	ra,8(sp)
 340:	e022                	sd	s0,0(sp)
 342:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 344:	00000097          	auipc	ra,0x0
 348:	f66080e7          	jalr	-154(ra) # 2aa <memmove>
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 354:	4885                	li	a7,1
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <exit>:
.global exit
exit:
 li a7, SYS_exit
 35c:	4889                	li	a7,2
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <wait>:
.global wait
wait:
 li a7, SYS_wait
 364:	488d                	li	a7,3
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 36c:	4891                	li	a7,4
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <read>:
.global read
read:
 li a7, SYS_read
 374:	4895                	li	a7,5
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <write>:
.global write
write:
 li a7, SYS_write
 37c:	48c1                	li	a7,16
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <close>:
.global close
close:
 li a7, SYS_close
 384:	48d5                	li	a7,21
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <kill>:
.global kill
kill:
 li a7, SYS_kill
 38c:	4899                	li	a7,6
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <exec>:
.global exec
exec:
 li a7, SYS_exec
 394:	489d                	li	a7,7
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <open>:
.global open
open:
 li a7, SYS_open
 39c:	48bd                	li	a7,15
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a4:	48c5                	li	a7,17
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ac:	48c9                	li	a7,18
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b4:	48a1                	li	a7,8
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <link>:
.global link
link:
 li a7, SYS_link
 3bc:	48cd                	li	a7,19
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c4:	48d1                	li	a7,20
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3cc:	48a5                	li	a7,9
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d4:	48a9                	li	a7,10
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3dc:	48ad                	li	a7,11
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3e4:	48b1                	li	a7,12
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ec:	48b5                	li	a7,13
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f4:	48b9                	li	a7,14
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <head>:
.global head
head:
 li a7, SYS_head
 3fc:	48d9                	li	a7,22
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 404:	48dd                	li	a7,23
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40c:	1101                	addi	sp,sp,-32
 40e:	ec06                	sd	ra,24(sp)
 410:	e822                	sd	s0,16(sp)
 412:	1000                	addi	s0,sp,32
 414:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 418:	4605                	li	a2,1
 41a:	fef40593          	addi	a1,s0,-17
 41e:	00000097          	auipc	ra,0x0
 422:	f5e080e7          	jalr	-162(ra) # 37c <write>
}
 426:	60e2                	ld	ra,24(sp)
 428:	6442                	ld	s0,16(sp)
 42a:	6105                	addi	sp,sp,32
 42c:	8082                	ret

000000000000042e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42e:	7139                	addi	sp,sp,-64
 430:	fc06                	sd	ra,56(sp)
 432:	f822                	sd	s0,48(sp)
 434:	f426                	sd	s1,40(sp)
 436:	f04a                	sd	s2,32(sp)
 438:	ec4e                	sd	s3,24(sp)
 43a:	0080                	addi	s0,sp,64
 43c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43e:	c299                	beqz	a3,444 <printint+0x16>
 440:	0805c963          	bltz	a1,4d2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 444:	2581                	sext.w	a1,a1
  neg = 0;
 446:	4881                	li	a7,0
 448:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 44c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 44e:	2601                	sext.w	a2,a2
 450:	00001517          	auipc	a0,0x1
 454:	89850513          	addi	a0,a0,-1896 # ce8 <digits>
 458:	883a                	mv	a6,a4
 45a:	2705                	addiw	a4,a4,1
 45c:	02c5f7bb          	remuw	a5,a1,a2
 460:	1782                	slli	a5,a5,0x20
 462:	9381                	srli	a5,a5,0x20
 464:	97aa                	add	a5,a5,a0
 466:	0007c783          	lbu	a5,0(a5)
 46a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 46e:	0005879b          	sext.w	a5,a1
 472:	02c5d5bb          	divuw	a1,a1,a2
 476:	0685                	addi	a3,a3,1
 478:	fec7f0e3          	bgeu	a5,a2,458 <printint+0x2a>
  if(neg)
 47c:	00088c63          	beqz	a7,494 <printint+0x66>
    buf[i++] = '-';
 480:	fd070793          	addi	a5,a4,-48
 484:	00878733          	add	a4,a5,s0
 488:	02d00793          	li	a5,45
 48c:	fef70823          	sb	a5,-16(a4)
 490:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 494:	02e05863          	blez	a4,4c4 <printint+0x96>
 498:	fc040793          	addi	a5,s0,-64
 49c:	00e78933          	add	s2,a5,a4
 4a0:	fff78993          	addi	s3,a5,-1
 4a4:	99ba                	add	s3,s3,a4
 4a6:	377d                	addiw	a4,a4,-1
 4a8:	1702                	slli	a4,a4,0x20
 4aa:	9301                	srli	a4,a4,0x20
 4ac:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4b0:	fff94583          	lbu	a1,-1(s2)
 4b4:	8526                	mv	a0,s1
 4b6:	00000097          	auipc	ra,0x0
 4ba:	f56080e7          	jalr	-170(ra) # 40c <putc>
  while(--i >= 0)
 4be:	197d                	addi	s2,s2,-1
 4c0:	ff3918e3          	bne	s2,s3,4b0 <printint+0x82>
}
 4c4:	70e2                	ld	ra,56(sp)
 4c6:	7442                	ld	s0,48(sp)
 4c8:	74a2                	ld	s1,40(sp)
 4ca:	7902                	ld	s2,32(sp)
 4cc:	69e2                	ld	s3,24(sp)
 4ce:	6121                	addi	sp,sp,64
 4d0:	8082                	ret
    x = -xx;
 4d2:	40b005bb          	negw	a1,a1
    neg = 1;
 4d6:	4885                	li	a7,1
    x = -xx;
 4d8:	bf85                	j	448 <printint+0x1a>

00000000000004da <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4da:	7119                	addi	sp,sp,-128
 4dc:	fc86                	sd	ra,120(sp)
 4de:	f8a2                	sd	s0,112(sp)
 4e0:	f4a6                	sd	s1,104(sp)
 4e2:	f0ca                	sd	s2,96(sp)
 4e4:	ecce                	sd	s3,88(sp)
 4e6:	e8d2                	sd	s4,80(sp)
 4e8:	e4d6                	sd	s5,72(sp)
 4ea:	e0da                	sd	s6,64(sp)
 4ec:	fc5e                	sd	s7,56(sp)
 4ee:	f862                	sd	s8,48(sp)
 4f0:	f466                	sd	s9,40(sp)
 4f2:	f06a                	sd	s10,32(sp)
 4f4:	ec6e                	sd	s11,24(sp)
 4f6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f8:	0005c903          	lbu	s2,0(a1)
 4fc:	18090f63          	beqz	s2,69a <vprintf+0x1c0>
 500:	8aaa                	mv	s5,a0
 502:	8b32                	mv	s6,a2
 504:	00158493          	addi	s1,a1,1
  state = 0;
 508:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 50a:	02500a13          	li	s4,37
 50e:	4c55                	li	s8,21
 510:	00000c97          	auipc	s9,0x0
 514:	780c8c93          	addi	s9,s9,1920 # c90 <close_file+0x5c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 518:	02800d93          	li	s11,40
  putc(fd, 'x');
 51c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 51e:	00000b97          	auipc	s7,0x0
 522:	7cab8b93          	addi	s7,s7,1994 # ce8 <digits>
 526:	a839                	j	544 <vprintf+0x6a>
        putc(fd, c);
 528:	85ca                	mv	a1,s2
 52a:	8556                	mv	a0,s5
 52c:	00000097          	auipc	ra,0x0
 530:	ee0080e7          	jalr	-288(ra) # 40c <putc>
 534:	a019                	j	53a <vprintf+0x60>
    } else if(state == '%'){
 536:	01498d63          	beq	s3,s4,550 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 53a:	0485                	addi	s1,s1,1
 53c:	fff4c903          	lbu	s2,-1(s1)
 540:	14090d63          	beqz	s2,69a <vprintf+0x1c0>
    if(state == 0){
 544:	fe0999e3          	bnez	s3,536 <vprintf+0x5c>
      if(c == '%'){
 548:	ff4910e3          	bne	s2,s4,528 <vprintf+0x4e>
        state = '%';
 54c:	89d2                	mv	s3,s4
 54e:	b7f5                	j	53a <vprintf+0x60>
      if(c == 'd'){
 550:	11490c63          	beq	s2,s4,668 <vprintf+0x18e>
 554:	f9d9079b          	addiw	a5,s2,-99
 558:	0ff7f793          	zext.b	a5,a5
 55c:	10fc6e63          	bltu	s8,a5,678 <vprintf+0x19e>
 560:	f9d9079b          	addiw	a5,s2,-99
 564:	0ff7f713          	zext.b	a4,a5
 568:	10ec6863          	bltu	s8,a4,678 <vprintf+0x19e>
 56c:	00271793          	slli	a5,a4,0x2
 570:	97e6                	add	a5,a5,s9
 572:	439c                	lw	a5,0(a5)
 574:	97e6                	add	a5,a5,s9
 576:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 578:	008b0913          	addi	s2,s6,8
 57c:	4685                	li	a3,1
 57e:	4629                	li	a2,10
 580:	000b2583          	lw	a1,0(s6)
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	ea8080e7          	jalr	-344(ra) # 42e <printint>
 58e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 590:	4981                	li	s3,0
 592:	b765                	j	53a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 594:	008b0913          	addi	s2,s6,8
 598:	4681                	li	a3,0
 59a:	4629                	li	a2,10
 59c:	000b2583          	lw	a1,0(s6)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e8c080e7          	jalr	-372(ra) # 42e <printint>
 5aa:	8b4a                	mv	s6,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b771                	j	53a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5b0:	008b0913          	addi	s2,s6,8
 5b4:	4681                	li	a3,0
 5b6:	866a                	mv	a2,s10
 5b8:	000b2583          	lw	a1,0(s6)
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e70080e7          	jalr	-400(ra) # 42e <printint>
 5c6:	8b4a                	mv	s6,s2
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	bf85                	j	53a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5cc:	008b0793          	addi	a5,s6,8
 5d0:	f8f43423          	sd	a5,-120(s0)
 5d4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5d8:	03000593          	li	a1,48
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	e2e080e7          	jalr	-466(ra) # 40c <putc>
  putc(fd, 'x');
 5e6:	07800593          	li	a1,120
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	e20080e7          	jalr	-480(ra) # 40c <putc>
 5f4:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f6:	03c9d793          	srli	a5,s3,0x3c
 5fa:	97de                	add	a5,a5,s7
 5fc:	0007c583          	lbu	a1,0(a5)
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	e0a080e7          	jalr	-502(ra) # 40c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 60a:	0992                	slli	s3,s3,0x4
 60c:	397d                	addiw	s2,s2,-1
 60e:	fe0914e3          	bnez	s2,5f6 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 612:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 616:	4981                	li	s3,0
 618:	b70d                	j	53a <vprintf+0x60>
        s = va_arg(ap, char*);
 61a:	008b0913          	addi	s2,s6,8
 61e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 622:	02098163          	beqz	s3,644 <vprintf+0x16a>
        while(*s != 0){
 626:	0009c583          	lbu	a1,0(s3)
 62a:	c5ad                	beqz	a1,694 <vprintf+0x1ba>
          putc(fd, *s);
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	dde080e7          	jalr	-546(ra) # 40c <putc>
          s++;
 636:	0985                	addi	s3,s3,1
        while(*s != 0){
 638:	0009c583          	lbu	a1,0(s3)
 63c:	f9e5                	bnez	a1,62c <vprintf+0x152>
        s = va_arg(ap, char*);
 63e:	8b4a                	mv	s6,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	bde5                	j	53a <vprintf+0x60>
          s = "(null)";
 644:	00000997          	auipc	s3,0x0
 648:	64498993          	addi	s3,s3,1604 # c88 <close_file+0x54>
        while(*s != 0){
 64c:	85ee                	mv	a1,s11
 64e:	bff9                	j	62c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 650:	008b0913          	addi	s2,s6,8
 654:	000b4583          	lbu	a1,0(s6)
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	db2080e7          	jalr	-590(ra) # 40c <putc>
 662:	8b4a                	mv	s6,s2
      state = 0;
 664:	4981                	li	s3,0
 666:	bdd1                	j	53a <vprintf+0x60>
        putc(fd, c);
 668:	85d2                	mv	a1,s4
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	da0080e7          	jalr	-608(ra) # 40c <putc>
      state = 0;
 674:	4981                	li	s3,0
 676:	b5d1                	j	53a <vprintf+0x60>
        putc(fd, '%');
 678:	85d2                	mv	a1,s4
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	d90080e7          	jalr	-624(ra) # 40c <putc>
        putc(fd, c);
 684:	85ca                	mv	a1,s2
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	d84080e7          	jalr	-636(ra) # 40c <putc>
      state = 0;
 690:	4981                	li	s3,0
 692:	b565                	j	53a <vprintf+0x60>
        s = va_arg(ap, char*);
 694:	8b4a                	mv	s6,s2
      state = 0;
 696:	4981                	li	s3,0
 698:	b54d                	j	53a <vprintf+0x60>
    }
  }
}
 69a:	70e6                	ld	ra,120(sp)
 69c:	7446                	ld	s0,112(sp)
 69e:	74a6                	ld	s1,104(sp)
 6a0:	7906                	ld	s2,96(sp)
 6a2:	69e6                	ld	s3,88(sp)
 6a4:	6a46                	ld	s4,80(sp)
 6a6:	6aa6                	ld	s5,72(sp)
 6a8:	6b06                	ld	s6,64(sp)
 6aa:	7be2                	ld	s7,56(sp)
 6ac:	7c42                	ld	s8,48(sp)
 6ae:	7ca2                	ld	s9,40(sp)
 6b0:	7d02                	ld	s10,32(sp)
 6b2:	6de2                	ld	s11,24(sp)
 6b4:	6109                	addi	sp,sp,128
 6b6:	8082                	ret

00000000000006b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b8:	715d                	addi	sp,sp,-80
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e010                	sd	a2,0(s0)
 6c2:	e414                	sd	a3,8(s0)
 6c4:	e818                	sd	a4,16(s0)
 6c6:	ec1c                	sd	a5,24(s0)
 6c8:	03043023          	sd	a6,32(s0)
 6cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d4:	8622                	mv	a2,s0
 6d6:	00000097          	auipc	ra,0x0
 6da:	e04080e7          	jalr	-508(ra) # 4da <vprintf>
}
 6de:	60e2                	ld	ra,24(sp)
 6e0:	6442                	ld	s0,16(sp)
 6e2:	6161                	addi	sp,sp,80
 6e4:	8082                	ret

00000000000006e6 <printf>:

void
printf(const char *fmt, ...)
{
 6e6:	711d                	addi	sp,sp,-96
 6e8:	ec06                	sd	ra,24(sp)
 6ea:	e822                	sd	s0,16(sp)
 6ec:	1000                	addi	s0,sp,32
 6ee:	e40c                	sd	a1,8(s0)
 6f0:	e810                	sd	a2,16(s0)
 6f2:	ec14                	sd	a3,24(s0)
 6f4:	f018                	sd	a4,32(s0)
 6f6:	f41c                	sd	a5,40(s0)
 6f8:	03043823          	sd	a6,48(s0)
 6fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 700:	00840613          	addi	a2,s0,8
 704:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 708:	85aa                	mv	a1,a0
 70a:	4505                	li	a0,1
 70c:	00000097          	auipc	ra,0x0
 710:	dce080e7          	jalr	-562(ra) # 4da <vprintf>
}
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6125                	addi	sp,sp,96
 71a:	8082                	ret

000000000000071c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71c:	1141                	addi	sp,sp,-16
 71e:	e422                	sd	s0,8(sp)
 720:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 722:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 726:	00001797          	auipc	a5,0x1
 72a:	8da7b783          	ld	a5,-1830(a5) # 1000 <freep>
 72e:	a02d                	j	758 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 730:	4618                	lw	a4,8(a2)
 732:	9f2d                	addw	a4,a4,a1
 734:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 738:	6398                	ld	a4,0(a5)
 73a:	6310                	ld	a2,0(a4)
 73c:	a83d                	j	77a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 73e:	ff852703          	lw	a4,-8(a0)
 742:	9f31                	addw	a4,a4,a2
 744:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 746:	ff053683          	ld	a3,-16(a0)
 74a:	a091                	j	78e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74c:	6398                	ld	a4,0(a5)
 74e:	00e7e463          	bltu	a5,a4,756 <free+0x3a>
 752:	00e6ea63          	bltu	a3,a4,766 <free+0x4a>
{
 756:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	fed7fae3          	bgeu	a5,a3,74c <free+0x30>
 75c:	6398                	ld	a4,0(a5)
 75e:	00e6e463          	bltu	a3,a4,766 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 762:	fee7eae3          	bltu	a5,a4,756 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 766:	ff852583          	lw	a1,-8(a0)
 76a:	6390                	ld	a2,0(a5)
 76c:	02059813          	slli	a6,a1,0x20
 770:	01c85713          	srli	a4,a6,0x1c
 774:	9736                	add	a4,a4,a3
 776:	fae60de3          	beq	a2,a4,730 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 77a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 77e:	4790                	lw	a2,8(a5)
 780:	02061593          	slli	a1,a2,0x20
 784:	01c5d713          	srli	a4,a1,0x1c
 788:	973e                	add	a4,a4,a5
 78a:	fae68ae3          	beq	a3,a4,73e <free+0x22>
    p->s.ptr = bp->s.ptr;
 78e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 790:	00001717          	auipc	a4,0x1
 794:	86f73823          	sd	a5,-1936(a4) # 1000 <freep>
}
 798:	6422                	ld	s0,8(sp)
 79a:	0141                	addi	sp,sp,16
 79c:	8082                	ret

000000000000079e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 79e:	7139                	addi	sp,sp,-64
 7a0:	fc06                	sd	ra,56(sp)
 7a2:	f822                	sd	s0,48(sp)
 7a4:	f426                	sd	s1,40(sp)
 7a6:	f04a                	sd	s2,32(sp)
 7a8:	ec4e                	sd	s3,24(sp)
 7aa:	e852                	sd	s4,16(sp)
 7ac:	e456                	sd	s5,8(sp)
 7ae:	e05a                	sd	s6,0(sp)
 7b0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b2:	02051493          	slli	s1,a0,0x20
 7b6:	9081                	srli	s1,s1,0x20
 7b8:	04bd                	addi	s1,s1,15
 7ba:	8091                	srli	s1,s1,0x4
 7bc:	0014899b          	addiw	s3,s1,1
 7c0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c2:	00001517          	auipc	a0,0x1
 7c6:	83e53503          	ld	a0,-1986(a0) # 1000 <freep>
 7ca:	c515                	beqz	a0,7f6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ce:	4798                	lw	a4,8(a5)
 7d0:	02977f63          	bgeu	a4,s1,80e <malloc+0x70>
 7d4:	8a4e                	mv	s4,s3
 7d6:	0009871b          	sext.w	a4,s3
 7da:	6685                	lui	a3,0x1
 7dc:	00d77363          	bgeu	a4,a3,7e2 <malloc+0x44>
 7e0:	6a05                	lui	s4,0x1
 7e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ea:	00001917          	auipc	s2,0x1
 7ee:	81690913          	addi	s2,s2,-2026 # 1000 <freep>
  if(p == (char*)-1)
 7f2:	5afd                	li	s5,-1
 7f4:	a895                	j	868 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7f6:	00001797          	auipc	a5,0x1
 7fa:	81a78793          	addi	a5,a5,-2022 # 1010 <base>
 7fe:	00001717          	auipc	a4,0x1
 802:	80f73123          	sd	a5,-2046(a4) # 1000 <freep>
 806:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 808:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 80c:	b7e1                	j	7d4 <malloc+0x36>
      if(p->s.size == nunits)
 80e:	02e48c63          	beq	s1,a4,846 <malloc+0xa8>
        p->s.size -= nunits;
 812:	4137073b          	subw	a4,a4,s3
 816:	c798                	sw	a4,8(a5)
        p += p->s.size;
 818:	02071693          	slli	a3,a4,0x20
 81c:	01c6d713          	srli	a4,a3,0x1c
 820:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 822:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 826:	00000717          	auipc	a4,0x0
 82a:	7ca73d23          	sd	a0,2010(a4) # 1000 <freep>
      return (void*)(p + 1);
 82e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 832:	70e2                	ld	ra,56(sp)
 834:	7442                	ld	s0,48(sp)
 836:	74a2                	ld	s1,40(sp)
 838:	7902                	ld	s2,32(sp)
 83a:	69e2                	ld	s3,24(sp)
 83c:	6a42                	ld	s4,16(sp)
 83e:	6aa2                	ld	s5,8(sp)
 840:	6b02                	ld	s6,0(sp)
 842:	6121                	addi	sp,sp,64
 844:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 846:	6398                	ld	a4,0(a5)
 848:	e118                	sd	a4,0(a0)
 84a:	bff1                	j	826 <malloc+0x88>
  hp->s.size = nu;
 84c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 850:	0541                	addi	a0,a0,16
 852:	00000097          	auipc	ra,0x0
 856:	eca080e7          	jalr	-310(ra) # 71c <free>
  return freep;
 85a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 85e:	d971                	beqz	a0,832 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 860:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 862:	4798                	lw	a4,8(a5)
 864:	fa9775e3          	bgeu	a4,s1,80e <malloc+0x70>
    if(p == freep)
 868:	00093703          	ld	a4,0(s2)
 86c:	853e                	mv	a0,a5
 86e:	fef719e3          	bne	a4,a5,860 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 872:	8552                	mv	a0,s4
 874:	00000097          	auipc	ra,0x0
 878:	b70080e7          	jalr	-1168(ra) # 3e4 <sbrk>
  if(p == (char*)-1)
 87c:	fd5518e3          	bne	a0,s5,84c <malloc+0xae>
        return 0;
 880:	4501                	li	a0,0
 882:	bf45                	j	832 <malloc+0x94>

0000000000000884 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 884:	c1d9                	beqz	a1,90a <head_run+0x86>
void head_run(int fd, int numOfLines){
 886:	dd010113          	addi	sp,sp,-560
 88a:	22113423          	sd	ra,552(sp)
 88e:	22813023          	sd	s0,544(sp)
 892:	20913c23          	sd	s1,536(sp)
 896:	21213823          	sd	s2,528(sp)
 89a:	21313423          	sd	s3,520(sp)
 89e:	21413023          	sd	s4,512(sp)
 8a2:	1c00                	addi	s0,sp,560
 8a4:	892a                	mv	s2,a0
 8a6:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 8aa:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 8ac:	00000a17          	auipc	s4,0x0
 8b0:	47ca0a13          	addi	s4,s4,1148 # d28 <digits+0x40>
		readStatus = read_line(fd, line);
 8b4:	dd840593          	addi	a1,s0,-552
 8b8:	854a                	mv	a0,s2
 8ba:	00000097          	auipc	ra,0x0
 8be:	318080e7          	jalr	792(ra) # bd2 <read_line>
		if (readStatus == READ_ERROR){
 8c2:	01350d63          	beq	a0,s3,8dc <head_run+0x58>
		if (readStatus == READ_EOF)
 8c6:	c11d                	beqz	a0,8ec <head_run+0x68>
		printf("%s",line);
 8c8:	dd840593          	addi	a1,s0,-552
 8cc:	8552                	mv	a0,s4
 8ce:	00000097          	auipc	ra,0x0
 8d2:	e18080e7          	jalr	-488(ra) # 6e6 <printf>
	while(numOfLines--){
 8d6:	34fd                	addiw	s1,s1,-1
 8d8:	fcf1                	bnez	s1,8b4 <head_run+0x30>
 8da:	a809                	j	8ec <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 8dc:	00000517          	auipc	a0,0x0
 8e0:	42450513          	addi	a0,a0,1060 # d00 <digits+0x18>
 8e4:	00000097          	auipc	ra,0x0
 8e8:	e02080e7          	jalr	-510(ra) # 6e6 <printf>

	}
}
 8ec:	22813083          	ld	ra,552(sp)
 8f0:	22013403          	ld	s0,544(sp)
 8f4:	21813483          	ld	s1,536(sp)
 8f8:	21013903          	ld	s2,528(sp)
 8fc:	20813983          	ld	s3,520(sp)
 900:	20013a03          	ld	s4,512(sp)
 904:	23010113          	addi	sp,sp,560
 908:	8082                	ret
 90a:	8082                	ret

000000000000090c <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 90c:	ba010113          	addi	sp,sp,-1120
 910:	44113c23          	sd	ra,1112(sp)
 914:	44813823          	sd	s0,1104(sp)
 918:	44913423          	sd	s1,1096(sp)
 91c:	45213023          	sd	s2,1088(sp)
 920:	43313c23          	sd	s3,1080(sp)
 924:	43413823          	sd	s4,1072(sp)
 928:	43513423          	sd	s5,1064(sp)
 92c:	43613023          	sd	s6,1056(sp)
 930:	41713c23          	sd	s7,1048(sp)
 934:	41813823          	sd	s8,1040(sp)
 938:	41913423          	sd	s9,1032(sp)
 93c:	41a13023          	sd	s10,1024(sp)
 940:	3fb13c23          	sd	s11,1016(sp)
 944:	46010413          	addi	s0,sp,1120
 948:	89aa                	mv	s3,a0
 94a:	8aae                	mv	s5,a1
 94c:	8c32                	mv	s8,a2
 94e:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 950:	d9840593          	addi	a1,s0,-616
 954:	00000097          	auipc	ra,0x0
 958:	27e080e7          	jalr	638(ra) # bd2 <read_line>


  if (readStatus == READ_ERROR)
 95c:	57fd                	li	a5,-1
 95e:	04f50163          	beq	a0,a5,9a0 <uniq_run+0x94>
 962:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 964:	ed21                	bnez	a0,9bc <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 966:	45813083          	ld	ra,1112(sp)
 96a:	45013403          	ld	s0,1104(sp)
 96e:	44813483          	ld	s1,1096(sp)
 972:	44013903          	ld	s2,1088(sp)
 976:	43813983          	ld	s3,1080(sp)
 97a:	43013a03          	ld	s4,1072(sp)
 97e:	42813a83          	ld	s5,1064(sp)
 982:	42013b03          	ld	s6,1056(sp)
 986:	41813b83          	ld	s7,1048(sp)
 98a:	41013c03          	ld	s8,1040(sp)
 98e:	40813c83          	ld	s9,1032(sp)
 992:	40013d03          	ld	s10,1024(sp)
 996:	3f813d83          	ld	s11,1016(sp)
 99a:	46010113          	addi	sp,sp,1120
 99e:	8082                	ret
    printf("[ERR] Error reading from the file ");
 9a0:	00000517          	auipc	a0,0x0
 9a4:	39050513          	addi	a0,a0,912 # d30 <digits+0x48>
 9a8:	00000097          	auipc	ra,0x0
 9ac:	d3e080e7          	jalr	-706(ra) # 6e6 <printf>
 9b0:	bf5d                	j	966 <uniq_run+0x5a>
 9b2:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 9b4:	8926                	mv	s2,s1
 9b6:	84be                	mv	s1,a5
        lineCount = 1;
 9b8:	8b6a                	mv	s6,s10
 9ba:	a8ed                	j	ab4 <uniq_run+0x1a8>
    int lineCount=1;
 9bc:	4b05                	li	s6,1
  char * line2 = buffer2;
 9be:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 9c2:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 9c6:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 9c8:	4d05                	li	s10,1
              printf("%s",line1);
 9ca:	00000d97          	auipc	s11,0x0
 9ce:	35ed8d93          	addi	s11,s11,862 # d28 <digits+0x40>
 9d2:	a0cd                	j	ab4 <uniq_run+0x1a8>
            if (repeatedLines){
 9d4:	020a0b63          	beqz	s4,a0a <uniq_run+0xfe>
                if (isRepeated){
 9d8:	f80b87e3          	beqz	s7,966 <uniq_run+0x5a>
                    if (showCount)
 9dc:	000c0d63          	beqz	s8,9f6 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 9e0:	864a                	mv	a2,s2
 9e2:	85da                	mv	a1,s6
 9e4:	00000517          	auipc	a0,0x0
 9e8:	37450513          	addi	a0,a0,884 # d58 <digits+0x70>
 9ec:	00000097          	auipc	ra,0x0
 9f0:	cfa080e7          	jalr	-774(ra) # 6e6 <printf>
 9f4:	bf8d                	j	966 <uniq_run+0x5a>
                      printf("%s",line1);
 9f6:	85ca                	mv	a1,s2
 9f8:	00000517          	auipc	a0,0x0
 9fc:	33050513          	addi	a0,a0,816 # d28 <digits+0x40>
 a00:	00000097          	auipc	ra,0x0
 a04:	ce6080e7          	jalr	-794(ra) # 6e6 <printf>
 a08:	bfb9                	j	966 <uniq_run+0x5a>
                if (showCount)
 a0a:	000c0d63          	beqz	s8,a24 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 a0e:	864a                	mv	a2,s2
 a10:	85da                	mv	a1,s6
 a12:	00000517          	auipc	a0,0x0
 a16:	34650513          	addi	a0,a0,838 # d58 <digits+0x70>
 a1a:	00000097          	auipc	ra,0x0
 a1e:	ccc080e7          	jalr	-820(ra) # 6e6 <printf>
 a22:	b791                	j	966 <uniq_run+0x5a>
                  printf("%s",line1);
 a24:	85ca                	mv	a1,s2
 a26:	00000517          	auipc	a0,0x0
 a2a:	30250513          	addi	a0,a0,770 # d28 <digits+0x40>
 a2e:	00000097          	auipc	ra,0x0
 a32:	cb8080e7          	jalr	-840(ra) # 6e6 <printf>
 a36:	bf05                	j	966 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 a38:	00000517          	auipc	a0,0x0
 a3c:	32850513          	addi	a0,a0,808 # d60 <digits+0x78>
 a40:	00000097          	auipc	ra,0x0
 a44:	ca6080e7          	jalr	-858(ra) # 6e6 <printf>
          break;
 a48:	bf39                	j	966 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 a4a:	85a6                	mv	a1,s1
 a4c:	854a                	mv	a0,s2
 a4e:	00000097          	auipc	ra,0x0
 a52:	110080e7          	jalr	272(ra) # b5e <compare_str_ic>
 a56:	a041                	j	ad6 <uniq_run+0x1ca>
                  printf("%s",line1);
 a58:	85ca                	mv	a1,s2
 a5a:	856e                	mv	a0,s11
 a5c:	00000097          	auipc	ra,0x0
 a60:	c8a080e7          	jalr	-886(ra) # 6e6 <printf>
        lineCount = 1;
 a64:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 a66:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a68:	8926                	mv	s2,s1
                  printf("%s",line1);
 a6a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a6c:	4b81                	li	s7,0
 a6e:	a099                	j	ab4 <uniq_run+0x1a8>
            if (showCount)
 a70:	020c0263          	beqz	s8,a94 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 a74:	864a                	mv	a2,s2
 a76:	85da                	mv	a1,s6
 a78:	00000517          	auipc	a0,0x0
 a7c:	2e050513          	addi	a0,a0,736 # d58 <digits+0x70>
 a80:	00000097          	auipc	ra,0x0
 a84:	c66080e7          	jalr	-922(ra) # 6e6 <printf>
 a88:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a8a:	8926                	mv	s2,s1
 a8c:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a8e:	4b81                	li	s7,0
        lineCount = 1;
 a90:	8b6a                	mv	s6,s10
 a92:	a00d                	j	ab4 <uniq_run+0x1a8>
              printf("%s",line1);
 a94:	85ca                	mv	a1,s2
 a96:	856e                	mv	a0,s11
 a98:	00000097          	auipc	ra,0x0
 a9c:	c4e080e7          	jalr	-946(ra) # 6e6 <printf>
 aa0:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 aa2:	8926                	mv	s2,s1
              printf("%s",line1);
 aa4:	84be                	mv	s1,a5
        isRepeated = 0 ;
 aa6:	4b81                	li	s7,0
        lineCount = 1;
 aa8:	8b6a                	mv	s6,s10
 aaa:	a029                	j	ab4 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 aac:	000a0363          	beqz	s4,ab2 <uniq_run+0x1a6>
 ab0:	8bea                	mv	s7,s10
          lineCount++;
 ab2:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 ab4:	85a6                	mv	a1,s1
 ab6:	854e                	mv	a0,s3
 ab8:	00000097          	auipc	ra,0x0
 abc:	11a080e7          	jalr	282(ra) # bd2 <read_line>
        if (readStatus == READ_EOF){
 ac0:	d911                	beqz	a0,9d4 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 ac2:	f7950be3          	beq	a0,s9,a38 <uniq_run+0x12c>
        if (!ignoreCase)
 ac6:	f80a92e3          	bnez	s5,a4a <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 aca:	85a6                	mv	a1,s1
 acc:	854a                	mv	a0,s2
 ace:	00000097          	auipc	ra,0x0
 ad2:	062080e7          	jalr	98(ra) # b30 <compare_str>
        if (compareStatus != 0){ 
 ad6:	d979                	beqz	a0,aac <uniq_run+0x1a0>
          if (repeatedLines){
 ad8:	f80a0ce3          	beqz	s4,a70 <uniq_run+0x164>
            if (isRepeated){
 adc:	ec0b8be3          	beqz	s7,9b2 <uniq_run+0xa6>
                if (showCount)
 ae0:	f60c0ce3          	beqz	s8,a58 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 ae4:	864a                	mv	a2,s2
 ae6:	85da                	mv	a1,s6
 ae8:	00000517          	auipc	a0,0x0
 aec:	27050513          	addi	a0,a0,624 # d58 <digits+0x70>
 af0:	00000097          	auipc	ra,0x0
 af4:	bf6080e7          	jalr	-1034(ra) # 6e6 <printf>
        lineCount = 1;
 af8:	8b5e                	mv	s6,s7
 afa:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 afc:	8926                	mv	s2,s1
 afe:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b00:	4b81                	li	s7,0
 b02:	bf4d                	j	ab4 <uniq_run+0x1a8>

0000000000000b04 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 b04:	1141                	addi	sp,sp,-16
 b06:	e422                	sd	s0,8(sp)
 b08:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 b0a:	00054783          	lbu	a5,0(a0)
 b0e:	cf99                	beqz	a5,b2c <get_strlen+0x28>
 b10:	00150713          	addi	a4,a0,1
 b14:	87ba                	mv	a5,a4
 b16:	4685                	li	a3,1
 b18:	9e99                	subw	a3,a3,a4
 b1a:	00f6853b          	addw	a0,a3,a5
 b1e:	0785                	addi	a5,a5,1
 b20:	fff7c703          	lbu	a4,-1(a5)
 b24:	fb7d                	bnez	a4,b1a <get_strlen+0x16>
	return len;
}
 b26:	6422                	ld	s0,8(sp)
 b28:	0141                	addi	sp,sp,16
 b2a:	8082                	ret
	int len = 0;
 b2c:	4501                	li	a0,0
 b2e:	bfe5                	j	b26 <get_strlen+0x22>

0000000000000b30 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 b30:	1141                	addi	sp,sp,-16
 b32:	e422                	sd	s0,8(sp)
 b34:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 b36:	00054783          	lbu	a5,0(a0)
 b3a:	cb91                	beqz	a5,b4e <compare_str+0x1e>
 b3c:	0005c703          	lbu	a4,0(a1)
 b40:	c719                	beqz	a4,b4e <compare_str+0x1e>
		if (*s1++ != *s2++)
 b42:	0505                	addi	a0,a0,1
 b44:	0585                	addi	a1,a1,1
 b46:	fee788e3          	beq	a5,a4,b36 <compare_str+0x6>
			return 1;
 b4a:	4505                	li	a0,1
 b4c:	a031                	j	b58 <compare_str+0x28>
	}
	if (*s1 == *s2)
 b4e:	0005c503          	lbu	a0,0(a1)
 b52:	8d1d                	sub	a0,a0,a5
			return 1;
 b54:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b58:	6422                	ld	s0,8(sp)
 b5a:	0141                	addi	sp,sp,16
 b5c:	8082                	ret

0000000000000b5e <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 b5e:	1141                	addi	sp,sp,-16
 b60:	e422                	sd	s0,8(sp)
 b62:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b64:	4665                	li	a2,25
	while(*s1 && *s2){
 b66:	a019                	j	b6c <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b68:	04e79763          	bne	a5,a4,bb6 <compare_str_ic+0x58>
	while(*s1 && *s2){
 b6c:	00054783          	lbu	a5,0(a0)
 b70:	cb9d                	beqz	a5,ba6 <compare_str_ic+0x48>
 b72:	0005c703          	lbu	a4,0(a1)
 b76:	cb05                	beqz	a4,ba6 <compare_str_ic+0x48>
		char b1 = *s1++;
 b78:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 b7a:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b7c:	fbf7869b          	addiw	a3,a5,-65
 b80:	0ff6f693          	zext.b	a3,a3
 b84:	00d66663          	bltu	a2,a3,b90 <compare_str_ic+0x32>
			b1 += 32;
 b88:	0207879b          	addiw	a5,a5,32
 b8c:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 b90:	fbf7069b          	addiw	a3,a4,-65
 b94:	0ff6f693          	zext.b	a3,a3
 b98:	fcd668e3          	bltu	a2,a3,b68 <compare_str_ic+0xa>
			b2 += 32;
 b9c:	0207071b          	addiw	a4,a4,32
 ba0:	0ff77713          	zext.b	a4,a4
 ba4:	b7d1                	j	b68 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 ba6:	0005c503          	lbu	a0,0(a1)
 baa:	8d1d                	sub	a0,a0,a5
			return 1;
 bac:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 bb0:	6422                	ld	s0,8(sp)
 bb2:	0141                	addi	sp,sp,16
 bb4:	8082                	ret
			return 1;
 bb6:	4505                	li	a0,1
 bb8:	bfe5                	j	bb0 <compare_str_ic+0x52>

0000000000000bba <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 bba:	1141                	addi	sp,sp,-16
 bbc:	e406                	sd	ra,8(sp)
 bbe:	e022                	sd	s0,0(sp)
 bc0:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 bc2:	fffff097          	auipc	ra,0xfffff
 bc6:	7da080e7          	jalr	2010(ra) # 39c <open>
	return fd;
}
 bca:	60a2                	ld	ra,8(sp)
 bcc:	6402                	ld	s0,0(sp)
 bce:	0141                	addi	sp,sp,16
 bd0:	8082                	ret

0000000000000bd2 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 bd2:	7139                	addi	sp,sp,-64
 bd4:	fc06                	sd	ra,56(sp)
 bd6:	f822                	sd	s0,48(sp)
 bd8:	f426                	sd	s1,40(sp)
 bda:	f04a                	sd	s2,32(sp)
 bdc:	ec4e                	sd	s3,24(sp)
 bde:	e852                	sd	s4,16(sp)
 be0:	0080                	addi	s0,sp,64
 be2:	89aa                	mv	s3,a0
 be4:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 be6:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 be8:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 bea:	4605                	li	a2,1
 bec:	fcf40593          	addi	a1,s0,-49
 bf0:	854e                	mv	a0,s3
 bf2:	fffff097          	auipc	ra,0xfffff
 bf6:	782080e7          	jalr	1922(ra) # 374 <read>
		if (readStatus == 0){
 bfa:	c505                	beqz	a0,c22 <read_line+0x50>
		*buffer++ = readByte;
 bfc:	0485                	addi	s1,s1,1
 bfe:	fcf44783          	lbu	a5,-49(s0)
 c02:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c06:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c08:	ff4791e3          	bne	a5,s4,bea <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 c0c:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 c10:	854a                	mv	a0,s2
 c12:	70e2                	ld	ra,56(sp)
 c14:	7442                	ld	s0,48(sp)
 c16:	74a2                	ld	s1,40(sp)
 c18:	7902                	ld	s2,32(sp)
 c1a:	69e2                	ld	s3,24(sp)
 c1c:	6a42                	ld	s4,16(sp)
 c1e:	6121                	addi	sp,sp,64
 c20:	8082                	ret
			if (byteCount!=0){
 c22:	fe0907e3          	beqz	s2,c10 <read_line+0x3e>
				*buffer = '\n';
 c26:	47a9                	li	a5,10
 c28:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 c2c:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 c30:	2905                	addiw	s2,s2,1
 c32:	bff9                	j	c10 <read_line+0x3e>

0000000000000c34 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 c34:	1141                	addi	sp,sp,-16
 c36:	e406                	sd	ra,8(sp)
 c38:	e022                	sd	s0,0(sp)
 c3a:	0800                	addi	s0,sp,16
	close(fd);
 c3c:	fffff097          	auipc	ra,0xfffff
 c40:	748080e7          	jalr	1864(ra) # 384 <close>
}
 c44:	60a2                	ld	ra,8(sp)
 c46:	6402                	ld	s0,0(sp)
 c48:	0141                	addi	sp,sp,16
 c4a:	8082                	ret
