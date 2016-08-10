flash: blink.hex
	@echo "### Reset teensy now"
	teensy-loader-cli -w --mcu=mkl26z64 $<

blink.hex: blink.elf
	arm-none-eabi-objcopy -O ihex -R .eeprom $< $@

blink.elf: blink.o layout.ld
	arm-none-eabi-ld -T layout.ld -o $@ $<

blink.o: blink.s Makefile
	arm-none-eabi-as -g -mcpu=cortex-m0plus -mthumb -o $@ $<

