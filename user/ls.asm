
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	328080e7          	jalr	808(ra) # 338 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2fc080e7          	jalr	764(ra) # 338 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2da080e7          	jalr	730(ra) # 338 <strlen>
  66:	00002997          	auipc	s3,0x2
  6a:	faa98993          	addi	s3,s3,-86 # 2010 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	434080e7          	jalr	1076(ra) # 4aa <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2b8080e7          	jalr	696(ra) # 338 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2aa080e7          	jalr	682(ra) # 338 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	2ba080e7          	jalr	698(ra) # 362 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	4c2080e7          	jalr	1218(ra) # 59c <open>
  e2:	08054163          	bltz	a0,164 <ls+0xb0>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	4c8080e7          	jalr	1224(ra) # 5b4 <fstat>
  f4:	08054363          	bltz	a0,17a <ls+0xc6>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	0007869b          	sext.w	a3,a5
 100:	4705                	li	a4,1
 102:	08e68c63          	beq	a3,a4,19a <ls+0xe6>
 106:	37f9                	addiw	a5,a5,-2
 108:	17c2                	slli	a5,a5,0x30
 10a:	93c1                	srli	a5,a5,0x30
 10c:	02f76663          	bltu	a4,a5,138 <ls+0x84>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 110:	854a                	mv	a0,s2
 112:	00000097          	auipc	ra,0x0
 116:	eee080e7          	jalr	-274(ra) # 0 <fmtname>
 11a:	85aa                	mv	a1,a0
 11c:	da843703          	ld	a4,-600(s0)
 120:	d9c42683          	lw	a3,-612(s0)
 124:	da041603          	lh	a2,-608(s0)
 128:	00001517          	auipc	a0,0x1
 12c:	e4850513          	addi	a0,a0,-440 # f70 <get_time_perf+0x90>
 130:	00000097          	auipc	ra,0x0
 134:	7ce080e7          	jalr	1998(ra) # 8fe <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 138:	8526                	mv	a0,s1
 13a:	00000097          	auipc	ra,0x0
 13e:	44a080e7          	jalr	1098(ra) # 584 <close>
}
 142:	26813083          	ld	ra,616(sp)
 146:	26013403          	ld	s0,608(sp)
 14a:	25813483          	ld	s1,600(sp)
 14e:	25013903          	ld	s2,592(sp)
 152:	24813983          	ld	s3,584(sp)
 156:	24013a03          	ld	s4,576(sp)
 15a:	23813a83          	ld	s5,568(sp)
 15e:	27010113          	addi	sp,sp,624
 162:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 164:	864a                	mv	a2,s2
 166:	00001597          	auipc	a1,0x1
 16a:	dda58593          	addi	a1,a1,-550 # f40 <get_time_perf+0x60>
 16e:	4509                	li	a0,2
 170:	00000097          	auipc	ra,0x0
 174:	760080e7          	jalr	1888(ra) # 8d0 <fprintf>
    return;
 178:	b7e9                	j	142 <ls+0x8e>
    fprintf(2, "ls: cannot stat %s\n", path);
 17a:	864a                	mv	a2,s2
 17c:	00001597          	auipc	a1,0x1
 180:	ddc58593          	addi	a1,a1,-548 # f58 <get_time_perf+0x78>
 184:	4509                	li	a0,2
 186:	00000097          	auipc	ra,0x0
 18a:	74a080e7          	jalr	1866(ra) # 8d0 <fprintf>
    close(fd);
 18e:	8526                	mv	a0,s1
 190:	00000097          	auipc	ra,0x0
 194:	3f4080e7          	jalr	1012(ra) # 584 <close>
    return;
 198:	b76d                	j	142 <ls+0x8e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19a:	854a                	mv	a0,s2
 19c:	00000097          	auipc	ra,0x0
 1a0:	19c080e7          	jalr	412(ra) # 338 <strlen>
 1a4:	2541                	addiw	a0,a0,16
 1a6:	20000793          	li	a5,512
 1aa:	00a7fb63          	bgeu	a5,a0,1c0 <ls+0x10c>
      printf("ls: path too long\n");
 1ae:	00001517          	auipc	a0,0x1
 1b2:	dd250513          	addi	a0,a0,-558 # f80 <get_time_perf+0xa0>
 1b6:	00000097          	auipc	ra,0x0
 1ba:	748080e7          	jalr	1864(ra) # 8fe <printf>
      break;
 1be:	bfad                	j	138 <ls+0x84>
    strcpy(buf, path);
 1c0:	85ca                	mv	a1,s2
 1c2:	dc040513          	addi	a0,s0,-576
 1c6:	00000097          	auipc	ra,0x0
 1ca:	12a080e7          	jalr	298(ra) # 2f0 <strcpy>
    p = buf+strlen(buf);
 1ce:	dc040513          	addi	a0,s0,-576
 1d2:	00000097          	auipc	ra,0x0
 1d6:	166080e7          	jalr	358(ra) # 338 <strlen>
 1da:	1502                	slli	a0,a0,0x20
 1dc:	9101                	srli	a0,a0,0x20
 1de:	dc040793          	addi	a5,s0,-576
 1e2:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1e6:	00190993          	addi	s3,s2,1
 1ea:	02f00793          	li	a5,47
 1ee:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f2:	00001a17          	auipc	s4,0x1
 1f6:	da6a0a13          	addi	s4,s4,-602 # f98 <get_time_perf+0xb8>
        printf("ls: cannot stat %s\n", buf);
 1fa:	00001a97          	auipc	s5,0x1
 1fe:	d5ea8a93          	addi	s5,s5,-674 # f58 <get_time_perf+0x78>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 202:	a801                	j	212 <ls+0x15e>
        printf("ls: cannot stat %s\n", buf);
 204:	dc040593          	addi	a1,s0,-576
 208:	8556                	mv	a0,s5
 20a:	00000097          	auipc	ra,0x0
 20e:	6f4080e7          	jalr	1780(ra) # 8fe <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 212:	4641                	li	a2,16
 214:	db040593          	addi	a1,s0,-592
 218:	8526                	mv	a0,s1
 21a:	00000097          	auipc	ra,0x0
 21e:	35a080e7          	jalr	858(ra) # 574 <read>
 222:	47c1                	li	a5,16
 224:	f0f51ae3          	bne	a0,a5,138 <ls+0x84>
      if(de.inum == 0)
 228:	db045783          	lhu	a5,-592(s0)
 22c:	d3fd                	beqz	a5,212 <ls+0x15e>
      memmove(p, de.name, DIRSIZ);
 22e:	4639                	li	a2,14
 230:	db240593          	addi	a1,s0,-590
 234:	854e                	mv	a0,s3
 236:	00000097          	auipc	ra,0x0
 23a:	274080e7          	jalr	628(ra) # 4aa <memmove>
      p[DIRSIZ] = 0;
 23e:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 242:	d9840593          	addi	a1,s0,-616
 246:	dc040513          	addi	a0,s0,-576
 24a:	00000097          	auipc	ra,0x0
 24e:	1d2080e7          	jalr	466(ra) # 41c <stat>
 252:	fa0549e3          	bltz	a0,204 <ls+0x150>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 256:	dc040513          	addi	a0,s0,-576
 25a:	00000097          	auipc	ra,0x0
 25e:	da6080e7          	jalr	-602(ra) # 0 <fmtname>
 262:	85aa                	mv	a1,a0
 264:	da843703          	ld	a4,-600(s0)
 268:	d9c42683          	lw	a3,-612(s0)
 26c:	da041603          	lh	a2,-608(s0)
 270:	8552                	mv	a0,s4
 272:	00000097          	auipc	ra,0x0
 276:	68c080e7          	jalr	1676(ra) # 8fe <printf>
 27a:	bf61                	j	212 <ls+0x15e>

000000000000027c <main>:

