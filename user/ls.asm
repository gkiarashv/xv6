
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
  66:	00001997          	auipc	s3,0x1
  6a:	faa98993          	addi	s3,s3,-86 # 1010 <buf.0>
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
 12c:	d6850513          	addi	a0,a0,-664 # e90 <close_file+0x50>
 130:	00000097          	auipc	ra,0x0
 134:	7b6080e7          	jalr	1974(ra) # 8e6 <printf>
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
 16a:	cfa58593          	addi	a1,a1,-774 # e60 <close_file+0x20>
 16e:	4509                	li	a0,2
 170:	00000097          	auipc	ra,0x0
 174:	748080e7          	jalr	1864(ra) # 8b8 <fprintf>
    return;
 178:	b7e9                	j	142 <ls+0x8e>
    fprintf(2, "ls: cannot stat %s\n", path);
 17a:	864a                	mv	a2,s2
 17c:	00001597          	auipc	a1,0x1
 180:	cfc58593          	addi	a1,a1,-772 # e78 <close_file+0x38>
 184:	4509                	li	a0,2
 186:	00000097          	auipc	ra,0x0
 18a:	732080e7          	jalr	1842(ra) # 8b8 <fprintf>
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
 1b2:	cf250513          	addi	a0,a0,-782 # ea0 <close_file+0x60>
 1b6:	00000097          	auipc	ra,0x0
 1ba:	730080e7          	jalr	1840(ra) # 8e6 <printf>
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
 1f6:	cc6a0a13          	addi	s4,s4,-826 # eb8 <close_file+0x78>
        printf("ls: cannot stat %s\n", buf);
 1fa:	00001a97          	auipc	s5,0x1
 1fe:	c7ea8a93          	addi	s5,s5,-898 # e78 <close_file+0x38>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 202:	a801                	j	212 <ls+0x15e>
        printf("ls: cannot stat %s\n", buf);
 204:	dc040593          	addi	a1,s0,-576
 208:	8556                	mv	a0,s5
 20a:	00000097          	auipc	ra,0x0
 20e:	6dc080e7          	jalr	1756(ra) # 8e6 <printf>
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
 276:	674080e7          	jalr	1652(ra) # 8e6 <printf>
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
 2c0:	c0c50513          	addi	a0,a0,-1012 # ec8 <close_file+0x88>
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

000000000000060c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 60c:	1101                	addi	sp,sp,-32
 60e:	ec06                	sd	ra,24(sp)
 610:	e822                	sd	s0,16(sp)
 612:	1000                	addi	s0,sp,32
 614:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 618:	4605                	li	a2,1
 61a:	fef40593          	addi	a1,s0,-17
 61e:	00000097          	auipc	ra,0x0
 622:	f5e080e7          	jalr	-162(ra) # 57c <write>
}
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	6105                	addi	sp,sp,32
 62c:	8082                	ret

000000000000062e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62e:	7139                	addi	sp,sp,-64
 630:	fc06                	sd	ra,56(sp)
 632:	f822                	sd	s0,48(sp)
 634:	f426                	sd	s1,40(sp)
 636:	f04a                	sd	s2,32(sp)
 638:	ec4e                	sd	s3,24(sp)
 63a:	0080                	addi	s0,sp,64
 63c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 63e:	c299                	beqz	a3,644 <printint+0x16>
 640:	0805c963          	bltz	a1,6d2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 644:	2581                	sext.w	a1,a1
  neg = 0;
 646:	4881                	li	a7,0
 648:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 64c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 64e:	2601                	sext.w	a2,a2
 650:	00001517          	auipc	a0,0x1
 654:	8e050513          	addi	a0,a0,-1824 # f30 <digits>
 658:	883a                	mv	a6,a4
 65a:	2705                	addiw	a4,a4,1
 65c:	02c5f7bb          	remuw	a5,a1,a2
 660:	1782                	slli	a5,a5,0x20
 662:	9381                	srli	a5,a5,0x20
 664:	97aa                	add	a5,a5,a0
 666:	0007c783          	lbu	a5,0(a5)
 66a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 66e:	0005879b          	sext.w	a5,a1
 672:	02c5d5bb          	divuw	a1,a1,a2
 676:	0685                	addi	a3,a3,1
 678:	fec7f0e3          	bgeu	a5,a2,658 <printint+0x2a>
  if(neg)
 67c:	00088c63          	beqz	a7,694 <printint+0x66>
    buf[i++] = '-';
 680:	fd070793          	addi	a5,a4,-48
 684:	00878733          	add	a4,a5,s0
 688:	02d00793          	li	a5,45
 68c:	fef70823          	sb	a5,-16(a4)
 690:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 694:	02e05863          	blez	a4,6c4 <printint+0x96>
 698:	fc040793          	addi	a5,s0,-64
 69c:	00e78933          	add	s2,a5,a4
 6a0:	fff78993          	addi	s3,a5,-1
 6a4:	99ba                	add	s3,s3,a4
 6a6:	377d                	addiw	a4,a4,-1
 6a8:	1702                	slli	a4,a4,0x20
 6aa:	9301                	srli	a4,a4,0x20
 6ac:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6b0:	fff94583          	lbu	a1,-1(s2)
 6b4:	8526                	mv	a0,s1
 6b6:	00000097          	auipc	ra,0x0
 6ba:	f56080e7          	jalr	-170(ra) # 60c <putc>
  while(--i >= 0)
 6be:	197d                	addi	s2,s2,-1
 6c0:	ff3918e3          	bne	s2,s3,6b0 <printint+0x82>
}
 6c4:	70e2                	ld	ra,56(sp)
 6c6:	7442                	ld	s0,48(sp)
 6c8:	74a2                	ld	s1,40(sp)
 6ca:	7902                	ld	s2,32(sp)
 6cc:	69e2                	ld	s3,24(sp)
 6ce:	6121                	addi	sp,sp,64
 6d0:	8082                	ret
    x = -xx;
 6d2:	40b005bb          	negw	a1,a1
    neg = 1;
 6d6:	4885                	li	a7,1
    x = -xx;
 6d8:	bf85                	j	648 <printint+0x1a>

