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
Blink demo in c for the teensy 3.1.

This text refers to the programmers manual for the MK20DX256VLH7. You can
obtain it from: https://www.pjrc.com/teensy/K20P64M72SF1RM.pdf
*/

#include <stdint.h>

extern unsigned int _estack;

void startup();
void nim_handler();
void hard_fault_handler();
void mem_fault_handler();
void bus_fault_handler();
void usage_fault_handler();

__attribute__ ((section(".vectors"), used))
void (* const _vectors[7])(void) = {
    (void (*)(void))((unsigned long)&_estack),
    startup,
    nim_handler,
    hard_fault_handler,
    mem_fault_handler,
    bus_fault_handler,
    usage_fault_handler
};

__attribute__ ((section(".flashconfig"), used))
const uint8_t flashconfigbytes[16] = {
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE
};

void startup() {
  while (1);
}
void nim_handler() { while (1); }
void hard_fault_handler() { while (1); }
void mem_fault_handler() { while (1); }
void bus_fault_handler() { while (1); }
void usage_fault_handler() { while (1); }

/*
    .syntax unified

    .section ".vectors"
    // Interrupt vector definitions - page 63

    .section ".flashconfig"
    // Flash Configuration located at 0x400 - page 569
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

    ldr sp, = _estack

    cpsid i // Disable interrupts

    // Unlock watchdog - page 478
    ldr r6, = 0x4005200E // address from page 473
    ldr r0, = 0xC520
    strh r0, [r6]
    ldr r0, = 0xD928
    strh r0, [r6]

    // Disable watchdog - page 468
    ldr r6, = 0x40052000 // address from page 473
    ldr r0, = 0x01D2
    strh r0, [r6]

    cpsie i // Enable interrupts

    // Enable system clock on all GPIO ports - page 254
    ldr r6, = 0x40048038
    ldr r0, = 0x00043F82 // 0b1000011111110000010
    str r0, [r6]

    // Configure the led pin
    ldr r6, = 0x4004B014 // PORTC_PCR5 - page 223/227
    ldr r0, = 0x00000143 // Enables GPIO | DSE | PULL_ENABLE | PULL_SELECT - page 227
    str r0, [r6]

    // Set the led pin to output
    ldr r6, = 0x400FF094 // GPIOC_PDDR - page 1334,1337
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
    ldr r6, = 0x400FF080 // GPIOC_PDOR - page 1334,1335
    ldr r0, = 0x0
    str r0, [r6]
    mov pc, r14

    // Function to turn the led on
    .thumb_func
    .global led_on
led_on:
    ldr r6, = 0x400FF080 // GPIOC_PDOR - page 1334,1335
    ldr r0, = 0x20
    str r0, [r6]
    mov pc, r14

    // Uncalibrated busy wait
    .thumb_func
    .global delay
delay:
    ldr r1, = 1000000
delay_loop:
    sub r1, r1, #1
    cmp r1, #0
    bne delay_loop
    mov pc, r14

_halt: b _halt
    .end
    */