int
main(int argc, char *argv[])
{
 27c:	1101                	addi	sp,sp,-32
 27e:	ec06                	sd	ra,24(sp)
 280:	e822                	sd	s0,16(sp)
 282:	e426                	sd	s1,8(sp)
 284:	e04a                	sd	s2,0(sp)
 286:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 288:	4785                	li	a5,1
 28a:	02a7d963          	bge	a5,a0,2bc <main+0x40>
 28e:	00858493          	addi	s1,a1,8
 292:	ffe5091b          	addiw	s2,a0,-2
 296:	02091793          	slli	a5,s2,0x20
 29a:	01d7d913          	srli	s2,a5,0x1d
 29e:	05c1                	addi	a1,a1,16
 2a0:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a2:	6088                	ld	a0,0(s1)
 2a4:	00000097          	auipc	ra,0x0
 2a8:	e10080e7          	jalr	-496(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2ac:	04a1                	addi	s1,s1,8
 2ae:	ff249ae3          	bne	s1,s2,2a2 <main+0x26>
  exit(0);
 2b2:	4501                	li	a0,0
 2b4:	00000097          	auipc	ra,0x0
 2b8:	2a8080e7          	jalr	680(ra) # 55c <exit>
    ls(".");
 2bc:	00001517          	auipc	a0,0x1
 2c0:	cec50513          	addi	a0,a0,-788 # fa8 <get_time_perf+0xc8>
 2c4:	00000097          	auipc	ra,0x0
 2c8:	df0080e7          	jalr	-528(ra) # b4 <ls>
    exit(0);
 2cc:	4501                	li	a0,0
 2ce:	00000097          	auipc	ra,0x0
 2d2:	28e080e7          	jalr	654(ra) # 55c <exit>

00000000000002d6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2de:	00000097          	auipc	ra,0x0
 2e2:	f9e080e7          	jalr	-98(ra) # 27c <main>
  exit(0);
 2e6:	4501                	li	a0,0
 2e8:	00000097          	auipc	ra,0x0
 2ec:	274080e7          	jalr	628(ra) # 55c <exit>

00000000000002f0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2f6:	87aa                	mv	a5,a0
 2f8:	0585                	addi	a1,a1,1
 2fa:	0785                	addi	a5,a5,1
 2fc:	fff5c703          	lbu	a4,-1(a1)
 300:	fee78fa3          	sb	a4,-1(a5)
 304:	fb75                	bnez	a4,2f8 <strcpy+0x8>
    ;
  return os;
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 312:	00054783          	lbu	a5,0(a0)
 316:	cb91                	beqz	a5,32a <strcmp+0x1e>
 318:	0005c703          	lbu	a4,0(a1)
 31c:	00f71763          	bne	a4,a5,32a <strcmp+0x1e>
    p++, q++;
 320:	0505                	addi	a0,a0,1
 322:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 324:	00054783          	lbu	a5,0(a0)
 328:	fbe5                	bnez	a5,318 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 32a:	0005c503          	lbu	a0,0(a1)
}
 32e:	40a7853b          	subw	a0,a5,a0
 332:	6422                	ld	s0,8(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret

0000000000000338 <strlen>:

uint
strlen(const char *s)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 33e:	00054783          	lbu	a5,0(a0)
 342:	cf91                	beqz	a5,35e <strlen+0x26>
 344:	0505                	addi	a0,a0,1
 346:	87aa                	mv	a5,a0
 348:	4685                	li	a3,1
 34a:	9e89                	subw	a3,a3,a0
 34c:	00f6853b          	addw	a0,a3,a5
 350:	0785                	addi	a5,a5,1
 352:	fff7c703          	lbu	a4,-1(a5)
 356:	fb7d                	bnez	a4,34c <strlen+0x14>
    ;
  return n;
}
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
  for(n = 0; s[n]; n++)
 35e:	4501                	li	a0,0
 360:	bfe5                	j	358 <strlen+0x20>

0000000000000362 <memset>:

void*
memset(void *dst, int c, uint n)
{
 362:	1141                	addi	sp,sp,-16
 364:	e422                	sd	s0,8(sp)
 366:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 368:	ca19                	beqz	a2,37e <memset+0x1c>
 36a:	87aa                	mv	a5,a0
 36c:	1602                	slli	a2,a2,0x20
 36e:	9201                	srli	a2,a2,0x20
 370:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 374:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 378:	0785                	addi	a5,a5,1
 37a:	fee79de3          	bne	a5,a4,374 <memset+0x12>
  }
  return dst;
}
 37e:	6422                	ld	s0,8(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <strchr>:

char*
strchr(const char *s, char c)
{
 384:	1141                	addi	sp,sp,-16
 386:	e422                	sd	s0,8(sp)
 388:	0800                	addi	s0,sp,16
  for(; *s; s++)
 38a:	00054783          	lbu	a5,0(a0)
 38e:	cb99                	beqz	a5,3a4 <strchr+0x20>
    if(*s == c)
 390:	00f58763          	beq	a1,a5,39e <strchr+0x1a>
  for(; *s; s++)
 394:	0505                	addi	a0,a0,1
 396:	00054783          	lbu	a5,0(a0)
 39a:	fbfd                	bnez	a5,390 <strchr+0xc>
      return (char*)s;
  return 0;
 39c:	4501                	li	a0,0
}
 39e:	6422                	ld	s0,8(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret
  return 0;
 3a4:	4501                	li	a0,0
 3a6:	bfe5                	j	39e <strchr+0x1a>

00000000000003a8 <gets>:

char*
gets(char *buf, int max)
{
 3a8:	711d                	addi	sp,sp,-96
 3aa:	ec86                	sd	ra,88(sp)
 3ac:	e8a2                	sd	s0,80(sp)
 3ae:	e4a6                	sd	s1,72(sp)
 3b0:	e0ca                	sd	s2,64(sp)
 3b2:	fc4e                	sd	s3,56(sp)
 3b4:	f852                	sd	s4,48(sp)
 3b6:	f456                	sd	s5,40(sp)
 3b8:	f05a                	sd	s6,32(sp)
 3ba:	ec5e                	sd	s7,24(sp)
 3bc:	1080                	addi	s0,sp,96
 3be:	8baa                	mv	s7,a0
 3c0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c2:	892a                	mv	s2,a0
 3c4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3c6:	4aa9                	li	s5,10
 3c8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3ca:	89a6                	mv	s3,s1
 3cc:	2485                	addiw	s1,s1,1
 3ce:	0344d863          	bge	s1,s4,3fe <gets+0x56>
    cc = read(0, &c, 1);
 3d2:	4605                	li	a2,1
 3d4:	faf40593          	addi	a1,s0,-81
 3d8:	4501                	li	a0,0
 3da:	00000097          	auipc	ra,0x0
 3de:	19a080e7          	jalr	410(ra) # 574 <read>
    if(cc < 1)
 3e2:	00a05e63          	blez	a0,3fe <gets+0x56>
    buf[i++] = c;
 3e6:	faf44783          	lbu	a5,-81(s0)
 3ea:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3ee:	01578763          	beq	a5,s5,3fc <gets+0x54>
 3f2:	0905                	addi	s2,s2,1
 3f4:	fd679be3          	bne	a5,s6,3ca <gets+0x22>
  for(i=0; i+1 < max; ){
 3f8:	89a6                	mv	s3,s1
 3fa:	a011                	j	3fe <gets+0x56>
 3fc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3fe:	99de                	add	s3,s3,s7
 400:	00098023          	sb	zero,0(s3)
  return buf;
}
 404:	855e                	mv	a0,s7
 406:	60e6                	ld	ra,88(sp)
 408:	6446                	ld	s0,80(sp)
 40a:	64a6                	ld	s1,72(sp)
 40c:	6906                	ld	s2,64(sp)
 40e:	79e2                	ld	s3,56(sp)
 410:	7a42                	ld	s4,48(sp)
 412:	7aa2                	ld	s5,40(sp)
 414:	7b02                	ld	s6,32(sp)
 416:	6be2                	ld	s7,24(sp)
 418:	6125                	addi	sp,sp,96
 41a:	8082                	ret

000000000000041c <stat>:

int
stat(const char *n, struct stat *st)
{
 41c:	1101                	addi	sp,sp,-32
 41e:	ec06                	sd	ra,24(sp)
 420:	e822                	sd	s0,16(sp)
 422:	e426                	sd	s1,8(sp)
 424:	e04a                	sd	s2,0(sp)
 426:	1000                	addi	s0,sp,32
 428:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 42a:	4581                	li	a1,0
 42c:	00000097          	auipc	ra,0x0
 430:	170080e7          	jalr	368(ra) # 59c <open>
  if(fd < 0)
 434:	02054563          	bltz	a0,45e <stat+0x42>
 438:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 43a:	85ca                	mv	a1,s2
 43c:	00000097          	auipc	ra,0x0
 440:	178080e7          	jalr	376(ra) # 5b4 <fstat>
 444:	892a                	mv	s2,a0
  close(fd);
 446:	8526                	mv	a0,s1
 448:	00000097          	auipc	ra,0x0
 44c:	13c080e7          	jalr	316(ra) # 584 <close>
  return r;
}
 450:	854a                	mv	a0,s2
 452:	60e2                	ld	ra,24(sp)
 454:	6442                	ld	s0,16(sp)
 456:	64a2                	ld	s1,8(sp)
 458:	6902                	ld	s2,0(sp)
 45a:	6105                	addi	sp,sp,32
 45c:	8082                	ret
    return -1;
 45e:	597d                	li	s2,-1
 460:	bfc5                	j	450 <stat+0x34>

0000000000000462 <atoi>:

int
atoi(const char *s)
{
 462:	1141                	addi	sp,sp,-16
 464:	e422                	sd	s0,8(sp)
 466:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 468:	00054683          	lbu	a3,0(a0)
 46c:	fd06879b          	addiw	a5,a3,-48
 470:	0ff7f793          	zext.b	a5,a5
 474:	4625                	li	a2,9
 476:	02f66863          	bltu	a2,a5,4a6 <atoi+0x44>
 47a:	872a                	mv	a4,a0
  n = 0;
 47c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 47e:	0705                	addi	a4,a4,1
 480:	0025179b          	slliw	a5,a0,0x2
 484:	9fa9                	addw	a5,a5,a0
 486:	0017979b          	slliw	a5,a5,0x1
 48a:	9fb5                	addw	a5,a5,a3
 48c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 490:	00074683          	lbu	a3,0(a4)
 494:	fd06879b          	addiw	a5,a3,-48
 498:	0ff7f793          	zext.b	a5,a5
 49c:	fef671e3          	bgeu	a2,a5,47e <atoi+0x1c>
  return n;
}
 4a0:	6422                	ld	s0,8(sp)
 4a2:	0141                	addi	sp,sp,16
 4a4:	8082                	ret
  n = 0;
 4a6:	4501                	li	a0,0
 4a8:	bfe5                	j	4a0 <atoi+0x3e>

00000000000004aa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4aa:	1141                	addi	sp,sp,-16
 4ac:	e422                	sd	s0,8(sp)
 4ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4b0:	02b57463          	bgeu	a0,a1,4d8 <memmove+0x2e>
    while(n-- > 0)
 4b4:	00c05f63          	blez	a2,4d2 <memmove+0x28>
 4b8:	1602                	slli	a2,a2,0x20
 4ba:	9201                	srli	a2,a2,0x20
 4bc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4c0:	872a                	mv	a4,a0
      *dst++ = *src++;
 4c2:	0585                	addi	a1,a1,1
 4c4:	0705                	addi	a4,a4,1
 4c6:	fff5c683          	lbu	a3,-1(a1)
 4ca:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4ce:	fee79ae3          	bne	a5,a4,4c2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4d2:	6422                	ld	s0,8(sp)
 4d4:	0141                	addi	sp,sp,16
 4d6:	8082                	ret
    dst += n;
 4d8:	00c50733          	add	a4,a0,a2
    src += n;
 4dc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4de:	fec05ae3          	blez	a2,4d2 <memmove+0x28>
 4e2:	fff6079b          	addiw	a5,a2,-1
 4e6:	1782                	slli	a5,a5,0x20
 4e8:	9381                	srli	a5,a5,0x20
 4ea:	fff7c793          	not	a5,a5
 4ee:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4f0:	15fd                	addi	a1,a1,-1
 4f2:	177d                	addi	a4,a4,-1
 4f4:	0005c683          	lbu	a3,0(a1)
 4f8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4fc:	fee79ae3          	bne	a5,a4,4f0 <memmove+0x46>
 500:	bfc9                	j	4d2 <memmove+0x28>

0000000000000502 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 502:	1141                	addi	sp,sp,-16
 504:	e422                	sd	s0,8(sp)
 506:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 508:	ca05                	beqz	a2,538 <memcmp+0x36>
 50a:	fff6069b          	addiw	a3,a2,-1
 50e:	1682                	slli	a3,a3,0x20
 510:	9281                	srli	a3,a3,0x20
 512:	0685                	addi	a3,a3,1
 514:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 516:	00054783          	lbu	a5,0(a0)
 51a:	0005c703          	lbu	a4,0(a1)
 51e:	00e79863          	bne	a5,a4,52e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 522:	0505                	addi	a0,a0,1
    p2++;
 524:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 526:	fed518e3          	bne	a0,a3,516 <memcmp+0x14>
  }
  return 0;
 52a:	4501                	li	a0,0
 52c:	a019                	j	532 <memcmp+0x30>
      return *p1 - *p2;
 52e:	40e7853b          	subw	a0,a5,a4
}
 532:	6422                	ld	s0,8(sp)
 534:	0141                	addi	sp,sp,16
 536:	8082                	ret
  return 0;
 538:	4501                	li	a0,0
 53a:	bfe5                	j	532 <memcmp+0x30>

000000000000053c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 53c:	1141                	addi	sp,sp,-16
 53e:	e406                	sd	ra,8(sp)
 540:	e022                	sd	s0,0(sp)
 542:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 544:	00000097          	auipc	ra,0x0
 548:	f66080e7          	jalr	-154(ra) # 4aa <memmove>
}
 54c:	60a2                	ld	ra,8(sp)
 54e:	6402                	ld	s0,0(sp)
 550:	0141                	addi	sp,sp,16
 552:	8082                	ret