00000000000006da <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6da:	7119                	addi	sp,sp,-128
 6dc:	fc86                	sd	ra,120(sp)
 6de:	f8a2                	sd	s0,112(sp)
 6e0:	f4a6                	sd	s1,104(sp)
 6e2:	f0ca                	sd	s2,96(sp)
 6e4:	ecce                	sd	s3,88(sp)
 6e6:	e8d2                	sd	s4,80(sp)
 6e8:	e4d6                	sd	s5,72(sp)
 6ea:	e0da                	sd	s6,64(sp)
 6ec:	fc5e                	sd	s7,56(sp)
 6ee:	f862                	sd	s8,48(sp)
 6f0:	f466                	sd	s9,40(sp)
 6f2:	f06a                	sd	s10,32(sp)
 6f4:	ec6e                	sd	s11,24(sp)
 6f6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6f8:	0005c903          	lbu	s2,0(a1)
 6fc:	18090f63          	beqz	s2,89a <vprintf+0x1c0>
 700:	8aaa                	mv	s5,a0
 702:	8b32                	mv	s6,a2
 704:	00158493          	addi	s1,a1,1
  state = 0;
 708:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 70a:	02500a13          	li	s4,37
 70e:	4c55                	li	s8,21
 710:	00000c97          	auipc	s9,0x0
 714:	7c8c8c93          	addi	s9,s9,1992 # ed8 <close_file+0x98>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 718:	02800d93          	li	s11,40
  putc(fd, 'x');
 71c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71e:	00001b97          	auipc	s7,0x1
 722:	812b8b93          	addi	s7,s7,-2030 # f30 <digits>
 726:	a839                	j	744 <vprintf+0x6a>
        putc(fd, c);
 728:	85ca                	mv	a1,s2
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	ee0080e7          	jalr	-288(ra) # 60c <putc>
 734:	a019                	j	73a <vprintf+0x60>
    } else if(state == '%'){
 736:	01498d63          	beq	s3,s4,750 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 73a:	0485                	addi	s1,s1,1
 73c:	fff4c903          	lbu	s2,-1(s1)
 740:	14090d63          	beqz	s2,89a <vprintf+0x1c0>
    if(state == 0){
 744:	fe0999e3          	bnez	s3,736 <vprintf+0x5c>
      if(c == '%'){
 748:	ff4910e3          	bne	s2,s4,728 <vprintf+0x4e>
        state = '%';
 74c:	89d2                	mv	s3,s4
 74e:	b7f5                	j	73a <vprintf+0x60>
      if(c == 'd'){
 750:	11490c63          	beq	s2,s4,868 <vprintf+0x18e>
 754:	f9d9079b          	addiw	a5,s2,-99
 758:	0ff7f793          	zext.b	a5,a5
 75c:	10fc6e63          	bltu	s8,a5,878 <vprintf+0x19e>
 760:	f9d9079b          	addiw	a5,s2,-99
 764:	0ff7f713          	zext.b	a4,a5
 768:	10ec6863          	bltu	s8,a4,878 <vprintf+0x19e>
 76c:	00271793          	slli	a5,a4,0x2
 770:	97e6                	add	a5,a5,s9
 772:	439c                	lw	a5,0(a5)
 774:	97e6                	add	a5,a5,s9
 776:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 778:	008b0913          	addi	s2,s6,8
 77c:	4685                	li	a3,1
 77e:	4629                	li	a2,10
 780:	000b2583          	lw	a1,0(s6)
 784:	8556                	mv	a0,s5
 786:	00000097          	auipc	ra,0x0
 78a:	ea8080e7          	jalr	-344(ra) # 62e <printint>
 78e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 790:	4981                	li	s3,0
 792:	b765                	j	73a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 794:	008b0913          	addi	s2,s6,8
 798:	4681                	li	a3,0
 79a:	4629                	li	a2,10
 79c:	000b2583          	lw	a1,0(s6)
 7a0:	8556                	mv	a0,s5
 7a2:	00000097          	auipc	ra,0x0
 7a6:	e8c080e7          	jalr	-372(ra) # 62e <printint>
 7aa:	8b4a                	mv	s6,s2
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	b771                	j	73a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7b0:	008b0913          	addi	s2,s6,8
 7b4:	4681                	li	a3,0
 7b6:	866a                	mv	a2,s10
 7b8:	000b2583          	lw	a1,0(s6)
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	e70080e7          	jalr	-400(ra) # 62e <printint>
 7c6:	8b4a                	mv	s6,s2
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	bf85                	j	73a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7cc:	008b0793          	addi	a5,s6,8
 7d0:	f8f43423          	sd	a5,-120(s0)
 7d4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7d8:	03000593          	li	a1,48
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	e2e080e7          	jalr	-466(ra) # 60c <putc>
  putc(fd, 'x');
 7e6:	07800593          	li	a1,120
 7ea:	8556                	mv	a0,s5
 7ec:	00000097          	auipc	ra,0x0
 7f0:	e20080e7          	jalr	-480(ra) # 60c <putc>
 7f4:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7f6:	03c9d793          	srli	a5,s3,0x3c
 7fa:	97de                	add	a5,a5,s7
 7fc:	0007c583          	lbu	a1,0(a5)
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	e0a080e7          	jalr	-502(ra) # 60c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 80a:	0992                	slli	s3,s3,0x4
 80c:	397d                	addiw	s2,s2,-1
 80e:	fe0914e3          	bnez	s2,7f6 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 812:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 816:	4981                	li	s3,0
 818:	b70d                	j	73a <vprintf+0x60>
        s = va_arg(ap, char*);
 81a:	008b0913          	addi	s2,s6,8
 81e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 822:	02098163          	beqz	s3,844 <vprintf+0x16a>
        while(*s != 0){
 826:	0009c583          	lbu	a1,0(s3)
 82a:	c5ad                	beqz	a1,894 <vprintf+0x1ba>
          putc(fd, *s);
 82c:	8556                	mv	a0,s5
 82e:	00000097          	auipc	ra,0x0
 832:	dde080e7          	jalr	-546(ra) # 60c <putc>
          s++;
 836:	0985                	addi	s3,s3,1
        while(*s != 0){
 838:	0009c583          	lbu	a1,0(s3)
 83c:	f9e5                	bnez	a1,82c <vprintf+0x152>
        s = va_arg(ap, char*);
 83e:	8b4a                	mv	s6,s2
      state = 0;
 840:	4981                	li	s3,0
 842:	bde5                	j	73a <vprintf+0x60>
          s = "(null)";
 844:	00000997          	auipc	s3,0x0
 848:	68c98993          	addi	s3,s3,1676 # ed0 <close_file+0x90>
        while(*s != 0){
 84c:	85ee                	mv	a1,s11
 84e:	bff9                	j	82c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 850:	008b0913          	addi	s2,s6,8
 854:	000b4583          	lbu	a1,0(s6)
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	db2080e7          	jalr	-590(ra) # 60c <putc>
 862:	8b4a                	mv	s6,s2
      state = 0;
 864:	4981                	li	s3,0
 866:	bdd1                	j	73a <vprintf+0x60>
        putc(fd, c);
 868:	85d2                	mv	a1,s4
 86a:	8556                	mv	a0,s5
 86c:	00000097          	auipc	ra,0x0
 870:	da0080e7          	jalr	-608(ra) # 60c <putc>
      state = 0;
 874:	4981                	li	s3,0
 876:	b5d1                	j	73a <vprintf+0x60>
        putc(fd, '%');
 878:	85d2                	mv	a1,s4
 87a:	8556                	mv	a0,s5
 87c:	00000097          	auipc	ra,0x0
 880:	d90080e7          	jalr	-624(ra) # 60c <putc>
        putc(fd, c);
 884:	85ca                	mv	a1,s2
 886:	8556                	mv	a0,s5
 888:	00000097          	auipc	ra,0x0
 88c:	d84080e7          	jalr	-636(ra) # 60c <putc>
      state = 0;
 890:	4981                	li	s3,0
 892:	b565                	j	73a <vprintf+0x60>
        s = va_arg(ap, char*);
 894:	8b4a                	mv	s6,s2
      state = 0;
 896:	4981                	li	s3,0
 898:	b54d                	j	73a <vprintf+0x60>
    }
  }
}
 89a:	70e6                	ld	ra,120(sp)
 89c:	7446                	ld	s0,112(sp)
 89e:	74a6                	ld	s1,104(sp)
 8a0:	7906                	ld	s2,96(sp)
 8a2:	69e6                	ld	s3,88(sp)
 8a4:	6a46                	ld	s4,80(sp)
 8a6:	6aa6                	ld	s5,72(sp)
 8a8:	6b06                	ld	s6,64(sp)
 8aa:	7be2                	ld	s7,56(sp)
 8ac:	7c42                	ld	s8,48(sp)
 8ae:	7ca2                	ld	s9,40(sp)
 8b0:	7d02                	ld	s10,32(sp)
 8b2:	6de2                	ld	s11,24(sp)
 8b4:	6109                	addi	sp,sp,128
 8b6:	8082                	ret

00000000000008b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b8:	715d                	addi	sp,sp,-80
 8ba:	ec06                	sd	ra,24(sp)
 8bc:	e822                	sd	s0,16(sp)
 8be:	1000                	addi	s0,sp,32
 8c0:	e010                	sd	a2,0(s0)
 8c2:	e414                	sd	a3,8(s0)
 8c4:	e818                	sd	a4,16(s0)
 8c6:	ec1c                	sd	a5,24(s0)
 8c8:	03043023          	sd	a6,32(s0)
 8cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8d4:	8622                	mv	a2,s0
 8d6:	00000097          	auipc	ra,0x0
 8da:	e04080e7          	jalr	-508(ra) # 6da <vprintf>
}
 8de:	60e2                	ld	ra,24(sp)
 8e0:	6442                	ld	s0,16(sp)
 8e2:	6161                	addi	sp,sp,80
 8e4:	8082                	ret

00000000000008e6 <printf>:

void
printf(const char *fmt, ...)
{
 8e6:	711d                	addi	sp,sp,-96
 8e8:	ec06                	sd	ra,24(sp)
 8ea:	e822                	sd	s0,16(sp)
 8ec:	1000                	addi	s0,sp,32
 8ee:	e40c                	sd	a1,8(s0)
 8f0:	e810                	sd	a2,16(s0)
 8f2:	ec14                	sd	a3,24(s0)
 8f4:	f018                	sd	a4,32(s0)
 8f6:	f41c                	sd	a5,40(s0)
 8f8:	03043823          	sd	a6,48(s0)
 8fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 900:	00840613          	addi	a2,s0,8
 904:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 908:	85aa                	mv	a1,a0
 90a:	4505                	li	a0,1
 90c:	00000097          	auipc	ra,0x0
 910:	dce080e7          	jalr	-562(ra) # 6da <vprintf>
}
 914:	60e2                	ld	ra,24(sp)
 916:	6442                	ld	s0,16(sp)
 918:	6125                	addi	sp,sp,96
 91a:	8082                	ret

000000000000091c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 91c:	1141                	addi	sp,sp,-16
 91e:	e422                	sd	s0,8(sp)
 920:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 922:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 926:	00000797          	auipc	a5,0x0
 92a:	6da7b783          	ld	a5,1754(a5) # 1000 <freep>
 92e:	a02d                	j	958 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 930:	4618                	lw	a4,8(a2)
 932:	9f2d                	addw	a4,a4,a1
 934:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 938:	6398                	ld	a4,0(a5)
 93a:	6310                	ld	a2,0(a4)
 93c:	a83d                	j	97a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 93e:	ff852703          	lw	a4,-8(a0)
 942:	9f31                	addw	a4,a4,a2
 944:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 946:	ff053683          	ld	a3,-16(a0)
 94a:	a091                	j	98e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94c:	6398                	ld	a4,0(a5)
 94e:	00e7e463          	bltu	a5,a4,956 <free+0x3a>
 952:	00e6ea63          	bltu	a3,a4,966 <free+0x4a>
{
 956:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 958:	fed7fae3          	bgeu	a5,a3,94c <free+0x30>
 95c:	6398                	ld	a4,0(a5)
 95e:	00e6e463          	bltu	a3,a4,966 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 962:	fee7eae3          	bltu	a5,a4,956 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 966:	ff852583          	lw	a1,-8(a0)
 96a:	6390                	ld	a2,0(a5)
 96c:	02059813          	slli	a6,a1,0x20
 970:	01c85713          	srli	a4,a6,0x1c
 974:	9736                	add	a4,a4,a3
 976:	fae60de3          	beq	a2,a4,930 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 97a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 97e:	4790                	lw	a2,8(a5)
 980:	02061593          	slli	a1,a2,0x20
 984:	01c5d713          	srli	a4,a1,0x1c
 988:	973e                	add	a4,a4,a5
 98a:	fae68ae3          	beq	a3,a4,93e <free+0x22>
    p->s.ptr = bp->s.ptr;
 98e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 990:	00000717          	auipc	a4,0x0
 994:	66f73823          	sd	a5,1648(a4) # 1000 <freep>
}
 998:	6422                	ld	s0,8(sp)
 99a:	0141                	addi	sp,sp,16
 99c:	8082                	ret

000000000000099e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 99e:	7139                	addi	sp,sp,-64
 9a0:	fc06                	sd	ra,56(sp)
 9a2:	f822                	sd	s0,48(sp)
 9a4:	f426                	sd	s1,40(sp)
 9a6:	f04a                	sd	s2,32(sp)
 9a8:	ec4e                	sd	s3,24(sp)
 9aa:	e852                	sd	s4,16(sp)
 9ac:	e456                	sd	s5,8(sp)
 9ae:	e05a                	sd	s6,0(sp)
 9b0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b2:	02051493          	slli	s1,a0,0x20
 9b6:	9081                	srli	s1,s1,0x20
 9b8:	04bd                	addi	s1,s1,15
 9ba:	8091                	srli	s1,s1,0x4
 9bc:	0014899b          	addiw	s3,s1,1
 9c0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9c2:	00000517          	auipc	a0,0x0
 9c6:	63e53503          	ld	a0,1598(a0) # 1000 <freep>
 9ca:	c515                	beqz	a0,9f6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ce:	4798                	lw	a4,8(a5)
 9d0:	02977f63          	bgeu	a4,s1,a0e <malloc+0x70>
 9d4:	8a4e                	mv	s4,s3
 9d6:	0009871b          	sext.w	a4,s3
 9da:	6685                	lui	a3,0x1
 9dc:	00d77363          	bgeu	a4,a3,9e2 <malloc+0x44>
 9e0:	6a05                	lui	s4,0x1
 9e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9ea:	00000917          	auipc	s2,0x0
 9ee:	61690913          	addi	s2,s2,1558 # 1000 <freep>
  if(p == (char*)-1)
 9f2:	5afd                	li	s5,-1
 9f4:	a895                	j	a68 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9f6:	00000797          	auipc	a5,0x0
 9fa:	62a78793          	addi	a5,a5,1578 # 1020 <base>
 9fe:	00000717          	auipc	a4,0x0
 a02:	60f73123          	sd	a5,1538(a4) # 1000 <freep>
 a06:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a08:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a0c:	b7e1                	j	9d4 <malloc+0x36>
      if(p->s.size == nunits)
 a0e:	02e48c63          	beq	s1,a4,a46 <malloc+0xa8>
        p->s.size -= nunits;
 a12:	4137073b          	subw	a4,a4,s3
 a16:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a18:	02071693          	slli	a3,a4,0x20
 a1c:	01c6d713          	srli	a4,a3,0x1c
 a20:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a22:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a26:	00000717          	auipc	a4,0x0
 a2a:	5ca73d23          	sd	a0,1498(a4) # 1000 <freep>
      return (void*)(p + 1);
 a2e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a32:	70e2                	ld	ra,56(sp)
 a34:	7442                	ld	s0,48(sp)
 a36:	74a2                	ld	s1,40(sp)
 a38:	7902                	ld	s2,32(sp)
 a3a:	69e2                	ld	s3,24(sp)
 a3c:	6a42                	ld	s4,16(sp)
 a3e:	6aa2                	ld	s5,8(sp)
 a40:	6b02                	ld	s6,0(sp)
 a42:	6121                	addi	sp,sp,64
 a44:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a46:	6398                	ld	a4,0(a5)
 a48:	e118                	sd	a4,0(a0)
 a4a:	bff1                	j	a26 <malloc+0x88>
  hp->s.size = nu;
 a4c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a50:	0541                	addi	a0,a0,16
 a52:	00000097          	auipc	ra,0x0
 a56:	eca080e7          	jalr	-310(ra) # 91c <free>
  return freep;
 a5a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a5e:	d971                	beqz	a0,a32 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a60:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a62:	4798                	lw	a4,8(a5)
 a64:	fa9775e3          	bgeu	a4,s1,a0e <malloc+0x70>
    if(p == freep)
 a68:	00093703          	ld	a4,0(s2)
 a6c:	853e                	mv	a0,a5
 a6e:	fef719e3          	bne	a4,a5,a60 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a72:	8552                	mv	a0,s4
 a74:	00000097          	auipc	ra,0x0
 a78:	b70080e7          	jalr	-1168(ra) # 5e4 <sbrk>
  if(p == (char*)-1)
 a7c:	fd5518e3          	bne	a0,s5,a4c <malloc+0xae>
        return 0;
 a80:	4501                	li	a0,0
 a82:	bf45                	j	a32 <malloc+0x94>

0000000000000a84 <head_run>:
#include "user/user.h"
#include "gelibs/file.h"

extern int read_line(int fd, char * buffer);

void head_run(int fd, int numOfLines){
 a84:	dc010113          	addi	sp,sp,-576
 a88:	22113c23          	sd	ra,568(sp)
 a8c:	22813823          	sd	s0,560(sp)
 a90:	22913423          	sd	s1,552(sp)
 a94:	23213023          	sd	s2,544(sp)
 a98:	21313c23          	sd	s3,536(sp)
 a9c:	21413823          	sd	s4,528(sp)
 aa0:	21513423          	sd	s5,520(sp)
 aa4:	0480                	addi	s0,sp,576
 aa6:	89aa                	mv	s3,a0
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 aa8:	892e                	mv	s2,a1

		readStatus = read_line(fd, line);
		
		if (readStatus == READ_ERROR){
 aaa:	5a7d                	li	s4,-1
			printf("[ERR] Error reading from the file \n");
			break;
		}

		printf("%s",line);
 aac:	00000a97          	auipc	s5,0x0
 ab0:	4c4a8a93          	addi	s5,s5,1220 # f70 <digits+0x40>
	while(numOfLines--){
 ab4:	02090e63          	beqz	s2,af0 <head_run+0x6c>
		readStatus = read_line(fd, line);
 ab8:	dc840593          	addi	a1,s0,-568
 abc:	854e                	mv	a0,s3
 abe:	00000097          	auipc	ra,0x0
 ac2:	324080e7          	jalr	804(ra) # de2 <read_line>
 ac6:	84aa                	mv	s1,a0
		if (readStatus == READ_ERROR){
 ac8:	01450c63          	beq	a0,s4,ae0 <head_run+0x5c>
		printf("%s",line);
 acc:	dc840593          	addi	a1,s0,-568
 ad0:	8556                	mv	a0,s5
 ad2:	00000097          	auipc	ra,0x0
 ad6:	e14080e7          	jalr	-492(ra) # 8e6 <printf>

		if (readStatus == READ_EOF )
 ada:	397d                	addiw	s2,s2,-1
 adc:	fce1                	bnez	s1,ab4 <head_run+0x30>
 ade:	a809                	j	af0 <head_run+0x6c>
			printf("[ERR] Error reading from the file \n");
 ae0:	00000517          	auipc	a0,0x0
 ae4:	46850513          	addi	a0,a0,1128 # f48 <digits+0x18>
 ae8:	00000097          	auipc	ra,0x0
 aec:	dfe080e7          	jalr	-514(ra) # 8e6 <printf>
			break;
	}
}
 af0:	23813083          	ld	ra,568(sp)
 af4:	23013403          	ld	s0,560(sp)
 af8:	22813483          	ld	s1,552(sp)
 afc:	22013903          	ld	s2,544(sp)
 b00:	21813983          	ld	s3,536(sp)
 b04:	21013a03          	ld	s4,528(sp)
 b08:	20813a83          	ld	s5,520(sp)
 b0c:	24010113          	addi	sp,sp,576
 b10:	8082                	ret

0000000000000b12 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 b12:	ba010113          	addi	sp,sp,-1120
 b16:	44113c23          	sd	ra,1112(sp)
 b1a:	44813823          	sd	s0,1104(sp)
 b1e:	44913423          	sd	s1,1096(sp)
 b22:	45213023          	sd	s2,1088(sp)
 b26:	43313c23          	sd	s3,1080(sp)
 b2a:	43413823          	sd	s4,1072(sp)
 b2e:	43513423          	sd	s5,1064(sp)
 b32:	43613023          	sd	s6,1056(sp)
 b36:	41713c23          	sd	s7,1048(sp)
 b3a:	41813823          	sd	s8,1040(sp)
 b3e:	41913423          	sd	s9,1032(sp)
 b42:	41a13023          	sd	s10,1024(sp)
 b46:	3fb13c23          	sd	s11,1016(sp)
 b4a:	46010413          	addi	s0,sp,1120
 b4e:	8aaa                	mv	s5,a0
 b50:	8bae                	mv	s7,a1
 b52:	8db2                	mv	s11,a2
 b54:	8c36                	mv	s8,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 b56:	d9840593          	addi	a1,s0,-616
 b5a:	00000097          	auipc	ra,0x0
 b5e:	288080e7          	jalr	648(ra) # de2 <read_line>

  if (readStatus == READ_ERROR)
 b62:	57fd                	li	a5,-1
 b64:	04f50163          	beq	a0,a5,ba6 <uniq_run+0x94>
 b68:	4b01                	li	s6,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 b6a:	ed21                	bnez	a0,bc2 <uniq_run+0xb0>





}
 b6c:	45813083          	ld	ra,1112(sp)
 b70:	45013403          	ld	s0,1104(sp)
 b74:	44813483          	ld	s1,1096(sp)
 b78:	44013903          	ld	s2,1088(sp)
 b7c:	43813983          	ld	s3,1080(sp)
 b80:	43013a03          	ld	s4,1072(sp)
 b84:	42813a83          	ld	s5,1064(sp)
 b88:	42013b03          	ld	s6,1056(sp)
 b8c:	41813b83          	ld	s7,1048(sp)
 b90:	41013c03          	ld	s8,1040(sp)
 b94:	40813c83          	ld	s9,1032(sp)
 b98:	40013d03          	ld	s10,1024(sp)
 b9c:	3f813d83          	ld	s11,1016(sp)
 ba0:	46010113          	addi	sp,sp,1120
 ba4:	8082                	ret
    printf("[ERR] Error reading from the file ");
 ba6:	00000517          	auipc	a0,0x0
 baa:	3d250513          	addi	a0,a0,978 # f78 <digits+0x48>
 bae:	00000097          	auipc	ra,0x0
 bb2:	d38080e7          	jalr	-712(ra) # 8e6 <printf>
 bb6:	bf5d                	j	b6c <uniq_run+0x5a>
 bb8:	87ca                	mv	a5,s2
 bba:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 bbc:	84be                	mv	s1,a5
        lineCount = 1;
 bbe:	89ea                	mv	s3,s10
 bc0:	a8fd                	j	cbe <uniq_run+0x1ac>
    int isEof = 0;
 bc2:	4a01                	li	s4,0
    int lineCount=1;
 bc4:	4985                	li	s3,1
  char * line2 = buffer2;
 bc6:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 bca:	d9840913          	addi	s2,s0,-616
      if (readStatus == READ_ERROR){
 bce:	5cfd                	li	s9,-1
        isEof = 1;
 bd0:	4d05                	li	s10,1
 bd2:	a0f5                	j	cbe <uniq_run+0x1ac>
        printf("[ERR] Error reading from the file");
 bd4:	00000517          	auipc	a0,0x0
 bd8:	3cc50513          	addi	a0,a0,972 # fa0 <digits+0x70>
 bdc:	00000097          	auipc	ra,0x0
 be0:	d0a080e7          	jalr	-758(ra) # 8e6 <printf>
        break;
 be4:	b761                	j	b6c <uniq_run+0x5a>
        compareStatus = compare_str_ic(line1, line2);
 be6:	85a6                	mv	a1,s1
 be8:	854a                	mv	a0,s2
 bea:	00000097          	auipc	ra,0x0
 bee:	184080e7          	jalr	388(ra) # d6e <compare_str_ic>
 bf2:	a8d5                	j	ce6 <uniq_run+0x1d4>
                  printf("%s",line1);
 bf4:	85ca                	mv	a1,s2
 bf6:	00000517          	auipc	a0,0x0
 bfa:	37a50513          	addi	a0,a0,890 # f70 <digits+0x40>
 bfe:	00000097          	auipc	ra,0x0
 c02:	ce8080e7          	jalr	-792(ra) # 8e6 <printf>
        lineCount = 1;
 c06:	89da                	mv	s3,s6
                  printf("%s",line1);
 c08:	87ca                	mv	a5,s2
 c0a:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 c0c:	84be                	mv	s1,a5
        isRepeated = 0 ;
 c0e:	4b01                	li	s6,0
 c10:	a07d                	j	cbe <uniq_run+0x1ac>
            if (showCount){
 c12:	040d8b63          	beqz	s11,c68 <uniq_run+0x156>
              printf("<%d> %s",lineCount,line1);
 c16:	864a                	mv	a2,s2
 c18:	85ce                	mv	a1,s3
 c1a:	00000517          	auipc	a0,0x0
 c1e:	3ae50513          	addi	a0,a0,942 # fc8 <digits+0x98>
 c22:	00000097          	auipc	ra,0x0
 c26:	cc4080e7          	jalr	-828(ra) # 8e6 <printf>
              if (isEof && get_strlen(line2)){
 c2a:	000a1863          	bnez	s4,c3a <uniq_run+0x128>
        isRepeated = 0 ;
 c2e:	8b52                	mv	s6,s4
 c30:	87ca                	mv	a5,s2
 c32:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 c34:	84be                	mv	s1,a5
        lineCount = 1;
 c36:	89ea                	mv	s3,s10
 c38:	a059                	j	cbe <uniq_run+0x1ac>
              if (isEof && get_strlen(line2)){
 c3a:	8526                	mv	a0,s1
 c3c:	00000097          	auipc	ra,0x0
 c40:	0d8080e7          	jalr	216(ra) # d14 <get_strlen>
 c44:	8b2a                	mv	s6,a0
 c46:	e511                	bnez	a0,c52 <uniq_run+0x140>
        lineCount = 1;
 c48:	89d2                	mv	s3,s4
 c4a:	87ca                	mv	a5,s2
 c4c:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 c4e:	84be                	mv	s1,a5
 c50:	a0bd                	j	cbe <uniq_run+0x1ac>
                printf("<%d> %s",lineCount,line2); 
 c52:	8626                	mv	a2,s1
 c54:	85ce                	mv	a1,s3
 c56:	00000517          	auipc	a0,0x0
 c5a:	37250513          	addi	a0,a0,882 # fc8 <digits+0x98>
 c5e:	00000097          	auipc	ra,0x0
 c62:	c88080e7          	jalr	-888(ra) # 8e6 <printf>
                break;
 c66:	b719                	j	b6c <uniq_run+0x5a>
              printf("%s",line1);
 c68:	85ca                	mv	a1,s2
 c6a:	00000517          	auipc	a0,0x0
 c6e:	30650513          	addi	a0,a0,774 # f70 <digits+0x40>
 c72:	00000097          	auipc	ra,0x0
 c76:	c74080e7          	jalr	-908(ra) # 8e6 <printf>
              if (isEof && get_strlen(line2)){
 c7a:	000a1863          	bnez	s4,c8a <uniq_run+0x178>
        isRepeated = 0 ;
 c7e:	8b52                	mv	s6,s4
 c80:	87ca                	mv	a5,s2
 c82:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 c84:	84be                	mv	s1,a5
        lineCount = 1;
 c86:	89ea                	mv	s3,s10
 c88:	a81d                	j	cbe <uniq_run+0x1ac>
              if (isEof && get_strlen(line2)){
 c8a:	8526                	mv	a0,s1
 c8c:	00000097          	auipc	ra,0x0
 c90:	088080e7          	jalr	136(ra) # d14 <get_strlen>
 c94:	8b2a                	mv	s6,a0
 c96:	e511                	bnez	a0,ca2 <uniq_run+0x190>
        lineCount = 1;
 c98:	89d2                	mv	s3,s4
 c9a:	87ca                	mv	a5,s2
 c9c:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 c9e:	84be                	mv	s1,a5
 ca0:	a839                	j	cbe <uniq_run+0x1ac>
                printf("%s",line2);
 ca2:	85a6                	mv	a1,s1
 ca4:	00000517          	auipc	a0,0x0
 ca8:	2cc50513          	addi	a0,a0,716 # f70 <digits+0x40>
 cac:	00000097          	auipc	ra,0x0
 cb0:	c3a080e7          	jalr	-966(ra) # 8e6 <printf>
                break;
 cb4:	bd65                	j	b6c <uniq_run+0x5a>
          if (repeatedLines && !isRepeated){
 cb6:	000c0363          	beqz	s8,cbc <uniq_run+0x1aa>
 cba:	8b6a                	mv	s6,s10
          lineCount++;
 cbc:	2985                	addiw	s3,s3,1
      readStatus = read_line(fd, line2);
 cbe:	85a6                	mv	a1,s1
 cc0:	8556                	mv	a0,s5
 cc2:	00000097          	auipc	ra,0x0
 cc6:	120080e7          	jalr	288(ra) # de2 <read_line>
      if (readStatus == READ_ERROR){
 cca:	f19505e3          	beq	a0,s9,bd4 <uniq_run+0xc2>
      if (readStatus == READ_EOF){
 cce:	e501                	bnez	a0,cd6 <uniq_run+0x1c4>
        if (isEof)
 cd0:	e80a1ee3          	bnez	s4,b6c <uniq_run+0x5a>
        isEof = 1;
 cd4:	8a6a                	mv	s4,s10
      if (!ignoreCase)
 cd6:	f00b98e3          	bnez	s7,be6 <uniq_run+0xd4>
        compareStatus = compare_str(line1, line2);
 cda:	85a6                	mv	a1,s1
 cdc:	854a                	mv	a0,s2
 cde:	00000097          	auipc	ra,0x0
 ce2:	062080e7          	jalr	98(ra) # d40 <compare_str>
      if (compareStatus != 0){ // Not equal
 ce6:	d961                	beqz	a0,cb6 <uniq_run+0x1a4>
          if (repeatedLines){
 ce8:	f20c05e3          	beqz	s8,c12 <uniq_run+0x100>
            if (isRepeated){
 cec:	ec0b06e3          	beqz	s6,bb8 <uniq_run+0xa6>
                if (showCount)
 cf0:	f00d82e3          	beqz	s11,bf4 <uniq_run+0xe2>
                  printf("<%d> %s",lineCount,line1);
 cf4:	864a                	mv	a2,s2
 cf6:	85ce                	mv	a1,s3
 cf8:	00000517          	auipc	a0,0x0
 cfc:	2d050513          	addi	a0,a0,720 # fc8 <digits+0x98>
 d00:	00000097          	auipc	ra,0x0
 d04:	be6080e7          	jalr	-1050(ra) # 8e6 <printf>
        lineCount = 1;
 d08:	89da                	mv	s3,s6
 d0a:	87ca                	mv	a5,s2
 d0c:	8926                	mv	s2,s1
        swap_pointers(line1, line2);
 d0e:	84be                	mv	s1,a5
        isRepeated = 0 ;
 d10:	4b01                	li	s6,0
 d12:	b775                	j	cbe <uniq_run+0x1ac>

0000000000000d14 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 d14:	1141                	addi	sp,sp,-16
 d16:	e422                	sd	s0,8(sp)
 d18:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 d1a:	00054783          	lbu	a5,0(a0)
 d1e:	cf99                	beqz	a5,d3c <get_strlen+0x28>
 d20:	00150713          	addi	a4,a0,1
 d24:	87ba                	mv	a5,a4
 d26:	4685                	li	a3,1
 d28:	9e99                	subw	a3,a3,a4
 d2a:	00f6853b          	addw	a0,a3,a5
 d2e:	0785                	addi	a5,a5,1
 d30:	fff7c703          	lbu	a4,-1(a5)
 d34:	fb7d                	bnez	a4,d2a <get_strlen+0x16>
	return len;
}
 d36:	6422                	ld	s0,8(sp)
 d38:	0141                	addi	sp,sp,16
 d3a:	8082                	ret
	int len = 0;
 d3c:	4501                	li	a0,0
 d3e:	bfe5                	j	d36 <get_strlen+0x22>

0000000000000d40 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 d40:	1141                	addi	sp,sp,-16
 d42:	e422                	sd	s0,8(sp)
 d44:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 d46:	00054783          	lbu	a5,0(a0)
 d4a:	cb91                	beqz	a5,d5e <compare_str+0x1e>
 d4c:	0005c703          	lbu	a4,0(a1)
 d50:	c719                	beqz	a4,d5e <compare_str+0x1e>
		if (*s1++ != *s2++)
 d52:	0505                	addi	a0,a0,1
 d54:	0585                	addi	a1,a1,1
 d56:	fee788e3          	beq	a5,a4,d46 <compare_str+0x6>
			return 1;
 d5a:	4505                	li	a0,1
 d5c:	a031                	j	d68 <compare_str+0x28>
	}
	if (*s1 == *s2)
 d5e:	0005c503          	lbu	a0,0(a1)
 d62:	8d1d                	sub	a0,a0,a5
			return 1;
 d64:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 d68:	6422                	ld	s0,8(sp)
 d6a:	0141                	addi	sp,sp,16
 d6c:	8082                	ret

0000000000000d6e <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 d6e:	1141                	addi	sp,sp,-16
 d70:	e422                	sd	s0,8(sp)
 d72:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 d74:	4665                	li	a2,25
	while(*s1 && *s2){
 d76:	a019                	j	d7c <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 d78:	04e79763          	bne	a5,a4,dc6 <compare_str_ic+0x58>
	while(*s1 && *s2){
 d7c:	00054783          	lbu	a5,0(a0)
 d80:	cb9d                	beqz	a5,db6 <compare_str_ic+0x48>
 d82:	0005c703          	lbu	a4,0(a1)
 d86:	cb05                	beqz	a4,db6 <compare_str_ic+0x48>
		char b1 = *s1++;
 d88:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 d8a:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 d8c:	fbf7869b          	addiw	a3,a5,-65
 d90:	0ff6f693          	zext.b	a3,a3
 d94:	00d66663          	bltu	a2,a3,da0 <compare_str_ic+0x32>
			b1 += 32;
 d98:	0207879b          	addiw	a5,a5,32
 d9c:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 da0:	fbf7069b          	addiw	a3,a4,-65
 da4:	0ff6f693          	zext.b	a3,a3
 da8:	fcd668e3          	bltu	a2,a3,d78 <compare_str_ic+0xa>
			b2 += 32;
 dac:	0207071b          	addiw	a4,a4,32
 db0:	0ff77713          	zext.b	a4,a4
 db4:	b7d1                	j	d78 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 db6:	0005c503          	lbu	a0,0(a1)
 dba:	8d1d                	sub	a0,a0,a5
			return 1;
 dbc:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 dc0:	6422                	ld	s0,8(sp)
 dc2:	0141                	addi	sp,sp,16
 dc4:	8082                	ret
			return 1;
 dc6:	4505                	li	a0,1
 dc8:	bfe5                	j	dc0 <compare_str_ic+0x52>

0000000000000dca <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 dca:	1141                	addi	sp,sp,-16
 dcc:	e406                	sd	ra,8(sp)
 dce:	e022                	sd	s0,0(sp)
 dd0:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 dd2:	fffff097          	auipc	ra,0xfffff
 dd6:	7ca080e7          	jalr	1994(ra) # 59c <open>
	return fd;
}
 dda:	60a2                	ld	ra,8(sp)
 ddc:	6402                	ld	s0,0(sp)
 dde:	0141                	addi	sp,sp,16
 de0:	8082                	ret

0000000000000de2 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 de2:	7139                	addi	sp,sp,-64
 de4:	fc06                	sd	ra,56(sp)
 de6:	f822                	sd	s0,48(sp)
 de8:	f426                	sd	s1,40(sp)
 dea:	f04a                	sd	s2,32(sp)
 dec:	ec4e                	sd	s3,24(sp)
 dee:	e852                	sd	s4,16(sp)
 df0:	0080                	addi	s0,sp,64
 df2:	89aa                	mv	s3,a0
 df4:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 df6:	4901                	li	s2,0
			return byteCount; 
		}
		*buffer++ = readByte;
		byteCount++;

		if (readByte == '\n'){
 df8:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 dfa:	4605                	li	a2,1
 dfc:	fcf40593          	addi	a1,s0,-49
 e00:	854e                	mv	a0,s3
 e02:	fffff097          	auipc	ra,0xfffff
 e06:	772080e7          	jalr	1906(ra) # 574 <read>
		if (readStatus <= 0){
 e0a:	02a05563          	blez	a0,e34 <read_line+0x52>
		*buffer++ = readByte;
 e0e:	0485                	addi	s1,s1,1
 e10:	fcf44783          	lbu	a5,-49(s0)
 e14:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 e18:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 e1a:	ff4790e3          	bne	a5,s4,dfa <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 e1e:	00048023          	sb	zero,0(s1)
		byteCount++;
 e22:	854a                	mv	a0,s2
			return byteCount;
		}
	}
}
 e24:	70e2                	ld	ra,56(sp)
 e26:	7442                	ld	s0,48(sp)
 e28:	74a2                	ld	s1,40(sp)
 e2a:	7902                	ld	s2,32(sp)
 e2c:	69e2                	ld	s3,24(sp)
 e2e:	6a42                	ld	s4,16(sp)
 e30:	6121                	addi	sp,sp,64
 e32:	8082                	ret
			*buffer = 0;  // Nullifying the end of the string
 e34:	00048023          	sb	zero,0(s1)
			if (byteCount == 0)
 e38:	fe0906e3          	beqz	s2,e24 <read_line+0x42>
 e3c:	854a                	mv	a0,s2
 e3e:	b7dd                	j	e24 <read_line+0x42>

0000000000000e40 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 e40:	1141                	addi	sp,sp,-16
 e42:	e406                	sd	ra,8(sp)
 e44:	e022                	sd	s0,0(sp)
 e46:	0800                	addi	s0,sp,16
	close(fd);
 e48:	fffff097          	auipc	ra,0xfffff
 e4c:	73c080e7          	jalr	1852(ra) # 584 <close>
}
 e50:	60a2                	ld	ra,8(sp)
 e52:	6402                	ld	s0,0(sp)
 e54:	0141                	addi	sp,sp,16
 e56:	8082                	ret
