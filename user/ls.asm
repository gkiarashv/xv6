
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
 12c:	e6850513          	addi	a0,a0,-408 # f90 <get_time_perf+0x98>
 130:	00000097          	auipc	ra,0x0
 134:	7e6080e7          	jalr	2022(ra) # 916 <printf>
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
 16a:	dfa58593          	addi	a1,a1,-518 # f60 <get_time_perf+0x68>
 16e:	4509                	li	a0,2
 170:	00000097          	auipc	ra,0x0
 174:	778080e7          	jalr	1912(ra) # 8e8 <fprintf>
    return;
 178:	b7e9                	j	142 <ls+0x8e>
    fprintf(2, "ls: cannot stat %s\n", path);
 17a:	864a                	mv	a2,s2
 17c:	00001597          	auipc	a1,0x1
 180:	dfc58593          	addi	a1,a1,-516 # f78 <get_time_perf+0x80>
 184:	4509                	li	a0,2
 186:	00000097          	auipc	ra,0x0
 18a:	762080e7          	jalr	1890(ra) # 8e8 <fprintf>
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
 1b2:	df250513          	addi	a0,a0,-526 # fa0 <get_time_perf+0xa8>
 1b6:	00000097          	auipc	ra,0x0
 1ba:	760080e7          	jalr	1888(ra) # 916 <printf>
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
 1f6:	dc6a0a13          	addi	s4,s4,-570 # fb8 <get_time_perf+0xc0>
        printf("ls: cannot stat %s\n", buf);
 1fa:	00001a97          	auipc	s5,0x1
 1fe:	d7ea8a93          	addi	s5,s5,-642 # f78 <get_time_perf+0x80>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 202:	a801                	j	212 <ls+0x15e>
        printf("ls: cannot stat %s\n", buf);
 204:	dc040593          	addi	a1,s0,-576
 208:	8556                	mv	a0,s5
 20a:	00000097          	auipc	ra,0x0
 20e:	70c080e7          	jalr	1804(ra) # 916 <printf>
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
 276:	6a4080e7          	jalr	1700(ra) # 916 <printf>
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
 2c0:	d0c50513          	addi	a0,a0,-756 # fc8 <get_time_perf+0xd0>
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

0000000000000624 <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 624:	48ed                	li	a7,27
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 62c:	48f1                	li	a7,28
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 634:	48f5                	li	a7,29
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 63c:	1101                	addi	sp,sp,-32
 63e:	ec06                	sd	ra,24(sp)
 640:	e822                	sd	s0,16(sp)
 642:	1000                	addi	s0,sp,32
 644:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 648:	4605                	li	a2,1
 64a:	fef40593          	addi	a1,s0,-17
 64e:	00000097          	auipc	ra,0x0
 652:	f2e080e7          	jalr	-210(ra) # 57c <write>
}
 656:	60e2                	ld	ra,24(sp)
 658:	6442                	ld	s0,16(sp)
 65a:	6105                	addi	sp,sp,32
 65c:	8082                	ret

000000000000065e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65e:	7139                	addi	sp,sp,-64
 660:	fc06                	sd	ra,56(sp)
 662:	f822                	sd	s0,48(sp)
 664:	f426                	sd	s1,40(sp)
 666:	f04a                	sd	s2,32(sp)
 668:	ec4e                	sd	s3,24(sp)
 66a:	0080                	addi	s0,sp,64
 66c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66e:	c299                	beqz	a3,674 <printint+0x16>
 670:	0805c963          	bltz	a1,702 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 674:	2581                	sext.w	a1,a1
  neg = 0;
 676:	4881                	li	a7,0
 678:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 67c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 67e:	2601                	sext.w	a2,a2
 680:	00001517          	auipc	a0,0x1
 684:	9b050513          	addi	a0,a0,-1616 # 1030 <digits>
 688:	883a                	mv	a6,a4
 68a:	2705                	addiw	a4,a4,1
 68c:	02c5f7bb          	remuw	a5,a1,a2
 690:	1782                	slli	a5,a5,0x20
 692:	9381                	srli	a5,a5,0x20
 694:	97aa                	add	a5,a5,a0
 696:	0007c783          	lbu	a5,0(a5)
 69a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 69e:	0005879b          	sext.w	a5,a1
 6a2:	02c5d5bb          	divuw	a1,a1,a2
 6a6:	0685                	addi	a3,a3,1
 6a8:	fec7f0e3          	bgeu	a5,a2,688 <printint+0x2a>
  if(neg)
 6ac:	00088c63          	beqz	a7,6c4 <printint+0x66>
    buf[i++] = '-';
 6b0:	fd070793          	addi	a5,a4,-48
 6b4:	00878733          	add	a4,a5,s0
 6b8:	02d00793          	li	a5,45
 6bc:	fef70823          	sb	a5,-16(a4)
 6c0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6c4:	02e05863          	blez	a4,6f4 <printint+0x96>
 6c8:	fc040793          	addi	a5,s0,-64
 6cc:	00e78933          	add	s2,a5,a4
 6d0:	fff78993          	addi	s3,a5,-1
 6d4:	99ba                	add	s3,s3,a4
 6d6:	377d                	addiw	a4,a4,-1
 6d8:	1702                	slli	a4,a4,0x20
 6da:	9301                	srli	a4,a4,0x20
 6dc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6e0:	fff94583          	lbu	a1,-1(s2)
 6e4:	8526                	mv	a0,s1
 6e6:	00000097          	auipc	ra,0x0
 6ea:	f56080e7          	jalr	-170(ra) # 63c <putc>
  while(--i >= 0)
 6ee:	197d                	addi	s2,s2,-1
 6f0:	ff3918e3          	bne	s2,s3,6e0 <printint+0x82>
}
 6f4:	70e2                	ld	ra,56(sp)
 6f6:	7442                	ld	s0,48(sp)
 6f8:	74a2                	ld	s1,40(sp)
 6fa:	7902                	ld	s2,32(sp)
 6fc:	69e2                	ld	s3,24(sp)
 6fe:	6121                	addi	sp,sp,64
 700:	8082                	ret
    x = -xx;
 702:	40b005bb          	negw	a1,a1
    neg = 1;
 706:	4885                	li	a7,1
    x = -xx;
 708:	bf85                	j	678 <printint+0x1a>

