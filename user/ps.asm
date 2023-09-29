
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
  34:	e2098993          	addi	s3,s3,-480 # e50 <get_time_perf+0x5e>
			cmd++;
			*pid = atoi(*cmd);
		}else if (!compare_str(*cmd,"-ppid")){
  38:	00001a97          	auipc	s5,0x1
  3c:	e20a8a93          	addi	s5,s5,-480 # e58 <get_time_perf+0x66>
			cmd++;
			*ppid = atoi(*cmd);

		}else if (!compare_str(*cmd,"-stat")){
  40:	00001b97          	auipc	s7,0x1
  44:	e20b8b93          	addi	s7,s7,-480 # e60 <get_time_perf+0x6e>
				*status=USED;
			else{
				printf("[ERR] Invalid process state\n");
				exit(0);
			}
		}else if(!compare_str(*cmd,"-name")){
  48:	00001d17          	auipc	s10,0x1
  4c:	e70d0d13          	addi	s10,s10,-400 # eb8 <get_time_perf+0xc6>
			if (!compare_str_ic(*cmd,"sleeping"))
  50:	00001c97          	auipc	s9,0x1
  54:	e18c8c93          	addi	s9,s9,-488 # e68 <get_time_perf+0x76>
			else if(!compare_str_ic(*cmd,"running"))
  58:	00001d97          	auipc	s11,0x1
  5c:	e20d8d93          	addi	s11,s11,-480 # e78 <get_time_perf+0x86>
  60:	a035                	j	8c <parse_cmd+0x8c>
		}else if (!compare_str(*cmd,"-ppid")){
  62:	85d6                	mv	a1,s5
  64:	6088                	ld	a0,0(s1)
  66:	00001097          	auipc	ra,0x1
  6a:	bf4080e7          	jalr	-1036(ra) # c5a <compare_str>
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
  92:	bcc080e7          	jalr	-1076(ra) # c5a <compare_str>
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
  b4:	baa080e7          	jalr	-1110(ra) # c5a <compare_str>
  b8:	e145                	bnez	a0,158 <parse_cmd+0x158>
			cmd++;
  ba:	00848913          	addi	s2,s1,8
			if (!compare_str_ic(*cmd,"sleeping"))
  be:	85e6                	mv	a1,s9
  c0:	6488                	ld	a0,8(s1)
  c2:	00001097          	auipc	ra,0x1
  c6:	bc6080e7          	jalr	-1082(ra) # c88 <compare_str_ic>
  ca:	e509                	bnez	a0,d4 <parse_cmd+0xd4>
				*status=SLEEPING;
  cc:	4789                	li	a5,2
  ce:	00fc2023          	sw	a5,0(s8)
  d2:	bf45                	j	82 <parse_cmd+0x82>
			else if(!compare_str_ic(*cmd,"running"))
  d4:	85ee                	mv	a1,s11
  d6:	6488                	ld	a0,8(s1)
  d8:	00001097          	auipc	ra,0x1
  dc:	bb0080e7          	jalr	-1104(ra) # c88 <compare_str_ic>
  e0:	e509                	bnez	a0,ea <parse_cmd+0xea>
				*status=RUNNING;
  e2:	4791                	li	a5,4
  e4:	00fc2023          	sw	a5,0(s8)
  e8:	bf69                	j	82 <parse_cmd+0x82>
			else if(!compare_str_ic(*cmd,"ready"))
  ea:	00001597          	auipc	a1,0x1
  ee:	d9658593          	addi	a1,a1,-618 # e80 <get_time_perf+0x8e>
  f2:	6488                	ld	a0,8(s1)
  f4:	00001097          	auipc	ra,0x1
  f8:	b94080e7          	jalr	-1132(ra) # c88 <compare_str_ic>
  fc:	e509                	bnez	a0,106 <parse_cmd+0x106>
				*status=RUNNABLE;
  fe:	478d                	li	a5,3
 100:	00fc2023          	sw	a5,0(s8)
 104:	bfbd                	j	82 <parse_cmd+0x82>
			else if(!compare_str_ic(*cmd,"zombie"))
 106:	00001597          	auipc	a1,0x1
 10a:	d8258593          	addi	a1,a1,-638 # e88 <get_time_perf+0x96>
 10e:	6488                	ld	a0,8(s1)
 110:	00001097          	auipc	ra,0x1
 114:	b78080e7          	jalr	-1160(ra) # c88 <compare_str_ic>
 118:	e509                	bnez	a0,122 <parse_cmd+0x122>
				*status=ZOMBIE;
 11a:	4795                	li	a5,5
 11c:	00fc2023          	sw	a5,0(s8)
 120:	b78d                	j	82 <parse_cmd+0x82>
			else if(!compare_str_ic(*cmd,"used"))
 122:	00001597          	auipc	a1,0x1
 126:	d6e58593          	addi	a1,a1,-658 # e90 <get_time_perf+0x9e>
 12a:	6488                	ld	a0,8(s1)
 12c:	00001097          	auipc	ra,0x1
 130:	b5c080e7          	jalr	-1188(ra) # c88 <compare_str_ic>
 134:	e509                	bnez	a0,13e <parse_cmd+0x13e>
				*status=USED;
 136:	4785                	li	a5,1
 138:	00fc2023          	sw	a5,0(s8)
 13c:	b799                	j	82 <parse_cmd+0x82>
				printf("[ERR] Invalid process state\n");
 13e:	00001517          	auipc	a0,0x1
 142:	d5a50513          	addi	a0,a0,-678 # e98 <get_time_perf+0xa6>
 146:	00000097          	auipc	ra,0x0
 14a:	6ca080e7          	jalr	1738(ra) # 810 <printf>
				exit(0);
 14e:	4501                	li	a0,0
 150:	00000097          	auipc	ra,0x0
 154:	31e080e7          	jalr	798(ra) # 46e <exit>
		}else if(!compare_str(*cmd,"-name")){
 158:	85ea                	mv	a1,s10
 15a:	6088                	ld	a0,0(s1)
 15c:	00001097          	auipc	ra,0x1
 160:	afe080e7          	jalr	-1282(ra) # c5a <compare_str>
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

0000000000000536 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 536:	1101                	addi	sp,sp,-32
 538:	ec06                	sd	ra,24(sp)
 53a:	e822                	sd	s0,16(sp)
 53c:	1000                	addi	s0,sp,32
 53e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 542:	4605                	li	a2,1
 544:	fef40593          	addi	a1,s0,-17
 548:	00000097          	auipc	ra,0x0
 54c:	f46080e7          	jalr	-186(ra) # 48e <write>
}
 550:	60e2                	ld	ra,24(sp)
 552:	6442                	ld	s0,16(sp)
 554:	6105                	addi	sp,sp,32
 556:	8082                	ret

