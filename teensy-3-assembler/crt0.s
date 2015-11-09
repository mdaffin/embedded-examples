    
    .syntax unified
    .thumb    
    .section ".vectors"
    .global _start
    .global _vectors

_vectors:    
_start:

    /* Initial Stack Pointer and Reset Vector */

    .long 0x20000000             
    .long _startup
  
    .org 0x400

    /* Flash Configuration */

    .long   0xFFFFFFFF
    .long   0xFFFFFFFF
    .long   0xFFFFFFFF
    .long   0xFFFFFFFE

    .thumb
    .section ".startup","x",%progbits
    .thumb_func
    .global _startup

_startup:

    /* Suggested register initialisation from "Definitive guide to Cortex-M3 guide" */
    
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

    CPSID i

unlock_watchdog:

    ldr r6, = 0x4005200e @ WDOG_UNLOCK doc: K20P64M50SF0RM.pdf ( Page: 423 )
    ldr r0, = 0xc520
    strh r0, [r6]
    ldr r0, = 0xd928
    strh r0, [r6]

disable_watchdog:

    ldr r6, = 0x40052000 @ WDOG_STCTRLH doc: K20P64M50SF0RM.pdf ( Page: 418 )
    ldr r0, = 0x01d2
    strh r0, [r6]

    CPSIE i

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

delay:

    ldr r1, = 0x2625A0
delay_loop:
    sub r1, r1, #1
    cmp r1, #0
    bne delay_loop
    mov pc, r14

    .end
