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
Blink demo in assembler for the teensy LC.

This text refers to the programmers manual for the MKL26Z64VFT4. You can
obtain it from: https://www.pjrc.com/teensy/KL26P121M48SF4RM.pdf
*/

    .syntax unified

    .section ".vectors"
    // Interrupt vector definitions - page 58
    .long _estack  //  0 ARM: Initial Stack Pointer
    .long _startup //  1 ARM: Initial Program Counter
    .long _halt    //  2 ARM: Non-maskable Interrupt (NMI)
    .long _halt    //  3 ARM: Hard Fault

    .section ".flashconfig"
    // Flash Configuration located at 0x400 - page 443
    .long   0xFFFFFFFF
    .long   0xFFFFFFFF
    .long   0xFFFFFFFF
    .long   0xFFFFFFFE

    // Start of program execution
    .section ".startup","x",%progbits
    .thumb_func
    .global _startup
_startup:
    // Zero all the registers
    movs r0,#0
    mov r1,r0
    mov r2,r0
    mov r3,r0
    mov r4,r0
    mov r5,r0
    mov r6,r0
    mov r7,r0
    mov r8,r0
    mov r9,r0
    mov r10,r0
    mov r11,r0
    mov r12,r0

/*    cpsid i // Disable interrupts*/

    // COP Control Register (SIM_COPC) - page 232
    ldr r6, = 0x40048100 // address from page 208
    ldr r0, = 0
    str r0, [r6]

/*    cpsie i // Enable interrupts*/

    // Enable system clock on all GPIO ports - page 222
    ldr r6, = 0x40048038
    ldr r0, = 0x00043F82 // 0b1000011111110000010
    str r0, [r6]

    // Configure the led pin
    ldr r6, = 0x4004B014 // PORTC_PCR5 - page 196
    ldr r0, = 0x00000143 // Enables GPIO | DSE | PULL_ENABLE | PULL_SELECT - page 200,201
    str r0, [r6]

    // Set the led pin to output
    ldr r6, = 0x400FF094 // GPIOC_PDDR - page 842
    ldr r0, = 0x20 // pin 5 on port c
    str r0, [r6]

    // Main loop
loop:
    bl led_on
    bl delay
    bl led_off
    bl delay
    b loop

    // Function to turn the led off
    .thumb_func
    .global led_off
led_off:
    ldr r6, = 0x400FF080 // GPIOC_PDOR - page 842,843
    ldr r0, = 0x0
    str r0, [r6]
    mov pc, r14

    // Function to turn the led on
    .thumb_func
    .global led_on
led_on:
    ldr r6, = 0x400FF080 // GPIOC_PDOR - page 842,843
    ldr r0, = 0x20
    str r0, [r6]
    mov pc, r14

    // Uncalibrated busy wait
    .thumb_func
    .global delay
delay:
    ldr r1, = 0x2625A0
delay_loop:
    subs r1, r1, #1
    cmp r1, #0
    bne delay_loop
    mov pc, r14

_halt: b _halt
    .end
