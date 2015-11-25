# Rust on the teensy 3.1

This works:

```bash
cargo build -v --target thumbv7em-none-eabi
arm-none-eabi-objcopy -O ihex -R .eeprom target/thumbv7em-none-eabi/debug/test blink-debug.hex
```

This produces and empty hex file:

```bash
cargo build -v --target thumbv7em-none-eabi --release
arm-none-eabi-objcopy -O ihex -R .eeprom target/thumbv7em-none-eabi/release/test blink-release.hex
```

