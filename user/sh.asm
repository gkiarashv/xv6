
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <create_cmd>:
void panic(char*);
struct cmd *parsecmd(char*);
void runcmd(struct cmd*) __attribute__((noreturn));


void create_cmd(char ** argv, char * cmd){
       0:	7179                	addi	sp,sp,-48
       2:	f406                	sd	ra,40(sp)
       4:	f022                	sd	s0,32(sp)
       6:	ec26                	sd	s1,24(sp)
       8:	e84a                	sd	s2,16(sp)
       a:	e44e                	sd	s3,8(sp)
       c:	e052                	sd	s4,0(sp)
       e:	1800                	addi	s0,sp,48
      10:	89ae                	mv	s3,a1

  int offset = 0;

  while(*argv){
      12:	610c                	ld	a1,0(a0)
      14:	cda1                	beqz	a1,6c <create_cmd+0x6c>
      16:	892a                	mv	s2,a0
  int offset = 0;
      18:	4481                	li	s1,0

    strcpy(cmd+offset,*argv);
    offset+= strlen(*argv);

    strcpy(cmd+offset," ");
      1a:	00002a17          	auipc	s4,0x2
      1e:	b76a0a13          	addi	s4,s4,-1162 # 1b90 <get_time_perf+0x62>
    strcpy(cmd+offset,*argv);
      22:	00998533          	add	a0,s3,s1
      26:	00001097          	auipc	ra,0x1
      2a:	f00080e7          	jalr	-256(ra) # f26 <strcpy>
    offset+= strlen(*argv);
      2e:	00093503          	ld	a0,0(s2)
      32:	00001097          	auipc	ra,0x1
      36:	f3c080e7          	jalr	-196(ra) # f6e <strlen>
      3a:	9ca9                	addw	s1,s1,a0
      3c:	0004851b          	sext.w	a0,s1
    strcpy(cmd+offset," ");
      40:	85d2                	mv	a1,s4
      42:	954e                	add	a0,a0,s3
      44:	00001097          	auipc	ra,0x1
      48:	ee2080e7          	jalr	-286(ra) # f26 <strcpy>
    offset+=1;
      4c:	2485                	addiw	s1,s1,1
    argv++;
      4e:	0921                	addi	s2,s2,8
  while(*argv){
      50:	00093583          	ld	a1,0(s2)
      54:	f5f9                	bnez	a1,22 <create_cmd+0x22>
  }

  *(cmd+offset)=0;
      56:	99a6                	add	s3,s3,s1
      58:	00098023          	sb	zero,0(s3)

}
      5c:	70a2                	ld	ra,40(sp)
      5e:	7402                	ld	s0,32(sp)
      60:	64e2                	ld	s1,24(sp)
      62:	6942                	ld	s2,16(sp)
      64:	69a2                	ld	s3,8(sp)
      66:	6a02                	ld	s4,0(sp)
      68:	6145                	addi	sp,sp,48
      6a:	8082                	ret
  int offset = 0;
      6c:	4481                	li	s1,0
      6e:	b7e5                	j	56 <create_cmd+0x56>

0000000000000070 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
      70:	1101                	addi	sp,sp,-32
      72:	ec06                	sd	ra,24(sp)
      74:	e822                	sd	s0,16(sp)
      76:	e426                	sd	s1,8(sp)
      78:	e04a                	sd	s2,0(sp)
      7a:	1000                	addi	s0,sp,32
      7c:	84aa                	mv	s1,a0
      7e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      80:	4609                	li	a2,2
      82:	00002597          	auipc	a1,0x2
      86:	b1658593          	addi	a1,a1,-1258 # 1b98 <get_time_perf+0x6a>
      8a:	4509                	li	a0,2
      8c:	00001097          	auipc	ra,0x1
      90:	126080e7          	jalr	294(ra) # 11b2 <write>
  memset(buf, 0, nbuf);
      94:	864a                	mv	a2,s2
      96:	4581                	li	a1,0
      98:	8526                	mv	a0,s1
      9a:	00001097          	auipc	ra,0x1
      9e:	efe080e7          	jalr	-258(ra) # f98 <memset>
  gets(buf, nbuf);
      a2:	85ca                	mv	a1,s2
      a4:	8526                	mv	a0,s1
      a6:	00001097          	auipc	ra,0x1
      aa:	f38080e7          	jalr	-200(ra) # fde <gets>
  if(buf[0] == 0) // EOF
      ae:	0004c503          	lbu	a0,0(s1)
      b2:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      b6:	40a00533          	neg	a0,a0
      ba:	60e2                	ld	ra,24(sp)
      bc:	6442                	ld	s0,16(sp)
      be:	64a2                	ld	s1,8(sp)
      c0:	6902                	ld	s2,0(sp)
      c2:	6105                	addi	sp,sp,32
      c4:	8082                	ret

00000000000000c6 <panic>:



void
panic(char *s)
{
      c6:	1141                	addi	sp,sp,-16
      c8:	e406                	sd	ra,8(sp)
      ca:	e022                	sd	s0,0(sp)
      cc:	0800                	addi	s0,sp,16
      ce:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      d0:	00002597          	auipc	a1,0x2
      d4:	ad058593          	addi	a1,a1,-1328 # 1ba0 <get_time_perf+0x72>
      d8:	4509                	li	a0,2
      da:	00001097          	auipc	ra,0x1
      de:	444080e7          	jalr	1092(ra) # 151e <fprintf>
  exit(1);
      e2:	4505                	li	a0,1
      e4:	00001097          	auipc	ra,0x1
      e8:	0ae080e7          	jalr	174(ra) # 1192 <exit>

00000000000000ec <fork1>:
}

int
fork1(void)
{
      ec:	1141                	addi	sp,sp,-16
      ee:	e406                	sd	ra,8(sp)
      f0:	e022                	sd	s0,0(sp)
      f2:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      f4:	00001097          	auipc	ra,0x1
      f8:	096080e7          	jalr	150(ra) # 118a <fork>
  if(pid == -1)
      fc:	57fd                	li	a5,-1
      fe:	00f50663          	beq	a0,a5,10a <fork1+0x1e>
    panic("fork");
  return pid;
}
     102:	60a2                	ld	ra,8(sp)
     104:	6402                	ld	s0,0(sp)
     106:	0141                	addi	sp,sp,16
     108:	8082                	ret
    panic("fork");
     10a:	00002517          	auipc	a0,0x2
     10e:	a9e50513          	addi	a0,a0,-1378 # 1ba8 <get_time_perf+0x7a>
     112:	00000097          	auipc	ra,0x0
     116:	fb4080e7          	jalr	-76(ra) # c6 <panic>

000000000000011a <runcmd>:
{
     11a:	7131                	addi	sp,sp,-192
     11c:	fd06                	sd	ra,184(sp)
     11e:	f922                	sd	s0,176(sp)
     120:	f526                	sd	s1,168(sp)
     122:	f14a                	sd	s2,160(sp)
     124:	0180                	addi	s0,sp,192
  if(cmd == 0)
     126:	c10d                	beqz	a0,148 <runcmd+0x2e>
     128:	84aa                	mv	s1,a0
  switch(cmd->type){
     12a:	4118                	lw	a4,0(a0)
     12c:	4795                	li	a5,5
     12e:	02e7e263          	bltu	a5,a4,152 <runcmd+0x38>
     132:	00056783          	lwu	a5,0(a0)
     136:	078a                	slli	a5,a5,0x2
     138:	00002717          	auipc	a4,0x2
     13c:	c4470713          	addi	a4,a4,-956 # 1d7c <get_time_perf+0x24e>
     140:	97ba                	add	a5,a5,a4
     142:	439c                	lw	a5,0(a5)
     144:	97ba                	add	a5,a5,a4
     146:	8782                	jr	a5
    exit(1);
     148:	4505                	li	a0,1
     14a:	00001097          	auipc	ra,0x1
     14e:	048080e7          	jalr	72(ra) # 1192 <exit>
    panic("runcmd");
     152:	00002517          	auipc	a0,0x2
     156:	a5e50513          	addi	a0,a0,-1442 # 1bb0 <get_time_perf+0x82>
     15a:	00000097          	auipc	ra,0x0
     15e:	f6c080e7          	jalr	-148(ra) # c6 <panic>
    if(ecmd->argv[0] == 0)
     162:	6508                	ld	a0,8(a0)
     164:	c945                	beqz	a0,214 <runcmd+0xfa>
    if (strcmp(argv[0],"time")==0){
     166:	00002597          	auipc	a1,0x2
     16a:	a5258593          	addi	a1,a1,-1454 # 1bb8 <get_time_perf+0x8a>
     16e:	00001097          	auipc	ra,0x1
     172:	dd4080e7          	jalr	-556(ra) # f42 <strcmp>
     176:	e545                	bnez	a0,21e <runcmd+0x104>
      argv++;
     178:	04c1                	addi	s1,s1,16
      e_time_t time = get_time_perf(argv);
     17a:	85a6                	mv	a1,s1
     17c:	f5040513          	addi	a0,s0,-176
     180:	00002097          	auipc	ra,0x2
     184:	9ae080e7          	jalr	-1618(ra) # 1b2e <get_time_perf>
      int fd = open(".time", O_CREATE | O_WRONLY | O_APPEND);
     188:	65a1                	lui	a1,0x8
     18a:	20158593          	addi	a1,a1,513 # 8201 <base+0x6179>
     18e:	00002517          	auipc	a0,0x2
     192:	a3250513          	addi	a0,a0,-1486 # 1bc0 <get_time_perf+0x92>
     196:	00001097          	auipc	ra,0x1
     19a:	03c080e7          	jalr	60(ra) # 11d2 <open>
     19e:	892a                	mv	s2,a0
      char issuedCmd[100]={0};
     1a0:	f6043823          	sd	zero,-144(s0)
     1a4:	05c00613          	li	a2,92
     1a8:	4581                	li	a1,0
     1aa:	f7840513          	addi	a0,s0,-136
     1ae:	00001097          	auipc	ra,0x1
     1b2:	dea080e7          	jalr	-534(ra) # f98 <memset>
      create_cmd(argv,issuedCmd);
     1b6:	f7040593          	addi	a1,s0,-144
     1ba:	8526                	mv	a0,s1
     1bc:	00000097          	auipc	ra,0x0
     1c0:	e44080e7          	jalr	-444(ra) # 0 <create_cmd>
      int cmdLen = strlen(issuedCmd);
     1c4:	f7040513          	addi	a0,s0,-144
     1c8:	00001097          	auipc	ra,0x1
     1cc:	da6080e7          	jalr	-602(ra) # f6e <strlen>
     1d0:	f4a42623          	sw	a0,-180(s0)
      write(fd, &cmdLen, sizeof(int));
     1d4:	4611                	li	a2,4
     1d6:	f4c40593          	addi	a1,s0,-180
     1da:	854a                	mv	a0,s2
     1dc:	00001097          	auipc	ra,0x1
     1e0:	fd6080e7          	jalr	-42(ra) # 11b2 <write>
      write(fd, issuedCmd,cmdLen);
     1e4:	f4c42603          	lw	a2,-180(s0)
     1e8:	f7040593          	addi	a1,s0,-144
     1ec:	854a                	mv	a0,s2
     1ee:	00001097          	auipc	ra,0x1
     1f2:	fc4080e7          	jalr	-60(ra) # 11b2 <write>
      write(fd, &time, sizeof(e_time_t));
     1f6:	02000613          	li	a2,32
     1fa:	f5040593          	addi	a1,s0,-176
     1fe:	854a                	mv	a0,s2
     200:	00001097          	auipc	ra,0x1
     204:	fb2080e7          	jalr	-78(ra) # 11b2 <write>
      close(fd);
     208:	854a                	mv	a0,s2
     20a:	00001097          	auipc	ra,0x1
     20e:	fb0080e7          	jalr	-80(ra) # 11ba <close>
     212:	aa95                	j	386 <runcmd+0x26c>
      exit(1);
     214:	4505                	li	a0,1
     216:	00001097          	auipc	ra,0x1
     21a:	f7c080e7          	jalr	-132(ra) # 1192 <exit>
      exec(argv[0], argv);
     21e:	00848593          	addi	a1,s1,8
     222:	6488                	ld	a0,8(s1)
     224:	00001097          	auipc	ra,0x1
     228:	fa6080e7          	jalr	-90(ra) # 11ca <exec>
      fprintf(2, "exec %s failed\n", argv[0]);
     22c:	6490                	ld	a2,8(s1)
     22e:	00002597          	auipc	a1,0x2
     232:	99a58593          	addi	a1,a1,-1638 # 1bc8 <get_time_perf+0x9a>
     236:	4509                	li	a0,2
     238:	00001097          	auipc	ra,0x1
     23c:	2e6080e7          	jalr	742(ra) # 151e <fprintf>
     240:	a299                	j	386 <runcmd+0x26c>
    close(rcmd->fd);
     242:	5148                	lw	a0,36(a0)
     244:	00001097          	auipc	ra,0x1
     248:	f76080e7          	jalr	-138(ra) # 11ba <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     24c:	508c                	lw	a1,32(s1)
     24e:	6888                	ld	a0,16(s1)
     250:	00001097          	auipc	ra,0x1
     254:	f82080e7          	jalr	-126(ra) # 11d2 <open>
     258:	00054763          	bltz	a0,266 <runcmd+0x14c>
    runcmd(rcmd->cmd);
     25c:	6488                	ld	a0,8(s1)
     25e:	00000097          	auipc	ra,0x0
     262:	ebc080e7          	jalr	-324(ra) # 11a <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     266:	6890                	ld	a2,16(s1)
     268:	00002597          	auipc	a1,0x2
     26c:	97058593          	addi	a1,a1,-1680 # 1bd8 <get_time_perf+0xaa>
     270:	4509                	li	a0,2
     272:	00001097          	auipc	ra,0x1
     276:	2ac080e7          	jalr	684(ra) # 151e <fprintf>
      exit(1);
     27a:	4505                	li	a0,1
     27c:	00001097          	auipc	ra,0x1
     280:	f16080e7          	jalr	-234(ra) # 1192 <exit>
    if(fork1() == 0)
     284:	00000097          	auipc	ra,0x0
     288:	e68080e7          	jalr	-408(ra) # ec <fork1>
     28c:	e511                	bnez	a0,298 <runcmd+0x17e>
      runcmd(lcmd->left);
     28e:	6488                	ld	a0,8(s1)
     290:	00000097          	auipc	ra,0x0
     294:	e8a080e7          	jalr	-374(ra) # 11a <runcmd>
    wait(0);
     298:	4501                	li	a0,0
     29a:	00001097          	auipc	ra,0x1
     29e:	f00080e7          	jalr	-256(ra) # 119a <wait>
    runcmd(lcmd->right);
     2a2:	6888                	ld	a0,16(s1)
     2a4:	00000097          	auipc	ra,0x0
     2a8:	e76080e7          	jalr	-394(ra) # 11a <runcmd>
    if(pipe(p) < 0)
     2ac:	fd840513          	addi	a0,s0,-40
     2b0:	00001097          	auipc	ra,0x1
     2b4:	ef2080e7          	jalr	-270(ra) # 11a2 <pipe>
     2b8:	04054363          	bltz	a0,2fe <runcmd+0x1e4>
    if(fork1() == 0){
     2bc:	00000097          	auipc	ra,0x0
     2c0:	e30080e7          	jalr	-464(ra) # ec <fork1>
     2c4:	e529                	bnez	a0,30e <runcmd+0x1f4>
      close(1);
     2c6:	4505                	li	a0,1
     2c8:	00001097          	auipc	ra,0x1
     2cc:	ef2080e7          	jalr	-270(ra) # 11ba <close>
      dup(p[1]);
     2d0:	fdc42503          	lw	a0,-36(s0)
     2d4:	00001097          	auipc	ra,0x1
     2d8:	f36080e7          	jalr	-202(ra) # 120a <dup>
      close(p[0]);
     2dc:	fd842503          	lw	a0,-40(s0)
     2e0:	00001097          	auipc	ra,0x1
     2e4:	eda080e7          	jalr	-294(ra) # 11ba <close>
      close(p[1]);
     2e8:	fdc42503          	lw	a0,-36(s0)
     2ec:	00001097          	auipc	ra,0x1
     2f0:	ece080e7          	jalr	-306(ra) # 11ba <close>
      runcmd(pcmd->left);
     2f4:	6488                	ld	a0,8(s1)
     2f6:	00000097          	auipc	ra,0x0
     2fa:	e24080e7          	jalr	-476(ra) # 11a <runcmd>
      panic("pipe");
     2fe:	00002517          	auipc	a0,0x2
     302:	8ea50513          	addi	a0,a0,-1814 # 1be8 <get_time_perf+0xba>
     306:	00000097          	auipc	ra,0x0
     30a:	dc0080e7          	jalr	-576(ra) # c6 <panic>
    if(fork1() == 0){
     30e:	00000097          	auipc	ra,0x0
     312:	dde080e7          	jalr	-546(ra) # ec <fork1>
     316:	ed05                	bnez	a0,34e <runcmd+0x234>
      close(0);
     318:	00001097          	auipc	ra,0x1
     31c:	ea2080e7          	jalr	-350(ra) # 11ba <close>
      dup(p[0]);
     320:	fd842503          	lw	a0,-40(s0)
     324:	00001097          	auipc	ra,0x1
     328:	ee6080e7          	jalr	-282(ra) # 120a <dup>
      close(p[0]);
     32c:	fd842503          	lw	a0,-40(s0)
     330:	00001097          	auipc	ra,0x1
     334:	e8a080e7          	jalr	-374(ra) # 11ba <close>
      close(p[1]);
     338:	fdc42503          	lw	a0,-36(s0)
     33c:	00001097          	auipc	ra,0x1
     340:	e7e080e7          	jalr	-386(ra) # 11ba <close>
      runcmd(pcmd->right);
     344:	6888                	ld	a0,16(s1)
     346:	00000097          	auipc	ra,0x0
     34a:	dd4080e7          	jalr	-556(ra) # 11a <runcmd>
    close(p[0]);
     34e:	fd842503          	lw	a0,-40(s0)
     352:	00001097          	auipc	ra,0x1
     356:	e68080e7          	jalr	-408(ra) # 11ba <close>
    close(p[1]);
     35a:	fdc42503          	lw	a0,-36(s0)
     35e:	00001097          	auipc	ra,0x1
     362:	e5c080e7          	jalr	-420(ra) # 11ba <close>
    wait(0);
     366:	4501                	li	a0,0
     368:	00001097          	auipc	ra,0x1
     36c:	e32080e7          	jalr	-462(ra) # 119a <wait>
    wait(0);
     370:	4501                	li	a0,0
     372:	00001097          	auipc	ra,0x1
     376:	e28080e7          	jalr	-472(ra) # 119a <wait>
    break;
     37a:	a031                	j	386 <runcmd+0x26c>
    if(fork1() == 0)
     37c:	00000097          	auipc	ra,0x0
     380:	d70080e7          	jalr	-656(ra) # ec <fork1>
     384:	c511                	beqz	a0,390 <runcmd+0x276>
  exit(0);
     386:	4501                	li	a0,0
     388:	00001097          	auipc	ra,0x1
     38c:	e0a080e7          	jalr	-502(ra) # 1192 <exit>
      runcmd(bcmd->cmd);
     390:	6488                	ld	a0,8(s1)
     392:	00000097          	auipc	ra,0x0
     396:	d88080e7          	jalr	-632(ra) # 11a <runcmd>

000000000000039a <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     39a:	1101                	addi	sp,sp,-32
     39c:	ec06                	sd	ra,24(sp)
     39e:	e822                	sd	s0,16(sp)
     3a0:	e426                	sd	s1,8(sp)
     3a2:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3a4:	64800513          	li	a0,1608
     3a8:	00001097          	auipc	ra,0x1
     3ac:	25c080e7          	jalr	604(ra) # 1604 <malloc>
     3b0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3b2:	64800613          	li	a2,1608
     3b6:	4581                	li	a1,0
     3b8:	00001097          	auipc	ra,0x1
     3bc:	be0080e7          	jalr	-1056(ra) # f98 <memset>
  cmd->type = EXEC;
     3c0:	4785                	li	a5,1
     3c2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     3c4:	8526                	mv	a0,s1
     3c6:	60e2                	ld	ra,24(sp)
     3c8:	6442                	ld	s0,16(sp)
     3ca:	64a2                	ld	s1,8(sp)
     3cc:	6105                	addi	sp,sp,32
     3ce:	8082                	ret

00000000000003d0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3d0:	7139                	addi	sp,sp,-64
     3d2:	fc06                	sd	ra,56(sp)
     3d4:	f822                	sd	s0,48(sp)
     3d6:	f426                	sd	s1,40(sp)
     3d8:	f04a                	sd	s2,32(sp)
     3da:	ec4e                	sd	s3,24(sp)
     3dc:	e852                	sd	s4,16(sp)
     3de:	e456                	sd	s5,8(sp)
     3e0:	e05a                	sd	s6,0(sp)
     3e2:	0080                	addi	s0,sp,64
     3e4:	8b2a                	mv	s6,a0
     3e6:	8aae                	mv	s5,a1
     3e8:	8a32                	mv	s4,a2
     3ea:	89b6                	mv	s3,a3
     3ec:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3ee:	02800513          	li	a0,40
     3f2:	00001097          	auipc	ra,0x1
     3f6:	212080e7          	jalr	530(ra) # 1604 <malloc>
     3fa:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3fc:	02800613          	li	a2,40
     400:	4581                	li	a1,0
     402:	00001097          	auipc	ra,0x1
     406:	b96080e7          	jalr	-1130(ra) # f98 <memset>
  cmd->type = REDIR;
     40a:	4789                	li	a5,2
     40c:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     40e:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     412:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     416:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     41a:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     41e:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     422:	8526                	mv	a0,s1
     424:	70e2                	ld	ra,56(sp)
     426:	7442                	ld	s0,48(sp)
     428:	74a2                	ld	s1,40(sp)
     42a:	7902                	ld	s2,32(sp)
     42c:	69e2                	ld	s3,24(sp)
     42e:	6a42                	ld	s4,16(sp)
     430:	6aa2                	ld	s5,8(sp)
     432:	6b02                	ld	s6,0(sp)
     434:	6121                	addi	sp,sp,64
     436:	8082                	ret

0000000000000438 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     438:	7179                	addi	sp,sp,-48
     43a:	f406                	sd	ra,40(sp)
     43c:	f022                	sd	s0,32(sp)
     43e:	ec26                	sd	s1,24(sp)
     440:	e84a                	sd	s2,16(sp)
     442:	e44e                	sd	s3,8(sp)
     444:	1800                	addi	s0,sp,48
     446:	89aa                	mv	s3,a0
     448:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     44a:	4561                	li	a0,24
     44c:	00001097          	auipc	ra,0x1
     450:	1b8080e7          	jalr	440(ra) # 1604 <malloc>
     454:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     456:	4661                	li	a2,24
     458:	4581                	li	a1,0
     45a:	00001097          	auipc	ra,0x1
     45e:	b3e080e7          	jalr	-1218(ra) # f98 <memset>
  cmd->type = PIPE;
     462:	478d                	li	a5,3
     464:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     466:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     46a:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     46e:	8526                	mv	a0,s1
     470:	70a2                	ld	ra,40(sp)
     472:	7402                	ld	s0,32(sp)
     474:	64e2                	ld	s1,24(sp)
     476:	6942                	ld	s2,16(sp)
     478:	69a2                	ld	s3,8(sp)
     47a:	6145                	addi	sp,sp,48
     47c:	8082                	ret

000000000000047e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     47e:	7179                	addi	sp,sp,-48
     480:	f406                	sd	ra,40(sp)
     482:	f022                	sd	s0,32(sp)
     484:	ec26                	sd	s1,24(sp)
     486:	e84a                	sd	s2,16(sp)
     488:	e44e                	sd	s3,8(sp)
     48a:	1800                	addi	s0,sp,48
     48c:	89aa                	mv	s3,a0
     48e:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     490:	4561                	li	a0,24
     492:	00001097          	auipc	ra,0x1
     496:	172080e7          	jalr	370(ra) # 1604 <malloc>
     49a:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     49c:	4661                	li	a2,24
     49e:	4581                	li	a1,0
     4a0:	00001097          	auipc	ra,0x1
     4a4:	af8080e7          	jalr	-1288(ra) # f98 <memset>
  cmd->type = LIST;
     4a8:	4791                	li	a5,4
     4aa:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     4ac:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     4b0:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     4b4:	8526                	mv	a0,s1
     4b6:	70a2                	ld	ra,40(sp)
     4b8:	7402                	ld	s0,32(sp)
     4ba:	64e2                	ld	s1,24(sp)
     4bc:	6942                	ld	s2,16(sp)
     4be:	69a2                	ld	s3,8(sp)
     4c0:	6145                	addi	sp,sp,48
     4c2:	8082                	ret

00000000000004c4 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4c4:	1101                	addi	sp,sp,-32
     4c6:	ec06                	sd	ra,24(sp)
     4c8:	e822                	sd	s0,16(sp)
     4ca:	e426                	sd	s1,8(sp)
     4cc:	e04a                	sd	s2,0(sp)
     4ce:	1000                	addi	s0,sp,32
     4d0:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4d2:	4541                	li	a0,16
     4d4:	00001097          	auipc	ra,0x1
     4d8:	130080e7          	jalr	304(ra) # 1604 <malloc>
     4dc:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     4de:	4641                	li	a2,16
     4e0:	4581                	li	a1,0
     4e2:	00001097          	auipc	ra,0x1
     4e6:	ab6080e7          	jalr	-1354(ra) # f98 <memset>
  cmd->type = BACK;
     4ea:	4795                	li	a5,5
     4ec:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     4ee:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     4f2:	8526                	mv	a0,s1
     4f4:	60e2                	ld	ra,24(sp)
     4f6:	6442                	ld	s0,16(sp)
     4f8:	64a2                	ld	s1,8(sp)
     4fa:	6902                	ld	s2,0(sp)
     4fc:	6105                	addi	sp,sp,32
     4fe:	8082                	ret

0000000000000500 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     500:	7139                	addi	sp,sp,-64
     502:	fc06                	sd	ra,56(sp)
     504:	f822                	sd	s0,48(sp)
     506:	f426                	sd	s1,40(sp)
     508:	f04a                	sd	s2,32(sp)
     50a:	ec4e                	sd	s3,24(sp)
     50c:	e852                	sd	s4,16(sp)
     50e:	e456                	sd	s5,8(sp)
     510:	e05a                	sd	s6,0(sp)
     512:	0080                	addi	s0,sp,64
     514:	8a2a                	mv	s4,a0
     516:	892e                	mv	s2,a1
     518:	8ab2                	mv	s5,a2
     51a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     51c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     51e:	00002997          	auipc	s3,0x2
     522:	aea98993          	addi	s3,s3,-1302 # 2008 <whitespace>
     526:	00b4fe63          	bgeu	s1,a1,542 <gettoken+0x42>
     52a:	0004c583          	lbu	a1,0(s1)
     52e:	854e                	mv	a0,s3
     530:	00001097          	auipc	ra,0x1
     534:	a8a080e7          	jalr	-1398(ra) # fba <strchr>
     538:	c509                	beqz	a0,542 <gettoken+0x42>
    s++;
     53a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     53c:	fe9917e3          	bne	s2,s1,52a <gettoken+0x2a>
    s++;
     540:	84ca                	mv	s1,s2
  if(q)
     542:	000a8463          	beqz	s5,54a <gettoken+0x4a>
    *q = s;
     546:	009ab023          	sd	s1,0(s5)
  ret = *s;
     54a:	0004c783          	lbu	a5,0(s1)
     54e:	00078a9b          	sext.w	s5,a5
  switch(*s){
     552:	03c00713          	li	a4,60
     556:	06f76663          	bltu	a4,a5,5c2 <gettoken+0xc2>
     55a:	03a00713          	li	a4,58
     55e:	00f76e63          	bltu	a4,a5,57a <gettoken+0x7a>
     562:	cf89                	beqz	a5,57c <gettoken+0x7c>
     564:	02600713          	li	a4,38
     568:	00e78963          	beq	a5,a4,57a <gettoken+0x7a>
     56c:	fd87879b          	addiw	a5,a5,-40
     570:	0ff7f793          	zext.b	a5,a5
     574:	4705                	li	a4,1
     576:	06f76d63          	bltu	a4,a5,5f0 <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     57a:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     57c:	000b0463          	beqz	s6,584 <gettoken+0x84>
    *eq = s;
     580:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     584:	00002997          	auipc	s3,0x2
     588:	a8498993          	addi	s3,s3,-1404 # 2008 <whitespace>
     58c:	0124fe63          	bgeu	s1,s2,5a8 <gettoken+0xa8>
     590:	0004c583          	lbu	a1,0(s1)
     594:	854e                	mv	a0,s3
     596:	00001097          	auipc	ra,0x1
     59a:	a24080e7          	jalr	-1500(ra) # fba <strchr>
     59e:	c509                	beqz	a0,5a8 <gettoken+0xa8>
    s++;
     5a0:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     5a2:	fe9917e3          	bne	s2,s1,590 <gettoken+0x90>
    s++;
     5a6:	84ca                	mv	s1,s2
  *ps = s;
     5a8:	009a3023          	sd	s1,0(s4)
  return ret;
}
     5ac:	8556                	mv	a0,s5
     5ae:	70e2                	ld	ra,56(sp)
     5b0:	7442                	ld	s0,48(sp)
     5b2:	74a2                	ld	s1,40(sp)
     5b4:	7902                	ld	s2,32(sp)
     5b6:	69e2                	ld	s3,24(sp)
     5b8:	6a42                	ld	s4,16(sp)
     5ba:	6aa2                	ld	s5,8(sp)
     5bc:	6b02                	ld	s6,0(sp)
     5be:	6121                	addi	sp,sp,64
     5c0:	8082                	ret
  switch(*s){
     5c2:	03e00713          	li	a4,62
     5c6:	02e79163          	bne	a5,a4,5e8 <gettoken+0xe8>
    s++;
     5ca:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     5ce:	0014c703          	lbu	a4,1(s1)
     5d2:	03e00793          	li	a5,62
      s++;
     5d6:	0489                	addi	s1,s1,2
      ret = '+';
     5d8:	02b00a93          	li	s5,43
    if(*s == '>'){
     5dc:	faf700e3          	beq	a4,a5,57c <gettoken+0x7c>
    s++;
     5e0:	84b6                	mv	s1,a3
  ret = *s;
     5e2:	03e00a93          	li	s5,62
     5e6:	bf59                	j	57c <gettoken+0x7c>
  switch(*s){
     5e8:	07c00713          	li	a4,124
     5ec:	f8e787e3          	beq	a5,a4,57a <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5f0:	00002997          	auipc	s3,0x2
     5f4:	a1898993          	addi	s3,s3,-1512 # 2008 <whitespace>
     5f8:	00002a97          	auipc	s5,0x2
     5fc:	a08a8a93          	addi	s5,s5,-1528 # 2000 <symbols>
     600:	0324f663          	bgeu	s1,s2,62c <gettoken+0x12c>
     604:	0004c583          	lbu	a1,0(s1)
     608:	854e                	mv	a0,s3
     60a:	00001097          	auipc	ra,0x1
     60e:	9b0080e7          	jalr	-1616(ra) # fba <strchr>
     612:	e50d                	bnez	a0,63c <gettoken+0x13c>
     614:	0004c583          	lbu	a1,0(s1)
     618:	8556                	mv	a0,s5
     61a:	00001097          	auipc	ra,0x1
     61e:	9a0080e7          	jalr	-1632(ra) # fba <strchr>
     622:	e911                	bnez	a0,636 <gettoken+0x136>
      s++;
     624:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     626:	fc991fe3          	bne	s2,s1,604 <gettoken+0x104>
      s++;
     62a:	84ca                	mv	s1,s2
  if(eq)
     62c:	06100a93          	li	s5,97
     630:	f40b18e3          	bnez	s6,580 <gettoken+0x80>
     634:	bf95                	j	5a8 <gettoken+0xa8>
    ret = 'a';
     636:	06100a93          	li	s5,97
     63a:	b789                	j	57c <gettoken+0x7c>
     63c:	06100a93          	li	s5,97
     640:	bf35                	j	57c <gettoken+0x7c>

0000000000000642 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     642:	7139                	addi	sp,sp,-64
     644:	fc06                	sd	ra,56(sp)
     646:	f822                	sd	s0,48(sp)
     648:	f426                	sd	s1,40(sp)
     64a:	f04a                	sd	s2,32(sp)
     64c:	ec4e                	sd	s3,24(sp)
     64e:	e852                	sd	s4,16(sp)
     650:	e456                	sd	s5,8(sp)
     652:	0080                	addi	s0,sp,64
     654:	8a2a                	mv	s4,a0
     656:	892e                	mv	s2,a1
     658:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     65a:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     65c:	00002997          	auipc	s3,0x2
     660:	9ac98993          	addi	s3,s3,-1620 # 2008 <whitespace>
     664:	00b4fe63          	bgeu	s1,a1,680 <peek+0x3e>
     668:	0004c583          	lbu	a1,0(s1)
     66c:	854e                	mv	a0,s3
     66e:	00001097          	auipc	ra,0x1
     672:	94c080e7          	jalr	-1716(ra) # fba <strchr>
     676:	c509                	beqz	a0,680 <peek+0x3e>
    s++;
     678:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     67a:	fe9917e3          	bne	s2,s1,668 <peek+0x26>
    s++;
     67e:	84ca                	mv	s1,s2
  *ps = s;
     680:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     684:	0004c583          	lbu	a1,0(s1)
     688:	4501                	li	a0,0
     68a:	e991                	bnez	a1,69e <peek+0x5c>
}
     68c:	70e2                	ld	ra,56(sp)
     68e:	7442                	ld	s0,48(sp)
     690:	74a2                	ld	s1,40(sp)
     692:	7902                	ld	s2,32(sp)
     694:	69e2                	ld	s3,24(sp)
     696:	6a42                	ld	s4,16(sp)
     698:	6aa2                	ld	s5,8(sp)
     69a:	6121                	addi	sp,sp,64
     69c:	8082                	ret
  return *s && strchr(toks, *s);
     69e:	8556                	mv	a0,s5
     6a0:	00001097          	auipc	ra,0x1
     6a4:	91a080e7          	jalr	-1766(ra) # fba <strchr>
     6a8:	00a03533          	snez	a0,a0
     6ac:	b7c5                	j	68c <peek+0x4a>

00000000000006ae <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     6ae:	7159                	addi	sp,sp,-112
     6b0:	f486                	sd	ra,104(sp)
     6b2:	f0a2                	sd	s0,96(sp)
     6b4:	eca6                	sd	s1,88(sp)
     6b6:	e8ca                	sd	s2,80(sp)
     6b8:	e4ce                	sd	s3,72(sp)
     6ba:	e0d2                	sd	s4,64(sp)
     6bc:	fc56                	sd	s5,56(sp)
     6be:	f85a                	sd	s6,48(sp)
     6c0:	f45e                	sd	s7,40(sp)
     6c2:	f062                	sd	s8,32(sp)
     6c4:	ec66                	sd	s9,24(sp)
     6c6:	1880                	addi	s0,sp,112
     6c8:	8a2a                	mv	s4,a0
     6ca:	89ae                	mv	s3,a1
     6cc:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     6ce:	00001b97          	auipc	s7,0x1
     6d2:	542b8b93          	addi	s7,s7,1346 # 1c10 <get_time_perf+0xe2>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     6d6:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     6da:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     6de:	a02d                	j	708 <parseredirs+0x5a>
      panic("missing file for redirection");
     6e0:	00001517          	auipc	a0,0x1
     6e4:	51050513          	addi	a0,a0,1296 # 1bf0 <get_time_perf+0xc2>
     6e8:	00000097          	auipc	ra,0x0
     6ec:	9de080e7          	jalr	-1570(ra) # c6 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     6f0:	4701                	li	a4,0
     6f2:	4681                	li	a3,0
     6f4:	f9043603          	ld	a2,-112(s0)
     6f8:	f9843583          	ld	a1,-104(s0)
     6fc:	8552                	mv	a0,s4
     6fe:	00000097          	auipc	ra,0x0
     702:	cd2080e7          	jalr	-814(ra) # 3d0 <redircmd>
     706:	8a2a                	mv	s4,a0
    switch(tok){
     708:	03e00b13          	li	s6,62
     70c:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     710:	865e                	mv	a2,s7
     712:	85ca                	mv	a1,s2
     714:	854e                	mv	a0,s3
     716:	00000097          	auipc	ra,0x0
     71a:	f2c080e7          	jalr	-212(ra) # 642 <peek>
     71e:	c925                	beqz	a0,78e <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     720:	4681                	li	a3,0
     722:	4601                	li	a2,0
     724:	85ca                	mv	a1,s2
     726:	854e                	mv	a0,s3
     728:	00000097          	auipc	ra,0x0
     72c:	dd8080e7          	jalr	-552(ra) # 500 <gettoken>
     730:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     732:	f9040693          	addi	a3,s0,-112
     736:	f9840613          	addi	a2,s0,-104
     73a:	85ca                	mv	a1,s2
     73c:	854e                	mv	a0,s3
     73e:	00000097          	auipc	ra,0x0
     742:	dc2080e7          	jalr	-574(ra) # 500 <gettoken>
     746:	f9851de3          	bne	a0,s8,6e0 <parseredirs+0x32>
    switch(tok){
     74a:	fb9483e3          	beq	s1,s9,6f0 <parseredirs+0x42>
     74e:	03648263          	beq	s1,s6,772 <parseredirs+0xc4>
     752:	fb549fe3          	bne	s1,s5,710 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     756:	4705                	li	a4,1
     758:	20100693          	li	a3,513
     75c:	f9043603          	ld	a2,-112(s0)
     760:	f9843583          	ld	a1,-104(s0)
     764:	8552                	mv	a0,s4
     766:	00000097          	auipc	ra,0x0
     76a:	c6a080e7          	jalr	-918(ra) # 3d0 <redircmd>
     76e:	8a2a                	mv	s4,a0
      break;
     770:	bf61                	j	708 <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     772:	4705                	li	a4,1
     774:	60100693          	li	a3,1537
     778:	f9043603          	ld	a2,-112(s0)
     77c:	f9843583          	ld	a1,-104(s0)
     780:	8552                	mv	a0,s4
     782:	00000097          	auipc	ra,0x0
     786:	c4e080e7          	jalr	-946(ra) # 3d0 <redircmd>
     78a:	8a2a                	mv	s4,a0
      break;
     78c:	bfb5                	j	708 <parseredirs+0x5a>
    }
  }
  return cmd;
}
     78e:	8552                	mv	a0,s4
     790:	70a6                	ld	ra,104(sp)
     792:	7406                	ld	s0,96(sp)
     794:	64e6                	ld	s1,88(sp)
     796:	6946                	ld	s2,80(sp)
     798:	69a6                	ld	s3,72(sp)
     79a:	6a06                	ld	s4,64(sp)
     79c:	7ae2                	ld	s5,56(sp)
     79e:	7b42                	ld	s6,48(sp)
     7a0:	7ba2                	ld	s7,40(sp)
     7a2:	7c02                	ld	s8,32(sp)
     7a4:	6ce2                	ld	s9,24(sp)
     7a6:	6165                	addi	sp,sp,112
     7a8:	8082                	ret

00000000000007aa <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     7aa:	7159                	addi	sp,sp,-112
     7ac:	f486                	sd	ra,104(sp)
     7ae:	f0a2                	sd	s0,96(sp)
     7b0:	eca6                	sd	s1,88(sp)
     7b2:	e8ca                	sd	s2,80(sp)
     7b4:	e4ce                	sd	s3,72(sp)
     7b6:	e0d2                	sd	s4,64(sp)
     7b8:	fc56                	sd	s5,56(sp)
     7ba:	f85a                	sd	s6,48(sp)
     7bc:	f45e                	sd	s7,40(sp)
     7be:	f062                	sd	s8,32(sp)
     7c0:	ec66                	sd	s9,24(sp)
     7c2:	1880                	addi	s0,sp,112
     7c4:	8a2a                	mv	s4,a0
     7c6:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     7c8:	00001617          	auipc	a2,0x1
     7cc:	45060613          	addi	a2,a2,1104 # 1c18 <get_time_perf+0xea>
     7d0:	00000097          	auipc	ra,0x0
     7d4:	e72080e7          	jalr	-398(ra) # 642 <peek>
     7d8:	e151                	bnez	a0,85c <parseexec+0xb2>
     7da:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     7dc:	00000097          	auipc	ra,0x0
     7e0:	bbe080e7          	jalr	-1090(ra) # 39a <execcmd>
     7e4:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     7e6:	8656                	mv	a2,s5
     7e8:	85d2                	mv	a1,s4
     7ea:	00000097          	auipc	ra,0x0
     7ee:	ec4080e7          	jalr	-316(ra) # 6ae <parseredirs>
     7f2:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     7f4:	008c0913          	addi	s2,s8,8
     7f8:	00001b17          	auipc	s6,0x1
     7fc:	440b0b13          	addi	s6,s6,1088 # 1c38 <get_time_perf+0x10a>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     800:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     804:	06400b93          	li	s7,100
  while(!peek(ps, es, "|)&;")){
     808:	865a                	mv	a2,s6
     80a:	85d6                	mv	a1,s5
     80c:	8552                	mv	a0,s4
     80e:	00000097          	auipc	ra,0x0
     812:	e34080e7          	jalr	-460(ra) # 642 <peek>
     816:	e93d                	bnez	a0,88c <parseexec+0xe2>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     818:	f9040693          	addi	a3,s0,-112
     81c:	f9840613          	addi	a2,s0,-104
     820:	85d6                	mv	a1,s5
     822:	8552                	mv	a0,s4
     824:	00000097          	auipc	ra,0x0
     828:	cdc080e7          	jalr	-804(ra) # 500 <gettoken>
     82c:	c125                	beqz	a0,88c <parseexec+0xe2>
    if(tok != 'a')
     82e:	03951f63          	bne	a0,s9,86c <parseexec+0xc2>
    cmd->argv[argc] = q;
     832:	f9843783          	ld	a5,-104(s0)
     836:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     83a:	f9043783          	ld	a5,-112(s0)
     83e:	32f93023          	sd	a5,800(s2)
    argc++;
     842:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     844:	0921                	addi	s2,s2,8
     846:	03798b63          	beq	s3,s7,87c <parseexec+0xd2>
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     84a:	8656                	mv	a2,s5
     84c:	85d2                	mv	a1,s4
     84e:	8526                	mv	a0,s1
     850:	00000097          	auipc	ra,0x0
     854:	e5e080e7          	jalr	-418(ra) # 6ae <parseredirs>
     858:	84aa                	mv	s1,a0
     85a:	b77d                	j	808 <parseexec+0x5e>
    return parseblock(ps, es);
     85c:	85d6                	mv	a1,s5
     85e:	8552                	mv	a0,s4
     860:	00000097          	auipc	ra,0x0
     864:	16a080e7          	jalr	362(ra) # 9ca <parseblock>
     868:	84aa                	mv	s1,a0
     86a:	a03d                	j	898 <parseexec+0xee>
      panic("syntax");
     86c:	00001517          	auipc	a0,0x1
     870:	3b450513          	addi	a0,a0,948 # 1c20 <get_time_perf+0xf2>
     874:	00000097          	auipc	ra,0x0
     878:	852080e7          	jalr	-1966(ra) # c6 <panic>
      panic("too many args");
     87c:	00001517          	auipc	a0,0x1
     880:	3ac50513          	addi	a0,a0,940 # 1c28 <get_time_perf+0xfa>
     884:	00000097          	auipc	ra,0x0
     888:	842080e7          	jalr	-1982(ra) # c6 <panic>
  }
  cmd->argv[argc] = 0;
     88c:	098e                	slli	s3,s3,0x3
     88e:	9c4e                	add	s8,s8,s3
     890:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     894:	320c3423          	sd	zero,808(s8)
  return ret;
}
     898:	8526                	mv	a0,s1
     89a:	70a6                	ld	ra,104(sp)
     89c:	7406                	ld	s0,96(sp)
     89e:	64e6                	ld	s1,88(sp)
     8a0:	6946                	ld	s2,80(sp)
     8a2:	69a6                	ld	s3,72(sp)
     8a4:	6a06                	ld	s4,64(sp)
     8a6:	7ae2                	ld	s5,56(sp)
     8a8:	7b42                	ld	s6,48(sp)
     8aa:	7ba2                	ld	s7,40(sp)
     8ac:	7c02                	ld	s8,32(sp)
     8ae:	6ce2                	ld	s9,24(sp)
     8b0:	6165                	addi	sp,sp,112
     8b2:	8082                	ret

00000000000008b4 <parsepipe>:
{
     8b4:	7179                	addi	sp,sp,-48
     8b6:	f406                	sd	ra,40(sp)
     8b8:	f022                	sd	s0,32(sp)
     8ba:	ec26                	sd	s1,24(sp)
     8bc:	e84a                	sd	s2,16(sp)
     8be:	e44e                	sd	s3,8(sp)
     8c0:	1800                	addi	s0,sp,48
     8c2:	892a                	mv	s2,a0
     8c4:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     8c6:	00000097          	auipc	ra,0x0
     8ca:	ee4080e7          	jalr	-284(ra) # 7aa <parseexec>
     8ce:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     8d0:	00001617          	auipc	a2,0x1
     8d4:	37060613          	addi	a2,a2,880 # 1c40 <get_time_perf+0x112>
     8d8:	85ce                	mv	a1,s3
     8da:	854a                	mv	a0,s2
     8dc:	00000097          	auipc	ra,0x0
     8e0:	d66080e7          	jalr	-666(ra) # 642 <peek>
     8e4:	e909                	bnez	a0,8f6 <parsepipe+0x42>
}
     8e6:	8526                	mv	a0,s1
     8e8:	70a2                	ld	ra,40(sp)
     8ea:	7402                	ld	s0,32(sp)
     8ec:	64e2                	ld	s1,24(sp)
     8ee:	6942                	ld	s2,16(sp)
     8f0:	69a2                	ld	s3,8(sp)
     8f2:	6145                	addi	sp,sp,48
     8f4:	8082                	ret
    gettoken(ps, es, 0, 0);
     8f6:	4681                	li	a3,0
     8f8:	4601                	li	a2,0
     8fa:	85ce                	mv	a1,s3
     8fc:	854a                	mv	a0,s2
     8fe:	00000097          	auipc	ra,0x0
     902:	c02080e7          	jalr	-1022(ra) # 500 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     906:	85ce                	mv	a1,s3
     908:	854a                	mv	a0,s2
     90a:	00000097          	auipc	ra,0x0
     90e:	faa080e7          	jalr	-86(ra) # 8b4 <parsepipe>
     912:	85aa                	mv	a1,a0
     914:	8526                	mv	a0,s1
     916:	00000097          	auipc	ra,0x0
     91a:	b22080e7          	jalr	-1246(ra) # 438 <pipecmd>
     91e:	84aa                	mv	s1,a0
  return cmd;
     920:	b7d9                	j	8e6 <parsepipe+0x32>

0000000000000922 <parseline>:
{
     922:	7179                	addi	sp,sp,-48
     924:	f406                	sd	ra,40(sp)
     926:	f022                	sd	s0,32(sp)
     928:	ec26                	sd	s1,24(sp)
     92a:	e84a                	sd	s2,16(sp)
     92c:	e44e                	sd	s3,8(sp)
     92e:	e052                	sd	s4,0(sp)
     930:	1800                	addi	s0,sp,48
     932:	892a                	mv	s2,a0
     934:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     936:	00000097          	auipc	ra,0x0
     93a:	f7e080e7          	jalr	-130(ra) # 8b4 <parsepipe>
     93e:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     940:	00001a17          	auipc	s4,0x1
     944:	308a0a13          	addi	s4,s4,776 # 1c48 <get_time_perf+0x11a>
     948:	a839                	j	966 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     94a:	4681                	li	a3,0
     94c:	4601                	li	a2,0
     94e:	85ce                	mv	a1,s3
     950:	854a                	mv	a0,s2
     952:	00000097          	auipc	ra,0x0
     956:	bae080e7          	jalr	-1106(ra) # 500 <gettoken>
    cmd = backcmd(cmd);
     95a:	8526                	mv	a0,s1
     95c:	00000097          	auipc	ra,0x0
     960:	b68080e7          	jalr	-1176(ra) # 4c4 <backcmd>
     964:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     966:	8652                	mv	a2,s4
     968:	85ce                	mv	a1,s3
     96a:	854a                	mv	a0,s2
     96c:	00000097          	auipc	ra,0x0
     970:	cd6080e7          	jalr	-810(ra) # 642 <peek>
     974:	f979                	bnez	a0,94a <parseline+0x28>
  if(peek(ps, es, ";")){
     976:	00001617          	auipc	a2,0x1
     97a:	2da60613          	addi	a2,a2,730 # 1c50 <get_time_perf+0x122>
     97e:	85ce                	mv	a1,s3
     980:	854a                	mv	a0,s2
     982:	00000097          	auipc	ra,0x0
     986:	cc0080e7          	jalr	-832(ra) # 642 <peek>
     98a:	e911                	bnez	a0,99e <parseline+0x7c>
}
     98c:	8526                	mv	a0,s1
     98e:	70a2                	ld	ra,40(sp)
     990:	7402                	ld	s0,32(sp)
     992:	64e2                	ld	s1,24(sp)
     994:	6942                	ld	s2,16(sp)
     996:	69a2                	ld	s3,8(sp)
     998:	6a02                	ld	s4,0(sp)
     99a:	6145                	addi	sp,sp,48
     99c:	8082                	ret
    gettoken(ps, es, 0, 0);
     99e:	4681                	li	a3,0
     9a0:	4601                	li	a2,0
     9a2:	85ce                	mv	a1,s3
     9a4:	854a                	mv	a0,s2
     9a6:	00000097          	auipc	ra,0x0
     9aa:	b5a080e7          	jalr	-1190(ra) # 500 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     9ae:	85ce                	mv	a1,s3
     9b0:	854a                	mv	a0,s2
     9b2:	00000097          	auipc	ra,0x0
     9b6:	f70080e7          	jalr	-144(ra) # 922 <parseline>
     9ba:	85aa                	mv	a1,a0
     9bc:	8526                	mv	a0,s1
     9be:	00000097          	auipc	ra,0x0
     9c2:	ac0080e7          	jalr	-1344(ra) # 47e <listcmd>
     9c6:	84aa                	mv	s1,a0
  return cmd;
     9c8:	b7d1                	j	98c <parseline+0x6a>

00000000000009ca <parseblock>:
{
     9ca:	7179                	addi	sp,sp,-48
     9cc:	f406                	sd	ra,40(sp)
     9ce:	f022                	sd	s0,32(sp)
     9d0:	ec26                	sd	s1,24(sp)
     9d2:	e84a                	sd	s2,16(sp)
     9d4:	e44e                	sd	s3,8(sp)
     9d6:	1800                	addi	s0,sp,48
     9d8:	84aa                	mv	s1,a0
     9da:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     9dc:	00001617          	auipc	a2,0x1
     9e0:	23c60613          	addi	a2,a2,572 # 1c18 <get_time_perf+0xea>
     9e4:	00000097          	auipc	ra,0x0
     9e8:	c5e080e7          	jalr	-930(ra) # 642 <peek>
     9ec:	c12d                	beqz	a0,a4e <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     9ee:	4681                	li	a3,0
     9f0:	4601                	li	a2,0
     9f2:	85ca                	mv	a1,s2
     9f4:	8526                	mv	a0,s1
     9f6:	00000097          	auipc	ra,0x0
     9fa:	b0a080e7          	jalr	-1270(ra) # 500 <gettoken>
  cmd = parseline(ps, es);
     9fe:	85ca                	mv	a1,s2
     a00:	8526                	mv	a0,s1
     a02:	00000097          	auipc	ra,0x0
     a06:	f20080e7          	jalr	-224(ra) # 922 <parseline>
     a0a:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     a0c:	00001617          	auipc	a2,0x1
     a10:	25c60613          	addi	a2,a2,604 # 1c68 <get_time_perf+0x13a>
     a14:	85ca                	mv	a1,s2
     a16:	8526                	mv	a0,s1
     a18:	00000097          	auipc	ra,0x0
     a1c:	c2a080e7          	jalr	-982(ra) # 642 <peek>
     a20:	cd1d                	beqz	a0,a5e <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     a22:	4681                	li	a3,0
     a24:	4601                	li	a2,0
     a26:	85ca                	mv	a1,s2
     a28:	8526                	mv	a0,s1
     a2a:	00000097          	auipc	ra,0x0
     a2e:	ad6080e7          	jalr	-1322(ra) # 500 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     a32:	864a                	mv	a2,s2
     a34:	85a6                	mv	a1,s1
     a36:	854e                	mv	a0,s3
     a38:	00000097          	auipc	ra,0x0
     a3c:	c76080e7          	jalr	-906(ra) # 6ae <parseredirs>
}
     a40:	70a2                	ld	ra,40(sp)
     a42:	7402                	ld	s0,32(sp)
     a44:	64e2                	ld	s1,24(sp)
     a46:	6942                	ld	s2,16(sp)
     a48:	69a2                	ld	s3,8(sp)
     a4a:	6145                	addi	sp,sp,48
     a4c:	8082                	ret
    panic("parseblock");
     a4e:	00001517          	auipc	a0,0x1
     a52:	20a50513          	addi	a0,a0,522 # 1c58 <get_time_perf+0x12a>
     a56:	fffff097          	auipc	ra,0xfffff
     a5a:	670080e7          	jalr	1648(ra) # c6 <panic>
    panic("syntax - missing )");
     a5e:	00001517          	auipc	a0,0x1
     a62:	21250513          	addi	a0,a0,530 # 1c70 <get_time_perf+0x142>
     a66:	fffff097          	auipc	ra,0xfffff
     a6a:	660080e7          	jalr	1632(ra) # c6 <panic>

0000000000000a6e <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     a6e:	1101                	addi	sp,sp,-32
     a70:	ec06                	sd	ra,24(sp)
     a72:	e822                	sd	s0,16(sp)
     a74:	e426                	sd	s1,8(sp)
     a76:	1000                	addi	s0,sp,32
     a78:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     a7a:	c529                	beqz	a0,ac4 <nulterminate+0x56>
    return 0;

  switch(cmd->type){
     a7c:	4118                	lw	a4,0(a0)
     a7e:	4795                	li	a5,5
     a80:	04e7e263          	bltu	a5,a4,ac4 <nulterminate+0x56>
     a84:	00056783          	lwu	a5,0(a0)
     a88:	078a                	slli	a5,a5,0x2
     a8a:	00001717          	auipc	a4,0x1
     a8e:	30a70713          	addi	a4,a4,778 # 1d94 <get_time_perf+0x266>
     a92:	97ba                	add	a5,a5,a4
     a94:	439c                	lw	a5,0(a5)
     a96:	97ba                	add	a5,a5,a4
     a98:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     a9a:	651c                	ld	a5,8(a0)
     a9c:	c785                	beqz	a5,ac4 <nulterminate+0x56>
     a9e:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     aa2:	3187b703          	ld	a4,792(a5)
     aa6:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     aaa:	07a1                	addi	a5,a5,8
     aac:	ff87b703          	ld	a4,-8(a5)
     ab0:	fb6d                	bnez	a4,aa2 <nulterminate+0x34>
     ab2:	a809                	j	ac4 <nulterminate+0x56>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     ab4:	6508                	ld	a0,8(a0)
     ab6:	00000097          	auipc	ra,0x0
     aba:	fb8080e7          	jalr	-72(ra) # a6e <nulterminate>
    *rcmd->efile = 0;
     abe:	6c9c                	ld	a5,24(s1)
     ac0:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     ac4:	8526                	mv	a0,s1
     ac6:	60e2                	ld	ra,24(sp)
     ac8:	6442                	ld	s0,16(sp)
     aca:	64a2                	ld	s1,8(sp)
     acc:	6105                	addi	sp,sp,32
     ace:	8082                	ret
    nulterminate(pcmd->left);
     ad0:	6508                	ld	a0,8(a0)
     ad2:	00000097          	auipc	ra,0x0
     ad6:	f9c080e7          	jalr	-100(ra) # a6e <nulterminate>
    nulterminate(pcmd->right);
     ada:	6888                	ld	a0,16(s1)
     adc:	00000097          	auipc	ra,0x0
     ae0:	f92080e7          	jalr	-110(ra) # a6e <nulterminate>
    break;
     ae4:	b7c5                	j	ac4 <nulterminate+0x56>
    nulterminate(lcmd->left);
     ae6:	6508                	ld	a0,8(a0)
     ae8:	00000097          	auipc	ra,0x0
     aec:	f86080e7          	jalr	-122(ra) # a6e <nulterminate>
    nulterminate(lcmd->right);
     af0:	6888                	ld	a0,16(s1)
     af2:	00000097          	auipc	ra,0x0
     af6:	f7c080e7          	jalr	-132(ra) # a6e <nulterminate>
    break;
     afa:	b7e9                	j	ac4 <nulterminate+0x56>
    nulterminate(bcmd->cmd);
     afc:	6508                	ld	a0,8(a0)
     afe:	00000097          	auipc	ra,0x0
     b02:	f70080e7          	jalr	-144(ra) # a6e <nulterminate>
    break;
     b06:	bf7d                	j	ac4 <nulterminate+0x56>

0000000000000b08 <parsecmd>:
{
     b08:	7179                	addi	sp,sp,-48
     b0a:	f406                	sd	ra,40(sp)
     b0c:	f022                	sd	s0,32(sp)
     b0e:	ec26                	sd	s1,24(sp)
     b10:	e84a                	sd	s2,16(sp)
     b12:	1800                	addi	s0,sp,48
     b14:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     b18:	84aa                	mv	s1,a0
     b1a:	00000097          	auipc	ra,0x0
     b1e:	454080e7          	jalr	1108(ra) # f6e <strlen>
     b22:	1502                	slli	a0,a0,0x20
     b24:	9101                	srli	a0,a0,0x20
     b26:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     b28:	85a6                	mv	a1,s1
     b2a:	fd840513          	addi	a0,s0,-40
     b2e:	00000097          	auipc	ra,0x0
     b32:	df4080e7          	jalr	-524(ra) # 922 <parseline>
     b36:	892a                	mv	s2,a0
  peek(&s, es, "");
     b38:	00001617          	auipc	a2,0x1
     b3c:	18860613          	addi	a2,a2,392 # 1cc0 <get_time_perf+0x192>
     b40:	85a6                	mv	a1,s1
     b42:	fd840513          	addi	a0,s0,-40
     b46:	00000097          	auipc	ra,0x0
     b4a:	afc080e7          	jalr	-1284(ra) # 642 <peek>
  if(s != es){
     b4e:	fd843603          	ld	a2,-40(s0)
     b52:	00961e63          	bne	a2,s1,b6e <parsecmd+0x66>
  nulterminate(cmd);
     b56:	854a                	mv	a0,s2
     b58:	00000097          	auipc	ra,0x0
     b5c:	f16080e7          	jalr	-234(ra) # a6e <nulterminate>
}
     b60:	854a                	mv	a0,s2
     b62:	70a2                	ld	ra,40(sp)
     b64:	7402                	ld	s0,32(sp)
     b66:	64e2                	ld	s1,24(sp)
     b68:	6942                	ld	s2,16(sp)
     b6a:	6145                	addi	sp,sp,48
     b6c:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     b6e:	00001597          	auipc	a1,0x1
     b72:	11a58593          	addi	a1,a1,282 # 1c88 <get_time_perf+0x15a>
     b76:	4509                	li	a0,2
     b78:	00001097          	auipc	ra,0x1
     b7c:	9a6080e7          	jalr	-1626(ra) # 151e <fprintf>
    panic("syntax");
     b80:	00001517          	auipc	a0,0x1
     b84:	0a050513          	addi	a0,a0,160 # 1c20 <get_time_perf+0xf2>
     b88:	fffff097          	auipc	ra,0xfffff
     b8c:	53e080e7          	jalr	1342(ra) # c6 <panic>

0000000000000b90 <beginswith>:


char * beginswith(char * src, char *target){
     b90:	1141                	addi	sp,sp,-16
     b92:	e422                	sd	s0,8(sp)
     b94:	0800                	addi	s0,sp,16
     b96:	87aa                	mv	a5,a0

  while(*src && (*src=='\t' || *src==' ')){src++;};
     b98:	00054703          	lbu	a4,0(a0)
     b9c:	46a5                	li	a3,9
     b9e:	02000613          	li	a2,32
     ba2:	e711                	bnez	a4,bae <beginswith+0x1e>
     ba4:	a035                	j	bd0 <beginswith+0x40>
     ba6:	0785                	addi	a5,a5,1
     ba8:	0007c703          	lbu	a4,0(a5)
     bac:	c315                	beqz	a4,bd0 <beginswith+0x40>
     bae:	fed70ce3          	beq	a4,a3,ba6 <beginswith+0x16>
     bb2:	fec70ae3          	beq	a4,a2,ba6 <beginswith+0x16>

  while(*src && *target && *src==*target){
     bb6:	0007c703          	lbu	a4,0(a5)
     bba:	cb19                	beqz	a4,bd0 <beginswith+0x40>
     bbc:	0005c683          	lbu	a3,0(a1)
     bc0:	c285                	beqz	a3,be0 <beginswith+0x50>
     bc2:	00e69d63          	bne	a3,a4,bdc <beginswith+0x4c>
    src++;
     bc6:	0785                	addi	a5,a5,1
    target++;
     bc8:	0585                	addi	a1,a1,1
  while(*src && *target && *src==*target){
     bca:	0007c703          	lbu	a4,0(a5)
     bce:	f77d                	bnez	a4,bbc <beginswith+0x2c>
  }

  if (!*target){
     bd0:	0005c703          	lbu	a4,0(a1)
    return src;
  }

  return 0;
     bd4:	4501                	li	a0,0
  if (!*target){
     bd6:	e711                	bnez	a4,be2 <beginswith+0x52>
     bd8:	853e                	mv	a0,a5
     bda:	a021                	j	be2 <beginswith+0x52>
  return 0;
     bdc:	4501                	li	a0,0
     bde:	a011                	j	be2 <beginswith+0x52>
     be0:	853e                	mv	a0,a5
}
     be2:	6422                	ld	s0,8(sp)
     be4:	0141                	addi	sp,sp,16
     be6:	8082                	ret

0000000000000be8 <print_time_infos>:

/*
  Prints the time information stored in the .time file
*/

void print_time_infos(void){
     be8:	7115                	addi	sp,sp,-224
     bea:	ed86                	sd	ra,216(sp)
     bec:	e9a2                	sd	s0,208(sp)
     bee:	e5a6                	sd	s1,200(sp)
     bf0:	e1ca                	sd	s2,192(sp)
     bf2:	fd4e                	sd	s3,184(sp)
     bf4:	f952                	sd	s4,176(sp)
     bf6:	f556                	sd	s5,168(sp)
     bf8:	f15a                	sd	s6,160(sp)
     bfa:	ed5e                	sd	s7,152(sp)
     bfc:	1180                	addi	s0,sp,224
  
  int fd = open(".time",O_RDONLY);
     bfe:	4581                	li	a1,0
     c00:	00001517          	auipc	a0,0x1
     c04:	fc050513          	addi	a0,a0,-64 # 1bc0 <get_time_perf+0x92>
     c08:	00000097          	auipc	ra,0x0
     c0c:	5ca080e7          	jalr	1482(ra) # 11d2 <open>
     c10:	8a2a                	mv	s4,a0

  printf("\n\nTIME---------------------\n");
     c12:	00001517          	auipc	a0,0x1
     c16:	08650513          	addi	a0,a0,134 # 1c98 <get_time_perf+0x16a>
     c1a:	00001097          	auipc	ra,0x1
     c1e:	932080e7          	jalr	-1742(ra) # 154c <printf>

  long totalTime = 0;
     c22:	4b01                	li	s6,0

    /* Reading the timing information */
    e_time_t time;
    read(fd, &time, sizeof(e_time_t));

    tick_to_time("Creation: ",time.creationTime * 100);
     c24:	08bb39b7          	lui	s3,0x8bb3
     c28:	c9798993          	addi	s3,s3,-873 # 8bb2c97 <base+0x8bb0c0f>
     c2c:	09b2                	slli	s3,s3,0xc
     c2e:	6a89                	lui	s5,0x2
     c30:	710a8a93          	addi	s5,s5,1808 # 2710 <base+0x688>
     c34:	005b9937          	lui	s2,0x5b9
     c38:	d8090913          	addi	s2,s2,-640 # 5b8d80 <base+0x5b6cf8>
     c3c:	a211                	j	d40 <print_time_infos+0x158>
    read(fd, cmdName, cmdLen);
     c3e:	f2442603          	lw	a2,-220(s0)
     c42:	f4840593          	addi	a1,s0,-184
     c46:	8552                	mv	a0,s4
     c48:	00000097          	auipc	ra,0x0
     c4c:	562080e7          	jalr	1378(ra) # 11aa <read>
    cmdName[cmdLen]=0;
     c50:	f2442783          	lw	a5,-220(s0)
     c54:	fb078793          	addi	a5,a5,-80
     c58:	97a2                	add	a5,a5,s0
     c5a:	f8078c23          	sb	zero,-104(a5)
    printf("CMD: %s\n", cmdName);
     c5e:	f4840593          	addi	a1,s0,-184
     c62:	00001517          	auipc	a0,0x1
     c66:	05650513          	addi	a0,a0,86 # 1cb8 <get_time_perf+0x18a>
     c6a:	00001097          	auipc	ra,0x1
     c6e:	8e2080e7          	jalr	-1822(ra) # 154c <printf>
    read(fd, &time, sizeof(e_time_t));
     c72:	02000613          	li	a2,32
     c76:	f2840593          	addi	a1,s0,-216
     c7a:	8552                	mv	a0,s4
     c7c:	00000097          	auipc	ra,0x0
     c80:	52e080e7          	jalr	1326(ra) # 11aa <read>
    tick_to_time("Creation: ",time.creationTime * 100);
     c84:	06400493          	li	s1,100
     c88:	f2843783          	ld	a5,-216(s0)
     c8c:	02f487b3          	mul	a5,s1,a5
     c90:	0337f733          	remu	a4,a5,s3
     c94:	0327f6b3          	remu	a3,a5,s2
     c98:	6be1                	lui	s7,0x18
     c9a:	6a0b8b93          	addi	s7,s7,1696 # 186a0 <base+0x16618>
     c9e:	03575733          	divu	a4,a4,s5
     ca2:	0376d6b3          	divu	a3,a3,s7
     ca6:	0327d633          	divu	a2,a5,s2
     caa:	00001597          	auipc	a1,0x1
     cae:	01e58593          	addi	a1,a1,30 # 1cc8 <get_time_perf+0x19a>
     cb2:	00001517          	auipc	a0,0x1
     cb6:	02650513          	addi	a0,a0,38 # 1cd8 <get_time_perf+0x1aa>
     cba:	00001097          	auipc	ra,0x1
     cbe:	892080e7          	jalr	-1902(ra) # 154c <printf>
    tick_to_time("End: ", time.endTime * 100);
     cc2:	f3043783          	ld	a5,-208(s0)
     cc6:	02f487b3          	mul	a5,s1,a5
     cca:	0337f733          	remu	a4,a5,s3
     cce:	0327f6b3          	remu	a3,a5,s2
     cd2:	03575733          	divu	a4,a4,s5
     cd6:	0376d6b3          	divu	a3,a3,s7
     cda:	0327d633          	divu	a2,a5,s2
     cde:	00001597          	auipc	a1,0x1
     ce2:	02258593          	addi	a1,a1,34 # 1d00 <get_time_perf+0x1d2>
     ce6:	00001517          	auipc	a0,0x1
     cea:	ff250513          	addi	a0,a0,-14 # 1cd8 <get_time_perf+0x1aa>
     cee:	00001097          	auipc	ra,0x1
     cf2:	85e080e7          	jalr	-1954(ra) # 154c <printf>
    tick_to_time("Duration: ", time.totalTime * 100);
     cf6:	f3843783          	ld	a5,-200(s0)
     cfa:	02f487b3          	mul	a5,s1,a5
     cfe:	0337f733          	remu	a4,a5,s3
     d02:	0327f6b3          	remu	a3,a5,s2
     d06:	03575733          	divu	a4,a4,s5
     d0a:	0376d6b3          	divu	a3,a3,s7
     d0e:	0327d633          	divu	a2,a5,s2
     d12:	00001597          	auipc	a1,0x1
     d16:	ff658593          	addi	a1,a1,-10 # 1d08 <get_time_perf+0x1da>
     d1a:	00001517          	auipc	a0,0x1
     d1e:	fbe50513          	addi	a0,a0,-66 # 1cd8 <get_time_perf+0x1aa>
     d22:	00001097          	auipc	ra,0x1
     d26:	82a080e7          	jalr	-2006(ra) # 154c <printf>

    totalTime += time.totalTime;
     d2a:	f3843783          	ld	a5,-200(s0)
     d2e:	9b3e                	add	s6,s6,a5

    printf("\n");
     d30:	00001517          	auipc	a0,0x1
     d34:	04850513          	addi	a0,a0,72 # 1d78 <get_time_perf+0x24a>
     d38:	00001097          	auipc	ra,0x1
     d3c:	814080e7          	jalr	-2028(ra) # 154c <printf>
    if (read(fd, &cmdLen, sizeof(int))<=0)
     d40:	4611                	li	a2,4
     d42:	f2440593          	addi	a1,s0,-220
     d46:	8552                	mv	a0,s4
     d48:	00000097          	auipc	ra,0x0
     d4c:	462080e7          	jalr	1122(ra) # 11aa <read>
     d50:	eea047e3          	bgtz	a0,c3e <print_time_infos+0x56>
  }

  printf("------------Total------------\n");
     d54:	00001517          	auipc	a0,0x1
     d58:	fc450513          	addi	a0,a0,-60 # 1d18 <get_time_perf+0x1ea>
     d5c:	00000097          	auipc	ra,0x0
     d60:	7f0080e7          	jalr	2032(ra) # 154c <printf>
  tick_to_time("Total: ", totalTime * 100);
     d64:	06400793          	li	a5,100
     d68:	02fb07b3          	mul	a5,s6,a5
     d6c:	08bb3637          	lui	a2,0x8bb3
     d70:	c9760613          	addi	a2,a2,-873 # 8bb2c97 <base+0x8bb0c0f>
     d74:	0632                	slli	a2,a2,0xc
     d76:	02c7e633          	rem	a2,a5,a2
     d7a:	005b95b7          	lui	a1,0x5b9
     d7e:	d8058593          	addi	a1,a1,-640 # 5b8d80 <base+0x5b6cf8>
     d82:	02b7e5b3          	rem	a1,a5,a1
     d86:	6709                	lui	a4,0x2
     d88:	71070713          	addi	a4,a4,1808 # 2710 <base+0x688>
     d8c:	02e64733          	div	a4,a2,a4
     d90:	66e1                	lui	a3,0x18
     d92:	6a068693          	addi	a3,a3,1696 # 186a0 <base+0x16618>
     d96:	02d5c6b3          	div	a3,a1,a3
     d9a:	663d                	lui	a2,0xf
     d9c:	a6060613          	addi	a2,a2,-1440 # ea60 <base+0xc9d8>
     da0:	02cb4633          	div	a2,s6,a2
     da4:	00001597          	auipc	a1,0x1
     da8:	f9458593          	addi	a1,a1,-108 # 1d38 <get_time_perf+0x20a>
     dac:	00001517          	auipc	a0,0x1
     db0:	f2c50513          	addi	a0,a0,-212 # 1cd8 <get_time_perf+0x1aa>
     db4:	00000097          	auipc	ra,0x0
     db8:	798080e7          	jalr	1944(ra) # 154c <printf>
}
     dbc:	60ee                	ld	ra,216(sp)
     dbe:	644e                	ld	s0,208(sp)
     dc0:	64ae                	ld	s1,200(sp)
     dc2:	690e                	ld	s2,192(sp)
     dc4:	79ea                	ld	s3,184(sp)
     dc6:	7a4a                	ld	s4,176(sp)
     dc8:	7aaa                	ld	s5,168(sp)
     dca:	7b0a                	ld	s6,160(sp)
     dcc:	6bea                	ld	s7,152(sp)
     dce:	612d                	addi	sp,sp,224
     dd0:	8082                	ret

0000000000000dd2 <main>:


int
main(void)
{
     dd2:	715d                	addi	sp,sp,-80
     dd4:	e486                	sd	ra,72(sp)
     dd6:	e0a2                	sd	s0,64(sp)
     dd8:	fc26                	sd	s1,56(sp)
     dda:	f84a                	sd	s2,48(sp)
     ddc:	f44e                	sd	s3,40(sp)
     dde:	f052                	sd	s4,32(sp)
     de0:	ec56                	sd	s5,24(sp)
     de2:	e85a                	sd	s6,16(sp)
     de4:	e45e                	sd	s7,8(sp)
     de6:	0880                	addi	s0,sp,80

  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     de8:	00001497          	auipc	s1,0x1
     dec:	f5848493          	addi	s1,s1,-168 # 1d40 <get_time_perf+0x212>
     df0:	4589                	li	a1,2
     df2:	8526                	mv	a0,s1
     df4:	00000097          	auipc	ra,0x0
     df8:	3de080e7          	jalr	990(ra) # 11d2 <open>
     dfc:	00054963          	bltz	a0,e0e <main+0x3c>
    if(fd >= 3){
     e00:	4789                	li	a5,2
     e02:	fea7d7e3          	bge	a5,a0,df0 <main+0x1e>
      close(fd);
     e06:	00000097          	auipc	ra,0x0
     e0a:	3b4080e7          	jalr	948(ra) # 11ba <close>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     e0e:	00001497          	auipc	s1,0x1
     e12:	21248493          	addi	s1,s1,530 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     e16:	06300993          	li	s3,99
      runcmd(parsecmd(buf));
    }
    wait(0);

     /* Check for the existance of .time file and if it exists, remove it */
    if (open(".time",O_RDONLY)>0){
     e1a:	00001917          	auipc	s2,0x1
     e1e:	da690913          	addi	s2,s2,-602 # 1bc0 <get_time_perf+0x92>

      /* Process the content */
      print_time_infos();

      if(unlink(".time") < 0)
        printf("[ERR] Deleting .time file failed\n");
     e22:	00001a97          	auipc	s5,0x1
     e26:	f36a8a93          	addi	s5,s5,-202 # 1d58 <get_time_perf+0x22a>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     e2a:	02000a13          	li	s4,32
      if(chdir(buf+3) < 0)
     e2e:	00001b17          	auipc	s6,0x1
     e32:	1f5b0b13          	addi	s6,s6,501 # 2023 <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     e36:	00001b97          	auipc	s7,0x1
     e3a:	f12b8b93          	addi	s7,s7,-238 # 1d48 <get_time_perf+0x21a>
     e3e:	a01d                	j	e64 <main+0x92>
    if(fork1() == 0){
     e40:	fffff097          	auipc	ra,0xfffff
     e44:	2ac080e7          	jalr	684(ra) # ec <fork1>
     e48:	c141                	beqz	a0,ec8 <main+0xf6>
    wait(0);
     e4a:	4501                	li	a0,0
     e4c:	00000097          	auipc	ra,0x0
     e50:	34e080e7          	jalr	846(ra) # 119a <wait>
    if (open(".time",O_RDONLY)>0){
     e54:	4581                	li	a1,0
     e56:	854a                	mv	a0,s2
     e58:	00000097          	auipc	ra,0x0
     e5c:	37a080e7          	jalr	890(ra) # 11d2 <open>
     e60:	08a04063          	bgtz	a0,ee0 <main+0x10e>
  while(getcmd(buf, sizeof(buf)) >= 0){
     e64:	06400593          	li	a1,100
     e68:	8526                	mv	a0,s1
     e6a:	fffff097          	auipc	ra,0xfffff
     e6e:	206080e7          	jalr	518(ra) # 70 <getcmd>
     e72:	08054863          	bltz	a0,f02 <main+0x130>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     e76:	0004c783          	lbu	a5,0(s1)
     e7a:	fd3793e3          	bne	a5,s3,e40 <main+0x6e>
     e7e:	0014c703          	lbu	a4,1(s1)
     e82:	06400793          	li	a5,100
     e86:	faf71de3          	bne	a4,a5,e40 <main+0x6e>
     e8a:	0024c783          	lbu	a5,2(s1)
     e8e:	fb4799e3          	bne	a5,s4,e40 <main+0x6e>
      buf[strlen(buf)-1] = 0;  // chop \n
     e92:	8526                	mv	a0,s1
     e94:	00000097          	auipc	ra,0x0
     e98:	0da080e7          	jalr	218(ra) # f6e <strlen>
     e9c:	fff5079b          	addiw	a5,a0,-1
     ea0:	1782                	slli	a5,a5,0x20
     ea2:	9381                	srli	a5,a5,0x20
     ea4:	97a6                	add	a5,a5,s1
     ea6:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     eaa:	855a                	mv	a0,s6
     eac:	00000097          	auipc	ra,0x0
     eb0:	356080e7          	jalr	854(ra) # 1202 <chdir>
     eb4:	fa0558e3          	bgez	a0,e64 <main+0x92>
        fprintf(2, "cannot cd %s\n", buf+3);
     eb8:	865a                	mv	a2,s6
     eba:	85de                	mv	a1,s7
     ebc:	4509                	li	a0,2
     ebe:	00000097          	auipc	ra,0x0
     ec2:	660080e7          	jalr	1632(ra) # 151e <fprintf>
     ec6:	bf79                	j	e64 <main+0x92>
      runcmd(parsecmd(buf));
     ec8:	00001517          	auipc	a0,0x1
     ecc:	15850513          	addi	a0,a0,344 # 2020 <buf.0>
     ed0:	00000097          	auipc	ra,0x0
     ed4:	c38080e7          	jalr	-968(ra) # b08 <parsecmd>
     ed8:	fffff097          	auipc	ra,0xfffff
     edc:	242080e7          	jalr	578(ra) # 11a <runcmd>
      print_time_infos();
     ee0:	00000097          	auipc	ra,0x0
     ee4:	d08080e7          	jalr	-760(ra) # be8 <print_time_infos>
      if(unlink(".time") < 0)
     ee8:	854a                	mv	a0,s2
     eea:	00000097          	auipc	ra,0x0
     eee:	2f8080e7          	jalr	760(ra) # 11e2 <unlink>
     ef2:	f60559e3          	bgez	a0,e64 <main+0x92>
        printf("[ERR] Deleting .time file failed\n");
     ef6:	8556                	mv	a0,s5
     ef8:	00000097          	auipc	ra,0x0
     efc:	654080e7          	jalr	1620(ra) # 154c <printf>
     f00:	b795                	j	e64 <main+0x92>
    }
  }
  exit(0);
     f02:	4501                	li	a0,0
     f04:	00000097          	auipc	ra,0x0
     f08:	28e080e7          	jalr	654(ra) # 1192 <exit>

0000000000000f0c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     f0c:	1141                	addi	sp,sp,-16
     f0e:	e406                	sd	ra,8(sp)
     f10:	e022                	sd	s0,0(sp)
     f12:	0800                	addi	s0,sp,16
  extern int main();
  main();
     f14:	00000097          	auipc	ra,0x0
     f18:	ebe080e7          	jalr	-322(ra) # dd2 <main>
  exit(0);
     f1c:	4501                	li	a0,0
     f1e:	00000097          	auipc	ra,0x0
     f22:	274080e7          	jalr	628(ra) # 1192 <exit>

0000000000000f26 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     f26:	1141                	addi	sp,sp,-16
     f28:	e422                	sd	s0,8(sp)
     f2a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     f2c:	87aa                	mv	a5,a0
     f2e:	0585                	addi	a1,a1,1
     f30:	0785                	addi	a5,a5,1
     f32:	fff5c703          	lbu	a4,-1(a1)
     f36:	fee78fa3          	sb	a4,-1(a5)
     f3a:	fb75                	bnez	a4,f2e <strcpy+0x8>
    ;
  return os;
}
     f3c:	6422                	ld	s0,8(sp)
     f3e:	0141                	addi	sp,sp,16
     f40:	8082                	ret

0000000000000f42 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     f42:	1141                	addi	sp,sp,-16
     f44:	e422                	sd	s0,8(sp)
     f46:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     f48:	00054783          	lbu	a5,0(a0)
     f4c:	cb91                	beqz	a5,f60 <strcmp+0x1e>
     f4e:	0005c703          	lbu	a4,0(a1)
     f52:	00f71763          	bne	a4,a5,f60 <strcmp+0x1e>
    p++, q++;
     f56:	0505                	addi	a0,a0,1
     f58:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     f5a:	00054783          	lbu	a5,0(a0)
     f5e:	fbe5                	bnez	a5,f4e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     f60:	0005c503          	lbu	a0,0(a1)
}
     f64:	40a7853b          	subw	a0,a5,a0
     f68:	6422                	ld	s0,8(sp)
     f6a:	0141                	addi	sp,sp,16
     f6c:	8082                	ret

0000000000000f6e <strlen>:

uint
strlen(const char *s)
{
     f6e:	1141                	addi	sp,sp,-16
     f70:	e422                	sd	s0,8(sp)
     f72:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     f74:	00054783          	lbu	a5,0(a0)
     f78:	cf91                	beqz	a5,f94 <strlen+0x26>
     f7a:	0505                	addi	a0,a0,1
     f7c:	87aa                	mv	a5,a0
     f7e:	4685                	li	a3,1
     f80:	9e89                	subw	a3,a3,a0
     f82:	00f6853b          	addw	a0,a3,a5
     f86:	0785                	addi	a5,a5,1
     f88:	fff7c703          	lbu	a4,-1(a5)
     f8c:	fb7d                	bnez	a4,f82 <strlen+0x14>
    ;
  return n;
}
     f8e:	6422                	ld	s0,8(sp)
     f90:	0141                	addi	sp,sp,16
     f92:	8082                	ret
  for(n = 0; s[n]; n++)
     f94:	4501                	li	a0,0
     f96:	bfe5                	j	f8e <strlen+0x20>

0000000000000f98 <memset>:

void*
memset(void *dst, int c, uint n)
{
     f98:	1141                	addi	sp,sp,-16
     f9a:	e422                	sd	s0,8(sp)
     f9c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     f9e:	ca19                	beqz	a2,fb4 <memset+0x1c>
     fa0:	87aa                	mv	a5,a0
     fa2:	1602                	slli	a2,a2,0x20
     fa4:	9201                	srli	a2,a2,0x20
     fa6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     faa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     fae:	0785                	addi	a5,a5,1
     fb0:	fee79de3          	bne	a5,a4,faa <memset+0x12>
  }
  return dst;
}
     fb4:	6422                	ld	s0,8(sp)
     fb6:	0141                	addi	sp,sp,16
     fb8:	8082                	ret

0000000000000fba <strchr>:

char*
strchr(const char *s, char c)
{
     fba:	1141                	addi	sp,sp,-16
     fbc:	e422                	sd	s0,8(sp)
     fbe:	0800                	addi	s0,sp,16
  for(; *s; s++)
     fc0:	00054783          	lbu	a5,0(a0)
     fc4:	cb99                	beqz	a5,fda <strchr+0x20>
    if(*s == c)
     fc6:	00f58763          	beq	a1,a5,fd4 <strchr+0x1a>
  for(; *s; s++)
     fca:	0505                	addi	a0,a0,1
     fcc:	00054783          	lbu	a5,0(a0)
     fd0:	fbfd                	bnez	a5,fc6 <strchr+0xc>
      return (char*)s;
  return 0;
     fd2:	4501                	li	a0,0
}
     fd4:	6422                	ld	s0,8(sp)
     fd6:	0141                	addi	sp,sp,16
     fd8:	8082                	ret
  return 0;
     fda:	4501                	li	a0,0
     fdc:	bfe5                	j	fd4 <strchr+0x1a>

0000000000000fde <gets>:

char*
gets(char *buf, int max)
{
     fde:	711d                	addi	sp,sp,-96
     fe0:	ec86                	sd	ra,88(sp)
     fe2:	e8a2                	sd	s0,80(sp)
     fe4:	e4a6                	sd	s1,72(sp)
     fe6:	e0ca                	sd	s2,64(sp)
     fe8:	fc4e                	sd	s3,56(sp)
     fea:	f852                	sd	s4,48(sp)
     fec:	f456                	sd	s5,40(sp)
     fee:	f05a                	sd	s6,32(sp)
     ff0:	ec5e                	sd	s7,24(sp)
     ff2:	1080                	addi	s0,sp,96
     ff4:	8baa                	mv	s7,a0
     ff6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ff8:	892a                	mv	s2,a0
     ffa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     ffc:	4aa9                	li	s5,10
     ffe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1000:	89a6                	mv	s3,s1
    1002:	2485                	addiw	s1,s1,1
    1004:	0344d863          	bge	s1,s4,1034 <gets+0x56>
    cc = read(0, &c, 1);
    1008:	4605                	li	a2,1
    100a:	faf40593          	addi	a1,s0,-81
    100e:	4501                	li	a0,0
    1010:	00000097          	auipc	ra,0x0
    1014:	19a080e7          	jalr	410(ra) # 11aa <read>
    if(cc < 1)
    1018:	00a05e63          	blez	a0,1034 <gets+0x56>
    buf[i++] = c;
    101c:	faf44783          	lbu	a5,-81(s0)
    1020:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1024:	01578763          	beq	a5,s5,1032 <gets+0x54>
    1028:	0905                	addi	s2,s2,1
    102a:	fd679be3          	bne	a5,s6,1000 <gets+0x22>
  for(i=0; i+1 < max; ){
    102e:	89a6                	mv	s3,s1
    1030:	a011                	j	1034 <gets+0x56>
    1032:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1034:	99de                	add	s3,s3,s7
    1036:	00098023          	sb	zero,0(s3)
  return buf;
}
    103a:	855e                	mv	a0,s7
    103c:	60e6                	ld	ra,88(sp)
    103e:	6446                	ld	s0,80(sp)
    1040:	64a6                	ld	s1,72(sp)
    1042:	6906                	ld	s2,64(sp)
    1044:	79e2                	ld	s3,56(sp)
    1046:	7a42                	ld	s4,48(sp)
    1048:	7aa2                	ld	s5,40(sp)
    104a:	7b02                	ld	s6,32(sp)
    104c:	6be2                	ld	s7,24(sp)
    104e:	6125                	addi	sp,sp,96
    1050:	8082                	ret

0000000000001052 <stat>:

int
stat(const char *n, struct stat *st)
{
    1052:	1101                	addi	sp,sp,-32
    1054:	ec06                	sd	ra,24(sp)
    1056:	e822                	sd	s0,16(sp)
    1058:	e426                	sd	s1,8(sp)
    105a:	e04a                	sd	s2,0(sp)
    105c:	1000                	addi	s0,sp,32
    105e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1060:	4581                	li	a1,0
    1062:	00000097          	auipc	ra,0x0
    1066:	170080e7          	jalr	368(ra) # 11d2 <open>
  if(fd < 0)
    106a:	02054563          	bltz	a0,1094 <stat+0x42>
    106e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1070:	85ca                	mv	a1,s2
    1072:	00000097          	auipc	ra,0x0
    1076:	178080e7          	jalr	376(ra) # 11ea <fstat>
    107a:	892a                	mv	s2,a0
  close(fd);
    107c:	8526                	mv	a0,s1
    107e:	00000097          	auipc	ra,0x0
    1082:	13c080e7          	jalr	316(ra) # 11ba <close>
  return r;
}
    1086:	854a                	mv	a0,s2
    1088:	60e2                	ld	ra,24(sp)
    108a:	6442                	ld	s0,16(sp)
    108c:	64a2                	ld	s1,8(sp)
    108e:	6902                	ld	s2,0(sp)
    1090:	6105                	addi	sp,sp,32
    1092:	8082                	ret
    return -1;
    1094:	597d                	li	s2,-1
    1096:	bfc5                	j	1086 <stat+0x34>

0000000000001098 <atoi>:

int
atoi(const char *s)
{
    1098:	1141                	addi	sp,sp,-16
    109a:	e422                	sd	s0,8(sp)
    109c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    109e:	00054683          	lbu	a3,0(a0)
    10a2:	fd06879b          	addiw	a5,a3,-48
    10a6:	0ff7f793          	zext.b	a5,a5
    10aa:	4625                	li	a2,9
    10ac:	02f66863          	bltu	a2,a5,10dc <atoi+0x44>
    10b0:	872a                	mv	a4,a0
  n = 0;
    10b2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    10b4:	0705                	addi	a4,a4,1
    10b6:	0025179b          	slliw	a5,a0,0x2
    10ba:	9fa9                	addw	a5,a5,a0
    10bc:	0017979b          	slliw	a5,a5,0x1
    10c0:	9fb5                	addw	a5,a5,a3
    10c2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    10c6:	00074683          	lbu	a3,0(a4)
    10ca:	fd06879b          	addiw	a5,a3,-48
    10ce:	0ff7f793          	zext.b	a5,a5
    10d2:	fef671e3          	bgeu	a2,a5,10b4 <atoi+0x1c>
  return n;
}
    10d6:	6422                	ld	s0,8(sp)
    10d8:	0141                	addi	sp,sp,16
    10da:	8082                	ret
  n = 0;
    10dc:	4501                	li	a0,0
    10de:	bfe5                	j	10d6 <atoi+0x3e>

00000000000010e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    10e0:	1141                	addi	sp,sp,-16
    10e2:	e422                	sd	s0,8(sp)
    10e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    10e6:	02b57463          	bgeu	a0,a1,110e <memmove+0x2e>
    while(n-- > 0)
    10ea:	00c05f63          	blez	a2,1108 <memmove+0x28>
    10ee:	1602                	slli	a2,a2,0x20
    10f0:	9201                	srli	a2,a2,0x20
    10f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    10f6:	872a                	mv	a4,a0
      *dst++ = *src++;
    10f8:	0585                	addi	a1,a1,1
    10fa:	0705                	addi	a4,a4,1
    10fc:	fff5c683          	lbu	a3,-1(a1)
    1100:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    1104:	fee79ae3          	bne	a5,a4,10f8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    1108:	6422                	ld	s0,8(sp)
    110a:	0141                	addi	sp,sp,16
    110c:	8082                	ret
    dst += n;
    110e:	00c50733          	add	a4,a0,a2
    src += n;
    1112:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    1114:	fec05ae3          	blez	a2,1108 <memmove+0x28>
    1118:	fff6079b          	addiw	a5,a2,-1
    111c:	1782                	slli	a5,a5,0x20
    111e:	9381                	srli	a5,a5,0x20
    1120:	fff7c793          	not	a5,a5
    1124:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    1126:	15fd                	addi	a1,a1,-1
    1128:	177d                	addi	a4,a4,-1
    112a:	0005c683          	lbu	a3,0(a1)
    112e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1132:	fee79ae3          	bne	a5,a4,1126 <memmove+0x46>
    1136:	bfc9                	j	1108 <memmove+0x28>

0000000000001138 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1138:	1141                	addi	sp,sp,-16
    113a:	e422                	sd	s0,8(sp)
    113c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    113e:	ca05                	beqz	a2,116e <memcmp+0x36>
    1140:	fff6069b          	addiw	a3,a2,-1
    1144:	1682                	slli	a3,a3,0x20
    1146:	9281                	srli	a3,a3,0x20
    1148:	0685                	addi	a3,a3,1
    114a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    114c:	00054783          	lbu	a5,0(a0)
    1150:	0005c703          	lbu	a4,0(a1)
    1154:	00e79863          	bne	a5,a4,1164 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    1158:	0505                	addi	a0,a0,1
    p2++;
    115a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    115c:	fed518e3          	bne	a0,a3,114c <memcmp+0x14>
  }
  return 0;
    1160:	4501                	li	a0,0
    1162:	a019                	j	1168 <memcmp+0x30>
      return *p1 - *p2;
    1164:	40e7853b          	subw	a0,a5,a4
}
    1168:	6422                	ld	s0,8(sp)
    116a:	0141                	addi	sp,sp,16
    116c:	8082                	ret
  return 0;
    116e:	4501                	li	a0,0
    1170:	bfe5                	j	1168 <memcmp+0x30>

0000000000001172 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    1172:	1141                	addi	sp,sp,-16
    1174:	e406                	sd	ra,8(sp)
    1176:	e022                	sd	s0,0(sp)
    1178:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    117a:	00000097          	auipc	ra,0x0
    117e:	f66080e7          	jalr	-154(ra) # 10e0 <memmove>
}
    1182:	60a2                	ld	ra,8(sp)
    1184:	6402                	ld	s0,0(sp)
    1186:	0141                	addi	sp,sp,16
    1188:	8082                	ret

000000000000118a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    118a:	4885                	li	a7,1
 ecall
    118c:	00000073          	ecall
 ret
    1190:	8082                	ret

0000000000001192 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1192:	4889                	li	a7,2
 ecall
    1194:	00000073          	ecall
 ret
    1198:	8082                	ret

000000000000119a <wait>:
.global wait
wait:
 li a7, SYS_wait
    119a:	488d                	li	a7,3
 ecall
    119c:	00000073          	ecall
 ret
    11a0:	8082                	ret

00000000000011a2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    11a2:	4891                	li	a7,4
 ecall
    11a4:	00000073          	ecall
 ret
    11a8:	8082                	ret

00000000000011aa <read>:
.global read
read:
 li a7, SYS_read
    11aa:	4895                	li	a7,5
 ecall
    11ac:	00000073          	ecall
 ret
    11b0:	8082                	ret

00000000000011b2 <write>:
.global write
write:
 li a7, SYS_write
    11b2:	48c1                	li	a7,16
 ecall
    11b4:	00000073          	ecall
 ret
    11b8:	8082                	ret

00000000000011ba <close>:
.global close
close:
 li a7, SYS_close
    11ba:	48d5                	li	a7,21
 ecall
    11bc:	00000073          	ecall
 ret
    11c0:	8082                	ret

00000000000011c2 <kill>:
.global kill
kill:
 li a7, SYS_kill
    11c2:	4899                	li	a7,6
 ecall
    11c4:	00000073          	ecall
 ret
    11c8:	8082                	ret

00000000000011ca <exec>:
.global exec
exec:
 li a7, SYS_exec
    11ca:	489d                	li	a7,7
 ecall
    11cc:	00000073          	ecall
 ret
    11d0:	8082                	ret

00000000000011d2 <open>:
.global open
open:
 li a7, SYS_open
    11d2:	48bd                	li	a7,15
 ecall
    11d4:	00000073          	ecall
 ret
    11d8:	8082                	ret

00000000000011da <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    11da:	48c5                	li	a7,17
 ecall
    11dc:	00000073          	ecall
 ret
    11e0:	8082                	ret

00000000000011e2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    11e2:	48c9                	li	a7,18
 ecall
    11e4:	00000073          	ecall
 ret
    11e8:	8082                	ret

00000000000011ea <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    11ea:	48a1                	li	a7,8
 ecall
    11ec:	00000073          	ecall
 ret
    11f0:	8082                	ret

00000000000011f2 <link>:
.global link
link:
 li a7, SYS_link
    11f2:	48cd                	li	a7,19
 ecall
    11f4:	00000073          	ecall
 ret
    11f8:	8082                	ret

00000000000011fa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    11fa:	48d1                	li	a7,20
 ecall
    11fc:	00000073          	ecall
 ret
    1200:	8082                	ret

0000000000001202 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1202:	48a5                	li	a7,9
 ecall
    1204:	00000073          	ecall
 ret
    1208:	8082                	ret

000000000000120a <dup>:
.global dup
dup:
 li a7, SYS_dup
    120a:	48a9                	li	a7,10
 ecall
    120c:	00000073          	ecall
 ret
    1210:	8082                	ret

0000000000001212 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1212:	48ad                	li	a7,11
 ecall
    1214:	00000073          	ecall
 ret
    1218:	8082                	ret

000000000000121a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    121a:	48b1                	li	a7,12
 ecall
    121c:	00000073          	ecall
 ret
    1220:	8082                	ret

0000000000001222 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1222:	48b5                	li	a7,13
 ecall
    1224:	00000073          	ecall
 ret
    1228:	8082                	ret

000000000000122a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    122a:	48b9                	li	a7,14
 ecall
    122c:	00000073          	ecall
 ret
    1230:	8082                	ret

0000000000001232 <head>:
.global head
head:
 li a7, SYS_head
    1232:	48d9                	li	a7,22
 ecall
    1234:	00000073          	ecall
 ret
    1238:	8082                	ret

000000000000123a <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
    123a:	48dd                	li	a7,23
 ecall
    123c:	00000073          	ecall
 ret
    1240:	8082                	ret

0000000000001242 <ps>:
.global ps
ps:
 li a7, SYS_ps
    1242:	48e1                	li	a7,24
 ecall
    1244:	00000073          	ecall
 ret
    1248:	8082                	ret

000000000000124a <times>:
.global times
times:
 li a7, SYS_times
    124a:	48e5                	li	a7,25
 ecall
    124c:	00000073          	ecall
 ret
    1250:	8082                	ret

0000000000001252 <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
    1252:	48e9                	li	a7,26
 ecall
    1254:	00000073          	ecall
 ret
    1258:	8082                	ret

000000000000125a <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
    125a:	48ed                	li	a7,27
 ecall
    125c:	00000073          	ecall
 ret
    1260:	8082                	ret

0000000000001262 <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
    1262:	48f1                	li	a7,28
 ecall
    1264:	00000073          	ecall
 ret
    1268:	8082                	ret

000000000000126a <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
    126a:	48f5                	li	a7,29
 ecall
    126c:	00000073          	ecall
 ret
    1270:	8082                	ret

0000000000001272 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1272:	1101                	addi	sp,sp,-32
    1274:	ec06                	sd	ra,24(sp)
    1276:	e822                	sd	s0,16(sp)
    1278:	1000                	addi	s0,sp,32
    127a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    127e:	4605                	li	a2,1
    1280:	fef40593          	addi	a1,s0,-17
    1284:	00000097          	auipc	ra,0x0
    1288:	f2e080e7          	jalr	-210(ra) # 11b2 <write>
}
    128c:	60e2                	ld	ra,24(sp)
    128e:	6442                	ld	s0,16(sp)
    1290:	6105                	addi	sp,sp,32
    1292:	8082                	ret

0000000000001294 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1294:	7139                	addi	sp,sp,-64
    1296:	fc06                	sd	ra,56(sp)
    1298:	f822                	sd	s0,48(sp)
    129a:	f426                	sd	s1,40(sp)
    129c:	f04a                	sd	s2,32(sp)
    129e:	ec4e                	sd	s3,24(sp)
    12a0:	0080                	addi	s0,sp,64
    12a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    12a4:	c299                	beqz	a3,12aa <printint+0x16>
    12a6:	0805c963          	bltz	a1,1338 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    12aa:	2581                	sext.w	a1,a1
  neg = 0;
    12ac:	4881                	li	a7,0
    12ae:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    12b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    12b4:	2601                	sext.w	a2,a2
    12b6:	00001517          	auipc	a0,0x1
    12ba:	b5a50513          	addi	a0,a0,-1190 # 1e10 <digits>
    12be:	883a                	mv	a6,a4
    12c0:	2705                	addiw	a4,a4,1
    12c2:	02c5f7bb          	remuw	a5,a1,a2
    12c6:	1782                	slli	a5,a5,0x20
    12c8:	9381                	srli	a5,a5,0x20
    12ca:	97aa                	add	a5,a5,a0
    12cc:	0007c783          	lbu	a5,0(a5)
    12d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    12d4:	0005879b          	sext.w	a5,a1
    12d8:	02c5d5bb          	divuw	a1,a1,a2
    12dc:	0685                	addi	a3,a3,1
    12de:	fec7f0e3          	bgeu	a5,a2,12be <printint+0x2a>
  if(neg)
    12e2:	00088c63          	beqz	a7,12fa <printint+0x66>
    buf[i++] = '-';
    12e6:	fd070793          	addi	a5,a4,-48
    12ea:	00878733          	add	a4,a5,s0
    12ee:	02d00793          	li	a5,45
    12f2:	fef70823          	sb	a5,-16(a4)
    12f6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    12fa:	02e05863          	blez	a4,132a <printint+0x96>
    12fe:	fc040793          	addi	a5,s0,-64
    1302:	00e78933          	add	s2,a5,a4
    1306:	fff78993          	addi	s3,a5,-1
    130a:	99ba                	add	s3,s3,a4
    130c:	377d                	addiw	a4,a4,-1
    130e:	1702                	slli	a4,a4,0x20
    1310:	9301                	srli	a4,a4,0x20
    1312:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1316:	fff94583          	lbu	a1,-1(s2)
    131a:	8526                	mv	a0,s1
    131c:	00000097          	auipc	ra,0x0
    1320:	f56080e7          	jalr	-170(ra) # 1272 <putc>
  while(--i >= 0)
    1324:	197d                	addi	s2,s2,-1
    1326:	ff3918e3          	bne	s2,s3,1316 <printint+0x82>
}
    132a:	70e2                	ld	ra,56(sp)
    132c:	7442                	ld	s0,48(sp)
    132e:	74a2                	ld	s1,40(sp)
    1330:	7902                	ld	s2,32(sp)
    1332:	69e2                	ld	s3,24(sp)
    1334:	6121                	addi	sp,sp,64
    1336:	8082                	ret
    x = -xx;
    1338:	40b005bb          	negw	a1,a1
    neg = 1;
    133c:	4885                	li	a7,1
    x = -xx;
    133e:	bf85                	j	12ae <printint+0x1a>

0000000000001340 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1340:	7119                	addi	sp,sp,-128
    1342:	fc86                	sd	ra,120(sp)
    1344:	f8a2                	sd	s0,112(sp)
    1346:	f4a6                	sd	s1,104(sp)
    1348:	f0ca                	sd	s2,96(sp)
    134a:	ecce                	sd	s3,88(sp)
    134c:	e8d2                	sd	s4,80(sp)
    134e:	e4d6                	sd	s5,72(sp)
    1350:	e0da                	sd	s6,64(sp)
    1352:	fc5e                	sd	s7,56(sp)
    1354:	f862                	sd	s8,48(sp)
    1356:	f466                	sd	s9,40(sp)
    1358:	f06a                	sd	s10,32(sp)
    135a:	ec6e                	sd	s11,24(sp)
    135c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    135e:	0005c903          	lbu	s2,0(a1)
    1362:	18090f63          	beqz	s2,1500 <vprintf+0x1c0>
    1366:	8aaa                	mv	s5,a0
    1368:	8b32                	mv	s6,a2
    136a:	00158493          	addi	s1,a1,1
  state = 0;
    136e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1370:	02500a13          	li	s4,37
    1374:	4c55                	li	s8,21
    1376:	00001c97          	auipc	s9,0x1
    137a:	a42c8c93          	addi	s9,s9,-1470 # 1db8 <get_time_perf+0x28a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    137e:	02800d93          	li	s11,40
  putc(fd, 'x');
    1382:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1384:	00001b97          	auipc	s7,0x1
    1388:	a8cb8b93          	addi	s7,s7,-1396 # 1e10 <digits>
    138c:	a839                	j	13aa <vprintf+0x6a>
        putc(fd, c);
    138e:	85ca                	mv	a1,s2
    1390:	8556                	mv	a0,s5
    1392:	00000097          	auipc	ra,0x0
    1396:	ee0080e7          	jalr	-288(ra) # 1272 <putc>
    139a:	a019                	j	13a0 <vprintf+0x60>
    } else if(state == '%'){
    139c:	01498d63          	beq	s3,s4,13b6 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    13a0:	0485                	addi	s1,s1,1
    13a2:	fff4c903          	lbu	s2,-1(s1)
    13a6:	14090d63          	beqz	s2,1500 <vprintf+0x1c0>
    if(state == 0){
    13aa:	fe0999e3          	bnez	s3,139c <vprintf+0x5c>
      if(c == '%'){
    13ae:	ff4910e3          	bne	s2,s4,138e <vprintf+0x4e>
        state = '%';
    13b2:	89d2                	mv	s3,s4
    13b4:	b7f5                	j	13a0 <vprintf+0x60>
      if(c == 'd'){
    13b6:	11490c63          	beq	s2,s4,14ce <vprintf+0x18e>
    13ba:	f9d9079b          	addiw	a5,s2,-99
    13be:	0ff7f793          	zext.b	a5,a5
    13c2:	10fc6e63          	bltu	s8,a5,14de <vprintf+0x19e>
    13c6:	f9d9079b          	addiw	a5,s2,-99
    13ca:	0ff7f713          	zext.b	a4,a5
    13ce:	10ec6863          	bltu	s8,a4,14de <vprintf+0x19e>
    13d2:	00271793          	slli	a5,a4,0x2
    13d6:	97e6                	add	a5,a5,s9
    13d8:	439c                	lw	a5,0(a5)
    13da:	97e6                	add	a5,a5,s9
    13dc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    13de:	008b0913          	addi	s2,s6,8
    13e2:	4685                	li	a3,1
    13e4:	4629                	li	a2,10
    13e6:	000b2583          	lw	a1,0(s6)
    13ea:	8556                	mv	a0,s5
    13ec:	00000097          	auipc	ra,0x0
    13f0:	ea8080e7          	jalr	-344(ra) # 1294 <printint>
    13f4:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    13f6:	4981                	li	s3,0
    13f8:	b765                	j	13a0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    13fa:	008b0913          	addi	s2,s6,8
    13fe:	4681                	li	a3,0
    1400:	4629                	li	a2,10
    1402:	000b2583          	lw	a1,0(s6)
    1406:	8556                	mv	a0,s5
    1408:	00000097          	auipc	ra,0x0
    140c:	e8c080e7          	jalr	-372(ra) # 1294 <printint>
    1410:	8b4a                	mv	s6,s2
      state = 0;
    1412:	4981                	li	s3,0
    1414:	b771                	j	13a0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1416:	008b0913          	addi	s2,s6,8
    141a:	4681                	li	a3,0
    141c:	866a                	mv	a2,s10
    141e:	000b2583          	lw	a1,0(s6)
    1422:	8556                	mv	a0,s5
    1424:	00000097          	auipc	ra,0x0
    1428:	e70080e7          	jalr	-400(ra) # 1294 <printint>
    142c:	8b4a                	mv	s6,s2
      state = 0;
    142e:	4981                	li	s3,0
    1430:	bf85                	j	13a0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1432:	008b0793          	addi	a5,s6,8
    1436:	f8f43423          	sd	a5,-120(s0)
    143a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    143e:	03000593          	li	a1,48
    1442:	8556                	mv	a0,s5
    1444:	00000097          	auipc	ra,0x0
    1448:	e2e080e7          	jalr	-466(ra) # 1272 <putc>
  putc(fd, 'x');
    144c:	07800593          	li	a1,120
    1450:	8556                	mv	a0,s5
    1452:	00000097          	auipc	ra,0x0
    1456:	e20080e7          	jalr	-480(ra) # 1272 <putc>
    145a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    145c:	03c9d793          	srli	a5,s3,0x3c
    1460:	97de                	add	a5,a5,s7
    1462:	0007c583          	lbu	a1,0(a5)
    1466:	8556                	mv	a0,s5
    1468:	00000097          	auipc	ra,0x0
    146c:	e0a080e7          	jalr	-502(ra) # 1272 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1470:	0992                	slli	s3,s3,0x4
    1472:	397d                	addiw	s2,s2,-1
    1474:	fe0914e3          	bnez	s2,145c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    1478:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    147c:	4981                	li	s3,0
    147e:	b70d                	j	13a0 <vprintf+0x60>
        s = va_arg(ap, char*);
    1480:	008b0913          	addi	s2,s6,8
    1484:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    1488:	02098163          	beqz	s3,14aa <vprintf+0x16a>
        while(*s != 0){
    148c:	0009c583          	lbu	a1,0(s3)
    1490:	c5ad                	beqz	a1,14fa <vprintf+0x1ba>
          putc(fd, *s);
    1492:	8556                	mv	a0,s5
    1494:	00000097          	auipc	ra,0x0
    1498:	dde080e7          	jalr	-546(ra) # 1272 <putc>
          s++;
    149c:	0985                	addi	s3,s3,1
        while(*s != 0){
    149e:	0009c583          	lbu	a1,0(s3)
    14a2:	f9e5                	bnez	a1,1492 <vprintf+0x152>
        s = va_arg(ap, char*);
    14a4:	8b4a                	mv	s6,s2
      state = 0;
    14a6:	4981                	li	s3,0
    14a8:	bde5                	j	13a0 <vprintf+0x60>
          s = "(null)";
    14aa:	00001997          	auipc	s3,0x1
    14ae:	90698993          	addi	s3,s3,-1786 # 1db0 <get_time_perf+0x282>
        while(*s != 0){
    14b2:	85ee                	mv	a1,s11
    14b4:	bff9                	j	1492 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    14b6:	008b0913          	addi	s2,s6,8
    14ba:	000b4583          	lbu	a1,0(s6)
    14be:	8556                	mv	a0,s5
    14c0:	00000097          	auipc	ra,0x0
    14c4:	db2080e7          	jalr	-590(ra) # 1272 <putc>
    14c8:	8b4a                	mv	s6,s2
      state = 0;
    14ca:	4981                	li	s3,0
    14cc:	bdd1                	j	13a0 <vprintf+0x60>
        putc(fd, c);
    14ce:	85d2                	mv	a1,s4
    14d0:	8556                	mv	a0,s5
    14d2:	00000097          	auipc	ra,0x0
    14d6:	da0080e7          	jalr	-608(ra) # 1272 <putc>
      state = 0;
    14da:	4981                	li	s3,0
    14dc:	b5d1                	j	13a0 <vprintf+0x60>
        putc(fd, '%');
    14de:	85d2                	mv	a1,s4
    14e0:	8556                	mv	a0,s5
    14e2:	00000097          	auipc	ra,0x0
    14e6:	d90080e7          	jalr	-624(ra) # 1272 <putc>
        putc(fd, c);
    14ea:	85ca                	mv	a1,s2
    14ec:	8556                	mv	a0,s5
    14ee:	00000097          	auipc	ra,0x0
    14f2:	d84080e7          	jalr	-636(ra) # 1272 <putc>
      state = 0;
    14f6:	4981                	li	s3,0
    14f8:	b565                	j	13a0 <vprintf+0x60>
        s = va_arg(ap, char*);
    14fa:	8b4a                	mv	s6,s2
      state = 0;
    14fc:	4981                	li	s3,0
    14fe:	b54d                	j	13a0 <vprintf+0x60>
    }
  }
}
    1500:	70e6                	ld	ra,120(sp)
    1502:	7446                	ld	s0,112(sp)
    1504:	74a6                	ld	s1,104(sp)
    1506:	7906                	ld	s2,96(sp)
    1508:	69e6                	ld	s3,88(sp)
    150a:	6a46                	ld	s4,80(sp)
    150c:	6aa6                	ld	s5,72(sp)
    150e:	6b06                	ld	s6,64(sp)
    1510:	7be2                	ld	s7,56(sp)
    1512:	7c42                	ld	s8,48(sp)
    1514:	7ca2                	ld	s9,40(sp)
    1516:	7d02                	ld	s10,32(sp)
    1518:	6de2                	ld	s11,24(sp)
    151a:	6109                	addi	sp,sp,128
    151c:	8082                	ret

000000000000151e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    151e:	715d                	addi	sp,sp,-80
    1520:	ec06                	sd	ra,24(sp)
    1522:	e822                	sd	s0,16(sp)
    1524:	1000                	addi	s0,sp,32
    1526:	e010                	sd	a2,0(s0)
    1528:	e414                	sd	a3,8(s0)
    152a:	e818                	sd	a4,16(s0)
    152c:	ec1c                	sd	a5,24(s0)
    152e:	03043023          	sd	a6,32(s0)
    1532:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1536:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    153a:	8622                	mv	a2,s0
    153c:	00000097          	auipc	ra,0x0
    1540:	e04080e7          	jalr	-508(ra) # 1340 <vprintf>
}
    1544:	60e2                	ld	ra,24(sp)
    1546:	6442                	ld	s0,16(sp)
    1548:	6161                	addi	sp,sp,80
    154a:	8082                	ret

000000000000154c <printf>:

void
printf(const char *fmt, ...)
{
    154c:	711d                	addi	sp,sp,-96
    154e:	ec06                	sd	ra,24(sp)
    1550:	e822                	sd	s0,16(sp)
    1552:	1000                	addi	s0,sp,32
    1554:	e40c                	sd	a1,8(s0)
    1556:	e810                	sd	a2,16(s0)
    1558:	ec14                	sd	a3,24(s0)
    155a:	f018                	sd	a4,32(s0)
    155c:	f41c                	sd	a5,40(s0)
    155e:	03043823          	sd	a6,48(s0)
    1562:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1566:	00840613          	addi	a2,s0,8
    156a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    156e:	85aa                	mv	a1,a0
    1570:	4505                	li	a0,1
    1572:	00000097          	auipc	ra,0x0
    1576:	dce080e7          	jalr	-562(ra) # 1340 <vprintf>
}
    157a:	60e2                	ld	ra,24(sp)
    157c:	6442                	ld	s0,16(sp)
    157e:	6125                	addi	sp,sp,96
    1580:	8082                	ret

0000000000001582 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1582:	1141                	addi	sp,sp,-16
    1584:	e422                	sd	s0,8(sp)
    1586:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1588:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    158c:	00001797          	auipc	a5,0x1
    1590:	a847b783          	ld	a5,-1404(a5) # 2010 <freep>
    1594:	a02d                	j	15be <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1596:	4618                	lw	a4,8(a2)
    1598:	9f2d                	addw	a4,a4,a1
    159a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    159e:	6398                	ld	a4,0(a5)
    15a0:	6310                	ld	a2,0(a4)
    15a2:	a83d                	j	15e0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    15a4:	ff852703          	lw	a4,-8(a0)
    15a8:	9f31                	addw	a4,a4,a2
    15aa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    15ac:	ff053683          	ld	a3,-16(a0)
    15b0:	a091                	j	15f4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15b2:	6398                	ld	a4,0(a5)
    15b4:	00e7e463          	bltu	a5,a4,15bc <free+0x3a>
    15b8:	00e6ea63          	bltu	a3,a4,15cc <free+0x4a>
{
    15bc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15be:	fed7fae3          	bgeu	a5,a3,15b2 <free+0x30>
    15c2:	6398                	ld	a4,0(a5)
    15c4:	00e6e463          	bltu	a3,a4,15cc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15c8:	fee7eae3          	bltu	a5,a4,15bc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    15cc:	ff852583          	lw	a1,-8(a0)
    15d0:	6390                	ld	a2,0(a5)
    15d2:	02059813          	slli	a6,a1,0x20
    15d6:	01c85713          	srli	a4,a6,0x1c
    15da:	9736                	add	a4,a4,a3
    15dc:	fae60de3          	beq	a2,a4,1596 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    15e0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    15e4:	4790                	lw	a2,8(a5)
    15e6:	02061593          	slli	a1,a2,0x20
    15ea:	01c5d713          	srli	a4,a1,0x1c
    15ee:	973e                	add	a4,a4,a5
    15f0:	fae68ae3          	beq	a3,a4,15a4 <free+0x22>
    p->s.ptr = bp->s.ptr;
    15f4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    15f6:	00001717          	auipc	a4,0x1
    15fa:	a0f73d23          	sd	a5,-1510(a4) # 2010 <freep>
}
    15fe:	6422                	ld	s0,8(sp)
    1600:	0141                	addi	sp,sp,16
    1602:	8082                	ret

0000000000001604 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1604:	7139                	addi	sp,sp,-64
    1606:	fc06                	sd	ra,56(sp)
    1608:	f822                	sd	s0,48(sp)
    160a:	f426                	sd	s1,40(sp)
    160c:	f04a                	sd	s2,32(sp)
    160e:	ec4e                	sd	s3,24(sp)
    1610:	e852                	sd	s4,16(sp)
    1612:	e456                	sd	s5,8(sp)
    1614:	e05a                	sd	s6,0(sp)
    1616:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1618:	02051493          	slli	s1,a0,0x20
    161c:	9081                	srli	s1,s1,0x20
    161e:	04bd                	addi	s1,s1,15
    1620:	8091                	srli	s1,s1,0x4
    1622:	0014899b          	addiw	s3,s1,1
    1626:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1628:	00001517          	auipc	a0,0x1
    162c:	9e853503          	ld	a0,-1560(a0) # 2010 <freep>
    1630:	c515                	beqz	a0,165c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1632:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1634:	4798                	lw	a4,8(a5)
    1636:	02977f63          	bgeu	a4,s1,1674 <malloc+0x70>
    163a:	8a4e                	mv	s4,s3
    163c:	0009871b          	sext.w	a4,s3
    1640:	6685                	lui	a3,0x1
    1642:	00d77363          	bgeu	a4,a3,1648 <malloc+0x44>
    1646:	6a05                	lui	s4,0x1
    1648:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    164c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1650:	00001917          	auipc	s2,0x1
    1654:	9c090913          	addi	s2,s2,-1600 # 2010 <freep>
  if(p == (char*)-1)
    1658:	5afd                	li	s5,-1
    165a:	a895                	j	16ce <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    165c:	00001797          	auipc	a5,0x1
    1660:	a2c78793          	addi	a5,a5,-1492 # 2088 <base>
    1664:	00001717          	auipc	a4,0x1
    1668:	9af73623          	sd	a5,-1620(a4) # 2010 <freep>
    166c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    166e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1672:	b7e1                	j	163a <malloc+0x36>
      if(p->s.size == nunits)
    1674:	02e48c63          	beq	s1,a4,16ac <malloc+0xa8>
        p->s.size -= nunits;
    1678:	4137073b          	subw	a4,a4,s3
    167c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    167e:	02071693          	slli	a3,a4,0x20
    1682:	01c6d713          	srli	a4,a3,0x1c
    1686:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1688:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    168c:	00001717          	auipc	a4,0x1
    1690:	98a73223          	sd	a0,-1660(a4) # 2010 <freep>
      return (void*)(p + 1);
    1694:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1698:	70e2                	ld	ra,56(sp)
    169a:	7442                	ld	s0,48(sp)
    169c:	74a2                	ld	s1,40(sp)
    169e:	7902                	ld	s2,32(sp)
    16a0:	69e2                	ld	s3,24(sp)
    16a2:	6a42                	ld	s4,16(sp)
    16a4:	6aa2                	ld	s5,8(sp)
    16a6:	6b02                	ld	s6,0(sp)
    16a8:	6121                	addi	sp,sp,64
    16aa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    16ac:	6398                	ld	a4,0(a5)
    16ae:	e118                	sd	a4,0(a0)
    16b0:	bff1                	j	168c <malloc+0x88>
  hp->s.size = nu;
    16b2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    16b6:	0541                	addi	a0,a0,16
    16b8:	00000097          	auipc	ra,0x0
    16bc:	eca080e7          	jalr	-310(ra) # 1582 <free>
  return freep;
    16c0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    16c4:	d971                	beqz	a0,1698 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    16c8:	4798                	lw	a4,8(a5)
    16ca:	fa9775e3          	bgeu	a4,s1,1674 <malloc+0x70>
    if(p == freep)
    16ce:	00093703          	ld	a4,0(s2)
    16d2:	853e                	mv	a0,a5
    16d4:	fef719e3          	bne	a4,a5,16c6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    16d8:	8552                	mv	a0,s4
    16da:	00000097          	auipc	ra,0x0
    16de:	b40080e7          	jalr	-1216(ra) # 121a <sbrk>
  if(p == (char*)-1)
    16e2:	fd5518e3          	bne	a0,s5,16b2 <malloc+0xae>
        return 0;
    16e6:	4501                	li	a0,0
    16e8:	bf45                	j	1698 <malloc+0x94>

00000000000016ea <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
    16ea:	c1d9                	beqz	a1,1770 <head_run+0x86>
void head_run(int fd, int numOfLines){
    16ec:	dd010113          	addi	sp,sp,-560
    16f0:	22113423          	sd	ra,552(sp)
    16f4:	22813023          	sd	s0,544(sp)
    16f8:	20913c23          	sd	s1,536(sp)
    16fc:	21213823          	sd	s2,528(sp)
    1700:	21313423          	sd	s3,520(sp)
    1704:	21413023          	sd	s4,512(sp)
    1708:	1c00                	addi	s0,sp,560
    170a:	892a                	mv	s2,a0
    170c:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
    1710:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
    1712:	00000a17          	auipc	s4,0x0
    1716:	73ea0a13          	addi	s4,s4,1854 # 1e50 <digits+0x40>
		readStatus = read_line(fd, line);
    171a:	dd840593          	addi	a1,s0,-552
    171e:	854a                	mv	a0,s2
    1720:	00000097          	auipc	ra,0x0
    1724:	394080e7          	jalr	916(ra) # 1ab4 <read_line>
		if (readStatus == READ_ERROR){
    1728:	01350d63          	beq	a0,s3,1742 <head_run+0x58>
		if (readStatus == READ_EOF)
    172c:	c11d                	beqz	a0,1752 <head_run+0x68>
		printf("%s",line);
    172e:	dd840593          	addi	a1,s0,-552
    1732:	8552                	mv	a0,s4
    1734:	00000097          	auipc	ra,0x0
    1738:	e18080e7          	jalr	-488(ra) # 154c <printf>
	while(numOfLines--){
    173c:	34fd                	addiw	s1,s1,-1
    173e:	fcf1                	bnez	s1,171a <head_run+0x30>
    1740:	a809                	j	1752 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
    1742:	00000517          	auipc	a0,0x0
    1746:	6e650513          	addi	a0,a0,1766 # 1e28 <digits+0x18>
    174a:	00000097          	auipc	ra,0x0
    174e:	e02080e7          	jalr	-510(ra) # 154c <printf>

	}
}
    1752:	22813083          	ld	ra,552(sp)
    1756:	22013403          	ld	s0,544(sp)
    175a:	21813483          	ld	s1,536(sp)
    175e:	21013903          	ld	s2,528(sp)
    1762:	20813983          	ld	s3,520(sp)
    1766:	20013a03          	ld	s4,512(sp)
    176a:	23010113          	addi	sp,sp,560
    176e:	8082                	ret
    1770:	8082                	ret

0000000000001772 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
    1772:	ba010113          	addi	sp,sp,-1120
    1776:	44113c23          	sd	ra,1112(sp)
    177a:	44813823          	sd	s0,1104(sp)
    177e:	44913423          	sd	s1,1096(sp)
    1782:	45213023          	sd	s2,1088(sp)
    1786:	43313c23          	sd	s3,1080(sp)
    178a:	43413823          	sd	s4,1072(sp)
    178e:	43513423          	sd	s5,1064(sp)
    1792:	43613023          	sd	s6,1056(sp)
    1796:	41713c23          	sd	s7,1048(sp)
    179a:	41813823          	sd	s8,1040(sp)
    179e:	41913423          	sd	s9,1032(sp)
    17a2:	41a13023          	sd	s10,1024(sp)
    17a6:	3fb13c23          	sd	s11,1016(sp)
    17aa:	46010413          	addi	s0,sp,1120
    17ae:	89aa                	mv	s3,a0
    17b0:	8aae                	mv	s5,a1
    17b2:	8c32                	mv	s8,a2
    17b4:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
    17b6:	d9840593          	addi	a1,s0,-616
    17ba:	00000097          	auipc	ra,0x0
    17be:	2fa080e7          	jalr	762(ra) # 1ab4 <read_line>


  if (readStatus == READ_ERROR)
    17c2:	57fd                	li	a5,-1
    17c4:	04f50163          	beq	a0,a5,1806 <uniq_run+0x94>
    17c8:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
    17ca:	ed21                	bnez	a0,1822 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
    17cc:	45813083          	ld	ra,1112(sp)
    17d0:	45013403          	ld	s0,1104(sp)
    17d4:	44813483          	ld	s1,1096(sp)
    17d8:	44013903          	ld	s2,1088(sp)
    17dc:	43813983          	ld	s3,1080(sp)
    17e0:	43013a03          	ld	s4,1072(sp)
    17e4:	42813a83          	ld	s5,1064(sp)
    17e8:	42013b03          	ld	s6,1056(sp)
    17ec:	41813b83          	ld	s7,1048(sp)
    17f0:	41013c03          	ld	s8,1040(sp)
    17f4:	40813c83          	ld	s9,1032(sp)
    17f8:	40013d03          	ld	s10,1024(sp)
    17fc:	3f813d83          	ld	s11,1016(sp)
    1800:	46010113          	addi	sp,sp,1120
    1804:	8082                	ret
    printf("[ERR] Error reading from the file ");
    1806:	00000517          	auipc	a0,0x0
    180a:	65250513          	addi	a0,a0,1618 # 1e58 <digits+0x48>
    180e:	00000097          	auipc	ra,0x0
    1812:	d3e080e7          	jalr	-706(ra) # 154c <printf>
    1816:	bf5d                	j	17cc <uniq_run+0x5a>
    1818:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    181a:	8926                	mv	s2,s1
    181c:	84be                	mv	s1,a5
        lineCount = 1;
    181e:	8b6a                	mv	s6,s10
    1820:	a8ed                	j	191a <uniq_run+0x1a8>
    int lineCount=1;
    1822:	4b05                	li	s6,1
  char * line2 = buffer2;
    1824:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
    1828:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
    182c:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
    182e:	4d05                	li	s10,1
              printf("%s",line1);
    1830:	00000d97          	auipc	s11,0x0
    1834:	620d8d93          	addi	s11,s11,1568 # 1e50 <digits+0x40>
    1838:	a0cd                	j	191a <uniq_run+0x1a8>
            if (repeatedLines){
    183a:	020a0b63          	beqz	s4,1870 <uniq_run+0xfe>
                if (isRepeated){
    183e:	f80b87e3          	beqz	s7,17cc <uniq_run+0x5a>
                    if (showCount)
    1842:	000c0d63          	beqz	s8,185c <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
    1846:	864a                	mv	a2,s2
    1848:	85da                	mv	a1,s6
    184a:	00000517          	auipc	a0,0x0
    184e:	63650513          	addi	a0,a0,1590 # 1e80 <digits+0x70>
    1852:	00000097          	auipc	ra,0x0
    1856:	cfa080e7          	jalr	-774(ra) # 154c <printf>
    185a:	bf8d                	j	17cc <uniq_run+0x5a>
                      printf("%s",line1);
    185c:	85ca                	mv	a1,s2
    185e:	00000517          	auipc	a0,0x0
    1862:	5f250513          	addi	a0,a0,1522 # 1e50 <digits+0x40>
    1866:	00000097          	auipc	ra,0x0
    186a:	ce6080e7          	jalr	-794(ra) # 154c <printf>
    186e:	bfb9                	j	17cc <uniq_run+0x5a>
                if (showCount)
    1870:	000c0d63          	beqz	s8,188a <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
    1874:	864a                	mv	a2,s2
    1876:	85da                	mv	a1,s6
    1878:	00000517          	auipc	a0,0x0
    187c:	60850513          	addi	a0,a0,1544 # 1e80 <digits+0x70>
    1880:	00000097          	auipc	ra,0x0
    1884:	ccc080e7          	jalr	-820(ra) # 154c <printf>
    1888:	b791                	j	17cc <uniq_run+0x5a>
                  printf("%s",line1);
    188a:	85ca                	mv	a1,s2
    188c:	00000517          	auipc	a0,0x0
    1890:	5c450513          	addi	a0,a0,1476 # 1e50 <digits+0x40>
    1894:	00000097          	auipc	ra,0x0
    1898:	cb8080e7          	jalr	-840(ra) # 154c <printf>
    189c:	bf05                	j	17cc <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
    189e:	00000517          	auipc	a0,0x0
    18a2:	5ea50513          	addi	a0,a0,1514 # 1e88 <digits+0x78>
    18a6:	00000097          	auipc	ra,0x0
    18aa:	ca6080e7          	jalr	-858(ra) # 154c <printf>
          break;
    18ae:	bf39                	j	17cc <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
    18b0:	85a6                	mv	a1,s1
    18b2:	854a                	mv	a0,s2
    18b4:	00000097          	auipc	ra,0x0
    18b8:	110080e7          	jalr	272(ra) # 19c4 <compare_str_ic>
    18bc:	a041                	j	193c <uniq_run+0x1ca>
                  printf("%s",line1);
    18be:	85ca                	mv	a1,s2
    18c0:	856e                	mv	a0,s11
    18c2:	00000097          	auipc	ra,0x0
    18c6:	c8a080e7          	jalr	-886(ra) # 154c <printf>
        lineCount = 1;
    18ca:	8b5e                	mv	s6,s7
                  printf("%s",line1);
    18cc:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    18ce:	8926                	mv	s2,s1
                  printf("%s",line1);
    18d0:	84be                	mv	s1,a5
        isRepeated = 0 ;
    18d2:	4b81                	li	s7,0
    18d4:	a099                	j	191a <uniq_run+0x1a8>
            if (showCount)
    18d6:	020c0263          	beqz	s8,18fa <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
    18da:	864a                	mv	a2,s2
    18dc:	85da                	mv	a1,s6
    18de:	00000517          	auipc	a0,0x0
    18e2:	5a250513          	addi	a0,a0,1442 # 1e80 <digits+0x70>
    18e6:	00000097          	auipc	ra,0x0
    18ea:	c66080e7          	jalr	-922(ra) # 154c <printf>
    18ee:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    18f0:	8926                	mv	s2,s1
    18f2:	84be                	mv	s1,a5
        isRepeated = 0 ;
    18f4:	4b81                	li	s7,0
        lineCount = 1;
    18f6:	8b6a                	mv	s6,s10
    18f8:	a00d                	j	191a <uniq_run+0x1a8>
              printf("%s",line1);
    18fa:	85ca                	mv	a1,s2
    18fc:	856e                	mv	a0,s11
    18fe:	00000097          	auipc	ra,0x0
    1902:	c4e080e7          	jalr	-946(ra) # 154c <printf>
    1906:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    1908:	8926                	mv	s2,s1
              printf("%s",line1);
    190a:	84be                	mv	s1,a5
        isRepeated = 0 ;
    190c:	4b81                	li	s7,0
        lineCount = 1;
    190e:	8b6a                	mv	s6,s10
    1910:	a029                	j	191a <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
    1912:	000a0363          	beqz	s4,1918 <uniq_run+0x1a6>
    1916:	8bea                	mv	s7,s10
          lineCount++;
    1918:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
    191a:	85a6                	mv	a1,s1
    191c:	854e                	mv	a0,s3
    191e:	00000097          	auipc	ra,0x0
    1922:	196080e7          	jalr	406(ra) # 1ab4 <read_line>
        if (readStatus == READ_EOF){
    1926:	d911                	beqz	a0,183a <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
    1928:	f7950be3          	beq	a0,s9,189e <uniq_run+0x12c>
        if (!ignoreCase)
    192c:	f80a92e3          	bnez	s5,18b0 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
    1930:	85a6                	mv	a1,s1
    1932:	854a                	mv	a0,s2
    1934:	00000097          	auipc	ra,0x0
    1938:	062080e7          	jalr	98(ra) # 1996 <compare_str>
        if (compareStatus != 0){ 
    193c:	d979                	beqz	a0,1912 <uniq_run+0x1a0>
          if (repeatedLines){
    193e:	f80a0ce3          	beqz	s4,18d6 <uniq_run+0x164>
            if (isRepeated){
    1942:	ec0b8be3          	beqz	s7,1818 <uniq_run+0xa6>
                if (showCount)
    1946:	f60c0ce3          	beqz	s8,18be <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
    194a:	864a                	mv	a2,s2
    194c:	85da                	mv	a1,s6
    194e:	00000517          	auipc	a0,0x0
    1952:	53250513          	addi	a0,a0,1330 # 1e80 <digits+0x70>
    1956:	00000097          	auipc	ra,0x0
    195a:	bf6080e7          	jalr	-1034(ra) # 154c <printf>
        lineCount = 1;
    195e:	8b5e                	mv	s6,s7
    1960:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    1962:	8926                	mv	s2,s1
    1964:	84be                	mv	s1,a5
        isRepeated = 0 ;
    1966:	4b81                	li	s7,0
    1968:	bf4d                	j	191a <uniq_run+0x1a8>

000000000000196a <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
    196a:	1141                	addi	sp,sp,-16
    196c:	e422                	sd	s0,8(sp)
    196e:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
    1970:	00054783          	lbu	a5,0(a0)
    1974:	cf99                	beqz	a5,1992 <get_strlen+0x28>
    1976:	00150713          	addi	a4,a0,1
    197a:	87ba                	mv	a5,a4
    197c:	4685                	li	a3,1
    197e:	9e99                	subw	a3,a3,a4
    1980:	00f6853b          	addw	a0,a3,a5
    1984:	0785                	addi	a5,a5,1
    1986:	fff7c703          	lbu	a4,-1(a5)
    198a:	fb7d                	bnez	a4,1980 <get_strlen+0x16>
	return len;
}
    198c:	6422                	ld	s0,8(sp)
    198e:	0141                	addi	sp,sp,16
    1990:	8082                	ret
	int len = 0;
    1992:	4501                	li	a0,0
    1994:	bfe5                	j	198c <get_strlen+0x22>

0000000000001996 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
    1996:	1141                	addi	sp,sp,-16
    1998:	e422                	sd	s0,8(sp)
    199a:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
    199c:	00054783          	lbu	a5,0(a0)
    19a0:	cb91                	beqz	a5,19b4 <compare_str+0x1e>
    19a2:	0005c703          	lbu	a4,0(a1)
    19a6:	c719                	beqz	a4,19b4 <compare_str+0x1e>
		if (*s1++ != *s2++)
    19a8:	0505                	addi	a0,a0,1
    19aa:	0585                	addi	a1,a1,1
    19ac:	fee788e3          	beq	a5,a4,199c <compare_str+0x6>
			return 1;
    19b0:	4505                	li	a0,1
    19b2:	a031                	j	19be <compare_str+0x28>
	}
	if (*s1 == *s2)
    19b4:	0005c503          	lbu	a0,0(a1)
    19b8:	8d1d                	sub	a0,a0,a5
			return 1;
    19ba:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    19be:	6422                	ld	s0,8(sp)
    19c0:	0141                	addi	sp,sp,16
    19c2:	8082                	ret

00000000000019c4 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
    19c4:	1141                	addi	sp,sp,-16
    19c6:	e422                	sd	s0,8(sp)
    19c8:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
    19ca:	4665                	li	a2,25
	while(*s1 && *s2){
    19cc:	a019                	j	19d2 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
    19ce:	04e79763          	bne	a5,a4,1a1c <compare_str_ic+0x58>
	while(*s1 && *s2){
    19d2:	00054783          	lbu	a5,0(a0)
    19d6:	cb9d                	beqz	a5,1a0c <compare_str_ic+0x48>
    19d8:	0005c703          	lbu	a4,0(a1)
    19dc:	cb05                	beqz	a4,1a0c <compare_str_ic+0x48>
		char b1 = *s1++;
    19de:	0505                	addi	a0,a0,1
		char b2 = *s2++;
    19e0:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
    19e2:	fbf7869b          	addiw	a3,a5,-65
    19e6:	0ff6f693          	zext.b	a3,a3
    19ea:	00d66663          	bltu	a2,a3,19f6 <compare_str_ic+0x32>
			b1 += 32;
    19ee:	0207879b          	addiw	a5,a5,32
    19f2:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
    19f6:	fbf7069b          	addiw	a3,a4,-65
    19fa:	0ff6f693          	zext.b	a3,a3
    19fe:	fcd668e3          	bltu	a2,a3,19ce <compare_str_ic+0xa>
			b2 += 32;
    1a02:	0207071b          	addiw	a4,a4,32
    1a06:	0ff77713          	zext.b	a4,a4
    1a0a:	b7d1                	j	19ce <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
    1a0c:	0005c503          	lbu	a0,0(a1)
    1a10:	8d1d                	sub	a0,a0,a5
			return 1;
    1a12:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    1a16:	6422                	ld	s0,8(sp)
    1a18:	0141                	addi	sp,sp,16
    1a1a:	8082                	ret
			return 1;
    1a1c:	4505                	li	a0,1
    1a1e:	bfe5                	j	1a16 <compare_str_ic+0x52>

0000000000001a20 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
    1a20:	7179                	addi	sp,sp,-48
    1a22:	f406                	sd	ra,40(sp)
    1a24:	f022                	sd	s0,32(sp)
    1a26:	ec26                	sd	s1,24(sp)
    1a28:	e84a                	sd	s2,16(sp)
    1a2a:	e44e                	sd	s3,8(sp)
    1a2c:	1800                	addi	s0,sp,48
    1a2e:	89aa                	mv	s3,a0
    1a30:	892e                	mv	s2,a1
    int M = get_strlen(s1);
    1a32:	00000097          	auipc	ra,0x0
    1a36:	f38080e7          	jalr	-200(ra) # 196a <get_strlen>
    1a3a:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
    1a3c:	854a                	mv	a0,s2
    1a3e:	00000097          	auipc	ra,0x0
    1a42:	f2c080e7          	jalr	-212(ra) # 196a <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
    1a46:	409505bb          	subw	a1,a0,s1
    1a4a:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
    1a4c:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
    1a4e:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
    1a50:	0005da63          	bgez	a1,1a64 <check_substr+0x44>
    1a54:	a81d                	j	1a8a <check_substr+0x6a>
        if (j == M)
    1a56:	02f48a63          	beq	s1,a5,1a8a <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
    1a5a:	0885                	addi	a7,a7,1
    1a5c:	0008879b          	sext.w	a5,a7
    1a60:	02f5cc63          	blt	a1,a5,1a98 <check_substr+0x78>
    1a64:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
    1a68:	011906b3          	add	a3,s2,a7
    1a6c:	874e                	mv	a4,s3
    1a6e:	879a                	mv	a5,t1
    1a70:	fe9053e3          	blez	s1,1a56 <check_substr+0x36>
            if (s2[i + j] != s1[j])
    1a74:	0006c803          	lbu	a6,0(a3) # 1000 <gets+0x22>
    1a78:	00074603          	lbu	a2,0(a4)
    1a7c:	fcc81de3          	bne	a6,a2,1a56 <check_substr+0x36>
        for (j = 0; j < M; j++)
    1a80:	2785                	addiw	a5,a5,1
    1a82:	0685                	addi	a3,a3,1
    1a84:	0705                	addi	a4,a4,1
    1a86:	fef497e3          	bne	s1,a5,1a74 <check_substr+0x54>
}
    1a8a:	70a2                	ld	ra,40(sp)
    1a8c:	7402                	ld	s0,32(sp)
    1a8e:	64e2                	ld	s1,24(sp)
    1a90:	6942                	ld	s2,16(sp)
    1a92:	69a2                	ld	s3,8(sp)
    1a94:	6145                	addi	sp,sp,48
    1a96:	8082                	ret
    return -1;
    1a98:	557d                	li	a0,-1
    1a9a:	bfc5                	j	1a8a <check_substr+0x6a>

0000000000001a9c <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
    1a9c:	1141                	addi	sp,sp,-16
    1a9e:	e406                	sd	ra,8(sp)
    1aa0:	e022                	sd	s0,0(sp)
    1aa2:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
    1aa4:	fffff097          	auipc	ra,0xfffff
    1aa8:	72e080e7          	jalr	1838(ra) # 11d2 <open>
	return fd;
}
    1aac:	60a2                	ld	ra,8(sp)
    1aae:	6402                	ld	s0,0(sp)
    1ab0:	0141                	addi	sp,sp,16
    1ab2:	8082                	ret

0000000000001ab4 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
    1ab4:	7139                	addi	sp,sp,-64
    1ab6:	fc06                	sd	ra,56(sp)
    1ab8:	f822                	sd	s0,48(sp)
    1aba:	f426                	sd	s1,40(sp)
    1abc:	f04a                	sd	s2,32(sp)
    1abe:	ec4e                	sd	s3,24(sp)
    1ac0:	e852                	sd	s4,16(sp)
    1ac2:	0080                	addi	s0,sp,64
    1ac4:	89aa                	mv	s3,a0
    1ac6:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
    1ac8:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
    1aca:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
    1acc:	4605                	li	a2,1
    1ace:	fcf40593          	addi	a1,s0,-49
    1ad2:	854e                	mv	a0,s3
    1ad4:	fffff097          	auipc	ra,0xfffff
    1ad8:	6d6080e7          	jalr	1750(ra) # 11aa <read>
		if (readStatus == 0){
    1adc:	c505                	beqz	a0,1b04 <read_line+0x50>
		*buffer++ = readByte;
    1ade:	0485                	addi	s1,s1,1
    1ae0:	fcf44783          	lbu	a5,-49(s0)
    1ae4:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
    1ae8:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
    1aea:	ff4791e3          	bne	a5,s4,1acc <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
    1aee:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
    1af2:	854a                	mv	a0,s2
    1af4:	70e2                	ld	ra,56(sp)
    1af6:	7442                	ld	s0,48(sp)
    1af8:	74a2                	ld	s1,40(sp)
    1afa:	7902                	ld	s2,32(sp)
    1afc:	69e2                	ld	s3,24(sp)
    1afe:	6a42                	ld	s4,16(sp)
    1b00:	6121                	addi	sp,sp,64
    1b02:	8082                	ret
			if (byteCount!=0){
    1b04:	fe0907e3          	beqz	s2,1af2 <read_line+0x3e>
				*buffer = '\n';
    1b08:	47a9                	li	a5,10
    1b0a:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
    1b0e:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
    1b12:	2905                	addiw	s2,s2,1
    1b14:	bff9                	j	1af2 <read_line+0x3e>

0000000000001b16 <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
    1b16:	1141                	addi	sp,sp,-16
    1b18:	e406                	sd	ra,8(sp)
    1b1a:	e022                	sd	s0,0(sp)
    1b1c:	0800                	addi	s0,sp,16
	close(fd);
    1b1e:	fffff097          	auipc	ra,0xfffff
    1b22:	69c080e7          	jalr	1692(ra) # 11ba <close>
}
    1b26:	60a2                	ld	ra,8(sp)
    1b28:	6402                	ld	s0,0(sp)
    1b2a:	0141                	addi	sp,sp,16
    1b2c:	8082                	ret

0000000000001b2e <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
    1b2e:	7139                	addi	sp,sp,-64
    1b30:	fc06                	sd	ra,56(sp)
    1b32:	f822                	sd	s0,48(sp)
    1b34:	f426                	sd	s1,40(sp)
    1b36:	f04a                	sd	s2,32(sp)
    1b38:	0080                	addi	s0,sp,64
    1b3a:	84aa                	mv	s1,a0
    1b3c:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
    1b3e:	fffff097          	auipc	ra,0xfffff
    1b42:	64c080e7          	jalr	1612(ra) # 118a <fork>
    1b46:	ed19                	bnez	a0,1b64 <get_time_perf+0x36>
		exec(argv[0],argv);
    1b48:	85ca                	mv	a1,s2
    1b4a:	00093503          	ld	a0,0(s2)
    1b4e:	fffff097          	auipc	ra,0xfffff
    1b52:	67c080e7          	jalr	1660(ra) # 11ca <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
    1b56:	8526                	mv	a0,s1
    1b58:	70e2                	ld	ra,56(sp)
    1b5a:	7442                	ld	s0,48(sp)
    1b5c:	74a2                	ld	s1,40(sp)
    1b5e:	7902                	ld	s2,32(sp)
    1b60:	6121                	addi	sp,sp,64
    1b62:	8082                	ret
		times(pid , &time);
    1b64:	fc040593          	addi	a1,s0,-64
    1b68:	fffff097          	auipc	ra,0xfffff
    1b6c:	6e2080e7          	jalr	1762(ra) # 124a <times>
		return time;
    1b70:	fc043783          	ld	a5,-64(s0)
    1b74:	e09c                	sd	a5,0(s1)
    1b76:	fc843783          	ld	a5,-56(s0)
    1b7a:	e49c                	sd	a5,8(s1)
    1b7c:	fd043783          	ld	a5,-48(s0)
    1b80:	e89c                	sd	a5,16(s1)
    1b82:	fd843783          	ld	a5,-40(s0)
    1b86:	ec9c                	sd	a5,24(s1)
    1b88:	b7f9                	j	1b56 <get_time_perf+0x28>
