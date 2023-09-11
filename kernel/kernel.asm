
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	97013103          	ld	sp,-1680(sp) # 80008970 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000054:	98070713          	addi	a4,a4,-1664 # 800089d0 <timer_scratch>
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
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc9bf>
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
    8000018e:	98650513          	addi	a0,a0,-1658 # 80010b10 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a44080e7          	jalr	-1468(ra) # 80000bd6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	97648493          	addi	s1,s1,-1674 # 80010b10 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	a0690913          	addi	s2,s2,-1530 # 80010ba8 <cons+0x98>
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
    8000022a:	8ea50513          	addi	a0,a0,-1814 # 80010b10 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	a5c080e7          	jalr	-1444(ra) # 80000c8a <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	8d450513          	addi	a0,a0,-1836 # 80010b10 <cons>
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
    80000276:	92f72b23          	sw	a5,-1738(a4) # 80010ba8 <cons+0x98>
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
    800002d0:	84450513          	addi	a0,a0,-1980 # 80010b10 <cons>
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
    800002fe:	81650513          	addi	a0,a0,-2026 # 80010b10 <cons>
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
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	7f270713          	addi	a4,a4,2034 # 80010b10 <cons>
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
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	7c878793          	addi	a5,a5,1992 # 80010b10 <cons>
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
    8000037a:	8327a783          	lw	a5,-1998(a5) # 80010ba8 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	78670713          	addi	a4,a4,1926 # 80010b10 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	77648493          	addi	s1,s1,1910 # 80010b10 <cons>
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
    800003da:	73a70713          	addi	a4,a4,1850 # 80010b10 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	7cf72223          	sw	a5,1988(a4) # 80010bb0 <cons+0xa0>
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
    80000416:	6fe78793          	addi	a5,a5,1790 # 80010b10 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	76c7ab23          	sw	a2,1910(a5) # 80010bac <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	76a50513          	addi	a0,a0,1898 # 80010ba8 <cons+0x98>
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
    80000464:	6b050513          	addi	a0,a0,1712 # 80010b10 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	6de080e7          	jalr	1758(ra) # 80000b46 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32c080e7          	jalr	812(ra) # 8000079c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00021797          	auipc	a5,0x21
    8000047c:	83078793          	addi	a5,a5,-2000 # 80020ca8 <devsw>
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
    80000550:	6807a223          	sw	zero,1668(a5) # 80010bd0 <pr+0x18>
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
    80000584:	40f72823          	sw	a5,1040(a4) # 80008990 <panicked>
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
    800005c0:	614dad83          	lw	s11,1556(s11) # 80010bd0 <pr+0x18>
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
    800005fe:	5be50513          	addi	a0,a0,1470 # 80010bb8 <pr>
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
    8000075c:	46050513          	addi	a0,a0,1120 # 80010bb8 <pr>
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
    80000778:	44448493          	addi	s1,s1,1092 # 80010bb8 <pr>
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
    800007d8:	40450513          	addi	a0,a0,1028 # 80010bd8 <uart_tx_lock>
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
    80000804:	1907a783          	lw	a5,400(a5) # 80008990 <panicked>
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
    8000083c:	1607b783          	ld	a5,352(a5) # 80008998 <uart_tx_r>
    80000840:	00008717          	auipc	a4,0x8
    80000844:	16073703          	ld	a4,352(a4) # 800089a0 <uart_tx_w>
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
    80000866:	376a0a13          	addi	s4,s4,886 # 80010bd8 <uart_tx_lock>
    uart_tx_r += 1;
    8000086a:	00008497          	auipc	s1,0x8
    8000086e:	12e48493          	addi	s1,s1,302 # 80008998 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000872:	00008997          	auipc	s3,0x8
    80000876:	12e98993          	addi	s3,s3,302 # 800089a0 <uart_tx_w>
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
    800008d4:	30850513          	addi	a0,a0,776 # 80010bd8 <uart_tx_lock>
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	2fe080e7          	jalr	766(ra) # 80000bd6 <acquire>
  if(panicked){
    800008e0:	00008797          	auipc	a5,0x8
    800008e4:	0b07a783          	lw	a5,176(a5) # 80008990 <panicked>
    800008e8:	e7c9                	bnez	a5,80000972 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008ea:	00008717          	auipc	a4,0x8
    800008ee:	0b673703          	ld	a4,182(a4) # 800089a0 <uart_tx_w>
    800008f2:	00008797          	auipc	a5,0x8
    800008f6:	0a67b783          	ld	a5,166(a5) # 80008998 <uart_tx_r>
    800008fa:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fe:	00010997          	auipc	s3,0x10
    80000902:	2da98993          	addi	s3,s3,730 # 80010bd8 <uart_tx_lock>
    80000906:	00008497          	auipc	s1,0x8
    8000090a:	09248493          	addi	s1,s1,146 # 80008998 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090e:	00008917          	auipc	s2,0x8
    80000912:	09290913          	addi	s2,s2,146 # 800089a0 <uart_tx_w>
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
    80000938:	2a448493          	addi	s1,s1,676 # 80010bd8 <uart_tx_lock>
    8000093c:	01f77793          	andi	a5,a4,31
    80000940:	97a6                	add	a5,a5,s1
    80000942:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000946:	0705                	addi	a4,a4,1
    80000948:	00008797          	auipc	a5,0x8
    8000094c:	04e7bc23          	sd	a4,88(a5) # 800089a0 <uart_tx_w>
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
    800009be:	21e48493          	addi	s1,s1,542 # 80010bd8 <uart_tx_lock>
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
    80000a00:	44478793          	addi	a5,a5,1092 # 80021e40 <end>
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
    80000a20:	1f490913          	addi	s2,s2,500 # 80010c10 <kmem>
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
    80000abe:	15650513          	addi	a0,a0,342 # 80010c10 <kmem>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	084080e7          	jalr	132(ra) # 80000b46 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000aca:	45c5                	li	a1,17
    80000acc:	05ee                	slli	a1,a1,0x1b
    80000ace:	00021517          	auipc	a0,0x21
    80000ad2:	37250513          	addi	a0,a0,882 # 80021e40 <end>
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
    80000af4:	12048493          	addi	s1,s1,288 # 80010c10 <kmem>
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
    80000b0c:	10850513          	addi	a0,a0,264 # 80010c10 <kmem>
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
    80000b38:	0dc50513          	addi	a0,a0,220 # 80010c10 <kmem>
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
    80000d46:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd1c1>
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
    80000e8c:	b2070713          	addi	a4,a4,-1248 # 800089a8 <started>
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
    80000f5a:	fca080e7          	jalr	-54(ra) # 80002f20 <binit>
    iinit();         // inode table
    80000f5e:	00002097          	auipc	ra,0x2
    80000f62:	66a080e7          	jalr	1642(ra) # 800035c8 <iinit>
    fileinit();      // file table
    80000f66:	00003097          	auipc	ra,0x3
    80000f6a:	610080e7          	jalr	1552(ra) # 80004576 <fileinit>
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
    80000f88:	a2f72223          	sw	a5,-1500(a4) # 800089a8 <started>
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
    80000f9c:	a187b783          	ld	a5,-1512(a5) # 800089b0 <kernel_pagetable>
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
    80001016:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd1b7>
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
    80001258:	74a7be23          	sd	a0,1884(a5) # 800089b0 <kernel_pagetable>
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
    8000180c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd1c0>
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
    80001850:	81448493          	addi	s1,s1,-2028 # 80011060 <proc>
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
    8000186a:	1faa0a13          	addi	s4,s4,506 # 80016a60 <tickslock>
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
    800018ec:	34850513          	addi	a0,a0,840 # 80010c30 <pid_lock>
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	256080e7          	jalr	598(ra) # 80000b46 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018f8:	00007597          	auipc	a1,0x7
    800018fc:	8f058593          	addi	a1,a1,-1808 # 800081e8 <digits+0x1a8>
    80001900:	0000f517          	auipc	a0,0xf
    80001904:	34850513          	addi	a0,a0,840 # 80010c48 <wait_lock>
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	23e080e7          	jalr	574(ra) # 80000b46 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001910:	0000f497          	auipc	s1,0xf
    80001914:	75048493          	addi	s1,s1,1872 # 80011060 <proc>
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
    80001936:	12e98993          	addi	s3,s3,302 # 80016a60 <tickslock>
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
    800019a0:	2c450513          	addi	a0,a0,708 # 80010c60 <cpus>
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
    800019c8:	26c70713          	addi	a4,a4,620 # 80010c30 <pid_lock>
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
    80001a00:	f247a783          	lw	a5,-220(a5) # 80008920 <first.1>
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
    80001a1a:	f007a523          	sw	zero,-246(a5) # 80008920 <first.1>
    fsinit(ROOTDEV);
    80001a1e:	4505                	li	a0,1
    80001a20:	00002097          	auipc	ra,0x2
    80001a24:	b28080e7          	jalr	-1240(ra) # 80003548 <fsinit>
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
    80001a3a:	1fa90913          	addi	s2,s2,506 # 80010c30 <pid_lock>
    80001a3e:	854a                	mv	a0,s2
    80001a40:	fffff097          	auipc	ra,0xfffff
    80001a44:	196080e7          	jalr	406(ra) # 80000bd6 <acquire>
  pid = nextpid;
    80001a48:	00007797          	auipc	a5,0x7
    80001a4c:	edc78793          	addi	a5,a5,-292 # 80008924 <nextpid>
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
    80001bc6:	49e48493          	addi	s1,s1,1182 # 80011060 <proc>
    80001bca:	00015917          	auipc	s2,0x15
    80001bce:	e9690913          	addi	s2,s2,-362 # 80016a60 <tickslock>
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
    80001c9c:	d2a7b023          	sd	a0,-736(a5) # 800089b8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001ca0:	03400613          	li	a2,52
    80001ca4:	00007597          	auipc	a1,0x7
    80001ca8:	c8c58593          	addi	a1,a1,-884 # 80008930 <initcode>
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
    80001ce6:	290080e7          	jalr	656(ra) # 80003f72 <namei>
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
    80001e12:	00002097          	auipc	ra,0x2
    80001e16:	7f6080e7          	jalr	2038(ra) # 80004608 <filedup>
    80001e1a:	00a93023          	sd	a0,0(s2)
    80001e1e:	b7e5                	j	80001e06 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e20:	150ab503          	ld	a0,336(s5)
    80001e24:	00002097          	auipc	ra,0x2
    80001e28:	964080e7          	jalr	-1692(ra) # 80003788 <idup>
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
    80001e54:	df848493          	addi	s1,s1,-520 # 80010c48 <wait_lock>
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
    80001ec2:	d7270713          	addi	a4,a4,-654 # 80010c30 <pid_lock>
    80001ec6:	9756                	add	a4,a4,s5
    80001ec8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001ecc:	0000f717          	auipc	a4,0xf
    80001ed0:	d9c70713          	addi	a4,a4,-612 # 80010c68 <cpus+0x8>
    80001ed4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001ed6:	498d                	li	s3,3
        p->state = RUNNING;
    80001ed8:	4b11                	li	s6,4
        c->proc = p;
    80001eda:	079e                	slli	a5,a5,0x7
    80001edc:	0000fa17          	auipc	s4,0xf
    80001ee0:	d54a0a13          	addi	s4,s4,-684 # 80010c30 <pid_lock>
    80001ee4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ee6:	00015917          	auipc	s2,0x15
    80001eea:	b7a90913          	addi	s2,s2,-1158 # 80016a60 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ef2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ef6:	10079073          	csrw	sstatus,a5
    80001efa:	0000f497          	auipc	s1,0xf
    80001efe:	16648493          	addi	s1,s1,358 # 80011060 <proc>
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
    80001f6e:	cc670713          	addi	a4,a4,-826 # 80010c30 <pid_lock>
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
    80001f94:	ca090913          	addi	s2,s2,-864 # 80010c30 <pid_lock>
    80001f98:	2781                	sext.w	a5,a5
    80001f9a:	079e                	slli	a5,a5,0x7
    80001f9c:	97ca                	add	a5,a5,s2
    80001f9e:	0ac7a983          	lw	s3,172(a5)
    80001fa2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001fa4:	2781                	sext.w	a5,a5
    80001fa6:	079e                	slli	a5,a5,0x7
    80001fa8:	0000f597          	auipc	a1,0xf
    80001fac:	cc058593          	addi	a1,a1,-832 # 80010c68 <cpus+0x8>
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
    800020d0:	f9448493          	addi	s1,s1,-108 # 80011060 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800020d4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800020d6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800020d8:	00015917          	auipc	s2,0x15
    800020dc:	98890913          	addi	s2,s2,-1656 # 80016a60 <tickslock>
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
    80002144:	f2048493          	addi	s1,s1,-224 # 80011060 <proc>
      pp->parent = initproc;
    80002148:	00007a17          	auipc	s4,0x7
    8000214c:	870a0a13          	addi	s4,s4,-1936 # 800089b8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002150:	00015997          	auipc	s3,0x15
    80002154:	91098993          	addi	s3,s3,-1776 # 80016a60 <tickslock>
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
    800021a8:	8147b783          	ld	a5,-2028(a5) # 800089b8 <initproc>
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
    800021cc:	492080e7          	jalr	1170(ra) # 8000465a <fileclose>
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
    800021e4:	fb2080e7          	jalr	-78(ra) # 80004192 <begin_op>
  iput(p->cwd);
    800021e8:	1509b503          	ld	a0,336(s3)
    800021ec:	00001097          	auipc	ra,0x1
    800021f0:	794080e7          	jalr	1940(ra) # 80003980 <iput>
  end_op();
    800021f4:	00002097          	auipc	ra,0x2
    800021f8:	01c080e7          	jalr	28(ra) # 80004210 <end_op>
  p->cwd = 0;
    800021fc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002200:	0000f497          	auipc	s1,0xf
    80002204:	a4848493          	addi	s1,s1,-1464 # 80010c48 <wait_lock>
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
    80002272:	df248493          	addi	s1,s1,-526 # 80011060 <proc>
    80002276:	00014997          	auipc	s3,0x14
    8000227a:	7ea98993          	addi	s3,s3,2026 # 80016a60 <tickslock>
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
    80002356:	8f650513          	addi	a0,a0,-1802 # 80010c48 <wait_lock>
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
    8000236c:	6f898993          	addi	s3,s3,1784 # 80016a60 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002370:	0000fc17          	auipc	s8,0xf
    80002374:	8d8c0c13          	addi	s8,s8,-1832 # 80010c48 <wait_lock>
    havekids = 0;
    80002378:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000237a:	0000f497          	auipc	s1,0xf
    8000237e:	ce648493          	addi	s1,s1,-794 # 80011060 <proc>
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
    800023bc:	89050513          	addi	a0,a0,-1904 # 80010c48 <wait_lock>
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
    800023d8:	87450513          	addi	a0,a0,-1932 # 80010c48 <wait_lock>
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
    80002426:	82650513          	addi	a0,a0,-2010 # 80010c48 <wait_lock>
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
    80002532:	c8a48493          	addi	s1,s1,-886 # 800111b8 <proc+0x158>
    80002536:	00014917          	auipc	s2,0x14
    8000253a:	68290913          	addi	s2,s2,1666 # 80016bb8 <bcache+0x140>
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
    80002636:	42e50513          	addi	a0,a0,1070 # 80016a60 <tickslock>
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
    80002706:	35e48493          	addi	s1,s1,862 # 80016a60 <tickslock>
    8000270a:	8526                	mv	a0,s1
    8000270c:	ffffe097          	auipc	ra,0xffffe
    80002710:	4ca080e7          	jalr	1226(ra) # 80000bd6 <acquire>
  ticks++;
    80002714:	00006517          	auipc	a0,0x6
    80002718:	2ac50513          	addi	a0,a0,684 # 800089c0 <ticks>
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
    80002ba6:	7175                	addi	sp,sp,-144
    80002ba8:	e506                	sd	ra,136(sp)
    80002baa:	e122                	sd	s0,128(sp)
    80002bac:	0900                	addi	s0,sp,144

  printf("Head command is getting executed in kernel mode\n");
    80002bae:	00006517          	auipc	a0,0x6
    80002bb2:	96250513          	addi	a0,a0,-1694 # 80008510 <syscalls+0xc0>
    80002bb6:	ffffe097          	auipc	ra,0xffffe
    80002bba:	9d4080e7          	jalr	-1580(ra) # 8000058a <printf>

  uint64 passedFiles;
  uint64 lineCount;

  /* Fetching the first and the second arguments */
  argaddr(0, &passedFiles);
    80002bbe:	fe840593          	addi	a1,s0,-24
    80002bc2:	4501                	li	a0,0
    80002bc4:	00000097          	auipc	ra,0x0
    80002bc8:	f1e080e7          	jalr	-226(ra) # 80002ae2 <argaddr>
  argint(1, &lineCount);
    80002bcc:	fe040593          	addi	a1,s0,-32
    80002bd0:	4505                	li	a0,1
    80002bd2:	00000097          	auipc	ra,0x0
    80002bd6:	ef0080e7          	jalr	-272(ra) # 80002ac2 <argint>


  uint64 fileAddr;

  fetchaddr(passedFiles, &fileAddr);
    80002bda:	fd840593          	addi	a1,s0,-40
    80002bde:	fe843503          	ld	a0,-24(s0)
    80002be2:	00000097          	auipc	ra,0x0
    80002be6:	e42080e7          	jalr	-446(ra) # 80002a24 <fetchaddr>

  /* Reading from STDIN */
  if(!fileAddr){
    80002bea:	fd843583          	ld	a1,-40(s0)
    80002bee:	e58d                	bnez	a1,80002c18 <sys_head+0x72>
    head_run(0, lineCount);
    80002bf0:	fe042583          	lw	a1,-32(s0)
    80002bf4:	4501                	li	a0,0
    80002bf6:	00003097          	auipc	ra,0x3
    80002bfa:	0b0080e7          	jalr	176(ra) # 80005ca6 <head_run>
    printf("Reading from stdin");
    80002bfe:	00006517          	auipc	a0,0x6
    80002c02:	94a50513          	addi	a0,a0,-1718 # 80008548 <syscalls+0xf8>
    80002c06:	ffffe097          	auipc	ra,0xffffe
    80002c0a:	984080e7          	jalr	-1660(ra) # 8000058a <printf>
  // hh(path);


  // printf("%s",((char **)p)[0] );
  return 0;
}
    80002c0e:	4501                	li	a0,0
    80002c10:	60aa                	ld	ra,136(sp)
    80002c12:	640a                	ld	s0,128(sp)
    80002c14:	6149                	addi	sp,sp,144
    80002c16:	8082                	ret
    printf("here %x\n",fileAddr);
    80002c18:	00006517          	auipc	a0,0x6
    80002c1c:	94850513          	addi	a0,a0,-1720 # 80008560 <syscalls+0x110>
    80002c20:	ffffe097          	auipc	ra,0xffffe
    80002c24:	96a080e7          	jalr	-1686(ra) # 8000058a <printf>
    while(fileAddr){
    80002c28:	fd843503          	ld	a0,-40(s0)
    80002c2c:	d16d                	beqz	a0,80002c0e <sys_head+0x68>
      fetchstr(fileAddr, fileName, 100);
    80002c2e:	06400613          	li	a2,100
    80002c32:	f7040593          	addi	a1,s0,-144
    80002c36:	00000097          	auipc	ra,0x0
    80002c3a:	e40080e7          	jalr	-448(ra) # 80002a76 <fetchstr>
      int fd = open_file(fileName, 0);
    80002c3e:	4581                	li	a1,0
    80002c40:	f7040513          	addi	a0,s0,-144
    80002c44:	00004097          	auipc	ra,0x4
    80002c48:	8e4080e7          	jalr	-1820(ra) # 80006528 <open_file>
      head_run(fd, lineCount);
    80002c4c:	fe042583          	lw	a1,-32(s0)
    80002c50:	00003097          	auipc	ra,0x3
    80002c54:	056080e7          	jalr	86(ra) # 80005ca6 <head_run>
      passedFiles+=8;
    80002c58:	fe843503          	ld	a0,-24(s0)
    80002c5c:	0521                	addi	a0,a0,8
    80002c5e:	fea43423          	sd	a0,-24(s0)
      fetchaddr(passedFiles, &fileAddr);
    80002c62:	fd840593          	addi	a1,s0,-40
    80002c66:	00000097          	auipc	ra,0x0
    80002c6a:	dbe080e7          	jalr	-578(ra) # 80002a24 <fetchaddr>
    while(fileAddr){
    80002c6e:	fd843503          	ld	a0,-40(s0)
    80002c72:	fd55                	bnez	a0,80002c2e <sys_head+0x88>
    80002c74:	bf69                	j	80002c0e <sys_head+0x68>

0000000080002c76 <sys_uniq>:
#define OPT_IGNORE_CASE 1
#define OPT_SHOW_COUNT 2
#define OPT_SHOW_REPEATED_LINES 4


uint64 sys_uniq(void){
    80002c76:	7175                	addi	sp,sp,-144
    80002c78:	e506                	sd	ra,136(sp)
    80002c7a:	e122                	sd	s0,128(sp)
    80002c7c:	0900                	addi	s0,sp,144

  printf("Uniq command is getting executed in kernel mode\n");
    80002c7e:	00006517          	auipc	a0,0x6
    80002c82:	8f250513          	addi	a0,a0,-1806 # 80008570 <syscalls+0x120>
    80002c86:	ffffe097          	auipc	ra,0xffffe
    80002c8a:	904080e7          	jalr	-1788(ra) # 8000058a <printf>

  uint64 passedFiles;
  uint64 options;

  /* Fetching the first and the second arguments */
  argaddr(0, &passedFiles);
    80002c8e:	fe840593          	addi	a1,s0,-24
    80002c92:	4501                	li	a0,0
    80002c94:	00000097          	auipc	ra,0x0
    80002c98:	e4e080e7          	jalr	-434(ra) # 80002ae2 <argaddr>
  argint(1, &options);
    80002c9c:	fe040593          	addi	a1,s0,-32
    80002ca0:	4505                	li	a0,1
    80002ca2:	00000097          	auipc	ra,0x0
    80002ca6:	e20080e7          	jalr	-480(ra) # 80002ac2 <argint>

  printf("%d\n",options);
    80002caa:	fe043583          	ld	a1,-32(s0)
    80002cae:	00005517          	auipc	a0,0x5
    80002cb2:	78250513          	addi	a0,a0,1922 # 80008430 <states.0+0x168>
    80002cb6:	ffffe097          	auipc	ra,0xffffe
    80002cba:	8d4080e7          	jalr	-1836(ra) # 8000058a <printf>

  uint64 fileAddr;

  fetchaddr(passedFiles, &fileAddr);
    80002cbe:	fd840593          	addi	a1,s0,-40
    80002cc2:	fe843503          	ld	a0,-24(s0)
    80002cc6:	00000097          	auipc	ra,0x0
    80002cca:	d5e080e7          	jalr	-674(ra) # 80002a24 <fetchaddr>

  /* Reading from STDIN */
  if(!fileAddr){
    80002cce:	fd843503          	ld	a0,-40(s0)
    80002cd2:	cd31                	beqz	a0,80002d2e <sys_uniq+0xb8>

    
    while(fileAddr){

      char fileName[100];
      fetchstr(fileAddr, fileName, 100);
    80002cd4:	06400613          	li	a2,100
    80002cd8:	f7040593          	addi	a1,s0,-144
    80002cdc:	00000097          	auipc	ra,0x0
    80002ce0:	d9a080e7          	jalr	-614(ra) # 80002a76 <fetchstr>

      // Open the given file
      // struct file * f;
      // printf("%s\n",fileName);
      int fd = open_file(fileName, 0);
    80002ce4:	4581                	li	a1,0
    80002ce6:	f7040513          	addi	a0,s0,-144
    80002cea:	00004097          	auipc	ra,0x4
    80002cee:	83e080e7          	jalr	-1986(ra) # 80006528 <open_file>

      uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
    80002cf2:	fe044583          	lbu	a1,-32(s0)
    80002cf6:	0045f693          	andi	a3,a1,4
    80002cfa:	0025f613          	andi	a2,a1,2
    80002cfe:	8985                	andi	a1,a1,1
    80002d00:	00003097          	auipc	ra,0x3
    80002d04:	038080e7          	jalr	56(ra) # 80005d38 <uniq_run>


      // printf("%d\n",fd);

      // Fetching the next file name
      passedFiles+=8;
    80002d08:	fe843503          	ld	a0,-24(s0)
    80002d0c:	0521                	addi	a0,a0,8
    80002d0e:	fea43423          	sd	a0,-24(s0)
      fetchaddr(passedFiles, &fileAddr);
    80002d12:	fd840593          	addi	a1,s0,-40
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	d0e080e7          	jalr	-754(ra) # 80002a24 <fetchaddr>
    while(fileAddr){
    80002d1e:	fd843503          	ld	a0,-40(s0)
    80002d22:	f94d                	bnez	a0,80002cd4 <sys_uniq+0x5e>
  // hh(path);


  // printf("%s",((char **)p)[0] );
  return 0;
}
    80002d24:	4501                	li	a0,0
    80002d26:	60aa                	ld	ra,136(sp)
    80002d28:	640a                	ld	s0,128(sp)
    80002d2a:	6149                	addi	sp,sp,144
    80002d2c:	8082                	ret
    printf("Reading from stdin");
    80002d2e:	00006517          	auipc	a0,0x6
    80002d32:	81a50513          	addi	a0,a0,-2022 # 80008548 <syscalls+0xf8>
    80002d36:	ffffe097          	auipc	ra,0xffffe
    80002d3a:	854080e7          	jalr	-1964(ra) # 8000058a <printf>
    80002d3e:	b7dd                	j	80002d24 <sys_uniq+0xae>

0000000080002d40 <sys_exit>:



uint64
sys_exit(void)
{
    80002d40:	1101                	addi	sp,sp,-32
    80002d42:	ec06                	sd	ra,24(sp)
    80002d44:	e822                	sd	s0,16(sp)
    80002d46:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002d48:	fec40593          	addi	a1,s0,-20
    80002d4c:	4501                	li	a0,0
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	d74080e7          	jalr	-652(ra) # 80002ac2 <argint>
  exit(n);
    80002d56:	fec42503          	lw	a0,-20(s0)
    80002d5a:	fffff097          	auipc	ra,0xfffff
    80002d5e:	42e080e7          	jalr	1070(ra) # 80002188 <exit>
  return 0;  // not reached
}
    80002d62:	4501                	li	a0,0
    80002d64:	60e2                	ld	ra,24(sp)
    80002d66:	6442                	ld	s0,16(sp)
    80002d68:	6105                	addi	sp,sp,32
    80002d6a:	8082                	ret

0000000080002d6c <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d6c:	1141                	addi	sp,sp,-16
    80002d6e:	e406                	sd	ra,8(sp)
    80002d70:	e022                	sd	s0,0(sp)
    80002d72:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002d74:	fffff097          	auipc	ra,0xfffff
    80002d78:	c38080e7          	jalr	-968(ra) # 800019ac <myproc>
}
    80002d7c:	5908                	lw	a0,48(a0)
    80002d7e:	60a2                	ld	ra,8(sp)
    80002d80:	6402                	ld	s0,0(sp)
    80002d82:	0141                	addi	sp,sp,16
    80002d84:	8082                	ret

0000000080002d86 <sys_fork>:

uint64
sys_fork(void)
{
    80002d86:	1141                	addi	sp,sp,-16
    80002d88:	e406                	sd	ra,8(sp)
    80002d8a:	e022                	sd	s0,0(sp)
    80002d8c:	0800                	addi	s0,sp,16
  return fork();
    80002d8e:	fffff097          	auipc	ra,0xfffff
    80002d92:	fd4080e7          	jalr	-44(ra) # 80001d62 <fork>
}
    80002d96:	60a2                	ld	ra,8(sp)
    80002d98:	6402                	ld	s0,0(sp)
    80002d9a:	0141                	addi	sp,sp,16
    80002d9c:	8082                	ret

0000000080002d9e <sys_wait>:

uint64
sys_wait(void)
{
    80002d9e:	1101                	addi	sp,sp,-32
    80002da0:	ec06                	sd	ra,24(sp)
    80002da2:	e822                	sd	s0,16(sp)
    80002da4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002da6:	fe840593          	addi	a1,s0,-24
    80002daa:	4501                	li	a0,0
    80002dac:	00000097          	auipc	ra,0x0
    80002db0:	d36080e7          	jalr	-714(ra) # 80002ae2 <argaddr>
  return wait(p);
    80002db4:	fe843503          	ld	a0,-24(s0)
    80002db8:	fffff097          	auipc	ra,0xfffff
    80002dbc:	576080e7          	jalr	1398(ra) # 8000232e <wait>
}
    80002dc0:	60e2                	ld	ra,24(sp)
    80002dc2:	6442                	ld	s0,16(sp)
    80002dc4:	6105                	addi	sp,sp,32
    80002dc6:	8082                	ret

0000000080002dc8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002dc8:	7179                	addi	sp,sp,-48
    80002dca:	f406                	sd	ra,40(sp)
    80002dcc:	f022                	sd	s0,32(sp)
    80002dce:	ec26                	sd	s1,24(sp)
    80002dd0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002dd2:	fdc40593          	addi	a1,s0,-36
    80002dd6:	4501                	li	a0,0
    80002dd8:	00000097          	auipc	ra,0x0
    80002ddc:	cea080e7          	jalr	-790(ra) # 80002ac2 <argint>
  addr = myproc()->sz;
    80002de0:	fffff097          	auipc	ra,0xfffff
    80002de4:	bcc080e7          	jalr	-1076(ra) # 800019ac <myproc>
    80002de8:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002dea:	fdc42503          	lw	a0,-36(s0)
    80002dee:	fffff097          	auipc	ra,0xfffff
    80002df2:	f18080e7          	jalr	-232(ra) # 80001d06 <growproc>
    80002df6:	00054863          	bltz	a0,80002e06 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002dfa:	8526                	mv	a0,s1
    80002dfc:	70a2                	ld	ra,40(sp)
    80002dfe:	7402                	ld	s0,32(sp)
    80002e00:	64e2                	ld	s1,24(sp)
    80002e02:	6145                	addi	sp,sp,48
    80002e04:	8082                	ret
    return -1;
    80002e06:	54fd                	li	s1,-1
    80002e08:	bfcd                	j	80002dfa <sys_sbrk+0x32>

0000000080002e0a <sys_sleep>:

uint64
sys_sleep(void)
{
    80002e0a:	7139                	addi	sp,sp,-64
    80002e0c:	fc06                	sd	ra,56(sp)
    80002e0e:	f822                	sd	s0,48(sp)
    80002e10:	f426                	sd	s1,40(sp)
    80002e12:	f04a                	sd	s2,32(sp)
    80002e14:	ec4e                	sd	s3,24(sp)
    80002e16:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002e18:	fcc40593          	addi	a1,s0,-52
    80002e1c:	4501                	li	a0,0
    80002e1e:	00000097          	auipc	ra,0x0
    80002e22:	ca4080e7          	jalr	-860(ra) # 80002ac2 <argint>
  acquire(&tickslock);
    80002e26:	00014517          	auipc	a0,0x14
    80002e2a:	c3a50513          	addi	a0,a0,-966 # 80016a60 <tickslock>
    80002e2e:	ffffe097          	auipc	ra,0xffffe
    80002e32:	da8080e7          	jalr	-600(ra) # 80000bd6 <acquire>
  ticks0 = ticks;
    80002e36:	00006917          	auipc	s2,0x6
    80002e3a:	b8a92903          	lw	s2,-1142(s2) # 800089c0 <ticks>
  while(ticks - ticks0 < n){
    80002e3e:	fcc42783          	lw	a5,-52(s0)
    80002e42:	cf9d                	beqz	a5,80002e80 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002e44:	00014997          	auipc	s3,0x14
    80002e48:	c1c98993          	addi	s3,s3,-996 # 80016a60 <tickslock>
    80002e4c:	00006497          	auipc	s1,0x6
    80002e50:	b7448493          	addi	s1,s1,-1164 # 800089c0 <ticks>
    if(killed(myproc())){
    80002e54:	fffff097          	auipc	ra,0xfffff
    80002e58:	b58080e7          	jalr	-1192(ra) # 800019ac <myproc>
    80002e5c:	fffff097          	auipc	ra,0xfffff
    80002e60:	4a0080e7          	jalr	1184(ra) # 800022fc <killed>
    80002e64:	ed15                	bnez	a0,80002ea0 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002e66:	85ce                	mv	a1,s3
    80002e68:	8526                	mv	a0,s1
    80002e6a:	fffff097          	auipc	ra,0xfffff
    80002e6e:	1ea080e7          	jalr	490(ra) # 80002054 <sleep>
  while(ticks - ticks0 < n){
    80002e72:	409c                	lw	a5,0(s1)
    80002e74:	412787bb          	subw	a5,a5,s2
    80002e78:	fcc42703          	lw	a4,-52(s0)
    80002e7c:	fce7ece3          	bltu	a5,a4,80002e54 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002e80:	00014517          	auipc	a0,0x14
    80002e84:	be050513          	addi	a0,a0,-1056 # 80016a60 <tickslock>
    80002e88:	ffffe097          	auipc	ra,0xffffe
    80002e8c:	e02080e7          	jalr	-510(ra) # 80000c8a <release>
  return 0;
    80002e90:	4501                	li	a0,0
}
    80002e92:	70e2                	ld	ra,56(sp)
    80002e94:	7442                	ld	s0,48(sp)
    80002e96:	74a2                	ld	s1,40(sp)
    80002e98:	7902                	ld	s2,32(sp)
    80002e9a:	69e2                	ld	s3,24(sp)
    80002e9c:	6121                	addi	sp,sp,64
    80002e9e:	8082                	ret
      release(&tickslock);
    80002ea0:	00014517          	auipc	a0,0x14
    80002ea4:	bc050513          	addi	a0,a0,-1088 # 80016a60 <tickslock>
    80002ea8:	ffffe097          	auipc	ra,0xffffe
    80002eac:	de2080e7          	jalr	-542(ra) # 80000c8a <release>
      return -1;
    80002eb0:	557d                	li	a0,-1
    80002eb2:	b7c5                	j	80002e92 <sys_sleep+0x88>

0000000080002eb4 <sys_kill>:

uint64
sys_kill(void)
{
    80002eb4:	1101                	addi	sp,sp,-32
    80002eb6:	ec06                	sd	ra,24(sp)
    80002eb8:	e822                	sd	s0,16(sp)
    80002eba:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002ebc:	fec40593          	addi	a1,s0,-20
    80002ec0:	4501                	li	a0,0
    80002ec2:	00000097          	auipc	ra,0x0
    80002ec6:	c00080e7          	jalr	-1024(ra) # 80002ac2 <argint>
  return kill(pid);
    80002eca:	fec42503          	lw	a0,-20(s0)
    80002ece:	fffff097          	auipc	ra,0xfffff
    80002ed2:	390080e7          	jalr	912(ra) # 8000225e <kill>
}
    80002ed6:	60e2                	ld	ra,24(sp)
    80002ed8:	6442                	ld	s0,16(sp)
    80002eda:	6105                	addi	sp,sp,32
    80002edc:	8082                	ret

0000000080002ede <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ede:	1101                	addi	sp,sp,-32
    80002ee0:	ec06                	sd	ra,24(sp)
    80002ee2:	e822                	sd	s0,16(sp)
    80002ee4:	e426                	sd	s1,8(sp)
    80002ee6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ee8:	00014517          	auipc	a0,0x14
    80002eec:	b7850513          	addi	a0,a0,-1160 # 80016a60 <tickslock>
    80002ef0:	ffffe097          	auipc	ra,0xffffe
    80002ef4:	ce6080e7          	jalr	-794(ra) # 80000bd6 <acquire>
  xticks = ticks;
    80002ef8:	00006497          	auipc	s1,0x6
    80002efc:	ac84a483          	lw	s1,-1336(s1) # 800089c0 <ticks>
  release(&tickslock);
    80002f00:	00014517          	auipc	a0,0x14
    80002f04:	b6050513          	addi	a0,a0,-1184 # 80016a60 <tickslock>
    80002f08:	ffffe097          	auipc	ra,0xffffe
    80002f0c:	d82080e7          	jalr	-638(ra) # 80000c8a <release>
  return xticks;
}
    80002f10:	02049513          	slli	a0,s1,0x20
    80002f14:	9101                	srli	a0,a0,0x20
    80002f16:	60e2                	ld	ra,24(sp)
    80002f18:	6442                	ld	s0,16(sp)
    80002f1a:	64a2                	ld	s1,8(sp)
    80002f1c:	6105                	addi	sp,sp,32
    80002f1e:	8082                	ret

0000000080002f20 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002f20:	7179                	addi	sp,sp,-48
    80002f22:	f406                	sd	ra,40(sp)
    80002f24:	f022                	sd	s0,32(sp)
    80002f26:	ec26                	sd	s1,24(sp)
    80002f28:	e84a                	sd	s2,16(sp)
    80002f2a:	e44e                	sd	s3,8(sp)
    80002f2c:	e052                	sd	s4,0(sp)
    80002f2e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002f30:	00005597          	auipc	a1,0x5
    80002f34:	67858593          	addi	a1,a1,1656 # 800085a8 <syscalls+0x158>
    80002f38:	00014517          	auipc	a0,0x14
    80002f3c:	b4050513          	addi	a0,a0,-1216 # 80016a78 <bcache>
    80002f40:	ffffe097          	auipc	ra,0xffffe
    80002f44:	c06080e7          	jalr	-1018(ra) # 80000b46 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002f48:	0001c797          	auipc	a5,0x1c
    80002f4c:	b3078793          	addi	a5,a5,-1232 # 8001ea78 <bcache+0x8000>
    80002f50:	0001c717          	auipc	a4,0x1c
    80002f54:	d9070713          	addi	a4,a4,-624 # 8001ece0 <bcache+0x8268>
    80002f58:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002f5c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f60:	00014497          	auipc	s1,0x14
    80002f64:	b3048493          	addi	s1,s1,-1232 # 80016a90 <bcache+0x18>
    b->next = bcache.head.next;
    80002f68:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002f6a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002f6c:	00005a17          	auipc	s4,0x5
    80002f70:	644a0a13          	addi	s4,s4,1604 # 800085b0 <syscalls+0x160>
    b->next = bcache.head.next;
    80002f74:	2b893783          	ld	a5,696(s2)
    80002f78:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f7a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f7e:	85d2                	mv	a1,s4
    80002f80:	01048513          	addi	a0,s1,16
    80002f84:	00001097          	auipc	ra,0x1
    80002f88:	4c8080e7          	jalr	1224(ra) # 8000444c <initsleeplock>
    bcache.head.next->prev = b;
    80002f8c:	2b893783          	ld	a5,696(s2)
    80002f90:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f92:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f96:	45848493          	addi	s1,s1,1112
    80002f9a:	fd349de3          	bne	s1,s3,80002f74 <binit+0x54>
  }
}
    80002f9e:	70a2                	ld	ra,40(sp)
    80002fa0:	7402                	ld	s0,32(sp)
    80002fa2:	64e2                	ld	s1,24(sp)
    80002fa4:	6942                	ld	s2,16(sp)
    80002fa6:	69a2                	ld	s3,8(sp)
    80002fa8:	6a02                	ld	s4,0(sp)
    80002faa:	6145                	addi	sp,sp,48
    80002fac:	8082                	ret

0000000080002fae <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002fae:	7179                	addi	sp,sp,-48
    80002fb0:	f406                	sd	ra,40(sp)
    80002fb2:	f022                	sd	s0,32(sp)
    80002fb4:	ec26                	sd	s1,24(sp)
    80002fb6:	e84a                	sd	s2,16(sp)
    80002fb8:	e44e                	sd	s3,8(sp)
    80002fba:	1800                	addi	s0,sp,48
    80002fbc:	892a                	mv	s2,a0
    80002fbe:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002fc0:	00014517          	auipc	a0,0x14
    80002fc4:	ab850513          	addi	a0,a0,-1352 # 80016a78 <bcache>
    80002fc8:	ffffe097          	auipc	ra,0xffffe
    80002fcc:	c0e080e7          	jalr	-1010(ra) # 80000bd6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002fd0:	0001c497          	auipc	s1,0x1c
    80002fd4:	d604b483          	ld	s1,-672(s1) # 8001ed30 <bcache+0x82b8>
    80002fd8:	0001c797          	auipc	a5,0x1c
    80002fdc:	d0878793          	addi	a5,a5,-760 # 8001ece0 <bcache+0x8268>
    80002fe0:	02f48f63          	beq	s1,a5,8000301e <bread+0x70>
    80002fe4:	873e                	mv	a4,a5
    80002fe6:	a021                	j	80002fee <bread+0x40>
    80002fe8:	68a4                	ld	s1,80(s1)
    80002fea:	02e48a63          	beq	s1,a4,8000301e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002fee:	449c                	lw	a5,8(s1)
    80002ff0:	ff279ce3          	bne	a5,s2,80002fe8 <bread+0x3a>
    80002ff4:	44dc                	lw	a5,12(s1)
    80002ff6:	ff3799e3          	bne	a5,s3,80002fe8 <bread+0x3a>
      b->refcnt++;
    80002ffa:	40bc                	lw	a5,64(s1)
    80002ffc:	2785                	addiw	a5,a5,1
    80002ffe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003000:	00014517          	auipc	a0,0x14
    80003004:	a7850513          	addi	a0,a0,-1416 # 80016a78 <bcache>
    80003008:	ffffe097          	auipc	ra,0xffffe
    8000300c:	c82080e7          	jalr	-894(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    80003010:	01048513          	addi	a0,s1,16
    80003014:	00001097          	auipc	ra,0x1
    80003018:	472080e7          	jalr	1138(ra) # 80004486 <acquiresleep>
      return b;
    8000301c:	a8b9                	j	8000307a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000301e:	0001c497          	auipc	s1,0x1c
    80003022:	d0a4b483          	ld	s1,-758(s1) # 8001ed28 <bcache+0x82b0>
    80003026:	0001c797          	auipc	a5,0x1c
    8000302a:	cba78793          	addi	a5,a5,-838 # 8001ece0 <bcache+0x8268>
    8000302e:	00f48863          	beq	s1,a5,8000303e <bread+0x90>
    80003032:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003034:	40bc                	lw	a5,64(s1)
    80003036:	cf81                	beqz	a5,8000304e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003038:	64a4                	ld	s1,72(s1)
    8000303a:	fee49de3          	bne	s1,a4,80003034 <bread+0x86>
  panic("bget: no buffers");
    8000303e:	00005517          	auipc	a0,0x5
    80003042:	57a50513          	addi	a0,a0,1402 # 800085b8 <syscalls+0x168>
    80003046:	ffffd097          	auipc	ra,0xffffd
    8000304a:	4fa080e7          	jalr	1274(ra) # 80000540 <panic>
      b->dev = dev;
    8000304e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003052:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003056:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000305a:	4785                	li	a5,1
    8000305c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000305e:	00014517          	auipc	a0,0x14
    80003062:	a1a50513          	addi	a0,a0,-1510 # 80016a78 <bcache>
    80003066:	ffffe097          	auipc	ra,0xffffe
    8000306a:	c24080e7          	jalr	-988(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    8000306e:	01048513          	addi	a0,s1,16
    80003072:	00001097          	auipc	ra,0x1
    80003076:	414080e7          	jalr	1044(ra) # 80004486 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000307a:	409c                	lw	a5,0(s1)
    8000307c:	cb89                	beqz	a5,8000308e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000307e:	8526                	mv	a0,s1
    80003080:	70a2                	ld	ra,40(sp)
    80003082:	7402                	ld	s0,32(sp)
    80003084:	64e2                	ld	s1,24(sp)
    80003086:	6942                	ld	s2,16(sp)
    80003088:	69a2                	ld	s3,8(sp)
    8000308a:	6145                	addi	sp,sp,48
    8000308c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000308e:	4581                	li	a1,0
    80003090:	8526                	mv	a0,s1
    80003092:	00003097          	auipc	ra,0x3
    80003096:	1b0080e7          	jalr	432(ra) # 80006242 <virtio_disk_rw>
    b->valid = 1;
    8000309a:	4785                	li	a5,1
    8000309c:	c09c                	sw	a5,0(s1)
  return b;
    8000309e:	b7c5                	j	8000307e <bread+0xd0>

00000000800030a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800030a0:	1101                	addi	sp,sp,-32
    800030a2:	ec06                	sd	ra,24(sp)
    800030a4:	e822                	sd	s0,16(sp)
    800030a6:	e426                	sd	s1,8(sp)
    800030a8:	1000                	addi	s0,sp,32
    800030aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030ac:	0541                	addi	a0,a0,16
    800030ae:	00001097          	auipc	ra,0x1
    800030b2:	472080e7          	jalr	1138(ra) # 80004520 <holdingsleep>
    800030b6:	cd01                	beqz	a0,800030ce <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800030b8:	4585                	li	a1,1
    800030ba:	8526                	mv	a0,s1
    800030bc:	00003097          	auipc	ra,0x3
    800030c0:	186080e7          	jalr	390(ra) # 80006242 <virtio_disk_rw>
}
    800030c4:	60e2                	ld	ra,24(sp)
    800030c6:	6442                	ld	s0,16(sp)
    800030c8:	64a2                	ld	s1,8(sp)
    800030ca:	6105                	addi	sp,sp,32
    800030cc:	8082                	ret
    panic("bwrite");
    800030ce:	00005517          	auipc	a0,0x5
    800030d2:	50250513          	addi	a0,a0,1282 # 800085d0 <syscalls+0x180>
    800030d6:	ffffd097          	auipc	ra,0xffffd
    800030da:	46a080e7          	jalr	1130(ra) # 80000540 <panic>

00000000800030de <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800030de:	1101                	addi	sp,sp,-32
    800030e0:	ec06                	sd	ra,24(sp)
    800030e2:	e822                	sd	s0,16(sp)
    800030e4:	e426                	sd	s1,8(sp)
    800030e6:	e04a                	sd	s2,0(sp)
    800030e8:	1000                	addi	s0,sp,32
    800030ea:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030ec:	01050913          	addi	s2,a0,16
    800030f0:	854a                	mv	a0,s2
    800030f2:	00001097          	auipc	ra,0x1
    800030f6:	42e080e7          	jalr	1070(ra) # 80004520 <holdingsleep>
    800030fa:	c92d                	beqz	a0,8000316c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800030fc:	854a                	mv	a0,s2
    800030fe:	00001097          	auipc	ra,0x1
    80003102:	3de080e7          	jalr	990(ra) # 800044dc <releasesleep>

  acquire(&bcache.lock);
    80003106:	00014517          	auipc	a0,0x14
    8000310a:	97250513          	addi	a0,a0,-1678 # 80016a78 <bcache>
    8000310e:	ffffe097          	auipc	ra,0xffffe
    80003112:	ac8080e7          	jalr	-1336(ra) # 80000bd6 <acquire>
  b->refcnt--;
    80003116:	40bc                	lw	a5,64(s1)
    80003118:	37fd                	addiw	a5,a5,-1
    8000311a:	0007871b          	sext.w	a4,a5
    8000311e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003120:	eb05                	bnez	a4,80003150 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003122:	68bc                	ld	a5,80(s1)
    80003124:	64b8                	ld	a4,72(s1)
    80003126:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003128:	64bc                	ld	a5,72(s1)
    8000312a:	68b8                	ld	a4,80(s1)
    8000312c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000312e:	0001c797          	auipc	a5,0x1c
    80003132:	94a78793          	addi	a5,a5,-1718 # 8001ea78 <bcache+0x8000>
    80003136:	2b87b703          	ld	a4,696(a5)
    8000313a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000313c:	0001c717          	auipc	a4,0x1c
    80003140:	ba470713          	addi	a4,a4,-1116 # 8001ece0 <bcache+0x8268>
    80003144:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003146:	2b87b703          	ld	a4,696(a5)
    8000314a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000314c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003150:	00014517          	auipc	a0,0x14
    80003154:	92850513          	addi	a0,a0,-1752 # 80016a78 <bcache>
    80003158:	ffffe097          	auipc	ra,0xffffe
    8000315c:	b32080e7          	jalr	-1230(ra) # 80000c8a <release>
}
    80003160:	60e2                	ld	ra,24(sp)
    80003162:	6442                	ld	s0,16(sp)
    80003164:	64a2                	ld	s1,8(sp)
    80003166:	6902                	ld	s2,0(sp)
    80003168:	6105                	addi	sp,sp,32
    8000316a:	8082                	ret
    panic("brelse");
    8000316c:	00005517          	auipc	a0,0x5
    80003170:	46c50513          	addi	a0,a0,1132 # 800085d8 <syscalls+0x188>
    80003174:	ffffd097          	auipc	ra,0xffffd
    80003178:	3cc080e7          	jalr	972(ra) # 80000540 <panic>

000000008000317c <bpin>:

void
bpin(struct buf *b) {
    8000317c:	1101                	addi	sp,sp,-32
    8000317e:	ec06                	sd	ra,24(sp)
    80003180:	e822                	sd	s0,16(sp)
    80003182:	e426                	sd	s1,8(sp)
    80003184:	1000                	addi	s0,sp,32
    80003186:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003188:	00014517          	auipc	a0,0x14
    8000318c:	8f050513          	addi	a0,a0,-1808 # 80016a78 <bcache>
    80003190:	ffffe097          	auipc	ra,0xffffe
    80003194:	a46080e7          	jalr	-1466(ra) # 80000bd6 <acquire>
  b->refcnt++;
    80003198:	40bc                	lw	a5,64(s1)
    8000319a:	2785                	addiw	a5,a5,1
    8000319c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000319e:	00014517          	auipc	a0,0x14
    800031a2:	8da50513          	addi	a0,a0,-1830 # 80016a78 <bcache>
    800031a6:	ffffe097          	auipc	ra,0xffffe
    800031aa:	ae4080e7          	jalr	-1308(ra) # 80000c8a <release>
}
    800031ae:	60e2                	ld	ra,24(sp)
    800031b0:	6442                	ld	s0,16(sp)
    800031b2:	64a2                	ld	s1,8(sp)
    800031b4:	6105                	addi	sp,sp,32
    800031b6:	8082                	ret

00000000800031b8 <bunpin>:

void
bunpin(struct buf *b) {
    800031b8:	1101                	addi	sp,sp,-32
    800031ba:	ec06                	sd	ra,24(sp)
    800031bc:	e822                	sd	s0,16(sp)
    800031be:	e426                	sd	s1,8(sp)
    800031c0:	1000                	addi	s0,sp,32
    800031c2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800031c4:	00014517          	auipc	a0,0x14
    800031c8:	8b450513          	addi	a0,a0,-1868 # 80016a78 <bcache>
    800031cc:	ffffe097          	auipc	ra,0xffffe
    800031d0:	a0a080e7          	jalr	-1526(ra) # 80000bd6 <acquire>
  b->refcnt--;
    800031d4:	40bc                	lw	a5,64(s1)
    800031d6:	37fd                	addiw	a5,a5,-1
    800031d8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031da:	00014517          	auipc	a0,0x14
    800031de:	89e50513          	addi	a0,a0,-1890 # 80016a78 <bcache>
    800031e2:	ffffe097          	auipc	ra,0xffffe
    800031e6:	aa8080e7          	jalr	-1368(ra) # 80000c8a <release>
}
    800031ea:	60e2                	ld	ra,24(sp)
    800031ec:	6442                	ld	s0,16(sp)
    800031ee:	64a2                	ld	s1,8(sp)
    800031f0:	6105                	addi	sp,sp,32
    800031f2:	8082                	ret

00000000800031f4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800031f4:	1101                	addi	sp,sp,-32
    800031f6:	ec06                	sd	ra,24(sp)
    800031f8:	e822                	sd	s0,16(sp)
    800031fa:	e426                	sd	s1,8(sp)
    800031fc:	e04a                	sd	s2,0(sp)
    800031fe:	1000                	addi	s0,sp,32
    80003200:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003202:	00d5d59b          	srliw	a1,a1,0xd
    80003206:	0001c797          	auipc	a5,0x1c
    8000320a:	f4e7a783          	lw	a5,-178(a5) # 8001f154 <sb+0x1c>
    8000320e:	9dbd                	addw	a1,a1,a5
    80003210:	00000097          	auipc	ra,0x0
    80003214:	d9e080e7          	jalr	-610(ra) # 80002fae <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003218:	0074f713          	andi	a4,s1,7
    8000321c:	4785                	li	a5,1
    8000321e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003222:	14ce                	slli	s1,s1,0x33
    80003224:	90d9                	srli	s1,s1,0x36
    80003226:	00950733          	add	a4,a0,s1
    8000322a:	05874703          	lbu	a4,88(a4)
    8000322e:	00e7f6b3          	and	a3,a5,a4
    80003232:	c69d                	beqz	a3,80003260 <bfree+0x6c>
    80003234:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003236:	94aa                	add	s1,s1,a0
    80003238:	fff7c793          	not	a5,a5
    8000323c:	8f7d                	and	a4,a4,a5
    8000323e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003242:	00001097          	auipc	ra,0x1
    80003246:	126080e7          	jalr	294(ra) # 80004368 <log_write>
  brelse(bp);
    8000324a:	854a                	mv	a0,s2
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	e92080e7          	jalr	-366(ra) # 800030de <brelse>
}
    80003254:	60e2                	ld	ra,24(sp)
    80003256:	6442                	ld	s0,16(sp)
    80003258:	64a2                	ld	s1,8(sp)
    8000325a:	6902                	ld	s2,0(sp)
    8000325c:	6105                	addi	sp,sp,32
    8000325e:	8082                	ret
    panic("freeing free block");
    80003260:	00005517          	auipc	a0,0x5
    80003264:	38050513          	addi	a0,a0,896 # 800085e0 <syscalls+0x190>
    80003268:	ffffd097          	auipc	ra,0xffffd
    8000326c:	2d8080e7          	jalr	728(ra) # 80000540 <panic>

0000000080003270 <balloc>:
{
    80003270:	711d                	addi	sp,sp,-96
    80003272:	ec86                	sd	ra,88(sp)
    80003274:	e8a2                	sd	s0,80(sp)
    80003276:	e4a6                	sd	s1,72(sp)
    80003278:	e0ca                	sd	s2,64(sp)
    8000327a:	fc4e                	sd	s3,56(sp)
    8000327c:	f852                	sd	s4,48(sp)
    8000327e:	f456                	sd	s5,40(sp)
    80003280:	f05a                	sd	s6,32(sp)
    80003282:	ec5e                	sd	s7,24(sp)
    80003284:	e862                	sd	s8,16(sp)
    80003286:	e466                	sd	s9,8(sp)
    80003288:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000328a:	0001c797          	auipc	a5,0x1c
    8000328e:	eb27a783          	lw	a5,-334(a5) # 8001f13c <sb+0x4>
    80003292:	cff5                	beqz	a5,8000338e <balloc+0x11e>
    80003294:	8baa                	mv	s7,a0
    80003296:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003298:	0001cb17          	auipc	s6,0x1c
    8000329c:	ea0b0b13          	addi	s6,s6,-352 # 8001f138 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032a0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800032a2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032a4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800032a6:	6c89                	lui	s9,0x2
    800032a8:	a061                	j	80003330 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800032aa:	97ca                	add	a5,a5,s2
    800032ac:	8e55                	or	a2,a2,a3
    800032ae:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800032b2:	854a                	mv	a0,s2
    800032b4:	00001097          	auipc	ra,0x1
    800032b8:	0b4080e7          	jalr	180(ra) # 80004368 <log_write>
        brelse(bp);
    800032bc:	854a                	mv	a0,s2
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	e20080e7          	jalr	-480(ra) # 800030de <brelse>
  bp = bread(dev, bno);
    800032c6:	85a6                	mv	a1,s1
    800032c8:	855e                	mv	a0,s7
    800032ca:	00000097          	auipc	ra,0x0
    800032ce:	ce4080e7          	jalr	-796(ra) # 80002fae <bread>
    800032d2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800032d4:	40000613          	li	a2,1024
    800032d8:	4581                	li	a1,0
    800032da:	05850513          	addi	a0,a0,88
    800032de:	ffffe097          	auipc	ra,0xffffe
    800032e2:	9f4080e7          	jalr	-1548(ra) # 80000cd2 <memset>
  log_write(bp);
    800032e6:	854a                	mv	a0,s2
    800032e8:	00001097          	auipc	ra,0x1
    800032ec:	080080e7          	jalr	128(ra) # 80004368 <log_write>
  brelse(bp);
    800032f0:	854a                	mv	a0,s2
    800032f2:	00000097          	auipc	ra,0x0
    800032f6:	dec080e7          	jalr	-532(ra) # 800030de <brelse>
}
    800032fa:	8526                	mv	a0,s1
    800032fc:	60e6                	ld	ra,88(sp)
    800032fe:	6446                	ld	s0,80(sp)
    80003300:	64a6                	ld	s1,72(sp)
    80003302:	6906                	ld	s2,64(sp)
    80003304:	79e2                	ld	s3,56(sp)
    80003306:	7a42                	ld	s4,48(sp)
    80003308:	7aa2                	ld	s5,40(sp)
    8000330a:	7b02                	ld	s6,32(sp)
    8000330c:	6be2                	ld	s7,24(sp)
    8000330e:	6c42                	ld	s8,16(sp)
    80003310:	6ca2                	ld	s9,8(sp)
    80003312:	6125                	addi	sp,sp,96
    80003314:	8082                	ret
    brelse(bp);
    80003316:	854a                	mv	a0,s2
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	dc6080e7          	jalr	-570(ra) # 800030de <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003320:	015c87bb          	addw	a5,s9,s5
    80003324:	00078a9b          	sext.w	s5,a5
    80003328:	004b2703          	lw	a4,4(s6)
    8000332c:	06eaf163          	bgeu	s5,a4,8000338e <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80003330:	41fad79b          	sraiw	a5,s5,0x1f
    80003334:	0137d79b          	srliw	a5,a5,0x13
    80003338:	015787bb          	addw	a5,a5,s5
    8000333c:	40d7d79b          	sraiw	a5,a5,0xd
    80003340:	01cb2583          	lw	a1,28(s6)
    80003344:	9dbd                	addw	a1,a1,a5
    80003346:	855e                	mv	a0,s7
    80003348:	00000097          	auipc	ra,0x0
    8000334c:	c66080e7          	jalr	-922(ra) # 80002fae <bread>
    80003350:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003352:	004b2503          	lw	a0,4(s6)
    80003356:	000a849b          	sext.w	s1,s5
    8000335a:	8762                	mv	a4,s8
    8000335c:	faa4fde3          	bgeu	s1,a0,80003316 <balloc+0xa6>
      m = 1 << (bi % 8);
    80003360:	00777693          	andi	a3,a4,7
    80003364:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003368:	41f7579b          	sraiw	a5,a4,0x1f
    8000336c:	01d7d79b          	srliw	a5,a5,0x1d
    80003370:	9fb9                	addw	a5,a5,a4
    80003372:	4037d79b          	sraiw	a5,a5,0x3
    80003376:	00f90633          	add	a2,s2,a5
    8000337a:	05864603          	lbu	a2,88(a2)
    8000337e:	00c6f5b3          	and	a1,a3,a2
    80003382:	d585                	beqz	a1,800032aa <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003384:	2705                	addiw	a4,a4,1
    80003386:	2485                	addiw	s1,s1,1
    80003388:	fd471ae3          	bne	a4,s4,8000335c <balloc+0xec>
    8000338c:	b769                	j	80003316 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000338e:	00005517          	auipc	a0,0x5
    80003392:	26a50513          	addi	a0,a0,618 # 800085f8 <syscalls+0x1a8>
    80003396:	ffffd097          	auipc	ra,0xffffd
    8000339a:	1f4080e7          	jalr	500(ra) # 8000058a <printf>
  return 0;
    8000339e:	4481                	li	s1,0
    800033a0:	bfa9                	j	800032fa <balloc+0x8a>

00000000800033a2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800033a2:	7179                	addi	sp,sp,-48
    800033a4:	f406                	sd	ra,40(sp)
    800033a6:	f022                	sd	s0,32(sp)
    800033a8:	ec26                	sd	s1,24(sp)
    800033aa:	e84a                	sd	s2,16(sp)
    800033ac:	e44e                	sd	s3,8(sp)
    800033ae:	e052                	sd	s4,0(sp)
    800033b0:	1800                	addi	s0,sp,48
    800033b2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800033b4:	47ad                	li	a5,11
    800033b6:	02b7e863          	bltu	a5,a1,800033e6 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800033ba:	02059793          	slli	a5,a1,0x20
    800033be:	01e7d593          	srli	a1,a5,0x1e
    800033c2:	00b504b3          	add	s1,a0,a1
    800033c6:	0504a903          	lw	s2,80(s1)
    800033ca:	06091e63          	bnez	s2,80003446 <bmap+0xa4>
      addr = balloc(ip->dev);
    800033ce:	4108                	lw	a0,0(a0)
    800033d0:	00000097          	auipc	ra,0x0
    800033d4:	ea0080e7          	jalr	-352(ra) # 80003270 <balloc>
    800033d8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800033dc:	06090563          	beqz	s2,80003446 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800033e0:	0524a823          	sw	s2,80(s1)
    800033e4:	a08d                	j	80003446 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800033e6:	ff45849b          	addiw	s1,a1,-12
    800033ea:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800033ee:	0ff00793          	li	a5,255
    800033f2:	08e7e563          	bltu	a5,a4,8000347c <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800033f6:	08052903          	lw	s2,128(a0)
    800033fa:	00091d63          	bnez	s2,80003414 <bmap+0x72>
      addr = balloc(ip->dev);
    800033fe:	4108                	lw	a0,0(a0)
    80003400:	00000097          	auipc	ra,0x0
    80003404:	e70080e7          	jalr	-400(ra) # 80003270 <balloc>
    80003408:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000340c:	02090d63          	beqz	s2,80003446 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003410:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003414:	85ca                	mv	a1,s2
    80003416:	0009a503          	lw	a0,0(s3)
    8000341a:	00000097          	auipc	ra,0x0
    8000341e:	b94080e7          	jalr	-1132(ra) # 80002fae <bread>
    80003422:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003424:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003428:	02049713          	slli	a4,s1,0x20
    8000342c:	01e75593          	srli	a1,a4,0x1e
    80003430:	00b784b3          	add	s1,a5,a1
    80003434:	0004a903          	lw	s2,0(s1)
    80003438:	02090063          	beqz	s2,80003458 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000343c:	8552                	mv	a0,s4
    8000343e:	00000097          	auipc	ra,0x0
    80003442:	ca0080e7          	jalr	-864(ra) # 800030de <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003446:	854a                	mv	a0,s2
    80003448:	70a2                	ld	ra,40(sp)
    8000344a:	7402                	ld	s0,32(sp)
    8000344c:	64e2                	ld	s1,24(sp)
    8000344e:	6942                	ld	s2,16(sp)
    80003450:	69a2                	ld	s3,8(sp)
    80003452:	6a02                	ld	s4,0(sp)
    80003454:	6145                	addi	sp,sp,48
    80003456:	8082                	ret
      addr = balloc(ip->dev);
    80003458:	0009a503          	lw	a0,0(s3)
    8000345c:	00000097          	auipc	ra,0x0
    80003460:	e14080e7          	jalr	-492(ra) # 80003270 <balloc>
    80003464:	0005091b          	sext.w	s2,a0
      if(addr){
    80003468:	fc090ae3          	beqz	s2,8000343c <bmap+0x9a>
        a[bn] = addr;
    8000346c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003470:	8552                	mv	a0,s4
    80003472:	00001097          	auipc	ra,0x1
    80003476:	ef6080e7          	jalr	-266(ra) # 80004368 <log_write>
    8000347a:	b7c9                	j	8000343c <bmap+0x9a>
  panic("bmap: out of range");
    8000347c:	00005517          	auipc	a0,0x5
    80003480:	19450513          	addi	a0,a0,404 # 80008610 <syscalls+0x1c0>
    80003484:	ffffd097          	auipc	ra,0xffffd
    80003488:	0bc080e7          	jalr	188(ra) # 80000540 <panic>

000000008000348c <iget>:
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
    8000349e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800034a0:	0001c517          	auipc	a0,0x1c
    800034a4:	cb850513          	addi	a0,a0,-840 # 8001f158 <itable>
    800034a8:	ffffd097          	auipc	ra,0xffffd
    800034ac:	72e080e7          	jalr	1838(ra) # 80000bd6 <acquire>
  empty = 0;
    800034b0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800034b2:	0001c497          	auipc	s1,0x1c
    800034b6:	cbe48493          	addi	s1,s1,-834 # 8001f170 <itable+0x18>
    800034ba:	0001d697          	auipc	a3,0x1d
    800034be:	74668693          	addi	a3,a3,1862 # 80020c00 <log>
    800034c2:	a039                	j	800034d0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034c4:	02090b63          	beqz	s2,800034fa <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800034c8:	08848493          	addi	s1,s1,136
    800034cc:	02d48a63          	beq	s1,a3,80003500 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800034d0:	449c                	lw	a5,8(s1)
    800034d2:	fef059e3          	blez	a5,800034c4 <iget+0x38>
    800034d6:	4098                	lw	a4,0(s1)
    800034d8:	ff3716e3          	bne	a4,s3,800034c4 <iget+0x38>
    800034dc:	40d8                	lw	a4,4(s1)
    800034de:	ff4713e3          	bne	a4,s4,800034c4 <iget+0x38>
      ip->ref++;
    800034e2:	2785                	addiw	a5,a5,1
    800034e4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800034e6:	0001c517          	auipc	a0,0x1c
    800034ea:	c7250513          	addi	a0,a0,-910 # 8001f158 <itable>
    800034ee:	ffffd097          	auipc	ra,0xffffd
    800034f2:	79c080e7          	jalr	1948(ra) # 80000c8a <release>
      return ip;
    800034f6:	8926                	mv	s2,s1
    800034f8:	a03d                	j	80003526 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034fa:	f7f9                	bnez	a5,800034c8 <iget+0x3c>
    800034fc:	8926                	mv	s2,s1
    800034fe:	b7e9                	j	800034c8 <iget+0x3c>
  if(empty == 0)
    80003500:	02090c63          	beqz	s2,80003538 <iget+0xac>
  ip->dev = dev;
    80003504:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003508:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000350c:	4785                	li	a5,1
    8000350e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003512:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003516:	0001c517          	auipc	a0,0x1c
    8000351a:	c4250513          	addi	a0,a0,-958 # 8001f158 <itable>
    8000351e:	ffffd097          	auipc	ra,0xffffd
    80003522:	76c080e7          	jalr	1900(ra) # 80000c8a <release>
}
    80003526:	854a                	mv	a0,s2
    80003528:	70a2                	ld	ra,40(sp)
    8000352a:	7402                	ld	s0,32(sp)
    8000352c:	64e2                	ld	s1,24(sp)
    8000352e:	6942                	ld	s2,16(sp)
    80003530:	69a2                	ld	s3,8(sp)
    80003532:	6a02                	ld	s4,0(sp)
    80003534:	6145                	addi	sp,sp,48
    80003536:	8082                	ret
    panic("iget: no inodes");
    80003538:	00005517          	auipc	a0,0x5
    8000353c:	0f050513          	addi	a0,a0,240 # 80008628 <syscalls+0x1d8>
    80003540:	ffffd097          	auipc	ra,0xffffd
    80003544:	000080e7          	jalr	ra # 80000540 <panic>

0000000080003548 <fsinit>:
fsinit(int dev) {
    80003548:	7179                	addi	sp,sp,-48
    8000354a:	f406                	sd	ra,40(sp)
    8000354c:	f022                	sd	s0,32(sp)
    8000354e:	ec26                	sd	s1,24(sp)
    80003550:	e84a                	sd	s2,16(sp)
    80003552:	e44e                	sd	s3,8(sp)
    80003554:	1800                	addi	s0,sp,48
    80003556:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003558:	4585                	li	a1,1
    8000355a:	00000097          	auipc	ra,0x0
    8000355e:	a54080e7          	jalr	-1452(ra) # 80002fae <bread>
    80003562:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003564:	0001c997          	auipc	s3,0x1c
    80003568:	bd498993          	addi	s3,s3,-1068 # 8001f138 <sb>
    8000356c:	02000613          	li	a2,32
    80003570:	05850593          	addi	a1,a0,88
    80003574:	854e                	mv	a0,s3
    80003576:	ffffd097          	auipc	ra,0xffffd
    8000357a:	7b8080e7          	jalr	1976(ra) # 80000d2e <memmove>
  brelse(bp);
    8000357e:	8526                	mv	a0,s1
    80003580:	00000097          	auipc	ra,0x0
    80003584:	b5e080e7          	jalr	-1186(ra) # 800030de <brelse>
  if(sb.magic != FSMAGIC)
    80003588:	0009a703          	lw	a4,0(s3)
    8000358c:	102037b7          	lui	a5,0x10203
    80003590:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003594:	02f71263          	bne	a4,a5,800035b8 <fsinit+0x70>
  initlog(dev, &sb);
    80003598:	0001c597          	auipc	a1,0x1c
    8000359c:	ba058593          	addi	a1,a1,-1120 # 8001f138 <sb>
    800035a0:	854a                	mv	a0,s2
    800035a2:	00001097          	auipc	ra,0x1
    800035a6:	b4a080e7          	jalr	-1206(ra) # 800040ec <initlog>
}
    800035aa:	70a2                	ld	ra,40(sp)
    800035ac:	7402                	ld	s0,32(sp)
    800035ae:	64e2                	ld	s1,24(sp)
    800035b0:	6942                	ld	s2,16(sp)
    800035b2:	69a2                	ld	s3,8(sp)
    800035b4:	6145                	addi	sp,sp,48
    800035b6:	8082                	ret
    panic("invalid file system");
    800035b8:	00005517          	auipc	a0,0x5
    800035bc:	08050513          	addi	a0,a0,128 # 80008638 <syscalls+0x1e8>
    800035c0:	ffffd097          	auipc	ra,0xffffd
    800035c4:	f80080e7          	jalr	-128(ra) # 80000540 <panic>

00000000800035c8 <iinit>:
{
    800035c8:	7179                	addi	sp,sp,-48
    800035ca:	f406                	sd	ra,40(sp)
    800035cc:	f022                	sd	s0,32(sp)
    800035ce:	ec26                	sd	s1,24(sp)
    800035d0:	e84a                	sd	s2,16(sp)
    800035d2:	e44e                	sd	s3,8(sp)
    800035d4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800035d6:	00005597          	auipc	a1,0x5
    800035da:	07a58593          	addi	a1,a1,122 # 80008650 <syscalls+0x200>
    800035de:	0001c517          	auipc	a0,0x1c
    800035e2:	b7a50513          	addi	a0,a0,-1158 # 8001f158 <itable>
    800035e6:	ffffd097          	auipc	ra,0xffffd
    800035ea:	560080e7          	jalr	1376(ra) # 80000b46 <initlock>
  for(i = 0; i < NINODE; i++) {
    800035ee:	0001c497          	auipc	s1,0x1c
    800035f2:	b9248493          	addi	s1,s1,-1134 # 8001f180 <itable+0x28>
    800035f6:	0001d997          	auipc	s3,0x1d
    800035fa:	61a98993          	addi	s3,s3,1562 # 80020c10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800035fe:	00005917          	auipc	s2,0x5
    80003602:	05a90913          	addi	s2,s2,90 # 80008658 <syscalls+0x208>
    80003606:	85ca                	mv	a1,s2
    80003608:	8526                	mv	a0,s1
    8000360a:	00001097          	auipc	ra,0x1
    8000360e:	e42080e7          	jalr	-446(ra) # 8000444c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003612:	08848493          	addi	s1,s1,136
    80003616:	ff3498e3          	bne	s1,s3,80003606 <iinit+0x3e>
}
    8000361a:	70a2                	ld	ra,40(sp)
    8000361c:	7402                	ld	s0,32(sp)
    8000361e:	64e2                	ld	s1,24(sp)
    80003620:	6942                	ld	s2,16(sp)
    80003622:	69a2                	ld	s3,8(sp)
    80003624:	6145                	addi	sp,sp,48
    80003626:	8082                	ret

0000000080003628 <ialloc>:
{
    80003628:	715d                	addi	sp,sp,-80
    8000362a:	e486                	sd	ra,72(sp)
    8000362c:	e0a2                	sd	s0,64(sp)
    8000362e:	fc26                	sd	s1,56(sp)
    80003630:	f84a                	sd	s2,48(sp)
    80003632:	f44e                	sd	s3,40(sp)
    80003634:	f052                	sd	s4,32(sp)
    80003636:	ec56                	sd	s5,24(sp)
    80003638:	e85a                	sd	s6,16(sp)
    8000363a:	e45e                	sd	s7,8(sp)
    8000363c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000363e:	0001c717          	auipc	a4,0x1c
    80003642:	b0672703          	lw	a4,-1274(a4) # 8001f144 <sb+0xc>
    80003646:	4785                	li	a5,1
    80003648:	04e7fa63          	bgeu	a5,a4,8000369c <ialloc+0x74>
    8000364c:	8aaa                	mv	s5,a0
    8000364e:	8bae                	mv	s7,a1
    80003650:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003652:	0001ca17          	auipc	s4,0x1c
    80003656:	ae6a0a13          	addi	s4,s4,-1306 # 8001f138 <sb>
    8000365a:	00048b1b          	sext.w	s6,s1
    8000365e:	0044d593          	srli	a1,s1,0x4
    80003662:	018a2783          	lw	a5,24(s4)
    80003666:	9dbd                	addw	a1,a1,a5
    80003668:	8556                	mv	a0,s5
    8000366a:	00000097          	auipc	ra,0x0
    8000366e:	944080e7          	jalr	-1724(ra) # 80002fae <bread>
    80003672:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003674:	05850993          	addi	s3,a0,88
    80003678:	00f4f793          	andi	a5,s1,15
    8000367c:	079a                	slli	a5,a5,0x6
    8000367e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003680:	00099783          	lh	a5,0(s3)
    80003684:	c3a1                	beqz	a5,800036c4 <ialloc+0x9c>
    brelse(bp);
    80003686:	00000097          	auipc	ra,0x0
    8000368a:	a58080e7          	jalr	-1448(ra) # 800030de <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000368e:	0485                	addi	s1,s1,1
    80003690:	00ca2703          	lw	a4,12(s4)
    80003694:	0004879b          	sext.w	a5,s1
    80003698:	fce7e1e3          	bltu	a5,a4,8000365a <ialloc+0x32>
  printf("ialloc: no inodes\n");
    8000369c:	00005517          	auipc	a0,0x5
    800036a0:	fc450513          	addi	a0,a0,-60 # 80008660 <syscalls+0x210>
    800036a4:	ffffd097          	auipc	ra,0xffffd
    800036a8:	ee6080e7          	jalr	-282(ra) # 8000058a <printf>
  return 0;
    800036ac:	4501                	li	a0,0
}
    800036ae:	60a6                	ld	ra,72(sp)
    800036b0:	6406                	ld	s0,64(sp)
    800036b2:	74e2                	ld	s1,56(sp)
    800036b4:	7942                	ld	s2,48(sp)
    800036b6:	79a2                	ld	s3,40(sp)
    800036b8:	7a02                	ld	s4,32(sp)
    800036ba:	6ae2                	ld	s5,24(sp)
    800036bc:	6b42                	ld	s6,16(sp)
    800036be:	6ba2                	ld	s7,8(sp)
    800036c0:	6161                	addi	sp,sp,80
    800036c2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800036c4:	04000613          	li	a2,64
    800036c8:	4581                	li	a1,0
    800036ca:	854e                	mv	a0,s3
    800036cc:	ffffd097          	auipc	ra,0xffffd
    800036d0:	606080e7          	jalr	1542(ra) # 80000cd2 <memset>
      dip->type = type;
    800036d4:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800036d8:	854a                	mv	a0,s2
    800036da:	00001097          	auipc	ra,0x1
    800036de:	c8e080e7          	jalr	-882(ra) # 80004368 <log_write>
      brelse(bp);
    800036e2:	854a                	mv	a0,s2
    800036e4:	00000097          	auipc	ra,0x0
    800036e8:	9fa080e7          	jalr	-1542(ra) # 800030de <brelse>
      return iget(dev, inum);
    800036ec:	85da                	mv	a1,s6
    800036ee:	8556                	mv	a0,s5
    800036f0:	00000097          	auipc	ra,0x0
    800036f4:	d9c080e7          	jalr	-612(ra) # 8000348c <iget>
    800036f8:	bf5d                	j	800036ae <ialloc+0x86>

00000000800036fa <iupdate>:
{
    800036fa:	1101                	addi	sp,sp,-32
    800036fc:	ec06                	sd	ra,24(sp)
    800036fe:	e822                	sd	s0,16(sp)
    80003700:	e426                	sd	s1,8(sp)
    80003702:	e04a                	sd	s2,0(sp)
    80003704:	1000                	addi	s0,sp,32
    80003706:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003708:	415c                	lw	a5,4(a0)
    8000370a:	0047d79b          	srliw	a5,a5,0x4
    8000370e:	0001c597          	auipc	a1,0x1c
    80003712:	a425a583          	lw	a1,-1470(a1) # 8001f150 <sb+0x18>
    80003716:	9dbd                	addw	a1,a1,a5
    80003718:	4108                	lw	a0,0(a0)
    8000371a:	00000097          	auipc	ra,0x0
    8000371e:	894080e7          	jalr	-1900(ra) # 80002fae <bread>
    80003722:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003724:	05850793          	addi	a5,a0,88
    80003728:	40d8                	lw	a4,4(s1)
    8000372a:	8b3d                	andi	a4,a4,15
    8000372c:	071a                	slli	a4,a4,0x6
    8000372e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003730:	04449703          	lh	a4,68(s1)
    80003734:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003738:	04649703          	lh	a4,70(s1)
    8000373c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003740:	04849703          	lh	a4,72(s1)
    80003744:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003748:	04a49703          	lh	a4,74(s1)
    8000374c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003750:	44f8                	lw	a4,76(s1)
    80003752:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003754:	03400613          	li	a2,52
    80003758:	05048593          	addi	a1,s1,80
    8000375c:	00c78513          	addi	a0,a5,12
    80003760:	ffffd097          	auipc	ra,0xffffd
    80003764:	5ce080e7          	jalr	1486(ra) # 80000d2e <memmove>
  log_write(bp);
    80003768:	854a                	mv	a0,s2
    8000376a:	00001097          	auipc	ra,0x1
    8000376e:	bfe080e7          	jalr	-1026(ra) # 80004368 <log_write>
  brelse(bp);
    80003772:	854a                	mv	a0,s2
    80003774:	00000097          	auipc	ra,0x0
    80003778:	96a080e7          	jalr	-1686(ra) # 800030de <brelse>
}
    8000377c:	60e2                	ld	ra,24(sp)
    8000377e:	6442                	ld	s0,16(sp)
    80003780:	64a2                	ld	s1,8(sp)
    80003782:	6902                	ld	s2,0(sp)
    80003784:	6105                	addi	sp,sp,32
    80003786:	8082                	ret

0000000080003788 <idup>:
{
    80003788:	1101                	addi	sp,sp,-32
    8000378a:	ec06                	sd	ra,24(sp)
    8000378c:	e822                	sd	s0,16(sp)
    8000378e:	e426                	sd	s1,8(sp)
    80003790:	1000                	addi	s0,sp,32
    80003792:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003794:	0001c517          	auipc	a0,0x1c
    80003798:	9c450513          	addi	a0,a0,-1596 # 8001f158 <itable>
    8000379c:	ffffd097          	auipc	ra,0xffffd
    800037a0:	43a080e7          	jalr	1082(ra) # 80000bd6 <acquire>
  ip->ref++;
    800037a4:	449c                	lw	a5,8(s1)
    800037a6:	2785                	addiw	a5,a5,1
    800037a8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800037aa:	0001c517          	auipc	a0,0x1c
    800037ae:	9ae50513          	addi	a0,a0,-1618 # 8001f158 <itable>
    800037b2:	ffffd097          	auipc	ra,0xffffd
    800037b6:	4d8080e7          	jalr	1240(ra) # 80000c8a <release>
}
    800037ba:	8526                	mv	a0,s1
    800037bc:	60e2                	ld	ra,24(sp)
    800037be:	6442                	ld	s0,16(sp)
    800037c0:	64a2                	ld	s1,8(sp)
    800037c2:	6105                	addi	sp,sp,32
    800037c4:	8082                	ret

00000000800037c6 <ilock>:
{
    800037c6:	1101                	addi	sp,sp,-32
    800037c8:	ec06                	sd	ra,24(sp)
    800037ca:	e822                	sd	s0,16(sp)
    800037cc:	e426                	sd	s1,8(sp)
    800037ce:	e04a                	sd	s2,0(sp)
    800037d0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800037d2:	c115                	beqz	a0,800037f6 <ilock+0x30>
    800037d4:	84aa                	mv	s1,a0
    800037d6:	451c                	lw	a5,8(a0)
    800037d8:	00f05f63          	blez	a5,800037f6 <ilock+0x30>
  acquiresleep(&ip->lock);
    800037dc:	0541                	addi	a0,a0,16
    800037de:	00001097          	auipc	ra,0x1
    800037e2:	ca8080e7          	jalr	-856(ra) # 80004486 <acquiresleep>
  if(ip->valid == 0){
    800037e6:	40bc                	lw	a5,64(s1)
    800037e8:	cf99                	beqz	a5,80003806 <ilock+0x40>
}
    800037ea:	60e2                	ld	ra,24(sp)
    800037ec:	6442                	ld	s0,16(sp)
    800037ee:	64a2                	ld	s1,8(sp)
    800037f0:	6902                	ld	s2,0(sp)
    800037f2:	6105                	addi	sp,sp,32
    800037f4:	8082                	ret
    panic("ilock");
    800037f6:	00005517          	auipc	a0,0x5
    800037fa:	e8250513          	addi	a0,a0,-382 # 80008678 <syscalls+0x228>
    800037fe:	ffffd097          	auipc	ra,0xffffd
    80003802:	d42080e7          	jalr	-702(ra) # 80000540 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003806:	40dc                	lw	a5,4(s1)
    80003808:	0047d79b          	srliw	a5,a5,0x4
    8000380c:	0001c597          	auipc	a1,0x1c
    80003810:	9445a583          	lw	a1,-1724(a1) # 8001f150 <sb+0x18>
    80003814:	9dbd                	addw	a1,a1,a5
    80003816:	4088                	lw	a0,0(s1)
    80003818:	fffff097          	auipc	ra,0xfffff
    8000381c:	796080e7          	jalr	1942(ra) # 80002fae <bread>
    80003820:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003822:	05850593          	addi	a1,a0,88
    80003826:	40dc                	lw	a5,4(s1)
    80003828:	8bbd                	andi	a5,a5,15
    8000382a:	079a                	slli	a5,a5,0x6
    8000382c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000382e:	00059783          	lh	a5,0(a1)
    80003832:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003836:	00259783          	lh	a5,2(a1)
    8000383a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000383e:	00459783          	lh	a5,4(a1)
    80003842:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003846:	00659783          	lh	a5,6(a1)
    8000384a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000384e:	459c                	lw	a5,8(a1)
    80003850:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003852:	03400613          	li	a2,52
    80003856:	05b1                	addi	a1,a1,12
    80003858:	05048513          	addi	a0,s1,80
    8000385c:	ffffd097          	auipc	ra,0xffffd
    80003860:	4d2080e7          	jalr	1234(ra) # 80000d2e <memmove>
    brelse(bp);
    80003864:	854a                	mv	a0,s2
    80003866:	00000097          	auipc	ra,0x0
    8000386a:	878080e7          	jalr	-1928(ra) # 800030de <brelse>
    ip->valid = 1;
    8000386e:	4785                	li	a5,1
    80003870:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003872:	04449783          	lh	a5,68(s1)
    80003876:	fbb5                	bnez	a5,800037ea <ilock+0x24>
      panic("ilock: no type");
    80003878:	00005517          	auipc	a0,0x5
    8000387c:	e0850513          	addi	a0,a0,-504 # 80008680 <syscalls+0x230>
    80003880:	ffffd097          	auipc	ra,0xffffd
    80003884:	cc0080e7          	jalr	-832(ra) # 80000540 <panic>

0000000080003888 <iunlock>:
{
    80003888:	1101                	addi	sp,sp,-32
    8000388a:	ec06                	sd	ra,24(sp)
    8000388c:	e822                	sd	s0,16(sp)
    8000388e:	e426                	sd	s1,8(sp)
    80003890:	e04a                	sd	s2,0(sp)
    80003892:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003894:	c905                	beqz	a0,800038c4 <iunlock+0x3c>
    80003896:	84aa                	mv	s1,a0
    80003898:	01050913          	addi	s2,a0,16
    8000389c:	854a                	mv	a0,s2
    8000389e:	00001097          	auipc	ra,0x1
    800038a2:	c82080e7          	jalr	-894(ra) # 80004520 <holdingsleep>
    800038a6:	cd19                	beqz	a0,800038c4 <iunlock+0x3c>
    800038a8:	449c                	lw	a5,8(s1)
    800038aa:	00f05d63          	blez	a5,800038c4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800038ae:	854a                	mv	a0,s2
    800038b0:	00001097          	auipc	ra,0x1
    800038b4:	c2c080e7          	jalr	-980(ra) # 800044dc <releasesleep>
}
    800038b8:	60e2                	ld	ra,24(sp)
    800038ba:	6442                	ld	s0,16(sp)
    800038bc:	64a2                	ld	s1,8(sp)
    800038be:	6902                	ld	s2,0(sp)
    800038c0:	6105                	addi	sp,sp,32
    800038c2:	8082                	ret
    panic("iunlock");
    800038c4:	00005517          	auipc	a0,0x5
    800038c8:	dcc50513          	addi	a0,a0,-564 # 80008690 <syscalls+0x240>
    800038cc:	ffffd097          	auipc	ra,0xffffd
    800038d0:	c74080e7          	jalr	-908(ra) # 80000540 <panic>

00000000800038d4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800038d4:	7179                	addi	sp,sp,-48
    800038d6:	f406                	sd	ra,40(sp)
    800038d8:	f022                	sd	s0,32(sp)
    800038da:	ec26                	sd	s1,24(sp)
    800038dc:	e84a                	sd	s2,16(sp)
    800038de:	e44e                	sd	s3,8(sp)
    800038e0:	e052                	sd	s4,0(sp)
    800038e2:	1800                	addi	s0,sp,48
    800038e4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800038e6:	05050493          	addi	s1,a0,80
    800038ea:	08050913          	addi	s2,a0,128
    800038ee:	a021                	j	800038f6 <itrunc+0x22>
    800038f0:	0491                	addi	s1,s1,4
    800038f2:	01248d63          	beq	s1,s2,8000390c <itrunc+0x38>
    if(ip->addrs[i]){
    800038f6:	408c                	lw	a1,0(s1)
    800038f8:	dde5                	beqz	a1,800038f0 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800038fa:	0009a503          	lw	a0,0(s3)
    800038fe:	00000097          	auipc	ra,0x0
    80003902:	8f6080e7          	jalr	-1802(ra) # 800031f4 <bfree>
      ip->addrs[i] = 0;
    80003906:	0004a023          	sw	zero,0(s1)
    8000390a:	b7dd                	j	800038f0 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000390c:	0809a583          	lw	a1,128(s3)
    80003910:	e185                	bnez	a1,80003930 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003912:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003916:	854e                	mv	a0,s3
    80003918:	00000097          	auipc	ra,0x0
    8000391c:	de2080e7          	jalr	-542(ra) # 800036fa <iupdate>
}
    80003920:	70a2                	ld	ra,40(sp)
    80003922:	7402                	ld	s0,32(sp)
    80003924:	64e2                	ld	s1,24(sp)
    80003926:	6942                	ld	s2,16(sp)
    80003928:	69a2                	ld	s3,8(sp)
    8000392a:	6a02                	ld	s4,0(sp)
    8000392c:	6145                	addi	sp,sp,48
    8000392e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003930:	0009a503          	lw	a0,0(s3)
    80003934:	fffff097          	auipc	ra,0xfffff
    80003938:	67a080e7          	jalr	1658(ra) # 80002fae <bread>
    8000393c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000393e:	05850493          	addi	s1,a0,88
    80003942:	45850913          	addi	s2,a0,1112
    80003946:	a021                	j	8000394e <itrunc+0x7a>
    80003948:	0491                	addi	s1,s1,4
    8000394a:	01248b63          	beq	s1,s2,80003960 <itrunc+0x8c>
      if(a[j])
    8000394e:	408c                	lw	a1,0(s1)
    80003950:	dde5                	beqz	a1,80003948 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003952:	0009a503          	lw	a0,0(s3)
    80003956:	00000097          	auipc	ra,0x0
    8000395a:	89e080e7          	jalr	-1890(ra) # 800031f4 <bfree>
    8000395e:	b7ed                	j	80003948 <itrunc+0x74>
    brelse(bp);
    80003960:	8552                	mv	a0,s4
    80003962:	fffff097          	auipc	ra,0xfffff
    80003966:	77c080e7          	jalr	1916(ra) # 800030de <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000396a:	0809a583          	lw	a1,128(s3)
    8000396e:	0009a503          	lw	a0,0(s3)
    80003972:	00000097          	auipc	ra,0x0
    80003976:	882080e7          	jalr	-1918(ra) # 800031f4 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000397a:	0809a023          	sw	zero,128(s3)
    8000397e:	bf51                	j	80003912 <itrunc+0x3e>

0000000080003980 <iput>:
{
    80003980:	1101                	addi	sp,sp,-32
    80003982:	ec06                	sd	ra,24(sp)
    80003984:	e822                	sd	s0,16(sp)
    80003986:	e426                	sd	s1,8(sp)
    80003988:	e04a                	sd	s2,0(sp)
    8000398a:	1000                	addi	s0,sp,32
    8000398c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000398e:	0001b517          	auipc	a0,0x1b
    80003992:	7ca50513          	addi	a0,a0,1994 # 8001f158 <itable>
    80003996:	ffffd097          	auipc	ra,0xffffd
    8000399a:	240080e7          	jalr	576(ra) # 80000bd6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000399e:	4498                	lw	a4,8(s1)
    800039a0:	4785                	li	a5,1
    800039a2:	02f70363          	beq	a4,a5,800039c8 <iput+0x48>
  ip->ref--;
    800039a6:	449c                	lw	a5,8(s1)
    800039a8:	37fd                	addiw	a5,a5,-1
    800039aa:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800039ac:	0001b517          	auipc	a0,0x1b
    800039b0:	7ac50513          	addi	a0,a0,1964 # 8001f158 <itable>
    800039b4:	ffffd097          	auipc	ra,0xffffd
    800039b8:	2d6080e7          	jalr	726(ra) # 80000c8a <release>
}
    800039bc:	60e2                	ld	ra,24(sp)
    800039be:	6442                	ld	s0,16(sp)
    800039c0:	64a2                	ld	s1,8(sp)
    800039c2:	6902                	ld	s2,0(sp)
    800039c4:	6105                	addi	sp,sp,32
    800039c6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039c8:	40bc                	lw	a5,64(s1)
    800039ca:	dff1                	beqz	a5,800039a6 <iput+0x26>
    800039cc:	04a49783          	lh	a5,74(s1)
    800039d0:	fbf9                	bnez	a5,800039a6 <iput+0x26>
    acquiresleep(&ip->lock);
    800039d2:	01048913          	addi	s2,s1,16
    800039d6:	854a                	mv	a0,s2
    800039d8:	00001097          	auipc	ra,0x1
    800039dc:	aae080e7          	jalr	-1362(ra) # 80004486 <acquiresleep>
    release(&itable.lock);
    800039e0:	0001b517          	auipc	a0,0x1b
    800039e4:	77850513          	addi	a0,a0,1912 # 8001f158 <itable>
    800039e8:	ffffd097          	auipc	ra,0xffffd
    800039ec:	2a2080e7          	jalr	674(ra) # 80000c8a <release>
    itrunc(ip);
    800039f0:	8526                	mv	a0,s1
    800039f2:	00000097          	auipc	ra,0x0
    800039f6:	ee2080e7          	jalr	-286(ra) # 800038d4 <itrunc>
    ip->type = 0;
    800039fa:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800039fe:	8526                	mv	a0,s1
    80003a00:	00000097          	auipc	ra,0x0
    80003a04:	cfa080e7          	jalr	-774(ra) # 800036fa <iupdate>
    ip->valid = 0;
    80003a08:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003a0c:	854a                	mv	a0,s2
    80003a0e:	00001097          	auipc	ra,0x1
    80003a12:	ace080e7          	jalr	-1330(ra) # 800044dc <releasesleep>
    acquire(&itable.lock);
    80003a16:	0001b517          	auipc	a0,0x1b
    80003a1a:	74250513          	addi	a0,a0,1858 # 8001f158 <itable>
    80003a1e:	ffffd097          	auipc	ra,0xffffd
    80003a22:	1b8080e7          	jalr	440(ra) # 80000bd6 <acquire>
    80003a26:	b741                	j	800039a6 <iput+0x26>

0000000080003a28 <iunlockput>:
{
    80003a28:	1101                	addi	sp,sp,-32
    80003a2a:	ec06                	sd	ra,24(sp)
    80003a2c:	e822                	sd	s0,16(sp)
    80003a2e:	e426                	sd	s1,8(sp)
    80003a30:	1000                	addi	s0,sp,32
    80003a32:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a34:	00000097          	auipc	ra,0x0
    80003a38:	e54080e7          	jalr	-428(ra) # 80003888 <iunlock>
  iput(ip);
    80003a3c:	8526                	mv	a0,s1
    80003a3e:	00000097          	auipc	ra,0x0
    80003a42:	f42080e7          	jalr	-190(ra) # 80003980 <iput>
}
    80003a46:	60e2                	ld	ra,24(sp)
    80003a48:	6442                	ld	s0,16(sp)
    80003a4a:	64a2                	ld	s1,8(sp)
    80003a4c:	6105                	addi	sp,sp,32
    80003a4e:	8082                	ret

0000000080003a50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a50:	1141                	addi	sp,sp,-16
    80003a52:	e422                	sd	s0,8(sp)
    80003a54:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003a56:	411c                	lw	a5,0(a0)
    80003a58:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a5a:	415c                	lw	a5,4(a0)
    80003a5c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a5e:	04451783          	lh	a5,68(a0)
    80003a62:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a66:	04a51783          	lh	a5,74(a0)
    80003a6a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a6e:	04c56783          	lwu	a5,76(a0)
    80003a72:	e99c                	sd	a5,16(a1)
}
    80003a74:	6422                	ld	s0,8(sp)
    80003a76:	0141                	addi	sp,sp,16
    80003a78:	8082                	ret

0000000080003a7a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a7a:	457c                	lw	a5,76(a0)
    80003a7c:	0ed7e963          	bltu	a5,a3,80003b6e <readi+0xf4>
{
    80003a80:	7159                	addi	sp,sp,-112
    80003a82:	f486                	sd	ra,104(sp)
    80003a84:	f0a2                	sd	s0,96(sp)
    80003a86:	eca6                	sd	s1,88(sp)
    80003a88:	e8ca                	sd	s2,80(sp)
    80003a8a:	e4ce                	sd	s3,72(sp)
    80003a8c:	e0d2                	sd	s4,64(sp)
    80003a8e:	fc56                	sd	s5,56(sp)
    80003a90:	f85a                	sd	s6,48(sp)
    80003a92:	f45e                	sd	s7,40(sp)
    80003a94:	f062                	sd	s8,32(sp)
    80003a96:	ec66                	sd	s9,24(sp)
    80003a98:	e86a                	sd	s10,16(sp)
    80003a9a:	e46e                	sd	s11,8(sp)
    80003a9c:	1880                	addi	s0,sp,112
    80003a9e:	8b2a                	mv	s6,a0
    80003aa0:	8bae                	mv	s7,a1
    80003aa2:	8a32                	mv	s4,a2
    80003aa4:	84b6                	mv	s1,a3
    80003aa6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003aa8:	9f35                	addw	a4,a4,a3
    return 0;
    80003aaa:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003aac:	0ad76063          	bltu	a4,a3,80003b4c <readi+0xd2>
  if(off + n > ip->size)
    80003ab0:	00e7f463          	bgeu	a5,a4,80003ab8 <readi+0x3e>
    n = ip->size - off;
    80003ab4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ab8:	0a0a8963          	beqz	s5,80003b6a <readi+0xf0>
    80003abc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003abe:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003ac2:	5c7d                	li	s8,-1
    80003ac4:	a82d                	j	80003afe <readi+0x84>
    80003ac6:	020d1d93          	slli	s11,s10,0x20
    80003aca:	020ddd93          	srli	s11,s11,0x20
    80003ace:	05890613          	addi	a2,s2,88
    80003ad2:	86ee                	mv	a3,s11
    80003ad4:	963a                	add	a2,a2,a4
    80003ad6:	85d2                	mv	a1,s4
    80003ad8:	855e                	mv	a0,s7
    80003ada:	fffff097          	auipc	ra,0xfffff
    80003ade:	982080e7          	jalr	-1662(ra) # 8000245c <either_copyout>
    80003ae2:	05850d63          	beq	a0,s8,80003b3c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ae6:	854a                	mv	a0,s2
    80003ae8:	fffff097          	auipc	ra,0xfffff
    80003aec:	5f6080e7          	jalr	1526(ra) # 800030de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003af0:	013d09bb          	addw	s3,s10,s3
    80003af4:	009d04bb          	addw	s1,s10,s1
    80003af8:	9a6e                	add	s4,s4,s11
    80003afa:	0559f763          	bgeu	s3,s5,80003b48 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003afe:	00a4d59b          	srliw	a1,s1,0xa
    80003b02:	855a                	mv	a0,s6
    80003b04:	00000097          	auipc	ra,0x0
    80003b08:	89e080e7          	jalr	-1890(ra) # 800033a2 <bmap>
    80003b0c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003b10:	cd85                	beqz	a1,80003b48 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003b12:	000b2503          	lw	a0,0(s6)
    80003b16:	fffff097          	auipc	ra,0xfffff
    80003b1a:	498080e7          	jalr	1176(ra) # 80002fae <bread>
    80003b1e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b20:	3ff4f713          	andi	a4,s1,1023
    80003b24:	40ec87bb          	subw	a5,s9,a4
    80003b28:	413a86bb          	subw	a3,s5,s3
    80003b2c:	8d3e                	mv	s10,a5
    80003b2e:	2781                	sext.w	a5,a5
    80003b30:	0006861b          	sext.w	a2,a3
    80003b34:	f8f679e3          	bgeu	a2,a5,80003ac6 <readi+0x4c>
    80003b38:	8d36                	mv	s10,a3
    80003b3a:	b771                	j	80003ac6 <readi+0x4c>
      brelse(bp);
    80003b3c:	854a                	mv	a0,s2
    80003b3e:	fffff097          	auipc	ra,0xfffff
    80003b42:	5a0080e7          	jalr	1440(ra) # 800030de <brelse>
      tot = -1;
    80003b46:	59fd                	li	s3,-1
  }
  return tot;
    80003b48:	0009851b          	sext.w	a0,s3
}
    80003b4c:	70a6                	ld	ra,104(sp)
    80003b4e:	7406                	ld	s0,96(sp)
    80003b50:	64e6                	ld	s1,88(sp)
    80003b52:	6946                	ld	s2,80(sp)
    80003b54:	69a6                	ld	s3,72(sp)
    80003b56:	6a06                	ld	s4,64(sp)
    80003b58:	7ae2                	ld	s5,56(sp)
    80003b5a:	7b42                	ld	s6,48(sp)
    80003b5c:	7ba2                	ld	s7,40(sp)
    80003b5e:	7c02                	ld	s8,32(sp)
    80003b60:	6ce2                	ld	s9,24(sp)
    80003b62:	6d42                	ld	s10,16(sp)
    80003b64:	6da2                	ld	s11,8(sp)
    80003b66:	6165                	addi	sp,sp,112
    80003b68:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b6a:	89d6                	mv	s3,s5
    80003b6c:	bff1                	j	80003b48 <readi+0xce>
    return 0;
    80003b6e:	4501                	li	a0,0
}
    80003b70:	8082                	ret

0000000080003b72 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b72:	457c                	lw	a5,76(a0)
    80003b74:	10d7e863          	bltu	a5,a3,80003c84 <writei+0x112>
{
    80003b78:	7159                	addi	sp,sp,-112
    80003b7a:	f486                	sd	ra,104(sp)
    80003b7c:	f0a2                	sd	s0,96(sp)
    80003b7e:	eca6                	sd	s1,88(sp)
    80003b80:	e8ca                	sd	s2,80(sp)
    80003b82:	e4ce                	sd	s3,72(sp)
    80003b84:	e0d2                	sd	s4,64(sp)
    80003b86:	fc56                	sd	s5,56(sp)
    80003b88:	f85a                	sd	s6,48(sp)
    80003b8a:	f45e                	sd	s7,40(sp)
    80003b8c:	f062                	sd	s8,32(sp)
    80003b8e:	ec66                	sd	s9,24(sp)
    80003b90:	e86a                	sd	s10,16(sp)
    80003b92:	e46e                	sd	s11,8(sp)
    80003b94:	1880                	addi	s0,sp,112
    80003b96:	8aaa                	mv	s5,a0
    80003b98:	8bae                	mv	s7,a1
    80003b9a:	8a32                	mv	s4,a2
    80003b9c:	8936                	mv	s2,a3
    80003b9e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003ba0:	00e687bb          	addw	a5,a3,a4
    80003ba4:	0ed7e263          	bltu	a5,a3,80003c88 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003ba8:	00043737          	lui	a4,0x43
    80003bac:	0ef76063          	bltu	a4,a5,80003c8c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bb0:	0c0b0863          	beqz	s6,80003c80 <writei+0x10e>
    80003bb4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bb6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003bba:	5c7d                	li	s8,-1
    80003bbc:	a091                	j	80003c00 <writei+0x8e>
    80003bbe:	020d1d93          	slli	s11,s10,0x20
    80003bc2:	020ddd93          	srli	s11,s11,0x20
    80003bc6:	05848513          	addi	a0,s1,88
    80003bca:	86ee                	mv	a3,s11
    80003bcc:	8652                	mv	a2,s4
    80003bce:	85de                	mv	a1,s7
    80003bd0:	953a                	add	a0,a0,a4
    80003bd2:	fffff097          	auipc	ra,0xfffff
    80003bd6:	8e0080e7          	jalr	-1824(ra) # 800024b2 <either_copyin>
    80003bda:	07850263          	beq	a0,s8,80003c3e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003bde:	8526                	mv	a0,s1
    80003be0:	00000097          	auipc	ra,0x0
    80003be4:	788080e7          	jalr	1928(ra) # 80004368 <log_write>
    brelse(bp);
    80003be8:	8526                	mv	a0,s1
    80003bea:	fffff097          	auipc	ra,0xfffff
    80003bee:	4f4080e7          	jalr	1268(ra) # 800030de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bf2:	013d09bb          	addw	s3,s10,s3
    80003bf6:	012d093b          	addw	s2,s10,s2
    80003bfa:	9a6e                	add	s4,s4,s11
    80003bfc:	0569f663          	bgeu	s3,s6,80003c48 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003c00:	00a9559b          	srliw	a1,s2,0xa
    80003c04:	8556                	mv	a0,s5
    80003c06:	fffff097          	auipc	ra,0xfffff
    80003c0a:	79c080e7          	jalr	1948(ra) # 800033a2 <bmap>
    80003c0e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003c12:	c99d                	beqz	a1,80003c48 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003c14:	000aa503          	lw	a0,0(s5)
    80003c18:	fffff097          	auipc	ra,0xfffff
    80003c1c:	396080e7          	jalr	918(ra) # 80002fae <bread>
    80003c20:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c22:	3ff97713          	andi	a4,s2,1023
    80003c26:	40ec87bb          	subw	a5,s9,a4
    80003c2a:	413b06bb          	subw	a3,s6,s3
    80003c2e:	8d3e                	mv	s10,a5
    80003c30:	2781                	sext.w	a5,a5
    80003c32:	0006861b          	sext.w	a2,a3
    80003c36:	f8f674e3          	bgeu	a2,a5,80003bbe <writei+0x4c>
    80003c3a:	8d36                	mv	s10,a3
    80003c3c:	b749                	j	80003bbe <writei+0x4c>
      brelse(bp);
    80003c3e:	8526                	mv	a0,s1
    80003c40:	fffff097          	auipc	ra,0xfffff
    80003c44:	49e080e7          	jalr	1182(ra) # 800030de <brelse>
  }

  if(off > ip->size)
    80003c48:	04caa783          	lw	a5,76(s5)
    80003c4c:	0127f463          	bgeu	a5,s2,80003c54 <writei+0xe2>
    ip->size = off;
    80003c50:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003c54:	8556                	mv	a0,s5
    80003c56:	00000097          	auipc	ra,0x0
    80003c5a:	aa4080e7          	jalr	-1372(ra) # 800036fa <iupdate>

  return tot;
    80003c5e:	0009851b          	sext.w	a0,s3
}
    80003c62:	70a6                	ld	ra,104(sp)
    80003c64:	7406                	ld	s0,96(sp)
    80003c66:	64e6                	ld	s1,88(sp)
    80003c68:	6946                	ld	s2,80(sp)
    80003c6a:	69a6                	ld	s3,72(sp)
    80003c6c:	6a06                	ld	s4,64(sp)
    80003c6e:	7ae2                	ld	s5,56(sp)
    80003c70:	7b42                	ld	s6,48(sp)
    80003c72:	7ba2                	ld	s7,40(sp)
    80003c74:	7c02                	ld	s8,32(sp)
    80003c76:	6ce2                	ld	s9,24(sp)
    80003c78:	6d42                	ld	s10,16(sp)
    80003c7a:	6da2                	ld	s11,8(sp)
    80003c7c:	6165                	addi	sp,sp,112
    80003c7e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c80:	89da                	mv	s3,s6
    80003c82:	bfc9                	j	80003c54 <writei+0xe2>
    return -1;
    80003c84:	557d                	li	a0,-1
}
    80003c86:	8082                	ret
    return -1;
    80003c88:	557d                	li	a0,-1
    80003c8a:	bfe1                	j	80003c62 <writei+0xf0>
    return -1;
    80003c8c:	557d                	li	a0,-1
    80003c8e:	bfd1                	j	80003c62 <writei+0xf0>

0000000080003c90 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c90:	1141                	addi	sp,sp,-16
    80003c92:	e406                	sd	ra,8(sp)
    80003c94:	e022                	sd	s0,0(sp)
    80003c96:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c98:	4639                	li	a2,14
    80003c9a:	ffffd097          	auipc	ra,0xffffd
    80003c9e:	108080e7          	jalr	264(ra) # 80000da2 <strncmp>
}
    80003ca2:	60a2                	ld	ra,8(sp)
    80003ca4:	6402                	ld	s0,0(sp)
    80003ca6:	0141                	addi	sp,sp,16
    80003ca8:	8082                	ret

