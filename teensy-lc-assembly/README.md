# Assembler on the teensy LC

This is an example of writing pure assembler on the teensy LC.
It is based on the one for teensy 3.1.
See ../teensy-3-assembly/README.md

## Prerequisites
You will need the assembler, linker and objcopy from the arm-none-eabi toolkit:
* arm-none-eabi-as
* arm-none-eabi-ld
* arm-none-eabi-objcopy

You can get them from packge `arm-none-eabi-gcc` on archlinux or `gcc-arm-none-eabi` on ubuntu. Otherwise you can get it from [CodeSourcery](https://sourcery.mentor.com/GNUToolchain/release1802?) or from your arduino install at `$ARDUINO_SDK/hardware/tools/arm/bin`.

You will also need the teensy-loader or teensy-loader-cli which you can get [here](https://www.pjrc.com/teensy/loader.html)

## Linker script - layout.ld
The linker script tells the linker where to place the various bits of code. For more details see [this tutorial](http://bravegnu.org/gnu-eprog/linker.html)

## Assembler code - blink.s
A minimal example of the assembler needed to drive the led on a teensy LC. It only initlises parts of the arm chip that are needed to blink the led in order to make it easier to understand. For a more complete example see the the example by [karl lunt](http://www.seanet.com/~karllunt/bareteensy31.html).

## Compile and upload

To compile and upload to the teensy, run `make`.
