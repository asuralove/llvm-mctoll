# RUN: clang -target arm -mfloat-abi=soft -c -o %t.o %s
# RUN: llvm-mctoll -d -debug -print-after-all %t.o 2>&1 | FileCheck %s

# CHECK: ARMInstructionSplitting start
# CHECK: %1:gprnopc = ADDrr $r0, $r1
# CHECK-NEXT: STRi12 $r0, %1:gprnopc
# CHECK-NEXT: %3:gprnopc = ADDrr $r0, $r1
# CHECK-NEXT: $r0 = LDRi12 %3:gprnopc
# CHECK: ARMInstructionSplitting end

# CHECK: ARMInstructionSplitting start
# CHECK: %1:gprnopc = ADDrr $r0, $r1, 0, $cpsr
# CHECK-NEXT: STRi12 $r0, %1:gprnopc, 0, $cpsr
# CHECK-NEXT: %3:gprnopc = ADDrr $r0, $r1, 0, $cpsr
# CHECK-NEXT: $r0 = LDRi12 %3:gprnopc, 0, $cpsr
# CHECK: ARMInstructionSplitting end

  .text
  .align 4
  .code 32
  .global funcLDRSTRReg
  .type funcLDRSTRReg, %function
funcLDRSTRReg:
  sub	sp, sp, #16
  mov	r2, r1
  mov	r3, r0
  str	r0, [sp, #12]
  str	r1, [sp, #8]
  ldr	r0, [sp, #12]
  ldr	r1, [sp, #8]
  str r0, [r0, r1]
  ldr r0, [r0, r1]
  str	r2, [sp, #4]
  str	r3, [sp]
  add	sp, sp, #16
  bx	lr
  .size funcLDRSTRReg, .-funcLDRSTRReg

  .global funcLDRSTRRegC
  .type funcLDRSTRRegC, %function
funcLDRSTRRegC:
  sub	sp, sp, #16
  mov	r2, r1
  mov	r3, r0
  str	r0, [sp, #12]
  str	r1, [sp, #8]
  ldr	r0, [sp, #12]
  ldr	r1, [sp, #8]
  streq r0, [r0, r1]
  ldreq r0, [r0, r1]
  add r0, r0, r1
  str	r2, [sp, #4]
  str	r3, [sp]
  add	sp, sp, #16
  bx	lr
  .size funcLDRSTRRegC, .-funcLDRSTRRegC