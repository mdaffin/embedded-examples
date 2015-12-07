git clone https://github.com/rust-lang/rust rustcore
git -C rustcore checkout $(rustc --version -v | awk '/commit-hash/ {print $2}')

mkdir libcore-thumbv7em
rustc -C opt-level=2 -Z no-landing-pads --target thumbv7em-none-eabi -g rustcore/src/libcore/lib.rs --out-dir libcore-thumbv7em
rustc -C opt-level=2 -Z no-landing-pads --target thumbv7em-none-eabi -g --emit obj -L libcore-thumbv7em -o blink.o blink.rs
arm-none-eabi-ld -T layout.ld blink.o -o blink.elf
