# Assembler on the teensy 3.1

This is an example of writing pure assembler on the teensy 3.1. It is based of the example by [glock45](https://forum.pjrc.com/threads/25762-Turn-the-LED-on-with-assembler-code-\(-Teensy-3-1-\)?p=47739&viewfull=1#post47739).

## Prerequisites
You will need the assembler, linker and objcopy from the arm-none-eabi toolkit:
* arm-none-eabi-as
* arm-none-eabi-ld
* arm-none-eabi-objcopy

You can get them from packge `arm-none-eabi-gcc` on archlinux or `gcc-arm-none-eabi` on ubuntu. Otherwise you can get it from [CodeSourcery](https://sourcery.mentor.com/GNUToolchain/release1802?) or from your arduino install at `$ARDUINO_SDK/hardware/tools/arm/bin`.

You will also need the teensy-loader or teensy-loader-cli which you can get [here](https://www.pjrc.com/teensy/loader.html)

## Linker script - layout.ld
The linker script tells the linker where to place the various bits of code. For more details see [this tutorial](http://bravegnu.org/gnu-eprog/linker.html)

## Assembler code - crt0.s
A minimal example of the assembler needed to drive the led on a teensy 3.1. It only initlises parts of the arm chip that are needed to blink the led in order to make it easier to understand. For a more complete example see the the example by [karl lunt](http://www.seanet.com/~karllunt/bareteensy31.html).

## Compile and upload

To compile and upload to the teensy run:

```bash
arm-none-eabi-gcc -mcpu=cortex-m4 -nostdlib -mthumb -o crt0.o crt0.c

arm-none-eabi-as -g -mcpu=cortex-m4 -mthumb -o crt0.o crt0.s
arm-none-eabi-ld -T layout.ld -o crt0.elf crt0.o
arm-none-eabi-objcopy -O ihex -R .eeprom crt0.elf crt0.hex
echo "Reset teensy now"
teensy-loader-cli -w --mcu=mk20dx256 crt0.hex
```

## References
1. [Turn the LED on with assembler code ( Teensy 3.1 )](https://forum.pjrc.com/threads/25762-Turn-the-LED-on-with-assembler-code-\(-Teensy-3-1-\)?p=47739&viewfull=1#post47739)
1. [Embedded Programming with the GNU Toolchain](http://bravegnu.org/gnu-eprog/)
2. [Bare-metal Teensy 3.x Development](http://www.seanet.com/~karllunt/bareteensy31.html)


http://fun-tech.se/stm32/linker/
