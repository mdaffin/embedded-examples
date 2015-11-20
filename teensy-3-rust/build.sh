#!/bin/bash
set -euo pipefail

#arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -nostdlib -c -o crt0.o crt0.c
rustc -C opt-level=2 -Z no-landing-pads --target thumbv7em-none-eabi -g --emit obj -L libcore-thumbv7em -o main.o main.rs
arm-none-eabi-ld -T layout.ld -o crt0.elf main.o
arm-none-eabi-objcopy -O ihex -R .eeprom crt0.elf crt0.hex
echo "Reset teensy now"
teensy-loader-cli -w --mcu=mk20dx256 crt0.hex