0000000000000554 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 554:	4885                	li	a7,1
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <exit>:
.global exit
exit:
 li a7, SYS_exit
 55c:	4889                	li	a7,2
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <wait>:
.global wait
wait:
 li a7, SYS_wait
 564:	488d                	li	a7,3
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 56c:	4891                	li	a7,4
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <read>:
.global read
read:
 li a7, SYS_read
 574:	4895                	li	a7,5
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <write>:
.global write
write:
 li a7, SYS_write
 57c:	48c1                	li	a7,16
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <close>:
.global close
close:
 li a7, SYS_close
 584:	48d5                	li	a7,21
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <kill>:
.global kill
kill:
 li a7, SYS_kill
 58c:	4899                	li	a7,6
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <exec>:
.global exec
exec:
 li a7, SYS_exec
 594:	489d                	li	a7,7
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <open>:
.global open
open:
 li a7, SYS_open
 59c:	48bd                	li	a7,15
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5a4:	48c5                	li	a7,17
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ac:	48c9                	li	a7,18
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5b4:	48a1                	li	a7,8
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <link>:
.global link
link:
 li a7, SYS_link
 5bc:	48cd                	li	a7,19
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5c4:	48d1                	li	a7,20
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5cc:	48a5                	li	a7,9
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5d4:	48a9                	li	a7,10
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5dc:	48ad                	li	a7,11
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5e4:	48b1                	li	a7,12
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ec:	48b5                	li	a7,13
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5f4:	48b9                	li	a7,14
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <head>:
.global head
head:
 li a7, SYS_head
 5fc:	48d9                	li	a7,22
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 604:	48dd                	li	a7,23
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <ps>:
.global ps
ps:
 li a7, SYS_ps
 60c:	48e1                	li	a7,24
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <times>:
.global times
times:
 li a7, SYS_times
 614:	48e5                	li	a7,25
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 61c:	48e9                	li	a7,26
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 624:	1101                	addi	sp,sp,-32
 626:	ec06                	sd	ra,24(sp)
 628:	e822                	sd	s0,16(sp)
 62a:	1000                	addi	s0,sp,32
 62c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 630:	4605                	li	a2,1
 632:	fef40593          	addi	a1,s0,-17
 636:	00000097          	auipc	ra,0x0
 63a:	f46080e7          	jalr	-186(ra) # 57c <write>
}
 63e:	60e2                	ld	ra,24(sp)
 640:	6442                	ld	s0,16(sp)
 642:	6105                	addi	sp,sp,32
 644:	8082                	ret

