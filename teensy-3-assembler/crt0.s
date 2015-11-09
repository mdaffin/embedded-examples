    .syntax unified

    .section ".vectors"
    .long _estack //  0 ARM: Initial Stack Pointer
    .long _startup //  1 ARM: Initial Program Counter
    //  2 ARM: Non-maskable Interrupt (NMI)
    //  3 ARM: Hard Fault
    //  4 ARM: MemManage Fault
    //  5 ARM: Bus Fault
    //  6 ARM: Usage Fault
    //  7 --
    //  8 --
    //  9 --
    // 10 --
    // 11 ARM: Supervisor call (SVCall)
    // 12 ARM: Debug Monitor
    // 13 --
    // 14 ARM: Pendable req serv(PendableSrvReq)
    // 15 ARM: System tick timer (SysTick)
    // 16 DMA channel 0 transfer complete
    // 17 DMA channel 1 transfer complete
    // 18 DMA channel 2 transfer complete
    // 19 DMA channel 3 transfer complete
    // 20 DMA channel 4 transfer complete
    // 21 DMA channel 5 transfer complete
    // 22 DMA channel 6 transfer complete
    // 23 DMA channel 7 transfer complete
    // 24 DMA channel 8 transfer complete
    // 25 DMA channel 9 transfer complete
    // 26 DMA channel 10 transfer complete
    // 27 DMA channel 11 transfer complete
    // 28 DMA channel 12 transfer complete
    // 29 DMA channel 13 transfer complete
    // 30 DMA channel 14 transfer complete
    // 31 DMA channel 15 transfer complete
    // 32 DMA error interrupt channel
    // 33 --
    // 34 Flash Memory Command complete
    // 35 Flash Read collision
    // 36 Low-voltage detect/warning
    // 37 Low Leakage Wakeup
    // 38 Both EWM and WDOG interrupt
    // 39 --
    // 40 I2C0
    // 41 I2C1
    // 42 SPI0
    // 43 SPI1
    // 44 --
    // 45 CAN OR'ed Message buffer (0-15)
    // 46 CAN Bus Off
    // 47 CAN Error
    // 48 CAN Transmit Warning
    // 49 CAN Receive Warning
    // 50 CAN Wake Up
    // 51 I2S0 Transmit
    // 52 I2S0 Receive
    // 53 --
    // 54 --
    // 55 --
    // 56 --
    // 57 --
    // 58 --
    // 59 --
    // 60 UART0 CEA709.1-B (LON) status
    // 61 UART0 status
    // 62 UART0 error
    // 63 UART1 status
    // 64 UART1 error
    // 65 UART2 status
    // 66 UART2 error
    // 67 --
    // 68 --
    // 69 --
    // 70 --
    // 71 --
    // 72 --
    // 73 ADC0
    // 74 ADC1
    // 75 CMP0
    // 76 CMP1
    // 77 CMP2
    // 78 FTM0
    // 79 FTM1
    // 80 FTM2
    // 81 CMT
    // 82 RTC Alarm interrupt
    // 83 RTC Seconds interrupt
    // 84 PIT Channel 0
    // 85 PIT Channel 1
    // 86 PIT Channel 2
    // 87 PIT Channel 3
    // 88 PDB Programmable Delay Block
    // 89 USB OTG
    // 90 USB Charger Detect
    // 91 --
    // 92 --
    // 93 --
    // 94 --
    // 95 --
    // 96 --
    // 97 DAC0
    // 98 --
    // 99 TSI0
    // 100 MCG
    // 101 Low Power Timer
    // 102 --
    // 103 Pin detect (Port A)
    // 104 Pin detect (Port B)
    // 105 Pin detect (Port C)
    // 106 Pin detect (Port D)
    // 107 Pin detect (Port E)
    // 108 --
    // 109 --
    // 110 Software interrupt
  
    .section ".flashconfig"
    .long   0xFFFFFFFF
    .long   0xFFFFFFFF
    .long   0xFFFFFFFF
    .long   0xFFFFFFFE

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

.global _halt
_halt: b _halt

    .end