0000000080003caa <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003caa:	7139                	addi	sp,sp,-64
    80003cac:	fc06                	sd	ra,56(sp)
    80003cae:	f822                	sd	s0,48(sp)
    80003cb0:	f426                	sd	s1,40(sp)
    80003cb2:	f04a                	sd	s2,32(sp)
    80003cb4:	ec4e                	sd	s3,24(sp)
    80003cb6:	e852                	sd	s4,16(sp)
    80003cb8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003cba:	04451703          	lh	a4,68(a0)
    80003cbe:	4785                	li	a5,1
    80003cc0:	00f71a63          	bne	a4,a5,80003cd4 <dirlookup+0x2a>
    80003cc4:	892a                	mv	s2,a0
    80003cc6:	89ae                	mv	s3,a1
    80003cc8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cca:	457c                	lw	a5,76(a0)
    80003ccc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003cce:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cd0:	e79d                	bnez	a5,80003cfe <dirlookup+0x54>
    80003cd2:	a8a5                	j	80003d4a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003cd4:	00005517          	auipc	a0,0x5
    80003cd8:	9c450513          	addi	a0,a0,-1596 # 80008698 <syscalls+0x248>
    80003cdc:	ffffd097          	auipc	ra,0xffffd
    80003ce0:	864080e7          	jalr	-1948(ra) # 80000540 <panic>
      panic("dirlookup read");
    80003ce4:	00005517          	auipc	a0,0x5
    80003ce8:	9cc50513          	addi	a0,a0,-1588 # 800086b0 <syscalls+0x260>
    80003cec:	ffffd097          	auipc	ra,0xffffd
    80003cf0:	854080e7          	jalr	-1964(ra) # 80000540 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cf4:	24c1                	addiw	s1,s1,16
    80003cf6:	04c92783          	lw	a5,76(s2)
    80003cfa:	04f4f763          	bgeu	s1,a5,80003d48 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cfe:	4741                	li	a4,16
    80003d00:	86a6                	mv	a3,s1
    80003d02:	fc040613          	addi	a2,s0,-64
    80003d06:	4581                	li	a1,0
    80003d08:	854a                	mv	a0,s2
    80003d0a:	00000097          	auipc	ra,0x0
    80003d0e:	d70080e7          	jalr	-656(ra) # 80003a7a <readi>
    80003d12:	47c1                	li	a5,16
    80003d14:	fcf518e3          	bne	a0,a5,80003ce4 <dirlookup+0x3a>
    if(de.inum == 0)
    80003d18:	fc045783          	lhu	a5,-64(s0)
    80003d1c:	dfe1                	beqz	a5,80003cf4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003d1e:	fc240593          	addi	a1,s0,-62
    80003d22:	854e                	mv	a0,s3
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	f6c080e7          	jalr	-148(ra) # 80003c90 <namecmp>
    80003d2c:	f561                	bnez	a0,80003cf4 <dirlookup+0x4a>
      if(poff)
    80003d2e:	000a0463          	beqz	s4,80003d36 <dirlookup+0x8c>
        *poff = off;
    80003d32:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003d36:	fc045583          	lhu	a1,-64(s0)
    80003d3a:	00092503          	lw	a0,0(s2)
    80003d3e:	fffff097          	auipc	ra,0xfffff
    80003d42:	74e080e7          	jalr	1870(ra) # 8000348c <iget>
    80003d46:	a011                	j	80003d4a <dirlookup+0xa0>
  return 0;
    80003d48:	4501                	li	a0,0
}
    80003d4a:	70e2                	ld	ra,56(sp)
    80003d4c:	7442                	ld	s0,48(sp)
    80003d4e:	74a2                	ld	s1,40(sp)
    80003d50:	7902                	ld	s2,32(sp)
    80003d52:	69e2                	ld	s3,24(sp)
    80003d54:	6a42                	ld	s4,16(sp)
    80003d56:	6121                	addi	sp,sp,64
    80003d58:	8082                	ret

