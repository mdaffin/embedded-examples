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
A very basic linker script for the teensy LC. Page references refer to the
programmers manual for the MKL26Z64VFT4 which can be found at:
https://www.pjrc.com/teensy/KL26P121M48SF4RM.pdf
*/

MEMORY {
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 62K /* page 79 */
    RAM  (rwx) : ORIGIN = 0x1FFFF800, LENGTH = 8K /* page 82 */

}

SECTIONS {
    . = 0x00000000;
    .text : {
        KEEP(*(.vectors)) /* vectors must be placed first - page 58*/
        . = 0x400;
        KEEP(*(.flashconfig*)) /* flash configuration starts at 0x400 - page 569 */
        *(.startup)
        *(.text)
    } > FLASH

    _estack = ORIGIN(RAM) + LENGTH(RAM); /* stack pointer start */
}
