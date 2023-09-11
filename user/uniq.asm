
user/_uniq:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

u32 uniq_run(s32 fd, u8 ignoreCase, u8 showCount, u8 repeatedLines);
static u8 ** parse_cmd(u32 argc, u8 ** cmd, u8 * options);


s32 main(s32 argc, u8 ** argv){
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
static u8 ** parse_cmd(u32 argc, u8 ** cmd, u8 * options){


	/* Total number of files is maximum argc-1 requiring argc size storage for the last NULL*/
	u8 ** passedFiles = malloc(sizeof(u8 *) * (argc));
  18:	0035151b          	slliw	a0,a0,0x3
  1c:	00001097          	auipc	ra,0x1
  20:	954080e7          	jalr	-1708(ra) # 970 <malloc>

	if (!passedFiles)
  24:	c14d                	beqz	a0,c6 <main+0xc6>
  26:	8a2a                	mv	s4,a0


	*options = 0;
	u32 fileIdx = 0;

	cmd++;  // Skipping the program's name
  28:	00890493          	addi	s1,s2,8
	
	while(*cmd){
  2c:	00893503          	ld	a0,8(s2)
  30:	c925                	beqz	a0,a0 <main+0xa0>
	*options = 0;
  32:	4901                	li	s2,0
	u32 fileIdx = 0;
  34:	4b01                	li	s6,0
		if (!compare_str(cmd[0], "-c"))
  36:	00001997          	auipc	s3,0x1
  3a:	bba98993          	addi	s3,s3,-1094 # bf0 <compare_str_ic+0x5c>
			*options |= OPT_SHOW_COUNT;
		else if (!compare_str(cmd[0], "-i"))
  3e:	00001a97          	auipc	s5,0x1
  42:	bbaa8a93          	addi	s5,s5,-1094 # bf8 <compare_str_ic+0x64>
			*options |= OPT_IGNORE_CASE;
		else if (!compare_str(cmd[0], "-d"))
  46:	00001b97          	auipc	s7,0x1
  4a:	bbab8b93          	addi	s7,s7,-1094 # c00 <compare_str_ic+0x6c>
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
  58:	c529                	beqz	a0,a2 <main+0xa2>
		if (!compare_str(cmd[0], "-c"))
  5a:	85ce                	mv	a1,s3
  5c:	00001097          	auipc	ra,0x1
  60:	b0a080e7          	jalr	-1270(ra) # b66 <compare_str>
  64:	d575                	beqz	a0,50 <main+0x50>
		else if (!compare_str(cmd[0], "-i"))
  66:	85d6                	mv	a1,s5
  68:	6088                	ld	a0,0(s1)
  6a:	00001097          	auipc	ra,0x1
  6e:	afc080e7          	jalr	-1284(ra) # b66 <compare_str>
  72:	e501                	bnez	a0,7a <main+0x7a>
			*options |= OPT_IGNORE_CASE;
  74:	00196913          	ori	s2,s2,1
  78:	bff1                	j	54 <main+0x54>
		else if (!compare_str(cmd[0], "-d"))
  7a:	85de                	mv	a1,s7
  7c:	6088                	ld	a0,0(s1)
  7e:	00001097          	auipc	ra,0x1
  82:	ae8080e7          	jalr	-1304(ra) # b66 <compare_str>
  86:	e501                	bnez	a0,8e <main+0x8e>
			*options |= OPT_SHOW_REPEATED_LINES;
  88:	00496913          	ori	s2,s2,4
  8c:	b7e1                	j	54 <main+0x54>
			passedFiles[fileIdx++] = cmd[0];
  8e:	6098                	ld	a4,0(s1)
  90:	020b1693          	slli	a3,s6,0x20
  94:	01d6d793          	srli	a5,a3,0x1d
  98:	97d2                	add	a5,a5,s4
  9a:	e398                	sd	a4,0(a5)
  9c:	2b05                	addiw	s6,s6,1
  9e:	bf5d                	j	54 <main+0x54>
	*options = 0;
  a0:	4901                	li	s2,0
	uniq(passedFiles,options);
  a2:	85ca                	mv	a1,s2
  a4:	8552                	mv	a0,s4
  a6:	00000097          	auipc	ra,0x0
  aa:	530080e7          	jalr	1328(ra) # 5d6 <uniq>
	return 0;
  ae:	4501                	li	a0,0
}
  b0:	60a6                	ld	ra,72(sp)
  b2:	6406                	ld	s0,64(sp)
  b4:	74e2                	ld	s1,56(sp)
  b6:	7942                	ld	s2,48(sp)
  b8:	79a2                	ld	s3,40(sp)
  ba:	7a02                	ld	s4,32(sp)
  bc:	6ae2                	ld	s5,24(sp)
  be:	6b42                	ld	s6,16(sp)
  c0:	6ba2                	ld	s7,8(sp)
  c2:	6161                	addi	sp,sp,80
  c4:	8082                	ret
		print("[ERR] Cannot parse the cmd");
  c6:	00001517          	auipc	a0,0x1
  ca:	b4250513          	addi	a0,a0,-1214 # c08 <compare_str_ic+0x74>
  ce:	00001097          	auipc	ra,0x1
  d2:	9b4080e7          	jalr	-1612(ra) # a82 <print>
		return 1;
  d6:	4505                	li	a0,1
  d8:	bfe1                	j	b0 <main+0xb0>

00000000000000da <uniq_run>:





u32 uniq_run(s32 fd, u8 ignoreCase, u8 showCount, u8 repeatedLines){
  da:	7159                	addi	sp,sp,-112
  dc:	f486                	sd	ra,104(sp)
  de:	f0a2                	sd	s0,96(sp)
  e0:	eca6                	sd	s1,88(sp)
  e2:	e8ca                	sd	s2,80(sp)
  e4:	e4ce                	sd	s3,72(sp)
  e6:	e0d2                	sd	s4,64(sp)
  e8:	fc56                	sd	s5,56(sp)
  ea:	f85a                	sd	s6,48(sp)
  ec:	f45e                	sd	s7,40(sp)
  ee:	f062                	sd	s8,32(sp)
  f0:	ec66                	sd	s9,24(sp)
  f2:	e86a                	sd	s10,16(sp)
  f4:	e46e                	sd	s11,8(sp)
  f6:	1880                	addi	s0,sp,112
  f8:	8aaa                	mv	s5,a0
  fa:	8b2e                	mv	s6,a1
  fc:	8c32                	mv	s8,a2


	u8 * line1 = malloc(500);
  fe:	1f400513          	li	a0,500
 102:	00001097          	auipc	ra,0x1
 106:	86e080e7          	jalr	-1938(ra) # 970 <malloc>
 10a:	892a                	mv	s2,a0
	u8 * line2 = malloc(500);
 10c:	1f400513          	li	a0,500
 110:	00001097          	auipc	ra,0x1
 114:	860080e7          	jalr	-1952(ra) # 970 <malloc>
 118:	84aa                	mv	s1,a0
	
	s64 readStatus;

	readStatus = read_line(fd, line1);
 11a:	85ca                	mv	a1,s2
 11c:	8556                	mv	a0,s5
 11e:	00001097          	auipc	ra,0x1
 122:	9aa080e7          	jalr	-1622(ra) # ac8 <read_line>
	if (readStatus == READ_EOF || readStatus == READ_ERROR)
 126:	00150713          	addi	a4,a0,1
 12a:	4785                	li	a5,1
 12c:	02e7f563          	bgeu	a5,a4,156 <uniq_run+0x7c>
		return 0;
	line1[readStatus]=0;
 130:	954a                	add	a0,a0,s2
 132:	00050023          	sb	zero,0(a0)

	u8 first = 1;
	u32 count=1;
 136:	4a05                	li	s4,1
	u8 first = 1;
 138:	4b85                	li	s7,1

	while(1){

		readStatus = read_line(fd, line2);
		if (readStatus == READ_EOF || readStatus == READ_ERROR)
 13a:	4985                	li	s3,1
				first=0;
			}
			if (showCount)
				printf("<%d> %s",count,line2);
			else
				printf("<> %s",line2);
 13c:	00001c97          	auipc	s9,0x1
 140:	af4c8c93          	addi	s9,s9,-1292 # c30 <compare_str_ic+0x9c>
				printf("<%d> %s",count,line2);
 144:	00001d17          	auipc	s10,0x1
 148:	af4d0d13          	addi	s10,s10,-1292 # c38 <compare_str_ic+0xa4>
					printf("%d %s",count,line1);
 14c:	00001d97          	auipc	s11,0x1
 150:	adcd8d93          	addi	s11,s11,-1316 # c28 <compare_str_ic+0x94>
 154:	a0ad                	j	1be <uniq_run+0xe4>
		return 0;
 156:	4501                	li	a0,0
			// print(line1);
			// print(line2);
			count++;
		}
	}
}
 158:	70a6                	ld	ra,104(sp)
 15a:	7406                	ld	s0,96(sp)
 15c:	64e6                	ld	s1,88(sp)
 15e:	6946                	ld	s2,80(sp)
 160:	69a6                	ld	s3,72(sp)
 162:	6a06                	ld	s4,64(sp)
 164:	7ae2                	ld	s5,56(sp)
 166:	7b42                	ld	s6,48(sp)
 168:	7ba2                	ld	s7,40(sp)
 16a:	7c02                	ld	s8,32(sp)
 16c:	6ce2                	ld	s9,24(sp)
 16e:	6d42                	ld	s10,16(sp)
 170:	6da2                	ld	s11,8(sp)
 172:	6165                	addi	sp,sp,112
 174:	8082                	ret
			compareStatus = compare_str_ic(line1, line2);
 176:	85a6                	mv	a1,s1
 178:	854a                	mv	a0,s2
 17a:	00001097          	auipc	ra,0x1
 17e:	a1a080e7          	jalr	-1510(ra) # b94 <compare_str_ic>
 182:	a09d                	j	1e8 <uniq_run+0x10e>
				if (showCount)
 184:	000c0a63          	beqz	s8,198 <uniq_run+0xbe>
					printf("%d %s",count,line1);
 188:	864a                	mv	a2,s2
 18a:	85d2                	mv	a1,s4
 18c:	856e                	mv	a0,s11
 18e:	00000097          	auipc	ra,0x0
 192:	72a080e7          	jalr	1834(ra) # 8b8 <printf>
			if (showCount)
 196:	a8b1                	j	1f2 <uniq_run+0x118>
					printf("<> %s",line1);
 198:	85ca                	mv	a1,s2
 19a:	8566                	mv	a0,s9
 19c:	00000097          	auipc	ra,0x0
 1a0:	71c080e7          	jalr	1820(ra) # 8b8 <printf>
				printf("<> %s",line2);
 1a4:	85a6                	mv	a1,s1
 1a6:	8566                	mv	a0,s9
 1a8:	00000097          	auipc	ra,0x0
 1ac:	710080e7          	jalr	1808(ra) # 8b8 <printf>
 1b0:	87ca                	mv	a5,s2
			line1 = line2;
 1b2:	8926                	mv	s2,s1
			line2 = t;
 1b4:	84be                	mv	s1,a5
			count = 1;
 1b6:	8a4e                	mv	s4,s3
				printf("<> %s",line2);
 1b8:	4b81                	li	s7,0
 1ba:	a011                	j	1be <uniq_run+0xe4>
			count++;
 1bc:	2a05                	addiw	s4,s4,1
		readStatus = read_line(fd, line2);
 1be:	85a6                	mv	a1,s1
 1c0:	8556                	mv	a0,s5
 1c2:	00001097          	auipc	ra,0x1
 1c6:	906080e7          	jalr	-1786(ra) # ac8 <read_line>
		if (readStatus == READ_EOF || readStatus == READ_ERROR)
 1ca:	00150793          	addi	a5,a0,1
 1ce:	f8f9f5e3          	bgeu	s3,a5,158 <uniq_run+0x7e>
		line2[readStatus]=0;
 1d2:	9526                	add	a0,a0,s1
 1d4:	00050023          	sb	zero,0(a0)
		if (!ignoreCase)
 1d8:	f80b1fe3          	bnez	s6,176 <uniq_run+0x9c>
			compareStatus = compare_str(line1, line2);
 1dc:	85a6                	mv	a1,s1
 1de:	854a                	mv	a0,s2
 1e0:	00001097          	auipc	ra,0x1
 1e4:	986080e7          	jalr	-1658(ra) # b66 <compare_str>
		if (compareStatus != 0){
 1e8:	d971                	beqz	a0,1bc <uniq_run+0xe2>
			if (first==1){
 1ea:	f93b8de3          	beq	s7,s3,184 <uniq_run+0xaa>
			if (showCount)
 1ee:	fa0c0be3          	beqz	s8,1a4 <uniq_run+0xca>
				printf("<%d> %s",count,line2);
 1f2:	8626                	mv	a2,s1
 1f4:	85d2                	mv	a1,s4
 1f6:	856a                	mv	a0,s10
 1f8:	00000097          	auipc	ra,0x0
 1fc:	6c0080e7          	jalr	1728(ra) # 8b8 <printf>
 200:	87ca                	mv	a5,s2
			line1 = line2;
 202:	8926                	mv	s2,s1
			line2 = t;
 204:	84be                	mv	s1,a5
			count = 1;
 206:	8a4e                	mv	s4,s3
 208:	4b81                	li	s7,0
 20a:	bf55                	j	1be <uniq_run+0xe4>

000000000000020c <uniq_usermode>:
u32 uniq_usermode(u8 **passedFiles, u8 options){
 20c:	7139                	addi	sp,sp,-64
 20e:	fc06                	sd	ra,56(sp)
 210:	f822                	sd	s0,48(sp)
 212:	f426                	sd	s1,40(sp)
 214:	f04a                	sd	s2,32(sp)
 216:	ec4e                	sd	s3,24(sp)
 218:	e852                	sd	s4,16(sp)
 21a:	e456                	sd	s5,8(sp)
 21c:	e05a                	sd	s6,0(sp)
 21e:	0080                	addi	s0,sp,64
 220:	84aa                	mv	s1,a0
 222:	892e                	mv	s2,a1
	printf("Uniq command is getting executed in user mode\n");
 224:	00001517          	auipc	a0,0x1
 228:	a1c50513          	addi	a0,a0,-1508 # c40 <compare_str_ic+0xac>
 22c:	00000097          	auipc	ra,0x0
 230:	68c080e7          	jalr	1676(ra) # 8b8 <printf>
	if(!passedFiles[0])
 234:	6088                	ld	a0,0(s1)
 236:	cd09                	beqz	a0,250 <uniq_usermode+0x44>
			if (fd == OPEN_FILE_ERROR)
 238:	59fd                	li	s3,-1
				uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
 23a:	00497a93          	andi	s5,s2,4
 23e:	00297a13          	andi	s4,s2,2
 242:	00197913          	andi	s2,s2,1
				print("Error opening the file \n");
 246:	00001b17          	auipc	s6,0x1
 24a:	a2ab0b13          	addi	s6,s6,-1494 # c70 <compare_str_ic+0xdc>
 24e:	a081                	j	28e <uniq_usermode+0x82>
		uniq_run(STDIN, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
 250:	00497693          	andi	a3,s2,4
 254:	00297613          	andi	a2,s2,2
 258:	00197593          	andi	a1,s2,1
 25c:	4501                	li	a0,0
 25e:	00000097          	auipc	ra,0x0
 262:	e7c080e7          	jalr	-388(ra) # da <uniq_run>
}
 266:	70e2                	ld	ra,56(sp)
 268:	7442                	ld	s0,48(sp)
 26a:	74a2                	ld	s1,40(sp)
 26c:	7902                	ld	s2,32(sp)
 26e:	69e2                	ld	s3,24(sp)
 270:	6a42                	ld	s4,16(sp)
 272:	6aa2                	ld	s5,8(sp)
 274:	6b02                	ld	s6,0(sp)
 276:	6121                	addi	sp,sp,64
 278:	8082                	ret
				uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
 27a:	86d6                	mv	a3,s5
 27c:	8652                	mv	a2,s4
 27e:	85ca                	mv	a1,s2
 280:	00000097          	auipc	ra,0x0
 284:	e5a080e7          	jalr	-422(ra) # da <uniq_run>
			passedFiles++;
 288:	04a1                	addi	s1,s1,8
		while (*passedFiles){
 28a:	6088                	ld	a0,0(s1)
 28c:	dd69                	beqz	a0,266 <uniq_usermode+0x5a>
			u32 fd = open_file(*passedFiles, RDONLY);
 28e:	4581                	li	a1,0
 290:	00001097          	auipc	ra,0x1
 294:	820080e7          	jalr	-2016(ra) # ab0 <open_file>
			if (fd == OPEN_FILE_ERROR)
 298:	ff3511e3          	bne	a0,s3,27a <uniq_usermode+0x6e>
				print("Error opening the file \n");
 29c:	855a                	mv	a0,s6
 29e:	00000097          	auipc	ra,0x0
 2a2:	7e4080e7          	jalr	2020(ra) # a82 <print>
 2a6:	b7cd                	j	288 <uniq_usermode+0x7c>

00000000000002a8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2b0:	00000097          	auipc	ra,0x0
 2b4:	d50080e7          	jalr	-688(ra) # 0 <main>
  exit(0);
 2b8:	4501                	li	a0,0
 2ba:	00000097          	auipc	ra,0x0
 2be:	274080e7          	jalr	628(ra) # 52e <exit>

00000000000002c2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2c8:	87aa                	mv	a5,a0
 2ca:	0585                	addi	a1,a1,1
 2cc:	0785                	addi	a5,a5,1
 2ce:	fff5c703          	lbu	a4,-1(a1)
 2d2:	fee78fa3          	sb	a4,-1(a5)
 2d6:	fb75                	bnez	a4,2ca <strcpy+0x8>
    ;
  return os;
}
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	cb91                	beqz	a5,2fc <strcmp+0x1e>
 2ea:	0005c703          	lbu	a4,0(a1)
 2ee:	00f71763          	bne	a4,a5,2fc <strcmp+0x1e>
    p++, q++;
 2f2:	0505                	addi	a0,a0,1
 2f4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	fbe5                	bnez	a5,2ea <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2fc:	0005c503          	lbu	a0,0(a1)
}
 300:	40a7853b          	subw	a0,a5,a0
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret

000000000000030a <strlen>:

uint
strlen(const char *s)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 310:	00054783          	lbu	a5,0(a0)
 314:	cf91                	beqz	a5,330 <strlen+0x26>
 316:	0505                	addi	a0,a0,1
 318:	87aa                	mv	a5,a0
 31a:	4685                	li	a3,1
 31c:	9e89                	subw	a3,a3,a0
 31e:	00f6853b          	addw	a0,a3,a5
 322:	0785                	addi	a5,a5,1
 324:	fff7c703          	lbu	a4,-1(a5)
 328:	fb7d                	bnez	a4,31e <strlen+0x14>
    ;
  return n;
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  for(n = 0; s[n]; n++)
 330:	4501                	li	a0,0
 332:	bfe5                	j	32a <strlen+0x20>

0000000000000334 <memset>:

void*
memset(void *dst, int c, uint n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 33a:	ca19                	beqz	a2,350 <memset+0x1c>
 33c:	87aa                	mv	a5,a0
 33e:	1602                	slli	a2,a2,0x20
 340:	9201                	srli	a2,a2,0x20
 342:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 346:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 34a:	0785                	addi	a5,a5,1
 34c:	fee79de3          	bne	a5,a4,346 <memset+0x12>
  }
  return dst;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret

0000000000000356 <strchr>:

char*
strchr(const char *s, char c)
{
 356:	1141                	addi	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 35c:	00054783          	lbu	a5,0(a0)
 360:	cb99                	beqz	a5,376 <strchr+0x20>
    if(*s == c)
 362:	00f58763          	beq	a1,a5,370 <strchr+0x1a>
  for(; *s; s++)
 366:	0505                	addi	a0,a0,1
 368:	00054783          	lbu	a5,0(a0)
 36c:	fbfd                	bnez	a5,362 <strchr+0xc>
      return (char*)s;
  return 0;
 36e:	4501                	li	a0,0
}
 370:	6422                	ld	s0,8(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret
  return 0;
 376:	4501                	li	a0,0
 378:	bfe5                	j	370 <strchr+0x1a>

000000000000037a <gets>:

char*
gets(char *buf, int max)
{
 37a:	711d                	addi	sp,sp,-96
 37c:	ec86                	sd	ra,88(sp)
 37e:	e8a2                	sd	s0,80(sp)
 380:	e4a6                	sd	s1,72(sp)
 382:	e0ca                	sd	s2,64(sp)
 384:	fc4e                	sd	s3,56(sp)
 386:	f852                	sd	s4,48(sp)
 388:	f456                	sd	s5,40(sp)
 38a:	f05a                	sd	s6,32(sp)
 38c:	ec5e                	sd	s7,24(sp)
 38e:	1080                	addi	s0,sp,96
 390:	8baa                	mv	s7,a0
 392:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 394:	892a                	mv	s2,a0
 396:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 398:	4aa9                	li	s5,10
 39a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 39c:	89a6                	mv	s3,s1
 39e:	2485                	addiw	s1,s1,1
 3a0:	0344d863          	bge	s1,s4,3d0 <gets+0x56>
    cc = read(0, &c, 1);
 3a4:	4605                	li	a2,1
 3a6:	faf40593          	addi	a1,s0,-81
 3aa:	4501                	li	a0,0
 3ac:	00000097          	auipc	ra,0x0
 3b0:	19a080e7          	jalr	410(ra) # 546 <read>
    if(cc < 1)
 3b4:	00a05e63          	blez	a0,3d0 <gets+0x56>
    buf[i++] = c;
 3b8:	faf44783          	lbu	a5,-81(s0)
 3bc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3c0:	01578763          	beq	a5,s5,3ce <gets+0x54>
 3c4:	0905                	addi	s2,s2,1
 3c6:	fd679be3          	bne	a5,s6,39c <gets+0x22>
  for(i=0; i+1 < max; ){
 3ca:	89a6                	mv	s3,s1
 3cc:	a011                	j	3d0 <gets+0x56>
 3ce:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3d0:	99de                	add	s3,s3,s7
 3d2:	00098023          	sb	zero,0(s3)
  return buf;
}
 3d6:	855e                	mv	a0,s7
 3d8:	60e6                	ld	ra,88(sp)
 3da:	6446                	ld	s0,80(sp)
 3dc:	64a6                	ld	s1,72(sp)
 3de:	6906                	ld	s2,64(sp)
 3e0:	79e2                	ld	s3,56(sp)
 3e2:	7a42                	ld	s4,48(sp)
 3e4:	7aa2                	ld	s5,40(sp)
 3e6:	7b02                	ld	s6,32(sp)
 3e8:	6be2                	ld	s7,24(sp)
 3ea:	6125                	addi	sp,sp,96
 3ec:	8082                	ret

00000000000003ee <stat>:

int
stat(const char *n, struct stat *st)
{
 3ee:	1101                	addi	sp,sp,-32
 3f0:	ec06                	sd	ra,24(sp)
 3f2:	e822                	sd	s0,16(sp)
 3f4:	e426                	sd	s1,8(sp)
 3f6:	e04a                	sd	s2,0(sp)
 3f8:	1000                	addi	s0,sp,32
 3fa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3fc:	4581                	li	a1,0
 3fe:	00000097          	auipc	ra,0x0
 402:	170080e7          	jalr	368(ra) # 56e <open>
  if(fd < 0)
 406:	02054563          	bltz	a0,430 <stat+0x42>
 40a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 40c:	85ca                	mv	a1,s2
 40e:	00000097          	auipc	ra,0x0
 412:	178080e7          	jalr	376(ra) # 586 <fstat>
 416:	892a                	mv	s2,a0
  close(fd);
 418:	8526                	mv	a0,s1
 41a:	00000097          	auipc	ra,0x0
 41e:	13c080e7          	jalr	316(ra) # 556 <close>
  return r;
}
 422:	854a                	mv	a0,s2
 424:	60e2                	ld	ra,24(sp)
 426:	6442                	ld	s0,16(sp)
 428:	64a2                	ld	s1,8(sp)
 42a:	6902                	ld	s2,0(sp)
 42c:	6105                	addi	sp,sp,32
 42e:	8082                	ret
    return -1;
 430:	597d                	li	s2,-1
 432:	bfc5                	j	422 <stat+0x34>

0000000000000434 <atoi>:

int
atoi(const char *s)
{
 434:	1141                	addi	sp,sp,-16
 436:	e422                	sd	s0,8(sp)
 438:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 43a:	00054683          	lbu	a3,0(a0)
 43e:	fd06879b          	addiw	a5,a3,-48
 442:	0ff7f793          	zext.b	a5,a5
 446:	4625                	li	a2,9
 448:	02f66863          	bltu	a2,a5,478 <atoi+0x44>
 44c:	872a                	mv	a4,a0
  n = 0;
 44e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 450:	0705                	addi	a4,a4,1
 452:	0025179b          	slliw	a5,a0,0x2
 456:	9fa9                	addw	a5,a5,a0
 458:	0017979b          	slliw	a5,a5,0x1
 45c:	9fb5                	addw	a5,a5,a3
 45e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 462:	00074683          	lbu	a3,0(a4)
 466:	fd06879b          	addiw	a5,a3,-48
 46a:	0ff7f793          	zext.b	a5,a5
 46e:	fef671e3          	bgeu	a2,a5,450 <atoi+0x1c>
  return n;
}
 472:	6422                	ld	s0,8(sp)
 474:	0141                	addi	sp,sp,16
 476:	8082                	ret
  n = 0;
 478:	4501                	li	a0,0
 47a:	bfe5                	j	472 <atoi+0x3e>

000000000000047c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 47c:	1141                	addi	sp,sp,-16
 47e:	e422                	sd	s0,8(sp)
 480:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 482:	02b57463          	bgeu	a0,a1,4aa <memmove+0x2e>
    while(n-- > 0)
 486:	00c05f63          	blez	a2,4a4 <memmove+0x28>
 48a:	1602                	slli	a2,a2,0x20
 48c:	9201                	srli	a2,a2,0x20
 48e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 492:	872a                	mv	a4,a0
      *dst++ = *src++;
 494:	0585                	addi	a1,a1,1
 496:	0705                	addi	a4,a4,1
 498:	fff5c683          	lbu	a3,-1(a1)
 49c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4a0:	fee79ae3          	bne	a5,a4,494 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4a4:	6422                	ld	s0,8(sp)
 4a6:	0141                	addi	sp,sp,16
 4a8:	8082                	ret
    dst += n;
 4aa:	00c50733          	add	a4,a0,a2
    src += n;
 4ae:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4b0:	fec05ae3          	blez	a2,4a4 <memmove+0x28>
 4b4:	fff6079b          	addiw	a5,a2,-1
 4b8:	1782                	slli	a5,a5,0x20
 4ba:	9381                	srli	a5,a5,0x20
 4bc:	fff7c793          	not	a5,a5
 4c0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4c2:	15fd                	addi	a1,a1,-1
 4c4:	177d                	addi	a4,a4,-1
 4c6:	0005c683          	lbu	a3,0(a1)
 4ca:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4ce:	fee79ae3          	bne	a5,a4,4c2 <memmove+0x46>
 4d2:	bfc9                	j	4a4 <memmove+0x28>

00000000000004d4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e422                	sd	s0,8(sp)
 4d8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4da:	ca05                	beqz	a2,50a <memcmp+0x36>
 4dc:	fff6069b          	addiw	a3,a2,-1
 4e0:	1682                	slli	a3,a3,0x20
 4e2:	9281                	srli	a3,a3,0x20
 4e4:	0685                	addi	a3,a3,1
 4e6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4e8:	00054783          	lbu	a5,0(a0)
 4ec:	0005c703          	lbu	a4,0(a1)
 4f0:	00e79863          	bne	a5,a4,500 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4f4:	0505                	addi	a0,a0,1
    p2++;
 4f6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4f8:	fed518e3          	bne	a0,a3,4e8 <memcmp+0x14>
  }
  return 0;
 4fc:	4501                	li	a0,0
 4fe:	a019                	j	504 <memcmp+0x30>
      return *p1 - *p2;
 500:	40e7853b          	subw	a0,a5,a4
}
 504:	6422                	ld	s0,8(sp)
 506:	0141                	addi	sp,sp,16
 508:	8082                	ret
  return 0;
 50a:	4501                	li	a0,0
 50c:	bfe5                	j	504 <memcmp+0x30>

000000000000050e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 50e:	1141                	addi	sp,sp,-16
 510:	e406                	sd	ra,8(sp)
 512:	e022                	sd	s0,0(sp)
 514:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 516:	00000097          	auipc	ra,0x0
 51a:	f66080e7          	jalr	-154(ra) # 47c <memmove>
}
 51e:	60a2                	ld	ra,8(sp)
 520:	6402                	ld	s0,0(sp)
 522:	0141                	addi	sp,sp,16
 524:	8082                	ret

0000000000000526 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 526:	4885                	li	a7,1
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <exit>:
.global exit
exit:
 li a7, SYS_exit
 52e:	4889                	li	a7,2
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <wait>:
.global wait
wait:
 li a7, SYS_wait
 536:	488d                	li	a7,3
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 53e:	4891                	li	a7,4
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <read>:
.global read
read:
 li a7, SYS_read
 546:	4895                	li	a7,5
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <write>:
.global write
write:
 li a7, SYS_write
 54e:	48c1                	li	a7,16
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <close>:
.global close
close:
 li a7, SYS_close
 556:	48d5                	li	a7,21
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <kill>:
.global kill
kill:
 li a7, SYS_kill
 55e:	4899                	li	a7,6
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <exec>:
.global exec
exec:
 li a7, SYS_exec
 566:	489d                	li	a7,7
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <open>:
.global open
open:
 li a7, SYS_open
 56e:	48bd                	li	a7,15
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 576:	48c5                	li	a7,17
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 57e:	48c9                	li	a7,18
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 586:	48a1                	li	a7,8
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <link>:
.global link
link:
 li a7, SYS_link
 58e:	48cd                	li	a7,19
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 596:	48d1                	li	a7,20
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 59e:	48a5                	li	a7,9
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5a6:	48a9                	li	a7,10
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ae:	48ad                	li	a7,11
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5b6:	48b1                	li	a7,12
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5be:	48b5                	li	a7,13
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5c6:	48b9                	li	a7,14
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <head>:
.global head
head:
 li a7, SYS_head
 5ce:	48d9                	li	a7,22
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
 5d6:	48dd                	li	a7,23
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5de:	1101                	addi	sp,sp,-32
 5e0:	ec06                	sd	ra,24(sp)
 5e2:	e822                	sd	s0,16(sp)
 5e4:	1000                	addi	s0,sp,32
 5e6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ea:	4605                	li	a2,1
 5ec:	fef40593          	addi	a1,s0,-17
 5f0:	00000097          	auipc	ra,0x0
 5f4:	f5e080e7          	jalr	-162(ra) # 54e <write>
}
 5f8:	60e2                	ld	ra,24(sp)
 5fa:	6442                	ld	s0,16(sp)
 5fc:	6105                	addi	sp,sp,32
 5fe:	8082                	ret