0000000080003d5a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d5a:	711d                	addi	sp,sp,-96
    80003d5c:	ec86                	sd	ra,88(sp)
    80003d5e:	e8a2                	sd	s0,80(sp)
    80003d60:	e4a6                	sd	s1,72(sp)
    80003d62:	e0ca                	sd	s2,64(sp)
    80003d64:	fc4e                	sd	s3,56(sp)
    80003d66:	f852                	sd	s4,48(sp)
    80003d68:	f456                	sd	s5,40(sp)
    80003d6a:	f05a                	sd	s6,32(sp)
    80003d6c:	ec5e                	sd	s7,24(sp)
    80003d6e:	e862                	sd	s8,16(sp)
    80003d70:	e466                	sd	s9,8(sp)
    80003d72:	e06a                	sd	s10,0(sp)
    80003d74:	1080                	addi	s0,sp,96
    80003d76:	84aa                	mv	s1,a0
    80003d78:	8b2e                	mv	s6,a1
    80003d7a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d7c:	00054703          	lbu	a4,0(a0)
    80003d80:	02f00793          	li	a5,47
    80003d84:	02f70363          	beq	a4,a5,80003daa <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d88:	ffffe097          	auipc	ra,0xffffe
    80003d8c:	c24080e7          	jalr	-988(ra) # 800019ac <myproc>
    80003d90:	15053503          	ld	a0,336(a0)
    80003d94:	00000097          	auipc	ra,0x0
    80003d98:	9f4080e7          	jalr	-1548(ra) # 80003788 <idup>
    80003d9c:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d9e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003da2:	4cb5                	li	s9,13
  len = path - s;
    80003da4:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003da6:	4c05                	li	s8,1
    80003da8:	a87d                	j	80003e66 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003daa:	4585                	li	a1,1
    80003dac:	4505                	li	a0,1
    80003dae:	fffff097          	auipc	ra,0xfffff
    80003db2:	6de080e7          	jalr	1758(ra) # 8000348c <iget>
    80003db6:	8a2a                	mv	s4,a0
    80003db8:	b7dd                	j	80003d9e <namex+0x44>
      iunlockput(ip);
    80003dba:	8552                	mv	a0,s4
    80003dbc:	00000097          	auipc	ra,0x0
    80003dc0:	c6c080e7          	jalr	-916(ra) # 80003a28 <iunlockput>
      return 0;
    80003dc4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003dc6:	8552                	mv	a0,s4
    80003dc8:	60e6                	ld	ra,88(sp)
    80003dca:	6446                	ld	s0,80(sp)
    80003dcc:	64a6                	ld	s1,72(sp)
    80003dce:	6906                	ld	s2,64(sp)
    80003dd0:	79e2                	ld	s3,56(sp)
    80003dd2:	7a42                	ld	s4,48(sp)
    80003dd4:	7aa2                	ld	s5,40(sp)
    80003dd6:	7b02                	ld	s6,32(sp)
    80003dd8:	6be2                	ld	s7,24(sp)
    80003dda:	6c42                	ld	s8,16(sp)
    80003ddc:	6ca2                	ld	s9,8(sp)
    80003dde:	6d02                	ld	s10,0(sp)
    80003de0:	6125                	addi	sp,sp,96
    80003de2:	8082                	ret
      iunlock(ip);
    80003de4:	8552                	mv	a0,s4
    80003de6:	00000097          	auipc	ra,0x0
    80003dea:	aa2080e7          	jalr	-1374(ra) # 80003888 <iunlock>
      return ip;
    80003dee:	bfe1                	j	80003dc6 <namex+0x6c>
      iunlockput(ip);
    80003df0:	8552                	mv	a0,s4
    80003df2:	00000097          	auipc	ra,0x0
    80003df6:	c36080e7          	jalr	-970(ra) # 80003a28 <iunlockput>
      return 0;
    80003dfa:	8a4e                	mv	s4,s3
    80003dfc:	b7e9                	j	80003dc6 <namex+0x6c>
  len = path - s;
    80003dfe:	40998633          	sub	a2,s3,s1
    80003e02:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003e06:	09acd863          	bge	s9,s10,80003e96 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003e0a:	4639                	li	a2,14
    80003e0c:	85a6                	mv	a1,s1
    80003e0e:	8556                	mv	a0,s5
    80003e10:	ffffd097          	auipc	ra,0xffffd
    80003e14:	f1e080e7          	jalr	-226(ra) # 80000d2e <memmove>
    80003e18:	84ce                	mv	s1,s3
  while(*path == '/')
    80003e1a:	0004c783          	lbu	a5,0(s1)
    80003e1e:	01279763          	bne	a5,s2,80003e2c <namex+0xd2>
    path++;
    80003e22:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e24:	0004c783          	lbu	a5,0(s1)
    80003e28:	ff278de3          	beq	a5,s2,80003e22 <namex+0xc8>
    ilock(ip);
    80003e2c:	8552                	mv	a0,s4
    80003e2e:	00000097          	auipc	ra,0x0
    80003e32:	998080e7          	jalr	-1640(ra) # 800037c6 <ilock>
    if(ip->type != T_DIR){
    80003e36:	044a1783          	lh	a5,68(s4)
    80003e3a:	f98790e3          	bne	a5,s8,80003dba <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003e3e:	000b0563          	beqz	s6,80003e48 <namex+0xee>
    80003e42:	0004c783          	lbu	a5,0(s1)
    80003e46:	dfd9                	beqz	a5,80003de4 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003e48:	865e                	mv	a2,s7
    80003e4a:	85d6                	mv	a1,s5
    80003e4c:	8552                	mv	a0,s4
    80003e4e:	00000097          	auipc	ra,0x0
    80003e52:	e5c080e7          	jalr	-420(ra) # 80003caa <dirlookup>
    80003e56:	89aa                	mv	s3,a0
    80003e58:	dd41                	beqz	a0,80003df0 <namex+0x96>
    iunlockput(ip);
    80003e5a:	8552                	mv	a0,s4
    80003e5c:	00000097          	auipc	ra,0x0
    80003e60:	bcc080e7          	jalr	-1076(ra) # 80003a28 <iunlockput>
    ip = next;
    80003e64:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003e66:	0004c783          	lbu	a5,0(s1)
    80003e6a:	01279763          	bne	a5,s2,80003e78 <namex+0x11e>
    path++;
    80003e6e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e70:	0004c783          	lbu	a5,0(s1)
    80003e74:	ff278de3          	beq	a5,s2,80003e6e <namex+0x114>
  if(*path == 0)
    80003e78:	cb9d                	beqz	a5,80003eae <namex+0x154>
  while(*path != '/' && *path != 0)
    80003e7a:	0004c783          	lbu	a5,0(s1)
    80003e7e:	89a6                	mv	s3,s1
  len = path - s;
    80003e80:	8d5e                	mv	s10,s7
    80003e82:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003e84:	01278963          	beq	a5,s2,80003e96 <namex+0x13c>
    80003e88:	dbbd                	beqz	a5,80003dfe <namex+0xa4>
    path++;
    80003e8a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e8c:	0009c783          	lbu	a5,0(s3)
    80003e90:	ff279ce3          	bne	a5,s2,80003e88 <namex+0x12e>
    80003e94:	b7ad                	j	80003dfe <namex+0xa4>
    memmove(name, s, len);
    80003e96:	2601                	sext.w	a2,a2
    80003e98:	85a6                	mv	a1,s1
    80003e9a:	8556                	mv	a0,s5
    80003e9c:	ffffd097          	auipc	ra,0xffffd
    80003ea0:	e92080e7          	jalr	-366(ra) # 80000d2e <memmove>
    name[len] = 0;
    80003ea4:	9d56                	add	s10,s10,s5
    80003ea6:	000d0023          	sb	zero,0(s10)
    80003eaa:	84ce                	mv	s1,s3
    80003eac:	b7bd                	j	80003e1a <namex+0xc0>
  if(nameiparent){
    80003eae:	f00b0ce3          	beqz	s6,80003dc6 <namex+0x6c>
    iput(ip);
    80003eb2:	8552                	mv	a0,s4
    80003eb4:	00000097          	auipc	ra,0x0
    80003eb8:	acc080e7          	jalr	-1332(ra) # 80003980 <iput>
    return 0;
    80003ebc:	4a01                	li	s4,0
    80003ebe:	b721                	j	80003dc6 <namex+0x6c>

0000000080003ec0 <dirlink>:
{
    80003ec0:	7139                	addi	sp,sp,-64
    80003ec2:	fc06                	sd	ra,56(sp)
    80003ec4:	f822                	sd	s0,48(sp)
    80003ec6:	f426                	sd	s1,40(sp)
    80003ec8:	f04a                	sd	s2,32(sp)
    80003eca:	ec4e                	sd	s3,24(sp)
    80003ecc:	e852                	sd	s4,16(sp)
    80003ece:	0080                	addi	s0,sp,64
    80003ed0:	892a                	mv	s2,a0
    80003ed2:	8a2e                	mv	s4,a1
    80003ed4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ed6:	4601                	li	a2,0
    80003ed8:	00000097          	auipc	ra,0x0
    80003edc:	dd2080e7          	jalr	-558(ra) # 80003caa <dirlookup>
    80003ee0:	e93d                	bnez	a0,80003f56 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ee2:	04c92483          	lw	s1,76(s2)
    80003ee6:	c49d                	beqz	s1,80003f14 <dirlink+0x54>
    80003ee8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003eea:	4741                	li	a4,16
    80003eec:	86a6                	mv	a3,s1
    80003eee:	fc040613          	addi	a2,s0,-64
    80003ef2:	4581                	li	a1,0
    80003ef4:	854a                	mv	a0,s2
    80003ef6:	00000097          	auipc	ra,0x0
    80003efa:	b84080e7          	jalr	-1148(ra) # 80003a7a <readi>
    80003efe:	47c1                	li	a5,16
    80003f00:	06f51163          	bne	a0,a5,80003f62 <dirlink+0xa2>
    if(de.inum == 0)
    80003f04:	fc045783          	lhu	a5,-64(s0)
    80003f08:	c791                	beqz	a5,80003f14 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f0a:	24c1                	addiw	s1,s1,16
    80003f0c:	04c92783          	lw	a5,76(s2)
    80003f10:	fcf4ede3          	bltu	s1,a5,80003eea <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003f14:	4639                	li	a2,14
    80003f16:	85d2                	mv	a1,s4
    80003f18:	fc240513          	addi	a0,s0,-62
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	ec2080e7          	jalr	-318(ra) # 80000dde <strncpy>
  de.inum = inum;
    80003f24:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f28:	4741                	li	a4,16
    80003f2a:	86a6                	mv	a3,s1
    80003f2c:	fc040613          	addi	a2,s0,-64
    80003f30:	4581                	li	a1,0
    80003f32:	854a                	mv	a0,s2
    80003f34:	00000097          	auipc	ra,0x0
    80003f38:	c3e080e7          	jalr	-962(ra) # 80003b72 <writei>
    80003f3c:	1541                	addi	a0,a0,-16
    80003f3e:	00a03533          	snez	a0,a0
    80003f42:	40a00533          	neg	a0,a0
}
    80003f46:	70e2                	ld	ra,56(sp)
    80003f48:	7442                	ld	s0,48(sp)
    80003f4a:	74a2                	ld	s1,40(sp)
    80003f4c:	7902                	ld	s2,32(sp)
    80003f4e:	69e2                	ld	s3,24(sp)
    80003f50:	6a42                	ld	s4,16(sp)
    80003f52:	6121                	addi	sp,sp,64
    80003f54:	8082                	ret
    iput(ip);
    80003f56:	00000097          	auipc	ra,0x0
    80003f5a:	a2a080e7          	jalr	-1494(ra) # 80003980 <iput>
    return -1;
    80003f5e:	557d                	li	a0,-1
    80003f60:	b7dd                	j	80003f46 <dirlink+0x86>
      panic("dirlink read");
    80003f62:	00004517          	auipc	a0,0x4
    80003f66:	75e50513          	addi	a0,a0,1886 # 800086c0 <syscalls+0x270>
    80003f6a:	ffffc097          	auipc	ra,0xffffc
    80003f6e:	5d6080e7          	jalr	1494(ra) # 80000540 <panic>

0000000080003f72 <namei>:

struct inode*
namei(char *path)
{
    80003f72:	1101                	addi	sp,sp,-32
    80003f74:	ec06                	sd	ra,24(sp)
    80003f76:	e822                	sd	s0,16(sp)
    80003f78:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f7a:	fe040613          	addi	a2,s0,-32
    80003f7e:	4581                	li	a1,0
    80003f80:	00000097          	auipc	ra,0x0
    80003f84:	dda080e7          	jalr	-550(ra) # 80003d5a <namex>
}
    80003f88:	60e2                	ld	ra,24(sp)
    80003f8a:	6442                	ld	s0,16(sp)
    80003f8c:	6105                	addi	sp,sp,32
    80003f8e:	8082                	ret

0000000080003f90 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f90:	1141                	addi	sp,sp,-16
    80003f92:	e406                	sd	ra,8(sp)
    80003f94:	e022                	sd	s0,0(sp)
    80003f96:	0800                	addi	s0,sp,16
    80003f98:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f9a:	4585                	li	a1,1
    80003f9c:	00000097          	auipc	ra,0x0
    80003fa0:	dbe080e7          	jalr	-578(ra) # 80003d5a <namex>
}
    80003fa4:	60a2                	ld	ra,8(sp)
    80003fa6:	6402                	ld	s0,0(sp)
    80003fa8:	0141                	addi	sp,sp,16
    80003faa:	8082                	ret

0000000080003fac <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003fac:	1101                	addi	sp,sp,-32
    80003fae:	ec06                	sd	ra,24(sp)
    80003fb0:	e822                	sd	s0,16(sp)
    80003fb2:	e426                	sd	s1,8(sp)
    80003fb4:	e04a                	sd	s2,0(sp)
    80003fb6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003fb8:	0001d917          	auipc	s2,0x1d
    80003fbc:	c4890913          	addi	s2,s2,-952 # 80020c00 <log>
    80003fc0:	01892583          	lw	a1,24(s2)
    80003fc4:	02892503          	lw	a0,40(s2)
    80003fc8:	fffff097          	auipc	ra,0xfffff
    80003fcc:	fe6080e7          	jalr	-26(ra) # 80002fae <bread>
    80003fd0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003fd2:	02c92683          	lw	a3,44(s2)
    80003fd6:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003fd8:	02d05863          	blez	a3,80004008 <write_head+0x5c>
    80003fdc:	0001d797          	auipc	a5,0x1d
    80003fe0:	c5478793          	addi	a5,a5,-940 # 80020c30 <log+0x30>
    80003fe4:	05c50713          	addi	a4,a0,92
    80003fe8:	36fd                	addiw	a3,a3,-1
    80003fea:	02069613          	slli	a2,a3,0x20
    80003fee:	01e65693          	srli	a3,a2,0x1e
    80003ff2:	0001d617          	auipc	a2,0x1d
    80003ff6:	c4260613          	addi	a2,a2,-958 # 80020c34 <log+0x34>
    80003ffa:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003ffc:	4390                	lw	a2,0(a5)
    80003ffe:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004000:	0791                	addi	a5,a5,4
    80004002:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80004004:	fed79ce3          	bne	a5,a3,80003ffc <write_head+0x50>
  }
  bwrite(buf);
    80004008:	8526                	mv	a0,s1
    8000400a:	fffff097          	auipc	ra,0xfffff
    8000400e:	096080e7          	jalr	150(ra) # 800030a0 <bwrite>
  brelse(buf);
    80004012:	8526                	mv	a0,s1
    80004014:	fffff097          	auipc	ra,0xfffff
    80004018:	0ca080e7          	jalr	202(ra) # 800030de <brelse>
}
    8000401c:	60e2                	ld	ra,24(sp)
    8000401e:	6442                	ld	s0,16(sp)
    80004020:	64a2                	ld	s1,8(sp)
    80004022:	6902                	ld	s2,0(sp)
    80004024:	6105                	addi	sp,sp,32
    80004026:	8082                	ret