0000000000000558 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 558:	7139                	addi	sp,sp,-64
 55a:	fc06                	sd	ra,56(sp)
 55c:	f822                	sd	s0,48(sp)
 55e:	f426                	sd	s1,40(sp)
 560:	f04a                	sd	s2,32(sp)
 562:	ec4e                	sd	s3,24(sp)
 564:	0080                	addi	s0,sp,64
 566:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 568:	c299                	beqz	a3,56e <printint+0x16>
 56a:	0805c963          	bltz	a1,5fc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 56e:	2581                	sext.w	a1,a1
  neg = 0;
 570:	4881                	li	a7,0
 572:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 576:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 578:	2601                	sext.w	a2,a2
 57a:	00001517          	auipc	a0,0x1
 57e:	9a650513          	addi	a0,a0,-1626 # f20 <digits>
 582:	883a                	mv	a6,a4
 584:	2705                	addiw	a4,a4,1
 586:	02c5f7bb          	remuw	a5,a1,a2
 58a:	1782                	slli	a5,a5,0x20
 58c:	9381                	srli	a5,a5,0x20
 58e:	97aa                	add	a5,a5,a0
 590:	0007c783          	lbu	a5,0(a5)
 594:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 598:	0005879b          	sext.w	a5,a1
 59c:	02c5d5bb          	divuw	a1,a1,a2
 5a0:	0685                	addi	a3,a3,1
 5a2:	fec7f0e3          	bgeu	a5,a2,582 <printint+0x2a>
  if(neg)
 5a6:	00088c63          	beqz	a7,5be <printint+0x66>
    buf[i++] = '-';
 5aa:	fd070793          	addi	a5,a4,-48
 5ae:	00878733          	add	a4,a5,s0
 5b2:	02d00793          	li	a5,45
 5b6:	fef70823          	sb	a5,-16(a4)
 5ba:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5be:	02e05863          	blez	a4,5ee <printint+0x96>
 5c2:	fc040793          	addi	a5,s0,-64
 5c6:	00e78933          	add	s2,a5,a4
 5ca:	fff78993          	addi	s3,a5,-1
 5ce:	99ba                	add	s3,s3,a4
 5d0:	377d                	addiw	a4,a4,-1
 5d2:	1702                	slli	a4,a4,0x20
 5d4:	9301                	srli	a4,a4,0x20
 5d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5da:	fff94583          	lbu	a1,-1(s2)
 5de:	8526                	mv	a0,s1
 5e0:	00000097          	auipc	ra,0x0
 5e4:	f56080e7          	jalr	-170(ra) # 536 <putc>
  while(--i >= 0)
 5e8:	197d                	addi	s2,s2,-1
 5ea:	ff3918e3          	bne	s2,s3,5da <printint+0x82>
}
 5ee:	70e2                	ld	ra,56(sp)
 5f0:	7442                	ld	s0,48(sp)
 5f2:	74a2                	ld	s1,40(sp)
 5f4:	7902                	ld	s2,32(sp)
 5f6:	69e2                	ld	s3,24(sp)
 5f8:	6121                	addi	sp,sp,64
 5fa:	8082                	ret
    x = -xx;
 5fc:	40b005bb          	negw	a1,a1
    neg = 1;
 600:	4885                	li	a7,1
    x = -xx;
 602:	bf85                	j	572 <printint+0x1a>

