
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
      1e:	b16a0a13          	addi	s4,s4,-1258 # 1b30 <get_time_perf+0x5e>
    strcpy(cmd+offset,*argv);
      22:	00998533          	add	a0,s3,s1
      26:	00001097          	auipc	ra,0x1
      2a:	ebc080e7          	jalr	-324(ra) # ee2 <strcpy>
    offset+= strlen(*argv);
      2e:	00093503          	ld	a0,0(s2)
      32:	00001097          	auipc	ra,0x1
      36:	ef8080e7          	jalr	-264(ra) # f2a <strlen>
      3a:	9ca9                	addw	s1,s1,a0
      3c:	0004851b          	sext.w	a0,s1
    strcpy(cmd+offset," ");
      40:	85d2                	mv	a1,s4
      42:	954e                	add	a0,a0,s3
      44:	00001097          	auipc	ra,0x1
      48:	e9e080e7          	jalr	-354(ra) # ee2 <strcpy>
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
      86:	ab658593          	addi	a1,a1,-1354 # 1b38 <get_time_perf+0x66>
      8a:	4509                	li	a0,2
      8c:	00001097          	auipc	ra,0x1
      90:	0e2080e7          	jalr	226(ra) # 116e <write>
  memset(buf, 0, nbuf);
      94:	864a                	mv	a2,s2
      96:	4581                	li	a1,0
      98:	8526                	mv	a0,s1
      9a:	00001097          	auipc	ra,0x1
      9e:	eba080e7          	jalr	-326(ra) # f54 <memset>
  gets(buf, nbuf);
      a2:	85ca                	mv	a1,s2
      a4:	8526                	mv	a0,s1
      a6:	00001097          	auipc	ra,0x1
      aa:	ef4080e7          	jalr	-268(ra) # f9a <gets>
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
      d4:	a7058593          	addi	a1,a1,-1424 # 1b40 <get_time_perf+0x6e>
      d8:	4509                	li	a0,2
      da:	00001097          	auipc	ra,0x1
      de:	3e8080e7          	jalr	1000(ra) # 14c2 <fprintf>
  exit(1);
      e2:	4505                	li	a0,1
      e4:	00001097          	auipc	ra,0x1
      e8:	06a080e7          	jalr	106(ra) # 114e <exit>

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
      f8:	052080e7          	jalr	82(ra) # 1146 <fork>
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
     10e:	a3e50513          	addi	a0,a0,-1474 # 1b48 <get_time_perf+0x76>
     112:	00000097          	auipc	ra,0x0
     116:	fb4080e7          	jalr	-76(ra) # c6 <panic>

