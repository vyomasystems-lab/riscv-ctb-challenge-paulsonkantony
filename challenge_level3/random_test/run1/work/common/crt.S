#include "encoding.h"

#if __riscv_xlen == 64
  # define LREG ld
  # define LREGU lwu
  # define SREG sd
  # define REGBYTES 8
  # define FMV fmv.d.x
#else
  # define LREG lw
  # define SREG sw
  # define LREGU lw
  # define REGBYTES 4
  # define FMV fmv.w.x
#endif

  .section ".text.init"
  .globl _start
_start:
  la sp, begin_signature
  LREG  x1, 0*REGBYTES(sp)
  LREG  x3, 1*REGBYTES(sp)
  LREG  x4, 2*REGBYTES(sp)
  LREG  x5, 3*REGBYTES(sp)
  LREG  x6, 4*REGBYTES(sp)
  LREG  x7, 5*REGBYTES(sp)
  LREG  x8, 6*REGBYTES(sp)
  LREG  x9, 7*REGBYTES(sp)
  LREG  x10,8*REGBYTES(sp)
  LREG  x11,9*REGBYTES(sp)
  LREG  x12,10*REGBYTES(sp)
  LREG  x13,11*REGBYTES(sp)
  LREG  x14,12*REGBYTES(sp)
  LREG  x15,13*REGBYTES(sp)
  LREG  x16,14*REGBYTES(sp)
  LREG  x17,15*REGBYTES(sp)
  LREG  x18,16*REGBYTES(sp)
  LREG  x19,17*REGBYTES(sp)
  LREG  x20,18*REGBYTES(sp)
  LREG  x21,19*REGBYTES(sp)
  LREG  x22,20*REGBYTES(sp)
  LREG  x23,21*REGBYTES(sp)
  LREG  x24,22*REGBYTES(sp)
  LREG  x25,23*REGBYTES(sp)
  LREG  x26,24*REGBYTES(sp)
  LREG  x27,25*REGBYTES(sp)
  LREG  x28,26*REGBYTES(sp)
  LREG  x29,27*REGBYTES(sp)
  LREG  x30,28*REGBYTES(sp)
  LREG  x31,29*REGBYTES(sp)

  # enable FPU and accelerator if present
  li t0, MSTATUS_FS | MSTATUS_XS
  csrs mstatus, t0

  # make sure XLEN agrees with compilation choice
  li t0, 1
  slli t0, t0, 31
#if __riscv_xlen == 64
  bgez t0, 1f
#else
  bltz t0, 1f
#endif
2:
  li a0, 1
  sw a0, tohost, t0
  j 2b
1:

#ifdef __riscv_flen
  # initialize FPU if we have one
  la t0, 1f
  csrw mtvec, t0

  fssr    x0
  FMV  f0, x1
  FMV  f1, x1
  FMV  f2, x2
  FMV  f3, x3
  FMV  f4, x4
  FMV  f5, x5
  FMV  f6, x6
  FMV  f7, x7
  FMV  f8, x8
  FMV  f9, x9
  FMV  f10, x10
  FMV  f11, x11
  FMV  f12, x12
  FMV  f13, x13
  FMV  f14, x14
  FMV  f15, x15
  FMV  f16, x16
  FMV  f17, x17
  FMV  f18, x18
  FMV  f19, x19
  FMV  f20, x20
  FMV  f21, x21
  FMV  f22, x22
  FMV  f23, x23
  FMV  f24, x24
  FMV  f25, x25
  FMV  f26, x26
  FMV  f27, x27
  FMV  f28, x28
  FMV  f29, x29
  FMV  f30, x30
  FMV  f31, x31
  .align 4
1:
#endif

  # initialize trap vector
  la t0, trap_entry
  csrw mtvec, t0

  la  tp, _end + 63
  and tp, tp, -64

  # get core id
  csrr a0, mhartid
  # for now, assume only 1 core
  li a1, 1
1:bgeu a0, a1, 1b

  # give each core 128KB of stack + TLS
#define STKSHIFT 17
  sll a2, a0, STKSHIFT
  add tp, tp, a2
  add sp, a0, 1
  sll sp, sp, STKSHIFT
  add sp, sp, tp

  j main

  .align 2