000000000000070a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 70a:	7119                	addi	sp,sp,-128
 70c:	fc86                	sd	ra,120(sp)
 70e:	f8a2                	sd	s0,112(sp)
 710:	f4a6                	sd	s1,104(sp)
 712:	f0ca                	sd	s2,96(sp)
 714:	ecce                	sd	s3,88(sp)
 716:	e8d2                	sd	s4,80(sp)
 718:	e4d6                	sd	s5,72(sp)
 71a:	e0da                	sd	s6,64(sp)
 71c:	fc5e                	sd	s7,56(sp)
 71e:	f862                	sd	s8,48(sp)
 720:	f466                	sd	s9,40(sp)
 722:	f06a                	sd	s10,32(sp)
 724:	ec6e                	sd	s11,24(sp)
 726:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 728:	0005c903          	lbu	s2,0(a1)
 72c:	18090f63          	beqz	s2,8ca <vprintf+0x1c0>
 730:	8aaa                	mv	s5,a0
 732:	8b32                	mv	s6,a2
 734:	00158493          	addi	s1,a1,1
  state = 0;
 738:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 73a:	02500a13          	li	s4,37
 73e:	4c55                	li	s8,21
 740:	00001c97          	auipc	s9,0x1
 744:	898c8c93          	addi	s9,s9,-1896 # fd8 <get_time_perf+0xe0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 748:	02800d93          	li	s11,40
  putc(fd, 'x');
 74c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74e:	00001b97          	auipc	s7,0x1
 752:	8e2b8b93          	addi	s7,s7,-1822 # 1030 <digits>
 756:	a839                	j	774 <vprintf+0x6a>
        putc(fd, c);
 758:	85ca                	mv	a1,s2
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	ee0080e7          	jalr	-288(ra) # 63c <putc>
 764:	a019                	j	76a <vprintf+0x60>
    } else if(state == '%'){
 766:	01498d63          	beq	s3,s4,780 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 76a:	0485                	addi	s1,s1,1
 76c:	fff4c903          	lbu	s2,-1(s1)
 770:	14090d63          	beqz	s2,8ca <vprintf+0x1c0>
    if(state == 0){
 774:	fe0999e3          	bnez	s3,766 <vprintf+0x5c>
      if(c == '%'){
 778:	ff4910e3          	bne	s2,s4,758 <vprintf+0x4e>
        state = '%';
 77c:	89d2                	mv	s3,s4
 77e:	b7f5                	j	76a <vprintf+0x60>
      if(c == 'd'){
 780:	11490c63          	beq	s2,s4,898 <vprintf+0x18e>
 784:	f9d9079b          	addiw	a5,s2,-99
 788:	0ff7f793          	zext.b	a5,a5
 78c:	10fc6e63          	bltu	s8,a5,8a8 <vprintf+0x19e>
 790:	f9d9079b          	addiw	a5,s2,-99
 794:	0ff7f713          	zext.b	a4,a5
 798:	10ec6863          	bltu	s8,a4,8a8 <vprintf+0x19e>
 79c:	00271793          	slli	a5,a4,0x2
 7a0:	97e6                	add	a5,a5,s9
 7a2:	439c                	lw	a5,0(a5)
 7a4:	97e6                	add	a5,a5,s9
 7a6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7a8:	008b0913          	addi	s2,s6,8
 7ac:	4685                	li	a3,1
 7ae:	4629                	li	a2,10
 7b0:	000b2583          	lw	a1,0(s6)
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	ea8080e7          	jalr	-344(ra) # 65e <printint>
 7be:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b765                	j	76a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c4:	008b0913          	addi	s2,s6,8
 7c8:	4681                	li	a3,0
 7ca:	4629                	li	a2,10
 7cc:	000b2583          	lw	a1,0(s6)
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e8c080e7          	jalr	-372(ra) # 65e <printint>
 7da:	8b4a                	mv	s6,s2
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b771                	j	76a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7e0:	008b0913          	addi	s2,s6,8
 7e4:	4681                	li	a3,0
 7e6:	866a                	mv	a2,s10
 7e8:	000b2583          	lw	a1,0(s6)
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	e70080e7          	jalr	-400(ra) # 65e <printint>
 7f6:	8b4a                	mv	s6,s2
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	bf85                	j	76a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7fc:	008b0793          	addi	a5,s6,8
 800:	f8f43423          	sd	a5,-120(s0)
 804:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 808:	03000593          	li	a1,48
 80c:	8556                	mv	a0,s5
 80e:	00000097          	auipc	ra,0x0
 812:	e2e080e7          	jalr	-466(ra) # 63c <putc>
  putc(fd, 'x');
 816:	07800593          	li	a1,120
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	e20080e7          	jalr	-480(ra) # 63c <putc>
 824:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 826:	03c9d793          	srli	a5,s3,0x3c
 82a:	97de                	add	a5,a5,s7
 82c:	0007c583          	lbu	a1,0(a5)
 830:	8556                	mv	a0,s5
 832:	00000097          	auipc	ra,0x0
 836:	e0a080e7          	jalr	-502(ra) # 63c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 83a:	0992                	slli	s3,s3,0x4
 83c:	397d                	addiw	s2,s2,-1
 83e:	fe0914e3          	bnez	s2,826 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 842:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 846:	4981                	li	s3,0
 848:	b70d                	j	76a <vprintf+0x60>
        s = va_arg(ap, char*);
 84a:	008b0913          	addi	s2,s6,8
 84e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 852:	02098163          	beqz	s3,874 <vprintf+0x16a>
        while(*s != 0){
 856:	0009c583          	lbu	a1,0(s3)
 85a:	c5ad                	beqz	a1,8c4 <vprintf+0x1ba>
          putc(fd, *s);
 85c:	8556                	mv	a0,s5
 85e:	00000097          	auipc	ra,0x0
 862:	dde080e7          	jalr	-546(ra) # 63c <putc>
          s++;
 866:	0985                	addi	s3,s3,1
        while(*s != 0){
 868:	0009c583          	lbu	a1,0(s3)
 86c:	f9e5                	bnez	a1,85c <vprintf+0x152>
        s = va_arg(ap, char*);
 86e:	8b4a                	mv	s6,s2
      state = 0;
 870:	4981                	li	s3,0
 872:	bde5                	j	76a <vprintf+0x60>
          s = "(null)";
 874:	00000997          	auipc	s3,0x0
 878:	75c98993          	addi	s3,s3,1884 # fd0 <get_time_perf+0xd8>
        while(*s != 0){
 87c:	85ee                	mv	a1,s11
 87e:	bff9                	j	85c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 880:	008b0913          	addi	s2,s6,8
 884:	000b4583          	lbu	a1,0(s6)
 888:	8556                	mv	a0,s5
 88a:	00000097          	auipc	ra,0x0
 88e:	db2080e7          	jalr	-590(ra) # 63c <putc>
 892:	8b4a                	mv	s6,s2
      state = 0;
 894:	4981                	li	s3,0
 896:	bdd1                	j	76a <vprintf+0x60>
        putc(fd, c);
 898:	85d2                	mv	a1,s4
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	da0080e7          	jalr	-608(ra) # 63c <putc>
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	b5d1                	j	76a <vprintf+0x60>
        putc(fd, '%');
 8a8:	85d2                	mv	a1,s4
 8aa:	8556                	mv	a0,s5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	d90080e7          	jalr	-624(ra) # 63c <putc>
        putc(fd, c);
 8b4:	85ca                	mv	a1,s2
 8b6:	8556                	mv	a0,s5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	d84080e7          	jalr	-636(ra) # 63c <putc>
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	b565                	j	76a <vprintf+0x60>
        s = va_arg(ap, char*);
 8c4:	8b4a                	mv	s6,s2
      state = 0;
 8c6:	4981                	li	s3,0
 8c8:	b54d                	j	76a <vprintf+0x60>
    }
  }
}
 8ca:	70e6                	ld	ra,120(sp)
 8cc:	7446                	ld	s0,112(sp)
 8ce:	74a6                	ld	s1,104(sp)
 8d0:	7906                	ld	s2,96(sp)
 8d2:	69e6                	ld	s3,88(sp)
 8d4:	6a46                	ld	s4,80(sp)
 8d6:	6aa6                	ld	s5,72(sp)
 8d8:	6b06                	ld	s6,64(sp)
 8da:	7be2                	ld	s7,56(sp)
 8dc:	7c42                	ld	s8,48(sp)
 8de:	7ca2                	ld	s9,40(sp)
 8e0:	7d02                	ld	s10,32(sp)
 8e2:	6de2                	ld	s11,24(sp)
 8e4:	6109                	addi	sp,sp,128
 8e6:	8082                	ret

00000000000008e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e8:	715d                	addi	sp,sp,-80
 8ea:	ec06                	sd	ra,24(sp)
 8ec:	e822                	sd	s0,16(sp)
 8ee:	1000                	addi	s0,sp,32
 8f0:	e010                	sd	a2,0(s0)
 8f2:	e414                	sd	a3,8(s0)
 8f4:	e818                	sd	a4,16(s0)
 8f6:	ec1c                	sd	a5,24(s0)
 8f8:	03043023          	sd	a6,32(s0)
 8fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 900:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 904:	8622                	mv	a2,s0
 906:	00000097          	auipc	ra,0x0
 90a:	e04080e7          	jalr	-508(ra) # 70a <vprintf>
}
 90e:	60e2                	ld	ra,24(sp)
 910:	6442                	ld	s0,16(sp)
 912:	6161                	addi	sp,sp,80
 914:	8082                	ret

0000000000000916 <printf>:

void
printf(const char *fmt, ...)
{
 916:	711d                	addi	sp,sp,-96
 918:	ec06                	sd	ra,24(sp)
 91a:	e822                	sd	s0,16(sp)
 91c:	1000                	addi	s0,sp,32
 91e:	e40c                	sd	a1,8(s0)
 920:	e810                	sd	a2,16(s0)
 922:	ec14                	sd	a3,24(s0)
 924:	f018                	sd	a4,32(s0)
 926:	f41c                	sd	a5,40(s0)
 928:	03043823          	sd	a6,48(s0)
 92c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 930:	00840613          	addi	a2,s0,8
 934:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 938:	85aa                	mv	a1,a0
 93a:	4505                	li	a0,1
 93c:	00000097          	auipc	ra,0x0
 940:	dce080e7          	jalr	-562(ra) # 70a <vprintf>
}
 944:	60e2                	ld	ra,24(sp)
 946:	6442                	ld	s0,16(sp)
 948:	6125                	addi	sp,sp,96
 94a:	8082                	ret

000000000000094c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 94c:	1141                	addi	sp,sp,-16
 94e:	e422                	sd	s0,8(sp)
 950:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 952:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 956:	00001797          	auipc	a5,0x1
 95a:	6aa7b783          	ld	a5,1706(a5) # 2000 <freep>
 95e:	a02d                	j	988 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 960:	4618                	lw	a4,8(a2)
 962:	9f2d                	addw	a4,a4,a1
 964:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 968:	6398                	ld	a4,0(a5)
 96a:	6310                	ld	a2,0(a4)
 96c:	a83d                	j	9aa <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 96e:	ff852703          	lw	a4,-8(a0)
 972:	9f31                	addw	a4,a4,a2
 974:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 976:	ff053683          	ld	a3,-16(a0)
 97a:	a091                	j	9be <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97c:	6398                	ld	a4,0(a5)
 97e:	00e7e463          	bltu	a5,a4,986 <free+0x3a>
 982:	00e6ea63          	bltu	a3,a4,996 <free+0x4a>
{
 986:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 988:	fed7fae3          	bgeu	a5,a3,97c <free+0x30>
 98c:	6398                	ld	a4,0(a5)
 98e:	00e6e463          	bltu	a3,a4,996 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 992:	fee7eae3          	bltu	a5,a4,986 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 996:	ff852583          	lw	a1,-8(a0)
 99a:	6390                	ld	a2,0(a5)
 99c:	02059813          	slli	a6,a1,0x20
 9a0:	01c85713          	srli	a4,a6,0x1c
 9a4:	9736                	add	a4,a4,a3
 9a6:	fae60de3          	beq	a2,a4,960 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9aa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ae:	4790                	lw	a2,8(a5)
 9b0:	02061593          	slli	a1,a2,0x20
 9b4:	01c5d713          	srli	a4,a1,0x1c
 9b8:	973e                	add	a4,a4,a5
 9ba:	fae68ae3          	beq	a3,a4,96e <free+0x22>
    p->s.ptr = bp->s.ptr;
 9be:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9c0:	00001717          	auipc	a4,0x1
 9c4:	64f73023          	sd	a5,1600(a4) # 2000 <freep>
}
 9c8:	6422                	ld	s0,8(sp)
 9ca:	0141                	addi	sp,sp,16
 9cc:	8082                	ret

00000000000009ce <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ce:	7139                	addi	sp,sp,-64
 9d0:	fc06                	sd	ra,56(sp)
 9d2:	f822                	sd	s0,48(sp)
 9d4:	f426                	sd	s1,40(sp)
 9d6:	f04a                	sd	s2,32(sp)
 9d8:	ec4e                	sd	s3,24(sp)
 9da:	e852                	sd	s4,16(sp)
 9dc:	e456                	sd	s5,8(sp)
 9de:	e05a                	sd	s6,0(sp)
 9e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	02051493          	slli	s1,a0,0x20
 9e6:	9081                	srli	s1,s1,0x20
 9e8:	04bd                	addi	s1,s1,15
 9ea:	8091                	srli	s1,s1,0x4
 9ec:	0014899b          	addiw	s3,s1,1
 9f0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9f2:	00001517          	auipc	a0,0x1
 9f6:	60e53503          	ld	a0,1550(a0) # 2000 <freep>
 9fa:	c515                	beqz	a0,a26 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fe:	4798                	lw	a4,8(a5)
 a00:	02977f63          	bgeu	a4,s1,a3e <malloc+0x70>
 a04:	8a4e                	mv	s4,s3
 a06:	0009871b          	sext.w	a4,s3
 a0a:	6685                	lui	a3,0x1
 a0c:	00d77363          	bgeu	a4,a3,a12 <malloc+0x44>
 a10:	6a05                	lui	s4,0x1
 a12:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a16:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a1a:	00001917          	auipc	s2,0x1
 a1e:	5e690913          	addi	s2,s2,1510 # 2000 <freep>
  if(p == (char*)-1)
 a22:	5afd                	li	s5,-1
 a24:	a895                	j	a98 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a26:	00001797          	auipc	a5,0x1
 a2a:	5fa78793          	addi	a5,a5,1530 # 2020 <base>
 a2e:	00001717          	auipc	a4,0x1
 a32:	5cf73923          	sd	a5,1490(a4) # 2000 <freep>
 a36:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a38:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a3c:	b7e1                	j	a04 <malloc+0x36>
      if(p->s.size == nunits)
 a3e:	02e48c63          	beq	s1,a4,a76 <malloc+0xa8>
        p->s.size -= nunits;
 a42:	4137073b          	subw	a4,a4,s3
 a46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a48:	02071693          	slli	a3,a4,0x20
 a4c:	01c6d713          	srli	a4,a3,0x1c
 a50:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a52:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a56:	00001717          	auipc	a4,0x1
 a5a:	5aa73523          	sd	a0,1450(a4) # 2000 <freep>
      return (void*)(p + 1);
 a5e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a62:	70e2                	ld	ra,56(sp)
 a64:	7442                	ld	s0,48(sp)
 a66:	74a2                	ld	s1,40(sp)
 a68:	7902                	ld	s2,32(sp)
 a6a:	69e2                	ld	s3,24(sp)
 a6c:	6a42                	ld	s4,16(sp)
 a6e:	6aa2                	ld	s5,8(sp)
 a70:	6b02                	ld	s6,0(sp)
 a72:	6121                	addi	sp,sp,64
 a74:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a76:	6398                	ld	a4,0(a5)
 a78:	e118                	sd	a4,0(a0)
 a7a:	bff1                	j	a56 <malloc+0x88>
  hp->s.size = nu;
 a7c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a80:	0541                	addi	a0,a0,16
 a82:	00000097          	auipc	ra,0x0
 a86:	eca080e7          	jalr	-310(ra) # 94c <free>
  return freep;
 a8a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a8e:	d971                	beqz	a0,a62 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a90:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a92:	4798                	lw	a4,8(a5)
 a94:	fa9775e3          	bgeu	a4,s1,a3e <malloc+0x70>
    if(p == freep)
 a98:	00093703          	ld	a4,0(s2)
 a9c:	853e                	mv	a0,a5
 a9e:	fef719e3          	bne	a4,a5,a90 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 aa2:	8552                	mv	a0,s4
 aa4:	00000097          	auipc	ra,0x0
 aa8:	b40080e7          	jalr	-1216(ra) # 5e4 <sbrk>
  if(p == (char*)-1)
 aac:	fd5518e3          	bne	a0,s5,a7c <malloc+0xae>
        return 0;
 ab0:	4501                	li	a0,0
 ab2:	bf45                	j	a62 <malloc+0x94>

0000000000000ab4 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 ab4:	c1d9                	beqz	a1,b3a <head_run+0x86>
void head_run(int fd, int numOfLines){
 ab6:	dd010113          	addi	sp,sp,-560
 aba:	22113423          	sd	ra,552(sp)
 abe:	22813023          	sd	s0,544(sp)
 ac2:	20913c23          	sd	s1,536(sp)
 ac6:	21213823          	sd	s2,528(sp)
 aca:	21313423          	sd	s3,520(sp)
 ace:	21413023          	sd	s4,512(sp)
 ad2:	1c00                	addi	s0,sp,560
 ad4:	892a                	mv	s2,a0
 ad6:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 ada:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 adc:	00000a17          	auipc	s4,0x0
 ae0:	594a0a13          	addi	s4,s4,1428 # 1070 <digits+0x40>
		readStatus = read_line(fd, line);
 ae4:	dd840593          	addi	a1,s0,-552
 ae8:	854a                	mv	a0,s2
 aea:	00000097          	auipc	ra,0x0
 aee:	394080e7          	jalr	916(ra) # e7e <read_line>
		if (readStatus == READ_ERROR){
 af2:	01350d63          	beq	a0,s3,b0c <head_run+0x58>
		if (readStatus == READ_EOF)
 af6:	c11d                	beqz	a0,b1c <head_run+0x68>
		printf("%s",line);
 af8:	dd840593          	addi	a1,s0,-552
 afc:	8552                	mv	a0,s4
 afe:	00000097          	auipc	ra,0x0
 b02:	e18080e7          	jalr	-488(ra) # 916 <printf>
	while(numOfLines--){
 b06:	34fd                	addiw	s1,s1,-1
 b08:	fcf1                	bnez	s1,ae4 <head_run+0x30>
 b0a:	a809                	j	b1c <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 b0c:	00000517          	auipc	a0,0x0
 b10:	53c50513          	addi	a0,a0,1340 # 1048 <digits+0x18>
 b14:	00000097          	auipc	ra,0x0
 b18:	e02080e7          	jalr	-510(ra) # 916 <printf>

	}
}
 b1c:	22813083          	ld	ra,552(sp)
 b20:	22013403          	ld	s0,544(sp)
 b24:	21813483          	ld	s1,536(sp)
 b28:	21013903          	ld	s2,528(sp)
 b2c:	20813983          	ld	s3,520(sp)
 b30:	20013a03          	ld	s4,512(sp)
 b34:	23010113          	addi	sp,sp,560
 b38:	8082                	ret
 b3a:	8082                	ret

0000000000000b3c <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 b3c:	ba010113          	addi	sp,sp,-1120
 b40:	44113c23          	sd	ra,1112(sp)
 b44:	44813823          	sd	s0,1104(sp)
 b48:	44913423          	sd	s1,1096(sp)
 b4c:	45213023          	sd	s2,1088(sp)
 b50:	43313c23          	sd	s3,1080(sp)
 b54:	43413823          	sd	s4,1072(sp)
 b58:	43513423          	sd	s5,1064(sp)
 b5c:	43613023          	sd	s6,1056(sp)
 b60:	41713c23          	sd	s7,1048(sp)
 b64:	41813823          	sd	s8,1040(sp)
 b68:	41913423          	sd	s9,1032(sp)
 b6c:	41a13023          	sd	s10,1024(sp)
 b70:	3fb13c23          	sd	s11,1016(sp)
 b74:	46010413          	addi	s0,sp,1120
 b78:	89aa                	mv	s3,a0
 b7a:	8aae                	mv	s5,a1
 b7c:	8c32                	mv	s8,a2
 b7e:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 b80:	d9840593          	addi	a1,s0,-616
 b84:	00000097          	auipc	ra,0x0
 b88:	2fa080e7          	jalr	762(ra) # e7e <read_line>


  if (readStatus == READ_ERROR)
 b8c:	57fd                	li	a5,-1
 b8e:	04f50163          	beq	a0,a5,bd0 <uniq_run+0x94>
 b92:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 b94:	ed21                	bnez	a0,bec <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 b96:	45813083          	ld	ra,1112(sp)
 b9a:	45013403          	ld	s0,1104(sp)
 b9e:	44813483          	ld	s1,1096(sp)
 ba2:	44013903          	ld	s2,1088(sp)
 ba6:	43813983          	ld	s3,1080(sp)
 baa:	43013a03          	ld	s4,1072(sp)
 bae:	42813a83          	ld	s5,1064(sp)
 bb2:	42013b03          	ld	s6,1056(sp)
 bb6:	41813b83          	ld	s7,1048(sp)
 bba:	41013c03          	ld	s8,1040(sp)
 bbe:	40813c83          	ld	s9,1032(sp)
 bc2:	40013d03          	ld	s10,1024(sp)
 bc6:	3f813d83          	ld	s11,1016(sp)
 bca:	46010113          	addi	sp,sp,1120
 bce:	8082                	ret
    printf("[ERR] Error reading from the file ");
 bd0:	00000517          	auipc	a0,0x0
 bd4:	4a850513          	addi	a0,a0,1192 # 1078 <digits+0x48>
 bd8:	00000097          	auipc	ra,0x0
 bdc:	d3e080e7          	jalr	-706(ra) # 916 <printf>
 be0:	bf5d                	j	b96 <uniq_run+0x5a>
 be2:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 be4:	8926                	mv	s2,s1
 be6:	84be                	mv	s1,a5
        lineCount = 1;
 be8:	8b6a                	mv	s6,s10
 bea:	a8ed                	j	ce4 <uniq_run+0x1a8>
    int lineCount=1;
 bec:	4b05                	li	s6,1
  char * line2 = buffer2;
 bee:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 bf2:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 bf6:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 bf8:	4d05                	li	s10,1
              printf("%s",line1);
 bfa:	00000d97          	auipc	s11,0x0
 bfe:	476d8d93          	addi	s11,s11,1142 # 1070 <digits+0x40>
 c02:	a0cd                	j	ce4 <uniq_run+0x1a8>
            if (repeatedLines){
 c04:	020a0b63          	beqz	s4,c3a <uniq_run+0xfe>
                if (isRepeated){
 c08:	f80b87e3          	beqz	s7,b96 <uniq_run+0x5a>
                    if (showCount)
 c0c:	000c0d63          	beqz	s8,c26 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 c10:	864a                	mv	a2,s2
 c12:	85da                	mv	a1,s6
 c14:	00000517          	auipc	a0,0x0
 c18:	48c50513          	addi	a0,a0,1164 # 10a0 <digits+0x70>
 c1c:	00000097          	auipc	ra,0x0
 c20:	cfa080e7          	jalr	-774(ra) # 916 <printf>
 c24:	bf8d                	j	b96 <uniq_run+0x5a>
                      printf("%s",line1);
 c26:	85ca                	mv	a1,s2
 c28:	00000517          	auipc	a0,0x0
 c2c:	44850513          	addi	a0,a0,1096 # 1070 <digits+0x40>
 c30:	00000097          	auipc	ra,0x0
 c34:	ce6080e7          	jalr	-794(ra) # 916 <printf>
 c38:	bfb9                	j	b96 <uniq_run+0x5a>
                if (showCount)
 c3a:	000c0d63          	beqz	s8,c54 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 c3e:	864a                	mv	a2,s2
 c40:	85da                	mv	a1,s6
 c42:	00000517          	auipc	a0,0x0
 c46:	45e50513          	addi	a0,a0,1118 # 10a0 <digits+0x70>
 c4a:	00000097          	auipc	ra,0x0
 c4e:	ccc080e7          	jalr	-820(ra) # 916 <printf>
 c52:	b791                	j	b96 <uniq_run+0x5a>
                  printf("%s",line1);
 c54:	85ca                	mv	a1,s2
 c56:	00000517          	auipc	a0,0x0
 c5a:	41a50513          	addi	a0,a0,1050 # 1070 <digits+0x40>
 c5e:	00000097          	auipc	ra,0x0
 c62:	cb8080e7          	jalr	-840(ra) # 916 <printf>
 c66:	bf05                	j	b96 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 c68:	00000517          	auipc	a0,0x0
 c6c:	44050513          	addi	a0,a0,1088 # 10a8 <digits+0x78>
 c70:	00000097          	auipc	ra,0x0
 c74:	ca6080e7          	jalr	-858(ra) # 916 <printf>
          break;
 c78:	bf39                	j	b96 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 c7a:	85a6                	mv	a1,s1
 c7c:	854a                	mv	a0,s2
 c7e:	00000097          	auipc	ra,0x0
 c82:	110080e7          	jalr	272(ra) # d8e <compare_str_ic>
 c86:	a041                	j	d06 <uniq_run+0x1ca>
                  printf("%s",line1);
 c88:	85ca                	mv	a1,s2
 c8a:	856e                	mv	a0,s11
 c8c:	00000097          	auipc	ra,0x0
 c90:	c8a080e7          	jalr	-886(ra) # 916 <printf>
        lineCount = 1;
 c94:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 c96:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 c98:	8926                	mv	s2,s1
                  printf("%s",line1);
 c9a:	84be                	mv	s1,a5
        isRepeated = 0 ;
 c9c:	4b81                	li	s7,0
 c9e:	a099                	j	ce4 <uniq_run+0x1a8>
            if (showCount)
 ca0:	020c0263          	beqz	s8,cc4 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 ca4:	864a                	mv	a2,s2
 ca6:	85da                	mv	a1,s6
 ca8:	00000517          	auipc	a0,0x0
 cac:	3f850513          	addi	a0,a0,1016 # 10a0 <digits+0x70>
 cb0:	00000097          	auipc	ra,0x0
 cb4:	c66080e7          	jalr	-922(ra) # 916 <printf>
 cb8:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 cba:	8926                	mv	s2,s1
 cbc:	84be                	mv	s1,a5
        isRepeated = 0 ;
 cbe:	4b81                	li	s7,0
        lineCount = 1;
 cc0:	8b6a                	mv	s6,s10
 cc2:	a00d                	j	ce4 <uniq_run+0x1a8>
              printf("%s",line1);
 cc4:	85ca                	mv	a1,s2
 cc6:	856e                	mv	a0,s11
 cc8:	00000097          	auipc	ra,0x0
 ccc:	c4e080e7          	jalr	-946(ra) # 916 <printf>
 cd0:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 cd2:	8926                	mv	s2,s1
              printf("%s",line1);
 cd4:	84be                	mv	s1,a5
        isRepeated = 0 ;
 cd6:	4b81                	li	s7,0
        lineCount = 1;
 cd8:	8b6a                	mv	s6,s10
 cda:	a029                	j	ce4 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 cdc:	000a0363          	beqz	s4,ce2 <uniq_run+0x1a6>
 ce0:	8bea                	mv	s7,s10
          lineCount++;
 ce2:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 ce4:	85a6                	mv	a1,s1
 ce6:	854e                	mv	a0,s3
 ce8:	00000097          	auipc	ra,0x0
 cec:	196080e7          	jalr	406(ra) # e7e <read_line>
        if (readStatus == READ_EOF){
 cf0:	d911                	beqz	a0,c04 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 cf2:	f7950be3          	beq	a0,s9,c68 <uniq_run+0x12c>
        if (!ignoreCase)
 cf6:	f80a92e3          	bnez	s5,c7a <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 cfa:	85a6                	mv	a1,s1
 cfc:	854a                	mv	a0,s2
 cfe:	00000097          	auipc	ra,0x0
 d02:	062080e7          	jalr	98(ra) # d60 <compare_str>
        if (compareStatus != 0){ 
 d06:	d979                	beqz	a0,cdc <uniq_run+0x1a0>
          if (repeatedLines){
 d08:	f80a0ce3          	beqz	s4,ca0 <uniq_run+0x164>
            if (isRepeated){
 d0c:	ec0b8be3          	beqz	s7,be2 <uniq_run+0xa6>
                if (showCount)
 d10:	f60c0ce3          	beqz	s8,c88 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 d14:	864a                	mv	a2,s2
 d16:	85da                	mv	a1,s6
 d18:	00000517          	auipc	a0,0x0
 d1c:	38850513          	addi	a0,a0,904 # 10a0 <digits+0x70>
 d20:	00000097          	auipc	ra,0x0
 d24:	bf6080e7          	jalr	-1034(ra) # 916 <printf>
        lineCount = 1;
 d28:	8b5e                	mv	s6,s7
 d2a:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 d2c:	8926                	mv	s2,s1
 d2e:	84be                	mv	s1,a5
        isRepeated = 0 ;
 d30:	4b81                	li	s7,0
 d32:	bf4d                	j	ce4 <uniq_run+0x1a8>

0000000000000d34 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 d34:	1141                	addi	sp,sp,-16
 d36:	e422                	sd	s0,8(sp)
 d38:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 d3a:	00054783          	lbu	a5,0(a0)
 d3e:	cf99                	beqz	a5,d5c <get_strlen+0x28>
 d40:	00150713          	addi	a4,a0,1
 d44:	87ba                	mv	a5,a4
 d46:	4685                	li	a3,1
 d48:	9e99                	subw	a3,a3,a4
 d4a:	00f6853b          	addw	a0,a3,a5
 d4e:	0785                	addi	a5,a5,1
 d50:	fff7c703          	lbu	a4,-1(a5)
 d54:	fb7d                	bnez	a4,d4a <get_strlen+0x16>
	return len;
}
 d56:	6422                	ld	s0,8(sp)
 d58:	0141                	addi	sp,sp,16
 d5a:	8082                	ret
	int len = 0;
 d5c:	4501                	li	a0,0
 d5e:	bfe5                	j	d56 <get_strlen+0x22>

0000000000000d60 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 d60:	1141                	addi	sp,sp,-16
 d62:	e422                	sd	s0,8(sp)
 d64:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 d66:	00054783          	lbu	a5,0(a0)
 d6a:	cb91                	beqz	a5,d7e <compare_str+0x1e>
 d6c:	0005c703          	lbu	a4,0(a1)
 d70:	c719                	beqz	a4,d7e <compare_str+0x1e>
		if (*s1++ != *s2++)
 d72:	0505                	addi	a0,a0,1
 d74:	0585                	addi	a1,a1,1
 d76:	fee788e3          	beq	a5,a4,d66 <compare_str+0x6>
			return 1;
 d7a:	4505                	li	a0,1
 d7c:	a031                	j	d88 <compare_str+0x28>
	}
	if (*s1 == *s2)
 d7e:	0005c503          	lbu	a0,0(a1)
 d82:	8d1d                	sub	a0,a0,a5
			return 1;
 d84:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 d88:	6422                	ld	s0,8(sp)
 d8a:	0141                	addi	sp,sp,16
 d8c:	8082                	ret

0000000000000d8e <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 d8e:	1141                	addi	sp,sp,-16
 d90:	e422                	sd	s0,8(sp)
 d92:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 d94:	4665                	li	a2,25
	while(*s1 && *s2){
 d96:	a019                	j	d9c <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 d98:	04e79763          	bne	a5,a4,de6 <compare_str_ic+0x58>
	while(*s1 && *s2){
 d9c:	00054783          	lbu	a5,0(a0)
 da0:	cb9d                	beqz	a5,dd6 <compare_str_ic+0x48>
 da2:	0005c703          	lbu	a4,0(a1)
 da6:	cb05                	beqz	a4,dd6 <compare_str_ic+0x48>
		char b1 = *s1++;
 da8:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 daa:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 dac:	fbf7869b          	addiw	a3,a5,-65
 db0:	0ff6f693          	zext.b	a3,a3
 db4:	00d66663          	bltu	a2,a3,dc0 <compare_str_ic+0x32>
			b1 += 32;
 db8:	0207879b          	addiw	a5,a5,32
 dbc:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 dc0:	fbf7069b          	addiw	a3,a4,-65
 dc4:	0ff6f693          	zext.b	a3,a3
 dc8:	fcd668e3          	bltu	a2,a3,d98 <compare_str_ic+0xa>
			b2 += 32;
 dcc:	0207071b          	addiw	a4,a4,32
 dd0:	0ff77713          	zext.b	a4,a4
 dd4:	b7d1                	j	d98 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 dd6:	0005c503          	lbu	a0,0(a1)
 dda:	8d1d                	sub	a0,a0,a5
			return 1;
 ddc:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 de0:	6422                	ld	s0,8(sp)
 de2:	0141                	addi	sp,sp,16
 de4:	8082                	ret
			return 1;
 de6:	4505                	li	a0,1
 de8:	bfe5                	j	de0 <compare_str_ic+0x52>

0000000000000dea <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 dea:	7179                	addi	sp,sp,-48
 dec:	f406                	sd	ra,40(sp)
 dee:	f022                	sd	s0,32(sp)
 df0:	ec26                	sd	s1,24(sp)
 df2:	e84a                	sd	s2,16(sp)
 df4:	e44e                	sd	s3,8(sp)
 df6:	1800                	addi	s0,sp,48
 df8:	89aa                	mv	s3,a0
 dfa:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 dfc:	00000097          	auipc	ra,0x0
 e00:	f38080e7          	jalr	-200(ra) # d34 <get_strlen>
 e04:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 e06:	854a                	mv	a0,s2
 e08:	00000097          	auipc	ra,0x0
 e0c:	f2c080e7          	jalr	-212(ra) # d34 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 e10:	409505bb          	subw	a1,a0,s1
 e14:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 e16:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 e18:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 e1a:	0005da63          	bgez	a1,e2e <check_substr+0x44>
 e1e:	a81d                	j	e54 <check_substr+0x6a>
        if (j == M)
 e20:	02f48a63          	beq	s1,a5,e54 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 e24:	0885                	addi	a7,a7,1
 e26:	0008879b          	sext.w	a5,a7
 e2a:	02f5cc63          	blt	a1,a5,e62 <check_substr+0x78>
 e2e:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 e32:	011906b3          	add	a3,s2,a7
 e36:	874e                	mv	a4,s3
 e38:	879a                	mv	a5,t1
 e3a:	fe9053e3          	blez	s1,e20 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 e3e:	0006c803          	lbu	a6,0(a3) # 1000 <get_time_perf+0x108>
 e42:	00074603          	lbu	a2,0(a4)
 e46:	fcc81de3          	bne	a6,a2,e20 <check_substr+0x36>
        for (j = 0; j < M; j++)
 e4a:	2785                	addiw	a5,a5,1
 e4c:	0685                	addi	a3,a3,1
 e4e:	0705                	addi	a4,a4,1
 e50:	fef497e3          	bne	s1,a5,e3e <check_substr+0x54>
}
 e54:	70a2                	ld	ra,40(sp)
 e56:	7402                	ld	s0,32(sp)
 e58:	64e2                	ld	s1,24(sp)
 e5a:	6942                	ld	s2,16(sp)
 e5c:	69a2                	ld	s3,8(sp)
 e5e:	6145                	addi	sp,sp,48
 e60:	8082                	ret
    return -1;
 e62:	557d                	li	a0,-1
 e64:	bfc5                	j	e54 <check_substr+0x6a>

0000000000000e66 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 e66:	1141                	addi	sp,sp,-16
 e68:	e406                	sd	ra,8(sp)
 e6a:	e022                	sd	s0,0(sp)
 e6c:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 e6e:	fffff097          	auipc	ra,0xfffff
 e72:	72e080e7          	jalr	1838(ra) # 59c <open>
	return fd;
}
 e76:	60a2                	ld	ra,8(sp)
 e78:	6402                	ld	s0,0(sp)
 e7a:	0141                	addi	sp,sp,16
 e7c:	8082                	ret

0000000000000e7e <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 e7e:	7139                	addi	sp,sp,-64
 e80:	fc06                	sd	ra,56(sp)
 e82:	f822                	sd	s0,48(sp)
 e84:	f426                	sd	s1,40(sp)
 e86:	f04a                	sd	s2,32(sp)
 e88:	ec4e                	sd	s3,24(sp)
 e8a:	e852                	sd	s4,16(sp)
 e8c:	0080                	addi	s0,sp,64
 e8e:	89aa                	mv	s3,a0
 e90:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 e92:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 e94:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 e96:	4605                	li	a2,1
 e98:	fcf40593          	addi	a1,s0,-49
 e9c:	854e                	mv	a0,s3
 e9e:	fffff097          	auipc	ra,0xfffff
 ea2:	6d6080e7          	jalr	1750(ra) # 574 <read>
		if (readStatus == 0){
 ea6:	c505                	beqz	a0,ece <read_line+0x50>
		*buffer++ = readByte;
 ea8:	0485                	addi	s1,s1,1
 eaa:	fcf44783          	lbu	a5,-49(s0)
 eae:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 eb2:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 eb4:	ff4791e3          	bne	a5,s4,e96 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 eb8:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 ebc:	854a                	mv	a0,s2
 ebe:	70e2                	ld	ra,56(sp)
 ec0:	7442                	ld	s0,48(sp)
 ec2:	74a2                	ld	s1,40(sp)
 ec4:	7902                	ld	s2,32(sp)
 ec6:	69e2                	ld	s3,24(sp)
 ec8:	6a42                	ld	s4,16(sp)
 eca:	6121                	addi	sp,sp,64
 ecc:	8082                	ret
			if (byteCount!=0){
 ece:	fe0907e3          	beqz	s2,ebc <read_line+0x3e>
				*buffer = '\n';
 ed2:	47a9                	li	a5,10
 ed4:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 ed8:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 edc:	2905                	addiw	s2,s2,1
 ede:	bff9                	j	ebc <read_line+0x3e>

0000000000000ee0 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 ee0:	1141                	addi	sp,sp,-16
 ee2:	e406                	sd	ra,8(sp)
 ee4:	e022                	sd	s0,0(sp)
 ee6:	0800                	addi	s0,sp,16
	close(fd);
 ee8:	fffff097          	auipc	ra,0xfffff
 eec:	69c080e7          	jalr	1692(ra) # 584 <close>
}
 ef0:	60a2                	ld	ra,8(sp)
 ef2:	6402                	ld	s0,0(sp)
 ef4:	0141                	addi	sp,sp,16
 ef6:	8082                	ret

0000000000000ef8 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 ef8:	7139                	addi	sp,sp,-64
 efa:	fc06                	sd	ra,56(sp)
 efc:	f822                	sd	s0,48(sp)
 efe:	f426                	sd	s1,40(sp)
 f00:	f04a                	sd	s2,32(sp)
 f02:	0080                	addi	s0,sp,64
 f04:	84aa                	mv	s1,a0
 f06:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 f08:	fffff097          	auipc	ra,0xfffff
 f0c:	64c080e7          	jalr	1612(ra) # 554 <fork>
 f10:	ed19                	bnez	a0,f2e <get_time_perf+0x36>
		exec(argv[0],argv);
 f12:	85ca                	mv	a1,s2
 f14:	00093503          	ld	a0,0(s2)
 f18:	fffff097          	auipc	ra,0xfffff
 f1c:	67c080e7          	jalr	1660(ra) # 594 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 f20:	8526                	mv	a0,s1
 f22:	70e2                	ld	ra,56(sp)
 f24:	7442                	ld	s0,48(sp)
 f26:	74a2                	ld	s1,40(sp)
 f28:	7902                	ld	s2,32(sp)
 f2a:	6121                	addi	sp,sp,64
 f2c:	8082                	ret
		times(pid , &time);
 f2e:	fc040593          	addi	a1,s0,-64
 f32:	fffff097          	auipc	ra,0xfffff
 f36:	6e2080e7          	jalr	1762(ra) # 614 <times>
		return time;
 f3a:	fc043783          	ld	a5,-64(s0)
 f3e:	e09c                	sd	a5,0(s1)
 f40:	fc843783          	ld	a5,-56(s0)
 f44:	e49c                	sd	a5,8(s1)
 f46:	fd043783          	ld	a5,-48(s0)
 f4a:	e89c                	sd	a5,16(s1)
 f4c:	fd843783          	ld	a5,-40(s0)
 f50:	ec9c                	sd	a5,24(s1)
 f52:	b7f9                	j	f20 <get_time_perf+0x28>
