
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <parse_cmd>:

	ps(pid, ppid, status, pName);
}


void parse_cmd(char ** cmd, int * pid , int  * ppid, char ** name ,int * status){
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
  1e:	84aa                	mv	s1,a0
  20:	f8d43423          	sd	a3,-120(s0)

	while(*cmd){
  24:	6108                	ld	a0,0(a0)
  26:	14050863          	beqz	a0,176 <parse_cmd+0x176>
  2a:	8a2e                	mv	s4,a1
  2c:	8b32                	mv	s6,a2
  2e:	8c3a                	mv	s8,a4

		if (!compare_str(*cmd,"-pid")){
  30:	00001997          	auipc	s3,0x1
  34:	e4098993          	addi	s3,s3,-448 # e70 <get_time_perf+0x66>
			cmd++;
			*pid = atoi(*cmd);
		}else if (!compare_str(*cmd,"-ppid")){
  38:	00001a97          	auipc	s5,0x1
  3c:	e40a8a93          	addi	s5,s5,-448 # e78 <get_time_perf+0x6e>
			cmd++;
			*ppid = atoi(*cmd);

		}else if (!compare_str(*cmd,"-stat")){
  40:	00001b97          	auipc	s7,0x1
  44:	e40b8b93          	addi	s7,s7,-448 # e80 <get_time_perf+0x76>
				*status=USED;
			else{
				printf("[ERR] Invalid process state\n");
				exit(0);
			}
		}else if(!compare_str(*cmd,"-name")){
  48:	00001d17          	auipc	s10,0x1
  4c:	e90d0d13          	addi	s10,s10,-368 # ed8 <get_time_perf+0xce>
			if (!compare_str_ic(*cmd,"sleeping"))
  50:	00001c97          	auipc	s9,0x1
  54:	e38c8c93          	addi	s9,s9,-456 # e88 <get_time_perf+0x7e>
			else if(!compare_str_ic(*cmd,"running"))
  58:	00001d97          	auipc	s11,0x1
  5c:	e40d8d93          	addi	s11,s11,-448 # e98 <get_time_perf+0x8e>
  60:	a035                	j	8c <parse_cmd+0x8c>
		}else if (!compare_str(*cmd,"-ppid")){
  62:	85d6                	mv	a1,s5
  64:	6088                	ld	a0,0(s1)
  66:	00001097          	auipc	ra,0x1
  6a:	c0c080e7          	jalr	-1012(ra) # c72 <compare_str>
  6e:	ed1d                	bnez	a0,ac <parse_cmd+0xac>
			cmd++;
  70:	00848913          	addi	s2,s1,8
			*ppid = atoi(*cmd);
  74:	6488                	ld	a0,8(s1)
  76:	00000097          	auipc	ra,0x0
  7a:	2fe080e7          	jalr	766(ra) # 374 <atoi>
  7e:	00ab2023          	sw	a0,0(s6)
			cmd++;
			*name = *cmd;
		}
		cmd++;
  82:	00890493          	addi	s1,s2,8
	while(*cmd){
  86:	00893503          	ld	a0,8(s2)
  8a:	c575                	beqz	a0,176 <parse_cmd+0x176>
		if (!compare_str(*cmd,"-pid")){
  8c:	85ce                	mv	a1,s3
  8e:	00001097          	auipc	ra,0x1
  92:	be4080e7          	jalr	-1052(ra) # c72 <compare_str>
  96:	f571                	bnez	a0,62 <parse_cmd+0x62>
			cmd++;
  98:	00848913          	addi	s2,s1,8
			*pid = atoi(*cmd);
  9c:	6488                	ld	a0,8(s1)
  9e:	00000097          	auipc	ra,0x0
  a2:	2d6080e7          	jalr	726(ra) # 374 <atoi>
  a6:	00aa2023          	sw	a0,0(s4)
  aa:	bfe1                	j	82 <parse_cmd+0x82>
		}else if (!compare_str(*cmd,"-stat")){
  ac:	85de                	mv	a1,s7
  ae:	6088                	ld	a0,0(s1)
  b0:	00001097          	auipc	ra,0x1
  b4:	bc2080e7          	jalr	-1086(ra) # c72 <compare_str>
  b8:	e145                	bnez	a0,158 <parse_cmd+0x158>
			cmd++;
  ba:	00848913          	addi	s2,s1,8
			if (!compare_str_ic(*cmd,"sleeping"))
  be:	85e6                	mv	a1,s9
  c0:	6488                	ld	a0,8(s1)
  c2:	00001097          	auipc	ra,0x1
  c6:	bde080e7          	jalr	-1058(ra) # ca0 <compare_str_ic>
  ca:	e509                	bnez	a0,d4 <parse_cmd+0xd4>
				*status=SLEEPING;
  cc:	4789                	li	a5,2
  ce:	00fc2023          	sw	a5,0(s8)
  d2:	bf45                	j	82 <parse_cmd+0x82>
			else if(!compare_str_ic(*cmd,"running"))
  d4:	85ee                	mv	a1,s11
  d6:	6488                	ld	a0,8(s1)
  d8:	00001097          	auipc	ra,0x1
  dc:	bc8080e7          	jalr	-1080(ra) # ca0 <compare_str_ic>
  e0:	e509                	bnez	a0,ea <parse_cmd+0xea>
				*status=RUNNING;
  e2:	4791                	li	a5,4
  e4:	00fc2023          	sw	a5,0(s8)
  e8:	bf69                	j	82 <parse_cmd+0x82>
			else if(!compare_str_ic(*cmd,"ready"))
  ea:	00001597          	auipc	a1,0x1
  ee:	db658593          	addi	a1,a1,-586 # ea0 <get_time_perf+0x96>
  f2:	6488                	ld	a0,8(s1)
  f4:	00001097          	auipc	ra,0x1
  f8:	bac080e7          	jalr	-1108(ra) # ca0 <compare_str_ic>
  fc:	e509                	bnez	a0,106 <parse_cmd+0x106>
				*status=RUNNABLE;
  fe:	478d                	li	a5,3
 100:	00fc2023          	sw	a5,0(s8)
 104:	bfbd                	j	82 <parse_cmd+0x82>
			else if(!compare_str_ic(*cmd,"zombie"))
 106:	00001597          	auipc	a1,0x1
 10a:	da258593          	addi	a1,a1,-606 # ea8 <get_time_perf+0x9e>
 10e:	6488                	ld	a0,8(s1)
 110:	00001097          	auipc	ra,0x1
 114:	b90080e7          	jalr	-1136(ra) # ca0 <compare_str_ic>
 118:	e509                	bnez	a0,122 <parse_cmd+0x122>
				*status=ZOMBIE;
 11a:	4795                	li	a5,5
 11c:	00fc2023          	sw	a5,0(s8)
 120:	b78d                	j	82 <parse_cmd+0x82>
			else if(!compare_str_ic(*cmd,"used"))
 122:	00001597          	auipc	a1,0x1
 126:	d8e58593          	addi	a1,a1,-626 # eb0 <get_time_perf+0xa6>
 12a:	6488                	ld	a0,8(s1)
 12c:	00001097          	auipc	ra,0x1
 130:	b74080e7          	jalr	-1164(ra) # ca0 <compare_str_ic>
 134:	e509                	bnez	a0,13e <parse_cmd+0x13e>
				*status=USED;
 136:	4785                	li	a5,1
 138:	00fc2023          	sw	a5,0(s8)
 13c:	b799                	j	82 <parse_cmd+0x82>
				printf("[ERR] Invalid process state\n");
 13e:	00001517          	auipc	a0,0x1
 142:	d7a50513          	addi	a0,a0,-646 # eb8 <get_time_perf+0xae>
 146:	00000097          	auipc	ra,0x0
 14a:	6e2080e7          	jalr	1762(ra) # 828 <printf>
				exit(0);
 14e:	4501                	li	a0,0
 150:	00000097          	auipc	ra,0x0
 154:	31e080e7          	jalr	798(ra) # 46e <exit>
		}else if(!compare_str(*cmd,"-name")){
 158:	85ea                	mv	a1,s10
 15a:	6088                	ld	a0,0(s1)
 15c:	00001097          	auipc	ra,0x1
 160:	b16080e7          	jalr	-1258(ra) # c72 <compare_str>
 164:	8926                	mv	s2,s1
 166:	fd11                	bnez	a0,82 <parse_cmd+0x82>
			cmd++;
 168:	00848913          	addi	s2,s1,8
			*name = *cmd;
 16c:	649c                	ld	a5,8(s1)
 16e:	f8843703          	ld	a4,-120(s0)
 172:	e31c                	sd	a5,0(a4)
 174:	b739                	j	82 <parse_cmd+0x82>
	}
}
 176:	70e6                	ld	ra,120(sp)
 178:	7446                	ld	s0,112(sp)
 17a:	74a6                	ld	s1,104(sp)
 17c:	7906                	ld	s2,96(sp)
 17e:	69e6                	ld	s3,88(sp)
 180:	6a46                	ld	s4,80(sp)
 182:	6aa6                	ld	s5,72(sp)
 184:	6b06                	ld	s6,64(sp)
 186:	7be2                	ld	s7,56(sp)
 188:	7c42                	ld	s8,48(sp)
 18a:	7ca2                	ld	s9,40(sp)
 18c:	7d02                	ld	s10,32(sp)
 18e:	6de2                	ld	s11,24(sp)
 190:	6109                	addi	sp,sp,128
 192:	8082                	ret

0000000000000194 <main>:
int main(int argc, char **argv){
 194:	7179                	addi	sp,sp,-48
 196:	f406                	sd	ra,40(sp)
 198:	f022                	sd	s0,32(sp)
 19a:	1800                	addi	s0,sp,48
 19c:	852e                	mv	a0,a1
	char * pName = NULL;
 19e:	fe043423          	sd	zero,-24(s0)
	int status = -1;
 1a2:	57fd                	li	a5,-1
 1a4:	fef42223          	sw	a5,-28(s0)
	int pid = -1;
 1a8:	fef42023          	sw	a5,-32(s0)
	int ppid = -1;
 1ac:	fcf42e23          	sw	a5,-36(s0)
	parse_cmd(argv, &pid, &ppid, &pName, &status);
 1b0:	fe440713          	addi	a4,s0,-28
 1b4:	fe840693          	addi	a3,s0,-24
 1b8:	fdc40613          	addi	a2,s0,-36
 1bc:	fe040593          	addi	a1,s0,-32
 1c0:	00000097          	auipc	ra,0x0
 1c4:	e40080e7          	jalr	-448(ra) # 0 <parse_cmd>
	ps(pid, ppid, status, pName);
 1c8:	fe843683          	ld	a3,-24(s0)
 1cc:	fe442603          	lw	a2,-28(s0)
 1d0:	fdc42583          	lw	a1,-36(s0)
 1d4:	fe042503          	lw	a0,-32(s0)
 1d8:	00000097          	auipc	ra,0x0
 1dc:	346080e7          	jalr	838(ra) # 51e <ps>
}
 1e0:	70a2                	ld	ra,40(sp)
 1e2:	7402                	ld	s0,32(sp)
 1e4:	6145                	addi	sp,sp,48
 1e6:	8082                	ret

00000000000001e8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e406                	sd	ra,8(sp)
 1ec:	e022                	sd	s0,0(sp)
 1ee:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1f0:	00000097          	auipc	ra,0x0
 1f4:	fa4080e7          	jalr	-92(ra) # 194 <main>
  exit(0);
 1f8:	4501                	li	a0,0
 1fa:	00000097          	auipc	ra,0x0
 1fe:	274080e7          	jalr	628(ra) # 46e <exit>

0000000000000202 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 208:	87aa                	mv	a5,a0
 20a:	0585                	addi	a1,a1,1
 20c:	0785                	addi	a5,a5,1
 20e:	fff5c703          	lbu	a4,-1(a1)
 212:	fee78fa3          	sb	a4,-1(a5)
 216:	fb75                	bnez	a4,20a <strcpy+0x8>
    ;
  return os;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret

000000000000021e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 224:	00054783          	lbu	a5,0(a0)
 228:	cb91                	beqz	a5,23c <strcmp+0x1e>
 22a:	0005c703          	lbu	a4,0(a1)
 22e:	00f71763          	bne	a4,a5,23c <strcmp+0x1e>
    p++, q++;
 232:	0505                	addi	a0,a0,1
 234:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 236:	00054783          	lbu	a5,0(a0)
 23a:	fbe5                	bnez	a5,22a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 23c:	0005c503          	lbu	a0,0(a1)
}
 240:	40a7853b          	subw	a0,a5,a0
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret

000000000000024a <strlen>:

uint
strlen(const char *s)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 250:	00054783          	lbu	a5,0(a0)
 254:	cf91                	beqz	a5,270 <strlen+0x26>
 256:	0505                	addi	a0,a0,1
 258:	87aa                	mv	a5,a0
 25a:	4685                	li	a3,1
 25c:	9e89                	subw	a3,a3,a0
 25e:	00f6853b          	addw	a0,a3,a5
 262:	0785                	addi	a5,a5,1
 264:	fff7c703          	lbu	a4,-1(a5)
 268:	fb7d                	bnez	a4,25e <strlen+0x14>
    ;
  return n;
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
  for(n = 0; s[n]; n++)
 270:	4501                	li	a0,0
 272:	bfe5                	j	26a <strlen+0x20>

0000000000000274 <memset>:

void*
memset(void *dst, int c, uint n)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 27a:	ca19                	beqz	a2,290 <memset+0x1c>
 27c:	87aa                	mv	a5,a0
 27e:	1602                	slli	a2,a2,0x20
 280:	9201                	srli	a2,a2,0x20
 282:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 286:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 28a:	0785                	addi	a5,a5,1
 28c:	fee79de3          	bne	a5,a4,286 <memset+0x12>
  }
  return dst;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <strchr>:

