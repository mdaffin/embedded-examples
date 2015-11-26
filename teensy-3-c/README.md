# C on the teensy 3.1

An example of writing pure c on the teensy 3.1.

## Prerequisites
You will need the C compiler, linker and objcopy from the arm-none-eabi toolkit:
* arm-none-eabi-gcc
* arm-none-eabi-ld
* arm-none-eabi-objcopy

You can get them from packge `arm-none-eabi-gcc` on archlinux or `gcc-arm-none-eabi` on ubuntu. Otherwise you can get it from [CodeSourcery](https://sourcery.mentor.com/GNUToolchain/release1802?) or from your arduino install at `$ARDUINO_SDK/hardware/tools/arm/bin`.

You will also need the teensy-loader or teensy-loader-cli which you can get [here](https://www.pjrc.com/teensy/loader.html)

## Linker script: `layout.ld`

The linker script tells the linker where to place the various bits of code. For more details see [this tutorial](http://bravegnu.org/gnu-eprog/linker.html)

## C code: `blink.c`

A minimal example of the C code needed to drive the led on a teensy 3.1. It only initlises parts of the arm chip that are needed to blink the led in order to make it easier to understand. For a more complete example see the the example by [karl lunt](http://www.seanet.com/~karllunt/bareteensy31.html).

## Compile and upload

To compile and upload to the teensy run:

```bash
arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -nostdlib -c -o blink.o blink.c
arm-none-eabi-ld -T layout.ld -o blink.elf blink.o
arm-none-eabi-objcopy -O ihex -R .eeprom blink.elf blink.hex
echo "Reset teensy now"
teensy-loader-cli -w --mcu=mk20dx256 blink.hex
```

## References
1. [Embedded Programming with the GNU Toolchain](http://bravegnu.org/gnu-eprog/)
2. [Bare-metal Teensy 3.x Development](http://www.seanet.com/~karllunt/bareteensy31.html)
3. [STM32/ARM Cortex-M3 HOWTO](http://fun-tech.se/stm32/linker/)
4. [Teensy3 core code](https://github.com/PaulStoffregen/cores/blob/master/teensy3/mk20dx128.c)