0000000000000646 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 646:	7139                	addi	sp,sp,-64
 648:	fc06                	sd	ra,56(sp)
 64a:	f822                	sd	s0,48(sp)
 64c:	f426                	sd	s1,40(sp)
 64e:	f04a                	sd	s2,32(sp)
 650:	ec4e                	sd	s3,24(sp)
 652:	0080                	addi	s0,sp,64
 654:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 656:	c299                	beqz	a3,65c <printint+0x16>
 658:	0805c963          	bltz	a1,6ea <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 65c:	2581                	sext.w	a1,a1
  neg = 0;
 65e:	4881                	li	a7,0
 660:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 664:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 666:	2601                	sext.w	a2,a2
 668:	00001517          	auipc	a0,0x1
 66c:	9a850513          	addi	a0,a0,-1624 # 1010 <digits>
 670:	883a                	mv	a6,a4
 672:	2705                	addiw	a4,a4,1
 674:	02c5f7bb          	remuw	a5,a1,a2
 678:	1782                	slli	a5,a5,0x20
 67a:	9381                	srli	a5,a5,0x20
 67c:	97aa                	add	a5,a5,a0
 67e:	0007c783          	lbu	a5,0(a5)
 682:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 686:	0005879b          	sext.w	a5,a1
 68a:	02c5d5bb          	divuw	a1,a1,a2
 68e:	0685                	addi	a3,a3,1
 690:	fec7f0e3          	bgeu	a5,a2,670 <printint+0x2a>
  if(neg)
 694:	00088c63          	beqz	a7,6ac <printint+0x66>
    buf[i++] = '-';
 698:	fd070793          	addi	a5,a4,-48
 69c:	00878733          	add	a4,a5,s0
 6a0:	02d00793          	li	a5,45
 6a4:	fef70823          	sb	a5,-16(a4)
 6a8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6ac:	02e05863          	blez	a4,6dc <printint+0x96>
 6b0:	fc040793          	addi	a5,s0,-64
 6b4:	00e78933          	add	s2,a5,a4
 6b8:	fff78993          	addi	s3,a5,-1
 6bc:	99ba                	add	s3,s3,a4
 6be:	377d                	addiw	a4,a4,-1
 6c0:	1702                	slli	a4,a4,0x20
 6c2:	9301                	srli	a4,a4,0x20
 6c4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6c8:	fff94583          	lbu	a1,-1(s2)
 6cc:	8526                	mv	a0,s1
 6ce:	00000097          	auipc	ra,0x0
 6d2:	f56080e7          	jalr	-170(ra) # 624 <putc>
  while(--i >= 0)
 6d6:	197d                	addi	s2,s2,-1
 6d8:	ff3918e3          	bne	s2,s3,6c8 <printint+0x82>
}
 6dc:	70e2                	ld	ra,56(sp)
 6de:	7442                	ld	s0,48(sp)
 6e0:	74a2                	ld	s1,40(sp)
 6e2:	7902                	ld	s2,32(sp)
 6e4:	69e2                	ld	s3,24(sp)
 6e6:	6121                	addi	sp,sp,64
 6e8:	8082                	ret
    x = -xx;
 6ea:	40b005bb          	negw	a1,a1
    neg = 1;
 6ee:	4885                	li	a7,1
    x = -xx;
 6f0:	bf85                	j	660 <printint+0x1a>