trap_entry:
  addi sp, sp, -272

  SREG x1, 1*REGBYTES(sp)
  SREG x2, 2*REGBYTES(sp)
  SREG x3, 3*REGBYTES(sp)
  SREG x4, 4*REGBYTES(sp)
  SREG x5, 5*REGBYTES(sp)
  SREG x6, 6*REGBYTES(sp)
  SREG x7, 7*REGBYTES(sp)
  SREG x8, 8*REGBYTES(sp)
  SREG x9, 9*REGBYTES(sp)
  SREG x10, 10*REGBYTES(sp)
  SREG x11, 11*REGBYTES(sp)
  SREG x12, 12*REGBYTES(sp)
  SREG x13, 13*REGBYTES(sp)
  SREG x14, 14*REGBYTES(sp)
  SREG x15, 15*REGBYTES(sp)
  SREG x16, 16*REGBYTES(sp)
  SREG x17, 17*REGBYTES(sp)
  SREG x18, 18*REGBYTES(sp)
  SREG x19, 19*REGBYTES(sp)
  SREG x20, 20*REGBYTES(sp)
  SREG x21, 21*REGBYTES(sp)
  SREG x22, 22*REGBYTES(sp)
  SREG x23, 23*REGBYTES(sp)
  SREG x24, 24*REGBYTES(sp)
  SREG x25, 25*REGBYTES(sp)
  SREG x26, 26*REGBYTES(sp)
  SREG x27, 27*REGBYTES(sp)
  SREG x28, 28*REGBYTES(sp)
  SREG x29, 29*REGBYTES(sp)
  SREG x30, 30*REGBYTES(sp)
  SREG x31, 31*REGBYTES(sp)

  csrr a0, mcause                 # copy the mcause to register a0.
  csrr a1, mepc                   # copy the mepc to register a1.
  lhu  a2, 0(a1)                  # load instruction into reg a1.

  # check the lower 2 bits to see if the instruction is 32-bit or 16-bit.
  andi a2, a2, 0x3;
  li t0, 0x3
  bne a2,t0,inst16

  inst32:                           # is 32-bit instruction then increment by 4
  addi a1,a1,0x4
  beqz x0,1f

inst16:
  addi a1,a1,0x2                  # is 16-bit instruction then increment by 2

1: 
  csrw mepc, a1                   # point mepc to the next instruction.

  # use mcause to update the number of exceptions encountered in the program.

  # Remain in M-mode after eret
  li t0, MSTATUS_MPP
  csrs mstatus, t0

  LREG x1, 1*REGBYTES(sp)
  LREG x2, 2*REGBYTES(sp)
  LREG x3, 3*REGBYTES(sp)
  LREG x4, 4*REGBYTES(sp)
  LREG x5, 5*REGBYTES(sp)
  LREG x6, 6*REGBYTES(sp)
  LREG x7, 7*REGBYTES(sp)
  LREG x8, 8*REGBYTES(sp)
  LREG x9, 9*REGBYTES(sp)
  LREG x10, 10*REGBYTES(sp)
  LREG x11, 11*REGBYTES(sp)
  LREG x12, 12*REGBYTES(sp)
  LREG x13, 13*REGBYTES(sp)
  LREG x14, 14*REGBYTES(sp)
  LREG x15, 15*REGBYTES(sp)
  LREG x16, 16*REGBYTES(sp)
  LREG x17, 17*REGBYTES(sp)
  LREG x18, 18*REGBYTES(sp)
  LREG x19, 19*REGBYTES(sp)
  LREG x20, 20*REGBYTES(sp)
  LREG x21, 21*REGBYTES(sp)
  LREG x22, 22*REGBYTES(sp)
  LREG x23, 23*REGBYTES(sp)
  LREG x24, 24*REGBYTES(sp)
  LREG x25, 25*REGBYTES(sp)
  LREG x26, 26*REGBYTES(sp)
  LREG x27, 27*REGBYTES(sp)
  LREG x28, 28*REGBYTES(sp)
  LREG x29, 29*REGBYTES(sp)
  LREG x30, 30*REGBYTES(sp)
  LREG x31, 31*REGBYTES(sp)

  addi sp, sp, 272
  mret

.section ".tdata.begin"
.globl _tdata_begin
_tdata_begin:

.section ".tdata.end"
.globl _tdata_end
_tdata_end:

.section ".tbss.end"
.globl _tbss_end
_tbss_end:

.section ".tohost","aw",@progbits
.align 6
.globl tohost
tohost: .dword 0
.align 6
.globl fromhost
fromhost: .dword 0

# Exception generation numbers
.align 4
.globl ecause_num
ecause_num:
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0