0000000000000600 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 600:	7139                	addi	sp,sp,-64
 602:	fc06                	sd	ra,56(sp)
 604:	f822                	sd	s0,48(sp)
 606:	f426                	sd	s1,40(sp)
 608:	f04a                	sd	s2,32(sp)
 60a:	ec4e                	sd	s3,24(sp)
 60c:	0080                	addi	s0,sp,64
 60e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 610:	c299                	beqz	a3,616 <printint+0x16>
 612:	0805c963          	bltz	a1,6a4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 616:	2581                	sext.w	a1,a1
  neg = 0;
 618:	4881                	li	a7,0
 61a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 61e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 620:	2601                	sext.w	a2,a2
 622:	00000517          	auipc	a0,0x0
 626:	6ce50513          	addi	a0,a0,1742 # cf0 <digits>
 62a:	883a                	mv	a6,a4
 62c:	2705                	addiw	a4,a4,1
 62e:	02c5f7bb          	remuw	a5,a1,a2
 632:	1782                	slli	a5,a5,0x20
 634:	9381                	srli	a5,a5,0x20
 636:	97aa                	add	a5,a5,a0
 638:	0007c783          	lbu	a5,0(a5)
 63c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 640:	0005879b          	sext.w	a5,a1
 644:	02c5d5bb          	divuw	a1,a1,a2
 648:	0685                	addi	a3,a3,1
 64a:	fec7f0e3          	bgeu	a5,a2,62a <printint+0x2a>
  if(neg)
 64e:	00088c63          	beqz	a7,666 <printint+0x66>
    buf[i++] = '-';
 652:	fd070793          	addi	a5,a4,-48
 656:	00878733          	add	a4,a5,s0
 65a:	02d00793          	li	a5,45
 65e:	fef70823          	sb	a5,-16(a4)
 662:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 666:	02e05863          	blez	a4,696 <printint+0x96>
 66a:	fc040793          	addi	a5,s0,-64
 66e:	00e78933          	add	s2,a5,a4
 672:	fff78993          	addi	s3,a5,-1
 676:	99ba                	add	s3,s3,a4
 678:	377d                	addiw	a4,a4,-1
 67a:	1702                	slli	a4,a4,0x20
 67c:	9301                	srli	a4,a4,0x20
 67e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 682:	fff94583          	lbu	a1,-1(s2)
 686:	8526                	mv	a0,s1
 688:	00000097          	auipc	ra,0x0
 68c:	f56080e7          	jalr	-170(ra) # 5de <putc>
  while(--i >= 0)
 690:	197d                	addi	s2,s2,-1
 692:	ff3918e3          	bne	s2,s3,682 <printint+0x82>
}
 696:	70e2                	ld	ra,56(sp)
 698:	7442                	ld	s0,48(sp)
 69a:	74a2                	ld	s1,40(sp)
 69c:	7902                	ld	s2,32(sp)
 69e:	69e2                	ld	s3,24(sp)
 6a0:	6121                	addi	sp,sp,64
 6a2:	8082                	ret
    x = -xx;
 6a4:	40b005bb          	negw	a1,a1
    neg = 1;
 6a8:	4885                	li	a7,1
    x = -xx;
 6aa:	bf85                	j	61a <printint+0x1a>

