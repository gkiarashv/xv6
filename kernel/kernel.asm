
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a0013103          	ld	sp,-1536(sp) # 80008a00 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

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

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	a1070713          	addi	a4,a4,-1520 # 80008a60 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	eae78793          	addi	a5,a5,-338 # 80005f10 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc92f>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	dcc78793          	addi	a5,a5,-564 # 80000e78 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	388080e7          	jalr	904(ra) # 800024b2 <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	784080e7          	jalr	1924(ra) # 800008be <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	a1650513          	addi	a0,a0,-1514 # 80010ba0 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a44080e7          	jalr	-1468(ra) # 80000bd6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	a0648493          	addi	s1,s1,-1530 # 80010ba0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	a9690913          	addi	s2,s2,-1386 # 80010c38 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if(killed(myproc())){
    800001c0:	00001097          	auipc	ra,0x1
    800001c4:	7ec080e7          	jalr	2028(ra) # 800019ac <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	134080e7          	jalr	308(ra) # 800022fc <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	e7e080e7          	jalr	-386(ra) # 80002054 <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	24a080e7          	jalr	586(ra) # 8000245c <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	97a50513          	addi	a0,a0,-1670 # 80010ba0 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	a5c080e7          	jalr	-1444(ra) # 80000c8a <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	96450513          	addi	a0,a0,-1692 # 80010ba0 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	a46080e7          	jalr	-1466(ra) # 80000c8a <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00011717          	auipc	a4,0x11
    80000276:	9cf72323          	sw	a5,-1594(a4) # 80010c38 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	560080e7          	jalr	1376(ra) # 800007ec <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54e080e7          	jalr	1358(ra) # 800007ec <uartputc_sync>
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	542080e7          	jalr	1346(ra) # 800007ec <uartputc_sync>
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	538080e7          	jalr	1336(ra) # 800007ec <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00011517          	auipc	a0,0x11
    800002d0:	8d450513          	addi	a0,a0,-1836 # 80010ba0 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	902080e7          	jalr	-1790(ra) # 80000bd6 <acquire>

  switch(c){
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	216080e7          	jalr	534(ra) # 80002508 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00011517          	auipc	a0,0x11
    800002fe:	8a650513          	addi	a0,a0,-1882 # 80010ba0 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	988080e7          	jalr	-1656(ra) # 80000c8a <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch(c){
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031e:	00011717          	auipc	a4,0x11
    80000322:	88270713          	addi	a4,a4,-1918 # 80010ba0 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00011797          	auipc	a5,0x11
    8000034c:	85878793          	addi	a5,a5,-1960 # 80010ba0 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00011797          	auipc	a5,0x11
    8000037a:	8c27a783          	lw	a5,-1854(a5) # 80010c38 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00011717          	auipc	a4,0x11
    8000038e:	81670713          	addi	a4,a4,-2026 # 80010ba0 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00011497          	auipc	s1,0x11
    8000039e:	80648493          	addi	s1,s1,-2042 # 80010ba0 <cons>
    while(cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while(cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	7ca70713          	addi	a4,a4,1994 # 80010ba0 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00011717          	auipc	a4,0x11
    800003f0:	84f72a23          	sw	a5,-1964(a4) # 80010c40 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00010797          	auipc	a5,0x10
    80000416:	78e78793          	addi	a5,a5,1934 # 80010ba0 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00011797          	auipc	a5,0x11
    8000043a:	80c7a323          	sw	a2,-2042(a5) # 80010c3c <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	7fa50513          	addi	a0,a0,2042 # 80010c38 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	c72080e7          	jalr	-910(ra) # 800020b8 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	74050513          	addi	a0,a0,1856 # 80010ba0 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	6de080e7          	jalr	1758(ra) # 80000b46 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32c080e7          	jalr	812(ra) # 8000079c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00021797          	auipc	a5,0x21
    8000047c:	8c078793          	addi	a5,a5,-1856 # 80020d38 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7670713          	addi	a4,a4,-906 # 80000100 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054763          	bltz	a0,80000538 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00008617          	auipc	a2,0x8
    800004be:	b8660613          	addi	a2,a2,-1146 # 80008040 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if(sign)
    800004e6:	00088c63          	beqz	a7,800004fe <printint+0x62>
    buf[i++] = '-';
    800004ea:	fe070793          	addi	a5,a4,-32
    800004ee:	00878733          	add	a4,a5,s0
    800004f2:	02d00793          	li	a5,45
    800004f6:	fef70823          	sb	a5,-16(a4)
    800004fa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fe:	02e05763          	blez	a4,8000052c <printint+0x90>
    80000502:	fd040793          	addi	a5,s0,-48
    80000506:	00e784b3          	add	s1,a5,a4
    8000050a:	fff78913          	addi	s2,a5,-1
    8000050e:	993a                	add	s2,s2,a4
    80000510:	377d                	addiw	a4,a4,-1
    80000512:	1702                	slli	a4,a4,0x20
    80000514:	9301                	srli	a4,a4,0x20
    80000516:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000051a:	fff4c503          	lbu	a0,-1(s1)
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	d5e080e7          	jalr	-674(ra) # 8000027c <consputc>
  while(--i >= 0)
    80000526:	14fd                	addi	s1,s1,-1
    80000528:	ff2499e3          	bne	s1,s2,8000051a <printint+0x7e>
}
    8000052c:	70a2                	ld	ra,40(sp)
    8000052e:	7402                	ld	s0,32(sp)
    80000530:	64e2                	ld	s1,24(sp)
    80000532:	6942                	ld	s2,16(sp)
    80000534:	6145                	addi	sp,sp,48
    80000536:	8082                	ret
    x = -xx;
    80000538:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053c:	4885                	li	a7,1
    x = -xx;
    8000053e:	bf95                	j	800004b2 <printint+0x16>

0000000080000540 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000540:	1101                	addi	sp,sp,-32
    80000542:	ec06                	sd	ra,24(sp)
    80000544:	e822                	sd	s0,16(sp)
    80000546:	e426                	sd	s1,8(sp)
    80000548:	1000                	addi	s0,sp,32
    8000054a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054c:	00010797          	auipc	a5,0x10
    80000550:	7007aa23          	sw	zero,1812(a5) # 80010c60 <pr+0x18>
  printf("panic: ");
    80000554:	00008517          	auipc	a0,0x8
    80000558:	ac450513          	addi	a0,a0,-1340 # 80008018 <etext+0x18>
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	02e080e7          	jalr	46(ra) # 8000058a <printf>
  printf(s);
    80000564:	8526                	mv	a0,s1
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	024080e7          	jalr	36(ra) # 8000058a <printf>
  printf("\n");
    8000056e:	00008517          	auipc	a0,0x8
    80000572:	b5a50513          	addi	a0,a0,-1190 # 800080c8 <digits+0x88>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	014080e7          	jalr	20(ra) # 8000058a <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057e:	4785                	li	a5,1
    80000580:	00008717          	auipc	a4,0x8
    80000584:	4af72023          	sw	a5,1184(a4) # 80008a20 <panicked>
  for(;;)
    80000588:	a001                	j	80000588 <panic+0x48>

000000008000058a <printf>:
{
    8000058a:	7131                	addi	sp,sp,-192
    8000058c:	fc86                	sd	ra,120(sp)
    8000058e:	f8a2                	sd	s0,112(sp)
    80000590:	f4a6                	sd	s1,104(sp)
    80000592:	f0ca                	sd	s2,96(sp)
    80000594:	ecce                	sd	s3,88(sp)
    80000596:	e8d2                	sd	s4,80(sp)
    80000598:	e4d6                	sd	s5,72(sp)
    8000059a:	e0da                	sd	s6,64(sp)
    8000059c:	fc5e                	sd	s7,56(sp)
    8000059e:	f862                	sd	s8,48(sp)
    800005a0:	f466                	sd	s9,40(sp)
    800005a2:	f06a                	sd	s10,32(sp)
    800005a4:	ec6e                	sd	s11,24(sp)
    800005a6:	0100                	addi	s0,sp,128
    800005a8:	8a2a                	mv	s4,a0
    800005aa:	e40c                	sd	a1,8(s0)
    800005ac:	e810                	sd	a2,16(s0)
    800005ae:	ec14                	sd	a3,24(s0)
    800005b0:	f018                	sd	a4,32(s0)
    800005b2:	f41c                	sd	a5,40(s0)
    800005b4:	03043823          	sd	a6,48(s0)
    800005b8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005bc:	00010d97          	auipc	s11,0x10
    800005c0:	6a4dad83          	lw	s11,1700(s11) # 80010c60 <pr+0x18>
  if(locking)
    800005c4:	020d9b63          	bnez	s11,800005fa <printf+0x70>
  if (fmt == 0)
    800005c8:	040a0263          	beqz	s4,8000060c <printf+0x82>
  va_start(ap, fmt);
    800005cc:	00840793          	addi	a5,s0,8
    800005d0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d4:	000a4503          	lbu	a0,0(s4)
    800005d8:	14050f63          	beqz	a0,80000736 <printf+0x1ac>
    800005dc:	4981                	li	s3,0
    if(c != '%'){
    800005de:	02500a93          	li	s5,37
    switch(c){
    800005e2:	07000b93          	li	s7,112
  consputc('x');
    800005e6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e8:	00008b17          	auipc	s6,0x8
    800005ec:	a58b0b13          	addi	s6,s6,-1448 # 80008040 <digits>
    switch(c){
    800005f0:	07300c93          	li	s9,115
    800005f4:	06400c13          	li	s8,100
    800005f8:	a82d                	j	80000632 <printf+0xa8>
    acquire(&pr.lock);
    800005fa:	00010517          	auipc	a0,0x10
    800005fe:	64e50513          	addi	a0,a0,1614 # 80010c48 <pr>
    80000602:	00000097          	auipc	ra,0x0
    80000606:	5d4080e7          	jalr	1492(ra) # 80000bd6 <acquire>
    8000060a:	bf7d                	j	800005c8 <printf+0x3e>
    panic("null fmt");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a1c50513          	addi	a0,a0,-1508 # 80008028 <etext+0x28>
    80000614:	00000097          	auipc	ra,0x0
    80000618:	f2c080e7          	jalr	-212(ra) # 80000540 <panic>
      consputc(c);
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	c60080e7          	jalr	-928(ra) # 8000027c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000624:	2985                	addiw	s3,s3,1
    80000626:	013a07b3          	add	a5,s4,s3
    8000062a:	0007c503          	lbu	a0,0(a5)
    8000062e:	10050463          	beqz	a0,80000736 <printf+0x1ac>
    if(c != '%'){
    80000632:	ff5515e3          	bne	a0,s5,8000061c <printf+0x92>
    c = fmt[++i] & 0xff;
    80000636:	2985                	addiw	s3,s3,1
    80000638:	013a07b3          	add	a5,s4,s3
    8000063c:	0007c783          	lbu	a5,0(a5)
    80000640:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000644:	cbed                	beqz	a5,80000736 <printf+0x1ac>
    switch(c){
    80000646:	05778a63          	beq	a5,s7,8000069a <printf+0x110>
    8000064a:	02fbf663          	bgeu	s7,a5,80000676 <printf+0xec>
    8000064e:	09978863          	beq	a5,s9,800006de <printf+0x154>
    80000652:	07800713          	li	a4,120
    80000656:	0ce79563          	bne	a5,a4,80000720 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000065a:	f8843783          	ld	a5,-120(s0)
    8000065e:	00878713          	addi	a4,a5,8
    80000662:	f8e43423          	sd	a4,-120(s0)
    80000666:	4605                	li	a2,1
    80000668:	85ea                	mv	a1,s10
    8000066a:	4388                	lw	a0,0(a5)
    8000066c:	00000097          	auipc	ra,0x0
    80000670:	e30080e7          	jalr	-464(ra) # 8000049c <printint>
      break;
    80000674:	bf45                	j	80000624 <printf+0x9a>
    switch(c){
    80000676:	09578f63          	beq	a5,s5,80000714 <printf+0x18a>
    8000067a:	0b879363          	bne	a5,s8,80000720 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067e:	f8843783          	ld	a5,-120(s0)
    80000682:	00878713          	addi	a4,a5,8
    80000686:	f8e43423          	sd	a4,-120(s0)
    8000068a:	4605                	li	a2,1
    8000068c:	45a9                	li	a1,10
    8000068e:	4388                	lw	a0,0(a5)
    80000690:	00000097          	auipc	ra,0x0
    80000694:	e0c080e7          	jalr	-500(ra) # 8000049c <printint>
      break;
    80000698:	b771                	j	80000624 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000069a:	f8843783          	ld	a5,-120(s0)
    8000069e:	00878713          	addi	a4,a5,8
    800006a2:	f8e43423          	sd	a4,-120(s0)
    800006a6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006aa:	03000513          	li	a0,48
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	bce080e7          	jalr	-1074(ra) # 8000027c <consputc>
  consputc('x');
    800006b6:	07800513          	li	a0,120
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	bc2080e7          	jalr	-1086(ra) # 8000027c <consputc>
    800006c2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c4:	03c95793          	srli	a5,s2,0x3c
    800006c8:	97da                	add	a5,a5,s6
    800006ca:	0007c503          	lbu	a0,0(a5)
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	bae080e7          	jalr	-1106(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d6:	0912                	slli	s2,s2,0x4
    800006d8:	34fd                	addiw	s1,s1,-1
    800006da:	f4ed                	bnez	s1,800006c4 <printf+0x13a>
    800006dc:	b7a1                	j	80000624 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006de:	f8843783          	ld	a5,-120(s0)
    800006e2:	00878713          	addi	a4,a5,8
    800006e6:	f8e43423          	sd	a4,-120(s0)
    800006ea:	6384                	ld	s1,0(a5)
    800006ec:	cc89                	beqz	s1,80000706 <printf+0x17c>
      for(; *s; s++)
    800006ee:	0004c503          	lbu	a0,0(s1)
    800006f2:	d90d                	beqz	a0,80000624 <printf+0x9a>
        consputc(*s);
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	b88080e7          	jalr	-1144(ra) # 8000027c <consputc>
      for(; *s; s++)
    800006fc:	0485                	addi	s1,s1,1
    800006fe:	0004c503          	lbu	a0,0(s1)
    80000702:	f96d                	bnez	a0,800006f4 <printf+0x16a>
    80000704:	b705                	j	80000624 <printf+0x9a>
        s = "(null)";
    80000706:	00008497          	auipc	s1,0x8
    8000070a:	91a48493          	addi	s1,s1,-1766 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070e:	02800513          	li	a0,40
    80000712:	b7cd                	j	800006f4 <printf+0x16a>
      consputc('%');
    80000714:	8556                	mv	a0,s5
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b66080e7          	jalr	-1178(ra) # 8000027c <consputc>
      break;
    8000071e:	b719                	j	80000624 <printf+0x9a>
      consputc('%');
    80000720:	8556                	mv	a0,s5
    80000722:	00000097          	auipc	ra,0x0
    80000726:	b5a080e7          	jalr	-1190(ra) # 8000027c <consputc>
      consputc(c);
    8000072a:	8526                	mv	a0,s1
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	b50080e7          	jalr	-1200(ra) # 8000027c <consputc>
      break;
    80000734:	bdc5                	j	80000624 <printf+0x9a>
  if(locking)
    80000736:	020d9163          	bnez	s11,80000758 <printf+0x1ce>
}
    8000073a:	70e6                	ld	ra,120(sp)
    8000073c:	7446                	ld	s0,112(sp)
    8000073e:	74a6                	ld	s1,104(sp)
    80000740:	7906                	ld	s2,96(sp)
    80000742:	69e6                	ld	s3,88(sp)
    80000744:	6a46                	ld	s4,80(sp)
    80000746:	6aa6                	ld	s5,72(sp)
    80000748:	6b06                	ld	s6,64(sp)
    8000074a:	7be2                	ld	s7,56(sp)
    8000074c:	7c42                	ld	s8,48(sp)
    8000074e:	7ca2                	ld	s9,40(sp)
    80000750:	7d02                	ld	s10,32(sp)
    80000752:	6de2                	ld	s11,24(sp)
    80000754:	6129                	addi	sp,sp,192
    80000756:	8082                	ret
    release(&pr.lock);
    80000758:	00010517          	auipc	a0,0x10
    8000075c:	4f050513          	addi	a0,a0,1264 # 80010c48 <pr>
    80000760:	00000097          	auipc	ra,0x0
    80000764:	52a080e7          	jalr	1322(ra) # 80000c8a <release>
}
    80000768:	bfc9                	j	8000073a <printf+0x1b0>

000000008000076a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000076a:	1101                	addi	sp,sp,-32
    8000076c:	ec06                	sd	ra,24(sp)
    8000076e:	e822                	sd	s0,16(sp)
    80000770:	e426                	sd	s1,8(sp)
    80000772:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000774:	00010497          	auipc	s1,0x10
    80000778:	4d448493          	addi	s1,s1,1236 # 80010c48 <pr>
    8000077c:	00008597          	auipc	a1,0x8
    80000780:	8bc58593          	addi	a1,a1,-1860 # 80008038 <etext+0x38>
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	3c0080e7          	jalr	960(ra) # 80000b46 <initlock>
  pr.locking = 1;
    8000078e:	4785                	li	a5,1
    80000790:	cc9c                	sw	a5,24(s1)
}
    80000792:	60e2                	ld	ra,24(sp)
    80000794:	6442                	ld	s0,16(sp)
    80000796:	64a2                	ld	s1,8(sp)
    80000798:	6105                	addi	sp,sp,32
    8000079a:	8082                	ret

000000008000079c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079c:	1141                	addi	sp,sp,-16
    8000079e:	e406                	sd	ra,8(sp)
    800007a0:	e022                	sd	s0,0(sp)
    800007a2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a4:	100007b7          	lui	a5,0x10000
    800007a8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ac:	f8000713          	li	a4,-128
    800007b0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b4:	470d                	li	a4,3
    800007b6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007ba:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007be:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c2:	469d                	li	a3,7
    800007c4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007cc:	00008597          	auipc	a1,0x8
    800007d0:	88c58593          	addi	a1,a1,-1908 # 80008058 <digits+0x18>
    800007d4:	00010517          	auipc	a0,0x10
    800007d8:	49450513          	addi	a0,a0,1172 # 80010c68 <uart_tx_lock>
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	36a080e7          	jalr	874(ra) # 80000b46 <initlock>
}
    800007e4:	60a2                	ld	ra,8(sp)
    800007e6:	6402                	ld	s0,0(sp)
    800007e8:	0141                	addi	sp,sp,16
    800007ea:	8082                	ret

00000000800007ec <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ec:	1101                	addi	sp,sp,-32
    800007ee:	ec06                	sd	ra,24(sp)
    800007f0:	e822                	sd	s0,16(sp)
    800007f2:	e426                	sd	s1,8(sp)
    800007f4:	1000                	addi	s0,sp,32
    800007f6:	84aa                	mv	s1,a0
  push_off();
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	392080e7          	jalr	914(ra) # 80000b8a <push_off>

  if(panicked){
    80000800:	00008797          	auipc	a5,0x8
    80000804:	2207a783          	lw	a5,544(a5) # 80008a20 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000808:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080c:	c391                	beqz	a5,80000810 <uartputc_sync+0x24>
    for(;;)
    8000080e:	a001                	j	8000080e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000810:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000814:	0207f793          	andi	a5,a5,32
    80000818:	dfe5                	beqz	a5,80000810 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000081a:	0ff4f513          	zext.b	a0,s1
    8000081e:	100007b7          	lui	a5,0x10000
    80000822:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	404080e7          	jalr	1028(ra) # 80000c2a <pop_off>
}
    8000082e:	60e2                	ld	ra,24(sp)
    80000830:	6442                	ld	s0,16(sp)
    80000832:	64a2                	ld	s1,8(sp)
    80000834:	6105                	addi	sp,sp,32
    80000836:	8082                	ret

0000000080000838 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000838:	00008797          	auipc	a5,0x8
    8000083c:	1f07b783          	ld	a5,496(a5) # 80008a28 <uart_tx_r>
    80000840:	00008717          	auipc	a4,0x8
    80000844:	1f073703          	ld	a4,496(a4) # 80008a30 <uart_tx_w>
    80000848:	06f70a63          	beq	a4,a5,800008bc <uartstart+0x84>
{
    8000084c:	7139                	addi	sp,sp,-64
    8000084e:	fc06                	sd	ra,56(sp)
    80000850:	f822                	sd	s0,48(sp)
    80000852:	f426                	sd	s1,40(sp)
    80000854:	f04a                	sd	s2,32(sp)
    80000856:	ec4e                	sd	s3,24(sp)
    80000858:	e852                	sd	s4,16(sp)
    8000085a:	e456                	sd	s5,8(sp)
    8000085c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000862:	00010a17          	auipc	s4,0x10
    80000866:	406a0a13          	addi	s4,s4,1030 # 80010c68 <uart_tx_lock>
    uart_tx_r += 1;
    8000086a:	00008497          	auipc	s1,0x8
    8000086e:	1be48493          	addi	s1,s1,446 # 80008a28 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000872:	00008997          	auipc	s3,0x8
    80000876:	1be98993          	addi	s3,s3,446 # 80008a30 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000087a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087e:	02077713          	andi	a4,a4,32
    80000882:	c705                	beqz	a4,800008aa <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000884:	01f7f713          	andi	a4,a5,31
    80000888:	9752                	add	a4,a4,s4
    8000088a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088e:	0785                	addi	a5,a5,1
    80000890:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000892:	8526                	mv	a0,s1
    80000894:	00002097          	auipc	ra,0x2
    80000898:	824080e7          	jalr	-2012(ra) # 800020b8 <wakeup>
    
    WriteReg(THR, c);
    8000089c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008a0:	609c                	ld	a5,0(s1)
    800008a2:	0009b703          	ld	a4,0(s3)
    800008a6:	fcf71ae3          	bne	a4,a5,8000087a <uartstart+0x42>
  }
}
    800008aa:	70e2                	ld	ra,56(sp)
    800008ac:	7442                	ld	s0,48(sp)
    800008ae:	74a2                	ld	s1,40(sp)
    800008b0:	7902                	ld	s2,32(sp)
    800008b2:	69e2                	ld	s3,24(sp)
    800008b4:	6a42                	ld	s4,16(sp)
    800008b6:	6aa2                	ld	s5,8(sp)
    800008b8:	6121                	addi	sp,sp,64
    800008ba:	8082                	ret
    800008bc:	8082                	ret

00000000800008be <uartputc>:
{
    800008be:	7179                	addi	sp,sp,-48
    800008c0:	f406                	sd	ra,40(sp)
    800008c2:	f022                	sd	s0,32(sp)
    800008c4:	ec26                	sd	s1,24(sp)
    800008c6:	e84a                	sd	s2,16(sp)
    800008c8:	e44e                	sd	s3,8(sp)
    800008ca:	e052                	sd	s4,0(sp)
    800008cc:	1800                	addi	s0,sp,48
    800008ce:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008d0:	00010517          	auipc	a0,0x10
    800008d4:	39850513          	addi	a0,a0,920 # 80010c68 <uart_tx_lock>
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	2fe080e7          	jalr	766(ra) # 80000bd6 <acquire>
  if(panicked){
    800008e0:	00008797          	auipc	a5,0x8
    800008e4:	1407a783          	lw	a5,320(a5) # 80008a20 <panicked>
    800008e8:	e7c9                	bnez	a5,80000972 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008ea:	00008717          	auipc	a4,0x8
    800008ee:	14673703          	ld	a4,326(a4) # 80008a30 <uart_tx_w>
    800008f2:	00008797          	auipc	a5,0x8
    800008f6:	1367b783          	ld	a5,310(a5) # 80008a28 <uart_tx_r>
    800008fa:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fe:	00010997          	auipc	s3,0x10
    80000902:	36a98993          	addi	s3,s3,874 # 80010c68 <uart_tx_lock>
    80000906:	00008497          	auipc	s1,0x8
    8000090a:	12248493          	addi	s1,s1,290 # 80008a28 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090e:	00008917          	auipc	s2,0x8
    80000912:	12290913          	addi	s2,s2,290 # 80008a30 <uart_tx_w>
    80000916:	00e79f63          	bne	a5,a4,80000934 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000091a:	85ce                	mv	a1,s3
    8000091c:	8526                	mv	a0,s1
    8000091e:	00001097          	auipc	ra,0x1
    80000922:	736080e7          	jalr	1846(ra) # 80002054 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000926:	00093703          	ld	a4,0(s2)
    8000092a:	609c                	ld	a5,0(s1)
    8000092c:	02078793          	addi	a5,a5,32
    80000930:	fee785e3          	beq	a5,a4,8000091a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000934:	00010497          	auipc	s1,0x10
    80000938:	33448493          	addi	s1,s1,820 # 80010c68 <uart_tx_lock>
    8000093c:	01f77793          	andi	a5,a4,31
    80000940:	97a6                	add	a5,a5,s1
    80000942:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000946:	0705                	addi	a4,a4,1
    80000948:	00008797          	auipc	a5,0x8
    8000094c:	0ee7b423          	sd	a4,232(a5) # 80008a30 <uart_tx_w>
  uartstart();
    80000950:	00000097          	auipc	ra,0x0
    80000954:	ee8080e7          	jalr	-280(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    80000958:	8526                	mv	a0,s1
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	330080e7          	jalr	816(ra) # 80000c8a <release>
}
    80000962:	70a2                	ld	ra,40(sp)
    80000964:	7402                	ld	s0,32(sp)
    80000966:	64e2                	ld	s1,24(sp)
    80000968:	6942                	ld	s2,16(sp)
    8000096a:	69a2                	ld	s3,8(sp)
    8000096c:	6a02                	ld	s4,0(sp)
    8000096e:	6145                	addi	sp,sp,48
    80000970:	8082                	ret
    for(;;)
    80000972:	a001                	j	80000972 <uartputc+0xb4>

0000000080000974 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000974:	1141                	addi	sp,sp,-16
    80000976:	e422                	sd	s0,8(sp)
    80000978:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000097a:	100007b7          	lui	a5,0x10000
    8000097e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000982:	8b85                	andi	a5,a5,1
    80000984:	cb81                	beqz	a5,80000994 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000986:	100007b7          	lui	a5,0x10000
    8000098a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000098e:	6422                	ld	s0,8(sp)
    80000990:	0141                	addi	sp,sp,16
    80000992:	8082                	ret
    return -1;
    80000994:	557d                	li	a0,-1
    80000996:	bfe5                	j	8000098e <uartgetc+0x1a>

0000000080000998 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000998:	1101                	addi	sp,sp,-32
    8000099a:	ec06                	sd	ra,24(sp)
    8000099c:	e822                	sd	s0,16(sp)
    8000099e:	e426                	sd	s1,8(sp)
    800009a0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a2:	54fd                	li	s1,-1
    800009a4:	a029                	j	800009ae <uartintr+0x16>
      break;
    consoleintr(c);
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	918080e7          	jalr	-1768(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	fc6080e7          	jalr	-58(ra) # 80000974 <uartgetc>
    if(c == -1)
    800009b6:	fe9518e3          	bne	a0,s1,800009a6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009ba:	00010497          	auipc	s1,0x10
    800009be:	2ae48493          	addi	s1,s1,686 # 80010c68 <uart_tx_lock>
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	212080e7          	jalr	530(ra) # 80000bd6 <acquire>
  uartstart();
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	e6c080e7          	jalr	-404(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    800009d4:	8526                	mv	a0,s1
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	2b4080e7          	jalr	692(ra) # 80000c8a <release>
}
    800009de:	60e2                	ld	ra,24(sp)
    800009e0:	6442                	ld	s0,16(sp)
    800009e2:	64a2                	ld	s1,8(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret

00000000800009e8 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e8:	1101                	addi	sp,sp,-32
    800009ea:	ec06                	sd	ra,24(sp)
    800009ec:	e822                	sd	s0,16(sp)
    800009ee:	e426                	sd	s1,8(sp)
    800009f0:	e04a                	sd	s2,0(sp)
    800009f2:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f4:	03451793          	slli	a5,a0,0x34
    800009f8:	ebb9                	bnez	a5,80000a4e <kfree+0x66>
    800009fa:	84aa                	mv	s1,a0
    800009fc:	00021797          	auipc	a5,0x21
    80000a00:	4d478793          	addi	a5,a5,1236 # 80021ed0 <end>
    80000a04:	04f56563          	bltu	a0,a5,80000a4e <kfree+0x66>
    80000a08:	47c5                	li	a5,17
    80000a0a:	07ee                	slli	a5,a5,0x1b
    80000a0c:	04f57163          	bgeu	a0,a5,80000a4e <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a10:	6605                	lui	a2,0x1
    80000a12:	4585                	li	a1,1
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	2be080e7          	jalr	702(ra) # 80000cd2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a1c:	00010917          	auipc	s2,0x10
    80000a20:	28490913          	addi	s2,s2,644 # 80010ca0 <kmem>
    80000a24:	854a                	mv	a0,s2
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	1b0080e7          	jalr	432(ra) # 80000bd6 <acquire>
  r->next = kmem.freelist;
    80000a2e:	01893783          	ld	a5,24(s2)
    80000a32:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a34:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a38:	854a                	mv	a0,s2
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	250080e7          	jalr	592(ra) # 80000c8a <release>
}
    80000a42:	60e2                	ld	ra,24(sp)
    80000a44:	6442                	ld	s0,16(sp)
    80000a46:	64a2                	ld	s1,8(sp)
    80000a48:	6902                	ld	s2,0(sp)
    80000a4a:	6105                	addi	sp,sp,32
    80000a4c:	8082                	ret
    panic("kfree");
    80000a4e:	00007517          	auipc	a0,0x7
    80000a52:	61250513          	addi	a0,a0,1554 # 80008060 <digits+0x20>
    80000a56:	00000097          	auipc	ra,0x0
    80000a5a:	aea080e7          	jalr	-1302(ra) # 80000540 <panic>

0000000080000a5e <freerange>:
{
    80000a5e:	7179                	addi	sp,sp,-48
    80000a60:	f406                	sd	ra,40(sp)
    80000a62:	f022                	sd	s0,32(sp)
    80000a64:	ec26                	sd	s1,24(sp)
    80000a66:	e84a                	sd	s2,16(sp)
    80000a68:	e44e                	sd	s3,8(sp)
    80000a6a:	e052                	sd	s4,0(sp)
    80000a6c:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a6e:	6785                	lui	a5,0x1
    80000a70:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a74:	00e504b3          	add	s1,a0,a4
    80000a78:	777d                	lui	a4,0xfffff
    80000a7a:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a7c:	94be                	add	s1,s1,a5
    80000a7e:	0095ee63          	bltu	a1,s1,80000a9a <freerange+0x3c>
    80000a82:	892e                	mv	s2,a1
    kfree(p);
    80000a84:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a86:	6985                	lui	s3,0x1
    kfree(p);
    80000a88:	01448533          	add	a0,s1,s4
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	f5c080e7          	jalr	-164(ra) # 800009e8 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a94:	94ce                	add	s1,s1,s3
    80000a96:	fe9979e3          	bgeu	s2,s1,80000a88 <freerange+0x2a>
}
    80000a9a:	70a2                	ld	ra,40(sp)
    80000a9c:	7402                	ld	s0,32(sp)
    80000a9e:	64e2                	ld	s1,24(sp)
    80000aa0:	6942                	ld	s2,16(sp)
    80000aa2:	69a2                	ld	s3,8(sp)
    80000aa4:	6a02                	ld	s4,0(sp)
    80000aa6:	6145                	addi	sp,sp,48
    80000aa8:	8082                	ret

0000000080000aaa <kinit>:
{
    80000aaa:	1141                	addi	sp,sp,-16
    80000aac:	e406                	sd	ra,8(sp)
    80000aae:	e022                	sd	s0,0(sp)
    80000ab0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ab2:	00007597          	auipc	a1,0x7
    80000ab6:	5b658593          	addi	a1,a1,1462 # 80008068 <digits+0x28>
    80000aba:	00010517          	auipc	a0,0x10
    80000abe:	1e650513          	addi	a0,a0,486 # 80010ca0 <kmem>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	084080e7          	jalr	132(ra) # 80000b46 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000aca:	45c5                	li	a1,17
    80000acc:	05ee                	slli	a1,a1,0x1b
    80000ace:	00021517          	auipc	a0,0x21
    80000ad2:	40250513          	addi	a0,a0,1026 # 80021ed0 <end>
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	f88080e7          	jalr	-120(ra) # 80000a5e <freerange>
}
    80000ade:	60a2                	ld	ra,8(sp)
    80000ae0:	6402                	ld	s0,0(sp)
    80000ae2:	0141                	addi	sp,sp,16
    80000ae4:	8082                	ret

0000000080000ae6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae6:	1101                	addi	sp,sp,-32
    80000ae8:	ec06                	sd	ra,24(sp)
    80000aea:	e822                	sd	s0,16(sp)
    80000aec:	e426                	sd	s1,8(sp)
    80000aee:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000af0:	00010497          	auipc	s1,0x10
    80000af4:	1b048493          	addi	s1,s1,432 # 80010ca0 <kmem>
    80000af8:	8526                	mv	a0,s1
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	0dc080e7          	jalr	220(ra) # 80000bd6 <acquire>
  r = kmem.freelist;
    80000b02:	6c84                	ld	s1,24(s1)
  if(r)
    80000b04:	c885                	beqz	s1,80000b34 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b06:	609c                	ld	a5,0(s1)
    80000b08:	00010517          	auipc	a0,0x10
    80000b0c:	19850513          	addi	a0,a0,408 # 80010ca0 <kmem>
    80000b10:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	178080e7          	jalr	376(ra) # 80000c8a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b1a:	6605                	lui	a2,0x1
    80000b1c:	4595                	li	a1,5
    80000b1e:	8526                	mv	a0,s1
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	1b2080e7          	jalr	434(ra) # 80000cd2 <memset>
  return (void*)r;
}
    80000b28:	8526                	mv	a0,s1
    80000b2a:	60e2                	ld	ra,24(sp)
    80000b2c:	6442                	ld	s0,16(sp)
    80000b2e:	64a2                	ld	s1,8(sp)
    80000b30:	6105                	addi	sp,sp,32
    80000b32:	8082                	ret
  release(&kmem.lock);
    80000b34:	00010517          	auipc	a0,0x10
    80000b38:	16c50513          	addi	a0,a0,364 # 80010ca0 <kmem>
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	14e080e7          	jalr	334(ra) # 80000c8a <release>
  if(r)
    80000b44:	b7d5                	j	80000b28 <kalloc+0x42>

0000000080000b46 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b46:	1141                	addi	sp,sp,-16
    80000b48:	e422                	sd	s0,8(sp)
    80000b4a:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b4c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b4e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b52:	00053823          	sd	zero,16(a0)
}
    80000b56:	6422                	ld	s0,8(sp)
    80000b58:	0141                	addi	sp,sp,16
    80000b5a:	8082                	ret

0000000080000b5c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b5c:	411c                	lw	a5,0(a0)
    80000b5e:	e399                	bnez	a5,80000b64 <holding+0x8>
    80000b60:	4501                	li	a0,0
  return r;
}
    80000b62:	8082                	ret
{
    80000b64:	1101                	addi	sp,sp,-32
    80000b66:	ec06                	sd	ra,24(sp)
    80000b68:	e822                	sd	s0,16(sp)
    80000b6a:	e426                	sd	s1,8(sp)
    80000b6c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b6e:	6904                	ld	s1,16(a0)
    80000b70:	00001097          	auipc	ra,0x1
    80000b74:	e20080e7          	jalr	-480(ra) # 80001990 <mycpu>
    80000b78:	40a48533          	sub	a0,s1,a0
    80000b7c:	00153513          	seqz	a0,a0
}
    80000b80:	60e2                	ld	ra,24(sp)
    80000b82:	6442                	ld	s0,16(sp)
    80000b84:	64a2                	ld	s1,8(sp)
    80000b86:	6105                	addi	sp,sp,32
    80000b88:	8082                	ret

0000000080000b8a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b8a:	1101                	addi	sp,sp,-32
    80000b8c:	ec06                	sd	ra,24(sp)
    80000b8e:	e822                	sd	s0,16(sp)
    80000b90:	e426                	sd	s1,8(sp)
    80000b92:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b94:	100024f3          	csrr	s1,sstatus
    80000b98:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b9c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b9e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000ba2:	00001097          	auipc	ra,0x1
    80000ba6:	dee080e7          	jalr	-530(ra) # 80001990 <mycpu>
    80000baa:	5d3c                	lw	a5,120(a0)
    80000bac:	cf89                	beqz	a5,80000bc6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bae:	00001097          	auipc	ra,0x1
    80000bb2:	de2080e7          	jalr	-542(ra) # 80001990 <mycpu>
    80000bb6:	5d3c                	lw	a5,120(a0)
    80000bb8:	2785                	addiw	a5,a5,1
    80000bba:	dd3c                	sw	a5,120(a0)
}
    80000bbc:	60e2                	ld	ra,24(sp)
    80000bbe:	6442                	ld	s0,16(sp)
    80000bc0:	64a2                	ld	s1,8(sp)
    80000bc2:	6105                	addi	sp,sp,32
    80000bc4:	8082                	ret
    mycpu()->intena = old;
    80000bc6:	00001097          	auipc	ra,0x1
    80000bca:	dca080e7          	jalr	-566(ra) # 80001990 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bce:	8085                	srli	s1,s1,0x1
    80000bd0:	8885                	andi	s1,s1,1
    80000bd2:	dd64                	sw	s1,124(a0)
    80000bd4:	bfe9                	j	80000bae <push_off+0x24>

0000000080000bd6 <acquire>:
{
    80000bd6:	1101                	addi	sp,sp,-32
    80000bd8:	ec06                	sd	ra,24(sp)
    80000bda:	e822                	sd	s0,16(sp)
    80000bdc:	e426                	sd	s1,8(sp)
    80000bde:	1000                	addi	s0,sp,32
    80000be0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	fa8080e7          	jalr	-88(ra) # 80000b8a <push_off>
  if(holding(lk))
    80000bea:	8526                	mv	a0,s1
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	f70080e7          	jalr	-144(ra) # 80000b5c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf4:	4705                	li	a4,1
  if(holding(lk))
    80000bf6:	e115                	bnez	a0,80000c1a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf8:	87ba                	mv	a5,a4
    80000bfa:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bfe:	2781                	sext.w	a5,a5
    80000c00:	ffe5                	bnez	a5,80000bf8 <acquire+0x22>
  __sync_synchronize();
    80000c02:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c06:	00001097          	auipc	ra,0x1
    80000c0a:	d8a080e7          	jalr	-630(ra) # 80001990 <mycpu>
    80000c0e:	e888                	sd	a0,16(s1)
}
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    panic("acquire");
    80000c1a:	00007517          	auipc	a0,0x7
    80000c1e:	45650513          	addi	a0,a0,1110 # 80008070 <digits+0x30>
    80000c22:	00000097          	auipc	ra,0x0
    80000c26:	91e080e7          	jalr	-1762(ra) # 80000540 <panic>

0000000080000c2a <pop_off>:

void
pop_off(void)
{
    80000c2a:	1141                	addi	sp,sp,-16
    80000c2c:	e406                	sd	ra,8(sp)
    80000c2e:	e022                	sd	s0,0(sp)
    80000c30:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c32:	00001097          	auipc	ra,0x1
    80000c36:	d5e080e7          	jalr	-674(ra) # 80001990 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c3a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c3e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c40:	e78d                	bnez	a5,80000c6a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c42:	5d3c                	lw	a5,120(a0)
    80000c44:	02f05b63          	blez	a5,80000c7a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c48:	37fd                	addiw	a5,a5,-1
    80000c4a:	0007871b          	sext.w	a4,a5
    80000c4e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c50:	eb09                	bnez	a4,80000c62 <pop_off+0x38>
    80000c52:	5d7c                	lw	a5,124(a0)
    80000c54:	c799                	beqz	a5,80000c62 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c56:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c5a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c5e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c62:	60a2                	ld	ra,8(sp)
    80000c64:	6402                	ld	s0,0(sp)
    80000c66:	0141                	addi	sp,sp,16
    80000c68:	8082                	ret
    panic("pop_off - interruptible");
    80000c6a:	00007517          	auipc	a0,0x7
    80000c6e:	40e50513          	addi	a0,a0,1038 # 80008078 <digits+0x38>
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	8ce080e7          	jalr	-1842(ra) # 80000540 <panic>
    panic("pop_off");
    80000c7a:	00007517          	auipc	a0,0x7
    80000c7e:	41650513          	addi	a0,a0,1046 # 80008090 <digits+0x50>
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	8be080e7          	jalr	-1858(ra) # 80000540 <panic>

0000000080000c8a <release>:
{
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	e426                	sd	s1,8(sp)
    80000c92:	1000                	addi	s0,sp,32
    80000c94:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	ec6080e7          	jalr	-314(ra) # 80000b5c <holding>
    80000c9e:	c115                	beqz	a0,80000cc2 <release+0x38>
  lk->cpu = 0;
    80000ca0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca8:	0f50000f          	fence	iorw,ow
    80000cac:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cb0:	00000097          	auipc	ra,0x0
    80000cb4:	f7a080e7          	jalr	-134(ra) # 80000c2a <pop_off>
}
    80000cb8:	60e2                	ld	ra,24(sp)
    80000cba:	6442                	ld	s0,16(sp)
    80000cbc:	64a2                	ld	s1,8(sp)
    80000cbe:	6105                	addi	sp,sp,32
    80000cc0:	8082                	ret
    panic("release");
    80000cc2:	00007517          	auipc	a0,0x7
    80000cc6:	3d650513          	addi	a0,a0,982 # 80008098 <digits+0x58>
    80000cca:	00000097          	auipc	ra,0x0
    80000cce:	876080e7          	jalr	-1930(ra) # 80000540 <panic>

0000000080000cd2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cd2:	1141                	addi	sp,sp,-16
    80000cd4:	e422                	sd	s0,8(sp)
    80000cd6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd8:	ca19                	beqz	a2,80000cee <memset+0x1c>
    80000cda:	87aa                	mv	a5,a0
    80000cdc:	1602                	slli	a2,a2,0x20
    80000cde:	9201                	srli	a2,a2,0x20
    80000ce0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce8:	0785                	addi	a5,a5,1
    80000cea:	fee79de3          	bne	a5,a4,80000ce4 <memset+0x12>
  }
  return dst;
}
    80000cee:	6422                	ld	s0,8(sp)
    80000cf0:	0141                	addi	sp,sp,16
    80000cf2:	8082                	ret

0000000080000cf4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf4:	1141                	addi	sp,sp,-16
    80000cf6:	e422                	sd	s0,8(sp)
    80000cf8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cfa:	ca05                	beqz	a2,80000d2a <memcmp+0x36>
    80000cfc:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d00:	1682                	slli	a3,a3,0x20
    80000d02:	9281                	srli	a3,a3,0x20
    80000d04:	0685                	addi	a3,a3,1
    80000d06:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d08:	00054783          	lbu	a5,0(a0)
    80000d0c:	0005c703          	lbu	a4,0(a1)
    80000d10:	00e79863          	bne	a5,a4,80000d20 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d14:	0505                	addi	a0,a0,1
    80000d16:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d18:	fed518e3          	bne	a0,a3,80000d08 <memcmp+0x14>
  }

  return 0;
    80000d1c:	4501                	li	a0,0
    80000d1e:	a019                	j	80000d24 <memcmp+0x30>
      return *s1 - *s2;
    80000d20:	40e7853b          	subw	a0,a5,a4
}
    80000d24:	6422                	ld	s0,8(sp)
    80000d26:	0141                	addi	sp,sp,16
    80000d28:	8082                	ret
  return 0;
    80000d2a:	4501                	li	a0,0
    80000d2c:	bfe5                	j	80000d24 <memcmp+0x30>

0000000080000d2e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d2e:	1141                	addi	sp,sp,-16
    80000d30:	e422                	sd	s0,8(sp)
    80000d32:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d34:	c205                	beqz	a2,80000d54 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d36:	02a5e263          	bltu	a1,a0,80000d5a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d3a:	1602                	slli	a2,a2,0x20
    80000d3c:	9201                	srli	a2,a2,0x20
    80000d3e:	00c587b3          	add	a5,a1,a2
{
    80000d42:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d44:	0585                	addi	a1,a1,1
    80000d46:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd131>
    80000d48:	fff5c683          	lbu	a3,-1(a1)
    80000d4c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d50:	fef59ae3          	bne	a1,a5,80000d44 <memmove+0x16>

  return dst;
}
    80000d54:	6422                	ld	s0,8(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret
  if(s < d && s + n > d){
    80000d5a:	02061693          	slli	a3,a2,0x20
    80000d5e:	9281                	srli	a3,a3,0x20
    80000d60:	00d58733          	add	a4,a1,a3
    80000d64:	fce57be3          	bgeu	a0,a4,80000d3a <memmove+0xc>
    d += n;
    80000d68:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d6a:	fff6079b          	addiw	a5,a2,-1
    80000d6e:	1782                	slli	a5,a5,0x20
    80000d70:	9381                	srli	a5,a5,0x20
    80000d72:	fff7c793          	not	a5,a5
    80000d76:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d78:	177d                	addi	a4,a4,-1
    80000d7a:	16fd                	addi	a3,a3,-1
    80000d7c:	00074603          	lbu	a2,0(a4)
    80000d80:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d84:	fee79ae3          	bne	a5,a4,80000d78 <memmove+0x4a>
    80000d88:	b7f1                	j	80000d54 <memmove+0x26>

0000000080000d8a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d8a:	1141                	addi	sp,sp,-16
    80000d8c:	e406                	sd	ra,8(sp)
    80000d8e:	e022                	sd	s0,0(sp)
    80000d90:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	f9c080e7          	jalr	-100(ra) # 80000d2e <memmove>
}
    80000d9a:	60a2                	ld	ra,8(sp)
    80000d9c:	6402                	ld	s0,0(sp)
    80000d9e:	0141                	addi	sp,sp,16
    80000da0:	8082                	ret

0000000080000da2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da2:	1141                	addi	sp,sp,-16
    80000da4:	e422                	sd	s0,8(sp)
    80000da6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da8:	ce11                	beqz	a2,80000dc4 <strncmp+0x22>
    80000daa:	00054783          	lbu	a5,0(a0)
    80000dae:	cf89                	beqz	a5,80000dc8 <strncmp+0x26>
    80000db0:	0005c703          	lbu	a4,0(a1)
    80000db4:	00f71a63          	bne	a4,a5,80000dc8 <strncmp+0x26>
    n--, p++, q++;
    80000db8:	367d                	addiw	a2,a2,-1
    80000dba:	0505                	addi	a0,a0,1
    80000dbc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dbe:	f675                	bnez	a2,80000daa <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dc0:	4501                	li	a0,0
    80000dc2:	a809                	j	80000dd4 <strncmp+0x32>
    80000dc4:	4501                	li	a0,0
    80000dc6:	a039                	j	80000dd4 <strncmp+0x32>
  if(n == 0)
    80000dc8:	ca09                	beqz	a2,80000dda <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dca:	00054503          	lbu	a0,0(a0)
    80000dce:	0005c783          	lbu	a5,0(a1)
    80000dd2:	9d1d                	subw	a0,a0,a5
}
    80000dd4:	6422                	ld	s0,8(sp)
    80000dd6:	0141                	addi	sp,sp,16
    80000dd8:	8082                	ret
    return 0;
    80000dda:	4501                	li	a0,0
    80000ddc:	bfe5                	j	80000dd4 <strncmp+0x32>

0000000080000dde <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dde:	1141                	addi	sp,sp,-16
    80000de0:	e422                	sd	s0,8(sp)
    80000de2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de4:	872a                	mv	a4,a0
    80000de6:	8832                	mv	a6,a2
    80000de8:	367d                	addiw	a2,a2,-1
    80000dea:	01005963          	blez	a6,80000dfc <strncpy+0x1e>
    80000dee:	0705                	addi	a4,a4,1
    80000df0:	0005c783          	lbu	a5,0(a1)
    80000df4:	fef70fa3          	sb	a5,-1(a4)
    80000df8:	0585                	addi	a1,a1,1
    80000dfa:	f7f5                	bnez	a5,80000de6 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000dfc:	86ba                	mv	a3,a4
    80000dfe:	00c05c63          	blez	a2,80000e16 <strncpy+0x38>
    *s++ = 0;
    80000e02:	0685                	addi	a3,a3,1
    80000e04:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e08:	40d707bb          	subw	a5,a4,a3
    80000e0c:	37fd                	addiw	a5,a5,-1
    80000e0e:	010787bb          	addw	a5,a5,a6
    80000e12:	fef048e3          	bgtz	a5,80000e02 <strncpy+0x24>
  return os;
}
    80000e16:	6422                	ld	s0,8(sp)
    80000e18:	0141                	addi	sp,sp,16
    80000e1a:	8082                	ret

0000000080000e1c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e22:	02c05363          	blez	a2,80000e48 <safestrcpy+0x2c>
    80000e26:	fff6069b          	addiw	a3,a2,-1
    80000e2a:	1682                	slli	a3,a3,0x20
    80000e2c:	9281                	srli	a3,a3,0x20
    80000e2e:	96ae                	add	a3,a3,a1
    80000e30:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e32:	00d58963          	beq	a1,a3,80000e44 <safestrcpy+0x28>
    80000e36:	0585                	addi	a1,a1,1
    80000e38:	0785                	addi	a5,a5,1
    80000e3a:	fff5c703          	lbu	a4,-1(a1)
    80000e3e:	fee78fa3          	sb	a4,-1(a5)
    80000e42:	fb65                	bnez	a4,80000e32 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e44:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e48:	6422                	ld	s0,8(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <strlen>:

int
strlen(const char *s)
{
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e422                	sd	s0,8(sp)
    80000e52:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e54:	00054783          	lbu	a5,0(a0)
    80000e58:	cf91                	beqz	a5,80000e74 <strlen+0x26>
    80000e5a:	0505                	addi	a0,a0,1
    80000e5c:	87aa                	mv	a5,a0
    80000e5e:	4685                	li	a3,1
    80000e60:	9e89                	subw	a3,a3,a0
    80000e62:	00f6853b          	addw	a0,a3,a5
    80000e66:	0785                	addi	a5,a5,1
    80000e68:	fff7c703          	lbu	a4,-1(a5)
    80000e6c:	fb7d                	bnez	a4,80000e62 <strlen+0x14>
    ;
  return n;
}
    80000e6e:	6422                	ld	s0,8(sp)
    80000e70:	0141                	addi	sp,sp,16
    80000e72:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e74:	4501                	li	a0,0
    80000e76:	bfe5                	j	80000e6e <strlen+0x20>

0000000080000e78 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e78:	1141                	addi	sp,sp,-16
    80000e7a:	e406                	sd	ra,8(sp)
    80000e7c:	e022                	sd	s0,0(sp)
    80000e7e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e80:	00001097          	auipc	ra,0x1
    80000e84:	b00080e7          	jalr	-1280(ra) # 80001980 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e88:	00008717          	auipc	a4,0x8
    80000e8c:	bb070713          	addi	a4,a4,-1104 # 80008a38 <started>
  if(cpuid() == 0){
    80000e90:	c139                	beqz	a0,80000ed6 <main+0x5e>
    while(started == 0)
    80000e92:	431c                	lw	a5,0(a4)
    80000e94:	2781                	sext.w	a5,a5
    80000e96:	dff5                	beqz	a5,80000e92 <main+0x1a>
      ;
    __sync_synchronize();
    80000e98:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e9c:	00001097          	auipc	ra,0x1
    80000ea0:	ae4080e7          	jalr	-1308(ra) # 80001980 <cpuid>
    80000ea4:	85aa                	mv	a1,a0
    80000ea6:	00007517          	auipc	a0,0x7
    80000eaa:	21250513          	addi	a0,a0,530 # 800080b8 <digits+0x78>
    80000eae:	fffff097          	auipc	ra,0xfffff
    80000eb2:	6dc080e7          	jalr	1756(ra) # 8000058a <printf>
    kvminithart();    // turn on paging
    80000eb6:	00000097          	auipc	ra,0x0
    80000eba:	0d8080e7          	jalr	216(ra) # 80000f8e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ebe:	00001097          	auipc	ra,0x1
    80000ec2:	78c080e7          	jalr	1932(ra) # 8000264a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	08a080e7          	jalr	138(ra) # 80005f50 <plicinithart>
  }

  scheduler();        
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	fd4080e7          	jalr	-44(ra) # 80001ea2 <scheduler>
    consoleinit();
    80000ed6:	fffff097          	auipc	ra,0xfffff
    80000eda:	57a080e7          	jalr	1402(ra) # 80000450 <consoleinit>
    printfinit();
    80000ede:	00000097          	auipc	ra,0x0
    80000ee2:	88c080e7          	jalr	-1908(ra) # 8000076a <printfinit>
    printf("\n");
    80000ee6:	00007517          	auipc	a0,0x7
    80000eea:	1e250513          	addi	a0,a0,482 # 800080c8 <digits+0x88>
    80000eee:	fffff097          	auipc	ra,0xfffff
    80000ef2:	69c080e7          	jalr	1692(ra) # 8000058a <printf>
    printf("xv6 kernel is booting\n");
    80000ef6:	00007517          	auipc	a0,0x7
    80000efa:	1aa50513          	addi	a0,a0,426 # 800080a0 <digits+0x60>
    80000efe:	fffff097          	auipc	ra,0xfffff
    80000f02:	68c080e7          	jalr	1676(ra) # 8000058a <printf>
    printf("\n");
    80000f06:	00007517          	auipc	a0,0x7
    80000f0a:	1c250513          	addi	a0,a0,450 # 800080c8 <digits+0x88>
    80000f0e:	fffff097          	auipc	ra,0xfffff
    80000f12:	67c080e7          	jalr	1660(ra) # 8000058a <printf>
    kinit();         // physical page allocator
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	b94080e7          	jalr	-1132(ra) # 80000aaa <kinit>
    kvminit();       // create kernel page table
    80000f1e:	00000097          	auipc	ra,0x0
    80000f22:	326080e7          	jalr	806(ra) # 80001244 <kvminit>
    kvminithart();   // turn on paging
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	068080e7          	jalr	104(ra) # 80000f8e <kvminithart>
    procinit();      // process table
    80000f2e:	00001097          	auipc	ra,0x1
    80000f32:	99e080e7          	jalr	-1634(ra) # 800018cc <procinit>
    trapinit();      // trap vectors
    80000f36:	00001097          	auipc	ra,0x1
    80000f3a:	6ec080e7          	jalr	1772(ra) # 80002622 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f3e:	00001097          	auipc	ra,0x1
    80000f42:	70c080e7          	jalr	1804(ra) # 8000264a <trapinithart>
    plicinit();      // set up interrupt controller
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	ff4080e7          	jalr	-12(ra) # 80005f3a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	002080e7          	jalr	2(ra) # 80005f50 <plicinithart>
    binit();         // buffer cache
    80000f56:	00002097          	auipc	ra,0x2
    80000f5a:	0b4080e7          	jalr	180(ra) # 8000300a <binit>
    iinit();         // inode table
    80000f5e:	00002097          	auipc	ra,0x2
    80000f62:	754080e7          	jalr	1876(ra) # 800036b2 <iinit>
    fileinit();      // file table
    80000f66:	00003097          	auipc	ra,0x3
    80000f6a:	6fa080e7          	jalr	1786(ra) # 80004660 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	0ea080e7          	jalr	234(ra) # 80006058 <virtio_disk_init>
    userinit();      // first user process
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	d0e080e7          	jalr	-754(ra) # 80001c84 <userinit>
    __sync_synchronize();
    80000f7e:	0ff0000f          	fence
    started = 1;
    80000f82:	4785                	li	a5,1
    80000f84:	00008717          	auipc	a4,0x8
    80000f88:	aaf72a23          	sw	a5,-1356(a4) # 80008a38 <started>
    80000f8c:	b789                	j	80000ece <main+0x56>

0000000080000f8e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f8e:	1141                	addi	sp,sp,-16
    80000f90:	e422                	sd	s0,8(sp)
    80000f92:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f94:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f98:	00008797          	auipc	a5,0x8
    80000f9c:	aa87b783          	ld	a5,-1368(a5) # 80008a40 <kernel_pagetable>
    80000fa0:	83b1                	srli	a5,a5,0xc
    80000fa2:	577d                	li	a4,-1
    80000fa4:	177e                	slli	a4,a4,0x3f
    80000fa6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fa8:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000fac:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000fb0:	6422                	ld	s0,8(sp)
    80000fb2:	0141                	addi	sp,sp,16
    80000fb4:	8082                	ret

0000000080000fb6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fb6:	7139                	addi	sp,sp,-64
    80000fb8:	fc06                	sd	ra,56(sp)
    80000fba:	f822                	sd	s0,48(sp)
    80000fbc:	f426                	sd	s1,40(sp)
    80000fbe:	f04a                	sd	s2,32(sp)
    80000fc0:	ec4e                	sd	s3,24(sp)
    80000fc2:	e852                	sd	s4,16(sp)
    80000fc4:	e456                	sd	s5,8(sp)
    80000fc6:	e05a                	sd	s6,0(sp)
    80000fc8:	0080                	addi	s0,sp,64
    80000fca:	84aa                	mv	s1,a0
    80000fcc:	89ae                	mv	s3,a1
    80000fce:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fd0:	57fd                	li	a5,-1
    80000fd2:	83e9                	srli	a5,a5,0x1a
    80000fd4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fd6:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fd8:	04b7f263          	bgeu	a5,a1,8000101c <walk+0x66>
    panic("walk");
    80000fdc:	00007517          	auipc	a0,0x7
    80000fe0:	0f450513          	addi	a0,a0,244 # 800080d0 <digits+0x90>
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	55c080e7          	jalr	1372(ra) # 80000540 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fec:	060a8663          	beqz	s5,80001058 <walk+0xa2>
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	af6080e7          	jalr	-1290(ra) # 80000ae6 <kalloc>
    80000ff8:	84aa                	mv	s1,a0
    80000ffa:	c529                	beqz	a0,80001044 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ffc:	6605                	lui	a2,0x1
    80000ffe:	4581                	li	a1,0
    80001000:	00000097          	auipc	ra,0x0
    80001004:	cd2080e7          	jalr	-814(ra) # 80000cd2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001008:	00c4d793          	srli	a5,s1,0xc
    8000100c:	07aa                	slli	a5,a5,0xa
    8000100e:	0017e793          	ori	a5,a5,1
    80001012:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001016:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd127>
    80001018:	036a0063          	beq	s4,s6,80001038 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000101c:	0149d933          	srl	s2,s3,s4
    80001020:	1ff97913          	andi	s2,s2,511
    80001024:	090e                	slli	s2,s2,0x3
    80001026:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001028:	00093483          	ld	s1,0(s2)
    8000102c:	0014f793          	andi	a5,s1,1
    80001030:	dfd5                	beqz	a5,80000fec <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001032:	80a9                	srli	s1,s1,0xa
    80001034:	04b2                	slli	s1,s1,0xc
    80001036:	b7c5                	j	80001016 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001038:	00c9d513          	srli	a0,s3,0xc
    8000103c:	1ff57513          	andi	a0,a0,511
    80001040:	050e                	slli	a0,a0,0x3
    80001042:	9526                	add	a0,a0,s1
}
    80001044:	70e2                	ld	ra,56(sp)
    80001046:	7442                	ld	s0,48(sp)
    80001048:	74a2                	ld	s1,40(sp)
    8000104a:	7902                	ld	s2,32(sp)
    8000104c:	69e2                	ld	s3,24(sp)
    8000104e:	6a42                	ld	s4,16(sp)
    80001050:	6aa2                	ld	s5,8(sp)
    80001052:	6b02                	ld	s6,0(sp)
    80001054:	6121                	addi	sp,sp,64
    80001056:	8082                	ret
        return 0;
    80001058:	4501                	li	a0,0
    8000105a:	b7ed                	j	80001044 <walk+0x8e>

000000008000105c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000105c:	57fd                	li	a5,-1
    8000105e:	83e9                	srli	a5,a5,0x1a
    80001060:	00b7f463          	bgeu	a5,a1,80001068 <walkaddr+0xc>
    return 0;
    80001064:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001066:	8082                	ret
{
    80001068:	1141                	addi	sp,sp,-16
    8000106a:	e406                	sd	ra,8(sp)
    8000106c:	e022                	sd	s0,0(sp)
    8000106e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001070:	4601                	li	a2,0
    80001072:	00000097          	auipc	ra,0x0
    80001076:	f44080e7          	jalr	-188(ra) # 80000fb6 <walk>
  if(pte == 0)
    8000107a:	c105                	beqz	a0,8000109a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000107c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000107e:	0117f693          	andi	a3,a5,17
    80001082:	4745                	li	a4,17
    return 0;
    80001084:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001086:	00e68663          	beq	a3,a4,80001092 <walkaddr+0x36>
}
    8000108a:	60a2                	ld	ra,8(sp)
    8000108c:	6402                	ld	s0,0(sp)
    8000108e:	0141                	addi	sp,sp,16
    80001090:	8082                	ret
  pa = PTE2PA(*pte);
    80001092:	83a9                	srli	a5,a5,0xa
    80001094:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001098:	bfcd                	j	8000108a <walkaddr+0x2e>
    return 0;
    8000109a:	4501                	li	a0,0
    8000109c:	b7fd                	j	8000108a <walkaddr+0x2e>

000000008000109e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000109e:	715d                	addi	sp,sp,-80
    800010a0:	e486                	sd	ra,72(sp)
    800010a2:	e0a2                	sd	s0,64(sp)
    800010a4:	fc26                	sd	s1,56(sp)
    800010a6:	f84a                	sd	s2,48(sp)
    800010a8:	f44e                	sd	s3,40(sp)
    800010aa:	f052                	sd	s4,32(sp)
    800010ac:	ec56                	sd	s5,24(sp)
    800010ae:	e85a                	sd	s6,16(sp)
    800010b0:	e45e                	sd	s7,8(sp)
    800010b2:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010b4:	c639                	beqz	a2,80001102 <mappages+0x64>
    800010b6:	8aaa                	mv	s5,a0
    800010b8:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800010ba:	777d                	lui	a4,0xfffff
    800010bc:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010c0:	fff58993          	addi	s3,a1,-1
    800010c4:	99b2                	add	s3,s3,a2
    800010c6:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010ca:	893e                	mv	s2,a5
    800010cc:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010d0:	6b85                	lui	s7,0x1
    800010d2:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010d6:	4605                	li	a2,1
    800010d8:	85ca                	mv	a1,s2
    800010da:	8556                	mv	a0,s5
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	eda080e7          	jalr	-294(ra) # 80000fb6 <walk>
    800010e4:	cd1d                	beqz	a0,80001122 <mappages+0x84>
    if(*pte & PTE_V)
    800010e6:	611c                	ld	a5,0(a0)
    800010e8:	8b85                	andi	a5,a5,1
    800010ea:	e785                	bnez	a5,80001112 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010ec:	80b1                	srli	s1,s1,0xc
    800010ee:	04aa                	slli	s1,s1,0xa
    800010f0:	0164e4b3          	or	s1,s1,s6
    800010f4:	0014e493          	ori	s1,s1,1
    800010f8:	e104                	sd	s1,0(a0)
    if(a == last)
    800010fa:	05390063          	beq	s2,s3,8000113a <mappages+0x9c>
    a += PGSIZE;
    800010fe:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001100:	bfc9                	j	800010d2 <mappages+0x34>
    panic("mappages: size");
    80001102:	00007517          	auipc	a0,0x7
    80001106:	fd650513          	addi	a0,a0,-42 # 800080d8 <digits+0x98>
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	436080e7          	jalr	1078(ra) # 80000540 <panic>
      panic("mappages: remap");
    80001112:	00007517          	auipc	a0,0x7
    80001116:	fd650513          	addi	a0,a0,-42 # 800080e8 <digits+0xa8>
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	426080e7          	jalr	1062(ra) # 80000540 <panic>
      return -1;
    80001122:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001124:	60a6                	ld	ra,72(sp)
    80001126:	6406                	ld	s0,64(sp)
    80001128:	74e2                	ld	s1,56(sp)
    8000112a:	7942                	ld	s2,48(sp)
    8000112c:	79a2                	ld	s3,40(sp)
    8000112e:	7a02                	ld	s4,32(sp)
    80001130:	6ae2                	ld	s5,24(sp)
    80001132:	6b42                	ld	s6,16(sp)
    80001134:	6ba2                	ld	s7,8(sp)
    80001136:	6161                	addi	sp,sp,80
    80001138:	8082                	ret
  return 0;
    8000113a:	4501                	li	a0,0
    8000113c:	b7e5                	j	80001124 <mappages+0x86>

000000008000113e <kvmmap>:
{
    8000113e:	1141                	addi	sp,sp,-16
    80001140:	e406                	sd	ra,8(sp)
    80001142:	e022                	sd	s0,0(sp)
    80001144:	0800                	addi	s0,sp,16
    80001146:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001148:	86b2                	mv	a3,a2
    8000114a:	863e                	mv	a2,a5
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	f52080e7          	jalr	-174(ra) # 8000109e <mappages>
    80001154:	e509                	bnez	a0,8000115e <kvmmap+0x20>
}
    80001156:	60a2                	ld	ra,8(sp)
    80001158:	6402                	ld	s0,0(sp)
    8000115a:	0141                	addi	sp,sp,16
    8000115c:	8082                	ret
    panic("kvmmap");
    8000115e:	00007517          	auipc	a0,0x7
    80001162:	f9a50513          	addi	a0,a0,-102 # 800080f8 <digits+0xb8>
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	3da080e7          	jalr	986(ra) # 80000540 <panic>

000000008000116e <kvmmake>:
{
    8000116e:	1101                	addi	sp,sp,-32
    80001170:	ec06                	sd	ra,24(sp)
    80001172:	e822                	sd	s0,16(sp)
    80001174:	e426                	sd	s1,8(sp)
    80001176:	e04a                	sd	s2,0(sp)
    80001178:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	96c080e7          	jalr	-1684(ra) # 80000ae6 <kalloc>
    80001182:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001184:	6605                	lui	a2,0x1
    80001186:	4581                	li	a1,0
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	b4a080e7          	jalr	-1206(ra) # 80000cd2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001190:	4719                	li	a4,6
    80001192:	6685                	lui	a3,0x1
    80001194:	10000637          	lui	a2,0x10000
    80001198:	100005b7          	lui	a1,0x10000
    8000119c:	8526                	mv	a0,s1
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	fa0080e7          	jalr	-96(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011a6:	4719                	li	a4,6
    800011a8:	6685                	lui	a3,0x1
    800011aa:	10001637          	lui	a2,0x10001
    800011ae:	100015b7          	lui	a1,0x10001
    800011b2:	8526                	mv	a0,s1
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f8a080e7          	jalr	-118(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011bc:	4719                	li	a4,6
    800011be:	004006b7          	lui	a3,0x400
    800011c2:	0c000637          	lui	a2,0xc000
    800011c6:	0c0005b7          	lui	a1,0xc000
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	f72080e7          	jalr	-142(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011d4:	00007917          	auipc	s2,0x7
    800011d8:	e2c90913          	addi	s2,s2,-468 # 80008000 <etext>
    800011dc:	4729                	li	a4,10
    800011de:	80007697          	auipc	a3,0x80007
    800011e2:	e2268693          	addi	a3,a3,-478 # 8000 <_entry-0x7fff8000>
    800011e6:	4605                	li	a2,1
    800011e8:	067e                	slli	a2,a2,0x1f
    800011ea:	85b2                	mv	a1,a2
    800011ec:	8526                	mv	a0,s1
    800011ee:	00000097          	auipc	ra,0x0
    800011f2:	f50080e7          	jalr	-176(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011f6:	4719                	li	a4,6
    800011f8:	46c5                	li	a3,17
    800011fa:	06ee                	slli	a3,a3,0x1b
    800011fc:	412686b3          	sub	a3,a3,s2
    80001200:	864a                	mv	a2,s2
    80001202:	85ca                	mv	a1,s2
    80001204:	8526                	mv	a0,s1
    80001206:	00000097          	auipc	ra,0x0
    8000120a:	f38080e7          	jalr	-200(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000120e:	4729                	li	a4,10
    80001210:	6685                	lui	a3,0x1
    80001212:	00006617          	auipc	a2,0x6
    80001216:	dee60613          	addi	a2,a2,-530 # 80007000 <_trampoline>
    8000121a:	040005b7          	lui	a1,0x4000
    8000121e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001220:	05b2                	slli	a1,a1,0xc
    80001222:	8526                	mv	a0,s1
    80001224:	00000097          	auipc	ra,0x0
    80001228:	f1a080e7          	jalr	-230(ra) # 8000113e <kvmmap>
  proc_mapstacks(kpgtbl);
    8000122c:	8526                	mv	a0,s1
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	608080e7          	jalr	1544(ra) # 80001836 <proc_mapstacks>
}
    80001236:	8526                	mv	a0,s1
    80001238:	60e2                	ld	ra,24(sp)
    8000123a:	6442                	ld	s0,16(sp)
    8000123c:	64a2                	ld	s1,8(sp)
    8000123e:	6902                	ld	s2,0(sp)
    80001240:	6105                	addi	sp,sp,32
    80001242:	8082                	ret

0000000080001244 <kvminit>:
{
    80001244:	1141                	addi	sp,sp,-16
    80001246:	e406                	sd	ra,8(sp)
    80001248:	e022                	sd	s0,0(sp)
    8000124a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	f22080e7          	jalr	-222(ra) # 8000116e <kvmmake>
    80001254:	00007797          	auipc	a5,0x7
    80001258:	7ea7b623          	sd	a0,2028(a5) # 80008a40 <kernel_pagetable>
}
    8000125c:	60a2                	ld	ra,8(sp)
    8000125e:	6402                	ld	s0,0(sp)
    80001260:	0141                	addi	sp,sp,16
    80001262:	8082                	ret

0000000080001264 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001264:	715d                	addi	sp,sp,-80
    80001266:	e486                	sd	ra,72(sp)
    80001268:	e0a2                	sd	s0,64(sp)
    8000126a:	fc26                	sd	s1,56(sp)
    8000126c:	f84a                	sd	s2,48(sp)
    8000126e:	f44e                	sd	s3,40(sp)
    80001270:	f052                	sd	s4,32(sp)
    80001272:	ec56                	sd	s5,24(sp)
    80001274:	e85a                	sd	s6,16(sp)
    80001276:	e45e                	sd	s7,8(sp)
    80001278:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000127a:	03459793          	slli	a5,a1,0x34
    8000127e:	e795                	bnez	a5,800012aa <uvmunmap+0x46>
    80001280:	8a2a                	mv	s4,a0
    80001282:	892e                	mv	s2,a1
    80001284:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001286:	0632                	slli	a2,a2,0xc
    80001288:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000128c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000128e:	6b05                	lui	s6,0x1
    80001290:	0735e263          	bltu	a1,s3,800012f4 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001294:	60a6                	ld	ra,72(sp)
    80001296:	6406                	ld	s0,64(sp)
    80001298:	74e2                	ld	s1,56(sp)
    8000129a:	7942                	ld	s2,48(sp)
    8000129c:	79a2                	ld	s3,40(sp)
    8000129e:	7a02                	ld	s4,32(sp)
    800012a0:	6ae2                	ld	s5,24(sp)
    800012a2:	6b42                	ld	s6,16(sp)
    800012a4:	6ba2                	ld	s7,8(sp)
    800012a6:	6161                	addi	sp,sp,80
    800012a8:	8082                	ret
    panic("uvmunmap: not aligned");
    800012aa:	00007517          	auipc	a0,0x7
    800012ae:	e5650513          	addi	a0,a0,-426 # 80008100 <digits+0xc0>
    800012b2:	fffff097          	auipc	ra,0xfffff
    800012b6:	28e080e7          	jalr	654(ra) # 80000540 <panic>
      panic("uvmunmap: walk");
    800012ba:	00007517          	auipc	a0,0x7
    800012be:	e5e50513          	addi	a0,a0,-418 # 80008118 <digits+0xd8>
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	27e080e7          	jalr	638(ra) # 80000540 <panic>
      panic("uvmunmap: not mapped");
    800012ca:	00007517          	auipc	a0,0x7
    800012ce:	e5e50513          	addi	a0,a0,-418 # 80008128 <digits+0xe8>
    800012d2:	fffff097          	auipc	ra,0xfffff
    800012d6:	26e080e7          	jalr	622(ra) # 80000540 <panic>
      panic("uvmunmap: not a leaf");
    800012da:	00007517          	auipc	a0,0x7
    800012de:	e6650513          	addi	a0,a0,-410 # 80008140 <digits+0x100>
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	25e080e7          	jalr	606(ra) # 80000540 <panic>
    *pte = 0;
    800012ea:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012ee:	995a                	add	s2,s2,s6
    800012f0:	fb3972e3          	bgeu	s2,s3,80001294 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012f4:	4601                	li	a2,0
    800012f6:	85ca                	mv	a1,s2
    800012f8:	8552                	mv	a0,s4
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	cbc080e7          	jalr	-836(ra) # 80000fb6 <walk>
    80001302:	84aa                	mv	s1,a0
    80001304:	d95d                	beqz	a0,800012ba <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001306:	6108                	ld	a0,0(a0)
    80001308:	00157793          	andi	a5,a0,1
    8000130c:	dfdd                	beqz	a5,800012ca <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000130e:	3ff57793          	andi	a5,a0,1023
    80001312:	fd7784e3          	beq	a5,s7,800012da <uvmunmap+0x76>
    if(do_free){
    80001316:	fc0a8ae3          	beqz	s5,800012ea <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000131a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000131c:	0532                	slli	a0,a0,0xc
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	6ca080e7          	jalr	1738(ra) # 800009e8 <kfree>
    80001326:	b7d1                	j	800012ea <uvmunmap+0x86>

0000000080001328 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001328:	1101                	addi	sp,sp,-32
    8000132a:	ec06                	sd	ra,24(sp)
    8000132c:	e822                	sd	s0,16(sp)
    8000132e:	e426                	sd	s1,8(sp)
    80001330:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001332:	fffff097          	auipc	ra,0xfffff
    80001336:	7b4080e7          	jalr	1972(ra) # 80000ae6 <kalloc>
    8000133a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000133c:	c519                	beqz	a0,8000134a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000133e:	6605                	lui	a2,0x1
    80001340:	4581                	li	a1,0
    80001342:	00000097          	auipc	ra,0x0
    80001346:	990080e7          	jalr	-1648(ra) # 80000cd2 <memset>
  return pagetable;
}
    8000134a:	8526                	mv	a0,s1
    8000134c:	60e2                	ld	ra,24(sp)
    8000134e:	6442                	ld	s0,16(sp)
    80001350:	64a2                	ld	s1,8(sp)
    80001352:	6105                	addi	sp,sp,32
    80001354:	8082                	ret

0000000080001356 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001356:	7179                	addi	sp,sp,-48
    80001358:	f406                	sd	ra,40(sp)
    8000135a:	f022                	sd	s0,32(sp)
    8000135c:	ec26                	sd	s1,24(sp)
    8000135e:	e84a                	sd	s2,16(sp)
    80001360:	e44e                	sd	s3,8(sp)
    80001362:	e052                	sd	s4,0(sp)
    80001364:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001366:	6785                	lui	a5,0x1
    80001368:	04f67863          	bgeu	a2,a5,800013b8 <uvmfirst+0x62>
    8000136c:	8a2a                	mv	s4,a0
    8000136e:	89ae                	mv	s3,a1
    80001370:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	774080e7          	jalr	1908(ra) # 80000ae6 <kalloc>
    8000137a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000137c:	6605                	lui	a2,0x1
    8000137e:	4581                	li	a1,0
    80001380:	00000097          	auipc	ra,0x0
    80001384:	952080e7          	jalr	-1710(ra) # 80000cd2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001388:	4779                	li	a4,30
    8000138a:	86ca                	mv	a3,s2
    8000138c:	6605                	lui	a2,0x1
    8000138e:	4581                	li	a1,0
    80001390:	8552                	mv	a0,s4
    80001392:	00000097          	auipc	ra,0x0
    80001396:	d0c080e7          	jalr	-756(ra) # 8000109e <mappages>
  memmove(mem, src, sz);
    8000139a:	8626                	mv	a2,s1
    8000139c:	85ce                	mv	a1,s3
    8000139e:	854a                	mv	a0,s2
    800013a0:	00000097          	auipc	ra,0x0
    800013a4:	98e080e7          	jalr	-1650(ra) # 80000d2e <memmove>
}
    800013a8:	70a2                	ld	ra,40(sp)
    800013aa:	7402                	ld	s0,32(sp)
    800013ac:	64e2                	ld	s1,24(sp)
    800013ae:	6942                	ld	s2,16(sp)
    800013b0:	69a2                	ld	s3,8(sp)
    800013b2:	6a02                	ld	s4,0(sp)
    800013b4:	6145                	addi	sp,sp,48
    800013b6:	8082                	ret
    panic("uvmfirst: more than a page");
    800013b8:	00007517          	auipc	a0,0x7
    800013bc:	da050513          	addi	a0,a0,-608 # 80008158 <digits+0x118>
    800013c0:	fffff097          	auipc	ra,0xfffff
    800013c4:	180080e7          	jalr	384(ra) # 80000540 <panic>

00000000800013c8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013c8:	1101                	addi	sp,sp,-32
    800013ca:	ec06                	sd	ra,24(sp)
    800013cc:	e822                	sd	s0,16(sp)
    800013ce:	e426                	sd	s1,8(sp)
    800013d0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013d2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013d4:	00b67d63          	bgeu	a2,a1,800013ee <uvmdealloc+0x26>
    800013d8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013da:	6785                	lui	a5,0x1
    800013dc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013de:	00f60733          	add	a4,a2,a5
    800013e2:	76fd                	lui	a3,0xfffff
    800013e4:	8f75                	and	a4,a4,a3
    800013e6:	97ae                	add	a5,a5,a1
    800013e8:	8ff5                	and	a5,a5,a3
    800013ea:	00f76863          	bltu	a4,a5,800013fa <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013ee:	8526                	mv	a0,s1
    800013f0:	60e2                	ld	ra,24(sp)
    800013f2:	6442                	ld	s0,16(sp)
    800013f4:	64a2                	ld	s1,8(sp)
    800013f6:	6105                	addi	sp,sp,32
    800013f8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013fa:	8f99                	sub	a5,a5,a4
    800013fc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013fe:	4685                	li	a3,1
    80001400:	0007861b          	sext.w	a2,a5
    80001404:	85ba                	mv	a1,a4
    80001406:	00000097          	auipc	ra,0x0
    8000140a:	e5e080e7          	jalr	-418(ra) # 80001264 <uvmunmap>
    8000140e:	b7c5                	j	800013ee <uvmdealloc+0x26>

0000000080001410 <uvmalloc>:
  if(newsz < oldsz)
    80001410:	0ab66563          	bltu	a2,a1,800014ba <uvmalloc+0xaa>
{
    80001414:	7139                	addi	sp,sp,-64
    80001416:	fc06                	sd	ra,56(sp)
    80001418:	f822                	sd	s0,48(sp)
    8000141a:	f426                	sd	s1,40(sp)
    8000141c:	f04a                	sd	s2,32(sp)
    8000141e:	ec4e                	sd	s3,24(sp)
    80001420:	e852                	sd	s4,16(sp)
    80001422:	e456                	sd	s5,8(sp)
    80001424:	e05a                	sd	s6,0(sp)
    80001426:	0080                	addi	s0,sp,64
    80001428:	8aaa                	mv	s5,a0
    8000142a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000142c:	6785                	lui	a5,0x1
    8000142e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001430:	95be                	add	a1,a1,a5
    80001432:	77fd                	lui	a5,0xfffff
    80001434:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001438:	08c9f363          	bgeu	s3,a2,800014be <uvmalloc+0xae>
    8000143c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000143e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001442:	fffff097          	auipc	ra,0xfffff
    80001446:	6a4080e7          	jalr	1700(ra) # 80000ae6 <kalloc>
    8000144a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000144c:	c51d                	beqz	a0,8000147a <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000144e:	6605                	lui	a2,0x1
    80001450:	4581                	li	a1,0
    80001452:	00000097          	auipc	ra,0x0
    80001456:	880080e7          	jalr	-1920(ra) # 80000cd2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000145a:	875a                	mv	a4,s6
    8000145c:	86a6                	mv	a3,s1
    8000145e:	6605                	lui	a2,0x1
    80001460:	85ca                	mv	a1,s2
    80001462:	8556                	mv	a0,s5
    80001464:	00000097          	auipc	ra,0x0
    80001468:	c3a080e7          	jalr	-966(ra) # 8000109e <mappages>
    8000146c:	e90d                	bnez	a0,8000149e <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000146e:	6785                	lui	a5,0x1
    80001470:	993e                	add	s2,s2,a5
    80001472:	fd4968e3          	bltu	s2,s4,80001442 <uvmalloc+0x32>
  return newsz;
    80001476:	8552                	mv	a0,s4
    80001478:	a809                	j	8000148a <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000147a:	864e                	mv	a2,s3
    8000147c:	85ca                	mv	a1,s2
    8000147e:	8556                	mv	a0,s5
    80001480:	00000097          	auipc	ra,0x0
    80001484:	f48080e7          	jalr	-184(ra) # 800013c8 <uvmdealloc>
      return 0;
    80001488:	4501                	li	a0,0
}
    8000148a:	70e2                	ld	ra,56(sp)
    8000148c:	7442                	ld	s0,48(sp)
    8000148e:	74a2                	ld	s1,40(sp)
    80001490:	7902                	ld	s2,32(sp)
    80001492:	69e2                	ld	s3,24(sp)
    80001494:	6a42                	ld	s4,16(sp)
    80001496:	6aa2                	ld	s5,8(sp)
    80001498:	6b02                	ld	s6,0(sp)
    8000149a:	6121                	addi	sp,sp,64
    8000149c:	8082                	ret
      kfree(mem);
    8000149e:	8526                	mv	a0,s1
    800014a0:	fffff097          	auipc	ra,0xfffff
    800014a4:	548080e7          	jalr	1352(ra) # 800009e8 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014a8:	864e                	mv	a2,s3
    800014aa:	85ca                	mv	a1,s2
    800014ac:	8556                	mv	a0,s5
    800014ae:	00000097          	auipc	ra,0x0
    800014b2:	f1a080e7          	jalr	-230(ra) # 800013c8 <uvmdealloc>
      return 0;
    800014b6:	4501                	li	a0,0
    800014b8:	bfc9                	j	8000148a <uvmalloc+0x7a>
    return oldsz;
    800014ba:	852e                	mv	a0,a1
}
    800014bc:	8082                	ret
  return newsz;
    800014be:	8532                	mv	a0,a2
    800014c0:	b7e9                	j	8000148a <uvmalloc+0x7a>

00000000800014c2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014c2:	7179                	addi	sp,sp,-48
    800014c4:	f406                	sd	ra,40(sp)
    800014c6:	f022                	sd	s0,32(sp)
    800014c8:	ec26                	sd	s1,24(sp)
    800014ca:	e84a                	sd	s2,16(sp)
    800014cc:	e44e                	sd	s3,8(sp)
    800014ce:	e052                	sd	s4,0(sp)
    800014d0:	1800                	addi	s0,sp,48
    800014d2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014d4:	84aa                	mv	s1,a0
    800014d6:	6905                	lui	s2,0x1
    800014d8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014da:	4985                	li	s3,1
    800014dc:	a829                	j	800014f6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014de:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014e0:	00c79513          	slli	a0,a5,0xc
    800014e4:	00000097          	auipc	ra,0x0
    800014e8:	fde080e7          	jalr	-34(ra) # 800014c2 <freewalk>
      pagetable[i] = 0;
    800014ec:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014f0:	04a1                	addi	s1,s1,8
    800014f2:	03248163          	beq	s1,s2,80001514 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800014f6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014f8:	00f7f713          	andi	a4,a5,15
    800014fc:	ff3701e3          	beq	a4,s3,800014de <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001500:	8b85                	andi	a5,a5,1
    80001502:	d7fd                	beqz	a5,800014f0 <freewalk+0x2e>
      panic("freewalk: leaf");
    80001504:	00007517          	auipc	a0,0x7
    80001508:	c7450513          	addi	a0,a0,-908 # 80008178 <digits+0x138>
    8000150c:	fffff097          	auipc	ra,0xfffff
    80001510:	034080e7          	jalr	52(ra) # 80000540 <panic>
    }
  }
  kfree((void*)pagetable);
    80001514:	8552                	mv	a0,s4
    80001516:	fffff097          	auipc	ra,0xfffff
    8000151a:	4d2080e7          	jalr	1234(ra) # 800009e8 <kfree>
}
    8000151e:	70a2                	ld	ra,40(sp)
    80001520:	7402                	ld	s0,32(sp)
    80001522:	64e2                	ld	s1,24(sp)
    80001524:	6942                	ld	s2,16(sp)
    80001526:	69a2                	ld	s3,8(sp)
    80001528:	6a02                	ld	s4,0(sp)
    8000152a:	6145                	addi	sp,sp,48
    8000152c:	8082                	ret

000000008000152e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000152e:	1101                	addi	sp,sp,-32
    80001530:	ec06                	sd	ra,24(sp)
    80001532:	e822                	sd	s0,16(sp)
    80001534:	e426                	sd	s1,8(sp)
    80001536:	1000                	addi	s0,sp,32
    80001538:	84aa                	mv	s1,a0
  if(sz > 0)
    8000153a:	e999                	bnez	a1,80001550 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000153c:	8526                	mv	a0,s1
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	f84080e7          	jalr	-124(ra) # 800014c2 <freewalk>
}
    80001546:	60e2                	ld	ra,24(sp)
    80001548:	6442                	ld	s0,16(sp)
    8000154a:	64a2                	ld	s1,8(sp)
    8000154c:	6105                	addi	sp,sp,32
    8000154e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001550:	6785                	lui	a5,0x1
    80001552:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001554:	95be                	add	a1,a1,a5
    80001556:	4685                	li	a3,1
    80001558:	00c5d613          	srli	a2,a1,0xc
    8000155c:	4581                	li	a1,0
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	d06080e7          	jalr	-762(ra) # 80001264 <uvmunmap>
    80001566:	bfd9                	j	8000153c <uvmfree+0xe>

0000000080001568 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001568:	c679                	beqz	a2,80001636 <uvmcopy+0xce>
{
    8000156a:	715d                	addi	sp,sp,-80
    8000156c:	e486                	sd	ra,72(sp)
    8000156e:	e0a2                	sd	s0,64(sp)
    80001570:	fc26                	sd	s1,56(sp)
    80001572:	f84a                	sd	s2,48(sp)
    80001574:	f44e                	sd	s3,40(sp)
    80001576:	f052                	sd	s4,32(sp)
    80001578:	ec56                	sd	s5,24(sp)
    8000157a:	e85a                	sd	s6,16(sp)
    8000157c:	e45e                	sd	s7,8(sp)
    8000157e:	0880                	addi	s0,sp,80
    80001580:	8b2a                	mv	s6,a0
    80001582:	8aae                	mv	s5,a1
    80001584:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001586:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001588:	4601                	li	a2,0
    8000158a:	85ce                	mv	a1,s3
    8000158c:	855a                	mv	a0,s6
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	a28080e7          	jalr	-1496(ra) # 80000fb6 <walk>
    80001596:	c531                	beqz	a0,800015e2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001598:	6118                	ld	a4,0(a0)
    8000159a:	00177793          	andi	a5,a4,1
    8000159e:	cbb1                	beqz	a5,800015f2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015a0:	00a75593          	srli	a1,a4,0xa
    800015a4:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015a8:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015ac:	fffff097          	auipc	ra,0xfffff
    800015b0:	53a080e7          	jalr	1338(ra) # 80000ae6 <kalloc>
    800015b4:	892a                	mv	s2,a0
    800015b6:	c939                	beqz	a0,8000160c <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015b8:	6605                	lui	a2,0x1
    800015ba:	85de                	mv	a1,s7
    800015bc:	fffff097          	auipc	ra,0xfffff
    800015c0:	772080e7          	jalr	1906(ra) # 80000d2e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015c4:	8726                	mv	a4,s1
    800015c6:	86ca                	mv	a3,s2
    800015c8:	6605                	lui	a2,0x1
    800015ca:	85ce                	mv	a1,s3
    800015cc:	8556                	mv	a0,s5
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	ad0080e7          	jalr	-1328(ra) # 8000109e <mappages>
    800015d6:	e515                	bnez	a0,80001602 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015d8:	6785                	lui	a5,0x1
    800015da:	99be                	add	s3,s3,a5
    800015dc:	fb49e6e3          	bltu	s3,s4,80001588 <uvmcopy+0x20>
    800015e0:	a081                	j	80001620 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015e2:	00007517          	auipc	a0,0x7
    800015e6:	ba650513          	addi	a0,a0,-1114 # 80008188 <digits+0x148>
    800015ea:	fffff097          	auipc	ra,0xfffff
    800015ee:	f56080e7          	jalr	-170(ra) # 80000540 <panic>
      panic("uvmcopy: page not present");
    800015f2:	00007517          	auipc	a0,0x7
    800015f6:	bb650513          	addi	a0,a0,-1098 # 800081a8 <digits+0x168>
    800015fa:	fffff097          	auipc	ra,0xfffff
    800015fe:	f46080e7          	jalr	-186(ra) # 80000540 <panic>
      kfree(mem);
    80001602:	854a                	mv	a0,s2
    80001604:	fffff097          	auipc	ra,0xfffff
    80001608:	3e4080e7          	jalr	996(ra) # 800009e8 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000160c:	4685                	li	a3,1
    8000160e:	00c9d613          	srli	a2,s3,0xc
    80001612:	4581                	li	a1,0
    80001614:	8556                	mv	a0,s5
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	c4e080e7          	jalr	-946(ra) # 80001264 <uvmunmap>
  return -1;
    8000161e:	557d                	li	a0,-1
}
    80001620:	60a6                	ld	ra,72(sp)
    80001622:	6406                	ld	s0,64(sp)
    80001624:	74e2                	ld	s1,56(sp)
    80001626:	7942                	ld	s2,48(sp)
    80001628:	79a2                	ld	s3,40(sp)
    8000162a:	7a02                	ld	s4,32(sp)
    8000162c:	6ae2                	ld	s5,24(sp)
    8000162e:	6b42                	ld	s6,16(sp)
    80001630:	6ba2                	ld	s7,8(sp)
    80001632:	6161                	addi	sp,sp,80
    80001634:	8082                	ret
  return 0;
    80001636:	4501                	li	a0,0
}
    80001638:	8082                	ret

000000008000163a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000163a:	1141                	addi	sp,sp,-16
    8000163c:	e406                	sd	ra,8(sp)
    8000163e:	e022                	sd	s0,0(sp)
    80001640:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001642:	4601                	li	a2,0
    80001644:	00000097          	auipc	ra,0x0
    80001648:	972080e7          	jalr	-1678(ra) # 80000fb6 <walk>
  if(pte == 0)
    8000164c:	c901                	beqz	a0,8000165c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000164e:	611c                	ld	a5,0(a0)
    80001650:	9bbd                	andi	a5,a5,-17
    80001652:	e11c                	sd	a5,0(a0)
}
    80001654:	60a2                	ld	ra,8(sp)
    80001656:	6402                	ld	s0,0(sp)
    80001658:	0141                	addi	sp,sp,16
    8000165a:	8082                	ret
    panic("uvmclear");
    8000165c:	00007517          	auipc	a0,0x7
    80001660:	b6c50513          	addi	a0,a0,-1172 # 800081c8 <digits+0x188>
    80001664:	fffff097          	auipc	ra,0xfffff
    80001668:	edc080e7          	jalr	-292(ra) # 80000540 <panic>

000000008000166c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000166c:	c6bd                	beqz	a3,800016da <copyout+0x6e>
{
    8000166e:	715d                	addi	sp,sp,-80
    80001670:	e486                	sd	ra,72(sp)
    80001672:	e0a2                	sd	s0,64(sp)
    80001674:	fc26                	sd	s1,56(sp)
    80001676:	f84a                	sd	s2,48(sp)
    80001678:	f44e                	sd	s3,40(sp)
    8000167a:	f052                	sd	s4,32(sp)
    8000167c:	ec56                	sd	s5,24(sp)
    8000167e:	e85a                	sd	s6,16(sp)
    80001680:	e45e                	sd	s7,8(sp)
    80001682:	e062                	sd	s8,0(sp)
    80001684:	0880                	addi	s0,sp,80
    80001686:	8b2a                	mv	s6,a0
    80001688:	8c2e                	mv	s8,a1
    8000168a:	8a32                	mv	s4,a2
    8000168c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000168e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001690:	6a85                	lui	s5,0x1
    80001692:	a015                	j	800016b6 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001694:	9562                	add	a0,a0,s8
    80001696:	0004861b          	sext.w	a2,s1
    8000169a:	85d2                	mv	a1,s4
    8000169c:	41250533          	sub	a0,a0,s2
    800016a0:	fffff097          	auipc	ra,0xfffff
    800016a4:	68e080e7          	jalr	1678(ra) # 80000d2e <memmove>

    len -= n;
    800016a8:	409989b3          	sub	s3,s3,s1
    src += n;
    800016ac:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016ae:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016b2:	02098263          	beqz	s3,800016d6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016b6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016ba:	85ca                	mv	a1,s2
    800016bc:	855a                	mv	a0,s6
    800016be:	00000097          	auipc	ra,0x0
    800016c2:	99e080e7          	jalr	-1634(ra) # 8000105c <walkaddr>
    if(pa0 == 0)
    800016c6:	cd01                	beqz	a0,800016de <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016c8:	418904b3          	sub	s1,s2,s8
    800016cc:	94d6                	add	s1,s1,s5
    800016ce:	fc99f3e3          	bgeu	s3,s1,80001694 <copyout+0x28>
    800016d2:	84ce                	mv	s1,s3
    800016d4:	b7c1                	j	80001694 <copyout+0x28>
  }
  return 0;
    800016d6:	4501                	li	a0,0
    800016d8:	a021                	j	800016e0 <copyout+0x74>
    800016da:	4501                	li	a0,0
}
    800016dc:	8082                	ret
      return -1;
    800016de:	557d                	li	a0,-1
}
    800016e0:	60a6                	ld	ra,72(sp)
    800016e2:	6406                	ld	s0,64(sp)
    800016e4:	74e2                	ld	s1,56(sp)
    800016e6:	7942                	ld	s2,48(sp)
    800016e8:	79a2                	ld	s3,40(sp)
    800016ea:	7a02                	ld	s4,32(sp)
    800016ec:	6ae2                	ld	s5,24(sp)
    800016ee:	6b42                	ld	s6,16(sp)
    800016f0:	6ba2                	ld	s7,8(sp)
    800016f2:	6c02                	ld	s8,0(sp)
    800016f4:	6161                	addi	sp,sp,80
    800016f6:	8082                	ret

00000000800016f8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016f8:	caa5                	beqz	a3,80001768 <copyin+0x70>
{
    800016fa:	715d                	addi	sp,sp,-80
    800016fc:	e486                	sd	ra,72(sp)
    800016fe:	e0a2                	sd	s0,64(sp)
    80001700:	fc26                	sd	s1,56(sp)
    80001702:	f84a                	sd	s2,48(sp)
    80001704:	f44e                	sd	s3,40(sp)
    80001706:	f052                	sd	s4,32(sp)
    80001708:	ec56                	sd	s5,24(sp)
    8000170a:	e85a                	sd	s6,16(sp)
    8000170c:	e45e                	sd	s7,8(sp)
    8000170e:	e062                	sd	s8,0(sp)
    80001710:	0880                	addi	s0,sp,80
    80001712:	8b2a                	mv	s6,a0
    80001714:	8a2e                	mv	s4,a1
    80001716:	8c32                	mv	s8,a2
    80001718:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000171a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000171c:	6a85                	lui	s5,0x1
    8000171e:	a01d                	j	80001744 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001720:	018505b3          	add	a1,a0,s8
    80001724:	0004861b          	sext.w	a2,s1
    80001728:	412585b3          	sub	a1,a1,s2
    8000172c:	8552                	mv	a0,s4
    8000172e:	fffff097          	auipc	ra,0xfffff
    80001732:	600080e7          	jalr	1536(ra) # 80000d2e <memmove>

    len -= n;
    80001736:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000173a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000173c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001740:	02098263          	beqz	s3,80001764 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001744:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001748:	85ca                	mv	a1,s2
    8000174a:	855a                	mv	a0,s6
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	910080e7          	jalr	-1776(ra) # 8000105c <walkaddr>
    if(pa0 == 0)
    80001754:	cd01                	beqz	a0,8000176c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001756:	418904b3          	sub	s1,s2,s8
    8000175a:	94d6                	add	s1,s1,s5
    8000175c:	fc99f2e3          	bgeu	s3,s1,80001720 <copyin+0x28>
    80001760:	84ce                	mv	s1,s3
    80001762:	bf7d                	j	80001720 <copyin+0x28>
  }
  return 0;
    80001764:	4501                	li	a0,0
    80001766:	a021                	j	8000176e <copyin+0x76>
    80001768:	4501                	li	a0,0
}
    8000176a:	8082                	ret
      return -1;
    8000176c:	557d                	li	a0,-1
}
    8000176e:	60a6                	ld	ra,72(sp)
    80001770:	6406                	ld	s0,64(sp)
    80001772:	74e2                	ld	s1,56(sp)
    80001774:	7942                	ld	s2,48(sp)
    80001776:	79a2                	ld	s3,40(sp)
    80001778:	7a02                	ld	s4,32(sp)
    8000177a:	6ae2                	ld	s5,24(sp)
    8000177c:	6b42                	ld	s6,16(sp)
    8000177e:	6ba2                	ld	s7,8(sp)
    80001780:	6c02                	ld	s8,0(sp)
    80001782:	6161                	addi	sp,sp,80
    80001784:	8082                	ret

0000000080001786 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001786:	c2dd                	beqz	a3,8000182c <copyinstr+0xa6>
{
    80001788:	715d                	addi	sp,sp,-80
    8000178a:	e486                	sd	ra,72(sp)
    8000178c:	e0a2                	sd	s0,64(sp)
    8000178e:	fc26                	sd	s1,56(sp)
    80001790:	f84a                	sd	s2,48(sp)
    80001792:	f44e                	sd	s3,40(sp)
    80001794:	f052                	sd	s4,32(sp)
    80001796:	ec56                	sd	s5,24(sp)
    80001798:	e85a                	sd	s6,16(sp)
    8000179a:	e45e                	sd	s7,8(sp)
    8000179c:	0880                	addi	s0,sp,80
    8000179e:	8a2a                	mv	s4,a0
    800017a0:	8b2e                	mv	s6,a1
    800017a2:	8bb2                	mv	s7,a2
    800017a4:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017a6:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017a8:	6985                	lui	s3,0x1
    800017aa:	a02d                	j	800017d4 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017ac:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017b0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017b2:	37fd                	addiw	a5,a5,-1
    800017b4:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017b8:	60a6                	ld	ra,72(sp)
    800017ba:	6406                	ld	s0,64(sp)
    800017bc:	74e2                	ld	s1,56(sp)
    800017be:	7942                	ld	s2,48(sp)
    800017c0:	79a2                	ld	s3,40(sp)
    800017c2:	7a02                	ld	s4,32(sp)
    800017c4:	6ae2                	ld	s5,24(sp)
    800017c6:	6b42                	ld	s6,16(sp)
    800017c8:	6ba2                	ld	s7,8(sp)
    800017ca:	6161                	addi	sp,sp,80
    800017cc:	8082                	ret
    srcva = va0 + PGSIZE;
    800017ce:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017d2:	c8a9                	beqz	s1,80001824 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    800017d4:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017d8:	85ca                	mv	a1,s2
    800017da:	8552                	mv	a0,s4
    800017dc:	00000097          	auipc	ra,0x0
    800017e0:	880080e7          	jalr	-1920(ra) # 8000105c <walkaddr>
    if(pa0 == 0)
    800017e4:	c131                	beqz	a0,80001828 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800017e6:	417906b3          	sub	a3,s2,s7
    800017ea:	96ce                	add	a3,a3,s3
    800017ec:	00d4f363          	bgeu	s1,a3,800017f2 <copyinstr+0x6c>
    800017f0:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017f2:	955e                	add	a0,a0,s7
    800017f4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017f8:	daf9                	beqz	a3,800017ce <copyinstr+0x48>
    800017fa:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017fc:	41650633          	sub	a2,a0,s6
    80001800:	fff48593          	addi	a1,s1,-1
    80001804:	95da                	add	a1,a1,s6
    while(n > 0){
    80001806:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80001808:	00f60733          	add	a4,a2,a5
    8000180c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd130>
    80001810:	df51                	beqz	a4,800017ac <copyinstr+0x26>
        *dst = *p;
    80001812:	00e78023          	sb	a4,0(a5)
      --max;
    80001816:	40f584b3          	sub	s1,a1,a5
      dst++;
    8000181a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000181c:	fed796e3          	bne	a5,a3,80001808 <copyinstr+0x82>
      dst++;
    80001820:	8b3e                	mv	s6,a5
    80001822:	b775                	j	800017ce <copyinstr+0x48>
    80001824:	4781                	li	a5,0
    80001826:	b771                	j	800017b2 <copyinstr+0x2c>
      return -1;
    80001828:	557d                	li	a0,-1
    8000182a:	b779                	j	800017b8 <copyinstr+0x32>
  int got_null = 0;
    8000182c:	4781                	li	a5,0
  if(got_null){
    8000182e:	37fd                	addiw	a5,a5,-1
    80001830:	0007851b          	sext.w	a0,a5
}
    80001834:	8082                	ret

0000000080001836 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001836:	7139                	addi	sp,sp,-64
    80001838:	fc06                	sd	ra,56(sp)
    8000183a:	f822                	sd	s0,48(sp)
    8000183c:	f426                	sd	s1,40(sp)
    8000183e:	f04a                	sd	s2,32(sp)
    80001840:	ec4e                	sd	s3,24(sp)
    80001842:	e852                	sd	s4,16(sp)
    80001844:	e456                	sd	s5,8(sp)
    80001846:	e05a                	sd	s6,0(sp)
    80001848:	0080                	addi	s0,sp,64
    8000184a:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000184c:	00010497          	auipc	s1,0x10
    80001850:	8a448493          	addi	s1,s1,-1884 # 800110f0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001854:	8b26                	mv	s6,s1
    80001856:	00006a97          	auipc	s5,0x6
    8000185a:	7aaa8a93          	addi	s5,s5,1962 # 80008000 <etext>
    8000185e:	04000937          	lui	s2,0x4000
    80001862:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001864:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001866:	00015a17          	auipc	s4,0x15
    8000186a:	28aa0a13          	addi	s4,s4,650 # 80016af0 <tickslock>
    char *pa = kalloc();
    8000186e:	fffff097          	auipc	ra,0xfffff
    80001872:	278080e7          	jalr	632(ra) # 80000ae6 <kalloc>
    80001876:	862a                	mv	a2,a0
    if(pa == 0)
    80001878:	c131                	beqz	a0,800018bc <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    8000187a:	416485b3          	sub	a1,s1,s6
    8000187e:	858d                	srai	a1,a1,0x3
    80001880:	000ab783          	ld	a5,0(s5)
    80001884:	02f585b3          	mul	a1,a1,a5
    80001888:	2585                	addiw	a1,a1,1
    8000188a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000188e:	4719                	li	a4,6
    80001890:	6685                	lui	a3,0x1
    80001892:	40b905b3          	sub	a1,s2,a1
    80001896:	854e                	mv	a0,s3
    80001898:	00000097          	auipc	ra,0x0
    8000189c:	8a6080e7          	jalr	-1882(ra) # 8000113e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a0:	16848493          	addi	s1,s1,360
    800018a4:	fd4495e3          	bne	s1,s4,8000186e <proc_mapstacks+0x38>
  }
}
    800018a8:	70e2                	ld	ra,56(sp)
    800018aa:	7442                	ld	s0,48(sp)
    800018ac:	74a2                	ld	s1,40(sp)
    800018ae:	7902                	ld	s2,32(sp)
    800018b0:	69e2                	ld	s3,24(sp)
    800018b2:	6a42                	ld	s4,16(sp)
    800018b4:	6aa2                	ld	s5,8(sp)
    800018b6:	6b02                	ld	s6,0(sp)
    800018b8:	6121                	addi	sp,sp,64
    800018ba:	8082                	ret
      panic("kalloc");
    800018bc:	00007517          	auipc	a0,0x7
    800018c0:	91c50513          	addi	a0,a0,-1764 # 800081d8 <digits+0x198>
    800018c4:	fffff097          	auipc	ra,0xfffff
    800018c8:	c7c080e7          	jalr	-900(ra) # 80000540 <panic>

00000000800018cc <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800018cc:	7139                	addi	sp,sp,-64
    800018ce:	fc06                	sd	ra,56(sp)
    800018d0:	f822                	sd	s0,48(sp)
    800018d2:	f426                	sd	s1,40(sp)
    800018d4:	f04a                	sd	s2,32(sp)
    800018d6:	ec4e                	sd	s3,24(sp)
    800018d8:	e852                	sd	s4,16(sp)
    800018da:	e456                	sd	s5,8(sp)
    800018dc:	e05a                	sd	s6,0(sp)
    800018de:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018e0:	00007597          	auipc	a1,0x7
    800018e4:	90058593          	addi	a1,a1,-1792 # 800081e0 <digits+0x1a0>
    800018e8:	0000f517          	auipc	a0,0xf
    800018ec:	3d850513          	addi	a0,a0,984 # 80010cc0 <pid_lock>
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	256080e7          	jalr	598(ra) # 80000b46 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018f8:	00007597          	auipc	a1,0x7
    800018fc:	8f058593          	addi	a1,a1,-1808 # 800081e8 <digits+0x1a8>
    80001900:	0000f517          	auipc	a0,0xf
    80001904:	3d850513          	addi	a0,a0,984 # 80010cd8 <wait_lock>
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	23e080e7          	jalr	574(ra) # 80000b46 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001910:	0000f497          	auipc	s1,0xf
    80001914:	7e048493          	addi	s1,s1,2016 # 800110f0 <proc>
      initlock(&p->lock, "proc");
    80001918:	00007b17          	auipc	s6,0x7
    8000191c:	8e0b0b13          	addi	s6,s6,-1824 # 800081f8 <digits+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001920:	8aa6                	mv	s5,s1
    80001922:	00006a17          	auipc	s4,0x6
    80001926:	6dea0a13          	addi	s4,s4,1758 # 80008000 <etext>
    8000192a:	04000937          	lui	s2,0x4000
    8000192e:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001930:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001932:	00015997          	auipc	s3,0x15
    80001936:	1be98993          	addi	s3,s3,446 # 80016af0 <tickslock>
      initlock(&p->lock, "proc");
    8000193a:	85da                	mv	a1,s6
    8000193c:	8526                	mv	a0,s1
    8000193e:	fffff097          	auipc	ra,0xfffff
    80001942:	208080e7          	jalr	520(ra) # 80000b46 <initlock>
      p->state = UNUSED;
    80001946:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000194a:	415487b3          	sub	a5,s1,s5
    8000194e:	878d                	srai	a5,a5,0x3
    80001950:	000a3703          	ld	a4,0(s4)
    80001954:	02e787b3          	mul	a5,a5,a4
    80001958:	2785                	addiw	a5,a5,1
    8000195a:	00d7979b          	slliw	a5,a5,0xd
    8000195e:	40f907b3          	sub	a5,s2,a5
    80001962:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001964:	16848493          	addi	s1,s1,360
    80001968:	fd3499e3          	bne	s1,s3,8000193a <procinit+0x6e>
  }
}
    8000196c:	70e2                	ld	ra,56(sp)
    8000196e:	7442                	ld	s0,48(sp)
    80001970:	74a2                	ld	s1,40(sp)
    80001972:	7902                	ld	s2,32(sp)
    80001974:	69e2                	ld	s3,24(sp)
    80001976:	6a42                	ld	s4,16(sp)
    80001978:	6aa2                	ld	s5,8(sp)
    8000197a:	6b02                	ld	s6,0(sp)
    8000197c:	6121                	addi	sp,sp,64
    8000197e:	8082                	ret

0000000080001980 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001980:	1141                	addi	sp,sp,-16
    80001982:	e422                	sd	s0,8(sp)
    80001984:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001986:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001988:	2501                	sext.w	a0,a0
    8000198a:	6422                	ld	s0,8(sp)
    8000198c:	0141                	addi	sp,sp,16
    8000198e:	8082                	ret

0000000080001990 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001990:	1141                	addi	sp,sp,-16
    80001992:	e422                	sd	s0,8(sp)
    80001994:	0800                	addi	s0,sp,16
    80001996:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001998:	2781                	sext.w	a5,a5
    8000199a:	079e                	slli	a5,a5,0x7
  return c;
}
    8000199c:	0000f517          	auipc	a0,0xf
    800019a0:	35450513          	addi	a0,a0,852 # 80010cf0 <cpus>
    800019a4:	953e                	add	a0,a0,a5
    800019a6:	6422                	ld	s0,8(sp)
    800019a8:	0141                	addi	sp,sp,16
    800019aa:	8082                	ret

00000000800019ac <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800019ac:	1101                	addi	sp,sp,-32
    800019ae:	ec06                	sd	ra,24(sp)
    800019b0:	e822                	sd	s0,16(sp)
    800019b2:	e426                	sd	s1,8(sp)
    800019b4:	1000                	addi	s0,sp,32
  push_off();
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	1d4080e7          	jalr	468(ra) # 80000b8a <push_off>
    800019be:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019c0:	2781                	sext.w	a5,a5
    800019c2:	079e                	slli	a5,a5,0x7
    800019c4:	0000f717          	auipc	a4,0xf
    800019c8:	2fc70713          	addi	a4,a4,764 # 80010cc0 <pid_lock>
    800019cc:	97ba                	add	a5,a5,a4
    800019ce:	7b84                	ld	s1,48(a5)
  pop_off();
    800019d0:	fffff097          	auipc	ra,0xfffff
    800019d4:	25a080e7          	jalr	602(ra) # 80000c2a <pop_off>
  return p;
}
    800019d8:	8526                	mv	a0,s1
    800019da:	60e2                	ld	ra,24(sp)
    800019dc:	6442                	ld	s0,16(sp)
    800019de:	64a2                	ld	s1,8(sp)
    800019e0:	6105                	addi	sp,sp,32
    800019e2:	8082                	ret

00000000800019e4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800019e4:	1141                	addi	sp,sp,-16
    800019e6:	e406                	sd	ra,8(sp)
    800019e8:	e022                	sd	s0,0(sp)
    800019ea:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800019ec:	00000097          	auipc	ra,0x0
    800019f0:	fc0080e7          	jalr	-64(ra) # 800019ac <myproc>
    800019f4:	fffff097          	auipc	ra,0xfffff
    800019f8:	296080e7          	jalr	662(ra) # 80000c8a <release>

  if (first) {
    800019fc:	00007797          	auipc	a5,0x7
    80001a00:	fb47a783          	lw	a5,-76(a5) # 800089b0 <first.1>
    80001a04:	eb89                	bnez	a5,80001a16 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a06:	00001097          	auipc	ra,0x1
    80001a0a:	c5c080e7          	jalr	-932(ra) # 80002662 <usertrapret>
}
    80001a0e:	60a2                	ld	ra,8(sp)
    80001a10:	6402                	ld	s0,0(sp)
    80001a12:	0141                	addi	sp,sp,16
    80001a14:	8082                	ret
    first = 0;
    80001a16:	00007797          	auipc	a5,0x7
    80001a1a:	f807ad23          	sw	zero,-102(a5) # 800089b0 <first.1>
    fsinit(ROOTDEV);
    80001a1e:	4505                	li	a0,1
    80001a20:	00002097          	auipc	ra,0x2
    80001a24:	c12080e7          	jalr	-1006(ra) # 80003632 <fsinit>
    80001a28:	bff9                	j	80001a06 <forkret+0x22>

0000000080001a2a <allocpid>:
{
    80001a2a:	1101                	addi	sp,sp,-32
    80001a2c:	ec06                	sd	ra,24(sp)
    80001a2e:	e822                	sd	s0,16(sp)
    80001a30:	e426                	sd	s1,8(sp)
    80001a32:	e04a                	sd	s2,0(sp)
    80001a34:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a36:	0000f917          	auipc	s2,0xf
    80001a3a:	28a90913          	addi	s2,s2,650 # 80010cc0 <pid_lock>
    80001a3e:	854a                	mv	a0,s2
    80001a40:	fffff097          	auipc	ra,0xfffff
    80001a44:	196080e7          	jalr	406(ra) # 80000bd6 <acquire>
  pid = nextpid;
    80001a48:	00007797          	auipc	a5,0x7
    80001a4c:	f6c78793          	addi	a5,a5,-148 # 800089b4 <nextpid>
    80001a50:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a52:	0014871b          	addiw	a4,s1,1
    80001a56:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a58:	854a                	mv	a0,s2
    80001a5a:	fffff097          	auipc	ra,0xfffff
    80001a5e:	230080e7          	jalr	560(ra) # 80000c8a <release>
}
    80001a62:	8526                	mv	a0,s1
    80001a64:	60e2                	ld	ra,24(sp)
    80001a66:	6442                	ld	s0,16(sp)
    80001a68:	64a2                	ld	s1,8(sp)
    80001a6a:	6902                	ld	s2,0(sp)
    80001a6c:	6105                	addi	sp,sp,32
    80001a6e:	8082                	ret

0000000080001a70 <proc_pagetable>:
{
    80001a70:	1101                	addi	sp,sp,-32
    80001a72:	ec06                	sd	ra,24(sp)
    80001a74:	e822                	sd	s0,16(sp)
    80001a76:	e426                	sd	s1,8(sp)
    80001a78:	e04a                	sd	s2,0(sp)
    80001a7a:	1000                	addi	s0,sp,32
    80001a7c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a7e:	00000097          	auipc	ra,0x0
    80001a82:	8aa080e7          	jalr	-1878(ra) # 80001328 <uvmcreate>
    80001a86:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a88:	c121                	beqz	a0,80001ac8 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a8a:	4729                	li	a4,10
    80001a8c:	00005697          	auipc	a3,0x5
    80001a90:	57468693          	addi	a3,a3,1396 # 80007000 <_trampoline>
    80001a94:	6605                	lui	a2,0x1
    80001a96:	040005b7          	lui	a1,0x4000
    80001a9a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a9c:	05b2                	slli	a1,a1,0xc
    80001a9e:	fffff097          	auipc	ra,0xfffff
    80001aa2:	600080e7          	jalr	1536(ra) # 8000109e <mappages>
    80001aa6:	02054863          	bltz	a0,80001ad6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001aaa:	4719                	li	a4,6
    80001aac:	05893683          	ld	a3,88(s2)
    80001ab0:	6605                	lui	a2,0x1
    80001ab2:	020005b7          	lui	a1,0x2000
    80001ab6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ab8:	05b6                	slli	a1,a1,0xd
    80001aba:	8526                	mv	a0,s1
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	5e2080e7          	jalr	1506(ra) # 8000109e <mappages>
    80001ac4:	02054163          	bltz	a0,80001ae6 <proc_pagetable+0x76>
}
    80001ac8:	8526                	mv	a0,s1
    80001aca:	60e2                	ld	ra,24(sp)
    80001acc:	6442                	ld	s0,16(sp)
    80001ace:	64a2                	ld	s1,8(sp)
    80001ad0:	6902                	ld	s2,0(sp)
    80001ad2:	6105                	addi	sp,sp,32
    80001ad4:	8082                	ret
    uvmfree(pagetable, 0);
    80001ad6:	4581                	li	a1,0
    80001ad8:	8526                	mv	a0,s1
    80001ada:	00000097          	auipc	ra,0x0
    80001ade:	a54080e7          	jalr	-1452(ra) # 8000152e <uvmfree>
    return 0;
    80001ae2:	4481                	li	s1,0
    80001ae4:	b7d5                	j	80001ac8 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ae6:	4681                	li	a3,0
    80001ae8:	4605                	li	a2,1
    80001aea:	040005b7          	lui	a1,0x4000
    80001aee:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001af0:	05b2                	slli	a1,a1,0xc
    80001af2:	8526                	mv	a0,s1
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	770080e7          	jalr	1904(ra) # 80001264 <uvmunmap>
    uvmfree(pagetable, 0);
    80001afc:	4581                	li	a1,0
    80001afe:	8526                	mv	a0,s1
    80001b00:	00000097          	auipc	ra,0x0
    80001b04:	a2e080e7          	jalr	-1490(ra) # 8000152e <uvmfree>
    return 0;
    80001b08:	4481                	li	s1,0
    80001b0a:	bf7d                	j	80001ac8 <proc_pagetable+0x58>

0000000080001b0c <proc_freepagetable>:
{
    80001b0c:	1101                	addi	sp,sp,-32
    80001b0e:	ec06                	sd	ra,24(sp)
    80001b10:	e822                	sd	s0,16(sp)
    80001b12:	e426                	sd	s1,8(sp)
    80001b14:	e04a                	sd	s2,0(sp)
    80001b16:	1000                	addi	s0,sp,32
    80001b18:	84aa                	mv	s1,a0
    80001b1a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b1c:	4681                	li	a3,0
    80001b1e:	4605                	li	a2,1
    80001b20:	040005b7          	lui	a1,0x4000
    80001b24:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b26:	05b2                	slli	a1,a1,0xc
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	73c080e7          	jalr	1852(ra) # 80001264 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b30:	4681                	li	a3,0
    80001b32:	4605                	li	a2,1
    80001b34:	020005b7          	lui	a1,0x2000
    80001b38:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b3a:	05b6                	slli	a1,a1,0xd
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	fffff097          	auipc	ra,0xfffff
    80001b42:	726080e7          	jalr	1830(ra) # 80001264 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b46:	85ca                	mv	a1,s2
    80001b48:	8526                	mv	a0,s1
    80001b4a:	00000097          	auipc	ra,0x0
    80001b4e:	9e4080e7          	jalr	-1564(ra) # 8000152e <uvmfree>
}
    80001b52:	60e2                	ld	ra,24(sp)
    80001b54:	6442                	ld	s0,16(sp)
    80001b56:	64a2                	ld	s1,8(sp)
    80001b58:	6902                	ld	s2,0(sp)
    80001b5a:	6105                	addi	sp,sp,32
    80001b5c:	8082                	ret

0000000080001b5e <freeproc>:
{
    80001b5e:	1101                	addi	sp,sp,-32
    80001b60:	ec06                	sd	ra,24(sp)
    80001b62:	e822                	sd	s0,16(sp)
    80001b64:	e426                	sd	s1,8(sp)
    80001b66:	1000                	addi	s0,sp,32
    80001b68:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b6a:	6d28                	ld	a0,88(a0)
    80001b6c:	c509                	beqz	a0,80001b76 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b6e:	fffff097          	auipc	ra,0xfffff
    80001b72:	e7a080e7          	jalr	-390(ra) # 800009e8 <kfree>
  p->trapframe = 0;
    80001b76:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b7a:	68a8                	ld	a0,80(s1)
    80001b7c:	c511                	beqz	a0,80001b88 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b7e:	64ac                	ld	a1,72(s1)
    80001b80:	00000097          	auipc	ra,0x0
    80001b84:	f8c080e7          	jalr	-116(ra) # 80001b0c <proc_freepagetable>
  p->pagetable = 0;
    80001b88:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b8c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b90:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b94:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b98:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b9c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001ba0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001ba4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ba8:	0004ac23          	sw	zero,24(s1)
}
    80001bac:	60e2                	ld	ra,24(sp)
    80001bae:	6442                	ld	s0,16(sp)
    80001bb0:	64a2                	ld	s1,8(sp)
    80001bb2:	6105                	addi	sp,sp,32
    80001bb4:	8082                	ret

0000000080001bb6 <allocproc>:
{
    80001bb6:	1101                	addi	sp,sp,-32
    80001bb8:	ec06                	sd	ra,24(sp)
    80001bba:	e822                	sd	s0,16(sp)
    80001bbc:	e426                	sd	s1,8(sp)
    80001bbe:	e04a                	sd	s2,0(sp)
    80001bc0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bc2:	0000f497          	auipc	s1,0xf
    80001bc6:	52e48493          	addi	s1,s1,1326 # 800110f0 <proc>
    80001bca:	00015917          	auipc	s2,0x15
    80001bce:	f2690913          	addi	s2,s2,-218 # 80016af0 <tickslock>
    acquire(&p->lock);
    80001bd2:	8526                	mv	a0,s1
    80001bd4:	fffff097          	auipc	ra,0xfffff
    80001bd8:	002080e7          	jalr	2(ra) # 80000bd6 <acquire>
    if(p->state == UNUSED) {
    80001bdc:	4c9c                	lw	a5,24(s1)
    80001bde:	cf81                	beqz	a5,80001bf6 <allocproc+0x40>
      release(&p->lock);
    80001be0:	8526                	mv	a0,s1
    80001be2:	fffff097          	auipc	ra,0xfffff
    80001be6:	0a8080e7          	jalr	168(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bea:	16848493          	addi	s1,s1,360
    80001bee:	ff2492e3          	bne	s1,s2,80001bd2 <allocproc+0x1c>
  return 0;
    80001bf2:	4481                	li	s1,0
    80001bf4:	a889                	j	80001c46 <allocproc+0x90>
  p->pid = allocpid();
    80001bf6:	00000097          	auipc	ra,0x0
    80001bfa:	e34080e7          	jalr	-460(ra) # 80001a2a <allocpid>
    80001bfe:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c00:	4785                	li	a5,1
    80001c02:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c04:	fffff097          	auipc	ra,0xfffff
    80001c08:	ee2080e7          	jalr	-286(ra) # 80000ae6 <kalloc>
    80001c0c:	892a                	mv	s2,a0
    80001c0e:	eca8                	sd	a0,88(s1)
    80001c10:	c131                	beqz	a0,80001c54 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001c12:	8526                	mv	a0,s1
    80001c14:	00000097          	auipc	ra,0x0
    80001c18:	e5c080e7          	jalr	-420(ra) # 80001a70 <proc_pagetable>
    80001c1c:	892a                	mv	s2,a0
    80001c1e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c20:	c531                	beqz	a0,80001c6c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001c22:	07000613          	li	a2,112
    80001c26:	4581                	li	a1,0
    80001c28:	06048513          	addi	a0,s1,96
    80001c2c:	fffff097          	auipc	ra,0xfffff
    80001c30:	0a6080e7          	jalr	166(ra) # 80000cd2 <memset>
  p->context.ra = (uint64)forkret;
    80001c34:	00000797          	auipc	a5,0x0
    80001c38:	db078793          	addi	a5,a5,-592 # 800019e4 <forkret>
    80001c3c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c3e:	60bc                	ld	a5,64(s1)
    80001c40:	6705                	lui	a4,0x1
    80001c42:	97ba                	add	a5,a5,a4
    80001c44:	f4bc                	sd	a5,104(s1)
}
    80001c46:	8526                	mv	a0,s1
    80001c48:	60e2                	ld	ra,24(sp)
    80001c4a:	6442                	ld	s0,16(sp)
    80001c4c:	64a2                	ld	s1,8(sp)
    80001c4e:	6902                	ld	s2,0(sp)
    80001c50:	6105                	addi	sp,sp,32
    80001c52:	8082                	ret
    freeproc(p);
    80001c54:	8526                	mv	a0,s1
    80001c56:	00000097          	auipc	ra,0x0
    80001c5a:	f08080e7          	jalr	-248(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001c5e:	8526                	mv	a0,s1
    80001c60:	fffff097          	auipc	ra,0xfffff
    80001c64:	02a080e7          	jalr	42(ra) # 80000c8a <release>
    return 0;
    80001c68:	84ca                	mv	s1,s2
    80001c6a:	bff1                	j	80001c46 <allocproc+0x90>
    freeproc(p);
    80001c6c:	8526                	mv	a0,s1
    80001c6e:	00000097          	auipc	ra,0x0
    80001c72:	ef0080e7          	jalr	-272(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001c76:	8526                	mv	a0,s1
    80001c78:	fffff097          	auipc	ra,0xfffff
    80001c7c:	012080e7          	jalr	18(ra) # 80000c8a <release>
    return 0;
    80001c80:	84ca                	mv	s1,s2
    80001c82:	b7d1                	j	80001c46 <allocproc+0x90>

0000000080001c84 <userinit>:
{
    80001c84:	1101                	addi	sp,sp,-32
    80001c86:	ec06                	sd	ra,24(sp)
    80001c88:	e822                	sd	s0,16(sp)
    80001c8a:	e426                	sd	s1,8(sp)
    80001c8c:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c8e:	00000097          	auipc	ra,0x0
    80001c92:	f28080e7          	jalr	-216(ra) # 80001bb6 <allocproc>
    80001c96:	84aa                	mv	s1,a0
  initproc = p;
    80001c98:	00007797          	auipc	a5,0x7
    80001c9c:	daa7b823          	sd	a0,-592(a5) # 80008a48 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001ca0:	03400613          	li	a2,52
    80001ca4:	00007597          	auipc	a1,0x7
    80001ca8:	d1c58593          	addi	a1,a1,-740 # 800089c0 <initcode>
    80001cac:	6928                	ld	a0,80(a0)
    80001cae:	fffff097          	auipc	ra,0xfffff
    80001cb2:	6a8080e7          	jalr	1704(ra) # 80001356 <uvmfirst>
  p->sz = PGSIZE;
    80001cb6:	6785                	lui	a5,0x1
    80001cb8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cba:	6cb8                	ld	a4,88(s1)
    80001cbc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001cc0:	6cb8                	ld	a4,88(s1)
    80001cc2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cc4:	4641                	li	a2,16
    80001cc6:	00006597          	auipc	a1,0x6
    80001cca:	53a58593          	addi	a1,a1,1338 # 80008200 <digits+0x1c0>
    80001cce:	15848513          	addi	a0,s1,344
    80001cd2:	fffff097          	auipc	ra,0xfffff
    80001cd6:	14a080e7          	jalr	330(ra) # 80000e1c <safestrcpy>
  p->cwd = namei("/");
    80001cda:	00006517          	auipc	a0,0x6
    80001cde:	53650513          	addi	a0,a0,1334 # 80008210 <digits+0x1d0>
    80001ce2:	00002097          	auipc	ra,0x2
    80001ce6:	37a080e7          	jalr	890(ra) # 8000405c <namei>
    80001cea:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cee:	478d                	li	a5,3
    80001cf0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	fffff097          	auipc	ra,0xfffff
    80001cf8:	f96080e7          	jalr	-106(ra) # 80000c8a <release>
}
    80001cfc:	60e2                	ld	ra,24(sp)
    80001cfe:	6442                	ld	s0,16(sp)
    80001d00:	64a2                	ld	s1,8(sp)
    80001d02:	6105                	addi	sp,sp,32
    80001d04:	8082                	ret

0000000080001d06 <growproc>:
{
    80001d06:	1101                	addi	sp,sp,-32
    80001d08:	ec06                	sd	ra,24(sp)
    80001d0a:	e822                	sd	s0,16(sp)
    80001d0c:	e426                	sd	s1,8(sp)
    80001d0e:	e04a                	sd	s2,0(sp)
    80001d10:	1000                	addi	s0,sp,32
    80001d12:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	c98080e7          	jalr	-872(ra) # 800019ac <myproc>
    80001d1c:	84aa                	mv	s1,a0
  sz = p->sz;
    80001d1e:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001d20:	01204c63          	bgtz	s2,80001d38 <growproc+0x32>
  } else if(n < 0){
    80001d24:	02094663          	bltz	s2,80001d50 <growproc+0x4a>
  p->sz = sz;
    80001d28:	e4ac                	sd	a1,72(s1)
  return 0;
    80001d2a:	4501                	li	a0,0
}
    80001d2c:	60e2                	ld	ra,24(sp)
    80001d2e:	6442                	ld	s0,16(sp)
    80001d30:	64a2                	ld	s1,8(sp)
    80001d32:	6902                	ld	s2,0(sp)
    80001d34:	6105                	addi	sp,sp,32
    80001d36:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d38:	4691                	li	a3,4
    80001d3a:	00b90633          	add	a2,s2,a1
    80001d3e:	6928                	ld	a0,80(a0)
    80001d40:	fffff097          	auipc	ra,0xfffff
    80001d44:	6d0080e7          	jalr	1744(ra) # 80001410 <uvmalloc>
    80001d48:	85aa                	mv	a1,a0
    80001d4a:	fd79                	bnez	a0,80001d28 <growproc+0x22>
      return -1;
    80001d4c:	557d                	li	a0,-1
    80001d4e:	bff9                	j	80001d2c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d50:	00b90633          	add	a2,s2,a1
    80001d54:	6928                	ld	a0,80(a0)
    80001d56:	fffff097          	auipc	ra,0xfffff
    80001d5a:	672080e7          	jalr	1650(ra) # 800013c8 <uvmdealloc>
    80001d5e:	85aa                	mv	a1,a0
    80001d60:	b7e1                	j	80001d28 <growproc+0x22>

0000000080001d62 <fork>:
{
    80001d62:	7139                	addi	sp,sp,-64
    80001d64:	fc06                	sd	ra,56(sp)
    80001d66:	f822                	sd	s0,48(sp)
    80001d68:	f426                	sd	s1,40(sp)
    80001d6a:	f04a                	sd	s2,32(sp)
    80001d6c:	ec4e                	sd	s3,24(sp)
    80001d6e:	e852                	sd	s4,16(sp)
    80001d70:	e456                	sd	s5,8(sp)
    80001d72:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d74:	00000097          	auipc	ra,0x0
    80001d78:	c38080e7          	jalr	-968(ra) # 800019ac <myproc>
    80001d7c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d7e:	00000097          	auipc	ra,0x0
    80001d82:	e38080e7          	jalr	-456(ra) # 80001bb6 <allocproc>
    80001d86:	10050c63          	beqz	a0,80001e9e <fork+0x13c>
    80001d8a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d8c:	048ab603          	ld	a2,72(s5)
    80001d90:	692c                	ld	a1,80(a0)
    80001d92:	050ab503          	ld	a0,80(s5)
    80001d96:	fffff097          	auipc	ra,0xfffff
    80001d9a:	7d2080e7          	jalr	2002(ra) # 80001568 <uvmcopy>
    80001d9e:	04054863          	bltz	a0,80001dee <fork+0x8c>
  np->sz = p->sz;
    80001da2:	048ab783          	ld	a5,72(s5)
    80001da6:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001daa:	058ab683          	ld	a3,88(s5)
    80001dae:	87b6                	mv	a5,a3
    80001db0:	058a3703          	ld	a4,88(s4)
    80001db4:	12068693          	addi	a3,a3,288
    80001db8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dbc:	6788                	ld	a0,8(a5)
    80001dbe:	6b8c                	ld	a1,16(a5)
    80001dc0:	6f90                	ld	a2,24(a5)
    80001dc2:	01073023          	sd	a6,0(a4)
    80001dc6:	e708                	sd	a0,8(a4)
    80001dc8:	eb0c                	sd	a1,16(a4)
    80001dca:	ef10                	sd	a2,24(a4)
    80001dcc:	02078793          	addi	a5,a5,32
    80001dd0:	02070713          	addi	a4,a4,32
    80001dd4:	fed792e3          	bne	a5,a3,80001db8 <fork+0x56>
  np->trapframe->a0 = 0;
    80001dd8:	058a3783          	ld	a5,88(s4)
    80001ddc:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001de0:	0d0a8493          	addi	s1,s5,208
    80001de4:	0d0a0913          	addi	s2,s4,208
    80001de8:	150a8993          	addi	s3,s5,336
    80001dec:	a00d                	j	80001e0e <fork+0xac>
    freeproc(np);
    80001dee:	8552                	mv	a0,s4
    80001df0:	00000097          	auipc	ra,0x0
    80001df4:	d6e080e7          	jalr	-658(ra) # 80001b5e <freeproc>
    release(&np->lock);
    80001df8:	8552                	mv	a0,s4
    80001dfa:	fffff097          	auipc	ra,0xfffff
    80001dfe:	e90080e7          	jalr	-368(ra) # 80000c8a <release>
    return -1;
    80001e02:	597d                	li	s2,-1
    80001e04:	a059                	j	80001e8a <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001e06:	04a1                	addi	s1,s1,8
    80001e08:	0921                	addi	s2,s2,8
    80001e0a:	01348b63          	beq	s1,s3,80001e20 <fork+0xbe>
    if(p->ofile[i])
    80001e0e:	6088                	ld	a0,0(s1)
    80001e10:	d97d                	beqz	a0,80001e06 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e12:	00003097          	auipc	ra,0x3
    80001e16:	8e0080e7          	jalr	-1824(ra) # 800046f2 <filedup>
    80001e1a:	00a93023          	sd	a0,0(s2)
    80001e1e:	b7e5                	j	80001e06 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e20:	150ab503          	ld	a0,336(s5)
    80001e24:	00002097          	auipc	ra,0x2
    80001e28:	a4e080e7          	jalr	-1458(ra) # 80003872 <idup>
    80001e2c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e30:	4641                	li	a2,16
    80001e32:	158a8593          	addi	a1,s5,344
    80001e36:	158a0513          	addi	a0,s4,344
    80001e3a:	fffff097          	auipc	ra,0xfffff
    80001e3e:	fe2080e7          	jalr	-30(ra) # 80000e1c <safestrcpy>
  pid = np->pid;
    80001e42:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001e46:	8552                	mv	a0,s4
    80001e48:	fffff097          	auipc	ra,0xfffff
    80001e4c:	e42080e7          	jalr	-446(ra) # 80000c8a <release>
  acquire(&wait_lock);
    80001e50:	0000f497          	auipc	s1,0xf
    80001e54:	e8848493          	addi	s1,s1,-376 # 80010cd8 <wait_lock>
    80001e58:	8526                	mv	a0,s1
    80001e5a:	fffff097          	auipc	ra,0xfffff
    80001e5e:	d7c080e7          	jalr	-644(ra) # 80000bd6 <acquire>
  np->parent = p;
    80001e62:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001e66:	8526                	mv	a0,s1
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	e22080e7          	jalr	-478(ra) # 80000c8a <release>
  acquire(&np->lock);
    80001e70:	8552                	mv	a0,s4
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	d64080e7          	jalr	-668(ra) # 80000bd6 <acquire>
  np->state = RUNNABLE;
    80001e7a:	478d                	li	a5,3
    80001e7c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e80:	8552                	mv	a0,s4
    80001e82:	fffff097          	auipc	ra,0xfffff
    80001e86:	e08080e7          	jalr	-504(ra) # 80000c8a <release>
}
    80001e8a:	854a                	mv	a0,s2
    80001e8c:	70e2                	ld	ra,56(sp)
    80001e8e:	7442                	ld	s0,48(sp)
    80001e90:	74a2                	ld	s1,40(sp)
    80001e92:	7902                	ld	s2,32(sp)
    80001e94:	69e2                	ld	s3,24(sp)
    80001e96:	6a42                	ld	s4,16(sp)
    80001e98:	6aa2                	ld	s5,8(sp)
    80001e9a:	6121                	addi	sp,sp,64
    80001e9c:	8082                	ret
    return -1;
    80001e9e:	597d                	li	s2,-1
    80001ea0:	b7ed                	j	80001e8a <fork+0x128>

0000000080001ea2 <scheduler>:
{
    80001ea2:	7139                	addi	sp,sp,-64
    80001ea4:	fc06                	sd	ra,56(sp)
    80001ea6:	f822                	sd	s0,48(sp)
    80001ea8:	f426                	sd	s1,40(sp)
    80001eaa:	f04a                	sd	s2,32(sp)
    80001eac:	ec4e                	sd	s3,24(sp)
    80001eae:	e852                	sd	s4,16(sp)
    80001eb0:	e456                	sd	s5,8(sp)
    80001eb2:	e05a                	sd	s6,0(sp)
    80001eb4:	0080                	addi	s0,sp,64
    80001eb6:	8792                	mv	a5,tp
  int id = r_tp();
    80001eb8:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001eba:	00779a93          	slli	s5,a5,0x7
    80001ebe:	0000f717          	auipc	a4,0xf
    80001ec2:	e0270713          	addi	a4,a4,-510 # 80010cc0 <pid_lock>
    80001ec6:	9756                	add	a4,a4,s5
    80001ec8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001ecc:	0000f717          	auipc	a4,0xf
    80001ed0:	e2c70713          	addi	a4,a4,-468 # 80010cf8 <cpus+0x8>
    80001ed4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001ed6:	498d                	li	s3,3
        p->state = RUNNING;
    80001ed8:	4b11                	li	s6,4
        c->proc = p;
    80001eda:	079e                	slli	a5,a5,0x7
    80001edc:	0000fa17          	auipc	s4,0xf
    80001ee0:	de4a0a13          	addi	s4,s4,-540 # 80010cc0 <pid_lock>
    80001ee4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ee6:	00015917          	auipc	s2,0x15
    80001eea:	c0a90913          	addi	s2,s2,-1014 # 80016af0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ef2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ef6:	10079073          	csrw	sstatus,a5
    80001efa:	0000f497          	auipc	s1,0xf
    80001efe:	1f648493          	addi	s1,s1,502 # 800110f0 <proc>
    80001f02:	a811                	j	80001f16 <scheduler+0x74>
      release(&p->lock);
    80001f04:	8526                	mv	a0,s1
    80001f06:	fffff097          	auipc	ra,0xfffff
    80001f0a:	d84080e7          	jalr	-636(ra) # 80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f0e:	16848493          	addi	s1,s1,360
    80001f12:	fd248ee3          	beq	s1,s2,80001eee <scheduler+0x4c>
      acquire(&p->lock);
    80001f16:	8526                	mv	a0,s1
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	cbe080e7          	jalr	-834(ra) # 80000bd6 <acquire>
      if(p->state == RUNNABLE) {
    80001f20:	4c9c                	lw	a5,24(s1)
    80001f22:	ff3791e3          	bne	a5,s3,80001f04 <scheduler+0x62>
        p->state = RUNNING;
    80001f26:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001f2a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001f2e:	06048593          	addi	a1,s1,96
    80001f32:	8556                	mv	a0,s5
    80001f34:	00000097          	auipc	ra,0x0
    80001f38:	684080e7          	jalr	1668(ra) # 800025b8 <swtch>
        c->proc = 0;
    80001f3c:	020a3823          	sd	zero,48(s4)
    80001f40:	b7d1                	j	80001f04 <scheduler+0x62>

0000000080001f42 <sched>:
{
    80001f42:	7179                	addi	sp,sp,-48
    80001f44:	f406                	sd	ra,40(sp)
    80001f46:	f022                	sd	s0,32(sp)
    80001f48:	ec26                	sd	s1,24(sp)
    80001f4a:	e84a                	sd	s2,16(sp)
    80001f4c:	e44e                	sd	s3,8(sp)
    80001f4e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	a5c080e7          	jalr	-1444(ra) # 800019ac <myproc>
    80001f58:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f5a:	fffff097          	auipc	ra,0xfffff
    80001f5e:	c02080e7          	jalr	-1022(ra) # 80000b5c <holding>
    80001f62:	c93d                	beqz	a0,80001fd8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f64:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f66:	2781                	sext.w	a5,a5
    80001f68:	079e                	slli	a5,a5,0x7
    80001f6a:	0000f717          	auipc	a4,0xf
    80001f6e:	d5670713          	addi	a4,a4,-682 # 80010cc0 <pid_lock>
    80001f72:	97ba                	add	a5,a5,a4
    80001f74:	0a87a703          	lw	a4,168(a5)
    80001f78:	4785                	li	a5,1
    80001f7a:	06f71763          	bne	a4,a5,80001fe8 <sched+0xa6>
  if(p->state == RUNNING)
    80001f7e:	4c98                	lw	a4,24(s1)
    80001f80:	4791                	li	a5,4
    80001f82:	06f70b63          	beq	a4,a5,80001ff8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f86:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f8a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001f8c:	efb5                	bnez	a5,80002008 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f8e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f90:	0000f917          	auipc	s2,0xf
    80001f94:	d3090913          	addi	s2,s2,-720 # 80010cc0 <pid_lock>
    80001f98:	2781                	sext.w	a5,a5
    80001f9a:	079e                	slli	a5,a5,0x7
    80001f9c:	97ca                	add	a5,a5,s2
    80001f9e:	0ac7a983          	lw	s3,172(a5)
    80001fa2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001fa4:	2781                	sext.w	a5,a5
    80001fa6:	079e                	slli	a5,a5,0x7
    80001fa8:	0000f597          	auipc	a1,0xf
    80001fac:	d5058593          	addi	a1,a1,-688 # 80010cf8 <cpus+0x8>
    80001fb0:	95be                	add	a1,a1,a5
    80001fb2:	06048513          	addi	a0,s1,96
    80001fb6:	00000097          	auipc	ra,0x0
    80001fba:	602080e7          	jalr	1538(ra) # 800025b8 <swtch>
    80001fbe:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001fc0:	2781                	sext.w	a5,a5
    80001fc2:	079e                	slli	a5,a5,0x7
    80001fc4:	993e                	add	s2,s2,a5
    80001fc6:	0b392623          	sw	s3,172(s2)
}
    80001fca:	70a2                	ld	ra,40(sp)
    80001fcc:	7402                	ld	s0,32(sp)
    80001fce:	64e2                	ld	s1,24(sp)
    80001fd0:	6942                	ld	s2,16(sp)
    80001fd2:	69a2                	ld	s3,8(sp)
    80001fd4:	6145                	addi	sp,sp,48
    80001fd6:	8082                	ret
    panic("sched p->lock");
    80001fd8:	00006517          	auipc	a0,0x6
    80001fdc:	24050513          	addi	a0,a0,576 # 80008218 <digits+0x1d8>
    80001fe0:	ffffe097          	auipc	ra,0xffffe
    80001fe4:	560080e7          	jalr	1376(ra) # 80000540 <panic>
    panic("sched locks");
    80001fe8:	00006517          	auipc	a0,0x6
    80001fec:	24050513          	addi	a0,a0,576 # 80008228 <digits+0x1e8>
    80001ff0:	ffffe097          	auipc	ra,0xffffe
    80001ff4:	550080e7          	jalr	1360(ra) # 80000540 <panic>
    panic("sched running");
    80001ff8:	00006517          	auipc	a0,0x6
    80001ffc:	24050513          	addi	a0,a0,576 # 80008238 <digits+0x1f8>
    80002000:	ffffe097          	auipc	ra,0xffffe
    80002004:	540080e7          	jalr	1344(ra) # 80000540 <panic>
    panic("sched interruptible");
    80002008:	00006517          	auipc	a0,0x6
    8000200c:	24050513          	addi	a0,a0,576 # 80008248 <digits+0x208>
    80002010:	ffffe097          	auipc	ra,0xffffe
    80002014:	530080e7          	jalr	1328(ra) # 80000540 <panic>

0000000080002018 <yield>:
{
    80002018:	1101                	addi	sp,sp,-32
    8000201a:	ec06                	sd	ra,24(sp)
    8000201c:	e822                	sd	s0,16(sp)
    8000201e:	e426                	sd	s1,8(sp)
    80002020:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002022:	00000097          	auipc	ra,0x0
    80002026:	98a080e7          	jalr	-1654(ra) # 800019ac <myproc>
    8000202a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000202c:	fffff097          	auipc	ra,0xfffff
    80002030:	baa080e7          	jalr	-1110(ra) # 80000bd6 <acquire>
  p->state = RUNNABLE;
    80002034:	478d                	li	a5,3
    80002036:	cc9c                	sw	a5,24(s1)
  sched();
    80002038:	00000097          	auipc	ra,0x0
    8000203c:	f0a080e7          	jalr	-246(ra) # 80001f42 <sched>
  release(&p->lock);
    80002040:	8526                	mv	a0,s1
    80002042:	fffff097          	auipc	ra,0xfffff
    80002046:	c48080e7          	jalr	-952(ra) # 80000c8a <release>
}
    8000204a:	60e2                	ld	ra,24(sp)
    8000204c:	6442                	ld	s0,16(sp)
    8000204e:	64a2                	ld	s1,8(sp)
    80002050:	6105                	addi	sp,sp,32
    80002052:	8082                	ret

0000000080002054 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002054:	7179                	addi	sp,sp,-48
    80002056:	f406                	sd	ra,40(sp)
    80002058:	f022                	sd	s0,32(sp)
    8000205a:	ec26                	sd	s1,24(sp)
    8000205c:	e84a                	sd	s2,16(sp)
    8000205e:	e44e                	sd	s3,8(sp)
    80002060:	1800                	addi	s0,sp,48
    80002062:	89aa                	mv	s3,a0
    80002064:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002066:	00000097          	auipc	ra,0x0
    8000206a:	946080e7          	jalr	-1722(ra) # 800019ac <myproc>
    8000206e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	b66080e7          	jalr	-1178(ra) # 80000bd6 <acquire>
  release(lk);
    80002078:	854a                	mv	a0,s2
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	c10080e7          	jalr	-1008(ra) # 80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    80002082:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002086:	4789                	li	a5,2
    80002088:	cc9c                	sw	a5,24(s1)

  sched();
    8000208a:	00000097          	auipc	ra,0x0
    8000208e:	eb8080e7          	jalr	-328(ra) # 80001f42 <sched>

  // Tidy up.
  p->chan = 0;
    80002092:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002096:	8526                	mv	a0,s1
    80002098:	fffff097          	auipc	ra,0xfffff
    8000209c:	bf2080e7          	jalr	-1038(ra) # 80000c8a <release>
  acquire(lk);
    800020a0:	854a                	mv	a0,s2
    800020a2:	fffff097          	auipc	ra,0xfffff
    800020a6:	b34080e7          	jalr	-1228(ra) # 80000bd6 <acquire>
}
    800020aa:	70a2                	ld	ra,40(sp)
    800020ac:	7402                	ld	s0,32(sp)
    800020ae:	64e2                	ld	s1,24(sp)
    800020b0:	6942                	ld	s2,16(sp)
    800020b2:	69a2                	ld	s3,8(sp)
    800020b4:	6145                	addi	sp,sp,48
    800020b6:	8082                	ret

00000000800020b8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800020b8:	7139                	addi	sp,sp,-64
    800020ba:	fc06                	sd	ra,56(sp)
    800020bc:	f822                	sd	s0,48(sp)
    800020be:	f426                	sd	s1,40(sp)
    800020c0:	f04a                	sd	s2,32(sp)
    800020c2:	ec4e                	sd	s3,24(sp)
    800020c4:	e852                	sd	s4,16(sp)
    800020c6:	e456                	sd	s5,8(sp)
    800020c8:	0080                	addi	s0,sp,64
    800020ca:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800020cc:	0000f497          	auipc	s1,0xf
    800020d0:	02448493          	addi	s1,s1,36 # 800110f0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800020d4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800020d6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800020d8:	00015917          	auipc	s2,0x15
    800020dc:	a1890913          	addi	s2,s2,-1512 # 80016af0 <tickslock>
    800020e0:	a811                	j	800020f4 <wakeup+0x3c>
      }
      release(&p->lock);
    800020e2:	8526                	mv	a0,s1
    800020e4:	fffff097          	auipc	ra,0xfffff
    800020e8:	ba6080e7          	jalr	-1114(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800020ec:	16848493          	addi	s1,s1,360
    800020f0:	03248663          	beq	s1,s2,8000211c <wakeup+0x64>
    if(p != myproc()){
    800020f4:	00000097          	auipc	ra,0x0
    800020f8:	8b8080e7          	jalr	-1864(ra) # 800019ac <myproc>
    800020fc:	fea488e3          	beq	s1,a0,800020ec <wakeup+0x34>
      acquire(&p->lock);
    80002100:	8526                	mv	a0,s1
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	ad4080e7          	jalr	-1324(ra) # 80000bd6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000210a:	4c9c                	lw	a5,24(s1)
    8000210c:	fd379be3          	bne	a5,s3,800020e2 <wakeup+0x2a>
    80002110:	709c                	ld	a5,32(s1)
    80002112:	fd4798e3          	bne	a5,s4,800020e2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002116:	0154ac23          	sw	s5,24(s1)
    8000211a:	b7e1                	j	800020e2 <wakeup+0x2a>
    }
  }
}
    8000211c:	70e2                	ld	ra,56(sp)
    8000211e:	7442                	ld	s0,48(sp)
    80002120:	74a2                	ld	s1,40(sp)
    80002122:	7902                	ld	s2,32(sp)
    80002124:	69e2                	ld	s3,24(sp)
    80002126:	6a42                	ld	s4,16(sp)
    80002128:	6aa2                	ld	s5,8(sp)
    8000212a:	6121                	addi	sp,sp,64
    8000212c:	8082                	ret

000000008000212e <reparent>:
{
    8000212e:	7179                	addi	sp,sp,-48
    80002130:	f406                	sd	ra,40(sp)
    80002132:	f022                	sd	s0,32(sp)
    80002134:	ec26                	sd	s1,24(sp)
    80002136:	e84a                	sd	s2,16(sp)
    80002138:	e44e                	sd	s3,8(sp)
    8000213a:	e052                	sd	s4,0(sp)
    8000213c:	1800                	addi	s0,sp,48
    8000213e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002140:	0000f497          	auipc	s1,0xf
    80002144:	fb048493          	addi	s1,s1,-80 # 800110f0 <proc>
      pp->parent = initproc;
    80002148:	00007a17          	auipc	s4,0x7
    8000214c:	900a0a13          	addi	s4,s4,-1792 # 80008a48 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002150:	00015997          	auipc	s3,0x15
    80002154:	9a098993          	addi	s3,s3,-1632 # 80016af0 <tickslock>
    80002158:	a029                	j	80002162 <reparent+0x34>
    8000215a:	16848493          	addi	s1,s1,360
    8000215e:	01348d63          	beq	s1,s3,80002178 <reparent+0x4a>
    if(pp->parent == p){
    80002162:	7c9c                	ld	a5,56(s1)
    80002164:	ff279be3          	bne	a5,s2,8000215a <reparent+0x2c>
      pp->parent = initproc;
    80002168:	000a3503          	ld	a0,0(s4)
    8000216c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000216e:	00000097          	auipc	ra,0x0
    80002172:	f4a080e7          	jalr	-182(ra) # 800020b8 <wakeup>
    80002176:	b7d5                	j	8000215a <reparent+0x2c>
}
    80002178:	70a2                	ld	ra,40(sp)
    8000217a:	7402                	ld	s0,32(sp)
    8000217c:	64e2                	ld	s1,24(sp)
    8000217e:	6942                	ld	s2,16(sp)
    80002180:	69a2                	ld	s3,8(sp)
    80002182:	6a02                	ld	s4,0(sp)
    80002184:	6145                	addi	sp,sp,48
    80002186:	8082                	ret

0000000080002188 <exit>:
{
    80002188:	7179                	addi	sp,sp,-48
    8000218a:	f406                	sd	ra,40(sp)
    8000218c:	f022                	sd	s0,32(sp)
    8000218e:	ec26                	sd	s1,24(sp)
    80002190:	e84a                	sd	s2,16(sp)
    80002192:	e44e                	sd	s3,8(sp)
    80002194:	e052                	sd	s4,0(sp)
    80002196:	1800                	addi	s0,sp,48
    80002198:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000219a:	00000097          	auipc	ra,0x0
    8000219e:	812080e7          	jalr	-2030(ra) # 800019ac <myproc>
    800021a2:	89aa                	mv	s3,a0
  if(p == initproc)
    800021a4:	00007797          	auipc	a5,0x7
    800021a8:	8a47b783          	ld	a5,-1884(a5) # 80008a48 <initproc>
    800021ac:	0d050493          	addi	s1,a0,208
    800021b0:	15050913          	addi	s2,a0,336
    800021b4:	02a79363          	bne	a5,a0,800021da <exit+0x52>
    panic("init exiting");
    800021b8:	00006517          	auipc	a0,0x6
    800021bc:	0a850513          	addi	a0,a0,168 # 80008260 <digits+0x220>
    800021c0:	ffffe097          	auipc	ra,0xffffe
    800021c4:	380080e7          	jalr	896(ra) # 80000540 <panic>
      fileclose(f);
    800021c8:	00002097          	auipc	ra,0x2
    800021cc:	57c080e7          	jalr	1404(ra) # 80004744 <fileclose>
      p->ofile[fd] = 0;
    800021d0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800021d4:	04a1                	addi	s1,s1,8
    800021d6:	01248563          	beq	s1,s2,800021e0 <exit+0x58>
    if(p->ofile[fd]){
    800021da:	6088                	ld	a0,0(s1)
    800021dc:	f575                	bnez	a0,800021c8 <exit+0x40>
    800021de:	bfdd                	j	800021d4 <exit+0x4c>
  begin_op();
    800021e0:	00002097          	auipc	ra,0x2
    800021e4:	09c080e7          	jalr	156(ra) # 8000427c <begin_op>
  iput(p->cwd);
    800021e8:	1509b503          	ld	a0,336(s3)
    800021ec:	00002097          	auipc	ra,0x2
    800021f0:	87e080e7          	jalr	-1922(ra) # 80003a6a <iput>
  end_op();
    800021f4:	00002097          	auipc	ra,0x2
    800021f8:	106080e7          	jalr	262(ra) # 800042fa <end_op>
  p->cwd = 0;
    800021fc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002200:	0000f497          	auipc	s1,0xf
    80002204:	ad848493          	addi	s1,s1,-1320 # 80010cd8 <wait_lock>
    80002208:	8526                	mv	a0,s1
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	9cc080e7          	jalr	-1588(ra) # 80000bd6 <acquire>
  reparent(p);
    80002212:	854e                	mv	a0,s3
    80002214:	00000097          	auipc	ra,0x0
    80002218:	f1a080e7          	jalr	-230(ra) # 8000212e <reparent>
  wakeup(p->parent);
    8000221c:	0389b503          	ld	a0,56(s3)
    80002220:	00000097          	auipc	ra,0x0
    80002224:	e98080e7          	jalr	-360(ra) # 800020b8 <wakeup>
  acquire(&p->lock);
    80002228:	854e                	mv	a0,s3
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	9ac080e7          	jalr	-1620(ra) # 80000bd6 <acquire>
  p->xstate = status;
    80002232:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002236:	4795                	li	a5,5
    80002238:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000223c:	8526                	mv	a0,s1
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	a4c080e7          	jalr	-1460(ra) # 80000c8a <release>
  sched();
    80002246:	00000097          	auipc	ra,0x0
    8000224a:	cfc080e7          	jalr	-772(ra) # 80001f42 <sched>
  panic("zombie exit");
    8000224e:	00006517          	auipc	a0,0x6
    80002252:	02250513          	addi	a0,a0,34 # 80008270 <digits+0x230>
    80002256:	ffffe097          	auipc	ra,0xffffe
    8000225a:	2ea080e7          	jalr	746(ra) # 80000540 <panic>

000000008000225e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000225e:	7179                	addi	sp,sp,-48
    80002260:	f406                	sd	ra,40(sp)
    80002262:	f022                	sd	s0,32(sp)
    80002264:	ec26                	sd	s1,24(sp)
    80002266:	e84a                	sd	s2,16(sp)
    80002268:	e44e                	sd	s3,8(sp)
    8000226a:	1800                	addi	s0,sp,48
    8000226c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000226e:	0000f497          	auipc	s1,0xf
    80002272:	e8248493          	addi	s1,s1,-382 # 800110f0 <proc>
    80002276:	00015997          	auipc	s3,0x15
    8000227a:	87a98993          	addi	s3,s3,-1926 # 80016af0 <tickslock>
    acquire(&p->lock);
    8000227e:	8526                	mv	a0,s1
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	956080e7          	jalr	-1706(ra) # 80000bd6 <acquire>
    if(p->pid == pid){
    80002288:	589c                	lw	a5,48(s1)
    8000228a:	01278d63          	beq	a5,s2,800022a4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000228e:	8526                	mv	a0,s1
    80002290:	fffff097          	auipc	ra,0xfffff
    80002294:	9fa080e7          	jalr	-1542(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002298:	16848493          	addi	s1,s1,360
    8000229c:	ff3491e3          	bne	s1,s3,8000227e <kill+0x20>
  }
  return -1;
    800022a0:	557d                	li	a0,-1
    800022a2:	a829                	j	800022bc <kill+0x5e>
      p->killed = 1;
    800022a4:	4785                	li	a5,1
    800022a6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800022a8:	4c98                	lw	a4,24(s1)
    800022aa:	4789                	li	a5,2
    800022ac:	00f70f63          	beq	a4,a5,800022ca <kill+0x6c>
      release(&p->lock);
    800022b0:	8526                	mv	a0,s1
    800022b2:	fffff097          	auipc	ra,0xfffff
    800022b6:	9d8080e7          	jalr	-1576(ra) # 80000c8a <release>
      return 0;
    800022ba:	4501                	li	a0,0
}
    800022bc:	70a2                	ld	ra,40(sp)
    800022be:	7402                	ld	s0,32(sp)
    800022c0:	64e2                	ld	s1,24(sp)
    800022c2:	6942                	ld	s2,16(sp)
    800022c4:	69a2                	ld	s3,8(sp)
    800022c6:	6145                	addi	sp,sp,48
    800022c8:	8082                	ret
        p->state = RUNNABLE;
    800022ca:	478d                	li	a5,3
    800022cc:	cc9c                	sw	a5,24(s1)
    800022ce:	b7cd                	j	800022b0 <kill+0x52>

00000000800022d0 <setkilled>:

void
setkilled(struct proc *p)
{
    800022d0:	1101                	addi	sp,sp,-32
    800022d2:	ec06                	sd	ra,24(sp)
    800022d4:	e822                	sd	s0,16(sp)
    800022d6:	e426                	sd	s1,8(sp)
    800022d8:	1000                	addi	s0,sp,32
    800022da:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800022dc:	fffff097          	auipc	ra,0xfffff
    800022e0:	8fa080e7          	jalr	-1798(ra) # 80000bd6 <acquire>
  p->killed = 1;
    800022e4:	4785                	li	a5,1
    800022e6:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800022e8:	8526                	mv	a0,s1
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	9a0080e7          	jalr	-1632(ra) # 80000c8a <release>
}
    800022f2:	60e2                	ld	ra,24(sp)
    800022f4:	6442                	ld	s0,16(sp)
    800022f6:	64a2                	ld	s1,8(sp)
    800022f8:	6105                	addi	sp,sp,32
    800022fa:	8082                	ret

00000000800022fc <killed>:

int
killed(struct proc *p)
{
    800022fc:	1101                	addi	sp,sp,-32
    800022fe:	ec06                	sd	ra,24(sp)
    80002300:	e822                	sd	s0,16(sp)
    80002302:	e426                	sd	s1,8(sp)
    80002304:	e04a                	sd	s2,0(sp)
    80002306:	1000                	addi	s0,sp,32
    80002308:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	8cc080e7          	jalr	-1844(ra) # 80000bd6 <acquire>
  k = p->killed;
    80002312:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002316:	8526                	mv	a0,s1
    80002318:	fffff097          	auipc	ra,0xfffff
    8000231c:	972080e7          	jalr	-1678(ra) # 80000c8a <release>
  return k;
}
    80002320:	854a                	mv	a0,s2
    80002322:	60e2                	ld	ra,24(sp)
    80002324:	6442                	ld	s0,16(sp)
    80002326:	64a2                	ld	s1,8(sp)
    80002328:	6902                	ld	s2,0(sp)
    8000232a:	6105                	addi	sp,sp,32
    8000232c:	8082                	ret

000000008000232e <wait>:
{
    8000232e:	715d                	addi	sp,sp,-80
    80002330:	e486                	sd	ra,72(sp)
    80002332:	e0a2                	sd	s0,64(sp)
    80002334:	fc26                	sd	s1,56(sp)
    80002336:	f84a                	sd	s2,48(sp)
    80002338:	f44e                	sd	s3,40(sp)
    8000233a:	f052                	sd	s4,32(sp)
    8000233c:	ec56                	sd	s5,24(sp)
    8000233e:	e85a                	sd	s6,16(sp)
    80002340:	e45e                	sd	s7,8(sp)
    80002342:	e062                	sd	s8,0(sp)
    80002344:	0880                	addi	s0,sp,80
    80002346:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002348:	fffff097          	auipc	ra,0xfffff
    8000234c:	664080e7          	jalr	1636(ra) # 800019ac <myproc>
    80002350:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002352:	0000f517          	auipc	a0,0xf
    80002356:	98650513          	addi	a0,a0,-1658 # 80010cd8 <wait_lock>
    8000235a:	fffff097          	auipc	ra,0xfffff
    8000235e:	87c080e7          	jalr	-1924(ra) # 80000bd6 <acquire>
    havekids = 0;
    80002362:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002364:	4a15                	li	s4,5
        havekids = 1;
    80002366:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002368:	00014997          	auipc	s3,0x14
    8000236c:	78898993          	addi	s3,s3,1928 # 80016af0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002370:	0000fc17          	auipc	s8,0xf
    80002374:	968c0c13          	addi	s8,s8,-1688 # 80010cd8 <wait_lock>
    havekids = 0;
    80002378:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000237a:	0000f497          	auipc	s1,0xf
    8000237e:	d7648493          	addi	s1,s1,-650 # 800110f0 <proc>
    80002382:	a0bd                	j	800023f0 <wait+0xc2>
          pid = pp->pid;
    80002384:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002388:	000b0e63          	beqz	s6,800023a4 <wait+0x76>
    8000238c:	4691                	li	a3,4
    8000238e:	02c48613          	addi	a2,s1,44
    80002392:	85da                	mv	a1,s6
    80002394:	05093503          	ld	a0,80(s2)
    80002398:	fffff097          	auipc	ra,0xfffff
    8000239c:	2d4080e7          	jalr	724(ra) # 8000166c <copyout>
    800023a0:	02054563          	bltz	a0,800023ca <wait+0x9c>
          freeproc(pp);
    800023a4:	8526                	mv	a0,s1
    800023a6:	fffff097          	auipc	ra,0xfffff
    800023aa:	7b8080e7          	jalr	1976(ra) # 80001b5e <freeproc>
          release(&pp->lock);
    800023ae:	8526                	mv	a0,s1
    800023b0:	fffff097          	auipc	ra,0xfffff
    800023b4:	8da080e7          	jalr	-1830(ra) # 80000c8a <release>
          release(&wait_lock);
    800023b8:	0000f517          	auipc	a0,0xf
    800023bc:	92050513          	addi	a0,a0,-1760 # 80010cd8 <wait_lock>
    800023c0:	fffff097          	auipc	ra,0xfffff
    800023c4:	8ca080e7          	jalr	-1846(ra) # 80000c8a <release>
          return pid;
    800023c8:	a0b5                	j	80002434 <wait+0x106>
            release(&pp->lock);
    800023ca:	8526                	mv	a0,s1
    800023cc:	fffff097          	auipc	ra,0xfffff
    800023d0:	8be080e7          	jalr	-1858(ra) # 80000c8a <release>
            release(&wait_lock);
    800023d4:	0000f517          	auipc	a0,0xf
    800023d8:	90450513          	addi	a0,a0,-1788 # 80010cd8 <wait_lock>
    800023dc:	fffff097          	auipc	ra,0xfffff
    800023e0:	8ae080e7          	jalr	-1874(ra) # 80000c8a <release>
            return -1;
    800023e4:	59fd                	li	s3,-1
    800023e6:	a0b9                	j	80002434 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023e8:	16848493          	addi	s1,s1,360
    800023ec:	03348463          	beq	s1,s3,80002414 <wait+0xe6>
      if(pp->parent == p){
    800023f0:	7c9c                	ld	a5,56(s1)
    800023f2:	ff279be3          	bne	a5,s2,800023e8 <wait+0xba>
        acquire(&pp->lock);
    800023f6:	8526                	mv	a0,s1
    800023f8:	ffffe097          	auipc	ra,0xffffe
    800023fc:	7de080e7          	jalr	2014(ra) # 80000bd6 <acquire>
        if(pp->state == ZOMBIE){
    80002400:	4c9c                	lw	a5,24(s1)
    80002402:	f94781e3          	beq	a5,s4,80002384 <wait+0x56>
        release(&pp->lock);
    80002406:	8526                	mv	a0,s1
    80002408:	fffff097          	auipc	ra,0xfffff
    8000240c:	882080e7          	jalr	-1918(ra) # 80000c8a <release>
        havekids = 1;
    80002410:	8756                	mv	a4,s5
    80002412:	bfd9                	j	800023e8 <wait+0xba>
    if(!havekids || killed(p)){
    80002414:	c719                	beqz	a4,80002422 <wait+0xf4>
    80002416:	854a                	mv	a0,s2
    80002418:	00000097          	auipc	ra,0x0
    8000241c:	ee4080e7          	jalr	-284(ra) # 800022fc <killed>
    80002420:	c51d                	beqz	a0,8000244e <wait+0x120>
      release(&wait_lock);
    80002422:	0000f517          	auipc	a0,0xf
    80002426:	8b650513          	addi	a0,a0,-1866 # 80010cd8 <wait_lock>
    8000242a:	fffff097          	auipc	ra,0xfffff
    8000242e:	860080e7          	jalr	-1952(ra) # 80000c8a <release>
      return -1;
    80002432:	59fd                	li	s3,-1
}
    80002434:	854e                	mv	a0,s3
    80002436:	60a6                	ld	ra,72(sp)
    80002438:	6406                	ld	s0,64(sp)
    8000243a:	74e2                	ld	s1,56(sp)
    8000243c:	7942                	ld	s2,48(sp)
    8000243e:	79a2                	ld	s3,40(sp)
    80002440:	7a02                	ld	s4,32(sp)
    80002442:	6ae2                	ld	s5,24(sp)
    80002444:	6b42                	ld	s6,16(sp)
    80002446:	6ba2                	ld	s7,8(sp)
    80002448:	6c02                	ld	s8,0(sp)
    8000244a:	6161                	addi	sp,sp,80
    8000244c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000244e:	85e2                	mv	a1,s8
    80002450:	854a                	mv	a0,s2
    80002452:	00000097          	auipc	ra,0x0
    80002456:	c02080e7          	jalr	-1022(ra) # 80002054 <sleep>
    havekids = 0;
    8000245a:	bf39                	j	80002378 <wait+0x4a>

000000008000245c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000245c:	7179                	addi	sp,sp,-48
    8000245e:	f406                	sd	ra,40(sp)
    80002460:	f022                	sd	s0,32(sp)
    80002462:	ec26                	sd	s1,24(sp)
    80002464:	e84a                	sd	s2,16(sp)
    80002466:	e44e                	sd	s3,8(sp)
    80002468:	e052                	sd	s4,0(sp)
    8000246a:	1800                	addi	s0,sp,48
    8000246c:	84aa                	mv	s1,a0
    8000246e:	892e                	mv	s2,a1
    80002470:	89b2                	mv	s3,a2
    80002472:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002474:	fffff097          	auipc	ra,0xfffff
    80002478:	538080e7          	jalr	1336(ra) # 800019ac <myproc>
  if(user_dst){
    8000247c:	c08d                	beqz	s1,8000249e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000247e:	86d2                	mv	a3,s4
    80002480:	864e                	mv	a2,s3
    80002482:	85ca                	mv	a1,s2
    80002484:	6928                	ld	a0,80(a0)
    80002486:	fffff097          	auipc	ra,0xfffff
    8000248a:	1e6080e7          	jalr	486(ra) # 8000166c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000248e:	70a2                	ld	ra,40(sp)
    80002490:	7402                	ld	s0,32(sp)
    80002492:	64e2                	ld	s1,24(sp)
    80002494:	6942                	ld	s2,16(sp)
    80002496:	69a2                	ld	s3,8(sp)
    80002498:	6a02                	ld	s4,0(sp)
    8000249a:	6145                	addi	sp,sp,48
    8000249c:	8082                	ret
    memmove((char *)dst, src, len);
    8000249e:	000a061b          	sext.w	a2,s4
    800024a2:	85ce                	mv	a1,s3
    800024a4:	854a                	mv	a0,s2
    800024a6:	fffff097          	auipc	ra,0xfffff
    800024aa:	888080e7          	jalr	-1912(ra) # 80000d2e <memmove>
    return 0;
    800024ae:	8526                	mv	a0,s1
    800024b0:	bff9                	j	8000248e <either_copyout+0x32>

00000000800024b2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024b2:	7179                	addi	sp,sp,-48
    800024b4:	f406                	sd	ra,40(sp)
    800024b6:	f022                	sd	s0,32(sp)
    800024b8:	ec26                	sd	s1,24(sp)
    800024ba:	e84a                	sd	s2,16(sp)
    800024bc:	e44e                	sd	s3,8(sp)
    800024be:	e052                	sd	s4,0(sp)
    800024c0:	1800                	addi	s0,sp,48
    800024c2:	892a                	mv	s2,a0
    800024c4:	84ae                	mv	s1,a1
    800024c6:	89b2                	mv	s3,a2
    800024c8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	4e2080e7          	jalr	1250(ra) # 800019ac <myproc>
  if(user_src){
    800024d2:	c08d                	beqz	s1,800024f4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800024d4:	86d2                	mv	a3,s4
    800024d6:	864e                	mv	a2,s3
    800024d8:	85ca                	mv	a1,s2
    800024da:	6928                	ld	a0,80(a0)
    800024dc:	fffff097          	auipc	ra,0xfffff
    800024e0:	21c080e7          	jalr	540(ra) # 800016f8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024e4:	70a2                	ld	ra,40(sp)
    800024e6:	7402                	ld	s0,32(sp)
    800024e8:	64e2                	ld	s1,24(sp)
    800024ea:	6942                	ld	s2,16(sp)
    800024ec:	69a2                	ld	s3,8(sp)
    800024ee:	6a02                	ld	s4,0(sp)
    800024f0:	6145                	addi	sp,sp,48
    800024f2:	8082                	ret
    memmove(dst, (char*)src, len);
    800024f4:	000a061b          	sext.w	a2,s4
    800024f8:	85ce                	mv	a1,s3
    800024fa:	854a                	mv	a0,s2
    800024fc:	fffff097          	auipc	ra,0xfffff
    80002500:	832080e7          	jalr	-1998(ra) # 80000d2e <memmove>
    return 0;
    80002504:	8526                	mv	a0,s1
    80002506:	bff9                	j	800024e4 <either_copyin+0x32>

0000000080002508 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002508:	715d                	addi	sp,sp,-80
    8000250a:	e486                	sd	ra,72(sp)
    8000250c:	e0a2                	sd	s0,64(sp)
    8000250e:	fc26                	sd	s1,56(sp)
    80002510:	f84a                	sd	s2,48(sp)
    80002512:	f44e                	sd	s3,40(sp)
    80002514:	f052                	sd	s4,32(sp)
    80002516:	ec56                	sd	s5,24(sp)
    80002518:	e85a                	sd	s6,16(sp)
    8000251a:	e45e                	sd	s7,8(sp)
    8000251c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000251e:	00006517          	auipc	a0,0x6
    80002522:	baa50513          	addi	a0,a0,-1110 # 800080c8 <digits+0x88>
    80002526:	ffffe097          	auipc	ra,0xffffe
    8000252a:	064080e7          	jalr	100(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000252e:	0000f497          	auipc	s1,0xf
    80002532:	d1a48493          	addi	s1,s1,-742 # 80011248 <proc+0x158>
    80002536:	00014917          	auipc	s2,0x14
    8000253a:	71290913          	addi	s2,s2,1810 # 80016c48 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000253e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002540:	00006997          	auipc	s3,0x6
    80002544:	d4098993          	addi	s3,s3,-704 # 80008280 <digits+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80002548:	00006a97          	auipc	s5,0x6
    8000254c:	d40a8a93          	addi	s5,s5,-704 # 80008288 <digits+0x248>
    printf("\n");
    80002550:	00006a17          	auipc	s4,0x6
    80002554:	b78a0a13          	addi	s4,s4,-1160 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002558:	00006b97          	auipc	s7,0x6
    8000255c:	d70b8b93          	addi	s7,s7,-656 # 800082c8 <states.0>
    80002560:	a00d                	j	80002582 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002562:	ed86a583          	lw	a1,-296(a3)
    80002566:	8556                	mv	a0,s5
    80002568:	ffffe097          	auipc	ra,0xffffe
    8000256c:	022080e7          	jalr	34(ra) # 8000058a <printf>
    printf("\n");
    80002570:	8552                	mv	a0,s4
    80002572:	ffffe097          	auipc	ra,0xffffe
    80002576:	018080e7          	jalr	24(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000257a:	16848493          	addi	s1,s1,360
    8000257e:	03248263          	beq	s1,s2,800025a2 <procdump+0x9a>
    if(p->state == UNUSED)
    80002582:	86a6                	mv	a3,s1
    80002584:	ec04a783          	lw	a5,-320(s1)
    80002588:	dbed                	beqz	a5,8000257a <procdump+0x72>
      state = "???";
    8000258a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000258c:	fcfb6be3          	bltu	s6,a5,80002562 <procdump+0x5a>
    80002590:	02079713          	slli	a4,a5,0x20
    80002594:	01d75793          	srli	a5,a4,0x1d
    80002598:	97de                	add	a5,a5,s7
    8000259a:	6390                	ld	a2,0(a5)
    8000259c:	f279                	bnez	a2,80002562 <procdump+0x5a>
      state = "???";
    8000259e:	864e                	mv	a2,s3
    800025a0:	b7c9                	j	80002562 <procdump+0x5a>
  }
}
    800025a2:	60a6                	ld	ra,72(sp)
    800025a4:	6406                	ld	s0,64(sp)
    800025a6:	74e2                	ld	s1,56(sp)
    800025a8:	7942                	ld	s2,48(sp)
    800025aa:	79a2                	ld	s3,40(sp)
    800025ac:	7a02                	ld	s4,32(sp)
    800025ae:	6ae2                	ld	s5,24(sp)
    800025b0:	6b42                	ld	s6,16(sp)
    800025b2:	6ba2                	ld	s7,8(sp)
    800025b4:	6161                	addi	sp,sp,80
    800025b6:	8082                	ret

00000000800025b8 <swtch>:
    800025b8:	00153023          	sd	ra,0(a0)
    800025bc:	00253423          	sd	sp,8(a0)
    800025c0:	e900                	sd	s0,16(a0)
    800025c2:	ed04                	sd	s1,24(a0)
    800025c4:	03253023          	sd	s2,32(a0)
    800025c8:	03353423          	sd	s3,40(a0)
    800025cc:	03453823          	sd	s4,48(a0)
    800025d0:	03553c23          	sd	s5,56(a0)
    800025d4:	05653023          	sd	s6,64(a0)
    800025d8:	05753423          	sd	s7,72(a0)
    800025dc:	05853823          	sd	s8,80(a0)
    800025e0:	05953c23          	sd	s9,88(a0)
    800025e4:	07a53023          	sd	s10,96(a0)
    800025e8:	07b53423          	sd	s11,104(a0)
    800025ec:	0005b083          	ld	ra,0(a1)
    800025f0:	0085b103          	ld	sp,8(a1)
    800025f4:	6980                	ld	s0,16(a1)
    800025f6:	6d84                	ld	s1,24(a1)
    800025f8:	0205b903          	ld	s2,32(a1)
    800025fc:	0285b983          	ld	s3,40(a1)
    80002600:	0305ba03          	ld	s4,48(a1)
    80002604:	0385ba83          	ld	s5,56(a1)
    80002608:	0405bb03          	ld	s6,64(a1)
    8000260c:	0485bb83          	ld	s7,72(a1)
    80002610:	0505bc03          	ld	s8,80(a1)
    80002614:	0585bc83          	ld	s9,88(a1)
    80002618:	0605bd03          	ld	s10,96(a1)
    8000261c:	0685bd83          	ld	s11,104(a1)
    80002620:	8082                	ret

0000000080002622 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002622:	1141                	addi	sp,sp,-16
    80002624:	e406                	sd	ra,8(sp)
    80002626:	e022                	sd	s0,0(sp)
    80002628:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000262a:	00006597          	auipc	a1,0x6
    8000262e:	cce58593          	addi	a1,a1,-818 # 800082f8 <states.0+0x30>
    80002632:	00014517          	auipc	a0,0x14
    80002636:	4be50513          	addi	a0,a0,1214 # 80016af0 <tickslock>
    8000263a:	ffffe097          	auipc	ra,0xffffe
    8000263e:	50c080e7          	jalr	1292(ra) # 80000b46 <initlock>
}
    80002642:	60a2                	ld	ra,8(sp)
    80002644:	6402                	ld	s0,0(sp)
    80002646:	0141                	addi	sp,sp,16
    80002648:	8082                	ret

000000008000264a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000264a:	1141                	addi	sp,sp,-16
    8000264c:	e422                	sd	s0,8(sp)
    8000264e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002650:	00004797          	auipc	a5,0x4
    80002654:	83078793          	addi	a5,a5,-2000 # 80005e80 <kernelvec>
    80002658:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000265c:	6422                	ld	s0,8(sp)
    8000265e:	0141                	addi	sp,sp,16
    80002660:	8082                	ret

0000000080002662 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002662:	1141                	addi	sp,sp,-16
    80002664:	e406                	sd	ra,8(sp)
    80002666:	e022                	sd	s0,0(sp)
    80002668:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000266a:	fffff097          	auipc	ra,0xfffff
    8000266e:	342080e7          	jalr	834(ra) # 800019ac <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002672:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002676:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002678:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000267c:	00005697          	auipc	a3,0x5
    80002680:	98468693          	addi	a3,a3,-1660 # 80007000 <_trampoline>
    80002684:	00005717          	auipc	a4,0x5
    80002688:	97c70713          	addi	a4,a4,-1668 # 80007000 <_trampoline>
    8000268c:	8f15                	sub	a4,a4,a3
    8000268e:	040007b7          	lui	a5,0x4000
    80002692:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002694:	07b2                	slli	a5,a5,0xc
    80002696:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002698:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000269c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000269e:	18002673          	csrr	a2,satp
    800026a2:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800026a4:	6d30                	ld	a2,88(a0)
    800026a6:	6138                	ld	a4,64(a0)
    800026a8:	6585                	lui	a1,0x1
    800026aa:	972e                	add	a4,a4,a1
    800026ac:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800026ae:	6d38                	ld	a4,88(a0)
    800026b0:	00000617          	auipc	a2,0x0
    800026b4:	13060613          	addi	a2,a2,304 # 800027e0 <usertrap>
    800026b8:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800026ba:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800026bc:	8612                	mv	a2,tp
    800026be:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026c0:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800026c4:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800026c8:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026cc:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800026d0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026d2:	6f18                	ld	a4,24(a4)
    800026d4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800026d8:	6928                	ld	a0,80(a0)
    800026da:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800026dc:	00005717          	auipc	a4,0x5
    800026e0:	9c070713          	addi	a4,a4,-1600 # 8000709c <userret>
    800026e4:	8f15                	sub	a4,a4,a3
    800026e6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800026e8:	577d                	li	a4,-1
    800026ea:	177e                	slli	a4,a4,0x3f
    800026ec:	8d59                	or	a0,a0,a4
    800026ee:	9782                	jalr	a5
}
    800026f0:	60a2                	ld	ra,8(sp)
    800026f2:	6402                	ld	s0,0(sp)
    800026f4:	0141                	addi	sp,sp,16
    800026f6:	8082                	ret

00000000800026f8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026f8:	1101                	addi	sp,sp,-32
    800026fa:	ec06                	sd	ra,24(sp)
    800026fc:	e822                	sd	s0,16(sp)
    800026fe:	e426                	sd	s1,8(sp)
    80002700:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002702:	00014497          	auipc	s1,0x14
    80002706:	3ee48493          	addi	s1,s1,1006 # 80016af0 <tickslock>
    8000270a:	8526                	mv	a0,s1
    8000270c:	ffffe097          	auipc	ra,0xffffe
    80002710:	4ca080e7          	jalr	1226(ra) # 80000bd6 <acquire>
  ticks++;
    80002714:	00006517          	auipc	a0,0x6
    80002718:	33c50513          	addi	a0,a0,828 # 80008a50 <ticks>
    8000271c:	411c                	lw	a5,0(a0)
    8000271e:	2785                	addiw	a5,a5,1
    80002720:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002722:	00000097          	auipc	ra,0x0
    80002726:	996080e7          	jalr	-1642(ra) # 800020b8 <wakeup>
  release(&tickslock);
    8000272a:	8526                	mv	a0,s1
    8000272c:	ffffe097          	auipc	ra,0xffffe
    80002730:	55e080e7          	jalr	1374(ra) # 80000c8a <release>
}
    80002734:	60e2                	ld	ra,24(sp)
    80002736:	6442                	ld	s0,16(sp)
    80002738:	64a2                	ld	s1,8(sp)
    8000273a:	6105                	addi	sp,sp,32
    8000273c:	8082                	ret

000000008000273e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000273e:	1101                	addi	sp,sp,-32
    80002740:	ec06                	sd	ra,24(sp)
    80002742:	e822                	sd	s0,16(sp)
    80002744:	e426                	sd	s1,8(sp)
    80002746:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002748:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000274c:	00074d63          	bltz	a4,80002766 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002750:	57fd                	li	a5,-1
    80002752:	17fe                	slli	a5,a5,0x3f
    80002754:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002756:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002758:	06f70363          	beq	a4,a5,800027be <devintr+0x80>
  }
}
    8000275c:	60e2                	ld	ra,24(sp)
    8000275e:	6442                	ld	s0,16(sp)
    80002760:	64a2                	ld	s1,8(sp)
    80002762:	6105                	addi	sp,sp,32
    80002764:	8082                	ret
     (scause & 0xff) == 9){
    80002766:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    8000276a:	46a5                	li	a3,9
    8000276c:	fed792e3          	bne	a5,a3,80002750 <devintr+0x12>
    int irq = plic_claim();
    80002770:	00004097          	auipc	ra,0x4
    80002774:	818080e7          	jalr	-2024(ra) # 80005f88 <plic_claim>
    80002778:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000277a:	47a9                	li	a5,10
    8000277c:	02f50763          	beq	a0,a5,800027aa <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002780:	4785                	li	a5,1
    80002782:	02f50963          	beq	a0,a5,800027b4 <devintr+0x76>
    return 1;
    80002786:	4505                	li	a0,1
    } else if(irq){
    80002788:	d8f1                	beqz	s1,8000275c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000278a:	85a6                	mv	a1,s1
    8000278c:	00006517          	auipc	a0,0x6
    80002790:	b7450513          	addi	a0,a0,-1164 # 80008300 <states.0+0x38>
    80002794:	ffffe097          	auipc	ra,0xffffe
    80002798:	df6080e7          	jalr	-522(ra) # 8000058a <printf>
      plic_complete(irq);
    8000279c:	8526                	mv	a0,s1
    8000279e:	00004097          	auipc	ra,0x4
    800027a2:	80e080e7          	jalr	-2034(ra) # 80005fac <plic_complete>
    return 1;
    800027a6:	4505                	li	a0,1
    800027a8:	bf55                	j	8000275c <devintr+0x1e>
      uartintr();
    800027aa:	ffffe097          	auipc	ra,0xffffe
    800027ae:	1ee080e7          	jalr	494(ra) # 80000998 <uartintr>
    800027b2:	b7ed                	j	8000279c <devintr+0x5e>
      virtio_disk_intr();
    800027b4:	00004097          	auipc	ra,0x4
    800027b8:	cc0080e7          	jalr	-832(ra) # 80006474 <virtio_disk_intr>
    800027bc:	b7c5                	j	8000279c <devintr+0x5e>
    if(cpuid() == 0){
    800027be:	fffff097          	auipc	ra,0xfffff
    800027c2:	1c2080e7          	jalr	450(ra) # 80001980 <cpuid>
    800027c6:	c901                	beqz	a0,800027d6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800027c8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800027cc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800027ce:	14479073          	csrw	sip,a5
    return 2;
    800027d2:	4509                	li	a0,2
    800027d4:	b761                	j	8000275c <devintr+0x1e>
      clockintr();
    800027d6:	00000097          	auipc	ra,0x0
    800027da:	f22080e7          	jalr	-222(ra) # 800026f8 <clockintr>
    800027de:	b7ed                	j	800027c8 <devintr+0x8a>

00000000800027e0 <usertrap>:
{
    800027e0:	1101                	addi	sp,sp,-32
    800027e2:	ec06                	sd	ra,24(sp)
    800027e4:	e822                	sd	s0,16(sp)
    800027e6:	e426                	sd	s1,8(sp)
    800027e8:	e04a                	sd	s2,0(sp)
    800027ea:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ec:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027f0:	1007f793          	andi	a5,a5,256
    800027f4:	e3b1                	bnez	a5,80002838 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027f6:	00003797          	auipc	a5,0x3
    800027fa:	68a78793          	addi	a5,a5,1674 # 80005e80 <kernelvec>
    800027fe:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002802:	fffff097          	auipc	ra,0xfffff
    80002806:	1aa080e7          	jalr	426(ra) # 800019ac <myproc>
    8000280a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000280c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000280e:	14102773          	csrr	a4,sepc
    80002812:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002814:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002818:	47a1                	li	a5,8
    8000281a:	02f70763          	beq	a4,a5,80002848 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    8000281e:	00000097          	auipc	ra,0x0
    80002822:	f20080e7          	jalr	-224(ra) # 8000273e <devintr>
    80002826:	892a                	mv	s2,a0
    80002828:	c151                	beqz	a0,800028ac <usertrap+0xcc>
  if(killed(p))
    8000282a:	8526                	mv	a0,s1
    8000282c:	00000097          	auipc	ra,0x0
    80002830:	ad0080e7          	jalr	-1328(ra) # 800022fc <killed>
    80002834:	c929                	beqz	a0,80002886 <usertrap+0xa6>
    80002836:	a099                	j	8000287c <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002838:	00006517          	auipc	a0,0x6
    8000283c:	ae850513          	addi	a0,a0,-1304 # 80008320 <states.0+0x58>
    80002840:	ffffe097          	auipc	ra,0xffffe
    80002844:	d00080e7          	jalr	-768(ra) # 80000540 <panic>
    if(killed(p))
    80002848:	00000097          	auipc	ra,0x0
    8000284c:	ab4080e7          	jalr	-1356(ra) # 800022fc <killed>
    80002850:	e921                	bnez	a0,800028a0 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80002852:	6cb8                	ld	a4,88(s1)
    80002854:	6f1c                	ld	a5,24(a4)
    80002856:	0791                	addi	a5,a5,4
    80002858:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000285a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000285e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002862:	10079073          	csrw	sstatus,a5
    syscall();
    80002866:	00000097          	auipc	ra,0x0
    8000286a:	2d4080e7          	jalr	724(ra) # 80002b3a <syscall>
  if(killed(p))
    8000286e:	8526                	mv	a0,s1
    80002870:	00000097          	auipc	ra,0x0
    80002874:	a8c080e7          	jalr	-1396(ra) # 800022fc <killed>
    80002878:	c911                	beqz	a0,8000288c <usertrap+0xac>
    8000287a:	4901                	li	s2,0
    exit(-1);
    8000287c:	557d                	li	a0,-1
    8000287e:	00000097          	auipc	ra,0x0
    80002882:	90a080e7          	jalr	-1782(ra) # 80002188 <exit>
  if(which_dev == 2)
    80002886:	4789                	li	a5,2
    80002888:	04f90f63          	beq	s2,a5,800028e6 <usertrap+0x106>
  usertrapret();
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	dd6080e7          	jalr	-554(ra) # 80002662 <usertrapret>
}
    80002894:	60e2                	ld	ra,24(sp)
    80002896:	6442                	ld	s0,16(sp)
    80002898:	64a2                	ld	s1,8(sp)
    8000289a:	6902                	ld	s2,0(sp)
    8000289c:	6105                	addi	sp,sp,32
    8000289e:	8082                	ret
      exit(-1);
    800028a0:	557d                	li	a0,-1
    800028a2:	00000097          	auipc	ra,0x0
    800028a6:	8e6080e7          	jalr	-1818(ra) # 80002188 <exit>
    800028aa:	b765                	j	80002852 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028ac:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800028b0:	5890                	lw	a2,48(s1)
    800028b2:	00006517          	auipc	a0,0x6
    800028b6:	a8e50513          	addi	a0,a0,-1394 # 80008340 <states.0+0x78>
    800028ba:	ffffe097          	auipc	ra,0xffffe
    800028be:	cd0080e7          	jalr	-816(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028c2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800028c6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800028ca:	00006517          	auipc	a0,0x6
    800028ce:	aa650513          	addi	a0,a0,-1370 # 80008370 <states.0+0xa8>
    800028d2:	ffffe097          	auipc	ra,0xffffe
    800028d6:	cb8080e7          	jalr	-840(ra) # 8000058a <printf>
    setkilled(p);
    800028da:	8526                	mv	a0,s1
    800028dc:	00000097          	auipc	ra,0x0
    800028e0:	9f4080e7          	jalr	-1548(ra) # 800022d0 <setkilled>
    800028e4:	b769                	j	8000286e <usertrap+0x8e>
    yield();
    800028e6:	fffff097          	auipc	ra,0xfffff
    800028ea:	732080e7          	jalr	1842(ra) # 80002018 <yield>
    800028ee:	bf79                	j	8000288c <usertrap+0xac>

00000000800028f0 <kerneltrap>:
{
    800028f0:	7179                	addi	sp,sp,-48
    800028f2:	f406                	sd	ra,40(sp)
    800028f4:	f022                	sd	s0,32(sp)
    800028f6:	ec26                	sd	s1,24(sp)
    800028f8:	e84a                	sd	s2,16(sp)
    800028fa:	e44e                	sd	s3,8(sp)
    800028fc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028fe:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002902:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002906:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000290a:	1004f793          	andi	a5,s1,256
    8000290e:	cb85                	beqz	a5,8000293e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002910:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002914:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002916:	ef85                	bnez	a5,8000294e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002918:	00000097          	auipc	ra,0x0
    8000291c:	e26080e7          	jalr	-474(ra) # 8000273e <devintr>
    80002920:	cd1d                	beqz	a0,8000295e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002922:	4789                	li	a5,2
    80002924:	06f50a63          	beq	a0,a5,80002998 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002928:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000292c:	10049073          	csrw	sstatus,s1
}
    80002930:	70a2                	ld	ra,40(sp)
    80002932:	7402                	ld	s0,32(sp)
    80002934:	64e2                	ld	s1,24(sp)
    80002936:	6942                	ld	s2,16(sp)
    80002938:	69a2                	ld	s3,8(sp)
    8000293a:	6145                	addi	sp,sp,48
    8000293c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000293e:	00006517          	auipc	a0,0x6
    80002942:	a5250513          	addi	a0,a0,-1454 # 80008390 <states.0+0xc8>
    80002946:	ffffe097          	auipc	ra,0xffffe
    8000294a:	bfa080e7          	jalr	-1030(ra) # 80000540 <panic>
    panic("kerneltrap: interrupts enabled");
    8000294e:	00006517          	auipc	a0,0x6
    80002952:	a6a50513          	addi	a0,a0,-1430 # 800083b8 <states.0+0xf0>
    80002956:	ffffe097          	auipc	ra,0xffffe
    8000295a:	bea080e7          	jalr	-1046(ra) # 80000540 <panic>
    printf("scause %p\n", scause);
    8000295e:	85ce                	mv	a1,s3
    80002960:	00006517          	auipc	a0,0x6
    80002964:	a7850513          	addi	a0,a0,-1416 # 800083d8 <states.0+0x110>
    80002968:	ffffe097          	auipc	ra,0xffffe
    8000296c:	c22080e7          	jalr	-990(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002970:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002974:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002978:	00006517          	auipc	a0,0x6
    8000297c:	a7050513          	addi	a0,a0,-1424 # 800083e8 <states.0+0x120>
    80002980:	ffffe097          	auipc	ra,0xffffe
    80002984:	c0a080e7          	jalr	-1014(ra) # 8000058a <printf>
    panic("kerneltrap");
    80002988:	00006517          	auipc	a0,0x6
    8000298c:	a7850513          	addi	a0,a0,-1416 # 80008400 <states.0+0x138>
    80002990:	ffffe097          	auipc	ra,0xffffe
    80002994:	bb0080e7          	jalr	-1104(ra) # 80000540 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002998:	fffff097          	auipc	ra,0xfffff
    8000299c:	014080e7          	jalr	20(ra) # 800019ac <myproc>
    800029a0:	d541                	beqz	a0,80002928 <kerneltrap+0x38>
    800029a2:	fffff097          	auipc	ra,0xfffff
    800029a6:	00a080e7          	jalr	10(ra) # 800019ac <myproc>
    800029aa:	4d18                	lw	a4,24(a0)
    800029ac:	4791                	li	a5,4
    800029ae:	f6f71de3          	bne	a4,a5,80002928 <kerneltrap+0x38>
    yield();
    800029b2:	fffff097          	auipc	ra,0xfffff
    800029b6:	666080e7          	jalr	1638(ra) # 80002018 <yield>
    800029ba:	b7bd                	j	80002928 <kerneltrap+0x38>

00000000800029bc <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800029bc:	1101                	addi	sp,sp,-32
    800029be:	ec06                	sd	ra,24(sp)
    800029c0:	e822                	sd	s0,16(sp)
    800029c2:	e426                	sd	s1,8(sp)
    800029c4:	1000                	addi	s0,sp,32
    800029c6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800029c8:	fffff097          	auipc	ra,0xfffff
    800029cc:	fe4080e7          	jalr	-28(ra) # 800019ac <myproc>
  switch (n) {
    800029d0:	4795                	li	a5,5
    800029d2:	0497e163          	bltu	a5,s1,80002a14 <argraw+0x58>
    800029d6:	048a                	slli	s1,s1,0x2
    800029d8:	00006717          	auipc	a4,0x6
    800029dc:	a6070713          	addi	a4,a4,-1440 # 80008438 <states.0+0x170>
    800029e0:	94ba                	add	s1,s1,a4
    800029e2:	409c                	lw	a5,0(s1)
    800029e4:	97ba                	add	a5,a5,a4
    800029e6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800029e8:	6d3c                	ld	a5,88(a0)
    800029ea:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800029ec:	60e2                	ld	ra,24(sp)
    800029ee:	6442                	ld	s0,16(sp)
    800029f0:	64a2                	ld	s1,8(sp)
    800029f2:	6105                	addi	sp,sp,32
    800029f4:	8082                	ret
    return p->trapframe->a1;
    800029f6:	6d3c                	ld	a5,88(a0)
    800029f8:	7fa8                	ld	a0,120(a5)
    800029fa:	bfcd                	j	800029ec <argraw+0x30>
    return p->trapframe->a2;
    800029fc:	6d3c                	ld	a5,88(a0)
    800029fe:	63c8                	ld	a0,128(a5)
    80002a00:	b7f5                	j	800029ec <argraw+0x30>
    return p->trapframe->a3;
    80002a02:	6d3c                	ld	a5,88(a0)
    80002a04:	67c8                	ld	a0,136(a5)
    80002a06:	b7dd                	j	800029ec <argraw+0x30>
    return p->trapframe->a4;
    80002a08:	6d3c                	ld	a5,88(a0)
    80002a0a:	6bc8                	ld	a0,144(a5)
    80002a0c:	b7c5                	j	800029ec <argraw+0x30>
    return p->trapframe->a5;
    80002a0e:	6d3c                	ld	a5,88(a0)
    80002a10:	6fc8                	ld	a0,152(a5)
    80002a12:	bfe9                	j	800029ec <argraw+0x30>
  panic("argraw");
    80002a14:	00006517          	auipc	a0,0x6
    80002a18:	9fc50513          	addi	a0,a0,-1540 # 80008410 <states.0+0x148>
    80002a1c:	ffffe097          	auipc	ra,0xffffe
    80002a20:	b24080e7          	jalr	-1244(ra) # 80000540 <panic>

0000000080002a24 <fetchaddr>:
{
    80002a24:	1101                	addi	sp,sp,-32
    80002a26:	ec06                	sd	ra,24(sp)
    80002a28:	e822                	sd	s0,16(sp)
    80002a2a:	e426                	sd	s1,8(sp)
    80002a2c:	e04a                	sd	s2,0(sp)
    80002a2e:	1000                	addi	s0,sp,32
    80002a30:	84aa                	mv	s1,a0
    80002a32:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002a34:	fffff097          	auipc	ra,0xfffff
    80002a38:	f78080e7          	jalr	-136(ra) # 800019ac <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002a3c:	653c                	ld	a5,72(a0)
    80002a3e:	02f4f863          	bgeu	s1,a5,80002a6e <fetchaddr+0x4a>
    80002a42:	00848713          	addi	a4,s1,8
    80002a46:	02e7e663          	bltu	a5,a4,80002a72 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a4a:	46a1                	li	a3,8
    80002a4c:	8626                	mv	a2,s1
    80002a4e:	85ca                	mv	a1,s2
    80002a50:	6928                	ld	a0,80(a0)
    80002a52:	fffff097          	auipc	ra,0xfffff
    80002a56:	ca6080e7          	jalr	-858(ra) # 800016f8 <copyin>
    80002a5a:	00a03533          	snez	a0,a0
    80002a5e:	40a00533          	neg	a0,a0
}
    80002a62:	60e2                	ld	ra,24(sp)
    80002a64:	6442                	ld	s0,16(sp)
    80002a66:	64a2                	ld	s1,8(sp)
    80002a68:	6902                	ld	s2,0(sp)
    80002a6a:	6105                	addi	sp,sp,32
    80002a6c:	8082                	ret
    return -1;
    80002a6e:	557d                	li	a0,-1
    80002a70:	bfcd                	j	80002a62 <fetchaddr+0x3e>
    80002a72:	557d                	li	a0,-1
    80002a74:	b7fd                	j	80002a62 <fetchaddr+0x3e>

0000000080002a76 <fetchstr>:
{
    80002a76:	7179                	addi	sp,sp,-48
    80002a78:	f406                	sd	ra,40(sp)
    80002a7a:	f022                	sd	s0,32(sp)
    80002a7c:	ec26                	sd	s1,24(sp)
    80002a7e:	e84a                	sd	s2,16(sp)
    80002a80:	e44e                	sd	s3,8(sp)
    80002a82:	1800                	addi	s0,sp,48
    80002a84:	892a                	mv	s2,a0
    80002a86:	84ae                	mv	s1,a1
    80002a88:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002a8a:	fffff097          	auipc	ra,0xfffff
    80002a8e:	f22080e7          	jalr	-222(ra) # 800019ac <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002a92:	86ce                	mv	a3,s3
    80002a94:	864a                	mv	a2,s2
    80002a96:	85a6                	mv	a1,s1
    80002a98:	6928                	ld	a0,80(a0)
    80002a9a:	fffff097          	auipc	ra,0xfffff
    80002a9e:	cec080e7          	jalr	-788(ra) # 80001786 <copyinstr>
    80002aa2:	00054e63          	bltz	a0,80002abe <fetchstr+0x48>
  return strlen(buf);
    80002aa6:	8526                	mv	a0,s1
    80002aa8:	ffffe097          	auipc	ra,0xffffe
    80002aac:	3a6080e7          	jalr	934(ra) # 80000e4e <strlen>
}
    80002ab0:	70a2                	ld	ra,40(sp)
    80002ab2:	7402                	ld	s0,32(sp)
    80002ab4:	64e2                	ld	s1,24(sp)
    80002ab6:	6942                	ld	s2,16(sp)
    80002ab8:	69a2                	ld	s3,8(sp)
    80002aba:	6145                	addi	sp,sp,48
    80002abc:	8082                	ret
    return -1;
    80002abe:	557d                	li	a0,-1
    80002ac0:	bfc5                	j	80002ab0 <fetchstr+0x3a>

0000000080002ac2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002ac2:	1101                	addi	sp,sp,-32
    80002ac4:	ec06                	sd	ra,24(sp)
    80002ac6:	e822                	sd	s0,16(sp)
    80002ac8:	e426                	sd	s1,8(sp)
    80002aca:	1000                	addi	s0,sp,32
    80002acc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ace:	00000097          	auipc	ra,0x0
    80002ad2:	eee080e7          	jalr	-274(ra) # 800029bc <argraw>
    80002ad6:	c088                	sw	a0,0(s1)
}
    80002ad8:	60e2                	ld	ra,24(sp)
    80002ada:	6442                	ld	s0,16(sp)
    80002adc:	64a2                	ld	s1,8(sp)
    80002ade:	6105                	addi	sp,sp,32
    80002ae0:	8082                	ret

0000000080002ae2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002ae2:	1101                	addi	sp,sp,-32
    80002ae4:	ec06                	sd	ra,24(sp)
    80002ae6:	e822                	sd	s0,16(sp)
    80002ae8:	e426                	sd	s1,8(sp)
    80002aea:	1000                	addi	s0,sp,32
    80002aec:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002aee:	00000097          	auipc	ra,0x0
    80002af2:	ece080e7          	jalr	-306(ra) # 800029bc <argraw>
    80002af6:	e088                	sd	a0,0(s1)
}
    80002af8:	60e2                	ld	ra,24(sp)
    80002afa:	6442                	ld	s0,16(sp)
    80002afc:	64a2                	ld	s1,8(sp)
    80002afe:	6105                	addi	sp,sp,32
    80002b00:	8082                	ret

0000000080002b02 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b02:	7179                	addi	sp,sp,-48
    80002b04:	f406                	sd	ra,40(sp)
    80002b06:	f022                	sd	s0,32(sp)
    80002b08:	ec26                	sd	s1,24(sp)
    80002b0a:	e84a                	sd	s2,16(sp)
    80002b0c:	1800                	addi	s0,sp,48
    80002b0e:	84ae                	mv	s1,a1
    80002b10:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002b12:	fd840593          	addi	a1,s0,-40
    80002b16:	00000097          	auipc	ra,0x0
    80002b1a:	fcc080e7          	jalr	-52(ra) # 80002ae2 <argaddr>
  return fetchstr(addr, buf, max);
    80002b1e:	864a                	mv	a2,s2
    80002b20:	85a6                	mv	a1,s1
    80002b22:	fd843503          	ld	a0,-40(s0)
    80002b26:	00000097          	auipc	ra,0x0
    80002b2a:	f50080e7          	jalr	-176(ra) # 80002a76 <fetchstr>
}
    80002b2e:	70a2                	ld	ra,40(sp)
    80002b30:	7402                	ld	s0,32(sp)
    80002b32:	64e2                	ld	s1,24(sp)
    80002b34:	6942                	ld	s2,16(sp)
    80002b36:	6145                	addi	sp,sp,48
    80002b38:	8082                	ret

0000000080002b3a <syscall>:
[SYS_uniq]    sys_uniq,
};

void
syscall(void)
{
    80002b3a:	1101                	addi	sp,sp,-32
    80002b3c:	ec06                	sd	ra,24(sp)
    80002b3e:	e822                	sd	s0,16(sp)
    80002b40:	e426                	sd	s1,8(sp)
    80002b42:	e04a                	sd	s2,0(sp)
    80002b44:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b46:	fffff097          	auipc	ra,0xfffff
    80002b4a:	e66080e7          	jalr	-410(ra) # 800019ac <myproc>
    80002b4e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b50:	05853903          	ld	s2,88(a0)
    80002b54:	0a893783          	ld	a5,168(s2)
    80002b58:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b5c:	37fd                	addiw	a5,a5,-1
    80002b5e:	4759                	li	a4,22
    80002b60:	00f76f63          	bltu	a4,a5,80002b7e <syscall+0x44>
    80002b64:	00369713          	slli	a4,a3,0x3
    80002b68:	00006797          	auipc	a5,0x6
    80002b6c:	8e878793          	addi	a5,a5,-1816 # 80008450 <syscalls>
    80002b70:	97ba                	add	a5,a5,a4
    80002b72:	639c                	ld	a5,0(a5)
    80002b74:	c789                	beqz	a5,80002b7e <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002b76:	9782                	jalr	a5
    80002b78:	06a93823          	sd	a0,112(s2)
    80002b7c:	a839                	j	80002b9a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b7e:	15848613          	addi	a2,s1,344
    80002b82:	588c                	lw	a1,48(s1)
    80002b84:	00006517          	auipc	a0,0x6
    80002b88:	89450513          	addi	a0,a0,-1900 # 80008418 <states.0+0x150>
    80002b8c:	ffffe097          	auipc	ra,0xffffe
    80002b90:	9fe080e7          	jalr	-1538(ra) # 8000058a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b94:	6cbc                	ld	a5,88(s1)
    80002b96:	577d                	li	a4,-1
    80002b98:	fbb8                	sd	a4,112(a5)
  }
}
    80002b9a:	60e2                	ld	ra,24(sp)
    80002b9c:	6442                	ld	s0,16(sp)
    80002b9e:	64a2                	ld	s1,8(sp)
    80002ba0:	6902                	ld	s2,0(sp)
    80002ba2:	6105                	addi	sp,sp,32
    80002ba4:	8082                	ret

0000000080002ba6 <sys_head>:

  
  head(char ** files , int numOfLines);
  
*/
uint64 sys_head(void){
    80002ba6:	7131                	addi	sp,sp,-192
    80002ba8:	fd06                	sd	ra,184(sp)
    80002baa:	f922                	sd	s0,176(sp)
    80002bac:	f526                	sd	s1,168(sp)
    80002bae:	f14a                	sd	s2,160(sp)
    80002bb0:	ed4e                	sd	s3,152(sp)
    80002bb2:	e952                	sd	s4,144(sp)
    80002bb4:	e556                	sd	s5,136(sp)
    80002bb6:	e15a                	sd	s6,128(sp)
    80002bb8:	0180                	addi	s0,sp,192

  printf("Head command is getting executed in kernel mode\n");
    80002bba:	00006517          	auipc	a0,0x6
    80002bbe:	95650513          	addi	a0,a0,-1706 # 80008510 <syscalls+0xc0>
    80002bc2:	ffffe097          	auipc	ra,0xffffe
    80002bc6:	9c8080e7          	jalr	-1592(ra) # 8000058a <printf>

  uint64 passedFiles;
  uint64 lineCount;

  /* Fetching the first and the second arguments */
  argaddr(0, &passedFiles);
    80002bca:	fb840593          	addi	a1,s0,-72
    80002bce:	4501                	li	a0,0
    80002bd0:	00000097          	auipc	ra,0x0
    80002bd4:	f12080e7          	jalr	-238(ra) # 80002ae2 <argaddr>
  argint(1, &lineCount);
    80002bd8:	fb040593          	addi	a1,s0,-80
    80002bdc:	4505                	li	a0,1
    80002bde:	00000097          	auipc	ra,0x0
    80002be2:	ee4080e7          	jalr	-284(ra) # 80002ac2 <argint>

  /* Get number of files passed as argument*/
  uint64 files = passedFiles;
    80002be6:	fb843483          	ld	s1,-72(s0)
  uint64 fileAddr;
  uint32 numOfFiles=0;
  fetchaddr(files, &fileAddr);
    80002bea:	fa840593          	addi	a1,s0,-88
    80002bee:	8526                	mv	a0,s1
    80002bf0:	00000097          	auipc	ra,0x0
    80002bf4:	e34080e7          	jalr	-460(ra) # 80002a24 <fetchaddr>
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};
    80002bf8:	fa843783          	ld	a5,-88(s0)
    80002bfc:	c7a1                	beqz	a5,80002c44 <sys_head+0x9e>
  uint32 numOfFiles=0;
    80002bfe:	4901                	li	s2,0
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};
    80002c00:	04a1                	addi	s1,s1,8
    80002c02:	fa840593          	addi	a1,s0,-88
    80002c06:	8526                	mv	a0,s1
    80002c08:	00000097          	auipc	ra,0x0
    80002c0c:	e1c080e7          	jalr	-484(ra) # 80002a24 <fetchaddr>
    80002c10:	2905                	addiw	s2,s2,1
    80002c12:	fa843783          	ld	a5,-88(s0)
    80002c16:	f7ed                	bnez	a5,80002c00 <sys_head+0x5a>


  /* Fetching the first file */
  fetchaddr(passedFiles, &fileAddr);
    80002c18:	fa840593          	addi	a1,s0,-88
    80002c1c:	fb843503          	ld	a0,-72(s0)
    80002c20:	00000097          	auipc	ra,0x0
    80002c24:	e04080e7          	jalr	-508(ra) # 80002a24 <fetchaddr>

  /* Reading from STDIN */
  if(!fileAddr)
    80002c28:	fa843503          	ld	a0,-88(s0)
    80002c2c:	cd11                	beqz	a0,80002c48 <sys_head+0xa2>
      fetchstr(fileAddr, fileName, MAX_FILE_NAME_LEN);

      /* Open the given file */
      int fd = open_file(fileName, 0);
      
      if (fd == OPEN_FILE_ERROR)
    80002c2e:	59fd                	li	s3,-1
        printf("[ERR] opening the file '%s' failed \n",fileName);
      else{
        /* Only print the header if number of files is more than 1 */
        if (numOfFiles > 1) 
    80002c30:	4a05                	li	s4,1
          printf("==> %s <==\n",fileName);
    80002c32:	00006a97          	auipc	s5,0x6
    80002c36:	93ea8a93          	addi	s5,s5,-1730 # 80008570 <syscalls+0x120>
        printf("[ERR] opening the file '%s' failed \n",fileName);
    80002c3a:	00006b17          	auipc	s6,0x6
    80002c3e:	90eb0b13          	addi	s6,s6,-1778 # 80008548 <syscalls+0xf8>
    80002c42:	a095                	j	80002ca6 <sys_head+0x100>
  uint32 numOfFiles=0;
    80002c44:	4901                	li	s2,0
    80002c46:	bfc9                	j	80002c18 <sys_head+0x72>
    head_run(0, lineCount);
    80002c48:	fb042583          	lw	a1,-80(s0)
    80002c4c:	4501                	li	a0,0
    80002c4e:	00004097          	auipc	ra,0x4
    80002c52:	d2a080e7          	jalr	-726(ra) # 80006978 <head_run>
      fetchaddr(passedFiles, &fileAddr);
    }

  }
  return 0;
}
    80002c56:	4501                	li	a0,0
    80002c58:	70ea                	ld	ra,184(sp)
    80002c5a:	744a                	ld	s0,176(sp)
    80002c5c:	74aa                	ld	s1,168(sp)
    80002c5e:	790a                	ld	s2,160(sp)
    80002c60:	69ea                	ld	s3,152(sp)
    80002c62:	6a4a                	ld	s4,144(sp)
    80002c64:	6aaa                	ld	s5,136(sp)
    80002c66:	6b0a                	ld	s6,128(sp)
    80002c68:	6129                	addi	sp,sp,192
    80002c6a:	8082                	ret
        printf("[ERR] opening the file '%s' failed \n",fileName);
    80002c6c:	f4040593          	addi	a1,s0,-192
    80002c70:	855a                	mv	a0,s6
    80002c72:	ffffe097          	auipc	ra,0xffffe
    80002c76:	918080e7          	jalr	-1768(ra) # 8000058a <printf>
    80002c7a:	a801                	j	80002c8a <sys_head+0xe4>
        head_run(fd , lineCount);
    80002c7c:	fb042583          	lw	a1,-80(s0)
    80002c80:	8526                	mv	a0,s1
    80002c82:	00004097          	auipc	ra,0x4
    80002c86:	cf6080e7          	jalr	-778(ra) # 80006978 <head_run>
      passedFiles+=8;
    80002c8a:	fb843503          	ld	a0,-72(s0)
    80002c8e:	0521                	addi	a0,a0,8
    80002c90:	faa43c23          	sd	a0,-72(s0)
      fetchaddr(passedFiles, &fileAddr);
    80002c94:	fa840593          	addi	a1,s0,-88
    80002c98:	00000097          	auipc	ra,0x0
    80002c9c:	d8c080e7          	jalr	-628(ra) # 80002a24 <fetchaddr>
    while(fileAddr){
    80002ca0:	fa843503          	ld	a0,-88(s0)
    80002ca4:	d94d                	beqz	a0,80002c56 <sys_head+0xb0>
      fetchstr(fileAddr, fileName, MAX_FILE_NAME_LEN);
    80002ca6:	06400613          	li	a2,100
    80002caa:	f4040593          	addi	a1,s0,-192
    80002cae:	00000097          	auipc	ra,0x0
    80002cb2:	dc8080e7          	jalr	-568(ra) # 80002a76 <fetchstr>
      int fd = open_file(fileName, 0);
    80002cb6:	4581                	li	a1,0
    80002cb8:	f4040513          	addi	a0,s0,-192
    80002cbc:	00004097          	auipc	ra,0x4
    80002cc0:	86c080e7          	jalr	-1940(ra) # 80006528 <open_file>
    80002cc4:	84aa                	mv	s1,a0
      if (fd == OPEN_FILE_ERROR)
    80002cc6:	fb3503e3          	beq	a0,s3,80002c6c <sys_head+0xc6>
        if (numOfFiles > 1) 
    80002cca:	fb2a79e3          	bgeu	s4,s2,80002c7c <sys_head+0xd6>
          printf("==> %s <==\n",fileName);
    80002cce:	f4040593          	addi	a1,s0,-192
    80002cd2:	8556                	mv	a0,s5
    80002cd4:	ffffe097          	auipc	ra,0xffffe
    80002cd8:	8b6080e7          	jalr	-1866(ra) # 8000058a <printf>
    80002cdc:	b745                	j	80002c7c <sys_head+0xd6>

0000000080002cde <sys_uniq>:
#define OPT_SHOW_REPEATED_LINES 4




uint64 sys_uniq(void){
    80002cde:	7131                	addi	sp,sp,-192
    80002ce0:	fd06                	sd	ra,184(sp)
    80002ce2:	f922                	sd	s0,176(sp)
    80002ce4:	f526                	sd	s1,168(sp)
    80002ce6:	f14a                	sd	s2,160(sp)
    80002ce8:	ed4e                	sd	s3,152(sp)
    80002cea:	e952                	sd	s4,144(sp)
    80002cec:	e556                	sd	s5,136(sp)
    80002cee:	e15a                	sd	s6,128(sp)
    80002cf0:	0180                	addi	s0,sp,192

  printf("Uniq command is getting executed in kernel mode\n");
    80002cf2:	00006517          	auipc	a0,0x6
    80002cf6:	88e50513          	addi	a0,a0,-1906 # 80008580 <syscalls+0x130>
    80002cfa:	ffffe097          	auipc	ra,0xffffe
    80002cfe:	890080e7          	jalr	-1904(ra) # 8000058a <printf>

  uint64 passedFiles;
  uint64 options;

  /* Fetching the first and the second arguments */
  argaddr(0, &passedFiles);
    80002d02:	fb840593          	addi	a1,s0,-72
    80002d06:	4501                	li	a0,0
    80002d08:	00000097          	auipc	ra,0x0
    80002d0c:	dda080e7          	jalr	-550(ra) # 80002ae2 <argaddr>
  argint(1, &options);
    80002d10:	fb040593          	addi	a1,s0,-80
    80002d14:	4505                	li	a0,1
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	dac080e7          	jalr	-596(ra) # 80002ac2 <argint>


  /* Get number of files passed as argument*/
  uint64 files = passedFiles;
    80002d1e:	fb843483          	ld	s1,-72(s0)
  uint64 fileAddr;
  uint32 numOfFiles=0;
  fetchaddr(files, &fileAddr);
    80002d22:	fa840593          	addi	a1,s0,-88
    80002d26:	8526                	mv	a0,s1
    80002d28:	00000097          	auipc	ra,0x0
    80002d2c:	cfc080e7          	jalr	-772(ra) # 80002a24 <fetchaddr>
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};
    80002d30:	fa843783          	ld	a5,-88(s0)
    80002d34:	c7a1                	beqz	a5,80002d7c <sys_uniq+0x9e>
  uint32 numOfFiles=0;
    80002d36:	4901                	li	s2,0
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};
    80002d38:	04a1                	addi	s1,s1,8
    80002d3a:	fa840593          	addi	a1,s0,-88
    80002d3e:	8526                	mv	a0,s1
    80002d40:	00000097          	auipc	ra,0x0
    80002d44:	ce4080e7          	jalr	-796(ra) # 80002a24 <fetchaddr>
    80002d48:	2905                	addiw	s2,s2,1
    80002d4a:	fa843783          	ld	a5,-88(s0)
    80002d4e:	f7ed                	bnez	a5,80002d38 <sys_uniq+0x5a>



  /* Fetching the first file */
  fetchaddr(passedFiles, &fileAddr);
    80002d50:	fa840593          	addi	a1,s0,-88
    80002d54:	fb843503          	ld	a0,-72(s0)
    80002d58:	00000097          	auipc	ra,0x0
    80002d5c:	ccc080e7          	jalr	-820(ra) # 80002a24 <fetchaddr>




  /* Reading from STDIN */
  if(!fileAddr)
    80002d60:	fa843503          	ld	a0,-88(s0)
    80002d64:	cd11                	beqz	a0,80002d80 <sys_uniq+0xa2>

      // Open the given file

      int fd = open_file(fileName, 0);

      if (fd == OPEN_FILE_ERROR)
    80002d66:	59fd                	li	s3,-1
        printf("[ERR] Error opening the file '%s' \n", fileName);
      else{
        if (numOfFiles > 1) 
    80002d68:	4a05                	li	s4,1
          printf("==> %s <==\n",fileName);
    80002d6a:	00006a97          	auipc	s5,0x6
    80002d6e:	806a8a93          	addi	s5,s5,-2042 # 80008570 <syscalls+0x120>
        printf("[ERR] Error opening the file '%s' \n", fileName);
    80002d72:	00006b17          	auipc	s6,0x6
    80002d76:	846b0b13          	addi	s6,s6,-1978 # 800085b8 <syscalls+0x168>
    80002d7a:	a8a5                	j	80002df2 <sys_uniq+0x114>
  uint32 numOfFiles=0;
    80002d7c:	4901                	li	s2,0
    80002d7e:	bfc9                	j	80002d50 <sys_uniq+0x72>
    uniq_run(0, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
    80002d80:	fb044583          	lbu	a1,-80(s0)
    80002d84:	0045f693          	andi	a3,a1,4
    80002d88:	0025f613          	andi	a2,a1,2
    80002d8c:	8985                	andi	a1,a1,1
    80002d8e:	4501                	li	a0,0
    80002d90:	00004097          	auipc	ra,0x4
    80002d94:	c70080e7          	jalr	-912(ra) # 80006a00 <uniq_run>

    }

  }
  return 0;
}
    80002d98:	4501                	li	a0,0
    80002d9a:	70ea                	ld	ra,184(sp)
    80002d9c:	744a                	ld	s0,176(sp)
    80002d9e:	74aa                	ld	s1,168(sp)
    80002da0:	790a                	ld	s2,160(sp)
    80002da2:	69ea                	ld	s3,152(sp)
    80002da4:	6a4a                	ld	s4,144(sp)
    80002da6:	6aaa                	ld	s5,136(sp)
    80002da8:	6b0a                	ld	s6,128(sp)
    80002daa:	6129                	addi	sp,sp,192
    80002dac:	8082                	ret
        printf("[ERR] Error opening the file '%s' \n", fileName);
    80002dae:	f4040593          	addi	a1,s0,-192
    80002db2:	855a                	mv	a0,s6
    80002db4:	ffffd097          	auipc	ra,0xffffd
    80002db8:	7d6080e7          	jalr	2006(ra) # 8000058a <printf>
    80002dbc:	a829                	j	80002dd6 <sys_uniq+0xf8>
        uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
    80002dbe:	fb044583          	lbu	a1,-80(s0)
    80002dc2:	0045f693          	andi	a3,a1,4
    80002dc6:	0025f613          	andi	a2,a1,2
    80002dca:	8985                	andi	a1,a1,1
    80002dcc:	8526                	mv	a0,s1
    80002dce:	00004097          	auipc	ra,0x4
    80002dd2:	c32080e7          	jalr	-974(ra) # 80006a00 <uniq_run>
      passedFiles+=8; // TODO
    80002dd6:	fb843503          	ld	a0,-72(s0)
    80002dda:	0521                	addi	a0,a0,8
    80002ddc:	faa43c23          	sd	a0,-72(s0)
      fetchaddr(passedFiles, &fileAddr);
    80002de0:	fa840593          	addi	a1,s0,-88
    80002de4:	00000097          	auipc	ra,0x0
    80002de8:	c40080e7          	jalr	-960(ra) # 80002a24 <fetchaddr>
    while(fileAddr){
    80002dec:	fa843503          	ld	a0,-88(s0)
    80002df0:	d545                	beqz	a0,80002d98 <sys_uniq+0xba>
      fetchstr(fileAddr, fileName, MAX_FILE_NAME_LEN);
    80002df2:	06400613          	li	a2,100
    80002df6:	f4040593          	addi	a1,s0,-192
    80002dfa:	00000097          	auipc	ra,0x0
    80002dfe:	c7c080e7          	jalr	-900(ra) # 80002a76 <fetchstr>
      int fd = open_file(fileName, 0);
    80002e02:	4581                	li	a1,0
    80002e04:	f4040513          	addi	a0,s0,-192
    80002e08:	00003097          	auipc	ra,0x3
    80002e0c:	720080e7          	jalr	1824(ra) # 80006528 <open_file>
    80002e10:	84aa                	mv	s1,a0
      if (fd == OPEN_FILE_ERROR)
    80002e12:	f9350ee3          	beq	a0,s3,80002dae <sys_uniq+0xd0>
        if (numOfFiles > 1) 
    80002e16:	fb2a74e3          	bgeu	s4,s2,80002dbe <sys_uniq+0xe0>
          printf("==> %s <==\n",fileName);
    80002e1a:	f4040593          	addi	a1,s0,-192
    80002e1e:	8556                	mv	a0,s5
    80002e20:	ffffd097          	auipc	ra,0xffffd
    80002e24:	76a080e7          	jalr	1898(ra) # 8000058a <printf>
    80002e28:	bf59                	j	80002dbe <sys_uniq+0xe0>

0000000080002e2a <sys_exit>:



uint64
sys_exit(void)
{
    80002e2a:	1101                	addi	sp,sp,-32
    80002e2c:	ec06                	sd	ra,24(sp)
    80002e2e:	e822                	sd	s0,16(sp)
    80002e30:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002e32:	fec40593          	addi	a1,s0,-20
    80002e36:	4501                	li	a0,0
    80002e38:	00000097          	auipc	ra,0x0
    80002e3c:	c8a080e7          	jalr	-886(ra) # 80002ac2 <argint>
  exit(n);
    80002e40:	fec42503          	lw	a0,-20(s0)
    80002e44:	fffff097          	auipc	ra,0xfffff
    80002e48:	344080e7          	jalr	836(ra) # 80002188 <exit>
  return 0;  // not reached
}
    80002e4c:	4501                	li	a0,0
    80002e4e:	60e2                	ld	ra,24(sp)
    80002e50:	6442                	ld	s0,16(sp)
    80002e52:	6105                	addi	sp,sp,32
    80002e54:	8082                	ret

0000000080002e56 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002e56:	1141                	addi	sp,sp,-16
    80002e58:	e406                	sd	ra,8(sp)
    80002e5a:	e022                	sd	s0,0(sp)
    80002e5c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002e5e:	fffff097          	auipc	ra,0xfffff
    80002e62:	b4e080e7          	jalr	-1202(ra) # 800019ac <myproc>
}
    80002e66:	5908                	lw	a0,48(a0)
    80002e68:	60a2                	ld	ra,8(sp)
    80002e6a:	6402                	ld	s0,0(sp)
    80002e6c:	0141                	addi	sp,sp,16
    80002e6e:	8082                	ret

0000000080002e70 <sys_fork>:

uint64
sys_fork(void)
{
    80002e70:	1141                	addi	sp,sp,-16
    80002e72:	e406                	sd	ra,8(sp)
    80002e74:	e022                	sd	s0,0(sp)
    80002e76:	0800                	addi	s0,sp,16
  return fork();
    80002e78:	fffff097          	auipc	ra,0xfffff
    80002e7c:	eea080e7          	jalr	-278(ra) # 80001d62 <fork>
}
    80002e80:	60a2                	ld	ra,8(sp)
    80002e82:	6402                	ld	s0,0(sp)
    80002e84:	0141                	addi	sp,sp,16
    80002e86:	8082                	ret

0000000080002e88 <sys_wait>:

uint64
sys_wait(void)
{
    80002e88:	1101                	addi	sp,sp,-32
    80002e8a:	ec06                	sd	ra,24(sp)
    80002e8c:	e822                	sd	s0,16(sp)
    80002e8e:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002e90:	fe840593          	addi	a1,s0,-24
    80002e94:	4501                	li	a0,0
    80002e96:	00000097          	auipc	ra,0x0
    80002e9a:	c4c080e7          	jalr	-948(ra) # 80002ae2 <argaddr>
  return wait(p);
    80002e9e:	fe843503          	ld	a0,-24(s0)
    80002ea2:	fffff097          	auipc	ra,0xfffff
    80002ea6:	48c080e7          	jalr	1164(ra) # 8000232e <wait>
}
    80002eaa:	60e2                	ld	ra,24(sp)
    80002eac:	6442                	ld	s0,16(sp)
    80002eae:	6105                	addi	sp,sp,32
    80002eb0:	8082                	ret

0000000080002eb2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002eb2:	7179                	addi	sp,sp,-48
    80002eb4:	f406                	sd	ra,40(sp)
    80002eb6:	f022                	sd	s0,32(sp)
    80002eb8:	ec26                	sd	s1,24(sp)
    80002eba:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002ebc:	fdc40593          	addi	a1,s0,-36
    80002ec0:	4501                	li	a0,0
    80002ec2:	00000097          	auipc	ra,0x0
    80002ec6:	c00080e7          	jalr	-1024(ra) # 80002ac2 <argint>
  addr = myproc()->sz;
    80002eca:	fffff097          	auipc	ra,0xfffff
    80002ece:	ae2080e7          	jalr	-1310(ra) # 800019ac <myproc>
    80002ed2:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002ed4:	fdc42503          	lw	a0,-36(s0)
    80002ed8:	fffff097          	auipc	ra,0xfffff
    80002edc:	e2e080e7          	jalr	-466(ra) # 80001d06 <growproc>
    80002ee0:	00054863          	bltz	a0,80002ef0 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002ee4:	8526                	mv	a0,s1
    80002ee6:	70a2                	ld	ra,40(sp)
    80002ee8:	7402                	ld	s0,32(sp)
    80002eea:	64e2                	ld	s1,24(sp)
    80002eec:	6145                	addi	sp,sp,48
    80002eee:	8082                	ret
    return -1;
    80002ef0:	54fd                	li	s1,-1
    80002ef2:	bfcd                	j	80002ee4 <sys_sbrk+0x32>

0000000080002ef4 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002ef4:	7139                	addi	sp,sp,-64
    80002ef6:	fc06                	sd	ra,56(sp)
    80002ef8:	f822                	sd	s0,48(sp)
    80002efa:	f426                	sd	s1,40(sp)
    80002efc:	f04a                	sd	s2,32(sp)
    80002efe:	ec4e                	sd	s3,24(sp)
    80002f00:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002f02:	fcc40593          	addi	a1,s0,-52
    80002f06:	4501                	li	a0,0
    80002f08:	00000097          	auipc	ra,0x0
    80002f0c:	bba080e7          	jalr	-1094(ra) # 80002ac2 <argint>
  acquire(&tickslock);
    80002f10:	00014517          	auipc	a0,0x14
    80002f14:	be050513          	addi	a0,a0,-1056 # 80016af0 <tickslock>
    80002f18:	ffffe097          	auipc	ra,0xffffe
    80002f1c:	cbe080e7          	jalr	-834(ra) # 80000bd6 <acquire>
  ticks0 = ticks;
    80002f20:	00006917          	auipc	s2,0x6
    80002f24:	b3092903          	lw	s2,-1232(s2) # 80008a50 <ticks>
  while(ticks - ticks0 < n){
    80002f28:	fcc42783          	lw	a5,-52(s0)
    80002f2c:	cf9d                	beqz	a5,80002f6a <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002f2e:	00014997          	auipc	s3,0x14
    80002f32:	bc298993          	addi	s3,s3,-1086 # 80016af0 <tickslock>
    80002f36:	00006497          	auipc	s1,0x6
    80002f3a:	b1a48493          	addi	s1,s1,-1254 # 80008a50 <ticks>
    if(killed(myproc())){
    80002f3e:	fffff097          	auipc	ra,0xfffff
    80002f42:	a6e080e7          	jalr	-1426(ra) # 800019ac <myproc>
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	3b6080e7          	jalr	950(ra) # 800022fc <killed>
    80002f4e:	ed15                	bnez	a0,80002f8a <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002f50:	85ce                	mv	a1,s3
    80002f52:	8526                	mv	a0,s1
    80002f54:	fffff097          	auipc	ra,0xfffff
    80002f58:	100080e7          	jalr	256(ra) # 80002054 <sleep>
  while(ticks - ticks0 < n){
    80002f5c:	409c                	lw	a5,0(s1)
    80002f5e:	412787bb          	subw	a5,a5,s2
    80002f62:	fcc42703          	lw	a4,-52(s0)
    80002f66:	fce7ece3          	bltu	a5,a4,80002f3e <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002f6a:	00014517          	auipc	a0,0x14
    80002f6e:	b8650513          	addi	a0,a0,-1146 # 80016af0 <tickslock>
    80002f72:	ffffe097          	auipc	ra,0xffffe
    80002f76:	d18080e7          	jalr	-744(ra) # 80000c8a <release>
  return 0;
    80002f7a:	4501                	li	a0,0
}
    80002f7c:	70e2                	ld	ra,56(sp)
    80002f7e:	7442                	ld	s0,48(sp)
    80002f80:	74a2                	ld	s1,40(sp)
    80002f82:	7902                	ld	s2,32(sp)
    80002f84:	69e2                	ld	s3,24(sp)
    80002f86:	6121                	addi	sp,sp,64
    80002f88:	8082                	ret
      release(&tickslock);
    80002f8a:	00014517          	auipc	a0,0x14
    80002f8e:	b6650513          	addi	a0,a0,-1178 # 80016af0 <tickslock>
    80002f92:	ffffe097          	auipc	ra,0xffffe
    80002f96:	cf8080e7          	jalr	-776(ra) # 80000c8a <release>
      return -1;
    80002f9a:	557d                	li	a0,-1
    80002f9c:	b7c5                	j	80002f7c <sys_sleep+0x88>

0000000080002f9e <sys_kill>:

uint64
sys_kill(void)
{
    80002f9e:	1101                	addi	sp,sp,-32
    80002fa0:	ec06                	sd	ra,24(sp)
    80002fa2:	e822                	sd	s0,16(sp)
    80002fa4:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002fa6:	fec40593          	addi	a1,s0,-20
    80002faa:	4501                	li	a0,0
    80002fac:	00000097          	auipc	ra,0x0
    80002fb0:	b16080e7          	jalr	-1258(ra) # 80002ac2 <argint>
  return kill(pid);
    80002fb4:	fec42503          	lw	a0,-20(s0)
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	2a6080e7          	jalr	678(ra) # 8000225e <kill>
}
    80002fc0:	60e2                	ld	ra,24(sp)
    80002fc2:	6442                	ld	s0,16(sp)
    80002fc4:	6105                	addi	sp,sp,32
    80002fc6:	8082                	ret

0000000080002fc8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002fc8:	1101                	addi	sp,sp,-32
    80002fca:	ec06                	sd	ra,24(sp)
    80002fcc:	e822                	sd	s0,16(sp)
    80002fce:	e426                	sd	s1,8(sp)
    80002fd0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002fd2:	00014517          	auipc	a0,0x14
    80002fd6:	b1e50513          	addi	a0,a0,-1250 # 80016af0 <tickslock>
    80002fda:	ffffe097          	auipc	ra,0xffffe
    80002fde:	bfc080e7          	jalr	-1028(ra) # 80000bd6 <acquire>
  xticks = ticks;
    80002fe2:	00006497          	auipc	s1,0x6
    80002fe6:	a6e4a483          	lw	s1,-1426(s1) # 80008a50 <ticks>
  release(&tickslock);
    80002fea:	00014517          	auipc	a0,0x14
    80002fee:	b0650513          	addi	a0,a0,-1274 # 80016af0 <tickslock>
    80002ff2:	ffffe097          	auipc	ra,0xffffe
    80002ff6:	c98080e7          	jalr	-872(ra) # 80000c8a <release>
  return xticks;
}
    80002ffa:	02049513          	slli	a0,s1,0x20
    80002ffe:	9101                	srli	a0,a0,0x20
    80003000:	60e2                	ld	ra,24(sp)
    80003002:	6442                	ld	s0,16(sp)
    80003004:	64a2                	ld	s1,8(sp)
    80003006:	6105                	addi	sp,sp,32
    80003008:	8082                	ret

000000008000300a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000300a:	7179                	addi	sp,sp,-48
    8000300c:	f406                	sd	ra,40(sp)
    8000300e:	f022                	sd	s0,32(sp)
    80003010:	ec26                	sd	s1,24(sp)
    80003012:	e84a                	sd	s2,16(sp)
    80003014:	e44e                	sd	s3,8(sp)
    80003016:	e052                	sd	s4,0(sp)
    80003018:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000301a:	00005597          	auipc	a1,0x5
    8000301e:	5c658593          	addi	a1,a1,1478 # 800085e0 <syscalls+0x190>
    80003022:	00014517          	auipc	a0,0x14
    80003026:	ae650513          	addi	a0,a0,-1306 # 80016b08 <bcache>
    8000302a:	ffffe097          	auipc	ra,0xffffe
    8000302e:	b1c080e7          	jalr	-1252(ra) # 80000b46 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003032:	0001c797          	auipc	a5,0x1c
    80003036:	ad678793          	addi	a5,a5,-1322 # 8001eb08 <bcache+0x8000>
    8000303a:	0001c717          	auipc	a4,0x1c
    8000303e:	d3670713          	addi	a4,a4,-714 # 8001ed70 <bcache+0x8268>
    80003042:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003046:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000304a:	00014497          	auipc	s1,0x14
    8000304e:	ad648493          	addi	s1,s1,-1322 # 80016b20 <bcache+0x18>
    b->next = bcache.head.next;
    80003052:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003054:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003056:	00005a17          	auipc	s4,0x5
    8000305a:	592a0a13          	addi	s4,s4,1426 # 800085e8 <syscalls+0x198>
    b->next = bcache.head.next;
    8000305e:	2b893783          	ld	a5,696(s2)
    80003062:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003064:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003068:	85d2                	mv	a1,s4
    8000306a:	01048513          	addi	a0,s1,16
    8000306e:	00001097          	auipc	ra,0x1
    80003072:	4c8080e7          	jalr	1224(ra) # 80004536 <initsleeplock>
    bcache.head.next->prev = b;
    80003076:	2b893783          	ld	a5,696(s2)
    8000307a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000307c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003080:	45848493          	addi	s1,s1,1112
    80003084:	fd349de3          	bne	s1,s3,8000305e <binit+0x54>
  }
}
    80003088:	70a2                	ld	ra,40(sp)
    8000308a:	7402                	ld	s0,32(sp)
    8000308c:	64e2                	ld	s1,24(sp)
    8000308e:	6942                	ld	s2,16(sp)
    80003090:	69a2                	ld	s3,8(sp)
    80003092:	6a02                	ld	s4,0(sp)
    80003094:	6145                	addi	sp,sp,48
    80003096:	8082                	ret

0000000080003098 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003098:	7179                	addi	sp,sp,-48
    8000309a:	f406                	sd	ra,40(sp)
    8000309c:	f022                	sd	s0,32(sp)
    8000309e:	ec26                	sd	s1,24(sp)
    800030a0:	e84a                	sd	s2,16(sp)
    800030a2:	e44e                	sd	s3,8(sp)
    800030a4:	1800                	addi	s0,sp,48
    800030a6:	892a                	mv	s2,a0
    800030a8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800030aa:	00014517          	auipc	a0,0x14
    800030ae:	a5e50513          	addi	a0,a0,-1442 # 80016b08 <bcache>
    800030b2:	ffffe097          	auipc	ra,0xffffe
    800030b6:	b24080e7          	jalr	-1244(ra) # 80000bd6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800030ba:	0001c497          	auipc	s1,0x1c
    800030be:	d064b483          	ld	s1,-762(s1) # 8001edc0 <bcache+0x82b8>
    800030c2:	0001c797          	auipc	a5,0x1c
    800030c6:	cae78793          	addi	a5,a5,-850 # 8001ed70 <bcache+0x8268>
    800030ca:	02f48f63          	beq	s1,a5,80003108 <bread+0x70>
    800030ce:	873e                	mv	a4,a5
    800030d0:	a021                	j	800030d8 <bread+0x40>
    800030d2:	68a4                	ld	s1,80(s1)
    800030d4:	02e48a63          	beq	s1,a4,80003108 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800030d8:	449c                	lw	a5,8(s1)
    800030da:	ff279ce3          	bne	a5,s2,800030d2 <bread+0x3a>
    800030de:	44dc                	lw	a5,12(s1)
    800030e0:	ff3799e3          	bne	a5,s3,800030d2 <bread+0x3a>
      b->refcnt++;
    800030e4:	40bc                	lw	a5,64(s1)
    800030e6:	2785                	addiw	a5,a5,1
    800030e8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800030ea:	00014517          	auipc	a0,0x14
    800030ee:	a1e50513          	addi	a0,a0,-1506 # 80016b08 <bcache>
    800030f2:	ffffe097          	auipc	ra,0xffffe
    800030f6:	b98080e7          	jalr	-1128(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    800030fa:	01048513          	addi	a0,s1,16
    800030fe:	00001097          	auipc	ra,0x1
    80003102:	472080e7          	jalr	1138(ra) # 80004570 <acquiresleep>
      return b;
    80003106:	a8b9                	j	80003164 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003108:	0001c497          	auipc	s1,0x1c
    8000310c:	cb04b483          	ld	s1,-848(s1) # 8001edb8 <bcache+0x82b0>
    80003110:	0001c797          	auipc	a5,0x1c
    80003114:	c6078793          	addi	a5,a5,-928 # 8001ed70 <bcache+0x8268>
    80003118:	00f48863          	beq	s1,a5,80003128 <bread+0x90>
    8000311c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000311e:	40bc                	lw	a5,64(s1)
    80003120:	cf81                	beqz	a5,80003138 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003122:	64a4                	ld	s1,72(s1)
    80003124:	fee49de3          	bne	s1,a4,8000311e <bread+0x86>
  panic("bget: no buffers");
    80003128:	00005517          	auipc	a0,0x5
    8000312c:	4c850513          	addi	a0,a0,1224 # 800085f0 <syscalls+0x1a0>
    80003130:	ffffd097          	auipc	ra,0xffffd
    80003134:	410080e7          	jalr	1040(ra) # 80000540 <panic>
      b->dev = dev;
    80003138:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000313c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003140:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003144:	4785                	li	a5,1
    80003146:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003148:	00014517          	auipc	a0,0x14
    8000314c:	9c050513          	addi	a0,a0,-1600 # 80016b08 <bcache>
    80003150:	ffffe097          	auipc	ra,0xffffe
    80003154:	b3a080e7          	jalr	-1222(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    80003158:	01048513          	addi	a0,s1,16
    8000315c:	00001097          	auipc	ra,0x1
    80003160:	414080e7          	jalr	1044(ra) # 80004570 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003164:	409c                	lw	a5,0(s1)
    80003166:	cb89                	beqz	a5,80003178 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003168:	8526                	mv	a0,s1
    8000316a:	70a2                	ld	ra,40(sp)
    8000316c:	7402                	ld	s0,32(sp)
    8000316e:	64e2                	ld	s1,24(sp)
    80003170:	6942                	ld	s2,16(sp)
    80003172:	69a2                	ld	s3,8(sp)
    80003174:	6145                	addi	sp,sp,48
    80003176:	8082                	ret
    virtio_disk_rw(b, 0);
    80003178:	4581                	li	a1,0
    8000317a:	8526                	mv	a0,s1
    8000317c:	00003097          	auipc	ra,0x3
    80003180:	0c6080e7          	jalr	198(ra) # 80006242 <virtio_disk_rw>
    b->valid = 1;
    80003184:	4785                	li	a5,1
    80003186:	c09c                	sw	a5,0(s1)
  return b;
    80003188:	b7c5                	j	80003168 <bread+0xd0>

000000008000318a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000318a:	1101                	addi	sp,sp,-32
    8000318c:	ec06                	sd	ra,24(sp)
    8000318e:	e822                	sd	s0,16(sp)
    80003190:	e426                	sd	s1,8(sp)
    80003192:	1000                	addi	s0,sp,32
    80003194:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003196:	0541                	addi	a0,a0,16
    80003198:	00001097          	auipc	ra,0x1
    8000319c:	472080e7          	jalr	1138(ra) # 8000460a <holdingsleep>
    800031a0:	cd01                	beqz	a0,800031b8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800031a2:	4585                	li	a1,1
    800031a4:	8526                	mv	a0,s1
    800031a6:	00003097          	auipc	ra,0x3
    800031aa:	09c080e7          	jalr	156(ra) # 80006242 <virtio_disk_rw>
}
    800031ae:	60e2                	ld	ra,24(sp)
    800031b0:	6442                	ld	s0,16(sp)
    800031b2:	64a2                	ld	s1,8(sp)
    800031b4:	6105                	addi	sp,sp,32
    800031b6:	8082                	ret
    panic("bwrite");
    800031b8:	00005517          	auipc	a0,0x5
    800031bc:	45050513          	addi	a0,a0,1104 # 80008608 <syscalls+0x1b8>
    800031c0:	ffffd097          	auipc	ra,0xffffd
    800031c4:	380080e7          	jalr	896(ra) # 80000540 <panic>

00000000800031c8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800031c8:	1101                	addi	sp,sp,-32
    800031ca:	ec06                	sd	ra,24(sp)
    800031cc:	e822                	sd	s0,16(sp)
    800031ce:	e426                	sd	s1,8(sp)
    800031d0:	e04a                	sd	s2,0(sp)
    800031d2:	1000                	addi	s0,sp,32
    800031d4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031d6:	01050913          	addi	s2,a0,16
    800031da:	854a                	mv	a0,s2
    800031dc:	00001097          	auipc	ra,0x1
    800031e0:	42e080e7          	jalr	1070(ra) # 8000460a <holdingsleep>
    800031e4:	c92d                	beqz	a0,80003256 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800031e6:	854a                	mv	a0,s2
    800031e8:	00001097          	auipc	ra,0x1
    800031ec:	3de080e7          	jalr	990(ra) # 800045c6 <releasesleep>

  acquire(&bcache.lock);
    800031f0:	00014517          	auipc	a0,0x14
    800031f4:	91850513          	addi	a0,a0,-1768 # 80016b08 <bcache>
    800031f8:	ffffe097          	auipc	ra,0xffffe
    800031fc:	9de080e7          	jalr	-1570(ra) # 80000bd6 <acquire>
  b->refcnt--;
    80003200:	40bc                	lw	a5,64(s1)
    80003202:	37fd                	addiw	a5,a5,-1
    80003204:	0007871b          	sext.w	a4,a5
    80003208:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000320a:	eb05                	bnez	a4,8000323a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000320c:	68bc                	ld	a5,80(s1)
    8000320e:	64b8                	ld	a4,72(s1)
    80003210:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003212:	64bc                	ld	a5,72(s1)
    80003214:	68b8                	ld	a4,80(s1)
    80003216:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003218:	0001c797          	auipc	a5,0x1c
    8000321c:	8f078793          	addi	a5,a5,-1808 # 8001eb08 <bcache+0x8000>
    80003220:	2b87b703          	ld	a4,696(a5)
    80003224:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003226:	0001c717          	auipc	a4,0x1c
    8000322a:	b4a70713          	addi	a4,a4,-1206 # 8001ed70 <bcache+0x8268>
    8000322e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003230:	2b87b703          	ld	a4,696(a5)
    80003234:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003236:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000323a:	00014517          	auipc	a0,0x14
    8000323e:	8ce50513          	addi	a0,a0,-1842 # 80016b08 <bcache>
    80003242:	ffffe097          	auipc	ra,0xffffe
    80003246:	a48080e7          	jalr	-1464(ra) # 80000c8a <release>
}
    8000324a:	60e2                	ld	ra,24(sp)
    8000324c:	6442                	ld	s0,16(sp)
    8000324e:	64a2                	ld	s1,8(sp)
    80003250:	6902                	ld	s2,0(sp)
    80003252:	6105                	addi	sp,sp,32
    80003254:	8082                	ret
    panic("brelse");
    80003256:	00005517          	auipc	a0,0x5
    8000325a:	3ba50513          	addi	a0,a0,954 # 80008610 <syscalls+0x1c0>
    8000325e:	ffffd097          	auipc	ra,0xffffd
    80003262:	2e2080e7          	jalr	738(ra) # 80000540 <panic>

0000000080003266 <bpin>:

void
bpin(struct buf *b) {
    80003266:	1101                	addi	sp,sp,-32
    80003268:	ec06                	sd	ra,24(sp)
    8000326a:	e822                	sd	s0,16(sp)
    8000326c:	e426                	sd	s1,8(sp)
    8000326e:	1000                	addi	s0,sp,32
    80003270:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003272:	00014517          	auipc	a0,0x14
    80003276:	89650513          	addi	a0,a0,-1898 # 80016b08 <bcache>
    8000327a:	ffffe097          	auipc	ra,0xffffe
    8000327e:	95c080e7          	jalr	-1700(ra) # 80000bd6 <acquire>
  b->refcnt++;
    80003282:	40bc                	lw	a5,64(s1)
    80003284:	2785                	addiw	a5,a5,1
    80003286:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003288:	00014517          	auipc	a0,0x14
    8000328c:	88050513          	addi	a0,a0,-1920 # 80016b08 <bcache>
    80003290:	ffffe097          	auipc	ra,0xffffe
    80003294:	9fa080e7          	jalr	-1542(ra) # 80000c8a <release>
}
    80003298:	60e2                	ld	ra,24(sp)
    8000329a:	6442                	ld	s0,16(sp)
    8000329c:	64a2                	ld	s1,8(sp)
    8000329e:	6105                	addi	sp,sp,32
    800032a0:	8082                	ret

00000000800032a2 <bunpin>:

void
bunpin(struct buf *b) {
    800032a2:	1101                	addi	sp,sp,-32
    800032a4:	ec06                	sd	ra,24(sp)
    800032a6:	e822                	sd	s0,16(sp)
    800032a8:	e426                	sd	s1,8(sp)
    800032aa:	1000                	addi	s0,sp,32
    800032ac:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800032ae:	00014517          	auipc	a0,0x14
    800032b2:	85a50513          	addi	a0,a0,-1958 # 80016b08 <bcache>
    800032b6:	ffffe097          	auipc	ra,0xffffe
    800032ba:	920080e7          	jalr	-1760(ra) # 80000bd6 <acquire>
  b->refcnt--;
    800032be:	40bc                	lw	a5,64(s1)
    800032c0:	37fd                	addiw	a5,a5,-1
    800032c2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800032c4:	00014517          	auipc	a0,0x14
    800032c8:	84450513          	addi	a0,a0,-1980 # 80016b08 <bcache>
    800032cc:	ffffe097          	auipc	ra,0xffffe
    800032d0:	9be080e7          	jalr	-1602(ra) # 80000c8a <release>
}
    800032d4:	60e2                	ld	ra,24(sp)
    800032d6:	6442                	ld	s0,16(sp)
    800032d8:	64a2                	ld	s1,8(sp)
    800032da:	6105                	addi	sp,sp,32
    800032dc:	8082                	ret

00000000800032de <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800032de:	1101                	addi	sp,sp,-32
    800032e0:	ec06                	sd	ra,24(sp)
    800032e2:	e822                	sd	s0,16(sp)
    800032e4:	e426                	sd	s1,8(sp)
    800032e6:	e04a                	sd	s2,0(sp)
    800032e8:	1000                	addi	s0,sp,32
    800032ea:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800032ec:	00d5d59b          	srliw	a1,a1,0xd
    800032f0:	0001c797          	auipc	a5,0x1c
    800032f4:	ef47a783          	lw	a5,-268(a5) # 8001f1e4 <sb+0x1c>
    800032f8:	9dbd                	addw	a1,a1,a5
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	d9e080e7          	jalr	-610(ra) # 80003098 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003302:	0074f713          	andi	a4,s1,7
    80003306:	4785                	li	a5,1
    80003308:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000330c:	14ce                	slli	s1,s1,0x33
    8000330e:	90d9                	srli	s1,s1,0x36
    80003310:	00950733          	add	a4,a0,s1
    80003314:	05874703          	lbu	a4,88(a4)
    80003318:	00e7f6b3          	and	a3,a5,a4
    8000331c:	c69d                	beqz	a3,8000334a <bfree+0x6c>
    8000331e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003320:	94aa                	add	s1,s1,a0
    80003322:	fff7c793          	not	a5,a5
    80003326:	8f7d                	and	a4,a4,a5
    80003328:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000332c:	00001097          	auipc	ra,0x1
    80003330:	126080e7          	jalr	294(ra) # 80004452 <log_write>
  brelse(bp);
    80003334:	854a                	mv	a0,s2
    80003336:	00000097          	auipc	ra,0x0
    8000333a:	e92080e7          	jalr	-366(ra) # 800031c8 <brelse>
}
    8000333e:	60e2                	ld	ra,24(sp)
    80003340:	6442                	ld	s0,16(sp)
    80003342:	64a2                	ld	s1,8(sp)
    80003344:	6902                	ld	s2,0(sp)
    80003346:	6105                	addi	sp,sp,32
    80003348:	8082                	ret
    panic("freeing free block");
    8000334a:	00005517          	auipc	a0,0x5
    8000334e:	2ce50513          	addi	a0,a0,718 # 80008618 <syscalls+0x1c8>
    80003352:	ffffd097          	auipc	ra,0xffffd
    80003356:	1ee080e7          	jalr	494(ra) # 80000540 <panic>

000000008000335a <balloc>:
{
    8000335a:	711d                	addi	sp,sp,-96
    8000335c:	ec86                	sd	ra,88(sp)
    8000335e:	e8a2                	sd	s0,80(sp)
    80003360:	e4a6                	sd	s1,72(sp)
    80003362:	e0ca                	sd	s2,64(sp)
    80003364:	fc4e                	sd	s3,56(sp)
    80003366:	f852                	sd	s4,48(sp)
    80003368:	f456                	sd	s5,40(sp)
    8000336a:	f05a                	sd	s6,32(sp)
    8000336c:	ec5e                	sd	s7,24(sp)
    8000336e:	e862                	sd	s8,16(sp)
    80003370:	e466                	sd	s9,8(sp)
    80003372:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003374:	0001c797          	auipc	a5,0x1c
    80003378:	e587a783          	lw	a5,-424(a5) # 8001f1cc <sb+0x4>
    8000337c:	cff5                	beqz	a5,80003478 <balloc+0x11e>
    8000337e:	8baa                	mv	s7,a0
    80003380:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003382:	0001cb17          	auipc	s6,0x1c
    80003386:	e46b0b13          	addi	s6,s6,-442 # 8001f1c8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000338a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000338c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000338e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003390:	6c89                	lui	s9,0x2
    80003392:	a061                	j	8000341a <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003394:	97ca                	add	a5,a5,s2
    80003396:	8e55                	or	a2,a2,a3
    80003398:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000339c:	854a                	mv	a0,s2
    8000339e:	00001097          	auipc	ra,0x1
    800033a2:	0b4080e7          	jalr	180(ra) # 80004452 <log_write>
        brelse(bp);
    800033a6:	854a                	mv	a0,s2
    800033a8:	00000097          	auipc	ra,0x0
    800033ac:	e20080e7          	jalr	-480(ra) # 800031c8 <brelse>
  bp = bread(dev, bno);
    800033b0:	85a6                	mv	a1,s1
    800033b2:	855e                	mv	a0,s7
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	ce4080e7          	jalr	-796(ra) # 80003098 <bread>
    800033bc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800033be:	40000613          	li	a2,1024
    800033c2:	4581                	li	a1,0
    800033c4:	05850513          	addi	a0,a0,88
    800033c8:	ffffe097          	auipc	ra,0xffffe
    800033cc:	90a080e7          	jalr	-1782(ra) # 80000cd2 <memset>
  log_write(bp);
    800033d0:	854a                	mv	a0,s2
    800033d2:	00001097          	auipc	ra,0x1
    800033d6:	080080e7          	jalr	128(ra) # 80004452 <log_write>
  brelse(bp);
    800033da:	854a                	mv	a0,s2
    800033dc:	00000097          	auipc	ra,0x0
    800033e0:	dec080e7          	jalr	-532(ra) # 800031c8 <brelse>
}
    800033e4:	8526                	mv	a0,s1
    800033e6:	60e6                	ld	ra,88(sp)
    800033e8:	6446                	ld	s0,80(sp)
    800033ea:	64a6                	ld	s1,72(sp)
    800033ec:	6906                	ld	s2,64(sp)
    800033ee:	79e2                	ld	s3,56(sp)
    800033f0:	7a42                	ld	s4,48(sp)
    800033f2:	7aa2                	ld	s5,40(sp)
    800033f4:	7b02                	ld	s6,32(sp)
    800033f6:	6be2                	ld	s7,24(sp)
    800033f8:	6c42                	ld	s8,16(sp)
    800033fa:	6ca2                	ld	s9,8(sp)
    800033fc:	6125                	addi	sp,sp,96
    800033fe:	8082                	ret
    brelse(bp);
    80003400:	854a                	mv	a0,s2
    80003402:	00000097          	auipc	ra,0x0
    80003406:	dc6080e7          	jalr	-570(ra) # 800031c8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000340a:	015c87bb          	addw	a5,s9,s5
    8000340e:	00078a9b          	sext.w	s5,a5
    80003412:	004b2703          	lw	a4,4(s6)
    80003416:	06eaf163          	bgeu	s5,a4,80003478 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000341a:	41fad79b          	sraiw	a5,s5,0x1f
    8000341e:	0137d79b          	srliw	a5,a5,0x13
    80003422:	015787bb          	addw	a5,a5,s5
    80003426:	40d7d79b          	sraiw	a5,a5,0xd
    8000342a:	01cb2583          	lw	a1,28(s6)
    8000342e:	9dbd                	addw	a1,a1,a5
    80003430:	855e                	mv	a0,s7
    80003432:	00000097          	auipc	ra,0x0
    80003436:	c66080e7          	jalr	-922(ra) # 80003098 <bread>
    8000343a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000343c:	004b2503          	lw	a0,4(s6)
    80003440:	000a849b          	sext.w	s1,s5
    80003444:	8762                	mv	a4,s8
    80003446:	faa4fde3          	bgeu	s1,a0,80003400 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000344a:	00777693          	andi	a3,a4,7
    8000344e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003452:	41f7579b          	sraiw	a5,a4,0x1f
    80003456:	01d7d79b          	srliw	a5,a5,0x1d
    8000345a:	9fb9                	addw	a5,a5,a4
    8000345c:	4037d79b          	sraiw	a5,a5,0x3
    80003460:	00f90633          	add	a2,s2,a5
    80003464:	05864603          	lbu	a2,88(a2)
    80003468:	00c6f5b3          	and	a1,a3,a2
    8000346c:	d585                	beqz	a1,80003394 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000346e:	2705                	addiw	a4,a4,1
    80003470:	2485                	addiw	s1,s1,1
    80003472:	fd471ae3          	bne	a4,s4,80003446 <balloc+0xec>
    80003476:	b769                	j	80003400 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003478:	00005517          	auipc	a0,0x5
    8000347c:	1b850513          	addi	a0,a0,440 # 80008630 <syscalls+0x1e0>
    80003480:	ffffd097          	auipc	ra,0xffffd
    80003484:	10a080e7          	jalr	266(ra) # 8000058a <printf>
  return 0;
    80003488:	4481                	li	s1,0
    8000348a:	bfa9                	j	800033e4 <balloc+0x8a>

000000008000348c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000348c:	7179                	addi	sp,sp,-48
    8000348e:	f406                	sd	ra,40(sp)
    80003490:	f022                	sd	s0,32(sp)
    80003492:	ec26                	sd	s1,24(sp)
    80003494:	e84a                	sd	s2,16(sp)
    80003496:	e44e                	sd	s3,8(sp)
    80003498:	e052                	sd	s4,0(sp)
    8000349a:	1800                	addi	s0,sp,48
    8000349c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000349e:	47ad                	li	a5,11
    800034a0:	02b7e863          	bltu	a5,a1,800034d0 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800034a4:	02059793          	slli	a5,a1,0x20
    800034a8:	01e7d593          	srli	a1,a5,0x1e
    800034ac:	00b504b3          	add	s1,a0,a1
    800034b0:	0504a903          	lw	s2,80(s1)
    800034b4:	06091e63          	bnez	s2,80003530 <bmap+0xa4>
      addr = balloc(ip->dev);
    800034b8:	4108                	lw	a0,0(a0)
    800034ba:	00000097          	auipc	ra,0x0
    800034be:	ea0080e7          	jalr	-352(ra) # 8000335a <balloc>
    800034c2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800034c6:	06090563          	beqz	s2,80003530 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800034ca:	0524a823          	sw	s2,80(s1)
    800034ce:	a08d                	j	80003530 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800034d0:	ff45849b          	addiw	s1,a1,-12
    800034d4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800034d8:	0ff00793          	li	a5,255
    800034dc:	08e7e563          	bltu	a5,a4,80003566 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800034e0:	08052903          	lw	s2,128(a0)
    800034e4:	00091d63          	bnez	s2,800034fe <bmap+0x72>
      addr = balloc(ip->dev);
    800034e8:	4108                	lw	a0,0(a0)
    800034ea:	00000097          	auipc	ra,0x0
    800034ee:	e70080e7          	jalr	-400(ra) # 8000335a <balloc>
    800034f2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800034f6:	02090d63          	beqz	s2,80003530 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800034fa:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800034fe:	85ca                	mv	a1,s2
    80003500:	0009a503          	lw	a0,0(s3)
    80003504:	00000097          	auipc	ra,0x0
    80003508:	b94080e7          	jalr	-1132(ra) # 80003098 <bread>
    8000350c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000350e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003512:	02049713          	slli	a4,s1,0x20
    80003516:	01e75593          	srli	a1,a4,0x1e
    8000351a:	00b784b3          	add	s1,a5,a1
    8000351e:	0004a903          	lw	s2,0(s1)
    80003522:	02090063          	beqz	s2,80003542 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003526:	8552                	mv	a0,s4
    80003528:	00000097          	auipc	ra,0x0
    8000352c:	ca0080e7          	jalr	-864(ra) # 800031c8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003530:	854a                	mv	a0,s2
    80003532:	70a2                	ld	ra,40(sp)
    80003534:	7402                	ld	s0,32(sp)
    80003536:	64e2                	ld	s1,24(sp)
    80003538:	6942                	ld	s2,16(sp)
    8000353a:	69a2                	ld	s3,8(sp)
    8000353c:	6a02                	ld	s4,0(sp)
    8000353e:	6145                	addi	sp,sp,48
    80003540:	8082                	ret
      addr = balloc(ip->dev);
    80003542:	0009a503          	lw	a0,0(s3)
    80003546:	00000097          	auipc	ra,0x0
    8000354a:	e14080e7          	jalr	-492(ra) # 8000335a <balloc>
    8000354e:	0005091b          	sext.w	s2,a0
      if(addr){
    80003552:	fc090ae3          	beqz	s2,80003526 <bmap+0x9a>
        a[bn] = addr;
    80003556:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000355a:	8552                	mv	a0,s4
    8000355c:	00001097          	auipc	ra,0x1
    80003560:	ef6080e7          	jalr	-266(ra) # 80004452 <log_write>
    80003564:	b7c9                	j	80003526 <bmap+0x9a>
  panic("bmap: out of range");
    80003566:	00005517          	auipc	a0,0x5
    8000356a:	0e250513          	addi	a0,a0,226 # 80008648 <syscalls+0x1f8>
    8000356e:	ffffd097          	auipc	ra,0xffffd
    80003572:	fd2080e7          	jalr	-46(ra) # 80000540 <panic>

0000000080003576 <iget>:
{
    80003576:	7179                	addi	sp,sp,-48
    80003578:	f406                	sd	ra,40(sp)
    8000357a:	f022                	sd	s0,32(sp)
    8000357c:	ec26                	sd	s1,24(sp)
    8000357e:	e84a                	sd	s2,16(sp)
    80003580:	e44e                	sd	s3,8(sp)
    80003582:	e052                	sd	s4,0(sp)
    80003584:	1800                	addi	s0,sp,48
    80003586:	89aa                	mv	s3,a0
    80003588:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000358a:	0001c517          	auipc	a0,0x1c
    8000358e:	c5e50513          	addi	a0,a0,-930 # 8001f1e8 <itable>
    80003592:	ffffd097          	auipc	ra,0xffffd
    80003596:	644080e7          	jalr	1604(ra) # 80000bd6 <acquire>
  empty = 0;
    8000359a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000359c:	0001c497          	auipc	s1,0x1c
    800035a0:	c6448493          	addi	s1,s1,-924 # 8001f200 <itable+0x18>
    800035a4:	0001d697          	auipc	a3,0x1d
    800035a8:	6ec68693          	addi	a3,a3,1772 # 80020c90 <log>
    800035ac:	a039                	j	800035ba <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800035ae:	02090b63          	beqz	s2,800035e4 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800035b2:	08848493          	addi	s1,s1,136
    800035b6:	02d48a63          	beq	s1,a3,800035ea <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800035ba:	449c                	lw	a5,8(s1)
    800035bc:	fef059e3          	blez	a5,800035ae <iget+0x38>
    800035c0:	4098                	lw	a4,0(s1)
    800035c2:	ff3716e3          	bne	a4,s3,800035ae <iget+0x38>
    800035c6:	40d8                	lw	a4,4(s1)
    800035c8:	ff4713e3          	bne	a4,s4,800035ae <iget+0x38>
      ip->ref++;
    800035cc:	2785                	addiw	a5,a5,1
    800035ce:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800035d0:	0001c517          	auipc	a0,0x1c
    800035d4:	c1850513          	addi	a0,a0,-1000 # 8001f1e8 <itable>
    800035d8:	ffffd097          	auipc	ra,0xffffd
    800035dc:	6b2080e7          	jalr	1714(ra) # 80000c8a <release>
      return ip;
    800035e0:	8926                	mv	s2,s1
    800035e2:	a03d                	j	80003610 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800035e4:	f7f9                	bnez	a5,800035b2 <iget+0x3c>
    800035e6:	8926                	mv	s2,s1
    800035e8:	b7e9                	j	800035b2 <iget+0x3c>
  if(empty == 0)
    800035ea:	02090c63          	beqz	s2,80003622 <iget+0xac>
  ip->dev = dev;
    800035ee:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800035f2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800035f6:	4785                	li	a5,1
    800035f8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800035fc:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003600:	0001c517          	auipc	a0,0x1c
    80003604:	be850513          	addi	a0,a0,-1048 # 8001f1e8 <itable>
    80003608:	ffffd097          	auipc	ra,0xffffd
    8000360c:	682080e7          	jalr	1666(ra) # 80000c8a <release>
}
    80003610:	854a                	mv	a0,s2
    80003612:	70a2                	ld	ra,40(sp)
    80003614:	7402                	ld	s0,32(sp)
    80003616:	64e2                	ld	s1,24(sp)
    80003618:	6942                	ld	s2,16(sp)
    8000361a:	69a2                	ld	s3,8(sp)
    8000361c:	6a02                	ld	s4,0(sp)
    8000361e:	6145                	addi	sp,sp,48
    80003620:	8082                	ret
    panic("iget: no inodes");
    80003622:	00005517          	auipc	a0,0x5
    80003626:	03e50513          	addi	a0,a0,62 # 80008660 <syscalls+0x210>
    8000362a:	ffffd097          	auipc	ra,0xffffd
    8000362e:	f16080e7          	jalr	-234(ra) # 80000540 <panic>

0000000080003632 <fsinit>:
fsinit(int dev) {
    80003632:	7179                	addi	sp,sp,-48
    80003634:	f406                	sd	ra,40(sp)
    80003636:	f022                	sd	s0,32(sp)
    80003638:	ec26                	sd	s1,24(sp)
    8000363a:	e84a                	sd	s2,16(sp)
    8000363c:	e44e                	sd	s3,8(sp)
    8000363e:	1800                	addi	s0,sp,48
    80003640:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003642:	4585                	li	a1,1
    80003644:	00000097          	auipc	ra,0x0
    80003648:	a54080e7          	jalr	-1452(ra) # 80003098 <bread>
    8000364c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000364e:	0001c997          	auipc	s3,0x1c
    80003652:	b7a98993          	addi	s3,s3,-1158 # 8001f1c8 <sb>
    80003656:	02000613          	li	a2,32
    8000365a:	05850593          	addi	a1,a0,88
    8000365e:	854e                	mv	a0,s3
    80003660:	ffffd097          	auipc	ra,0xffffd
    80003664:	6ce080e7          	jalr	1742(ra) # 80000d2e <memmove>
  brelse(bp);
    80003668:	8526                	mv	a0,s1
    8000366a:	00000097          	auipc	ra,0x0
    8000366e:	b5e080e7          	jalr	-1186(ra) # 800031c8 <brelse>
  if(sb.magic != FSMAGIC)
    80003672:	0009a703          	lw	a4,0(s3)
    80003676:	102037b7          	lui	a5,0x10203
    8000367a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000367e:	02f71263          	bne	a4,a5,800036a2 <fsinit+0x70>
  initlog(dev, &sb);
    80003682:	0001c597          	auipc	a1,0x1c
    80003686:	b4658593          	addi	a1,a1,-1210 # 8001f1c8 <sb>
    8000368a:	854a                	mv	a0,s2
    8000368c:	00001097          	auipc	ra,0x1
    80003690:	b4a080e7          	jalr	-1206(ra) # 800041d6 <initlog>
}
    80003694:	70a2                	ld	ra,40(sp)
    80003696:	7402                	ld	s0,32(sp)
    80003698:	64e2                	ld	s1,24(sp)
    8000369a:	6942                	ld	s2,16(sp)
    8000369c:	69a2                	ld	s3,8(sp)
    8000369e:	6145                	addi	sp,sp,48
    800036a0:	8082                	ret
    panic("invalid file system");
    800036a2:	00005517          	auipc	a0,0x5
    800036a6:	fce50513          	addi	a0,a0,-50 # 80008670 <syscalls+0x220>
    800036aa:	ffffd097          	auipc	ra,0xffffd
    800036ae:	e96080e7          	jalr	-362(ra) # 80000540 <panic>

00000000800036b2 <iinit>:
{
    800036b2:	7179                	addi	sp,sp,-48
    800036b4:	f406                	sd	ra,40(sp)
    800036b6:	f022                	sd	s0,32(sp)
    800036b8:	ec26                	sd	s1,24(sp)
    800036ba:	e84a                	sd	s2,16(sp)
    800036bc:	e44e                	sd	s3,8(sp)
    800036be:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800036c0:	00005597          	auipc	a1,0x5
    800036c4:	fc858593          	addi	a1,a1,-56 # 80008688 <syscalls+0x238>
    800036c8:	0001c517          	auipc	a0,0x1c
    800036cc:	b2050513          	addi	a0,a0,-1248 # 8001f1e8 <itable>
    800036d0:	ffffd097          	auipc	ra,0xffffd
    800036d4:	476080e7          	jalr	1142(ra) # 80000b46 <initlock>
  for(i = 0; i < NINODE; i++) {
    800036d8:	0001c497          	auipc	s1,0x1c
    800036dc:	b3848493          	addi	s1,s1,-1224 # 8001f210 <itable+0x28>
    800036e0:	0001d997          	auipc	s3,0x1d
    800036e4:	5c098993          	addi	s3,s3,1472 # 80020ca0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800036e8:	00005917          	auipc	s2,0x5
    800036ec:	fa890913          	addi	s2,s2,-88 # 80008690 <syscalls+0x240>
    800036f0:	85ca                	mv	a1,s2
    800036f2:	8526                	mv	a0,s1
    800036f4:	00001097          	auipc	ra,0x1
    800036f8:	e42080e7          	jalr	-446(ra) # 80004536 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800036fc:	08848493          	addi	s1,s1,136
    80003700:	ff3498e3          	bne	s1,s3,800036f0 <iinit+0x3e>
}
    80003704:	70a2                	ld	ra,40(sp)
    80003706:	7402                	ld	s0,32(sp)
    80003708:	64e2                	ld	s1,24(sp)
    8000370a:	6942                	ld	s2,16(sp)
    8000370c:	69a2                	ld	s3,8(sp)
    8000370e:	6145                	addi	sp,sp,48
    80003710:	8082                	ret

0000000080003712 <ialloc>:
{
    80003712:	715d                	addi	sp,sp,-80
    80003714:	e486                	sd	ra,72(sp)
    80003716:	e0a2                	sd	s0,64(sp)
    80003718:	fc26                	sd	s1,56(sp)
    8000371a:	f84a                	sd	s2,48(sp)
    8000371c:	f44e                	sd	s3,40(sp)
    8000371e:	f052                	sd	s4,32(sp)
    80003720:	ec56                	sd	s5,24(sp)
    80003722:	e85a                	sd	s6,16(sp)
    80003724:	e45e                	sd	s7,8(sp)
    80003726:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003728:	0001c717          	auipc	a4,0x1c
    8000372c:	aac72703          	lw	a4,-1364(a4) # 8001f1d4 <sb+0xc>
    80003730:	4785                	li	a5,1
    80003732:	04e7fa63          	bgeu	a5,a4,80003786 <ialloc+0x74>
    80003736:	8aaa                	mv	s5,a0
    80003738:	8bae                	mv	s7,a1
    8000373a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000373c:	0001ca17          	auipc	s4,0x1c
    80003740:	a8ca0a13          	addi	s4,s4,-1396 # 8001f1c8 <sb>
    80003744:	00048b1b          	sext.w	s6,s1
    80003748:	0044d593          	srli	a1,s1,0x4
    8000374c:	018a2783          	lw	a5,24(s4)
    80003750:	9dbd                	addw	a1,a1,a5
    80003752:	8556                	mv	a0,s5
    80003754:	00000097          	auipc	ra,0x0
    80003758:	944080e7          	jalr	-1724(ra) # 80003098 <bread>
    8000375c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000375e:	05850993          	addi	s3,a0,88
    80003762:	00f4f793          	andi	a5,s1,15
    80003766:	079a                	slli	a5,a5,0x6
    80003768:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000376a:	00099783          	lh	a5,0(s3)
    8000376e:	c3a1                	beqz	a5,800037ae <ialloc+0x9c>
    brelse(bp);
    80003770:	00000097          	auipc	ra,0x0
    80003774:	a58080e7          	jalr	-1448(ra) # 800031c8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003778:	0485                	addi	s1,s1,1
    8000377a:	00ca2703          	lw	a4,12(s4)
    8000377e:	0004879b          	sext.w	a5,s1
    80003782:	fce7e1e3          	bltu	a5,a4,80003744 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003786:	00005517          	auipc	a0,0x5
    8000378a:	f1250513          	addi	a0,a0,-238 # 80008698 <syscalls+0x248>
    8000378e:	ffffd097          	auipc	ra,0xffffd
    80003792:	dfc080e7          	jalr	-516(ra) # 8000058a <printf>
  return 0;
    80003796:	4501                	li	a0,0
}
    80003798:	60a6                	ld	ra,72(sp)
    8000379a:	6406                	ld	s0,64(sp)
    8000379c:	74e2                	ld	s1,56(sp)
    8000379e:	7942                	ld	s2,48(sp)
    800037a0:	79a2                	ld	s3,40(sp)
    800037a2:	7a02                	ld	s4,32(sp)
    800037a4:	6ae2                	ld	s5,24(sp)
    800037a6:	6b42                	ld	s6,16(sp)
    800037a8:	6ba2                	ld	s7,8(sp)
    800037aa:	6161                	addi	sp,sp,80
    800037ac:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800037ae:	04000613          	li	a2,64
    800037b2:	4581                	li	a1,0
    800037b4:	854e                	mv	a0,s3
    800037b6:	ffffd097          	auipc	ra,0xffffd
    800037ba:	51c080e7          	jalr	1308(ra) # 80000cd2 <memset>
      dip->type = type;
    800037be:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800037c2:	854a                	mv	a0,s2
    800037c4:	00001097          	auipc	ra,0x1
    800037c8:	c8e080e7          	jalr	-882(ra) # 80004452 <log_write>
      brelse(bp);
    800037cc:	854a                	mv	a0,s2
    800037ce:	00000097          	auipc	ra,0x0
    800037d2:	9fa080e7          	jalr	-1542(ra) # 800031c8 <brelse>
      return iget(dev, inum);
    800037d6:	85da                	mv	a1,s6
    800037d8:	8556                	mv	a0,s5
    800037da:	00000097          	auipc	ra,0x0
    800037de:	d9c080e7          	jalr	-612(ra) # 80003576 <iget>
    800037e2:	bf5d                	j	80003798 <ialloc+0x86>

00000000800037e4 <iupdate>:
{
    800037e4:	1101                	addi	sp,sp,-32
    800037e6:	ec06                	sd	ra,24(sp)
    800037e8:	e822                	sd	s0,16(sp)
    800037ea:	e426                	sd	s1,8(sp)
    800037ec:	e04a                	sd	s2,0(sp)
    800037ee:	1000                	addi	s0,sp,32
    800037f0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037f2:	415c                	lw	a5,4(a0)
    800037f4:	0047d79b          	srliw	a5,a5,0x4
    800037f8:	0001c597          	auipc	a1,0x1c
    800037fc:	9e85a583          	lw	a1,-1560(a1) # 8001f1e0 <sb+0x18>
    80003800:	9dbd                	addw	a1,a1,a5
    80003802:	4108                	lw	a0,0(a0)
    80003804:	00000097          	auipc	ra,0x0
    80003808:	894080e7          	jalr	-1900(ra) # 80003098 <bread>
    8000380c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000380e:	05850793          	addi	a5,a0,88
    80003812:	40d8                	lw	a4,4(s1)
    80003814:	8b3d                	andi	a4,a4,15
    80003816:	071a                	slli	a4,a4,0x6
    80003818:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000381a:	04449703          	lh	a4,68(s1)
    8000381e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003822:	04649703          	lh	a4,70(s1)
    80003826:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000382a:	04849703          	lh	a4,72(s1)
    8000382e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003832:	04a49703          	lh	a4,74(s1)
    80003836:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000383a:	44f8                	lw	a4,76(s1)
    8000383c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000383e:	03400613          	li	a2,52
    80003842:	05048593          	addi	a1,s1,80
    80003846:	00c78513          	addi	a0,a5,12
    8000384a:	ffffd097          	auipc	ra,0xffffd
    8000384e:	4e4080e7          	jalr	1252(ra) # 80000d2e <memmove>
  log_write(bp);
    80003852:	854a                	mv	a0,s2
    80003854:	00001097          	auipc	ra,0x1
    80003858:	bfe080e7          	jalr	-1026(ra) # 80004452 <log_write>
  brelse(bp);
    8000385c:	854a                	mv	a0,s2
    8000385e:	00000097          	auipc	ra,0x0
    80003862:	96a080e7          	jalr	-1686(ra) # 800031c8 <brelse>
}
    80003866:	60e2                	ld	ra,24(sp)
    80003868:	6442                	ld	s0,16(sp)
    8000386a:	64a2                	ld	s1,8(sp)
    8000386c:	6902                	ld	s2,0(sp)
    8000386e:	6105                	addi	sp,sp,32
    80003870:	8082                	ret

0000000080003872 <idup>:
{
    80003872:	1101                	addi	sp,sp,-32
    80003874:	ec06                	sd	ra,24(sp)
    80003876:	e822                	sd	s0,16(sp)
    80003878:	e426                	sd	s1,8(sp)
    8000387a:	1000                	addi	s0,sp,32
    8000387c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000387e:	0001c517          	auipc	a0,0x1c
    80003882:	96a50513          	addi	a0,a0,-1686 # 8001f1e8 <itable>
    80003886:	ffffd097          	auipc	ra,0xffffd
    8000388a:	350080e7          	jalr	848(ra) # 80000bd6 <acquire>
  ip->ref++;
    8000388e:	449c                	lw	a5,8(s1)
    80003890:	2785                	addiw	a5,a5,1
    80003892:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003894:	0001c517          	auipc	a0,0x1c
    80003898:	95450513          	addi	a0,a0,-1708 # 8001f1e8 <itable>
    8000389c:	ffffd097          	auipc	ra,0xffffd
    800038a0:	3ee080e7          	jalr	1006(ra) # 80000c8a <release>
}
    800038a4:	8526                	mv	a0,s1
    800038a6:	60e2                	ld	ra,24(sp)
    800038a8:	6442                	ld	s0,16(sp)
    800038aa:	64a2                	ld	s1,8(sp)
    800038ac:	6105                	addi	sp,sp,32
    800038ae:	8082                	ret

00000000800038b0 <ilock>:
{
    800038b0:	1101                	addi	sp,sp,-32
    800038b2:	ec06                	sd	ra,24(sp)
    800038b4:	e822                	sd	s0,16(sp)
    800038b6:	e426                	sd	s1,8(sp)
    800038b8:	e04a                	sd	s2,0(sp)
    800038ba:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800038bc:	c115                	beqz	a0,800038e0 <ilock+0x30>
    800038be:	84aa                	mv	s1,a0
    800038c0:	451c                	lw	a5,8(a0)
    800038c2:	00f05f63          	blez	a5,800038e0 <ilock+0x30>
  acquiresleep(&ip->lock);
    800038c6:	0541                	addi	a0,a0,16
    800038c8:	00001097          	auipc	ra,0x1
    800038cc:	ca8080e7          	jalr	-856(ra) # 80004570 <acquiresleep>
  if(ip->valid == 0){
    800038d0:	40bc                	lw	a5,64(s1)
    800038d2:	cf99                	beqz	a5,800038f0 <ilock+0x40>
}
    800038d4:	60e2                	ld	ra,24(sp)
    800038d6:	6442                	ld	s0,16(sp)
    800038d8:	64a2                	ld	s1,8(sp)
    800038da:	6902                	ld	s2,0(sp)
    800038dc:	6105                	addi	sp,sp,32
    800038de:	8082                	ret
    panic("ilock");
    800038e0:	00005517          	auipc	a0,0x5
    800038e4:	dd050513          	addi	a0,a0,-560 # 800086b0 <syscalls+0x260>
    800038e8:	ffffd097          	auipc	ra,0xffffd
    800038ec:	c58080e7          	jalr	-936(ra) # 80000540 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800038f0:	40dc                	lw	a5,4(s1)
    800038f2:	0047d79b          	srliw	a5,a5,0x4
    800038f6:	0001c597          	auipc	a1,0x1c
    800038fa:	8ea5a583          	lw	a1,-1814(a1) # 8001f1e0 <sb+0x18>
    800038fe:	9dbd                	addw	a1,a1,a5
    80003900:	4088                	lw	a0,0(s1)
    80003902:	fffff097          	auipc	ra,0xfffff
    80003906:	796080e7          	jalr	1942(ra) # 80003098 <bread>
    8000390a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000390c:	05850593          	addi	a1,a0,88
    80003910:	40dc                	lw	a5,4(s1)
    80003912:	8bbd                	andi	a5,a5,15
    80003914:	079a                	slli	a5,a5,0x6
    80003916:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003918:	00059783          	lh	a5,0(a1)
    8000391c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003920:	00259783          	lh	a5,2(a1)
    80003924:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003928:	00459783          	lh	a5,4(a1)
    8000392c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003930:	00659783          	lh	a5,6(a1)
    80003934:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003938:	459c                	lw	a5,8(a1)
    8000393a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000393c:	03400613          	li	a2,52
    80003940:	05b1                	addi	a1,a1,12
    80003942:	05048513          	addi	a0,s1,80
    80003946:	ffffd097          	auipc	ra,0xffffd
    8000394a:	3e8080e7          	jalr	1000(ra) # 80000d2e <memmove>
    brelse(bp);
    8000394e:	854a                	mv	a0,s2
    80003950:	00000097          	auipc	ra,0x0
    80003954:	878080e7          	jalr	-1928(ra) # 800031c8 <brelse>
    ip->valid = 1;
    80003958:	4785                	li	a5,1
    8000395a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000395c:	04449783          	lh	a5,68(s1)
    80003960:	fbb5                	bnez	a5,800038d4 <ilock+0x24>
      panic("ilock: no type");
    80003962:	00005517          	auipc	a0,0x5
    80003966:	d5650513          	addi	a0,a0,-682 # 800086b8 <syscalls+0x268>
    8000396a:	ffffd097          	auipc	ra,0xffffd
    8000396e:	bd6080e7          	jalr	-1066(ra) # 80000540 <panic>

0000000080003972 <iunlock>:
{
    80003972:	1101                	addi	sp,sp,-32
    80003974:	ec06                	sd	ra,24(sp)
    80003976:	e822                	sd	s0,16(sp)
    80003978:	e426                	sd	s1,8(sp)
    8000397a:	e04a                	sd	s2,0(sp)
    8000397c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000397e:	c905                	beqz	a0,800039ae <iunlock+0x3c>
    80003980:	84aa                	mv	s1,a0
    80003982:	01050913          	addi	s2,a0,16
    80003986:	854a                	mv	a0,s2
    80003988:	00001097          	auipc	ra,0x1
    8000398c:	c82080e7          	jalr	-894(ra) # 8000460a <holdingsleep>
    80003990:	cd19                	beqz	a0,800039ae <iunlock+0x3c>
    80003992:	449c                	lw	a5,8(s1)
    80003994:	00f05d63          	blez	a5,800039ae <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003998:	854a                	mv	a0,s2
    8000399a:	00001097          	auipc	ra,0x1
    8000399e:	c2c080e7          	jalr	-980(ra) # 800045c6 <releasesleep>
}
    800039a2:	60e2                	ld	ra,24(sp)
    800039a4:	6442                	ld	s0,16(sp)
    800039a6:	64a2                	ld	s1,8(sp)
    800039a8:	6902                	ld	s2,0(sp)
    800039aa:	6105                	addi	sp,sp,32
    800039ac:	8082                	ret
    panic("iunlock");
    800039ae:	00005517          	auipc	a0,0x5
    800039b2:	d1a50513          	addi	a0,a0,-742 # 800086c8 <syscalls+0x278>
    800039b6:	ffffd097          	auipc	ra,0xffffd
    800039ba:	b8a080e7          	jalr	-1142(ra) # 80000540 <panic>

00000000800039be <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800039be:	7179                	addi	sp,sp,-48
    800039c0:	f406                	sd	ra,40(sp)
    800039c2:	f022                	sd	s0,32(sp)
    800039c4:	ec26                	sd	s1,24(sp)
    800039c6:	e84a                	sd	s2,16(sp)
    800039c8:	e44e                	sd	s3,8(sp)
    800039ca:	e052                	sd	s4,0(sp)
    800039cc:	1800                	addi	s0,sp,48
    800039ce:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800039d0:	05050493          	addi	s1,a0,80
    800039d4:	08050913          	addi	s2,a0,128
    800039d8:	a021                	j	800039e0 <itrunc+0x22>
    800039da:	0491                	addi	s1,s1,4
    800039dc:	01248d63          	beq	s1,s2,800039f6 <itrunc+0x38>
    if(ip->addrs[i]){
    800039e0:	408c                	lw	a1,0(s1)
    800039e2:	dde5                	beqz	a1,800039da <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800039e4:	0009a503          	lw	a0,0(s3)
    800039e8:	00000097          	auipc	ra,0x0
    800039ec:	8f6080e7          	jalr	-1802(ra) # 800032de <bfree>
      ip->addrs[i] = 0;
    800039f0:	0004a023          	sw	zero,0(s1)
    800039f4:	b7dd                	j	800039da <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800039f6:	0809a583          	lw	a1,128(s3)
    800039fa:	e185                	bnez	a1,80003a1a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800039fc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003a00:	854e                	mv	a0,s3
    80003a02:	00000097          	auipc	ra,0x0
    80003a06:	de2080e7          	jalr	-542(ra) # 800037e4 <iupdate>
}
    80003a0a:	70a2                	ld	ra,40(sp)
    80003a0c:	7402                	ld	s0,32(sp)
    80003a0e:	64e2                	ld	s1,24(sp)
    80003a10:	6942                	ld	s2,16(sp)
    80003a12:	69a2                	ld	s3,8(sp)
    80003a14:	6a02                	ld	s4,0(sp)
    80003a16:	6145                	addi	sp,sp,48
    80003a18:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003a1a:	0009a503          	lw	a0,0(s3)
    80003a1e:	fffff097          	auipc	ra,0xfffff
    80003a22:	67a080e7          	jalr	1658(ra) # 80003098 <bread>
    80003a26:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003a28:	05850493          	addi	s1,a0,88
    80003a2c:	45850913          	addi	s2,a0,1112
    80003a30:	a021                	j	80003a38 <itrunc+0x7a>
    80003a32:	0491                	addi	s1,s1,4
    80003a34:	01248b63          	beq	s1,s2,80003a4a <itrunc+0x8c>
      if(a[j])
    80003a38:	408c                	lw	a1,0(s1)
    80003a3a:	dde5                	beqz	a1,80003a32 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003a3c:	0009a503          	lw	a0,0(s3)
    80003a40:	00000097          	auipc	ra,0x0
    80003a44:	89e080e7          	jalr	-1890(ra) # 800032de <bfree>
    80003a48:	b7ed                	j	80003a32 <itrunc+0x74>
    brelse(bp);
    80003a4a:	8552                	mv	a0,s4
    80003a4c:	fffff097          	auipc	ra,0xfffff
    80003a50:	77c080e7          	jalr	1916(ra) # 800031c8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003a54:	0809a583          	lw	a1,128(s3)
    80003a58:	0009a503          	lw	a0,0(s3)
    80003a5c:	00000097          	auipc	ra,0x0
    80003a60:	882080e7          	jalr	-1918(ra) # 800032de <bfree>
    ip->addrs[NDIRECT] = 0;
    80003a64:	0809a023          	sw	zero,128(s3)
    80003a68:	bf51                	j	800039fc <itrunc+0x3e>

0000000080003a6a <iput>:
{
    80003a6a:	1101                	addi	sp,sp,-32
    80003a6c:	ec06                	sd	ra,24(sp)
    80003a6e:	e822                	sd	s0,16(sp)
    80003a70:	e426                	sd	s1,8(sp)
    80003a72:	e04a                	sd	s2,0(sp)
    80003a74:	1000                	addi	s0,sp,32
    80003a76:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a78:	0001b517          	auipc	a0,0x1b
    80003a7c:	77050513          	addi	a0,a0,1904 # 8001f1e8 <itable>
    80003a80:	ffffd097          	auipc	ra,0xffffd
    80003a84:	156080e7          	jalr	342(ra) # 80000bd6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a88:	4498                	lw	a4,8(s1)
    80003a8a:	4785                	li	a5,1
    80003a8c:	02f70363          	beq	a4,a5,80003ab2 <iput+0x48>
  ip->ref--;
    80003a90:	449c                	lw	a5,8(s1)
    80003a92:	37fd                	addiw	a5,a5,-1
    80003a94:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a96:	0001b517          	auipc	a0,0x1b
    80003a9a:	75250513          	addi	a0,a0,1874 # 8001f1e8 <itable>
    80003a9e:	ffffd097          	auipc	ra,0xffffd
    80003aa2:	1ec080e7          	jalr	492(ra) # 80000c8a <release>
}
    80003aa6:	60e2                	ld	ra,24(sp)
    80003aa8:	6442                	ld	s0,16(sp)
    80003aaa:	64a2                	ld	s1,8(sp)
    80003aac:	6902                	ld	s2,0(sp)
    80003aae:	6105                	addi	sp,sp,32
    80003ab0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ab2:	40bc                	lw	a5,64(s1)
    80003ab4:	dff1                	beqz	a5,80003a90 <iput+0x26>
    80003ab6:	04a49783          	lh	a5,74(s1)
    80003aba:	fbf9                	bnez	a5,80003a90 <iput+0x26>
    acquiresleep(&ip->lock);
    80003abc:	01048913          	addi	s2,s1,16
    80003ac0:	854a                	mv	a0,s2
    80003ac2:	00001097          	auipc	ra,0x1
    80003ac6:	aae080e7          	jalr	-1362(ra) # 80004570 <acquiresleep>
    release(&itable.lock);
    80003aca:	0001b517          	auipc	a0,0x1b
    80003ace:	71e50513          	addi	a0,a0,1822 # 8001f1e8 <itable>
    80003ad2:	ffffd097          	auipc	ra,0xffffd
    80003ad6:	1b8080e7          	jalr	440(ra) # 80000c8a <release>
    itrunc(ip);
    80003ada:	8526                	mv	a0,s1
    80003adc:	00000097          	auipc	ra,0x0
    80003ae0:	ee2080e7          	jalr	-286(ra) # 800039be <itrunc>
    ip->type = 0;
    80003ae4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003ae8:	8526                	mv	a0,s1
    80003aea:	00000097          	auipc	ra,0x0
    80003aee:	cfa080e7          	jalr	-774(ra) # 800037e4 <iupdate>
    ip->valid = 0;
    80003af2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003af6:	854a                	mv	a0,s2
    80003af8:	00001097          	auipc	ra,0x1
    80003afc:	ace080e7          	jalr	-1330(ra) # 800045c6 <releasesleep>
    acquire(&itable.lock);
    80003b00:	0001b517          	auipc	a0,0x1b
    80003b04:	6e850513          	addi	a0,a0,1768 # 8001f1e8 <itable>
    80003b08:	ffffd097          	auipc	ra,0xffffd
    80003b0c:	0ce080e7          	jalr	206(ra) # 80000bd6 <acquire>
    80003b10:	b741                	j	80003a90 <iput+0x26>

0000000080003b12 <iunlockput>:
{
    80003b12:	1101                	addi	sp,sp,-32
    80003b14:	ec06                	sd	ra,24(sp)
    80003b16:	e822                	sd	s0,16(sp)
    80003b18:	e426                	sd	s1,8(sp)
    80003b1a:	1000                	addi	s0,sp,32
    80003b1c:	84aa                	mv	s1,a0
  iunlock(ip);
    80003b1e:	00000097          	auipc	ra,0x0
    80003b22:	e54080e7          	jalr	-428(ra) # 80003972 <iunlock>
  iput(ip);
    80003b26:	8526                	mv	a0,s1
    80003b28:	00000097          	auipc	ra,0x0
    80003b2c:	f42080e7          	jalr	-190(ra) # 80003a6a <iput>
}
    80003b30:	60e2                	ld	ra,24(sp)
    80003b32:	6442                	ld	s0,16(sp)
    80003b34:	64a2                	ld	s1,8(sp)
    80003b36:	6105                	addi	sp,sp,32
    80003b38:	8082                	ret

0000000080003b3a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003b3a:	1141                	addi	sp,sp,-16
    80003b3c:	e422                	sd	s0,8(sp)
    80003b3e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003b40:	411c                	lw	a5,0(a0)
    80003b42:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003b44:	415c                	lw	a5,4(a0)
    80003b46:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003b48:	04451783          	lh	a5,68(a0)
    80003b4c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003b50:	04a51783          	lh	a5,74(a0)
    80003b54:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003b58:	04c56783          	lwu	a5,76(a0)
    80003b5c:	e99c                	sd	a5,16(a1)
}
    80003b5e:	6422                	ld	s0,8(sp)
    80003b60:	0141                	addi	sp,sp,16
    80003b62:	8082                	ret

0000000080003b64 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b64:	457c                	lw	a5,76(a0)
    80003b66:	0ed7e963          	bltu	a5,a3,80003c58 <readi+0xf4>
{
    80003b6a:	7159                	addi	sp,sp,-112
    80003b6c:	f486                	sd	ra,104(sp)
    80003b6e:	f0a2                	sd	s0,96(sp)
    80003b70:	eca6                	sd	s1,88(sp)
    80003b72:	e8ca                	sd	s2,80(sp)
    80003b74:	e4ce                	sd	s3,72(sp)
    80003b76:	e0d2                	sd	s4,64(sp)
    80003b78:	fc56                	sd	s5,56(sp)
    80003b7a:	f85a                	sd	s6,48(sp)
    80003b7c:	f45e                	sd	s7,40(sp)
    80003b7e:	f062                	sd	s8,32(sp)
    80003b80:	ec66                	sd	s9,24(sp)
    80003b82:	e86a                	sd	s10,16(sp)
    80003b84:	e46e                	sd	s11,8(sp)
    80003b86:	1880                	addi	s0,sp,112
    80003b88:	8b2a                	mv	s6,a0
    80003b8a:	8bae                	mv	s7,a1
    80003b8c:	8a32                	mv	s4,a2
    80003b8e:	84b6                	mv	s1,a3
    80003b90:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003b92:	9f35                	addw	a4,a4,a3
    return 0;
    80003b94:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003b96:	0ad76063          	bltu	a4,a3,80003c36 <readi+0xd2>
  if(off + n > ip->size)
    80003b9a:	00e7f463          	bgeu	a5,a4,80003ba2 <readi+0x3e>
    n = ip->size - off;
    80003b9e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ba2:	0a0a8963          	beqz	s5,80003c54 <readi+0xf0>
    80003ba6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ba8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003bac:	5c7d                	li	s8,-1
    80003bae:	a82d                	j	80003be8 <readi+0x84>
    80003bb0:	020d1d93          	slli	s11,s10,0x20
    80003bb4:	020ddd93          	srli	s11,s11,0x20
    80003bb8:	05890613          	addi	a2,s2,88
    80003bbc:	86ee                	mv	a3,s11
    80003bbe:	963a                	add	a2,a2,a4
    80003bc0:	85d2                	mv	a1,s4
    80003bc2:	855e                	mv	a0,s7
    80003bc4:	fffff097          	auipc	ra,0xfffff
    80003bc8:	898080e7          	jalr	-1896(ra) # 8000245c <either_copyout>
    80003bcc:	05850d63          	beq	a0,s8,80003c26 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003bd0:	854a                	mv	a0,s2
    80003bd2:	fffff097          	auipc	ra,0xfffff
    80003bd6:	5f6080e7          	jalr	1526(ra) # 800031c8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003bda:	013d09bb          	addw	s3,s10,s3
    80003bde:	009d04bb          	addw	s1,s10,s1
    80003be2:	9a6e                	add	s4,s4,s11
    80003be4:	0559f763          	bgeu	s3,s5,80003c32 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003be8:	00a4d59b          	srliw	a1,s1,0xa
    80003bec:	855a                	mv	a0,s6
    80003bee:	00000097          	auipc	ra,0x0
    80003bf2:	89e080e7          	jalr	-1890(ra) # 8000348c <bmap>
    80003bf6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003bfa:	cd85                	beqz	a1,80003c32 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003bfc:	000b2503          	lw	a0,0(s6)
    80003c00:	fffff097          	auipc	ra,0xfffff
    80003c04:	498080e7          	jalr	1176(ra) # 80003098 <bread>
    80003c08:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c0a:	3ff4f713          	andi	a4,s1,1023
    80003c0e:	40ec87bb          	subw	a5,s9,a4
    80003c12:	413a86bb          	subw	a3,s5,s3
    80003c16:	8d3e                	mv	s10,a5
    80003c18:	2781                	sext.w	a5,a5
    80003c1a:	0006861b          	sext.w	a2,a3
    80003c1e:	f8f679e3          	bgeu	a2,a5,80003bb0 <readi+0x4c>
    80003c22:	8d36                	mv	s10,a3
    80003c24:	b771                	j	80003bb0 <readi+0x4c>
      brelse(bp);
    80003c26:	854a                	mv	a0,s2
    80003c28:	fffff097          	auipc	ra,0xfffff
    80003c2c:	5a0080e7          	jalr	1440(ra) # 800031c8 <brelse>
      tot = -1;
    80003c30:	59fd                	li	s3,-1
  }
  return tot;
    80003c32:	0009851b          	sext.w	a0,s3
}
    80003c36:	70a6                	ld	ra,104(sp)
    80003c38:	7406                	ld	s0,96(sp)
    80003c3a:	64e6                	ld	s1,88(sp)
    80003c3c:	6946                	ld	s2,80(sp)
    80003c3e:	69a6                	ld	s3,72(sp)
    80003c40:	6a06                	ld	s4,64(sp)
    80003c42:	7ae2                	ld	s5,56(sp)
    80003c44:	7b42                	ld	s6,48(sp)
    80003c46:	7ba2                	ld	s7,40(sp)
    80003c48:	7c02                	ld	s8,32(sp)
    80003c4a:	6ce2                	ld	s9,24(sp)
    80003c4c:	6d42                	ld	s10,16(sp)
    80003c4e:	6da2                	ld	s11,8(sp)
    80003c50:	6165                	addi	sp,sp,112
    80003c52:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003c54:	89d6                	mv	s3,s5
    80003c56:	bff1                	j	80003c32 <readi+0xce>
    return 0;
    80003c58:	4501                	li	a0,0
}
    80003c5a:	8082                	ret

0000000080003c5c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c5c:	457c                	lw	a5,76(a0)
    80003c5e:	10d7e863          	bltu	a5,a3,80003d6e <writei+0x112>
{
    80003c62:	7159                	addi	sp,sp,-112
    80003c64:	f486                	sd	ra,104(sp)
    80003c66:	f0a2                	sd	s0,96(sp)
    80003c68:	eca6                	sd	s1,88(sp)
    80003c6a:	e8ca                	sd	s2,80(sp)
    80003c6c:	e4ce                	sd	s3,72(sp)
    80003c6e:	e0d2                	sd	s4,64(sp)
    80003c70:	fc56                	sd	s5,56(sp)
    80003c72:	f85a                	sd	s6,48(sp)
    80003c74:	f45e                	sd	s7,40(sp)
    80003c76:	f062                	sd	s8,32(sp)
    80003c78:	ec66                	sd	s9,24(sp)
    80003c7a:	e86a                	sd	s10,16(sp)
    80003c7c:	e46e                	sd	s11,8(sp)
    80003c7e:	1880                	addi	s0,sp,112
    80003c80:	8aaa                	mv	s5,a0
    80003c82:	8bae                	mv	s7,a1
    80003c84:	8a32                	mv	s4,a2
    80003c86:	8936                	mv	s2,a3
    80003c88:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003c8a:	00e687bb          	addw	a5,a3,a4
    80003c8e:	0ed7e263          	bltu	a5,a3,80003d72 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003c92:	00043737          	lui	a4,0x43
    80003c96:	0ef76063          	bltu	a4,a5,80003d76 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c9a:	0c0b0863          	beqz	s6,80003d6a <writei+0x10e>
    80003c9e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ca0:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003ca4:	5c7d                	li	s8,-1
    80003ca6:	a091                	j	80003cea <writei+0x8e>
    80003ca8:	020d1d93          	slli	s11,s10,0x20
    80003cac:	020ddd93          	srli	s11,s11,0x20
    80003cb0:	05848513          	addi	a0,s1,88
    80003cb4:	86ee                	mv	a3,s11
    80003cb6:	8652                	mv	a2,s4
    80003cb8:	85de                	mv	a1,s7
    80003cba:	953a                	add	a0,a0,a4
    80003cbc:	ffffe097          	auipc	ra,0xffffe
    80003cc0:	7f6080e7          	jalr	2038(ra) # 800024b2 <either_copyin>
    80003cc4:	07850263          	beq	a0,s8,80003d28 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003cc8:	8526                	mv	a0,s1
    80003cca:	00000097          	auipc	ra,0x0
    80003cce:	788080e7          	jalr	1928(ra) # 80004452 <log_write>
    brelse(bp);
    80003cd2:	8526                	mv	a0,s1
    80003cd4:	fffff097          	auipc	ra,0xfffff
    80003cd8:	4f4080e7          	jalr	1268(ra) # 800031c8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003cdc:	013d09bb          	addw	s3,s10,s3
    80003ce0:	012d093b          	addw	s2,s10,s2
    80003ce4:	9a6e                	add	s4,s4,s11
    80003ce6:	0569f663          	bgeu	s3,s6,80003d32 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003cea:	00a9559b          	srliw	a1,s2,0xa
    80003cee:	8556                	mv	a0,s5
    80003cf0:	fffff097          	auipc	ra,0xfffff
    80003cf4:	79c080e7          	jalr	1948(ra) # 8000348c <bmap>
    80003cf8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003cfc:	c99d                	beqz	a1,80003d32 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003cfe:	000aa503          	lw	a0,0(s5)
    80003d02:	fffff097          	auipc	ra,0xfffff
    80003d06:	396080e7          	jalr	918(ra) # 80003098 <bread>
    80003d0a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d0c:	3ff97713          	andi	a4,s2,1023
    80003d10:	40ec87bb          	subw	a5,s9,a4
    80003d14:	413b06bb          	subw	a3,s6,s3
    80003d18:	8d3e                	mv	s10,a5
    80003d1a:	2781                	sext.w	a5,a5
    80003d1c:	0006861b          	sext.w	a2,a3
    80003d20:	f8f674e3          	bgeu	a2,a5,80003ca8 <writei+0x4c>
    80003d24:	8d36                	mv	s10,a3
    80003d26:	b749                	j	80003ca8 <writei+0x4c>
      brelse(bp);
    80003d28:	8526                	mv	a0,s1
    80003d2a:	fffff097          	auipc	ra,0xfffff
    80003d2e:	49e080e7          	jalr	1182(ra) # 800031c8 <brelse>
  }

  if(off > ip->size)
    80003d32:	04caa783          	lw	a5,76(s5)
    80003d36:	0127f463          	bgeu	a5,s2,80003d3e <writei+0xe2>
    ip->size = off;
    80003d3a:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003d3e:	8556                	mv	a0,s5
    80003d40:	00000097          	auipc	ra,0x0
    80003d44:	aa4080e7          	jalr	-1372(ra) # 800037e4 <iupdate>

  return tot;
    80003d48:	0009851b          	sext.w	a0,s3
}
    80003d4c:	70a6                	ld	ra,104(sp)
    80003d4e:	7406                	ld	s0,96(sp)
    80003d50:	64e6                	ld	s1,88(sp)
    80003d52:	6946                	ld	s2,80(sp)
    80003d54:	69a6                	ld	s3,72(sp)
    80003d56:	6a06                	ld	s4,64(sp)
    80003d58:	7ae2                	ld	s5,56(sp)
    80003d5a:	7b42                	ld	s6,48(sp)
    80003d5c:	7ba2                	ld	s7,40(sp)
    80003d5e:	7c02                	ld	s8,32(sp)
    80003d60:	6ce2                	ld	s9,24(sp)
    80003d62:	6d42                	ld	s10,16(sp)
    80003d64:	6da2                	ld	s11,8(sp)
    80003d66:	6165                	addi	sp,sp,112
    80003d68:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d6a:	89da                	mv	s3,s6
    80003d6c:	bfc9                	j	80003d3e <writei+0xe2>
    return -1;
    80003d6e:	557d                	li	a0,-1
}
    80003d70:	8082                	ret
    return -1;
    80003d72:	557d                	li	a0,-1
    80003d74:	bfe1                	j	80003d4c <writei+0xf0>
    return -1;
    80003d76:	557d                	li	a0,-1
    80003d78:	bfd1                	j	80003d4c <writei+0xf0>

0000000080003d7a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003d7a:	1141                	addi	sp,sp,-16
    80003d7c:	e406                	sd	ra,8(sp)
    80003d7e:	e022                	sd	s0,0(sp)
    80003d80:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003d82:	4639                	li	a2,14
    80003d84:	ffffd097          	auipc	ra,0xffffd
    80003d88:	01e080e7          	jalr	30(ra) # 80000da2 <strncmp>
}
    80003d8c:	60a2                	ld	ra,8(sp)
    80003d8e:	6402                	ld	s0,0(sp)
    80003d90:	0141                	addi	sp,sp,16
    80003d92:	8082                	ret

0000000080003d94 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003d94:	7139                	addi	sp,sp,-64
    80003d96:	fc06                	sd	ra,56(sp)
    80003d98:	f822                	sd	s0,48(sp)
    80003d9a:	f426                	sd	s1,40(sp)
    80003d9c:	f04a                	sd	s2,32(sp)
    80003d9e:	ec4e                	sd	s3,24(sp)
    80003da0:	e852                	sd	s4,16(sp)
    80003da2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003da4:	04451703          	lh	a4,68(a0)
    80003da8:	4785                	li	a5,1
    80003daa:	00f71a63          	bne	a4,a5,80003dbe <dirlookup+0x2a>
    80003dae:	892a                	mv	s2,a0
    80003db0:	89ae                	mv	s3,a1
    80003db2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003db4:	457c                	lw	a5,76(a0)
    80003db6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003db8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003dba:	e79d                	bnez	a5,80003de8 <dirlookup+0x54>
    80003dbc:	a8a5                	j	80003e34 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003dbe:	00005517          	auipc	a0,0x5
    80003dc2:	91250513          	addi	a0,a0,-1774 # 800086d0 <syscalls+0x280>
    80003dc6:	ffffc097          	auipc	ra,0xffffc
    80003dca:	77a080e7          	jalr	1914(ra) # 80000540 <panic>
      panic("dirlookup read");
    80003dce:	00005517          	auipc	a0,0x5
    80003dd2:	91a50513          	addi	a0,a0,-1766 # 800086e8 <syscalls+0x298>
    80003dd6:	ffffc097          	auipc	ra,0xffffc
    80003dda:	76a080e7          	jalr	1898(ra) # 80000540 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003dde:	24c1                	addiw	s1,s1,16
    80003de0:	04c92783          	lw	a5,76(s2)
    80003de4:	04f4f763          	bgeu	s1,a5,80003e32 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003de8:	4741                	li	a4,16
    80003dea:	86a6                	mv	a3,s1
    80003dec:	fc040613          	addi	a2,s0,-64
    80003df0:	4581                	li	a1,0
    80003df2:	854a                	mv	a0,s2
    80003df4:	00000097          	auipc	ra,0x0
    80003df8:	d70080e7          	jalr	-656(ra) # 80003b64 <readi>
    80003dfc:	47c1                	li	a5,16
    80003dfe:	fcf518e3          	bne	a0,a5,80003dce <dirlookup+0x3a>
    if(de.inum == 0)
    80003e02:	fc045783          	lhu	a5,-64(s0)
    80003e06:	dfe1                	beqz	a5,80003dde <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003e08:	fc240593          	addi	a1,s0,-62
    80003e0c:	854e                	mv	a0,s3
    80003e0e:	00000097          	auipc	ra,0x0
    80003e12:	f6c080e7          	jalr	-148(ra) # 80003d7a <namecmp>
    80003e16:	f561                	bnez	a0,80003dde <dirlookup+0x4a>
      if(poff)
    80003e18:	000a0463          	beqz	s4,80003e20 <dirlookup+0x8c>
        *poff = off;
    80003e1c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003e20:	fc045583          	lhu	a1,-64(s0)
    80003e24:	00092503          	lw	a0,0(s2)
    80003e28:	fffff097          	auipc	ra,0xfffff
    80003e2c:	74e080e7          	jalr	1870(ra) # 80003576 <iget>
    80003e30:	a011                	j	80003e34 <dirlookup+0xa0>
  return 0;
    80003e32:	4501                	li	a0,0
}
    80003e34:	70e2                	ld	ra,56(sp)
    80003e36:	7442                	ld	s0,48(sp)
    80003e38:	74a2                	ld	s1,40(sp)
    80003e3a:	7902                	ld	s2,32(sp)
    80003e3c:	69e2                	ld	s3,24(sp)
    80003e3e:	6a42                	ld	s4,16(sp)
    80003e40:	6121                	addi	sp,sp,64
    80003e42:	8082                	ret

0000000080003e44 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003e44:	711d                	addi	sp,sp,-96
    80003e46:	ec86                	sd	ra,88(sp)
    80003e48:	e8a2                	sd	s0,80(sp)
    80003e4a:	e4a6                	sd	s1,72(sp)
    80003e4c:	e0ca                	sd	s2,64(sp)
    80003e4e:	fc4e                	sd	s3,56(sp)
    80003e50:	f852                	sd	s4,48(sp)
    80003e52:	f456                	sd	s5,40(sp)
    80003e54:	f05a                	sd	s6,32(sp)
    80003e56:	ec5e                	sd	s7,24(sp)
    80003e58:	e862                	sd	s8,16(sp)
    80003e5a:	e466                	sd	s9,8(sp)
    80003e5c:	e06a                	sd	s10,0(sp)
    80003e5e:	1080                	addi	s0,sp,96
    80003e60:	84aa                	mv	s1,a0
    80003e62:	8b2e                	mv	s6,a1
    80003e64:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003e66:	00054703          	lbu	a4,0(a0)
    80003e6a:	02f00793          	li	a5,47
    80003e6e:	02f70363          	beq	a4,a5,80003e94 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003e72:	ffffe097          	auipc	ra,0xffffe
    80003e76:	b3a080e7          	jalr	-1222(ra) # 800019ac <myproc>
    80003e7a:	15053503          	ld	a0,336(a0)
    80003e7e:	00000097          	auipc	ra,0x0
    80003e82:	9f4080e7          	jalr	-1548(ra) # 80003872 <idup>
    80003e86:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003e88:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003e8c:	4cb5                	li	s9,13
  len = path - s;
    80003e8e:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003e90:	4c05                	li	s8,1
    80003e92:	a87d                	j	80003f50 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003e94:	4585                	li	a1,1
    80003e96:	4505                	li	a0,1
    80003e98:	fffff097          	auipc	ra,0xfffff
    80003e9c:	6de080e7          	jalr	1758(ra) # 80003576 <iget>
    80003ea0:	8a2a                	mv	s4,a0
    80003ea2:	b7dd                	j	80003e88 <namex+0x44>
      iunlockput(ip);
    80003ea4:	8552                	mv	a0,s4
    80003ea6:	00000097          	auipc	ra,0x0
    80003eaa:	c6c080e7          	jalr	-916(ra) # 80003b12 <iunlockput>
      return 0;
    80003eae:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003eb0:	8552                	mv	a0,s4
    80003eb2:	60e6                	ld	ra,88(sp)
    80003eb4:	6446                	ld	s0,80(sp)
    80003eb6:	64a6                	ld	s1,72(sp)
    80003eb8:	6906                	ld	s2,64(sp)
    80003eba:	79e2                	ld	s3,56(sp)
    80003ebc:	7a42                	ld	s4,48(sp)
    80003ebe:	7aa2                	ld	s5,40(sp)
    80003ec0:	7b02                	ld	s6,32(sp)
    80003ec2:	6be2                	ld	s7,24(sp)
    80003ec4:	6c42                	ld	s8,16(sp)
    80003ec6:	6ca2                	ld	s9,8(sp)
    80003ec8:	6d02                	ld	s10,0(sp)
    80003eca:	6125                	addi	sp,sp,96
    80003ecc:	8082                	ret
      iunlock(ip);
    80003ece:	8552                	mv	a0,s4
    80003ed0:	00000097          	auipc	ra,0x0
    80003ed4:	aa2080e7          	jalr	-1374(ra) # 80003972 <iunlock>
      return ip;
    80003ed8:	bfe1                	j	80003eb0 <namex+0x6c>
      iunlockput(ip);
    80003eda:	8552                	mv	a0,s4
    80003edc:	00000097          	auipc	ra,0x0
    80003ee0:	c36080e7          	jalr	-970(ra) # 80003b12 <iunlockput>
      return 0;
    80003ee4:	8a4e                	mv	s4,s3
    80003ee6:	b7e9                	j	80003eb0 <namex+0x6c>
  len = path - s;
    80003ee8:	40998633          	sub	a2,s3,s1
    80003eec:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003ef0:	09acd863          	bge	s9,s10,80003f80 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003ef4:	4639                	li	a2,14
    80003ef6:	85a6                	mv	a1,s1
    80003ef8:	8556                	mv	a0,s5
    80003efa:	ffffd097          	auipc	ra,0xffffd
    80003efe:	e34080e7          	jalr	-460(ra) # 80000d2e <memmove>
    80003f02:	84ce                	mv	s1,s3
  while(*path == '/')
    80003f04:	0004c783          	lbu	a5,0(s1)
    80003f08:	01279763          	bne	a5,s2,80003f16 <namex+0xd2>
    path++;
    80003f0c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003f0e:	0004c783          	lbu	a5,0(s1)
    80003f12:	ff278de3          	beq	a5,s2,80003f0c <namex+0xc8>
    ilock(ip);
    80003f16:	8552                	mv	a0,s4
    80003f18:	00000097          	auipc	ra,0x0
    80003f1c:	998080e7          	jalr	-1640(ra) # 800038b0 <ilock>
    if(ip->type != T_DIR){
    80003f20:	044a1783          	lh	a5,68(s4)
    80003f24:	f98790e3          	bne	a5,s8,80003ea4 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003f28:	000b0563          	beqz	s6,80003f32 <namex+0xee>
    80003f2c:	0004c783          	lbu	a5,0(s1)
    80003f30:	dfd9                	beqz	a5,80003ece <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003f32:	865e                	mv	a2,s7
    80003f34:	85d6                	mv	a1,s5
    80003f36:	8552                	mv	a0,s4
    80003f38:	00000097          	auipc	ra,0x0
    80003f3c:	e5c080e7          	jalr	-420(ra) # 80003d94 <dirlookup>
    80003f40:	89aa                	mv	s3,a0
    80003f42:	dd41                	beqz	a0,80003eda <namex+0x96>
    iunlockput(ip);
    80003f44:	8552                	mv	a0,s4
    80003f46:	00000097          	auipc	ra,0x0
    80003f4a:	bcc080e7          	jalr	-1076(ra) # 80003b12 <iunlockput>
    ip = next;
    80003f4e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003f50:	0004c783          	lbu	a5,0(s1)
    80003f54:	01279763          	bne	a5,s2,80003f62 <namex+0x11e>
    path++;
    80003f58:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003f5a:	0004c783          	lbu	a5,0(s1)
    80003f5e:	ff278de3          	beq	a5,s2,80003f58 <namex+0x114>
  if(*path == 0)
    80003f62:	cb9d                	beqz	a5,80003f98 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003f64:	0004c783          	lbu	a5,0(s1)
    80003f68:	89a6                	mv	s3,s1
  len = path - s;
    80003f6a:	8d5e                	mv	s10,s7
    80003f6c:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003f6e:	01278963          	beq	a5,s2,80003f80 <namex+0x13c>
    80003f72:	dbbd                	beqz	a5,80003ee8 <namex+0xa4>
    path++;
    80003f74:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003f76:	0009c783          	lbu	a5,0(s3)
    80003f7a:	ff279ce3          	bne	a5,s2,80003f72 <namex+0x12e>
    80003f7e:	b7ad                	j	80003ee8 <namex+0xa4>
    memmove(name, s, len);
    80003f80:	2601                	sext.w	a2,a2
    80003f82:	85a6                	mv	a1,s1
    80003f84:	8556                	mv	a0,s5
    80003f86:	ffffd097          	auipc	ra,0xffffd
    80003f8a:	da8080e7          	jalr	-600(ra) # 80000d2e <memmove>
    name[len] = 0;
    80003f8e:	9d56                	add	s10,s10,s5
    80003f90:	000d0023          	sb	zero,0(s10)
    80003f94:	84ce                	mv	s1,s3
    80003f96:	b7bd                	j	80003f04 <namex+0xc0>
  if(nameiparent){
    80003f98:	f00b0ce3          	beqz	s6,80003eb0 <namex+0x6c>
    iput(ip);
    80003f9c:	8552                	mv	a0,s4
    80003f9e:	00000097          	auipc	ra,0x0
    80003fa2:	acc080e7          	jalr	-1332(ra) # 80003a6a <iput>
    return 0;
    80003fa6:	4a01                	li	s4,0
    80003fa8:	b721                	j	80003eb0 <namex+0x6c>

0000000080003faa <dirlink>:
{
    80003faa:	7139                	addi	sp,sp,-64
    80003fac:	fc06                	sd	ra,56(sp)
    80003fae:	f822                	sd	s0,48(sp)
    80003fb0:	f426                	sd	s1,40(sp)
    80003fb2:	f04a                	sd	s2,32(sp)
    80003fb4:	ec4e                	sd	s3,24(sp)
    80003fb6:	e852                	sd	s4,16(sp)
    80003fb8:	0080                	addi	s0,sp,64
    80003fba:	892a                	mv	s2,a0
    80003fbc:	8a2e                	mv	s4,a1
    80003fbe:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003fc0:	4601                	li	a2,0
    80003fc2:	00000097          	auipc	ra,0x0
    80003fc6:	dd2080e7          	jalr	-558(ra) # 80003d94 <dirlookup>
    80003fca:	e93d                	bnez	a0,80004040 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fcc:	04c92483          	lw	s1,76(s2)
    80003fd0:	c49d                	beqz	s1,80003ffe <dirlink+0x54>
    80003fd2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fd4:	4741                	li	a4,16
    80003fd6:	86a6                	mv	a3,s1
    80003fd8:	fc040613          	addi	a2,s0,-64
    80003fdc:	4581                	li	a1,0
    80003fde:	854a                	mv	a0,s2
    80003fe0:	00000097          	auipc	ra,0x0
    80003fe4:	b84080e7          	jalr	-1148(ra) # 80003b64 <readi>
    80003fe8:	47c1                	li	a5,16
    80003fea:	06f51163          	bne	a0,a5,8000404c <dirlink+0xa2>
    if(de.inum == 0)
    80003fee:	fc045783          	lhu	a5,-64(s0)
    80003ff2:	c791                	beqz	a5,80003ffe <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ff4:	24c1                	addiw	s1,s1,16
    80003ff6:	04c92783          	lw	a5,76(s2)
    80003ffa:	fcf4ede3          	bltu	s1,a5,80003fd4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003ffe:	4639                	li	a2,14
    80004000:	85d2                	mv	a1,s4
    80004002:	fc240513          	addi	a0,s0,-62
    80004006:	ffffd097          	auipc	ra,0xffffd
    8000400a:	dd8080e7          	jalr	-552(ra) # 80000dde <strncpy>
  de.inum = inum;
    8000400e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004012:	4741                	li	a4,16
    80004014:	86a6                	mv	a3,s1
    80004016:	fc040613          	addi	a2,s0,-64
    8000401a:	4581                	li	a1,0
    8000401c:	854a                	mv	a0,s2
    8000401e:	00000097          	auipc	ra,0x0
    80004022:	c3e080e7          	jalr	-962(ra) # 80003c5c <writei>
    80004026:	1541                	addi	a0,a0,-16
    80004028:	00a03533          	snez	a0,a0
    8000402c:	40a00533          	neg	a0,a0
}
    80004030:	70e2                	ld	ra,56(sp)
    80004032:	7442                	ld	s0,48(sp)
    80004034:	74a2                	ld	s1,40(sp)
    80004036:	7902                	ld	s2,32(sp)
    80004038:	69e2                	ld	s3,24(sp)
    8000403a:	6a42                	ld	s4,16(sp)
    8000403c:	6121                	addi	sp,sp,64
    8000403e:	8082                	ret
    iput(ip);
    80004040:	00000097          	auipc	ra,0x0
    80004044:	a2a080e7          	jalr	-1494(ra) # 80003a6a <iput>
    return -1;
    80004048:	557d                	li	a0,-1
    8000404a:	b7dd                	j	80004030 <dirlink+0x86>
      panic("dirlink read");
    8000404c:	00004517          	auipc	a0,0x4
    80004050:	6ac50513          	addi	a0,a0,1708 # 800086f8 <syscalls+0x2a8>
    80004054:	ffffc097          	auipc	ra,0xffffc
    80004058:	4ec080e7          	jalr	1260(ra) # 80000540 <panic>

000000008000405c <namei>:

struct inode*
namei(char *path)
{
    8000405c:	1101                	addi	sp,sp,-32
    8000405e:	ec06                	sd	ra,24(sp)
    80004060:	e822                	sd	s0,16(sp)
    80004062:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004064:	fe040613          	addi	a2,s0,-32
    80004068:	4581                	li	a1,0
    8000406a:	00000097          	auipc	ra,0x0
    8000406e:	dda080e7          	jalr	-550(ra) # 80003e44 <namex>
}
    80004072:	60e2                	ld	ra,24(sp)
    80004074:	6442                	ld	s0,16(sp)
    80004076:	6105                	addi	sp,sp,32
    80004078:	8082                	ret

000000008000407a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000407a:	1141                	addi	sp,sp,-16
    8000407c:	e406                	sd	ra,8(sp)
    8000407e:	e022                	sd	s0,0(sp)
    80004080:	0800                	addi	s0,sp,16
    80004082:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004084:	4585                	li	a1,1
    80004086:	00000097          	auipc	ra,0x0
    8000408a:	dbe080e7          	jalr	-578(ra) # 80003e44 <namex>
}
    8000408e:	60a2                	ld	ra,8(sp)
    80004090:	6402                	ld	s0,0(sp)
    80004092:	0141                	addi	sp,sp,16
    80004094:	8082                	ret

0000000080004096 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004096:	1101                	addi	sp,sp,-32
    80004098:	ec06                	sd	ra,24(sp)
    8000409a:	e822                	sd	s0,16(sp)
    8000409c:	e426                	sd	s1,8(sp)
    8000409e:	e04a                	sd	s2,0(sp)
    800040a0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800040a2:	0001d917          	auipc	s2,0x1d
    800040a6:	bee90913          	addi	s2,s2,-1042 # 80020c90 <log>
    800040aa:	01892583          	lw	a1,24(s2)
    800040ae:	02892503          	lw	a0,40(s2)
    800040b2:	fffff097          	auipc	ra,0xfffff
    800040b6:	fe6080e7          	jalr	-26(ra) # 80003098 <bread>
    800040ba:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800040bc:	02c92683          	lw	a3,44(s2)
    800040c0:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800040c2:	02d05863          	blez	a3,800040f2 <write_head+0x5c>
    800040c6:	0001d797          	auipc	a5,0x1d
    800040ca:	bfa78793          	addi	a5,a5,-1030 # 80020cc0 <log+0x30>
    800040ce:	05c50713          	addi	a4,a0,92
    800040d2:	36fd                	addiw	a3,a3,-1
    800040d4:	02069613          	slli	a2,a3,0x20
    800040d8:	01e65693          	srli	a3,a2,0x1e
    800040dc:	0001d617          	auipc	a2,0x1d
    800040e0:	be860613          	addi	a2,a2,-1048 # 80020cc4 <log+0x34>
    800040e4:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800040e6:	4390                	lw	a2,0(a5)
    800040e8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040ea:	0791                	addi	a5,a5,4
    800040ec:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800040ee:	fed79ce3          	bne	a5,a3,800040e6 <write_head+0x50>
  }
  bwrite(buf);
    800040f2:	8526                	mv	a0,s1
    800040f4:	fffff097          	auipc	ra,0xfffff
    800040f8:	096080e7          	jalr	150(ra) # 8000318a <bwrite>
  brelse(buf);
    800040fc:	8526                	mv	a0,s1
    800040fe:	fffff097          	auipc	ra,0xfffff
    80004102:	0ca080e7          	jalr	202(ra) # 800031c8 <brelse>
}
    80004106:	60e2                	ld	ra,24(sp)
    80004108:	6442                	ld	s0,16(sp)
    8000410a:	64a2                	ld	s1,8(sp)
    8000410c:	6902                	ld	s2,0(sp)
    8000410e:	6105                	addi	sp,sp,32
    80004110:	8082                	ret

0000000080004112 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004112:	0001d797          	auipc	a5,0x1d
    80004116:	baa7a783          	lw	a5,-1110(a5) # 80020cbc <log+0x2c>
    8000411a:	0af05d63          	blez	a5,800041d4 <install_trans+0xc2>
{
    8000411e:	7139                	addi	sp,sp,-64
    80004120:	fc06                	sd	ra,56(sp)
    80004122:	f822                	sd	s0,48(sp)
    80004124:	f426                	sd	s1,40(sp)
    80004126:	f04a                	sd	s2,32(sp)
    80004128:	ec4e                	sd	s3,24(sp)
    8000412a:	e852                	sd	s4,16(sp)
    8000412c:	e456                	sd	s5,8(sp)
    8000412e:	e05a                	sd	s6,0(sp)
    80004130:	0080                	addi	s0,sp,64
    80004132:	8b2a                	mv	s6,a0
    80004134:	0001da97          	auipc	s5,0x1d
    80004138:	b8ca8a93          	addi	s5,s5,-1140 # 80020cc0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000413c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000413e:	0001d997          	auipc	s3,0x1d
    80004142:	b5298993          	addi	s3,s3,-1198 # 80020c90 <log>
    80004146:	a00d                	j	80004168 <install_trans+0x56>
    brelse(lbuf);
    80004148:	854a                	mv	a0,s2
    8000414a:	fffff097          	auipc	ra,0xfffff
    8000414e:	07e080e7          	jalr	126(ra) # 800031c8 <brelse>
    brelse(dbuf);
    80004152:	8526                	mv	a0,s1
    80004154:	fffff097          	auipc	ra,0xfffff
    80004158:	074080e7          	jalr	116(ra) # 800031c8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000415c:	2a05                	addiw	s4,s4,1
    8000415e:	0a91                	addi	s5,s5,4
    80004160:	02c9a783          	lw	a5,44(s3)
    80004164:	04fa5e63          	bge	s4,a5,800041c0 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004168:	0189a583          	lw	a1,24(s3)
    8000416c:	014585bb          	addw	a1,a1,s4
    80004170:	2585                	addiw	a1,a1,1
    80004172:	0289a503          	lw	a0,40(s3)
    80004176:	fffff097          	auipc	ra,0xfffff
    8000417a:	f22080e7          	jalr	-222(ra) # 80003098 <bread>
    8000417e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004180:	000aa583          	lw	a1,0(s5)
    80004184:	0289a503          	lw	a0,40(s3)
    80004188:	fffff097          	auipc	ra,0xfffff
    8000418c:	f10080e7          	jalr	-240(ra) # 80003098 <bread>
    80004190:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004192:	40000613          	li	a2,1024
    80004196:	05890593          	addi	a1,s2,88
    8000419a:	05850513          	addi	a0,a0,88
    8000419e:	ffffd097          	auipc	ra,0xffffd
    800041a2:	b90080e7          	jalr	-1136(ra) # 80000d2e <memmove>
    bwrite(dbuf);  // write dst to disk
    800041a6:	8526                	mv	a0,s1
    800041a8:	fffff097          	auipc	ra,0xfffff
    800041ac:	fe2080e7          	jalr	-30(ra) # 8000318a <bwrite>
    if(recovering == 0)
    800041b0:	f80b1ce3          	bnez	s6,80004148 <install_trans+0x36>
      bunpin(dbuf);
    800041b4:	8526                	mv	a0,s1
    800041b6:	fffff097          	auipc	ra,0xfffff
    800041ba:	0ec080e7          	jalr	236(ra) # 800032a2 <bunpin>
    800041be:	b769                	j	80004148 <install_trans+0x36>
}
    800041c0:	70e2                	ld	ra,56(sp)
    800041c2:	7442                	ld	s0,48(sp)
    800041c4:	74a2                	ld	s1,40(sp)
    800041c6:	7902                	ld	s2,32(sp)
    800041c8:	69e2                	ld	s3,24(sp)
    800041ca:	6a42                	ld	s4,16(sp)
    800041cc:	6aa2                	ld	s5,8(sp)
    800041ce:	6b02                	ld	s6,0(sp)
    800041d0:	6121                	addi	sp,sp,64
    800041d2:	8082                	ret
    800041d4:	8082                	ret

00000000800041d6 <initlog>:
{
    800041d6:	7179                	addi	sp,sp,-48
    800041d8:	f406                	sd	ra,40(sp)
    800041da:	f022                	sd	s0,32(sp)
    800041dc:	ec26                	sd	s1,24(sp)
    800041de:	e84a                	sd	s2,16(sp)
    800041e0:	e44e                	sd	s3,8(sp)
    800041e2:	1800                	addi	s0,sp,48
    800041e4:	892a                	mv	s2,a0
    800041e6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800041e8:	0001d497          	auipc	s1,0x1d
    800041ec:	aa848493          	addi	s1,s1,-1368 # 80020c90 <log>
    800041f0:	00004597          	auipc	a1,0x4
    800041f4:	51858593          	addi	a1,a1,1304 # 80008708 <syscalls+0x2b8>
    800041f8:	8526                	mv	a0,s1
    800041fa:	ffffd097          	auipc	ra,0xffffd
    800041fe:	94c080e7          	jalr	-1716(ra) # 80000b46 <initlock>
  log.start = sb->logstart;
    80004202:	0149a583          	lw	a1,20(s3)
    80004206:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004208:	0109a783          	lw	a5,16(s3)
    8000420c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000420e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004212:	854a                	mv	a0,s2
    80004214:	fffff097          	auipc	ra,0xfffff
    80004218:	e84080e7          	jalr	-380(ra) # 80003098 <bread>
  log.lh.n = lh->n;
    8000421c:	4d34                	lw	a3,88(a0)
    8000421e:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004220:	02d05663          	blez	a3,8000424c <initlog+0x76>
    80004224:	05c50793          	addi	a5,a0,92
    80004228:	0001d717          	auipc	a4,0x1d
    8000422c:	a9870713          	addi	a4,a4,-1384 # 80020cc0 <log+0x30>
    80004230:	36fd                	addiw	a3,a3,-1
    80004232:	02069613          	slli	a2,a3,0x20
    80004236:	01e65693          	srli	a3,a2,0x1e
    8000423a:	06050613          	addi	a2,a0,96
    8000423e:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004240:	4390                	lw	a2,0(a5)
    80004242:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004244:	0791                	addi	a5,a5,4
    80004246:	0711                	addi	a4,a4,4
    80004248:	fed79ce3          	bne	a5,a3,80004240 <initlog+0x6a>
  brelse(buf);
    8000424c:	fffff097          	auipc	ra,0xfffff
    80004250:	f7c080e7          	jalr	-132(ra) # 800031c8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004254:	4505                	li	a0,1
    80004256:	00000097          	auipc	ra,0x0
    8000425a:	ebc080e7          	jalr	-324(ra) # 80004112 <install_trans>
  log.lh.n = 0;
    8000425e:	0001d797          	auipc	a5,0x1d
    80004262:	a407af23          	sw	zero,-1442(a5) # 80020cbc <log+0x2c>
  write_head(); // clear the log
    80004266:	00000097          	auipc	ra,0x0
    8000426a:	e30080e7          	jalr	-464(ra) # 80004096 <write_head>
}
    8000426e:	70a2                	ld	ra,40(sp)
    80004270:	7402                	ld	s0,32(sp)
    80004272:	64e2                	ld	s1,24(sp)
    80004274:	6942                	ld	s2,16(sp)
    80004276:	69a2                	ld	s3,8(sp)
    80004278:	6145                	addi	sp,sp,48
    8000427a:	8082                	ret

000000008000427c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000427c:	1101                	addi	sp,sp,-32
    8000427e:	ec06                	sd	ra,24(sp)
    80004280:	e822                	sd	s0,16(sp)
    80004282:	e426                	sd	s1,8(sp)
    80004284:	e04a                	sd	s2,0(sp)
    80004286:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004288:	0001d517          	auipc	a0,0x1d
    8000428c:	a0850513          	addi	a0,a0,-1528 # 80020c90 <log>
    80004290:	ffffd097          	auipc	ra,0xffffd
    80004294:	946080e7          	jalr	-1722(ra) # 80000bd6 <acquire>
  while(1){
    if(log.committing){
    80004298:	0001d497          	auipc	s1,0x1d
    8000429c:	9f848493          	addi	s1,s1,-1544 # 80020c90 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800042a0:	4979                	li	s2,30
    800042a2:	a039                	j	800042b0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800042a4:	85a6                	mv	a1,s1
    800042a6:	8526                	mv	a0,s1
    800042a8:	ffffe097          	auipc	ra,0xffffe
    800042ac:	dac080e7          	jalr	-596(ra) # 80002054 <sleep>
    if(log.committing){
    800042b0:	50dc                	lw	a5,36(s1)
    800042b2:	fbed                	bnez	a5,800042a4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800042b4:	5098                	lw	a4,32(s1)
    800042b6:	2705                	addiw	a4,a4,1
    800042b8:	0007069b          	sext.w	a3,a4
    800042bc:	0027179b          	slliw	a5,a4,0x2
    800042c0:	9fb9                	addw	a5,a5,a4
    800042c2:	0017979b          	slliw	a5,a5,0x1
    800042c6:	54d8                	lw	a4,44(s1)
    800042c8:	9fb9                	addw	a5,a5,a4
    800042ca:	00f95963          	bge	s2,a5,800042dc <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800042ce:	85a6                	mv	a1,s1
    800042d0:	8526                	mv	a0,s1
    800042d2:	ffffe097          	auipc	ra,0xffffe
    800042d6:	d82080e7          	jalr	-638(ra) # 80002054 <sleep>
    800042da:	bfd9                	j	800042b0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800042dc:	0001d517          	auipc	a0,0x1d
    800042e0:	9b450513          	addi	a0,a0,-1612 # 80020c90 <log>
    800042e4:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800042e6:	ffffd097          	auipc	ra,0xffffd
    800042ea:	9a4080e7          	jalr	-1628(ra) # 80000c8a <release>
      break;
    }
  }
}
    800042ee:	60e2                	ld	ra,24(sp)
    800042f0:	6442                	ld	s0,16(sp)
    800042f2:	64a2                	ld	s1,8(sp)
    800042f4:	6902                	ld	s2,0(sp)
    800042f6:	6105                	addi	sp,sp,32
    800042f8:	8082                	ret

00000000800042fa <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800042fa:	7139                	addi	sp,sp,-64
    800042fc:	fc06                	sd	ra,56(sp)
    800042fe:	f822                	sd	s0,48(sp)
    80004300:	f426                	sd	s1,40(sp)
    80004302:	f04a                	sd	s2,32(sp)
    80004304:	ec4e                	sd	s3,24(sp)
    80004306:	e852                	sd	s4,16(sp)
    80004308:	e456                	sd	s5,8(sp)
    8000430a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000430c:	0001d497          	auipc	s1,0x1d
    80004310:	98448493          	addi	s1,s1,-1660 # 80020c90 <log>
    80004314:	8526                	mv	a0,s1
    80004316:	ffffd097          	auipc	ra,0xffffd
    8000431a:	8c0080e7          	jalr	-1856(ra) # 80000bd6 <acquire>
  log.outstanding -= 1;
    8000431e:	509c                	lw	a5,32(s1)
    80004320:	37fd                	addiw	a5,a5,-1
    80004322:	0007891b          	sext.w	s2,a5
    80004326:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004328:	50dc                	lw	a5,36(s1)
    8000432a:	e7b9                	bnez	a5,80004378 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000432c:	04091e63          	bnez	s2,80004388 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004330:	0001d497          	auipc	s1,0x1d
    80004334:	96048493          	addi	s1,s1,-1696 # 80020c90 <log>
    80004338:	4785                	li	a5,1
    8000433a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000433c:	8526                	mv	a0,s1
    8000433e:	ffffd097          	auipc	ra,0xffffd
    80004342:	94c080e7          	jalr	-1716(ra) # 80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004346:	54dc                	lw	a5,44(s1)
    80004348:	06f04763          	bgtz	a5,800043b6 <end_op+0xbc>
    acquire(&log.lock);
    8000434c:	0001d497          	auipc	s1,0x1d
    80004350:	94448493          	addi	s1,s1,-1724 # 80020c90 <log>
    80004354:	8526                	mv	a0,s1
    80004356:	ffffd097          	auipc	ra,0xffffd
    8000435a:	880080e7          	jalr	-1920(ra) # 80000bd6 <acquire>
    log.committing = 0;
    8000435e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004362:	8526                	mv	a0,s1
    80004364:	ffffe097          	auipc	ra,0xffffe
    80004368:	d54080e7          	jalr	-684(ra) # 800020b8 <wakeup>
    release(&log.lock);
    8000436c:	8526                	mv	a0,s1
    8000436e:	ffffd097          	auipc	ra,0xffffd
    80004372:	91c080e7          	jalr	-1764(ra) # 80000c8a <release>
}
    80004376:	a03d                	j	800043a4 <end_op+0xaa>
    panic("log.committing");
    80004378:	00004517          	auipc	a0,0x4
    8000437c:	39850513          	addi	a0,a0,920 # 80008710 <syscalls+0x2c0>
    80004380:	ffffc097          	auipc	ra,0xffffc
    80004384:	1c0080e7          	jalr	448(ra) # 80000540 <panic>
    wakeup(&log);
    80004388:	0001d497          	auipc	s1,0x1d
    8000438c:	90848493          	addi	s1,s1,-1784 # 80020c90 <log>
    80004390:	8526                	mv	a0,s1
    80004392:	ffffe097          	auipc	ra,0xffffe
    80004396:	d26080e7          	jalr	-730(ra) # 800020b8 <wakeup>
  release(&log.lock);
    8000439a:	8526                	mv	a0,s1
    8000439c:	ffffd097          	auipc	ra,0xffffd
    800043a0:	8ee080e7          	jalr	-1810(ra) # 80000c8a <release>
}
    800043a4:	70e2                	ld	ra,56(sp)
    800043a6:	7442                	ld	s0,48(sp)
    800043a8:	74a2                	ld	s1,40(sp)
    800043aa:	7902                	ld	s2,32(sp)
    800043ac:	69e2                	ld	s3,24(sp)
    800043ae:	6a42                	ld	s4,16(sp)
    800043b0:	6aa2                	ld	s5,8(sp)
    800043b2:	6121                	addi	sp,sp,64
    800043b4:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800043b6:	0001da97          	auipc	s5,0x1d
    800043ba:	90aa8a93          	addi	s5,s5,-1782 # 80020cc0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800043be:	0001da17          	auipc	s4,0x1d
    800043c2:	8d2a0a13          	addi	s4,s4,-1838 # 80020c90 <log>
    800043c6:	018a2583          	lw	a1,24(s4)
    800043ca:	012585bb          	addw	a1,a1,s2
    800043ce:	2585                	addiw	a1,a1,1
    800043d0:	028a2503          	lw	a0,40(s4)
    800043d4:	fffff097          	auipc	ra,0xfffff
    800043d8:	cc4080e7          	jalr	-828(ra) # 80003098 <bread>
    800043dc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800043de:	000aa583          	lw	a1,0(s5)
    800043e2:	028a2503          	lw	a0,40(s4)
    800043e6:	fffff097          	auipc	ra,0xfffff
    800043ea:	cb2080e7          	jalr	-846(ra) # 80003098 <bread>
    800043ee:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800043f0:	40000613          	li	a2,1024
    800043f4:	05850593          	addi	a1,a0,88
    800043f8:	05848513          	addi	a0,s1,88
    800043fc:	ffffd097          	auipc	ra,0xffffd
    80004400:	932080e7          	jalr	-1742(ra) # 80000d2e <memmove>
    bwrite(to);  // write the log
    80004404:	8526                	mv	a0,s1
    80004406:	fffff097          	auipc	ra,0xfffff
    8000440a:	d84080e7          	jalr	-636(ra) # 8000318a <bwrite>
    brelse(from);
    8000440e:	854e                	mv	a0,s3
    80004410:	fffff097          	auipc	ra,0xfffff
    80004414:	db8080e7          	jalr	-584(ra) # 800031c8 <brelse>
    brelse(to);
    80004418:	8526                	mv	a0,s1
    8000441a:	fffff097          	auipc	ra,0xfffff
    8000441e:	dae080e7          	jalr	-594(ra) # 800031c8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004422:	2905                	addiw	s2,s2,1
    80004424:	0a91                	addi	s5,s5,4
    80004426:	02ca2783          	lw	a5,44(s4)
    8000442a:	f8f94ee3          	blt	s2,a5,800043c6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000442e:	00000097          	auipc	ra,0x0
    80004432:	c68080e7          	jalr	-920(ra) # 80004096 <write_head>
    install_trans(0); // Now install writes to home locations
    80004436:	4501                	li	a0,0
    80004438:	00000097          	auipc	ra,0x0
    8000443c:	cda080e7          	jalr	-806(ra) # 80004112 <install_trans>
    log.lh.n = 0;
    80004440:	0001d797          	auipc	a5,0x1d
    80004444:	8607ae23          	sw	zero,-1924(a5) # 80020cbc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004448:	00000097          	auipc	ra,0x0
    8000444c:	c4e080e7          	jalr	-946(ra) # 80004096 <write_head>
    80004450:	bdf5                	j	8000434c <end_op+0x52>

0000000080004452 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004452:	1101                	addi	sp,sp,-32
    80004454:	ec06                	sd	ra,24(sp)
    80004456:	e822                	sd	s0,16(sp)
    80004458:	e426                	sd	s1,8(sp)
    8000445a:	e04a                	sd	s2,0(sp)
    8000445c:	1000                	addi	s0,sp,32
    8000445e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004460:	0001d917          	auipc	s2,0x1d
    80004464:	83090913          	addi	s2,s2,-2000 # 80020c90 <log>
    80004468:	854a                	mv	a0,s2
    8000446a:	ffffc097          	auipc	ra,0xffffc
    8000446e:	76c080e7          	jalr	1900(ra) # 80000bd6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004472:	02c92603          	lw	a2,44(s2)
    80004476:	47f5                	li	a5,29
    80004478:	06c7c563          	blt	a5,a2,800044e2 <log_write+0x90>
    8000447c:	0001d797          	auipc	a5,0x1d
    80004480:	8307a783          	lw	a5,-2000(a5) # 80020cac <log+0x1c>
    80004484:	37fd                	addiw	a5,a5,-1
    80004486:	04f65e63          	bge	a2,a5,800044e2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000448a:	0001d797          	auipc	a5,0x1d
    8000448e:	8267a783          	lw	a5,-2010(a5) # 80020cb0 <log+0x20>
    80004492:	06f05063          	blez	a5,800044f2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004496:	4781                	li	a5,0
    80004498:	06c05563          	blez	a2,80004502 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000449c:	44cc                	lw	a1,12(s1)
    8000449e:	0001d717          	auipc	a4,0x1d
    800044a2:	82270713          	addi	a4,a4,-2014 # 80020cc0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800044a6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800044a8:	4314                	lw	a3,0(a4)
    800044aa:	04b68c63          	beq	a3,a1,80004502 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800044ae:	2785                	addiw	a5,a5,1
    800044b0:	0711                	addi	a4,a4,4
    800044b2:	fef61be3          	bne	a2,a5,800044a8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800044b6:	0621                	addi	a2,a2,8
    800044b8:	060a                	slli	a2,a2,0x2
    800044ba:	0001c797          	auipc	a5,0x1c
    800044be:	7d678793          	addi	a5,a5,2006 # 80020c90 <log>
    800044c2:	97b2                	add	a5,a5,a2
    800044c4:	44d8                	lw	a4,12(s1)
    800044c6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800044c8:	8526                	mv	a0,s1
    800044ca:	fffff097          	auipc	ra,0xfffff
    800044ce:	d9c080e7          	jalr	-612(ra) # 80003266 <bpin>
    log.lh.n++;
    800044d2:	0001c717          	auipc	a4,0x1c
    800044d6:	7be70713          	addi	a4,a4,1982 # 80020c90 <log>
    800044da:	575c                	lw	a5,44(a4)
    800044dc:	2785                	addiw	a5,a5,1
    800044de:	d75c                	sw	a5,44(a4)
    800044e0:	a82d                	j	8000451a <log_write+0xc8>
    panic("too big a transaction");
    800044e2:	00004517          	auipc	a0,0x4
    800044e6:	23e50513          	addi	a0,a0,574 # 80008720 <syscalls+0x2d0>
    800044ea:	ffffc097          	auipc	ra,0xffffc
    800044ee:	056080e7          	jalr	86(ra) # 80000540 <panic>
    panic("log_write outside of trans");
    800044f2:	00004517          	auipc	a0,0x4
    800044f6:	24650513          	addi	a0,a0,582 # 80008738 <syscalls+0x2e8>
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	046080e7          	jalr	70(ra) # 80000540 <panic>
  log.lh.block[i] = b->blockno;
    80004502:	00878693          	addi	a3,a5,8
    80004506:	068a                	slli	a3,a3,0x2
    80004508:	0001c717          	auipc	a4,0x1c
    8000450c:	78870713          	addi	a4,a4,1928 # 80020c90 <log>
    80004510:	9736                	add	a4,a4,a3
    80004512:	44d4                	lw	a3,12(s1)
    80004514:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004516:	faf609e3          	beq	a2,a5,800044c8 <log_write+0x76>
  }
  release(&log.lock);
    8000451a:	0001c517          	auipc	a0,0x1c
    8000451e:	77650513          	addi	a0,a0,1910 # 80020c90 <log>
    80004522:	ffffc097          	auipc	ra,0xffffc
    80004526:	768080e7          	jalr	1896(ra) # 80000c8a <release>
}
    8000452a:	60e2                	ld	ra,24(sp)
    8000452c:	6442                	ld	s0,16(sp)
    8000452e:	64a2                	ld	s1,8(sp)
    80004530:	6902                	ld	s2,0(sp)
    80004532:	6105                	addi	sp,sp,32
    80004534:	8082                	ret

0000000080004536 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004536:	1101                	addi	sp,sp,-32
    80004538:	ec06                	sd	ra,24(sp)
    8000453a:	e822                	sd	s0,16(sp)
    8000453c:	e426                	sd	s1,8(sp)
    8000453e:	e04a                	sd	s2,0(sp)
    80004540:	1000                	addi	s0,sp,32
    80004542:	84aa                	mv	s1,a0
    80004544:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004546:	00004597          	auipc	a1,0x4
    8000454a:	21258593          	addi	a1,a1,530 # 80008758 <syscalls+0x308>
    8000454e:	0521                	addi	a0,a0,8
    80004550:	ffffc097          	auipc	ra,0xffffc
    80004554:	5f6080e7          	jalr	1526(ra) # 80000b46 <initlock>
  lk->name = name;
    80004558:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000455c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004560:	0204a423          	sw	zero,40(s1)
}
    80004564:	60e2                	ld	ra,24(sp)
    80004566:	6442                	ld	s0,16(sp)
    80004568:	64a2                	ld	s1,8(sp)
    8000456a:	6902                	ld	s2,0(sp)
    8000456c:	6105                	addi	sp,sp,32
    8000456e:	8082                	ret

0000000080004570 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004570:	1101                	addi	sp,sp,-32
    80004572:	ec06                	sd	ra,24(sp)
    80004574:	e822                	sd	s0,16(sp)
    80004576:	e426                	sd	s1,8(sp)
    80004578:	e04a                	sd	s2,0(sp)
    8000457a:	1000                	addi	s0,sp,32
    8000457c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000457e:	00850913          	addi	s2,a0,8
    80004582:	854a                	mv	a0,s2
    80004584:	ffffc097          	auipc	ra,0xffffc
    80004588:	652080e7          	jalr	1618(ra) # 80000bd6 <acquire>
  while (lk->locked) {
    8000458c:	409c                	lw	a5,0(s1)
    8000458e:	cb89                	beqz	a5,800045a0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004590:	85ca                	mv	a1,s2
    80004592:	8526                	mv	a0,s1
    80004594:	ffffe097          	auipc	ra,0xffffe
    80004598:	ac0080e7          	jalr	-1344(ra) # 80002054 <sleep>
  while (lk->locked) {
    8000459c:	409c                	lw	a5,0(s1)
    8000459e:	fbed                	bnez	a5,80004590 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800045a0:	4785                	li	a5,1
    800045a2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800045a4:	ffffd097          	auipc	ra,0xffffd
    800045a8:	408080e7          	jalr	1032(ra) # 800019ac <myproc>
    800045ac:	591c                	lw	a5,48(a0)
    800045ae:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800045b0:	854a                	mv	a0,s2
    800045b2:	ffffc097          	auipc	ra,0xffffc
    800045b6:	6d8080e7          	jalr	1752(ra) # 80000c8a <release>
}
    800045ba:	60e2                	ld	ra,24(sp)
    800045bc:	6442                	ld	s0,16(sp)
    800045be:	64a2                	ld	s1,8(sp)
    800045c0:	6902                	ld	s2,0(sp)
    800045c2:	6105                	addi	sp,sp,32
    800045c4:	8082                	ret

00000000800045c6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800045c6:	1101                	addi	sp,sp,-32
    800045c8:	ec06                	sd	ra,24(sp)
    800045ca:	e822                	sd	s0,16(sp)
    800045cc:	e426                	sd	s1,8(sp)
    800045ce:	e04a                	sd	s2,0(sp)
    800045d0:	1000                	addi	s0,sp,32
    800045d2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800045d4:	00850913          	addi	s2,a0,8
    800045d8:	854a                	mv	a0,s2
    800045da:	ffffc097          	auipc	ra,0xffffc
    800045de:	5fc080e7          	jalr	1532(ra) # 80000bd6 <acquire>
  lk->locked = 0;
    800045e2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800045e6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800045ea:	8526                	mv	a0,s1
    800045ec:	ffffe097          	auipc	ra,0xffffe
    800045f0:	acc080e7          	jalr	-1332(ra) # 800020b8 <wakeup>
  release(&lk->lk);
    800045f4:	854a                	mv	a0,s2
    800045f6:	ffffc097          	auipc	ra,0xffffc
    800045fa:	694080e7          	jalr	1684(ra) # 80000c8a <release>
}
    800045fe:	60e2                	ld	ra,24(sp)
    80004600:	6442                	ld	s0,16(sp)
    80004602:	64a2                	ld	s1,8(sp)
    80004604:	6902                	ld	s2,0(sp)
    80004606:	6105                	addi	sp,sp,32
    80004608:	8082                	ret

000000008000460a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000460a:	7179                	addi	sp,sp,-48
    8000460c:	f406                	sd	ra,40(sp)
    8000460e:	f022                	sd	s0,32(sp)
    80004610:	ec26                	sd	s1,24(sp)
    80004612:	e84a                	sd	s2,16(sp)
    80004614:	e44e                	sd	s3,8(sp)
    80004616:	1800                	addi	s0,sp,48
    80004618:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000461a:	00850913          	addi	s2,a0,8
    8000461e:	854a                	mv	a0,s2
    80004620:	ffffc097          	auipc	ra,0xffffc
    80004624:	5b6080e7          	jalr	1462(ra) # 80000bd6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004628:	409c                	lw	a5,0(s1)
    8000462a:	ef99                	bnez	a5,80004648 <holdingsleep+0x3e>
    8000462c:	4481                	li	s1,0
  release(&lk->lk);
    8000462e:	854a                	mv	a0,s2
    80004630:	ffffc097          	auipc	ra,0xffffc
    80004634:	65a080e7          	jalr	1626(ra) # 80000c8a <release>
  return r;
}
    80004638:	8526                	mv	a0,s1
    8000463a:	70a2                	ld	ra,40(sp)
    8000463c:	7402                	ld	s0,32(sp)
    8000463e:	64e2                	ld	s1,24(sp)
    80004640:	6942                	ld	s2,16(sp)
    80004642:	69a2                	ld	s3,8(sp)
    80004644:	6145                	addi	sp,sp,48
    80004646:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004648:	0284a983          	lw	s3,40(s1)
    8000464c:	ffffd097          	auipc	ra,0xffffd
    80004650:	360080e7          	jalr	864(ra) # 800019ac <myproc>
    80004654:	5904                	lw	s1,48(a0)
    80004656:	413484b3          	sub	s1,s1,s3
    8000465a:	0014b493          	seqz	s1,s1
    8000465e:	bfc1                	j	8000462e <holdingsleep+0x24>

0000000080004660 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004660:	1141                	addi	sp,sp,-16
    80004662:	e406                	sd	ra,8(sp)
    80004664:	e022                	sd	s0,0(sp)
    80004666:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004668:	00004597          	auipc	a1,0x4
    8000466c:	10058593          	addi	a1,a1,256 # 80008768 <syscalls+0x318>
    80004670:	0001c517          	auipc	a0,0x1c
    80004674:	76850513          	addi	a0,a0,1896 # 80020dd8 <ftable>
    80004678:	ffffc097          	auipc	ra,0xffffc
    8000467c:	4ce080e7          	jalr	1230(ra) # 80000b46 <initlock>
}
    80004680:	60a2                	ld	ra,8(sp)
    80004682:	6402                	ld	s0,0(sp)
    80004684:	0141                	addi	sp,sp,16
    80004686:	8082                	ret

0000000080004688 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004688:	1101                	addi	sp,sp,-32
    8000468a:	ec06                	sd	ra,24(sp)
    8000468c:	e822                	sd	s0,16(sp)
    8000468e:	e426                	sd	s1,8(sp)
    80004690:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004692:	0001c517          	auipc	a0,0x1c
    80004696:	74650513          	addi	a0,a0,1862 # 80020dd8 <ftable>
    8000469a:	ffffc097          	auipc	ra,0xffffc
    8000469e:	53c080e7          	jalr	1340(ra) # 80000bd6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800046a2:	0001c497          	auipc	s1,0x1c
    800046a6:	74e48493          	addi	s1,s1,1870 # 80020df0 <ftable+0x18>
    800046aa:	0001d717          	auipc	a4,0x1d
    800046ae:	6e670713          	addi	a4,a4,1766 # 80021d90 <disk>
    if(f->ref == 0){
    800046b2:	40dc                	lw	a5,4(s1)
    800046b4:	cf99                	beqz	a5,800046d2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800046b6:	02848493          	addi	s1,s1,40
    800046ba:	fee49ce3          	bne	s1,a4,800046b2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800046be:	0001c517          	auipc	a0,0x1c
    800046c2:	71a50513          	addi	a0,a0,1818 # 80020dd8 <ftable>
    800046c6:	ffffc097          	auipc	ra,0xffffc
    800046ca:	5c4080e7          	jalr	1476(ra) # 80000c8a <release>
  return 0;
    800046ce:	4481                	li	s1,0
    800046d0:	a819                	j	800046e6 <filealloc+0x5e>
      f->ref = 1;
    800046d2:	4785                	li	a5,1
    800046d4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800046d6:	0001c517          	auipc	a0,0x1c
    800046da:	70250513          	addi	a0,a0,1794 # 80020dd8 <ftable>
    800046de:	ffffc097          	auipc	ra,0xffffc
    800046e2:	5ac080e7          	jalr	1452(ra) # 80000c8a <release>
}
    800046e6:	8526                	mv	a0,s1
    800046e8:	60e2                	ld	ra,24(sp)
    800046ea:	6442                	ld	s0,16(sp)
    800046ec:	64a2                	ld	s1,8(sp)
    800046ee:	6105                	addi	sp,sp,32
    800046f0:	8082                	ret

00000000800046f2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800046f2:	1101                	addi	sp,sp,-32
    800046f4:	ec06                	sd	ra,24(sp)
    800046f6:	e822                	sd	s0,16(sp)
    800046f8:	e426                	sd	s1,8(sp)
    800046fa:	1000                	addi	s0,sp,32
    800046fc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800046fe:	0001c517          	auipc	a0,0x1c
    80004702:	6da50513          	addi	a0,a0,1754 # 80020dd8 <ftable>
    80004706:	ffffc097          	auipc	ra,0xffffc
    8000470a:	4d0080e7          	jalr	1232(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    8000470e:	40dc                	lw	a5,4(s1)
    80004710:	02f05263          	blez	a5,80004734 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004714:	2785                	addiw	a5,a5,1
    80004716:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004718:	0001c517          	auipc	a0,0x1c
    8000471c:	6c050513          	addi	a0,a0,1728 # 80020dd8 <ftable>
    80004720:	ffffc097          	auipc	ra,0xffffc
    80004724:	56a080e7          	jalr	1386(ra) # 80000c8a <release>
  return f;
}
    80004728:	8526                	mv	a0,s1
    8000472a:	60e2                	ld	ra,24(sp)
    8000472c:	6442                	ld	s0,16(sp)
    8000472e:	64a2                	ld	s1,8(sp)
    80004730:	6105                	addi	sp,sp,32
    80004732:	8082                	ret
    panic("filedup");
    80004734:	00004517          	auipc	a0,0x4
    80004738:	03c50513          	addi	a0,a0,60 # 80008770 <syscalls+0x320>
    8000473c:	ffffc097          	auipc	ra,0xffffc
    80004740:	e04080e7          	jalr	-508(ra) # 80000540 <panic>

0000000080004744 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004744:	7139                	addi	sp,sp,-64
    80004746:	fc06                	sd	ra,56(sp)
    80004748:	f822                	sd	s0,48(sp)
    8000474a:	f426                	sd	s1,40(sp)
    8000474c:	f04a                	sd	s2,32(sp)
    8000474e:	ec4e                	sd	s3,24(sp)
    80004750:	e852                	sd	s4,16(sp)
    80004752:	e456                	sd	s5,8(sp)
    80004754:	0080                	addi	s0,sp,64
    80004756:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004758:	0001c517          	auipc	a0,0x1c
    8000475c:	68050513          	addi	a0,a0,1664 # 80020dd8 <ftable>
    80004760:	ffffc097          	auipc	ra,0xffffc
    80004764:	476080e7          	jalr	1142(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    80004768:	40dc                	lw	a5,4(s1)
    8000476a:	06f05163          	blez	a5,800047cc <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000476e:	37fd                	addiw	a5,a5,-1
    80004770:	0007871b          	sext.w	a4,a5
    80004774:	c0dc                	sw	a5,4(s1)
    80004776:	06e04363          	bgtz	a4,800047dc <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000477a:	0004a903          	lw	s2,0(s1)
    8000477e:	0094ca83          	lbu	s5,9(s1)
    80004782:	0104ba03          	ld	s4,16(s1)
    80004786:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000478a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000478e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004792:	0001c517          	auipc	a0,0x1c
    80004796:	64650513          	addi	a0,a0,1606 # 80020dd8 <ftable>
    8000479a:	ffffc097          	auipc	ra,0xffffc
    8000479e:	4f0080e7          	jalr	1264(ra) # 80000c8a <release>

  if(ff.type == FD_PIPE){
    800047a2:	4785                	li	a5,1
    800047a4:	04f90d63          	beq	s2,a5,800047fe <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800047a8:	3979                	addiw	s2,s2,-2
    800047aa:	4785                	li	a5,1
    800047ac:	0527e063          	bltu	a5,s2,800047ec <fileclose+0xa8>
    begin_op();
    800047b0:	00000097          	auipc	ra,0x0
    800047b4:	acc080e7          	jalr	-1332(ra) # 8000427c <begin_op>
    iput(ff.ip);
    800047b8:	854e                	mv	a0,s3
    800047ba:	fffff097          	auipc	ra,0xfffff
    800047be:	2b0080e7          	jalr	688(ra) # 80003a6a <iput>
    end_op();
    800047c2:	00000097          	auipc	ra,0x0
    800047c6:	b38080e7          	jalr	-1224(ra) # 800042fa <end_op>
    800047ca:	a00d                	j	800047ec <fileclose+0xa8>
    panic("fileclose");
    800047cc:	00004517          	auipc	a0,0x4
    800047d0:	fac50513          	addi	a0,a0,-84 # 80008778 <syscalls+0x328>
    800047d4:	ffffc097          	auipc	ra,0xffffc
    800047d8:	d6c080e7          	jalr	-660(ra) # 80000540 <panic>
    release(&ftable.lock);
    800047dc:	0001c517          	auipc	a0,0x1c
    800047e0:	5fc50513          	addi	a0,a0,1532 # 80020dd8 <ftable>
    800047e4:	ffffc097          	auipc	ra,0xffffc
    800047e8:	4a6080e7          	jalr	1190(ra) # 80000c8a <release>
  }
}
    800047ec:	70e2                	ld	ra,56(sp)
    800047ee:	7442                	ld	s0,48(sp)
    800047f0:	74a2                	ld	s1,40(sp)
    800047f2:	7902                	ld	s2,32(sp)
    800047f4:	69e2                	ld	s3,24(sp)
    800047f6:	6a42                	ld	s4,16(sp)
    800047f8:	6aa2                	ld	s5,8(sp)
    800047fa:	6121                	addi	sp,sp,64
    800047fc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800047fe:	85d6                	mv	a1,s5
    80004800:	8552                	mv	a0,s4
    80004802:	00000097          	auipc	ra,0x0
    80004806:	34c080e7          	jalr	844(ra) # 80004b4e <pipeclose>
    8000480a:	b7cd                	j	800047ec <fileclose+0xa8>

000000008000480c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000480c:	715d                	addi	sp,sp,-80
    8000480e:	e486                	sd	ra,72(sp)
    80004810:	e0a2                	sd	s0,64(sp)
    80004812:	fc26                	sd	s1,56(sp)
    80004814:	f84a                	sd	s2,48(sp)
    80004816:	f44e                	sd	s3,40(sp)
    80004818:	0880                	addi	s0,sp,80
    8000481a:	84aa                	mv	s1,a0
    8000481c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000481e:	ffffd097          	auipc	ra,0xffffd
    80004822:	18e080e7          	jalr	398(ra) # 800019ac <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004826:	409c                	lw	a5,0(s1)
    80004828:	37f9                	addiw	a5,a5,-2
    8000482a:	4705                	li	a4,1
    8000482c:	04f76763          	bltu	a4,a5,8000487a <filestat+0x6e>
    80004830:	892a                	mv	s2,a0
    ilock(f->ip);
    80004832:	6c88                	ld	a0,24(s1)
    80004834:	fffff097          	auipc	ra,0xfffff
    80004838:	07c080e7          	jalr	124(ra) # 800038b0 <ilock>
    stati(f->ip, &st);
    8000483c:	fb840593          	addi	a1,s0,-72
    80004840:	6c88                	ld	a0,24(s1)
    80004842:	fffff097          	auipc	ra,0xfffff
    80004846:	2f8080e7          	jalr	760(ra) # 80003b3a <stati>
    iunlock(f->ip);
    8000484a:	6c88                	ld	a0,24(s1)
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	126080e7          	jalr	294(ra) # 80003972 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004854:	46e1                	li	a3,24
    80004856:	fb840613          	addi	a2,s0,-72
    8000485a:	85ce                	mv	a1,s3
    8000485c:	05093503          	ld	a0,80(s2)
    80004860:	ffffd097          	auipc	ra,0xffffd
    80004864:	e0c080e7          	jalr	-500(ra) # 8000166c <copyout>
    80004868:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000486c:	60a6                	ld	ra,72(sp)
    8000486e:	6406                	ld	s0,64(sp)
    80004870:	74e2                	ld	s1,56(sp)
    80004872:	7942                	ld	s2,48(sp)
    80004874:	79a2                	ld	s3,40(sp)
    80004876:	6161                	addi	sp,sp,80
    80004878:	8082                	ret
  return -1;
    8000487a:	557d                	li	a0,-1
    8000487c:	bfc5                	j	8000486c <filestat+0x60>

000000008000487e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000487e:	7179                	addi	sp,sp,-48
    80004880:	f406                	sd	ra,40(sp)
    80004882:	f022                	sd	s0,32(sp)
    80004884:	ec26                	sd	s1,24(sp)
    80004886:	e84a                	sd	s2,16(sp)
    80004888:	e44e                	sd	s3,8(sp)
    8000488a:	1800                	addi	s0,sp,48

  int r = 0;

  if(f->readable == 0)
    8000488c:	00854783          	lbu	a5,8(a0)
    80004890:	c3d5                	beqz	a5,80004934 <fileread+0xb6>
    80004892:	84aa                	mv	s1,a0
    80004894:	89ae                	mv	s3,a1
    80004896:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004898:	411c                	lw	a5,0(a0)
    8000489a:	4705                	li	a4,1
    8000489c:	04e78963          	beq	a5,a4,800048ee <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800048a0:	470d                	li	a4,3
    800048a2:	04e78d63          	beq	a5,a4,800048fc <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800048a6:	4709                	li	a4,2
    800048a8:	06e79e63          	bne	a5,a4,80004924 <fileread+0xa6>
    ilock(f->ip);
    800048ac:	6d08                	ld	a0,24(a0)
    800048ae:	fffff097          	auipc	ra,0xfffff
    800048b2:	002080e7          	jalr	2(ra) # 800038b0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800048b6:	874a                	mv	a4,s2
    800048b8:	5094                	lw	a3,32(s1)
    800048ba:	864e                	mv	a2,s3
    800048bc:	4585                	li	a1,1
    800048be:	6c88                	ld	a0,24(s1)
    800048c0:	fffff097          	auipc	ra,0xfffff
    800048c4:	2a4080e7          	jalr	676(ra) # 80003b64 <readi>
    800048c8:	892a                	mv	s2,a0
    800048ca:	00a05563          	blez	a0,800048d4 <fileread+0x56>
      f->off += r;
    800048ce:	509c                	lw	a5,32(s1)
    800048d0:	9fa9                	addw	a5,a5,a0
    800048d2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800048d4:	6c88                	ld	a0,24(s1)
    800048d6:	fffff097          	auipc	ra,0xfffff
    800048da:	09c080e7          	jalr	156(ra) # 80003972 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800048de:	854a                	mv	a0,s2
    800048e0:	70a2                	ld	ra,40(sp)
    800048e2:	7402                	ld	s0,32(sp)
    800048e4:	64e2                	ld	s1,24(sp)
    800048e6:	6942                	ld	s2,16(sp)
    800048e8:	69a2                	ld	s3,8(sp)
    800048ea:	6145                	addi	sp,sp,48
    800048ec:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800048ee:	6908                	ld	a0,16(a0)
    800048f0:	00000097          	auipc	ra,0x0
    800048f4:	3c6080e7          	jalr	966(ra) # 80004cb6 <piperead>
    800048f8:	892a                	mv	s2,a0
    800048fa:	b7d5                	j	800048de <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800048fc:	02451783          	lh	a5,36(a0)
    80004900:	03079693          	slli	a3,a5,0x30
    80004904:	92c1                	srli	a3,a3,0x30
    80004906:	4725                	li	a4,9
    80004908:	02d76863          	bltu	a4,a3,80004938 <fileread+0xba>
    8000490c:	0792                	slli	a5,a5,0x4
    8000490e:	0001c717          	auipc	a4,0x1c
    80004912:	42a70713          	addi	a4,a4,1066 # 80020d38 <devsw>
    80004916:	97ba                	add	a5,a5,a4
    80004918:	639c                	ld	a5,0(a5)
    8000491a:	c38d                	beqz	a5,8000493c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000491c:	4505                	li	a0,1
    8000491e:	9782                	jalr	a5
    80004920:	892a                	mv	s2,a0
    80004922:	bf75                	j	800048de <fileread+0x60>
    panic("fileread");
    80004924:	00004517          	auipc	a0,0x4
    80004928:	e6450513          	addi	a0,a0,-412 # 80008788 <syscalls+0x338>
    8000492c:	ffffc097          	auipc	ra,0xffffc
    80004930:	c14080e7          	jalr	-1004(ra) # 80000540 <panic>
    return -1;
    80004934:	597d                	li	s2,-1
    80004936:	b765                	j	800048de <fileread+0x60>
      return -1;
    80004938:	597d                	li	s2,-1
    8000493a:	b755                	j	800048de <fileread+0x60>
    8000493c:	597d                	li	s2,-1
    8000493e:	b745                	j	800048de <fileread+0x60>

0000000080004940 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004940:	715d                	addi	sp,sp,-80
    80004942:	e486                	sd	ra,72(sp)
    80004944:	e0a2                	sd	s0,64(sp)
    80004946:	fc26                	sd	s1,56(sp)
    80004948:	f84a                	sd	s2,48(sp)
    8000494a:	f44e                	sd	s3,40(sp)
    8000494c:	f052                	sd	s4,32(sp)
    8000494e:	ec56                	sd	s5,24(sp)
    80004950:	e85a                	sd	s6,16(sp)
    80004952:	e45e                	sd	s7,8(sp)
    80004954:	e062                	sd	s8,0(sp)
    80004956:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004958:	00954783          	lbu	a5,9(a0)
    8000495c:	10078663          	beqz	a5,80004a68 <filewrite+0x128>
    80004960:	892a                	mv	s2,a0
    80004962:	8b2e                	mv	s6,a1
    80004964:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004966:	411c                	lw	a5,0(a0)
    80004968:	4705                	li	a4,1
    8000496a:	02e78263          	beq	a5,a4,8000498e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000496e:	470d                	li	a4,3
    80004970:	02e78663          	beq	a5,a4,8000499c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004974:	4709                	li	a4,2
    80004976:	0ee79163          	bne	a5,a4,80004a58 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000497a:	0ac05d63          	blez	a2,80004a34 <filewrite+0xf4>
    int i = 0;
    8000497e:	4981                	li	s3,0
    80004980:	6b85                	lui	s7,0x1
    80004982:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004986:	6c05                	lui	s8,0x1
    80004988:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000498c:	a861                	j	80004a24 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    8000498e:	6908                	ld	a0,16(a0)
    80004990:	00000097          	auipc	ra,0x0
    80004994:	22e080e7          	jalr	558(ra) # 80004bbe <pipewrite>
    80004998:	8a2a                	mv	s4,a0
    8000499a:	a045                	j	80004a3a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000499c:	02451783          	lh	a5,36(a0)
    800049a0:	03079693          	slli	a3,a5,0x30
    800049a4:	92c1                	srli	a3,a3,0x30
    800049a6:	4725                	li	a4,9
    800049a8:	0cd76263          	bltu	a4,a3,80004a6c <filewrite+0x12c>
    800049ac:	0792                	slli	a5,a5,0x4
    800049ae:	0001c717          	auipc	a4,0x1c
    800049b2:	38a70713          	addi	a4,a4,906 # 80020d38 <devsw>
    800049b6:	97ba                	add	a5,a5,a4
    800049b8:	679c                	ld	a5,8(a5)
    800049ba:	cbdd                	beqz	a5,80004a70 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    800049bc:	4505                	li	a0,1
    800049be:	9782                	jalr	a5
    800049c0:	8a2a                	mv	s4,a0
    800049c2:	a8a5                	j	80004a3a <filewrite+0xfa>
    800049c4:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800049c8:	00000097          	auipc	ra,0x0
    800049cc:	8b4080e7          	jalr	-1868(ra) # 8000427c <begin_op>
      ilock(f->ip);
    800049d0:	01893503          	ld	a0,24(s2)
    800049d4:	fffff097          	auipc	ra,0xfffff
    800049d8:	edc080e7          	jalr	-292(ra) # 800038b0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800049dc:	8756                	mv	a4,s5
    800049de:	02092683          	lw	a3,32(s2)
    800049e2:	01698633          	add	a2,s3,s6
    800049e6:	4585                	li	a1,1
    800049e8:	01893503          	ld	a0,24(s2)
    800049ec:	fffff097          	auipc	ra,0xfffff
    800049f0:	270080e7          	jalr	624(ra) # 80003c5c <writei>
    800049f4:	84aa                	mv	s1,a0
    800049f6:	00a05763          	blez	a0,80004a04 <filewrite+0xc4>
        f->off += r;
    800049fa:	02092783          	lw	a5,32(s2)
    800049fe:	9fa9                	addw	a5,a5,a0
    80004a00:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004a04:	01893503          	ld	a0,24(s2)
    80004a08:	fffff097          	auipc	ra,0xfffff
    80004a0c:	f6a080e7          	jalr	-150(ra) # 80003972 <iunlock>
      end_op();
    80004a10:	00000097          	auipc	ra,0x0
    80004a14:	8ea080e7          	jalr	-1814(ra) # 800042fa <end_op>

      if(r != n1){
    80004a18:	009a9f63          	bne	s5,s1,80004a36 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004a1c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004a20:	0149db63          	bge	s3,s4,80004a36 <filewrite+0xf6>
      int n1 = n - i;
    80004a24:	413a04bb          	subw	s1,s4,s3
    80004a28:	0004879b          	sext.w	a5,s1
    80004a2c:	f8fbdce3          	bge	s7,a5,800049c4 <filewrite+0x84>
    80004a30:	84e2                	mv	s1,s8
    80004a32:	bf49                	j	800049c4 <filewrite+0x84>
    int i = 0;
    80004a34:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004a36:	013a1f63          	bne	s4,s3,80004a54 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004a3a:	8552                	mv	a0,s4
    80004a3c:	60a6                	ld	ra,72(sp)
    80004a3e:	6406                	ld	s0,64(sp)
    80004a40:	74e2                	ld	s1,56(sp)
    80004a42:	7942                	ld	s2,48(sp)
    80004a44:	79a2                	ld	s3,40(sp)
    80004a46:	7a02                	ld	s4,32(sp)
    80004a48:	6ae2                	ld	s5,24(sp)
    80004a4a:	6b42                	ld	s6,16(sp)
    80004a4c:	6ba2                	ld	s7,8(sp)
    80004a4e:	6c02                	ld	s8,0(sp)
    80004a50:	6161                	addi	sp,sp,80
    80004a52:	8082                	ret
    ret = (i == n ? n : -1);
    80004a54:	5a7d                	li	s4,-1
    80004a56:	b7d5                	j	80004a3a <filewrite+0xfa>
    panic("filewrite");
    80004a58:	00004517          	auipc	a0,0x4
    80004a5c:	d4050513          	addi	a0,a0,-704 # 80008798 <syscalls+0x348>
    80004a60:	ffffc097          	auipc	ra,0xffffc
    80004a64:	ae0080e7          	jalr	-1312(ra) # 80000540 <panic>
    return -1;
    80004a68:	5a7d                	li	s4,-1
    80004a6a:	bfc1                	j	80004a3a <filewrite+0xfa>
      return -1;
    80004a6c:	5a7d                	li	s4,-1
    80004a6e:	b7f1                	j	80004a3a <filewrite+0xfa>
    80004a70:	5a7d                	li	s4,-1
    80004a72:	b7e1                	j	80004a3a <filewrite+0xfa>

0000000080004a74 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004a74:	7179                	addi	sp,sp,-48
    80004a76:	f406                	sd	ra,40(sp)
    80004a78:	f022                	sd	s0,32(sp)
    80004a7a:	ec26                	sd	s1,24(sp)
    80004a7c:	e84a                	sd	s2,16(sp)
    80004a7e:	e44e                	sd	s3,8(sp)
    80004a80:	e052                	sd	s4,0(sp)
    80004a82:	1800                	addi	s0,sp,48
    80004a84:	84aa                	mv	s1,a0
    80004a86:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004a88:	0005b023          	sd	zero,0(a1)
    80004a8c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004a90:	00000097          	auipc	ra,0x0
    80004a94:	bf8080e7          	jalr	-1032(ra) # 80004688 <filealloc>
    80004a98:	e088                	sd	a0,0(s1)
    80004a9a:	c551                	beqz	a0,80004b26 <pipealloc+0xb2>
    80004a9c:	00000097          	auipc	ra,0x0
    80004aa0:	bec080e7          	jalr	-1044(ra) # 80004688 <filealloc>
    80004aa4:	00aa3023          	sd	a0,0(s4)
    80004aa8:	c92d                	beqz	a0,80004b1a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004aaa:	ffffc097          	auipc	ra,0xffffc
    80004aae:	03c080e7          	jalr	60(ra) # 80000ae6 <kalloc>
    80004ab2:	892a                	mv	s2,a0
    80004ab4:	c125                	beqz	a0,80004b14 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004ab6:	4985                	li	s3,1
    80004ab8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004abc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004ac0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004ac4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004ac8:	00004597          	auipc	a1,0x4
    80004acc:	ce058593          	addi	a1,a1,-800 # 800087a8 <syscalls+0x358>
    80004ad0:	ffffc097          	auipc	ra,0xffffc
    80004ad4:	076080e7          	jalr	118(ra) # 80000b46 <initlock>
  (*f0)->type = FD_PIPE;
    80004ad8:	609c                	ld	a5,0(s1)
    80004ada:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004ade:	609c                	ld	a5,0(s1)
    80004ae0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004ae4:	609c                	ld	a5,0(s1)
    80004ae6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004aea:	609c                	ld	a5,0(s1)
    80004aec:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004af0:	000a3783          	ld	a5,0(s4)
    80004af4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004af8:	000a3783          	ld	a5,0(s4)
    80004afc:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004b00:	000a3783          	ld	a5,0(s4)
    80004b04:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004b08:	000a3783          	ld	a5,0(s4)
    80004b0c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004b10:	4501                	li	a0,0
    80004b12:	a025                	j	80004b3a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004b14:	6088                	ld	a0,0(s1)
    80004b16:	e501                	bnez	a0,80004b1e <pipealloc+0xaa>
    80004b18:	a039                	j	80004b26 <pipealloc+0xb2>
    80004b1a:	6088                	ld	a0,0(s1)
    80004b1c:	c51d                	beqz	a0,80004b4a <pipealloc+0xd6>
    fileclose(*f0);
    80004b1e:	00000097          	auipc	ra,0x0
    80004b22:	c26080e7          	jalr	-986(ra) # 80004744 <fileclose>
  if(*f1)
    80004b26:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004b2a:	557d                	li	a0,-1
  if(*f1)
    80004b2c:	c799                	beqz	a5,80004b3a <pipealloc+0xc6>
    fileclose(*f1);
    80004b2e:	853e                	mv	a0,a5
    80004b30:	00000097          	auipc	ra,0x0
    80004b34:	c14080e7          	jalr	-1004(ra) # 80004744 <fileclose>
  return -1;
    80004b38:	557d                	li	a0,-1
}
    80004b3a:	70a2                	ld	ra,40(sp)
    80004b3c:	7402                	ld	s0,32(sp)
    80004b3e:	64e2                	ld	s1,24(sp)
    80004b40:	6942                	ld	s2,16(sp)
    80004b42:	69a2                	ld	s3,8(sp)
    80004b44:	6a02                	ld	s4,0(sp)
    80004b46:	6145                	addi	sp,sp,48
    80004b48:	8082                	ret
  return -1;
    80004b4a:	557d                	li	a0,-1
    80004b4c:	b7fd                	j	80004b3a <pipealloc+0xc6>

0000000080004b4e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004b4e:	1101                	addi	sp,sp,-32
    80004b50:	ec06                	sd	ra,24(sp)
    80004b52:	e822                	sd	s0,16(sp)
    80004b54:	e426                	sd	s1,8(sp)
    80004b56:	e04a                	sd	s2,0(sp)
    80004b58:	1000                	addi	s0,sp,32
    80004b5a:	84aa                	mv	s1,a0
    80004b5c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004b5e:	ffffc097          	auipc	ra,0xffffc
    80004b62:	078080e7          	jalr	120(ra) # 80000bd6 <acquire>
  if(writable){
    80004b66:	02090d63          	beqz	s2,80004ba0 <pipeclose+0x52>
    pi->writeopen = 0;
    80004b6a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004b6e:	21848513          	addi	a0,s1,536
    80004b72:	ffffd097          	auipc	ra,0xffffd
    80004b76:	546080e7          	jalr	1350(ra) # 800020b8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004b7a:	2204b783          	ld	a5,544(s1)
    80004b7e:	eb95                	bnez	a5,80004bb2 <pipeclose+0x64>
    release(&pi->lock);
    80004b80:	8526                	mv	a0,s1
    80004b82:	ffffc097          	auipc	ra,0xffffc
    80004b86:	108080e7          	jalr	264(ra) # 80000c8a <release>
    kfree((char*)pi);
    80004b8a:	8526                	mv	a0,s1
    80004b8c:	ffffc097          	auipc	ra,0xffffc
    80004b90:	e5c080e7          	jalr	-420(ra) # 800009e8 <kfree>
  } else
    release(&pi->lock);
}
    80004b94:	60e2                	ld	ra,24(sp)
    80004b96:	6442                	ld	s0,16(sp)
    80004b98:	64a2                	ld	s1,8(sp)
    80004b9a:	6902                	ld	s2,0(sp)
    80004b9c:	6105                	addi	sp,sp,32
    80004b9e:	8082                	ret
    pi->readopen = 0;
    80004ba0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004ba4:	21c48513          	addi	a0,s1,540
    80004ba8:	ffffd097          	auipc	ra,0xffffd
    80004bac:	510080e7          	jalr	1296(ra) # 800020b8 <wakeup>
    80004bb0:	b7e9                	j	80004b7a <pipeclose+0x2c>
    release(&pi->lock);
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	ffffc097          	auipc	ra,0xffffc
    80004bb8:	0d6080e7          	jalr	214(ra) # 80000c8a <release>
}
    80004bbc:	bfe1                	j	80004b94 <pipeclose+0x46>

0000000080004bbe <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004bbe:	711d                	addi	sp,sp,-96
    80004bc0:	ec86                	sd	ra,88(sp)
    80004bc2:	e8a2                	sd	s0,80(sp)
    80004bc4:	e4a6                	sd	s1,72(sp)
    80004bc6:	e0ca                	sd	s2,64(sp)
    80004bc8:	fc4e                	sd	s3,56(sp)
    80004bca:	f852                	sd	s4,48(sp)
    80004bcc:	f456                	sd	s5,40(sp)
    80004bce:	f05a                	sd	s6,32(sp)
    80004bd0:	ec5e                	sd	s7,24(sp)
    80004bd2:	e862                	sd	s8,16(sp)
    80004bd4:	1080                	addi	s0,sp,96
    80004bd6:	84aa                	mv	s1,a0
    80004bd8:	8aae                	mv	s5,a1
    80004bda:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004bdc:	ffffd097          	auipc	ra,0xffffd
    80004be0:	dd0080e7          	jalr	-560(ra) # 800019ac <myproc>
    80004be4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004be6:	8526                	mv	a0,s1
    80004be8:	ffffc097          	auipc	ra,0xffffc
    80004bec:	fee080e7          	jalr	-18(ra) # 80000bd6 <acquire>
  while(i < n){
    80004bf0:	0b405663          	blez	s4,80004c9c <pipewrite+0xde>
  int i = 0;
    80004bf4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004bf6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004bf8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004bfc:	21c48b93          	addi	s7,s1,540
    80004c00:	a089                	j	80004c42 <pipewrite+0x84>
      release(&pi->lock);
    80004c02:	8526                	mv	a0,s1
    80004c04:	ffffc097          	auipc	ra,0xffffc
    80004c08:	086080e7          	jalr	134(ra) # 80000c8a <release>
      return -1;
    80004c0c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004c0e:	854a                	mv	a0,s2
    80004c10:	60e6                	ld	ra,88(sp)
    80004c12:	6446                	ld	s0,80(sp)
    80004c14:	64a6                	ld	s1,72(sp)
    80004c16:	6906                	ld	s2,64(sp)
    80004c18:	79e2                	ld	s3,56(sp)
    80004c1a:	7a42                	ld	s4,48(sp)
    80004c1c:	7aa2                	ld	s5,40(sp)
    80004c1e:	7b02                	ld	s6,32(sp)
    80004c20:	6be2                	ld	s7,24(sp)
    80004c22:	6c42                	ld	s8,16(sp)
    80004c24:	6125                	addi	sp,sp,96
    80004c26:	8082                	ret
      wakeup(&pi->nread);
    80004c28:	8562                	mv	a0,s8
    80004c2a:	ffffd097          	auipc	ra,0xffffd
    80004c2e:	48e080e7          	jalr	1166(ra) # 800020b8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004c32:	85a6                	mv	a1,s1
    80004c34:	855e                	mv	a0,s7
    80004c36:	ffffd097          	auipc	ra,0xffffd
    80004c3a:	41e080e7          	jalr	1054(ra) # 80002054 <sleep>
  while(i < n){
    80004c3e:	07495063          	bge	s2,s4,80004c9e <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004c42:	2204a783          	lw	a5,544(s1)
    80004c46:	dfd5                	beqz	a5,80004c02 <pipewrite+0x44>
    80004c48:	854e                	mv	a0,s3
    80004c4a:	ffffd097          	auipc	ra,0xffffd
    80004c4e:	6b2080e7          	jalr	1714(ra) # 800022fc <killed>
    80004c52:	f945                	bnez	a0,80004c02 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004c54:	2184a783          	lw	a5,536(s1)
    80004c58:	21c4a703          	lw	a4,540(s1)
    80004c5c:	2007879b          	addiw	a5,a5,512
    80004c60:	fcf704e3          	beq	a4,a5,80004c28 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c64:	4685                	li	a3,1
    80004c66:	01590633          	add	a2,s2,s5
    80004c6a:	faf40593          	addi	a1,s0,-81
    80004c6e:	0509b503          	ld	a0,80(s3)
    80004c72:	ffffd097          	auipc	ra,0xffffd
    80004c76:	a86080e7          	jalr	-1402(ra) # 800016f8 <copyin>
    80004c7a:	03650263          	beq	a0,s6,80004c9e <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004c7e:	21c4a783          	lw	a5,540(s1)
    80004c82:	0017871b          	addiw	a4,a5,1
    80004c86:	20e4ae23          	sw	a4,540(s1)
    80004c8a:	1ff7f793          	andi	a5,a5,511
    80004c8e:	97a6                	add	a5,a5,s1
    80004c90:	faf44703          	lbu	a4,-81(s0)
    80004c94:	00e78c23          	sb	a4,24(a5)
      i++;
    80004c98:	2905                	addiw	s2,s2,1
    80004c9a:	b755                	j	80004c3e <pipewrite+0x80>
  int i = 0;
    80004c9c:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004c9e:	21848513          	addi	a0,s1,536
    80004ca2:	ffffd097          	auipc	ra,0xffffd
    80004ca6:	416080e7          	jalr	1046(ra) # 800020b8 <wakeup>
  release(&pi->lock);
    80004caa:	8526                	mv	a0,s1
    80004cac:	ffffc097          	auipc	ra,0xffffc
    80004cb0:	fde080e7          	jalr	-34(ra) # 80000c8a <release>
  return i;
    80004cb4:	bfa9                	j	80004c0e <pipewrite+0x50>

0000000080004cb6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004cb6:	715d                	addi	sp,sp,-80
    80004cb8:	e486                	sd	ra,72(sp)
    80004cba:	e0a2                	sd	s0,64(sp)
    80004cbc:	fc26                	sd	s1,56(sp)
    80004cbe:	f84a                	sd	s2,48(sp)
    80004cc0:	f44e                	sd	s3,40(sp)
    80004cc2:	f052                	sd	s4,32(sp)
    80004cc4:	ec56                	sd	s5,24(sp)
    80004cc6:	e85a                	sd	s6,16(sp)
    80004cc8:	0880                	addi	s0,sp,80
    80004cca:	84aa                	mv	s1,a0
    80004ccc:	892e                	mv	s2,a1
    80004cce:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004cd0:	ffffd097          	auipc	ra,0xffffd
    80004cd4:	cdc080e7          	jalr	-804(ra) # 800019ac <myproc>
    80004cd8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004cda:	8526                	mv	a0,s1
    80004cdc:	ffffc097          	auipc	ra,0xffffc
    80004ce0:	efa080e7          	jalr	-262(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ce4:	2184a703          	lw	a4,536(s1)
    80004ce8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004cec:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004cf0:	02f71763          	bne	a4,a5,80004d1e <piperead+0x68>
    80004cf4:	2244a783          	lw	a5,548(s1)
    80004cf8:	c39d                	beqz	a5,80004d1e <piperead+0x68>
    if(killed(pr)){
    80004cfa:	8552                	mv	a0,s4
    80004cfc:	ffffd097          	auipc	ra,0xffffd
    80004d00:	600080e7          	jalr	1536(ra) # 800022fc <killed>
    80004d04:	e949                	bnez	a0,80004d96 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004d06:	85a6                	mv	a1,s1
    80004d08:	854e                	mv	a0,s3
    80004d0a:	ffffd097          	auipc	ra,0xffffd
    80004d0e:	34a080e7          	jalr	842(ra) # 80002054 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d12:	2184a703          	lw	a4,536(s1)
    80004d16:	21c4a783          	lw	a5,540(s1)
    80004d1a:	fcf70de3          	beq	a4,a5,80004cf4 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d1e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d20:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d22:	05505463          	blez	s5,80004d6a <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004d26:	2184a783          	lw	a5,536(s1)
    80004d2a:	21c4a703          	lw	a4,540(s1)
    80004d2e:	02f70e63          	beq	a4,a5,80004d6a <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004d32:	0017871b          	addiw	a4,a5,1
    80004d36:	20e4ac23          	sw	a4,536(s1)
    80004d3a:	1ff7f793          	andi	a5,a5,511
    80004d3e:	97a6                	add	a5,a5,s1
    80004d40:	0187c783          	lbu	a5,24(a5)
    80004d44:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d48:	4685                	li	a3,1
    80004d4a:	fbf40613          	addi	a2,s0,-65
    80004d4e:	85ca                	mv	a1,s2
    80004d50:	050a3503          	ld	a0,80(s4)
    80004d54:	ffffd097          	auipc	ra,0xffffd
    80004d58:	918080e7          	jalr	-1768(ra) # 8000166c <copyout>
    80004d5c:	01650763          	beq	a0,s6,80004d6a <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d60:	2985                	addiw	s3,s3,1
    80004d62:	0905                	addi	s2,s2,1
    80004d64:	fd3a91e3          	bne	s5,s3,80004d26 <piperead+0x70>
    80004d68:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004d6a:	21c48513          	addi	a0,s1,540
    80004d6e:	ffffd097          	auipc	ra,0xffffd
    80004d72:	34a080e7          	jalr	842(ra) # 800020b8 <wakeup>
  release(&pi->lock);
    80004d76:	8526                	mv	a0,s1
    80004d78:	ffffc097          	auipc	ra,0xffffc
    80004d7c:	f12080e7          	jalr	-238(ra) # 80000c8a <release>
  return i;
}
    80004d80:	854e                	mv	a0,s3
    80004d82:	60a6                	ld	ra,72(sp)
    80004d84:	6406                	ld	s0,64(sp)
    80004d86:	74e2                	ld	s1,56(sp)
    80004d88:	7942                	ld	s2,48(sp)
    80004d8a:	79a2                	ld	s3,40(sp)
    80004d8c:	7a02                	ld	s4,32(sp)
    80004d8e:	6ae2                	ld	s5,24(sp)
    80004d90:	6b42                	ld	s6,16(sp)
    80004d92:	6161                	addi	sp,sp,80
    80004d94:	8082                	ret
      release(&pi->lock);
    80004d96:	8526                	mv	a0,s1
    80004d98:	ffffc097          	auipc	ra,0xffffc
    80004d9c:	ef2080e7          	jalr	-270(ra) # 80000c8a <release>
      return -1;
    80004da0:	59fd                	li	s3,-1
    80004da2:	bff9                	j	80004d80 <piperead+0xca>

0000000080004da4 <read_pipe>:
Reading from the pipe

*/
int
read_pipe(struct pipe *pi, uint64 addr, int n)
{
    80004da4:	715d                	addi	sp,sp,-80
    80004da6:	e486                	sd	ra,72(sp)
    80004da8:	e0a2                	sd	s0,64(sp)
    80004daa:	fc26                	sd	s1,56(sp)
    80004dac:	f84a                	sd	s2,48(sp)
    80004dae:	f44e                	sd	s3,40(sp)
    80004db0:	f052                	sd	s4,32(sp)
    80004db2:	ec56                	sd	s5,24(sp)
    80004db4:	0880                	addi	s0,sp,80
    80004db6:	84aa                	mv	s1,a0
    80004db8:	8a2e                	mv	s4,a1
    80004dba:	89b2                	mv	s3,a2
  int i;
  struct proc *pr = myproc();
    80004dbc:	ffffd097          	auipc	ra,0xffffd
    80004dc0:	bf0080e7          	jalr	-1040(ra) # 800019ac <myproc>
    80004dc4:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    80004dc6:	8526                	mv	a0,s1
    80004dc8:	ffffc097          	auipc	ra,0xffffc
    80004dcc:	e0e080e7          	jalr	-498(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004dd0:	2184a703          	lw	a4,536(s1)
    80004dd4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004dd8:	21848a93          	addi	s5,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ddc:	02f71763          	bne	a4,a5,80004e0a <read_pipe+0x66>
    80004de0:	2244a783          	lw	a5,548(s1)
    80004de4:	c39d                	beqz	a5,80004e0a <read_pipe+0x66>
    if(killed(pr)){
    80004de6:	854a                	mv	a0,s2
    80004de8:	ffffd097          	auipc	ra,0xffffd
    80004dec:	514080e7          	jalr	1300(ra) # 800022fc <killed>
    80004df0:	e541                	bnez	a0,80004e78 <read_pipe+0xd4>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004df2:	85a6                	mv	a1,s1
    80004df4:	8556                	mv	a0,s5
    80004df6:	ffffd097          	auipc	ra,0xffffd
    80004dfa:	25e080e7          	jalr	606(ra) # 80002054 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004dfe:	2184a703          	lw	a4,536(s1)
    80004e02:	21c4a783          	lw	a5,540(s1)
    80004e06:	fcf70de3          	beq	a4,a5,80004de0 <read_pipe+0x3c>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e0a:	4901                	li	s2,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    memmove((char *)addr,(char*)&ch,n);
    80004e0c:	00098a9b          	sext.w	s5,s3
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e10:	03305f63          	blez	s3,80004e4e <read_pipe+0xaa>
    if(pi->nread == pi->nwrite)
    80004e14:	2184a783          	lw	a5,536(s1)
    80004e18:	21c4a703          	lw	a4,540(s1)
    80004e1c:	02f70963          	beq	a4,a5,80004e4e <read_pipe+0xaa>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004e20:	0017871b          	addiw	a4,a5,1
    80004e24:	20e4ac23          	sw	a4,536(s1)
    80004e28:	1ff7f793          	andi	a5,a5,511
    80004e2c:	97a6                	add	a5,a5,s1
    80004e2e:	0187c783          	lbu	a5,24(a5)
    80004e32:	faf40fa3          	sb	a5,-65(s0)
    memmove((char *)addr,(char*)&ch,n);
    80004e36:	8656                	mv	a2,s5
    80004e38:	fbf40593          	addi	a1,s0,-65
    80004e3c:	8552                	mv	a0,s4
    80004e3e:	ffffc097          	auipc	ra,0xffffc
    80004e42:	ef0080e7          	jalr	-272(ra) # 80000d2e <memmove>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e46:	2905                	addiw	s2,s2,1
    80004e48:	fd2996e3          	bne	s3,s2,80004e14 <read_pipe+0x70>
    80004e4c:	894e                	mv	s2,s3
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004e4e:	21c48513          	addi	a0,s1,540
    80004e52:	ffffd097          	auipc	ra,0xffffd
    80004e56:	266080e7          	jalr	614(ra) # 800020b8 <wakeup>
  release(&pi->lock);
    80004e5a:	8526                	mv	a0,s1
    80004e5c:	ffffc097          	auipc	ra,0xffffc
    80004e60:	e2e080e7          	jalr	-466(ra) # 80000c8a <release>
  return i;
}
    80004e64:	854a                	mv	a0,s2
    80004e66:	60a6                	ld	ra,72(sp)
    80004e68:	6406                	ld	s0,64(sp)
    80004e6a:	74e2                	ld	s1,56(sp)
    80004e6c:	7942                	ld	s2,48(sp)
    80004e6e:	79a2                	ld	s3,40(sp)
    80004e70:	7a02                	ld	s4,32(sp)
    80004e72:	6ae2                	ld	s5,24(sp)
    80004e74:	6161                	addi	sp,sp,80
    80004e76:	8082                	ret
      release(&pi->lock);
    80004e78:	8526                	mv	a0,s1
    80004e7a:	ffffc097          	auipc	ra,0xffffc
    80004e7e:	e10080e7          	jalr	-496(ra) # 80000c8a <release>
      return -1;
    80004e82:	597d                	li	s2,-1
    80004e84:	b7c5                	j	80004e64 <read_pipe+0xc0>

0000000080004e86 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004e86:	1141                	addi	sp,sp,-16
    80004e88:	e422                	sd	s0,8(sp)
    80004e8a:	0800                	addi	s0,sp,16
    80004e8c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004e8e:	8905                	andi	a0,a0,1
    80004e90:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004e92:	8b89                	andi	a5,a5,2
    80004e94:	c399                	beqz	a5,80004e9a <flags2perm+0x14>
      perm |= PTE_W;
    80004e96:	00456513          	ori	a0,a0,4
    return perm;
}
    80004e9a:	6422                	ld	s0,8(sp)
    80004e9c:	0141                	addi	sp,sp,16
    80004e9e:	8082                	ret

0000000080004ea0 <exec>:

int
exec(char *path, char **argv)
{
    80004ea0:	de010113          	addi	sp,sp,-544
    80004ea4:	20113c23          	sd	ra,536(sp)
    80004ea8:	20813823          	sd	s0,528(sp)
    80004eac:	20913423          	sd	s1,520(sp)
    80004eb0:	21213023          	sd	s2,512(sp)
    80004eb4:	ffce                	sd	s3,504(sp)
    80004eb6:	fbd2                	sd	s4,496(sp)
    80004eb8:	f7d6                	sd	s5,488(sp)
    80004eba:	f3da                	sd	s6,480(sp)
    80004ebc:	efde                	sd	s7,472(sp)
    80004ebe:	ebe2                	sd	s8,464(sp)
    80004ec0:	e7e6                	sd	s9,456(sp)
    80004ec2:	e3ea                	sd	s10,448(sp)
    80004ec4:	ff6e                	sd	s11,440(sp)
    80004ec6:	1400                	addi	s0,sp,544
    80004ec8:	892a                	mv	s2,a0
    80004eca:	dea43423          	sd	a0,-536(s0)
    80004ece:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004ed2:	ffffd097          	auipc	ra,0xffffd
    80004ed6:	ada080e7          	jalr	-1318(ra) # 800019ac <myproc>
    80004eda:	84aa                	mv	s1,a0

  begin_op();
    80004edc:	fffff097          	auipc	ra,0xfffff
    80004ee0:	3a0080e7          	jalr	928(ra) # 8000427c <begin_op>

  if((ip = namei(path)) == 0){
    80004ee4:	854a                	mv	a0,s2
    80004ee6:	fffff097          	auipc	ra,0xfffff
    80004eea:	176080e7          	jalr	374(ra) # 8000405c <namei>
    80004eee:	c93d                	beqz	a0,80004f64 <exec+0xc4>
    80004ef0:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004ef2:	fffff097          	auipc	ra,0xfffff
    80004ef6:	9be080e7          	jalr	-1602(ra) # 800038b0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004efa:	04000713          	li	a4,64
    80004efe:	4681                	li	a3,0
    80004f00:	e5040613          	addi	a2,s0,-432
    80004f04:	4581                	li	a1,0
    80004f06:	8556                	mv	a0,s5
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	c5c080e7          	jalr	-932(ra) # 80003b64 <readi>
    80004f10:	04000793          	li	a5,64
    80004f14:	00f51a63          	bne	a0,a5,80004f28 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004f18:	e5042703          	lw	a4,-432(s0)
    80004f1c:	464c47b7          	lui	a5,0x464c4
    80004f20:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004f24:	04f70663          	beq	a4,a5,80004f70 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004f28:	8556                	mv	a0,s5
    80004f2a:	fffff097          	auipc	ra,0xfffff
    80004f2e:	be8080e7          	jalr	-1048(ra) # 80003b12 <iunlockput>
    end_op();
    80004f32:	fffff097          	auipc	ra,0xfffff
    80004f36:	3c8080e7          	jalr	968(ra) # 800042fa <end_op>
  }
  return -1;
    80004f3a:	557d                	li	a0,-1
}
    80004f3c:	21813083          	ld	ra,536(sp)
    80004f40:	21013403          	ld	s0,528(sp)
    80004f44:	20813483          	ld	s1,520(sp)
    80004f48:	20013903          	ld	s2,512(sp)
    80004f4c:	79fe                	ld	s3,504(sp)
    80004f4e:	7a5e                	ld	s4,496(sp)
    80004f50:	7abe                	ld	s5,488(sp)
    80004f52:	7b1e                	ld	s6,480(sp)
    80004f54:	6bfe                	ld	s7,472(sp)
    80004f56:	6c5e                	ld	s8,464(sp)
    80004f58:	6cbe                	ld	s9,456(sp)
    80004f5a:	6d1e                	ld	s10,448(sp)
    80004f5c:	7dfa                	ld	s11,440(sp)
    80004f5e:	22010113          	addi	sp,sp,544
    80004f62:	8082                	ret
    end_op();
    80004f64:	fffff097          	auipc	ra,0xfffff
    80004f68:	396080e7          	jalr	918(ra) # 800042fa <end_op>
    return -1;
    80004f6c:	557d                	li	a0,-1
    80004f6e:	b7f9                	j	80004f3c <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004f70:	8526                	mv	a0,s1
    80004f72:	ffffd097          	auipc	ra,0xffffd
    80004f76:	afe080e7          	jalr	-1282(ra) # 80001a70 <proc_pagetable>
    80004f7a:	8b2a                	mv	s6,a0
    80004f7c:	d555                	beqz	a0,80004f28 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f7e:	e7042783          	lw	a5,-400(s0)
    80004f82:	e8845703          	lhu	a4,-376(s0)
    80004f86:	c735                	beqz	a4,80004ff2 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004f88:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f8a:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004f8e:	6a05                	lui	s4,0x1
    80004f90:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004f94:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004f98:	6d85                	lui	s11,0x1
    80004f9a:	7d7d                	lui	s10,0xfffff
    80004f9c:	ac3d                	j	800051da <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004f9e:	00004517          	auipc	a0,0x4
    80004fa2:	81250513          	addi	a0,a0,-2030 # 800087b0 <syscalls+0x360>
    80004fa6:	ffffb097          	auipc	ra,0xffffb
    80004faa:	59a080e7          	jalr	1434(ra) # 80000540 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004fae:	874a                	mv	a4,s2
    80004fb0:	009c86bb          	addw	a3,s9,s1
    80004fb4:	4581                	li	a1,0
    80004fb6:	8556                	mv	a0,s5
    80004fb8:	fffff097          	auipc	ra,0xfffff
    80004fbc:	bac080e7          	jalr	-1108(ra) # 80003b64 <readi>
    80004fc0:	2501                	sext.w	a0,a0
    80004fc2:	1aa91963          	bne	s2,a0,80005174 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    80004fc6:	009d84bb          	addw	s1,s11,s1
    80004fca:	013d09bb          	addw	s3,s10,s3
    80004fce:	1f74f663          	bgeu	s1,s7,800051ba <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80004fd2:	02049593          	slli	a1,s1,0x20
    80004fd6:	9181                	srli	a1,a1,0x20
    80004fd8:	95e2                	add	a1,a1,s8
    80004fda:	855a                	mv	a0,s6
    80004fdc:	ffffc097          	auipc	ra,0xffffc
    80004fe0:	080080e7          	jalr	128(ra) # 8000105c <walkaddr>
    80004fe4:	862a                	mv	a2,a0
    if(pa == 0)
    80004fe6:	dd45                	beqz	a0,80004f9e <exec+0xfe>
      n = PGSIZE;
    80004fe8:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004fea:	fd49f2e3          	bgeu	s3,s4,80004fae <exec+0x10e>
      n = sz - i;
    80004fee:	894e                	mv	s2,s3
    80004ff0:	bf7d                	j	80004fae <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004ff2:	4901                	li	s2,0
  iunlockput(ip);
    80004ff4:	8556                	mv	a0,s5
    80004ff6:	fffff097          	auipc	ra,0xfffff
    80004ffa:	b1c080e7          	jalr	-1252(ra) # 80003b12 <iunlockput>
  end_op();
    80004ffe:	fffff097          	auipc	ra,0xfffff
    80005002:	2fc080e7          	jalr	764(ra) # 800042fa <end_op>
  p = myproc();
    80005006:	ffffd097          	auipc	ra,0xffffd
    8000500a:	9a6080e7          	jalr	-1626(ra) # 800019ac <myproc>
    8000500e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80005010:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005014:	6785                	lui	a5,0x1
    80005016:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80005018:	97ca                	add	a5,a5,s2
    8000501a:	777d                	lui	a4,0xfffff
    8000501c:	8ff9                	and	a5,a5,a4
    8000501e:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005022:	4691                	li	a3,4
    80005024:	6609                	lui	a2,0x2
    80005026:	963e                	add	a2,a2,a5
    80005028:	85be                	mv	a1,a5
    8000502a:	855a                	mv	a0,s6
    8000502c:	ffffc097          	auipc	ra,0xffffc
    80005030:	3e4080e7          	jalr	996(ra) # 80001410 <uvmalloc>
    80005034:	8c2a                	mv	s8,a0
  ip = 0;
    80005036:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005038:	12050e63          	beqz	a0,80005174 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000503c:	75f9                	lui	a1,0xffffe
    8000503e:	95aa                	add	a1,a1,a0
    80005040:	855a                	mv	a0,s6
    80005042:	ffffc097          	auipc	ra,0xffffc
    80005046:	5f8080e7          	jalr	1528(ra) # 8000163a <uvmclear>
  stackbase = sp - PGSIZE;
    8000504a:	7afd                	lui	s5,0xfffff
    8000504c:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000504e:	df043783          	ld	a5,-528(s0)
    80005052:	6388                	ld	a0,0(a5)
    80005054:	c925                	beqz	a0,800050c4 <exec+0x224>
    80005056:	e9040993          	addi	s3,s0,-368
    8000505a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000505e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005060:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005062:	ffffc097          	auipc	ra,0xffffc
    80005066:	dec080e7          	jalr	-532(ra) # 80000e4e <strlen>
    8000506a:	0015079b          	addiw	a5,a0,1
    8000506e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005072:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005076:	13596663          	bltu	s2,s5,800051a2 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000507a:	df043d83          	ld	s11,-528(s0)
    8000507e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005082:	8552                	mv	a0,s4
    80005084:	ffffc097          	auipc	ra,0xffffc
    80005088:	dca080e7          	jalr	-566(ra) # 80000e4e <strlen>
    8000508c:	0015069b          	addiw	a3,a0,1
    80005090:	8652                	mv	a2,s4
    80005092:	85ca                	mv	a1,s2
    80005094:	855a                	mv	a0,s6
    80005096:	ffffc097          	auipc	ra,0xffffc
    8000509a:	5d6080e7          	jalr	1494(ra) # 8000166c <copyout>
    8000509e:	10054663          	bltz	a0,800051aa <exec+0x30a>
    ustack[argc] = sp;
    800050a2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800050a6:	0485                	addi	s1,s1,1
    800050a8:	008d8793          	addi	a5,s11,8
    800050ac:	def43823          	sd	a5,-528(s0)
    800050b0:	008db503          	ld	a0,8(s11)
    800050b4:	c911                	beqz	a0,800050c8 <exec+0x228>
    if(argc >= MAXARG)
    800050b6:	09a1                	addi	s3,s3,8
    800050b8:	fb3c95e3          	bne	s9,s3,80005062 <exec+0x1c2>
  sz = sz1;
    800050bc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800050c0:	4a81                	li	s5,0
    800050c2:	a84d                	j	80005174 <exec+0x2d4>
  sp = sz;
    800050c4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800050c6:	4481                	li	s1,0
  ustack[argc] = 0;
    800050c8:	00349793          	slli	a5,s1,0x3
    800050cc:	f9078793          	addi	a5,a5,-112
    800050d0:	97a2                	add	a5,a5,s0
    800050d2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800050d6:	00148693          	addi	a3,s1,1
    800050da:	068e                	slli	a3,a3,0x3
    800050dc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800050e0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800050e4:	01597663          	bgeu	s2,s5,800050f0 <exec+0x250>
  sz = sz1;
    800050e8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800050ec:	4a81                	li	s5,0
    800050ee:	a059                	j	80005174 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800050f0:	e9040613          	addi	a2,s0,-368
    800050f4:	85ca                	mv	a1,s2
    800050f6:	855a                	mv	a0,s6
    800050f8:	ffffc097          	auipc	ra,0xffffc
    800050fc:	574080e7          	jalr	1396(ra) # 8000166c <copyout>
    80005100:	0a054963          	bltz	a0,800051b2 <exec+0x312>
  p->trapframe->a1 = sp;
    80005104:	058bb783          	ld	a5,88(s7)
    80005108:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000510c:	de843783          	ld	a5,-536(s0)
    80005110:	0007c703          	lbu	a4,0(a5)
    80005114:	cf11                	beqz	a4,80005130 <exec+0x290>
    80005116:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005118:	02f00693          	li	a3,47
    8000511c:	a039                	j	8000512a <exec+0x28a>
      last = s+1;
    8000511e:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005122:	0785                	addi	a5,a5,1
    80005124:	fff7c703          	lbu	a4,-1(a5)
    80005128:	c701                	beqz	a4,80005130 <exec+0x290>
    if(*s == '/')
    8000512a:	fed71ce3          	bne	a4,a3,80005122 <exec+0x282>
    8000512e:	bfc5                	j	8000511e <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80005130:	4641                	li	a2,16
    80005132:	de843583          	ld	a1,-536(s0)
    80005136:	158b8513          	addi	a0,s7,344
    8000513a:	ffffc097          	auipc	ra,0xffffc
    8000513e:	ce2080e7          	jalr	-798(ra) # 80000e1c <safestrcpy>
  oldpagetable = p->pagetable;
    80005142:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80005146:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000514a:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000514e:	058bb783          	ld	a5,88(s7)
    80005152:	e6843703          	ld	a4,-408(s0)
    80005156:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005158:	058bb783          	ld	a5,88(s7)
    8000515c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005160:	85ea                	mv	a1,s10
    80005162:	ffffd097          	auipc	ra,0xffffd
    80005166:	9aa080e7          	jalr	-1622(ra) # 80001b0c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000516a:	0004851b          	sext.w	a0,s1
    8000516e:	b3f9                	j	80004f3c <exec+0x9c>
    80005170:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005174:	df843583          	ld	a1,-520(s0)
    80005178:	855a                	mv	a0,s6
    8000517a:	ffffd097          	auipc	ra,0xffffd
    8000517e:	992080e7          	jalr	-1646(ra) # 80001b0c <proc_freepagetable>
  if(ip){
    80005182:	da0a93e3          	bnez	s5,80004f28 <exec+0x88>
  return -1;
    80005186:	557d                	li	a0,-1
    80005188:	bb55                	j	80004f3c <exec+0x9c>
    8000518a:	df243c23          	sd	s2,-520(s0)
    8000518e:	b7dd                	j	80005174 <exec+0x2d4>
    80005190:	df243c23          	sd	s2,-520(s0)
    80005194:	b7c5                	j	80005174 <exec+0x2d4>
    80005196:	df243c23          	sd	s2,-520(s0)
    8000519a:	bfe9                	j	80005174 <exec+0x2d4>
    8000519c:	df243c23          	sd	s2,-520(s0)
    800051a0:	bfd1                	j	80005174 <exec+0x2d4>
  sz = sz1;
    800051a2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800051a6:	4a81                	li	s5,0
    800051a8:	b7f1                	j	80005174 <exec+0x2d4>
  sz = sz1;
    800051aa:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800051ae:	4a81                	li	s5,0
    800051b0:	b7d1                	j	80005174 <exec+0x2d4>
  sz = sz1;
    800051b2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800051b6:	4a81                	li	s5,0
    800051b8:	bf75                	j	80005174 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800051ba:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800051be:	e0843783          	ld	a5,-504(s0)
    800051c2:	0017869b          	addiw	a3,a5,1
    800051c6:	e0d43423          	sd	a3,-504(s0)
    800051ca:	e0043783          	ld	a5,-512(s0)
    800051ce:	0387879b          	addiw	a5,a5,56
    800051d2:	e8845703          	lhu	a4,-376(s0)
    800051d6:	e0e6dfe3          	bge	a3,a4,80004ff4 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800051da:	2781                	sext.w	a5,a5
    800051dc:	e0f43023          	sd	a5,-512(s0)
    800051e0:	03800713          	li	a4,56
    800051e4:	86be                	mv	a3,a5
    800051e6:	e1840613          	addi	a2,s0,-488
    800051ea:	4581                	li	a1,0
    800051ec:	8556                	mv	a0,s5
    800051ee:	fffff097          	auipc	ra,0xfffff
    800051f2:	976080e7          	jalr	-1674(ra) # 80003b64 <readi>
    800051f6:	03800793          	li	a5,56
    800051fa:	f6f51be3          	bne	a0,a5,80005170 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    800051fe:	e1842783          	lw	a5,-488(s0)
    80005202:	4705                	li	a4,1
    80005204:	fae79de3          	bne	a5,a4,800051be <exec+0x31e>
    if(ph.memsz < ph.filesz)
    80005208:	e4043483          	ld	s1,-448(s0)
    8000520c:	e3843783          	ld	a5,-456(s0)
    80005210:	f6f4ede3          	bltu	s1,a5,8000518a <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005214:	e2843783          	ld	a5,-472(s0)
    80005218:	94be                	add	s1,s1,a5
    8000521a:	f6f4ebe3          	bltu	s1,a5,80005190 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    8000521e:	de043703          	ld	a4,-544(s0)
    80005222:	8ff9                	and	a5,a5,a4
    80005224:	fbad                	bnez	a5,80005196 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005226:	e1c42503          	lw	a0,-484(s0)
    8000522a:	00000097          	auipc	ra,0x0
    8000522e:	c5c080e7          	jalr	-932(ra) # 80004e86 <flags2perm>
    80005232:	86aa                	mv	a3,a0
    80005234:	8626                	mv	a2,s1
    80005236:	85ca                	mv	a1,s2
    80005238:	855a                	mv	a0,s6
    8000523a:	ffffc097          	auipc	ra,0xffffc
    8000523e:	1d6080e7          	jalr	470(ra) # 80001410 <uvmalloc>
    80005242:	dea43c23          	sd	a0,-520(s0)
    80005246:	d939                	beqz	a0,8000519c <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005248:	e2843c03          	ld	s8,-472(s0)
    8000524c:	e2042c83          	lw	s9,-480(s0)
    80005250:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005254:	f60b83e3          	beqz	s7,800051ba <exec+0x31a>
    80005258:	89de                	mv	s3,s7
    8000525a:	4481                	li	s1,0
    8000525c:	bb9d                	j	80004fd2 <exec+0x132>

000000008000525e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000525e:	7179                	addi	sp,sp,-48
    80005260:	f406                	sd	ra,40(sp)
    80005262:	f022                	sd	s0,32(sp)
    80005264:	ec26                	sd	s1,24(sp)
    80005266:	e84a                	sd	s2,16(sp)
    80005268:	1800                	addi	s0,sp,48
    8000526a:	892e                	mv	s2,a1
    8000526c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000526e:	fdc40593          	addi	a1,s0,-36
    80005272:	ffffe097          	auipc	ra,0xffffe
    80005276:	850080e7          	jalr	-1968(ra) # 80002ac2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000527a:	fdc42703          	lw	a4,-36(s0)
    8000527e:	47bd                	li	a5,15
    80005280:	02e7eb63          	bltu	a5,a4,800052b6 <argfd+0x58>
    80005284:	ffffc097          	auipc	ra,0xffffc
    80005288:	728080e7          	jalr	1832(ra) # 800019ac <myproc>
    8000528c:	fdc42703          	lw	a4,-36(s0)
    80005290:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd14a>
    80005294:	078e                	slli	a5,a5,0x3
    80005296:	953e                	add	a0,a0,a5
    80005298:	611c                	ld	a5,0(a0)
    8000529a:	c385                	beqz	a5,800052ba <argfd+0x5c>
    return -1;
  if(pfd)
    8000529c:	00090463          	beqz	s2,800052a4 <argfd+0x46>
    *pfd = fd;
    800052a0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800052a4:	4501                	li	a0,0
  if(pf)
    800052a6:	c091                	beqz	s1,800052aa <argfd+0x4c>
    *pf = f;
    800052a8:	e09c                	sd	a5,0(s1)
}
    800052aa:	70a2                	ld	ra,40(sp)
    800052ac:	7402                	ld	s0,32(sp)
    800052ae:	64e2                	ld	s1,24(sp)
    800052b0:	6942                	ld	s2,16(sp)
    800052b2:	6145                	addi	sp,sp,48
    800052b4:	8082                	ret
    return -1;
    800052b6:	557d                	li	a0,-1
    800052b8:	bfcd                	j	800052aa <argfd+0x4c>
    800052ba:	557d                	li	a0,-1
    800052bc:	b7fd                	j	800052aa <argfd+0x4c>

00000000800052be <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800052be:	1101                	addi	sp,sp,-32
    800052c0:	ec06                	sd	ra,24(sp)
    800052c2:	e822                	sd	s0,16(sp)
    800052c4:	e426                	sd	s1,8(sp)
    800052c6:	1000                	addi	s0,sp,32
    800052c8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800052ca:	ffffc097          	auipc	ra,0xffffc
    800052ce:	6e2080e7          	jalr	1762(ra) # 800019ac <myproc>
    800052d2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800052d4:	0d050793          	addi	a5,a0,208
    800052d8:	4501                	li	a0,0
    800052da:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800052dc:	6398                	ld	a4,0(a5)
    800052de:	cb19                	beqz	a4,800052f4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800052e0:	2505                	addiw	a0,a0,1
    800052e2:	07a1                	addi	a5,a5,8
    800052e4:	fed51ce3          	bne	a0,a3,800052dc <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800052e8:	557d                	li	a0,-1
}
    800052ea:	60e2                	ld	ra,24(sp)
    800052ec:	6442                	ld	s0,16(sp)
    800052ee:	64a2                	ld	s1,8(sp)
    800052f0:	6105                	addi	sp,sp,32
    800052f2:	8082                	ret
      p->ofile[fd] = f;
    800052f4:	01a50793          	addi	a5,a0,26
    800052f8:	078e                	slli	a5,a5,0x3
    800052fa:	963e                	add	a2,a2,a5
    800052fc:	e204                	sd	s1,0(a2)
      return fd;
    800052fe:	b7f5                	j	800052ea <fdalloc+0x2c>

0000000080005300 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005300:	715d                	addi	sp,sp,-80
    80005302:	e486                	sd	ra,72(sp)
    80005304:	e0a2                	sd	s0,64(sp)
    80005306:	fc26                	sd	s1,56(sp)
    80005308:	f84a                	sd	s2,48(sp)
    8000530a:	f44e                	sd	s3,40(sp)
    8000530c:	f052                	sd	s4,32(sp)
    8000530e:	ec56                	sd	s5,24(sp)
    80005310:	e85a                	sd	s6,16(sp)
    80005312:	0880                	addi	s0,sp,80
    80005314:	8b2e                	mv	s6,a1
    80005316:	89b2                	mv	s3,a2
    80005318:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000531a:	fb040593          	addi	a1,s0,-80
    8000531e:	fffff097          	auipc	ra,0xfffff
    80005322:	d5c080e7          	jalr	-676(ra) # 8000407a <nameiparent>
    80005326:	84aa                	mv	s1,a0
    80005328:	14050f63          	beqz	a0,80005486 <create+0x186>
    return 0;

  ilock(dp);
    8000532c:	ffffe097          	auipc	ra,0xffffe
    80005330:	584080e7          	jalr	1412(ra) # 800038b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005334:	4601                	li	a2,0
    80005336:	fb040593          	addi	a1,s0,-80
    8000533a:	8526                	mv	a0,s1
    8000533c:	fffff097          	auipc	ra,0xfffff
    80005340:	a58080e7          	jalr	-1448(ra) # 80003d94 <dirlookup>
    80005344:	8aaa                	mv	s5,a0
    80005346:	c931                	beqz	a0,8000539a <create+0x9a>
    iunlockput(dp);
    80005348:	8526                	mv	a0,s1
    8000534a:	ffffe097          	auipc	ra,0xffffe
    8000534e:	7c8080e7          	jalr	1992(ra) # 80003b12 <iunlockput>
    ilock(ip);
    80005352:	8556                	mv	a0,s5
    80005354:	ffffe097          	auipc	ra,0xffffe
    80005358:	55c080e7          	jalr	1372(ra) # 800038b0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000535c:	000b059b          	sext.w	a1,s6
    80005360:	4789                	li	a5,2
    80005362:	02f59563          	bne	a1,a5,8000538c <create+0x8c>
    80005366:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd174>
    8000536a:	37f9                	addiw	a5,a5,-2
    8000536c:	17c2                	slli	a5,a5,0x30
    8000536e:	93c1                	srli	a5,a5,0x30
    80005370:	4705                	li	a4,1
    80005372:	00f76d63          	bltu	a4,a5,8000538c <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005376:	8556                	mv	a0,s5
    80005378:	60a6                	ld	ra,72(sp)
    8000537a:	6406                	ld	s0,64(sp)
    8000537c:	74e2                	ld	s1,56(sp)
    8000537e:	7942                	ld	s2,48(sp)
    80005380:	79a2                	ld	s3,40(sp)
    80005382:	7a02                	ld	s4,32(sp)
    80005384:	6ae2                	ld	s5,24(sp)
    80005386:	6b42                	ld	s6,16(sp)
    80005388:	6161                	addi	sp,sp,80
    8000538a:	8082                	ret
    iunlockput(ip);
    8000538c:	8556                	mv	a0,s5
    8000538e:	ffffe097          	auipc	ra,0xffffe
    80005392:	784080e7          	jalr	1924(ra) # 80003b12 <iunlockput>
    return 0;
    80005396:	4a81                	li	s5,0
    80005398:	bff9                	j	80005376 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000539a:	85da                	mv	a1,s6
    8000539c:	4088                	lw	a0,0(s1)
    8000539e:	ffffe097          	auipc	ra,0xffffe
    800053a2:	374080e7          	jalr	884(ra) # 80003712 <ialloc>
    800053a6:	8a2a                	mv	s4,a0
    800053a8:	c539                	beqz	a0,800053f6 <create+0xf6>
  ilock(ip);
    800053aa:	ffffe097          	auipc	ra,0xffffe
    800053ae:	506080e7          	jalr	1286(ra) # 800038b0 <ilock>
  ip->major = major;
    800053b2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800053b6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800053ba:	4905                	li	s2,1
    800053bc:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800053c0:	8552                	mv	a0,s4
    800053c2:	ffffe097          	auipc	ra,0xffffe
    800053c6:	422080e7          	jalr	1058(ra) # 800037e4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800053ca:	000b059b          	sext.w	a1,s6
    800053ce:	03258b63          	beq	a1,s2,80005404 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800053d2:	004a2603          	lw	a2,4(s4)
    800053d6:	fb040593          	addi	a1,s0,-80
    800053da:	8526                	mv	a0,s1
    800053dc:	fffff097          	auipc	ra,0xfffff
    800053e0:	bce080e7          	jalr	-1074(ra) # 80003faa <dirlink>
    800053e4:	06054f63          	bltz	a0,80005462 <create+0x162>
  iunlockput(dp);
    800053e8:	8526                	mv	a0,s1
    800053ea:	ffffe097          	auipc	ra,0xffffe
    800053ee:	728080e7          	jalr	1832(ra) # 80003b12 <iunlockput>
  return ip;
    800053f2:	8ad2                	mv	s5,s4
    800053f4:	b749                	j	80005376 <create+0x76>
    iunlockput(dp);
    800053f6:	8526                	mv	a0,s1
    800053f8:	ffffe097          	auipc	ra,0xffffe
    800053fc:	71a080e7          	jalr	1818(ra) # 80003b12 <iunlockput>
    return 0;
    80005400:	8ad2                	mv	s5,s4
    80005402:	bf95                	j	80005376 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005404:	004a2603          	lw	a2,4(s4)
    80005408:	00003597          	auipc	a1,0x3
    8000540c:	3c858593          	addi	a1,a1,968 # 800087d0 <syscalls+0x380>
    80005410:	8552                	mv	a0,s4
    80005412:	fffff097          	auipc	ra,0xfffff
    80005416:	b98080e7          	jalr	-1128(ra) # 80003faa <dirlink>
    8000541a:	04054463          	bltz	a0,80005462 <create+0x162>
    8000541e:	40d0                	lw	a2,4(s1)
    80005420:	00003597          	auipc	a1,0x3
    80005424:	3b858593          	addi	a1,a1,952 # 800087d8 <syscalls+0x388>
    80005428:	8552                	mv	a0,s4
    8000542a:	fffff097          	auipc	ra,0xfffff
    8000542e:	b80080e7          	jalr	-1152(ra) # 80003faa <dirlink>
    80005432:	02054863          	bltz	a0,80005462 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80005436:	004a2603          	lw	a2,4(s4)
    8000543a:	fb040593          	addi	a1,s0,-80
    8000543e:	8526                	mv	a0,s1
    80005440:	fffff097          	auipc	ra,0xfffff
    80005444:	b6a080e7          	jalr	-1174(ra) # 80003faa <dirlink>
    80005448:	00054d63          	bltz	a0,80005462 <create+0x162>
    dp->nlink++;  // for ".."
    8000544c:	04a4d783          	lhu	a5,74(s1)
    80005450:	2785                	addiw	a5,a5,1
    80005452:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005456:	8526                	mv	a0,s1
    80005458:	ffffe097          	auipc	ra,0xffffe
    8000545c:	38c080e7          	jalr	908(ra) # 800037e4 <iupdate>
    80005460:	b761                	j	800053e8 <create+0xe8>
  ip->nlink = 0;
    80005462:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005466:	8552                	mv	a0,s4
    80005468:	ffffe097          	auipc	ra,0xffffe
    8000546c:	37c080e7          	jalr	892(ra) # 800037e4 <iupdate>
  iunlockput(ip);
    80005470:	8552                	mv	a0,s4
    80005472:	ffffe097          	auipc	ra,0xffffe
    80005476:	6a0080e7          	jalr	1696(ra) # 80003b12 <iunlockput>
  iunlockput(dp);
    8000547a:	8526                	mv	a0,s1
    8000547c:	ffffe097          	auipc	ra,0xffffe
    80005480:	696080e7          	jalr	1686(ra) # 80003b12 <iunlockput>
  return 0;
    80005484:	bdcd                	j	80005376 <create+0x76>
    return 0;
    80005486:	8aaa                	mv	s5,a0
    80005488:	b5fd                	j	80005376 <create+0x76>

000000008000548a <sys_dup>:
{
    8000548a:	7179                	addi	sp,sp,-48
    8000548c:	f406                	sd	ra,40(sp)
    8000548e:	f022                	sd	s0,32(sp)
    80005490:	ec26                	sd	s1,24(sp)
    80005492:	e84a                	sd	s2,16(sp)
    80005494:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005496:	fd840613          	addi	a2,s0,-40
    8000549a:	4581                	li	a1,0
    8000549c:	4501                	li	a0,0
    8000549e:	00000097          	auipc	ra,0x0
    800054a2:	dc0080e7          	jalr	-576(ra) # 8000525e <argfd>
    return -1;
    800054a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800054a8:	02054363          	bltz	a0,800054ce <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800054ac:	fd843903          	ld	s2,-40(s0)
    800054b0:	854a                	mv	a0,s2
    800054b2:	00000097          	auipc	ra,0x0
    800054b6:	e0c080e7          	jalr	-500(ra) # 800052be <fdalloc>
    800054ba:	84aa                	mv	s1,a0
    return -1;
    800054bc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800054be:	00054863          	bltz	a0,800054ce <sys_dup+0x44>
  filedup(f);
    800054c2:	854a                	mv	a0,s2
    800054c4:	fffff097          	auipc	ra,0xfffff
    800054c8:	22e080e7          	jalr	558(ra) # 800046f2 <filedup>
  return fd;
    800054cc:	87a6                	mv	a5,s1
}
    800054ce:	853e                	mv	a0,a5
    800054d0:	70a2                	ld	ra,40(sp)
    800054d2:	7402                	ld	s0,32(sp)
    800054d4:	64e2                	ld	s1,24(sp)
    800054d6:	6942                	ld	s2,16(sp)
    800054d8:	6145                	addi	sp,sp,48
    800054da:	8082                	ret

00000000800054dc <sys_read>:
{
    800054dc:	7179                	addi	sp,sp,-48
    800054de:	f406                	sd	ra,40(sp)
    800054e0:	f022                	sd	s0,32(sp)
    800054e2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800054e4:	fd840593          	addi	a1,s0,-40
    800054e8:	4505                	li	a0,1
    800054ea:	ffffd097          	auipc	ra,0xffffd
    800054ee:	5f8080e7          	jalr	1528(ra) # 80002ae2 <argaddr>
  argint(2, &n);
    800054f2:	fe440593          	addi	a1,s0,-28
    800054f6:	4509                	li	a0,2
    800054f8:	ffffd097          	auipc	ra,0xffffd
    800054fc:	5ca080e7          	jalr	1482(ra) # 80002ac2 <argint>
  if(argfd(0, 0, &f) < 0)
    80005500:	fe840613          	addi	a2,s0,-24
    80005504:	4581                	li	a1,0
    80005506:	4501                	li	a0,0
    80005508:	00000097          	auipc	ra,0x0
    8000550c:	d56080e7          	jalr	-682(ra) # 8000525e <argfd>
    80005510:	87aa                	mv	a5,a0
    return -1;
    80005512:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005514:	0007cc63          	bltz	a5,8000552c <sys_read+0x50>
  return fileread(f, p, n);
    80005518:	fe442603          	lw	a2,-28(s0)
    8000551c:	fd843583          	ld	a1,-40(s0)
    80005520:	fe843503          	ld	a0,-24(s0)
    80005524:	fffff097          	auipc	ra,0xfffff
    80005528:	35a080e7          	jalr	858(ra) # 8000487e <fileread>
}
    8000552c:	70a2                	ld	ra,40(sp)
    8000552e:	7402                	ld	s0,32(sp)
    80005530:	6145                	addi	sp,sp,48
    80005532:	8082                	ret

0000000080005534 <sys_write>:
{
    80005534:	7179                	addi	sp,sp,-48
    80005536:	f406                	sd	ra,40(sp)
    80005538:	f022                	sd	s0,32(sp)
    8000553a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000553c:	fd840593          	addi	a1,s0,-40
    80005540:	4505                	li	a0,1
    80005542:	ffffd097          	auipc	ra,0xffffd
    80005546:	5a0080e7          	jalr	1440(ra) # 80002ae2 <argaddr>
  argint(2, &n);
    8000554a:	fe440593          	addi	a1,s0,-28
    8000554e:	4509                	li	a0,2
    80005550:	ffffd097          	auipc	ra,0xffffd
    80005554:	572080e7          	jalr	1394(ra) # 80002ac2 <argint>
  if(argfd(0, 0, &f) < 0)
    80005558:	fe840613          	addi	a2,s0,-24
    8000555c:	4581                	li	a1,0
    8000555e:	4501                	li	a0,0
    80005560:	00000097          	auipc	ra,0x0
    80005564:	cfe080e7          	jalr	-770(ra) # 8000525e <argfd>
    80005568:	87aa                	mv	a5,a0
    return -1;
    8000556a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000556c:	0007cc63          	bltz	a5,80005584 <sys_write+0x50>
  return filewrite(f, p, n);
    80005570:	fe442603          	lw	a2,-28(s0)
    80005574:	fd843583          	ld	a1,-40(s0)
    80005578:	fe843503          	ld	a0,-24(s0)
    8000557c:	fffff097          	auipc	ra,0xfffff
    80005580:	3c4080e7          	jalr	964(ra) # 80004940 <filewrite>
}
    80005584:	70a2                	ld	ra,40(sp)
    80005586:	7402                	ld	s0,32(sp)
    80005588:	6145                	addi	sp,sp,48
    8000558a:	8082                	ret

000000008000558c <sys_close>:
{
    8000558c:	1101                	addi	sp,sp,-32
    8000558e:	ec06                	sd	ra,24(sp)
    80005590:	e822                	sd	s0,16(sp)
    80005592:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005594:	fe040613          	addi	a2,s0,-32
    80005598:	fec40593          	addi	a1,s0,-20
    8000559c:	4501                	li	a0,0
    8000559e:	00000097          	auipc	ra,0x0
    800055a2:	cc0080e7          	jalr	-832(ra) # 8000525e <argfd>
    return -1;
    800055a6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800055a8:	02054463          	bltz	a0,800055d0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800055ac:	ffffc097          	auipc	ra,0xffffc
    800055b0:	400080e7          	jalr	1024(ra) # 800019ac <myproc>
    800055b4:	fec42783          	lw	a5,-20(s0)
    800055b8:	07e9                	addi	a5,a5,26
    800055ba:	078e                	slli	a5,a5,0x3
    800055bc:	953e                	add	a0,a0,a5
    800055be:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800055c2:	fe043503          	ld	a0,-32(s0)
    800055c6:	fffff097          	auipc	ra,0xfffff
    800055ca:	17e080e7          	jalr	382(ra) # 80004744 <fileclose>
  return 0;
    800055ce:	4781                	li	a5,0
}
    800055d0:	853e                	mv	a0,a5
    800055d2:	60e2                	ld	ra,24(sp)
    800055d4:	6442                	ld	s0,16(sp)
    800055d6:	6105                	addi	sp,sp,32
    800055d8:	8082                	ret

00000000800055da <sys_fstat>:
{
    800055da:	1101                	addi	sp,sp,-32
    800055dc:	ec06                	sd	ra,24(sp)
    800055de:	e822                	sd	s0,16(sp)
    800055e0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800055e2:	fe040593          	addi	a1,s0,-32
    800055e6:	4505                	li	a0,1
    800055e8:	ffffd097          	auipc	ra,0xffffd
    800055ec:	4fa080e7          	jalr	1274(ra) # 80002ae2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800055f0:	fe840613          	addi	a2,s0,-24
    800055f4:	4581                	li	a1,0
    800055f6:	4501                	li	a0,0
    800055f8:	00000097          	auipc	ra,0x0
    800055fc:	c66080e7          	jalr	-922(ra) # 8000525e <argfd>
    80005600:	87aa                	mv	a5,a0
    return -1;
    80005602:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005604:	0007ca63          	bltz	a5,80005618 <sys_fstat+0x3e>
  return filestat(f, st);
    80005608:	fe043583          	ld	a1,-32(s0)
    8000560c:	fe843503          	ld	a0,-24(s0)
    80005610:	fffff097          	auipc	ra,0xfffff
    80005614:	1fc080e7          	jalr	508(ra) # 8000480c <filestat>
}
    80005618:	60e2                	ld	ra,24(sp)
    8000561a:	6442                	ld	s0,16(sp)
    8000561c:	6105                	addi	sp,sp,32
    8000561e:	8082                	ret

0000000080005620 <sys_link>:
{
    80005620:	7169                	addi	sp,sp,-304
    80005622:	f606                	sd	ra,296(sp)
    80005624:	f222                	sd	s0,288(sp)
    80005626:	ee26                	sd	s1,280(sp)
    80005628:	ea4a                	sd	s2,272(sp)
    8000562a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000562c:	08000613          	li	a2,128
    80005630:	ed040593          	addi	a1,s0,-304
    80005634:	4501                	li	a0,0
    80005636:	ffffd097          	auipc	ra,0xffffd
    8000563a:	4cc080e7          	jalr	1228(ra) # 80002b02 <argstr>
    return -1;
    8000563e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005640:	10054e63          	bltz	a0,8000575c <sys_link+0x13c>
    80005644:	08000613          	li	a2,128
    80005648:	f5040593          	addi	a1,s0,-176
    8000564c:	4505                	li	a0,1
    8000564e:	ffffd097          	auipc	ra,0xffffd
    80005652:	4b4080e7          	jalr	1204(ra) # 80002b02 <argstr>
    return -1;
    80005656:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005658:	10054263          	bltz	a0,8000575c <sys_link+0x13c>
  begin_op();
    8000565c:	fffff097          	auipc	ra,0xfffff
    80005660:	c20080e7          	jalr	-992(ra) # 8000427c <begin_op>
  if((ip = namei(old)) == 0){
    80005664:	ed040513          	addi	a0,s0,-304
    80005668:	fffff097          	auipc	ra,0xfffff
    8000566c:	9f4080e7          	jalr	-1548(ra) # 8000405c <namei>
    80005670:	84aa                	mv	s1,a0
    80005672:	c551                	beqz	a0,800056fe <sys_link+0xde>
  ilock(ip);
    80005674:	ffffe097          	auipc	ra,0xffffe
    80005678:	23c080e7          	jalr	572(ra) # 800038b0 <ilock>
  if(ip->type == T_DIR){
    8000567c:	04449703          	lh	a4,68(s1)
    80005680:	4785                	li	a5,1
    80005682:	08f70463          	beq	a4,a5,8000570a <sys_link+0xea>
  ip->nlink++;
    80005686:	04a4d783          	lhu	a5,74(s1)
    8000568a:	2785                	addiw	a5,a5,1
    8000568c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005690:	8526                	mv	a0,s1
    80005692:	ffffe097          	auipc	ra,0xffffe
    80005696:	152080e7          	jalr	338(ra) # 800037e4 <iupdate>
  iunlock(ip);
    8000569a:	8526                	mv	a0,s1
    8000569c:	ffffe097          	auipc	ra,0xffffe
    800056a0:	2d6080e7          	jalr	726(ra) # 80003972 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800056a4:	fd040593          	addi	a1,s0,-48
    800056a8:	f5040513          	addi	a0,s0,-176
    800056ac:	fffff097          	auipc	ra,0xfffff
    800056b0:	9ce080e7          	jalr	-1586(ra) # 8000407a <nameiparent>
    800056b4:	892a                	mv	s2,a0
    800056b6:	c935                	beqz	a0,8000572a <sys_link+0x10a>
  ilock(dp);
    800056b8:	ffffe097          	auipc	ra,0xffffe
    800056bc:	1f8080e7          	jalr	504(ra) # 800038b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800056c0:	00092703          	lw	a4,0(s2)
    800056c4:	409c                	lw	a5,0(s1)
    800056c6:	04f71d63          	bne	a4,a5,80005720 <sys_link+0x100>
    800056ca:	40d0                	lw	a2,4(s1)
    800056cc:	fd040593          	addi	a1,s0,-48
    800056d0:	854a                	mv	a0,s2
    800056d2:	fffff097          	auipc	ra,0xfffff
    800056d6:	8d8080e7          	jalr	-1832(ra) # 80003faa <dirlink>
    800056da:	04054363          	bltz	a0,80005720 <sys_link+0x100>
  iunlockput(dp);
    800056de:	854a                	mv	a0,s2
    800056e0:	ffffe097          	auipc	ra,0xffffe
    800056e4:	432080e7          	jalr	1074(ra) # 80003b12 <iunlockput>
  iput(ip);
    800056e8:	8526                	mv	a0,s1
    800056ea:	ffffe097          	auipc	ra,0xffffe
    800056ee:	380080e7          	jalr	896(ra) # 80003a6a <iput>
  end_op();
    800056f2:	fffff097          	auipc	ra,0xfffff
    800056f6:	c08080e7          	jalr	-1016(ra) # 800042fa <end_op>
  return 0;
    800056fa:	4781                	li	a5,0
    800056fc:	a085                	j	8000575c <sys_link+0x13c>
    end_op();
    800056fe:	fffff097          	auipc	ra,0xfffff
    80005702:	bfc080e7          	jalr	-1028(ra) # 800042fa <end_op>
    return -1;
    80005706:	57fd                	li	a5,-1
    80005708:	a891                	j	8000575c <sys_link+0x13c>
    iunlockput(ip);
    8000570a:	8526                	mv	a0,s1
    8000570c:	ffffe097          	auipc	ra,0xffffe
    80005710:	406080e7          	jalr	1030(ra) # 80003b12 <iunlockput>
    end_op();
    80005714:	fffff097          	auipc	ra,0xfffff
    80005718:	be6080e7          	jalr	-1050(ra) # 800042fa <end_op>
    return -1;
    8000571c:	57fd                	li	a5,-1
    8000571e:	a83d                	j	8000575c <sys_link+0x13c>
    iunlockput(dp);
    80005720:	854a                	mv	a0,s2
    80005722:	ffffe097          	auipc	ra,0xffffe
    80005726:	3f0080e7          	jalr	1008(ra) # 80003b12 <iunlockput>
  ilock(ip);
    8000572a:	8526                	mv	a0,s1
    8000572c:	ffffe097          	auipc	ra,0xffffe
    80005730:	184080e7          	jalr	388(ra) # 800038b0 <ilock>
  ip->nlink--;
    80005734:	04a4d783          	lhu	a5,74(s1)
    80005738:	37fd                	addiw	a5,a5,-1
    8000573a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000573e:	8526                	mv	a0,s1
    80005740:	ffffe097          	auipc	ra,0xffffe
    80005744:	0a4080e7          	jalr	164(ra) # 800037e4 <iupdate>
  iunlockput(ip);
    80005748:	8526                	mv	a0,s1
    8000574a:	ffffe097          	auipc	ra,0xffffe
    8000574e:	3c8080e7          	jalr	968(ra) # 80003b12 <iunlockput>
  end_op();
    80005752:	fffff097          	auipc	ra,0xfffff
    80005756:	ba8080e7          	jalr	-1112(ra) # 800042fa <end_op>
  return -1;
    8000575a:	57fd                	li	a5,-1
}
    8000575c:	853e                	mv	a0,a5
    8000575e:	70b2                	ld	ra,296(sp)
    80005760:	7412                	ld	s0,288(sp)
    80005762:	64f2                	ld	s1,280(sp)
    80005764:	6952                	ld	s2,272(sp)
    80005766:	6155                	addi	sp,sp,304
    80005768:	8082                	ret

000000008000576a <sys_unlink>:
{
    8000576a:	7151                	addi	sp,sp,-240
    8000576c:	f586                	sd	ra,232(sp)
    8000576e:	f1a2                	sd	s0,224(sp)
    80005770:	eda6                	sd	s1,216(sp)
    80005772:	e9ca                	sd	s2,208(sp)
    80005774:	e5ce                	sd	s3,200(sp)
    80005776:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005778:	08000613          	li	a2,128
    8000577c:	f3040593          	addi	a1,s0,-208
    80005780:	4501                	li	a0,0
    80005782:	ffffd097          	auipc	ra,0xffffd
    80005786:	380080e7          	jalr	896(ra) # 80002b02 <argstr>
    8000578a:	18054163          	bltz	a0,8000590c <sys_unlink+0x1a2>
  begin_op();
    8000578e:	fffff097          	auipc	ra,0xfffff
    80005792:	aee080e7          	jalr	-1298(ra) # 8000427c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005796:	fb040593          	addi	a1,s0,-80
    8000579a:	f3040513          	addi	a0,s0,-208
    8000579e:	fffff097          	auipc	ra,0xfffff
    800057a2:	8dc080e7          	jalr	-1828(ra) # 8000407a <nameiparent>
    800057a6:	84aa                	mv	s1,a0
    800057a8:	c979                	beqz	a0,8000587e <sys_unlink+0x114>
  ilock(dp);
    800057aa:	ffffe097          	auipc	ra,0xffffe
    800057ae:	106080e7          	jalr	262(ra) # 800038b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800057b2:	00003597          	auipc	a1,0x3
    800057b6:	01e58593          	addi	a1,a1,30 # 800087d0 <syscalls+0x380>
    800057ba:	fb040513          	addi	a0,s0,-80
    800057be:	ffffe097          	auipc	ra,0xffffe
    800057c2:	5bc080e7          	jalr	1468(ra) # 80003d7a <namecmp>
    800057c6:	14050a63          	beqz	a0,8000591a <sys_unlink+0x1b0>
    800057ca:	00003597          	auipc	a1,0x3
    800057ce:	00e58593          	addi	a1,a1,14 # 800087d8 <syscalls+0x388>
    800057d2:	fb040513          	addi	a0,s0,-80
    800057d6:	ffffe097          	auipc	ra,0xffffe
    800057da:	5a4080e7          	jalr	1444(ra) # 80003d7a <namecmp>
    800057de:	12050e63          	beqz	a0,8000591a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800057e2:	f2c40613          	addi	a2,s0,-212
    800057e6:	fb040593          	addi	a1,s0,-80
    800057ea:	8526                	mv	a0,s1
    800057ec:	ffffe097          	auipc	ra,0xffffe
    800057f0:	5a8080e7          	jalr	1448(ra) # 80003d94 <dirlookup>
    800057f4:	892a                	mv	s2,a0
    800057f6:	12050263          	beqz	a0,8000591a <sys_unlink+0x1b0>
  ilock(ip);
    800057fa:	ffffe097          	auipc	ra,0xffffe
    800057fe:	0b6080e7          	jalr	182(ra) # 800038b0 <ilock>
  if(ip->nlink < 1)
    80005802:	04a91783          	lh	a5,74(s2)
    80005806:	08f05263          	blez	a5,8000588a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000580a:	04491703          	lh	a4,68(s2)
    8000580e:	4785                	li	a5,1
    80005810:	08f70563          	beq	a4,a5,8000589a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005814:	4641                	li	a2,16
    80005816:	4581                	li	a1,0
    80005818:	fc040513          	addi	a0,s0,-64
    8000581c:	ffffb097          	auipc	ra,0xffffb
    80005820:	4b6080e7          	jalr	1206(ra) # 80000cd2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005824:	4741                	li	a4,16
    80005826:	f2c42683          	lw	a3,-212(s0)
    8000582a:	fc040613          	addi	a2,s0,-64
    8000582e:	4581                	li	a1,0
    80005830:	8526                	mv	a0,s1
    80005832:	ffffe097          	auipc	ra,0xffffe
    80005836:	42a080e7          	jalr	1066(ra) # 80003c5c <writei>
    8000583a:	47c1                	li	a5,16
    8000583c:	0af51563          	bne	a0,a5,800058e6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005840:	04491703          	lh	a4,68(s2)
    80005844:	4785                	li	a5,1
    80005846:	0af70863          	beq	a4,a5,800058f6 <sys_unlink+0x18c>
  iunlockput(dp);
    8000584a:	8526                	mv	a0,s1
    8000584c:	ffffe097          	auipc	ra,0xffffe
    80005850:	2c6080e7          	jalr	710(ra) # 80003b12 <iunlockput>
  ip->nlink--;
    80005854:	04a95783          	lhu	a5,74(s2)
    80005858:	37fd                	addiw	a5,a5,-1
    8000585a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000585e:	854a                	mv	a0,s2
    80005860:	ffffe097          	auipc	ra,0xffffe
    80005864:	f84080e7          	jalr	-124(ra) # 800037e4 <iupdate>
  iunlockput(ip);
    80005868:	854a                	mv	a0,s2
    8000586a:	ffffe097          	auipc	ra,0xffffe
    8000586e:	2a8080e7          	jalr	680(ra) # 80003b12 <iunlockput>
  end_op();
    80005872:	fffff097          	auipc	ra,0xfffff
    80005876:	a88080e7          	jalr	-1400(ra) # 800042fa <end_op>
  return 0;
    8000587a:	4501                	li	a0,0
    8000587c:	a84d                	j	8000592e <sys_unlink+0x1c4>
    end_op();
    8000587e:	fffff097          	auipc	ra,0xfffff
    80005882:	a7c080e7          	jalr	-1412(ra) # 800042fa <end_op>
    return -1;
    80005886:	557d                	li	a0,-1
    80005888:	a05d                	j	8000592e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000588a:	00003517          	auipc	a0,0x3
    8000588e:	f5650513          	addi	a0,a0,-170 # 800087e0 <syscalls+0x390>
    80005892:	ffffb097          	auipc	ra,0xffffb
    80005896:	cae080e7          	jalr	-850(ra) # 80000540 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000589a:	04c92703          	lw	a4,76(s2)
    8000589e:	02000793          	li	a5,32
    800058a2:	f6e7f9e3          	bgeu	a5,a4,80005814 <sys_unlink+0xaa>
    800058a6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800058aa:	4741                	li	a4,16
    800058ac:	86ce                	mv	a3,s3
    800058ae:	f1840613          	addi	a2,s0,-232
    800058b2:	4581                	li	a1,0
    800058b4:	854a                	mv	a0,s2
    800058b6:	ffffe097          	auipc	ra,0xffffe
    800058ba:	2ae080e7          	jalr	686(ra) # 80003b64 <readi>
    800058be:	47c1                	li	a5,16
    800058c0:	00f51b63          	bne	a0,a5,800058d6 <sys_unlink+0x16c>
    if(de.inum != 0)
    800058c4:	f1845783          	lhu	a5,-232(s0)
    800058c8:	e7a1                	bnez	a5,80005910 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800058ca:	29c1                	addiw	s3,s3,16
    800058cc:	04c92783          	lw	a5,76(s2)
    800058d0:	fcf9ede3          	bltu	s3,a5,800058aa <sys_unlink+0x140>
    800058d4:	b781                	j	80005814 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800058d6:	00003517          	auipc	a0,0x3
    800058da:	f2250513          	addi	a0,a0,-222 # 800087f8 <syscalls+0x3a8>
    800058de:	ffffb097          	auipc	ra,0xffffb
    800058e2:	c62080e7          	jalr	-926(ra) # 80000540 <panic>
    panic("unlink: writei");
    800058e6:	00003517          	auipc	a0,0x3
    800058ea:	f2a50513          	addi	a0,a0,-214 # 80008810 <syscalls+0x3c0>
    800058ee:	ffffb097          	auipc	ra,0xffffb
    800058f2:	c52080e7          	jalr	-942(ra) # 80000540 <panic>
    dp->nlink--;
    800058f6:	04a4d783          	lhu	a5,74(s1)
    800058fa:	37fd                	addiw	a5,a5,-1
    800058fc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005900:	8526                	mv	a0,s1
    80005902:	ffffe097          	auipc	ra,0xffffe
    80005906:	ee2080e7          	jalr	-286(ra) # 800037e4 <iupdate>
    8000590a:	b781                	j	8000584a <sys_unlink+0xe0>
    return -1;
    8000590c:	557d                	li	a0,-1
    8000590e:	a005                	j	8000592e <sys_unlink+0x1c4>
    iunlockput(ip);
    80005910:	854a                	mv	a0,s2
    80005912:	ffffe097          	auipc	ra,0xffffe
    80005916:	200080e7          	jalr	512(ra) # 80003b12 <iunlockput>
  iunlockput(dp);
    8000591a:	8526                	mv	a0,s1
    8000591c:	ffffe097          	auipc	ra,0xffffe
    80005920:	1f6080e7          	jalr	502(ra) # 80003b12 <iunlockput>
  end_op();
    80005924:	fffff097          	auipc	ra,0xfffff
    80005928:	9d6080e7          	jalr	-1578(ra) # 800042fa <end_op>
  return -1;
    8000592c:	557d                	li	a0,-1
}
    8000592e:	70ae                	ld	ra,232(sp)
    80005930:	740e                	ld	s0,224(sp)
    80005932:	64ee                	ld	s1,216(sp)
    80005934:	694e                	ld	s2,208(sp)
    80005936:	69ae                	ld	s3,200(sp)
    80005938:	616d                	addi	sp,sp,240
    8000593a:	8082                	ret

000000008000593c <sys_open>:

uint64
sys_open(void)
{
    8000593c:	7131                	addi	sp,sp,-192
    8000593e:	fd06                	sd	ra,184(sp)
    80005940:	f922                	sd	s0,176(sp)
    80005942:	f526                	sd	s1,168(sp)
    80005944:	f14a                	sd	s2,160(sp)
    80005946:	ed4e                	sd	s3,152(sp)
    80005948:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000594a:	f4c40593          	addi	a1,s0,-180
    8000594e:	4505                	li	a0,1
    80005950:	ffffd097          	auipc	ra,0xffffd
    80005954:	172080e7          	jalr	370(ra) # 80002ac2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005958:	08000613          	li	a2,128
    8000595c:	f5040593          	addi	a1,s0,-176
    80005960:	4501                	li	a0,0
    80005962:	ffffd097          	auipc	ra,0xffffd
    80005966:	1a0080e7          	jalr	416(ra) # 80002b02 <argstr>
    8000596a:	87aa                	mv	a5,a0
    return -1;
    8000596c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000596e:	0a07c963          	bltz	a5,80005a20 <sys_open+0xe4>

  begin_op();
    80005972:	fffff097          	auipc	ra,0xfffff
    80005976:	90a080e7          	jalr	-1782(ra) # 8000427c <begin_op>

  if(omode & O_CREATE){
    8000597a:	f4c42783          	lw	a5,-180(s0)
    8000597e:	2007f793          	andi	a5,a5,512
    80005982:	cfc5                	beqz	a5,80005a3a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005984:	4681                	li	a3,0
    80005986:	4601                	li	a2,0
    80005988:	4589                	li	a1,2
    8000598a:	f5040513          	addi	a0,s0,-176
    8000598e:	00000097          	auipc	ra,0x0
    80005992:	972080e7          	jalr	-1678(ra) # 80005300 <create>
    80005996:	84aa                	mv	s1,a0
    if(ip == 0){
    80005998:	c959                	beqz	a0,80005a2e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000599a:	04449703          	lh	a4,68(s1)
    8000599e:	478d                	li	a5,3
    800059a0:	00f71763          	bne	a4,a5,800059ae <sys_open+0x72>
    800059a4:	0464d703          	lhu	a4,70(s1)
    800059a8:	47a5                	li	a5,9
    800059aa:	0ce7ed63          	bltu	a5,a4,80005a84 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800059ae:	fffff097          	auipc	ra,0xfffff
    800059b2:	cda080e7          	jalr	-806(ra) # 80004688 <filealloc>
    800059b6:	89aa                	mv	s3,a0
    800059b8:	10050363          	beqz	a0,80005abe <sys_open+0x182>
    800059bc:	00000097          	auipc	ra,0x0
    800059c0:	902080e7          	jalr	-1790(ra) # 800052be <fdalloc>
    800059c4:	892a                	mv	s2,a0
    800059c6:	0e054763          	bltz	a0,80005ab4 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800059ca:	04449703          	lh	a4,68(s1)
    800059ce:	478d                	li	a5,3
    800059d0:	0cf70563          	beq	a4,a5,80005a9a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800059d4:	4789                	li	a5,2
    800059d6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800059da:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800059de:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    800059e2:	f4c42783          	lw	a5,-180(s0)
    800059e6:	0017c713          	xori	a4,a5,1
    800059ea:	8b05                	andi	a4,a4,1
    800059ec:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800059f0:	0037f713          	andi	a4,a5,3
    800059f4:	00e03733          	snez	a4,a4
    800059f8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800059fc:	4007f793          	andi	a5,a5,1024
    80005a00:	c791                	beqz	a5,80005a0c <sys_open+0xd0>
    80005a02:	04449703          	lh	a4,68(s1)
    80005a06:	4789                	li	a5,2
    80005a08:	0af70063          	beq	a4,a5,80005aa8 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005a0c:	8526                	mv	a0,s1
    80005a0e:	ffffe097          	auipc	ra,0xffffe
    80005a12:	f64080e7          	jalr	-156(ra) # 80003972 <iunlock>
  end_op();
    80005a16:	fffff097          	auipc	ra,0xfffff
    80005a1a:	8e4080e7          	jalr	-1820(ra) # 800042fa <end_op>

  return fd;
    80005a1e:	854a                	mv	a0,s2
}
    80005a20:	70ea                	ld	ra,184(sp)
    80005a22:	744a                	ld	s0,176(sp)
    80005a24:	74aa                	ld	s1,168(sp)
    80005a26:	790a                	ld	s2,160(sp)
    80005a28:	69ea                	ld	s3,152(sp)
    80005a2a:	6129                	addi	sp,sp,192
    80005a2c:	8082                	ret
      end_op();
    80005a2e:	fffff097          	auipc	ra,0xfffff
    80005a32:	8cc080e7          	jalr	-1844(ra) # 800042fa <end_op>
      return -1;
    80005a36:	557d                	li	a0,-1
    80005a38:	b7e5                	j	80005a20 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005a3a:	f5040513          	addi	a0,s0,-176
    80005a3e:	ffffe097          	auipc	ra,0xffffe
    80005a42:	61e080e7          	jalr	1566(ra) # 8000405c <namei>
    80005a46:	84aa                	mv	s1,a0
    80005a48:	c905                	beqz	a0,80005a78 <sys_open+0x13c>
    ilock(ip);
    80005a4a:	ffffe097          	auipc	ra,0xffffe
    80005a4e:	e66080e7          	jalr	-410(ra) # 800038b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005a52:	04449703          	lh	a4,68(s1)
    80005a56:	4785                	li	a5,1
    80005a58:	f4f711e3          	bne	a4,a5,8000599a <sys_open+0x5e>
    80005a5c:	f4c42783          	lw	a5,-180(s0)
    80005a60:	d7b9                	beqz	a5,800059ae <sys_open+0x72>
      iunlockput(ip);
    80005a62:	8526                	mv	a0,s1
    80005a64:	ffffe097          	auipc	ra,0xffffe
    80005a68:	0ae080e7          	jalr	174(ra) # 80003b12 <iunlockput>
      end_op();
    80005a6c:	fffff097          	auipc	ra,0xfffff
    80005a70:	88e080e7          	jalr	-1906(ra) # 800042fa <end_op>
      return -1;
    80005a74:	557d                	li	a0,-1
    80005a76:	b76d                	j	80005a20 <sys_open+0xe4>
      end_op();
    80005a78:	fffff097          	auipc	ra,0xfffff
    80005a7c:	882080e7          	jalr	-1918(ra) # 800042fa <end_op>
      return -1;
    80005a80:	557d                	li	a0,-1
    80005a82:	bf79                	j	80005a20 <sys_open+0xe4>
    iunlockput(ip);
    80005a84:	8526                	mv	a0,s1
    80005a86:	ffffe097          	auipc	ra,0xffffe
    80005a8a:	08c080e7          	jalr	140(ra) # 80003b12 <iunlockput>
    end_op();
    80005a8e:	fffff097          	auipc	ra,0xfffff
    80005a92:	86c080e7          	jalr	-1940(ra) # 800042fa <end_op>
    return -1;
    80005a96:	557d                	li	a0,-1
    80005a98:	b761                	j	80005a20 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005a9a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005a9e:	04649783          	lh	a5,70(s1)
    80005aa2:	02f99223          	sh	a5,36(s3)
    80005aa6:	bf25                	j	800059de <sys_open+0xa2>
    itrunc(ip);
    80005aa8:	8526                	mv	a0,s1
    80005aaa:	ffffe097          	auipc	ra,0xffffe
    80005aae:	f14080e7          	jalr	-236(ra) # 800039be <itrunc>
    80005ab2:	bfa9                	j	80005a0c <sys_open+0xd0>
      fileclose(f);
    80005ab4:	854e                	mv	a0,s3
    80005ab6:	fffff097          	auipc	ra,0xfffff
    80005aba:	c8e080e7          	jalr	-882(ra) # 80004744 <fileclose>
    iunlockput(ip);
    80005abe:	8526                	mv	a0,s1
    80005ac0:	ffffe097          	auipc	ra,0xffffe
    80005ac4:	052080e7          	jalr	82(ra) # 80003b12 <iunlockput>
    end_op();
    80005ac8:	fffff097          	auipc	ra,0xfffff
    80005acc:	832080e7          	jalr	-1998(ra) # 800042fa <end_op>
    return -1;
    80005ad0:	557d                	li	a0,-1
    80005ad2:	b7b9                	j	80005a20 <sys_open+0xe4>

0000000080005ad4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005ad4:	7175                	addi	sp,sp,-144
    80005ad6:	e506                	sd	ra,136(sp)
    80005ad8:	e122                	sd	s0,128(sp)
    80005ada:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005adc:	ffffe097          	auipc	ra,0xffffe
    80005ae0:	7a0080e7          	jalr	1952(ra) # 8000427c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005ae4:	08000613          	li	a2,128
    80005ae8:	f7040593          	addi	a1,s0,-144
    80005aec:	4501                	li	a0,0
    80005aee:	ffffd097          	auipc	ra,0xffffd
    80005af2:	014080e7          	jalr	20(ra) # 80002b02 <argstr>
    80005af6:	02054963          	bltz	a0,80005b28 <sys_mkdir+0x54>
    80005afa:	4681                	li	a3,0
    80005afc:	4601                	li	a2,0
    80005afe:	4585                	li	a1,1
    80005b00:	f7040513          	addi	a0,s0,-144
    80005b04:	fffff097          	auipc	ra,0xfffff
    80005b08:	7fc080e7          	jalr	2044(ra) # 80005300 <create>
    80005b0c:	cd11                	beqz	a0,80005b28 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b0e:	ffffe097          	auipc	ra,0xffffe
    80005b12:	004080e7          	jalr	4(ra) # 80003b12 <iunlockput>
  end_op();
    80005b16:	ffffe097          	auipc	ra,0xffffe
    80005b1a:	7e4080e7          	jalr	2020(ra) # 800042fa <end_op>
  return 0;
    80005b1e:	4501                	li	a0,0
}
    80005b20:	60aa                	ld	ra,136(sp)
    80005b22:	640a                	ld	s0,128(sp)
    80005b24:	6149                	addi	sp,sp,144
    80005b26:	8082                	ret
    end_op();
    80005b28:	ffffe097          	auipc	ra,0xffffe
    80005b2c:	7d2080e7          	jalr	2002(ra) # 800042fa <end_op>
    return -1;
    80005b30:	557d                	li	a0,-1
    80005b32:	b7fd                	j	80005b20 <sys_mkdir+0x4c>

0000000080005b34 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005b34:	7135                	addi	sp,sp,-160
    80005b36:	ed06                	sd	ra,152(sp)
    80005b38:	e922                	sd	s0,144(sp)
    80005b3a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005b3c:	ffffe097          	auipc	ra,0xffffe
    80005b40:	740080e7          	jalr	1856(ra) # 8000427c <begin_op>
  argint(1, &major);
    80005b44:	f6c40593          	addi	a1,s0,-148
    80005b48:	4505                	li	a0,1
    80005b4a:	ffffd097          	auipc	ra,0xffffd
    80005b4e:	f78080e7          	jalr	-136(ra) # 80002ac2 <argint>
  argint(2, &minor);
    80005b52:	f6840593          	addi	a1,s0,-152
    80005b56:	4509                	li	a0,2
    80005b58:	ffffd097          	auipc	ra,0xffffd
    80005b5c:	f6a080e7          	jalr	-150(ra) # 80002ac2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b60:	08000613          	li	a2,128
    80005b64:	f7040593          	addi	a1,s0,-144
    80005b68:	4501                	li	a0,0
    80005b6a:	ffffd097          	auipc	ra,0xffffd
    80005b6e:	f98080e7          	jalr	-104(ra) # 80002b02 <argstr>
    80005b72:	02054b63          	bltz	a0,80005ba8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005b76:	f6841683          	lh	a3,-152(s0)
    80005b7a:	f6c41603          	lh	a2,-148(s0)
    80005b7e:	458d                	li	a1,3
    80005b80:	f7040513          	addi	a0,s0,-144
    80005b84:	fffff097          	auipc	ra,0xfffff
    80005b88:	77c080e7          	jalr	1916(ra) # 80005300 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b8c:	cd11                	beqz	a0,80005ba8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b8e:	ffffe097          	auipc	ra,0xffffe
    80005b92:	f84080e7          	jalr	-124(ra) # 80003b12 <iunlockput>
  end_op();
    80005b96:	ffffe097          	auipc	ra,0xffffe
    80005b9a:	764080e7          	jalr	1892(ra) # 800042fa <end_op>
  return 0;
    80005b9e:	4501                	li	a0,0
}
    80005ba0:	60ea                	ld	ra,152(sp)
    80005ba2:	644a                	ld	s0,144(sp)
    80005ba4:	610d                	addi	sp,sp,160
    80005ba6:	8082                	ret
    end_op();
    80005ba8:	ffffe097          	auipc	ra,0xffffe
    80005bac:	752080e7          	jalr	1874(ra) # 800042fa <end_op>
    return -1;
    80005bb0:	557d                	li	a0,-1
    80005bb2:	b7fd                	j	80005ba0 <sys_mknod+0x6c>

0000000080005bb4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005bb4:	7135                	addi	sp,sp,-160
    80005bb6:	ed06                	sd	ra,152(sp)
    80005bb8:	e922                	sd	s0,144(sp)
    80005bba:	e526                	sd	s1,136(sp)
    80005bbc:	e14a                	sd	s2,128(sp)
    80005bbe:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005bc0:	ffffc097          	auipc	ra,0xffffc
    80005bc4:	dec080e7          	jalr	-532(ra) # 800019ac <myproc>
    80005bc8:	892a                	mv	s2,a0
  
  begin_op();
    80005bca:	ffffe097          	auipc	ra,0xffffe
    80005bce:	6b2080e7          	jalr	1714(ra) # 8000427c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005bd2:	08000613          	li	a2,128
    80005bd6:	f6040593          	addi	a1,s0,-160
    80005bda:	4501                	li	a0,0
    80005bdc:	ffffd097          	auipc	ra,0xffffd
    80005be0:	f26080e7          	jalr	-218(ra) # 80002b02 <argstr>
    80005be4:	04054b63          	bltz	a0,80005c3a <sys_chdir+0x86>
    80005be8:	f6040513          	addi	a0,s0,-160
    80005bec:	ffffe097          	auipc	ra,0xffffe
    80005bf0:	470080e7          	jalr	1136(ra) # 8000405c <namei>
    80005bf4:	84aa                	mv	s1,a0
    80005bf6:	c131                	beqz	a0,80005c3a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005bf8:	ffffe097          	auipc	ra,0xffffe
    80005bfc:	cb8080e7          	jalr	-840(ra) # 800038b0 <ilock>
  if(ip->type != T_DIR){
    80005c00:	04449703          	lh	a4,68(s1)
    80005c04:	4785                	li	a5,1
    80005c06:	04f71063          	bne	a4,a5,80005c46 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005c0a:	8526                	mv	a0,s1
    80005c0c:	ffffe097          	auipc	ra,0xffffe
    80005c10:	d66080e7          	jalr	-666(ra) # 80003972 <iunlock>
  iput(p->cwd);
    80005c14:	15093503          	ld	a0,336(s2)
    80005c18:	ffffe097          	auipc	ra,0xffffe
    80005c1c:	e52080e7          	jalr	-430(ra) # 80003a6a <iput>
  end_op();
    80005c20:	ffffe097          	auipc	ra,0xffffe
    80005c24:	6da080e7          	jalr	1754(ra) # 800042fa <end_op>
  p->cwd = ip;
    80005c28:	14993823          	sd	s1,336(s2)
  return 0;
    80005c2c:	4501                	li	a0,0
}
    80005c2e:	60ea                	ld	ra,152(sp)
    80005c30:	644a                	ld	s0,144(sp)
    80005c32:	64aa                	ld	s1,136(sp)
    80005c34:	690a                	ld	s2,128(sp)
    80005c36:	610d                	addi	sp,sp,160
    80005c38:	8082                	ret
    end_op();
    80005c3a:	ffffe097          	auipc	ra,0xffffe
    80005c3e:	6c0080e7          	jalr	1728(ra) # 800042fa <end_op>
    return -1;
    80005c42:	557d                	li	a0,-1
    80005c44:	b7ed                	j	80005c2e <sys_chdir+0x7a>
    iunlockput(ip);
    80005c46:	8526                	mv	a0,s1
    80005c48:	ffffe097          	auipc	ra,0xffffe
    80005c4c:	eca080e7          	jalr	-310(ra) # 80003b12 <iunlockput>
    end_op();
    80005c50:	ffffe097          	auipc	ra,0xffffe
    80005c54:	6aa080e7          	jalr	1706(ra) # 800042fa <end_op>
    return -1;
    80005c58:	557d                	li	a0,-1
    80005c5a:	bfd1                	j	80005c2e <sys_chdir+0x7a>

0000000080005c5c <sys_exec>:

uint64
sys_exec(void)
{
    80005c5c:	7145                	addi	sp,sp,-464
    80005c5e:	e786                	sd	ra,456(sp)
    80005c60:	e3a2                	sd	s0,448(sp)
    80005c62:	ff26                	sd	s1,440(sp)
    80005c64:	fb4a                	sd	s2,432(sp)
    80005c66:	f74e                	sd	s3,424(sp)
    80005c68:	f352                	sd	s4,416(sp)
    80005c6a:	ef56                	sd	s5,408(sp)
    80005c6c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005c6e:	e3840593          	addi	a1,s0,-456
    80005c72:	4505                	li	a0,1
    80005c74:	ffffd097          	auipc	ra,0xffffd
    80005c78:	e6e080e7          	jalr	-402(ra) # 80002ae2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005c7c:	08000613          	li	a2,128
    80005c80:	f4040593          	addi	a1,s0,-192
    80005c84:	4501                	li	a0,0
    80005c86:	ffffd097          	auipc	ra,0xffffd
    80005c8a:	e7c080e7          	jalr	-388(ra) # 80002b02 <argstr>
    80005c8e:	87aa                	mv	a5,a0
    return -1;
    80005c90:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005c92:	0c07c363          	bltz	a5,80005d58 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80005c96:	10000613          	li	a2,256
    80005c9a:	4581                	li	a1,0
    80005c9c:	e4040513          	addi	a0,s0,-448
    80005ca0:	ffffb097          	auipc	ra,0xffffb
    80005ca4:	032080e7          	jalr	50(ra) # 80000cd2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005ca8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005cac:	89a6                	mv	s3,s1
    80005cae:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005cb0:	02000a13          	li	s4,32
    80005cb4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005cb8:	00391513          	slli	a0,s2,0x3
    80005cbc:	e3040593          	addi	a1,s0,-464
    80005cc0:	e3843783          	ld	a5,-456(s0)
    80005cc4:	953e                	add	a0,a0,a5
    80005cc6:	ffffd097          	auipc	ra,0xffffd
    80005cca:	d5e080e7          	jalr	-674(ra) # 80002a24 <fetchaddr>
    80005cce:	02054a63          	bltz	a0,80005d02 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005cd2:	e3043783          	ld	a5,-464(s0)
    80005cd6:	c3b9                	beqz	a5,80005d1c <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005cd8:	ffffb097          	auipc	ra,0xffffb
    80005cdc:	e0e080e7          	jalr	-498(ra) # 80000ae6 <kalloc>
    80005ce0:	85aa                	mv	a1,a0
    80005ce2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005ce6:	cd11                	beqz	a0,80005d02 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005ce8:	6605                	lui	a2,0x1
    80005cea:	e3043503          	ld	a0,-464(s0)
    80005cee:	ffffd097          	auipc	ra,0xffffd
    80005cf2:	d88080e7          	jalr	-632(ra) # 80002a76 <fetchstr>
    80005cf6:	00054663          	bltz	a0,80005d02 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005cfa:	0905                	addi	s2,s2,1
    80005cfc:	09a1                	addi	s3,s3,8
    80005cfe:	fb491be3          	bne	s2,s4,80005cb4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d02:	f4040913          	addi	s2,s0,-192
    80005d06:	6088                	ld	a0,0(s1)
    80005d08:	c539                	beqz	a0,80005d56 <sys_exec+0xfa>
    kfree(argv[i]);
    80005d0a:	ffffb097          	auipc	ra,0xffffb
    80005d0e:	cde080e7          	jalr	-802(ra) # 800009e8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d12:	04a1                	addi	s1,s1,8
    80005d14:	ff2499e3          	bne	s1,s2,80005d06 <sys_exec+0xaa>
  return -1;
    80005d18:	557d                	li	a0,-1
    80005d1a:	a83d                	j	80005d58 <sys_exec+0xfc>
      argv[i] = 0;
    80005d1c:	0a8e                	slli	s5,s5,0x3
    80005d1e:	fc0a8793          	addi	a5,s5,-64
    80005d22:	00878ab3          	add	s5,a5,s0
    80005d26:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005d2a:	e4040593          	addi	a1,s0,-448
    80005d2e:	f4040513          	addi	a0,s0,-192
    80005d32:	fffff097          	auipc	ra,0xfffff
    80005d36:	16e080e7          	jalr	366(ra) # 80004ea0 <exec>
    80005d3a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d3c:	f4040993          	addi	s3,s0,-192
    80005d40:	6088                	ld	a0,0(s1)
    80005d42:	c901                	beqz	a0,80005d52 <sys_exec+0xf6>
    kfree(argv[i]);
    80005d44:	ffffb097          	auipc	ra,0xffffb
    80005d48:	ca4080e7          	jalr	-860(ra) # 800009e8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d4c:	04a1                	addi	s1,s1,8
    80005d4e:	ff3499e3          	bne	s1,s3,80005d40 <sys_exec+0xe4>
  return ret;
    80005d52:	854a                	mv	a0,s2
    80005d54:	a011                	j	80005d58 <sys_exec+0xfc>
  return -1;
    80005d56:	557d                	li	a0,-1
}
    80005d58:	60be                	ld	ra,456(sp)
    80005d5a:	641e                	ld	s0,448(sp)
    80005d5c:	74fa                	ld	s1,440(sp)
    80005d5e:	795a                	ld	s2,432(sp)
    80005d60:	79ba                	ld	s3,424(sp)
    80005d62:	7a1a                	ld	s4,416(sp)
    80005d64:	6afa                	ld	s5,408(sp)
    80005d66:	6179                	addi	sp,sp,464
    80005d68:	8082                	ret

0000000080005d6a <sys_pipe>:

uint64
sys_pipe(void)
{
    80005d6a:	7139                	addi	sp,sp,-64
    80005d6c:	fc06                	sd	ra,56(sp)
    80005d6e:	f822                	sd	s0,48(sp)
    80005d70:	f426                	sd	s1,40(sp)
    80005d72:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005d74:	ffffc097          	auipc	ra,0xffffc
    80005d78:	c38080e7          	jalr	-968(ra) # 800019ac <myproc>
    80005d7c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005d7e:	fd840593          	addi	a1,s0,-40
    80005d82:	4501                	li	a0,0
    80005d84:	ffffd097          	auipc	ra,0xffffd
    80005d88:	d5e080e7          	jalr	-674(ra) # 80002ae2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005d8c:	fc840593          	addi	a1,s0,-56
    80005d90:	fd040513          	addi	a0,s0,-48
    80005d94:	fffff097          	auipc	ra,0xfffff
    80005d98:	ce0080e7          	jalr	-800(ra) # 80004a74 <pipealloc>
    return -1;
    80005d9c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005d9e:	0c054463          	bltz	a0,80005e66 <sys_pipe+0xfc>
  fd0 = -1;
    80005da2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005da6:	fd043503          	ld	a0,-48(s0)
    80005daa:	fffff097          	auipc	ra,0xfffff
    80005dae:	514080e7          	jalr	1300(ra) # 800052be <fdalloc>
    80005db2:	fca42223          	sw	a0,-60(s0)
    80005db6:	08054b63          	bltz	a0,80005e4c <sys_pipe+0xe2>
    80005dba:	fc843503          	ld	a0,-56(s0)
    80005dbe:	fffff097          	auipc	ra,0xfffff
    80005dc2:	500080e7          	jalr	1280(ra) # 800052be <fdalloc>
    80005dc6:	fca42023          	sw	a0,-64(s0)
    80005dca:	06054863          	bltz	a0,80005e3a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005dce:	4691                	li	a3,4
    80005dd0:	fc440613          	addi	a2,s0,-60
    80005dd4:	fd843583          	ld	a1,-40(s0)
    80005dd8:	68a8                	ld	a0,80(s1)
    80005dda:	ffffc097          	auipc	ra,0xffffc
    80005dde:	892080e7          	jalr	-1902(ra) # 8000166c <copyout>
    80005de2:	02054063          	bltz	a0,80005e02 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005de6:	4691                	li	a3,4
    80005de8:	fc040613          	addi	a2,s0,-64
    80005dec:	fd843583          	ld	a1,-40(s0)
    80005df0:	0591                	addi	a1,a1,4
    80005df2:	68a8                	ld	a0,80(s1)
    80005df4:	ffffc097          	auipc	ra,0xffffc
    80005df8:	878080e7          	jalr	-1928(ra) # 8000166c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005dfc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005dfe:	06055463          	bgez	a0,80005e66 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005e02:	fc442783          	lw	a5,-60(s0)
    80005e06:	07e9                	addi	a5,a5,26
    80005e08:	078e                	slli	a5,a5,0x3
    80005e0a:	97a6                	add	a5,a5,s1
    80005e0c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005e10:	fc042783          	lw	a5,-64(s0)
    80005e14:	07e9                	addi	a5,a5,26
    80005e16:	078e                	slli	a5,a5,0x3
    80005e18:	94be                	add	s1,s1,a5
    80005e1a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005e1e:	fd043503          	ld	a0,-48(s0)
    80005e22:	fffff097          	auipc	ra,0xfffff
    80005e26:	922080e7          	jalr	-1758(ra) # 80004744 <fileclose>
    fileclose(wf);
    80005e2a:	fc843503          	ld	a0,-56(s0)
    80005e2e:	fffff097          	auipc	ra,0xfffff
    80005e32:	916080e7          	jalr	-1770(ra) # 80004744 <fileclose>
    return -1;
    80005e36:	57fd                	li	a5,-1
    80005e38:	a03d                	j	80005e66 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005e3a:	fc442783          	lw	a5,-60(s0)
    80005e3e:	0007c763          	bltz	a5,80005e4c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005e42:	07e9                	addi	a5,a5,26
    80005e44:	078e                	slli	a5,a5,0x3
    80005e46:	97a6                	add	a5,a5,s1
    80005e48:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005e4c:	fd043503          	ld	a0,-48(s0)
    80005e50:	fffff097          	auipc	ra,0xfffff
    80005e54:	8f4080e7          	jalr	-1804(ra) # 80004744 <fileclose>
    fileclose(wf);
    80005e58:	fc843503          	ld	a0,-56(s0)
    80005e5c:	fffff097          	auipc	ra,0xfffff
    80005e60:	8e8080e7          	jalr	-1816(ra) # 80004744 <fileclose>
    return -1;
    80005e64:	57fd                	li	a5,-1
}
    80005e66:	853e                	mv	a0,a5
    80005e68:	70e2                	ld	ra,56(sp)
    80005e6a:	7442                	ld	s0,48(sp)
    80005e6c:	74a2                	ld	s1,40(sp)
    80005e6e:	6121                	addi	sp,sp,64
    80005e70:	8082                	ret
	...

0000000080005e80 <kernelvec>:
    80005e80:	7111                	addi	sp,sp,-256
    80005e82:	e006                	sd	ra,0(sp)
    80005e84:	e40a                	sd	sp,8(sp)
    80005e86:	e80e                	sd	gp,16(sp)
    80005e88:	ec12                	sd	tp,24(sp)
    80005e8a:	f016                	sd	t0,32(sp)
    80005e8c:	f41a                	sd	t1,40(sp)
    80005e8e:	f81e                	sd	t2,48(sp)
    80005e90:	fc22                	sd	s0,56(sp)
    80005e92:	e0a6                	sd	s1,64(sp)
    80005e94:	e4aa                	sd	a0,72(sp)
    80005e96:	e8ae                	sd	a1,80(sp)
    80005e98:	ecb2                	sd	a2,88(sp)
    80005e9a:	f0b6                	sd	a3,96(sp)
    80005e9c:	f4ba                	sd	a4,104(sp)
    80005e9e:	f8be                	sd	a5,112(sp)
    80005ea0:	fcc2                	sd	a6,120(sp)
    80005ea2:	e146                	sd	a7,128(sp)
    80005ea4:	e54a                	sd	s2,136(sp)
    80005ea6:	e94e                	sd	s3,144(sp)
    80005ea8:	ed52                	sd	s4,152(sp)
    80005eaa:	f156                	sd	s5,160(sp)
    80005eac:	f55a                	sd	s6,168(sp)
    80005eae:	f95e                	sd	s7,176(sp)
    80005eb0:	fd62                	sd	s8,184(sp)
    80005eb2:	e1e6                	sd	s9,192(sp)
    80005eb4:	e5ea                	sd	s10,200(sp)
    80005eb6:	e9ee                	sd	s11,208(sp)
    80005eb8:	edf2                	sd	t3,216(sp)
    80005eba:	f1f6                	sd	t4,224(sp)
    80005ebc:	f5fa                	sd	t5,232(sp)
    80005ebe:	f9fe                	sd	t6,240(sp)
    80005ec0:	a31fc0ef          	jal	ra,800028f0 <kerneltrap>
    80005ec4:	6082                	ld	ra,0(sp)
    80005ec6:	6122                	ld	sp,8(sp)
    80005ec8:	61c2                	ld	gp,16(sp)
    80005eca:	7282                	ld	t0,32(sp)
    80005ecc:	7322                	ld	t1,40(sp)
    80005ece:	73c2                	ld	t2,48(sp)
    80005ed0:	7462                	ld	s0,56(sp)
    80005ed2:	6486                	ld	s1,64(sp)
    80005ed4:	6526                	ld	a0,72(sp)
    80005ed6:	65c6                	ld	a1,80(sp)
    80005ed8:	6666                	ld	a2,88(sp)
    80005eda:	7686                	ld	a3,96(sp)
    80005edc:	7726                	ld	a4,104(sp)
    80005ede:	77c6                	ld	a5,112(sp)
    80005ee0:	7866                	ld	a6,120(sp)
    80005ee2:	688a                	ld	a7,128(sp)
    80005ee4:	692a                	ld	s2,136(sp)
    80005ee6:	69ca                	ld	s3,144(sp)
    80005ee8:	6a6a                	ld	s4,152(sp)
    80005eea:	7a8a                	ld	s5,160(sp)
    80005eec:	7b2a                	ld	s6,168(sp)
    80005eee:	7bca                	ld	s7,176(sp)
    80005ef0:	7c6a                	ld	s8,184(sp)
    80005ef2:	6c8e                	ld	s9,192(sp)
    80005ef4:	6d2e                	ld	s10,200(sp)
    80005ef6:	6dce                	ld	s11,208(sp)
    80005ef8:	6e6e                	ld	t3,216(sp)
    80005efa:	7e8e                	ld	t4,224(sp)
    80005efc:	7f2e                	ld	t5,232(sp)
    80005efe:	7fce                	ld	t6,240(sp)
    80005f00:	6111                	addi	sp,sp,256
    80005f02:	10200073          	sret
    80005f06:	00000013          	nop
    80005f0a:	00000013          	nop
    80005f0e:	0001                	nop

0000000080005f10 <timervec>:
    80005f10:	34051573          	csrrw	a0,mscratch,a0
    80005f14:	e10c                	sd	a1,0(a0)
    80005f16:	e510                	sd	a2,8(a0)
    80005f18:	e914                	sd	a3,16(a0)
    80005f1a:	6d0c                	ld	a1,24(a0)
    80005f1c:	7110                	ld	a2,32(a0)
    80005f1e:	6194                	ld	a3,0(a1)
    80005f20:	96b2                	add	a3,a3,a2
    80005f22:	e194                	sd	a3,0(a1)
    80005f24:	4589                	li	a1,2
    80005f26:	14459073          	csrw	sip,a1
    80005f2a:	6914                	ld	a3,16(a0)
    80005f2c:	6510                	ld	a2,8(a0)
    80005f2e:	610c                	ld	a1,0(a0)
    80005f30:	34051573          	csrrw	a0,mscratch,a0
    80005f34:	30200073          	mret
	...

0000000080005f3a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005f3a:	1141                	addi	sp,sp,-16
    80005f3c:	e422                	sd	s0,8(sp)
    80005f3e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005f40:	0c0007b7          	lui	a5,0xc000
    80005f44:	4705                	li	a4,1
    80005f46:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005f48:	c3d8                	sw	a4,4(a5)
}
    80005f4a:	6422                	ld	s0,8(sp)
    80005f4c:	0141                	addi	sp,sp,16
    80005f4e:	8082                	ret

0000000080005f50 <plicinithart>:

void
plicinithart(void)
{
    80005f50:	1141                	addi	sp,sp,-16
    80005f52:	e406                	sd	ra,8(sp)
    80005f54:	e022                	sd	s0,0(sp)
    80005f56:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f58:	ffffc097          	auipc	ra,0xffffc
    80005f5c:	a28080e7          	jalr	-1496(ra) # 80001980 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005f60:	0085171b          	slliw	a4,a0,0x8
    80005f64:	0c0027b7          	lui	a5,0xc002
    80005f68:	97ba                	add	a5,a5,a4
    80005f6a:	40200713          	li	a4,1026
    80005f6e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005f72:	00d5151b          	slliw	a0,a0,0xd
    80005f76:	0c2017b7          	lui	a5,0xc201
    80005f7a:	97aa                	add	a5,a5,a0
    80005f7c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005f80:	60a2                	ld	ra,8(sp)
    80005f82:	6402                	ld	s0,0(sp)
    80005f84:	0141                	addi	sp,sp,16
    80005f86:	8082                	ret

0000000080005f88 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005f88:	1141                	addi	sp,sp,-16
    80005f8a:	e406                	sd	ra,8(sp)
    80005f8c:	e022                	sd	s0,0(sp)
    80005f8e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f90:	ffffc097          	auipc	ra,0xffffc
    80005f94:	9f0080e7          	jalr	-1552(ra) # 80001980 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005f98:	00d5151b          	slliw	a0,a0,0xd
    80005f9c:	0c2017b7          	lui	a5,0xc201
    80005fa0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005fa2:	43c8                	lw	a0,4(a5)
    80005fa4:	60a2                	ld	ra,8(sp)
    80005fa6:	6402                	ld	s0,0(sp)
    80005fa8:	0141                	addi	sp,sp,16
    80005faa:	8082                	ret

0000000080005fac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005fac:	1101                	addi	sp,sp,-32
    80005fae:	ec06                	sd	ra,24(sp)
    80005fb0:	e822                	sd	s0,16(sp)
    80005fb2:	e426                	sd	s1,8(sp)
    80005fb4:	1000                	addi	s0,sp,32
    80005fb6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005fb8:	ffffc097          	auipc	ra,0xffffc
    80005fbc:	9c8080e7          	jalr	-1592(ra) # 80001980 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005fc0:	00d5151b          	slliw	a0,a0,0xd
    80005fc4:	0c2017b7          	lui	a5,0xc201
    80005fc8:	97aa                	add	a5,a5,a0
    80005fca:	c3c4                	sw	s1,4(a5)
}
    80005fcc:	60e2                	ld	ra,24(sp)
    80005fce:	6442                	ld	s0,16(sp)
    80005fd0:	64a2                	ld	s1,8(sp)
    80005fd2:	6105                	addi	sp,sp,32
    80005fd4:	8082                	ret

0000000080005fd6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005fd6:	1141                	addi	sp,sp,-16
    80005fd8:	e406                	sd	ra,8(sp)
    80005fda:	e022                	sd	s0,0(sp)
    80005fdc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005fde:	479d                	li	a5,7
    80005fe0:	04a7cc63          	blt	a5,a0,80006038 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005fe4:	0001c797          	auipc	a5,0x1c
    80005fe8:	dac78793          	addi	a5,a5,-596 # 80021d90 <disk>
    80005fec:	97aa                	add	a5,a5,a0
    80005fee:	0187c783          	lbu	a5,24(a5)
    80005ff2:	ebb9                	bnez	a5,80006048 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005ff4:	00451693          	slli	a3,a0,0x4
    80005ff8:	0001c797          	auipc	a5,0x1c
    80005ffc:	d9878793          	addi	a5,a5,-616 # 80021d90 <disk>
    80006000:	6398                	ld	a4,0(a5)
    80006002:	9736                	add	a4,a4,a3
    80006004:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80006008:	6398                	ld	a4,0(a5)
    8000600a:	9736                	add	a4,a4,a3
    8000600c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006010:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006014:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006018:	97aa                	add	a5,a5,a0
    8000601a:	4705                	li	a4,1
    8000601c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006020:	0001c517          	auipc	a0,0x1c
    80006024:	d8850513          	addi	a0,a0,-632 # 80021da8 <disk+0x18>
    80006028:	ffffc097          	auipc	ra,0xffffc
    8000602c:	090080e7          	jalr	144(ra) # 800020b8 <wakeup>
}
    80006030:	60a2                	ld	ra,8(sp)
    80006032:	6402                	ld	s0,0(sp)
    80006034:	0141                	addi	sp,sp,16
    80006036:	8082                	ret
    panic("free_desc 1");
    80006038:	00002517          	auipc	a0,0x2
    8000603c:	7e850513          	addi	a0,a0,2024 # 80008820 <syscalls+0x3d0>
    80006040:	ffffa097          	auipc	ra,0xffffa
    80006044:	500080e7          	jalr	1280(ra) # 80000540 <panic>
    panic("free_desc 2");
    80006048:	00002517          	auipc	a0,0x2
    8000604c:	7e850513          	addi	a0,a0,2024 # 80008830 <syscalls+0x3e0>
    80006050:	ffffa097          	auipc	ra,0xffffa
    80006054:	4f0080e7          	jalr	1264(ra) # 80000540 <panic>

0000000080006058 <virtio_disk_init>:
{
    80006058:	1101                	addi	sp,sp,-32
    8000605a:	ec06                	sd	ra,24(sp)
    8000605c:	e822                	sd	s0,16(sp)
    8000605e:	e426                	sd	s1,8(sp)
    80006060:	e04a                	sd	s2,0(sp)
    80006062:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006064:	00002597          	auipc	a1,0x2
    80006068:	7dc58593          	addi	a1,a1,2012 # 80008840 <syscalls+0x3f0>
    8000606c:	0001c517          	auipc	a0,0x1c
    80006070:	e4c50513          	addi	a0,a0,-436 # 80021eb8 <disk+0x128>
    80006074:	ffffb097          	auipc	ra,0xffffb
    80006078:	ad2080e7          	jalr	-1326(ra) # 80000b46 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000607c:	100017b7          	lui	a5,0x10001
    80006080:	4398                	lw	a4,0(a5)
    80006082:	2701                	sext.w	a4,a4
    80006084:	747277b7          	lui	a5,0x74727
    80006088:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000608c:	14f71b63          	bne	a4,a5,800061e2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006090:	100017b7          	lui	a5,0x10001
    80006094:	43dc                	lw	a5,4(a5)
    80006096:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006098:	4709                	li	a4,2
    8000609a:	14e79463          	bne	a5,a4,800061e2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000609e:	100017b7          	lui	a5,0x10001
    800060a2:	479c                	lw	a5,8(a5)
    800060a4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800060a6:	12e79e63          	bne	a5,a4,800061e2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800060aa:	100017b7          	lui	a5,0x10001
    800060ae:	47d8                	lw	a4,12(a5)
    800060b0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800060b2:	554d47b7          	lui	a5,0x554d4
    800060b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800060ba:	12f71463          	bne	a4,a5,800061e2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800060be:	100017b7          	lui	a5,0x10001
    800060c2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800060c6:	4705                	li	a4,1
    800060c8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060ca:	470d                	li	a4,3
    800060cc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800060ce:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800060d0:	c7ffe6b7          	lui	a3,0xc7ffe
    800060d4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc88f>
    800060d8:	8f75                	and	a4,a4,a3
    800060da:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060dc:	472d                	li	a4,11
    800060de:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800060e0:	5bbc                	lw	a5,112(a5)
    800060e2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800060e6:	8ba1                	andi	a5,a5,8
    800060e8:	10078563          	beqz	a5,800061f2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800060ec:	100017b7          	lui	a5,0x10001
    800060f0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800060f4:	43fc                	lw	a5,68(a5)
    800060f6:	2781                	sext.w	a5,a5
    800060f8:	10079563          	bnez	a5,80006202 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800060fc:	100017b7          	lui	a5,0x10001
    80006100:	5bdc                	lw	a5,52(a5)
    80006102:	2781                	sext.w	a5,a5
  if(max == 0)
    80006104:	10078763          	beqz	a5,80006212 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80006108:	471d                	li	a4,7
    8000610a:	10f77c63          	bgeu	a4,a5,80006222 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000610e:	ffffb097          	auipc	ra,0xffffb
    80006112:	9d8080e7          	jalr	-1576(ra) # 80000ae6 <kalloc>
    80006116:	0001c497          	auipc	s1,0x1c
    8000611a:	c7a48493          	addi	s1,s1,-902 # 80021d90 <disk>
    8000611e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006120:	ffffb097          	auipc	ra,0xffffb
    80006124:	9c6080e7          	jalr	-1594(ra) # 80000ae6 <kalloc>
    80006128:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000612a:	ffffb097          	auipc	ra,0xffffb
    8000612e:	9bc080e7          	jalr	-1604(ra) # 80000ae6 <kalloc>
    80006132:	87aa                	mv	a5,a0
    80006134:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006136:	6088                	ld	a0,0(s1)
    80006138:	cd6d                	beqz	a0,80006232 <virtio_disk_init+0x1da>
    8000613a:	0001c717          	auipc	a4,0x1c
    8000613e:	c5e73703          	ld	a4,-930(a4) # 80021d98 <disk+0x8>
    80006142:	cb65                	beqz	a4,80006232 <virtio_disk_init+0x1da>
    80006144:	c7fd                	beqz	a5,80006232 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80006146:	6605                	lui	a2,0x1
    80006148:	4581                	li	a1,0
    8000614a:	ffffb097          	auipc	ra,0xffffb
    8000614e:	b88080e7          	jalr	-1144(ra) # 80000cd2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006152:	0001c497          	auipc	s1,0x1c
    80006156:	c3e48493          	addi	s1,s1,-962 # 80021d90 <disk>
    8000615a:	6605                	lui	a2,0x1
    8000615c:	4581                	li	a1,0
    8000615e:	6488                	ld	a0,8(s1)
    80006160:	ffffb097          	auipc	ra,0xffffb
    80006164:	b72080e7          	jalr	-1166(ra) # 80000cd2 <memset>
  memset(disk.used, 0, PGSIZE);
    80006168:	6605                	lui	a2,0x1
    8000616a:	4581                	li	a1,0
    8000616c:	6888                	ld	a0,16(s1)
    8000616e:	ffffb097          	auipc	ra,0xffffb
    80006172:	b64080e7          	jalr	-1180(ra) # 80000cd2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006176:	100017b7          	lui	a5,0x10001
    8000617a:	4721                	li	a4,8
    8000617c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000617e:	4098                	lw	a4,0(s1)
    80006180:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006184:	40d8                	lw	a4,4(s1)
    80006186:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000618a:	6498                	ld	a4,8(s1)
    8000618c:	0007069b          	sext.w	a3,a4
    80006190:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006194:	9701                	srai	a4,a4,0x20
    80006196:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000619a:	6898                	ld	a4,16(s1)
    8000619c:	0007069b          	sext.w	a3,a4
    800061a0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800061a4:	9701                	srai	a4,a4,0x20
    800061a6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800061aa:	4705                	li	a4,1
    800061ac:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800061ae:	00e48c23          	sb	a4,24(s1)
    800061b2:	00e48ca3          	sb	a4,25(s1)
    800061b6:	00e48d23          	sb	a4,26(s1)
    800061ba:	00e48da3          	sb	a4,27(s1)
    800061be:	00e48e23          	sb	a4,28(s1)
    800061c2:	00e48ea3          	sb	a4,29(s1)
    800061c6:	00e48f23          	sb	a4,30(s1)
    800061ca:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800061ce:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800061d2:	0727a823          	sw	s2,112(a5)
}
    800061d6:	60e2                	ld	ra,24(sp)
    800061d8:	6442                	ld	s0,16(sp)
    800061da:	64a2                	ld	s1,8(sp)
    800061dc:	6902                	ld	s2,0(sp)
    800061de:	6105                	addi	sp,sp,32
    800061e0:	8082                	ret
    panic("could not find virtio disk");
    800061e2:	00002517          	auipc	a0,0x2
    800061e6:	66e50513          	addi	a0,a0,1646 # 80008850 <syscalls+0x400>
    800061ea:	ffffa097          	auipc	ra,0xffffa
    800061ee:	356080e7          	jalr	854(ra) # 80000540 <panic>
    panic("virtio disk FEATURES_OK unset");
    800061f2:	00002517          	auipc	a0,0x2
    800061f6:	67e50513          	addi	a0,a0,1662 # 80008870 <syscalls+0x420>
    800061fa:	ffffa097          	auipc	ra,0xffffa
    800061fe:	346080e7          	jalr	838(ra) # 80000540 <panic>
    panic("virtio disk should not be ready");
    80006202:	00002517          	auipc	a0,0x2
    80006206:	68e50513          	addi	a0,a0,1678 # 80008890 <syscalls+0x440>
    8000620a:	ffffa097          	auipc	ra,0xffffa
    8000620e:	336080e7          	jalr	822(ra) # 80000540 <panic>
    panic("virtio disk has no queue 0");
    80006212:	00002517          	auipc	a0,0x2
    80006216:	69e50513          	addi	a0,a0,1694 # 800088b0 <syscalls+0x460>
    8000621a:	ffffa097          	auipc	ra,0xffffa
    8000621e:	326080e7          	jalr	806(ra) # 80000540 <panic>
    panic("virtio disk max queue too short");
    80006222:	00002517          	auipc	a0,0x2
    80006226:	6ae50513          	addi	a0,a0,1710 # 800088d0 <syscalls+0x480>
    8000622a:	ffffa097          	auipc	ra,0xffffa
    8000622e:	316080e7          	jalr	790(ra) # 80000540 <panic>
    panic("virtio disk kalloc");
    80006232:	00002517          	auipc	a0,0x2
    80006236:	6be50513          	addi	a0,a0,1726 # 800088f0 <syscalls+0x4a0>
    8000623a:	ffffa097          	auipc	ra,0xffffa
    8000623e:	306080e7          	jalr	774(ra) # 80000540 <panic>

0000000080006242 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006242:	7119                	addi	sp,sp,-128
    80006244:	fc86                	sd	ra,120(sp)
    80006246:	f8a2                	sd	s0,112(sp)
    80006248:	f4a6                	sd	s1,104(sp)
    8000624a:	f0ca                	sd	s2,96(sp)
    8000624c:	ecce                	sd	s3,88(sp)
    8000624e:	e8d2                	sd	s4,80(sp)
    80006250:	e4d6                	sd	s5,72(sp)
    80006252:	e0da                	sd	s6,64(sp)
    80006254:	fc5e                	sd	s7,56(sp)
    80006256:	f862                	sd	s8,48(sp)
    80006258:	f466                	sd	s9,40(sp)
    8000625a:	f06a                	sd	s10,32(sp)
    8000625c:	ec6e                	sd	s11,24(sp)
    8000625e:	0100                	addi	s0,sp,128
    80006260:	8aaa                	mv	s5,a0
    80006262:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006264:	00c52d03          	lw	s10,12(a0)
    80006268:	001d1d1b          	slliw	s10,s10,0x1
    8000626c:	1d02                	slli	s10,s10,0x20
    8000626e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006272:	0001c517          	auipc	a0,0x1c
    80006276:	c4650513          	addi	a0,a0,-954 # 80021eb8 <disk+0x128>
    8000627a:	ffffb097          	auipc	ra,0xffffb
    8000627e:	95c080e7          	jalr	-1700(ra) # 80000bd6 <acquire>
  for(int i = 0; i < 3; i++){
    80006282:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006284:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006286:	0001cb97          	auipc	s7,0x1c
    8000628a:	b0ab8b93          	addi	s7,s7,-1270 # 80021d90 <disk>
  for(int i = 0; i < 3; i++){
    8000628e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006290:	0001cc97          	auipc	s9,0x1c
    80006294:	c28c8c93          	addi	s9,s9,-984 # 80021eb8 <disk+0x128>
    80006298:	a08d                	j	800062fa <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000629a:	00fb8733          	add	a4,s7,a5
    8000629e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800062a2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800062a4:	0207c563          	bltz	a5,800062ce <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800062a8:	2905                	addiw	s2,s2,1
    800062aa:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800062ac:	05690c63          	beq	s2,s6,80006304 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800062b0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800062b2:	0001c717          	auipc	a4,0x1c
    800062b6:	ade70713          	addi	a4,a4,-1314 # 80021d90 <disk>
    800062ba:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800062bc:	01874683          	lbu	a3,24(a4)
    800062c0:	fee9                	bnez	a3,8000629a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800062c2:	2785                	addiw	a5,a5,1
    800062c4:	0705                	addi	a4,a4,1
    800062c6:	fe979be3          	bne	a5,s1,800062bc <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800062ca:	57fd                	li	a5,-1
    800062cc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800062ce:	01205d63          	blez	s2,800062e8 <virtio_disk_rw+0xa6>
    800062d2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800062d4:	000a2503          	lw	a0,0(s4)
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	cfe080e7          	jalr	-770(ra) # 80005fd6 <free_desc>
      for(int j = 0; j < i; j++)
    800062e0:	2d85                	addiw	s11,s11,1
    800062e2:	0a11                	addi	s4,s4,4
    800062e4:	ff2d98e3          	bne	s11,s2,800062d4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800062e8:	85e6                	mv	a1,s9
    800062ea:	0001c517          	auipc	a0,0x1c
    800062ee:	abe50513          	addi	a0,a0,-1346 # 80021da8 <disk+0x18>
    800062f2:	ffffc097          	auipc	ra,0xffffc
    800062f6:	d62080e7          	jalr	-670(ra) # 80002054 <sleep>
  for(int i = 0; i < 3; i++){
    800062fa:	f8040a13          	addi	s4,s0,-128
{
    800062fe:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006300:	894e                	mv	s2,s3
    80006302:	b77d                	j	800062b0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006304:	f8042503          	lw	a0,-128(s0)
    80006308:	00a50713          	addi	a4,a0,10
    8000630c:	0712                	slli	a4,a4,0x4

  if(write)
    8000630e:	0001c797          	auipc	a5,0x1c
    80006312:	a8278793          	addi	a5,a5,-1406 # 80021d90 <disk>
    80006316:	00e786b3          	add	a3,a5,a4
    8000631a:	01803633          	snez	a2,s8
    8000631e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006320:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006324:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006328:	f6070613          	addi	a2,a4,-160
    8000632c:	6394                	ld	a3,0(a5)
    8000632e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006330:	00870593          	addi	a1,a4,8
    80006334:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006336:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006338:	0007b803          	ld	a6,0(a5)
    8000633c:	9642                	add	a2,a2,a6
    8000633e:	46c1                	li	a3,16
    80006340:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006342:	4585                	li	a1,1
    80006344:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80006348:	f8442683          	lw	a3,-124(s0)
    8000634c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006350:	0692                	slli	a3,a3,0x4
    80006352:	9836                	add	a6,a6,a3
    80006354:	058a8613          	addi	a2,s5,88
    80006358:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000635c:	0007b803          	ld	a6,0(a5)
    80006360:	96c2                	add	a3,a3,a6
    80006362:	40000613          	li	a2,1024
    80006366:	c690                	sw	a2,8(a3)
  if(write)
    80006368:	001c3613          	seqz	a2,s8
    8000636c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006370:	00166613          	ori	a2,a2,1
    80006374:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80006378:	f8842603          	lw	a2,-120(s0)
    8000637c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006380:	00250693          	addi	a3,a0,2
    80006384:	0692                	slli	a3,a3,0x4
    80006386:	96be                	add	a3,a3,a5
    80006388:	58fd                	li	a7,-1
    8000638a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000638e:	0612                	slli	a2,a2,0x4
    80006390:	9832                	add	a6,a6,a2
    80006392:	f9070713          	addi	a4,a4,-112
    80006396:	973e                	add	a4,a4,a5
    80006398:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000639c:	6398                	ld	a4,0(a5)
    8000639e:	9732                	add	a4,a4,a2
    800063a0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800063a2:	4609                	li	a2,2
    800063a4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800063a8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800063ac:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800063b0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800063b4:	6794                	ld	a3,8(a5)
    800063b6:	0026d703          	lhu	a4,2(a3)
    800063ba:	8b1d                	andi	a4,a4,7
    800063bc:	0706                	slli	a4,a4,0x1
    800063be:	96ba                	add	a3,a3,a4
    800063c0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800063c4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800063c8:	6798                	ld	a4,8(a5)
    800063ca:	00275783          	lhu	a5,2(a4)
    800063ce:	2785                	addiw	a5,a5,1
    800063d0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800063d4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800063d8:	100017b7          	lui	a5,0x10001
    800063dc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800063e0:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    800063e4:	0001c917          	auipc	s2,0x1c
    800063e8:	ad490913          	addi	s2,s2,-1324 # 80021eb8 <disk+0x128>
  while(b->disk == 1) {
    800063ec:	4485                	li	s1,1
    800063ee:	00b79c63          	bne	a5,a1,80006406 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800063f2:	85ca                	mv	a1,s2
    800063f4:	8556                	mv	a0,s5
    800063f6:	ffffc097          	auipc	ra,0xffffc
    800063fa:	c5e080e7          	jalr	-930(ra) # 80002054 <sleep>
  while(b->disk == 1) {
    800063fe:	004aa783          	lw	a5,4(s5)
    80006402:	fe9788e3          	beq	a5,s1,800063f2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006406:	f8042903          	lw	s2,-128(s0)
    8000640a:	00290713          	addi	a4,s2,2
    8000640e:	0712                	slli	a4,a4,0x4
    80006410:	0001c797          	auipc	a5,0x1c
    80006414:	98078793          	addi	a5,a5,-1664 # 80021d90 <disk>
    80006418:	97ba                	add	a5,a5,a4
    8000641a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000641e:	0001c997          	auipc	s3,0x1c
    80006422:	97298993          	addi	s3,s3,-1678 # 80021d90 <disk>
    80006426:	00491713          	slli	a4,s2,0x4
    8000642a:	0009b783          	ld	a5,0(s3)
    8000642e:	97ba                	add	a5,a5,a4
    80006430:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006434:	854a                	mv	a0,s2
    80006436:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000643a:	00000097          	auipc	ra,0x0
    8000643e:	b9c080e7          	jalr	-1124(ra) # 80005fd6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006442:	8885                	andi	s1,s1,1
    80006444:	f0ed                	bnez	s1,80006426 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006446:	0001c517          	auipc	a0,0x1c
    8000644a:	a7250513          	addi	a0,a0,-1422 # 80021eb8 <disk+0x128>
    8000644e:	ffffb097          	auipc	ra,0xffffb
    80006452:	83c080e7          	jalr	-1988(ra) # 80000c8a <release>
}
    80006456:	70e6                	ld	ra,120(sp)
    80006458:	7446                	ld	s0,112(sp)
    8000645a:	74a6                	ld	s1,104(sp)
    8000645c:	7906                	ld	s2,96(sp)
    8000645e:	69e6                	ld	s3,88(sp)
    80006460:	6a46                	ld	s4,80(sp)
    80006462:	6aa6                	ld	s5,72(sp)
    80006464:	6b06                	ld	s6,64(sp)
    80006466:	7be2                	ld	s7,56(sp)
    80006468:	7c42                	ld	s8,48(sp)
    8000646a:	7ca2                	ld	s9,40(sp)
    8000646c:	7d02                	ld	s10,32(sp)
    8000646e:	6de2                	ld	s11,24(sp)
    80006470:	6109                	addi	sp,sp,128
    80006472:	8082                	ret

0000000080006474 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006474:	1101                	addi	sp,sp,-32
    80006476:	ec06                	sd	ra,24(sp)
    80006478:	e822                	sd	s0,16(sp)
    8000647a:	e426                	sd	s1,8(sp)
    8000647c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000647e:	0001c497          	auipc	s1,0x1c
    80006482:	91248493          	addi	s1,s1,-1774 # 80021d90 <disk>
    80006486:	0001c517          	auipc	a0,0x1c
    8000648a:	a3250513          	addi	a0,a0,-1486 # 80021eb8 <disk+0x128>
    8000648e:	ffffa097          	auipc	ra,0xffffa
    80006492:	748080e7          	jalr	1864(ra) # 80000bd6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006496:	10001737          	lui	a4,0x10001
    8000649a:	533c                	lw	a5,96(a4)
    8000649c:	8b8d                	andi	a5,a5,3
    8000649e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800064a0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800064a4:	689c                	ld	a5,16(s1)
    800064a6:	0204d703          	lhu	a4,32(s1)
    800064aa:	0027d783          	lhu	a5,2(a5)
    800064ae:	04f70863          	beq	a4,a5,800064fe <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800064b2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800064b6:	6898                	ld	a4,16(s1)
    800064b8:	0204d783          	lhu	a5,32(s1)
    800064bc:	8b9d                	andi	a5,a5,7
    800064be:	078e                	slli	a5,a5,0x3
    800064c0:	97ba                	add	a5,a5,a4
    800064c2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800064c4:	00278713          	addi	a4,a5,2
    800064c8:	0712                	slli	a4,a4,0x4
    800064ca:	9726                	add	a4,a4,s1
    800064cc:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800064d0:	e721                	bnez	a4,80006518 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800064d2:	0789                	addi	a5,a5,2
    800064d4:	0792                	slli	a5,a5,0x4
    800064d6:	97a6                	add	a5,a5,s1
    800064d8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800064da:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800064de:	ffffc097          	auipc	ra,0xffffc
    800064e2:	bda080e7          	jalr	-1062(ra) # 800020b8 <wakeup>

    disk.used_idx += 1;
    800064e6:	0204d783          	lhu	a5,32(s1)
    800064ea:	2785                	addiw	a5,a5,1
    800064ec:	17c2                	slli	a5,a5,0x30
    800064ee:	93c1                	srli	a5,a5,0x30
    800064f0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800064f4:	6898                	ld	a4,16(s1)
    800064f6:	00275703          	lhu	a4,2(a4)
    800064fa:	faf71ce3          	bne	a4,a5,800064b2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800064fe:	0001c517          	auipc	a0,0x1c
    80006502:	9ba50513          	addi	a0,a0,-1606 # 80021eb8 <disk+0x128>
    80006506:	ffffa097          	auipc	ra,0xffffa
    8000650a:	784080e7          	jalr	1924(ra) # 80000c8a <release>
}
    8000650e:	60e2                	ld	ra,24(sp)
    80006510:	6442                	ld	s0,16(sp)
    80006512:	64a2                	ld	s1,8(sp)
    80006514:	6105                	addi	sp,sp,32
    80006516:	8082                	ret
      panic("virtio_disk_intr status");
    80006518:	00002517          	auipc	a0,0x2
    8000651c:	3f050513          	addi	a0,a0,1008 # 80008908 <syscalls+0x4b8>
    80006520:	ffffa097          	auipc	ra,0xffffa
    80006524:	020080e7          	jalr	32(ra) # 80000540 <panic>

0000000080006528 <open_file>:
  filePath: File's path
  omode: Manipulation mode

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * path, int omode){
    80006528:	7139                	addi	sp,sp,-64
    8000652a:	fc06                	sd	ra,56(sp)
    8000652c:	f822                	sd	s0,48(sp)
    8000652e:	f426                	sd	s1,40(sp)
    80006530:	f04a                	sd	s2,32(sp)
    80006532:	ec4e                	sd	s3,24(sp)
    80006534:	e852                	sd	s4,16(sp)
    80006536:	0080                	addi	s0,sp,64
    80006538:	84aa                	mv	s1,a0
    8000653a:	8a2e                	mv	s4,a1
  int fd;
  struct file *f;
  struct inode *ip;
  int n;

  begin_op();
    8000653c:	ffffe097          	auipc	ra,0xffffe
    80006540:	d40080e7          	jalr	-704(ra) # 8000427c <begin_op>

  if(omode & O_CREATE){
    80006544:	200a7793          	andi	a5,s4,512
    80006548:	c7f5                	beqz	a5,80006634 <open_file+0x10c>
  if((dp = nameiparent(path, name)) == 0)
    8000654a:	fc040593          	addi	a1,s0,-64
    8000654e:	8526                	mv	a0,s1
    80006550:	ffffe097          	auipc	ra,0xffffe
    80006554:	b2a080e7          	jalr	-1238(ra) # 8000407a <nameiparent>
    80006558:	84aa                	mv	s1,a0
    8000655a:	c531                	beqz	a0,800065a6 <open_file+0x7e>
  ilock(dp);
    8000655c:	ffffd097          	auipc	ra,0xffffd
    80006560:	354080e7          	jalr	852(ra) # 800038b0 <ilock>
  if((ip = dirlookup(dp, name, 0)) != 0){
    80006564:	4601                	li	a2,0
    80006566:	fc040593          	addi	a1,s0,-64
    8000656a:	8526                	mv	a0,s1
    8000656c:	ffffe097          	auipc	ra,0xffffe
    80006570:	828080e7          	jalr	-2008(ra) # 80003d94 <dirlookup>
    80006574:	892a                	mv	s2,a0
    80006576:	cd15                	beqz	a0,800065b2 <open_file+0x8a>
    iunlockput(dp);
    80006578:	8526                	mv	a0,s1
    8000657a:	ffffd097          	auipc	ra,0xffffd
    8000657e:	598080e7          	jalr	1432(ra) # 80003b12 <iunlockput>
    ilock(ip);
    80006582:	854a                	mv	a0,s2
    80006584:	ffffd097          	auipc	ra,0xffffd
    80006588:	32c080e7          	jalr	812(ra) # 800038b0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000658c:	04495783          	lhu	a5,68(s2)
    80006590:	37f9                	addiw	a5,a5,-2
    80006592:	17c2                	slli	a5,a5,0x30
    80006594:	93c1                	srli	a5,a5,0x30
    80006596:	4705                	li	a4,1
    80006598:	0af77e63          	bgeu	a4,a5,80006654 <open_file+0x12c>
    iunlockput(ip);
    8000659c:	854a                	mv	a0,s2
    8000659e:	ffffd097          	auipc	ra,0xffffd
    800065a2:	574080e7          	jalr	1396(ra) # 80003b12 <iunlockput>
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
    800065a6:	ffffe097          	auipc	ra,0xffffe
    800065aa:	d54080e7          	jalr	-684(ra) # 800042fa <end_op>
      return -1;
    800065ae:	54fd                	li	s1,-1
    800065b0:	aa79                	j	8000674e <open_file+0x226>
  if((ip = ialloc(dp->dev, type)) == 0){
    800065b2:	4589                	li	a1,2
    800065b4:	4088                	lw	a0,0(s1)
    800065b6:	ffffd097          	auipc	ra,0xffffd
    800065ba:	15c080e7          	jalr	348(ra) # 80003712 <ialloc>
    800065be:	892a                	mv	s2,a0
    800065c0:	c131                	beqz	a0,80006604 <open_file+0xdc>
  ilock(ip);
    800065c2:	ffffd097          	auipc	ra,0xffffd
    800065c6:	2ee080e7          	jalr	750(ra) # 800038b0 <ilock>
  ip->major = major;
    800065ca:	04091323          	sh	zero,70(s2)
  ip->minor = minor;
    800065ce:	04091423          	sh	zero,72(s2)
  ip->nlink = 1;
    800065d2:	4785                	li	a5,1
    800065d4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800065d8:	854a                	mv	a0,s2
    800065da:	ffffd097          	auipc	ra,0xffffd
    800065de:	20a080e7          	jalr	522(ra) # 800037e4 <iupdate>
  if(dirlink(dp, name, ip->inum) < 0)
    800065e2:	00492603          	lw	a2,4(s2)
    800065e6:	fc040593          	addi	a1,s0,-64
    800065ea:	8526                	mv	a0,s1
    800065ec:	ffffe097          	auipc	ra,0xffffe
    800065f0:	9be080e7          	jalr	-1602(ra) # 80003faa <dirlink>
    800065f4:	00054e63          	bltz	a0,80006610 <open_file+0xe8>
  iunlockput(dp);
    800065f8:	8526                	mv	a0,s1
    800065fa:	ffffd097          	auipc	ra,0xffffd
    800065fe:	518080e7          	jalr	1304(ra) # 80003b12 <iunlockput>
  return ip;
    80006602:	a889                	j	80006654 <open_file+0x12c>
    iunlockput(dp);
    80006604:	8526                	mv	a0,s1
    80006606:	ffffd097          	auipc	ra,0xffffd
    8000660a:	50c080e7          	jalr	1292(ra) # 80003b12 <iunlockput>
    return 0;
    8000660e:	bf61                	j	800065a6 <open_file+0x7e>
  ip->nlink = 0;
    80006610:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80006614:	854a                	mv	a0,s2
    80006616:	ffffd097          	auipc	ra,0xffffd
    8000661a:	1ce080e7          	jalr	462(ra) # 800037e4 <iupdate>
  iunlockput(ip);
    8000661e:	854a                	mv	a0,s2
    80006620:	ffffd097          	auipc	ra,0xffffd
    80006624:	4f2080e7          	jalr	1266(ra) # 80003b12 <iunlockput>
  iunlockput(dp);
    80006628:	8526                	mv	a0,s1
    8000662a:	ffffd097          	auipc	ra,0xffffd
    8000662e:	4e8080e7          	jalr	1256(ra) # 80003b12 <iunlockput>
  return 0;
    80006632:	bf95                	j	800065a6 <open_file+0x7e>
    }
  } else {
    if((ip = namei(path)) == 0){
    80006634:	8526                	mv	a0,s1
    80006636:	ffffe097          	auipc	ra,0xffffe
    8000663a:	a26080e7          	jalr	-1498(ra) # 8000405c <namei>
    8000663e:	892a                	mv	s2,a0
    80006640:	c925                	beqz	a0,800066b0 <open_file+0x188>
      end_op();
      return -1;
    }
    ilock(ip);
    80006642:	ffffd097          	auipc	ra,0xffffd
    80006646:	26e080e7          	jalr	622(ra) # 800038b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000664a:	04491703          	lh	a4,68(s2)
    8000664e:	4785                	li	a5,1
    80006650:	06f70663          	beq	a4,a5,800066bc <open_file+0x194>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80006654:	04491703          	lh	a4,68(s2)
    80006658:	478d                	li	a5,3
    8000665a:	00f71763          	bne	a4,a5,80006668 <open_file+0x140>
    8000665e:	04695703          	lhu	a4,70(s2)
    80006662:	47a5                	li	a5,9
    80006664:	06e7e963          	bltu	a5,a4,800066d6 <open_file+0x1ae>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006668:	ffffe097          	auipc	ra,0xffffe
    8000666c:	020080e7          	jalr	32(ra) # 80004688 <filealloc>
    80006670:	89aa                	mv	s3,a0
    80006672:	c505                	beqz	a0,8000669a <open_file+0x172>
  struct proc *p = myproc();
    80006674:	ffffb097          	auipc	ra,0xffffb
    80006678:	338080e7          	jalr	824(ra) # 800019ac <myproc>
  for(fd = 0; fd < NOFILE; fd++){
    8000667c:	0d050793          	addi	a5,a0,208
    80006680:	4481                	li	s1,0
    80006682:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80006684:	6398                	ld	a4,0(a5)
    80006686:	c33d                	beqz	a4,800066ec <open_file+0x1c4>
  for(fd = 0; fd < NOFILE; fd++){
    80006688:	2485                	addiw	s1,s1,1
    8000668a:	07a1                	addi	a5,a5,8
    8000668c:	fed49ce3          	bne	s1,a3,80006684 <open_file+0x15c>
    if(f)
      fileclose(f);
    80006690:	854e                	mv	a0,s3
    80006692:	ffffe097          	auipc	ra,0xffffe
    80006696:	0b2080e7          	jalr	178(ra) # 80004744 <fileclose>
    iunlockput(ip);
    8000669a:	854a                	mv	a0,s2
    8000669c:	ffffd097          	auipc	ra,0xffffd
    800066a0:	476080e7          	jalr	1142(ra) # 80003b12 <iunlockput>
    end_op();
    800066a4:	ffffe097          	auipc	ra,0xffffe
    800066a8:	c56080e7          	jalr	-938(ra) # 800042fa <end_op>
    return -1;
    800066ac:	54fd                	li	s1,-1
    800066ae:	a045                	j	8000674e <open_file+0x226>
      end_op();
    800066b0:	ffffe097          	auipc	ra,0xffffe
    800066b4:	c4a080e7          	jalr	-950(ra) # 800042fa <end_op>
      return -1;
    800066b8:	54fd                	li	s1,-1
    800066ba:	a851                	j	8000674e <open_file+0x226>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800066bc:	fa0a06e3          	beqz	s4,80006668 <open_file+0x140>
      iunlockput(ip);
    800066c0:	854a                	mv	a0,s2
    800066c2:	ffffd097          	auipc	ra,0xffffd
    800066c6:	450080e7          	jalr	1104(ra) # 80003b12 <iunlockput>
      end_op();
    800066ca:	ffffe097          	auipc	ra,0xffffe
    800066ce:	c30080e7          	jalr	-976(ra) # 800042fa <end_op>
      return -1;
    800066d2:	54fd                	li	s1,-1
    800066d4:	a8ad                	j	8000674e <open_file+0x226>
    iunlockput(ip);
    800066d6:	854a                	mv	a0,s2
    800066d8:	ffffd097          	auipc	ra,0xffffd
    800066dc:	43a080e7          	jalr	1082(ra) # 80003b12 <iunlockput>
    end_op();
    800066e0:	ffffe097          	auipc	ra,0xffffe
    800066e4:	c1a080e7          	jalr	-998(ra) # 800042fa <end_op>
    return -1;
    800066e8:	54fd                	li	s1,-1
    800066ea:	a095                	j	8000674e <open_file+0x226>
      p->ofile[fd] = f;
    800066ec:	01a48793          	addi	a5,s1,26
    800066f0:	078e                	slli	a5,a5,0x3
    800066f2:	953e                	add	a0,a0,a5
    800066f4:	01353023          	sd	s3,0(a0)
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800066f8:	f804cce3          	bltz	s1,80006690 <open_file+0x168>
  }

  if(ip->type == T_DEVICE){
    800066fc:	04491703          	lh	a4,68(s2)
    80006700:	478d                	li	a5,3
    80006702:	04f70f63          	beq	a4,a5,80006760 <open_file+0x238>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006706:	4789                	li	a5,2
    80006708:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000670c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80006710:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80006714:	001a4793          	xori	a5,s4,1
    80006718:	8b85                	andi	a5,a5,1
    8000671a:	00f98423          	sb	a5,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000671e:	003a7793          	andi	a5,s4,3
    80006722:	00f037b3          	snez	a5,a5
    80006726:	00f984a3          	sb	a5,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000672a:	400a7a13          	andi	s4,s4,1024
    8000672e:	000a0763          	beqz	s4,8000673c <open_file+0x214>
    80006732:	04491703          	lh	a4,68(s2)
    80006736:	4789                	li	a5,2
    80006738:	02f70b63          	beq	a4,a5,8000676e <open_file+0x246>
    itrunc(ip);
  }

  iunlock(ip);
    8000673c:	854a                	mv	a0,s2
    8000673e:	ffffd097          	auipc	ra,0xffffd
    80006742:	234080e7          	jalr	564(ra) # 80003972 <iunlock>
  end_op();
    80006746:	ffffe097          	auipc	ra,0xffffe
    8000674a:	bb4080e7          	jalr	-1100(ra) # 800042fa <end_op>

  return fd;


}
    8000674e:	8526                	mv	a0,s1
    80006750:	70e2                	ld	ra,56(sp)
    80006752:	7442                	ld	s0,48(sp)
    80006754:	74a2                	ld	s1,40(sp)
    80006756:	7902                	ld	s2,32(sp)
    80006758:	69e2                	ld	s3,24(sp)
    8000675a:	6a42                	ld	s4,16(sp)
    8000675c:	6121                	addi	sp,sp,64
    8000675e:	8082                	ret
    f->type = FD_DEVICE;
    80006760:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80006764:	04691783          	lh	a5,70(s2)
    80006768:	02f99223          	sh	a5,36(s3)
    8000676c:	b755                	j	80006710 <open_file+0x1e8>
    itrunc(ip);
    8000676e:	854a                	mv	a0,s2
    80006770:	ffffd097          	auipc	ra,0xffffd
    80006774:	24e080e7          	jalr	590(ra) # 800039be <itrunc>
    80006778:	b7d1                	j	8000673c <open_file+0x214>

000000008000677a <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
    8000677a:	715d                	addi	sp,sp,-80
    8000677c:	e486                	sd	ra,72(sp)
    8000677e:	e0a2                	sd	s0,64(sp)
    80006780:	fc26                	sd	s1,56(sp)
    80006782:	f84a                	sd	s2,48(sp)
    80006784:	f44e                	sd	s3,40(sp)
    80006786:	f052                	sd	s4,32(sp)
    80006788:	ec56                	sd	s5,24(sp)
    8000678a:	e85a                	sd	s6,16(sp)
    8000678c:	0880                	addi	s0,sp,80

  struct file *f;

  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000678e:	47bd                	li	a5,15
    return -1;
    80006790:	59fd                	li	s3,-1
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80006792:	00a7fd63          	bgeu	a5,a0,800067ac <read_line+0x32>

    }

  }

}
    80006796:	854e                	mv	a0,s3
    80006798:	60a6                	ld	ra,72(sp)
    8000679a:	6406                	ld	s0,64(sp)
    8000679c:	74e2                	ld	s1,56(sp)
    8000679e:	7942                	ld	s2,48(sp)
    800067a0:	79a2                	ld	s3,40(sp)
    800067a2:	7a02                	ld	s4,32(sp)
    800067a4:	6ae2                	ld	s5,24(sp)
    800067a6:	6b42                	ld	s6,16(sp)
    800067a8:	6161                	addi	sp,sp,80
    800067aa:	8082                	ret
    800067ac:	892e                	mv	s2,a1
    800067ae:	89aa                	mv	s3,a0
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800067b0:	ffffb097          	auipc	ra,0xffffb
    800067b4:	1fc080e7          	jalr	508(ra) # 800019ac <myproc>
    800067b8:	01a98793          	addi	a5,s3,26
    800067bc:	078e                	slli	a5,a5,0x3
    800067be:	953e                	add	a0,a0,a5
    800067c0:	6104                	ld	s1,0(a0)
    800067c2:	c0f5                	beqz	s1,800068a6 <read_line+0x12c>
  if (!fd){ 
    800067c4:	08099c63          	bnez	s3,8000685c <read_line+0xe2>
    if (f->pipe){
    800067c8:	689c                	ld	a5,16(s1)
    800067ca:	8a4a                	mv	s4,s2
    800067cc:	4a81                	li	s5,0
        if (buffer[idx]=='\n'){
    800067ce:	4b29                	li	s6,10
    if (f->pipe){
    800067d0:	ef8d                	bnez	a5,8000680a <read_line+0x90>
    800067d2:	89ca                	mv	s3,s2
    800067d4:	4a01                	li	s4,0
      while((readStatus=devsw[f->major].read(0, (uint64)buffer+idx, 1)) == 1){ // The first 0 indicates kernel address
    800067d6:	0001aa97          	auipc	s5,0x1a
    800067da:	562a8a93          	addi	s5,s5,1378 # 80020d38 <devsw>
    800067de:	02449783          	lh	a5,36(s1)
    800067e2:	0792                	slli	a5,a5,0x4
    800067e4:	97d6                	add	a5,a5,s5
    800067e6:	639c                	ld	a5,0(a5)
    800067e8:	4605                	li	a2,1
    800067ea:	85ce                	mv	a1,s3
    800067ec:	4501                	li	a0,0
    800067ee:	9782                	jalr	a5
    800067f0:	4785                	li	a5,1
    800067f2:	06f51163          	bne	a0,a5,80006854 <read_line+0xda>
        if (buffer[idx]=='\n'){
    800067f6:	0009c783          	lbu	a5,0(s3)
    800067fa:	001a0713          	addi	a4,s4,1
    800067fe:	0985                	addi	s3,s3,1
    80006800:	05678663          	beq	a5,s6,8000684c <read_line+0xd2>
    80006804:	8a3a                	mv	s4,a4
    80006806:	bfe1                	j	800067de <read_line+0x64>
    80006808:	8aba                	mv	s5,a4
    8000680a:	000a899b          	sext.w	s3,s5
        readStatus = read_pipe(f->pipe,(uint64)buffer+idx,1);
    8000680e:	4605                	li	a2,1
    80006810:	85d2                	mv	a1,s4
    80006812:	6888                	ld	a0,16(s1)
    80006814:	ffffe097          	auipc	ra,0xffffe
    80006818:	590080e7          	jalr	1424(ra) # 80004da4 <read_pipe>
        if (readStatus<= 0){
    8000681c:	00a05e63          	blez	a0,80006838 <read_line+0xbe>
        if (buffer[idx]=='\n'){
    80006820:	000a4783          	lbu	a5,0(s4)
    80006824:	001a8713          	addi	a4,s5,1
    80006828:	0a05                	addi	s4,s4,1
    8000682a:	fd679fe3          	bne	a5,s6,80006808 <read_line+0x8e>
          buffer[idx+1]=0;
    8000682e:	9aca                	add	s5,s5,s2
    80006830:	000a80a3          	sb	zero,1(s5)
          return idx+1;
    80006834:	2985                	addiw	s3,s3,1
    80006836:	b785                	j	80006796 <read_line+0x1c>
          if (idx!=0){
    80006838:	f4098fe3          	beqz	s3,80006796 <read_line+0x1c>
            buffer[idx] = '\n';
    8000683c:	9aca                	add	s5,s5,s2
    8000683e:	47a9                	li	a5,10
    80006840:	00fa8023          	sb	a5,0(s5)
            buffer[idx+1]=0;
    80006844:	000a80a3          	sb	zero,1(s5)
            return idx+1;
    80006848:	2985                	addiw	s3,s3,1
    8000684a:	b7b1                	j	80006796 <read_line+0x1c>
          buffer[idx+1]=0;
    8000684c:	9a4a                	add	s4,s4,s2
    8000684e:	000a00a3          	sb	zero,1(s4)
      if (!newLine)
    80006852:	b791                	j	80006796 <read_line+0x1c>
        buffer[idx]=0;
    80006854:	9a4a                	add	s4,s4,s2
    80006856:	000a0023          	sb	zero,0(s4)
}
    8000685a:	bf35                	j	80006796 <read_line+0x1c>
  int byteCount = 0;
    8000685c:	4981                	li	s3,0
        if (readByte == '\n'){
    8000685e:	4a29                	li	s4,10
        readStatus = readi(f->ip, 0, (uint64)&readByte, f->off, 1);
    80006860:	4705                	li	a4,1
    80006862:	5094                	lw	a3,32(s1)
    80006864:	fbf40613          	addi	a2,s0,-65
    80006868:	4581                	li	a1,0
    8000686a:	6c88                	ld	a0,24(s1)
    8000686c:	ffffd097          	auipc	ra,0xffffd
    80006870:	2f8080e7          	jalr	760(ra) # 80003b64 <readi>
        if (readStatus > 0)
    80006874:	02a05063          	blez	a0,80006894 <read_line+0x11a>
          f->off += readStatus;
    80006878:	509c                	lw	a5,32(s1)
    8000687a:	9fa9                	addw	a5,a5,a0
    8000687c:	d09c                	sw	a5,32(s1)
        *buffer++ = readByte;
    8000687e:	0905                	addi	s2,s2,1
    80006880:	fbf44783          	lbu	a5,-65(s0)
    80006884:	fef90fa3          	sb	a5,-1(s2)
        byteCount++;
    80006888:	2985                	addiw	s3,s3,1
        if (readByte == '\n'){
    8000688a:	fd479be3          	bne	a5,s4,80006860 <read_line+0xe6>
            *(buffer)=0; // Nullifying the end of the string
    8000688e:	00090023          	sb	zero,0(s2)
          return byteCount;
    80006892:	b711                	j	80006796 <read_line+0x1c>
          if (byteCount!=0){
    80006894:	f00981e3          	beqz	s3,80006796 <read_line+0x1c>
            *buffer = '\n';
    80006898:	47a9                	li	a5,10
    8000689a:	00f90023          	sb	a5,0(s2)
            *(buffer+1)=0;
    8000689e:	000900a3          	sb	zero,1(s2)
            return byteCount+1;
    800068a2:	2985                	addiw	s3,s3,1
    800068a4:	bdcd                	j	80006796 <read_line+0x1c>
    return -1;
    800068a6:	59fd                	li	s3,-1
    800068a8:	b5fd                	j	80006796 <read_line+0x1c>

00000000800068aa <close_file>:
  fd: File discriptor

[OUTPUT]:

*/
void close_file(struct file *f){
    800068aa:	1141                	addi	sp,sp,-16
    800068ac:	e406                	sd	ra,8(sp)
    800068ae:	e022                	sd	s0,0(sp)
    800068b0:	0800                	addi	s0,sp,16
  fileclose(f);
    800068b2:	ffffe097          	auipc	ra,0xffffe
    800068b6:	e92080e7          	jalr	-366(ra) # 80004744 <fileclose>
}
    800068ba:	60a2                	ld	ra,8(sp)
    800068bc:	6402                	ld	s0,0(sp)
    800068be:	0141                	addi	sp,sp,16
    800068c0:	8082                	ret

00000000800068c2 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
    800068c2:	1141                	addi	sp,sp,-16
    800068c4:	e422                	sd	s0,8(sp)
    800068c6:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
    800068c8:	00054783          	lbu	a5,0(a0)
    800068cc:	cf99                	beqz	a5,800068ea <get_strlen+0x28>
    800068ce:	00150713          	addi	a4,a0,1
    800068d2:	87ba                	mv	a5,a4
    800068d4:	4685                	li	a3,1
    800068d6:	9e99                	subw	a3,a3,a4
    800068d8:	00f6853b          	addw	a0,a3,a5
    800068dc:	0785                	addi	a5,a5,1
    800068de:	fff7c703          	lbu	a4,-1(a5)
    800068e2:	fb7d                	bnez	a4,800068d8 <get_strlen+0x16>
	return len;
}
    800068e4:	6422                	ld	s0,8(sp)
    800068e6:	0141                	addi	sp,sp,16
    800068e8:	8082                	ret
	int len = 0;
    800068ea:	4501                	li	a0,0
    800068ec:	bfe5                	j	800068e4 <get_strlen+0x22>

00000000800068ee <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
    800068ee:	1141                	addi	sp,sp,-16
    800068f0:	e422                	sd	s0,8(sp)
    800068f2:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
    800068f4:	00054783          	lbu	a5,0(a0)
    800068f8:	cb91                	beqz	a5,8000690c <compare_str+0x1e>
    800068fa:	0005c703          	lbu	a4,0(a1)
    800068fe:	c719                	beqz	a4,8000690c <compare_str+0x1e>
		if (*s1++ != *s2++)
    80006900:	0505                	addi	a0,a0,1
    80006902:	0585                	addi	a1,a1,1
    80006904:	fee788e3          	beq	a5,a4,800068f4 <compare_str+0x6>
			return 1;
    80006908:	4505                	li	a0,1
    8000690a:	a031                	j	80006916 <compare_str+0x28>
	}
	if (*s1 == *s2)
    8000690c:	0005c503          	lbu	a0,0(a1)
    80006910:	8d1d                	sub	a0,a0,a5
			return 1;
    80006912:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    80006916:	6422                	ld	s0,8(sp)
    80006918:	0141                	addi	sp,sp,16
    8000691a:	8082                	ret

000000008000691c <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
    8000691c:	1141                	addi	sp,sp,-16
    8000691e:	e422                	sd	s0,8(sp)
    80006920:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
    80006922:	4665                	li	a2,25
	while(*s1 && *s2){
    80006924:	a019                	j	8000692a <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
    80006926:	04e79763          	bne	a5,a4,80006974 <compare_str_ic+0x58>
	while(*s1 && *s2){
    8000692a:	00054783          	lbu	a5,0(a0)
    8000692e:	cb9d                	beqz	a5,80006964 <compare_str_ic+0x48>
    80006930:	0005c703          	lbu	a4,0(a1)
    80006934:	cb05                	beqz	a4,80006964 <compare_str_ic+0x48>
		char b1 = *s1++;
    80006936:	0505                	addi	a0,a0,1
		char b2 = *s2++;
    80006938:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
    8000693a:	fbf7869b          	addiw	a3,a5,-65
    8000693e:	0ff6f693          	zext.b	a3,a3
    80006942:	00d66663          	bltu	a2,a3,8000694e <compare_str_ic+0x32>
			b1 += 32;
    80006946:	0207879b          	addiw	a5,a5,32
    8000694a:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
    8000694e:	fbf7069b          	addiw	a3,a4,-65
    80006952:	0ff6f693          	zext.b	a3,a3
    80006956:	fcd668e3          	bltu	a2,a3,80006926 <compare_str_ic+0xa>
			b2 += 32;
    8000695a:	0207071b          	addiw	a4,a4,32
    8000695e:	0ff77713          	zext.b	a4,a4
    80006962:	b7d1                	j	80006926 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
    80006964:	0005c503          	lbu	a0,0(a1)
    80006968:	8d1d                	sub	a0,a0,a5
			return 1;
    8000696a:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    8000696e:	6422                	ld	s0,8(sp)
    80006970:	0141                	addi	sp,sp,16
    80006972:	8082                	ret
			return 1;
    80006974:	4505                	li	a0,1
    80006976:	bfe5                	j	8000696e <compare_str_ic+0x52>

0000000080006978 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
    80006978:	c1d9                	beqz	a1,800069fe <head_run+0x86>
void head_run(int fd, int numOfLines){
    8000697a:	dd010113          	addi	sp,sp,-560
    8000697e:	22113423          	sd	ra,552(sp)
    80006982:	22813023          	sd	s0,544(sp)
    80006986:	20913c23          	sd	s1,536(sp)
    8000698a:	21213823          	sd	s2,528(sp)
    8000698e:	21313423          	sd	s3,520(sp)
    80006992:	21413023          	sd	s4,512(sp)
    80006996:	1c00                	addi	s0,sp,560
    80006998:	892a                	mv	s2,a0
    8000699a:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
    8000699e:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
    800069a0:	00002a17          	auipc	s4,0x2
    800069a4:	fa8a0a13          	addi	s4,s4,-88 # 80008948 <syscalls+0x4f8>
		readStatus = read_line(fd, line);
    800069a8:	dd840593          	addi	a1,s0,-552
    800069ac:	854a                	mv	a0,s2
    800069ae:	00000097          	auipc	ra,0x0
    800069b2:	dcc080e7          	jalr	-564(ra) # 8000677a <read_line>
		if (readStatus == READ_ERROR){
    800069b6:	01350d63          	beq	a0,s3,800069d0 <head_run+0x58>
		if (readStatus == READ_EOF)
    800069ba:	c11d                	beqz	a0,800069e0 <head_run+0x68>
		printf("%s",line);
    800069bc:	dd840593          	addi	a1,s0,-552
    800069c0:	8552                	mv	a0,s4
    800069c2:	ffffa097          	auipc	ra,0xffffa
    800069c6:	bc8080e7          	jalr	-1080(ra) # 8000058a <printf>
	while(numOfLines--){
    800069ca:	34fd                	addiw	s1,s1,-1
    800069cc:	fcf1                	bnez	s1,800069a8 <head_run+0x30>
    800069ce:	a809                	j	800069e0 <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
    800069d0:	00002517          	auipc	a0,0x2
    800069d4:	f5050513          	addi	a0,a0,-176 # 80008920 <syscalls+0x4d0>
    800069d8:	ffffa097          	auipc	ra,0xffffa
    800069dc:	bb2080e7          	jalr	-1102(ra) # 8000058a <printf>

	}
}
    800069e0:	22813083          	ld	ra,552(sp)
    800069e4:	22013403          	ld	s0,544(sp)
    800069e8:	21813483          	ld	s1,536(sp)
    800069ec:	21013903          	ld	s2,528(sp)
    800069f0:	20813983          	ld	s3,520(sp)
    800069f4:	20013a03          	ld	s4,512(sp)
    800069f8:	23010113          	addi	sp,sp,560
    800069fc:	8082                	ret
    800069fe:	8082                	ret

0000000080006a00 <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
    80006a00:	ba010113          	addi	sp,sp,-1120
    80006a04:	44113c23          	sd	ra,1112(sp)
    80006a08:	44813823          	sd	s0,1104(sp)
    80006a0c:	44913423          	sd	s1,1096(sp)
    80006a10:	45213023          	sd	s2,1088(sp)
    80006a14:	43313c23          	sd	s3,1080(sp)
    80006a18:	43413823          	sd	s4,1072(sp)
    80006a1c:	43513423          	sd	s5,1064(sp)
    80006a20:	43613023          	sd	s6,1056(sp)
    80006a24:	41713c23          	sd	s7,1048(sp)
    80006a28:	41813823          	sd	s8,1040(sp)
    80006a2c:	41913423          	sd	s9,1032(sp)
    80006a30:	41a13023          	sd	s10,1024(sp)
    80006a34:	3fb13c23          	sd	s11,1016(sp)
    80006a38:	46010413          	addi	s0,sp,1120
    80006a3c:	89aa                	mv	s3,a0
    80006a3e:	8aae                	mv	s5,a1
    80006a40:	8c32                	mv	s8,a2
    80006a42:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
    80006a44:	d9840593          	addi	a1,s0,-616
    80006a48:	00000097          	auipc	ra,0x0
    80006a4c:	d32080e7          	jalr	-718(ra) # 8000677a <read_line>


  if (readStatus == READ_ERROR)
    80006a50:	57fd                	li	a5,-1
    80006a52:	04f50163          	beq	a0,a5,80006a94 <uniq_run+0x94>
    80006a56:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
    80006a58:	ed21                	bnez	a0,80006ab0 <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
    80006a5a:	45813083          	ld	ra,1112(sp)
    80006a5e:	45013403          	ld	s0,1104(sp)
    80006a62:	44813483          	ld	s1,1096(sp)
    80006a66:	44013903          	ld	s2,1088(sp)
    80006a6a:	43813983          	ld	s3,1080(sp)
    80006a6e:	43013a03          	ld	s4,1072(sp)
    80006a72:	42813a83          	ld	s5,1064(sp)
    80006a76:	42013b03          	ld	s6,1056(sp)
    80006a7a:	41813b83          	ld	s7,1048(sp)
    80006a7e:	41013c03          	ld	s8,1040(sp)
    80006a82:	40813c83          	ld	s9,1032(sp)
    80006a86:	40013d03          	ld	s10,1024(sp)
    80006a8a:	3f813d83          	ld	s11,1016(sp)
    80006a8e:	46010113          	addi	sp,sp,1120
    80006a92:	8082                	ret
    printf("[ERR] Error reading from the file ");
    80006a94:	00002517          	auipc	a0,0x2
    80006a98:	ebc50513          	addi	a0,a0,-324 # 80008950 <syscalls+0x500>
    80006a9c:	ffffa097          	auipc	ra,0xffffa
    80006aa0:	aee080e7          	jalr	-1298(ra) # 8000058a <printf>
    80006aa4:	bf5d                	j	80006a5a <uniq_run+0x5a>
    80006aa6:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006aa8:	8926                	mv	s2,s1
    80006aaa:	84be                	mv	s1,a5
        lineCount = 1;
    80006aac:	8b6a                	mv	s6,s10
    80006aae:	a8ed                	j	80006ba8 <uniq_run+0x1a8>
    int lineCount=1;
    80006ab0:	4b05                	li	s6,1
  char * line2 = buffer2;
    80006ab2:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
    80006ab6:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
    80006aba:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
    80006abc:	4d05                	li	s10,1
              printf("%s",line1);
    80006abe:	00002d97          	auipc	s11,0x2
    80006ac2:	e8ad8d93          	addi	s11,s11,-374 # 80008948 <syscalls+0x4f8>
    80006ac6:	a0cd                	j	80006ba8 <uniq_run+0x1a8>
            if (repeatedLines){
    80006ac8:	020a0b63          	beqz	s4,80006afe <uniq_run+0xfe>
                if (isRepeated){
    80006acc:	f80b87e3          	beqz	s7,80006a5a <uniq_run+0x5a>
                    if (showCount)
    80006ad0:	000c0d63          	beqz	s8,80006aea <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
    80006ad4:	864a                	mv	a2,s2
    80006ad6:	85da                	mv	a1,s6
    80006ad8:	00002517          	auipc	a0,0x2
    80006adc:	ea050513          	addi	a0,a0,-352 # 80008978 <syscalls+0x528>
    80006ae0:	ffffa097          	auipc	ra,0xffffa
    80006ae4:	aaa080e7          	jalr	-1366(ra) # 8000058a <printf>
    80006ae8:	bf8d                	j	80006a5a <uniq_run+0x5a>
                      printf("%s",line1);
    80006aea:	85ca                	mv	a1,s2
    80006aec:	00002517          	auipc	a0,0x2
    80006af0:	e5c50513          	addi	a0,a0,-420 # 80008948 <syscalls+0x4f8>
    80006af4:	ffffa097          	auipc	ra,0xffffa
    80006af8:	a96080e7          	jalr	-1386(ra) # 8000058a <printf>
    80006afc:	bfb9                	j	80006a5a <uniq_run+0x5a>
                if (showCount)
    80006afe:	000c0d63          	beqz	s8,80006b18 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
    80006b02:	864a                	mv	a2,s2
    80006b04:	85da                	mv	a1,s6
    80006b06:	00002517          	auipc	a0,0x2
    80006b0a:	e7250513          	addi	a0,a0,-398 # 80008978 <syscalls+0x528>
    80006b0e:	ffffa097          	auipc	ra,0xffffa
    80006b12:	a7c080e7          	jalr	-1412(ra) # 8000058a <printf>
    80006b16:	b791                	j	80006a5a <uniq_run+0x5a>
                  printf("%s",line1);
    80006b18:	85ca                	mv	a1,s2
    80006b1a:	00002517          	auipc	a0,0x2
    80006b1e:	e2e50513          	addi	a0,a0,-466 # 80008948 <syscalls+0x4f8>
    80006b22:	ffffa097          	auipc	ra,0xffffa
    80006b26:	a68080e7          	jalr	-1432(ra) # 8000058a <printf>
    80006b2a:	bf05                	j	80006a5a <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
    80006b2c:	00002517          	auipc	a0,0x2
    80006b30:	e5450513          	addi	a0,a0,-428 # 80008980 <syscalls+0x530>
    80006b34:	ffffa097          	auipc	ra,0xffffa
    80006b38:	a56080e7          	jalr	-1450(ra) # 8000058a <printf>
          break;
    80006b3c:	bf39                	j	80006a5a <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
    80006b3e:	85a6                	mv	a1,s1
    80006b40:	854a                	mv	a0,s2
    80006b42:	00000097          	auipc	ra,0x0
    80006b46:	dda080e7          	jalr	-550(ra) # 8000691c <compare_str_ic>
    80006b4a:	a041                	j	80006bca <uniq_run+0x1ca>
                  printf("%s",line1);
    80006b4c:	85ca                	mv	a1,s2
    80006b4e:	856e                	mv	a0,s11
    80006b50:	ffffa097          	auipc	ra,0xffffa
    80006b54:	a3a080e7          	jalr	-1478(ra) # 8000058a <printf>
        lineCount = 1;
    80006b58:	8b5e                	mv	s6,s7
                  printf("%s",line1);
    80006b5a:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006b5c:	8926                	mv	s2,s1
                  printf("%s",line1);
    80006b5e:	84be                	mv	s1,a5
        isRepeated = 0 ;
    80006b60:	4b81                	li	s7,0
    80006b62:	a099                	j	80006ba8 <uniq_run+0x1a8>
            if (showCount)
    80006b64:	020c0263          	beqz	s8,80006b88 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
    80006b68:	864a                	mv	a2,s2
    80006b6a:	85da                	mv	a1,s6
    80006b6c:	00002517          	auipc	a0,0x2
    80006b70:	e0c50513          	addi	a0,a0,-500 # 80008978 <syscalls+0x528>
    80006b74:	ffffa097          	auipc	ra,0xffffa
    80006b78:	a16080e7          	jalr	-1514(ra) # 8000058a <printf>
    80006b7c:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006b7e:	8926                	mv	s2,s1
    80006b80:	84be                	mv	s1,a5
        isRepeated = 0 ;
    80006b82:	4b81                	li	s7,0
        lineCount = 1;
    80006b84:	8b6a                	mv	s6,s10
    80006b86:	a00d                	j	80006ba8 <uniq_run+0x1a8>
              printf("%s",line1);
    80006b88:	85ca                	mv	a1,s2
    80006b8a:	856e                	mv	a0,s11
    80006b8c:	ffffa097          	auipc	ra,0xffffa
    80006b90:	9fe080e7          	jalr	-1538(ra) # 8000058a <printf>
    80006b94:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006b96:	8926                	mv	s2,s1
              printf("%s",line1);
    80006b98:	84be                	mv	s1,a5
        isRepeated = 0 ;
    80006b9a:	4b81                	li	s7,0
        lineCount = 1;
    80006b9c:	8b6a                	mv	s6,s10
    80006b9e:	a029                	j	80006ba8 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
    80006ba0:	000a0363          	beqz	s4,80006ba6 <uniq_run+0x1a6>
    80006ba4:	8bea                	mv	s7,s10
          lineCount++;
    80006ba6:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
    80006ba8:	85a6                	mv	a1,s1
    80006baa:	854e                	mv	a0,s3
    80006bac:	00000097          	auipc	ra,0x0
    80006bb0:	bce080e7          	jalr	-1074(ra) # 8000677a <read_line>
        if (readStatus == READ_EOF){
    80006bb4:	d911                	beqz	a0,80006ac8 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
    80006bb6:	f7950be3          	beq	a0,s9,80006b2c <uniq_run+0x12c>
        if (!ignoreCase)
    80006bba:	f80a92e3          	bnez	s5,80006b3e <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
    80006bbe:	85a6                	mv	a1,s1
    80006bc0:	854a                	mv	a0,s2
    80006bc2:	00000097          	auipc	ra,0x0
    80006bc6:	d2c080e7          	jalr	-724(ra) # 800068ee <compare_str>
        if (compareStatus != 0){ 
    80006bca:	d979                	beqz	a0,80006ba0 <uniq_run+0x1a0>
          if (repeatedLines){
    80006bcc:	f80a0ce3          	beqz	s4,80006b64 <uniq_run+0x164>
            if (isRepeated){
    80006bd0:	ec0b8be3          	beqz	s7,80006aa6 <uniq_run+0xa6>
                if (showCount)
    80006bd4:	f60c0ce3          	beqz	s8,80006b4c <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
    80006bd8:	864a                	mv	a2,s2
    80006bda:	85da                	mv	a1,s6
    80006bdc:	00002517          	auipc	a0,0x2
    80006be0:	d9c50513          	addi	a0,a0,-612 # 80008978 <syscalls+0x528>
    80006be4:	ffffa097          	auipc	ra,0xffffa
    80006be8:	9a6080e7          	jalr	-1626(ra) # 8000058a <printf>
        lineCount = 1;
    80006bec:	8b5e                	mv	s6,s7
    80006bee:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006bf0:	8926                	mv	s2,s1
    80006bf2:	84be                	mv	s1,a5
        isRepeated = 0 ;
    80006bf4:	4b81                	li	s7,0
    80006bf6:	bf4d                	j	80006ba8 <uniq_run+0x1a8>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