00000000000006f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6f2:	7119                	addi	sp,sp,-128
 6f4:	fc86                	sd	ra,120(sp)
 6f6:	f8a2                	sd	s0,112(sp)
 6f8:	f4a6                	sd	s1,104(sp)
 6fa:	f0ca                	sd	s2,96(sp)
 6fc:	ecce                	sd	s3,88(sp)
 6fe:	e8d2                	sd	s4,80(sp)
 700:	e4d6                	sd	s5,72(sp)
 702:	e0da                	sd	s6,64(sp)
 704:	fc5e                	sd	s7,56(sp)
 706:	f862                	sd	s8,48(sp)
 708:	f466                	sd	s9,40(sp)
 70a:	f06a                	sd	s10,32(sp)
 70c:	ec6e                	sd	s11,24(sp)
 70e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 710:	0005c903          	lbu	s2,0(a1)
 714:	18090f63          	beqz	s2,8b2 <vprintf+0x1c0>
 718:	8aaa                	mv	s5,a0
 71a:	8b32                	mv	s6,a2
 71c:	00158493          	addi	s1,a1,1
  state = 0;
 720:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 722:	02500a13          	li	s4,37
 726:	4c55                	li	s8,21
 728:	00001c97          	auipc	s9,0x1
 72c:	890c8c93          	addi	s9,s9,-1904 # fb8 <get_time_perf+0xd8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 730:	02800d93          	li	s11,40
  putc(fd, 'x');
 734:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 736:	00001b97          	auipc	s7,0x1
 73a:	8dab8b93          	addi	s7,s7,-1830 # 1010 <digits>
 73e:	a839                	j	75c <vprintf+0x6a>
        putc(fd, c);
 740:	85ca                	mv	a1,s2
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	ee0080e7          	jalr	-288(ra) # 624 <putc>
 74c:	a019                	j	752 <vprintf+0x60>
    } else if(state == '%'){
 74e:	01498d63          	beq	s3,s4,768 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 752:	0485                	addi	s1,s1,1
 754:	fff4c903          	lbu	s2,-1(s1)
 758:	14090d63          	beqz	s2,8b2 <vprintf+0x1c0>
    if(state == 0){
 75c:	fe0999e3          	bnez	s3,74e <vprintf+0x5c>
      if(c == '%'){
 760:	ff4910e3          	bne	s2,s4,740 <vprintf+0x4e>
        state = '%';
 764:	89d2                	mv	s3,s4
 766:	b7f5                	j	752 <vprintf+0x60>
      if(c == 'd'){
 768:	11490c63          	beq	s2,s4,880 <vprintf+0x18e>
 76c:	f9d9079b          	addiw	a5,s2,-99
 770:	0ff7f793          	zext.b	a5,a5
 774:	10fc6e63          	bltu	s8,a5,890 <vprintf+0x19e>
 778:	f9d9079b          	addiw	a5,s2,-99
 77c:	0ff7f713          	zext.b	a4,a5
 780:	10ec6863          	bltu	s8,a4,890 <vprintf+0x19e>
 784:	00271793          	slli	a5,a4,0x2
 788:	97e6                	add	a5,a5,s9
 78a:	439c                	lw	a5,0(a5)
 78c:	97e6                	add	a5,a5,s9
 78e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 790:	008b0913          	addi	s2,s6,8
 794:	4685                	li	a3,1
 796:	4629                	li	a2,10
 798:	000b2583          	lw	a1,0(s6)
 79c:	8556                	mv	a0,s5
 79e:	00000097          	auipc	ra,0x0
 7a2:	ea8080e7          	jalr	-344(ra) # 646 <printint>
 7a6:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	b765                	j	752 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ac:	008b0913          	addi	s2,s6,8
 7b0:	4681                	li	a3,0
 7b2:	4629                	li	a2,10
 7b4:	000b2583          	lw	a1,0(s6)
 7b8:	8556                	mv	a0,s5
 7ba:	00000097          	auipc	ra,0x0
 7be:	e8c080e7          	jalr	-372(ra) # 646 <printint>
 7c2:	8b4a                	mv	s6,s2
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	b771                	j	752 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7c8:	008b0913          	addi	s2,s6,8
 7cc:	4681                	li	a3,0
 7ce:	866a                	mv	a2,s10
 7d0:	000b2583          	lw	a1,0(s6)
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	e70080e7          	jalr	-400(ra) # 646 <printint>
 7de:	8b4a                	mv	s6,s2
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	bf85                	j	752 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7e4:	008b0793          	addi	a5,s6,8
 7e8:	f8f43423          	sd	a5,-120(s0)
 7ec:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7f0:	03000593          	li	a1,48
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	e2e080e7          	jalr	-466(ra) # 624 <putc>
  putc(fd, 'x');
 7fe:	07800593          	li	a1,120
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	e20080e7          	jalr	-480(ra) # 624 <putc>
 80c:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 80e:	03c9d793          	srli	a5,s3,0x3c
 812:	97de                	add	a5,a5,s7
 814:	0007c583          	lbu	a1,0(a5)
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	e0a080e7          	jalr	-502(ra) # 624 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 822:	0992                	slli	s3,s3,0x4
 824:	397d                	addiw	s2,s2,-1
 826:	fe0914e3          	bnez	s2,80e <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 82a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 82e:	4981                	li	s3,0
 830:	b70d                	j	752 <vprintf+0x60>
        s = va_arg(ap, char*);
 832:	008b0913          	addi	s2,s6,8
 836:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 83a:	02098163          	beqz	s3,85c <vprintf+0x16a>
        while(*s != 0){
 83e:	0009c583          	lbu	a1,0(s3)
 842:	c5ad                	beqz	a1,8ac <vprintf+0x1ba>
          putc(fd, *s);
 844:	8556                	mv	a0,s5
 846:	00000097          	auipc	ra,0x0
 84a:	dde080e7          	jalr	-546(ra) # 624 <putc>
          s++;
 84e:	0985                	addi	s3,s3,1
        while(*s != 0){
 850:	0009c583          	lbu	a1,0(s3)
 854:	f9e5                	bnez	a1,844 <vprintf+0x152>
        s = va_arg(ap, char*);
 856:	8b4a                	mv	s6,s2
      state = 0;
 858:	4981                	li	s3,0
 85a:	bde5                	j	752 <vprintf+0x60>
          s = "(null)";
 85c:	00000997          	auipc	s3,0x0
 860:	75498993          	addi	s3,s3,1876 # fb0 <get_time_perf+0xd0>
        while(*s != 0){
 864:	85ee                	mv	a1,s11
 866:	bff9                	j	844 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 868:	008b0913          	addi	s2,s6,8
 86c:	000b4583          	lbu	a1,0(s6)
 870:	8556                	mv	a0,s5
 872:	00000097          	auipc	ra,0x0
 876:	db2080e7          	jalr	-590(ra) # 624 <putc>
 87a:	8b4a                	mv	s6,s2
      state = 0;
 87c:	4981                	li	s3,0
 87e:	bdd1                	j	752 <vprintf+0x60>
        putc(fd, c);
 880:	85d2                	mv	a1,s4
 882:	8556                	mv	a0,s5
 884:	00000097          	auipc	ra,0x0
 888:	da0080e7          	jalr	-608(ra) # 624 <putc>
      state = 0;
 88c:	4981                	li	s3,0
 88e:	b5d1                	j	752 <vprintf+0x60>
        putc(fd, '%');
 890:	85d2                	mv	a1,s4
 892:	8556                	mv	a0,s5
 894:	00000097          	auipc	ra,0x0
 898:	d90080e7          	jalr	-624(ra) # 624 <putc>
        putc(fd, c);
 89c:	85ca                	mv	a1,s2
 89e:	8556                	mv	a0,s5
 8a0:	00000097          	auipc	ra,0x0
 8a4:	d84080e7          	jalr	-636(ra) # 624 <putc>
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	b565                	j	752 <vprintf+0x60>
        s = va_arg(ap, char*);
 8ac:	8b4a                	mv	s6,s2
      state = 0;
 8ae:	4981                	li	s3,0
 8b0:	b54d                	j	752 <vprintf+0x60>
    }
  }
}
 8b2:	70e6                	ld	ra,120(sp)
 8b4:	7446                	ld	s0,112(sp)
 8b6:	74a6                	ld	s1,104(sp)
 8b8:	7906                	ld	s2,96(sp)
 8ba:	69e6                	ld	s3,88(sp)
 8bc:	6a46                	ld	s4,80(sp)
 8be:	6aa6                	ld	s5,72(sp)
 8c0:	6b06                	ld	s6,64(sp)
 8c2:	7be2                	ld	s7,56(sp)
 8c4:	7c42                	ld	s8,48(sp)
 8c6:	7ca2                	ld	s9,40(sp)
 8c8:	7d02                	ld	s10,32(sp)
 8ca:	6de2                	ld	s11,24(sp)
 8cc:	6109                	addi	sp,sp,128
 8ce:	8082                	ret

00000000000008d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d0:	715d                	addi	sp,sp,-80
 8d2:	ec06                	sd	ra,24(sp)
 8d4:	e822                	sd	s0,16(sp)
 8d6:	1000                	addi	s0,sp,32
 8d8:	e010                	sd	a2,0(s0)
 8da:	e414                	sd	a3,8(s0)
 8dc:	e818                	sd	a4,16(s0)
 8de:	ec1c                	sd	a5,24(s0)
 8e0:	03043023          	sd	a6,32(s0)
 8e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ec:	8622                	mv	a2,s0
 8ee:	00000097          	auipc	ra,0x0
 8f2:	e04080e7          	jalr	-508(ra) # 6f2 <vprintf>
}
 8f6:	60e2                	ld	ra,24(sp)
 8f8:	6442                	ld	s0,16(sp)
 8fa:	6161                	addi	sp,sp,80
 8fc:	8082                	ret

00000000000008fe <printf>:

void
printf(const char *fmt, ...)
{
 8fe:	711d                	addi	sp,sp,-96
 900:	ec06                	sd	ra,24(sp)
 902:	e822                	sd	s0,16(sp)
 904:	1000                	addi	s0,sp,32
 906:	e40c                	sd	a1,8(s0)
 908:	e810                	sd	a2,16(s0)
 90a:	ec14                	sd	a3,24(s0)
 90c:	f018                	sd	a4,32(s0)
 90e:	f41c                	sd	a5,40(s0)
 910:	03043823          	sd	a6,48(s0)
 914:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 918:	00840613          	addi	a2,s0,8
 91c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 920:	85aa                	mv	a1,a0
 922:	4505                	li	a0,1
 924:	00000097          	auipc	ra,0x0
 928:	dce080e7          	jalr	-562(ra) # 6f2 <vprintf>
}
 92c:	60e2                	ld	ra,24(sp)
 92e:	6442                	ld	s0,16(sp)
 930:	6125                	addi	sp,sp,96
 932:	8082                	ret

0000000000000934 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 934:	1141                	addi	sp,sp,-16
 936:	e422                	sd	s0,8(sp)
 938:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 93a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93e:	00001797          	auipc	a5,0x1
 942:	6c27b783          	ld	a5,1730(a5) # 2000 <freep>
 946:	a02d                	j	970 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 948:	4618                	lw	a4,8(a2)
 94a:	9f2d                	addw	a4,a4,a1
 94c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 950:	6398                	ld	a4,0(a5)
 952:	6310                	ld	a2,0(a4)
 954:	a83d                	j	992 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 956:	ff852703          	lw	a4,-8(a0)
 95a:	9f31                	addw	a4,a4,a2
 95c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 95e:	ff053683          	ld	a3,-16(a0)
 962:	a091                	j	9a6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 964:	6398                	ld	a4,0(a5)
 966:	00e7e463          	bltu	a5,a4,96e <free+0x3a>
 96a:	00e6ea63          	bltu	a3,a4,97e <free+0x4a>
{
 96e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 970:	fed7fae3          	bgeu	a5,a3,964 <free+0x30>
 974:	6398                	ld	a4,0(a5)
 976:	00e6e463          	bltu	a3,a4,97e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97a:	fee7eae3          	bltu	a5,a4,96e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 97e:	ff852583          	lw	a1,-8(a0)
 982:	6390                	ld	a2,0(a5)
 984:	02059813          	slli	a6,a1,0x20
 988:	01c85713          	srli	a4,a6,0x1c
 98c:	9736                	add	a4,a4,a3
 98e:	fae60de3          	beq	a2,a4,948 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 992:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 996:	4790                	lw	a2,8(a5)
 998:	02061593          	slli	a1,a2,0x20
 99c:	01c5d713          	srli	a4,a1,0x1c
 9a0:	973e                	add	a4,a4,a5
 9a2:	fae68ae3          	beq	a3,a4,956 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9a6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9a8:	00001717          	auipc	a4,0x1
 9ac:	64f73c23          	sd	a5,1624(a4) # 2000 <freep>
}
 9b0:	6422                	ld	s0,8(sp)
 9b2:	0141                	addi	sp,sp,16
 9b4:	8082                	ret

00000000000009b6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9b6:	7139                	addi	sp,sp,-64
 9b8:	fc06                	sd	ra,56(sp)
 9ba:	f822                	sd	s0,48(sp)
 9bc:	f426                	sd	s1,40(sp)
 9be:	f04a                	sd	s2,32(sp)
 9c0:	ec4e                	sd	s3,24(sp)
 9c2:	e852                	sd	s4,16(sp)
 9c4:	e456                	sd	s5,8(sp)
 9c6:	e05a                	sd	s6,0(sp)
 9c8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ca:	02051493          	slli	s1,a0,0x20
 9ce:	9081                	srli	s1,s1,0x20
 9d0:	04bd                	addi	s1,s1,15
 9d2:	8091                	srli	s1,s1,0x4
 9d4:	0014899b          	addiw	s3,s1,1
 9d8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9da:	00001517          	auipc	a0,0x1
 9de:	62653503          	ld	a0,1574(a0) # 2000 <freep>
 9e2:	c515                	beqz	a0,a0e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e6:	4798                	lw	a4,8(a5)
 9e8:	02977f63          	bgeu	a4,s1,a26 <malloc+0x70>
 9ec:	8a4e                	mv	s4,s3
 9ee:	0009871b          	sext.w	a4,s3
 9f2:	6685                	lui	a3,0x1
 9f4:	00d77363          	bgeu	a4,a3,9fa <malloc+0x44>
 9f8:	6a05                	lui	s4,0x1
 9fa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9fe:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a02:	00001917          	auipc	s2,0x1
 a06:	5fe90913          	addi	s2,s2,1534 # 2000 <freep>
  if(p == (char*)-1)
 a0a:	5afd                	li	s5,-1
 a0c:	a895                	j	a80 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a0e:	00001797          	auipc	a5,0x1
 a12:	61278793          	addi	a5,a5,1554 # 2020 <base>
 a16:	00001717          	auipc	a4,0x1
 a1a:	5ef73523          	sd	a5,1514(a4) # 2000 <freep>
 a1e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a20:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a24:	b7e1                	j	9ec <malloc+0x36>
      if(p->s.size == nunits)
 a26:	02e48c63          	beq	s1,a4,a5e <malloc+0xa8>
        p->s.size -= nunits;
 a2a:	4137073b          	subw	a4,a4,s3
 a2e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a30:	02071693          	slli	a3,a4,0x20
 a34:	01c6d713          	srli	a4,a3,0x1c
 a38:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a3a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a3e:	00001717          	auipc	a4,0x1
 a42:	5ca73123          	sd	a0,1474(a4) # 2000 <freep>
      return (void*)(p + 1);
 a46:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a4a:	70e2                	ld	ra,56(sp)
 a4c:	7442                	ld	s0,48(sp)
 a4e:	74a2                	ld	s1,40(sp)
 a50:	7902                	ld	s2,32(sp)
 a52:	69e2                	ld	s3,24(sp)
 a54:	6a42                	ld	s4,16(sp)
 a56:	6aa2                	ld	s5,8(sp)
 a58:	6b02                	ld	s6,0(sp)
 a5a:	6121                	addi	sp,sp,64
 a5c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a5e:	6398                	ld	a4,0(a5)
 a60:	e118                	sd	a4,0(a0)
 a62:	bff1                	j	a3e <malloc+0x88>
  hp->s.size = nu;
 a64:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a68:	0541                	addi	a0,a0,16
 a6a:	00000097          	auipc	ra,0x0
 a6e:	eca080e7          	jalr	-310(ra) # 934 <free>
  return freep;
 a72:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a76:	d971                	beqz	a0,a4a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a78:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a7a:	4798                	lw	a4,8(a5)
 a7c:	fa9775e3          	bgeu	a4,s1,a26 <malloc+0x70>
    if(p == freep)
 a80:	00093703          	ld	a4,0(s2)
 a84:	853e                	mv	a0,a5
 a86:	fef719e3          	bne	a4,a5,a78 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a8a:	8552                	mv	a0,s4
 a8c:	00000097          	auipc	ra,0x0
 a90:	b58080e7          	jalr	-1192(ra) # 5e4 <sbrk>
  if(p == (char*)-1)
 a94:	fd5518e3          	bne	a0,s5,a64 <malloc+0xae>
        return 0;
 a98:	4501                	li	a0,0
 a9a:	bf45                	j	a4a <malloc+0x94>

0000000000000a9c <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 a9c:	c1d9                	beqz	a1,b22 <head_run+0x86>
void head_run(int fd, int numOfLines){
 a9e:	dd010113          	addi	sp,sp,-560
 aa2:	22113423          	sd	ra,552(sp)
 aa6:	22813023          	sd	s0,544(sp)
 aaa:	20913c23          	sd	s1,536(sp)
 aae:	21213823          	sd	s2,528(sp)
 ab2:	21313423          	sd	s3,520(sp)
 ab6:	21413023          	sd	s4,512(sp)
 aba:	1c00                	addi	s0,sp,560
 abc:	892a                	mv	s2,a0
 abe:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 ac2:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 ac4:	00000a17          	auipc	s4,0x0
 ac8:	58ca0a13          	addi	s4,s4,1420 # 1050 <digits+0x40>
		readStatus = read_line(fd, line);
 acc:	dd840593          	addi	a1,s0,-552
 ad0:	854a                	mv	a0,s2
 ad2:	00000097          	auipc	ra,0x0
 ad6:	394080e7          	jalr	916(ra) # e66 <read_line>
		if (readStatus == READ_ERROR){
 ada:	01350d63          	beq	a0,s3,af4 <head_run+0x58>
		if (readStatus == READ_EOF)
 ade:	c11d                	beqz	a0,b04 <head_run+0x68>
		printf("%s",line);
 ae0:	dd840593          	addi	a1,s0,-552
 ae4:	8552                	mv	a0,s4
 ae6:	00000097          	auipc	ra,0x0
 aea:	e18080e7          	jalr	-488(ra) # 8fe <printf>
	while(numOfLines--){
 aee:	34fd                	addiw	s1,s1,-1
 af0:	fcf1                	bnez	s1,acc <head_run+0x30>
 af2:	a809                	j	b04 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 af4:	00000517          	auipc	a0,0x0
 af8:	53450513          	addi	a0,a0,1332 # 1028 <digits+0x18>
 afc:	00000097          	auipc	ra,0x0
 b00:	e02080e7          	jalr	-510(ra) # 8fe <printf>

	}
}
 b04:	22813083          	ld	ra,552(sp)
 b08:	22013403          	ld	s0,544(sp)
 b0c:	21813483          	ld	s1,536(sp)
 b10:	21013903          	ld	s2,528(sp)
 b14:	20813983          	ld	s3,520(sp)
 b18:	20013a03          	ld	s4,512(sp)
 b1c:	23010113          	addi	sp,sp,560
 b20:	8082                	ret
 b22:	8082                	ret

0000000000000b24 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 b24:	ba010113          	addi	sp,sp,-1120
 b28:	44113c23          	sd	ra,1112(sp)
 b2c:	44813823          	sd	s0,1104(sp)
 b30:	44913423          	sd	s1,1096(sp)
 b34:	45213023          	sd	s2,1088(sp)
 b38:	43313c23          	sd	s3,1080(sp)
 b3c:	43413823          	sd	s4,1072(sp)
 b40:	43513423          	sd	s5,1064(sp)
 b44:	43613023          	sd	s6,1056(sp)
 b48:	41713c23          	sd	s7,1048(sp)
 b4c:	41813823          	sd	s8,1040(sp)
 b50:	41913423          	sd	s9,1032(sp)
 b54:	41a13023          	sd	s10,1024(sp)
 b58:	3fb13c23          	sd	s11,1016(sp)
 b5c:	46010413          	addi	s0,sp,1120
 b60:	89aa                	mv	s3,a0
 b62:	8aae                	mv	s5,a1
 b64:	8c32                	mv	s8,a2
 b66:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 b68:	d9840593          	addi	a1,s0,-616
 b6c:	00000097          	auipc	ra,0x0
 b70:	2fa080e7          	jalr	762(ra) # e66 <read_line>


  if (readStatus == READ_ERROR)
 b74:	57fd                	li	a5,-1
 b76:	04f50163          	beq	a0,a5,bb8 <uniq_run+0x94>
 b7a:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 b7c:	ed21                	bnez	a0,bd4 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 b7e:	45813083          	ld	ra,1112(sp)
 b82:	45013403          	ld	s0,1104(sp)
 b86:	44813483          	ld	s1,1096(sp)
 b8a:	44013903          	ld	s2,1088(sp)
 b8e:	43813983          	ld	s3,1080(sp)
 b92:	43013a03          	ld	s4,1072(sp)
 b96:	42813a83          	ld	s5,1064(sp)
 b9a:	42013b03          	ld	s6,1056(sp)
 b9e:	41813b83          	ld	s7,1048(sp)
 ba2:	41013c03          	ld	s8,1040(sp)
 ba6:	40813c83          	ld	s9,1032(sp)
 baa:	40013d03          	ld	s10,1024(sp)
 bae:	3f813d83          	ld	s11,1016(sp)
 bb2:	46010113          	addi	sp,sp,1120
 bb6:	8082                	ret
    printf("[ERR] Error reading from the file ");
 bb8:	00000517          	auipc	a0,0x0
 bbc:	4a050513          	addi	a0,a0,1184 # 1058 <digits+0x48>
 bc0:	00000097          	auipc	ra,0x0
 bc4:	d3e080e7          	jalr	-706(ra) # 8fe <printf>
 bc8:	bf5d                	j	b7e <uniq_run+0x5a>
 bca:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 bcc:	8926                	mv	s2,s1
 bce:	84be                	mv	s1,a5
        lineCount = 1;
 bd0:	8b6a                	mv	s6,s10
 bd2:	a8ed                	j	ccc <uniq_run+0x1a8>
    int lineCount=1;
 bd4:	4b05                	li	s6,1
  char * line2 = buffer2;
 bd6:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 bda:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 bde:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 be0:	4d05                	li	s10,1
              printf("%s",line1);
 be2:	00000d97          	auipc	s11,0x0
 be6:	46ed8d93          	addi	s11,s11,1134 # 1050 <digits+0x40>
 bea:	a0cd                	j	ccc <uniq_run+0x1a8>
            if (repeatedLines){
 bec:	020a0b63          	beqz	s4,c22 <uniq_run+0xfe>
                if (isRepeated){
 bf0:	f80b87e3          	beqz	s7,b7e <uniq_run+0x5a>
                    if (showCount)
 bf4:	000c0d63          	beqz	s8,c0e <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 bf8:	864a                	mv	a2,s2
 bfa:	85da                	mv	a1,s6
 bfc:	00000517          	auipc	a0,0x0
 c00:	48450513          	addi	a0,a0,1156 # 1080 <digits+0x70>
 c04:	00000097          	auipc	ra,0x0
 c08:	cfa080e7          	jalr	-774(ra) # 8fe <printf>
 c0c:	bf8d                	j	b7e <uniq_run+0x5a>
                      printf("%s",line1);
 c0e:	85ca                	mv	a1,s2
 c10:	00000517          	auipc	a0,0x0
 c14:	44050513          	addi	a0,a0,1088 # 1050 <digits+0x40>
 c18:	00000097          	auipc	ra,0x0
 c1c:	ce6080e7          	jalr	-794(ra) # 8fe <printf>
 c20:	bfb9                	j	b7e <uniq_run+0x5a>
                if (showCount)
 c22:	000c0d63          	beqz	s8,c3c <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 c26:	864a                	mv	a2,s2
 c28:	85da                	mv	a1,s6
 c2a:	00000517          	auipc	a0,0x0
 c2e:	45650513          	addi	a0,a0,1110 # 1080 <digits+0x70>
 c32:	00000097          	auipc	ra,0x0
 c36:	ccc080e7          	jalr	-820(ra) # 8fe <printf>
 c3a:	b791                	j	b7e <uniq_run+0x5a>
                  printf("%s",line1);
 c3c:	85ca                	mv	a1,s2
 c3e:	00000517          	auipc	a0,0x0
 c42:	41250513          	addi	a0,a0,1042 # 1050 <digits+0x40>
 c46:	00000097          	auipc	ra,0x0
 c4a:	cb8080e7          	jalr	-840(ra) # 8fe <printf>
 c4e:	bf05                	j	b7e <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 c50:	00000517          	auipc	a0,0x0
 c54:	43850513          	addi	a0,a0,1080 # 1088 <digits+0x78>
 c58:	00000097          	auipc	ra,0x0
 c5c:	ca6080e7          	jalr	-858(ra) # 8fe <printf>
          break;
 c60:	bf39                	j	b7e <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 c62:	85a6                	mv	a1,s1
 c64:	854a                	mv	a0,s2
 c66:	00000097          	auipc	ra,0x0
 c6a:	110080e7          	jalr	272(ra) # d76 <compare_str_ic>
 c6e:	a041                	j	cee <uniq_run+0x1ca>
                  printf("%s",line1);
 c70:	85ca                	mv	a1,s2
 c72:	856e                	mv	a0,s11
 c74:	00000097          	auipc	ra,0x0
 c78:	c8a080e7          	jalr	-886(ra) # 8fe <printf>
        lineCount = 1;
 c7c:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 c7e:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 c80:	8926                	mv	s2,s1
                  printf("%s",line1);
 c82:	84be                	mv	s1,a5
        isRepeated = 0 ;
 c84:	4b81                	li	s7,0
 c86:	a099                	j	ccc <uniq_run+0x1a8>
            if (showCount)
 c88:	020c0263          	beqz	s8,cac <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 c8c:	864a                	mv	a2,s2
 c8e:	85da                	mv	a1,s6
 c90:	00000517          	auipc	a0,0x0
 c94:	3f050513          	addi	a0,a0,1008 # 1080 <digits+0x70>
 c98:	00000097          	auipc	ra,0x0
 c9c:	c66080e7          	jalr	-922(ra) # 8fe <printf>
 ca0:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 ca2:	8926                	mv	s2,s1
 ca4:	84be                	mv	s1,a5
        isRepeated = 0 ;
 ca6:	4b81                	li	s7,0
        lineCount = 1;
 ca8:	8b6a                	mv	s6,s10
 caa:	a00d                	j	ccc <uniq_run+0x1a8>
              printf("%s",line1);
 cac:	85ca                	mv	a1,s2
 cae:	856e                	mv	a0,s11
 cb0:	00000097          	auipc	ra,0x0
 cb4:	c4e080e7          	jalr	-946(ra) # 8fe <printf>
 cb8:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 cba:	8926                	mv	s2,s1
              printf("%s",line1);
 cbc:	84be                	mv	s1,a5
        isRepeated = 0 ;
 cbe:	4b81                	li	s7,0
        lineCount = 1;
 cc0:	8b6a                	mv	s6,s10
 cc2:	a029                	j	ccc <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 cc4:	000a0363          	beqz	s4,cca <uniq_run+0x1a6>
 cc8:	8bea                	mv	s7,s10
          lineCount++;
 cca:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 ccc:	85a6                	mv	a1,s1
 cce:	854e                	mv	a0,s3
 cd0:	00000097          	auipc	ra,0x0
 cd4:	196080e7          	jalr	406(ra) # e66 <read_line>
        if (readStatus == READ_EOF){
 cd8:	d911                	beqz	a0,bec <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 cda:	f7950be3          	beq	a0,s9,c50 <uniq_run+0x12c>
        if (!ignoreCase)
 cde:	f80a92e3          	bnez	s5,c62 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 ce2:	85a6                	mv	a1,s1
 ce4:	854a                	mv	a0,s2
 ce6:	00000097          	auipc	ra,0x0
 cea:	062080e7          	jalr	98(ra) # d48 <compare_str>
        if (compareStatus != 0){ 
 cee:	d979                	beqz	a0,cc4 <uniq_run+0x1a0>
          if (repeatedLines){
 cf0:	f80a0ce3          	beqz	s4,c88 <uniq_run+0x164>
            if (isRepeated){
 cf4:	ec0b8be3          	beqz	s7,bca <uniq_run+0xa6>
                if (showCount)
 cf8:	f60c0ce3          	beqz	s8,c70 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 cfc:	864a                	mv	a2,s2
 cfe:	85da                	mv	a1,s6
 d00:	00000517          	auipc	a0,0x0
 d04:	38050513          	addi	a0,a0,896 # 1080 <digits+0x70>
 d08:	00000097          	auipc	ra,0x0
 d0c:	bf6080e7          	jalr	-1034(ra) # 8fe <printf>
        lineCount = 1;
 d10:	8b5e                	mv	s6,s7
 d12:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 d14:	8926                	mv	s2,s1
 d16:	84be                	mv	s1,a5
        isRepeated = 0 ;
 d18:	4b81                	li	s7,0
 d1a:	bf4d                	j	ccc <uniq_run+0x1a8>

0000000000000d1c <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 d1c:	1141                	addi	sp,sp,-16
 d1e:	e422                	sd	s0,8(sp)
 d20:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 d22:	00054783          	lbu	a5,0(a0)
 d26:	cf99                	beqz	a5,d44 <get_strlen+0x28>
 d28:	00150713          	addi	a4,a0,1
 d2c:	87ba                	mv	a5,a4
 d2e:	4685                	li	a3,1
 d30:	9e99                	subw	a3,a3,a4
 d32:	00f6853b          	addw	a0,a3,a5
 d36:	0785                	addi	a5,a5,1
 d38:	fff7c703          	lbu	a4,-1(a5)
 d3c:	fb7d                	bnez	a4,d32 <get_strlen+0x16>
	return len;
}
 d3e:	6422                	ld	s0,8(sp)
 d40:	0141                	addi	sp,sp,16
 d42:	8082                	ret
	int len = 0;
 d44:	4501                	li	a0,0
 d46:	bfe5                	j	d3e <get_strlen+0x22>

0000000000000d48 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 d48:	1141                	addi	sp,sp,-16
 d4a:	e422                	sd	s0,8(sp)
 d4c:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 d4e:	00054783          	lbu	a5,0(a0)
 d52:	cb91                	beqz	a5,d66 <compare_str+0x1e>
 d54:	0005c703          	lbu	a4,0(a1)
 d58:	c719                	beqz	a4,d66 <compare_str+0x1e>
		if (*s1++ != *s2++)
 d5a:	0505                	addi	a0,a0,1
 d5c:	0585                	addi	a1,a1,1
 d5e:	fee788e3          	beq	a5,a4,d4e <compare_str+0x6>
			return 1;
 d62:	4505                	li	a0,1
 d64:	a031                	j	d70 <compare_str+0x28>
	}
	if (*s1 == *s2)
 d66:	0005c503          	lbu	a0,0(a1)
 d6a:	8d1d                	sub	a0,a0,a5
			return 1;
 d6c:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 d70:	6422                	ld	s0,8(sp)
 d72:	0141                	addi	sp,sp,16
 d74:	8082                	ret

0000000000000d76 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 d76:	1141                	addi	sp,sp,-16
 d78:	e422                	sd	s0,8(sp)
 d7a:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 d7c:	4665                	li	a2,25
	while(*s1 && *s2){
 d7e:	a019                	j	d84 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 d80:	04e79763          	bne	a5,a4,dce <compare_str_ic+0x58>
	while(*s1 && *s2){
 d84:	00054783          	lbu	a5,0(a0)
 d88:	cb9d                	beqz	a5,dbe <compare_str_ic+0x48>
 d8a:	0005c703          	lbu	a4,0(a1)
 d8e:	cb05                	beqz	a4,dbe <compare_str_ic+0x48>
		char b1 = *s1++;
 d90:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 d92:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 d94:	fbf7869b          	addiw	a3,a5,-65
 d98:	0ff6f693          	zext.b	a3,a3
 d9c:	00d66663          	bltu	a2,a3,da8 <compare_str_ic+0x32>
			b1 += 32;
 da0:	0207879b          	addiw	a5,a5,32
 da4:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 da8:	fbf7069b          	addiw	a3,a4,-65
 dac:	0ff6f693          	zext.b	a3,a3
 db0:	fcd668e3          	bltu	a2,a3,d80 <compare_str_ic+0xa>
			b2 += 32;
 db4:	0207071b          	addiw	a4,a4,32
 db8:	0ff77713          	zext.b	a4,a4
 dbc:	b7d1                	j	d80 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 dbe:	0005c503          	lbu	a0,0(a1)
 dc2:	8d1d                	sub	a0,a0,a5
			return 1;
 dc4:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 dc8:	6422                	ld	s0,8(sp)
 dca:	0141                	addi	sp,sp,16
 dcc:	8082                	ret
			return 1;
 dce:	4505                	li	a0,1
 dd0:	bfe5                	j	dc8 <compare_str_ic+0x52>

0000000000000dd2 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 dd2:	7179                	addi	sp,sp,-48
 dd4:	f406                	sd	ra,40(sp)
 dd6:	f022                	sd	s0,32(sp)
 dd8:	ec26                	sd	s1,24(sp)
 dda:	e84a                	sd	s2,16(sp)
 ddc:	e44e                	sd	s3,8(sp)
 dde:	1800                	addi	s0,sp,48
 de0:	89aa                	mv	s3,a0
 de2:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 de4:	00000097          	auipc	ra,0x0
 de8:	f38080e7          	jalr	-200(ra) # d1c <get_strlen>
 dec:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 dee:	854a                	mv	a0,s2
 df0:	00000097          	auipc	ra,0x0
 df4:	f2c080e7          	jalr	-212(ra) # d1c <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 df8:	409505bb          	subw	a1,a0,s1
 dfc:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 dfe:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 e00:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 e02:	0005da63          	bgez	a1,e16 <check_substr+0x44>
 e06:	a81d                	j	e3c <check_substr+0x6a>
        if (j == M)
 e08:	02f48a63          	beq	s1,a5,e3c <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 e0c:	0885                	addi	a7,a7,1
 e0e:	0008879b          	sext.w	a5,a7
 e12:	02f5cc63          	blt	a1,a5,e4a <check_substr+0x78>
 e16:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 e1a:	011906b3          	add	a3,s2,a7
 e1e:	874e                	mv	a4,s3
 e20:	879a                	mv	a5,t1
 e22:	fe9053e3          	blez	s1,e08 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 e26:	0006c803          	lbu	a6,0(a3) # 1000 <get_time_perf+0x120>
 e2a:	00074603          	lbu	a2,0(a4)
 e2e:	fcc81de3          	bne	a6,a2,e08 <check_substr+0x36>
        for (j = 0; j < M; j++)
 e32:	2785                	addiw	a5,a5,1
 e34:	0685                	addi	a3,a3,1
 e36:	0705                	addi	a4,a4,1
 e38:	fef497e3          	bne	s1,a5,e26 <check_substr+0x54>
}
 e3c:	70a2                	ld	ra,40(sp)
 e3e:	7402                	ld	s0,32(sp)
 e40:	64e2                	ld	s1,24(sp)
 e42:	6942                	ld	s2,16(sp)
 e44:	69a2                	ld	s3,8(sp)
 e46:	6145                	addi	sp,sp,48
 e48:	8082                	ret
    return -1;
 e4a:	557d                	li	a0,-1
 e4c:	bfc5                	j	e3c <check_substr+0x6a>

0000000000000e4e <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 e4e:	1141                	addi	sp,sp,-16
 e50:	e406                	sd	ra,8(sp)
 e52:	e022                	sd	s0,0(sp)
 e54:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 e56:	fffff097          	auipc	ra,0xfffff
 e5a:	746080e7          	jalr	1862(ra) # 59c <open>
	return fd;
}
 e5e:	60a2                	ld	ra,8(sp)
 e60:	6402                	ld	s0,0(sp)
 e62:	0141                	addi	sp,sp,16
 e64:	8082                	ret

0000000000000e66 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 e66:	7139                	addi	sp,sp,-64
 e68:	fc06                	sd	ra,56(sp)
 e6a:	f822                	sd	s0,48(sp)
 e6c:	f426                	sd	s1,40(sp)
 e6e:	f04a                	sd	s2,32(sp)
 e70:	ec4e                	sd	s3,24(sp)
 e72:	e852                	sd	s4,16(sp)
 e74:	0080                	addi	s0,sp,64
 e76:	89aa                	mv	s3,a0
 e78:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 e7a:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 e7c:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 e7e:	4605                	li	a2,1
 e80:	fcf40593          	addi	a1,s0,-49
 e84:	854e                	mv	a0,s3
 e86:	fffff097          	auipc	ra,0xfffff
 e8a:	6ee080e7          	jalr	1774(ra) # 574 <read>
		if (readStatus == 0){
 e8e:	c505                	beqz	a0,eb6 <read_line+0x50>
		*buffer++ = readByte;
 e90:	0485                	addi	s1,s1,1
 e92:	fcf44783          	lbu	a5,-49(s0)
 e96:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 e9a:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 e9c:	ff4791e3          	bne	a5,s4,e7e <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 ea0:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 ea4:	854a                	mv	a0,s2
 ea6:	70e2                	ld	ra,56(sp)
 ea8:	7442                	ld	s0,48(sp)
 eaa:	74a2                	ld	s1,40(sp)
 eac:	7902                	ld	s2,32(sp)
 eae:	69e2                	ld	s3,24(sp)
 eb0:	6a42                	ld	s4,16(sp)
 eb2:	6121                	addi	sp,sp,64
 eb4:	8082                	ret
			if (byteCount!=0){
 eb6:	fe0907e3          	beqz	s2,ea4 <read_line+0x3e>
				*buffer = '\n';
 eba:	47a9                	li	a5,10
 ebc:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 ec0:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 ec4:	2905                	addiw	s2,s2,1
 ec6:	bff9                	j	ea4 <read_line+0x3e>

0000000000000ec8 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 ec8:	1141                	addi	sp,sp,-16
 eca:	e406                	sd	ra,8(sp)
 ecc:	e022                	sd	s0,0(sp)
 ece:	0800                	addi	s0,sp,16
	close(fd);
 ed0:	fffff097          	auipc	ra,0xfffff
 ed4:	6b4080e7          	jalr	1716(ra) # 584 <close>
}
 ed8:	60a2                	ld	ra,8(sp)
 eda:	6402                	ld	s0,0(sp)
 edc:	0141                	addi	sp,sp,16
 ede:	8082                	ret

0000000000000ee0 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 ee0:	7139                	addi	sp,sp,-64
 ee2:	fc06                	sd	ra,56(sp)
 ee4:	f822                	sd	s0,48(sp)
 ee6:	f426                	sd	s1,40(sp)
 ee8:	f04a                	sd	s2,32(sp)
 eea:	0080                	addi	s0,sp,64
 eec:	84aa                	mv	s1,a0
 eee:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 ef0:	fffff097          	auipc	ra,0xfffff
 ef4:	664080e7          	jalr	1636(ra) # 554 <fork>
 ef8:	ed19                	bnez	a0,f16 <get_time_perf+0x36>
		exec(argv[0],argv);
 efa:	85ca                	mv	a1,s2
 efc:	00093503          	ld	a0,0(s2)
 f00:	fffff097          	auipc	ra,0xfffff
 f04:	694080e7          	jalr	1684(ra) # 594 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 f08:	8526                	mv	a0,s1
 f0a:	70e2                	ld	ra,56(sp)
 f0c:	7442                	ld	s0,48(sp)
 f0e:	74a2                	ld	s1,40(sp)
 f10:	7902                	ld	s2,32(sp)
 f12:	6121                	addi	sp,sp,64
 f14:	8082                	ret
		times(pid , &time);
 f16:	fc840593          	addi	a1,s0,-56
 f1a:	fffff097          	auipc	ra,0xfffff
 f1e:	6fa080e7          	jalr	1786(ra) # 614 <times>
		return time;
 f22:	fc843783          	ld	a5,-56(s0)
 f26:	e09c                	sd	a5,0(s1)
 f28:	fd043783          	ld	a5,-48(s0)
 f2c:	e49c                	sd	a5,8(s1)
 f2e:	fd843783          	ld	a5,-40(s0)
 f32:	e89c                	sd	a5,16(s1)
 f34:	bfd1                	j	f08 <get_time_perf+0x28>
