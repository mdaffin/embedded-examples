#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

OUTDIR=out
mkdir -p "${OUTDIR}"
rm -f "${OUTDIR}"/*
arm-none-eabi-as -g -mcpu=cortex-m4 -mthumb -o "${OUTDIR}"/crt0.o crt0.s
arm-none-eabi-ld -T layout.ld -o "${OUTDIR}"/crt0.elf "${OUTDIR}"/crt0.o
arm-none-eabi-objcopy -O ihex -R .eeprom "${OUTDIR}"/crt0.elf "${OUTDIR}"/crt0.hex
arm-none-eabi-objcopy -O binary -R .eeprom "${OUTDIR}"/crt0.elf "${OUTDIR}"/crt0.bin
echo "Reset teensy now"
teensy-loader-cli -w --mcu=mk20dx256 "${OUTDIR}"/crt0.hex