char*
strchr(const char *s, char c)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	cb99                	beqz	a5,2b6 <strchr+0x20>
    if(*s == c)
 2a2:	00f58763          	beq	a1,a5,2b0 <strchr+0x1a>
  for(; *s; s++)
 2a6:	0505                	addi	a0,a0,1
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	fbfd                	bnez	a5,2a2 <strchr+0xc>
      return (char*)s;
  return 0;
 2ae:	4501                	li	a0,0
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
  return 0;
 2b6:	4501                	li	a0,0
 2b8:	bfe5                	j	2b0 <strchr+0x1a>

00000000000002ba <gets>:

char*
gets(char *buf, int max)
{
 2ba:	711d                	addi	sp,sp,-96
 2bc:	ec86                	sd	ra,88(sp)
 2be:	e8a2                	sd	s0,80(sp)
 2c0:	e4a6                	sd	s1,72(sp)
 2c2:	e0ca                	sd	s2,64(sp)
 2c4:	fc4e                	sd	s3,56(sp)
 2c6:	f852                	sd	s4,48(sp)
 2c8:	f456                	sd	s5,40(sp)
 2ca:	f05a                	sd	s6,32(sp)
 2cc:	ec5e                	sd	s7,24(sp)
 2ce:	1080                	addi	s0,sp,96
 2d0:	8baa                	mv	s7,a0
 2d2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d4:	892a                	mv	s2,a0
 2d6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d8:	4aa9                	li	s5,10
 2da:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2dc:	89a6                	mv	s3,s1
 2de:	2485                	addiw	s1,s1,1
 2e0:	0344d863          	bge	s1,s4,310 <gets+0x56>
    cc = read(0, &c, 1);
 2e4:	4605                	li	a2,1
 2e6:	faf40593          	addi	a1,s0,-81
 2ea:	4501                	li	a0,0
 2ec:	00000097          	auipc	ra,0x0
 2f0:	19a080e7          	jalr	410(ra) # 486 <read>
    if(cc < 1)
 2f4:	00a05e63          	blez	a0,310 <gets+0x56>
    buf[i++] = c;
 2f8:	faf44783          	lbu	a5,-81(s0)
 2fc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 300:	01578763          	beq	a5,s5,30e <gets+0x54>
 304:	0905                	addi	s2,s2,1
 306:	fd679be3          	bne	a5,s6,2dc <gets+0x22>
  for(i=0; i+1 < max; ){
 30a:	89a6                	mv	s3,s1
 30c:	a011                	j	310 <gets+0x56>
 30e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 310:	99de                	add	s3,s3,s7
 312:	00098023          	sb	zero,0(s3)
  return buf;
}
 316:	855e                	mv	a0,s7
 318:	60e6                	ld	ra,88(sp)
 31a:	6446                	ld	s0,80(sp)
 31c:	64a6                	ld	s1,72(sp)
 31e:	6906                	ld	s2,64(sp)
 320:	79e2                	ld	s3,56(sp)
 322:	7a42                	ld	s4,48(sp)
 324:	7aa2                	ld	s5,40(sp)
 326:	7b02                	ld	s6,32(sp)
 328:	6be2                	ld	s7,24(sp)
 32a:	6125                	addi	sp,sp,96
 32c:	8082                	ret

000000000000032e <stat>:

int
stat(const char *n, struct stat *st)
{
 32e:	1101                	addi	sp,sp,-32
 330:	ec06                	sd	ra,24(sp)
 332:	e822                	sd	s0,16(sp)
 334:	e426                	sd	s1,8(sp)
 336:	e04a                	sd	s2,0(sp)
 338:	1000                	addi	s0,sp,32
 33a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33c:	4581                	li	a1,0
 33e:	00000097          	auipc	ra,0x0
 342:	170080e7          	jalr	368(ra) # 4ae <open>
  if(fd < 0)
 346:	02054563          	bltz	a0,370 <stat+0x42>
 34a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 34c:	85ca                	mv	a1,s2
 34e:	00000097          	auipc	ra,0x0
 352:	178080e7          	jalr	376(ra) # 4c6 <fstat>
 356:	892a                	mv	s2,a0
  close(fd);
 358:	8526                	mv	a0,s1
 35a:	00000097          	auipc	ra,0x0
 35e:	13c080e7          	jalr	316(ra) # 496 <close>
  return r;
}
 362:	854a                	mv	a0,s2
 364:	60e2                	ld	ra,24(sp)
 366:	6442                	ld	s0,16(sp)
 368:	64a2                	ld	s1,8(sp)
 36a:	6902                	ld	s2,0(sp)
 36c:	6105                	addi	sp,sp,32
 36e:	8082                	ret
    return -1;
 370:	597d                	li	s2,-1
 372:	bfc5                	j	362 <stat+0x34>

0000000000000374 <atoi>:

int
atoi(const char *s)
{
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 37a:	00054683          	lbu	a3,0(a0)
 37e:	fd06879b          	addiw	a5,a3,-48
 382:	0ff7f793          	zext.b	a5,a5
 386:	4625                	li	a2,9
 388:	02f66863          	bltu	a2,a5,3b8 <atoi+0x44>
 38c:	872a                	mv	a4,a0
  n = 0;
 38e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 390:	0705                	addi	a4,a4,1
 392:	0025179b          	slliw	a5,a0,0x2
 396:	9fa9                	addw	a5,a5,a0
 398:	0017979b          	slliw	a5,a5,0x1
 39c:	9fb5                	addw	a5,a5,a3
 39e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3a2:	00074683          	lbu	a3,0(a4)
 3a6:	fd06879b          	addiw	a5,a3,-48
 3aa:	0ff7f793          	zext.b	a5,a5
 3ae:	fef671e3          	bgeu	a2,a5,390 <atoi+0x1c>
  return n;
}
 3b2:	6422                	ld	s0,8(sp)
 3b4:	0141                	addi	sp,sp,16
 3b6:	8082                	ret
  n = 0;
 3b8:	4501                	li	a0,0
 3ba:	bfe5                	j	3b2 <atoi+0x3e>

00000000000003bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e422                	sd	s0,8(sp)
 3c0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c2:	02b57463          	bgeu	a0,a1,3ea <memmove+0x2e>
    while(n-- > 0)
 3c6:	00c05f63          	blez	a2,3e4 <memmove+0x28>
 3ca:	1602                	slli	a2,a2,0x20
 3cc:	9201                	srli	a2,a2,0x20
 3ce:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d2:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d4:	0585                	addi	a1,a1,1
 3d6:	0705                	addi	a4,a4,1
 3d8:	fff5c683          	lbu	a3,-1(a1)
 3dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3e0:	fee79ae3          	bne	a5,a4,3d4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e4:	6422                	ld	s0,8(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret
    dst += n;
 3ea:	00c50733          	add	a4,a0,a2
    src += n;
 3ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3f0:	fec05ae3          	blez	a2,3e4 <memmove+0x28>
 3f4:	fff6079b          	addiw	a5,a2,-1
 3f8:	1782                	slli	a5,a5,0x20
 3fa:	9381                	srli	a5,a5,0x20
 3fc:	fff7c793          	not	a5,a5
 400:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 402:	15fd                	addi	a1,a1,-1
 404:	177d                	addi	a4,a4,-1
 406:	0005c683          	lbu	a3,0(a1)
 40a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 40e:	fee79ae3          	bne	a5,a4,402 <memmove+0x46>
 412:	bfc9                	j	3e4 <memmove+0x28>

0000000000000414 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 41a:	ca05                	beqz	a2,44a <memcmp+0x36>
 41c:	fff6069b          	addiw	a3,a2,-1
 420:	1682                	slli	a3,a3,0x20
 422:	9281                	srli	a3,a3,0x20
 424:	0685                	addi	a3,a3,1
 426:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 428:	00054783          	lbu	a5,0(a0)
 42c:	0005c703          	lbu	a4,0(a1)
 430:	00e79863          	bne	a5,a4,440 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 434:	0505                	addi	a0,a0,1
    p2++;
 436:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 438:	fed518e3          	bne	a0,a3,428 <memcmp+0x14>
  }
  return 0;
 43c:	4501                	li	a0,0
 43e:	a019                	j	444 <memcmp+0x30>
      return *p1 - *p2;
 440:	40e7853b          	subw	a0,a5,a4
}
 444:	6422                	ld	s0,8(sp)
 446:	0141                	addi	sp,sp,16
 448:	8082                	ret
  return 0;
 44a:	4501                	li	a0,0
 44c:	bfe5                	j	444 <memcmp+0x30>

