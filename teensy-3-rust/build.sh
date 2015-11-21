#!/bin/bash
set -euo pipefail

rustc -C opt-level=2 -Z no-landing-pads --target thumbv7em-none-eabi -g --emit obj -L libcore-thumbv7em -o blink.o blink.rs
arm-none-eabi-ld -T layout.ld -o blink.elf blink.o
arm-none-eabi-objcopy -O ihex -R .eeprom blink.elf blink.hex
echo "Reset teensy now"
teensy-loader-cli -w --mcu=mk20dx256 blink.hex

