
user/elibs/_head:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <head_run>:
void head_run(s32 fd, u32 numOfLines){
	
	u8 line[MAX_LINE_LEN];
	s64 readStatus;

	while(numOfLines--){
   0:	c9d1                	beqz	a1,94 <head_run+0x94>
void head_run(s32 fd, u32 numOfLines){
   2:	dd010113          	addi	sp,sp,-560
   6:	22113423          	sd	ra,552(sp)
   a:	22813023          	sd	s0,544(sp)
   e:	20913c23          	sd	s1,536(sp)
  12:	21213823          	sd	s2,528(sp)
  16:	21313423          	sd	s3,520(sp)
  1a:	21413023          	sd	s4,512(sp)
  1e:	1c00                	addi	s0,sp,560
  20:	89aa                	mv	s3,a0
  22:	fff5849b          	addiw	s1,a1,-1
		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
  26:	597d                	li	s2,-1
		}

		if (readStatus == READ_EOF )
			break;
		line[readStatus]=0;
		printf("%s",line);
  28:	00001a17          	auipc	s4,0x1
  2c:	b70a0a13          	addi	s4,s4,-1168 # b98 <compare_str_ic+0x86>
		readStatus = read_line(fd, line);
  30:	dd840593          	addi	a1,s0,-552
  34:	854e                	mv	a0,s3
  36:	00001097          	auipc	ra,0x1
  3a:	a10080e7          	jalr	-1520(ra) # a46 <read_line>
		if (readStatus == READ_ERROR){
  3e:	03250463          	beq	a0,s2,66 <head_run+0x66>
		if (readStatus == READ_EOF )
  42:	c915                	beqz	a0,76 <head_run+0x76>
		line[readStatus]=0;
  44:	fd050793          	addi	a5,a0,-48
  48:	00878533          	add	a0,a5,s0
  4c:	e0050423          	sb	zero,-504(a0)
		printf("%s",line);
  50:	dd840593          	addi	a1,s0,-552
  54:	8552                	mv	a0,s4
  56:	00000097          	auipc	ra,0x0
  5a:	7e0080e7          	jalr	2016(ra) # 836 <printf>
	while(numOfLines--){
  5e:	34fd                	addiw	s1,s1,-1
  60:	fd2498e3          	bne	s1,s2,30 <head_run+0x30>
  64:	a809                	j	76 <head_run+0x76>
			printf("[ERR] Error reading from the file \n");
  66:	00001517          	auipc	a0,0x1
  6a:	b0a50513          	addi	a0,a0,-1270 # b70 <compare_str_ic+0x5e>
  6e:	00000097          	auipc	ra,0x0
  72:	7c8080e7          	jalr	1992(ra) # 836 <printf>
	}
}
  76:	22813083          	ld	ra,552(sp)
  7a:	22013403          	ld	s0,544(sp)
  7e:	21813483          	ld	s1,536(sp)
  82:	21013903          	ld	s2,528(sp)
  86:	20813983          	ld	s3,520(sp)
  8a:	20013a03          	ld	s4,512(sp)
  8e:	23010113          	addi	sp,sp,560
  92:	8082                	ret
  94:	8082                	ret

0000000000000096 <head_usermode>:
void head_usermode(u8 **passedFiles, u32 lineCount){
  96:	715d                	addi	sp,sp,-80
  98:	e486                	sd	ra,72(sp)
  9a:	e0a2                	sd	s0,64(sp)
  9c:	fc26                	sd	s1,56(sp)
  9e:	f84a                	sd	s2,48(sp)
  a0:	f44e                	sd	s3,40(sp)
  a2:	f052                	sd	s4,32(sp)
  a4:	ec56                	sd	s5,24(sp)
  a6:	e85a                	sd	s6,16(sp)
  a8:	e45e                	sd	s7,8(sp)
  aa:	e062                	sd	s8,0(sp)
  ac:	0880                	addi	s0,sp,80
  ae:	892a                	mv	s2,a0
  b0:	8a2e                	mv	s4,a1
	printf("Head command is getting executed in user mode\n");
  b2:	00001517          	auipc	a0,0x1
  b6:	aee50513          	addi	a0,a0,-1298 # ba0 <compare_str_ic+0x8e>
  ba:	00000097          	auipc	ra,0x0
  be:	77c080e7          	jalr	1916(ra) # 836 <printf>
	while(*files++){numOfFiles++;};
  c2:	00093503          	ld	a0,0(s2)
  c6:	cd2d                	beqz	a0,140 <head_usermode+0xaa>
  c8:	00890793          	addi	a5,s2,8
	u32 numOfFiles=0;
  cc:	4981                	li	s3,0
	while(*files++){numOfFiles++;};
  ce:	2985                	addiw	s3,s3,1
  d0:	07a1                	addi	a5,a5,8
  d2:	ff87b703          	ld	a4,-8(a5)
  d6:	ff65                	bnez	a4,ce <head_usermode+0x38>
			if (fd == OPEN_FILE_ERROR)
  d8:	5afd                	li	s5,-1
				if (numOfFiles > 1) 
  da:	4b05                	li	s6,1
					printf("==> %s <==\n",*passedFiles);
  dc:	00001b97          	auipc	s7,0x1
  e0:	b1cb8b93          	addi	s7,s7,-1252 # bf8 <compare_str_ic+0xe6>
				printf("[ERR] opening the file '%s' failed \n",*passedFiles);
  e4:	00001c17          	auipc	s8,0x1
  e8:	aecc0c13          	addi	s8,s8,-1300 # bd0 <compare_str_ic+0xbe>
  ec:	a805                	j	11c <head_usermode+0x86>
  ee:	00093583          	ld	a1,0(s2)
  f2:	8562                	mv	a0,s8
  f4:	00000097          	auipc	ra,0x0
  f8:	742080e7          	jalr	1858(ra) # 836 <printf>
  fc:	a039                	j	10a <head_usermode+0x74>
				head_run(fd , lineCount);
  fe:	85d2                	mv	a1,s4
 100:	8526                	mv	a0,s1
 102:	00000097          	auipc	ra,0x0
 106:	efe080e7          	jalr	-258(ra) # 0 <head_run>
			close_file(fd);
 10a:	8526                	mv	a0,s1
 10c:	00001097          	auipc	ra,0x1
 110:	994080e7          	jalr	-1644(ra) # aa0 <close_file>
			passedFiles++;
 114:	0921                	addi	s2,s2,8
		while (*passedFiles){
 116:	00093503          	ld	a0,0(s2)
 11a:	c90d                	beqz	a0,14c <head_usermode+0xb6>
			u32 fd = open_file(*passedFiles, RDONLY);
 11c:	4581                	li	a1,0
 11e:	00001097          	auipc	ra,0x1
 122:	910080e7          	jalr	-1776(ra) # a2e <open_file>
 126:	84aa                	mv	s1,a0
			if (fd == OPEN_FILE_ERROR)
 128:	fd5503e3          	beq	a0,s5,ee <head_usermode+0x58>
				if (numOfFiles > 1) 
 12c:	fd3b79e3          	bgeu	s6,s3,fe <head_usermode+0x68>
					printf("==> %s <==\n",*passedFiles);
 130:	00093583          	ld	a1,0(s2)
 134:	855e                	mv	a0,s7
 136:	00000097          	auipc	ra,0x0
 13a:	700080e7          	jalr	1792(ra) # 836 <printf>
 13e:	b7c1                	j	fe <head_usermode+0x68>
		head_run(STDIN, lineCount);
 140:	85d2                	mv	a1,s4
 142:	4501                	li	a0,0
 144:	00000097          	auipc	ra,0x0
 148:	ebc080e7          	jalr	-324(ra) # 0 <head_run>
}
 14c:	60a6                	ld	ra,72(sp)
 14e:	6406                	ld	s0,64(sp)
 150:	74e2                	ld	s1,56(sp)
 152:	7942                	ld	s2,48(sp)
 154:	79a2                	ld	s3,40(sp)
 156:	7a02                	ld	s4,32(sp)
 158:	6ae2                	ld	s5,24(sp)
 15a:	6b42                	ld	s6,16(sp)
 15c:	6ba2                	ld	s7,8(sp)
 15e:	6c02                	ld	s8,0(sp)
 160:	6161                	addi	sp,sp,80
 162:	8082                	ret

0000000000000164 <main>:
s32 main(s32 argc, u8 ** argv){
 164:	7139                	addi	sp,sp,-64
 166:	fc06                	sd	ra,56(sp)
 168:	f822                	sd	s0,48(sp)
 16a:	f426                	sd	s1,40(sp)
 16c:	f04a                	sd	s2,32(sp)
 16e:	ec4e                	sd	s3,24(sp)
 170:	e852                	sd	s4,16(sp)
 172:	e456                	sd	s5,8(sp)
 174:	e05a                	sd	s6,0(sp)
 176:	0080                	addi	s0,sp,64
 178:	892e                	mv	s2,a1

	/* Default value for lineCount */
	*lineCount = NUM_OF_LINES;

	/* Total number of files is maximum argc-1 requiring argc size storage for the last NULL*/
	u8 ** passedFiles = malloc(sizeof(u8 *) * (argc));
 17a:	0035151b          	slliw	a0,a0,0x3
 17e:	00000097          	auipc	ra,0x0
 182:	770080e7          	jalr	1904(ra) # 8ee <malloc>

	if (!passedFiles){
 186:	c551                	beqz	a0,212 <main+0xae>
 188:	8a2a                	mv	s4,a0
		return NULL;
	}


	u32 fileIdx = 0;
	cmd++;  // Skipping the program's name
 18a:	00890493          	addi	s1,s2,8
	
	while(*cmd){
 18e:	00893503          	ld	a0,8(s2)
 192:	c531                	beqz	a0,1de <main+0x7a>
	*lineCount = NUM_OF_LINES;
 194:	4ab9                	li	s5,14
	u32 fileIdx = 0;
 196:	4981                	li	s3,0
		if (!compare_str(cmd[0], "-n")){
 198:	00001b17          	auipc	s6,0x1
 19c:	a70b0b13          	addi	s6,s6,-1424 # c08 <compare_str_ic+0xf6>
 1a0:	a839                	j	1be <main+0x5a>
			cmd++;
			*lineCount = atoi(cmd[0]);
		}
		else
			passedFiles[fileIdx++] = cmd[0];
 1a2:	6098                	ld	a4,0(s1)
 1a4:	02099693          	slli	a3,s3,0x20
 1a8:	01d6d793          	srli	a5,a3,0x1d
 1ac:	97d2                	add	a5,a5,s4
 1ae:	e398                	sd	a4,0(a5)
 1b0:	2985                	addiw	s3,s3,1
 1b2:	8926                	mv	s2,s1
			
		cmd++;
 1b4:	00890493          	addi	s1,s2,8
	while(*cmd){
 1b8:	00893503          	ld	a0,8(s2)
 1bc:	c11d                	beqz	a0,1e2 <main+0x7e>
		if (!compare_str(cmd[0], "-n")){
 1be:	85da                	mv	a1,s6
 1c0:	00001097          	auipc	ra,0x1
 1c4:	924080e7          	jalr	-1756(ra) # ae4 <compare_str>
 1c8:	fd69                	bnez	a0,1a2 <main+0x3e>
			cmd++;
 1ca:	00848913          	addi	s2,s1,8
			*lineCount = atoi(cmd[0]);
 1ce:	6488                	ld	a0,8(s1)
 1d0:	00000097          	auipc	ra,0x0
 1d4:	1e2080e7          	jalr	482(ra) # 3b2 <atoi>
 1d8:	00050a9b          	sext.w	s5,a0
 1dc:	bfe1                	j	1b4 <main+0x50>
	*lineCount = NUM_OF_LINES;
 1de:	4ab9                	li	s5,14
	u32 fileIdx = 0;
 1e0:	4981                	li	s3,0
	}

	passedFiles[fileIdx]=NULL;
 1e2:	02099793          	slli	a5,s3,0x20
 1e6:	01d7d993          	srli	s3,a5,0x1d
 1ea:	99d2                	add	s3,s3,s4
 1ec:	0009b023          	sd	zero,0(s3)
	head_usermode(passedFiles, lineCount);
 1f0:	85d6                	mv	a1,s5
 1f2:	8552                	mv	a0,s4
 1f4:	00000097          	auipc	ra,0x0
 1f8:	ea2080e7          	jalr	-350(ra) # 96 <head_usermode>
	return 0;
 1fc:	4501                	li	a0,0
}
 1fe:	70e2                	ld	ra,56(sp)
 200:	7442                	ld	s0,48(sp)
 202:	74a2                	ld	s1,40(sp)
 204:	7902                	ld	s2,32(sp)
 206:	69e2                	ld	s3,24(sp)
 208:	6a42                	ld	s4,16(sp)
 20a:	6aa2                	ld	s5,8(sp)
 20c:	6b02                	ld	s6,0(sp)
 20e:	6121                	addi	sp,sp,64
 210:	8082                	ret
		printf("[ERR] Cannot parse the issued command\n");
 212:	00001517          	auipc	a0,0x1
 216:	9fe50513          	addi	a0,a0,-1538 # c10 <compare_str_ic+0xfe>
 21a:	00000097          	auipc	ra,0x0
 21e:	61c080e7          	jalr	1564(ra) # 836 <printf>
		return 1;
 222:	4505                	li	a0,1
 224:	bfe9                	j	1fe <main+0x9a>

0000000000000226 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 22e:	00000097          	auipc	ra,0x0
 232:	f36080e7          	jalr	-202(ra) # 164 <main>
  exit(0);
 236:	4501                	li	a0,0
 238:	00000097          	auipc	ra,0x0
 23c:	274080e7          	jalr	628(ra) # 4ac <exit>

0000000000000240 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 240:	1141                	addi	sp,sp,-16
 242:	e422                	sd	s0,8(sp)
 244:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 246:	87aa                	mv	a5,a0
 248:	0585                	addi	a1,a1,1
 24a:	0785                	addi	a5,a5,1
 24c:	fff5c703          	lbu	a4,-1(a1)
 250:	fee78fa3          	sb	a4,-1(a5)
 254:	fb75                	bnez	a4,248 <strcpy+0x8>
    ;
  return os;
}
 256:	6422                	ld	s0,8(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret

000000000000025c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 262:	00054783          	lbu	a5,0(a0)
 266:	cb91                	beqz	a5,27a <strcmp+0x1e>
 268:	0005c703          	lbu	a4,0(a1)
 26c:	00f71763          	bne	a4,a5,27a <strcmp+0x1e>
    p++, q++;
 270:	0505                	addi	a0,a0,1
 272:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 274:	00054783          	lbu	a5,0(a0)
 278:	fbe5                	bnez	a5,268 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 27a:	0005c503          	lbu	a0,0(a1)
}
 27e:	40a7853b          	subw	a0,a5,a0
 282:	6422                	ld	s0,8(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <strlen>:

uint
strlen(const char *s)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 28e:	00054783          	lbu	a5,0(a0)
 292:	cf91                	beqz	a5,2ae <strlen+0x26>
 294:	0505                	addi	a0,a0,1
 296:	87aa                	mv	a5,a0
 298:	4685                	li	a3,1
 29a:	9e89                	subw	a3,a3,a0
 29c:	00f6853b          	addw	a0,a3,a5
 2a0:	0785                	addi	a5,a5,1
 2a2:	fff7c703          	lbu	a4,-1(a5)
 2a6:	fb7d                	bnez	a4,29c <strlen+0x14>
    ;
  return n;
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
  for(n = 0; s[n]; n++)
 2ae:	4501                	li	a0,0
 2b0:	bfe5                	j	2a8 <strlen+0x20>

00000000000002b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2b8:	ca19                	beqz	a2,2ce <memset+0x1c>
 2ba:	87aa                	mv	a5,a0
 2bc:	1602                	slli	a2,a2,0x20
 2be:	9201                	srli	a2,a2,0x20
 2c0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2c8:	0785                	addi	a5,a5,1
 2ca:	fee79de3          	bne	a5,a4,2c4 <memset+0x12>
  }
  return dst;
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret

00000000000002d4 <strchr>:

char*
strchr(const char *s, char c)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2da:	00054783          	lbu	a5,0(a0)
 2de:	cb99                	beqz	a5,2f4 <strchr+0x20>
    if(*s == c)
 2e0:	00f58763          	beq	a1,a5,2ee <strchr+0x1a>
  for(; *s; s++)
 2e4:	0505                	addi	a0,a0,1
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	fbfd                	bnez	a5,2e0 <strchr+0xc>
      return (char*)s;
  return 0;
 2ec:	4501                	li	a0,0
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret
  return 0;
 2f4:	4501                	li	a0,0
 2f6:	bfe5                	j	2ee <strchr+0x1a>

00000000000002f8 <gets>:

char*
gets(char *buf, int max)
{
 2f8:	711d                	addi	sp,sp,-96
 2fa:	ec86                	sd	ra,88(sp)
 2fc:	e8a2                	sd	s0,80(sp)
 2fe:	e4a6                	sd	s1,72(sp)
 300:	e0ca                	sd	s2,64(sp)
 302:	fc4e                	sd	s3,56(sp)
 304:	f852                	sd	s4,48(sp)
 306:	f456                	sd	s5,40(sp)
 308:	f05a                	sd	s6,32(sp)
 30a:	ec5e                	sd	s7,24(sp)
 30c:	1080                	addi	s0,sp,96
 30e:	8baa                	mv	s7,a0
 310:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 312:	892a                	mv	s2,a0
 314:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 316:	4aa9                	li	s5,10
 318:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 31a:	89a6                	mv	s3,s1
 31c:	2485                	addiw	s1,s1,1
 31e:	0344d863          	bge	s1,s4,34e <gets+0x56>
    cc = read(0, &c, 1);
 322:	4605                	li	a2,1
 324:	faf40593          	addi	a1,s0,-81
 328:	4501                	li	a0,0
 32a:	00000097          	auipc	ra,0x0
 32e:	19a080e7          	jalr	410(ra) # 4c4 <read>
    if(cc < 1)
 332:	00a05e63          	blez	a0,34e <gets+0x56>
    buf[i++] = c;
 336:	faf44783          	lbu	a5,-81(s0)
 33a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 33e:	01578763          	beq	a5,s5,34c <gets+0x54>
 342:	0905                	addi	s2,s2,1
 344:	fd679be3          	bne	a5,s6,31a <gets+0x22>
  for(i=0; i+1 < max; ){
 348:	89a6                	mv	s3,s1
 34a:	a011                	j	34e <gets+0x56>
 34c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 34e:	99de                	add	s3,s3,s7
 350:	00098023          	sb	zero,0(s3)
  return buf;
}
 354:	855e                	mv	a0,s7
 356:	60e6                	ld	ra,88(sp)
 358:	6446                	ld	s0,80(sp)
 35a:	64a6                	ld	s1,72(sp)
 35c:	6906                	ld	s2,64(sp)
 35e:	79e2                	ld	s3,56(sp)
 360:	7a42                	ld	s4,48(sp)
 362:	7aa2                	ld	s5,40(sp)
 364:	7b02                	ld	s6,32(sp)
 366:	6be2                	ld	s7,24(sp)
 368:	6125                	addi	sp,sp,96
 36a:	8082                	ret

000000000000036c <stat>:

int
stat(const char *n, struct stat *st)
{
 36c:	1101                	addi	sp,sp,-32
 36e:	ec06                	sd	ra,24(sp)
 370:	e822                	sd	s0,16(sp)
 372:	e426                	sd	s1,8(sp)
 374:	e04a                	sd	s2,0(sp)
 376:	1000                	addi	s0,sp,32
 378:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 37a:	4581                	li	a1,0
 37c:	00000097          	auipc	ra,0x0
 380:	170080e7          	jalr	368(ra) # 4ec <open>
  if(fd < 0)
 384:	02054563          	bltz	a0,3ae <stat+0x42>
 388:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 38a:	85ca                	mv	a1,s2
 38c:	00000097          	auipc	ra,0x0
 390:	178080e7          	jalr	376(ra) # 504 <fstat>
 394:	892a                	mv	s2,a0
  close(fd);
 396:	8526                	mv	a0,s1
 398:	00000097          	auipc	ra,0x0
 39c:	13c080e7          	jalr	316(ra) # 4d4 <close>
  return r;
}
 3a0:	854a                	mv	a0,s2
 3a2:	60e2                	ld	ra,24(sp)
 3a4:	6442                	ld	s0,16(sp)
 3a6:	64a2                	ld	s1,8(sp)
 3a8:	6902                	ld	s2,0(sp)
 3aa:	6105                	addi	sp,sp,32
 3ac:	8082                	ret
    return -1;
 3ae:	597d                	li	s2,-1
 3b0:	bfc5                	j	3a0 <stat+0x34>

00000000000003b2 <atoi>:

int
atoi(const char *s)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e422                	sd	s0,8(sp)
 3b6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b8:	00054683          	lbu	a3,0(a0)
 3bc:	fd06879b          	addiw	a5,a3,-48
 3c0:	0ff7f793          	zext.b	a5,a5
 3c4:	4625                	li	a2,9
 3c6:	02f66863          	bltu	a2,a5,3f6 <atoi+0x44>
 3ca:	872a                	mv	a4,a0
  n = 0;
 3cc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3ce:	0705                	addi	a4,a4,1
 3d0:	0025179b          	slliw	a5,a0,0x2
 3d4:	9fa9                	addw	a5,a5,a0
 3d6:	0017979b          	slliw	a5,a5,0x1
 3da:	9fb5                	addw	a5,a5,a3
 3dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3e0:	00074683          	lbu	a3,0(a4)
 3e4:	fd06879b          	addiw	a5,a3,-48
 3e8:	0ff7f793          	zext.b	a5,a5
 3ec:	fef671e3          	bgeu	a2,a5,3ce <atoi+0x1c>
  return n;
}
 3f0:	6422                	ld	s0,8(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret
  n = 0;
 3f6:	4501                	li	a0,0
 3f8:	bfe5                	j	3f0 <atoi+0x3e>

00000000000003fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3fa:	1141                	addi	sp,sp,-16
 3fc:	e422                	sd	s0,8(sp)
 3fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 400:	02b57463          	bgeu	a0,a1,428 <memmove+0x2e>
    while(n-- > 0)
 404:	00c05f63          	blez	a2,422 <memmove+0x28>
 408:	1602                	slli	a2,a2,0x20
 40a:	9201                	srli	a2,a2,0x20
 40c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 410:	872a                	mv	a4,a0
      *dst++ = *src++;
 412:	0585                	addi	a1,a1,1
 414:	0705                	addi	a4,a4,1
 416:	fff5c683          	lbu	a3,-1(a1)
 41a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 41e:	fee79ae3          	bne	a5,a4,412 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 422:	6422                	ld	s0,8(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret
    dst += n;
 428:	00c50733          	add	a4,a0,a2
    src += n;
 42c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 42e:	fec05ae3          	blez	a2,422 <memmove+0x28>
 432:	fff6079b          	addiw	a5,a2,-1
 436:	1782                	slli	a5,a5,0x20
 438:	9381                	srli	a5,a5,0x20
 43a:	fff7c793          	not	a5,a5
 43e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 440:	15fd                	addi	a1,a1,-1
 442:	177d                	addi	a4,a4,-1
 444:	0005c683          	lbu	a3,0(a1)
 448:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 44c:	fee79ae3          	bne	a5,a4,440 <memmove+0x46>
 450:	bfc9                	j	422 <memmove+0x28>

0000000000000452 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 452:	1141                	addi	sp,sp,-16
 454:	e422                	sd	s0,8(sp)
 456:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 458:	ca05                	beqz	a2,488 <memcmp+0x36>
 45a:	fff6069b          	addiw	a3,a2,-1
 45e:	1682                	slli	a3,a3,0x20
 460:	9281                	srli	a3,a3,0x20
 462:	0685                	addi	a3,a3,1
 464:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 466:	00054783          	lbu	a5,0(a0)
 46a:	0005c703          	lbu	a4,0(a1)
 46e:	00e79863          	bne	a5,a4,47e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 472:	0505                	addi	a0,a0,1
    p2++;
 474:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 476:	fed518e3          	bne	a0,a3,466 <memcmp+0x14>
  }
  return 0;
 47a:	4501                	li	a0,0
 47c:	a019                	j	482 <memcmp+0x30>
      return *p1 - *p2;
 47e:	40e7853b          	subw	a0,a5,a4
}
 482:	6422                	ld	s0,8(sp)
 484:	0141                	addi	sp,sp,16
 486:	8082                	ret
  return 0;
 488:	4501                	li	a0,0
 48a:	bfe5                	j	482 <memcmp+0x30>

000000000000048c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 48c:	1141                	addi	sp,sp,-16
 48e:	e406                	sd	ra,8(sp)
 490:	e022                	sd	s0,0(sp)
 492:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 494:	00000097          	auipc	ra,0x0
 498:	f66080e7          	jalr	-154(ra) # 3fa <memmove>
}
 49c:	60a2                	ld	ra,8(sp)
 49e:	6402                	ld	s0,0(sp)
 4a0:	0141                	addi	sp,sp,16
 4a2:	8082                	ret

00000000000004a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4a4:	4885                	li	a7,1
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ac:	4889                	li	a7,2
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4b4:	488d                	li	a7,3
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4bc:	4891                	li	a7,4
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <read>:
.global read
read:
 li a7, SYS_read
 4c4:	4895                	li	a7,5
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <write>:
.global write
write:
 li a7, SYS_write
 4cc:	48c1                	li	a7,16
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <close>:
.global close
close:
 li a7, SYS_close
 4d4:	48d5                	li	a7,21
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 4dc:	4899                	li	a7,6
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4e4:	489d                	li	a7,7
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <open>:
.global open
open:
 li a7, SYS_open
 4ec:	48bd                	li	a7,15
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4f4:	48c5                	li	a7,17
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4fc:	48c9                	li	a7,18
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 504:	48a1                	li	a7,8
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <link>:
.global link
link:
 li a7, SYS_link
 50c:	48cd                	li	a7,19
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 514:	48d1                	li	a7,20
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 51c:	48a5                	li	a7,9
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <dup>:
.global dup
dup:
 li a7, SYS_dup
 524:	48a9                	li	a7,10
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 52c:	48ad                	li	a7,11
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 534:	48b1                	li	a7,12
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 53c:	48b5                	li	a7,13
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 544:	48b9                	li	a7,14
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <head>:
.global head
head:
 li a7, SYS_head
 54c:	48d9                	li	a7,22
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 554:	48dd                	li	a7,23
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 55c:	1101                	addi	sp,sp,-32
 55e:	ec06                	sd	ra,24(sp)
 560:	e822                	sd	s0,16(sp)
 562:	1000                	addi	s0,sp,32
 564:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 568:	4605                	li	a2,1
 56a:	fef40593          	addi	a1,s0,-17
 56e:	00000097          	auipc	ra,0x0
 572:	f5e080e7          	jalr	-162(ra) # 4cc <write>
}
 576:	60e2                	ld	ra,24(sp)
 578:	6442                	ld	s0,16(sp)
 57a:	6105                	addi	sp,sp,32
 57c:	8082                	ret

000000000000057e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57e:	7139                	addi	sp,sp,-64
 580:	fc06                	sd	ra,56(sp)
 582:	f822                	sd	s0,48(sp)
 584:	f426                	sd	s1,40(sp)
 586:	f04a                	sd	s2,32(sp)
 588:	ec4e                	sd	s3,24(sp)
 58a:	0080                	addi	s0,sp,64
 58c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 58e:	c299                	beqz	a3,594 <printint+0x16>
 590:	0805c963          	bltz	a1,622 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 594:	2581                	sext.w	a1,a1
  neg = 0;
 596:	4881                	li	a7,0
 598:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 59c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 59e:	2601                	sext.w	a2,a2
 5a0:	00000517          	auipc	a0,0x0
 5a4:	6f850513          	addi	a0,a0,1784 # c98 <digits>
 5a8:	883a                	mv	a6,a4
 5aa:	2705                	addiw	a4,a4,1
 5ac:	02c5f7bb          	remuw	a5,a1,a2
 5b0:	1782                	slli	a5,a5,0x20
 5b2:	9381                	srli	a5,a5,0x20
 5b4:	97aa                	add	a5,a5,a0
 5b6:	0007c783          	lbu	a5,0(a5)
 5ba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5be:	0005879b          	sext.w	a5,a1
 5c2:	02c5d5bb          	divuw	a1,a1,a2
 5c6:	0685                	addi	a3,a3,1
 5c8:	fec7f0e3          	bgeu	a5,a2,5a8 <printint+0x2a>
  if(neg)
 5cc:	00088c63          	beqz	a7,5e4 <printint+0x66>
    buf[i++] = '-';
 5d0:	fd070793          	addi	a5,a4,-48
 5d4:	00878733          	add	a4,a5,s0
 5d8:	02d00793          	li	a5,45
 5dc:	fef70823          	sb	a5,-16(a4)
 5e0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5e4:	02e05863          	blez	a4,614 <printint+0x96>
 5e8:	fc040793          	addi	a5,s0,-64
 5ec:	00e78933          	add	s2,a5,a4
 5f0:	fff78993          	addi	s3,a5,-1
 5f4:	99ba                	add	s3,s3,a4
 5f6:	377d                	addiw	a4,a4,-1
 5f8:	1702                	slli	a4,a4,0x20
 5fa:	9301                	srli	a4,a4,0x20
 5fc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 600:	fff94583          	lbu	a1,-1(s2)
 604:	8526                	mv	a0,s1
 606:	00000097          	auipc	ra,0x0
 60a:	f56080e7          	jalr	-170(ra) # 55c <putc>
  while(--i >= 0)
 60e:	197d                	addi	s2,s2,-1
 610:	ff3918e3          	bne	s2,s3,600 <printint+0x82>
}
 614:	70e2                	ld	ra,56(sp)
 616:	7442                	ld	s0,48(sp)
 618:	74a2                	ld	s1,40(sp)
 61a:	7902                	ld	s2,32(sp)
 61c:	69e2                	ld	s3,24(sp)
 61e:	6121                	addi	sp,sp,64
 620:	8082                	ret
    x = -xx;
 622:	40b005bb          	negw	a1,a1
    neg = 1;
 626:	4885                	li	a7,1
    x = -xx;
 628:	bf85                	j	598 <printint+0x1a>

000000000000062a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 62a:	7119                	addi	sp,sp,-128
 62c:	fc86                	sd	ra,120(sp)
 62e:	f8a2                	sd	s0,112(sp)
 630:	f4a6                	sd	s1,104(sp)
 632:	f0ca                	sd	s2,96(sp)
 634:	ecce                	sd	s3,88(sp)
 636:	e8d2                	sd	s4,80(sp)
 638:	e4d6                	sd	s5,72(sp)
 63a:	e0da                	sd	s6,64(sp)
 63c:	fc5e                	sd	s7,56(sp)
 63e:	f862                	sd	s8,48(sp)
 640:	f466                	sd	s9,40(sp)
 642:	f06a                	sd	s10,32(sp)
 644:	ec6e                	sd	s11,24(sp)
 646:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 648:	0005c903          	lbu	s2,0(a1)
 64c:	18090f63          	beqz	s2,7ea <vprintf+0x1c0>
 650:	8aaa                	mv	s5,a0
 652:	8b32                	mv	s6,a2
 654:	00158493          	addi	s1,a1,1
  state = 0;
 658:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 65a:	02500a13          	li	s4,37
 65e:	4c55                	li	s8,21
 660:	00000c97          	auipc	s9,0x0
 664:	5e0c8c93          	addi	s9,s9,1504 # c40 <compare_str_ic+0x12e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 668:	02800d93          	li	s11,40
  putc(fd, 'x');
 66c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66e:	00000b97          	auipc	s7,0x0
 672:	62ab8b93          	addi	s7,s7,1578 # c98 <digits>
 676:	a839                	j	694 <vprintf+0x6a>
        putc(fd, c);
 678:	85ca                	mv	a1,s2
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	ee0080e7          	jalr	-288(ra) # 55c <putc>
 684:	a019                	j	68a <vprintf+0x60>
    } else if(state == '%'){
 686:	01498d63          	beq	s3,s4,6a0 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 68a:	0485                	addi	s1,s1,1
 68c:	fff4c903          	lbu	s2,-1(s1)
 690:	14090d63          	beqz	s2,7ea <vprintf+0x1c0>
    if(state == 0){
 694:	fe0999e3          	bnez	s3,686 <vprintf+0x5c>
      if(c == '%'){
 698:	ff4910e3          	bne	s2,s4,678 <vprintf+0x4e>
        state = '%';
 69c:	89d2                	mv	s3,s4
 69e:	b7f5                	j	68a <vprintf+0x60>
      if(c == 'd'){
 6a0:	11490c63          	beq	s2,s4,7b8 <vprintf+0x18e>
 6a4:	f9d9079b          	addiw	a5,s2,-99
 6a8:	0ff7f793          	zext.b	a5,a5
 6ac:	10fc6e63          	bltu	s8,a5,7c8 <vprintf+0x19e>
 6b0:	f9d9079b          	addiw	a5,s2,-99
 6b4:	0ff7f713          	zext.b	a4,a5
 6b8:	10ec6863          	bltu	s8,a4,7c8 <vprintf+0x19e>
 6bc:	00271793          	slli	a5,a4,0x2
 6c0:	97e6                	add	a5,a5,s9
 6c2:	439c                	lw	a5,0(a5)
 6c4:	97e6                	add	a5,a5,s9
 6c6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6c8:	008b0913          	addi	s2,s6,8
 6cc:	4685                	li	a3,1
 6ce:	4629                	li	a2,10
 6d0:	000b2583          	lw	a1,0(s6)
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	ea8080e7          	jalr	-344(ra) # 57e <printint>
 6de:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b765                	j	68a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e4:	008b0913          	addi	s2,s6,8
 6e8:	4681                	li	a3,0
 6ea:	4629                	li	a2,10
 6ec:	000b2583          	lw	a1,0(s6)
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	e8c080e7          	jalr	-372(ra) # 57e <printint>
 6fa:	8b4a                	mv	s6,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b771                	j	68a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 700:	008b0913          	addi	s2,s6,8
 704:	4681                	li	a3,0
 706:	866a                	mv	a2,s10
 708:	000b2583          	lw	a1,0(s6)
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	e70080e7          	jalr	-400(ra) # 57e <printint>
 716:	8b4a                	mv	s6,s2
      state = 0;
 718:	4981                	li	s3,0
 71a:	bf85                	j	68a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 71c:	008b0793          	addi	a5,s6,8
 720:	f8f43423          	sd	a5,-120(s0)
 724:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 728:	03000593          	li	a1,48
 72c:	8556                	mv	a0,s5
 72e:	00000097          	auipc	ra,0x0
 732:	e2e080e7          	jalr	-466(ra) # 55c <putc>
  putc(fd, 'x');
 736:	07800593          	li	a1,120
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	e20080e7          	jalr	-480(ra) # 55c <putc>
 744:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 746:	03c9d793          	srli	a5,s3,0x3c
 74a:	97de                	add	a5,a5,s7
 74c:	0007c583          	lbu	a1,0(a5)
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	e0a080e7          	jalr	-502(ra) # 55c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 75a:	0992                	slli	s3,s3,0x4
 75c:	397d                	addiw	s2,s2,-1
 75e:	fe0914e3          	bnez	s2,746 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 762:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 766:	4981                	li	s3,0
 768:	b70d                	j	68a <vprintf+0x60>
        s = va_arg(ap, char*);
 76a:	008b0913          	addi	s2,s6,8
 76e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 772:	02098163          	beqz	s3,794 <vprintf+0x16a>
        while(*s != 0){
 776:	0009c583          	lbu	a1,0(s3)
 77a:	c5ad                	beqz	a1,7e4 <vprintf+0x1ba>
          putc(fd, *s);
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	dde080e7          	jalr	-546(ra) # 55c <putc>
          s++;
 786:	0985                	addi	s3,s3,1
        while(*s != 0){
 788:	0009c583          	lbu	a1,0(s3)
 78c:	f9e5                	bnez	a1,77c <vprintf+0x152>
        s = va_arg(ap, char*);
 78e:	8b4a                	mv	s6,s2
      state = 0;
 790:	4981                	li	s3,0
 792:	bde5                	j	68a <vprintf+0x60>
          s = "(null)";
 794:	00000997          	auipc	s3,0x0
 798:	4a498993          	addi	s3,s3,1188 # c38 <compare_str_ic+0x126>
        while(*s != 0){
 79c:	85ee                	mv	a1,s11
 79e:	bff9                	j	77c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7a0:	008b0913          	addi	s2,s6,8
 7a4:	000b4583          	lbu	a1,0(s6)
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	db2080e7          	jalr	-590(ra) # 55c <putc>
 7b2:	8b4a                	mv	s6,s2
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	bdd1                	j	68a <vprintf+0x60>
        putc(fd, c);
 7b8:	85d2                	mv	a1,s4
 7ba:	8556                	mv	a0,s5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	da0080e7          	jalr	-608(ra) # 55c <putc>
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	b5d1                	j	68a <vprintf+0x60>
        putc(fd, '%');
 7c8:	85d2                	mv	a1,s4
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	d90080e7          	jalr	-624(ra) # 55c <putc>
        putc(fd, c);
 7d4:	85ca                	mv	a1,s2
 7d6:	8556                	mv	a0,s5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	d84080e7          	jalr	-636(ra) # 55c <putc>
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	b565                	j	68a <vprintf+0x60>
        s = va_arg(ap, char*);
 7e4:	8b4a                	mv	s6,s2
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	b54d                	j	68a <vprintf+0x60>
    }
  }
}
 7ea:	70e6                	ld	ra,120(sp)
 7ec:	7446                	ld	s0,112(sp)
 7ee:	74a6                	ld	s1,104(sp)
 7f0:	7906                	ld	s2,96(sp)
 7f2:	69e6                	ld	s3,88(sp)
 7f4:	6a46                	ld	s4,80(sp)
 7f6:	6aa6                	ld	s5,72(sp)
 7f8:	6b06                	ld	s6,64(sp)
 7fa:	7be2                	ld	s7,56(sp)
 7fc:	7c42                	ld	s8,48(sp)
 7fe:	7ca2                	ld	s9,40(sp)
 800:	7d02                	ld	s10,32(sp)
 802:	6de2                	ld	s11,24(sp)
 804:	6109                	addi	sp,sp,128
 806:	8082                	ret

0000000000000808 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 808:	715d                	addi	sp,sp,-80
 80a:	ec06                	sd	ra,24(sp)
 80c:	e822                	sd	s0,16(sp)
 80e:	1000                	addi	s0,sp,32
 810:	e010                	sd	a2,0(s0)
 812:	e414                	sd	a3,8(s0)
 814:	e818                	sd	a4,16(s0)
 816:	ec1c                	sd	a5,24(s0)
 818:	03043023          	sd	a6,32(s0)
 81c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 820:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 824:	8622                	mv	a2,s0
 826:	00000097          	auipc	ra,0x0
 82a:	e04080e7          	jalr	-508(ra) # 62a <vprintf>
}
 82e:	60e2                	ld	ra,24(sp)
 830:	6442                	ld	s0,16(sp)
 832:	6161                	addi	sp,sp,80
 834:	8082                	ret

0000000000000836 <printf>:

void
printf(const char *fmt, ...)
{
 836:	711d                	addi	sp,sp,-96
 838:	ec06                	sd	ra,24(sp)
 83a:	e822                	sd	s0,16(sp)
 83c:	1000                	addi	s0,sp,32
 83e:	e40c                	sd	a1,8(s0)
 840:	e810                	sd	a2,16(s0)
 842:	ec14                	sd	a3,24(s0)
 844:	f018                	sd	a4,32(s0)
 846:	f41c                	sd	a5,40(s0)
 848:	03043823          	sd	a6,48(s0)
 84c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 850:	00840613          	addi	a2,s0,8
 854:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 858:	85aa                	mv	a1,a0
 85a:	4505                	li	a0,1
 85c:	00000097          	auipc	ra,0x0
 860:	dce080e7          	jalr	-562(ra) # 62a <vprintf>
}
 864:	60e2                	ld	ra,24(sp)
 866:	6442                	ld	s0,16(sp)
 868:	6125                	addi	sp,sp,96
 86a:	8082                	ret

000000000000086c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86c:	1141                	addi	sp,sp,-16
 86e:	e422                	sd	s0,8(sp)
 870:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 872:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 876:	00000797          	auipc	a5,0x0
 87a:	78a7b783          	ld	a5,1930(a5) # 1000 <freep>
 87e:	a02d                	j	8a8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 880:	4618                	lw	a4,8(a2)
 882:	9f2d                	addw	a4,a4,a1
 884:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 888:	6398                	ld	a4,0(a5)
 88a:	6310                	ld	a2,0(a4)
 88c:	a83d                	j	8ca <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 88e:	ff852703          	lw	a4,-8(a0)
 892:	9f31                	addw	a4,a4,a2
 894:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 896:	ff053683          	ld	a3,-16(a0)
 89a:	a091                	j	8de <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89c:	6398                	ld	a4,0(a5)
 89e:	00e7e463          	bltu	a5,a4,8a6 <free+0x3a>
 8a2:	00e6ea63          	bltu	a3,a4,8b6 <free+0x4a>
{
 8a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a8:	fed7fae3          	bgeu	a5,a3,89c <free+0x30>
 8ac:	6398                	ld	a4,0(a5)
 8ae:	00e6e463          	bltu	a3,a4,8b6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b2:	fee7eae3          	bltu	a5,a4,8a6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8b6:	ff852583          	lw	a1,-8(a0)
 8ba:	6390                	ld	a2,0(a5)
 8bc:	02059813          	slli	a6,a1,0x20
 8c0:	01c85713          	srli	a4,a6,0x1c
 8c4:	9736                	add	a4,a4,a3
 8c6:	fae60de3          	beq	a2,a4,880 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ce:	4790                	lw	a2,8(a5)
 8d0:	02061593          	slli	a1,a2,0x20
 8d4:	01c5d713          	srli	a4,a1,0x1c
 8d8:	973e                	add	a4,a4,a5
 8da:	fae68ae3          	beq	a3,a4,88e <free+0x22>
    p->s.ptr = bp->s.ptr;
 8de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8e0:	00000717          	auipc	a4,0x0
 8e4:	72f73023          	sd	a5,1824(a4) # 1000 <freep>
}
 8e8:	6422                	ld	s0,8(sp)
 8ea:	0141                	addi	sp,sp,16
 8ec:	8082                	ret

00000000000008ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ee:	7139                	addi	sp,sp,-64
 8f0:	fc06                	sd	ra,56(sp)
 8f2:	f822                	sd	s0,48(sp)
 8f4:	f426                	sd	s1,40(sp)
 8f6:	f04a                	sd	s2,32(sp)
 8f8:	ec4e                	sd	s3,24(sp)
 8fa:	e852                	sd	s4,16(sp)
 8fc:	e456                	sd	s5,8(sp)
 8fe:	e05a                	sd	s6,0(sp)
 900:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 902:	02051493          	slli	s1,a0,0x20
 906:	9081                	srli	s1,s1,0x20
 908:	04bd                	addi	s1,s1,15
 90a:	8091                	srli	s1,s1,0x4
 90c:	0014899b          	addiw	s3,s1,1
 910:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 912:	00000517          	auipc	a0,0x0
 916:	6ee53503          	ld	a0,1774(a0) # 1000 <freep>
 91a:	c515                	beqz	a0,946 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91e:	4798                	lw	a4,8(a5)
 920:	02977f63          	bgeu	a4,s1,95e <malloc+0x70>
 924:	8a4e                	mv	s4,s3
 926:	0009871b          	sext.w	a4,s3
 92a:	6685                	lui	a3,0x1
 92c:	00d77363          	bgeu	a4,a3,932 <malloc+0x44>
 930:	6a05                	lui	s4,0x1
 932:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 936:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 93a:	00000917          	auipc	s2,0x0
 93e:	6c690913          	addi	s2,s2,1734 # 1000 <freep>
  if(p == (char*)-1)
 942:	5afd                	li	s5,-1
 944:	a895                	j	9b8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 946:	00000797          	auipc	a5,0x0
 94a:	6ca78793          	addi	a5,a5,1738 # 1010 <base>
 94e:	00000717          	auipc	a4,0x0
 952:	6af73923          	sd	a5,1714(a4) # 1000 <freep>
 956:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 958:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 95c:	b7e1                	j	924 <malloc+0x36>
      if(p->s.size == nunits)
 95e:	02e48c63          	beq	s1,a4,996 <malloc+0xa8>
        p->s.size -= nunits;
 962:	4137073b          	subw	a4,a4,s3
 966:	c798                	sw	a4,8(a5)
        p += p->s.size;
 968:	02071693          	slli	a3,a4,0x20
 96c:	01c6d713          	srli	a4,a3,0x1c
 970:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 972:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 976:	00000717          	auipc	a4,0x0
 97a:	68a73523          	sd	a0,1674(a4) # 1000 <freep>
      return (void*)(p + 1);
 97e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 982:	70e2                	ld	ra,56(sp)
 984:	7442                	ld	s0,48(sp)
 986:	74a2                	ld	s1,40(sp)
 988:	7902                	ld	s2,32(sp)
 98a:	69e2                	ld	s3,24(sp)
 98c:	6a42                	ld	s4,16(sp)
 98e:	6aa2                	ld	s5,8(sp)
 990:	6b02                	ld	s6,0(sp)
 992:	6121                	addi	sp,sp,64
 994:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 996:	6398                	ld	a4,0(a5)
 998:	e118                	sd	a4,0(a0)
 99a:	bff1                	j	976 <malloc+0x88>
  hp->s.size = nu;
 99c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9a0:	0541                	addi	a0,a0,16
 9a2:	00000097          	auipc	ra,0x0
 9a6:	eca080e7          	jalr	-310(ra) # 86c <free>
  return freep;
 9aa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ae:	d971                	beqz	a0,982 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b2:	4798                	lw	a4,8(a5)
 9b4:	fa9775e3          	bgeu	a4,s1,95e <malloc+0x70>
    if(p == freep)
 9b8:	00093703          	ld	a4,0(s2)
 9bc:	853e                	mv	a0,a5
 9be:	fef719e3          	bne	a4,a5,9b0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9c2:	8552                	mv	a0,s4
 9c4:	00000097          	auipc	ra,0x0
 9c8:	b70080e7          	jalr	-1168(ra) # 534 <sbrk>
  if(p == (char*)-1)
 9cc:	fd5518e3          	bne	a0,s5,99c <malloc+0xae>
        return 0;
 9d0:	4501                	li	a0,0
 9d2:	bf45                	j	982 <malloc+0x94>

00000000000009d4 <str_len>:
 9d4:	1141                	addi	sp,sp,-16
 9d6:	e422                	sd	s0,8(sp)
 9d8:	0800                	addi	s0,sp,16
 9da:	00054783          	lbu	a5,0(a0)
 9de:	cf99                	beqz	a5,9fc <str_len+0x28>
 9e0:	00150713          	addi	a4,a0,1
 9e4:	87ba                	mv	a5,a4
 9e6:	4685                	li	a3,1
 9e8:	9e99                	subw	a3,a3,a4
 9ea:	00f6853b          	addw	a0,a3,a5
 9ee:	0785                	addi	a5,a5,1
 9f0:	fff7c703          	lbu	a4,-1(a5)
 9f4:	fb7d                	bnez	a4,9ea <str_len+0x16>
 9f6:	6422                	ld	s0,8(sp)
 9f8:	0141                	addi	sp,sp,16
 9fa:	8082                	ret
 9fc:	4501                	li	a0,0
 9fe:	bfe5                	j	9f6 <str_len+0x22>

0000000000000a00 <print>:
 a00:	1101                	addi	sp,sp,-32
 a02:	ec06                	sd	ra,24(sp)
 a04:	e822                	sd	s0,16(sp)
 a06:	e426                	sd	s1,8(sp)
 a08:	1000                	addi	s0,sp,32
 a0a:	84aa                	mv	s1,a0
 a0c:	00000097          	auipc	ra,0x0
 a10:	fc8080e7          	jalr	-56(ra) # 9d4 <str_len>
 a14:	0005061b          	sext.w	a2,a0
 a18:	85a6                	mv	a1,s1
 a1a:	4505                	li	a0,1
 a1c:	00000097          	auipc	ra,0x0
 a20:	ab0080e7          	jalr	-1360(ra) # 4cc <write>
 a24:	60e2                	ld	ra,24(sp)
 a26:	6442                	ld	s0,16(sp)
 a28:	64a2                	ld	s1,8(sp)
 a2a:	6105                	addi	sp,sp,32
 a2c:	8082                	ret

0000000000000a2e <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
s32 open_file(u8 * filePath, s32 flag){
 a2e:	1141                	addi	sp,sp,-16
 a30:	e406                	sd	ra,8(sp)
 a32:	e022                	sd	s0,0(sp)
 a34:	0800                	addi	s0,sp,16
	s32 fd = open(filePath, flag);
 a36:	00000097          	auipc	ra,0x0
 a3a:	ab6080e7          	jalr	-1354(ra) # 4ec <open>
	return fd;
}
 a3e:	60a2                	ld	ra,8(sp)
 a40:	6402                	ld	s0,0(sp)
 a42:	0141                	addi	sp,sp,16
 a44:	8082                	ret

0000000000000a46 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
s64 read_line(s32 fd, u8 * buffer){
 a46:	7139                	addi	sp,sp,-64
 a48:	fc06                	sd	ra,56(sp)
 a4a:	f822                	sd	s0,48(sp)
 a4c:	f426                	sd	s1,40(sp)
 a4e:	f04a                	sd	s2,32(sp)
 a50:	ec4e                	sd	s3,24(sp)
 a52:	e852                	sd	s4,16(sp)
 a54:	0080                	addi	s0,sp,64
 a56:	89aa                	mv	s3,a0
 a58:	84ae                	mv	s1,a1

	u8 readByte;
	s64 byteCount = 0;
 a5a:	4901                	li	s2,0
			return byteCount; 
		}
		*buffer++ = readByte;
		byteCount++;

		if (readByte == '\n'){
 a5c:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 a5e:	4605                	li	a2,1
 a60:	fcf40593          	addi	a1,s0,-49
 a64:	854e                	mv	a0,s3
 a66:	00000097          	auipc	ra,0x0
 a6a:	a5e080e7          	jalr	-1442(ra) # 4c4 <read>
		if (readStatus <= 0){
 a6e:	02a05563          	blez	a0,a98 <read_line+0x52>
		*buffer++ = readByte;
 a72:	0485                	addi	s1,s1,1
 a74:	fcf44783          	lbu	a5,-49(s0)
 a78:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 a7c:	0905                	addi	s2,s2,1
		if (readByte == '\n'){
 a7e:	ff4790e3          	bne	a5,s4,a5e <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 a82:	00048023          	sb	zero,0(s1)
		byteCount++;
 a86:	854a                	mv	a0,s2
			return byteCount;
		}
	
	}
}
 a88:	70e2                	ld	ra,56(sp)
 a8a:	7442                	ld	s0,48(sp)
 a8c:	74a2                	ld	s1,40(sp)
 a8e:	7902                	ld	s2,32(sp)
 a90:	69e2                	ld	s3,24(sp)
 a92:	6a42                	ld	s4,16(sp)
 a94:	6121                	addi	sp,sp,64
 a96:	8082                	ret
			if (byteCount == 0)
 a98:	fe0908e3          	beqz	s2,a88 <read_line+0x42>
 a9c:	854a                	mv	a0,s2
 a9e:	b7ed                	j	a88 <read_line+0x42>

0000000000000aa0 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(s32 fd){
 aa0:	1141                	addi	sp,sp,-16
 aa2:	e406                	sd	ra,8(sp)
 aa4:	e022                	sd	s0,0(sp)
 aa6:	0800                	addi	s0,sp,16
	close(fd);
 aa8:	00000097          	auipc	ra,0x0
 aac:	a2c080e7          	jalr	-1492(ra) # 4d4 <close>
}
 ab0:	60a2                	ld	ra,8(sp)
 ab2:	6402                	ld	s0,0(sp)
 ab4:	0141                	addi	sp,sp,16
 ab6:	8082                	ret

0000000000000ab8 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
u32 get_strlen(const u8 * str){
 ab8:	1141                	addi	sp,sp,-16
 aba:	e422                	sd	s0,8(sp)
 abc:	0800                	addi	s0,sp,16
	u32 len = 0;
	while(*str++){len++;};
 abe:	00054783          	lbu	a5,0(a0)
 ac2:	cf99                	beqz	a5,ae0 <get_strlen+0x28>
 ac4:	00150713          	addi	a4,a0,1
 ac8:	87ba                	mv	a5,a4
 aca:	4685                	li	a3,1
 acc:	9e99                	subw	a3,a3,a4
 ace:	00f6853b          	addw	a0,a3,a5
 ad2:	0785                	addi	a5,a5,1
 ad4:	fff7c703          	lbu	a4,-1(a5)
 ad8:	fb7d                	bnez	a4,ace <get_strlen+0x16>
	return len;
}
 ada:	6422                	ld	s0,8(sp)
 adc:	0141                	addi	sp,sp,16
 ade:	8082                	ret
	u32 len = 0;
 ae0:	4501                	li	a0,0
 ae2:	bfe5                	j	ada <get_strlen+0x22>

0000000000000ae4 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
u8 compare_str(const u8 * s1 , const u8 * s2){
 ae4:	1141                	addi	sp,sp,-16
 ae6:	e422                	sd	s0,8(sp)
 ae8:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 aea:	00054783          	lbu	a5,0(a0)
 aee:	cb91                	beqz	a5,b02 <compare_str+0x1e>
 af0:	0005c703          	lbu	a4,0(a1)
 af4:	c719                	beqz	a4,b02 <compare_str+0x1e>
		if (*s1++ != *s2++)
 af6:	0505                	addi	a0,a0,1
 af8:	0585                	addi	a1,a1,1
 afa:	fee788e3          	beq	a5,a4,aea <compare_str+0x6>
			return 1;
 afe:	4505                	li	a0,1
 b00:	a031                	j	b0c <compare_str+0x28>
	}
	if (*s1 == *s2)
 b02:	0005c503          	lbu	a0,0(a1)
 b06:	8d1d                	sub	a0,a0,a5
			return 1;
 b08:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b0c:	6422                	ld	s0,8(sp)
 b0e:	0141                	addi	sp,sp,16
 b10:	8082                	ret

0000000000000b12 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
u8 compare_str_ic(const u8 * s1 , const u8 * s2){
 b12:	1141                	addi	sp,sp,-16
 b14:	e422                	sd	s0,8(sp)
 b16:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		u8 b1 = *s1++;
		u8 b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b18:	4665                	li	a2,25
	while(*s1 && *s2){
 b1a:	a019                	j	b20 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b1c:	04e79763          	bne	a5,a4,b6a <compare_str_ic+0x58>
	while(*s1 && *s2){
 b20:	00054783          	lbu	a5,0(a0)
 b24:	cb9d                	beqz	a5,b5a <compare_str_ic+0x48>
 b26:	0005c703          	lbu	a4,0(a1)
 b2a:	cb05                	beqz	a4,b5a <compare_str_ic+0x48>
		u8 b1 = *s1++;
 b2c:	0505                	addi	a0,a0,1
		u8 b2 = *s2++;
 b2e:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 b30:	fbf7869b          	addiw	a3,a5,-65
 b34:	0ff6f693          	zext.b	a3,a3
 b38:	00d66663          	bltu	a2,a3,b44 <compare_str_ic+0x32>
			b1 += 32;
 b3c:	0207879b          	addiw	a5,a5,32
 b40:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 b44:	fbf7069b          	addiw	a3,a4,-65
 b48:	0ff6f693          	zext.b	a3,a3
 b4c:	fcd668e3          	bltu	a2,a3,b1c <compare_str_ic+0xa>
			b2 += 32;
 b50:	0207071b          	addiw	a4,a4,32
 b54:	0ff77713          	zext.b	a4,a4
 b58:	b7d1                	j	b1c <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 b5a:	0005c503          	lbu	a0,0(a1)
 b5e:	8d1d                	sub	a0,a0,a5
			return 1;
 b60:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b64:	6422                	ld	s0,8(sp)
 b66:	0141                	addi	sp,sp,16
 b68:	8082                	ret
			return 1;
 b6a:	4505                	li	a0,1
 b6c:	bfe5                	j	b64 <compare_str_ic+0x52>
