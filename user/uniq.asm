
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
  20:	79a080e7          	jalr	1946(ra) # 7b6 <malloc>

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
  3a:	d0a98993          	addi	s3,s3,-758 # d40 <get_time_perf+0x60>
			*options |= OPT_SHOW_COUNT;
		else if (!compare_str(cmd[0], "-i"))
  3e:	00001a97          	auipc	s5,0x1
  42:	d0aa8a93          	addi	s5,s5,-758 # d48 <get_time_perf+0x68>
			*options |= OPT_IGNORE_CASE;
		else if (!compare_str(cmd[0], "-d"))
  46:	00001b97          	auipc	s7,0x1
  4a:	d0ab8b93          	addi	s7,s7,-758 # d50 <get_time_perf+0x70>
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
  60:	aec080e7          	jalr	-1300(ra) # b48 <compare_str>
  64:	d575                	beqz	a0,50 <main+0x50>
		else if (!compare_str(cmd[0], "-i"))
  66:	85d6                	mv	a1,s5
  68:	6088                	ld	a0,0(s1)
  6a:	00001097          	auipc	ra,0x1
  6e:	ade080e7          	jalr	-1314(ra) # b48 <compare_str>
  72:	e501                	bnez	a0,7a <main+0x7a>
			*options |= OPT_IGNORE_CASE;
  74:	00196913          	ori	s2,s2,1
  78:	bff1                	j	54 <main+0x54>
		else if (!compare_str(cmd[0], "-d"))
  7a:	85de                	mv	a1,s7
  7c:	6088                	ld	a0,0(s1)
  7e:	00001097          	auipc	ra,0x1
  82:	aca080e7          	jalr	-1334(ra) # b48 <compare_str>
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
  c6:	c9650513          	addi	a0,a0,-874 # d58 <get_time_perf+0x78>
  ca:	00000097          	auipc	ra,0x0
  ce:	634080e7          	jalr	1588(ra) # 6fe <printf>
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

000000000000040c <ps>:
.global ps
ps:
 li a7, SYS_ps
 40c:	48e1                	li	a7,24
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <times>:
.global times
times:
 li a7, SYS_times
 414:	48e5                	li	a7,25
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 41c:	48e9                	li	a7,26
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 424:	1101                	addi	sp,sp,-32
 426:	ec06                	sd	ra,24(sp)
 428:	e822                	sd	s0,16(sp)
 42a:	1000                	addi	s0,sp,32
 42c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 430:	4605                	li	a2,1
 432:	fef40593          	addi	a1,s0,-17
 436:	00000097          	auipc	ra,0x0
 43a:	f46080e7          	jalr	-186(ra) # 37c <write>
}
 43e:	60e2                	ld	ra,24(sp)
 440:	6442                	ld	s0,16(sp)
 442:	6105                	addi	sp,sp,32
 444:	8082                	ret

0000000000000446 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 446:	7139                	addi	sp,sp,-64
 448:	fc06                	sd	ra,56(sp)
 44a:	f822                	sd	s0,48(sp)
 44c:	f426                	sd	s1,40(sp)
 44e:	f04a                	sd	s2,32(sp)
 450:	ec4e                	sd	s3,24(sp)
 452:	0080                	addi	s0,sp,64
 454:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 456:	c299                	beqz	a3,45c <printint+0x16>
 458:	0805c963          	bltz	a1,4ea <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 45c:	2581                	sext.w	a1,a1
  neg = 0;
 45e:	4881                	li	a7,0
 460:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 464:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 466:	2601                	sext.w	a2,a2
 468:	00001517          	auipc	a0,0x1
 46c:	97050513          	addi	a0,a0,-1680 # dd8 <digits>
 470:	883a                	mv	a6,a4
 472:	2705                	addiw	a4,a4,1
 474:	02c5f7bb          	remuw	a5,a1,a2
 478:	1782                	slli	a5,a5,0x20
 47a:	9381                	srli	a5,a5,0x20
 47c:	97aa                	add	a5,a5,a0
 47e:	0007c783          	lbu	a5,0(a5)
 482:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 486:	0005879b          	sext.w	a5,a1
 48a:	02c5d5bb          	divuw	a1,a1,a2
 48e:	0685                	addi	a3,a3,1
 490:	fec7f0e3          	bgeu	a5,a2,470 <printint+0x2a>
  if(neg)
 494:	00088c63          	beqz	a7,4ac <printint+0x66>
    buf[i++] = '-';
 498:	fd070793          	addi	a5,a4,-48
 49c:	00878733          	add	a4,a5,s0
 4a0:	02d00793          	li	a5,45
 4a4:	fef70823          	sb	a5,-16(a4)
 4a8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ac:	02e05863          	blez	a4,4dc <printint+0x96>
 4b0:	fc040793          	addi	a5,s0,-64
 4b4:	00e78933          	add	s2,a5,a4
 4b8:	fff78993          	addi	s3,a5,-1
 4bc:	99ba                	add	s3,s3,a4
 4be:	377d                	addiw	a4,a4,-1
 4c0:	1702                	slli	a4,a4,0x20
 4c2:	9301                	srli	a4,a4,0x20
 4c4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c8:	fff94583          	lbu	a1,-1(s2)
 4cc:	8526                	mv	a0,s1
 4ce:	00000097          	auipc	ra,0x0
 4d2:	f56080e7          	jalr	-170(ra) # 424 <putc>
  while(--i >= 0)
 4d6:	197d                	addi	s2,s2,-1
 4d8:	ff3918e3          	bne	s2,s3,4c8 <printint+0x82>
}
 4dc:	70e2                	ld	ra,56(sp)
 4de:	7442                	ld	s0,48(sp)
 4e0:	74a2                	ld	s1,40(sp)
 4e2:	7902                	ld	s2,32(sp)
 4e4:	69e2                	ld	s3,24(sp)
 4e6:	6121                	addi	sp,sp,64
 4e8:	8082                	ret
    x = -xx;
 4ea:	40b005bb          	negw	a1,a1
    neg = 1;
 4ee:	4885                	li	a7,1
    x = -xx;
 4f0:	bf85                	j	460 <printint+0x1a>

