
user/_schedtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <parse_cmd>:

	return 0;
}


int parse_cmd(char ** cmd, char * schedAlgo, char ** commands, int * priority, int * nextCmd){
       0:	7135                	addi	sp,sp,-160
       2:	ed06                	sd	ra,152(sp)
       4:	e922                	sd	s0,144(sp)
       6:	e526                	sd	s1,136(sp)
       8:	e14a                	sd	s2,128(sp)
       a:	fcce                	sd	s3,120(sp)
       c:	f8d2                	sd	s4,112(sp)
       e:	f4d6                	sd	s5,104(sp)
      10:	f0da                	sd	s6,96(sp)
      12:	ecde                	sd	s7,88(sp)
      14:	e8e2                	sd	s8,80(sp)
      16:	e4e6                	sd	s9,72(sp)
      18:	e0ea                	sd	s10,64(sp)
      1a:	fc6e                	sd	s11,56(sp)
      1c:	1100                	addi	s0,sp,160
      1e:	f8c43423          	sd	a2,-120(s0)
      22:	f6d43c23          	sd	a3,-136(s0)
      26:	f6e43823          	sd	a4,-144(s0)

	cmd++;  // Skipping the program's name
      2a:	00850913          	addi	s2,a0,8
	int priorityIdx = 0;
	int commandsIdx = 0;
	int nextCmdIdx = 0;
	int cmdCount=0;

	while(*cmd){
      2e:	6508                	ld	a0,8(a0)
      30:	1e050c63          	beqz	a0,228 <parse_cmd+0x228>
      34:	8a2e                	mv	s4,a1
	int cmdCount=0;
      36:	4d81                	li	s11,0
	int nextCmdIdx = 0;
      38:	4c81                	li	s9,0
	int commandsIdx = 0;
      3a:	4a81                	li	s5,0
	int priorityIdx = 0;
      3c:	f8043023          	sd	zero,-128(s0)
		if (!compare_str(cmd[0], "-fcfs"))
      40:	00001997          	auipc	s3,0x1
      44:	28098993          	addi	s3,s3,640 # 12c0 <get_time_perf+0x5e>
			*schedAlgo = SCH_FCFS;
		
		else if (!compare_str(cmd[0], "-ps"))
      48:	00001b17          	auipc	s6,0x1
      4c:	280b0b13          	addi	s6,s6,640 # 12c8 <get_time_perf+0x66>
			*schedAlgo = SCH_PS;		
		
		else if (!compare_str(cmd[0], "-p")){
      50:	00001b97          	auipc	s7,0x1
      54:	280b8b93          	addi	s7,s7,640 # 12d0 <get_time_perf+0x6e>
			commands[commandsIdx++]=0;

			cmdCount++;
		}
		
		else if (!compare_str(cmd[0], "-c")){
      58:	00001c17          	auipc	s8,0x1
      5c:	280c0c13          	addi	s8,s8,640 # 12d8 <get_time_perf+0x76>
			*schedAlgo = SCH_PS;		
      60:	4d05                	li	s10,1
      62:	a821                	j	7a <parse_cmd+0x7a>
			*schedAlgo = SCH_FCFS;
      64:	000a0023          	sb	zero,0(s4)
      68:	84ca                	mv	s1,s2
			if (*cmd) // for handling - if sth exists
				cmd--;
			commands[commandsIdx++]=0;
			cmdCount++;
		}
		if (!*cmd)
      6a:	609c                	ld	a5,0(s1)
      6c:	1a078f63          	beqz	a5,22a <parse_cmd+0x22a>
			break;	
		cmd++;
      70:	00848913          	addi	s2,s1,8
	while(*cmd){
      74:	6488                	ld	a0,8(s1)
      76:	1a050a63          	beqz	a0,22a <parse_cmd+0x22a>
		if (!compare_str(cmd[0], "-fcfs"))
      7a:	85ce                	mv	a1,s3
      7c:	00001097          	auipc	ra,0x1
      80:	04e080e7          	jalr	78(ra) # 10ca <compare_str>
      84:	d165                	beqz	a0,64 <parse_cmd+0x64>
		else if (!compare_str(cmd[0], "-ps"))
      86:	85da                	mv	a1,s6
      88:	00093503          	ld	a0,0(s2)
      8c:	00001097          	auipc	ra,0x1
      90:	03e080e7          	jalr	62(ra) # 10ca <compare_str>
      94:	e509                	bnez	a0,9e <parse_cmd+0x9e>
			*schedAlgo = SCH_PS;		
      96:	01aa0023          	sb	s10,0(s4)
      9a:	84ca                	mv	s1,s2
      9c:	b7f9                	j	6a <parse_cmd+0x6a>
		else if (!compare_str(cmd[0], "-p")){
      9e:	85de                	mv	a1,s7
      a0:	00093503          	ld	a0,0(s2)
      a4:	00001097          	auipc	ra,0x1
      a8:	026080e7          	jalr	38(ra) # 10ca <compare_str>
      ac:	cd59                	beqz	a0,14a <parse_cmd+0x14a>
		else if (!compare_str(cmd[0], "-c")){
      ae:	85e2                	mv	a1,s8
      b0:	00093503          	ld	a0,0(s2)
      b4:	00001097          	auipc	ra,0x1
      b8:	016080e7          	jalr	22(ra) # 10ca <compare_str>
      bc:	84ca                	mv	s1,s2
      be:	f555                	bnez	a0,6a <parse_cmd+0x6a>
			cmd++;
      c0:	00890493          	addi	s1,s2,8
			priority[priorityIdx++]=10;
      c4:	f8043783          	ld	a5,-128(s0)
      c8:	0017871b          	addiw	a4,a5,1
      cc:	f8e43023          	sd	a4,-128(s0)
      d0:	078a                	slli	a5,a5,0x2
      d2:	f7843703          	ld	a4,-136(s0)
      d6:	97ba                	add	a5,a5,a4
      d8:	4729                	li	a4,10
      da:	c398                	sw	a4,0(a5)
			nextCmd[nextCmdIdx++] = commandsIdx;
      dc:	001c879b          	addiw	a5,s9,1
      e0:	f6f43423          	sd	a5,-152(s0)
      e4:	0c8a                	slli	s9,s9,0x2
      e6:	f7043783          	ld	a5,-144(s0)
      ea:	9cbe                	add	s9,s9,a5
      ec:	015ca023          	sw	s5,0(s9)
			while(*cmd && !( !compare_str(cmd[0], "-ps") || !compare_str(cmd[0], "-fcfs") || !compare_str(cmd[0], "-p") || !compare_str(cmd[0], "-c") )){
      f0:	00893503          	ld	a0,8(s2)
      f4:	c929                	beqz	a0,146 <parse_cmd+0x146>
      f6:	003a9913          	slli	s2,s5,0x3
      fa:	f8843783          	ld	a5,-120(s0)
      fe:	993e                	add	s2,s2,a5
     100:	85da                	mv	a1,s6
     102:	00001097          	auipc	ra,0x1
     106:	fc8080e7          	jalr	-56(ra) # 10ca <compare_str>
     10a:	cd6d                	beqz	a0,204 <parse_cmd+0x204>
     10c:	85ce                	mv	a1,s3
     10e:	6088                	ld	a0,0(s1)
     110:	00001097          	auipc	ra,0x1
     114:	fba080e7          	jalr	-70(ra) # 10ca <compare_str>
     118:	c575                	beqz	a0,204 <parse_cmd+0x204>
     11a:	85de                	mv	a1,s7
     11c:	6088                	ld	a0,0(s1)
     11e:	00001097          	auipc	ra,0x1
     122:	fac080e7          	jalr	-84(ra) # 10ca <compare_str>
     126:	cd79                	beqz	a0,204 <parse_cmd+0x204>
     128:	85e2                	mv	a1,s8
     12a:	6088                	ld	a0,0(s1)
     12c:	00001097          	auipc	ra,0x1
     130:	f9e080e7          	jalr	-98(ra) # 10ca <compare_str>
     134:	c961                	beqz	a0,204 <parse_cmd+0x204>
				commands[commandsIdx++]=*cmd;
     136:	2a85                	addiw	s5,s5,1
     138:	609c                	ld	a5,0(s1)
     13a:	00f93023          	sd	a5,0(s2)
				cmd++;
     13e:	04a1                	addi	s1,s1,8
			while(*cmd && !( !compare_str(cmd[0], "-ps") || !compare_str(cmd[0], "-fcfs") || !compare_str(cmd[0], "-p") || !compare_str(cmd[0], "-c") )){
     140:	6088                	ld	a0,0(s1)
     142:	0921                	addi	s2,s2,8
     144:	fd55                	bnez	a0,100 <parse_cmd+0x100>
				cmd--;
     146:	87d6                	mv	a5,s5
     148:	a0d1                	j	20c <parse_cmd+0x20c>
			priority[priorityIdx++]=atoi(cmd[1]);
     14a:	f8043783          	ld	a5,-128(s0)
     14e:	0017871b          	addiw	a4,a5,1
     152:	f8e43023          	sd	a4,-128(s0)
     156:	00279493          	slli	s1,a5,0x2
     15a:	f7843783          	ld	a5,-136(s0)
     15e:	94be                	add	s1,s1,a5
     160:	00893503          	ld	a0,8(s2)
     164:	00000097          	auipc	ra,0x0
     168:	668080e7          	jalr	1640(ra) # 7cc <atoi>
     16c:	c088                	sw	a0,0(s1)
			nextCmd[nextCmdIdx++] = commandsIdx;
     16e:	001c879b          	addiw	a5,s9,1
     172:	f6f43423          	sd	a5,-152(s0)
     176:	0c8a                	slli	s9,s9,0x2
     178:	f7043783          	ld	a5,-144(s0)
     17c:	9cbe                	add	s9,s9,a5
     17e:	015ca023          	sw	s5,0(s9)
			cmd+=3;
     182:	01890493          	addi	s1,s2,24
			while(*cmd && !( !compare_str(cmd[0], "-ps") || !compare_str(cmd[0], "-fcfs") || !compare_str(cmd[0], "-p") || !compare_str(cmd[0], "-c") )){
     186:	01893503          	ld	a0,24(s2)
     18a:	c929                	beqz	a0,1dc <parse_cmd+0x1dc>
     18c:	003a9913          	slli	s2,s5,0x3
     190:	f8843783          	ld	a5,-120(s0)
     194:	993e                	add	s2,s2,a5
     196:	85da                	mv	a1,s6
     198:	00001097          	auipc	ra,0x1
     19c:	f32080e7          	jalr	-206(ra) # 10ca <compare_str>
     1a0:	c121                	beqz	a0,1e0 <parse_cmd+0x1e0>
     1a2:	85ce                	mv	a1,s3
     1a4:	6088                	ld	a0,0(s1)
     1a6:	00001097          	auipc	ra,0x1
     1aa:	f24080e7          	jalr	-220(ra) # 10ca <compare_str>
     1ae:	c90d                	beqz	a0,1e0 <parse_cmd+0x1e0>
     1b0:	85de                	mv	a1,s7
     1b2:	6088                	ld	a0,0(s1)
     1b4:	00001097          	auipc	ra,0x1
     1b8:	f16080e7          	jalr	-234(ra) # 10ca <compare_str>
     1bc:	c115                	beqz	a0,1e0 <parse_cmd+0x1e0>
     1be:	85e2                	mv	a1,s8
     1c0:	6088                	ld	a0,0(s1)
     1c2:	00001097          	auipc	ra,0x1
     1c6:	f08080e7          	jalr	-248(ra) # 10ca <compare_str>
     1ca:	c919                	beqz	a0,1e0 <parse_cmd+0x1e0>
				commands[commandsIdx++]=*cmd;
     1cc:	2a85                	addiw	s5,s5,1
     1ce:	609c                	ld	a5,0(s1)
     1d0:	00f93023          	sd	a5,0(s2)
				cmd++;
     1d4:	04a1                	addi	s1,s1,8
			while(*cmd && !( !compare_str(cmd[0], "-ps") || !compare_str(cmd[0], "-fcfs") || !compare_str(cmd[0], "-p") || !compare_str(cmd[0], "-c") )){
     1d6:	6088                	ld	a0,0(s1)
     1d8:	0921                	addi	s2,s2,8
     1da:	fd55                	bnez	a0,196 <parse_cmd+0x196>
				cmd--;
     1dc:	87d6                	mv	a5,s5
     1de:	a029                	j	1e8 <parse_cmd+0x1e8>
			if (*cmd) // for handling - if sth exists
     1e0:	609c                	ld	a5,0(s1)
     1e2:	cf99                	beqz	a5,200 <parse_cmd+0x200>
				cmd--;
     1e4:	14e1                	addi	s1,s1,-8
     1e6:	87d6                	mv	a5,s5
			commands[commandsIdx++]=0;
     1e8:	00178a9b          	addiw	s5,a5,1
     1ec:	078e                	slli	a5,a5,0x3
     1ee:	f8843703          	ld	a4,-120(s0)
     1f2:	97ba                	add	a5,a5,a4
     1f4:	0007b023          	sd	zero,0(a5)
			cmdCount++;
     1f8:	2d85                	addiw	s11,s11,1
			nextCmd[nextCmdIdx++] = commandsIdx;
     1fa:	f6843c83          	ld	s9,-152(s0)
     1fe:	b5b5                	j	6a <parse_cmd+0x6a>
     200:	87d6                	mv	a5,s5
     202:	b7dd                	j	1e8 <parse_cmd+0x1e8>
			if (*cmd) // for handling - if sth exists
     204:	609c                	ld	a5,0(s1)
     206:	cf99                	beqz	a5,224 <parse_cmd+0x224>
				cmd--;
     208:	14e1                	addi	s1,s1,-8
     20a:	87d6                	mv	a5,s5
			commands[commandsIdx++]=0;
     20c:	00178a9b          	addiw	s5,a5,1
     210:	078e                	slli	a5,a5,0x3
     212:	f8843703          	ld	a4,-120(s0)
     216:	97ba                	add	a5,a5,a4
     218:	0007b023          	sd	zero,0(a5)
			cmdCount++;
     21c:	2d85                	addiw	s11,s11,1
			nextCmd[nextCmdIdx++] = commandsIdx;
     21e:	f6843c83          	ld	s9,-152(s0)
     222:	b5a1                	j	6a <parse_cmd+0x6a>
     224:	87d6                	mv	a5,s5
     226:	b7dd                	j	20c <parse_cmd+0x20c>
	int cmdCount=0;
     228:	4d81                	li	s11,0
	}
	return cmdCount;
}
     22a:	856e                	mv	a0,s11
     22c:	60ea                	ld	ra,152(sp)
     22e:	644a                	ld	s0,144(sp)
     230:	64aa                	ld	s1,136(sp)
     232:	690a                	ld	s2,128(sp)
     234:	79e6                	ld	s3,120(sp)
     236:	7a46                	ld	s4,112(sp)
     238:	7aa6                	ld	s5,104(sp)
     23a:	7b06                	ld	s6,96(sp)
     23c:	6be6                	ld	s7,88(sp)
     23e:	6c46                	ld	s8,80(sp)
     240:	6ca6                	ld	s9,72(sp)
     242:	6d06                	ld	s10,64(sp)
     244:	7de2                	ld	s11,56(sp)
     246:	610d                	addi	sp,sp,160
     248:	8082                	ret

000000000000024a <main>:
int main(int argc, char ** argv){
     24a:	bc010113          	addi	sp,sp,-1088
     24e:	42113c23          	sd	ra,1080(sp)
     252:	42813823          	sd	s0,1072(sp)
     256:	42913423          	sd	s1,1064(sp)
     25a:	43213023          	sd	s2,1056(sp)
     25e:	41313c23          	sd	s3,1048(sp)
     262:	41413823          	sd	s4,1040(sp)
     266:	41513423          	sd	s5,1032(sp)
     26a:	41613023          	sd	s6,1024(sp)
     26e:	3f713c23          	sd	s7,1016(sp)
     272:	44010413          	addi	s0,sp,1088
     276:	84ae                	mv	s1,a1
	getsched(&kernelScheduler);
     278:	fac40513          	addi	a0,s0,-84
     27c:	00000097          	auipc	ra,0x0
     280:	722080e7          	jalr	1826(ra) # 99e <getsched>
	char sched = kernelScheduler;
     284:	fac42783          	lw	a5,-84(s0)
     288:	faf405a3          	sb	a5,-85(s0)
	int cmdCount = parse_cmd(argv, &sched , commands, priority, nextCmd);
     28c:	be840713          	addi	a4,s0,-1048
     290:	c3840693          	addi	a3,s0,-968
     294:	c8840613          	addi	a2,s0,-888
     298:	fab40593          	addi	a1,s0,-85
     29c:	8526                	mv	a0,s1
     29e:	00000097          	auipc	ra,0x0
     2a2:	d62080e7          	jalr	-670(ra) # 0 <parse_cmd>
     2a6:	89aa                	mv	s3,a0
	int * pids = malloc(sizeof(int) * cmdCount);
     2a8:	0025151b          	slliw	a0,a0,0x2
     2ac:	00001097          	auipc	ra,0x1
     2b0:	a8c080e7          	jalr	-1396(ra) # d38 <malloc>
     2b4:	8aaa                	mv	s5,a0
	if (kernelScheduler == SCH_FCFS){
     2b6:	fac42a03          	lw	s4,-84(s0)
     2ba:	140a1463          	bnez	s4,402 <main+0x1b8>
     2be:	4901                	li	s2,0
		if (sched == SCH_PS){
     2c0:	fab44703          	lbu	a4,-85(s0)
     2c4:	4785                	li	a5,1
     2c6:	0ef70d63          	beq	a4,a5,3c0 <main+0x176>
			for(int i=0;i<cmdCount;i++){
     2ca:	13305763          	blez	s3,3f8 <main+0x1ae>
     2ce:	be840493          	addi	s1,s0,-1048
     2d2:	892a                	mv	s2,a0
     2d4:	fff98b1b          	addiw	s6,s3,-1
     2d8:	020b1793          	slli	a5,s6,0x20
     2dc:	01e7db13          	srli	s6,a5,0x1e
     2e0:	bec40793          	addi	a5,s0,-1044
     2e4:	9b3e                	add	s6,s6,a5
				char ** cmds = &commands[nextCmd[i]];
     2e6:	0004ab83          	lw	s7,0(s1)
				pid = fork();
     2ea:	00000097          	auipc	ra,0x0
     2ee:	5d4080e7          	jalr	1492(ra) # 8be <fork>
				if (!pid){ // Child
     2f2:	c565                	beqz	a0,3da <main+0x190>
				pids[pidIdx++]=pid;
     2f4:	00a92023          	sw	a0,0(s2)
			for(int i=0;i<cmdCount;i++){
     2f8:	0491                	addi	s1,s1,4
     2fa:	0911                	addi	s2,s2,4
     2fc:	ff6495e3          	bne	s1,s6,2e6 <main+0x9c>
					wait(0);
     300:	4501                	li	a0,0
     302:	00000097          	auipc	ra,0x0
     306:	5cc080e7          	jalr	1484(ra) # 8ce <wait>
				for(int i=0;i<cmdCount;i++)
     30a:	8952                	mv	s2,s4
     30c:	2a05                	addiw	s4,s4,1
     30e:	ff4999e3          	bne	s3,s4,300 <main+0xb6>
     312:	84d6                	mv	s1,s5
     314:	02091793          	slli	a5,s2,0x20
     318:	01e7d913          	srli	s2,a5,0x1e
     31c:	0a91                	addi	s5,s5,4
     31e:	9956                	add	s2,s2,s5
     320:	4a81                	li	s5,0
     322:	4a01                	li	s4,0
					printf("creationTime: %d  endTime: %d   totalTime: %d   runningTime: %d (ticks) \n",time.creationTime,
     324:	00001b17          	auipc	s6,0x1
     328:	fdcb0b13          	addi	s6,s6,-36 # 1300 <get_time_perf+0x9e>
					getpidtime(pids[i],&time);
     32c:	bc840593          	addi	a1,s0,-1080
     330:	4088                	lw	a0,0(s1)
     332:	00000097          	auipc	ra,0x0
     336:	664080e7          	jalr	1636(ra) # 996 <getpidtime>
					printf("creationTime: %d  endTime: %d   totalTime: %d   runningTime: %d (ticks) \n",time.creationTime,
     33a:	be043703          	ld	a4,-1056(s0)
     33e:	bd843683          	ld	a3,-1064(s0)
     342:	bd043603          	ld	a2,-1072(s0)
     346:	bc843583          	ld	a1,-1080(s0)
     34a:	855a                	mv	a0,s6
     34c:	00001097          	auipc	ra,0x1
     350:	934080e7          	jalr	-1740(ra) # c80 <printf>
					turnATime += time.totalTime;
     354:	bd843783          	ld	a5,-1064(s0)
     358:	9a3e                	add	s4,s4,a5
					wTime += time.runningTime-time.creationTime;
     35a:	be043783          	ld	a5,-1056(s0)
     35e:	bc843703          	ld	a4,-1080(s0)
     362:	8f99                	sub	a5,a5,a4
     364:	9abe                	add	s5,s5,a5
				for(int i=0;i<cmdCount;i++){
     366:	0491                	addi	s1,s1,4
     368:	fc9912e3          	bne	s2,s1,32c <main+0xe2>
				printf("------------------------------------------------------------------\n");
     36c:	00001517          	auipc	a0,0x1
     370:	fe450513          	addi	a0,a0,-28 # 1350 <get_time_perf+0xee>
     374:	00001097          	auipc	ra,0x1
     378:	90c080e7          	jalr	-1780(ra) # c80 <printf>
				printf("AVGTurnAroundTime: %d ticks   AVGWaitingTime: %d ticks\n",turnATime/cmdCount, wTime/cmdCount);
     37c:	033ad633          	divu	a2,s5,s3
     380:	033a55b3          	divu	a1,s4,s3
     384:	00001517          	auipc	a0,0x1
     388:	01450513          	addi	a0,a0,20 # 1398 <get_time_perf+0x136>
     38c:	00001097          	auipc	ra,0x1
     390:	8f4080e7          	jalr	-1804(ra) # c80 <printf>
}
     394:	4501                	li	a0,0
     396:	43813083          	ld	ra,1080(sp)
     39a:	43013403          	ld	s0,1072(sp)
     39e:	42813483          	ld	s1,1064(sp)
     3a2:	42013903          	ld	s2,1056(sp)
     3a6:	41813983          	ld	s3,1048(sp)
     3aa:	41013a03          	ld	s4,1040(sp)
     3ae:	40813a83          	ld	s5,1032(sp)
     3b2:	40013b03          	ld	s6,1024(sp)
     3b6:	3f813b83          	ld	s7,1016(sp)
     3ba:	44010113          	addi	sp,sp,1088
     3be:	8082                	ret
			printf("[ERR] Kernel is running FCFS\n");
     3c0:	00001517          	auipc	a0,0x1
     3c4:	f2050513          	addi	a0,a0,-224 # 12e0 <get_time_perf+0x7e>
     3c8:	00001097          	auipc	ra,0x1
     3cc:	8b8080e7          	jalr	-1864(ra) # c80 <printf>
			exit(-1);
     3d0:	557d                	li	a0,-1
     3d2:	00000097          	auipc	ra,0x0
     3d6:	4f4080e7          	jalr	1268(ra) # 8c6 <exit>
				char ** cmds = &commands[nextCmd[i]];
     3da:	003b9593          	slli	a1,s7,0x3
					exec(cmds[0],cmds);
     3de:	fb058793          	addi	a5,a1,-80
     3e2:	97a2                	add	a5,a5,s0
     3e4:	c8840713          	addi	a4,s0,-888
     3e8:	95ba                	add	a1,a1,a4
     3ea:	cd87b503          	ld	a0,-808(a5)
     3ee:	00000097          	auipc	ra,0x0
     3f2:	510080e7          	jalr	1296(ra) # 8fe <exec>
			if (pid){ // Parent
     3f6:	bf79                	j	394 <main+0x14a>
     3f8:	f8090ee3          	beqz	s2,394 <main+0x14a>
				time_t wTime=0;
     3fc:	4a81                	li	s5,0
				time_t turnATime=0;
     3fe:	4a01                	li	s4,0
     400:	b7b5                	j	36c <main+0x122>
     402:	4b01                	li	s6,0
     404:	4b81                	li	s7,0
	}else if (kernelScheduler == SCH_PS){
     406:	4785                	li	a5,1
     408:	0cfa0a63          	beq	s4,a5,4dc <main+0x292>
		if (sched != SCH_DEF){
     40c:	fab44703          	lbu	a4,-85(s0)
     410:	4789                	li	a5,2
     412:	1ef71663          	bne	a4,a5,5fe <main+0x3b4>
			for(int i=0;i<cmdCount;i++){
     416:	23305063          	blez	s3,636 <main+0x3ec>
     41a:	be840493          	addi	s1,s0,-1048
     41e:	892a                	mv	s2,a0
     420:	fff98a1b          	addiw	s4,s3,-1
     424:	020a1793          	slli	a5,s4,0x20
     428:	01e7da13          	srli	s4,a5,0x1e
     42c:	bec40793          	addi	a5,s0,-1044
     430:	9a3e                	add	s4,s4,a5
				char ** cmds = &commands[nextCmd[i]];
     432:	0004ab03          	lw	s6,0(s1)
				pid=fork();
     436:	00000097          	auipc	ra,0x0
     43a:	488080e7          	jalr	1160(ra) # 8be <fork>
				if (!pid){
     43e:	1c050d63          	beqz	a0,618 <main+0x3ce>
				pids[pidIdx++]=pid;
     442:	00a92023          	sw	a0,0(s2)
			for(int i=0;i<cmdCount;i++){
     446:	0491                	addi	s1,s1,4
     448:	0911                	addi	s2,s2,4
     44a:	ff4494e3          	bne	s1,s4,432 <main+0x1e8>
     44e:	4481                	li	s1,0
					wait(0);
     450:	4501                	li	a0,0
     452:	00000097          	auipc	ra,0x0
     456:	47c080e7          	jalr	1148(ra) # 8ce <wait>
				for(int i=0;i<cmdCount;i++)
     45a:	87a6                	mv	a5,s1
     45c:	2485                	addiw	s1,s1,1
     45e:	fe9999e3          	bne	s3,s1,450 <main+0x206>
     462:	84d6                	mv	s1,s5
     464:	0a91                	addi	s5,s5,4
     466:	02079713          	slli	a4,a5,0x20
     46a:	01e75793          	srli	a5,a4,0x1e
     46e:	9abe                	add	s5,s5,a5
     470:	4a01                	li	s4,0
     472:	4901                	li	s2,0
					printf("creationTime: %d  endTime: %d   totalTime: %d   runningTime: %d (ticks) \n",time.creationTime,
     474:	00001b17          	auipc	s6,0x1
     478:	e8cb0b13          	addi	s6,s6,-372 # 1300 <get_time_perf+0x9e>
					getpidtime(pids[i],&time);
     47c:	bc840593          	addi	a1,s0,-1080
     480:	4088                	lw	a0,0(s1)
     482:	00000097          	auipc	ra,0x0
     486:	514080e7          	jalr	1300(ra) # 996 <getpidtime>
					turnATime += time.totalTime;
     48a:	bd843683          	ld	a3,-1064(s0)
     48e:	9936                	add	s2,s2,a3
					wTime += time.runningTime-time.creationTime;
     490:	be043703          	ld	a4,-1056(s0)
     494:	bc843583          	ld	a1,-1080(s0)
     498:	40b707b3          	sub	a5,a4,a1
     49c:	9a3e                	add	s4,s4,a5
					printf("creationTime: %d  endTime: %d   totalTime: %d   runningTime: %d (ticks) \n",time.creationTime,
     49e:	bd043603          	ld	a2,-1072(s0)
     4a2:	855a                	mv	a0,s6
     4a4:	00000097          	auipc	ra,0x0
     4a8:	7dc080e7          	jalr	2012(ra) # c80 <printf>
				for(int i=0;i<cmdCount;i++){
     4ac:	0491                	addi	s1,s1,4
     4ae:	fd5497e3          	bne	s1,s5,47c <main+0x232>
				printf("------------------------------------------------------------------\n");
     4b2:	00001517          	auipc	a0,0x1
     4b6:	e9e50513          	addi	a0,a0,-354 # 1350 <get_time_perf+0xee>
     4ba:	00000097          	auipc	ra,0x0
     4be:	7c6080e7          	jalr	1990(ra) # c80 <printf>
				printf("AVGTurnAroundTime: %d ticks   AVGWaitingTime: %d ticks\n",turnATime/cmdCount, wTime/cmdCount);
     4c2:	033a5633          	divu	a2,s4,s3
     4c6:	033955b3          	divu	a1,s2,s3
     4ca:	00001517          	auipc	a0,0x1
     4ce:	ece50513          	addi	a0,a0,-306 # 1398 <get_time_perf+0x136>
     4d2:	00000097          	auipc	ra,0x0
     4d6:	7ae080e7          	jalr	1966(ra) # c80 <printf>
     4da:	bd6d                	j	394 <main+0x14a>
		if (sched == SCH_FCFS){
     4dc:	fab44783          	lbu	a5,-85(s0)
     4e0:	c7b9                	beqz	a5,52e <main+0x2e4>
			for(int i=0;i<cmdCount;i++){
     4e2:	09305263          	blez	s3,566 <main+0x31c>
     4e6:	be840493          	addi	s1,s0,-1048
     4ea:	8a2a                	mv	s4,a0
     4ec:	c3840913          	addi	s2,s0,-968
     4f0:	fff98b1b          	addiw	s6,s3,-1
     4f4:	020b1793          	slli	a5,s6,0x20
     4f8:	01e7db13          	srli	s6,a5,0x1e
     4fc:	bec40793          	addi	a5,s0,-1044
     500:	9b3e                	add	s6,s6,a5
				char ** cmds = &commands[nextCmd[i]];
     502:	0004ab83          	lw	s7,0(s1)
				pid=fork();
     506:	00000097          	auipc	ra,0x0
     50a:	3b8080e7          	jalr	952(ra) # 8be <fork>
				if (!pid){ // Child
     50e:	cd0d                	beqz	a0,548 <main+0x2fe>
				pids[pidIdx++]=pid;
     510:	00aa2023          	sw	a0,0(s4)
				setpr(pid, priority[i]);
     514:	00092583          	lw	a1,0(s2)
     518:	00000097          	auipc	ra,0x0
     51c:	476080e7          	jalr	1142(ra) # 98e <setpr>
			for(int i=0;i<cmdCount;i++){
     520:	0491                	addi	s1,s1,4
     522:	0a11                	addi	s4,s4,4
     524:	0911                	addi	s2,s2,4
     526:	fd649ee3          	bne	s1,s6,502 <main+0x2b8>
     52a:	4901                	li	s2,0
     52c:	a099                	j	572 <main+0x328>
			printf("[ERR] Kernel is running Priority scheduling\n");
     52e:	00001517          	auipc	a0,0x1
     532:	ea250513          	addi	a0,a0,-350 # 13d0 <get_time_perf+0x16e>
     536:	00000097          	auipc	ra,0x0
     53a:	74a080e7          	jalr	1866(ra) # c80 <printf>
			exit(-1);
     53e:	557d                	li	a0,-1
     540:	00000097          	auipc	ra,0x0
     544:	386080e7          	jalr	902(ra) # 8c6 <exit>
				char ** cmds = &commands[nextCmd[i]];
     548:	003b9593          	slli	a1,s7,0x3
					exec(cmds[0],cmds);
     54c:	fb058793          	addi	a5,a1,-80
     550:	97a2                	add	a5,a5,s0
     552:	c8840713          	addi	a4,s0,-888
     556:	95ba                	add	a1,a1,a4
     558:	cd87b503          	ld	a0,-808(a5)
     55c:	00000097          	auipc	ra,0x0
     560:	3a2080e7          	jalr	930(ra) # 8fe <exec>
			if (pid){ // Parent
     564:	bd05                	j	394 <main+0x14a>
     566:	e20b87e3          	beqz	s7,394 <main+0x14a>
				time_t wTime=0;
     56a:	4a01                	li	s4,0
				time_t turnATime=0;
     56c:	4901                	li	s2,0
     56e:	a09d                	j	5d4 <main+0x38a>
				for(int i=0;i<cmdCount;i++)
     570:	893e                	mv	s2,a5
					wait(0);
     572:	4501                	li	a0,0
     574:	00000097          	auipc	ra,0x0
     578:	35a080e7          	jalr	858(ra) # 8ce <wait>
				for(int i=0;i<cmdCount;i++)
     57c:	0019079b          	addiw	a5,s2,1
     580:	fef998e3          	bne	s3,a5,570 <main+0x326>
     584:	84d6                	mv	s1,s5
     586:	0a91                	addi	s5,s5,4
     588:	02091793          	slli	a5,s2,0x20
     58c:	01e7d913          	srli	s2,a5,0x1e
     590:	9aca                	add	s5,s5,s2
     592:	4a01                	li	s4,0
     594:	4901                	li	s2,0
					printf("creationTime: %d  endTime: %d   totalTime: %d   runningTime: %d (ticks) \n",time.creationTime,
     596:	00001b17          	auipc	s6,0x1
     59a:	d6ab0b13          	addi	s6,s6,-662 # 1300 <get_time_perf+0x9e>
					getpidtime(pids[i],&time);
     59e:	bc840593          	addi	a1,s0,-1080
     5a2:	4088                	lw	a0,0(s1)
     5a4:	00000097          	auipc	ra,0x0
     5a8:	3f2080e7          	jalr	1010(ra) # 996 <getpidtime>
					turnATime += time.totalTime;
     5ac:	bd843683          	ld	a3,-1064(s0)
     5b0:	9936                	add	s2,s2,a3
					wTime += time.runningTime-time.creationTime;
     5b2:	be043703          	ld	a4,-1056(s0)
     5b6:	bc843583          	ld	a1,-1080(s0)
     5ba:	40b707b3          	sub	a5,a4,a1
     5be:	9a3e                	add	s4,s4,a5
					printf("creationTime: %d  endTime: %d   totalTime: %d   runningTime: %d (ticks) \n",time.creationTime,
     5c0:	bd043603          	ld	a2,-1072(s0)
     5c4:	855a                	mv	a0,s6
     5c6:	00000097          	auipc	ra,0x0
     5ca:	6ba080e7          	jalr	1722(ra) # c80 <printf>
				for(int i=0;i<cmdCount;i++){
     5ce:	0491                	addi	s1,s1,4
     5d0:	fd5497e3          	bne	s1,s5,59e <main+0x354>
				printf("------------------------------------------------------------------\n");
     5d4:	00001517          	auipc	a0,0x1
     5d8:	d7c50513          	addi	a0,a0,-644 # 1350 <get_time_perf+0xee>
     5dc:	00000097          	auipc	ra,0x0
     5e0:	6a4080e7          	jalr	1700(ra) # c80 <printf>
				printf("AVGTurnAroundTime: %d ticks   AVGWaitingTime: %d ticks\n",turnATime/cmdCount, wTime/cmdCount);
     5e4:	033a5633          	divu	a2,s4,s3
     5e8:	033955b3          	divu	a1,s2,s3
     5ec:	00001517          	auipc	a0,0x1
     5f0:	dac50513          	addi	a0,a0,-596 # 1398 <get_time_perf+0x136>
     5f4:	00000097          	auipc	ra,0x0
     5f8:	68c080e7          	jalr	1676(ra) # c80 <printf>
     5fc:	bb61                	j	394 <main+0x14a>
			printf("[ERR] Kernel is running default scheduling\n");
     5fe:	00001517          	auipc	a0,0x1
     602:	e0250513          	addi	a0,a0,-510 # 1400 <get_time_perf+0x19e>
     606:	00000097          	auipc	ra,0x0
     60a:	67a080e7          	jalr	1658(ra) # c80 <printf>
			exit(-1);
     60e:	557d                	li	a0,-1
     610:	00000097          	auipc	ra,0x0
     614:	2b6080e7          	jalr	694(ra) # 8c6 <exit>
				char ** cmds = &commands[nextCmd[i]];
     618:	003b1593          	slli	a1,s6,0x3
					exec(cmds[0],cmds);
     61c:	fb058793          	addi	a5,a1,-80
     620:	97a2                	add	a5,a5,s0
     622:	c8840713          	addi	a4,s0,-888
     626:	95ba                	add	a1,a1,a4
     628:	cd87b503          	ld	a0,-808(a5)
     62c:	00000097          	auipc	ra,0x0
     630:	2d2080e7          	jalr	722(ra) # 8fe <exec>
			if (pid){
     634:	b385                	j	394 <main+0x14a>
     636:	d40b0fe3          	beqz	s6,394 <main+0x14a>
				time_t wTime=0;
     63a:	4a01                	li	s4,0
				time_t turnATime=0;
     63c:	4901                	li	s2,0
     63e:	bd95                	j	4b2 <main+0x268>

0000000000000640 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     640:	1141                	addi	sp,sp,-16
     642:	e406                	sd	ra,8(sp)
     644:	e022                	sd	s0,0(sp)
     646:	0800                	addi	s0,sp,16
  extern int main();
  main();
     648:	00000097          	auipc	ra,0x0
     64c:	c02080e7          	jalr	-1022(ra) # 24a <main>
  exit(0);
     650:	4501                	li	a0,0
     652:	00000097          	auipc	ra,0x0
     656:	274080e7          	jalr	628(ra) # 8c6 <exit>

000000000000065a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     65a:	1141                	addi	sp,sp,-16
     65c:	e422                	sd	s0,8(sp)
     65e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     660:	87aa                	mv	a5,a0
     662:	0585                	addi	a1,a1,1
     664:	0785                	addi	a5,a5,1
     666:	fff5c703          	lbu	a4,-1(a1)
     66a:	fee78fa3          	sb	a4,-1(a5)
     66e:	fb75                	bnez	a4,662 <strcpy+0x8>
    ;
  return os;
}
     670:	6422                	ld	s0,8(sp)
     672:	0141                	addi	sp,sp,16
     674:	8082                	ret

0000000000000676 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     676:	1141                	addi	sp,sp,-16
     678:	e422                	sd	s0,8(sp)
     67a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     67c:	00054783          	lbu	a5,0(a0)
     680:	cb91                	beqz	a5,694 <strcmp+0x1e>
     682:	0005c703          	lbu	a4,0(a1)
     686:	00f71763          	bne	a4,a5,694 <strcmp+0x1e>
    p++, q++;
     68a:	0505                	addi	a0,a0,1
     68c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     68e:	00054783          	lbu	a5,0(a0)
     692:	fbe5                	bnez	a5,682 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     694:	0005c503          	lbu	a0,0(a1)
}
     698:	40a7853b          	subw	a0,a5,a0
     69c:	6422                	ld	s0,8(sp)
     69e:	0141                	addi	sp,sp,16
     6a0:	8082                	ret

00000000000006a2 <strlen>:

uint
strlen(const char *s)
{
     6a2:	1141                	addi	sp,sp,-16
     6a4:	e422                	sd	s0,8(sp)
     6a6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     6a8:	00054783          	lbu	a5,0(a0)
     6ac:	cf91                	beqz	a5,6c8 <strlen+0x26>
     6ae:	0505                	addi	a0,a0,1
     6b0:	87aa                	mv	a5,a0
     6b2:	4685                	li	a3,1
     6b4:	9e89                	subw	a3,a3,a0
     6b6:	00f6853b          	addw	a0,a3,a5
     6ba:	0785                	addi	a5,a5,1
     6bc:	fff7c703          	lbu	a4,-1(a5)
     6c0:	fb7d                	bnez	a4,6b6 <strlen+0x14>
    ;
  return n;
}
     6c2:	6422                	ld	s0,8(sp)
     6c4:	0141                	addi	sp,sp,16
     6c6:	8082                	ret
  for(n = 0; s[n]; n++)
     6c8:	4501                	li	a0,0
     6ca:	bfe5                	j	6c2 <strlen+0x20>

00000000000006cc <memset>:

void*
memset(void *dst, int c, uint n)
{
     6cc:	1141                	addi	sp,sp,-16
     6ce:	e422                	sd	s0,8(sp)
     6d0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     6d2:	ca19                	beqz	a2,6e8 <memset+0x1c>
     6d4:	87aa                	mv	a5,a0
     6d6:	1602                	slli	a2,a2,0x20
     6d8:	9201                	srli	a2,a2,0x20
     6da:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     6de:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     6e2:	0785                	addi	a5,a5,1
     6e4:	fee79de3          	bne	a5,a4,6de <memset+0x12>
  }
  return dst;
}
     6e8:	6422                	ld	s0,8(sp)
     6ea:	0141                	addi	sp,sp,16
     6ec:	8082                	ret

00000000000006ee <strchr>:

char*
strchr(const char *s, char c)
{
     6ee:	1141                	addi	sp,sp,-16
     6f0:	e422                	sd	s0,8(sp)
     6f2:	0800                	addi	s0,sp,16
  for(; *s; s++)
     6f4:	00054783          	lbu	a5,0(a0)
     6f8:	cb99                	beqz	a5,70e <strchr+0x20>
    if(*s == c)
     6fa:	00f58763          	beq	a1,a5,708 <strchr+0x1a>
  for(; *s; s++)
     6fe:	0505                	addi	a0,a0,1
     700:	00054783          	lbu	a5,0(a0)
     704:	fbfd                	bnez	a5,6fa <strchr+0xc>
      return (char*)s;
  return 0;
     706:	4501                	li	a0,0
}
     708:	6422                	ld	s0,8(sp)
     70a:	0141                	addi	sp,sp,16
     70c:	8082                	ret
  return 0;
     70e:	4501                	li	a0,0
     710:	bfe5                	j	708 <strchr+0x1a>

0000000000000712 <gets>:

char*
gets(char *buf, int max)
{
     712:	711d                	addi	sp,sp,-96
     714:	ec86                	sd	ra,88(sp)
     716:	e8a2                	sd	s0,80(sp)
     718:	e4a6                	sd	s1,72(sp)
     71a:	e0ca                	sd	s2,64(sp)
     71c:	fc4e                	sd	s3,56(sp)
     71e:	f852                	sd	s4,48(sp)
     720:	f456                	sd	s5,40(sp)
     722:	f05a                	sd	s6,32(sp)
     724:	ec5e                	sd	s7,24(sp)
     726:	1080                	addi	s0,sp,96
     728:	8baa                	mv	s7,a0
     72a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     72c:	892a                	mv	s2,a0
     72e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     730:	4aa9                	li	s5,10
     732:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     734:	89a6                	mv	s3,s1
     736:	2485                	addiw	s1,s1,1
     738:	0344d863          	bge	s1,s4,768 <gets+0x56>
    cc = read(0, &c, 1);
     73c:	4605                	li	a2,1
     73e:	faf40593          	addi	a1,s0,-81
     742:	4501                	li	a0,0
     744:	00000097          	auipc	ra,0x0
     748:	19a080e7          	jalr	410(ra) # 8de <read>
    if(cc < 1)
     74c:	00a05e63          	blez	a0,768 <gets+0x56>
    buf[i++] = c;
     750:	faf44783          	lbu	a5,-81(s0)
     754:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     758:	01578763          	beq	a5,s5,766 <gets+0x54>
     75c:	0905                	addi	s2,s2,1
     75e:	fd679be3          	bne	a5,s6,734 <gets+0x22>
  for(i=0; i+1 < max; ){
     762:	89a6                	mv	s3,s1
     764:	a011                	j	768 <gets+0x56>
     766:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     768:	99de                	add	s3,s3,s7
     76a:	00098023          	sb	zero,0(s3)
  return buf;
}
     76e:	855e                	mv	a0,s7
     770:	60e6                	ld	ra,88(sp)
     772:	6446                	ld	s0,80(sp)
     774:	64a6                	ld	s1,72(sp)
     776:	6906                	ld	s2,64(sp)
     778:	79e2                	ld	s3,56(sp)
     77a:	7a42                	ld	s4,48(sp)
     77c:	7aa2                	ld	s5,40(sp)
     77e:	7b02                	ld	s6,32(sp)
     780:	6be2                	ld	s7,24(sp)
     782:	6125                	addi	sp,sp,96
     784:	8082                	ret

0000000000000786 <stat>:

int
stat(const char *n, struct stat *st)
{
     786:	1101                	addi	sp,sp,-32
     788:	ec06                	sd	ra,24(sp)
     78a:	e822                	sd	s0,16(sp)
     78c:	e426                	sd	s1,8(sp)
     78e:	e04a                	sd	s2,0(sp)
     790:	1000                	addi	s0,sp,32
     792:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     794:	4581                	li	a1,0
     796:	00000097          	auipc	ra,0x0
     79a:	170080e7          	jalr	368(ra) # 906 <open>
  if(fd < 0)
     79e:	02054563          	bltz	a0,7c8 <stat+0x42>
     7a2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     7a4:	85ca                	mv	a1,s2
     7a6:	00000097          	auipc	ra,0x0
     7aa:	178080e7          	jalr	376(ra) # 91e <fstat>
     7ae:	892a                	mv	s2,a0
  close(fd);
     7b0:	8526                	mv	a0,s1
     7b2:	00000097          	auipc	ra,0x0
     7b6:	13c080e7          	jalr	316(ra) # 8ee <close>
  return r;
}
     7ba:	854a                	mv	a0,s2
     7bc:	60e2                	ld	ra,24(sp)
     7be:	6442                	ld	s0,16(sp)
     7c0:	64a2                	ld	s1,8(sp)
     7c2:	6902                	ld	s2,0(sp)
     7c4:	6105                	addi	sp,sp,32
     7c6:	8082                	ret
    return -1;
     7c8:	597d                	li	s2,-1
     7ca:	bfc5                	j	7ba <stat+0x34>

00000000000007cc <atoi>:

int
atoi(const char *s)
{
     7cc:	1141                	addi	sp,sp,-16
     7ce:	e422                	sd	s0,8(sp)
     7d0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     7d2:	00054683          	lbu	a3,0(a0)
     7d6:	fd06879b          	addiw	a5,a3,-48
     7da:	0ff7f793          	zext.b	a5,a5
     7de:	4625                	li	a2,9
     7e0:	02f66863          	bltu	a2,a5,810 <atoi+0x44>
     7e4:	872a                	mv	a4,a0
  n = 0;
     7e6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     7e8:	0705                	addi	a4,a4,1
     7ea:	0025179b          	slliw	a5,a0,0x2
     7ee:	9fa9                	addw	a5,a5,a0
     7f0:	0017979b          	slliw	a5,a5,0x1
     7f4:	9fb5                	addw	a5,a5,a3
     7f6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     7fa:	00074683          	lbu	a3,0(a4)
     7fe:	fd06879b          	addiw	a5,a3,-48
     802:	0ff7f793          	zext.b	a5,a5
     806:	fef671e3          	bgeu	a2,a5,7e8 <atoi+0x1c>
  return n;
}
     80a:	6422                	ld	s0,8(sp)
     80c:	0141                	addi	sp,sp,16
     80e:	8082                	ret
  n = 0;
     810:	4501                	li	a0,0
     812:	bfe5                	j	80a <atoi+0x3e>

0000000000000814 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     814:	1141                	addi	sp,sp,-16
     816:	e422                	sd	s0,8(sp)
     818:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     81a:	02b57463          	bgeu	a0,a1,842 <memmove+0x2e>
    while(n-- > 0)
     81e:	00c05f63          	blez	a2,83c <memmove+0x28>
     822:	1602                	slli	a2,a2,0x20
     824:	9201                	srli	a2,a2,0x20
     826:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     82a:	872a                	mv	a4,a0
      *dst++ = *src++;
     82c:	0585                	addi	a1,a1,1
     82e:	0705                	addi	a4,a4,1
     830:	fff5c683          	lbu	a3,-1(a1)
     834:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     838:	fee79ae3          	bne	a5,a4,82c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     83c:	6422                	ld	s0,8(sp)
     83e:	0141                	addi	sp,sp,16
     840:	8082                	ret
    dst += n;
     842:	00c50733          	add	a4,a0,a2
    src += n;
     846:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     848:	fec05ae3          	blez	a2,83c <memmove+0x28>
     84c:	fff6079b          	addiw	a5,a2,-1
     850:	1782                	slli	a5,a5,0x20
     852:	9381                	srli	a5,a5,0x20
     854:	fff7c793          	not	a5,a5
     858:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     85a:	15fd                	addi	a1,a1,-1
     85c:	177d                	addi	a4,a4,-1
     85e:	0005c683          	lbu	a3,0(a1)
     862:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     866:	fee79ae3          	bne	a5,a4,85a <memmove+0x46>
     86a:	bfc9                	j	83c <memmove+0x28>

000000000000086c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     86c:	1141                	addi	sp,sp,-16
     86e:	e422                	sd	s0,8(sp)
     870:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     872:	ca05                	beqz	a2,8a2 <memcmp+0x36>
     874:	fff6069b          	addiw	a3,a2,-1
     878:	1682                	slli	a3,a3,0x20
     87a:	9281                	srli	a3,a3,0x20
     87c:	0685                	addi	a3,a3,1
     87e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     880:	00054783          	lbu	a5,0(a0)
     884:	0005c703          	lbu	a4,0(a1)
     888:	00e79863          	bne	a5,a4,898 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     88c:	0505                	addi	a0,a0,1
    p2++;
     88e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     890:	fed518e3          	bne	a0,a3,880 <memcmp+0x14>
  }
  return 0;
     894:	4501                	li	a0,0
     896:	a019                	j	89c <memcmp+0x30>
      return *p1 - *p2;
     898:	40e7853b          	subw	a0,a5,a4
}
     89c:	6422                	ld	s0,8(sp)
     89e:	0141                	addi	sp,sp,16
     8a0:	8082                	ret
  return 0;
     8a2:	4501                	li	a0,0
     8a4:	bfe5                	j	89c <memcmp+0x30>

00000000000008a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     8a6:	1141                	addi	sp,sp,-16
     8a8:	e406                	sd	ra,8(sp)
     8aa:	e022                	sd	s0,0(sp)
     8ac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     8ae:	00000097          	auipc	ra,0x0
     8b2:	f66080e7          	jalr	-154(ra) # 814 <memmove>
}
     8b6:	60a2                	ld	ra,8(sp)
     8b8:	6402                	ld	s0,0(sp)
     8ba:	0141                	addi	sp,sp,16
     8bc:	8082                	ret

00000000000008be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     8be:	4885                	li	a7,1
 ecall
     8c0:	00000073          	ecall
 ret
     8c4:	8082                	ret

00000000000008c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
     8c6:	4889                	li	a7,2
 ecall
     8c8:	00000073          	ecall
 ret
     8cc:	8082                	ret

00000000000008ce <wait>:
.global wait
wait:
 li a7, SYS_wait
     8ce:	488d                	li	a7,3
 ecall
     8d0:	00000073          	ecall
 ret
     8d4:	8082                	ret

00000000000008d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     8d6:	4891                	li	a7,4
 ecall
     8d8:	00000073          	ecall
 ret
     8dc:	8082                	ret

00000000000008de <read>:
.global read
read:
 li a7, SYS_read
     8de:	4895                	li	a7,5
 ecall
     8e0:	00000073          	ecall
 ret
     8e4:	8082                	ret

00000000000008e6 <write>:
.global write
write:
 li a7, SYS_write
     8e6:	48c1                	li	a7,16
 ecall
     8e8:	00000073          	ecall
 ret
     8ec:	8082                	ret

00000000000008ee <close>:
.global close
close:
 li a7, SYS_close
     8ee:	48d5                	li	a7,21
 ecall
     8f0:	00000073          	ecall
 ret
     8f4:	8082                	ret

00000000000008f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
     8f6:	4899                	li	a7,6
 ecall
     8f8:	00000073          	ecall
 ret
     8fc:	8082                	ret

00000000000008fe <exec>:
.global exec
exec:
 li a7, SYS_exec
     8fe:	489d                	li	a7,7
 ecall
     900:	00000073          	ecall
 ret
     904:	8082                	ret

0000000000000906 <open>:
.global open
open:
 li a7, SYS_open
     906:	48bd                	li	a7,15
 ecall
     908:	00000073          	ecall
 ret
     90c:	8082                	ret

000000000000090e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     90e:	48c5                	li	a7,17
 ecall
     910:	00000073          	ecall
 ret
     914:	8082                	ret

0000000000000916 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     916:	48c9                	li	a7,18
 ecall
     918:	00000073          	ecall
 ret
     91c:	8082                	ret

000000000000091e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     91e:	48a1                	li	a7,8
 ecall
     920:	00000073          	ecall
 ret
     924:	8082                	ret

0000000000000926 <link>:
.global link
link:
 li a7, SYS_link
     926:	48cd                	li	a7,19
 ecall
     928:	00000073          	ecall
 ret
     92c:	8082                	ret

000000000000092e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     92e:	48d1                	li	a7,20
 ecall
     930:	00000073          	ecall
 ret
     934:	8082                	ret

0000000000000936 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     936:	48a5                	li	a7,9
 ecall
     938:	00000073          	ecall
 ret
     93c:	8082                	ret

000000000000093e <dup>:
.global dup
dup:
 li a7, SYS_dup
     93e:	48a9                	li	a7,10
 ecall
     940:	00000073          	ecall
 ret
     944:	8082                	ret

0000000000000946 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     946:	48ad                	li	a7,11
 ecall
     948:	00000073          	ecall
 ret
     94c:	8082                	ret

000000000000094e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     94e:	48b1                	li	a7,12
 ecall
     950:	00000073          	ecall
 ret
     954:	8082                	ret

0000000000000956 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     956:	48b5                	li	a7,13
 ecall
     958:	00000073          	ecall
 ret
     95c:	8082                	ret

000000000000095e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     95e:	48b9                	li	a7,14
 ecall
     960:	00000073          	ecall
 ret
     964:	8082                	ret

0000000000000966 <head>:
.global head
head:
 li a7, SYS_head
     966:	48d9                	li	a7,22
 ecall
     968:	00000073          	ecall
 ret
     96c:	8082                	ret

000000000000096e <uniq>:
.global uniq
uniq:
 li a7, SYS_uniq
     96e:	48dd                	li	a7,23
 ecall
     970:	00000073          	ecall
 ret
     974:	8082                	ret

0000000000000976 <ps>:
.global ps
ps:
 li a7, SYS_ps
     976:	48e1                	li	a7,24
 ecall
     978:	00000073          	ecall
 ret
     97c:	8082                	ret

000000000000097e <times>:
.global times
times:
 li a7, SYS_times
     97e:	48e5                	li	a7,25
 ecall
     980:	00000073          	ecall
 ret
     984:	8082                	ret

0000000000000986 <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
     986:	48e9                	li	a7,26
 ecall
     988:	00000073          	ecall
 ret
     98c:	8082                	ret

000000000000098e <setpr>:
.global setpr
setpr:
 li a7, SYS_setpr
     98e:	48ed                	li	a7,27
 ecall
     990:	00000073          	ecall
 ret
     994:	8082                	ret

0000000000000996 <getpidtime>:
.global getpidtime
getpidtime:
 li a7, SYS_getpidtime
     996:	48f1                	li	a7,28
 ecall
     998:	00000073          	ecall
 ret
     99c:	8082                	ret

000000000000099e <getsched>:
.global getsched
getsched:
 li a7, SYS_getsched
     99e:	48f5                	li	a7,29
 ecall
     9a0:	00000073          	ecall
 ret
     9a4:	8082                	ret

00000000000009a6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     9a6:	1101                	addi	sp,sp,-32
     9a8:	ec06                	sd	ra,24(sp)
     9aa:	e822                	sd	s0,16(sp)
     9ac:	1000                	addi	s0,sp,32
     9ae:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     9b2:	4605                	li	a2,1
     9b4:	fef40593          	addi	a1,s0,-17
     9b8:	00000097          	auipc	ra,0x0
     9bc:	f2e080e7          	jalr	-210(ra) # 8e6 <write>
}
     9c0:	60e2                	ld	ra,24(sp)
     9c2:	6442                	ld	s0,16(sp)
     9c4:	6105                	addi	sp,sp,32
     9c6:	8082                	ret

00000000000009c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     9c8:	7139                	addi	sp,sp,-64
     9ca:	fc06                	sd	ra,56(sp)
     9cc:	f822                	sd	s0,48(sp)
     9ce:	f426                	sd	s1,40(sp)
     9d0:	f04a                	sd	s2,32(sp)
     9d2:	ec4e                	sd	s3,24(sp)
     9d4:	0080                	addi	s0,sp,64
     9d6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     9d8:	c299                	beqz	a3,9de <printint+0x16>
     9da:	0805c963          	bltz	a1,a6c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     9de:	2581                	sext.w	a1,a1
  neg = 0;
     9e0:	4881                	li	a7,0
     9e2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     9e6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     9e8:	2601                	sext.w	a2,a2
     9ea:	00001517          	auipc	a0,0x1
     9ee:	aa650513          	addi	a0,a0,-1370 # 1490 <digits>
     9f2:	883a                	mv	a6,a4
     9f4:	2705                	addiw	a4,a4,1
     9f6:	02c5f7bb          	remuw	a5,a1,a2
     9fa:	1782                	slli	a5,a5,0x20
     9fc:	9381                	srli	a5,a5,0x20
     9fe:	97aa                	add	a5,a5,a0
     a00:	0007c783          	lbu	a5,0(a5)
     a04:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     a08:	0005879b          	sext.w	a5,a1
     a0c:	02c5d5bb          	divuw	a1,a1,a2
     a10:	0685                	addi	a3,a3,1
     a12:	fec7f0e3          	bgeu	a5,a2,9f2 <printint+0x2a>
  if(neg)
     a16:	00088c63          	beqz	a7,a2e <printint+0x66>
    buf[i++] = '-';
     a1a:	fd070793          	addi	a5,a4,-48
     a1e:	00878733          	add	a4,a5,s0
     a22:	02d00793          	li	a5,45
     a26:	fef70823          	sb	a5,-16(a4)
     a2a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     a2e:	02e05863          	blez	a4,a5e <printint+0x96>
     a32:	fc040793          	addi	a5,s0,-64
     a36:	00e78933          	add	s2,a5,a4
     a3a:	fff78993          	addi	s3,a5,-1
     a3e:	99ba                	add	s3,s3,a4
     a40:	377d                	addiw	a4,a4,-1
     a42:	1702                	slli	a4,a4,0x20
     a44:	9301                	srli	a4,a4,0x20
     a46:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     a4a:	fff94583          	lbu	a1,-1(s2)
     a4e:	8526                	mv	a0,s1
     a50:	00000097          	auipc	ra,0x0
     a54:	f56080e7          	jalr	-170(ra) # 9a6 <putc>
  while(--i >= 0)
     a58:	197d                	addi	s2,s2,-1
     a5a:	ff3918e3          	bne	s2,s3,a4a <printint+0x82>
}
     a5e:	70e2                	ld	ra,56(sp)
     a60:	7442                	ld	s0,48(sp)
     a62:	74a2                	ld	s1,40(sp)
     a64:	7902                	ld	s2,32(sp)
     a66:	69e2                	ld	s3,24(sp)
     a68:	6121                	addi	sp,sp,64
     a6a:	8082                	ret
    x = -xx;
     a6c:	40b005bb          	negw	a1,a1
    neg = 1;
     a70:	4885                	li	a7,1
    x = -xx;
     a72:	bf85                	j	9e2 <printint+0x1a>

0000000000000a74 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     a74:	7119                	addi	sp,sp,-128
     a76:	fc86                	sd	ra,120(sp)
     a78:	f8a2                	sd	s0,112(sp)
     a7a:	f4a6                	sd	s1,104(sp)
     a7c:	f0ca                	sd	s2,96(sp)
     a7e:	ecce                	sd	s3,88(sp)
     a80:	e8d2                	sd	s4,80(sp)
     a82:	e4d6                	sd	s5,72(sp)
     a84:	e0da                	sd	s6,64(sp)
     a86:	fc5e                	sd	s7,56(sp)
     a88:	f862                	sd	s8,48(sp)
     a8a:	f466                	sd	s9,40(sp)
     a8c:	f06a                	sd	s10,32(sp)
     a8e:	ec6e                	sd	s11,24(sp)
     a90:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     a92:	0005c903          	lbu	s2,0(a1)
     a96:	18090f63          	beqz	s2,c34 <vprintf+0x1c0>
     a9a:	8aaa                	mv	s5,a0
     a9c:	8b32                	mv	s6,a2
     a9e:	00158493          	addi	s1,a1,1
  state = 0;
     aa2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     aa4:	02500a13          	li	s4,37
     aa8:	4c55                	li	s8,21
     aaa:	00001c97          	auipc	s9,0x1
     aae:	98ec8c93          	addi	s9,s9,-1650 # 1438 <get_time_perf+0x1d6>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     ab2:	02800d93          	li	s11,40
  putc(fd, 'x');
     ab6:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     ab8:	00001b97          	auipc	s7,0x1
     abc:	9d8b8b93          	addi	s7,s7,-1576 # 1490 <digits>
     ac0:	a839                	j	ade <vprintf+0x6a>
        putc(fd, c);
     ac2:	85ca                	mv	a1,s2
     ac4:	8556                	mv	a0,s5
     ac6:	00000097          	auipc	ra,0x0
     aca:	ee0080e7          	jalr	-288(ra) # 9a6 <putc>
     ace:	a019                	j	ad4 <vprintf+0x60>
    } else if(state == '%'){
     ad0:	01498d63          	beq	s3,s4,aea <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     ad4:	0485                	addi	s1,s1,1
     ad6:	fff4c903          	lbu	s2,-1(s1)
     ada:	14090d63          	beqz	s2,c34 <vprintf+0x1c0>
    if(state == 0){
     ade:	fe0999e3          	bnez	s3,ad0 <vprintf+0x5c>
      if(c == '%'){
     ae2:	ff4910e3          	bne	s2,s4,ac2 <vprintf+0x4e>
        state = '%';
     ae6:	89d2                	mv	s3,s4
     ae8:	b7f5                	j	ad4 <vprintf+0x60>
      if(c == 'd'){
     aea:	11490c63          	beq	s2,s4,c02 <vprintf+0x18e>
     aee:	f9d9079b          	addiw	a5,s2,-99
     af2:	0ff7f793          	zext.b	a5,a5
     af6:	10fc6e63          	bltu	s8,a5,c12 <vprintf+0x19e>
     afa:	f9d9079b          	addiw	a5,s2,-99
     afe:	0ff7f713          	zext.b	a4,a5
     b02:	10ec6863          	bltu	s8,a4,c12 <vprintf+0x19e>
     b06:	00271793          	slli	a5,a4,0x2
     b0a:	97e6                	add	a5,a5,s9
     b0c:	439c                	lw	a5,0(a5)
     b0e:	97e6                	add	a5,a5,s9
     b10:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     b12:	008b0913          	addi	s2,s6,8
     b16:	4685                	li	a3,1
     b18:	4629                	li	a2,10
     b1a:	000b2583          	lw	a1,0(s6)
     b1e:	8556                	mv	a0,s5
     b20:	00000097          	auipc	ra,0x0
     b24:	ea8080e7          	jalr	-344(ra) # 9c8 <printint>
     b28:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     b2a:	4981                	li	s3,0
     b2c:	b765                	j	ad4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     b2e:	008b0913          	addi	s2,s6,8
     b32:	4681                	li	a3,0
     b34:	4629                	li	a2,10
     b36:	000b2583          	lw	a1,0(s6)
     b3a:	8556                	mv	a0,s5
     b3c:	00000097          	auipc	ra,0x0
     b40:	e8c080e7          	jalr	-372(ra) # 9c8 <printint>
     b44:	8b4a                	mv	s6,s2
      state = 0;
     b46:	4981                	li	s3,0
     b48:	b771                	j	ad4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     b4a:	008b0913          	addi	s2,s6,8
     b4e:	4681                	li	a3,0
     b50:	866a                	mv	a2,s10
     b52:	000b2583          	lw	a1,0(s6)
     b56:	8556                	mv	a0,s5
     b58:	00000097          	auipc	ra,0x0
     b5c:	e70080e7          	jalr	-400(ra) # 9c8 <printint>
     b60:	8b4a                	mv	s6,s2
      state = 0;
     b62:	4981                	li	s3,0
     b64:	bf85                	j	ad4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     b66:	008b0793          	addi	a5,s6,8
     b6a:	f8f43423          	sd	a5,-120(s0)
     b6e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     b72:	03000593          	li	a1,48
     b76:	8556                	mv	a0,s5
     b78:	00000097          	auipc	ra,0x0
     b7c:	e2e080e7          	jalr	-466(ra) # 9a6 <putc>
  putc(fd, 'x');
     b80:	07800593          	li	a1,120
     b84:	8556                	mv	a0,s5
     b86:	00000097          	auipc	ra,0x0
     b8a:	e20080e7          	jalr	-480(ra) # 9a6 <putc>
     b8e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     b90:	03c9d793          	srli	a5,s3,0x3c
     b94:	97de                	add	a5,a5,s7
     b96:	0007c583          	lbu	a1,0(a5)
     b9a:	8556                	mv	a0,s5
     b9c:	00000097          	auipc	ra,0x0
     ba0:	e0a080e7          	jalr	-502(ra) # 9a6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     ba4:	0992                	slli	s3,s3,0x4
     ba6:	397d                	addiw	s2,s2,-1
     ba8:	fe0914e3          	bnez	s2,b90 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
     bac:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     bb0:	4981                	li	s3,0
     bb2:	b70d                	j	ad4 <vprintf+0x60>
        s = va_arg(ap, char*);
     bb4:	008b0913          	addi	s2,s6,8
     bb8:	000b3983          	ld	s3,0(s6)
        if(s == 0)
     bbc:	02098163          	beqz	s3,bde <vprintf+0x16a>
        while(*s != 0){
     bc0:	0009c583          	lbu	a1,0(s3)
     bc4:	c5ad                	beqz	a1,c2e <vprintf+0x1ba>
          putc(fd, *s);
     bc6:	8556                	mv	a0,s5
     bc8:	00000097          	auipc	ra,0x0
     bcc:	dde080e7          	jalr	-546(ra) # 9a6 <putc>
          s++;
     bd0:	0985                	addi	s3,s3,1
        while(*s != 0){
     bd2:	0009c583          	lbu	a1,0(s3)
     bd6:	f9e5                	bnez	a1,bc6 <vprintf+0x152>
        s = va_arg(ap, char*);
     bd8:	8b4a                	mv	s6,s2
      state = 0;
     bda:	4981                	li	s3,0
     bdc:	bde5                	j	ad4 <vprintf+0x60>
          s = "(null)";
     bde:	00001997          	auipc	s3,0x1
     be2:	85298993          	addi	s3,s3,-1966 # 1430 <get_time_perf+0x1ce>
        while(*s != 0){
     be6:	85ee                	mv	a1,s11
     be8:	bff9                	j	bc6 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
     bea:	008b0913          	addi	s2,s6,8
     bee:	000b4583          	lbu	a1,0(s6)
     bf2:	8556                	mv	a0,s5
     bf4:	00000097          	auipc	ra,0x0
     bf8:	db2080e7          	jalr	-590(ra) # 9a6 <putc>
     bfc:	8b4a                	mv	s6,s2
      state = 0;
     bfe:	4981                	li	s3,0
     c00:	bdd1                	j	ad4 <vprintf+0x60>
        putc(fd, c);
     c02:	85d2                	mv	a1,s4
     c04:	8556                	mv	a0,s5
     c06:	00000097          	auipc	ra,0x0
     c0a:	da0080e7          	jalr	-608(ra) # 9a6 <putc>
      state = 0;
     c0e:	4981                	li	s3,0
     c10:	b5d1                	j	ad4 <vprintf+0x60>
        putc(fd, '%');
     c12:	85d2                	mv	a1,s4
     c14:	8556                	mv	a0,s5
     c16:	00000097          	auipc	ra,0x0
     c1a:	d90080e7          	jalr	-624(ra) # 9a6 <putc>
        putc(fd, c);
     c1e:	85ca                	mv	a1,s2
     c20:	8556                	mv	a0,s5
     c22:	00000097          	auipc	ra,0x0
     c26:	d84080e7          	jalr	-636(ra) # 9a6 <putc>
      state = 0;
     c2a:	4981                	li	s3,0
     c2c:	b565                	j	ad4 <vprintf+0x60>
        s = va_arg(ap, char*);
     c2e:	8b4a                	mv	s6,s2
      state = 0;
     c30:	4981                	li	s3,0
     c32:	b54d                	j	ad4 <vprintf+0x60>
    }
  }
}
     c34:	70e6                	ld	ra,120(sp)
     c36:	7446                	ld	s0,112(sp)
     c38:	74a6                	ld	s1,104(sp)
     c3a:	7906                	ld	s2,96(sp)
     c3c:	69e6                	ld	s3,88(sp)
     c3e:	6a46                	ld	s4,80(sp)
     c40:	6aa6                	ld	s5,72(sp)
     c42:	6b06                	ld	s6,64(sp)
     c44:	7be2                	ld	s7,56(sp)
     c46:	7c42                	ld	s8,48(sp)
     c48:	7ca2                	ld	s9,40(sp)
     c4a:	7d02                	ld	s10,32(sp)
     c4c:	6de2                	ld	s11,24(sp)
     c4e:	6109                	addi	sp,sp,128
     c50:	8082                	ret

0000000000000c52 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     c52:	715d                	addi	sp,sp,-80
     c54:	ec06                	sd	ra,24(sp)
     c56:	e822                	sd	s0,16(sp)
     c58:	1000                	addi	s0,sp,32
     c5a:	e010                	sd	a2,0(s0)
     c5c:	e414                	sd	a3,8(s0)
     c5e:	e818                	sd	a4,16(s0)
     c60:	ec1c                	sd	a5,24(s0)
     c62:	03043023          	sd	a6,32(s0)
     c66:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     c6a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     c6e:	8622                	mv	a2,s0
     c70:	00000097          	auipc	ra,0x0
     c74:	e04080e7          	jalr	-508(ra) # a74 <vprintf>
}
     c78:	60e2                	ld	ra,24(sp)
     c7a:	6442                	ld	s0,16(sp)
     c7c:	6161                	addi	sp,sp,80
     c7e:	8082                	ret

0000000000000c80 <printf>:

void
printf(const char *fmt, ...)
{
     c80:	711d                	addi	sp,sp,-96
     c82:	ec06                	sd	ra,24(sp)
     c84:	e822                	sd	s0,16(sp)
     c86:	1000                	addi	s0,sp,32
     c88:	e40c                	sd	a1,8(s0)
     c8a:	e810                	sd	a2,16(s0)
     c8c:	ec14                	sd	a3,24(s0)
     c8e:	f018                	sd	a4,32(s0)
     c90:	f41c                	sd	a5,40(s0)
     c92:	03043823          	sd	a6,48(s0)
     c96:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     c9a:	00840613          	addi	a2,s0,8
     c9e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     ca2:	85aa                	mv	a1,a0
     ca4:	4505                	li	a0,1
     ca6:	00000097          	auipc	ra,0x0
     caa:	dce080e7          	jalr	-562(ra) # a74 <vprintf>
}
     cae:	60e2                	ld	ra,24(sp)
     cb0:	6442                	ld	s0,16(sp)
     cb2:	6125                	addi	sp,sp,96
     cb4:	8082                	ret

0000000000000cb6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     cb6:	1141                	addi	sp,sp,-16
     cb8:	e422                	sd	s0,8(sp)
     cba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     cbc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     cc0:	00001797          	auipc	a5,0x1
     cc4:	3407b783          	ld	a5,832(a5) # 2000 <freep>
     cc8:	a02d                	j	cf2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     cca:	4618                	lw	a4,8(a2)
     ccc:	9f2d                	addw	a4,a4,a1
     cce:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     cd2:	6398                	ld	a4,0(a5)
     cd4:	6310                	ld	a2,0(a4)
     cd6:	a83d                	j	d14 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     cd8:	ff852703          	lw	a4,-8(a0)
     cdc:	9f31                	addw	a4,a4,a2
     cde:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     ce0:	ff053683          	ld	a3,-16(a0)
     ce4:	a091                	j	d28 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ce6:	6398                	ld	a4,0(a5)
     ce8:	00e7e463          	bltu	a5,a4,cf0 <free+0x3a>
     cec:	00e6ea63          	bltu	a3,a4,d00 <free+0x4a>
{
     cf0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     cf2:	fed7fae3          	bgeu	a5,a3,ce6 <free+0x30>
     cf6:	6398                	ld	a4,0(a5)
     cf8:	00e6e463          	bltu	a3,a4,d00 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     cfc:	fee7eae3          	bltu	a5,a4,cf0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     d00:	ff852583          	lw	a1,-8(a0)
     d04:	6390                	ld	a2,0(a5)
     d06:	02059813          	slli	a6,a1,0x20
     d0a:	01c85713          	srli	a4,a6,0x1c
     d0e:	9736                	add	a4,a4,a3
     d10:	fae60de3          	beq	a2,a4,cca <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     d14:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     d18:	4790                	lw	a2,8(a5)
     d1a:	02061593          	slli	a1,a2,0x20
     d1e:	01c5d713          	srli	a4,a1,0x1c
     d22:	973e                	add	a4,a4,a5
     d24:	fae68ae3          	beq	a3,a4,cd8 <free+0x22>
    p->s.ptr = bp->s.ptr;
     d28:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     d2a:	00001717          	auipc	a4,0x1
     d2e:	2cf73b23          	sd	a5,726(a4) # 2000 <freep>
}
     d32:	6422                	ld	s0,8(sp)
     d34:	0141                	addi	sp,sp,16
     d36:	8082                	ret

0000000000000d38 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     d38:	7139                	addi	sp,sp,-64
     d3a:	fc06                	sd	ra,56(sp)
     d3c:	f822                	sd	s0,48(sp)
     d3e:	f426                	sd	s1,40(sp)
     d40:	f04a                	sd	s2,32(sp)
     d42:	ec4e                	sd	s3,24(sp)
     d44:	e852                	sd	s4,16(sp)
     d46:	e456                	sd	s5,8(sp)
     d48:	e05a                	sd	s6,0(sp)
     d4a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     d4c:	02051493          	slli	s1,a0,0x20
     d50:	9081                	srli	s1,s1,0x20
     d52:	04bd                	addi	s1,s1,15
     d54:	8091                	srli	s1,s1,0x4
     d56:	0014899b          	addiw	s3,s1,1
     d5a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     d5c:	00001517          	auipc	a0,0x1
     d60:	2a453503          	ld	a0,676(a0) # 2000 <freep>
     d64:	c515                	beqz	a0,d90 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     d66:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     d68:	4798                	lw	a4,8(a5)
     d6a:	02977f63          	bgeu	a4,s1,da8 <malloc+0x70>
     d6e:	8a4e                	mv	s4,s3
     d70:	0009871b          	sext.w	a4,s3
     d74:	6685                	lui	a3,0x1
     d76:	00d77363          	bgeu	a4,a3,d7c <malloc+0x44>
     d7a:	6a05                	lui	s4,0x1
     d7c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     d80:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     d84:	00001917          	auipc	s2,0x1
     d88:	27c90913          	addi	s2,s2,636 # 2000 <freep>
  if(p == (char*)-1)
     d8c:	5afd                	li	s5,-1
     d8e:	a895                	j	e02 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
     d90:	00001797          	auipc	a5,0x1
     d94:	28078793          	addi	a5,a5,640 # 2010 <base>
     d98:	00001717          	auipc	a4,0x1
     d9c:	26f73423          	sd	a5,616(a4) # 2000 <freep>
     da0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     da2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     da6:	b7e1                	j	d6e <malloc+0x36>
      if(p->s.size == nunits)
     da8:	02e48c63          	beq	s1,a4,de0 <malloc+0xa8>
        p->s.size -= nunits;
     dac:	4137073b          	subw	a4,a4,s3
     db0:	c798                	sw	a4,8(a5)
        p += p->s.size;
     db2:	02071693          	slli	a3,a4,0x20
     db6:	01c6d713          	srli	a4,a3,0x1c
     dba:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
     dbc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
     dc0:	00001717          	auipc	a4,0x1
     dc4:	24a73023          	sd	a0,576(a4) # 2000 <freep>
      return (void*)(p + 1);
     dc8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
     dcc:	70e2                	ld	ra,56(sp)
     dce:	7442                	ld	s0,48(sp)
     dd0:	74a2                	ld	s1,40(sp)
     dd2:	7902                	ld	s2,32(sp)
     dd4:	69e2                	ld	s3,24(sp)
     dd6:	6a42                	ld	s4,16(sp)
     dd8:	6aa2                	ld	s5,8(sp)
     dda:	6b02                	ld	s6,0(sp)
     ddc:	6121                	addi	sp,sp,64
     dde:	8082                	ret
        prevp->s.ptr = p->s.ptr;
     de0:	6398                	ld	a4,0(a5)
     de2:	e118                	sd	a4,0(a0)
     de4:	bff1                	j	dc0 <malloc+0x88>
  hp->s.size = nu;
     de6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
     dea:	0541                	addi	a0,a0,16
     dec:	00000097          	auipc	ra,0x0
     df0:	eca080e7          	jalr	-310(ra) # cb6 <free>
  return freep;
     df4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
     df8:	d971                	beqz	a0,dcc <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     dfa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     dfc:	4798                	lw	a4,8(a5)
     dfe:	fa9775e3          	bgeu	a4,s1,da8 <malloc+0x70>
    if(p == freep)
     e02:	00093703          	ld	a4,0(s2)
     e06:	853e                	mv	a0,a5
     e08:	fef719e3          	bne	a4,a5,dfa <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
     e0c:	8552                	mv	a0,s4
     e0e:	00000097          	auipc	ra,0x0
     e12:	b40080e7          	jalr	-1216(ra) # 94e <sbrk>
  if(p == (char*)-1)
     e16:	fd5518e3          	bne	a0,s5,de6 <malloc+0xae>
        return 0;
     e1a:	4501                	li	a0,0
     e1c:	bf45                	j	dcc <malloc+0x94>

0000000000000e1e <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
     e1e:	c1d9                	beqz	a1,ea4 <head_run+0x86>
void head_run(int fd, int numOfLines){
     e20:	dd010113          	addi	sp,sp,-560
     e24:	22113423          	sd	ra,552(sp)
     e28:	22813023          	sd	s0,544(sp)
     e2c:	20913c23          	sd	s1,536(sp)
     e30:	21213823          	sd	s2,528(sp)
     e34:	21313423          	sd	s3,520(sp)
     e38:	21413023          	sd	s4,512(sp)
     e3c:	1c00                	addi	s0,sp,560
     e3e:	892a                	mv	s2,a0
     e40:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
     e44:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
     e46:	00000a17          	auipc	s4,0x0
     e4a:	68aa0a13          	addi	s4,s4,1674 # 14d0 <digits+0x40>
		readStatus = read_line(fd, line);
     e4e:	dd840593          	addi	a1,s0,-552
     e52:	854a                	mv	a0,s2
     e54:	00000097          	auipc	ra,0x0
     e58:	394080e7          	jalr	916(ra) # 11e8 <read_line>
		if (readStatus == READ_ERROR){
     e5c:	01350d63          	beq	a0,s3,e76 <head_run+0x58>
		if (readStatus == READ_EOF)
     e60:	c11d                	beqz	a0,e86 <head_run+0x68>
		printf("%s",line);
     e62:	dd840593          	addi	a1,s0,-552
     e66:	8552                	mv	a0,s4
     e68:	00000097          	auipc	ra,0x0
     e6c:	e18080e7          	jalr	-488(ra) # c80 <printf>
	while(numOfLines--){
     e70:	34fd                	addiw	s1,s1,-1
     e72:	fcf1                	bnez	s1,e4e <head_run+0x30>
     e74:	a809                	j	e86 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
     e76:	00000517          	auipc	a0,0x0
     e7a:	63250513          	addi	a0,a0,1586 # 14a8 <digits+0x18>
     e7e:	00000097          	auipc	ra,0x0
     e82:	e02080e7          	jalr	-510(ra) # c80 <printf>

	}
}
     e86:	22813083          	ld	ra,552(sp)
     e8a:	22013403          	ld	s0,544(sp)
     e8e:	21813483          	ld	s1,536(sp)
     e92:	21013903          	ld	s2,528(sp)
     e96:	20813983          	ld	s3,520(sp)
     e9a:	20013a03          	ld	s4,512(sp)
     e9e:	23010113          	addi	sp,sp,560
     ea2:	8082                	ret
     ea4:	8082                	ret

0000000000000ea6 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
     ea6:	ba010113          	addi	sp,sp,-1120
     eaa:	44113c23          	sd	ra,1112(sp)
     eae:	44813823          	sd	s0,1104(sp)
     eb2:	44913423          	sd	s1,1096(sp)
     eb6:	45213023          	sd	s2,1088(sp)
     eba:	43313c23          	sd	s3,1080(sp)
     ebe:	43413823          	sd	s4,1072(sp)
     ec2:	43513423          	sd	s5,1064(sp)
     ec6:	43613023          	sd	s6,1056(sp)
     eca:	41713c23          	sd	s7,1048(sp)
     ece:	41813823          	sd	s8,1040(sp)
     ed2:	41913423          	sd	s9,1032(sp)
     ed6:	41a13023          	sd	s10,1024(sp)
     eda:	3fb13c23          	sd	s11,1016(sp)
     ede:	46010413          	addi	s0,sp,1120
     ee2:	89aa                	mv	s3,a0
     ee4:	8aae                	mv	s5,a1
     ee6:	8c32                	mv	s8,a2
     ee8:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
     eea:	d9840593          	addi	a1,s0,-616
     eee:	00000097          	auipc	ra,0x0
     ef2:	2fa080e7          	jalr	762(ra) # 11e8 <read_line>


  if (readStatus == READ_ERROR)
     ef6:	57fd                	li	a5,-1
     ef8:	04f50163          	beq	a0,a5,f3a <uniq_run+0x94>
     efc:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
     efe:	ed21                	bnez	a0,f56 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
     f00:	45813083          	ld	ra,1112(sp)
     f04:	45013403          	ld	s0,1104(sp)
     f08:	44813483          	ld	s1,1096(sp)
     f0c:	44013903          	ld	s2,1088(sp)
     f10:	43813983          	ld	s3,1080(sp)
     f14:	43013a03          	ld	s4,1072(sp)
     f18:	42813a83          	ld	s5,1064(sp)
     f1c:	42013b03          	ld	s6,1056(sp)
     f20:	41813b83          	ld	s7,1048(sp)
     f24:	41013c03          	ld	s8,1040(sp)
     f28:	40813c83          	ld	s9,1032(sp)
     f2c:	40013d03          	ld	s10,1024(sp)
     f30:	3f813d83          	ld	s11,1016(sp)
     f34:	46010113          	addi	sp,sp,1120
     f38:	8082                	ret
    printf("[ERR] Error reading from the file ");
     f3a:	00000517          	auipc	a0,0x0
     f3e:	59e50513          	addi	a0,a0,1438 # 14d8 <digits+0x48>
     f42:	00000097          	auipc	ra,0x0
     f46:	d3e080e7          	jalr	-706(ra) # c80 <printf>
     f4a:	bf5d                	j	f00 <uniq_run+0x5a>
     f4c:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
     f4e:	8926                	mv	s2,s1
     f50:	84be                	mv	s1,a5
        lineCount = 1;
     f52:	8b6a                	mv	s6,s10
     f54:	a8ed                	j	104e <uniq_run+0x1a8>
    int lineCount=1;
     f56:	4b05                	li	s6,1
  char * line2 = buffer2;
     f58:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
     f5c:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
     f60:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
     f62:	4d05                	li	s10,1
              printf("%s",line1);
     f64:	00000d97          	auipc	s11,0x0
     f68:	56cd8d93          	addi	s11,s11,1388 # 14d0 <digits+0x40>
     f6c:	a0cd                	j	104e <uniq_run+0x1a8>
            if (repeatedLines){
     f6e:	020a0b63          	beqz	s4,fa4 <uniq_run+0xfe>
                if (isRepeated){
     f72:	f80b87e3          	beqz	s7,f00 <uniq_run+0x5a>
                    if (showCount)
     f76:	000c0d63          	beqz	s8,f90 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
     f7a:	864a                	mv	a2,s2
     f7c:	85da                	mv	a1,s6
     f7e:	00000517          	auipc	a0,0x0
     f82:	58250513          	addi	a0,a0,1410 # 1500 <digits+0x70>
     f86:	00000097          	auipc	ra,0x0
     f8a:	cfa080e7          	jalr	-774(ra) # c80 <printf>
     f8e:	bf8d                	j	f00 <uniq_run+0x5a>
                      printf("%s",line1);
     f90:	85ca                	mv	a1,s2
     f92:	00000517          	auipc	a0,0x0
     f96:	53e50513          	addi	a0,a0,1342 # 14d0 <digits+0x40>
     f9a:	00000097          	auipc	ra,0x0
     f9e:	ce6080e7          	jalr	-794(ra) # c80 <printf>
     fa2:	bfb9                	j	f00 <uniq_run+0x5a>
                if (showCount)
     fa4:	000c0d63          	beqz	s8,fbe <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
     fa8:	864a                	mv	a2,s2
     faa:	85da                	mv	a1,s6
     fac:	00000517          	auipc	a0,0x0
     fb0:	55450513          	addi	a0,a0,1364 # 1500 <digits+0x70>
     fb4:	00000097          	auipc	ra,0x0
     fb8:	ccc080e7          	jalr	-820(ra) # c80 <printf>
     fbc:	b791                	j	f00 <uniq_run+0x5a>
                  printf("%s",line1);
     fbe:	85ca                	mv	a1,s2
     fc0:	00000517          	auipc	a0,0x0
     fc4:	51050513          	addi	a0,a0,1296 # 14d0 <digits+0x40>
     fc8:	00000097          	auipc	ra,0x0
     fcc:	cb8080e7          	jalr	-840(ra) # c80 <printf>
     fd0:	bf05                	j	f00 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
     fd2:	00000517          	auipc	a0,0x0
     fd6:	53650513          	addi	a0,a0,1334 # 1508 <digits+0x78>
     fda:	00000097          	auipc	ra,0x0
     fde:	ca6080e7          	jalr	-858(ra) # c80 <printf>
          break;
     fe2:	bf39                	j	f00 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
     fe4:	85a6                	mv	a1,s1
     fe6:	854a                	mv	a0,s2
     fe8:	00000097          	auipc	ra,0x0
     fec:	110080e7          	jalr	272(ra) # 10f8 <compare_str_ic>
     ff0:	a041                	j	1070 <uniq_run+0x1ca>
                  printf("%s",line1);
     ff2:	85ca                	mv	a1,s2
     ff4:	856e                	mv	a0,s11
     ff6:	00000097          	auipc	ra,0x0
     ffa:	c8a080e7          	jalr	-886(ra) # c80 <printf>
        lineCount = 1;
     ffe:	8b5e                	mv	s6,s7
                  printf("%s",line1);
    1000:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    1002:	8926                	mv	s2,s1
                  printf("%s",line1);
    1004:	84be                	mv	s1,a5
        isRepeated = 0 ;
    1006:	4b81                	li	s7,0
    1008:	a099                	j	104e <uniq_run+0x1a8>
            if (showCount)
    100a:	020c0263          	beqz	s8,102e <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
    100e:	864a                	mv	a2,s2
    1010:	85da                	mv	a1,s6
    1012:	00000517          	auipc	a0,0x0
    1016:	4ee50513          	addi	a0,a0,1262 # 1500 <digits+0x70>
    101a:	00000097          	auipc	ra,0x0
    101e:	c66080e7          	jalr	-922(ra) # c80 <printf>
    1022:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    1024:	8926                	mv	s2,s1
    1026:	84be                	mv	s1,a5
        isRepeated = 0 ;
    1028:	4b81                	li	s7,0
        lineCount = 1;
    102a:	8b6a                	mv	s6,s10
    102c:	a00d                	j	104e <uniq_run+0x1a8>
              printf("%s",line1);
    102e:	85ca                	mv	a1,s2
    1030:	856e                	mv	a0,s11
    1032:	00000097          	auipc	ra,0x0
    1036:	c4e080e7          	jalr	-946(ra) # c80 <printf>
    103a:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    103c:	8926                	mv	s2,s1
              printf("%s",line1);
    103e:	84be                	mv	s1,a5
        isRepeated = 0 ;
    1040:	4b81                	li	s7,0
        lineCount = 1;
    1042:	8b6a                	mv	s6,s10
    1044:	a029                	j	104e <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
    1046:	000a0363          	beqz	s4,104c <uniq_run+0x1a6>
    104a:	8bea                	mv	s7,s10
          lineCount++;
    104c:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
    104e:	85a6                	mv	a1,s1
    1050:	854e                	mv	a0,s3
    1052:	00000097          	auipc	ra,0x0
    1056:	196080e7          	jalr	406(ra) # 11e8 <read_line>
        if (readStatus == READ_EOF){
    105a:	d911                	beqz	a0,f6e <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
    105c:	f7950be3          	beq	a0,s9,fd2 <uniq_run+0x12c>
        if (!ignoreCase)
    1060:	f80a92e3          	bnez	s5,fe4 <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
    1064:	85a6                	mv	a1,s1
    1066:	854a                	mv	a0,s2
    1068:	00000097          	auipc	ra,0x0
    106c:	062080e7          	jalr	98(ra) # 10ca <compare_str>
        if (compareStatus != 0){ 
    1070:	d979                	beqz	a0,1046 <uniq_run+0x1a0>
          if (repeatedLines){
    1072:	f80a0ce3          	beqz	s4,100a <uniq_run+0x164>
            if (isRepeated){
    1076:	ec0b8be3          	beqz	s7,f4c <uniq_run+0xa6>
                if (showCount)
    107a:	f60c0ce3          	beqz	s8,ff2 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
    107e:	864a                	mv	a2,s2
    1080:	85da                	mv	a1,s6
    1082:	00000517          	auipc	a0,0x0
    1086:	47e50513          	addi	a0,a0,1150 # 1500 <digits+0x70>
    108a:	00000097          	auipc	ra,0x0
    108e:	bf6080e7          	jalr	-1034(ra) # c80 <printf>
        lineCount = 1;
    1092:	8b5e                	mv	s6,s7
    1094:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    1096:	8926                	mv	s2,s1
    1098:	84be                	mv	s1,a5
        isRepeated = 0 ;
    109a:	4b81                	li	s7,0
    109c:	bf4d                	j	104e <uniq_run+0x1a8>

000000000000109e <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
    109e:	1141                	addi	sp,sp,-16
    10a0:	e422                	sd	s0,8(sp)
    10a2:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
    10a4:	00054783          	lbu	a5,0(a0)
    10a8:	cf99                	beqz	a5,10c6 <get_strlen+0x28>
    10aa:	00150713          	addi	a4,a0,1
    10ae:	87ba                	mv	a5,a4
    10b0:	4685                	li	a3,1
    10b2:	9e99                	subw	a3,a3,a4
    10b4:	00f6853b          	addw	a0,a3,a5
    10b8:	0785                	addi	a5,a5,1
    10ba:	fff7c703          	lbu	a4,-1(a5)
    10be:	fb7d                	bnez	a4,10b4 <get_strlen+0x16>
	return len;
}
    10c0:	6422                	ld	s0,8(sp)
    10c2:	0141                	addi	sp,sp,16
    10c4:	8082                	ret
	int len = 0;
    10c6:	4501                	li	a0,0
    10c8:	bfe5                	j	10c0 <get_strlen+0x22>

00000000000010ca <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
    10ca:	1141                	addi	sp,sp,-16
    10cc:	e422                	sd	s0,8(sp)
    10ce:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
    10d0:	00054783          	lbu	a5,0(a0)
    10d4:	cb91                	beqz	a5,10e8 <compare_str+0x1e>
    10d6:	0005c703          	lbu	a4,0(a1)
    10da:	c719                	beqz	a4,10e8 <compare_str+0x1e>
		if (*s1++ != *s2++)
    10dc:	0505                	addi	a0,a0,1
    10de:	0585                	addi	a1,a1,1
    10e0:	fee788e3          	beq	a5,a4,10d0 <compare_str+0x6>
			return 1;
    10e4:	4505                	li	a0,1
    10e6:	a031                	j	10f2 <compare_str+0x28>
	}
	if (*s1 == *s2)
    10e8:	0005c503          	lbu	a0,0(a1)
    10ec:	8d1d                	sub	a0,a0,a5
			return 1;
    10ee:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    10f2:	6422                	ld	s0,8(sp)
    10f4:	0141                	addi	sp,sp,16
    10f6:	8082                	ret

00000000000010f8 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
    10f8:	1141                	addi	sp,sp,-16
    10fa:	e422                	sd	s0,8(sp)
    10fc:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
    10fe:	4665                	li	a2,25
	while(*s1 && *s2){
    1100:	a019                	j	1106 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
    1102:	04e79763          	bne	a5,a4,1150 <compare_str_ic+0x58>
	while(*s1 && *s2){
    1106:	00054783          	lbu	a5,0(a0)
    110a:	cb9d                	beqz	a5,1140 <compare_str_ic+0x48>
    110c:	0005c703          	lbu	a4,0(a1)
    1110:	cb05                	beqz	a4,1140 <compare_str_ic+0x48>
		char b1 = *s1++;
    1112:	0505                	addi	a0,a0,1
		char b2 = *s2++;
    1114:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
    1116:	fbf7869b          	addiw	a3,a5,-65
    111a:	0ff6f693          	zext.b	a3,a3
    111e:	00d66663          	bltu	a2,a3,112a <compare_str_ic+0x32>
			b1 += 32;
    1122:	0207879b          	addiw	a5,a5,32
    1126:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
    112a:	fbf7069b          	addiw	a3,a4,-65
    112e:	0ff6f693          	zext.b	a3,a3
    1132:	fcd668e3          	bltu	a2,a3,1102 <compare_str_ic+0xa>
			b2 += 32;
    1136:	0207071b          	addiw	a4,a4,32
    113a:	0ff77713          	zext.b	a4,a4
    113e:	b7d1                	j	1102 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
    1140:	0005c503          	lbu	a0,0(a1)
    1144:	8d1d                	sub	a0,a0,a5
			return 1;
    1146:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    114a:	6422                	ld	s0,8(sp)
    114c:	0141                	addi	sp,sp,16
    114e:	8082                	ret
			return 1;
    1150:	4505                	li	a0,1
    1152:	bfe5                	j	114a <compare_str_ic+0x52>

0000000000001154 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
    1154:	7179                	addi	sp,sp,-48
    1156:	f406                	sd	ra,40(sp)
    1158:	f022                	sd	s0,32(sp)
    115a:	ec26                	sd	s1,24(sp)
    115c:	e84a                	sd	s2,16(sp)
    115e:	e44e                	sd	s3,8(sp)
    1160:	1800                	addi	s0,sp,48
    1162:	89aa                	mv	s3,a0
    1164:	892e                	mv	s2,a1
    int M = get_strlen(s1);
    1166:	00000097          	auipc	ra,0x0
    116a:	f38080e7          	jalr	-200(ra) # 109e <get_strlen>
    116e:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
    1170:	854a                	mv	a0,s2
    1172:	00000097          	auipc	ra,0x0
    1176:	f2c080e7          	jalr	-212(ra) # 109e <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
    117a:	409505bb          	subw	a1,a0,s1
    117e:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
    1180:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
    1182:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
    1184:	0005da63          	bgez	a1,1198 <check_substr+0x44>
    1188:	a81d                	j	11be <check_substr+0x6a>
        if (j == M)
    118a:	02f48a63          	beq	s1,a5,11be <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
    118e:	0885                	addi	a7,a7,1
    1190:	0008879b          	sext.w	a5,a7
    1194:	02f5cc63          	blt	a1,a5,11cc <check_substr+0x78>
    1198:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
    119c:	011906b3          	add	a3,s2,a7
    11a0:	874e                	mv	a4,s3
    11a2:	879a                	mv	a5,t1
    11a4:	fe9053e3          	blez	s1,118a <check_substr+0x36>
            if (s2[i + j] != s1[j])
    11a8:	0006c803          	lbu	a6,0(a3) # 1000 <uniq_run+0x15a>
    11ac:	00074603          	lbu	a2,0(a4)
    11b0:	fcc81de3          	bne	a6,a2,118a <check_substr+0x36>
        for (j = 0; j < M; j++)
    11b4:	2785                	addiw	a5,a5,1
    11b6:	0685                	addi	a3,a3,1
    11b8:	0705                	addi	a4,a4,1
    11ba:	fef497e3          	bne	s1,a5,11a8 <check_substr+0x54>
}
    11be:	70a2                	ld	ra,40(sp)
    11c0:	7402                	ld	s0,32(sp)
    11c2:	64e2                	ld	s1,24(sp)
    11c4:	6942                	ld	s2,16(sp)
    11c6:	69a2                	ld	s3,8(sp)
    11c8:	6145                	addi	sp,sp,48
    11ca:	8082                	ret
    return -1;
    11cc:	557d                	li	a0,-1
    11ce:	bfc5                	j	11be <check_substr+0x6a>

00000000000011d0 <open_file>:
	filePath: File's path
	flag: Manipulation flag

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * filePath, int flag){
    11d0:	1141                	addi	sp,sp,-16
    11d2:	e406                	sd	ra,8(sp)
    11d4:	e022                	sd	s0,0(sp)
    11d6:	0800                	addi	s0,sp,16
	int fd = open(filePath, flag);
    11d8:	fffff097          	auipc	ra,0xfffff
    11dc:	72e080e7          	jalr	1838(ra) # 906 <open>
	return fd;
}
    11e0:	60a2                	ld	ra,8(sp)
    11e2:	6402                	ld	s0,0(sp)
    11e4:	0141                	addi	sp,sp,16
    11e6:	8082                	ret

00000000000011e8 <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
    11e8:	7139                	addi	sp,sp,-64
    11ea:	fc06                	sd	ra,56(sp)
    11ec:	f822                	sd	s0,48(sp)
    11ee:	f426                	sd	s1,40(sp)
    11f0:	f04a                	sd	s2,32(sp)
    11f2:	ec4e                	sd	s3,24(sp)
    11f4:	e852                	sd	s4,16(sp)
    11f6:	0080                	addi	s0,sp,64
    11f8:	89aa                	mv	s3,a0
    11fa:	84ae                	mv	s1,a1

	char readByte;
	int byteCount = 0;
    11fc:	4901                	li	s2,0
		// }
		*buffer++ = readByte;
		byteCount++;


		if (readByte == '\n'){
    11fe:	4a29                	li	s4,10
		readStatus = read(fd,&readByte,1);
    1200:	4605                	li	a2,1
    1202:	fcf40593          	addi	a1,s0,-49
    1206:	854e                	mv	a0,s3
    1208:	fffff097          	auipc	ra,0xfffff
    120c:	6d6080e7          	jalr	1750(ra) # 8de <read>
		if (readStatus == 0){
    1210:	c505                	beqz	a0,1238 <read_line+0x50>
		*buffer++ = readByte;
    1212:	0485                	addi	s1,s1,1
    1214:	fcf44783          	lbu	a5,-49(s0)
    1218:	fef48fa3          	sb	a5,-1(s1)
		byteCount++;
    121c:	2905                	addiw	s2,s2,1
		if (readByte == '\n'){
    121e:	ff4791e3          	bne	a5,s4,1200 <read_line+0x18>
			*buffer = 0;  // Nullifying the end of the string
    1222:	00048023          	sb	zero,0(s1)
			return byteCount;
		}
	}
}
    1226:	854a                	mv	a0,s2
    1228:	70e2                	ld	ra,56(sp)
    122a:	7442                	ld	s0,48(sp)
    122c:	74a2                	ld	s1,40(sp)
    122e:	7902                	ld	s2,32(sp)
    1230:	69e2                	ld	s3,24(sp)
    1232:	6a42                	ld	s4,16(sp)
    1234:	6121                	addi	sp,sp,64
    1236:	8082                	ret
			if (byteCount!=0){
    1238:	fe0907e3          	beqz	s2,1226 <read_line+0x3e>
				*buffer = '\n';
    123c:	47a9                	li	a5,10
    123e:	00f48023          	sb	a5,0(s1)
				*(buffer+1)=0;
    1242:	000480a3          	sb	zero,1(s1)
				return byteCount+1;
    1246:	2905                	addiw	s2,s2,1
    1248:	bff9                	j	1226 <read_line+0x3e>

000000000000124a <close_file>:
	fd: File discriptor

[OUTPUT]:

*/
void close_file(int fd){
    124a:	1141                	addi	sp,sp,-16
    124c:	e406                	sd	ra,8(sp)
    124e:	e022                	sd	s0,0(sp)
    1250:	0800                	addi	s0,sp,16
	close(fd);
    1252:	fffff097          	auipc	ra,0xfffff
    1256:	69c080e7          	jalr	1692(ra) # 8ee <close>
}
    125a:	60a2                	ld	ra,8(sp)
    125c:	6402                	ld	s0,0(sp)
    125e:	0141                	addi	sp,sp,16
    1260:	8082                	ret

0000000000001262 <get_time_perf>:
#include "user/user.h"
#include "gelibs/time.h"



e_time_t get_time_perf(char **argv){
    1262:	7139                	addi	sp,sp,-64
    1264:	fc06                	sd	ra,56(sp)
    1266:	f822                	sd	s0,48(sp)
    1268:	f426                	sd	s1,40(sp)
    126a:	f04a                	sd	s2,32(sp)
    126c:	0080                	addi	s0,sp,64
    126e:	84aa                	mv	s1,a0
    1270:	892e                	mv	s2,a1

	int pid;

	if ((pid=fork())==0){
    1272:	fffff097          	auipc	ra,0xfffff
    1276:	64c080e7          	jalr	1612(ra) # 8be <fork>
    127a:	ed19                	bnez	a0,1298 <get_time_perf+0x36>
		exec(argv[0],argv);
    127c:	85ca                	mv	a1,s2
    127e:	00093503          	ld	a0,0(s2)
    1282:	fffff097          	auipc	ra,0xfffff
    1286:	67c080e7          	jalr	1660(ra) # 8fe <exec>
		/* Get the currect child's timing information with its pid */
		times(pid , &time);

		return time;
	}
    128a:	8526                	mv	a0,s1
    128c:	70e2                	ld	ra,56(sp)
    128e:	7442                	ld	s0,48(sp)
    1290:	74a2                	ld	s1,40(sp)
    1292:	7902                	ld	s2,32(sp)
    1294:	6121                	addi	sp,sp,64
    1296:	8082                	ret
		times(pid , &time);
    1298:	fc040593          	addi	a1,s0,-64
    129c:	fffff097          	auipc	ra,0xfffff
    12a0:	6e2080e7          	jalr	1762(ra) # 97e <times>
		return time;
    12a4:	fc043783          	ld	a5,-64(s0)
    12a8:	e09c                	sd	a5,0(s1)
    12aa:	fc843783          	ld	a5,-56(s0)
    12ae:	e49c                	sd	a5,8(s1)
    12b0:	fd043783          	ld	a5,-48(s0)
    12b4:	e89c                	sd	a5,16(s1)
    12b6:	fd843783          	ld	a5,-40(s0)
    12ba:	ec9c                	sd	a5,24(s1)
    12bc:	b7f9                	j	128a <get_time_perf+0x28>