000000000000044e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 44e:	1141                	addi	sp,sp,-16
 450:	e406                	sd	ra,8(sp)
 452:	e022                	sd	s0,0(sp)
 454:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 456:	00000097          	auipc	ra,0x0
 45a:	f66080e7          	jalr	-154(ra) # 3bc <memmove>
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret

0000000000000466 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 466:	4885                	li	a7,1
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <exit>:
.global exit
exit:
 li a7, SYS_exit
 46e:	4889                	li	a7,2
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <wait>:
.global wait
wait:
 li a7, SYS_wait
 476:	488d                	li	a7,3
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 47e:	4891                	li	a7,4
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <read>:
.global read
read:
 li a7, SYS_read
 486:	4895                	li	a7,5
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <write>:
.global write
write:
 li a7, SYS_write
 48e:	48c1                	li	a7,16
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <close>:
.global close
close:
 li a7, SYS_close
 496:	48d5                	li	a7,21
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <kill>:
.global kill
kill:
 li a7, SYS_kill
 49e:	4899                	li	a7,6
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a6:	489d                	li	a7,7
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <open>:
.global open
open:
 li a7, SYS_open
 4ae:	48bd                	li	a7,15
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b6:	48c5                	li	a7,17
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4be:	48c9                	li	a7,18
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c6:	48a1                	li	a7,8
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <link>:
.global link
link:
 li a7, SYS_link
 4ce:	48cd                	li	a7,19
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d6:	48d1                	li	a7,20
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4de:	48a5                	li	a7,9
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e6:	48a9                	li	a7,10
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ee:	48ad                	li	a7,11
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f6:	48b1                	li	a7,12
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4fe:	48b5                	li	a7,13
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 506:	48b9                	li	a7,14
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <head>:
.global head
head:
 li a7, SYS_head
 50e:	48d9                	li	a7,22
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 516:	48dd                	li	a7,23
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <ps>:
.global ps
ps:
 li a7, SYS_ps
 51e:	48e1                	li	a7,24
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <times>:
.global times
times:
 li a7, SYS_times
 526:	48e5                	li	a7,25
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 52e:	48e9                	li	a7,26
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
 536:	48ed                	li	a7,27
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
 53e:	48f1                	li	a7,28
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
 546:	48f5                	li	a7,29
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 54e:	1101                	addi	sp,sp,-32
 550:	ec06                	sd	ra,24(sp)
 552:	e822                	sd	s0,16(sp)
 554:	1000                	addi	s0,sp,32
 556:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 55a:	4605                	li	a2,1
 55c:	fef40593          	addi	a1,s0,-17
 560:	00000097          	auipc	ra,0x0
 564:	f2e080e7          	jalr	-210(ra) # 48e <write>
}
 568:	60e2                	ld	ra,24(sp)
 56a:	6442                	ld	s0,16(sp)
 56c:	6105                	addi	sp,sp,32
 56e:	8082                	ret