0000000080004028 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004028:	0001d797          	auipc	a5,0x1d
    8000402c:	c047a783          	lw	a5,-1020(a5) # 80020c2c <log+0x2c>
    80004030:	0af05d63          	blez	a5,800040ea <install_trans+0xc2>
{
    80004034:	7139                	addi	sp,sp,-64
    80004036:	fc06                	sd	ra,56(sp)
    80004038:	f822                	sd	s0,48(sp)
    8000403a:	f426                	sd	s1,40(sp)
    8000403c:	f04a                	sd	s2,32(sp)
    8000403e:	ec4e                	sd	s3,24(sp)
    80004040:	e852                	sd	s4,16(sp)
    80004042:	e456                	sd	s5,8(sp)
    80004044:	e05a                	sd	s6,0(sp)
    80004046:	0080                	addi	s0,sp,64
    80004048:	8b2a                	mv	s6,a0
    8000404a:	0001da97          	auipc	s5,0x1d
    8000404e:	be6a8a93          	addi	s5,s5,-1050 # 80020c30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004052:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004054:	0001d997          	auipc	s3,0x1d
    80004058:	bac98993          	addi	s3,s3,-1108 # 80020c00 <log>
    8000405c:	a00d                	j	8000407e <install_trans+0x56>
    brelse(lbuf);
    8000405e:	854a                	mv	a0,s2
    80004060:	fffff097          	auipc	ra,0xfffff
    80004064:	07e080e7          	jalr	126(ra) # 800030de <brelse>
    brelse(dbuf);
    80004068:	8526                	mv	a0,s1
    8000406a:	fffff097          	auipc	ra,0xfffff
    8000406e:	074080e7          	jalr	116(ra) # 800030de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004072:	2a05                	addiw	s4,s4,1
    80004074:	0a91                	addi	s5,s5,4
    80004076:	02c9a783          	lw	a5,44(s3)
    8000407a:	04fa5e63          	bge	s4,a5,800040d6 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000407e:	0189a583          	lw	a1,24(s3)
    80004082:	014585bb          	addw	a1,a1,s4
    80004086:	2585                	addiw	a1,a1,1
    80004088:	0289a503          	lw	a0,40(s3)
    8000408c:	fffff097          	auipc	ra,0xfffff
    80004090:	f22080e7          	jalr	-222(ra) # 80002fae <bread>
    80004094:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004096:	000aa583          	lw	a1,0(s5)
    8000409a:	0289a503          	lw	a0,40(s3)
    8000409e:	fffff097          	auipc	ra,0xfffff
    800040a2:	f10080e7          	jalr	-240(ra) # 80002fae <bread>
    800040a6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800040a8:	40000613          	li	a2,1024
    800040ac:	05890593          	addi	a1,s2,88
    800040b0:	05850513          	addi	a0,a0,88
    800040b4:	ffffd097          	auipc	ra,0xffffd
    800040b8:	c7a080e7          	jalr	-902(ra) # 80000d2e <memmove>
    bwrite(dbuf);  // write dst to disk
    800040bc:	8526                	mv	a0,s1
    800040be:	fffff097          	auipc	ra,0xfffff
    800040c2:	fe2080e7          	jalr	-30(ra) # 800030a0 <bwrite>
    if(recovering == 0)
    800040c6:	f80b1ce3          	bnez	s6,8000405e <install_trans+0x36>
      bunpin(dbuf);
    800040ca:	8526                	mv	a0,s1
    800040cc:	fffff097          	auipc	ra,0xfffff
    800040d0:	0ec080e7          	jalr	236(ra) # 800031b8 <bunpin>
    800040d4:	b769                	j	8000405e <install_trans+0x36>
}
    800040d6:	70e2                	ld	ra,56(sp)
    800040d8:	7442                	ld	s0,48(sp)
    800040da:	74a2                	ld	s1,40(sp)
    800040dc:	7902                	ld	s2,32(sp)
    800040de:	69e2                	ld	s3,24(sp)
    800040e0:	6a42                	ld	s4,16(sp)
    800040e2:	6aa2                	ld	s5,8(sp)
    800040e4:	6b02                	ld	s6,0(sp)
    800040e6:	6121                	addi	sp,sp,64
    800040e8:	8082                	ret
    800040ea:	8082                	ret

00000000800040ec <initlog>:
{
    800040ec:	7179                	addi	sp,sp,-48
    800040ee:	f406                	sd	ra,40(sp)
    800040f0:	f022                	sd	s0,32(sp)
    800040f2:	ec26                	sd	s1,24(sp)
    800040f4:	e84a                	sd	s2,16(sp)
    800040f6:	e44e                	sd	s3,8(sp)
    800040f8:	1800                	addi	s0,sp,48
    800040fa:	892a                	mv	s2,a0
    800040fc:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800040fe:	0001d497          	auipc	s1,0x1d
    80004102:	b0248493          	addi	s1,s1,-1278 # 80020c00 <log>
    80004106:	00004597          	auipc	a1,0x4
    8000410a:	5ca58593          	addi	a1,a1,1482 # 800086d0 <syscalls+0x280>
    8000410e:	8526                	mv	a0,s1
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	a36080e7          	jalr	-1482(ra) # 80000b46 <initlock>
  log.start = sb->logstart;
    80004118:	0149a583          	lw	a1,20(s3)
    8000411c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000411e:	0109a783          	lw	a5,16(s3)
    80004122:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004124:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004128:	854a                	mv	a0,s2
    8000412a:	fffff097          	auipc	ra,0xfffff
    8000412e:	e84080e7          	jalr	-380(ra) # 80002fae <bread>
  log.lh.n = lh->n;
    80004132:	4d34                	lw	a3,88(a0)
    80004134:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004136:	02d05663          	blez	a3,80004162 <initlog+0x76>
    8000413a:	05c50793          	addi	a5,a0,92
    8000413e:	0001d717          	auipc	a4,0x1d
    80004142:	af270713          	addi	a4,a4,-1294 # 80020c30 <log+0x30>
    80004146:	36fd                	addiw	a3,a3,-1
    80004148:	02069613          	slli	a2,a3,0x20
    8000414c:	01e65693          	srli	a3,a2,0x1e
    80004150:	06050613          	addi	a2,a0,96
    80004154:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004156:	4390                	lw	a2,0(a5)
    80004158:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000415a:	0791                	addi	a5,a5,4
    8000415c:	0711                	addi	a4,a4,4
    8000415e:	fed79ce3          	bne	a5,a3,80004156 <initlog+0x6a>
  brelse(buf);
    80004162:	fffff097          	auipc	ra,0xfffff
    80004166:	f7c080e7          	jalr	-132(ra) # 800030de <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000416a:	4505                	li	a0,1
    8000416c:	00000097          	auipc	ra,0x0
    80004170:	ebc080e7          	jalr	-324(ra) # 80004028 <install_trans>
  log.lh.n = 0;
    80004174:	0001d797          	auipc	a5,0x1d
    80004178:	aa07ac23          	sw	zero,-1352(a5) # 80020c2c <log+0x2c>
  write_head(); // clear the log
    8000417c:	00000097          	auipc	ra,0x0
    80004180:	e30080e7          	jalr	-464(ra) # 80003fac <write_head>
}
    80004184:	70a2                	ld	ra,40(sp)
    80004186:	7402                	ld	s0,32(sp)
    80004188:	64e2                	ld	s1,24(sp)
    8000418a:	6942                	ld	s2,16(sp)
    8000418c:	69a2                	ld	s3,8(sp)
    8000418e:	6145                	addi	sp,sp,48
    80004190:	8082                	ret

0000000080004192 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004192:	1101                	addi	sp,sp,-32
    80004194:	ec06                	sd	ra,24(sp)
    80004196:	e822                	sd	s0,16(sp)
    80004198:	e426                	sd	s1,8(sp)
    8000419a:	e04a                	sd	s2,0(sp)
    8000419c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000419e:	0001d517          	auipc	a0,0x1d
    800041a2:	a6250513          	addi	a0,a0,-1438 # 80020c00 <log>
    800041a6:	ffffd097          	auipc	ra,0xffffd
    800041aa:	a30080e7          	jalr	-1488(ra) # 80000bd6 <acquire>
  while(1){
    if(log.committing){
    800041ae:	0001d497          	auipc	s1,0x1d
    800041b2:	a5248493          	addi	s1,s1,-1454 # 80020c00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800041b6:	4979                	li	s2,30
    800041b8:	a039                	j	800041c6 <begin_op+0x34>
      sleep(&log, &log.lock);
    800041ba:	85a6                	mv	a1,s1
    800041bc:	8526                	mv	a0,s1
    800041be:	ffffe097          	auipc	ra,0xffffe
    800041c2:	e96080e7          	jalr	-362(ra) # 80002054 <sleep>
    if(log.committing){
    800041c6:	50dc                	lw	a5,36(s1)
    800041c8:	fbed                	bnez	a5,800041ba <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800041ca:	5098                	lw	a4,32(s1)
    800041cc:	2705                	addiw	a4,a4,1
    800041ce:	0007069b          	sext.w	a3,a4
    800041d2:	0027179b          	slliw	a5,a4,0x2
    800041d6:	9fb9                	addw	a5,a5,a4
    800041d8:	0017979b          	slliw	a5,a5,0x1
    800041dc:	54d8                	lw	a4,44(s1)
    800041de:	9fb9                	addw	a5,a5,a4
    800041e0:	00f95963          	bge	s2,a5,800041f2 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800041e4:	85a6                	mv	a1,s1
    800041e6:	8526                	mv	a0,s1
    800041e8:	ffffe097          	auipc	ra,0xffffe
    800041ec:	e6c080e7          	jalr	-404(ra) # 80002054 <sleep>
    800041f0:	bfd9                	j	800041c6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800041f2:	0001d517          	auipc	a0,0x1d
    800041f6:	a0e50513          	addi	a0,a0,-1522 # 80020c00 <log>
    800041fa:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800041fc:	ffffd097          	auipc	ra,0xffffd
    80004200:	a8e080e7          	jalr	-1394(ra) # 80000c8a <release>
      break;
    }
  }
}
    80004204:	60e2                	ld	ra,24(sp)
    80004206:	6442                	ld	s0,16(sp)
    80004208:	64a2                	ld	s1,8(sp)
    8000420a:	6902                	ld	s2,0(sp)
    8000420c:	6105                	addi	sp,sp,32
    8000420e:	8082                	ret

0000000080004210 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004210:	7139                	addi	sp,sp,-64
    80004212:	fc06                	sd	ra,56(sp)
    80004214:	f822                	sd	s0,48(sp)
    80004216:	f426                	sd	s1,40(sp)
    80004218:	f04a                	sd	s2,32(sp)
    8000421a:	ec4e                	sd	s3,24(sp)
    8000421c:	e852                	sd	s4,16(sp)
    8000421e:	e456                	sd	s5,8(sp)
    80004220:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004222:	0001d497          	auipc	s1,0x1d
    80004226:	9de48493          	addi	s1,s1,-1570 # 80020c00 <log>
    8000422a:	8526                	mv	a0,s1
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	9aa080e7          	jalr	-1622(ra) # 80000bd6 <acquire>
  log.outstanding -= 1;
    80004234:	509c                	lw	a5,32(s1)
    80004236:	37fd                	addiw	a5,a5,-1
    80004238:	0007891b          	sext.w	s2,a5
    8000423c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000423e:	50dc                	lw	a5,36(s1)
    80004240:	e7b9                	bnez	a5,8000428e <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004242:	04091e63          	bnez	s2,8000429e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004246:	0001d497          	auipc	s1,0x1d
    8000424a:	9ba48493          	addi	s1,s1,-1606 # 80020c00 <log>
    8000424e:	4785                	li	a5,1
    80004250:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004252:	8526                	mv	a0,s1
    80004254:	ffffd097          	auipc	ra,0xffffd
    80004258:	a36080e7          	jalr	-1482(ra) # 80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000425c:	54dc                	lw	a5,44(s1)
    8000425e:	06f04763          	bgtz	a5,800042cc <end_op+0xbc>
    acquire(&log.lock);
    80004262:	0001d497          	auipc	s1,0x1d
    80004266:	99e48493          	addi	s1,s1,-1634 # 80020c00 <log>
    8000426a:	8526                	mv	a0,s1
    8000426c:	ffffd097          	auipc	ra,0xffffd
    80004270:	96a080e7          	jalr	-1686(ra) # 80000bd6 <acquire>
    log.committing = 0;
    80004274:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004278:	8526                	mv	a0,s1
    8000427a:	ffffe097          	auipc	ra,0xffffe
    8000427e:	e3e080e7          	jalr	-450(ra) # 800020b8 <wakeup>
    release(&log.lock);
    80004282:	8526                	mv	a0,s1
    80004284:	ffffd097          	auipc	ra,0xffffd
    80004288:	a06080e7          	jalr	-1530(ra) # 80000c8a <release>
}
    8000428c:	a03d                	j	800042ba <end_op+0xaa>
    panic("log.committing");
    8000428e:	00004517          	auipc	a0,0x4
    80004292:	44a50513          	addi	a0,a0,1098 # 800086d8 <syscalls+0x288>
    80004296:	ffffc097          	auipc	ra,0xffffc
    8000429a:	2aa080e7          	jalr	682(ra) # 80000540 <panic>
    wakeup(&log);
    8000429e:	0001d497          	auipc	s1,0x1d
    800042a2:	96248493          	addi	s1,s1,-1694 # 80020c00 <log>
    800042a6:	8526                	mv	a0,s1
    800042a8:	ffffe097          	auipc	ra,0xffffe
    800042ac:	e10080e7          	jalr	-496(ra) # 800020b8 <wakeup>
  release(&log.lock);
    800042b0:	8526                	mv	a0,s1
    800042b2:	ffffd097          	auipc	ra,0xffffd
    800042b6:	9d8080e7          	jalr	-1576(ra) # 80000c8a <release>
}
    800042ba:	70e2                	ld	ra,56(sp)
    800042bc:	7442                	ld	s0,48(sp)
    800042be:	74a2                	ld	s1,40(sp)
    800042c0:	7902                	ld	s2,32(sp)
    800042c2:	69e2                	ld	s3,24(sp)
    800042c4:	6a42                	ld	s4,16(sp)
    800042c6:	6aa2                	ld	s5,8(sp)
    800042c8:	6121                	addi	sp,sp,64
    800042ca:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800042cc:	0001da97          	auipc	s5,0x1d
    800042d0:	964a8a93          	addi	s5,s5,-1692 # 80020c30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800042d4:	0001da17          	auipc	s4,0x1d
    800042d8:	92ca0a13          	addi	s4,s4,-1748 # 80020c00 <log>
    800042dc:	018a2583          	lw	a1,24(s4)
    800042e0:	012585bb          	addw	a1,a1,s2
    800042e4:	2585                	addiw	a1,a1,1
    800042e6:	028a2503          	lw	a0,40(s4)
    800042ea:	fffff097          	auipc	ra,0xfffff
    800042ee:	cc4080e7          	jalr	-828(ra) # 80002fae <bread>
    800042f2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800042f4:	000aa583          	lw	a1,0(s5)
    800042f8:	028a2503          	lw	a0,40(s4)
    800042fc:	fffff097          	auipc	ra,0xfffff
    80004300:	cb2080e7          	jalr	-846(ra) # 80002fae <bread>
    80004304:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004306:	40000613          	li	a2,1024
    8000430a:	05850593          	addi	a1,a0,88
    8000430e:	05848513          	addi	a0,s1,88
    80004312:	ffffd097          	auipc	ra,0xffffd
    80004316:	a1c080e7          	jalr	-1508(ra) # 80000d2e <memmove>
    bwrite(to);  // write the log
    8000431a:	8526                	mv	a0,s1
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	d84080e7          	jalr	-636(ra) # 800030a0 <bwrite>
    brelse(from);
    80004324:	854e                	mv	a0,s3
    80004326:	fffff097          	auipc	ra,0xfffff
    8000432a:	db8080e7          	jalr	-584(ra) # 800030de <brelse>
    brelse(to);
    8000432e:	8526                	mv	a0,s1
    80004330:	fffff097          	auipc	ra,0xfffff
    80004334:	dae080e7          	jalr	-594(ra) # 800030de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004338:	2905                	addiw	s2,s2,1
    8000433a:	0a91                	addi	s5,s5,4
    8000433c:	02ca2783          	lw	a5,44(s4)
    80004340:	f8f94ee3          	blt	s2,a5,800042dc <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004344:	00000097          	auipc	ra,0x0
    80004348:	c68080e7          	jalr	-920(ra) # 80003fac <write_head>
    install_trans(0); // Now install writes to home locations
    8000434c:	4501                	li	a0,0
    8000434e:	00000097          	auipc	ra,0x0
    80004352:	cda080e7          	jalr	-806(ra) # 80004028 <install_trans>
    log.lh.n = 0;
    80004356:	0001d797          	auipc	a5,0x1d
    8000435a:	8c07ab23          	sw	zero,-1834(a5) # 80020c2c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000435e:	00000097          	auipc	ra,0x0
    80004362:	c4e080e7          	jalr	-946(ra) # 80003fac <write_head>
    80004366:	bdf5                	j	80004262 <end_op+0x52>

0000000080004368 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004368:	1101                	addi	sp,sp,-32
    8000436a:	ec06                	sd	ra,24(sp)
    8000436c:	e822                	sd	s0,16(sp)
    8000436e:	e426                	sd	s1,8(sp)
    80004370:	e04a                	sd	s2,0(sp)
    80004372:	1000                	addi	s0,sp,32
    80004374:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004376:	0001d917          	auipc	s2,0x1d
    8000437a:	88a90913          	addi	s2,s2,-1910 # 80020c00 <log>
    8000437e:	854a                	mv	a0,s2
    80004380:	ffffd097          	auipc	ra,0xffffd
    80004384:	856080e7          	jalr	-1962(ra) # 80000bd6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004388:	02c92603          	lw	a2,44(s2)
    8000438c:	47f5                	li	a5,29
    8000438e:	06c7c563          	blt	a5,a2,800043f8 <log_write+0x90>
    80004392:	0001d797          	auipc	a5,0x1d
    80004396:	88a7a783          	lw	a5,-1910(a5) # 80020c1c <log+0x1c>
    8000439a:	37fd                	addiw	a5,a5,-1
    8000439c:	04f65e63          	bge	a2,a5,800043f8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800043a0:	0001d797          	auipc	a5,0x1d
    800043a4:	8807a783          	lw	a5,-1920(a5) # 80020c20 <log+0x20>
    800043a8:	06f05063          	blez	a5,80004408 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800043ac:	4781                	li	a5,0
    800043ae:	06c05563          	blez	a2,80004418 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800043b2:	44cc                	lw	a1,12(s1)
    800043b4:	0001d717          	auipc	a4,0x1d
    800043b8:	87c70713          	addi	a4,a4,-1924 # 80020c30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800043bc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800043be:	4314                	lw	a3,0(a4)
    800043c0:	04b68c63          	beq	a3,a1,80004418 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800043c4:	2785                	addiw	a5,a5,1
    800043c6:	0711                	addi	a4,a4,4
    800043c8:	fef61be3          	bne	a2,a5,800043be <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800043cc:	0621                	addi	a2,a2,8
    800043ce:	060a                	slli	a2,a2,0x2
    800043d0:	0001d797          	auipc	a5,0x1d
    800043d4:	83078793          	addi	a5,a5,-2000 # 80020c00 <log>
    800043d8:	97b2                	add	a5,a5,a2
    800043da:	44d8                	lw	a4,12(s1)
    800043dc:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800043de:	8526                	mv	a0,s1
    800043e0:	fffff097          	auipc	ra,0xfffff
    800043e4:	d9c080e7          	jalr	-612(ra) # 8000317c <bpin>
    log.lh.n++;
    800043e8:	0001d717          	auipc	a4,0x1d
    800043ec:	81870713          	addi	a4,a4,-2024 # 80020c00 <log>
    800043f0:	575c                	lw	a5,44(a4)
    800043f2:	2785                	addiw	a5,a5,1
    800043f4:	d75c                	sw	a5,44(a4)
    800043f6:	a82d                	j	80004430 <log_write+0xc8>
    panic("too big a transaction");
    800043f8:	00004517          	auipc	a0,0x4
    800043fc:	2f050513          	addi	a0,a0,752 # 800086e8 <syscalls+0x298>
    80004400:	ffffc097          	auipc	ra,0xffffc
    80004404:	140080e7          	jalr	320(ra) # 80000540 <panic>
    panic("log_write outside of trans");
    80004408:	00004517          	auipc	a0,0x4
    8000440c:	2f850513          	addi	a0,a0,760 # 80008700 <syscalls+0x2b0>
    80004410:	ffffc097          	auipc	ra,0xffffc
    80004414:	130080e7          	jalr	304(ra) # 80000540 <panic>
  log.lh.block[i] = b->blockno;
    80004418:	00878693          	addi	a3,a5,8
    8000441c:	068a                	slli	a3,a3,0x2
    8000441e:	0001c717          	auipc	a4,0x1c
    80004422:	7e270713          	addi	a4,a4,2018 # 80020c00 <log>
    80004426:	9736                	add	a4,a4,a3
    80004428:	44d4                	lw	a3,12(s1)
    8000442a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000442c:	faf609e3          	beq	a2,a5,800043de <log_write+0x76>
  }
  release(&log.lock);
    80004430:	0001c517          	auipc	a0,0x1c
    80004434:	7d050513          	addi	a0,a0,2000 # 80020c00 <log>
    80004438:	ffffd097          	auipc	ra,0xffffd
    8000443c:	852080e7          	jalr	-1966(ra) # 80000c8a <release>
}
    80004440:	60e2                	ld	ra,24(sp)
    80004442:	6442                	ld	s0,16(sp)
    80004444:	64a2                	ld	s1,8(sp)
    80004446:	6902                	ld	s2,0(sp)
    80004448:	6105                	addi	sp,sp,32
    8000444a:	8082                	ret

000000008000444c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000444c:	1101                	addi	sp,sp,-32
    8000444e:	ec06                	sd	ra,24(sp)
    80004450:	e822                	sd	s0,16(sp)
    80004452:	e426                	sd	s1,8(sp)
    80004454:	e04a                	sd	s2,0(sp)
    80004456:	1000                	addi	s0,sp,32
    80004458:	84aa                	mv	s1,a0
    8000445a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000445c:	00004597          	auipc	a1,0x4
    80004460:	2c458593          	addi	a1,a1,708 # 80008720 <syscalls+0x2d0>
    80004464:	0521                	addi	a0,a0,8
    80004466:	ffffc097          	auipc	ra,0xffffc
    8000446a:	6e0080e7          	jalr	1760(ra) # 80000b46 <initlock>
  lk->name = name;
    8000446e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004472:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004476:	0204a423          	sw	zero,40(s1)
}
    8000447a:	60e2                	ld	ra,24(sp)
    8000447c:	6442                	ld	s0,16(sp)
    8000447e:	64a2                	ld	s1,8(sp)
    80004480:	6902                	ld	s2,0(sp)
    80004482:	6105                	addi	sp,sp,32
    80004484:	8082                	ret

0000000080004486 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004486:	1101                	addi	sp,sp,-32
    80004488:	ec06                	sd	ra,24(sp)
    8000448a:	e822                	sd	s0,16(sp)
    8000448c:	e426                	sd	s1,8(sp)
    8000448e:	e04a                	sd	s2,0(sp)
    80004490:	1000                	addi	s0,sp,32
    80004492:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004494:	00850913          	addi	s2,a0,8
    80004498:	854a                	mv	a0,s2
    8000449a:	ffffc097          	auipc	ra,0xffffc
    8000449e:	73c080e7          	jalr	1852(ra) # 80000bd6 <acquire>
  while (lk->locked) {
    800044a2:	409c                	lw	a5,0(s1)
    800044a4:	cb89                	beqz	a5,800044b6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800044a6:	85ca                	mv	a1,s2
    800044a8:	8526                	mv	a0,s1
    800044aa:	ffffe097          	auipc	ra,0xffffe
    800044ae:	baa080e7          	jalr	-1110(ra) # 80002054 <sleep>
  while (lk->locked) {
    800044b2:	409c                	lw	a5,0(s1)
    800044b4:	fbed                	bnez	a5,800044a6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800044b6:	4785                	li	a5,1
    800044b8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800044ba:	ffffd097          	auipc	ra,0xffffd
    800044be:	4f2080e7          	jalr	1266(ra) # 800019ac <myproc>
    800044c2:	591c                	lw	a5,48(a0)
    800044c4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800044c6:	854a                	mv	a0,s2
    800044c8:	ffffc097          	auipc	ra,0xffffc
    800044cc:	7c2080e7          	jalr	1986(ra) # 80000c8a <release>
}
    800044d0:	60e2                	ld	ra,24(sp)
    800044d2:	6442                	ld	s0,16(sp)
    800044d4:	64a2                	ld	s1,8(sp)
    800044d6:	6902                	ld	s2,0(sp)
    800044d8:	6105                	addi	sp,sp,32
    800044da:	8082                	ret

00000000800044dc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800044dc:	1101                	addi	sp,sp,-32
    800044de:	ec06                	sd	ra,24(sp)
    800044e0:	e822                	sd	s0,16(sp)
    800044e2:	e426                	sd	s1,8(sp)
    800044e4:	e04a                	sd	s2,0(sp)
    800044e6:	1000                	addi	s0,sp,32
    800044e8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800044ea:	00850913          	addi	s2,a0,8
    800044ee:	854a                	mv	a0,s2
    800044f0:	ffffc097          	auipc	ra,0xffffc
    800044f4:	6e6080e7          	jalr	1766(ra) # 80000bd6 <acquire>
  lk->locked = 0;
    800044f8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800044fc:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004500:	8526                	mv	a0,s1
    80004502:	ffffe097          	auipc	ra,0xffffe
    80004506:	bb6080e7          	jalr	-1098(ra) # 800020b8 <wakeup>
  release(&lk->lk);
    8000450a:	854a                	mv	a0,s2
    8000450c:	ffffc097          	auipc	ra,0xffffc
    80004510:	77e080e7          	jalr	1918(ra) # 80000c8a <release>
}
    80004514:	60e2                	ld	ra,24(sp)
    80004516:	6442                	ld	s0,16(sp)
    80004518:	64a2                	ld	s1,8(sp)
    8000451a:	6902                	ld	s2,0(sp)
    8000451c:	6105                	addi	sp,sp,32
    8000451e:	8082                	ret

0000000080004520 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004520:	7179                	addi	sp,sp,-48
    80004522:	f406                	sd	ra,40(sp)
    80004524:	f022                	sd	s0,32(sp)
    80004526:	ec26                	sd	s1,24(sp)
    80004528:	e84a                	sd	s2,16(sp)
    8000452a:	e44e                	sd	s3,8(sp)
    8000452c:	1800                	addi	s0,sp,48
    8000452e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004530:	00850913          	addi	s2,a0,8
    80004534:	854a                	mv	a0,s2
    80004536:	ffffc097          	auipc	ra,0xffffc
    8000453a:	6a0080e7          	jalr	1696(ra) # 80000bd6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000453e:	409c                	lw	a5,0(s1)
    80004540:	ef99                	bnez	a5,8000455e <holdingsleep+0x3e>
    80004542:	4481                	li	s1,0
  release(&lk->lk);
    80004544:	854a                	mv	a0,s2
    80004546:	ffffc097          	auipc	ra,0xffffc
    8000454a:	744080e7          	jalr	1860(ra) # 80000c8a <release>
  return r;
}
    8000454e:	8526                	mv	a0,s1
    80004550:	70a2                	ld	ra,40(sp)
    80004552:	7402                	ld	s0,32(sp)
    80004554:	64e2                	ld	s1,24(sp)
    80004556:	6942                	ld	s2,16(sp)
    80004558:	69a2                	ld	s3,8(sp)
    8000455a:	6145                	addi	sp,sp,48
    8000455c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000455e:	0284a983          	lw	s3,40(s1)
    80004562:	ffffd097          	auipc	ra,0xffffd
    80004566:	44a080e7          	jalr	1098(ra) # 800019ac <myproc>
    8000456a:	5904                	lw	s1,48(a0)
    8000456c:	413484b3          	sub	s1,s1,s3
    80004570:	0014b493          	seqz	s1,s1
    80004574:	bfc1                	j	80004544 <holdingsleep+0x24>

