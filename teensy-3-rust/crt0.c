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

#define WDOG_UNLOCK  (*(volatile unsigned short *)0x4005200E) // Watchdog Unlock register
#define WDOG_STCTRLH (*(volatile unsigned short *)0x40052000) // Watchdog Status and Control Register High
#define GPIO_CONFIG  (*(volatile unsigned short *)0x40048038)
#define PORTC_PCR5   (*(volatile unsigned short *)0x4004B014) // PORTC_PCR5 - page 223/227
#define GPIOC_PDDR   (*(volatile unsigned short *)0x400FF094) // GPIOC_PDDR - page 1334,1337
#define GPIOC_PDOR   (*(volatile unsigned short *)0x400FF080) // GPIOC_PDOR - page 1334,1335

extern unsigned long _etext;
extern unsigned long _sdata;
extern unsigned long _edata;
extern unsigned long _sbss;
extern unsigned long _ebss;
extern unsigned long _estack;

void startup();
void nim_handler();
void hard_fault_handler();
void mem_fault_handler();
void bus_fault_handler();
void usage_fault_handler();
extern void rust_loop();
void led_on();
void led_off();
void delay(int ms);

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
const unsigned char flashconfigbytes[16] = {
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
	0xFF, 0xFF, 0xFF, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF
};

__attribute__ ((section(".startup")))
void startup() {
	unsigned long *src = &_etext;
	unsigned long *dest = &_sdata;

  WDOG_UNLOCK  = ((unsigned short)0xC520);
  WDOG_UNLOCK  = ((unsigned short)0xD928);
  WDOG_STCTRLH = ((unsigned short)0x01D2);

	while (dest < &_edata) *dest++ = *src++;
	dest = &_sbss;
	while (dest < &_ebss) *dest++ = 0;

  // Enable system clock on all GPIO ports - page 254
  GPIO_CONFIG = ((unsigned short)0x00043F82); // 0b1000011111110000010
  // Configure the led pin
  PORTC_PCR5 = ((unsigned short)0x00000143); // Enables GPIO | DSE | PULL_ENABLE | PULL_SELECT - page 227
  // Set the led pin to output
  GPIOC_PDDR = ((unsigned short)0x20); // pin 5 on port c

  rust_loop();
}

void delay(int ms) {
  for (unsigned int i = 0; i <= ms * 2500; i++) {;}
}

void nim_handler() { while (1); }
void hard_fault_handler() { while (1); }
void mem_fault_handler() { while (1); }
void bus_fault_handler() { while (1); }
void usage_fault_handler() { while (1); }