00000000000006ac <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ac:	7119                	addi	sp,sp,-128
 6ae:	fc86                	sd	ra,120(sp)
 6b0:	f8a2                	sd	s0,112(sp)
 6b2:	f4a6                	sd	s1,104(sp)
 6b4:	f0ca                	sd	s2,96(sp)
 6b6:	ecce                	sd	s3,88(sp)
 6b8:	e8d2                	sd	s4,80(sp)
 6ba:	e4d6                	sd	s5,72(sp)
 6bc:	e0da                	sd	s6,64(sp)
 6be:	fc5e                	sd	s7,56(sp)
 6c0:	f862                	sd	s8,48(sp)
 6c2:	f466                	sd	s9,40(sp)
 6c4:	f06a                	sd	s10,32(sp)
 6c6:	ec6e                	sd	s11,24(sp)
 6c8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6ca:	0005c903          	lbu	s2,0(a1)
 6ce:	18090f63          	beqz	s2,86c <vprintf+0x1c0>
 6d2:	8aaa                	mv	s5,a0
 6d4:	8b32                	mv	s6,a2
 6d6:	00158493          	addi	s1,a1,1
  state = 0;
 6da:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6dc:	02500a13          	li	s4,37
 6e0:	4c55                	li	s8,21
 6e2:	00000c97          	auipc	s9,0x0
 6e6:	5b6c8c93          	addi	s9,s9,1462 # c98 <compare_str_ic+0x104>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ea:	02800d93          	li	s11,40
  putc(fd, 'x');
 6ee:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f0:	00000b97          	auipc	s7,0x0
 6f4:	600b8b93          	addi	s7,s7,1536 # cf0 <digits>
 6f8:	a839                	j	716 <vprintf+0x6a>
        putc(fd, c);
 6fa:	85ca                	mv	a1,s2
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	ee0080e7          	jalr	-288(ra) # 5de <putc>
 706:	a019                	j	70c <vprintf+0x60>
    } else if(state == '%'){
 708:	01498d63          	beq	s3,s4,722 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 70c:	0485                	addi	s1,s1,1
 70e:	fff4c903          	lbu	s2,-1(s1)
 712:	14090d63          	beqz	s2,86c <vprintf+0x1c0>
    if(state == 0){
 716:	fe0999e3          	bnez	s3,708 <vprintf+0x5c>
      if(c == '%'){
 71a:	ff4910e3          	bne	s2,s4,6fa <vprintf+0x4e>
        state = '%';
 71e:	89d2                	mv	s3,s4
 720:	b7f5                	j	70c <vprintf+0x60>
      if(c == 'd'){
 722:	11490c63          	beq	s2,s4,83a <vprintf+0x18e>
 726:	f9d9079b          	addiw	a5,s2,-99
 72a:	0ff7f793          	zext.b	a5,a5
 72e:	10fc6e63          	bltu	s8,a5,84a <vprintf+0x19e>
 732:	f9d9079b          	addiw	a5,s2,-99
 736:	0ff7f713          	zext.b	a4,a5
 73a:	10ec6863          	bltu	s8,a4,84a <vprintf+0x19e>
 73e:	00271793          	slli	a5,a4,0x2
 742:	97e6                	add	a5,a5,s9
 744:	439c                	lw	a5,0(a5)
 746:	97e6                	add	a5,a5,s9
 748:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 74a:	008b0913          	addi	s2,s6,8
 74e:	4685                	li	a3,1
 750:	4629                	li	a2,10
 752:	000b2583          	lw	a1,0(s6)
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	ea8080e7          	jalr	-344(ra) # 600 <printint>
 760:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 762:	4981                	li	s3,0
 764:	b765                	j	70c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 766:	008b0913          	addi	s2,s6,8
 76a:	4681                	li	a3,0
 76c:	4629                	li	a2,10
 76e:	000b2583          	lw	a1,0(s6)
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	e8c080e7          	jalr	-372(ra) # 600 <printint>
 77c:	8b4a                	mv	s6,s2
      state = 0;
 77e:	4981                	li	s3,0
 780:	b771                	j	70c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 782:	008b0913          	addi	s2,s6,8
 786:	4681                	li	a3,0
 788:	866a                	mv	a2,s10
 78a:	000b2583          	lw	a1,0(s6)
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	e70080e7          	jalr	-400(ra) # 600 <printint>
 798:	8b4a                	mv	s6,s2
      state = 0;
 79a:	4981                	li	s3,0
 79c:	bf85                	j	70c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 79e:	008b0793          	addi	a5,s6,8
 7a2:	f8f43423          	sd	a5,-120(s0)
 7a6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7aa:	03000593          	li	a1,48
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	e2e080e7          	jalr	-466(ra) # 5de <putc>
  putc(fd, 'x');
 7b8:	07800593          	li	a1,120
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	e20080e7          	jalr	-480(ra) # 5de <putc>
 7c6:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c8:	03c9d793          	srli	a5,s3,0x3c
 7cc:	97de                	add	a5,a5,s7
 7ce:	0007c583          	lbu	a1,0(a5)
 7d2:	8556                	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	e0a080e7          	jalr	-502(ra) # 5de <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7dc:	0992                	slli	s3,s3,0x4
 7de:	397d                	addiw	s2,s2,-1
 7e0:	fe0914e3          	bnez	s2,7c8 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7e4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	b70d                	j	70c <vprintf+0x60>
        s = va_arg(ap, char*);
 7ec:	008b0913          	addi	s2,s6,8
 7f0:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7f4:	02098163          	beqz	s3,816 <vprintf+0x16a>
        while(*s != 0){
 7f8:	0009c583          	lbu	a1,0(s3)
 7fc:	c5ad                	beqz	a1,866 <vprintf+0x1ba>
          putc(fd, *s);
 7fe:	8556                	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	dde080e7          	jalr	-546(ra) # 5de <putc>
          s++;
 808:	0985                	addi	s3,s3,1
        while(*s != 0){
 80a:	0009c583          	lbu	a1,0(s3)
 80e:	f9e5                	bnez	a1,7fe <vprintf+0x152>
        s = va_arg(ap, char*);
 810:	8b4a                	mv	s6,s2
      state = 0;
 812:	4981                	li	s3,0
 814:	bde5                	j	70c <vprintf+0x60>
          s = "(null)";
 816:	00000997          	auipc	s3,0x0
 81a:	47a98993          	addi	s3,s3,1146 # c90 <compare_str_ic+0xfc>
        while(*s != 0){
 81e:	85ee                	mv	a1,s11
 820:	bff9                	j	7fe <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 822:	008b0913          	addi	s2,s6,8
 826:	000b4583          	lbu	a1,0(s6)
 82a:	8556                	mv	a0,s5
 82c:	00000097          	auipc	ra,0x0
 830:	db2080e7          	jalr	-590(ra) # 5de <putc>
 834:	8b4a                	mv	s6,s2
      state = 0;
 836:	4981                	li	s3,0
 838:	bdd1                	j	70c <vprintf+0x60>
        putc(fd, c);
 83a:	85d2                	mv	a1,s4
 83c:	8556                	mv	a0,s5
 83e:	00000097          	auipc	ra,0x0
 842:	da0080e7          	jalr	-608(ra) # 5de <putc>
      state = 0;
 846:	4981                	li	s3,0
 848:	b5d1                	j	70c <vprintf+0x60>
        putc(fd, '%');
 84a:	85d2                	mv	a1,s4
 84c:	8556                	mv	a0,s5
 84e:	00000097          	auipc	ra,0x0
 852:	d90080e7          	jalr	-624(ra) # 5de <putc>
        putc(fd, c);
 856:	85ca                	mv	a1,s2
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	d84080e7          	jalr	-636(ra) # 5de <putc>
      state = 0;
 862:	4981                	li	s3,0
 864:	b565                	j	70c <vprintf+0x60>
        s = va_arg(ap, char*);
 866:	8b4a                	mv	s6,s2
      state = 0;
 868:	4981                	li	s3,0
 86a:	b54d                	j	70c <vprintf+0x60>
    }
  }
}
 86c:	70e6                	ld	ra,120(sp)
 86e:	7446                	ld	s0,112(sp)
 870:	74a6                	ld	s1,104(sp)
 872:	7906                	ld	s2,96(sp)
 874:	69e6                	ld	s3,88(sp)
 876:	6a46                	ld	s4,80(sp)
 878:	6aa6                	ld	s5,72(sp)
 87a:	6b06                	ld	s6,64(sp)
 87c:	7be2                	ld	s7,56(sp)
 87e:	7c42                	ld	s8,48(sp)
 880:	7ca2                	ld	s9,40(sp)
 882:	7d02                	ld	s10,32(sp)
 884:	6de2                	ld	s11,24(sp)
 886:	6109                	addi	sp,sp,128
 888:	8082                	ret

000000000000088a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 88a:	715d                	addi	sp,sp,-80
 88c:	ec06                	sd	ra,24(sp)
 88e:	e822                	sd	s0,16(sp)
 890:	1000                	addi	s0,sp,32
 892:	e010                	sd	a2,0(s0)
 894:	e414                	sd	a3,8(s0)
 896:	e818                	sd	a4,16(s0)
 898:	ec1c                	sd	a5,24(s0)
 89a:	03043023          	sd	a6,32(s0)
 89e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8a6:	8622                	mv	a2,s0
 8a8:	00000097          	auipc	ra,0x0
 8ac:	e04080e7          	jalr	-508(ra) # 6ac <vprintf>
}
 8b0:	60e2                	ld	ra,24(sp)
 8b2:	6442                	ld	s0,16(sp)
 8b4:	6161                	addi	sp,sp,80
 8b6:	8082                	ret

00000000000008b8 <printf>:

void
printf(const char *fmt, ...)
{
 8b8:	711d                	addi	sp,sp,-96
 8ba:	ec06                	sd	ra,24(sp)
 8bc:	e822                	sd	s0,16(sp)
 8be:	1000                	addi	s0,sp,32
 8c0:	e40c                	sd	a1,8(s0)
 8c2:	e810                	sd	a2,16(s0)
 8c4:	ec14                	sd	a3,24(s0)
 8c6:	f018                	sd	a4,32(s0)
 8c8:	f41c                	sd	a5,40(s0)
 8ca:	03043823          	sd	a6,48(s0)
 8ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8d2:	00840613          	addi	a2,s0,8
 8d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8da:	85aa                	mv	a1,a0
 8dc:	4505                	li	a0,1
 8de:	00000097          	auipc	ra,0x0
 8e2:	dce080e7          	jalr	-562(ra) # 6ac <vprintf>
}
 8e6:	60e2                	ld	ra,24(sp)
 8e8:	6442                	ld	s0,16(sp)
 8ea:	6125                	addi	sp,sp,96
 8ec:	8082                	ret

00000000000008ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ee:	1141                	addi	sp,sp,-16
 8f0:	e422                	sd	s0,8(sp)
 8f2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8f4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f8:	00000797          	auipc	a5,0x0
 8fc:	7087b783          	ld	a5,1800(a5) # 1000 <freep>
 900:	a02d                	j	92a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 902:	4618                	lw	a4,8(a2)
 904:	9f2d                	addw	a4,a4,a1
 906:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 90a:	6398                	ld	a4,0(a5)
 90c:	6310                	ld	a2,0(a4)
 90e:	a83d                	j	94c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 910:	ff852703          	lw	a4,-8(a0)
 914:	9f31                	addw	a4,a4,a2
 916:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 918:	ff053683          	ld	a3,-16(a0)
 91c:	a091                	j	960 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 91e:	6398                	ld	a4,0(a5)
 920:	00e7e463          	bltu	a5,a4,928 <free+0x3a>
 924:	00e6ea63          	bltu	a3,a4,938 <free+0x4a>
{
 928:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92a:	fed7fae3          	bgeu	a5,a3,91e <free+0x30>
 92e:	6398                	ld	a4,0(a5)
 930:	00e6e463          	bltu	a3,a4,938 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 934:	fee7eae3          	bltu	a5,a4,928 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 938:	ff852583          	lw	a1,-8(a0)
 93c:	6390                	ld	a2,0(a5)
 93e:	02059813          	slli	a6,a1,0x20
 942:	01c85713          	srli	a4,a6,0x1c
 946:	9736                	add	a4,a4,a3
 948:	fae60de3          	beq	a2,a4,902 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 94c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 950:	4790                	lw	a2,8(a5)
 952:	02061593          	slli	a1,a2,0x20
 956:	01c5d713          	srli	a4,a1,0x1c
 95a:	973e                	add	a4,a4,a5
 95c:	fae68ae3          	beq	a3,a4,910 <free+0x22>
    p->s.ptr = bp->s.ptr;
 960:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 962:	00000717          	auipc	a4,0x0
 966:	68f73f23          	sd	a5,1694(a4) # 1000 <freep>
}
 96a:	6422                	ld	s0,8(sp)
 96c:	0141                	addi	sp,sp,16
 96e:	8082                	ret

0000000000000970 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 970:	7139                	addi	sp,sp,-64
 972:	fc06                	sd	ra,56(sp)
 974:	f822                	sd	s0,48(sp)
 976:	f426                	sd	s1,40(sp)
 978:	f04a                	sd	s2,32(sp)
 97a:	ec4e                	sd	s3,24(sp)
 97c:	e852                	sd	s4,16(sp)
 97e:	e456                	sd	s5,8(sp)
 980:	e05a                	sd	s6,0(sp)
 982:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 984:	02051493          	slli	s1,a0,0x20
 988:	9081                	srli	s1,s1,0x20
 98a:	04bd                	addi	s1,s1,15
 98c:	8091                	srli	s1,s1,0x4
 98e:	0014899b          	addiw	s3,s1,1
 992:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 994:	00000517          	auipc	a0,0x0
 998:	66c53503          	ld	a0,1644(a0) # 1000 <freep>
 99c:	c515                	beqz	a0,9c8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a0:	4798                	lw	a4,8(a5)
 9a2:	02977f63          	bgeu	a4,s1,9e0 <malloc+0x70>
 9a6:	8a4e                	mv	s4,s3
 9a8:	0009871b          	sext.w	a4,s3
 9ac:	6685                	lui	a3,0x1
 9ae:	00d77363          	bgeu	a4,a3,9b4 <malloc+0x44>
 9b2:	6a05                	lui	s4,0x1
 9b4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9b8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9bc:	00000917          	auipc	s2,0x0
 9c0:	64490913          	addi	s2,s2,1604 # 1000 <freep>
  if(p == (char*)-1)
 9c4:	5afd                	li	s5,-1
 9c6:	a895                	j	a3a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9c8:	00000797          	auipc	a5,0x0
 9cc:	64878793          	addi	a5,a5,1608 # 1010 <base>
 9d0:	00000717          	auipc	a4,0x0
 9d4:	62f73823          	sd	a5,1584(a4) # 1000 <freep>
 9d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9de:	b7e1                	j	9a6 <malloc+0x36>
      if(p->s.size == nunits)
 9e0:	02e48c63          	beq	s1,a4,a18 <malloc+0xa8>
        p->s.size -= nunits;
 9e4:	4137073b          	subw	a4,a4,s3
 9e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ea:	02071693          	slli	a3,a4,0x20
 9ee:	01c6d713          	srli	a4,a3,0x1c
 9f2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9f4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9f8:	00000717          	auipc	a4,0x0
 9fc:	60a73423          	sd	a0,1544(a4) # 1000 <freep>
      return (void*)(p + 1);
 a00:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a04:	70e2                	ld	ra,56(sp)
 a06:	7442                	ld	s0,48(sp)
 a08:	74a2                	ld	s1,40(sp)
 a0a:	7902                	ld	s2,32(sp)
 a0c:	69e2                	ld	s3,24(sp)
 a0e:	6a42                	ld	s4,16(sp)
 a10:	6aa2                	ld	s5,8(sp)
 a12:	6b02                	ld	s6,0(sp)
 a14:	6121                	addi	sp,sp,64
 a16:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a18:	6398                	ld	a4,0(a5)
 a1a:	e118                	sd	a4,0(a0)
 a1c:	bff1                	j	9f8 <malloc+0x88>
  hp->s.size = nu;
 a1e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a22:	0541                	addi	a0,a0,16
 a24:	00000097          	auipc	ra,0x0
 a28:	eca080e7          	jalr	-310(ra) # 8ee <free>
  return freep;
 a2c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a30:	d971                	beqz	a0,a04 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a32:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a34:	4798                	lw	a4,8(a5)
 a36:	fa9775e3          	bgeu	a4,s1,9e0 <malloc+0x70>
    if(p == freep)
 a3a:	00093703          	ld	a4,0(s2)
 a3e:	853e                	mv	a0,a5
 a40:	fef719e3          	bne	a4,a5,a32 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a44:	8552                	mv	a0,s4
 a46:	00000097          	auipc	ra,0x0
 a4a:	b70080e7          	jalr	-1168(ra) # 5b6 <sbrk>
  if(p == (char*)-1)
 a4e:	fd5518e3          	bne	a0,s5,a1e <malloc+0xae>
        return 0;
 a52:	4501                	li	a0,0
 a54:	bf45                	j	a04 <malloc+0x94>

0000000000000a56 <str_len>:
 a56:	1141                	addi	sp,sp,-16
 a58:	e422                	sd	s0,8(sp)
 a5a:	0800                	addi	s0,sp,16
 a5c:	00054783          	lbu	a5,0(a0)
 a60:	cf99                	beqz	a5,a7e <str_len+0x28>
 a62:	00150713          	addi	a4,a0,1
 a66:	87ba                	mv	a5,a4
 a68:	4685                	li	a3,1
 a6a:	9e99                	subw	a3,a3,a4
 a6c:	00f6853b          	addw	a0,a3,a5
 a70:	0785                	addi	a5,a5,1
 a72:	fff7c703          	lbu	a4,-1(a5)
 a76:	fb7d                	bnez	a4,a6c <str_len+0x16>
 a78:	6422                	ld	s0,8(sp)
 a7a:	0141                	addi	sp,sp,16
 a7c:	8082                	ret
 a7e:	4501                	li	a0,0
 a80:	bfe5                	j	a78 <str_len+0x22>

0000000000000a82 <print>:
 a82:	1101                	addi	sp,sp,-32
 a84:	ec06                	sd	ra,24(sp)
 a86:	e822                	sd	s0,16(sp)
 a88:	e426                	sd	s1,8(sp)
 a8a:	1000                	addi	s0,sp,32
 a8c:	84aa                	mv	s1,a0
 a8e:	00000097          	auipc	ra,0x0
 a92:	fc8080e7          	jalr	-56(ra) # a56 <str_len>
 a96:	0005061b          	sext.w	a2,a0
 a9a:	85a6                	mv	a1,s1
 a9c:	4505                	li	a0,1
 a9e:	00000097          	auipc	ra,0x0
 aa2:	ab0080e7          	jalr	-1360(ra) # 54e <write>
 aa6:	60e2                	ld	ra,24(sp)
 aa8:	6442                	ld	s0,16(sp)
 aaa:	64a2                	ld	s1,8(sp)
 aac:	6105                	addi	sp,sp,32
 aae:	8082                	ret

0000000000000ab0 <open_file>:
[INPUT]: File's name
		 Manipulation mode

[OUTPUT]: File descriptor, -1 on error
*/
s32 open_file(u8 * filePath, s32 flag){
 ab0:	1141                	addi	sp,sp,-16
 ab2:	e406                	sd	ra,8(sp)
 ab4:	e022                	sd	s0,0(sp)
 ab6:	0800                	addi	s0,sp,16
	s32 fd = open(filePath, flag);
 ab8:	00000097          	auipc	ra,0x0
 abc:	ab6080e7          	jalr	-1354(ra) # 56e <open>
	return fd;
}
 ac0:	60a2                	ld	ra,8(sp)
 ac2:	6402                	ld	s0,0(sp)
 ac4:	0141                	addi	sp,sp,16
 ac6:	8082                	ret

0000000000000ac8 <read_line>:




s64 read_line(s32 fd, u8 * buffer){
 ac8:	7139                	addi	sp,sp,-64
 aca:	fc06                	sd	ra,56(sp)
 acc:	f822                	sd	s0,48(sp)
 ace:	f426                	sd	s1,40(sp)
 ad0:	f04a                	sd	s2,32(sp)
 ad2:	ec4e                	sd	s3,24(sp)
 ad4:	e852                	sd	s4,16(sp)
 ad6:	0080                	addi	s0,sp,64
 ad8:	892a                	mv	s2,a0
 ada:	89ae                	mv	s3,a1

	u8 readByte;
	s64 byteCount = 0;
 adc:	4481                	li	s1,0
		}

		*buffer++ = readByte;
		byteCount++;

		if (readByte == '\n')
 ade:	4a29                	li	s4,10
	while((readStatus = read(fd,&readByte,1))){
 ae0:	4605                	li	a2,1
 ae2:	fcf40593          	addi	a1,s0,-49
 ae6:	854a                	mv	a0,s2
 ae8:	00000097          	auipc	ra,0x0
 aec:	a5e080e7          	jalr	-1442(ra) # 546 <read>
 af0:	87aa                	mv	a5,a0
 af2:	cd01                	beqz	a0,b0a <read_line+0x42>
		if (readStatus <= 0L){
 af4:	02f05463          	blez	a5,b1c <read_line+0x54>
		*buffer++ = readByte;
 af8:	fcf44783          	lbu	a5,-49(s0)
 afc:	00998733          	add	a4,s3,s1
 b00:	00f70023          	sb	a5,0(a4)
		byteCount++;
 b04:	0485                	addi	s1,s1,1
		if (readByte == '\n')
 b06:	fd479de3          	bne	a5,s4,ae0 <read_line+0x18>
			return byteCount;
	}

	return byteCount;
}
 b0a:	8526                	mv	a0,s1
 b0c:	70e2                	ld	ra,56(sp)
 b0e:	7442                	ld	s0,48(sp)
 b10:	74a2                	ld	s1,40(sp)
 b12:	7902                	ld	s2,32(sp)
 b14:	69e2                	ld	s3,24(sp)
 b16:	6a42                	ld	s4,16(sp)
 b18:	6121                	addi	sp,sp,64
 b1a:	8082                	ret
			if (byteCount == 0)
 b1c:	f4fd                	bnez	s1,b0a <read_line+0x42>
	while((readStatus = read(fd,&readByte,1))){
 b1e:	84aa                	mv	s1,a0
 b20:	b7ed                	j	b0a <read_line+0x42>

0000000000000b22 <close_file>:


void close_file(s32 fd){
 b22:	1141                	addi	sp,sp,-16
 b24:	e406                	sd	ra,8(sp)
 b26:	e022                	sd	s0,0(sp)
 b28:	0800                	addi	s0,sp,16
	close(fd);
 b2a:	00000097          	auipc	ra,0x0
 b2e:	a2c080e7          	jalr	-1492(ra) # 556 <close>
}
 b32:	60a2                	ld	ra,8(sp)
 b34:	6402                	ld	s0,0(sp)
 b36:	0141                	addi	sp,sp,16
 b38:	8082                	ret

0000000000000b3a <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
u32 get_strlen(const u8 * str){
 b3a:	1141                	addi	sp,sp,-16
 b3c:	e422                	sd	s0,8(sp)
 b3e:	0800                	addi	s0,sp,16
	u32 len = 0;
	while(*str++){len++;};
 b40:	00054783          	lbu	a5,0(a0)
 b44:	cf99                	beqz	a5,b62 <get_strlen+0x28>
 b46:	00150713          	addi	a4,a0,1
 b4a:	87ba                	mv	a5,a4
 b4c:	4685                	li	a3,1
 b4e:	9e99                	subw	a3,a3,a4
 b50:	00f6853b          	addw	a0,a3,a5
 b54:	0785                	addi	a5,a5,1
 b56:	fff7c703          	lbu	a4,-1(a5)
 b5a:	fb7d                	bnez	a4,b50 <get_strlen+0x16>
	return len;
}
 b5c:	6422                	ld	s0,8(sp)
 b5e:	0141                	addi	sp,sp,16
 b60:	8082                	ret
	u32 len = 0;
 b62:	4501                	li	a0,0
 b64:	bfe5                	j	b5c <get_strlen+0x22>

0000000000000b66 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
u8 compare_str(const u8 * s1 , const u8 * s2){
 b66:	1141                	addi	sp,sp,-16
 b68:	e422                	sd	s0,8(sp)
 b6a:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
 b6c:	00054783          	lbu	a5,0(a0)
 b70:	cb91                	beqz	a5,b84 <compare_str+0x1e>
 b72:	0005c703          	lbu	a4,0(a1)
 b76:	c719                	beqz	a4,b84 <compare_str+0x1e>
		if (*s1++ != *s2++)
 b78:	0505                	addi	a0,a0,1
 b7a:	0585                	addi	a1,a1,1
 b7c:	fee788e3          	beq	a5,a4,b6c <compare_str+0x6>
			return 1;
 b80:	4505                	li	a0,1
 b82:	a031                	j	b8e <compare_str+0x28>
	}
	if (*s1 == *s2)
 b84:	0005c503          	lbu	a0,0(a1)
 b88:	8d1d                	sub	a0,a0,a5
			return 1;
 b8a:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 b8e:	6422                	ld	s0,8(sp)
 b90:	0141                	addi	sp,sp,16
 b92:	8082                	ret

0000000000000b94 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
u8 compare_str_ic(const u8 * s1 , const u8 * s2){
 b94:	1141                	addi	sp,sp,-16
 b96:	e422                	sd	s0,8(sp)
 b98:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		u8 b1 = *s1++;
		u8 b2 = *s2++;

		if (b1>='A' && b1<='Z'){
 b9a:	4665                	li	a2,25
	while(*s1 && *s2){
 b9c:	a019                	j	ba2 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
 b9e:	04e79763          	bne	a5,a4,bec <compare_str_ic+0x58>
	while(*s1 && *s2){
 ba2:	00054783          	lbu	a5,0(a0)
 ba6:	cb9d                	beqz	a5,bdc <compare_str_ic+0x48>
 ba8:	0005c703          	lbu	a4,0(a1)
 bac:	cb05                	beqz	a4,bdc <compare_str_ic+0x48>
		u8 b1 = *s1++;
 bae:	0505                	addi	a0,a0,1
		u8 b2 = *s2++;
 bb0:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
 bb2:	fbf7869b          	addiw	a3,a5,-65
 bb6:	0ff6f693          	zext.b	a3,a3
 bba:	00d66663          	bltu	a2,a3,bc6 <compare_str_ic+0x32>
			b1 += 32;
 bbe:	0207879b          	addiw	a5,a5,32
 bc2:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
 bc6:	fbf7069b          	addiw	a3,a4,-65
 bca:	0ff6f693          	zext.b	a3,a3
 bce:	fcd668e3          	bltu	a2,a3,b9e <compare_str_ic+0xa>
			b2 += 32;
 bd2:	0207071b          	addiw	a4,a4,32
 bd6:	0ff77713          	zext.b	a4,a4
 bda:	b7d1                	j	b9e <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
 bdc:	0005c503          	lbu	a0,0(a1)
 be0:	8d1d                	sub	a0,a0,a5
			return 1;
 be2:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
 be6:	6422                	ld	s0,8(sp)
 be8:	0141                	addi	sp,sp,16
 bea:	8082                	ret
			return 1;
 bec:	4505                	li	a0,1
 bee:	bfe5                	j	be6 <compare_str_ic+0x52>