000000000000011a <runcmd>:
{
     11a:	7171                	addi	sp,sp,-176
     11c:	f506                	sd	ra,168(sp)
     11e:	f122                	sd	s0,160(sp)
     120:	ed26                	sd	s1,152(sp)
     122:	e94a                	sd	s2,144(sp)
     124:	1900                	addi	s0,sp,176
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
     13c:	be470713          	addi	a4,a4,-1052 # 1d1c <get_time_perf+0x24a>
     140:	97ba                	add	a5,a5,a4
     142:	439c                	lw	a5,0(a5)
     144:	97ba                	add	a5,a5,a4
     146:	8782                	jr	a5
    exit(1);
     148:	4505                	li	a0,1
     14a:	00001097          	auipc	ra,0x1
     14e:	004080e7          	jalr	4(ra) # 114e <exit>
    panic("runcmd");
     152:	00002517          	auipc	a0,0x2
     156:	9fe50513          	addi	a0,a0,-1538 # 1b50 <get_time_perf+0x7e>
     15a:	00000097          	auipc	ra,0x0
     15e:	f6c080e7          	jalr	-148(ra) # c6 <panic>
    if(ecmd->argv[0] == 0)
     162:	6508                	ld	a0,8(a0)
     164:	c55d                	beqz	a0,212 <runcmd+0xf8>
    if (strcmp(argv[0],"time")==0){
     166:	00002597          	auipc	a1,0x2
     16a:	9f258593          	addi	a1,a1,-1550 # 1b58 <get_time_perf+0x86>
     16e:	00001097          	auipc	ra,0x1
     172:	d90080e7          	jalr	-624(ra) # efe <strcmp>
     176:	e15d                	bnez	a0,21c <runcmd+0x102>
      argv++;
     178:	04c1                	addi	s1,s1,16
      e_time_t time = get_time_perf(argv);
     17a:	85a6                	mv	a1,s1
     17c:	f5840513          	addi	a0,s0,-168
     180:	00002097          	auipc	ra,0x2
     184:	952080e7          	jalr	-1710(ra) # 1ad2 <get_time_perf>
      int fd = open(".time", O_CREATE | O_WRONLY | O_APPEND);
     188:	65a1                	lui	a1,0x8
     18a:	20158593          	addi	a1,a1,513 # 8201 <base+0x6179>
     18e:	00002517          	auipc	a0,0x2
     192:	9d250513          	addi	a0,a0,-1582 # 1b60 <get_time_perf+0x8e>
     196:	00001097          	auipc	ra,0x1
     19a:	ff8080e7          	jalr	-8(ra) # 118e <open>
     19e:	892a                	mv	s2,a0
      char issuedCmd[100]={0};
     1a0:	f6043823          	sd	zero,-144(s0)
     1a4:	05c00613          	li	a2,92
     1a8:	4581                	li	a1,0
     1aa:	f7840513          	addi	a0,s0,-136
     1ae:	00001097          	auipc	ra,0x1
     1b2:	da6080e7          	jalr	-602(ra) # f54 <memset>
      create_cmd(argv,issuedCmd);
     1b6:	f7040593          	addi	a1,s0,-144
     1ba:	8526                	mv	a0,s1
     1bc:	00000097          	auipc	ra,0x0
     1c0:	e44080e7          	jalr	-444(ra) # 0 <create_cmd>
      int cmdLen = strlen(issuedCmd);
     1c4:	f7040513          	addi	a0,s0,-144
     1c8:	00001097          	auipc	ra,0x1
     1cc:	d62080e7          	jalr	-670(ra) # f2a <strlen>
     1d0:	f4a42a23          	sw	a0,-172(s0)
      write(fd, &cmdLen, sizeof(int));
     1d4:	4611                	li	a2,4
     1d6:	f5440593          	addi	a1,s0,-172
     1da:	854a                	mv	a0,s2
     1dc:	00001097          	auipc	ra,0x1
     1e0:	f92080e7          	jalr	-110(ra) # 116e <write>
      write(fd, issuedCmd,cmdLen);
     1e4:	f5442603          	lw	a2,-172(s0)
     1e8:	f7040593          	addi	a1,s0,-144
     1ec:	854a                	mv	a0,s2
     1ee:	00001097          	auipc	ra,0x1
     1f2:	f80080e7          	jalr	-128(ra) # 116e <write>
      write(fd, &time, sizeof(e_time_t));
     1f6:	4661                	li	a2,24
     1f8:	f5840593          	addi	a1,s0,-168
     1fc:	854a                	mv	a0,s2
     1fe:	00001097          	auipc	ra,0x1
     202:	f70080e7          	jalr	-144(ra) # 116e <write>
      close(fd);
     206:	854a                	mv	a0,s2
     208:	00001097          	auipc	ra,0x1
     20c:	f6e080e7          	jalr	-146(ra) # 1176 <close>
     210:	aa95                	j	384 <runcmd+0x26a>
      exit(1);
     212:	4505                	li	a0,1
     214:	00001097          	auipc	ra,0x1
     218:	f3a080e7          	jalr	-198(ra) # 114e <exit>
      exec(argv[0], argv);
     21c:	00848593          	addi	a1,s1,8
     220:	6488                	ld	a0,8(s1)
     222:	00001097          	auipc	ra,0x1
     226:	f64080e7          	jalr	-156(ra) # 1186 <exec>
      fprintf(2, "exec %s failed\n", argv[0]);
     22a:	6490                	ld	a2,8(s1)
     22c:	00002597          	auipc	a1,0x2
     230:	93c58593          	addi	a1,a1,-1732 # 1b68 <get_time_perf+0x96>
     234:	4509                	li	a0,2
     236:	00001097          	auipc	ra,0x1
     23a:	28c080e7          	jalr	652(ra) # 14c2 <fprintf>
     23e:	a299                	j	384 <runcmd+0x26a>
    close(rcmd->fd);
     240:	5148                	lw	a0,36(a0)
     242:	00001097          	auipc	ra,0x1
     246:	f34080e7          	jalr	-204(ra) # 1176 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     24a:	508c                	lw	a1,32(s1)
     24c:	6888                	ld	a0,16(s1)
     24e:	00001097          	auipc	ra,0x1
     252:	f40080e7          	jalr	-192(ra) # 118e <open>
     256:	00054763          	bltz	a0,264 <runcmd+0x14a>
    runcmd(rcmd->cmd);
     25a:	6488                	ld	a0,8(s1)
     25c:	00000097          	auipc	ra,0x0
     260:	ebe080e7          	jalr	-322(ra) # 11a <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     264:	6890                	ld	a2,16(s1)
     266:	00002597          	auipc	a1,0x2
     26a:	91258593          	addi	a1,a1,-1774 # 1b78 <get_time_perf+0xa6>
     26e:	4509                	li	a0,2
     270:	00001097          	auipc	ra,0x1
     274:	252080e7          	jalr	594(ra) # 14c2 <fprintf>
      exit(1);
     278:	4505                	li	a0,1
     27a:	00001097          	auipc	ra,0x1
     27e:	ed4080e7          	jalr	-300(ra) # 114e <exit>
    if(fork1() == 0)
     282:	00000097          	auipc	ra,0x0
     286:	e6a080e7          	jalr	-406(ra) # ec <fork1>
     28a:	e511                	bnez	a0,296 <runcmd+0x17c>
      runcmd(lcmd->left);
     28c:	6488                	ld	a0,8(s1)
     28e:	00000097          	auipc	ra,0x0
     292:	e8c080e7          	jalr	-372(ra) # 11a <runcmd>
    wait(0);
     296:	4501                	li	a0,0
     298:	00001097          	auipc	ra,0x1
     29c:	ebe080e7          	jalr	-322(ra) # 1156 <wait>
    runcmd(lcmd->right);
     2a0:	6888                	ld	a0,16(s1)
     2a2:	00000097          	auipc	ra,0x0
     2a6:	e78080e7          	jalr	-392(ra) # 11a <runcmd>
    if(pipe(p) < 0)
     2aa:	fd840513          	addi	a0,s0,-40
     2ae:	00001097          	auipc	ra,0x1
     2b2:	eb0080e7          	jalr	-336(ra) # 115e <pipe>
     2b6:	04054363          	bltz	a0,2fc <runcmd+0x1e2>
    if(fork1() == 0){
     2ba:	00000097          	auipc	ra,0x0
     2be:	e32080e7          	jalr	-462(ra) # ec <fork1>
     2c2:	e529                	bnez	a0,30c <runcmd+0x1f2>
      close(1);
     2c4:	4505                	li	a0,1
     2c6:	00001097          	auipc	ra,0x1
     2ca:	eb0080e7          	jalr	-336(ra) # 1176 <close>
      dup(p[1]);
     2ce:	fdc42503          	lw	a0,-36(s0)
     2d2:	00001097          	auipc	ra,0x1
     2d6:	ef4080e7          	jalr	-268(ra) # 11c6 <dup>
      close(p[0]);
     2da:	fd842503          	lw	a0,-40(s0)
     2de:	00001097          	auipc	ra,0x1
     2e2:	e98080e7          	jalr	-360(ra) # 1176 <close>
      close(p[1]);
     2e6:	fdc42503          	lw	a0,-36(s0)
     2ea:	00001097          	auipc	ra,0x1
     2ee:	e8c080e7          	jalr	-372(ra) # 1176 <close>
      runcmd(pcmd->left);
     2f2:	6488                	ld	a0,8(s1)
     2f4:	00000097          	auipc	ra,0x0
     2f8:	e26080e7          	jalr	-474(ra) # 11a <runcmd>
      panic("pipe");
     2fc:	00002517          	auipc	a0,0x2
     300:	88c50513          	addi	a0,a0,-1908 # 1b88 <get_time_perf+0xb6>
     304:	00000097          	auipc	ra,0x0
     308:	dc2080e7          	jalr	-574(ra) # c6 <panic>
    if(fork1() == 0){
     30c:	00000097          	auipc	ra,0x0
     310:	de0080e7          	jalr	-544(ra) # ec <fork1>
     314:	ed05                	bnez	a0,34c <runcmd+0x232>
      close(0);
     316:	00001097          	auipc	ra,0x1
     31a:	e60080e7          	jalr	-416(ra) # 1176 <close>
      dup(p[0]);
     31e:	fd842503          	lw	a0,-40(s0)
     322:	00001097          	auipc	ra,0x1
     326:	ea4080e7          	jalr	-348(ra) # 11c6 <dup>
      close(p[0]);
     32a:	fd842503          	lw	a0,-40(s0)
     32e:	00001097          	auipc	ra,0x1
     332:	e48080e7          	jalr	-440(ra) # 1176 <close>
      close(p[1]);
     336:	fdc42503          	lw	a0,-36(s0)
     33a:	00001097          	auipc	ra,0x1
     33e:	e3c080e7          	jalr	-452(ra) # 1176 <close>
      runcmd(pcmd->right);
     342:	6888                	ld	a0,16(s1)
     344:	00000097          	auipc	ra,0x0
     348:	dd6080e7          	jalr	-554(ra) # 11a <runcmd>
    close(p[0]);
     34c:	fd842503          	lw	a0,-40(s0)
     350:	00001097          	auipc	ra,0x1
     354:	e26080e7          	jalr	-474(ra) # 1176 <close>
    close(p[1]);
     358:	fdc42503          	lw	a0,-36(s0)
     35c:	00001097          	auipc	ra,0x1
     360:	e1a080e7          	jalr	-486(ra) # 1176 <close>
    wait(0);
     364:	4501                	li	a0,0
     366:	00001097          	auipc	ra,0x1
     36a:	df0080e7          	jalr	-528(ra) # 1156 <wait>
    wait(0);
     36e:	4501                	li	a0,0
     370:	00001097          	auipc	ra,0x1
     374:	de6080e7          	jalr	-538(ra) # 1156 <wait>
    break;
     378:	a031                	j	384 <runcmd+0x26a>
    if(fork1() == 0)
     37a:	00000097          	auipc	ra,0x0
     37e:	d72080e7          	jalr	-654(ra) # ec <fork1>
     382:	c511                	beqz	a0,38e <runcmd+0x274>
  exit(0);
     384:	4501                	li	a0,0
     386:	00001097          	auipc	ra,0x1
     38a:	dc8080e7          	jalr	-568(ra) # 114e <exit>
      runcmd(bcmd->cmd);
     38e:	6488                	ld	a0,8(s1)
     390:	00000097          	auipc	ra,0x0
     394:	d8a080e7          	jalr	-630(ra) # 11a <runcmd>

0000000000000398 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     398:	1101                	addi	sp,sp,-32
     39a:	ec06                	sd	ra,24(sp)
     39c:	e822                	sd	s0,16(sp)
     39e:	e426                	sd	s1,8(sp)
     3a0:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3a2:	0a800513          	li	a0,168
     3a6:	00001097          	auipc	ra,0x1
     3aa:	202080e7          	jalr	514(ra) # 15a8 <malloc>
     3ae:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3b0:	0a800613          	li	a2,168
     3b4:	4581                	li	a1,0
     3b6:	00001097          	auipc	ra,0x1
     3ba:	b9e080e7          	jalr	-1122(ra) # f54 <memset>
  cmd->type = EXEC;
     3be:	4785                	li	a5,1
     3c0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     3c2:	8526                	mv	a0,s1
     3c4:	60e2                	ld	ra,24(sp)
     3c6:	6442                	ld	s0,16(sp)
     3c8:	64a2                	ld	s1,8(sp)
     3ca:	6105                	addi	sp,sp,32
     3cc:	8082                	ret

00000000000003ce <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3ce:	7139                	addi	sp,sp,-64
     3d0:	fc06                	sd	ra,56(sp)
     3d2:	f822                	sd	s0,48(sp)
     3d4:	f426                	sd	s1,40(sp)
     3d6:	f04a                	sd	s2,32(sp)
     3d8:	ec4e                	sd	s3,24(sp)
     3da:	e852                	sd	s4,16(sp)
     3dc:	e456                	sd	s5,8(sp)
     3de:	e05a                	sd	s6,0(sp)
     3e0:	0080                	addi	s0,sp,64
     3e2:	8b2a                	mv	s6,a0
     3e4:	8aae                	mv	s5,a1
     3e6:	8a32                	mv	s4,a2
     3e8:	89b6                	mv	s3,a3
     3ea:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3ec:	02800513          	li	a0,40
     3f0:	00001097          	auipc	ra,0x1
     3f4:	1b8080e7          	jalr	440(ra) # 15a8 <malloc>
     3f8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3fa:	02800613          	li	a2,40
     3fe:	4581                	li	a1,0
     400:	00001097          	auipc	ra,0x1
     404:	b54080e7          	jalr	-1196(ra) # f54 <memset>
  cmd->type = REDIR;
     408:	4789                	li	a5,2
     40a:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     40c:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     410:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     414:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     418:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     41c:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     420:	8526                	mv	a0,s1
     422:	70e2                	ld	ra,56(sp)
     424:	7442                	ld	s0,48(sp)
     426:	74a2                	ld	s1,40(sp)
     428:	7902                	ld	s2,32(sp)
     42a:	69e2                	ld	s3,24(sp)
     42c:	6a42                	ld	s4,16(sp)
     42e:	6aa2                	ld	s5,8(sp)
     430:	6b02                	ld	s6,0(sp)
     432:	6121                	addi	sp,sp,64
     434:	8082                	ret

0000000000000436 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     436:	7179                	addi	sp,sp,-48
     438:	f406                	sd	ra,40(sp)
     43a:	f022                	sd	s0,32(sp)
     43c:	ec26                	sd	s1,24(sp)
     43e:	e84a                	sd	s2,16(sp)
     440:	e44e                	sd	s3,8(sp)
     442:	1800                	addi	s0,sp,48
     444:	89aa                	mv	s3,a0
     446:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     448:	4561                	li	a0,24
     44a:	00001097          	auipc	ra,0x1
     44e:	15e080e7          	jalr	350(ra) # 15a8 <malloc>
     452:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     454:	4661                	li	a2,24
     456:	4581                	li	a1,0
     458:	00001097          	auipc	ra,0x1
     45c:	afc080e7          	jalr	-1284(ra) # f54 <memset>
  cmd->type = PIPE;
     460:	478d                	li	a5,3
     462:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     464:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     468:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     46c:	8526                	mv	a0,s1
     46e:	70a2                	ld	ra,40(sp)
     470:	7402                	ld	s0,32(sp)
     472:	64e2                	ld	s1,24(sp)
     474:	6942                	ld	s2,16(sp)
     476:	69a2                	ld	s3,8(sp)
     478:	6145                	addi	sp,sp,48
     47a:	8082                	ret

000000000000047c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     47c:	7179                	addi	sp,sp,-48
     47e:	f406                	sd	ra,40(sp)
     480:	f022                	sd	s0,32(sp)
     482:	ec26                	sd	s1,24(sp)
     484:	e84a                	sd	s2,16(sp)
     486:	e44e                	sd	s3,8(sp)
     488:	1800                	addi	s0,sp,48
     48a:	89aa                	mv	s3,a0
     48c:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     48e:	4561                	li	a0,24
     490:	00001097          	auipc	ra,0x1
     494:	118080e7          	jalr	280(ra) # 15a8 <malloc>
     498:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     49a:	4661                	li	a2,24
     49c:	4581                	li	a1,0
     49e:	00001097          	auipc	ra,0x1
     4a2:	ab6080e7          	jalr	-1354(ra) # f54 <memset>
  cmd->type = LIST;
     4a6:	4791                	li	a5,4
     4a8:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     4aa:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     4ae:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     4b2:	8526                	mv	a0,s1
     4b4:	70a2                	ld	ra,40(sp)
     4b6:	7402                	ld	s0,32(sp)
     4b8:	64e2                	ld	s1,24(sp)
     4ba:	6942                	ld	s2,16(sp)
     4bc:	69a2                	ld	s3,8(sp)
     4be:	6145                	addi	sp,sp,48
     4c0:	8082                	ret

00000000000004c2 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4c2:	1101                	addi	sp,sp,-32
     4c4:	ec06                	sd	ra,24(sp)
     4c6:	e822                	sd	s0,16(sp)
     4c8:	e426                	sd	s1,8(sp)
     4ca:	e04a                	sd	s2,0(sp)
     4cc:	1000                	addi	s0,sp,32
     4ce:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4d0:	4541                	li	a0,16
     4d2:	00001097          	auipc	ra,0x1
     4d6:	0d6080e7          	jalr	214(ra) # 15a8 <malloc>
     4da:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     4dc:	4641                	li	a2,16
     4de:	4581                	li	a1,0
     4e0:	00001097          	auipc	ra,0x1
     4e4:	a74080e7          	jalr	-1420(ra) # f54 <memset>
  cmd->type = BACK;
     4e8:	4795                	li	a5,5
     4ea:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     4ec:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     4f0:	8526                	mv	a0,s1
     4f2:	60e2                	ld	ra,24(sp)
     4f4:	6442                	ld	s0,16(sp)
     4f6:	64a2                	ld	s1,8(sp)
     4f8:	6902                	ld	s2,0(sp)
     4fa:	6105                	addi	sp,sp,32
     4fc:	8082                	ret

00000000000004fe <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     4fe:	7139                	addi	sp,sp,-64
     500:	fc06                	sd	ra,56(sp)
     502:	f822                	sd	s0,48(sp)
     504:	f426                	sd	s1,40(sp)
     506:	f04a                	sd	s2,32(sp)
     508:	ec4e                	sd	s3,24(sp)
     50a:	e852                	sd	s4,16(sp)
     50c:	e456                	sd	s5,8(sp)
     50e:	e05a                	sd	s6,0(sp)
     510:	0080                	addi	s0,sp,64
     512:	8a2a                	mv	s4,a0
     514:	892e                	mv	s2,a1
     516:	8ab2                	mv	s5,a2
     518:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     51a:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     51c:	00002997          	auipc	s3,0x2
     520:	aec98993          	addi	s3,s3,-1300 # 2008 <whitespace>
     524:	00b4fe63          	bgeu	s1,a1,540 <gettoken+0x42>
     528:	0004c583          	lbu	a1,0(s1)
     52c:	854e                	mv	a0,s3
     52e:	00001097          	auipc	ra,0x1
     532:	a48080e7          	jalr	-1464(ra) # f76 <strchr>
     536:	c509                	beqz	a0,540 <gettoken+0x42>
    s++;
     538:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     53a:	fe9917e3          	bne	s2,s1,528 <gettoken+0x2a>
    s++;
     53e:	84ca                	mv	s1,s2
  if(q)
     540:	000a8463          	beqz	s5,548 <gettoken+0x4a>
    *q = s;
     544:	009ab023          	sd	s1,0(s5)
  ret = *s;
     548:	0004c783          	lbu	a5,0(s1)
     54c:	00078a9b          	sext.w	s5,a5
  switch(*s){
     550:	03c00713          	li	a4,60
     554:	06f76663          	bltu	a4,a5,5c0 <gettoken+0xc2>
     558:	03a00713          	li	a4,58
     55c:	00f76e63          	bltu	a4,a5,578 <gettoken+0x7a>
     560:	cf89                	beqz	a5,57a <gettoken+0x7c>
     562:	02600713          	li	a4,38
     566:	00e78963          	beq	a5,a4,578 <gettoken+0x7a>
     56a:	fd87879b          	addiw	a5,a5,-40
     56e:	0ff7f793          	zext.b	a5,a5
     572:	4705                	li	a4,1
     574:	06f76d63          	bltu	a4,a5,5ee <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     578:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     57a:	000b0463          	beqz	s6,582 <gettoken+0x84>
    *eq = s;
     57e:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     582:	00002997          	auipc	s3,0x2
     586:	a8698993          	addi	s3,s3,-1402 # 2008 <whitespace>
     58a:	0124fe63          	bgeu	s1,s2,5a6 <gettoken+0xa8>
     58e:	0004c583          	lbu	a1,0(s1)
     592:	854e                	mv	a0,s3
     594:	00001097          	auipc	ra,0x1
     598:	9e2080e7          	jalr	-1566(ra) # f76 <strchr>
     59c:	c509                	beqz	a0,5a6 <gettoken+0xa8>
    s++;
     59e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     5a0:	fe9917e3          	bne	s2,s1,58e <gettoken+0x90>
    s++;
     5a4:	84ca                	mv	s1,s2
  *ps = s;
     5a6:	009a3023          	sd	s1,0(s4)
  return ret;
}
     5aa:	8556                	mv	a0,s5
     5ac:	70e2                	ld	ra,56(sp)
     5ae:	7442                	ld	s0,48(sp)
     5b0:	74a2                	ld	s1,40(sp)
     5b2:	7902                	ld	s2,32(sp)
     5b4:	69e2                	ld	s3,24(sp)
     5b6:	6a42                	ld	s4,16(sp)
     5b8:	6aa2                	ld	s5,8(sp)
     5ba:	6b02                	ld	s6,0(sp)
     5bc:	6121                	addi	sp,sp,64
     5be:	8082                	ret
  switch(*s){
     5c0:	03e00713          	li	a4,62
     5c4:	02e79163          	bne	a5,a4,5e6 <gettoken+0xe8>
    s++;
     5c8:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     5cc:	0014c703          	lbu	a4,1(s1)
     5d0:	03e00793          	li	a5,62
      s++;
     5d4:	0489                	addi	s1,s1,2
      ret = '+';
     5d6:	02b00a93          	li	s5,43
    if(*s == '>'){
     5da:	faf700e3          	beq	a4,a5,57a <gettoken+0x7c>
    s++;
     5de:	84b6                	mv	s1,a3
  ret = *s;
     5e0:	03e00a93          	li	s5,62
     5e4:	bf59                	j	57a <gettoken+0x7c>
  switch(*s){
     5e6:	07c00713          	li	a4,124
     5ea:	f8e787e3          	beq	a5,a4,578 <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5ee:	00002997          	auipc	s3,0x2
     5f2:	a1a98993          	addi	s3,s3,-1510 # 2008 <whitespace>
     5f6:	00002a97          	auipc	s5,0x2
     5fa:	a0aa8a93          	addi	s5,s5,-1526 # 2000 <symbols>
     5fe:	0324f663          	bgeu	s1,s2,62a <gettoken+0x12c>
     602:	0004c583          	lbu	a1,0(s1)
     606:	854e                	mv	a0,s3
     608:	00001097          	auipc	ra,0x1
     60c:	96e080e7          	jalr	-1682(ra) # f76 <strchr>
     610:	e50d                	bnez	a0,63a <gettoken+0x13c>
     612:	0004c583          	lbu	a1,0(s1)
     616:	8556                	mv	a0,s5
     618:	00001097          	auipc	ra,0x1
     61c:	95e080e7          	jalr	-1698(ra) # f76 <strchr>
     620:	e911                	bnez	a0,634 <gettoken+0x136>
      s++;
     622:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     624:	fc991fe3          	bne	s2,s1,602 <gettoken+0x104>
      s++;
     628:	84ca                	mv	s1,s2
  if(eq)
     62a:	06100a93          	li	s5,97
     62e:	f40b18e3          	bnez	s6,57e <gettoken+0x80>
     632:	bf95                	j	5a6 <gettoken+0xa8>
    ret = 'a';
     634:	06100a93          	li	s5,97
     638:	b789                	j	57a <gettoken+0x7c>
     63a:	06100a93          	li	s5,97
     63e:	bf35                	j	57a <gettoken+0x7c>

0000000000000640 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     640:	7139                	addi	sp,sp,-64
     642:	fc06                	sd	ra,56(sp)
     644:	f822                	sd	s0,48(sp)
     646:	f426                	sd	s1,40(sp)
     648:	f04a                	sd	s2,32(sp)
     64a:	ec4e                	sd	s3,24(sp)
     64c:	e852                	sd	s4,16(sp)
     64e:	e456                	sd	s5,8(sp)
     650:	0080                	addi	s0,sp,64
     652:	8a2a                	mv	s4,a0
     654:	892e                	mv	s2,a1
     656:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     658:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     65a:	00002997          	auipc	s3,0x2
     65e:	9ae98993          	addi	s3,s3,-1618 # 2008 <whitespace>
     662:	00b4fe63          	bgeu	s1,a1,67e <peek+0x3e>
     666:	0004c583          	lbu	a1,0(s1)
     66a:	854e                	mv	a0,s3
     66c:	00001097          	auipc	ra,0x1
     670:	90a080e7          	jalr	-1782(ra) # f76 <strchr>
     674:	c509                	beqz	a0,67e <peek+0x3e>
    s++;
     676:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     678:	fe9917e3          	bne	s2,s1,666 <peek+0x26>
    s++;
     67c:	84ca                	mv	s1,s2
  *ps = s;
     67e:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     682:	0004c583          	lbu	a1,0(s1)
     686:	4501                	li	a0,0
     688:	e991                	bnez	a1,69c <peek+0x5c>
}
     68a:	70e2                	ld	ra,56(sp)
     68c:	7442                	ld	s0,48(sp)
     68e:	74a2                	ld	s1,40(sp)
     690:	7902                	ld	s2,32(sp)
     692:	69e2                	ld	s3,24(sp)
     694:	6a42                	ld	s4,16(sp)
     696:	6aa2                	ld	s5,8(sp)
     698:	6121                	addi	sp,sp,64
     69a:	8082                	ret
  return *s && strchr(toks, *s);
     69c:	8556                	mv	a0,s5
     69e:	00001097          	auipc	ra,0x1
     6a2:	8d8080e7          	jalr	-1832(ra) # f76 <strchr>
     6a6:	00a03533          	snez	a0,a0
     6aa:	b7c5                	j	68a <peek+0x4a>

00000000000006ac <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     6ac:	7159                	addi	sp,sp,-112
     6ae:	f486                	sd	ra,104(sp)
     6b0:	f0a2                	sd	s0,96(sp)
     6b2:	eca6                	sd	s1,88(sp)
     6b4:	e8ca                	sd	s2,80(sp)
     6b6:	e4ce                	sd	s3,72(sp)
     6b8:	e0d2                	sd	s4,64(sp)
     6ba:	fc56                	sd	s5,56(sp)
     6bc:	f85a                	sd	s6,48(sp)
     6be:	f45e                	sd	s7,40(sp)
     6c0:	f062                	sd	s8,32(sp)
     6c2:	ec66                	sd	s9,24(sp)
     6c4:	1880                	addi	s0,sp,112
     6c6:	8a2a                	mv	s4,a0
     6c8:	89ae                	mv	s3,a1
     6ca:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     6cc:	00001b97          	auipc	s7,0x1
     6d0:	4e4b8b93          	addi	s7,s7,1252 # 1bb0 <get_time_perf+0xde>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     6d4:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     6d8:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     6dc:	a02d                	j	706 <parseredirs+0x5a>
      panic("missing file for redirection");
     6de:	00001517          	auipc	a0,0x1
     6e2:	4b250513          	addi	a0,a0,1202 # 1b90 <get_time_perf+0xbe>
     6e6:	00000097          	auipc	ra,0x0
     6ea:	9e0080e7          	jalr	-1568(ra) # c6 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     6ee:	4701                	li	a4,0
     6f0:	4681                	li	a3,0
     6f2:	f9043603          	ld	a2,-112(s0)
     6f6:	f9843583          	ld	a1,-104(s0)
     6fa:	8552                	mv	a0,s4
     6fc:	00000097          	auipc	ra,0x0
     700:	cd2080e7          	jalr	-814(ra) # 3ce <redircmd>
     704:	8a2a                	mv	s4,a0
    switch(tok){
     706:	03e00b13          	li	s6,62
     70a:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     70e:	865e                	mv	a2,s7
     710:	85ca                	mv	a1,s2
     712:	854e                	mv	a0,s3
     714:	00000097          	auipc	ra,0x0
     718:	f2c080e7          	jalr	-212(ra) # 640 <peek>
     71c:	c925                	beqz	a0,78c <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     71e:	4681                	li	a3,0
     720:	4601                	li	a2,0
     722:	85ca                	mv	a1,s2
     724:	854e                	mv	a0,s3
     726:	00000097          	auipc	ra,0x0
     72a:	dd8080e7          	jalr	-552(ra) # 4fe <gettoken>
     72e:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     730:	f9040693          	addi	a3,s0,-112
     734:	f9840613          	addi	a2,s0,-104
     738:	85ca                	mv	a1,s2
     73a:	854e                	mv	a0,s3
     73c:	00000097          	auipc	ra,0x0
     740:	dc2080e7          	jalr	-574(ra) # 4fe <gettoken>
     744:	f9851de3          	bne	a0,s8,6de <parseredirs+0x32>
    switch(tok){
     748:	fb9483e3          	beq	s1,s9,6ee <parseredirs+0x42>
     74c:	03648263          	beq	s1,s6,770 <parseredirs+0xc4>
     750:	fb549fe3          	bne	s1,s5,70e <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     754:	4705                	li	a4,1
     756:	20100693          	li	a3,513
     75a:	f9043603          	ld	a2,-112(s0)
     75e:	f9843583          	ld	a1,-104(s0)
     762:	8552                	mv	a0,s4
     764:	00000097          	auipc	ra,0x0
     768:	c6a080e7          	jalr	-918(ra) # 3ce <redircmd>
     76c:	8a2a                	mv	s4,a0
      break;
     76e:	bf61                	j	706 <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     770:	4705                	li	a4,1
     772:	60100693          	li	a3,1537
     776:	f9043603          	ld	a2,-112(s0)
     77a:	f9843583          	ld	a1,-104(s0)
     77e:	8552                	mv	a0,s4
     780:	00000097          	auipc	ra,0x0
     784:	c4e080e7          	jalr	-946(ra) # 3ce <redircmd>
     788:	8a2a                	mv	s4,a0
      break;
     78a:	bfb5                	j	706 <parseredirs+0x5a>
    }
  }
  return cmd;
}
     78c:	8552                	mv	a0,s4
     78e:	70a6                	ld	ra,104(sp)
     790:	7406                	ld	s0,96(sp)
     792:	64e6                	ld	s1,88(sp)
     794:	6946                	ld	s2,80(sp)
     796:	69a6                	ld	s3,72(sp)
     798:	6a06                	ld	s4,64(sp)
     79a:	7ae2                	ld	s5,56(sp)
     79c:	7b42                	ld	s6,48(sp)
     79e:	7ba2                	ld	s7,40(sp)
     7a0:	7c02                	ld	s8,32(sp)
     7a2:	6ce2                	ld	s9,24(sp)
     7a4:	6165                	addi	sp,sp,112
     7a6:	8082                	ret

00000000000007a8 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     7a8:	7159                	addi	sp,sp,-112
     7aa:	f486                	sd	ra,104(sp)
     7ac:	f0a2                	sd	s0,96(sp)
     7ae:	eca6                	sd	s1,88(sp)
     7b0:	e8ca                	sd	s2,80(sp)
     7b2:	e4ce                	sd	s3,72(sp)
     7b4:	e0d2                	sd	s4,64(sp)
     7b6:	fc56                	sd	s5,56(sp)
     7b8:	f85a                	sd	s6,48(sp)
     7ba:	f45e                	sd	s7,40(sp)
     7bc:	f062                	sd	s8,32(sp)
     7be:	ec66                	sd	s9,24(sp)
     7c0:	1880                	addi	s0,sp,112
     7c2:	8a2a                	mv	s4,a0
     7c4:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     7c6:	00001617          	auipc	a2,0x1
     7ca:	3f260613          	addi	a2,a2,1010 # 1bb8 <get_time_perf+0xe6>
     7ce:	00000097          	auipc	ra,0x0
     7d2:	e72080e7          	jalr	-398(ra) # 640 <peek>
     7d6:	e905                	bnez	a0,806 <parseexec+0x5e>
     7d8:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     7da:	00000097          	auipc	ra,0x0
     7de:	bbe080e7          	jalr	-1090(ra) # 398 <execcmd>
     7e2:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     7e4:	8656                	mv	a2,s5
     7e6:	85d2                	mv	a1,s4
     7e8:	00000097          	auipc	ra,0x0
     7ec:	ec4080e7          	jalr	-316(ra) # 6ac <parseredirs>
     7f0:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     7f2:	008c0913          	addi	s2,s8,8
     7f6:	00001b17          	auipc	s6,0x1
     7fa:	3e2b0b13          	addi	s6,s6,994 # 1bd8 <get_time_perf+0x106>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     7fe:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     802:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     804:	a0b1                	j	850 <parseexec+0xa8>
    return parseblock(ps, es);
     806:	85d6                	mv	a1,s5
     808:	8552                	mv	a0,s4
     80a:	00000097          	auipc	ra,0x0
     80e:	1bc080e7          	jalr	444(ra) # 9c6 <parseblock>
     812:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     814:	8526                	mv	a0,s1
     816:	70a6                	ld	ra,104(sp)
     818:	7406                	ld	s0,96(sp)
     81a:	64e6                	ld	s1,88(sp)
     81c:	6946                	ld	s2,80(sp)
     81e:	69a6                	ld	s3,72(sp)
     820:	6a06                	ld	s4,64(sp)
     822:	7ae2                	ld	s5,56(sp)
     824:	7b42                	ld	s6,48(sp)
     826:	7ba2                	ld	s7,40(sp)
     828:	7c02                	ld	s8,32(sp)
     82a:	6ce2                	ld	s9,24(sp)
     82c:	6165                	addi	sp,sp,112
     82e:	8082                	ret
      panic("syntax");
     830:	00001517          	auipc	a0,0x1
     834:	39050513          	addi	a0,a0,912 # 1bc0 <get_time_perf+0xee>
     838:	00000097          	auipc	ra,0x0
     83c:	88e080e7          	jalr	-1906(ra) # c6 <panic>
    ret = parseredirs(ret, ps, es);
     840:	8656                	mv	a2,s5
     842:	85d2                	mv	a1,s4
     844:	8526                	mv	a0,s1
     846:	00000097          	auipc	ra,0x0
     84a:	e66080e7          	jalr	-410(ra) # 6ac <parseredirs>
     84e:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     850:	865a                	mv	a2,s6
     852:	85d6                	mv	a1,s5
     854:	8552                	mv	a0,s4
     856:	00000097          	auipc	ra,0x0
     85a:	dea080e7          	jalr	-534(ra) # 640 <peek>
     85e:	e131                	bnez	a0,8a2 <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     860:	f9040693          	addi	a3,s0,-112
     864:	f9840613          	addi	a2,s0,-104
     868:	85d6                	mv	a1,s5
     86a:	8552                	mv	a0,s4
     86c:	00000097          	auipc	ra,0x0
     870:	c92080e7          	jalr	-878(ra) # 4fe <gettoken>
     874:	c51d                	beqz	a0,8a2 <parseexec+0xfa>
    if(tok != 'a')
     876:	fb951de3          	bne	a0,s9,830 <parseexec+0x88>
    cmd->argv[argc] = q;
     87a:	f9843783          	ld	a5,-104(s0)
     87e:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     882:	f9043783          	ld	a5,-112(s0)
     886:	04f93823          	sd	a5,80(s2)
    argc++;
     88a:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     88c:	0921                	addi	s2,s2,8
     88e:	fb7999e3          	bne	s3,s7,840 <parseexec+0x98>
      panic("too many args");
     892:	00001517          	auipc	a0,0x1
     896:	33650513          	addi	a0,a0,822 # 1bc8 <get_time_perf+0xf6>
     89a:	00000097          	auipc	ra,0x0
     89e:	82c080e7          	jalr	-2004(ra) # c6 <panic>
  cmd->argv[argc] = 0;
     8a2:	098e                	slli	s3,s3,0x3
     8a4:	9c4e                	add	s8,s8,s3
     8a6:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     8aa:	040c3c23          	sd	zero,88(s8)
  return ret;
     8ae:	b79d                	j	814 <parseexec+0x6c>

00000000000008b0 <parsepipe>:
{
     8b0:	7179                	addi	sp,sp,-48
     8b2:	f406                	sd	ra,40(sp)
     8b4:	f022                	sd	s0,32(sp)
     8b6:	ec26                	sd	s1,24(sp)
     8b8:	e84a                	sd	s2,16(sp)
     8ba:	e44e                	sd	s3,8(sp)
     8bc:	1800                	addi	s0,sp,48
     8be:	892a                	mv	s2,a0
     8c0:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     8c2:	00000097          	auipc	ra,0x0
     8c6:	ee6080e7          	jalr	-282(ra) # 7a8 <parseexec>
     8ca:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     8cc:	00001617          	auipc	a2,0x1
     8d0:	31460613          	addi	a2,a2,788 # 1be0 <get_time_perf+0x10e>
     8d4:	85ce                	mv	a1,s3
     8d6:	854a                	mv	a0,s2
     8d8:	00000097          	auipc	ra,0x0
     8dc:	d68080e7          	jalr	-664(ra) # 640 <peek>
     8e0:	e909                	bnez	a0,8f2 <parsepipe+0x42>
}
     8e2:	8526                	mv	a0,s1
     8e4:	70a2                	ld	ra,40(sp)
     8e6:	7402                	ld	s0,32(sp)
     8e8:	64e2                	ld	s1,24(sp)
     8ea:	6942                	ld	s2,16(sp)
     8ec:	69a2                	ld	s3,8(sp)
     8ee:	6145                	addi	sp,sp,48
     8f0:	8082                	ret
    gettoken(ps, es, 0, 0);
     8f2:	4681                	li	a3,0
     8f4:	4601                	li	a2,0
     8f6:	85ce                	mv	a1,s3
     8f8:	854a                	mv	a0,s2
     8fa:	00000097          	auipc	ra,0x0
     8fe:	c04080e7          	jalr	-1020(ra) # 4fe <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     902:	85ce                	mv	a1,s3
     904:	854a                	mv	a0,s2
     906:	00000097          	auipc	ra,0x0
     90a:	faa080e7          	jalr	-86(ra) # 8b0 <parsepipe>
     90e:	85aa                	mv	a1,a0
     910:	8526                	mv	a0,s1
     912:	00000097          	auipc	ra,0x0
     916:	b24080e7          	jalr	-1244(ra) # 436 <pipecmd>
     91a:	84aa                	mv	s1,a0
  return cmd;
     91c:	b7d9                	j	8e2 <parsepipe+0x32>

000000000000091e <parseline>:
{
     91e:	7179                	addi	sp,sp,-48
     920:	f406                	sd	ra,40(sp)
     922:	f022                	sd	s0,32(sp)
     924:	ec26                	sd	s1,24(sp)
     926:	e84a                	sd	s2,16(sp)
     928:	e44e                	sd	s3,8(sp)
     92a:	e052                	sd	s4,0(sp)
     92c:	1800                	addi	s0,sp,48
     92e:	892a                	mv	s2,a0
     930:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     932:	00000097          	auipc	ra,0x0
     936:	f7e080e7          	jalr	-130(ra) # 8b0 <parsepipe>
     93a:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     93c:	00001a17          	auipc	s4,0x1
     940:	2aca0a13          	addi	s4,s4,684 # 1be8 <get_time_perf+0x116>
     944:	a839                	j	962 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     946:	4681                	li	a3,0
     948:	4601                	li	a2,0
     94a:	85ce                	mv	a1,s3
     94c:	854a                	mv	a0,s2
     94e:	00000097          	auipc	ra,0x0
     952:	bb0080e7          	jalr	-1104(ra) # 4fe <gettoken>
    cmd = backcmd(cmd);
     956:	8526                	mv	a0,s1
     958:	00000097          	auipc	ra,0x0
     95c:	b6a080e7          	jalr	-1174(ra) # 4c2 <backcmd>
     960:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     962:	8652                	mv	a2,s4
     964:	85ce                	mv	a1,s3
     966:	854a                	mv	a0,s2
     968:	00000097          	auipc	ra,0x0
     96c:	cd8080e7          	jalr	-808(ra) # 640 <peek>
     970:	f979                	bnez	a0,946 <parseline+0x28>
  if(peek(ps, es, ";")){
     972:	00001617          	auipc	a2,0x1
     976:	27e60613          	addi	a2,a2,638 # 1bf0 <get_time_perf+0x11e>
     97a:	85ce                	mv	a1,s3
     97c:	854a                	mv	a0,s2
     97e:	00000097          	auipc	ra,0x0
     982:	cc2080e7          	jalr	-830(ra) # 640 <peek>
     986:	e911                	bnez	a0,99a <parseline+0x7c>
}
     988:	8526                	mv	a0,s1
     98a:	70a2                	ld	ra,40(sp)
     98c:	7402                	ld	s0,32(sp)
     98e:	64e2                	ld	s1,24(sp)
     990:	6942                	ld	s2,16(sp)
     992:	69a2                	ld	s3,8(sp)
     994:	6a02                	ld	s4,0(sp)
     996:	6145                	addi	sp,sp,48
     998:	8082                	ret
    gettoken(ps, es, 0, 0);
     99a:	4681                	li	a3,0
     99c:	4601                	li	a2,0
     99e:	85ce                	mv	a1,s3
     9a0:	854a                	mv	a0,s2
     9a2:	00000097          	auipc	ra,0x0
     9a6:	b5c080e7          	jalr	-1188(ra) # 4fe <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     9aa:	85ce                	mv	a1,s3
     9ac:	854a                	mv	a0,s2
     9ae:	00000097          	auipc	ra,0x0
     9b2:	f70080e7          	jalr	-144(ra) # 91e <parseline>
     9b6:	85aa                	mv	a1,a0
     9b8:	8526                	mv	a0,s1
     9ba:	00000097          	auipc	ra,0x0
     9be:	ac2080e7          	jalr	-1342(ra) # 47c <listcmd>
     9c2:	84aa                	mv	s1,a0
  return cmd;
     9c4:	b7d1                	j	988 <parseline+0x6a>

00000000000009c6 <parseblock>:
{
     9c6:	7179                	addi	sp,sp,-48
     9c8:	f406                	sd	ra,40(sp)
     9ca:	f022                	sd	s0,32(sp)
     9cc:	ec26                	sd	s1,24(sp)
     9ce:	e84a                	sd	s2,16(sp)
     9d0:	e44e                	sd	s3,8(sp)
     9d2:	1800                	addi	s0,sp,48
     9d4:	84aa                	mv	s1,a0
     9d6:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     9d8:	00001617          	auipc	a2,0x1
     9dc:	1e060613          	addi	a2,a2,480 # 1bb8 <get_time_perf+0xe6>
     9e0:	00000097          	auipc	ra,0x0
     9e4:	c60080e7          	jalr	-928(ra) # 640 <peek>
     9e8:	c12d                	beqz	a0,a4a <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     9ea:	4681                	li	a3,0
     9ec:	4601                	li	a2,0
     9ee:	85ca                	mv	a1,s2
     9f0:	8526                	mv	a0,s1
     9f2:	00000097          	auipc	ra,0x0
     9f6:	b0c080e7          	jalr	-1268(ra) # 4fe <gettoken>
  cmd = parseline(ps, es);
     9fa:	85ca                	mv	a1,s2
     9fc:	8526                	mv	a0,s1
     9fe:	00000097          	auipc	ra,0x0
     a02:	f20080e7          	jalr	-224(ra) # 91e <parseline>
     a06:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     a08:	00001617          	auipc	a2,0x1
     a0c:	20060613          	addi	a2,a2,512 # 1c08 <get_time_perf+0x136>
     a10:	85ca                	mv	a1,s2
     a12:	8526                	mv	a0,s1
     a14:	00000097          	auipc	ra,0x0
     a18:	c2c080e7          	jalr	-980(ra) # 640 <peek>
     a1c:	cd1d                	beqz	a0,a5a <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     a1e:	4681                	li	a3,0
     a20:	4601                	li	a2,0
     a22:	85ca                	mv	a1,s2
     a24:	8526                	mv	a0,s1
     a26:	00000097          	auipc	ra,0x0
     a2a:	ad8080e7          	jalr	-1320(ra) # 4fe <gettoken>
  cmd = parseredirs(cmd, ps, es);
     a2e:	864a                	mv	a2,s2
     a30:	85a6                	mv	a1,s1
     a32:	854e                	mv	a0,s3
     a34:	00000097          	auipc	ra,0x0
     a38:	c78080e7          	jalr	-904(ra) # 6ac <parseredirs>
}
     a3c:	70a2                	ld	ra,40(sp)
     a3e:	7402                	ld	s0,32(sp)
     a40:	64e2                	ld	s1,24(sp)
     a42:	6942                	ld	s2,16(sp)
     a44:	69a2                	ld	s3,8(sp)
     a46:	6145                	addi	sp,sp,48
     a48:	8082                	ret
    panic("parseblock");
     a4a:	00001517          	auipc	a0,0x1
     a4e:	1ae50513          	addi	a0,a0,430 # 1bf8 <get_time_perf+0x126>
     a52:	fffff097          	auipc	ra,0xfffff
     a56:	674080e7          	jalr	1652(ra) # c6 <panic>
    panic("syntax - missing )");
     a5a:	00001517          	auipc	a0,0x1
     a5e:	1b650513          	addi	a0,a0,438 # 1c10 <get_time_perf+0x13e>
     a62:	fffff097          	auipc	ra,0xfffff
     a66:	664080e7          	jalr	1636(ra) # c6 <panic>

0000000000000a6a <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     a6a:	1101                	addi	sp,sp,-32
     a6c:	ec06                	sd	ra,24(sp)
     a6e:	e822                	sd	s0,16(sp)
     a70:	e426                	sd	s1,8(sp)
     a72:	1000                	addi	s0,sp,32
     a74:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     a76:	c521                	beqz	a0,abe <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     a78:	4118                	lw	a4,0(a0)
     a7a:	4795                	li	a5,5
     a7c:	04e7e163          	bltu	a5,a4,abe <nulterminate+0x54>
     a80:	00056783          	lwu	a5,0(a0)
     a84:	078a                	slli	a5,a5,0x2
     a86:	00001717          	auipc	a4,0x1
     a8a:	2ae70713          	addi	a4,a4,686 # 1d34 <get_time_perf+0x262>
     a8e:	97ba                	add	a5,a5,a4
     a90:	439c                	lw	a5,0(a5)
     a92:	97ba                	add	a5,a5,a4
     a94:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     a96:	651c                	ld	a5,8(a0)
     a98:	c39d                	beqz	a5,abe <nulterminate+0x54>
     a9a:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     a9e:	67b8                	ld	a4,72(a5)
     aa0:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     aa4:	07a1                	addi	a5,a5,8
     aa6:	ff87b703          	ld	a4,-8(a5)
     aaa:	fb75                	bnez	a4,a9e <nulterminate+0x34>
     aac:	a809                	j	abe <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     aae:	6508                	ld	a0,8(a0)
     ab0:	00000097          	auipc	ra,0x0
     ab4:	fba080e7          	jalr	-70(ra) # a6a <nulterminate>
    *rcmd->efile = 0;
     ab8:	6c9c                	ld	a5,24(s1)
     aba:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     abe:	8526                	mv	a0,s1
     ac0:	60e2                	ld	ra,24(sp)
     ac2:	6442                	ld	s0,16(sp)
     ac4:	64a2                	ld	s1,8(sp)
     ac6:	6105                	addi	sp,sp,32
     ac8:	8082                	ret
    nulterminate(pcmd->left);
     aca:	6508                	ld	a0,8(a0)
     acc:	00000097          	auipc	ra,0x0
     ad0:	f9e080e7          	jalr	-98(ra) # a6a <nulterminate>
    nulterminate(pcmd->right);
     ad4:	6888                	ld	a0,16(s1)
     ad6:	00000097          	auipc	ra,0x0
     ada:	f94080e7          	jalr	-108(ra) # a6a <nulterminate>
    break;
     ade:	b7c5                	j	abe <nulterminate+0x54>
    nulterminate(lcmd->left);
     ae0:	6508                	ld	a0,8(a0)
     ae2:	00000097          	auipc	ra,0x0
     ae6:	f88080e7          	jalr	-120(ra) # a6a <nulterminate>
    nulterminate(lcmd->right);
     aea:	6888                	ld	a0,16(s1)
     aec:	00000097          	auipc	ra,0x0
     af0:	f7e080e7          	jalr	-130(ra) # a6a <nulterminate>
    break;
     af4:	b7e9                	j	abe <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     af6:	6508                	ld	a0,8(a0)
     af8:	00000097          	auipc	ra,0x0
     afc:	f72080e7          	jalr	-142(ra) # a6a <nulterminate>
    break;
     b00:	bf7d                	j	abe <nulterminate+0x54>

0000000000000b02 <parsecmd>:
{
     b02:	7179                	addi	sp,sp,-48
     b04:	f406                	sd	ra,40(sp)
     b06:	f022                	sd	s0,32(sp)
     b08:	ec26                	sd	s1,24(sp)
     b0a:	e84a                	sd	s2,16(sp)
     b0c:	1800                	addi	s0,sp,48
     b0e:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     b12:	84aa                	mv	s1,a0
     b14:	00000097          	auipc	ra,0x0
     b18:	416080e7          	jalr	1046(ra) # f2a <strlen>
     b1c:	1502                	slli	a0,a0,0x20
     b1e:	9101                	srli	a0,a0,0x20
     b20:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     b22:	85a6                	mv	a1,s1
     b24:	fd840513          	addi	a0,s0,-40
     b28:	00000097          	auipc	ra,0x0
     b2c:	df6080e7          	jalr	-522(ra) # 91e <parseline>
     b30:	892a                	mv	s2,a0
  peek(&s, es, "");
     b32:	00001617          	auipc	a2,0x1
     b36:	12e60613          	addi	a2,a2,302 # 1c60 <get_time_perf+0x18e>
     b3a:	85a6                	mv	a1,s1
     b3c:	fd840513          	addi	a0,s0,-40
     b40:	00000097          	auipc	ra,0x0
     b44:	b00080e7          	jalr	-1280(ra) # 640 <peek>
  if(s != es){
     b48:	fd843603          	ld	a2,-40(s0)
     b4c:	00961e63          	bne	a2,s1,b68 <parsecmd+0x66>
  nulterminate(cmd);
     b50:	854a                	mv	a0,s2
     b52:	00000097          	auipc	ra,0x0
     b56:	f18080e7          	jalr	-232(ra) # a6a <nulterminate>
}
     b5a:	854a                	mv	a0,s2
     b5c:	70a2                	ld	ra,40(sp)
     b5e:	7402                	ld	s0,32(sp)
     b60:	64e2                	ld	s1,24(sp)
     b62:	6942                	ld	s2,16(sp)
     b64:	6145                	addi	sp,sp,48
     b66:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     b68:	00001597          	auipc	a1,0x1
     b6c:	0c058593          	addi	a1,a1,192 # 1c28 <get_time_perf+0x156>
     b70:	4509                	li	a0,2
     b72:	00001097          	auipc	ra,0x1
     b76:	950080e7          	jalr	-1712(ra) # 14c2 <fprintf>
    panic("syntax");
     b7a:	00001517          	auipc	a0,0x1
     b7e:	04650513          	addi	a0,a0,70 # 1bc0 <get_time_perf+0xee>
     b82:	fffff097          	auipc	ra,0xfffff
     b86:	544080e7          	jalr	1348(ra) # c6 <panic>

0000000000000b8a <beginswith>:


char * beginswith(char * src, char *target){
     b8a:	1141                	addi	sp,sp,-16
     b8c:	e422                	sd	s0,8(sp)
     b8e:	0800                	addi	s0,sp,16
     b90:	87aa                	mv	a5,a0

  while(*src && (*src=='\t' || *src==' ')){src++;};
     b92:	00054703          	lbu	a4,0(a0)
     b96:	46a5                	li	a3,9
     b98:	02000613          	li	a2,32
     b9c:	e711                	bnez	a4,ba8 <beginswith+0x1e>
     b9e:	a035                	j	bca <beginswith+0x40>
     ba0:	0785                	addi	a5,a5,1
     ba2:	0007c703          	lbu	a4,0(a5)
     ba6:	c315                	beqz	a4,bca <beginswith+0x40>
     ba8:	fed70ce3          	beq	a4,a3,ba0 <beginswith+0x16>
     bac:	fec70ae3          	beq	a4,a2,ba0 <beginswith+0x16>

  while(*src && *target && *src==*target){
     bb0:	0007c703          	lbu	a4,0(a5)
     bb4:	cb19                	beqz	a4,bca <beginswith+0x40>
     bb6:	0005c683          	lbu	a3,0(a1)
     bba:	c285                	beqz	a3,bda <beginswith+0x50>
     bbc:	00e69d63          	bne	a3,a4,bd6 <beginswith+0x4c>
    src++;
     bc0:	0785                	addi	a5,a5,1
    target++;
     bc2:	0585                	addi	a1,a1,1
  while(*src && *target && *src==*target){
     bc4:	0007c703          	lbu	a4,0(a5)
     bc8:	f77d                	bnez	a4,bb6 <beginswith+0x2c>
  }

  if (!*target){
     bca:	0005c703          	lbu	a4,0(a1)
    return src;
  }

  return 0;
     bce:	4501                	li	a0,0
  if (!*target){
     bd0:	e711                	bnez	a4,bdc <beginswith+0x52>
     bd2:	853e                	mv	a0,a5
     bd4:	a021                	j	bdc <beginswith+0x52>
  return 0;
     bd6:	4501                	li	a0,0
     bd8:	a011                	j	bdc <beginswith+0x52>
     bda:	853e                	mv	a0,a5
}
     bdc:	6422                	ld	s0,8(sp)
     bde:	0141                	addi	sp,sp,16
     be0:	8082                	ret

0000000000000be2 <print_time_infos>:

/*
  Prints the time information stored in the .time file
*/

void print_time_infos(void){
     be2:	7155                	addi	sp,sp,-208
     be4:	e586                	sd	ra,200(sp)
     be6:	e1a2                	sd	s0,192(sp)
     be8:	fd26                	sd	s1,184(sp)
     bea:	f94a                	sd	s2,176(sp)
     bec:	f54e                	sd	s3,168(sp)
     bee:	f152                	sd	s4,160(sp)
     bf0:	ed56                	sd	s5,152(sp)
     bf2:	e95a                	sd	s6,144(sp)
     bf4:	0980                	addi	s0,sp,208
  
  int fd = open(".time",O_RDONLY);
     bf6:	4581                	li	a1,0
     bf8:	00001517          	auipc	a0,0x1
     bfc:	f6850513          	addi	a0,a0,-152 # 1b60 <get_time_perf+0x8e>
     c00:	00000097          	auipc	ra,0x0
     c04:	58e080e7          	jalr	1422(ra) # 118e <open>
     c08:	89aa                	mv	s3,a0

  printf("\n\nTIME---------------------\n");
     c0a:	00001517          	auipc	a0,0x1
     c0e:	02e50513          	addi	a0,a0,46 # 1c38 <get_time_perf+0x166>
     c12:	00001097          	auipc	ra,0x1
     c16:	8de080e7          	jalr	-1826(ra) # 14f0 <printf>

  long totalTime = 0;
     c1a:	4a81                	li	s5,0
      break;

    /* Reading the cmd name */
    read(fd, cmdName, cmdLen);
    cmdName[cmdLen]=0;
    printf("CMD: %s\n", cmdName);
     c1c:	00001b17          	auipc	s6,0x1
     c20:	03cb0b13          	addi	s6,s6,60 # 1c58 <get_time_perf+0x186>

    /* Reading the timing information */
    e_time_t time;
    read(fd, &time, sizeof(e_time_t));

    tick_to_time("Creation: ",time.creationTime * 100);
     c24:	06400a13          	li	s4,100
     c28:	64bd                	lui	s1,0xf
     c2a:	a6048493          	addi	s1,s1,-1440 # ea60 <base+0xc9d8>
     c2e:	3e800913          	li	s2,1000
     c32:	a0dd                	j	d18 <print_time_infos+0x136>
    read(fd, cmdName, cmdLen);
     c34:	f3c42603          	lw	a2,-196(s0)
     c38:	f5840593          	addi	a1,s0,-168
     c3c:	854e                	mv	a0,s3
     c3e:	00000097          	auipc	ra,0x0
     c42:	528080e7          	jalr	1320(ra) # 1166 <read>
    cmdName[cmdLen]=0;
     c46:	f3c42783          	lw	a5,-196(s0)
     c4a:	fc078793          	addi	a5,a5,-64
     c4e:	97a2                	add	a5,a5,s0
     c50:	f8078c23          	sb	zero,-104(a5)
    printf("CMD: %s\n", cmdName);
     c54:	f5840593          	addi	a1,s0,-168
     c58:	855a                	mv	a0,s6
     c5a:	00001097          	auipc	ra,0x1
     c5e:	896080e7          	jalr	-1898(ra) # 14f0 <printf>
    read(fd, &time, sizeof(e_time_t));
     c62:	4661                	li	a2,24
     c64:	f4040593          	addi	a1,s0,-192
     c68:	854e                	mv	a0,s3
     c6a:	00000097          	auipc	ra,0x0
     c6e:	4fc080e7          	jalr	1276(ra) # 1166 <read>
    tick_to_time("Creation: ",time.creationTime * 100);
     c72:	f4043783          	ld	a5,-192(s0)
     c76:	02fa07b3          	mul	a5,s4,a5
     c7a:	0297f6b3          	remu	a3,a5,s1
     c7e:	0326f733          	remu	a4,a3,s2
     c82:	0326d6b3          	divu	a3,a3,s2
     c86:	0297d633          	divu	a2,a5,s1
     c8a:	00001597          	auipc	a1,0x1
     c8e:	fde58593          	addi	a1,a1,-34 # 1c68 <get_time_perf+0x196>
     c92:	00001517          	auipc	a0,0x1
     c96:	fe650513          	addi	a0,a0,-26 # 1c78 <get_time_perf+0x1a6>
     c9a:	00001097          	auipc	ra,0x1
     c9e:	856080e7          	jalr	-1962(ra) # 14f0 <printf>
    tick_to_time("End: ", time.endTime * 100);
     ca2:	f4843783          	ld	a5,-184(s0)
     ca6:	02fa07b3          	mul	a5,s4,a5
     caa:	0297f6b3          	remu	a3,a5,s1
     cae:	0326f733          	remu	a4,a3,s2
     cb2:	0326d6b3          	divu	a3,a3,s2
     cb6:	0297d633          	divu	a2,a5,s1
     cba:	00001597          	auipc	a1,0x1
     cbe:	fe658593          	addi	a1,a1,-26 # 1ca0 <get_time_perf+0x1ce>
     cc2:	00001517          	auipc	a0,0x1
     cc6:	fb650513          	addi	a0,a0,-74 # 1c78 <get_time_perf+0x1a6>
     cca:	00001097          	auipc	ra,0x1
     cce:	826080e7          	jalr	-2010(ra) # 14f0 <printf>
    tick_to_time("Duration: ", time.totalTime * 100);
     cd2:	f5043783          	ld	a5,-176(s0)
     cd6:	02fa07b3          	mul	a5,s4,a5
     cda:	0297f6b3          	remu	a3,a5,s1
     cde:	0326f733          	remu	a4,a3,s2
     ce2:	0326d6b3          	divu	a3,a3,s2
     ce6:	0297d633          	divu	a2,a5,s1
     cea:	00001597          	auipc	a1,0x1
     cee:	fbe58593          	addi	a1,a1,-66 # 1ca8 <get_time_perf+0x1d6>
     cf2:	00001517          	auipc	a0,0x1
     cf6:	f8650513          	addi	a0,a0,-122 # 1c78 <get_time_perf+0x1a6>
     cfa:	00000097          	auipc	ra,0x0
     cfe:	7f6080e7          	jalr	2038(ra) # 14f0 <printf>

    totalTime += time.totalTime;
     d02:	f5043783          	ld	a5,-176(s0)
     d06:	9abe                	add	s5,s5,a5

    printf("\n");
     d08:	00001517          	auipc	a0,0x1
     d0c:	01050513          	addi	a0,a0,16 # 1d18 <get_time_perf+0x246>
     d10:	00000097          	auipc	ra,0x0
     d14:	7e0080e7          	jalr	2016(ra) # 14f0 <printf>
    if (read(fd, &cmdLen, sizeof(int))<=0)
     d18:	4611                	li	a2,4
     d1a:	f3c40593          	addi	a1,s0,-196
     d1e:	854e                	mv	a0,s3
     d20:	00000097          	auipc	ra,0x0
     d24:	446080e7          	jalr	1094(ra) # 1166 <read>
     d28:	f0a046e3          	bgtz	a0,c34 <print_time_infos+0x52>
  }

  printf("------------Total------------\n");
     d2c:	00001517          	auipc	a0,0x1
     d30:	f8c50513          	addi	a0,a0,-116 # 1cb8 <get_time_perf+0x1e6>
     d34:	00000097          	auipc	ra,0x0
     d38:	7bc080e7          	jalr	1980(ra) # 14f0 <printf>
  tick_to_time("Total: ", totalTime * 100);
     d3c:	06400793          	li	a5,100
     d40:	02fa87b3          	mul	a5,s5,a5
     d44:	66bd                	lui	a3,0xf
     d46:	a6068693          	addi	a3,a3,-1440 # ea60 <base+0xc9d8>
     d4a:	02d7e6b3          	rem	a3,a5,a3
     d4e:	3e800613          	li	a2,1000
     d52:	02c6e733          	rem	a4,a3,a2
     d56:	02c6c6b3          	div	a3,a3,a2
     d5a:	25800613          	li	a2,600
     d5e:	02cac633          	div	a2,s5,a2
     d62:	00001597          	auipc	a1,0x1
     d66:	f7658593          	addi	a1,a1,-138 # 1cd8 <get_time_perf+0x206>
     d6a:	00001517          	auipc	a0,0x1
     d6e:	f0e50513          	addi	a0,a0,-242 # 1c78 <get_time_perf+0x1a6>
     d72:	00000097          	auipc	ra,0x0
     d76:	77e080e7          	jalr	1918(ra) # 14f0 <printf>
}
     d7a:	60ae                	ld	ra,200(sp)
     d7c:	640e                	ld	s0,192(sp)
     d7e:	74ea                	ld	s1,184(sp)
     d80:	794a                	ld	s2,176(sp)
     d82:	79aa                	ld	s3,168(sp)
     d84:	7a0a                	ld	s4,160(sp)
     d86:	6aea                	ld	s5,152(sp)
     d88:	6b4a                	ld	s6,144(sp)
     d8a:	6169                	addi	sp,sp,208
     d8c:	8082                	ret

0000000000000d8e <main>:


int
main(void)
{
     d8e:	715d                	addi	sp,sp,-80
     d90:	e486                	sd	ra,72(sp)
     d92:	e0a2                	sd	s0,64(sp)
     d94:	fc26                	sd	s1,56(sp)
     d96:	f84a                	sd	s2,48(sp)
     d98:	f44e                	sd	s3,40(sp)
     d9a:	f052                	sd	s4,32(sp)
     d9c:	ec56                	sd	s5,24(sp)
     d9e:	e85a                	sd	s6,16(sp)
     da0:	e45e                	sd	s7,8(sp)
     da2:	0880                	addi	s0,sp,80

  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     da4:	00001497          	auipc	s1,0x1
     da8:	f3c48493          	addi	s1,s1,-196 # 1ce0 <get_time_perf+0x20e>
     dac:	4589                	li	a1,2
     dae:	8526                	mv	a0,s1
     db0:	00000097          	auipc	ra,0x0
     db4:	3de080e7          	jalr	990(ra) # 118e <open>
     db8:	00054963          	bltz	a0,dca <main+0x3c>
    if(fd >= 3){
     dbc:	4789                	li	a5,2
     dbe:	fea7d7e3          	bge	a5,a0,dac <main+0x1e>
      close(fd);
     dc2:	00000097          	auipc	ra,0x0
     dc6:	3b4080e7          	jalr	948(ra) # 1176 <close>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     dca:	00001497          	auipc	s1,0x1
     dce:	25648493          	addi	s1,s1,598 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     dd2:	06300993          	li	s3,99
      runcmd(parsecmd(buf));
    }
    wait(0);

     /* Check for the existance of .time file and if it exists, remove it */
    if (open(".time",O_RDONLY)>0){
     dd6:	00001917          	auipc	s2,0x1
     dda:	d8a90913          	addi	s2,s2,-630 # 1b60 <get_time_perf+0x8e>

      /* Process the content */
      print_time_infos();

      if(unlink(".time") < 0)
        printf("[ERR] Deleting .time file failed\n");
     dde:	00001a97          	auipc	s5,0x1
     de2:	f1aa8a93          	addi	s5,s5,-230 # 1cf8 <get_time_perf+0x226>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     de6:	02000a13          	li	s4,32
      if(chdir(buf+3) < 0)
     dea:	00001b17          	auipc	s6,0x1
     dee:	239b0b13          	addi	s6,s6,569 # 2023 <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     df2:	00001b97          	auipc	s7,0x1
     df6:	ef6b8b93          	addi	s7,s7,-266 # 1ce8 <get_time_perf+0x216>
     dfa:	a01d                	j	e20 <main+0x92>
    if(fork1() == 0){
     dfc:	fffff097          	auipc	ra,0xfffff
     e00:	2f0080e7          	jalr	752(ra) # ec <fork1>
     e04:	c141                	beqz	a0,e84 <main+0xf6>
    wait(0);
     e06:	4501                	li	a0,0
     e08:	00000097          	auipc	ra,0x0
     e0c:	34e080e7          	jalr	846(ra) # 1156 <wait>
    if (open(".time",O_RDONLY)>0){
     e10:	4581                	li	a1,0
     e12:	854a                	mv	a0,s2
     e14:	00000097          	auipc	ra,0x0
     e18:	37a080e7          	jalr	890(ra) # 118e <open>
     e1c:	08a04063          	bgtz	a0,e9c <main+0x10e>
  while(getcmd(buf, sizeof(buf)) >= 0){
     e20:	06400593          	li	a1,100
     e24:	8526                	mv	a0,s1
     e26:	fffff097          	auipc	ra,0xfffff
     e2a:	24a080e7          	jalr	586(ra) # 70 <getcmd>
     e2e:	08054863          	bltz	a0,ebe <main+0x130>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     e32:	0004c783          	lbu	a5,0(s1)
     e36:	fd3793e3          	bne	a5,s3,dfc <main+0x6e>
     e3a:	0014c703          	lbu	a4,1(s1)
     e3e:	06400793          	li	a5,100
     e42:	faf71de3          	bne	a4,a5,dfc <main+0x6e>
     e46:	0024c783          	lbu	a5,2(s1)
     e4a:	fb4799e3          	bne	a5,s4,dfc <main+0x6e>
      buf[strlen(buf)-1] = 0;  // chop \n
     e4e:	8526                	mv	a0,s1
     e50:	00000097          	auipc	ra,0x0
     e54:	0da080e7          	jalr	218(ra) # f2a <strlen>
     e58:	fff5079b          	addiw	a5,a0,-1
     e5c:	1782                	slli	a5,a5,0x20
     e5e:	9381                	srli	a5,a5,0x20
     e60:	97a6                	add	a5,a5,s1
     e62:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     e66:	855a                	mv	a0,s6
     e68:	00000097          	auipc	ra,0x0
     e6c:	356080e7          	jalr	854(ra) # 11be <chdir>
     e70:	fa0558e3          	bgez	a0,e20 <main+0x92>
        fprintf(2, "cannot cd %s\n", buf+3);
     e74:	865a                	mv	a2,s6
     e76:	85de                	mv	a1,s7
     e78:	4509                	li	a0,2
     e7a:	00000097          	auipc	ra,0x0
     e7e:	648080e7          	jalr	1608(ra) # 14c2 <fprintf>
     e82:	bf79                	j	e20 <main+0x92>
      runcmd(parsecmd(buf));
     e84:	00001517          	auipc	a0,0x1
     e88:	19c50513          	addi	a0,a0,412 # 2020 <buf.0>
     e8c:	00000097          	auipc	ra,0x0
     e90:	c76080e7          	jalr	-906(ra) # b02 <parsecmd>
     e94:	fffff097          	auipc	ra,0xfffff
     e98:	286080e7          	jalr	646(ra) # 11a <runcmd>
      print_time_infos();
     e9c:	00000097          	auipc	ra,0x0
     ea0:	d46080e7          	jalr	-698(ra) # be2 <print_time_infos>
      if(unlink(".time") < 0)
     ea4:	854a                	mv	a0,s2
     ea6:	00000097          	auipc	ra,0x0
     eaa:	2f8080e7          	jalr	760(ra) # 119e <unlink>
     eae:	f60559e3          	bgez	a0,e20 <main+0x92>
        printf("[ERR] Deleting .time file failed\n");
     eb2:	8556                	mv	a0,s5
     eb4:	00000097          	auipc	ra,0x0
     eb8:	63c080e7          	jalr	1596(ra) # 14f0 <printf>
     ebc:	b795                	j	e20 <main+0x92>
    }
  }
  exit(0);
     ebe:	4501                	li	a0,0
     ec0:	00000097          	auipc	ra,0x0
     ec4:	28e080e7          	jalr	654(ra) # 114e <exit>

0000000000000ec8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     ec8:	1141                	addi	sp,sp,-16
     eca:	e406                	sd	ra,8(sp)
     ecc:	e022                	sd	s0,0(sp)
     ece:	0800                	addi	s0,sp,16
  extern int main();
  main();
     ed0:	00000097          	auipc	ra,0x0
     ed4:	ebe080e7          	jalr	-322(ra) # d8e <main>
  exit(0);
     ed8:	4501                	li	a0,0
     eda:	00000097          	auipc	ra,0x0
     ede:	274080e7          	jalr	628(ra) # 114e <exit>

0000000000000ee2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     ee2:	1141                	addi	sp,sp,-16
     ee4:	e422                	sd	s0,8(sp)
     ee6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     ee8:	87aa                	mv	a5,a0
     eea:	0585                	addi	a1,a1,1
     eec:	0785                	addi	a5,a5,1
     eee:	fff5c703          	lbu	a4,-1(a1)
     ef2:	fee78fa3          	sb	a4,-1(a5)
     ef6:	fb75                	bnez	a4,eea <strcpy+0x8>
    ;
  return os;
}
     ef8:	6422                	ld	s0,8(sp)
     efa:	0141                	addi	sp,sp,16
     efc:	8082                	ret

0000000000000efe <strcmp>:

int
strcmp(const char *p, const char *q)
{
     efe:	1141                	addi	sp,sp,-16
     f00:	e422                	sd	s0,8(sp)
     f02:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     f04:	00054783          	lbu	a5,0(a0)
     f08:	cb91                	beqz	a5,f1c <strcmp+0x1e>
     f0a:	0005c703          	lbu	a4,0(a1)
     f0e:	00f71763          	bne	a4,a5,f1c <strcmp+0x1e>
    p++, q++;
     f12:	0505                	addi	a0,a0,1
     f14:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     f16:	00054783          	lbu	a5,0(a0)
     f1a:	fbe5                	bnez	a5,f0a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     f1c:	0005c503          	lbu	a0,0(a1)
}
     f20:	40a7853b          	subw	a0,a5,a0
     f24:	6422                	ld	s0,8(sp)
     f26:	0141                	addi	sp,sp,16
     f28:	8082                	ret

0000000000000f2a <strlen>:

uint
strlen(const char *s)
{
     f2a:	1141                	addi	sp,sp,-16
     f2c:	e422                	sd	s0,8(sp)
     f2e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     f30:	00054783          	lbu	a5,0(a0)
     f34:	cf91                	beqz	a5,f50 <strlen+0x26>
     f36:	0505                	addi	a0,a0,1
     f38:	87aa                	mv	a5,a0
     f3a:	4685                	li	a3,1
     f3c:	9e89                	subw	a3,a3,a0
     f3e:	00f6853b          	addw	a0,a3,a5
     f42:	0785                	addi	a5,a5,1
     f44:	fff7c703          	lbu	a4,-1(a5)
     f48:	fb7d                	bnez	a4,f3e <strlen+0x14>
    ;
  return n;
}
     f4a:	6422                	ld	s0,8(sp)
     f4c:	0141                	addi	sp,sp,16
     f4e:	8082                	ret
  for(n = 0; s[n]; n++)
     f50:	4501                	li	a0,0
     f52:	bfe5                	j	f4a <strlen+0x20>

0000000000000f54 <memset>:

void*
memset(void *dst, int c, uint n)
{
     f54:	1141                	addi	sp,sp,-16
     f56:	e422                	sd	s0,8(sp)
     f58:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     f5a:	ca19                	beqz	a2,f70 <memset+0x1c>
     f5c:	87aa                	mv	a5,a0
     f5e:	1602                	slli	a2,a2,0x20
     f60:	9201                	srli	a2,a2,0x20
     f62:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     f66:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     f6a:	0785                	addi	a5,a5,1
     f6c:	fee79de3          	bne	a5,a4,f66 <memset+0x12>
  }
  return dst;
}
     f70:	6422                	ld	s0,8(sp)
     f72:	0141                	addi	sp,sp,16
     f74:	8082                	ret

0000000000000f76 <strchr>:

char*
strchr(const char *s, char c)
{
     f76:	1141                	addi	sp,sp,-16
     f78:	e422                	sd	s0,8(sp)
     f7a:	0800                	addi	s0,sp,16
  for(; *s; s++)
     f7c:	00054783          	lbu	a5,0(a0)
     f80:	cb99                	beqz	a5,f96 <strchr+0x20>
    if(*s == c)
     f82:	00f58763          	beq	a1,a5,f90 <strchr+0x1a>
  for(; *s; s++)
     f86:	0505                	addi	a0,a0,1
     f88:	00054783          	lbu	a5,0(a0)
     f8c:	fbfd                	bnez	a5,f82 <strchr+0xc>
      return (char*)s;
  return 0;
     f8e:	4501                	li	a0,0
}
     f90:	6422                	ld	s0,8(sp)
     f92:	0141                	addi	sp,sp,16
     f94:	8082                	ret
  return 0;
     f96:	4501                	li	a0,0
     f98:	bfe5                	j	f90 <strchr+0x1a>

0000000000000f9a <gets>:

char*
gets(char *buf, int max)
{
     f9a:	711d                	addi	sp,sp,-96
     f9c:	ec86                	sd	ra,88(sp)
     f9e:	e8a2                	sd	s0,80(sp)
     fa0:	e4a6                	sd	s1,72(sp)
     fa2:	e0ca                	sd	s2,64(sp)
     fa4:	fc4e                	sd	s3,56(sp)
     fa6:	f852                	sd	s4,48(sp)
     fa8:	f456                	sd	s5,40(sp)
     faa:	f05a                	sd	s6,32(sp)
     fac:	ec5e                	sd	s7,24(sp)
     fae:	1080                	addi	s0,sp,96
     fb0:	8baa                	mv	s7,a0
     fb2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     fb4:	892a                	mv	s2,a0
     fb6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     fb8:	4aa9                	li	s5,10
     fba:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     fbc:	89a6                	mv	s3,s1
     fbe:	2485                	addiw	s1,s1,1
     fc0:	0344d863          	bge	s1,s4,ff0 <gets+0x56>
    cc = read(0, &c, 1);
     fc4:	4605                	li	a2,1
     fc6:	faf40593          	addi	a1,s0,-81
     fca:	4501                	li	a0,0
     fcc:	00000097          	auipc	ra,0x0
     fd0:	19a080e7          	jalr	410(ra) # 1166 <read>
    if(cc < 1)
     fd4:	00a05e63          	blez	a0,ff0 <gets+0x56>
    buf[i++] = c;
     fd8:	faf44783          	lbu	a5,-81(s0)
     fdc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     fe0:	01578763          	beq	a5,s5,fee <gets+0x54>
     fe4:	0905                	addi	s2,s2,1
     fe6:	fd679be3          	bne	a5,s6,fbc <gets+0x22>
  for(i=0; i+1 < max; ){
     fea:	89a6                	mv	s3,s1
     fec:	a011                	j	ff0 <gets+0x56>
     fee:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     ff0:	99de                	add	s3,s3,s7
     ff2:	00098023          	sb	zero,0(s3)
  return buf;
}
     ff6:	855e                	mv	a0,s7
     ff8:	60e6                	ld	ra,88(sp)
     ffa:	6446                	ld	s0,80(sp)
     ffc:	64a6                	ld	s1,72(sp)
     ffe:	6906                	ld	s2,64(sp)
    1000:	79e2                	ld	s3,56(sp)
    1002:	7a42                	ld	s4,48(sp)
    1004:	7aa2                	ld	s5,40(sp)
    1006:	7b02                	ld	s6,32(sp)
    1008:	6be2                	ld	s7,24(sp)
    100a:	6125                	addi	sp,sp,96
    100c:	8082                	ret

000000000000100e <stat>:

int
stat(const char *n, struct stat *st)
{
    100e:	1101                	addi	sp,sp,-32
    1010:	ec06                	sd	ra,24(sp)
    1012:	e822                	sd	s0,16(sp)
    1014:	e426                	sd	s1,8(sp)
    1016:	e04a                	sd	s2,0(sp)
    1018:	1000                	addi	s0,sp,32
    101a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    101c:	4581                	li	a1,0
    101e:	00000097          	auipc	ra,0x0
    1022:	170080e7          	jalr	368(ra) # 118e <open>
  if(fd < 0)
    1026:	02054563          	bltz	a0,1050 <stat+0x42>
    102a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    102c:	85ca                	mv	a1,s2
    102e:	00000097          	auipc	ra,0x0
    1032:	178080e7          	jalr	376(ra) # 11a6 <fstat>
    1036:	892a                	mv	s2,a0
  close(fd);
    1038:	8526                	mv	a0,s1
    103a:	00000097          	auipc	ra,0x0
    103e:	13c080e7          	jalr	316(ra) # 1176 <close>
  return r;
}
    1042:	854a                	mv	a0,s2
    1044:	60e2                	ld	ra,24(sp)
    1046:	6442                	ld	s0,16(sp)
    1048:	64a2                	ld	s1,8(sp)
    104a:	6902                	ld	s2,0(sp)
    104c:	6105                	addi	sp,sp,32
    104e:	8082                	ret
    return -1;
    1050:	597d                	li	s2,-1
    1052:	bfc5                	j	1042 <stat+0x34>

0000000000001054 <atoi>:

int
atoi(const char *s)
{
    1054:	1141                	addi	sp,sp,-16
    1056:	e422                	sd	s0,8(sp)
    1058:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    105a:	00054683          	lbu	a3,0(a0)
    105e:	fd06879b          	addiw	a5,a3,-48
    1062:	0ff7f793          	zext.b	a5,a5
    1066:	4625                	li	a2,9
    1068:	02f66863          	bltu	a2,a5,1098 <atoi+0x44>
    106c:	872a                	mv	a4,a0
  n = 0;
    106e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    1070:	0705                	addi	a4,a4,1
    1072:	0025179b          	slliw	a5,a0,0x2
    1076:	9fa9                	addw	a5,a5,a0
    1078:	0017979b          	slliw	a5,a5,0x1
    107c:	9fb5                	addw	a5,a5,a3
    107e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    1082:	00074683          	lbu	a3,0(a4)
    1086:	fd06879b          	addiw	a5,a3,-48
    108a:	0ff7f793          	zext.b	a5,a5
    108e:	fef671e3          	bgeu	a2,a5,1070 <atoi+0x1c>
  return n;
}
    1092:	6422                	ld	s0,8(sp)
    1094:	0141                	addi	sp,sp,16
    1096:	8082                	ret
  n = 0;
    1098:	4501                	li	a0,0
    109a:	bfe5                	j	1092 <atoi+0x3e>

000000000000109c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    109c:	1141                	addi	sp,sp,-16
    109e:	e422                	sd	s0,8(sp)
    10a0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    10a2:	02b57463          	bgeu	a0,a1,10ca <memmove+0x2e>
    while(n-- > 0)
    10a6:	00c05f63          	blez	a2,10c4 <memmove+0x28>
    10aa:	1602                	slli	a2,a2,0x20
    10ac:	9201                	srli	a2,a2,0x20
    10ae:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    10b2:	872a                	mv	a4,a0
      *dst++ = *src++;
    10b4:	0585                	addi	a1,a1,1
    10b6:	0705                	addi	a4,a4,1
    10b8:	fff5c683          	lbu	a3,-1(a1)
    10bc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    10c0:	fee79ae3          	bne	a5,a4,10b4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    10c4:	6422                	ld	s0,8(sp)
    10c6:	0141                	addi	sp,sp,16
    10c8:	8082                	ret
    dst += n;
    10ca:	00c50733          	add	a4,a0,a2
    src += n;
    10ce:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    10d0:	fec05ae3          	blez	a2,10c4 <memmove+0x28>
    10d4:	fff6079b          	addiw	a5,a2,-1
    10d8:	1782                	slli	a5,a5,0x20
    10da:	9381                	srli	a5,a5,0x20
    10dc:	fff7c793          	not	a5,a5
    10e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    10e2:	15fd                	addi	a1,a1,-1
    10e4:	177d                	addi	a4,a4,-1
    10e6:	0005c683          	lbu	a3,0(a1)
    10ea:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    10ee:	fee79ae3          	bne	a5,a4,10e2 <memmove+0x46>
    10f2:	bfc9                	j	10c4 <memmove+0x28>

00000000000010f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    10f4:	1141                	addi	sp,sp,-16
    10f6:	e422                	sd	s0,8(sp)
    10f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    10fa:	ca05                	beqz	a2,112a <memcmp+0x36>
    10fc:	fff6069b          	addiw	a3,a2,-1
    1100:	1682                	slli	a3,a3,0x20
    1102:	9281                	srli	a3,a3,0x20
    1104:	0685                	addi	a3,a3,1
    1106:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1108:	00054783          	lbu	a5,0(a0)
    110c:	0005c703          	lbu	a4,0(a1)
    1110:	00e79863          	bne	a5,a4,1120 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    1114:	0505                	addi	a0,a0,1
    p2++;
    1116:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1118:	fed518e3          	bne	a0,a3,1108 <memcmp+0x14>
  }
  return 0;
    111c:	4501                	li	a0,0
    111e:	a019                	j	1124 <memcmp+0x30>
      return *p1 - *p2;
    1120:	40e7853b          	subw	a0,a5,a4
}
    1124:	6422                	ld	s0,8(sp)
    1126:	0141                	addi	sp,sp,16
    1128:	8082                	ret
  return 0;
    112a:	4501                	li	a0,0
    112c:	bfe5                	j	1124 <memcmp+0x30>

000000000000112e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    112e:	1141                	addi	sp,sp,-16
    1130:	e406                	sd	ra,8(sp)
    1132:	e022                	sd	s0,0(sp)
    1134:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    1136:	00000097          	auipc	ra,0x0
    113a:	f66080e7          	jalr	-154(ra) # 109c <memmove>
}
    113e:	60a2                	ld	ra,8(sp)
    1140:	6402                	ld	s0,0(sp)
    1142:	0141                	addi	sp,sp,16
    1144:	8082                	ret

0000000000001146 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1146:	4885                	li	a7,1
 ecall
    1148:	00000073          	ecall
 ret
    114c:	8082                	ret

000000000000114e <exit>:
.global exit
exit:
 li a7, SYS_exit
    114e:	4889                	li	a7,2
 ecall
    1150:	00000073          	ecall
 ret
    1154:	8082                	ret

0000000000001156 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1156:	488d                	li	a7,3
 ecall
    1158:	00000073          	ecall
 ret
    115c:	8082                	ret

000000000000115e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    115e:	4891                	li	a7,4
 ecall
    1160:	00000073          	ecall
 ret
    1164:	8082                	ret

0000000000001166 <read>:
.global read
read:
 li a7, SYS_read
    1166:	4895                	li	a7,5
 ecall
    1168:	00000073          	ecall
 ret
    116c:	8082                	ret

000000000000116e <write>:
.global write
write:
 li a7, SYS_write
    116e:	48c1                	li	a7,16
 ecall
    1170:	00000073          	ecall
 ret
    1174:	8082                	ret

0000000000001176 <close>:
.global close
close:
 li a7, SYS_close
    1176:	48d5                	li	a7,21
 ecall
    1178:	00000073          	ecall
 ret
    117c:	8082                	ret

000000000000117e <kill>:
.global kill
kill:
 li a7, SYS_kill
    117e:	4899                	li	a7,6
 ecall
    1180:	00000073          	ecall
 ret
    1184:	8082                	ret

0000000000001186 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1186:	489d                	li	a7,7
 ecall
    1188:	00000073          	ecall
 ret
    118c:	8082                	ret

000000000000118e <open>:
.global open
open:
 li a7, SYS_open
    118e:	48bd                	li	a7,15
 ecall
    1190:	00000073          	ecall
 ret
    1194:	8082                	ret

0000000000001196 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1196:	48c5                	li	a7,17
 ecall
    1198:	00000073          	ecall
 ret
    119c:	8082                	ret

000000000000119e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    119e:	48c9                	li	a7,18
 ecall
    11a0:	00000073          	ecall
 ret
    11a4:	8082                	ret

00000000000011a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    11a6:	48a1                	li	a7,8
 ecall
    11a8:	00000073          	ecall
 ret
    11ac:	8082                	ret

00000000000011ae <link>:
.global link
link:
 li a7, SYS_link
    11ae:	48cd                	li	a7,19
 ecall
    11b0:	00000073          	ecall
 ret
    11b4:	8082                	ret

00000000000011b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    11b6:	48d1                	li	a7,20
 ecall
    11b8:	00000073          	ecall
 ret
    11bc:	8082                	ret

00000000000011be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    11be:	48a5                	li	a7,9
 ecall
    11c0:	00000073          	ecall
 ret
    11c4:	8082                	ret

00000000000011c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
    11c6:	48a9                	li	a7,10
 ecall
    11c8:	00000073          	ecall
 ret
    11cc:	8082                	ret

00000000000011ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    11ce:	48ad                	li	a7,11
 ecall
    11d0:	00000073          	ecall
 ret
    11d4:	8082                	ret

00000000000011d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    11d6:	48b1                	li	a7,12
 ecall
    11d8:	00000073          	ecall
 ret
    11dc:	8082                	ret

00000000000011de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    11de:	48b5                	li	a7,13
 ecall
    11e0:	00000073          	ecall
 ret
    11e4:	8082                	ret

00000000000011e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    11e6:	48b9                	li	a7,14
 ecall
    11e8:	00000073          	ecall
 ret
    11ec:	8082                	ret

00000000000011ee <head>:
.global head
head:
 li a7, SYS_head
    11ee:	48d9                	li	a7,22
 ecall
    11f0:	00000073          	ecall
 ret
    11f4:	8082                	ret

00000000000011f6 <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
    11f6:	48dd                	li	a7,23
 ecall
    11f8:	00000073          	ecall
 ret
    11fc:	8082                	ret

00000000000011fe <ps>:
.global ps
ps:
 li a7, SYS_ps
    11fe:	48e1                	li	a7,24
 ecall
    1200:	00000073          	ecall
 ret
    1204:	8082                	ret

0000000000001206 <times>:
.global times
times:
 li a7, SYS_times
    1206:	48e5                	li	a7,25
 ecall
    1208:	00000073          	ecall
 ret
    120c:	8082                	ret

000000000000120e <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
    120e:	48e9                	li	a7,26
 ecall
    1210:	00000073          	ecall
 ret
    1214:	8082                	ret

0000000000001216 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1216:	1101                	addi	sp,sp,-32
    1218:	ec06                	sd	ra,24(sp)
    121a:	e822                	sd	s0,16(sp)
    121c:	1000                	addi	s0,sp,32
    121e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1222:	4605                	li	a2,1
    1224:	fef40593          	addi	a1,s0,-17
    1228:	00000097          	auipc	ra,0x0
    122c:	f46080e7          	jalr	-186(ra) # 116e <write>
}
    1230:	60e2                	ld	ra,24(sp)
    1232:	6442                	ld	s0,16(sp)
    1234:	6105                	addi	sp,sp,32
    1236:	8082                	ret

0000000000001238 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1238:	7139                	addi	sp,sp,-64
    123a:	fc06                	sd	ra,56(sp)
    123c:	f822                	sd	s0,48(sp)
    123e:	f426                	sd	s1,40(sp)
    1240:	f04a                	sd	s2,32(sp)
    1242:	ec4e                	sd	s3,24(sp)
    1244:	0080                	addi	s0,sp,64
    1246:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1248:	c299                	beqz	a3,124e <printint+0x16>
    124a:	0805c963          	bltz	a1,12dc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    124e:	2581                	sext.w	a1,a1
  neg = 0;
    1250:	4881                	li	a7,0
    1252:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1256:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1258:	2601                	sext.w	a2,a2
    125a:	00001517          	auipc	a0,0x1
    125e:	b5650513          	addi	a0,a0,-1194 # 1db0 <digits>
    1262:	883a                	mv	a6,a4
    1264:	2705                	addiw	a4,a4,1
    1266:	02c5f7bb          	remuw	a5,a1,a2
    126a:	1782                	slli	a5,a5,0x20
    126c:	9381                	srli	a5,a5,0x20
    126e:	97aa                	add	a5,a5,a0
    1270:	0007c783          	lbu	a5,0(a5)
    1274:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1278:	0005879b          	sext.w	a5,a1
    127c:	02c5d5bb          	divuw	a1,a1,a2
    1280:	0685                	addi	a3,a3,1
    1282:	fec7f0e3          	bgeu	a5,a2,1262 <printint+0x2a>
  if(neg)
    1286:	00088c63          	beqz	a7,129e <printint+0x66>
    buf[i++] = '-';
    128a:	fd070793          	addi	a5,a4,-48
    128e:	00878733          	add	a4,a5,s0
    1292:	02d00793          	li	a5,45
    1296:	fef70823          	sb	a5,-16(a4)
    129a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    129e:	02e05863          	blez	a4,12ce <printint+0x96>
    12a2:	fc040793          	addi	a5,s0,-64
    12a6:	00e78933          	add	s2,a5,a4
    12aa:	fff78993          	addi	s3,a5,-1
    12ae:	99ba                	add	s3,s3,a4
    12b0:	377d                	addiw	a4,a4,-1
    12b2:	1702                	slli	a4,a4,0x20
    12b4:	9301                	srli	a4,a4,0x20
    12b6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    12ba:	fff94583          	lbu	a1,-1(s2)
    12be:	8526                	mv	a0,s1
    12c0:	00000097          	auipc	ra,0x0
    12c4:	f56080e7          	jalr	-170(ra) # 1216 <putc>
  while(--i >= 0)
    12c8:	197d                	addi	s2,s2,-1
    12ca:	ff3918e3          	bne	s2,s3,12ba <printint+0x82>
}
    12ce:	70e2                	ld	ra,56(sp)
    12d0:	7442                	ld	s0,48(sp)
    12d2:	74a2                	ld	s1,40(sp)
    12d4:	7902                	ld	s2,32(sp)
    12d6:	69e2                	ld	s3,24(sp)
    12d8:	6121                	addi	sp,sp,64
    12da:	8082                	ret
    x = -xx;
    12dc:	40b005bb          	negw	a1,a1
    neg = 1;
    12e0:	4885                	li	a7,1
    x = -xx;
    12e2:	bf85                	j	1252 <printint+0x1a>

00000000000012e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    12e4:	7119                	addi	sp,sp,-128
    12e6:	fc86                	sd	ra,120(sp)
    12e8:	f8a2                	sd	s0,112(sp)
    12ea:	f4a6                	sd	s1,104(sp)
    12ec:	f0ca                	sd	s2,96(sp)
    12ee:	ecce                	sd	s3,88(sp)
    12f0:	e8d2                	sd	s4,80(sp)
    12f2:	e4d6                	sd	s5,72(sp)
    12f4:	e0da                	sd	s6,64(sp)
    12f6:	fc5e                	sd	s7,56(sp)
    12f8:	f862                	sd	s8,48(sp)
    12fa:	f466                	sd	s9,40(sp)
    12fc:	f06a                	sd	s10,32(sp)
    12fe:	ec6e                	sd	s11,24(sp)
    1300:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1302:	0005c903          	lbu	s2,0(a1)
    1306:	18090f63          	beqz	s2,14a4 <vprintf+0x1c0>
    130a:	8aaa                	mv	s5,a0
    130c:	8b32                	mv	s6,a2
    130e:	00158493          	addi	s1,a1,1
  state = 0;
    1312:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1314:	02500a13          	li	s4,37
    1318:	4c55                	li	s8,21
    131a:	00001c97          	auipc	s9,0x1
    131e:	a3ec8c93          	addi	s9,s9,-1474 # 1d58 <get_time_perf+0x286>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1322:	02800d93          	li	s11,40
  putc(fd, 'x');
    1326:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1328:	00001b97          	auipc	s7,0x1
    132c:	a88b8b93          	addi	s7,s7,-1400 # 1db0 <digits>
    1330:	a839                	j	134e <vprintf+0x6a>
        putc(fd, c);
    1332:	85ca                	mv	a1,s2
    1334:	8556                	mv	a0,s5
    1336:	00000097          	auipc	ra,0x0
    133a:	ee0080e7          	jalr	-288(ra) # 1216 <putc>
    133e:	a019                	j	1344 <vprintf+0x60>
    } else if(state == '%'){
    1340:	01498d63          	beq	s3,s4,135a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    1344:	0485                	addi	s1,s1,1
    1346:	fff4c903          	lbu	s2,-1(s1)
    134a:	14090d63          	beqz	s2,14a4 <vprintf+0x1c0>
    if(state == 0){
    134e:	fe0999e3          	bnez	s3,1340 <vprintf+0x5c>
      if(c == '%'){
    1352:	ff4910e3          	bne	s2,s4,1332 <vprintf+0x4e>
        state = '%';
    1356:	89d2                	mv	s3,s4
    1358:	b7f5                	j	1344 <vprintf+0x60>
      if(c == 'd'){
    135a:	11490c63          	beq	s2,s4,1472 <vprintf+0x18e>
    135e:	f9d9079b          	addiw	a5,s2,-99
    1362:	0ff7f793          	zext.b	a5,a5
    1366:	10fc6e63          	bltu	s8,a5,1482 <vprintf+0x19e>
    136a:	f9d9079b          	addiw	a5,s2,-99
    136e:	0ff7f713          	zext.b	a4,a5
    1372:	10ec6863          	bltu	s8,a4,1482 <vprintf+0x19e>
    1376:	00271793          	slli	a5,a4,0x2
    137a:	97e6                	add	a5,a5,s9
    137c:	439c                	lw	a5,0(a5)
    137e:	97e6                	add	a5,a5,s9
    1380:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1382:	008b0913          	addi	s2,s6,8
    1386:	4685                	li	a3,1
    1388:	4629                	li	a2,10
    138a:	000b2583          	lw	a1,0(s6)
    138e:	8556                	mv	a0,s5
    1390:	00000097          	auipc	ra,0x0
    1394:	ea8080e7          	jalr	-344(ra) # 1238 <printint>
    1398:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    139a:	4981                	li	s3,0
    139c:	b765                	j	1344 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    139e:	008b0913          	addi	s2,s6,8
    13a2:	4681                	li	a3,0
    13a4:	4629                	li	a2,10
    13a6:	000b2583          	lw	a1,0(s6)
    13aa:	8556                	mv	a0,s5
    13ac:	00000097          	auipc	ra,0x0
    13b0:	e8c080e7          	jalr	-372(ra) # 1238 <printint>
    13b4:	8b4a                	mv	s6,s2
      state = 0;
    13b6:	4981                	li	s3,0
    13b8:	b771                	j	1344 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    13ba:	008b0913          	addi	s2,s6,8
    13be:	4681                	li	a3,0
    13c0:	866a                	mv	a2,s10
    13c2:	000b2583          	lw	a1,0(s6)
    13c6:	8556                	mv	a0,s5
    13c8:	00000097          	auipc	ra,0x0
    13cc:	e70080e7          	jalr	-400(ra) # 1238 <printint>
    13d0:	8b4a                	mv	s6,s2
      state = 0;
    13d2:	4981                	li	s3,0
    13d4:	bf85                	j	1344 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    13d6:	008b0793          	addi	a5,s6,8
    13da:	f8f43423          	sd	a5,-120(s0)
    13de:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    13e2:	03000593          	li	a1,48
    13e6:	8556                	mv	a0,s5
    13e8:	00000097          	auipc	ra,0x0
    13ec:	e2e080e7          	jalr	-466(ra) # 1216 <putc>
  putc(fd, 'x');
    13f0:	07800593          	li	a1,120
    13f4:	8556                	mv	a0,s5
    13f6:	00000097          	auipc	ra,0x0
    13fa:	e20080e7          	jalr	-480(ra) # 1216 <putc>
    13fe:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1400:	03c9d793          	srli	a5,s3,0x3c
    1404:	97de                	add	a5,a5,s7
    1406:	0007c583          	lbu	a1,0(a5)
    140a:	8556                	mv	a0,s5
    140c:	00000097          	auipc	ra,0x0
    1410:	e0a080e7          	jalr	-502(ra) # 1216 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1414:	0992                	slli	s3,s3,0x4
    1416:	397d                	addiw	s2,s2,-1
    1418:	fe0914e3          	bnez	s2,1400 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    141c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1420:	4981                	li	s3,0
    1422:	b70d                	j	1344 <vprintf+0x60>
        s = va_arg(ap, char*);
    1424:	008b0913          	addi	s2,s6,8
    1428:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    142c:	02098163          	beqz	s3,144e <vprintf+0x16a>
        while(*s != 0){
    1430:	0009c583          	lbu	a1,0(s3)
    1434:	c5ad                	beqz	a1,149e <vprintf+0x1ba>
          putc(fd, *s);
    1436:	8556                	mv	a0,s5
    1438:	00000097          	auipc	ra,0x0
    143c:	dde080e7          	jalr	-546(ra) # 1216 <putc>
          s++;
    1440:	0985                	addi	s3,s3,1
        while(*s != 0){
    1442:	0009c583          	lbu	a1,0(s3)
    1446:	f9e5                	bnez	a1,1436 <vprintf+0x152>
        s = va_arg(ap, char*);
    1448:	8b4a                	mv	s6,s2
      state = 0;
    144a:	4981                	li	s3,0
    144c:	bde5                	j	1344 <vprintf+0x60>
          s = "(null)";
    144e:	00001997          	auipc	s3,0x1
    1452:	90298993          	addi	s3,s3,-1790 # 1d50 <get_time_perf+0x27e>
        while(*s != 0){
    1456:	85ee                	mv	a1,s11
    1458:	bff9                	j	1436 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    145a:	008b0913          	addi	s2,s6,8
    145e:	000b4583          	lbu	a1,0(s6)
    1462:	8556                	mv	a0,s5
    1464:	00000097          	auipc	ra,0x0
    1468:	db2080e7          	jalr	-590(ra) # 1216 <putc>
    146c:	8b4a                	mv	s6,s2
      state = 0;
    146e:	4981                	li	s3,0
    1470:	bdd1                	j	1344 <vprintf+0x60>
        putc(fd, c);
    1472:	85d2                	mv	a1,s4
    1474:	8556                	mv	a0,s5
    1476:	00000097          	auipc	ra,0x0
    147a:	da0080e7          	jalr	-608(ra) # 1216 <putc>
      state = 0;
    147e:	4981                	li	s3,0
    1480:	b5d1                	j	1344 <vprintf+0x60>
        putc(fd, '%');
    1482:	85d2                	mv	a1,s4
    1484:	8556                	mv	a0,s5
    1486:	00000097          	auipc	ra,0x0
    148a:	d90080e7          	jalr	-624(ra) # 1216 <putc>
        putc(fd, c);
    148e:	85ca                	mv	a1,s2
    1490:	8556                	mv	a0,s5
    1492:	00000097          	auipc	ra,0x0
    1496:	d84080e7          	jalr	-636(ra) # 1216 <putc>
      state = 0;
    149a:	4981                	li	s3,0
    149c:	b565                	j	1344 <vprintf+0x60>
        s = va_arg(ap, char*);
    149e:	8b4a                	mv	s6,s2
      state = 0;
    14a0:	4981                	li	s3,0
    14a2:	b54d                	j	1344 <vprintf+0x60>
    }
  }
}
    14a4:	70e6                	ld	ra,120(sp)
    14a6:	7446                	ld	s0,112(sp)
    14a8:	74a6                	ld	s1,104(sp)
    14aa:	7906                	ld	s2,96(sp)
    14ac:	69e6                	ld	s3,88(sp)
    14ae:	6a46                	ld	s4,80(sp)
    14b0:	6aa6                	ld	s5,72(sp)
    14b2:	6b06                	ld	s6,64(sp)
    14b4:	7be2                	ld	s7,56(sp)
    14b6:	7c42                	ld	s8,48(sp)
    14b8:	7ca2                	ld	s9,40(sp)
    14ba:	7d02                	ld	s10,32(sp)
    14bc:	6de2                	ld	s11,24(sp)
    14be:	6109                	addi	sp,sp,128
    14c0:	8082                	ret

00000000000014c2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    14c2:	715d                	addi	sp,sp,-80
    14c4:	ec06                	sd	ra,24(sp)
    14c6:	e822                	sd	s0,16(sp)
    14c8:	1000                	addi	s0,sp,32
    14ca:	e010                	sd	a2,0(s0)
    14cc:	e414                	sd	a3,8(s0)
    14ce:	e818                	sd	a4,16(s0)
    14d0:	ec1c                	sd	a5,24(s0)
    14d2:	03043023          	sd	a6,32(s0)
    14d6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    14da:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    14de:	8622                	mv	a2,s0
    14e0:	00000097          	auipc	ra,0x0
    14e4:	e04080e7          	jalr	-508(ra) # 12e4 <vprintf>
}
    14e8:	60e2                	ld	ra,24(sp)
    14ea:	6442                	ld	s0,16(sp)
    14ec:	6161                	addi	sp,sp,80
    14ee:	8082                	ret

00000000000014f0 <printf>:

void
printf(const char *fmt, ...)
{
    14f0:	711d                	addi	sp,sp,-96
    14f2:	ec06                	sd	ra,24(sp)
    14f4:	e822                	sd	s0,16(sp)
    14f6:	1000                	addi	s0,sp,32
    14f8:	e40c                	sd	a1,8(s0)
    14fa:	e810                	sd	a2,16(s0)
    14fc:	ec14                	sd	a3,24(s0)
    14fe:	f018                	sd	a4,32(s0)
    1500:	f41c                	sd	a5,40(s0)
    1502:	03043823          	sd	a6,48(s0)
    1506:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    150a:	00840613          	addi	a2,s0,8
    150e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1512:	85aa                	mv	a1,a0
    1514:	4505                	li	a0,1
    1516:	00000097          	auipc	ra,0x0
    151a:	dce080e7          	jalr	-562(ra) # 12e4 <vprintf>
}
    151e:	60e2                	ld	ra,24(sp)
    1520:	6442                	ld	s0,16(sp)
    1522:	6125                	addi	sp,sp,96
    1524:	8082                	ret

0000000000001526 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1526:	1141                	addi	sp,sp,-16
    1528:	e422                	sd	s0,8(sp)
    152a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    152c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1530:	00001797          	auipc	a5,0x1
    1534:	ae07b783          	ld	a5,-1312(a5) # 2010 <freep>
    1538:	a02d                	j	1562 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    153a:	4618                	lw	a4,8(a2)
    153c:	9f2d                	addw	a4,a4,a1
    153e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1542:	6398                	ld	a4,0(a5)
    1544:	6310                	ld	a2,0(a4)
    1546:	a83d                	j	1584 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1548:	ff852703          	lw	a4,-8(a0)
    154c:	9f31                	addw	a4,a4,a2
    154e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1550:	ff053683          	ld	a3,-16(a0)
    1554:	a091                	j	1598 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1556:	6398                	ld	a4,0(a5)
    1558:	00e7e463          	bltu	a5,a4,1560 <free+0x3a>
    155c:	00e6ea63          	bltu	a3,a4,1570 <free+0x4a>
{
    1560:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1562:	fed7fae3          	bgeu	a5,a3,1556 <free+0x30>
    1566:	6398                	ld	a4,0(a5)
    1568:	00e6e463          	bltu	a3,a4,1570 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    156c:	fee7eae3          	bltu	a5,a4,1560 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1570:	ff852583          	lw	a1,-8(a0)
    1574:	6390                	ld	a2,0(a5)
    1576:	02059813          	slli	a6,a1,0x20
    157a:	01c85713          	srli	a4,a6,0x1c
    157e:	9736                	add	a4,a4,a3
    1580:	fae60de3          	beq	a2,a4,153a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1584:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1588:	4790                	lw	a2,8(a5)
    158a:	02061593          	slli	a1,a2,0x20
    158e:	01c5d713          	srli	a4,a1,0x1c
    1592:	973e                	add	a4,a4,a5
    1594:	fae68ae3          	beq	a3,a4,1548 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1598:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    159a:	00001717          	auipc	a4,0x1
    159e:	a6f73b23          	sd	a5,-1418(a4) # 2010 <freep>
}
    15a2:	6422                	ld	s0,8(sp)
    15a4:	0141                	addi	sp,sp,16
    15a6:	8082                	ret

00000000000015a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    15a8:	7139                	addi	sp,sp,-64
    15aa:	fc06                	sd	ra,56(sp)
    15ac:	f822                	sd	s0,48(sp)
    15ae:	f426                	sd	s1,40(sp)
    15b0:	f04a                	sd	s2,32(sp)
    15b2:	ec4e                	sd	s3,24(sp)
    15b4:	e852                	sd	s4,16(sp)
    15b6:	e456                	sd	s5,8(sp)
    15b8:	e05a                	sd	s6,0(sp)
    15ba:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    15bc:	02051493          	slli	s1,a0,0x20
    15c0:	9081                	srli	s1,s1,0x20
    15c2:	04bd                	addi	s1,s1,15
    15c4:	8091                	srli	s1,s1,0x4
    15c6:	0014899b          	addiw	s3,s1,1
    15ca:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    15cc:	00001517          	auipc	a0,0x1
    15d0:	a4453503          	ld	a0,-1468(a0) # 2010 <freep>
    15d4:	c515                	beqz	a0,1600 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    15d8:	4798                	lw	a4,8(a5)
    15da:	02977f63          	bgeu	a4,s1,1618 <malloc+0x70>
    15de:	8a4e                	mv	s4,s3
    15e0:	0009871b          	sext.w	a4,s3
    15e4:	6685                	lui	a3,0x1
    15e6:	00d77363          	bgeu	a4,a3,15ec <malloc+0x44>
    15ea:	6a05                	lui	s4,0x1
    15ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    15f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    15f4:	00001917          	auipc	s2,0x1
    15f8:	a1c90913          	addi	s2,s2,-1508 # 2010 <freep>
  if(p == (char*)-1)
    15fc:	5afd                	li	s5,-1
    15fe:	a895                	j	1672 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    1600:	00001797          	auipc	a5,0x1
    1604:	a8878793          	addi	a5,a5,-1400 # 2088 <base>
    1608:	00001717          	auipc	a4,0x1
    160c:	a0f73423          	sd	a5,-1528(a4) # 2010 <freep>
    1610:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1612:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1616:	b7e1                	j	15de <malloc+0x36>
      if(p->s.size == nunits)
    1618:	02e48c63          	beq	s1,a4,1650 <malloc+0xa8>
        p->s.size -= nunits;
    161c:	4137073b          	subw	a4,a4,s3
    1620:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1622:	02071693          	slli	a3,a4,0x20
    1626:	01c6d713          	srli	a4,a3,0x1c
    162a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    162c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1630:	00001717          	auipc	a4,0x1
    1634:	9ea73023          	sd	a0,-1568(a4) # 2010 <freep>
      return (void*)(p + 1);
    1638:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    163c:	70e2                	ld	ra,56(sp)
    163e:	7442                	ld	s0,48(sp)
    1640:	74a2                	ld	s1,40(sp)
    1642:	7902                	ld	s2,32(sp)
    1644:	69e2                	ld	s3,24(sp)
    1646:	6a42                	ld	s4,16(sp)
    1648:	6aa2                	ld	s5,8(sp)
    164a:	6b02                	ld	s6,0(sp)
    164c:	6121                	addi	sp,sp,64
    164e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1650:	6398                	ld	a4,0(a5)
    1652:	e118                	sd	a4,0(a0)
    1654:	bff1                	j	1630 <malloc+0x88>
  hp->s.size = nu;
    1656:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    165a:	0541                	addi	a0,a0,16
    165c:	00000097          	auipc	ra,0x0
    1660:	eca080e7          	jalr	-310(ra) # 1526 <free>
  return freep;
    1664:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1668:	d971                	beqz	a0,163c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    166a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    166c:	4798                	lw	a4,8(a5)
    166e:	fa9775e3          	bgeu	a4,s1,1618 <malloc+0x70>
    if(p == freep)
    1672:	00093703          	ld	a4,0(s2)
    1676:	853e                	mv	a0,a5
    1678:	fef719e3          	bne	a4,a5,166a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    167c:	8552                	mv	a0,s4
    167e:	00000097          	auipc	ra,0x0
    1682:	b58080e7          	jalr	-1192(ra) # 11d6 <sbrk>
  if(p == (char*)-1)
    1686:	fd5518e3          	bne	a0,s5,1656 <malloc+0xae>
        return 0;
    168a:	4501                	li	a0,0
    168c:	bf45                	j	163c <malloc+0x94>

000000000000168e <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
    168e:	c1d9                	beqz	a1,1714 <head_run+0x86>
void head_run(int fd, int numOfLines){
    1690:	dd010113          	addi	sp,sp,-560
    1694:	22113423          	sd	ra,552(sp)
    1698:	22813023          	sd	s0,544(sp)
    169c:	20913c23          	sd	s1,536(sp)
    16a0:	21213823          	sd	s2,528(sp)
    16a4:	21313423          	sd	s3,520(sp)
    16a8:	21413023          	sd	s4,512(sp)
    16ac:	1c00                	addi	s0,sp,560
    16ae:	892a                	mv	s2,a0
    16b0:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
    16b4:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
    16b6:	00000a17          	auipc	s4,0x0
    16ba:	73aa0a13          	addi	s4,s4,1850 # 1df0 <digits+0x40>
		readStatus = read_line(fd, line);
    16be:	dd840593          	addi	a1,s0,-552
    16c2:	854a                	mv	a0,s2
    16c4:	00000097          	auipc	ra,0x0
    16c8:	394080e7          	jalr	916(ra) # 1a58 <read_line>
		if (readStatus == READ_ERROR){
    16cc:	01350d63          	beq	a0,s3,16e6 <head_run+0x58>
		if (readStatus == READ_EOF)
    16d0:	c11d                	beqz	a0,16f6 <head_run+0x68>
		printf("%s",line);
    16d2:	dd840593          	addi	a1,s0,-552
    16d6:	8552                	mv	a0,s4
    16d8:	00000097          	auipc	ra,0x0
    16dc:	e18080e7          	jalr	-488(ra) # 14f0 <printf>
	while(numOfLines--){
    16e0:	34fd                	addiw	s1,s1,-1
    16e2:	fcf1                	bnez	s1,16be <head_run+0x30>
    16e4:	a809                	j	16f6 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
    16e6:	00000517          	auipc	a0,0x0
    16ea:	6e250513          	addi	a0,a0,1762 # 1dc8 <digits+0x18>
    16ee:	00000097          	auipc	ra,0x0
    16f2:	e02080e7          	jalr	-510(ra) # 14f0 <printf>

	}
}
    16f6:	22813083          	ld	ra,552(sp)
    16fa:	22013403          	ld	s0,544(sp)
    16fe:	21813483          	ld	s1,536(sp)
    1702:	21013903          	ld	s2,528(sp)
    1706:	20813983          	ld	s3,520(sp)
    170a:	20013a03          	ld	s4,512(sp)
    170e:	23010113          	addi	sp,sp,560
    1712:	8082                	ret
    1714:	8082                	ret

0000000000001716 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
    1716:	ba010113          	addi	sp,sp,-1120
    171a:	44113c23          	sd	ra,1112(sp)
    171e:	44813823          	sd	s0,1104(sp)
    1722:	44913423          	sd	s1,1096(sp)
    1726:	45213023          	sd	s2,1088(sp)
    172a:	43313c23          	sd	s3,1080(sp)
    172e:	43413823          	sd	s4,1072(sp)
    1732:	43513423          	sd	s5,1064(sp)
    1736:	43613023          	sd	s6,1056(sp)
    173a:	41713c23          	sd	s7,1048(sp)
    173e:	41813823          	sd	s8,1040(sp)
    1742:	41913423          	sd	s9,1032(sp)
    1746:	41a13023          	sd	s10,1024(sp)
    174a:	3fb13c23          	sd	s11,1016(sp)
    174e:	46010413          	addi	s0,sp,1120
    1752:	89aa                	mv	s3,a0
    1754:	8aae                	mv	s5,a1
    1756:	8c32                	mv	s8,a2
    1758:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
    175a:	d9840593          	addi	a1,s0,-616
    175e:	00000097          	auipc	ra,0x0
    1762:	2fa080e7          	jalr	762(ra) # 1a58 <read_line>


  if (readStatus == READ_ERROR)
    1766:	57fd                	li	a5,-1
    1768:	04f50163          	beq	a0,a5,17aa <uniq_run+0x94>
    176c:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
    176e:	ed21                	bnez	a0,17c6 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
    1770:	45813083          	ld	ra,1112(sp)
    1774:	45013403          	ld	s0,1104(sp)
    1778:	44813483          	ld	s1,1096(sp)
    177c:	44013903          	ld	s2,1088(sp)
    1780:	43813983          	ld	s3,1080(sp)
    1784:	43013a03          	ld	s4,1072(sp)
    1788:	42813a83          	ld	s5,1064(sp)
    178c:	42013b03          	ld	s6,1056(sp)
    1790:	41813b83          	ld	s7,1048(sp)
    1794:	41013c03          	ld	s8,1040(sp)
    1798:	40813c83          	ld	s9,1032(sp)
    179c:	40013d03          	ld	s10,1024(sp)
    17a0:	3f813d83          	ld	s11,1016(sp)
    17a4:	46010113          	addi	sp,sp,1120
    17a8:	8082                	ret
    printf("[ERR] Error reading from the file ");
    17aa:	00000517          	auipc	a0,0x0
    17ae:	64e50513          	addi	a0,a0,1614 # 1df8 <digits+0x48>
    17b2:	00000097          	auipc	ra,0x0
    17b6:	d3e080e7          	jalr	-706(ra) # 14f0 <printf>
    17ba:	bf5d                	j	1770 <uniq_run+0x5a>
    17bc:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    17be:	8926                	mv	s2,s1
    17c0:	84be                	mv	s1,a5
        lineCount = 1;
    17c2:	8b6a                	mv	s6,s10
    17c4:	a8ed                	j	18be <uniq_run+0x1a8>
    int lineCount=1;
    17c6:	4b05                	li	s6,1
  char * line2 = buffer2;
    17c8:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
    17cc:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
    17d0:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
    17d2:	4d05                	li	s10,1
              printf("%s",line1);
    17d4:	00000d97          	auipc	s11,0x0
    17d8:	61cd8d93          	addi	s11,s11,1564 # 1df0 <digits+0x40>
    17dc:	a0cd                	j	18be <uniq_run+0x1a8>
            if (repeatedLines){
    17de:	020a0b63          	beqz	s4,1814 <uniq_run+0xfe>
                if (isRepeated){
    17e2:	f80b87e3          	beqz	s7,1770 <uniq_run+0x5a>
                    if (showCount)
    17e6:	000c0d63          	beqz	s8,1800 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
    17ea:	864a                	mv	a2,s2
    17ec:	85da                	mv	a1,s6
    17ee:	00000517          	auipc	a0,0x0
    17f2:	63250513          	addi	a0,a0,1586 # 1e20 <digits+0x70>
    17f6:	00000097          	auipc	ra,0x0
    17fa:	cfa080e7          	jalr	-774(ra) # 14f0 <printf>
    17fe:	bf8d                	j	1770 <uniq_run+0x5a>
                      printf("%s",line1);
    1800:	85ca                	mv	a1,s2
    1802:	00000517          	auipc	a0,0x0
    1806:	5ee50513          	addi	a0,a0,1518 # 1df0 <digits+0x40>
    180a:	00000097          	auipc	ra,0x0
    180e:	ce6080e7          	jalr	-794(ra) # 14f0 <printf>
    1812:	bfb9                	j	1770 <uniq_run+0x5a>
                if (showCount)
    1814:	000c0d63          	beqz	s8,182e <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
    1818:	864a                	mv	a2,s2
    181a:	85da                	mv	a1,s6
    181c:	00000517          	auipc	a0,0x0
    1820:	60450513          	addi	a0,a0,1540 # 1e20 <digits+0x70>
    1824:	00000097          	auipc	ra,0x0
    1828:	ccc080e7          	jalr	-820(ra) # 14f0 <printf>
    182c:	b791                	j	1770 <uniq_run+0x5a>
                  printf("%s",line1);
    182e:	85ca                	mv	a1,s2
    1830:	00000517          	auipc	a0,0x0
    1834:	5c050513          	addi	a0,a0,1472 # 1df0 <digits+0x40>
    1838:	00000097          	auipc	ra,0x0
    183c:	cb8080e7          	jalr	-840(ra) # 14f0 <printf>
    1840:	bf05                	j	1770 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
    1842:	00000517          	auipc	a0,0x0
    1846:	5e650513          	addi	a0,a0,1510 # 1e28 <digits+0x78>
    184a:	00000097          	auipc	ra,0x0
    184e:	ca6080e7          	jalr	-858(ra) # 14f0 <printf>
          break;
    1852:	bf39                	j	1770 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
    1854:	85a6                	mv	a1,s1
    1856:	854a                	mv	a0,s2
    1858:	00000097          	auipc	ra,0x0
    185c:	110080e7          	jalr	272(ra) # 1968 <compare_str_ic>
    1860:	a041                	j	18e0 <uniq_run+0x1ca>
                  printf("%s",line1);
    1862:	85ca                	mv	a1,s2
    1864:	856e                	mv	a0,s11
    1866:	00000097          	auipc	ra,0x0
    186a:	c8a080e7          	jalr	-886(ra) # 14f0 <printf>
        lineCount = 1;
    186e:	8b5e                	mv	s6,s7
                  printf("%s",line1);
    1870:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    1872:	8926                	mv	s2,s1
                  printf("%s",line1);
    1874:	84be                	mv	s1,a5
        isRepeated = 0 ;
    1876:	4b81                	li	s7,0
    1878:	a099                	j	18be <uniq_run+0x1a8>
            if (showCount)
    187a:	020c0263          	beqz	s8,189e <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
    187e:	864a                	mv	a2,s2
    1880:	85da                	mv	a1,s6
    1882:	00000517          	auipc	a0,0x0
    1886:	59e50513          	addi	a0,a0,1438 # 1e20 <digits+0x70>
    188a:	00000097          	auipc	ra,0x0
    188e:	c66080e7          	jalr	-922(ra) # 14f0 <printf>
    1892:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    1894:	8926                	mv	s2,s1
    1896:	84be                	mv	s1,a5
        isRepeated = 0 ;
    1898:	4b81                	li	s7,0
        lineCount = 1;
    189a:	8b6a                	mv	s6,s10
    189c:	a00d                	j	18be <uniq_run+0x1a8>
              printf("%s",line1);
    189e:	85ca                	mv	a1,s2
    18a0:	856e                	mv	a0,s11
    18a2:	00000097          	auipc	ra,0x0
    18a6:	c4e080e7          	jalr	-946(ra) # 14f0 <printf>
    18aa:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    18ac:	8926                	mv	s2,s1
              printf("%s",line1);
    18ae:	84be                	mv	s1,a5
        isRepeated = 0 ;
    18b0:	4b81                	li	s7,0
        lineCount = 1;
    18b2:	8b6a                	mv	s6,s10
    18b4:	a029                	j	18be <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
    18b6:	000a0363          	beqz	s4,18bc <uniq_run+0x1a6>
    18ba:	8bea                	mv	s7,s10
          lineCount++;
    18bc:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
    18be:	85a6                	mv	a1,s1
    18c0:	854e                	mv	a0,s3
    18c2:	00000097          	auipc	ra,0x0
    18c6:	196080e7          	jalr	406(ra) # 1a58 <read_line>
        if (readStatus == READ_EOF){
    18ca:	d911                	beqz	a0,17de <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
    18cc:	f7950be3          	beq	a0,s9,1842 <uniq_run+0x12c>
        if (!ignoreCase)
    18d0:	f80a92e3          	bnez	s5,1854 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
    18d4:	85a6                	mv	a1,s1
    18d6:	854a                	mv	a0,s2
    18d8:	00000097          	auipc	ra,0x0
    18dc:	062080e7          	jalr	98(ra) # 193a <compare_str>
        if (compareStatus != 0){ 
    18e0:	d979                	beqz	a0,18b6 <uniq_run+0x1a0>
          if (repeatedLines){
    18e2:	f80a0ce3          	beqz	s4,187a <uniq_run+0x164>
            if (isRepeated){
    18e6:	ec0b8be3          	beqz	s7,17bc <uniq_run+0xa6>
                if (showCount)
    18ea:	f60c0ce3          	beqz	s8,1862 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
    18ee:	864a                	mv	a2,s2
    18f0:	85da                	mv	a1,s6
    18f2:	00000517          	auipc	a0,0x0
    18f6:	52e50513          	addi	a0,a0,1326 # 1e20 <digits+0x70>
    18fa:	00000097          	auipc	ra,0x0
    18fe:	bf6080e7          	jalr	-1034(ra) # 14f0 <printf>
        lineCount = 1;
    1902:	8b5e                	mv	s6,s7
    1904:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    1906:	8926                	mv	s2,s1
    1908:	84be                	mv	s1,a5
        isRepeated = 0 ;
    190a:	4b81                	li	s7,0
    190c:	bf4d                	j	18be <uniq_run+0x1a8>

000000000000190e <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
    190e:	1141                	addi	sp,sp,-16
    1910:	e422                	sd	s0,8(sp)
    1912:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
    1914:	00054783          	lbu	a5,0(a0)
    1918:	cf99                	beqz	a5,1936 <get_strlen+0x28>
    191a:	00150713          	addi	a4,a0,1
    191e:	87ba                	mv	a5,a4
    1920:	4685                	li	a3,1
    1922:	9e99                	subw	a3,a3,a4
    1924:	00f6853b          	addw	a0,a3,a5
    1928:	0785                	addi	a5,a5,1
    192a:	fff7c703          	lbu	a4,-1(a5)
    192e:	fb7d                	bnez	a4,1924 <get_strlen+0x16>
	return len;
}
    1930:	6422                	ld	s0,8(sp)
    1932:	0141                	addi	sp,sp,16
    1934:	8082                	ret
	int len = 0;
    1936:	4501                	li	a0,0
    1938:	bfe5                	j	1930 <get_strlen+0x22>

000000000000193a <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
    193a:	1141                	addi	sp,sp,-16
    193c:	e422                	sd	s0,8(sp)
    193e:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
    1940:	00054783          	lbu	a5,0(a0)
    1944:	cb91                	beqz	a5,1958 <compare_str+0x1e>
    1946:	0005c703          	lbu	a4,0(a1)
    194a:	c719                	beqz	a4,1958 <compare_str+0x1e>
		if (*s1++ != *s2++)
    194c:	0505                	addi	a0,a0,1
    194e:	0585                	addi	a1,a1,1
    1950:	fee788e3          	beq	a5,a4,1940 <compare_str+0x6>
			return 1;
    1954:	4505                	li	a0,1
    1956:	a031                	j	1962 <compare_str+0x28>
	}
	if (*s1 == *s2)
    1958:	0005c503          	lbu	a0,0(a1)
    195c:	8d1d                	sub	a0,a0,a5
			return 1;
    195e:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    1962:	6422                	ld	s0,8(sp)
    1964:	0141                	addi	sp,sp,16
    1966:	8082                	ret

0000000000001968 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
    1968:	1141                	addi	sp,sp,-16
    196a:	e422                	sd	s0,8(sp)
    196c:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
    196e:	4665                	li	a2,25
	while(*s1 && *s2){
    1970:	a019                	j	1976 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
    1972:	04e79763          	bne	a5,a4,19c0 <compare_str_ic+0x58>
	while(*s1 && *s2){
    1976:	00054783          	lbu	a5,0(a0)
    197a:	cb9d                	beqz	a5,19b0 <compare_str_ic+0x48>
    197c:	0005c703          	lbu	a4,0(a1)
    1980:	cb05                	beqz	a4,19b0 <compare_str_ic+0x48>
		char b1 = *s1++;
    1982:	0505                	addi	a0,a0,1
		char b2 = *s2++;
    1984:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
    1986:	fbf7869b          	addiw	a3,a5,-65
    198a:	0ff6f693          	zext.b	a3,a3
    198e:	00d66663          	bltu	a2,a3,199a <compare_str_ic+0x32>
			b1 += 32;
    1992:	0207879b          	addiw	a5,a5,32
    1996:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
    199a:	fbf7069b          	addiw	a3,a4,-65
    199e:	0ff6f693          	zext.b	a3,a3
    19a2:	fcd668e3          	bltu	a2,a3,1972 <compare_str_ic+0xa>
			b2 += 32;
    19a6:	0207071b          	addiw	a4,a4,32
    19aa:	0ff77713          	zext.b	a4,a4
    19ae:	b7d1                	j	1972 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
    19b0:	0005c503          	lbu	a0,0(a1)
    19b4:	8d1d                	sub	a0,a0,a5
			return 1;
    19b6:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    19ba:	6422                	ld	s0,8(sp)
    19bc:	0141                	addi	sp,sp,16
    19be:	8082                	ret
			return 1;
    19c0:	4505                	li	a0,1
    19c2:	bfe5                	j	19ba <compare_str_ic+0x52>

00000000000019c4 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
    19c4:	7179                	addi	sp,sp,-48
    19c6:	f406                	sd	ra,40(sp)
    19c8:	f022                	sd	s0,32(sp)
    19ca:	ec26                	sd	s1,24(sp)
    19cc:	e84a                	sd	s2,16(sp)
    19ce:	e44e                	sd	s3,8(sp)
    19d0:	1800                	addi	s0,sp,48
    19d2:	89aa                	mv	s3,a0
    19d4:	892e                	mv	s2,a1
    int M = get_strlen(s1);
    19d6:	00000097          	auipc	ra,0x0
    19da:	f38080e7          	jalr	-200(ra) # 190e <get_strlen>
    19de:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
    19e0:	854a                	mv	a0,s2
    19e2:	00000097          	auipc	ra,0x0
    19e6:	f2c080e7          	jalr	-212(ra) # 190e <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
    19ea:	409505bb          	subw	a1,a0,s1
    19ee:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
    19f0:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
    19f2:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
    19f4:	0005da63          	bgez	a1,1a08 <check_substr+0x44>
    19f8:	a81d                	j	1a2e <check_substr+0x6a>
        if (j == M)
    19fa:	02f48a63          	beq	s1,a5,1a2e <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
    19fe:	0885                	addi	a7,a7,1
    1a00:	0008879b          	sext.w	a5,a7
    1a04:	02f5cc63          	blt	a1,a5,1a3c <check_substr+0x78>
    1a08:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
    1a0c:	011906b3          	add	a3,s2,a7
    1a10:	874e                	mv	a4,s3
    1a12:	879a                	mv	a5,t1
    1a14:	fe9053e3          	blez	s1,19fa <check_substr+0x36>
            if (s2[i + j] != s1[j])
    1a18:	0006c803          	lbu	a6,0(a3) # 1000 <gets+0x66>
    1a1c:	00074603          	lbu	a2,0(a4)
    1a20:	fcc81de3          	bne	a6,a2,19fa <check_substr+0x36>
        for (j = 0; j < M; j++)
    1a24:	2785                	addiw	a5,a5,1
    1a26:	0685                	addi	a3,a3,1
    1a28:	0705                	addi	a4,a4,1
    1a2a:	fef497e3          	bne	s1,a5,1a18 <check_substr+0x54>
}
    1a2e:	70a2                	ld	ra,40(sp)
    1a30:	7402                	ld	s0,32(sp)
    1a32:	64e2                	ld	s1,24(sp)
    1a34:	6942                	ld	s2,16(sp)
    1a36:	69a2                	ld	s3,8(sp)
    1a38:	6145                	addi	sp,sp,48
    1a3a:	8082                	ret
    return -1;
    1a3c:	557d                	li	a0,-1
    1a3e:	bfc5                	j	1a2e <check_substr+0x6a>

0000000000001a40 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
    1a40:	1141                	addi	sp,sp,-16
    1a42:	e406                	sd	ra,8(sp)
    1a44:	e022                	sd	s0,0(sp)
    1a46:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
    1a48:	fffff097          	auipc	ra,0xfffff
    1a4c:	746080e7          	jalr	1862(ra) # 118e <open>
	return fd;
}
    1a50:	60a2                	ld	ra,8(sp)
    1a52:	6402                	ld	s0,0(sp)
    1a54:	0141                	addi	sp,sp,16
    1a56:	8082                	ret

0000000000001a58 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
    1a58:	7139                	addi	sp,sp,-64
    1a5a:	fc06                	sd	ra,56(sp)
    1a5c:	f822                	sd	s0,48(sp)
    1a5e:	f426                	sd	s1,40(sp)
    1a60:	f04a                	sd	s2,32(sp)
    1a62:	ec4e                	sd	s3,24(sp)
    1a64:	e852                	sd	s4,16(sp)
    1a66:	0080                	addi	s0,sp,64
    1a68:	89aa                	mv	s3,a0
    1a6a:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
    1a6c:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
    1a6e:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
    1a70:	4605                	li	a2,1
    1a72:	fcf40593          	addi	a1,s0,-49
    1a76:	854e                	mv	a0,s3
    1a78:	fffff097          	auipc	ra,0xfffff
    1a7c:	6ee080e7          	jalr	1774(ra) # 1166 <read>
		if (readStatus == 0){
    1a80:	c505                	beqz	a0,1aa8 <read_line+0x50>
		*buffer++ = readByte;
    1a82:	0485                	addi	s1,s1,1
    1a84:	fcf44783          	lbu	a5,-49(s0)
    1a88:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
    1a8c:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
    1a8e:	ff4791e3          	bne	a5,s4,1a70 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
    1a92:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
    1a96:	854a                	mv	a0,s2
    1a98:	70e2                	ld	ra,56(sp)
    1a9a:	7442                	ld	s0,48(sp)
    1a9c:	74a2                	ld	s1,40(sp)
    1a9e:	7902                	ld	s2,32(sp)
    1aa0:	69e2                	ld	s3,24(sp)
    1aa2:	6a42                	ld	s4,16(sp)
    1aa4:	6121                	addi	sp,sp,64
    1aa6:	8082                	ret
			if (byteCount!=0){
    1aa8:	fe0907e3          	beqz	s2,1a96 <read_line+0x3e>
				*buffer = '\n';
    1aac:	47a9                	li	a5,10
    1aae:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
    1ab2:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
    1ab6:	2905                	addiw	s2,s2,1
    1ab8:	bff9                	j	1a96 <read_line+0x3e>

0000000000001aba <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
    1aba:	1141                	addi	sp,sp,-16
    1abc:	e406                	sd	ra,8(sp)
    1abe:	e022                	sd	s0,0(sp)
    1ac0:	0800                	addi	s0,sp,16
	close(fd);
    1ac2:	fffff097          	auipc	ra,0xfffff
    1ac6:	6b4080e7          	jalr	1716(ra) # 1176 <close>
}
    1aca:	60a2                	ld	ra,8(sp)
    1acc:	6402                	ld	s0,0(sp)
    1ace:	0141                	addi	sp,sp,16
    1ad0:	8082                	ret

0000000000001ad2 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
    1ad2:	7139                	addi	sp,sp,-64
    1ad4:	fc06                	sd	ra,56(sp)
    1ad6:	f822                	sd	s0,48(sp)
    1ad8:	f426                	sd	s1,40(sp)
    1ada:	f04a                	sd	s2,32(sp)
    1adc:	0080                	addi	s0,sp,64
    1ade:	84aa                	mv	s1,a0
    1ae0:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
    1ae2:	fffff097          	auipc	ra,0xfffff
    1ae6:	664080e7          	jalr	1636(ra) # 1146 <fork>
    1aea:	ed19                	bnez	a0,1b08 <get_time_perf+0x36>
		exec(argv[0],argv);
    1aec:	85ca                	mv	a1,s2
    1aee:	00093503          	ld	a0,0(s2)
    1af2:	fffff097          	auipc	ra,0xfffff
    1af6:	694080e7          	jalr	1684(ra) # 1186 <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
    1afa:	8526                	mv	a0,s1
    1afc:	70e2                	ld	ra,56(sp)
    1afe:	7442                	ld	s0,48(sp)
    1b00:	74a2                	ld	s1,40(sp)
    1b02:	7902                	ld	s2,32(sp)
    1b04:	6121                	addi	sp,sp,64
    1b06:	8082                	ret
		times(pid , &time);
    1b08:	fc840593          	addi	a1,s0,-56
    1b0c:	fffff097          	auipc	ra,0xfffff
    1b10:	6fa080e7          	jalr	1786(ra) # 1206 <times>
		return time;
    1b14:	fc843783          	ld	a5,-56(s0)
    1b18:	e09c                	sd	a5,0(s1)
    1b1a:	fd043783          	ld	a5,-48(s0)
    1b1e:	e49c                	sd	a5,8(s1)
    1b20:	fd843783          	ld	a5,-40(s0)
    1b24:	e89c                	sd	a5,16(s1)
    1b26:	bfd1                	j	1afa <get_time_perf+0x28>
