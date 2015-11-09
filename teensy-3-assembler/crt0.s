/*
Copyright (c) 2015 Michael Daffin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

/*
Example assembler code to make the led on the teensy 3.1/3.2 blink.

This text refers to the programmers manual for the MK20DX256VLH7. You can
obtain it from: https://www.pjrc.com/teensy/K20P64M72SF1RM.pdf
*/

    .syntax unified

    .section ".vectors"
    // Interrupt vector definitions - page 63
    .long _estack //  0 ARM: Initial Stack Pointer
    .long _startup //  1 ARM: Initial Program Counter
    //  2 ARM: Non-maskable Interrupt (NMI)
    //  3 ARM: Hard Fault
    //  4 ARM: MemManage Fault
    //  5 ARM: Bus Fault
    //  6 ARM: Usage Fault
  
    .section ".flashconfig"
    // Flash Configuration located at 0x400 - page 569
    .long   0xFFFFFFFF
    .long   0xFFFFFFFF
    .long   0xFFFFFFFF
    .long   0xFFFFFFFE

    .section ".startup","x",%progbits
    .thumb_func
    .global _startup
_startup:
    mov     r0,#0
    mov     r1,#0
    mov     r2,#0
    mov     r3,#0
    mov     r4,#0
    mov     r5,#0
    mov     r6,#0
    mov     r7,#0
    mov     r8,#0
    mov     r9,#0
    mov     r10,#0
    mov     r11,#0
    mov     r12,#0

    CPSID i // Disable interrupts

    // Unlock watchdog - page 478
    ldr r6, = 0x4005200e // page 473
    ldr r0, = 0xc520
    strh r0, [r6]
    ldr r0, = 0xd928
    strh r0, [r6]

    // Disable watchdog - page 468
    ldr r6, = 0x40052000 // page 473
    ldr r0, = 0x01d2
    strh r0, [r6]

    CPSIE i // Enable interrupts

led_setup:

    ldr r6, = 0x40048038 @ SIM_SCGC5  doc: K20P64M50SF0RM.pdf ( Page 239 )
    ldr r0, = 0x00043F82 @ Clocks active to all GPIO
    str r0, [r6]

    .set GPIO_ENABLE, (0x001 << 8)
    .set PULL_UP_ENABLE, (1 << 1)
    .set PULL_UP_SELECT, (1 << 0)
    .set DRIVE_STR, (1 << 6)
    .set PORT_CTRL_FLAGS, ( DRIVE_STR | GPIO_ENABLE | PULL_UP_ENABLE | PULL_UP_SELECT) @ doc: K20P64M50SF0RM.pdf ( Page 213 )

    ldr r6, = 0x4004B014 @ PORTC_PCR5 doc: K20P64M50SF0RM.pdf ( Pages 210, 213 )
    ldr r0, = PORT_CTRL_FLAGS
    str r0, [r6]

    ldr r6, = 0x400FF094 @ GPIOC_PDDR doc: K20P64M50SF0RM.pdf ( Pages: 1181, 1185 )
    ldr r0, = 0xFFFFFFFF @ All as output
    str r0, [r6]

loop:
    bl led_on
    bl delay
    bl led_off
    bl delay
    b loop

led_off:

    ldr r6, = 0x400FF080 @ GPIOC_PDOR doc: K20P64M50SF0RM.pdf ( Pages: 1180, 1182 )
    ldr r0, = 0x00000000 @ All as low
    str r0, [r6]
    mov pc, r14

led_on:

    ldr r6, = 0x400FF080 @ GPIOC_PDOR doc: K20P64M50SF0RM.pdf ( Pages: 1180, 1182 )
    ldr r0, = 0xFFFFFFFF @ All as high
    str r0, [r6]
    mov pc, r14

delay: @ Uncalibrated busy wait

    ldr r1, = 0x2625A0
delay_loop:
    sub r1, r1, #1
    cmp r1, #0
    bne delay_loop
    mov pc, r14

.global _halt
_halt: b _halt

    .end