0000000000000570 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 570:	7139                	addi	sp,sp,-64
 572:	fc06                	sd	ra,56(sp)
 574:	f822                	sd	s0,48(sp)
 576:	f426                	sd	s1,40(sp)
 578:	f04a                	sd	s2,32(sp)
 57a:	ec4e                	sd	s3,24(sp)
 57c:	0080                	addi	s0,sp,64
 57e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 580:	c299                	beqz	a3,586 <printint+0x16>
 582:	0805c963          	bltz	a1,614 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 586:	2581                	sext.w	a1,a1
  neg = 0;
 588:	4881                	li	a7,0
 58a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 58e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 590:	2601                	sext.w	a2,a2
 592:	00001517          	auipc	a0,0x1
 596:	9ae50513          	addi	a0,a0,-1618 # f40 <digits>
 59a:	883a                	mv	a6,a4
 59c:	2705                	addiw	a4,a4,1
 59e:	02c5f7bb          	remuw	a5,a1,a2
 5a2:	1782                	slli	a5,a5,0x20
 5a4:	9381                	srli	a5,a5,0x20
 5a6:	97aa                	add	a5,a5,a0
 5a8:	0007c783          	lbu	a5,0(a5)
 5ac:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b0:	0005879b          	sext.w	a5,a1
 5b4:	02c5d5bb          	divuw	a1,a1,a2
 5b8:	0685                	addi	a3,a3,1
 5ba:	fec7f0e3          	bgeu	a5,a2,59a <printint+0x2a>
  if(neg)
 5be:	00088c63          	beqz	a7,5d6 <printint+0x66>
    buf[i++] = '-';
 5c2:	fd070793          	addi	a5,a4,-48
 5c6:	00878733          	add	a4,a5,s0
 5ca:	02d00793          	li	a5,45
 5ce:	fef70823          	sb	a5,-16(a4)
 5d2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5d6:	02e05863          	blez	a4,606 <printint+0x96>
 5da:	fc040793          	addi	a5,s0,-64
 5de:	00e78933          	add	s2,a5,a4
 5e2:	fff78993          	addi	s3,a5,-1
 5e6:	99ba                	add	s3,s3,a4
 5e8:	377d                	addiw	a4,a4,-1
 5ea:	1702                	slli	a4,a4,0x20
 5ec:	9301                	srli	a4,a4,0x20
 5ee:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5f2:	fff94583          	lbu	a1,-1(s2)
 5f6:	8526                	mv	a0,s1
 5f8:	00000097          	auipc	ra,0x0
 5fc:	f56080e7          	jalr	-170(ra) # 54e <putc>
  while(--i >= 0)
 600:	197d                	addi	s2,s2,-1
 602:	ff3918e3          	bne	s2,s3,5f2 <printint+0x82>
}
 606:	70e2                	ld	ra,56(sp)
 608:	7442                	ld	s0,48(sp)
 60a:	74a2                	ld	s1,40(sp)
 60c:	7902                	ld	s2,32(sp)
 60e:	69e2                	ld	s3,24(sp)
 610:	6121                	addi	sp,sp,64
 612:	8082                	ret
    x = -xx;
 614:	40b005bb          	negw	a1,a1
    neg = 1;
 618:	4885                	li	a7,1
    x = -xx;
 61a:	bf85                	j	58a <printint+0x1a>

