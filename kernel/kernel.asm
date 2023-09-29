
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	b7013103          	ld	sp,-1168(sp) # 80009b70 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000050:	0000a717          	auipc	a4,0xa
    80000054:	b8070713          	addi	a4,a4,-1152 # 80009bd0 <timer_scratch>
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
    80000066:	fce78793          	addi	a5,a5,-50 # 80006030 <timervec>
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
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb1bf>
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
    8000012e:	3ac080e7          	jalr	940(ra) # 800024d6 <either_copyin>
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
    8000018a:	00012517          	auipc	a0,0x12
    8000018e:	b8650513          	addi	a0,a0,-1146 # 80011d10 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a44080e7          	jalr	-1468(ra) # 80000bd6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00012497          	auipc	s1,0x12
    8000019e:	b7648493          	addi	s1,s1,-1162 # 80011d10 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00012917          	auipc	s2,0x12
    800001a6:	c0690913          	addi	s2,s2,-1018 # 80011da8 <cons+0x98>
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
    800001cc:	158080e7          	jalr	344(ra) # 80002320 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	e8a080e7          	jalr	-374(ra) # 80002060 <sleep>
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
    80000216:	26e080e7          	jalr	622(ra) # 80002480 <either_copyout>
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
    80000226:	00012517          	auipc	a0,0x12
    8000022a:	aea50513          	addi	a0,a0,-1302 # 80011d10 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	a5c080e7          	jalr	-1444(ra) # 80000c8a <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00012517          	auipc	a0,0x12
    80000240:	ad450513          	addi	a0,a0,-1324 # 80011d10 <cons>
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
    80000272:	00012717          	auipc	a4,0x12
    80000276:	b2f72b23          	sw	a5,-1226(a4) # 80011da8 <cons+0x98>
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
    800002cc:	00012517          	auipc	a0,0x12
    800002d0:	a4450513          	addi	a0,a0,-1468 # 80011d10 <cons>
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
    800002f6:	23a080e7          	jalr	570(ra) # 8000252c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00012517          	auipc	a0,0x12
    800002fe:	a1650513          	addi	a0,a0,-1514 # 80011d10 <cons>
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
    8000031e:	00012717          	auipc	a4,0x12
    80000322:	9f270713          	addi	a4,a4,-1550 # 80011d10 <cons>
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
    80000348:	00012797          	auipc	a5,0x12
    8000034c:	9c878793          	addi	a5,a5,-1592 # 80011d10 <cons>
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
    80000376:	00012797          	auipc	a5,0x12
    8000037a:	a327a783          	lw	a5,-1486(a5) # 80011da8 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00012717          	auipc	a4,0x12
    8000038e:	98670713          	addi	a4,a4,-1658 # 80011d10 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00012497          	auipc	s1,0x12
    8000039e:	97648493          	addi	s1,s1,-1674 # 80011d10 <cons>
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
    800003d6:	00012717          	auipc	a4,0x12
    800003da:	93a70713          	addi	a4,a4,-1734 # 80011d10 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00012717          	auipc	a4,0x12
    800003f0:	9cf72223          	sw	a5,-1596(a4) # 80011db0 <cons+0xa0>
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
    80000412:	00012797          	auipc	a5,0x12
    80000416:	8fe78793          	addi	a5,a5,-1794 # 80011d10 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00012797          	auipc	a5,0x12
    8000043a:	96c7ab23          	sw	a2,-1674(a5) # 80011dac <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00012517          	auipc	a0,0x12
    80000442:	96a50513          	addi	a0,a0,-1686 # 80011da8 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	c7e080e7          	jalr	-898(ra) # 800020c4 <wakeup>
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
    80000458:	00009597          	auipc	a1,0x9
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80009010 <etext+0x10>
    80000460:	00012517          	auipc	a0,0x12
    80000464:	8b050513          	addi	a0,a0,-1872 # 80011d10 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	6de080e7          	jalr	1758(ra) # 80000b46 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32c080e7          	jalr	812(ra) # 8000079c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00022797          	auipc	a5,0x22
    8000047c:	03078793          	addi	a5,a5,48 # 800224a8 <devsw>
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
    800004ba:	00009617          	auipc	a2,0x9
    800004be:	b8660613          	addi	a2,a2,-1146 # 80009040 <digits>
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
    8000054c:	00012797          	auipc	a5,0x12
    80000550:	8807a223          	sw	zero,-1916(a5) # 80011dd0 <pr+0x18>
  printf("panic: ");
    80000554:	00009517          	auipc	a0,0x9
    80000558:	ac450513          	addi	a0,a0,-1340 # 80009018 <etext+0x18>
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	02e080e7          	jalr	46(ra) # 8000058a <printf>
  printf(s);
    80000564:	8526                	mv	a0,s1
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	024080e7          	jalr	36(ra) # 8000058a <printf>
  printf("\n");
    8000056e:	00009517          	auipc	a0,0x9
    80000572:	5aa50513          	addi	a0,a0,1450 # 80009b18 <syscalls+0x6c8>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	014080e7          	jalr	20(ra) # 8000058a <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057e:	4785                	li	a5,1
    80000580:	00009717          	auipc	a4,0x9
    80000584:	60f72823          	sw	a5,1552(a4) # 80009b90 <panicked>
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
    800005bc:	00012d97          	auipc	s11,0x12
    800005c0:	814dad83          	lw	s11,-2028(s11) # 80011dd0 <pr+0x18>
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
    800005e8:	00009b17          	auipc	s6,0x9
    800005ec:	a58b0b13          	addi	s6,s6,-1448 # 80009040 <digits>
    switch(c){
    800005f0:	07300c93          	li	s9,115
    800005f4:	06400c13          	li	s8,100
    800005f8:	a82d                	j	80000632 <printf+0xa8>
    acquire(&pr.lock);
    800005fa:	00011517          	auipc	a0,0x11
    800005fe:	7be50513          	addi	a0,a0,1982 # 80011db8 <pr>
    80000602:	00000097          	auipc	ra,0x0
    80000606:	5d4080e7          	jalr	1492(ra) # 80000bd6 <acquire>
    8000060a:	bf7d                	j	800005c8 <printf+0x3e>
    panic("null fmt");
    8000060c:	00009517          	auipc	a0,0x9
    80000610:	a1c50513          	addi	a0,a0,-1508 # 80009028 <etext+0x28>
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
    80000706:	00009497          	auipc	s1,0x9
    8000070a:	91a48493          	addi	s1,s1,-1766 # 80009020 <etext+0x20>
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
    80000758:	00011517          	auipc	a0,0x11
    8000075c:	66050513          	addi	a0,a0,1632 # 80011db8 <pr>
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
    80000774:	00011497          	auipc	s1,0x11
    80000778:	64448493          	addi	s1,s1,1604 # 80011db8 <pr>
    8000077c:	00009597          	auipc	a1,0x9
    80000780:	8bc58593          	addi	a1,a1,-1860 # 80009038 <etext+0x38>
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
    800007cc:	00009597          	auipc	a1,0x9
    800007d0:	88c58593          	addi	a1,a1,-1908 # 80009058 <digits+0x18>
    800007d4:	00011517          	auipc	a0,0x11
    800007d8:	60450513          	addi	a0,a0,1540 # 80011dd8 <uart_tx_lock>
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
    80000800:	00009797          	auipc	a5,0x9
    80000804:	3907a783          	lw	a5,912(a5) # 80009b90 <panicked>
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
    80000838:	00009797          	auipc	a5,0x9
    8000083c:	3607b783          	ld	a5,864(a5) # 80009b98 <uart_tx_r>
    80000840:	00009717          	auipc	a4,0x9
    80000844:	36073703          	ld	a4,864(a4) # 80009ba0 <uart_tx_w>
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
    80000862:	00011a17          	auipc	s4,0x11
    80000866:	576a0a13          	addi	s4,s4,1398 # 80011dd8 <uart_tx_lock>
    uart_tx_r += 1;
    8000086a:	00009497          	auipc	s1,0x9
    8000086e:	32e48493          	addi	s1,s1,814 # 80009b98 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000872:	00009997          	auipc	s3,0x9
    80000876:	32e98993          	addi	s3,s3,814 # 80009ba0 <uart_tx_w>
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
    80000898:	830080e7          	jalr	-2000(ra) # 800020c4 <wakeup>
    
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
    800008d0:	00011517          	auipc	a0,0x11
    800008d4:	50850513          	addi	a0,a0,1288 # 80011dd8 <uart_tx_lock>
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	2fe080e7          	jalr	766(ra) # 80000bd6 <acquire>
  if(panicked){
    800008e0:	00009797          	auipc	a5,0x9
    800008e4:	2b07a783          	lw	a5,688(a5) # 80009b90 <panicked>
    800008e8:	e7c9                	bnez	a5,80000972 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008ea:	00009717          	auipc	a4,0x9
    800008ee:	2b673703          	ld	a4,694(a4) # 80009ba0 <uart_tx_w>
    800008f2:	00009797          	auipc	a5,0x9
    800008f6:	2a67b783          	ld	a5,678(a5) # 80009b98 <uart_tx_r>
    800008fa:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fe:	00011997          	auipc	s3,0x11
    80000902:	4da98993          	addi	s3,s3,1242 # 80011dd8 <uart_tx_lock>
    80000906:	00009497          	auipc	s1,0x9
    8000090a:	29248493          	addi	s1,s1,658 # 80009b98 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090e:	00009917          	auipc	s2,0x9
    80000912:	29290913          	addi	s2,s2,658 # 80009ba0 <uart_tx_w>
    80000916:	00e79f63          	bne	a5,a4,80000934 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000091a:	85ce                	mv	a1,s3
    8000091c:	8526                	mv	a0,s1
    8000091e:	00001097          	auipc	ra,0x1
    80000922:	742080e7          	jalr	1858(ra) # 80002060 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000926:	00093703          	ld	a4,0(s2)
    8000092a:	609c                	ld	a5,0(s1)
    8000092c:	02078793          	addi	a5,a5,32
    80000930:	fee785e3          	beq	a5,a4,8000091a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000934:	00011497          	auipc	s1,0x11
    80000938:	4a448493          	addi	s1,s1,1188 # 80011dd8 <uart_tx_lock>
    8000093c:	01f77793          	andi	a5,a4,31
    80000940:	97a6                	add	a5,a5,s1
    80000942:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000946:	0705                	addi	a4,a4,1
    80000948:	00009797          	auipc	a5,0x9
    8000094c:	24e7bc23          	sd	a4,600(a5) # 80009ba0 <uart_tx_w>
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
    800009ba:	00011497          	auipc	s1,0x11
    800009be:	41e48493          	addi	s1,s1,1054 # 80011dd8 <uart_tx_lock>
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
    800009fc:	00023797          	auipc	a5,0x23
    80000a00:	c4478793          	addi	a5,a5,-956 # 80023640 <end>
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
    80000a1c:	00011917          	auipc	s2,0x11
    80000a20:	3f490913          	addi	s2,s2,1012 # 80011e10 <kmem>
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
    80000a4e:	00008517          	auipc	a0,0x8
    80000a52:	61250513          	addi	a0,a0,1554 # 80009060 <digits+0x20>
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
    80000ab2:	00008597          	auipc	a1,0x8
    80000ab6:	5b658593          	addi	a1,a1,1462 # 80009068 <digits+0x28>
    80000aba:	00011517          	auipc	a0,0x11
    80000abe:	35650513          	addi	a0,a0,854 # 80011e10 <kmem>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	084080e7          	jalr	132(ra) # 80000b46 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000aca:	45c5                	li	a1,17
    80000acc:	05ee                	slli	a1,a1,0x1b
    80000ace:	00023517          	auipc	a0,0x23
    80000ad2:	b7250513          	addi	a0,a0,-1166 # 80023640 <end>
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
    80000af0:	00011497          	auipc	s1,0x11
    80000af4:	32048493          	addi	s1,s1,800 # 80011e10 <kmem>
    80000af8:	8526                	mv	a0,s1
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	0dc080e7          	jalr	220(ra) # 80000bd6 <acquire>
  r = kmem.freelist;
    80000b02:	6c84                	ld	s1,24(s1)
  if(r)
    80000b04:	c885                	beqz	s1,80000b34 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b06:	609c                	ld	a5,0(s1)
    80000b08:	00011517          	auipc	a0,0x11
    80000b0c:	30850513          	addi	a0,a0,776 # 80011e10 <kmem>
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
    80000b34:	00011517          	auipc	a0,0x11
    80000b38:	2dc50513          	addi	a0,a0,732 # 80011e10 <kmem>
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
    80000c1a:	00008517          	auipc	a0,0x8
    80000c1e:	45650513          	addi	a0,a0,1110 # 80009070 <digits+0x30>
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
    80000c6a:	00008517          	auipc	a0,0x8
    80000c6e:	40e50513          	addi	a0,a0,1038 # 80009078 <digits+0x38>
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	8ce080e7          	jalr	-1842(ra) # 80000540 <panic>
    panic("pop_off");
    80000c7a:	00008517          	auipc	a0,0x8
    80000c7e:	41650513          	addi	a0,a0,1046 # 80009090 <digits+0x50>
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
    80000cc2:	00008517          	auipc	a0,0x8
    80000cc6:	3d650513          	addi	a0,a0,982 # 80009098 <digits+0x58>
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
    80000d46:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb9c1>
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
    80000e88:	00009717          	auipc	a4,0x9
    80000e8c:	d2070713          	addi	a4,a4,-736 # 80009ba8 <started>
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
    80000ea6:	00008517          	auipc	a0,0x8
    80000eaa:	21250513          	addi	a0,a0,530 # 800090b8 <digits+0x78>
    80000eae:	fffff097          	auipc	ra,0xfffff
    80000eb2:	6dc080e7          	jalr	1756(ra) # 8000058a <printf>
    kvminithart();    // turn on paging
    80000eb6:	00000097          	auipc	ra,0x0
    80000eba:	0d8080e7          	jalr	216(ra) # 80000f8e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ebe:	00001097          	auipc	ra,0x1
    80000ec2:	7b0080e7          	jalr	1968(ra) # 8000266e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	1aa080e7          	jalr	426(ra) # 80006070 <plicinithart>
  }

  scheduler();        
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	fe0080e7          	jalr	-32(ra) # 80001eae <scheduler>
    consoleinit();
    80000ed6:	fffff097          	auipc	ra,0xfffff
    80000eda:	57a080e7          	jalr	1402(ra) # 80000450 <consoleinit>
    printfinit();
    80000ede:	00000097          	auipc	ra,0x0
    80000ee2:	88c080e7          	jalr	-1908(ra) # 8000076a <printfinit>
    printf("\n");
    80000ee6:	00009517          	auipc	a0,0x9
    80000eea:	c3250513          	addi	a0,a0,-974 # 80009b18 <syscalls+0x6c8>
    80000eee:	fffff097          	auipc	ra,0xfffff
    80000ef2:	69c080e7          	jalr	1692(ra) # 8000058a <printf>
    printf("xv6 kernel is booting\n");
    80000ef6:	00008517          	auipc	a0,0x8
    80000efa:	1aa50513          	addi	a0,a0,426 # 800090a0 <digits+0x60>
    80000efe:	fffff097          	auipc	ra,0xfffff
    80000f02:	68c080e7          	jalr	1676(ra) # 8000058a <printf>
    printf("\n");
    80000f06:	00009517          	auipc	a0,0x9
    80000f0a:	c1250513          	addi	a0,a0,-1006 # 80009b18 <syscalls+0x6c8>
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
    80000f3a:	710080e7          	jalr	1808(ra) # 80002646 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f3e:	00001097          	auipc	ra,0x1
    80000f42:	730080e7          	jalr	1840(ra) # 8000266e <trapinithart>
    plicinit();      // set up interrupt controller
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	114080e7          	jalr	276(ra) # 8000605a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	122080e7          	jalr	290(ra) # 80006070 <plicinithart>
    binit();         // buffer cache
    80000f56:	00002097          	auipc	ra,0x2
    80000f5a:	1c8080e7          	jalr	456(ra) # 8000311e <binit>
    iinit();         // inode table
    80000f5e:	00003097          	auipc	ra,0x3
    80000f62:	868080e7          	jalr	-1944(ra) # 800037c6 <iinit>
    fileinit();      // file table
    80000f66:	00004097          	auipc	ra,0x4
    80000f6a:	80e080e7          	jalr	-2034(ra) # 80004774 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	20a080e7          	jalr	522(ra) # 80006178 <virtio_disk_init>
    userinit();      // first user process
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	d1a080e7          	jalr	-742(ra) # 80001c90 <userinit>
    __sync_synchronize();
    80000f7e:	0ff0000f          	fence
    started = 1;
    80000f82:	4785                	li	a5,1
    80000f84:	00009717          	auipc	a4,0x9
    80000f88:	c2f72223          	sw	a5,-988(a4) # 80009ba8 <started>
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
    80000f98:	00009797          	auipc	a5,0x9
    80000f9c:	c187b783          	ld	a5,-1000(a5) # 80009bb0 <kernel_pagetable>
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
    80000fdc:	00008517          	auipc	a0,0x8
    80000fe0:	0f450513          	addi	a0,a0,244 # 800090d0 <digits+0x90>
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
    80001016:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb9b7>
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
    80001102:	00008517          	auipc	a0,0x8
    80001106:	fd650513          	addi	a0,a0,-42 # 800090d8 <digits+0x98>
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	436080e7          	jalr	1078(ra) # 80000540 <panic>
      panic("mappages: remap");
    80001112:	00008517          	auipc	a0,0x8
    80001116:	fd650513          	addi	a0,a0,-42 # 800090e8 <digits+0xa8>
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
    8000115e:	00008517          	auipc	a0,0x8
    80001162:	f9a50513          	addi	a0,a0,-102 # 800090f8 <digits+0xb8>
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
    800011d4:	00008917          	auipc	s2,0x8
    800011d8:	e2c90913          	addi	s2,s2,-468 # 80009000 <etext>
    800011dc:	4729                	li	a4,10
    800011de:	80008697          	auipc	a3,0x80008
    800011e2:	e2268693          	addi	a3,a3,-478 # 9000 <_entry-0x7fff7000>
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
    80001212:	00007617          	auipc	a2,0x7
    80001216:	dee60613          	addi	a2,a2,-530 # 80008000 <_trampoline>
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
    80001254:	00009797          	auipc	a5,0x9
    80001258:	94a7be23          	sd	a0,-1700(a5) # 80009bb0 <kernel_pagetable>
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
    800012aa:	00008517          	auipc	a0,0x8
    800012ae:	e5650513          	addi	a0,a0,-426 # 80009100 <digits+0xc0>
    800012b2:	fffff097          	auipc	ra,0xfffff
    800012b6:	28e080e7          	jalr	654(ra) # 80000540 <panic>
      panic("uvmunmap: walk");
    800012ba:	00008517          	auipc	a0,0x8
    800012be:	e5e50513          	addi	a0,a0,-418 # 80009118 <digits+0xd8>
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	27e080e7          	jalr	638(ra) # 80000540 <panic>
      panic("uvmunmap: not mapped");
    800012ca:	00008517          	auipc	a0,0x8
    800012ce:	e5e50513          	addi	a0,a0,-418 # 80009128 <digits+0xe8>
    800012d2:	fffff097          	auipc	ra,0xfffff
    800012d6:	26e080e7          	jalr	622(ra) # 80000540 <panic>
      panic("uvmunmap: not a leaf");
    800012da:	00008517          	auipc	a0,0x8
    800012de:	e6650513          	addi	a0,a0,-410 # 80009140 <digits+0x100>
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
    800013b8:	00008517          	auipc	a0,0x8
    800013bc:	da050513          	addi	a0,a0,-608 # 80009158 <digits+0x118>
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
    80001504:	00008517          	auipc	a0,0x8
    80001508:	c7450513          	addi	a0,a0,-908 # 80009178 <digits+0x138>
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
    800015e2:	00008517          	auipc	a0,0x8
    800015e6:	ba650513          	addi	a0,a0,-1114 # 80009188 <digits+0x148>
    800015ea:	fffff097          	auipc	ra,0xfffff
    800015ee:	f56080e7          	jalr	-170(ra) # 80000540 <panic>
      panic("uvmcopy: page not present");
    800015f2:	00008517          	auipc	a0,0x8
    800015f6:	bb650513          	addi	a0,a0,-1098 # 800091a8 <digits+0x168>
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
    8000165c:	00008517          	auipc	a0,0x8
    80001660:	b6c50513          	addi	a0,a0,-1172 # 800091c8 <digits+0x188>
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
    8000180c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdb9c0>
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
    8000184c:	00011497          	auipc	s1,0x11
    80001850:	a1448493          	addi	s1,s1,-1516 # 80012260 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001854:	8b26                	mv	s6,s1
    80001856:	00007a97          	auipc	s5,0x7
    8000185a:	7aaa8a93          	addi	s5,s5,1962 # 80009000 <etext>
    8000185e:	04000937          	lui	s2,0x4000
    80001862:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001864:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001866:	00017a17          	auipc	s4,0x17
    8000186a:	9faa0a13          	addi	s4,s4,-1542 # 80018260 <tickslock>
    char *pa = kalloc();
    8000186e:	fffff097          	auipc	ra,0xfffff
    80001872:	278080e7          	jalr	632(ra) # 80000ae6 <kalloc>
    80001876:	862a                	mv	a2,a0
    if(pa == 0)
    80001878:	c131                	beqz	a0,800018bc <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    8000187a:	416485b3          	sub	a1,s1,s6
    8000187e:	859d                	srai	a1,a1,0x7
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
    800018a0:	18048493          	addi	s1,s1,384
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
    800018bc:	00008517          	auipc	a0,0x8
    800018c0:	91c50513          	addi	a0,a0,-1764 # 800091d8 <digits+0x198>
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
    800018e0:	00008597          	auipc	a1,0x8
    800018e4:	90058593          	addi	a1,a1,-1792 # 800091e0 <digits+0x1a0>
    800018e8:	00010517          	auipc	a0,0x10
    800018ec:	54850513          	addi	a0,a0,1352 # 80011e30 <pid_lock>
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	256080e7          	jalr	598(ra) # 80000b46 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018f8:	00008597          	auipc	a1,0x8
    800018fc:	8f058593          	addi	a1,a1,-1808 # 800091e8 <digits+0x1a8>
    80001900:	00010517          	auipc	a0,0x10
    80001904:	54850513          	addi	a0,a0,1352 # 80011e48 <wait_lock>
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	23e080e7          	jalr	574(ra) # 80000b46 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001910:	00011497          	auipc	s1,0x11
    80001914:	95048493          	addi	s1,s1,-1712 # 80012260 <proc>
      initlock(&p->lock, "proc");
    80001918:	00008b17          	auipc	s6,0x8
    8000191c:	8e0b0b13          	addi	s6,s6,-1824 # 800091f8 <digits+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001920:	8aa6                	mv	s5,s1
    80001922:	00007a17          	auipc	s4,0x7
    80001926:	6dea0a13          	addi	s4,s4,1758 # 80009000 <etext>
    8000192a:	04000937          	lui	s2,0x4000
    8000192e:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001930:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001932:	00017997          	auipc	s3,0x17
    80001936:	92e98993          	addi	s3,s3,-1746 # 80018260 <tickslock>
      initlock(&p->lock, "proc");
    8000193a:	85da                	mv	a1,s6
    8000193c:	8526                	mv	a0,s1
    8000193e:	fffff097          	auipc	ra,0xfffff
    80001942:	208080e7          	jalr	520(ra) # 80000b46 <initlock>
      p->state = UNUSED;
    80001946:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000194a:	415487b3          	sub	a5,s1,s5
    8000194e:	879d                	srai	a5,a5,0x7
    80001950:	000a3703          	ld	a4,0(s4)
    80001954:	02e787b3          	mul	a5,a5,a4
    80001958:	2785                	addiw	a5,a5,1
    8000195a:	00d7979b          	slliw	a5,a5,0xd
    8000195e:	40f907b3          	sub	a5,s2,a5
    80001962:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001964:	18048493          	addi	s1,s1,384
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
    8000199c:	00010517          	auipc	a0,0x10
    800019a0:	4c450513          	addi	a0,a0,1220 # 80011e60 <cpus>
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
    800019c4:	00010717          	auipc	a4,0x10
    800019c8:	46c70713          	addi	a4,a4,1132 # 80011e30 <pid_lock>
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
    800019fc:	00008797          	auipc	a5,0x8
    80001a00:	1247a783          	lw	a5,292(a5) # 80009b20 <first.1>
    80001a04:	eb89                	bnez	a5,80001a16 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a06:	00001097          	auipc	ra,0x1
    80001a0a:	c80080e7          	jalr	-896(ra) # 80002686 <usertrapret>
}
    80001a0e:	60a2                	ld	ra,8(sp)
    80001a10:	6402                	ld	s0,0(sp)
    80001a12:	0141                	addi	sp,sp,16
    80001a14:	8082                	ret
    first = 0;
    80001a16:	00008797          	auipc	a5,0x8
    80001a1a:	1007a523          	sw	zero,266(a5) # 80009b20 <first.1>
    fsinit(ROOTDEV);
    80001a1e:	4505                	li	a0,1
    80001a20:	00002097          	auipc	ra,0x2
    80001a24:	d26080e7          	jalr	-730(ra) # 80003746 <fsinit>
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
    80001a36:	00010917          	auipc	s2,0x10
    80001a3a:	3fa90913          	addi	s2,s2,1018 # 80011e30 <pid_lock>
    80001a3e:	854a                	mv	a0,s2
    80001a40:	fffff097          	auipc	ra,0xfffff
    80001a44:	196080e7          	jalr	406(ra) # 80000bd6 <acquire>
  pid = nextpid;
    80001a48:	00008797          	auipc	a5,0x8
    80001a4c:	0dc78793          	addi	a5,a5,220 # 80009b24 <nextpid>
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
    80001a8c:	00006697          	auipc	a3,0x6
    80001a90:	57468693          	addi	a3,a3,1396 # 80008000 <_trampoline>
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
    80001bc2:	00010497          	auipc	s1,0x10
    80001bc6:	69e48493          	addi	s1,s1,1694 # 80012260 <proc>
    80001bca:	00016917          	auipc	s2,0x16
    80001bce:	69690913          	addi	s2,s2,1686 # 80018260 <tickslock>
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
    80001bea:	18048493          	addi	s1,s1,384
    80001bee:	ff2492e3          	bne	s1,s2,80001bd2 <allocproc+0x1c>
  return 0;
    80001bf2:	4481                	li	s1,0
    80001bf4:	a8b9                	j	80001c52 <allocproc+0x9c>
  p->execTime.creationTime = sys_uptime();
    80001bf6:	00001097          	auipc	ra,0x1
    80001bfa:	498080e7          	jalr	1176(ra) # 8000308e <sys_uptime>
    80001bfe:	16a4b423          	sd	a0,360(s1)
  p->pid = allocpid();
    80001c02:	00000097          	auipc	ra,0x0
    80001c06:	e28080e7          	jalr	-472(ra) # 80001a2a <allocpid>
    80001c0a:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c0c:	4785                	li	a5,1
    80001c0e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c10:	fffff097          	auipc	ra,0xfffff
    80001c14:	ed6080e7          	jalr	-298(ra) # 80000ae6 <kalloc>
    80001c18:	892a                	mv	s2,a0
    80001c1a:	eca8                	sd	a0,88(s1)
    80001c1c:	c131                	beqz	a0,80001c60 <allocproc+0xaa>
  p->pagetable = proc_pagetable(p);
    80001c1e:	8526                	mv	a0,s1
    80001c20:	00000097          	auipc	ra,0x0
    80001c24:	e50080e7          	jalr	-432(ra) # 80001a70 <proc_pagetable>
    80001c28:	892a                	mv	s2,a0
    80001c2a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c2c:	c531                	beqz	a0,80001c78 <allocproc+0xc2>
  memset(&p->context, 0, sizeof(p->context));
    80001c2e:	07000613          	li	a2,112
    80001c32:	4581                	li	a1,0
    80001c34:	06048513          	addi	a0,s1,96
    80001c38:	fffff097          	auipc	ra,0xfffff
    80001c3c:	09a080e7          	jalr	154(ra) # 80000cd2 <memset>
  p->context.ra = (uint64)forkret;
    80001c40:	00000797          	auipc	a5,0x0
    80001c44:	da478793          	addi	a5,a5,-604 # 800019e4 <forkret>
    80001c48:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c4a:	60bc                	ld	a5,64(s1)
    80001c4c:	6705                	lui	a4,0x1
    80001c4e:	97ba                	add	a5,a5,a4
    80001c50:	f4bc                	sd	a5,104(s1)
}
    80001c52:	8526                	mv	a0,s1
    80001c54:	60e2                	ld	ra,24(sp)
    80001c56:	6442                	ld	s0,16(sp)
    80001c58:	64a2                	ld	s1,8(sp)
    80001c5a:	6902                	ld	s2,0(sp)
    80001c5c:	6105                	addi	sp,sp,32
    80001c5e:	8082                	ret
    freeproc(p);
    80001c60:	8526                	mv	a0,s1
    80001c62:	00000097          	auipc	ra,0x0
    80001c66:	efc080e7          	jalr	-260(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	fffff097          	auipc	ra,0xfffff
    80001c70:	01e080e7          	jalr	30(ra) # 80000c8a <release>
    return 0;
    80001c74:	84ca                	mv	s1,s2
    80001c76:	bff1                	j	80001c52 <allocproc+0x9c>
    freeproc(p);
    80001c78:	8526                	mv	a0,s1
    80001c7a:	00000097          	auipc	ra,0x0
    80001c7e:	ee4080e7          	jalr	-284(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001c82:	8526                	mv	a0,s1
    80001c84:	fffff097          	auipc	ra,0xfffff
    80001c88:	006080e7          	jalr	6(ra) # 80000c8a <release>
    return 0;
    80001c8c:	84ca                	mv	s1,s2
    80001c8e:	b7d1                	j	80001c52 <allocproc+0x9c>

0000000080001c90 <userinit>:
{
    80001c90:	1101                	addi	sp,sp,-32
    80001c92:	ec06                	sd	ra,24(sp)
    80001c94:	e822                	sd	s0,16(sp)
    80001c96:	e426                	sd	s1,8(sp)
    80001c98:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c9a:	00000097          	auipc	ra,0x0
    80001c9e:	f1c080e7          	jalr	-228(ra) # 80001bb6 <allocproc>
    80001ca2:	84aa                	mv	s1,a0
  initproc = p;
    80001ca4:	00008797          	auipc	a5,0x8
    80001ca8:	f0a7ba23          	sd	a0,-236(a5) # 80009bb8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001cac:	03400613          	li	a2,52
    80001cb0:	00008597          	auipc	a1,0x8
    80001cb4:	e8058593          	addi	a1,a1,-384 # 80009b30 <initcode>
    80001cb8:	6928                	ld	a0,80(a0)
    80001cba:	fffff097          	auipc	ra,0xfffff
    80001cbe:	69c080e7          	jalr	1692(ra) # 80001356 <uvmfirst>
  p->sz = PGSIZE;
    80001cc2:	6785                	lui	a5,0x1
    80001cc4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cc6:	6cb8                	ld	a4,88(s1)
    80001cc8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001ccc:	6cb8                	ld	a4,88(s1)
    80001cce:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cd0:	4641                	li	a2,16
    80001cd2:	00007597          	auipc	a1,0x7
    80001cd6:	52e58593          	addi	a1,a1,1326 # 80009200 <digits+0x1c0>
    80001cda:	15848513          	addi	a0,s1,344
    80001cde:	fffff097          	auipc	ra,0xfffff
    80001ce2:	13e080e7          	jalr	318(ra) # 80000e1c <safestrcpy>
  p->cwd = namei("/");
    80001ce6:	00007517          	auipc	a0,0x7
    80001cea:	52a50513          	addi	a0,a0,1322 # 80009210 <digits+0x1d0>
    80001cee:	00002097          	auipc	ra,0x2
    80001cf2:	482080e7          	jalr	1154(ra) # 80004170 <namei>
    80001cf6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cfa:	478d                	li	a5,3
    80001cfc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001cfe:	8526                	mv	a0,s1
    80001d00:	fffff097          	auipc	ra,0xfffff
    80001d04:	f8a080e7          	jalr	-118(ra) # 80000c8a <release>
}
    80001d08:	60e2                	ld	ra,24(sp)
    80001d0a:	6442                	ld	s0,16(sp)
    80001d0c:	64a2                	ld	s1,8(sp)
    80001d0e:	6105                	addi	sp,sp,32
    80001d10:	8082                	ret

0000000080001d12 <growproc>:
{
    80001d12:	1101                	addi	sp,sp,-32
    80001d14:	ec06                	sd	ra,24(sp)
    80001d16:	e822                	sd	s0,16(sp)
    80001d18:	e426                	sd	s1,8(sp)
    80001d1a:	e04a                	sd	s2,0(sp)
    80001d1c:	1000                	addi	s0,sp,32
    80001d1e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	c8c080e7          	jalr	-884(ra) # 800019ac <myproc>
    80001d28:	84aa                	mv	s1,a0
  sz = p->sz;
    80001d2a:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001d2c:	01204c63          	bgtz	s2,80001d44 <growproc+0x32>
  } else if(n < 0){
    80001d30:	02094663          	bltz	s2,80001d5c <growproc+0x4a>
  p->sz = sz;
    80001d34:	e4ac                	sd	a1,72(s1)
  return 0;
    80001d36:	4501                	li	a0,0
}
    80001d38:	60e2                	ld	ra,24(sp)
    80001d3a:	6442                	ld	s0,16(sp)
    80001d3c:	64a2                	ld	s1,8(sp)
    80001d3e:	6902                	ld	s2,0(sp)
    80001d40:	6105                	addi	sp,sp,32
    80001d42:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d44:	4691                	li	a3,4
    80001d46:	00b90633          	add	a2,s2,a1
    80001d4a:	6928                	ld	a0,80(a0)
    80001d4c:	fffff097          	auipc	ra,0xfffff
    80001d50:	6c4080e7          	jalr	1732(ra) # 80001410 <uvmalloc>
    80001d54:	85aa                	mv	a1,a0
    80001d56:	fd79                	bnez	a0,80001d34 <growproc+0x22>
      return -1;
    80001d58:	557d                	li	a0,-1
    80001d5a:	bff9                	j	80001d38 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d5c:	00b90633          	add	a2,s2,a1
    80001d60:	6928                	ld	a0,80(a0)
    80001d62:	fffff097          	auipc	ra,0xfffff
    80001d66:	666080e7          	jalr	1638(ra) # 800013c8 <uvmdealloc>
    80001d6a:	85aa                	mv	a1,a0
    80001d6c:	b7e1                	j	80001d34 <growproc+0x22>

0000000080001d6e <fork>:
{
    80001d6e:	7139                	addi	sp,sp,-64
    80001d70:	fc06                	sd	ra,56(sp)
    80001d72:	f822                	sd	s0,48(sp)
    80001d74:	f426                	sd	s1,40(sp)
    80001d76:	f04a                	sd	s2,32(sp)
    80001d78:	ec4e                	sd	s3,24(sp)
    80001d7a:	e852                	sd	s4,16(sp)
    80001d7c:	e456                	sd	s5,8(sp)
    80001d7e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d80:	00000097          	auipc	ra,0x0
    80001d84:	c2c080e7          	jalr	-980(ra) # 800019ac <myproc>
    80001d88:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d8a:	00000097          	auipc	ra,0x0
    80001d8e:	e2c080e7          	jalr	-468(ra) # 80001bb6 <allocproc>
    80001d92:	10050c63          	beqz	a0,80001eaa <fork+0x13c>
    80001d96:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d98:	048ab603          	ld	a2,72(s5)
    80001d9c:	692c                	ld	a1,80(a0)
    80001d9e:	050ab503          	ld	a0,80(s5)
    80001da2:	fffff097          	auipc	ra,0xfffff
    80001da6:	7c6080e7          	jalr	1990(ra) # 80001568 <uvmcopy>
    80001daa:	04054863          	bltz	a0,80001dfa <fork+0x8c>
  np->sz = p->sz;
    80001dae:	048ab783          	ld	a5,72(s5)
    80001db2:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001db6:	058ab683          	ld	a3,88(s5)
    80001dba:	87b6                	mv	a5,a3
    80001dbc:	058a3703          	ld	a4,88(s4)
    80001dc0:	12068693          	addi	a3,a3,288
    80001dc4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dc8:	6788                	ld	a0,8(a5)
    80001dca:	6b8c                	ld	a1,16(a5)
    80001dcc:	6f90                	ld	a2,24(a5)
    80001dce:	01073023          	sd	a6,0(a4)
    80001dd2:	e708                	sd	a0,8(a4)
    80001dd4:	eb0c                	sd	a1,16(a4)
    80001dd6:	ef10                	sd	a2,24(a4)
    80001dd8:	02078793          	addi	a5,a5,32
    80001ddc:	02070713          	addi	a4,a4,32
    80001de0:	fed792e3          	bne	a5,a3,80001dc4 <fork+0x56>
  np->trapframe->a0 = 0;
    80001de4:	058a3783          	ld	a5,88(s4)
    80001de8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001dec:	0d0a8493          	addi	s1,s5,208
    80001df0:	0d0a0913          	addi	s2,s4,208
    80001df4:	150a8993          	addi	s3,s5,336
    80001df8:	a00d                	j	80001e1a <fork+0xac>
    freeproc(np);
    80001dfa:	8552                	mv	a0,s4
    80001dfc:	00000097          	auipc	ra,0x0
    80001e00:	d62080e7          	jalr	-670(ra) # 80001b5e <freeproc>
    release(&np->lock);
    80001e04:	8552                	mv	a0,s4
    80001e06:	fffff097          	auipc	ra,0xfffff
    80001e0a:	e84080e7          	jalr	-380(ra) # 80000c8a <release>
    return -1;
    80001e0e:	597d                	li	s2,-1
    80001e10:	a059                	j	80001e96 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001e12:	04a1                	addi	s1,s1,8
    80001e14:	0921                	addi	s2,s2,8
    80001e16:	01348b63          	beq	s1,s3,80001e2c <fork+0xbe>
    if(p->ofile[i])
    80001e1a:	6088                	ld	a0,0(s1)
    80001e1c:	d97d                	beqz	a0,80001e12 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e1e:	00003097          	auipc	ra,0x3
    80001e22:	9e8080e7          	jalr	-1560(ra) # 80004806 <filedup>
    80001e26:	00a93023          	sd	a0,0(s2)
    80001e2a:	b7e5                	j	80001e12 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e2c:	150ab503          	ld	a0,336(s5)
    80001e30:	00002097          	auipc	ra,0x2
    80001e34:	b56080e7          	jalr	-1194(ra) # 80003986 <idup>
    80001e38:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e3c:	4641                	li	a2,16
    80001e3e:	158a8593          	addi	a1,s5,344
    80001e42:	158a0513          	addi	a0,s4,344
    80001e46:	fffff097          	auipc	ra,0xfffff
    80001e4a:	fd6080e7          	jalr	-42(ra) # 80000e1c <safestrcpy>
  pid = np->pid;
    80001e4e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001e52:	8552                	mv	a0,s4
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	e36080e7          	jalr	-458(ra) # 80000c8a <release>
  acquire(&wait_lock);
    80001e5c:	00010497          	auipc	s1,0x10
    80001e60:	fec48493          	addi	s1,s1,-20 # 80011e48 <wait_lock>
    80001e64:	8526                	mv	a0,s1
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	d70080e7          	jalr	-656(ra) # 80000bd6 <acquire>
  np->parent = p;
    80001e6e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001e72:	8526                	mv	a0,s1
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	e16080e7          	jalr	-490(ra) # 80000c8a <release>
  acquire(&np->lock);
    80001e7c:	8552                	mv	a0,s4
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	d58080e7          	jalr	-680(ra) # 80000bd6 <acquire>
  np->state = RUNNABLE;
    80001e86:	478d                	li	a5,3
    80001e88:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e8c:	8552                	mv	a0,s4
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	dfc080e7          	jalr	-516(ra) # 80000c8a <release>
}
    80001e96:	854a                	mv	a0,s2
    80001e98:	70e2                	ld	ra,56(sp)
    80001e9a:	7442                	ld	s0,48(sp)
    80001e9c:	74a2                	ld	s1,40(sp)
    80001e9e:	7902                	ld	s2,32(sp)
    80001ea0:	69e2                	ld	s3,24(sp)
    80001ea2:	6a42                	ld	s4,16(sp)
    80001ea4:	6aa2                	ld	s5,8(sp)
    80001ea6:	6121                	addi	sp,sp,64
    80001ea8:	8082                	ret
    return -1;
    80001eaa:	597d                	li	s2,-1
    80001eac:	b7ed                	j	80001e96 <fork+0x128>

0000000080001eae <scheduler>:
{
    80001eae:	7139                	addi	sp,sp,-64
    80001eb0:	fc06                	sd	ra,56(sp)
    80001eb2:	f822                	sd	s0,48(sp)
    80001eb4:	f426                	sd	s1,40(sp)
    80001eb6:	f04a                	sd	s2,32(sp)
    80001eb8:	ec4e                	sd	s3,24(sp)
    80001eba:	e852                	sd	s4,16(sp)
    80001ebc:	e456                	sd	s5,8(sp)
    80001ebe:	e05a                	sd	s6,0(sp)
    80001ec0:	0080                	addi	s0,sp,64
    80001ec2:	8792                	mv	a5,tp
  int id = r_tp();
    80001ec4:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ec6:	00779a93          	slli	s5,a5,0x7
    80001eca:	00010717          	auipc	a4,0x10
    80001ece:	f6670713          	addi	a4,a4,-154 # 80011e30 <pid_lock>
    80001ed2:	9756                	add	a4,a4,s5
    80001ed4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001ed8:	00010717          	auipc	a4,0x10
    80001edc:	f9070713          	addi	a4,a4,-112 # 80011e68 <cpus+0x8>
    80001ee0:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001ee2:	498d                	li	s3,3
        p->state = RUNNING;
    80001ee4:	4b11                	li	s6,4
        c->proc = p;
    80001ee6:	079e                	slli	a5,a5,0x7
    80001ee8:	00010a17          	auipc	s4,0x10
    80001eec:	f48a0a13          	addi	s4,s4,-184 # 80011e30 <pid_lock>
    80001ef0:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ef2:	00016917          	auipc	s2,0x16
    80001ef6:	36e90913          	addi	s2,s2,878 # 80018260 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001efa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001efe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f02:	10079073          	csrw	sstatus,a5
    80001f06:	00010497          	auipc	s1,0x10
    80001f0a:	35a48493          	addi	s1,s1,858 # 80012260 <proc>
    80001f0e:	a811                	j	80001f22 <scheduler+0x74>
      release(&p->lock);
    80001f10:	8526                	mv	a0,s1
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	d78080e7          	jalr	-648(ra) # 80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f1a:	18048493          	addi	s1,s1,384
    80001f1e:	fd248ee3          	beq	s1,s2,80001efa <scheduler+0x4c>
      acquire(&p->lock);
    80001f22:	8526                	mv	a0,s1
    80001f24:	fffff097          	auipc	ra,0xfffff
    80001f28:	cb2080e7          	jalr	-846(ra) # 80000bd6 <acquire>
      if(p->state == RUNNABLE) {
    80001f2c:	4c9c                	lw	a5,24(s1)
    80001f2e:	ff3791e3          	bne	a5,s3,80001f10 <scheduler+0x62>
        p->state = RUNNING;
    80001f32:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001f36:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001f3a:	06048593          	addi	a1,s1,96
    80001f3e:	8556                	mv	a0,s5
    80001f40:	00000097          	auipc	ra,0x0
    80001f44:	69c080e7          	jalr	1692(ra) # 800025dc <swtch>
        c->proc = 0;
    80001f48:	020a3823          	sd	zero,48(s4)
    80001f4c:	b7d1                	j	80001f10 <scheduler+0x62>

0000000080001f4e <sched>:
{
    80001f4e:	7179                	addi	sp,sp,-48
    80001f50:	f406                	sd	ra,40(sp)
    80001f52:	f022                	sd	s0,32(sp)
    80001f54:	ec26                	sd	s1,24(sp)
    80001f56:	e84a                	sd	s2,16(sp)
    80001f58:	e44e                	sd	s3,8(sp)
    80001f5a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f5c:	00000097          	auipc	ra,0x0
    80001f60:	a50080e7          	jalr	-1456(ra) # 800019ac <myproc>
    80001f64:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	bf6080e7          	jalr	-1034(ra) # 80000b5c <holding>
    80001f6e:	c93d                	beqz	a0,80001fe4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f70:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f72:	2781                	sext.w	a5,a5
    80001f74:	079e                	slli	a5,a5,0x7
    80001f76:	00010717          	auipc	a4,0x10
    80001f7a:	eba70713          	addi	a4,a4,-326 # 80011e30 <pid_lock>
    80001f7e:	97ba                	add	a5,a5,a4
    80001f80:	0a87a703          	lw	a4,168(a5)
    80001f84:	4785                	li	a5,1
    80001f86:	06f71763          	bne	a4,a5,80001ff4 <sched+0xa6>
  if(p->state == RUNNING)
    80001f8a:	4c98                	lw	a4,24(s1)
    80001f8c:	4791                	li	a5,4
    80001f8e:	06f70b63          	beq	a4,a5,80002004 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f92:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f96:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001f98:	efb5                	bnez	a5,80002014 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f9a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f9c:	00010917          	auipc	s2,0x10
    80001fa0:	e9490913          	addi	s2,s2,-364 # 80011e30 <pid_lock>
    80001fa4:	2781                	sext.w	a5,a5
    80001fa6:	079e                	slli	a5,a5,0x7
    80001fa8:	97ca                	add	a5,a5,s2
    80001faa:	0ac7a983          	lw	s3,172(a5)
    80001fae:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001fb0:	2781                	sext.w	a5,a5
    80001fb2:	079e                	slli	a5,a5,0x7
    80001fb4:	00010597          	auipc	a1,0x10
    80001fb8:	eb458593          	addi	a1,a1,-332 # 80011e68 <cpus+0x8>
    80001fbc:	95be                	add	a1,a1,a5
    80001fbe:	06048513          	addi	a0,s1,96
    80001fc2:	00000097          	auipc	ra,0x0
    80001fc6:	61a080e7          	jalr	1562(ra) # 800025dc <swtch>
    80001fca:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001fcc:	2781                	sext.w	a5,a5
    80001fce:	079e                	slli	a5,a5,0x7
    80001fd0:	993e                	add	s2,s2,a5
    80001fd2:	0b392623          	sw	s3,172(s2)
}
    80001fd6:	70a2                	ld	ra,40(sp)
    80001fd8:	7402                	ld	s0,32(sp)
    80001fda:	64e2                	ld	s1,24(sp)
    80001fdc:	6942                	ld	s2,16(sp)
    80001fde:	69a2                	ld	s3,8(sp)
    80001fe0:	6145                	addi	sp,sp,48
    80001fe2:	8082                	ret
    panic("sched p->lock");
    80001fe4:	00007517          	auipc	a0,0x7
    80001fe8:	23450513          	addi	a0,a0,564 # 80009218 <digits+0x1d8>
    80001fec:	ffffe097          	auipc	ra,0xffffe
    80001ff0:	554080e7          	jalr	1364(ra) # 80000540 <panic>
    panic("sched locks");
    80001ff4:	00007517          	auipc	a0,0x7
    80001ff8:	23450513          	addi	a0,a0,564 # 80009228 <digits+0x1e8>
    80001ffc:	ffffe097          	auipc	ra,0xffffe
    80002000:	544080e7          	jalr	1348(ra) # 80000540 <panic>
    panic("sched running");
    80002004:	00007517          	auipc	a0,0x7
    80002008:	23450513          	addi	a0,a0,564 # 80009238 <digits+0x1f8>
    8000200c:	ffffe097          	auipc	ra,0xffffe
    80002010:	534080e7          	jalr	1332(ra) # 80000540 <panic>
    panic("sched interruptible");
    80002014:	00007517          	auipc	a0,0x7
    80002018:	23450513          	addi	a0,a0,564 # 80009248 <digits+0x208>
    8000201c:	ffffe097          	auipc	ra,0xffffe
    80002020:	524080e7          	jalr	1316(ra) # 80000540 <panic>

0000000080002024 <yield>:
{
    80002024:	1101                	addi	sp,sp,-32
    80002026:	ec06                	sd	ra,24(sp)
    80002028:	e822                	sd	s0,16(sp)
    8000202a:	e426                	sd	s1,8(sp)
    8000202c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000202e:	00000097          	auipc	ra,0x0
    80002032:	97e080e7          	jalr	-1666(ra) # 800019ac <myproc>
    80002036:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002038:	fffff097          	auipc	ra,0xfffff
    8000203c:	b9e080e7          	jalr	-1122(ra) # 80000bd6 <acquire>
  p->state = RUNNABLE;
    80002040:	478d                	li	a5,3
    80002042:	cc9c                	sw	a5,24(s1)
  sched();
    80002044:	00000097          	auipc	ra,0x0
    80002048:	f0a080e7          	jalr	-246(ra) # 80001f4e <sched>
  release(&p->lock);
    8000204c:	8526                	mv	a0,s1
    8000204e:	fffff097          	auipc	ra,0xfffff
    80002052:	c3c080e7          	jalr	-964(ra) # 80000c8a <release>
}
    80002056:	60e2                	ld	ra,24(sp)
    80002058:	6442                	ld	s0,16(sp)
    8000205a:	64a2                	ld	s1,8(sp)
    8000205c:	6105                	addi	sp,sp,32
    8000205e:	8082                	ret

0000000080002060 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002060:	7179                	addi	sp,sp,-48
    80002062:	f406                	sd	ra,40(sp)
    80002064:	f022                	sd	s0,32(sp)
    80002066:	ec26                	sd	s1,24(sp)
    80002068:	e84a                	sd	s2,16(sp)
    8000206a:	e44e                	sd	s3,8(sp)
    8000206c:	1800                	addi	s0,sp,48
    8000206e:	89aa                	mv	s3,a0
    80002070:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002072:	00000097          	auipc	ra,0x0
    80002076:	93a080e7          	jalr	-1734(ra) # 800019ac <myproc>
    8000207a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	b5a080e7          	jalr	-1190(ra) # 80000bd6 <acquire>
  release(lk);
    80002084:	854a                	mv	a0,s2
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	c04080e7          	jalr	-1020(ra) # 80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    8000208e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002092:	4789                	li	a5,2
    80002094:	cc9c                	sw	a5,24(s1)

  sched();
    80002096:	00000097          	auipc	ra,0x0
    8000209a:	eb8080e7          	jalr	-328(ra) # 80001f4e <sched>

  // Tidy up.
  p->chan = 0;
    8000209e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800020a2:	8526                	mv	a0,s1
    800020a4:	fffff097          	auipc	ra,0xfffff
    800020a8:	be6080e7          	jalr	-1050(ra) # 80000c8a <release>
  acquire(lk);
    800020ac:	854a                	mv	a0,s2
    800020ae:	fffff097          	auipc	ra,0xfffff
    800020b2:	b28080e7          	jalr	-1240(ra) # 80000bd6 <acquire>
}
    800020b6:	70a2                	ld	ra,40(sp)
    800020b8:	7402                	ld	s0,32(sp)
    800020ba:	64e2                	ld	s1,24(sp)
    800020bc:	6942                	ld	s2,16(sp)
    800020be:	69a2                	ld	s3,8(sp)
    800020c0:	6145                	addi	sp,sp,48
    800020c2:	8082                	ret

00000000800020c4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800020c4:	7139                	addi	sp,sp,-64
    800020c6:	fc06                	sd	ra,56(sp)
    800020c8:	f822                	sd	s0,48(sp)
    800020ca:	f426                	sd	s1,40(sp)
    800020cc:	f04a                	sd	s2,32(sp)
    800020ce:	ec4e                	sd	s3,24(sp)
    800020d0:	e852                	sd	s4,16(sp)
    800020d2:	e456                	sd	s5,8(sp)
    800020d4:	0080                	addi	s0,sp,64
    800020d6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800020d8:	00010497          	auipc	s1,0x10
    800020dc:	18848493          	addi	s1,s1,392 # 80012260 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800020e0:	4989                	li	s3,2
        p->state = RUNNABLE;
    800020e2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800020e4:	00016917          	auipc	s2,0x16
    800020e8:	17c90913          	addi	s2,s2,380 # 80018260 <tickslock>
    800020ec:	a811                	j	80002100 <wakeup+0x3c>
      }
      release(&p->lock);
    800020ee:	8526                	mv	a0,s1
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	b9a080e7          	jalr	-1126(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800020f8:	18048493          	addi	s1,s1,384
    800020fc:	03248663          	beq	s1,s2,80002128 <wakeup+0x64>
    if(p != myproc()){
    80002100:	00000097          	auipc	ra,0x0
    80002104:	8ac080e7          	jalr	-1876(ra) # 800019ac <myproc>
    80002108:	fea488e3          	beq	s1,a0,800020f8 <wakeup+0x34>
      acquire(&p->lock);
    8000210c:	8526                	mv	a0,s1
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	ac8080e7          	jalr	-1336(ra) # 80000bd6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002116:	4c9c                	lw	a5,24(s1)
    80002118:	fd379be3          	bne	a5,s3,800020ee <wakeup+0x2a>
    8000211c:	709c                	ld	a5,32(s1)
    8000211e:	fd4798e3          	bne	a5,s4,800020ee <wakeup+0x2a>
        p->state = RUNNABLE;
    80002122:	0154ac23          	sw	s5,24(s1)
    80002126:	b7e1                	j	800020ee <wakeup+0x2a>
    }
  }
}
    80002128:	70e2                	ld	ra,56(sp)
    8000212a:	7442                	ld	s0,48(sp)
    8000212c:	74a2                	ld	s1,40(sp)
    8000212e:	7902                	ld	s2,32(sp)
    80002130:	69e2                	ld	s3,24(sp)
    80002132:	6a42                	ld	s4,16(sp)
    80002134:	6aa2                	ld	s5,8(sp)
    80002136:	6121                	addi	sp,sp,64
    80002138:	8082                	ret

000000008000213a <reparent>:
{
    8000213a:	7179                	addi	sp,sp,-48
    8000213c:	f406                	sd	ra,40(sp)
    8000213e:	f022                	sd	s0,32(sp)
    80002140:	ec26                	sd	s1,24(sp)
    80002142:	e84a                	sd	s2,16(sp)
    80002144:	e44e                	sd	s3,8(sp)
    80002146:	e052                	sd	s4,0(sp)
    80002148:	1800                	addi	s0,sp,48
    8000214a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000214c:	00010497          	auipc	s1,0x10
    80002150:	11448493          	addi	s1,s1,276 # 80012260 <proc>
      pp->parent = initproc;
    80002154:	00008a17          	auipc	s4,0x8
    80002158:	a64a0a13          	addi	s4,s4,-1436 # 80009bb8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000215c:	00016997          	auipc	s3,0x16
    80002160:	10498993          	addi	s3,s3,260 # 80018260 <tickslock>
    80002164:	a029                	j	8000216e <reparent+0x34>
    80002166:	18048493          	addi	s1,s1,384
    8000216a:	01348d63          	beq	s1,s3,80002184 <reparent+0x4a>
    if(pp->parent == p){
    8000216e:	7c9c                	ld	a5,56(s1)
    80002170:	ff279be3          	bne	a5,s2,80002166 <reparent+0x2c>
      pp->parent = initproc;
    80002174:	000a3503          	ld	a0,0(s4)
    80002178:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000217a:	00000097          	auipc	ra,0x0
    8000217e:	f4a080e7          	jalr	-182(ra) # 800020c4 <wakeup>
    80002182:	b7d5                	j	80002166 <reparent+0x2c>
}
    80002184:	70a2                	ld	ra,40(sp)
    80002186:	7402                	ld	s0,32(sp)
    80002188:	64e2                	ld	s1,24(sp)
    8000218a:	6942                	ld	s2,16(sp)
    8000218c:	69a2                	ld	s3,8(sp)
    8000218e:	6a02                	ld	s4,0(sp)
    80002190:	6145                	addi	sp,sp,48
    80002192:	8082                	ret

0000000080002194 <exit>:
{
    80002194:	7179                	addi	sp,sp,-48
    80002196:	f406                	sd	ra,40(sp)
    80002198:	f022                	sd	s0,32(sp)
    8000219a:	ec26                	sd	s1,24(sp)
    8000219c:	e84a                	sd	s2,16(sp)
    8000219e:	e44e                	sd	s3,8(sp)
    800021a0:	e052                	sd	s4,0(sp)
    800021a2:	1800                	addi	s0,sp,48
    800021a4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800021a6:	00000097          	auipc	ra,0x0
    800021aa:	806080e7          	jalr	-2042(ra) # 800019ac <myproc>
    800021ae:	892a                	mv	s2,a0
  p->execTime.endTime = sys_uptime();
    800021b0:	00001097          	auipc	ra,0x1
    800021b4:	ede080e7          	jalr	-290(ra) # 8000308e <sys_uptime>
    800021b8:	16a93823          	sd	a0,368(s2)
  p->execTime.totalTime = p->execTime.endTime - p->execTime.creationTime;
    800021bc:	16893783          	ld	a5,360(s2)
    800021c0:	40f507b3          	sub	a5,a0,a5
    800021c4:	16f93c23          	sd	a5,376(s2)
  if(p == initproc)
    800021c8:	00008797          	auipc	a5,0x8
    800021cc:	9f07b783          	ld	a5,-1552(a5) # 80009bb8 <initproc>
    800021d0:	0d090493          	addi	s1,s2,208
    800021d4:	15090993          	addi	s3,s2,336
    800021d8:	03279363          	bne	a5,s2,800021fe <exit+0x6a>
    panic("init exiting");
    800021dc:	00007517          	auipc	a0,0x7
    800021e0:	08450513          	addi	a0,a0,132 # 80009260 <digits+0x220>
    800021e4:	ffffe097          	auipc	ra,0xffffe
    800021e8:	35c080e7          	jalr	860(ra) # 80000540 <panic>
      fileclose(f);
    800021ec:	00002097          	auipc	ra,0x2
    800021f0:	66c080e7          	jalr	1644(ra) # 80004858 <fileclose>
      p->ofile[fd] = 0;
    800021f4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800021f8:	04a1                	addi	s1,s1,8
    800021fa:	01348563          	beq	s1,s3,80002204 <exit+0x70>
    if(p->ofile[fd]){
    800021fe:	6088                	ld	a0,0(s1)
    80002200:	f575                	bnez	a0,800021ec <exit+0x58>
    80002202:	bfdd                	j	800021f8 <exit+0x64>
  begin_op();
    80002204:	00002097          	auipc	ra,0x2
    80002208:	18c080e7          	jalr	396(ra) # 80004390 <begin_op>
  iput(p->cwd);
    8000220c:	15093503          	ld	a0,336(s2)
    80002210:	00002097          	auipc	ra,0x2
    80002214:	96e080e7          	jalr	-1682(ra) # 80003b7e <iput>
  end_op();
    80002218:	00002097          	auipc	ra,0x2
    8000221c:	1f6080e7          	jalr	502(ra) # 8000440e <end_op>
  p->cwd = 0;
    80002220:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    80002224:	00010497          	auipc	s1,0x10
    80002228:	c2448493          	addi	s1,s1,-988 # 80011e48 <wait_lock>
    8000222c:	8526                	mv	a0,s1
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	9a8080e7          	jalr	-1624(ra) # 80000bd6 <acquire>
  reparent(p);
    80002236:	854a                	mv	a0,s2
    80002238:	00000097          	auipc	ra,0x0
    8000223c:	f02080e7          	jalr	-254(ra) # 8000213a <reparent>
  wakeup(p->parent);
    80002240:	03893503          	ld	a0,56(s2)
    80002244:	00000097          	auipc	ra,0x0
    80002248:	e80080e7          	jalr	-384(ra) # 800020c4 <wakeup>
  acquire(&p->lock);
    8000224c:	854a                	mv	a0,s2
    8000224e:	fffff097          	auipc	ra,0xfffff
    80002252:	988080e7          	jalr	-1656(ra) # 80000bd6 <acquire>
  p->xstate = status;
    80002256:	03492623          	sw	s4,44(s2)
  p->state = ZOMBIE;
    8000225a:	4795                	li	a5,5
    8000225c:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    80002260:	8526                	mv	a0,s1
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	a28080e7          	jalr	-1496(ra) # 80000c8a <release>
  sched();
    8000226a:	00000097          	auipc	ra,0x0
    8000226e:	ce4080e7          	jalr	-796(ra) # 80001f4e <sched>
  panic("zombie exit");
    80002272:	00007517          	auipc	a0,0x7
    80002276:	ffe50513          	addi	a0,a0,-2 # 80009270 <digits+0x230>
    8000227a:	ffffe097          	auipc	ra,0xffffe
    8000227e:	2c6080e7          	jalr	710(ra) # 80000540 <panic>

0000000080002282 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002282:	7179                	addi	sp,sp,-48
    80002284:	f406                	sd	ra,40(sp)
    80002286:	f022                	sd	s0,32(sp)
    80002288:	ec26                	sd	s1,24(sp)
    8000228a:	e84a                	sd	s2,16(sp)
    8000228c:	e44e                	sd	s3,8(sp)
    8000228e:	1800                	addi	s0,sp,48
    80002290:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002292:	00010497          	auipc	s1,0x10
    80002296:	fce48493          	addi	s1,s1,-50 # 80012260 <proc>
    8000229a:	00016997          	auipc	s3,0x16
    8000229e:	fc698993          	addi	s3,s3,-58 # 80018260 <tickslock>
    acquire(&p->lock);
    800022a2:	8526                	mv	a0,s1
    800022a4:	fffff097          	auipc	ra,0xfffff
    800022a8:	932080e7          	jalr	-1742(ra) # 80000bd6 <acquire>
    if(p->pid == pid){
    800022ac:	589c                	lw	a5,48(s1)
    800022ae:	01278d63          	beq	a5,s2,800022c8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800022b2:	8526                	mv	a0,s1
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	9d6080e7          	jalr	-1578(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800022bc:	18048493          	addi	s1,s1,384
    800022c0:	ff3491e3          	bne	s1,s3,800022a2 <kill+0x20>
  }
  return -1;
    800022c4:	557d                	li	a0,-1
    800022c6:	a829                	j	800022e0 <kill+0x5e>
      p->killed = 1;
    800022c8:	4785                	li	a5,1
    800022ca:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800022cc:	4c98                	lw	a4,24(s1)
    800022ce:	4789                	li	a5,2
    800022d0:	00f70f63          	beq	a4,a5,800022ee <kill+0x6c>
      release(&p->lock);
    800022d4:	8526                	mv	a0,s1
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	9b4080e7          	jalr	-1612(ra) # 80000c8a <release>
      return 0;
    800022de:	4501                	li	a0,0
}
    800022e0:	70a2                	ld	ra,40(sp)
    800022e2:	7402                	ld	s0,32(sp)
    800022e4:	64e2                	ld	s1,24(sp)
    800022e6:	6942                	ld	s2,16(sp)
    800022e8:	69a2                	ld	s3,8(sp)
    800022ea:	6145                	addi	sp,sp,48
    800022ec:	8082                	ret
        p->state = RUNNABLE;
    800022ee:	478d                	li	a5,3
    800022f0:	cc9c                	sw	a5,24(s1)
    800022f2:	b7cd                	j	800022d4 <kill+0x52>

00000000800022f4 <setkilled>:

void
setkilled(struct proc *p)
{
    800022f4:	1101                	addi	sp,sp,-32
    800022f6:	ec06                	sd	ra,24(sp)
    800022f8:	e822                	sd	s0,16(sp)
    800022fa:	e426                	sd	s1,8(sp)
    800022fc:	1000                	addi	s0,sp,32
    800022fe:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	8d6080e7          	jalr	-1834(ra) # 80000bd6 <acquire>
  p->killed = 1;
    80002308:	4785                	li	a5,1
    8000230a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000230c:	8526                	mv	a0,s1
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	97c080e7          	jalr	-1668(ra) # 80000c8a <release>
}
    80002316:	60e2                	ld	ra,24(sp)
    80002318:	6442                	ld	s0,16(sp)
    8000231a:	64a2                	ld	s1,8(sp)
    8000231c:	6105                	addi	sp,sp,32
    8000231e:	8082                	ret

0000000080002320 <killed>:

int
killed(struct proc *p)
{
    80002320:	1101                	addi	sp,sp,-32
    80002322:	ec06                	sd	ra,24(sp)
    80002324:	e822                	sd	s0,16(sp)
    80002326:	e426                	sd	s1,8(sp)
    80002328:	e04a                	sd	s2,0(sp)
    8000232a:	1000                	addi	s0,sp,32
    8000232c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000232e:	fffff097          	auipc	ra,0xfffff
    80002332:	8a8080e7          	jalr	-1880(ra) # 80000bd6 <acquire>
  k = p->killed;
    80002336:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000233a:	8526                	mv	a0,s1
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	94e080e7          	jalr	-1714(ra) # 80000c8a <release>
  return k;
}
    80002344:	854a                	mv	a0,s2
    80002346:	60e2                	ld	ra,24(sp)
    80002348:	6442                	ld	s0,16(sp)
    8000234a:	64a2                	ld	s1,8(sp)
    8000234c:	6902                	ld	s2,0(sp)
    8000234e:	6105                	addi	sp,sp,32
    80002350:	8082                	ret

0000000080002352 <wait>:
{
    80002352:	715d                	addi	sp,sp,-80
    80002354:	e486                	sd	ra,72(sp)
    80002356:	e0a2                	sd	s0,64(sp)
    80002358:	fc26                	sd	s1,56(sp)
    8000235a:	f84a                	sd	s2,48(sp)
    8000235c:	f44e                	sd	s3,40(sp)
    8000235e:	f052                	sd	s4,32(sp)
    80002360:	ec56                	sd	s5,24(sp)
    80002362:	e85a                	sd	s6,16(sp)
    80002364:	e45e                	sd	s7,8(sp)
    80002366:	e062                	sd	s8,0(sp)
    80002368:	0880                	addi	s0,sp,80
    8000236a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000236c:	fffff097          	auipc	ra,0xfffff
    80002370:	640080e7          	jalr	1600(ra) # 800019ac <myproc>
    80002374:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002376:	00010517          	auipc	a0,0x10
    8000237a:	ad250513          	addi	a0,a0,-1326 # 80011e48 <wait_lock>
    8000237e:	fffff097          	auipc	ra,0xfffff
    80002382:	858080e7          	jalr	-1960(ra) # 80000bd6 <acquire>
    havekids = 0;
    80002386:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002388:	4a15                	li	s4,5
        havekids = 1;
    8000238a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000238c:	00016997          	auipc	s3,0x16
    80002390:	ed498993          	addi	s3,s3,-300 # 80018260 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002394:	00010c17          	auipc	s8,0x10
    80002398:	ab4c0c13          	addi	s8,s8,-1356 # 80011e48 <wait_lock>
    havekids = 0;
    8000239c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000239e:	00010497          	auipc	s1,0x10
    800023a2:	ec248493          	addi	s1,s1,-318 # 80012260 <proc>
    800023a6:	a0bd                	j	80002414 <wait+0xc2>
          pid = pp->pid;
    800023a8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800023ac:	000b0e63          	beqz	s6,800023c8 <wait+0x76>
    800023b0:	4691                	li	a3,4
    800023b2:	02c48613          	addi	a2,s1,44
    800023b6:	85da                	mv	a1,s6
    800023b8:	05093503          	ld	a0,80(s2)
    800023bc:	fffff097          	auipc	ra,0xfffff
    800023c0:	2b0080e7          	jalr	688(ra) # 8000166c <copyout>
    800023c4:	02054563          	bltz	a0,800023ee <wait+0x9c>
          freeproc(pp);
    800023c8:	8526                	mv	a0,s1
    800023ca:	fffff097          	auipc	ra,0xfffff
    800023ce:	794080e7          	jalr	1940(ra) # 80001b5e <freeproc>
          release(&pp->lock);
    800023d2:	8526                	mv	a0,s1
    800023d4:	fffff097          	auipc	ra,0xfffff
    800023d8:	8b6080e7          	jalr	-1866(ra) # 80000c8a <release>
          release(&wait_lock);
    800023dc:	00010517          	auipc	a0,0x10
    800023e0:	a6c50513          	addi	a0,a0,-1428 # 80011e48 <wait_lock>
    800023e4:	fffff097          	auipc	ra,0xfffff
    800023e8:	8a6080e7          	jalr	-1882(ra) # 80000c8a <release>
          return pid;
    800023ec:	a0b5                	j	80002458 <wait+0x106>
            release(&pp->lock);
    800023ee:	8526                	mv	a0,s1
    800023f0:	fffff097          	auipc	ra,0xfffff
    800023f4:	89a080e7          	jalr	-1894(ra) # 80000c8a <release>
            release(&wait_lock);
    800023f8:	00010517          	auipc	a0,0x10
    800023fc:	a5050513          	addi	a0,a0,-1456 # 80011e48 <wait_lock>
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	88a080e7          	jalr	-1910(ra) # 80000c8a <release>
            return -1;
    80002408:	59fd                	li	s3,-1
    8000240a:	a0b9                	j	80002458 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000240c:	18048493          	addi	s1,s1,384
    80002410:	03348463          	beq	s1,s3,80002438 <wait+0xe6>
      if(pp->parent == p){
    80002414:	7c9c                	ld	a5,56(s1)
    80002416:	ff279be3          	bne	a5,s2,8000240c <wait+0xba>
        acquire(&pp->lock);
    8000241a:	8526                	mv	a0,s1
    8000241c:	ffffe097          	auipc	ra,0xffffe
    80002420:	7ba080e7          	jalr	1978(ra) # 80000bd6 <acquire>
        if(pp->state == ZOMBIE){
    80002424:	4c9c                	lw	a5,24(s1)
    80002426:	f94781e3          	beq	a5,s4,800023a8 <wait+0x56>
        release(&pp->lock);
    8000242a:	8526                	mv	a0,s1
    8000242c:	fffff097          	auipc	ra,0xfffff
    80002430:	85e080e7          	jalr	-1954(ra) # 80000c8a <release>
        havekids = 1;
    80002434:	8756                	mv	a4,s5
    80002436:	bfd9                	j	8000240c <wait+0xba>
    if(!havekids || killed(p)){
    80002438:	c719                	beqz	a4,80002446 <wait+0xf4>
    8000243a:	854a                	mv	a0,s2
    8000243c:	00000097          	auipc	ra,0x0
    80002440:	ee4080e7          	jalr	-284(ra) # 80002320 <killed>
    80002444:	c51d                	beqz	a0,80002472 <wait+0x120>
      release(&wait_lock);
    80002446:	00010517          	auipc	a0,0x10
    8000244a:	a0250513          	addi	a0,a0,-1534 # 80011e48 <wait_lock>
    8000244e:	fffff097          	auipc	ra,0xfffff
    80002452:	83c080e7          	jalr	-1988(ra) # 80000c8a <release>
      return -1;
    80002456:	59fd                	li	s3,-1
}
    80002458:	854e                	mv	a0,s3
    8000245a:	60a6                	ld	ra,72(sp)
    8000245c:	6406                	ld	s0,64(sp)
    8000245e:	74e2                	ld	s1,56(sp)
    80002460:	7942                	ld	s2,48(sp)
    80002462:	79a2                	ld	s3,40(sp)
    80002464:	7a02                	ld	s4,32(sp)
    80002466:	6ae2                	ld	s5,24(sp)
    80002468:	6b42                	ld	s6,16(sp)
    8000246a:	6ba2                	ld	s7,8(sp)
    8000246c:	6c02                	ld	s8,0(sp)
    8000246e:	6161                	addi	sp,sp,80
    80002470:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002472:	85e2                	mv	a1,s8
    80002474:	854a                	mv	a0,s2
    80002476:	00000097          	auipc	ra,0x0
    8000247a:	bea080e7          	jalr	-1046(ra) # 80002060 <sleep>
    havekids = 0;
    8000247e:	bf39                	j	8000239c <wait+0x4a>

0000000080002480 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002480:	7179                	addi	sp,sp,-48
    80002482:	f406                	sd	ra,40(sp)
    80002484:	f022                	sd	s0,32(sp)
    80002486:	ec26                	sd	s1,24(sp)
    80002488:	e84a                	sd	s2,16(sp)
    8000248a:	e44e                	sd	s3,8(sp)
    8000248c:	e052                	sd	s4,0(sp)
    8000248e:	1800                	addi	s0,sp,48
    80002490:	84aa                	mv	s1,a0
    80002492:	892e                	mv	s2,a1
    80002494:	89b2                	mv	s3,a2
    80002496:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002498:	fffff097          	auipc	ra,0xfffff
    8000249c:	514080e7          	jalr	1300(ra) # 800019ac <myproc>
  if(user_dst){
    800024a0:	c08d                	beqz	s1,800024c2 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024a2:	86d2                	mv	a3,s4
    800024a4:	864e                	mv	a2,s3
    800024a6:	85ca                	mv	a1,s2
    800024a8:	6928                	ld	a0,80(a0)
    800024aa:	fffff097          	auipc	ra,0xfffff
    800024ae:	1c2080e7          	jalr	450(ra) # 8000166c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024b2:	70a2                	ld	ra,40(sp)
    800024b4:	7402                	ld	s0,32(sp)
    800024b6:	64e2                	ld	s1,24(sp)
    800024b8:	6942                	ld	s2,16(sp)
    800024ba:	69a2                	ld	s3,8(sp)
    800024bc:	6a02                	ld	s4,0(sp)
    800024be:	6145                	addi	sp,sp,48
    800024c0:	8082                	ret
    memmove((char *)dst, src, len);
    800024c2:	000a061b          	sext.w	a2,s4
    800024c6:	85ce                	mv	a1,s3
    800024c8:	854a                	mv	a0,s2
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	864080e7          	jalr	-1948(ra) # 80000d2e <memmove>
    return 0;
    800024d2:	8526                	mv	a0,s1
    800024d4:	bff9                	j	800024b2 <either_copyout+0x32>

00000000800024d6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024d6:	7179                	addi	sp,sp,-48
    800024d8:	f406                	sd	ra,40(sp)
    800024da:	f022                	sd	s0,32(sp)
    800024dc:	ec26                	sd	s1,24(sp)
    800024de:	e84a                	sd	s2,16(sp)
    800024e0:	e44e                	sd	s3,8(sp)
    800024e2:	e052                	sd	s4,0(sp)
    800024e4:	1800                	addi	s0,sp,48
    800024e6:	892a                	mv	s2,a0
    800024e8:	84ae                	mv	s1,a1
    800024ea:	89b2                	mv	s3,a2
    800024ec:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024ee:	fffff097          	auipc	ra,0xfffff
    800024f2:	4be080e7          	jalr	1214(ra) # 800019ac <myproc>
  if(user_src){
    800024f6:	c08d                	beqz	s1,80002518 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800024f8:	86d2                	mv	a3,s4
    800024fa:	864e                	mv	a2,s3
    800024fc:	85ca                	mv	a1,s2
    800024fe:	6928                	ld	a0,80(a0)
    80002500:	fffff097          	auipc	ra,0xfffff
    80002504:	1f8080e7          	jalr	504(ra) # 800016f8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002508:	70a2                	ld	ra,40(sp)
    8000250a:	7402                	ld	s0,32(sp)
    8000250c:	64e2                	ld	s1,24(sp)
    8000250e:	6942                	ld	s2,16(sp)
    80002510:	69a2                	ld	s3,8(sp)
    80002512:	6a02                	ld	s4,0(sp)
    80002514:	6145                	addi	sp,sp,48
    80002516:	8082                	ret
    memmove(dst, (char*)src, len);
    80002518:	000a061b          	sext.w	a2,s4
    8000251c:	85ce                	mv	a1,s3
    8000251e:	854a                	mv	a0,s2
    80002520:	fffff097          	auipc	ra,0xfffff
    80002524:	80e080e7          	jalr	-2034(ra) # 80000d2e <memmove>
    return 0;
    80002528:	8526                	mv	a0,s1
    8000252a:	bff9                	j	80002508 <either_copyin+0x32>

000000008000252c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000252c:	715d                	addi	sp,sp,-80
    8000252e:	e486                	sd	ra,72(sp)
    80002530:	e0a2                	sd	s0,64(sp)
    80002532:	fc26                	sd	s1,56(sp)
    80002534:	f84a                	sd	s2,48(sp)
    80002536:	f44e                	sd	s3,40(sp)
    80002538:	f052                	sd	s4,32(sp)
    8000253a:	ec56                	sd	s5,24(sp)
    8000253c:	e85a                	sd	s6,16(sp)
    8000253e:	e45e                	sd	s7,8(sp)
    80002540:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002542:	00007517          	auipc	a0,0x7
    80002546:	5d650513          	addi	a0,a0,1494 # 80009b18 <syscalls+0x6c8>
    8000254a:	ffffe097          	auipc	ra,0xffffe
    8000254e:	040080e7          	jalr	64(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002552:	00010497          	auipc	s1,0x10
    80002556:	e6648493          	addi	s1,s1,-410 # 800123b8 <proc+0x158>
    8000255a:	00016917          	auipc	s2,0x16
    8000255e:	e5e90913          	addi	s2,s2,-418 # 800183b8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002562:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002564:	00007997          	auipc	s3,0x7
    80002568:	d1c98993          	addi	s3,s3,-740 # 80009280 <digits+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    8000256c:	00007a97          	auipc	s5,0x7
    80002570:	d1ca8a93          	addi	s5,s5,-740 # 80009288 <digits+0x248>
    printf("\n");
    80002574:	00007a17          	auipc	s4,0x7
    80002578:	5a4a0a13          	addi	s4,s4,1444 # 80009b18 <syscalls+0x6c8>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000257c:	00007b97          	auipc	s7,0x7
    80002580:	d4cb8b93          	addi	s7,s7,-692 # 800092c8 <states.0>
    80002584:	a00d                	j	800025a6 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002586:	ed86a583          	lw	a1,-296(a3)
    8000258a:	8556                	mv	a0,s5
    8000258c:	ffffe097          	auipc	ra,0xffffe
    80002590:	ffe080e7          	jalr	-2(ra) # 8000058a <printf>
    printf("\n");
    80002594:	8552                	mv	a0,s4
    80002596:	ffffe097          	auipc	ra,0xffffe
    8000259a:	ff4080e7          	jalr	-12(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000259e:	18048493          	addi	s1,s1,384
    800025a2:	03248263          	beq	s1,s2,800025c6 <procdump+0x9a>
    if(p->state == UNUSED)
    800025a6:	86a6                	mv	a3,s1
    800025a8:	ec04a783          	lw	a5,-320(s1)
    800025ac:	dbed                	beqz	a5,8000259e <procdump+0x72>
      state = "???";
    800025ae:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025b0:	fcfb6be3          	bltu	s6,a5,80002586 <procdump+0x5a>
    800025b4:	02079713          	slli	a4,a5,0x20
    800025b8:	01d75793          	srli	a5,a4,0x1d
    800025bc:	97de                	add	a5,a5,s7
    800025be:	6390                	ld	a2,0(a5)
    800025c0:	f279                	bnez	a2,80002586 <procdump+0x5a>
      state = "???";
    800025c2:	864e                	mv	a2,s3
    800025c4:	b7c9                	j	80002586 <procdump+0x5a>
  }
}
    800025c6:	60a6                	ld	ra,72(sp)
    800025c8:	6406                	ld	s0,64(sp)
    800025ca:	74e2                	ld	s1,56(sp)
    800025cc:	7942                	ld	s2,48(sp)
    800025ce:	79a2                	ld	s3,40(sp)
    800025d0:	7a02                	ld	s4,32(sp)
    800025d2:	6ae2                	ld	s5,24(sp)
    800025d4:	6b42                	ld	s6,16(sp)
    800025d6:	6ba2                	ld	s7,8(sp)
    800025d8:	6161                	addi	sp,sp,80
    800025da:	8082                	ret

00000000800025dc <swtch>:
    800025dc:	00153023          	sd	ra,0(a0)
    800025e0:	00253423          	sd	sp,8(a0)
    800025e4:	e900                	sd	s0,16(a0)
    800025e6:	ed04                	sd	s1,24(a0)
    800025e8:	03253023          	sd	s2,32(a0)
    800025ec:	03353423          	sd	s3,40(a0)
    800025f0:	03453823          	sd	s4,48(a0)
    800025f4:	03553c23          	sd	s5,56(a0)
    800025f8:	05653023          	sd	s6,64(a0)
    800025fc:	05753423          	sd	s7,72(a0)
    80002600:	05853823          	sd	s8,80(a0)
    80002604:	05953c23          	sd	s9,88(a0)
    80002608:	07a53023          	sd	s10,96(a0)
    8000260c:	07b53423          	sd	s11,104(a0)
    80002610:	0005b083          	ld	ra,0(a1)
    80002614:	0085b103          	ld	sp,8(a1)
    80002618:	6980                	ld	s0,16(a1)
    8000261a:	6d84                	ld	s1,24(a1)
    8000261c:	0205b903          	ld	s2,32(a1)
    80002620:	0285b983          	ld	s3,40(a1)
    80002624:	0305ba03          	ld	s4,48(a1)
    80002628:	0385ba83          	ld	s5,56(a1)
    8000262c:	0405bb03          	ld	s6,64(a1)
    80002630:	0485bb83          	ld	s7,72(a1)
    80002634:	0505bc03          	ld	s8,80(a1)
    80002638:	0585bc83          	ld	s9,88(a1)
    8000263c:	0605bd03          	ld	s10,96(a1)
    80002640:	0685bd83          	ld	s11,104(a1)
    80002644:	8082                	ret

0000000080002646 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002646:	1141                	addi	sp,sp,-16
    80002648:	e406                	sd	ra,8(sp)
    8000264a:	e022                	sd	s0,0(sp)
    8000264c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000264e:	00007597          	auipc	a1,0x7
    80002652:	caa58593          	addi	a1,a1,-854 # 800092f8 <states.0+0x30>
    80002656:	00016517          	auipc	a0,0x16
    8000265a:	c0a50513          	addi	a0,a0,-1014 # 80018260 <tickslock>
    8000265e:	ffffe097          	auipc	ra,0xffffe
    80002662:	4e8080e7          	jalr	1256(ra) # 80000b46 <initlock>
}
    80002666:	60a2                	ld	ra,8(sp)
    80002668:	6402                	ld	s0,0(sp)
    8000266a:	0141                	addi	sp,sp,16
    8000266c:	8082                	ret

000000008000266e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000266e:	1141                	addi	sp,sp,-16
    80002670:	e422                	sd	s0,8(sp)
    80002672:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002674:	00004797          	auipc	a5,0x4
    80002678:	92c78793          	addi	a5,a5,-1748 # 80005fa0 <kernelvec>
    8000267c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002680:	6422                	ld	s0,8(sp)
    80002682:	0141                	addi	sp,sp,16
    80002684:	8082                	ret

0000000080002686 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002686:	1141                	addi	sp,sp,-16
    80002688:	e406                	sd	ra,8(sp)
    8000268a:	e022                	sd	s0,0(sp)
    8000268c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000268e:	fffff097          	auipc	ra,0xfffff
    80002692:	31e080e7          	jalr	798(ra) # 800019ac <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002696:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000269a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000269c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800026a0:	00006697          	auipc	a3,0x6
    800026a4:	96068693          	addi	a3,a3,-1696 # 80008000 <_trampoline>
    800026a8:	00006717          	auipc	a4,0x6
    800026ac:	95870713          	addi	a4,a4,-1704 # 80008000 <_trampoline>
    800026b0:	8f15                	sub	a4,a4,a3
    800026b2:	040007b7          	lui	a5,0x4000
    800026b6:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800026b8:	07b2                	slli	a5,a5,0xc
    800026ba:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026bc:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800026c0:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800026c2:	18002673          	csrr	a2,satp
    800026c6:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800026c8:	6d30                	ld	a2,88(a0)
    800026ca:	6138                	ld	a4,64(a0)
    800026cc:	6585                	lui	a1,0x1
    800026ce:	972e                	add	a4,a4,a1
    800026d0:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800026d2:	6d38                	ld	a4,88(a0)
    800026d4:	00000617          	auipc	a2,0x0
    800026d8:	13060613          	addi	a2,a2,304 # 80002804 <usertrap>
    800026dc:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800026de:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800026e0:	8612                	mv	a2,tp
    800026e2:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026e4:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800026e8:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800026ec:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026f0:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800026f4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026f6:	6f18                	ld	a4,24(a4)
    800026f8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800026fc:	6928                	ld	a0,80(a0)
    800026fe:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002700:	00006717          	auipc	a4,0x6
    80002704:	99c70713          	addi	a4,a4,-1636 # 8000809c <userret>
    80002708:	8f15                	sub	a4,a4,a3
    8000270a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000270c:	577d                	li	a4,-1
    8000270e:	177e                	slli	a4,a4,0x3f
    80002710:	8d59                	or	a0,a0,a4
    80002712:	9782                	jalr	a5
}
    80002714:	60a2                	ld	ra,8(sp)
    80002716:	6402                	ld	s0,0(sp)
    80002718:	0141                	addi	sp,sp,16
    8000271a:	8082                	ret

000000008000271c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000271c:	1101                	addi	sp,sp,-32
    8000271e:	ec06                	sd	ra,24(sp)
    80002720:	e822                	sd	s0,16(sp)
    80002722:	e426                	sd	s1,8(sp)
    80002724:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002726:	00016497          	auipc	s1,0x16
    8000272a:	b3a48493          	addi	s1,s1,-1222 # 80018260 <tickslock>
    8000272e:	8526                	mv	a0,s1
    80002730:	ffffe097          	auipc	ra,0xffffe
    80002734:	4a6080e7          	jalr	1190(ra) # 80000bd6 <acquire>
  ticks++;
    80002738:	00007517          	auipc	a0,0x7
    8000273c:	48850513          	addi	a0,a0,1160 # 80009bc0 <ticks>
    80002740:	411c                	lw	a5,0(a0)
    80002742:	2785                	addiw	a5,a5,1
    80002744:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002746:	00000097          	auipc	ra,0x0
    8000274a:	97e080e7          	jalr	-1666(ra) # 800020c4 <wakeup>
  release(&tickslock);
    8000274e:	8526                	mv	a0,s1
    80002750:	ffffe097          	auipc	ra,0xffffe
    80002754:	53a080e7          	jalr	1338(ra) # 80000c8a <release>
}
    80002758:	60e2                	ld	ra,24(sp)
    8000275a:	6442                	ld	s0,16(sp)
    8000275c:	64a2                	ld	s1,8(sp)
    8000275e:	6105                	addi	sp,sp,32
    80002760:	8082                	ret

0000000080002762 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002762:	1101                	addi	sp,sp,-32
    80002764:	ec06                	sd	ra,24(sp)
    80002766:	e822                	sd	s0,16(sp)
    80002768:	e426                	sd	s1,8(sp)
    8000276a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000276c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002770:	00074d63          	bltz	a4,8000278a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002774:	57fd                	li	a5,-1
    80002776:	17fe                	slli	a5,a5,0x3f
    80002778:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    8000277a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000277c:	06f70363          	beq	a4,a5,800027e2 <devintr+0x80>
  }
}
    80002780:	60e2                	ld	ra,24(sp)
    80002782:	6442                	ld	s0,16(sp)
    80002784:	64a2                	ld	s1,8(sp)
    80002786:	6105                	addi	sp,sp,32
    80002788:	8082                	ret
     (scause & 0xff) == 9){
    8000278a:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    8000278e:	46a5                	li	a3,9
    80002790:	fed792e3          	bne	a5,a3,80002774 <devintr+0x12>
    int irq = plic_claim();
    80002794:	00004097          	auipc	ra,0x4
    80002798:	914080e7          	jalr	-1772(ra) # 800060a8 <plic_claim>
    8000279c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000279e:	47a9                	li	a5,10
    800027a0:	02f50763          	beq	a0,a5,800027ce <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    800027a4:	4785                	li	a5,1
    800027a6:	02f50963          	beq	a0,a5,800027d8 <devintr+0x76>
    return 1;
    800027aa:	4505                	li	a0,1
    } else if(irq){
    800027ac:	d8f1                	beqz	s1,80002780 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    800027ae:	85a6                	mv	a1,s1
    800027b0:	00007517          	auipc	a0,0x7
    800027b4:	b5050513          	addi	a0,a0,-1200 # 80009300 <states.0+0x38>
    800027b8:	ffffe097          	auipc	ra,0xffffe
    800027bc:	dd2080e7          	jalr	-558(ra) # 8000058a <printf>
      plic_complete(irq);
    800027c0:	8526                	mv	a0,s1
    800027c2:	00004097          	auipc	ra,0x4
    800027c6:	90a080e7          	jalr	-1782(ra) # 800060cc <plic_complete>
    return 1;
    800027ca:	4505                	li	a0,1
    800027cc:	bf55                	j	80002780 <devintr+0x1e>
      uartintr();
    800027ce:	ffffe097          	auipc	ra,0xffffe
    800027d2:	1ca080e7          	jalr	458(ra) # 80000998 <uartintr>
    800027d6:	b7ed                	j	800027c0 <devintr+0x5e>
      virtio_disk_intr();
    800027d8:	00004097          	auipc	ra,0x4
    800027dc:	dbc080e7          	jalr	-580(ra) # 80006594 <virtio_disk_intr>
    800027e0:	b7c5                	j	800027c0 <devintr+0x5e>
    if(cpuid() == 0){
    800027e2:	fffff097          	auipc	ra,0xfffff
    800027e6:	19e080e7          	jalr	414(ra) # 80001980 <cpuid>
    800027ea:	c901                	beqz	a0,800027fa <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800027ec:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800027f0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800027f2:	14479073          	csrw	sip,a5
    return 2;
    800027f6:	4509                	li	a0,2
    800027f8:	b761                	j	80002780 <devintr+0x1e>
      clockintr();
    800027fa:	00000097          	auipc	ra,0x0
    800027fe:	f22080e7          	jalr	-222(ra) # 8000271c <clockintr>
    80002802:	b7ed                	j	800027ec <devintr+0x8a>

0000000080002804 <usertrap>:
{
    80002804:	1101                	addi	sp,sp,-32
    80002806:	ec06                	sd	ra,24(sp)
    80002808:	e822                	sd	s0,16(sp)
    8000280a:	e426                	sd	s1,8(sp)
    8000280c:	e04a                	sd	s2,0(sp)
    8000280e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002810:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002814:	1007f793          	andi	a5,a5,256
    80002818:	e3b1                	bnez	a5,8000285c <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000281a:	00003797          	auipc	a5,0x3
    8000281e:	78678793          	addi	a5,a5,1926 # 80005fa0 <kernelvec>
    80002822:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002826:	fffff097          	auipc	ra,0xfffff
    8000282a:	186080e7          	jalr	390(ra) # 800019ac <myproc>
    8000282e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002830:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002832:	14102773          	csrr	a4,sepc
    80002836:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002838:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000283c:	47a1                	li	a5,8
    8000283e:	02f70763          	beq	a4,a5,8000286c <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80002842:	00000097          	auipc	ra,0x0
    80002846:	f20080e7          	jalr	-224(ra) # 80002762 <devintr>
    8000284a:	892a                	mv	s2,a0
    8000284c:	c151                	beqz	a0,800028d0 <usertrap+0xcc>
  if(killed(p))
    8000284e:	8526                	mv	a0,s1
    80002850:	00000097          	auipc	ra,0x0
    80002854:	ad0080e7          	jalr	-1328(ra) # 80002320 <killed>
    80002858:	c929                	beqz	a0,800028aa <usertrap+0xa6>
    8000285a:	a099                	j	800028a0 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    8000285c:	00007517          	auipc	a0,0x7
    80002860:	ac450513          	addi	a0,a0,-1340 # 80009320 <states.0+0x58>
    80002864:	ffffe097          	auipc	ra,0xffffe
    80002868:	cdc080e7          	jalr	-804(ra) # 80000540 <panic>
    if(killed(p))
    8000286c:	00000097          	auipc	ra,0x0
    80002870:	ab4080e7          	jalr	-1356(ra) # 80002320 <killed>
    80002874:	e921                	bnez	a0,800028c4 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80002876:	6cb8                	ld	a4,88(s1)
    80002878:	6f1c                	ld	a5,24(a4)
    8000287a:	0791                	addi	a5,a5,4
    8000287c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000287e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002882:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002886:	10079073          	csrw	sstatus,a5
    syscall();
    8000288a:	00000097          	auipc	ra,0x0
    8000288e:	2d4080e7          	jalr	724(ra) # 80002b5e <syscall>
  if(killed(p))
    80002892:	8526                	mv	a0,s1
    80002894:	00000097          	auipc	ra,0x0
    80002898:	a8c080e7          	jalr	-1396(ra) # 80002320 <killed>
    8000289c:	c911                	beqz	a0,800028b0 <usertrap+0xac>
    8000289e:	4901                	li	s2,0
    exit(-1);
    800028a0:	557d                	li	a0,-1
    800028a2:	00000097          	auipc	ra,0x0
    800028a6:	8f2080e7          	jalr	-1806(ra) # 80002194 <exit>
  if(which_dev == 2)
    800028aa:	4789                	li	a5,2
    800028ac:	04f90f63          	beq	s2,a5,8000290a <usertrap+0x106>
  usertrapret();
    800028b0:	00000097          	auipc	ra,0x0
    800028b4:	dd6080e7          	jalr	-554(ra) # 80002686 <usertrapret>
}
    800028b8:	60e2                	ld	ra,24(sp)
    800028ba:	6442                	ld	s0,16(sp)
    800028bc:	64a2                	ld	s1,8(sp)
    800028be:	6902                	ld	s2,0(sp)
    800028c0:	6105                	addi	sp,sp,32
    800028c2:	8082                	ret
      exit(-1);
    800028c4:	557d                	li	a0,-1
    800028c6:	00000097          	auipc	ra,0x0
    800028ca:	8ce080e7          	jalr	-1842(ra) # 80002194 <exit>
    800028ce:	b765                	j	80002876 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028d0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800028d4:	5890                	lw	a2,48(s1)
    800028d6:	00007517          	auipc	a0,0x7
    800028da:	a6a50513          	addi	a0,a0,-1430 # 80009340 <states.0+0x78>
    800028de:	ffffe097          	auipc	ra,0xffffe
    800028e2:	cac080e7          	jalr	-852(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028e6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800028ea:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800028ee:	00007517          	auipc	a0,0x7
    800028f2:	a8250513          	addi	a0,a0,-1406 # 80009370 <states.0+0xa8>
    800028f6:	ffffe097          	auipc	ra,0xffffe
    800028fa:	c94080e7          	jalr	-876(ra) # 8000058a <printf>
    setkilled(p);
    800028fe:	8526                	mv	a0,s1
    80002900:	00000097          	auipc	ra,0x0
    80002904:	9f4080e7          	jalr	-1548(ra) # 800022f4 <setkilled>
    80002908:	b769                	j	80002892 <usertrap+0x8e>
    yield();
    8000290a:	fffff097          	auipc	ra,0xfffff
    8000290e:	71a080e7          	jalr	1818(ra) # 80002024 <yield>
    80002912:	bf79                	j	800028b0 <usertrap+0xac>

0000000080002914 <kerneltrap>:
{
    80002914:	7179                	addi	sp,sp,-48
    80002916:	f406                	sd	ra,40(sp)
    80002918:	f022                	sd	s0,32(sp)
    8000291a:	ec26                	sd	s1,24(sp)
    8000291c:	e84a                	sd	s2,16(sp)
    8000291e:	e44e                	sd	s3,8(sp)
    80002920:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002922:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002926:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000292a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000292e:	1004f793          	andi	a5,s1,256
    80002932:	cb85                	beqz	a5,80002962 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002934:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002938:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000293a:	ef85                	bnez	a5,80002972 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	e26080e7          	jalr	-474(ra) # 80002762 <devintr>
    80002944:	cd1d                	beqz	a0,80002982 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002946:	4789                	li	a5,2
    80002948:	06f50a63          	beq	a0,a5,800029bc <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000294c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002950:	10049073          	csrw	sstatus,s1
}
    80002954:	70a2                	ld	ra,40(sp)
    80002956:	7402                	ld	s0,32(sp)
    80002958:	64e2                	ld	s1,24(sp)
    8000295a:	6942                	ld	s2,16(sp)
    8000295c:	69a2                	ld	s3,8(sp)
    8000295e:	6145                	addi	sp,sp,48
    80002960:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002962:	00007517          	auipc	a0,0x7
    80002966:	a2e50513          	addi	a0,a0,-1490 # 80009390 <states.0+0xc8>
    8000296a:	ffffe097          	auipc	ra,0xffffe
    8000296e:	bd6080e7          	jalr	-1066(ra) # 80000540 <panic>
    panic("kerneltrap: interrupts enabled");
    80002972:	00007517          	auipc	a0,0x7
    80002976:	a4650513          	addi	a0,a0,-1466 # 800093b8 <states.0+0xf0>
    8000297a:	ffffe097          	auipc	ra,0xffffe
    8000297e:	bc6080e7          	jalr	-1082(ra) # 80000540 <panic>
    printf("scause %p\n", scause);
    80002982:	85ce                	mv	a1,s3
    80002984:	00007517          	auipc	a0,0x7
    80002988:	a5450513          	addi	a0,a0,-1452 # 800093d8 <states.0+0x110>
    8000298c:	ffffe097          	auipc	ra,0xffffe
    80002990:	bfe080e7          	jalr	-1026(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002994:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002998:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000299c:	00007517          	auipc	a0,0x7
    800029a0:	a4c50513          	addi	a0,a0,-1460 # 800093e8 <states.0+0x120>
    800029a4:	ffffe097          	auipc	ra,0xffffe
    800029a8:	be6080e7          	jalr	-1050(ra) # 8000058a <printf>
    panic("kerneltrap");
    800029ac:	00007517          	auipc	a0,0x7
    800029b0:	a5450513          	addi	a0,a0,-1452 # 80009400 <states.0+0x138>
    800029b4:	ffffe097          	auipc	ra,0xffffe
    800029b8:	b8c080e7          	jalr	-1140(ra) # 80000540 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800029bc:	fffff097          	auipc	ra,0xfffff
    800029c0:	ff0080e7          	jalr	-16(ra) # 800019ac <myproc>
    800029c4:	d541                	beqz	a0,8000294c <kerneltrap+0x38>
    800029c6:	fffff097          	auipc	ra,0xfffff
    800029ca:	fe6080e7          	jalr	-26(ra) # 800019ac <myproc>
    800029ce:	4d18                	lw	a4,24(a0)
    800029d0:	4791                	li	a5,4
    800029d2:	f6f71de3          	bne	a4,a5,8000294c <kerneltrap+0x38>
    yield();
    800029d6:	fffff097          	auipc	ra,0xfffff
    800029da:	64e080e7          	jalr	1614(ra) # 80002024 <yield>
    800029de:	b7bd                	j	8000294c <kerneltrap+0x38>

00000000800029e0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800029e0:	1101                	addi	sp,sp,-32
    800029e2:	ec06                	sd	ra,24(sp)
    800029e4:	e822                	sd	s0,16(sp)
    800029e6:	e426                	sd	s1,8(sp)
    800029e8:	1000                	addi	s0,sp,32
    800029ea:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800029ec:	fffff097          	auipc	ra,0xfffff
    800029f0:	fc0080e7          	jalr	-64(ra) # 800019ac <myproc>
  switch (n) {
    800029f4:	4795                	li	a5,5
    800029f6:	0497e163          	bltu	a5,s1,80002a38 <argraw+0x58>
    800029fa:	048a                	slli	s1,s1,0x2
    800029fc:	00007717          	auipc	a4,0x7
    80002a00:	a3c70713          	addi	a4,a4,-1476 # 80009438 <states.0+0x170>
    80002a04:	94ba                	add	s1,s1,a4
    80002a06:	409c                	lw	a5,0(s1)
    80002a08:	97ba                	add	a5,a5,a4
    80002a0a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002a0c:	6d3c                	ld	a5,88(a0)
    80002a0e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002a10:	60e2                	ld	ra,24(sp)
    80002a12:	6442                	ld	s0,16(sp)
    80002a14:	64a2                	ld	s1,8(sp)
    80002a16:	6105                	addi	sp,sp,32
    80002a18:	8082                	ret
    return p->trapframe->a1;
    80002a1a:	6d3c                	ld	a5,88(a0)
    80002a1c:	7fa8                	ld	a0,120(a5)
    80002a1e:	bfcd                	j	80002a10 <argraw+0x30>
    return p->trapframe->a2;
    80002a20:	6d3c                	ld	a5,88(a0)
    80002a22:	63c8                	ld	a0,128(a5)
    80002a24:	b7f5                	j	80002a10 <argraw+0x30>
    return p->trapframe->a3;
    80002a26:	6d3c                	ld	a5,88(a0)
    80002a28:	67c8                	ld	a0,136(a5)
    80002a2a:	b7dd                	j	80002a10 <argraw+0x30>
    return p->trapframe->a4;
    80002a2c:	6d3c                	ld	a5,88(a0)
    80002a2e:	6bc8                	ld	a0,144(a5)
    80002a30:	b7c5                	j	80002a10 <argraw+0x30>
    return p->trapframe->a5;
    80002a32:	6d3c                	ld	a5,88(a0)
    80002a34:	6fc8                	ld	a0,152(a5)
    80002a36:	bfe9                	j	80002a10 <argraw+0x30>
  panic("argraw");
    80002a38:	00007517          	auipc	a0,0x7
    80002a3c:	9d850513          	addi	a0,a0,-1576 # 80009410 <states.0+0x148>
    80002a40:	ffffe097          	auipc	ra,0xffffe
    80002a44:	b00080e7          	jalr	-1280(ra) # 80000540 <panic>

0000000080002a48 <fetchaddr>:
{
    80002a48:	1101                	addi	sp,sp,-32
    80002a4a:	ec06                	sd	ra,24(sp)
    80002a4c:	e822                	sd	s0,16(sp)
    80002a4e:	e426                	sd	s1,8(sp)
    80002a50:	e04a                	sd	s2,0(sp)
    80002a52:	1000                	addi	s0,sp,32
    80002a54:	84aa                	mv	s1,a0
    80002a56:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002a58:	fffff097          	auipc	ra,0xfffff
    80002a5c:	f54080e7          	jalr	-172(ra) # 800019ac <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002a60:	653c                	ld	a5,72(a0)
    80002a62:	02f4f863          	bgeu	s1,a5,80002a92 <fetchaddr+0x4a>
    80002a66:	00848713          	addi	a4,s1,8
    80002a6a:	02e7e663          	bltu	a5,a4,80002a96 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a6e:	46a1                	li	a3,8
    80002a70:	8626                	mv	a2,s1
    80002a72:	85ca                	mv	a1,s2
    80002a74:	6928                	ld	a0,80(a0)
    80002a76:	fffff097          	auipc	ra,0xfffff
    80002a7a:	c82080e7          	jalr	-894(ra) # 800016f8 <copyin>
    80002a7e:	00a03533          	snez	a0,a0
    80002a82:	40a00533          	neg	a0,a0
}
    80002a86:	60e2                	ld	ra,24(sp)
    80002a88:	6442                	ld	s0,16(sp)
    80002a8a:	64a2                	ld	s1,8(sp)
    80002a8c:	6902                	ld	s2,0(sp)
    80002a8e:	6105                	addi	sp,sp,32
    80002a90:	8082                	ret
    return -1;
    80002a92:	557d                	li	a0,-1
    80002a94:	bfcd                	j	80002a86 <fetchaddr+0x3e>
    80002a96:	557d                	li	a0,-1
    80002a98:	b7fd                	j	80002a86 <fetchaddr+0x3e>

0000000080002a9a <fetchstr>:
{
    80002a9a:	7179                	addi	sp,sp,-48
    80002a9c:	f406                	sd	ra,40(sp)
    80002a9e:	f022                	sd	s0,32(sp)
    80002aa0:	ec26                	sd	s1,24(sp)
    80002aa2:	e84a                	sd	s2,16(sp)
    80002aa4:	e44e                	sd	s3,8(sp)
    80002aa6:	1800                	addi	s0,sp,48
    80002aa8:	892a                	mv	s2,a0
    80002aaa:	84ae                	mv	s1,a1
    80002aac:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002aae:	fffff097          	auipc	ra,0xfffff
    80002ab2:	efe080e7          	jalr	-258(ra) # 800019ac <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002ab6:	86ce                	mv	a3,s3
    80002ab8:	864a                	mv	a2,s2
    80002aba:	85a6                	mv	a1,s1
    80002abc:	6928                	ld	a0,80(a0)
    80002abe:	fffff097          	auipc	ra,0xfffff
    80002ac2:	cc8080e7          	jalr	-824(ra) # 80001786 <copyinstr>
    80002ac6:	00054e63          	bltz	a0,80002ae2 <fetchstr+0x48>
  return strlen(buf);
    80002aca:	8526                	mv	a0,s1
    80002acc:	ffffe097          	auipc	ra,0xffffe
    80002ad0:	382080e7          	jalr	898(ra) # 80000e4e <strlen>
}
    80002ad4:	70a2                	ld	ra,40(sp)
    80002ad6:	7402                	ld	s0,32(sp)
    80002ad8:	64e2                	ld	s1,24(sp)
    80002ada:	6942                	ld	s2,16(sp)
    80002adc:	69a2                	ld	s3,8(sp)
    80002ade:	6145                	addi	sp,sp,48
    80002ae0:	8082                	ret
    return -1;
    80002ae2:	557d                	li	a0,-1
    80002ae4:	bfc5                	j	80002ad4 <fetchstr+0x3a>

0000000080002ae6 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002ae6:	1101                	addi	sp,sp,-32
    80002ae8:	ec06                	sd	ra,24(sp)
    80002aea:	e822                	sd	s0,16(sp)
    80002aec:	e426                	sd	s1,8(sp)
    80002aee:	1000                	addi	s0,sp,32
    80002af0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002af2:	00000097          	auipc	ra,0x0
    80002af6:	eee080e7          	jalr	-274(ra) # 800029e0 <argraw>
    80002afa:	c088                	sw	a0,0(s1)
}
    80002afc:	60e2                	ld	ra,24(sp)
    80002afe:	6442                	ld	s0,16(sp)
    80002b00:	64a2                	ld	s1,8(sp)
    80002b02:	6105                	addi	sp,sp,32
    80002b04:	8082                	ret

0000000080002b06 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002b06:	1101                	addi	sp,sp,-32
    80002b08:	ec06                	sd	ra,24(sp)
    80002b0a:	e822                	sd	s0,16(sp)
    80002b0c:	e426                	sd	s1,8(sp)
    80002b0e:	1000                	addi	s0,sp,32
    80002b10:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b12:	00000097          	auipc	ra,0x0
    80002b16:	ece080e7          	jalr	-306(ra) # 800029e0 <argraw>
    80002b1a:	e088                	sd	a0,0(s1)
}
    80002b1c:	60e2                	ld	ra,24(sp)
    80002b1e:	6442                	ld	s0,16(sp)
    80002b20:	64a2                	ld	s1,8(sp)
    80002b22:	6105                	addi	sp,sp,32
    80002b24:	8082                	ret

0000000080002b26 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b26:	7179                	addi	sp,sp,-48
    80002b28:	f406                	sd	ra,40(sp)
    80002b2a:	f022                	sd	s0,32(sp)
    80002b2c:	ec26                	sd	s1,24(sp)
    80002b2e:	e84a                	sd	s2,16(sp)
    80002b30:	1800                	addi	s0,sp,48
    80002b32:	84ae                	mv	s1,a1
    80002b34:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002b36:	fd840593          	addi	a1,s0,-40
    80002b3a:	00000097          	auipc	ra,0x0
    80002b3e:	fcc080e7          	jalr	-52(ra) # 80002b06 <argaddr>
  return fetchstr(addr, buf, max);
    80002b42:	864a                	mv	a2,s2
    80002b44:	85a6                	mv	a1,s1
    80002b46:	fd843503          	ld	a0,-40(s0)
    80002b4a:	00000097          	auipc	ra,0x0
    80002b4e:	f50080e7          	jalr	-176(ra) # 80002a9a <fetchstr>
}
    80002b52:	70a2                	ld	ra,40(sp)
    80002b54:	7402                	ld	s0,32(sp)
    80002b56:	64e2                	ld	s1,24(sp)
    80002b58:	6942                	ld	s2,16(sp)
    80002b5a:	6145                	addi	sp,sp,48
    80002b5c:	8082                	ret

0000000080002b5e <syscall>:
[SYS_gettime]    sys_gettime
};

void
syscall(void)
{
    80002b5e:	1101                	addi	sp,sp,-32
    80002b60:	ec06                	sd	ra,24(sp)
    80002b62:	e822                	sd	s0,16(sp)
    80002b64:	e426                	sd	s1,8(sp)
    80002b66:	e04a                	sd	s2,0(sp)
    80002b68:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b6a:	fffff097          	auipc	ra,0xfffff
    80002b6e:	e42080e7          	jalr	-446(ra) # 800019ac <myproc>
    80002b72:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b74:	05853903          	ld	s2,88(a0)
    80002b78:	0a893783          	ld	a5,168(s2)
    80002b7c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b80:	37fd                	addiw	a5,a5,-1
    80002b82:	4765                	li	a4,25
    80002b84:	00f76f63          	bltu	a4,a5,80002ba2 <syscall+0x44>
    80002b88:	00369713          	slli	a4,a3,0x3
    80002b8c:	00007797          	auipc	a5,0x7
    80002b90:	8c478793          	addi	a5,a5,-1852 # 80009450 <syscalls>
    80002b94:	97ba                	add	a5,a5,a4
    80002b96:	639c                	ld	a5,0(a5)
    80002b98:	c789                	beqz	a5,80002ba2 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002b9a:	9782                	jalr	a5
    80002b9c:	06a93823          	sd	a0,112(s2)
    80002ba0:	a839                	j	80002bbe <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002ba2:	15848613          	addi	a2,s1,344
    80002ba6:	588c                	lw	a1,48(s1)
    80002ba8:	00007517          	auipc	a0,0x7
    80002bac:	87050513          	addi	a0,a0,-1936 # 80009418 <states.0+0x150>
    80002bb0:	ffffe097          	auipc	ra,0xffffe
    80002bb4:	9da080e7          	jalr	-1574(ra) # 8000058a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002bb8:	6cbc                	ld	a5,88(s1)
    80002bba:	577d                	li	a4,-1
    80002bbc:	fbb8                	sd	a4,112(a5)
  }
}
    80002bbe:	60e2                	ld	ra,24(sp)
    80002bc0:	6442                	ld	s0,16(sp)
    80002bc2:	64a2                	ld	s1,8(sp)
    80002bc4:	6902                	ld	s2,0(sp)
    80002bc6:	6105                	addi	sp,sp,32
    80002bc8:	8082                	ret

0000000080002bca <sys_times>:

It returns the timing information for the process with process id of pid as the e_time_t structure into
time variable.

*/
uint64 sys_times(void){
    80002bca:	1101                	addi	sp,sp,-32
    80002bcc:	ec06                	sd	ra,24(sp)
    80002bce:	e822                	sd	s0,16(sp)
    80002bd0:	1000                	addi	s0,sp,32

  uint32 pid;
  uint64 timeStructAddress;
  argint(0, &pid);
    80002bd2:	fec40593          	addi	a1,s0,-20
    80002bd6:	4501                	li	a0,0
    80002bd8:	00000097          	auipc	ra,0x0
    80002bdc:	f0e080e7          	jalr	-242(ra) # 80002ae6 <argint>
  argaddr(1, &timeStructAddress);
    80002be0:	fe040593          	addi	a1,s0,-32
    80002be4:	4505                	li	a0,1
    80002be6:	00000097          	auipc	ra,0x0
    80002bea:	f20080e7          	jalr	-224(ra) # 80002b06 <argaddr>

  get_process_time(pid,timeStructAddress,0);
    80002bee:	4601                	li	a2,0
    80002bf0:	fe043583          	ld	a1,-32(s0)
    80002bf4:	fec42503          	lw	a0,-20(s0)
    80002bf8:	00004097          	auipc	ra,0x4
    80002bfc:	6aa080e7          	jalr	1706(ra) # 800072a2 <get_process_time>
  
  return 0;
}
    80002c00:	4501                	li	a0,0
    80002c02:	60e2                	ld	ra,24(sp)
    80002c04:	6442                	ld	s0,16(sp)
    80002c06:	6105                	addi	sp,sp,32
    80002c08:	8082                	ret

0000000080002c0a <sys_ps>:

  
  ps(int pid, int ppid, int status, char * pName);
  
*/
uint64 sys_ps(void){
    80002c0a:	7179                	addi	sp,sp,-48
    80002c0c:	f406                	sd	ra,40(sp)
    80002c0e:	f022                	sd	s0,32(sp)
    80002c10:	1800                	addi	s0,sp,48
  uint32 pid;
  uint32 ppid;
  uint32 status;
  uint64 pName;

  argint(0, &pid);
    80002c12:	fec40593          	addi	a1,s0,-20
    80002c16:	4501                	li	a0,0
    80002c18:	00000097          	auipc	ra,0x0
    80002c1c:	ece080e7          	jalr	-306(ra) # 80002ae6 <argint>
  argint(1, &ppid);
    80002c20:	fe840593          	addi	a1,s0,-24
    80002c24:	4505                	li	a0,1
    80002c26:	00000097          	auipc	ra,0x0
    80002c2a:	ec0080e7          	jalr	-320(ra) # 80002ae6 <argint>
  argint(2, &status);
    80002c2e:	fe440593          	addi	a1,s0,-28
    80002c32:	4509                	li	a0,2
    80002c34:	00000097          	auipc	ra,0x0
    80002c38:	eb2080e7          	jalr	-334(ra) # 80002ae6 <argint>
  argaddr(3, &pName);
    80002c3c:	fd840593          	addi	a1,s0,-40
    80002c40:	450d                	li	a0,3
    80002c42:	00000097          	auipc	ra,0x0
    80002c46:	ec4080e7          	jalr	-316(ra) # 80002b06 <argaddr>

  get_process_status(pid, ppid, status, pName);
    80002c4a:	fd843683          	ld	a3,-40(s0)
    80002c4e:	fe442603          	lw	a2,-28(s0)
    80002c52:	fe842583          	lw	a1,-24(s0)
    80002c56:	fec42503          	lw	a0,-20(s0)
    80002c5a:	00004097          	auipc	ra,0x4
    80002c5e:	13a080e7          	jalr	314(ra) # 80006d94 <get_process_status>

  return 0;
}
    80002c62:	4501                	li	a0,0
    80002c64:	70a2                	ld	ra,40(sp)
    80002c66:	7402                	ld	s0,32(sp)
    80002c68:	6145                	addi	sp,sp,48
    80002c6a:	8082                	ret

0000000080002c6c <sys_head>:

  
  head(char ** files , int numOfLines);
  
*/
uint64 sys_head(void){
    80002c6c:	7131                	addi	sp,sp,-192
    80002c6e:	fd06                	sd	ra,184(sp)
    80002c70:	f922                	sd	s0,176(sp)
    80002c72:	f526                	sd	s1,168(sp)
    80002c74:	f14a                	sd	s2,160(sp)
    80002c76:	ed4e                	sd	s3,152(sp)
    80002c78:	e952                	sd	s4,144(sp)
    80002c7a:	e556                	sd	s5,136(sp)
    80002c7c:	e15a                	sd	s6,128(sp)
    80002c7e:	0180                	addi	s0,sp,192

  printf("Head command is getting executed in kernel mode\n");
    80002c80:	00007517          	auipc	a0,0x7
    80002c84:	8a850513          	addi	a0,a0,-1880 # 80009528 <syscalls+0xd8>
    80002c88:	ffffe097          	auipc	ra,0xffffe
    80002c8c:	902080e7          	jalr	-1790(ra) # 8000058a <printf>

  uint64 passedFiles;
  uint64 lineCount;

  /* Fetching the first and the second arguments */
  argaddr(0, &passedFiles);
    80002c90:	fb840593          	addi	a1,s0,-72
    80002c94:	4501                	li	a0,0
    80002c96:	00000097          	auipc	ra,0x0
    80002c9a:	e70080e7          	jalr	-400(ra) # 80002b06 <argaddr>
  argint(1, &lineCount);
    80002c9e:	fb040593          	addi	a1,s0,-80
    80002ca2:	4505                	li	a0,1
    80002ca4:	00000097          	auipc	ra,0x0
    80002ca8:	e42080e7          	jalr	-446(ra) # 80002ae6 <argint>

  /* Get number of files passed as argument*/
  uint64 files = passedFiles;
    80002cac:	fb843483          	ld	s1,-72(s0)
  uint64 fileAddr;
  uint32 numOfFiles=0;
  fetchaddr(files, &fileAddr);
    80002cb0:	fa840593          	addi	a1,s0,-88
    80002cb4:	8526                	mv	a0,s1
    80002cb6:	00000097          	auipc	ra,0x0
    80002cba:	d92080e7          	jalr	-622(ra) # 80002a48 <fetchaddr>
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};
    80002cbe:	fa843783          	ld	a5,-88(s0)
    80002cc2:	c7a1                	beqz	a5,80002d0a <sys_head+0x9e>
  uint32 numOfFiles=0;
    80002cc4:	4901                	li	s2,0
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};
    80002cc6:	04a1                	addi	s1,s1,8
    80002cc8:	fa840593          	addi	a1,s0,-88
    80002ccc:	8526                	mv	a0,s1
    80002cce:	00000097          	auipc	ra,0x0
    80002cd2:	d7a080e7          	jalr	-646(ra) # 80002a48 <fetchaddr>
    80002cd6:	2905                	addiw	s2,s2,1
    80002cd8:	fa843783          	ld	a5,-88(s0)
    80002cdc:	f7ed                	bnez	a5,80002cc6 <sys_head+0x5a>


  /* Fetching the first file */
  fetchaddr(passedFiles, &fileAddr);
    80002cde:	fa840593          	addi	a1,s0,-88
    80002ce2:	fb843503          	ld	a0,-72(s0)
    80002ce6:	00000097          	auipc	ra,0x0
    80002cea:	d62080e7          	jalr	-670(ra) # 80002a48 <fetchaddr>

  /* Reading from STDIN */
  if(!fileAddr)
    80002cee:	fa843503          	ld	a0,-88(s0)
    80002cf2:	cd11                	beqz	a0,80002d0e <sys_head+0xa2>
      fetchstr(fileAddr, fileName, MAX_FILE_NAME_LEN);

      /* Open the given file */
      int fd = open_file(fileName, 0);
      
      if (fd == OPEN_FILE_ERROR)
    80002cf4:	59fd                	li	s3,-1
        printf("[ERR] opening the file '%s' failed \n",fileName);
      else{
        /* Only print the header if number of files is more than 1 */
        if (numOfFiles > 1) 
    80002cf6:	4a05                	li	s4,1
          printf("==> %s <==\n",fileName);
    80002cf8:	00007a97          	auipc	s5,0x7
    80002cfc:	890a8a93          	addi	s5,s5,-1904 # 80009588 <syscalls+0x138>
        printf("[ERR] opening the file '%s' failed \n",fileName);
    80002d00:	00007b17          	auipc	s6,0x7
    80002d04:	860b0b13          	addi	s6,s6,-1952 # 80009560 <syscalls+0x110>
    80002d08:	a095                	j	80002d6c <sys_head+0x100>
  uint32 numOfFiles=0;
    80002d0a:	4901                	li	s2,0
    80002d0c:	bfc9                	j	80002cde <sys_head+0x72>
    head_run(0, lineCount);
    80002d0e:	fb042583          	lw	a1,-80(s0)
    80002d12:	4501                	li	a0,0
    80002d14:	00004097          	auipc	ra,0x4
    80002d18:	e00080e7          	jalr	-512(ra) # 80006b14 <head_run>
      fetchaddr(passedFiles, &fileAddr);
    }

  }
  return 0;
}
    80002d1c:	4501                	li	a0,0
    80002d1e:	70ea                	ld	ra,184(sp)
    80002d20:	744a                	ld	s0,176(sp)
    80002d22:	74aa                	ld	s1,168(sp)
    80002d24:	790a                	ld	s2,160(sp)
    80002d26:	69ea                	ld	s3,152(sp)
    80002d28:	6a4a                	ld	s4,144(sp)
    80002d2a:	6aaa                	ld	s5,136(sp)
    80002d2c:	6b0a                	ld	s6,128(sp)
    80002d2e:	6129                	addi	sp,sp,192
    80002d30:	8082                	ret
        printf("[ERR] opening the file '%s' failed \n",fileName);
    80002d32:	f4040593          	addi	a1,s0,-192
    80002d36:	855a                	mv	a0,s6
    80002d38:	ffffe097          	auipc	ra,0xffffe
    80002d3c:	852080e7          	jalr	-1966(ra) # 8000058a <printf>
    80002d40:	a801                	j	80002d50 <sys_head+0xe4>
        head_run(fd , lineCount);
    80002d42:	fb042583          	lw	a1,-80(s0)
    80002d46:	8526                	mv	a0,s1
    80002d48:	00004097          	auipc	ra,0x4
    80002d4c:	dcc080e7          	jalr	-564(ra) # 80006b14 <head_run>
      passedFiles+=8;
    80002d50:	fb843503          	ld	a0,-72(s0)
    80002d54:	0521                	addi	a0,a0,8
    80002d56:	faa43c23          	sd	a0,-72(s0)
      fetchaddr(passedFiles, &fileAddr);
    80002d5a:	fa840593          	addi	a1,s0,-88
    80002d5e:	00000097          	auipc	ra,0x0
    80002d62:	cea080e7          	jalr	-790(ra) # 80002a48 <fetchaddr>
    while(fileAddr){
    80002d66:	fa843503          	ld	a0,-88(s0)
    80002d6a:	d94d                	beqz	a0,80002d1c <sys_head+0xb0>
      fetchstr(fileAddr, fileName, MAX_FILE_NAME_LEN);
    80002d6c:	06400613          	li	a2,100
    80002d70:	f4040593          	addi	a1,s0,-192
    80002d74:	00000097          	auipc	ra,0x0
    80002d78:	d26080e7          	jalr	-730(ra) # 80002a9a <fetchstr>
      int fd = open_file(fileName, 0);
    80002d7c:	4581                	li	a1,0
    80002d7e:	f4040513          	addi	a0,s0,-192
    80002d82:	00004097          	auipc	ra,0x4
    80002d86:	8c6080e7          	jalr	-1850(ra) # 80006648 <open_file>
    80002d8a:	84aa                	mv	s1,a0
      if (fd == OPEN_FILE_ERROR)
    80002d8c:	fb3503e3          	beq	a0,s3,80002d32 <sys_head+0xc6>
        if (numOfFiles > 1) 
    80002d90:	fb2a79e3          	bgeu	s4,s2,80002d42 <sys_head+0xd6>
          printf("==> %s <==\n",fileName);
    80002d94:	f4040593          	addi	a1,s0,-192
    80002d98:	8556                	mv	a0,s5
    80002d9a:	ffffd097          	auipc	ra,0xffffd
    80002d9e:	7f0080e7          	jalr	2032(ra) # 8000058a <printf>
    80002da2:	b745                	j	80002d42 <sys_head+0xd6>

0000000080002da4 <sys_uniq>:
#define OPT_SHOW_REPEATED_LINES 4




uint64 sys_uniq(void){
    80002da4:	7131                	addi	sp,sp,-192
    80002da6:	fd06                	sd	ra,184(sp)
    80002da8:	f922                	sd	s0,176(sp)
    80002daa:	f526                	sd	s1,168(sp)
    80002dac:	f14a                	sd	s2,160(sp)
    80002dae:	ed4e                	sd	s3,152(sp)
    80002db0:	e952                	sd	s4,144(sp)
    80002db2:	e556                	sd	s5,136(sp)
    80002db4:	e15a                	sd	s6,128(sp)
    80002db6:	0180                	addi	s0,sp,192

  printf("Uniq command is getting executed in kernel mode\n");
    80002db8:	00006517          	auipc	a0,0x6
    80002dbc:	7e050513          	addi	a0,a0,2016 # 80009598 <syscalls+0x148>
    80002dc0:	ffffd097          	auipc	ra,0xffffd
    80002dc4:	7ca080e7          	jalr	1994(ra) # 8000058a <printf>

  uint64 passedFiles;
  uint64 options;

  /* Fetching the first and the second arguments */
  argaddr(0, &passedFiles);
    80002dc8:	fb840593          	addi	a1,s0,-72
    80002dcc:	4501                	li	a0,0
    80002dce:	00000097          	auipc	ra,0x0
    80002dd2:	d38080e7          	jalr	-712(ra) # 80002b06 <argaddr>
  argint(1, &options);
    80002dd6:	fb040593          	addi	a1,s0,-80
    80002dda:	4505                	li	a0,1
    80002ddc:	00000097          	auipc	ra,0x0
    80002de0:	d0a080e7          	jalr	-758(ra) # 80002ae6 <argint>


  /* Get number of files passed as argument*/
  uint64 files = passedFiles;
    80002de4:	fb843483          	ld	s1,-72(s0)
  uint64 fileAddr;
  uint32 numOfFiles=0;
  fetchaddr(files, &fileAddr);
    80002de8:	fa840593          	addi	a1,s0,-88
    80002dec:	8526                	mv	a0,s1
    80002dee:	00000097          	auipc	ra,0x0
    80002df2:	c5a080e7          	jalr	-934(ra) # 80002a48 <fetchaddr>
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};
    80002df6:	fa843783          	ld	a5,-88(s0)
    80002dfa:	c7a1                	beqz	a5,80002e42 <sys_uniq+0x9e>
  uint32 numOfFiles=0;
    80002dfc:	4901                	li	s2,0
  while(fileAddr){files+=8;fetchaddr(files, &fileAddr);numOfFiles++;};
    80002dfe:	04a1                	addi	s1,s1,8
    80002e00:	fa840593          	addi	a1,s0,-88
    80002e04:	8526                	mv	a0,s1
    80002e06:	00000097          	auipc	ra,0x0
    80002e0a:	c42080e7          	jalr	-958(ra) # 80002a48 <fetchaddr>
    80002e0e:	2905                	addiw	s2,s2,1
    80002e10:	fa843783          	ld	a5,-88(s0)
    80002e14:	f7ed                	bnez	a5,80002dfe <sys_uniq+0x5a>



  /* Fetching the first file */
  fetchaddr(passedFiles, &fileAddr);
    80002e16:	fa840593          	addi	a1,s0,-88
    80002e1a:	fb843503          	ld	a0,-72(s0)
    80002e1e:	00000097          	auipc	ra,0x0
    80002e22:	c2a080e7          	jalr	-982(ra) # 80002a48 <fetchaddr>




  /* Reading from STDIN */
  if(!fileAddr)
    80002e26:	fa843503          	ld	a0,-88(s0)
    80002e2a:	cd11                	beqz	a0,80002e46 <sys_uniq+0xa2>

      // Open the given file

      int fd = open_file(fileName, 0);

      if (fd == OPEN_FILE_ERROR)
    80002e2c:	59fd                	li	s3,-1
        printf("[ERR] Error opening the file '%s' \n", fileName);
      else{
        if (numOfFiles > 1) 
    80002e2e:	4a05                	li	s4,1
          printf("==> %s <==\n",fileName);
    80002e30:	00006a97          	auipc	s5,0x6
    80002e34:	758a8a93          	addi	s5,s5,1880 # 80009588 <syscalls+0x138>
        printf("[ERR] Error opening the file '%s' \n", fileName);
    80002e38:	00006b17          	auipc	s6,0x6
    80002e3c:	798b0b13          	addi	s6,s6,1944 # 800095d0 <syscalls+0x180>
    80002e40:	a8a5                	j	80002eb8 <sys_uniq+0x114>
  uint32 numOfFiles=0;
    80002e42:	4901                	li	s2,0
    80002e44:	bfc9                	j	80002e16 <sys_uniq+0x72>
    uniq_run(0, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
    80002e46:	fb044583          	lbu	a1,-80(s0)
    80002e4a:	0045f693          	andi	a3,a1,4
    80002e4e:	0025f613          	andi	a2,a1,2
    80002e52:	8985                	andi	a1,a1,1
    80002e54:	4501                	li	a0,0
    80002e56:	00004097          	auipc	ra,0x4
    80002e5a:	d46080e7          	jalr	-698(ra) # 80006b9c <uniq_run>

    }

  }
  return 0;
}
    80002e5e:	4501                	li	a0,0
    80002e60:	70ea                	ld	ra,184(sp)
    80002e62:	744a                	ld	s0,176(sp)
    80002e64:	74aa                	ld	s1,168(sp)
    80002e66:	790a                	ld	s2,160(sp)
    80002e68:	69ea                	ld	s3,152(sp)
    80002e6a:	6a4a                	ld	s4,144(sp)
    80002e6c:	6aaa                	ld	s5,136(sp)
    80002e6e:	6b0a                	ld	s6,128(sp)
    80002e70:	6129                	addi	sp,sp,192
    80002e72:	8082                	ret
        printf("[ERR] Error opening the file '%s' \n", fileName);
    80002e74:	f4040593          	addi	a1,s0,-192
    80002e78:	855a                	mv	a0,s6
    80002e7a:	ffffd097          	auipc	ra,0xffffd
    80002e7e:	710080e7          	jalr	1808(ra) # 8000058a <printf>
    80002e82:	a829                	j	80002e9c <sys_uniq+0xf8>
        uniq_run(fd, options & OPT_IGNORE_CASE, options & OPT_SHOW_COUNT, options & OPT_SHOW_REPEATED_LINES);
    80002e84:	fb044583          	lbu	a1,-80(s0)
    80002e88:	0045f693          	andi	a3,a1,4
    80002e8c:	0025f613          	andi	a2,a1,2
    80002e90:	8985                	andi	a1,a1,1
    80002e92:	8526                	mv	a0,s1
    80002e94:	00004097          	auipc	ra,0x4
    80002e98:	d08080e7          	jalr	-760(ra) # 80006b9c <uniq_run>
      passedFiles+=8; // TODO
    80002e9c:	fb843503          	ld	a0,-72(s0)
    80002ea0:	0521                	addi	a0,a0,8
    80002ea2:	faa43c23          	sd	a0,-72(s0)
      fetchaddr(passedFiles, &fileAddr);
    80002ea6:	fa840593          	addi	a1,s0,-88
    80002eaa:	00000097          	auipc	ra,0x0
    80002eae:	b9e080e7          	jalr	-1122(ra) # 80002a48 <fetchaddr>
    while(fileAddr){
    80002eb2:	fa843503          	ld	a0,-88(s0)
    80002eb6:	d545                	beqz	a0,80002e5e <sys_uniq+0xba>
      fetchstr(fileAddr, fileName, MAX_FILE_NAME_LEN);
    80002eb8:	06400613          	li	a2,100
    80002ebc:	f4040593          	addi	a1,s0,-192
    80002ec0:	00000097          	auipc	ra,0x0
    80002ec4:	bda080e7          	jalr	-1062(ra) # 80002a9a <fetchstr>
      int fd = open_file(fileName, 0);
    80002ec8:	4581                	li	a1,0
    80002eca:	f4040513          	addi	a0,s0,-192
    80002ece:	00003097          	auipc	ra,0x3
    80002ed2:	77a080e7          	jalr	1914(ra) # 80006648 <open_file>
    80002ed6:	84aa                	mv	s1,a0
      if (fd == OPEN_FILE_ERROR)
    80002ed8:	f9350ee3          	beq	a0,s3,80002e74 <sys_uniq+0xd0>
        if (numOfFiles > 1) 
    80002edc:	fb2a74e3          	bgeu	s4,s2,80002e84 <sys_uniq+0xe0>
          printf("==> %s <==\n",fileName);
    80002ee0:	f4040593          	addi	a1,s0,-192
    80002ee4:	8556                	mv	a0,s5
    80002ee6:	ffffd097          	auipc	ra,0xffffd
    80002eea:	6a4080e7          	jalr	1700(ra) # 8000058a <printf>
    80002eee:	bf59                	j	80002e84 <sys_uniq+0xe0>

0000000080002ef0 <sys_exit>:



uint64
sys_exit(void)
{
    80002ef0:	1101                	addi	sp,sp,-32
    80002ef2:	ec06                	sd	ra,24(sp)
    80002ef4:	e822                	sd	s0,16(sp)
    80002ef6:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002ef8:	fec40593          	addi	a1,s0,-20
    80002efc:	4501                	li	a0,0
    80002efe:	00000097          	auipc	ra,0x0
    80002f02:	be8080e7          	jalr	-1048(ra) # 80002ae6 <argint>
  exit(n);
    80002f06:	fec42503          	lw	a0,-20(s0)
    80002f0a:	fffff097          	auipc	ra,0xfffff
    80002f0e:	28a080e7          	jalr	650(ra) # 80002194 <exit>
  return 0;  // not reached
}
    80002f12:	4501                	li	a0,0
    80002f14:	60e2                	ld	ra,24(sp)
    80002f16:	6442                	ld	s0,16(sp)
    80002f18:	6105                	addi	sp,sp,32
    80002f1a:	8082                	ret

0000000080002f1c <sys_getpid>:

uint64
sys_getpid(void)
{
    80002f1c:	1141                	addi	sp,sp,-16
    80002f1e:	e406                	sd	ra,8(sp)
    80002f20:	e022                	sd	s0,0(sp)
    80002f22:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002f24:	fffff097          	auipc	ra,0xfffff
    80002f28:	a88080e7          	jalr	-1400(ra) # 800019ac <myproc>
}
    80002f2c:	5908                	lw	a0,48(a0)
    80002f2e:	60a2                	ld	ra,8(sp)
    80002f30:	6402                	ld	s0,0(sp)
    80002f32:	0141                	addi	sp,sp,16
    80002f34:	8082                	ret

0000000080002f36 <sys_fork>:

uint64
sys_fork(void)
{
    80002f36:	1141                	addi	sp,sp,-16
    80002f38:	e406                	sd	ra,8(sp)
    80002f3a:	e022                	sd	s0,0(sp)
    80002f3c:	0800                	addi	s0,sp,16
  return fork();
    80002f3e:	fffff097          	auipc	ra,0xfffff
    80002f42:	e30080e7          	jalr	-464(ra) # 80001d6e <fork>
}
    80002f46:	60a2                	ld	ra,8(sp)
    80002f48:	6402                	ld	s0,0(sp)
    80002f4a:	0141                	addi	sp,sp,16
    80002f4c:	8082                	ret

0000000080002f4e <sys_wait>:

uint64
sys_wait(void)
{
    80002f4e:	1101                	addi	sp,sp,-32
    80002f50:	ec06                	sd	ra,24(sp)
    80002f52:	e822                	sd	s0,16(sp)
    80002f54:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002f56:	fe840593          	addi	a1,s0,-24
    80002f5a:	4501                	li	a0,0
    80002f5c:	00000097          	auipc	ra,0x0
    80002f60:	baa080e7          	jalr	-1110(ra) # 80002b06 <argaddr>
  return wait(p);
    80002f64:	fe843503          	ld	a0,-24(s0)
    80002f68:	fffff097          	auipc	ra,0xfffff
    80002f6c:	3ea080e7          	jalr	1002(ra) # 80002352 <wait>
}
    80002f70:	60e2                	ld	ra,24(sp)
    80002f72:	6442                	ld	s0,16(sp)
    80002f74:	6105                	addi	sp,sp,32
    80002f76:	8082                	ret

0000000080002f78 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002f78:	7179                	addi	sp,sp,-48
    80002f7a:	f406                	sd	ra,40(sp)
    80002f7c:	f022                	sd	s0,32(sp)
    80002f7e:	ec26                	sd	s1,24(sp)
    80002f80:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002f82:	fdc40593          	addi	a1,s0,-36
    80002f86:	4501                	li	a0,0
    80002f88:	00000097          	auipc	ra,0x0
    80002f8c:	b5e080e7          	jalr	-1186(ra) # 80002ae6 <argint>
  addr = myproc()->sz;
    80002f90:	fffff097          	auipc	ra,0xfffff
    80002f94:	a1c080e7          	jalr	-1508(ra) # 800019ac <myproc>
    80002f98:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002f9a:	fdc42503          	lw	a0,-36(s0)
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	d74080e7          	jalr	-652(ra) # 80001d12 <growproc>
    80002fa6:	00054863          	bltz	a0,80002fb6 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002faa:	8526                	mv	a0,s1
    80002fac:	70a2                	ld	ra,40(sp)
    80002fae:	7402                	ld	s0,32(sp)
    80002fb0:	64e2                	ld	s1,24(sp)
    80002fb2:	6145                	addi	sp,sp,48
    80002fb4:	8082                	ret
    return -1;
    80002fb6:	54fd                	li	s1,-1
    80002fb8:	bfcd                	j	80002faa <sys_sbrk+0x32>

0000000080002fba <sys_sleep>:

uint64
sys_sleep(void)
{
    80002fba:	7139                	addi	sp,sp,-64
    80002fbc:	fc06                	sd	ra,56(sp)
    80002fbe:	f822                	sd	s0,48(sp)
    80002fc0:	f426                	sd	s1,40(sp)
    80002fc2:	f04a                	sd	s2,32(sp)
    80002fc4:	ec4e                	sd	s3,24(sp)
    80002fc6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002fc8:	fcc40593          	addi	a1,s0,-52
    80002fcc:	4501                	li	a0,0
    80002fce:	00000097          	auipc	ra,0x0
    80002fd2:	b18080e7          	jalr	-1256(ra) # 80002ae6 <argint>
  acquire(&tickslock);
    80002fd6:	00015517          	auipc	a0,0x15
    80002fda:	28a50513          	addi	a0,a0,650 # 80018260 <tickslock>
    80002fde:	ffffe097          	auipc	ra,0xffffe
    80002fe2:	bf8080e7          	jalr	-1032(ra) # 80000bd6 <acquire>
  ticks0 = ticks;
    80002fe6:	00007917          	auipc	s2,0x7
    80002fea:	bda92903          	lw	s2,-1062(s2) # 80009bc0 <ticks>
  while(ticks - ticks0 < n){
    80002fee:	fcc42783          	lw	a5,-52(s0)
    80002ff2:	cf9d                	beqz	a5,80003030 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002ff4:	00015997          	auipc	s3,0x15
    80002ff8:	26c98993          	addi	s3,s3,620 # 80018260 <tickslock>
    80002ffc:	00007497          	auipc	s1,0x7
    80003000:	bc448493          	addi	s1,s1,-1084 # 80009bc0 <ticks>
    if(killed(myproc())){
    80003004:	fffff097          	auipc	ra,0xfffff
    80003008:	9a8080e7          	jalr	-1624(ra) # 800019ac <myproc>
    8000300c:	fffff097          	auipc	ra,0xfffff
    80003010:	314080e7          	jalr	788(ra) # 80002320 <killed>
    80003014:	ed15                	bnez	a0,80003050 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003016:	85ce                	mv	a1,s3
    80003018:	8526                	mv	a0,s1
    8000301a:	fffff097          	auipc	ra,0xfffff
    8000301e:	046080e7          	jalr	70(ra) # 80002060 <sleep>
  while(ticks - ticks0 < n){
    80003022:	409c                	lw	a5,0(s1)
    80003024:	412787bb          	subw	a5,a5,s2
    80003028:	fcc42703          	lw	a4,-52(s0)
    8000302c:	fce7ece3          	bltu	a5,a4,80003004 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80003030:	00015517          	auipc	a0,0x15
    80003034:	23050513          	addi	a0,a0,560 # 80018260 <tickslock>
    80003038:	ffffe097          	auipc	ra,0xffffe
    8000303c:	c52080e7          	jalr	-942(ra) # 80000c8a <release>
  return 0;
    80003040:	4501                	li	a0,0
}
    80003042:	70e2                	ld	ra,56(sp)
    80003044:	7442                	ld	s0,48(sp)
    80003046:	74a2                	ld	s1,40(sp)
    80003048:	7902                	ld	s2,32(sp)
    8000304a:	69e2                	ld	s3,24(sp)
    8000304c:	6121                	addi	sp,sp,64
    8000304e:	8082                	ret
      release(&tickslock);
    80003050:	00015517          	auipc	a0,0x15
    80003054:	21050513          	addi	a0,a0,528 # 80018260 <tickslock>
    80003058:	ffffe097          	auipc	ra,0xffffe
    8000305c:	c32080e7          	jalr	-974(ra) # 80000c8a <release>
      return -1;
    80003060:	557d                	li	a0,-1
    80003062:	b7c5                	j	80003042 <sys_sleep+0x88>

0000000080003064 <sys_kill>:

uint64
sys_kill(void)
{
    80003064:	1101                	addi	sp,sp,-32
    80003066:	ec06                	sd	ra,24(sp)
    80003068:	e822                	sd	s0,16(sp)
    8000306a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000306c:	fec40593          	addi	a1,s0,-20
    80003070:	4501                	li	a0,0
    80003072:	00000097          	auipc	ra,0x0
    80003076:	a74080e7          	jalr	-1420(ra) # 80002ae6 <argint>
  return kill(pid);
    8000307a:	fec42503          	lw	a0,-20(s0)
    8000307e:	fffff097          	auipc	ra,0xfffff
    80003082:	204080e7          	jalr	516(ra) # 80002282 <kill>
}
    80003086:	60e2                	ld	ra,24(sp)
    80003088:	6442                	ld	s0,16(sp)
    8000308a:	6105                	addi	sp,sp,32
    8000308c:	8082                	ret

000000008000308e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000308e:	1101                	addi	sp,sp,-32
    80003090:	ec06                	sd	ra,24(sp)
    80003092:	e822                	sd	s0,16(sp)
    80003094:	e426                	sd	s1,8(sp)
    80003096:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003098:	00015517          	auipc	a0,0x15
    8000309c:	1c850513          	addi	a0,a0,456 # 80018260 <tickslock>
    800030a0:	ffffe097          	auipc	ra,0xffffe
    800030a4:	b36080e7          	jalr	-1226(ra) # 80000bd6 <acquire>
  xticks = ticks;
    800030a8:	00007497          	auipc	s1,0x7
    800030ac:	b184a483          	lw	s1,-1256(s1) # 80009bc0 <ticks>
  release(&tickslock);
    800030b0:	00015517          	auipc	a0,0x15
    800030b4:	1b050513          	addi	a0,a0,432 # 80018260 <tickslock>
    800030b8:	ffffe097          	auipc	ra,0xffffe
    800030bc:	bd2080e7          	jalr	-1070(ra) # 80000c8a <release>
  return xticks;
}
    800030c0:	02049513          	slli	a0,s1,0x20
    800030c4:	9101                	srli	a0,a0,0x20
    800030c6:	60e2                	ld	ra,24(sp)
    800030c8:	6442                	ld	s0,16(sp)
    800030ca:	64a2                	ld	s1,8(sp)
    800030cc:	6105                	addi	sp,sp,32
    800030ce:	8082                	ret

00000000800030d0 <sys_gettime>:
uint64 sys_gettime(void){
    800030d0:	7179                	addi	sp,sp,-48
    800030d2:	f406                	sd	ra,40(sp)
    800030d4:	f022                	sd	s0,32(sp)
    800030d6:	ec26                	sd	s1,24(sp)
    800030d8:	1800                	addi	s0,sp,48
  struct proc * p = myproc();
    800030da:	fffff097          	auipc	ra,0xfffff
    800030de:	8d2080e7          	jalr	-1838(ra) # 800019ac <myproc>
    800030e2:	84aa                	mv	s1,a0
  argaddr(0, &address);
    800030e4:	fd840593          	addi	a1,s0,-40
    800030e8:	4501                	li	a0,0
    800030ea:	00000097          	auipc	ra,0x0
    800030ee:	a1c080e7          	jalr	-1508(ra) # 80002b06 <argaddr>
  time=sys_uptime();
    800030f2:	00000097          	auipc	ra,0x0
    800030f6:	f9c080e7          	jalr	-100(ra) # 8000308e <sys_uptime>
    800030fa:	fca43823          	sd	a0,-48(s0)
  copyout(p->pagetable, address,&time, sizeof(uint64));
    800030fe:	46a1                	li	a3,8
    80003100:	fd040613          	addi	a2,s0,-48
    80003104:	fd843583          	ld	a1,-40(s0)
    80003108:	68a8                	ld	a0,80(s1)
    8000310a:	ffffe097          	auipc	ra,0xffffe
    8000310e:	562080e7          	jalr	1378(ra) # 8000166c <copyout>
}
    80003112:	4501                	li	a0,0
    80003114:	70a2                	ld	ra,40(sp)
    80003116:	7402                	ld	s0,32(sp)
    80003118:	64e2                	ld	s1,24(sp)
    8000311a:	6145                	addi	sp,sp,48
    8000311c:	8082                	ret

000000008000311e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000311e:	7179                	addi	sp,sp,-48
    80003120:	f406                	sd	ra,40(sp)
    80003122:	f022                	sd	s0,32(sp)
    80003124:	ec26                	sd	s1,24(sp)
    80003126:	e84a                	sd	s2,16(sp)
    80003128:	e44e                	sd	s3,8(sp)
    8000312a:	e052                	sd	s4,0(sp)
    8000312c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000312e:	00006597          	auipc	a1,0x6
    80003132:	4ca58593          	addi	a1,a1,1226 # 800095f8 <syscalls+0x1a8>
    80003136:	00015517          	auipc	a0,0x15
    8000313a:	14250513          	addi	a0,a0,322 # 80018278 <bcache>
    8000313e:	ffffe097          	auipc	ra,0xffffe
    80003142:	a08080e7          	jalr	-1528(ra) # 80000b46 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003146:	0001d797          	auipc	a5,0x1d
    8000314a:	13278793          	addi	a5,a5,306 # 80020278 <bcache+0x8000>
    8000314e:	0001d717          	auipc	a4,0x1d
    80003152:	39270713          	addi	a4,a4,914 # 800204e0 <bcache+0x8268>
    80003156:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000315a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000315e:	00015497          	auipc	s1,0x15
    80003162:	13248493          	addi	s1,s1,306 # 80018290 <bcache+0x18>
    b->next = bcache.head.next;
    80003166:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003168:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000316a:	00006a17          	auipc	s4,0x6
    8000316e:	496a0a13          	addi	s4,s4,1174 # 80009600 <syscalls+0x1b0>
    b->next = bcache.head.next;
    80003172:	2b893783          	ld	a5,696(s2)
    80003176:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003178:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000317c:	85d2                	mv	a1,s4
    8000317e:	01048513          	addi	a0,s1,16
    80003182:	00001097          	auipc	ra,0x1
    80003186:	4c8080e7          	jalr	1224(ra) # 8000464a <initsleeplock>
    bcache.head.next->prev = b;
    8000318a:	2b893783          	ld	a5,696(s2)
    8000318e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003190:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003194:	45848493          	addi	s1,s1,1112
    80003198:	fd349de3          	bne	s1,s3,80003172 <binit+0x54>
  }
}
    8000319c:	70a2                	ld	ra,40(sp)
    8000319e:	7402                	ld	s0,32(sp)
    800031a0:	64e2                	ld	s1,24(sp)
    800031a2:	6942                	ld	s2,16(sp)
    800031a4:	69a2                	ld	s3,8(sp)
    800031a6:	6a02                	ld	s4,0(sp)
    800031a8:	6145                	addi	sp,sp,48
    800031aa:	8082                	ret

00000000800031ac <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800031ac:	7179                	addi	sp,sp,-48
    800031ae:	f406                	sd	ra,40(sp)
    800031b0:	f022                	sd	s0,32(sp)
    800031b2:	ec26                	sd	s1,24(sp)
    800031b4:	e84a                	sd	s2,16(sp)
    800031b6:	e44e                	sd	s3,8(sp)
    800031b8:	1800                	addi	s0,sp,48
    800031ba:	892a                	mv	s2,a0
    800031bc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800031be:	00015517          	auipc	a0,0x15
    800031c2:	0ba50513          	addi	a0,a0,186 # 80018278 <bcache>
    800031c6:	ffffe097          	auipc	ra,0xffffe
    800031ca:	a10080e7          	jalr	-1520(ra) # 80000bd6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800031ce:	0001d497          	auipc	s1,0x1d
    800031d2:	3624b483          	ld	s1,866(s1) # 80020530 <bcache+0x82b8>
    800031d6:	0001d797          	auipc	a5,0x1d
    800031da:	30a78793          	addi	a5,a5,778 # 800204e0 <bcache+0x8268>
    800031de:	02f48f63          	beq	s1,a5,8000321c <bread+0x70>
    800031e2:	873e                	mv	a4,a5
    800031e4:	a021                	j	800031ec <bread+0x40>
    800031e6:	68a4                	ld	s1,80(s1)
    800031e8:	02e48a63          	beq	s1,a4,8000321c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800031ec:	449c                	lw	a5,8(s1)
    800031ee:	ff279ce3          	bne	a5,s2,800031e6 <bread+0x3a>
    800031f2:	44dc                	lw	a5,12(s1)
    800031f4:	ff3799e3          	bne	a5,s3,800031e6 <bread+0x3a>
      b->refcnt++;
    800031f8:	40bc                	lw	a5,64(s1)
    800031fa:	2785                	addiw	a5,a5,1
    800031fc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800031fe:	00015517          	auipc	a0,0x15
    80003202:	07a50513          	addi	a0,a0,122 # 80018278 <bcache>
    80003206:	ffffe097          	auipc	ra,0xffffe
    8000320a:	a84080e7          	jalr	-1404(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    8000320e:	01048513          	addi	a0,s1,16
    80003212:	00001097          	auipc	ra,0x1
    80003216:	472080e7          	jalr	1138(ra) # 80004684 <acquiresleep>
      return b;
    8000321a:	a8b9                	j	80003278 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000321c:	0001d497          	auipc	s1,0x1d
    80003220:	30c4b483          	ld	s1,780(s1) # 80020528 <bcache+0x82b0>
    80003224:	0001d797          	auipc	a5,0x1d
    80003228:	2bc78793          	addi	a5,a5,700 # 800204e0 <bcache+0x8268>
    8000322c:	00f48863          	beq	s1,a5,8000323c <bread+0x90>
    80003230:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003232:	40bc                	lw	a5,64(s1)
    80003234:	cf81                	beqz	a5,8000324c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003236:	64a4                	ld	s1,72(s1)
    80003238:	fee49de3          	bne	s1,a4,80003232 <bread+0x86>
  panic("bget: no buffers");
    8000323c:	00006517          	auipc	a0,0x6
    80003240:	3cc50513          	addi	a0,a0,972 # 80009608 <syscalls+0x1b8>
    80003244:	ffffd097          	auipc	ra,0xffffd
    80003248:	2fc080e7          	jalr	764(ra) # 80000540 <panic>
      b->dev = dev;
    8000324c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003250:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003254:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003258:	4785                	li	a5,1
    8000325a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000325c:	00015517          	auipc	a0,0x15
    80003260:	01c50513          	addi	a0,a0,28 # 80018278 <bcache>
    80003264:	ffffe097          	auipc	ra,0xffffe
    80003268:	a26080e7          	jalr	-1498(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    8000326c:	01048513          	addi	a0,s1,16
    80003270:	00001097          	auipc	ra,0x1
    80003274:	414080e7          	jalr	1044(ra) # 80004684 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003278:	409c                	lw	a5,0(s1)
    8000327a:	cb89                	beqz	a5,8000328c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000327c:	8526                	mv	a0,s1
    8000327e:	70a2                	ld	ra,40(sp)
    80003280:	7402                	ld	s0,32(sp)
    80003282:	64e2                	ld	s1,24(sp)
    80003284:	6942                	ld	s2,16(sp)
    80003286:	69a2                	ld	s3,8(sp)
    80003288:	6145                	addi	sp,sp,48
    8000328a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000328c:	4581                	li	a1,0
    8000328e:	8526                	mv	a0,s1
    80003290:	00003097          	auipc	ra,0x3
    80003294:	0d2080e7          	jalr	210(ra) # 80006362 <virtio_disk_rw>
    b->valid = 1;
    80003298:	4785                	li	a5,1
    8000329a:	c09c                	sw	a5,0(s1)
  return b;
    8000329c:	b7c5                	j	8000327c <bread+0xd0>

000000008000329e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000329e:	1101                	addi	sp,sp,-32
    800032a0:	ec06                	sd	ra,24(sp)
    800032a2:	e822                	sd	s0,16(sp)
    800032a4:	e426                	sd	s1,8(sp)
    800032a6:	1000                	addi	s0,sp,32
    800032a8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800032aa:	0541                	addi	a0,a0,16
    800032ac:	00001097          	auipc	ra,0x1
    800032b0:	472080e7          	jalr	1138(ra) # 8000471e <holdingsleep>
    800032b4:	cd01                	beqz	a0,800032cc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800032b6:	4585                	li	a1,1
    800032b8:	8526                	mv	a0,s1
    800032ba:	00003097          	auipc	ra,0x3
    800032be:	0a8080e7          	jalr	168(ra) # 80006362 <virtio_disk_rw>
}
    800032c2:	60e2                	ld	ra,24(sp)
    800032c4:	6442                	ld	s0,16(sp)
    800032c6:	64a2                	ld	s1,8(sp)
    800032c8:	6105                	addi	sp,sp,32
    800032ca:	8082                	ret
    panic("bwrite");
    800032cc:	00006517          	auipc	a0,0x6
    800032d0:	35450513          	addi	a0,a0,852 # 80009620 <syscalls+0x1d0>
    800032d4:	ffffd097          	auipc	ra,0xffffd
    800032d8:	26c080e7          	jalr	620(ra) # 80000540 <panic>

00000000800032dc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800032dc:	1101                	addi	sp,sp,-32
    800032de:	ec06                	sd	ra,24(sp)
    800032e0:	e822                	sd	s0,16(sp)
    800032e2:	e426                	sd	s1,8(sp)
    800032e4:	e04a                	sd	s2,0(sp)
    800032e6:	1000                	addi	s0,sp,32
    800032e8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800032ea:	01050913          	addi	s2,a0,16
    800032ee:	854a                	mv	a0,s2
    800032f0:	00001097          	auipc	ra,0x1
    800032f4:	42e080e7          	jalr	1070(ra) # 8000471e <holdingsleep>
    800032f8:	c92d                	beqz	a0,8000336a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800032fa:	854a                	mv	a0,s2
    800032fc:	00001097          	auipc	ra,0x1
    80003300:	3de080e7          	jalr	990(ra) # 800046da <releasesleep>

  acquire(&bcache.lock);
    80003304:	00015517          	auipc	a0,0x15
    80003308:	f7450513          	addi	a0,a0,-140 # 80018278 <bcache>
    8000330c:	ffffe097          	auipc	ra,0xffffe
    80003310:	8ca080e7          	jalr	-1846(ra) # 80000bd6 <acquire>
  b->refcnt--;
    80003314:	40bc                	lw	a5,64(s1)
    80003316:	37fd                	addiw	a5,a5,-1
    80003318:	0007871b          	sext.w	a4,a5
    8000331c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000331e:	eb05                	bnez	a4,8000334e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003320:	68bc                	ld	a5,80(s1)
    80003322:	64b8                	ld	a4,72(s1)
    80003324:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003326:	64bc                	ld	a5,72(s1)
    80003328:	68b8                	ld	a4,80(s1)
    8000332a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000332c:	0001d797          	auipc	a5,0x1d
    80003330:	f4c78793          	addi	a5,a5,-180 # 80020278 <bcache+0x8000>
    80003334:	2b87b703          	ld	a4,696(a5)
    80003338:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000333a:	0001d717          	auipc	a4,0x1d
    8000333e:	1a670713          	addi	a4,a4,422 # 800204e0 <bcache+0x8268>
    80003342:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003344:	2b87b703          	ld	a4,696(a5)
    80003348:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000334a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000334e:	00015517          	auipc	a0,0x15
    80003352:	f2a50513          	addi	a0,a0,-214 # 80018278 <bcache>
    80003356:	ffffe097          	auipc	ra,0xffffe
    8000335a:	934080e7          	jalr	-1740(ra) # 80000c8a <release>
}
    8000335e:	60e2                	ld	ra,24(sp)
    80003360:	6442                	ld	s0,16(sp)
    80003362:	64a2                	ld	s1,8(sp)
    80003364:	6902                	ld	s2,0(sp)
    80003366:	6105                	addi	sp,sp,32
    80003368:	8082                	ret
    panic("brelse");
    8000336a:	00006517          	auipc	a0,0x6
    8000336e:	2be50513          	addi	a0,a0,702 # 80009628 <syscalls+0x1d8>
    80003372:	ffffd097          	auipc	ra,0xffffd
    80003376:	1ce080e7          	jalr	462(ra) # 80000540 <panic>

000000008000337a <bpin>:

void
bpin(struct buf *b) {
    8000337a:	1101                	addi	sp,sp,-32
    8000337c:	ec06                	sd	ra,24(sp)
    8000337e:	e822                	sd	s0,16(sp)
    80003380:	e426                	sd	s1,8(sp)
    80003382:	1000                	addi	s0,sp,32
    80003384:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003386:	00015517          	auipc	a0,0x15
    8000338a:	ef250513          	addi	a0,a0,-270 # 80018278 <bcache>
    8000338e:	ffffe097          	auipc	ra,0xffffe
    80003392:	848080e7          	jalr	-1976(ra) # 80000bd6 <acquire>
  b->refcnt++;
    80003396:	40bc                	lw	a5,64(s1)
    80003398:	2785                	addiw	a5,a5,1
    8000339a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000339c:	00015517          	auipc	a0,0x15
    800033a0:	edc50513          	addi	a0,a0,-292 # 80018278 <bcache>
    800033a4:	ffffe097          	auipc	ra,0xffffe
    800033a8:	8e6080e7          	jalr	-1818(ra) # 80000c8a <release>
}
    800033ac:	60e2                	ld	ra,24(sp)
    800033ae:	6442                	ld	s0,16(sp)
    800033b0:	64a2                	ld	s1,8(sp)
    800033b2:	6105                	addi	sp,sp,32
    800033b4:	8082                	ret

00000000800033b6 <bunpin>:

void
bunpin(struct buf *b) {
    800033b6:	1101                	addi	sp,sp,-32
    800033b8:	ec06                	sd	ra,24(sp)
    800033ba:	e822                	sd	s0,16(sp)
    800033bc:	e426                	sd	s1,8(sp)
    800033be:	1000                	addi	s0,sp,32
    800033c0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800033c2:	00015517          	auipc	a0,0x15
    800033c6:	eb650513          	addi	a0,a0,-330 # 80018278 <bcache>
    800033ca:	ffffe097          	auipc	ra,0xffffe
    800033ce:	80c080e7          	jalr	-2036(ra) # 80000bd6 <acquire>
  b->refcnt--;
    800033d2:	40bc                	lw	a5,64(s1)
    800033d4:	37fd                	addiw	a5,a5,-1
    800033d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800033d8:	00015517          	auipc	a0,0x15
    800033dc:	ea050513          	addi	a0,a0,-352 # 80018278 <bcache>
    800033e0:	ffffe097          	auipc	ra,0xffffe
    800033e4:	8aa080e7          	jalr	-1878(ra) # 80000c8a <release>
}
    800033e8:	60e2                	ld	ra,24(sp)
    800033ea:	6442                	ld	s0,16(sp)
    800033ec:	64a2                	ld	s1,8(sp)
    800033ee:	6105                	addi	sp,sp,32
    800033f0:	8082                	ret

00000000800033f2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800033f2:	1101                	addi	sp,sp,-32
    800033f4:	ec06                	sd	ra,24(sp)
    800033f6:	e822                	sd	s0,16(sp)
    800033f8:	e426                	sd	s1,8(sp)
    800033fa:	e04a                	sd	s2,0(sp)
    800033fc:	1000                	addi	s0,sp,32
    800033fe:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003400:	00d5d59b          	srliw	a1,a1,0xd
    80003404:	0001d797          	auipc	a5,0x1d
    80003408:	5507a783          	lw	a5,1360(a5) # 80020954 <sb+0x1c>
    8000340c:	9dbd                	addw	a1,a1,a5
    8000340e:	00000097          	auipc	ra,0x0
    80003412:	d9e080e7          	jalr	-610(ra) # 800031ac <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003416:	0074f713          	andi	a4,s1,7
    8000341a:	4785                	li	a5,1
    8000341c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003420:	14ce                	slli	s1,s1,0x33
    80003422:	90d9                	srli	s1,s1,0x36
    80003424:	00950733          	add	a4,a0,s1
    80003428:	05874703          	lbu	a4,88(a4)
    8000342c:	00e7f6b3          	and	a3,a5,a4
    80003430:	c69d                	beqz	a3,8000345e <bfree+0x6c>
    80003432:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003434:	94aa                	add	s1,s1,a0
    80003436:	fff7c793          	not	a5,a5
    8000343a:	8f7d                	and	a4,a4,a5
    8000343c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003440:	00001097          	auipc	ra,0x1
    80003444:	126080e7          	jalr	294(ra) # 80004566 <log_write>
  brelse(bp);
    80003448:	854a                	mv	a0,s2
    8000344a:	00000097          	auipc	ra,0x0
    8000344e:	e92080e7          	jalr	-366(ra) # 800032dc <brelse>
}
    80003452:	60e2                	ld	ra,24(sp)
    80003454:	6442                	ld	s0,16(sp)
    80003456:	64a2                	ld	s1,8(sp)
    80003458:	6902                	ld	s2,0(sp)
    8000345a:	6105                	addi	sp,sp,32
    8000345c:	8082                	ret
    panic("freeing free block");
    8000345e:	00006517          	auipc	a0,0x6
    80003462:	1d250513          	addi	a0,a0,466 # 80009630 <syscalls+0x1e0>
    80003466:	ffffd097          	auipc	ra,0xffffd
    8000346a:	0da080e7          	jalr	218(ra) # 80000540 <panic>

000000008000346e <balloc>:
{
    8000346e:	711d                	addi	sp,sp,-96
    80003470:	ec86                	sd	ra,88(sp)
    80003472:	e8a2                	sd	s0,80(sp)
    80003474:	e4a6                	sd	s1,72(sp)
    80003476:	e0ca                	sd	s2,64(sp)
    80003478:	fc4e                	sd	s3,56(sp)
    8000347a:	f852                	sd	s4,48(sp)
    8000347c:	f456                	sd	s5,40(sp)
    8000347e:	f05a                	sd	s6,32(sp)
    80003480:	ec5e                	sd	s7,24(sp)
    80003482:	e862                	sd	s8,16(sp)
    80003484:	e466                	sd	s9,8(sp)
    80003486:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003488:	0001d797          	auipc	a5,0x1d
    8000348c:	4b47a783          	lw	a5,1204(a5) # 8002093c <sb+0x4>
    80003490:	cff5                	beqz	a5,8000358c <balloc+0x11e>
    80003492:	8baa                	mv	s7,a0
    80003494:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003496:	0001db17          	auipc	s6,0x1d
    8000349a:	4a2b0b13          	addi	s6,s6,1186 # 80020938 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000349e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800034a0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800034a2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800034a4:	6c89                	lui	s9,0x2
    800034a6:	a061                	j	8000352e <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800034a8:	97ca                	add	a5,a5,s2
    800034aa:	8e55                	or	a2,a2,a3
    800034ac:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800034b0:	854a                	mv	a0,s2
    800034b2:	00001097          	auipc	ra,0x1
    800034b6:	0b4080e7          	jalr	180(ra) # 80004566 <log_write>
        brelse(bp);
    800034ba:	854a                	mv	a0,s2
    800034bc:	00000097          	auipc	ra,0x0
    800034c0:	e20080e7          	jalr	-480(ra) # 800032dc <brelse>
  bp = bread(dev, bno);
    800034c4:	85a6                	mv	a1,s1
    800034c6:	855e                	mv	a0,s7
    800034c8:	00000097          	auipc	ra,0x0
    800034cc:	ce4080e7          	jalr	-796(ra) # 800031ac <bread>
    800034d0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800034d2:	40000613          	li	a2,1024
    800034d6:	4581                	li	a1,0
    800034d8:	05850513          	addi	a0,a0,88
    800034dc:	ffffd097          	auipc	ra,0xffffd
    800034e0:	7f6080e7          	jalr	2038(ra) # 80000cd2 <memset>
  log_write(bp);
    800034e4:	854a                	mv	a0,s2
    800034e6:	00001097          	auipc	ra,0x1
    800034ea:	080080e7          	jalr	128(ra) # 80004566 <log_write>
  brelse(bp);
    800034ee:	854a                	mv	a0,s2
    800034f0:	00000097          	auipc	ra,0x0
    800034f4:	dec080e7          	jalr	-532(ra) # 800032dc <brelse>
}
    800034f8:	8526                	mv	a0,s1
    800034fa:	60e6                	ld	ra,88(sp)
    800034fc:	6446                	ld	s0,80(sp)
    800034fe:	64a6                	ld	s1,72(sp)
    80003500:	6906                	ld	s2,64(sp)
    80003502:	79e2                	ld	s3,56(sp)
    80003504:	7a42                	ld	s4,48(sp)
    80003506:	7aa2                	ld	s5,40(sp)
    80003508:	7b02                	ld	s6,32(sp)
    8000350a:	6be2                	ld	s7,24(sp)
    8000350c:	6c42                	ld	s8,16(sp)
    8000350e:	6ca2                	ld	s9,8(sp)
    80003510:	6125                	addi	sp,sp,96
    80003512:	8082                	ret
    brelse(bp);
    80003514:	854a                	mv	a0,s2
    80003516:	00000097          	auipc	ra,0x0
    8000351a:	dc6080e7          	jalr	-570(ra) # 800032dc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000351e:	015c87bb          	addw	a5,s9,s5
    80003522:	00078a9b          	sext.w	s5,a5
    80003526:	004b2703          	lw	a4,4(s6)
    8000352a:	06eaf163          	bgeu	s5,a4,8000358c <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000352e:	41fad79b          	sraiw	a5,s5,0x1f
    80003532:	0137d79b          	srliw	a5,a5,0x13
    80003536:	015787bb          	addw	a5,a5,s5
    8000353a:	40d7d79b          	sraiw	a5,a5,0xd
    8000353e:	01cb2583          	lw	a1,28(s6)
    80003542:	9dbd                	addw	a1,a1,a5
    80003544:	855e                	mv	a0,s7
    80003546:	00000097          	auipc	ra,0x0
    8000354a:	c66080e7          	jalr	-922(ra) # 800031ac <bread>
    8000354e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003550:	004b2503          	lw	a0,4(s6)
    80003554:	000a849b          	sext.w	s1,s5
    80003558:	8762                	mv	a4,s8
    8000355a:	faa4fde3          	bgeu	s1,a0,80003514 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000355e:	00777693          	andi	a3,a4,7
    80003562:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003566:	41f7579b          	sraiw	a5,a4,0x1f
    8000356a:	01d7d79b          	srliw	a5,a5,0x1d
    8000356e:	9fb9                	addw	a5,a5,a4
    80003570:	4037d79b          	sraiw	a5,a5,0x3
    80003574:	00f90633          	add	a2,s2,a5
    80003578:	05864603          	lbu	a2,88(a2)
    8000357c:	00c6f5b3          	and	a1,a3,a2
    80003580:	d585                	beqz	a1,800034a8 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003582:	2705                	addiw	a4,a4,1
    80003584:	2485                	addiw	s1,s1,1
    80003586:	fd471ae3          	bne	a4,s4,8000355a <balloc+0xec>
    8000358a:	b769                	j	80003514 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000358c:	00006517          	auipc	a0,0x6
    80003590:	0bc50513          	addi	a0,a0,188 # 80009648 <syscalls+0x1f8>
    80003594:	ffffd097          	auipc	ra,0xffffd
    80003598:	ff6080e7          	jalr	-10(ra) # 8000058a <printf>
  return 0;
    8000359c:	4481                	li	s1,0
    8000359e:	bfa9                	j	800034f8 <balloc+0x8a>

00000000800035a0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800035a0:	7179                	addi	sp,sp,-48
    800035a2:	f406                	sd	ra,40(sp)
    800035a4:	f022                	sd	s0,32(sp)
    800035a6:	ec26                	sd	s1,24(sp)
    800035a8:	e84a                	sd	s2,16(sp)
    800035aa:	e44e                	sd	s3,8(sp)
    800035ac:	e052                	sd	s4,0(sp)
    800035ae:	1800                	addi	s0,sp,48
    800035b0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800035b2:	47ad                	li	a5,11
    800035b4:	02b7e863          	bltu	a5,a1,800035e4 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800035b8:	02059793          	slli	a5,a1,0x20
    800035bc:	01e7d593          	srli	a1,a5,0x1e
    800035c0:	00b504b3          	add	s1,a0,a1
    800035c4:	0504a903          	lw	s2,80(s1)
    800035c8:	06091e63          	bnez	s2,80003644 <bmap+0xa4>
      addr = balloc(ip->dev);
    800035cc:	4108                	lw	a0,0(a0)
    800035ce:	00000097          	auipc	ra,0x0
    800035d2:	ea0080e7          	jalr	-352(ra) # 8000346e <balloc>
    800035d6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800035da:	06090563          	beqz	s2,80003644 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800035de:	0524a823          	sw	s2,80(s1)
    800035e2:	a08d                	j	80003644 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800035e4:	ff45849b          	addiw	s1,a1,-12
    800035e8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800035ec:	0ff00793          	li	a5,255
    800035f0:	08e7e563          	bltu	a5,a4,8000367a <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800035f4:	08052903          	lw	s2,128(a0)
    800035f8:	00091d63          	bnez	s2,80003612 <bmap+0x72>
      addr = balloc(ip->dev);
    800035fc:	4108                	lw	a0,0(a0)
    800035fe:	00000097          	auipc	ra,0x0
    80003602:	e70080e7          	jalr	-400(ra) # 8000346e <balloc>
    80003606:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000360a:	02090d63          	beqz	s2,80003644 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000360e:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003612:	85ca                	mv	a1,s2
    80003614:	0009a503          	lw	a0,0(s3)
    80003618:	00000097          	auipc	ra,0x0
    8000361c:	b94080e7          	jalr	-1132(ra) # 800031ac <bread>
    80003620:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003622:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003626:	02049713          	slli	a4,s1,0x20
    8000362a:	01e75593          	srli	a1,a4,0x1e
    8000362e:	00b784b3          	add	s1,a5,a1
    80003632:	0004a903          	lw	s2,0(s1)
    80003636:	02090063          	beqz	s2,80003656 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000363a:	8552                	mv	a0,s4
    8000363c:	00000097          	auipc	ra,0x0
    80003640:	ca0080e7          	jalr	-864(ra) # 800032dc <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003644:	854a                	mv	a0,s2
    80003646:	70a2                	ld	ra,40(sp)
    80003648:	7402                	ld	s0,32(sp)
    8000364a:	64e2                	ld	s1,24(sp)
    8000364c:	6942                	ld	s2,16(sp)
    8000364e:	69a2                	ld	s3,8(sp)
    80003650:	6a02                	ld	s4,0(sp)
    80003652:	6145                	addi	sp,sp,48
    80003654:	8082                	ret
      addr = balloc(ip->dev);
    80003656:	0009a503          	lw	a0,0(s3)
    8000365a:	00000097          	auipc	ra,0x0
    8000365e:	e14080e7          	jalr	-492(ra) # 8000346e <balloc>
    80003662:	0005091b          	sext.w	s2,a0
      if(addr){
    80003666:	fc090ae3          	beqz	s2,8000363a <bmap+0x9a>
        a[bn] = addr;
    8000366a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000366e:	8552                	mv	a0,s4
    80003670:	00001097          	auipc	ra,0x1
    80003674:	ef6080e7          	jalr	-266(ra) # 80004566 <log_write>
    80003678:	b7c9                	j	8000363a <bmap+0x9a>
  panic("bmap: out of range");
    8000367a:	00006517          	auipc	a0,0x6
    8000367e:	fe650513          	addi	a0,a0,-26 # 80009660 <syscalls+0x210>
    80003682:	ffffd097          	auipc	ra,0xffffd
    80003686:	ebe080e7          	jalr	-322(ra) # 80000540 <panic>

000000008000368a <iget>:
{
    8000368a:	7179                	addi	sp,sp,-48
    8000368c:	f406                	sd	ra,40(sp)
    8000368e:	f022                	sd	s0,32(sp)
    80003690:	ec26                	sd	s1,24(sp)
    80003692:	e84a                	sd	s2,16(sp)
    80003694:	e44e                	sd	s3,8(sp)
    80003696:	e052                	sd	s4,0(sp)
    80003698:	1800                	addi	s0,sp,48
    8000369a:	89aa                	mv	s3,a0
    8000369c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000369e:	0001d517          	auipc	a0,0x1d
    800036a2:	2ba50513          	addi	a0,a0,698 # 80020958 <itable>
    800036a6:	ffffd097          	auipc	ra,0xffffd
    800036aa:	530080e7          	jalr	1328(ra) # 80000bd6 <acquire>
  empty = 0;
    800036ae:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800036b0:	0001d497          	auipc	s1,0x1d
    800036b4:	2c048493          	addi	s1,s1,704 # 80020970 <itable+0x18>
    800036b8:	0001f697          	auipc	a3,0x1f
    800036bc:	d4868693          	addi	a3,a3,-696 # 80022400 <log>
    800036c0:	a039                	j	800036ce <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800036c2:	02090b63          	beqz	s2,800036f8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800036c6:	08848493          	addi	s1,s1,136
    800036ca:	02d48a63          	beq	s1,a3,800036fe <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800036ce:	449c                	lw	a5,8(s1)
    800036d0:	fef059e3          	blez	a5,800036c2 <iget+0x38>
    800036d4:	4098                	lw	a4,0(s1)
    800036d6:	ff3716e3          	bne	a4,s3,800036c2 <iget+0x38>
    800036da:	40d8                	lw	a4,4(s1)
    800036dc:	ff4713e3          	bne	a4,s4,800036c2 <iget+0x38>
      ip->ref++;
    800036e0:	2785                	addiw	a5,a5,1
    800036e2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800036e4:	0001d517          	auipc	a0,0x1d
    800036e8:	27450513          	addi	a0,a0,628 # 80020958 <itable>
    800036ec:	ffffd097          	auipc	ra,0xffffd
    800036f0:	59e080e7          	jalr	1438(ra) # 80000c8a <release>
      return ip;
    800036f4:	8926                	mv	s2,s1
    800036f6:	a03d                	j	80003724 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800036f8:	f7f9                	bnez	a5,800036c6 <iget+0x3c>
    800036fa:	8926                	mv	s2,s1
    800036fc:	b7e9                	j	800036c6 <iget+0x3c>
  if(empty == 0)
    800036fe:	02090c63          	beqz	s2,80003736 <iget+0xac>
  ip->dev = dev;
    80003702:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003706:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000370a:	4785                	li	a5,1
    8000370c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003710:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003714:	0001d517          	auipc	a0,0x1d
    80003718:	24450513          	addi	a0,a0,580 # 80020958 <itable>
    8000371c:	ffffd097          	auipc	ra,0xffffd
    80003720:	56e080e7          	jalr	1390(ra) # 80000c8a <release>
}
    80003724:	854a                	mv	a0,s2
    80003726:	70a2                	ld	ra,40(sp)
    80003728:	7402                	ld	s0,32(sp)
    8000372a:	64e2                	ld	s1,24(sp)
    8000372c:	6942                	ld	s2,16(sp)
    8000372e:	69a2                	ld	s3,8(sp)
    80003730:	6a02                	ld	s4,0(sp)
    80003732:	6145                	addi	sp,sp,48
    80003734:	8082                	ret
    panic("iget: no inodes");
    80003736:	00006517          	auipc	a0,0x6
    8000373a:	f4250513          	addi	a0,a0,-190 # 80009678 <syscalls+0x228>
    8000373e:	ffffd097          	auipc	ra,0xffffd
    80003742:	e02080e7          	jalr	-510(ra) # 80000540 <panic>

0000000080003746 <fsinit>:
fsinit(int dev) {
    80003746:	7179                	addi	sp,sp,-48
    80003748:	f406                	sd	ra,40(sp)
    8000374a:	f022                	sd	s0,32(sp)
    8000374c:	ec26                	sd	s1,24(sp)
    8000374e:	e84a                	sd	s2,16(sp)
    80003750:	e44e                	sd	s3,8(sp)
    80003752:	1800                	addi	s0,sp,48
    80003754:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003756:	4585                	li	a1,1
    80003758:	00000097          	auipc	ra,0x0
    8000375c:	a54080e7          	jalr	-1452(ra) # 800031ac <bread>
    80003760:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003762:	0001d997          	auipc	s3,0x1d
    80003766:	1d698993          	addi	s3,s3,470 # 80020938 <sb>
    8000376a:	02000613          	li	a2,32
    8000376e:	05850593          	addi	a1,a0,88
    80003772:	854e                	mv	a0,s3
    80003774:	ffffd097          	auipc	ra,0xffffd
    80003778:	5ba080e7          	jalr	1466(ra) # 80000d2e <memmove>
  brelse(bp);
    8000377c:	8526                	mv	a0,s1
    8000377e:	00000097          	auipc	ra,0x0
    80003782:	b5e080e7          	jalr	-1186(ra) # 800032dc <brelse>
  if(sb.magic != FSMAGIC)
    80003786:	0009a703          	lw	a4,0(s3)
    8000378a:	102037b7          	lui	a5,0x10203
    8000378e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003792:	02f71263          	bne	a4,a5,800037b6 <fsinit+0x70>
  initlog(dev, &sb);
    80003796:	0001d597          	auipc	a1,0x1d
    8000379a:	1a258593          	addi	a1,a1,418 # 80020938 <sb>
    8000379e:	854a                	mv	a0,s2
    800037a0:	00001097          	auipc	ra,0x1
    800037a4:	b4a080e7          	jalr	-1206(ra) # 800042ea <initlog>
}
    800037a8:	70a2                	ld	ra,40(sp)
    800037aa:	7402                	ld	s0,32(sp)
    800037ac:	64e2                	ld	s1,24(sp)
    800037ae:	6942                	ld	s2,16(sp)
    800037b0:	69a2                	ld	s3,8(sp)
    800037b2:	6145                	addi	sp,sp,48
    800037b4:	8082                	ret
    panic("invalid file system");
    800037b6:	00006517          	auipc	a0,0x6
    800037ba:	ed250513          	addi	a0,a0,-302 # 80009688 <syscalls+0x238>
    800037be:	ffffd097          	auipc	ra,0xffffd
    800037c2:	d82080e7          	jalr	-638(ra) # 80000540 <panic>

00000000800037c6 <iinit>:
{
    800037c6:	7179                	addi	sp,sp,-48
    800037c8:	f406                	sd	ra,40(sp)
    800037ca:	f022                	sd	s0,32(sp)
    800037cc:	ec26                	sd	s1,24(sp)
    800037ce:	e84a                	sd	s2,16(sp)
    800037d0:	e44e                	sd	s3,8(sp)
    800037d2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800037d4:	00006597          	auipc	a1,0x6
    800037d8:	ecc58593          	addi	a1,a1,-308 # 800096a0 <syscalls+0x250>
    800037dc:	0001d517          	auipc	a0,0x1d
    800037e0:	17c50513          	addi	a0,a0,380 # 80020958 <itable>
    800037e4:	ffffd097          	auipc	ra,0xffffd
    800037e8:	362080e7          	jalr	866(ra) # 80000b46 <initlock>
  for(i = 0; i < NINODE; i++) {
    800037ec:	0001d497          	auipc	s1,0x1d
    800037f0:	19448493          	addi	s1,s1,404 # 80020980 <itable+0x28>
    800037f4:	0001f997          	auipc	s3,0x1f
    800037f8:	c1c98993          	addi	s3,s3,-996 # 80022410 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800037fc:	00006917          	auipc	s2,0x6
    80003800:	eac90913          	addi	s2,s2,-340 # 800096a8 <syscalls+0x258>
    80003804:	85ca                	mv	a1,s2
    80003806:	8526                	mv	a0,s1
    80003808:	00001097          	auipc	ra,0x1
    8000380c:	e42080e7          	jalr	-446(ra) # 8000464a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003810:	08848493          	addi	s1,s1,136
    80003814:	ff3498e3          	bne	s1,s3,80003804 <iinit+0x3e>
}
    80003818:	70a2                	ld	ra,40(sp)
    8000381a:	7402                	ld	s0,32(sp)
    8000381c:	64e2                	ld	s1,24(sp)
    8000381e:	6942                	ld	s2,16(sp)
    80003820:	69a2                	ld	s3,8(sp)
    80003822:	6145                	addi	sp,sp,48
    80003824:	8082                	ret

0000000080003826 <ialloc>:
{
    80003826:	715d                	addi	sp,sp,-80
    80003828:	e486                	sd	ra,72(sp)
    8000382a:	e0a2                	sd	s0,64(sp)
    8000382c:	fc26                	sd	s1,56(sp)
    8000382e:	f84a                	sd	s2,48(sp)
    80003830:	f44e                	sd	s3,40(sp)
    80003832:	f052                	sd	s4,32(sp)
    80003834:	ec56                	sd	s5,24(sp)
    80003836:	e85a                	sd	s6,16(sp)
    80003838:	e45e                	sd	s7,8(sp)
    8000383a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000383c:	0001d717          	auipc	a4,0x1d
    80003840:	10872703          	lw	a4,264(a4) # 80020944 <sb+0xc>
    80003844:	4785                	li	a5,1
    80003846:	04e7fa63          	bgeu	a5,a4,8000389a <ialloc+0x74>
    8000384a:	8aaa                	mv	s5,a0
    8000384c:	8bae                	mv	s7,a1
    8000384e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003850:	0001da17          	auipc	s4,0x1d
    80003854:	0e8a0a13          	addi	s4,s4,232 # 80020938 <sb>
    80003858:	00048b1b          	sext.w	s6,s1
    8000385c:	0044d593          	srli	a1,s1,0x4
    80003860:	018a2783          	lw	a5,24(s4)
    80003864:	9dbd                	addw	a1,a1,a5
    80003866:	8556                	mv	a0,s5
    80003868:	00000097          	auipc	ra,0x0
    8000386c:	944080e7          	jalr	-1724(ra) # 800031ac <bread>
    80003870:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003872:	05850993          	addi	s3,a0,88
    80003876:	00f4f793          	andi	a5,s1,15
    8000387a:	079a                	slli	a5,a5,0x6
    8000387c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000387e:	00099783          	lh	a5,0(s3)
    80003882:	c3a1                	beqz	a5,800038c2 <ialloc+0x9c>
    brelse(bp);
    80003884:	00000097          	auipc	ra,0x0
    80003888:	a58080e7          	jalr	-1448(ra) # 800032dc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000388c:	0485                	addi	s1,s1,1
    8000388e:	00ca2703          	lw	a4,12(s4)
    80003892:	0004879b          	sext.w	a5,s1
    80003896:	fce7e1e3          	bltu	a5,a4,80003858 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    8000389a:	00006517          	auipc	a0,0x6
    8000389e:	e1650513          	addi	a0,a0,-490 # 800096b0 <syscalls+0x260>
    800038a2:	ffffd097          	auipc	ra,0xffffd
    800038a6:	ce8080e7          	jalr	-792(ra) # 8000058a <printf>
  return 0;
    800038aa:	4501                	li	a0,0
}
    800038ac:	60a6                	ld	ra,72(sp)
    800038ae:	6406                	ld	s0,64(sp)
    800038b0:	74e2                	ld	s1,56(sp)
    800038b2:	7942                	ld	s2,48(sp)
    800038b4:	79a2                	ld	s3,40(sp)
    800038b6:	7a02                	ld	s4,32(sp)
    800038b8:	6ae2                	ld	s5,24(sp)
    800038ba:	6b42                	ld	s6,16(sp)
    800038bc:	6ba2                	ld	s7,8(sp)
    800038be:	6161                	addi	sp,sp,80
    800038c0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800038c2:	04000613          	li	a2,64
    800038c6:	4581                	li	a1,0
    800038c8:	854e                	mv	a0,s3
    800038ca:	ffffd097          	auipc	ra,0xffffd
    800038ce:	408080e7          	jalr	1032(ra) # 80000cd2 <memset>
      dip->type = type;
    800038d2:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800038d6:	854a                	mv	a0,s2
    800038d8:	00001097          	auipc	ra,0x1
    800038dc:	c8e080e7          	jalr	-882(ra) # 80004566 <log_write>
      brelse(bp);
    800038e0:	854a                	mv	a0,s2
    800038e2:	00000097          	auipc	ra,0x0
    800038e6:	9fa080e7          	jalr	-1542(ra) # 800032dc <brelse>
      return iget(dev, inum);
    800038ea:	85da                	mv	a1,s6
    800038ec:	8556                	mv	a0,s5
    800038ee:	00000097          	auipc	ra,0x0
    800038f2:	d9c080e7          	jalr	-612(ra) # 8000368a <iget>
    800038f6:	bf5d                	j	800038ac <ialloc+0x86>

00000000800038f8 <iupdate>:
{
    800038f8:	1101                	addi	sp,sp,-32
    800038fa:	ec06                	sd	ra,24(sp)
    800038fc:	e822                	sd	s0,16(sp)
    800038fe:	e426                	sd	s1,8(sp)
    80003900:	e04a                	sd	s2,0(sp)
    80003902:	1000                	addi	s0,sp,32
    80003904:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003906:	415c                	lw	a5,4(a0)
    80003908:	0047d79b          	srliw	a5,a5,0x4
    8000390c:	0001d597          	auipc	a1,0x1d
    80003910:	0445a583          	lw	a1,68(a1) # 80020950 <sb+0x18>
    80003914:	9dbd                	addw	a1,a1,a5
    80003916:	4108                	lw	a0,0(a0)
    80003918:	00000097          	auipc	ra,0x0
    8000391c:	894080e7          	jalr	-1900(ra) # 800031ac <bread>
    80003920:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003922:	05850793          	addi	a5,a0,88
    80003926:	40d8                	lw	a4,4(s1)
    80003928:	8b3d                	andi	a4,a4,15
    8000392a:	071a                	slli	a4,a4,0x6
    8000392c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000392e:	04449703          	lh	a4,68(s1)
    80003932:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003936:	04649703          	lh	a4,70(s1)
    8000393a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000393e:	04849703          	lh	a4,72(s1)
    80003942:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003946:	04a49703          	lh	a4,74(s1)
    8000394a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000394e:	44f8                	lw	a4,76(s1)
    80003950:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003952:	03400613          	li	a2,52
    80003956:	05048593          	addi	a1,s1,80
    8000395a:	00c78513          	addi	a0,a5,12
    8000395e:	ffffd097          	auipc	ra,0xffffd
    80003962:	3d0080e7          	jalr	976(ra) # 80000d2e <memmove>
  log_write(bp);
    80003966:	854a                	mv	a0,s2
    80003968:	00001097          	auipc	ra,0x1
    8000396c:	bfe080e7          	jalr	-1026(ra) # 80004566 <log_write>
  brelse(bp);
    80003970:	854a                	mv	a0,s2
    80003972:	00000097          	auipc	ra,0x0
    80003976:	96a080e7          	jalr	-1686(ra) # 800032dc <brelse>
}
    8000397a:	60e2                	ld	ra,24(sp)
    8000397c:	6442                	ld	s0,16(sp)
    8000397e:	64a2                	ld	s1,8(sp)
    80003980:	6902                	ld	s2,0(sp)
    80003982:	6105                	addi	sp,sp,32
    80003984:	8082                	ret

0000000080003986 <idup>:
{
    80003986:	1101                	addi	sp,sp,-32
    80003988:	ec06                	sd	ra,24(sp)
    8000398a:	e822                	sd	s0,16(sp)
    8000398c:	e426                	sd	s1,8(sp)
    8000398e:	1000                	addi	s0,sp,32
    80003990:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003992:	0001d517          	auipc	a0,0x1d
    80003996:	fc650513          	addi	a0,a0,-58 # 80020958 <itable>
    8000399a:	ffffd097          	auipc	ra,0xffffd
    8000399e:	23c080e7          	jalr	572(ra) # 80000bd6 <acquire>
  ip->ref++;
    800039a2:	449c                	lw	a5,8(s1)
    800039a4:	2785                	addiw	a5,a5,1
    800039a6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800039a8:	0001d517          	auipc	a0,0x1d
    800039ac:	fb050513          	addi	a0,a0,-80 # 80020958 <itable>
    800039b0:	ffffd097          	auipc	ra,0xffffd
    800039b4:	2da080e7          	jalr	730(ra) # 80000c8a <release>
}
    800039b8:	8526                	mv	a0,s1
    800039ba:	60e2                	ld	ra,24(sp)
    800039bc:	6442                	ld	s0,16(sp)
    800039be:	64a2                	ld	s1,8(sp)
    800039c0:	6105                	addi	sp,sp,32
    800039c2:	8082                	ret

00000000800039c4 <ilock>:
{
    800039c4:	1101                	addi	sp,sp,-32
    800039c6:	ec06                	sd	ra,24(sp)
    800039c8:	e822                	sd	s0,16(sp)
    800039ca:	e426                	sd	s1,8(sp)
    800039cc:	e04a                	sd	s2,0(sp)
    800039ce:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800039d0:	c115                	beqz	a0,800039f4 <ilock+0x30>
    800039d2:	84aa                	mv	s1,a0
    800039d4:	451c                	lw	a5,8(a0)
    800039d6:	00f05f63          	blez	a5,800039f4 <ilock+0x30>
  acquiresleep(&ip->lock);
    800039da:	0541                	addi	a0,a0,16
    800039dc:	00001097          	auipc	ra,0x1
    800039e0:	ca8080e7          	jalr	-856(ra) # 80004684 <acquiresleep>
  if(ip->valid == 0){
    800039e4:	40bc                	lw	a5,64(s1)
    800039e6:	cf99                	beqz	a5,80003a04 <ilock+0x40>
}
    800039e8:	60e2                	ld	ra,24(sp)
    800039ea:	6442                	ld	s0,16(sp)
    800039ec:	64a2                	ld	s1,8(sp)
    800039ee:	6902                	ld	s2,0(sp)
    800039f0:	6105                	addi	sp,sp,32
    800039f2:	8082                	ret
    panic("ilock");
    800039f4:	00006517          	auipc	a0,0x6
    800039f8:	cd450513          	addi	a0,a0,-812 # 800096c8 <syscalls+0x278>
    800039fc:	ffffd097          	auipc	ra,0xffffd
    80003a00:	b44080e7          	jalr	-1212(ra) # 80000540 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003a04:	40dc                	lw	a5,4(s1)
    80003a06:	0047d79b          	srliw	a5,a5,0x4
    80003a0a:	0001d597          	auipc	a1,0x1d
    80003a0e:	f465a583          	lw	a1,-186(a1) # 80020950 <sb+0x18>
    80003a12:	9dbd                	addw	a1,a1,a5
    80003a14:	4088                	lw	a0,0(s1)
    80003a16:	fffff097          	auipc	ra,0xfffff
    80003a1a:	796080e7          	jalr	1942(ra) # 800031ac <bread>
    80003a1e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a20:	05850593          	addi	a1,a0,88
    80003a24:	40dc                	lw	a5,4(s1)
    80003a26:	8bbd                	andi	a5,a5,15
    80003a28:	079a                	slli	a5,a5,0x6
    80003a2a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003a2c:	00059783          	lh	a5,0(a1)
    80003a30:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003a34:	00259783          	lh	a5,2(a1)
    80003a38:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003a3c:	00459783          	lh	a5,4(a1)
    80003a40:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003a44:	00659783          	lh	a5,6(a1)
    80003a48:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003a4c:	459c                	lw	a5,8(a1)
    80003a4e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003a50:	03400613          	li	a2,52
    80003a54:	05b1                	addi	a1,a1,12
    80003a56:	05048513          	addi	a0,s1,80
    80003a5a:	ffffd097          	auipc	ra,0xffffd
    80003a5e:	2d4080e7          	jalr	724(ra) # 80000d2e <memmove>
    brelse(bp);
    80003a62:	854a                	mv	a0,s2
    80003a64:	00000097          	auipc	ra,0x0
    80003a68:	878080e7          	jalr	-1928(ra) # 800032dc <brelse>
    ip->valid = 1;
    80003a6c:	4785                	li	a5,1
    80003a6e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003a70:	04449783          	lh	a5,68(s1)
    80003a74:	fbb5                	bnez	a5,800039e8 <ilock+0x24>
      panic("ilock: no type");
    80003a76:	00006517          	auipc	a0,0x6
    80003a7a:	c5a50513          	addi	a0,a0,-934 # 800096d0 <syscalls+0x280>
    80003a7e:	ffffd097          	auipc	ra,0xffffd
    80003a82:	ac2080e7          	jalr	-1342(ra) # 80000540 <panic>

0000000080003a86 <iunlock>:
{
    80003a86:	1101                	addi	sp,sp,-32
    80003a88:	ec06                	sd	ra,24(sp)
    80003a8a:	e822                	sd	s0,16(sp)
    80003a8c:	e426                	sd	s1,8(sp)
    80003a8e:	e04a                	sd	s2,0(sp)
    80003a90:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003a92:	c905                	beqz	a0,80003ac2 <iunlock+0x3c>
    80003a94:	84aa                	mv	s1,a0
    80003a96:	01050913          	addi	s2,a0,16
    80003a9a:	854a                	mv	a0,s2
    80003a9c:	00001097          	auipc	ra,0x1
    80003aa0:	c82080e7          	jalr	-894(ra) # 8000471e <holdingsleep>
    80003aa4:	cd19                	beqz	a0,80003ac2 <iunlock+0x3c>
    80003aa6:	449c                	lw	a5,8(s1)
    80003aa8:	00f05d63          	blez	a5,80003ac2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003aac:	854a                	mv	a0,s2
    80003aae:	00001097          	auipc	ra,0x1
    80003ab2:	c2c080e7          	jalr	-980(ra) # 800046da <releasesleep>
}
    80003ab6:	60e2                	ld	ra,24(sp)
    80003ab8:	6442                	ld	s0,16(sp)
    80003aba:	64a2                	ld	s1,8(sp)
    80003abc:	6902                	ld	s2,0(sp)
    80003abe:	6105                	addi	sp,sp,32
    80003ac0:	8082                	ret
    panic("iunlock");
    80003ac2:	00006517          	auipc	a0,0x6
    80003ac6:	c1e50513          	addi	a0,a0,-994 # 800096e0 <syscalls+0x290>
    80003aca:	ffffd097          	auipc	ra,0xffffd
    80003ace:	a76080e7          	jalr	-1418(ra) # 80000540 <panic>

0000000080003ad2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003ad2:	7179                	addi	sp,sp,-48
    80003ad4:	f406                	sd	ra,40(sp)
    80003ad6:	f022                	sd	s0,32(sp)
    80003ad8:	ec26                	sd	s1,24(sp)
    80003ada:	e84a                	sd	s2,16(sp)
    80003adc:	e44e                	sd	s3,8(sp)
    80003ade:	e052                	sd	s4,0(sp)
    80003ae0:	1800                	addi	s0,sp,48
    80003ae2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003ae4:	05050493          	addi	s1,a0,80
    80003ae8:	08050913          	addi	s2,a0,128
    80003aec:	a021                	j	80003af4 <itrunc+0x22>
    80003aee:	0491                	addi	s1,s1,4
    80003af0:	01248d63          	beq	s1,s2,80003b0a <itrunc+0x38>
    if(ip->addrs[i]){
    80003af4:	408c                	lw	a1,0(s1)
    80003af6:	dde5                	beqz	a1,80003aee <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003af8:	0009a503          	lw	a0,0(s3)
    80003afc:	00000097          	auipc	ra,0x0
    80003b00:	8f6080e7          	jalr	-1802(ra) # 800033f2 <bfree>
      ip->addrs[i] = 0;
    80003b04:	0004a023          	sw	zero,0(s1)
    80003b08:	b7dd                	j	80003aee <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003b0a:	0809a583          	lw	a1,128(s3)
    80003b0e:	e185                	bnez	a1,80003b2e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003b10:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003b14:	854e                	mv	a0,s3
    80003b16:	00000097          	auipc	ra,0x0
    80003b1a:	de2080e7          	jalr	-542(ra) # 800038f8 <iupdate>
}
    80003b1e:	70a2                	ld	ra,40(sp)
    80003b20:	7402                	ld	s0,32(sp)
    80003b22:	64e2                	ld	s1,24(sp)
    80003b24:	6942                	ld	s2,16(sp)
    80003b26:	69a2                	ld	s3,8(sp)
    80003b28:	6a02                	ld	s4,0(sp)
    80003b2a:	6145                	addi	sp,sp,48
    80003b2c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003b2e:	0009a503          	lw	a0,0(s3)
    80003b32:	fffff097          	auipc	ra,0xfffff
    80003b36:	67a080e7          	jalr	1658(ra) # 800031ac <bread>
    80003b3a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003b3c:	05850493          	addi	s1,a0,88
    80003b40:	45850913          	addi	s2,a0,1112
    80003b44:	a021                	j	80003b4c <itrunc+0x7a>
    80003b46:	0491                	addi	s1,s1,4
    80003b48:	01248b63          	beq	s1,s2,80003b5e <itrunc+0x8c>
      if(a[j])
    80003b4c:	408c                	lw	a1,0(s1)
    80003b4e:	dde5                	beqz	a1,80003b46 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003b50:	0009a503          	lw	a0,0(s3)
    80003b54:	00000097          	auipc	ra,0x0
    80003b58:	89e080e7          	jalr	-1890(ra) # 800033f2 <bfree>
    80003b5c:	b7ed                	j	80003b46 <itrunc+0x74>
    brelse(bp);
    80003b5e:	8552                	mv	a0,s4
    80003b60:	fffff097          	auipc	ra,0xfffff
    80003b64:	77c080e7          	jalr	1916(ra) # 800032dc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003b68:	0809a583          	lw	a1,128(s3)
    80003b6c:	0009a503          	lw	a0,0(s3)
    80003b70:	00000097          	auipc	ra,0x0
    80003b74:	882080e7          	jalr	-1918(ra) # 800033f2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003b78:	0809a023          	sw	zero,128(s3)
    80003b7c:	bf51                	j	80003b10 <itrunc+0x3e>

0000000080003b7e <iput>:
{
    80003b7e:	1101                	addi	sp,sp,-32
    80003b80:	ec06                	sd	ra,24(sp)
    80003b82:	e822                	sd	s0,16(sp)
    80003b84:	e426                	sd	s1,8(sp)
    80003b86:	e04a                	sd	s2,0(sp)
    80003b88:	1000                	addi	s0,sp,32
    80003b8a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003b8c:	0001d517          	auipc	a0,0x1d
    80003b90:	dcc50513          	addi	a0,a0,-564 # 80020958 <itable>
    80003b94:	ffffd097          	auipc	ra,0xffffd
    80003b98:	042080e7          	jalr	66(ra) # 80000bd6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003b9c:	4498                	lw	a4,8(s1)
    80003b9e:	4785                	li	a5,1
    80003ba0:	02f70363          	beq	a4,a5,80003bc6 <iput+0x48>
  ip->ref--;
    80003ba4:	449c                	lw	a5,8(s1)
    80003ba6:	37fd                	addiw	a5,a5,-1
    80003ba8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003baa:	0001d517          	auipc	a0,0x1d
    80003bae:	dae50513          	addi	a0,a0,-594 # 80020958 <itable>
    80003bb2:	ffffd097          	auipc	ra,0xffffd
    80003bb6:	0d8080e7          	jalr	216(ra) # 80000c8a <release>
}
    80003bba:	60e2                	ld	ra,24(sp)
    80003bbc:	6442                	ld	s0,16(sp)
    80003bbe:	64a2                	ld	s1,8(sp)
    80003bc0:	6902                	ld	s2,0(sp)
    80003bc2:	6105                	addi	sp,sp,32
    80003bc4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003bc6:	40bc                	lw	a5,64(s1)
    80003bc8:	dff1                	beqz	a5,80003ba4 <iput+0x26>
    80003bca:	04a49783          	lh	a5,74(s1)
    80003bce:	fbf9                	bnez	a5,80003ba4 <iput+0x26>
    acquiresleep(&ip->lock);
    80003bd0:	01048913          	addi	s2,s1,16
    80003bd4:	854a                	mv	a0,s2
    80003bd6:	00001097          	auipc	ra,0x1
    80003bda:	aae080e7          	jalr	-1362(ra) # 80004684 <acquiresleep>
    release(&itable.lock);
    80003bde:	0001d517          	auipc	a0,0x1d
    80003be2:	d7a50513          	addi	a0,a0,-646 # 80020958 <itable>
    80003be6:	ffffd097          	auipc	ra,0xffffd
    80003bea:	0a4080e7          	jalr	164(ra) # 80000c8a <release>
    itrunc(ip);
    80003bee:	8526                	mv	a0,s1
    80003bf0:	00000097          	auipc	ra,0x0
    80003bf4:	ee2080e7          	jalr	-286(ra) # 80003ad2 <itrunc>
    ip->type = 0;
    80003bf8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003bfc:	8526                	mv	a0,s1
    80003bfe:	00000097          	auipc	ra,0x0
    80003c02:	cfa080e7          	jalr	-774(ra) # 800038f8 <iupdate>
    ip->valid = 0;
    80003c06:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003c0a:	854a                	mv	a0,s2
    80003c0c:	00001097          	auipc	ra,0x1
    80003c10:	ace080e7          	jalr	-1330(ra) # 800046da <releasesleep>
    acquire(&itable.lock);
    80003c14:	0001d517          	auipc	a0,0x1d
    80003c18:	d4450513          	addi	a0,a0,-700 # 80020958 <itable>
    80003c1c:	ffffd097          	auipc	ra,0xffffd
    80003c20:	fba080e7          	jalr	-70(ra) # 80000bd6 <acquire>
    80003c24:	b741                	j	80003ba4 <iput+0x26>

0000000080003c26 <iunlockput>:
{
    80003c26:	1101                	addi	sp,sp,-32
    80003c28:	ec06                	sd	ra,24(sp)
    80003c2a:	e822                	sd	s0,16(sp)
    80003c2c:	e426                	sd	s1,8(sp)
    80003c2e:	1000                	addi	s0,sp,32
    80003c30:	84aa                	mv	s1,a0
  iunlock(ip);
    80003c32:	00000097          	auipc	ra,0x0
    80003c36:	e54080e7          	jalr	-428(ra) # 80003a86 <iunlock>
  iput(ip);
    80003c3a:	8526                	mv	a0,s1
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	f42080e7          	jalr	-190(ra) # 80003b7e <iput>
}
    80003c44:	60e2                	ld	ra,24(sp)
    80003c46:	6442                	ld	s0,16(sp)
    80003c48:	64a2                	ld	s1,8(sp)
    80003c4a:	6105                	addi	sp,sp,32
    80003c4c:	8082                	ret

0000000080003c4e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003c4e:	1141                	addi	sp,sp,-16
    80003c50:	e422                	sd	s0,8(sp)
    80003c52:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003c54:	411c                	lw	a5,0(a0)
    80003c56:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003c58:	415c                	lw	a5,4(a0)
    80003c5a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003c5c:	04451783          	lh	a5,68(a0)
    80003c60:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003c64:	04a51783          	lh	a5,74(a0)
    80003c68:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003c6c:	04c56783          	lwu	a5,76(a0)
    80003c70:	e99c                	sd	a5,16(a1)
}
    80003c72:	6422                	ld	s0,8(sp)
    80003c74:	0141                	addi	sp,sp,16
    80003c76:	8082                	ret

0000000080003c78 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c78:	457c                	lw	a5,76(a0)
    80003c7a:	0ed7e963          	bltu	a5,a3,80003d6c <readi+0xf4>
{
    80003c7e:	7159                	addi	sp,sp,-112
    80003c80:	f486                	sd	ra,104(sp)
    80003c82:	f0a2                	sd	s0,96(sp)
    80003c84:	eca6                	sd	s1,88(sp)
    80003c86:	e8ca                	sd	s2,80(sp)
    80003c88:	e4ce                	sd	s3,72(sp)
    80003c8a:	e0d2                	sd	s4,64(sp)
    80003c8c:	fc56                	sd	s5,56(sp)
    80003c8e:	f85a                	sd	s6,48(sp)
    80003c90:	f45e                	sd	s7,40(sp)
    80003c92:	f062                	sd	s8,32(sp)
    80003c94:	ec66                	sd	s9,24(sp)
    80003c96:	e86a                	sd	s10,16(sp)
    80003c98:	e46e                	sd	s11,8(sp)
    80003c9a:	1880                	addi	s0,sp,112
    80003c9c:	8b2a                	mv	s6,a0
    80003c9e:	8bae                	mv	s7,a1
    80003ca0:	8a32                	mv	s4,a2
    80003ca2:	84b6                	mv	s1,a3
    80003ca4:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003ca6:	9f35                	addw	a4,a4,a3
    return 0;
    80003ca8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003caa:	0ad76063          	bltu	a4,a3,80003d4a <readi+0xd2>
  if(off + n > ip->size)
    80003cae:	00e7f463          	bgeu	a5,a4,80003cb6 <readi+0x3e>
    n = ip->size - off;
    80003cb2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003cb6:	0a0a8963          	beqz	s5,80003d68 <readi+0xf0>
    80003cba:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003cbc:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003cc0:	5c7d                	li	s8,-1
    80003cc2:	a82d                	j	80003cfc <readi+0x84>
    80003cc4:	020d1d93          	slli	s11,s10,0x20
    80003cc8:	020ddd93          	srli	s11,s11,0x20
    80003ccc:	05890613          	addi	a2,s2,88
    80003cd0:	86ee                	mv	a3,s11
    80003cd2:	963a                	add	a2,a2,a4
    80003cd4:	85d2                	mv	a1,s4
    80003cd6:	855e                	mv	a0,s7
    80003cd8:	ffffe097          	auipc	ra,0xffffe
    80003cdc:	7a8080e7          	jalr	1960(ra) # 80002480 <either_copyout>
    80003ce0:	05850d63          	beq	a0,s8,80003d3a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ce4:	854a                	mv	a0,s2
    80003ce6:	fffff097          	auipc	ra,0xfffff
    80003cea:	5f6080e7          	jalr	1526(ra) # 800032dc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003cee:	013d09bb          	addw	s3,s10,s3
    80003cf2:	009d04bb          	addw	s1,s10,s1
    80003cf6:	9a6e                	add	s4,s4,s11
    80003cf8:	0559f763          	bgeu	s3,s5,80003d46 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003cfc:	00a4d59b          	srliw	a1,s1,0xa
    80003d00:	855a                	mv	a0,s6
    80003d02:	00000097          	auipc	ra,0x0
    80003d06:	89e080e7          	jalr	-1890(ra) # 800035a0 <bmap>
    80003d0a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003d0e:	cd85                	beqz	a1,80003d46 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003d10:	000b2503          	lw	a0,0(s6)
    80003d14:	fffff097          	auipc	ra,0xfffff
    80003d18:	498080e7          	jalr	1176(ra) # 800031ac <bread>
    80003d1c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d1e:	3ff4f713          	andi	a4,s1,1023
    80003d22:	40ec87bb          	subw	a5,s9,a4
    80003d26:	413a86bb          	subw	a3,s5,s3
    80003d2a:	8d3e                	mv	s10,a5
    80003d2c:	2781                	sext.w	a5,a5
    80003d2e:	0006861b          	sext.w	a2,a3
    80003d32:	f8f679e3          	bgeu	a2,a5,80003cc4 <readi+0x4c>
    80003d36:	8d36                	mv	s10,a3
    80003d38:	b771                	j	80003cc4 <readi+0x4c>
      brelse(bp);
    80003d3a:	854a                	mv	a0,s2
    80003d3c:	fffff097          	auipc	ra,0xfffff
    80003d40:	5a0080e7          	jalr	1440(ra) # 800032dc <brelse>
      tot = -1;
    80003d44:	59fd                	li	s3,-1
  }
  return tot;
    80003d46:	0009851b          	sext.w	a0,s3
}
    80003d4a:	70a6                	ld	ra,104(sp)
    80003d4c:	7406                	ld	s0,96(sp)
    80003d4e:	64e6                	ld	s1,88(sp)
    80003d50:	6946                	ld	s2,80(sp)
    80003d52:	69a6                	ld	s3,72(sp)
    80003d54:	6a06                	ld	s4,64(sp)
    80003d56:	7ae2                	ld	s5,56(sp)
    80003d58:	7b42                	ld	s6,48(sp)
    80003d5a:	7ba2                	ld	s7,40(sp)
    80003d5c:	7c02                	ld	s8,32(sp)
    80003d5e:	6ce2                	ld	s9,24(sp)
    80003d60:	6d42                	ld	s10,16(sp)
    80003d62:	6da2                	ld	s11,8(sp)
    80003d64:	6165                	addi	sp,sp,112
    80003d66:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d68:	89d6                	mv	s3,s5
    80003d6a:	bff1                	j	80003d46 <readi+0xce>
    return 0;
    80003d6c:	4501                	li	a0,0
}
    80003d6e:	8082                	ret

0000000080003d70 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003d70:	457c                	lw	a5,76(a0)
    80003d72:	10d7e863          	bltu	a5,a3,80003e82 <writei+0x112>
{
    80003d76:	7159                	addi	sp,sp,-112
    80003d78:	f486                	sd	ra,104(sp)
    80003d7a:	f0a2                	sd	s0,96(sp)
    80003d7c:	eca6                	sd	s1,88(sp)
    80003d7e:	e8ca                	sd	s2,80(sp)
    80003d80:	e4ce                	sd	s3,72(sp)
    80003d82:	e0d2                	sd	s4,64(sp)
    80003d84:	fc56                	sd	s5,56(sp)
    80003d86:	f85a                	sd	s6,48(sp)
    80003d88:	f45e                	sd	s7,40(sp)
    80003d8a:	f062                	sd	s8,32(sp)
    80003d8c:	ec66                	sd	s9,24(sp)
    80003d8e:	e86a                	sd	s10,16(sp)
    80003d90:	e46e                	sd	s11,8(sp)
    80003d92:	1880                	addi	s0,sp,112
    80003d94:	8aaa                	mv	s5,a0
    80003d96:	8bae                	mv	s7,a1
    80003d98:	8a32                	mv	s4,a2
    80003d9a:	8936                	mv	s2,a3
    80003d9c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003d9e:	00e687bb          	addw	a5,a3,a4
    80003da2:	0ed7e263          	bltu	a5,a3,80003e86 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003da6:	00043737          	lui	a4,0x43
    80003daa:	0ef76063          	bltu	a4,a5,80003e8a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003dae:	0c0b0863          	beqz	s6,80003e7e <writei+0x10e>
    80003db2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003db4:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003db8:	5c7d                	li	s8,-1
    80003dba:	a091                	j	80003dfe <writei+0x8e>
    80003dbc:	020d1d93          	slli	s11,s10,0x20
    80003dc0:	020ddd93          	srli	s11,s11,0x20
    80003dc4:	05848513          	addi	a0,s1,88
    80003dc8:	86ee                	mv	a3,s11
    80003dca:	8652                	mv	a2,s4
    80003dcc:	85de                	mv	a1,s7
    80003dce:	953a                	add	a0,a0,a4
    80003dd0:	ffffe097          	auipc	ra,0xffffe
    80003dd4:	706080e7          	jalr	1798(ra) # 800024d6 <either_copyin>
    80003dd8:	07850263          	beq	a0,s8,80003e3c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003ddc:	8526                	mv	a0,s1
    80003dde:	00000097          	auipc	ra,0x0
    80003de2:	788080e7          	jalr	1928(ra) # 80004566 <log_write>
    brelse(bp);
    80003de6:	8526                	mv	a0,s1
    80003de8:	fffff097          	auipc	ra,0xfffff
    80003dec:	4f4080e7          	jalr	1268(ra) # 800032dc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003df0:	013d09bb          	addw	s3,s10,s3
    80003df4:	012d093b          	addw	s2,s10,s2
    80003df8:	9a6e                	add	s4,s4,s11
    80003dfa:	0569f663          	bgeu	s3,s6,80003e46 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003dfe:	00a9559b          	srliw	a1,s2,0xa
    80003e02:	8556                	mv	a0,s5
    80003e04:	fffff097          	auipc	ra,0xfffff
    80003e08:	79c080e7          	jalr	1948(ra) # 800035a0 <bmap>
    80003e0c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003e10:	c99d                	beqz	a1,80003e46 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003e12:	000aa503          	lw	a0,0(s5)
    80003e16:	fffff097          	auipc	ra,0xfffff
    80003e1a:	396080e7          	jalr	918(ra) # 800031ac <bread>
    80003e1e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e20:	3ff97713          	andi	a4,s2,1023
    80003e24:	40ec87bb          	subw	a5,s9,a4
    80003e28:	413b06bb          	subw	a3,s6,s3
    80003e2c:	8d3e                	mv	s10,a5
    80003e2e:	2781                	sext.w	a5,a5
    80003e30:	0006861b          	sext.w	a2,a3
    80003e34:	f8f674e3          	bgeu	a2,a5,80003dbc <writei+0x4c>
    80003e38:	8d36                	mv	s10,a3
    80003e3a:	b749                	j	80003dbc <writei+0x4c>
      brelse(bp);
    80003e3c:	8526                	mv	a0,s1
    80003e3e:	fffff097          	auipc	ra,0xfffff
    80003e42:	49e080e7          	jalr	1182(ra) # 800032dc <brelse>
  }

  if(off > ip->size)
    80003e46:	04caa783          	lw	a5,76(s5)
    80003e4a:	0127f463          	bgeu	a5,s2,80003e52 <writei+0xe2>
    ip->size = off;
    80003e4e:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003e52:	8556                	mv	a0,s5
    80003e54:	00000097          	auipc	ra,0x0
    80003e58:	aa4080e7          	jalr	-1372(ra) # 800038f8 <iupdate>

  return tot;
    80003e5c:	0009851b          	sext.w	a0,s3
}
    80003e60:	70a6                	ld	ra,104(sp)
    80003e62:	7406                	ld	s0,96(sp)
    80003e64:	64e6                	ld	s1,88(sp)
    80003e66:	6946                	ld	s2,80(sp)
    80003e68:	69a6                	ld	s3,72(sp)
    80003e6a:	6a06                	ld	s4,64(sp)
    80003e6c:	7ae2                	ld	s5,56(sp)
    80003e6e:	7b42                	ld	s6,48(sp)
    80003e70:	7ba2                	ld	s7,40(sp)
    80003e72:	7c02                	ld	s8,32(sp)
    80003e74:	6ce2                	ld	s9,24(sp)
    80003e76:	6d42                	ld	s10,16(sp)
    80003e78:	6da2                	ld	s11,8(sp)
    80003e7a:	6165                	addi	sp,sp,112
    80003e7c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e7e:	89da                	mv	s3,s6
    80003e80:	bfc9                	j	80003e52 <writei+0xe2>
    return -1;
    80003e82:	557d                	li	a0,-1
}
    80003e84:	8082                	ret
    return -1;
    80003e86:	557d                	li	a0,-1
    80003e88:	bfe1                	j	80003e60 <writei+0xf0>
    return -1;
    80003e8a:	557d                	li	a0,-1
    80003e8c:	bfd1                	j	80003e60 <writei+0xf0>

0000000080003e8e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003e8e:	1141                	addi	sp,sp,-16
    80003e90:	e406                	sd	ra,8(sp)
    80003e92:	e022                	sd	s0,0(sp)
    80003e94:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003e96:	4639                	li	a2,14
    80003e98:	ffffd097          	auipc	ra,0xffffd
    80003e9c:	f0a080e7          	jalr	-246(ra) # 80000da2 <strncmp>
}
    80003ea0:	60a2                	ld	ra,8(sp)
    80003ea2:	6402                	ld	s0,0(sp)
    80003ea4:	0141                	addi	sp,sp,16
    80003ea6:	8082                	ret

0000000080003ea8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003ea8:	7139                	addi	sp,sp,-64
    80003eaa:	fc06                	sd	ra,56(sp)
    80003eac:	f822                	sd	s0,48(sp)
    80003eae:	f426                	sd	s1,40(sp)
    80003eb0:	f04a                	sd	s2,32(sp)
    80003eb2:	ec4e                	sd	s3,24(sp)
    80003eb4:	e852                	sd	s4,16(sp)
    80003eb6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003eb8:	04451703          	lh	a4,68(a0)
    80003ebc:	4785                	li	a5,1
    80003ebe:	00f71a63          	bne	a4,a5,80003ed2 <dirlookup+0x2a>
    80003ec2:	892a                	mv	s2,a0
    80003ec4:	89ae                	mv	s3,a1
    80003ec6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ec8:	457c                	lw	a5,76(a0)
    80003eca:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003ecc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ece:	e79d                	bnez	a5,80003efc <dirlookup+0x54>
    80003ed0:	a8a5                	j	80003f48 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003ed2:	00006517          	auipc	a0,0x6
    80003ed6:	81650513          	addi	a0,a0,-2026 # 800096e8 <syscalls+0x298>
    80003eda:	ffffc097          	auipc	ra,0xffffc
    80003ede:	666080e7          	jalr	1638(ra) # 80000540 <panic>
      panic("dirlookup read");
    80003ee2:	00006517          	auipc	a0,0x6
    80003ee6:	81e50513          	addi	a0,a0,-2018 # 80009700 <syscalls+0x2b0>
    80003eea:	ffffc097          	auipc	ra,0xffffc
    80003eee:	656080e7          	jalr	1622(ra) # 80000540 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ef2:	24c1                	addiw	s1,s1,16
    80003ef4:	04c92783          	lw	a5,76(s2)
    80003ef8:	04f4f763          	bgeu	s1,a5,80003f46 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003efc:	4741                	li	a4,16
    80003efe:	86a6                	mv	a3,s1
    80003f00:	fc040613          	addi	a2,s0,-64
    80003f04:	4581                	li	a1,0
    80003f06:	854a                	mv	a0,s2
    80003f08:	00000097          	auipc	ra,0x0
    80003f0c:	d70080e7          	jalr	-656(ra) # 80003c78 <readi>
    80003f10:	47c1                	li	a5,16
    80003f12:	fcf518e3          	bne	a0,a5,80003ee2 <dirlookup+0x3a>
    if(de.inum == 0)
    80003f16:	fc045783          	lhu	a5,-64(s0)
    80003f1a:	dfe1                	beqz	a5,80003ef2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003f1c:	fc240593          	addi	a1,s0,-62
    80003f20:	854e                	mv	a0,s3
    80003f22:	00000097          	auipc	ra,0x0
    80003f26:	f6c080e7          	jalr	-148(ra) # 80003e8e <namecmp>
    80003f2a:	f561                	bnez	a0,80003ef2 <dirlookup+0x4a>
      if(poff)
    80003f2c:	000a0463          	beqz	s4,80003f34 <dirlookup+0x8c>
        *poff = off;
    80003f30:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003f34:	fc045583          	lhu	a1,-64(s0)
    80003f38:	00092503          	lw	a0,0(s2)
    80003f3c:	fffff097          	auipc	ra,0xfffff
    80003f40:	74e080e7          	jalr	1870(ra) # 8000368a <iget>
    80003f44:	a011                	j	80003f48 <dirlookup+0xa0>
  return 0;
    80003f46:	4501                	li	a0,0
}
    80003f48:	70e2                	ld	ra,56(sp)
    80003f4a:	7442                	ld	s0,48(sp)
    80003f4c:	74a2                	ld	s1,40(sp)
    80003f4e:	7902                	ld	s2,32(sp)
    80003f50:	69e2                	ld	s3,24(sp)
    80003f52:	6a42                	ld	s4,16(sp)
    80003f54:	6121                	addi	sp,sp,64
    80003f56:	8082                	ret

0000000080003f58 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003f58:	711d                	addi	sp,sp,-96
    80003f5a:	ec86                	sd	ra,88(sp)
    80003f5c:	e8a2                	sd	s0,80(sp)
    80003f5e:	e4a6                	sd	s1,72(sp)
    80003f60:	e0ca                	sd	s2,64(sp)
    80003f62:	fc4e                	sd	s3,56(sp)
    80003f64:	f852                	sd	s4,48(sp)
    80003f66:	f456                	sd	s5,40(sp)
    80003f68:	f05a                	sd	s6,32(sp)
    80003f6a:	ec5e                	sd	s7,24(sp)
    80003f6c:	e862                	sd	s8,16(sp)
    80003f6e:	e466                	sd	s9,8(sp)
    80003f70:	e06a                	sd	s10,0(sp)
    80003f72:	1080                	addi	s0,sp,96
    80003f74:	84aa                	mv	s1,a0
    80003f76:	8b2e                	mv	s6,a1
    80003f78:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003f7a:	00054703          	lbu	a4,0(a0)
    80003f7e:	02f00793          	li	a5,47
    80003f82:	02f70363          	beq	a4,a5,80003fa8 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003f86:	ffffe097          	auipc	ra,0xffffe
    80003f8a:	a26080e7          	jalr	-1498(ra) # 800019ac <myproc>
    80003f8e:	15053503          	ld	a0,336(a0)
    80003f92:	00000097          	auipc	ra,0x0
    80003f96:	9f4080e7          	jalr	-1548(ra) # 80003986 <idup>
    80003f9a:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003f9c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003fa0:	4cb5                	li	s9,13
  len = path - s;
    80003fa2:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003fa4:	4c05                	li	s8,1
    80003fa6:	a87d                	j	80004064 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003fa8:	4585                	li	a1,1
    80003faa:	4505                	li	a0,1
    80003fac:	fffff097          	auipc	ra,0xfffff
    80003fb0:	6de080e7          	jalr	1758(ra) # 8000368a <iget>
    80003fb4:	8a2a                	mv	s4,a0
    80003fb6:	b7dd                	j	80003f9c <namex+0x44>
      iunlockput(ip);
    80003fb8:	8552                	mv	a0,s4
    80003fba:	00000097          	auipc	ra,0x0
    80003fbe:	c6c080e7          	jalr	-916(ra) # 80003c26 <iunlockput>
      return 0;
    80003fc2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003fc4:	8552                	mv	a0,s4
    80003fc6:	60e6                	ld	ra,88(sp)
    80003fc8:	6446                	ld	s0,80(sp)
    80003fca:	64a6                	ld	s1,72(sp)
    80003fcc:	6906                	ld	s2,64(sp)
    80003fce:	79e2                	ld	s3,56(sp)
    80003fd0:	7a42                	ld	s4,48(sp)
    80003fd2:	7aa2                	ld	s5,40(sp)
    80003fd4:	7b02                	ld	s6,32(sp)
    80003fd6:	6be2                	ld	s7,24(sp)
    80003fd8:	6c42                	ld	s8,16(sp)
    80003fda:	6ca2                	ld	s9,8(sp)
    80003fdc:	6d02                	ld	s10,0(sp)
    80003fde:	6125                	addi	sp,sp,96
    80003fe0:	8082                	ret
      iunlock(ip);
    80003fe2:	8552                	mv	a0,s4
    80003fe4:	00000097          	auipc	ra,0x0
    80003fe8:	aa2080e7          	jalr	-1374(ra) # 80003a86 <iunlock>
      return ip;
    80003fec:	bfe1                	j	80003fc4 <namex+0x6c>
      iunlockput(ip);
    80003fee:	8552                	mv	a0,s4
    80003ff0:	00000097          	auipc	ra,0x0
    80003ff4:	c36080e7          	jalr	-970(ra) # 80003c26 <iunlockput>
      return 0;
    80003ff8:	8a4e                	mv	s4,s3
    80003ffa:	b7e9                	j	80003fc4 <namex+0x6c>
  len = path - s;
    80003ffc:	40998633          	sub	a2,s3,s1
    80004000:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004004:	09acd863          	bge	s9,s10,80004094 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80004008:	4639                	li	a2,14
    8000400a:	85a6                	mv	a1,s1
    8000400c:	8556                	mv	a0,s5
    8000400e:	ffffd097          	auipc	ra,0xffffd
    80004012:	d20080e7          	jalr	-736(ra) # 80000d2e <memmove>
    80004016:	84ce                	mv	s1,s3
  while(*path == '/')
    80004018:	0004c783          	lbu	a5,0(s1)
    8000401c:	01279763          	bne	a5,s2,8000402a <namex+0xd2>
    path++;
    80004020:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004022:	0004c783          	lbu	a5,0(s1)
    80004026:	ff278de3          	beq	a5,s2,80004020 <namex+0xc8>
    ilock(ip);
    8000402a:	8552                	mv	a0,s4
    8000402c:	00000097          	auipc	ra,0x0
    80004030:	998080e7          	jalr	-1640(ra) # 800039c4 <ilock>
    if(ip->type != T_DIR){
    80004034:	044a1783          	lh	a5,68(s4)
    80004038:	f98790e3          	bne	a5,s8,80003fb8 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000403c:	000b0563          	beqz	s6,80004046 <namex+0xee>
    80004040:	0004c783          	lbu	a5,0(s1)
    80004044:	dfd9                	beqz	a5,80003fe2 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004046:	865e                	mv	a2,s7
    80004048:	85d6                	mv	a1,s5
    8000404a:	8552                	mv	a0,s4
    8000404c:	00000097          	auipc	ra,0x0
    80004050:	e5c080e7          	jalr	-420(ra) # 80003ea8 <dirlookup>
    80004054:	89aa                	mv	s3,a0
    80004056:	dd41                	beqz	a0,80003fee <namex+0x96>
    iunlockput(ip);
    80004058:	8552                	mv	a0,s4
    8000405a:	00000097          	auipc	ra,0x0
    8000405e:	bcc080e7          	jalr	-1076(ra) # 80003c26 <iunlockput>
    ip = next;
    80004062:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004064:	0004c783          	lbu	a5,0(s1)
    80004068:	01279763          	bne	a5,s2,80004076 <namex+0x11e>
    path++;
    8000406c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000406e:	0004c783          	lbu	a5,0(s1)
    80004072:	ff278de3          	beq	a5,s2,8000406c <namex+0x114>
  if(*path == 0)
    80004076:	cb9d                	beqz	a5,800040ac <namex+0x154>
  while(*path != '/' && *path != 0)
    80004078:	0004c783          	lbu	a5,0(s1)
    8000407c:	89a6                	mv	s3,s1
  len = path - s;
    8000407e:	8d5e                	mv	s10,s7
    80004080:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80004082:	01278963          	beq	a5,s2,80004094 <namex+0x13c>
    80004086:	dbbd                	beqz	a5,80003ffc <namex+0xa4>
    path++;
    80004088:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000408a:	0009c783          	lbu	a5,0(s3)
    8000408e:	ff279ce3          	bne	a5,s2,80004086 <namex+0x12e>
    80004092:	b7ad                	j	80003ffc <namex+0xa4>
    memmove(name, s, len);
    80004094:	2601                	sext.w	a2,a2
    80004096:	85a6                	mv	a1,s1
    80004098:	8556                	mv	a0,s5
    8000409a:	ffffd097          	auipc	ra,0xffffd
    8000409e:	c94080e7          	jalr	-876(ra) # 80000d2e <memmove>
    name[len] = 0;
    800040a2:	9d56                	add	s10,s10,s5
    800040a4:	000d0023          	sb	zero,0(s10)
    800040a8:	84ce                	mv	s1,s3
    800040aa:	b7bd                	j	80004018 <namex+0xc0>
  if(nameiparent){
    800040ac:	f00b0ce3          	beqz	s6,80003fc4 <namex+0x6c>
    iput(ip);
    800040b0:	8552                	mv	a0,s4
    800040b2:	00000097          	auipc	ra,0x0
    800040b6:	acc080e7          	jalr	-1332(ra) # 80003b7e <iput>
    return 0;
    800040ba:	4a01                	li	s4,0
    800040bc:	b721                	j	80003fc4 <namex+0x6c>

00000000800040be <dirlink>:
{
    800040be:	7139                	addi	sp,sp,-64
    800040c0:	fc06                	sd	ra,56(sp)
    800040c2:	f822                	sd	s0,48(sp)
    800040c4:	f426                	sd	s1,40(sp)
    800040c6:	f04a                	sd	s2,32(sp)
    800040c8:	ec4e                	sd	s3,24(sp)
    800040ca:	e852                	sd	s4,16(sp)
    800040cc:	0080                	addi	s0,sp,64
    800040ce:	892a                	mv	s2,a0
    800040d0:	8a2e                	mv	s4,a1
    800040d2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800040d4:	4601                	li	a2,0
    800040d6:	00000097          	auipc	ra,0x0
    800040da:	dd2080e7          	jalr	-558(ra) # 80003ea8 <dirlookup>
    800040de:	e93d                	bnez	a0,80004154 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040e0:	04c92483          	lw	s1,76(s2)
    800040e4:	c49d                	beqz	s1,80004112 <dirlink+0x54>
    800040e6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040e8:	4741                	li	a4,16
    800040ea:	86a6                	mv	a3,s1
    800040ec:	fc040613          	addi	a2,s0,-64
    800040f0:	4581                	li	a1,0
    800040f2:	854a                	mv	a0,s2
    800040f4:	00000097          	auipc	ra,0x0
    800040f8:	b84080e7          	jalr	-1148(ra) # 80003c78 <readi>
    800040fc:	47c1                	li	a5,16
    800040fe:	06f51163          	bne	a0,a5,80004160 <dirlink+0xa2>
    if(de.inum == 0)
    80004102:	fc045783          	lhu	a5,-64(s0)
    80004106:	c791                	beqz	a5,80004112 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004108:	24c1                	addiw	s1,s1,16
    8000410a:	04c92783          	lw	a5,76(s2)
    8000410e:	fcf4ede3          	bltu	s1,a5,800040e8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004112:	4639                	li	a2,14
    80004114:	85d2                	mv	a1,s4
    80004116:	fc240513          	addi	a0,s0,-62
    8000411a:	ffffd097          	auipc	ra,0xffffd
    8000411e:	cc4080e7          	jalr	-828(ra) # 80000dde <strncpy>
  de.inum = inum;
    80004122:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004126:	4741                	li	a4,16
    80004128:	86a6                	mv	a3,s1
    8000412a:	fc040613          	addi	a2,s0,-64
    8000412e:	4581                	li	a1,0
    80004130:	854a                	mv	a0,s2
    80004132:	00000097          	auipc	ra,0x0
    80004136:	c3e080e7          	jalr	-962(ra) # 80003d70 <writei>
    8000413a:	1541                	addi	a0,a0,-16
    8000413c:	00a03533          	snez	a0,a0
    80004140:	40a00533          	neg	a0,a0
}
    80004144:	70e2                	ld	ra,56(sp)
    80004146:	7442                	ld	s0,48(sp)
    80004148:	74a2                	ld	s1,40(sp)
    8000414a:	7902                	ld	s2,32(sp)
    8000414c:	69e2                	ld	s3,24(sp)
    8000414e:	6a42                	ld	s4,16(sp)
    80004150:	6121                	addi	sp,sp,64
    80004152:	8082                	ret
    iput(ip);
    80004154:	00000097          	auipc	ra,0x0
    80004158:	a2a080e7          	jalr	-1494(ra) # 80003b7e <iput>
    return -1;
    8000415c:	557d                	li	a0,-1
    8000415e:	b7dd                	j	80004144 <dirlink+0x86>
      panic("dirlink read");
    80004160:	00005517          	auipc	a0,0x5
    80004164:	5b050513          	addi	a0,a0,1456 # 80009710 <syscalls+0x2c0>
    80004168:	ffffc097          	auipc	ra,0xffffc
    8000416c:	3d8080e7          	jalr	984(ra) # 80000540 <panic>

0000000080004170 <namei>:

struct inode*
namei(char *path)
{
    80004170:	1101                	addi	sp,sp,-32
    80004172:	ec06                	sd	ra,24(sp)
    80004174:	e822                	sd	s0,16(sp)
    80004176:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004178:	fe040613          	addi	a2,s0,-32
    8000417c:	4581                	li	a1,0
    8000417e:	00000097          	auipc	ra,0x0
    80004182:	dda080e7          	jalr	-550(ra) # 80003f58 <namex>
}
    80004186:	60e2                	ld	ra,24(sp)
    80004188:	6442                	ld	s0,16(sp)
    8000418a:	6105                	addi	sp,sp,32
    8000418c:	8082                	ret

000000008000418e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000418e:	1141                	addi	sp,sp,-16
    80004190:	e406                	sd	ra,8(sp)
    80004192:	e022                	sd	s0,0(sp)
    80004194:	0800                	addi	s0,sp,16
    80004196:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004198:	4585                	li	a1,1
    8000419a:	00000097          	auipc	ra,0x0
    8000419e:	dbe080e7          	jalr	-578(ra) # 80003f58 <namex>
}
    800041a2:	60a2                	ld	ra,8(sp)
    800041a4:	6402                	ld	s0,0(sp)
    800041a6:	0141                	addi	sp,sp,16
    800041a8:	8082                	ret

00000000800041aa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800041aa:	1101                	addi	sp,sp,-32
    800041ac:	ec06                	sd	ra,24(sp)
    800041ae:	e822                	sd	s0,16(sp)
    800041b0:	e426                	sd	s1,8(sp)
    800041b2:	e04a                	sd	s2,0(sp)
    800041b4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800041b6:	0001e917          	auipc	s2,0x1e
    800041ba:	24a90913          	addi	s2,s2,586 # 80022400 <log>
    800041be:	01892583          	lw	a1,24(s2)
    800041c2:	02892503          	lw	a0,40(s2)
    800041c6:	fffff097          	auipc	ra,0xfffff
    800041ca:	fe6080e7          	jalr	-26(ra) # 800031ac <bread>
    800041ce:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800041d0:	02c92683          	lw	a3,44(s2)
    800041d4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800041d6:	02d05863          	blez	a3,80004206 <write_head+0x5c>
    800041da:	0001e797          	auipc	a5,0x1e
    800041de:	25678793          	addi	a5,a5,598 # 80022430 <log+0x30>
    800041e2:	05c50713          	addi	a4,a0,92
    800041e6:	36fd                	addiw	a3,a3,-1
    800041e8:	02069613          	slli	a2,a3,0x20
    800041ec:	01e65693          	srli	a3,a2,0x1e
    800041f0:	0001e617          	auipc	a2,0x1e
    800041f4:	24460613          	addi	a2,a2,580 # 80022434 <log+0x34>
    800041f8:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800041fa:	4390                	lw	a2,0(a5)
    800041fc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800041fe:	0791                	addi	a5,a5,4
    80004200:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80004202:	fed79ce3          	bne	a5,a3,800041fa <write_head+0x50>
  }
  bwrite(buf);
    80004206:	8526                	mv	a0,s1
    80004208:	fffff097          	auipc	ra,0xfffff
    8000420c:	096080e7          	jalr	150(ra) # 8000329e <bwrite>
  brelse(buf);
    80004210:	8526                	mv	a0,s1
    80004212:	fffff097          	auipc	ra,0xfffff
    80004216:	0ca080e7          	jalr	202(ra) # 800032dc <brelse>
}
    8000421a:	60e2                	ld	ra,24(sp)
    8000421c:	6442                	ld	s0,16(sp)
    8000421e:	64a2                	ld	s1,8(sp)
    80004220:	6902                	ld	s2,0(sp)
    80004222:	6105                	addi	sp,sp,32
    80004224:	8082                	ret

0000000080004226 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004226:	0001e797          	auipc	a5,0x1e
    8000422a:	2067a783          	lw	a5,518(a5) # 8002242c <log+0x2c>
    8000422e:	0af05d63          	blez	a5,800042e8 <install_trans+0xc2>
{
    80004232:	7139                	addi	sp,sp,-64
    80004234:	fc06                	sd	ra,56(sp)
    80004236:	f822                	sd	s0,48(sp)
    80004238:	f426                	sd	s1,40(sp)
    8000423a:	f04a                	sd	s2,32(sp)
    8000423c:	ec4e                	sd	s3,24(sp)
    8000423e:	e852                	sd	s4,16(sp)
    80004240:	e456                	sd	s5,8(sp)
    80004242:	e05a                	sd	s6,0(sp)
    80004244:	0080                	addi	s0,sp,64
    80004246:	8b2a                	mv	s6,a0
    80004248:	0001ea97          	auipc	s5,0x1e
    8000424c:	1e8a8a93          	addi	s5,s5,488 # 80022430 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004250:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004252:	0001e997          	auipc	s3,0x1e
    80004256:	1ae98993          	addi	s3,s3,430 # 80022400 <log>
    8000425a:	a00d                	j	8000427c <install_trans+0x56>
    brelse(lbuf);
    8000425c:	854a                	mv	a0,s2
    8000425e:	fffff097          	auipc	ra,0xfffff
    80004262:	07e080e7          	jalr	126(ra) # 800032dc <brelse>
    brelse(dbuf);
    80004266:	8526                	mv	a0,s1
    80004268:	fffff097          	auipc	ra,0xfffff
    8000426c:	074080e7          	jalr	116(ra) # 800032dc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004270:	2a05                	addiw	s4,s4,1
    80004272:	0a91                	addi	s5,s5,4
    80004274:	02c9a783          	lw	a5,44(s3)
    80004278:	04fa5e63          	bge	s4,a5,800042d4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000427c:	0189a583          	lw	a1,24(s3)
    80004280:	014585bb          	addw	a1,a1,s4
    80004284:	2585                	addiw	a1,a1,1
    80004286:	0289a503          	lw	a0,40(s3)
    8000428a:	fffff097          	auipc	ra,0xfffff
    8000428e:	f22080e7          	jalr	-222(ra) # 800031ac <bread>
    80004292:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004294:	000aa583          	lw	a1,0(s5)
    80004298:	0289a503          	lw	a0,40(s3)
    8000429c:	fffff097          	auipc	ra,0xfffff
    800042a0:	f10080e7          	jalr	-240(ra) # 800031ac <bread>
    800042a4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800042a6:	40000613          	li	a2,1024
    800042aa:	05890593          	addi	a1,s2,88
    800042ae:	05850513          	addi	a0,a0,88
    800042b2:	ffffd097          	auipc	ra,0xffffd
    800042b6:	a7c080e7          	jalr	-1412(ra) # 80000d2e <memmove>
    bwrite(dbuf);  // write dst to disk
    800042ba:	8526                	mv	a0,s1
    800042bc:	fffff097          	auipc	ra,0xfffff
    800042c0:	fe2080e7          	jalr	-30(ra) # 8000329e <bwrite>
    if(recovering == 0)
    800042c4:	f80b1ce3          	bnez	s6,8000425c <install_trans+0x36>
      bunpin(dbuf);
    800042c8:	8526                	mv	a0,s1
    800042ca:	fffff097          	auipc	ra,0xfffff
    800042ce:	0ec080e7          	jalr	236(ra) # 800033b6 <bunpin>
    800042d2:	b769                	j	8000425c <install_trans+0x36>
}
    800042d4:	70e2                	ld	ra,56(sp)
    800042d6:	7442                	ld	s0,48(sp)
    800042d8:	74a2                	ld	s1,40(sp)
    800042da:	7902                	ld	s2,32(sp)
    800042dc:	69e2                	ld	s3,24(sp)
    800042de:	6a42                	ld	s4,16(sp)
    800042e0:	6aa2                	ld	s5,8(sp)
    800042e2:	6b02                	ld	s6,0(sp)
    800042e4:	6121                	addi	sp,sp,64
    800042e6:	8082                	ret
    800042e8:	8082                	ret

00000000800042ea <initlog>:
{
    800042ea:	7179                	addi	sp,sp,-48
    800042ec:	f406                	sd	ra,40(sp)
    800042ee:	f022                	sd	s0,32(sp)
    800042f0:	ec26                	sd	s1,24(sp)
    800042f2:	e84a                	sd	s2,16(sp)
    800042f4:	e44e                	sd	s3,8(sp)
    800042f6:	1800                	addi	s0,sp,48
    800042f8:	892a                	mv	s2,a0
    800042fa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800042fc:	0001e497          	auipc	s1,0x1e
    80004300:	10448493          	addi	s1,s1,260 # 80022400 <log>
    80004304:	00005597          	auipc	a1,0x5
    80004308:	41c58593          	addi	a1,a1,1052 # 80009720 <syscalls+0x2d0>
    8000430c:	8526                	mv	a0,s1
    8000430e:	ffffd097          	auipc	ra,0xffffd
    80004312:	838080e7          	jalr	-1992(ra) # 80000b46 <initlock>
  log.start = sb->logstart;
    80004316:	0149a583          	lw	a1,20(s3)
    8000431a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000431c:	0109a783          	lw	a5,16(s3)
    80004320:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004322:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004326:	854a                	mv	a0,s2
    80004328:	fffff097          	auipc	ra,0xfffff
    8000432c:	e84080e7          	jalr	-380(ra) # 800031ac <bread>
  log.lh.n = lh->n;
    80004330:	4d34                	lw	a3,88(a0)
    80004332:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004334:	02d05663          	blez	a3,80004360 <initlog+0x76>
    80004338:	05c50793          	addi	a5,a0,92
    8000433c:	0001e717          	auipc	a4,0x1e
    80004340:	0f470713          	addi	a4,a4,244 # 80022430 <log+0x30>
    80004344:	36fd                	addiw	a3,a3,-1
    80004346:	02069613          	slli	a2,a3,0x20
    8000434a:	01e65693          	srli	a3,a2,0x1e
    8000434e:	06050613          	addi	a2,a0,96
    80004352:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004354:	4390                	lw	a2,0(a5)
    80004356:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004358:	0791                	addi	a5,a5,4
    8000435a:	0711                	addi	a4,a4,4
    8000435c:	fed79ce3          	bne	a5,a3,80004354 <initlog+0x6a>
  brelse(buf);
    80004360:	fffff097          	auipc	ra,0xfffff
    80004364:	f7c080e7          	jalr	-132(ra) # 800032dc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004368:	4505                	li	a0,1
    8000436a:	00000097          	auipc	ra,0x0
    8000436e:	ebc080e7          	jalr	-324(ra) # 80004226 <install_trans>
  log.lh.n = 0;
    80004372:	0001e797          	auipc	a5,0x1e
    80004376:	0a07ad23          	sw	zero,186(a5) # 8002242c <log+0x2c>
  write_head(); // clear the log
    8000437a:	00000097          	auipc	ra,0x0
    8000437e:	e30080e7          	jalr	-464(ra) # 800041aa <write_head>
}
    80004382:	70a2                	ld	ra,40(sp)
    80004384:	7402                	ld	s0,32(sp)
    80004386:	64e2                	ld	s1,24(sp)
    80004388:	6942                	ld	s2,16(sp)
    8000438a:	69a2                	ld	s3,8(sp)
    8000438c:	6145                	addi	sp,sp,48
    8000438e:	8082                	ret

0000000080004390 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004390:	1101                	addi	sp,sp,-32
    80004392:	ec06                	sd	ra,24(sp)
    80004394:	e822                	sd	s0,16(sp)
    80004396:	e426                	sd	s1,8(sp)
    80004398:	e04a                	sd	s2,0(sp)
    8000439a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000439c:	0001e517          	auipc	a0,0x1e
    800043a0:	06450513          	addi	a0,a0,100 # 80022400 <log>
    800043a4:	ffffd097          	auipc	ra,0xffffd
    800043a8:	832080e7          	jalr	-1998(ra) # 80000bd6 <acquire>
  while(1){
    if(log.committing){
    800043ac:	0001e497          	auipc	s1,0x1e
    800043b0:	05448493          	addi	s1,s1,84 # 80022400 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800043b4:	4979                	li	s2,30
    800043b6:	a039                	j	800043c4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800043b8:	85a6                	mv	a1,s1
    800043ba:	8526                	mv	a0,s1
    800043bc:	ffffe097          	auipc	ra,0xffffe
    800043c0:	ca4080e7          	jalr	-860(ra) # 80002060 <sleep>
    if(log.committing){
    800043c4:	50dc                	lw	a5,36(s1)
    800043c6:	fbed                	bnez	a5,800043b8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800043c8:	5098                	lw	a4,32(s1)
    800043ca:	2705                	addiw	a4,a4,1
    800043cc:	0007069b          	sext.w	a3,a4
    800043d0:	0027179b          	slliw	a5,a4,0x2
    800043d4:	9fb9                	addw	a5,a5,a4
    800043d6:	0017979b          	slliw	a5,a5,0x1
    800043da:	54d8                	lw	a4,44(s1)
    800043dc:	9fb9                	addw	a5,a5,a4
    800043de:	00f95963          	bge	s2,a5,800043f0 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800043e2:	85a6                	mv	a1,s1
    800043e4:	8526                	mv	a0,s1
    800043e6:	ffffe097          	auipc	ra,0xffffe
    800043ea:	c7a080e7          	jalr	-902(ra) # 80002060 <sleep>
    800043ee:	bfd9                	j	800043c4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800043f0:	0001e517          	auipc	a0,0x1e
    800043f4:	01050513          	addi	a0,a0,16 # 80022400 <log>
    800043f8:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800043fa:	ffffd097          	auipc	ra,0xffffd
    800043fe:	890080e7          	jalr	-1904(ra) # 80000c8a <release>
      break;
    }
  }
}
    80004402:	60e2                	ld	ra,24(sp)
    80004404:	6442                	ld	s0,16(sp)
    80004406:	64a2                	ld	s1,8(sp)
    80004408:	6902                	ld	s2,0(sp)
    8000440a:	6105                	addi	sp,sp,32
    8000440c:	8082                	ret

000000008000440e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000440e:	7139                	addi	sp,sp,-64
    80004410:	fc06                	sd	ra,56(sp)
    80004412:	f822                	sd	s0,48(sp)
    80004414:	f426                	sd	s1,40(sp)
    80004416:	f04a                	sd	s2,32(sp)
    80004418:	ec4e                	sd	s3,24(sp)
    8000441a:	e852                	sd	s4,16(sp)
    8000441c:	e456                	sd	s5,8(sp)
    8000441e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004420:	0001e497          	auipc	s1,0x1e
    80004424:	fe048493          	addi	s1,s1,-32 # 80022400 <log>
    80004428:	8526                	mv	a0,s1
    8000442a:	ffffc097          	auipc	ra,0xffffc
    8000442e:	7ac080e7          	jalr	1964(ra) # 80000bd6 <acquire>
  log.outstanding -= 1;
    80004432:	509c                	lw	a5,32(s1)
    80004434:	37fd                	addiw	a5,a5,-1
    80004436:	0007891b          	sext.w	s2,a5
    8000443a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000443c:	50dc                	lw	a5,36(s1)
    8000443e:	e7b9                	bnez	a5,8000448c <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004440:	04091e63          	bnez	s2,8000449c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004444:	0001e497          	auipc	s1,0x1e
    80004448:	fbc48493          	addi	s1,s1,-68 # 80022400 <log>
    8000444c:	4785                	li	a5,1
    8000444e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004450:	8526                	mv	a0,s1
    80004452:	ffffd097          	auipc	ra,0xffffd
    80004456:	838080e7          	jalr	-1992(ra) # 80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000445a:	54dc                	lw	a5,44(s1)
    8000445c:	06f04763          	bgtz	a5,800044ca <end_op+0xbc>
    acquire(&log.lock);
    80004460:	0001e497          	auipc	s1,0x1e
    80004464:	fa048493          	addi	s1,s1,-96 # 80022400 <log>
    80004468:	8526                	mv	a0,s1
    8000446a:	ffffc097          	auipc	ra,0xffffc
    8000446e:	76c080e7          	jalr	1900(ra) # 80000bd6 <acquire>
    log.committing = 0;
    80004472:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004476:	8526                	mv	a0,s1
    80004478:	ffffe097          	auipc	ra,0xffffe
    8000447c:	c4c080e7          	jalr	-948(ra) # 800020c4 <wakeup>
    release(&log.lock);
    80004480:	8526                	mv	a0,s1
    80004482:	ffffd097          	auipc	ra,0xffffd
    80004486:	808080e7          	jalr	-2040(ra) # 80000c8a <release>
}
    8000448a:	a03d                	j	800044b8 <end_op+0xaa>
    panic("log.committing");
    8000448c:	00005517          	auipc	a0,0x5
    80004490:	29c50513          	addi	a0,a0,668 # 80009728 <syscalls+0x2d8>
    80004494:	ffffc097          	auipc	ra,0xffffc
    80004498:	0ac080e7          	jalr	172(ra) # 80000540 <panic>
    wakeup(&log);
    8000449c:	0001e497          	auipc	s1,0x1e
    800044a0:	f6448493          	addi	s1,s1,-156 # 80022400 <log>
    800044a4:	8526                	mv	a0,s1
    800044a6:	ffffe097          	auipc	ra,0xffffe
    800044aa:	c1e080e7          	jalr	-994(ra) # 800020c4 <wakeup>
  release(&log.lock);
    800044ae:	8526                	mv	a0,s1
    800044b0:	ffffc097          	auipc	ra,0xffffc
    800044b4:	7da080e7          	jalr	2010(ra) # 80000c8a <release>
}
    800044b8:	70e2                	ld	ra,56(sp)
    800044ba:	7442                	ld	s0,48(sp)
    800044bc:	74a2                	ld	s1,40(sp)
    800044be:	7902                	ld	s2,32(sp)
    800044c0:	69e2                	ld	s3,24(sp)
    800044c2:	6a42                	ld	s4,16(sp)
    800044c4:	6aa2                	ld	s5,8(sp)
    800044c6:	6121                	addi	sp,sp,64
    800044c8:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800044ca:	0001ea97          	auipc	s5,0x1e
    800044ce:	f66a8a93          	addi	s5,s5,-154 # 80022430 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800044d2:	0001ea17          	auipc	s4,0x1e
    800044d6:	f2ea0a13          	addi	s4,s4,-210 # 80022400 <log>
    800044da:	018a2583          	lw	a1,24(s4)
    800044de:	012585bb          	addw	a1,a1,s2
    800044e2:	2585                	addiw	a1,a1,1
    800044e4:	028a2503          	lw	a0,40(s4)
    800044e8:	fffff097          	auipc	ra,0xfffff
    800044ec:	cc4080e7          	jalr	-828(ra) # 800031ac <bread>
    800044f0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800044f2:	000aa583          	lw	a1,0(s5)
    800044f6:	028a2503          	lw	a0,40(s4)
    800044fa:	fffff097          	auipc	ra,0xfffff
    800044fe:	cb2080e7          	jalr	-846(ra) # 800031ac <bread>
    80004502:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004504:	40000613          	li	a2,1024
    80004508:	05850593          	addi	a1,a0,88
    8000450c:	05848513          	addi	a0,s1,88
    80004510:	ffffd097          	auipc	ra,0xffffd
    80004514:	81e080e7          	jalr	-2018(ra) # 80000d2e <memmove>
    bwrite(to);  // write the log
    80004518:	8526                	mv	a0,s1
    8000451a:	fffff097          	auipc	ra,0xfffff
    8000451e:	d84080e7          	jalr	-636(ra) # 8000329e <bwrite>
    brelse(from);
    80004522:	854e                	mv	a0,s3
    80004524:	fffff097          	auipc	ra,0xfffff
    80004528:	db8080e7          	jalr	-584(ra) # 800032dc <brelse>
    brelse(to);
    8000452c:	8526                	mv	a0,s1
    8000452e:	fffff097          	auipc	ra,0xfffff
    80004532:	dae080e7          	jalr	-594(ra) # 800032dc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004536:	2905                	addiw	s2,s2,1
    80004538:	0a91                	addi	s5,s5,4
    8000453a:	02ca2783          	lw	a5,44(s4)
    8000453e:	f8f94ee3          	blt	s2,a5,800044da <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004542:	00000097          	auipc	ra,0x0
    80004546:	c68080e7          	jalr	-920(ra) # 800041aa <write_head>
    install_trans(0); // Now install writes to home locations
    8000454a:	4501                	li	a0,0
    8000454c:	00000097          	auipc	ra,0x0
    80004550:	cda080e7          	jalr	-806(ra) # 80004226 <install_trans>
    log.lh.n = 0;
    80004554:	0001e797          	auipc	a5,0x1e
    80004558:	ec07ac23          	sw	zero,-296(a5) # 8002242c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000455c:	00000097          	auipc	ra,0x0
    80004560:	c4e080e7          	jalr	-946(ra) # 800041aa <write_head>
    80004564:	bdf5                	j	80004460 <end_op+0x52>

0000000080004566 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004566:	1101                	addi	sp,sp,-32
    80004568:	ec06                	sd	ra,24(sp)
    8000456a:	e822                	sd	s0,16(sp)
    8000456c:	e426                	sd	s1,8(sp)
    8000456e:	e04a                	sd	s2,0(sp)
    80004570:	1000                	addi	s0,sp,32
    80004572:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004574:	0001e917          	auipc	s2,0x1e
    80004578:	e8c90913          	addi	s2,s2,-372 # 80022400 <log>
    8000457c:	854a                	mv	a0,s2
    8000457e:	ffffc097          	auipc	ra,0xffffc
    80004582:	658080e7          	jalr	1624(ra) # 80000bd6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004586:	02c92603          	lw	a2,44(s2)
    8000458a:	47f5                	li	a5,29
    8000458c:	06c7c563          	blt	a5,a2,800045f6 <log_write+0x90>
    80004590:	0001e797          	auipc	a5,0x1e
    80004594:	e8c7a783          	lw	a5,-372(a5) # 8002241c <log+0x1c>
    80004598:	37fd                	addiw	a5,a5,-1
    8000459a:	04f65e63          	bge	a2,a5,800045f6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000459e:	0001e797          	auipc	a5,0x1e
    800045a2:	e827a783          	lw	a5,-382(a5) # 80022420 <log+0x20>
    800045a6:	06f05063          	blez	a5,80004606 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800045aa:	4781                	li	a5,0
    800045ac:	06c05563          	blez	a2,80004616 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800045b0:	44cc                	lw	a1,12(s1)
    800045b2:	0001e717          	auipc	a4,0x1e
    800045b6:	e7e70713          	addi	a4,a4,-386 # 80022430 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800045ba:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800045bc:	4314                	lw	a3,0(a4)
    800045be:	04b68c63          	beq	a3,a1,80004616 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800045c2:	2785                	addiw	a5,a5,1
    800045c4:	0711                	addi	a4,a4,4
    800045c6:	fef61be3          	bne	a2,a5,800045bc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800045ca:	0621                	addi	a2,a2,8
    800045cc:	060a                	slli	a2,a2,0x2
    800045ce:	0001e797          	auipc	a5,0x1e
    800045d2:	e3278793          	addi	a5,a5,-462 # 80022400 <log>
    800045d6:	97b2                	add	a5,a5,a2
    800045d8:	44d8                	lw	a4,12(s1)
    800045da:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800045dc:	8526                	mv	a0,s1
    800045de:	fffff097          	auipc	ra,0xfffff
    800045e2:	d9c080e7          	jalr	-612(ra) # 8000337a <bpin>
    log.lh.n++;
    800045e6:	0001e717          	auipc	a4,0x1e
    800045ea:	e1a70713          	addi	a4,a4,-486 # 80022400 <log>
    800045ee:	575c                	lw	a5,44(a4)
    800045f0:	2785                	addiw	a5,a5,1
    800045f2:	d75c                	sw	a5,44(a4)
    800045f4:	a82d                	j	8000462e <log_write+0xc8>
    panic("too big a transaction");
    800045f6:	00005517          	auipc	a0,0x5
    800045fa:	14250513          	addi	a0,a0,322 # 80009738 <syscalls+0x2e8>
    800045fe:	ffffc097          	auipc	ra,0xffffc
    80004602:	f42080e7          	jalr	-190(ra) # 80000540 <panic>
    panic("log_write outside of trans");
    80004606:	00005517          	auipc	a0,0x5
    8000460a:	14a50513          	addi	a0,a0,330 # 80009750 <syscalls+0x300>
    8000460e:	ffffc097          	auipc	ra,0xffffc
    80004612:	f32080e7          	jalr	-206(ra) # 80000540 <panic>
  log.lh.block[i] = b->blockno;
    80004616:	00878693          	addi	a3,a5,8
    8000461a:	068a                	slli	a3,a3,0x2
    8000461c:	0001e717          	auipc	a4,0x1e
    80004620:	de470713          	addi	a4,a4,-540 # 80022400 <log>
    80004624:	9736                	add	a4,a4,a3
    80004626:	44d4                	lw	a3,12(s1)
    80004628:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000462a:	faf609e3          	beq	a2,a5,800045dc <log_write+0x76>
  }
  release(&log.lock);
    8000462e:	0001e517          	auipc	a0,0x1e
    80004632:	dd250513          	addi	a0,a0,-558 # 80022400 <log>
    80004636:	ffffc097          	auipc	ra,0xffffc
    8000463a:	654080e7          	jalr	1620(ra) # 80000c8a <release>
}
    8000463e:	60e2                	ld	ra,24(sp)
    80004640:	6442                	ld	s0,16(sp)
    80004642:	64a2                	ld	s1,8(sp)
    80004644:	6902                	ld	s2,0(sp)
    80004646:	6105                	addi	sp,sp,32
    80004648:	8082                	ret

000000008000464a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000464a:	1101                	addi	sp,sp,-32
    8000464c:	ec06                	sd	ra,24(sp)
    8000464e:	e822                	sd	s0,16(sp)
    80004650:	e426                	sd	s1,8(sp)
    80004652:	e04a                	sd	s2,0(sp)
    80004654:	1000                	addi	s0,sp,32
    80004656:	84aa                	mv	s1,a0
    80004658:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000465a:	00005597          	auipc	a1,0x5
    8000465e:	11658593          	addi	a1,a1,278 # 80009770 <syscalls+0x320>
    80004662:	0521                	addi	a0,a0,8
    80004664:	ffffc097          	auipc	ra,0xffffc
    80004668:	4e2080e7          	jalr	1250(ra) # 80000b46 <initlock>
  lk->name = name;
    8000466c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004670:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004674:	0204a423          	sw	zero,40(s1)
}
    80004678:	60e2                	ld	ra,24(sp)
    8000467a:	6442                	ld	s0,16(sp)
    8000467c:	64a2                	ld	s1,8(sp)
    8000467e:	6902                	ld	s2,0(sp)
    80004680:	6105                	addi	sp,sp,32
    80004682:	8082                	ret

0000000080004684 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004684:	1101                	addi	sp,sp,-32
    80004686:	ec06                	sd	ra,24(sp)
    80004688:	e822                	sd	s0,16(sp)
    8000468a:	e426                	sd	s1,8(sp)
    8000468c:	e04a                	sd	s2,0(sp)
    8000468e:	1000                	addi	s0,sp,32
    80004690:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004692:	00850913          	addi	s2,a0,8
    80004696:	854a                	mv	a0,s2
    80004698:	ffffc097          	auipc	ra,0xffffc
    8000469c:	53e080e7          	jalr	1342(ra) # 80000bd6 <acquire>
  while (lk->locked) {
    800046a0:	409c                	lw	a5,0(s1)
    800046a2:	cb89                	beqz	a5,800046b4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800046a4:	85ca                	mv	a1,s2
    800046a6:	8526                	mv	a0,s1
    800046a8:	ffffe097          	auipc	ra,0xffffe
    800046ac:	9b8080e7          	jalr	-1608(ra) # 80002060 <sleep>
  while (lk->locked) {
    800046b0:	409c                	lw	a5,0(s1)
    800046b2:	fbed                	bnez	a5,800046a4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800046b4:	4785                	li	a5,1
    800046b6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800046b8:	ffffd097          	auipc	ra,0xffffd
    800046bc:	2f4080e7          	jalr	756(ra) # 800019ac <myproc>
    800046c0:	591c                	lw	a5,48(a0)
    800046c2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800046c4:	854a                	mv	a0,s2
    800046c6:	ffffc097          	auipc	ra,0xffffc
    800046ca:	5c4080e7          	jalr	1476(ra) # 80000c8a <release>
}
    800046ce:	60e2                	ld	ra,24(sp)
    800046d0:	6442                	ld	s0,16(sp)
    800046d2:	64a2                	ld	s1,8(sp)
    800046d4:	6902                	ld	s2,0(sp)
    800046d6:	6105                	addi	sp,sp,32
    800046d8:	8082                	ret

00000000800046da <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800046da:	1101                	addi	sp,sp,-32
    800046dc:	ec06                	sd	ra,24(sp)
    800046de:	e822                	sd	s0,16(sp)
    800046e0:	e426                	sd	s1,8(sp)
    800046e2:	e04a                	sd	s2,0(sp)
    800046e4:	1000                	addi	s0,sp,32
    800046e6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800046e8:	00850913          	addi	s2,a0,8
    800046ec:	854a                	mv	a0,s2
    800046ee:	ffffc097          	auipc	ra,0xffffc
    800046f2:	4e8080e7          	jalr	1256(ra) # 80000bd6 <acquire>
  lk->locked = 0;
    800046f6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800046fa:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800046fe:	8526                	mv	a0,s1
    80004700:	ffffe097          	auipc	ra,0xffffe
    80004704:	9c4080e7          	jalr	-1596(ra) # 800020c4 <wakeup>
  release(&lk->lk);
    80004708:	854a                	mv	a0,s2
    8000470a:	ffffc097          	auipc	ra,0xffffc
    8000470e:	580080e7          	jalr	1408(ra) # 80000c8a <release>
}
    80004712:	60e2                	ld	ra,24(sp)
    80004714:	6442                	ld	s0,16(sp)
    80004716:	64a2                	ld	s1,8(sp)
    80004718:	6902                	ld	s2,0(sp)
    8000471a:	6105                	addi	sp,sp,32
    8000471c:	8082                	ret

000000008000471e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000471e:	7179                	addi	sp,sp,-48
    80004720:	f406                	sd	ra,40(sp)
    80004722:	f022                	sd	s0,32(sp)
    80004724:	ec26                	sd	s1,24(sp)
    80004726:	e84a                	sd	s2,16(sp)
    80004728:	e44e                	sd	s3,8(sp)
    8000472a:	1800                	addi	s0,sp,48
    8000472c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000472e:	00850913          	addi	s2,a0,8
    80004732:	854a                	mv	a0,s2
    80004734:	ffffc097          	auipc	ra,0xffffc
    80004738:	4a2080e7          	jalr	1186(ra) # 80000bd6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000473c:	409c                	lw	a5,0(s1)
    8000473e:	ef99                	bnez	a5,8000475c <holdingsleep+0x3e>
    80004740:	4481                	li	s1,0
  release(&lk->lk);
    80004742:	854a                	mv	a0,s2
    80004744:	ffffc097          	auipc	ra,0xffffc
    80004748:	546080e7          	jalr	1350(ra) # 80000c8a <release>
  return r;
}
    8000474c:	8526                	mv	a0,s1
    8000474e:	70a2                	ld	ra,40(sp)
    80004750:	7402                	ld	s0,32(sp)
    80004752:	64e2                	ld	s1,24(sp)
    80004754:	6942                	ld	s2,16(sp)
    80004756:	69a2                	ld	s3,8(sp)
    80004758:	6145                	addi	sp,sp,48
    8000475a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000475c:	0284a983          	lw	s3,40(s1)
    80004760:	ffffd097          	auipc	ra,0xffffd
    80004764:	24c080e7          	jalr	588(ra) # 800019ac <myproc>
    80004768:	5904                	lw	s1,48(a0)
    8000476a:	413484b3          	sub	s1,s1,s3
    8000476e:	0014b493          	seqz	s1,s1
    80004772:	bfc1                	j	80004742 <holdingsleep+0x24>

0000000080004774 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004774:	1141                	addi	sp,sp,-16
    80004776:	e406                	sd	ra,8(sp)
    80004778:	e022                	sd	s0,0(sp)
    8000477a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000477c:	00005597          	auipc	a1,0x5
    80004780:	00458593          	addi	a1,a1,4 # 80009780 <syscalls+0x330>
    80004784:	0001e517          	auipc	a0,0x1e
    80004788:	dc450513          	addi	a0,a0,-572 # 80022548 <ftable>
    8000478c:	ffffc097          	auipc	ra,0xffffc
    80004790:	3ba080e7          	jalr	954(ra) # 80000b46 <initlock>
}
    80004794:	60a2                	ld	ra,8(sp)
    80004796:	6402                	ld	s0,0(sp)
    80004798:	0141                	addi	sp,sp,16
    8000479a:	8082                	ret

000000008000479c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000479c:	1101                	addi	sp,sp,-32
    8000479e:	ec06                	sd	ra,24(sp)
    800047a0:	e822                	sd	s0,16(sp)
    800047a2:	e426                	sd	s1,8(sp)
    800047a4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800047a6:	0001e517          	auipc	a0,0x1e
    800047aa:	da250513          	addi	a0,a0,-606 # 80022548 <ftable>
    800047ae:	ffffc097          	auipc	ra,0xffffc
    800047b2:	428080e7          	jalr	1064(ra) # 80000bd6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800047b6:	0001e497          	auipc	s1,0x1e
    800047ba:	daa48493          	addi	s1,s1,-598 # 80022560 <ftable+0x18>
    800047be:	0001f717          	auipc	a4,0x1f
    800047c2:	d4270713          	addi	a4,a4,-702 # 80023500 <disk>
    if(f->ref == 0){
    800047c6:	40dc                	lw	a5,4(s1)
    800047c8:	cf99                	beqz	a5,800047e6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800047ca:	02848493          	addi	s1,s1,40
    800047ce:	fee49ce3          	bne	s1,a4,800047c6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800047d2:	0001e517          	auipc	a0,0x1e
    800047d6:	d7650513          	addi	a0,a0,-650 # 80022548 <ftable>
    800047da:	ffffc097          	auipc	ra,0xffffc
    800047de:	4b0080e7          	jalr	1200(ra) # 80000c8a <release>
  return 0;
    800047e2:	4481                	li	s1,0
    800047e4:	a819                	j	800047fa <filealloc+0x5e>
      f->ref = 1;
    800047e6:	4785                	li	a5,1
    800047e8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800047ea:	0001e517          	auipc	a0,0x1e
    800047ee:	d5e50513          	addi	a0,a0,-674 # 80022548 <ftable>
    800047f2:	ffffc097          	auipc	ra,0xffffc
    800047f6:	498080e7          	jalr	1176(ra) # 80000c8a <release>
}
    800047fa:	8526                	mv	a0,s1
    800047fc:	60e2                	ld	ra,24(sp)
    800047fe:	6442                	ld	s0,16(sp)
    80004800:	64a2                	ld	s1,8(sp)
    80004802:	6105                	addi	sp,sp,32
    80004804:	8082                	ret

0000000080004806 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004806:	1101                	addi	sp,sp,-32
    80004808:	ec06                	sd	ra,24(sp)
    8000480a:	e822                	sd	s0,16(sp)
    8000480c:	e426                	sd	s1,8(sp)
    8000480e:	1000                	addi	s0,sp,32
    80004810:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004812:	0001e517          	auipc	a0,0x1e
    80004816:	d3650513          	addi	a0,a0,-714 # 80022548 <ftable>
    8000481a:	ffffc097          	auipc	ra,0xffffc
    8000481e:	3bc080e7          	jalr	956(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    80004822:	40dc                	lw	a5,4(s1)
    80004824:	02f05263          	blez	a5,80004848 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004828:	2785                	addiw	a5,a5,1
    8000482a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000482c:	0001e517          	auipc	a0,0x1e
    80004830:	d1c50513          	addi	a0,a0,-740 # 80022548 <ftable>
    80004834:	ffffc097          	auipc	ra,0xffffc
    80004838:	456080e7          	jalr	1110(ra) # 80000c8a <release>
  return f;
}
    8000483c:	8526                	mv	a0,s1
    8000483e:	60e2                	ld	ra,24(sp)
    80004840:	6442                	ld	s0,16(sp)
    80004842:	64a2                	ld	s1,8(sp)
    80004844:	6105                	addi	sp,sp,32
    80004846:	8082                	ret
    panic("filedup");
    80004848:	00005517          	auipc	a0,0x5
    8000484c:	f4050513          	addi	a0,a0,-192 # 80009788 <syscalls+0x338>
    80004850:	ffffc097          	auipc	ra,0xffffc
    80004854:	cf0080e7          	jalr	-784(ra) # 80000540 <panic>

0000000080004858 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004858:	7139                	addi	sp,sp,-64
    8000485a:	fc06                	sd	ra,56(sp)
    8000485c:	f822                	sd	s0,48(sp)
    8000485e:	f426                	sd	s1,40(sp)
    80004860:	f04a                	sd	s2,32(sp)
    80004862:	ec4e                	sd	s3,24(sp)
    80004864:	e852                	sd	s4,16(sp)
    80004866:	e456                	sd	s5,8(sp)
    80004868:	0080                	addi	s0,sp,64
    8000486a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000486c:	0001e517          	auipc	a0,0x1e
    80004870:	cdc50513          	addi	a0,a0,-804 # 80022548 <ftable>
    80004874:	ffffc097          	auipc	ra,0xffffc
    80004878:	362080e7          	jalr	866(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    8000487c:	40dc                	lw	a5,4(s1)
    8000487e:	06f05163          	blez	a5,800048e0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004882:	37fd                	addiw	a5,a5,-1
    80004884:	0007871b          	sext.w	a4,a5
    80004888:	c0dc                	sw	a5,4(s1)
    8000488a:	06e04363          	bgtz	a4,800048f0 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000488e:	0004a903          	lw	s2,0(s1)
    80004892:	0094ca83          	lbu	s5,9(s1)
    80004896:	0104ba03          	ld	s4,16(s1)
    8000489a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000489e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800048a2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800048a6:	0001e517          	auipc	a0,0x1e
    800048aa:	ca250513          	addi	a0,a0,-862 # 80022548 <ftable>
    800048ae:	ffffc097          	auipc	ra,0xffffc
    800048b2:	3dc080e7          	jalr	988(ra) # 80000c8a <release>

  if(ff.type == FD_PIPE){
    800048b6:	4785                	li	a5,1
    800048b8:	04f90d63          	beq	s2,a5,80004912 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800048bc:	3979                	addiw	s2,s2,-2
    800048be:	4785                	li	a5,1
    800048c0:	0527e063          	bltu	a5,s2,80004900 <fileclose+0xa8>
    begin_op();
    800048c4:	00000097          	auipc	ra,0x0
    800048c8:	acc080e7          	jalr	-1332(ra) # 80004390 <begin_op>
    iput(ff.ip);
    800048cc:	854e                	mv	a0,s3
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	2b0080e7          	jalr	688(ra) # 80003b7e <iput>
    end_op();
    800048d6:	00000097          	auipc	ra,0x0
    800048da:	b38080e7          	jalr	-1224(ra) # 8000440e <end_op>
    800048de:	a00d                	j	80004900 <fileclose+0xa8>
    panic("fileclose");
    800048e0:	00005517          	auipc	a0,0x5
    800048e4:	eb050513          	addi	a0,a0,-336 # 80009790 <syscalls+0x340>
    800048e8:	ffffc097          	auipc	ra,0xffffc
    800048ec:	c58080e7          	jalr	-936(ra) # 80000540 <panic>
    release(&ftable.lock);
    800048f0:	0001e517          	auipc	a0,0x1e
    800048f4:	c5850513          	addi	a0,a0,-936 # 80022548 <ftable>
    800048f8:	ffffc097          	auipc	ra,0xffffc
    800048fc:	392080e7          	jalr	914(ra) # 80000c8a <release>
  }
}
    80004900:	70e2                	ld	ra,56(sp)
    80004902:	7442                	ld	s0,48(sp)
    80004904:	74a2                	ld	s1,40(sp)
    80004906:	7902                	ld	s2,32(sp)
    80004908:	69e2                	ld	s3,24(sp)
    8000490a:	6a42                	ld	s4,16(sp)
    8000490c:	6aa2                	ld	s5,8(sp)
    8000490e:	6121                	addi	sp,sp,64
    80004910:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004912:	85d6                	mv	a1,s5
    80004914:	8552                	mv	a0,s4
    80004916:	00000097          	auipc	ra,0x0
    8000491a:	34c080e7          	jalr	844(ra) # 80004c62 <pipeclose>
    8000491e:	b7cd                	j	80004900 <fileclose+0xa8>

0000000080004920 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004920:	715d                	addi	sp,sp,-80
    80004922:	e486                	sd	ra,72(sp)
    80004924:	e0a2                	sd	s0,64(sp)
    80004926:	fc26                	sd	s1,56(sp)
    80004928:	f84a                	sd	s2,48(sp)
    8000492a:	f44e                	sd	s3,40(sp)
    8000492c:	0880                	addi	s0,sp,80
    8000492e:	84aa                	mv	s1,a0
    80004930:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004932:	ffffd097          	auipc	ra,0xffffd
    80004936:	07a080e7          	jalr	122(ra) # 800019ac <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000493a:	409c                	lw	a5,0(s1)
    8000493c:	37f9                	addiw	a5,a5,-2
    8000493e:	4705                	li	a4,1
    80004940:	04f76763          	bltu	a4,a5,8000498e <filestat+0x6e>
    80004944:	892a                	mv	s2,a0
    ilock(f->ip);
    80004946:	6c88                	ld	a0,24(s1)
    80004948:	fffff097          	auipc	ra,0xfffff
    8000494c:	07c080e7          	jalr	124(ra) # 800039c4 <ilock>
    stati(f->ip, &st);
    80004950:	fb840593          	addi	a1,s0,-72
    80004954:	6c88                	ld	a0,24(s1)
    80004956:	fffff097          	auipc	ra,0xfffff
    8000495a:	2f8080e7          	jalr	760(ra) # 80003c4e <stati>
    iunlock(f->ip);
    8000495e:	6c88                	ld	a0,24(s1)
    80004960:	fffff097          	auipc	ra,0xfffff
    80004964:	126080e7          	jalr	294(ra) # 80003a86 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004968:	46e1                	li	a3,24
    8000496a:	fb840613          	addi	a2,s0,-72
    8000496e:	85ce                	mv	a1,s3
    80004970:	05093503          	ld	a0,80(s2)
    80004974:	ffffd097          	auipc	ra,0xffffd
    80004978:	cf8080e7          	jalr	-776(ra) # 8000166c <copyout>
    8000497c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004980:	60a6                	ld	ra,72(sp)
    80004982:	6406                	ld	s0,64(sp)
    80004984:	74e2                	ld	s1,56(sp)
    80004986:	7942                	ld	s2,48(sp)
    80004988:	79a2                	ld	s3,40(sp)
    8000498a:	6161                	addi	sp,sp,80
    8000498c:	8082                	ret
  return -1;
    8000498e:	557d                	li	a0,-1
    80004990:	bfc5                	j	80004980 <filestat+0x60>

0000000080004992 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004992:	7179                	addi	sp,sp,-48
    80004994:	f406                	sd	ra,40(sp)
    80004996:	f022                	sd	s0,32(sp)
    80004998:	ec26                	sd	s1,24(sp)
    8000499a:	e84a                	sd	s2,16(sp)
    8000499c:	e44e                	sd	s3,8(sp)
    8000499e:	1800                	addi	s0,sp,48

  int r = 0;

  if(f->readable == 0)
    800049a0:	00854783          	lbu	a5,8(a0)
    800049a4:	c3d5                	beqz	a5,80004a48 <fileread+0xb6>
    800049a6:	84aa                	mv	s1,a0
    800049a8:	89ae                	mv	s3,a1
    800049aa:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800049ac:	411c                	lw	a5,0(a0)
    800049ae:	4705                	li	a4,1
    800049b0:	04e78963          	beq	a5,a4,80004a02 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800049b4:	470d                	li	a4,3
    800049b6:	04e78d63          	beq	a5,a4,80004a10 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800049ba:	4709                	li	a4,2
    800049bc:	06e79e63          	bne	a5,a4,80004a38 <fileread+0xa6>
    ilock(f->ip);
    800049c0:	6d08                	ld	a0,24(a0)
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	002080e7          	jalr	2(ra) # 800039c4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800049ca:	874a                	mv	a4,s2
    800049cc:	5094                	lw	a3,32(s1)
    800049ce:	864e                	mv	a2,s3
    800049d0:	4585                	li	a1,1
    800049d2:	6c88                	ld	a0,24(s1)
    800049d4:	fffff097          	auipc	ra,0xfffff
    800049d8:	2a4080e7          	jalr	676(ra) # 80003c78 <readi>
    800049dc:	892a                	mv	s2,a0
    800049de:	00a05563          	blez	a0,800049e8 <fileread+0x56>
      f->off += r;
    800049e2:	509c                	lw	a5,32(s1)
    800049e4:	9fa9                	addw	a5,a5,a0
    800049e6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800049e8:	6c88                	ld	a0,24(s1)
    800049ea:	fffff097          	auipc	ra,0xfffff
    800049ee:	09c080e7          	jalr	156(ra) # 80003a86 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800049f2:	854a                	mv	a0,s2
    800049f4:	70a2                	ld	ra,40(sp)
    800049f6:	7402                	ld	s0,32(sp)
    800049f8:	64e2                	ld	s1,24(sp)
    800049fa:	6942                	ld	s2,16(sp)
    800049fc:	69a2                	ld	s3,8(sp)
    800049fe:	6145                	addi	sp,sp,48
    80004a00:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004a02:	6908                	ld	a0,16(a0)
    80004a04:	00000097          	auipc	ra,0x0
    80004a08:	3c6080e7          	jalr	966(ra) # 80004dca <piperead>
    80004a0c:	892a                	mv	s2,a0
    80004a0e:	b7d5                	j	800049f2 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004a10:	02451783          	lh	a5,36(a0)
    80004a14:	03079693          	slli	a3,a5,0x30
    80004a18:	92c1                	srli	a3,a3,0x30
    80004a1a:	4725                	li	a4,9
    80004a1c:	02d76863          	bltu	a4,a3,80004a4c <fileread+0xba>
    80004a20:	0792                	slli	a5,a5,0x4
    80004a22:	0001e717          	auipc	a4,0x1e
    80004a26:	a8670713          	addi	a4,a4,-1402 # 800224a8 <devsw>
    80004a2a:	97ba                	add	a5,a5,a4
    80004a2c:	639c                	ld	a5,0(a5)
    80004a2e:	c38d                	beqz	a5,80004a50 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004a30:	4505                	li	a0,1
    80004a32:	9782                	jalr	a5
    80004a34:	892a                	mv	s2,a0
    80004a36:	bf75                	j	800049f2 <fileread+0x60>
    panic("fileread");
    80004a38:	00005517          	auipc	a0,0x5
    80004a3c:	d6850513          	addi	a0,a0,-664 # 800097a0 <syscalls+0x350>
    80004a40:	ffffc097          	auipc	ra,0xffffc
    80004a44:	b00080e7          	jalr	-1280(ra) # 80000540 <panic>
    return -1;
    80004a48:	597d                	li	s2,-1
    80004a4a:	b765                	j	800049f2 <fileread+0x60>
      return -1;
    80004a4c:	597d                	li	s2,-1
    80004a4e:	b755                	j	800049f2 <fileread+0x60>
    80004a50:	597d                	li	s2,-1
    80004a52:	b745                	j	800049f2 <fileread+0x60>

0000000080004a54 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004a54:	715d                	addi	sp,sp,-80
    80004a56:	e486                	sd	ra,72(sp)
    80004a58:	e0a2                	sd	s0,64(sp)
    80004a5a:	fc26                	sd	s1,56(sp)
    80004a5c:	f84a                	sd	s2,48(sp)
    80004a5e:	f44e                	sd	s3,40(sp)
    80004a60:	f052                	sd	s4,32(sp)
    80004a62:	ec56                	sd	s5,24(sp)
    80004a64:	e85a                	sd	s6,16(sp)
    80004a66:	e45e                	sd	s7,8(sp)
    80004a68:	e062                	sd	s8,0(sp)
    80004a6a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004a6c:	00954783          	lbu	a5,9(a0)
    80004a70:	10078663          	beqz	a5,80004b7c <filewrite+0x128>
    80004a74:	892a                	mv	s2,a0
    80004a76:	8b2e                	mv	s6,a1
    80004a78:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a7a:	411c                	lw	a5,0(a0)
    80004a7c:	4705                	li	a4,1
    80004a7e:	02e78263          	beq	a5,a4,80004aa2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a82:	470d                	li	a4,3
    80004a84:	02e78663          	beq	a5,a4,80004ab0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004a88:	4709                	li	a4,2
    80004a8a:	0ee79163          	bne	a5,a4,80004b6c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004a8e:	0ac05d63          	blez	a2,80004b48 <filewrite+0xf4>
    int i = 0;
    80004a92:	4981                	li	s3,0
    80004a94:	6b85                	lui	s7,0x1
    80004a96:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004a9a:	6c05                	lui	s8,0x1
    80004a9c:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004aa0:	a861                	j	80004b38 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004aa2:	6908                	ld	a0,16(a0)
    80004aa4:	00000097          	auipc	ra,0x0
    80004aa8:	22e080e7          	jalr	558(ra) # 80004cd2 <pipewrite>
    80004aac:	8a2a                	mv	s4,a0
    80004aae:	a045                	j	80004b4e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004ab0:	02451783          	lh	a5,36(a0)
    80004ab4:	03079693          	slli	a3,a5,0x30
    80004ab8:	92c1                	srli	a3,a3,0x30
    80004aba:	4725                	li	a4,9
    80004abc:	0cd76263          	bltu	a4,a3,80004b80 <filewrite+0x12c>
    80004ac0:	0792                	slli	a5,a5,0x4
    80004ac2:	0001e717          	auipc	a4,0x1e
    80004ac6:	9e670713          	addi	a4,a4,-1562 # 800224a8 <devsw>
    80004aca:	97ba                	add	a5,a5,a4
    80004acc:	679c                	ld	a5,8(a5)
    80004ace:	cbdd                	beqz	a5,80004b84 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004ad0:	4505                	li	a0,1
    80004ad2:	9782                	jalr	a5
    80004ad4:	8a2a                	mv	s4,a0
    80004ad6:	a8a5                	j	80004b4e <filewrite+0xfa>
    80004ad8:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004adc:	00000097          	auipc	ra,0x0
    80004ae0:	8b4080e7          	jalr	-1868(ra) # 80004390 <begin_op>
      ilock(f->ip);
    80004ae4:	01893503          	ld	a0,24(s2)
    80004ae8:	fffff097          	auipc	ra,0xfffff
    80004aec:	edc080e7          	jalr	-292(ra) # 800039c4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004af0:	8756                	mv	a4,s5
    80004af2:	02092683          	lw	a3,32(s2)
    80004af6:	01698633          	add	a2,s3,s6
    80004afa:	4585                	li	a1,1
    80004afc:	01893503          	ld	a0,24(s2)
    80004b00:	fffff097          	auipc	ra,0xfffff
    80004b04:	270080e7          	jalr	624(ra) # 80003d70 <writei>
    80004b08:	84aa                	mv	s1,a0
    80004b0a:	00a05763          	blez	a0,80004b18 <filewrite+0xc4>
        f->off += r;
    80004b0e:	02092783          	lw	a5,32(s2)
    80004b12:	9fa9                	addw	a5,a5,a0
    80004b14:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004b18:	01893503          	ld	a0,24(s2)
    80004b1c:	fffff097          	auipc	ra,0xfffff
    80004b20:	f6a080e7          	jalr	-150(ra) # 80003a86 <iunlock>
      end_op();
    80004b24:	00000097          	auipc	ra,0x0
    80004b28:	8ea080e7          	jalr	-1814(ra) # 8000440e <end_op>

      if(r != n1){
    80004b2c:	009a9f63          	bne	s5,s1,80004b4a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004b30:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004b34:	0149db63          	bge	s3,s4,80004b4a <filewrite+0xf6>
      int n1 = n - i;
    80004b38:	413a04bb          	subw	s1,s4,s3
    80004b3c:	0004879b          	sext.w	a5,s1
    80004b40:	f8fbdce3          	bge	s7,a5,80004ad8 <filewrite+0x84>
    80004b44:	84e2                	mv	s1,s8
    80004b46:	bf49                	j	80004ad8 <filewrite+0x84>
    int i = 0;
    80004b48:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004b4a:	013a1f63          	bne	s4,s3,80004b68 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004b4e:	8552                	mv	a0,s4
    80004b50:	60a6                	ld	ra,72(sp)
    80004b52:	6406                	ld	s0,64(sp)
    80004b54:	74e2                	ld	s1,56(sp)
    80004b56:	7942                	ld	s2,48(sp)
    80004b58:	79a2                	ld	s3,40(sp)
    80004b5a:	7a02                	ld	s4,32(sp)
    80004b5c:	6ae2                	ld	s5,24(sp)
    80004b5e:	6b42                	ld	s6,16(sp)
    80004b60:	6ba2                	ld	s7,8(sp)
    80004b62:	6c02                	ld	s8,0(sp)
    80004b64:	6161                	addi	sp,sp,80
    80004b66:	8082                	ret
    ret = (i == n ? n : -1);
    80004b68:	5a7d                	li	s4,-1
    80004b6a:	b7d5                	j	80004b4e <filewrite+0xfa>
    panic("filewrite");
    80004b6c:	00005517          	auipc	a0,0x5
    80004b70:	c4450513          	addi	a0,a0,-956 # 800097b0 <syscalls+0x360>
    80004b74:	ffffc097          	auipc	ra,0xffffc
    80004b78:	9cc080e7          	jalr	-1588(ra) # 80000540 <panic>
    return -1;
    80004b7c:	5a7d                	li	s4,-1
    80004b7e:	bfc1                	j	80004b4e <filewrite+0xfa>
      return -1;
    80004b80:	5a7d                	li	s4,-1
    80004b82:	b7f1                	j	80004b4e <filewrite+0xfa>
    80004b84:	5a7d                	li	s4,-1
    80004b86:	b7e1                	j	80004b4e <filewrite+0xfa>

0000000080004b88 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004b88:	7179                	addi	sp,sp,-48
    80004b8a:	f406                	sd	ra,40(sp)
    80004b8c:	f022                	sd	s0,32(sp)
    80004b8e:	ec26                	sd	s1,24(sp)
    80004b90:	e84a                	sd	s2,16(sp)
    80004b92:	e44e                	sd	s3,8(sp)
    80004b94:	e052                	sd	s4,0(sp)
    80004b96:	1800                	addi	s0,sp,48
    80004b98:	84aa                	mv	s1,a0
    80004b9a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004b9c:	0005b023          	sd	zero,0(a1)
    80004ba0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004ba4:	00000097          	auipc	ra,0x0
    80004ba8:	bf8080e7          	jalr	-1032(ra) # 8000479c <filealloc>
    80004bac:	e088                	sd	a0,0(s1)
    80004bae:	c551                	beqz	a0,80004c3a <pipealloc+0xb2>
    80004bb0:	00000097          	auipc	ra,0x0
    80004bb4:	bec080e7          	jalr	-1044(ra) # 8000479c <filealloc>
    80004bb8:	00aa3023          	sd	a0,0(s4)
    80004bbc:	c92d                	beqz	a0,80004c2e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004bbe:	ffffc097          	auipc	ra,0xffffc
    80004bc2:	f28080e7          	jalr	-216(ra) # 80000ae6 <kalloc>
    80004bc6:	892a                	mv	s2,a0
    80004bc8:	c125                	beqz	a0,80004c28 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004bca:	4985                	li	s3,1
    80004bcc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004bd0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004bd4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004bd8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004bdc:	00005597          	auipc	a1,0x5
    80004be0:	be458593          	addi	a1,a1,-1052 # 800097c0 <syscalls+0x370>
    80004be4:	ffffc097          	auipc	ra,0xffffc
    80004be8:	f62080e7          	jalr	-158(ra) # 80000b46 <initlock>
  (*f0)->type = FD_PIPE;
    80004bec:	609c                	ld	a5,0(s1)
    80004bee:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004bf2:	609c                	ld	a5,0(s1)
    80004bf4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004bf8:	609c                	ld	a5,0(s1)
    80004bfa:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004bfe:	609c                	ld	a5,0(s1)
    80004c00:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004c04:	000a3783          	ld	a5,0(s4)
    80004c08:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004c0c:	000a3783          	ld	a5,0(s4)
    80004c10:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004c14:	000a3783          	ld	a5,0(s4)
    80004c18:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004c1c:	000a3783          	ld	a5,0(s4)
    80004c20:	0127b823          	sd	s2,16(a5)
  return 0;
    80004c24:	4501                	li	a0,0
    80004c26:	a025                	j	80004c4e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004c28:	6088                	ld	a0,0(s1)
    80004c2a:	e501                	bnez	a0,80004c32 <pipealloc+0xaa>
    80004c2c:	a039                	j	80004c3a <pipealloc+0xb2>
    80004c2e:	6088                	ld	a0,0(s1)
    80004c30:	c51d                	beqz	a0,80004c5e <pipealloc+0xd6>
    fileclose(*f0);
    80004c32:	00000097          	auipc	ra,0x0
    80004c36:	c26080e7          	jalr	-986(ra) # 80004858 <fileclose>
  if(*f1)
    80004c3a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004c3e:	557d                	li	a0,-1
  if(*f1)
    80004c40:	c799                	beqz	a5,80004c4e <pipealloc+0xc6>
    fileclose(*f1);
    80004c42:	853e                	mv	a0,a5
    80004c44:	00000097          	auipc	ra,0x0
    80004c48:	c14080e7          	jalr	-1004(ra) # 80004858 <fileclose>
  return -1;
    80004c4c:	557d                	li	a0,-1
}
    80004c4e:	70a2                	ld	ra,40(sp)
    80004c50:	7402                	ld	s0,32(sp)
    80004c52:	64e2                	ld	s1,24(sp)
    80004c54:	6942                	ld	s2,16(sp)
    80004c56:	69a2                	ld	s3,8(sp)
    80004c58:	6a02                	ld	s4,0(sp)
    80004c5a:	6145                	addi	sp,sp,48
    80004c5c:	8082                	ret
  return -1;
    80004c5e:	557d                	li	a0,-1
    80004c60:	b7fd                	j	80004c4e <pipealloc+0xc6>

0000000080004c62 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004c62:	1101                	addi	sp,sp,-32
    80004c64:	ec06                	sd	ra,24(sp)
    80004c66:	e822                	sd	s0,16(sp)
    80004c68:	e426                	sd	s1,8(sp)
    80004c6a:	e04a                	sd	s2,0(sp)
    80004c6c:	1000                	addi	s0,sp,32
    80004c6e:	84aa                	mv	s1,a0
    80004c70:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004c72:	ffffc097          	auipc	ra,0xffffc
    80004c76:	f64080e7          	jalr	-156(ra) # 80000bd6 <acquire>
  if(writable){
    80004c7a:	02090d63          	beqz	s2,80004cb4 <pipeclose+0x52>
    pi->writeopen = 0;
    80004c7e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004c82:	21848513          	addi	a0,s1,536
    80004c86:	ffffd097          	auipc	ra,0xffffd
    80004c8a:	43e080e7          	jalr	1086(ra) # 800020c4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004c8e:	2204b783          	ld	a5,544(s1)
    80004c92:	eb95                	bnez	a5,80004cc6 <pipeclose+0x64>
    release(&pi->lock);
    80004c94:	8526                	mv	a0,s1
    80004c96:	ffffc097          	auipc	ra,0xffffc
    80004c9a:	ff4080e7          	jalr	-12(ra) # 80000c8a <release>
    kfree((char*)pi);
    80004c9e:	8526                	mv	a0,s1
    80004ca0:	ffffc097          	auipc	ra,0xffffc
    80004ca4:	d48080e7          	jalr	-696(ra) # 800009e8 <kfree>
  } else
    release(&pi->lock);
}
    80004ca8:	60e2                	ld	ra,24(sp)
    80004caa:	6442                	ld	s0,16(sp)
    80004cac:	64a2                	ld	s1,8(sp)
    80004cae:	6902                	ld	s2,0(sp)
    80004cb0:	6105                	addi	sp,sp,32
    80004cb2:	8082                	ret
    pi->readopen = 0;
    80004cb4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004cb8:	21c48513          	addi	a0,s1,540
    80004cbc:	ffffd097          	auipc	ra,0xffffd
    80004cc0:	408080e7          	jalr	1032(ra) # 800020c4 <wakeup>
    80004cc4:	b7e9                	j	80004c8e <pipeclose+0x2c>
    release(&pi->lock);
    80004cc6:	8526                	mv	a0,s1
    80004cc8:	ffffc097          	auipc	ra,0xffffc
    80004ccc:	fc2080e7          	jalr	-62(ra) # 80000c8a <release>
}
    80004cd0:	bfe1                	j	80004ca8 <pipeclose+0x46>

0000000080004cd2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004cd2:	711d                	addi	sp,sp,-96
    80004cd4:	ec86                	sd	ra,88(sp)
    80004cd6:	e8a2                	sd	s0,80(sp)
    80004cd8:	e4a6                	sd	s1,72(sp)
    80004cda:	e0ca                	sd	s2,64(sp)
    80004cdc:	fc4e                	sd	s3,56(sp)
    80004cde:	f852                	sd	s4,48(sp)
    80004ce0:	f456                	sd	s5,40(sp)
    80004ce2:	f05a                	sd	s6,32(sp)
    80004ce4:	ec5e                	sd	s7,24(sp)
    80004ce6:	e862                	sd	s8,16(sp)
    80004ce8:	1080                	addi	s0,sp,96
    80004cea:	84aa                	mv	s1,a0
    80004cec:	8aae                	mv	s5,a1
    80004cee:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004cf0:	ffffd097          	auipc	ra,0xffffd
    80004cf4:	cbc080e7          	jalr	-836(ra) # 800019ac <myproc>
    80004cf8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004cfa:	8526                	mv	a0,s1
    80004cfc:	ffffc097          	auipc	ra,0xffffc
    80004d00:	eda080e7          	jalr	-294(ra) # 80000bd6 <acquire>
  while(i < n){
    80004d04:	0b405663          	blez	s4,80004db0 <pipewrite+0xde>
  int i = 0;
    80004d08:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d0a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004d0c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004d10:	21c48b93          	addi	s7,s1,540
    80004d14:	a089                	j	80004d56 <pipewrite+0x84>
      release(&pi->lock);
    80004d16:	8526                	mv	a0,s1
    80004d18:	ffffc097          	auipc	ra,0xffffc
    80004d1c:	f72080e7          	jalr	-142(ra) # 80000c8a <release>
      return -1;
    80004d20:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004d22:	854a                	mv	a0,s2
    80004d24:	60e6                	ld	ra,88(sp)
    80004d26:	6446                	ld	s0,80(sp)
    80004d28:	64a6                	ld	s1,72(sp)
    80004d2a:	6906                	ld	s2,64(sp)
    80004d2c:	79e2                	ld	s3,56(sp)
    80004d2e:	7a42                	ld	s4,48(sp)
    80004d30:	7aa2                	ld	s5,40(sp)
    80004d32:	7b02                	ld	s6,32(sp)
    80004d34:	6be2                	ld	s7,24(sp)
    80004d36:	6c42                	ld	s8,16(sp)
    80004d38:	6125                	addi	sp,sp,96
    80004d3a:	8082                	ret
      wakeup(&pi->nread);
    80004d3c:	8562                	mv	a0,s8
    80004d3e:	ffffd097          	auipc	ra,0xffffd
    80004d42:	386080e7          	jalr	902(ra) # 800020c4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004d46:	85a6                	mv	a1,s1
    80004d48:	855e                	mv	a0,s7
    80004d4a:	ffffd097          	auipc	ra,0xffffd
    80004d4e:	316080e7          	jalr	790(ra) # 80002060 <sleep>
  while(i < n){
    80004d52:	07495063          	bge	s2,s4,80004db2 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004d56:	2204a783          	lw	a5,544(s1)
    80004d5a:	dfd5                	beqz	a5,80004d16 <pipewrite+0x44>
    80004d5c:	854e                	mv	a0,s3
    80004d5e:	ffffd097          	auipc	ra,0xffffd
    80004d62:	5c2080e7          	jalr	1474(ra) # 80002320 <killed>
    80004d66:	f945                	bnez	a0,80004d16 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004d68:	2184a783          	lw	a5,536(s1)
    80004d6c:	21c4a703          	lw	a4,540(s1)
    80004d70:	2007879b          	addiw	a5,a5,512
    80004d74:	fcf704e3          	beq	a4,a5,80004d3c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d78:	4685                	li	a3,1
    80004d7a:	01590633          	add	a2,s2,s5
    80004d7e:	faf40593          	addi	a1,s0,-81
    80004d82:	0509b503          	ld	a0,80(s3)
    80004d86:	ffffd097          	auipc	ra,0xffffd
    80004d8a:	972080e7          	jalr	-1678(ra) # 800016f8 <copyin>
    80004d8e:	03650263          	beq	a0,s6,80004db2 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004d92:	21c4a783          	lw	a5,540(s1)
    80004d96:	0017871b          	addiw	a4,a5,1
    80004d9a:	20e4ae23          	sw	a4,540(s1)
    80004d9e:	1ff7f793          	andi	a5,a5,511
    80004da2:	97a6                	add	a5,a5,s1
    80004da4:	faf44703          	lbu	a4,-81(s0)
    80004da8:	00e78c23          	sb	a4,24(a5)
      i++;
    80004dac:	2905                	addiw	s2,s2,1
    80004dae:	b755                	j	80004d52 <pipewrite+0x80>
  int i = 0;
    80004db0:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004db2:	21848513          	addi	a0,s1,536
    80004db6:	ffffd097          	auipc	ra,0xffffd
    80004dba:	30e080e7          	jalr	782(ra) # 800020c4 <wakeup>
  release(&pi->lock);
    80004dbe:	8526                	mv	a0,s1
    80004dc0:	ffffc097          	auipc	ra,0xffffc
    80004dc4:	eca080e7          	jalr	-310(ra) # 80000c8a <release>
  return i;
    80004dc8:	bfa9                	j	80004d22 <pipewrite+0x50>

0000000080004dca <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004dca:	715d                	addi	sp,sp,-80
    80004dcc:	e486                	sd	ra,72(sp)
    80004dce:	e0a2                	sd	s0,64(sp)
    80004dd0:	fc26                	sd	s1,56(sp)
    80004dd2:	f84a                	sd	s2,48(sp)
    80004dd4:	f44e                	sd	s3,40(sp)
    80004dd6:	f052                	sd	s4,32(sp)
    80004dd8:	ec56                	sd	s5,24(sp)
    80004dda:	e85a                	sd	s6,16(sp)
    80004ddc:	0880                	addi	s0,sp,80
    80004dde:	84aa                	mv	s1,a0
    80004de0:	892e                	mv	s2,a1
    80004de2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004de4:	ffffd097          	auipc	ra,0xffffd
    80004de8:	bc8080e7          	jalr	-1080(ra) # 800019ac <myproc>
    80004dec:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004dee:	8526                	mv	a0,s1
    80004df0:	ffffc097          	auipc	ra,0xffffc
    80004df4:	de6080e7          	jalr	-538(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004df8:	2184a703          	lw	a4,536(s1)
    80004dfc:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e00:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e04:	02f71763          	bne	a4,a5,80004e32 <piperead+0x68>
    80004e08:	2244a783          	lw	a5,548(s1)
    80004e0c:	c39d                	beqz	a5,80004e32 <piperead+0x68>
    if(killed(pr)){
    80004e0e:	8552                	mv	a0,s4
    80004e10:	ffffd097          	auipc	ra,0xffffd
    80004e14:	510080e7          	jalr	1296(ra) # 80002320 <killed>
    80004e18:	e949                	bnez	a0,80004eaa <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e1a:	85a6                	mv	a1,s1
    80004e1c:	854e                	mv	a0,s3
    80004e1e:	ffffd097          	auipc	ra,0xffffd
    80004e22:	242080e7          	jalr	578(ra) # 80002060 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e26:	2184a703          	lw	a4,536(s1)
    80004e2a:	21c4a783          	lw	a5,540(s1)
    80004e2e:	fcf70de3          	beq	a4,a5,80004e08 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e32:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004e34:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e36:	05505463          	blez	s5,80004e7e <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004e3a:	2184a783          	lw	a5,536(s1)
    80004e3e:	21c4a703          	lw	a4,540(s1)
    80004e42:	02f70e63          	beq	a4,a5,80004e7e <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004e46:	0017871b          	addiw	a4,a5,1
    80004e4a:	20e4ac23          	sw	a4,536(s1)
    80004e4e:	1ff7f793          	andi	a5,a5,511
    80004e52:	97a6                	add	a5,a5,s1
    80004e54:	0187c783          	lbu	a5,24(a5)
    80004e58:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004e5c:	4685                	li	a3,1
    80004e5e:	fbf40613          	addi	a2,s0,-65
    80004e62:	85ca                	mv	a1,s2
    80004e64:	050a3503          	ld	a0,80(s4)
    80004e68:	ffffd097          	auipc	ra,0xffffd
    80004e6c:	804080e7          	jalr	-2044(ra) # 8000166c <copyout>
    80004e70:	01650763          	beq	a0,s6,80004e7e <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e74:	2985                	addiw	s3,s3,1
    80004e76:	0905                	addi	s2,s2,1
    80004e78:	fd3a91e3          	bne	s5,s3,80004e3a <piperead+0x70>
    80004e7c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004e7e:	21c48513          	addi	a0,s1,540
    80004e82:	ffffd097          	auipc	ra,0xffffd
    80004e86:	242080e7          	jalr	578(ra) # 800020c4 <wakeup>
  release(&pi->lock);
    80004e8a:	8526                	mv	a0,s1
    80004e8c:	ffffc097          	auipc	ra,0xffffc
    80004e90:	dfe080e7          	jalr	-514(ra) # 80000c8a <release>
  return i;
}
    80004e94:	854e                	mv	a0,s3
    80004e96:	60a6                	ld	ra,72(sp)
    80004e98:	6406                	ld	s0,64(sp)
    80004e9a:	74e2                	ld	s1,56(sp)
    80004e9c:	7942                	ld	s2,48(sp)
    80004e9e:	79a2                	ld	s3,40(sp)
    80004ea0:	7a02                	ld	s4,32(sp)
    80004ea2:	6ae2                	ld	s5,24(sp)
    80004ea4:	6b42                	ld	s6,16(sp)
    80004ea6:	6161                	addi	sp,sp,80
    80004ea8:	8082                	ret
      release(&pi->lock);
    80004eaa:	8526                	mv	a0,s1
    80004eac:	ffffc097          	auipc	ra,0xffffc
    80004eb0:	dde080e7          	jalr	-546(ra) # 80000c8a <release>
      return -1;
    80004eb4:	59fd                	li	s3,-1
    80004eb6:	bff9                	j	80004e94 <piperead+0xca>

0000000080004eb8 <read_pipe>:
Reading from the pipe

*/
int
read_pipe(struct pipe *pi, uint64 addr, int n)
{
    80004eb8:	715d                	addi	sp,sp,-80
    80004eba:	e486                	sd	ra,72(sp)
    80004ebc:	e0a2                	sd	s0,64(sp)
    80004ebe:	fc26                	sd	s1,56(sp)
    80004ec0:	f84a                	sd	s2,48(sp)
    80004ec2:	f44e                	sd	s3,40(sp)
    80004ec4:	f052                	sd	s4,32(sp)
    80004ec6:	ec56                	sd	s5,24(sp)
    80004ec8:	0880                	addi	s0,sp,80
    80004eca:	84aa                	mv	s1,a0
    80004ecc:	8a2e                	mv	s4,a1
    80004ece:	89b2                	mv	s3,a2
  int i;
  struct proc *pr = myproc();
    80004ed0:	ffffd097          	auipc	ra,0xffffd
    80004ed4:	adc080e7          	jalr	-1316(ra) # 800019ac <myproc>
    80004ed8:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    80004eda:	8526                	mv	a0,s1
    80004edc:	ffffc097          	auipc	ra,0xffffc
    80004ee0:	cfa080e7          	jalr	-774(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ee4:	2184a703          	lw	a4,536(s1)
    80004ee8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004eec:	21848a93          	addi	s5,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ef0:	02f71763          	bne	a4,a5,80004f1e <read_pipe+0x66>
    80004ef4:	2244a783          	lw	a5,548(s1)
    80004ef8:	c39d                	beqz	a5,80004f1e <read_pipe+0x66>
    if(killed(pr)){
    80004efa:	854a                	mv	a0,s2
    80004efc:	ffffd097          	auipc	ra,0xffffd
    80004f00:	424080e7          	jalr	1060(ra) # 80002320 <killed>
    80004f04:	e541                	bnez	a0,80004f8c <read_pipe+0xd4>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004f06:	85a6                	mv	a1,s1
    80004f08:	8556                	mv	a0,s5
    80004f0a:	ffffd097          	auipc	ra,0xffffd
    80004f0e:	156080e7          	jalr	342(ra) # 80002060 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f12:	2184a703          	lw	a4,536(s1)
    80004f16:	21c4a783          	lw	a5,540(s1)
    80004f1a:	fcf70de3          	beq	a4,a5,80004ef4 <read_pipe+0x3c>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f1e:	4901                	li	s2,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    memmove((char *)addr,(char*)&ch,n);
    80004f20:	00098a9b          	sext.w	s5,s3
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f24:	03305f63          	blez	s3,80004f62 <read_pipe+0xaa>
    if(pi->nread == pi->nwrite)
    80004f28:	2184a783          	lw	a5,536(s1)
    80004f2c:	21c4a703          	lw	a4,540(s1)
    80004f30:	02f70963          	beq	a4,a5,80004f62 <read_pipe+0xaa>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004f34:	0017871b          	addiw	a4,a5,1
    80004f38:	20e4ac23          	sw	a4,536(s1)
    80004f3c:	1ff7f793          	andi	a5,a5,511
    80004f40:	97a6                	add	a5,a5,s1
    80004f42:	0187c783          	lbu	a5,24(a5)
    80004f46:	faf40fa3          	sb	a5,-65(s0)
    memmove((char *)addr,(char*)&ch,n);
    80004f4a:	8656                	mv	a2,s5
    80004f4c:	fbf40593          	addi	a1,s0,-65
    80004f50:	8552                	mv	a0,s4
    80004f52:	ffffc097          	auipc	ra,0xffffc
    80004f56:	ddc080e7          	jalr	-548(ra) # 80000d2e <memmove>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f5a:	2905                	addiw	s2,s2,1
    80004f5c:	fd2996e3          	bne	s3,s2,80004f28 <read_pipe+0x70>
    80004f60:	894e                	mv	s2,s3
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004f62:	21c48513          	addi	a0,s1,540
    80004f66:	ffffd097          	auipc	ra,0xffffd
    80004f6a:	15e080e7          	jalr	350(ra) # 800020c4 <wakeup>
  release(&pi->lock);
    80004f6e:	8526                	mv	a0,s1
    80004f70:	ffffc097          	auipc	ra,0xffffc
    80004f74:	d1a080e7          	jalr	-742(ra) # 80000c8a <release>
  return i;
}
    80004f78:	854a                	mv	a0,s2
    80004f7a:	60a6                	ld	ra,72(sp)
    80004f7c:	6406                	ld	s0,64(sp)
    80004f7e:	74e2                	ld	s1,56(sp)
    80004f80:	7942                	ld	s2,48(sp)
    80004f82:	79a2                	ld	s3,40(sp)
    80004f84:	7a02                	ld	s4,32(sp)
    80004f86:	6ae2                	ld	s5,24(sp)
    80004f88:	6161                	addi	sp,sp,80
    80004f8a:	8082                	ret
      release(&pi->lock);
    80004f8c:	8526                	mv	a0,s1
    80004f8e:	ffffc097          	auipc	ra,0xffffc
    80004f92:	cfc080e7          	jalr	-772(ra) # 80000c8a <release>
      return -1;
    80004f96:	597d                	li	s2,-1
    80004f98:	b7c5                	j	80004f78 <read_pipe+0xc0>

0000000080004f9a <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);
extern uint64 sys_uptime(void);

int flags2perm(int flags)
{
    80004f9a:	1141                	addi	sp,sp,-16
    80004f9c:	e422                	sd	s0,8(sp)
    80004f9e:	0800                	addi	s0,sp,16
    80004fa0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004fa2:	8905                	andi	a0,a0,1
    80004fa4:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004fa6:	8b89                	andi	a5,a5,2
    80004fa8:	c399                	beqz	a5,80004fae <flags2perm+0x14>
      perm |= PTE_W;
    80004faa:	00456513          	ori	a0,a0,4
    return perm;
}
    80004fae:	6422                	ld	s0,8(sp)
    80004fb0:	0141                	addi	sp,sp,16
    80004fb2:	8082                	ret

0000000080004fb4 <exec>:

int
exec(char *path, char **argv)
{
    80004fb4:	de010113          	addi	sp,sp,-544
    80004fb8:	20113c23          	sd	ra,536(sp)
    80004fbc:	20813823          	sd	s0,528(sp)
    80004fc0:	20913423          	sd	s1,520(sp)
    80004fc4:	21213023          	sd	s2,512(sp)
    80004fc8:	ffce                	sd	s3,504(sp)
    80004fca:	fbd2                	sd	s4,496(sp)
    80004fcc:	f7d6                	sd	s5,488(sp)
    80004fce:	f3da                	sd	s6,480(sp)
    80004fd0:	efde                	sd	s7,472(sp)
    80004fd2:	ebe2                	sd	s8,464(sp)
    80004fd4:	e7e6                	sd	s9,456(sp)
    80004fd6:	e3ea                	sd	s10,448(sp)
    80004fd8:	ff6e                	sd	s11,440(sp)
    80004fda:	1400                	addi	s0,sp,544
    80004fdc:	892a                	mv	s2,a0
    80004fde:	dea43423          	sd	a0,-536(s0)
    80004fe2:	deb43823          	sd	a1,-528(s0)
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;


  struct proc *p = myproc();
    80004fe6:	ffffd097          	auipc	ra,0xffffd
    80004fea:	9c6080e7          	jalr	-1594(ra) # 800019ac <myproc>
    80004fee:	84aa                	mv	s1,a0

  begin_op();
    80004ff0:	fffff097          	auipc	ra,0xfffff
    80004ff4:	3a0080e7          	jalr	928(ra) # 80004390 <begin_op>

  if((ip = namei(path)) == 0){
    80004ff8:	854a                	mv	a0,s2
    80004ffa:	fffff097          	auipc	ra,0xfffff
    80004ffe:	176080e7          	jalr	374(ra) # 80004170 <namei>
    80005002:	c93d                	beqz	a0,80005078 <exec+0xc4>
    80005004:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005006:	fffff097          	auipc	ra,0xfffff
    8000500a:	9be080e7          	jalr	-1602(ra) # 800039c4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000500e:	04000713          	li	a4,64
    80005012:	4681                	li	a3,0
    80005014:	e5040613          	addi	a2,s0,-432
    80005018:	4581                	li	a1,0
    8000501a:	8556                	mv	a0,s5
    8000501c:	fffff097          	auipc	ra,0xfffff
    80005020:	c5c080e7          	jalr	-932(ra) # 80003c78 <readi>
    80005024:	04000793          	li	a5,64
    80005028:	00f51a63          	bne	a0,a5,8000503c <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000502c:	e5042703          	lw	a4,-432(s0)
    80005030:	464c47b7          	lui	a5,0x464c4
    80005034:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005038:	04f70663          	beq	a4,a5,80005084 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000503c:	8556                	mv	a0,s5
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	be8080e7          	jalr	-1048(ra) # 80003c26 <iunlockput>
    end_op();
    80005046:	fffff097          	auipc	ra,0xfffff
    8000504a:	3c8080e7          	jalr	968(ra) # 8000440e <end_op>
  }

  return -1;
    8000504e:	557d                	li	a0,-1
}
    80005050:	21813083          	ld	ra,536(sp)
    80005054:	21013403          	ld	s0,528(sp)
    80005058:	20813483          	ld	s1,520(sp)
    8000505c:	20013903          	ld	s2,512(sp)
    80005060:	79fe                	ld	s3,504(sp)
    80005062:	7a5e                	ld	s4,496(sp)
    80005064:	7abe                	ld	s5,488(sp)
    80005066:	7b1e                	ld	s6,480(sp)
    80005068:	6bfe                	ld	s7,472(sp)
    8000506a:	6c5e                	ld	s8,464(sp)
    8000506c:	6cbe                	ld	s9,456(sp)
    8000506e:	6d1e                	ld	s10,448(sp)
    80005070:	7dfa                	ld	s11,440(sp)
    80005072:	22010113          	addi	sp,sp,544
    80005076:	8082                	ret
    end_op();
    80005078:	fffff097          	auipc	ra,0xfffff
    8000507c:	396080e7          	jalr	918(ra) # 8000440e <end_op>
    return -1;
    80005080:	557d                	li	a0,-1
    80005082:	b7f9                	j	80005050 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80005084:	8526                	mv	a0,s1
    80005086:	ffffd097          	auipc	ra,0xffffd
    8000508a:	9ea080e7          	jalr	-1558(ra) # 80001a70 <proc_pagetable>
    8000508e:	8b2a                	mv	s6,a0
    80005090:	d555                	beqz	a0,8000503c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005092:	e7042783          	lw	a5,-400(s0)
    80005096:	e8845703          	lhu	a4,-376(s0)
    8000509a:	c735                	beqz	a4,80005106 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000509c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000509e:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800050a2:	6a05                	lui	s4,0x1
    800050a4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800050a8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800050ac:	6d85                	lui	s11,0x1
    800050ae:	7d7d                	lui	s10,0xfffff
    800050b0:	ac3d                	j	800052ee <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800050b2:	00004517          	auipc	a0,0x4
    800050b6:	71650513          	addi	a0,a0,1814 # 800097c8 <syscalls+0x378>
    800050ba:	ffffb097          	auipc	ra,0xffffb
    800050be:	486080e7          	jalr	1158(ra) # 80000540 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800050c2:	874a                	mv	a4,s2
    800050c4:	009c86bb          	addw	a3,s9,s1
    800050c8:	4581                	li	a1,0
    800050ca:	8556                	mv	a0,s5
    800050cc:	fffff097          	auipc	ra,0xfffff
    800050d0:	bac080e7          	jalr	-1108(ra) # 80003c78 <readi>
    800050d4:	2501                	sext.w	a0,a0
    800050d6:	1aa91963          	bne	s2,a0,80005288 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    800050da:	009d84bb          	addw	s1,s11,s1
    800050de:	013d09bb          	addw	s3,s10,s3
    800050e2:	1f74f663          	bgeu	s1,s7,800052ce <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    800050e6:	02049593          	slli	a1,s1,0x20
    800050ea:	9181                	srli	a1,a1,0x20
    800050ec:	95e2                	add	a1,a1,s8
    800050ee:	855a                	mv	a0,s6
    800050f0:	ffffc097          	auipc	ra,0xffffc
    800050f4:	f6c080e7          	jalr	-148(ra) # 8000105c <walkaddr>
    800050f8:	862a                	mv	a2,a0
    if(pa == 0)
    800050fa:	dd45                	beqz	a0,800050b2 <exec+0xfe>
      n = PGSIZE;
    800050fc:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800050fe:	fd49f2e3          	bgeu	s3,s4,800050c2 <exec+0x10e>
      n = sz - i;
    80005102:	894e                	mv	s2,s3
    80005104:	bf7d                	j	800050c2 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005106:	4901                	li	s2,0
  iunlockput(ip);
    80005108:	8556                	mv	a0,s5
    8000510a:	fffff097          	auipc	ra,0xfffff
    8000510e:	b1c080e7          	jalr	-1252(ra) # 80003c26 <iunlockput>
  end_op();
    80005112:	fffff097          	auipc	ra,0xfffff
    80005116:	2fc080e7          	jalr	764(ra) # 8000440e <end_op>
  p = myproc();
    8000511a:	ffffd097          	auipc	ra,0xffffd
    8000511e:	892080e7          	jalr	-1902(ra) # 800019ac <myproc>
    80005122:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80005124:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005128:	6785                	lui	a5,0x1
    8000512a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000512c:	97ca                	add	a5,a5,s2
    8000512e:	777d                	lui	a4,0xfffff
    80005130:	8ff9                	and	a5,a5,a4
    80005132:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005136:	4691                	li	a3,4
    80005138:	6609                	lui	a2,0x2
    8000513a:	963e                	add	a2,a2,a5
    8000513c:	85be                	mv	a1,a5
    8000513e:	855a                	mv	a0,s6
    80005140:	ffffc097          	auipc	ra,0xffffc
    80005144:	2d0080e7          	jalr	720(ra) # 80001410 <uvmalloc>
    80005148:	8c2a                	mv	s8,a0
  ip = 0;
    8000514a:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000514c:	12050e63          	beqz	a0,80005288 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005150:	75f9                	lui	a1,0xffffe
    80005152:	95aa                	add	a1,a1,a0
    80005154:	855a                	mv	a0,s6
    80005156:	ffffc097          	auipc	ra,0xffffc
    8000515a:	4e4080e7          	jalr	1252(ra) # 8000163a <uvmclear>
  stackbase = sp - PGSIZE;
    8000515e:	7afd                	lui	s5,0xfffff
    80005160:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80005162:	df043783          	ld	a5,-528(s0)
    80005166:	6388                	ld	a0,0(a5)
    80005168:	c925                	beqz	a0,800051d8 <exec+0x224>
    8000516a:	e9040993          	addi	s3,s0,-368
    8000516e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80005172:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005174:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005176:	ffffc097          	auipc	ra,0xffffc
    8000517a:	cd8080e7          	jalr	-808(ra) # 80000e4e <strlen>
    8000517e:	0015079b          	addiw	a5,a0,1
    80005182:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005186:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000518a:	13596663          	bltu	s2,s5,800052b6 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000518e:	df043d83          	ld	s11,-528(s0)
    80005192:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005196:	8552                	mv	a0,s4
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	cb6080e7          	jalr	-842(ra) # 80000e4e <strlen>
    800051a0:	0015069b          	addiw	a3,a0,1
    800051a4:	8652                	mv	a2,s4
    800051a6:	85ca                	mv	a1,s2
    800051a8:	855a                	mv	a0,s6
    800051aa:	ffffc097          	auipc	ra,0xffffc
    800051ae:	4c2080e7          	jalr	1218(ra) # 8000166c <copyout>
    800051b2:	10054663          	bltz	a0,800052be <exec+0x30a>
    ustack[argc] = sp;
    800051b6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800051ba:	0485                	addi	s1,s1,1
    800051bc:	008d8793          	addi	a5,s11,8
    800051c0:	def43823          	sd	a5,-528(s0)
    800051c4:	008db503          	ld	a0,8(s11)
    800051c8:	c911                	beqz	a0,800051dc <exec+0x228>
    if(argc >= MAXARG)
    800051ca:	09a1                	addi	s3,s3,8
    800051cc:	fb3c95e3          	bne	s9,s3,80005176 <exec+0x1c2>
  sz = sz1;
    800051d0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800051d4:	4a81                	li	s5,0
    800051d6:	a84d                	j	80005288 <exec+0x2d4>
  sp = sz;
    800051d8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800051da:	4481                	li	s1,0
  ustack[argc] = 0;
    800051dc:	00349793          	slli	a5,s1,0x3
    800051e0:	f9078793          	addi	a5,a5,-112
    800051e4:	97a2                	add	a5,a5,s0
    800051e6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800051ea:	00148693          	addi	a3,s1,1
    800051ee:	068e                	slli	a3,a3,0x3
    800051f0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800051f4:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800051f8:	01597663          	bgeu	s2,s5,80005204 <exec+0x250>
  sz = sz1;
    800051fc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005200:	4a81                	li	s5,0
    80005202:	a059                	j	80005288 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005204:	e9040613          	addi	a2,s0,-368
    80005208:	85ca                	mv	a1,s2
    8000520a:	855a                	mv	a0,s6
    8000520c:	ffffc097          	auipc	ra,0xffffc
    80005210:	460080e7          	jalr	1120(ra) # 8000166c <copyout>
    80005214:	0a054963          	bltz	a0,800052c6 <exec+0x312>
  p->trapframe->a1 = sp;
    80005218:	058bb783          	ld	a5,88(s7)
    8000521c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005220:	de843783          	ld	a5,-536(s0)
    80005224:	0007c703          	lbu	a4,0(a5)
    80005228:	cf11                	beqz	a4,80005244 <exec+0x290>
    8000522a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000522c:	02f00693          	li	a3,47
    80005230:	a039                	j	8000523e <exec+0x28a>
      last = s+1;
    80005232:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005236:	0785                	addi	a5,a5,1
    80005238:	fff7c703          	lbu	a4,-1(a5)
    8000523c:	c701                	beqz	a4,80005244 <exec+0x290>
    if(*s == '/')
    8000523e:	fed71ce3          	bne	a4,a3,80005236 <exec+0x282>
    80005242:	bfc5                	j	80005232 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80005244:	4641                	li	a2,16
    80005246:	de843583          	ld	a1,-536(s0)
    8000524a:	158b8513          	addi	a0,s7,344
    8000524e:	ffffc097          	auipc	ra,0xffffc
    80005252:	bce080e7          	jalr	-1074(ra) # 80000e1c <safestrcpy>
  oldpagetable = p->pagetable;
    80005256:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000525a:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000525e:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005262:	058bb783          	ld	a5,88(s7)
    80005266:	e6843703          	ld	a4,-408(s0)
    8000526a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000526c:	058bb783          	ld	a5,88(s7)
    80005270:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005274:	85ea                	mv	a1,s10
    80005276:	ffffd097          	auipc	ra,0xffffd
    8000527a:	896080e7          	jalr	-1898(ra) # 80001b0c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000527e:	0004851b          	sext.w	a0,s1
    80005282:	b3f9                	j	80005050 <exec+0x9c>
    80005284:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005288:	df843583          	ld	a1,-520(s0)
    8000528c:	855a                	mv	a0,s6
    8000528e:	ffffd097          	auipc	ra,0xffffd
    80005292:	87e080e7          	jalr	-1922(ra) # 80001b0c <proc_freepagetable>
  if(ip){
    80005296:	da0a93e3          	bnez	s5,8000503c <exec+0x88>
  return -1;
    8000529a:	557d                	li	a0,-1
    8000529c:	bb55                	j	80005050 <exec+0x9c>
    8000529e:	df243c23          	sd	s2,-520(s0)
    800052a2:	b7dd                	j	80005288 <exec+0x2d4>
    800052a4:	df243c23          	sd	s2,-520(s0)
    800052a8:	b7c5                	j	80005288 <exec+0x2d4>
    800052aa:	df243c23          	sd	s2,-520(s0)
    800052ae:	bfe9                	j	80005288 <exec+0x2d4>
    800052b0:	df243c23          	sd	s2,-520(s0)
    800052b4:	bfd1                	j	80005288 <exec+0x2d4>
  sz = sz1;
    800052b6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800052ba:	4a81                	li	s5,0
    800052bc:	b7f1                	j	80005288 <exec+0x2d4>
  sz = sz1;
    800052be:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800052c2:	4a81                	li	s5,0
    800052c4:	b7d1                	j	80005288 <exec+0x2d4>
  sz = sz1;
    800052c6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800052ca:	4a81                	li	s5,0
    800052cc:	bf75                	j	80005288 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800052ce:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052d2:	e0843783          	ld	a5,-504(s0)
    800052d6:	0017869b          	addiw	a3,a5,1
    800052da:	e0d43423          	sd	a3,-504(s0)
    800052de:	e0043783          	ld	a5,-512(s0)
    800052e2:	0387879b          	addiw	a5,a5,56
    800052e6:	e8845703          	lhu	a4,-376(s0)
    800052ea:	e0e6dfe3          	bge	a3,a4,80005108 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800052ee:	2781                	sext.w	a5,a5
    800052f0:	e0f43023          	sd	a5,-512(s0)
    800052f4:	03800713          	li	a4,56
    800052f8:	86be                	mv	a3,a5
    800052fa:	e1840613          	addi	a2,s0,-488
    800052fe:	4581                	li	a1,0
    80005300:	8556                	mv	a0,s5
    80005302:	fffff097          	auipc	ra,0xfffff
    80005306:	976080e7          	jalr	-1674(ra) # 80003c78 <readi>
    8000530a:	03800793          	li	a5,56
    8000530e:	f6f51be3          	bne	a0,a5,80005284 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    80005312:	e1842783          	lw	a5,-488(s0)
    80005316:	4705                	li	a4,1
    80005318:	fae79de3          	bne	a5,a4,800052d2 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    8000531c:	e4043483          	ld	s1,-448(s0)
    80005320:	e3843783          	ld	a5,-456(s0)
    80005324:	f6f4ede3          	bltu	s1,a5,8000529e <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005328:	e2843783          	ld	a5,-472(s0)
    8000532c:	94be                	add	s1,s1,a5
    8000532e:	f6f4ebe3          	bltu	s1,a5,800052a4 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80005332:	de043703          	ld	a4,-544(s0)
    80005336:	8ff9                	and	a5,a5,a4
    80005338:	fbad                	bnez	a5,800052aa <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000533a:	e1c42503          	lw	a0,-484(s0)
    8000533e:	00000097          	auipc	ra,0x0
    80005342:	c5c080e7          	jalr	-932(ra) # 80004f9a <flags2perm>
    80005346:	86aa                	mv	a3,a0
    80005348:	8626                	mv	a2,s1
    8000534a:	85ca                	mv	a1,s2
    8000534c:	855a                	mv	a0,s6
    8000534e:	ffffc097          	auipc	ra,0xffffc
    80005352:	0c2080e7          	jalr	194(ra) # 80001410 <uvmalloc>
    80005356:	dea43c23          	sd	a0,-520(s0)
    8000535a:	d939                	beqz	a0,800052b0 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000535c:	e2843c03          	ld	s8,-472(s0)
    80005360:	e2042c83          	lw	s9,-480(s0)
    80005364:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005368:	f60b83e3          	beqz	s7,800052ce <exec+0x31a>
    8000536c:	89de                	mv	s3,s7
    8000536e:	4481                	li	s1,0
    80005370:	bb9d                	j	800050e6 <exec+0x132>

0000000080005372 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005372:	7179                	addi	sp,sp,-48
    80005374:	f406                	sd	ra,40(sp)
    80005376:	f022                	sd	s0,32(sp)
    80005378:	ec26                	sd	s1,24(sp)
    8000537a:	e84a                	sd	s2,16(sp)
    8000537c:	1800                	addi	s0,sp,48
    8000537e:	892e                	mv	s2,a1
    80005380:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005382:	fdc40593          	addi	a1,s0,-36
    80005386:	ffffd097          	auipc	ra,0xffffd
    8000538a:	760080e7          	jalr	1888(ra) # 80002ae6 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000538e:	fdc42703          	lw	a4,-36(s0)
    80005392:	47bd                	li	a5,15
    80005394:	02e7eb63          	bltu	a5,a4,800053ca <argfd+0x58>
    80005398:	ffffc097          	auipc	ra,0xffffc
    8000539c:	614080e7          	jalr	1556(ra) # 800019ac <myproc>
    800053a0:	fdc42703          	lw	a4,-36(s0)
    800053a4:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdb9da>
    800053a8:	078e                	slli	a5,a5,0x3
    800053aa:	953e                	add	a0,a0,a5
    800053ac:	611c                	ld	a5,0(a0)
    800053ae:	c385                	beqz	a5,800053ce <argfd+0x5c>
    return -1;
  if(pfd)
    800053b0:	00090463          	beqz	s2,800053b8 <argfd+0x46>
    *pfd = fd;
    800053b4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800053b8:	4501                	li	a0,0
  if(pf)
    800053ba:	c091                	beqz	s1,800053be <argfd+0x4c>
    *pf = f;
    800053bc:	e09c                	sd	a5,0(s1)
}
    800053be:	70a2                	ld	ra,40(sp)
    800053c0:	7402                	ld	s0,32(sp)
    800053c2:	64e2                	ld	s1,24(sp)
    800053c4:	6942                	ld	s2,16(sp)
    800053c6:	6145                	addi	sp,sp,48
    800053c8:	8082                	ret
    return -1;
    800053ca:	557d                	li	a0,-1
    800053cc:	bfcd                	j	800053be <argfd+0x4c>
    800053ce:	557d                	li	a0,-1
    800053d0:	b7fd                	j	800053be <argfd+0x4c>

00000000800053d2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800053d2:	1101                	addi	sp,sp,-32
    800053d4:	ec06                	sd	ra,24(sp)
    800053d6:	e822                	sd	s0,16(sp)
    800053d8:	e426                	sd	s1,8(sp)
    800053da:	1000                	addi	s0,sp,32
    800053dc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800053de:	ffffc097          	auipc	ra,0xffffc
    800053e2:	5ce080e7          	jalr	1486(ra) # 800019ac <myproc>
    800053e6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800053e8:	0d050793          	addi	a5,a0,208
    800053ec:	4501                	li	a0,0
    800053ee:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800053f0:	6398                	ld	a4,0(a5)
    800053f2:	cb19                	beqz	a4,80005408 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800053f4:	2505                	addiw	a0,a0,1
    800053f6:	07a1                	addi	a5,a5,8
    800053f8:	fed51ce3          	bne	a0,a3,800053f0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800053fc:	557d                	li	a0,-1
}
    800053fe:	60e2                	ld	ra,24(sp)
    80005400:	6442                	ld	s0,16(sp)
    80005402:	64a2                	ld	s1,8(sp)
    80005404:	6105                	addi	sp,sp,32
    80005406:	8082                	ret
      p->ofile[fd] = f;
    80005408:	01a50793          	addi	a5,a0,26
    8000540c:	078e                	slli	a5,a5,0x3
    8000540e:	963e                	add	a2,a2,a5
    80005410:	e204                	sd	s1,0(a2)
      return fd;
    80005412:	b7f5                	j	800053fe <fdalloc+0x2c>

0000000080005414 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005414:	715d                	addi	sp,sp,-80
    80005416:	e486                	sd	ra,72(sp)
    80005418:	e0a2                	sd	s0,64(sp)
    8000541a:	fc26                	sd	s1,56(sp)
    8000541c:	f84a                	sd	s2,48(sp)
    8000541e:	f44e                	sd	s3,40(sp)
    80005420:	f052                	sd	s4,32(sp)
    80005422:	ec56                	sd	s5,24(sp)
    80005424:	e85a                	sd	s6,16(sp)
    80005426:	0880                	addi	s0,sp,80
    80005428:	8b2e                	mv	s6,a1
    8000542a:	89b2                	mv	s3,a2
    8000542c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000542e:	fb040593          	addi	a1,s0,-80
    80005432:	fffff097          	auipc	ra,0xfffff
    80005436:	d5c080e7          	jalr	-676(ra) # 8000418e <nameiparent>
    8000543a:	84aa                	mv	s1,a0
    8000543c:	14050f63          	beqz	a0,8000559a <create+0x186>
    return 0;

  ilock(dp);
    80005440:	ffffe097          	auipc	ra,0xffffe
    80005444:	584080e7          	jalr	1412(ra) # 800039c4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005448:	4601                	li	a2,0
    8000544a:	fb040593          	addi	a1,s0,-80
    8000544e:	8526                	mv	a0,s1
    80005450:	fffff097          	auipc	ra,0xfffff
    80005454:	a58080e7          	jalr	-1448(ra) # 80003ea8 <dirlookup>
    80005458:	8aaa                	mv	s5,a0
    8000545a:	c931                	beqz	a0,800054ae <create+0x9a>
    iunlockput(dp);
    8000545c:	8526                	mv	a0,s1
    8000545e:	ffffe097          	auipc	ra,0xffffe
    80005462:	7c8080e7          	jalr	1992(ra) # 80003c26 <iunlockput>
    ilock(ip);
    80005466:	8556                	mv	a0,s5
    80005468:	ffffe097          	auipc	ra,0xffffe
    8000546c:	55c080e7          	jalr	1372(ra) # 800039c4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005470:	000b059b          	sext.w	a1,s6
    80005474:	4789                	li	a5,2
    80005476:	02f59563          	bne	a1,a5,800054a0 <create+0x8c>
    8000547a:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdba04>
    8000547e:	37f9                	addiw	a5,a5,-2
    80005480:	17c2                	slli	a5,a5,0x30
    80005482:	93c1                	srli	a5,a5,0x30
    80005484:	4705                	li	a4,1
    80005486:	00f76d63          	bltu	a4,a5,800054a0 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000548a:	8556                	mv	a0,s5
    8000548c:	60a6                	ld	ra,72(sp)
    8000548e:	6406                	ld	s0,64(sp)
    80005490:	74e2                	ld	s1,56(sp)
    80005492:	7942                	ld	s2,48(sp)
    80005494:	79a2                	ld	s3,40(sp)
    80005496:	7a02                	ld	s4,32(sp)
    80005498:	6ae2                	ld	s5,24(sp)
    8000549a:	6b42                	ld	s6,16(sp)
    8000549c:	6161                	addi	sp,sp,80
    8000549e:	8082                	ret
    iunlockput(ip);
    800054a0:	8556                	mv	a0,s5
    800054a2:	ffffe097          	auipc	ra,0xffffe
    800054a6:	784080e7          	jalr	1924(ra) # 80003c26 <iunlockput>
    return 0;
    800054aa:	4a81                	li	s5,0
    800054ac:	bff9                	j	8000548a <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800054ae:	85da                	mv	a1,s6
    800054b0:	4088                	lw	a0,0(s1)
    800054b2:	ffffe097          	auipc	ra,0xffffe
    800054b6:	374080e7          	jalr	884(ra) # 80003826 <ialloc>
    800054ba:	8a2a                	mv	s4,a0
    800054bc:	c539                	beqz	a0,8000550a <create+0xf6>
  ilock(ip);
    800054be:	ffffe097          	auipc	ra,0xffffe
    800054c2:	506080e7          	jalr	1286(ra) # 800039c4 <ilock>
  ip->major = major;
    800054c6:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800054ca:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800054ce:	4905                	li	s2,1
    800054d0:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800054d4:	8552                	mv	a0,s4
    800054d6:	ffffe097          	auipc	ra,0xffffe
    800054da:	422080e7          	jalr	1058(ra) # 800038f8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800054de:	000b059b          	sext.w	a1,s6
    800054e2:	03258b63          	beq	a1,s2,80005518 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800054e6:	004a2603          	lw	a2,4(s4)
    800054ea:	fb040593          	addi	a1,s0,-80
    800054ee:	8526                	mv	a0,s1
    800054f0:	fffff097          	auipc	ra,0xfffff
    800054f4:	bce080e7          	jalr	-1074(ra) # 800040be <dirlink>
    800054f8:	06054f63          	bltz	a0,80005576 <create+0x162>
  iunlockput(dp);
    800054fc:	8526                	mv	a0,s1
    800054fe:	ffffe097          	auipc	ra,0xffffe
    80005502:	728080e7          	jalr	1832(ra) # 80003c26 <iunlockput>
  return ip;
    80005506:	8ad2                	mv	s5,s4
    80005508:	b749                	j	8000548a <create+0x76>
    iunlockput(dp);
    8000550a:	8526                	mv	a0,s1
    8000550c:	ffffe097          	auipc	ra,0xffffe
    80005510:	71a080e7          	jalr	1818(ra) # 80003c26 <iunlockput>
    return 0;
    80005514:	8ad2                	mv	s5,s4
    80005516:	bf95                	j	8000548a <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005518:	004a2603          	lw	a2,4(s4)
    8000551c:	00004597          	auipc	a1,0x4
    80005520:	2cc58593          	addi	a1,a1,716 # 800097e8 <syscalls+0x398>
    80005524:	8552                	mv	a0,s4
    80005526:	fffff097          	auipc	ra,0xfffff
    8000552a:	b98080e7          	jalr	-1128(ra) # 800040be <dirlink>
    8000552e:	04054463          	bltz	a0,80005576 <create+0x162>
    80005532:	40d0                	lw	a2,4(s1)
    80005534:	00004597          	auipc	a1,0x4
    80005538:	2bc58593          	addi	a1,a1,700 # 800097f0 <syscalls+0x3a0>
    8000553c:	8552                	mv	a0,s4
    8000553e:	fffff097          	auipc	ra,0xfffff
    80005542:	b80080e7          	jalr	-1152(ra) # 800040be <dirlink>
    80005546:	02054863          	bltz	a0,80005576 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    8000554a:	004a2603          	lw	a2,4(s4)
    8000554e:	fb040593          	addi	a1,s0,-80
    80005552:	8526                	mv	a0,s1
    80005554:	fffff097          	auipc	ra,0xfffff
    80005558:	b6a080e7          	jalr	-1174(ra) # 800040be <dirlink>
    8000555c:	00054d63          	bltz	a0,80005576 <create+0x162>
    dp->nlink++;  // for ".."
    80005560:	04a4d783          	lhu	a5,74(s1)
    80005564:	2785                	addiw	a5,a5,1
    80005566:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000556a:	8526                	mv	a0,s1
    8000556c:	ffffe097          	auipc	ra,0xffffe
    80005570:	38c080e7          	jalr	908(ra) # 800038f8 <iupdate>
    80005574:	b761                	j	800054fc <create+0xe8>
  ip->nlink = 0;
    80005576:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000557a:	8552                	mv	a0,s4
    8000557c:	ffffe097          	auipc	ra,0xffffe
    80005580:	37c080e7          	jalr	892(ra) # 800038f8 <iupdate>
  iunlockput(ip);
    80005584:	8552                	mv	a0,s4
    80005586:	ffffe097          	auipc	ra,0xffffe
    8000558a:	6a0080e7          	jalr	1696(ra) # 80003c26 <iunlockput>
  iunlockput(dp);
    8000558e:	8526                	mv	a0,s1
    80005590:	ffffe097          	auipc	ra,0xffffe
    80005594:	696080e7          	jalr	1686(ra) # 80003c26 <iunlockput>
  return 0;
    80005598:	bdcd                	j	8000548a <create+0x76>
    return 0;
    8000559a:	8aaa                	mv	s5,a0
    8000559c:	b5fd                	j	8000548a <create+0x76>

000000008000559e <sys_dup>:
{
    8000559e:	7179                	addi	sp,sp,-48
    800055a0:	f406                	sd	ra,40(sp)
    800055a2:	f022                	sd	s0,32(sp)
    800055a4:	ec26                	sd	s1,24(sp)
    800055a6:	e84a                	sd	s2,16(sp)
    800055a8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800055aa:	fd840613          	addi	a2,s0,-40
    800055ae:	4581                	li	a1,0
    800055b0:	4501                	li	a0,0
    800055b2:	00000097          	auipc	ra,0x0
    800055b6:	dc0080e7          	jalr	-576(ra) # 80005372 <argfd>
    return -1;
    800055ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800055bc:	02054363          	bltz	a0,800055e2 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800055c0:	fd843903          	ld	s2,-40(s0)
    800055c4:	854a                	mv	a0,s2
    800055c6:	00000097          	auipc	ra,0x0
    800055ca:	e0c080e7          	jalr	-500(ra) # 800053d2 <fdalloc>
    800055ce:	84aa                	mv	s1,a0
    return -1;
    800055d0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800055d2:	00054863          	bltz	a0,800055e2 <sys_dup+0x44>
  filedup(f);
    800055d6:	854a                	mv	a0,s2
    800055d8:	fffff097          	auipc	ra,0xfffff
    800055dc:	22e080e7          	jalr	558(ra) # 80004806 <filedup>
  return fd;
    800055e0:	87a6                	mv	a5,s1
}
    800055e2:	853e                	mv	a0,a5
    800055e4:	70a2                	ld	ra,40(sp)
    800055e6:	7402                	ld	s0,32(sp)
    800055e8:	64e2                	ld	s1,24(sp)
    800055ea:	6942                	ld	s2,16(sp)
    800055ec:	6145                	addi	sp,sp,48
    800055ee:	8082                	ret

00000000800055f0 <sys_read>:
{
    800055f0:	7179                	addi	sp,sp,-48
    800055f2:	f406                	sd	ra,40(sp)
    800055f4:	f022                	sd	s0,32(sp)
    800055f6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800055f8:	fd840593          	addi	a1,s0,-40
    800055fc:	4505                	li	a0,1
    800055fe:	ffffd097          	auipc	ra,0xffffd
    80005602:	508080e7          	jalr	1288(ra) # 80002b06 <argaddr>
  argint(2, &n);
    80005606:	fe440593          	addi	a1,s0,-28
    8000560a:	4509                	li	a0,2
    8000560c:	ffffd097          	auipc	ra,0xffffd
    80005610:	4da080e7          	jalr	1242(ra) # 80002ae6 <argint>
  if(argfd(0, 0, &f) < 0)
    80005614:	fe840613          	addi	a2,s0,-24
    80005618:	4581                	li	a1,0
    8000561a:	4501                	li	a0,0
    8000561c:	00000097          	auipc	ra,0x0
    80005620:	d56080e7          	jalr	-682(ra) # 80005372 <argfd>
    80005624:	87aa                	mv	a5,a0
    return -1;
    80005626:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005628:	0007cc63          	bltz	a5,80005640 <sys_read+0x50>
  return fileread(f, p, n);
    8000562c:	fe442603          	lw	a2,-28(s0)
    80005630:	fd843583          	ld	a1,-40(s0)
    80005634:	fe843503          	ld	a0,-24(s0)
    80005638:	fffff097          	auipc	ra,0xfffff
    8000563c:	35a080e7          	jalr	858(ra) # 80004992 <fileread>
}
    80005640:	70a2                	ld	ra,40(sp)
    80005642:	7402                	ld	s0,32(sp)
    80005644:	6145                	addi	sp,sp,48
    80005646:	8082                	ret

0000000080005648 <sys_write>:
{
    80005648:	7179                	addi	sp,sp,-48
    8000564a:	f406                	sd	ra,40(sp)
    8000564c:	f022                	sd	s0,32(sp)
    8000564e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005650:	fd840593          	addi	a1,s0,-40
    80005654:	4505                	li	a0,1
    80005656:	ffffd097          	auipc	ra,0xffffd
    8000565a:	4b0080e7          	jalr	1200(ra) # 80002b06 <argaddr>
  argint(2, &n);
    8000565e:	fe440593          	addi	a1,s0,-28
    80005662:	4509                	li	a0,2
    80005664:	ffffd097          	auipc	ra,0xffffd
    80005668:	482080e7          	jalr	1154(ra) # 80002ae6 <argint>
  if(argfd(0, 0, &f) < 0)
    8000566c:	fe840613          	addi	a2,s0,-24
    80005670:	4581                	li	a1,0
    80005672:	4501                	li	a0,0
    80005674:	00000097          	auipc	ra,0x0
    80005678:	cfe080e7          	jalr	-770(ra) # 80005372 <argfd>
    8000567c:	87aa                	mv	a5,a0
    return -1;
    8000567e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005680:	0007cc63          	bltz	a5,80005698 <sys_write+0x50>
  return filewrite(f, p, n);
    80005684:	fe442603          	lw	a2,-28(s0)
    80005688:	fd843583          	ld	a1,-40(s0)
    8000568c:	fe843503          	ld	a0,-24(s0)
    80005690:	fffff097          	auipc	ra,0xfffff
    80005694:	3c4080e7          	jalr	964(ra) # 80004a54 <filewrite>
}
    80005698:	70a2                	ld	ra,40(sp)
    8000569a:	7402                	ld	s0,32(sp)
    8000569c:	6145                	addi	sp,sp,48
    8000569e:	8082                	ret

00000000800056a0 <sys_close>:
{
    800056a0:	1101                	addi	sp,sp,-32
    800056a2:	ec06                	sd	ra,24(sp)
    800056a4:	e822                	sd	s0,16(sp)
    800056a6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800056a8:	fe040613          	addi	a2,s0,-32
    800056ac:	fec40593          	addi	a1,s0,-20
    800056b0:	4501                	li	a0,0
    800056b2:	00000097          	auipc	ra,0x0
    800056b6:	cc0080e7          	jalr	-832(ra) # 80005372 <argfd>
    return -1;
    800056ba:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800056bc:	02054463          	bltz	a0,800056e4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800056c0:	ffffc097          	auipc	ra,0xffffc
    800056c4:	2ec080e7          	jalr	748(ra) # 800019ac <myproc>
    800056c8:	fec42783          	lw	a5,-20(s0)
    800056cc:	07e9                	addi	a5,a5,26
    800056ce:	078e                	slli	a5,a5,0x3
    800056d0:	953e                	add	a0,a0,a5
    800056d2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800056d6:	fe043503          	ld	a0,-32(s0)
    800056da:	fffff097          	auipc	ra,0xfffff
    800056de:	17e080e7          	jalr	382(ra) # 80004858 <fileclose>
  return 0;
    800056e2:	4781                	li	a5,0
}
    800056e4:	853e                	mv	a0,a5
    800056e6:	60e2                	ld	ra,24(sp)
    800056e8:	6442                	ld	s0,16(sp)
    800056ea:	6105                	addi	sp,sp,32
    800056ec:	8082                	ret

00000000800056ee <sys_fstat>:
{
    800056ee:	1101                	addi	sp,sp,-32
    800056f0:	ec06                	sd	ra,24(sp)
    800056f2:	e822                	sd	s0,16(sp)
    800056f4:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800056f6:	fe040593          	addi	a1,s0,-32
    800056fa:	4505                	li	a0,1
    800056fc:	ffffd097          	auipc	ra,0xffffd
    80005700:	40a080e7          	jalr	1034(ra) # 80002b06 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005704:	fe840613          	addi	a2,s0,-24
    80005708:	4581                	li	a1,0
    8000570a:	4501                	li	a0,0
    8000570c:	00000097          	auipc	ra,0x0
    80005710:	c66080e7          	jalr	-922(ra) # 80005372 <argfd>
    80005714:	87aa                	mv	a5,a0
    return -1;
    80005716:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005718:	0007ca63          	bltz	a5,8000572c <sys_fstat+0x3e>
  return filestat(f, st);
    8000571c:	fe043583          	ld	a1,-32(s0)
    80005720:	fe843503          	ld	a0,-24(s0)
    80005724:	fffff097          	auipc	ra,0xfffff
    80005728:	1fc080e7          	jalr	508(ra) # 80004920 <filestat>
}
    8000572c:	60e2                	ld	ra,24(sp)
    8000572e:	6442                	ld	s0,16(sp)
    80005730:	6105                	addi	sp,sp,32
    80005732:	8082                	ret

0000000080005734 <sys_link>:
{
    80005734:	7169                	addi	sp,sp,-304
    80005736:	f606                	sd	ra,296(sp)
    80005738:	f222                	sd	s0,288(sp)
    8000573a:	ee26                	sd	s1,280(sp)
    8000573c:	ea4a                	sd	s2,272(sp)
    8000573e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005740:	08000613          	li	a2,128
    80005744:	ed040593          	addi	a1,s0,-304
    80005748:	4501                	li	a0,0
    8000574a:	ffffd097          	auipc	ra,0xffffd
    8000574e:	3dc080e7          	jalr	988(ra) # 80002b26 <argstr>
    return -1;
    80005752:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005754:	10054e63          	bltz	a0,80005870 <sys_link+0x13c>
    80005758:	08000613          	li	a2,128
    8000575c:	f5040593          	addi	a1,s0,-176
    80005760:	4505                	li	a0,1
    80005762:	ffffd097          	auipc	ra,0xffffd
    80005766:	3c4080e7          	jalr	964(ra) # 80002b26 <argstr>
    return -1;
    8000576a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000576c:	10054263          	bltz	a0,80005870 <sys_link+0x13c>
  begin_op();
    80005770:	fffff097          	auipc	ra,0xfffff
    80005774:	c20080e7          	jalr	-992(ra) # 80004390 <begin_op>
  if((ip = namei(old)) == 0){
    80005778:	ed040513          	addi	a0,s0,-304
    8000577c:	fffff097          	auipc	ra,0xfffff
    80005780:	9f4080e7          	jalr	-1548(ra) # 80004170 <namei>
    80005784:	84aa                	mv	s1,a0
    80005786:	c551                	beqz	a0,80005812 <sys_link+0xde>
  ilock(ip);
    80005788:	ffffe097          	auipc	ra,0xffffe
    8000578c:	23c080e7          	jalr	572(ra) # 800039c4 <ilock>
  if(ip->type == T_DIR){
    80005790:	04449703          	lh	a4,68(s1)
    80005794:	4785                	li	a5,1
    80005796:	08f70463          	beq	a4,a5,8000581e <sys_link+0xea>
  ip->nlink++;
    8000579a:	04a4d783          	lhu	a5,74(s1)
    8000579e:	2785                	addiw	a5,a5,1
    800057a0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800057a4:	8526                	mv	a0,s1
    800057a6:	ffffe097          	auipc	ra,0xffffe
    800057aa:	152080e7          	jalr	338(ra) # 800038f8 <iupdate>
  iunlock(ip);
    800057ae:	8526                	mv	a0,s1
    800057b0:	ffffe097          	auipc	ra,0xffffe
    800057b4:	2d6080e7          	jalr	726(ra) # 80003a86 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800057b8:	fd040593          	addi	a1,s0,-48
    800057bc:	f5040513          	addi	a0,s0,-176
    800057c0:	fffff097          	auipc	ra,0xfffff
    800057c4:	9ce080e7          	jalr	-1586(ra) # 8000418e <nameiparent>
    800057c8:	892a                	mv	s2,a0
    800057ca:	c935                	beqz	a0,8000583e <sys_link+0x10a>
  ilock(dp);
    800057cc:	ffffe097          	auipc	ra,0xffffe
    800057d0:	1f8080e7          	jalr	504(ra) # 800039c4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800057d4:	00092703          	lw	a4,0(s2)
    800057d8:	409c                	lw	a5,0(s1)
    800057da:	04f71d63          	bne	a4,a5,80005834 <sys_link+0x100>
    800057de:	40d0                	lw	a2,4(s1)
    800057e0:	fd040593          	addi	a1,s0,-48
    800057e4:	854a                	mv	a0,s2
    800057e6:	fffff097          	auipc	ra,0xfffff
    800057ea:	8d8080e7          	jalr	-1832(ra) # 800040be <dirlink>
    800057ee:	04054363          	bltz	a0,80005834 <sys_link+0x100>
  iunlockput(dp);
    800057f2:	854a                	mv	a0,s2
    800057f4:	ffffe097          	auipc	ra,0xffffe
    800057f8:	432080e7          	jalr	1074(ra) # 80003c26 <iunlockput>
  iput(ip);
    800057fc:	8526                	mv	a0,s1
    800057fe:	ffffe097          	auipc	ra,0xffffe
    80005802:	380080e7          	jalr	896(ra) # 80003b7e <iput>
  end_op();
    80005806:	fffff097          	auipc	ra,0xfffff
    8000580a:	c08080e7          	jalr	-1016(ra) # 8000440e <end_op>
  return 0;
    8000580e:	4781                	li	a5,0
    80005810:	a085                	j	80005870 <sys_link+0x13c>
    end_op();
    80005812:	fffff097          	auipc	ra,0xfffff
    80005816:	bfc080e7          	jalr	-1028(ra) # 8000440e <end_op>
    return -1;
    8000581a:	57fd                	li	a5,-1
    8000581c:	a891                	j	80005870 <sys_link+0x13c>
    iunlockput(ip);
    8000581e:	8526                	mv	a0,s1
    80005820:	ffffe097          	auipc	ra,0xffffe
    80005824:	406080e7          	jalr	1030(ra) # 80003c26 <iunlockput>
    end_op();
    80005828:	fffff097          	auipc	ra,0xfffff
    8000582c:	be6080e7          	jalr	-1050(ra) # 8000440e <end_op>
    return -1;
    80005830:	57fd                	li	a5,-1
    80005832:	a83d                	j	80005870 <sys_link+0x13c>
    iunlockput(dp);
    80005834:	854a                	mv	a0,s2
    80005836:	ffffe097          	auipc	ra,0xffffe
    8000583a:	3f0080e7          	jalr	1008(ra) # 80003c26 <iunlockput>
  ilock(ip);
    8000583e:	8526                	mv	a0,s1
    80005840:	ffffe097          	auipc	ra,0xffffe
    80005844:	184080e7          	jalr	388(ra) # 800039c4 <ilock>
  ip->nlink--;
    80005848:	04a4d783          	lhu	a5,74(s1)
    8000584c:	37fd                	addiw	a5,a5,-1
    8000584e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005852:	8526                	mv	a0,s1
    80005854:	ffffe097          	auipc	ra,0xffffe
    80005858:	0a4080e7          	jalr	164(ra) # 800038f8 <iupdate>
  iunlockput(ip);
    8000585c:	8526                	mv	a0,s1
    8000585e:	ffffe097          	auipc	ra,0xffffe
    80005862:	3c8080e7          	jalr	968(ra) # 80003c26 <iunlockput>
  end_op();
    80005866:	fffff097          	auipc	ra,0xfffff
    8000586a:	ba8080e7          	jalr	-1112(ra) # 8000440e <end_op>
  return -1;
    8000586e:	57fd                	li	a5,-1
}
    80005870:	853e                	mv	a0,a5
    80005872:	70b2                	ld	ra,296(sp)
    80005874:	7412                	ld	s0,288(sp)
    80005876:	64f2                	ld	s1,280(sp)
    80005878:	6952                	ld	s2,272(sp)
    8000587a:	6155                	addi	sp,sp,304
    8000587c:	8082                	ret

000000008000587e <sys_unlink>:
{
    8000587e:	7151                	addi	sp,sp,-240
    80005880:	f586                	sd	ra,232(sp)
    80005882:	f1a2                	sd	s0,224(sp)
    80005884:	eda6                	sd	s1,216(sp)
    80005886:	e9ca                	sd	s2,208(sp)
    80005888:	e5ce                	sd	s3,200(sp)
    8000588a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000588c:	08000613          	li	a2,128
    80005890:	f3040593          	addi	a1,s0,-208
    80005894:	4501                	li	a0,0
    80005896:	ffffd097          	auipc	ra,0xffffd
    8000589a:	290080e7          	jalr	656(ra) # 80002b26 <argstr>
    8000589e:	18054163          	bltz	a0,80005a20 <sys_unlink+0x1a2>
  begin_op();
    800058a2:	fffff097          	auipc	ra,0xfffff
    800058a6:	aee080e7          	jalr	-1298(ra) # 80004390 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800058aa:	fb040593          	addi	a1,s0,-80
    800058ae:	f3040513          	addi	a0,s0,-208
    800058b2:	fffff097          	auipc	ra,0xfffff
    800058b6:	8dc080e7          	jalr	-1828(ra) # 8000418e <nameiparent>
    800058ba:	84aa                	mv	s1,a0
    800058bc:	c979                	beqz	a0,80005992 <sys_unlink+0x114>
  ilock(dp);
    800058be:	ffffe097          	auipc	ra,0xffffe
    800058c2:	106080e7          	jalr	262(ra) # 800039c4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800058c6:	00004597          	auipc	a1,0x4
    800058ca:	f2258593          	addi	a1,a1,-222 # 800097e8 <syscalls+0x398>
    800058ce:	fb040513          	addi	a0,s0,-80
    800058d2:	ffffe097          	auipc	ra,0xffffe
    800058d6:	5bc080e7          	jalr	1468(ra) # 80003e8e <namecmp>
    800058da:	14050a63          	beqz	a0,80005a2e <sys_unlink+0x1b0>
    800058de:	00004597          	auipc	a1,0x4
    800058e2:	f1258593          	addi	a1,a1,-238 # 800097f0 <syscalls+0x3a0>
    800058e6:	fb040513          	addi	a0,s0,-80
    800058ea:	ffffe097          	auipc	ra,0xffffe
    800058ee:	5a4080e7          	jalr	1444(ra) # 80003e8e <namecmp>
    800058f2:	12050e63          	beqz	a0,80005a2e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800058f6:	f2c40613          	addi	a2,s0,-212
    800058fa:	fb040593          	addi	a1,s0,-80
    800058fe:	8526                	mv	a0,s1
    80005900:	ffffe097          	auipc	ra,0xffffe
    80005904:	5a8080e7          	jalr	1448(ra) # 80003ea8 <dirlookup>
    80005908:	892a                	mv	s2,a0
    8000590a:	12050263          	beqz	a0,80005a2e <sys_unlink+0x1b0>
  ilock(ip);
    8000590e:	ffffe097          	auipc	ra,0xffffe
    80005912:	0b6080e7          	jalr	182(ra) # 800039c4 <ilock>
  if(ip->nlink < 1)
    80005916:	04a91783          	lh	a5,74(s2)
    8000591a:	08f05263          	blez	a5,8000599e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000591e:	04491703          	lh	a4,68(s2)
    80005922:	4785                	li	a5,1
    80005924:	08f70563          	beq	a4,a5,800059ae <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005928:	4641                	li	a2,16
    8000592a:	4581                	li	a1,0
    8000592c:	fc040513          	addi	a0,s0,-64
    80005930:	ffffb097          	auipc	ra,0xffffb
    80005934:	3a2080e7          	jalr	930(ra) # 80000cd2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005938:	4741                	li	a4,16
    8000593a:	f2c42683          	lw	a3,-212(s0)
    8000593e:	fc040613          	addi	a2,s0,-64
    80005942:	4581                	li	a1,0
    80005944:	8526                	mv	a0,s1
    80005946:	ffffe097          	auipc	ra,0xffffe
    8000594a:	42a080e7          	jalr	1066(ra) # 80003d70 <writei>
    8000594e:	47c1                	li	a5,16
    80005950:	0af51563          	bne	a0,a5,800059fa <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005954:	04491703          	lh	a4,68(s2)
    80005958:	4785                	li	a5,1
    8000595a:	0af70863          	beq	a4,a5,80005a0a <sys_unlink+0x18c>
  iunlockput(dp);
    8000595e:	8526                	mv	a0,s1
    80005960:	ffffe097          	auipc	ra,0xffffe
    80005964:	2c6080e7          	jalr	710(ra) # 80003c26 <iunlockput>
  ip->nlink--;
    80005968:	04a95783          	lhu	a5,74(s2)
    8000596c:	37fd                	addiw	a5,a5,-1
    8000596e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005972:	854a                	mv	a0,s2
    80005974:	ffffe097          	auipc	ra,0xffffe
    80005978:	f84080e7          	jalr	-124(ra) # 800038f8 <iupdate>
  iunlockput(ip);
    8000597c:	854a                	mv	a0,s2
    8000597e:	ffffe097          	auipc	ra,0xffffe
    80005982:	2a8080e7          	jalr	680(ra) # 80003c26 <iunlockput>
  end_op();
    80005986:	fffff097          	auipc	ra,0xfffff
    8000598a:	a88080e7          	jalr	-1400(ra) # 8000440e <end_op>
  return 0;
    8000598e:	4501                	li	a0,0
    80005990:	a84d                	j	80005a42 <sys_unlink+0x1c4>
    end_op();
    80005992:	fffff097          	auipc	ra,0xfffff
    80005996:	a7c080e7          	jalr	-1412(ra) # 8000440e <end_op>
    return -1;
    8000599a:	557d                	li	a0,-1
    8000599c:	a05d                	j	80005a42 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000599e:	00004517          	auipc	a0,0x4
    800059a2:	e5a50513          	addi	a0,a0,-422 # 800097f8 <syscalls+0x3a8>
    800059a6:	ffffb097          	auipc	ra,0xffffb
    800059aa:	b9a080e7          	jalr	-1126(ra) # 80000540 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800059ae:	04c92703          	lw	a4,76(s2)
    800059b2:	02000793          	li	a5,32
    800059b6:	f6e7f9e3          	bgeu	a5,a4,80005928 <sys_unlink+0xaa>
    800059ba:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800059be:	4741                	li	a4,16
    800059c0:	86ce                	mv	a3,s3
    800059c2:	f1840613          	addi	a2,s0,-232
    800059c6:	4581                	li	a1,0
    800059c8:	854a                	mv	a0,s2
    800059ca:	ffffe097          	auipc	ra,0xffffe
    800059ce:	2ae080e7          	jalr	686(ra) # 80003c78 <readi>
    800059d2:	47c1                	li	a5,16
    800059d4:	00f51b63          	bne	a0,a5,800059ea <sys_unlink+0x16c>
    if(de.inum != 0)
    800059d8:	f1845783          	lhu	a5,-232(s0)
    800059dc:	e7a1                	bnez	a5,80005a24 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800059de:	29c1                	addiw	s3,s3,16
    800059e0:	04c92783          	lw	a5,76(s2)
    800059e4:	fcf9ede3          	bltu	s3,a5,800059be <sys_unlink+0x140>
    800059e8:	b781                	j	80005928 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800059ea:	00004517          	auipc	a0,0x4
    800059ee:	e2650513          	addi	a0,a0,-474 # 80009810 <syscalls+0x3c0>
    800059f2:	ffffb097          	auipc	ra,0xffffb
    800059f6:	b4e080e7          	jalr	-1202(ra) # 80000540 <panic>
    panic("unlink: writei");
    800059fa:	00004517          	auipc	a0,0x4
    800059fe:	e2e50513          	addi	a0,a0,-466 # 80009828 <syscalls+0x3d8>
    80005a02:	ffffb097          	auipc	ra,0xffffb
    80005a06:	b3e080e7          	jalr	-1218(ra) # 80000540 <panic>
    dp->nlink--;
    80005a0a:	04a4d783          	lhu	a5,74(s1)
    80005a0e:	37fd                	addiw	a5,a5,-1
    80005a10:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a14:	8526                	mv	a0,s1
    80005a16:	ffffe097          	auipc	ra,0xffffe
    80005a1a:	ee2080e7          	jalr	-286(ra) # 800038f8 <iupdate>
    80005a1e:	b781                	j	8000595e <sys_unlink+0xe0>
    return -1;
    80005a20:	557d                	li	a0,-1
    80005a22:	a005                	j	80005a42 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005a24:	854a                	mv	a0,s2
    80005a26:	ffffe097          	auipc	ra,0xffffe
    80005a2a:	200080e7          	jalr	512(ra) # 80003c26 <iunlockput>
  iunlockput(dp);
    80005a2e:	8526                	mv	a0,s1
    80005a30:	ffffe097          	auipc	ra,0xffffe
    80005a34:	1f6080e7          	jalr	502(ra) # 80003c26 <iunlockput>
  end_op();
    80005a38:	fffff097          	auipc	ra,0xfffff
    80005a3c:	9d6080e7          	jalr	-1578(ra) # 8000440e <end_op>
  return -1;
    80005a40:	557d                	li	a0,-1
}
    80005a42:	70ae                	ld	ra,232(sp)
    80005a44:	740e                	ld	s0,224(sp)
    80005a46:	64ee                	ld	s1,216(sp)
    80005a48:	694e                	ld	s2,208(sp)
    80005a4a:	69ae                	ld	s3,200(sp)
    80005a4c:	616d                	addi	sp,sp,240
    80005a4e:	8082                	ret

0000000080005a50 <sys_open>:

uint64
sys_open(void)
{
    80005a50:	7131                	addi	sp,sp,-192
    80005a52:	fd06                	sd	ra,184(sp)
    80005a54:	f922                	sd	s0,176(sp)
    80005a56:	f526                	sd	s1,168(sp)
    80005a58:	f14a                	sd	s2,160(sp)
    80005a5a:	ed4e                	sd	s3,152(sp)
    80005a5c:	0180                	addi	s0,sp,192
  struct file *f;
  struct inode *ip;
  int n;


  argint(1, &omode);
    80005a5e:	f4c40593          	addi	a1,s0,-180
    80005a62:	4505                	li	a0,1
    80005a64:	ffffd097          	auipc	ra,0xffffd
    80005a68:	082080e7          	jalr	130(ra) # 80002ae6 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005a6c:	08000613          	li	a2,128
    80005a70:	f5040593          	addi	a1,s0,-176
    80005a74:	4501                	li	a0,0
    80005a76:	ffffd097          	auipc	ra,0xffffd
    80005a7a:	0b0080e7          	jalr	176(ra) # 80002b26 <argstr>
    80005a7e:	87aa                	mv	a5,a0
    return -1;
    80005a80:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005a82:	1207cc63          	bltz	a5,80005bba <sys_open+0x16a>

  begin_op();
    80005a86:	fffff097          	auipc	ra,0xfffff
    80005a8a:	90a080e7          	jalr	-1782(ra) # 80004390 <begin_op>

  if(omode & O_CREATE){
    80005a8e:	f4c42783          	lw	a5,-180(s0)
    80005a92:	2007f793          	andi	a5,a5,512
    80005a96:	cbbd                	beqz	a5,80005b0c <sys_open+0xbc>
    ip = create(path, T_FILE, 0, 0);
    80005a98:	4681                	li	a3,0
    80005a9a:	4601                	li	a2,0
    80005a9c:	4589                	li	a1,2
    80005a9e:	f5040513          	addi	a0,s0,-176
    80005aa2:	00000097          	auipc	ra,0x0
    80005aa6:	972080e7          	jalr	-1678(ra) # 80005414 <create>
    80005aaa:	84aa                	mv	s1,a0
    if(ip == 0){
    80005aac:	c931                	beqz	a0,80005b00 <sys_open+0xb0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005aae:	04449703          	lh	a4,68(s1)
    80005ab2:	478d                	li	a5,3
    80005ab4:	00f71763          	bne	a4,a5,80005ac2 <sys_open+0x72>
    80005ab8:	0464d703          	lhu	a4,70(s1)
    80005abc:	47a5                	li	a5,9
    80005abe:	08e7ec63          	bltu	a5,a4,80005b56 <sys_open+0x106>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005ac2:	fffff097          	auipc	ra,0xfffff
    80005ac6:	cda080e7          	jalr	-806(ra) # 8000479c <filealloc>
    80005aca:	892a                	mv	s2,a0
    80005acc:	10050c63          	beqz	a0,80005be4 <sys_open+0x194>
    80005ad0:	00000097          	auipc	ra,0x0
    80005ad4:	902080e7          	jalr	-1790(ra) # 800053d2 <fdalloc>
    80005ad8:	89aa                	mv	s3,a0
    80005ada:	10054063          	bltz	a0,80005bda <sys_open+0x18a>
    end_op();
    return -1;
  }


  if(ip->type == T_DEVICE){
    80005ade:	04449703          	lh	a4,68(s1)
    80005ae2:	478d                	li	a5,3
    80005ae4:	08f70463          	beq	a4,a5,80005b6c <sys_open+0x11c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    
    f->type = FD_INODE;
    80005ae8:	4789                	li	a5,2
    80005aea:	00f92023          	sw	a5,0(s2)

    if (omode & O_APPEND)
    80005aee:	f4c42783          	lw	a5,-180(s0)
    80005af2:	83bd                	srli	a5,a5,0xf
    80005af4:	8b85                	andi	a5,a5,1
    80005af6:	cbe9                	beqz	a5,80005bc8 <sys_open+0x178>
      f->off = ip->size;
    80005af8:	44fc                	lw	a5,76(s1)
    80005afa:	02f92023          	sw	a5,32(s2)
    80005afe:	a8ad                	j	80005b78 <sys_open+0x128>
      end_op();
    80005b00:	fffff097          	auipc	ra,0xfffff
    80005b04:	90e080e7          	jalr	-1778(ra) # 8000440e <end_op>
      return -1;
    80005b08:	557d                	li	a0,-1
    80005b0a:	a845                	j	80005bba <sys_open+0x16a>
    if((ip = namei(path)) == 0){
    80005b0c:	f5040513          	addi	a0,s0,-176
    80005b10:	ffffe097          	auipc	ra,0xffffe
    80005b14:	660080e7          	jalr	1632(ra) # 80004170 <namei>
    80005b18:	84aa                	mv	s1,a0
    80005b1a:	c905                	beqz	a0,80005b4a <sys_open+0xfa>
    ilock(ip);
    80005b1c:	ffffe097          	auipc	ra,0xffffe
    80005b20:	ea8080e7          	jalr	-344(ra) # 800039c4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005b24:	04449703          	lh	a4,68(s1)
    80005b28:	4785                	li	a5,1
    80005b2a:	f8f712e3          	bne	a4,a5,80005aae <sys_open+0x5e>
    80005b2e:	f4c42783          	lw	a5,-180(s0)
    80005b32:	dbc1                	beqz	a5,80005ac2 <sys_open+0x72>
      iunlockput(ip);
    80005b34:	8526                	mv	a0,s1
    80005b36:	ffffe097          	auipc	ra,0xffffe
    80005b3a:	0f0080e7          	jalr	240(ra) # 80003c26 <iunlockput>
      end_op();
    80005b3e:	fffff097          	auipc	ra,0xfffff
    80005b42:	8d0080e7          	jalr	-1840(ra) # 8000440e <end_op>
      return -1;
    80005b46:	557d                	li	a0,-1
    80005b48:	a88d                	j	80005bba <sys_open+0x16a>
      end_op();
    80005b4a:	fffff097          	auipc	ra,0xfffff
    80005b4e:	8c4080e7          	jalr	-1852(ra) # 8000440e <end_op>
      return -1;
    80005b52:	557d                	li	a0,-1
    80005b54:	a09d                	j	80005bba <sys_open+0x16a>
    iunlockput(ip);
    80005b56:	8526                	mv	a0,s1
    80005b58:	ffffe097          	auipc	ra,0xffffe
    80005b5c:	0ce080e7          	jalr	206(ra) # 80003c26 <iunlockput>
    end_op();
    80005b60:	fffff097          	auipc	ra,0xfffff
    80005b64:	8ae080e7          	jalr	-1874(ra) # 8000440e <end_op>
    return -1;
    80005b68:	557d                	li	a0,-1
    80005b6a:	a881                	j	80005bba <sys_open+0x16a>
    f->type = FD_DEVICE;
    80005b6c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005b70:	04649783          	lh	a5,70(s1)
    80005b74:	02f91223          	sh	a5,36(s2)
    else
      f->off = 0;
  }
  f->ip = ip;
    80005b78:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005b7c:	f4c42783          	lw	a5,-180(s0)
    80005b80:	0017c713          	xori	a4,a5,1
    80005b84:	8b05                	andi	a4,a4,1
    80005b86:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005b8a:	0037f713          	andi	a4,a5,3
    80005b8e:	00e03733          	snez	a4,a4
    80005b92:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005b96:	4007f793          	andi	a5,a5,1024
    80005b9a:	c791                	beqz	a5,80005ba6 <sys_open+0x156>
    80005b9c:	04449703          	lh	a4,68(s1)
    80005ba0:	4789                	li	a5,2
    80005ba2:	02f70663          	beq	a4,a5,80005bce <sys_open+0x17e>
    itrunc(ip);
  }

  iunlock(ip);
    80005ba6:	8526                	mv	a0,s1
    80005ba8:	ffffe097          	auipc	ra,0xffffe
    80005bac:	ede080e7          	jalr	-290(ra) # 80003a86 <iunlock>
  end_op();
    80005bb0:	fffff097          	auipc	ra,0xfffff
    80005bb4:	85e080e7          	jalr	-1954(ra) # 8000440e <end_op>

  return fd;
    80005bb8:	854e                	mv	a0,s3
}
    80005bba:	70ea                	ld	ra,184(sp)
    80005bbc:	744a                	ld	s0,176(sp)
    80005bbe:	74aa                	ld	s1,168(sp)
    80005bc0:	790a                	ld	s2,160(sp)
    80005bc2:	69ea                	ld	s3,152(sp)
    80005bc4:	6129                	addi	sp,sp,192
    80005bc6:	8082                	ret
      f->off = 0;
    80005bc8:	02092023          	sw	zero,32(s2)
    80005bcc:	b775                	j	80005b78 <sys_open+0x128>
    itrunc(ip);
    80005bce:	8526                	mv	a0,s1
    80005bd0:	ffffe097          	auipc	ra,0xffffe
    80005bd4:	f02080e7          	jalr	-254(ra) # 80003ad2 <itrunc>
    80005bd8:	b7f9                	j	80005ba6 <sys_open+0x156>
      fileclose(f);
    80005bda:	854a                	mv	a0,s2
    80005bdc:	fffff097          	auipc	ra,0xfffff
    80005be0:	c7c080e7          	jalr	-900(ra) # 80004858 <fileclose>
    iunlockput(ip);
    80005be4:	8526                	mv	a0,s1
    80005be6:	ffffe097          	auipc	ra,0xffffe
    80005bea:	040080e7          	jalr	64(ra) # 80003c26 <iunlockput>
    end_op();
    80005bee:	fffff097          	auipc	ra,0xfffff
    80005bf2:	820080e7          	jalr	-2016(ra) # 8000440e <end_op>
    return -1;
    80005bf6:	557d                	li	a0,-1
    80005bf8:	b7c9                	j	80005bba <sys_open+0x16a>

0000000080005bfa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005bfa:	7175                	addi	sp,sp,-144
    80005bfc:	e506                	sd	ra,136(sp)
    80005bfe:	e122                	sd	s0,128(sp)
    80005c00:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005c02:	ffffe097          	auipc	ra,0xffffe
    80005c06:	78e080e7          	jalr	1934(ra) # 80004390 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005c0a:	08000613          	li	a2,128
    80005c0e:	f7040593          	addi	a1,s0,-144
    80005c12:	4501                	li	a0,0
    80005c14:	ffffd097          	auipc	ra,0xffffd
    80005c18:	f12080e7          	jalr	-238(ra) # 80002b26 <argstr>
    80005c1c:	02054963          	bltz	a0,80005c4e <sys_mkdir+0x54>
    80005c20:	4681                	li	a3,0
    80005c22:	4601                	li	a2,0
    80005c24:	4585                	li	a1,1
    80005c26:	f7040513          	addi	a0,s0,-144
    80005c2a:	fffff097          	auipc	ra,0xfffff
    80005c2e:	7ea080e7          	jalr	2026(ra) # 80005414 <create>
    80005c32:	cd11                	beqz	a0,80005c4e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c34:	ffffe097          	auipc	ra,0xffffe
    80005c38:	ff2080e7          	jalr	-14(ra) # 80003c26 <iunlockput>
  end_op();
    80005c3c:	ffffe097          	auipc	ra,0xffffe
    80005c40:	7d2080e7          	jalr	2002(ra) # 8000440e <end_op>
  return 0;
    80005c44:	4501                	li	a0,0
}
    80005c46:	60aa                	ld	ra,136(sp)
    80005c48:	640a                	ld	s0,128(sp)
    80005c4a:	6149                	addi	sp,sp,144
    80005c4c:	8082                	ret
    end_op();
    80005c4e:	ffffe097          	auipc	ra,0xffffe
    80005c52:	7c0080e7          	jalr	1984(ra) # 8000440e <end_op>
    return -1;
    80005c56:	557d                	li	a0,-1
    80005c58:	b7fd                	j	80005c46 <sys_mkdir+0x4c>

0000000080005c5a <sys_mknod>:

uint64
sys_mknod(void)
{
    80005c5a:	7135                	addi	sp,sp,-160
    80005c5c:	ed06                	sd	ra,152(sp)
    80005c5e:	e922                	sd	s0,144(sp)
    80005c60:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005c62:	ffffe097          	auipc	ra,0xffffe
    80005c66:	72e080e7          	jalr	1838(ra) # 80004390 <begin_op>
  argint(1, &major);
    80005c6a:	f6c40593          	addi	a1,s0,-148
    80005c6e:	4505                	li	a0,1
    80005c70:	ffffd097          	auipc	ra,0xffffd
    80005c74:	e76080e7          	jalr	-394(ra) # 80002ae6 <argint>
  argint(2, &minor);
    80005c78:	f6840593          	addi	a1,s0,-152
    80005c7c:	4509                	li	a0,2
    80005c7e:	ffffd097          	auipc	ra,0xffffd
    80005c82:	e68080e7          	jalr	-408(ra) # 80002ae6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c86:	08000613          	li	a2,128
    80005c8a:	f7040593          	addi	a1,s0,-144
    80005c8e:	4501                	li	a0,0
    80005c90:	ffffd097          	auipc	ra,0xffffd
    80005c94:	e96080e7          	jalr	-362(ra) # 80002b26 <argstr>
    80005c98:	02054b63          	bltz	a0,80005cce <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005c9c:	f6841683          	lh	a3,-152(s0)
    80005ca0:	f6c41603          	lh	a2,-148(s0)
    80005ca4:	458d                	li	a1,3
    80005ca6:	f7040513          	addi	a0,s0,-144
    80005caa:	fffff097          	auipc	ra,0xfffff
    80005cae:	76a080e7          	jalr	1898(ra) # 80005414 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005cb2:	cd11                	beqz	a0,80005cce <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005cb4:	ffffe097          	auipc	ra,0xffffe
    80005cb8:	f72080e7          	jalr	-142(ra) # 80003c26 <iunlockput>
  end_op();
    80005cbc:	ffffe097          	auipc	ra,0xffffe
    80005cc0:	752080e7          	jalr	1874(ra) # 8000440e <end_op>
  return 0;
    80005cc4:	4501                	li	a0,0
}
    80005cc6:	60ea                	ld	ra,152(sp)
    80005cc8:	644a                	ld	s0,144(sp)
    80005cca:	610d                	addi	sp,sp,160
    80005ccc:	8082                	ret
    end_op();
    80005cce:	ffffe097          	auipc	ra,0xffffe
    80005cd2:	740080e7          	jalr	1856(ra) # 8000440e <end_op>
    return -1;
    80005cd6:	557d                	li	a0,-1
    80005cd8:	b7fd                	j	80005cc6 <sys_mknod+0x6c>

0000000080005cda <sys_chdir>:

uint64
sys_chdir(void)
{
    80005cda:	7135                	addi	sp,sp,-160
    80005cdc:	ed06                	sd	ra,152(sp)
    80005cde:	e922                	sd	s0,144(sp)
    80005ce0:	e526                	sd	s1,136(sp)
    80005ce2:	e14a                	sd	s2,128(sp)
    80005ce4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005ce6:	ffffc097          	auipc	ra,0xffffc
    80005cea:	cc6080e7          	jalr	-826(ra) # 800019ac <myproc>
    80005cee:	892a                	mv	s2,a0
  
  begin_op();
    80005cf0:	ffffe097          	auipc	ra,0xffffe
    80005cf4:	6a0080e7          	jalr	1696(ra) # 80004390 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005cf8:	08000613          	li	a2,128
    80005cfc:	f6040593          	addi	a1,s0,-160
    80005d00:	4501                	li	a0,0
    80005d02:	ffffd097          	auipc	ra,0xffffd
    80005d06:	e24080e7          	jalr	-476(ra) # 80002b26 <argstr>
    80005d0a:	04054b63          	bltz	a0,80005d60 <sys_chdir+0x86>
    80005d0e:	f6040513          	addi	a0,s0,-160
    80005d12:	ffffe097          	auipc	ra,0xffffe
    80005d16:	45e080e7          	jalr	1118(ra) # 80004170 <namei>
    80005d1a:	84aa                	mv	s1,a0
    80005d1c:	c131                	beqz	a0,80005d60 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005d1e:	ffffe097          	auipc	ra,0xffffe
    80005d22:	ca6080e7          	jalr	-858(ra) # 800039c4 <ilock>
  if(ip->type != T_DIR){
    80005d26:	04449703          	lh	a4,68(s1)
    80005d2a:	4785                	li	a5,1
    80005d2c:	04f71063          	bne	a4,a5,80005d6c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005d30:	8526                	mv	a0,s1
    80005d32:	ffffe097          	auipc	ra,0xffffe
    80005d36:	d54080e7          	jalr	-684(ra) # 80003a86 <iunlock>
  iput(p->cwd);
    80005d3a:	15093503          	ld	a0,336(s2)
    80005d3e:	ffffe097          	auipc	ra,0xffffe
    80005d42:	e40080e7          	jalr	-448(ra) # 80003b7e <iput>
  end_op();
    80005d46:	ffffe097          	auipc	ra,0xffffe
    80005d4a:	6c8080e7          	jalr	1736(ra) # 8000440e <end_op>
  p->cwd = ip;
    80005d4e:	14993823          	sd	s1,336(s2)
  return 0;
    80005d52:	4501                	li	a0,0
}
    80005d54:	60ea                	ld	ra,152(sp)
    80005d56:	644a                	ld	s0,144(sp)
    80005d58:	64aa                	ld	s1,136(sp)
    80005d5a:	690a                	ld	s2,128(sp)
    80005d5c:	610d                	addi	sp,sp,160
    80005d5e:	8082                	ret
    end_op();
    80005d60:	ffffe097          	auipc	ra,0xffffe
    80005d64:	6ae080e7          	jalr	1710(ra) # 8000440e <end_op>
    return -1;
    80005d68:	557d                	li	a0,-1
    80005d6a:	b7ed                	j	80005d54 <sys_chdir+0x7a>
    iunlockput(ip);
    80005d6c:	8526                	mv	a0,s1
    80005d6e:	ffffe097          	auipc	ra,0xffffe
    80005d72:	eb8080e7          	jalr	-328(ra) # 80003c26 <iunlockput>
    end_op();
    80005d76:	ffffe097          	auipc	ra,0xffffe
    80005d7a:	698080e7          	jalr	1688(ra) # 8000440e <end_op>
    return -1;
    80005d7e:	557d                	li	a0,-1
    80005d80:	bfd1                	j	80005d54 <sys_chdir+0x7a>

0000000080005d82 <sys_exec>:

uint64
sys_exec(void)
{
    80005d82:	7145                	addi	sp,sp,-464
    80005d84:	e786                	sd	ra,456(sp)
    80005d86:	e3a2                	sd	s0,448(sp)
    80005d88:	ff26                	sd	s1,440(sp)
    80005d8a:	fb4a                	sd	s2,432(sp)
    80005d8c:	f74e                	sd	s3,424(sp)
    80005d8e:	f352                	sd	s4,416(sp)
    80005d90:	ef56                	sd	s5,408(sp)
    80005d92:	0b80                	addi	s0,sp,464

  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005d94:	e3840593          	addi	a1,s0,-456
    80005d98:	4505                	li	a0,1
    80005d9a:	ffffd097          	auipc	ra,0xffffd
    80005d9e:	d6c080e7          	jalr	-660(ra) # 80002b06 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005da2:	08000613          	li	a2,128
    80005da6:	f4040593          	addi	a1,s0,-192
    80005daa:	4501                	li	a0,0
    80005dac:	ffffd097          	auipc	ra,0xffffd
    80005db0:	d7a080e7          	jalr	-646(ra) # 80002b26 <argstr>
    80005db4:	87aa                	mv	a5,a0
    return -1;
    80005db6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005db8:	0c07c363          	bltz	a5,80005e7e <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80005dbc:	10000613          	li	a2,256
    80005dc0:	4581                	li	a1,0
    80005dc2:	e4040513          	addi	a0,s0,-448
    80005dc6:	ffffb097          	auipc	ra,0xffffb
    80005dca:	f0c080e7          	jalr	-244(ra) # 80000cd2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005dce:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005dd2:	89a6                	mv	s3,s1
    80005dd4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005dd6:	02000a13          	li	s4,32
    80005dda:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005dde:	00391513          	slli	a0,s2,0x3
    80005de2:	e3040593          	addi	a1,s0,-464
    80005de6:	e3843783          	ld	a5,-456(s0)
    80005dea:	953e                	add	a0,a0,a5
    80005dec:	ffffd097          	auipc	ra,0xffffd
    80005df0:	c5c080e7          	jalr	-932(ra) # 80002a48 <fetchaddr>
    80005df4:	02054a63          	bltz	a0,80005e28 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005df8:	e3043783          	ld	a5,-464(s0)
    80005dfc:	c3b9                	beqz	a5,80005e42 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005dfe:	ffffb097          	auipc	ra,0xffffb
    80005e02:	ce8080e7          	jalr	-792(ra) # 80000ae6 <kalloc>
    80005e06:	85aa                	mv	a1,a0
    80005e08:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005e0c:	cd11                	beqz	a0,80005e28 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005e0e:	6605                	lui	a2,0x1
    80005e10:	e3043503          	ld	a0,-464(s0)
    80005e14:	ffffd097          	auipc	ra,0xffffd
    80005e18:	c86080e7          	jalr	-890(ra) # 80002a9a <fetchstr>
    80005e1c:	00054663          	bltz	a0,80005e28 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005e20:	0905                	addi	s2,s2,1
    80005e22:	09a1                	addi	s3,s3,8
    80005e24:	fb491be3          	bne	s2,s4,80005dda <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e28:	f4040913          	addi	s2,s0,-192
    80005e2c:	6088                	ld	a0,0(s1)
    80005e2e:	c539                	beqz	a0,80005e7c <sys_exec+0xfa>
    kfree(argv[i]);
    80005e30:	ffffb097          	auipc	ra,0xffffb
    80005e34:	bb8080e7          	jalr	-1096(ra) # 800009e8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e38:	04a1                	addi	s1,s1,8
    80005e3a:	ff2499e3          	bne	s1,s2,80005e2c <sys_exec+0xaa>
  return -1;
    80005e3e:	557d                	li	a0,-1
    80005e40:	a83d                	j	80005e7e <sys_exec+0xfc>
      argv[i] = 0;
    80005e42:	0a8e                	slli	s5,s5,0x3
    80005e44:	fc0a8793          	addi	a5,s5,-64
    80005e48:	00878ab3          	add	s5,a5,s0
    80005e4c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005e50:	e4040593          	addi	a1,s0,-448
    80005e54:	f4040513          	addi	a0,s0,-192
    80005e58:	fffff097          	auipc	ra,0xfffff
    80005e5c:	15c080e7          	jalr	348(ra) # 80004fb4 <exec>
    80005e60:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e62:	f4040993          	addi	s3,s0,-192
    80005e66:	6088                	ld	a0,0(s1)
    80005e68:	c901                	beqz	a0,80005e78 <sys_exec+0xf6>
    kfree(argv[i]);
    80005e6a:	ffffb097          	auipc	ra,0xffffb
    80005e6e:	b7e080e7          	jalr	-1154(ra) # 800009e8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e72:	04a1                	addi	s1,s1,8
    80005e74:	ff3499e3          	bne	s1,s3,80005e66 <sys_exec+0xe4>
  return ret;
    80005e78:	854a                	mv	a0,s2
    80005e7a:	a011                	j	80005e7e <sys_exec+0xfc>
  return -1;
    80005e7c:	557d                	li	a0,-1
}
    80005e7e:	60be                	ld	ra,456(sp)
    80005e80:	641e                	ld	s0,448(sp)
    80005e82:	74fa                	ld	s1,440(sp)
    80005e84:	795a                	ld	s2,432(sp)
    80005e86:	79ba                	ld	s3,424(sp)
    80005e88:	7a1a                	ld	s4,416(sp)
    80005e8a:	6afa                	ld	s5,408(sp)
    80005e8c:	6179                	addi	sp,sp,464
    80005e8e:	8082                	ret

0000000080005e90 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005e90:	7139                	addi	sp,sp,-64
    80005e92:	fc06                	sd	ra,56(sp)
    80005e94:	f822                	sd	s0,48(sp)
    80005e96:	f426                	sd	s1,40(sp)
    80005e98:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005e9a:	ffffc097          	auipc	ra,0xffffc
    80005e9e:	b12080e7          	jalr	-1262(ra) # 800019ac <myproc>
    80005ea2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005ea4:	fd840593          	addi	a1,s0,-40
    80005ea8:	4501                	li	a0,0
    80005eaa:	ffffd097          	auipc	ra,0xffffd
    80005eae:	c5c080e7          	jalr	-932(ra) # 80002b06 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005eb2:	fc840593          	addi	a1,s0,-56
    80005eb6:	fd040513          	addi	a0,s0,-48
    80005eba:	fffff097          	auipc	ra,0xfffff
    80005ebe:	cce080e7          	jalr	-818(ra) # 80004b88 <pipealloc>
    return -1;
    80005ec2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005ec4:	0c054463          	bltz	a0,80005f8c <sys_pipe+0xfc>
  fd0 = -1;
    80005ec8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005ecc:	fd043503          	ld	a0,-48(s0)
    80005ed0:	fffff097          	auipc	ra,0xfffff
    80005ed4:	502080e7          	jalr	1282(ra) # 800053d2 <fdalloc>
    80005ed8:	fca42223          	sw	a0,-60(s0)
    80005edc:	08054b63          	bltz	a0,80005f72 <sys_pipe+0xe2>
    80005ee0:	fc843503          	ld	a0,-56(s0)
    80005ee4:	fffff097          	auipc	ra,0xfffff
    80005ee8:	4ee080e7          	jalr	1262(ra) # 800053d2 <fdalloc>
    80005eec:	fca42023          	sw	a0,-64(s0)
    80005ef0:	06054863          	bltz	a0,80005f60 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ef4:	4691                	li	a3,4
    80005ef6:	fc440613          	addi	a2,s0,-60
    80005efa:	fd843583          	ld	a1,-40(s0)
    80005efe:	68a8                	ld	a0,80(s1)
    80005f00:	ffffb097          	auipc	ra,0xffffb
    80005f04:	76c080e7          	jalr	1900(ra) # 8000166c <copyout>
    80005f08:	02054063          	bltz	a0,80005f28 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005f0c:	4691                	li	a3,4
    80005f0e:	fc040613          	addi	a2,s0,-64
    80005f12:	fd843583          	ld	a1,-40(s0)
    80005f16:	0591                	addi	a1,a1,4
    80005f18:	68a8                	ld	a0,80(s1)
    80005f1a:	ffffb097          	auipc	ra,0xffffb
    80005f1e:	752080e7          	jalr	1874(ra) # 8000166c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005f22:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005f24:	06055463          	bgez	a0,80005f8c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005f28:	fc442783          	lw	a5,-60(s0)
    80005f2c:	07e9                	addi	a5,a5,26
    80005f2e:	078e                	slli	a5,a5,0x3
    80005f30:	97a6                	add	a5,a5,s1
    80005f32:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005f36:	fc042783          	lw	a5,-64(s0)
    80005f3a:	07e9                	addi	a5,a5,26
    80005f3c:	078e                	slli	a5,a5,0x3
    80005f3e:	94be                	add	s1,s1,a5
    80005f40:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005f44:	fd043503          	ld	a0,-48(s0)
    80005f48:	fffff097          	auipc	ra,0xfffff
    80005f4c:	910080e7          	jalr	-1776(ra) # 80004858 <fileclose>
    fileclose(wf);
    80005f50:	fc843503          	ld	a0,-56(s0)
    80005f54:	fffff097          	auipc	ra,0xfffff
    80005f58:	904080e7          	jalr	-1788(ra) # 80004858 <fileclose>
    return -1;
    80005f5c:	57fd                	li	a5,-1
    80005f5e:	a03d                	j	80005f8c <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005f60:	fc442783          	lw	a5,-60(s0)
    80005f64:	0007c763          	bltz	a5,80005f72 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005f68:	07e9                	addi	a5,a5,26
    80005f6a:	078e                	slli	a5,a5,0x3
    80005f6c:	97a6                	add	a5,a5,s1
    80005f6e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005f72:	fd043503          	ld	a0,-48(s0)
    80005f76:	fffff097          	auipc	ra,0xfffff
    80005f7a:	8e2080e7          	jalr	-1822(ra) # 80004858 <fileclose>
    fileclose(wf);
    80005f7e:	fc843503          	ld	a0,-56(s0)
    80005f82:	fffff097          	auipc	ra,0xfffff
    80005f86:	8d6080e7          	jalr	-1834(ra) # 80004858 <fileclose>
    return -1;
    80005f8a:	57fd                	li	a5,-1
}
    80005f8c:	853e                	mv	a0,a5
    80005f8e:	70e2                	ld	ra,56(sp)
    80005f90:	7442                	ld	s0,48(sp)
    80005f92:	74a2                	ld	s1,40(sp)
    80005f94:	6121                	addi	sp,sp,64
    80005f96:	8082                	ret
	...

0000000080005fa0 <kernelvec>:
    80005fa0:	7111                	addi	sp,sp,-256
    80005fa2:	e006                	sd	ra,0(sp)
    80005fa4:	e40a                	sd	sp,8(sp)
    80005fa6:	e80e                	sd	gp,16(sp)
    80005fa8:	ec12                	sd	tp,24(sp)
    80005faa:	f016                	sd	t0,32(sp)
    80005fac:	f41a                	sd	t1,40(sp)
    80005fae:	f81e                	sd	t2,48(sp)
    80005fb0:	fc22                	sd	s0,56(sp)
    80005fb2:	e0a6                	sd	s1,64(sp)
    80005fb4:	e4aa                	sd	a0,72(sp)
    80005fb6:	e8ae                	sd	a1,80(sp)
    80005fb8:	ecb2                	sd	a2,88(sp)
    80005fba:	f0b6                	sd	a3,96(sp)
    80005fbc:	f4ba                	sd	a4,104(sp)
    80005fbe:	f8be                	sd	a5,112(sp)
    80005fc0:	fcc2                	sd	a6,120(sp)
    80005fc2:	e146                	sd	a7,128(sp)
    80005fc4:	e54a                	sd	s2,136(sp)
    80005fc6:	e94e                	sd	s3,144(sp)
    80005fc8:	ed52                	sd	s4,152(sp)
    80005fca:	f156                	sd	s5,160(sp)
    80005fcc:	f55a                	sd	s6,168(sp)
    80005fce:	f95e                	sd	s7,176(sp)
    80005fd0:	fd62                	sd	s8,184(sp)
    80005fd2:	e1e6                	sd	s9,192(sp)
    80005fd4:	e5ea                	sd	s10,200(sp)
    80005fd6:	e9ee                	sd	s11,208(sp)
    80005fd8:	edf2                	sd	t3,216(sp)
    80005fda:	f1f6                	sd	t4,224(sp)
    80005fdc:	f5fa                	sd	t5,232(sp)
    80005fde:	f9fe                	sd	t6,240(sp)
    80005fe0:	935fc0ef          	jal	ra,80002914 <kerneltrap>
    80005fe4:	6082                	ld	ra,0(sp)
    80005fe6:	6122                	ld	sp,8(sp)
    80005fe8:	61c2                	ld	gp,16(sp)
    80005fea:	7282                	ld	t0,32(sp)
    80005fec:	7322                	ld	t1,40(sp)
    80005fee:	73c2                	ld	t2,48(sp)
    80005ff0:	7462                	ld	s0,56(sp)
    80005ff2:	6486                	ld	s1,64(sp)
    80005ff4:	6526                	ld	a0,72(sp)
    80005ff6:	65c6                	ld	a1,80(sp)
    80005ff8:	6666                	ld	a2,88(sp)
    80005ffa:	7686                	ld	a3,96(sp)
    80005ffc:	7726                	ld	a4,104(sp)
    80005ffe:	77c6                	ld	a5,112(sp)
    80006000:	7866                	ld	a6,120(sp)
    80006002:	688a                	ld	a7,128(sp)
    80006004:	692a                	ld	s2,136(sp)
    80006006:	69ca                	ld	s3,144(sp)
    80006008:	6a6a                	ld	s4,152(sp)
    8000600a:	7a8a                	ld	s5,160(sp)
    8000600c:	7b2a                	ld	s6,168(sp)
    8000600e:	7bca                	ld	s7,176(sp)
    80006010:	7c6a                	ld	s8,184(sp)
    80006012:	6c8e                	ld	s9,192(sp)
    80006014:	6d2e                	ld	s10,200(sp)
    80006016:	6dce                	ld	s11,208(sp)
    80006018:	6e6e                	ld	t3,216(sp)
    8000601a:	7e8e                	ld	t4,224(sp)
    8000601c:	7f2e                	ld	t5,232(sp)
    8000601e:	7fce                	ld	t6,240(sp)
    80006020:	6111                	addi	sp,sp,256
    80006022:	10200073          	sret
    80006026:	00000013          	nop
    8000602a:	00000013          	nop
    8000602e:	0001                	nop

0000000080006030 <timervec>:
    80006030:	34051573          	csrrw	a0,mscratch,a0
    80006034:	e10c                	sd	a1,0(a0)
    80006036:	e510                	sd	a2,8(a0)
    80006038:	e914                	sd	a3,16(a0)
    8000603a:	6d0c                	ld	a1,24(a0)
    8000603c:	7110                	ld	a2,32(a0)
    8000603e:	6194                	ld	a3,0(a1)
    80006040:	96b2                	add	a3,a3,a2
    80006042:	e194                	sd	a3,0(a1)
    80006044:	4589                	li	a1,2
    80006046:	14459073          	csrw	sip,a1
    8000604a:	6914                	ld	a3,16(a0)
    8000604c:	6510                	ld	a2,8(a0)
    8000604e:	610c                	ld	a1,0(a0)
    80006050:	34051573          	csrrw	a0,mscratch,a0
    80006054:	30200073          	mret
	...

000000008000605a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000605a:	1141                	addi	sp,sp,-16
    8000605c:	e422                	sd	s0,8(sp)
    8000605e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006060:	0c0007b7          	lui	a5,0xc000
    80006064:	4705                	li	a4,1
    80006066:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006068:	c3d8                	sw	a4,4(a5)
}
    8000606a:	6422                	ld	s0,8(sp)
    8000606c:	0141                	addi	sp,sp,16
    8000606e:	8082                	ret

0000000080006070 <plicinithart>:

void
plicinithart(void)
{
    80006070:	1141                	addi	sp,sp,-16
    80006072:	e406                	sd	ra,8(sp)
    80006074:	e022                	sd	s0,0(sp)
    80006076:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006078:	ffffc097          	auipc	ra,0xffffc
    8000607c:	908080e7          	jalr	-1784(ra) # 80001980 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006080:	0085171b          	slliw	a4,a0,0x8
    80006084:	0c0027b7          	lui	a5,0xc002
    80006088:	97ba                	add	a5,a5,a4
    8000608a:	40200713          	li	a4,1026
    8000608e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006092:	00d5151b          	slliw	a0,a0,0xd
    80006096:	0c2017b7          	lui	a5,0xc201
    8000609a:	97aa                	add	a5,a5,a0
    8000609c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800060a0:	60a2                	ld	ra,8(sp)
    800060a2:	6402                	ld	s0,0(sp)
    800060a4:	0141                	addi	sp,sp,16
    800060a6:	8082                	ret

00000000800060a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800060a8:	1141                	addi	sp,sp,-16
    800060aa:	e406                	sd	ra,8(sp)
    800060ac:	e022                	sd	s0,0(sp)
    800060ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800060b0:	ffffc097          	auipc	ra,0xffffc
    800060b4:	8d0080e7          	jalr	-1840(ra) # 80001980 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800060b8:	00d5151b          	slliw	a0,a0,0xd
    800060bc:	0c2017b7          	lui	a5,0xc201
    800060c0:	97aa                	add	a5,a5,a0
  return irq;
}
    800060c2:	43c8                	lw	a0,4(a5)
    800060c4:	60a2                	ld	ra,8(sp)
    800060c6:	6402                	ld	s0,0(sp)
    800060c8:	0141                	addi	sp,sp,16
    800060ca:	8082                	ret

00000000800060cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800060cc:	1101                	addi	sp,sp,-32
    800060ce:	ec06                	sd	ra,24(sp)
    800060d0:	e822                	sd	s0,16(sp)
    800060d2:	e426                	sd	s1,8(sp)
    800060d4:	1000                	addi	s0,sp,32
    800060d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800060d8:	ffffc097          	auipc	ra,0xffffc
    800060dc:	8a8080e7          	jalr	-1880(ra) # 80001980 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800060e0:	00d5151b          	slliw	a0,a0,0xd
    800060e4:	0c2017b7          	lui	a5,0xc201
    800060e8:	97aa                	add	a5,a5,a0
    800060ea:	c3c4                	sw	s1,4(a5)
}
    800060ec:	60e2                	ld	ra,24(sp)
    800060ee:	6442                	ld	s0,16(sp)
    800060f0:	64a2                	ld	s1,8(sp)
    800060f2:	6105                	addi	sp,sp,32
    800060f4:	8082                	ret

00000000800060f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800060f6:	1141                	addi	sp,sp,-16
    800060f8:	e406                	sd	ra,8(sp)
    800060fa:	e022                	sd	s0,0(sp)
    800060fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800060fe:	479d                	li	a5,7
    80006100:	04a7cc63          	blt	a5,a0,80006158 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006104:	0001d797          	auipc	a5,0x1d
    80006108:	3fc78793          	addi	a5,a5,1020 # 80023500 <disk>
    8000610c:	97aa                	add	a5,a5,a0
    8000610e:	0187c783          	lbu	a5,24(a5)
    80006112:	ebb9                	bnez	a5,80006168 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006114:	00451693          	slli	a3,a0,0x4
    80006118:	0001d797          	auipc	a5,0x1d
    8000611c:	3e878793          	addi	a5,a5,1000 # 80023500 <disk>
    80006120:	6398                	ld	a4,0(a5)
    80006122:	9736                	add	a4,a4,a3
    80006124:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80006128:	6398                	ld	a4,0(a5)
    8000612a:	9736                	add	a4,a4,a3
    8000612c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006130:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006134:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006138:	97aa                	add	a5,a5,a0
    8000613a:	4705                	li	a4,1
    8000613c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006140:	0001d517          	auipc	a0,0x1d
    80006144:	3d850513          	addi	a0,a0,984 # 80023518 <disk+0x18>
    80006148:	ffffc097          	auipc	ra,0xffffc
    8000614c:	f7c080e7          	jalr	-132(ra) # 800020c4 <wakeup>
}
    80006150:	60a2                	ld	ra,8(sp)
    80006152:	6402                	ld	s0,0(sp)
    80006154:	0141                	addi	sp,sp,16
    80006156:	8082                	ret
    panic("free_desc 1");
    80006158:	00003517          	auipc	a0,0x3
    8000615c:	6e050513          	addi	a0,a0,1760 # 80009838 <syscalls+0x3e8>
    80006160:	ffffa097          	auipc	ra,0xffffa
    80006164:	3e0080e7          	jalr	992(ra) # 80000540 <panic>
    panic("free_desc 2");
    80006168:	00003517          	auipc	a0,0x3
    8000616c:	6e050513          	addi	a0,a0,1760 # 80009848 <syscalls+0x3f8>
    80006170:	ffffa097          	auipc	ra,0xffffa
    80006174:	3d0080e7          	jalr	976(ra) # 80000540 <panic>

0000000080006178 <virtio_disk_init>:
{
    80006178:	1101                	addi	sp,sp,-32
    8000617a:	ec06                	sd	ra,24(sp)
    8000617c:	e822                	sd	s0,16(sp)
    8000617e:	e426                	sd	s1,8(sp)
    80006180:	e04a                	sd	s2,0(sp)
    80006182:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006184:	00003597          	auipc	a1,0x3
    80006188:	6d458593          	addi	a1,a1,1748 # 80009858 <syscalls+0x408>
    8000618c:	0001d517          	auipc	a0,0x1d
    80006190:	49c50513          	addi	a0,a0,1180 # 80023628 <disk+0x128>
    80006194:	ffffb097          	auipc	ra,0xffffb
    80006198:	9b2080e7          	jalr	-1614(ra) # 80000b46 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000619c:	100017b7          	lui	a5,0x10001
    800061a0:	4398                	lw	a4,0(a5)
    800061a2:	2701                	sext.w	a4,a4
    800061a4:	747277b7          	lui	a5,0x74727
    800061a8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800061ac:	14f71b63          	bne	a4,a5,80006302 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800061b0:	100017b7          	lui	a5,0x10001
    800061b4:	43dc                	lw	a5,4(a5)
    800061b6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800061b8:	4709                	li	a4,2
    800061ba:	14e79463          	bne	a5,a4,80006302 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800061be:	100017b7          	lui	a5,0x10001
    800061c2:	479c                	lw	a5,8(a5)
    800061c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800061c6:	12e79e63          	bne	a5,a4,80006302 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800061ca:	100017b7          	lui	a5,0x10001
    800061ce:	47d8                	lw	a4,12(a5)
    800061d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800061d2:	554d47b7          	lui	a5,0x554d4
    800061d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800061da:	12f71463          	bne	a4,a5,80006302 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800061de:	100017b7          	lui	a5,0x10001
    800061e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800061e6:	4705                	li	a4,1
    800061e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061ea:	470d                	li	a4,3
    800061ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800061ee:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800061f0:	c7ffe6b7          	lui	a3,0xc7ffe
    800061f4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb11f>
    800061f8:	8f75                	and	a4,a4,a3
    800061fa:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061fc:	472d                	li	a4,11
    800061fe:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80006200:	5bbc                	lw	a5,112(a5)
    80006202:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006206:	8ba1                	andi	a5,a5,8
    80006208:	10078563          	beqz	a5,80006312 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000620c:	100017b7          	lui	a5,0x10001
    80006210:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006214:	43fc                	lw	a5,68(a5)
    80006216:	2781                	sext.w	a5,a5
    80006218:	10079563          	bnez	a5,80006322 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000621c:	100017b7          	lui	a5,0x10001
    80006220:	5bdc                	lw	a5,52(a5)
    80006222:	2781                	sext.w	a5,a5
  if(max == 0)
    80006224:	10078763          	beqz	a5,80006332 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80006228:	471d                	li	a4,7
    8000622a:	10f77c63          	bgeu	a4,a5,80006342 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000622e:	ffffb097          	auipc	ra,0xffffb
    80006232:	8b8080e7          	jalr	-1864(ra) # 80000ae6 <kalloc>
    80006236:	0001d497          	auipc	s1,0x1d
    8000623a:	2ca48493          	addi	s1,s1,714 # 80023500 <disk>
    8000623e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006240:	ffffb097          	auipc	ra,0xffffb
    80006244:	8a6080e7          	jalr	-1882(ra) # 80000ae6 <kalloc>
    80006248:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000624a:	ffffb097          	auipc	ra,0xffffb
    8000624e:	89c080e7          	jalr	-1892(ra) # 80000ae6 <kalloc>
    80006252:	87aa                	mv	a5,a0
    80006254:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006256:	6088                	ld	a0,0(s1)
    80006258:	cd6d                	beqz	a0,80006352 <virtio_disk_init+0x1da>
    8000625a:	0001d717          	auipc	a4,0x1d
    8000625e:	2ae73703          	ld	a4,686(a4) # 80023508 <disk+0x8>
    80006262:	cb65                	beqz	a4,80006352 <virtio_disk_init+0x1da>
    80006264:	c7fd                	beqz	a5,80006352 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80006266:	6605                	lui	a2,0x1
    80006268:	4581                	li	a1,0
    8000626a:	ffffb097          	auipc	ra,0xffffb
    8000626e:	a68080e7          	jalr	-1432(ra) # 80000cd2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006272:	0001d497          	auipc	s1,0x1d
    80006276:	28e48493          	addi	s1,s1,654 # 80023500 <disk>
    8000627a:	6605                	lui	a2,0x1
    8000627c:	4581                	li	a1,0
    8000627e:	6488                	ld	a0,8(s1)
    80006280:	ffffb097          	auipc	ra,0xffffb
    80006284:	a52080e7          	jalr	-1454(ra) # 80000cd2 <memset>
  memset(disk.used, 0, PGSIZE);
    80006288:	6605                	lui	a2,0x1
    8000628a:	4581                	li	a1,0
    8000628c:	6888                	ld	a0,16(s1)
    8000628e:	ffffb097          	auipc	ra,0xffffb
    80006292:	a44080e7          	jalr	-1468(ra) # 80000cd2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006296:	100017b7          	lui	a5,0x10001
    8000629a:	4721                	li	a4,8
    8000629c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000629e:	4098                	lw	a4,0(s1)
    800062a0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800062a4:	40d8                	lw	a4,4(s1)
    800062a6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800062aa:	6498                	ld	a4,8(s1)
    800062ac:	0007069b          	sext.w	a3,a4
    800062b0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800062b4:	9701                	srai	a4,a4,0x20
    800062b6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800062ba:	6898                	ld	a4,16(s1)
    800062bc:	0007069b          	sext.w	a3,a4
    800062c0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800062c4:	9701                	srai	a4,a4,0x20
    800062c6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800062ca:	4705                	li	a4,1
    800062cc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800062ce:	00e48c23          	sb	a4,24(s1)
    800062d2:	00e48ca3          	sb	a4,25(s1)
    800062d6:	00e48d23          	sb	a4,26(s1)
    800062da:	00e48da3          	sb	a4,27(s1)
    800062de:	00e48e23          	sb	a4,28(s1)
    800062e2:	00e48ea3          	sb	a4,29(s1)
    800062e6:	00e48f23          	sb	a4,30(s1)
    800062ea:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800062ee:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800062f2:	0727a823          	sw	s2,112(a5)
}
    800062f6:	60e2                	ld	ra,24(sp)
    800062f8:	6442                	ld	s0,16(sp)
    800062fa:	64a2                	ld	s1,8(sp)
    800062fc:	6902                	ld	s2,0(sp)
    800062fe:	6105                	addi	sp,sp,32
    80006300:	8082                	ret
    panic("could not find virtio disk");
    80006302:	00003517          	auipc	a0,0x3
    80006306:	56650513          	addi	a0,a0,1382 # 80009868 <syscalls+0x418>
    8000630a:	ffffa097          	auipc	ra,0xffffa
    8000630e:	236080e7          	jalr	566(ra) # 80000540 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006312:	00003517          	auipc	a0,0x3
    80006316:	57650513          	addi	a0,a0,1398 # 80009888 <syscalls+0x438>
    8000631a:	ffffa097          	auipc	ra,0xffffa
    8000631e:	226080e7          	jalr	550(ra) # 80000540 <panic>
    panic("virtio disk should not be ready");
    80006322:	00003517          	auipc	a0,0x3
    80006326:	58650513          	addi	a0,a0,1414 # 800098a8 <syscalls+0x458>
    8000632a:	ffffa097          	auipc	ra,0xffffa
    8000632e:	216080e7          	jalr	534(ra) # 80000540 <panic>
    panic("virtio disk has no queue 0");
    80006332:	00003517          	auipc	a0,0x3
    80006336:	59650513          	addi	a0,a0,1430 # 800098c8 <syscalls+0x478>
    8000633a:	ffffa097          	auipc	ra,0xffffa
    8000633e:	206080e7          	jalr	518(ra) # 80000540 <panic>
    panic("virtio disk max queue too short");
    80006342:	00003517          	auipc	a0,0x3
    80006346:	5a650513          	addi	a0,a0,1446 # 800098e8 <syscalls+0x498>
    8000634a:	ffffa097          	auipc	ra,0xffffa
    8000634e:	1f6080e7          	jalr	502(ra) # 80000540 <panic>
    panic("virtio disk kalloc");
    80006352:	00003517          	auipc	a0,0x3
    80006356:	5b650513          	addi	a0,a0,1462 # 80009908 <syscalls+0x4b8>
    8000635a:	ffffa097          	auipc	ra,0xffffa
    8000635e:	1e6080e7          	jalr	486(ra) # 80000540 <panic>

0000000080006362 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006362:	7119                	addi	sp,sp,-128
    80006364:	fc86                	sd	ra,120(sp)
    80006366:	f8a2                	sd	s0,112(sp)
    80006368:	f4a6                	sd	s1,104(sp)
    8000636a:	f0ca                	sd	s2,96(sp)
    8000636c:	ecce                	sd	s3,88(sp)
    8000636e:	e8d2                	sd	s4,80(sp)
    80006370:	e4d6                	sd	s5,72(sp)
    80006372:	e0da                	sd	s6,64(sp)
    80006374:	fc5e                	sd	s7,56(sp)
    80006376:	f862                	sd	s8,48(sp)
    80006378:	f466                	sd	s9,40(sp)
    8000637a:	f06a                	sd	s10,32(sp)
    8000637c:	ec6e                	sd	s11,24(sp)
    8000637e:	0100                	addi	s0,sp,128
    80006380:	8aaa                	mv	s5,a0
    80006382:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006384:	00c52d03          	lw	s10,12(a0)
    80006388:	001d1d1b          	slliw	s10,s10,0x1
    8000638c:	1d02                	slli	s10,s10,0x20
    8000638e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006392:	0001d517          	auipc	a0,0x1d
    80006396:	29650513          	addi	a0,a0,662 # 80023628 <disk+0x128>
    8000639a:	ffffb097          	auipc	ra,0xffffb
    8000639e:	83c080e7          	jalr	-1988(ra) # 80000bd6 <acquire>
  for(int i = 0; i < 3; i++){
    800063a2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800063a4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800063a6:	0001db97          	auipc	s7,0x1d
    800063aa:	15ab8b93          	addi	s7,s7,346 # 80023500 <disk>
  for(int i = 0; i < 3; i++){
    800063ae:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800063b0:	0001dc97          	auipc	s9,0x1d
    800063b4:	278c8c93          	addi	s9,s9,632 # 80023628 <disk+0x128>
    800063b8:	a08d                	j	8000641a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800063ba:	00fb8733          	add	a4,s7,a5
    800063be:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800063c2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800063c4:	0207c563          	bltz	a5,800063ee <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800063c8:	2905                	addiw	s2,s2,1
    800063ca:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800063cc:	05690c63          	beq	s2,s6,80006424 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800063d0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800063d2:	0001d717          	auipc	a4,0x1d
    800063d6:	12e70713          	addi	a4,a4,302 # 80023500 <disk>
    800063da:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800063dc:	01874683          	lbu	a3,24(a4)
    800063e0:	fee9                	bnez	a3,800063ba <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800063e2:	2785                	addiw	a5,a5,1
    800063e4:	0705                	addi	a4,a4,1
    800063e6:	fe979be3          	bne	a5,s1,800063dc <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800063ea:	57fd                	li	a5,-1
    800063ec:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800063ee:	01205d63          	blez	s2,80006408 <virtio_disk_rw+0xa6>
    800063f2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800063f4:	000a2503          	lw	a0,0(s4)
    800063f8:	00000097          	auipc	ra,0x0
    800063fc:	cfe080e7          	jalr	-770(ra) # 800060f6 <free_desc>
      for(int j = 0; j < i; j++)
    80006400:	2d85                	addiw	s11,s11,1
    80006402:	0a11                	addi	s4,s4,4
    80006404:	ff2d98e3          	bne	s11,s2,800063f4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006408:	85e6                	mv	a1,s9
    8000640a:	0001d517          	auipc	a0,0x1d
    8000640e:	10e50513          	addi	a0,a0,270 # 80023518 <disk+0x18>
    80006412:	ffffc097          	auipc	ra,0xffffc
    80006416:	c4e080e7          	jalr	-946(ra) # 80002060 <sleep>
  for(int i = 0; i < 3; i++){
    8000641a:	f8040a13          	addi	s4,s0,-128
{
    8000641e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006420:	894e                	mv	s2,s3
    80006422:	b77d                	j	800063d0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006424:	f8042503          	lw	a0,-128(s0)
    80006428:	00a50713          	addi	a4,a0,10
    8000642c:	0712                	slli	a4,a4,0x4

  if(write)
    8000642e:	0001d797          	auipc	a5,0x1d
    80006432:	0d278793          	addi	a5,a5,210 # 80023500 <disk>
    80006436:	00e786b3          	add	a3,a5,a4
    8000643a:	01803633          	snez	a2,s8
    8000643e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006440:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006444:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006448:	f6070613          	addi	a2,a4,-160
    8000644c:	6394                	ld	a3,0(a5)
    8000644e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006450:	00870593          	addi	a1,a4,8
    80006454:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006456:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006458:	0007b803          	ld	a6,0(a5)
    8000645c:	9642                	add	a2,a2,a6
    8000645e:	46c1                	li	a3,16
    80006460:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006462:	4585                	li	a1,1
    80006464:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80006468:	f8442683          	lw	a3,-124(s0)
    8000646c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006470:	0692                	slli	a3,a3,0x4
    80006472:	9836                	add	a6,a6,a3
    80006474:	058a8613          	addi	a2,s5,88
    80006478:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000647c:	0007b803          	ld	a6,0(a5)
    80006480:	96c2                	add	a3,a3,a6
    80006482:	40000613          	li	a2,1024
    80006486:	c690                	sw	a2,8(a3)
  if(write)
    80006488:	001c3613          	seqz	a2,s8
    8000648c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006490:	00166613          	ori	a2,a2,1
    80006494:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80006498:	f8842603          	lw	a2,-120(s0)
    8000649c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800064a0:	00250693          	addi	a3,a0,2
    800064a4:	0692                	slli	a3,a3,0x4
    800064a6:	96be                	add	a3,a3,a5
    800064a8:	58fd                	li	a7,-1
    800064aa:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800064ae:	0612                	slli	a2,a2,0x4
    800064b0:	9832                	add	a6,a6,a2
    800064b2:	f9070713          	addi	a4,a4,-112
    800064b6:	973e                	add	a4,a4,a5
    800064b8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800064bc:	6398                	ld	a4,0(a5)
    800064be:	9732                	add	a4,a4,a2
    800064c0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800064c2:	4609                	li	a2,2
    800064c4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800064c8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800064cc:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800064d0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800064d4:	6794                	ld	a3,8(a5)
    800064d6:	0026d703          	lhu	a4,2(a3)
    800064da:	8b1d                	andi	a4,a4,7
    800064dc:	0706                	slli	a4,a4,0x1
    800064de:	96ba                	add	a3,a3,a4
    800064e0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800064e4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800064e8:	6798                	ld	a4,8(a5)
    800064ea:	00275783          	lhu	a5,2(a4)
    800064ee:	2785                	addiw	a5,a5,1
    800064f0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800064f4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800064f8:	100017b7          	lui	a5,0x10001
    800064fc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006500:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80006504:	0001d917          	auipc	s2,0x1d
    80006508:	12490913          	addi	s2,s2,292 # 80023628 <disk+0x128>
  while(b->disk == 1) {
    8000650c:	4485                	li	s1,1
    8000650e:	00b79c63          	bne	a5,a1,80006526 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006512:	85ca                	mv	a1,s2
    80006514:	8556                	mv	a0,s5
    80006516:	ffffc097          	auipc	ra,0xffffc
    8000651a:	b4a080e7          	jalr	-1206(ra) # 80002060 <sleep>
  while(b->disk == 1) {
    8000651e:	004aa783          	lw	a5,4(s5)
    80006522:	fe9788e3          	beq	a5,s1,80006512 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006526:	f8042903          	lw	s2,-128(s0)
    8000652a:	00290713          	addi	a4,s2,2
    8000652e:	0712                	slli	a4,a4,0x4
    80006530:	0001d797          	auipc	a5,0x1d
    80006534:	fd078793          	addi	a5,a5,-48 # 80023500 <disk>
    80006538:	97ba                	add	a5,a5,a4
    8000653a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000653e:	0001d997          	auipc	s3,0x1d
    80006542:	fc298993          	addi	s3,s3,-62 # 80023500 <disk>
    80006546:	00491713          	slli	a4,s2,0x4
    8000654a:	0009b783          	ld	a5,0(s3)
    8000654e:	97ba                	add	a5,a5,a4
    80006550:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006554:	854a                	mv	a0,s2
    80006556:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000655a:	00000097          	auipc	ra,0x0
    8000655e:	b9c080e7          	jalr	-1124(ra) # 800060f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006562:	8885                	andi	s1,s1,1
    80006564:	f0ed                	bnez	s1,80006546 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006566:	0001d517          	auipc	a0,0x1d
    8000656a:	0c250513          	addi	a0,a0,194 # 80023628 <disk+0x128>
    8000656e:	ffffa097          	auipc	ra,0xffffa
    80006572:	71c080e7          	jalr	1820(ra) # 80000c8a <release>
}
    80006576:	70e6                	ld	ra,120(sp)
    80006578:	7446                	ld	s0,112(sp)
    8000657a:	74a6                	ld	s1,104(sp)
    8000657c:	7906                	ld	s2,96(sp)
    8000657e:	69e6                	ld	s3,88(sp)
    80006580:	6a46                	ld	s4,80(sp)
    80006582:	6aa6                	ld	s5,72(sp)
    80006584:	6b06                	ld	s6,64(sp)
    80006586:	7be2                	ld	s7,56(sp)
    80006588:	7c42                	ld	s8,48(sp)
    8000658a:	7ca2                	ld	s9,40(sp)
    8000658c:	7d02                	ld	s10,32(sp)
    8000658e:	6de2                	ld	s11,24(sp)
    80006590:	6109                	addi	sp,sp,128
    80006592:	8082                	ret

0000000080006594 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006594:	1101                	addi	sp,sp,-32
    80006596:	ec06                	sd	ra,24(sp)
    80006598:	e822                	sd	s0,16(sp)
    8000659a:	e426                	sd	s1,8(sp)
    8000659c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000659e:	0001d497          	auipc	s1,0x1d
    800065a2:	f6248493          	addi	s1,s1,-158 # 80023500 <disk>
    800065a6:	0001d517          	auipc	a0,0x1d
    800065aa:	08250513          	addi	a0,a0,130 # 80023628 <disk+0x128>
    800065ae:	ffffa097          	auipc	ra,0xffffa
    800065b2:	628080e7          	jalr	1576(ra) # 80000bd6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800065b6:	10001737          	lui	a4,0x10001
    800065ba:	533c                	lw	a5,96(a4)
    800065bc:	8b8d                	andi	a5,a5,3
    800065be:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800065c0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800065c4:	689c                	ld	a5,16(s1)
    800065c6:	0204d703          	lhu	a4,32(s1)
    800065ca:	0027d783          	lhu	a5,2(a5)
    800065ce:	04f70863          	beq	a4,a5,8000661e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800065d2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800065d6:	6898                	ld	a4,16(s1)
    800065d8:	0204d783          	lhu	a5,32(s1)
    800065dc:	8b9d                	andi	a5,a5,7
    800065de:	078e                	slli	a5,a5,0x3
    800065e0:	97ba                	add	a5,a5,a4
    800065e2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800065e4:	00278713          	addi	a4,a5,2
    800065e8:	0712                	slli	a4,a4,0x4
    800065ea:	9726                	add	a4,a4,s1
    800065ec:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800065f0:	e721                	bnez	a4,80006638 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800065f2:	0789                	addi	a5,a5,2
    800065f4:	0792                	slli	a5,a5,0x4
    800065f6:	97a6                	add	a5,a5,s1
    800065f8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800065fa:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800065fe:	ffffc097          	auipc	ra,0xffffc
    80006602:	ac6080e7          	jalr	-1338(ra) # 800020c4 <wakeup>

    disk.used_idx += 1;
    80006606:	0204d783          	lhu	a5,32(s1)
    8000660a:	2785                	addiw	a5,a5,1
    8000660c:	17c2                	slli	a5,a5,0x30
    8000660e:	93c1                	srli	a5,a5,0x30
    80006610:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006614:	6898                	ld	a4,16(s1)
    80006616:	00275703          	lhu	a4,2(a4)
    8000661a:	faf71ce3          	bne	a4,a5,800065d2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000661e:	0001d517          	auipc	a0,0x1d
    80006622:	00a50513          	addi	a0,a0,10 # 80023628 <disk+0x128>
    80006626:	ffffa097          	auipc	ra,0xffffa
    8000662a:	664080e7          	jalr	1636(ra) # 80000c8a <release>
}
    8000662e:	60e2                	ld	ra,24(sp)
    80006630:	6442                	ld	s0,16(sp)
    80006632:	64a2                	ld	s1,8(sp)
    80006634:	6105                	addi	sp,sp,32
    80006636:	8082                	ret
      panic("virtio_disk_intr status");
    80006638:	00003517          	auipc	a0,0x3
    8000663c:	2e850513          	addi	a0,a0,744 # 80009920 <syscalls+0x4d0>
    80006640:	ffffa097          	auipc	ra,0xffffa
    80006644:	f00080e7          	jalr	-256(ra) # 80000540 <panic>

0000000080006648 <open_file>:
  filePath: File's path
  omode: Manipulation mode

[OUTPUT]: File descriptor, -1 on error
*/
int open_file(char * path, int omode){
    80006648:	7139                	addi	sp,sp,-64
    8000664a:	fc06                	sd	ra,56(sp)
    8000664c:	f822                	sd	s0,48(sp)
    8000664e:	f426                	sd	s1,40(sp)
    80006650:	f04a                	sd	s2,32(sp)
    80006652:	ec4e                	sd	s3,24(sp)
    80006654:	e852                	sd	s4,16(sp)
    80006656:	0080                	addi	s0,sp,64
    80006658:	84aa                	mv	s1,a0
    8000665a:	8a2e                	mv	s4,a1
  int fd;
  struct file *f;
  struct inode *ip;
  int n;

  begin_op();
    8000665c:	ffffe097          	auipc	ra,0xffffe
    80006660:	d34080e7          	jalr	-716(ra) # 80004390 <begin_op>

  if(omode & O_CREATE){
    80006664:	200a7793          	andi	a5,s4,512
    80006668:	c7f5                	beqz	a5,80006754 <open_file+0x10c>
  if((dp = nameiparent(path, name)) == 0)
    8000666a:	fc040593          	addi	a1,s0,-64
    8000666e:	8526                	mv	a0,s1
    80006670:	ffffe097          	auipc	ra,0xffffe
    80006674:	b1e080e7          	jalr	-1250(ra) # 8000418e <nameiparent>
    80006678:	84aa                	mv	s1,a0
    8000667a:	c531                	beqz	a0,800066c6 <open_file+0x7e>
  ilock(dp);
    8000667c:	ffffd097          	auipc	ra,0xffffd
    80006680:	348080e7          	jalr	840(ra) # 800039c4 <ilock>
  if((ip = dirlookup(dp, name, 0)) != 0){
    80006684:	4601                	li	a2,0
    80006686:	fc040593          	addi	a1,s0,-64
    8000668a:	8526                	mv	a0,s1
    8000668c:	ffffe097          	auipc	ra,0xffffe
    80006690:	81c080e7          	jalr	-2020(ra) # 80003ea8 <dirlookup>
    80006694:	892a                	mv	s2,a0
    80006696:	cd15                	beqz	a0,800066d2 <open_file+0x8a>
    iunlockput(dp);
    80006698:	8526                	mv	a0,s1
    8000669a:	ffffd097          	auipc	ra,0xffffd
    8000669e:	58c080e7          	jalr	1420(ra) # 80003c26 <iunlockput>
    ilock(ip);
    800066a2:	854a                	mv	a0,s2
    800066a4:	ffffd097          	auipc	ra,0xffffd
    800066a8:	320080e7          	jalr	800(ra) # 800039c4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800066ac:	04495783          	lhu	a5,68(s2)
    800066b0:	37f9                	addiw	a5,a5,-2
    800066b2:	17c2                	slli	a5,a5,0x30
    800066b4:	93c1                	srli	a5,a5,0x30
    800066b6:	4705                	li	a4,1
    800066b8:	0af77e63          	bgeu	a4,a5,80006774 <open_file+0x12c>
    iunlockput(ip);
    800066bc:	854a                	mv	a0,s2
    800066be:	ffffd097          	auipc	ra,0xffffd
    800066c2:	568080e7          	jalr	1384(ra) # 80003c26 <iunlockput>
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
    800066c6:	ffffe097          	auipc	ra,0xffffe
    800066ca:	d48080e7          	jalr	-696(ra) # 8000440e <end_op>
      return -1;
    800066ce:	54fd                	li	s1,-1
    800066d0:	aa79                	j	8000686e <open_file+0x226>
  if((ip = ialloc(dp->dev, type)) == 0){
    800066d2:	4589                	li	a1,2
    800066d4:	4088                	lw	a0,0(s1)
    800066d6:	ffffd097          	auipc	ra,0xffffd
    800066da:	150080e7          	jalr	336(ra) # 80003826 <ialloc>
    800066de:	892a                	mv	s2,a0
    800066e0:	c131                	beqz	a0,80006724 <open_file+0xdc>
  ilock(ip);
    800066e2:	ffffd097          	auipc	ra,0xffffd
    800066e6:	2e2080e7          	jalr	738(ra) # 800039c4 <ilock>
  ip->major = major;
    800066ea:	04091323          	sh	zero,70(s2)
  ip->minor = minor;
    800066ee:	04091423          	sh	zero,72(s2)
  ip->nlink = 1;
    800066f2:	4785                	li	a5,1
    800066f4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800066f8:	854a                	mv	a0,s2
    800066fa:	ffffd097          	auipc	ra,0xffffd
    800066fe:	1fe080e7          	jalr	510(ra) # 800038f8 <iupdate>
  if(dirlink(dp, name, ip->inum) < 0)
    80006702:	00492603          	lw	a2,4(s2)
    80006706:	fc040593          	addi	a1,s0,-64
    8000670a:	8526                	mv	a0,s1
    8000670c:	ffffe097          	auipc	ra,0xffffe
    80006710:	9b2080e7          	jalr	-1614(ra) # 800040be <dirlink>
    80006714:	00054e63          	bltz	a0,80006730 <open_file+0xe8>
  iunlockput(dp);
    80006718:	8526                	mv	a0,s1
    8000671a:	ffffd097          	auipc	ra,0xffffd
    8000671e:	50c080e7          	jalr	1292(ra) # 80003c26 <iunlockput>
  return ip;
    80006722:	a889                	j	80006774 <open_file+0x12c>
    iunlockput(dp);
    80006724:	8526                	mv	a0,s1
    80006726:	ffffd097          	auipc	ra,0xffffd
    8000672a:	500080e7          	jalr	1280(ra) # 80003c26 <iunlockput>
    return 0;
    8000672e:	bf61                	j	800066c6 <open_file+0x7e>
  ip->nlink = 0;
    80006730:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80006734:	854a                	mv	a0,s2
    80006736:	ffffd097          	auipc	ra,0xffffd
    8000673a:	1c2080e7          	jalr	450(ra) # 800038f8 <iupdate>
  iunlockput(ip);
    8000673e:	854a                	mv	a0,s2
    80006740:	ffffd097          	auipc	ra,0xffffd
    80006744:	4e6080e7          	jalr	1254(ra) # 80003c26 <iunlockput>
  iunlockput(dp);
    80006748:	8526                	mv	a0,s1
    8000674a:	ffffd097          	auipc	ra,0xffffd
    8000674e:	4dc080e7          	jalr	1244(ra) # 80003c26 <iunlockput>
  return 0;
    80006752:	bf95                	j	800066c6 <open_file+0x7e>
    }
  } else {
    if((ip = namei(path)) == 0){
    80006754:	8526                	mv	a0,s1
    80006756:	ffffe097          	auipc	ra,0xffffe
    8000675a:	a1a080e7          	jalr	-1510(ra) # 80004170 <namei>
    8000675e:	892a                	mv	s2,a0
    80006760:	c925                	beqz	a0,800067d0 <open_file+0x188>
      end_op();
      return -1;
    }
    ilock(ip);
    80006762:	ffffd097          	auipc	ra,0xffffd
    80006766:	262080e7          	jalr	610(ra) # 800039c4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000676a:	04491703          	lh	a4,68(s2)
    8000676e:	4785                	li	a5,1
    80006770:	06f70663          	beq	a4,a5,800067dc <open_file+0x194>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80006774:	04491703          	lh	a4,68(s2)
    80006778:	478d                	li	a5,3
    8000677a:	00f71763          	bne	a4,a5,80006788 <open_file+0x140>
    8000677e:	04695703          	lhu	a4,70(s2)
    80006782:	47a5                	li	a5,9
    80006784:	06e7e963          	bltu	a5,a4,800067f6 <open_file+0x1ae>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006788:	ffffe097          	auipc	ra,0xffffe
    8000678c:	014080e7          	jalr	20(ra) # 8000479c <filealloc>
    80006790:	89aa                	mv	s3,a0
    80006792:	c505                	beqz	a0,800067ba <open_file+0x172>
  struct proc *p = myproc();
    80006794:	ffffb097          	auipc	ra,0xffffb
    80006798:	218080e7          	jalr	536(ra) # 800019ac <myproc>
  for(fd = 0; fd < NOFILE; fd++){
    8000679c:	0d050793          	addi	a5,a0,208
    800067a0:	4481                	li	s1,0
    800067a2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800067a4:	6398                	ld	a4,0(a5)
    800067a6:	c33d                	beqz	a4,8000680c <open_file+0x1c4>
  for(fd = 0; fd < NOFILE; fd++){
    800067a8:	2485                	addiw	s1,s1,1
    800067aa:	07a1                	addi	a5,a5,8
    800067ac:	fed49ce3          	bne	s1,a3,800067a4 <open_file+0x15c>
    if(f)
      fileclose(f);
    800067b0:	854e                	mv	a0,s3
    800067b2:	ffffe097          	auipc	ra,0xffffe
    800067b6:	0a6080e7          	jalr	166(ra) # 80004858 <fileclose>
    iunlockput(ip);
    800067ba:	854a                	mv	a0,s2
    800067bc:	ffffd097          	auipc	ra,0xffffd
    800067c0:	46a080e7          	jalr	1130(ra) # 80003c26 <iunlockput>
    end_op();
    800067c4:	ffffe097          	auipc	ra,0xffffe
    800067c8:	c4a080e7          	jalr	-950(ra) # 8000440e <end_op>
    return -1;
    800067cc:	54fd                	li	s1,-1
    800067ce:	a045                	j	8000686e <open_file+0x226>
      end_op();
    800067d0:	ffffe097          	auipc	ra,0xffffe
    800067d4:	c3e080e7          	jalr	-962(ra) # 8000440e <end_op>
      return -1;
    800067d8:	54fd                	li	s1,-1
    800067da:	a851                	j	8000686e <open_file+0x226>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800067dc:	fa0a06e3          	beqz	s4,80006788 <open_file+0x140>
      iunlockput(ip);
    800067e0:	854a                	mv	a0,s2
    800067e2:	ffffd097          	auipc	ra,0xffffd
    800067e6:	444080e7          	jalr	1092(ra) # 80003c26 <iunlockput>
      end_op();
    800067ea:	ffffe097          	auipc	ra,0xffffe
    800067ee:	c24080e7          	jalr	-988(ra) # 8000440e <end_op>
      return -1;
    800067f2:	54fd                	li	s1,-1
    800067f4:	a8ad                	j	8000686e <open_file+0x226>
    iunlockput(ip);
    800067f6:	854a                	mv	a0,s2
    800067f8:	ffffd097          	auipc	ra,0xffffd
    800067fc:	42e080e7          	jalr	1070(ra) # 80003c26 <iunlockput>
    end_op();
    80006800:	ffffe097          	auipc	ra,0xffffe
    80006804:	c0e080e7          	jalr	-1010(ra) # 8000440e <end_op>
    return -1;
    80006808:	54fd                	li	s1,-1
    8000680a:	a095                	j	8000686e <open_file+0x226>
      p->ofile[fd] = f;
    8000680c:	01a48793          	addi	a5,s1,26
    80006810:	078e                	slli	a5,a5,0x3
    80006812:	953e                	add	a0,a0,a5
    80006814:	01353023          	sd	s3,0(a0)
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006818:	f804cce3          	bltz	s1,800067b0 <open_file+0x168>
  }

  if(ip->type == T_DEVICE){
    8000681c:	04491703          	lh	a4,68(s2)
    80006820:	478d                	li	a5,3
    80006822:	04f70f63          	beq	a4,a5,80006880 <open_file+0x238>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006826:	4789                	li	a5,2
    80006828:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000682c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80006830:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80006834:	001a4793          	xori	a5,s4,1
    80006838:	8b85                	andi	a5,a5,1
    8000683a:	00f98423          	sb	a5,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000683e:	003a7793          	andi	a5,s4,3
    80006842:	00f037b3          	snez	a5,a5
    80006846:	00f984a3          	sb	a5,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000684a:	400a7a13          	andi	s4,s4,1024
    8000684e:	000a0763          	beqz	s4,8000685c <open_file+0x214>
    80006852:	04491703          	lh	a4,68(s2)
    80006856:	4789                	li	a5,2
    80006858:	02f70b63          	beq	a4,a5,8000688e <open_file+0x246>
    itrunc(ip);
  }

  iunlock(ip);
    8000685c:	854a                	mv	a0,s2
    8000685e:	ffffd097          	auipc	ra,0xffffd
    80006862:	228080e7          	jalr	552(ra) # 80003a86 <iunlock>
  end_op();
    80006866:	ffffe097          	auipc	ra,0xffffe
    8000686a:	ba8080e7          	jalr	-1112(ra) # 8000440e <end_op>

  return fd;


}
    8000686e:	8526                	mv	a0,s1
    80006870:	70e2                	ld	ra,56(sp)
    80006872:	7442                	ld	s0,48(sp)
    80006874:	74a2                	ld	s1,40(sp)
    80006876:	7902                	ld	s2,32(sp)
    80006878:	69e2                	ld	s3,24(sp)
    8000687a:	6a42                	ld	s4,16(sp)
    8000687c:	6121                	addi	sp,sp,64
    8000687e:	8082                	ret
    f->type = FD_DEVICE;
    80006880:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80006884:	04691783          	lh	a5,70(s2)
    80006888:	02f99223          	sh	a5,36(s3)
    8000688c:	b755                	j	80006830 <open_file+0x1e8>
    itrunc(ip);
    8000688e:	854a                	mv	a0,s2
    80006890:	ffffd097          	auipc	ra,0xffffd
    80006894:	242080e7          	jalr	578(ra) # 80003ad2 <itrunc>
    80006898:	b7d1                	j	8000685c <open_file+0x214>

000000008000689a <read_line>:

[OUTPUT]: Number of read bytes. Upon reading end-of-file, zero is returned.  

[ERROR]: -1 is returned
*/
int read_line(int fd, char * buffer){
    8000689a:	715d                	addi	sp,sp,-80
    8000689c:	e486                	sd	ra,72(sp)
    8000689e:	e0a2                	sd	s0,64(sp)
    800068a0:	fc26                	sd	s1,56(sp)
    800068a2:	f84a                	sd	s2,48(sp)
    800068a4:	f44e                	sd	s3,40(sp)
    800068a6:	f052                	sd	s4,32(sp)
    800068a8:	ec56                	sd	s5,24(sp)
    800068aa:	e85a                	sd	s6,16(sp)
    800068ac:	0880                	addi	s0,sp,80

  struct file *f;

  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800068ae:	47bd                	li	a5,15
    return -1;
    800068b0:	59fd                	li	s3,-1
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800068b2:	00a7fd63          	bgeu	a5,a0,800068cc <read_line+0x32>

    }

  }

}
    800068b6:	854e                	mv	a0,s3
    800068b8:	60a6                	ld	ra,72(sp)
    800068ba:	6406                	ld	s0,64(sp)
    800068bc:	74e2                	ld	s1,56(sp)
    800068be:	7942                	ld	s2,48(sp)
    800068c0:	79a2                	ld	s3,40(sp)
    800068c2:	7a02                	ld	s4,32(sp)
    800068c4:	6ae2                	ld	s5,24(sp)
    800068c6:	6b42                	ld	s6,16(sp)
    800068c8:	6161                	addi	sp,sp,80
    800068ca:	8082                	ret
    800068cc:	892e                	mv	s2,a1
    800068ce:	89aa                	mv	s3,a0
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800068d0:	ffffb097          	auipc	ra,0xffffb
    800068d4:	0dc080e7          	jalr	220(ra) # 800019ac <myproc>
    800068d8:	01a98793          	addi	a5,s3,26
    800068dc:	078e                	slli	a5,a5,0x3
    800068de:	953e                	add	a0,a0,a5
    800068e0:	6104                	ld	s1,0(a0)
    800068e2:	c0f5                	beqz	s1,800069c6 <read_line+0x12c>
  if (!fd){ 
    800068e4:	08099c63          	bnez	s3,8000697c <read_line+0xe2>
    if (f->pipe){
    800068e8:	689c                	ld	a5,16(s1)
    800068ea:	8a4a                	mv	s4,s2
    800068ec:	4a81                	li	s5,0
        if (buffer[idx]=='\n'){
    800068ee:	4b29                	li	s6,10
    if (f->pipe){
    800068f0:	ef8d                	bnez	a5,8000692a <read_line+0x90>
    800068f2:	89ca                	mv	s3,s2
    800068f4:	4a01                	li	s4,0
      while((readStatus=devsw[f->major].read(0, (uint64)buffer+idx, 1)) == 1){ // The first 0 indicates kernel address
    800068f6:	0001ca97          	auipc	s5,0x1c
    800068fa:	bb2a8a93          	addi	s5,s5,-1102 # 800224a8 <devsw>
    800068fe:	02449783          	lh	a5,36(s1)
    80006902:	0792                	slli	a5,a5,0x4
    80006904:	97d6                	add	a5,a5,s5
    80006906:	639c                	ld	a5,0(a5)
    80006908:	4605                	li	a2,1
    8000690a:	85ce                	mv	a1,s3
    8000690c:	4501                	li	a0,0
    8000690e:	9782                	jalr	a5
    80006910:	4785                	li	a5,1
    80006912:	06f51163          	bne	a0,a5,80006974 <read_line+0xda>
        if (buffer[idx]=='\n'){
    80006916:	0009c783          	lbu	a5,0(s3)
    8000691a:	001a0713          	addi	a4,s4,1
    8000691e:	0985                	addi	s3,s3,1
    80006920:	05678663          	beq	a5,s6,8000696c <read_line+0xd2>
    80006924:	8a3a                	mv	s4,a4
    80006926:	bfe1                	j	800068fe <read_line+0x64>
    80006928:	8aba                	mv	s5,a4
    8000692a:	000a899b          	sext.w	s3,s5
        readStatus = read_pipe(f->pipe,(uint64)buffer+idx,1);
    8000692e:	4605                	li	a2,1
    80006930:	85d2                	mv	a1,s4
    80006932:	6888                	ld	a0,16(s1)
    80006934:	ffffe097          	auipc	ra,0xffffe
    80006938:	584080e7          	jalr	1412(ra) # 80004eb8 <read_pipe>
        if (readStatus<= 0){
    8000693c:	00a05e63          	blez	a0,80006958 <read_line+0xbe>
        if (buffer[idx]=='\n'){
    80006940:	000a4783          	lbu	a5,0(s4)
    80006944:	001a8713          	addi	a4,s5,1
    80006948:	0a05                	addi	s4,s4,1
    8000694a:	fd679fe3          	bne	a5,s6,80006928 <read_line+0x8e>
          buffer[idx+1]=0;
    8000694e:	9aca                	add	s5,s5,s2
    80006950:	000a80a3          	sb	zero,1(s5)
          return idx+1;
    80006954:	2985                	addiw	s3,s3,1
    80006956:	b785                	j	800068b6 <read_line+0x1c>
          if (idx!=0){
    80006958:	f4098fe3          	beqz	s3,800068b6 <read_line+0x1c>
            buffer[idx] = '\n';
    8000695c:	9aca                	add	s5,s5,s2
    8000695e:	47a9                	li	a5,10
    80006960:	00fa8023          	sb	a5,0(s5)
            buffer[idx+1]=0;
    80006964:	000a80a3          	sb	zero,1(s5)
            return idx+1;
    80006968:	2985                	addiw	s3,s3,1
    8000696a:	b7b1                	j	800068b6 <read_line+0x1c>
          buffer[idx+1]=0;
    8000696c:	9a4a                	add	s4,s4,s2
    8000696e:	000a00a3          	sb	zero,1(s4)
      if (!newLine)
    80006972:	b791                	j	800068b6 <read_line+0x1c>
        buffer[idx]=0;
    80006974:	9a4a                	add	s4,s4,s2
    80006976:	000a0023          	sb	zero,0(s4)
}
    8000697a:	bf35                	j	800068b6 <read_line+0x1c>
  int byteCount = 0;
    8000697c:	4981                	li	s3,0
        if (readByte == '\n'){
    8000697e:	4a29                	li	s4,10
        readStatus = readi(f->ip, 0, (uint64)&readByte, f->off, 1);
    80006980:	4705                	li	a4,1
    80006982:	5094                	lw	a3,32(s1)
    80006984:	fbf40613          	addi	a2,s0,-65
    80006988:	4581                	li	a1,0
    8000698a:	6c88                	ld	a0,24(s1)
    8000698c:	ffffd097          	auipc	ra,0xffffd
    80006990:	2ec080e7          	jalr	748(ra) # 80003c78 <readi>
        if (readStatus > 0)
    80006994:	02a05063          	blez	a0,800069b4 <read_line+0x11a>
          f->off += readStatus;
    80006998:	509c                	lw	a5,32(s1)
    8000699a:	9fa9                	addw	a5,a5,a0
    8000699c:	d09c                	sw	a5,32(s1)
        *buffer++ = readByte;
    8000699e:	0905                	addi	s2,s2,1
    800069a0:	fbf44783          	lbu	a5,-65(s0)
    800069a4:	fef90fa3          	sb	a5,-1(s2)
        byteCount++;
    800069a8:	2985                	addiw	s3,s3,1
        if (readByte == '\n'){
    800069aa:	fd479be3          	bne	a5,s4,80006980 <read_line+0xe6>
            *(buffer)=0; // Nullifying the end of the string
    800069ae:	00090023          	sb	zero,0(s2)
          return byteCount;
    800069b2:	b711                	j	800068b6 <read_line+0x1c>
          if (byteCount!=0){
    800069b4:	f00981e3          	beqz	s3,800068b6 <read_line+0x1c>
            *buffer = '\n';
    800069b8:	47a9                	li	a5,10
    800069ba:	00f90023          	sb	a5,0(s2)
            *(buffer+1)=0;
    800069be:	000900a3          	sb	zero,1(s2)
            return byteCount+1;
    800069c2:	2985                	addiw	s3,s3,1
    800069c4:	bdcd                	j	800068b6 <read_line+0x1c>
    return -1;
    800069c6:	59fd                	li	s3,-1
    800069c8:	b5fd                	j	800068b6 <read_line+0x1c>

00000000800069ca <close_file>:
  fd: File discriptor

[OUTPUT]:

*/
void close_file(struct file *f){
    800069ca:	1141                	addi	sp,sp,-16
    800069cc:	e406                	sd	ra,8(sp)
    800069ce:	e022                	sd	s0,0(sp)
    800069d0:	0800                	addi	s0,sp,16
  fileclose(f);
    800069d2:	ffffe097          	auipc	ra,0xffffe
    800069d6:	e86080e7          	jalr	-378(ra) # 80004858 <fileclose>
}
    800069da:	60a2                	ld	ra,8(sp)
    800069dc:	6402                	ld	s0,0(sp)
    800069de:	0141                	addi	sp,sp,16
    800069e0:	8082                	ret

00000000800069e2 <get_strlen>:

/* Computes the length of a string
[Input]: String pointer
[Output]: String's length
 */
int get_strlen(const char * str){
    800069e2:	1141                	addi	sp,sp,-16
    800069e4:	e422                	sd	s0,8(sp)
    800069e6:	0800                	addi	s0,sp,16
	int len = 0;
	while(*str++){len++;};
    800069e8:	00054783          	lbu	a5,0(a0)
    800069ec:	cf99                	beqz	a5,80006a0a <get_strlen+0x28>
    800069ee:	00150713          	addi	a4,a0,1
    800069f2:	87ba                	mv	a5,a4
    800069f4:	4685                	li	a3,1
    800069f6:	9e99                	subw	a3,a3,a4
    800069f8:	00f6853b          	addw	a0,a3,a5
    800069fc:	0785                	addi	a5,a5,1
    800069fe:	fff7c703          	lbu	a4,-1(a5)
    80006a02:	fb7d                	bnez	a4,800069f8 <get_strlen+0x16>
	return len;
}
    80006a04:	6422                	ld	s0,8(sp)
    80006a06:	0141                	addi	sp,sp,16
    80006a08:	8082                	ret
	int len = 0;
    80006a0a:	4501                	li	a0,0
    80006a0c:	bfe5                	j	80006a04 <get_strlen+0x22>

0000000080006a0e <compare_str>:
/* Compars two given strings
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str(const char * s1 , const char * s2){
    80006a0e:	1141                	addi	sp,sp,-16
    80006a10:	e422                	sd	s0,8(sp)
    80006a12:	0800                	addi	s0,sp,16

	while(*s1 && *s2){
    80006a14:	00054783          	lbu	a5,0(a0)
    80006a18:	cb91                	beqz	a5,80006a2c <compare_str+0x1e>
    80006a1a:	0005c703          	lbu	a4,0(a1)
    80006a1e:	c719                	beqz	a4,80006a2c <compare_str+0x1e>
		if (*s1++ != *s2++)
    80006a20:	0505                	addi	a0,a0,1
    80006a22:	0585                	addi	a1,a1,1
    80006a24:	fee788e3          	beq	a5,a4,80006a14 <compare_str+0x6>
			return 1;
    80006a28:	4505                	li	a0,1
    80006a2a:	a031                	j	80006a36 <compare_str+0x28>
	}
	if (*s1 == *s2)
    80006a2c:	0005c503          	lbu	a0,0(a1)
    80006a30:	8d1d                	sub	a0,a0,a5
			return 1;
    80006a32:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    80006a36:	6422                	ld	s0,8(sp)
    80006a38:	0141                	addi	sp,sp,16
    80006a3a:	8082                	ret

0000000080006a3c <compare_str_ic>:
/* Compars two given strings (case-insensitive)
[Input]: String 1 pointer
		 String 2 pointer
[Output]: 0 If equal, else 1
*/
char compare_str_ic(const char * s1 , const char * s2){
    80006a3c:	1141                	addi	sp,sp,-16
    80006a3e:	e422                	sd	s0,8(sp)
    80006a40:	0800                	addi	s0,sp,16
	while(*s1 && *s2){

		char b1 = *s1++;
		char b2 = *s2++;

		if (b1>='A' && b1<='Z'){
    80006a42:	4665                	li	a2,25
	while(*s1 && *s2){
    80006a44:	a019                	j	80006a4a <compare_str_ic+0xe>
			b1 += 32;
		}
		if (b2>='A' && b2<='Z')
			b2 += 32;

		if (b1!=b2){
    80006a46:	04e79763          	bne	a5,a4,80006a94 <compare_str_ic+0x58>
	while(*s1 && *s2){
    80006a4a:	00054783          	lbu	a5,0(a0)
    80006a4e:	cb9d                	beqz	a5,80006a84 <compare_str_ic+0x48>
    80006a50:	0005c703          	lbu	a4,0(a1)
    80006a54:	cb05                	beqz	a4,80006a84 <compare_str_ic+0x48>
		char b1 = *s1++;
    80006a56:	0505                	addi	a0,a0,1
		char b2 = *s2++;
    80006a58:	0585                	addi	a1,a1,1
		if (b1>='A' && b1<='Z'){
    80006a5a:	fbf7869b          	addiw	a3,a5,-65
    80006a5e:	0ff6f693          	zext.b	a3,a3
    80006a62:	00d66663          	bltu	a2,a3,80006a6e <compare_str_ic+0x32>
			b1 += 32;
    80006a66:	0207879b          	addiw	a5,a5,32
    80006a6a:	0ff7f793          	zext.b	a5,a5
		if (b2>='A' && b2<='Z')
    80006a6e:	fbf7069b          	addiw	a3,a4,-65
    80006a72:	0ff6f693          	zext.b	a3,a3
    80006a76:	fcd668e3          	bltu	a2,a3,80006a46 <compare_str_ic+0xa>
			b2 += 32;
    80006a7a:	0207071b          	addiw	a4,a4,32
    80006a7e:	0ff77713          	zext.b	a4,a4
    80006a82:	b7d1                	j	80006a46 <compare_str_ic+0xa>
			return 1;
		}
	}
	if (*s1 == *s2)
    80006a84:	0005c503          	lbu	a0,0(a1)
    80006a88:	8d1d                	sub	a0,a0,a5
			return 1;
    80006a8a:	00a03533          	snez	a0,a0
		return 0;
	return 1;
}
    80006a8e:	6422                	ld	s0,8(sp)
    80006a90:	0141                	addi	sp,sp,16
    80006a92:	8082                	ret
			return 1;
    80006a94:	4505                	li	a0,1
    80006a96:	bfe5                	j	80006a8e <compare_str_ic+0x52>

0000000080006a98 <check_substr>:
[Input]: String 1 pointer
		 String 2 pointer
[Output]: index If substring, else -1
*/
int check_substr(char* s1, char* s2)
{
    80006a98:	7179                	addi	sp,sp,-48
    80006a9a:	f406                	sd	ra,40(sp)
    80006a9c:	f022                	sd	s0,32(sp)
    80006a9e:	ec26                	sd	s1,24(sp)
    80006aa0:	e84a                	sd	s2,16(sp)
    80006aa2:	e44e                	sd	s3,8(sp)
    80006aa4:	1800                	addi	s0,sp,48
    80006aa6:	89aa                	mv	s3,a0
    80006aa8:	892e                	mv	s2,a1
    int M = get_strlen(s1);
    80006aaa:	00000097          	auipc	ra,0x0
    80006aae:	f38080e7          	jalr	-200(ra) # 800069e2 <get_strlen>
    80006ab2:	84aa                	mv	s1,a0
    int N = get_strlen(s2);
    80006ab4:	854a                	mv	a0,s2
    80006ab6:	00000097          	auipc	ra,0x0
    80006aba:	f2c080e7          	jalr	-212(ra) # 800069e2 <get_strlen>
 
    /* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
    80006abe:	409505bb          	subw	a1,a0,s1
    80006ac2:	4881                	li	a7,0
        int j;
 
        /* For current index i, check for
 pattern match */
        for (j = 0; j < M; j++)
    80006ac4:	4301                	li	t1,0
 
        if (j == M)
            return i;
    }
 
    return -1;
    80006ac6:	557d                	li	a0,-1
    for (int i = 0; i <= N - M; i++) {
    80006ac8:	0005da63          	bgez	a1,80006adc <check_substr+0x44>
    80006acc:	a81d                	j	80006b02 <check_substr+0x6a>
        if (j == M)
    80006ace:	02f48a63          	beq	s1,a5,80006b02 <check_substr+0x6a>
    for (int i = 0; i <= N - M; i++) {
    80006ad2:	0885                	addi	a7,a7,1
    80006ad4:	0008879b          	sext.w	a5,a7
    80006ad8:	02f5cc63          	blt	a1,a5,80006b10 <check_substr+0x78>
    80006adc:	0008851b          	sext.w	a0,a7
        for (j = 0; j < M; j++)
    80006ae0:	011906b3          	add	a3,s2,a7
    80006ae4:	874e                	mv	a4,s3
    80006ae6:	879a                	mv	a5,t1
    80006ae8:	fe9053e3          	blez	s1,80006ace <check_substr+0x36>
            if (s2[i + j] != s1[j])
    80006aec:	0006c803          	lbu	a6,0(a3)
    80006af0:	00074603          	lbu	a2,0(a4)
    80006af4:	fcc81de3          	bne	a6,a2,80006ace <check_substr+0x36>
        for (j = 0; j < M; j++)
    80006af8:	2785                	addiw	a5,a5,1
    80006afa:	0685                	addi	a3,a3,1
    80006afc:	0705                	addi	a4,a4,1
    80006afe:	fef497e3          	bne	s1,a5,80006aec <check_substr+0x54>
}
    80006b02:	70a2                	ld	ra,40(sp)
    80006b04:	7402                	ld	s0,32(sp)
    80006b06:	64e2                	ld	s1,24(sp)
    80006b08:	6942                	ld	s2,16(sp)
    80006b0a:	69a2                	ld	s3,8(sp)
    80006b0c:	6145                	addi	sp,sp,48
    80006b0e:	8082                	ret
    return -1;
    80006b10:	557d                	li	a0,-1
    80006b12:	bfc5                	j	80006b02 <check_substr+0x6a>

0000000080006b14 <head_run>:
void head_run(int fd, int numOfLines){
	
	char line[MAX_LINE_LEN];
	int readStatus;

	while(numOfLines--){
    80006b14:	c1d9                	beqz	a1,80006b9a <head_run+0x86>
void head_run(int fd, int numOfLines){
    80006b16:	dd010113          	addi	sp,sp,-560
    80006b1a:	22113423          	sd	ra,552(sp)
    80006b1e:	22813023          	sd	s0,544(sp)
    80006b22:	20913c23          	sd	s1,536(sp)
    80006b26:	21213823          	sd	s2,528(sp)
    80006b2a:	21313423          	sd	s3,520(sp)
    80006b2e:	21413023          	sd	s4,512(sp)
    80006b32:	1c00                	addi	s0,sp,560
    80006b34:	892a                	mv	s2,a0
    80006b36:	0005849b          	sext.w	s1,a1

		readStatus = read_line(fd, line);

		if (readStatus == READ_ERROR){
    80006b3a:	59fd                	li	s3,-1
			break;
		}
		if (readStatus == READ_EOF)
			break;	

		printf("%s",line);
    80006b3c:	00003a17          	auipc	s4,0x3
    80006b40:	e24a0a13          	addi	s4,s4,-476 # 80009960 <syscalls+0x510>
		readStatus = read_line(fd, line);
    80006b44:	dd840593          	addi	a1,s0,-552
    80006b48:	854a                	mv	a0,s2
    80006b4a:	00000097          	auipc	ra,0x0
    80006b4e:	d50080e7          	jalr	-688(ra) # 8000689a <read_line>
		if (readStatus == READ_ERROR){
    80006b52:	01350d63          	beq	a0,s3,80006b6c <head_run+0x58>
		if (readStatus == READ_EOF)
    80006b56:	c11d                	beqz	a0,80006b7c <head_run+0x68>
		printf("%s",line);
    80006b58:	dd840593          	addi	a1,s0,-552
    80006b5c:	8552                	mv	a0,s4
    80006b5e:	ffffa097          	auipc	ra,0xffffa
    80006b62:	a2c080e7          	jalr	-1492(ra) # 8000058a <printf>
	while(numOfLines--){
    80006b66:	34fd                	addiw	s1,s1,-1
    80006b68:	fcf1                	bnez	s1,80006b44 <head_run+0x30>
    80006b6a:	a809                	j	80006b7c <head_run+0x68>
			printf("[ERR] Error reading from the file \n");
    80006b6c:	00003517          	auipc	a0,0x3
    80006b70:	dcc50513          	addi	a0,a0,-564 # 80009938 <syscalls+0x4e8>
    80006b74:	ffffa097          	auipc	ra,0xffffa
    80006b78:	a16080e7          	jalr	-1514(ra) # 8000058a <printf>

	}
}
    80006b7c:	22813083          	ld	ra,552(sp)
    80006b80:	22013403          	ld	s0,544(sp)
    80006b84:	21813483          	ld	s1,536(sp)
    80006b88:	21013903          	ld	s2,528(sp)
    80006b8c:	20813983          	ld	s3,520(sp)
    80006b90:	20013a03          	ld	s4,512(sp)
    80006b94:	23010113          	addi	sp,sp,560
    80006b98:	8082                	ret
    80006b9a:	8082                	ret

0000000080006b9c <uniq_run>:
   repeatedLines: Shows only repeated lines

[OUTPUT]: 

*/
void uniq_run(int fd, char ignoreCase, char showCount, char repeatedLines){
    80006b9c:	ba010113          	addi	sp,sp,-1120
    80006ba0:	44113c23          	sd	ra,1112(sp)
    80006ba4:	44813823          	sd	s0,1104(sp)
    80006ba8:	44913423          	sd	s1,1096(sp)
    80006bac:	45213023          	sd	s2,1088(sp)
    80006bb0:	43313c23          	sd	s3,1080(sp)
    80006bb4:	43413823          	sd	s4,1072(sp)
    80006bb8:	43513423          	sd	s5,1064(sp)
    80006bbc:	43613023          	sd	s6,1056(sp)
    80006bc0:	41713c23          	sd	s7,1048(sp)
    80006bc4:	41813823          	sd	s8,1040(sp)
    80006bc8:	41913423          	sd	s9,1032(sp)
    80006bcc:	41a13023          	sd	s10,1024(sp)
    80006bd0:	3fb13c23          	sd	s11,1016(sp)
    80006bd4:	46010413          	addi	s0,sp,1120
    80006bd8:	89aa                	mv	s3,a0
    80006bda:	8aae                	mv	s5,a1
    80006bdc:	8c32                	mv	s8,a2
    80006bde:	8a36                	mv	s4,a3
  char * line1 = buffer1;
  char * line2 = buffer2;
  
  
  uint64 readStatus;
  readStatus = read_line(fd, line1);
    80006be0:	d9840593          	addi	a1,s0,-616
    80006be4:	00000097          	auipc	ra,0x0
    80006be8:	cb6080e7          	jalr	-842(ra) # 8000689a <read_line>


  if (readStatus == READ_ERROR)
    80006bec:	57fd                	li	a5,-1
    80006bee:	04f50163          	beq	a0,a5,80006c30 <uniq_run+0x94>
    80006bf2:	4b81                	li	s7,0
    printf("[ERR] Error reading from the file ");
  
  else if (readStatus != READ_EOF){
    80006bf4:	ed21                	bnez	a0,80006c4c <uniq_run+0xb0>
          lineCount++;
        }

      }
    }
}
    80006bf6:	45813083          	ld	ra,1112(sp)
    80006bfa:	45013403          	ld	s0,1104(sp)
    80006bfe:	44813483          	ld	s1,1096(sp)
    80006c02:	44013903          	ld	s2,1088(sp)
    80006c06:	43813983          	ld	s3,1080(sp)
    80006c0a:	43013a03          	ld	s4,1072(sp)
    80006c0e:	42813a83          	ld	s5,1064(sp)
    80006c12:	42013b03          	ld	s6,1056(sp)
    80006c16:	41813b83          	ld	s7,1048(sp)
    80006c1a:	41013c03          	ld	s8,1040(sp)
    80006c1e:	40813c83          	ld	s9,1032(sp)
    80006c22:	40013d03          	ld	s10,1024(sp)
    80006c26:	3f813d83          	ld	s11,1016(sp)
    80006c2a:	46010113          	addi	sp,sp,1120
    80006c2e:	8082                	ret
    printf("[ERR] Error reading from the file ");
    80006c30:	00003517          	auipc	a0,0x3
    80006c34:	d3850513          	addi	a0,a0,-712 # 80009968 <syscalls+0x518>
    80006c38:	ffffa097          	auipc	ra,0xffffa
    80006c3c:	952080e7          	jalr	-1710(ra) # 8000058a <printf>
    80006c40:	bf5d                	j	80006bf6 <uniq_run+0x5a>
    80006c42:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006c44:	8926                	mv	s2,s1
    80006c46:	84be                	mv	s1,a5
        lineCount = 1;
    80006c48:	8b6a                	mv	s6,s10
    80006c4a:	a8ed                	j	80006d44 <uniq_run+0x1a8>
    int lineCount=1;
    80006c4c:	4b05                	li	s6,1
  char * line2 = buffer2;
    80006c4e:	ba040493          	addi	s1,s0,-1120
  char * line1 = buffer1;
    80006c52:	d9840913          	addi	s2,s0,-616
        if (readStatus == READ_ERROR){
    80006c56:	5cfd                	li	s9,-1
          if (repeatedLines && !isRepeated)
    80006c58:	4d05                	li	s10,1
              printf("%s",line1);
    80006c5a:	00003d97          	auipc	s11,0x3
    80006c5e:	d06d8d93          	addi	s11,s11,-762 # 80009960 <syscalls+0x510>
    80006c62:	a0cd                	j	80006d44 <uniq_run+0x1a8>
            if (repeatedLines){
    80006c64:	020a0b63          	beqz	s4,80006c9a <uniq_run+0xfe>
                if (isRepeated){
    80006c68:	f80b87e3          	beqz	s7,80006bf6 <uniq_run+0x5a>
                    if (showCount)
    80006c6c:	000c0d63          	beqz	s8,80006c86 <uniq_run+0xea>
                      printf("<%d> %s",lineCount,line1);
    80006c70:	864a                	mv	a2,s2
    80006c72:	85da                	mv	a1,s6
    80006c74:	00003517          	auipc	a0,0x3
    80006c78:	d1c50513          	addi	a0,a0,-740 # 80009990 <syscalls+0x540>
    80006c7c:	ffffa097          	auipc	ra,0xffffa
    80006c80:	90e080e7          	jalr	-1778(ra) # 8000058a <printf>
    80006c84:	bf8d                	j	80006bf6 <uniq_run+0x5a>
                      printf("%s",line1);
    80006c86:	85ca                	mv	a1,s2
    80006c88:	00003517          	auipc	a0,0x3
    80006c8c:	cd850513          	addi	a0,a0,-808 # 80009960 <syscalls+0x510>
    80006c90:	ffffa097          	auipc	ra,0xffffa
    80006c94:	8fa080e7          	jalr	-1798(ra) # 8000058a <printf>
    80006c98:	bfb9                	j	80006bf6 <uniq_run+0x5a>
                if (showCount)
    80006c9a:	000c0d63          	beqz	s8,80006cb4 <uniq_run+0x118>
                  printf("<%d> %s",lineCount,line1);
    80006c9e:	864a                	mv	a2,s2
    80006ca0:	85da                	mv	a1,s6
    80006ca2:	00003517          	auipc	a0,0x3
    80006ca6:	cee50513          	addi	a0,a0,-786 # 80009990 <syscalls+0x540>
    80006caa:	ffffa097          	auipc	ra,0xffffa
    80006cae:	8e0080e7          	jalr	-1824(ra) # 8000058a <printf>
    80006cb2:	b791                	j	80006bf6 <uniq_run+0x5a>
                  printf("%s",line1);
    80006cb4:	85ca                	mv	a1,s2
    80006cb6:	00003517          	auipc	a0,0x3
    80006cba:	caa50513          	addi	a0,a0,-854 # 80009960 <syscalls+0x510>
    80006cbe:	ffffa097          	auipc	ra,0xffffa
    80006cc2:	8cc080e7          	jalr	-1844(ra) # 8000058a <printf>
    80006cc6:	bf05                	j	80006bf6 <uniq_run+0x5a>
          printf("[ERR] Error reading from the file");
    80006cc8:	00003517          	auipc	a0,0x3
    80006ccc:	cd050513          	addi	a0,a0,-816 # 80009998 <syscalls+0x548>
    80006cd0:	ffffa097          	auipc	ra,0xffffa
    80006cd4:	8ba080e7          	jalr	-1862(ra) # 8000058a <printf>
          break;
    80006cd8:	bf39                	j	80006bf6 <uniq_run+0x5a>
          compareStatus = compare_str_ic(line1, line2);
    80006cda:	85a6                	mv	a1,s1
    80006cdc:	854a                	mv	a0,s2
    80006cde:	00000097          	auipc	ra,0x0
    80006ce2:	d5e080e7          	jalr	-674(ra) # 80006a3c <compare_str_ic>
    80006ce6:	a041                	j	80006d66 <uniq_run+0x1ca>
                  printf("%s",line1);
    80006ce8:	85ca                	mv	a1,s2
    80006cea:	856e                	mv	a0,s11
    80006cec:	ffffa097          	auipc	ra,0xffffa
    80006cf0:	89e080e7          	jalr	-1890(ra) # 8000058a <printf>
        lineCount = 1;
    80006cf4:	8b5e                	mv	s6,s7
                  printf("%s",line1);
    80006cf6:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006cf8:	8926                	mv	s2,s1
                  printf("%s",line1);
    80006cfa:	84be                	mv	s1,a5
        isRepeated = 0 ;
    80006cfc:	4b81                	li	s7,0
    80006cfe:	a099                	j	80006d44 <uniq_run+0x1a8>
            if (showCount)
    80006d00:	020c0263          	beqz	s8,80006d24 <uniq_run+0x188>
              printf("<%d> %s",lineCount,line1);
    80006d04:	864a                	mv	a2,s2
    80006d06:	85da                	mv	a1,s6
    80006d08:	00003517          	auipc	a0,0x3
    80006d0c:	c8850513          	addi	a0,a0,-888 # 80009990 <syscalls+0x540>
    80006d10:	ffffa097          	auipc	ra,0xffffa
    80006d14:	87a080e7          	jalr	-1926(ra) # 8000058a <printf>
    80006d18:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006d1a:	8926                	mv	s2,s1
    80006d1c:	84be                	mv	s1,a5
        isRepeated = 0 ;
    80006d1e:	4b81                	li	s7,0
        lineCount = 1;
    80006d20:	8b6a                	mv	s6,s10
    80006d22:	a00d                	j	80006d44 <uniq_run+0x1a8>
              printf("%s",line1);
    80006d24:	85ca                	mv	a1,s2
    80006d26:	856e                	mv	a0,s11
    80006d28:	ffffa097          	auipc	ra,0xffffa
    80006d2c:	862080e7          	jalr	-1950(ra) # 8000058a <printf>
    80006d30:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006d32:	8926                	mv	s2,s1
              printf("%s",line1);
    80006d34:	84be                	mv	s1,a5
        isRepeated = 0 ;
    80006d36:	4b81                	li	s7,0
        lineCount = 1;
    80006d38:	8b6a                	mv	s6,s10
    80006d3a:	a029                	j	80006d44 <uniq_run+0x1a8>
          if (repeatedLines && !isRepeated)
    80006d3c:	000a0363          	beqz	s4,80006d42 <uniq_run+0x1a6>
    80006d40:	8bea                	mv	s7,s10
          lineCount++;
    80006d42:	2b05                	addiw	s6,s6,1
        readStatus = read_line(fd, line2);
    80006d44:	85a6                	mv	a1,s1
    80006d46:	854e                	mv	a0,s3
    80006d48:	00000097          	auipc	ra,0x0
    80006d4c:	b52080e7          	jalr	-1198(ra) # 8000689a <read_line>
        if (readStatus == READ_EOF){
    80006d50:	d911                	beqz	a0,80006c64 <uniq_run+0xc8>
        if (readStatus == READ_ERROR){
    80006d52:	f7950be3          	beq	a0,s9,80006cc8 <uniq_run+0x12c>
        if (!ignoreCase)
    80006d56:	f80a92e3          	bnez	s5,80006cda <uniq_run+0x13e>
          compareStatus = compare_str(line1, line2);
    80006d5a:	85a6                	mv	a1,s1
    80006d5c:	854a                	mv	a0,s2
    80006d5e:	00000097          	auipc	ra,0x0
    80006d62:	cb0080e7          	jalr	-848(ra) # 80006a0e <compare_str>
        if (compareStatus != 0){ 
    80006d66:	d979                	beqz	a0,80006d3c <uniq_run+0x1a0>
          if (repeatedLines){
    80006d68:	f80a0ce3          	beqz	s4,80006d00 <uniq_run+0x164>
            if (isRepeated){
    80006d6c:	ec0b8be3          	beqz	s7,80006c42 <uniq_run+0xa6>
                if (showCount)
    80006d70:	f60c0ce3          	beqz	s8,80006ce8 <uniq_run+0x14c>
                  printf("<%d> %s",lineCount,line1);
    80006d74:	864a                	mv	a2,s2
    80006d76:	85da                	mv	a1,s6
    80006d78:	00003517          	auipc	a0,0x3
    80006d7c:	c1850513          	addi	a0,a0,-1000 # 80009990 <syscalls+0x540>
    80006d80:	ffffa097          	auipc	ra,0xffffa
    80006d84:	80a080e7          	jalr	-2038(ra) # 8000058a <printf>
        lineCount = 1;
    80006d88:	8b5e                	mv	s6,s7
    80006d8a:	87ca                	mv	a5,s2
        swap_pointers(line1, line2);
    80006d8c:	8926                	mv	s2,s1
    80006d8e:	84be                	mv	s1,a5
        isRepeated = 0 ;
    80006d90:	4b81                	li	s7,0
    80006d92:	bf4d                	j	80006d44 <uniq_run+0x1a8>

0000000080006d94 <get_process_status>:


/*
Prints the status of all the processes in the system
*/
void get_process_status(int tpid, int tppid, int tstatus, uint64 pName){
    80006d94:	7151                	addi	sp,sp,-240
    80006d96:	f586                	sd	ra,232(sp)
    80006d98:	f1a2                	sd	s0,224(sp)
    80006d9a:	eda6                	sd	s1,216(sp)
    80006d9c:	e9ca                	sd	s2,208(sp)
    80006d9e:	e5ce                	sd	s3,200(sp)
    80006da0:	e1d2                	sd	s4,192(sp)
    80006da2:	fd56                	sd	s5,184(sp)
    80006da4:	f95a                	sd	s6,176(sp)
    80006da6:	f55e                	sd	s7,168(sp)
    80006da8:	f162                	sd	s8,160(sp)
    80006daa:	ed66                	sd	s9,152(sp)
    80006dac:	e96a                	sd	s10,144(sp)
    80006dae:	e56e                	sd	s11,136(sp)
    80006db0:	1980                	addi	s0,sp,240
    80006db2:	8aaa                	mv	s5,a0
    80006db4:	8bae                	mv	s7,a1
    80006db6:	8d32                	mv	s10,a2
    80006db8:	8c36                	mv	s8,a3


	struct proc *pp;
	int havekids, pid;
	struct proc *p = myproc();
    80006dba:	ffffb097          	auipc	ra,0xffffb
    80006dbe:	bf2080e7          	jalr	-1038(ra) # 800019ac <myproc>
	int foundPID = 0;

	// For process name specific option
	int namesIDx = 0;

	acquire(&wait_lock);
    80006dc2:	0000b517          	auipc	a0,0xb
    80006dc6:	08650513          	addi	a0,a0,134 # 80011e48 <wait_lock>
    80006dca:	ffffa097          	auipc	ra,0xffffa
    80006dce:	e0c080e7          	jalr	-500(ra) # 80000bd6 <acquire>


	printf("PID\tPPID\t  STAT\t          STIME\t\t         ETIME\t\t     TTIME\t     NAME\n");
    80006dd2:	00003517          	auipc	a0,0x3
    80006dd6:	bee50513          	addi	a0,a0,-1042 # 800099c0 <syscalls+0x570>
    80006dda:	ffff9097          	auipc	ra,0xffff9
    80006dde:	7b0080e7          	jalr	1968(ra) # 8000058a <printf>
	printf("---\t----\t--------   --------------------\t-------------------- --------------------  ---------\n");
    80006de2:	00003517          	auipc	a0,0x3
    80006de6:	c2650513          	addi	a0,a0,-986 # 80009a08 <syscalls+0x5b8>
    80006dea:	ffff9097          	auipc	ra,0xffff9
    80006dee:	7a0080e7          	jalr	1952(ra) # 8000058a <printf>


	for (int i=0;i<NPROC;i++){
    80006df2:	0000b497          	auipc	s1,0xb
    80006df6:	5c648493          	addi	s1,s1,1478 # 800123b8 <proc+0x158>
    80006dfa:	00011c97          	auipc	s9,0x11
    80006dfe:	5bec8c93          	addi	s9,s9,1470 # 800183b8 <bcache+0x140>
	int foundPID = 0;
    80006e02:	4d81                	li	s11,0
			tick2time(p->execTime.endTime*100);
			tick2time(p->execTime.totalTime*100);
		}
		else if (p->state == USED){
			printf("%d\t %d\t%s     ",p->pid, parentID, "USED");
			tick2time(p->execTime.creationTime*100);
    80006e04:	6b3d                	lui	s6,0xf
    80006e06:	a60b0b13          	addi	s6,s6,-1440 # ea60 <_entry-0x7fff15a0>
		if (tstatus >= 0 && p->state != tstatus){
    80006e0a:	000d079b          	sext.w	a5,s10
    80006e0e:	f0f43823          	sd	a5,-240(s0)
    80006e12:	a231                	j	80006f1e <get_process_status+0x18a>
			release(&p->lock);
    80006e14:	854a                	mv	a0,s2
    80006e16:	ffffa097          	auipc	ra,0xffffa
    80006e1a:	e74080e7          	jalr	-396(ra) # 80000c8a <release>
			foundPID = 1;
    80006e1e:	4d85                	li	s11,1
			continue;
    80006e20:	a8dd                	j	80006f16 <get_process_status+0x182>
			fetchstr(pName, processName, 100);
    80006e22:	06400613          	li	a2,100
    80006e26:	f2840593          	addi	a1,s0,-216
    80006e2a:	8562                	mv	a0,s8
    80006e2c:	ffffc097          	auipc	ra,0xffffc
    80006e30:	c6e080e7          	jalr	-914(ra) # 80002a9a <fetchstr>
			if (check_substr(processName, p->name)==-1){
    80006e34:	85a6                	mv	a1,s1
    80006e36:	f2840513          	addi	a0,s0,-216
    80006e3a:	00000097          	auipc	ra,0x0
    80006e3e:	c5e080e7          	jalr	-930(ra) # 80006a98 <check_substr>
    80006e42:	57fd                	li	a5,-1
    80006e44:	0ef51c63          	bne	a0,a5,80006f3c <get_process_status+0x1a8>
				release(&p->lock);
    80006e48:	854a                	mv	a0,s2
    80006e4a:	ffffa097          	auipc	ra,0xffffa
    80006e4e:	e40080e7          	jalr	-448(ra) # 80000c8a <release>
				continue;
    80006e52:	a0d1                	j	80006f16 <get_process_status+0x182>
			release(&p->lock);
    80006e54:	854a                	mv	a0,s2
    80006e56:	ffffa097          	auipc	ra,0xffffa
    80006e5a:	e34080e7          	jalr	-460(ra) # 80000c8a <release>
			continue;
    80006e5e:	a865                	j	80006f16 <get_process_status+0x182>
			release(&p->lock);
    80006e60:	854a                	mv	a0,s2
    80006e62:	ffffa097          	auipc	ra,0xffffa
    80006e66:	e28080e7          	jalr	-472(ra) # 80000c8a <release>
			continue;
    80006e6a:	a075                	j	80006f16 <get_process_status+0x182>
			printf("%d\t %d\t%s     ",p->pid, parentID, "Sleeping");
    80006e6c:	00003697          	auipc	a3,0x3
    80006e70:	bfc68693          	addi	a3,a3,-1028 # 80009a68 <syscalls+0x618>
    80006e74:	8652                	mv	a2,s4
    80006e76:	ed89a583          	lw	a1,-296(s3)
    80006e7a:	00003517          	auipc	a0,0x3
    80006e7e:	bfe50513          	addi	a0,a0,-1026 # 80009a78 <syscalls+0x628>
    80006e82:	ffff9097          	auipc	ra,0xffff9
    80006e86:	708080e7          	jalr	1800(ra) # 8000058a <printf>
			tick2time(p->execTime.creationTime*100);
    80006e8a:	0109b583          	ld	a1,16(s3)
    80006e8e:	06400793          	li	a5,100
    80006e92:	02b785b3          	mul	a1,a5,a1
    80006e96:	0365f633          	remu	a2,a1,s6
    80006e9a:	3e800a13          	li	s4,1000
    80006e9e:	034676b3          	remu	a3,a2,s4
    80006ea2:	03465633          	divu	a2,a2,s4
    80006ea6:	0365d5b3          	divu	a1,a1,s6
    80006eaa:	00003517          	auipc	a0,0x3
    80006eae:	bde50513          	addi	a0,a0,-1058 # 80009a88 <syscalls+0x638>
    80006eb2:	ffff9097          	auipc	ra,0xffff9
    80006eb6:	6d8080e7          	jalr	1752(ra) # 8000058a <printf>
			printf("      In progress        ");
    80006eba:	00003517          	auipc	a0,0x3
    80006ebe:	be650513          	addi	a0,a0,-1050 # 80009aa0 <syscalls+0x650>
    80006ec2:	ffff9097          	auipc	ra,0xffff9
    80006ec6:	6c8080e7          	jalr	1736(ra) # 8000058a <printf>
			tick2time(time*100);
    80006eca:	f1843703          	ld	a4,-232(s0)
    80006ece:	06400793          	li	a5,100
    80006ed2:	02f705b3          	mul	a1,a4,a5
    80006ed6:	0365f633          	remu	a2,a1,s6
    80006eda:	034676b3          	remu	a3,a2,s4
    80006ede:	03465633          	divu	a2,a2,s4
    80006ee2:	0365d5b3          	divu	a1,a1,s6
    80006ee6:	00003517          	auipc	a0,0x3
    80006eea:	ba250513          	addi	a0,a0,-1118 # 80009a88 <syscalls+0x638>
    80006eee:	ffff9097          	auipc	ra,0xffff9
    80006ef2:	69c080e7          	jalr	1692(ra) # 8000058a <printf>
			printf("     %s\n",p->name);
    80006ef6:	85ce                	mv	a1,s3
    80006ef8:	00003517          	auipc	a0,0x3
    80006efc:	bc850513          	addi	a0,a0,-1080 # 80009ac0 <syscalls+0x670>
    80006f00:	ffff9097          	auipc	ra,0xffff9
    80006f04:	68a080e7          	jalr	1674(ra) # 8000058a <printf>
			tick2time(p->execTime.endTime*100);
			tick2time(p->execTime.totalTime*100);
		}

		release(&p->lock);
    80006f08:	854a                	mv	a0,s2
    80006f0a:	ffffa097          	auipc	ra,0xffffa
    80006f0e:	d80080e7          	jalr	-640(ra) # 80000c8a <release>

		if (foundPID){
    80006f12:	300d9563          	bnez	s11,8000721c <get_process_status+0x488>
	for (int i=0;i<NPROC;i++){
    80006f16:	18048493          	addi	s1,s1,384
    80006f1a:	31948163          	beq	s1,s9,8000721c <get_process_status+0x488>
		acquire(&p->lock);
    80006f1e:	ea848913          	addi	s2,s1,-344
    80006f22:	854a                	mv	a0,s2
    80006f24:	ffffa097          	auipc	ra,0xffffa
    80006f28:	cb2080e7          	jalr	-846(ra) # 80000bd6 <acquire>
		if (tpid >= 0 &&  tpid != p->pid){
    80006f2c:	000ac663          	bltz	s5,80006f38 <get_process_status+0x1a4>
    80006f30:	ed84a783          	lw	a5,-296(s1)
    80006f34:	ef5790e3          	bne	a5,s5,80006e14 <get_process_status+0x80>
		if (pName!=0){
    80006f38:	ee0c15e3          	bnez	s8,80006e22 <get_process_status+0x8e>
		int parentID = (p->parent) ? p->parent->pid : 0;
    80006f3c:	89a6                	mv	s3,s1
    80006f3e:	ee04b783          	ld	a5,-288(s1)
    80006f42:	4a01                	li	s4,0
    80006f44:	c399                	beqz	a5,80006f4a <get_process_status+0x1b6>
    80006f46:	0307aa03          	lw	s4,48(a5)
		if (tppid >=0 && tppid!=parentID){
    80006f4a:	000bc463          	bltz	s7,80006f52 <get_process_status+0x1be>
    80006f4e:	f17a13e3          	bne	s4,s7,80006e54 <get_process_status+0xc0>
		if (tstatus >= 0 && p->state != tstatus){
    80006f52:	000d4863          	bltz	s10,80006f62 <get_process_status+0x1ce>
    80006f56:	ec09a783          	lw	a5,-320(s3)
    80006f5a:	f1043703          	ld	a4,-240(s0)
    80006f5e:	f0e791e3          	bne	a5,a4,80006e60 <get_process_status+0xcc>
		time_t time = sys_uptime();
    80006f62:	ffffc097          	auipc	ra,0xffffc
    80006f66:	12c080e7          	jalr	300(ra) # 8000308e <sys_uptime>
    80006f6a:	f0a43c23          	sd	a0,-232(s0)
		if (p->state == SLEEPING){
    80006f6e:	ec09a783          	lw	a5,-320(s3)
    80006f72:	4709                	li	a4,2
    80006f74:	eee78ce3          	beq	a5,a4,80006e6c <get_process_status+0xd8>
		else if (p->state == RUNNABLE){
    80006f78:	470d                	li	a4,3
    80006f7a:	0ae78f63          	beq	a5,a4,80007038 <get_process_status+0x2a4>
		else if (p->state == RUNNING){
    80006f7e:	4711                	li	a4,4
    80006f80:	14e78b63          	beq	a5,a4,800070d6 <get_process_status+0x342>
		else if (p->state == ZOMBIE ){
    80006f84:	4715                	li	a4,5
    80006f86:	1ee78763          	beq	a5,a4,80007174 <get_process_status+0x3e0>
		else if (p->state == USED){
    80006f8a:	4705                	li	a4,1
    80006f8c:	f6e79ee3          	bne	a5,a4,80006f08 <get_process_status+0x174>
			printf("%d\t %d\t%s     ",p->pid, parentID, "USED");
    80006f90:	00003697          	auipc	a3,0x3
    80006f94:	b7868693          	addi	a3,a3,-1160 # 80009b08 <syscalls+0x6b8>
    80006f98:	8652                	mv	a2,s4
    80006f9a:	ed89a583          	lw	a1,-296(s3)
    80006f9e:	00003517          	auipc	a0,0x3
    80006fa2:	ada50513          	addi	a0,a0,-1318 # 80009a78 <syscalls+0x628>
    80006fa6:	ffff9097          	auipc	ra,0xffff9
    80006faa:	5e4080e7          	jalr	1508(ra) # 8000058a <printf>
			tick2time(p->execTime.creationTime*100);
    80006fae:	0109b583          	ld	a1,16(s3)
    80006fb2:	06400793          	li	a5,100
    80006fb6:	02b785b3          	mul	a1,a5,a1
    80006fba:	0365f633          	remu	a2,a1,s6
    80006fbe:	3e800a13          	li	s4,1000
    80006fc2:	034676b3          	remu	a3,a2,s4
    80006fc6:	03465633          	divu	a2,a2,s4
    80006fca:	0365d5b3          	divu	a1,a1,s6
    80006fce:	00003517          	auipc	a0,0x3
    80006fd2:	aba50513          	addi	a0,a0,-1350 # 80009a88 <syscalls+0x638>
    80006fd6:	ffff9097          	auipc	ra,0xffff9
    80006fda:	5b4080e7          	jalr	1460(ra) # 8000058a <printf>
			tick2time(p->execTime.endTime*100);
    80006fde:	0189b583          	ld	a1,24(s3)
    80006fe2:	06400793          	li	a5,100
    80006fe6:	02b785b3          	mul	a1,a5,a1
    80006fea:	0365f633          	remu	a2,a1,s6
    80006fee:	034676b3          	remu	a3,a2,s4
    80006ff2:	03465633          	divu	a2,a2,s4
    80006ff6:	0365d5b3          	divu	a1,a1,s6
    80006ffa:	00003517          	auipc	a0,0x3
    80006ffe:	a8e50513          	addi	a0,a0,-1394 # 80009a88 <syscalls+0x638>
    80007002:	ffff9097          	auipc	ra,0xffff9
    80007006:	588080e7          	jalr	1416(ra) # 8000058a <printf>
			tick2time(p->execTime.totalTime*100);
    8000700a:	0209b783          	ld	a5,32(s3)
    8000700e:	06400713          	li	a4,100
    80007012:	02f705b3          	mul	a1,a4,a5
    80007016:	0365f633          	remu	a2,a1,s6
    8000701a:	034676b3          	remu	a3,a2,s4
    8000701e:	03465633          	divu	a2,a2,s4
    80007022:	0365d5b3          	divu	a1,a1,s6
    80007026:	00003517          	auipc	a0,0x3
    8000702a:	a6250513          	addi	a0,a0,-1438 # 80009a88 <syscalls+0x638>
    8000702e:	ffff9097          	auipc	ra,0xffff9
    80007032:	55c080e7          	jalr	1372(ra) # 8000058a <printf>
    80007036:	bdc9                	j	80006f08 <get_process_status+0x174>
			printf("%d\t %d\t%s     ",p->pid, parentID, "Ready");
    80007038:	00003697          	auipc	a3,0x3
    8000703c:	a9868693          	addi	a3,a3,-1384 # 80009ad0 <syscalls+0x680>
    80007040:	8652                	mv	a2,s4
    80007042:	ed89a583          	lw	a1,-296(s3)
    80007046:	00003517          	auipc	a0,0x3
    8000704a:	a3250513          	addi	a0,a0,-1486 # 80009a78 <syscalls+0x628>
    8000704e:	ffff9097          	auipc	ra,0xffff9
    80007052:	53c080e7          	jalr	1340(ra) # 8000058a <printf>
			tick2time(p->execTime.creationTime*100);
    80007056:	0109b583          	ld	a1,16(s3)
    8000705a:	06400793          	li	a5,100
    8000705e:	02b785b3          	mul	a1,a5,a1
    80007062:	0365f633          	remu	a2,a1,s6
    80007066:	3e800a13          	li	s4,1000
    8000706a:	034676b3          	remu	a3,a2,s4
    8000706e:	03465633          	divu	a2,a2,s4
    80007072:	0365d5b3          	divu	a1,a1,s6
    80007076:	00003517          	auipc	a0,0x3
    8000707a:	a1250513          	addi	a0,a0,-1518 # 80009a88 <syscalls+0x638>
    8000707e:	ffff9097          	auipc	ra,0xffff9
    80007082:	50c080e7          	jalr	1292(ra) # 8000058a <printf>
			printf("      In progress       ");
    80007086:	00003517          	auipc	a0,0x3
    8000708a:	a5250513          	addi	a0,a0,-1454 # 80009ad8 <syscalls+0x688>
    8000708e:	ffff9097          	auipc	ra,0xffff9
    80007092:	4fc080e7          	jalr	1276(ra) # 8000058a <printf>
			tick2time(time*100);
    80007096:	f1843703          	ld	a4,-232(s0)
    8000709a:	06400793          	li	a5,100
    8000709e:	02f705b3          	mul	a1,a4,a5
    800070a2:	0365f633          	remu	a2,a1,s6
    800070a6:	034676b3          	remu	a3,a2,s4
    800070aa:	03465633          	divu	a2,a2,s4
    800070ae:	0365d5b3          	divu	a1,a1,s6
    800070b2:	00003517          	auipc	a0,0x3
    800070b6:	9d650513          	addi	a0,a0,-1578 # 80009a88 <syscalls+0x638>
    800070ba:	ffff9097          	auipc	ra,0xffff9
    800070be:	4d0080e7          	jalr	1232(ra) # 8000058a <printf>
			printf("     %s\n",p->name);
    800070c2:	85ce                	mv	a1,s3
    800070c4:	00003517          	auipc	a0,0x3
    800070c8:	9fc50513          	addi	a0,a0,-1540 # 80009ac0 <syscalls+0x670>
    800070cc:	ffff9097          	auipc	ra,0xffff9
    800070d0:	4be080e7          	jalr	1214(ra) # 8000058a <printf>
    800070d4:	bd15                	j	80006f08 <get_process_status+0x174>
			printf("%d\t %d\t%s     ",p->pid, parentID, "Running");
    800070d6:	00003697          	auipc	a3,0x3
    800070da:	a2268693          	addi	a3,a3,-1502 # 80009af8 <syscalls+0x6a8>
    800070de:	8652                	mv	a2,s4
    800070e0:	ed89a583          	lw	a1,-296(s3)
    800070e4:	00003517          	auipc	a0,0x3
    800070e8:	99450513          	addi	a0,a0,-1644 # 80009a78 <syscalls+0x628>
    800070ec:	ffff9097          	auipc	ra,0xffff9
    800070f0:	49e080e7          	jalr	1182(ra) # 8000058a <printf>
			tick2time(p->execTime.creationTime*100);
    800070f4:	0109b583          	ld	a1,16(s3)
    800070f8:	06400793          	li	a5,100
    800070fc:	02b785b3          	mul	a1,a5,a1
    80007100:	0365f633          	remu	a2,a1,s6
    80007104:	3e800a13          	li	s4,1000
    80007108:	034676b3          	remu	a3,a2,s4
    8000710c:	03465633          	divu	a2,a2,s4
    80007110:	0365d5b3          	divu	a1,a1,s6
    80007114:	00003517          	auipc	a0,0x3
    80007118:	97450513          	addi	a0,a0,-1676 # 80009a88 <syscalls+0x638>
    8000711c:	ffff9097          	auipc	ra,0xffff9
    80007120:	46e080e7          	jalr	1134(ra) # 8000058a <printf>
			printf("      In progress        ");
    80007124:	00003517          	auipc	a0,0x3
    80007128:	97c50513          	addi	a0,a0,-1668 # 80009aa0 <syscalls+0x650>
    8000712c:	ffff9097          	auipc	ra,0xffff9
    80007130:	45e080e7          	jalr	1118(ra) # 8000058a <printf>
			tick2time(time*100);
    80007134:	f1843703          	ld	a4,-232(s0)
    80007138:	06400793          	li	a5,100
    8000713c:	02f705b3          	mul	a1,a4,a5
    80007140:	0365f633          	remu	a2,a1,s6
    80007144:	034676b3          	remu	a3,a2,s4
    80007148:	03465633          	divu	a2,a2,s4
    8000714c:	0365d5b3          	divu	a1,a1,s6
    80007150:	00003517          	auipc	a0,0x3
    80007154:	93850513          	addi	a0,a0,-1736 # 80009a88 <syscalls+0x638>
    80007158:	ffff9097          	auipc	ra,0xffff9
    8000715c:	432080e7          	jalr	1074(ra) # 8000058a <printf>
			printf("     %s\n",p->name);
    80007160:	85ce                	mv	a1,s3
    80007162:	00003517          	auipc	a0,0x3
    80007166:	95e50513          	addi	a0,a0,-1698 # 80009ac0 <syscalls+0x670>
    8000716a:	ffff9097          	auipc	ra,0xffff9
    8000716e:	420080e7          	jalr	1056(ra) # 8000058a <printf>
    80007172:	bb59                	j	80006f08 <get_process_status+0x174>
			printf("%d\t %d\t%s     ",p->pid, parentID, "ZOMBIE");
    80007174:	00003697          	auipc	a3,0x3
    80007178:	98c68693          	addi	a3,a3,-1652 # 80009b00 <syscalls+0x6b0>
    8000717c:	8652                	mv	a2,s4
    8000717e:	ed89a583          	lw	a1,-296(s3)
    80007182:	00003517          	auipc	a0,0x3
    80007186:	8f650513          	addi	a0,a0,-1802 # 80009a78 <syscalls+0x628>
    8000718a:	ffff9097          	auipc	ra,0xffff9
    8000718e:	400080e7          	jalr	1024(ra) # 8000058a <printf>
			tick2time(p->execTime.creationTime*100);
    80007192:	0109b583          	ld	a1,16(s3)
    80007196:	06400793          	li	a5,100
    8000719a:	02b785b3          	mul	a1,a5,a1
    8000719e:	0365f633          	remu	a2,a1,s6
    800071a2:	3e800a13          	li	s4,1000
    800071a6:	034676b3          	remu	a3,a2,s4
    800071aa:	03465633          	divu	a2,a2,s4
    800071ae:	0365d5b3          	divu	a1,a1,s6
    800071b2:	00003517          	auipc	a0,0x3
    800071b6:	8d650513          	addi	a0,a0,-1834 # 80009a88 <syscalls+0x638>
    800071ba:	ffff9097          	auipc	ra,0xffff9
    800071be:	3d0080e7          	jalr	976(ra) # 8000058a <printf>
			tick2time(p->execTime.endTime*100);
    800071c2:	0189b583          	ld	a1,24(s3)
    800071c6:	06400793          	li	a5,100
    800071ca:	02b785b3          	mul	a1,a5,a1
    800071ce:	0365f633          	remu	a2,a1,s6
    800071d2:	034676b3          	remu	a3,a2,s4
    800071d6:	03465633          	divu	a2,a2,s4
    800071da:	0365d5b3          	divu	a1,a1,s6
    800071de:	00003517          	auipc	a0,0x3
    800071e2:	8aa50513          	addi	a0,a0,-1878 # 80009a88 <syscalls+0x638>
    800071e6:	ffff9097          	auipc	ra,0xffff9
    800071ea:	3a4080e7          	jalr	932(ra) # 8000058a <printf>
			tick2time(p->execTime.totalTime*100);
    800071ee:	0209b783          	ld	a5,32(s3)
    800071f2:	06400713          	li	a4,100
    800071f6:	02f705b3          	mul	a1,a4,a5
    800071fa:	0365f633          	remu	a2,a1,s6
    800071fe:	034676b3          	remu	a3,a2,s4
    80007202:	03465633          	divu	a2,a2,s4
    80007206:	0365d5b3          	divu	a1,a1,s6
    8000720a:	00003517          	auipc	a0,0x3
    8000720e:	87e50513          	addi	a0,a0,-1922 # 80009a88 <syscalls+0x638>
    80007212:	ffff9097          	auipc	ra,0xffff9
    80007216:	378080e7          	jalr	888(ra) # 8000058a <printf>
    8000721a:	b1fd                	j	80006f08 <get_process_status+0x174>
			break;
		}
	}
	release(&wait_lock);
    8000721c:	0000b517          	auipc	a0,0xb
    80007220:	c2c50513          	addi	a0,a0,-980 # 80011e48 <wait_lock>
    80007224:	ffffa097          	auipc	ra,0xffffa
    80007228:	a66080e7          	jalr	-1434(ra) # 80000c8a <release>
}
    8000722c:	70ae                	ld	ra,232(sp)
    8000722e:	740e                	ld	s0,224(sp)
    80007230:	64ee                	ld	s1,216(sp)
    80007232:	694e                	ld	s2,208(sp)
    80007234:	69ae                	ld	s3,200(sp)
    80007236:	6a0e                	ld	s4,192(sp)
    80007238:	7aea                	ld	s5,184(sp)
    8000723a:	7b4a                	ld	s6,176(sp)
    8000723c:	7baa                	ld	s7,168(sp)
    8000723e:	7c0a                	ld	s8,160(sp)
    80007240:	6cea                	ld	s9,152(sp)
    80007242:	6d4a                	ld	s10,144(sp)
    80007244:	6daa                	ld	s11,136(sp)
    80007246:	616d                	addi	sp,sp,240
    80007248:	8082                	ret

000000008000724a <freeproc>:
extern struct proc proc[NPROC];
extern struct spinlock wait_lock;

extern uint64 sys_uptime(void);

void freeproc(struct proc *p){
    8000724a:	1101                	addi	sp,sp,-32
    8000724c:	ec06                	sd	ra,24(sp)
    8000724e:	e822                	sd	s0,16(sp)
    80007250:	e426                	sd	s1,8(sp)
    80007252:	1000                	addi	s0,sp,32
    80007254:	84aa                	mv	s1,a0

  if(p->trapframe)
    80007256:	6d28                	ld	a0,88(a0)
    80007258:	c509                	beqz	a0,80007262 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000725a:	ffff9097          	auipc	ra,0xffff9
    8000725e:	78e080e7          	jalr	1934(ra) # 800009e8 <kfree>
  p->trapframe = 0;
    80007262:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80007266:	68a8                	ld	a0,80(s1)
    80007268:	c511                	beqz	a0,80007274 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000726a:	64ac                	ld	a1,72(s1)
    8000726c:	ffffb097          	auipc	ra,0xffffb
    80007270:	8a0080e7          	jalr	-1888(ra) # 80001b0c <proc_freepagetable>
  p->pagetable = 0;
    80007274:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80007278:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000727c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80007280:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80007284:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80007288:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000728c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80007290:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80007294:	0004ac23          	sw	zero,24(s1)
}
    80007298:	60e2                	ld	ra,24(sp)
    8000729a:	6442                	ld	s0,16(sp)
    8000729c:	64a2                	ld	s1,8(sp)
    8000729e:	6105                	addi	sp,sp,32
    800072a0:	8082                	ret

00000000800072a2 <get_process_time>:



int get_process_time(int tpid, uint64 uaddr, uint64 addr){
    800072a2:	711d                	addi	sp,sp,-96
    800072a4:	ec86                	sd	ra,88(sp)
    800072a6:	e8a2                	sd	s0,80(sp)
    800072a8:	e4a6                	sd	s1,72(sp)
    800072aa:	e0ca                	sd	s2,64(sp)
    800072ac:	fc4e                	sd	s3,56(sp)
    800072ae:	f852                	sd	s4,48(sp)
    800072b0:	f456                	sd	s5,40(sp)
    800072b2:	f05a                	sd	s6,32(sp)
    800072b4:	ec5e                	sd	s7,24(sp)
    800072b6:	e862                	sd	s8,16(sp)
    800072b8:	e466                	sd	s9,8(sp)
    800072ba:	e06a                	sd	s10,0(sp)
    800072bc:	1080                	addi	s0,sp,96
    800072be:	8baa                	mv	s7,a0
    800072c0:	8c2e                	mv	s8,a1
    800072c2:	8b32                	mv	s6,a2

	struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();
    800072c4:	ffffa097          	auipc	ra,0xffffa
    800072c8:	6e8080e7          	jalr	1768(ra) # 800019ac <myproc>
    800072cc:	892a                	mv	s2,a0

  acquire(&wait_lock);
    800072ce:	0000b517          	auipc	a0,0xb
    800072d2:	b7a50513          	addi	a0,a0,-1158 # 80011e48 <wait_lock>
    800072d6:	ffffa097          	auipc	ra,0xffffa
    800072da:	900080e7          	jalr	-1792(ra) # 80000bd6 <acquire>

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    800072de:	4c81                	li	s9,0
      if(pp->parent == p){
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);

        havekids = 1;
        if(pp->state == ZOMBIE){
    800072e0:	4a15                	li	s4,5
        havekids = 1;
    800072e2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800072e4:	00011997          	auipc	s3,0x11
    800072e8:	f7c98993          	addi	s3,s3,-132 # 80018260 <tickslock>
      release(&wait_lock);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800072ec:	0000bd17          	auipc	s10,0xb
    800072f0:	b5cd0d13          	addi	s10,s10,-1188 # 80011e48 <wait_lock>
    havekids = 0;
    800072f4:	8766                	mv	a4,s9
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800072f6:	0000b497          	auipc	s1,0xb
    800072fa:	f6a48493          	addi	s1,s1,-150 # 80012260 <proc>
    800072fe:	a04d                	j	800073a0 <get_process_time+0xfe>
          pid = pp->pid;
    80007300:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80007304:	020b1863          	bnez	s6,80007334 <get_process_time+0x92>
          if (pp->pid == tpid){
    80007308:	589c                	lw	a5,48(s1)
    8000730a:	07778063          	beq	a5,s7,8000736a <get_process_time+0xc8>
          freeproc(pp);
    8000730e:	8526                	mv	a0,s1
    80007310:	00000097          	auipc	ra,0x0
    80007314:	f3a080e7          	jalr	-198(ra) # 8000724a <freeproc>
          release(&pp->lock);
    80007318:	8526                	mv	a0,s1
    8000731a:	ffffa097          	auipc	ra,0xffffa
    8000731e:	970080e7          	jalr	-1680(ra) # 80000c8a <release>
          release(&wait_lock);
    80007322:	0000b517          	auipc	a0,0xb
    80007326:	b2650513          	addi	a0,a0,-1242 # 80011e48 <wait_lock>
    8000732a:	ffffa097          	auipc	ra,0xffffa
    8000732e:	960080e7          	jalr	-1696(ra) # 80000c8a <release>
          return pid;
    80007332:	a0c9                	j	800073f4 <get_process_time+0x152>
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80007334:	4691                	li	a3,4
    80007336:	02c48613          	addi	a2,s1,44
    8000733a:	85da                	mv	a1,s6
    8000733c:	05093503          	ld	a0,80(s2)
    80007340:	ffffa097          	auipc	ra,0xffffa
    80007344:	32c080e7          	jalr	812(ra) # 8000166c <copyout>
    80007348:	fc0550e3          	bgez	a0,80007308 <get_process_time+0x66>
            release(&pp->lock);
    8000734c:	8526                	mv	a0,s1
    8000734e:	ffffa097          	auipc	ra,0xffffa
    80007352:	93c080e7          	jalr	-1732(ra) # 80000c8a <release>
            release(&wait_lock);
    80007356:	0000b517          	auipc	a0,0xb
    8000735a:	af250513          	addi	a0,a0,-1294 # 80011e48 <wait_lock>
    8000735e:	ffffa097          	auipc	ra,0xffffa
    80007362:	92c080e7          	jalr	-1748(ra) # 80000c8a <release>
            return -1;
    80007366:	59fd                	li	s3,-1
    80007368:	a071                	j	800073f4 <get_process_time+0x152>
			        p->execTime.endTime = sys_uptime();
    8000736a:	ffffc097          	auipc	ra,0xffffc
    8000736e:	d24080e7          	jalr	-732(ra) # 8000308e <sys_uptime>
    80007372:	16a93823          	sd	a0,368(s2)
			        p->execTime.totalTime = p->execTime.endTime - p->execTime.creationTime;
    80007376:	16893703          	ld	a4,360(s2)
    8000737a:	40e507b3          	sub	a5,a0,a4
    8000737e:	16f93c23          	sd	a5,376(s2)
      		    copyout(p->pagetable, uaddr, &(p->execTime) , sizeof(e_time_t));
    80007382:	46e1                	li	a3,24
    80007384:	16890613          	addi	a2,s2,360
    80007388:	85e2                	mv	a1,s8
    8000738a:	05093503          	ld	a0,80(s2)
    8000738e:	ffffa097          	auipc	ra,0xffffa
    80007392:	2de080e7          	jalr	734(ra) # 8000166c <copyout>
    80007396:	bfa5                	j	8000730e <get_process_time+0x6c>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80007398:	18048493          	addi	s1,s1,384
    8000739c:	03348463          	beq	s1,s3,800073c4 <get_process_time+0x122>
      if(pp->parent == p){
    800073a0:	7c9c                	ld	a5,56(s1)
    800073a2:	ff279be3          	bne	a5,s2,80007398 <get_process_time+0xf6>
        acquire(&pp->lock);
    800073a6:	8526                	mv	a0,s1
    800073a8:	ffffa097          	auipc	ra,0xffffa
    800073ac:	82e080e7          	jalr	-2002(ra) # 80000bd6 <acquire>
        if(pp->state == ZOMBIE){
    800073b0:	4c9c                	lw	a5,24(s1)
    800073b2:	f54787e3          	beq	a5,s4,80007300 <get_process_time+0x5e>
        release(&pp->lock);
    800073b6:	8526                	mv	a0,s1
    800073b8:	ffffa097          	auipc	ra,0xffffa
    800073bc:	8d2080e7          	jalr	-1838(ra) # 80000c8a <release>
        havekids = 1;
    800073c0:	8756                	mv	a4,s5
    800073c2:	bfd9                	j	80007398 <get_process_time+0xf6>
    if(!havekids || killed(p)){
    800073c4:	c719                	beqz	a4,800073d2 <get_process_time+0x130>
    800073c6:	854a                	mv	a0,s2
    800073c8:	ffffb097          	auipc	ra,0xffffb
    800073cc:	f58080e7          	jalr	-168(ra) # 80002320 <killed>
    800073d0:	c129                	beqz	a0,80007412 <get_process_time+0x170>
    	printf("NO CHILD\n");
    800073d2:	00002517          	auipc	a0,0x2
    800073d6:	73e50513          	addi	a0,a0,1854 # 80009b10 <syscalls+0x6c0>
    800073da:	ffff9097          	auipc	ra,0xffff9
    800073de:	1b0080e7          	jalr	432(ra) # 8000058a <printf>
      release(&wait_lock);
    800073e2:	0000b517          	auipc	a0,0xb
    800073e6:	a6650513          	addi	a0,a0,-1434 # 80011e48 <wait_lock>
    800073ea:	ffffa097          	auipc	ra,0xffffa
    800073ee:	8a0080e7          	jalr	-1888(ra) # 80000c8a <release>
      return -1;
    800073f2:	59fd                	li	s3,-1
  }
}
    800073f4:	854e                	mv	a0,s3
    800073f6:	60e6                	ld	ra,88(sp)
    800073f8:	6446                	ld	s0,80(sp)
    800073fa:	64a6                	ld	s1,72(sp)
    800073fc:	6906                	ld	s2,64(sp)
    800073fe:	79e2                	ld	s3,56(sp)
    80007400:	7a42                	ld	s4,48(sp)
    80007402:	7aa2                	ld	s5,40(sp)
    80007404:	7b02                	ld	s6,32(sp)
    80007406:	6be2                	ld	s7,24(sp)
    80007408:	6c42                	ld	s8,16(sp)
    8000740a:	6ca2                	ld	s9,8(sp)
    8000740c:	6d02                	ld	s10,0(sp)
    8000740e:	6125                	addi	sp,sp,96
    80007410:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80007412:	85ea                	mv	a1,s10
    80007414:	854a                	mv	a0,s2
    80007416:	ffffb097          	auipc	ra,0xffffb
    8000741a:	c4a080e7          	jalr	-950(ra) # 80002060 <sleep>
    havekids = 0;
    8000741e:	bdd9                	j	800072f4 <get_process_time+0x52>
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