# Read only data
.section ".rodata"
.globl rodata
rodata:
    	.dword 0x5b707269762d6d6f
	.dword 0x64655d0a6d6f6465
	.dword 0x203d206d0a5b6765
	.dword 0x6e6572616c5d0a74
	.dword 0x6f74616c5f696e73
	.dword 0x7472756374696f6e
	.dword 0x73203d2031303030
	.dword 0x0a726567735f6e6f
	.dword 0x745f757365203d20
	.dword 0x78312c78320a6375
	.dword 0x73746f6d5f747261
	.dword 0x705f68616e646c65
	.dword 0x72203d2046616c73
	.dword 0x650a636f64655f73
	.dword 0x746172745f616464
	.dword 0x72657373203d2032
	.dword 0x3134373438333634
	.dword 0x380a64656661756c
	.dword 0x745f70726f677261
	.dword 0x6d5f65786974203d
	.dword 0x20547275650a6465
	.dword 0x6c65676174696f6e
	.dword 0x203d20300a5b6973
	.dword 0x612d696e73747275
	.dword 0x6374696f6e2d6469
	.dword 0x7374726962757469
	.dword 0x6f6e5d0a72656c5f
	.dword 0x737973203d20300a
	.dword 0x72656c5f7379732e
	.dword 0x637372203d20300a
	.dword 0x72656c5f72763332
	.dword 0x692e6374726c203d
	.dword 0x20310a72656c5f72
	.dword 0x763332692e636f6d
	.dword 0x70757465203d2031
	.dword 0x300a72656c5f7276
	.dword 0x3332692e64617461
	.dword 0x203d20350a72656c
	.dword 0x5f72763332692e66
	.dword 0x656e6365203d2030
	.dword 0x0a72656c5f727636
	.dword 0x34692e636f6d7075
	.dword 0x7465203d20300a72
	.dword 0x656c5f7276363469
	.dword 0x2e64617461203d20
	.dword 0x300a72656c5f7276
	.dword 0x3332692e7a626120
	.dword 0x3d20300a72656c5f
	.dword 0x72763634692e7a62
	.dword 0x61203d20300a7265
	.dword 0x6c5f72763332692e
	.dword 0x7a6262203d20300a
	.dword 0x72656c5f72763634
	.dword 0x692e7a6262203d20
	.dword 0x300a72656c5f7276
	.dword 0x3332692e7a626320
	.dword 0x3d20300a72656c5f
	.dword 0x72763332692e7a62
	.dword 0x73203d20300a7265
	.dword 0x6c5f72763332692e
	.dword 0x7a6265203d20300a
	.dword 0x72656c5f72763634
	.dword 0x692e7a6265203d20
	.dword 0x300a72656c5f7276
	.dword 0x3332692e7a626620
	.dword 0x3d20300a72656c5f
	.dword 0x72763634692e7a62
	.dword 0x66203d20300a7265
	.dword 0x6c5f72763634692e
	.dword 0x7a626d203d20300a
	.dword 0x72656c5f72763332
	.dword 0x692e7a6270203d20
	.dword 0x300a72656c5f7276
	.dword 0x3634692e7a627020
	.dword 0x3d20300a72656c5f
	.dword 0x72763332692e7a62
	.dword 0x72203d20300a7265
	.dword 0x6c5f72763634692e
	.dword 0x7a6272203d20300a
	.dword 0x72656c5f72763332
	.dword 0x692e7a6274203d20
	.dword 0x300a72656c5f7276
	.dword 0x3634692e7a627420
	.dword 0x3d20300a72656c5f
	.dword 0x727633326d203d20
	.dword 0x300a72656c5f7276
	.dword 0x36346d203d20300a
	.dword 0x72656c5f72763332
	.dword 0x61203d20300a7265
	.dword 0x6c5f727636346120
	.dword 0x3d20300a72656c5f
	.dword 0x7276333266203d20
	.dword 0x300a72656c5f7276
	.dword 0x363466203d20300a
	.dword 0x72656c5f72763332
	.dword 0x64203d20300a7265
	.dword 0x6c5f727636346420
	.dword 0x3d20300a72656c5f
	.dword 0x7276632e6374726c
	.dword 0x203d20300a72656c
	.dword 0x5f7276632e636f6d
	.dword 0x70757465203d2030
	.dword 0x0a72656c5f727663
	.dword 0x2e7370203d20300a
	.dword 0x72656c5f7276632e
	.dword 0x64617461203d2030
	.dword 0x0a72656c5f727663
	.dword 0x2e6664617461203d
	.dword 0x20300a72656c5f72
	.dword 0x763332632e636f6d
	.dword 0x70757465203d2030
	.dword 0x0a72656c5f727633
	.dword 0x32632e6374726c20
	.dword 0x3d20300a72656c5f
	.dword 0x72763332632e6664
	.dword 0x617461203d20300a
	.dword 0x72656c5f72763634
	.dword 0x632e636f6d707574
	.dword 0x65203d20300a7265
	.dword 0x6c5f72763634632e
	.dword 0x64617461203d2030
	.dword 0x0a5b666c6f61742d
	.dword 0x726f756e64696e67
	.dword 0x5d0a726e65203d20
	.dword 0x31300a72747a203d
	.dword 0x2031300a72646e20
	.dword 0x3d2031300a727570
	.dword 0x203d2031300a726d
	.dword 0x6d203d2031300a5b
	.dword 0x6272616e63682d63
	.dword 0x6f6e74726f6c5d0a
	.dword 0x6261636b77617264
	.dword 0x2d70726f62616269
	.dword 0x6c697479203d2030
	.dword 0x2e350a626c6f636b
	.dword 0x2d73697a65203d20
	.dword 0x370a5b7265637572
	.dword 0x73696f6e2d6f7074
	.dword 0x696f6e735d0a7265
	.dword 0x63757273696f6e2d
	.dword 0x656e61626c65203d
	.dword 0x2046616c73650a72
	.dword 0x6563757273696f6e
	.dword 0x2d6465707468203d
	.dword 0x2031300a72656375
	.dword 0x7273696f6e2d6361
	.dword 0x6c6c73203d20350a
	.dword 0x5b6163636573732d
	.dword 0x73656374696f6e73
	.dword 0x5d0a626567696e5f
	.dword 0x7369676e61747572
	.dword 0x65203d2030783830
	.dword 0x3039313030302c30
	.dword 0x7838303039353030
	.dword 0x302c72770a5b6373
	.dword 0x722d73656374696f
	.dword 0x6e735d0a73656374
	.dword 0x696f6e73203d2030
	.dword 0x78303130303a3078
	.dword 0x6466662c20307833
	.dword 0x32352c2030783530
	.dword 0x303a30786666660a
	.dword 0x5b757365722d6675
	.dword 0x6e6374696f6e735d
	.dword 0x0a66756e6331203d
	.dword 0x207b303a22616464
	.dword 0x2078302c78302c78
	.dword 0x30227d0a5b737769
	.dword 0x7463682d70726976
	.dword 0x2d6d6f6465735d0a
	.dword 0x7377697463685f6d
	.dword 0x6f646573203d2046
	.dword 0x616c73650a6e756d
	.dword 0x5f73776974636865
	.dword 0x73203d20300a5b69
	.dword 0x2d63616368655d0a
	.dword 0x6e756d5f63616c6c
	.dword 0x73203d20300a6e75
	.dword 0x6d5f62797465735f
	.dword 0x7065725f626c6f63
	.dword 0x6b203d2031360a6e
	.dword 0x756d5f626c6f636b
	.dword 0x73203d20380a6e75
	.dword 0x6d5f6379636c6573
	.dword 0x203d2031300a5b64
	.dword 0x2d63616368655d0a
	.dword 0x6e756d5f63616c6c
	.dword 0x73203d20300a6e75
	.dword 0x6d5f62797465735f
	.dword 0x7065725f626c6f63
	.dword 0x6b203d2031360a6e
	.dword 0x756d5f626c6f636b
	.dword 0x73203d20380a6e75
	.dword 0x6d5f6379636c6573
	.dword 0x203d2031300a5b65
	.dword 0x7863657074696f6e
	.dword 0x2d67656e65726174
	.dword 0x696f6e5d0a656361
	.dword 0x7573653030203d20
	.dword 0x300a656361757365
	.dword 0x3031203d20300a65
	.dword 0x6361757365303220
	.dword 0x3d20300a65636175
	.dword 0x73653033203d2030
	.dword 0x0a65636175736530
	.dword 0x34203d20300a6563
	.dword 0x617573653035203d
	.dword 0x20300a6563617573
	.dword 0x653036203d20300a
	.dword 0x6563617573653037
	.dword 0x203d20300a656361
	.dword 0x7573653038203d20
	.dword 0x300a656361757365
	.dword 0x3039203d20300a65
	.dword 0x6361757365313020
	.dword 0x3d20300a65636175
	.dword 0x73653131203d2030
	.dword 0x0a65636175736531
	.dword 0x32203d20300a6563
	.dword 0x617573653133203d
	.dword 0x20300a6563617573
	.dword 0x653134203d20300a
	.dword 0x5b646174612d6861
	.dword 0x7a617264735d0a72
	.dword 0x61775f70726f6220
	.dword 0x3d20302e350a7761
	.dword 0x725f70726f62203d
	.dword 0x20302e350a776177
	.dword 0x5f70726f62203d20
	.dword 0x302e350a6e756d5f
	.dword 0x726567735f6c6f6f
	.dword 0x6b626568696e6420
	.dword 0x3d20330a5b70726f
	.dword 0x6772616d2d6d6163
	.dword 0x726f5d0a7072655f
	.dword 0x70726f6772616d5f
	.dword 0x6d6163726f203d20
	.dword 0x6164642078302c78
	.dword 0x302c78300a706f73
	.dword 0x745f70726f677261
	.dword 0x6d5f6d6163726f20
	.dword 0x3d206c692067702c
	.dword 0x313b200a20737720
	.dword 0x67702c20746f686f
	.dword 0x73742c2074353b0a
	.dword 0x2066656e63652e69
	.dword 0x3b0a206c69207436
	.dword 0x2c20203078323030
	.dword 0x30303b200a206c61
	.dword 0x2074352c20626567
	.dword 0x696e5f7369676e61
	.dword 0x747572653b200a20
	.dword 0x73772074352c2030
	.dword 0x287436293b200a20
	.dword 0x6c612074352c2065
	.dword 0x6e645f7369676e61
	.dword 0x74757265200a2073
	.dword 0x772074352c203828
	.dword 0x7436293b200a2073
	.dword 0x772074352c202031
	.dword 0x32287436293b0a70
	.dword 0x72655f6272616e63
	.dword 0x685f6d6163726f20
	.dword 0x3d20616464207830
	.dword 0x2c78302c78300a70
	.dword 0x6f73745f6272616e
	.dword 0x63685f6d6163726f
	.dword 0x203d206164642078
	.dword 0x302c78302c78300a
	.dword 0x6563617573653030
	.dword 0x203d2072616e646f
	.dword 0x6d0a656361757365
	.dword 0x3031203d2072616e
	.dword 0x646f6d0a65636175
	.dword 0x73653032203d2072
	.dword 0x616e646f6d0a6563
	.dword 0x617573653033203d
	.dword 0x2072616e646f6d0a
	.dword 0x6563617573653034
	.dword 0x203d2072616e646f
	.dword 0x6d0a656361757365
	.dword 0x3035203d2072616e
	.dword 0x646f6d0a65636175
	.dword 0x73653036203d2072
	.dword 0x616e646f6d0a6563
	.dword 0x617573653037203d
	.dword 0x2072616e646f6d0a
	.dword 0x6563617573653038
	.dword 0x203d2072616e646f
	.dword 0x6d0a656361757365
	.dword 0x3039203d2072616e
	.dword 0x646f6d0a65636175
	.dword 0x73653130203d2072
	.dword 0x616e646f6d0a6563
	.dword 0x617573653131203d
	.dword 0x2072616e646f6d0a
	.dword 0x6563617573653132
	.dword 0x203d2072616e646f
	.dword 0x6d0a656361757365
	.dword 0x3133203d2072616e
	.dword 0x646f6d0a65636175
	.dword 0x73653134203d2072
	.dword 0x616e646f6d0a5b73
	.dword 0x656c662d63686563
	.dword 0x6b696e675d0a7261
	.dword 0x7465203d20313030
	.dword 0x0a746573745f7061
	.dword 0x73735f6d6163726f
	.dword 0x203d206c61202020
	.dword 0x20202073702c2062
	.dword 0x6567696e5f736967
	.dword 0x6e61747572653b20
	.dword 0x6164646920202020
	.dword 0x73702c2073702c20
	.dword 0x322a524547425954
	.dword 0x45533b206c692020
	.dword 0x2020202074312c20
	.dword 0x307866666666663b
	.dword 0x2053524547202020
	.dword 0x2074312c20302a52
	.dword 0x4547425954455328
	.dword 0x7370290a74657374
	.dword 0x5f6661696c5f6d61
	.dword 0x63726f203d206164
	.dword 0x642078302c78302c
	.byte 0x78
	.byte 0x30
	.byte 0xa