000000000000061c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 61c:	7119                	addi	sp,sp,-128
 61e:	fc86                	sd	ra,120(sp)
 620:	f8a2                	sd	s0,112(sp)
 622:	f4a6                	sd	s1,104(sp)
 624:	f0ca                	sd	s2,96(sp)
 626:	ecce                	sd	s3,88(sp)
 628:	e8d2                	sd	s4,80(sp)
 62a:	e4d6                	sd	s5,72(sp)
 62c:	e0da                	sd	s6,64(sp)
 62e:	fc5e                	sd	s7,56(sp)
 630:	f862                	sd	s8,48(sp)
 632:	f466                	sd	s9,40(sp)
 634:	f06a                	sd	s10,32(sp)
 636:	ec6e                	sd	s11,24(sp)
 638:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 63a:	0005c903          	lbu	s2,0(a1)
 63e:	18090f63          	beqz	s2,7dc <vprintf+0x1c0>
 642:	8aaa                	mv	s5,a0
 644:	8b32                	mv	s6,a2
 646:	00158493          	addi	s1,a1,1
  state = 0;
 64a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 64c:	02500a13          	li	s4,37
 650:	4c55                	li	s8,21
 652:	00001c97          	auipc	s9,0x1
 656:	896c8c93          	addi	s9,s9,-1898 # ee8 <get_time_perf+0xde>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 65a:	02800d93          	li	s11,40
  putc(fd, 'x');
 65e:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 660:	00001b97          	auipc	s7,0x1
 664:	8e0b8b93          	addi	s7,s7,-1824 # f40 <digits>
 668:	a839                	j	686 <vprintf+0x6a>
        putc(fd, c);
 66a:	85ca                	mv	a1,s2
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	ee0080e7          	jalr	-288(ra) # 54e <putc>
 676:	a019                	j	67c <vprintf+0x60>
    } else if(state == '%'){
 678:	01498d63          	beq	s3,s4,692 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 67c:	0485                	addi	s1,s1,1
 67e:	fff4c903          	lbu	s2,-1(s1)
 682:	14090d63          	beqz	s2,7dc <vprintf+0x1c0>
    if(state == 0){
 686:	fe0999e3          	bnez	s3,678 <vprintf+0x5c>
      if(c == '%'){
 68a:	ff4910e3          	bne	s2,s4,66a <vprintf+0x4e>
        state = '%';
 68e:	89d2                	mv	s3,s4
 690:	b7f5                	j	67c <vprintf+0x60>
      if(c == 'd'){
 692:	11490c63          	beq	s2,s4,7aa <vprintf+0x18e>
 696:	f9d9079b          	addiw	a5,s2,-99
 69a:	0ff7f793          	zext.b	a5,a5
 69e:	10fc6e63          	bltu	s8,a5,7ba <vprintf+0x19e>
 6a2:	f9d9079b          	addiw	a5,s2,-99
 6a6:	0ff7f713          	zext.b	a4,a5
 6aa:	10ec6863          	bltu	s8,a4,7ba <vprintf+0x19e>
 6ae:	00271793          	slli	a5,a4,0x2
 6b2:	97e6                	add	a5,a5,s9
 6b4:	439c                	lw	a5,0(a5)
 6b6:	97e6                	add	a5,a5,s9
 6b8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6ba:	008b0913          	addi	s2,s6,8
 6be:	4685                	li	a3,1
 6c0:	4629                	li	a2,10
 6c2:	000b2583          	lw	a1,0(s6)
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	ea8080e7          	jalr	-344(ra) # 570 <printint>
 6d0:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b765                	j	67c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d6:	008b0913          	addi	s2,s6,8
 6da:	4681                	li	a3,0
 6dc:	4629                	li	a2,10
 6de:	000b2583          	lw	a1,0(s6)
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	e8c080e7          	jalr	-372(ra) # 570 <printint>
 6ec:	8b4a                	mv	s6,s2
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b771                	j	67c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6f2:	008b0913          	addi	s2,s6,8
 6f6:	4681                	li	a3,0
 6f8:	866a                	mv	a2,s10
 6fa:	000b2583          	lw	a1,0(s6)
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	e70080e7          	jalr	-400(ra) # 570 <printint>
 708:	8b4a                	mv	s6,s2
      state = 0;
 70a:	4981                	li	s3,0
 70c:	bf85                	j	67c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 70e:	008b0793          	addi	a5,s6,8
 712:	f8f43423          	sd	a5,-120(s0)
 716:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 71a:	03000593          	li	a1,48
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	e2e080e7          	jalr	-466(ra) # 54e <putc>
  putc(fd, 'x');
 728:	07800593          	li	a1,120
 72c:	8556                	mv	a0,s5
 72e:	00000097          	auipc	ra,0x0
 732:	e20080e7          	jalr	-480(ra) # 54e <putc>
 736:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 738:	03c9d793          	srli	a5,s3,0x3c
 73c:	97de                	add	a5,a5,s7
 73e:	0007c583          	lbu	a1,0(a5)
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	e0a080e7          	jalr	-502(ra) # 54e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 74c:	0992                	slli	s3,s3,0x4
 74e:	397d                	addiw	s2,s2,-1
 750:	fe0914e3          	bnez	s2,738 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 754:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 758:	4981                	li	s3,0
 75a:	b70d                	j	67c <vprintf+0x60>
        s = va_arg(ap, char*);
 75c:	008b0913          	addi	s2,s6,8
 760:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 764:	02098163          	beqz	s3,786 <vprintf+0x16a>
        while(*s != 0){
 768:	0009c583          	lbu	a1,0(s3)
 76c:	c5ad                	beqz	a1,7d6 <vprintf+0x1ba>
          putc(fd, *s);
 76e:	8556                	mv	a0,s5
 770:	00000097          	auipc	ra,0x0
 774:	dde080e7          	jalr	-546(ra) # 54e <putc>
          s++;
 778:	0985                	addi	s3,s3,1
        while(*s != 0){
 77a:	0009c583          	lbu	a1,0(s3)
 77e:	f9e5                	bnez	a1,76e <vprintf+0x152>
        s = va_arg(ap, char*);
 780:	8b4a                	mv	s6,s2
      state = 0;
 782:	4981                	li	s3,0
 784:	bde5                	j	67c <vprintf+0x60>
          s = "(null)";
 786:	00000997          	auipc	s3,0x0
 78a:	75a98993          	addi	s3,s3,1882 # ee0 <get_time_perf+0xd6>
        while(*s != 0){
 78e:	85ee                	mv	a1,s11
 790:	bff9                	j	76e <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 792:	008b0913          	addi	s2,s6,8
 796:	000b4583          	lbu	a1,0(s6)
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	db2080e7          	jalr	-590(ra) # 54e <putc>
 7a4:	8b4a                	mv	s6,s2
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	bdd1                	j	67c <vprintf+0x60>
        putc(fd, c);
 7aa:	85d2                	mv	a1,s4
 7ac:	8556                	mv	a0,s5
 7ae:	00000097          	auipc	ra,0x0
 7b2:	da0080e7          	jalr	-608(ra) # 54e <putc>
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b5d1                	j	67c <vprintf+0x60>
        putc(fd, '%');
 7ba:	85d2                	mv	a1,s4
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	d90080e7          	jalr	-624(ra) # 54e <putc>
        putc(fd, c);
 7c6:	85ca                	mv	a1,s2
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	d84080e7          	jalr	-636(ra) # 54e <putc>
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	b565                	j	67c <vprintf+0x60>
        s = va_arg(ap, char*);
 7d6:	8b4a                	mv	s6,s2
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	b54d                	j	67c <vprintf+0x60>
    }
  }
}
 7dc:	70e6                	ld	ra,120(sp)
 7de:	7446                	ld	s0,112(sp)
 7e0:	74a6                	ld	s1,104(sp)
 7e2:	7906                	ld	s2,96(sp)
 7e4:	69e6                	ld	s3,88(sp)
 7e6:	6a46                	ld	s4,80(sp)
 7e8:	6aa6                	ld	s5,72(sp)
 7ea:	6b06                	ld	s6,64(sp)
 7ec:	7be2                	ld	s7,56(sp)
 7ee:	7c42                	ld	s8,48(sp)
 7f0:	7ca2                	ld	s9,40(sp)
 7f2:	7d02                	ld	s10,32(sp)
 7f4:	6de2                	ld	s11,24(sp)
 7f6:	6109                	addi	sp,sp,128
 7f8:	8082                	ret

00000000000007fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7fa:	715d                	addi	sp,sp,-80
 7fc:	ec06                	sd	ra,24(sp)
 7fe:	e822                	sd	s0,16(sp)
 800:	1000                	addi	s0,sp,32
 802:	e010                	sd	a2,0(s0)
 804:	e414                	sd	a3,8(s0)
 806:	e818                	sd	a4,16(s0)
 808:	ec1c                	sd	a5,24(s0)
 80a:	03043023          	sd	a6,32(s0)
 80e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 812:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 816:	8622                	mv	a2,s0
 818:	00000097          	auipc	ra,0x0
 81c:	e04080e7          	jalr	-508(ra) # 61c <vprintf>
}
 820:	60e2                	ld	ra,24(sp)
 822:	6442                	ld	s0,16(sp)
 824:	6161                	addi	sp,sp,80
 826:	8082                	ret

0000000000000828 <printf>:

void
printf(const char *fmt, ...)
{
 828:	711d                	addi	sp,sp,-96
 82a:	ec06                	sd	ra,24(sp)
 82c:	e822                	sd	s0,16(sp)
 82e:	1000                	addi	s0,sp,32
 830:	e40c                	sd	a1,8(s0)
 832:	e810                	sd	a2,16(s0)
 834:	ec14                	sd	a3,24(s0)
 836:	f018                	sd	a4,32(s0)
 838:	f41c                	sd	a5,40(s0)
 83a:	03043823          	sd	a6,48(s0)
 83e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 842:	00840613          	addi	a2,s0,8
 846:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 84a:	85aa                	mv	a1,a0
 84c:	4505                	li	a0,1
 84e:	00000097          	auipc	ra,0x0
 852:	dce080e7          	jalr	-562(ra) # 61c <vprintf>
}
 856:	60e2                	ld	ra,24(sp)
 858:	6442                	ld	s0,16(sp)
 85a:	6125                	addi	sp,sp,96
 85c:	8082                	ret

000000000000085e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 85e:	1141                	addi	sp,sp,-16
 860:	e422                	sd	s0,8(sp)
 862:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 864:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 868:	00000797          	auipc	a5,0x0
 86c:	7987b783          	ld	a5,1944(a5) # 1000 <freep>
 870:	a02d                	j	89a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 872:	4618                	lw	a4,8(a2)
 874:	9f2d                	addw	a4,a4,a1
 876:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 87a:	6398                	ld	a4,0(a5)
 87c:	6310                	ld	a2,0(a4)
 87e:	a83d                	j	8bc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 880:	ff852703          	lw	a4,-8(a0)
 884:	9f31                	addw	a4,a4,a2
 886:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 888:	ff053683          	ld	a3,-16(a0)
 88c:	a091                	j	8d0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88e:	6398                	ld	a4,0(a5)
 890:	00e7e463          	bltu	a5,a4,898 <free+0x3a>
 894:	00e6ea63          	bltu	a3,a4,8a8 <free+0x4a>
{
 898:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89a:	fed7fae3          	bgeu	a5,a3,88e <free+0x30>
 89e:	6398                	ld	a4,0(a5)
 8a0:	00e6e463          	bltu	a3,a4,8a8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a4:	fee7eae3          	bltu	a5,a4,898 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8a8:	ff852583          	lw	a1,-8(a0)
 8ac:	6390                	ld	a2,0(a5)
 8ae:	02059813          	slli	a6,a1,0x20
 8b2:	01c85713          	srli	a4,a6,0x1c
 8b6:	9736                	add	a4,a4,a3
 8b8:	fae60de3          	beq	a2,a4,872 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8bc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8c0:	4790                	lw	a2,8(a5)
 8c2:	02061593          	slli	a1,a2,0x20
 8c6:	01c5d713          	srli	a4,a1,0x1c
 8ca:	973e                	add	a4,a4,a5
 8cc:	fae68ae3          	beq	a3,a4,880 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8d0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8d2:	00000717          	auipc	a4,0x0
 8d6:	72f73723          	sd	a5,1838(a4) # 1000 <freep>
}
 8da:	6422                	ld	s0,8(sp)
 8dc:	0141                	addi	sp,sp,16
 8de:	8082                	ret

00000000000008e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e0:	7139                	addi	sp,sp,-64
 8e2:	fc06                	sd	ra,56(sp)
 8e4:	f822                	sd	s0,48(sp)
 8e6:	f426                	sd	s1,40(sp)
 8e8:	f04a                	sd	s2,32(sp)
 8ea:	ec4e                	sd	s3,24(sp)
 8ec:	e852                	sd	s4,16(sp)
 8ee:	e456                	sd	s5,8(sp)
 8f0:	e05a                	sd	s6,0(sp)
 8f2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f4:	02051493          	slli	s1,a0,0x20
 8f8:	9081                	srli	s1,s1,0x20
 8fa:	04bd                	addi	s1,s1,15
 8fc:	8091                	srli	s1,s1,0x4
 8fe:	0014899b          	addiw	s3,s1,1
 902:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 904:	00000517          	auipc	a0,0x0
 908:	6fc53503          	ld	a0,1788(a0) # 1000 <freep>
 90c:	c515                	beqz	a0,938 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 910:	4798                	lw	a4,8(a5)
 912:	02977f63          	bgeu	a4,s1,950 <malloc+0x70>
 916:	8a4e                	mv	s4,s3
 918:	0009871b          	sext.w	a4,s3
 91c:	6685                	lui	a3,0x1
 91e:	00d77363          	bgeu	a4,a3,924 <malloc+0x44>
 922:	6a05                	lui	s4,0x1
 924:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 928:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 92c:	00000917          	auipc	s2,0x0
 930:	6d490913          	addi	s2,s2,1748 # 1000 <freep>
  if(p == (char*)-1)
 934:	5afd                	li	s5,-1
 936:	a895                	j	9aa <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 938:	00000797          	auipc	a5,0x0
 93c:	6d878793          	addi	a5,a5,1752 # 1010 <base>
 940:	00000717          	auipc	a4,0x0
 944:	6cf73023          	sd	a5,1728(a4) # 1000 <freep>
 948:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 94e:	b7e1                	j	916 <malloc+0x36>
      if(p->s.size == nunits)
 950:	02e48c63          	beq	s1,a4,988 <malloc+0xa8>
        p->s.size -= nunits;
 954:	4137073b          	subw	a4,a4,s3
 958:	c798                	sw	a4,8(a5)
        p += p->s.size;
 95a:	02071693          	slli	a3,a4,0x20
 95e:	01c6d713          	srli	a4,a3,0x1c
 962:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 964:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 968:	00000717          	auipc	a4,0x0
 96c:	68a73c23          	sd	a0,1688(a4) # 1000 <freep>
      return (void*)(p + 1);
 970:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 974:	70e2                	ld	ra,56(sp)
 976:	7442                	ld	s0,48(sp)
 978:	74a2                	ld	s1,40(sp)
 97a:	7902                	ld	s2,32(sp)
 97c:	69e2                	ld	s3,24(sp)
 97e:	6a42                	ld	s4,16(sp)
 980:	6aa2                	ld	s5,8(sp)
 982:	6b02                	ld	s6,0(sp)
 984:	6121                	addi	sp,sp,64
 986:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 988:	6398                	ld	a4,0(a5)
 98a:	e118                	sd	a4,0(a0)
 98c:	bff1                	j	968 <malloc+0x88>
  hp->s.size = nu;
 98e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 992:	0541                	addi	a0,a0,16
 994:	00000097          	auipc	ra,0x0
 998:	eca080e7          	jalr	-310(ra) # 85e <free>
  return freep;
 99c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9a0:	d971                	beqz	a0,974 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a4:	4798                	lw	a4,8(a5)
 9a6:	fa9775e3          	bgeu	a4,s1,950 <malloc+0x70>
    if(p == freep)
 9aa:	00093703          	ld	a4,0(s2)
 9ae:	853e                	mv	a0,a5
 9b0:	fef719e3          	bne	a4,a5,9a2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9b4:	8552                	mv	a0,s4
 9b6:	00000097          	auipc	ra,0x0
 9ba:	b40080e7          	jalr	-1216(ra) # 4f6 <sbrk>
  if(p == (char*)-1)
 9be:	fd5518e3          	bne	a0,s5,98e <malloc+0xae>
        return 0;
 9c2:	4501                	li	a0,0
 9c4:	bf45                	j	974 <malloc+0x94>

00000000000009c6 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 9c6:	c1d9                	beqz	a1,a4c <head_run+0x86>
void head_run(int fd, int numOfLines){
 9c8:	dd010113          	addi	sp,sp,-560
 9cc:	22113423          	sd	ra,552(sp)
 9d0:	22813023          	sd	s0,544(sp)
 9d4:	20913c23          	sd	s1,536(sp)
 9d8:	21213823          	sd	s2,528(sp)
 9dc:	21313423          	sd	s3,520(sp)
 9e0:	21413023          	sd	s4,512(sp)
 9e4:	1c00                	addi	s0,sp,560
 9e6:	892a                	mv	s2,a0
 9e8:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 9ec:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 9ee:	00000a17          	auipc	s4,0x0
 9f2:	592a0a13          	addi	s4,s4,1426 # f80 <digits+0x40>
		readStatus = read_line(fd, line);
 9f6:	dd840593          	addi	a1,s0,-552
 9fa:	854a                	mv	a0,s2
 9fc:	00000097          	auipc	ra,0x0
 a00:	394080e7          	jalr	916(ra) # d90 <read_line>
		if (readStatus == READ_ERROR){
 a04:	01350d63          	beq	a0,s3,a1e <head_run+0x58>
		if (readStatus == READ_EOF)
 a08:	c11d                	beqz	a0,a2e <head_run+0x68>
		printf("%s",line);
 a0a:	dd840593          	addi	a1,s0,-552
 a0e:	8552                	mv	a0,s4
 a10:	00000097          	auipc	ra,0x0
 a14:	e18080e7          	jalr	-488(ra) # 828 <printf>
	while(numOfLines--){
 a18:	34fd                	addiw	s1,s1,-1
 a1a:	fcf1                	bnez	s1,9f6 <head_run+0x30>
 a1c:	a809                	j	a2e <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 a1e:	00000517          	auipc	a0,0x0
 a22:	53a50513          	addi	a0,a0,1338 # f58 <digits+0x18>
 a26:	00000097          	auipc	ra,0x0
 a2a:	e02080e7          	jalr	-510(ra) # 828 <printf>

	}
}
 a2e:	22813083          	ld	ra,552(sp)
 a32:	22013403          	ld	s0,544(sp)
 a36:	21813483          	ld	s1,536(sp)
 a3a:	21013903          	ld	s2,528(sp)
 a3e:	20813983          	ld	s3,520(sp)
 a42:	20013a03          	ld	s4,512(sp)
 a46:	23010113          	addi	sp,sp,560
 a4a:	8082                	ret
 a4c:	8082                	ret

0000000000000a4e <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 a4e:	ba010113          	addi	sp,sp,-1120
 a52:	44113c23          	sd	ra,1112(sp)
 a56:	44813823          	sd	s0,1104(sp)
 a5a:	44913423          	sd	s1,1096(sp)
 a5e:	45213023          	sd	s2,1088(sp)
 a62:	43313c23          	sd	s3,1080(sp)
 a66:	43413823          	sd	s4,1072(sp)
 a6a:	43513423          	sd	s5,1064(sp)
 a6e:	43613023          	sd	s6,1056(sp)
 a72:	41713c23          	sd	s7,1048(sp)
 a76:	41813823          	sd	s8,1040(sp)
 a7a:	41913423          	sd	s9,1032(sp)
 a7e:	41a13023          	sd	s10,1024(sp)
 a82:	3fb13c23          	sd	s11,1016(sp)
 a86:	46010413          	addi	s0,sp,1120
 a8a:	89aa                	mv	s3,a0
 a8c:	8aae                	mv	s5,a1
 a8e:	8c32                	mv	s8,a2
 a90:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 a92:	d9840593          	addi	a1,s0,-616
 a96:	00000097          	auipc	ra,0x0
 a9a:	2fa080e7          	jalr	762(ra) # d90 <read_line>


  if (readStatus == READ_ERROR)
 a9e:	57fd                	li	a5,-1
 aa0:	04f50163          	beq	a0,a5,ae2 <uniq_run+0x94>
 aa4:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 aa6:	ed21                	bnez	a0,afe <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 aa8:	45813083          	ld	ra,1112(sp)
 aac:	45013403          	ld	s0,1104(sp)
 ab0:	44813483          	ld	s1,1096(sp)
 ab4:	44013903          	ld	s2,1088(sp)
 ab8:	43813983          	ld	s3,1080(sp)
 abc:	43013a03          	ld	s4,1072(sp)
 ac0:	42813a83          	ld	s5,1064(sp)
 ac4:	42013b03          	ld	s6,1056(sp)
 ac8:	41813b83          	ld	s7,1048(sp)
 acc:	41013c03          	ld	s8,1040(sp)
 ad0:	40813c83          	ld	s9,1032(sp)
 ad4:	40013d03          	ld	s10,1024(sp)
 ad8:	3f813d83          	ld	s11,1016(sp)
 adc:	46010113          	addi	sp,sp,1120
 ae0:	8082                	ret
    printf("[ERR] Error reading from the file ");
 ae2:	00000517          	auipc	a0,0x0
 ae6:	4a650513          	addi	a0,a0,1190 # f88 <digits+0x48>
 aea:	00000097          	auipc	ra,0x0
 aee:	d3e080e7          	jalr	-706(ra) # 828 <printf>
 af2:	bf5d                	j	aa8 <uniq_run+0x5a>
 af4:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 af6:	8926                	mv	s2,s1
 af8:	84be                	mv	s1,a5
        lineCount = 1;
 afa:	8b6a                	mv	s6,s10
 afc:	a8ed                	j	bf6 <uniq_run+0x1a8>
    int lineCount=1;
 afe:	4b05                	li	s6,1
  char * line2 = buffer2;
 b00:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 b04:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 b08:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 b0a:	4d05                	li	s10,1
              printf("%s",line1);
 b0c:	00000d97          	auipc	s11,0x0
 b10:	474d8d93          	addi	s11,s11,1140 # f80 <digits+0x40>
 b14:	a0cd                	j	bf6 <uniq_run+0x1a8>
            if (repeatedLines){
 b16:	020a0b63          	beqz	s4,b4c <uniq_run+0xfe>
                if (isRepeated){
 b1a:	f80b87e3          	beqz	s7,aa8 <uniq_run+0x5a>
                    if (showCount)
 b1e:	000c0d63          	beqz	s8,b38 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 b22:	864a                	mv	a2,s2
 b24:	85da                	mv	a1,s6
 b26:	00000517          	auipc	a0,0x0
 b2a:	48a50513          	addi	a0,a0,1162 # fb0 <digits+0x70>
 b2e:	00000097          	auipc	ra,0x0
 b32:	cfa080e7          	jalr	-774(ra) # 828 <printf>
 b36:	bf8d                	j	aa8 <uniq_run+0x5a>
                      printf("%s",line1);
 b38:	85ca                	mv	a1,s2
 b3a:	00000517          	auipc	a0,0x0
 b3e:	44650513          	addi	a0,a0,1094 # f80 <digits+0x40>
 b42:	00000097          	auipc	ra,0x0
 b46:	ce6080e7          	jalr	-794(ra) # 828 <printf>
 b4a:	bfb9                	j	aa8 <uniq_run+0x5a>
                if (showCount)
 b4c:	000c0d63          	beqz	s8,b66 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 b50:	864a                	mv	a2,s2
 b52:	85da                	mv	a1,s6
 b54:	00000517          	auipc	a0,0x0
 b58:	45c50513          	addi	a0,a0,1116 # fb0 <digits+0x70>
 b5c:	00000097          	auipc	ra,0x0
 b60:	ccc080e7          	jalr	-820(ra) # 828 <printf>
 b64:	b791                	j	aa8 <uniq_run+0x5a>
                  printf("%s",line1);
 b66:	85ca                	mv	a1,s2
 b68:	00000517          	auipc	a0,0x0
 b6c:	41850513          	addi	a0,a0,1048 # f80 <digits+0x40>
 b70:	00000097          	auipc	ra,0x0
 b74:	cb8080e7          	jalr	-840(ra) # 828 <printf>
 b78:	bf05                	j	aa8 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 b7a:	00000517          	auipc	a0,0x0
 b7e:	43e50513          	addi	a0,a0,1086 # fb8 <digits+0x78>
 b82:	00000097          	auipc	ra,0x0
 b86:	ca6080e7          	jalr	-858(ra) # 828 <printf>
          break;
 b8a:	bf39                	j	aa8 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 b8c:	85a6                	mv	a1,s1
 b8e:	854a                	mv	a0,s2
 b90:	00000097          	auipc	ra,0x0
 b94:	110080e7          	jalr	272(ra) # ca0 <compare_str_ic>
 b98:	a041                	j	c18 <uniq_run+0x1ca>
                  printf("%s",line1);
 b9a:	85ca                	mv	a1,s2
 b9c:	856e                	mv	a0,s11
 b9e:	00000097          	auipc	ra,0x0
 ba2:	c8a080e7          	jalr	-886(ra) # 828 <printf>
        lineCount = 1;
 ba6:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 ba8:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 baa:	8926                	mv	s2,s1
                  printf("%s",line1);
 bac:	84be                	mv	s1,a5
        isRepeated = 0 ;
 bae:	4b81                	li	s7,0
 bb0:	a099                	j	bf6 <uniq_run+0x1a8>
            if (showCount)
 bb2:	020c0263          	beqz	s8,bd6 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 bb6:	864a                	mv	a2,s2
 bb8:	85da                	mv	a1,s6
 bba:	00000517          	auipc	a0,0x0
 bbe:	3f650513          	addi	a0,a0,1014 # fb0 <digits+0x70>
 bc2:	00000097          	auipc	ra,0x0
 bc6:	c66080e7          	jalr	-922(ra) # 828 <printf>
 bca:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 bcc:	8926                	mv	s2,s1
 bce:	84be                	mv	s1,a5
        isRepeated = 0 ;
 bd0:	4b81                	li	s7,0
        lineCount = 1;
 bd2:	8b6a                	mv	s6,s10
 bd4:	a00d                	j	bf6 <uniq_run+0x1a8>
              printf("%s",line1);
 bd6:	85ca                	mv	a1,s2
 bd8:	856e                	mv	a0,s11
 bda:	00000097          	auipc	ra,0x0
 bde:	c4e080e7          	jalr	-946(ra) # 828 <printf>
 be2:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 be4:	8926                	mv	s2,s1
              printf("%s",line1);
 be6:	84be                	mv	s1,a5
        isRepeated = 0 ;
 be8:	4b81                	li	s7,0
        lineCount = 1;
 bea:	8b6a                	mv	s6,s10
 bec:	a029                	j	bf6 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 bee:	000a0363          	beqz	s4,bf4 <uniq_run+0x1a6>
 bf2:	8bea                	mv	s7,s10
          lineCount++;
 bf4:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 bf6:	85a6                	mv	a1,s1
 bf8:	854e                	mv	a0,s3
 bfa:	00000097          	auipc	ra,0x0
 bfe:	196080e7          	jalr	406(ra) # d90 <read_line>
        if (readStatus == READ_EOF){
 c02:	d911                	beqz	a0,b16 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 c04:	f7950be3          	beq	a0,s9,b7a <uniq_run+0x12c>
        if (!ignoreCase)
 c08:	f80a92e3          	bnez	s5,b8c <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 c0c:	85a6                	mv	a1,s1
 c0e:	854a                	mv	a0,s2
 c10:	00000097          	auipc	ra,0x0
 c14:	062080e7          	jalr	98(ra) # c72 <compare_str>
        if (compareStatus != 0){ 
 c18:	d979                	beqz	a0,bee <uniq_run+0x1a0>
          if (repeatedLines){
 c1a:	f80a0ce3          	beqz	s4,bb2 <uniq_run+0x164>
            if (isRepeated){
 c1e:	ec0b8be3          	beqz	s7,af4 <uniq_run+0xa6>
                if (showCount)
 c22:	f60c0ce3          	beqz	s8,b9a <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 c26:	864a                	mv	a2,s2
 c28:	85da                	mv	a1,s6
 c2a:	00000517          	auipc	a0,0x0
 c2e:	38650513          	addi	a0,a0,902 # fb0 <digits+0x70>
 c32:	00000097          	auipc	ra,0x0
 c36:	bf6080e7          	jalr	-1034(ra) # 828 <printf>
        lineCount = 1;
 c3a:	8b5e                	mv	s6,s7
 c3c:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 c3e:	8926                	mv	s2,s1
 c40:	84be                	mv	s1,a5
        isRepeated = 0 ;
 c42:	4b81                	li	s7,0
 c44:	bf4d                	j	bf6 <uniq_run+0x1a8>

0000000000000c46 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 c46:	1141                	addi	sp,sp,-16
 c48:	e422                	sd	s0,8(sp)
 c4a:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 c4c:	00054783          	lbu	a5,0(a0)
 c50:	cf99                	beqz	a5,c6e <get_strlen+0x28>
 c52:	00150713          	addi	a4,a0,1
 c56:	87ba                	mv	a5,a4
 c58:	4685                	li	a3,1
 c5a:	9e99                	subw	a3,a3,a4
 c5c:	00f6853b          	addw	a0,a3,a5
 c60:	0785                	addi	a5,a5,1
 c62:	fff7c703          	lbu	a4,-1(a5)
 c66:	fb7d                	bnez	a4,c5c <get_strlen+0x16>
	return len;
}
 c68:	6422                	ld	s0,8(sp)
 c6a:	0141                	addi	sp,sp,16
 c6c:	8082                	ret
	int len = 0;
 c6e:	4501                	li	a0,0
 c70:	bfe5                	j	c68 <get_strlen+0x22>

0000000000000c72 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 c72:	1141                	addi	sp,sp,-16
 c74:	e422                	sd	s0,8(sp)
 c76:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 c78:	00054783          	lbu	a5,0(a0)
 c7c:	cb91                	beqz	a5,c90 <compare_str+0x1e>
 c7e:	0005c703          	lbu	a4,0(a1)
 c82:	c719                	beqz	a4,c90 <compare_str+0x1e>
		if (*s1++ != *s2++)
 c84:	0505                	addi	a0,a0,1
 c86:	0585                	addi	a1,a1,1
 c88:	fee788e3          	beq	a5,a4,c78 <compare_str+0x6>
			return 1;
 c8c:	4505                	li	a0,1
 c8e:	a031                	j	c9a <compare_str+0x28>
	}
	if (*s1 == *s2)
 c90:	0005c503          	lbu	a0,0(a1)
 c94:	8d1d                	sub	a0,a0,a5
			return 1;
 c96:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 c9a:	6422                	ld	s0,8(sp)
 c9c:	0141                	addi	sp,sp,16
 c9e:	8082                	ret

0000000000000ca0 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 ca0:	1141                	addi	sp,sp,-16
 ca2:	e422                	sd	s0,8(sp)
 ca4:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 ca6:	4665                	li	a2,25
	while(*s1 && *s2){
 ca8:	a019                	j	cae <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 caa:	04e79763          	bne	a5,a4,cf8 <compare_str_ic+0x58>
	while(*s1 && *s2){
 cae:	00054783          	lbu	a5,0(a0)
 cb2:	cb9d                	beqz	a5,ce8 <compare_str_ic+0x48>
 cb4:	0005c703          	lbu	a4,0(a1)
 cb8:	cb05                	beqz	a4,ce8 <compare_str_ic+0x48>
		char b1 = *s1++;
 cba:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 cbc:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 cbe:	fbf7869b          	addiw	a3,a5,-65
 cc2:	0ff6f693          	zext.b	a3,a3
 cc6:	00d66663          	bltu	a2,a3,cd2 <compare_str_ic+0x32>
			b1 += 32;
 cca:	0207879b          	addiw	a5,a5,32
 cce:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 cd2:	fbf7069b          	addiw	a3,a4,-65
 cd6:	0ff6f693          	zext.b	a3,a3
 cda:	fcd668e3          	bltu	a2,a3,caa <compare_str_ic+0xa>
			b2 += 32;
 cde:	0207071b          	addiw	a4,a4,32
 ce2:	0ff77713          	zext.b	a4,a4
 ce6:	b7d1                	j	caa <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 ce8:	0005c503          	lbu	a0,0(a1)
 cec:	8d1d                	sub	a0,a0,a5
			return 1;
 cee:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 cf2:	6422                	ld	s0,8(sp)
 cf4:	0141                	addi	sp,sp,16
 cf6:	8082                	ret
			return 1;
 cf8:	4505                	li	a0,1
 cfa:	bfe5                	j	cf2 <compare_str_ic+0x52>

0000000000000cfc <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 cfc:	7179                	addi	sp,sp,-48
 cfe:	f406                	sd	ra,40(sp)
 d00:	f022                	sd	s0,32(sp)
 d02:	ec26                	sd	s1,24(sp)
 d04:	e84a                	sd	s2,16(sp)
 d06:	e44e                	sd	s3,8(sp)
 d08:	1800                	addi	s0,sp,48
 d0a:	89aa                	mv	s3,a0
 d0c:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 d0e:	00000097          	auipc	ra,0x0
 d12:	f38080e7          	jalr	-200(ra) # c46 <get_strlen>
 d16:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 d18:	854a                	mv	a0,s2
 d1a:	00000097          	auipc	ra,0x0
 d1e:	f2c080e7          	jalr	-212(ra) # c46 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 d22:	409505bb          	subw	a1,a0,s1
 d26:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 d28:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 d2a:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 d2c:	0005da63          	bgez	a1,d40 <check_substr+0x44>
 d30:	a81d                	j	d66 <check_substr+0x6a>
        if (j == M)
 d32:	02f48a63          	beq	s1,a5,d66 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 d36:	0885                	addi	a7,a7,1
 d38:	0008879b          	sext.w	a5,a7
 d3c:	02f5cc63          	blt	a1,a5,d74 <check_substr+0x78>
 d40:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 d44:	011906b3          	add	a3,s2,a7
 d48:	874e                	mv	a4,s3
 d4a:	879a                	mv	a5,t1
 d4c:	fe9053e3          	blez	s1,d32 <check_substr+0x36>
            if (s2[i + j] != s1[j])
 d50:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 d54:	00074603          	lbu	a2,0(a4)
 d58:	fcc81de3          	bne	a6,a2,d32 <check_substr+0x36>
        for (j = 0; j < M; j++)
 d5c:	2785                	addiw	a5,a5,1
 d5e:	0685                	addi	a3,a3,1
 d60:	0705                	addi	a4,a4,1
 d62:	fef497e3          	bne	s1,a5,d50 <check_substr+0x54>
}
 d66:	70a2                	ld	ra,40(sp)
 d68:	7402                	ld	s0,32(sp)
 d6a:	64e2                	ld	s1,24(sp)
 d6c:	6942                	ld	s2,16(sp)
 d6e:	69a2                	ld	s3,8(sp)
 d70:	6145                	addi	sp,sp,48
 d72:	8082                	ret
    return -1;
 d74:	557d                	li	a0,-1
 d76:	bfc5                	j	d66 <check_substr+0x6a>

0000000000000d78 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 d78:	1141                	addi	sp,sp,-16
 d7a:	e406                	sd	ra,8(sp)
 d7c:	e022                	sd	s0,0(sp)
 d7e:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 d80:	fffff097          	auipc	ra,0xfffff
 d84:	72e080e7          	jalr	1838(ra) # 4ae <open>
	return fd;
}
 d88:	60a2                	ld	ra,8(sp)
 d8a:	6402                	ld	s0,0(sp)
 d8c:	0141                	addi	sp,sp,16
 d8e:	8082                	ret

0000000000000d90 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 d90:	7139                	addi	sp,sp,-64
 d92:	fc06                	sd	ra,56(sp)
 d94:	f822                	sd	s0,48(sp)
 d96:	f426                	sd	s1,40(sp)
 d98:	f04a                	sd	s2,32(sp)
 d9a:	ec4e                	sd	s3,24(sp)
 d9c:	e852                	sd	s4,16(sp)
 d9e:	0080                	addi	s0,sp,64
 da0:	89aa                	mv	s3,a0
 da2:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 da4:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 da6:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 da8:	4605                	li	a2,1
 daa:	fcf40593          	addi	a1,s0,-49
 dae:	854e                	mv	a0,s3
 db0:	fffff097          	auipc	ra,0xfffff
 db4:	6d6080e7          	jalr	1750(ra) # 486 <read>
		if (readStatus == 0){
 db8:	c505                	beqz	a0,de0 <read_line+0x50>
		*buffer++ = readByte;
 dba:	0485                	addi	s1,s1,1
 dbc:	fcf44783          	lbu	a5,-49(s0)
 dc0:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 dc4:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 dc6:	ff4791e3          	bne	a5,s4,da8 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 dca:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 dce:	854a                	mv	a0,s2
 dd0:	70e2                	ld	ra,56(sp)
 dd2:	7442                	ld	s0,48(sp)
 dd4:	74a2                	ld	s1,40(sp)
 dd6:	7902                	ld	s2,32(sp)
 dd8:	69e2                	ld	s3,24(sp)
 dda:	6a42                	ld	s4,16(sp)
 ddc:	6121                	addi	sp,sp,64
 dde:	8082                	ret
			if (byteCount!=0){
 de0:	fe0907e3          	beqz	s2,dce <read_line+0x3e>
				*buffer = '\n';
 de4:	47a9                	li	a5,10
 de6:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 dea:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 dee:	2905                	addiw	s2,s2,1
 df0:	bff9                	j	dce <read_line+0x3e>

0000000000000df2 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 df2:	1141                	addi	sp,sp,-16
 df4:	e406                	sd	ra,8(sp)
 df6:	e022                	sd	s0,0(sp)
 df8:	0800                	addi	s0,sp,16
	close(fd);
 dfa:	fffff097          	auipc	ra,0xfffff
 dfe:	69c080e7          	jalr	1692(ra) # 496 <close>
}
 e02:	60a2                	ld	ra,8(sp)
 e04:	6402                	ld	s0,0(sp)
 e06:	0141                	addi	sp,sp,16
 e08:	8082                	ret

0000000000000e0a <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 e0a:	7139                	addi	sp,sp,-64
 e0c:	fc06                	sd	ra,56(sp)
 e0e:	f822                	sd	s0,48(sp)
 e10:	f426                	sd	s1,40(sp)
 e12:	f04a                	sd	s2,32(sp)
 e14:	0080                	addi	s0,sp,64
 e16:	84aa                	mv	s1,a0
 e18:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 e1a:	fffff097          	auipc	ra,0xfffff
 e1e:	64c080e7          	jalr	1612(ra) # 466 <fork>
 e22:	ed19                	bnez	a0,e40 <get_time_perf+0x36>
		exec(argv[0],argv);
 e24:	85ca                	mv	a1,s2
 e26:	00093503          	ld	a0,0(s2)
 e2a:	fffff097          	auipc	ra,0xfffff
 e2e:	67c080e7          	jalr	1660(ra) # 4a6 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 e32:	8526                	mv	a0,s1
 e34:	70e2                	ld	ra,56(sp)
 e36:	7442                	ld	s0,48(sp)
 e38:	74a2                	ld	s1,40(sp)
 e3a:	7902                	ld	s2,32(sp)
 e3c:	6121                	addi	sp,sp,64
 e3e:	8082                	ret
		times(pid , &time);
 e40:	fc040593          	addi	a1,s0,-64
 e44:	fffff097          	auipc	ra,0xfffff
 e48:	6e2080e7          	jalr	1762(ra) # 526 <times>
		return time;
 e4c:	fc043783          	ld	a5,-64(s0)
 e50:	e09c                	sd	a5,0(s1)
 e52:	fc843783          	ld	a5,-56(s0)
 e56:	e49c                	sd	a5,8(s1)
 e58:	fd043783          	ld	a5,-48(s0)
 e5c:	e89c                	sd	a5,16(s1)
 e5e:	fd843783          	ld	a5,-40(s0)
 e62:	ec9c                	sd	a5,24(s1)
 e64:	b7f9                	j	e32 <get_time_perf+0x28>
