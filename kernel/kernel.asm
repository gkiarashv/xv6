
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	b9013103          	ld	sp,-1136(sp) # 80009b90 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	074000ef          	jal	ra,8000008a <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.1000000
  int interval = 10000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	6609                	lui	a2,0x2
    8000003e:	71060613          	addi	a2,a2,1808 # 2710 <_entry-0x7fffd8f0>
    80000042:	9732                	add	a4,a4,a2
    80000044:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000046:	00259693          	slli	a3,a1,0x2
    8000004a:	96ae                	add	a3,a3,a1
    8000004c:	068e                	slli	a3,a3,0x3
    8000004e:	0000a717          	auipc	a4,0xa
    80000052:	ba270713          	addi	a4,a4,-1118 # 80009bf0 <timer_scratch>
    80000056:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80000058:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005a:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005c:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000060:	00006797          	auipc	a5,0x6
    80000064:	1b078793          	addi	a5,a5,432 # 80006210 <timervec>
    80000068:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000070:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000078:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007c:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000080:	30479073          	csrw	mie,a5
}
    80000084:	6422                	ld	s0,8(sp)
    80000086:	0141                	addi	sp,sp,16
    80000088:	8082                	ret

000000008000008a <start>:
{
    8000008a:	1141                	addi	sp,sp,-16
    8000008c:	e406                	sd	ra,8(sp)
    8000008e:	e022                	sd	s0,0(sp)
    80000090:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000092:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000096:	7779                	lui	a4,0xffffe
    80000098:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdad9f>
    8000009c:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009e:	6705                	lui	a4,0x1
    800000a0:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a6:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000aa:	00001797          	auipc	a5,0x1
    800000ae:	dcc78793          	addi	a5,a5,-564 # 80000e76 <main>
    800000b2:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b6:	4781                	li	a5,0
    800000b8:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000bc:	67c1                	lui	a5,0x10
    800000be:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c0:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c4:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c8:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000cc:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d0:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d4:	57fd                	li	a5,-1
    800000d6:	83a9                	srli	a5,a5,0xa
    800000d8:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000dc:	47bd                	li	a5,15
    800000de:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e2:	00000097          	auipc	ra,0x0
    800000e6:	f3a080e7          	jalr	-198(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ea:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000ee:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f0:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f2:	30200073          	mret
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000fe:	715d                	addi	sp,sp,-80
    80000100:	e486                	sd	ra,72(sp)
    80000102:	e0a2                	sd	s0,64(sp)
    80000104:	fc26                	sd	s1,56(sp)
    80000106:	f84a                	sd	s2,48(sp)
    80000108:	f44e                	sd	s3,40(sp)
    8000010a:	f052                	sd	s4,32(sp)
    8000010c:	ec56                	sd	s5,24(sp)
    8000010e:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000110:	04c05763          	blez	a2,8000015e <consolewrite+0x60>
    80000114:	8a2a                	mv	s4,a0
    80000116:	84ae                	mv	s1,a1
    80000118:	89b2                	mv	s3,a2
    8000011a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011c:	5afd                	li	s5,-1
    8000011e:	4685                	li	a3,1
    80000120:	8626                	mv	a2,s1
    80000122:	85d2                	mv	a1,s4
    80000124:	fbf40513          	addi	a0,s0,-65
    80000128:	00002097          	auipc	ra,0x2
    8000012c:	458080e7          	jalr	1112(ra) # 80002580 <either_copyin>
    80000130:	01550d63          	beq	a0,s5,8000014a <consolewrite+0x4c>
      break;
    uartputc(c);
    80000134:	fbf44503          	lbu	a0,-65(s0)
    80000138:	00000097          	auipc	ra,0x0
    8000013c:	784080e7          	jalr	1924(ra) # 800008bc <uartputc>
  for(i = 0; i < n; i++){
    80000140:	2905                	addiw	s2,s2,1
    80000142:	0485                	addi	s1,s1,1
    80000144:	fd299de3          	bne	s3,s2,8000011e <consolewrite+0x20>
    80000148:	894e                	mv	s2,s3
  }

  return i;
}
    8000014a:	854a                	mv	a0,s2
    8000014c:	60a6                	ld	ra,72(sp)
    8000014e:	6406                	ld	s0,64(sp)
    80000150:	74e2                	ld	s1,56(sp)
    80000152:	7942                	ld	s2,48(sp)
    80000154:	79a2                	ld	s3,40(sp)
    80000156:	7a02                	ld	s4,32(sp)
    80000158:	6ae2                	ld	s5,24(sp)
    8000015a:	6161                	addi	sp,sp,80
    8000015c:	8082                	ret
  for(i = 0; i < n; i++){
    8000015e:	4901                	li	s2,0
    80000160:	b7ed                	j	8000014a <consolewrite+0x4c>

0000000080000162 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000162:	7159                	addi	sp,sp,-112
    80000164:	f486                	sd	ra,104(sp)
    80000166:	f0a2                	sd	s0,96(sp)
    80000168:	eca6                	sd	s1,88(sp)
    8000016a:	e8ca                	sd	s2,80(sp)
    8000016c:	e4ce                	sd	s3,72(sp)
    8000016e:	e0d2                	sd	s4,64(sp)
    80000170:	fc56                	sd	s5,56(sp)
    80000172:	f85a                	sd	s6,48(sp)
    80000174:	f45e                	sd	s7,40(sp)
    80000176:	f062                	sd	s8,32(sp)
    80000178:	ec66                	sd	s9,24(sp)
    8000017a:	e86a                	sd	s10,16(sp)
    8000017c:	1880                	addi	s0,sp,112
    8000017e:	8aaa                	mv	s5,a0
    80000180:	8a2e                	mv	s4,a1
    80000182:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000184:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000188:	00012517          	auipc	a0,0x12
    8000018c:	ba850513          	addi	a0,a0,-1112 # 80011d30 <cons>
    80000190:	00001097          	auipc	ra,0x1
    80000194:	a44080e7          	jalr	-1468(ra) # 80000bd4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000198:	00012497          	auipc	s1,0x12
    8000019c:	b9848493          	addi	s1,s1,-1128 # 80011d30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a0:	00012917          	auipc	s2,0x12
    800001a4:	c2890913          	addi	s2,s2,-984 # 80011dc8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001a8:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001aa:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ac:	4ca9                	li	s9,10
  while(n > 0){
    800001ae:	07305b63          	blez	s3,80000224 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	02f71763          	bne	a4,a5,800001e8 <consoleread+0x86>
      if(killed(myproc())){
    800001be:	00001097          	auipc	ra,0x1
    800001c2:	7ec080e7          	jalr	2028(ra) # 800019aa <myproc>
    800001c6:	00002097          	auipc	ra,0x2
    800001ca:	1f8080e7          	jalr	504(ra) # 800023be <killed>
    800001ce:	e535                	bnez	a0,8000023a <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d0:	85a6                	mv	a1,s1
    800001d2:	854a                	mv	a0,s2
    800001d4:	00002097          	auipc	ra,0x2
    800001d8:	f1e080e7          	jalr	-226(ra) # 800020f2 <sleep>
    while(cons.r == cons.w){
    800001dc:	0984a783          	lw	a5,152(s1)
    800001e0:	09c4a703          	lw	a4,156(s1)
    800001e4:	fcf70de3          	beq	a4,a5,800001be <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	0017871b          	addiw	a4,a5,1
    800001ec:	08e4ac23          	sw	a4,152(s1)
    800001f0:	07f7f713          	andi	a4,a5,127
    800001f4:	9726                	add	a4,a4,s1
    800001f6:	01874703          	lbu	a4,24(a4)
    800001fa:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001fe:	077d0563          	beq	s10,s7,80000268 <consoleread+0x106>
    cbuf = c;
    80000202:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000206:	4685                	li	a3,1
    80000208:	f9f40613          	addi	a2,s0,-97
    8000020c:	85d2                	mv	a1,s4
    8000020e:	8556                	mv	a0,s5
    80000210:	00002097          	auipc	ra,0x2
    80000214:	31a080e7          	jalr	794(ra) # 8000252a <either_copyout>
    80000218:	01850663          	beq	a0,s8,80000224 <consoleread+0xc2>
    dst++;
    8000021c:	0a05                	addi	s4,s4,1
    --n;
    8000021e:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000220:	f99d17e3          	bne	s10,s9,800001ae <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000224:	00012517          	auipc	a0,0x12
    80000228:	b0c50513          	addi	a0,a0,-1268 # 80011d30 <cons>
    8000022c:	00001097          	auipc	ra,0x1
    80000230:	a5c080e7          	jalr	-1444(ra) # 80000c88 <release>

  return target - n;
    80000234:	413b053b          	subw	a0,s6,s3
    80000238:	a811                	j	8000024c <consoleread+0xea>
        release(&cons.lock);
    8000023a:	00012517          	auipc	a0,0x12
    8000023e:	af650513          	addi	a0,a0,-1290 # 80011d30 <cons>
    80000242:	00001097          	auipc	ra,0x1
    80000246:	a46080e7          	jalr	-1466(ra) # 80000c88 <release>
        return -1;
    8000024a:	557d                	li	a0,-1
}
    8000024c:	70a6                	ld	ra,104(sp)
    8000024e:	7406                	ld	s0,96(sp)
    80000250:	64e6                	ld	s1,88(sp)
    80000252:	6946                	ld	s2,80(sp)
    80000254:	69a6                	ld	s3,72(sp)
    80000256:	6a06                	ld	s4,64(sp)
    80000258:	7ae2                	ld	s5,56(sp)
    8000025a:	7b42                	ld	s6,48(sp)
    8000025c:	7ba2                	ld	s7,40(sp)
    8000025e:	7c02                	ld	s8,32(sp)
    80000260:	6ce2                	ld	s9,24(sp)
    80000262:	6d42                	ld	s10,16(sp)
    80000264:	6165                	addi	sp,sp,112
    80000266:	8082                	ret
      if(n < target){
    80000268:	0009871b          	sext.w	a4,s3
    8000026c:	fb677ce3          	bgeu	a4,s6,80000224 <consoleread+0xc2>
        cons.r--;
    80000270:	00012717          	auipc	a4,0x12
    80000274:	b4f72c23          	sw	a5,-1192(a4) # 80011dc8 <cons+0x98>
    80000278:	b775                	j	80000224 <consoleread+0xc2>

000000008000027a <consputc>:
{
    8000027a:	1141                	addi	sp,sp,-16
    8000027c:	e406                	sd	ra,8(sp)
    8000027e:	e022                	sd	s0,0(sp)
    80000280:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000282:	10000793          	li	a5,256
    80000286:	00f50a63          	beq	a0,a5,8000029a <consputc+0x20>
    uartputc_sync(c);
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	560080e7          	jalr	1376(ra) # 800007ea <uartputc_sync>
}
    80000292:	60a2                	ld	ra,8(sp)
    80000294:	6402                	ld	s0,0(sp)
    80000296:	0141                	addi	sp,sp,16
    80000298:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029a:	4521                	li	a0,8
    8000029c:	00000097          	auipc	ra,0x0
    800002a0:	54e080e7          	jalr	1358(ra) # 800007ea <uartputc_sync>
    800002a4:	02000513          	li	a0,32
    800002a8:	00000097          	auipc	ra,0x0
    800002ac:	542080e7          	jalr	1346(ra) # 800007ea <uartputc_sync>
    800002b0:	4521                	li	a0,8
    800002b2:	00000097          	auipc	ra,0x0
    800002b6:	538080e7          	jalr	1336(ra) # 800007ea <uartputc_sync>
    800002ba:	bfe1                	j	80000292 <consputc+0x18>

00000000800002bc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002bc:	1101                	addi	sp,sp,-32
    800002be:	ec06                	sd	ra,24(sp)
    800002c0:	e822                	sd	s0,16(sp)
    800002c2:	e426                	sd	s1,8(sp)
    800002c4:	e04a                	sd	s2,0(sp)
    800002c6:	1000                	addi	s0,sp,32
    800002c8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002ca:	00012517          	auipc	a0,0x12
    800002ce:	a6650513          	addi	a0,a0,-1434 # 80011d30 <cons>
    800002d2:	00001097          	auipc	ra,0x1
    800002d6:	902080e7          	jalr	-1790(ra) # 80000bd4 <acquire>

  switch(c){
    800002da:	47d5                	li	a5,21
    800002dc:	0af48663          	beq	s1,a5,80000388 <consoleintr+0xcc>
    800002e0:	0297ca63          	blt	a5,s1,80000314 <consoleintr+0x58>
    800002e4:	47a1                	li	a5,8
    800002e6:	0ef48763          	beq	s1,a5,800003d4 <consoleintr+0x118>
    800002ea:	47c1                	li	a5,16
    800002ec:	10f49a63          	bne	s1,a5,80000400 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f0:	00002097          	auipc	ra,0x2
    800002f4:	2e6080e7          	jalr	742(ra) # 800025d6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002f8:	00012517          	auipc	a0,0x12
    800002fc:	a3850513          	addi	a0,a0,-1480 # 80011d30 <cons>
    80000300:	00001097          	auipc	ra,0x1
    80000304:	988080e7          	jalr	-1656(ra) # 80000c88 <release>
}
    80000308:	60e2                	ld	ra,24(sp)
    8000030a:	6442                	ld	s0,16(sp)
    8000030c:	64a2                	ld	s1,8(sp)
    8000030e:	6902                	ld	s2,0(sp)
    80000310:	6105                	addi	sp,sp,32
    80000312:	8082                	ret
  switch(c){
    80000314:	07f00793          	li	a5,127
    80000318:	0af48e63          	beq	s1,a5,800003d4 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031c:	00012717          	auipc	a4,0x12
    80000320:	a1470713          	addi	a4,a4,-1516 # 80011d30 <cons>
    80000324:	0a072783          	lw	a5,160(a4)
    80000328:	09872703          	lw	a4,152(a4)
    8000032c:	9f99                	subw	a5,a5,a4
    8000032e:	07f00713          	li	a4,127
    80000332:	fcf763e3          	bltu	a4,a5,800002f8 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000336:	47b5                	li	a5,13
    80000338:	0cf48763          	beq	s1,a5,80000406 <consoleintr+0x14a>
      consputc(c);
    8000033c:	8526                	mv	a0,s1
    8000033e:	00000097          	auipc	ra,0x0
    80000342:	f3c080e7          	jalr	-196(ra) # 8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000346:	00012797          	auipc	a5,0x12
    8000034a:	9ea78793          	addi	a5,a5,-1558 # 80011d30 <cons>
    8000034e:	0a07a683          	lw	a3,160(a5)
    80000352:	0016871b          	addiw	a4,a3,1
    80000356:	0007061b          	sext.w	a2,a4
    8000035a:	0ae7a023          	sw	a4,160(a5)
    8000035e:	07f6f693          	andi	a3,a3,127
    80000362:	97b6                	add	a5,a5,a3
    80000364:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000368:	47a9                	li	a5,10
    8000036a:	0cf48563          	beq	s1,a5,80000434 <consoleintr+0x178>
    8000036e:	4791                	li	a5,4
    80000370:	0cf48263          	beq	s1,a5,80000434 <consoleintr+0x178>
    80000374:	00012797          	auipc	a5,0x12
    80000378:	a547a783          	lw	a5,-1452(a5) # 80011dc8 <cons+0x98>
    8000037c:	9f1d                	subw	a4,a4,a5
    8000037e:	08000793          	li	a5,128
    80000382:	f6f71be3          	bne	a4,a5,800002f8 <consoleintr+0x3c>
    80000386:	a07d                	j	80000434 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000388:	00012717          	auipc	a4,0x12
    8000038c:	9a870713          	addi	a4,a4,-1624 # 80011d30 <cons>
    80000390:	0a072783          	lw	a5,160(a4)
    80000394:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000398:	00012497          	auipc	s1,0x12
    8000039c:	99848493          	addi	s1,s1,-1640 # 80011d30 <cons>
    while(cons.e != cons.w &&
    800003a0:	4929                	li	s2,10
    800003a2:	f4f70be3          	beq	a4,a5,800002f8 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a6:	37fd                	addiw	a5,a5,-1
    800003a8:	07f7f713          	andi	a4,a5,127
    800003ac:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ae:	01874703          	lbu	a4,24(a4)
    800003b2:	f52703e3          	beq	a4,s2,800002f8 <consoleintr+0x3c>
      cons.e--;
    800003b6:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003ba:	10000513          	li	a0,256
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	ebc080e7          	jalr	-324(ra) # 8000027a <consputc>
    while(cons.e != cons.w &&
    800003c6:	0a04a783          	lw	a5,160(s1)
    800003ca:	09c4a703          	lw	a4,156(s1)
    800003ce:	fcf71ce3          	bne	a4,a5,800003a6 <consoleintr+0xea>
    800003d2:	b71d                	j	800002f8 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d4:	00012717          	auipc	a4,0x12
    800003d8:	95c70713          	addi	a4,a4,-1700 # 80011d30 <cons>
    800003dc:	0a072783          	lw	a5,160(a4)
    800003e0:	09c72703          	lw	a4,156(a4)
    800003e4:	f0f70ae3          	beq	a4,a5,800002f8 <consoleintr+0x3c>
      cons.e--;
    800003e8:	37fd                	addiw	a5,a5,-1
    800003ea:	00012717          	auipc	a4,0x12
    800003ee:	9ef72323          	sw	a5,-1562(a4) # 80011dd0 <cons+0xa0>
      consputc(BACKSPACE);
    800003f2:	10000513          	li	a0,256
    800003f6:	00000097          	auipc	ra,0x0
    800003fa:	e84080e7          	jalr	-380(ra) # 8000027a <consputc>
    800003fe:	bded                	j	800002f8 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000400:	ee048ce3          	beqz	s1,800002f8 <consoleintr+0x3c>
    80000404:	bf21                	j	8000031c <consoleintr+0x60>
      consputc(c);
    80000406:	4529                	li	a0,10
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	e72080e7          	jalr	-398(ra) # 8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000410:	00012797          	auipc	a5,0x12
    80000414:	92078793          	addi	a5,a5,-1760 # 80011d30 <cons>
    80000418:	0a07a703          	lw	a4,160(a5)
    8000041c:	0017069b          	addiw	a3,a4,1
    80000420:	0006861b          	sext.w	a2,a3
    80000424:	0ad7a023          	sw	a3,160(a5)
    80000428:	07f77713          	andi	a4,a4,127
    8000042c:	97ba                	add	a5,a5,a4
    8000042e:	4729                	li	a4,10
    80000430:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000434:	00012797          	auipc	a5,0x12
    80000438:	98c7ac23          	sw	a2,-1640(a5) # 80011dcc <cons+0x9c>
        wakeup(&cons.r);
    8000043c:	00012517          	auipc	a0,0x12
    80000440:	98c50513          	addi	a0,a0,-1652 # 80011dc8 <cons+0x98>
    80000444:	00002097          	auipc	ra,0x2
    80000448:	d12080e7          	jalr	-750(ra) # 80002156 <wakeup>
    8000044c:	b575                	j	800002f8 <consoleintr+0x3c>

000000008000044e <consoleinit>:

void
consoleinit(void)
{
    8000044e:	1141                	addi	sp,sp,-16
    80000450:	e406                	sd	ra,8(sp)
    80000452:	e022                	sd	s0,0(sp)
    80000454:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000456:	00009597          	auipc	a1,0x9
    8000045a:	bba58593          	addi	a1,a1,-1094 # 80009010 <etext+0x10>
    8000045e:	00012517          	auipc	a0,0x12
    80000462:	8d250513          	addi	a0,a0,-1838 # 80011d30 <cons>
    80000466:	00000097          	auipc	ra,0x0
    8000046a:	6de080e7          	jalr	1758(ra) # 80000b44 <initlock>

  uartinit();
    8000046e:	00000097          	auipc	ra,0x0
    80000472:	32c080e7          	jalr	812(ra) # 8000079a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000476:	00022797          	auipc	a5,0x22
    8000047a:	45278793          	addi	a5,a5,1106 # 800228c8 <devsw>
    8000047e:	00000717          	auipc	a4,0x0
    80000482:	ce470713          	addi	a4,a4,-796 # 80000162 <consoleread>
    80000486:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000488:	00000717          	auipc	a4,0x0
    8000048c:	c7670713          	addi	a4,a4,-906 # 800000fe <consolewrite>
    80000490:	ef98                	sd	a4,24(a5)
}
    80000492:	60a2                	ld	ra,8(sp)
    80000494:	6402                	ld	s0,0(sp)
    80000496:	0141                	addi	sp,sp,16
    80000498:	8082                	ret

000000008000049a <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049a:	7179                	addi	sp,sp,-48
    8000049c:	f406                	sd	ra,40(sp)
    8000049e:	f022                	sd	s0,32(sp)
    800004a0:	ec26                	sd	s1,24(sp)
    800004a2:	e84a                	sd	s2,16(sp)
    800004a4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a6:	c219                	beqz	a2,800004ac <printint+0x12>
    800004a8:	08054763          	bltz	a0,80000536 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ac:	2501                	sext.w	a0,a0
    800004ae:	4881                	li	a7,0
    800004b0:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b6:	2581                	sext.w	a1,a1
    800004b8:	00009617          	auipc	a2,0x9
    800004bc:	b8860613          	addi	a2,a2,-1144 # 80009040 <digits>
    800004c0:	883a                	mv	a6,a4
    800004c2:	2705                	addiw	a4,a4,1
    800004c4:	02b577bb          	remuw	a5,a0,a1
    800004c8:	1782                	slli	a5,a5,0x20
    800004ca:	9381                	srli	a5,a5,0x20
    800004cc:	97b2                	add	a5,a5,a2
    800004ce:	0007c783          	lbu	a5,0(a5)
    800004d2:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d6:	0005079b          	sext.w	a5,a0
    800004da:	02b5553b          	divuw	a0,a0,a1
    800004de:	0685                	addi	a3,a3,1
    800004e0:	feb7f0e3          	bgeu	a5,a1,800004c0 <printint+0x26>

  if(sign)
    800004e4:	00088c63          	beqz	a7,800004fc <printint+0x62>
    buf[i++] = '-';
    800004e8:	fe070793          	addi	a5,a4,-32
    800004ec:	00878733          	add	a4,a5,s0
    800004f0:	02d00793          	li	a5,45
    800004f4:	fef70823          	sb	a5,-16(a4)
    800004f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fc:	02e05763          	blez	a4,8000052a <printint+0x90>
    80000500:	fd040793          	addi	a5,s0,-48
    80000504:	00e784b3          	add	s1,a5,a4
    80000508:	fff78913          	addi	s2,a5,-1
    8000050c:	993a                	add	s2,s2,a4
    8000050e:	377d                	addiw	a4,a4,-1
    80000510:	1702                	slli	a4,a4,0x20
    80000512:	9301                	srli	a4,a4,0x20
    80000514:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000518:	fff4c503          	lbu	a0,-1(s1)
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	d5e080e7          	jalr	-674(ra) # 8000027a <consputc>
  while(--i >= 0)
    80000524:	14fd                	addi	s1,s1,-1
    80000526:	ff2499e3          	bne	s1,s2,80000518 <printint+0x7e>
}
    8000052a:	70a2                	ld	ra,40(sp)
    8000052c:	7402                	ld	s0,32(sp)
    8000052e:	64e2                	ld	s1,24(sp)
    80000530:	6942                	ld	s2,16(sp)
    80000532:	6145                	addi	sp,sp,48
    80000534:	8082                	ret
    x = -xx;
    80000536:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053a:	4885                	li	a7,1
    x = -xx;
    8000053c:	bf95                	j	800004b0 <printint+0x16>

000000008000053e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053e:	1101                	addi	sp,sp,-32
    80000540:	ec06                	sd	ra,24(sp)
    80000542:	e822                	sd	s0,16(sp)
    80000544:	e426                	sd	s1,8(sp)
    80000546:	1000                	addi	s0,sp,32
    80000548:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054a:	00012797          	auipc	a5,0x12
    8000054e:	8a07a323          	sw	zero,-1882(a5) # 80011df0 <pr+0x18>
  printf("panic: ");
    80000552:	00009517          	auipc	a0,0x9
    80000556:	ac650513          	addi	a0,a0,-1338 # 80009018 <etext+0x18>
    8000055a:	00000097          	auipc	ra,0x0
    8000055e:	02e080e7          	jalr	46(ra) # 80000588 <printf>
  printf(s);
    80000562:	8526                	mv	a0,s1
    80000564:	00000097          	auipc	ra,0x0
    80000568:	024080e7          	jalr	36(ra) # 80000588 <printf>
  printf("\n");
    8000056c:	00009517          	auipc	a0,0x9
    80000570:	5c450513          	addi	a0,a0,1476 # 80009b30 <syscalls+0x6e0>
    80000574:	00000097          	auipc	ra,0x0
    80000578:	014080e7          	jalr	20(ra) # 80000588 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057c:	4785                	li	a5,1
    8000057e:	00009717          	auipc	a4,0x9
    80000582:	62f72923          	sw	a5,1586(a4) # 80009bb0 <panicked>
  for(;;)
    80000586:	a001                	j	80000586 <panic+0x48>

0000000080000588 <printf>:
{
    80000588:	7131                	addi	sp,sp,-192
    8000058a:	fc86                	sd	ra,120(sp)
    8000058c:	f8a2                	sd	s0,112(sp)
    8000058e:	f4a6                	sd	s1,104(sp)
    80000590:	f0ca                	sd	s2,96(sp)
    80000592:	ecce                	sd	s3,88(sp)
    80000594:	e8d2                	sd	s4,80(sp)
    80000596:	e4d6                	sd	s5,72(sp)
    80000598:	e0da                	sd	s6,64(sp)
    8000059a:	fc5e                	sd	s7,56(sp)
    8000059c:	f862                	sd	s8,48(sp)
    8000059e:	f466                	sd	s9,40(sp)
    800005a0:	f06a                	sd	s10,32(sp)
    800005a2:	ec6e                	sd	s11,24(sp)
    800005a4:	0100                	addi	s0,sp,128
    800005a6:	8a2a                	mv	s4,a0
    800005a8:	e40c                	sd	a1,8(s0)
    800005aa:	e810                	sd	a2,16(s0)
    800005ac:	ec14                	sd	a3,24(s0)
    800005ae:	f018                	sd	a4,32(s0)
    800005b0:	f41c                	sd	a5,40(s0)
    800005b2:	03043823          	sd	a6,48(s0)
    800005b6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ba:	00012d97          	auipc	s11,0x12
    800005be:	836dad83          	lw	s11,-1994(s11) # 80011df0 <pr+0x18>
  if(locking)
    800005c2:	020d9b63          	bnez	s11,800005f8 <printf+0x70>
  if (fmt == 0)
    800005c6:	040a0263          	beqz	s4,8000060a <printf+0x82>
  va_start(ap, fmt);
    800005ca:	00840793          	addi	a5,s0,8
    800005ce:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d2:	000a4503          	lbu	a0,0(s4)
    800005d6:	14050f63          	beqz	a0,80000734 <printf+0x1ac>
    800005da:	4981                	li	s3,0
    if(c != '%'){
    800005dc:	02500a93          	li	s5,37
    switch(c){
    800005e0:	07000b93          	li	s7,112
  consputc('x');
    800005e4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e6:	00009b17          	auipc	s6,0x9
    800005ea:	a5ab0b13          	addi	s6,s6,-1446 # 80009040 <digits>
    switch(c){
    800005ee:	07300c93          	li	s9,115
    800005f2:	06400c13          	li	s8,100
    800005f6:	a82d                	j	80000630 <printf+0xa8>
    acquire(&pr.lock);
    800005f8:	00011517          	auipc	a0,0x11
    800005fc:	7e050513          	addi	a0,a0,2016 # 80011dd8 <pr>
    80000600:	00000097          	auipc	ra,0x0
    80000604:	5d4080e7          	jalr	1492(ra) # 80000bd4 <acquire>
    80000608:	bf7d                	j	800005c6 <printf+0x3e>
    panic("null fmt");
    8000060a:	00009517          	auipc	a0,0x9
    8000060e:	a1e50513          	addi	a0,a0,-1506 # 80009028 <etext+0x28>
    80000612:	00000097          	auipc	ra,0x0
    80000616:	f2c080e7          	jalr	-212(ra) # 8000053e <panic>
      consputc(c);
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	c60080e7          	jalr	-928(ra) # 8000027a <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000622:	2985                	addiw	s3,s3,1
    80000624:	013a07b3          	add	a5,s4,s3
    80000628:	0007c503          	lbu	a0,0(a5)
    8000062c:	10050463          	beqz	a0,80000734 <printf+0x1ac>
    if(c != '%'){
    80000630:	ff5515e3          	bne	a0,s5,8000061a <printf+0x92>
    c = fmt[++i] & 0xff;
    80000634:	2985                	addiw	s3,s3,1
    80000636:	013a07b3          	add	a5,s4,s3
    8000063a:	0007c783          	lbu	a5,0(a5)
    8000063e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000642:	cbed                	beqz	a5,80000734 <printf+0x1ac>
    switch(c){
    80000644:	05778a63          	beq	a5,s7,80000698 <printf+0x110>
    80000648:	02fbf663          	bgeu	s7,a5,80000674 <printf+0xec>
    8000064c:	09978863          	beq	a5,s9,800006dc <printf+0x154>
    80000650:	07800713          	li	a4,120
    80000654:	0ce79563          	bne	a5,a4,8000071e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4605                	li	a2,1
    80000666:	85ea                	mv	a1,s10
    80000668:	4388                	lw	a0,0(a5)
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	e30080e7          	jalr	-464(ra) # 8000049a <printint>
      break;
    80000672:	bf45                	j	80000622 <printf+0x9a>
    switch(c){
    80000674:	09578f63          	beq	a5,s5,80000712 <printf+0x18a>
    80000678:	0b879363          	bne	a5,s8,8000071e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067c:	f8843783          	ld	a5,-120(s0)
    80000680:	00878713          	addi	a4,a5,8
    80000684:	f8e43423          	sd	a4,-120(s0)
    80000688:	4605                	li	a2,1
    8000068a:	45a9                	li	a1,10
    8000068c:	4388                	lw	a0,0(a5)
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	e0c080e7          	jalr	-500(ra) # 8000049a <printint>
      break;
    80000696:	b771                	j	80000622 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000698:	f8843783          	ld	a5,-120(s0)
    8000069c:	00878713          	addi	a4,a5,8
    800006a0:	f8e43423          	sd	a4,-120(s0)
    800006a4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a8:	03000513          	li	a0,48
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	bce080e7          	jalr	-1074(ra) # 8000027a <consputc>
  consputc('x');
    800006b4:	07800513          	li	a0,120
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bc2080e7          	jalr	-1086(ra) # 8000027a <consputc>
    800006c0:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c2:	03c95793          	srli	a5,s2,0x3c
    800006c6:	97da                	add	a5,a5,s6
    800006c8:	0007c503          	lbu	a0,0(a5)
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	bae080e7          	jalr	-1106(ra) # 8000027a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d4:	0912                	slli	s2,s2,0x4
    800006d6:	34fd                	addiw	s1,s1,-1
    800006d8:	f4ed                	bnez	s1,800006c2 <printf+0x13a>
    800006da:	b7a1                	j	80000622 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	6384                	ld	s1,0(a5)
    800006ea:	cc89                	beqz	s1,80000704 <printf+0x17c>
      for(; *s; s++)
    800006ec:	0004c503          	lbu	a0,0(s1)
    800006f0:	d90d                	beqz	a0,80000622 <printf+0x9a>
        consputc(*s);
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	b88080e7          	jalr	-1144(ra) # 8000027a <consputc>
      for(; *s; s++)
    800006fa:	0485                	addi	s1,s1,1
    800006fc:	0004c503          	lbu	a0,0(s1)
    80000700:	f96d                	bnez	a0,800006f2 <printf+0x16a>
    80000702:	b705                	j	80000622 <printf+0x9a>
        s = "(null)";
    80000704:	00009497          	auipc	s1,0x9
    80000708:	91c48493          	addi	s1,s1,-1764 # 80009020 <etext+0x20>
      for(; *s; s++)
    8000070c:	02800513          	li	a0,40
    80000710:	b7cd                	j	800006f2 <printf+0x16a>
      consputc('%');
    80000712:	8556                	mv	a0,s5
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b66080e7          	jalr	-1178(ra) # 8000027a <consputc>
      break;
    8000071c:	b719                	j	80000622 <printf+0x9a>
      consputc('%');
    8000071e:	8556                	mv	a0,s5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b5a080e7          	jalr	-1190(ra) # 8000027a <consputc>
      consputc(c);
    80000728:	8526                	mv	a0,s1
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b50080e7          	jalr	-1200(ra) # 8000027a <consputc>
      break;
    80000732:	bdc5                	j	80000622 <printf+0x9a>
  if(locking)
    80000734:	020d9163          	bnez	s11,80000756 <printf+0x1ce>
}
    80000738:	70e6                	ld	ra,120(sp)
    8000073a:	7446                	ld	s0,112(sp)
    8000073c:	74a6                	ld	s1,104(sp)
    8000073e:	7906                	ld	s2,96(sp)
    80000740:	69e6                	ld	s3,88(sp)
    80000742:	6a46                	ld	s4,80(sp)
    80000744:	6aa6                	ld	s5,72(sp)
    80000746:	6b06                	ld	s6,64(sp)
    80000748:	7be2                	ld	s7,56(sp)
    8000074a:	7c42                	ld	s8,48(sp)
    8000074c:	7ca2                	ld	s9,40(sp)
    8000074e:	7d02                	ld	s10,32(sp)
    80000750:	6de2                	ld	s11,24(sp)
    80000752:	6129                	addi	sp,sp,192
    80000754:	8082                	ret
    release(&pr.lock);
    80000756:	00011517          	auipc	a0,0x11
    8000075a:	68250513          	addi	a0,a0,1666 # 80011dd8 <pr>
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	52a080e7          	jalr	1322(ra) # 80000c88 <release>
}
    80000766:	bfc9                	j	80000738 <printf+0x1b0>

0000000080000768 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000768:	1101                	addi	sp,sp,-32
    8000076a:	ec06                	sd	ra,24(sp)
    8000076c:	e822                	sd	s0,16(sp)
    8000076e:	e426                	sd	s1,8(sp)
    80000770:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000772:	00011497          	auipc	s1,0x11
    80000776:	66648493          	addi	s1,s1,1638 # 80011dd8 <pr>
    8000077a:	00009597          	auipc	a1,0x9
    8000077e:	8be58593          	addi	a1,a1,-1858 # 80009038 <etext+0x38>
    80000782:	8526                	mv	a0,s1
    80000784:	00000097          	auipc	ra,0x0
    80000788:	3c0080e7          	jalr	960(ra) # 80000b44 <initlock>
  pr.locking = 1;
    8000078c:	4785                	li	a5,1
    8000078e:	cc9c                	sw	a5,24(s1)
}
    80000790:	60e2                	ld	ra,24(sp)
    80000792:	6442                	ld	s0,16(sp)
    80000794:	64a2                	ld	s1,8(sp)
    80000796:	6105                	addi	sp,sp,32
    80000798:	8082                	ret

000000008000079a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079a:	1141                	addi	sp,sp,-16
    8000079c:	e406                	sd	ra,8(sp)
    8000079e:	e022                	sd	s0,0(sp)
    800007a0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a2:	100007b7          	lui	a5,0x10000
    800007a6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007aa:	f8000713          	li	a4,-128
    800007ae:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b2:	470d                	li	a4,3
    800007b4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007bc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c0:	469d                	li	a3,7
    800007c2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ca:	00009597          	auipc	a1,0x9
    800007ce:	88e58593          	addi	a1,a1,-1906 # 80009058 <digits+0x18>
    800007d2:	00011517          	auipc	a0,0x11
    800007d6:	62650513          	addi	a0,a0,1574 # 80011df8 <uart_tx_lock>
    800007da:	00000097          	auipc	ra,0x0
    800007de:	36a080e7          	jalr	874(ra) # 80000b44 <initlock>
}
    800007e2:	60a2                	ld	ra,8(sp)
    800007e4:	6402                	ld	s0,0(sp)
    800007e6:	0141                	addi	sp,sp,16
    800007e8:	8082                	ret

00000000800007ea <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ea:	1101                	addi	sp,sp,-32
    800007ec:	ec06                	sd	ra,24(sp)
    800007ee:	e822                	sd	s0,16(sp)
    800007f0:	e426                	sd	s1,8(sp)
    800007f2:	1000                	addi	s0,sp,32
    800007f4:	84aa                	mv	s1,a0
  push_off();
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	392080e7          	jalr	914(ra) # 80000b88 <push_off>

  if(panicked){
    800007fe:	00009797          	auipc	a5,0x9
    80000802:	3b27a783          	lw	a5,946(a5) # 80009bb0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000806:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080a:	c391                	beqz	a5,8000080e <uartputc_sync+0x24>
    for(;;)
    8000080c:	a001                	j	8000080c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000812:	0207f793          	andi	a5,a5,32
    80000816:	dfe5                	beqz	a5,8000080e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000818:	0ff4f513          	zext.b	a0,s1
    8000081c:	100007b7          	lui	a5,0x10000
    80000820:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000824:	00000097          	auipc	ra,0x0
    80000828:	404080e7          	jalr	1028(ra) # 80000c28 <pop_off>
}
    8000082c:	60e2                	ld	ra,24(sp)
    8000082e:	6442                	ld	s0,16(sp)
    80000830:	64a2                	ld	s1,8(sp)
    80000832:	6105                	addi	sp,sp,32
    80000834:	8082                	ret

0000000080000836 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000836:	00009797          	auipc	a5,0x9
    8000083a:	3827b783          	ld	a5,898(a5) # 80009bb8 <uart_tx_r>
    8000083e:	00009717          	auipc	a4,0x9
    80000842:	38273703          	ld	a4,898(a4) # 80009bc0 <uart_tx_w>
    80000846:	06f70a63          	beq	a4,a5,800008ba <uartstart+0x84>
{
    8000084a:	7139                	addi	sp,sp,-64
    8000084c:	fc06                	sd	ra,56(sp)
    8000084e:	f822                	sd	s0,48(sp)
    80000850:	f426                	sd	s1,40(sp)
    80000852:	f04a                	sd	s2,32(sp)
    80000854:	ec4e                	sd	s3,24(sp)
    80000856:	e852                	sd	s4,16(sp)
    80000858:	e456                	sd	s5,8(sp)
    8000085a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000860:	00011a17          	auipc	s4,0x11
    80000864:	598a0a13          	addi	s4,s4,1432 # 80011df8 <uart_tx_lock>
    uart_tx_r += 1;
    80000868:	00009497          	auipc	s1,0x9
    8000086c:	35048493          	addi	s1,s1,848 # 80009bb8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000870:	00009997          	auipc	s3,0x9
    80000874:	35098993          	addi	s3,s3,848 # 80009bc0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000878:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087c:	02077713          	andi	a4,a4,32
    80000880:	c705                	beqz	a4,800008a8 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000882:	01f7f713          	andi	a4,a5,31
    80000886:	9752                	add	a4,a4,s4
    80000888:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088c:	0785                	addi	a5,a5,1
    8000088e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000890:	8526                	mv	a0,s1
    80000892:	00002097          	auipc	ra,0x2
    80000896:	8c4080e7          	jalr	-1852(ra) # 80002156 <wakeup>
    
    WriteReg(THR, c);
    8000089a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089e:	609c                	ld	a5,0(s1)
    800008a0:	0009b703          	ld	a4,0(s3)
    800008a4:	fcf71ae3          	bne	a4,a5,80000878 <uartstart+0x42>
  }
}
    800008a8:	70e2                	ld	ra,56(sp)
    800008aa:	7442                	ld	s0,48(sp)
    800008ac:	74a2                	ld	s1,40(sp)
    800008ae:	7902                	ld	s2,32(sp)
    800008b0:	69e2                	ld	s3,24(sp)
    800008b2:	6a42                	ld	s4,16(sp)
    800008b4:	6aa2                	ld	s5,8(sp)
    800008b6:	6121                	addi	sp,sp,64
    800008b8:	8082                	ret
    800008ba:	8082                	ret

00000000800008bc <uartputc>:
{
    800008bc:	7179                	addi	sp,sp,-48
    800008be:	f406                	sd	ra,40(sp)
    800008c0:	f022                	sd	s0,32(sp)
    800008c2:	ec26                	sd	s1,24(sp)
    800008c4:	e84a                	sd	s2,16(sp)
    800008c6:	e44e                	sd	s3,8(sp)
    800008c8:	e052                	sd	s4,0(sp)
    800008ca:	1800                	addi	s0,sp,48
    800008cc:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ce:	00011517          	auipc	a0,0x11
    800008d2:	52a50513          	addi	a0,a0,1322 # 80011df8 <uart_tx_lock>
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	2fe080e7          	jalr	766(ra) # 80000bd4 <acquire>
  if(panicked){
    800008de:	00009797          	auipc	a5,0x9
    800008e2:	2d27a783          	lw	a5,722(a5) # 80009bb0 <panicked>
    800008e6:	e7c9                	bnez	a5,80000970 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e8:	00009717          	auipc	a4,0x9
    800008ec:	2d873703          	ld	a4,728(a4) # 80009bc0 <uart_tx_w>
    800008f0:	00009797          	auipc	a5,0x9
    800008f4:	2c87b783          	ld	a5,712(a5) # 80009bb8 <uart_tx_r>
    800008f8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fc:	00011997          	auipc	s3,0x11
    80000900:	4fc98993          	addi	s3,s3,1276 # 80011df8 <uart_tx_lock>
    80000904:	00009497          	auipc	s1,0x9
    80000908:	2b448493          	addi	s1,s1,692 # 80009bb8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090c:	00009917          	auipc	s2,0x9
    80000910:	2b490913          	addi	s2,s2,692 # 80009bc0 <uart_tx_w>
    80000914:	00e79f63          	bne	a5,a4,80000932 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000918:	85ce                	mv	a1,s3
    8000091a:	8526                	mv	a0,s1
    8000091c:	00001097          	auipc	ra,0x1
    80000920:	7d6080e7          	jalr	2006(ra) # 800020f2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000924:	00093703          	ld	a4,0(s2)
    80000928:	609c                	ld	a5,0(s1)
    8000092a:	02078793          	addi	a5,a5,32
    8000092e:	fee785e3          	beq	a5,a4,80000918 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000932:	00011497          	auipc	s1,0x11
    80000936:	4c648493          	addi	s1,s1,1222 # 80011df8 <uart_tx_lock>
    8000093a:	01f77793          	andi	a5,a4,31
    8000093e:	97a6                	add	a5,a5,s1
    80000940:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000944:	0705                	addi	a4,a4,1
    80000946:	00009797          	auipc	a5,0x9
    8000094a:	26e7bd23          	sd	a4,634(a5) # 80009bc0 <uart_tx_w>
  uartstart();
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	ee8080e7          	jalr	-280(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    80000956:	8526                	mv	a0,s1
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	330080e7          	jalr	816(ra) # 80000c88 <release>
}
    80000960:	70a2                	ld	ra,40(sp)
    80000962:	7402                	ld	s0,32(sp)
    80000964:	64e2                	ld	s1,24(sp)
    80000966:	6942                	ld	s2,16(sp)
    80000968:	69a2                	ld	s3,8(sp)
    8000096a:	6a02                	ld	s4,0(sp)
    8000096c:	6145                	addi	sp,sp,48
    8000096e:	8082                	ret
    for(;;)
    80000970:	a001                	j	80000970 <uartputc+0xb4>

0000000080000972 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000972:	1141                	addi	sp,sp,-16
    80000974:	e422                	sd	s0,8(sp)
    80000976:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000978:	100007b7          	lui	a5,0x10000
    8000097c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000980:	8b85                	andi	a5,a5,1
    80000982:	cb81                	beqz	a5,80000992 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000984:	100007b7          	lui	a5,0x10000
    80000988:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000098c:	6422                	ld	s0,8(sp)
    8000098e:	0141                	addi	sp,sp,16
    80000990:	8082                	ret
    return -1;
    80000992:	557d                	li	a0,-1
    80000994:	bfe5                	j	8000098c <uartgetc+0x1a>

0000000080000996 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000996:	1101                	addi	sp,sp,-32
    80000998:	ec06                	sd	ra,24(sp)
    8000099a:	e822                	sd	s0,16(sp)
    8000099c:	e426                	sd	s1,8(sp)
    8000099e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a0:	54fd                	li	s1,-1
    800009a2:	a029                	j	800009ac <uartintr+0x16>
      break;
    consoleintr(c);
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	918080e7          	jalr	-1768(ra) # 800002bc <consoleintr>
    int c = uartgetc();
    800009ac:	00000097          	auipc	ra,0x0
    800009b0:	fc6080e7          	jalr	-58(ra) # 80000972 <uartgetc>
    if(c == -1)
    800009b4:	fe9518e3          	bne	a0,s1,800009a4 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009b8:	00011497          	auipc	s1,0x11
    800009bc:	44048493          	addi	s1,s1,1088 # 80011df8 <uart_tx_lock>
    800009c0:	8526                	mv	a0,s1
    800009c2:	00000097          	auipc	ra,0x0
    800009c6:	212080e7          	jalr	530(ra) # 80000bd4 <acquire>
  uartstart();
    800009ca:	00000097          	auipc	ra,0x0
    800009ce:	e6c080e7          	jalr	-404(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    800009d2:	8526                	mv	a0,s1
    800009d4:	00000097          	auipc	ra,0x0
    800009d8:	2b4080e7          	jalr	692(ra) # 80000c88 <release>
}
    800009dc:	60e2                	ld	ra,24(sp)
    800009de:	6442                	ld	s0,16(sp)
    800009e0:	64a2                	ld	s1,8(sp)
    800009e2:	6105                	addi	sp,sp,32
    800009e4:	8082                	ret

00000000800009e6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e6:	1101                	addi	sp,sp,-32
    800009e8:	ec06                	sd	ra,24(sp)
    800009ea:	e822                	sd	s0,16(sp)
    800009ec:	e426                	sd	s1,8(sp)
    800009ee:	e04a                	sd	s2,0(sp)
    800009f0:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f2:	03451793          	slli	a5,a0,0x34
    800009f6:	ebb9                	bnez	a5,80000a4c <kfree+0x66>
    800009f8:	84aa                	mv	s1,a0
    800009fa:	00023797          	auipc	a5,0x23
    800009fe:	06678793          	addi	a5,a5,102 # 80023a60 <end>
    80000a02:	04f56563          	bltu	a0,a5,80000a4c <kfree+0x66>
    80000a06:	47c5                	li	a5,17
    80000a08:	07ee                	slli	a5,a5,0x1b
    80000a0a:	04f57163          	bgeu	a0,a5,80000a4c <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a0e:	6605                	lui	a2,0x1
    80000a10:	4585                	li	a1,1
    80000a12:	00000097          	auipc	ra,0x0
    80000a16:	2be080e7          	jalr	702(ra) # 80000cd0 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a1a:	00011917          	auipc	s2,0x11
    80000a1e:	41690913          	addi	s2,s2,1046 # 80011e30 <kmem>
    80000a22:	854a                	mv	a0,s2
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	1b0080e7          	jalr	432(ra) # 80000bd4 <acquire>
  r->next = kmem.freelist;
    80000a2c:	01893783          	ld	a5,24(s2)
    80000a30:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a32:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a36:	854a                	mv	a0,s2
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	250080e7          	jalr	592(ra) # 80000c88 <release>
}
    80000a40:	60e2                	ld	ra,24(sp)
    80000a42:	6442                	ld	s0,16(sp)
    80000a44:	64a2                	ld	s1,8(sp)
    80000a46:	6902                	ld	s2,0(sp)
    80000a48:	6105                	addi	sp,sp,32
    80000a4a:	8082                	ret
    panic("kfree");
    80000a4c:	00008517          	auipc	a0,0x8
    80000a50:	61450513          	addi	a0,a0,1556 # 80009060 <digits+0x20>
    80000a54:	00000097          	auipc	ra,0x0
    80000a58:	aea080e7          	jalr	-1302(ra) # 8000053e <panic>

0000000080000a5c <freerange>:
{
    80000a5c:	7179                	addi	sp,sp,-48
    80000a5e:	f406                	sd	ra,40(sp)
    80000a60:	f022                	sd	s0,32(sp)
    80000a62:	ec26                	sd	s1,24(sp)
    80000a64:	e84a                	sd	s2,16(sp)
    80000a66:	e44e                	sd	s3,8(sp)
    80000a68:	e052                	sd	s4,0(sp)
    80000a6a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a6c:	6785                	lui	a5,0x1
    80000a6e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a72:	00e504b3          	add	s1,a0,a4
    80000a76:	777d                	lui	a4,0xfffff
    80000a78:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a7a:	94be                	add	s1,s1,a5
    80000a7c:	0095ee63          	bltu	a1,s1,80000a98 <freerange+0x3c>
    80000a80:	892e                	mv	s2,a1
    kfree(p);
    80000a82:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a84:	6985                	lui	s3,0x1
    kfree(p);
    80000a86:	01448533          	add	a0,s1,s4
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	f5c080e7          	jalr	-164(ra) # 800009e6 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a92:	94ce                	add	s1,s1,s3
    80000a94:	fe9979e3          	bgeu	s2,s1,80000a86 <freerange+0x2a>
}
    80000a98:	70a2                	ld	ra,40(sp)
    80000a9a:	7402                	ld	s0,32(sp)
    80000a9c:	64e2                	ld	s1,24(sp)
    80000a9e:	6942                	ld	s2,16(sp)
    80000aa0:	69a2                	ld	s3,8(sp)
    80000aa2:	6a02                	ld	s4,0(sp)
    80000aa4:	6145                	addi	sp,sp,48
    80000aa6:	8082                	ret

0000000080000aa8 <kinit>:
{
    80000aa8:	1141                	addi	sp,sp,-16
    80000aaa:	e406                	sd	ra,8(sp)
    80000aac:	e022                	sd	s0,0(sp)
    80000aae:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ab0:	00008597          	auipc	a1,0x8
    80000ab4:	5b858593          	addi	a1,a1,1464 # 80009068 <digits+0x28>
    80000ab8:	00011517          	auipc	a0,0x11
    80000abc:	37850513          	addi	a0,a0,888 # 80011e30 <kmem>
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	084080e7          	jalr	132(ra) # 80000b44 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ac8:	45c5                	li	a1,17
    80000aca:	05ee                	slli	a1,a1,0x1b
    80000acc:	00023517          	auipc	a0,0x23
    80000ad0:	f9450513          	addi	a0,a0,-108 # 80023a60 <end>
    80000ad4:	00000097          	auipc	ra,0x0
    80000ad8:	f88080e7          	jalr	-120(ra) # 80000a5c <freerange>
}
    80000adc:	60a2                	ld	ra,8(sp)
    80000ade:	6402                	ld	s0,0(sp)
    80000ae0:	0141                	addi	sp,sp,16
    80000ae2:	8082                	ret

0000000080000ae4 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae4:	1101                	addi	sp,sp,-32
    80000ae6:	ec06                	sd	ra,24(sp)
    80000ae8:	e822                	sd	s0,16(sp)
    80000aea:	e426                	sd	s1,8(sp)
    80000aec:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000aee:	00011497          	auipc	s1,0x11
    80000af2:	34248493          	addi	s1,s1,834 # 80011e30 <kmem>
    80000af6:	8526                	mv	a0,s1
    80000af8:	00000097          	auipc	ra,0x0
    80000afc:	0dc080e7          	jalr	220(ra) # 80000bd4 <acquire>
  r = kmem.freelist;
    80000b00:	6c84                	ld	s1,24(s1)
  if(r)
    80000b02:	c885                	beqz	s1,80000b32 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b04:	609c                	ld	a5,0(s1)
    80000b06:	00011517          	auipc	a0,0x11
    80000b0a:	32a50513          	addi	a0,a0,810 # 80011e30 <kmem>
    80000b0e:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b10:	00000097          	auipc	ra,0x0
    80000b14:	178080e7          	jalr	376(ra) # 80000c88 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b18:	6605                	lui	a2,0x1
    80000b1a:	4595                	li	a1,5
    80000b1c:	8526                	mv	a0,s1
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	1b2080e7          	jalr	434(ra) # 80000cd0 <memset>
  return (void*)r;
}
    80000b26:	8526                	mv	a0,s1
    80000b28:	60e2                	ld	ra,24(sp)
    80000b2a:	6442                	ld	s0,16(sp)
    80000b2c:	64a2                	ld	s1,8(sp)
    80000b2e:	6105                	addi	sp,sp,32
    80000b30:	8082                	ret
  release(&kmem.lock);
    80000b32:	00011517          	auipc	a0,0x11
    80000b36:	2fe50513          	addi	a0,a0,766 # 80011e30 <kmem>
    80000b3a:	00000097          	auipc	ra,0x0
    80000b3e:	14e080e7          	jalr	334(ra) # 80000c88 <release>
  if(r)
    80000b42:	b7d5                	j	80000b26 <kalloc+0x42>

0000000080000b44 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b44:	1141                	addi	sp,sp,-16
    80000b46:	e422                	sd	s0,8(sp)
    80000b48:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b4a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b4c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b50:	00053823          	sd	zero,16(a0)
}
    80000b54:	6422                	ld	s0,8(sp)
    80000b56:	0141                	addi	sp,sp,16
    80000b58:	8082                	ret

0000000080000b5a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b5a:	411c                	lw	a5,0(a0)
    80000b5c:	e399                	bnez	a5,80000b62 <holding+0x8>
    80000b5e:	4501                	li	a0,0
  return r;
}
    80000b60:	8082                	ret
{
    80000b62:	1101                	addi	sp,sp,-32
    80000b64:	ec06                	sd	ra,24(sp)
    80000b66:	e822                	sd	s0,16(sp)
    80000b68:	e426                	sd	s1,8(sp)
    80000b6a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b6c:	6904                	ld	s1,16(a0)
    80000b6e:	00001097          	auipc	ra,0x1
    80000b72:	e20080e7          	jalr	-480(ra) # 8000198e <mycpu>
    80000b76:	40a48533          	sub	a0,s1,a0
    80000b7a:	00153513          	seqz	a0,a0
}
    80000b7e:	60e2                	ld	ra,24(sp)
    80000b80:	6442                	ld	s0,16(sp)
    80000b82:	64a2                	ld	s1,8(sp)
    80000b84:	6105                	addi	sp,sp,32
    80000b86:	8082                	ret

0000000080000b88 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b88:	1101                	addi	sp,sp,-32
    80000b8a:	ec06                	sd	ra,24(sp)
    80000b8c:	e822                	sd	s0,16(sp)
    80000b8e:	e426                	sd	s1,8(sp)
    80000b90:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b92:	100024f3          	csrr	s1,sstatus
    80000b96:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b9a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b9c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000ba0:	00001097          	auipc	ra,0x1
    80000ba4:	dee080e7          	jalr	-530(ra) # 8000198e <mycpu>
    80000ba8:	5d3c                	lw	a5,120(a0)
    80000baa:	cf89                	beqz	a5,80000bc4 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bac:	00001097          	auipc	ra,0x1
    80000bb0:	de2080e7          	jalr	-542(ra) # 8000198e <mycpu>
    80000bb4:	5d3c                	lw	a5,120(a0)
    80000bb6:	2785                	addiw	a5,a5,1
    80000bb8:	dd3c                	sw	a5,120(a0)
}
    80000bba:	60e2                	ld	ra,24(sp)
    80000bbc:	6442                	ld	s0,16(sp)
    80000bbe:	64a2                	ld	s1,8(sp)
    80000bc0:	6105                	addi	sp,sp,32
    80000bc2:	8082                	ret
    mycpu()->intena = old;
    80000bc4:	00001097          	auipc	ra,0x1
    80000bc8:	dca080e7          	jalr	-566(ra) # 8000198e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bcc:	8085                	srli	s1,s1,0x1
    80000bce:	8885                	andi	s1,s1,1
    80000bd0:	dd64                	sw	s1,124(a0)
    80000bd2:	bfe9                	j	80000bac <push_off+0x24>

0000000080000bd4 <acquire>:
{
    80000bd4:	1101                	addi	sp,sp,-32
    80000bd6:	ec06                	sd	ra,24(sp)
    80000bd8:	e822                	sd	s0,16(sp)
    80000bda:	e426                	sd	s1,8(sp)
    80000bdc:	1000                	addi	s0,sp,32
    80000bde:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000be0:	00000097          	auipc	ra,0x0
    80000be4:	fa8080e7          	jalr	-88(ra) # 80000b88 <push_off>
  if(holding(lk))
    80000be8:	8526                	mv	a0,s1
    80000bea:	00000097          	auipc	ra,0x0
    80000bee:	f70080e7          	jalr	-144(ra) # 80000b5a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf2:	4705                	li	a4,1
  if(holding(lk))
    80000bf4:	e115                	bnez	a0,80000c18 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf6:	87ba                	mv	a5,a4
    80000bf8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bfc:	2781                	sext.w	a5,a5
    80000bfe:	ffe5                	bnez	a5,80000bf6 <acquire+0x22>
  __sync_synchronize();
    80000c00:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c04:	00001097          	auipc	ra,0x1
    80000c08:	d8a080e7          	jalr	-630(ra) # 8000198e <mycpu>
    80000c0c:	e888                	sd	a0,16(s1)
}
    80000c0e:	60e2                	ld	ra,24(sp)
    80000c10:	6442                	ld	s0,16(sp)
    80000c12:	64a2                	ld	s1,8(sp)
    80000c14:	6105                	addi	sp,sp,32
    80000c16:	8082                	ret
    panic("acquire");
    80000c18:	00008517          	auipc	a0,0x8
    80000c1c:	45850513          	addi	a0,a0,1112 # 80009070 <digits+0x30>
    80000c20:	00000097          	auipc	ra,0x0
    80000c24:	91e080e7          	jalr	-1762(ra) # 8000053e <panic>

0000000080000c28 <pop_off>:

void
pop_off(void)
{
    80000c28:	1141                	addi	sp,sp,-16
    80000c2a:	e406                	sd	ra,8(sp)
    80000c2c:	e022                	sd	s0,0(sp)
    80000c2e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c30:	00001097          	auipc	ra,0x1
    80000c34:	d5e080e7          	jalr	-674(ra) # 8000198e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c38:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c3c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c3e:	e78d                	bnez	a5,80000c68 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c40:	5d3c                	lw	a5,120(a0)
    80000c42:	02f05b63          	blez	a5,80000c78 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c46:	37fd                	addiw	a5,a5,-1
    80000c48:	0007871b          	sext.w	a4,a5
    80000c4c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c4e:	eb09                	bnez	a4,80000c60 <pop_off+0x38>
    80000c50:	5d7c                	lw	a5,124(a0)
    80000c52:	c799                	beqz	a5,80000c60 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c54:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c58:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c5c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c60:	60a2                	ld	ra,8(sp)
    80000c62:	6402                	ld	s0,0(sp)
    80000c64:	0141                	addi	sp,sp,16
    80000c66:	8082                	ret
    panic("pop_off - interruptible");
    80000c68:	00008517          	auipc	a0,0x8
    80000c6c:	41050513          	addi	a0,a0,1040 # 80009078 <digits+0x38>
    80000c70:	00000097          	auipc	ra,0x0
    80000c74:	8ce080e7          	jalr	-1842(ra) # 8000053e <panic>
    panic("pop_off");
    80000c78:	00008517          	auipc	a0,0x8
    80000c7c:	41850513          	addi	a0,a0,1048 # 80009090 <digits+0x50>
    80000c80:	00000097          	auipc	ra,0x0
    80000c84:	8be080e7          	jalr	-1858(ra) # 8000053e <panic>

0000000080000c88 <release>:
{
    80000c88:	1101                	addi	sp,sp,-32
    80000c8a:	ec06                	sd	ra,24(sp)
    80000c8c:	e822                	sd	s0,16(sp)
    80000c8e:	e426                	sd	s1,8(sp)
    80000c90:	1000                	addi	s0,sp,32
    80000c92:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c94:	00000097          	auipc	ra,0x0
    80000c98:	ec6080e7          	jalr	-314(ra) # 80000b5a <holding>
    80000c9c:	c115                	beqz	a0,80000cc0 <release+0x38>
  lk->cpu = 0;
    80000c9e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca6:	0f50000f          	fence	iorw,ow
    80000caa:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cae:	00000097          	auipc	ra,0x0
    80000cb2:	f7a080e7          	jalr	-134(ra) # 80000c28 <pop_off>
}
    80000cb6:	60e2                	ld	ra,24(sp)
    80000cb8:	6442                	ld	s0,16(sp)
    80000cba:	64a2                	ld	s1,8(sp)
    80000cbc:	6105                	addi	sp,sp,32
    80000cbe:	8082                	ret
    panic("release");
    80000cc0:	00008517          	auipc	a0,0x8
    80000cc4:	3d850513          	addi	a0,a0,984 # 80009098 <digits+0x58>
    80000cc8:	00000097          	auipc	ra,0x0
    80000ccc:	876080e7          	jalr	-1930(ra) # 8000053e <panic>

0000000080000cd0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cd0:	1141                	addi	sp,sp,-16
    80000cd2:	e422                	sd	s0,8(sp)
    80000cd4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd6:	ca19                	beqz	a2,80000cec <memset+0x1c>
    80000cd8:	87aa                	mv	a5,a0
    80000cda:	1602                	slli	a2,a2,0x20
    80000cdc:	9201                	srli	a2,a2,0x20
    80000cde:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce6:	0785                	addi	a5,a5,1
    80000ce8:	fee79de3          	bne	a5,a4,80000ce2 <memset+0x12>
  }
  return dst;
}
    80000cec:	6422                	ld	s0,8(sp)
    80000cee:	0141                	addi	sp,sp,16
    80000cf0:	8082                	ret

0000000080000cf2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf2:	1141                	addi	sp,sp,-16
    80000cf4:	e422                	sd	s0,8(sp)
    80000cf6:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf8:	ca05                	beqz	a2,80000d28 <memcmp+0x36>
    80000cfa:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cfe:	1682                	slli	a3,a3,0x20
    80000d00:	9281                	srli	a3,a3,0x20
    80000d02:	0685                	addi	a3,a3,1
    80000d04:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d06:	00054783          	lbu	a5,0(a0)
    80000d0a:	0005c703          	lbu	a4,0(a1)
    80000d0e:	00e79863          	bne	a5,a4,80000d1e <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d12:	0505                	addi	a0,a0,1
    80000d14:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d16:	fed518e3          	bne	a0,a3,80000d06 <memcmp+0x14>
  }

  return 0;
    80000d1a:	4501                	li	a0,0
    80000d1c:	a019                	j	80000d22 <memcmp+0x30>
      return *s1 - *s2;
    80000d1e:	40e7853b          	subw	a0,a5,a4
}
    80000d22:	6422                	ld	s0,8(sp)
    80000d24:	0141                	addi	sp,sp,16
    80000d26:	8082                	ret
  return 0;
    80000d28:	4501                	li	a0,0
    80000d2a:	bfe5                	j	80000d22 <memcmp+0x30>

0000000080000d2c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d2c:	1141                	addi	sp,sp,-16
    80000d2e:	e422                	sd	s0,8(sp)
    80000d30:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d32:	c205                	beqz	a2,80000d52 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d34:	02a5e263          	bltu	a1,a0,80000d58 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d38:	1602                	slli	a2,a2,0x20
    80000d3a:	9201                	srli	a2,a2,0x20
    80000d3c:	00c587b3          	add	a5,a1,a2
{
    80000d40:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d42:	0585                	addi	a1,a1,1
    80000d44:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb5a1>
    80000d46:	fff5c683          	lbu	a3,-1(a1)
    80000d4a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d4e:	fef59ae3          	bne	a1,a5,80000d42 <memmove+0x16>

  return dst;
}
    80000d52:	6422                	ld	s0,8(sp)
    80000d54:	0141                	addi	sp,sp,16
    80000d56:	8082                	ret
  if(s < d && s + n > d){
    80000d58:	02061693          	slli	a3,a2,0x20
    80000d5c:	9281                	srli	a3,a3,0x20
    80000d5e:	00d58733          	add	a4,a1,a3
    80000d62:	fce57be3          	bgeu	a0,a4,80000d38 <memmove+0xc>
    d += n;
    80000d66:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d68:	fff6079b          	addiw	a5,a2,-1
    80000d6c:	1782                	slli	a5,a5,0x20
    80000d6e:	9381                	srli	a5,a5,0x20
    80000d70:	fff7c793          	not	a5,a5
    80000d74:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d76:	177d                	addi	a4,a4,-1
    80000d78:	16fd                	addi	a3,a3,-1
    80000d7a:	00074603          	lbu	a2,0(a4)
    80000d7e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d82:	fee79ae3          	bne	a5,a4,80000d76 <memmove+0x4a>
    80000d86:	b7f1                	j	80000d52 <memmove+0x26>

0000000080000d88 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d88:	1141                	addi	sp,sp,-16
    80000d8a:	e406                	sd	ra,8(sp)
    80000d8c:	e022                	sd	s0,0(sp)
    80000d8e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d90:	00000097          	auipc	ra,0x0
    80000d94:	f9c080e7          	jalr	-100(ra) # 80000d2c <memmove>
}
    80000d98:	60a2                	ld	ra,8(sp)
    80000d9a:	6402                	ld	s0,0(sp)
    80000d9c:	0141                	addi	sp,sp,16
    80000d9e:	8082                	ret

0000000080000da0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da0:	1141                	addi	sp,sp,-16
    80000da2:	e422                	sd	s0,8(sp)
    80000da4:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da6:	ce11                	beqz	a2,80000dc2 <strncmp+0x22>
    80000da8:	00054783          	lbu	a5,0(a0)
    80000dac:	cf89                	beqz	a5,80000dc6 <strncmp+0x26>
    80000dae:	0005c703          	lbu	a4,0(a1)
    80000db2:	00f71a63          	bne	a4,a5,80000dc6 <strncmp+0x26>
    n--, p++, q++;
    80000db6:	367d                	addiw	a2,a2,-1
    80000db8:	0505                	addi	a0,a0,1
    80000dba:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dbc:	f675                	bnez	a2,80000da8 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dbe:	4501                	li	a0,0
    80000dc0:	a809                	j	80000dd2 <strncmp+0x32>
    80000dc2:	4501                	li	a0,0
    80000dc4:	a039                	j	80000dd2 <strncmp+0x32>
  if(n == 0)
    80000dc6:	ca09                	beqz	a2,80000dd8 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dc8:	00054503          	lbu	a0,0(a0)
    80000dcc:	0005c783          	lbu	a5,0(a1)
    80000dd0:	9d1d                	subw	a0,a0,a5
}
    80000dd2:	6422                	ld	s0,8(sp)
    80000dd4:	0141                	addi	sp,sp,16
    80000dd6:	8082                	ret
    return 0;
    80000dd8:	4501                	li	a0,0
    80000dda:	bfe5                	j	80000dd2 <strncmp+0x32>

0000000080000ddc <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000ddc:	1141                	addi	sp,sp,-16
    80000dde:	e422                	sd	s0,8(sp)
    80000de0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de2:	872a                	mv	a4,a0
    80000de4:	8832                	mv	a6,a2
    80000de6:	367d                	addiw	a2,a2,-1
    80000de8:	01005963          	blez	a6,80000dfa <strncpy+0x1e>
    80000dec:	0705                	addi	a4,a4,1
    80000dee:	0005c783          	lbu	a5,0(a1)
    80000df2:	fef70fa3          	sb	a5,-1(a4)
    80000df6:	0585                	addi	a1,a1,1
    80000df8:	f7f5                	bnez	a5,80000de4 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000dfa:	86ba                	mv	a3,a4
    80000dfc:	00c05c63          	blez	a2,80000e14 <strncpy+0x38>
    *s++ = 0;
    80000e00:	0685                	addi	a3,a3,1
    80000e02:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e06:	40d707bb          	subw	a5,a4,a3
    80000e0a:	37fd                	addiw	a5,a5,-1
    80000e0c:	010787bb          	addw	a5,a5,a6
    80000e10:	fef048e3          	bgtz	a5,80000e00 <strncpy+0x24>
  return os;
}
    80000e14:	6422                	ld	s0,8(sp)
    80000e16:	0141                	addi	sp,sp,16
    80000e18:	8082                	ret

0000000080000e1a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e1a:	1141                	addi	sp,sp,-16
    80000e1c:	e422                	sd	s0,8(sp)
    80000e1e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e20:	02c05363          	blez	a2,80000e46 <safestrcpy+0x2c>
    80000e24:	fff6069b          	addiw	a3,a2,-1
    80000e28:	1682                	slli	a3,a3,0x20
    80000e2a:	9281                	srli	a3,a3,0x20
    80000e2c:	96ae                	add	a3,a3,a1
    80000e2e:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e30:	00d58963          	beq	a1,a3,80000e42 <safestrcpy+0x28>
    80000e34:	0585                	addi	a1,a1,1
    80000e36:	0785                	addi	a5,a5,1
    80000e38:	fff5c703          	lbu	a4,-1(a1)
    80000e3c:	fee78fa3          	sb	a4,-1(a5)
    80000e40:	fb65                	bnez	a4,80000e30 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e42:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e46:	6422                	ld	s0,8(sp)
    80000e48:	0141                	addi	sp,sp,16
    80000e4a:	8082                	ret

0000000080000e4c <strlen>:

int
strlen(const char *s)
{
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e422                	sd	s0,8(sp)
    80000e50:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e52:	00054783          	lbu	a5,0(a0)
    80000e56:	cf91                	beqz	a5,80000e72 <strlen+0x26>
    80000e58:	0505                	addi	a0,a0,1
    80000e5a:	87aa                	mv	a5,a0
    80000e5c:	4685                	li	a3,1
    80000e5e:	9e89                	subw	a3,a3,a0
    80000e60:	00f6853b          	addw	a0,a3,a5
    80000e64:	0785                	addi	a5,a5,1
    80000e66:	fff7c703          	lbu	a4,-1(a5)
    80000e6a:	fb7d                	bnez	a4,80000e60 <strlen+0x14>
    ;
  return n;
}
    80000e6c:	6422                	ld	s0,8(sp)
    80000e6e:	0141                	addi	sp,sp,16
    80000e70:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e72:	4501                	li	a0,0
    80000e74:	bfe5                	j	80000e6c <strlen+0x20>

0000000080000e76 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e406                	sd	ra,8(sp)
    80000e7a:	e022                	sd	s0,0(sp)
    80000e7c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e7e:	00001097          	auipc	ra,0x1
    80000e82:	b00080e7          	jalr	-1280(ra) # 8000197e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e86:	00009717          	auipc	a4,0x9
    80000e8a:	d4270713          	addi	a4,a4,-702 # 80009bc8 <started>
  if(cpuid() == 0){
    80000e8e:	c139                	beqz	a0,80000ed4 <main+0x5e>
    while(started == 0)
    80000e90:	431c                	lw	a5,0(a4)
    80000e92:	2781                	sext.w	a5,a5
    80000e94:	dff5                	beqz	a5,80000e90 <main+0x1a>
      ;
    __sync_synchronize();
    80000e96:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e9a:	00001097          	auipc	ra,0x1
    80000e9e:	ae4080e7          	jalr	-1308(ra) # 8000197e <cpuid>
    80000ea2:	85aa                	mv	a1,a0
    80000ea4:	00008517          	auipc	a0,0x8
    80000ea8:	21450513          	addi	a0,a0,532 # 800090b8 <digits+0x78>
    80000eac:	fffff097          	auipc	ra,0xfffff
    80000eb0:	6dc080e7          	jalr	1756(ra) # 80000588 <printf>
    kvminithart();    // turn on paging
    80000eb4:	00000097          	auipc	ra,0x0
    80000eb8:	0d8080e7          	jalr	216(ra) # 80000f8c <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	85c080e7          	jalr	-1956(ra) # 80002718 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec4:	00005097          	auipc	ra,0x5
    80000ec8:	38c080e7          	jalr	908(ra) # 80006250 <plicinithart>
  }
  scheduler();        
    80000ecc:	00001097          	auipc	ra,0x1
    80000ed0:	fe6080e7          	jalr	-26(ra) # 80001eb2 <scheduler>
    consoleinit();
    80000ed4:	fffff097          	auipc	ra,0xfffff
    80000ed8:	57a080e7          	jalr	1402(ra) # 8000044e <consoleinit>
    printfinit();
    80000edc:	00000097          	auipc	ra,0x0
    80000ee0:	88c080e7          	jalr	-1908(ra) # 80000768 <printfinit>
    printf("\n");
    80000ee4:	00009517          	auipc	a0,0x9
    80000ee8:	c4c50513          	addi	a0,a0,-948 # 80009b30 <syscalls+0x6e0>
    80000eec:	fffff097          	auipc	ra,0xfffff
    80000ef0:	69c080e7          	jalr	1692(ra) # 80000588 <printf>
    printf("xv6 kernel is booting\n");
    80000ef4:	00008517          	auipc	a0,0x8
    80000ef8:	1ac50513          	addi	a0,a0,428 # 800090a0 <digits+0x60>
    80000efc:	fffff097          	auipc	ra,0xfffff
    80000f00:	68c080e7          	jalr	1676(ra) # 80000588 <printf>
    printf("\n");
    80000f04:	00009517          	auipc	a0,0x9
    80000f08:	c2c50513          	addi	a0,a0,-980 # 80009b30 <syscalls+0x6e0>
    80000f0c:	fffff097          	auipc	ra,0xfffff
    80000f10:	67c080e7          	jalr	1660(ra) # 80000588 <printf>
    kinit();         // physical page allocator
    80000f14:	00000097          	auipc	ra,0x0
    80000f18:	b94080e7          	jalr	-1132(ra) # 80000aa8 <kinit>
    kvminit();       // create kernel page table
    80000f1c:	00000097          	auipc	ra,0x0
    80000f20:	326080e7          	jalr	806(ra) # 80001242 <kvminit>
    kvminithart();   // turn on paging
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	068080e7          	jalr	104(ra) # 80000f8c <kvminithart>
    procinit();      // process table
    80000f2c:	00001097          	auipc	ra,0x1
    80000f30:	99e080e7          	jalr	-1634(ra) # 800018ca <procinit>
    trapinit();      // trap vectors
    80000f34:	00001097          	auipc	ra,0x1
    80000f38:	7bc080e7          	jalr	1980(ra) # 800026f0 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f3c:	00001097          	auipc	ra,0x1
    80000f40:	7dc080e7          	jalr	2012(ra) # 80002718 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f44:	00005097          	auipc	ra,0x5
    80000f48:	2f6080e7          	jalr	758(ra) # 8000623a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f4c:	00005097          	auipc	ra,0x5
    80000f50:	304080e7          	jalr	772(ra) # 80006250 <plicinithart>
    binit();         // buffer cache
    80000f54:	00002097          	auipc	ra,0x2
    80000f58:	3a4080e7          	jalr	932(ra) # 800032f8 <binit>
    iinit();         // inode table
    80000f5c:	00003097          	auipc	ra,0x3
    80000f60:	a44080e7          	jalr	-1468(ra) # 800039a0 <iinit>
    fileinit();      // file table
    80000f64:	00004097          	auipc	ra,0x4
    80000f68:	9ea080e7          	jalr	-1558(ra) # 8000494e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f6c:	00005097          	auipc	ra,0x5
    80000f70:	3ec080e7          	jalr	1004(ra) # 80006358 <virtio_disk_init>
    userinit();      // first user process
    80000f74:	00001097          	auipc	ra,0x1
    80000f78:	d20080e7          	jalr	-736(ra) # 80001c94 <userinit>
    __sync_synchronize();
    80000f7c:	0ff0000f          	fence
    started = 1;
    80000f80:	4785                	li	a5,1
    80000f82:	00009717          	auipc	a4,0x9
    80000f86:	c4f72323          	sw	a5,-954(a4) # 80009bc8 <started>
    80000f8a:	b789                	j	80000ecc <main+0x56>

0000000080000f8c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f8c:	1141                	addi	sp,sp,-16
    80000f8e:	e422                	sd	s0,8(sp)
    80000f90:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f92:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f96:	00009797          	auipc	a5,0x9
    80000f9a:	c3a7b783          	ld	a5,-966(a5) # 80009bd0 <kernel_pagetable>
    80000f9e:	83b1                	srli	a5,a5,0xc
    80000fa0:	577d                	li	a4,-1
    80000fa2:	177e                	slli	a4,a4,0x3f
    80000fa4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fa6:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000faa:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000fae:	6422                	ld	s0,8(sp)
    80000fb0:	0141                	addi	sp,sp,16
    80000fb2:	8082                	ret

0000000080000fb4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fb4:	7139                	addi	sp,sp,-64
    80000fb6:	fc06                	sd	ra,56(sp)
    80000fb8:	f822                	sd	s0,48(sp)
    80000fba:	f426                	sd	s1,40(sp)
    80000fbc:	f04a                	sd	s2,32(sp)
    80000fbe:	ec4e                	sd	s3,24(sp)
    80000fc0:	e852                	sd	s4,16(sp)
    80000fc2:	e456                	sd	s5,8(sp)
    80000fc4:	e05a                	sd	s6,0(sp)
    80000fc6:	0080                	addi	s0,sp,64
    80000fc8:	84aa                	mv	s1,a0
    80000fca:	89ae                	mv	s3,a1
    80000fcc:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fce:	57fd                	li	a5,-1
    80000fd0:	83e9                	srli	a5,a5,0x1a
    80000fd2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fd4:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fd6:	04b7f263          	bgeu	a5,a1,8000101a <walk+0x66>
    panic("walk");
    80000fda:	00008517          	auipc	a0,0x8
    80000fde:	0f650513          	addi	a0,a0,246 # 800090d0 <digits+0x90>
    80000fe2:	fffff097          	auipc	ra,0xfffff
    80000fe6:	55c080e7          	jalr	1372(ra) # 8000053e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fea:	060a8663          	beqz	s5,80001056 <walk+0xa2>
    80000fee:	00000097          	auipc	ra,0x0
    80000ff2:	af6080e7          	jalr	-1290(ra) # 80000ae4 <kalloc>
    80000ff6:	84aa                	mv	s1,a0
    80000ff8:	c529                	beqz	a0,80001042 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ffa:	6605                	lui	a2,0x1
    80000ffc:	4581                	li	a1,0
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	cd2080e7          	jalr	-814(ra) # 80000cd0 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001006:	00c4d793          	srli	a5,s1,0xc
    8000100a:	07aa                	slli	a5,a5,0xa
    8000100c:	0017e793          	ori	a5,a5,1
    80001010:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001014:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb597>
    80001016:	036a0063          	beq	s4,s6,80001036 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000101a:	0149d933          	srl	s2,s3,s4
    8000101e:	1ff97913          	andi	s2,s2,511
    80001022:	090e                	slli	s2,s2,0x3
    80001024:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001026:	00093483          	ld	s1,0(s2)
    8000102a:	0014f793          	andi	a5,s1,1
    8000102e:	dfd5                	beqz	a5,80000fea <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001030:	80a9                	srli	s1,s1,0xa
    80001032:	04b2                	slli	s1,s1,0xc
    80001034:	b7c5                	j	80001014 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001036:	00c9d513          	srli	a0,s3,0xc
    8000103a:	1ff57513          	andi	a0,a0,511
    8000103e:	050e                	slli	a0,a0,0x3
    80001040:	9526                	add	a0,a0,s1
}
    80001042:	70e2                	ld	ra,56(sp)
    80001044:	7442                	ld	s0,48(sp)
    80001046:	74a2                	ld	s1,40(sp)
    80001048:	7902                	ld	s2,32(sp)
    8000104a:	69e2                	ld	s3,24(sp)
    8000104c:	6a42                	ld	s4,16(sp)
    8000104e:	6aa2                	ld	s5,8(sp)
    80001050:	6b02                	ld	s6,0(sp)
    80001052:	6121                	addi	sp,sp,64
    80001054:	8082                	ret
        return 0;
    80001056:	4501                	li	a0,0
    80001058:	b7ed                	j	80001042 <walk+0x8e>

000000008000105a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000105a:	57fd                	li	a5,-1
    8000105c:	83e9                	srli	a5,a5,0x1a
    8000105e:	00b7f463          	bgeu	a5,a1,80001066 <walkaddr+0xc>
    return 0;
    80001062:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001064:	8082                	ret
{
    80001066:	1141                	addi	sp,sp,-16
    80001068:	e406                	sd	ra,8(sp)
    8000106a:	e022                	sd	s0,0(sp)
    8000106c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000106e:	4601                	li	a2,0
    80001070:	00000097          	auipc	ra,0x0
    80001074:	f44080e7          	jalr	-188(ra) # 80000fb4 <walk>
  if(pte == 0)
    80001078:	c105                	beqz	a0,80001098 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000107a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000107c:	0117f693          	andi	a3,a5,17
    80001080:	4745                	li	a4,17
    return 0;
    80001082:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001084:	00e68663          	beq	a3,a4,80001090 <walkaddr+0x36>
}
    80001088:	60a2                	ld	ra,8(sp)
    8000108a:	6402                	ld	s0,0(sp)
    8000108c:	0141                	addi	sp,sp,16
    8000108e:	8082                	ret
  pa = PTE2PA(*pte);
    80001090:	83a9                	srli	a5,a5,0xa
    80001092:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001096:	bfcd                	j	80001088 <walkaddr+0x2e>
    return 0;
    80001098:	4501                	li	a0,0
    8000109a:	b7fd                	j	80001088 <walkaddr+0x2e>

000000008000109c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000109c:	715d                	addi	sp,sp,-80
    8000109e:	e486                	sd	ra,72(sp)
    800010a0:	e0a2                	sd	s0,64(sp)
    800010a2:	fc26                	sd	s1,56(sp)
    800010a4:	f84a                	sd	s2,48(sp)
    800010a6:	f44e                	sd	s3,40(sp)
    800010a8:	f052                	sd	s4,32(sp)
    800010aa:	ec56                	sd	s5,24(sp)
    800010ac:	e85a                	sd	s6,16(sp)
    800010ae:	e45e                	sd	s7,8(sp)
    800010b0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010b2:	c639                	beqz	a2,80001100 <mappages+0x64>
    800010b4:	8aaa                	mv	s5,a0
    800010b6:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800010b8:	777d                	lui	a4,0xfffff
    800010ba:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010be:	fff58993          	addi	s3,a1,-1
    800010c2:	99b2                	add	s3,s3,a2
    800010c4:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010c8:	893e                	mv	s2,a5
    800010ca:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010ce:	6b85                	lui	s7,0x1
    800010d0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010d4:	4605                	li	a2,1
    800010d6:	85ca                	mv	a1,s2
    800010d8:	8556                	mv	a0,s5
    800010da:	00000097          	auipc	ra,0x0
    800010de:	eda080e7          	jalr	-294(ra) # 80000fb4 <walk>
    800010e2:	cd1d                	beqz	a0,80001120 <mappages+0x84>
    if(*pte & PTE_V)
    800010e4:	611c                	ld	a5,0(a0)
    800010e6:	8b85                	andi	a5,a5,1
    800010e8:	e785                	bnez	a5,80001110 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010ea:	80b1                	srli	s1,s1,0xc
    800010ec:	04aa                	slli	s1,s1,0xa
    800010ee:	0164e4b3          	or	s1,s1,s6
    800010f2:	0014e493          	ori	s1,s1,1
    800010f6:	e104                	sd	s1,0(a0)
    if(a == last)
    800010f8:	05390063          	beq	s2,s3,80001138 <mappages+0x9c>
    a += PGSIZE;
    800010fc:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010fe:	bfc9                	j	800010d0 <mappages+0x34>
    panic("mappages: size");
    80001100:	00008517          	auipc	a0,0x8
    80001104:	fd850513          	addi	a0,a0,-40 # 800090d8 <digits+0x98>
    80001108:	fffff097          	auipc	ra,0xfffff
    8000110c:	436080e7          	jalr	1078(ra) # 8000053e <panic>
      panic("mappages: remap");
    80001110:	00008517          	auipc	a0,0x8
    80001114:	fd850513          	addi	a0,a0,-40 # 800090e8 <digits+0xa8>
    80001118:	fffff097          	auipc	ra,0xfffff
    8000111c:	426080e7          	jalr	1062(ra) # 8000053e <panic>
      return -1;
    80001120:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001122:	60a6                	ld	ra,72(sp)
    80001124:	6406                	ld	s0,64(sp)
    80001126:	74e2                	ld	s1,56(sp)
    80001128:	7942                	ld	s2,48(sp)
    8000112a:	79a2                	ld	s3,40(sp)
    8000112c:	7a02                	ld	s4,32(sp)
    8000112e:	6ae2                	ld	s5,24(sp)
    80001130:	6b42                	ld	s6,16(sp)
    80001132:	6ba2                	ld	s7,8(sp)
    80001134:	6161                	addi	sp,sp,80
    80001136:	8082                	ret
  return 0;
    80001138:	4501                	li	a0,0
    8000113a:	b7e5                	j	80001122 <mappages+0x86>

000000008000113c <kvmmap>:
{
    8000113c:	1141                	addi	sp,sp,-16
    8000113e:	e406                	sd	ra,8(sp)
    80001140:	e022                	sd	s0,0(sp)
    80001142:	0800                	addi	s0,sp,16
    80001144:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001146:	86b2                	mv	a3,a2
    80001148:	863e                	mv	a2,a5
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	f52080e7          	jalr	-174(ra) # 8000109c <mappages>
    80001152:	e509                	bnez	a0,8000115c <kvmmap+0x20>
}
    80001154:	60a2                	ld	ra,8(sp)
    80001156:	6402                	ld	s0,0(sp)
    80001158:	0141                	addi	sp,sp,16
    8000115a:	8082                	ret
    panic("kvmmap");
    8000115c:	00008517          	auipc	a0,0x8
    80001160:	f9c50513          	addi	a0,a0,-100 # 800090f8 <digits+0xb8>
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	3da080e7          	jalr	986(ra) # 8000053e <panic>

000000008000116c <kvmmake>:
{
    8000116c:	1101                	addi	sp,sp,-32
    8000116e:	ec06                	sd	ra,24(sp)
    80001170:	e822                	sd	s0,16(sp)
    80001172:	e426                	sd	s1,8(sp)
    80001174:	e04a                	sd	s2,0(sp)
    80001176:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001178:	00000097          	auipc	ra,0x0
    8000117c:	96c080e7          	jalr	-1684(ra) # 80000ae4 <kalloc>
    80001180:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001182:	6605                	lui	a2,0x1
    80001184:	4581                	li	a1,0
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	b4a080e7          	jalr	-1206(ra) # 80000cd0 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000118e:	4719                	li	a4,6
    80001190:	6685                	lui	a3,0x1
    80001192:	10000637          	lui	a2,0x10000
    80001196:	100005b7          	lui	a1,0x10000
    8000119a:	8526                	mv	a0,s1
    8000119c:	00000097          	auipc	ra,0x0
    800011a0:	fa0080e7          	jalr	-96(ra) # 8000113c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011a4:	4719                	li	a4,6
    800011a6:	6685                	lui	a3,0x1
    800011a8:	10001637          	lui	a2,0x10001
    800011ac:	100015b7          	lui	a1,0x10001
    800011b0:	8526                	mv	a0,s1
    800011b2:	00000097          	auipc	ra,0x0
    800011b6:	f8a080e7          	jalr	-118(ra) # 8000113c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011ba:	4719                	li	a4,6
    800011bc:	004006b7          	lui	a3,0x400
    800011c0:	0c000637          	lui	a2,0xc000
    800011c4:	0c0005b7          	lui	a1,0xc000
    800011c8:	8526                	mv	a0,s1
    800011ca:	00000097          	auipc	ra,0x0
    800011ce:	f72080e7          	jalr	-142(ra) # 8000113c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011d2:	00008917          	auipc	s2,0x8
    800011d6:	e2e90913          	addi	s2,s2,-466 # 80009000 <etext>
    800011da:	4729                	li	a4,10
    800011dc:	80008697          	auipc	a3,0x80008
    800011e0:	e2468693          	addi	a3,a3,-476 # 9000 <_entry-0x7fff7000>
    800011e4:	4605                	li	a2,1
    800011e6:	067e                	slli	a2,a2,0x1f
    800011e8:	85b2                	mv	a1,a2
    800011ea:	8526                	mv	a0,s1
    800011ec:	00000097          	auipc	ra,0x0
    800011f0:	f50080e7          	jalr	-176(ra) # 8000113c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011f4:	4719                	li	a4,6
    800011f6:	46c5                	li	a3,17
    800011f8:	06ee                	slli	a3,a3,0x1b
    800011fa:	412686b3          	sub	a3,a3,s2
    800011fe:	864a                	mv	a2,s2
    80001200:	85ca                	mv	a1,s2
    80001202:	8526                	mv	a0,s1
    80001204:	00000097          	auipc	ra,0x0
    80001208:	f38080e7          	jalr	-200(ra) # 8000113c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000120c:	4729                	li	a4,10
    8000120e:	6685                	lui	a3,0x1
    80001210:	00007617          	auipc	a2,0x7
    80001214:	df060613          	addi	a2,a2,-528 # 80008000 <_trampoline>
    80001218:	040005b7          	lui	a1,0x4000
    8000121c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000121e:	05b2                	slli	a1,a1,0xc
    80001220:	8526                	mv	a0,s1
    80001222:	00000097          	auipc	ra,0x0
    80001226:	f1a080e7          	jalr	-230(ra) # 8000113c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000122a:	8526                	mv	a0,s1
    8000122c:	00000097          	auipc	ra,0x0
    80001230:	608080e7          	jalr	1544(ra) # 80001834 <proc_mapstacks>
}
    80001234:	8526                	mv	a0,s1
    80001236:	60e2                	ld	ra,24(sp)
    80001238:	6442                	ld	s0,16(sp)
    8000123a:	64a2                	ld	s1,8(sp)
    8000123c:	6902                	ld	s2,0(sp)
    8000123e:	6105                	addi	sp,sp,32
    80001240:	8082                	ret

0000000080001242 <kvminit>:
{
    80001242:	1141                	addi	sp,sp,-16
    80001244:	e406                	sd	ra,8(sp)
    80001246:	e022                	sd	s0,0(sp)
    80001248:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000124a:	00000097          	auipc	ra,0x0
    8000124e:	f22080e7          	jalr	-222(ra) # 8000116c <kvmmake>
    80001252:	00009797          	auipc	a5,0x9
    80001256:	96a7bf23          	sd	a0,-1666(a5) # 80009bd0 <kernel_pagetable>
}
    8000125a:	60a2                	ld	ra,8(sp)
    8000125c:	6402                	ld	s0,0(sp)
    8000125e:	0141                	addi	sp,sp,16
    80001260:	8082                	ret

0000000080001262 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001262:	715d                	addi	sp,sp,-80
    80001264:	e486                	sd	ra,72(sp)
    80001266:	e0a2                	sd	s0,64(sp)
    80001268:	fc26                	sd	s1,56(sp)
    8000126a:	f84a                	sd	s2,48(sp)
    8000126c:	f44e                	sd	s3,40(sp)
    8000126e:	f052                	sd	s4,32(sp)
    80001270:	ec56                	sd	s5,24(sp)
    80001272:	e85a                	sd	s6,16(sp)
    80001274:	e45e                	sd	s7,8(sp)
    80001276:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001278:	03459793          	slli	a5,a1,0x34
    8000127c:	e795                	bnez	a5,800012a8 <uvmunmap+0x46>
    8000127e:	8a2a                	mv	s4,a0
    80001280:	892e                	mv	s2,a1
    80001282:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001284:	0632                	slli	a2,a2,0xc
    80001286:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000128a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000128c:	6b05                	lui	s6,0x1
    8000128e:	0735e263          	bltu	a1,s3,800012f2 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001292:	60a6                	ld	ra,72(sp)
    80001294:	6406                	ld	s0,64(sp)
    80001296:	74e2                	ld	s1,56(sp)
    80001298:	7942                	ld	s2,48(sp)
    8000129a:	79a2                	ld	s3,40(sp)
    8000129c:	7a02                	ld	s4,32(sp)
    8000129e:	6ae2                	ld	s5,24(sp)
    800012a0:	6b42                	ld	s6,16(sp)
    800012a2:	6ba2                	ld	s7,8(sp)
    800012a4:	6161                	addi	sp,sp,80
    800012a6:	8082                	ret
    panic("uvmunmap: not aligned");
    800012a8:	00008517          	auipc	a0,0x8
    800012ac:	e5850513          	addi	a0,a0,-424 # 80009100 <digits+0xc0>
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	28e080e7          	jalr	654(ra) # 8000053e <panic>
      panic("uvmunmap: walk");
    800012b8:	00008517          	auipc	a0,0x8
    800012bc:	e6050513          	addi	a0,a0,-416 # 80009118 <digits+0xd8>
    800012c0:	fffff097          	auipc	ra,0xfffff
    800012c4:	27e080e7          	jalr	638(ra) # 8000053e <panic>
      panic("uvmunmap: not mapped");
    800012c8:	00008517          	auipc	a0,0x8
    800012cc:	e6050513          	addi	a0,a0,-416 # 80009128 <digits+0xe8>
    800012d0:	fffff097          	auipc	ra,0xfffff
    800012d4:	26e080e7          	jalr	622(ra) # 8000053e <panic>
      panic("uvmunmap: not a leaf");
    800012d8:	00008517          	auipc	a0,0x8
    800012dc:	e6850513          	addi	a0,a0,-408 # 80009140 <digits+0x100>
    800012e0:	fffff097          	auipc	ra,0xfffff
    800012e4:	25e080e7          	jalr	606(ra) # 8000053e <panic>
    *pte = 0;
    800012e8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012ec:	995a                	add	s2,s2,s6
    800012ee:	fb3972e3          	bgeu	s2,s3,80001292 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012f2:	4601                	li	a2,0
    800012f4:	85ca                	mv	a1,s2
    800012f6:	8552                	mv	a0,s4
    800012f8:	00000097          	auipc	ra,0x0
    800012fc:	cbc080e7          	jalr	-836(ra) # 80000fb4 <walk>
    80001300:	84aa                	mv	s1,a0
    80001302:	d95d                	beqz	a0,800012b8 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001304:	6108                	ld	a0,0(a0)
    80001306:	00157793          	andi	a5,a0,1
    8000130a:	dfdd                	beqz	a5,800012c8 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000130c:	3ff57793          	andi	a5,a0,1023
    80001310:	fd7784e3          	beq	a5,s7,800012d8 <uvmunmap+0x76>
    if(do_free){
    80001314:	fc0a8ae3          	beqz	s5,800012e8 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001318:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000131a:	0532                	slli	a0,a0,0xc
    8000131c:	fffff097          	auipc	ra,0xfffff
    80001320:	6ca080e7          	jalr	1738(ra) # 800009e6 <kfree>
    80001324:	b7d1                	j	800012e8 <uvmunmap+0x86>

0000000080001326 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001326:	1101                	addi	sp,sp,-32
    80001328:	ec06                	sd	ra,24(sp)
    8000132a:	e822                	sd	s0,16(sp)
    8000132c:	e426                	sd	s1,8(sp)
    8000132e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001330:	fffff097          	auipc	ra,0xfffff
    80001334:	7b4080e7          	jalr	1972(ra) # 80000ae4 <kalloc>
    80001338:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000133a:	c519                	beqz	a0,80001348 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000133c:	6605                	lui	a2,0x1
    8000133e:	4581                	li	a1,0
    80001340:	00000097          	auipc	ra,0x0
    80001344:	990080e7          	jalr	-1648(ra) # 80000cd0 <memset>
  return pagetable;
}
    80001348:	8526                	mv	a0,s1
    8000134a:	60e2                	ld	ra,24(sp)
    8000134c:	6442                	ld	s0,16(sp)
    8000134e:	64a2                	ld	s1,8(sp)
    80001350:	6105                	addi	sp,sp,32
    80001352:	8082                	ret

0000000080001354 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001354:	7179                	addi	sp,sp,-48
    80001356:	f406                	sd	ra,40(sp)
    80001358:	f022                	sd	s0,32(sp)
    8000135a:	ec26                	sd	s1,24(sp)
    8000135c:	e84a                	sd	s2,16(sp)
    8000135e:	e44e                	sd	s3,8(sp)
    80001360:	e052                	sd	s4,0(sp)
    80001362:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001364:	6785                	lui	a5,0x1
    80001366:	04f67863          	bgeu	a2,a5,800013b6 <uvmfirst+0x62>
    8000136a:	8a2a                	mv	s4,a0
    8000136c:	89ae                	mv	s3,a1
    8000136e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001370:	fffff097          	auipc	ra,0xfffff
    80001374:	774080e7          	jalr	1908(ra) # 80000ae4 <kalloc>
    80001378:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000137a:	6605                	lui	a2,0x1
    8000137c:	4581                	li	a1,0
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	952080e7          	jalr	-1710(ra) # 80000cd0 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001386:	4779                	li	a4,30
    80001388:	86ca                	mv	a3,s2
    8000138a:	6605                	lui	a2,0x1
    8000138c:	4581                	li	a1,0
    8000138e:	8552                	mv	a0,s4
    80001390:	00000097          	auipc	ra,0x0
    80001394:	d0c080e7          	jalr	-756(ra) # 8000109c <mappages>
  memmove(mem, src, sz);
    80001398:	8626                	mv	a2,s1
    8000139a:	85ce                	mv	a1,s3
    8000139c:	854a                	mv	a0,s2
    8000139e:	00000097          	auipc	ra,0x0
    800013a2:	98e080e7          	jalr	-1650(ra) # 80000d2c <memmove>
}
    800013a6:	70a2                	ld	ra,40(sp)
    800013a8:	7402                	ld	s0,32(sp)
    800013aa:	64e2                	ld	s1,24(sp)
    800013ac:	6942                	ld	s2,16(sp)
    800013ae:	69a2                	ld	s3,8(sp)
    800013b0:	6a02                	ld	s4,0(sp)
    800013b2:	6145                	addi	sp,sp,48
    800013b4:	8082                	ret
    panic("uvmfirst: more than a page");
    800013b6:	00008517          	auipc	a0,0x8
    800013ba:	da250513          	addi	a0,a0,-606 # 80009158 <digits+0x118>
    800013be:	fffff097          	auipc	ra,0xfffff
    800013c2:	180080e7          	jalr	384(ra) # 8000053e <panic>

00000000800013c6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013c6:	1101                	addi	sp,sp,-32
    800013c8:	ec06                	sd	ra,24(sp)
    800013ca:	e822                	sd	s0,16(sp)
    800013cc:	e426                	sd	s1,8(sp)
    800013ce:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013d0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013d2:	00b67d63          	bgeu	a2,a1,800013ec <uvmdealloc+0x26>
    800013d6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013d8:	6785                	lui	a5,0x1
    800013da:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013dc:	00f60733          	add	a4,a2,a5
    800013e0:	76fd                	lui	a3,0xfffff
    800013e2:	8f75                	and	a4,a4,a3
    800013e4:	97ae                	add	a5,a5,a1
    800013e6:	8ff5                	and	a5,a5,a3
    800013e8:	00f76863          	bltu	a4,a5,800013f8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013ec:	8526                	mv	a0,s1
    800013ee:	60e2                	ld	ra,24(sp)
    800013f0:	6442                	ld	s0,16(sp)
    800013f2:	64a2                	ld	s1,8(sp)
    800013f4:	6105                	addi	sp,sp,32
    800013f6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013f8:	8f99                	sub	a5,a5,a4
    800013fa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013fc:	4685                	li	a3,1
    800013fe:	0007861b          	sext.w	a2,a5
    80001402:	85ba                	mv	a1,a4
    80001404:	00000097          	auipc	ra,0x0
    80001408:	e5e080e7          	jalr	-418(ra) # 80001262 <uvmunmap>
    8000140c:	b7c5                	j	800013ec <uvmdealloc+0x26>

000000008000140e <uvmalloc>:
  if(newsz < oldsz)
    8000140e:	0ab66563          	bltu	a2,a1,800014b8 <uvmalloc+0xaa>
{
    80001412:	7139                	addi	sp,sp,-64
    80001414:	fc06                	sd	ra,56(sp)
    80001416:	f822                	sd	s0,48(sp)
    80001418:	f426                	sd	s1,40(sp)
    8000141a:	f04a                	sd	s2,32(sp)
    8000141c:	ec4e                	sd	s3,24(sp)
    8000141e:	e852                	sd	s4,16(sp)
    80001420:	e456                	sd	s5,8(sp)
    80001422:	e05a                	sd	s6,0(sp)
    80001424:	0080                	addi	s0,sp,64
    80001426:	8aaa                	mv	s5,a0
    80001428:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000142a:	6785                	lui	a5,0x1
    8000142c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000142e:	95be                	add	a1,a1,a5
    80001430:	77fd                	lui	a5,0xfffff
    80001432:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001436:	08c9f363          	bgeu	s3,a2,800014bc <uvmalloc+0xae>
    8000143a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000143c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001440:	fffff097          	auipc	ra,0xfffff
    80001444:	6a4080e7          	jalr	1700(ra) # 80000ae4 <kalloc>
    80001448:	84aa                	mv	s1,a0
    if(mem == 0){
    8000144a:	c51d                	beqz	a0,80001478 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000144c:	6605                	lui	a2,0x1
    8000144e:	4581                	li	a1,0
    80001450:	00000097          	auipc	ra,0x0
    80001454:	880080e7          	jalr	-1920(ra) # 80000cd0 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001458:	875a                	mv	a4,s6
    8000145a:	86a6                	mv	a3,s1
    8000145c:	6605                	lui	a2,0x1
    8000145e:	85ca                	mv	a1,s2
    80001460:	8556                	mv	a0,s5
    80001462:	00000097          	auipc	ra,0x0
    80001466:	c3a080e7          	jalr	-966(ra) # 8000109c <mappages>
    8000146a:	e90d                	bnez	a0,8000149c <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000146c:	6785                	lui	a5,0x1
    8000146e:	993e                	add	s2,s2,a5
    80001470:	fd4968e3          	bltu	s2,s4,80001440 <uvmalloc+0x32>
  return newsz;
    80001474:	8552                	mv	a0,s4
    80001476:	a809                	j	80001488 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80001478:	864e                	mv	a2,s3
    8000147a:	85ca                	mv	a1,s2
    8000147c:	8556                	mv	a0,s5
    8000147e:	00000097          	auipc	ra,0x0
    80001482:	f48080e7          	jalr	-184(ra) # 800013c6 <uvmdealloc>
      return 0;
    80001486:	4501                	li	a0,0
}
    80001488:	70e2                	ld	ra,56(sp)
    8000148a:	7442                	ld	s0,48(sp)
    8000148c:	74a2                	ld	s1,40(sp)
    8000148e:	7902                	ld	s2,32(sp)
    80001490:	69e2                	ld	s3,24(sp)
    80001492:	6a42                	ld	s4,16(sp)
    80001494:	6aa2                	ld	s5,8(sp)
    80001496:	6b02                	ld	s6,0(sp)
    80001498:	6121                	addi	sp,sp,64
    8000149a:	8082                	ret
      kfree(mem);
    8000149c:	8526                	mv	a0,s1
    8000149e:	fffff097          	auipc	ra,0xfffff
    800014a2:	548080e7          	jalr	1352(ra) # 800009e6 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014a6:	864e                	mv	a2,s3
    800014a8:	85ca                	mv	a1,s2
    800014aa:	8556                	mv	a0,s5
    800014ac:	00000097          	auipc	ra,0x0
    800014b0:	f1a080e7          	jalr	-230(ra) # 800013c6 <uvmdealloc>
      return 0;
    800014b4:	4501                	li	a0,0
    800014b6:	bfc9                	j	80001488 <uvmalloc+0x7a>
    return oldsz;
    800014b8:	852e                	mv	a0,a1
}
    800014ba:	8082                	ret
  return newsz;
    800014bc:	8532                	mv	a0,a2
    800014be:	b7e9                	j	80001488 <uvmalloc+0x7a>

00000000800014c0 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014c0:	7179                	addi	sp,sp,-48
    800014c2:	f406                	sd	ra,40(sp)
    800014c4:	f022                	sd	s0,32(sp)
    800014c6:	ec26                	sd	s1,24(sp)
    800014c8:	e84a                	sd	s2,16(sp)
    800014ca:	e44e                	sd	s3,8(sp)
    800014cc:	e052                	sd	s4,0(sp)
    800014ce:	1800                	addi	s0,sp,48
    800014d0:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014d2:	84aa                	mv	s1,a0
    800014d4:	6905                	lui	s2,0x1
    800014d6:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014d8:	4985                	li	s3,1
    800014da:	a829                	j	800014f4 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014dc:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014de:	00c79513          	slli	a0,a5,0xc
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	fde080e7          	jalr	-34(ra) # 800014c0 <freewalk>
      pagetable[i] = 0;
    800014ea:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014ee:	04a1                	addi	s1,s1,8
    800014f0:	03248163          	beq	s1,s2,80001512 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800014f4:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014f6:	00f7f713          	andi	a4,a5,15
    800014fa:	ff3701e3          	beq	a4,s3,800014dc <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014fe:	8b85                	andi	a5,a5,1
    80001500:	d7fd                	beqz	a5,800014ee <freewalk+0x2e>
      panic("freewalk: leaf");
    80001502:	00008517          	auipc	a0,0x8
    80001506:	c7650513          	addi	a0,a0,-906 # 80009178 <digits+0x138>
    8000150a:	fffff097          	auipc	ra,0xfffff
    8000150e:	034080e7          	jalr	52(ra) # 8000053e <panic>
    }
  }
  kfree((void*)pagetable);
    80001512:	8552                	mv	a0,s4
    80001514:	fffff097          	auipc	ra,0xfffff
    80001518:	4d2080e7          	jalr	1234(ra) # 800009e6 <kfree>
}
    8000151c:	70a2                	ld	ra,40(sp)
    8000151e:	7402                	ld	s0,32(sp)
    80001520:	64e2                	ld	s1,24(sp)
    80001522:	6942                	ld	s2,16(sp)
    80001524:	69a2                	ld	s3,8(sp)
    80001526:	6a02                	ld	s4,0(sp)
    80001528:	6145                	addi	sp,sp,48
    8000152a:	8082                	ret

000000008000152c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000152c:	1101                	addi	sp,sp,-32
    8000152e:	ec06                	sd	ra,24(sp)
    80001530:	e822                	sd	s0,16(sp)
    80001532:	e426                	sd	s1,8(sp)
    80001534:	1000                	addi	s0,sp,32
    80001536:	84aa                	mv	s1,a0
  if(sz > 0)
    80001538:	e999                	bnez	a1,8000154e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000153a:	8526                	mv	a0,s1
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	f84080e7          	jalr	-124(ra) # 800014c0 <freewalk>
}
    80001544:	60e2                	ld	ra,24(sp)
    80001546:	6442                	ld	s0,16(sp)
    80001548:	64a2                	ld	s1,8(sp)
    8000154a:	6105                	addi	sp,sp,32
    8000154c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000154e:	6785                	lui	a5,0x1
    80001550:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001552:	95be                	add	a1,a1,a5
    80001554:	4685                	li	a3,1
    80001556:	00c5d613          	srli	a2,a1,0xc
    8000155a:	4581                	li	a1,0
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	d06080e7          	jalr	-762(ra) # 80001262 <uvmunmap>
    80001564:	bfd9                	j	8000153a <uvmfree+0xe>

0000000080001566 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001566:	c679                	beqz	a2,80001634 <uvmcopy+0xce>
{
    80001568:	715d                	addi	sp,sp,-80
    8000156a:	e486                	sd	ra,72(sp)
    8000156c:	e0a2                	sd	s0,64(sp)
    8000156e:	fc26                	sd	s1,56(sp)
    80001570:	f84a                	sd	s2,48(sp)
    80001572:	f44e                	sd	s3,40(sp)
    80001574:	f052                	sd	s4,32(sp)
    80001576:	ec56                	sd	s5,24(sp)
    80001578:	e85a                	sd	s6,16(sp)
    8000157a:	e45e                	sd	s7,8(sp)
    8000157c:	0880                	addi	s0,sp,80
    8000157e:	8b2a                	mv	s6,a0
    80001580:	8aae                	mv	s5,a1
    80001582:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001584:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001586:	4601                	li	a2,0
    80001588:	85ce                	mv	a1,s3
    8000158a:	855a                	mv	a0,s6
    8000158c:	00000097          	auipc	ra,0x0
    80001590:	a28080e7          	jalr	-1496(ra) # 80000fb4 <walk>
    80001594:	c531                	beqz	a0,800015e0 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001596:	6118                	ld	a4,0(a0)
    80001598:	00177793          	andi	a5,a4,1
    8000159c:	cbb1                	beqz	a5,800015f0 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000159e:	00a75593          	srli	a1,a4,0xa
    800015a2:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015a6:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015aa:	fffff097          	auipc	ra,0xfffff
    800015ae:	53a080e7          	jalr	1338(ra) # 80000ae4 <kalloc>
    800015b2:	892a                	mv	s2,a0
    800015b4:	c939                	beqz	a0,8000160a <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015b6:	6605                	lui	a2,0x1
    800015b8:	85de                	mv	a1,s7
    800015ba:	fffff097          	auipc	ra,0xfffff
    800015be:	772080e7          	jalr	1906(ra) # 80000d2c <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015c2:	8726                	mv	a4,s1
    800015c4:	86ca                	mv	a3,s2
    800015c6:	6605                	lui	a2,0x1
    800015c8:	85ce                	mv	a1,s3
    800015ca:	8556                	mv	a0,s5
    800015cc:	00000097          	auipc	ra,0x0
    800015d0:	ad0080e7          	jalr	-1328(ra) # 8000109c <mappages>
    800015d4:	e515                	bnez	a0,80001600 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015d6:	6785                	lui	a5,0x1
    800015d8:	99be                	add	s3,s3,a5
    800015da:	fb49e6e3          	bltu	s3,s4,80001586 <uvmcopy+0x20>
    800015de:	a081                	j	8000161e <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015e0:	00008517          	auipc	a0,0x8
    800015e4:	ba850513          	addi	a0,a0,-1112 # 80009188 <digits+0x148>
    800015e8:	fffff097          	auipc	ra,0xfffff
    800015ec:	f56080e7          	jalr	-170(ra) # 8000053e <panic>
      panic("uvmcopy: page not present");
    800015f0:	00008517          	auipc	a0,0x8
    800015f4:	bb850513          	addi	a0,a0,-1096 # 800091a8 <digits+0x168>
    800015f8:	fffff097          	auipc	ra,0xfffff
    800015fc:	f46080e7          	jalr	-186(ra) # 8000053e <panic>
      kfree(mem);
    80001600:	854a                	mv	a0,s2
    80001602:	fffff097          	auipc	ra,0xfffff
    80001606:	3e4080e7          	jalr	996(ra) # 800009e6 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000160a:	4685                	li	a3,1
    8000160c:	00c9d613          	srli	a2,s3,0xc
    80001610:	4581                	li	a1,0
    80001612:	8556                	mv	a0,s5
    80001614:	00000097          	auipc	ra,0x0
    80001618:	c4e080e7          	jalr	-946(ra) # 80001262 <uvmunmap>
  return -1;
    8000161c:	557d                	li	a0,-1
}
    8000161e:	60a6                	ld	ra,72(sp)
    80001620:	6406                	ld	s0,64(sp)
    80001622:	74e2                	ld	s1,56(sp)
    80001624:	7942                	ld	s2,48(sp)
    80001626:	79a2                	ld	s3,40(sp)
    80001628:	7a02                	ld	s4,32(sp)
    8000162a:	6ae2                	ld	s5,24(sp)
    8000162c:	6b42                	ld	s6,16(sp)
    8000162e:	6ba2                	ld	s7,8(sp)
    80001630:	6161                	addi	sp,sp,80
    80001632:	8082                	ret
  return 0;
    80001634:	4501                	li	a0,0
}
    80001636:	8082                	ret

0000000080001638 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001638:	1141                	addi	sp,sp,-16
    8000163a:	e406                	sd	ra,8(sp)
    8000163c:	e022                	sd	s0,0(sp)
    8000163e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001640:	4601                	li	a2,0
    80001642:	00000097          	auipc	ra,0x0
    80001646:	972080e7          	jalr	-1678(ra) # 80000fb4 <walk>
  if(pte == 0)
    8000164a:	c901                	beqz	a0,8000165a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000164c:	611c                	ld	a5,0(a0)
    8000164e:	9bbd                	andi	a5,a5,-17
    80001650:	e11c                	sd	a5,0(a0)
}
    80001652:	60a2                	ld	ra,8(sp)
    80001654:	6402                	ld	s0,0(sp)
    80001656:	0141                	addi	sp,sp,16
    80001658:	8082                	ret
    panic("uvmclear");
    8000165a:	00008517          	auipc	a0,0x8
    8000165e:	b6e50513          	addi	a0,a0,-1170 # 800091c8 <digits+0x188>
    80001662:	fffff097          	auipc	ra,0xfffff
    80001666:	edc080e7          	jalr	-292(ra) # 8000053e <panic>

000000008000166a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000166a:	c6bd                	beqz	a3,800016d8 <copyout+0x6e>
{
    8000166c:	715d                	addi	sp,sp,-80
    8000166e:	e486                	sd	ra,72(sp)
    80001670:	e0a2                	sd	s0,64(sp)
    80001672:	fc26                	sd	s1,56(sp)
    80001674:	f84a                	sd	s2,48(sp)
    80001676:	f44e                	sd	s3,40(sp)
    80001678:	f052                	sd	s4,32(sp)
    8000167a:	ec56                	sd	s5,24(sp)
    8000167c:	e85a                	sd	s6,16(sp)
    8000167e:	e45e                	sd	s7,8(sp)
    80001680:	e062                	sd	s8,0(sp)
    80001682:	0880                	addi	s0,sp,80
    80001684:	8b2a                	mv	s6,a0
    80001686:	8c2e                	mv	s8,a1
    80001688:	8a32                	mv	s4,a2
    8000168a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000168c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000168e:	6a85                	lui	s5,0x1
    80001690:	a015                	j	800016b4 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001692:	9562                	add	a0,a0,s8
    80001694:	0004861b          	sext.w	a2,s1
    80001698:	85d2                	mv	a1,s4
    8000169a:	41250533          	sub	a0,a0,s2
    8000169e:	fffff097          	auipc	ra,0xfffff
    800016a2:	68e080e7          	jalr	1678(ra) # 80000d2c <memmove>

    len -= n;
    800016a6:	409989b3          	sub	s3,s3,s1
    src += n;
    800016aa:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016ac:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016b0:	02098263          	beqz	s3,800016d4 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016b4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016b8:	85ca                	mv	a1,s2
    800016ba:	855a                	mv	a0,s6
    800016bc:	00000097          	auipc	ra,0x0
    800016c0:	99e080e7          	jalr	-1634(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    800016c4:	cd01                	beqz	a0,800016dc <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016c6:	418904b3          	sub	s1,s2,s8
    800016ca:	94d6                	add	s1,s1,s5
    800016cc:	fc99f3e3          	bgeu	s3,s1,80001692 <copyout+0x28>
    800016d0:	84ce                	mv	s1,s3
    800016d2:	b7c1                	j	80001692 <copyout+0x28>
  }
  return 0;
    800016d4:	4501                	li	a0,0
    800016d6:	a021                	j	800016de <copyout+0x74>
    800016d8:	4501                	li	a0,0
}
    800016da:	8082                	ret
      return -1;
    800016dc:	557d                	li	a0,-1
}
    800016de:	60a6                	ld	ra,72(sp)
    800016e0:	6406                	ld	s0,64(sp)
    800016e2:	74e2                	ld	s1,56(sp)
    800016e4:	7942                	ld	s2,48(sp)
    800016e6:	79a2                	ld	s3,40(sp)
    800016e8:	7a02                	ld	s4,32(sp)
    800016ea:	6ae2                	ld	s5,24(sp)
    800016ec:	6b42                	ld	s6,16(sp)
    800016ee:	6ba2                	ld	s7,8(sp)
    800016f0:	6c02                	ld	s8,0(sp)
    800016f2:	6161                	addi	sp,sp,80
    800016f4:	8082                	ret

00000000800016f6 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016f6:	caa5                	beqz	a3,80001766 <copyin+0x70>
{
    800016f8:	715d                	addi	sp,sp,-80
    800016fa:	e486                	sd	ra,72(sp)
    800016fc:	e0a2                	sd	s0,64(sp)
    800016fe:	fc26                	sd	s1,56(sp)
    80001700:	f84a                	sd	s2,48(sp)
    80001702:	f44e                	sd	s3,40(sp)
    80001704:	f052                	sd	s4,32(sp)
    80001706:	ec56                	sd	s5,24(sp)
    80001708:	e85a                	sd	s6,16(sp)
    8000170a:	e45e                	sd	s7,8(sp)
    8000170c:	e062                	sd	s8,0(sp)
    8000170e:	0880                	addi	s0,sp,80
    80001710:	8b2a                	mv	s6,a0
    80001712:	8a2e                	mv	s4,a1
    80001714:	8c32                	mv	s8,a2
    80001716:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001718:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000171a:	6a85                	lui	s5,0x1
    8000171c:	a01d                	j	80001742 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000171e:	018505b3          	add	a1,a0,s8
    80001722:	0004861b          	sext.w	a2,s1
    80001726:	412585b3          	sub	a1,a1,s2
    8000172a:	8552                	mv	a0,s4
    8000172c:	fffff097          	auipc	ra,0xfffff
    80001730:	600080e7          	jalr	1536(ra) # 80000d2c <memmove>

    len -= n;
    80001734:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001738:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000173a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000173e:	02098263          	beqz	s3,80001762 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001742:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001746:	85ca                	mv	a1,s2
    80001748:	855a                	mv	a0,s6
    8000174a:	00000097          	auipc	ra,0x0
    8000174e:	910080e7          	jalr	-1776(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    80001752:	cd01                	beqz	a0,8000176a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001754:	418904b3          	sub	s1,s2,s8
    80001758:	94d6                	add	s1,s1,s5
    8000175a:	fc99f2e3          	bgeu	s3,s1,8000171e <copyin+0x28>
    8000175e:	84ce                	mv	s1,s3
    80001760:	bf7d                	j	8000171e <copyin+0x28>
  }
  return 0;
    80001762:	4501                	li	a0,0
    80001764:	a021                	j	8000176c <copyin+0x76>
    80001766:	4501                	li	a0,0
}
    80001768:	8082                	ret
      return -1;
    8000176a:	557d                	li	a0,-1
}
    8000176c:	60a6                	ld	ra,72(sp)
    8000176e:	6406                	ld	s0,64(sp)
    80001770:	74e2                	ld	s1,56(sp)
    80001772:	7942                	ld	s2,48(sp)
    80001774:	79a2                	ld	s3,40(sp)
    80001776:	7a02                	ld	s4,32(sp)
    80001778:	6ae2                	ld	s5,24(sp)
    8000177a:	6b42                	ld	s6,16(sp)
    8000177c:	6ba2                	ld	s7,8(sp)
    8000177e:	6c02                	ld	s8,0(sp)
    80001780:	6161                	addi	sp,sp,80
    80001782:	8082                	ret

0000000080001784 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001784:	c2dd                	beqz	a3,8000182a <copyinstr+0xa6>
{
    80001786:	715d                	addi	sp,sp,-80
    80001788:	e486                	sd	ra,72(sp)
    8000178a:	e0a2                	sd	s0,64(sp)
    8000178c:	fc26                	sd	s1,56(sp)
    8000178e:	f84a                	sd	s2,48(sp)
    80001790:	f44e                	sd	s3,40(sp)
    80001792:	f052                	sd	s4,32(sp)
    80001794:	ec56                	sd	s5,24(sp)
    80001796:	e85a                	sd	s6,16(sp)
    80001798:	e45e                	sd	s7,8(sp)
    8000179a:	0880                	addi	s0,sp,80
    8000179c:	8a2a                	mv	s4,a0
    8000179e:	8b2e                	mv	s6,a1
    800017a0:	8bb2                	mv	s7,a2
    800017a2:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017a4:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017a6:	6985                	lui	s3,0x1
    800017a8:	a02d                	j	800017d2 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017aa:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017ae:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017b0:	37fd                	addiw	a5,a5,-1
    800017b2:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017b6:	60a6                	ld	ra,72(sp)
    800017b8:	6406                	ld	s0,64(sp)
    800017ba:	74e2                	ld	s1,56(sp)
    800017bc:	7942                	ld	s2,48(sp)
    800017be:	79a2                	ld	s3,40(sp)
    800017c0:	7a02                	ld	s4,32(sp)
    800017c2:	6ae2                	ld	s5,24(sp)
    800017c4:	6b42                	ld	s6,16(sp)
    800017c6:	6ba2                	ld	s7,8(sp)
    800017c8:	6161                	addi	sp,sp,80
    800017ca:	8082                	ret
    srcva = va0 + PGSIZE;
    800017cc:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017d0:	c8a9                	beqz	s1,80001822 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    800017d2:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017d6:	85ca                	mv	a1,s2
    800017d8:	8552                	mv	a0,s4
    800017da:	00000097          	auipc	ra,0x0
    800017de:	880080e7          	jalr	-1920(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    800017e2:	c131                	beqz	a0,80001826 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800017e4:	417906b3          	sub	a3,s2,s7
    800017e8:	96ce                	add	a3,a3,s3
    800017ea:	00d4f363          	bgeu	s1,a3,800017f0 <copyinstr+0x6c>
    800017ee:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017f0:	955e                	add	a0,a0,s7
    800017f2:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017f6:	daf9                	beqz	a3,800017cc <copyinstr+0x48>
    800017f8:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017fa:	41650633          	sub	a2,a0,s6
    800017fe:	fff48593          	addi	a1,s1,-1
    80001802:	95da                	add	a1,a1,s6
    while(n > 0){
    80001804:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80001806:	00f60733          	add	a4,a2,a5
    8000180a:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdb5a0>
    8000180e:	df51                	beqz	a4,800017aa <copyinstr+0x26>
        *dst = *p;
    80001810:	00e78023          	sb	a4,0(a5)
      --max;
    80001814:	40f584b3          	sub	s1,a1,a5
      dst++;
    80001818:	0785                	addi	a5,a5,1
    while(n > 0){
    8000181a:	fed796e3          	bne	a5,a3,80001806 <copyinstr+0x82>
      dst++;
    8000181e:	8b3e                	mv	s6,a5
    80001820:	b775                	j	800017cc <copyinstr+0x48>
    80001822:	4781                	li	a5,0
    80001824:	b771                	j	800017b0 <copyinstr+0x2c>
      return -1;
    80001826:	557d                	li	a0,-1
    80001828:	b779                	j	800017b6 <copyinstr+0x32>
  int got_null = 0;
    8000182a:	4781                	li	a5,0
  if(got_null){
    8000182c:	37fd                	addiw	a5,a5,-1
    8000182e:	0007851b          	sext.w	a0,a5
}
    80001832:	8082                	ret

0000000080001834 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001834:	7139                	addi	sp,sp,-64
    80001836:	fc06                	sd	ra,56(sp)
    80001838:	f822                	sd	s0,48(sp)
    8000183a:	f426                	sd	s1,40(sp)
    8000183c:	f04a                	sd	s2,32(sp)
    8000183e:	ec4e                	sd	s3,24(sp)
    80001840:	e852                	sd	s4,16(sp)
    80001842:	e456                	sd	s5,8(sp)
    80001844:	e05a                	sd	s6,0(sp)
    80001846:	0080                	addi	s0,sp,64
    80001848:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000184a:	00011497          	auipc	s1,0x11
    8000184e:	a3648493          	addi	s1,s1,-1482 # 80012280 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001852:	8b26                	mv	s6,s1
    80001854:	00007a97          	auipc	s5,0x7
    80001858:	7aca8a93          	addi	s5,s5,1964 # 80009000 <etext>
    8000185c:	04000937          	lui	s2,0x4000
    80001860:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001862:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001864:	00017a17          	auipc	s4,0x17
    80001868:	e1ca0a13          	addi	s4,s4,-484 # 80018680 <tickslock>
    char *pa = kalloc();
    8000186c:	fffff097          	auipc	ra,0xfffff
    80001870:	278080e7          	jalr	632(ra) # 80000ae4 <kalloc>
    80001874:	862a                	mv	a2,a0
    if(pa == 0)
    80001876:	c131                	beqz	a0,800018ba <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001878:	416485b3          	sub	a1,s1,s6
    8000187c:	8591                	srai	a1,a1,0x4
    8000187e:	000ab783          	ld	a5,0(s5)
    80001882:	02f585b3          	mul	a1,a1,a5
    80001886:	2585                	addiw	a1,a1,1
    80001888:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000188c:	4719                	li	a4,6
    8000188e:	6685                	lui	a3,0x1
    80001890:	40b905b3          	sub	a1,s2,a1
    80001894:	854e                	mv	a0,s3
    80001896:	00000097          	auipc	ra,0x0
    8000189a:	8a6080e7          	jalr	-1882(ra) # 8000113c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000189e:	19048493          	addi	s1,s1,400
    800018a2:	fd4495e3          	bne	s1,s4,8000186c <proc_mapstacks+0x38>
  }
}
    800018a6:	70e2                	ld	ra,56(sp)
    800018a8:	7442                	ld	s0,48(sp)
    800018aa:	74a2                	ld	s1,40(sp)
    800018ac:	7902                	ld	s2,32(sp)
    800018ae:	69e2                	ld	s3,24(sp)
    800018b0:	6a42                	ld	s4,16(sp)
    800018b2:	6aa2                	ld	s5,8(sp)
    800018b4:	6b02                	ld	s6,0(sp)
    800018b6:	6121                	addi	sp,sp,64
    800018b8:	8082                	ret
      panic("kalloc");
    800018ba:	00008517          	auipc	a0,0x8
    800018be:	91e50513          	addi	a0,a0,-1762 # 800091d8 <digits+0x198>
    800018c2:	fffff097          	auipc	ra,0xfffff
    800018c6:	c7c080e7          	jalr	-900(ra) # 8000053e <panic>

00000000800018ca <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800018ca:	7139                	addi	sp,sp,-64
    800018cc:	fc06                	sd	ra,56(sp)
    800018ce:	f822                	sd	s0,48(sp)
    800018d0:	f426                	sd	s1,40(sp)
    800018d2:	f04a                	sd	s2,32(sp)
    800018d4:	ec4e                	sd	s3,24(sp)
    800018d6:	e852                	sd	s4,16(sp)
    800018d8:	e456                	sd	s5,8(sp)
    800018da:	e05a                	sd	s6,0(sp)
    800018dc:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018de:	00008597          	auipc	a1,0x8
    800018e2:	90258593          	addi	a1,a1,-1790 # 800091e0 <digits+0x1a0>
    800018e6:	00010517          	auipc	a0,0x10
    800018ea:	56a50513          	addi	a0,a0,1386 # 80011e50 <pid_lock>
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	256080e7          	jalr	598(ra) # 80000b44 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018f6:	00008597          	auipc	a1,0x8
    800018fa:	8f258593          	addi	a1,a1,-1806 # 800091e8 <digits+0x1a8>
    800018fe:	00010517          	auipc	a0,0x10
    80001902:	56a50513          	addi	a0,a0,1386 # 80011e68 <wait_lock>
    80001906:	fffff097          	auipc	ra,0xfffff
    8000190a:	23e080e7          	jalr	574(ra) # 80000b44 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000190e:	00011497          	auipc	s1,0x11
    80001912:	97248493          	addi	s1,s1,-1678 # 80012280 <proc>
      initlock(&p->lock, "proc");
    80001916:	00008b17          	auipc	s6,0x8
    8000191a:	8e2b0b13          	addi	s6,s6,-1822 # 800091f8 <digits+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000191e:	8aa6                	mv	s5,s1
    80001920:	00007a17          	auipc	s4,0x7
    80001924:	6e0a0a13          	addi	s4,s4,1760 # 80009000 <etext>
    80001928:	04000937          	lui	s2,0x4000
    8000192c:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000192e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001930:	00017997          	auipc	s3,0x17
    80001934:	d5098993          	addi	s3,s3,-688 # 80018680 <tickslock>
      initlock(&p->lock, "proc");
    80001938:	85da                	mv	a1,s6
    8000193a:	8526                	mv	a0,s1
    8000193c:	fffff097          	auipc	ra,0xfffff
    80001940:	208080e7          	jalr	520(ra) # 80000b44 <initlock>
      p->state = UNUSED;
    80001944:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001948:	415487b3          	sub	a5,s1,s5
    8000194c:	8791                	srai	a5,a5,0x4
    8000194e:	000a3703          	ld	a4,0(s4)
    80001952:	02e787b3          	mul	a5,a5,a4
    80001956:	2785                	addiw	a5,a5,1
    80001958:	00d7979b          	slliw	a5,a5,0xd
    8000195c:	40f907b3          	sub	a5,s2,a5
    80001960:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001962:	19048493          	addi	s1,s1,400
    80001966:	fd3499e3          	bne	s1,s3,80001938 <procinit+0x6e>
  }
}
    8000196a:	70e2                	ld	ra,56(sp)
    8000196c:	7442                	ld	s0,48(sp)
    8000196e:	74a2                	ld	s1,40(sp)
    80001970:	7902                	ld	s2,32(sp)
    80001972:	69e2                	ld	s3,24(sp)
    80001974:	6a42                	ld	s4,16(sp)
    80001976:	6aa2                	ld	s5,8(sp)
    80001978:	6b02                	ld	s6,0(sp)
    8000197a:	6121                	addi	sp,sp,64
    8000197c:	8082                	ret

000000008000197e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000197e:	1141                	addi	sp,sp,-16
    80001980:	e422                	sd	s0,8(sp)
    80001982:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001984:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001986:	2501                	sext.w	a0,a0
    80001988:	6422                	ld	s0,8(sp)
    8000198a:	0141                	addi	sp,sp,16
    8000198c:	8082                	ret

000000008000198e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000198e:	1141                	addi	sp,sp,-16
    80001990:	e422                	sd	s0,8(sp)
    80001992:	0800                	addi	s0,sp,16
    80001994:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001996:	2781                	sext.w	a5,a5
    80001998:	079e                	slli	a5,a5,0x7
  return c;
}
    8000199a:	00010517          	auipc	a0,0x10
    8000199e:	4e650513          	addi	a0,a0,1254 # 80011e80 <cpus>
    800019a2:	953e                	add	a0,a0,a5
    800019a4:	6422                	ld	s0,8(sp)
    800019a6:	0141                	addi	sp,sp,16
    800019a8:	8082                	ret

00000000800019aa <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800019aa:	1101                	addi	sp,sp,-32
    800019ac:	ec06                	sd	ra,24(sp)
    800019ae:	e822                	sd	s0,16(sp)
    800019b0:	e426                	sd	s1,8(sp)
    800019b2:	1000                	addi	s0,sp,32
  push_off();
    800019b4:	fffff097          	auipc	ra,0xfffff
    800019b8:	1d4080e7          	jalr	468(ra) # 80000b88 <push_off>
    800019bc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019be:	2781                	sext.w	a5,a5
    800019c0:	079e                	slli	a5,a5,0x7
    800019c2:	00010717          	auipc	a4,0x10
    800019c6:	48e70713          	addi	a4,a4,1166 # 80011e50 <pid_lock>
    800019ca:	97ba                	add	a5,a5,a4
    800019cc:	7b84                	ld	s1,48(a5)
  pop_off();
    800019ce:	fffff097          	auipc	ra,0xfffff
    800019d2:	25a080e7          	jalr	602(ra) # 80000c28 <pop_off>
  return p;
}
    800019d6:	8526                	mv	a0,s1
    800019d8:	60e2                	ld	ra,24(sp)
    800019da:	6442                	ld	s0,16(sp)
    800019dc:	64a2                	ld	s1,8(sp)
    800019de:	6105                	addi	sp,sp,32
    800019e0:	8082                	ret

00000000800019e2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800019e2:	1141                	addi	sp,sp,-16
    800019e4:	e406                	sd	ra,8(sp)
    800019e6:	e022                	sd	s0,0(sp)
    800019e8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800019ea:	00000097          	auipc	ra,0x0
    800019ee:	fc0080e7          	jalr	-64(ra) # 800019aa <myproc>
    800019f2:	fffff097          	auipc	ra,0xfffff
    800019f6:	296080e7          	jalr	662(ra) # 80000c88 <release>

  if (first) {
    800019fa:	00008797          	auipc	a5,0x8
    800019fe:	1467a783          	lw	a5,326(a5) # 80009b40 <first.1>
    80001a02:	eb89                	bnez	a5,80001a14 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a04:	00001097          	auipc	ra,0x1
    80001a08:	d2c080e7          	jalr	-724(ra) # 80002730 <usertrapret>
}
    80001a0c:	60a2                	ld	ra,8(sp)
    80001a0e:	6402                	ld	s0,0(sp)
    80001a10:	0141                	addi	sp,sp,16
    80001a12:	8082                	ret
    first = 0;
    80001a14:	00008797          	auipc	a5,0x8
    80001a18:	1207a623          	sw	zero,300(a5) # 80009b40 <first.1>
    fsinit(ROOTDEV);
    80001a1c:	4505                	li	a0,1
    80001a1e:	00002097          	auipc	ra,0x2
    80001a22:	f02080e7          	jalr	-254(ra) # 80003920 <fsinit>
    80001a26:	bff9                	j	80001a04 <forkret+0x22>

0000000080001a28 <allocpid>:
{
    80001a28:	1101                	addi	sp,sp,-32
    80001a2a:	ec06                	sd	ra,24(sp)
    80001a2c:	e822                	sd	s0,16(sp)
    80001a2e:	e426                	sd	s1,8(sp)
    80001a30:	e04a                	sd	s2,0(sp)
    80001a32:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a34:	00010917          	auipc	s2,0x10
    80001a38:	41c90913          	addi	s2,s2,1052 # 80011e50 <pid_lock>
    80001a3c:	854a                	mv	a0,s2
    80001a3e:	fffff097          	auipc	ra,0xfffff
    80001a42:	196080e7          	jalr	406(ra) # 80000bd4 <acquire>
  pid = nextpid;
    80001a46:	00008797          	auipc	a5,0x8
    80001a4a:	0fe78793          	addi	a5,a5,254 # 80009b44 <nextpid>
    80001a4e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a50:	0014871b          	addiw	a4,s1,1
    80001a54:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a56:	854a                	mv	a0,s2
    80001a58:	fffff097          	auipc	ra,0xfffff
    80001a5c:	230080e7          	jalr	560(ra) # 80000c88 <release>
}
    80001a60:	8526                	mv	a0,s1
    80001a62:	60e2                	ld	ra,24(sp)
    80001a64:	6442                	ld	s0,16(sp)
    80001a66:	64a2                	ld	s1,8(sp)
    80001a68:	6902                	ld	s2,0(sp)
    80001a6a:	6105                	addi	sp,sp,32
    80001a6c:	8082                	ret

0000000080001a6e <proc_pagetable>:
{
    80001a6e:	1101                	addi	sp,sp,-32
    80001a70:	ec06                	sd	ra,24(sp)
    80001a72:	e822                	sd	s0,16(sp)
    80001a74:	e426                	sd	s1,8(sp)
    80001a76:	e04a                	sd	s2,0(sp)
    80001a78:	1000                	addi	s0,sp,32
    80001a7a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a7c:	00000097          	auipc	ra,0x0
    80001a80:	8aa080e7          	jalr	-1878(ra) # 80001326 <uvmcreate>
    80001a84:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a86:	c121                	beqz	a0,80001ac6 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a88:	4729                	li	a4,10
    80001a8a:	00006697          	auipc	a3,0x6
    80001a8e:	57668693          	addi	a3,a3,1398 # 80008000 <_trampoline>
    80001a92:	6605                	lui	a2,0x1
    80001a94:	040005b7          	lui	a1,0x4000
    80001a98:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a9a:	05b2                	slli	a1,a1,0xc
    80001a9c:	fffff097          	auipc	ra,0xfffff
    80001aa0:	600080e7          	jalr	1536(ra) # 8000109c <mappages>
    80001aa4:	02054863          	bltz	a0,80001ad4 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001aa8:	4719                	li	a4,6
    80001aaa:	05893683          	ld	a3,88(s2)
    80001aae:	6605                	lui	a2,0x1
    80001ab0:	020005b7          	lui	a1,0x2000
    80001ab4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ab6:	05b6                	slli	a1,a1,0xd
    80001ab8:	8526                	mv	a0,s1
    80001aba:	fffff097          	auipc	ra,0xfffff
    80001abe:	5e2080e7          	jalr	1506(ra) # 8000109c <mappages>
    80001ac2:	02054163          	bltz	a0,80001ae4 <proc_pagetable+0x76>
}
    80001ac6:	8526                	mv	a0,s1
    80001ac8:	60e2                	ld	ra,24(sp)
    80001aca:	6442                	ld	s0,16(sp)
    80001acc:	64a2                	ld	s1,8(sp)
    80001ace:	6902                	ld	s2,0(sp)
    80001ad0:	6105                	addi	sp,sp,32
    80001ad2:	8082                	ret
    uvmfree(pagetable, 0);
    80001ad4:	4581                	li	a1,0
    80001ad6:	8526                	mv	a0,s1
    80001ad8:	00000097          	auipc	ra,0x0
    80001adc:	a54080e7          	jalr	-1452(ra) # 8000152c <uvmfree>
    return 0;
    80001ae0:	4481                	li	s1,0
    80001ae2:	b7d5                	j	80001ac6 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ae4:	4681                	li	a3,0
    80001ae6:	4605                	li	a2,1
    80001ae8:	040005b7          	lui	a1,0x4000
    80001aec:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001aee:	05b2                	slli	a1,a1,0xc
    80001af0:	8526                	mv	a0,s1
    80001af2:	fffff097          	auipc	ra,0xfffff
    80001af6:	770080e7          	jalr	1904(ra) # 80001262 <uvmunmap>
    uvmfree(pagetable, 0);
    80001afa:	4581                	li	a1,0
    80001afc:	8526                	mv	a0,s1
    80001afe:	00000097          	auipc	ra,0x0
    80001b02:	a2e080e7          	jalr	-1490(ra) # 8000152c <uvmfree>
    return 0;
    80001b06:	4481                	li	s1,0
    80001b08:	bf7d                	j	80001ac6 <proc_pagetable+0x58>

0000000080001b0a <proc_freepagetable>:
{
    80001b0a:	1101                	addi	sp,sp,-32
    80001b0c:	ec06                	sd	ra,24(sp)
    80001b0e:	e822                	sd	s0,16(sp)
    80001b10:	e426                	sd	s1,8(sp)
    80001b12:	e04a                	sd	s2,0(sp)
    80001b14:	1000                	addi	s0,sp,32
    80001b16:	84aa                	mv	s1,a0
    80001b18:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b1a:	4681                	li	a3,0
    80001b1c:	4605                	li	a2,1
    80001b1e:	040005b7          	lui	a1,0x4000
    80001b22:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b24:	05b2                	slli	a1,a1,0xc
    80001b26:	fffff097          	auipc	ra,0xfffff
    80001b2a:	73c080e7          	jalr	1852(ra) # 80001262 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b2e:	4681                	li	a3,0
    80001b30:	4605                	li	a2,1
    80001b32:	020005b7          	lui	a1,0x2000
    80001b36:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b38:	05b6                	slli	a1,a1,0xd
    80001b3a:	8526                	mv	a0,s1
    80001b3c:	fffff097          	auipc	ra,0xfffff
    80001b40:	726080e7          	jalr	1830(ra) # 80001262 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b44:	85ca                	mv	a1,s2
    80001b46:	8526                	mv	a0,s1
    80001b48:	00000097          	auipc	ra,0x0
    80001b4c:	9e4080e7          	jalr	-1564(ra) # 8000152c <uvmfree>
}
    80001b50:	60e2                	ld	ra,24(sp)
    80001b52:	6442                	ld	s0,16(sp)
    80001b54:	64a2                	ld	s1,8(sp)
    80001b56:	6902                	ld	s2,0(sp)
    80001b58:	6105                	addi	sp,sp,32
    80001b5a:	8082                	ret

0000000080001b5c <freeproc>:
{
    80001b5c:	1101                	addi	sp,sp,-32
    80001b5e:	ec06                	sd	ra,24(sp)
    80001b60:	e822                	sd	s0,16(sp)
    80001b62:	e426                	sd	s1,8(sp)
    80001b64:	1000                	addi	s0,sp,32
    80001b66:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b68:	6d28                	ld	a0,88(a0)
    80001b6a:	c509                	beqz	a0,80001b74 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b6c:	fffff097          	auipc	ra,0xfffff
    80001b70:	e7a080e7          	jalr	-390(ra) # 800009e6 <kfree>
  p->trapframe = 0;
    80001b74:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b78:	68a8                	ld	a0,80(s1)
    80001b7a:	c511                	beqz	a0,80001b86 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b7c:	64ac                	ld	a1,72(s1)
    80001b7e:	00000097          	auipc	ra,0x0
    80001b82:	f8c080e7          	jalr	-116(ra) # 80001b0a <proc_freepagetable>
  p->pagetable = 0;
    80001b86:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b8a:	0404b423          	sd	zero,72(s1)
  p->parent = 0;
    80001b8e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b92:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b96:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b9a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b9e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ba2:	0004ac23          	sw	zero,24(s1)
}
    80001ba6:	60e2                	ld	ra,24(sp)
    80001ba8:	6442                	ld	s0,16(sp)
    80001baa:	64a2                	ld	s1,8(sp)
    80001bac:	6105                	addi	sp,sp,32
    80001bae:	8082                	ret

0000000080001bb0 <allocproc>:
{
    80001bb0:	1101                	addi	sp,sp,-32
    80001bb2:	ec06                	sd	ra,24(sp)
    80001bb4:	e822                	sd	s0,16(sp)
    80001bb6:	e426                	sd	s1,8(sp)
    80001bb8:	e04a                	sd	s2,0(sp)
    80001bba:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bbc:	00010497          	auipc	s1,0x10
    80001bc0:	6c448493          	addi	s1,s1,1732 # 80012280 <proc>
    80001bc4:	00017917          	auipc	s2,0x17
    80001bc8:	abc90913          	addi	s2,s2,-1348 # 80018680 <tickslock>
    acquire(&p->lock);
    80001bcc:	8526                	mv	a0,s1
    80001bce:	fffff097          	auipc	ra,0xfffff
    80001bd2:	006080e7          	jalr	6(ra) # 80000bd4 <acquire>
    if(p->state == UNUSED) {
    80001bd6:	4c9c                	lw	a5,24(s1)
    80001bd8:	cf81                	beqz	a5,80001bf0 <allocproc+0x40>
      release(&p->lock);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	fffff097          	auipc	ra,0xfffff
    80001be0:	0ac080e7          	jalr	172(ra) # 80000c88 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001be4:	19048493          	addi	s1,s1,400
    80001be8:	ff2492e3          	bne	s1,s2,80001bcc <allocproc+0x1c>
  return 0;
    80001bec:	4481                	li	s1,0
    80001bee:	a0a5                	j	80001c56 <allocproc+0xa6>
  p->execTime.creationTime = sys_uptime();
    80001bf0:	00001097          	auipc	ra,0x1
    80001bf4:	678080e7          	jalr	1656(ra) # 80003268 <sys_uptime>
    80001bf8:	16a4b423          	sd	a0,360(s1)
  p->execTime.runningTime = 0;
    80001bfc:	1804b023          	sd	zero,384(s1)
  p->priority = DEFAULT_PRIORITY;
    80001c00:	47a9                	li	a5,10
    80001c02:	18f4a423          	sw	a5,392(s1)
  p->pid = allocpid();
    80001c06:	00000097          	auipc	ra,0x0
    80001c0a:	e22080e7          	jalr	-478(ra) # 80001a28 <allocpid>
    80001c0e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c10:	4785                	li	a5,1
    80001c12:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c14:	fffff097          	auipc	ra,0xfffff
    80001c18:	ed0080e7          	jalr	-304(ra) # 80000ae4 <kalloc>
    80001c1c:	892a                	mv	s2,a0
    80001c1e:	eca8                	sd	a0,88(s1)
    80001c20:	c131                	beqz	a0,80001c64 <allocproc+0xb4>
  p->pagetable = proc_pagetable(p);
    80001c22:	8526                	mv	a0,s1
    80001c24:	00000097          	auipc	ra,0x0
    80001c28:	e4a080e7          	jalr	-438(ra) # 80001a6e <proc_pagetable>
    80001c2c:	892a                	mv	s2,a0
    80001c2e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c30:	c531                	beqz	a0,80001c7c <allocproc+0xcc>
  memset(&p->context, 0, sizeof(p->context));
    80001c32:	07000613          	li	a2,112
    80001c36:	4581                	li	a1,0
    80001c38:	06048513          	addi	a0,s1,96
    80001c3c:	fffff097          	auipc	ra,0xfffff
    80001c40:	094080e7          	jalr	148(ra) # 80000cd0 <memset>
  p->context.ra = (uint64)forkret;
    80001c44:	00000797          	auipc	a5,0x0
    80001c48:	d9e78793          	addi	a5,a5,-610 # 800019e2 <forkret>
    80001c4c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c4e:	60bc                	ld	a5,64(s1)
    80001c50:	6705                	lui	a4,0x1
    80001c52:	97ba                	add	a5,a5,a4
    80001c54:	f4bc                	sd	a5,104(s1)
}
    80001c56:	8526                	mv	a0,s1
    80001c58:	60e2                	ld	ra,24(sp)
    80001c5a:	6442                	ld	s0,16(sp)
    80001c5c:	64a2                	ld	s1,8(sp)
    80001c5e:	6902                	ld	s2,0(sp)
    80001c60:	6105                	addi	sp,sp,32
    80001c62:	8082                	ret
    freeproc(p);
    80001c64:	8526                	mv	a0,s1
    80001c66:	00000097          	auipc	ra,0x0
    80001c6a:	ef6080e7          	jalr	-266(ra) # 80001b5c <freeproc>
    release(&p->lock);
    80001c6e:	8526                	mv	a0,s1
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	018080e7          	jalr	24(ra) # 80000c88 <release>
    return 0;
    80001c78:	84ca                	mv	s1,s2
    80001c7a:	bff1                	j	80001c56 <allocproc+0xa6>
    freeproc(p);
    80001c7c:	8526                	mv	a0,s1
    80001c7e:	00000097          	auipc	ra,0x0
    80001c82:	ede080e7          	jalr	-290(ra) # 80001b5c <freeproc>
    release(&p->lock);
    80001c86:	8526                	mv	a0,s1
    80001c88:	fffff097          	auipc	ra,0xfffff
    80001c8c:	000080e7          	jalr	ra # 80000c88 <release>
    return 0;
    80001c90:	84ca                	mv	s1,s2
    80001c92:	b7d1                	j	80001c56 <allocproc+0xa6>

0000000080001c94 <userinit>:
{
    80001c94:	1101                	addi	sp,sp,-32
    80001c96:	ec06                	sd	ra,24(sp)
    80001c98:	e822                	sd	s0,16(sp)
    80001c9a:	e426                	sd	s1,8(sp)
    80001c9c:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c9e:	00000097          	auipc	ra,0x0
    80001ca2:	f12080e7          	jalr	-238(ra) # 80001bb0 <allocproc>
    80001ca6:	84aa                	mv	s1,a0
  initproc = p;
    80001ca8:	00008797          	auipc	a5,0x8
    80001cac:	f2a7b823          	sd	a0,-208(a5) # 80009bd8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001cb0:	03400613          	li	a2,52
    80001cb4:	00008597          	auipc	a1,0x8
    80001cb8:	e9c58593          	addi	a1,a1,-356 # 80009b50 <initcode>
    80001cbc:	6928                	ld	a0,80(a0)
    80001cbe:	fffff097          	auipc	ra,0xfffff
    80001cc2:	696080e7          	jalr	1686(ra) # 80001354 <uvmfirst>
  p->sz = PGSIZE;
    80001cc6:	6785                	lui	a5,0x1
    80001cc8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cca:	6cb8                	ld	a4,88(s1)
    80001ccc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001cd0:	6cb8                	ld	a4,88(s1)
    80001cd2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cd4:	4641                	li	a2,16
    80001cd6:	00007597          	auipc	a1,0x7
    80001cda:	52a58593          	addi	a1,a1,1322 # 80009200 <digits+0x1c0>
    80001cde:	15848513          	addi	a0,s1,344
    80001ce2:	fffff097          	auipc	ra,0xfffff
    80001ce6:	138080e7          	jalr	312(ra) # 80000e1a <safestrcpy>
  p->cwd = namei("/");
    80001cea:	00007517          	auipc	a0,0x7
    80001cee:	52650513          	addi	a0,a0,1318 # 80009210 <digits+0x1d0>
    80001cf2:	00002097          	auipc	ra,0x2
    80001cf6:	658080e7          	jalr	1624(ra) # 8000434a <namei>
    80001cfa:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cfe:	478d                	li	a5,3
    80001d00:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d02:	8526                	mv	a0,s1
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	f84080e7          	jalr	-124(ra) # 80000c88 <release>
}
    80001d0c:	60e2                	ld	ra,24(sp)
    80001d0e:	6442                	ld	s0,16(sp)
    80001d10:	64a2                	ld	s1,8(sp)
    80001d12:	6105                	addi	sp,sp,32
    80001d14:	8082                	ret

0000000080001d16 <growproc>:
{
    80001d16:	1101                	addi	sp,sp,-32
    80001d18:	ec06                	sd	ra,24(sp)
    80001d1a:	e822                	sd	s0,16(sp)
    80001d1c:	e426                	sd	s1,8(sp)
    80001d1e:	e04a                	sd	s2,0(sp)
    80001d20:	1000                	addi	s0,sp,32
    80001d22:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	c86080e7          	jalr	-890(ra) # 800019aa <myproc>
    80001d2c:	84aa                	mv	s1,a0
  sz = p->sz;
    80001d2e:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001d30:	01204c63          	bgtz	s2,80001d48 <growproc+0x32>
  } else if(n < 0){
    80001d34:	02094663          	bltz	s2,80001d60 <growproc+0x4a>
  p->sz = sz;
    80001d38:	e4ac                	sd	a1,72(s1)
  return 0;
    80001d3a:	4501                	li	a0,0
}
    80001d3c:	60e2                	ld	ra,24(sp)
    80001d3e:	6442                	ld	s0,16(sp)
    80001d40:	64a2                	ld	s1,8(sp)
    80001d42:	6902                	ld	s2,0(sp)
    80001d44:	6105                	addi	sp,sp,32
    80001d46:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d48:	4691                	li	a3,4
    80001d4a:	00b90633          	add	a2,s2,a1
    80001d4e:	6928                	ld	a0,80(a0)
    80001d50:	fffff097          	auipc	ra,0xfffff
    80001d54:	6be080e7          	jalr	1726(ra) # 8000140e <uvmalloc>
    80001d58:	85aa                	mv	a1,a0
    80001d5a:	fd79                	bnez	a0,80001d38 <growproc+0x22>
      return -1;
    80001d5c:	557d                	li	a0,-1
    80001d5e:	bff9                	j	80001d3c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d60:	00b90633          	add	a2,s2,a1
    80001d64:	6928                	ld	a0,80(a0)
    80001d66:	fffff097          	auipc	ra,0xfffff
    80001d6a:	660080e7          	jalr	1632(ra) # 800013c6 <uvmdealloc>
    80001d6e:	85aa                	mv	a1,a0
    80001d70:	b7e1                	j	80001d38 <growproc+0x22>

0000000080001d72 <fork>:
{
    80001d72:	7139                	addi	sp,sp,-64
    80001d74:	fc06                	sd	ra,56(sp)
    80001d76:	f822                	sd	s0,48(sp)
    80001d78:	f426                	sd	s1,40(sp)
    80001d7a:	f04a                	sd	s2,32(sp)
    80001d7c:	ec4e                	sd	s3,24(sp)
    80001d7e:	e852                	sd	s4,16(sp)
    80001d80:	e456                	sd	s5,8(sp)
    80001d82:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	c26080e7          	jalr	-986(ra) # 800019aa <myproc>
    80001d8c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d8e:	00000097          	auipc	ra,0x0
    80001d92:	e22080e7          	jalr	-478(ra) # 80001bb0 <allocproc>
    80001d96:	10050c63          	beqz	a0,80001eae <fork+0x13c>
    80001d9a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d9c:	048ab603          	ld	a2,72(s5)
    80001da0:	692c                	ld	a1,80(a0)
    80001da2:	050ab503          	ld	a0,80(s5)
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	7c0080e7          	jalr	1984(ra) # 80001566 <uvmcopy>
    80001dae:	04054863          	bltz	a0,80001dfe <fork+0x8c>
  np->sz = p->sz;
    80001db2:	048ab783          	ld	a5,72(s5)
    80001db6:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001dba:	058ab683          	ld	a3,88(s5)
    80001dbe:	87b6                	mv	a5,a3
    80001dc0:	058a3703          	ld	a4,88(s4)
    80001dc4:	12068693          	addi	a3,a3,288
    80001dc8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dcc:	6788                	ld	a0,8(a5)
    80001dce:	6b8c                	ld	a1,16(a5)
    80001dd0:	6f90                	ld	a2,24(a5)
    80001dd2:	01073023          	sd	a6,0(a4)
    80001dd6:	e708                	sd	a0,8(a4)
    80001dd8:	eb0c                	sd	a1,16(a4)
    80001dda:	ef10                	sd	a2,24(a4)
    80001ddc:	02078793          	addi	a5,a5,32
    80001de0:	02070713          	addi	a4,a4,32
    80001de4:	fed792e3          	bne	a5,a3,80001dc8 <fork+0x56>
  np->trapframe->a0 = 0;
    80001de8:	058a3783          	ld	a5,88(s4)
    80001dec:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001df0:	0d0a8493          	addi	s1,s5,208
    80001df4:	0d0a0913          	addi	s2,s4,208
    80001df8:	150a8993          	addi	s3,s5,336
    80001dfc:	a00d                	j	80001e1e <fork+0xac>
    freeproc(np);
    80001dfe:	8552                	mv	a0,s4
    80001e00:	00000097          	auipc	ra,0x0
    80001e04:	d5c080e7          	jalr	-676(ra) # 80001b5c <freeproc>
    release(&np->lock);
    80001e08:	8552                	mv	a0,s4
    80001e0a:	fffff097          	auipc	ra,0xfffff
    80001e0e:	e7e080e7          	jalr	-386(ra) # 80000c88 <release>
    return -1;
    80001e12:	597d                	li	s2,-1
    80001e14:	a059                	j	80001e9a <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001e16:	04a1                	addi	s1,s1,8
    80001e18:	0921                	addi	s2,s2,8
    80001e1a:	01348b63          	beq	s1,s3,80001e30 <fork+0xbe>
    if(p->ofile[i])
    80001e1e:	6088                	ld	a0,0(s1)
    80001e20:	d97d                	beqz	a0,80001e16 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e22:	00003097          	auipc	ra,0x3
    80001e26:	bbe080e7          	jalr	-1090(ra) # 800049e0 <filedup>
    80001e2a:	00a93023          	sd	a0,0(s2)
    80001e2e:	b7e5                	j	80001e16 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e30:	150ab503          	ld	a0,336(s5)
    80001e34:	00002097          	auipc	ra,0x2
    80001e38:	d2c080e7          	jalr	-724(ra) # 80003b60 <idup>
    80001e3c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e40:	4641                	li	a2,16
    80001e42:	158a8593          	addi	a1,s5,344
    80001e46:	158a0513          	addi	a0,s4,344
    80001e4a:	fffff097          	auipc	ra,0xfffff
    80001e4e:	fd0080e7          	jalr	-48(ra) # 80000e1a <safestrcpy>
  pid = np->pid;
    80001e52:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001e56:	8552                	mv	a0,s4
    80001e58:	fffff097          	auipc	ra,0xfffff
    80001e5c:	e30080e7          	jalr	-464(ra) # 80000c88 <release>
  acquire(&wait_lock);
    80001e60:	00010497          	auipc	s1,0x10
    80001e64:	00848493          	addi	s1,s1,8 # 80011e68 <wait_lock>
    80001e68:	8526                	mv	a0,s1
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	d6a080e7          	jalr	-662(ra) # 80000bd4 <acquire>
  np->parent = p;
    80001e72:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001e76:	8526                	mv	a0,s1
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	e10080e7          	jalr	-496(ra) # 80000c88 <release>
  acquire(&np->lock);
    80001e80:	8552                	mv	a0,s4
    80001e82:	fffff097          	auipc	ra,0xfffff
    80001e86:	d52080e7          	jalr	-686(ra) # 80000bd4 <acquire>
  np->state = RUNNABLE;
    80001e8a:	478d                	li	a5,3
    80001e8c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e90:	8552                	mv	a0,s4
    80001e92:	fffff097          	auipc	ra,0xfffff
    80001e96:	df6080e7          	jalr	-522(ra) # 80000c88 <release>
}
    80001e9a:	854a                	mv	a0,s2
    80001e9c:	70e2                	ld	ra,56(sp)
    80001e9e:	7442                	ld	s0,48(sp)
    80001ea0:	74a2                	ld	s1,40(sp)
    80001ea2:	7902                	ld	s2,32(sp)
    80001ea4:	69e2                	ld	s3,24(sp)
    80001ea6:	6a42                	ld	s4,16(sp)
    80001ea8:	6aa2                	ld	s5,8(sp)
    80001eaa:	6121                	addi	sp,sp,64
    80001eac:	8082                	ret
    return -1;
    80001eae:	597d                	li	s2,-1
    80001eb0:	b7ed                	j	80001e9a <fork+0x128>

0000000080001eb2 <scheduler>:
{
    80001eb2:	715d                	addi	sp,sp,-80
    80001eb4:	e486                	sd	ra,72(sp)
    80001eb6:	e0a2                	sd	s0,64(sp)
    80001eb8:	fc26                	sd	s1,56(sp)
    80001eba:	f84a                	sd	s2,48(sp)
    80001ebc:	f44e                	sd	s3,40(sp)
    80001ebe:	f052                	sd	s4,32(sp)
    80001ec0:	ec56                	sd	s5,24(sp)
    80001ec2:	e85a                	sd	s6,16(sp)
    80001ec4:	e45e                	sd	s7,8(sp)
    80001ec6:	0880                	addi	s0,sp,80
    80001ec8:	8792                	mv	a5,tp
  int id = r_tp();
    80001eca:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ecc:	00779b13          	slli	s6,a5,0x7
    80001ed0:	00010717          	auipc	a4,0x10
    80001ed4:	f8070713          	addi	a4,a4,-128 # 80011e50 <pid_lock>
    80001ed8:	975a                	add	a4,a4,s6
    80001eda:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001ede:	00010717          	auipc	a4,0x10
    80001ee2:	faa70713          	addi	a4,a4,-86 # 80011e88 <cpus+0x8>
    80001ee6:	9b3a                	add	s6,s6,a4
      if(p->state == RUNNABLE) {
    80001ee8:	4a0d                	li	s4,3
          for(struct proc * pr=proc; pr < &proc[NPROC]; pr++){
    80001eea:	00016997          	auipc	s3,0x16
    80001eee:	79698993          	addi	s3,s3,1942 # 80018680 <tickslock>
        c->proc = p;
    80001ef2:	079e                	slli	a5,a5,0x7
    80001ef4:	00010a97          	auipc	s5,0x10
    80001ef8:	f5ca8a93          	addi	s5,s5,-164 # 80011e50 <pid_lock>
    80001efc:	9abe                	add	s5,s5,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001efe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f02:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f06:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f0a:	00010917          	auipc	s2,0x10
    80001f0e:	37690913          	addi	s2,s2,886 # 80012280 <proc>
        p->state = RUNNING;
    80001f12:	4b91                	li	s7,4
      acquire(&p->lock);
    80001f14:	854a                	mv	a0,s2
    80001f16:	fffff097          	auipc	ra,0xfffff
    80001f1a:	cbe080e7          	jalr	-834(ra) # 80000bd4 <acquire>
      if(p->state == RUNNABLE) {
    80001f1e:	01892783          	lw	a5,24(s2)
    80001f22:	01478c63          	beq	a5,s4,80001f3a <scheduler+0x88>
      release(&p->lock);
    80001f26:	854a                	mv	a0,s2
    80001f28:	fffff097          	auipc	ra,0xfffff
    80001f2c:	d60080e7          	jalr	-672(ra) # 80000c88 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f30:	19090913          	addi	s2,s2,400
    80001f34:	fd3975e3          	bgeu	s2,s3,80001efe <scheduler+0x4c>
    80001f38:	bff1                	j	80001f14 <scheduler+0x62>
          for(struct proc * pr=proc; pr < &proc[NPROC]; pr++){
    80001f3a:	00010497          	auipc	s1,0x10
    80001f3e:	34648493          	addi	s1,s1,838 # 80012280 <proc>
    80001f42:	a015                	j	80001f66 <scheduler+0xb4>
                release(&pr->lock);
    80001f44:	8526                	mv	a0,s1
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	d42080e7          	jalr	-702(ra) # 80000c88 <release>
    80001f4e:	a801                	j	80001f5e <scheduler+0xac>
            else if((pr->state == RUNNABLE) && (pr->execTime.creationTime < toRun->execTime.creationTime)){
    80001f50:	04f76763          	bltu	a4,a5,80001f9e <scheduler+0xec>
              release(&pr->lock);
    80001f54:	8526                	mv	a0,s1
    80001f56:	fffff097          	auipc	ra,0xfffff
    80001f5a:	d32080e7          	jalr	-718(ra) # 80000c88 <release>
          for(struct proc * pr=proc; pr < &proc[NPROC]; pr++){
    80001f5e:	19048493          	addi	s1,s1,400
    80001f62:	05348763          	beq	s1,s3,80001fb0 <scheduler+0xfe>
            if(pr==toRun)
    80001f66:	04990363          	beq	s2,s1,80001fac <scheduler+0xfa>
            acquire(&pr->lock);
    80001f6a:	8526                	mv	a0,s1
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	c68080e7          	jalr	-920(ra) # 80000bd4 <acquire>
            if((pr->state == RUNNABLE) && (pr->execTime.creationTime == toRun->execTime.creationTime)){
    80001f74:	4c9c                	lw	a5,24(s1)
    80001f76:	fd479fe3          	bne	a5,s4,80001f54 <scheduler+0xa2>
    80001f7a:	1684b703          	ld	a4,360(s1)
    80001f7e:	16893783          	ld	a5,360(s2)
    80001f82:	fcf717e3          	bne	a4,a5,80001f50 <scheduler+0x9e>
              if (pr->pid < toRun->pid){
    80001f86:	5898                	lw	a4,48(s1)
    80001f88:	03092783          	lw	a5,48(s2)
    80001f8c:	faf75ce3          	bge	a4,a5,80001f44 <scheduler+0x92>
                release(&toRun->lock);
    80001f90:	854a                	mv	a0,s2
    80001f92:	fffff097          	auipc	ra,0xfffff
    80001f96:	cf6080e7          	jalr	-778(ra) # 80000c88 <release>
                toRun = pr;
    80001f9a:	8926                	mv	s2,s1
    80001f9c:	b7c9                	j	80001f5e <scheduler+0xac>
                release(&toRun->lock);
    80001f9e:	854a                	mv	a0,s2
    80001fa0:	fffff097          	auipc	ra,0xfffff
    80001fa4:	ce8080e7          	jalr	-792(ra) # 80000c88 <release>
                toRun = pr;
    80001fa8:	8926                	mv	s2,s1
    80001faa:	bf55                	j	80001f5e <scheduler+0xac>
    80001fac:	8926                	mv	s2,s1
    80001fae:	bf45                	j	80001f5e <scheduler+0xac>
        if (!p->execTime.runningTime)
    80001fb0:	18093783          	ld	a5,384(s2)
    80001fb4:	cf99                	beqz	a5,80001fd2 <scheduler+0x120>
        p->state = RUNNING;
    80001fb6:	01792c23          	sw	s7,24(s2)
        c->proc = p;
    80001fba:	032ab823          	sd	s2,48(s5)
        swtch(&c->context, &p->context);
    80001fbe:	06090593          	addi	a1,s2,96
    80001fc2:	855a                	mv	a0,s6
    80001fc4:	00000097          	auipc	ra,0x0
    80001fc8:	6c2080e7          	jalr	1730(ra) # 80002686 <swtch>
        c->proc = 0;
    80001fcc:	020ab823          	sd	zero,48(s5)
    80001fd0:	bf99                	j	80001f26 <scheduler+0x74>
          p->execTime.runningTime = sys_uptime();
    80001fd2:	00001097          	auipc	ra,0x1
    80001fd6:	296080e7          	jalr	662(ra) # 80003268 <sys_uptime>
    80001fda:	18a93023          	sd	a0,384(s2)
    80001fde:	bfe1                	j	80001fb6 <scheduler+0x104>

0000000080001fe0 <sched>:
{
    80001fe0:	7179                	addi	sp,sp,-48
    80001fe2:	f406                	sd	ra,40(sp)
    80001fe4:	f022                	sd	s0,32(sp)
    80001fe6:	ec26                	sd	s1,24(sp)
    80001fe8:	e84a                	sd	s2,16(sp)
    80001fea:	e44e                	sd	s3,8(sp)
    80001fec:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001fee:	00000097          	auipc	ra,0x0
    80001ff2:	9bc080e7          	jalr	-1604(ra) # 800019aa <myproc>
    80001ff6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001ff8:	fffff097          	auipc	ra,0xfffff
    80001ffc:	b62080e7          	jalr	-1182(ra) # 80000b5a <holding>
    80002000:	c93d                	beqz	a0,80002076 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002002:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002004:	2781                	sext.w	a5,a5
    80002006:	079e                	slli	a5,a5,0x7
    80002008:	00010717          	auipc	a4,0x10
    8000200c:	e4870713          	addi	a4,a4,-440 # 80011e50 <pid_lock>
    80002010:	97ba                	add	a5,a5,a4
    80002012:	0a87a703          	lw	a4,168(a5)
    80002016:	4785                	li	a5,1
    80002018:	06f71763          	bne	a4,a5,80002086 <sched+0xa6>
  if(p->state == RUNNING)
    8000201c:	4c98                	lw	a4,24(s1)
    8000201e:	4791                	li	a5,4
    80002020:	06f70b63          	beq	a4,a5,80002096 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002024:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002028:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000202a:	efb5                	bnez	a5,800020a6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000202c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000202e:	00010917          	auipc	s2,0x10
    80002032:	e2290913          	addi	s2,s2,-478 # 80011e50 <pid_lock>
    80002036:	2781                	sext.w	a5,a5
    80002038:	079e                	slli	a5,a5,0x7
    8000203a:	97ca                	add	a5,a5,s2
    8000203c:	0ac7a983          	lw	s3,172(a5)
    80002040:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002042:	2781                	sext.w	a5,a5
    80002044:	079e                	slli	a5,a5,0x7
    80002046:	00010597          	auipc	a1,0x10
    8000204a:	e4258593          	addi	a1,a1,-446 # 80011e88 <cpus+0x8>
    8000204e:	95be                	add	a1,a1,a5
    80002050:	06048513          	addi	a0,s1,96
    80002054:	00000097          	auipc	ra,0x0
    80002058:	632080e7          	jalr	1586(ra) # 80002686 <swtch>
    8000205c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000205e:	2781                	sext.w	a5,a5
    80002060:	079e                	slli	a5,a5,0x7
    80002062:	993e                	add	s2,s2,a5
    80002064:	0b392623          	sw	s3,172(s2)
}
    80002068:	70a2                	ld	ra,40(sp)
    8000206a:	7402                	ld	s0,32(sp)
    8000206c:	64e2                	ld	s1,24(sp)
    8000206e:	6942                	ld	s2,16(sp)
    80002070:	69a2                	ld	s3,8(sp)
    80002072:	6145                	addi	sp,sp,48
    80002074:	8082                	ret
    panic("sched p->lock");
    80002076:	00007517          	auipc	a0,0x7
    8000207a:	1a250513          	addi	a0,a0,418 # 80009218 <digits+0x1d8>
    8000207e:	ffffe097          	auipc	ra,0xffffe
    80002082:	4c0080e7          	jalr	1216(ra) # 8000053e <panic>
    panic("sched locks");
    80002086:	00007517          	auipc	a0,0x7
    8000208a:	1a250513          	addi	a0,a0,418 # 80009228 <digits+0x1e8>
    8000208e:	ffffe097          	auipc	ra,0xffffe
    80002092:	4b0080e7          	jalr	1200(ra) # 8000053e <panic>
    panic("sched running");
    80002096:	00007517          	auipc	a0,0x7
    8000209a:	1a250513          	addi	a0,a0,418 # 80009238 <digits+0x1f8>
    8000209e:	ffffe097          	auipc	ra,0xffffe
    800020a2:	4a0080e7          	jalr	1184(ra) # 8000053e <panic>
    panic("sched interruptible");
    800020a6:	00007517          	auipc	a0,0x7
    800020aa:	1a250513          	addi	a0,a0,418 # 80009248 <digits+0x208>
    800020ae:	ffffe097          	auipc	ra,0xffffe
    800020b2:	490080e7          	jalr	1168(ra) # 8000053e <panic>

00000000800020b6 <yield>:
{
    800020b6:	1101                	addi	sp,sp,-32
    800020b8:	ec06                	sd	ra,24(sp)
    800020ba:	e822                	sd	s0,16(sp)
    800020bc:	e426                	sd	s1,8(sp)
    800020be:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020c0:	00000097          	auipc	ra,0x0
    800020c4:	8ea080e7          	jalr	-1814(ra) # 800019aa <myproc>
    800020c8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020ca:	fffff097          	auipc	ra,0xfffff
    800020ce:	b0a080e7          	jalr	-1270(ra) # 80000bd4 <acquire>
  p->state = RUNNABLE;
    800020d2:	478d                	li	a5,3
    800020d4:	cc9c                	sw	a5,24(s1)
  sched();
    800020d6:	00000097          	auipc	ra,0x0
    800020da:	f0a080e7          	jalr	-246(ra) # 80001fe0 <sched>
  release(&p->lock);
    800020de:	8526                	mv	a0,s1
    800020e0:	fffff097          	auipc	ra,0xfffff
    800020e4:	ba8080e7          	jalr	-1112(ra) # 80000c88 <release>
}
    800020e8:	60e2                	ld	ra,24(sp)
    800020ea:	6442                	ld	s0,16(sp)
    800020ec:	64a2                	ld	s1,8(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret

00000000800020f2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800020f2:	7179                	addi	sp,sp,-48
    800020f4:	f406                	sd	ra,40(sp)
    800020f6:	f022                	sd	s0,32(sp)
    800020f8:	ec26                	sd	s1,24(sp)
    800020fa:	e84a                	sd	s2,16(sp)
    800020fc:	e44e                	sd	s3,8(sp)
    800020fe:	1800                	addi	s0,sp,48
    80002100:	89aa                	mv	s3,a0
    80002102:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002104:	00000097          	auipc	ra,0x0
    80002108:	8a6080e7          	jalr	-1882(ra) # 800019aa <myproc>
    8000210c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	ac6080e7          	jalr	-1338(ra) # 80000bd4 <acquire>
  release(lk);
    80002116:	854a                	mv	a0,s2
    80002118:	fffff097          	auipc	ra,0xfffff
    8000211c:	b70080e7          	jalr	-1168(ra) # 80000c88 <release>

  // Go to sleep.
  p->chan = chan;
    80002120:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002124:	4789                	li	a5,2
    80002126:	cc9c                	sw	a5,24(s1)

  sched();
    80002128:	00000097          	auipc	ra,0x0
    8000212c:	eb8080e7          	jalr	-328(ra) # 80001fe0 <sched>

  // Tidy up.
  p->chan = 0;
    80002130:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002134:	8526                	mv	a0,s1
    80002136:	fffff097          	auipc	ra,0xfffff
    8000213a:	b52080e7          	jalr	-1198(ra) # 80000c88 <release>
  acquire(lk);
    8000213e:	854a                	mv	a0,s2
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	a94080e7          	jalr	-1388(ra) # 80000bd4 <acquire>
}
    80002148:	70a2                	ld	ra,40(sp)
    8000214a:	7402                	ld	s0,32(sp)
    8000214c:	64e2                	ld	s1,24(sp)
    8000214e:	6942                	ld	s2,16(sp)
    80002150:	69a2                	ld	s3,8(sp)
    80002152:	6145                	addi	sp,sp,48
    80002154:	8082                	ret

0000000080002156 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002156:	7139                	addi	sp,sp,-64
    80002158:	fc06                	sd	ra,56(sp)
    8000215a:	f822                	sd	s0,48(sp)
    8000215c:	f426                	sd	s1,40(sp)
    8000215e:	f04a                	sd	s2,32(sp)
    80002160:	ec4e                	sd	s3,24(sp)
    80002162:	e852                	sd	s4,16(sp)
    80002164:	e456                	sd	s5,8(sp)
    80002166:	0080                	addi	s0,sp,64
    80002168:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000216a:	00010497          	auipc	s1,0x10
    8000216e:	11648493          	addi	s1,s1,278 # 80012280 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002172:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002174:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002176:	00016917          	auipc	s2,0x16
    8000217a:	50a90913          	addi	s2,s2,1290 # 80018680 <tickslock>
    8000217e:	a811                	j	80002192 <wakeup+0x3c>
      }
      release(&p->lock);
    80002180:	8526                	mv	a0,s1
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	b06080e7          	jalr	-1274(ra) # 80000c88 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000218a:	19048493          	addi	s1,s1,400
    8000218e:	03248663          	beq	s1,s2,800021ba <wakeup+0x64>
    if(p != myproc()){
    80002192:	00000097          	auipc	ra,0x0
    80002196:	818080e7          	jalr	-2024(ra) # 800019aa <myproc>
    8000219a:	fea488e3          	beq	s1,a0,8000218a <wakeup+0x34>
      acquire(&p->lock);
    8000219e:	8526                	mv	a0,s1
    800021a0:	fffff097          	auipc	ra,0xfffff
    800021a4:	a34080e7          	jalr	-1484(ra) # 80000bd4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800021a8:	4c9c                	lw	a5,24(s1)
    800021aa:	fd379be3          	bne	a5,s3,80002180 <wakeup+0x2a>
    800021ae:	709c                	ld	a5,32(s1)
    800021b0:	fd4798e3          	bne	a5,s4,80002180 <wakeup+0x2a>
        p->state = RUNNABLE;
    800021b4:	0154ac23          	sw	s5,24(s1)
    800021b8:	b7e1                	j	80002180 <wakeup+0x2a>
    }
  }
}
    800021ba:	70e2                	ld	ra,56(sp)
    800021bc:	7442                	ld	s0,48(sp)
    800021be:	74a2                	ld	s1,40(sp)
    800021c0:	7902                	ld	s2,32(sp)
    800021c2:	69e2                	ld	s3,24(sp)
    800021c4:	6a42                	ld	s4,16(sp)
    800021c6:	6aa2                	ld	s5,8(sp)
    800021c8:	6121                	addi	sp,sp,64
    800021ca:	8082                	ret

00000000800021cc <reparent>:
{
    800021cc:	7179                	addi	sp,sp,-48
    800021ce:	f406                	sd	ra,40(sp)
    800021d0:	f022                	sd	s0,32(sp)
    800021d2:	ec26                	sd	s1,24(sp)
    800021d4:	e84a                	sd	s2,16(sp)
    800021d6:	e44e                	sd	s3,8(sp)
    800021d8:	e052                	sd	s4,0(sp)
    800021da:	1800                	addi	s0,sp,48
    800021dc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021de:	00010497          	auipc	s1,0x10
    800021e2:	0a248493          	addi	s1,s1,162 # 80012280 <proc>
      pp->parent = initproc;
    800021e6:	00008a17          	auipc	s4,0x8
    800021ea:	9f2a0a13          	addi	s4,s4,-1550 # 80009bd8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021ee:	00016997          	auipc	s3,0x16
    800021f2:	49298993          	addi	s3,s3,1170 # 80018680 <tickslock>
    800021f6:	a029                	j	80002200 <reparent+0x34>
    800021f8:	19048493          	addi	s1,s1,400
    800021fc:	01348d63          	beq	s1,s3,80002216 <reparent+0x4a>
    if(pp->parent == p){
    80002200:	7c9c                	ld	a5,56(s1)
    80002202:	ff279be3          	bne	a5,s2,800021f8 <reparent+0x2c>
      pp->parent = initproc;
    80002206:	000a3503          	ld	a0,0(s4)
    8000220a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000220c:	00000097          	auipc	ra,0x0
    80002210:	f4a080e7          	jalr	-182(ra) # 80002156 <wakeup>
    80002214:	b7d5                	j	800021f8 <reparent+0x2c>
}
    80002216:	70a2                	ld	ra,40(sp)
    80002218:	7402                	ld	s0,32(sp)
    8000221a:	64e2                	ld	s1,24(sp)
    8000221c:	6942                	ld	s2,16(sp)
    8000221e:	69a2                	ld	s3,8(sp)
    80002220:	6a02                	ld	s4,0(sp)
    80002222:	6145                	addi	sp,sp,48
    80002224:	8082                	ret

0000000080002226 <exit>:
{
    80002226:	7179                	addi	sp,sp,-48
    80002228:	f406                	sd	ra,40(sp)
    8000222a:	f022                	sd	s0,32(sp)
    8000222c:	ec26                	sd	s1,24(sp)
    8000222e:	e84a                	sd	s2,16(sp)
    80002230:	e44e                	sd	s3,8(sp)
    80002232:	e052                	sd	s4,0(sp)
    80002234:	1800                	addi	s0,sp,48
    80002236:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	772080e7          	jalr	1906(ra) # 800019aa <myproc>
    80002240:	892a                	mv	s2,a0
  p->execTime.endTime = sys_uptime();
    80002242:	00001097          	auipc	ra,0x1
    80002246:	026080e7          	jalr	38(ra) # 80003268 <sys_uptime>
    8000224a:	16a93823          	sd	a0,368(s2)
  p->execTime.totalTime = p->execTime.endTime - p->execTime.creationTime;
    8000224e:	16893783          	ld	a5,360(s2)
    80002252:	40f507b3          	sub	a5,a0,a5
    80002256:	16f93c23          	sd	a5,376(s2)
  if(p == initproc)
    8000225a:	00008797          	auipc	a5,0x8
    8000225e:	97e7b783          	ld	a5,-1666(a5) # 80009bd8 <initproc>
    80002262:	0d090493          	addi	s1,s2,208
    80002266:	15090993          	addi	s3,s2,336
    8000226a:	03279363          	bne	a5,s2,80002290 <exit+0x6a>
    panic("init exiting");
    8000226e:	00007517          	auipc	a0,0x7
    80002272:	ff250513          	addi	a0,a0,-14 # 80009260 <digits+0x220>
    80002276:	ffffe097          	auipc	ra,0xffffe
    8000227a:	2c8080e7          	jalr	712(ra) # 8000053e <panic>
      fileclose(f);
    8000227e:	00002097          	auipc	ra,0x2
    80002282:	7b4080e7          	jalr	1972(ra) # 80004a32 <fileclose>
      p->ofile[fd] = 0;
    80002286:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000228a:	04a1                	addi	s1,s1,8
    8000228c:	01348563          	beq	s1,s3,80002296 <exit+0x70>
    if(p->ofile[fd]){
    80002290:	6088                	ld	a0,0(s1)
    80002292:	f575                	bnez	a0,8000227e <exit+0x58>
    80002294:	bfdd                	j	8000228a <exit+0x64>
  begin_op();
    80002296:	00002097          	auipc	ra,0x2
    8000229a:	2d4080e7          	jalr	724(ra) # 8000456a <begin_op>
  iput(p->cwd);
    8000229e:	15093503          	ld	a0,336(s2)
    800022a2:	00002097          	auipc	ra,0x2
    800022a6:	ab6080e7          	jalr	-1354(ra) # 80003d58 <iput>
  end_op();
    800022aa:	00002097          	auipc	ra,0x2
    800022ae:	33e080e7          	jalr	830(ra) # 800045e8 <end_op>
  p->cwd = 0;
    800022b2:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    800022b6:	00010497          	auipc	s1,0x10
    800022ba:	bb248493          	addi	s1,s1,-1102 # 80011e68 <wait_lock>
    800022be:	8526                	mv	a0,s1
    800022c0:	fffff097          	auipc	ra,0xfffff
    800022c4:	914080e7          	jalr	-1772(ra) # 80000bd4 <acquire>
  reparent(p);
    800022c8:	854a                	mv	a0,s2
    800022ca:	00000097          	auipc	ra,0x0
    800022ce:	f02080e7          	jalr	-254(ra) # 800021cc <reparent>
  wakeup(p->parent);
    800022d2:	03893503          	ld	a0,56(s2)
    800022d6:	00000097          	auipc	ra,0x0
    800022da:	e80080e7          	jalr	-384(ra) # 80002156 <wakeup>
  acquire(&p->lock);
    800022de:	854a                	mv	a0,s2
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	8f4080e7          	jalr	-1804(ra) # 80000bd4 <acquire>
  p->xstate = status;
    800022e8:	03492623          	sw	s4,44(s2)
  p->state = ZOMBIE;
    800022ec:	4795                	li	a5,5
    800022ee:	00f92c23          	sw	a5,24(s2)
  p->execTime.endTime=sys_uptime();
    800022f2:	00001097          	auipc	ra,0x1
    800022f6:	f76080e7          	jalr	-138(ra) # 80003268 <sys_uptime>
    800022fa:	16a93823          	sd	a0,368(s2)
  release(&wait_lock);
    800022fe:	8526                	mv	a0,s1
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	988080e7          	jalr	-1656(ra) # 80000c88 <release>
  sched();
    80002308:	00000097          	auipc	ra,0x0
    8000230c:	cd8080e7          	jalr	-808(ra) # 80001fe0 <sched>
  panic("zombie exit");
    80002310:	00007517          	auipc	a0,0x7
    80002314:	f6050513          	addi	a0,a0,-160 # 80009270 <digits+0x230>
    80002318:	ffffe097          	auipc	ra,0xffffe
    8000231c:	226080e7          	jalr	550(ra) # 8000053e <panic>

0000000080002320 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002320:	7179                	addi	sp,sp,-48
    80002322:	f406                	sd	ra,40(sp)
    80002324:	f022                	sd	s0,32(sp)
    80002326:	ec26                	sd	s1,24(sp)
    80002328:	e84a                	sd	s2,16(sp)
    8000232a:	e44e                	sd	s3,8(sp)
    8000232c:	1800                	addi	s0,sp,48
    8000232e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002330:	00010497          	auipc	s1,0x10
    80002334:	f5048493          	addi	s1,s1,-176 # 80012280 <proc>
    80002338:	00016997          	auipc	s3,0x16
    8000233c:	34898993          	addi	s3,s3,840 # 80018680 <tickslock>
    acquire(&p->lock);
    80002340:	8526                	mv	a0,s1
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	892080e7          	jalr	-1902(ra) # 80000bd4 <acquire>
    if(p->pid == pid){
    8000234a:	589c                	lw	a5,48(s1)
    8000234c:	01278d63          	beq	a5,s2,80002366 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002350:	8526                	mv	a0,s1
    80002352:	fffff097          	auipc	ra,0xfffff
    80002356:	936080e7          	jalr	-1738(ra) # 80000c88 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000235a:	19048493          	addi	s1,s1,400
    8000235e:	ff3491e3          	bne	s1,s3,80002340 <kill+0x20>
  }
  return -1;
    80002362:	557d                	li	a0,-1
    80002364:	a829                	j	8000237e <kill+0x5e>
      p->killed = 1;
    80002366:	4785                	li	a5,1
    80002368:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000236a:	4c98                	lw	a4,24(s1)
    8000236c:	4789                	li	a5,2
    8000236e:	00f70f63          	beq	a4,a5,8000238c <kill+0x6c>
      release(&p->lock);
    80002372:	8526                	mv	a0,s1
    80002374:	fffff097          	auipc	ra,0xfffff
    80002378:	914080e7          	jalr	-1772(ra) # 80000c88 <release>
      return 0;
    8000237c:	4501                	li	a0,0
}
    8000237e:	70a2                	ld	ra,40(sp)
    80002380:	7402                	ld	s0,32(sp)
    80002382:	64e2                	ld	s1,24(sp)
    80002384:	6942                	ld	s2,16(sp)
    80002386:	69a2                	ld	s3,8(sp)
    80002388:	6145                	addi	sp,sp,48
    8000238a:	8082                	ret
        p->state = RUNNABLE;
    8000238c:	478d                	li	a5,3
    8000238e:	cc9c                	sw	a5,24(s1)
    80002390:	b7cd                	j	80002372 <kill+0x52>

0000000080002392 <setkilled>:

void
setkilled(struct proc *p)
{
    80002392:	1101                	addi	sp,sp,-32
    80002394:	ec06                	sd	ra,24(sp)
    80002396:	e822                	sd	s0,16(sp)
    80002398:	e426                	sd	s1,8(sp)
    8000239a:	1000                	addi	s0,sp,32
    8000239c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000239e:	fffff097          	auipc	ra,0xfffff
    800023a2:	836080e7          	jalr	-1994(ra) # 80000bd4 <acquire>
  p->killed = 1;
    800023a6:	4785                	li	a5,1
    800023a8:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800023aa:	8526                	mv	a0,s1
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	8dc080e7          	jalr	-1828(ra) # 80000c88 <release>
}
    800023b4:	60e2                	ld	ra,24(sp)
    800023b6:	6442                	ld	s0,16(sp)
    800023b8:	64a2                	ld	s1,8(sp)
    800023ba:	6105                	addi	sp,sp,32
    800023bc:	8082                	ret

00000000800023be <killed>:

int
killed(struct proc *p)
{
    800023be:	1101                	addi	sp,sp,-32
    800023c0:	ec06                	sd	ra,24(sp)
    800023c2:	e822                	sd	s0,16(sp)
    800023c4:	e426                	sd	s1,8(sp)
    800023c6:	e04a                	sd	s2,0(sp)
    800023c8:	1000                	addi	s0,sp,32
    800023ca:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800023cc:	fffff097          	auipc	ra,0xfffff
    800023d0:	808080e7          	jalr	-2040(ra) # 80000bd4 <acquire>
  k = p->killed;
    800023d4:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800023d8:	8526                	mv	a0,s1
    800023da:	fffff097          	auipc	ra,0xfffff
    800023de:	8ae080e7          	jalr	-1874(ra) # 80000c88 <release>
  return k;
}
    800023e2:	854a                	mv	a0,s2
    800023e4:	60e2                	ld	ra,24(sp)
    800023e6:	6442                	ld	s0,16(sp)
    800023e8:	64a2                	ld	s1,8(sp)
    800023ea:	6902                	ld	s2,0(sp)
    800023ec:	6105                	addi	sp,sp,32
    800023ee:	8082                	ret

00000000800023f0 <wait>:
{
    800023f0:	715d                	addi	sp,sp,-80
    800023f2:	e486                	sd	ra,72(sp)
    800023f4:	e0a2                	sd	s0,64(sp)
    800023f6:	fc26                	sd	s1,56(sp)
    800023f8:	f84a                	sd	s2,48(sp)
    800023fa:	f44e                	sd	s3,40(sp)
    800023fc:	f052                	sd	s4,32(sp)
    800023fe:	ec56                	sd	s5,24(sp)
    80002400:	e85a                	sd	s6,16(sp)
    80002402:	e45e                	sd	s7,8(sp)
    80002404:	e062                	sd	s8,0(sp)
    80002406:	0880                	addi	s0,sp,80
    80002408:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000240a:	fffff097          	auipc	ra,0xfffff
    8000240e:	5a0080e7          	jalr	1440(ra) # 800019aa <myproc>
    80002412:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002414:	00010517          	auipc	a0,0x10
    80002418:	a5450513          	addi	a0,a0,-1452 # 80011e68 <wait_lock>
    8000241c:	ffffe097          	auipc	ra,0xffffe
    80002420:	7b8080e7          	jalr	1976(ra) # 80000bd4 <acquire>
    havekids = 0;
    80002424:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002426:	4a15                	li	s4,5
        havekids = 1;
    80002428:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000242a:	00016997          	auipc	s3,0x16
    8000242e:	25698993          	addi	s3,s3,598 # 80018680 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002432:	00010c17          	auipc	s8,0x10
    80002436:	a36c0c13          	addi	s8,s8,-1482 # 80011e68 <wait_lock>
    havekids = 0;
    8000243a:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000243c:	00010497          	auipc	s1,0x10
    80002440:	e4448493          	addi	s1,s1,-444 # 80012280 <proc>
    80002444:	a8ad                	j	800024be <wait+0xce>
          pid = pp->pid;
    80002446:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000244a:	000b0e63          	beqz	s6,80002466 <wait+0x76>
    8000244e:	4691                	li	a3,4
    80002450:	02c48613          	addi	a2,s1,44
    80002454:	85da                	mv	a1,s6
    80002456:	05093503          	ld	a0,80(s2)
    8000245a:	fffff097          	auipc	ra,0xfffff
    8000245e:	210080e7          	jalr	528(ra) # 8000166a <copyout>
    80002462:	02054563          	bltz	a0,8000248c <wait+0x9c>
          freeproc(pp);
    80002466:	8526                	mv	a0,s1
    80002468:	fffff097          	auipc	ra,0xfffff
    8000246c:	6f4080e7          	jalr	1780(ra) # 80001b5c <freeproc>
          release(&pp->lock);
    80002470:	8526                	mv	a0,s1
    80002472:	fffff097          	auipc	ra,0xfffff
    80002476:	816080e7          	jalr	-2026(ra) # 80000c88 <release>
          release(&wait_lock);
    8000247a:	00010517          	auipc	a0,0x10
    8000247e:	9ee50513          	addi	a0,a0,-1554 # 80011e68 <wait_lock>
    80002482:	fffff097          	auipc	ra,0xfffff
    80002486:	806080e7          	jalr	-2042(ra) # 80000c88 <release>
          return pid;
    8000248a:	a8a5                	j	80002502 <wait+0x112>
            pp->execTime.endTime=sys_uptime();
    8000248c:	00001097          	auipc	ra,0x1
    80002490:	ddc080e7          	jalr	-548(ra) # 80003268 <sys_uptime>
    80002494:	16a4b823          	sd	a0,368(s1)
            release(&pp->lock);
    80002498:	8526                	mv	a0,s1
    8000249a:	ffffe097          	auipc	ra,0xffffe
    8000249e:	7ee080e7          	jalr	2030(ra) # 80000c88 <release>
            release(&wait_lock);
    800024a2:	00010517          	auipc	a0,0x10
    800024a6:	9c650513          	addi	a0,a0,-1594 # 80011e68 <wait_lock>
    800024aa:	ffffe097          	auipc	ra,0xffffe
    800024ae:	7de080e7          	jalr	2014(ra) # 80000c88 <release>
            return -1;
    800024b2:	59fd                	li	s3,-1
    800024b4:	a0b9                	j	80002502 <wait+0x112>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024b6:	19048493          	addi	s1,s1,400
    800024ba:	03348463          	beq	s1,s3,800024e2 <wait+0xf2>
      if(pp->parent == p){
    800024be:	7c9c                	ld	a5,56(s1)
    800024c0:	ff279be3          	bne	a5,s2,800024b6 <wait+0xc6>
        acquire(&pp->lock);
    800024c4:	8526                	mv	a0,s1
    800024c6:	ffffe097          	auipc	ra,0xffffe
    800024ca:	70e080e7          	jalr	1806(ra) # 80000bd4 <acquire>
        if(pp->state == ZOMBIE){
    800024ce:	4c9c                	lw	a5,24(s1)
    800024d0:	f7478be3          	beq	a5,s4,80002446 <wait+0x56>
        release(&pp->lock);
    800024d4:	8526                	mv	a0,s1
    800024d6:	ffffe097          	auipc	ra,0xffffe
    800024da:	7b2080e7          	jalr	1970(ra) # 80000c88 <release>
        havekids = 1;
    800024de:	8756                	mv	a4,s5
    800024e0:	bfd9                	j	800024b6 <wait+0xc6>
    if(!havekids || killed(p)){
    800024e2:	c719                	beqz	a4,800024f0 <wait+0x100>
    800024e4:	854a                	mv	a0,s2
    800024e6:	00000097          	auipc	ra,0x0
    800024ea:	ed8080e7          	jalr	-296(ra) # 800023be <killed>
    800024ee:	c51d                	beqz	a0,8000251c <wait+0x12c>
      release(&wait_lock);
    800024f0:	00010517          	auipc	a0,0x10
    800024f4:	97850513          	addi	a0,a0,-1672 # 80011e68 <wait_lock>
    800024f8:	ffffe097          	auipc	ra,0xffffe
    800024fc:	790080e7          	jalr	1936(ra) # 80000c88 <release>
      return -1;
    80002500:	59fd                	li	s3,-1
}
    80002502:	854e                	mv	a0,s3
    80002504:	60a6                	ld	ra,72(sp)
    80002506:	6406                	ld	s0,64(sp)
    80002508:	74e2                	ld	s1,56(sp)
    8000250a:	7942                	ld	s2,48(sp)
    8000250c:	79a2                	ld	s3,40(sp)
    8000250e:	7a02                	ld	s4,32(sp)
    80002510:	6ae2                	ld	s5,24(sp)
    80002512:	6b42                	ld	s6,16(sp)
    80002514:	6ba2                	ld	s7,8(sp)
    80002516:	6c02                	ld	s8,0(sp)
    80002518:	6161                	addi	sp,sp,80
    8000251a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000251c:	85e2                	mv	a1,s8
    8000251e:	854a                	mv	a0,s2
    80002520:	00000097          	auipc	ra,0x0
    80002524:	bd2080e7          	jalr	-1070(ra) # 800020f2 <sleep>
    havekids = 0;
    80002528:	bf09                	j	8000243a <wait+0x4a>

000000008000252a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000252a:	7179                	addi	sp,sp,-48
    8000252c:	f406                	sd	ra,40(sp)
    8000252e:	f022                	sd	s0,32(sp)
    80002530:	ec26                	sd	s1,24(sp)
    80002532:	e84a                	sd	s2,16(sp)
    80002534:	e44e                	sd	s3,8(sp)
    80002536:	e052                	sd	s4,0(sp)
    80002538:	1800                	addi	s0,sp,48
    8000253a:	84aa                	mv	s1,a0
    8000253c:	892e                	mv	s2,a1
    8000253e:	89b2                	mv	s3,a2
    80002540:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002542:	fffff097          	auipc	ra,0xfffff
    80002546:	468080e7          	jalr	1128(ra) # 800019aa <myproc>
  if(user_dst){
    8000254a:	c08d                	beqz	s1,8000256c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000254c:	86d2                	mv	a3,s4
    8000254e:	864e                	mv	a2,s3
    80002550:	85ca                	mv	a1,s2
    80002552:	6928                	ld	a0,80(a0)
    80002554:	fffff097          	auipc	ra,0xfffff
    80002558:	116080e7          	jalr	278(ra) # 8000166a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000255c:	70a2                	ld	ra,40(sp)
    8000255e:	7402                	ld	s0,32(sp)
    80002560:	64e2                	ld	s1,24(sp)
    80002562:	6942                	ld	s2,16(sp)
    80002564:	69a2                	ld	s3,8(sp)
    80002566:	6a02                	ld	s4,0(sp)
    80002568:	6145                	addi	sp,sp,48
    8000256a:	8082                	ret
    memmove((char *)dst, src, len);
    8000256c:	000a061b          	sext.w	a2,s4
    80002570:	85ce                	mv	a1,s3
    80002572:	854a                	mv	a0,s2
    80002574:	ffffe097          	auipc	ra,0xffffe
    80002578:	7b8080e7          	jalr	1976(ra) # 80000d2c <memmove>
    return 0;
    8000257c:	8526                	mv	a0,s1
    8000257e:	bff9                	j	8000255c <either_copyout+0x32>

0000000080002580 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002580:	7179                	addi	sp,sp,-48
    80002582:	f406                	sd	ra,40(sp)
    80002584:	f022                	sd	s0,32(sp)
    80002586:	ec26                	sd	s1,24(sp)
    80002588:	e84a                	sd	s2,16(sp)
    8000258a:	e44e                	sd	s3,8(sp)
    8000258c:	e052                	sd	s4,0(sp)
    8000258e:	1800                	addi	s0,sp,48
    80002590:	892a                	mv	s2,a0
    80002592:	84ae                	mv	s1,a1
    80002594:	89b2                	mv	s3,a2
    80002596:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002598:	fffff097          	auipc	ra,0xfffff
    8000259c:	412080e7          	jalr	1042(ra) # 800019aa <myproc>
  if(user_src){
    800025a0:	c08d                	beqz	s1,800025c2 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800025a2:	86d2                	mv	a3,s4
    800025a4:	864e                	mv	a2,s3
    800025a6:	85ca                	mv	a1,s2
    800025a8:	6928                	ld	a0,80(a0)
    800025aa:	fffff097          	auipc	ra,0xfffff
    800025ae:	14c080e7          	jalr	332(ra) # 800016f6 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800025b2:	70a2                	ld	ra,40(sp)
    800025b4:	7402                	ld	s0,32(sp)
    800025b6:	64e2                	ld	s1,24(sp)
    800025b8:	6942                	ld	s2,16(sp)
    800025ba:	69a2                	ld	s3,8(sp)
    800025bc:	6a02                	ld	s4,0(sp)
    800025be:	6145                	addi	sp,sp,48
    800025c0:	8082                	ret
    memmove(dst, (char*)src, len);
    800025c2:	000a061b          	sext.w	a2,s4
    800025c6:	85ce                	mv	a1,s3
    800025c8:	854a                	mv	a0,s2
    800025ca:	ffffe097          	auipc	ra,0xffffe
    800025ce:	762080e7          	jalr	1890(ra) # 80000d2c <memmove>
    return 0;
    800025d2:	8526                	mv	a0,s1
    800025d4:	bff9                	j	800025b2 <either_copyin+0x32>

00000000800025d6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800025d6:	715d                	addi	sp,sp,-80
    800025d8:	e486                	sd	ra,72(sp)
    800025da:	e0a2                	sd	s0,64(sp)
    800025dc:	fc26                	sd	s1,56(sp)
    800025de:	f84a                	sd	s2,48(sp)
    800025e0:	f44e                	sd	s3,40(sp)
    800025e2:	f052                	sd	s4,32(sp)
    800025e4:	ec56                	sd	s5,24(sp)
    800025e6:	e85a                	sd	s6,16(sp)
    800025e8:	e45e                	sd	s7,8(sp)
    800025ea:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800025ec:	00007517          	auipc	a0,0x7
    800025f0:	54450513          	addi	a0,a0,1348 # 80009b30 <syscalls+0x6e0>
    800025f4:	ffffe097          	auipc	ra,0xffffe
    800025f8:	f94080e7          	jalr	-108(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025fc:	00010497          	auipc	s1,0x10
    80002600:	ddc48493          	addi	s1,s1,-548 # 800123d8 <proc+0x158>
    80002604:	00016917          	auipc	s2,0x16
    80002608:	1d490913          	addi	s2,s2,468 # 800187d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000260c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000260e:	00007997          	auipc	s3,0x7
    80002612:	c7298993          	addi	s3,s3,-910 # 80009280 <digits+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80002616:	00007a97          	auipc	s5,0x7
    8000261a:	c72a8a93          	addi	s5,s5,-910 # 80009288 <digits+0x248>
    printf("\n");
    8000261e:	00007a17          	auipc	s4,0x7
    80002622:	512a0a13          	addi	s4,s4,1298 # 80009b30 <syscalls+0x6e0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002626:	00007b97          	auipc	s7,0x7
    8000262a:	ca2b8b93          	addi	s7,s7,-862 # 800092c8 <states.0>
    8000262e:	a00d                	j	80002650 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002630:	ed86a583          	lw	a1,-296(a3)
    80002634:	8556                	mv	a0,s5
    80002636:	ffffe097          	auipc	ra,0xffffe
    8000263a:	f52080e7          	jalr	-174(ra) # 80000588 <printf>
    printf("\n");
    8000263e:	8552                	mv	a0,s4
    80002640:	ffffe097          	auipc	ra,0xffffe
    80002644:	f48080e7          	jalr	-184(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002648:	19048493          	addi	s1,s1,400
    8000264c:	03248263          	beq	s1,s2,80002670 <procdump+0x9a>
    if(p->state == UNUSED)
    80002650:	86a6                	mv	a3,s1
    80002652:	ec04a783          	lw	a5,-320(s1)
    80002656:	dbed                	beqz	a5,80002648 <procdump+0x72>
      state = "???";
    80002658:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000265a:	fcfb6be3          	bltu	s6,a5,80002630 <procdump+0x5a>
    8000265e:	02079713          	slli	a4,a5,0x20
    80002662:	01d75793          	srli	a5,a4,0x1d
    80002666:	97de                	add	a5,a5,s7
    80002668:	6390                	ld	a2,0(a5)
    8000266a:	f279                	bnez	a2,80002630 <procdump+0x5a>
      state = "???";
    8000266c:	864e                	mv	a2,s3
    8000266e:	b7c9                	j	80002630 <procdump+0x5a>
  }
}
    80002670:	60a6                	ld	ra,72(sp)
    80002672:	6406                	ld	s0,64(sp)
    80002674:	74e2                	ld	s1,56(sp)
    80002676:	7942                	ld	s2,48(sp)
    80002678:	79a2                	ld	s3,40(sp)
    8000267a:	7a02                	ld	s4,32(sp)
    8000267c:	6ae2                	ld	s5,24(sp)
    8000267e:	6b42                	ld	s6,16(sp)
    80002680:	6ba2                	ld	s7,8(sp)
    80002682:	6161                	addi	sp,sp,80
    80002684:	8082                	ret

0000000080002686 <swtch>:
    80002686:	00153023          	sd	ra,0(a0)
    8000268a:	00253423          	sd	sp,8(a0)
    8000268e:	e900                	sd	s0,16(a0)
    80002690:	ed04                	sd	s1,24(a0)
    80002692:	03253023          	sd	s2,32(a0)
    80002696:	03353423          	sd	s3,40(a0)
    8000269a:	03453823          	sd	s4,48(a0)
    8000269e:	03553c23          	sd	s5,56(a0)
    800026a2:	05653023          	sd	s6,64(a0)
    800026a6:	05753423          	sd	s7,72(a0)
    800026aa:	05853823          	sd	s8,80(a0)
    800026ae:	05953c23          	sd	s9,88(a0)
    800026b2:	07a53023          	sd	s10,96(a0)
    800026b6:	07b53423          	sd	s11,104(a0)
    800026ba:	0005b083          	ld	ra,0(a1)
    800026be:	0085b103          	ld	sp,8(a1)
    800026c2:	6980                	ld	s0,16(a1)
    800026c4:	6d84                	ld	s1,24(a1)
    800026c6:	0205b903          	ld	s2,32(a1)
    800026ca:	0285b983          	ld	s3,40(a1)
    800026ce:	0305ba03          	ld	s4,48(a1)
    800026d2:	0385ba83          	ld	s5,56(a1)
    800026d6:	0405bb03          	ld	s6,64(a1)
    800026da:	0485bb83          	ld	s7,72(a1)
    800026de:	0505bc03          	ld	s8,80(a1)
    800026e2:	0585bc83          	ld	s9,88(a1)
    800026e6:	0605bd03          	ld	s10,96(a1)
    800026ea:	0685bd83          	ld	s11,104(a1)
    800026ee:	8082                	ret

00000000800026f0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800026f0:	1141                	addi	sp,sp,-16
    800026f2:	e406                	sd	ra,8(sp)
    800026f4:	e022                	sd	s0,0(sp)
    800026f6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800026f8:	00007597          	auipc	a1,0x7
    800026fc:	c0058593          	addi	a1,a1,-1024 # 800092f8 <states.0+0x30>
    80002700:	00016517          	auipc	a0,0x16
    80002704:	f8050513          	addi	a0,a0,-128 # 80018680 <tickslock>
    80002708:	ffffe097          	auipc	ra,0xffffe
    8000270c:	43c080e7          	jalr	1084(ra) # 80000b44 <initlock>
}
    80002710:	60a2                	ld	ra,8(sp)
    80002712:	6402                	ld	s0,0(sp)
    80002714:	0141                	addi	sp,sp,16
    80002716:	8082                	ret

0000000080002718 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002718:	1141                	addi	sp,sp,-16
    8000271a:	e422                	sd	s0,8(sp)
    8000271c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000271e:	00004797          	auipc	a5,0x4
    80002722:	a6278793          	addi	a5,a5,-1438 # 80006180 <kernelvec>
    80002726:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000272a:	6422                	ld	s0,8(sp)
    8000272c:	0141                	addi	sp,sp,16
    8000272e:	8082                	ret

0000000080002730 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002730:	1141                	addi	sp,sp,-16
    80002732:	e406                	sd	ra,8(sp)
    80002734:	e022                	sd	s0,0(sp)
    80002736:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002738:	fffff097          	auipc	ra,0xfffff
    8000273c:	272080e7          	jalr	626(ra) # 800019aa <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002740:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002744:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002746:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000274a:	00006697          	auipc	a3,0x6
    8000274e:	8b668693          	addi	a3,a3,-1866 # 80008000 <_trampoline>
    80002752:	00006717          	auipc	a4,0x6
    80002756:	8ae70713          	addi	a4,a4,-1874 # 80008000 <_trampoline>
    8000275a:	8f15                	sub	a4,a4,a3
    8000275c:	040007b7          	lui	a5,0x4000
    80002760:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002762:	07b2                	slli	a5,a5,0xc
    80002764:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002766:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000276a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000276c:	18002673          	csrr	a2,satp
    80002770:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002772:	6d30                	ld	a2,88(a0)
    80002774:	6138                	ld	a4,64(a0)
    80002776:	6585                	lui	a1,0x1
    80002778:	972e                	add	a4,a4,a1
    8000277a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000277c:	6d38                	ld	a4,88(a0)
    8000277e:	00000617          	auipc	a2,0x0
    80002782:	13060613          	addi	a2,a2,304 # 800028ae <usertrap>
    80002786:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002788:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000278a:	8612                	mv	a2,tp
    8000278c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000278e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002792:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002796:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000279a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000279e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800027a0:	6f18                	ld	a4,24(a4)
    800027a2:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800027a6:	6928                	ld	a0,80(a0)
    800027a8:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800027aa:	00006717          	auipc	a4,0x6
    800027ae:	8f270713          	addi	a4,a4,-1806 # 8000809c <userret>
    800027b2:	8f15                	sub	a4,a4,a3
    800027b4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800027b6:	577d                	li	a4,-1
    800027b8:	177e                	slli	a4,a4,0x3f
    800027ba:	8d59                	or	a0,a0,a4
    800027bc:	9782                	jalr	a5
}
    800027be:	60a2                	ld	ra,8(sp)
    800027c0:	6402                	ld	s0,0(sp)
    800027c2:	0141                	addi	sp,sp,16
    800027c4:	8082                	ret

00000000800027c6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800027c6:	1101                	addi	sp,sp,-32
    800027c8:	ec06                	sd	ra,24(sp)
    800027ca:	e822                	sd	s0,16(sp)
    800027cc:	e426                	sd	s1,8(sp)
    800027ce:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800027d0:	00016497          	auipc	s1,0x16
    800027d4:	eb048493          	addi	s1,s1,-336 # 80018680 <tickslock>
    800027d8:	8526                	mv	a0,s1
    800027da:	ffffe097          	auipc	ra,0xffffe
    800027de:	3fa080e7          	jalr	1018(ra) # 80000bd4 <acquire>
  ticks++;
    800027e2:	00007517          	auipc	a0,0x7
    800027e6:	3fe50513          	addi	a0,a0,1022 # 80009be0 <ticks>
    800027ea:	411c                	lw	a5,0(a0)
    800027ec:	2785                	addiw	a5,a5,1
    800027ee:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800027f0:	00000097          	auipc	ra,0x0
    800027f4:	966080e7          	jalr	-1690(ra) # 80002156 <wakeup>
  release(&tickslock);
    800027f8:	8526                	mv	a0,s1
    800027fa:	ffffe097          	auipc	ra,0xffffe
    800027fe:	48e080e7          	jalr	1166(ra) # 80000c88 <release>
}
    80002802:	60e2                	ld	ra,24(sp)
    80002804:	6442                	ld	s0,16(sp)
    80002806:	64a2                	ld	s1,8(sp)
    80002808:	6105                	addi	sp,sp,32
    8000280a:	8082                	ret

000000008000280c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000280c:	1101                	addi	sp,sp,-32
    8000280e:	ec06                	sd	ra,24(sp)
    80002810:	e822                	sd	s0,16(sp)
    80002812:	e426                	sd	s1,8(sp)
    80002814:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002816:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000281a:	00074d63          	bltz	a4,80002834 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    8000281e:	57fd                	li	a5,-1
    80002820:	17fe                	slli	a5,a5,0x3f
    80002822:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002824:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002826:	06f70363          	beq	a4,a5,8000288c <devintr+0x80>
  }
}
    8000282a:	60e2                	ld	ra,24(sp)
    8000282c:	6442                	ld	s0,16(sp)
    8000282e:	64a2                	ld	s1,8(sp)
    80002830:	6105                	addi	sp,sp,32
    80002832:	8082                	ret
     (scause & 0xff) == 9){
    80002834:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80002838:	46a5                	li	a3,9
    8000283a:	fed792e3          	bne	a5,a3,8000281e <devintr+0x12>
    int irq = plic_claim();
    8000283e:	00004097          	auipc	ra,0x4
    80002842:	a4a080e7          	jalr	-1462(ra) # 80006288 <plic_claim>
    80002846:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002848:	47a9                	li	a5,10
    8000284a:	02f50763          	beq	a0,a5,80002878 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    8000284e:	4785                	li	a5,1
    80002850:	02f50963          	beq	a0,a5,80002882 <devintr+0x76>
    return 1;
    80002854:	4505                	li	a0,1
    } else if(irq){
    80002856:	d8f1                	beqz	s1,8000282a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002858:	85a6                	mv	a1,s1
    8000285a:	00007517          	auipc	a0,0x7
    8000285e:	aa650513          	addi	a0,a0,-1370 # 80009300 <states.0+0x38>
    80002862:	ffffe097          	auipc	ra,0xffffe
    80002866:	d26080e7          	jalr	-730(ra) # 80000588 <printf>
      plic_complete(irq);
    8000286a:	8526                	mv	a0,s1
    8000286c:	00004097          	auipc	ra,0x4
    80002870:	a40080e7          	jalr	-1472(ra) # 800062ac <plic_complete>
    return 1;
    80002874:	4505                	li	a0,1
    80002876:	bf55                	j	8000282a <devintr+0x1e>
      uartintr();
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	11e080e7          	jalr	286(ra) # 80000996 <uartintr>
    80002880:	b7ed                	j	8000286a <devintr+0x5e>
      virtio_disk_intr();
    80002882:	00004097          	auipc	ra,0x4
    80002886:	ef2080e7          	jalr	-270(ra) # 80006774 <virtio_disk_intr>
    8000288a:	b7c5                	j	8000286a <devintr+0x5e>
    if(cpuid() == 0){
    8000288c:	fffff097          	auipc	ra,0xfffff
    80002890:	0f2080e7          	jalr	242(ra) # 8000197e <cpuid>
    80002894:	c901                	beqz	a0,800028a4 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002896:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000289a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000289c:	14479073          	csrw	sip,a5
    return 2;
    800028a0:	4509                	li	a0,2
    800028a2:	b761                	j	8000282a <devintr+0x1e>
      clockintr();
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	f22080e7          	jalr	-222(ra) # 800027c6 <clockintr>
    800028ac:	b7ed                	j	80002896 <devintr+0x8a>

00000000800028ae <usertrap>:
{
    800028ae:	1101                	addi	sp,sp,-32
    800028b0:	ec06                	sd	ra,24(sp)
    800028b2:	e822                	sd	s0,16(sp)
    800028b4:	e426                	sd	s1,8(sp)
    800028b6:	e04a                	sd	s2,0(sp)
    800028b8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028ba:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800028be:	1007f793          	andi	a5,a5,256
    800028c2:	e3b1                	bnez	a5,80002906 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028c4:	00004797          	auipc	a5,0x4
    800028c8:	8bc78793          	addi	a5,a5,-1860 # 80006180 <kernelvec>
    800028cc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028d0:	fffff097          	auipc	ra,0xfffff
    800028d4:	0da080e7          	jalr	218(ra) # 800019aa <myproc>
    800028d8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800028da:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028dc:	14102773          	csrr	a4,sepc
    800028e0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028e2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028e6:	47a1                	li	a5,8
    800028e8:	02f70763          	beq	a4,a5,80002916 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    800028ec:	00000097          	auipc	ra,0x0
    800028f0:	f20080e7          	jalr	-224(ra) # 8000280c <devintr>
    800028f4:	892a                	mv	s2,a0
    800028f6:	c151                	beqz	a0,8000297a <usertrap+0xcc>
  if(killed(p))
    800028f8:	8526                	mv	a0,s1
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	ac4080e7          	jalr	-1340(ra) # 800023be <killed>
    80002902:	c929                	beqz	a0,80002954 <usertrap+0xa6>
    80002904:	a099                	j	8000294a <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002906:	00007517          	auipc	a0,0x7
    8000290a:	a1a50513          	addi	a0,a0,-1510 # 80009320 <states.0+0x58>
    8000290e:	ffffe097          	auipc	ra,0xffffe
    80002912:	c30080e7          	jalr	-976(ra) # 8000053e <panic>
    if(killed(p))
    80002916:	00000097          	auipc	ra,0x0
    8000291a:	aa8080e7          	jalr	-1368(ra) # 800023be <killed>
    8000291e:	e921                	bnez	a0,8000296e <usertrap+0xc0>
    p->trapframe->epc += 4;
    80002920:	6cb8                	ld	a4,88(s1)
    80002922:	6f1c                	ld	a5,24(a4)
    80002924:	0791                	addi	a5,a5,4
    80002926:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002928:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000292c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002930:	10079073          	csrw	sstatus,a5
    syscall();
    80002934:	00000097          	auipc	ra,0x0
    80002938:	2d4080e7          	jalr	724(ra) # 80002c08 <syscall>
  if(killed(p))
    8000293c:	8526                	mv	a0,s1
    8000293e:	00000097          	auipc	ra,0x0
    80002942:	a80080e7          	jalr	-1408(ra) # 800023be <killed>
    80002946:	c911                	beqz	a0,8000295a <usertrap+0xac>
    80002948:	4901                	li	s2,0
    exit(-1);
    8000294a:	557d                	li	a0,-1
    8000294c:	00000097          	auipc	ra,0x0
    80002950:	8da080e7          	jalr	-1830(ra) # 80002226 <exit>
  if(which_dev == 2)
    80002954:	4789                	li	a5,2
    80002956:	04f90f63          	beq	s2,a5,800029b4 <usertrap+0x106>
  usertrapret();
    8000295a:	00000097          	auipc	ra,0x0
    8000295e:	dd6080e7          	jalr	-554(ra) # 80002730 <usertrapret>
}
    80002962:	60e2                	ld	ra,24(sp)
    80002964:	6442                	ld	s0,16(sp)
    80002966:	64a2                	ld	s1,8(sp)
    80002968:	6902                	ld	s2,0(sp)
    8000296a:	6105                	addi	sp,sp,32
    8000296c:	8082                	ret
      exit(-1);
    8000296e:	557d                	li	a0,-1
    80002970:	00000097          	auipc	ra,0x0
    80002974:	8b6080e7          	jalr	-1866(ra) # 80002226 <exit>
    80002978:	b765                	j	80002920 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000297a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000297e:	5890                	lw	a2,48(s1)
    80002980:	00007517          	auipc	a0,0x7
    80002984:	9c050513          	addi	a0,a0,-1600 # 80009340 <states.0+0x78>
    80002988:	ffffe097          	auipc	ra,0xffffe
    8000298c:	c00080e7          	jalr	-1024(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002990:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002994:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002998:	00007517          	auipc	a0,0x7
    8000299c:	9d850513          	addi	a0,a0,-1576 # 80009370 <states.0+0xa8>
    800029a0:	ffffe097          	auipc	ra,0xffffe
    800029a4:	be8080e7          	jalr	-1048(ra) # 80000588 <printf>
    setkilled(p);
    800029a8:	8526                	mv	a0,s1
    800029aa:	00000097          	auipc	ra,0x0
    800029ae:	9e8080e7          	jalr	-1560(ra) # 80002392 <setkilled>
    800029b2:	b769                	j	8000293c <usertrap+0x8e>
    yield();
    800029b4:	fffff097          	auipc	ra,0xfffff
    800029b8:	702080e7          	jalr	1794(ra) # 800020b6 <yield>
    800029bc:	bf79                	j	8000295a <usertrap+0xac>

00000000800029be <kerneltrap>:
{
    800029be:	7179                	addi	sp,sp,-48
    800029c0:	f406                	sd	ra,40(sp)
    800029c2:	f022                	sd	s0,32(sp)
    800029c4:	ec26                	sd	s1,24(sp)
    800029c6:	e84a                	sd	s2,16(sp)
    800029c8:	e44e                	sd	s3,8(sp)
    800029ca:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029cc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029d0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029d4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800029d8:	1004f793          	andi	a5,s1,256
    800029dc:	cb85                	beqz	a5,80002a0c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029de:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800029e2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800029e4:	ef85                	bnez	a5,80002a1c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800029e6:	00000097          	auipc	ra,0x0
    800029ea:	e26080e7          	jalr	-474(ra) # 8000280c <devintr>
    800029ee:	cd1d                	beqz	a0,80002a2c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800029f0:	4789                	li	a5,2
    800029f2:	06f50a63          	beq	a0,a5,80002a66 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800029f6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029fa:	10049073          	csrw	sstatus,s1
}
    800029fe:	70a2                	ld	ra,40(sp)
    80002a00:	7402                	ld	s0,32(sp)
    80002a02:	64e2                	ld	s1,24(sp)
    80002a04:	6942                	ld	s2,16(sp)
    80002a06:	69a2                	ld	s3,8(sp)
    80002a08:	6145                	addi	sp,sp,48
    80002a0a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a0c:	00007517          	auipc	a0,0x7
    80002a10:	98450513          	addi	a0,a0,-1660 # 80009390 <states.0+0xc8>
    80002a14:	ffffe097          	auipc	ra,0xffffe
    80002a18:	b2a080e7          	jalr	-1238(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    80002a1c:	00007517          	auipc	a0,0x7
    80002a20:	99c50513          	addi	a0,a0,-1636 # 800093b8 <states.0+0xf0>
    80002a24:	ffffe097          	auipc	ra,0xffffe
    80002a28:	b1a080e7          	jalr	-1254(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    80002a2c:	85ce                	mv	a1,s3
    80002a2e:	00007517          	auipc	a0,0x7
    80002a32:	9aa50513          	addi	a0,a0,-1622 # 800093d8 <states.0+0x110>
    80002a36:	ffffe097          	auipc	ra,0xffffe
    80002a3a:	b52080e7          	jalr	-1198(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a3e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a42:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a46:	00007517          	auipc	a0,0x7
    80002a4a:	9a250513          	addi	a0,a0,-1630 # 800093e8 <states.0+0x120>
    80002a4e:	ffffe097          	auipc	ra,0xffffe
    80002a52:	b3a080e7          	jalr	-1222(ra) # 80000588 <printf>
    panic("kerneltrap");
    80002a56:	00007517          	auipc	a0,0x7
    80002a5a:	9aa50513          	addi	a0,a0,-1622 # 80009400 <states.0+0x138>
    80002a5e:	ffffe097          	auipc	ra,0xffffe
    80002a62:	ae0080e7          	jalr	-1312(ra) # 8000053e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a66:	fffff097          	auipc	ra,0xfffff
    80002a6a:	f44080e7          	jalr	-188(ra) # 800019aa <myproc>
    80002a6e:	d541                	beqz	a0,800029f6 <kerneltrap+0x38>
    80002a70:	fffff097          	auipc	ra,0xfffff
    80002a74:	f3a080e7          	jalr	-198(ra) # 800019aa <myproc>
    80002a78:	4d18                	lw	a4,24(a0)
    80002a7a:	4791                	li	a5,4
    80002a7c:	f6f71de3          	bne	a4,a5,800029f6 <kerneltrap+0x38>
    yield();
    80002a80:	fffff097          	auipc	ra,0xfffff
    80002a84:	636080e7          	jalr	1590(ra) # 800020b6 <yield>
    80002a88:	b7bd                	j	800029f6 <kerneltrap+0x38>

0000000080002a8a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a8a:	1101                	addi	sp,sp,-32
    80002a8c:	ec06                	sd	ra,24(sp)
    80002a8e:	e822                	sd	s0,16(sp)
    80002a90:	e426                	sd	s1,8(sp)
    80002a92:	1000                	addi	s0,sp,32
    80002a94:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a96:	fffff097          	auipc	ra,0xfffff
    80002a9a:	f14080e7          	jalr	-236(ra) # 800019aa <myproc>
  switch (n) {
    80002a9e:	4795                	li	a5,5
    80002aa0:	0497e163          	bltu	a5,s1,80002ae2 <argraw+0x58>
    80002aa4:	048a                	slli	s1,s1,0x2
    80002aa6:	00007717          	auipc	a4,0x7
    80002aaa:	99270713          	addi	a4,a4,-1646 # 80009438 <states.0+0x170>
    80002aae:	94ba                	add	s1,s1,a4
    80002ab0:	409c                	lw	a5,0(s1)
    80002ab2:	97ba                	add	a5,a5,a4
    80002ab4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002ab6:	6d3c                	ld	a5,88(a0)
    80002ab8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002aba:	60e2                	ld	ra,24(sp)
    80002abc:	6442                	ld	s0,16(sp)
    80002abe:	64a2                	ld	s1,8(sp)
    80002ac0:	6105                	addi	sp,sp,32
    80002ac2:	8082                	ret
    return p->trapframe->a1;
    80002ac4:	6d3c                	ld	a5,88(a0)
    80002ac6:	7fa8                	ld	a0,120(a5)
    80002ac8:	bfcd                	j	80002aba <argraw+0x30>
    return p->trapframe->a2;
    80002aca:	6d3c                	ld	a5,88(a0)
    80002acc:	63c8                	ld	a0,128(a5)
    80002ace:	b7f5                	j	80002aba <argraw+0x30>
    return p->trapframe->a3;
    80002ad0:	6d3c                	ld	a5,88(a0)
    80002ad2:	67c8                	ld	a0,136(a5)
    80002ad4:	b7dd                	j	80002aba <argraw+0x30>
    return p->trapframe->a4;
    80002ad6:	6d3c                	ld	a5,88(a0)
    80002ad8:	6bc8                	ld	a0,144(a5)
    80002ada:	b7c5                	j	80002aba <argraw+0x30>
    return p->trapframe->a5;
    80002adc:	6d3c                	ld	a5,88(a0)
    80002ade:	6fc8                	ld	a0,152(a5)
    80002ae0:	bfe9                	j	80002aba <argraw+0x30>
  panic("argraw");
    80002ae2:	00007517          	auipc	a0,0x7
    80002ae6:	92e50513          	addi	a0,a0,-1746 # 80009410 <states.0+0x148>
    80002aea:	ffffe097          	auipc	ra,0xffffe
    80002aee:	a54080e7          	jalr	-1452(ra) # 8000053e <panic>

0000000080002af2 <fetchaddr>:
{
    80002af2:	1101                	addi	sp,sp,-32
    80002af4:	ec06                	sd	ra,24(sp)
    80002af6:	e822                	sd	s0,16(sp)
    80002af8:	e426                	sd	s1,8(sp)
    80002afa:	e04a                	sd	s2,0(sp)
    80002afc:	1000                	addi	s0,sp,32
    80002afe:	84aa                	mv	s1,a0
    80002b00:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b02:	fffff097          	auipc	ra,0xfffff
    80002b06:	ea8080e7          	jalr	-344(ra) # 800019aa <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002b0a:	653c                	ld	a5,72(a0)
    80002b0c:	02f4f863          	bgeu	s1,a5,80002b3c <fetchaddr+0x4a>
    80002b10:	00848713          	addi	a4,s1,8
    80002b14:	02e7e663          	bltu	a5,a4,80002b40 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b18:	46a1                	li	a3,8
    80002b1a:	8626                	mv	a2,s1
    80002b1c:	85ca                	mv	a1,s2
    80002b1e:	6928                	ld	a0,80(a0)
    80002b20:	fffff097          	auipc	ra,0xfffff
    80002b24:	bd6080e7          	jalr	-1066(ra) # 800016f6 <copyin>
    80002b28:	00a03533          	snez	a0,a0
    80002b2c:	40a00533          	neg	a0,a0
}
    80002b30:	60e2                	ld	ra,24(sp)
    80002b32:	6442                	ld	s0,16(sp)
    80002b34:	64a2                	ld	s1,8(sp)
    80002b36:	6902                	ld	s2,0(sp)
    80002b38:	6105                	addi	sp,sp,32
    80002b3a:	8082                	ret
    return -1;
    80002b3c:	557d                	li	a0,-1
    80002b3e:	bfcd                	j	80002b30 <fetchaddr+0x3e>
    80002b40:	557d                	li	a0,-1
    80002b42:	b7fd                	j	80002b30 <fetchaddr+0x3e>

0000000080002b44 <fetchstr>:
{
    80002b44:	7179                	addi	sp,sp,-48
    80002b46:	f406                	sd	ra,40(sp)
    80002b48:	f022                	sd	s0,32(sp)
    80002b4a:	ec26                	sd	s1,24(sp)
    80002b4c:	e84a                	sd	s2,16(sp)
    80002b4e:	e44e                	sd	s3,8(sp)
    80002b50:	1800                	addi	s0,sp,48
    80002b52:	892a                	mv	s2,a0
    80002b54:	84ae                	mv	s1,a1
    80002b56:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b58:	fffff097          	auipc	ra,0xfffff
    80002b5c:	e52080e7          	jalr	-430(ra) # 800019aa <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002b60:	86ce                	mv	a3,s3
    80002b62:	864a                	mv	a2,s2
    80002b64:	85a6                	mv	a1,s1
    80002b66:	6928                	ld	a0,80(a0)
    80002b68:	fffff097          	auipc	ra,0xfffff
    80002b6c:	c1c080e7          	jalr	-996(ra) # 80001784 <copyinstr>
    80002b70:	00054e63          	bltz	a0,80002b8c <fetchstr+0x48>
  return strlen(buf);
    80002b74:	8526                	mv	a0,s1
    80002b76:	ffffe097          	auipc	ra,0xffffe
    80002b7a:	2d6080e7          	jalr	726(ra) # 80000e4c <strlen>
}
    80002b7e:	70a2                	ld	ra,40(sp)
    80002b80:	7402                	ld	s0,32(sp)
    80002b82:	64e2                	ld	s1,24(sp)
    80002b84:	6942                	ld	s2,16(sp)
    80002b86:	69a2                	ld	s3,8(sp)
    80002b88:	6145                	addi	sp,sp,48
    80002b8a:	8082                	ret
    return -1;
    80002b8c:	557d                	li	a0,-1
    80002b8e:	bfc5                	j	80002b7e <fetchstr+0x3a>

0000000080002b90 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002b90:	1101                	addi	sp,sp,-32
    80002b92:	ec06                	sd	ra,24(sp)
    80002b94:	e822                	sd	s0,16(sp)
    80002b96:	e426                	sd	s1,8(sp)
    80002b98:	1000                	addi	s0,sp,32
    80002b9a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b9c:	00000097          	auipc	ra,0x0
    80002ba0:	eee080e7          	jalr	-274(ra) # 80002a8a <argraw>
    80002ba4:	c088                	sw	a0,0(s1)
}
    80002ba6:	60e2                	ld	ra,24(sp)
    80002ba8:	6442                	ld	s0,16(sp)
    80002baa:	64a2                	ld	s1,8(sp)
    80002bac:	6105                	addi	sp,sp,32
    80002bae:	8082                	ret

0000000080002bb0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002bb0:	1101                	addi	sp,sp,-32
    80002bb2:	ec06                	sd	ra,24(sp)
    80002bb4:	e822                	sd	s0,16(sp)
    80002bb6:	e426                	sd	s1,8(sp)
    80002bb8:	1000                	addi	s0,sp,32
    80002bba:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bbc:	00000097          	auipc	ra,0x0
    80002bc0:	ece080e7          	jalr	-306(ra) # 80002a8a <argraw>
    80002bc4:	e088                	sd	a0,0(s1)
}
    80002bc6:	60e2                	ld	ra,24(sp)
    80002bc8:	6442                	ld	s0,16(sp)
    80002bca:	64a2                	ld	s1,8(sp)
    80002bcc:	6105                	addi	sp,sp,32
    80002bce:	8082                	ret

0000000080002bd0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002bd0:	7179                	addi	sp,sp,-48
    80002bd2:	f406                	sd	ra,40(sp)
    80002bd4:	f022                	sd	s0,32(sp)
    80002bd6:	ec26                	sd	s1,24(sp)
    80002bd8:	e84a                	sd	s2,16(sp)
    80002bda:	1800                	addi	s0,sp,48
    80002bdc:	84ae                	mv	s1,a1
    80002bde:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002be0:	fd840593          	addi	a1,s0,-40
    80002be4:	00000097          	auipc	ra,0x0
    80002be8:	fcc080e7          	jalr	-52(ra) # 80002bb0 <argaddr>
  return fetchstr(addr, buf, max);
    80002bec:	864a                	mv	a2,s2
    80002bee:	85a6                	mv	a1,s1
    80002bf0:	fd843503          	ld	a0,-40(s0)
    80002bf4:	00000097          	auipc	ra,0x0
    80002bf8:	f50080e7          	jalr	-176(ra) # 80002b44 <fetchstr>
}
    80002bfc:	70a2                	ld	ra,40(sp)
    80002bfe:	7402                	ld	s0,32(sp)
    80002c00:	64e2                	ld	s1,24(sp)
    80002c02:	6942                	ld	s2,16(sp)
    80002c04:	6145                	addi	sp,sp,48
    80002c06:	8082                	ret

0000000080002c08 <syscall>:
[SYS_getsched]    sys_getsched,
};

void
syscall(void)
{
    80002c08:	1101                	addi	sp,sp,-32
    80002c0a:	ec06                	sd	ra,24(sp)
    80002c0c:	e822                	sd	s0,16(sp)
    80002c0e:	e426                	sd	s1,8(sp)
    80002c10:	e04a                	sd	s2,0(sp)
    80002c12:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002c14:	fffff097          	auipc	ra,0xfffff
    80002c18:	d96080e7          	jalr	-618(ra) # 800019aa <myproc>
    80002c1c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002c1e:	05853903          	ld	s2,88(a0)
    80002c22:	0a893783          	ld	a5,168(s2)
    80002c26:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c2a:	37fd                	addiw	a5,a5,-1
    80002c2c:	4771                	li	a4,28
    80002c2e:	00f76f63          	bltu	a4,a5,80002c4c <syscall+0x44>
    80002c32:	00369713          	slli	a4,a3,0x3
    80002c36:	00007797          	auipc	a5,0x7
    80002c3a:	81a78793          	addi	a5,a5,-2022 # 80009450 <syscalls>
    80002c3e:	97ba                	add	a5,a5,a4
    80002c40:	639c                	ld	a5,0(a5)
    80002c42:	c789                	beqz	a5,80002c4c <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002c44:	9782                	jalr	a5
    80002c46:	06a93823          	sd	a0,112(s2)
    80002c4a:	a839                	j	80002c68 <syscall+0x60>

  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c4c:	15848613          	addi	a2,s1,344
    80002c50:	588c                	lw	a1,48(s1)
    80002c52:	00006517          	auipc	a0,0x6
    80002c56:	7c650513          	addi	a0,a0,1990 # 80009418 <states.0+0x150>
    80002c5a:	ffffe097          	auipc	ra,0xffffe
    80002c5e:	92e080e7          	jalr	-1746(ra) # 80000588 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c62:	6cbc                	ld	a5,88(s1)
    80002c64:	577d                	li	a4,-1
    80002c66:	fbb8                	sd	a4,112(a5)
  }
}
    80002c68:	60e2                	ld	ra,24(sp)
    80002c6a:	6442                	ld	s0,16(sp)
    80002c6c:	64a2                	ld	s1,8(sp)
    80002c6e:	6902                	ld	s2,0(sp)
    80002c70:	6105                	addi	sp,sp,32
    80002c72:	8082                	ret

0000000080002c74 <sys_getsched>:
extern struct spinlock wait_lock;
uint64 sys_uptime(void);



uint64 sys_getsched(void){
    80002c74:	1101                	addi	sp,sp,-32
    80002c76:	ec06                	sd	ra,24(sp)
    80002c78:	e822                	sd	s0,16(sp)
    80002c7a:	1000                	addi	s0,sp,32

  uint64 address;
  argaddr(0, &address);
    80002c7c:	fe840593          	addi	a1,s0,-24
    80002c80:	4501                	li	a0,0
    80002c82:	00000097          	auipc	ra,0x0
    80002c86:	f2e080e7          	jalr	-210(ra) # 80002bb0 <argaddr>
  struct proc * p = myproc();
    80002c8a:	fffff097          	auipc	ra,0xfffff
    80002c8e:	d20080e7          	jalr	-736(ra) # 800019aa <myproc>

  #ifdef FCFS
    int fcfs = SCH_FCFS;
    80002c92:	fe042223          	sw	zero,-28(s0)
    copyout(p->pagetable, address, &fcfs, sizeof(int));
    80002c96:	4691                	li	a3,4
    80002c98:	fe440613          	addi	a2,s0,-28
    80002c9c:	fe843583          	ld	a1,-24(s0)
    80002ca0:	6928                	ld	a0,80(a0)
    80002ca2:	fffff097          	auipc	ra,0xfffff
    80002ca6:	9c8080e7          	jalr	-1592(ra) # 8000166a <copyout>
    copyout(p->pagetable, address, &ps, sizeof(int));
  #else
    int def = SCH_DEF;
    copyout(p->pagetable, address, &def, sizeof(int));
  #endif
}
    80002caa:	60e2                	ld	ra,24(sp)
    80002cac:	6442                	ld	s0,16(sp)
    80002cae:	6105                	addi	sp,sp,32
    80002cb0:	8082                	ret

0000000080002cb2 <sys_getpidtime>:


uint64 sys_getpidtime(void){
    80002cb2:	7139                	addi	sp,sp,-64
    80002cb4:	fc06                	sd	ra,56(sp)
    80002cb6:	f822                	sd	s0,48(sp)
    80002cb8:	f426                	sd	s1,40(sp)
    80002cba:	f04a                	sd	s2,32(sp)
    80002cbc:	ec4e                	sd	s3,24(sp)
    80002cbe:	0080                	addi	s0,sp,64

  uint64 address;
  uint32 pid;

  argint(0, &pid);
    80002cc0:	fc440593          	addi	a1,s0,-60
    80002cc4:	4501                	li	a0,0
    80002cc6:	00000097          	auipc	ra,0x0
    80002cca:	eca080e7          	jalr	-310(ra) # 80002b90 <argint>
  argaddr(1, &address);
    80002cce:	fc840593          	addi	a1,s0,-56
    80002cd2:	4505                	li	a0,1
    80002cd4:	00000097          	auipc	ra,0x0
    80002cd8:	edc080e7          	jalr	-292(ra) # 80002bb0 <argaddr>

  struct proc * p = myproc();
    80002cdc:	fffff097          	auipc	ra,0xfffff
    80002ce0:	cce080e7          	jalr	-818(ra) # 800019aa <myproc>
    80002ce4:	89aa                	mv	s3,a0

  acquire(&wait_lock);
    80002ce6:	0000f517          	auipc	a0,0xf
    80002cea:	18250513          	addi	a0,a0,386 # 80011e68 <wait_lock>
    80002cee:	ffffe097          	auipc	ra,0xffffe
    80002cf2:	ee6080e7          	jalr	-282(ra) # 80000bd4 <acquire>

  for(struct proc * pp = proc; pp < &proc[NPROC]; pp++){
    80002cf6:	0000f497          	auipc	s1,0xf
    80002cfa:	58a48493          	addi	s1,s1,1418 # 80012280 <proc>
    80002cfe:	00016917          	auipc	s2,0x16
    80002d02:	98290913          	addi	s2,s2,-1662 # 80018680 <tickslock>
    80002d06:	a811                	j	80002d1a <sys_getpidtime+0x68>
      acquire(&pp->lock);

      if(pp->pid==pid)
          copyout(p->pagetable, address, &pp->execTime, sizeof(e_time_t));

      release(&pp->lock);
    80002d08:	8526                	mv	a0,s1
    80002d0a:	ffffe097          	auipc	ra,0xffffe
    80002d0e:	f7e080e7          	jalr	-130(ra) # 80000c88 <release>
  for(struct proc * pp = proc; pp < &proc[NPROC]; pp++){
    80002d12:	19048493          	addi	s1,s1,400
    80002d16:	03248963          	beq	s1,s2,80002d48 <sys_getpidtime+0x96>
      acquire(&pp->lock);
    80002d1a:	8526                	mv	a0,s1
    80002d1c:	ffffe097          	auipc	ra,0xffffe
    80002d20:	eb8080e7          	jalr	-328(ra) # 80000bd4 <acquire>
      if(pp->pid==pid)
    80002d24:	5898                	lw	a4,48(s1)
    80002d26:	fc442783          	lw	a5,-60(s0)
    80002d2a:	fcf71fe3          	bne	a4,a5,80002d08 <sys_getpidtime+0x56>
          copyout(p->pagetable, address, &pp->execTime, sizeof(e_time_t));
    80002d2e:	02000693          	li	a3,32
    80002d32:	16848613          	addi	a2,s1,360
    80002d36:	fc843583          	ld	a1,-56(s0)
    80002d3a:	0509b503          	ld	a0,80(s3)
    80002d3e:	fffff097          	auipc	ra,0xfffff
    80002d42:	92c080e7          	jalr	-1748(ra) # 8000166a <copyout>
    80002d46:	b7c9                	j	80002d08 <sys_getpidtime+0x56>
  }

  release(&wait_lock);
    80002d48:	0000f517          	auipc	a0,0xf
    80002d4c:	12050513          	addi	a0,a0,288 # 80011e68 <wait_lock>
    80002d50:	ffffe097          	auipc	ra,0xffffe
    80002d54:	f38080e7          	jalr	-200(ra) # 80000c88 <release>

  return 0;
}
    80002d58:	4501                	li	a0,0
    80002d5a:	70e2                	ld	ra,56(sp)
    80002d5c:	7442                	ld	s0,48(sp)
    80002d5e:	74a2                	ld	s1,40(sp)
    80002d60:	7902                	ld	s2,32(sp)
    80002d62:	69e2                	ld	s3,24(sp)
    80002d64:	6121                	addi	sp,sp,64
    80002d66:	8082                	ret

0000000080002d68 <sys_setpr>:


uint64 sys_setpr(void){
    80002d68:	1101                	addi	sp,sp,-32
    80002d6a:	ec06                	sd	ra,24(sp)
    80002d6c:	e822                	sd	s0,16(sp)
    80002d6e:	1000                	addi	s0,sp,32

  uint32 priority;
  uint32 pid;

  argint(1, &priority);
    80002d70:	fec40593          	addi	a1,s0,-20
    80002d74:	4505                	li	a0,1
    80002d76:	00000097          	auipc	ra,0x0
    80002d7a:	e1a080e7          	jalr	-486(ra) # 80002b90 <argint>
  argint(0, &pid);
    80002d7e:	fe840593          	addi	a1,s0,-24
    80002d82:	4501                	li	a0,0
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	e0c080e7          	jalr	-500(ra) # 80002b90 <argint>

  change_priority(pid,priority);
    80002d8c:	fec42583          	lw	a1,-20(s0)
    80002d90:	fe842503          	lw	a0,-24(s0)
    80002d94:	00005097          	auipc	ra,0x5
    80002d98:	86e080e7          	jalr	-1938(ra) # 80007602 <change_priority>
}
    80002d9c:	60e2                	ld	ra,24(sp)
    80002d9e:	6442                	ld	s0,16(sp)
    80002da0:	6105                	addi	sp,sp,32
    80002da2:	8082                	ret

0000000080002da4 <sys_times>:

It returns the timing information for the process with process id of pid as the e_time_t structure into
time variable.

*/
uint64 sys_times(void){
    80002da4:	1101                	addi	sp,sp,-32
    80002da6:	ec06                	sd	ra,24(sp)
    80002da8:	e822                	sd	s0,16(sp)
    80002daa:	1000                	addi	s0,sp,32

  uint32 pid;
  uint64 timeStructAddress;
  argint(0, &pid);
    80002dac:	fec40593          	addi	a1,s0,-20
    80002db0:	4501                	li	a0,0
    80002db2:	00000097          	auipc	ra,0x0
    80002db6:	dde080e7          	jalr	-546(ra) # 80002b90 <argint>
  argaddr(1, &timeStructAddress);
    80002dba:	fe040593          	addi	a1,s0,-32
    80002dbe:	4505                	li	a0,1
    80002dc0:	00000097          	auipc	ra,0x0
    80002dc4:	df0080e7          	jalr	-528(ra) # 80002bb0 <argaddr>

  get_process_time(pid,timeStructAddress,0);
    80002dc8:	4601                	li	a2,0
    80002dca:	fe043583          	ld	a1,-32(s0)
    80002dce:	fec42503          	lw	a0,-20(s0)
    80002dd2:	00004097          	auipc	ra,0x4
    80002dd6:	6b0080e7          	jalr	1712(ra) # 80007482 <get_process_time>
  
  return 0;
}
    80002dda:	4501                	li	a0,0
    80002ddc:	60e2                	ld	ra,24(sp)
    80002dde:	6442                	ld	s0,16(sp)
    80002de0:	6105                	addi	sp,sp,32
    80002de2:	8082                	ret

0000000080002de4 <sys_ps>:

  
  ps(int pid, int ppid, int status, char * pName);
  
*/
uint64 sys_ps(void){
    80002de4:	7179                	addi	sp,sp,-48
    80002de6:	f406                	sd	ra,40(sp)
    80002de8:	f022                	sd	s0,32(sp)
    80002dea:	1800                	addi	s0,sp,48
  uint32 pid;
  uint32 ppid;
  uint32 status;
  uint64 pName;

  argint(0, &pid);
    80002dec:	fec40593          	addi	a1,s0,-20
    80002df0:	4501                	li	a0,0
    80002df2:	00000097          	auipc	ra,0x0
    80002df6:	d9e080e7          	jalr	-610(ra) # 80002b90 <argint>
  argint(1, &ppid);
    80002dfa:	fe840593          	addi	a1,s0,-24
    80002dfe:	4505                	li	a0,1
    80002e00:	00000097          	auipc	ra,0x0
    80002e04:	d90080e7          	jalr	-624(ra) # 80002b90 <argint>
  argint(2, &status);
    80002e08:	fe440593          	addi	a1,s0,-28
    80002e0c:	4509                	li	a0,2
    80002e0e:	00000097          	auipc	ra,0x0
    80002e12:	d82080e7          	jalr	-638(ra) # 80002b90 <argint>
  argaddr(3, &pName);
    80002e16:	fd840593          	addi	a1,s0,-40
    80002e1a:	450d                	li	a0,3
    80002e1c:	00000097          	auipc	ra,0x0
    80002e20:	d94080e7          	jalr	-620(ra) # 80002bb0 <argaddr>

  get_process_status(pid, ppid, status, pName);
    80002e24:	fd843683          	ld	a3,-40(s0)
    80002e28:	fe442603          	lw	a2,-28(s0)
    80002e2c:	fe842583          	lw	a1,-24(s0)
    80002e30:	fec42503          	lw	a0,-20(s0)
    80002e34:	00004097          	auipc	ra,0x4
    80002e38:	140080e7          	jalr	320(ra) # 80006f74 <get_process_status>

  return 0;
}
    80002e3c:	4501                	li	a0,0
    80002e3e:	70a2                	ld	ra,40(sp)
    80002e40:	7402                	ld	s0,32(sp)
    80002e42:	6145                	addi	sp,sp,48
    80002e44:	8082                	ret

0000000080002e46 <sys_head>:

  
  head(char ** files , int numOfLines);
  
*/
uint64 sys_head(void){
    80002e46:	7131                	addi	sp,sp,-192
    80002e48:	fd06                	sd	ra,184(sp)
    80002e4a:	f922                	sd	s0,176(sp)
    80002e4c:	f526                	sd	s1,168(sp)
    80002e4e:	f14a                	sd	s2,160(sp)
    80002e50:	ed4e                	sd	s3,152(sp)
    80002e52:	e952                	sd	s4,144(sp)
    80002e54:	e556                	sd	s5,136(sp)
    80002e56:	e15a                	sd	s6,128(sp)
    80002e58:	0180                	addi	s0,sp,192

  printf("Head command is getting executed in kernel mode\n");
    80002e5a:	00006517          	auipc	a0,0x6
    80002e5e:	6e650513          	addi	a0,a0,1766 # 80009540 <syscalls+0xf0>
    80002e62:	ffffd097          	auipc	ra,0xffffd
    80002e66:	726080e7          	jalr	1830(ra) # 80000588 <printf>

  uint64 passedFiles;
  uint64 lineCount;

  /* Fetching the first and the second arguments */
  argaddr(0, &passedFiles);
    80002e6a:	fb840593          	addi	a1,s0,-72
    80002e6e:	4501                	li	a0,0
    80002e70:	00000097          	auipc	ra,0x0
    80002e74:	d40080e7          	jalr	-704(ra) # 80002bb0 <argaddr>
  argint(1, &lineCount);
    80002e78:	fb040593          	addi	a1,s0,-80
    80002e7c:	4505                	li	a0,1
    80002e7e:	00000097          	auipc	ra,0x0
    80002e82:	d12080e7          	jalr	-750(ra) # 80002b90 <argint>

  /* Get number of files passed as argument*/
  uint64 files = passedFiles;
    80002e86:	fb843483          	ld	s1,-72(s0)
  uint64 fileAddr;
  uint32 numOfFiles=0;
  fetchaddr(files, &fileAddr);
    80002e8a:	fa840593          	addi	a1,s0,-88
    80002e8e:	8526                	mv	a0,s1
    80002e90:	00000097          	auipc	ra,0x0
    80002e94:	c62080e7          	jalr	-926(ra) # 80002af2 <fetchaddr>
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};
    80002e98:	fa843783          	ld	a5,-88(s0)
    80002e9c:	c7a1                	beqz	a5,80002ee4 <sys_head+0x9e>
  uint32 numOfFiles=0;
    80002e9e:	4901                	li	s2,0
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};
    80002ea0:	04a1                	addi	s1,s1,8
    80002ea2:	fa840593          	addi	a1,s0,-88
    80002ea6:	8526                	mv	a0,s1
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	c4a080e7          	jalr	-950(ra) # 80002af2 <fetchaddr>
    80002eb0:	2905                	addiw	s2,s2,1
    80002eb2:	fa843783          	ld	a5,-88(s0)
    80002eb6:	f7ed                	bnez	a5,80002ea0 <sys_head+0x5a>


  /* Fetching the first file */
  fetchaddr(passedFiles, &fileAddr);
    80002eb8:	fa840593          	addi	a1,s0,-88
    80002ebc:	fb843503          	ld	a0,-72(s0)
    80002ec0:	00000097          	auipc	ra,0x0
    80002ec4:	c32080e7          	jalr	-974(ra) # 80002af2 <fetchaddr>

  /* Reading from STDIN */
  if(!fileAddr)
    80002ec8:	fa843503          	ld	a0,-88(s0)
    80002ecc:	cd11                	beqz	a0,80002ee8 <sys_head+0xa2>
      fetchstr(fileAddr, fileName, MAX_FILE_NAME_LEN);

      /* Open the given file */
      int fd = open_file(fileName, 0);
      
      if (fd == OPEN_FILE_ERROR)
    80002ece:	59fd                	li	s3,-1
        printf("[ERR] opening the file '%s' failed \n",fileName);
      else{
        /* Only print the header if number of files is more than 1 */
        if (numOfFiles > 1) 
    80002ed0:	4a05                	li	s4,1
          printf("==> %s <==\n",fileName);
    80002ed2:	00006a97          	auipc	s5,0x6
    80002ed6:	6cea8a93          	addi	s5,s5,1742 # 800095a0 <syscalls+0x150>
        printf("[ERR] opening the file '%s' failed \n",fileName);
    80002eda:	00006b17          	auipc	s6,0x6
    80002ede:	69eb0b13          	addi	s6,s6,1694 # 80009578 <syscalls+0x128>
    80002ee2:	a095                	j	80002f46 <sys_head+0x100>
  uint32 numOfFiles=0;
    80002ee4:	4901                	li	s2,0
    80002ee6:	bfc9                	j	80002eb8 <sys_head+0x72>
    head_run(0, lineCount);
    80002ee8:	fb042583          	lw	a1,-80(s0)
    80002eec:	4501                	li	a0,0
    80002eee:	00004097          	auipc	ra,0x4
    80002ef2:	e06080e7          	jalr	-506(ra) # 80006cf4 <head_run>
      fetchaddr(passedFiles, &fileAddr);
    }

  }
  return 0;
}
    80002ef6:	4501                	li	a0,0
    80002ef8:	70ea                	ld	ra,184(sp)
    80002efa:	744a                	ld	s0,176(sp)
    80002efc:	74aa                	ld	s1,168(sp)
    80002efe:	790a                	ld	s2,160(sp)
    80002f00:	69ea                	ld	s3,152(sp)
    80002f02:	6a4a                	ld	s4,144(sp)
    80002f04:	6aaa                	ld	s5,136(sp)
    80002f06:	6b0a                	ld	s6,128(sp)
    80002f08:	6129                	addi	sp,sp,192
    80002f0a:	8082                	ret
        printf("[ERR] opening the file '%s' failed \n",fileName);
    80002f0c:	f4040593          	addi	a1,s0,-192
    80002f10:	855a                	mv	a0,s6
    80002f12:	ffffd097          	auipc	ra,0xffffd
    80002f16:	676080e7          	jalr	1654(ra) # 80000588 <printf>
    80002f1a:	a801                	j	80002f2a <sys_head+0xe4>
        head_run(fd , lineCount);
    80002f1c:	fb042583          	lw	a1,-80(s0)
    80002f20:	8526                	mv	a0,s1
    80002f22:	00004097          	auipc	ra,0x4
    80002f26:	dd2080e7          	jalr	-558(ra) # 80006cf4 <head_run>
      passedFiles+=8;
    80002f2a:	fb843503          	ld	a0,-72(s0)
    80002f2e:	0521                	addi	a0,a0,8
    80002f30:	faa43c23          	sd	a0,-72(s0)
      fetchaddr(passedFiles, &fileAddr);
    80002f34:	fa840593          	addi	a1,s0,-88
    80002f38:	00000097          	auipc	ra,0x0
    80002f3c:	bba080e7          	jalr	-1094(ra) # 80002af2 <fetchaddr>
    while(fileAddr){
    80002f40:	fa843503          	ld	a0,-88(s0)
    80002f44:	d94d                	beqz	a0,80002ef6 <sys_head+0xb0>
      fetchstr(fileAddr, fileName, MAX_FILE_NAME_LEN);
    80002f46:	06400613          	li	a2,100
    80002f4a:	f4040593          	addi	a1,s0,-192
    80002f4e:	00000097          	auipc	ra,0x0
    80002f52:	bf6080e7          	jalr	-1034(ra) # 80002b44 <fetchstr>
      int fd = open_file(fileName, 0);
    80002f56:	4581                	li	a1,0
    80002f58:	f4040513          	addi	a0,s0,-192
    80002f5c:	00004097          	auipc	ra,0x4
    80002f60:	8cc080e7          	jalr	-1844(ra) # 80006828 <open_file>
    80002f64:	84aa                	mv	s1,a0
      if (fd == OPEN_FILE_ERROR)
    80002f66:	fb3503e3          	beq	a0,s3,80002f0c <sys_head+0xc6>
        if (numOfFiles > 1) 
    80002f6a:	fb2a79e3          	bgeu	s4,s2,80002f1c <sys_head+0xd6>
          printf("==> %s <==\n",fileName);
    80002f6e:	f4040593          	addi	a1,s0,-192
    80002f72:	8556                	mv	a0,s5
    80002f74:	ffffd097          	auipc	ra,0xffffd
    80002f78:	614080e7          	jalr	1556(ra) # 80000588 <printf>
    80002f7c:	b745                	j	80002f1c <sys_head+0xd6>

0000000080002f7e <sys_uniq>:
#define OPT_SHOW_REPEATED_LINES 4




uint64 sys_uniq(void){
    80002f7e:	7131                	addi	sp,sp,-192
    80002f80:	fd06                	sd	ra,184(sp)
    80002f82:	f922                	sd	s0,176(sp)
    80002f84:	f526                	sd	s1,168(sp)
    80002f86:	f14a                	sd	s2,160(sp)
    80002f88:	ed4e                	sd	s3,152(sp)
    80002f8a:	e952                	sd	s4,144(sp)
    80002f8c:	e556                	sd	s5,136(sp)
    80002f8e:	e15a                	sd	s6,128(sp)
    80002f90:	0180                	addi	s0,sp,192

  printf("Uniq command is getting executed in kernel mode\n");
    80002f92:	00006517          	auipc	a0,0x6
    80002f96:	61e50513          	addi	a0,a0,1566 # 800095b0 <syscalls+0x160>
    80002f9a:	ffffd097          	auipc	ra,0xffffd
    80002f9e:	5ee080e7          	jalr	1518(ra) # 80000588 <printf>

  uint64 passedFiles;
  uint64 options;

  /* Fetching the first and the second arguments */
  argaddr(0, &passedFiles);
    80002fa2:	fb840593          	addi	a1,s0,-72
    80002fa6:	4501                	li	a0,0
    80002fa8:	00000097          	auipc	ra,0x0
    80002fac:	c08080e7          	jalr	-1016(ra) # 80002bb0 <argaddr>
  argint(1, &options);
    80002fb0:	fb040593          	addi	a1,s0,-80
    80002fb4:	4505                	li	a0,1
    80002fb6:	00000097          	auipc	ra,0x0
    80002fba:	bda080e7          	jalr	-1062(ra) # 80002b90 <argint>


  /* Get number of files passed as argument*/
  uint64 files = passedFiles;
    80002fbe:	fb843483          	ld	s1,-72(s0)
  uint64 fileAddr;
  uint32 numOfFiles=0;
  fetchaddr(files, &fileAddr);
    80002fc2:	fa840593          	addi	a1,s0,-88
    80002fc6:	8526                	mv	a0,s1
    80002fc8:	00000097          	auipc	ra,0x0
    80002fcc:	b2a080e7          	jalr	-1238(ra) # 80002af2 <fetchaddr>
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};
    80002fd0:	fa843783          	ld	a5,-88(s0)
    80002fd4:	c7a1                	beqz	a5,8000301c <sys_uniq+0x9e>
  uint32 numOfFiles=0;
    80002fd6:	4901                	li	s2,0
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};
    80002fd8:	04a1                	addi	s1,s1,8
    80002fda:	fa840593          	addi	a1,s0,-88
    80002fde:	8526                	mv	a0,s1
    80002fe0:	00000097          	auipc	ra,0x0
    80002fe4:	b12080e7          	jalr	-1262(ra) # 80002af2 <fetchaddr>
    80002fe8:	2905                	addiw	s2,s2,1
    80002fea:	fa843783          	ld	a5,-88(s0)
    80002fee:	f7ed                	bnez	a5,80002fd8 <sys_uniq+0x5a>



  /* Fetching the first file */
  fetchaddr(passedFiles, &fileAddr);
    80002ff0:	fa840593          	addi	a1,s0,-88
    80002ff4:	fb843503          	ld	a0,-72(s0)
    80002ff8:	00000097          	auipc	ra,0x0
    80002ffc:	afa080e7          	jalr	-1286(ra) # 80002af2 <fetchaddr>




  /* Reading from STDIN */
  if(!fileAddr)
    80003000:	fa843503          	ld	a0,-88(s0)
    80003004:	cd11                	beqz	a0,80003020 <sys_uniq+0xa2>

      // Open the given file

      int fd = open_file(fileName, 0);

      if (fd == OPEN_FILE_ERROR)
    80003006:	59fd                	li	s3,-1
        printf("[ERR] Error opening the file '%s' \n", fileName);
      else{
        if (numOfFiles > 1) 
    80003008:	4a05                	li	s4,1
          printf("==> %s <==\n",fileName);
    8000300a:	00006a97          	auipc	s5,0x6
    8000300e:	596a8a93          	addi	s5,s5,1430 # 800095a0 <syscalls+0x150>
        printf("[ERR] Error opening the file '%s' \n", fileName);
    80003012:	00006b17          	auipc	s6,0x6
    80003016:	5d6b0b13          	addi	s6,s6,1494 # 800095e8 <syscalls+0x198>
    8000301a:	a8a5                	j	80003092 <sys_uniq+0x114>
  uint32 numOfFiles=0;
    8000301c:	4901                	li	s2,0
    8000301e:	bfc9                	j	80002ff0 <sys_uniq+0x72>
    uniq_run(0, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
    80003020:	fb044583          	lbu	a1,-80(s0)
    80003024:	0045f693          	andi	a3,a1,4
    80003028:	0025f613          	andi	a2,a1,2
    8000302c:	8985                	andi	a1,a1,1
    8000302e:	4501                	li	a0,0
    80003030:	00004097          	auipc	ra,0x4
    80003034:	d4c080e7          	jalr	-692(ra) # 80006d7c <uniq_run>

    }

  }
  return 0;
}
    80003038:	4501                	li	a0,0
    8000303a:	70ea                	ld	ra,184(sp)
    8000303c:	744a                	ld	s0,176(sp)
    8000303e:	74aa                	ld	s1,168(sp)
    80003040:	790a                	ld	s2,160(sp)
    80003042:	69ea                	ld	s3,152(sp)
    80003044:	6a4a                	ld	s4,144(sp)
    80003046:	6aaa                	ld	s5,136(sp)
    80003048:	6b0a                	ld	s6,128(sp)
    8000304a:	6129                	addi	sp,sp,192
    8000304c:	8082                	ret
        printf("[ERR] Error opening the file '%s' \n", fileName);
    8000304e:	f4040593          	addi	a1,s0,-192
    80003052:	855a                	mv	a0,s6
    80003054:	ffffd097          	auipc	ra,0xffffd
    80003058:	534080e7          	jalr	1332(ra) # 80000588 <printf>
    8000305c:	a829                	j	80003076 <sys_uniq+0xf8>
        uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
    8000305e:	fb044583          	lbu	a1,-80(s0)
    80003062:	0045f693          	andi	a3,a1,4
    80003066:	0025f613          	andi	a2,a1,2
    8000306a:	8985                	andi	a1,a1,1
    8000306c:	8526                	mv	a0,s1
    8000306e:	00004097          	auipc	ra,0x4
    80003072:	d0e080e7          	jalr	-754(ra) # 80006d7c <uniq_run>
      passedFiles+=8; // TODO
    80003076:	fb843503          	ld	a0,-72(s0)
    8000307a:	0521                	addi	a0,a0,8
    8000307c:	faa43c23          	sd	a0,-72(s0)
      fetchaddr(passedFiles, &fileAddr);
    80003080:	fa840593          	addi	a1,s0,-88
    80003084:	00000097          	auipc	ra,0x0
    80003088:	a6e080e7          	jalr	-1426(ra) # 80002af2 <fetchaddr>
    while(fileAddr){
    8000308c:	fa843503          	ld	a0,-88(s0)
    80003090:	d545                	beqz	a0,80003038 <sys_uniq+0xba>
      fetchstr(fileAddr, fileName, MAX_FILE_NAME_LEN);
    80003092:	06400613          	li	a2,100
    80003096:	f4040593          	addi	a1,s0,-192
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	aaa080e7          	jalr	-1366(ra) # 80002b44 <fetchstr>
      int fd = open_file(fileName, 0);
    800030a2:	4581                	li	a1,0
    800030a4:	f4040513          	addi	a0,s0,-192
    800030a8:	00003097          	auipc	ra,0x3
    800030ac:	780080e7          	jalr	1920(ra) # 80006828 <open_file>
    800030b0:	84aa                	mv	s1,a0
      if (fd == OPEN_FILE_ERROR)
    800030b2:	f9350ee3          	beq	a0,s3,8000304e <sys_uniq+0xd0>
        if (numOfFiles > 1) 
    800030b6:	fb2a74e3          	bgeu	s4,s2,8000305e <sys_uniq+0xe0>
          printf("==> %s <==\n",fileName);
    800030ba:	f4040593          	addi	a1,s0,-192
    800030be:	8556                	mv	a0,s5
    800030c0:	ffffd097          	auipc	ra,0xffffd
    800030c4:	4c8080e7          	jalr	1224(ra) # 80000588 <printf>
    800030c8:	bf59                	j	8000305e <sys_uniq+0xe0>

00000000800030ca <sys_exit>:



uint64
sys_exit(void)
{
    800030ca:	1101                	addi	sp,sp,-32
    800030cc:	ec06                	sd	ra,24(sp)
    800030ce:	e822                	sd	s0,16(sp)
    800030d0:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800030d2:	fec40593          	addi	a1,s0,-20
    800030d6:	4501                	li	a0,0
    800030d8:	00000097          	auipc	ra,0x0
    800030dc:	ab8080e7          	jalr	-1352(ra) # 80002b90 <argint>
  exit(n);
    800030e0:	fec42503          	lw	a0,-20(s0)
    800030e4:	fffff097          	auipc	ra,0xfffff
    800030e8:	142080e7          	jalr	322(ra) # 80002226 <exit>
  return 0;  // not reached
}
    800030ec:	4501                	li	a0,0
    800030ee:	60e2                	ld	ra,24(sp)
    800030f0:	6442                	ld	s0,16(sp)
    800030f2:	6105                	addi	sp,sp,32
    800030f4:	8082                	ret

00000000800030f6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800030f6:	1141                	addi	sp,sp,-16
    800030f8:	e406                	sd	ra,8(sp)
    800030fa:	e022                	sd	s0,0(sp)
    800030fc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800030fe:	fffff097          	auipc	ra,0xfffff
    80003102:	8ac080e7          	jalr	-1876(ra) # 800019aa <myproc>
}
    80003106:	5908                	lw	a0,48(a0)
    80003108:	60a2                	ld	ra,8(sp)
    8000310a:	6402                	ld	s0,0(sp)
    8000310c:	0141                	addi	sp,sp,16
    8000310e:	8082                	ret

0000000080003110 <sys_fork>:

uint64
sys_fork(void)
{
    80003110:	1141                	addi	sp,sp,-16
    80003112:	e406                	sd	ra,8(sp)
    80003114:	e022                	sd	s0,0(sp)
    80003116:	0800                	addi	s0,sp,16
  return fork();
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	c5a080e7          	jalr	-934(ra) # 80001d72 <fork>
}
    80003120:	60a2                	ld	ra,8(sp)
    80003122:	6402                	ld	s0,0(sp)
    80003124:	0141                	addi	sp,sp,16
    80003126:	8082                	ret

0000000080003128 <sys_wait>:

uint64
sys_wait(void)
{
    80003128:	1101                	addi	sp,sp,-32
    8000312a:	ec06                	sd	ra,24(sp)
    8000312c:	e822                	sd	s0,16(sp)
    8000312e:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003130:	fe840593          	addi	a1,s0,-24
    80003134:	4501                	li	a0,0
    80003136:	00000097          	auipc	ra,0x0
    8000313a:	a7a080e7          	jalr	-1414(ra) # 80002bb0 <argaddr>
  return wait(p);
    8000313e:	fe843503          	ld	a0,-24(s0)
    80003142:	fffff097          	auipc	ra,0xfffff
    80003146:	2ae080e7          	jalr	686(ra) # 800023f0 <wait>
}
    8000314a:	60e2                	ld	ra,24(sp)
    8000314c:	6442                	ld	s0,16(sp)
    8000314e:	6105                	addi	sp,sp,32
    80003150:	8082                	ret

0000000080003152 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003152:	7179                	addi	sp,sp,-48
    80003154:	f406                	sd	ra,40(sp)
    80003156:	f022                	sd	s0,32(sp)
    80003158:	ec26                	sd	s1,24(sp)
    8000315a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000315c:	fdc40593          	addi	a1,s0,-36
    80003160:	4501                	li	a0,0
    80003162:	00000097          	auipc	ra,0x0
    80003166:	a2e080e7          	jalr	-1490(ra) # 80002b90 <argint>
  addr = myproc()->sz;
    8000316a:	fffff097          	auipc	ra,0xfffff
    8000316e:	840080e7          	jalr	-1984(ra) # 800019aa <myproc>
    80003172:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80003174:	fdc42503          	lw	a0,-36(s0)
    80003178:	fffff097          	auipc	ra,0xfffff
    8000317c:	b9e080e7          	jalr	-1122(ra) # 80001d16 <growproc>
    80003180:	00054863          	bltz	a0,80003190 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80003184:	8526                	mv	a0,s1
    80003186:	70a2                	ld	ra,40(sp)
    80003188:	7402                	ld	s0,32(sp)
    8000318a:	64e2                	ld	s1,24(sp)
    8000318c:	6145                	addi	sp,sp,48
    8000318e:	8082                	ret
    return -1;
    80003190:	54fd                	li	s1,-1
    80003192:	bfcd                	j	80003184 <sys_sbrk+0x32>

0000000080003194 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003194:	7139                	addi	sp,sp,-64
    80003196:	fc06                	sd	ra,56(sp)
    80003198:	f822                	sd	s0,48(sp)
    8000319a:	f426                	sd	s1,40(sp)
    8000319c:	f04a                	sd	s2,32(sp)
    8000319e:	ec4e                	sd	s3,24(sp)
    800031a0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800031a2:	fcc40593          	addi	a1,s0,-52
    800031a6:	4501                	li	a0,0
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	9e8080e7          	jalr	-1560(ra) # 80002b90 <argint>
  acquire(&tickslock);
    800031b0:	00015517          	auipc	a0,0x15
    800031b4:	4d050513          	addi	a0,a0,1232 # 80018680 <tickslock>
    800031b8:	ffffe097          	auipc	ra,0xffffe
    800031bc:	a1c080e7          	jalr	-1508(ra) # 80000bd4 <acquire>
  ticks0 = ticks;
    800031c0:	00007917          	auipc	s2,0x7
    800031c4:	a2092903          	lw	s2,-1504(s2) # 80009be0 <ticks>
  while(ticks - ticks0 < n){
    800031c8:	fcc42783          	lw	a5,-52(s0)
    800031cc:	cf9d                	beqz	a5,8000320a <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800031ce:	00015997          	auipc	s3,0x15
    800031d2:	4b298993          	addi	s3,s3,1202 # 80018680 <tickslock>
    800031d6:	00007497          	auipc	s1,0x7
    800031da:	a0a48493          	addi	s1,s1,-1526 # 80009be0 <ticks>
    if(killed(myproc())){
    800031de:	ffffe097          	auipc	ra,0xffffe
    800031e2:	7cc080e7          	jalr	1996(ra) # 800019aa <myproc>
    800031e6:	fffff097          	auipc	ra,0xfffff
    800031ea:	1d8080e7          	jalr	472(ra) # 800023be <killed>
    800031ee:	ed15                	bnez	a0,8000322a <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800031f0:	85ce                	mv	a1,s3
    800031f2:	8526                	mv	a0,s1
    800031f4:	fffff097          	auipc	ra,0xfffff
    800031f8:	efe080e7          	jalr	-258(ra) # 800020f2 <sleep>
  while(ticks - ticks0 < n){
    800031fc:	409c                	lw	a5,0(s1)
    800031fe:	412787bb          	subw	a5,a5,s2
    80003202:	fcc42703          	lw	a4,-52(s0)
    80003206:	fce7ece3          	bltu	a5,a4,800031de <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000320a:	00015517          	auipc	a0,0x15
    8000320e:	47650513          	addi	a0,a0,1142 # 80018680 <tickslock>
    80003212:	ffffe097          	auipc	ra,0xffffe
    80003216:	a76080e7          	jalr	-1418(ra) # 80000c88 <release>
  return 0;
    8000321a:	4501                	li	a0,0
}
    8000321c:	70e2                	ld	ra,56(sp)
    8000321e:	7442                	ld	s0,48(sp)
    80003220:	74a2                	ld	s1,40(sp)
    80003222:	7902                	ld	s2,32(sp)
    80003224:	69e2                	ld	s3,24(sp)
    80003226:	6121                	addi	sp,sp,64
    80003228:	8082                	ret
      release(&tickslock);
    8000322a:	00015517          	auipc	a0,0x15
    8000322e:	45650513          	addi	a0,a0,1110 # 80018680 <tickslock>
    80003232:	ffffe097          	auipc	ra,0xffffe
    80003236:	a56080e7          	jalr	-1450(ra) # 80000c88 <release>
      return -1;
    8000323a:	557d                	li	a0,-1
    8000323c:	b7c5                	j	8000321c <sys_sleep+0x88>

000000008000323e <sys_kill>:

uint64
sys_kill(void)
{
    8000323e:	1101                	addi	sp,sp,-32
    80003240:	ec06                	sd	ra,24(sp)
    80003242:	e822                	sd	s0,16(sp)
    80003244:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003246:	fec40593          	addi	a1,s0,-20
    8000324a:	4501                	li	a0,0
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	944080e7          	jalr	-1724(ra) # 80002b90 <argint>
  return kill(pid);
    80003254:	fec42503          	lw	a0,-20(s0)
    80003258:	fffff097          	auipc	ra,0xfffff
    8000325c:	0c8080e7          	jalr	200(ra) # 80002320 <kill>
}
    80003260:	60e2                	ld	ra,24(sp)
    80003262:	6442                	ld	s0,16(sp)
    80003264:	6105                	addi	sp,sp,32
    80003266:	8082                	ret

0000000080003268 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003268:	1101                	addi	sp,sp,-32
    8000326a:	ec06                	sd	ra,24(sp)
    8000326c:	e822                	sd	s0,16(sp)
    8000326e:	e426                	sd	s1,8(sp)
    80003270:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003272:	00015517          	auipc	a0,0x15
    80003276:	40e50513          	addi	a0,a0,1038 # 80018680 <tickslock>
    8000327a:	ffffe097          	auipc	ra,0xffffe
    8000327e:	95a080e7          	jalr	-1702(ra) # 80000bd4 <acquire>
  xticks = ticks;
    80003282:	00007497          	auipc	s1,0x7
    80003286:	95e4a483          	lw	s1,-1698(s1) # 80009be0 <ticks>
  release(&tickslock);
    8000328a:	00015517          	auipc	a0,0x15
    8000328e:	3f650513          	addi	a0,a0,1014 # 80018680 <tickslock>
    80003292:	ffffe097          	auipc	ra,0xffffe
    80003296:	9f6080e7          	jalr	-1546(ra) # 80000c88 <release>
  return xticks;
}
    8000329a:	02049513          	slli	a0,s1,0x20
    8000329e:	9101                	srli	a0,a0,0x20
    800032a0:	60e2                	ld	ra,24(sp)
    800032a2:	6442                	ld	s0,16(sp)
    800032a4:	64a2                	ld	s1,8(sp)
    800032a6:	6105                	addi	sp,sp,32
    800032a8:	8082                	ret

00000000800032aa <sys_gettime>:
uint64 sys_gettime(void){
    800032aa:	7179                	addi	sp,sp,-48
    800032ac:	f406                	sd	ra,40(sp)
    800032ae:	f022                	sd	s0,32(sp)
    800032b0:	ec26                	sd	s1,24(sp)
    800032b2:	1800                	addi	s0,sp,48
  struct proc * p = myproc();
    800032b4:	ffffe097          	auipc	ra,0xffffe
    800032b8:	6f6080e7          	jalr	1782(ra) # 800019aa <myproc>
    800032bc:	84aa                	mv	s1,a0
  argaddr(0, &address);
    800032be:	fd840593          	addi	a1,s0,-40
    800032c2:	4501                	li	a0,0
    800032c4:	00000097          	auipc	ra,0x0
    800032c8:	8ec080e7          	jalr	-1812(ra) # 80002bb0 <argaddr>
  time=sys_uptime();
    800032cc:	00000097          	auipc	ra,0x0
    800032d0:	f9c080e7          	jalr	-100(ra) # 80003268 <sys_uptime>
    800032d4:	fca43823          	sd	a0,-48(s0)
  copyout(p->pagetable, address,&time, sizeof(uint64));
    800032d8:	46a1                	li	a3,8
    800032da:	fd040613          	addi	a2,s0,-48
    800032de:	fd843583          	ld	a1,-40(s0)
    800032e2:	68a8                	ld	a0,80(s1)
    800032e4:	ffffe097          	auipc	ra,0xffffe
    800032e8:	386080e7          	jalr	902(ra) # 8000166a <copyout>
}
    800032ec:	4501                	li	a0,0
    800032ee:	70a2                	ld	ra,40(sp)
    800032f0:	7402                	ld	s0,32(sp)
    800032f2:	64e2                	ld	s1,24(sp)
    800032f4:	6145                	addi	sp,sp,48
    800032f6:	8082                	ret

00000000800032f8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800032f8:	7179                	addi	sp,sp,-48
    800032fa:	f406                	sd	ra,40(sp)
    800032fc:	f022                	sd	s0,32(sp)
    800032fe:	ec26                	sd	s1,24(sp)
    80003300:	e84a                	sd	s2,16(sp)
    80003302:	e44e                	sd	s3,8(sp)
    80003304:	e052                	sd	s4,0(sp)
    80003306:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003308:	00006597          	auipc	a1,0x6
    8000330c:	30858593          	addi	a1,a1,776 # 80009610 <syscalls+0x1c0>
    80003310:	00015517          	auipc	a0,0x15
    80003314:	38850513          	addi	a0,a0,904 # 80018698 <bcache>
    80003318:	ffffe097          	auipc	ra,0xffffe
    8000331c:	82c080e7          	jalr	-2004(ra) # 80000b44 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003320:	0001d797          	auipc	a5,0x1d
    80003324:	37878793          	addi	a5,a5,888 # 80020698 <bcache+0x8000>
    80003328:	0001d717          	auipc	a4,0x1d
    8000332c:	5d870713          	addi	a4,a4,1496 # 80020900 <bcache+0x8268>
    80003330:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003334:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003338:	00015497          	auipc	s1,0x15
    8000333c:	37848493          	addi	s1,s1,888 # 800186b0 <bcache+0x18>
    b->next = bcache.head.next;
    80003340:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003342:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003344:	00006a17          	auipc	s4,0x6
    80003348:	2d4a0a13          	addi	s4,s4,724 # 80009618 <syscalls+0x1c8>
    b->next = bcache.head.next;
    8000334c:	2b893783          	ld	a5,696(s2)
    80003350:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003352:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003356:	85d2                	mv	a1,s4
    80003358:	01048513          	addi	a0,s1,16
    8000335c:	00001097          	auipc	ra,0x1
    80003360:	4c8080e7          	jalr	1224(ra) # 80004824 <initsleeplock>
    bcache.head.next->prev = b;
    80003364:	2b893783          	ld	a5,696(s2)
    80003368:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000336a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000336e:	45848493          	addi	s1,s1,1112
    80003372:	fd349de3          	bne	s1,s3,8000334c <binit+0x54>
  }
}
    80003376:	70a2                	ld	ra,40(sp)
    80003378:	7402                	ld	s0,32(sp)
    8000337a:	64e2                	ld	s1,24(sp)
    8000337c:	6942                	ld	s2,16(sp)
    8000337e:	69a2                	ld	s3,8(sp)
    80003380:	6a02                	ld	s4,0(sp)
    80003382:	6145                	addi	sp,sp,48
    80003384:	8082                	ret

0000000080003386 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003386:	7179                	addi	sp,sp,-48
    80003388:	f406                	sd	ra,40(sp)
    8000338a:	f022                	sd	s0,32(sp)
    8000338c:	ec26                	sd	s1,24(sp)
    8000338e:	e84a                	sd	s2,16(sp)
    80003390:	e44e                	sd	s3,8(sp)
    80003392:	1800                	addi	s0,sp,48
    80003394:	892a                	mv	s2,a0
    80003396:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003398:	00015517          	auipc	a0,0x15
    8000339c:	30050513          	addi	a0,a0,768 # 80018698 <bcache>
    800033a0:	ffffe097          	auipc	ra,0xffffe
    800033a4:	834080e7          	jalr	-1996(ra) # 80000bd4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800033a8:	0001d497          	auipc	s1,0x1d
    800033ac:	5a84b483          	ld	s1,1448(s1) # 80020950 <bcache+0x82b8>
    800033b0:	0001d797          	auipc	a5,0x1d
    800033b4:	55078793          	addi	a5,a5,1360 # 80020900 <bcache+0x8268>
    800033b8:	02f48f63          	beq	s1,a5,800033f6 <bread+0x70>
    800033bc:	873e                	mv	a4,a5
    800033be:	a021                	j	800033c6 <bread+0x40>
    800033c0:	68a4                	ld	s1,80(s1)
    800033c2:	02e48a63          	beq	s1,a4,800033f6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800033c6:	449c                	lw	a5,8(s1)
    800033c8:	ff279ce3          	bne	a5,s2,800033c0 <bread+0x3a>
    800033cc:	44dc                	lw	a5,12(s1)
    800033ce:	ff3799e3          	bne	a5,s3,800033c0 <bread+0x3a>
      b->refcnt++;
    800033d2:	40bc                	lw	a5,64(s1)
    800033d4:	2785                	addiw	a5,a5,1
    800033d6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800033d8:	00015517          	auipc	a0,0x15
    800033dc:	2c050513          	addi	a0,a0,704 # 80018698 <bcache>
    800033e0:	ffffe097          	auipc	ra,0xffffe
    800033e4:	8a8080e7          	jalr	-1880(ra) # 80000c88 <release>
      acquiresleep(&b->lock);
    800033e8:	01048513          	addi	a0,s1,16
    800033ec:	00001097          	auipc	ra,0x1
    800033f0:	472080e7          	jalr	1138(ra) # 8000485e <acquiresleep>
      return b;
    800033f4:	a8b9                	j	80003452 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800033f6:	0001d497          	auipc	s1,0x1d
    800033fa:	5524b483          	ld	s1,1362(s1) # 80020948 <bcache+0x82b0>
    800033fe:	0001d797          	auipc	a5,0x1d
    80003402:	50278793          	addi	a5,a5,1282 # 80020900 <bcache+0x8268>
    80003406:	00f48863          	beq	s1,a5,80003416 <bread+0x90>
    8000340a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000340c:	40bc                	lw	a5,64(s1)
    8000340e:	cf81                	beqz	a5,80003426 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003410:	64a4                	ld	s1,72(s1)
    80003412:	fee49de3          	bne	s1,a4,8000340c <bread+0x86>
  panic("bget: no buffers");
    80003416:	00006517          	auipc	a0,0x6
    8000341a:	20a50513          	addi	a0,a0,522 # 80009620 <syscalls+0x1d0>
    8000341e:	ffffd097          	auipc	ra,0xffffd
    80003422:	120080e7          	jalr	288(ra) # 8000053e <panic>
      b->dev = dev;
    80003426:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000342a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000342e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003432:	4785                	li	a5,1
    80003434:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003436:	00015517          	auipc	a0,0x15
    8000343a:	26250513          	addi	a0,a0,610 # 80018698 <bcache>
    8000343e:	ffffe097          	auipc	ra,0xffffe
    80003442:	84a080e7          	jalr	-1974(ra) # 80000c88 <release>
      acquiresleep(&b->lock);
    80003446:	01048513          	addi	a0,s1,16
    8000344a:	00001097          	auipc	ra,0x1
    8000344e:	414080e7          	jalr	1044(ra) # 8000485e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003452:	409c                	lw	a5,0(s1)
    80003454:	cb89                	beqz	a5,80003466 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003456:	8526                	mv	a0,s1
    80003458:	70a2                	ld	ra,40(sp)
    8000345a:	7402                	ld	s0,32(sp)
    8000345c:	64e2                	ld	s1,24(sp)
    8000345e:	6942                	ld	s2,16(sp)
    80003460:	69a2                	ld	s3,8(sp)
    80003462:	6145                	addi	sp,sp,48
    80003464:	8082                	ret
    virtio_disk_rw(b, 0);
    80003466:	4581                	li	a1,0
    80003468:	8526                	mv	a0,s1
    8000346a:	00003097          	auipc	ra,0x3
    8000346e:	0d8080e7          	jalr	216(ra) # 80006542 <virtio_disk_rw>
    b->valid = 1;
    80003472:	4785                	li	a5,1
    80003474:	c09c                	sw	a5,0(s1)
  return b;
    80003476:	b7c5                	j	80003456 <bread+0xd0>

0000000080003478 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003478:	1101                	addi	sp,sp,-32
    8000347a:	ec06                	sd	ra,24(sp)
    8000347c:	e822                	sd	s0,16(sp)
    8000347e:	e426                	sd	s1,8(sp)
    80003480:	1000                	addi	s0,sp,32
    80003482:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003484:	0541                	addi	a0,a0,16
    80003486:	00001097          	auipc	ra,0x1
    8000348a:	472080e7          	jalr	1138(ra) # 800048f8 <holdingsleep>
    8000348e:	cd01                	beqz	a0,800034a6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003490:	4585                	li	a1,1
    80003492:	8526                	mv	a0,s1
    80003494:	00003097          	auipc	ra,0x3
    80003498:	0ae080e7          	jalr	174(ra) # 80006542 <virtio_disk_rw>
}
    8000349c:	60e2                	ld	ra,24(sp)
    8000349e:	6442                	ld	s0,16(sp)
    800034a0:	64a2                	ld	s1,8(sp)
    800034a2:	6105                	addi	sp,sp,32
    800034a4:	8082                	ret
    panic("bwrite");
    800034a6:	00006517          	auipc	a0,0x6
    800034aa:	19250513          	addi	a0,a0,402 # 80009638 <syscalls+0x1e8>
    800034ae:	ffffd097          	auipc	ra,0xffffd
    800034b2:	090080e7          	jalr	144(ra) # 8000053e <panic>

00000000800034b6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800034b6:	1101                	addi	sp,sp,-32
    800034b8:	ec06                	sd	ra,24(sp)
    800034ba:	e822                	sd	s0,16(sp)
    800034bc:	e426                	sd	s1,8(sp)
    800034be:	e04a                	sd	s2,0(sp)
    800034c0:	1000                	addi	s0,sp,32
    800034c2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034c4:	01050913          	addi	s2,a0,16
    800034c8:	854a                	mv	a0,s2
    800034ca:	00001097          	auipc	ra,0x1
    800034ce:	42e080e7          	jalr	1070(ra) # 800048f8 <holdingsleep>
    800034d2:	c92d                	beqz	a0,80003544 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800034d4:	854a                	mv	a0,s2
    800034d6:	00001097          	auipc	ra,0x1
    800034da:	3de080e7          	jalr	990(ra) # 800048b4 <releasesleep>

  acquire(&bcache.lock);
    800034de:	00015517          	auipc	a0,0x15
    800034e2:	1ba50513          	addi	a0,a0,442 # 80018698 <bcache>
    800034e6:	ffffd097          	auipc	ra,0xffffd
    800034ea:	6ee080e7          	jalr	1774(ra) # 80000bd4 <acquire>
  b->refcnt--;
    800034ee:	40bc                	lw	a5,64(s1)
    800034f0:	37fd                	addiw	a5,a5,-1
    800034f2:	0007871b          	sext.w	a4,a5
    800034f6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800034f8:	eb05                	bnez	a4,80003528 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800034fa:	68bc                	ld	a5,80(s1)
    800034fc:	64b8                	ld	a4,72(s1)
    800034fe:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003500:	64bc                	ld	a5,72(s1)
    80003502:	68b8                	ld	a4,80(s1)
    80003504:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003506:	0001d797          	auipc	a5,0x1d
    8000350a:	19278793          	addi	a5,a5,402 # 80020698 <bcache+0x8000>
    8000350e:	2b87b703          	ld	a4,696(a5)
    80003512:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003514:	0001d717          	auipc	a4,0x1d
    80003518:	3ec70713          	addi	a4,a4,1004 # 80020900 <bcache+0x8268>
    8000351c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000351e:	2b87b703          	ld	a4,696(a5)
    80003522:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003524:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003528:	00015517          	auipc	a0,0x15
    8000352c:	17050513          	addi	a0,a0,368 # 80018698 <bcache>
    80003530:	ffffd097          	auipc	ra,0xffffd
    80003534:	758080e7          	jalr	1880(ra) # 80000c88 <release>
}
    80003538:	60e2                	ld	ra,24(sp)
    8000353a:	6442                	ld	s0,16(sp)
    8000353c:	64a2                	ld	s1,8(sp)
    8000353e:	6902                	ld	s2,0(sp)
    80003540:	6105                	addi	sp,sp,32
    80003542:	8082                	ret
    panic("brelse");
    80003544:	00006517          	auipc	a0,0x6
    80003548:	0fc50513          	addi	a0,a0,252 # 80009640 <syscalls+0x1f0>
    8000354c:	ffffd097          	auipc	ra,0xffffd
    80003550:	ff2080e7          	jalr	-14(ra) # 8000053e <panic>

0000000080003554 <bpin>:

void
bpin(struct buf *b) {
    80003554:	1101                	addi	sp,sp,-32
    80003556:	ec06                	sd	ra,24(sp)
    80003558:	e822                	sd	s0,16(sp)
    8000355a:	e426                	sd	s1,8(sp)
    8000355c:	1000                	addi	s0,sp,32
    8000355e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003560:	00015517          	auipc	a0,0x15
    80003564:	13850513          	addi	a0,a0,312 # 80018698 <bcache>
    80003568:	ffffd097          	auipc	ra,0xffffd
    8000356c:	66c080e7          	jalr	1644(ra) # 80000bd4 <acquire>
  b->refcnt++;
    80003570:	40bc                	lw	a5,64(s1)
    80003572:	2785                	addiw	a5,a5,1
    80003574:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003576:	00015517          	auipc	a0,0x15
    8000357a:	12250513          	addi	a0,a0,290 # 80018698 <bcache>
    8000357e:	ffffd097          	auipc	ra,0xffffd
    80003582:	70a080e7          	jalr	1802(ra) # 80000c88 <release>
}
    80003586:	60e2                	ld	ra,24(sp)
    80003588:	6442                	ld	s0,16(sp)
    8000358a:	64a2                	ld	s1,8(sp)
    8000358c:	6105                	addi	sp,sp,32
    8000358e:	8082                	ret

0000000080003590 <bunpin>:

void
bunpin(struct buf *b) {
    80003590:	1101                	addi	sp,sp,-32
    80003592:	ec06                	sd	ra,24(sp)
    80003594:	e822                	sd	s0,16(sp)
    80003596:	e426                	sd	s1,8(sp)
    80003598:	1000                	addi	s0,sp,32
    8000359a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000359c:	00015517          	auipc	a0,0x15
    800035a0:	0fc50513          	addi	a0,a0,252 # 80018698 <bcache>
    800035a4:	ffffd097          	auipc	ra,0xffffd
    800035a8:	630080e7          	jalr	1584(ra) # 80000bd4 <acquire>
  b->refcnt--;
    800035ac:	40bc                	lw	a5,64(s1)
    800035ae:	37fd                	addiw	a5,a5,-1
    800035b0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035b2:	00015517          	auipc	a0,0x15
    800035b6:	0e650513          	addi	a0,a0,230 # 80018698 <bcache>
    800035ba:	ffffd097          	auipc	ra,0xffffd
    800035be:	6ce080e7          	jalr	1742(ra) # 80000c88 <release>
}
    800035c2:	60e2                	ld	ra,24(sp)
    800035c4:	6442                	ld	s0,16(sp)
    800035c6:	64a2                	ld	s1,8(sp)
    800035c8:	6105                	addi	sp,sp,32
    800035ca:	8082                	ret

00000000800035cc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800035cc:	1101                	addi	sp,sp,-32
    800035ce:	ec06                	sd	ra,24(sp)
    800035d0:	e822                	sd	s0,16(sp)
    800035d2:	e426                	sd	s1,8(sp)
    800035d4:	e04a                	sd	s2,0(sp)
    800035d6:	1000                	addi	s0,sp,32
    800035d8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800035da:	00d5d59b          	srliw	a1,a1,0xd
    800035de:	0001d797          	auipc	a5,0x1d
    800035e2:	7967a783          	lw	a5,1942(a5) # 80020d74 <sb+0x1c>
    800035e6:	9dbd                	addw	a1,a1,a5
    800035e8:	00000097          	auipc	ra,0x0
    800035ec:	d9e080e7          	jalr	-610(ra) # 80003386 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800035f0:	0074f713          	andi	a4,s1,7
    800035f4:	4785                	li	a5,1
    800035f6:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800035fa:	14ce                	slli	s1,s1,0x33
    800035fc:	90d9                	srli	s1,s1,0x36
    800035fe:	00950733          	add	a4,a0,s1
    80003602:	05874703          	lbu	a4,88(a4)
    80003606:	00e7f6b3          	and	a3,a5,a4
    8000360a:	c69d                	beqz	a3,80003638 <bfree+0x6c>
    8000360c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000360e:	94aa                	add	s1,s1,a0
    80003610:	fff7c793          	not	a5,a5
    80003614:	8f7d                	and	a4,a4,a5
    80003616:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000361a:	00001097          	auipc	ra,0x1
    8000361e:	126080e7          	jalr	294(ra) # 80004740 <log_write>
  brelse(bp);
    80003622:	854a                	mv	a0,s2
    80003624:	00000097          	auipc	ra,0x0
    80003628:	e92080e7          	jalr	-366(ra) # 800034b6 <brelse>
}
    8000362c:	60e2                	ld	ra,24(sp)
    8000362e:	6442                	ld	s0,16(sp)
    80003630:	64a2                	ld	s1,8(sp)
    80003632:	6902                	ld	s2,0(sp)
    80003634:	6105                	addi	sp,sp,32
    80003636:	8082                	ret
    panic("freeing free block");
    80003638:	00006517          	auipc	a0,0x6
    8000363c:	01050513          	addi	a0,a0,16 # 80009648 <syscalls+0x1f8>
    80003640:	ffffd097          	auipc	ra,0xffffd
    80003644:	efe080e7          	jalr	-258(ra) # 8000053e <panic>

0000000080003648 <balloc>:
{
    80003648:	711d                	addi	sp,sp,-96
    8000364a:	ec86                	sd	ra,88(sp)
    8000364c:	e8a2                	sd	s0,80(sp)
    8000364e:	e4a6                	sd	s1,72(sp)
    80003650:	e0ca                	sd	s2,64(sp)
    80003652:	fc4e                	sd	s3,56(sp)
    80003654:	f852                	sd	s4,48(sp)
    80003656:	f456                	sd	s5,40(sp)
    80003658:	f05a                	sd	s6,32(sp)
    8000365a:	ec5e                	sd	s7,24(sp)
    8000365c:	e862                	sd	s8,16(sp)
    8000365e:	e466                	sd	s9,8(sp)
    80003660:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003662:	0001d797          	auipc	a5,0x1d
    80003666:	6fa7a783          	lw	a5,1786(a5) # 80020d5c <sb+0x4>
    8000366a:	cff5                	beqz	a5,80003766 <balloc+0x11e>
    8000366c:	8baa                	mv	s7,a0
    8000366e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003670:	0001db17          	auipc	s6,0x1d
    80003674:	6e8b0b13          	addi	s6,s6,1768 # 80020d58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003678:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000367a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000367c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000367e:	6c89                	lui	s9,0x2
    80003680:	a061                	j	80003708 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003682:	97ca                	add	a5,a5,s2
    80003684:	8e55                	or	a2,a2,a3
    80003686:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000368a:	854a                	mv	a0,s2
    8000368c:	00001097          	auipc	ra,0x1
    80003690:	0b4080e7          	jalr	180(ra) # 80004740 <log_write>
        brelse(bp);
    80003694:	854a                	mv	a0,s2
    80003696:	00000097          	auipc	ra,0x0
    8000369a:	e20080e7          	jalr	-480(ra) # 800034b6 <brelse>
  bp = bread(dev, bno);
    8000369e:	85a6                	mv	a1,s1
    800036a0:	855e                	mv	a0,s7
    800036a2:	00000097          	auipc	ra,0x0
    800036a6:	ce4080e7          	jalr	-796(ra) # 80003386 <bread>
    800036aa:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800036ac:	40000613          	li	a2,1024
    800036b0:	4581                	li	a1,0
    800036b2:	05850513          	addi	a0,a0,88
    800036b6:	ffffd097          	auipc	ra,0xffffd
    800036ba:	61a080e7          	jalr	1562(ra) # 80000cd0 <memset>
  log_write(bp);
    800036be:	854a                	mv	a0,s2
    800036c0:	00001097          	auipc	ra,0x1
    800036c4:	080080e7          	jalr	128(ra) # 80004740 <log_write>
  brelse(bp);
    800036c8:	854a                	mv	a0,s2
    800036ca:	00000097          	auipc	ra,0x0
    800036ce:	dec080e7          	jalr	-532(ra) # 800034b6 <brelse>
}
    800036d2:	8526                	mv	a0,s1
    800036d4:	60e6                	ld	ra,88(sp)
    800036d6:	6446                	ld	s0,80(sp)
    800036d8:	64a6                	ld	s1,72(sp)
    800036da:	6906                	ld	s2,64(sp)
    800036dc:	79e2                	ld	s3,56(sp)
    800036de:	7a42                	ld	s4,48(sp)
    800036e0:	7aa2                	ld	s5,40(sp)
    800036e2:	7b02                	ld	s6,32(sp)
    800036e4:	6be2                	ld	s7,24(sp)
    800036e6:	6c42                	ld	s8,16(sp)
    800036e8:	6ca2                	ld	s9,8(sp)
    800036ea:	6125                	addi	sp,sp,96
    800036ec:	8082                	ret
    brelse(bp);
    800036ee:	854a                	mv	a0,s2
    800036f0:	00000097          	auipc	ra,0x0
    800036f4:	dc6080e7          	jalr	-570(ra) # 800034b6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800036f8:	015c87bb          	addw	a5,s9,s5
    800036fc:	00078a9b          	sext.w	s5,a5
    80003700:	004b2703          	lw	a4,4(s6)
    80003704:	06eaf163          	bgeu	s5,a4,80003766 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80003708:	41fad79b          	sraiw	a5,s5,0x1f
    8000370c:	0137d79b          	srliw	a5,a5,0x13
    80003710:	015787bb          	addw	a5,a5,s5
    80003714:	40d7d79b          	sraiw	a5,a5,0xd
    80003718:	01cb2583          	lw	a1,28(s6)
    8000371c:	9dbd                	addw	a1,a1,a5
    8000371e:	855e                	mv	a0,s7
    80003720:	00000097          	auipc	ra,0x0
    80003724:	c66080e7          	jalr	-922(ra) # 80003386 <bread>
    80003728:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000372a:	004b2503          	lw	a0,4(s6)
    8000372e:	000a849b          	sext.w	s1,s5
    80003732:	8762                	mv	a4,s8
    80003734:	faa4fde3          	bgeu	s1,a0,800036ee <balloc+0xa6>
      m = 1 << (bi % 8);
    80003738:	00777693          	andi	a3,a4,7
    8000373c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003740:	41f7579b          	sraiw	a5,a4,0x1f
    80003744:	01d7d79b          	srliw	a5,a5,0x1d
    80003748:	9fb9                	addw	a5,a5,a4
    8000374a:	4037d79b          	sraiw	a5,a5,0x3
    8000374e:	00f90633          	add	a2,s2,a5
    80003752:	05864603          	lbu	a2,88(a2)
    80003756:	00c6f5b3          	and	a1,a3,a2
    8000375a:	d585                	beqz	a1,80003682 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000375c:	2705                	addiw	a4,a4,1
    8000375e:	2485                	addiw	s1,s1,1
    80003760:	fd471ae3          	bne	a4,s4,80003734 <balloc+0xec>
    80003764:	b769                	j	800036ee <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003766:	00006517          	auipc	a0,0x6
    8000376a:	efa50513          	addi	a0,a0,-262 # 80009660 <syscalls+0x210>
    8000376e:	ffffd097          	auipc	ra,0xffffd
    80003772:	e1a080e7          	jalr	-486(ra) # 80000588 <printf>
  return 0;
    80003776:	4481                	li	s1,0
    80003778:	bfa9                	j	800036d2 <balloc+0x8a>

000000008000377a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000377a:	7179                	addi	sp,sp,-48
    8000377c:	f406                	sd	ra,40(sp)
    8000377e:	f022                	sd	s0,32(sp)
    80003780:	ec26                	sd	s1,24(sp)
    80003782:	e84a                	sd	s2,16(sp)
    80003784:	e44e                	sd	s3,8(sp)
    80003786:	e052                	sd	s4,0(sp)
    80003788:	1800                	addi	s0,sp,48
    8000378a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000378c:	47ad                	li	a5,11
    8000378e:	02b7e863          	bltu	a5,a1,800037be <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80003792:	02059793          	slli	a5,a1,0x20
    80003796:	01e7d593          	srli	a1,a5,0x1e
    8000379a:	00b504b3          	add	s1,a0,a1
    8000379e:	0504a903          	lw	s2,80(s1)
    800037a2:	06091e63          	bnez	s2,8000381e <bmap+0xa4>
      addr = balloc(ip->dev);
    800037a6:	4108                	lw	a0,0(a0)
    800037a8:	00000097          	auipc	ra,0x0
    800037ac:	ea0080e7          	jalr	-352(ra) # 80003648 <balloc>
    800037b0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800037b4:	06090563          	beqz	s2,8000381e <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800037b8:	0524a823          	sw	s2,80(s1)
    800037bc:	a08d                	j	8000381e <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800037be:	ff45849b          	addiw	s1,a1,-12
    800037c2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800037c6:	0ff00793          	li	a5,255
    800037ca:	08e7e563          	bltu	a5,a4,80003854 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800037ce:	08052903          	lw	s2,128(a0)
    800037d2:	00091d63          	bnez	s2,800037ec <bmap+0x72>
      addr = balloc(ip->dev);
    800037d6:	4108                	lw	a0,0(a0)
    800037d8:	00000097          	auipc	ra,0x0
    800037dc:	e70080e7          	jalr	-400(ra) # 80003648 <balloc>
    800037e0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800037e4:	02090d63          	beqz	s2,8000381e <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800037e8:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800037ec:	85ca                	mv	a1,s2
    800037ee:	0009a503          	lw	a0,0(s3)
    800037f2:	00000097          	auipc	ra,0x0
    800037f6:	b94080e7          	jalr	-1132(ra) # 80003386 <bread>
    800037fa:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800037fc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003800:	02049713          	slli	a4,s1,0x20
    80003804:	01e75593          	srli	a1,a4,0x1e
    80003808:	00b784b3          	add	s1,a5,a1
    8000380c:	0004a903          	lw	s2,0(s1)
    80003810:	02090063          	beqz	s2,80003830 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003814:	8552                	mv	a0,s4
    80003816:	00000097          	auipc	ra,0x0
    8000381a:	ca0080e7          	jalr	-864(ra) # 800034b6 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000381e:	854a                	mv	a0,s2
    80003820:	70a2                	ld	ra,40(sp)
    80003822:	7402                	ld	s0,32(sp)
    80003824:	64e2                	ld	s1,24(sp)
    80003826:	6942                	ld	s2,16(sp)
    80003828:	69a2                	ld	s3,8(sp)
    8000382a:	6a02                	ld	s4,0(sp)
    8000382c:	6145                	addi	sp,sp,48
    8000382e:	8082                	ret
      addr = balloc(ip->dev);
    80003830:	0009a503          	lw	a0,0(s3)
    80003834:	00000097          	auipc	ra,0x0
    80003838:	e14080e7          	jalr	-492(ra) # 80003648 <balloc>
    8000383c:	0005091b          	sext.w	s2,a0
      if(addr){
    80003840:	fc090ae3          	beqz	s2,80003814 <bmap+0x9a>
        a[bn] = addr;
    80003844:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003848:	8552                	mv	a0,s4
    8000384a:	00001097          	auipc	ra,0x1
    8000384e:	ef6080e7          	jalr	-266(ra) # 80004740 <log_write>
    80003852:	b7c9                	j	80003814 <bmap+0x9a>
  panic("bmap: out of range");
    80003854:	00006517          	auipc	a0,0x6
    80003858:	e2450513          	addi	a0,a0,-476 # 80009678 <syscalls+0x228>
    8000385c:	ffffd097          	auipc	ra,0xffffd
    80003860:	ce2080e7          	jalr	-798(ra) # 8000053e <panic>

0000000080003864 <iget>:
{
    80003864:	7179                	addi	sp,sp,-48
    80003866:	f406                	sd	ra,40(sp)
    80003868:	f022                	sd	s0,32(sp)
    8000386a:	ec26                	sd	s1,24(sp)
    8000386c:	e84a                	sd	s2,16(sp)
    8000386e:	e44e                	sd	s3,8(sp)
    80003870:	e052                	sd	s4,0(sp)
    80003872:	1800                	addi	s0,sp,48
    80003874:	89aa                	mv	s3,a0
    80003876:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003878:	0001d517          	auipc	a0,0x1d
    8000387c:	50050513          	addi	a0,a0,1280 # 80020d78 <itable>
    80003880:	ffffd097          	auipc	ra,0xffffd
    80003884:	354080e7          	jalr	852(ra) # 80000bd4 <acquire>
  empty = 0;
    80003888:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000388a:	0001d497          	auipc	s1,0x1d
    8000388e:	50648493          	addi	s1,s1,1286 # 80020d90 <itable+0x18>
    80003892:	0001f697          	auipc	a3,0x1f
    80003896:	f8e68693          	addi	a3,a3,-114 # 80022820 <log>
    8000389a:	a039                	j	800038a8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000389c:	02090b63          	beqz	s2,800038d2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800038a0:	08848493          	addi	s1,s1,136
    800038a4:	02d48a63          	beq	s1,a3,800038d8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800038a8:	449c                	lw	a5,8(s1)
    800038aa:	fef059e3          	blez	a5,8000389c <iget+0x38>
    800038ae:	4098                	lw	a4,0(s1)
    800038b0:	ff3716e3          	bne	a4,s3,8000389c <iget+0x38>
    800038b4:	40d8                	lw	a4,4(s1)
    800038b6:	ff4713e3          	bne	a4,s4,8000389c <iget+0x38>
      ip->ref++;
    800038ba:	2785                	addiw	a5,a5,1
    800038bc:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800038be:	0001d517          	auipc	a0,0x1d
    800038c2:	4ba50513          	addi	a0,a0,1210 # 80020d78 <itable>
    800038c6:	ffffd097          	auipc	ra,0xffffd
    800038ca:	3c2080e7          	jalr	962(ra) # 80000c88 <release>
      return ip;
    800038ce:	8926                	mv	s2,s1
    800038d0:	a03d                	j	800038fe <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800038d2:	f7f9                	bnez	a5,800038a0 <iget+0x3c>
    800038d4:	8926                	mv	s2,s1
    800038d6:	b7e9                	j	800038a0 <iget+0x3c>
  if(empty == 0)
    800038d8:	02090c63          	beqz	s2,80003910 <iget+0xac>
  ip->dev = dev;
    800038dc:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800038e0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800038e4:	4785                	li	a5,1
    800038e6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800038ea:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800038ee:	0001d517          	auipc	a0,0x1d
    800038f2:	48a50513          	addi	a0,a0,1162 # 80020d78 <itable>
    800038f6:	ffffd097          	auipc	ra,0xffffd
    800038fa:	392080e7          	jalr	914(ra) # 80000c88 <release>
}
    800038fe:	854a                	mv	a0,s2
    80003900:	70a2                	ld	ra,40(sp)
    80003902:	7402                	ld	s0,32(sp)
    80003904:	64e2                	ld	s1,24(sp)
    80003906:	6942                	ld	s2,16(sp)
    80003908:	69a2                	ld	s3,8(sp)
    8000390a:	6a02                	ld	s4,0(sp)
    8000390c:	6145                	addi	sp,sp,48
    8000390e:	8082                	ret
    panic("iget: no inodes");
    80003910:	00006517          	auipc	a0,0x6
    80003914:	d8050513          	addi	a0,a0,-640 # 80009690 <syscalls+0x240>
    80003918:	ffffd097          	auipc	ra,0xffffd
    8000391c:	c26080e7          	jalr	-986(ra) # 8000053e <panic>

0000000080003920 <fsinit>:
fsinit(int dev) {
    80003920:	7179                	addi	sp,sp,-48
    80003922:	f406                	sd	ra,40(sp)
    80003924:	f022                	sd	s0,32(sp)
    80003926:	ec26                	sd	s1,24(sp)
    80003928:	e84a                	sd	s2,16(sp)
    8000392a:	e44e                	sd	s3,8(sp)
    8000392c:	1800                	addi	s0,sp,48
    8000392e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003930:	4585                	li	a1,1
    80003932:	00000097          	auipc	ra,0x0
    80003936:	a54080e7          	jalr	-1452(ra) # 80003386 <bread>
    8000393a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000393c:	0001d997          	auipc	s3,0x1d
    80003940:	41c98993          	addi	s3,s3,1052 # 80020d58 <sb>
    80003944:	02000613          	li	a2,32
    80003948:	05850593          	addi	a1,a0,88
    8000394c:	854e                	mv	a0,s3
    8000394e:	ffffd097          	auipc	ra,0xffffd
    80003952:	3de080e7          	jalr	990(ra) # 80000d2c <memmove>
  brelse(bp);
    80003956:	8526                	mv	a0,s1
    80003958:	00000097          	auipc	ra,0x0
    8000395c:	b5e080e7          	jalr	-1186(ra) # 800034b6 <brelse>
  if(sb.magic != FSMAGIC)
    80003960:	0009a703          	lw	a4,0(s3)
    80003964:	102037b7          	lui	a5,0x10203
    80003968:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000396c:	02f71263          	bne	a4,a5,80003990 <fsinit+0x70>
  initlog(dev, &sb);
    80003970:	0001d597          	auipc	a1,0x1d
    80003974:	3e858593          	addi	a1,a1,1000 # 80020d58 <sb>
    80003978:	854a                	mv	a0,s2
    8000397a:	00001097          	auipc	ra,0x1
    8000397e:	b4a080e7          	jalr	-1206(ra) # 800044c4 <initlog>
}
    80003982:	70a2                	ld	ra,40(sp)
    80003984:	7402                	ld	s0,32(sp)
    80003986:	64e2                	ld	s1,24(sp)
    80003988:	6942                	ld	s2,16(sp)
    8000398a:	69a2                	ld	s3,8(sp)
    8000398c:	6145                	addi	sp,sp,48
    8000398e:	8082                	ret
    panic("invalid file system");
    80003990:	00006517          	auipc	a0,0x6
    80003994:	d1050513          	addi	a0,a0,-752 # 800096a0 <syscalls+0x250>
    80003998:	ffffd097          	auipc	ra,0xffffd
    8000399c:	ba6080e7          	jalr	-1114(ra) # 8000053e <panic>

00000000800039a0 <iinit>:
{
    800039a0:	7179                	addi	sp,sp,-48
    800039a2:	f406                	sd	ra,40(sp)
    800039a4:	f022                	sd	s0,32(sp)
    800039a6:	ec26                	sd	s1,24(sp)
    800039a8:	e84a                	sd	s2,16(sp)
    800039aa:	e44e                	sd	s3,8(sp)
    800039ac:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800039ae:	00006597          	auipc	a1,0x6
    800039b2:	d0a58593          	addi	a1,a1,-758 # 800096b8 <syscalls+0x268>
    800039b6:	0001d517          	auipc	a0,0x1d
    800039ba:	3c250513          	addi	a0,a0,962 # 80020d78 <itable>
    800039be:	ffffd097          	auipc	ra,0xffffd
    800039c2:	186080e7          	jalr	390(ra) # 80000b44 <initlock>
  for(i = 0; i < NINODE; i++) {
    800039c6:	0001d497          	auipc	s1,0x1d
    800039ca:	3da48493          	addi	s1,s1,986 # 80020da0 <itable+0x28>
    800039ce:	0001f997          	auipc	s3,0x1f
    800039d2:	e6298993          	addi	s3,s3,-414 # 80022830 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800039d6:	00006917          	auipc	s2,0x6
    800039da:	cea90913          	addi	s2,s2,-790 # 800096c0 <syscalls+0x270>
    800039de:	85ca                	mv	a1,s2
    800039e0:	8526                	mv	a0,s1
    800039e2:	00001097          	auipc	ra,0x1
    800039e6:	e42080e7          	jalr	-446(ra) # 80004824 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800039ea:	08848493          	addi	s1,s1,136
    800039ee:	ff3498e3          	bne	s1,s3,800039de <iinit+0x3e>
}
    800039f2:	70a2                	ld	ra,40(sp)
    800039f4:	7402                	ld	s0,32(sp)
    800039f6:	64e2                	ld	s1,24(sp)
    800039f8:	6942                	ld	s2,16(sp)
    800039fa:	69a2                	ld	s3,8(sp)
    800039fc:	6145                	addi	sp,sp,48
    800039fe:	8082                	ret

0000000080003a00 <ialloc>:
{
    80003a00:	715d                	addi	sp,sp,-80
    80003a02:	e486                	sd	ra,72(sp)
    80003a04:	e0a2                	sd	s0,64(sp)
    80003a06:	fc26                	sd	s1,56(sp)
    80003a08:	f84a                	sd	s2,48(sp)
    80003a0a:	f44e                	sd	s3,40(sp)
    80003a0c:	f052                	sd	s4,32(sp)
    80003a0e:	ec56                	sd	s5,24(sp)
    80003a10:	e85a                	sd	s6,16(sp)
    80003a12:	e45e                	sd	s7,8(sp)
    80003a14:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a16:	0001d717          	auipc	a4,0x1d
    80003a1a:	34e72703          	lw	a4,846(a4) # 80020d64 <sb+0xc>
    80003a1e:	4785                	li	a5,1
    80003a20:	04e7fa63          	bgeu	a5,a4,80003a74 <ialloc+0x74>
    80003a24:	8aaa                	mv	s5,a0
    80003a26:	8bae                	mv	s7,a1
    80003a28:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003a2a:	0001da17          	auipc	s4,0x1d
    80003a2e:	32ea0a13          	addi	s4,s4,814 # 80020d58 <sb>
    80003a32:	00048b1b          	sext.w	s6,s1
    80003a36:	0044d593          	srli	a1,s1,0x4
    80003a3a:	018a2783          	lw	a5,24(s4)
    80003a3e:	9dbd                	addw	a1,a1,a5
    80003a40:	8556                	mv	a0,s5
    80003a42:	00000097          	auipc	ra,0x0
    80003a46:	944080e7          	jalr	-1724(ra) # 80003386 <bread>
    80003a4a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003a4c:	05850993          	addi	s3,a0,88
    80003a50:	00f4f793          	andi	a5,s1,15
    80003a54:	079a                	slli	a5,a5,0x6
    80003a56:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003a58:	00099783          	lh	a5,0(s3)
    80003a5c:	c3a1                	beqz	a5,80003a9c <ialloc+0x9c>
    brelse(bp);
    80003a5e:	00000097          	auipc	ra,0x0
    80003a62:	a58080e7          	jalr	-1448(ra) # 800034b6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a66:	0485                	addi	s1,s1,1
    80003a68:	00ca2703          	lw	a4,12(s4)
    80003a6c:	0004879b          	sext.w	a5,s1
    80003a70:	fce7e1e3          	bltu	a5,a4,80003a32 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003a74:	00006517          	auipc	a0,0x6
    80003a78:	c5450513          	addi	a0,a0,-940 # 800096c8 <syscalls+0x278>
    80003a7c:	ffffd097          	auipc	ra,0xffffd
    80003a80:	b0c080e7          	jalr	-1268(ra) # 80000588 <printf>
  return 0;
    80003a84:	4501                	li	a0,0
}
    80003a86:	60a6                	ld	ra,72(sp)
    80003a88:	6406                	ld	s0,64(sp)
    80003a8a:	74e2                	ld	s1,56(sp)
    80003a8c:	7942                	ld	s2,48(sp)
    80003a8e:	79a2                	ld	s3,40(sp)
    80003a90:	7a02                	ld	s4,32(sp)
    80003a92:	6ae2                	ld	s5,24(sp)
    80003a94:	6b42                	ld	s6,16(sp)
    80003a96:	6ba2                	ld	s7,8(sp)
    80003a98:	6161                	addi	sp,sp,80
    80003a9a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003a9c:	04000613          	li	a2,64
    80003aa0:	4581                	li	a1,0
    80003aa2:	854e                	mv	a0,s3
    80003aa4:	ffffd097          	auipc	ra,0xffffd
    80003aa8:	22c080e7          	jalr	556(ra) # 80000cd0 <memset>
      dip->type = type;
    80003aac:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003ab0:	854a                	mv	a0,s2
    80003ab2:	00001097          	auipc	ra,0x1
    80003ab6:	c8e080e7          	jalr	-882(ra) # 80004740 <log_write>
      brelse(bp);
    80003aba:	854a                	mv	a0,s2
    80003abc:	00000097          	auipc	ra,0x0
    80003ac0:	9fa080e7          	jalr	-1542(ra) # 800034b6 <brelse>
      return iget(dev, inum);
    80003ac4:	85da                	mv	a1,s6
    80003ac6:	8556                	mv	a0,s5
    80003ac8:	00000097          	auipc	ra,0x0
    80003acc:	d9c080e7          	jalr	-612(ra) # 80003864 <iget>
    80003ad0:	bf5d                	j	80003a86 <ialloc+0x86>

0000000080003ad2 <iupdate>:
{
    80003ad2:	1101                	addi	sp,sp,-32
    80003ad4:	ec06                	sd	ra,24(sp)
    80003ad6:	e822                	sd	s0,16(sp)
    80003ad8:	e426                	sd	s1,8(sp)
    80003ada:	e04a                	sd	s2,0(sp)
    80003adc:	1000                	addi	s0,sp,32
    80003ade:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003ae0:	415c                	lw	a5,4(a0)
    80003ae2:	0047d79b          	srliw	a5,a5,0x4
    80003ae6:	0001d597          	auipc	a1,0x1d
    80003aea:	28a5a583          	lw	a1,650(a1) # 80020d70 <sb+0x18>
    80003aee:	9dbd                	addw	a1,a1,a5
    80003af0:	4108                	lw	a0,0(a0)
    80003af2:	00000097          	auipc	ra,0x0
    80003af6:	894080e7          	jalr	-1900(ra) # 80003386 <bread>
    80003afa:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003afc:	05850793          	addi	a5,a0,88
    80003b00:	40d8                	lw	a4,4(s1)
    80003b02:	8b3d                	andi	a4,a4,15
    80003b04:	071a                	slli	a4,a4,0x6
    80003b06:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003b08:	04449703          	lh	a4,68(s1)
    80003b0c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003b10:	04649703          	lh	a4,70(s1)
    80003b14:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003b18:	04849703          	lh	a4,72(s1)
    80003b1c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003b20:	04a49703          	lh	a4,74(s1)
    80003b24:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003b28:	44f8                	lw	a4,76(s1)
    80003b2a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003b2c:	03400613          	li	a2,52
    80003b30:	05048593          	addi	a1,s1,80
    80003b34:	00c78513          	addi	a0,a5,12
    80003b38:	ffffd097          	auipc	ra,0xffffd
    80003b3c:	1f4080e7          	jalr	500(ra) # 80000d2c <memmove>
  log_write(bp);
    80003b40:	854a                	mv	a0,s2
    80003b42:	00001097          	auipc	ra,0x1
    80003b46:	bfe080e7          	jalr	-1026(ra) # 80004740 <log_write>
  brelse(bp);
    80003b4a:	854a                	mv	a0,s2
    80003b4c:	00000097          	auipc	ra,0x0
    80003b50:	96a080e7          	jalr	-1686(ra) # 800034b6 <brelse>
}
    80003b54:	60e2                	ld	ra,24(sp)
    80003b56:	6442                	ld	s0,16(sp)
    80003b58:	64a2                	ld	s1,8(sp)
    80003b5a:	6902                	ld	s2,0(sp)
    80003b5c:	6105                	addi	sp,sp,32
    80003b5e:	8082                	ret

0000000080003b60 <idup>:
{
    80003b60:	1101                	addi	sp,sp,-32
    80003b62:	ec06                	sd	ra,24(sp)
    80003b64:	e822                	sd	s0,16(sp)
    80003b66:	e426                	sd	s1,8(sp)
    80003b68:	1000                	addi	s0,sp,32
    80003b6a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003b6c:	0001d517          	auipc	a0,0x1d
    80003b70:	20c50513          	addi	a0,a0,524 # 80020d78 <itable>
    80003b74:	ffffd097          	auipc	ra,0xffffd
    80003b78:	060080e7          	jalr	96(ra) # 80000bd4 <acquire>
  ip->ref++;
    80003b7c:	449c                	lw	a5,8(s1)
    80003b7e:	2785                	addiw	a5,a5,1
    80003b80:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003b82:	0001d517          	auipc	a0,0x1d
    80003b86:	1f650513          	addi	a0,a0,502 # 80020d78 <itable>
    80003b8a:	ffffd097          	auipc	ra,0xffffd
    80003b8e:	0fe080e7          	jalr	254(ra) # 80000c88 <release>
}
    80003b92:	8526                	mv	a0,s1
    80003b94:	60e2                	ld	ra,24(sp)
    80003b96:	6442                	ld	s0,16(sp)
    80003b98:	64a2                	ld	s1,8(sp)
    80003b9a:	6105                	addi	sp,sp,32
    80003b9c:	8082                	ret

0000000080003b9e <ilock>:
{
    80003b9e:	1101                	addi	sp,sp,-32
    80003ba0:	ec06                	sd	ra,24(sp)
    80003ba2:	e822                	sd	s0,16(sp)
    80003ba4:	e426                	sd	s1,8(sp)
    80003ba6:	e04a                	sd	s2,0(sp)
    80003ba8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003baa:	c115                	beqz	a0,80003bce <ilock+0x30>
    80003bac:	84aa                	mv	s1,a0
    80003bae:	451c                	lw	a5,8(a0)
    80003bb0:	00f05f63          	blez	a5,80003bce <ilock+0x30>
  acquiresleep(&ip->lock);
    80003bb4:	0541                	addi	a0,a0,16
    80003bb6:	00001097          	auipc	ra,0x1
    80003bba:	ca8080e7          	jalr	-856(ra) # 8000485e <acquiresleep>
  if(ip->valid == 0){
    80003bbe:	40bc                	lw	a5,64(s1)
    80003bc0:	cf99                	beqz	a5,80003bde <ilock+0x40>
}
    80003bc2:	60e2                	ld	ra,24(sp)
    80003bc4:	6442                	ld	s0,16(sp)
    80003bc6:	64a2                	ld	s1,8(sp)
    80003bc8:	6902                	ld	s2,0(sp)
    80003bca:	6105                	addi	sp,sp,32
    80003bcc:	8082                	ret
    panic("ilock");
    80003bce:	00006517          	auipc	a0,0x6
    80003bd2:	b1250513          	addi	a0,a0,-1262 # 800096e0 <syscalls+0x290>
    80003bd6:	ffffd097          	auipc	ra,0xffffd
    80003bda:	968080e7          	jalr	-1688(ra) # 8000053e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003bde:	40dc                	lw	a5,4(s1)
    80003be0:	0047d79b          	srliw	a5,a5,0x4
    80003be4:	0001d597          	auipc	a1,0x1d
    80003be8:	18c5a583          	lw	a1,396(a1) # 80020d70 <sb+0x18>
    80003bec:	9dbd                	addw	a1,a1,a5
    80003bee:	4088                	lw	a0,0(s1)
    80003bf0:	fffff097          	auipc	ra,0xfffff
    80003bf4:	796080e7          	jalr	1942(ra) # 80003386 <bread>
    80003bf8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003bfa:	05850593          	addi	a1,a0,88
    80003bfe:	40dc                	lw	a5,4(s1)
    80003c00:	8bbd                	andi	a5,a5,15
    80003c02:	079a                	slli	a5,a5,0x6
    80003c04:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003c06:	00059783          	lh	a5,0(a1)
    80003c0a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003c0e:	00259783          	lh	a5,2(a1)
    80003c12:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003c16:	00459783          	lh	a5,4(a1)
    80003c1a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003c1e:	00659783          	lh	a5,6(a1)
    80003c22:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003c26:	459c                	lw	a5,8(a1)
    80003c28:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003c2a:	03400613          	li	a2,52
    80003c2e:	05b1                	addi	a1,a1,12
    80003c30:	05048513          	addi	a0,s1,80
    80003c34:	ffffd097          	auipc	ra,0xffffd
    80003c38:	0f8080e7          	jalr	248(ra) # 80000d2c <memmove>
    brelse(bp);
    80003c3c:	854a                	mv	a0,s2
    80003c3e:	00000097          	auipc	ra,0x0
    80003c42:	878080e7          	jalr	-1928(ra) # 800034b6 <brelse>
    ip->valid = 1;
    80003c46:	4785                	li	a5,1
    80003c48:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003c4a:	04449783          	lh	a5,68(s1)
    80003c4e:	fbb5                	bnez	a5,80003bc2 <ilock+0x24>
      panic("ilock: no type");
    80003c50:	00006517          	auipc	a0,0x6
    80003c54:	a9850513          	addi	a0,a0,-1384 # 800096e8 <syscalls+0x298>
    80003c58:	ffffd097          	auipc	ra,0xffffd
    80003c5c:	8e6080e7          	jalr	-1818(ra) # 8000053e <panic>

0000000080003c60 <iunlock>:
{
    80003c60:	1101                	addi	sp,sp,-32
    80003c62:	ec06                	sd	ra,24(sp)
    80003c64:	e822                	sd	s0,16(sp)
    80003c66:	e426                	sd	s1,8(sp)
    80003c68:	e04a                	sd	s2,0(sp)
    80003c6a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003c6c:	c905                	beqz	a0,80003c9c <iunlock+0x3c>
    80003c6e:	84aa                	mv	s1,a0
    80003c70:	01050913          	addi	s2,a0,16
    80003c74:	854a                	mv	a0,s2
    80003c76:	00001097          	auipc	ra,0x1
    80003c7a:	c82080e7          	jalr	-894(ra) # 800048f8 <holdingsleep>
    80003c7e:	cd19                	beqz	a0,80003c9c <iunlock+0x3c>
    80003c80:	449c                	lw	a5,8(s1)
    80003c82:	00f05d63          	blez	a5,80003c9c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003c86:	854a                	mv	a0,s2
    80003c88:	00001097          	auipc	ra,0x1
    80003c8c:	c2c080e7          	jalr	-980(ra) # 800048b4 <releasesleep>
}
    80003c90:	60e2                	ld	ra,24(sp)
    80003c92:	6442                	ld	s0,16(sp)
    80003c94:	64a2                	ld	s1,8(sp)
    80003c96:	6902                	ld	s2,0(sp)
    80003c98:	6105                	addi	sp,sp,32
    80003c9a:	8082                	ret
    panic("iunlock");
    80003c9c:	00006517          	auipc	a0,0x6
    80003ca0:	a5c50513          	addi	a0,a0,-1444 # 800096f8 <syscalls+0x2a8>
    80003ca4:	ffffd097          	auipc	ra,0xffffd
    80003ca8:	89a080e7          	jalr	-1894(ra) # 8000053e <panic>

0000000080003cac <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003cac:	7179                	addi	sp,sp,-48
    80003cae:	f406                	sd	ra,40(sp)
    80003cb0:	f022                	sd	s0,32(sp)
    80003cb2:	ec26                	sd	s1,24(sp)
    80003cb4:	e84a                	sd	s2,16(sp)
    80003cb6:	e44e                	sd	s3,8(sp)
    80003cb8:	e052                	sd	s4,0(sp)
    80003cba:	1800                	addi	s0,sp,48
    80003cbc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003cbe:	05050493          	addi	s1,a0,80
    80003cc2:	08050913          	addi	s2,a0,128
    80003cc6:	a021                	j	80003cce <itrunc+0x22>
    80003cc8:	0491                	addi	s1,s1,4
    80003cca:	01248d63          	beq	s1,s2,80003ce4 <itrunc+0x38>
    if(ip->addrs[i]){
    80003cce:	408c                	lw	a1,0(s1)
    80003cd0:	dde5                	beqz	a1,80003cc8 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003cd2:	0009a503          	lw	a0,0(s3)
    80003cd6:	00000097          	auipc	ra,0x0
    80003cda:	8f6080e7          	jalr	-1802(ra) # 800035cc <bfree>
      ip->addrs[i] = 0;
    80003cde:	0004a023          	sw	zero,0(s1)
    80003ce2:	b7dd                	j	80003cc8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003ce4:	0809a583          	lw	a1,128(s3)
    80003ce8:	e185                	bnez	a1,80003d08 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003cea:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003cee:	854e                	mv	a0,s3
    80003cf0:	00000097          	auipc	ra,0x0
    80003cf4:	de2080e7          	jalr	-542(ra) # 80003ad2 <iupdate>
}
    80003cf8:	70a2                	ld	ra,40(sp)
    80003cfa:	7402                	ld	s0,32(sp)
    80003cfc:	64e2                	ld	s1,24(sp)
    80003cfe:	6942                	ld	s2,16(sp)
    80003d00:	69a2                	ld	s3,8(sp)
    80003d02:	6a02                	ld	s4,0(sp)
    80003d04:	6145                	addi	sp,sp,48
    80003d06:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003d08:	0009a503          	lw	a0,0(s3)
    80003d0c:	fffff097          	auipc	ra,0xfffff
    80003d10:	67a080e7          	jalr	1658(ra) # 80003386 <bread>
    80003d14:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003d16:	05850493          	addi	s1,a0,88
    80003d1a:	45850913          	addi	s2,a0,1112
    80003d1e:	a021                	j	80003d26 <itrunc+0x7a>
    80003d20:	0491                	addi	s1,s1,4
    80003d22:	01248b63          	beq	s1,s2,80003d38 <itrunc+0x8c>
      if(a[j])
    80003d26:	408c                	lw	a1,0(s1)
    80003d28:	dde5                	beqz	a1,80003d20 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003d2a:	0009a503          	lw	a0,0(s3)
    80003d2e:	00000097          	auipc	ra,0x0
    80003d32:	89e080e7          	jalr	-1890(ra) # 800035cc <bfree>
    80003d36:	b7ed                	j	80003d20 <itrunc+0x74>
    brelse(bp);
    80003d38:	8552                	mv	a0,s4
    80003d3a:	fffff097          	auipc	ra,0xfffff
    80003d3e:	77c080e7          	jalr	1916(ra) # 800034b6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003d42:	0809a583          	lw	a1,128(s3)
    80003d46:	0009a503          	lw	a0,0(s3)
    80003d4a:	00000097          	auipc	ra,0x0
    80003d4e:	882080e7          	jalr	-1918(ra) # 800035cc <bfree>
    ip->addrs[NDIRECT] = 0;
    80003d52:	0809a023          	sw	zero,128(s3)
    80003d56:	bf51                	j	80003cea <itrunc+0x3e>

0000000080003d58 <iput>:
{
    80003d58:	1101                	addi	sp,sp,-32
    80003d5a:	ec06                	sd	ra,24(sp)
    80003d5c:	e822                	sd	s0,16(sp)
    80003d5e:	e426                	sd	s1,8(sp)
    80003d60:	e04a                	sd	s2,0(sp)
    80003d62:	1000                	addi	s0,sp,32
    80003d64:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003d66:	0001d517          	auipc	a0,0x1d
    80003d6a:	01250513          	addi	a0,a0,18 # 80020d78 <itable>
    80003d6e:	ffffd097          	auipc	ra,0xffffd
    80003d72:	e66080e7          	jalr	-410(ra) # 80000bd4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003d76:	4498                	lw	a4,8(s1)
    80003d78:	4785                	li	a5,1
    80003d7a:	02f70363          	beq	a4,a5,80003da0 <iput+0x48>
  ip->ref--;
    80003d7e:	449c                	lw	a5,8(s1)
    80003d80:	37fd                	addiw	a5,a5,-1
    80003d82:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003d84:	0001d517          	auipc	a0,0x1d
    80003d88:	ff450513          	addi	a0,a0,-12 # 80020d78 <itable>
    80003d8c:	ffffd097          	auipc	ra,0xffffd
    80003d90:	efc080e7          	jalr	-260(ra) # 80000c88 <release>
}
    80003d94:	60e2                	ld	ra,24(sp)
    80003d96:	6442                	ld	s0,16(sp)
    80003d98:	64a2                	ld	s1,8(sp)
    80003d9a:	6902                	ld	s2,0(sp)
    80003d9c:	6105                	addi	sp,sp,32
    80003d9e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003da0:	40bc                	lw	a5,64(s1)
    80003da2:	dff1                	beqz	a5,80003d7e <iput+0x26>
    80003da4:	04a49783          	lh	a5,74(s1)
    80003da8:	fbf9                	bnez	a5,80003d7e <iput+0x26>
    acquiresleep(&ip->lock);
    80003daa:	01048913          	addi	s2,s1,16
    80003dae:	854a                	mv	a0,s2
    80003db0:	00001097          	auipc	ra,0x1
    80003db4:	aae080e7          	jalr	-1362(ra) # 8000485e <acquiresleep>
    release(&itable.lock);
    80003db8:	0001d517          	auipc	a0,0x1d
    80003dbc:	fc050513          	addi	a0,a0,-64 # 80020d78 <itable>
    80003dc0:	ffffd097          	auipc	ra,0xffffd
    80003dc4:	ec8080e7          	jalr	-312(ra) # 80000c88 <release>
    itrunc(ip);
    80003dc8:	8526                	mv	a0,s1
    80003dca:	00000097          	auipc	ra,0x0
    80003dce:	ee2080e7          	jalr	-286(ra) # 80003cac <itrunc>
    ip->type = 0;
    80003dd2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003dd6:	8526                	mv	a0,s1
    80003dd8:	00000097          	auipc	ra,0x0
    80003ddc:	cfa080e7          	jalr	-774(ra) # 80003ad2 <iupdate>
    ip->valid = 0;
    80003de0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003de4:	854a                	mv	a0,s2
    80003de6:	00001097          	auipc	ra,0x1
    80003dea:	ace080e7          	jalr	-1330(ra) # 800048b4 <releasesleep>
    acquire(&itable.lock);
    80003dee:	0001d517          	auipc	a0,0x1d
    80003df2:	f8a50513          	addi	a0,a0,-118 # 80020d78 <itable>
    80003df6:	ffffd097          	auipc	ra,0xffffd
    80003dfa:	dde080e7          	jalr	-546(ra) # 80000bd4 <acquire>
    80003dfe:	b741                	j	80003d7e <iput+0x26>

0000000080003e00 <iunlockput>:
{
    80003e00:	1101                	addi	sp,sp,-32
    80003e02:	ec06                	sd	ra,24(sp)
    80003e04:	e822                	sd	s0,16(sp)
    80003e06:	e426                	sd	s1,8(sp)
    80003e08:	1000                	addi	s0,sp,32
    80003e0a:	84aa                	mv	s1,a0
  iunlock(ip);
    80003e0c:	00000097          	auipc	ra,0x0
    80003e10:	e54080e7          	jalr	-428(ra) # 80003c60 <iunlock>
  iput(ip);
    80003e14:	8526                	mv	a0,s1
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	f42080e7          	jalr	-190(ra) # 80003d58 <iput>
}
    80003e1e:	60e2                	ld	ra,24(sp)
    80003e20:	6442                	ld	s0,16(sp)
    80003e22:	64a2                	ld	s1,8(sp)
    80003e24:	6105                	addi	sp,sp,32
    80003e26:	8082                	ret

0000000080003e28 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003e28:	1141                	addi	sp,sp,-16
    80003e2a:	e422                	sd	s0,8(sp)
    80003e2c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003e2e:	411c                	lw	a5,0(a0)
    80003e30:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003e32:	415c                	lw	a5,4(a0)
    80003e34:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003e36:	04451783          	lh	a5,68(a0)
    80003e3a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003e3e:	04a51783          	lh	a5,74(a0)
    80003e42:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003e46:	04c56783          	lwu	a5,76(a0)
    80003e4a:	e99c                	sd	a5,16(a1)
}
    80003e4c:	6422                	ld	s0,8(sp)
    80003e4e:	0141                	addi	sp,sp,16
    80003e50:	8082                	ret

0000000080003e52 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003e52:	457c                	lw	a5,76(a0)
    80003e54:	0ed7e963          	bltu	a5,a3,80003f46 <readi+0xf4>
{
    80003e58:	7159                	addi	sp,sp,-112
    80003e5a:	f486                	sd	ra,104(sp)
    80003e5c:	f0a2                	sd	s0,96(sp)
    80003e5e:	eca6                	sd	s1,88(sp)
    80003e60:	e8ca                	sd	s2,80(sp)
    80003e62:	e4ce                	sd	s3,72(sp)
    80003e64:	e0d2                	sd	s4,64(sp)
    80003e66:	fc56                	sd	s5,56(sp)
    80003e68:	f85a                	sd	s6,48(sp)
    80003e6a:	f45e                	sd	s7,40(sp)
    80003e6c:	f062                	sd	s8,32(sp)
    80003e6e:	ec66                	sd	s9,24(sp)
    80003e70:	e86a                	sd	s10,16(sp)
    80003e72:	e46e                	sd	s11,8(sp)
    80003e74:	1880                	addi	s0,sp,112
    80003e76:	8b2a                	mv	s6,a0
    80003e78:	8bae                	mv	s7,a1
    80003e7a:	8a32                	mv	s4,a2
    80003e7c:	84b6                	mv	s1,a3
    80003e7e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003e80:	9f35                	addw	a4,a4,a3
    return 0;
    80003e82:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003e84:	0ad76063          	bltu	a4,a3,80003f24 <readi+0xd2>
  if(off + n > ip->size)
    80003e88:	00e7f463          	bgeu	a5,a4,80003e90 <readi+0x3e>
    n = ip->size - off;
    80003e8c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e90:	0a0a8963          	beqz	s5,80003f42 <readi+0xf0>
    80003e94:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e96:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003e9a:	5c7d                	li	s8,-1
    80003e9c:	a82d                	j	80003ed6 <readi+0x84>
    80003e9e:	020d1d93          	slli	s11,s10,0x20
    80003ea2:	020ddd93          	srli	s11,s11,0x20
    80003ea6:	05890613          	addi	a2,s2,88
    80003eaa:	86ee                	mv	a3,s11
    80003eac:	963a                	add	a2,a2,a4
    80003eae:	85d2                	mv	a1,s4
    80003eb0:	855e                	mv	a0,s7
    80003eb2:	ffffe097          	auipc	ra,0xffffe
    80003eb6:	678080e7          	jalr	1656(ra) # 8000252a <either_copyout>
    80003eba:	05850d63          	beq	a0,s8,80003f14 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ebe:	854a                	mv	a0,s2
    80003ec0:	fffff097          	auipc	ra,0xfffff
    80003ec4:	5f6080e7          	jalr	1526(ra) # 800034b6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ec8:	013d09bb          	addw	s3,s10,s3
    80003ecc:	009d04bb          	addw	s1,s10,s1
    80003ed0:	9a6e                	add	s4,s4,s11
    80003ed2:	0559f763          	bgeu	s3,s5,80003f20 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003ed6:	00a4d59b          	srliw	a1,s1,0xa
    80003eda:	855a                	mv	a0,s6
    80003edc:	00000097          	auipc	ra,0x0
    80003ee0:	89e080e7          	jalr	-1890(ra) # 8000377a <bmap>
    80003ee4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003ee8:	cd85                	beqz	a1,80003f20 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003eea:	000b2503          	lw	a0,0(s6)
    80003eee:	fffff097          	auipc	ra,0xfffff
    80003ef2:	498080e7          	jalr	1176(ra) # 80003386 <bread>
    80003ef6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ef8:	3ff4f713          	andi	a4,s1,1023
    80003efc:	40ec87bb          	subw	a5,s9,a4
    80003f00:	413a86bb          	subw	a3,s5,s3
    80003f04:	8d3e                	mv	s10,a5
    80003f06:	2781                	sext.w	a5,a5
    80003f08:	0006861b          	sext.w	a2,a3
    80003f0c:	f8f679e3          	bgeu	a2,a5,80003e9e <readi+0x4c>
    80003f10:	8d36                	mv	s10,a3
    80003f12:	b771                	j	80003e9e <readi+0x4c>
      brelse(bp);
    80003f14:	854a                	mv	a0,s2
    80003f16:	fffff097          	auipc	ra,0xfffff
    80003f1a:	5a0080e7          	jalr	1440(ra) # 800034b6 <brelse>
      tot = -1;
    80003f1e:	59fd                	li	s3,-1
  }
  return tot;
    80003f20:	0009851b          	sext.w	a0,s3
}
    80003f24:	70a6                	ld	ra,104(sp)
    80003f26:	7406                	ld	s0,96(sp)
    80003f28:	64e6                	ld	s1,88(sp)
    80003f2a:	6946                	ld	s2,80(sp)
    80003f2c:	69a6                	ld	s3,72(sp)
    80003f2e:	6a06                	ld	s4,64(sp)
    80003f30:	7ae2                	ld	s5,56(sp)
    80003f32:	7b42                	ld	s6,48(sp)
    80003f34:	7ba2                	ld	s7,40(sp)
    80003f36:	7c02                	ld	s8,32(sp)
    80003f38:	6ce2                	ld	s9,24(sp)
    80003f3a:	6d42                	ld	s10,16(sp)
    80003f3c:	6da2                	ld	s11,8(sp)
    80003f3e:	6165                	addi	sp,sp,112
    80003f40:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f42:	89d6                	mv	s3,s5
    80003f44:	bff1                	j	80003f20 <readi+0xce>
    return 0;
    80003f46:	4501                	li	a0,0
}
    80003f48:	8082                	ret

0000000080003f4a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f4a:	457c                	lw	a5,76(a0)
    80003f4c:	10d7e863          	bltu	a5,a3,8000405c <writei+0x112>
{
    80003f50:	7159                	addi	sp,sp,-112
    80003f52:	f486                	sd	ra,104(sp)
    80003f54:	f0a2                	sd	s0,96(sp)
    80003f56:	eca6                	sd	s1,88(sp)
    80003f58:	e8ca                	sd	s2,80(sp)
    80003f5a:	e4ce                	sd	s3,72(sp)
    80003f5c:	e0d2                	sd	s4,64(sp)
    80003f5e:	fc56                	sd	s5,56(sp)
    80003f60:	f85a                	sd	s6,48(sp)
    80003f62:	f45e                	sd	s7,40(sp)
    80003f64:	f062                	sd	s8,32(sp)
    80003f66:	ec66                	sd	s9,24(sp)
    80003f68:	e86a                	sd	s10,16(sp)
    80003f6a:	e46e                	sd	s11,8(sp)
    80003f6c:	1880                	addi	s0,sp,112
    80003f6e:	8aaa                	mv	s5,a0
    80003f70:	8bae                	mv	s7,a1
    80003f72:	8a32                	mv	s4,a2
    80003f74:	8936                	mv	s2,a3
    80003f76:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003f78:	00e687bb          	addw	a5,a3,a4
    80003f7c:	0ed7e263          	bltu	a5,a3,80004060 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003f80:	00043737          	lui	a4,0x43
    80003f84:	0ef76063          	bltu	a4,a5,80004064 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f88:	0c0b0863          	beqz	s6,80004058 <writei+0x10e>
    80003f8c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f8e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003f92:	5c7d                	li	s8,-1
    80003f94:	a091                	j	80003fd8 <writei+0x8e>
    80003f96:	020d1d93          	slli	s11,s10,0x20
    80003f9a:	020ddd93          	srli	s11,s11,0x20
    80003f9e:	05848513          	addi	a0,s1,88
    80003fa2:	86ee                	mv	a3,s11
    80003fa4:	8652                	mv	a2,s4
    80003fa6:	85de                	mv	a1,s7
    80003fa8:	953a                	add	a0,a0,a4
    80003faa:	ffffe097          	auipc	ra,0xffffe
    80003fae:	5d6080e7          	jalr	1494(ra) # 80002580 <either_copyin>
    80003fb2:	07850263          	beq	a0,s8,80004016 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003fb6:	8526                	mv	a0,s1
    80003fb8:	00000097          	auipc	ra,0x0
    80003fbc:	788080e7          	jalr	1928(ra) # 80004740 <log_write>
    brelse(bp);
    80003fc0:	8526                	mv	a0,s1
    80003fc2:	fffff097          	auipc	ra,0xfffff
    80003fc6:	4f4080e7          	jalr	1268(ra) # 800034b6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003fca:	013d09bb          	addw	s3,s10,s3
    80003fce:	012d093b          	addw	s2,s10,s2
    80003fd2:	9a6e                	add	s4,s4,s11
    80003fd4:	0569f663          	bgeu	s3,s6,80004020 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003fd8:	00a9559b          	srliw	a1,s2,0xa
    80003fdc:	8556                	mv	a0,s5
    80003fde:	fffff097          	auipc	ra,0xfffff
    80003fe2:	79c080e7          	jalr	1948(ra) # 8000377a <bmap>
    80003fe6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003fea:	c99d                	beqz	a1,80004020 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003fec:	000aa503          	lw	a0,0(s5)
    80003ff0:	fffff097          	auipc	ra,0xfffff
    80003ff4:	396080e7          	jalr	918(ra) # 80003386 <bread>
    80003ff8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ffa:	3ff97713          	andi	a4,s2,1023
    80003ffe:	40ec87bb          	subw	a5,s9,a4
    80004002:	413b06bb          	subw	a3,s6,s3
    80004006:	8d3e                	mv	s10,a5
    80004008:	2781                	sext.w	a5,a5
    8000400a:	0006861b          	sext.w	a2,a3
    8000400e:	f8f674e3          	bgeu	a2,a5,80003f96 <writei+0x4c>
    80004012:	8d36                	mv	s10,a3
    80004014:	b749                	j	80003f96 <writei+0x4c>
      brelse(bp);
    80004016:	8526                	mv	a0,s1
    80004018:	fffff097          	auipc	ra,0xfffff
    8000401c:	49e080e7          	jalr	1182(ra) # 800034b6 <brelse>
  }

  if(off > ip->size)
    80004020:	04caa783          	lw	a5,76(s5)
    80004024:	0127f463          	bgeu	a5,s2,8000402c <writei+0xe2>
    ip->size = off;
    80004028:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000402c:	8556                	mv	a0,s5
    8000402e:	00000097          	auipc	ra,0x0
    80004032:	aa4080e7          	jalr	-1372(ra) # 80003ad2 <iupdate>

  return tot;
    80004036:	0009851b          	sext.w	a0,s3
}
    8000403a:	70a6                	ld	ra,104(sp)
    8000403c:	7406                	ld	s0,96(sp)
    8000403e:	64e6                	ld	s1,88(sp)
    80004040:	6946                	ld	s2,80(sp)
    80004042:	69a6                	ld	s3,72(sp)
    80004044:	6a06                	ld	s4,64(sp)
    80004046:	7ae2                	ld	s5,56(sp)
    80004048:	7b42                	ld	s6,48(sp)
    8000404a:	7ba2                	ld	s7,40(sp)
    8000404c:	7c02                	ld	s8,32(sp)
    8000404e:	6ce2                	ld	s9,24(sp)
    80004050:	6d42                	ld	s10,16(sp)
    80004052:	6da2                	ld	s11,8(sp)
    80004054:	6165                	addi	sp,sp,112
    80004056:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004058:	89da                	mv	s3,s6
    8000405a:	bfc9                	j	8000402c <writei+0xe2>
    return -1;
    8000405c:	557d                	li	a0,-1
}
    8000405e:	8082                	ret
    return -1;
    80004060:	557d                	li	a0,-1
    80004062:	bfe1                	j	8000403a <writei+0xf0>
    return -1;
    80004064:	557d                	li	a0,-1
    80004066:	bfd1                	j	8000403a <writei+0xf0>

0000000080004068 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004068:	1141                	addi	sp,sp,-16
    8000406a:	e406                	sd	ra,8(sp)
    8000406c:	e022                	sd	s0,0(sp)
    8000406e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004070:	4639                	li	a2,14
    80004072:	ffffd097          	auipc	ra,0xffffd
    80004076:	d2e080e7          	jalr	-722(ra) # 80000da0 <strncmp>
}
    8000407a:	60a2                	ld	ra,8(sp)
    8000407c:	6402                	ld	s0,0(sp)
    8000407e:	0141                	addi	sp,sp,16
    80004080:	8082                	ret

0000000080004082 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004082:	7139                	addi	sp,sp,-64
    80004084:	fc06                	sd	ra,56(sp)
    80004086:	f822                	sd	s0,48(sp)
    80004088:	f426                	sd	s1,40(sp)
    8000408a:	f04a                	sd	s2,32(sp)
    8000408c:	ec4e                	sd	s3,24(sp)
    8000408e:	e852                	sd	s4,16(sp)
    80004090:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004092:	04451703          	lh	a4,68(a0)
    80004096:	4785                	li	a5,1
    80004098:	00f71a63          	bne	a4,a5,800040ac <dirlookup+0x2a>
    8000409c:	892a                	mv	s2,a0
    8000409e:	89ae                	mv	s3,a1
    800040a0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800040a2:	457c                	lw	a5,76(a0)
    800040a4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800040a6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040a8:	e79d                	bnez	a5,800040d6 <dirlookup+0x54>
    800040aa:	a8a5                	j	80004122 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800040ac:	00005517          	auipc	a0,0x5
    800040b0:	65450513          	addi	a0,a0,1620 # 80009700 <syscalls+0x2b0>
    800040b4:	ffffc097          	auipc	ra,0xffffc
    800040b8:	48a080e7          	jalr	1162(ra) # 8000053e <panic>
      panic("dirlookup read");
    800040bc:	00005517          	auipc	a0,0x5
    800040c0:	65c50513          	addi	a0,a0,1628 # 80009718 <syscalls+0x2c8>
    800040c4:	ffffc097          	auipc	ra,0xffffc
    800040c8:	47a080e7          	jalr	1146(ra) # 8000053e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040cc:	24c1                	addiw	s1,s1,16
    800040ce:	04c92783          	lw	a5,76(s2)
    800040d2:	04f4f763          	bgeu	s1,a5,80004120 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040d6:	4741                	li	a4,16
    800040d8:	86a6                	mv	a3,s1
    800040da:	fc040613          	addi	a2,s0,-64
    800040de:	4581                	li	a1,0
    800040e0:	854a                	mv	a0,s2
    800040e2:	00000097          	auipc	ra,0x0
    800040e6:	d70080e7          	jalr	-656(ra) # 80003e52 <readi>
    800040ea:	47c1                	li	a5,16
    800040ec:	fcf518e3          	bne	a0,a5,800040bc <dirlookup+0x3a>
    if(de.inum == 0)
    800040f0:	fc045783          	lhu	a5,-64(s0)
    800040f4:	dfe1                	beqz	a5,800040cc <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800040f6:	fc240593          	addi	a1,s0,-62
    800040fa:	854e                	mv	a0,s3
    800040fc:	00000097          	auipc	ra,0x0
    80004100:	f6c080e7          	jalr	-148(ra) # 80004068 <namecmp>
    80004104:	f561                	bnez	a0,800040cc <dirlookup+0x4a>
      if(poff)
    80004106:	000a0463          	beqz	s4,8000410e <dirlookup+0x8c>
        *poff = off;
    8000410a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000410e:	fc045583          	lhu	a1,-64(s0)
    80004112:	00092503          	lw	a0,0(s2)
    80004116:	fffff097          	auipc	ra,0xfffff
    8000411a:	74e080e7          	jalr	1870(ra) # 80003864 <iget>
    8000411e:	a011                	j	80004122 <dirlookup+0xa0>
  return 0;
    80004120:	4501                	li	a0,0
}
    80004122:	70e2                	ld	ra,56(sp)
    80004124:	7442                	ld	s0,48(sp)
    80004126:	74a2                	ld	s1,40(sp)
    80004128:	7902                	ld	s2,32(sp)
    8000412a:	69e2                	ld	s3,24(sp)
    8000412c:	6a42                	ld	s4,16(sp)
    8000412e:	6121                	addi	sp,sp,64
    80004130:	8082                	ret

0000000080004132 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004132:	711d                	addi	sp,sp,-96
    80004134:	ec86                	sd	ra,88(sp)
    80004136:	e8a2                	sd	s0,80(sp)
    80004138:	e4a6                	sd	s1,72(sp)
    8000413a:	e0ca                	sd	s2,64(sp)
    8000413c:	fc4e                	sd	s3,56(sp)
    8000413e:	f852                	sd	s4,48(sp)
    80004140:	f456                	sd	s5,40(sp)
    80004142:	f05a                	sd	s6,32(sp)
    80004144:	ec5e                	sd	s7,24(sp)
    80004146:	e862                	sd	s8,16(sp)
    80004148:	e466                	sd	s9,8(sp)
    8000414a:	e06a                	sd	s10,0(sp)
    8000414c:	1080                	addi	s0,sp,96
    8000414e:	84aa                	mv	s1,a0
    80004150:	8b2e                	mv	s6,a1
    80004152:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004154:	00054703          	lbu	a4,0(a0)
    80004158:	02f00793          	li	a5,47
    8000415c:	02f70363          	beq	a4,a5,80004182 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004160:	ffffe097          	auipc	ra,0xffffe
    80004164:	84a080e7          	jalr	-1974(ra) # 800019aa <myproc>
    80004168:	15053503          	ld	a0,336(a0)
    8000416c:	00000097          	auipc	ra,0x0
    80004170:	9f4080e7          	jalr	-1548(ra) # 80003b60 <idup>
    80004174:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004176:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000417a:	4cb5                	li	s9,13
  len = path - s;
    8000417c:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000417e:	4c05                	li	s8,1
    80004180:	a87d                	j	8000423e <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80004182:	4585                	li	a1,1
    80004184:	4505                	li	a0,1
    80004186:	fffff097          	auipc	ra,0xfffff
    8000418a:	6de080e7          	jalr	1758(ra) # 80003864 <iget>
    8000418e:	8a2a                	mv	s4,a0
    80004190:	b7dd                	j	80004176 <namex+0x44>
      iunlockput(ip);
    80004192:	8552                	mv	a0,s4
    80004194:	00000097          	auipc	ra,0x0
    80004198:	c6c080e7          	jalr	-916(ra) # 80003e00 <iunlockput>
      return 0;
    8000419c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000419e:	8552                	mv	a0,s4
    800041a0:	60e6                	ld	ra,88(sp)
    800041a2:	6446                	ld	s0,80(sp)
    800041a4:	64a6                	ld	s1,72(sp)
    800041a6:	6906                	ld	s2,64(sp)
    800041a8:	79e2                	ld	s3,56(sp)
    800041aa:	7a42                	ld	s4,48(sp)
    800041ac:	7aa2                	ld	s5,40(sp)
    800041ae:	7b02                	ld	s6,32(sp)
    800041b0:	6be2                	ld	s7,24(sp)
    800041b2:	6c42                	ld	s8,16(sp)
    800041b4:	6ca2                	ld	s9,8(sp)
    800041b6:	6d02                	ld	s10,0(sp)
    800041b8:	6125                	addi	sp,sp,96
    800041ba:	8082                	ret
      iunlock(ip);
    800041bc:	8552                	mv	a0,s4
    800041be:	00000097          	auipc	ra,0x0
    800041c2:	aa2080e7          	jalr	-1374(ra) # 80003c60 <iunlock>
      return ip;
    800041c6:	bfe1                	j	8000419e <namex+0x6c>
      iunlockput(ip);
    800041c8:	8552                	mv	a0,s4
    800041ca:	00000097          	auipc	ra,0x0
    800041ce:	c36080e7          	jalr	-970(ra) # 80003e00 <iunlockput>
      return 0;
    800041d2:	8a4e                	mv	s4,s3
    800041d4:	b7e9                	j	8000419e <namex+0x6c>
  len = path - s;
    800041d6:	40998633          	sub	a2,s3,s1
    800041da:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800041de:	09acd863          	bge	s9,s10,8000426e <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800041e2:	4639                	li	a2,14
    800041e4:	85a6                	mv	a1,s1
    800041e6:	8556                	mv	a0,s5
    800041e8:	ffffd097          	auipc	ra,0xffffd
    800041ec:	b44080e7          	jalr	-1212(ra) # 80000d2c <memmove>
    800041f0:	84ce                	mv	s1,s3
  while(*path == '/')
    800041f2:	0004c783          	lbu	a5,0(s1)
    800041f6:	01279763          	bne	a5,s2,80004204 <namex+0xd2>
    path++;
    800041fa:	0485                	addi	s1,s1,1
  while(*path == '/')
    800041fc:	0004c783          	lbu	a5,0(s1)
    80004200:	ff278de3          	beq	a5,s2,800041fa <namex+0xc8>
    ilock(ip);
    80004204:	8552                	mv	a0,s4
    80004206:	00000097          	auipc	ra,0x0
    8000420a:	998080e7          	jalr	-1640(ra) # 80003b9e <ilock>
    if(ip->type != T_DIR){
    8000420e:	044a1783          	lh	a5,68(s4)
    80004212:	f98790e3          	bne	a5,s8,80004192 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80004216:	000b0563          	beqz	s6,80004220 <namex+0xee>
    8000421a:	0004c783          	lbu	a5,0(s1)
    8000421e:	dfd9                	beqz	a5,800041bc <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004220:	865e                	mv	a2,s7
    80004222:	85d6                	mv	a1,s5
    80004224:	8552                	mv	a0,s4
    80004226:	00000097          	auipc	ra,0x0
    8000422a:	e5c080e7          	jalr	-420(ra) # 80004082 <dirlookup>
    8000422e:	89aa                	mv	s3,a0
    80004230:	dd41                	beqz	a0,800041c8 <namex+0x96>
    iunlockput(ip);
    80004232:	8552                	mv	a0,s4
    80004234:	00000097          	auipc	ra,0x0
    80004238:	bcc080e7          	jalr	-1076(ra) # 80003e00 <iunlockput>
    ip = next;
    8000423c:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000423e:	0004c783          	lbu	a5,0(s1)
    80004242:	01279763          	bne	a5,s2,80004250 <namex+0x11e>
    path++;
    80004246:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004248:	0004c783          	lbu	a5,0(s1)
    8000424c:	ff278de3          	beq	a5,s2,80004246 <namex+0x114>
  if(*path == 0)
    80004250:	cb9d                	beqz	a5,80004286 <namex+0x154>
  while(*path != '/' && *path != 0)
    80004252:	0004c783          	lbu	a5,0(s1)
    80004256:	89a6                	mv	s3,s1
  len = path - s;
    80004258:	8d5e                	mv	s10,s7
    8000425a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000425c:	01278963          	beq	a5,s2,8000426e <namex+0x13c>
    80004260:	dbbd                	beqz	a5,800041d6 <namex+0xa4>
    path++;
    80004262:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80004264:	0009c783          	lbu	a5,0(s3)
    80004268:	ff279ce3          	bne	a5,s2,80004260 <namex+0x12e>
    8000426c:	b7ad                	j	800041d6 <namex+0xa4>
    memmove(name, s, len);
    8000426e:	2601                	sext.w	a2,a2
    80004270:	85a6                	mv	a1,s1
    80004272:	8556                	mv	a0,s5
    80004274:	ffffd097          	auipc	ra,0xffffd
    80004278:	ab8080e7          	jalr	-1352(ra) # 80000d2c <memmove>
    name[len] = 0;
    8000427c:	9d56                	add	s10,s10,s5
    8000427e:	000d0023          	sb	zero,0(s10)
    80004282:	84ce                	mv	s1,s3
    80004284:	b7bd                	j	800041f2 <namex+0xc0>
  if(nameiparent){
    80004286:	f00b0ce3          	beqz	s6,8000419e <namex+0x6c>
    iput(ip);
    8000428a:	8552                	mv	a0,s4
    8000428c:	00000097          	auipc	ra,0x0
    80004290:	acc080e7          	jalr	-1332(ra) # 80003d58 <iput>
    return 0;
    80004294:	4a01                	li	s4,0
    80004296:	b721                	j	8000419e <namex+0x6c>

0000000080004298 <dirlink>:
{
    80004298:	7139                	addi	sp,sp,-64
    8000429a:	fc06                	sd	ra,56(sp)
    8000429c:	f822                	sd	s0,48(sp)
    8000429e:	f426                	sd	s1,40(sp)
    800042a0:	f04a                	sd	s2,32(sp)
    800042a2:	ec4e                	sd	s3,24(sp)
    800042a4:	e852                	sd	s4,16(sp)
    800042a6:	0080                	addi	s0,sp,64
    800042a8:	892a                	mv	s2,a0
    800042aa:	8a2e                	mv	s4,a1
    800042ac:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800042ae:	4601                	li	a2,0
    800042b0:	00000097          	auipc	ra,0x0
    800042b4:	dd2080e7          	jalr	-558(ra) # 80004082 <dirlookup>
    800042b8:	e93d                	bnez	a0,8000432e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800042ba:	04c92483          	lw	s1,76(s2)
    800042be:	c49d                	beqz	s1,800042ec <dirlink+0x54>
    800042c0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042c2:	4741                	li	a4,16
    800042c4:	86a6                	mv	a3,s1
    800042c6:	fc040613          	addi	a2,s0,-64
    800042ca:	4581                	li	a1,0
    800042cc:	854a                	mv	a0,s2
    800042ce:	00000097          	auipc	ra,0x0
    800042d2:	b84080e7          	jalr	-1148(ra) # 80003e52 <readi>
    800042d6:	47c1                	li	a5,16
    800042d8:	06f51163          	bne	a0,a5,8000433a <dirlink+0xa2>
    if(de.inum == 0)
    800042dc:	fc045783          	lhu	a5,-64(s0)
    800042e0:	c791                	beqz	a5,800042ec <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800042e2:	24c1                	addiw	s1,s1,16
    800042e4:	04c92783          	lw	a5,76(s2)
    800042e8:	fcf4ede3          	bltu	s1,a5,800042c2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800042ec:	4639                	li	a2,14
    800042ee:	85d2                	mv	a1,s4
    800042f0:	fc240513          	addi	a0,s0,-62
    800042f4:	ffffd097          	auipc	ra,0xffffd
    800042f8:	ae8080e7          	jalr	-1304(ra) # 80000ddc <strncpy>
  de.inum = inum;
    800042fc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004300:	4741                	li	a4,16
    80004302:	86a6                	mv	a3,s1
    80004304:	fc040613          	addi	a2,s0,-64
    80004308:	4581                	li	a1,0
    8000430a:	854a                	mv	a0,s2
    8000430c:	00000097          	auipc	ra,0x0
    80004310:	c3e080e7          	jalr	-962(ra) # 80003f4a <writei>
    80004314:	1541                	addi	a0,a0,-16
    80004316:	00a03533          	snez	a0,a0
    8000431a:	40a00533          	neg	a0,a0
}
    8000431e:	70e2                	ld	ra,56(sp)
    80004320:	7442                	ld	s0,48(sp)
    80004322:	74a2                	ld	s1,40(sp)
    80004324:	7902                	ld	s2,32(sp)
    80004326:	69e2                	ld	s3,24(sp)
    80004328:	6a42                	ld	s4,16(sp)
    8000432a:	6121                	addi	sp,sp,64
    8000432c:	8082                	ret
    iput(ip);
    8000432e:	00000097          	auipc	ra,0x0
    80004332:	a2a080e7          	jalr	-1494(ra) # 80003d58 <iput>
    return -1;
    80004336:	557d                	li	a0,-1
    80004338:	b7dd                	j	8000431e <dirlink+0x86>
      panic("dirlink read");
    8000433a:	00005517          	auipc	a0,0x5
    8000433e:	3ee50513          	addi	a0,a0,1006 # 80009728 <syscalls+0x2d8>
    80004342:	ffffc097          	auipc	ra,0xffffc
    80004346:	1fc080e7          	jalr	508(ra) # 8000053e <panic>

000000008000434a <namei>:

struct inode*
namei(char *path)
{
    8000434a:	1101                	addi	sp,sp,-32
    8000434c:	ec06                	sd	ra,24(sp)
    8000434e:	e822                	sd	s0,16(sp)
    80004350:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004352:	fe040613          	addi	a2,s0,-32
    80004356:	4581                	li	a1,0
    80004358:	00000097          	auipc	ra,0x0
    8000435c:	dda080e7          	jalr	-550(ra) # 80004132 <namex>
}
    80004360:	60e2                	ld	ra,24(sp)
    80004362:	6442                	ld	s0,16(sp)
    80004364:	6105                	addi	sp,sp,32
    80004366:	8082                	ret

0000000080004368 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004368:	1141                	addi	sp,sp,-16
    8000436a:	e406                	sd	ra,8(sp)
    8000436c:	e022                	sd	s0,0(sp)
    8000436e:	0800                	addi	s0,sp,16
    80004370:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004372:	4585                	li	a1,1
    80004374:	00000097          	auipc	ra,0x0
    80004378:	dbe080e7          	jalr	-578(ra) # 80004132 <namex>
}
    8000437c:	60a2                	ld	ra,8(sp)
    8000437e:	6402                	ld	s0,0(sp)
    80004380:	0141                	addi	sp,sp,16
    80004382:	8082                	ret

0000000080004384 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004384:	1101                	addi	sp,sp,-32
    80004386:	ec06                	sd	ra,24(sp)
    80004388:	e822                	sd	s0,16(sp)
    8000438a:	e426                	sd	s1,8(sp)
    8000438c:	e04a                	sd	s2,0(sp)
    8000438e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004390:	0001e917          	auipc	s2,0x1e
    80004394:	49090913          	addi	s2,s2,1168 # 80022820 <log>
    80004398:	01892583          	lw	a1,24(s2)
    8000439c:	02892503          	lw	a0,40(s2)
    800043a0:	fffff097          	auipc	ra,0xfffff
    800043a4:	fe6080e7          	jalr	-26(ra) # 80003386 <bread>
    800043a8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800043aa:	02c92683          	lw	a3,44(s2)
    800043ae:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800043b0:	02d05863          	blez	a3,800043e0 <write_head+0x5c>
    800043b4:	0001e797          	auipc	a5,0x1e
    800043b8:	49c78793          	addi	a5,a5,1180 # 80022850 <log+0x30>
    800043bc:	05c50713          	addi	a4,a0,92
    800043c0:	36fd                	addiw	a3,a3,-1
    800043c2:	02069613          	slli	a2,a3,0x20
    800043c6:	01e65693          	srli	a3,a2,0x1e
    800043ca:	0001e617          	auipc	a2,0x1e
    800043ce:	48a60613          	addi	a2,a2,1162 # 80022854 <log+0x34>
    800043d2:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800043d4:	4390                	lw	a2,0(a5)
    800043d6:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800043d8:	0791                	addi	a5,a5,4
    800043da:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800043dc:	fed79ce3          	bne	a5,a3,800043d4 <write_head+0x50>
  }
  bwrite(buf);
    800043e0:	8526                	mv	a0,s1
    800043e2:	fffff097          	auipc	ra,0xfffff
    800043e6:	096080e7          	jalr	150(ra) # 80003478 <bwrite>
  brelse(buf);
    800043ea:	8526                	mv	a0,s1
    800043ec:	fffff097          	auipc	ra,0xfffff
    800043f0:	0ca080e7          	jalr	202(ra) # 800034b6 <brelse>
}
    800043f4:	60e2                	ld	ra,24(sp)
    800043f6:	6442                	ld	s0,16(sp)
    800043f8:	64a2                	ld	s1,8(sp)
    800043fa:	6902                	ld	s2,0(sp)
    800043fc:	6105                	addi	sp,sp,32
    800043fe:	8082                	ret

0000000080004400 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004400:	0001e797          	auipc	a5,0x1e
    80004404:	44c7a783          	lw	a5,1100(a5) # 8002284c <log+0x2c>
    80004408:	0af05d63          	blez	a5,800044c2 <install_trans+0xc2>
{
    8000440c:	7139                	addi	sp,sp,-64
    8000440e:	fc06                	sd	ra,56(sp)
    80004410:	f822                	sd	s0,48(sp)
    80004412:	f426                	sd	s1,40(sp)
    80004414:	f04a                	sd	s2,32(sp)
    80004416:	ec4e                	sd	s3,24(sp)
    80004418:	e852                	sd	s4,16(sp)
    8000441a:	e456                	sd	s5,8(sp)
    8000441c:	e05a                	sd	s6,0(sp)
    8000441e:	0080                	addi	s0,sp,64
    80004420:	8b2a                	mv	s6,a0
    80004422:	0001ea97          	auipc	s5,0x1e
    80004426:	42ea8a93          	addi	s5,s5,1070 # 80022850 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000442a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000442c:	0001e997          	auipc	s3,0x1e
    80004430:	3f498993          	addi	s3,s3,1012 # 80022820 <log>
    80004434:	a00d                	j	80004456 <install_trans+0x56>
    brelse(lbuf);
    80004436:	854a                	mv	a0,s2
    80004438:	fffff097          	auipc	ra,0xfffff
    8000443c:	07e080e7          	jalr	126(ra) # 800034b6 <brelse>
    brelse(dbuf);
    80004440:	8526                	mv	a0,s1
    80004442:	fffff097          	auipc	ra,0xfffff
    80004446:	074080e7          	jalr	116(ra) # 800034b6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000444a:	2a05                	addiw	s4,s4,1
    8000444c:	0a91                	addi	s5,s5,4
    8000444e:	02c9a783          	lw	a5,44(s3)
    80004452:	04fa5e63          	bge	s4,a5,800044ae <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004456:	0189a583          	lw	a1,24(s3)
    8000445a:	014585bb          	addw	a1,a1,s4
    8000445e:	2585                	addiw	a1,a1,1
    80004460:	0289a503          	lw	a0,40(s3)
    80004464:	fffff097          	auipc	ra,0xfffff
    80004468:	f22080e7          	jalr	-222(ra) # 80003386 <bread>
    8000446c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000446e:	000aa583          	lw	a1,0(s5)
    80004472:	0289a503          	lw	a0,40(s3)
    80004476:	fffff097          	auipc	ra,0xfffff
    8000447a:	f10080e7          	jalr	-240(ra) # 80003386 <bread>
    8000447e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004480:	40000613          	li	a2,1024
    80004484:	05890593          	addi	a1,s2,88
    80004488:	05850513          	addi	a0,a0,88
    8000448c:	ffffd097          	auipc	ra,0xffffd
    80004490:	8a0080e7          	jalr	-1888(ra) # 80000d2c <memmove>
    bwrite(dbuf);  // write dst to disk
    80004494:	8526                	mv	a0,s1
    80004496:	fffff097          	auipc	ra,0xfffff
    8000449a:	fe2080e7          	jalr	-30(ra) # 80003478 <bwrite>
    if(recovering == 0)
    8000449e:	f80b1ce3          	bnez	s6,80004436 <install_trans+0x36>
      bunpin(dbuf);
    800044a2:	8526                	mv	a0,s1
    800044a4:	fffff097          	auipc	ra,0xfffff
    800044a8:	0ec080e7          	jalr	236(ra) # 80003590 <bunpin>
    800044ac:	b769                	j	80004436 <install_trans+0x36>
}
    800044ae:	70e2                	ld	ra,56(sp)
    800044b0:	7442                	ld	s0,48(sp)
    800044b2:	74a2                	ld	s1,40(sp)
    800044b4:	7902                	ld	s2,32(sp)
    800044b6:	69e2                	ld	s3,24(sp)
    800044b8:	6a42                	ld	s4,16(sp)
    800044ba:	6aa2                	ld	s5,8(sp)
    800044bc:	6b02                	ld	s6,0(sp)
    800044be:	6121                	addi	sp,sp,64
    800044c0:	8082                	ret
    800044c2:	8082                	ret

00000000800044c4 <initlog>:
{
    800044c4:	7179                	addi	sp,sp,-48
    800044c6:	f406                	sd	ra,40(sp)
    800044c8:	f022                	sd	s0,32(sp)
    800044ca:	ec26                	sd	s1,24(sp)
    800044cc:	e84a                	sd	s2,16(sp)
    800044ce:	e44e                	sd	s3,8(sp)
    800044d0:	1800                	addi	s0,sp,48
    800044d2:	892a                	mv	s2,a0
    800044d4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800044d6:	0001e497          	auipc	s1,0x1e
    800044da:	34a48493          	addi	s1,s1,842 # 80022820 <log>
    800044de:	00005597          	auipc	a1,0x5
    800044e2:	25a58593          	addi	a1,a1,602 # 80009738 <syscalls+0x2e8>
    800044e6:	8526                	mv	a0,s1
    800044e8:	ffffc097          	auipc	ra,0xffffc
    800044ec:	65c080e7          	jalr	1628(ra) # 80000b44 <initlock>
  log.start = sb->logstart;
    800044f0:	0149a583          	lw	a1,20(s3)
    800044f4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800044f6:	0109a783          	lw	a5,16(s3)
    800044fa:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800044fc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004500:	854a                	mv	a0,s2
    80004502:	fffff097          	auipc	ra,0xfffff
    80004506:	e84080e7          	jalr	-380(ra) # 80003386 <bread>
  log.lh.n = lh->n;
    8000450a:	4d34                	lw	a3,88(a0)
    8000450c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000450e:	02d05663          	blez	a3,8000453a <initlog+0x76>
    80004512:	05c50793          	addi	a5,a0,92
    80004516:	0001e717          	auipc	a4,0x1e
    8000451a:	33a70713          	addi	a4,a4,826 # 80022850 <log+0x30>
    8000451e:	36fd                	addiw	a3,a3,-1
    80004520:	02069613          	slli	a2,a3,0x20
    80004524:	01e65693          	srli	a3,a2,0x1e
    80004528:	06050613          	addi	a2,a0,96
    8000452c:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000452e:	4390                	lw	a2,0(a5)
    80004530:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004532:	0791                	addi	a5,a5,4
    80004534:	0711                	addi	a4,a4,4
    80004536:	fed79ce3          	bne	a5,a3,8000452e <initlog+0x6a>
  brelse(buf);
    8000453a:	fffff097          	auipc	ra,0xfffff
    8000453e:	f7c080e7          	jalr	-132(ra) # 800034b6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004542:	4505                	li	a0,1
    80004544:	00000097          	auipc	ra,0x0
    80004548:	ebc080e7          	jalr	-324(ra) # 80004400 <install_trans>
  log.lh.n = 0;
    8000454c:	0001e797          	auipc	a5,0x1e
    80004550:	3007a023          	sw	zero,768(a5) # 8002284c <log+0x2c>
  write_head(); // clear the log
    80004554:	00000097          	auipc	ra,0x0
    80004558:	e30080e7          	jalr	-464(ra) # 80004384 <write_head>
}
    8000455c:	70a2                	ld	ra,40(sp)
    8000455e:	7402                	ld	s0,32(sp)
    80004560:	64e2                	ld	s1,24(sp)
    80004562:	6942                	ld	s2,16(sp)
    80004564:	69a2                	ld	s3,8(sp)
    80004566:	6145                	addi	sp,sp,48
    80004568:	8082                	ret

000000008000456a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000456a:	1101                	addi	sp,sp,-32
    8000456c:	ec06                	sd	ra,24(sp)
    8000456e:	e822                	sd	s0,16(sp)
    80004570:	e426                	sd	s1,8(sp)
    80004572:	e04a                	sd	s2,0(sp)
    80004574:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004576:	0001e517          	auipc	a0,0x1e
    8000457a:	2aa50513          	addi	a0,a0,682 # 80022820 <log>
    8000457e:	ffffc097          	auipc	ra,0xffffc
    80004582:	656080e7          	jalr	1622(ra) # 80000bd4 <acquire>
  while(1){
    if(log.committing){
    80004586:	0001e497          	auipc	s1,0x1e
    8000458a:	29a48493          	addi	s1,s1,666 # 80022820 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000458e:	4979                	li	s2,30
    80004590:	a039                	j	8000459e <begin_op+0x34>
      sleep(&log, &log.lock);
    80004592:	85a6                	mv	a1,s1
    80004594:	8526                	mv	a0,s1
    80004596:	ffffe097          	auipc	ra,0xffffe
    8000459a:	b5c080e7          	jalr	-1188(ra) # 800020f2 <sleep>
    if(log.committing){
    8000459e:	50dc                	lw	a5,36(s1)
    800045a0:	fbed                	bnez	a5,80004592 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800045a2:	5098                	lw	a4,32(s1)
    800045a4:	2705                	addiw	a4,a4,1
    800045a6:	0007069b          	sext.w	a3,a4
    800045aa:	0027179b          	slliw	a5,a4,0x2
    800045ae:	9fb9                	addw	a5,a5,a4
    800045b0:	0017979b          	slliw	a5,a5,0x1
    800045b4:	54d8                	lw	a4,44(s1)
    800045b6:	9fb9                	addw	a5,a5,a4
    800045b8:	00f95963          	bge	s2,a5,800045ca <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800045bc:	85a6                	mv	a1,s1
    800045be:	8526                	mv	a0,s1
    800045c0:	ffffe097          	auipc	ra,0xffffe
    800045c4:	b32080e7          	jalr	-1230(ra) # 800020f2 <sleep>
    800045c8:	bfd9                	j	8000459e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800045ca:	0001e517          	auipc	a0,0x1e
    800045ce:	25650513          	addi	a0,a0,598 # 80022820 <log>
    800045d2:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800045d4:	ffffc097          	auipc	ra,0xffffc
    800045d8:	6b4080e7          	jalr	1716(ra) # 80000c88 <release>
      break;
    }
  }
}
    800045dc:	60e2                	ld	ra,24(sp)
    800045de:	6442                	ld	s0,16(sp)
    800045e0:	64a2                	ld	s1,8(sp)
    800045e2:	6902                	ld	s2,0(sp)
    800045e4:	6105                	addi	sp,sp,32
    800045e6:	8082                	ret

00000000800045e8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800045e8:	7139                	addi	sp,sp,-64
    800045ea:	fc06                	sd	ra,56(sp)
    800045ec:	f822                	sd	s0,48(sp)
    800045ee:	f426                	sd	s1,40(sp)
    800045f0:	f04a                	sd	s2,32(sp)
    800045f2:	ec4e                	sd	s3,24(sp)
    800045f4:	e852                	sd	s4,16(sp)
    800045f6:	e456                	sd	s5,8(sp)
    800045f8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800045fa:	0001e497          	auipc	s1,0x1e
    800045fe:	22648493          	addi	s1,s1,550 # 80022820 <log>
    80004602:	8526                	mv	a0,s1
    80004604:	ffffc097          	auipc	ra,0xffffc
    80004608:	5d0080e7          	jalr	1488(ra) # 80000bd4 <acquire>
  log.outstanding -= 1;
    8000460c:	509c                	lw	a5,32(s1)
    8000460e:	37fd                	addiw	a5,a5,-1
    80004610:	0007891b          	sext.w	s2,a5
    80004614:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004616:	50dc                	lw	a5,36(s1)
    80004618:	e7b9                	bnez	a5,80004666 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000461a:	04091e63          	bnez	s2,80004676 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000461e:	0001e497          	auipc	s1,0x1e
    80004622:	20248493          	addi	s1,s1,514 # 80022820 <log>
    80004626:	4785                	li	a5,1
    80004628:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000462a:	8526                	mv	a0,s1
    8000462c:	ffffc097          	auipc	ra,0xffffc
    80004630:	65c080e7          	jalr	1628(ra) # 80000c88 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004634:	54dc                	lw	a5,44(s1)
    80004636:	06f04763          	bgtz	a5,800046a4 <end_op+0xbc>
    acquire(&log.lock);
    8000463a:	0001e497          	auipc	s1,0x1e
    8000463e:	1e648493          	addi	s1,s1,486 # 80022820 <log>
    80004642:	8526                	mv	a0,s1
    80004644:	ffffc097          	auipc	ra,0xffffc
    80004648:	590080e7          	jalr	1424(ra) # 80000bd4 <acquire>
    log.committing = 0;
    8000464c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004650:	8526                	mv	a0,s1
    80004652:	ffffe097          	auipc	ra,0xffffe
    80004656:	b04080e7          	jalr	-1276(ra) # 80002156 <wakeup>
    release(&log.lock);
    8000465a:	8526                	mv	a0,s1
    8000465c:	ffffc097          	auipc	ra,0xffffc
    80004660:	62c080e7          	jalr	1580(ra) # 80000c88 <release>
}
    80004664:	a03d                	j	80004692 <end_op+0xaa>
    panic("log.committing");
    80004666:	00005517          	auipc	a0,0x5
    8000466a:	0da50513          	addi	a0,a0,218 # 80009740 <syscalls+0x2f0>
    8000466e:	ffffc097          	auipc	ra,0xffffc
    80004672:	ed0080e7          	jalr	-304(ra) # 8000053e <panic>
    wakeup(&log);
    80004676:	0001e497          	auipc	s1,0x1e
    8000467a:	1aa48493          	addi	s1,s1,426 # 80022820 <log>
    8000467e:	8526                	mv	a0,s1
    80004680:	ffffe097          	auipc	ra,0xffffe
    80004684:	ad6080e7          	jalr	-1322(ra) # 80002156 <wakeup>
  release(&log.lock);
    80004688:	8526                	mv	a0,s1
    8000468a:	ffffc097          	auipc	ra,0xffffc
    8000468e:	5fe080e7          	jalr	1534(ra) # 80000c88 <release>
}
    80004692:	70e2                	ld	ra,56(sp)
    80004694:	7442                	ld	s0,48(sp)
    80004696:	74a2                	ld	s1,40(sp)
    80004698:	7902                	ld	s2,32(sp)
    8000469a:	69e2                	ld	s3,24(sp)
    8000469c:	6a42                	ld	s4,16(sp)
    8000469e:	6aa2                	ld	s5,8(sp)
    800046a0:	6121                	addi	sp,sp,64
    800046a2:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800046a4:	0001ea97          	auipc	s5,0x1e
    800046a8:	1aca8a93          	addi	s5,s5,428 # 80022850 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800046ac:	0001ea17          	auipc	s4,0x1e
    800046b0:	174a0a13          	addi	s4,s4,372 # 80022820 <log>
    800046b4:	018a2583          	lw	a1,24(s4)
    800046b8:	012585bb          	addw	a1,a1,s2
    800046bc:	2585                	addiw	a1,a1,1
    800046be:	028a2503          	lw	a0,40(s4)
    800046c2:	fffff097          	auipc	ra,0xfffff
    800046c6:	cc4080e7          	jalr	-828(ra) # 80003386 <bread>
    800046ca:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800046cc:	000aa583          	lw	a1,0(s5)
    800046d0:	028a2503          	lw	a0,40(s4)
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	cb2080e7          	jalr	-846(ra) # 80003386 <bread>
    800046dc:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800046de:	40000613          	li	a2,1024
    800046e2:	05850593          	addi	a1,a0,88
    800046e6:	05848513          	addi	a0,s1,88
    800046ea:	ffffc097          	auipc	ra,0xffffc
    800046ee:	642080e7          	jalr	1602(ra) # 80000d2c <memmove>
    bwrite(to);  // write the log
    800046f2:	8526                	mv	a0,s1
    800046f4:	fffff097          	auipc	ra,0xfffff
    800046f8:	d84080e7          	jalr	-636(ra) # 80003478 <bwrite>
    brelse(from);
    800046fc:	854e                	mv	a0,s3
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	db8080e7          	jalr	-584(ra) # 800034b6 <brelse>
    brelse(to);
    80004706:	8526                	mv	a0,s1
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	dae080e7          	jalr	-594(ra) # 800034b6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004710:	2905                	addiw	s2,s2,1
    80004712:	0a91                	addi	s5,s5,4
    80004714:	02ca2783          	lw	a5,44(s4)
    80004718:	f8f94ee3          	blt	s2,a5,800046b4 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000471c:	00000097          	auipc	ra,0x0
    80004720:	c68080e7          	jalr	-920(ra) # 80004384 <write_head>
    install_trans(0); // Now install writes to home locations
    80004724:	4501                	li	a0,0
    80004726:	00000097          	auipc	ra,0x0
    8000472a:	cda080e7          	jalr	-806(ra) # 80004400 <install_trans>
    log.lh.n = 0;
    8000472e:	0001e797          	auipc	a5,0x1e
    80004732:	1007af23          	sw	zero,286(a5) # 8002284c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004736:	00000097          	auipc	ra,0x0
    8000473a:	c4e080e7          	jalr	-946(ra) # 80004384 <write_head>
    8000473e:	bdf5                	j	8000463a <end_op+0x52>

0000000080004740 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004740:	1101                	addi	sp,sp,-32
    80004742:	ec06                	sd	ra,24(sp)
    80004744:	e822                	sd	s0,16(sp)
    80004746:	e426                	sd	s1,8(sp)
    80004748:	e04a                	sd	s2,0(sp)
    8000474a:	1000                	addi	s0,sp,32
    8000474c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000474e:	0001e917          	auipc	s2,0x1e
    80004752:	0d290913          	addi	s2,s2,210 # 80022820 <log>
    80004756:	854a                	mv	a0,s2
    80004758:	ffffc097          	auipc	ra,0xffffc
    8000475c:	47c080e7          	jalr	1148(ra) # 80000bd4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004760:	02c92603          	lw	a2,44(s2)
    80004764:	47f5                	li	a5,29
    80004766:	06c7c563          	blt	a5,a2,800047d0 <log_write+0x90>
    8000476a:	0001e797          	auipc	a5,0x1e
    8000476e:	0d27a783          	lw	a5,210(a5) # 8002283c <log+0x1c>
    80004772:	37fd                	addiw	a5,a5,-1
    80004774:	04f65e63          	bge	a2,a5,800047d0 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004778:	0001e797          	auipc	a5,0x1e
    8000477c:	0c87a783          	lw	a5,200(a5) # 80022840 <log+0x20>
    80004780:	06f05063          	blez	a5,800047e0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004784:	4781                	li	a5,0
    80004786:	06c05563          	blez	a2,800047f0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000478a:	44cc                	lw	a1,12(s1)
    8000478c:	0001e717          	auipc	a4,0x1e
    80004790:	0c470713          	addi	a4,a4,196 # 80022850 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004794:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004796:	4314                	lw	a3,0(a4)
    80004798:	04b68c63          	beq	a3,a1,800047f0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000479c:	2785                	addiw	a5,a5,1
    8000479e:	0711                	addi	a4,a4,4
    800047a0:	fef61be3          	bne	a2,a5,80004796 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800047a4:	0621                	addi	a2,a2,8
    800047a6:	060a                	slli	a2,a2,0x2
    800047a8:	0001e797          	auipc	a5,0x1e
    800047ac:	07878793          	addi	a5,a5,120 # 80022820 <log>
    800047b0:	97b2                	add	a5,a5,a2
    800047b2:	44d8                	lw	a4,12(s1)
    800047b4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800047b6:	8526                	mv	a0,s1
    800047b8:	fffff097          	auipc	ra,0xfffff
    800047bc:	d9c080e7          	jalr	-612(ra) # 80003554 <bpin>
    log.lh.n++;
    800047c0:	0001e717          	auipc	a4,0x1e
    800047c4:	06070713          	addi	a4,a4,96 # 80022820 <log>
    800047c8:	575c                	lw	a5,44(a4)
    800047ca:	2785                	addiw	a5,a5,1
    800047cc:	d75c                	sw	a5,44(a4)
    800047ce:	a82d                	j	80004808 <log_write+0xc8>
    panic("too big a transaction");
    800047d0:	00005517          	auipc	a0,0x5
    800047d4:	f8050513          	addi	a0,a0,-128 # 80009750 <syscalls+0x300>
    800047d8:	ffffc097          	auipc	ra,0xffffc
    800047dc:	d66080e7          	jalr	-666(ra) # 8000053e <panic>
    panic("log_write outside of trans");
    800047e0:	00005517          	auipc	a0,0x5
    800047e4:	f8850513          	addi	a0,a0,-120 # 80009768 <syscalls+0x318>
    800047e8:	ffffc097          	auipc	ra,0xffffc
    800047ec:	d56080e7          	jalr	-682(ra) # 8000053e <panic>
  log.lh.block[i] = b->blockno;
    800047f0:	00878693          	addi	a3,a5,8
    800047f4:	068a                	slli	a3,a3,0x2
    800047f6:	0001e717          	auipc	a4,0x1e
    800047fa:	02a70713          	addi	a4,a4,42 # 80022820 <log>
    800047fe:	9736                	add	a4,a4,a3
    80004800:	44d4                	lw	a3,12(s1)
    80004802:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004804:	faf609e3          	beq	a2,a5,800047b6 <log_write+0x76>
  }
  release(&log.lock);
    80004808:	0001e517          	auipc	a0,0x1e
    8000480c:	01850513          	addi	a0,a0,24 # 80022820 <log>
    80004810:	ffffc097          	auipc	ra,0xffffc
    80004814:	478080e7          	jalr	1144(ra) # 80000c88 <release>
}
    80004818:	60e2                	ld	ra,24(sp)
    8000481a:	6442                	ld	s0,16(sp)
    8000481c:	64a2                	ld	s1,8(sp)
    8000481e:	6902                	ld	s2,0(sp)
    80004820:	6105                	addi	sp,sp,32
    80004822:	8082                	ret

0000000080004824 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004824:	1101                	addi	sp,sp,-32
    80004826:	ec06                	sd	ra,24(sp)
    80004828:	e822                	sd	s0,16(sp)
    8000482a:	e426                	sd	s1,8(sp)
    8000482c:	e04a                	sd	s2,0(sp)
    8000482e:	1000                	addi	s0,sp,32
    80004830:	84aa                	mv	s1,a0
    80004832:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004834:	00005597          	auipc	a1,0x5
    80004838:	f5458593          	addi	a1,a1,-172 # 80009788 <syscalls+0x338>
    8000483c:	0521                	addi	a0,a0,8
    8000483e:	ffffc097          	auipc	ra,0xffffc
    80004842:	306080e7          	jalr	774(ra) # 80000b44 <initlock>
  lk->name = name;
    80004846:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000484a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000484e:	0204a423          	sw	zero,40(s1)
}
    80004852:	60e2                	ld	ra,24(sp)
    80004854:	6442                	ld	s0,16(sp)
    80004856:	64a2                	ld	s1,8(sp)
    80004858:	6902                	ld	s2,0(sp)
    8000485a:	6105                	addi	sp,sp,32
    8000485c:	8082                	ret

000000008000485e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000485e:	1101                	addi	sp,sp,-32
    80004860:	ec06                	sd	ra,24(sp)
    80004862:	e822                	sd	s0,16(sp)
    80004864:	e426                	sd	s1,8(sp)
    80004866:	e04a                	sd	s2,0(sp)
    80004868:	1000                	addi	s0,sp,32
    8000486a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000486c:	00850913          	addi	s2,a0,8
    80004870:	854a                	mv	a0,s2
    80004872:	ffffc097          	auipc	ra,0xffffc
    80004876:	362080e7          	jalr	866(ra) # 80000bd4 <acquire>
  while (lk->locked) {
    8000487a:	409c                	lw	a5,0(s1)
    8000487c:	cb89                	beqz	a5,8000488e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000487e:	85ca                	mv	a1,s2
    80004880:	8526                	mv	a0,s1
    80004882:	ffffe097          	auipc	ra,0xffffe
    80004886:	870080e7          	jalr	-1936(ra) # 800020f2 <sleep>
  while (lk->locked) {
    8000488a:	409c                	lw	a5,0(s1)
    8000488c:	fbed                	bnez	a5,8000487e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000488e:	4785                	li	a5,1
    80004890:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004892:	ffffd097          	auipc	ra,0xffffd
    80004896:	118080e7          	jalr	280(ra) # 800019aa <myproc>
    8000489a:	591c                	lw	a5,48(a0)
    8000489c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000489e:	854a                	mv	a0,s2
    800048a0:	ffffc097          	auipc	ra,0xffffc
    800048a4:	3e8080e7          	jalr	1000(ra) # 80000c88 <release>
}
    800048a8:	60e2                	ld	ra,24(sp)
    800048aa:	6442                	ld	s0,16(sp)
    800048ac:	64a2                	ld	s1,8(sp)
    800048ae:	6902                	ld	s2,0(sp)
    800048b0:	6105                	addi	sp,sp,32
    800048b2:	8082                	ret

00000000800048b4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800048b4:	1101                	addi	sp,sp,-32
    800048b6:	ec06                	sd	ra,24(sp)
    800048b8:	e822                	sd	s0,16(sp)
    800048ba:	e426                	sd	s1,8(sp)
    800048bc:	e04a                	sd	s2,0(sp)
    800048be:	1000                	addi	s0,sp,32
    800048c0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800048c2:	00850913          	addi	s2,a0,8
    800048c6:	854a                	mv	a0,s2
    800048c8:	ffffc097          	auipc	ra,0xffffc
    800048cc:	30c080e7          	jalr	780(ra) # 80000bd4 <acquire>
  lk->locked = 0;
    800048d0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800048d4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800048d8:	8526                	mv	a0,s1
    800048da:	ffffe097          	auipc	ra,0xffffe
    800048de:	87c080e7          	jalr	-1924(ra) # 80002156 <wakeup>
  release(&lk->lk);
    800048e2:	854a                	mv	a0,s2
    800048e4:	ffffc097          	auipc	ra,0xffffc
    800048e8:	3a4080e7          	jalr	932(ra) # 80000c88 <release>
}
    800048ec:	60e2                	ld	ra,24(sp)
    800048ee:	6442                	ld	s0,16(sp)
    800048f0:	64a2                	ld	s1,8(sp)
    800048f2:	6902                	ld	s2,0(sp)
    800048f4:	6105                	addi	sp,sp,32
    800048f6:	8082                	ret

00000000800048f8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800048f8:	7179                	addi	sp,sp,-48
    800048fa:	f406                	sd	ra,40(sp)
    800048fc:	f022                	sd	s0,32(sp)
    800048fe:	ec26                	sd	s1,24(sp)
    80004900:	e84a                	sd	s2,16(sp)
    80004902:	e44e                	sd	s3,8(sp)
    80004904:	1800                	addi	s0,sp,48
    80004906:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004908:	00850913          	addi	s2,a0,8
    8000490c:	854a                	mv	a0,s2
    8000490e:	ffffc097          	auipc	ra,0xffffc
    80004912:	2c6080e7          	jalr	710(ra) # 80000bd4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004916:	409c                	lw	a5,0(s1)
    80004918:	ef99                	bnez	a5,80004936 <holdingsleep+0x3e>
    8000491a:	4481                	li	s1,0
  release(&lk->lk);
    8000491c:	854a                	mv	a0,s2
    8000491e:	ffffc097          	auipc	ra,0xffffc
    80004922:	36a080e7          	jalr	874(ra) # 80000c88 <release>
  return r;
}
    80004926:	8526                	mv	a0,s1
    80004928:	70a2                	ld	ra,40(sp)
    8000492a:	7402                	ld	s0,32(sp)
    8000492c:	64e2                	ld	s1,24(sp)
    8000492e:	6942                	ld	s2,16(sp)
    80004930:	69a2                	ld	s3,8(sp)
    80004932:	6145                	addi	sp,sp,48
    80004934:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004936:	0284a983          	lw	s3,40(s1)
    8000493a:	ffffd097          	auipc	ra,0xffffd
    8000493e:	070080e7          	jalr	112(ra) # 800019aa <myproc>
    80004942:	5904                	lw	s1,48(a0)
    80004944:	413484b3          	sub	s1,s1,s3
    80004948:	0014b493          	seqz	s1,s1
    8000494c:	bfc1                	j	8000491c <holdingsleep+0x24>

000000008000494e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000494e:	1141                	addi	sp,sp,-16
    80004950:	e406                	sd	ra,8(sp)
    80004952:	e022                	sd	s0,0(sp)
    80004954:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004956:	00005597          	auipc	a1,0x5
    8000495a:	e4258593          	addi	a1,a1,-446 # 80009798 <syscalls+0x348>
    8000495e:	0001e517          	auipc	a0,0x1e
    80004962:	00a50513          	addi	a0,a0,10 # 80022968 <ftable>
    80004966:	ffffc097          	auipc	ra,0xffffc
    8000496a:	1de080e7          	jalr	478(ra) # 80000b44 <initlock>
}
    8000496e:	60a2                	ld	ra,8(sp)
    80004970:	6402                	ld	s0,0(sp)
    80004972:	0141                	addi	sp,sp,16
    80004974:	8082                	ret

0000000080004976 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004976:	1101                	addi	sp,sp,-32
    80004978:	ec06                	sd	ra,24(sp)
    8000497a:	e822                	sd	s0,16(sp)
    8000497c:	e426                	sd	s1,8(sp)
    8000497e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004980:	0001e517          	auipc	a0,0x1e
    80004984:	fe850513          	addi	a0,a0,-24 # 80022968 <ftable>
    80004988:	ffffc097          	auipc	ra,0xffffc
    8000498c:	24c080e7          	jalr	588(ra) # 80000bd4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004990:	0001e497          	auipc	s1,0x1e
    80004994:	ff048493          	addi	s1,s1,-16 # 80022980 <ftable+0x18>
    80004998:	0001f717          	auipc	a4,0x1f
    8000499c:	f8870713          	addi	a4,a4,-120 # 80023920 <disk>
    if(f->ref == 0){
    800049a0:	40dc                	lw	a5,4(s1)
    800049a2:	cf99                	beqz	a5,800049c0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800049a4:	02848493          	addi	s1,s1,40
    800049a8:	fee49ce3          	bne	s1,a4,800049a0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800049ac:	0001e517          	auipc	a0,0x1e
    800049b0:	fbc50513          	addi	a0,a0,-68 # 80022968 <ftable>
    800049b4:	ffffc097          	auipc	ra,0xffffc
    800049b8:	2d4080e7          	jalr	724(ra) # 80000c88 <release>
  return 0;
    800049bc:	4481                	li	s1,0
    800049be:	a819                	j	800049d4 <filealloc+0x5e>
      f->ref = 1;
    800049c0:	4785                	li	a5,1
    800049c2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800049c4:	0001e517          	auipc	a0,0x1e
    800049c8:	fa450513          	addi	a0,a0,-92 # 80022968 <ftable>
    800049cc:	ffffc097          	auipc	ra,0xffffc
    800049d0:	2bc080e7          	jalr	700(ra) # 80000c88 <release>
}
    800049d4:	8526                	mv	a0,s1
    800049d6:	60e2                	ld	ra,24(sp)
    800049d8:	6442                	ld	s0,16(sp)
    800049da:	64a2                	ld	s1,8(sp)
    800049dc:	6105                	addi	sp,sp,32
    800049de:	8082                	ret

00000000800049e0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800049e0:	1101                	addi	sp,sp,-32
    800049e2:	ec06                	sd	ra,24(sp)
    800049e4:	e822                	sd	s0,16(sp)
    800049e6:	e426                	sd	s1,8(sp)
    800049e8:	1000                	addi	s0,sp,32
    800049ea:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800049ec:	0001e517          	auipc	a0,0x1e
    800049f0:	f7c50513          	addi	a0,a0,-132 # 80022968 <ftable>
    800049f4:	ffffc097          	auipc	ra,0xffffc
    800049f8:	1e0080e7          	jalr	480(ra) # 80000bd4 <acquire>
  if(f->ref < 1)
    800049fc:	40dc                	lw	a5,4(s1)
    800049fe:	02f05263          	blez	a5,80004a22 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004a02:	2785                	addiw	a5,a5,1
    80004a04:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004a06:	0001e517          	auipc	a0,0x1e
    80004a0a:	f6250513          	addi	a0,a0,-158 # 80022968 <ftable>
    80004a0e:	ffffc097          	auipc	ra,0xffffc
    80004a12:	27a080e7          	jalr	634(ra) # 80000c88 <release>
  return f;
}
    80004a16:	8526                	mv	a0,s1
    80004a18:	60e2                	ld	ra,24(sp)
    80004a1a:	6442                	ld	s0,16(sp)
    80004a1c:	64a2                	ld	s1,8(sp)
    80004a1e:	6105                	addi	sp,sp,32
    80004a20:	8082                	ret
    panic("filedup");
    80004a22:	00005517          	auipc	a0,0x5
    80004a26:	d7e50513          	addi	a0,a0,-642 # 800097a0 <syscalls+0x350>
    80004a2a:	ffffc097          	auipc	ra,0xffffc
    80004a2e:	b14080e7          	jalr	-1260(ra) # 8000053e <panic>

0000000080004a32 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004a32:	7139                	addi	sp,sp,-64
    80004a34:	fc06                	sd	ra,56(sp)
    80004a36:	f822                	sd	s0,48(sp)
    80004a38:	f426                	sd	s1,40(sp)
    80004a3a:	f04a                	sd	s2,32(sp)
    80004a3c:	ec4e                	sd	s3,24(sp)
    80004a3e:	e852                	sd	s4,16(sp)
    80004a40:	e456                	sd	s5,8(sp)
    80004a42:	0080                	addi	s0,sp,64
    80004a44:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004a46:	0001e517          	auipc	a0,0x1e
    80004a4a:	f2250513          	addi	a0,a0,-222 # 80022968 <ftable>
    80004a4e:	ffffc097          	auipc	ra,0xffffc
    80004a52:	186080e7          	jalr	390(ra) # 80000bd4 <acquire>
  if(f->ref < 1)
    80004a56:	40dc                	lw	a5,4(s1)
    80004a58:	06f05163          	blez	a5,80004aba <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004a5c:	37fd                	addiw	a5,a5,-1
    80004a5e:	0007871b          	sext.w	a4,a5
    80004a62:	c0dc                	sw	a5,4(s1)
    80004a64:	06e04363          	bgtz	a4,80004aca <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004a68:	0004a903          	lw	s2,0(s1)
    80004a6c:	0094ca83          	lbu	s5,9(s1)
    80004a70:	0104ba03          	ld	s4,16(s1)
    80004a74:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004a78:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004a7c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004a80:	0001e517          	auipc	a0,0x1e
    80004a84:	ee850513          	addi	a0,a0,-280 # 80022968 <ftable>
    80004a88:	ffffc097          	auipc	ra,0xffffc
    80004a8c:	200080e7          	jalr	512(ra) # 80000c88 <release>

  if(ff.type == FD_PIPE){
    80004a90:	4785                	li	a5,1
    80004a92:	04f90d63          	beq	s2,a5,80004aec <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004a96:	3979                	addiw	s2,s2,-2
    80004a98:	4785                	li	a5,1
    80004a9a:	0527e063          	bltu	a5,s2,80004ada <fileclose+0xa8>
    begin_op();
    80004a9e:	00000097          	auipc	ra,0x0
    80004aa2:	acc080e7          	jalr	-1332(ra) # 8000456a <begin_op>
    iput(ff.ip);
    80004aa6:	854e                	mv	a0,s3
    80004aa8:	fffff097          	auipc	ra,0xfffff
    80004aac:	2b0080e7          	jalr	688(ra) # 80003d58 <iput>
    end_op();
    80004ab0:	00000097          	auipc	ra,0x0
    80004ab4:	b38080e7          	jalr	-1224(ra) # 800045e8 <end_op>
    80004ab8:	a00d                	j	80004ada <fileclose+0xa8>
    panic("fileclose");
    80004aba:	00005517          	auipc	a0,0x5
    80004abe:	cee50513          	addi	a0,a0,-786 # 800097a8 <syscalls+0x358>
    80004ac2:	ffffc097          	auipc	ra,0xffffc
    80004ac6:	a7c080e7          	jalr	-1412(ra) # 8000053e <panic>
    release(&ftable.lock);
    80004aca:	0001e517          	auipc	a0,0x1e
    80004ace:	e9e50513          	addi	a0,a0,-354 # 80022968 <ftable>
    80004ad2:	ffffc097          	auipc	ra,0xffffc
    80004ad6:	1b6080e7          	jalr	438(ra) # 80000c88 <release>
  }
}
    80004ada:	70e2                	ld	ra,56(sp)
    80004adc:	7442                	ld	s0,48(sp)
    80004ade:	74a2                	ld	s1,40(sp)
    80004ae0:	7902                	ld	s2,32(sp)
    80004ae2:	69e2                	ld	s3,24(sp)
    80004ae4:	6a42                	ld	s4,16(sp)
    80004ae6:	6aa2                	ld	s5,8(sp)
    80004ae8:	6121                	addi	sp,sp,64
    80004aea:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004aec:	85d6                	mv	a1,s5
    80004aee:	8552                	mv	a0,s4
    80004af0:	00000097          	auipc	ra,0x0
    80004af4:	34c080e7          	jalr	844(ra) # 80004e3c <pipeclose>
    80004af8:	b7cd                	j	80004ada <fileclose+0xa8>

0000000080004afa <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004afa:	715d                	addi	sp,sp,-80
    80004afc:	e486                	sd	ra,72(sp)
    80004afe:	e0a2                	sd	s0,64(sp)
    80004b00:	fc26                	sd	s1,56(sp)
    80004b02:	f84a                	sd	s2,48(sp)
    80004b04:	f44e                	sd	s3,40(sp)
    80004b06:	0880                	addi	s0,sp,80
    80004b08:	84aa                	mv	s1,a0
    80004b0a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004b0c:	ffffd097          	auipc	ra,0xffffd
    80004b10:	e9e080e7          	jalr	-354(ra) # 800019aa <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004b14:	409c                	lw	a5,0(s1)
    80004b16:	37f9                	addiw	a5,a5,-2
    80004b18:	4705                	li	a4,1
    80004b1a:	04f76763          	bltu	a4,a5,80004b68 <filestat+0x6e>
    80004b1e:	892a                	mv	s2,a0
    ilock(f->ip);
    80004b20:	6c88                	ld	a0,24(s1)
    80004b22:	fffff097          	auipc	ra,0xfffff
    80004b26:	07c080e7          	jalr	124(ra) # 80003b9e <ilock>
    stati(f->ip, &st);
    80004b2a:	fb840593          	addi	a1,s0,-72
    80004b2e:	6c88                	ld	a0,24(s1)
    80004b30:	fffff097          	auipc	ra,0xfffff
    80004b34:	2f8080e7          	jalr	760(ra) # 80003e28 <stati>
    iunlock(f->ip);
    80004b38:	6c88                	ld	a0,24(s1)
    80004b3a:	fffff097          	auipc	ra,0xfffff
    80004b3e:	126080e7          	jalr	294(ra) # 80003c60 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004b42:	46e1                	li	a3,24
    80004b44:	fb840613          	addi	a2,s0,-72
    80004b48:	85ce                	mv	a1,s3
    80004b4a:	05093503          	ld	a0,80(s2)
    80004b4e:	ffffd097          	auipc	ra,0xffffd
    80004b52:	b1c080e7          	jalr	-1252(ra) # 8000166a <copyout>
    80004b56:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004b5a:	60a6                	ld	ra,72(sp)
    80004b5c:	6406                	ld	s0,64(sp)
    80004b5e:	74e2                	ld	s1,56(sp)
    80004b60:	7942                	ld	s2,48(sp)
    80004b62:	79a2                	ld	s3,40(sp)
    80004b64:	6161                	addi	sp,sp,80
    80004b66:	8082                	ret
  return -1;
    80004b68:	557d                	li	a0,-1
    80004b6a:	bfc5                	j	80004b5a <filestat+0x60>

0000000080004b6c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004b6c:	7179                	addi	sp,sp,-48
    80004b6e:	f406                	sd	ra,40(sp)
    80004b70:	f022                	sd	s0,32(sp)
    80004b72:	ec26                	sd	s1,24(sp)
    80004b74:	e84a                	sd	s2,16(sp)
    80004b76:	e44e                	sd	s3,8(sp)
    80004b78:	1800                	addi	s0,sp,48

  int r = 0;

  if(f->readable == 0)
    80004b7a:	00854783          	lbu	a5,8(a0)
    80004b7e:	c3d5                	beqz	a5,80004c22 <fileread+0xb6>
    80004b80:	84aa                	mv	s1,a0
    80004b82:	89ae                	mv	s3,a1
    80004b84:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b86:	411c                	lw	a5,0(a0)
    80004b88:	4705                	li	a4,1
    80004b8a:	04e78963          	beq	a5,a4,80004bdc <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b8e:	470d                	li	a4,3
    80004b90:	04e78d63          	beq	a5,a4,80004bea <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b94:	4709                	li	a4,2
    80004b96:	06e79e63          	bne	a5,a4,80004c12 <fileread+0xa6>
    ilock(f->ip);
    80004b9a:	6d08                	ld	a0,24(a0)
    80004b9c:	fffff097          	auipc	ra,0xfffff
    80004ba0:	002080e7          	jalr	2(ra) # 80003b9e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004ba4:	874a                	mv	a4,s2
    80004ba6:	5094                	lw	a3,32(s1)
    80004ba8:	864e                	mv	a2,s3
    80004baa:	4585                	li	a1,1
    80004bac:	6c88                	ld	a0,24(s1)
    80004bae:	fffff097          	auipc	ra,0xfffff
    80004bb2:	2a4080e7          	jalr	676(ra) # 80003e52 <readi>
    80004bb6:	892a                	mv	s2,a0
    80004bb8:	00a05563          	blez	a0,80004bc2 <fileread+0x56>
      f->off += r;
    80004bbc:	509c                	lw	a5,32(s1)
    80004bbe:	9fa9                	addw	a5,a5,a0
    80004bc0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004bc2:	6c88                	ld	a0,24(s1)
    80004bc4:	fffff097          	auipc	ra,0xfffff
    80004bc8:	09c080e7          	jalr	156(ra) # 80003c60 <iunlock>
  } else {
    panic("fileread");
  }
  return r;
}
    80004bcc:	854a                	mv	a0,s2
    80004bce:	70a2                	ld	ra,40(sp)
    80004bd0:	7402                	ld	s0,32(sp)
    80004bd2:	64e2                	ld	s1,24(sp)
    80004bd4:	6942                	ld	s2,16(sp)
    80004bd6:	69a2                	ld	s3,8(sp)
    80004bd8:	6145                	addi	sp,sp,48
    80004bda:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004bdc:	6908                	ld	a0,16(a0)
    80004bde:	00000097          	auipc	ra,0x0
    80004be2:	3c6080e7          	jalr	966(ra) # 80004fa4 <piperead>
    80004be6:	892a                	mv	s2,a0
    80004be8:	b7d5                	j	80004bcc <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004bea:	02451783          	lh	a5,36(a0)
    80004bee:	03079693          	slli	a3,a5,0x30
    80004bf2:	92c1                	srli	a3,a3,0x30
    80004bf4:	4725                	li	a4,9
    80004bf6:	02d76863          	bltu	a4,a3,80004c26 <fileread+0xba>
    80004bfa:	0792                	slli	a5,a5,0x4
    80004bfc:	0001e717          	auipc	a4,0x1e
    80004c00:	ccc70713          	addi	a4,a4,-820 # 800228c8 <devsw>
    80004c04:	97ba                	add	a5,a5,a4
    80004c06:	639c                	ld	a5,0(a5)
    80004c08:	c38d                	beqz	a5,80004c2a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004c0a:	4505                	li	a0,1
    80004c0c:	9782                	jalr	a5
    80004c0e:	892a                	mv	s2,a0
    80004c10:	bf75                	j	80004bcc <fileread+0x60>
    panic("fileread");
    80004c12:	00005517          	auipc	a0,0x5
    80004c16:	ba650513          	addi	a0,a0,-1114 # 800097b8 <syscalls+0x368>
    80004c1a:	ffffc097          	auipc	ra,0xffffc
    80004c1e:	924080e7          	jalr	-1756(ra) # 8000053e <panic>
    return -1;
    80004c22:	597d                	li	s2,-1
    80004c24:	b765                	j	80004bcc <fileread+0x60>
      return -1;
    80004c26:	597d                	li	s2,-1
    80004c28:	b755                	j	80004bcc <fileread+0x60>
    80004c2a:	597d                	li	s2,-1
    80004c2c:	b745                	j	80004bcc <fileread+0x60>

0000000080004c2e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004c2e:	715d                	addi	sp,sp,-80
    80004c30:	e486                	sd	ra,72(sp)
    80004c32:	e0a2                	sd	s0,64(sp)
    80004c34:	fc26                	sd	s1,56(sp)
    80004c36:	f84a                	sd	s2,48(sp)
    80004c38:	f44e                	sd	s3,40(sp)
    80004c3a:	f052                	sd	s4,32(sp)
    80004c3c:	ec56                	sd	s5,24(sp)
    80004c3e:	e85a                	sd	s6,16(sp)
    80004c40:	e45e                	sd	s7,8(sp)
    80004c42:	e062                	sd	s8,0(sp)
    80004c44:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004c46:	00954783          	lbu	a5,9(a0)
    80004c4a:	10078663          	beqz	a5,80004d56 <filewrite+0x128>
    80004c4e:	892a                	mv	s2,a0
    80004c50:	8b2e                	mv	s6,a1
    80004c52:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c54:	411c                	lw	a5,0(a0)
    80004c56:	4705                	li	a4,1
    80004c58:	02e78263          	beq	a5,a4,80004c7c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c5c:	470d                	li	a4,3
    80004c5e:	02e78663          	beq	a5,a4,80004c8a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c62:	4709                	li	a4,2
    80004c64:	0ee79163          	bne	a5,a4,80004d46 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004c68:	0ac05d63          	blez	a2,80004d22 <filewrite+0xf4>
    int i = 0;
    80004c6c:	4981                	li	s3,0
    80004c6e:	6b85                	lui	s7,0x1
    80004c70:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004c74:	6c05                	lui	s8,0x1
    80004c76:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004c7a:	a861                	j	80004d12 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004c7c:	6908                	ld	a0,16(a0)
    80004c7e:	00000097          	auipc	ra,0x0
    80004c82:	22e080e7          	jalr	558(ra) # 80004eac <pipewrite>
    80004c86:	8a2a                	mv	s4,a0
    80004c88:	a045                	j	80004d28 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004c8a:	02451783          	lh	a5,36(a0)
    80004c8e:	03079693          	slli	a3,a5,0x30
    80004c92:	92c1                	srli	a3,a3,0x30
    80004c94:	4725                	li	a4,9
    80004c96:	0cd76263          	bltu	a4,a3,80004d5a <filewrite+0x12c>
    80004c9a:	0792                	slli	a5,a5,0x4
    80004c9c:	0001e717          	auipc	a4,0x1e
    80004ca0:	c2c70713          	addi	a4,a4,-980 # 800228c8 <devsw>
    80004ca4:	97ba                	add	a5,a5,a4
    80004ca6:	679c                	ld	a5,8(a5)
    80004ca8:	cbdd                	beqz	a5,80004d5e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004caa:	4505                	li	a0,1
    80004cac:	9782                	jalr	a5
    80004cae:	8a2a                	mv	s4,a0
    80004cb0:	a8a5                	j	80004d28 <filewrite+0xfa>
    80004cb2:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004cb6:	00000097          	auipc	ra,0x0
    80004cba:	8b4080e7          	jalr	-1868(ra) # 8000456a <begin_op>
      ilock(f->ip);
    80004cbe:	01893503          	ld	a0,24(s2)
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	edc080e7          	jalr	-292(ra) # 80003b9e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004cca:	8756                	mv	a4,s5
    80004ccc:	02092683          	lw	a3,32(s2)
    80004cd0:	01698633          	add	a2,s3,s6
    80004cd4:	4585                	li	a1,1
    80004cd6:	01893503          	ld	a0,24(s2)
    80004cda:	fffff097          	auipc	ra,0xfffff
    80004cde:	270080e7          	jalr	624(ra) # 80003f4a <writei>
    80004ce2:	84aa                	mv	s1,a0
    80004ce4:	00a05763          	blez	a0,80004cf2 <filewrite+0xc4>
        f->off += r;
    80004ce8:	02092783          	lw	a5,32(s2)
    80004cec:	9fa9                	addw	a5,a5,a0
    80004cee:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004cf2:	01893503          	ld	a0,24(s2)
    80004cf6:	fffff097          	auipc	ra,0xfffff
    80004cfa:	f6a080e7          	jalr	-150(ra) # 80003c60 <iunlock>
      end_op();
    80004cfe:	00000097          	auipc	ra,0x0
    80004d02:	8ea080e7          	jalr	-1814(ra) # 800045e8 <end_op>

      if(r != n1){
    80004d06:	009a9f63          	bne	s5,s1,80004d24 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004d0a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004d0e:	0149db63          	bge	s3,s4,80004d24 <filewrite+0xf6>
      int n1 = n - i;
    80004d12:	413a04bb          	subw	s1,s4,s3
    80004d16:	0004879b          	sext.w	a5,s1
    80004d1a:	f8fbdce3          	bge	s7,a5,80004cb2 <filewrite+0x84>
    80004d1e:	84e2                	mv	s1,s8
    80004d20:	bf49                	j	80004cb2 <filewrite+0x84>
    int i = 0;
    80004d22:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004d24:	013a1f63          	bne	s4,s3,80004d42 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004d28:	8552                	mv	a0,s4
    80004d2a:	60a6                	ld	ra,72(sp)
    80004d2c:	6406                	ld	s0,64(sp)
    80004d2e:	74e2                	ld	s1,56(sp)
    80004d30:	7942                	ld	s2,48(sp)
    80004d32:	79a2                	ld	s3,40(sp)
    80004d34:	7a02                	ld	s4,32(sp)
    80004d36:	6ae2                	ld	s5,24(sp)
    80004d38:	6b42                	ld	s6,16(sp)
    80004d3a:	6ba2                	ld	s7,8(sp)
    80004d3c:	6c02                	ld	s8,0(sp)
    80004d3e:	6161                	addi	sp,sp,80
    80004d40:	8082                	ret
    ret = (i == n ? n : -1);
    80004d42:	5a7d                	li	s4,-1
    80004d44:	b7d5                	j	80004d28 <filewrite+0xfa>
    panic("filewrite");
    80004d46:	00005517          	auipc	a0,0x5
    80004d4a:	a8250513          	addi	a0,a0,-1406 # 800097c8 <syscalls+0x378>
    80004d4e:	ffffb097          	auipc	ra,0xffffb
    80004d52:	7f0080e7          	jalr	2032(ra) # 8000053e <panic>
    return -1;
    80004d56:	5a7d                	li	s4,-1
    80004d58:	bfc1                	j	80004d28 <filewrite+0xfa>
      return -1;
    80004d5a:	5a7d                	li	s4,-1
    80004d5c:	b7f1                	j	80004d28 <filewrite+0xfa>
    80004d5e:	5a7d                	li	s4,-1
    80004d60:	b7e1                	j	80004d28 <filewrite+0xfa>

0000000080004d62 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004d62:	7179                	addi	sp,sp,-48
    80004d64:	f406                	sd	ra,40(sp)
    80004d66:	f022                	sd	s0,32(sp)
    80004d68:	ec26                	sd	s1,24(sp)
    80004d6a:	e84a                	sd	s2,16(sp)
    80004d6c:	e44e                	sd	s3,8(sp)
    80004d6e:	e052                	sd	s4,0(sp)
    80004d70:	1800                	addi	s0,sp,48
    80004d72:	84aa                	mv	s1,a0
    80004d74:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004d76:	0005b023          	sd	zero,0(a1)
    80004d7a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004d7e:	00000097          	auipc	ra,0x0
    80004d82:	bf8080e7          	jalr	-1032(ra) # 80004976 <filealloc>
    80004d86:	e088                	sd	a0,0(s1)
    80004d88:	c551                	beqz	a0,80004e14 <pipealloc+0xb2>
    80004d8a:	00000097          	auipc	ra,0x0
    80004d8e:	bec080e7          	jalr	-1044(ra) # 80004976 <filealloc>
    80004d92:	00aa3023          	sd	a0,0(s4)
    80004d96:	c92d                	beqz	a0,80004e08 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004d98:	ffffc097          	auipc	ra,0xffffc
    80004d9c:	d4c080e7          	jalr	-692(ra) # 80000ae4 <kalloc>
    80004da0:	892a                	mv	s2,a0
    80004da2:	c125                	beqz	a0,80004e02 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004da4:	4985                	li	s3,1
    80004da6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004daa:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004dae:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004db2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004db6:	00005597          	auipc	a1,0x5
    80004dba:	a2258593          	addi	a1,a1,-1502 # 800097d8 <syscalls+0x388>
    80004dbe:	ffffc097          	auipc	ra,0xffffc
    80004dc2:	d86080e7          	jalr	-634(ra) # 80000b44 <initlock>
  (*f0)->type = FD_PIPE;
    80004dc6:	609c                	ld	a5,0(s1)
    80004dc8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004dcc:	609c                	ld	a5,0(s1)
    80004dce:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004dd2:	609c                	ld	a5,0(s1)
    80004dd4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004dd8:	609c                	ld	a5,0(s1)
    80004dda:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004dde:	000a3783          	ld	a5,0(s4)
    80004de2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004de6:	000a3783          	ld	a5,0(s4)
    80004dea:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004dee:	000a3783          	ld	a5,0(s4)
    80004df2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004df6:	000a3783          	ld	a5,0(s4)
    80004dfa:	0127b823          	sd	s2,16(a5)
  return 0;
    80004dfe:	4501                	li	a0,0
    80004e00:	a025                	j	80004e28 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004e02:	6088                	ld	a0,0(s1)
    80004e04:	e501                	bnez	a0,80004e0c <pipealloc+0xaa>
    80004e06:	a039                	j	80004e14 <pipealloc+0xb2>
    80004e08:	6088                	ld	a0,0(s1)
    80004e0a:	c51d                	beqz	a0,80004e38 <pipealloc+0xd6>
    fileclose(*f0);
    80004e0c:	00000097          	auipc	ra,0x0
    80004e10:	c26080e7          	jalr	-986(ra) # 80004a32 <fileclose>
  if(*f1)
    80004e14:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004e18:	557d                	li	a0,-1
  if(*f1)
    80004e1a:	c799                	beqz	a5,80004e28 <pipealloc+0xc6>
    fileclose(*f1);
    80004e1c:	853e                	mv	a0,a5
    80004e1e:	00000097          	auipc	ra,0x0
    80004e22:	c14080e7          	jalr	-1004(ra) # 80004a32 <fileclose>
  return -1;
    80004e26:	557d                	li	a0,-1
}
    80004e28:	70a2                	ld	ra,40(sp)
    80004e2a:	7402                	ld	s0,32(sp)
    80004e2c:	64e2                	ld	s1,24(sp)
    80004e2e:	6942                	ld	s2,16(sp)
    80004e30:	69a2                	ld	s3,8(sp)
    80004e32:	6a02                	ld	s4,0(sp)
    80004e34:	6145                	addi	sp,sp,48
    80004e36:	8082                	ret
  return -1;
    80004e38:	557d                	li	a0,-1
    80004e3a:	b7fd                	j	80004e28 <pipealloc+0xc6>

0000000080004e3c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004e3c:	1101                	addi	sp,sp,-32
    80004e3e:	ec06                	sd	ra,24(sp)
    80004e40:	e822                	sd	s0,16(sp)
    80004e42:	e426                	sd	s1,8(sp)
    80004e44:	e04a                	sd	s2,0(sp)
    80004e46:	1000                	addi	s0,sp,32
    80004e48:	84aa                	mv	s1,a0
    80004e4a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004e4c:	ffffc097          	auipc	ra,0xffffc
    80004e50:	d88080e7          	jalr	-632(ra) # 80000bd4 <acquire>
  if(writable){
    80004e54:	02090d63          	beqz	s2,80004e8e <pipeclose+0x52>
    pi->writeopen = 0;
    80004e58:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004e5c:	21848513          	addi	a0,s1,536
    80004e60:	ffffd097          	auipc	ra,0xffffd
    80004e64:	2f6080e7          	jalr	758(ra) # 80002156 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004e68:	2204b783          	ld	a5,544(s1)
    80004e6c:	eb95                	bnez	a5,80004ea0 <pipeclose+0x64>
    release(&pi->lock);
    80004e6e:	8526                	mv	a0,s1
    80004e70:	ffffc097          	auipc	ra,0xffffc
    80004e74:	e18080e7          	jalr	-488(ra) # 80000c88 <release>
    kfree((char*)pi);
    80004e78:	8526                	mv	a0,s1
    80004e7a:	ffffc097          	auipc	ra,0xffffc
    80004e7e:	b6c080e7          	jalr	-1172(ra) # 800009e6 <kfree>
  } else
    release(&pi->lock);
}
    80004e82:	60e2                	ld	ra,24(sp)
    80004e84:	6442                	ld	s0,16(sp)
    80004e86:	64a2                	ld	s1,8(sp)
    80004e88:	6902                	ld	s2,0(sp)
    80004e8a:	6105                	addi	sp,sp,32
    80004e8c:	8082                	ret
    pi->readopen = 0;
    80004e8e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004e92:	21c48513          	addi	a0,s1,540
    80004e96:	ffffd097          	auipc	ra,0xffffd
    80004e9a:	2c0080e7          	jalr	704(ra) # 80002156 <wakeup>
    80004e9e:	b7e9                	j	80004e68 <pipeclose+0x2c>
    release(&pi->lock);
    80004ea0:	8526                	mv	a0,s1
    80004ea2:	ffffc097          	auipc	ra,0xffffc
    80004ea6:	de6080e7          	jalr	-538(ra) # 80000c88 <release>
}
    80004eaa:	bfe1                	j	80004e82 <pipeclose+0x46>

0000000080004eac <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004eac:	711d                	addi	sp,sp,-96
    80004eae:	ec86                	sd	ra,88(sp)
    80004eb0:	e8a2                	sd	s0,80(sp)
    80004eb2:	e4a6                	sd	s1,72(sp)
    80004eb4:	e0ca                	sd	s2,64(sp)
    80004eb6:	fc4e                	sd	s3,56(sp)
    80004eb8:	f852                	sd	s4,48(sp)
    80004eba:	f456                	sd	s5,40(sp)
    80004ebc:	f05a                	sd	s6,32(sp)
    80004ebe:	ec5e                	sd	s7,24(sp)
    80004ec0:	e862                	sd	s8,16(sp)
    80004ec2:	1080                	addi	s0,sp,96
    80004ec4:	84aa                	mv	s1,a0
    80004ec6:	8aae                	mv	s5,a1
    80004ec8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004eca:	ffffd097          	auipc	ra,0xffffd
    80004ece:	ae0080e7          	jalr	-1312(ra) # 800019aa <myproc>
    80004ed2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004ed4:	8526                	mv	a0,s1
    80004ed6:	ffffc097          	auipc	ra,0xffffc
    80004eda:	cfe080e7          	jalr	-770(ra) # 80000bd4 <acquire>
  while(i < n){
    80004ede:	0b405663          	blez	s4,80004f8a <pipewrite+0xde>
  int i = 0;
    80004ee2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ee4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004ee6:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004eea:	21c48b93          	addi	s7,s1,540
    80004eee:	a089                	j	80004f30 <pipewrite+0x84>
      release(&pi->lock);
    80004ef0:	8526                	mv	a0,s1
    80004ef2:	ffffc097          	auipc	ra,0xffffc
    80004ef6:	d96080e7          	jalr	-618(ra) # 80000c88 <release>
      return -1;
    80004efa:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004efc:	854a                	mv	a0,s2
    80004efe:	60e6                	ld	ra,88(sp)
    80004f00:	6446                	ld	s0,80(sp)
    80004f02:	64a6                	ld	s1,72(sp)
    80004f04:	6906                	ld	s2,64(sp)
    80004f06:	79e2                	ld	s3,56(sp)
    80004f08:	7a42                	ld	s4,48(sp)
    80004f0a:	7aa2                	ld	s5,40(sp)
    80004f0c:	7b02                	ld	s6,32(sp)
    80004f0e:	6be2                	ld	s7,24(sp)
    80004f10:	6c42                	ld	s8,16(sp)
    80004f12:	6125                	addi	sp,sp,96
    80004f14:	8082                	ret
      wakeup(&pi->nread);
    80004f16:	8562                	mv	a0,s8
    80004f18:	ffffd097          	auipc	ra,0xffffd
    80004f1c:	23e080e7          	jalr	574(ra) # 80002156 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004f20:	85a6                	mv	a1,s1
    80004f22:	855e                	mv	a0,s7
    80004f24:	ffffd097          	auipc	ra,0xffffd
    80004f28:	1ce080e7          	jalr	462(ra) # 800020f2 <sleep>
  while(i < n){
    80004f2c:	07495063          	bge	s2,s4,80004f8c <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004f30:	2204a783          	lw	a5,544(s1)
    80004f34:	dfd5                	beqz	a5,80004ef0 <pipewrite+0x44>
    80004f36:	854e                	mv	a0,s3
    80004f38:	ffffd097          	auipc	ra,0xffffd
    80004f3c:	486080e7          	jalr	1158(ra) # 800023be <killed>
    80004f40:	f945                	bnez	a0,80004ef0 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004f42:	2184a783          	lw	a5,536(s1)
    80004f46:	21c4a703          	lw	a4,540(s1)
    80004f4a:	2007879b          	addiw	a5,a5,512
    80004f4e:	fcf704e3          	beq	a4,a5,80004f16 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f52:	4685                	li	a3,1
    80004f54:	01590633          	add	a2,s2,s5
    80004f58:	faf40593          	addi	a1,s0,-81
    80004f5c:	0509b503          	ld	a0,80(s3)
    80004f60:	ffffc097          	auipc	ra,0xffffc
    80004f64:	796080e7          	jalr	1942(ra) # 800016f6 <copyin>
    80004f68:	03650263          	beq	a0,s6,80004f8c <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004f6c:	21c4a783          	lw	a5,540(s1)
    80004f70:	0017871b          	addiw	a4,a5,1
    80004f74:	20e4ae23          	sw	a4,540(s1)
    80004f78:	1ff7f793          	andi	a5,a5,511
    80004f7c:	97a6                	add	a5,a5,s1
    80004f7e:	faf44703          	lbu	a4,-81(s0)
    80004f82:	00e78c23          	sb	a4,24(a5)
      i++;
    80004f86:	2905                	addiw	s2,s2,1
    80004f88:	b755                	j	80004f2c <pipewrite+0x80>
  int i = 0;
    80004f8a:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004f8c:	21848513          	addi	a0,s1,536
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	1c6080e7          	jalr	454(ra) # 80002156 <wakeup>
  release(&pi->lock);
    80004f98:	8526                	mv	a0,s1
    80004f9a:	ffffc097          	auipc	ra,0xffffc
    80004f9e:	cee080e7          	jalr	-786(ra) # 80000c88 <release>
  return i;
    80004fa2:	bfa9                	j	80004efc <pipewrite+0x50>

0000000080004fa4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004fa4:	715d                	addi	sp,sp,-80
    80004fa6:	e486                	sd	ra,72(sp)
    80004fa8:	e0a2                	sd	s0,64(sp)
    80004faa:	fc26                	sd	s1,56(sp)
    80004fac:	f84a                	sd	s2,48(sp)
    80004fae:	f44e                	sd	s3,40(sp)
    80004fb0:	f052                	sd	s4,32(sp)
    80004fb2:	ec56                	sd	s5,24(sp)
    80004fb4:	e85a                	sd	s6,16(sp)
    80004fb6:	0880                	addi	s0,sp,80
    80004fb8:	84aa                	mv	s1,a0
    80004fba:	892e                	mv	s2,a1
    80004fbc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004fbe:	ffffd097          	auipc	ra,0xffffd
    80004fc2:	9ec080e7          	jalr	-1556(ra) # 800019aa <myproc>
    80004fc6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004fc8:	8526                	mv	a0,s1
    80004fca:	ffffc097          	auipc	ra,0xffffc
    80004fce:	c0a080e7          	jalr	-1014(ra) # 80000bd4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004fd2:	2184a703          	lw	a4,536(s1)
    80004fd6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004fda:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004fde:	02f71763          	bne	a4,a5,8000500c <piperead+0x68>
    80004fe2:	2244a783          	lw	a5,548(s1)
    80004fe6:	c39d                	beqz	a5,8000500c <piperead+0x68>
    if(killed(pr)){
    80004fe8:	8552                	mv	a0,s4
    80004fea:	ffffd097          	auipc	ra,0xffffd
    80004fee:	3d4080e7          	jalr	980(ra) # 800023be <killed>
    80004ff2:	e949                	bnez	a0,80005084 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004ff4:	85a6                	mv	a1,s1
    80004ff6:	854e                	mv	a0,s3
    80004ff8:	ffffd097          	auipc	ra,0xffffd
    80004ffc:	0fa080e7          	jalr	250(ra) # 800020f2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005000:	2184a703          	lw	a4,536(s1)
    80005004:	21c4a783          	lw	a5,540(s1)
    80005008:	fcf70de3          	beq	a4,a5,80004fe2 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000500c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000500e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005010:	05505463          	blez	s5,80005058 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80005014:	2184a783          	lw	a5,536(s1)
    80005018:	21c4a703          	lw	a4,540(s1)
    8000501c:	02f70e63          	beq	a4,a5,80005058 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005020:	0017871b          	addiw	a4,a5,1
    80005024:	20e4ac23          	sw	a4,536(s1)
    80005028:	1ff7f793          	andi	a5,a5,511
    8000502c:	97a6                	add	a5,a5,s1
    8000502e:	0187c783          	lbu	a5,24(a5)
    80005032:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005036:	4685                	li	a3,1
    80005038:	fbf40613          	addi	a2,s0,-65
    8000503c:	85ca                	mv	a1,s2
    8000503e:	050a3503          	ld	a0,80(s4)
    80005042:	ffffc097          	auipc	ra,0xffffc
    80005046:	628080e7          	jalr	1576(ra) # 8000166a <copyout>
    8000504a:	01650763          	beq	a0,s6,80005058 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000504e:	2985                	addiw	s3,s3,1
    80005050:	0905                	addi	s2,s2,1
    80005052:	fd3a91e3          	bne	s5,s3,80005014 <piperead+0x70>
    80005056:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005058:	21c48513          	addi	a0,s1,540
    8000505c:	ffffd097          	auipc	ra,0xffffd
    80005060:	0fa080e7          	jalr	250(ra) # 80002156 <wakeup>
  release(&pi->lock);
    80005064:	8526                	mv	a0,s1
    80005066:	ffffc097          	auipc	ra,0xffffc
    8000506a:	c22080e7          	jalr	-990(ra) # 80000c88 <release>
  return i;
}
    8000506e:	854e                	mv	a0,s3
    80005070:	60a6                	ld	ra,72(sp)
    80005072:	6406                	ld	s0,64(sp)
    80005074:	74e2                	ld	s1,56(sp)
    80005076:	7942                	ld	s2,48(sp)
    80005078:	79a2                	ld	s3,40(sp)
    8000507a:	7a02                	ld	s4,32(sp)
    8000507c:	6ae2                	ld	s5,24(sp)
    8000507e:	6b42                	ld	s6,16(sp)
    80005080:	6161                	addi	sp,sp,80
    80005082:	8082                	ret
      release(&pi->lock);
    80005084:	8526                	mv	a0,s1
    80005086:	ffffc097          	auipc	ra,0xffffc
    8000508a:	c02080e7          	jalr	-1022(ra) # 80000c88 <release>
      return -1;
    8000508e:	59fd                	li	s3,-1
    80005090:	bff9                	j	8000506e <piperead+0xca>

0000000080005092 <read_pipe>:
Reading from the pipe

*/
int
read_pipe(struct pipe *pi, uint64 addr, int n)
{
    80005092:	715d                	addi	sp,sp,-80
    80005094:	e486                	sd	ra,72(sp)
    80005096:	e0a2                	sd	s0,64(sp)
    80005098:	fc26                	sd	s1,56(sp)
    8000509a:	f84a                	sd	s2,48(sp)
    8000509c:	f44e                	sd	s3,40(sp)
    8000509e:	f052                	sd	s4,32(sp)
    800050a0:	ec56                	sd	s5,24(sp)
    800050a2:	0880                	addi	s0,sp,80
    800050a4:	84aa                	mv	s1,a0
    800050a6:	8a2e                	mv	s4,a1
    800050a8:	89b2                	mv	s3,a2
  int i;
  struct proc *pr = myproc();
    800050aa:	ffffd097          	auipc	ra,0xffffd
    800050ae:	900080e7          	jalr	-1792(ra) # 800019aa <myproc>
    800050b2:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    800050b4:	8526                	mv	a0,s1
    800050b6:	ffffc097          	auipc	ra,0xffffc
    800050ba:	b1e080e7          	jalr	-1250(ra) # 80000bd4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050be:	2184a703          	lw	a4,536(s1)
    800050c2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050c6:	21848a93          	addi	s5,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050ca:	02f71763          	bne	a4,a5,800050f8 <read_pipe+0x66>
    800050ce:	2244a783          	lw	a5,548(s1)
    800050d2:	c39d                	beqz	a5,800050f8 <read_pipe+0x66>
    if(killed(pr)){
    800050d4:	854a                	mv	a0,s2
    800050d6:	ffffd097          	auipc	ra,0xffffd
    800050da:	2e8080e7          	jalr	744(ra) # 800023be <killed>
    800050de:	e541                	bnez	a0,80005166 <read_pipe+0xd4>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050e0:	85a6                	mv	a1,s1
    800050e2:	8556                	mv	a0,s5
    800050e4:	ffffd097          	auipc	ra,0xffffd
    800050e8:	00e080e7          	jalr	14(ra) # 800020f2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050ec:	2184a703          	lw	a4,536(s1)
    800050f0:	21c4a783          	lw	a5,540(s1)
    800050f4:	fcf70de3          	beq	a4,a5,800050ce <read_pipe+0x3c>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050f8:	4901                	li	s2,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    memmove((char *)addr,(char*)&ch,n);
    800050fa:	00098a9b          	sext.w	s5,s3
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050fe:	03305f63          	blez	s3,8000513c <read_pipe+0xaa>
    if(pi->nread == pi->nwrite)
    80005102:	2184a783          	lw	a5,536(s1)
    80005106:	21c4a703          	lw	a4,540(s1)
    8000510a:	02f70963          	beq	a4,a5,8000513c <read_pipe+0xaa>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000510e:	0017871b          	addiw	a4,a5,1
    80005112:	20e4ac23          	sw	a4,536(s1)
    80005116:	1ff7f793          	andi	a5,a5,511
    8000511a:	97a6                	add	a5,a5,s1
    8000511c:	0187c783          	lbu	a5,24(a5)
    80005120:	faf40fa3          	sb	a5,-65(s0)
    memmove((char *)addr,(char*)&ch,n);
    80005124:	8656                	mv	a2,s5
    80005126:	fbf40593          	addi	a1,s0,-65
    8000512a:	8552                	mv	a0,s4
    8000512c:	ffffc097          	auipc	ra,0xffffc
    80005130:	c00080e7          	jalr	-1024(ra) # 80000d2c <memmove>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005134:	2905                	addiw	s2,s2,1
    80005136:	fd2996e3          	bne	s3,s2,80005102 <read_pipe+0x70>
    8000513a:	894e                	mv	s2,s3
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000513c:	21c48513          	addi	a0,s1,540
    80005140:	ffffd097          	auipc	ra,0xffffd
    80005144:	016080e7          	jalr	22(ra) # 80002156 <wakeup>
  release(&pi->lock);
    80005148:	8526                	mv	a0,s1
    8000514a:	ffffc097          	auipc	ra,0xffffc
    8000514e:	b3e080e7          	jalr	-1218(ra) # 80000c88 <release>
  return i;
}
    80005152:	854a                	mv	a0,s2
    80005154:	60a6                	ld	ra,72(sp)
    80005156:	6406                	ld	s0,64(sp)
    80005158:	74e2                	ld	s1,56(sp)
    8000515a:	7942                	ld	s2,48(sp)
    8000515c:	79a2                	ld	s3,40(sp)
    8000515e:	7a02                	ld	s4,32(sp)
    80005160:	6ae2                	ld	s5,24(sp)
    80005162:	6161                	addi	sp,sp,80
    80005164:	8082                	ret
      release(&pi->lock);
    80005166:	8526                	mv	a0,s1
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	b20080e7          	jalr	-1248(ra) # 80000c88 <release>
      return -1;
    80005170:	597d                	li	s2,-1
    80005172:	b7c5                	j	80005152 <read_pipe+0xc0>

0000000080005174 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);
extern uint64 sys_uptime(void);

int flags2perm(int flags)
{
    80005174:	1141                	addi	sp,sp,-16
    80005176:	e422                	sd	s0,8(sp)
    80005178:	0800                	addi	s0,sp,16
    8000517a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000517c:	8905                	andi	a0,a0,1
    8000517e:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80005180:	8b89                	andi	a5,a5,2
    80005182:	c399                	beqz	a5,80005188 <flags2perm+0x14>
      perm |= PTE_W;
    80005184:	00456513          	ori	a0,a0,4
    return perm;
}
    80005188:	6422                	ld	s0,8(sp)
    8000518a:	0141                	addi	sp,sp,16
    8000518c:	8082                	ret

000000008000518e <exec>:

int
exec(char *path, char **argv)
{
    8000518e:	de010113          	addi	sp,sp,-544
    80005192:	20113c23          	sd	ra,536(sp)
    80005196:	20813823          	sd	s0,528(sp)
    8000519a:	20913423          	sd	s1,520(sp)
    8000519e:	21213023          	sd	s2,512(sp)
    800051a2:	ffce                	sd	s3,504(sp)
    800051a4:	fbd2                	sd	s4,496(sp)
    800051a6:	f7d6                	sd	s5,488(sp)
    800051a8:	f3da                	sd	s6,480(sp)
    800051aa:	efde                	sd	s7,472(sp)
    800051ac:	ebe2                	sd	s8,464(sp)
    800051ae:	e7e6                	sd	s9,456(sp)
    800051b0:	e3ea                	sd	s10,448(sp)
    800051b2:	ff6e                	sd	s11,440(sp)
    800051b4:	1400                	addi	s0,sp,544
    800051b6:	892a                	mv	s2,a0
    800051b8:	dea43423          	sd	a0,-536(s0)
    800051bc:	deb43823          	sd	a1,-528(s0)
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;


  struct proc *p = myproc();
    800051c0:	ffffc097          	auipc	ra,0xffffc
    800051c4:	7ea080e7          	jalr	2026(ra) # 800019aa <myproc>
    800051c8:	84aa                	mv	s1,a0

  begin_op();
    800051ca:	fffff097          	auipc	ra,0xfffff
    800051ce:	3a0080e7          	jalr	928(ra) # 8000456a <begin_op>

  if((ip = namei(path)) == 0){
    800051d2:	854a                	mv	a0,s2
    800051d4:	fffff097          	auipc	ra,0xfffff
    800051d8:	176080e7          	jalr	374(ra) # 8000434a <namei>
    800051dc:	c93d                	beqz	a0,80005252 <exec+0xc4>
    800051de:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800051e0:	fffff097          	auipc	ra,0xfffff
    800051e4:	9be080e7          	jalr	-1602(ra) # 80003b9e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800051e8:	04000713          	li	a4,64
    800051ec:	4681                	li	a3,0
    800051ee:	e5040613          	addi	a2,s0,-432
    800051f2:	4581                	li	a1,0
    800051f4:	8556                	mv	a0,s5
    800051f6:	fffff097          	auipc	ra,0xfffff
    800051fa:	c5c080e7          	jalr	-932(ra) # 80003e52 <readi>
    800051fe:	04000793          	li	a5,64
    80005202:	00f51a63          	bne	a0,a5,80005216 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005206:	e5042703          	lw	a4,-432(s0)
    8000520a:	464c47b7          	lui	a5,0x464c4
    8000520e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005212:	04f70663          	beq	a4,a5,8000525e <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005216:	8556                	mv	a0,s5
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	be8080e7          	jalr	-1048(ra) # 80003e00 <iunlockput>
    end_op();
    80005220:	fffff097          	auipc	ra,0xfffff
    80005224:	3c8080e7          	jalr	968(ra) # 800045e8 <end_op>
  }

  return -1;
    80005228:	557d                	li	a0,-1
}
    8000522a:	21813083          	ld	ra,536(sp)
    8000522e:	21013403          	ld	s0,528(sp)
    80005232:	20813483          	ld	s1,520(sp)
    80005236:	20013903          	ld	s2,512(sp)
    8000523a:	79fe                	ld	s3,504(sp)
    8000523c:	7a5e                	ld	s4,496(sp)
    8000523e:	7abe                	ld	s5,488(sp)
    80005240:	7b1e                	ld	s6,480(sp)
    80005242:	6bfe                	ld	s7,472(sp)
    80005244:	6c5e                	ld	s8,464(sp)
    80005246:	6cbe                	ld	s9,456(sp)
    80005248:	6d1e                	ld	s10,448(sp)
    8000524a:	7dfa                	ld	s11,440(sp)
    8000524c:	22010113          	addi	sp,sp,544
    80005250:	8082                	ret
    end_op();
    80005252:	fffff097          	auipc	ra,0xfffff
    80005256:	396080e7          	jalr	918(ra) # 800045e8 <end_op>
    return -1;
    8000525a:	557d                	li	a0,-1
    8000525c:	b7f9                	j	8000522a <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000525e:	8526                	mv	a0,s1
    80005260:	ffffd097          	auipc	ra,0xffffd
    80005264:	80e080e7          	jalr	-2034(ra) # 80001a6e <proc_pagetable>
    80005268:	8b2a                	mv	s6,a0
    8000526a:	d555                	beqz	a0,80005216 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000526c:	e7042783          	lw	a5,-400(s0)
    80005270:	e8845703          	lhu	a4,-376(s0)
    80005274:	c735                	beqz	a4,800052e0 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005276:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005278:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000527c:	6a05                	lui	s4,0x1
    8000527e:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005282:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80005286:	6d85                	lui	s11,0x1
    80005288:	7d7d                	lui	s10,0xfffff
    8000528a:	ac3d                	j	800054c8 <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000528c:	00004517          	auipc	a0,0x4
    80005290:	55450513          	addi	a0,a0,1364 # 800097e0 <syscalls+0x390>
    80005294:	ffffb097          	auipc	ra,0xffffb
    80005298:	2aa080e7          	jalr	682(ra) # 8000053e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000529c:	874a                	mv	a4,s2
    8000529e:	009c86bb          	addw	a3,s9,s1
    800052a2:	4581                	li	a1,0
    800052a4:	8556                	mv	a0,s5
    800052a6:	fffff097          	auipc	ra,0xfffff
    800052aa:	bac080e7          	jalr	-1108(ra) # 80003e52 <readi>
    800052ae:	2501                	sext.w	a0,a0
    800052b0:	1aa91963          	bne	s2,a0,80005462 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    800052b4:	009d84bb          	addw	s1,s11,s1
    800052b8:	013d09bb          	addw	s3,s10,s3
    800052bc:	1f74f663          	bgeu	s1,s7,800054a8 <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    800052c0:	02049593          	slli	a1,s1,0x20
    800052c4:	9181                	srli	a1,a1,0x20
    800052c6:	95e2                	add	a1,a1,s8
    800052c8:	855a                	mv	a0,s6
    800052ca:	ffffc097          	auipc	ra,0xffffc
    800052ce:	d90080e7          	jalr	-624(ra) # 8000105a <walkaddr>
    800052d2:	862a                	mv	a2,a0
    if(pa == 0)
    800052d4:	dd45                	beqz	a0,8000528c <exec+0xfe>
      n = PGSIZE;
    800052d6:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800052d8:	fd49f2e3          	bgeu	s3,s4,8000529c <exec+0x10e>
      n = sz - i;
    800052dc:	894e                	mv	s2,s3
    800052de:	bf7d                	j	8000529c <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800052e0:	4901                	li	s2,0
  iunlockput(ip);
    800052e2:	8556                	mv	a0,s5
    800052e4:	fffff097          	auipc	ra,0xfffff
    800052e8:	b1c080e7          	jalr	-1252(ra) # 80003e00 <iunlockput>
  end_op();
    800052ec:	fffff097          	auipc	ra,0xfffff
    800052f0:	2fc080e7          	jalr	764(ra) # 800045e8 <end_op>
  p = myproc();
    800052f4:	ffffc097          	auipc	ra,0xffffc
    800052f8:	6b6080e7          	jalr	1718(ra) # 800019aa <myproc>
    800052fc:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800052fe:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005302:	6785                	lui	a5,0x1
    80005304:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80005306:	97ca                	add	a5,a5,s2
    80005308:	777d                	lui	a4,0xfffff
    8000530a:	8ff9                	and	a5,a5,a4
    8000530c:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005310:	4691                	li	a3,4
    80005312:	6609                	lui	a2,0x2
    80005314:	963e                	add	a2,a2,a5
    80005316:	85be                	mv	a1,a5
    80005318:	855a                	mv	a0,s6
    8000531a:	ffffc097          	auipc	ra,0xffffc
    8000531e:	0f4080e7          	jalr	244(ra) # 8000140e <uvmalloc>
    80005322:	8c2a                	mv	s8,a0
  ip = 0;
    80005324:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005326:	12050e63          	beqz	a0,80005462 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000532a:	75f9                	lui	a1,0xffffe
    8000532c:	95aa                	add	a1,a1,a0
    8000532e:	855a                	mv	a0,s6
    80005330:	ffffc097          	auipc	ra,0xffffc
    80005334:	308080e7          	jalr	776(ra) # 80001638 <uvmclear>
  stackbase = sp - PGSIZE;
    80005338:	7afd                	lui	s5,0xfffff
    8000533a:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000533c:	df043783          	ld	a5,-528(s0)
    80005340:	6388                	ld	a0,0(a5)
    80005342:	c925                	beqz	a0,800053b2 <exec+0x224>
    80005344:	e9040993          	addi	s3,s0,-368
    80005348:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000534c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000534e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005350:	ffffc097          	auipc	ra,0xffffc
    80005354:	afc080e7          	jalr	-1284(ra) # 80000e4c <strlen>
    80005358:	0015079b          	addiw	a5,a0,1
    8000535c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005360:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005364:	13596663          	bltu	s2,s5,80005490 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005368:	df043d83          	ld	s11,-528(s0)
    8000536c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005370:	8552                	mv	a0,s4
    80005372:	ffffc097          	auipc	ra,0xffffc
    80005376:	ada080e7          	jalr	-1318(ra) # 80000e4c <strlen>
    8000537a:	0015069b          	addiw	a3,a0,1
    8000537e:	8652                	mv	a2,s4
    80005380:	85ca                	mv	a1,s2
    80005382:	855a                	mv	a0,s6
    80005384:	ffffc097          	auipc	ra,0xffffc
    80005388:	2e6080e7          	jalr	742(ra) # 8000166a <copyout>
    8000538c:	10054663          	bltz	a0,80005498 <exec+0x30a>
    ustack[argc] = sp;
    80005390:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005394:	0485                	addi	s1,s1,1
    80005396:	008d8793          	addi	a5,s11,8
    8000539a:	def43823          	sd	a5,-528(s0)
    8000539e:	008db503          	ld	a0,8(s11)
    800053a2:	c911                	beqz	a0,800053b6 <exec+0x228>
    if(argc >= MAXARG)
    800053a4:	09a1                	addi	s3,s3,8
    800053a6:	fb3c95e3          	bne	s9,s3,80005350 <exec+0x1c2>
  sz = sz1;
    800053aa:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053ae:	4a81                	li	s5,0
    800053b0:	a84d                	j	80005462 <exec+0x2d4>
  sp = sz;
    800053b2:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800053b4:	4481                	li	s1,0
  ustack[argc] = 0;
    800053b6:	00349793          	slli	a5,s1,0x3
    800053ba:	f9078793          	addi	a5,a5,-112
    800053be:	97a2                	add	a5,a5,s0
    800053c0:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800053c4:	00148693          	addi	a3,s1,1
    800053c8:	068e                	slli	a3,a3,0x3
    800053ca:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800053ce:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800053d2:	01597663          	bgeu	s2,s5,800053de <exec+0x250>
  sz = sz1;
    800053d6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053da:	4a81                	li	s5,0
    800053dc:	a059                	j	80005462 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800053de:	e9040613          	addi	a2,s0,-368
    800053e2:	85ca                	mv	a1,s2
    800053e4:	855a                	mv	a0,s6
    800053e6:	ffffc097          	auipc	ra,0xffffc
    800053ea:	284080e7          	jalr	644(ra) # 8000166a <copyout>
    800053ee:	0a054963          	bltz	a0,800054a0 <exec+0x312>
  p->trapframe->a1 = sp;
    800053f2:	058bb783          	ld	a5,88(s7)
    800053f6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800053fa:	de843783          	ld	a5,-536(s0)
    800053fe:	0007c703          	lbu	a4,0(a5)
    80005402:	cf11                	beqz	a4,8000541e <exec+0x290>
    80005404:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005406:	02f00693          	li	a3,47
    8000540a:	a039                	j	80005418 <exec+0x28a>
      last = s+1;
    8000540c:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005410:	0785                	addi	a5,a5,1
    80005412:	fff7c703          	lbu	a4,-1(a5)
    80005416:	c701                	beqz	a4,8000541e <exec+0x290>
    if(*s == '/')
    80005418:	fed71ce3          	bne	a4,a3,80005410 <exec+0x282>
    8000541c:	bfc5                	j	8000540c <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    8000541e:	4641                	li	a2,16
    80005420:	de843583          	ld	a1,-536(s0)
    80005424:	158b8513          	addi	a0,s7,344
    80005428:	ffffc097          	auipc	ra,0xffffc
    8000542c:	9f2080e7          	jalr	-1550(ra) # 80000e1a <safestrcpy>
  oldpagetable = p->pagetable;
    80005430:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80005434:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005438:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000543c:	058bb783          	ld	a5,88(s7)
    80005440:	e6843703          	ld	a4,-408(s0)
    80005444:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005446:	058bb783          	ld	a5,88(s7)
    8000544a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000544e:	85ea                	mv	a1,s10
    80005450:	ffffc097          	auipc	ra,0xffffc
    80005454:	6ba080e7          	jalr	1722(ra) # 80001b0a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005458:	0004851b          	sext.w	a0,s1
    8000545c:	b3f9                	j	8000522a <exec+0x9c>
    8000545e:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005462:	df843583          	ld	a1,-520(s0)
    80005466:	855a                	mv	a0,s6
    80005468:	ffffc097          	auipc	ra,0xffffc
    8000546c:	6a2080e7          	jalr	1698(ra) # 80001b0a <proc_freepagetable>
  if(ip){
    80005470:	da0a93e3          	bnez	s5,80005216 <exec+0x88>
  return -1;
    80005474:	557d                	li	a0,-1
    80005476:	bb55                	j	8000522a <exec+0x9c>
    80005478:	df243c23          	sd	s2,-520(s0)
    8000547c:	b7dd                	j	80005462 <exec+0x2d4>
    8000547e:	df243c23          	sd	s2,-520(s0)
    80005482:	b7c5                	j	80005462 <exec+0x2d4>
    80005484:	df243c23          	sd	s2,-520(s0)
    80005488:	bfe9                	j	80005462 <exec+0x2d4>
    8000548a:	df243c23          	sd	s2,-520(s0)
    8000548e:	bfd1                	j	80005462 <exec+0x2d4>
  sz = sz1;
    80005490:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005494:	4a81                	li	s5,0
    80005496:	b7f1                	j	80005462 <exec+0x2d4>
  sz = sz1;
    80005498:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000549c:	4a81                	li	s5,0
    8000549e:	b7d1                	j	80005462 <exec+0x2d4>
  sz = sz1;
    800054a0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800054a4:	4a81                	li	s5,0
    800054a6:	bf75                	j	80005462 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800054a8:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054ac:	e0843783          	ld	a5,-504(s0)
    800054b0:	0017869b          	addiw	a3,a5,1
    800054b4:	e0d43423          	sd	a3,-504(s0)
    800054b8:	e0043783          	ld	a5,-512(s0)
    800054bc:	0387879b          	addiw	a5,a5,56
    800054c0:	e8845703          	lhu	a4,-376(s0)
    800054c4:	e0e6dfe3          	bge	a3,a4,800052e2 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800054c8:	2781                	sext.w	a5,a5
    800054ca:	e0f43023          	sd	a5,-512(s0)
    800054ce:	03800713          	li	a4,56
    800054d2:	86be                	mv	a3,a5
    800054d4:	e1840613          	addi	a2,s0,-488
    800054d8:	4581                	li	a1,0
    800054da:	8556                	mv	a0,s5
    800054dc:	fffff097          	auipc	ra,0xfffff
    800054e0:	976080e7          	jalr	-1674(ra) # 80003e52 <readi>
    800054e4:	03800793          	li	a5,56
    800054e8:	f6f51be3          	bne	a0,a5,8000545e <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    800054ec:	e1842783          	lw	a5,-488(s0)
    800054f0:	4705                	li	a4,1
    800054f2:	fae79de3          	bne	a5,a4,800054ac <exec+0x31e>
    if(ph.memsz < ph.filesz)
    800054f6:	e4043483          	ld	s1,-448(s0)
    800054fa:	e3843783          	ld	a5,-456(s0)
    800054fe:	f6f4ede3          	bltu	s1,a5,80005478 <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005502:	e2843783          	ld	a5,-472(s0)
    80005506:	94be                	add	s1,s1,a5
    80005508:	f6f4ebe3          	bltu	s1,a5,8000547e <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    8000550c:	de043703          	ld	a4,-544(s0)
    80005510:	8ff9                	and	a5,a5,a4
    80005512:	fbad                	bnez	a5,80005484 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005514:	e1c42503          	lw	a0,-484(s0)
    80005518:	00000097          	auipc	ra,0x0
    8000551c:	c5c080e7          	jalr	-932(ra) # 80005174 <flags2perm>
    80005520:	86aa                	mv	a3,a0
    80005522:	8626                	mv	a2,s1
    80005524:	85ca                	mv	a1,s2
    80005526:	855a                	mv	a0,s6
    80005528:	ffffc097          	auipc	ra,0xffffc
    8000552c:	ee6080e7          	jalr	-282(ra) # 8000140e <uvmalloc>
    80005530:	dea43c23          	sd	a0,-520(s0)
    80005534:	d939                	beqz	a0,8000548a <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005536:	e2843c03          	ld	s8,-472(s0)
    8000553a:	e2042c83          	lw	s9,-480(s0)
    8000553e:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005542:	f60b83e3          	beqz	s7,800054a8 <exec+0x31a>
    80005546:	89de                	mv	s3,s7
    80005548:	4481                	li	s1,0
    8000554a:	bb9d                	j	800052c0 <exec+0x132>

000000008000554c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000554c:	7179                	addi	sp,sp,-48
    8000554e:	f406                	sd	ra,40(sp)
    80005550:	f022                	sd	s0,32(sp)
    80005552:	ec26                	sd	s1,24(sp)
    80005554:	e84a                	sd	s2,16(sp)
    80005556:	1800                	addi	s0,sp,48
    80005558:	892e                	mv	s2,a1
    8000555a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000555c:	fdc40593          	addi	a1,s0,-36
    80005560:	ffffd097          	auipc	ra,0xffffd
    80005564:	630080e7          	jalr	1584(ra) # 80002b90 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005568:	fdc42703          	lw	a4,-36(s0)
    8000556c:	47bd                	li	a5,15
    8000556e:	02e7eb63          	bltu	a5,a4,800055a4 <argfd+0x58>
    80005572:	ffffc097          	auipc	ra,0xffffc
    80005576:	438080e7          	jalr	1080(ra) # 800019aa <myproc>
    8000557a:	fdc42703          	lw	a4,-36(s0)
    8000557e:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdb5ba>
    80005582:	078e                	slli	a5,a5,0x3
    80005584:	953e                	add	a0,a0,a5
    80005586:	611c                	ld	a5,0(a0)
    80005588:	c385                	beqz	a5,800055a8 <argfd+0x5c>
    return -1;
  if(pfd)
    8000558a:	00090463          	beqz	s2,80005592 <argfd+0x46>
    *pfd = fd;
    8000558e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005592:	4501                	li	a0,0
  if(pf)
    80005594:	c091                	beqz	s1,80005598 <argfd+0x4c>
    *pf = f;
    80005596:	e09c                	sd	a5,0(s1)
}
    80005598:	70a2                	ld	ra,40(sp)
    8000559a:	7402                	ld	s0,32(sp)
    8000559c:	64e2                	ld	s1,24(sp)
    8000559e:	6942                	ld	s2,16(sp)
    800055a0:	6145                	addi	sp,sp,48
    800055a2:	8082                	ret
    return -1;
    800055a4:	557d                	li	a0,-1
    800055a6:	bfcd                	j	80005598 <argfd+0x4c>
    800055a8:	557d                	li	a0,-1
    800055aa:	b7fd                	j	80005598 <argfd+0x4c>

00000000800055ac <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800055ac:	1101                	addi	sp,sp,-32
    800055ae:	ec06                	sd	ra,24(sp)
    800055b0:	e822                	sd	s0,16(sp)
    800055b2:	e426                	sd	s1,8(sp)
    800055b4:	1000                	addi	s0,sp,32
    800055b6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800055b8:	ffffc097          	auipc	ra,0xffffc
    800055bc:	3f2080e7          	jalr	1010(ra) # 800019aa <myproc>
    800055c0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800055c2:	0d050793          	addi	a5,a0,208
    800055c6:	4501                	li	a0,0
    800055c8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800055ca:	6398                	ld	a4,0(a5)
    800055cc:	cb19                	beqz	a4,800055e2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800055ce:	2505                	addiw	a0,a0,1
    800055d0:	07a1                	addi	a5,a5,8
    800055d2:	fed51ce3          	bne	a0,a3,800055ca <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800055d6:	557d                	li	a0,-1
}
    800055d8:	60e2                	ld	ra,24(sp)
    800055da:	6442                	ld	s0,16(sp)
    800055dc:	64a2                	ld	s1,8(sp)
    800055de:	6105                	addi	sp,sp,32
    800055e0:	8082                	ret
      p->ofile[fd] = f;
    800055e2:	01a50793          	addi	a5,a0,26
    800055e6:	078e                	slli	a5,a5,0x3
    800055e8:	963e                	add	a2,a2,a5
    800055ea:	e204                	sd	s1,0(a2)
      return fd;
    800055ec:	b7f5                	j	800055d8 <fdalloc+0x2c>

00000000800055ee <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800055ee:	715d                	addi	sp,sp,-80
    800055f0:	e486                	sd	ra,72(sp)
    800055f2:	e0a2                	sd	s0,64(sp)
    800055f4:	fc26                	sd	s1,56(sp)
    800055f6:	f84a                	sd	s2,48(sp)
    800055f8:	f44e                	sd	s3,40(sp)
    800055fa:	f052                	sd	s4,32(sp)
    800055fc:	ec56                	sd	s5,24(sp)
    800055fe:	e85a                	sd	s6,16(sp)
    80005600:	0880                	addi	s0,sp,80
    80005602:	8b2e                	mv	s6,a1
    80005604:	89b2                	mv	s3,a2
    80005606:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005608:	fb040593          	addi	a1,s0,-80
    8000560c:	fffff097          	auipc	ra,0xfffff
    80005610:	d5c080e7          	jalr	-676(ra) # 80004368 <nameiparent>
    80005614:	84aa                	mv	s1,a0
    80005616:	14050f63          	beqz	a0,80005774 <create+0x186>
    return 0;

  ilock(dp);
    8000561a:	ffffe097          	auipc	ra,0xffffe
    8000561e:	584080e7          	jalr	1412(ra) # 80003b9e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005622:	4601                	li	a2,0
    80005624:	fb040593          	addi	a1,s0,-80
    80005628:	8526                	mv	a0,s1
    8000562a:	fffff097          	auipc	ra,0xfffff
    8000562e:	a58080e7          	jalr	-1448(ra) # 80004082 <dirlookup>
    80005632:	8aaa                	mv	s5,a0
    80005634:	c931                	beqz	a0,80005688 <create+0x9a>
    iunlockput(dp);
    80005636:	8526                	mv	a0,s1
    80005638:	ffffe097          	auipc	ra,0xffffe
    8000563c:	7c8080e7          	jalr	1992(ra) # 80003e00 <iunlockput>
    ilock(ip);
    80005640:	8556                	mv	a0,s5
    80005642:	ffffe097          	auipc	ra,0xffffe
    80005646:	55c080e7          	jalr	1372(ra) # 80003b9e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000564a:	000b059b          	sext.w	a1,s6
    8000564e:	4789                	li	a5,2
    80005650:	02f59563          	bne	a1,a5,8000567a <create+0x8c>
    80005654:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdb5e4>
    80005658:	37f9                	addiw	a5,a5,-2
    8000565a:	17c2                	slli	a5,a5,0x30
    8000565c:	93c1                	srli	a5,a5,0x30
    8000565e:	4705                	li	a4,1
    80005660:	00f76d63          	bltu	a4,a5,8000567a <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005664:	8556                	mv	a0,s5
    80005666:	60a6                	ld	ra,72(sp)
    80005668:	6406                	ld	s0,64(sp)
    8000566a:	74e2                	ld	s1,56(sp)
    8000566c:	7942                	ld	s2,48(sp)
    8000566e:	79a2                	ld	s3,40(sp)
    80005670:	7a02                	ld	s4,32(sp)
    80005672:	6ae2                	ld	s5,24(sp)
    80005674:	6b42                	ld	s6,16(sp)
    80005676:	6161                	addi	sp,sp,80
    80005678:	8082                	ret
    iunlockput(ip);
    8000567a:	8556                	mv	a0,s5
    8000567c:	ffffe097          	auipc	ra,0xffffe
    80005680:	784080e7          	jalr	1924(ra) # 80003e00 <iunlockput>
    return 0;
    80005684:	4a81                	li	s5,0
    80005686:	bff9                	j	80005664 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005688:	85da                	mv	a1,s6
    8000568a:	4088                	lw	a0,0(s1)
    8000568c:	ffffe097          	auipc	ra,0xffffe
    80005690:	374080e7          	jalr	884(ra) # 80003a00 <ialloc>
    80005694:	8a2a                	mv	s4,a0
    80005696:	c539                	beqz	a0,800056e4 <create+0xf6>
  ilock(ip);
    80005698:	ffffe097          	auipc	ra,0xffffe
    8000569c:	506080e7          	jalr	1286(ra) # 80003b9e <ilock>
  ip->major = major;
    800056a0:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800056a4:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800056a8:	4905                	li	s2,1
    800056aa:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800056ae:	8552                	mv	a0,s4
    800056b0:	ffffe097          	auipc	ra,0xffffe
    800056b4:	422080e7          	jalr	1058(ra) # 80003ad2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800056b8:	000b059b          	sext.w	a1,s6
    800056bc:	03258b63          	beq	a1,s2,800056f2 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800056c0:	004a2603          	lw	a2,4(s4)
    800056c4:	fb040593          	addi	a1,s0,-80
    800056c8:	8526                	mv	a0,s1
    800056ca:	fffff097          	auipc	ra,0xfffff
    800056ce:	bce080e7          	jalr	-1074(ra) # 80004298 <dirlink>
    800056d2:	06054f63          	bltz	a0,80005750 <create+0x162>
  iunlockput(dp);
    800056d6:	8526                	mv	a0,s1
    800056d8:	ffffe097          	auipc	ra,0xffffe
    800056dc:	728080e7          	jalr	1832(ra) # 80003e00 <iunlockput>
  return ip;
    800056e0:	8ad2                	mv	s5,s4
    800056e2:	b749                	j	80005664 <create+0x76>
    iunlockput(dp);
    800056e4:	8526                	mv	a0,s1
    800056e6:	ffffe097          	auipc	ra,0xffffe
    800056ea:	71a080e7          	jalr	1818(ra) # 80003e00 <iunlockput>
    return 0;
    800056ee:	8ad2                	mv	s5,s4
    800056f0:	bf95                	j	80005664 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800056f2:	004a2603          	lw	a2,4(s4)
    800056f6:	00004597          	auipc	a1,0x4
    800056fa:	10a58593          	addi	a1,a1,266 # 80009800 <syscalls+0x3b0>
    800056fe:	8552                	mv	a0,s4
    80005700:	fffff097          	auipc	ra,0xfffff
    80005704:	b98080e7          	jalr	-1128(ra) # 80004298 <dirlink>
    80005708:	04054463          	bltz	a0,80005750 <create+0x162>
    8000570c:	40d0                	lw	a2,4(s1)
    8000570e:	00004597          	auipc	a1,0x4
    80005712:	0fa58593          	addi	a1,a1,250 # 80009808 <syscalls+0x3b8>
    80005716:	8552                	mv	a0,s4
    80005718:	fffff097          	auipc	ra,0xfffff
    8000571c:	b80080e7          	jalr	-1152(ra) # 80004298 <dirlink>
    80005720:	02054863          	bltz	a0,80005750 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80005724:	004a2603          	lw	a2,4(s4)
    80005728:	fb040593          	addi	a1,s0,-80
    8000572c:	8526                	mv	a0,s1
    8000572e:	fffff097          	auipc	ra,0xfffff
    80005732:	b6a080e7          	jalr	-1174(ra) # 80004298 <dirlink>
    80005736:	00054d63          	bltz	a0,80005750 <create+0x162>
    dp->nlink++;  // for ".."
    8000573a:	04a4d783          	lhu	a5,74(s1)
    8000573e:	2785                	addiw	a5,a5,1
    80005740:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005744:	8526                	mv	a0,s1
    80005746:	ffffe097          	auipc	ra,0xffffe
    8000574a:	38c080e7          	jalr	908(ra) # 80003ad2 <iupdate>
    8000574e:	b761                	j	800056d6 <create+0xe8>
  ip->nlink = 0;
    80005750:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005754:	8552                	mv	a0,s4
    80005756:	ffffe097          	auipc	ra,0xffffe
    8000575a:	37c080e7          	jalr	892(ra) # 80003ad2 <iupdate>
  iunlockput(ip);
    8000575e:	8552                	mv	a0,s4
    80005760:	ffffe097          	auipc	ra,0xffffe
    80005764:	6a0080e7          	jalr	1696(ra) # 80003e00 <iunlockput>
  iunlockput(dp);
    80005768:	8526                	mv	a0,s1
    8000576a:	ffffe097          	auipc	ra,0xffffe
    8000576e:	696080e7          	jalr	1686(ra) # 80003e00 <iunlockput>
  return 0;
    80005772:	bdcd                	j	80005664 <create+0x76>
    return 0;
    80005774:	8aaa                	mv	s5,a0
    80005776:	b5fd                	j	80005664 <create+0x76>

0000000080005778 <sys_dup>:
{
    80005778:	7179                	addi	sp,sp,-48
    8000577a:	f406                	sd	ra,40(sp)
    8000577c:	f022                	sd	s0,32(sp)
    8000577e:	ec26                	sd	s1,24(sp)
    80005780:	e84a                	sd	s2,16(sp)
    80005782:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005784:	fd840613          	addi	a2,s0,-40
    80005788:	4581                	li	a1,0
    8000578a:	4501                	li	a0,0
    8000578c:	00000097          	auipc	ra,0x0
    80005790:	dc0080e7          	jalr	-576(ra) # 8000554c <argfd>
    return -1;
    80005794:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005796:	02054363          	bltz	a0,800057bc <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000579a:	fd843903          	ld	s2,-40(s0)
    8000579e:	854a                	mv	a0,s2
    800057a0:	00000097          	auipc	ra,0x0
    800057a4:	e0c080e7          	jalr	-500(ra) # 800055ac <fdalloc>
    800057a8:	84aa                	mv	s1,a0
    return -1;
    800057aa:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800057ac:	00054863          	bltz	a0,800057bc <sys_dup+0x44>
  filedup(f);
    800057b0:	854a                	mv	a0,s2
    800057b2:	fffff097          	auipc	ra,0xfffff
    800057b6:	22e080e7          	jalr	558(ra) # 800049e0 <filedup>
  return fd;
    800057ba:	87a6                	mv	a5,s1
}
    800057bc:	853e                	mv	a0,a5
    800057be:	70a2                	ld	ra,40(sp)
    800057c0:	7402                	ld	s0,32(sp)
    800057c2:	64e2                	ld	s1,24(sp)
    800057c4:	6942                	ld	s2,16(sp)
    800057c6:	6145                	addi	sp,sp,48
    800057c8:	8082                	ret

00000000800057ca <sys_read>:
{
    800057ca:	7179                	addi	sp,sp,-48
    800057cc:	f406                	sd	ra,40(sp)
    800057ce:	f022                	sd	s0,32(sp)
    800057d0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800057d2:	fd840593          	addi	a1,s0,-40
    800057d6:	4505                	li	a0,1
    800057d8:	ffffd097          	auipc	ra,0xffffd
    800057dc:	3d8080e7          	jalr	984(ra) # 80002bb0 <argaddr>
  argint(2, &n);
    800057e0:	fe440593          	addi	a1,s0,-28
    800057e4:	4509                	li	a0,2
    800057e6:	ffffd097          	auipc	ra,0xffffd
    800057ea:	3aa080e7          	jalr	938(ra) # 80002b90 <argint>
  if(argfd(0, 0, &f) < 0)
    800057ee:	fe840613          	addi	a2,s0,-24
    800057f2:	4581                	li	a1,0
    800057f4:	4501                	li	a0,0
    800057f6:	00000097          	auipc	ra,0x0
    800057fa:	d56080e7          	jalr	-682(ra) # 8000554c <argfd>
    800057fe:	87aa                	mv	a5,a0
    return -1;
    80005800:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005802:	0007cc63          	bltz	a5,8000581a <sys_read+0x50>
  return fileread(f, p, n);
    80005806:	fe442603          	lw	a2,-28(s0)
    8000580a:	fd843583          	ld	a1,-40(s0)
    8000580e:	fe843503          	ld	a0,-24(s0)
    80005812:	fffff097          	auipc	ra,0xfffff
    80005816:	35a080e7          	jalr	858(ra) # 80004b6c <fileread>
}
    8000581a:	70a2                	ld	ra,40(sp)
    8000581c:	7402                	ld	s0,32(sp)
    8000581e:	6145                	addi	sp,sp,48
    80005820:	8082                	ret

0000000080005822 <sys_write>:
{
    80005822:	7179                	addi	sp,sp,-48
    80005824:	f406                	sd	ra,40(sp)
    80005826:	f022                	sd	s0,32(sp)
    80005828:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000582a:	fd840593          	addi	a1,s0,-40
    8000582e:	4505                	li	a0,1
    80005830:	ffffd097          	auipc	ra,0xffffd
    80005834:	380080e7          	jalr	896(ra) # 80002bb0 <argaddr>
  argint(2, &n);
    80005838:	fe440593          	addi	a1,s0,-28
    8000583c:	4509                	li	a0,2
    8000583e:	ffffd097          	auipc	ra,0xffffd
    80005842:	352080e7          	jalr	850(ra) # 80002b90 <argint>
  if(argfd(0, 0, &f) < 0)
    80005846:	fe840613          	addi	a2,s0,-24
    8000584a:	4581                	li	a1,0
    8000584c:	4501                	li	a0,0
    8000584e:	00000097          	auipc	ra,0x0
    80005852:	cfe080e7          	jalr	-770(ra) # 8000554c <argfd>
    80005856:	87aa                	mv	a5,a0
    return -1;
    80005858:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000585a:	0007cc63          	bltz	a5,80005872 <sys_write+0x50>
  return filewrite(f, p, n);
    8000585e:	fe442603          	lw	a2,-28(s0)
    80005862:	fd843583          	ld	a1,-40(s0)
    80005866:	fe843503          	ld	a0,-24(s0)
    8000586a:	fffff097          	auipc	ra,0xfffff
    8000586e:	3c4080e7          	jalr	964(ra) # 80004c2e <filewrite>
}
    80005872:	70a2                	ld	ra,40(sp)
    80005874:	7402                	ld	s0,32(sp)
    80005876:	6145                	addi	sp,sp,48
    80005878:	8082                	ret

000000008000587a <sys_close>:
{
    8000587a:	1101                	addi	sp,sp,-32
    8000587c:	ec06                	sd	ra,24(sp)
    8000587e:	e822                	sd	s0,16(sp)
    80005880:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005882:	fe040613          	addi	a2,s0,-32
    80005886:	fec40593          	addi	a1,s0,-20
    8000588a:	4501                	li	a0,0
    8000588c:	00000097          	auipc	ra,0x0
    80005890:	cc0080e7          	jalr	-832(ra) # 8000554c <argfd>
    return -1;
    80005894:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005896:	02054463          	bltz	a0,800058be <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000589a:	ffffc097          	auipc	ra,0xffffc
    8000589e:	110080e7          	jalr	272(ra) # 800019aa <myproc>
    800058a2:	fec42783          	lw	a5,-20(s0)
    800058a6:	07e9                	addi	a5,a5,26
    800058a8:	078e                	slli	a5,a5,0x3
    800058aa:	953e                	add	a0,a0,a5
    800058ac:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800058b0:	fe043503          	ld	a0,-32(s0)
    800058b4:	fffff097          	auipc	ra,0xfffff
    800058b8:	17e080e7          	jalr	382(ra) # 80004a32 <fileclose>
  return 0;
    800058bc:	4781                	li	a5,0
}
    800058be:	853e                	mv	a0,a5
    800058c0:	60e2                	ld	ra,24(sp)
    800058c2:	6442                	ld	s0,16(sp)
    800058c4:	6105                	addi	sp,sp,32
    800058c6:	8082                	ret

00000000800058c8 <sys_fstat>:
{
    800058c8:	1101                	addi	sp,sp,-32
    800058ca:	ec06                	sd	ra,24(sp)
    800058cc:	e822                	sd	s0,16(sp)
    800058ce:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800058d0:	fe040593          	addi	a1,s0,-32
    800058d4:	4505                	li	a0,1
    800058d6:	ffffd097          	auipc	ra,0xffffd
    800058da:	2da080e7          	jalr	730(ra) # 80002bb0 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800058de:	fe840613          	addi	a2,s0,-24
    800058e2:	4581                	li	a1,0
    800058e4:	4501                	li	a0,0
    800058e6:	00000097          	auipc	ra,0x0
    800058ea:	c66080e7          	jalr	-922(ra) # 8000554c <argfd>
    800058ee:	87aa                	mv	a5,a0
    return -1;
    800058f0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058f2:	0007ca63          	bltz	a5,80005906 <sys_fstat+0x3e>
  return filestat(f, st);
    800058f6:	fe043583          	ld	a1,-32(s0)
    800058fa:	fe843503          	ld	a0,-24(s0)
    800058fe:	fffff097          	auipc	ra,0xfffff
    80005902:	1fc080e7          	jalr	508(ra) # 80004afa <filestat>
}
    80005906:	60e2                	ld	ra,24(sp)
    80005908:	6442                	ld	s0,16(sp)
    8000590a:	6105                	addi	sp,sp,32
    8000590c:	8082                	ret

000000008000590e <sys_link>:
{
    8000590e:	7169                	addi	sp,sp,-304
    80005910:	f606                	sd	ra,296(sp)
    80005912:	f222                	sd	s0,288(sp)
    80005914:	ee26                	sd	s1,280(sp)
    80005916:	ea4a                	sd	s2,272(sp)
    80005918:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000591a:	08000613          	li	a2,128
    8000591e:	ed040593          	addi	a1,s0,-304
    80005922:	4501                	li	a0,0
    80005924:	ffffd097          	auipc	ra,0xffffd
    80005928:	2ac080e7          	jalr	684(ra) # 80002bd0 <argstr>
    return -1;
    8000592c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000592e:	10054e63          	bltz	a0,80005a4a <sys_link+0x13c>
    80005932:	08000613          	li	a2,128
    80005936:	f5040593          	addi	a1,s0,-176
    8000593a:	4505                	li	a0,1
    8000593c:	ffffd097          	auipc	ra,0xffffd
    80005940:	294080e7          	jalr	660(ra) # 80002bd0 <argstr>
    return -1;
    80005944:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005946:	10054263          	bltz	a0,80005a4a <sys_link+0x13c>
  begin_op();
    8000594a:	fffff097          	auipc	ra,0xfffff
    8000594e:	c20080e7          	jalr	-992(ra) # 8000456a <begin_op>
  if((ip = namei(old)) == 0){
    80005952:	ed040513          	addi	a0,s0,-304
    80005956:	fffff097          	auipc	ra,0xfffff
    8000595a:	9f4080e7          	jalr	-1548(ra) # 8000434a <namei>
    8000595e:	84aa                	mv	s1,a0
    80005960:	c551                	beqz	a0,800059ec <sys_link+0xde>
  ilock(ip);
    80005962:	ffffe097          	auipc	ra,0xffffe
    80005966:	23c080e7          	jalr	572(ra) # 80003b9e <ilock>
  if(ip->type == T_DIR){
    8000596a:	04449703          	lh	a4,68(s1)
    8000596e:	4785                	li	a5,1
    80005970:	08f70463          	beq	a4,a5,800059f8 <sys_link+0xea>
  ip->nlink++;
    80005974:	04a4d783          	lhu	a5,74(s1)
    80005978:	2785                	addiw	a5,a5,1
    8000597a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000597e:	8526                	mv	a0,s1
    80005980:	ffffe097          	auipc	ra,0xffffe
    80005984:	152080e7          	jalr	338(ra) # 80003ad2 <iupdate>
  iunlock(ip);
    80005988:	8526                	mv	a0,s1
    8000598a:	ffffe097          	auipc	ra,0xffffe
    8000598e:	2d6080e7          	jalr	726(ra) # 80003c60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005992:	fd040593          	addi	a1,s0,-48
    80005996:	f5040513          	addi	a0,s0,-176
    8000599a:	fffff097          	auipc	ra,0xfffff
    8000599e:	9ce080e7          	jalr	-1586(ra) # 80004368 <nameiparent>
    800059a2:	892a                	mv	s2,a0
    800059a4:	c935                	beqz	a0,80005a18 <sys_link+0x10a>
  ilock(dp);
    800059a6:	ffffe097          	auipc	ra,0xffffe
    800059aa:	1f8080e7          	jalr	504(ra) # 80003b9e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800059ae:	00092703          	lw	a4,0(s2)
    800059b2:	409c                	lw	a5,0(s1)
    800059b4:	04f71d63          	bne	a4,a5,80005a0e <sys_link+0x100>
    800059b8:	40d0                	lw	a2,4(s1)
    800059ba:	fd040593          	addi	a1,s0,-48
    800059be:	854a                	mv	a0,s2
    800059c0:	fffff097          	auipc	ra,0xfffff
    800059c4:	8d8080e7          	jalr	-1832(ra) # 80004298 <dirlink>
    800059c8:	04054363          	bltz	a0,80005a0e <sys_link+0x100>
  iunlockput(dp);
    800059cc:	854a                	mv	a0,s2
    800059ce:	ffffe097          	auipc	ra,0xffffe
    800059d2:	432080e7          	jalr	1074(ra) # 80003e00 <iunlockput>
  iput(ip);
    800059d6:	8526                	mv	a0,s1
    800059d8:	ffffe097          	auipc	ra,0xffffe
    800059dc:	380080e7          	jalr	896(ra) # 80003d58 <iput>
  end_op();
    800059e0:	fffff097          	auipc	ra,0xfffff
    800059e4:	c08080e7          	jalr	-1016(ra) # 800045e8 <end_op>
  return 0;
    800059e8:	4781                	li	a5,0
    800059ea:	a085                	j	80005a4a <sys_link+0x13c>
    end_op();
    800059ec:	fffff097          	auipc	ra,0xfffff
    800059f0:	bfc080e7          	jalr	-1028(ra) # 800045e8 <end_op>
    return -1;
    800059f4:	57fd                	li	a5,-1
    800059f6:	a891                	j	80005a4a <sys_link+0x13c>
    iunlockput(ip);
    800059f8:	8526                	mv	a0,s1
    800059fa:	ffffe097          	auipc	ra,0xffffe
    800059fe:	406080e7          	jalr	1030(ra) # 80003e00 <iunlockput>
    end_op();
    80005a02:	fffff097          	auipc	ra,0xfffff
    80005a06:	be6080e7          	jalr	-1050(ra) # 800045e8 <end_op>
    return -1;
    80005a0a:	57fd                	li	a5,-1
    80005a0c:	a83d                	j	80005a4a <sys_link+0x13c>
    iunlockput(dp);
    80005a0e:	854a                	mv	a0,s2
    80005a10:	ffffe097          	auipc	ra,0xffffe
    80005a14:	3f0080e7          	jalr	1008(ra) # 80003e00 <iunlockput>
  ilock(ip);
    80005a18:	8526                	mv	a0,s1
    80005a1a:	ffffe097          	auipc	ra,0xffffe
    80005a1e:	184080e7          	jalr	388(ra) # 80003b9e <ilock>
  ip->nlink--;
    80005a22:	04a4d783          	lhu	a5,74(s1)
    80005a26:	37fd                	addiw	a5,a5,-1
    80005a28:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a2c:	8526                	mv	a0,s1
    80005a2e:	ffffe097          	auipc	ra,0xffffe
    80005a32:	0a4080e7          	jalr	164(ra) # 80003ad2 <iupdate>
  iunlockput(ip);
    80005a36:	8526                	mv	a0,s1
    80005a38:	ffffe097          	auipc	ra,0xffffe
    80005a3c:	3c8080e7          	jalr	968(ra) # 80003e00 <iunlockput>
  end_op();
    80005a40:	fffff097          	auipc	ra,0xfffff
    80005a44:	ba8080e7          	jalr	-1112(ra) # 800045e8 <end_op>
  return -1;
    80005a48:	57fd                	li	a5,-1
}
    80005a4a:	853e                	mv	a0,a5
    80005a4c:	70b2                	ld	ra,296(sp)
    80005a4e:	7412                	ld	s0,288(sp)
    80005a50:	64f2                	ld	s1,280(sp)
    80005a52:	6952                	ld	s2,272(sp)
    80005a54:	6155                	addi	sp,sp,304
    80005a56:	8082                	ret

0000000080005a58 <sys_unlink>:
{
    80005a58:	7151                	addi	sp,sp,-240
    80005a5a:	f586                	sd	ra,232(sp)
    80005a5c:	f1a2                	sd	s0,224(sp)
    80005a5e:	eda6                	sd	s1,216(sp)
    80005a60:	e9ca                	sd	s2,208(sp)
    80005a62:	e5ce                	sd	s3,200(sp)
    80005a64:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005a66:	08000613          	li	a2,128
    80005a6a:	f3040593          	addi	a1,s0,-208
    80005a6e:	4501                	li	a0,0
    80005a70:	ffffd097          	auipc	ra,0xffffd
    80005a74:	160080e7          	jalr	352(ra) # 80002bd0 <argstr>
    80005a78:	18054163          	bltz	a0,80005bfa <sys_unlink+0x1a2>
  begin_op();
    80005a7c:	fffff097          	auipc	ra,0xfffff
    80005a80:	aee080e7          	jalr	-1298(ra) # 8000456a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005a84:	fb040593          	addi	a1,s0,-80
    80005a88:	f3040513          	addi	a0,s0,-208
    80005a8c:	fffff097          	auipc	ra,0xfffff
    80005a90:	8dc080e7          	jalr	-1828(ra) # 80004368 <nameiparent>
    80005a94:	84aa                	mv	s1,a0
    80005a96:	c979                	beqz	a0,80005b6c <sys_unlink+0x114>
  ilock(dp);
    80005a98:	ffffe097          	auipc	ra,0xffffe
    80005a9c:	106080e7          	jalr	262(ra) # 80003b9e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005aa0:	00004597          	auipc	a1,0x4
    80005aa4:	d6058593          	addi	a1,a1,-672 # 80009800 <syscalls+0x3b0>
    80005aa8:	fb040513          	addi	a0,s0,-80
    80005aac:	ffffe097          	auipc	ra,0xffffe
    80005ab0:	5bc080e7          	jalr	1468(ra) # 80004068 <namecmp>
    80005ab4:	14050a63          	beqz	a0,80005c08 <sys_unlink+0x1b0>
    80005ab8:	00004597          	auipc	a1,0x4
    80005abc:	d5058593          	addi	a1,a1,-688 # 80009808 <syscalls+0x3b8>
    80005ac0:	fb040513          	addi	a0,s0,-80
    80005ac4:	ffffe097          	auipc	ra,0xffffe
    80005ac8:	5a4080e7          	jalr	1444(ra) # 80004068 <namecmp>
    80005acc:	12050e63          	beqz	a0,80005c08 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005ad0:	f2c40613          	addi	a2,s0,-212
    80005ad4:	fb040593          	addi	a1,s0,-80
    80005ad8:	8526                	mv	a0,s1
    80005ada:	ffffe097          	auipc	ra,0xffffe
    80005ade:	5a8080e7          	jalr	1448(ra) # 80004082 <dirlookup>
    80005ae2:	892a                	mv	s2,a0
    80005ae4:	12050263          	beqz	a0,80005c08 <sys_unlink+0x1b0>
  ilock(ip);
    80005ae8:	ffffe097          	auipc	ra,0xffffe
    80005aec:	0b6080e7          	jalr	182(ra) # 80003b9e <ilock>
  if(ip->nlink < 1)
    80005af0:	04a91783          	lh	a5,74(s2)
    80005af4:	08f05263          	blez	a5,80005b78 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005af8:	04491703          	lh	a4,68(s2)
    80005afc:	4785                	li	a5,1
    80005afe:	08f70563          	beq	a4,a5,80005b88 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005b02:	4641                	li	a2,16
    80005b04:	4581                	li	a1,0
    80005b06:	fc040513          	addi	a0,s0,-64
    80005b0a:	ffffb097          	auipc	ra,0xffffb
    80005b0e:	1c6080e7          	jalr	454(ra) # 80000cd0 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b12:	4741                	li	a4,16
    80005b14:	f2c42683          	lw	a3,-212(s0)
    80005b18:	fc040613          	addi	a2,s0,-64
    80005b1c:	4581                	li	a1,0
    80005b1e:	8526                	mv	a0,s1
    80005b20:	ffffe097          	auipc	ra,0xffffe
    80005b24:	42a080e7          	jalr	1066(ra) # 80003f4a <writei>
    80005b28:	47c1                	li	a5,16
    80005b2a:	0af51563          	bne	a0,a5,80005bd4 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005b2e:	04491703          	lh	a4,68(s2)
    80005b32:	4785                	li	a5,1
    80005b34:	0af70863          	beq	a4,a5,80005be4 <sys_unlink+0x18c>
  iunlockput(dp);
    80005b38:	8526                	mv	a0,s1
    80005b3a:	ffffe097          	auipc	ra,0xffffe
    80005b3e:	2c6080e7          	jalr	710(ra) # 80003e00 <iunlockput>
  ip->nlink--;
    80005b42:	04a95783          	lhu	a5,74(s2)
    80005b46:	37fd                	addiw	a5,a5,-1
    80005b48:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005b4c:	854a                	mv	a0,s2
    80005b4e:	ffffe097          	auipc	ra,0xffffe
    80005b52:	f84080e7          	jalr	-124(ra) # 80003ad2 <iupdate>
  iunlockput(ip);
    80005b56:	854a                	mv	a0,s2
    80005b58:	ffffe097          	auipc	ra,0xffffe
    80005b5c:	2a8080e7          	jalr	680(ra) # 80003e00 <iunlockput>
  end_op();
    80005b60:	fffff097          	auipc	ra,0xfffff
    80005b64:	a88080e7          	jalr	-1400(ra) # 800045e8 <end_op>
  return 0;
    80005b68:	4501                	li	a0,0
    80005b6a:	a84d                	j	80005c1c <sys_unlink+0x1c4>
    end_op();
    80005b6c:	fffff097          	auipc	ra,0xfffff
    80005b70:	a7c080e7          	jalr	-1412(ra) # 800045e8 <end_op>
    return -1;
    80005b74:	557d                	li	a0,-1
    80005b76:	a05d                	j	80005c1c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005b78:	00004517          	auipc	a0,0x4
    80005b7c:	c9850513          	addi	a0,a0,-872 # 80009810 <syscalls+0x3c0>
    80005b80:	ffffb097          	auipc	ra,0xffffb
    80005b84:	9be080e7          	jalr	-1602(ra) # 8000053e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005b88:	04c92703          	lw	a4,76(s2)
    80005b8c:	02000793          	li	a5,32
    80005b90:	f6e7f9e3          	bgeu	a5,a4,80005b02 <sys_unlink+0xaa>
    80005b94:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b98:	4741                	li	a4,16
    80005b9a:	86ce                	mv	a3,s3
    80005b9c:	f1840613          	addi	a2,s0,-232
    80005ba0:	4581                	li	a1,0
    80005ba2:	854a                	mv	a0,s2
    80005ba4:	ffffe097          	auipc	ra,0xffffe
    80005ba8:	2ae080e7          	jalr	686(ra) # 80003e52 <readi>
    80005bac:	47c1                	li	a5,16
    80005bae:	00f51b63          	bne	a0,a5,80005bc4 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005bb2:	f1845783          	lhu	a5,-232(s0)
    80005bb6:	e7a1                	bnez	a5,80005bfe <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005bb8:	29c1                	addiw	s3,s3,16
    80005bba:	04c92783          	lw	a5,76(s2)
    80005bbe:	fcf9ede3          	bltu	s3,a5,80005b98 <sys_unlink+0x140>
    80005bc2:	b781                	j	80005b02 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005bc4:	00004517          	auipc	a0,0x4
    80005bc8:	c6450513          	addi	a0,a0,-924 # 80009828 <syscalls+0x3d8>
    80005bcc:	ffffb097          	auipc	ra,0xffffb
    80005bd0:	972080e7          	jalr	-1678(ra) # 8000053e <panic>
    panic("unlink: writei");
    80005bd4:	00004517          	auipc	a0,0x4
    80005bd8:	c6c50513          	addi	a0,a0,-916 # 80009840 <syscalls+0x3f0>
    80005bdc:	ffffb097          	auipc	ra,0xffffb
    80005be0:	962080e7          	jalr	-1694(ra) # 8000053e <panic>
    dp->nlink--;
    80005be4:	04a4d783          	lhu	a5,74(s1)
    80005be8:	37fd                	addiw	a5,a5,-1
    80005bea:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005bee:	8526                	mv	a0,s1
    80005bf0:	ffffe097          	auipc	ra,0xffffe
    80005bf4:	ee2080e7          	jalr	-286(ra) # 80003ad2 <iupdate>
    80005bf8:	b781                	j	80005b38 <sys_unlink+0xe0>
    return -1;
    80005bfa:	557d                	li	a0,-1
    80005bfc:	a005                	j	80005c1c <sys_unlink+0x1c4>
    iunlockput(ip);
    80005bfe:	854a                	mv	a0,s2
    80005c00:	ffffe097          	auipc	ra,0xffffe
    80005c04:	200080e7          	jalr	512(ra) # 80003e00 <iunlockput>
  iunlockput(dp);
    80005c08:	8526                	mv	a0,s1
    80005c0a:	ffffe097          	auipc	ra,0xffffe
    80005c0e:	1f6080e7          	jalr	502(ra) # 80003e00 <iunlockput>
  end_op();
    80005c12:	fffff097          	auipc	ra,0xfffff
    80005c16:	9d6080e7          	jalr	-1578(ra) # 800045e8 <end_op>
  return -1;
    80005c1a:	557d                	li	a0,-1
}
    80005c1c:	70ae                	ld	ra,232(sp)
    80005c1e:	740e                	ld	s0,224(sp)
    80005c20:	64ee                	ld	s1,216(sp)
    80005c22:	694e                	ld	s2,208(sp)
    80005c24:	69ae                	ld	s3,200(sp)
    80005c26:	616d                	addi	sp,sp,240
    80005c28:	8082                	ret

0000000080005c2a <sys_open>:

uint64
sys_open(void)
{
    80005c2a:	7131                	addi	sp,sp,-192
    80005c2c:	fd06                	sd	ra,184(sp)
    80005c2e:	f922                	sd	s0,176(sp)
    80005c30:	f526                	sd	s1,168(sp)
    80005c32:	f14a                	sd	s2,160(sp)
    80005c34:	ed4e                	sd	s3,152(sp)
    80005c36:	0180                	addi	s0,sp,192
  struct file *f;
  struct inode *ip;
  int n;


  argint(1, &omode);
    80005c38:	f4c40593          	addi	a1,s0,-180
    80005c3c:	4505                	li	a0,1
    80005c3e:	ffffd097          	auipc	ra,0xffffd
    80005c42:	f52080e7          	jalr	-174(ra) # 80002b90 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005c46:	08000613          	li	a2,128
    80005c4a:	f5040593          	addi	a1,s0,-176
    80005c4e:	4501                	li	a0,0
    80005c50:	ffffd097          	auipc	ra,0xffffd
    80005c54:	f80080e7          	jalr	-128(ra) # 80002bd0 <argstr>
    80005c58:	87aa                	mv	a5,a0
    return -1;
    80005c5a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005c5c:	1207cc63          	bltz	a5,80005d94 <sys_open+0x16a>

  begin_op();
    80005c60:	fffff097          	auipc	ra,0xfffff
    80005c64:	90a080e7          	jalr	-1782(ra) # 8000456a <begin_op>

  if(omode & O_CREATE){
    80005c68:	f4c42783          	lw	a5,-180(s0)
    80005c6c:	2007f793          	andi	a5,a5,512
    80005c70:	cbbd                	beqz	a5,80005ce6 <sys_open+0xbc>
    ip = create(path, T_FILE, 0, 0);
    80005c72:	4681                	li	a3,0
    80005c74:	4601                	li	a2,0
    80005c76:	4589                	li	a1,2
    80005c78:	f5040513          	addi	a0,s0,-176
    80005c7c:	00000097          	auipc	ra,0x0
    80005c80:	972080e7          	jalr	-1678(ra) # 800055ee <create>
    80005c84:	84aa                	mv	s1,a0
    if(ip == 0){
    80005c86:	c931                	beqz	a0,80005cda <sys_open+0xb0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005c88:	04449703          	lh	a4,68(s1)
    80005c8c:	478d                	li	a5,3
    80005c8e:	00f71763          	bne	a4,a5,80005c9c <sys_open+0x72>
    80005c92:	0464d703          	lhu	a4,70(s1)
    80005c96:	47a5                	li	a5,9
    80005c98:	08e7ec63          	bltu	a5,a4,80005d30 <sys_open+0x106>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005c9c:	fffff097          	auipc	ra,0xfffff
    80005ca0:	cda080e7          	jalr	-806(ra) # 80004976 <filealloc>
    80005ca4:	892a                	mv	s2,a0
    80005ca6:	10050c63          	beqz	a0,80005dbe <sys_open+0x194>
    80005caa:	00000097          	auipc	ra,0x0
    80005cae:	902080e7          	jalr	-1790(ra) # 800055ac <fdalloc>
    80005cb2:	89aa                	mv	s3,a0
    80005cb4:	10054063          	bltz	a0,80005db4 <sys_open+0x18a>
    end_op();
    return -1;
  }


  if(ip->type == T_DEVICE){
    80005cb8:	04449703          	lh	a4,68(s1)
    80005cbc:	478d                	li	a5,3
    80005cbe:	08f70463          	beq	a4,a5,80005d46 <sys_open+0x11c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    
    f->type = FD_INODE;
    80005cc2:	4789                	li	a5,2
    80005cc4:	00f92023          	sw	a5,0(s2)

    if (omode & O_APPEND)
    80005cc8:	f4c42783          	lw	a5,-180(s0)
    80005ccc:	83bd                	srli	a5,a5,0xf
    80005cce:	8b85                	andi	a5,a5,1
    80005cd0:	cbe9                	beqz	a5,80005da2 <sys_open+0x178>
      f->off = ip->size;
    80005cd2:	44fc                	lw	a5,76(s1)
    80005cd4:	02f92023          	sw	a5,32(s2)
    80005cd8:	a8ad                	j	80005d52 <sys_open+0x128>
      end_op();
    80005cda:	fffff097          	auipc	ra,0xfffff
    80005cde:	90e080e7          	jalr	-1778(ra) # 800045e8 <end_op>
      return -1;
    80005ce2:	557d                	li	a0,-1
    80005ce4:	a845                	j	80005d94 <sys_open+0x16a>
    if((ip = namei(path)) == 0){
    80005ce6:	f5040513          	addi	a0,s0,-176
    80005cea:	ffffe097          	auipc	ra,0xffffe
    80005cee:	660080e7          	jalr	1632(ra) # 8000434a <namei>
    80005cf2:	84aa                	mv	s1,a0
    80005cf4:	c905                	beqz	a0,80005d24 <sys_open+0xfa>
    ilock(ip);
    80005cf6:	ffffe097          	auipc	ra,0xffffe
    80005cfa:	ea8080e7          	jalr	-344(ra) # 80003b9e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005cfe:	04449703          	lh	a4,68(s1)
    80005d02:	4785                	li	a5,1
    80005d04:	f8f712e3          	bne	a4,a5,80005c88 <sys_open+0x5e>
    80005d08:	f4c42783          	lw	a5,-180(s0)
    80005d0c:	dbc1                	beqz	a5,80005c9c <sys_open+0x72>
      iunlockput(ip);
    80005d0e:	8526                	mv	a0,s1
    80005d10:	ffffe097          	auipc	ra,0xffffe
    80005d14:	0f0080e7          	jalr	240(ra) # 80003e00 <iunlockput>
      end_op();
    80005d18:	fffff097          	auipc	ra,0xfffff
    80005d1c:	8d0080e7          	jalr	-1840(ra) # 800045e8 <end_op>
      return -1;
    80005d20:	557d                	li	a0,-1
    80005d22:	a88d                	j	80005d94 <sys_open+0x16a>
      end_op();
    80005d24:	fffff097          	auipc	ra,0xfffff
    80005d28:	8c4080e7          	jalr	-1852(ra) # 800045e8 <end_op>
      return -1;
    80005d2c:	557d                	li	a0,-1
    80005d2e:	a09d                	j	80005d94 <sys_open+0x16a>
    iunlockput(ip);
    80005d30:	8526                	mv	a0,s1
    80005d32:	ffffe097          	auipc	ra,0xffffe
    80005d36:	0ce080e7          	jalr	206(ra) # 80003e00 <iunlockput>
    end_op();
    80005d3a:	fffff097          	auipc	ra,0xfffff
    80005d3e:	8ae080e7          	jalr	-1874(ra) # 800045e8 <end_op>
    return -1;
    80005d42:	557d                	li	a0,-1
    80005d44:	a881                	j	80005d94 <sys_open+0x16a>
    f->type = FD_DEVICE;
    80005d46:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005d4a:	04649783          	lh	a5,70(s1)
    80005d4e:	02f91223          	sh	a5,36(s2)
    else
      f->off = 0;
  }
  f->ip = ip;
    80005d52:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005d56:	f4c42783          	lw	a5,-180(s0)
    80005d5a:	0017c713          	xori	a4,a5,1
    80005d5e:	8b05                	andi	a4,a4,1
    80005d60:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005d64:	0037f713          	andi	a4,a5,3
    80005d68:	00e03733          	snez	a4,a4
    80005d6c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005d70:	4007f793          	andi	a5,a5,1024
    80005d74:	c791                	beqz	a5,80005d80 <sys_open+0x156>
    80005d76:	04449703          	lh	a4,68(s1)
    80005d7a:	4789                	li	a5,2
    80005d7c:	02f70663          	beq	a4,a5,80005da8 <sys_open+0x17e>
    itrunc(ip);
  }

  iunlock(ip);
    80005d80:	8526                	mv	a0,s1
    80005d82:	ffffe097          	auipc	ra,0xffffe
    80005d86:	ede080e7          	jalr	-290(ra) # 80003c60 <iunlock>
  end_op();
    80005d8a:	fffff097          	auipc	ra,0xfffff
    80005d8e:	85e080e7          	jalr	-1954(ra) # 800045e8 <end_op>

  return fd;
    80005d92:	854e                	mv	a0,s3
}
    80005d94:	70ea                	ld	ra,184(sp)
    80005d96:	744a                	ld	s0,176(sp)
    80005d98:	74aa                	ld	s1,168(sp)
    80005d9a:	790a                	ld	s2,160(sp)
    80005d9c:	69ea                	ld	s3,152(sp)
    80005d9e:	6129                	addi	sp,sp,192
    80005da0:	8082                	ret
      f->off = 0;
    80005da2:	02092023          	sw	zero,32(s2)
    80005da6:	b775                	j	80005d52 <sys_open+0x128>
    itrunc(ip);
    80005da8:	8526                	mv	a0,s1
    80005daa:	ffffe097          	auipc	ra,0xffffe
    80005dae:	f02080e7          	jalr	-254(ra) # 80003cac <itrunc>
    80005db2:	b7f9                	j	80005d80 <sys_open+0x156>
      fileclose(f);
    80005db4:	854a                	mv	a0,s2
    80005db6:	fffff097          	auipc	ra,0xfffff
    80005dba:	c7c080e7          	jalr	-900(ra) # 80004a32 <fileclose>
    iunlockput(ip);
    80005dbe:	8526                	mv	a0,s1
    80005dc0:	ffffe097          	auipc	ra,0xffffe
    80005dc4:	040080e7          	jalr	64(ra) # 80003e00 <iunlockput>
    end_op();
    80005dc8:	fffff097          	auipc	ra,0xfffff
    80005dcc:	820080e7          	jalr	-2016(ra) # 800045e8 <end_op>
    return -1;
    80005dd0:	557d                	li	a0,-1
    80005dd2:	b7c9                	j	80005d94 <sys_open+0x16a>

0000000080005dd4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005dd4:	7175                	addi	sp,sp,-144
    80005dd6:	e506                	sd	ra,136(sp)
    80005dd8:	e122                	sd	s0,128(sp)
    80005dda:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005ddc:	ffffe097          	auipc	ra,0xffffe
    80005de0:	78e080e7          	jalr	1934(ra) # 8000456a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005de4:	08000613          	li	a2,128
    80005de8:	f7040593          	addi	a1,s0,-144
    80005dec:	4501                	li	a0,0
    80005dee:	ffffd097          	auipc	ra,0xffffd
    80005df2:	de2080e7          	jalr	-542(ra) # 80002bd0 <argstr>
    80005df6:	02054963          	bltz	a0,80005e28 <sys_mkdir+0x54>
    80005dfa:	4681                	li	a3,0
    80005dfc:	4601                	li	a2,0
    80005dfe:	4585                	li	a1,1
    80005e00:	f7040513          	addi	a0,s0,-144
    80005e04:	fffff097          	auipc	ra,0xfffff
    80005e08:	7ea080e7          	jalr	2026(ra) # 800055ee <create>
    80005e0c:	cd11                	beqz	a0,80005e28 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e0e:	ffffe097          	auipc	ra,0xffffe
    80005e12:	ff2080e7          	jalr	-14(ra) # 80003e00 <iunlockput>
  end_op();
    80005e16:	ffffe097          	auipc	ra,0xffffe
    80005e1a:	7d2080e7          	jalr	2002(ra) # 800045e8 <end_op>
  return 0;
    80005e1e:	4501                	li	a0,0
}
    80005e20:	60aa                	ld	ra,136(sp)
    80005e22:	640a                	ld	s0,128(sp)
    80005e24:	6149                	addi	sp,sp,144
    80005e26:	8082                	ret
    end_op();
    80005e28:	ffffe097          	auipc	ra,0xffffe
    80005e2c:	7c0080e7          	jalr	1984(ra) # 800045e8 <end_op>
    return -1;
    80005e30:	557d                	li	a0,-1
    80005e32:	b7fd                	j	80005e20 <sys_mkdir+0x4c>

0000000080005e34 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005e34:	7135                	addi	sp,sp,-160
    80005e36:	ed06                	sd	ra,152(sp)
    80005e38:	e922                	sd	s0,144(sp)
    80005e3a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005e3c:	ffffe097          	auipc	ra,0xffffe
    80005e40:	72e080e7          	jalr	1838(ra) # 8000456a <begin_op>
  argint(1, &major);
    80005e44:	f6c40593          	addi	a1,s0,-148
    80005e48:	4505                	li	a0,1
    80005e4a:	ffffd097          	auipc	ra,0xffffd
    80005e4e:	d46080e7          	jalr	-698(ra) # 80002b90 <argint>
  argint(2, &minor);
    80005e52:	f6840593          	addi	a1,s0,-152
    80005e56:	4509                	li	a0,2
    80005e58:	ffffd097          	auipc	ra,0xffffd
    80005e5c:	d38080e7          	jalr	-712(ra) # 80002b90 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e60:	08000613          	li	a2,128
    80005e64:	f7040593          	addi	a1,s0,-144
    80005e68:	4501                	li	a0,0
    80005e6a:	ffffd097          	auipc	ra,0xffffd
    80005e6e:	d66080e7          	jalr	-666(ra) # 80002bd0 <argstr>
    80005e72:	02054b63          	bltz	a0,80005ea8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005e76:	f6841683          	lh	a3,-152(s0)
    80005e7a:	f6c41603          	lh	a2,-148(s0)
    80005e7e:	458d                	li	a1,3
    80005e80:	f7040513          	addi	a0,s0,-144
    80005e84:	fffff097          	auipc	ra,0xfffff
    80005e88:	76a080e7          	jalr	1898(ra) # 800055ee <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e8c:	cd11                	beqz	a0,80005ea8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e8e:	ffffe097          	auipc	ra,0xffffe
    80005e92:	f72080e7          	jalr	-142(ra) # 80003e00 <iunlockput>
  end_op();
    80005e96:	ffffe097          	auipc	ra,0xffffe
    80005e9a:	752080e7          	jalr	1874(ra) # 800045e8 <end_op>
  return 0;
    80005e9e:	4501                	li	a0,0
}
    80005ea0:	60ea                	ld	ra,152(sp)
    80005ea2:	644a                	ld	s0,144(sp)
    80005ea4:	610d                	addi	sp,sp,160
    80005ea6:	8082                	ret
    end_op();
    80005ea8:	ffffe097          	auipc	ra,0xffffe
    80005eac:	740080e7          	jalr	1856(ra) # 800045e8 <end_op>
    return -1;
    80005eb0:	557d                	li	a0,-1
    80005eb2:	b7fd                	j	80005ea0 <sys_mknod+0x6c>

0000000080005eb4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005eb4:	7135                	addi	sp,sp,-160
    80005eb6:	ed06                	sd	ra,152(sp)
    80005eb8:	e922                	sd	s0,144(sp)
    80005eba:	e526                	sd	s1,136(sp)
    80005ebc:	e14a                	sd	s2,128(sp)
    80005ebe:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005ec0:	ffffc097          	auipc	ra,0xffffc
    80005ec4:	aea080e7          	jalr	-1302(ra) # 800019aa <myproc>
    80005ec8:	892a                	mv	s2,a0
  
  begin_op();
    80005eca:	ffffe097          	auipc	ra,0xffffe
    80005ece:	6a0080e7          	jalr	1696(ra) # 8000456a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005ed2:	08000613          	li	a2,128
    80005ed6:	f6040593          	addi	a1,s0,-160
    80005eda:	4501                	li	a0,0
    80005edc:	ffffd097          	auipc	ra,0xffffd
    80005ee0:	cf4080e7          	jalr	-780(ra) # 80002bd0 <argstr>
    80005ee4:	04054b63          	bltz	a0,80005f3a <sys_chdir+0x86>
    80005ee8:	f6040513          	addi	a0,s0,-160
    80005eec:	ffffe097          	auipc	ra,0xffffe
    80005ef0:	45e080e7          	jalr	1118(ra) # 8000434a <namei>
    80005ef4:	84aa                	mv	s1,a0
    80005ef6:	c131                	beqz	a0,80005f3a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005ef8:	ffffe097          	auipc	ra,0xffffe
    80005efc:	ca6080e7          	jalr	-858(ra) # 80003b9e <ilock>
  if(ip->type != T_DIR){
    80005f00:	04449703          	lh	a4,68(s1)
    80005f04:	4785                	li	a5,1
    80005f06:	04f71063          	bne	a4,a5,80005f46 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005f0a:	8526                	mv	a0,s1
    80005f0c:	ffffe097          	auipc	ra,0xffffe
    80005f10:	d54080e7          	jalr	-684(ra) # 80003c60 <iunlock>
  iput(p->cwd);
    80005f14:	15093503          	ld	a0,336(s2)
    80005f18:	ffffe097          	auipc	ra,0xffffe
    80005f1c:	e40080e7          	jalr	-448(ra) # 80003d58 <iput>
  end_op();
    80005f20:	ffffe097          	auipc	ra,0xffffe
    80005f24:	6c8080e7          	jalr	1736(ra) # 800045e8 <end_op>
  p->cwd = ip;
    80005f28:	14993823          	sd	s1,336(s2)
  return 0;
    80005f2c:	4501                	li	a0,0
}
    80005f2e:	60ea                	ld	ra,152(sp)
    80005f30:	644a                	ld	s0,144(sp)
    80005f32:	64aa                	ld	s1,136(sp)
    80005f34:	690a                	ld	s2,128(sp)
    80005f36:	610d                	addi	sp,sp,160
    80005f38:	8082                	ret
    end_op();
    80005f3a:	ffffe097          	auipc	ra,0xffffe
    80005f3e:	6ae080e7          	jalr	1710(ra) # 800045e8 <end_op>
    return -1;
    80005f42:	557d                	li	a0,-1
    80005f44:	b7ed                	j	80005f2e <sys_chdir+0x7a>
    iunlockput(ip);
    80005f46:	8526                	mv	a0,s1
    80005f48:	ffffe097          	auipc	ra,0xffffe
    80005f4c:	eb8080e7          	jalr	-328(ra) # 80003e00 <iunlockput>
    end_op();
    80005f50:	ffffe097          	auipc	ra,0xffffe
    80005f54:	698080e7          	jalr	1688(ra) # 800045e8 <end_op>
    return -1;
    80005f58:	557d                	li	a0,-1
    80005f5a:	bfd1                	j	80005f2e <sys_chdir+0x7a>

0000000080005f5c <sys_exec>:

uint64
sys_exec(void)
{
    80005f5c:	7145                	addi	sp,sp,-464
    80005f5e:	e786                	sd	ra,456(sp)
    80005f60:	e3a2                	sd	s0,448(sp)
    80005f62:	ff26                	sd	s1,440(sp)
    80005f64:	fb4a                	sd	s2,432(sp)
    80005f66:	f74e                	sd	s3,424(sp)
    80005f68:	f352                	sd	s4,416(sp)
    80005f6a:	ef56                	sd	s5,408(sp)
    80005f6c:	0b80                	addi	s0,sp,464

  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005f6e:	e3840593          	addi	a1,s0,-456
    80005f72:	4505                	li	a0,1
    80005f74:	ffffd097          	auipc	ra,0xffffd
    80005f78:	c3c080e7          	jalr	-964(ra) # 80002bb0 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005f7c:	08000613          	li	a2,128
    80005f80:	f4040593          	addi	a1,s0,-192
    80005f84:	4501                	li	a0,0
    80005f86:	ffffd097          	auipc	ra,0xffffd
    80005f8a:	c4a080e7          	jalr	-950(ra) # 80002bd0 <argstr>
    80005f8e:	87aa                	mv	a5,a0
    return -1;
    80005f90:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005f92:	0c07c363          	bltz	a5,80006058 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80005f96:	10000613          	li	a2,256
    80005f9a:	4581                	li	a1,0
    80005f9c:	e4040513          	addi	a0,s0,-448
    80005fa0:	ffffb097          	auipc	ra,0xffffb
    80005fa4:	d30080e7          	jalr	-720(ra) # 80000cd0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005fa8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005fac:	89a6                	mv	s3,s1
    80005fae:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005fb0:	02000a13          	li	s4,32
    80005fb4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005fb8:	00391513          	slli	a0,s2,0x3
    80005fbc:	e3040593          	addi	a1,s0,-464
    80005fc0:	e3843783          	ld	a5,-456(s0)
    80005fc4:	953e                	add	a0,a0,a5
    80005fc6:	ffffd097          	auipc	ra,0xffffd
    80005fca:	b2c080e7          	jalr	-1236(ra) # 80002af2 <fetchaddr>
    80005fce:	02054a63          	bltz	a0,80006002 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005fd2:	e3043783          	ld	a5,-464(s0)
    80005fd6:	c3b9                	beqz	a5,8000601c <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005fd8:	ffffb097          	auipc	ra,0xffffb
    80005fdc:	b0c080e7          	jalr	-1268(ra) # 80000ae4 <kalloc>
    80005fe0:	85aa                	mv	a1,a0
    80005fe2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005fe6:	cd11                	beqz	a0,80006002 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005fe8:	6605                	lui	a2,0x1
    80005fea:	e3043503          	ld	a0,-464(s0)
    80005fee:	ffffd097          	auipc	ra,0xffffd
    80005ff2:	b56080e7          	jalr	-1194(ra) # 80002b44 <fetchstr>
    80005ff6:	00054663          	bltz	a0,80006002 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005ffa:	0905                	addi	s2,s2,1
    80005ffc:	09a1                	addi	s3,s3,8
    80005ffe:	fb491be3          	bne	s2,s4,80005fb4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006002:	f4040913          	addi	s2,s0,-192
    80006006:	6088                	ld	a0,0(s1)
    80006008:	c539                	beqz	a0,80006056 <sys_exec+0xfa>
    kfree(argv[i]);
    8000600a:	ffffb097          	auipc	ra,0xffffb
    8000600e:	9dc080e7          	jalr	-1572(ra) # 800009e6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006012:	04a1                	addi	s1,s1,8
    80006014:	ff2499e3          	bne	s1,s2,80006006 <sys_exec+0xaa>
  return -1;
    80006018:	557d                	li	a0,-1
    8000601a:	a83d                	j	80006058 <sys_exec+0xfc>
      argv[i] = 0;
    8000601c:	0a8e                	slli	s5,s5,0x3
    8000601e:	fc0a8793          	addi	a5,s5,-64
    80006022:	00878ab3          	add	s5,a5,s0
    80006026:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000602a:	e4040593          	addi	a1,s0,-448
    8000602e:	f4040513          	addi	a0,s0,-192
    80006032:	fffff097          	auipc	ra,0xfffff
    80006036:	15c080e7          	jalr	348(ra) # 8000518e <exec>
    8000603a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000603c:	f4040993          	addi	s3,s0,-192
    80006040:	6088                	ld	a0,0(s1)
    80006042:	c901                	beqz	a0,80006052 <sys_exec+0xf6>
    kfree(argv[i]);
    80006044:	ffffb097          	auipc	ra,0xffffb
    80006048:	9a2080e7          	jalr	-1630(ra) # 800009e6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000604c:	04a1                	addi	s1,s1,8
    8000604e:	ff3499e3          	bne	s1,s3,80006040 <sys_exec+0xe4>
  return ret;
    80006052:	854a                	mv	a0,s2
    80006054:	a011                	j	80006058 <sys_exec+0xfc>
  return -1;
    80006056:	557d                	li	a0,-1
}
    80006058:	60be                	ld	ra,456(sp)
    8000605a:	641e                	ld	s0,448(sp)
    8000605c:	74fa                	ld	s1,440(sp)
    8000605e:	795a                	ld	s2,432(sp)
    80006060:	79ba                	ld	s3,424(sp)
    80006062:	7a1a                	ld	s4,416(sp)
    80006064:	6afa                	ld	s5,408(sp)
    80006066:	6179                	addi	sp,sp,464
    80006068:	8082                	ret

000000008000606a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000606a:	7139                	addi	sp,sp,-64
    8000606c:	fc06                	sd	ra,56(sp)
    8000606e:	f822                	sd	s0,48(sp)
    80006070:	f426                	sd	s1,40(sp)
    80006072:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006074:	ffffc097          	auipc	ra,0xffffc
    80006078:	936080e7          	jalr	-1738(ra) # 800019aa <myproc>
    8000607c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000607e:	fd840593          	addi	a1,s0,-40
    80006082:	4501                	li	a0,0
    80006084:	ffffd097          	auipc	ra,0xffffd
    80006088:	b2c080e7          	jalr	-1236(ra) # 80002bb0 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000608c:	fc840593          	addi	a1,s0,-56
    80006090:	fd040513          	addi	a0,s0,-48
    80006094:	fffff097          	auipc	ra,0xfffff
    80006098:	cce080e7          	jalr	-818(ra) # 80004d62 <pipealloc>
    return -1;
    8000609c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000609e:	0c054463          	bltz	a0,80006166 <sys_pipe+0xfc>
  fd0 = -1;
    800060a2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800060a6:	fd043503          	ld	a0,-48(s0)
    800060aa:	fffff097          	auipc	ra,0xfffff
    800060ae:	502080e7          	jalr	1282(ra) # 800055ac <fdalloc>
    800060b2:	fca42223          	sw	a0,-60(s0)
    800060b6:	08054b63          	bltz	a0,8000614c <sys_pipe+0xe2>
    800060ba:	fc843503          	ld	a0,-56(s0)
    800060be:	fffff097          	auipc	ra,0xfffff
    800060c2:	4ee080e7          	jalr	1262(ra) # 800055ac <fdalloc>
    800060c6:	fca42023          	sw	a0,-64(s0)
    800060ca:	06054863          	bltz	a0,8000613a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800060ce:	4691                	li	a3,4
    800060d0:	fc440613          	addi	a2,s0,-60
    800060d4:	fd843583          	ld	a1,-40(s0)
    800060d8:	68a8                	ld	a0,80(s1)
    800060da:	ffffb097          	auipc	ra,0xffffb
    800060de:	590080e7          	jalr	1424(ra) # 8000166a <copyout>
    800060e2:	02054063          	bltz	a0,80006102 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800060e6:	4691                	li	a3,4
    800060e8:	fc040613          	addi	a2,s0,-64
    800060ec:	fd843583          	ld	a1,-40(s0)
    800060f0:	0591                	addi	a1,a1,4
    800060f2:	68a8                	ld	a0,80(s1)
    800060f4:	ffffb097          	auipc	ra,0xffffb
    800060f8:	576080e7          	jalr	1398(ra) # 8000166a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800060fc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800060fe:	06055463          	bgez	a0,80006166 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006102:	fc442783          	lw	a5,-60(s0)
    80006106:	07e9                	addi	a5,a5,26
    80006108:	078e                	slli	a5,a5,0x3
    8000610a:	97a6                	add	a5,a5,s1
    8000610c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006110:	fc042783          	lw	a5,-64(s0)
    80006114:	07e9                	addi	a5,a5,26
    80006116:	078e                	slli	a5,a5,0x3
    80006118:	94be                	add	s1,s1,a5
    8000611a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000611e:	fd043503          	ld	a0,-48(s0)
    80006122:	fffff097          	auipc	ra,0xfffff
    80006126:	910080e7          	jalr	-1776(ra) # 80004a32 <fileclose>
    fileclose(wf);
    8000612a:	fc843503          	ld	a0,-56(s0)
    8000612e:	fffff097          	auipc	ra,0xfffff
    80006132:	904080e7          	jalr	-1788(ra) # 80004a32 <fileclose>
    return -1;
    80006136:	57fd                	li	a5,-1
    80006138:	a03d                	j	80006166 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000613a:	fc442783          	lw	a5,-60(s0)
    8000613e:	0007c763          	bltz	a5,8000614c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006142:	07e9                	addi	a5,a5,26
    80006144:	078e                	slli	a5,a5,0x3
    80006146:	97a6                	add	a5,a5,s1
    80006148:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000614c:	fd043503          	ld	a0,-48(s0)
    80006150:	fffff097          	auipc	ra,0xfffff
    80006154:	8e2080e7          	jalr	-1822(ra) # 80004a32 <fileclose>
    fileclose(wf);
    80006158:	fc843503          	ld	a0,-56(s0)
    8000615c:	fffff097          	auipc	ra,0xfffff
    80006160:	8d6080e7          	jalr	-1834(ra) # 80004a32 <fileclose>
    return -1;
    80006164:	57fd                	li	a5,-1
}
    80006166:	853e                	mv	a0,a5
    80006168:	70e2                	ld	ra,56(sp)
    8000616a:	7442                	ld	s0,48(sp)
    8000616c:	74a2                	ld	s1,40(sp)
    8000616e:	6121                	addi	sp,sp,64
    80006170:	8082                	ret
	...

0000000080006180 <kernelvec>:
    80006180:	7111                	addi	sp,sp,-256
    80006182:	e006                	sd	ra,0(sp)
    80006184:	e40a                	sd	sp,8(sp)
    80006186:	e80e                	sd	gp,16(sp)
    80006188:	ec12                	sd	tp,24(sp)
    8000618a:	f016                	sd	t0,32(sp)
    8000618c:	f41a                	sd	t1,40(sp)
    8000618e:	f81e                	sd	t2,48(sp)
    80006190:	fc22                	sd	s0,56(sp)
    80006192:	e0a6                	sd	s1,64(sp)
    80006194:	e4aa                	sd	a0,72(sp)
    80006196:	e8ae                	sd	a1,80(sp)
    80006198:	ecb2                	sd	a2,88(sp)
    8000619a:	f0b6                	sd	a3,96(sp)
    8000619c:	f4ba                	sd	a4,104(sp)
    8000619e:	f8be                	sd	a5,112(sp)
    800061a0:	fcc2                	sd	a6,120(sp)
    800061a2:	e146                	sd	a7,128(sp)
    800061a4:	e54a                	sd	s2,136(sp)
    800061a6:	e94e                	sd	s3,144(sp)
    800061a8:	ed52                	sd	s4,152(sp)
    800061aa:	f156                	sd	s5,160(sp)
    800061ac:	f55a                	sd	s6,168(sp)
    800061ae:	f95e                	sd	s7,176(sp)
    800061b0:	fd62                	sd	s8,184(sp)
    800061b2:	e1e6                	sd	s9,192(sp)
    800061b4:	e5ea                	sd	s10,200(sp)
    800061b6:	e9ee                	sd	s11,208(sp)
    800061b8:	edf2                	sd	t3,216(sp)
    800061ba:	f1f6                	sd	t4,224(sp)
    800061bc:	f5fa                	sd	t5,232(sp)
    800061be:	f9fe                	sd	t6,240(sp)
    800061c0:	ffefc0ef          	jal	ra,800029be <kerneltrap>
    800061c4:	6082                	ld	ra,0(sp)
    800061c6:	6122                	ld	sp,8(sp)
    800061c8:	61c2                	ld	gp,16(sp)
    800061ca:	7282                	ld	t0,32(sp)
    800061cc:	7322                	ld	t1,40(sp)
    800061ce:	73c2                	ld	t2,48(sp)
    800061d0:	7462                	ld	s0,56(sp)
    800061d2:	6486                	ld	s1,64(sp)
    800061d4:	6526                	ld	a0,72(sp)
    800061d6:	65c6                	ld	a1,80(sp)
    800061d8:	6666                	ld	a2,88(sp)
    800061da:	7686                	ld	a3,96(sp)
    800061dc:	7726                	ld	a4,104(sp)
    800061de:	77c6                	ld	a5,112(sp)
    800061e0:	7866                	ld	a6,120(sp)
    800061e2:	688a                	ld	a7,128(sp)
    800061e4:	692a                	ld	s2,136(sp)
    800061e6:	69ca                	ld	s3,144(sp)
    800061e8:	6a6a                	ld	s4,152(sp)
    800061ea:	7a8a                	ld	s5,160(sp)
    800061ec:	7b2a                	ld	s6,168(sp)
    800061ee:	7bca                	ld	s7,176(sp)
    800061f0:	7c6a                	ld	s8,184(sp)
    800061f2:	6c8e                	ld	s9,192(sp)
    800061f4:	6d2e                	ld	s10,200(sp)
    800061f6:	6dce                	ld	s11,208(sp)
    800061f8:	6e6e                	ld	t3,216(sp)
    800061fa:	7e8e                	ld	t4,224(sp)
    800061fc:	7f2e                	ld	t5,232(sp)
    800061fe:	7fce                	ld	t6,240(sp)
    80006200:	6111                	addi	sp,sp,256
    80006202:	10200073          	sret
    80006206:	00000013          	nop
    8000620a:	00000013          	nop
    8000620e:	0001                	nop

0000000080006210 <timervec>:
    80006210:	34051573          	csrrw	a0,mscratch,a0
    80006214:	e10c                	sd	a1,0(a0)
    80006216:	e510                	sd	a2,8(a0)
    80006218:	e914                	sd	a3,16(a0)
    8000621a:	6d0c                	ld	a1,24(a0)
    8000621c:	7110                	ld	a2,32(a0)
    8000621e:	6194                	ld	a3,0(a1)
    80006220:	96b2                	add	a3,a3,a2
    80006222:	e194                	sd	a3,0(a1)
    80006224:	4589                	li	a1,2
    80006226:	14459073          	csrw	sip,a1
    8000622a:	6914                	ld	a3,16(a0)
    8000622c:	6510                	ld	a2,8(a0)
    8000622e:	610c                	ld	a1,0(a0)
    80006230:	34051573          	csrrw	a0,mscratch,a0
    80006234:	30200073          	mret
	...

000000008000623a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000623a:	1141                	addi	sp,sp,-16
    8000623c:	e422                	sd	s0,8(sp)
    8000623e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006240:	0c0007b7          	lui	a5,0xc000
    80006244:	4705                	li	a4,1
    80006246:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006248:	c3d8                	sw	a4,4(a5)
}
    8000624a:	6422                	ld	s0,8(sp)
    8000624c:	0141                	addi	sp,sp,16
    8000624e:	8082                	ret

0000000080006250 <plicinithart>:

void
plicinithart(void)
{
    80006250:	1141                	addi	sp,sp,-16
    80006252:	e406                	sd	ra,8(sp)
    80006254:	e022                	sd	s0,0(sp)
    80006256:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006258:	ffffb097          	auipc	ra,0xffffb
    8000625c:	726080e7          	jalr	1830(ra) # 8000197e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006260:	0085171b          	slliw	a4,a0,0x8
    80006264:	0c0027b7          	lui	a5,0xc002
    80006268:	97ba                	add	a5,a5,a4
    8000626a:	40200713          	li	a4,1026
    8000626e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006272:	00d5151b          	slliw	a0,a0,0xd
    80006276:	0c2017b7          	lui	a5,0xc201
    8000627a:	97aa                	add	a5,a5,a0
    8000627c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006280:	60a2                	ld	ra,8(sp)
    80006282:	6402                	ld	s0,0(sp)
    80006284:	0141                	addi	sp,sp,16
    80006286:	8082                	ret

0000000080006288 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006288:	1141                	addi	sp,sp,-16
    8000628a:	e406                	sd	ra,8(sp)
    8000628c:	e022                	sd	s0,0(sp)
    8000628e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006290:	ffffb097          	auipc	ra,0xffffb
    80006294:	6ee080e7          	jalr	1774(ra) # 8000197e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006298:	00d5151b          	slliw	a0,a0,0xd
    8000629c:	0c2017b7          	lui	a5,0xc201
    800062a0:	97aa                	add	a5,a5,a0
  return irq;
}
    800062a2:	43c8                	lw	a0,4(a5)
    800062a4:	60a2                	ld	ra,8(sp)
    800062a6:	6402                	ld	s0,0(sp)
    800062a8:	0141                	addi	sp,sp,16
    800062aa:	8082                	ret

00000000800062ac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800062ac:	1101                	addi	sp,sp,-32
    800062ae:	ec06                	sd	ra,24(sp)
    800062b0:	e822                	sd	s0,16(sp)
    800062b2:	e426                	sd	s1,8(sp)
    800062b4:	1000                	addi	s0,sp,32
    800062b6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800062b8:	ffffb097          	auipc	ra,0xffffb
    800062bc:	6c6080e7          	jalr	1734(ra) # 8000197e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800062c0:	00d5151b          	slliw	a0,a0,0xd
    800062c4:	0c2017b7          	lui	a5,0xc201
    800062c8:	97aa                	add	a5,a5,a0
    800062ca:	c3c4                	sw	s1,4(a5)
}
    800062cc:	60e2                	ld	ra,24(sp)
    800062ce:	6442                	ld	s0,16(sp)
    800062d0:	64a2                	ld	s1,8(sp)
    800062d2:	6105                	addi	sp,sp,32
    800062d4:	8082                	ret

00000000800062d6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800062d6:	1141                	addi	sp,sp,-16
    800062d8:	e406                	sd	ra,8(sp)
    800062da:	e022                	sd	s0,0(sp)
    800062dc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800062de:	479d                	li	a5,7
    800062e0:	04a7cc63          	blt	a5,a0,80006338 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800062e4:	0001d797          	auipc	a5,0x1d
    800062e8:	63c78793          	addi	a5,a5,1596 # 80023920 <disk>
    800062ec:	97aa                	add	a5,a5,a0
    800062ee:	0187c783          	lbu	a5,24(a5)
    800062f2:	ebb9                	bnez	a5,80006348 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800062f4:	00451693          	slli	a3,a0,0x4
    800062f8:	0001d797          	auipc	a5,0x1d
    800062fc:	62878793          	addi	a5,a5,1576 # 80023920 <disk>
    80006300:	6398                	ld	a4,0(a5)
    80006302:	9736                	add	a4,a4,a3
    80006304:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80006308:	6398                	ld	a4,0(a5)
    8000630a:	9736                	add	a4,a4,a3
    8000630c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006310:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006314:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006318:	97aa                	add	a5,a5,a0
    8000631a:	4705                	li	a4,1
    8000631c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006320:	0001d517          	auipc	a0,0x1d
    80006324:	61850513          	addi	a0,a0,1560 # 80023938 <disk+0x18>
    80006328:	ffffc097          	auipc	ra,0xffffc
    8000632c:	e2e080e7          	jalr	-466(ra) # 80002156 <wakeup>
}
    80006330:	60a2                	ld	ra,8(sp)
    80006332:	6402                	ld	s0,0(sp)
    80006334:	0141                	addi	sp,sp,16
    80006336:	8082                	ret
    panic("free_desc 1");
    80006338:	00003517          	auipc	a0,0x3
    8000633c:	51850513          	addi	a0,a0,1304 # 80009850 <syscalls+0x400>
    80006340:	ffffa097          	auipc	ra,0xffffa
    80006344:	1fe080e7          	jalr	510(ra) # 8000053e <panic>
    panic("free_desc 2");
    80006348:	00003517          	auipc	a0,0x3
    8000634c:	51850513          	addi	a0,a0,1304 # 80009860 <syscalls+0x410>
    80006350:	ffffa097          	auipc	ra,0xffffa
    80006354:	1ee080e7          	jalr	494(ra) # 8000053e <panic>

0000000080006358 <virtio_disk_init>:
{
    80006358:	1101                	addi	sp,sp,-32
    8000635a:	ec06                	sd	ra,24(sp)
    8000635c:	e822                	sd	s0,16(sp)
    8000635e:	e426                	sd	s1,8(sp)
    80006360:	e04a                	sd	s2,0(sp)
    80006362:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006364:	00003597          	auipc	a1,0x3
    80006368:	50c58593          	addi	a1,a1,1292 # 80009870 <syscalls+0x420>
    8000636c:	0001d517          	auipc	a0,0x1d
    80006370:	6dc50513          	addi	a0,a0,1756 # 80023a48 <disk+0x128>
    80006374:	ffffa097          	auipc	ra,0xffffa
    80006378:	7d0080e7          	jalr	2000(ra) # 80000b44 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000637c:	100017b7          	lui	a5,0x10001
    80006380:	4398                	lw	a4,0(a5)
    80006382:	2701                	sext.w	a4,a4
    80006384:	747277b7          	lui	a5,0x74727
    80006388:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000638c:	14f71b63          	bne	a4,a5,800064e2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006390:	100017b7          	lui	a5,0x10001
    80006394:	43dc                	lw	a5,4(a5)
    80006396:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006398:	4709                	li	a4,2
    8000639a:	14e79463          	bne	a5,a4,800064e2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000639e:	100017b7          	lui	a5,0x10001
    800063a2:	479c                	lw	a5,8(a5)
    800063a4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800063a6:	12e79e63          	bne	a5,a4,800064e2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800063aa:	100017b7          	lui	a5,0x10001
    800063ae:	47d8                	lw	a4,12(a5)
    800063b0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800063b2:	554d47b7          	lui	a5,0x554d4
    800063b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800063ba:	12f71463          	bne	a4,a5,800064e2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800063be:	100017b7          	lui	a5,0x10001
    800063c2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800063c6:	4705                	li	a4,1
    800063c8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063ca:	470d                	li	a4,3
    800063cc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800063ce:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800063d0:	c7ffe6b7          	lui	a3,0xc7ffe
    800063d4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdacff>
    800063d8:	8f75                	and	a4,a4,a3
    800063da:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063dc:	472d                	li	a4,11
    800063de:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800063e0:	5bbc                	lw	a5,112(a5)
    800063e2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800063e6:	8ba1                	andi	a5,a5,8
    800063e8:	10078563          	beqz	a5,800064f2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800063ec:	100017b7          	lui	a5,0x10001
    800063f0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800063f4:	43fc                	lw	a5,68(a5)
    800063f6:	2781                	sext.w	a5,a5
    800063f8:	10079563          	bnez	a5,80006502 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800063fc:	100017b7          	lui	a5,0x10001
    80006400:	5bdc                	lw	a5,52(a5)
    80006402:	2781                	sext.w	a5,a5
  if(max == 0)
    80006404:	10078763          	beqz	a5,80006512 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80006408:	471d                	li	a4,7
    8000640a:	10f77c63          	bgeu	a4,a5,80006522 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000640e:	ffffa097          	auipc	ra,0xffffa
    80006412:	6d6080e7          	jalr	1750(ra) # 80000ae4 <kalloc>
    80006416:	0001d497          	auipc	s1,0x1d
    8000641a:	50a48493          	addi	s1,s1,1290 # 80023920 <disk>
    8000641e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006420:	ffffa097          	auipc	ra,0xffffa
    80006424:	6c4080e7          	jalr	1732(ra) # 80000ae4 <kalloc>
    80006428:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000642a:	ffffa097          	auipc	ra,0xffffa
    8000642e:	6ba080e7          	jalr	1722(ra) # 80000ae4 <kalloc>
    80006432:	87aa                	mv	a5,a0
    80006434:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006436:	6088                	ld	a0,0(s1)
    80006438:	cd6d                	beqz	a0,80006532 <virtio_disk_init+0x1da>
    8000643a:	0001d717          	auipc	a4,0x1d
    8000643e:	4ee73703          	ld	a4,1262(a4) # 80023928 <disk+0x8>
    80006442:	cb65                	beqz	a4,80006532 <virtio_disk_init+0x1da>
    80006444:	c7fd                	beqz	a5,80006532 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80006446:	6605                	lui	a2,0x1
    80006448:	4581                	li	a1,0
    8000644a:	ffffb097          	auipc	ra,0xffffb
    8000644e:	886080e7          	jalr	-1914(ra) # 80000cd0 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006452:	0001d497          	auipc	s1,0x1d
    80006456:	4ce48493          	addi	s1,s1,1230 # 80023920 <disk>
    8000645a:	6605                	lui	a2,0x1
    8000645c:	4581                	li	a1,0
    8000645e:	6488                	ld	a0,8(s1)
    80006460:	ffffb097          	auipc	ra,0xffffb
    80006464:	870080e7          	jalr	-1936(ra) # 80000cd0 <memset>
  memset(disk.used, 0, PGSIZE);
    80006468:	6605                	lui	a2,0x1
    8000646a:	4581                	li	a1,0
    8000646c:	6888                	ld	a0,16(s1)
    8000646e:	ffffb097          	auipc	ra,0xffffb
    80006472:	862080e7          	jalr	-1950(ra) # 80000cd0 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006476:	100017b7          	lui	a5,0x10001
    8000647a:	4721                	li	a4,8
    8000647c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000647e:	4098                	lw	a4,0(s1)
    80006480:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006484:	40d8                	lw	a4,4(s1)
    80006486:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000648a:	6498                	ld	a4,8(s1)
    8000648c:	0007069b          	sext.w	a3,a4
    80006490:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006494:	9701                	srai	a4,a4,0x20
    80006496:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000649a:	6898                	ld	a4,16(s1)
    8000649c:	0007069b          	sext.w	a3,a4
    800064a0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800064a4:	9701                	srai	a4,a4,0x20
    800064a6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800064aa:	4705                	li	a4,1
    800064ac:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800064ae:	00e48c23          	sb	a4,24(s1)
    800064b2:	00e48ca3          	sb	a4,25(s1)
    800064b6:	00e48d23          	sb	a4,26(s1)
    800064ba:	00e48da3          	sb	a4,27(s1)
    800064be:	00e48e23          	sb	a4,28(s1)
    800064c2:	00e48ea3          	sb	a4,29(s1)
    800064c6:	00e48f23          	sb	a4,30(s1)
    800064ca:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800064ce:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800064d2:	0727a823          	sw	s2,112(a5)
}
    800064d6:	60e2                	ld	ra,24(sp)
    800064d8:	6442                	ld	s0,16(sp)
    800064da:	64a2                	ld	s1,8(sp)
    800064dc:	6902                	ld	s2,0(sp)
    800064de:	6105                	addi	sp,sp,32
    800064e0:	8082                	ret
    panic("could not find virtio disk");
    800064e2:	00003517          	auipc	a0,0x3
    800064e6:	39e50513          	addi	a0,a0,926 # 80009880 <syscalls+0x430>
    800064ea:	ffffa097          	auipc	ra,0xffffa
    800064ee:	054080e7          	jalr	84(ra) # 8000053e <panic>
    panic("virtio disk FEATURES_OK unset");
    800064f2:	00003517          	auipc	a0,0x3
    800064f6:	3ae50513          	addi	a0,a0,942 # 800098a0 <syscalls+0x450>
    800064fa:	ffffa097          	auipc	ra,0xffffa
    800064fe:	044080e7          	jalr	68(ra) # 8000053e <panic>
    panic("virtio disk should not be ready");
    80006502:	00003517          	auipc	a0,0x3
    80006506:	3be50513          	addi	a0,a0,958 # 800098c0 <syscalls+0x470>
    8000650a:	ffffa097          	auipc	ra,0xffffa
    8000650e:	034080e7          	jalr	52(ra) # 8000053e <panic>
    panic("virtio disk has no queue 0");
    80006512:	00003517          	auipc	a0,0x3
    80006516:	3ce50513          	addi	a0,a0,974 # 800098e0 <syscalls+0x490>
    8000651a:	ffffa097          	auipc	ra,0xffffa
    8000651e:	024080e7          	jalr	36(ra) # 8000053e <panic>
    panic("virtio disk max queue too short");
    80006522:	00003517          	auipc	a0,0x3
    80006526:	3de50513          	addi	a0,a0,990 # 80009900 <syscalls+0x4b0>
    8000652a:	ffffa097          	auipc	ra,0xffffa
    8000652e:	014080e7          	jalr	20(ra) # 8000053e <panic>
    panic("virtio disk kalloc");
    80006532:	00003517          	auipc	a0,0x3
    80006536:	3ee50513          	addi	a0,a0,1006 # 80009920 <syscalls+0x4d0>
    8000653a:	ffffa097          	auipc	ra,0xffffa
    8000653e:	004080e7          	jalr	4(ra) # 8000053e <panic>

0000000080006542 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006542:	7119                	addi	sp,sp,-128
    80006544:	fc86                	sd	ra,120(sp)
    80006546:	f8a2                	sd	s0,112(sp)
    80006548:	f4a6                	sd	s1,104(sp)
    8000654a:	f0ca                	sd	s2,96(sp)
    8000654c:	ecce                	sd	s3,88(sp)
    8000654e:	e8d2                	sd	s4,80(sp)
    80006550:	e4d6                	sd	s5,72(sp)
    80006552:	e0da                	sd	s6,64(sp)
    80006554:	fc5e                	sd	s7,56(sp)
    80006556:	f862                	sd	s8,48(sp)
    80006558:	f466                	sd	s9,40(sp)
    8000655a:	f06a                	sd	s10,32(sp)
    8000655c:	ec6e                	sd	s11,24(sp)
    8000655e:	0100                	addi	s0,sp,128
    80006560:	8aaa                	mv	s5,a0
    80006562:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006564:	00c52d03          	lw	s10,12(a0)
    80006568:	001d1d1b          	slliw	s10,s10,0x1
    8000656c:	1d02                	slli	s10,s10,0x20
    8000656e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006572:	0001d517          	auipc	a0,0x1d
    80006576:	4d650513          	addi	a0,a0,1238 # 80023a48 <disk+0x128>
    8000657a:	ffffa097          	auipc	ra,0xffffa
    8000657e:	65a080e7          	jalr	1626(ra) # 80000bd4 <acquire>
  for(int i = 0; i < 3; i++){
    80006582:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006584:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006586:	0001db97          	auipc	s7,0x1d
    8000658a:	39ab8b93          	addi	s7,s7,922 # 80023920 <disk>
  for(int i = 0; i < 3; i++){
    8000658e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006590:	0001dc97          	auipc	s9,0x1d
    80006594:	4b8c8c93          	addi	s9,s9,1208 # 80023a48 <disk+0x128>
    80006598:	a08d                	j	800065fa <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000659a:	00fb8733          	add	a4,s7,a5
    8000659e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800065a2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800065a4:	0207c563          	bltz	a5,800065ce <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800065a8:	2905                	addiw	s2,s2,1
    800065aa:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800065ac:	05690c63          	beq	s2,s6,80006604 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800065b0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800065b2:	0001d717          	auipc	a4,0x1d
    800065b6:	36e70713          	addi	a4,a4,878 # 80023920 <disk>
    800065ba:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800065bc:	01874683          	lbu	a3,24(a4)
    800065c0:	fee9                	bnez	a3,8000659a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800065c2:	2785                	addiw	a5,a5,1
    800065c4:	0705                	addi	a4,a4,1
    800065c6:	fe979be3          	bne	a5,s1,800065bc <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800065ca:	57fd                	li	a5,-1
    800065cc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800065ce:	01205d63          	blez	s2,800065e8 <virtio_disk_rw+0xa6>
    800065d2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800065d4:	000a2503          	lw	a0,0(s4)
    800065d8:	00000097          	auipc	ra,0x0
    800065dc:	cfe080e7          	jalr	-770(ra) # 800062d6 <free_desc>
      for(int j = 0; j < i; j++)
    800065e0:	2d85                	addiw	s11,s11,1
    800065e2:	0a11                	addi	s4,s4,4
    800065e4:	ff2d98e3          	bne	s11,s2,800065d4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800065e8:	85e6                	mv	a1,s9
    800065ea:	0001d517          	auipc	a0,0x1d
    800065ee:	34e50513          	addi	a0,a0,846 # 80023938 <disk+0x18>
    800065f2:	ffffc097          	auipc	ra,0xffffc
    800065f6:	b00080e7          	jalr	-1280(ra) # 800020f2 <sleep>
  for(int i = 0; i < 3; i++){
    800065fa:	f8040a13          	addi	s4,s0,-128
{
    800065fe:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006600:	894e                	mv	s2,s3
    80006602:	b77d                	j	800065b0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006604:	f8042503          	lw	a0,-128(s0)
    80006608:	00a50713          	addi	a4,a0,10
    8000660c:	0712                	slli	a4,a4,0x4

  if(write)
    8000660e:	0001d797          	auipc	a5,0x1d
    80006612:	31278793          	addi	a5,a5,786 # 80023920 <disk>
    80006616:	00e786b3          	add	a3,a5,a4
    8000661a:	01803633          	snez	a2,s8
    8000661e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006620:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006624:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006628:	f6070613          	addi	a2,a4,-160
    8000662c:	6394                	ld	a3,0(a5)
    8000662e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006630:	00870593          	addi	a1,a4,8
    80006634:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006636:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006638:	0007b803          	ld	a6,0(a5)
    8000663c:	9642                	add	a2,a2,a6
    8000663e:	46c1                	li	a3,16
    80006640:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006642:	4585                	li	a1,1
    80006644:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80006648:	f8442683          	lw	a3,-124(s0)
    8000664c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006650:	0692                	slli	a3,a3,0x4
    80006652:	9836                	add	a6,a6,a3
    80006654:	058a8613          	addi	a2,s5,88
    80006658:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000665c:	0007b803          	ld	a6,0(a5)
    80006660:	96c2                	add	a3,a3,a6
    80006662:	40000613          	li	a2,1024
    80006666:	c690                	sw	a2,8(a3)
  if(write)
    80006668:	001c3613          	seqz	a2,s8
    8000666c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006670:	00166613          	ori	a2,a2,1
    80006674:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80006678:	f8842603          	lw	a2,-120(s0)
    8000667c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006680:	00250693          	addi	a3,a0,2
    80006684:	0692                	slli	a3,a3,0x4
    80006686:	96be                	add	a3,a3,a5
    80006688:	58fd                	li	a7,-1
    8000668a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000668e:	0612                	slli	a2,a2,0x4
    80006690:	9832                	add	a6,a6,a2
    80006692:	f9070713          	addi	a4,a4,-112
    80006696:	973e                	add	a4,a4,a5
    80006698:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000669c:	6398                	ld	a4,0(a5)
    8000669e:	9732                	add	a4,a4,a2
    800066a0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800066a2:	4609                	li	a2,2
    800066a4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800066a8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800066ac:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800066b0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800066b4:	6794                	ld	a3,8(a5)
    800066b6:	0026d703          	lhu	a4,2(a3)
    800066ba:	8b1d                	andi	a4,a4,7
    800066bc:	0706                	slli	a4,a4,0x1
    800066be:	96ba                	add	a3,a3,a4
    800066c0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800066c4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800066c8:	6798                	ld	a4,8(a5)
    800066ca:	00275783          	lhu	a5,2(a4)
    800066ce:	2785                	addiw	a5,a5,1
    800066d0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800066d4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800066d8:	100017b7          	lui	a5,0x10001
    800066dc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800066e0:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    800066e4:	0001d917          	auipc	s2,0x1d
    800066e8:	36490913          	addi	s2,s2,868 # 80023a48 <disk+0x128>
  while(b->disk == 1) {
    800066ec:	4485                	li	s1,1
    800066ee:	00b79c63          	bne	a5,a1,80006706 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800066f2:	85ca                	mv	a1,s2
    800066f4:	8556                	mv	a0,s5
    800066f6:	ffffc097          	auipc	ra,0xffffc
    800066fa:	9fc080e7          	jalr	-1540(ra) # 800020f2 <sleep>
  while(b->disk == 1) {
    800066fe:	004aa783          	lw	a5,4(s5)
    80006702:	fe9788e3          	beq	a5,s1,800066f2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006706:	f8042903          	lw	s2,-128(s0)
    8000670a:	00290713          	addi	a4,s2,2
    8000670e:	0712                	slli	a4,a4,0x4
    80006710:	0001d797          	auipc	a5,0x1d
    80006714:	21078793          	addi	a5,a5,528 # 80023920 <disk>
    80006718:	97ba                	add	a5,a5,a4
    8000671a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000671e:	0001d997          	auipc	s3,0x1d
    80006722:	20298993          	addi	s3,s3,514 # 80023920 <disk>
    80006726:	00491713          	slli	a4,s2,0x4
    8000672a:	0009b783          	ld	a5,0(s3)
    8000672e:	97ba                	add	a5,a5,a4
    80006730:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006734:	854a                	mv	a0,s2
    80006736:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000673a:	00000097          	auipc	ra,0x0
    8000673e:	b9c080e7          	jalr	-1124(ra) # 800062d6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006742:	8885                	andi	s1,s1,1
    80006744:	f0ed                	bnez	s1,80006726 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006746:	0001d517          	auipc	a0,0x1d
    8000674a:	30250513          	addi	a0,a0,770 # 80023a48 <disk+0x128>
    8000674e:	ffffa097          	auipc	ra,0xffffa
    80006752:	53a080e7          	jalr	1338(ra) # 80000c88 <release>
}
    80006756:	70e6                	ld	ra,120(sp)
    80006758:	7446                	ld	s0,112(sp)
    8000675a:	74a6                	ld	s1,104(sp)
    8000675c:	7906                	ld	s2,96(sp)
    8000675e:	69e6                	ld	s3,88(sp)
    80006760:	6a46                	ld	s4,80(sp)
    80006762:	6aa6                	ld	s5,72(sp)
    80006764:	6b06                	ld	s6,64(sp)
    80006766:	7be2                	ld	s7,56(sp)
    80006768:	7c42                	ld	s8,48(sp)
    8000676a:	7ca2                	ld	s9,40(sp)
    8000676c:	7d02                	ld	s10,32(sp)
    8000676e:	6de2                	ld	s11,24(sp)
    80006770:	6109                	addi	sp,sp,128
    80006772:	8082                	ret

0000000080006774 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006774:	1101                	addi	sp,sp,-32
    80006776:	ec06                	sd	ra,24(sp)
    80006778:	e822                	sd	s0,16(sp)
    8000677a:	e426                	sd	s1,8(sp)
    8000677c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000677e:	0001d497          	auipc	s1,0x1d
    80006782:	1a248493          	addi	s1,s1,418 # 80023920 <disk>
    80006786:	0001d517          	auipc	a0,0x1d
    8000678a:	2c250513          	addi	a0,a0,706 # 80023a48 <disk+0x128>
    8000678e:	ffffa097          	auipc	ra,0xffffa
    80006792:	446080e7          	jalr	1094(ra) # 80000bd4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006796:	10001737          	lui	a4,0x10001
    8000679a:	533c                	lw	a5,96(a4)
    8000679c:	8b8d                	andi	a5,a5,3
    8000679e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800067a0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800067a4:	689c                	ld	a5,16(s1)
    800067a6:	0204d703          	lhu	a4,32(s1)
    800067aa:	0027d783          	lhu	a5,2(a5)
    800067ae:	04f70863          	beq	a4,a5,800067fe <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800067b2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800067b6:	6898                	ld	a4,16(s1)
    800067b8:	0204d783          	lhu	a5,32(s1)
    800067bc:	8b9d                	andi	a5,a5,7
    800067be:	078e                	slli	a5,a5,0x3
    800067c0:	97ba                	add	a5,a5,a4
    800067c2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800067c4:	00278713          	addi	a4,a5,2
    800067c8:	0712                	slli	a4,a4,0x4
    800067ca:	9726                	add	a4,a4,s1
    800067cc:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800067d0:	e721                	bnez	a4,80006818 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800067d2:	0789                	addi	a5,a5,2
    800067d4:	0792                	slli	a5,a5,0x4
    800067d6:	97a6                	add	a5,a5,s1
    800067d8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800067da:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800067de:	ffffc097          	auipc	ra,0xffffc
    800067e2:	978080e7          	jalr	-1672(ra) # 80002156 <wakeup>

    disk.used_idx += 1;
    800067e6:	0204d783          	lhu	a5,32(s1)
    800067ea:	2785                	addiw	a5,a5,1
    800067ec:	17c2                	slli	a5,a5,0x30
    800067ee:	93c1                	srli	a5,a5,0x30
    800067f0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800067f4:	6898                	ld	a4,16(s1)
    800067f6:	00275703          	lhu	a4,2(a4)
    800067fa:	faf71ce3          	bne	a4,a5,800067b2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800067fe:	0001d517          	auipc	a0,0x1d
    80006802:	24a50513          	addi	a0,a0,586 # 80023a48 <disk+0x128>
    80006806:	ffffa097          	auipc	ra,0xffffa
    8000680a:	482080e7          	jalr	1154(ra) # 80000c88 <release>
}
    8000680e:	60e2                	ld	ra,24(sp)
    80006810:	6442                	ld	s0,16(sp)
    80006812:	64a2                	ld	s1,8(sp)
    80006814:	6105                	addi	sp,sp,32
    80006816:	8082                	ret
      panic("virtio_disk_intr status");
    80006818:	00003517          	auipc	a0,0x3
    8000681c:	12050513          	addi	a0,a0,288 # 80009938 <syscalls+0x4e8>
    80006820:	ffffa097          	auipc	ra,0xffffa
    80006824:	d1e080e7          	jalr	-738(ra) # 8000053e <panic>

0000000080006828 <open_file>:
  filePath: File's path
  omode: Manipulation mode

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * path, int omode){
    80006828:	7139                	addi	sp,sp,-64
    8000682a:	fc06                	sd	ra,56(sp)
    8000682c:	f822                	sd	s0,48(sp)
    8000682e:	f426                	sd	s1,40(sp)
    80006830:	f04a                	sd	s2,32(sp)
    80006832:	ec4e                	sd	s3,24(sp)
    80006834:	e852                	sd	s4,16(sp)
    80006836:	0080                	addi	s0,sp,64
    80006838:	84aa                	mv	s1,a0
    8000683a:	8a2e                	mv	s4,a1
  int fd;
  struct file *f;
  struct inode *ip;
  int n;

  begin_op();
    8000683c:	ffffe097          	auipc	ra,0xffffe
    80006840:	d2e080e7          	jalr	-722(ra) # 8000456a <begin_op>

  if(omode & O_CREATE){
    80006844:	200a7793          	andi	a5,s4,512
    80006848:	c7f5                	beqz	a5,80006934 <open_file+0x10c>
  if((dp = nameiparent(path, name)) == 0)
    8000684a:	fc040593          	addi	a1,s0,-64
    8000684e:	8526                	mv	a0,s1
    80006850:	ffffe097          	auipc	ra,0xffffe
    80006854:	b18080e7          	jalr	-1256(ra) # 80004368 <nameiparent>
    80006858:	84aa                	mv	s1,a0
    8000685a:	c531                	beqz	a0,800068a6 <open_file+0x7e>
  ilock(dp);
    8000685c:	ffffd097          	auipc	ra,0xffffd
    80006860:	342080e7          	jalr	834(ra) # 80003b9e <ilock>
  if((ip = dirlookup(dp, name, 0)) != 0){
    80006864:	4601                	li	a2,0
    80006866:	fc040593          	addi	a1,s0,-64
    8000686a:	8526                	mv	a0,s1
    8000686c:	ffffe097          	auipc	ra,0xffffe
    80006870:	816080e7          	jalr	-2026(ra) # 80004082 <dirlookup>
    80006874:	892a                	mv	s2,a0
    80006876:	cd15                	beqz	a0,800068b2 <open_file+0x8a>
    iunlockput(dp);
    80006878:	8526                	mv	a0,s1
    8000687a:	ffffd097          	auipc	ra,0xffffd
    8000687e:	586080e7          	jalr	1414(ra) # 80003e00 <iunlockput>
    ilock(ip);
    80006882:	854a                	mv	a0,s2
    80006884:	ffffd097          	auipc	ra,0xffffd
    80006888:	31a080e7          	jalr	794(ra) # 80003b9e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000688c:	04495783          	lhu	a5,68(s2)
    80006890:	37f9                	addiw	a5,a5,-2
    80006892:	17c2                	slli	a5,a5,0x30
    80006894:	93c1                	srli	a5,a5,0x30
    80006896:	4705                	li	a4,1
    80006898:	0af77e63          	bgeu	a4,a5,80006954 <open_file+0x12c>
    iunlockput(ip);
    8000689c:	854a                	mv	a0,s2
    8000689e:	ffffd097          	auipc	ra,0xffffd
    800068a2:	562080e7          	jalr	1378(ra) # 80003e00 <iunlockput>
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
    800068a6:	ffffe097          	auipc	ra,0xffffe
    800068aa:	d42080e7          	jalr	-702(ra) # 800045e8 <end_op>
      return -1;
    800068ae:	54fd                	li	s1,-1
    800068b0:	aa79                	j	80006a4e <open_file+0x226>
  if((ip = ialloc(dp->dev, type)) == 0){
    800068b2:	4589                	li	a1,2
    800068b4:	4088                	lw	a0,0(s1)
    800068b6:	ffffd097          	auipc	ra,0xffffd
    800068ba:	14a080e7          	jalr	330(ra) # 80003a00 <ialloc>
    800068be:	892a                	mv	s2,a0
    800068c0:	c131                	beqz	a0,80006904 <open_file+0xdc>
  ilock(ip);
    800068c2:	ffffd097          	auipc	ra,0xffffd
    800068c6:	2dc080e7          	jalr	732(ra) # 80003b9e <ilock>
  ip->major = major;
    800068ca:	04091323          	sh	zero,70(s2)
  ip->minor = minor;
    800068ce:	04091423          	sh	zero,72(s2)
  ip->nlink = 1;
    800068d2:	4785                	li	a5,1
    800068d4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800068d8:	854a                	mv	a0,s2
    800068da:	ffffd097          	auipc	ra,0xffffd
    800068de:	1f8080e7          	jalr	504(ra) # 80003ad2 <iupdate>
  if(dirlink(dp, name, ip->inum) < 0)
    800068e2:	00492603          	lw	a2,4(s2)
    800068e6:	fc040593          	addi	a1,s0,-64
    800068ea:	8526                	mv	a0,s1
    800068ec:	ffffe097          	auipc	ra,0xffffe
    800068f0:	9ac080e7          	jalr	-1620(ra) # 80004298 <dirlink>
    800068f4:	00054e63          	bltz	a0,80006910 <open_file+0xe8>
  iunlockput(dp);
    800068f8:	8526                	mv	a0,s1
    800068fa:	ffffd097          	auipc	ra,0xffffd
    800068fe:	506080e7          	jalr	1286(ra) # 80003e00 <iunlockput>
  return ip;
    80006902:	a889                	j	80006954 <open_file+0x12c>
    iunlockput(dp);
    80006904:	8526                	mv	a0,s1
    80006906:	ffffd097          	auipc	ra,0xffffd
    8000690a:	4fa080e7          	jalr	1274(ra) # 80003e00 <iunlockput>
    return 0;
    8000690e:	bf61                	j	800068a6 <open_file+0x7e>
  ip->nlink = 0;
    80006910:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80006914:	854a                	mv	a0,s2
    80006916:	ffffd097          	auipc	ra,0xffffd
    8000691a:	1bc080e7          	jalr	444(ra) # 80003ad2 <iupdate>
  iunlockput(ip);
    8000691e:	854a                	mv	a0,s2
    80006920:	ffffd097          	auipc	ra,0xffffd
    80006924:	4e0080e7          	jalr	1248(ra) # 80003e00 <iunlockput>
  iunlockput(dp);
    80006928:	8526                	mv	a0,s1
    8000692a:	ffffd097          	auipc	ra,0xffffd
    8000692e:	4d6080e7          	jalr	1238(ra) # 80003e00 <iunlockput>
  return 0;
    80006932:	bf95                	j	800068a6 <open_file+0x7e>
    }
  } else {
    if((ip = namei(path)) == 0){
    80006934:	8526                	mv	a0,s1
    80006936:	ffffe097          	auipc	ra,0xffffe
    8000693a:	a14080e7          	jalr	-1516(ra) # 8000434a <namei>
    8000693e:	892a                	mv	s2,a0
    80006940:	c925                	beqz	a0,800069b0 <open_file+0x188>
      end_op();
      return -1;
    }
    ilock(ip);
    80006942:	ffffd097          	auipc	ra,0xffffd
    80006946:	25c080e7          	jalr	604(ra) # 80003b9e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000694a:	04491703          	lh	a4,68(s2)
    8000694e:	4785                	li	a5,1
    80006950:	06f70663          	beq	a4,a5,800069bc <open_file+0x194>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80006954:	04491703          	lh	a4,68(s2)
    80006958:	478d                	li	a5,3
    8000695a:	00f71763          	bne	a4,a5,80006968 <open_file+0x140>
    8000695e:	04695703          	lhu	a4,70(s2)
    80006962:	47a5                	li	a5,9
    80006964:	06e7e963          	bltu	a5,a4,800069d6 <open_file+0x1ae>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006968:	ffffe097          	auipc	ra,0xffffe
    8000696c:	00e080e7          	jalr	14(ra) # 80004976 <filealloc>
    80006970:	89aa                	mv	s3,a0
    80006972:	c505                	beqz	a0,8000699a <open_file+0x172>
  struct proc *p = myproc();
    80006974:	ffffb097          	auipc	ra,0xffffb
    80006978:	036080e7          	jalr	54(ra) # 800019aa <myproc>
  for(fd = 0; fd < NOFILE; fd++){
    8000697c:	0d050793          	addi	a5,a0,208
    80006980:	4481                	li	s1,0
    80006982:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80006984:	6398                	ld	a4,0(a5)
    80006986:	c33d                	beqz	a4,800069ec <open_file+0x1c4>
  for(fd = 0; fd < NOFILE; fd++){
    80006988:	2485                	addiw	s1,s1,1
    8000698a:	07a1                	addi	a5,a5,8
    8000698c:	fed49ce3          	bne	s1,a3,80006984 <open_file+0x15c>
    if(f)
      fileclose(f);
    80006990:	854e                	mv	a0,s3
    80006992:	ffffe097          	auipc	ra,0xffffe
    80006996:	0a0080e7          	jalr	160(ra) # 80004a32 <fileclose>
    iunlockput(ip);
    8000699a:	854a                	mv	a0,s2
    8000699c:	ffffd097          	auipc	ra,0xffffd
    800069a0:	464080e7          	jalr	1124(ra) # 80003e00 <iunlockput>
    end_op();
    800069a4:	ffffe097          	auipc	ra,0xffffe
    800069a8:	c44080e7          	jalr	-956(ra) # 800045e8 <end_op>
    return -1;
    800069ac:	54fd                	li	s1,-1
    800069ae:	a045                	j	80006a4e <open_file+0x226>
      end_op();
    800069b0:	ffffe097          	auipc	ra,0xffffe
    800069b4:	c38080e7          	jalr	-968(ra) # 800045e8 <end_op>
      return -1;
    800069b8:	54fd                	li	s1,-1
    800069ba:	a851                	j	80006a4e <open_file+0x226>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800069bc:	fa0a06e3          	beqz	s4,80006968 <open_file+0x140>
      iunlockput(ip);
    800069c0:	854a                	mv	a0,s2
    800069c2:	ffffd097          	auipc	ra,0xffffd
    800069c6:	43e080e7          	jalr	1086(ra) # 80003e00 <iunlockput>
      end_op();
    800069ca:	ffffe097          	auipc	ra,0xffffe
    800069ce:	c1e080e7          	jalr	-994(ra) # 800045e8 <end_op>
      return -1;
    800069d2:	54fd                	li	s1,-1
    800069d4:	a8ad                	j	80006a4e <open_file+0x226>
    iunlockput(ip);
    800069d6:	854a                	mv	a0,s2
    800069d8:	ffffd097          	auipc	ra,0xffffd
    800069dc:	428080e7          	jalr	1064(ra) # 80003e00 <iunlockput>
    end_op();
    800069e0:	ffffe097          	auipc	ra,0xffffe
    800069e4:	c08080e7          	jalr	-1016(ra) # 800045e8 <end_op>
    return -1;
    800069e8:	54fd                	li	s1,-1
    800069ea:	a095                	j	80006a4e <open_file+0x226>
      p->ofile[fd] = f;
    800069ec:	01a48793          	addi	a5,s1,26
    800069f0:	078e                	slli	a5,a5,0x3
    800069f2:	953e                	add	a0,a0,a5
    800069f4:	01353023          	sd	s3,0(a0)
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800069f8:	f804cce3          	bltz	s1,80006990 <open_file+0x168>
  }

  if(ip->type == T_DEVICE){
    800069fc:	04491703          	lh	a4,68(s2)
    80006a00:	478d                	li	a5,3
    80006a02:	04f70f63          	beq	a4,a5,80006a60 <open_file+0x238>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006a06:	4789                	li	a5,2
    80006a08:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80006a0c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80006a10:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80006a14:	001a4793          	xori	a5,s4,1
    80006a18:	8b85                	andi	a5,a5,1
    80006a1a:	00f98423          	sb	a5,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006a1e:	003a7793          	andi	a5,s4,3
    80006a22:	00f037b3          	snez	a5,a5
    80006a26:	00f984a3          	sb	a5,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80006a2a:	400a7a13          	andi	s4,s4,1024
    80006a2e:	000a0763          	beqz	s4,80006a3c <open_file+0x214>
    80006a32:	04491703          	lh	a4,68(s2)
    80006a36:	4789                	li	a5,2
    80006a38:	02f70b63          	beq	a4,a5,80006a6e <open_file+0x246>
    itrunc(ip);
  }

  iunlock(ip);
    80006a3c:	854a                	mv	a0,s2
    80006a3e:	ffffd097          	auipc	ra,0xffffd
    80006a42:	222080e7          	jalr	546(ra) # 80003c60 <iunlock>
  end_op();
    80006a46:	ffffe097          	auipc	ra,0xffffe
    80006a4a:	ba2080e7          	jalr	-1118(ra) # 800045e8 <end_op>

  return fd;


}
    80006a4e:	8526                	mv	a0,s1
    80006a50:	70e2                	ld	ra,56(sp)
    80006a52:	7442                	ld	s0,48(sp)
    80006a54:	74a2                	ld	s1,40(sp)
    80006a56:	7902                	ld	s2,32(sp)
    80006a58:	69e2                	ld	s3,24(sp)
    80006a5a:	6a42                	ld	s4,16(sp)
    80006a5c:	6121                	addi	sp,sp,64
    80006a5e:	8082                	ret
    f->type = FD_DEVICE;
    80006a60:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80006a64:	04691783          	lh	a5,70(s2)
    80006a68:	02f99223          	sh	a5,36(s3)
    80006a6c:	b755                	j	80006a10 <open_file+0x1e8>
    itrunc(ip);
    80006a6e:	854a                	mv	a0,s2
    80006a70:	ffffd097          	auipc	ra,0xffffd
    80006a74:	23c080e7          	jalr	572(ra) # 80003cac <itrunc>
    80006a78:	b7d1                	j	80006a3c <open_file+0x214>

0000000080006a7a <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
    80006a7a:	715d                	addi	sp,sp,-80
    80006a7c:	e486                	sd	ra,72(sp)
    80006a7e:	e0a2                	sd	s0,64(sp)
    80006a80:	fc26                	sd	s1,56(sp)
    80006a82:	f84a                	sd	s2,48(sp)
    80006a84:	f44e                	sd	s3,40(sp)
    80006a86:	f052                	sd	s4,32(sp)
    80006a88:	ec56                	sd	s5,24(sp)
    80006a8a:	e85a                	sd	s6,16(sp)
    80006a8c:	0880                	addi	s0,sp,80

  struct file *f;

  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80006a8e:	47bd                	li	a5,15
    return -1;
    80006a90:	59fd                	li	s3,-1
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80006a92:	00a7fd63          	bgeu	a5,a0,80006aac <read_line+0x32>

    }

  }

}
    80006a96:	854e                	mv	a0,s3
    80006a98:	60a6                	ld	ra,72(sp)
    80006a9a:	6406                	ld	s0,64(sp)
    80006a9c:	74e2                	ld	s1,56(sp)
    80006a9e:	7942                	ld	s2,48(sp)
    80006aa0:	79a2                	ld	s3,40(sp)
    80006aa2:	7a02                	ld	s4,32(sp)
    80006aa4:	6ae2                	ld	s5,24(sp)
    80006aa6:	6b42                	ld	s6,16(sp)
    80006aa8:	6161                	addi	sp,sp,80
    80006aaa:	8082                	ret
    80006aac:	892e                	mv	s2,a1
    80006aae:	89aa                	mv	s3,a0
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80006ab0:	ffffb097          	auipc	ra,0xffffb
    80006ab4:	efa080e7          	jalr	-262(ra) # 800019aa <myproc>
    80006ab8:	01a98793          	addi	a5,s3,26
    80006abc:	078e                	slli	a5,a5,0x3
    80006abe:	953e                	add	a0,a0,a5
    80006ac0:	6104                	ld	s1,0(a0)
    80006ac2:	c0f5                	beqz	s1,80006ba6 <read_line+0x12c>
  if (!fd){ 
    80006ac4:	08099c63          	bnez	s3,80006b5c <read_line+0xe2>
    if (f->pipe){
    80006ac8:	689c                	ld	a5,16(s1)
    80006aca:	8a4a                	mv	s4,s2
    80006acc:	4a81                	li	s5,0
        if (buffer[idx]=='\n'){
    80006ace:	4b29                	li	s6,10
    if (f->pipe){
    80006ad0:	ef8d                	bnez	a5,80006b0a <read_line+0x90>
    80006ad2:	89ca                	mv	s3,s2
    80006ad4:	4a01                	li	s4,0
      while((readStatus=devsw[f->major].read(0, (uint64)buffer+idx, 1)) == 1){ // The first 0 indicates kernel address
    80006ad6:	0001ca97          	auipc	s5,0x1c
    80006ada:	df2a8a93          	addi	s5,s5,-526 # 800228c8 <devsw>
    80006ade:	02449783          	lh	a5,36(s1)
    80006ae2:	0792                	slli	a5,a5,0x4
    80006ae4:	97d6                	add	a5,a5,s5
    80006ae6:	639c                	ld	a5,0(a5)
    80006ae8:	4605                	li	a2,1
    80006aea:	85ce                	mv	a1,s3
    80006aec:	4501                	li	a0,0
    80006aee:	9782                	jalr	a5
    80006af0:	4785                	li	a5,1
    80006af2:	06f51163          	bne	a0,a5,80006b54 <read_line+0xda>
        if (buffer[idx]=='\n'){
    80006af6:	0009c783          	lbu	a5,0(s3)
    80006afa:	001a0713          	addi	a4,s4,1
    80006afe:	0985                	addi	s3,s3,1
    80006b00:	05678663          	beq	a5,s6,80006b4c <read_line+0xd2>
    80006b04:	8a3a                	mv	s4,a4
    80006b06:	bfe1                	j	80006ade <read_line+0x64>
    80006b08:	8aba                	mv	s5,a4
    80006b0a:	000a899b          	sext.w	s3,s5
        readStatus = read_pipe(f->pipe,(uint64)buffer+idx,1);
    80006b0e:	4605                	li	a2,1
    80006b10:	85d2                	mv	a1,s4
    80006b12:	6888                	ld	a0,16(s1)
    80006b14:	ffffe097          	auipc	ra,0xffffe
    80006b18:	57e080e7          	jalr	1406(ra) # 80005092 <read_pipe>
        if (readStatus<= 0){
    80006b1c:	00a05e63          	blez	a0,80006b38 <read_line+0xbe>
        if (buffer[idx]=='\n'){
    80006b20:	000a4783          	lbu	a5,0(s4)
    80006b24:	001a8713          	addi	a4,s5,1
    80006b28:	0a05                	addi	s4,s4,1
    80006b2a:	fd679fe3          	bne	a5,s6,80006b08 <read_line+0x8e>
          buffer[idx+1]=0;
    80006b2e:	9aca                	add	s5,s5,s2
    80006b30:	000a80a3          	sb	zero,1(s5)
          return idx+1;
    80006b34:	2985                	addiw	s3,s3,1
    80006b36:	b785                	j	80006a96 <read_line+0x1c>
          if (idx!=0){
    80006b38:	f4098fe3          	beqz	s3,80006a96 <read_line+0x1c>
            buffer[idx] = '\n';
    80006b3c:	9aca                	add	s5,s5,s2
    80006b3e:	47a9                	li	a5,10
    80006b40:	00fa8023          	sb	a5,0(s5)
            buffer[idx+1]=0;
    80006b44:	000a80a3          	sb	zero,1(s5)
            return idx+1;
    80006b48:	2985                	addiw	s3,s3,1
    80006b4a:	b7b1                	j	80006a96 <read_line+0x1c>
          buffer[idx+1]=0;
    80006b4c:	9a4a                	add	s4,s4,s2
    80006b4e:	000a00a3          	sb	zero,1(s4)
      if (!newLine)
    80006b52:	b791                	j	80006a96 <read_line+0x1c>
        buffer[idx]=0;
    80006b54:	9a4a                	add	s4,s4,s2
    80006b56:	000a0023          	sb	zero,0(s4)
}
    80006b5a:	bf35                	j	80006a96 <read_line+0x1c>
  int byteCount = 0;
    80006b5c:	4981                	li	s3,0
        if (readByte == '\n'){
    80006b5e:	4a29                	li	s4,10
        readStatus = readi(f->ip, 0, (uint64)&readByte, f->off, 1);
    80006b60:	4705                	li	a4,1
    80006b62:	5094                	lw	a3,32(s1)
    80006b64:	fbf40613          	addi	a2,s0,-65
    80006b68:	4581                	li	a1,0
    80006b6a:	6c88                	ld	a0,24(s1)
    80006b6c:	ffffd097          	auipc	ra,0xffffd
    80006b70:	2e6080e7          	jalr	742(ra) # 80003e52 <readi>
        if (readStatus > 0)
    80006b74:	02a05063          	blez	a0,80006b94 <read_line+0x11a>
          f->off += readStatus;
    80006b78:	509c                	lw	a5,32(s1)
    80006b7a:	9fa9                	addw	a5,a5,a0
    80006b7c:	d09c                	sw	a5,32(s1)
        *buffer++ = readByte;
    80006b7e:	0905                	addi	s2,s2,1
    80006b80:	fbf44783          	lbu	a5,-65(s0)
    80006b84:	fef90fa3          	sb	a5,-1(s2)
        byteCount++;
    80006b88:	2985                	addiw	s3,s3,1
        if (readByte == '\n'){
    80006b8a:	fd479be3          	bne	a5,s4,80006b60 <read_line+0xe6>
            *(buffer)=0; // Nullifying the end of the string
    80006b8e:	00090023          	sb	zero,0(s2)
          return byteCount;
    80006b92:	b711                	j	80006a96 <read_line+0x1c>
          if (byteCount!=0){
    80006b94:	f00981e3          	beqz	s3,80006a96 <read_line+0x1c>
            *buffer = '\n';
    80006b98:	47a9                	li	a5,10
    80006b9a:	00f90023          	sb	a5,0(s2)
            *(buffer+1)=0;
    80006b9e:	000900a3          	sb	zero,1(s2)
            return byteCount+1;
    80006ba2:	2985                	addiw	s3,s3,1
    80006ba4:	bdcd                	j	80006a96 <read_line+0x1c>
    return -1;
    80006ba6:	59fd                	li	s3,-1
    80006ba8:	b5fd                	j	80006a96 <read_line+0x1c>

0000000080006baa <close_file>:
  fd: File discriptor

[OUTPUT]:

*/
void close_file(struct file *f){
    80006baa:	1141                	addi	sp,sp,-16
    80006bac:	e406                	sd	ra,8(sp)
    80006bae:	e022                	sd	s0,0(sp)
    80006bb0:	0800                	addi	s0,sp,16
  fileclose(f);
    80006bb2:	ffffe097          	auipc	ra,0xffffe
    80006bb6:	e80080e7          	jalr	-384(ra) # 80004a32 <fileclose>
}
    80006bba:	60a2                	ld	ra,8(sp)
    80006bbc:	6402                	ld	s0,0(sp)
    80006bbe:	0141                	addi	sp,sp,16
    80006bc0:	8082                	ret

0000000080006bc2 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
    80006bc2:	1141                	addi	sp,sp,-16
    80006bc4:	e422                	sd	s0,8(sp)
    80006bc6:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
    80006bc8:	00054783          	lbu	a5,0(a0)
    80006bcc:	cf99                	beqz	a5,80006bea <get_strlen+0x28>
    80006bce:	00150713          	addi	a4,a0,1
    80006bd2:	87ba                	mv	a5,a4
    80006bd4:	4685                	li	a3,1
    80006bd6:	9e99                	subw	a3,a3,a4
    80006bd8:	00f6853b          	addw	a0,a3,a5
    80006bdc:	0785                	addi	a5,a5,1
    80006bde:	fff7c703          	lbu	a4,-1(a5)
    80006be2:	fb7d                	bnez	a4,80006bd8 <get_strlen+0x16>
	return len;
}
    80006be4:	6422                	ld	s0,8(sp)
    80006be6:	0141                	addi	sp,sp,16
    80006be8:	8082                	ret
	int len = 0;
    80006bea:	4501                	li	a0,0
    80006bec:	bfe5                	j	80006be4 <get_strlen+0x22>

0000000080006bee <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
    80006bee:	1141                	addi	sp,sp,-16
    80006bf0:	e422                	sd	s0,8(sp)
    80006bf2:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
    80006bf4:	00054783          	lbu	a5,0(a0)
    80006bf8:	cb91                	beqz	a5,80006c0c <compare_str+0x1e>
    80006bfa:	0005c703          	lbu	a4,0(a1)
    80006bfe:	c719                	beqz	a4,80006c0c <compare_str+0x1e>
		if (*s1++ != *s2++)
    80006c00:	0505                	addi	a0,a0,1
    80006c02:	0585                	addi	a1,a1,1
    80006c04:	fee788e3          	beq	a5,a4,80006bf4 <compare_str+0x6>
			return 1;
    80006c08:	4505                	li	a0,1
    80006c0a:	a031                	j	80006c16 <compare_str+0x28>
	}
	if (*s1 == *s2)
    80006c0c:	0005c503          	lbu	a0,0(a1)
    80006c10:	8d1d                	sub	a0,a0,a5
			return 1;
    80006c12:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    80006c16:	6422                	ld	s0,8(sp)
    80006c18:	0141                	addi	sp,sp,16
    80006c1a:	8082                	ret

0000000080006c1c <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
    80006c1c:	1141                	addi	sp,sp,-16
    80006c1e:	e422                	sd	s0,8(sp)
    80006c20:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
    80006c22:	4665                	li	a2,25
	while(*s1 && *s2){
    80006c24:	a019                	j	80006c2a <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
    80006c26:	04e79763          	bne	a5,a4,80006c74 <compare_str_ic+0x58>
	while(*s1 && *s2){
    80006c2a:	00054783          	lbu	a5,0(a0)
    80006c2e:	cb9d                	beqz	a5,80006c64 <compare_str_ic+0x48>
    80006c30:	0005c703          	lbu	a4,0(a1)
    80006c34:	cb05                	beqz	a4,80006c64 <compare_str_ic+0x48>
		char b1 = *s1++;
    80006c36:	0505                	addi	a0,a0,1
		char b2 = *s2++;
    80006c38:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
    80006c3a:	fbf7869b          	addiw	a3,a5,-65
    80006c3e:	0ff6f693          	zext.b	a3,a3
    80006c42:	00d66663          	bltu	a2,a3,80006c4e <compare_str_ic+0x32>
			b1 += 32;
    80006c46:	0207879b          	addiw	a5,a5,32
    80006c4a:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
    80006c4e:	fbf7069b          	addiw	a3,a4,-65
    80006c52:	0ff6f693          	zext.b	a3,a3
    80006c56:	fcd668e3          	bltu	a2,a3,80006c26 <compare_str_ic+0xa>
			b2 += 32;
    80006c5a:	0207071b          	addiw	a4,a4,32
    80006c5e:	0ff77713          	zext.b	a4,a4
    80006c62:	b7d1                	j	80006c26 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
    80006c64:	0005c503          	lbu	a0,0(a1)
    80006c68:	8d1d                	sub	a0,a0,a5
			return 1;
    80006c6a:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    80006c6e:	6422                	ld	s0,8(sp)
    80006c70:	0141                	addi	sp,sp,16
    80006c72:	8082                	ret
			return 1;
    80006c74:	4505                	li	a0,1
    80006c76:	bfe5                	j	80006c6e <compare_str_ic+0x52>

0000000080006c78 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
    80006c78:	7179                	addi	sp,sp,-48
    80006c7a:	f406                	sd	ra,40(sp)
    80006c7c:	f022                	sd	s0,32(sp)
    80006c7e:	ec26                	sd	s1,24(sp)
    80006c80:	e84a                	sd	s2,16(sp)
    80006c82:	e44e                	sd	s3,8(sp)
    80006c84:	1800                	addi	s0,sp,48
    80006c86:	89aa                	mv	s3,a0
    80006c88:	892e                	mv	s2,a1
    int M = get_strlen(s1);
    80006c8a:	00000097          	auipc	ra,0x0
    80006c8e:	f38080e7          	jalr	-200(ra) # 80006bc2 <get_strlen>
    80006c92:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
    80006c94:	854a                	mv	a0,s2
    80006c96:	00000097          	auipc	ra,0x0
    80006c9a:	f2c080e7          	jalr	-212(ra) # 80006bc2 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
    80006c9e:	409505bb          	subw	a1,a0,s1
    80006ca2:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
    80006ca4:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
    80006ca6:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
    80006ca8:	0005da63          	bgez	a1,80006cbc <check_substr+0x44>
    80006cac:	a81d                	j	80006ce2 <check_substr+0x6a>
        if (j == M)
    80006cae:	02f48a63          	beq	s1,a5,80006ce2 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
    80006cb2:	0885                	addi	a7,a7,1
    80006cb4:	0008879b          	sext.w	a5,a7
    80006cb8:	02f5cc63          	blt	a1,a5,80006cf0 <check_substr+0x78>
    80006cbc:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
    80006cc0:	011906b3          	add	a3,s2,a7
    80006cc4:	874e                	mv	a4,s3
    80006cc6:	879a                	mv	a5,t1
    80006cc8:	fe9053e3          	blez	s1,80006cae <check_substr+0x36>
            if (s2[i + j] != s1[j])
    80006ccc:	0006c803          	lbu	a6,0(a3)
    80006cd0:	00074603          	lbu	a2,0(a4)
    80006cd4:	fcc81de3          	bne	a6,a2,80006cae <check_substr+0x36>
        for (j = 0; j < M; j++)
    80006cd8:	2785                	addiw	a5,a5,1
    80006cda:	0685                	addi	a3,a3,1
    80006cdc:	0705                	addi	a4,a4,1
    80006cde:	fef497e3          	bne	s1,a5,80006ccc <check_substr+0x54>
}
    80006ce2:	70a2                	ld	ra,40(sp)
    80006ce4:	7402                	ld	s0,32(sp)
    80006ce6:	64e2                	ld	s1,24(sp)
    80006ce8:	6942                	ld	s2,16(sp)
    80006cea:	69a2                	ld	s3,8(sp)
    80006cec:	6145                	addi	sp,sp,48
    80006cee:	8082                	ret
    return -1;
    80006cf0:	557d                	li	a0,-1
    80006cf2:	bfc5                	j	80006ce2 <check_substr+0x6a>

0000000080006cf4 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
    80006cf4:	c1d9                	beqz	a1,80006d7a <head_run+0x86>
void head_run(int fd, int numOfLines){
    80006cf6:	dd010113          	addi	sp,sp,-560
    80006cfa:	22113423          	sd	ra,552(sp)
    80006cfe:	22813023          	sd	s0,544(sp)
    80006d02:	20913c23          	sd	s1,536(sp)
    80006d06:	21213823          	sd	s2,528(sp)
    80006d0a:	21313423          	sd	s3,520(sp)
    80006d0e:	21413023          	sd	s4,512(sp)
    80006d12:	1c00                	addi	s0,sp,560
    80006d14:	892a                	mv	s2,a0
    80006d16:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
    80006d1a:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
    80006d1c:	00003a17          	auipc	s4,0x3
    80006d20:	c5ca0a13          	addi	s4,s4,-932 # 80009978 <syscalls+0x528>
		readStatus = read_line(fd, line);
    80006d24:	dd840593          	addi	a1,s0,-552
    80006d28:	854a                	mv	a0,s2
    80006d2a:	00000097          	auipc	ra,0x0
    80006d2e:	d50080e7          	jalr	-688(ra) # 80006a7a <read_line>
		if (readStatus == READ_ERROR){
    80006d32:	01350d63          	beq	a0,s3,80006d4c <head_run+0x58>
		if (readStatus == READ_EOF)
    80006d36:	c11d                	beqz	a0,80006d5c <head_run+0x68>
		printf("%s",line);
    80006d38:	dd840593          	addi	a1,s0,-552
    80006d3c:	8552                	mv	a0,s4
    80006d3e:	ffffa097          	auipc	ra,0xffffa
    80006d42:	84a080e7          	jalr	-1974(ra) # 80000588 <printf>
	while(numOfLines--){
    80006d46:	34fd                	addiw	s1,s1,-1
    80006d48:	fcf1                	bnez	s1,80006d24 <head_run+0x30>
    80006d4a:	a809                	j	80006d5c <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
    80006d4c:	00003517          	auipc	a0,0x3
    80006d50:	c0450513          	addi	a0,a0,-1020 # 80009950 <syscalls+0x500>
    80006d54:	ffffa097          	auipc	ra,0xffffa
    80006d58:	834080e7          	jalr	-1996(ra) # 80000588 <printf>

	}
}
    80006d5c:	22813083          	ld	ra,552(sp)
    80006d60:	22013403          	ld	s0,544(sp)
    80006d64:	21813483          	ld	s1,536(sp)
    80006d68:	21013903          	ld	s2,528(sp)
    80006d6c:	20813983          	ld	s3,520(sp)
    80006d70:	20013a03          	ld	s4,512(sp)
    80006d74:	23010113          	addi	sp,sp,560
    80006d78:	8082                	ret
    80006d7a:	8082                	ret

0000000080006d7c <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
    80006d7c:	ba010113          	addi	sp,sp,-1120
    80006d80:	44113c23          	sd	ra,1112(sp)
    80006d84:	44813823          	sd	s0,1104(sp)
    80006d88:	44913423          	sd	s1,1096(sp)
    80006d8c:	45213023          	sd	s2,1088(sp)
    80006d90:	43313c23          	sd	s3,1080(sp)
    80006d94:	43413823          	sd	s4,1072(sp)
    80006d98:	43513423          	sd	s5,1064(sp)
    80006d9c:	43613023          	sd	s6,1056(sp)
    80006da0:	41713c23          	sd	s7,1048(sp)
    80006da4:	41813823          	sd	s8,1040(sp)
    80006da8:	41913423          	sd	s9,1032(sp)
    80006dac:	41a13023          	sd	s10,1024(sp)
    80006db0:	3fb13c23          	sd	s11,1016(sp)
    80006db4:	46010413          	addi	s0,sp,1120
    80006db8:	89aa                	mv	s3,a0
    80006dba:	8aae                	mv	s5,a1
    80006dbc:	8c32                	mv	s8,a2
    80006dbe:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
    80006dc0:	d9840593          	addi	a1,s0,-616
    80006dc4:	00000097          	auipc	ra,0x0
    80006dc8:	cb6080e7          	jalr	-842(ra) # 80006a7a <read_line>


  if (readStatus == READ_ERROR)
    80006dcc:	57fd                	li	a5,-1
    80006dce:	04f50163          	beq	a0,a5,80006e10 <uniq_run+0x94>
    80006dd2:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
    80006dd4:	ed21                	bnez	a0,80006e2c <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
    80006dd6:	45813083          	ld	ra,1112(sp)
    80006dda:	45013403          	ld	s0,1104(sp)
    80006dde:	44813483          	ld	s1,1096(sp)
    80006de2:	44013903          	ld	s2,1088(sp)
    80006de6:	43813983          	ld	s3,1080(sp)
    80006dea:	43013a03          	ld	s4,1072(sp)
    80006dee:	42813a83          	ld	s5,1064(sp)
    80006df2:	42013b03          	ld	s6,1056(sp)
    80006df6:	41813b83          	ld	s7,1048(sp)
    80006dfa:	41013c03          	ld	s8,1040(sp)
    80006dfe:	40813c83          	ld	s9,1032(sp)
    80006e02:	40013d03          	ld	s10,1024(sp)
    80006e06:	3f813d83          	ld	s11,1016(sp)
    80006e0a:	46010113          	addi	sp,sp,1120
    80006e0e:	8082                	ret
    printf("[ERR] Error reading from the file ");
    80006e10:	00003517          	auipc	a0,0x3
    80006e14:	b7050513          	addi	a0,a0,-1168 # 80009980 <syscalls+0x530>
    80006e18:	ffff9097          	auipc	ra,0xffff9
    80006e1c:	770080e7          	jalr	1904(ra) # 80000588 <printf>
    80006e20:	bf5d                	j	80006dd6 <uniq_run+0x5a>
    80006e22:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006e24:	8926                	mv	s2,s1
    80006e26:	84be                	mv	s1,a5
        lineCount = 1;
    80006e28:	8b6a                	mv	s6,s10
    80006e2a:	a8ed                	j	80006f24 <uniq_run+0x1a8>
    int lineCount=1;
    80006e2c:	4b05                	li	s6,1
  char * line2 = buffer2;
    80006e2e:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
    80006e32:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
    80006e36:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
    80006e38:	4d05                	li	s10,1
              printf("%s",line1);
    80006e3a:	00003d97          	auipc	s11,0x3
    80006e3e:	b3ed8d93          	addi	s11,s11,-1218 # 80009978 <syscalls+0x528>
    80006e42:	a0cd                	j	80006f24 <uniq_run+0x1a8>
            if (repeatedLines){
    80006e44:	020a0b63          	beqz	s4,80006e7a <uniq_run+0xfe>
                if (isRepeated){
    80006e48:	f80b87e3          	beqz	s7,80006dd6 <uniq_run+0x5a>
                    if (showCount)
    80006e4c:	000c0d63          	beqz	s8,80006e66 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
    80006e50:	864a                	mv	a2,s2
    80006e52:	85da                	mv	a1,s6
    80006e54:	00003517          	auipc	a0,0x3
    80006e58:	b5450513          	addi	a0,a0,-1196 # 800099a8 <syscalls+0x558>
    80006e5c:	ffff9097          	auipc	ra,0xffff9
    80006e60:	72c080e7          	jalr	1836(ra) # 80000588 <printf>
    80006e64:	bf8d                	j	80006dd6 <uniq_run+0x5a>
                      printf("%s",line1);
    80006e66:	85ca                	mv	a1,s2
    80006e68:	00003517          	auipc	a0,0x3
    80006e6c:	b1050513          	addi	a0,a0,-1264 # 80009978 <syscalls+0x528>
    80006e70:	ffff9097          	auipc	ra,0xffff9
    80006e74:	718080e7          	jalr	1816(ra) # 80000588 <printf>
    80006e78:	bfb9                	j	80006dd6 <uniq_run+0x5a>
                if (showCount)
    80006e7a:	000c0d63          	beqz	s8,80006e94 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
    80006e7e:	864a                	mv	a2,s2
    80006e80:	85da                	mv	a1,s6
    80006e82:	00003517          	auipc	a0,0x3
    80006e86:	b2650513          	addi	a0,a0,-1242 # 800099a8 <syscalls+0x558>
    80006e8a:	ffff9097          	auipc	ra,0xffff9
    80006e8e:	6fe080e7          	jalr	1790(ra) # 80000588 <printf>
    80006e92:	b791                	j	80006dd6 <uniq_run+0x5a>
                  printf("%s",line1);
    80006e94:	85ca                	mv	a1,s2
    80006e96:	00003517          	auipc	a0,0x3
    80006e9a:	ae250513          	addi	a0,a0,-1310 # 80009978 <syscalls+0x528>
    80006e9e:	ffff9097          	auipc	ra,0xffff9
    80006ea2:	6ea080e7          	jalr	1770(ra) # 80000588 <printf>
    80006ea6:	bf05                	j	80006dd6 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
    80006ea8:	00003517          	auipc	a0,0x3
    80006eac:	b0850513          	addi	a0,a0,-1272 # 800099b0 <syscalls+0x560>
    80006eb0:	ffff9097          	auipc	ra,0xffff9
    80006eb4:	6d8080e7          	jalr	1752(ra) # 80000588 <printf>
          break;
    80006eb8:	bf39                	j	80006dd6 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
    80006eba:	85a6                	mv	a1,s1
    80006ebc:	854a                	mv	a0,s2
    80006ebe:	00000097          	auipc	ra,0x0
    80006ec2:	d5e080e7          	jalr	-674(ra) # 80006c1c <compare_str_ic>
    80006ec6:	a041                	j	80006f46 <uniq_run+0x1ca>
                  printf("%s",line1);
    80006ec8:	85ca                	mv	a1,s2
    80006eca:	856e                	mv	a0,s11
    80006ecc:	ffff9097          	auipc	ra,0xffff9
    80006ed0:	6bc080e7          	jalr	1724(ra) # 80000588 <printf>
        lineCount = 1;
    80006ed4:	8b5e                	mv	s6,s7
                  printf("%s",line1);
    80006ed6:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006ed8:	8926                	mv	s2,s1
                  printf("%s",line1);
    80006eda:	84be                	mv	s1,a5
        isRepeated = 0 ;
    80006edc:	4b81                	li	s7,0
    80006ede:	a099                	j	80006f24 <uniq_run+0x1a8>
            if (showCount)
    80006ee0:	020c0263          	beqz	s8,80006f04 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
    80006ee4:	864a                	mv	a2,s2
    80006ee6:	85da                	mv	a1,s6
    80006ee8:	00003517          	auipc	a0,0x3
    80006eec:	ac050513          	addi	a0,a0,-1344 # 800099a8 <syscalls+0x558>
    80006ef0:	ffff9097          	auipc	ra,0xffff9
    80006ef4:	698080e7          	jalr	1688(ra) # 80000588 <printf>
    80006ef8:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006efa:	8926                	mv	s2,s1
    80006efc:	84be                	mv	s1,a5
        isRepeated = 0 ;
    80006efe:	4b81                	li	s7,0
        lineCount = 1;
    80006f00:	8b6a                	mv	s6,s10
    80006f02:	a00d                	j	80006f24 <uniq_run+0x1a8>
              printf("%s",line1);
    80006f04:	85ca                	mv	a1,s2
    80006f06:	856e                	mv	a0,s11
    80006f08:	ffff9097          	auipc	ra,0xffff9
    80006f0c:	680080e7          	jalr	1664(ra) # 80000588 <printf>
    80006f10:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006f12:	8926                	mv	s2,s1
              printf("%s",line1);
    80006f14:	84be                	mv	s1,a5
        isRepeated = 0 ;
    80006f16:	4b81                	li	s7,0
        lineCount = 1;
    80006f18:	8b6a                	mv	s6,s10
    80006f1a:	a029                	j	80006f24 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
    80006f1c:	000a0363          	beqz	s4,80006f22 <uniq_run+0x1a6>
    80006f20:	8bea                	mv	s7,s10
          lineCount++;
    80006f22:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
    80006f24:	85a6                	mv	a1,s1
    80006f26:	854e                	mv	a0,s3
    80006f28:	00000097          	auipc	ra,0x0
    80006f2c:	b52080e7          	jalr	-1198(ra) # 80006a7a <read_line>
        if (readStatus == READ_EOF){
    80006f30:	d911                	beqz	a0,80006e44 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
    80006f32:	f7950be3          	beq	a0,s9,80006ea8 <uniq_run+0x12c>
        if (!ignoreCase)
    80006f36:	f80a92e3          	bnez	s5,80006eba <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
    80006f3a:	85a6                	mv	a1,s1
    80006f3c:	854a                	mv	a0,s2
    80006f3e:	00000097          	auipc	ra,0x0
    80006f42:	cb0080e7          	jalr	-848(ra) # 80006bee <compare_str>
        if (compareStatus != 0){ 
    80006f46:	d979                	beqz	a0,80006f1c <uniq_run+0x1a0>
          if (repeatedLines){
    80006f48:	f80a0ce3          	beqz	s4,80006ee0 <uniq_run+0x164>
            if (isRepeated){
    80006f4c:	ec0b8be3          	beqz	s7,80006e22 <uniq_run+0xa6>
                if (showCount)
    80006f50:	f60c0ce3          	beqz	s8,80006ec8 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
    80006f54:	864a                	mv	a2,s2
    80006f56:	85da                	mv	a1,s6
    80006f58:	00003517          	auipc	a0,0x3
    80006f5c:	a5050513          	addi	a0,a0,-1456 # 800099a8 <syscalls+0x558>
    80006f60:	ffff9097          	auipc	ra,0xffff9
    80006f64:	628080e7          	jalr	1576(ra) # 80000588 <printf>
        lineCount = 1;
    80006f68:	8b5e                	mv	s6,s7
    80006f6a:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006f6c:	8926                	mv	s2,s1
    80006f6e:	84be                	mv	s1,a5
        isRepeated = 0 ;
    80006f70:	4b81                	li	s7,0
    80006f72:	bf4d                	j	80006f24 <uniq_run+0x1a8>

0000000080006f74 <get_process_status>:


/*
Prints the status of all the processes in the system
*/
void get_process_status(int tpid, int tppid, int tstatus, uint64 pName){
    80006f74:	7151                	addi	sp,sp,-240
    80006f76:	f586                	sd	ra,232(sp)
    80006f78:	f1a2                	sd	s0,224(sp)
    80006f7a:	eda6                	sd	s1,216(sp)
    80006f7c:	e9ca                	sd	s2,208(sp)
    80006f7e:	e5ce                	sd	s3,200(sp)
    80006f80:	e1d2                	sd	s4,192(sp)
    80006f82:	fd56                	sd	s5,184(sp)
    80006f84:	f95a                	sd	s6,176(sp)
    80006f86:	f55e                	sd	s7,168(sp)
    80006f88:	f162                	sd	s8,160(sp)
    80006f8a:	ed66                	sd	s9,152(sp)
    80006f8c:	e96a                	sd	s10,144(sp)
    80006f8e:	e56e                	sd	s11,136(sp)
    80006f90:	1980                	addi	s0,sp,240
    80006f92:	8aaa                	mv	s5,a0
    80006f94:	8bae                	mv	s7,a1
    80006f96:	8d32                	mv	s10,a2
    80006f98:	8c36                	mv	s8,a3


	struct proc *pp;
	int havekids, pid;
	struct proc *p = myproc();
    80006f9a:	ffffb097          	auipc	ra,0xffffb
    80006f9e:	a10080e7          	jalr	-1520(ra) # 800019aa <myproc>
	int foundPID = 0;

	// For process name specific option
	int namesIDx = 0;

	acquire(&wait_lock);
    80006fa2:	0000b517          	auipc	a0,0xb
    80006fa6:	ec650513          	addi	a0,a0,-314 # 80011e68 <wait_lock>
    80006faa:	ffffa097          	auipc	ra,0xffffa
    80006fae:	c2a080e7          	jalr	-982(ra) # 80000bd4 <acquire>


	printf("PID\tPPID\t  STAT\t          STIME\t\t         ETIME\t\t     TTIME\t     NAME\n");
    80006fb2:	00003517          	auipc	a0,0x3
    80006fb6:	a2650513          	addi	a0,a0,-1498 # 800099d8 <syscalls+0x588>
    80006fba:	ffff9097          	auipc	ra,0xffff9
    80006fbe:	5ce080e7          	jalr	1486(ra) # 80000588 <printf>
	printf("---\t----\t--------   --------------------\t-------------------- --------------------  ---------\n");
    80006fc2:	00003517          	auipc	a0,0x3
    80006fc6:	a5e50513          	addi	a0,a0,-1442 # 80009a20 <syscalls+0x5d0>
    80006fca:	ffff9097          	auipc	ra,0xffff9
    80006fce:	5be080e7          	jalr	1470(ra) # 80000588 <printf>


	for (int i=0;i<NPROC;i++){
    80006fd2:	0000b497          	auipc	s1,0xb
    80006fd6:	40648493          	addi	s1,s1,1030 # 800123d8 <proc+0x158>
    80006fda:	00011c97          	auipc	s9,0x11
    80006fde:	3fec8c93          	addi	s9,s9,1022 # 800183d8 <proc+0x6158>
	int foundPID = 0;
    80006fe2:	4d81                	li	s11,0
			tick2time(p->execTime.endTime*100);
			tick2time(p->execTime.totalTime*100);
		}
		else if (p->state == USED){
			printf("%d\t %d\t%s     ",p->pid, parentID, "USED");
			tick2time(p->execTime.creationTime*100);
    80006fe4:	6b3d                	lui	s6,0xf
    80006fe6:	a60b0b13          	addi	s6,s6,-1440 # ea60 <_entry-0x7fff15a0>
		if (tstatus >= 0 && p->state != tstatus){
    80006fea:	000d079b          	sext.w	a5,s10
    80006fee:	f0f43823          	sd	a5,-240(s0)
    80006ff2:	a231                	j	800070fe <get_process_status+0x18a>
			release(&p->lock);
    80006ff4:	854a                	mv	a0,s2
    80006ff6:	ffffa097          	auipc	ra,0xffffa
    80006ffa:	c92080e7          	jalr	-878(ra) # 80000c88 <release>
			foundPID = 1;
    80006ffe:	4d85                	li	s11,1
			continue;
    80007000:	a8dd                	j	800070f6 <get_process_status+0x182>
			fetchstr(pName, processName, 100);
    80007002:	06400613          	li	a2,100
    80007006:	f2840593          	addi	a1,s0,-216
    8000700a:	8562                	mv	a0,s8
    8000700c:	ffffc097          	auipc	ra,0xffffc
    80007010:	b38080e7          	jalr	-1224(ra) # 80002b44 <fetchstr>
			if (check_substr(processName, p->name)==-1){
    80007014:	85a6                	mv	a1,s1
    80007016:	f2840513          	addi	a0,s0,-216
    8000701a:	00000097          	auipc	ra,0x0
    8000701e:	c5e080e7          	jalr	-930(ra) # 80006c78 <check_substr>
    80007022:	57fd                	li	a5,-1
    80007024:	0ef51c63          	bne	a0,a5,8000711c <get_process_status+0x1a8>
				release(&p->lock);
    80007028:	854a                	mv	a0,s2
    8000702a:	ffffa097          	auipc	ra,0xffffa
    8000702e:	c5e080e7          	jalr	-930(ra) # 80000c88 <release>
				continue;
    80007032:	a0d1                	j	800070f6 <get_process_status+0x182>
			release(&p->lock);
    80007034:	854a                	mv	a0,s2
    80007036:	ffffa097          	auipc	ra,0xffffa
    8000703a:	c52080e7          	jalr	-942(ra) # 80000c88 <release>
			continue;
    8000703e:	a865                	j	800070f6 <get_process_status+0x182>
			release(&p->lock);
    80007040:	854a                	mv	a0,s2
    80007042:	ffffa097          	auipc	ra,0xffffa
    80007046:	c46080e7          	jalr	-954(ra) # 80000c88 <release>
			continue;
    8000704a:	a075                	j	800070f6 <get_process_status+0x182>
			printf("%d\t %d\t%s     ",p->pid, parentID, "Sleeping");
    8000704c:	00003697          	auipc	a3,0x3
    80007050:	a3468693          	addi	a3,a3,-1484 # 80009a80 <syscalls+0x630>
    80007054:	8652                	mv	a2,s4
    80007056:	ed89a583          	lw	a1,-296(s3)
    8000705a:	00003517          	auipc	a0,0x3
    8000705e:	a3650513          	addi	a0,a0,-1482 # 80009a90 <syscalls+0x640>
    80007062:	ffff9097          	auipc	ra,0xffff9
    80007066:	526080e7          	jalr	1318(ra) # 80000588 <printf>
			tick2time(p->execTime.creationTime*100);
    8000706a:	0109b583          	ld	a1,16(s3)
    8000706e:	06400793          	li	a5,100
    80007072:	02b785b3          	mul	a1,a5,a1
    80007076:	0365f633          	remu	a2,a1,s6
    8000707a:	3e800a13          	li	s4,1000
    8000707e:	034676b3          	remu	a3,a2,s4
    80007082:	03465633          	divu	a2,a2,s4
    80007086:	0365d5b3          	divu	a1,a1,s6
    8000708a:	00003517          	auipc	a0,0x3
    8000708e:	a1650513          	addi	a0,a0,-1514 # 80009aa0 <syscalls+0x650>
    80007092:	ffff9097          	auipc	ra,0xffff9
    80007096:	4f6080e7          	jalr	1270(ra) # 80000588 <printf>
			printf("      In progress        ");
    8000709a:	00003517          	auipc	a0,0x3
    8000709e:	a1e50513          	addi	a0,a0,-1506 # 80009ab8 <syscalls+0x668>
    800070a2:	ffff9097          	auipc	ra,0xffff9
    800070a6:	4e6080e7          	jalr	1254(ra) # 80000588 <printf>
			tick2time(time*100);
    800070aa:	f1843703          	ld	a4,-232(s0)
    800070ae:	06400793          	li	a5,100
    800070b2:	02f705b3          	mul	a1,a4,a5
    800070b6:	0365f633          	remu	a2,a1,s6
    800070ba:	034676b3          	remu	a3,a2,s4
    800070be:	03465633          	divu	a2,a2,s4
    800070c2:	0365d5b3          	divu	a1,a1,s6
    800070c6:	00003517          	auipc	a0,0x3
    800070ca:	9da50513          	addi	a0,a0,-1574 # 80009aa0 <syscalls+0x650>
    800070ce:	ffff9097          	auipc	ra,0xffff9
    800070d2:	4ba080e7          	jalr	1210(ra) # 80000588 <printf>
			printf("     %s\n",p->name);
    800070d6:	85ce                	mv	a1,s3
    800070d8:	00003517          	auipc	a0,0x3
    800070dc:	a0050513          	addi	a0,a0,-1536 # 80009ad8 <syscalls+0x688>
    800070e0:	ffff9097          	auipc	ra,0xffff9
    800070e4:	4a8080e7          	jalr	1192(ra) # 80000588 <printf>
			tick2time(p->execTime.endTime*100);
			tick2time(p->execTime.totalTime*100);
		}

		release(&p->lock);
    800070e8:	854a                	mv	a0,s2
    800070ea:	ffffa097          	auipc	ra,0xffffa
    800070ee:	b9e080e7          	jalr	-1122(ra) # 80000c88 <release>

		if (foundPID){
    800070f2:	300d9563          	bnez	s11,800073fc <get_process_status+0x488>
	for (int i=0;i<NPROC;i++){
    800070f6:	18048493          	addi	s1,s1,384
    800070fa:	31948163          	beq	s1,s9,800073fc <get_process_status+0x488>
		acquire(&p->lock);
    800070fe:	ea848913          	addi	s2,s1,-344
    80007102:	854a                	mv	a0,s2
    80007104:	ffffa097          	auipc	ra,0xffffa
    80007108:	ad0080e7          	jalr	-1328(ra) # 80000bd4 <acquire>
		if (tpid >= 0 &&  tpid != p->pid){
    8000710c:	000ac663          	bltz	s5,80007118 <get_process_status+0x1a4>
    80007110:	ed84a783          	lw	a5,-296(s1)
    80007114:	ef5790e3          	bne	a5,s5,80006ff4 <get_process_status+0x80>
		if (pName!=0){
    80007118:	ee0c15e3          	bnez	s8,80007002 <get_process_status+0x8e>
		int parentID = (p->parent) ? p->parent->pid : 0;
    8000711c:	89a6                	mv	s3,s1
    8000711e:	ee04b783          	ld	a5,-288(s1)
    80007122:	4a01                	li	s4,0
    80007124:	c399                	beqz	a5,8000712a <get_process_status+0x1b6>
    80007126:	0307aa03          	lw	s4,48(a5)
		if (tppid >=0 && tppid!=parentID){
    8000712a:	000bc463          	bltz	s7,80007132 <get_process_status+0x1be>
    8000712e:	f17a13e3          	bne	s4,s7,80007034 <get_process_status+0xc0>
		if (tstatus >= 0 && p->state != tstatus){
    80007132:	000d4863          	bltz	s10,80007142 <get_process_status+0x1ce>
    80007136:	ec09a783          	lw	a5,-320(s3)
    8000713a:	f1043703          	ld	a4,-240(s0)
    8000713e:	f0e791e3          	bne	a5,a4,80007040 <get_process_status+0xcc>
		time_t time = sys_uptime();
    80007142:	ffffc097          	auipc	ra,0xffffc
    80007146:	126080e7          	jalr	294(ra) # 80003268 <sys_uptime>
    8000714a:	f0a43c23          	sd	a0,-232(s0)
		if (p->state == SLEEPING){
    8000714e:	ec09a783          	lw	a5,-320(s3)
    80007152:	4709                	li	a4,2
    80007154:	eee78ce3          	beq	a5,a4,8000704c <get_process_status+0xd8>
		else if (p->state == RUNNABLE){
    80007158:	470d                	li	a4,3
    8000715a:	0ae78f63          	beq	a5,a4,80007218 <get_process_status+0x2a4>
		else if (p->state == RUNNING){
    8000715e:	4711                	li	a4,4
    80007160:	14e78b63          	beq	a5,a4,800072b6 <get_process_status+0x342>
		else if (p->state == ZOMBIE ){
    80007164:	4715                	li	a4,5
    80007166:	1ee78763          	beq	a5,a4,80007354 <get_process_status+0x3e0>
		else if (p->state == USED){
    8000716a:	4705                	li	a4,1
    8000716c:	f6e79ee3          	bne	a5,a4,800070e8 <get_process_status+0x174>
			printf("%d\t %d\t%s     ",p->pid, parentID, "USED");
    80007170:	00003697          	auipc	a3,0x3
    80007174:	9b068693          	addi	a3,a3,-1616 # 80009b20 <syscalls+0x6d0>
    80007178:	8652                	mv	a2,s4
    8000717a:	ed89a583          	lw	a1,-296(s3)
    8000717e:	00003517          	auipc	a0,0x3
    80007182:	91250513          	addi	a0,a0,-1774 # 80009a90 <syscalls+0x640>
    80007186:	ffff9097          	auipc	ra,0xffff9
    8000718a:	402080e7          	jalr	1026(ra) # 80000588 <printf>
			tick2time(p->execTime.creationTime*100);
    8000718e:	0109b583          	ld	a1,16(s3)
    80007192:	06400793          	li	a5,100
    80007196:	02b785b3          	mul	a1,a5,a1
    8000719a:	0365f633          	remu	a2,a1,s6
    8000719e:	3e800a13          	li	s4,1000
    800071a2:	034676b3          	remu	a3,a2,s4
    800071a6:	03465633          	divu	a2,a2,s4
    800071aa:	0365d5b3          	divu	a1,a1,s6
    800071ae:	00003517          	auipc	a0,0x3
    800071b2:	8f250513          	addi	a0,a0,-1806 # 80009aa0 <syscalls+0x650>
    800071b6:	ffff9097          	auipc	ra,0xffff9
    800071ba:	3d2080e7          	jalr	978(ra) # 80000588 <printf>
			tick2time(p->execTime.endTime*100);
    800071be:	0189b583          	ld	a1,24(s3)
    800071c2:	06400793          	li	a5,100
    800071c6:	02b785b3          	mul	a1,a5,a1
    800071ca:	0365f633          	remu	a2,a1,s6
    800071ce:	034676b3          	remu	a3,a2,s4
    800071d2:	03465633          	divu	a2,a2,s4
    800071d6:	0365d5b3          	divu	a1,a1,s6
    800071da:	00003517          	auipc	a0,0x3
    800071de:	8c650513          	addi	a0,a0,-1850 # 80009aa0 <syscalls+0x650>
    800071e2:	ffff9097          	auipc	ra,0xffff9
    800071e6:	3a6080e7          	jalr	934(ra) # 80000588 <printf>
			tick2time(p->execTime.totalTime*100);
    800071ea:	0209b783          	ld	a5,32(s3)
    800071ee:	06400713          	li	a4,100
    800071f2:	02f705b3          	mul	a1,a4,a5
    800071f6:	0365f633          	remu	a2,a1,s6
    800071fa:	034676b3          	remu	a3,a2,s4
    800071fe:	03465633          	divu	a2,a2,s4
    80007202:	0365d5b3          	divu	a1,a1,s6
    80007206:	00003517          	auipc	a0,0x3
    8000720a:	89a50513          	addi	a0,a0,-1894 # 80009aa0 <syscalls+0x650>
    8000720e:	ffff9097          	auipc	ra,0xffff9
    80007212:	37a080e7          	jalr	890(ra) # 80000588 <printf>
    80007216:	bdc9                	j	800070e8 <get_process_status+0x174>
			printf("%d\t %d\t%s     ",p->pid, parentID, "Ready");
    80007218:	00003697          	auipc	a3,0x3
    8000721c:	8d068693          	addi	a3,a3,-1840 # 80009ae8 <syscalls+0x698>
    80007220:	8652                	mv	a2,s4
    80007222:	ed89a583          	lw	a1,-296(s3)
    80007226:	00003517          	auipc	a0,0x3
    8000722a:	86a50513          	addi	a0,a0,-1942 # 80009a90 <syscalls+0x640>
    8000722e:	ffff9097          	auipc	ra,0xffff9
    80007232:	35a080e7          	jalr	858(ra) # 80000588 <printf>
			tick2time(p->execTime.creationTime*100);
    80007236:	0109b583          	ld	a1,16(s3)
    8000723a:	06400793          	li	a5,100
    8000723e:	02b785b3          	mul	a1,a5,a1
    80007242:	0365f633          	remu	a2,a1,s6
    80007246:	3e800a13          	li	s4,1000
    8000724a:	034676b3          	remu	a3,a2,s4
    8000724e:	03465633          	divu	a2,a2,s4
    80007252:	0365d5b3          	divu	a1,a1,s6
    80007256:	00003517          	auipc	a0,0x3
    8000725a:	84a50513          	addi	a0,a0,-1974 # 80009aa0 <syscalls+0x650>
    8000725e:	ffff9097          	auipc	ra,0xffff9
    80007262:	32a080e7          	jalr	810(ra) # 80000588 <printf>
			printf("      In progress       ");
    80007266:	00003517          	auipc	a0,0x3
    8000726a:	88a50513          	addi	a0,a0,-1910 # 80009af0 <syscalls+0x6a0>
    8000726e:	ffff9097          	auipc	ra,0xffff9
    80007272:	31a080e7          	jalr	794(ra) # 80000588 <printf>
			tick2time(time*100);
    80007276:	f1843703          	ld	a4,-232(s0)
    8000727a:	06400793          	li	a5,100
    8000727e:	02f705b3          	mul	a1,a4,a5
    80007282:	0365f633          	remu	a2,a1,s6
    80007286:	034676b3          	remu	a3,a2,s4
    8000728a:	03465633          	divu	a2,a2,s4
    8000728e:	0365d5b3          	divu	a1,a1,s6
    80007292:	00003517          	auipc	a0,0x3
    80007296:	80e50513          	addi	a0,a0,-2034 # 80009aa0 <syscalls+0x650>
    8000729a:	ffff9097          	auipc	ra,0xffff9
    8000729e:	2ee080e7          	jalr	750(ra) # 80000588 <printf>
			printf("     %s\n",p->name);
    800072a2:	85ce                	mv	a1,s3
    800072a4:	00003517          	auipc	a0,0x3
    800072a8:	83450513          	addi	a0,a0,-1996 # 80009ad8 <syscalls+0x688>
    800072ac:	ffff9097          	auipc	ra,0xffff9
    800072b0:	2dc080e7          	jalr	732(ra) # 80000588 <printf>
    800072b4:	bd15                	j	800070e8 <get_process_status+0x174>
			printf("%d\t %d\t%s     ",p->pid, parentID, "Running");
    800072b6:	00003697          	auipc	a3,0x3
    800072ba:	85a68693          	addi	a3,a3,-1958 # 80009b10 <syscalls+0x6c0>
    800072be:	8652                	mv	a2,s4
    800072c0:	ed89a583          	lw	a1,-296(s3)
    800072c4:	00002517          	auipc	a0,0x2
    800072c8:	7cc50513          	addi	a0,a0,1996 # 80009a90 <syscalls+0x640>
    800072cc:	ffff9097          	auipc	ra,0xffff9
    800072d0:	2bc080e7          	jalr	700(ra) # 80000588 <printf>
			tick2time(p->execTime.creationTime*100);
    800072d4:	0109b583          	ld	a1,16(s3)
    800072d8:	06400793          	li	a5,100
    800072dc:	02b785b3          	mul	a1,a5,a1
    800072e0:	0365f633          	remu	a2,a1,s6
    800072e4:	3e800a13          	li	s4,1000
    800072e8:	034676b3          	remu	a3,a2,s4
    800072ec:	03465633          	divu	a2,a2,s4
    800072f0:	0365d5b3          	divu	a1,a1,s6
    800072f4:	00002517          	auipc	a0,0x2
    800072f8:	7ac50513          	addi	a0,a0,1964 # 80009aa0 <syscalls+0x650>
    800072fc:	ffff9097          	auipc	ra,0xffff9
    80007300:	28c080e7          	jalr	652(ra) # 80000588 <printf>
			printf("      In progress        ");
    80007304:	00002517          	auipc	a0,0x2
    80007308:	7b450513          	addi	a0,a0,1972 # 80009ab8 <syscalls+0x668>
    8000730c:	ffff9097          	auipc	ra,0xffff9
    80007310:	27c080e7          	jalr	636(ra) # 80000588 <printf>
			tick2time(time*100);
    80007314:	f1843703          	ld	a4,-232(s0)
    80007318:	06400793          	li	a5,100
    8000731c:	02f705b3          	mul	a1,a4,a5
    80007320:	0365f633          	remu	a2,a1,s6
    80007324:	034676b3          	remu	a3,a2,s4
    80007328:	03465633          	divu	a2,a2,s4
    8000732c:	0365d5b3          	divu	a1,a1,s6
    80007330:	00002517          	auipc	a0,0x2
    80007334:	77050513          	addi	a0,a0,1904 # 80009aa0 <syscalls+0x650>
    80007338:	ffff9097          	auipc	ra,0xffff9
    8000733c:	250080e7          	jalr	592(ra) # 80000588 <printf>
			printf("     %s\n",p->name);
    80007340:	85ce                	mv	a1,s3
    80007342:	00002517          	auipc	a0,0x2
    80007346:	79650513          	addi	a0,a0,1942 # 80009ad8 <syscalls+0x688>
    8000734a:	ffff9097          	auipc	ra,0xffff9
    8000734e:	23e080e7          	jalr	574(ra) # 80000588 <printf>
    80007352:	bb59                	j	800070e8 <get_process_status+0x174>
			printf("%d\t %d\t%s     ",p->pid, parentID, "ZOMBIE");
    80007354:	00002697          	auipc	a3,0x2
    80007358:	7c468693          	addi	a3,a3,1988 # 80009b18 <syscalls+0x6c8>
    8000735c:	8652                	mv	a2,s4
    8000735e:	ed89a583          	lw	a1,-296(s3)
    80007362:	00002517          	auipc	a0,0x2
    80007366:	72e50513          	addi	a0,a0,1838 # 80009a90 <syscalls+0x640>
    8000736a:	ffff9097          	auipc	ra,0xffff9
    8000736e:	21e080e7          	jalr	542(ra) # 80000588 <printf>
			tick2time(p->execTime.creationTime*100);
    80007372:	0109b583          	ld	a1,16(s3)
    80007376:	06400793          	li	a5,100
    8000737a:	02b785b3          	mul	a1,a5,a1
    8000737e:	0365f633          	remu	a2,a1,s6
    80007382:	3e800a13          	li	s4,1000
    80007386:	034676b3          	remu	a3,a2,s4
    8000738a:	03465633          	divu	a2,a2,s4
    8000738e:	0365d5b3          	divu	a1,a1,s6
    80007392:	00002517          	auipc	a0,0x2
    80007396:	70e50513          	addi	a0,a0,1806 # 80009aa0 <syscalls+0x650>
    8000739a:	ffff9097          	auipc	ra,0xffff9
    8000739e:	1ee080e7          	jalr	494(ra) # 80000588 <printf>
			tick2time(p->execTime.endTime*100);
    800073a2:	0189b583          	ld	a1,24(s3)
    800073a6:	06400793          	li	a5,100
    800073aa:	02b785b3          	mul	a1,a5,a1
    800073ae:	0365f633          	remu	a2,a1,s6
    800073b2:	034676b3          	remu	a3,a2,s4
    800073b6:	03465633          	divu	a2,a2,s4
    800073ba:	0365d5b3          	divu	a1,a1,s6
    800073be:	00002517          	auipc	a0,0x2
    800073c2:	6e250513          	addi	a0,a0,1762 # 80009aa0 <syscalls+0x650>
    800073c6:	ffff9097          	auipc	ra,0xffff9
    800073ca:	1c2080e7          	jalr	450(ra) # 80000588 <printf>
			tick2time(p->execTime.totalTime*100);
    800073ce:	0209b783          	ld	a5,32(s3)
    800073d2:	06400713          	li	a4,100
    800073d6:	02f705b3          	mul	a1,a4,a5
    800073da:	0365f633          	remu	a2,a1,s6
    800073de:	034676b3          	remu	a3,a2,s4
    800073e2:	03465633          	divu	a2,a2,s4
    800073e6:	0365d5b3          	divu	a1,a1,s6
    800073ea:	00002517          	auipc	a0,0x2
    800073ee:	6b650513          	addi	a0,a0,1718 # 80009aa0 <syscalls+0x650>
    800073f2:	ffff9097          	auipc	ra,0xffff9
    800073f6:	196080e7          	jalr	406(ra) # 80000588 <printf>
    800073fa:	b1fd                	j	800070e8 <get_process_status+0x174>
			break;
		}
	}
	release(&wait_lock);
    800073fc:	0000b517          	auipc	a0,0xb
    80007400:	a6c50513          	addi	a0,a0,-1428 # 80011e68 <wait_lock>
    80007404:	ffffa097          	auipc	ra,0xffffa
    80007408:	884080e7          	jalr	-1916(ra) # 80000c88 <release>
}
    8000740c:	70ae                	ld	ra,232(sp)
    8000740e:	740e                	ld	s0,224(sp)
    80007410:	64ee                	ld	s1,216(sp)
    80007412:	694e                	ld	s2,208(sp)
    80007414:	69ae                	ld	s3,200(sp)
    80007416:	6a0e                	ld	s4,192(sp)
    80007418:	7aea                	ld	s5,184(sp)
    8000741a:	7b4a                	ld	s6,176(sp)
    8000741c:	7baa                	ld	s7,168(sp)
    8000741e:	7c0a                	ld	s8,160(sp)
    80007420:	6cea                	ld	s9,152(sp)
    80007422:	6d4a                	ld	s10,144(sp)
    80007424:	6daa                	ld	s11,136(sp)
    80007426:	616d                	addi	sp,sp,240
    80007428:	8082                	ret

000000008000742a <freeproc>:
extern struct proc proc[NPROC];
extern struct spinlock wait_lock;

extern uint64 sys_uptime(void);

void freeproc(struct proc *p){
    8000742a:	1101                	addi	sp,sp,-32
    8000742c:	ec06                	sd	ra,24(sp)
    8000742e:	e822                	sd	s0,16(sp)
    80007430:	e426                	sd	s1,8(sp)
    80007432:	1000                	addi	s0,sp,32
    80007434:	84aa                	mv	s1,a0

  if(p->trapframe)
    80007436:	6d28                	ld	a0,88(a0)
    80007438:	c509                	beqz	a0,80007442 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000743a:	ffff9097          	auipc	ra,0xffff9
    8000743e:	5ac080e7          	jalr	1452(ra) # 800009e6 <kfree>
  p->trapframe = 0;
    80007442:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80007446:	68a8                	ld	a0,80(s1)
    80007448:	c511                	beqz	a0,80007454 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000744a:	64ac                	ld	a1,72(s1)
    8000744c:	ffffa097          	auipc	ra,0xffffa
    80007450:	6be080e7          	jalr	1726(ra) # 80001b0a <proc_freepagetable>
  p->pagetable = 0;
    80007454:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80007458:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000745c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80007460:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80007464:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80007468:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000746c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80007470:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80007474:	0004ac23          	sw	zero,24(s1)
}
    80007478:	60e2                	ld	ra,24(sp)
    8000747a:	6442                	ld	s0,16(sp)
    8000747c:	64a2                	ld	s1,8(sp)
    8000747e:	6105                	addi	sp,sp,32
    80007480:	8082                	ret

0000000080007482 <get_process_time>:





int get_process_time(int tpid, uint64 uaddr, uint64 addr){
    80007482:	711d                	addi	sp,sp,-96
    80007484:	ec86                	sd	ra,88(sp)
    80007486:	e8a2                	sd	s0,80(sp)
    80007488:	e4a6                	sd	s1,72(sp)
    8000748a:	e0ca                	sd	s2,64(sp)
    8000748c:	fc4e                	sd	s3,56(sp)
    8000748e:	f852                	sd	s4,48(sp)
    80007490:	f456                	sd	s5,40(sp)
    80007492:	f05a                	sd	s6,32(sp)
    80007494:	ec5e                	sd	s7,24(sp)
    80007496:	e862                	sd	s8,16(sp)
    80007498:	e466                	sd	s9,8(sp)
    8000749a:	e06a                	sd	s10,0(sp)
    8000749c:	1080                	addi	s0,sp,96
    8000749e:	8baa                	mv	s7,a0
    800074a0:	8c2e                	mv	s8,a1
    800074a2:	8b32                	mv	s6,a2

	struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();
    800074a4:	ffffa097          	auipc	ra,0xffffa
    800074a8:	506080e7          	jalr	1286(ra) # 800019aa <myproc>
    800074ac:	892a                	mv	s2,a0

  acquire(&wait_lock);
    800074ae:	0000b517          	auipc	a0,0xb
    800074b2:	9ba50513          	addi	a0,a0,-1606 # 80011e68 <wait_lock>
    800074b6:	ffff9097          	auipc	ra,0xffff9
    800074ba:	71e080e7          	jalr	1822(ra) # 80000bd4 <acquire>

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    800074be:	4c81                	li	s9,0
      if(pp->parent == p){
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);

        havekids = 1;
        if(pp->state == ZOMBIE){
    800074c0:	4a15                	li	s4,5
        havekids = 1;
    800074c2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800074c4:	00011997          	auipc	s3,0x11
    800074c8:	1bc98993          	addi	s3,s3,444 # 80018680 <tickslock>
      release(&wait_lock);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800074cc:	0000bd17          	auipc	s10,0xb
    800074d0:	99cd0d13          	addi	s10,s10,-1636 # 80011e68 <wait_lock>
    havekids = 0;
    800074d4:	8766                	mv	a4,s9
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800074d6:	0000b497          	auipc	s1,0xb
    800074da:	daa48493          	addi	s1,s1,-598 # 80012280 <proc>
    800074de:	a055                	j	80007582 <get_process_time+0x100>
          pid = pp->pid;
    800074e0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800074e4:	020b1863          	bnez	s6,80007514 <get_process_time+0x92>
          if (pp->pid == tpid){
    800074e8:	589c                	lw	a5,48(s1)
    800074ea:	07778063          	beq	a5,s7,8000754a <get_process_time+0xc8>
          freeproc(pp);
    800074ee:	8526                	mv	a0,s1
    800074f0:	00000097          	auipc	ra,0x0
    800074f4:	f3a080e7          	jalr	-198(ra) # 8000742a <freeproc>
          release(&pp->lock);
    800074f8:	8526                	mv	a0,s1
    800074fa:	ffff9097          	auipc	ra,0xffff9
    800074fe:	78e080e7          	jalr	1934(ra) # 80000c88 <release>
          release(&wait_lock);
    80007502:	0000b517          	auipc	a0,0xb
    80007506:	96650513          	addi	a0,a0,-1690 # 80011e68 <wait_lock>
    8000750a:	ffff9097          	auipc	ra,0xffff9
    8000750e:	77e080e7          	jalr	1918(ra) # 80000c88 <release>
          return pid;
    80007512:	a0d1                	j	800075d6 <get_process_time+0x154>
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80007514:	4691                	li	a3,4
    80007516:	02c48613          	addi	a2,s1,44
    8000751a:	85da                	mv	a1,s6
    8000751c:	05093503          	ld	a0,80(s2)
    80007520:	ffffa097          	auipc	ra,0xffffa
    80007524:	14a080e7          	jalr	330(ra) # 8000166a <copyout>
    80007528:	fc0550e3          	bgez	a0,800074e8 <get_process_time+0x66>
            release(&pp->lock);
    8000752c:	8526                	mv	a0,s1
    8000752e:	ffff9097          	auipc	ra,0xffff9
    80007532:	75a080e7          	jalr	1882(ra) # 80000c88 <release>
            release(&wait_lock);
    80007536:	0000b517          	auipc	a0,0xb
    8000753a:	93250513          	addi	a0,a0,-1742 # 80011e68 <wait_lock>
    8000753e:	ffff9097          	auipc	ra,0xffff9
    80007542:	74a080e7          	jalr	1866(ra) # 80000c88 <release>
            return -1;
    80007546:	59fd                	li	s3,-1
    80007548:	a079                	j	800075d6 <get_process_time+0x154>
			        p->execTime.endTime = sys_uptime();
    8000754a:	ffffc097          	auipc	ra,0xffffc
    8000754e:	d1e080e7          	jalr	-738(ra) # 80003268 <sys_uptime>
    80007552:	16a93823          	sd	a0,368(s2)
			        p->execTime.totalTime = p->execTime.endTime - p->execTime.creationTime;
    80007556:	16893703          	ld	a4,360(s2)
    8000755a:	40e507b3          	sub	a5,a0,a4
    8000755e:	16f93c23          	sd	a5,376(s2)
      		    copyout(p->pagetable, uaddr, &(p->execTime) , sizeof(e_time_t));
    80007562:	02000693          	li	a3,32
    80007566:	16890613          	addi	a2,s2,360
    8000756a:	85e2                	mv	a1,s8
    8000756c:	05093503          	ld	a0,80(s2)
    80007570:	ffffa097          	auipc	ra,0xffffa
    80007574:	0fa080e7          	jalr	250(ra) # 8000166a <copyout>
    80007578:	bf9d                	j	800074ee <get_process_time+0x6c>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000757a:	19048493          	addi	s1,s1,400
    8000757e:	03348463          	beq	s1,s3,800075a6 <get_process_time+0x124>
      if(pp->parent == p){
    80007582:	7c9c                	ld	a5,56(s1)
    80007584:	ff279be3          	bne	a5,s2,8000757a <get_process_time+0xf8>
        acquire(&pp->lock);
    80007588:	8526                	mv	a0,s1
    8000758a:	ffff9097          	auipc	ra,0xffff9
    8000758e:	64a080e7          	jalr	1610(ra) # 80000bd4 <acquire>
        if(pp->state == ZOMBIE){
    80007592:	4c9c                	lw	a5,24(s1)
    80007594:	f54786e3          	beq	a5,s4,800074e0 <get_process_time+0x5e>
        release(&pp->lock);
    80007598:	8526                	mv	a0,s1
    8000759a:	ffff9097          	auipc	ra,0xffff9
    8000759e:	6ee080e7          	jalr	1774(ra) # 80000c88 <release>
        havekids = 1;
    800075a2:	8756                	mv	a4,s5
    800075a4:	bfd9                	j	8000757a <get_process_time+0xf8>
    if(!havekids || killed(p)){
    800075a6:	c719                	beqz	a4,800075b4 <get_process_time+0x132>
    800075a8:	854a                	mv	a0,s2
    800075aa:	ffffb097          	auipc	ra,0xffffb
    800075ae:	e14080e7          	jalr	-492(ra) # 800023be <killed>
    800075b2:	c129                	beqz	a0,800075f4 <get_process_time+0x172>
    	printf("NO CHILD\n");
    800075b4:	00002517          	auipc	a0,0x2
    800075b8:	57450513          	addi	a0,a0,1396 # 80009b28 <syscalls+0x6d8>
    800075bc:	ffff9097          	auipc	ra,0xffff9
    800075c0:	fcc080e7          	jalr	-52(ra) # 80000588 <printf>
      release(&wait_lock);
    800075c4:	0000b517          	auipc	a0,0xb
    800075c8:	8a450513          	addi	a0,a0,-1884 # 80011e68 <wait_lock>
    800075cc:	ffff9097          	auipc	ra,0xffff9
    800075d0:	6bc080e7          	jalr	1724(ra) # 80000c88 <release>
      return -1;
    800075d4:	59fd                	li	s3,-1
  }
}
    800075d6:	854e                	mv	a0,s3
    800075d8:	60e6                	ld	ra,88(sp)
    800075da:	6446                	ld	s0,80(sp)
    800075dc:	64a6                	ld	s1,72(sp)
    800075de:	6906                	ld	s2,64(sp)
    800075e0:	79e2                	ld	s3,56(sp)
    800075e2:	7a42                	ld	s4,48(sp)
    800075e4:	7aa2                	ld	s5,40(sp)
    800075e6:	7b02                	ld	s6,32(sp)
    800075e8:	6be2                	ld	s7,24(sp)
    800075ea:	6c42                	ld	s8,16(sp)
    800075ec:	6ca2                	ld	s9,8(sp)
    800075ee:	6d02                	ld	s10,0(sp)
    800075f0:	6125                	addi	sp,sp,96
    800075f2:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800075f4:	85ea                	mv	a1,s10
    800075f6:	854a                	mv	a0,s2
    800075f8:	ffffb097          	auipc	ra,0xffffb
    800075fc:	afa080e7          	jalr	-1286(ra) # 800020f2 <sleep>
    havekids = 0;
    80007600:	bdd1                	j	800074d4 <get_process_time+0x52>

0000000080007602 <change_priority>:
[Output]
	Returns 1 if sucessful, else 0
*/
int change_priority(int pid, int priority){

	if (!(priority>=MIN_PRIORITY && priority<=MAX_PRIORITY))
    80007602:	fff5871b          	addiw	a4,a1,-1
    80007606:	47cd                	li	a5,19
    80007608:	08e7e463          	bltu	a5,a4,80007690 <change_priority+0x8e>
int change_priority(int pid, int priority){
    8000760c:	7139                	addi	sp,sp,-64
    8000760e:	fc06                	sd	ra,56(sp)
    80007610:	f822                	sd	s0,48(sp)
    80007612:	f426                	sd	s1,40(sp)
    80007614:	f04a                	sd	s2,32(sp)
    80007616:	ec4e                	sd	s3,24(sp)
    80007618:	e852                	sd	s4,16(sp)
    8000761a:	e456                	sd	s5,8(sp)
    8000761c:	e05a                	sd	s6,0(sp)
    8000761e:	0080                	addi	s0,sp,64
    80007620:	89aa                	mv	s3,a0
    80007622:	8b2e                	mv	s6,a1
    80007624:	0000b497          	auipc	s1,0xb
    80007628:	c5c48493          	addi	s1,s1,-932 # 80012280 <proc>
		return 0;

	struct proc *p;

	for (int i=0;i<NPROC;i++){
    8000762c:	4901                	li	s2,0
    8000762e:	04000a93          	li	s5,64
		
		struct proc * p = &proc[i];

		acquire(&p->lock);
    80007632:	8526                	mv	a0,s1
    80007634:	ffff9097          	auipc	ra,0xffff9
    80007638:	5a0080e7          	jalr	1440(ra) # 80000bd4 <acquire>

		if(p->pid == pid) {
    8000763c:	589c                	lw	a5,48(s1)
    8000763e:	01378e63          	beq	a5,s3,8000765a <change_priority+0x58>
	    	p->priority = priority;
	    	release(&p->lock);
	    	return 1;
	    }
	    release(&p->lock);
    80007642:	8526                	mv	a0,s1
    80007644:	ffff9097          	auipc	ra,0xffff9
    80007648:	644080e7          	jalr	1604(ra) # 80000c88 <release>
	for (int i=0;i<NPROC;i++){
    8000764c:	2905                	addiw	s2,s2,1
    8000764e:	19048493          	addi	s1,s1,400
    80007652:	ff5910e3          	bne	s2,s5,80007632 <change_priority+0x30>
	}
  	return 0;
    80007656:	4501                	li	a0,0
    80007658:	a015                	j	8000767c <change_priority+0x7a>
	    	p->priority = priority;
    8000765a:	19000793          	li	a5,400
    8000765e:	02f90933          	mul	s2,s2,a5
    80007662:	0000b797          	auipc	a5,0xb
    80007666:	c1e78793          	addi	a5,a5,-994 # 80012280 <proc>
    8000766a:	97ca                	add	a5,a5,s2
    8000766c:	1967a423          	sw	s6,392(a5)
	    	release(&p->lock);
    80007670:	8526                	mv	a0,s1
    80007672:	ffff9097          	auipc	ra,0xffff9
    80007676:	616080e7          	jalr	1558(ra) # 80000c88 <release>
	    	return 1;
    8000767a:	4505                	li	a0,1
}
    8000767c:	70e2                	ld	ra,56(sp)
    8000767e:	7442                	ld	s0,48(sp)
    80007680:	74a2                	ld	s1,40(sp)
    80007682:	7902                	ld	s2,32(sp)
    80007684:	69e2                	ld	s3,24(sp)
    80007686:	6a42                	ld	s4,16(sp)
    80007688:	6aa2                	ld	s5,8(sp)
    8000768a:	6b02                	ld	s6,0(sp)
    8000768c:	6121                	addi	sp,sp,64
    8000768e:	8082                	ret
		return 0;
    80007690:	4501                	li	a0,0
}
    80007692:	8082                	ret
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000800a:	0536                	slli	a0,a0,0xd
    8000800c:	02153423          	sd	ra,40(a0)
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	sd	s0,96(a0)
    8000802a:	f524                	sd	s1,104(a0)
    8000802c:	fd2c                	sd	a1,120(a0)
    8000802e:	e150                	sd	a2,128(a0)
    80008030:	e554                	sd	a3,136(a0)
    80008032:	e958                	sd	a4,144(a0)
    80008034:	ed5c                	sd	a5,152(a0)
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	8282                	jr	t0

000000008000809c <userret>:
    8000809c:	12000073          	sfence.vma
    800080a0:	18051073          	csrw	satp,a0
    800080a4:	12000073          	sfence.vma
    800080a8:	02000537          	lui	a0,0x2000
    800080ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800080ae:	0536                	slli	a0,a0,0xd
    800080b0:	02853083          	ld	ra,40(a0)
    800080b4:	03053103          	ld	sp,48(a0)
    800080b8:	03853183          	ld	gp,56(a0)
    800080bc:	04053203          	ld	tp,64(a0)
    800080c0:	04853283          	ld	t0,72(a0)
    800080c4:	05053303          	ld	t1,80(a0)
    800080c8:	05853383          	ld	t2,88(a0)
    800080cc:	7120                	ld	s0,96(a0)
    800080ce:	7524                	ld	s1,104(a0)
    800080d0:	7d2c                	ld	a1,120(a0)
    800080d2:	6150                	ld	a2,128(a0)
    800080d4:	6554                	ld	a3,136(a0)
    800080d6:	6958                	ld	a4,144(a0)
    800080d8:	6d5c                	ld	a5,152(a0)
    800080da:	0a053803          	ld	a6,160(a0)
    800080de:	0a853883          	ld	a7,168(a0)
    800080e2:	0b053903          	ld	s2,176(a0)
    800080e6:	0b853983          	ld	s3,184(a0)
    800080ea:	0c053a03          	ld	s4,192(a0)
    800080ee:	0c853a83          	ld	s5,200(a0)
    800080f2:	0d053b03          	ld	s6,208(a0)
    800080f6:	0d853b83          	ld	s7,216(a0)
    800080fa:	0e053c03          	ld	s8,224(a0)
    800080fe:	0e853c83          	ld	s9,232(a0)
    80008102:	0f053d03          	ld	s10,240(a0)
    80008106:	0f853d83          	ld	s11,248(a0)
    8000810a:	10053e03          	ld	t3,256(a0)
    8000810e:	10853e83          	ld	t4,264(a0)
    80008112:	11053f03          	ld	t5,272(a0)
    80008116:	11853f83          	ld	t6,280(a0)
    8000811a:	7928                	ld	a0,112(a0)
    8000811c:	10200073          	sret
	...