0000000000000604 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 604:	7119                	addi	sp,sp,-128
 606:	fc86                	sd	ra,120(sp)
 608:	f8a2                	sd	s0,112(sp)
 60a:	f4a6                	sd	s1,104(sp)
 60c:	f0ca                	sd	s2,96(sp)
 60e:	ecce                	sd	s3,88(sp)
 610:	e8d2                	sd	s4,80(sp)
 612:	e4d6                	sd	s5,72(sp)
 614:	e0da                	sd	s6,64(sp)
 616:	fc5e                	sd	s7,56(sp)
 618:	f862                	sd	s8,48(sp)
 61a:	f466                	sd	s9,40(sp)
 61c:	f06a                	sd	s10,32(sp)
 61e:	ec6e                	sd	s11,24(sp)
 620:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 622:	0005c903          	lbu	s2,0(a1)
 626:	18090f63          	beqz	s2,7c4 <vprintf+0x1c0>
 62a:	8aaa                	mv	s5,a0
 62c:	8b32                	mv	s6,a2
 62e:	00158493          	addi	s1,a1,1
  state = 0;
 632:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 634:	02500a13          	li	s4,37
 638:	4c55                	li	s8,21
 63a:	00001c97          	auipc	s9,0x1
 63e:	88ec8c93          	addi	s9,s9,-1906 # ec8 <get_time_perf+0xd6>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 642:	02800d93          	li	s11,40
  putc(fd, 'x');
 646:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 648:	00001b97          	auipc	s7,0x1
 64c:	8d8b8b93          	addi	s7,s7,-1832 # f20 <digits>
 650:	a839                	j	66e <vprintf+0x6a>
        putc(fd, c);
 652:	85ca                	mv	a1,s2
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	ee0080e7          	jalr	-288(ra) # 536 <putc>
 65e:	a019                	j	664 <vprintf+0x60>
    } else if(state == '%'){
 660:	01498d63          	beq	s3,s4,67a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 664:	0485                	addi	s1,s1,1
 666:	fff4c903          	lbu	s2,-1(s1)
 66a:	14090d63          	beqz	s2,7c4 <vprintf+0x1c0>
    if(state == 0){
 66e:	fe0999e3          	bnez	s3,660 <vprintf+0x5c>
      if(c == '%'){
 672:	ff4910e3          	bne	s2,s4,652 <vprintf+0x4e>
        state = '%';
 676:	89d2                	mv	s3,s4
 678:	b7f5                	j	664 <vprintf+0x60>
      if(c == 'd'){
 67a:	11490c63          	beq	s2,s4,792 <vprintf+0x18e>
 67e:	f9d9079b          	addiw	a5,s2,-99
 682:	0ff7f793          	zext.b	a5,a5
 686:	10fc6e63          	bltu	s8,a5,7a2 <vprintf+0x19e>
 68a:	f9d9079b          	addiw	a5,s2,-99
 68e:	0ff7f713          	zext.b	a4,a5
 692:	10ec6863          	bltu	s8,a4,7a2 <vprintf+0x19e>
 696:	00271793          	slli	a5,a4,0x2
 69a:	97e6                	add	a5,a5,s9
 69c:	439c                	lw	a5,0(a5)
 69e:	97e6                	add	a5,a5,s9
 6a0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6a2:	008b0913          	addi	s2,s6,8
 6a6:	4685                	li	a3,1
 6a8:	4629                	li	a2,10
 6aa:	000b2583          	lw	a1,0(s6)
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	ea8080e7          	jalr	-344(ra) # 558 <printint>
 6b8:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	b765                	j	664 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	008b0913          	addi	s2,s6,8
 6c2:	4681                	li	a3,0
 6c4:	4629                	li	a2,10
 6c6:	000b2583          	lw	a1,0(s6)
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	e8c080e7          	jalr	-372(ra) # 558 <printint>
 6d4:	8b4a                	mv	s6,s2
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	b771                	j	664 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6da:	008b0913          	addi	s2,s6,8
 6de:	4681                	li	a3,0
 6e0:	866a                	mv	a2,s10
 6e2:	000b2583          	lw	a1,0(s6)
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e70080e7          	jalr	-400(ra) # 558 <printint>
 6f0:	8b4a                	mv	s6,s2
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bf85                	j	664 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6f6:	008b0793          	addi	a5,s6,8
 6fa:	f8f43423          	sd	a5,-120(s0)
 6fe:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 702:	03000593          	li	a1,48
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	e2e080e7          	jalr	-466(ra) # 536 <putc>
  putc(fd, 'x');
 710:	07800593          	li	a1,120
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	e20080e7          	jalr	-480(ra) # 536 <putc>
 71e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 720:	03c9d793          	srli	a5,s3,0x3c
 724:	97de                	add	a5,a5,s7
 726:	0007c583          	lbu	a1,0(a5)
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	e0a080e7          	jalr	-502(ra) # 536 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 734:	0992                	slli	s3,s3,0x4
 736:	397d                	addiw	s2,s2,-1
 738:	fe0914e3          	bnez	s2,720 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 73c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 740:	4981                	li	s3,0
 742:	b70d                	j	664 <vprintf+0x60>
        s = va_arg(ap, char*);
 744:	008b0913          	addi	s2,s6,8
 748:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 74c:	02098163          	beqz	s3,76e <vprintf+0x16a>
        while(*s != 0){
 750:	0009c583          	lbu	a1,0(s3)
 754:	c5ad                	beqz	a1,7be <vprintf+0x1ba>
          putc(fd, *s);
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	dde080e7          	jalr	-546(ra) # 536 <putc>
          s++;
 760:	0985                	addi	s3,s3,1
        while(*s != 0){
 762:	0009c583          	lbu	a1,0(s3)
 766:	f9e5                	bnez	a1,756 <vprintf+0x152>
        s = va_arg(ap, char*);
 768:	8b4a                	mv	s6,s2
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bde5                	j	664 <vprintf+0x60>
          s = "(null)";
 76e:	00000997          	auipc	s3,0x0
 772:	75298993          	addi	s3,s3,1874 # ec0 <get_time_perf+0xce>
        while(*s != 0){
 776:	85ee                	mv	a1,s11
 778:	bff9                	j	756 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 77a:	008b0913          	addi	s2,s6,8
 77e:	000b4583          	lbu	a1,0(s6)
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	db2080e7          	jalr	-590(ra) # 536 <putc>
 78c:	8b4a                	mv	s6,s2
      state = 0;
 78e:	4981                	li	s3,0
 790:	bdd1                	j	664 <vprintf+0x60>
        putc(fd, c);
 792:	85d2                	mv	a1,s4
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	da0080e7          	jalr	-608(ra) # 536 <putc>
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	b5d1                	j	664 <vprintf+0x60>
        putc(fd, '%');
 7a2:	85d2                	mv	a1,s4
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	d90080e7          	jalr	-624(ra) # 536 <putc>
        putc(fd, c);
 7ae:	85ca                	mv	a1,s2
 7b0:	8556                	mv	a0,s5
 7b2:	00000097          	auipc	ra,0x0
 7b6:	d84080e7          	jalr	-636(ra) # 536 <putc>
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	b565                	j	664 <vprintf+0x60>
        s = va_arg(ap, char*);
 7be:	8b4a                	mv	s6,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b54d                	j	664 <vprintf+0x60>
    }
  }
}
 7c4:	70e6                	ld	ra,120(sp)
 7c6:	7446                	ld	s0,112(sp)
 7c8:	74a6                	ld	s1,104(sp)
 7ca:	7906                	ld	s2,96(sp)
 7cc:	69e6                	ld	s3,88(sp)
 7ce:	6a46                	ld	s4,80(sp)
 7d0:	6aa6                	ld	s5,72(sp)
 7d2:	6b06                	ld	s6,64(sp)
 7d4:	7be2                	ld	s7,56(sp)
 7d6:	7c42                	ld	s8,48(sp)
 7d8:	7ca2                	ld	s9,40(sp)
 7da:	7d02                	ld	s10,32(sp)
 7dc:	6de2                	ld	s11,24(sp)
 7de:	6109                	addi	sp,sp,128
 7e0:	8082                	ret

00000000000007e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e2:	715d                	addi	sp,sp,-80
 7e4:	ec06                	sd	ra,24(sp)
 7e6:	e822                	sd	s0,16(sp)
 7e8:	1000                	addi	s0,sp,32
 7ea:	e010                	sd	a2,0(s0)
 7ec:	e414                	sd	a3,8(s0)
 7ee:	e818                	sd	a4,16(s0)
 7f0:	ec1c                	sd	a5,24(s0)
 7f2:	03043023          	sd	a6,32(s0)
 7f6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7fa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7fe:	8622                	mv	a2,s0
 800:	00000097          	auipc	ra,0x0
 804:	e04080e7          	jalr	-508(ra) # 604 <vprintf>
}
 808:	60e2                	ld	ra,24(sp)
 80a:	6442                	ld	s0,16(sp)
 80c:	6161                	addi	sp,sp,80
 80e:	8082                	ret

0000000000000810 <printf>:

void
printf(const char *fmt, ...)
{
 810:	711d                	addi	sp,sp,-96
 812:	ec06                	sd	ra,24(sp)
 814:	e822                	sd	s0,16(sp)
 816:	1000                	addi	s0,sp,32
 818:	e40c                	sd	a1,8(s0)
 81a:	e810                	sd	a2,16(s0)
 81c:	ec14                	sd	a3,24(s0)
 81e:	f018                	sd	a4,32(s0)
 820:	f41c                	sd	a5,40(s0)
 822:	03043823          	sd	a6,48(s0)
 826:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 82a:	00840613          	addi	a2,s0,8
 82e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 832:	85aa                	mv	a1,a0
 834:	4505                	li	a0,1
 836:	00000097          	auipc	ra,0x0
 83a:	dce080e7          	jalr	-562(ra) # 604 <vprintf>
}
 83e:	60e2                	ld	ra,24(sp)
 840:	6442                	ld	s0,16(sp)
 842:	6125                	addi	sp,sp,96
 844:	8082                	ret

0000000000000846 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 846:	1141                	addi	sp,sp,-16
 848:	e422                	sd	s0,8(sp)
 84a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 84c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 850:	00000797          	auipc	a5,0x0
 854:	7b07b783          	ld	a5,1968(a5) # 1000 <freep>
 858:	a02d                	j	882 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 85a:	4618                	lw	a4,8(a2)
 85c:	9f2d                	addw	a4,a4,a1
 85e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 862:	6398                	ld	a4,0(a5)
 864:	6310                	ld	a2,0(a4)
 866:	a83d                	j	8a4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 868:	ff852703          	lw	a4,-8(a0)
 86c:	9f31                	addw	a4,a4,a2
 86e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 870:	ff053683          	ld	a3,-16(a0)
 874:	a091                	j	8b8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 876:	6398                	ld	a4,0(a5)
 878:	00e7e463          	bltu	a5,a4,880 <free+0x3a>
 87c:	00e6ea63          	bltu	a3,a4,890 <free+0x4a>
{
 880:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 882:	fed7fae3          	bgeu	a5,a3,876 <free+0x30>
 886:	6398                	ld	a4,0(a5)
 888:	00e6e463          	bltu	a3,a4,890 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88c:	fee7eae3          	bltu	a5,a4,880 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 890:	ff852583          	lw	a1,-8(a0)
 894:	6390                	ld	a2,0(a5)
 896:	02059813          	slli	a6,a1,0x20
 89a:	01c85713          	srli	a4,a6,0x1c
 89e:	9736                	add	a4,a4,a3
 8a0:	fae60de3          	beq	a2,a4,85a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8a4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8a8:	4790                	lw	a2,8(a5)
 8aa:	02061593          	slli	a1,a2,0x20
 8ae:	01c5d713          	srli	a4,a1,0x1c
 8b2:	973e                	add	a4,a4,a5
 8b4:	fae68ae3          	beq	a3,a4,868 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8b8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ba:	00000717          	auipc	a4,0x0
 8be:	74f73323          	sd	a5,1862(a4) # 1000 <freep>
}
 8c2:	6422                	ld	s0,8(sp)
 8c4:	0141                	addi	sp,sp,16
 8c6:	8082                	ret

00000000000008c8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c8:	7139                	addi	sp,sp,-64
 8ca:	fc06                	sd	ra,56(sp)
 8cc:	f822                	sd	s0,48(sp)
 8ce:	f426                	sd	s1,40(sp)
 8d0:	f04a                	sd	s2,32(sp)
 8d2:	ec4e                	sd	s3,24(sp)
 8d4:	e852                	sd	s4,16(sp)
 8d6:	e456                	sd	s5,8(sp)
 8d8:	e05a                	sd	s6,0(sp)
 8da:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8dc:	02051493          	slli	s1,a0,0x20
 8e0:	9081                	srli	s1,s1,0x20
 8e2:	04bd                	addi	s1,s1,15
 8e4:	8091                	srli	s1,s1,0x4
 8e6:	0014899b          	addiw	s3,s1,1
 8ea:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8ec:	00000517          	auipc	a0,0x0
 8f0:	71453503          	ld	a0,1812(a0) # 1000 <freep>
 8f4:	c515                	beqz	a0,920 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f8:	4798                	lw	a4,8(a5)
 8fa:	02977f63          	bgeu	a4,s1,938 <malloc+0x70>
 8fe:	8a4e                	mv	s4,s3
 900:	0009871b          	sext.w	a4,s3
 904:	6685                	lui	a3,0x1
 906:	00d77363          	bgeu	a4,a3,90c <malloc+0x44>
 90a:	6a05                	lui	s4,0x1
 90c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 910:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 914:	00000917          	auipc	s2,0x0
 918:	6ec90913          	addi	s2,s2,1772 # 1000 <freep>
  if(p == (char*)-1)
 91c:	5afd                	li	s5,-1
 91e:	a895                	j	992 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 920:	00000797          	auipc	a5,0x0
 924:	6f078793          	addi	a5,a5,1776 # 1010 <base>
 928:	00000717          	auipc	a4,0x0
 92c:	6cf73c23          	sd	a5,1752(a4) # 1000 <freep>
 930:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 932:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 936:	b7e1                	j	8fe <malloc+0x36>
      if(p->s.size == nunits)
 938:	02e48c63          	beq	s1,a4,970 <malloc+0xa8>
        p->s.size -= nunits;
 93c:	4137073b          	subw	a4,a4,s3
 940:	c798                	sw	a4,8(a5)
        p += p->s.size;
 942:	02071693          	slli	a3,a4,0x20
 946:	01c6d713          	srli	a4,a3,0x1c
 94a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 94c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 950:	00000717          	auipc	a4,0x0
 954:	6aa73823          	sd	a0,1712(a4) # 1000 <freep>
      return (void*)(p + 1);
 958:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 95c:	70e2                	ld	ra,56(sp)
 95e:	7442                	ld	s0,48(sp)
 960:	74a2                	ld	s1,40(sp)
 962:	7902                	ld	s2,32(sp)
 964:	69e2                	ld	s3,24(sp)
 966:	6a42                	ld	s4,16(sp)
 968:	6aa2                	ld	s5,8(sp)
 96a:	6b02                	ld	s6,0(sp)
 96c:	6121                	addi	sp,sp,64
 96e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 970:	6398                	ld	a4,0(a5)
 972:	e118                	sd	a4,0(a0)
 974:	bff1                	j	950 <malloc+0x88>
  hp->s.size = nu;
 976:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 97a:	0541                	addi	a0,a0,16
 97c:	00000097          	auipc	ra,0x0
 980:	eca080e7          	jalr	-310(ra) # 846 <free>
  return freep;
 984:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 988:	d971                	beqz	a0,95c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98c:	4798                	lw	a4,8(a5)
 98e:	fa9775e3          	bgeu	a4,s1,938 <malloc+0x70>
    if(p == freep)
 992:	00093703          	ld	a4,0(s2)
 996:	853e                	mv	a0,a5
 998:	fef719e3          	bne	a4,a5,98a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 99c:	8552                	mv	a0,s4
 99e:	00000097          	auipc	ra,0x0
 9a2:	b58080e7          	jalr	-1192(ra) # 4f6 <sbrk>
  if(p == (char*)-1)
 9a6:	fd5518e3          	bne	a0,s5,976 <malloc+0xae>
        return 0;
 9aa:	4501                	li	a0,0
 9ac:	bf45                	j	95c <malloc+0x94>

00000000000009ae <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
 9ae:	c1d9                	beqz	a1,a34 <head_run+0x86>
void head_run(int fd, int numOfLines){
 9b0:	dd010113          	addi	sp,sp,-560
 9b4:	22113423          	sd	ra,552(sp)
 9b8:	22813023          	sd	s0,544(sp)
 9bc:	20913c23          	sd	s1,536(sp)
 9c0:	21213823          	sd	s2,528(sp)
 9c4:	21313423          	sd	s3,520(sp)
 9c8:	21413023          	sd	s4,512(sp)
 9cc:	1c00                	addi	s0,sp,560
 9ce:	892a                	mv	s2,a0
 9d0:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
 9d4:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
 9d6:	00000a17          	auipc	s4,0x0
 9da:	58aa0a13          	addi	s4,s4,1418 # f60 <digits+0x40>
		readStatus = read_line(fd, line);
 9de:	dd840593          	addi	a1,s0,-552
 9e2:	854a                	mv	a0,s2
 9e4:	00000097          	auipc	ra,0x0
 9e8:	394080e7          	jalr	916(ra) # d78 <read_line>
		if (readStatus == READ_ERROR){
 9ec:	01350d63          	beq	a0,s3,a06 <head_run+0x58>
		if (readStatus == READ_EOF)
 9f0:	c11d                	beqz	a0,a16 <head_run+0x68>
		printf("%s",line);
 9f2:	dd840593          	addi	a1,s0,-552
 9f6:	8552                	mv	a0,s4
 9f8:	00000097          	auipc	ra,0x0
 9fc:	e18080e7          	jalr	-488(ra) # 810 <printf>
	while(numOfLines--){
 a00:	34fd                	addiw	s1,s1,-1
 a02:	fcf1                	bnez	s1,9de <head_run+0x30>
 a04:	a809                	j	a16 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
 a06:	00000517          	auipc	a0,0x0
 a0a:	53250513          	addi	a0,a0,1330 # f38 <digits+0x18>
 a0e:	00000097          	auipc	ra,0x0
 a12:	e02080e7          	jalr	-510(ra) # 810 <printf>

	}
}
 a16:	22813083          	ld	ra,552(sp)
 a1a:	22013403          	ld	s0,544(sp)
 a1e:	21813483          	ld	s1,536(sp)
 a22:	21013903          	ld	s2,528(sp)
 a26:	20813983          	ld	s3,520(sp)
 a2a:	20013a03          	ld	s4,512(sp)
 a2e:	23010113          	addi	sp,sp,560
 a32:	8082                	ret
 a34:	8082                	ret

0000000000000a36 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
 a36:	ba010113          	addi	sp,sp,-1120
 a3a:	44113c23          	sd	ra,1112(sp)
 a3e:	44813823          	sd	s0,1104(sp)
 a42:	44913423          	sd	s1,1096(sp)
 a46:	45213023          	sd	s2,1088(sp)
 a4a:	43313c23          	sd	s3,1080(sp)
 a4e:	43413823          	sd	s4,1072(sp)
 a52:	43513423          	sd	s5,1064(sp)
 a56:	43613023          	sd	s6,1056(sp)
 a5a:	41713c23          	sd	s7,1048(sp)
 a5e:	41813823          	sd	s8,1040(sp)
 a62:	41913423          	sd	s9,1032(sp)
 a66:	41a13023          	sd	s10,1024(sp)
 a6a:	3fb13c23          	sd	s11,1016(sp)
 a6e:	46010413          	addi	s0,sp,1120
 a72:	89aa                	mv	s3,a0
 a74:	8aae                	mv	s5,a1
 a76:	8c32                	mv	s8,a2
 a78:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
 a7a:	d9840593          	addi	a1,s0,-616
 a7e:	00000097          	auipc	ra,0x0
 a82:	2fa080e7          	jalr	762(ra) # d78 <read_line>


  if (readStatus == READ_ERROR)
 a86:	57fd                	li	a5,-1
 a88:	04f50163          	beq	a0,a5,aca <uniq_run+0x94>
 a8c:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
 a8e:	ed21                	bnez	a0,ae6 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
 a90:	45813083          	ld	ra,1112(sp)
 a94:	45013403          	ld	s0,1104(sp)
 a98:	44813483          	ld	s1,1096(sp)
 a9c:	44013903          	ld	s2,1088(sp)
 aa0:	43813983          	ld	s3,1080(sp)
 aa4:	43013a03          	ld	s4,1072(sp)
 aa8:	42813a83          	ld	s5,1064(sp)
 aac:	42013b03          	ld	s6,1056(sp)
 ab0:	41813b83          	ld	s7,1048(sp)
 ab4:	41013c03          	ld	s8,1040(sp)
 ab8:	40813c83          	ld	s9,1032(sp)
 abc:	40013d03          	ld	s10,1024(sp)
 ac0:	3f813d83          	ld	s11,1016(sp)
 ac4:	46010113          	addi	sp,sp,1120
 ac8:	8082                	ret
    printf("[ERR] Error reading from the file ");
 aca:	00000517          	auipc	a0,0x0
 ace:	49e50513          	addi	a0,a0,1182 # f68 <digits+0x48>
 ad2:	00000097          	auipc	ra,0x0
 ad6:	d3e080e7          	jalr	-706(ra) # 810 <printf>
 ada:	bf5d                	j	a90 <uniq_run+0x5a>
 adc:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 ade:	8926                	mv	s2,s1
 ae0:	84be                	mv	s1,a5
        lineCount = 1;
 ae2:	8b6a                	mv	s6,s10
 ae4:	a8ed                	j	bde <uniq_run+0x1a8>
    int lineCount=1;
 ae6:	4b05                	li	s6,1
  char * line2 = buffer2;
 ae8:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
 aec:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
 af0:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
 af2:	4d05                	li	s10,1
              printf("%s",line1);
 af4:	00000d97          	auipc	s11,0x0
 af8:	46cd8d93          	addi	s11,s11,1132 # f60 <digits+0x40>
 afc:	a0cd                	j	bde <uniq_run+0x1a8>
            if (repeatedLines){
 afe:	020a0b63          	beqz	s4,b34 <uniq_run+0xfe>
                if (isRepeated){
 b02:	f80b87e3          	beqz	s7,a90 <uniq_run+0x5a>
                    if (showCount)
 b06:	000c0d63          	beqz	s8,b20 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
 b0a:	864a                	mv	a2,s2
 b0c:	85da                	mv	a1,s6
 b0e:	00000517          	auipc	a0,0x0
 b12:	48250513          	addi	a0,a0,1154 # f90 <digits+0x70>
 b16:	00000097          	auipc	ra,0x0
 b1a:	cfa080e7          	jalr	-774(ra) # 810 <printf>
 b1e:	bf8d                	j	a90 <uniq_run+0x5a>
                      printf("%s",line1);
 b20:	85ca                	mv	a1,s2
 b22:	00000517          	auipc	a0,0x0
 b26:	43e50513          	addi	a0,a0,1086 # f60 <digits+0x40>
 b2a:	00000097          	auipc	ra,0x0
 b2e:	ce6080e7          	jalr	-794(ra) # 810 <printf>
 b32:	bfb9                	j	a90 <uniq_run+0x5a>
                if (showCount)
 b34:	000c0d63          	beqz	s8,b4e <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
 b38:	864a                	mv	a2,s2
 b3a:	85da                	mv	a1,s6
 b3c:	00000517          	auipc	a0,0x0
 b40:	45450513          	addi	a0,a0,1108 # f90 <digits+0x70>
 b44:	00000097          	auipc	ra,0x0
 b48:	ccc080e7          	jalr	-820(ra) # 810 <printf>
 b4c:	b791                	j	a90 <uniq_run+0x5a>
                  printf("%s",line1);
 b4e:	85ca                	mv	a1,s2
 b50:	00000517          	auipc	a0,0x0
 b54:	41050513          	addi	a0,a0,1040 # f60 <digits+0x40>
 b58:	00000097          	auipc	ra,0x0
 b5c:	cb8080e7          	jalr	-840(ra) # 810 <printf>
 b60:	bf05                	j	a90 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
 b62:	00000517          	auipc	a0,0x0
 b66:	43650513          	addi	a0,a0,1078 # f98 <digits+0x78>
 b6a:	00000097          	auipc	ra,0x0
 b6e:	ca6080e7          	jalr	-858(ra) # 810 <printf>
          break;
 b72:	bf39                	j	a90 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
 b74:	85a6                	mv	a1,s1
 b76:	854a                	mv	a0,s2
 b78:	00000097          	auipc	ra,0x0
 b7c:	110080e7          	jalr	272(ra) # c88 <compare_str_ic>
 b80:	a041                	j	c00 <uniq_run+0x1ca>
                  printf("%s",line1);
 b82:	85ca                	mv	a1,s2
 b84:	856e                	mv	a0,s11
 b86:	00000097          	auipc	ra,0x0
 b8a:	c8a080e7          	jalr	-886(ra) # 810 <printf>
        lineCount = 1;
 b8e:	8b5e                	mv	s6,s7
                  printf("%s",line1);
 b90:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 b92:	8926                	mv	s2,s1
                  printf("%s",line1);
 b94:	84be                	mv	s1,a5
        isRepeated = 0 ;
 b96:	4b81                	li	s7,0
 b98:	a099                	j	bde <uniq_run+0x1a8>
            if (showCount)
 b9a:	020c0263          	beqz	s8,bbe <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
 b9e:	864a                	mv	a2,s2
 ba0:	85da                	mv	a1,s6
 ba2:	00000517          	auipc	a0,0x0
 ba6:	3ee50513          	addi	a0,a0,1006 # f90 <digits+0x70>
 baa:	00000097          	auipc	ra,0x0
 bae:	c66080e7          	jalr	-922(ra) # 810 <printf>
 bb2:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 bb4:	8926                	mv	s2,s1
 bb6:	84be                	mv	s1,a5
        isRepeated = 0 ;
 bb8:	4b81                	li	s7,0
        lineCount = 1;
 bba:	8b6a                	mv	s6,s10
 bbc:	a00d                	j	bde <uniq_run+0x1a8>
              printf("%s",line1);
 bbe:	85ca                	mv	a1,s2
 bc0:	856e                	mv	a0,s11
 bc2:	00000097          	auipc	ra,0x0
 bc6:	c4e080e7          	jalr	-946(ra) # 810 <printf>
 bca:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 bcc:	8926                	mv	s2,s1
              printf("%s",line1);
 bce:	84be                	mv	s1,a5
        isRepeated = 0 ;
 bd0:	4b81                	li	s7,0
        lineCount = 1;
 bd2:	8b6a                	mv	s6,s10
 bd4:	a029                	j	bde <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
 bd6:	000a0363          	beqz	s4,bdc <uniq_run+0x1a6>
 bda:	8bea                	mv	s7,s10
          lineCount++;
 bdc:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
 bde:	85a6                	mv	a1,s1
 be0:	854e                	mv	a0,s3
 be2:	00000097          	auipc	ra,0x0
 be6:	196080e7          	jalr	406(ra) # d78 <read_line>
        if (readStatus == READ_EOF){
 bea:	d911                	beqz	a0,afe <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
 bec:	f7950be3          	beq	a0,s9,b62 <uniq_run+0x12c>
        if (!ignoreCase)
 bf0:	f80a92e3          	bnez	s5,b74 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
 bf4:	85a6                	mv	a1,s1
 bf6:	854a                	mv	a0,s2
 bf8:	00000097          	auipc	ra,0x0
 bfc:	062080e7          	jalr	98(ra) # c5a <compare_str>
        if (compareStatus != 0){ 
 c00:	d979                	beqz	a0,bd6 <uniq_run+0x1a0>
          if (repeatedLines){
 c02:	f80a0ce3          	beqz	s4,b9a <uniq_run+0x164>
            if (isRepeated){
 c06:	ec0b8be3          	beqz	s7,adc <uniq_run+0xa6>
                if (showCount)
 c0a:	f60c0ce3          	beqz	s8,b82 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
 c0e:	864a                	mv	a2,s2
 c10:	85da                	mv	a1,s6
 c12:	00000517          	auipc	a0,0x0
 c16:	37e50513          	addi	a0,a0,894 # f90 <digits+0x70>
 c1a:	00000097          	auipc	ra,0x0
 c1e:	bf6080e7          	jalr	-1034(ra) # 810 <printf>
        lineCount = 1;
 c22:	8b5e                	mv	s6,s7
 c24:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
 c26:	8926                	mv	s2,s1
 c28:	84be                	mv	s1,a5
        isRepeated = 0 ;
 c2a:	4b81                	li	s7,0
 c2c:	bf4d                	j	bde <uniq_run+0x1a8>

0000000000000c2e <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
 c2e:	1141                	addi	sp,sp,-16
 c30:	e422                	sd	s0,8(sp)
 c32:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
 c34:	00054783          	lbu	a5,0(a0)
 c38:	cf99                	beqz	a5,c56 <get_strlen+0x28>
 c3a:	00150713          	addi	a4,a0,1
 c3e:	87ba                	mv	a5,a4
 c40:	4685                	li	a3,1
 c42:	9e99                	subw	a3,a3,a4
 c44:	00f6853b          	addw	a0,a3,a5
 c48:	0785                	addi	a5,a5,1
 c4a:	fff7c703          	lbu	a4,-1(a5)
 c4e:	fb7d                	bnez	a4,c44 <get_strlen+0x16>
	return len;
}
 c50:	6422                	ld	s0,8(sp)
 c52:	0141                	addi	sp,sp,16
 c54:	8082                	ret
	int len = 0;
 c56:	4501                	li	a0,0
 c58:	bfe5                	j	c50 <get_strlen+0x22>

0000000000000c5a <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
 c5a:	1141                	addi	sp,sp,-16
 c5c:	e422                	sd	s0,8(sp)
 c5e:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 c60:	00054783          	lbu	a5,0(a0)
 c64:	cb91                	beqz	a5,c78 <compare_str+0x1e>
 c66:	0005c703          	lbu	a4,0(a1)
 c6a:	c719                	beqz	a4,c78 <compare_str+0x1e>
		if (*s1++ != *s2++)
 c6c:	0505                	addi	a0,a0,1
 c6e:	0585                	addi	a1,a1,1
 c70:	fee788e3          	beq	a5,a4,c60 <compare_str+0x6>
			return 1;
 c74:	4505                	li	a0,1
 c76:	a031                	j	c82 <compare_str+0x28>
	}
	if (*s1 == *s2)
 c78:	0005c503          	lbu	a0,0(a1)
 c7c:	8d1d                	sub	a0,a0,a5
			return 1;
 c7e:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 c82:	6422                	ld	s0,8(sp)
 c84:	0141                	addi	sp,sp,16
 c86:	8082                	ret

0000000000000c88 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
 c88:	1141                	addi	sp,sp,-16
 c8a:	e422                	sd	s0,8(sp)
 c8c:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 c8e:	4665                	li	a2,25
	while(*s1 && *s2){
 c90:	a019                	j	c96 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 c92:	04e79763          	bne	a5,a4,ce0 <compare_str_ic+0x58>
	while(*s1 && *s2){
 c96:	00054783          	lbu	a5,0(a0)
 c9a:	cb9d                	beqz	a5,cd0 <compare_str_ic+0x48>
 c9c:	0005c703          	lbu	a4,0(a1)
 ca0:	cb05                	beqz	a4,cd0 <compare_str_ic+0x48>
		char b1 = *s1++;
 ca2:	0505                	addi	a0,a0,1
		char b2 = *s2++;
 ca4:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 ca6:	fbf7869b          	addiw	a3,a5,-65
 caa:	0ff6f693          	zext.b	a3,a3
 cae:	00d66663          	bltu	a2,a3,cba <compare_str_ic+0x32>
			b1 += 32;
 cb2:	0207879b          	addiw	a5,a5,32
 cb6:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 cba:	fbf7069b          	addiw	a3,a4,-65
 cbe:	0ff6f693          	zext.b	a3,a3
 cc2:	fcd668e3          	bltu	a2,a3,c92 <compare_str_ic+0xa>
			b2 += 32;
 cc6:	0207071b          	addiw	a4,a4,32
 cca:	0ff77713          	zext.b	a4,a4
 cce:	b7d1                	j	c92 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 cd0:	0005c503          	lbu	a0,0(a1)
 cd4:	8d1d                	sub	a0,a0,a5
			return 1;
 cd6:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 cda:	6422                	ld	s0,8(sp)
 cdc:	0141                	addi	sp,sp,16
 cde:	8082                	ret
			return 1;
 ce0:	4505                	li	a0,1
 ce2:	bfe5                	j	cda <compare_str_ic+0x52>

0000000000000ce4 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
 ce4:	7179                	addi	sp,sp,-48
 ce6:	f406                	sd	ra,40(sp)
 ce8:	f022                	sd	s0,32(sp)
 cea:	ec26                	sd	s1,24(sp)
 cec:	e84a                	sd	s2,16(sp)
 cee:	e44e                	sd	s3,8(sp)
 cf0:	1800                	addi	s0,sp,48
 cf2:	89aa                	mv	s3,a0
 cf4:	892e                	mv	s2,a1
    int M = get_strlen(s1);
 cf6:	00000097          	auipc	ra,0x0
 cfa:	f38080e7          	jalr	-200(ra) # c2e <get_strlen>
 cfe:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
 d00:	854a                	mv	a0,s2
 d02:	00000097          	auipc	ra,0x0
 d06:	f2c080e7          	jalr	-212(ra) # c2e <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
 d0a:	409505bb          	subw	a1,a0,s1
 d0e:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
 d10:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
 d12:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
 d14:	0005da63          	bgez	a1,d28 <check_substr+0x44>
 d18:	a81d                	j	d4e <check_substr+0x6a>
        if (j == M)
 d1a:	02f48a63          	beq	s1,a5,d4e <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
 d1e:	0885                	addi	a7,a7,1
 d20:	0008879b          	sext.w	a5,a7
 d24:	02f5cc63          	blt	a1,a5,d5c <check_substr+0x78>
 d28:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
 d2c:	011906b3          	add	a3,s2,a7
 d30:	874e                	mv	a4,s3
 d32:	879a                	mv	a5,t1
 d34:	fe9053e3          	blez	s1,d1a <check_substr+0x36>
            if (s2[i + j] != s1[j])
 d38:	0006c803          	lbu	a6,0(a3) # 1000 <freep>
 d3c:	00074603          	lbu	a2,0(a4)
 d40:	fcc81de3          	bne	a6,a2,d1a <check_substr+0x36>
        for (j = 0; j < M; j++)
 d44:	2785                	addiw	a5,a5,1
 d46:	0685                	addi	a3,a3,1
 d48:	0705                	addi	a4,a4,1
 d4a:	fef497e3          	bne	s1,a5,d38 <check_substr+0x54>
}
 d4e:	70a2                	ld	ra,40(sp)
 d50:	7402                	ld	s0,32(sp)
 d52:	64e2                	ld	s1,24(sp)
 d54:	6942                	ld	s2,16(sp)
 d56:	69a2                	ld	s3,8(sp)
 d58:	6145                	addi	sp,sp,48
 d5a:	8082                	ret
    return -1;
 d5c:	557d                	li	a0,-1
 d5e:	bfc5                	j	d4e <check_substr+0x6a>

0000000000000d60 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
 d60:	1141                	addi	sp,sp,-16
 d62:	e406                	sd	ra,8(sp)
 d64:	e022                	sd	s0,0(sp)
 d66:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
 d68:	fffff097          	auipc	ra,0xfffff
 d6c:	746080e7          	jalr	1862(ra) # 4ae <open>
	return fd;
}
 d70:	60a2                	ld	ra,8(sp)
 d72:	6402                	ld	s0,0(sp)
 d74:	0141                	addi	sp,sp,16
 d76:	8082                	ret

0000000000000d78 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
 d78:	7139                	addi	sp,sp,-64
 d7a:	fc06                	sd	ra,56(sp)
 d7c:	f822                	sd	s0,48(sp)
 d7e:	f426                	sd	s1,40(sp)
 d80:	f04a                	sd	s2,32(sp)
 d82:	ec4e                	sd	s3,24(sp)
 d84:	e852                	sd	s4,16(sp)
 d86:	0080                	addi	s0,sp,64
 d88:	89aa                	mv	s3,a0
 d8a:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
 d8c:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
 d8e:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
 d90:	4605                	li	a2,1
 d92:	fcf40593          	addi	a1,s0,-49
 d96:	854e                	mv	a0,s3
 d98:	fffff097          	auipc	ra,0xfffff
 d9c:	6ee080e7          	jalr	1774(ra) # 486 <read>
		if (readStatus == 0){
 da0:	c505                	beqz	a0,dc8 <read_line+0x50>
		*buffer++ = readByte;
 da2:	0485                	addi	s1,s1,1
 da4:	fcf44783          	lbu	a5,-49(s0)
 da8:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
 dac:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
 dae:	ff4791e3          	bne	a5,s4,d90 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
 db2:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
 db6:	854a                	mv	a0,s2
 db8:	70e2                	ld	ra,56(sp)
 dba:	7442                	ld	s0,48(sp)
 dbc:	74a2                	ld	s1,40(sp)
 dbe:	7902                	ld	s2,32(sp)
 dc0:	69e2                	ld	s3,24(sp)
 dc2:	6a42                	ld	s4,16(sp)
 dc4:	6121                	addi	sp,sp,64
 dc6:	8082                	ret
			if (byteCount!=0){
 dc8:	fe0907e3          	beqz	s2,db6 <read_line+0x3e>
				*buffer = '\n';
 dcc:	47a9                	li	a5,10
 dce:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
 dd2:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
 dd6:	2905                	addiw	s2,s2,1
 dd8:	bff9                	j	db6 <read_line+0x3e>

0000000000000dda <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
 dda:	1141                	addi	sp,sp,-16
 ddc:	e406                	sd	ra,8(sp)
 dde:	e022                	sd	s0,0(sp)
 de0:	0800                	addi	s0,sp,16
	close(fd);
 de2:	fffff097          	auipc	ra,0xfffff
 de6:	6b4080e7          	jalr	1716(ra) # 496 <close>
}
 dea:	60a2                	ld	ra,8(sp)
 dec:	6402                	ld	s0,0(sp)
 dee:	0141                	addi	sp,sp,16
 df0:	8082                	ret

0000000000000df2 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
 df2:	7139                	addi	sp,sp,-64
 df4:	fc06                	sd	ra,56(sp)
 df6:	f822                	sd	s0,48(sp)
 df8:	f426                	sd	s1,40(sp)
 dfa:	f04a                	sd	s2,32(sp)
 dfc:	0080                	addi	s0,sp,64
 dfe:	84aa                	mv	s1,a0
 e00:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
 e02:	fffff097          	auipc	ra,0xfffff
 e06:	664080e7          	jalr	1636(ra) # 466 <fork>
 e0a:	ed19                	bnez	a0,e28 <get_time_perf+0x36>
		exec(argv[0],argv);
 e0c:	85ca                	mv	a1,s2
 e0e:	00093503          	ld	a0,0(s2)
 e12:	fffff097          	auipc	ra,0xfffff
 e16:	694080e7          	jalr	1684(ra) # 4a6 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
 e1a:	8526                	mv	a0,s1
 e1c:	70e2                	ld	ra,56(sp)
 e1e:	7442                	ld	s0,48(sp)
 e20:	74a2                	ld	s1,40(sp)
 e22:	7902                	ld	s2,32(sp)
 e24:	6121                	addi	sp,sp,64
 e26:	8082                	ret
		times(pid , &time);
 e28:	fc840593          	addi	a1,s0,-56
 e2c:	fffff097          	auipc	ra,0xfffff
 e30:	6fa080e7          	jalr	1786(ra) # 526 <times>
		return time;
 e34:	fc843783          	ld	a5,-56(s0)
 e38:	e09c                	sd	a5,0(s1)
 e3a:	fd043783          	ld	a5,-48(s0)
 e3e:	e49c                	sd	a5,8(s1)
 e40:	fd843783          	ld	a5,-40(s0)
 e44:	e89c                	sd	a5,16(s1)
 e46:	bfd1                	j	e1a <get_time_perf+0x28>