0000000080004576 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004576:	1141                	addi	sp,sp,-16
    80004578:	e406                	sd	ra,8(sp)
    8000457a:	e022                	sd	s0,0(sp)
    8000457c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000457e:	00004597          	auipc	a1,0x4
    80004582:	1b258593          	addi	a1,a1,434 # 80008730 <syscalls+0x2e0>
    80004586:	0001c517          	auipc	a0,0x1c
    8000458a:	7c250513          	addi	a0,a0,1986 # 80020d48 <ftable>
    8000458e:	ffffc097          	auipc	ra,0xffffc
    80004592:	5b8080e7          	jalr	1464(ra) # 80000b46 <initlock>
}
    80004596:	60a2                	ld	ra,8(sp)
    80004598:	6402                	ld	s0,0(sp)
    8000459a:	0141                	addi	sp,sp,16
    8000459c:	8082                	ret

000000008000459e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000459e:	1101                	addi	sp,sp,-32
    800045a0:	ec06                	sd	ra,24(sp)
    800045a2:	e822                	sd	s0,16(sp)
    800045a4:	e426                	sd	s1,8(sp)
    800045a6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800045a8:	0001c517          	auipc	a0,0x1c
    800045ac:	7a050513          	addi	a0,a0,1952 # 80020d48 <ftable>
    800045b0:	ffffc097          	auipc	ra,0xffffc
    800045b4:	626080e7          	jalr	1574(ra) # 80000bd6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045b8:	0001c497          	auipc	s1,0x1c
    800045bc:	7a848493          	addi	s1,s1,1960 # 80020d60 <ftable+0x18>
    800045c0:	0001d717          	auipc	a4,0x1d
    800045c4:	74070713          	addi	a4,a4,1856 # 80021d00 <disk>
    if(f->ref == 0){
    800045c8:	40dc                	lw	a5,4(s1)
    800045ca:	cf99                	beqz	a5,800045e8 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045cc:	02848493          	addi	s1,s1,40
    800045d0:	fee49ce3          	bne	s1,a4,800045c8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800045d4:	0001c517          	auipc	a0,0x1c
    800045d8:	77450513          	addi	a0,a0,1908 # 80020d48 <ftable>
    800045dc:	ffffc097          	auipc	ra,0xffffc
    800045e0:	6ae080e7          	jalr	1710(ra) # 80000c8a <release>
  return 0;
    800045e4:	4481                	li	s1,0
    800045e6:	a819                	j	800045fc <filealloc+0x5e>
      f->ref = 1;
    800045e8:	4785                	li	a5,1
    800045ea:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800045ec:	0001c517          	auipc	a0,0x1c
    800045f0:	75c50513          	addi	a0,a0,1884 # 80020d48 <ftable>
    800045f4:	ffffc097          	auipc	ra,0xffffc
    800045f8:	696080e7          	jalr	1686(ra) # 80000c8a <release>
}
    800045fc:	8526                	mv	a0,s1
    800045fe:	60e2                	ld	ra,24(sp)
    80004600:	6442                	ld	s0,16(sp)
    80004602:	64a2                	ld	s1,8(sp)
    80004604:	6105                	addi	sp,sp,32
    80004606:	8082                	ret

0000000080004608 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004608:	1101                	addi	sp,sp,-32
    8000460a:	ec06                	sd	ra,24(sp)
    8000460c:	e822                	sd	s0,16(sp)
    8000460e:	e426                	sd	s1,8(sp)
    80004610:	1000                	addi	s0,sp,32
    80004612:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004614:	0001c517          	auipc	a0,0x1c
    80004618:	73450513          	addi	a0,a0,1844 # 80020d48 <ftable>
    8000461c:	ffffc097          	auipc	ra,0xffffc
    80004620:	5ba080e7          	jalr	1466(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    80004624:	40dc                	lw	a5,4(s1)
    80004626:	02f05263          	blez	a5,8000464a <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000462a:	2785                	addiw	a5,a5,1
    8000462c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000462e:	0001c517          	auipc	a0,0x1c
    80004632:	71a50513          	addi	a0,a0,1818 # 80020d48 <ftable>
    80004636:	ffffc097          	auipc	ra,0xffffc
    8000463a:	654080e7          	jalr	1620(ra) # 80000c8a <release>
  return f;
}
    8000463e:	8526                	mv	a0,s1
    80004640:	60e2                	ld	ra,24(sp)
    80004642:	6442                	ld	s0,16(sp)
    80004644:	64a2                	ld	s1,8(sp)
    80004646:	6105                	addi	sp,sp,32
    80004648:	8082                	ret
    panic("filedup");
    8000464a:	00004517          	auipc	a0,0x4
    8000464e:	0ee50513          	addi	a0,a0,238 # 80008738 <syscalls+0x2e8>
    80004652:	ffffc097          	auipc	ra,0xffffc
    80004656:	eee080e7          	jalr	-274(ra) # 80000540 <panic>

000000008000465a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000465a:	7139                	addi	sp,sp,-64
    8000465c:	fc06                	sd	ra,56(sp)
    8000465e:	f822                	sd	s0,48(sp)
    80004660:	f426                	sd	s1,40(sp)
    80004662:	f04a                	sd	s2,32(sp)
    80004664:	ec4e                	sd	s3,24(sp)
    80004666:	e852                	sd	s4,16(sp)
    80004668:	e456                	sd	s5,8(sp)
    8000466a:	0080                	addi	s0,sp,64
    8000466c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000466e:	0001c517          	auipc	a0,0x1c
    80004672:	6da50513          	addi	a0,a0,1754 # 80020d48 <ftable>
    80004676:	ffffc097          	auipc	ra,0xffffc
    8000467a:	560080e7          	jalr	1376(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    8000467e:	40dc                	lw	a5,4(s1)
    80004680:	06f05163          	blez	a5,800046e2 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004684:	37fd                	addiw	a5,a5,-1
    80004686:	0007871b          	sext.w	a4,a5
    8000468a:	c0dc                	sw	a5,4(s1)
    8000468c:	06e04363          	bgtz	a4,800046f2 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004690:	0004a903          	lw	s2,0(s1)
    80004694:	0094ca83          	lbu	s5,9(s1)
    80004698:	0104ba03          	ld	s4,16(s1)
    8000469c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800046a0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800046a4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800046a8:	0001c517          	auipc	a0,0x1c
    800046ac:	6a050513          	addi	a0,a0,1696 # 80020d48 <ftable>
    800046b0:	ffffc097          	auipc	ra,0xffffc
    800046b4:	5da080e7          	jalr	1498(ra) # 80000c8a <release>

  if(ff.type == FD_PIPE){
    800046b8:	4785                	li	a5,1
    800046ba:	04f90d63          	beq	s2,a5,80004714 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800046be:	3979                	addiw	s2,s2,-2
    800046c0:	4785                	li	a5,1
    800046c2:	0527e063          	bltu	a5,s2,80004702 <fileclose+0xa8>
    begin_op();
    800046c6:	00000097          	auipc	ra,0x0
    800046ca:	acc080e7          	jalr	-1332(ra) # 80004192 <begin_op>
    iput(ff.ip);
    800046ce:	854e                	mv	a0,s3
    800046d0:	fffff097          	auipc	ra,0xfffff
    800046d4:	2b0080e7          	jalr	688(ra) # 80003980 <iput>
    end_op();
    800046d8:	00000097          	auipc	ra,0x0
    800046dc:	b38080e7          	jalr	-1224(ra) # 80004210 <end_op>
    800046e0:	a00d                	j	80004702 <fileclose+0xa8>
    panic("fileclose");
    800046e2:	00004517          	auipc	a0,0x4
    800046e6:	05e50513          	addi	a0,a0,94 # 80008740 <syscalls+0x2f0>
    800046ea:	ffffc097          	auipc	ra,0xffffc
    800046ee:	e56080e7          	jalr	-426(ra) # 80000540 <panic>
    release(&ftable.lock);
    800046f2:	0001c517          	auipc	a0,0x1c
    800046f6:	65650513          	addi	a0,a0,1622 # 80020d48 <ftable>
    800046fa:	ffffc097          	auipc	ra,0xffffc
    800046fe:	590080e7          	jalr	1424(ra) # 80000c8a <release>
  }
}
    80004702:	70e2                	ld	ra,56(sp)
    80004704:	7442                	ld	s0,48(sp)
    80004706:	74a2                	ld	s1,40(sp)
    80004708:	7902                	ld	s2,32(sp)
    8000470a:	69e2                	ld	s3,24(sp)
    8000470c:	6a42                	ld	s4,16(sp)
    8000470e:	6aa2                	ld	s5,8(sp)
    80004710:	6121                	addi	sp,sp,64
    80004712:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004714:	85d6                	mv	a1,s5
    80004716:	8552                	mv	a0,s4
    80004718:	00000097          	auipc	ra,0x0
    8000471c:	34c080e7          	jalr	844(ra) # 80004a64 <pipeclose>
    80004720:	b7cd                	j	80004702 <fileclose+0xa8>

0000000080004722 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004722:	715d                	addi	sp,sp,-80
    80004724:	e486                	sd	ra,72(sp)
    80004726:	e0a2                	sd	s0,64(sp)
    80004728:	fc26                	sd	s1,56(sp)
    8000472a:	f84a                	sd	s2,48(sp)
    8000472c:	f44e                	sd	s3,40(sp)
    8000472e:	0880                	addi	s0,sp,80
    80004730:	84aa                	mv	s1,a0
    80004732:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004734:	ffffd097          	auipc	ra,0xffffd
    80004738:	278080e7          	jalr	632(ra) # 800019ac <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000473c:	409c                	lw	a5,0(s1)
    8000473e:	37f9                	addiw	a5,a5,-2
    80004740:	4705                	li	a4,1
    80004742:	04f76763          	bltu	a4,a5,80004790 <filestat+0x6e>
    80004746:	892a                	mv	s2,a0
    ilock(f->ip);
    80004748:	6c88                	ld	a0,24(s1)
    8000474a:	fffff097          	auipc	ra,0xfffff
    8000474e:	07c080e7          	jalr	124(ra) # 800037c6 <ilock>
    stati(f->ip, &st);
    80004752:	fb840593          	addi	a1,s0,-72
    80004756:	6c88                	ld	a0,24(s1)
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	2f8080e7          	jalr	760(ra) # 80003a50 <stati>
    iunlock(f->ip);
    80004760:	6c88                	ld	a0,24(s1)
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	126080e7          	jalr	294(ra) # 80003888 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000476a:	46e1                	li	a3,24
    8000476c:	fb840613          	addi	a2,s0,-72
    80004770:	85ce                	mv	a1,s3
    80004772:	05093503          	ld	a0,80(s2)
    80004776:	ffffd097          	auipc	ra,0xffffd
    8000477a:	ef6080e7          	jalr	-266(ra) # 8000166c <copyout>
    8000477e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004782:	60a6                	ld	ra,72(sp)
    80004784:	6406                	ld	s0,64(sp)
    80004786:	74e2                	ld	s1,56(sp)
    80004788:	7942                	ld	s2,48(sp)
    8000478a:	79a2                	ld	s3,40(sp)
    8000478c:	6161                	addi	sp,sp,80
    8000478e:	8082                	ret
  return -1;
    80004790:	557d                	li	a0,-1
    80004792:	bfc5                	j	80004782 <filestat+0x60>

0000000080004794 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004794:	7179                	addi	sp,sp,-48
    80004796:	f406                	sd	ra,40(sp)
    80004798:	f022                	sd	s0,32(sp)
    8000479a:	ec26                	sd	s1,24(sp)
    8000479c:	e84a                	sd	s2,16(sp)
    8000479e:	e44e                	sd	s3,8(sp)
    800047a0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800047a2:	00854783          	lbu	a5,8(a0)
    800047a6:	c3d5                	beqz	a5,8000484a <fileread+0xb6>
    800047a8:	84aa                	mv	s1,a0
    800047aa:	89ae                	mv	s3,a1
    800047ac:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800047ae:	411c                	lw	a5,0(a0)
    800047b0:	4705                	li	a4,1
    800047b2:	04e78963          	beq	a5,a4,80004804 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047b6:	470d                	li	a4,3
    800047b8:	04e78d63          	beq	a5,a4,80004812 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800047bc:	4709                	li	a4,2
    800047be:	06e79e63          	bne	a5,a4,8000483a <fileread+0xa6>
    ilock(f->ip);
    800047c2:	6d08                	ld	a0,24(a0)
    800047c4:	fffff097          	auipc	ra,0xfffff
    800047c8:	002080e7          	jalr	2(ra) # 800037c6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800047cc:	874a                	mv	a4,s2
    800047ce:	5094                	lw	a3,32(s1)
    800047d0:	864e                	mv	a2,s3
    800047d2:	4585                	li	a1,1
    800047d4:	6c88                	ld	a0,24(s1)
    800047d6:	fffff097          	auipc	ra,0xfffff
    800047da:	2a4080e7          	jalr	676(ra) # 80003a7a <readi>
    800047de:	892a                	mv	s2,a0
    800047e0:	00a05563          	blez	a0,800047ea <fileread+0x56>
      f->off += r;
    800047e4:	509c                	lw	a5,32(s1)
    800047e6:	9fa9                	addw	a5,a5,a0
    800047e8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800047ea:	6c88                	ld	a0,24(s1)
    800047ec:	fffff097          	auipc	ra,0xfffff
    800047f0:	09c080e7          	jalr	156(ra) # 80003888 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800047f4:	854a                	mv	a0,s2
    800047f6:	70a2                	ld	ra,40(sp)
    800047f8:	7402                	ld	s0,32(sp)
    800047fa:	64e2                	ld	s1,24(sp)
    800047fc:	6942                	ld	s2,16(sp)
    800047fe:	69a2                	ld	s3,8(sp)
    80004800:	6145                	addi	sp,sp,48
    80004802:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004804:	6908                	ld	a0,16(a0)
    80004806:	00000097          	auipc	ra,0x0
    8000480a:	3c6080e7          	jalr	966(ra) # 80004bcc <piperead>
    8000480e:	892a                	mv	s2,a0
    80004810:	b7d5                	j	800047f4 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004812:	02451783          	lh	a5,36(a0)
    80004816:	03079693          	slli	a3,a5,0x30
    8000481a:	92c1                	srli	a3,a3,0x30
    8000481c:	4725                	li	a4,9
    8000481e:	02d76863          	bltu	a4,a3,8000484e <fileread+0xba>
    80004822:	0792                	slli	a5,a5,0x4
    80004824:	0001c717          	auipc	a4,0x1c
    80004828:	48470713          	addi	a4,a4,1156 # 80020ca8 <devsw>
    8000482c:	97ba                	add	a5,a5,a4
    8000482e:	639c                	ld	a5,0(a5)
    80004830:	c38d                	beqz	a5,80004852 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004832:	4505                	li	a0,1
    80004834:	9782                	jalr	a5
    80004836:	892a                	mv	s2,a0
    80004838:	bf75                	j	800047f4 <fileread+0x60>
    panic("fileread");
    8000483a:	00004517          	auipc	a0,0x4
    8000483e:	f1650513          	addi	a0,a0,-234 # 80008750 <syscalls+0x300>
    80004842:	ffffc097          	auipc	ra,0xffffc
    80004846:	cfe080e7          	jalr	-770(ra) # 80000540 <panic>
    return -1;
    8000484a:	597d                	li	s2,-1
    8000484c:	b765                	j	800047f4 <fileread+0x60>
      return -1;
    8000484e:	597d                	li	s2,-1
    80004850:	b755                	j	800047f4 <fileread+0x60>
    80004852:	597d                	li	s2,-1
    80004854:	b745                	j	800047f4 <fileread+0x60>

0000000080004856 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004856:	715d                	addi	sp,sp,-80
    80004858:	e486                	sd	ra,72(sp)
    8000485a:	e0a2                	sd	s0,64(sp)
    8000485c:	fc26                	sd	s1,56(sp)
    8000485e:	f84a                	sd	s2,48(sp)
    80004860:	f44e                	sd	s3,40(sp)
    80004862:	f052                	sd	s4,32(sp)
    80004864:	ec56                	sd	s5,24(sp)
    80004866:	e85a                	sd	s6,16(sp)
    80004868:	e45e                	sd	s7,8(sp)
    8000486a:	e062                	sd	s8,0(sp)
    8000486c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    8000486e:	00954783          	lbu	a5,9(a0)
    80004872:	10078663          	beqz	a5,8000497e <filewrite+0x128>
    80004876:	892a                	mv	s2,a0
    80004878:	8b2e                	mv	s6,a1
    8000487a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000487c:	411c                	lw	a5,0(a0)
    8000487e:	4705                	li	a4,1
    80004880:	02e78263          	beq	a5,a4,800048a4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004884:	470d                	li	a4,3
    80004886:	02e78663          	beq	a5,a4,800048b2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000488a:	4709                	li	a4,2
    8000488c:	0ee79163          	bne	a5,a4,8000496e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004890:	0ac05d63          	blez	a2,8000494a <filewrite+0xf4>
    int i = 0;
    80004894:	4981                	li	s3,0
    80004896:	6b85                	lui	s7,0x1
    80004898:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000489c:	6c05                	lui	s8,0x1
    8000489e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800048a2:	a861                	j	8000493a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    800048a4:	6908                	ld	a0,16(a0)
    800048a6:	00000097          	auipc	ra,0x0
    800048aa:	22e080e7          	jalr	558(ra) # 80004ad4 <pipewrite>
    800048ae:	8a2a                	mv	s4,a0
    800048b0:	a045                	j	80004950 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800048b2:	02451783          	lh	a5,36(a0)
    800048b6:	03079693          	slli	a3,a5,0x30
    800048ba:	92c1                	srli	a3,a3,0x30
    800048bc:	4725                	li	a4,9
    800048be:	0cd76263          	bltu	a4,a3,80004982 <filewrite+0x12c>
    800048c2:	0792                	slli	a5,a5,0x4
    800048c4:	0001c717          	auipc	a4,0x1c
    800048c8:	3e470713          	addi	a4,a4,996 # 80020ca8 <devsw>
    800048cc:	97ba                	add	a5,a5,a4
    800048ce:	679c                	ld	a5,8(a5)
    800048d0:	cbdd                	beqz	a5,80004986 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    800048d2:	4505                	li	a0,1
    800048d4:	9782                	jalr	a5
    800048d6:	8a2a                	mv	s4,a0
    800048d8:	a8a5                	j	80004950 <filewrite+0xfa>
    800048da:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800048de:	00000097          	auipc	ra,0x0
    800048e2:	8b4080e7          	jalr	-1868(ra) # 80004192 <begin_op>
      ilock(f->ip);
    800048e6:	01893503          	ld	a0,24(s2)
    800048ea:	fffff097          	auipc	ra,0xfffff
    800048ee:	edc080e7          	jalr	-292(ra) # 800037c6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800048f2:	8756                	mv	a4,s5
    800048f4:	02092683          	lw	a3,32(s2)
    800048f8:	01698633          	add	a2,s3,s6
    800048fc:	4585                	li	a1,1
    800048fe:	01893503          	ld	a0,24(s2)
    80004902:	fffff097          	auipc	ra,0xfffff
    80004906:	270080e7          	jalr	624(ra) # 80003b72 <writei>
    8000490a:	84aa                	mv	s1,a0
    8000490c:	00a05763          	blez	a0,8000491a <filewrite+0xc4>
        f->off += r;
    80004910:	02092783          	lw	a5,32(s2)
    80004914:	9fa9                	addw	a5,a5,a0
    80004916:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000491a:	01893503          	ld	a0,24(s2)
    8000491e:	fffff097          	auipc	ra,0xfffff
    80004922:	f6a080e7          	jalr	-150(ra) # 80003888 <iunlock>
      end_op();
    80004926:	00000097          	auipc	ra,0x0
    8000492a:	8ea080e7          	jalr	-1814(ra) # 80004210 <end_op>

      if(r != n1){
    8000492e:	009a9f63          	bne	s5,s1,8000494c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004932:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004936:	0149db63          	bge	s3,s4,8000494c <filewrite+0xf6>
      int n1 = n - i;
    8000493a:	413a04bb          	subw	s1,s4,s3
    8000493e:	0004879b          	sext.w	a5,s1
    80004942:	f8fbdce3          	bge	s7,a5,800048da <filewrite+0x84>
    80004946:	84e2                	mv	s1,s8
    80004948:	bf49                	j	800048da <filewrite+0x84>
    int i = 0;
    8000494a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000494c:	013a1f63          	bne	s4,s3,8000496a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004950:	8552                	mv	a0,s4
    80004952:	60a6                	ld	ra,72(sp)
    80004954:	6406                	ld	s0,64(sp)
    80004956:	74e2                	ld	s1,56(sp)
    80004958:	7942                	ld	s2,48(sp)
    8000495a:	79a2                	ld	s3,40(sp)
    8000495c:	7a02                	ld	s4,32(sp)
    8000495e:	6ae2                	ld	s5,24(sp)
    80004960:	6b42                	ld	s6,16(sp)
    80004962:	6ba2                	ld	s7,8(sp)
    80004964:	6c02                	ld	s8,0(sp)
    80004966:	6161                	addi	sp,sp,80
    80004968:	8082                	ret
    ret = (i == n ? n : -1);
    8000496a:	5a7d                	li	s4,-1
    8000496c:	b7d5                	j	80004950 <filewrite+0xfa>
    panic("filewrite");
    8000496e:	00004517          	auipc	a0,0x4
    80004972:	df250513          	addi	a0,a0,-526 # 80008760 <syscalls+0x310>
    80004976:	ffffc097          	auipc	ra,0xffffc
    8000497a:	bca080e7          	jalr	-1078(ra) # 80000540 <panic>
    return -1;
    8000497e:	5a7d                	li	s4,-1
    80004980:	bfc1                	j	80004950 <filewrite+0xfa>
      return -1;
    80004982:	5a7d                	li	s4,-1
    80004984:	b7f1                	j	80004950 <filewrite+0xfa>
    80004986:	5a7d                	li	s4,-1
    80004988:	b7e1                	j	80004950 <filewrite+0xfa>

000000008000498a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000498a:	7179                	addi	sp,sp,-48
    8000498c:	f406                	sd	ra,40(sp)
    8000498e:	f022                	sd	s0,32(sp)
    80004990:	ec26                	sd	s1,24(sp)
    80004992:	e84a                	sd	s2,16(sp)
    80004994:	e44e                	sd	s3,8(sp)
    80004996:	e052                	sd	s4,0(sp)
    80004998:	1800                	addi	s0,sp,48
    8000499a:	84aa                	mv	s1,a0
    8000499c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000499e:	0005b023          	sd	zero,0(a1)
    800049a2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800049a6:	00000097          	auipc	ra,0x0
    800049aa:	bf8080e7          	jalr	-1032(ra) # 8000459e <filealloc>
    800049ae:	e088                	sd	a0,0(s1)
    800049b0:	c551                	beqz	a0,80004a3c <pipealloc+0xb2>
    800049b2:	00000097          	auipc	ra,0x0
    800049b6:	bec080e7          	jalr	-1044(ra) # 8000459e <filealloc>
    800049ba:	00aa3023          	sd	a0,0(s4)
    800049be:	c92d                	beqz	a0,80004a30 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800049c0:	ffffc097          	auipc	ra,0xffffc
    800049c4:	126080e7          	jalr	294(ra) # 80000ae6 <kalloc>
    800049c8:	892a                	mv	s2,a0
    800049ca:	c125                	beqz	a0,80004a2a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800049cc:	4985                	li	s3,1
    800049ce:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800049d2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800049d6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800049da:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800049de:	00004597          	auipc	a1,0x4
    800049e2:	d9258593          	addi	a1,a1,-622 # 80008770 <syscalls+0x320>
    800049e6:	ffffc097          	auipc	ra,0xffffc
    800049ea:	160080e7          	jalr	352(ra) # 80000b46 <initlock>
  (*f0)->type = FD_PIPE;
    800049ee:	609c                	ld	a5,0(s1)
    800049f0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800049f4:	609c                	ld	a5,0(s1)
    800049f6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800049fa:	609c                	ld	a5,0(s1)
    800049fc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004a00:	609c                	ld	a5,0(s1)
    80004a02:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004a06:	000a3783          	ld	a5,0(s4)
    80004a0a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004a0e:	000a3783          	ld	a5,0(s4)
    80004a12:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004a16:	000a3783          	ld	a5,0(s4)
    80004a1a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004a1e:	000a3783          	ld	a5,0(s4)
    80004a22:	0127b823          	sd	s2,16(a5)
  return 0;
    80004a26:	4501                	li	a0,0
    80004a28:	a025                	j	80004a50 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004a2a:	6088                	ld	a0,0(s1)
    80004a2c:	e501                	bnez	a0,80004a34 <pipealloc+0xaa>
    80004a2e:	a039                	j	80004a3c <pipealloc+0xb2>
    80004a30:	6088                	ld	a0,0(s1)
    80004a32:	c51d                	beqz	a0,80004a60 <pipealloc+0xd6>
    fileclose(*f0);
    80004a34:	00000097          	auipc	ra,0x0
    80004a38:	c26080e7          	jalr	-986(ra) # 8000465a <fileclose>
  if(*f1)
    80004a3c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004a40:	557d                	li	a0,-1
  if(*f1)
    80004a42:	c799                	beqz	a5,80004a50 <pipealloc+0xc6>
    fileclose(*f1);
    80004a44:	853e                	mv	a0,a5
    80004a46:	00000097          	auipc	ra,0x0
    80004a4a:	c14080e7          	jalr	-1004(ra) # 8000465a <fileclose>
  return -1;
    80004a4e:	557d                	li	a0,-1
}
    80004a50:	70a2                	ld	ra,40(sp)
    80004a52:	7402                	ld	s0,32(sp)
    80004a54:	64e2                	ld	s1,24(sp)
    80004a56:	6942                	ld	s2,16(sp)
    80004a58:	69a2                	ld	s3,8(sp)
    80004a5a:	6a02                	ld	s4,0(sp)
    80004a5c:	6145                	addi	sp,sp,48
    80004a5e:	8082                	ret
  return -1;
    80004a60:	557d                	li	a0,-1
    80004a62:	b7fd                	j	80004a50 <pipealloc+0xc6>

0000000080004a64 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004a64:	1101                	addi	sp,sp,-32
    80004a66:	ec06                	sd	ra,24(sp)
    80004a68:	e822                	sd	s0,16(sp)
    80004a6a:	e426                	sd	s1,8(sp)
    80004a6c:	e04a                	sd	s2,0(sp)
    80004a6e:	1000                	addi	s0,sp,32
    80004a70:	84aa                	mv	s1,a0
    80004a72:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004a74:	ffffc097          	auipc	ra,0xffffc
    80004a78:	162080e7          	jalr	354(ra) # 80000bd6 <acquire>
  if(writable){
    80004a7c:	02090d63          	beqz	s2,80004ab6 <pipeclose+0x52>
    pi->writeopen = 0;
    80004a80:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a84:	21848513          	addi	a0,s1,536
    80004a88:	ffffd097          	auipc	ra,0xffffd
    80004a8c:	630080e7          	jalr	1584(ra) # 800020b8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a90:	2204b783          	ld	a5,544(s1)
    80004a94:	eb95                	bnez	a5,80004ac8 <pipeclose+0x64>
    release(&pi->lock);
    80004a96:	8526                	mv	a0,s1
    80004a98:	ffffc097          	auipc	ra,0xffffc
    80004a9c:	1f2080e7          	jalr	498(ra) # 80000c8a <release>
    kfree((char*)pi);
    80004aa0:	8526                	mv	a0,s1
    80004aa2:	ffffc097          	auipc	ra,0xffffc
    80004aa6:	f46080e7          	jalr	-186(ra) # 800009e8 <kfree>
  } else
    release(&pi->lock);
}
    80004aaa:	60e2                	ld	ra,24(sp)
    80004aac:	6442                	ld	s0,16(sp)
    80004aae:	64a2                	ld	s1,8(sp)
    80004ab0:	6902                	ld	s2,0(sp)
    80004ab2:	6105                	addi	sp,sp,32
    80004ab4:	8082                	ret
    pi->readopen = 0;
    80004ab6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004aba:	21c48513          	addi	a0,s1,540
    80004abe:	ffffd097          	auipc	ra,0xffffd
    80004ac2:	5fa080e7          	jalr	1530(ra) # 800020b8 <wakeup>
    80004ac6:	b7e9                	j	80004a90 <pipeclose+0x2c>
    release(&pi->lock);
    80004ac8:	8526                	mv	a0,s1
    80004aca:	ffffc097          	auipc	ra,0xffffc
    80004ace:	1c0080e7          	jalr	448(ra) # 80000c8a <release>
}
    80004ad2:	bfe1                	j	80004aaa <pipeclose+0x46>

