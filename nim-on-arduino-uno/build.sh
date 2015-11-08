#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

nim c -d:release --gc:none --cpu:avr --os:standalone --parallelBuild:1 --passC:-Os --passC:-DF_CPU=16000000UL --passC:-mmcu=atmega328p --passL:-mmcu=atmega328p --verbosity:2 hello.nim
avr-objcopy -O ihex -R .eeprom hello hello.hex
avrdude -F -V -c arduino -p ATMEGA328P -P $1 -b 115200 -U flash:w:hello.hex