00000000000004f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f2:	7119                	addi	sp,sp,-128
 4f4:	fc86                	sd	ra,120(sp)
 4f6:	f8a2                	sd	s0,112(sp)
 4f8:	f4a6                	sd	s1,104(sp)
 4fa:	f0ca                	sd	s2,96(sp)
 4fc:	ecce                	sd	s3,88(sp)
 4fe:	e8d2                	sd	s4,80(sp)
 500:	e4d6                	sd	s5,72(sp)
 502:	e0da                	sd	s6,64(sp)
 504:	fc5e                	sd	s7,56(sp)
 506:	f862                	sd	s8,48(sp)
 508:	f466                	sd	s9,40(sp)
 50a:	f06a                	sd	s10,32(sp)
 50c:	ec6e                	sd	s11,24(sp)
 50e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 510:	0005c903          	lbu	s2,0(a1)
 514:	18090f63          	beqz	s2,6b2 <vprintf+0x1c0>
 518:	8aaa                	mv	s5,a0
 51a:	8b32                	mv	s6,a2
 51c:	00158493          	addi	s1,a1,1
  state = 0;
 520:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 522:	02500a13          	li	s4,37
 526:	4c55                	li	s8,21
 528:	00001c97          	auipc	s9,0x1
 52c:	858c8c93          	addi	s9,s9,-1960 # d80 <get_time_perf+0xa0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 530:	02800d93          	li	s11,40
  putc(fd, 'x');
 534:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 536:	00001b97          	auipc	s7,0x1
 53a:	8a2b8b93          	addi	s7,s7,-1886 # dd8 <digits>
 53e:	a839                	j	55c <vprintf+0x6a>
        putc(fd, c);
 540:	85ca                	mv	a1,s2
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	ee0080e7          	jalr	-288(ra) # 424 <putc>
 54c:	a019                	j	552 <vprintf+0x60>
    } else if(state == '%'){
 54e:	01498d63          	beq	s3,s4,568 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 552:	0485                	addi	s1,s1,1
 554:	fff4c903          	lbu	s2,-1(s1)
 558:	14090d63          	beqz	s2,6b2 <vprintf+0x1c0>
    if(state == 0){
 55c:	fe0999e3          	bnez	s3,54e <vprintf+0x5c>
      if(c == '%'){
 560:	ff4910e3          	bne	s2,s4,540 <vprintf+0x4e>
        state = '%';
 564:	89d2                	mv	s3,s4
 566:	b7f5                	j	552 <vprintf+0x60>
      if(c == 'd'){
 568:	11490c63          	beq	s2,s4,680 <vprintf+0x18e>
 56c:	f9d9079b          	addiw	a5,s2,-99
 570:	0ff7f793          	zext.b	a5,a5
 574:	10fc6e63          	bltu	s8,a5,690 <vprintf+0x19e>
 578:	f9d9079b          	addiw	a5,s2,-99
 57c:	0ff7f713          	zext.b	a4,a5
 580:	10ec6863          	bltu	s8,a4,690 <vprintf+0x19e>
 584:	00271793          	slli	a5,a4,0x2
 588:	97e6                	add	a5,a5,s9
 58a:	439c                	lw	a5,0(a5)
 58c:	97e6                	add	a5,a5,s9
 58e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 590:	008b0913          	addi	s2,s6,8
 594:	4685                	li	a3,1
 596:	4629                	li	a2,10
 598:	000b2583          	lw	a1,0(s6)
 59c:	8556                	mv	a0,s5
 59e:	00000097          	auipc	ra,0x0
 5a2:	ea8080e7          	jalr	-344(ra) # 446 <printint>
 5a6:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b765                	j	552 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ac:	008b0913          	addi	s2,s6,8
 5b0:	4681                	li	a3,0
 5b2:	4629                	li	a2,10
 5b4:	000b2583          	lw	a1,0(s6)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	e8c080e7          	jalr	-372(ra) # 446 <printint>
 5c2:	8b4a                	mv	s6,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b771                	j	552 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5c8:	008b0913          	addi	s2,s6,8
 5cc:	4681                	li	a3,0
 5ce:	866a                	mv	a2,s10
 5d0:	000b2583          	lw	a1,0(s6)
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	e70080e7          	jalr	-400(ra) # 446 <printint>
 5de:	8b4a                	mv	s6,s2
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	bf85                	j	552 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5e4:	008b0793          	addi	a5,s6,8
 5e8:	f8f43423          	sd	a5,-120(s0)
 5ec:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5f0:	03000593          	li	a1,48
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e2e080e7          	jalr	-466(ra) # 424 <putc>
  putc(fd, 'x');
 5fe:	07800593          	li	a1,120
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e20080e7          	jalr	-480(ra) # 424 <putc>
 60c:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60e:	03c9d793          	srli	a5,s3,0x3c
 612:	97de                	add	a5,a5,s7
 614:	0007c583          	lbu	a1,0(a5)
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e0a080e7          	jalr	-502(ra) # 424 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 622:	0992                	slli	s3,s3,0x4
 624:	397d                	addiw	s2,s2,-1
 626:	fe0914e3          	bnez	s2,60e <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 62a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 62e:	4981                	li	s3,0
 630:	b70d                	j	552 <vprintf+0x60>
        s = va_arg(ap, char*);
 632:	008b0913          	addi	s2,s6,8
 636:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 63a:	02098163          	beqz	s3,65c <vprintf+0x16a>
        while(*s != 0){
 63e:	0009c583          	lbu	a1,0(s3)
 642:	c5ad                	beqz	a1,6ac <vprintf+0x1ba>
          putc(fd, *s);
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	dde080e7          	jalr	-546(ra) # 424 <putc>
          s++;
 64e:	0985                	addi	s3,s3,1
        while(*s != 0){
 650:	0009c583          	lbu	a1,0(s3)
 654:	f9e5                	bnez	a1,644 <vprintf+0x152>
        s = va_arg(ap, char*);
 656:	8b4a                	mv	s6,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	bde5                	j	552 <vprintf+0x60>
          s = "(null)";
 65c:	00000997          	auipc	s3,0x0
 660:	71c98993          	addi	s3,s3,1820 # d78 <get_time_perf+0x98>
        while(*s != 0){
 664:	85ee                	mv	a1,s11
 666:	bff9                	j	644 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 668:	008b0913          	addi	s2,s6,8
 66c:	000b4583          	lbu	a1,0(s6)
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	db2080e7          	jalr	-590(ra) # 424 <putc>
 67a:	8b4a                	mv	s6,s2
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bdd1                	j	552 <vprintf+0x60>
        putc(fd, c);
 680:	85d2                	mv	a1,s4
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	da0080e7          	jalr	-608(ra) # 424 <putc>
      state = 0;
 68c:	4981                	li	s3,0
 68e:	b5d1                	j	552 <vprintf+0x60>
        putc(fd, '%');
 690:	85d2                	mv	a1,s4
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	d90080e7          	jalr	-624(ra) # 424 <putc>
        putc(fd, c);
 69c:	85ca                	mv	a1,s2
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	d84080e7          	jalr	-636(ra) # 424 <putc>
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b565                	j	552 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ac:	8b4a                	mv	s6,s2
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b54d                	j	552 <vprintf+0x60>
    }
  }
}
 6b2:	70e6                	ld	ra,120(sp)
 6b4:	7446                	ld	s0,112(sp)
 6b6:	74a6                	ld	s1,104(sp)
 6b8:	7906                	ld	s2,96(sp)
 6ba:	69e6                	ld	s3,88(sp)
 6bc:	6a46                	ld	s4,80(sp)
 6be:	6aa6                	ld	s5,72(sp)
 6c0:	6b06                	ld	s6,64(sp)
 6c2:	7be2                	ld	s7,56(sp)
 6c4:	7c42                	ld	s8,48(sp)
 6c6:	7ca2                	ld	s9,40(sp)
 6c8:	7d02                	ld	s10,32(sp)
 6ca:	6de2                	ld	s11,24(sp)
 6cc:	6109                	addi	sp,sp,128
 6ce:	8082                	ret

00000000000006d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d0:	715d                	addi	sp,sp,-80
 6d2:	ec06                	sd	ra,24(sp)
 6d4:	e822                	sd	s0,16(sp)
 6d6:	1000                	addi	s0,sp,32
 6d8:	e010                	sd	a2,0(s0)
 6da:	e414                	sd	a3,8(s0)
 6dc:	e818                	sd	a4,16(s0)
 6de:	ec1c                	sd	a5,24(s0)
 6e0:	03043023          	sd	a6,32(s0)
 6e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ec:	8622                	mv	a2,s0
 6ee:	00000097          	auipc	ra,0x0
 6f2:	e04080e7          	jalr	-508(ra) # 4f2 <vprintf>
}
 6f6:	60e2                	ld	ra,24(sp)
 6f8:	6442                	ld	s0,16(sp)
 6fa:	6161                	addi	sp,sp,80
 6fc:	8082                	ret

00000000000006fe <printf>:

void
printf(const char *fmt, ...)
{
 6fe:	711d                	addi	sp,sp,-96
 700:	ec06                	sd	ra,24(sp)
 702:	e822                	sd	s0,16(sp)
 704:	1000                	addi	s0,sp,32
 706:	e40c                	sd	a1,8(s0)
 708:	e810                	sd	a2,16(s0)
 70a:	ec14                	sd	a3,24(s0)
 70c:	f018                	sd	a4,32(s0)
 70e:	f41c                	sd	a5,40(s0)
 710:	03043823          	sd	a6,48(s0)
 714:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 718:	00840613          	addi	a2,s0,8
 71c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 720:	85aa                	mv	a1,a0
 722:	4505                	li	a0,1
 724:	00000097          	auipc	ra,0x0
 728:	dce080e7          	jalr	-562(ra) # 4f2 <vprintf>
}
 72c:	60e2                	ld	ra,24(sp)
 72e:	6442                	ld	s0,16(sp)
 730:	6125                	addi	sp,sp,96
 732:	8082                	ret

0000000000000734 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 734:	1141                	addi	sp,sp,-16
 736:	e422                	sd	s0,8(sp)
 738:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73e:	00001797          	auipc	a5,0x1
 742:	8c27b783          	ld	a5,-1854(a5) # 1000 <freep>
 746:	a02d                	j	770 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 748:	4618                	lw	a4,8(a2)
 74a:	9f2d                	addw	a4,a4,a1
 74c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 750:	6398                	ld	a4,0(a5)
 752:	6310                	ld	a2,0(a4)
 754:	a83d                	j	792 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 756:	ff852703          	lw	a4,-8(a0)
 75a:	9f31                	addw	a4,a4,a2
 75c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 75e:	ff053683          	ld	a3,-16(a0)
 762:	a091                	j	7a6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 764:	6398                	ld	a4,0(a5)
 766:	00e7e463          	bltu	a5,a4,76e <free+0x3a>
 76a:	00e6ea63          	bltu	a3,a4,77e <free+0x4a>
{
 76e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 770:	fed7fae3          	bgeu	a5,a3,764 <free+0x30>
 774:	6398                	ld	a4,0(a5)
 776:	00e6e463          	bltu	a3,a4,77e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77a:	fee7eae3          	bltu	a5,a4,76e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 77e:	ff852583          	lw	a1,-8(a0)
 782:	6390                	ld	a2,0(a5)
 784:	02059813          	slli	a6,a1,0x20
 788:	01c85713          	srli	a4,a6,0x1c
 78c:	9736                	add	a4,a4,a3
 78e:	fae60de3          	beq	a2,a4,748 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 792:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 796:	4790                	lw	a2,8(a5)
 798:	02061593          	slli	a1,a2,0x20
 79c:	01c5d713          	srli	a4,a1,0x1c
 7a0:	973e                	add	a4,a4,a5
 7a2:	fae68ae3          	beq	a3,a4,756 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7a6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a8:	00001717          	auipc	a4,0x1
 7ac:	84f73c23          	sd	a5,-1960(a4) # 1000 <freep>
}
 7b0:	6422                	ld	s0,8(sp)
 7b2:	0141                	addi	sp,sp,16
 7b4:	8082                	ret

00000000000007b6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b6:	7139                	addi	sp,sp,-64
 7b8:	fc06                	sd	ra,56(sp)
 7ba:	f822                	sd	s0,48(sp)
 7bc:	f426                	sd	s1,40(sp)
 7be:	f04a                	sd	s2,32(sp)
 7c0:	ec4e                	sd	s3,24(sp)
 7c2:	e852                	sd	s4,16(sp)
 7c4:	e456                	sd	s5,8(sp)
 7c6:	e05a                	sd	s6,0(sp)
 7c8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ca:	02051493          	slli	s1,a0,0x20
 7ce:	9081                	srli	s1,s1,0x20
 7d0:	04bd                	addi	s1,s1,15
 7d2:	8091                	srli	s1,s1,0x4
 7d4:	0014899b          	addiw	s3,s1,1
 7d8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7da:	00001517          	auipc	a0,0x1
 7de:	82653503          	ld	a0,-2010(a0) # 1000 <freep>
 7e2:	c515                	beqz	a0,80e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e6:	4798                	lw	a4,8(a5)
 7e8:	02977f63          	bgeu	a4,s1,826 <malloc+0x70>
 7ec:	8a4e                	mv	s4,s3
 7ee:	0009871b          	sext.w	a4,s3
 7f2:	6685                	lui	a3,0x1
 7f4:	00d77363          	bgeu	a4,a3,7fa <malloc+0x44>
 7f8:	6a05                	lui	s4,0x1
 7fa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7fe:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 802:	00000917          	auipc	s2,0x0
 806:	7fe90913          	addi	s2,s2,2046 # 1000 <freep>
  if(p == (char*)-1)
 80a:	5afd                	li	s5,-1
 80c:	a895                	j	880 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 80e:	00001797          	auipc	a5,0x1
 812:	80278793          	addi	a5,a5,-2046 # 1010 <base>
 816:	00000717          	auipc	a4,0x0
 81a:	7ef73523          	sd	a5,2026(a4) # 1000 <freep>
 81e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 820:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 824:	b7e1                	j	7ec <malloc+0x36>
      if(p->s.size == nunits)
 826:	02e48c63          	beq	s1,a4,85e <malloc+0xa8>
        p->s.size -= nunits;
 82a:	4137073b          	subw	a4,a4,s3
 82e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 830:	02071693          	slli	a3,a4,0x20
 834:	01c6d713          	srli	a4,a3,0x1c
 838:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 83a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 83e:	00000717          	auipc	a4,0x0
 842:	7ca73123          	sd	a0,1986(a4) # 1000 <freep>
      return (void*)(p + 1);
 846:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 84a:	70e2                	ld	ra,56(sp)
 84c:	7442                	ld	s0,48(sp)
 84e:	74a2                	ld	s1,40(sp)
 850:	7902                	ld	s2,32(sp)
 852:	69e2                	ld	s3,24(sp)
 854:	6a42                	ld	s4,16(sp)
 856:	6aa2                	ld	s5,8(sp)
 858:	6b02                	ld	s6,0(sp)
 85a:	6121                	addi	sp,sp,64
 85c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 85e:	6398                	ld	a4,0(a5)
 860:	e118                	sd	a4,0(a0)
 862:	bff1                	j	83e <malloc+0x88>
  hp->s.size = nu;
 864:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 868:	0541                	addi	a0,a0,16
 86a:	00000097          	auipc	ra,0x0
 86e:	eca080e7          	jalr	-310(ra) # 734 <free>
  return freep;
 872:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 876:	d971                	beqz	a0,84a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 878:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87a:	4798                	lw	a4,8(a5)
 87c:	fa9775e3          	bgeu	a4,s1,826 <malloc+0x70>
    if(p == freep)
 880:	00093703          	ld	a4,0(s2)
 884:	853e                	mv	a0,a5
 886:	fef719e3          	bne	a4,a5,878 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 88a:	8552                	mv	a0,s4
 88c:	00000097          	auipc	ra,0x0
 890:	b58080e7          	jalr	-1192(ra) # 3e4 <sbrk>
  if(p == (char*)-1)
 894:	fd5518e3          	bne	a0,s5,864 <malloc+0xae>
        return 0;
 898:	4501                	li	a0,0
 89a:	bf45                	j	84a <malloc+0x94>

000000000000089c <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 89c:	c1d9                	beqz	a1,922 <head_run+0x86>
void head_run(int fd, int numOfLines){
 89e:	dd010113          	addi	sp,sp,-560
 8a2:	22113423          	sd	ra,552(sp)
 8a6:	22813023          	sd	s0,544(sp)
 8aa:	20913c23          	sd	s1,536(sp)
 8ae:	21213823          	sd	s2,528(sp)
 8b2:	21313423          	sd	s3,520(sp)
 8b6:	21413023          	sd	s4,512(sp)
 8ba:	1c00                	addi	s0,sp,560
 8bc:	892a                	mv	s2,a0
 8be:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 8c2:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 8c4:	00000a17          	auipc	s4,0x0
 8c8:	554a0a13          	addi	s4,s4,1364 # e18 <digits+0x40>
		readStatus = read_line(fd, line);
 8cc:	dd840593          	addi	a1,s0,-552
 8d0:	854a                	mv	a0,s2
 8d2:	00000097          	auipc	ra,0x0
 8d6:	394080e7          	jalr	916(ra) # c66 <read_line>
		if (readStatus == READ_ERROR){
 8da:	01350d63          	beq	a0,s3,8f4 <head_run+0x58>
		if (readStatus == READ_EOF)
 8de:	c11d                	beqz	a0,904 <head_run+0x68>
		printf("%s",line);
 8e0:	dd840593          	addi	a1,s0,-552
 8e4:	8552                	mv	a0,s4
 8e6:	00000097          	auipc	ra,0x0
 8ea:	e18080e7          	jalr	-488(ra) # 6fe <printf>
	while(numOfLines--){
 8ee:	34fd                	addiw	s1,s1,-1
 8f0:	fcf1                	bnez	s1,8cc <head_run+0x30>
 8f2:	a809                	j	904 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 8f4:	00000517          	auipc	a0,0x0
 8f8:	4fc50513          	addi	a0,a0,1276 # df0 <digits+0x18>
 8fc:	00000097          	auipc	ra,0x0
 900:	e02080e7          	jalr	-510(ra) # 6fe <printf>

	}
}
 904:	22813083          	ld	ra,552(sp)
 908:	22013403          	ld	s0,544(sp)
 90c:	21813483          	ld	s1,536(sp)
 910:	21013903          	ld	s2,528(sp)
 914:	20813983          	ld	s3,520(sp)
 918:	20013a03          	ld	s4,512(sp)
 91c:	23010113          	addi	sp,sp,560
 920:	8082                	ret
 922:	8082                	ret

0000000000000924 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 924:	ba010113          	addi	sp,sp,-1120
 928:	44113c23          	sd	ra,1112(sp)
 92c:	44813823          	sd	s0,1104(sp)
 930:	44913423          	sd	s1,1096(sp)
 934:	45213023          	sd	s2,1088(sp)
 938:	43313c23          	sd	s3,1080(sp)
 93c:	43413823          	sd	s4,1072(sp)
 940:	43513423          	sd	s5,1064(sp)
 944:	43613023          	sd	s6,1056(sp)
 948:	41713c23          	sd	s7,1048(sp)
 94c:	41813823          	sd	s8,1040(sp)
 950:	41913423          	sd	s9,1032(sp)
 954:	41a13023          	sd	s10,1024(sp)
 958:	3fb13c23          	sd	s11,1016(sp)
 95c:	46010413          	addi	s0,sp,1120
 960:	89aa                	mv	s3,a0
 962:	8aae                	mv	s5,a1
 964:	8c32                	mv	s8,a2
 966:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 968:	d9840593          	addi	a1,s0,-616
 96c:	00000097          	auipc	ra,0x0
 970:	2fa080e7          	jalr	762(ra) # c66 <read_line>


  if (readStatus == READ_ERROR)
 974:	57fd                	li	a5,-1
 976:	04f50163          	beq	a0,a5,9b8 <uniq_run+0x94>
 97a:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 97c:	ed21                	bnez	a0,9d4 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 97e:	45813083          	ld	ra,1112(sp)
 982:	45013403          	ld	s0,1104(sp)
 986:	44813483          	ld	s1,1096(sp)
 98a:	44013903          	ld	s2,1088(sp)
 98e:	43813983          	ld	s3,1080(sp)
 992:	43013a03          	ld	s4,1072(sp)
 996:	42813a83          	ld	s5,1064(sp)
 99a:	42013b03          	ld	s6,1056(sp)
 99e:	41813b83          	ld	s7,1048(sp)
 9a2:	41013c03          	ld	s8,1040(sp)
 9a6:	40813c83          	ld	s9,1032(sp)
 9aa:	40013d03          	ld	s10,1024(sp)
 9ae:	3f813d83          	ld	s11,1016(sp)
 9b2:	46010113          	addi	sp,sp,1120
 9b6:	8082                	ret
    printf("[ERR] Error reading from the file ");
 9b8:	00000517          	auipc	a0,0x0
 9bc:	46850513          	addi	a0,a0,1128 # e20 <digits+0x48>
 9c0:	00000097          	auipc	ra,0x0
 9c4:	d3e080e7          	jalr	-706(ra) # 6fe <printf>
 9c8:	bf5d                	j	97e <uniq_run+0x5a>
 9ca:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 9cc:	8926                	mv	s2,s1
 9ce:	84be                	mv	s1,a5
        lineCount = 1;
 9d0:	8b6a                	mv	s6,s10
 9d2:	a8ed                	j	acc <uniq_run+0x1a8>
    int lineCount=1;
 9d4:	4b05                	li	s6,1
  char * line2 = buffer2;
 9d6:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 9da:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 9de:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 9e0:	4d05                	li	s10,1
              printf("%s",line1);
 9e2:	00000d97          	auipc	s11,0x0
 9e6:	436d8d93          	addi	s11,s11,1078 # e18 <digits+0x40>
 9ea:	a0cd                	j	acc <uniq_run+0x1a8>
            if (repeatedLines){
 9ec:	020a0b63          	beqz	s4,a22 <uniq_run+0xfe>
                if (isRepeated){
 9f0:	f80b87e3          	beqz	s7,97e <uniq_run+0x5a>
                    if (showCount)
 9f4:	000c0d63          	beqz	s8,a0e <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 9f8:	864a                	mv	a2,s2
 9fa:	85da                	mv	a1,s6
 9fc:	00000517          	auipc	a0,0x0
 a00:	44c50513          	addi	a0,a0,1100 # e48 <digits+0x70>
 a04:	00000097          	auipc	ra,0x0
 a08:	cfa080e7          	jalr	-774(ra) # 6fe <printf>
 a0c:	bf8d                	j	97e <uniq_run+0x5a>
                      printf("%s",line1);
 a0e:	85ca                	mv	a1,s2
 a10:	00000517          	auipc	a0,0x0
 a14:	40850513          	addi	a0,a0,1032 # e18 <digits+0x40>
 a18:	00000097          	auipc	ra,0x0
 a1c:	ce6080e7          	jalr	-794(ra) # 6fe <printf>
 a20:	bfb9                	j	97e <uniq_run+0x5a>
                if (showCount)
 a22:	000c0d63          	beqz	s8,a3c <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 a26:	864a                	mv	a2,s2
 a28:	85da                	mv	a1,s6
 a2a:	00000517          	auipc	a0,0x0
 a2e:	41e50513          	addi	a0,a0,1054 # e48 <digits+0x70>
 a32:	00000097          	auipc	ra,0x0
 a36:	ccc080e7          	jalr	-820(ra) # 6fe <printf>
 a3a:	b791                	j	97e <uniq_run+0x5a>
                  printf("%s",line1);
 a3c:	85ca                	mv	a1,s2
 a3e:	00000517          	auipc	a0,0x0
 a42:	3da50513          	addi	a0,a0,986 # e18 <digits+0x40>
 a46:	00000097          	auipc	ra,0x0
 a4a:	cb8080e7          	jalr	-840(ra) # 6fe <printf>
 a4e:	bf05                	j	97e <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 a50:	00000517          	auipc	a0,0x0
 a54:	40050513          	addi	a0,a0,1024 # e50 <digits+0x78>
 a58:	00000097          	auipc	ra,0x0
 a5c:	ca6080e7          	jalr	-858(ra) # 6fe <printf>
          break;
 a60:	bf39                	j	97e <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 a62:	85a6                	mv	a1,s1
 a64:	854a                	mv	a0,s2
 a66:	00000097          	auipc	ra,0x0
 a6a:	110080e7          	jalr	272(ra) # b76 <compare_str_ic>
 a6e:	a041                	j	aee <uniq_run+0x1ca>
                  printf("%s",line1);
 a70:	85ca                	mv	a1,s2
 a72:	856e                	mv	a0,s11
 a74:	00000097          	auipc	ra,0x0
 a78:	c8a080e7          	jalr	-886(ra) # 6fe <printf>
        lineCount = 1;
 a7c:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 a7e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 a80:	8926                	mv	s2,s1
                  printf("%s",line1);
 a82:	84be                	mv	s1,a5
        isRepeated = 0 ;
 a84:	4b81                	li	s7,0
 a86:	a099                	j	acc <uniq_run+0x1a8>
            if (showCount)
 a88:	020c0263          	beqz	s8,aac <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 a8c:	864a                	mv	a2,s2
 a8e:	85da                	mv	a1,s6
 a90:	00000517          	auipc	a0,0x0
 a94:	3b850513          	addi	a0,a0,952 # e48 <digits+0x70>
 a98:	00000097          	auipc	ra,0x0
 a9c:	c66080e7          	jalr	-922(ra) # 6fe <printf>
 aa0:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 aa2:	8926                	mv	s2,s1
 aa4:	84be                	mv	s1,a5
        isRepeated = 0 ;
 aa6:	4b81                	li	s7,0
        lineCount = 1;
 aa8:	8b6a                	mv	s6,s10
 aaa:	a00d                	j	acc <uniq_run+0x1a8>
              printf("%s",line1);
 aac:	85ca                	mv	a1,s2
 aae:	856e                	mv	a0,s11
 ab0:	00000097          	auipc	ra,0x0
 ab4:	c4e080e7          	jalr	-946(ra) # 6fe <printf>
 ab8:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 aba:	8926                	mv	s2,s1
              printf("%s",line1);
 abc:	84be                	mv	s1,a5
        isRepeated = 0 ;
 abe:	4b81                	li	s7,0
        lineCount = 1;
 ac0:	8b6a                	mv	s6,s10
 ac2:	a029                	j	acc <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 ac4:	000a0363          	beqz	s4,aca <uniq_run+0x1a6>
 ac8:	8bea                	mv	s7,s10
          lineCount++;
 aca:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 acc:	85a6                	mv	a1,s1
 ace:	854e                	mv	a0,s3
 ad0:	00000097          	auipc	ra,0x0
 ad4:	196080e7          	jalr	406(ra) # c66 <read_line>
        if (readStatus == READ_EOF){
 ad8:	d911                	beqz	a0,9ec <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 ada:	f7950be3          	beq	a0,s9,a50 <uniq_run+0x12c>
        if (!ignoreCase)
 ade:	f80a92e3          	bnez	s5,a62 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 ae2:	85a6                	mv	a1,s1
 ae4:	854a                	mv	a0,s2
 ae6:	00000097          	auipc	ra,0x0
 aea:	062080e7          	jalr	98(ra) # b48 <compare_str>
        if (compareStatus != 0){ 
 aee:	d979                	beqz	a0,ac4 <uniq_run+0x1a0>
          if (repeatedLines){
 af0:	f80a0ce3          	beqz	s4,a88 <uniq_run+0x164>
            if (isRepeated){
 af4:	ec0b8be3          	beqz	s7,9ca <uniq_run+0xa6>
                if (showCount)
 af8:	f60c0ce3          	beqz	s8,a70 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 afc:	864a                	mv	a2,s2
 afe:	85da                	mv	a1,s6
 b00:	00000517          	auipc	a0,0x0
 b04:	34850513          	addi	a0,a0,840 # e48 <digits+0x70>
 b08:	00000097          	auipc	ra,0x0
 b0c:	bf6080e7          	jalr	-1034(ra) # 6fe <printf>
        lineCount = 1;
 b10:	8b5e                	mv	s6,s7
 b12:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b14:	8926                	mv	s2,s1
 b16:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b18:	4b81                	li	s7,0
 b1a:	bf4d                	j	acc <uniq_run+0x1a8>

0000000000000b1c <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 b1c:	1141                	addi	sp,sp,-16
 b1e:	e422                	sd	s0,8(sp)
 b20:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 b22:	00054783          	lbu	a5,0(a0)
 b26:	cf99                	beqz	a5,b44 <get_strlen+0x28>
 b28:	00150713          	addi	a4,a0,1
 b2c:	87ba                	mv	a5,a4
 b2e:	4685                	li	a3,1
 b30:	9e99                	subw	a3,a3,a4
 b32:	00f6853b          	addw	a0,a3,a5
 b36:	0785                	addi	a5,a5,1
 b38:	fff7c703          	lbu	a4,-1(a5)
 b3c:	fb7d                	bnez	a4,b32 <get_strlen+0x16>
	return len;
}
 b3e:	6422                	ld	s0,8(sp)
 b40:	0141                	addi	sp,sp,16
 b42:	8082                	ret
	int len = 0;
 b44:	4501                	li	a0,0
 b46:	bfe5                	j	b3e <get_strlen+0x22>

0000000000000b48 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 b48:	1141                	addi	sp,sp,-16
 b4a:	e422                	sd	s0,8(sp)
 b4c:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 b4e:	00054783          	lbu	a5,0(a0)
 b52:	cb91                	beqz	a5,b66 <compare_str+0x1e>
 b54:	0005c703          	lbu	a4,0(a1)
 b58:	c719                	beqz	a4,b66 <compare_str+0x1e>
		if (*s1++ != *s2++)
 b5a:	0505                	addi	a0,a0,1
 b5c:	0585                	addi	a1,a1,1
 b5e:	fee788e3          	beq	a5,a4,b4e <compare_str+0x6>
			return 1;
 b62:	4505                	li	a0,1
 b64:	a031                	j	b70 <compare_str+0x28>
	}
	if (*s1 == *s2)
 b66:	0005c503          	lbu	a0,0(a1)
 b6a:	8d1d                	sub	a0,a0,a5
			return 1;
 b6c:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b70:	6422                	ld	s0,8(sp)
 b72:	0141                	addi	sp,sp,16
 b74:	8082                	ret

0000000000000b76 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 b76:	1141                	addi	sp,sp,-16
 b78:	e422                	sd	s0,8(sp)
 b7a:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b7c:	4665                	li	a2,25
	while(*s1 && *s2){
 b7e:	a019                	j	b84 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b80:	04e79763          	bne	a5,a4,bce <compare_str_ic+0x58>
	while(*s1 && *s2){
 b84:	00054783          	lbu	a5,0(a0)
 b88:	cb9d                	beqz	a5,bbe <compare_str_ic+0x48>
 b8a:	0005c703          	lbu	a4,0(a1)
 b8e:	cb05                	beqz	a4,bbe <compare_str_ic+0x48>
		char b1 = *s1++;
 b90:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 b92:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b94:	fbf7869b          	addiw	a3,a5,-65
 b98:	0ff6f693          	zext.b	a3,a3
 b9c:	00d66663          	bltu	a2,a3,ba8 <compare_str_ic+0x32>
			b1 += 32;
 ba0:	0207879b          	addiw	a5,a5,32
 ba4:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 ba8:	fbf7069b          	addiw	a3,a4,-65
 bac:	0ff6f693          	zext.b	a3,a3
 bb0:	fcd668e3          	bltu	a2,a3,b80 <compare_str_ic+0xa>
			b2 += 32;
 bb4:	0207071b          	addiw	a4,a4,32
 bb8:	0ff77713          	zext.b	a4,a4
 bbc:	b7d1                	j	b80 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 bbe:	0005c503          	lbu	a0,0(a1)
 bc2:	8d1d                	sub	a0,a0,a5
			return 1;
 bc4:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 bc8:	6422                	ld	s0,8(sp)
 bca:	0141                	addi	sp,sp,16
 bcc:	8082                	ret
			return 1;
 bce:	4505                	li	a0,1
 bd0:	bfe5                	j	bc8 <compare_str_ic+0x52>

0000000000000bd2 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 bd2:	7179                	addi	sp,sp,-48
 bd4:	f406                	sd	ra,40(sp)
 bd6:	f022                	sd	s0,32(sp)
 bd8:	ec26                	sd	s1,24(sp)
 bda:	e84a                	sd	s2,16(sp)
 bdc:	e44e                	sd	s3,8(sp)
 bde:	1800                	addi	s0,sp,48
 be0:	89aa                	mv	s3,a0
 be2:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 be4:	00000097          	auipc	ra,0x0
 be8:	f38080e7          	jalr	-200(ra) # b1c <get_strlen>
 bec:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 bee:	854a                	mv	a0,s2
 bf0:	00000097          	auipc	ra,0x0
 bf4:	f2c080e7          	jalr	-212(ra) # b1c <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 bf8:	409505bb          	subw	a1,a0,s1
 bfc:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 bfe:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 c00:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 c02:	0005da63          	bgez	a1,c16 <check_substr+0x44>
 c06:	a81d                	j	c3c <check_substr+0x6a>
        if (j == M)
 c08:	02f48a63          	beq	s1,a5,c3c <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 c0c:	0885                	addi	a7,a7,1
 c0e:	0008879b          	sext.w	a5,a7
 c12:	02f5cc63          	blt	a1,a5,c4a <check_substr+0x78>
 c16:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 c1a:	011906b3          	add	a3,s2,a7
 c1e:	874e                	mv	a4,s3
 c20:	879a                	mv	a5,t1
 c22:	fe9053e3          	blez	s1,c08 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 c26:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 c2a:	00074603          	lbu	a2,0(a4)
 c2e:	fcc81de3          	bne	a6,a2,c08 <check_substr+0x36>
        for (j = 0; j < M; j++)
 c32:	2785                	addiw	a5,a5,1
 c34:	0685                	addi	a3,a3,1
 c36:	0705                	addi	a4,a4,1
 c38:	fef497e3          	bne	s1,a5,c26 <check_substr+0x54>
}
 c3c:	70a2                	ld	ra,40(sp)
 c3e:	7402                	ld	s0,32(sp)
 c40:	64e2                	ld	s1,24(sp)
 c42:	6942                	ld	s2,16(sp)
 c44:	69a2                	ld	s3,8(sp)
 c46:	6145                	addi	sp,sp,48
 c48:	8082                	ret
    return -1;
 c4a:	557d                	li	a0,-1
 c4c:	bfc5                	j	c3c <check_substr+0x6a>

0000000000000c4e <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 c4e:	1141                	addi	sp,sp,-16
 c50:	e406                	sd	ra,8(sp)
 c52:	e022                	sd	s0,0(sp)
 c54:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 c56:	fffff097          	auipc	ra,0xfffff
 c5a:	746080e7          	jalr	1862(ra) # 39c <open>
	return fd;
}
 c5e:	60a2                	ld	ra,8(sp)
 c60:	6402                	ld	s0,0(sp)
 c62:	0141                	addi	sp,sp,16
 c64:	8082                	ret

0000000000000c66 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 c66:	7139                	addi	sp,sp,-64
 c68:	fc06                	sd	ra,56(sp)
 c6a:	f822                	sd	s0,48(sp)
 c6c:	f426                	sd	s1,40(sp)
 c6e:	f04a                	sd	s2,32(sp)
 c70:	ec4e                	sd	s3,24(sp)
 c72:	e852                	sd	s4,16(sp)
 c74:	0080                	addi	s0,sp,64
 c76:	89aa                	mv	s3,a0
 c78:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 c7a:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 c7c:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 c7e:	4605                	li	a2,1
 c80:	fcf40593          	addi	a1,s0,-49
 c84:	854e                	mv	a0,s3
 c86:	fffff097          	auipc	ra,0xfffff
 c8a:	6ee080e7          	jalr	1774(ra) # 374 <read>
		if (readStatus == 0){
 c8e:	c505                	beqz	a0,cb6 <read_line+0x50>
		*buffer++ = readByte;
 c90:	0485                	addi	s1,s1,1
 c92:	fcf44783          	lbu	a5,-49(s0)
 c96:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 c9a:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 c9c:	ff4791e3          	bne	a5,s4,c7e <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 ca0:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 ca4:	854a                	mv	a0,s2
 ca6:	70e2                	ld	ra,56(sp)
 ca8:	7442                	ld	s0,48(sp)
 caa:	74a2                	ld	s1,40(sp)
 cac:	7902                	ld	s2,32(sp)
 cae:	69e2                	ld	s3,24(sp)
 cb0:	6a42                	ld	s4,16(sp)
 cb2:	6121                	addi	sp,sp,64
 cb4:	8082                	ret
			if (byteCount!=0){
 cb6:	fe0907e3          	beqz	s2,ca4 <read_line+0x3e>
				*buffer = '\n';
 cba:	47a9                	li	a5,10
 cbc:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 cc0:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 cc4:	2905                	addiw	s2,s2,1
 cc6:	bff9                	j	ca4 <read_line+0x3e>

0000000000000cc8 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 cc8:	1141                	addi	sp,sp,-16
 cca:	e406                	sd	ra,8(sp)
 ccc:	e022                	sd	s0,0(sp)
 cce:	0800                	addi	s0,sp,16
	close(fd);
 cd0:	fffff097          	auipc	ra,0xfffff
 cd4:	6b4080e7          	jalr	1716(ra) # 384 <close>
}
 cd8:	60a2                	ld	ra,8(sp)
 cda:	6402                	ld	s0,0(sp)
 cdc:	0141                	addi	sp,sp,16
 cde:	8082                	ret

0000000000000ce0 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 ce0:	7139                	addi	sp,sp,-64
 ce2:	fc06                	sd	ra,56(sp)
 ce4:	f822                	sd	s0,48(sp)
 ce6:	f426                	sd	s1,40(sp)
 ce8:	f04a                	sd	s2,32(sp)
 cea:	0080                	addi	s0,sp,64
 cec:	84aa                	mv	s1,a0
 cee:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 cf0:	fffff097          	auipc	ra,0xfffff
 cf4:	664080e7          	jalr	1636(ra) # 354 <fork>
 cf8:	ed19                	bnez	a0,d16 <get_time_perf+0x36>
		exec(argv[0],argv);
 cfa:	85ca                	mv	a1,s2
 cfc:	00093503          	ld	a0,0(s2)
 d00:	fffff097          	auipc	ra,0xfffff
 d04:	694080e7          	jalr	1684(ra) # 394 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 d08:	8526                	mv	a0,s1
 d0a:	70e2                	ld	ra,56(sp)
 d0c:	7442                	ld	s0,48(sp)
 d0e:	74a2                	ld	s1,40(sp)
 d10:	7902                	ld	s2,32(sp)
 d12:	6121                	addi	sp,sp,64
 d14:	8082                	ret
		times(pid , &time);
 d16:	fc840593          	addi	a1,s0,-56
 d1a:	fffff097          	auipc	ra,0xfffff
 d1e:	6fa080e7          	jalr	1786(ra) # 414 <times>
		return time;
 d22:	fc843783          	ld	a5,-56(s0)
 d26:	e09c                	sd	a5,0(s1)
 d28:	fd043783          	ld	a5,-48(s0)
 d2c:	e49c                	sd	a5,8(s1)
 d2e:	fd843783          	ld	a5,-40(s0)
 d32:	e89c                	sd	a5,16(s1)
 d34:	bfd1                	j	d08 <get_time_perf+0x28>