0000000080004ad4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004ad4:	711d                	addi	sp,sp,-96
    80004ad6:	ec86                	sd	ra,88(sp)
    80004ad8:	e8a2                	sd	s0,80(sp)
    80004ada:	e4a6                	sd	s1,72(sp)
    80004adc:	e0ca                	sd	s2,64(sp)
    80004ade:	fc4e                	sd	s3,56(sp)
    80004ae0:	f852                	sd	s4,48(sp)
    80004ae2:	f456                	sd	s5,40(sp)
    80004ae4:	f05a                	sd	s6,32(sp)
    80004ae6:	ec5e                	sd	s7,24(sp)
    80004ae8:	e862                	sd	s8,16(sp)
    80004aea:	1080                	addi	s0,sp,96
    80004aec:	84aa                	mv	s1,a0
    80004aee:	8aae                	mv	s5,a1
    80004af0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004af2:	ffffd097          	auipc	ra,0xffffd
    80004af6:	eba080e7          	jalr	-326(ra) # 800019ac <myproc>
    80004afa:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004afc:	8526                	mv	a0,s1
    80004afe:	ffffc097          	auipc	ra,0xffffc
    80004b02:	0d8080e7          	jalr	216(ra) # 80000bd6 <acquire>
  while(i < n){
    80004b06:	0b405663          	blez	s4,80004bb2 <pipewrite+0xde>
  int i = 0;
    80004b0a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b0c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004b0e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004b12:	21c48b93          	addi	s7,s1,540
    80004b16:	a089                	j	80004b58 <pipewrite+0x84>
      release(&pi->lock);
    80004b18:	8526                	mv	a0,s1
    80004b1a:	ffffc097          	auipc	ra,0xffffc
    80004b1e:	170080e7          	jalr	368(ra) # 80000c8a <release>
      return -1;
    80004b22:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004b24:	854a                	mv	a0,s2
    80004b26:	60e6                	ld	ra,88(sp)
    80004b28:	6446                	ld	s0,80(sp)
    80004b2a:	64a6                	ld	s1,72(sp)
    80004b2c:	6906                	ld	s2,64(sp)
    80004b2e:	79e2                	ld	s3,56(sp)
    80004b30:	7a42                	ld	s4,48(sp)
    80004b32:	7aa2                	ld	s5,40(sp)
    80004b34:	7b02                	ld	s6,32(sp)
    80004b36:	6be2                	ld	s7,24(sp)
    80004b38:	6c42                	ld	s8,16(sp)
    80004b3a:	6125                	addi	sp,sp,96
    80004b3c:	8082                	ret
      wakeup(&pi->nread);
    80004b3e:	8562                	mv	a0,s8
    80004b40:	ffffd097          	auipc	ra,0xffffd
    80004b44:	578080e7          	jalr	1400(ra) # 800020b8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004b48:	85a6                	mv	a1,s1
    80004b4a:	855e                	mv	a0,s7
    80004b4c:	ffffd097          	auipc	ra,0xffffd
    80004b50:	508080e7          	jalr	1288(ra) # 80002054 <sleep>
  while(i < n){
    80004b54:	07495063          	bge	s2,s4,80004bb4 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004b58:	2204a783          	lw	a5,544(s1)
    80004b5c:	dfd5                	beqz	a5,80004b18 <pipewrite+0x44>
    80004b5e:	854e                	mv	a0,s3
    80004b60:	ffffd097          	auipc	ra,0xffffd
    80004b64:	79c080e7          	jalr	1948(ra) # 800022fc <killed>
    80004b68:	f945                	bnez	a0,80004b18 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004b6a:	2184a783          	lw	a5,536(s1)
    80004b6e:	21c4a703          	lw	a4,540(s1)
    80004b72:	2007879b          	addiw	a5,a5,512
    80004b76:	fcf704e3          	beq	a4,a5,80004b3e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b7a:	4685                	li	a3,1
    80004b7c:	01590633          	add	a2,s2,s5
    80004b80:	faf40593          	addi	a1,s0,-81
    80004b84:	0509b503          	ld	a0,80(s3)
    80004b88:	ffffd097          	auipc	ra,0xffffd
    80004b8c:	b70080e7          	jalr	-1168(ra) # 800016f8 <copyin>
    80004b90:	03650263          	beq	a0,s6,80004bb4 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b94:	21c4a783          	lw	a5,540(s1)
    80004b98:	0017871b          	addiw	a4,a5,1
    80004b9c:	20e4ae23          	sw	a4,540(s1)
    80004ba0:	1ff7f793          	andi	a5,a5,511
    80004ba4:	97a6                	add	a5,a5,s1
    80004ba6:	faf44703          	lbu	a4,-81(s0)
    80004baa:	00e78c23          	sb	a4,24(a5)
      i++;
    80004bae:	2905                	addiw	s2,s2,1
    80004bb0:	b755                	j	80004b54 <pipewrite+0x80>
  int i = 0;
    80004bb2:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004bb4:	21848513          	addi	a0,s1,536
    80004bb8:	ffffd097          	auipc	ra,0xffffd
    80004bbc:	500080e7          	jalr	1280(ra) # 800020b8 <wakeup>
  release(&pi->lock);
    80004bc0:	8526                	mv	a0,s1
    80004bc2:	ffffc097          	auipc	ra,0xffffc
    80004bc6:	0c8080e7          	jalr	200(ra) # 80000c8a <release>
  return i;
    80004bca:	bfa9                	j	80004b24 <pipewrite+0x50>

0000000080004bcc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004bcc:	715d                	addi	sp,sp,-80
    80004bce:	e486                	sd	ra,72(sp)
    80004bd0:	e0a2                	sd	s0,64(sp)
    80004bd2:	fc26                	sd	s1,56(sp)
    80004bd4:	f84a                	sd	s2,48(sp)
    80004bd6:	f44e                	sd	s3,40(sp)
    80004bd8:	f052                	sd	s4,32(sp)
    80004bda:	ec56                	sd	s5,24(sp)
    80004bdc:	e85a                	sd	s6,16(sp)
    80004bde:	0880                	addi	s0,sp,80
    80004be0:	84aa                	mv	s1,a0
    80004be2:	892e                	mv	s2,a1
    80004be4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004be6:	ffffd097          	auipc	ra,0xffffd
    80004bea:	dc6080e7          	jalr	-570(ra) # 800019ac <myproc>
    80004bee:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004bf0:	8526                	mv	a0,s1
    80004bf2:	ffffc097          	auipc	ra,0xffffc
    80004bf6:	fe4080e7          	jalr	-28(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004bfa:	2184a703          	lw	a4,536(s1)
    80004bfe:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c02:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c06:	02f71763          	bne	a4,a5,80004c34 <piperead+0x68>
    80004c0a:	2244a783          	lw	a5,548(s1)
    80004c0e:	c39d                	beqz	a5,80004c34 <piperead+0x68>
    if(killed(pr)){
    80004c10:	8552                	mv	a0,s4
    80004c12:	ffffd097          	auipc	ra,0xffffd
    80004c16:	6ea080e7          	jalr	1770(ra) # 800022fc <killed>
    80004c1a:	e949                	bnez	a0,80004cac <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c1c:	85a6                	mv	a1,s1
    80004c1e:	854e                	mv	a0,s3
    80004c20:	ffffd097          	auipc	ra,0xffffd
    80004c24:	434080e7          	jalr	1076(ra) # 80002054 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c28:	2184a703          	lw	a4,536(s1)
    80004c2c:	21c4a783          	lw	a5,540(s1)
    80004c30:	fcf70de3          	beq	a4,a5,80004c0a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c34:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c36:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c38:	05505463          	blez	s5,80004c80 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004c3c:	2184a783          	lw	a5,536(s1)
    80004c40:	21c4a703          	lw	a4,540(s1)
    80004c44:	02f70e63          	beq	a4,a5,80004c80 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004c48:	0017871b          	addiw	a4,a5,1
    80004c4c:	20e4ac23          	sw	a4,536(s1)
    80004c50:	1ff7f793          	andi	a5,a5,511
    80004c54:	97a6                	add	a5,a5,s1
    80004c56:	0187c783          	lbu	a5,24(a5)
    80004c5a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c5e:	4685                	li	a3,1
    80004c60:	fbf40613          	addi	a2,s0,-65
    80004c64:	85ca                	mv	a1,s2
    80004c66:	050a3503          	ld	a0,80(s4)
    80004c6a:	ffffd097          	auipc	ra,0xffffd
    80004c6e:	a02080e7          	jalr	-1534(ra) # 8000166c <copyout>
    80004c72:	01650763          	beq	a0,s6,80004c80 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c76:	2985                	addiw	s3,s3,1
    80004c78:	0905                	addi	s2,s2,1
    80004c7a:	fd3a91e3          	bne	s5,s3,80004c3c <piperead+0x70>
    80004c7e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004c80:	21c48513          	addi	a0,s1,540
    80004c84:	ffffd097          	auipc	ra,0xffffd
    80004c88:	434080e7          	jalr	1076(ra) # 800020b8 <wakeup>
  release(&pi->lock);
    80004c8c:	8526                	mv	a0,s1
    80004c8e:	ffffc097          	auipc	ra,0xffffc
    80004c92:	ffc080e7          	jalr	-4(ra) # 80000c8a <release>
  return i;
}
    80004c96:	854e                	mv	a0,s3
    80004c98:	60a6                	ld	ra,72(sp)
    80004c9a:	6406                	ld	s0,64(sp)
    80004c9c:	74e2                	ld	s1,56(sp)
    80004c9e:	7942                	ld	s2,48(sp)
    80004ca0:	79a2                	ld	s3,40(sp)
    80004ca2:	7a02                	ld	s4,32(sp)
    80004ca4:	6ae2                	ld	s5,24(sp)
    80004ca6:	6b42                	ld	s6,16(sp)
    80004ca8:	6161                	addi	sp,sp,80
    80004caa:	8082                	ret
      release(&pi->lock);
    80004cac:	8526                	mv	a0,s1
    80004cae:	ffffc097          	auipc	ra,0xffffc
    80004cb2:	fdc080e7          	jalr	-36(ra) # 80000c8a <release>
      return -1;
    80004cb6:	59fd                	li	s3,-1
    80004cb8:	bff9                	j	80004c96 <piperead+0xca>

0000000080004cba <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004cba:	1141                	addi	sp,sp,-16
    80004cbc:	e422                	sd	s0,8(sp)
    80004cbe:	0800                	addi	s0,sp,16
    80004cc0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004cc2:	8905                	andi	a0,a0,1
    80004cc4:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004cc6:	8b89                	andi	a5,a5,2
    80004cc8:	c399                	beqz	a5,80004cce <flags2perm+0x14>
      perm |= PTE_W;
    80004cca:	00456513          	ori	a0,a0,4
    return perm;
}
    80004cce:	6422                	ld	s0,8(sp)
    80004cd0:	0141                	addi	sp,sp,16
    80004cd2:	8082                	ret

0000000080004cd4 <exec>:

int
exec(char *path, char **argv)
{
    80004cd4:	de010113          	addi	sp,sp,-544
    80004cd8:	20113c23          	sd	ra,536(sp)
    80004cdc:	20813823          	sd	s0,528(sp)
    80004ce0:	20913423          	sd	s1,520(sp)
    80004ce4:	21213023          	sd	s2,512(sp)
    80004ce8:	ffce                	sd	s3,504(sp)
    80004cea:	fbd2                	sd	s4,496(sp)
    80004cec:	f7d6                	sd	s5,488(sp)
    80004cee:	f3da                	sd	s6,480(sp)
    80004cf0:	efde                	sd	s7,472(sp)
    80004cf2:	ebe2                	sd	s8,464(sp)
    80004cf4:	e7e6                	sd	s9,456(sp)
    80004cf6:	e3ea                	sd	s10,448(sp)
    80004cf8:	ff6e                	sd	s11,440(sp)
    80004cfa:	1400                	addi	s0,sp,544
    80004cfc:	892a                	mv	s2,a0
    80004cfe:	dea43423          	sd	a0,-536(s0)
    80004d02:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004d06:	ffffd097          	auipc	ra,0xffffd
    80004d0a:	ca6080e7          	jalr	-858(ra) # 800019ac <myproc>
    80004d0e:	84aa                	mv	s1,a0

  begin_op();
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	482080e7          	jalr	1154(ra) # 80004192 <begin_op>

  if((ip = namei(path)) == 0){
    80004d18:	854a                	mv	a0,s2
    80004d1a:	fffff097          	auipc	ra,0xfffff
    80004d1e:	258080e7          	jalr	600(ra) # 80003f72 <namei>
    80004d22:	c93d                	beqz	a0,80004d98 <exec+0xc4>
    80004d24:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	aa0080e7          	jalr	-1376(ra) # 800037c6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004d2e:	04000713          	li	a4,64
    80004d32:	4681                	li	a3,0
    80004d34:	e5040613          	addi	a2,s0,-432
    80004d38:	4581                	li	a1,0
    80004d3a:	8556                	mv	a0,s5
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	d3e080e7          	jalr	-706(ra) # 80003a7a <readi>
    80004d44:	04000793          	li	a5,64
    80004d48:	00f51a63          	bne	a0,a5,80004d5c <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004d4c:	e5042703          	lw	a4,-432(s0)
    80004d50:	464c47b7          	lui	a5,0x464c4
    80004d54:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004d58:	04f70663          	beq	a4,a5,80004da4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004d5c:	8556                	mv	a0,s5
    80004d5e:	fffff097          	auipc	ra,0xfffff
    80004d62:	cca080e7          	jalr	-822(ra) # 80003a28 <iunlockput>
    end_op();
    80004d66:	fffff097          	auipc	ra,0xfffff
    80004d6a:	4aa080e7          	jalr	1194(ra) # 80004210 <end_op>
  }
  return -1;
    80004d6e:	557d                	li	a0,-1
}
    80004d70:	21813083          	ld	ra,536(sp)
    80004d74:	21013403          	ld	s0,528(sp)
    80004d78:	20813483          	ld	s1,520(sp)
    80004d7c:	20013903          	ld	s2,512(sp)
    80004d80:	79fe                	ld	s3,504(sp)
    80004d82:	7a5e                	ld	s4,496(sp)
    80004d84:	7abe                	ld	s5,488(sp)
    80004d86:	7b1e                	ld	s6,480(sp)
    80004d88:	6bfe                	ld	s7,472(sp)
    80004d8a:	6c5e                	ld	s8,464(sp)
    80004d8c:	6cbe                	ld	s9,456(sp)
    80004d8e:	6d1e                	ld	s10,448(sp)
    80004d90:	7dfa                	ld	s11,440(sp)
    80004d92:	22010113          	addi	sp,sp,544
    80004d96:	8082                	ret
    end_op();
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	478080e7          	jalr	1144(ra) # 80004210 <end_op>
    return -1;
    80004da0:	557d                	li	a0,-1
    80004da2:	b7f9                	j	80004d70 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004da4:	8526                	mv	a0,s1
    80004da6:	ffffd097          	auipc	ra,0xffffd
    80004daa:	cca080e7          	jalr	-822(ra) # 80001a70 <proc_pagetable>
    80004dae:	8b2a                	mv	s6,a0
    80004db0:	d555                	beqz	a0,80004d5c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004db2:	e7042783          	lw	a5,-400(s0)
    80004db6:	e8845703          	lhu	a4,-376(s0)
    80004dba:	c735                	beqz	a4,80004e26 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004dbc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004dbe:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004dc2:	6a05                	lui	s4,0x1
    80004dc4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004dc8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004dcc:	6d85                	lui	s11,0x1
    80004dce:	7d7d                	lui	s10,0xfffff
    80004dd0:	ac3d                	j	8000500e <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004dd2:	00004517          	auipc	a0,0x4
    80004dd6:	9a650513          	addi	a0,a0,-1626 # 80008778 <syscalls+0x328>
    80004dda:	ffffb097          	auipc	ra,0xffffb
    80004dde:	766080e7          	jalr	1894(ra) # 80000540 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004de2:	874a                	mv	a4,s2
    80004de4:	009c86bb          	addw	a3,s9,s1
    80004de8:	4581                	li	a1,0
    80004dea:	8556                	mv	a0,s5
    80004dec:	fffff097          	auipc	ra,0xfffff
    80004df0:	c8e080e7          	jalr	-882(ra) # 80003a7a <readi>
    80004df4:	2501                	sext.w	a0,a0
    80004df6:	1aa91963          	bne	s2,a0,80004fa8 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    80004dfa:	009d84bb          	addw	s1,s11,s1
    80004dfe:	013d09bb          	addw	s3,s10,s3
    80004e02:	1f74f663          	bgeu	s1,s7,80004fee <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80004e06:	02049593          	slli	a1,s1,0x20
    80004e0a:	9181                	srli	a1,a1,0x20
    80004e0c:	95e2                	add	a1,a1,s8
    80004e0e:	855a                	mv	a0,s6
    80004e10:	ffffc097          	auipc	ra,0xffffc
    80004e14:	24c080e7          	jalr	588(ra) # 8000105c <walkaddr>
    80004e18:	862a                	mv	a2,a0
    if(pa == 0)
    80004e1a:	dd45                	beqz	a0,80004dd2 <exec+0xfe>
      n = PGSIZE;
    80004e1c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004e1e:	fd49f2e3          	bgeu	s3,s4,80004de2 <exec+0x10e>
      n = sz - i;
    80004e22:	894e                	mv	s2,s3
    80004e24:	bf7d                	j	80004de2 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004e26:	4901                	li	s2,0
  iunlockput(ip);
    80004e28:	8556                	mv	a0,s5
    80004e2a:	fffff097          	auipc	ra,0xfffff
    80004e2e:	bfe080e7          	jalr	-1026(ra) # 80003a28 <iunlockput>
  end_op();
    80004e32:	fffff097          	auipc	ra,0xfffff
    80004e36:	3de080e7          	jalr	990(ra) # 80004210 <end_op>
  p = myproc();
    80004e3a:	ffffd097          	auipc	ra,0xffffd
    80004e3e:	b72080e7          	jalr	-1166(ra) # 800019ac <myproc>
    80004e42:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004e44:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004e48:	6785                	lui	a5,0x1
    80004e4a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004e4c:	97ca                	add	a5,a5,s2
    80004e4e:	777d                	lui	a4,0xfffff
    80004e50:	8ff9                	and	a5,a5,a4
    80004e52:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004e56:	4691                	li	a3,4
    80004e58:	6609                	lui	a2,0x2
    80004e5a:	963e                	add	a2,a2,a5
    80004e5c:	85be                	mv	a1,a5
    80004e5e:	855a                	mv	a0,s6
    80004e60:	ffffc097          	auipc	ra,0xffffc
    80004e64:	5b0080e7          	jalr	1456(ra) # 80001410 <uvmalloc>
    80004e68:	8c2a                	mv	s8,a0
  ip = 0;
    80004e6a:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004e6c:	12050e63          	beqz	a0,80004fa8 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004e70:	75f9                	lui	a1,0xffffe
    80004e72:	95aa                	add	a1,a1,a0
    80004e74:	855a                	mv	a0,s6
    80004e76:	ffffc097          	auipc	ra,0xffffc
    80004e7a:	7c4080e7          	jalr	1988(ra) # 8000163a <uvmclear>
  stackbase = sp - PGSIZE;
    80004e7e:	7afd                	lui	s5,0xfffff
    80004e80:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e82:	df043783          	ld	a5,-528(s0)
    80004e86:	6388                	ld	a0,0(a5)
    80004e88:	c925                	beqz	a0,80004ef8 <exec+0x224>
    80004e8a:	e9040993          	addi	s3,s0,-368
    80004e8e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004e92:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e94:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004e96:	ffffc097          	auipc	ra,0xffffc
    80004e9a:	fb8080e7          	jalr	-72(ra) # 80000e4e <strlen>
    80004e9e:	0015079b          	addiw	a5,a0,1
    80004ea2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004ea6:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004eaa:	13596663          	bltu	s2,s5,80004fd6 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004eae:	df043d83          	ld	s11,-528(s0)
    80004eb2:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004eb6:	8552                	mv	a0,s4
    80004eb8:	ffffc097          	auipc	ra,0xffffc
    80004ebc:	f96080e7          	jalr	-106(ra) # 80000e4e <strlen>
    80004ec0:	0015069b          	addiw	a3,a0,1
    80004ec4:	8652                	mv	a2,s4
    80004ec6:	85ca                	mv	a1,s2
    80004ec8:	855a                	mv	a0,s6
    80004eca:	ffffc097          	auipc	ra,0xffffc
    80004ece:	7a2080e7          	jalr	1954(ra) # 8000166c <copyout>
    80004ed2:	10054663          	bltz	a0,80004fde <exec+0x30a>
    ustack[argc] = sp;
    80004ed6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004eda:	0485                	addi	s1,s1,1
    80004edc:	008d8793          	addi	a5,s11,8
    80004ee0:	def43823          	sd	a5,-528(s0)
    80004ee4:	008db503          	ld	a0,8(s11)
    80004ee8:	c911                	beqz	a0,80004efc <exec+0x228>
    if(argc >= MAXARG)
    80004eea:	09a1                	addi	s3,s3,8
    80004eec:	fb3c95e3          	bne	s9,s3,80004e96 <exec+0x1c2>
  sz = sz1;
    80004ef0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004ef4:	4a81                	li	s5,0
    80004ef6:	a84d                	j	80004fa8 <exec+0x2d4>
  sp = sz;
    80004ef8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004efa:	4481                	li	s1,0
  ustack[argc] = 0;
    80004efc:	00349793          	slli	a5,s1,0x3
    80004f00:	f9078793          	addi	a5,a5,-112
    80004f04:	97a2                	add	a5,a5,s0
    80004f06:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004f0a:	00148693          	addi	a3,s1,1
    80004f0e:	068e                	slli	a3,a3,0x3
    80004f10:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004f14:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004f18:	01597663          	bgeu	s2,s5,80004f24 <exec+0x250>
  sz = sz1;
    80004f1c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f20:	4a81                	li	s5,0
    80004f22:	a059                	j	80004fa8 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004f24:	e9040613          	addi	a2,s0,-368
    80004f28:	85ca                	mv	a1,s2
    80004f2a:	855a                	mv	a0,s6
    80004f2c:	ffffc097          	auipc	ra,0xffffc
    80004f30:	740080e7          	jalr	1856(ra) # 8000166c <copyout>
    80004f34:	0a054963          	bltz	a0,80004fe6 <exec+0x312>
  p->trapframe->a1 = sp;
    80004f38:	058bb783          	ld	a5,88(s7)
    80004f3c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004f40:	de843783          	ld	a5,-536(s0)
    80004f44:	0007c703          	lbu	a4,0(a5)
    80004f48:	cf11                	beqz	a4,80004f64 <exec+0x290>
    80004f4a:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004f4c:	02f00693          	li	a3,47
    80004f50:	a039                	j	80004f5e <exec+0x28a>
      last = s+1;
    80004f52:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004f56:	0785                	addi	a5,a5,1
    80004f58:	fff7c703          	lbu	a4,-1(a5)
    80004f5c:	c701                	beqz	a4,80004f64 <exec+0x290>
    if(*s == '/')
    80004f5e:	fed71ce3          	bne	a4,a3,80004f56 <exec+0x282>
    80004f62:	bfc5                	j	80004f52 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004f64:	4641                	li	a2,16
    80004f66:	de843583          	ld	a1,-536(s0)
    80004f6a:	158b8513          	addi	a0,s7,344
    80004f6e:	ffffc097          	auipc	ra,0xffffc
    80004f72:	eae080e7          	jalr	-338(ra) # 80000e1c <safestrcpy>
  oldpagetable = p->pagetable;
    80004f76:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004f7a:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004f7e:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004f82:	058bb783          	ld	a5,88(s7)
    80004f86:	e6843703          	ld	a4,-408(s0)
    80004f8a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004f8c:	058bb783          	ld	a5,88(s7)
    80004f90:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f94:	85ea                	mv	a1,s10
    80004f96:	ffffd097          	auipc	ra,0xffffd
    80004f9a:	b76080e7          	jalr	-1162(ra) # 80001b0c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f9e:	0004851b          	sext.w	a0,s1
    80004fa2:	b3f9                	j	80004d70 <exec+0x9c>
    80004fa4:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004fa8:	df843583          	ld	a1,-520(s0)
    80004fac:	855a                	mv	a0,s6
    80004fae:	ffffd097          	auipc	ra,0xffffd
    80004fb2:	b5e080e7          	jalr	-1186(ra) # 80001b0c <proc_freepagetable>
  if(ip){
    80004fb6:	da0a93e3          	bnez	s5,80004d5c <exec+0x88>
  return -1;
    80004fba:	557d                	li	a0,-1
    80004fbc:	bb55                	j	80004d70 <exec+0x9c>
    80004fbe:	df243c23          	sd	s2,-520(s0)
    80004fc2:	b7dd                	j	80004fa8 <exec+0x2d4>
    80004fc4:	df243c23          	sd	s2,-520(s0)
    80004fc8:	b7c5                	j	80004fa8 <exec+0x2d4>
    80004fca:	df243c23          	sd	s2,-520(s0)
    80004fce:	bfe9                	j	80004fa8 <exec+0x2d4>
    80004fd0:	df243c23          	sd	s2,-520(s0)
    80004fd4:	bfd1                	j	80004fa8 <exec+0x2d4>
  sz = sz1;
    80004fd6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004fda:	4a81                	li	s5,0
    80004fdc:	b7f1                	j	80004fa8 <exec+0x2d4>
  sz = sz1;
    80004fde:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004fe2:	4a81                	li	s5,0
    80004fe4:	b7d1                	j	80004fa8 <exec+0x2d4>
  sz = sz1;
    80004fe6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004fea:	4a81                	li	s5,0
    80004fec:	bf75                	j	80004fa8 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004fee:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004ff2:	e0843783          	ld	a5,-504(s0)
    80004ff6:	0017869b          	addiw	a3,a5,1
    80004ffa:	e0d43423          	sd	a3,-504(s0)
    80004ffe:	e0043783          	ld	a5,-512(s0)
    80005002:	0387879b          	addiw	a5,a5,56
    80005006:	e8845703          	lhu	a4,-376(s0)
    8000500a:	e0e6dfe3          	bge	a3,a4,80004e28 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000500e:	2781                	sext.w	a5,a5
    80005010:	e0f43023          	sd	a5,-512(s0)
    80005014:	03800713          	li	a4,56
    80005018:	86be                	mv	a3,a5
    8000501a:	e1840613          	addi	a2,s0,-488
    8000501e:	4581                	li	a1,0
    80005020:	8556                	mv	a0,s5
    80005022:	fffff097          	auipc	ra,0xfffff
    80005026:	a58080e7          	jalr	-1448(ra) # 80003a7a <readi>
    8000502a:	03800793          	li	a5,56
    8000502e:	f6f51be3          	bne	a0,a5,80004fa4 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    80005032:	e1842783          	lw	a5,-488(s0)
    80005036:	4705                	li	a4,1
    80005038:	fae79de3          	bne	a5,a4,80004ff2 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    8000503c:	e4043483          	ld	s1,-448(s0)
    80005040:	e3843783          	ld	a5,-456(s0)
    80005044:	f6f4ede3          	bltu	s1,a5,80004fbe <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005048:	e2843783          	ld	a5,-472(s0)
    8000504c:	94be                	add	s1,s1,a5
    8000504e:	f6f4ebe3          	bltu	s1,a5,80004fc4 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80005052:	de043703          	ld	a4,-544(s0)
    80005056:	8ff9                	and	a5,a5,a4
    80005058:	fbad                	bnez	a5,80004fca <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000505a:	e1c42503          	lw	a0,-484(s0)
    8000505e:	00000097          	auipc	ra,0x0
    80005062:	c5c080e7          	jalr	-932(ra) # 80004cba <flags2perm>
    80005066:	86aa                	mv	a3,a0
    80005068:	8626                	mv	a2,s1
    8000506a:	85ca                	mv	a1,s2
    8000506c:	855a                	mv	a0,s6
    8000506e:	ffffc097          	auipc	ra,0xffffc
    80005072:	3a2080e7          	jalr	930(ra) # 80001410 <uvmalloc>
    80005076:	dea43c23          	sd	a0,-520(s0)
    8000507a:	d939                	beqz	a0,80004fd0 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000507c:	e2843c03          	ld	s8,-472(s0)
    80005080:	e2042c83          	lw	s9,-480(s0)
    80005084:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005088:	f60b83e3          	beqz	s7,80004fee <exec+0x31a>
    8000508c:	89de                	mv	s3,s7
    8000508e:	4481                	li	s1,0
    80005090:	bb9d                	j	80004e06 <exec+0x132>

0000000080005092 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005092:	7179                	addi	sp,sp,-48
    80005094:	f406                	sd	ra,40(sp)
    80005096:	f022                	sd	s0,32(sp)
    80005098:	ec26                	sd	s1,24(sp)
    8000509a:	e84a                	sd	s2,16(sp)
    8000509c:	1800                	addi	s0,sp,48
    8000509e:	892e                	mv	s2,a1
    800050a0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800050a2:	fdc40593          	addi	a1,s0,-36
    800050a6:	ffffe097          	auipc	ra,0xffffe
    800050aa:	a1c080e7          	jalr	-1508(ra) # 80002ac2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800050ae:	fdc42703          	lw	a4,-36(s0)
    800050b2:	47bd                	li	a5,15
    800050b4:	02e7eb63          	bltu	a5,a4,800050ea <argfd+0x58>
    800050b8:	ffffd097          	auipc	ra,0xffffd
    800050bc:	8f4080e7          	jalr	-1804(ra) # 800019ac <myproc>
    800050c0:	fdc42703          	lw	a4,-36(s0)
    800050c4:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd1da>
    800050c8:	078e                	slli	a5,a5,0x3
    800050ca:	953e                	add	a0,a0,a5
    800050cc:	611c                	ld	a5,0(a0)
    800050ce:	c385                	beqz	a5,800050ee <argfd+0x5c>
    return -1;
  if(pfd)
    800050d0:	00090463          	beqz	s2,800050d8 <argfd+0x46>
    *pfd = fd;
    800050d4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800050d8:	4501                	li	a0,0
  if(pf)
    800050da:	c091                	beqz	s1,800050de <argfd+0x4c>
    *pf = f;
    800050dc:	e09c                	sd	a5,0(s1)
}
    800050de:	70a2                	ld	ra,40(sp)
    800050e0:	7402                	ld	s0,32(sp)
    800050e2:	64e2                	ld	s1,24(sp)
    800050e4:	6942                	ld	s2,16(sp)
    800050e6:	6145                	addi	sp,sp,48
    800050e8:	8082                	ret
    return -1;
    800050ea:	557d                	li	a0,-1
    800050ec:	bfcd                	j	800050de <argfd+0x4c>
    800050ee:	557d                	li	a0,-1
    800050f0:	b7fd                	j	800050de <argfd+0x4c>

00000000800050f2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800050f2:	1101                	addi	sp,sp,-32
    800050f4:	ec06                	sd	ra,24(sp)
    800050f6:	e822                	sd	s0,16(sp)
    800050f8:	e426                	sd	s1,8(sp)
    800050fa:	1000                	addi	s0,sp,32
    800050fc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800050fe:	ffffd097          	auipc	ra,0xffffd
    80005102:	8ae080e7          	jalr	-1874(ra) # 800019ac <myproc>
    80005106:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005108:	0d050793          	addi	a5,a0,208
    8000510c:	4501                	li	a0,0
    8000510e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005110:	6398                	ld	a4,0(a5)
    80005112:	cb19                	beqz	a4,80005128 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005114:	2505                	addiw	a0,a0,1
    80005116:	07a1                	addi	a5,a5,8
    80005118:	fed51ce3          	bne	a0,a3,80005110 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000511c:	557d                	li	a0,-1
}
    8000511e:	60e2                	ld	ra,24(sp)
    80005120:	6442                	ld	s0,16(sp)
    80005122:	64a2                	ld	s1,8(sp)
    80005124:	6105                	addi	sp,sp,32
    80005126:	8082                	ret
      p->ofile[fd] = f;
    80005128:	01a50793          	addi	a5,a0,26
    8000512c:	078e                	slli	a5,a5,0x3
    8000512e:	963e                	add	a2,a2,a5
    80005130:	e204                	sd	s1,0(a2)
      return fd;
    80005132:	b7f5                	j	8000511e <fdalloc+0x2c>

0000000080005134 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005134:	715d                	addi	sp,sp,-80
    80005136:	e486                	sd	ra,72(sp)
    80005138:	e0a2                	sd	s0,64(sp)
    8000513a:	fc26                	sd	s1,56(sp)
    8000513c:	f84a                	sd	s2,48(sp)
    8000513e:	f44e                	sd	s3,40(sp)
    80005140:	f052                	sd	s4,32(sp)
    80005142:	ec56                	sd	s5,24(sp)
    80005144:	e85a                	sd	s6,16(sp)
    80005146:	0880                	addi	s0,sp,80
    80005148:	8b2e                	mv	s6,a1
    8000514a:	89b2                	mv	s3,a2
    8000514c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000514e:	fb040593          	addi	a1,s0,-80
    80005152:	fffff097          	auipc	ra,0xfffff
    80005156:	e3e080e7          	jalr	-450(ra) # 80003f90 <nameiparent>
    8000515a:	84aa                	mv	s1,a0
    8000515c:	14050f63          	beqz	a0,800052ba <create+0x186>
    return 0;

  ilock(dp);
    80005160:	ffffe097          	auipc	ra,0xffffe
    80005164:	666080e7          	jalr	1638(ra) # 800037c6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005168:	4601                	li	a2,0
    8000516a:	fb040593          	addi	a1,s0,-80
    8000516e:	8526                	mv	a0,s1
    80005170:	fffff097          	auipc	ra,0xfffff
    80005174:	b3a080e7          	jalr	-1222(ra) # 80003caa <dirlookup>
    80005178:	8aaa                	mv	s5,a0
    8000517a:	c931                	beqz	a0,800051ce <create+0x9a>
    iunlockput(dp);
    8000517c:	8526                	mv	a0,s1
    8000517e:	fffff097          	auipc	ra,0xfffff
    80005182:	8aa080e7          	jalr	-1878(ra) # 80003a28 <iunlockput>
    ilock(ip);
    80005186:	8556                	mv	a0,s5
    80005188:	ffffe097          	auipc	ra,0xffffe
    8000518c:	63e080e7          	jalr	1598(ra) # 800037c6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005190:	000b059b          	sext.w	a1,s6
    80005194:	4789                	li	a5,2
    80005196:	02f59563          	bne	a1,a5,800051c0 <create+0x8c>
    8000519a:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd204>
    8000519e:	37f9                	addiw	a5,a5,-2
    800051a0:	17c2                	slli	a5,a5,0x30
    800051a2:	93c1                	srli	a5,a5,0x30
    800051a4:	4705                	li	a4,1
    800051a6:	00f76d63          	bltu	a4,a5,800051c0 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800051aa:	8556                	mv	a0,s5
    800051ac:	60a6                	ld	ra,72(sp)
    800051ae:	6406                	ld	s0,64(sp)
    800051b0:	74e2                	ld	s1,56(sp)
    800051b2:	7942                	ld	s2,48(sp)
    800051b4:	79a2                	ld	s3,40(sp)
    800051b6:	7a02                	ld	s4,32(sp)
    800051b8:	6ae2                	ld	s5,24(sp)
    800051ba:	6b42                	ld	s6,16(sp)
    800051bc:	6161                	addi	sp,sp,80
    800051be:	8082                	ret
    iunlockput(ip);
    800051c0:	8556                	mv	a0,s5
    800051c2:	fffff097          	auipc	ra,0xfffff
    800051c6:	866080e7          	jalr	-1946(ra) # 80003a28 <iunlockput>
    return 0;
    800051ca:	4a81                	li	s5,0
    800051cc:	bff9                	j	800051aa <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800051ce:	85da                	mv	a1,s6
    800051d0:	4088                	lw	a0,0(s1)
    800051d2:	ffffe097          	auipc	ra,0xffffe
    800051d6:	456080e7          	jalr	1110(ra) # 80003628 <ialloc>
    800051da:	8a2a                	mv	s4,a0
    800051dc:	c539                	beqz	a0,8000522a <create+0xf6>
  ilock(ip);
    800051de:	ffffe097          	auipc	ra,0xffffe
    800051e2:	5e8080e7          	jalr	1512(ra) # 800037c6 <ilock>
  ip->major = major;
    800051e6:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800051ea:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800051ee:	4905                	li	s2,1
    800051f0:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800051f4:	8552                	mv	a0,s4
    800051f6:	ffffe097          	auipc	ra,0xffffe
    800051fa:	504080e7          	jalr	1284(ra) # 800036fa <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800051fe:	000b059b          	sext.w	a1,s6
    80005202:	03258b63          	beq	a1,s2,80005238 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80005206:	004a2603          	lw	a2,4(s4)
    8000520a:	fb040593          	addi	a1,s0,-80
    8000520e:	8526                	mv	a0,s1
    80005210:	fffff097          	auipc	ra,0xfffff
    80005214:	cb0080e7          	jalr	-848(ra) # 80003ec0 <dirlink>
    80005218:	06054f63          	bltz	a0,80005296 <create+0x162>
  iunlockput(dp);
    8000521c:	8526                	mv	a0,s1
    8000521e:	fffff097          	auipc	ra,0xfffff
    80005222:	80a080e7          	jalr	-2038(ra) # 80003a28 <iunlockput>
  return ip;
    80005226:	8ad2                	mv	s5,s4
    80005228:	b749                	j	800051aa <create+0x76>
    iunlockput(dp);
    8000522a:	8526                	mv	a0,s1
    8000522c:	ffffe097          	auipc	ra,0xffffe
    80005230:	7fc080e7          	jalr	2044(ra) # 80003a28 <iunlockput>
    return 0;
    80005234:	8ad2                	mv	s5,s4
    80005236:	bf95                	j	800051aa <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005238:	004a2603          	lw	a2,4(s4)
    8000523c:	00003597          	auipc	a1,0x3
    80005240:	55c58593          	addi	a1,a1,1372 # 80008798 <syscalls+0x348>
    80005244:	8552                	mv	a0,s4
    80005246:	fffff097          	auipc	ra,0xfffff
    8000524a:	c7a080e7          	jalr	-902(ra) # 80003ec0 <dirlink>
    8000524e:	04054463          	bltz	a0,80005296 <create+0x162>
    80005252:	40d0                	lw	a2,4(s1)
    80005254:	00003597          	auipc	a1,0x3
    80005258:	54c58593          	addi	a1,a1,1356 # 800087a0 <syscalls+0x350>
    8000525c:	8552                	mv	a0,s4
    8000525e:	fffff097          	auipc	ra,0xfffff
    80005262:	c62080e7          	jalr	-926(ra) # 80003ec0 <dirlink>
    80005266:	02054863          	bltz	a0,80005296 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    8000526a:	004a2603          	lw	a2,4(s4)
    8000526e:	fb040593          	addi	a1,s0,-80
    80005272:	8526                	mv	a0,s1
    80005274:	fffff097          	auipc	ra,0xfffff
    80005278:	c4c080e7          	jalr	-948(ra) # 80003ec0 <dirlink>
    8000527c:	00054d63          	bltz	a0,80005296 <create+0x162>
    dp->nlink++;  // for ".."
    80005280:	04a4d783          	lhu	a5,74(s1)
    80005284:	2785                	addiw	a5,a5,1
    80005286:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000528a:	8526                	mv	a0,s1
    8000528c:	ffffe097          	auipc	ra,0xffffe
    80005290:	46e080e7          	jalr	1134(ra) # 800036fa <iupdate>
    80005294:	b761                	j	8000521c <create+0xe8>
  ip->nlink = 0;
    80005296:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000529a:	8552                	mv	a0,s4
    8000529c:	ffffe097          	auipc	ra,0xffffe
    800052a0:	45e080e7          	jalr	1118(ra) # 800036fa <iupdate>
  iunlockput(ip);
    800052a4:	8552                	mv	a0,s4
    800052a6:	ffffe097          	auipc	ra,0xffffe
    800052aa:	782080e7          	jalr	1922(ra) # 80003a28 <iunlockput>
  iunlockput(dp);
    800052ae:	8526                	mv	a0,s1
    800052b0:	ffffe097          	auipc	ra,0xffffe
    800052b4:	778080e7          	jalr	1912(ra) # 80003a28 <iunlockput>
  return 0;
    800052b8:	bdcd                	j	800051aa <create+0x76>
    return 0;
    800052ba:	8aaa                	mv	s5,a0
    800052bc:	b5fd                	j	800051aa <create+0x76>

00000000800052be <sys_dup>:
{
    800052be:	7179                	addi	sp,sp,-48
    800052c0:	f406                	sd	ra,40(sp)
    800052c2:	f022                	sd	s0,32(sp)
    800052c4:	ec26                	sd	s1,24(sp)
    800052c6:	e84a                	sd	s2,16(sp)
    800052c8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800052ca:	fd840613          	addi	a2,s0,-40
    800052ce:	4581                	li	a1,0
    800052d0:	4501                	li	a0,0
    800052d2:	00000097          	auipc	ra,0x0
    800052d6:	dc0080e7          	jalr	-576(ra) # 80005092 <argfd>
    return -1;
    800052da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800052dc:	02054363          	bltz	a0,80005302 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800052e0:	fd843903          	ld	s2,-40(s0)
    800052e4:	854a                	mv	a0,s2
    800052e6:	00000097          	auipc	ra,0x0
    800052ea:	e0c080e7          	jalr	-500(ra) # 800050f2 <fdalloc>
    800052ee:	84aa                	mv	s1,a0
    return -1;
    800052f0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800052f2:	00054863          	bltz	a0,80005302 <sys_dup+0x44>
  filedup(f);
    800052f6:	854a                	mv	a0,s2
    800052f8:	fffff097          	auipc	ra,0xfffff
    800052fc:	310080e7          	jalr	784(ra) # 80004608 <filedup>
  return fd;
    80005300:	87a6                	mv	a5,s1
}
    80005302:	853e                	mv	a0,a5
    80005304:	70a2                	ld	ra,40(sp)
    80005306:	7402                	ld	s0,32(sp)
    80005308:	64e2                	ld	s1,24(sp)
    8000530a:	6942                	ld	s2,16(sp)
    8000530c:	6145                	addi	sp,sp,48
    8000530e:	8082                	ret

0000000080005310 <sys_read>:
{
    80005310:	7179                	addi	sp,sp,-48
    80005312:	f406                	sd	ra,40(sp)
    80005314:	f022                	sd	s0,32(sp)
    80005316:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005318:	fd840593          	addi	a1,s0,-40
    8000531c:	4505                	li	a0,1
    8000531e:	ffffd097          	auipc	ra,0xffffd
    80005322:	7c4080e7          	jalr	1988(ra) # 80002ae2 <argaddr>
  argint(2, &n);
    80005326:	fe440593          	addi	a1,s0,-28
    8000532a:	4509                	li	a0,2
    8000532c:	ffffd097          	auipc	ra,0xffffd
    80005330:	796080e7          	jalr	1942(ra) # 80002ac2 <argint>
  if(argfd(0, 0, &f) < 0)
    80005334:	fe840613          	addi	a2,s0,-24
    80005338:	4581                	li	a1,0
    8000533a:	4501                	li	a0,0
    8000533c:	00000097          	auipc	ra,0x0
    80005340:	d56080e7          	jalr	-682(ra) # 80005092 <argfd>
    80005344:	87aa                	mv	a5,a0
    return -1;
    80005346:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005348:	0007cc63          	bltz	a5,80005360 <sys_read+0x50>
  return fileread(f, p, n);
    8000534c:	fe442603          	lw	a2,-28(s0)
    80005350:	fd843583          	ld	a1,-40(s0)
    80005354:	fe843503          	ld	a0,-24(s0)
    80005358:	fffff097          	auipc	ra,0xfffff
    8000535c:	43c080e7          	jalr	1084(ra) # 80004794 <fileread>
}
    80005360:	70a2                	ld	ra,40(sp)
    80005362:	7402                	ld	s0,32(sp)
    80005364:	6145                	addi	sp,sp,48
    80005366:	8082                	ret

0000000080005368 <sys_write>:
{
    80005368:	7179                	addi	sp,sp,-48
    8000536a:	f406                	sd	ra,40(sp)
    8000536c:	f022                	sd	s0,32(sp)
    8000536e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005370:	fd840593          	addi	a1,s0,-40
    80005374:	4505                	li	a0,1
    80005376:	ffffd097          	auipc	ra,0xffffd
    8000537a:	76c080e7          	jalr	1900(ra) # 80002ae2 <argaddr>
  argint(2, &n);
    8000537e:	fe440593          	addi	a1,s0,-28
    80005382:	4509                	li	a0,2
    80005384:	ffffd097          	auipc	ra,0xffffd
    80005388:	73e080e7          	jalr	1854(ra) # 80002ac2 <argint>
  if(argfd(0, 0, &f) < 0)
    8000538c:	fe840613          	addi	a2,s0,-24
    80005390:	4581                	li	a1,0
    80005392:	4501                	li	a0,0
    80005394:	00000097          	auipc	ra,0x0
    80005398:	cfe080e7          	jalr	-770(ra) # 80005092 <argfd>
    8000539c:	87aa                	mv	a5,a0
    return -1;
    8000539e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053a0:	0007cc63          	bltz	a5,800053b8 <sys_write+0x50>
  return filewrite(f, p, n);
    800053a4:	fe442603          	lw	a2,-28(s0)
    800053a8:	fd843583          	ld	a1,-40(s0)
    800053ac:	fe843503          	ld	a0,-24(s0)
    800053b0:	fffff097          	auipc	ra,0xfffff
    800053b4:	4a6080e7          	jalr	1190(ra) # 80004856 <filewrite>
}
    800053b8:	70a2                	ld	ra,40(sp)
    800053ba:	7402                	ld	s0,32(sp)
    800053bc:	6145                	addi	sp,sp,48
    800053be:	8082                	ret

00000000800053c0 <sys_close>:
{
    800053c0:	1101                	addi	sp,sp,-32
    800053c2:	ec06                	sd	ra,24(sp)
    800053c4:	e822                	sd	s0,16(sp)
    800053c6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800053c8:	fe040613          	addi	a2,s0,-32
    800053cc:	fec40593          	addi	a1,s0,-20
    800053d0:	4501                	li	a0,0
    800053d2:	00000097          	auipc	ra,0x0
    800053d6:	cc0080e7          	jalr	-832(ra) # 80005092 <argfd>
    return -1;
    800053da:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800053dc:	02054463          	bltz	a0,80005404 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800053e0:	ffffc097          	auipc	ra,0xffffc
    800053e4:	5cc080e7          	jalr	1484(ra) # 800019ac <myproc>
    800053e8:	fec42783          	lw	a5,-20(s0)
    800053ec:	07e9                	addi	a5,a5,26
    800053ee:	078e                	slli	a5,a5,0x3
    800053f0:	953e                	add	a0,a0,a5
    800053f2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800053f6:	fe043503          	ld	a0,-32(s0)
    800053fa:	fffff097          	auipc	ra,0xfffff
    800053fe:	260080e7          	jalr	608(ra) # 8000465a <fileclose>
  return 0;
    80005402:	4781                	li	a5,0
}
    80005404:	853e                	mv	a0,a5
    80005406:	60e2                	ld	ra,24(sp)
    80005408:	6442                	ld	s0,16(sp)
    8000540a:	6105                	addi	sp,sp,32
    8000540c:	8082                	ret

000000008000540e <sys_fstat>:
{
    8000540e:	1101                	addi	sp,sp,-32
    80005410:	ec06                	sd	ra,24(sp)
    80005412:	e822                	sd	s0,16(sp)
    80005414:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005416:	fe040593          	addi	a1,s0,-32
    8000541a:	4505                	li	a0,1
    8000541c:	ffffd097          	auipc	ra,0xffffd
    80005420:	6c6080e7          	jalr	1734(ra) # 80002ae2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005424:	fe840613          	addi	a2,s0,-24
    80005428:	4581                	li	a1,0
    8000542a:	4501                	li	a0,0
    8000542c:	00000097          	auipc	ra,0x0
    80005430:	c66080e7          	jalr	-922(ra) # 80005092 <argfd>
    80005434:	87aa                	mv	a5,a0
    return -1;
    80005436:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005438:	0007ca63          	bltz	a5,8000544c <sys_fstat+0x3e>
  return filestat(f, st);
    8000543c:	fe043583          	ld	a1,-32(s0)
    80005440:	fe843503          	ld	a0,-24(s0)
    80005444:	fffff097          	auipc	ra,0xfffff
    80005448:	2de080e7          	jalr	734(ra) # 80004722 <filestat>
}
    8000544c:	60e2                	ld	ra,24(sp)
    8000544e:	6442                	ld	s0,16(sp)
    80005450:	6105                	addi	sp,sp,32
    80005452:	8082                	ret

0000000080005454 <sys_link>:
{
    80005454:	7169                	addi	sp,sp,-304
    80005456:	f606                	sd	ra,296(sp)
    80005458:	f222                	sd	s0,288(sp)
    8000545a:	ee26                	sd	s1,280(sp)
    8000545c:	ea4a                	sd	s2,272(sp)
    8000545e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005460:	08000613          	li	a2,128
    80005464:	ed040593          	addi	a1,s0,-304
    80005468:	4501                	li	a0,0
    8000546a:	ffffd097          	auipc	ra,0xffffd
    8000546e:	698080e7          	jalr	1688(ra) # 80002b02 <argstr>
    return -1;
    80005472:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005474:	10054e63          	bltz	a0,80005590 <sys_link+0x13c>
    80005478:	08000613          	li	a2,128
    8000547c:	f5040593          	addi	a1,s0,-176
    80005480:	4505                	li	a0,1
    80005482:	ffffd097          	auipc	ra,0xffffd
    80005486:	680080e7          	jalr	1664(ra) # 80002b02 <argstr>
    return -1;
    8000548a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000548c:	10054263          	bltz	a0,80005590 <sys_link+0x13c>
  begin_op();
    80005490:	fffff097          	auipc	ra,0xfffff
    80005494:	d02080e7          	jalr	-766(ra) # 80004192 <begin_op>
  if((ip = namei(old)) == 0){
    80005498:	ed040513          	addi	a0,s0,-304
    8000549c:	fffff097          	auipc	ra,0xfffff
    800054a0:	ad6080e7          	jalr	-1322(ra) # 80003f72 <namei>
    800054a4:	84aa                	mv	s1,a0
    800054a6:	c551                	beqz	a0,80005532 <sys_link+0xde>
  ilock(ip);
    800054a8:	ffffe097          	auipc	ra,0xffffe
    800054ac:	31e080e7          	jalr	798(ra) # 800037c6 <ilock>
  if(ip->type == T_DIR){
    800054b0:	04449703          	lh	a4,68(s1)
    800054b4:	4785                	li	a5,1
    800054b6:	08f70463          	beq	a4,a5,8000553e <sys_link+0xea>
  ip->nlink++;
    800054ba:	04a4d783          	lhu	a5,74(s1)
    800054be:	2785                	addiw	a5,a5,1
    800054c0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054c4:	8526                	mv	a0,s1
    800054c6:	ffffe097          	auipc	ra,0xffffe
    800054ca:	234080e7          	jalr	564(ra) # 800036fa <iupdate>
  iunlock(ip);
    800054ce:	8526                	mv	a0,s1
    800054d0:	ffffe097          	auipc	ra,0xffffe
    800054d4:	3b8080e7          	jalr	952(ra) # 80003888 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800054d8:	fd040593          	addi	a1,s0,-48
    800054dc:	f5040513          	addi	a0,s0,-176
    800054e0:	fffff097          	auipc	ra,0xfffff
    800054e4:	ab0080e7          	jalr	-1360(ra) # 80003f90 <nameiparent>
    800054e8:	892a                	mv	s2,a0
    800054ea:	c935                	beqz	a0,8000555e <sys_link+0x10a>
  ilock(dp);
    800054ec:	ffffe097          	auipc	ra,0xffffe
    800054f0:	2da080e7          	jalr	730(ra) # 800037c6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800054f4:	00092703          	lw	a4,0(s2)
    800054f8:	409c                	lw	a5,0(s1)
    800054fa:	04f71d63          	bne	a4,a5,80005554 <sys_link+0x100>
    800054fe:	40d0                	lw	a2,4(s1)
    80005500:	fd040593          	addi	a1,s0,-48
    80005504:	854a                	mv	a0,s2
    80005506:	fffff097          	auipc	ra,0xfffff
    8000550a:	9ba080e7          	jalr	-1606(ra) # 80003ec0 <dirlink>
    8000550e:	04054363          	bltz	a0,80005554 <sys_link+0x100>
  iunlockput(dp);
    80005512:	854a                	mv	a0,s2
    80005514:	ffffe097          	auipc	ra,0xffffe
    80005518:	514080e7          	jalr	1300(ra) # 80003a28 <iunlockput>
  iput(ip);
    8000551c:	8526                	mv	a0,s1
    8000551e:	ffffe097          	auipc	ra,0xffffe
    80005522:	462080e7          	jalr	1122(ra) # 80003980 <iput>
  end_op();
    80005526:	fffff097          	auipc	ra,0xfffff
    8000552a:	cea080e7          	jalr	-790(ra) # 80004210 <end_op>
  return 0;
    8000552e:	4781                	li	a5,0
    80005530:	a085                	j	80005590 <sys_link+0x13c>
    end_op();
    80005532:	fffff097          	auipc	ra,0xfffff
    80005536:	cde080e7          	jalr	-802(ra) # 80004210 <end_op>
    return -1;
    8000553a:	57fd                	li	a5,-1
    8000553c:	a891                	j	80005590 <sys_link+0x13c>
    iunlockput(ip);
    8000553e:	8526                	mv	a0,s1
    80005540:	ffffe097          	auipc	ra,0xffffe
    80005544:	4e8080e7          	jalr	1256(ra) # 80003a28 <iunlockput>
    end_op();
    80005548:	fffff097          	auipc	ra,0xfffff
    8000554c:	cc8080e7          	jalr	-824(ra) # 80004210 <end_op>
    return -1;
    80005550:	57fd                	li	a5,-1
    80005552:	a83d                	j	80005590 <sys_link+0x13c>
    iunlockput(dp);
    80005554:	854a                	mv	a0,s2
    80005556:	ffffe097          	auipc	ra,0xffffe
    8000555a:	4d2080e7          	jalr	1234(ra) # 80003a28 <iunlockput>
  ilock(ip);
    8000555e:	8526                	mv	a0,s1
    80005560:	ffffe097          	auipc	ra,0xffffe
    80005564:	266080e7          	jalr	614(ra) # 800037c6 <ilock>
  ip->nlink--;
    80005568:	04a4d783          	lhu	a5,74(s1)
    8000556c:	37fd                	addiw	a5,a5,-1
    8000556e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005572:	8526                	mv	a0,s1
    80005574:	ffffe097          	auipc	ra,0xffffe
    80005578:	186080e7          	jalr	390(ra) # 800036fa <iupdate>
  iunlockput(ip);
    8000557c:	8526                	mv	a0,s1
    8000557e:	ffffe097          	auipc	ra,0xffffe
    80005582:	4aa080e7          	jalr	1194(ra) # 80003a28 <iunlockput>
  end_op();
    80005586:	fffff097          	auipc	ra,0xfffff
    8000558a:	c8a080e7          	jalr	-886(ra) # 80004210 <end_op>
  return -1;
    8000558e:	57fd                	li	a5,-1
}
    80005590:	853e                	mv	a0,a5
    80005592:	70b2                	ld	ra,296(sp)
    80005594:	7412                	ld	s0,288(sp)
    80005596:	64f2                	ld	s1,280(sp)
    80005598:	6952                	ld	s2,272(sp)
    8000559a:	6155                	addi	sp,sp,304
    8000559c:	8082                	ret

000000008000559e <sys_unlink>:
{
    8000559e:	7151                	addi	sp,sp,-240
    800055a0:	f586                	sd	ra,232(sp)
    800055a2:	f1a2                	sd	s0,224(sp)
    800055a4:	eda6                	sd	s1,216(sp)
    800055a6:	e9ca                	sd	s2,208(sp)
    800055a8:	e5ce                	sd	s3,200(sp)
    800055aa:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800055ac:	08000613          	li	a2,128
    800055b0:	f3040593          	addi	a1,s0,-208
    800055b4:	4501                	li	a0,0
    800055b6:	ffffd097          	auipc	ra,0xffffd
    800055ba:	54c080e7          	jalr	1356(ra) # 80002b02 <argstr>
    800055be:	18054163          	bltz	a0,80005740 <sys_unlink+0x1a2>
  begin_op();
    800055c2:	fffff097          	auipc	ra,0xfffff
    800055c6:	bd0080e7          	jalr	-1072(ra) # 80004192 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800055ca:	fb040593          	addi	a1,s0,-80
    800055ce:	f3040513          	addi	a0,s0,-208
    800055d2:	fffff097          	auipc	ra,0xfffff
    800055d6:	9be080e7          	jalr	-1602(ra) # 80003f90 <nameiparent>
    800055da:	84aa                	mv	s1,a0
    800055dc:	c979                	beqz	a0,800056b2 <sys_unlink+0x114>
  ilock(dp);
    800055de:	ffffe097          	auipc	ra,0xffffe
    800055e2:	1e8080e7          	jalr	488(ra) # 800037c6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800055e6:	00003597          	auipc	a1,0x3
    800055ea:	1b258593          	addi	a1,a1,434 # 80008798 <syscalls+0x348>
    800055ee:	fb040513          	addi	a0,s0,-80
    800055f2:	ffffe097          	auipc	ra,0xffffe
    800055f6:	69e080e7          	jalr	1694(ra) # 80003c90 <namecmp>
    800055fa:	14050a63          	beqz	a0,8000574e <sys_unlink+0x1b0>
    800055fe:	00003597          	auipc	a1,0x3
    80005602:	1a258593          	addi	a1,a1,418 # 800087a0 <syscalls+0x350>
    80005606:	fb040513          	addi	a0,s0,-80
    8000560a:	ffffe097          	auipc	ra,0xffffe
    8000560e:	686080e7          	jalr	1670(ra) # 80003c90 <namecmp>
    80005612:	12050e63          	beqz	a0,8000574e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005616:	f2c40613          	addi	a2,s0,-212
    8000561a:	fb040593          	addi	a1,s0,-80
    8000561e:	8526                	mv	a0,s1
    80005620:	ffffe097          	auipc	ra,0xffffe
    80005624:	68a080e7          	jalr	1674(ra) # 80003caa <dirlookup>
    80005628:	892a                	mv	s2,a0
    8000562a:	12050263          	beqz	a0,8000574e <sys_unlink+0x1b0>
  ilock(ip);
    8000562e:	ffffe097          	auipc	ra,0xffffe
    80005632:	198080e7          	jalr	408(ra) # 800037c6 <ilock>
  if(ip->nlink < 1)
    80005636:	04a91783          	lh	a5,74(s2)
    8000563a:	08f05263          	blez	a5,800056be <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000563e:	04491703          	lh	a4,68(s2)
    80005642:	4785                	li	a5,1
    80005644:	08f70563          	beq	a4,a5,800056ce <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005648:	4641                	li	a2,16
    8000564a:	4581                	li	a1,0
    8000564c:	fc040513          	addi	a0,s0,-64
    80005650:	ffffb097          	auipc	ra,0xffffb
    80005654:	682080e7          	jalr	1666(ra) # 80000cd2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005658:	4741                	li	a4,16
    8000565a:	f2c42683          	lw	a3,-212(s0)
    8000565e:	fc040613          	addi	a2,s0,-64
    80005662:	4581                	li	a1,0
    80005664:	8526                	mv	a0,s1
    80005666:	ffffe097          	auipc	ra,0xffffe
    8000566a:	50c080e7          	jalr	1292(ra) # 80003b72 <writei>
    8000566e:	47c1                	li	a5,16
    80005670:	0af51563          	bne	a0,a5,8000571a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005674:	04491703          	lh	a4,68(s2)
    80005678:	4785                	li	a5,1
    8000567a:	0af70863          	beq	a4,a5,8000572a <sys_unlink+0x18c>
  iunlockput(dp);
    8000567e:	8526                	mv	a0,s1
    80005680:	ffffe097          	auipc	ra,0xffffe
    80005684:	3a8080e7          	jalr	936(ra) # 80003a28 <iunlockput>
  ip->nlink--;
    80005688:	04a95783          	lhu	a5,74(s2)
    8000568c:	37fd                	addiw	a5,a5,-1
    8000568e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005692:	854a                	mv	a0,s2
    80005694:	ffffe097          	auipc	ra,0xffffe
    80005698:	066080e7          	jalr	102(ra) # 800036fa <iupdate>
  iunlockput(ip);
    8000569c:	854a                	mv	a0,s2
    8000569e:	ffffe097          	auipc	ra,0xffffe
    800056a2:	38a080e7          	jalr	906(ra) # 80003a28 <iunlockput>
  end_op();
    800056a6:	fffff097          	auipc	ra,0xfffff
    800056aa:	b6a080e7          	jalr	-1174(ra) # 80004210 <end_op>
  return 0;
    800056ae:	4501                	li	a0,0
    800056b0:	a84d                	j	80005762 <sys_unlink+0x1c4>
    end_op();
    800056b2:	fffff097          	auipc	ra,0xfffff
    800056b6:	b5e080e7          	jalr	-1186(ra) # 80004210 <end_op>
    return -1;
    800056ba:	557d                	li	a0,-1
    800056bc:	a05d                	j	80005762 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800056be:	00003517          	auipc	a0,0x3
    800056c2:	0ea50513          	addi	a0,a0,234 # 800087a8 <syscalls+0x358>
    800056c6:	ffffb097          	auipc	ra,0xffffb
    800056ca:	e7a080e7          	jalr	-390(ra) # 80000540 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056ce:	04c92703          	lw	a4,76(s2)
    800056d2:	02000793          	li	a5,32
    800056d6:	f6e7f9e3          	bgeu	a5,a4,80005648 <sys_unlink+0xaa>
    800056da:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056de:	4741                	li	a4,16
    800056e0:	86ce                	mv	a3,s3
    800056e2:	f1840613          	addi	a2,s0,-232
    800056e6:	4581                	li	a1,0
    800056e8:	854a                	mv	a0,s2
    800056ea:	ffffe097          	auipc	ra,0xffffe
    800056ee:	390080e7          	jalr	912(ra) # 80003a7a <readi>
    800056f2:	47c1                	li	a5,16
    800056f4:	00f51b63          	bne	a0,a5,8000570a <sys_unlink+0x16c>
    if(de.inum != 0)
    800056f8:	f1845783          	lhu	a5,-232(s0)
    800056fc:	e7a1                	bnez	a5,80005744 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056fe:	29c1                	addiw	s3,s3,16
    80005700:	04c92783          	lw	a5,76(s2)
    80005704:	fcf9ede3          	bltu	s3,a5,800056de <sys_unlink+0x140>
    80005708:	b781                	j	80005648 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000570a:	00003517          	auipc	a0,0x3
    8000570e:	0b650513          	addi	a0,a0,182 # 800087c0 <syscalls+0x370>
    80005712:	ffffb097          	auipc	ra,0xffffb
    80005716:	e2e080e7          	jalr	-466(ra) # 80000540 <panic>
    panic("unlink: writei");
    8000571a:	00003517          	auipc	a0,0x3
    8000571e:	0be50513          	addi	a0,a0,190 # 800087d8 <syscalls+0x388>
    80005722:	ffffb097          	auipc	ra,0xffffb
    80005726:	e1e080e7          	jalr	-482(ra) # 80000540 <panic>
    dp->nlink--;
    8000572a:	04a4d783          	lhu	a5,74(s1)
    8000572e:	37fd                	addiw	a5,a5,-1
    80005730:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005734:	8526                	mv	a0,s1
    80005736:	ffffe097          	auipc	ra,0xffffe
    8000573a:	fc4080e7          	jalr	-60(ra) # 800036fa <iupdate>
    8000573e:	b781                	j	8000567e <sys_unlink+0xe0>
    return -1;
    80005740:	557d                	li	a0,-1
    80005742:	a005                	j	80005762 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005744:	854a                	mv	a0,s2
    80005746:	ffffe097          	auipc	ra,0xffffe
    8000574a:	2e2080e7          	jalr	738(ra) # 80003a28 <iunlockput>
  iunlockput(dp);
    8000574e:	8526                	mv	a0,s1
    80005750:	ffffe097          	auipc	ra,0xffffe
    80005754:	2d8080e7          	jalr	728(ra) # 80003a28 <iunlockput>
  end_op();
    80005758:	fffff097          	auipc	ra,0xfffff
    8000575c:	ab8080e7          	jalr	-1352(ra) # 80004210 <end_op>
  return -1;
    80005760:	557d                	li	a0,-1
}
    80005762:	70ae                	ld	ra,232(sp)
    80005764:	740e                	ld	s0,224(sp)
    80005766:	64ee                	ld	s1,216(sp)
    80005768:	694e                	ld	s2,208(sp)
    8000576a:	69ae                	ld	s3,200(sp)
    8000576c:	616d                	addi	sp,sp,240
    8000576e:	8082                	ret

0000000080005770 <sys_open>:

uint64
sys_open(void)
{
    80005770:	7131                	addi	sp,sp,-192
    80005772:	fd06                	sd	ra,184(sp)
    80005774:	f922                	sd	s0,176(sp)
    80005776:	f526                	sd	s1,168(sp)
    80005778:	f14a                	sd	s2,160(sp)
    8000577a:	ed4e                	sd	s3,152(sp)
    8000577c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000577e:	f4c40593          	addi	a1,s0,-180
    80005782:	4505                	li	a0,1
    80005784:	ffffd097          	auipc	ra,0xffffd
    80005788:	33e080e7          	jalr	830(ra) # 80002ac2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000578c:	08000613          	li	a2,128
    80005790:	f5040593          	addi	a1,s0,-176
    80005794:	4501                	li	a0,0
    80005796:	ffffd097          	auipc	ra,0xffffd
    8000579a:	36c080e7          	jalr	876(ra) # 80002b02 <argstr>
    8000579e:	87aa                	mv	a5,a0
    return -1;
    800057a0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800057a2:	0a07c963          	bltz	a5,80005854 <sys_open+0xe4>

  begin_op();
    800057a6:	fffff097          	auipc	ra,0xfffff
    800057aa:	9ec080e7          	jalr	-1556(ra) # 80004192 <begin_op>

  if(omode & O_CREATE){
    800057ae:	f4c42783          	lw	a5,-180(s0)
    800057b2:	2007f793          	andi	a5,a5,512
    800057b6:	cfc5                	beqz	a5,8000586e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800057b8:	4681                	li	a3,0
    800057ba:	4601                	li	a2,0
    800057bc:	4589                	li	a1,2
    800057be:	f5040513          	addi	a0,s0,-176
    800057c2:	00000097          	auipc	ra,0x0
    800057c6:	972080e7          	jalr	-1678(ra) # 80005134 <create>
    800057ca:	84aa                	mv	s1,a0
    if(ip == 0){
    800057cc:	c959                	beqz	a0,80005862 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800057ce:	04449703          	lh	a4,68(s1)
    800057d2:	478d                	li	a5,3
    800057d4:	00f71763          	bne	a4,a5,800057e2 <sys_open+0x72>
    800057d8:	0464d703          	lhu	a4,70(s1)
    800057dc:	47a5                	li	a5,9
    800057de:	0ce7ed63          	bltu	a5,a4,800058b8 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800057e2:	fffff097          	auipc	ra,0xfffff
    800057e6:	dbc080e7          	jalr	-580(ra) # 8000459e <filealloc>
    800057ea:	89aa                	mv	s3,a0
    800057ec:	10050363          	beqz	a0,800058f2 <sys_open+0x182>
    800057f0:	00000097          	auipc	ra,0x0
    800057f4:	902080e7          	jalr	-1790(ra) # 800050f2 <fdalloc>
    800057f8:	892a                	mv	s2,a0
    800057fa:	0e054763          	bltz	a0,800058e8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800057fe:	04449703          	lh	a4,68(s1)
    80005802:	478d                	li	a5,3
    80005804:	0cf70563          	beq	a4,a5,800058ce <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005808:	4789                	li	a5,2
    8000580a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000580e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005812:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005816:	f4c42783          	lw	a5,-180(s0)
    8000581a:	0017c713          	xori	a4,a5,1
    8000581e:	8b05                	andi	a4,a4,1
    80005820:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005824:	0037f713          	andi	a4,a5,3
    80005828:	00e03733          	snez	a4,a4
    8000582c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005830:	4007f793          	andi	a5,a5,1024
    80005834:	c791                	beqz	a5,80005840 <sys_open+0xd0>
    80005836:	04449703          	lh	a4,68(s1)
    8000583a:	4789                	li	a5,2
    8000583c:	0af70063          	beq	a4,a5,800058dc <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005840:	8526                	mv	a0,s1
    80005842:	ffffe097          	auipc	ra,0xffffe
    80005846:	046080e7          	jalr	70(ra) # 80003888 <iunlock>
  end_op();
    8000584a:	fffff097          	auipc	ra,0xfffff
    8000584e:	9c6080e7          	jalr	-1594(ra) # 80004210 <end_op>

  return fd;
    80005852:	854a                	mv	a0,s2
}
    80005854:	70ea                	ld	ra,184(sp)
    80005856:	744a                	ld	s0,176(sp)
    80005858:	74aa                	ld	s1,168(sp)
    8000585a:	790a                	ld	s2,160(sp)
    8000585c:	69ea                	ld	s3,152(sp)
    8000585e:	6129                	addi	sp,sp,192
    80005860:	8082                	ret
      end_op();
    80005862:	fffff097          	auipc	ra,0xfffff
    80005866:	9ae080e7          	jalr	-1618(ra) # 80004210 <end_op>
      return -1;
    8000586a:	557d                	li	a0,-1
    8000586c:	b7e5                	j	80005854 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    8000586e:	f5040513          	addi	a0,s0,-176
    80005872:	ffffe097          	auipc	ra,0xffffe
    80005876:	700080e7          	jalr	1792(ra) # 80003f72 <namei>
    8000587a:	84aa                	mv	s1,a0
    8000587c:	c905                	beqz	a0,800058ac <sys_open+0x13c>
    ilock(ip);
    8000587e:	ffffe097          	auipc	ra,0xffffe
    80005882:	f48080e7          	jalr	-184(ra) # 800037c6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005886:	04449703          	lh	a4,68(s1)
    8000588a:	4785                	li	a5,1
    8000588c:	f4f711e3          	bne	a4,a5,800057ce <sys_open+0x5e>
    80005890:	f4c42783          	lw	a5,-180(s0)
    80005894:	d7b9                	beqz	a5,800057e2 <sys_open+0x72>
      iunlockput(ip);
    80005896:	8526                	mv	a0,s1
    80005898:	ffffe097          	auipc	ra,0xffffe
    8000589c:	190080e7          	jalr	400(ra) # 80003a28 <iunlockput>
      end_op();
    800058a0:	fffff097          	auipc	ra,0xfffff
    800058a4:	970080e7          	jalr	-1680(ra) # 80004210 <end_op>
      return -1;
    800058a8:	557d                	li	a0,-1
    800058aa:	b76d                	j	80005854 <sys_open+0xe4>
      end_op();
    800058ac:	fffff097          	auipc	ra,0xfffff
    800058b0:	964080e7          	jalr	-1692(ra) # 80004210 <end_op>
      return -1;
    800058b4:	557d                	li	a0,-1
    800058b6:	bf79                	j	80005854 <sys_open+0xe4>
    iunlockput(ip);
    800058b8:	8526                	mv	a0,s1
    800058ba:	ffffe097          	auipc	ra,0xffffe
    800058be:	16e080e7          	jalr	366(ra) # 80003a28 <iunlockput>
    end_op();
    800058c2:	fffff097          	auipc	ra,0xfffff
    800058c6:	94e080e7          	jalr	-1714(ra) # 80004210 <end_op>
    return -1;
    800058ca:	557d                	li	a0,-1
    800058cc:	b761                	j	80005854 <sys_open+0xe4>
    f->type = FD_DEVICE;
    800058ce:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800058d2:	04649783          	lh	a5,70(s1)
    800058d6:	02f99223          	sh	a5,36(s3)
    800058da:	bf25                	j	80005812 <sys_open+0xa2>
    itrunc(ip);
    800058dc:	8526                	mv	a0,s1
    800058de:	ffffe097          	auipc	ra,0xffffe
    800058e2:	ff6080e7          	jalr	-10(ra) # 800038d4 <itrunc>
    800058e6:	bfa9                	j	80005840 <sys_open+0xd0>
      fileclose(f);
    800058e8:	854e                	mv	a0,s3
    800058ea:	fffff097          	auipc	ra,0xfffff
    800058ee:	d70080e7          	jalr	-656(ra) # 8000465a <fileclose>
    iunlockput(ip);
    800058f2:	8526                	mv	a0,s1
    800058f4:	ffffe097          	auipc	ra,0xffffe
    800058f8:	134080e7          	jalr	308(ra) # 80003a28 <iunlockput>
    end_op();
    800058fc:	fffff097          	auipc	ra,0xfffff
    80005900:	914080e7          	jalr	-1772(ra) # 80004210 <end_op>
    return -1;
    80005904:	557d                	li	a0,-1
    80005906:	b7b9                	j	80005854 <sys_open+0xe4>

0000000080005908 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005908:	7175                	addi	sp,sp,-144
    8000590a:	e506                	sd	ra,136(sp)
    8000590c:	e122                	sd	s0,128(sp)
    8000590e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005910:	fffff097          	auipc	ra,0xfffff
    80005914:	882080e7          	jalr	-1918(ra) # 80004192 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005918:	08000613          	li	a2,128
    8000591c:	f7040593          	addi	a1,s0,-144
    80005920:	4501                	li	a0,0
    80005922:	ffffd097          	auipc	ra,0xffffd
    80005926:	1e0080e7          	jalr	480(ra) # 80002b02 <argstr>
    8000592a:	02054963          	bltz	a0,8000595c <sys_mkdir+0x54>
    8000592e:	4681                	li	a3,0
    80005930:	4601                	li	a2,0
    80005932:	4585                	li	a1,1
    80005934:	f7040513          	addi	a0,s0,-144
    80005938:	fffff097          	auipc	ra,0xfffff
    8000593c:	7fc080e7          	jalr	2044(ra) # 80005134 <create>
    80005940:	cd11                	beqz	a0,8000595c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005942:	ffffe097          	auipc	ra,0xffffe
    80005946:	0e6080e7          	jalr	230(ra) # 80003a28 <iunlockput>
  end_op();
    8000594a:	fffff097          	auipc	ra,0xfffff
    8000594e:	8c6080e7          	jalr	-1850(ra) # 80004210 <end_op>
  return 0;
    80005952:	4501                	li	a0,0
}
    80005954:	60aa                	ld	ra,136(sp)
    80005956:	640a                	ld	s0,128(sp)
    80005958:	6149                	addi	sp,sp,144
    8000595a:	8082                	ret
    end_op();
    8000595c:	fffff097          	auipc	ra,0xfffff
    80005960:	8b4080e7          	jalr	-1868(ra) # 80004210 <end_op>
    return -1;
    80005964:	557d                	li	a0,-1
    80005966:	b7fd                	j	80005954 <sys_mkdir+0x4c>

0000000080005968 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005968:	7135                	addi	sp,sp,-160
    8000596a:	ed06                	sd	ra,152(sp)
    8000596c:	e922                	sd	s0,144(sp)
    8000596e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005970:	fffff097          	auipc	ra,0xfffff
    80005974:	822080e7          	jalr	-2014(ra) # 80004192 <begin_op>
  argint(1, &major);
    80005978:	f6c40593          	addi	a1,s0,-148
    8000597c:	4505                	li	a0,1
    8000597e:	ffffd097          	auipc	ra,0xffffd
    80005982:	144080e7          	jalr	324(ra) # 80002ac2 <argint>
  argint(2, &minor);
    80005986:	f6840593          	addi	a1,s0,-152
    8000598a:	4509                	li	a0,2
    8000598c:	ffffd097          	auipc	ra,0xffffd
    80005990:	136080e7          	jalr	310(ra) # 80002ac2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005994:	08000613          	li	a2,128
    80005998:	f7040593          	addi	a1,s0,-144
    8000599c:	4501                	li	a0,0
    8000599e:	ffffd097          	auipc	ra,0xffffd
    800059a2:	164080e7          	jalr	356(ra) # 80002b02 <argstr>
    800059a6:	02054b63          	bltz	a0,800059dc <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800059aa:	f6841683          	lh	a3,-152(s0)
    800059ae:	f6c41603          	lh	a2,-148(s0)
    800059b2:	458d                	li	a1,3
    800059b4:	f7040513          	addi	a0,s0,-144
    800059b8:	fffff097          	auipc	ra,0xfffff
    800059bc:	77c080e7          	jalr	1916(ra) # 80005134 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800059c0:	cd11                	beqz	a0,800059dc <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800059c2:	ffffe097          	auipc	ra,0xffffe
    800059c6:	066080e7          	jalr	102(ra) # 80003a28 <iunlockput>
  end_op();
    800059ca:	fffff097          	auipc	ra,0xfffff
    800059ce:	846080e7          	jalr	-1978(ra) # 80004210 <end_op>
  return 0;
    800059d2:	4501                	li	a0,0
}
    800059d4:	60ea                	ld	ra,152(sp)
    800059d6:	644a                	ld	s0,144(sp)
    800059d8:	610d                	addi	sp,sp,160
    800059da:	8082                	ret
    end_op();
    800059dc:	fffff097          	auipc	ra,0xfffff
    800059e0:	834080e7          	jalr	-1996(ra) # 80004210 <end_op>
    return -1;
    800059e4:	557d                	li	a0,-1
    800059e6:	b7fd                	j	800059d4 <sys_mknod+0x6c>

00000000800059e8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800059e8:	7135                	addi	sp,sp,-160
    800059ea:	ed06                	sd	ra,152(sp)
    800059ec:	e922                	sd	s0,144(sp)
    800059ee:	e526                	sd	s1,136(sp)
    800059f0:	e14a                	sd	s2,128(sp)
    800059f2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800059f4:	ffffc097          	auipc	ra,0xffffc
    800059f8:	fb8080e7          	jalr	-72(ra) # 800019ac <myproc>
    800059fc:	892a                	mv	s2,a0
  
  begin_op();
    800059fe:	ffffe097          	auipc	ra,0xffffe
    80005a02:	794080e7          	jalr	1940(ra) # 80004192 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005a06:	08000613          	li	a2,128
    80005a0a:	f6040593          	addi	a1,s0,-160
    80005a0e:	4501                	li	a0,0
    80005a10:	ffffd097          	auipc	ra,0xffffd
    80005a14:	0f2080e7          	jalr	242(ra) # 80002b02 <argstr>
    80005a18:	04054b63          	bltz	a0,80005a6e <sys_chdir+0x86>
    80005a1c:	f6040513          	addi	a0,s0,-160
    80005a20:	ffffe097          	auipc	ra,0xffffe
    80005a24:	552080e7          	jalr	1362(ra) # 80003f72 <namei>
    80005a28:	84aa                	mv	s1,a0
    80005a2a:	c131                	beqz	a0,80005a6e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005a2c:	ffffe097          	auipc	ra,0xffffe
    80005a30:	d9a080e7          	jalr	-614(ra) # 800037c6 <ilock>
  if(ip->type != T_DIR){
    80005a34:	04449703          	lh	a4,68(s1)
    80005a38:	4785                	li	a5,1
    80005a3a:	04f71063          	bne	a4,a5,80005a7a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005a3e:	8526                	mv	a0,s1
    80005a40:	ffffe097          	auipc	ra,0xffffe
    80005a44:	e48080e7          	jalr	-440(ra) # 80003888 <iunlock>
  iput(p->cwd);
    80005a48:	15093503          	ld	a0,336(s2)
    80005a4c:	ffffe097          	auipc	ra,0xffffe
    80005a50:	f34080e7          	jalr	-204(ra) # 80003980 <iput>
  end_op();
    80005a54:	ffffe097          	auipc	ra,0xffffe
    80005a58:	7bc080e7          	jalr	1980(ra) # 80004210 <end_op>
  p->cwd = ip;
    80005a5c:	14993823          	sd	s1,336(s2)
  return 0;
    80005a60:	4501                	li	a0,0
}
    80005a62:	60ea                	ld	ra,152(sp)
    80005a64:	644a                	ld	s0,144(sp)
    80005a66:	64aa                	ld	s1,136(sp)
    80005a68:	690a                	ld	s2,128(sp)
    80005a6a:	610d                	addi	sp,sp,160
    80005a6c:	8082                	ret
    end_op();
    80005a6e:	ffffe097          	auipc	ra,0xffffe
    80005a72:	7a2080e7          	jalr	1954(ra) # 80004210 <end_op>
    return -1;
    80005a76:	557d                	li	a0,-1
    80005a78:	b7ed                	j	80005a62 <sys_chdir+0x7a>
    iunlockput(ip);
    80005a7a:	8526                	mv	a0,s1
    80005a7c:	ffffe097          	auipc	ra,0xffffe
    80005a80:	fac080e7          	jalr	-84(ra) # 80003a28 <iunlockput>
    end_op();
    80005a84:	ffffe097          	auipc	ra,0xffffe
    80005a88:	78c080e7          	jalr	1932(ra) # 80004210 <end_op>
    return -1;
    80005a8c:	557d                	li	a0,-1
    80005a8e:	bfd1                	j	80005a62 <sys_chdir+0x7a>

0000000080005a90 <sys_exec>:

uint64
sys_exec(void)
{
    80005a90:	7145                	addi	sp,sp,-464
    80005a92:	e786                	sd	ra,456(sp)
    80005a94:	e3a2                	sd	s0,448(sp)
    80005a96:	ff26                	sd	s1,440(sp)
    80005a98:	fb4a                	sd	s2,432(sp)
    80005a9a:	f74e                	sd	s3,424(sp)
    80005a9c:	f352                	sd	s4,416(sp)
    80005a9e:	ef56                	sd	s5,408(sp)
    80005aa0:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005aa2:	e3840593          	addi	a1,s0,-456
    80005aa6:	4505                	li	a0,1
    80005aa8:	ffffd097          	auipc	ra,0xffffd
    80005aac:	03a080e7          	jalr	58(ra) # 80002ae2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005ab0:	08000613          	li	a2,128
    80005ab4:	f4040593          	addi	a1,s0,-192
    80005ab8:	4501                	li	a0,0
    80005aba:	ffffd097          	auipc	ra,0xffffd
    80005abe:	048080e7          	jalr	72(ra) # 80002b02 <argstr>
    80005ac2:	87aa                	mv	a5,a0
    return -1;
    80005ac4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005ac6:	0c07c363          	bltz	a5,80005b8c <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80005aca:	10000613          	li	a2,256
    80005ace:	4581                	li	a1,0
    80005ad0:	e4040513          	addi	a0,s0,-448
    80005ad4:	ffffb097          	auipc	ra,0xffffb
    80005ad8:	1fe080e7          	jalr	510(ra) # 80000cd2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005adc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005ae0:	89a6                	mv	s3,s1
    80005ae2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005ae4:	02000a13          	li	s4,32
    80005ae8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005aec:	00391513          	slli	a0,s2,0x3
    80005af0:	e3040593          	addi	a1,s0,-464
    80005af4:	e3843783          	ld	a5,-456(s0)
    80005af8:	953e                	add	a0,a0,a5
    80005afa:	ffffd097          	auipc	ra,0xffffd
    80005afe:	f2a080e7          	jalr	-214(ra) # 80002a24 <fetchaddr>
    80005b02:	02054a63          	bltz	a0,80005b36 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005b06:	e3043783          	ld	a5,-464(s0)
    80005b0a:	c3b9                	beqz	a5,80005b50 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005b0c:	ffffb097          	auipc	ra,0xffffb
    80005b10:	fda080e7          	jalr	-38(ra) # 80000ae6 <kalloc>
    80005b14:	85aa                	mv	a1,a0
    80005b16:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005b1a:	cd11                	beqz	a0,80005b36 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005b1c:	6605                	lui	a2,0x1
    80005b1e:	e3043503          	ld	a0,-464(s0)
    80005b22:	ffffd097          	auipc	ra,0xffffd
    80005b26:	f54080e7          	jalr	-172(ra) # 80002a76 <fetchstr>
    80005b2a:	00054663          	bltz	a0,80005b36 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005b2e:	0905                	addi	s2,s2,1
    80005b30:	09a1                	addi	s3,s3,8
    80005b32:	fb491be3          	bne	s2,s4,80005ae8 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b36:	f4040913          	addi	s2,s0,-192
    80005b3a:	6088                	ld	a0,0(s1)
    80005b3c:	c539                	beqz	a0,80005b8a <sys_exec+0xfa>
    kfree(argv[i]);
    80005b3e:	ffffb097          	auipc	ra,0xffffb
    80005b42:	eaa080e7          	jalr	-342(ra) # 800009e8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b46:	04a1                	addi	s1,s1,8
    80005b48:	ff2499e3          	bne	s1,s2,80005b3a <sys_exec+0xaa>
  return -1;
    80005b4c:	557d                	li	a0,-1
    80005b4e:	a83d                	j	80005b8c <sys_exec+0xfc>
      argv[i] = 0;
    80005b50:	0a8e                	slli	s5,s5,0x3
    80005b52:	fc0a8793          	addi	a5,s5,-64
    80005b56:	00878ab3          	add	s5,a5,s0
    80005b5a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005b5e:	e4040593          	addi	a1,s0,-448
    80005b62:	f4040513          	addi	a0,s0,-192
    80005b66:	fffff097          	auipc	ra,0xfffff
    80005b6a:	16e080e7          	jalr	366(ra) # 80004cd4 <exec>
    80005b6e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b70:	f4040993          	addi	s3,s0,-192
    80005b74:	6088                	ld	a0,0(s1)
    80005b76:	c901                	beqz	a0,80005b86 <sys_exec+0xf6>
    kfree(argv[i]);
    80005b78:	ffffb097          	auipc	ra,0xffffb
    80005b7c:	e70080e7          	jalr	-400(ra) # 800009e8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b80:	04a1                	addi	s1,s1,8
    80005b82:	ff3499e3          	bne	s1,s3,80005b74 <sys_exec+0xe4>
  return ret;
    80005b86:	854a                	mv	a0,s2
    80005b88:	a011                	j	80005b8c <sys_exec+0xfc>
  return -1;
    80005b8a:	557d                	li	a0,-1
}
    80005b8c:	60be                	ld	ra,456(sp)
    80005b8e:	641e                	ld	s0,448(sp)
    80005b90:	74fa                	ld	s1,440(sp)
    80005b92:	795a                	ld	s2,432(sp)
    80005b94:	79ba                	ld	s3,424(sp)
    80005b96:	7a1a                	ld	s4,416(sp)
    80005b98:	6afa                	ld	s5,408(sp)
    80005b9a:	6179                	addi	sp,sp,464
    80005b9c:	8082                	ret

0000000080005b9e <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b9e:	7139                	addi	sp,sp,-64
    80005ba0:	fc06                	sd	ra,56(sp)
    80005ba2:	f822                	sd	s0,48(sp)
    80005ba4:	f426                	sd	s1,40(sp)
    80005ba6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005ba8:	ffffc097          	auipc	ra,0xffffc
    80005bac:	e04080e7          	jalr	-508(ra) # 800019ac <myproc>
    80005bb0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005bb2:	fd840593          	addi	a1,s0,-40
    80005bb6:	4501                	li	a0,0
    80005bb8:	ffffd097          	auipc	ra,0xffffd
    80005bbc:	f2a080e7          	jalr	-214(ra) # 80002ae2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005bc0:	fc840593          	addi	a1,s0,-56
    80005bc4:	fd040513          	addi	a0,s0,-48
    80005bc8:	fffff097          	auipc	ra,0xfffff
    80005bcc:	dc2080e7          	jalr	-574(ra) # 8000498a <pipealloc>
    return -1;
    80005bd0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005bd2:	0c054463          	bltz	a0,80005c9a <sys_pipe+0xfc>
  fd0 = -1;
    80005bd6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005bda:	fd043503          	ld	a0,-48(s0)
    80005bde:	fffff097          	auipc	ra,0xfffff
    80005be2:	514080e7          	jalr	1300(ra) # 800050f2 <fdalloc>
    80005be6:	fca42223          	sw	a0,-60(s0)
    80005bea:	08054b63          	bltz	a0,80005c80 <sys_pipe+0xe2>
    80005bee:	fc843503          	ld	a0,-56(s0)
    80005bf2:	fffff097          	auipc	ra,0xfffff
    80005bf6:	500080e7          	jalr	1280(ra) # 800050f2 <fdalloc>
    80005bfa:	fca42023          	sw	a0,-64(s0)
    80005bfe:	06054863          	bltz	a0,80005c6e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c02:	4691                	li	a3,4
    80005c04:	fc440613          	addi	a2,s0,-60
    80005c08:	fd843583          	ld	a1,-40(s0)
    80005c0c:	68a8                	ld	a0,80(s1)
    80005c0e:	ffffc097          	auipc	ra,0xffffc
    80005c12:	a5e080e7          	jalr	-1442(ra) # 8000166c <copyout>
    80005c16:	02054063          	bltz	a0,80005c36 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005c1a:	4691                	li	a3,4
    80005c1c:	fc040613          	addi	a2,s0,-64
    80005c20:	fd843583          	ld	a1,-40(s0)
    80005c24:	0591                	addi	a1,a1,4
    80005c26:	68a8                	ld	a0,80(s1)
    80005c28:	ffffc097          	auipc	ra,0xffffc
    80005c2c:	a44080e7          	jalr	-1468(ra) # 8000166c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005c30:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c32:	06055463          	bgez	a0,80005c9a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005c36:	fc442783          	lw	a5,-60(s0)
    80005c3a:	07e9                	addi	a5,a5,26
    80005c3c:	078e                	slli	a5,a5,0x3
    80005c3e:	97a6                	add	a5,a5,s1
    80005c40:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005c44:	fc042783          	lw	a5,-64(s0)
    80005c48:	07e9                	addi	a5,a5,26
    80005c4a:	078e                	slli	a5,a5,0x3
    80005c4c:	94be                	add	s1,s1,a5
    80005c4e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005c52:	fd043503          	ld	a0,-48(s0)
    80005c56:	fffff097          	auipc	ra,0xfffff
    80005c5a:	a04080e7          	jalr	-1532(ra) # 8000465a <fileclose>
    fileclose(wf);
    80005c5e:	fc843503          	ld	a0,-56(s0)
    80005c62:	fffff097          	auipc	ra,0xfffff
    80005c66:	9f8080e7          	jalr	-1544(ra) # 8000465a <fileclose>
    return -1;
    80005c6a:	57fd                	li	a5,-1
    80005c6c:	a03d                	j	80005c9a <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005c6e:	fc442783          	lw	a5,-60(s0)
    80005c72:	0007c763          	bltz	a5,80005c80 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005c76:	07e9                	addi	a5,a5,26
    80005c78:	078e                	slli	a5,a5,0x3
    80005c7a:	97a6                	add	a5,a5,s1
    80005c7c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005c80:	fd043503          	ld	a0,-48(s0)
    80005c84:	fffff097          	auipc	ra,0xfffff
    80005c88:	9d6080e7          	jalr	-1578(ra) # 8000465a <fileclose>
    fileclose(wf);
    80005c8c:	fc843503          	ld	a0,-56(s0)
    80005c90:	fffff097          	auipc	ra,0xfffff
    80005c94:	9ca080e7          	jalr	-1590(ra) # 8000465a <fileclose>
    return -1;
    80005c98:	57fd                	li	a5,-1
}
    80005c9a:	853e                	mv	a0,a5
    80005c9c:	70e2                	ld	ra,56(sp)
    80005c9e:	7442                	ld	s0,48(sp)
    80005ca0:	74a2                	ld	s1,40(sp)
    80005ca2:	6121                	addi	sp,sp,64
    80005ca4:	8082                	ret

0000000080005ca6 <head_run>:
void head_run(int fd, int numOfLines){

  char line[MAX_LINE_LEN];
  int readStatus;

  while(numOfLines--){
    80005ca6:	c9c1                	beqz	a1,80005d36 <head_run+0x90>
void head_run(int fd, int numOfLines){
    80005ca8:	dd010113          	addi	sp,sp,-560
    80005cac:	22113423          	sd	ra,552(sp)
    80005cb0:	22813023          	sd	s0,544(sp)
    80005cb4:	20913c23          	sd	s1,536(sp)
    80005cb8:	21213823          	sd	s2,528(sp)
    80005cbc:	21313423          	sd	s3,520(sp)
    80005cc0:	21413023          	sd	s4,512(sp)
    80005cc4:	1c00                	addi	s0,sp,560
    80005cc6:	892a                	mv	s2,a0
    80005cc8:	0005849b          	sext.w	s1,a1
    readStatus = read_line(fd, line);

    if (readStatus == -1){
    80005ccc:	59fd                	li	s3,-1
      printf("Error reading from the file \n");
      break;
    }
    line[readStatus]=0;
    printf("%s",line);
    80005cce:	00003a17          	auipc	s4,0x3
    80005cd2:	b3aa0a13          	addi	s4,s4,-1222 # 80008808 <syscalls+0x3b8>
    readStatus = read_line(fd, line);
    80005cd6:	dd840593          	addi	a1,s0,-552
    80005cda:	854a                	mv	a0,s2
    80005cdc:	00001097          	auipc	ra,0x1
    80005ce0:	a9e080e7          	jalr	-1378(ra) # 8000677a <read_line>
    if (readStatus == -1){
    80005ce4:	03350263          	beq	a0,s3,80005d08 <head_run+0x62>
    line[readStatus]=0;
    80005ce8:	fd050793          	addi	a5,a0,-48
    80005cec:	00878533          	add	a0,a5,s0
    80005cf0:	e0050423          	sb	zero,-504(a0)
    printf("%s",line);
    80005cf4:	dd840593          	addi	a1,s0,-552
    80005cf8:	8552                	mv	a0,s4
    80005cfa:	ffffb097          	auipc	ra,0xffffb
    80005cfe:	890080e7          	jalr	-1904(ra) # 8000058a <printf>
  while(numOfLines--){
    80005d02:	34fd                	addiw	s1,s1,-1
    80005d04:	f8e9                	bnez	s1,80005cd6 <head_run+0x30>
    80005d06:	a809                	j	80005d18 <head_run+0x72>
      printf("Error reading from the file \n");
    80005d08:	00003517          	auipc	a0,0x3
    80005d0c:	ae050513          	addi	a0,a0,-1312 # 800087e8 <syscalls+0x398>
    80005d10:	ffffb097          	auipc	ra,0xffffb
    80005d14:	87a080e7          	jalr	-1926(ra) # 8000058a <printf>
  }

}
    80005d18:	22813083          	ld	ra,552(sp)
    80005d1c:	22013403          	ld	s0,544(sp)
    80005d20:	21813483          	ld	s1,536(sp)
    80005d24:	21013903          	ld	s2,528(sp)
    80005d28:	20813983          	ld	s3,520(sp)
    80005d2c:	20013a03          	ld	s4,512(sp)
    80005d30:	23010113          	addi	sp,sp,560
    80005d34:	8082                	ret
    80005d36:	8082                	ret

0000000080005d38 <uniq_run>:





int uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
    80005d38:	ba010113          	addi	sp,sp,-1120
    80005d3c:	44113c23          	sd	ra,1112(sp)
    80005d40:	44813823          	sd	s0,1104(sp)
    80005d44:	44913423          	sd	s1,1096(sp)
    80005d48:	45213023          	sd	s2,1088(sp)
    80005d4c:	43313c23          	sd	s3,1080(sp)
    80005d50:	43413823          	sd	s4,1072(sp)
    80005d54:	43513423          	sd	s5,1064(sp)
    80005d58:	43613023          	sd	s6,1056(sp)
    80005d5c:	41713c23          	sd	s7,1048(sp)
    80005d60:	41813823          	sd	s8,1040(sp)
    80005d64:	41913423          	sd	s9,1032(sp)
    80005d68:	41a13023          	sd	s10,1024(sp)
    80005d6c:	3fb13c23          	sd	s11,1016(sp)
    80005d70:	46010413          	addi	s0,sp,1120
    80005d74:	8a2a                	mv	s4,a0
    80005d76:	8aae                	mv	s5,a1
    80005d78:	8c32                	mv	s8,a2
  
  

  uint64 readStatus;

  readStatus = read_line(fd, line1);
    80005d7a:	d9840593          	addi	a1,s0,-616
    80005d7e:	00001097          	auipc	ra,0x1
    80005d82:	9fc080e7          	jalr	-1540(ra) # 8000677a <read_line>
  // printf("sa\n");

  if (readStatus <= 0)
    80005d86:	c161                	beqz	a0,80005e46 <uniq_run+0x10e>
    return 0;

  line1[readStatus]=0;
    80005d88:	f9050793          	addi	a5,a0,-112
    80005d8c:	00878533          	add	a0,a5,s0
    80005d90:	e0050423          	sb	zero,-504(a0)

  char first = 1;
  uint32 count=1;
    80005d94:	4985                	li	s3,1
  char first = 1;
    80005d96:	4b85                	li	s7,1
  char * line2 = buffer2;
    80005d98:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
    80005d9c:	d9840913          	addi	s2,s0,-616


    /* Compare two lines */
    if (compareStatus != 0){

      if (first==1){
    80005da0:	4b05                	li	s6,1
        first=0;
      }
      if (showCount)
        printf("%d %s",count,line2);
      else
        printf("%s",line2);
    80005da2:	00003d97          	auipc	s11,0x3
    80005da6:	a66d8d93          	addi	s11,s11,-1434 # 80008808 <syscalls+0x3b8>
    80005daa:	4c81                	li	s9,0
        printf("%d %s",count,line2);
    80005dac:	00003d17          	auipc	s10,0x3
    80005db0:	a64d0d13          	addi	s10,s10,-1436 # 80008810 <syscalls+0x3c0>
    80005db4:	a0a9                	j	80005dfe <uniq_run+0xc6>
      compareStatus = compare_str_ic(line1, line2);
    80005db6:	85a6                	mv	a1,s1
    80005db8:	854a                	mv	a0,s2
    80005dba:	00001097          	auipc	ra,0x1
    80005dbe:	a9c080e7          	jalr	-1380(ra) # 80006856 <compare_str_ic>
    80005dc2:	a085                	j	80005e22 <uniq_run+0xea>
        if (showCount)
    80005dc4:	000c0a63          	beqz	s8,80005dd8 <uniq_run+0xa0>
          printf("%d %s",count,line1);
    80005dc8:	864a                	mv	a2,s2
    80005dca:	85ce                	mv	a1,s3
    80005dcc:	856a                	mv	a0,s10
    80005dce:	ffffa097          	auipc	ra,0xffffa
    80005dd2:	7bc080e7          	jalr	1980(ra) # 8000058a <printf>
      if (showCount)
    80005dd6:	a899                	j	80005e2c <uniq_run+0xf4>
          printf("%s",line1);
    80005dd8:	85ca                	mv	a1,s2
    80005dda:	856e                	mv	a0,s11
    80005ddc:	ffffa097          	auipc	ra,0xffffa
    80005de0:	7ae080e7          	jalr	1966(ra) # 8000058a <printf>
        printf("%s",line2);
    80005de4:	85a6                	mv	a1,s1
    80005de6:	856e                	mv	a0,s11
    80005de8:	ffffa097          	auipc	ra,0xffffa
    80005dec:	7a2080e7          	jalr	1954(ra) # 8000058a <printf>
    80005df0:	87ca                	mv	a5,s2

      count = 1;


      void * t = line1;
      line1 = line2;
    80005df2:	8926                	mv	s2,s1
      line2 = t;
    80005df4:	84be                	mv	s1,a5
      count = 1;
    80005df6:	89da                	mv	s3,s6
        printf("%s",line2);
    80005df8:	8be6                	mv	s7,s9
    80005dfa:	a011                	j	80005dfe <uniq_run+0xc6>
    }else{
      // print("EQ:\n");
      // print(line1);
      // print(line2);
      count++;
    80005dfc:	2985                	addiw	s3,s3,1
    readStatus = read_line(fd, line2);
    80005dfe:	85a6                	mv	a1,s1
    80005e00:	8552                	mv	a0,s4
    80005e02:	00001097          	auipc	ra,0x1
    80005e06:	978080e7          	jalr	-1672(ra) # 8000677a <read_line>
    if (readStatus <= 0 )//TODO
    80005e0a:	cd15                	beqz	a0,80005e46 <uniq_run+0x10e>
    line2[readStatus]=0;
    80005e0c:	9526                	add	a0,a0,s1
    80005e0e:	00050023          	sb	zero,0(a0)
    if (!ignoreCase)
    80005e12:	fa0a92e3          	bnez	s5,80005db6 <uniq_run+0x7e>
      compareStatus = compare_str(line1, line2);
    80005e16:	85a6                	mv	a1,s1
    80005e18:	854a                	mv	a0,s2
    80005e1a:	00001097          	auipc	ra,0x1
    80005e1e:	a0e080e7          	jalr	-1522(ra) # 80006828 <compare_str>
    if (compareStatus != 0){
    80005e22:	dd69                	beqz	a0,80005dfc <uniq_run+0xc4>
      if (first==1){
    80005e24:	fb6b80e3          	beq	s7,s6,80005dc4 <uniq_run+0x8c>
      if (showCount)
    80005e28:	fa0c0ee3          	beqz	s8,80005de4 <uniq_run+0xac>
        printf("%d %s",count,line2);
    80005e2c:	8626                	mv	a2,s1
    80005e2e:	85ce                	mv	a1,s3
    80005e30:	856a                	mv	a0,s10
    80005e32:	ffffa097          	auipc	ra,0xffffa
    80005e36:	758080e7          	jalr	1880(ra) # 8000058a <printf>
    80005e3a:	87ca                	mv	a5,s2
      line1 = line2;
    80005e3c:	8926                	mv	s2,s1
      line2 = t;
    80005e3e:	84be                	mv	s1,a5
      count = 1;
    80005e40:	89da                	mv	s3,s6
    80005e42:	8be6                	mv	s7,s9
    80005e44:	bf6d                	j	80005dfe <uniq_run+0xc6>
    }
  }
}
    80005e46:	45813083          	ld	ra,1112(sp)
    80005e4a:	45013403          	ld	s0,1104(sp)
    80005e4e:	44813483          	ld	s1,1096(sp)
    80005e52:	44013903          	ld	s2,1088(sp)
    80005e56:	43813983          	ld	s3,1080(sp)
    80005e5a:	43013a03          	ld	s4,1072(sp)
    80005e5e:	42813a83          	ld	s5,1064(sp)
    80005e62:	42013b03          	ld	s6,1056(sp)
    80005e66:	41813b83          	ld	s7,1048(sp)
    80005e6a:	41013c03          	ld	s8,1040(sp)
    80005e6e:	40813c83          	ld	s9,1032(sp)
    80005e72:	40013d03          	ld	s10,1024(sp)
    80005e76:	3f813d83          	ld	s11,1016(sp)
    80005e7a:	46010113          	addi	sp,sp,1120
    80005e7e:	8082                	ret

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
    80005fe8:	d1c78793          	addi	a5,a5,-740 # 80021d00 <disk>
    80005fec:	97aa                	add	a5,a5,a0
    80005fee:	0187c783          	lbu	a5,24(a5)
    80005ff2:	ebb9                	bnez	a5,80006048 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005ff4:	00451693          	slli	a3,a0,0x4
    80005ff8:	0001c797          	auipc	a5,0x1c
    80005ffc:	d0878793          	addi	a5,a5,-760 # 80021d00 <disk>
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
    80006024:	cf850513          	addi	a0,a0,-776 # 80021d18 <disk+0x18>
    80006028:	ffffc097          	auipc	ra,0xffffc
    8000602c:	090080e7          	jalr	144(ra) # 800020b8 <wakeup>
}
    80006030:	60a2                	ld	ra,8(sp)
    80006032:	6402                	ld	s0,0(sp)
    80006034:	0141                	addi	sp,sp,16
    80006036:	8082                	ret
    panic("free_desc 1");
    80006038:	00002517          	auipc	a0,0x2
    8000603c:	7e050513          	addi	a0,a0,2016 # 80008818 <syscalls+0x3c8>
    80006040:	ffffa097          	auipc	ra,0xffffa
    80006044:	500080e7          	jalr	1280(ra) # 80000540 <panic>
    panic("free_desc 2");
    80006048:	00002517          	auipc	a0,0x2
    8000604c:	7e050513          	addi	a0,a0,2016 # 80008828 <syscalls+0x3d8>
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
    80006068:	7d458593          	addi	a1,a1,2004 # 80008838 <syscalls+0x3e8>
    8000606c:	0001c517          	auipc	a0,0x1c
    80006070:	dbc50513          	addi	a0,a0,-580 # 80021e28 <disk+0x128>
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
    800060d4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc91f>
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
    8000611a:	bea48493          	addi	s1,s1,-1046 # 80021d00 <disk>
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
    8000613e:	bce73703          	ld	a4,-1074(a4) # 80021d08 <disk+0x8>
    80006142:	cb65                	beqz	a4,80006232 <virtio_disk_init+0x1da>
    80006144:	c7fd                	beqz	a5,80006232 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80006146:	6605                	lui	a2,0x1
    80006148:	4581                	li	a1,0
    8000614a:	ffffb097          	auipc	ra,0xffffb
    8000614e:	b88080e7          	jalr	-1144(ra) # 80000cd2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006152:	0001c497          	auipc	s1,0x1c
    80006156:	bae48493          	addi	s1,s1,-1106 # 80021d00 <disk>
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
    800061e6:	66650513          	addi	a0,a0,1638 # 80008848 <syscalls+0x3f8>
    800061ea:	ffffa097          	auipc	ra,0xffffa
    800061ee:	356080e7          	jalr	854(ra) # 80000540 <panic>
    panic("virtio disk FEATURES_OK unset");
    800061f2:	00002517          	auipc	a0,0x2
    800061f6:	67650513          	addi	a0,a0,1654 # 80008868 <syscalls+0x418>
    800061fa:	ffffa097          	auipc	ra,0xffffa
    800061fe:	346080e7          	jalr	838(ra) # 80000540 <panic>
    panic("virtio disk should not be ready");
    80006202:	00002517          	auipc	a0,0x2
    80006206:	68650513          	addi	a0,a0,1670 # 80008888 <syscalls+0x438>
    8000620a:	ffffa097          	auipc	ra,0xffffa
    8000620e:	336080e7          	jalr	822(ra) # 80000540 <panic>
    panic("virtio disk has no queue 0");
    80006212:	00002517          	auipc	a0,0x2
    80006216:	69650513          	addi	a0,a0,1686 # 800088a8 <syscalls+0x458>
    8000621a:	ffffa097          	auipc	ra,0xffffa
    8000621e:	326080e7          	jalr	806(ra) # 80000540 <panic>
    panic("virtio disk max queue too short");
    80006222:	00002517          	auipc	a0,0x2
    80006226:	6a650513          	addi	a0,a0,1702 # 800088c8 <syscalls+0x478>
    8000622a:	ffffa097          	auipc	ra,0xffffa
    8000622e:	316080e7          	jalr	790(ra) # 80000540 <panic>
    panic("virtio disk kalloc");
    80006232:	00002517          	auipc	a0,0x2
    80006236:	6b650513          	addi	a0,a0,1718 # 800088e8 <syscalls+0x498>
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
    80006276:	bb650513          	addi	a0,a0,-1098 # 80021e28 <disk+0x128>
    8000627a:	ffffb097          	auipc	ra,0xffffb
    8000627e:	95c080e7          	jalr	-1700(ra) # 80000bd6 <acquire>
  for(int i = 0; i < 3; i++){
    80006282:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006284:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006286:	0001cb97          	auipc	s7,0x1c
    8000628a:	a7ab8b93          	addi	s7,s7,-1414 # 80021d00 <disk>
  for(int i = 0; i < 3; i++){
    8000628e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006290:	0001cc97          	auipc	s9,0x1c
    80006294:	b98c8c93          	addi	s9,s9,-1128 # 80021e28 <disk+0x128>
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
    800062b6:	a4e70713          	addi	a4,a4,-1458 # 80021d00 <disk>
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
    800062ee:	a2e50513          	addi	a0,a0,-1490 # 80021d18 <disk+0x18>
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
    80006312:	9f278793          	addi	a5,a5,-1550 # 80021d00 <disk>
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
    800063e8:	a4490913          	addi	s2,s2,-1468 # 80021e28 <disk+0x128>
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
    80006414:	8f078793          	addi	a5,a5,-1808 # 80021d00 <disk>
    80006418:	97ba                	add	a5,a5,a4
    8000641a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000641e:	0001c997          	auipc	s3,0x1c
    80006422:	8e298993          	addi	s3,s3,-1822 # 80021d00 <disk>
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
    8000644a:	9e250513          	addi	a0,a0,-1566 # 80021e28 <disk+0x128>
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
    80006482:	88248493          	addi	s1,s1,-1918 # 80021d00 <disk>
    80006486:	0001c517          	auipc	a0,0x1c
    8000648a:	9a250513          	addi	a0,a0,-1630 # 80021e28 <disk+0x128>
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
    80006502:	92a50513          	addi	a0,a0,-1750 # 80021e28 <disk+0x128>
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
    8000651c:	3e850513          	addi	a0,a0,1000 # 80008900 <syscalls+0x4b0>
    80006520:	ffffa097          	auipc	ra,0xffffa
    80006524:	020080e7          	jalr	32(ra) # 80000540 <panic>

0000000080006528 <open_file>:
  iunlockput(dp);
  return 0;
}


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
    80006540:	c56080e7          	jalr	-938(ra) # 80004192 <begin_op>

  if(omode & O_CREATE){
    80006544:	200a7793          	andi	a5,s4,512
    80006548:	c7f5                	beqz	a5,80006634 <open_file+0x10c>
  if((dp = nameiparent(path, name)) == 0)
    8000654a:	fc040593          	addi	a1,s0,-64
    8000654e:	8526                	mv	a0,s1
    80006550:	ffffe097          	auipc	ra,0xffffe
    80006554:	a40080e7          	jalr	-1472(ra) # 80003f90 <nameiparent>
    80006558:	84aa                	mv	s1,a0
    8000655a:	c531                	beqz	a0,800065a6 <open_file+0x7e>
  ilock(dp);
    8000655c:	ffffd097          	auipc	ra,0xffffd
    80006560:	26a080e7          	jalr	618(ra) # 800037c6 <ilock>
  if((ip = dirlookup(dp, name, 0)) != 0){
    80006564:	4601                	li	a2,0
    80006566:	fc040593          	addi	a1,s0,-64
    8000656a:	8526                	mv	a0,s1
    8000656c:	ffffd097          	auipc	ra,0xffffd
    80006570:	73e080e7          	jalr	1854(ra) # 80003caa <dirlookup>
    80006574:	892a                	mv	s2,a0
    80006576:	cd15                	beqz	a0,800065b2 <open_file+0x8a>
    iunlockput(dp);
    80006578:	8526                	mv	a0,s1
    8000657a:	ffffd097          	auipc	ra,0xffffd
    8000657e:	4ae080e7          	jalr	1198(ra) # 80003a28 <iunlockput>
    ilock(ip);
    80006582:	854a                	mv	a0,s2
    80006584:	ffffd097          	auipc	ra,0xffffd
    80006588:	242080e7          	jalr	578(ra) # 800037c6 <ilock>
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
    800065a2:	48a080e7          	jalr	1162(ra) # 80003a28 <iunlockput>
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
    800065a6:	ffffe097          	auipc	ra,0xffffe
    800065aa:	c6a080e7          	jalr	-918(ra) # 80004210 <end_op>
      return -1;
    800065ae:	54fd                	li	s1,-1
    800065b0:	aa79                	j	8000674e <open_file+0x226>
  if((ip = ialloc(dp->dev, type)) == 0){
    800065b2:	4589                	li	a1,2
    800065b4:	4088                	lw	a0,0(s1)
    800065b6:	ffffd097          	auipc	ra,0xffffd
    800065ba:	072080e7          	jalr	114(ra) # 80003628 <ialloc>
    800065be:	892a                	mv	s2,a0
    800065c0:	c131                	beqz	a0,80006604 <open_file+0xdc>
  ilock(ip);
    800065c2:	ffffd097          	auipc	ra,0xffffd
    800065c6:	204080e7          	jalr	516(ra) # 800037c6 <ilock>
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
    800065de:	120080e7          	jalr	288(ra) # 800036fa <iupdate>
  if(dirlink(dp, name, ip->inum) < 0)
    800065e2:	00492603          	lw	a2,4(s2)
    800065e6:	fc040593          	addi	a1,s0,-64
    800065ea:	8526                	mv	a0,s1
    800065ec:	ffffe097          	auipc	ra,0xffffe
    800065f0:	8d4080e7          	jalr	-1836(ra) # 80003ec0 <dirlink>
    800065f4:	00054e63          	bltz	a0,80006610 <open_file+0xe8>
  iunlockput(dp);
    800065f8:	8526                	mv	a0,s1
    800065fa:	ffffd097          	auipc	ra,0xffffd
    800065fe:	42e080e7          	jalr	1070(ra) # 80003a28 <iunlockput>
  return ip;
    80006602:	a889                	j	80006654 <open_file+0x12c>
    iunlockput(dp);
    80006604:	8526                	mv	a0,s1
    80006606:	ffffd097          	auipc	ra,0xffffd
    8000660a:	422080e7          	jalr	1058(ra) # 80003a28 <iunlockput>
    return 0;
    8000660e:	bf61                	j	800065a6 <open_file+0x7e>
  ip->nlink = 0;
    80006610:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80006614:	854a                	mv	a0,s2
    80006616:	ffffd097          	auipc	ra,0xffffd
    8000661a:	0e4080e7          	jalr	228(ra) # 800036fa <iupdate>
  iunlockput(ip);
    8000661e:	854a                	mv	a0,s2
    80006620:	ffffd097          	auipc	ra,0xffffd
    80006624:	408080e7          	jalr	1032(ra) # 80003a28 <iunlockput>
  iunlockput(dp);
    80006628:	8526                	mv	a0,s1
    8000662a:	ffffd097          	auipc	ra,0xffffd
    8000662e:	3fe080e7          	jalr	1022(ra) # 80003a28 <iunlockput>
  return 0;
    80006632:	bf95                	j	800065a6 <open_file+0x7e>
    }
  } else {
    if((ip = namei(path)) == 0){
    80006634:	8526                	mv	a0,s1
    80006636:	ffffe097          	auipc	ra,0xffffe
    8000663a:	93c080e7          	jalr	-1732(ra) # 80003f72 <namei>
    8000663e:	892a                	mv	s2,a0
    80006640:	c925                	beqz	a0,800066b0 <open_file+0x188>
      end_op();
      return -1;
    }
    ilock(ip);
    80006642:	ffffd097          	auipc	ra,0xffffd
    80006646:	184080e7          	jalr	388(ra) # 800037c6 <ilock>
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
    8000666c:	f36080e7          	jalr	-202(ra) # 8000459e <filealloc>
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
    80006696:	fc8080e7          	jalr	-56(ra) # 8000465a <fileclose>
    iunlockput(ip);
    8000669a:	854a                	mv	a0,s2
    8000669c:	ffffd097          	auipc	ra,0xffffd
    800066a0:	38c080e7          	jalr	908(ra) # 80003a28 <iunlockput>
    end_op();
    800066a4:	ffffe097          	auipc	ra,0xffffe
    800066a8:	b6c080e7          	jalr	-1172(ra) # 80004210 <end_op>
    return -1;
    800066ac:	54fd                	li	s1,-1
    800066ae:	a045                	j	8000674e <open_file+0x226>
      end_op();
    800066b0:	ffffe097          	auipc	ra,0xffffe
    800066b4:	b60080e7          	jalr	-1184(ra) # 80004210 <end_op>
      return -1;
    800066b8:	54fd                	li	s1,-1
    800066ba:	a851                	j	8000674e <open_file+0x226>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800066bc:	fa0a06e3          	beqz	s4,80006668 <open_file+0x140>
      iunlockput(ip);
    800066c0:	854a                	mv	a0,s2
    800066c2:	ffffd097          	auipc	ra,0xffffd
    800066c6:	366080e7          	jalr	870(ra) # 80003a28 <iunlockput>
      end_op();
    800066ca:	ffffe097          	auipc	ra,0xffffe
    800066ce:	b46080e7          	jalr	-1210(ra) # 80004210 <end_op>
      return -1;
    800066d2:	54fd                	li	s1,-1
    800066d4:	a8ad                	j	8000674e <open_file+0x226>
    iunlockput(ip);
    800066d6:	854a                	mv	a0,s2
    800066d8:	ffffd097          	auipc	ra,0xffffd
    800066dc:	350080e7          	jalr	848(ra) # 80003a28 <iunlockput>
    end_op();
    800066e0:	ffffe097          	auipc	ra,0xffffe
    800066e4:	b30080e7          	jalr	-1232(ra) # 80004210 <end_op>
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
    80006742:	14a080e7          	jalr	330(ra) # 80003888 <iunlock>
  end_op();
    80006746:	ffffe097          	auipc	ra,0xffffe
    8000674a:	aca080e7          	jalr	-1334(ra) # 80004210 <end_op>

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
    80006774:	164080e7          	jalr	356(ra) # 800038d4 <itrunc>
    80006778:	b7d1                	j	8000673c <open_file+0x214>

000000008000677a <read_line>:
    f->off += r;

  return r;
}

int read_line(int fd, char * buffer){
    8000677a:	7139                	addi	sp,sp,-64
    8000677c:	fc06                	sd	ra,56(sp)
    8000677e:	f822                	sd	s0,48(sp)
    80006780:	f426                	sd	s1,40(sp)
    80006782:	f04a                	sd	s2,32(sp)
    80006784:	ec4e                	sd	s3,24(sp)
    80006786:	e852                	sd	s4,16(sp)
    80006788:	0080                	addi	s0,sp,64
  // int fd;
  struct file *f;
  // printf("fd: %d\n ",fd);


  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000678a:	47bd                	li	a5,15
    8000678c:	06a7e663          	bltu	a5,a0,800067f8 <read_line+0x7e>
    80006790:	892e                	mv	s2,a1
    80006792:	84aa                	mv	s1,a0
    80006794:	ffffb097          	auipc	ra,0xffffb
    80006798:	218080e7          	jalr	536(ra) # 800019ac <myproc>
    8000679c:	04e9                	addi	s1,s1,26
    8000679e:	048e                	slli	s1,s1,0x3
    800067a0:	9526                	add	a0,a0,s1
    800067a2:	6104                	ld	s1,0(a0)
    return -1;



  char readByte;
  int byteCount = 0;
    800067a4:	4981                	li	s3,0
    }
    // printf("%d ",readByte);
    *buffer++ = readByte;
    byteCount++;

    if (readByte == '\n')
    800067a6:	4a29                	li	s4,10
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800067a8:	e095                	bnez	s1,800067cc <read_line+0x52>
    return -1;
    800067aa:	59fd                	li	s3,-1
    800067ac:	a82d                	j	800067e6 <read_line+0x6c>
      if (byteCount == 0)
    800067ae:	02099c63          	bnez	s3,800067e6 <read_line+0x6c>
  int r = readi(f->ip, 0, (uint64)byte, f->off, 1);
    800067b2:	89aa                	mv	s3,a0
    800067b4:	a80d                	j	800067e6 <read_line+0x6c>
    f->off += r;
    800067b6:	509c                	lw	a5,32(s1)
    800067b8:	9fa9                	addw	a5,a5,a0
    800067ba:	d09c                	sw	a5,32(s1)
    *buffer++ = readByte;
    800067bc:	fcf44783          	lbu	a5,-49(s0)
    800067c0:	00f90023          	sb	a5,0(s2)
    byteCount++;
    800067c4:	2985                	addiw	s3,s3,1
    if (readByte == '\n')
    800067c6:	0905                	addi	s2,s2,1
    800067c8:	01478f63          	beq	a5,s4,800067e6 <read_line+0x6c>
  int r = readi(f->ip, 0, (uint64)byte, f->off, 1);
    800067cc:	4705                	li	a4,1
    800067ce:	5094                	lw	a3,32(s1)
    800067d0:	fcf40613          	addi	a2,s0,-49
    800067d4:	4581                	li	a1,0
    800067d6:	6c88                	ld	a0,24(s1)
    800067d8:	ffffd097          	auipc	ra,0xffffd
    800067dc:	2a2080e7          	jalr	674(ra) # 80003a7a <readi>
  if (r>0)
    800067e0:	fca04be3          	bgtz	a0,800067b6 <read_line+0x3c>
  while((readStatus = read_byte(f,&readByte))){
    800067e4:	f569                	bnez	a0,800067ae <read_line+0x34>
      return byteCount;
  }

  return byteCount;

}
    800067e6:	854e                	mv	a0,s3
    800067e8:	70e2                	ld	ra,56(sp)
    800067ea:	7442                	ld	s0,48(sp)
    800067ec:	74a2                	ld	s1,40(sp)
    800067ee:	7902                	ld	s2,32(sp)
    800067f0:	69e2                	ld	s3,24(sp)
    800067f2:	6a42                	ld	s4,16(sp)
    800067f4:	6121                	addi	sp,sp,64
    800067f6:	8082                	ret
    return -1;
    800067f8:	59fd                	li	s3,-1
    800067fa:	b7f5                	j	800067e6 <read_line+0x6c>

00000000800067fc <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
    800067fc:	1141                	addi	sp,sp,-16
    800067fe:	e422                	sd	s0,8(sp)
    80006800:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
    80006802:	00054783          	lbu	a5,0(a0)
    80006806:	cf99                	beqz	a5,80006824 <get_strlen+0x28>
    80006808:	00150713          	addi	a4,a0,1
    8000680c:	87ba                	mv	a5,a4
    8000680e:	4685                	li	a3,1
    80006810:	9e99                	subw	a3,a3,a4
    80006812:	00f6853b          	addw	a0,a3,a5
    80006816:	0785                	addi	a5,a5,1
    80006818:	fff7c703          	lbu	a4,-1(a5)
    8000681c:	fb7d                	bnez	a4,80006812 <get_strlen+0x16>
	return len;
}
    8000681e:	6422                	ld	s0,8(sp)
    80006820:	0141                	addi	sp,sp,16
    80006822:	8082                	ret
	int len = 0;
    80006824:	4501                	li	a0,0
    80006826:	bfe5                	j	8000681e <get_strlen+0x22>

0000000080006828 <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
    80006828:	1141                	addi	sp,sp,-16
    8000682a:	e422                	sd	s0,8(sp)
    8000682c:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
    8000682e:	00054783          	lbu	a5,0(a0)
    80006832:	cb91                	beqz	a5,80006846 <compare_str+0x1e>
    80006834:	0005c703          	lbu	a4,0(a1)
    80006838:	c719                	beqz	a4,80006846 <compare_str+0x1e>
		if (*s1++ != *s2++)
    8000683a:	0505                	addi	a0,a0,1
    8000683c:	0585                	addi	a1,a1,1
    8000683e:	fee788e3          	beq	a5,a4,8000682e <compare_str+0x6>
			return 1;
    80006842:	4505                	li	a0,1
    80006844:	a031                	j	80006850 <compare_str+0x28>
	}
	if (*s1 == *s2)
    80006846:	0005c503          	lbu	a0,0(a1)
    8000684a:	8d1d                	sub	a0,a0,a5
			return 1;
    8000684c:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    80006850:	6422                	ld	s0,8(sp)
    80006852:	0141                	addi	sp,sp,16
    80006854:	8082                	ret

0000000080006856 <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
    80006856:	1141                	addi	sp,sp,-16
    80006858:	e422                	sd	s0,8(sp)
    8000685a:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
    8000685c:	4665                	li	a2,25
	while(*s1 && *s2){
    8000685e:	a019                	j	80006864 <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
    80006860:	04e79763          	bne	a5,a4,800068ae <compare_str_ic+0x58>
	while(*s1 && *s2){
    80006864:	00054783          	lbu	a5,0(a0)
    80006868:	cb9d                	beqz	a5,8000689e <compare_str_ic+0x48>
    8000686a:	0005c703          	lbu	a4,0(a1)
    8000686e:	cb05                	beqz	a4,8000689e <compare_str_ic+0x48>
		char b1 = *s1++;
    80006870:	0505                	addi	a0,a0,1
		char b2 = *s2++;
    80006872:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
    80006874:	fbf7869b          	addiw	a3,a5,-65
    80006878:	0ff6f693          	zext.b	a3,a3
    8000687c:	00d66663          	bltu	a2,a3,80006888 <compare_str_ic+0x32>
			b1 += 32;
    80006880:	0207879b          	addiw	a5,a5,32
    80006884:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
    80006888:	fbf7069b          	addiw	a3,a4,-65
    8000688c:	0ff6f693          	zext.b	a3,a3
    80006890:	fcd668e3          	bltu	a2,a3,80006860 <compare_str_ic+0xa>
			b2 += 32;
    80006894:	0207071b          	addiw	a4,a4,32
    80006898:	0ff77713          	zext.b	a4,a4
    8000689c:	b7d1                	j	80006860 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
    8000689e:	0005c503          	lbu	a0,0(a1)
    800068a2:	8d1d                	sub	a0,a0,a5
			return 1;
    800068a4:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    800068a8:	6422                	ld	s0,8(sp)
    800068aa:	0141                	addi	sp,sp,16
    800068ac:	8082                	ret
			return 1;
    800068ae:	4505                	li	a0,1
    800068b0:	bfe5                	j	800068a8 <compare_str_ic+0x52>
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
