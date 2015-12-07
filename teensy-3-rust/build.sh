git clone https://github.com/rust-lang/rust rustcore
git -C rustcore checkout $(rustc --version -v | awk '/commit-hash/ {print $2}')

mkdir libcore-thumbv7em
rustc -C opt-level=2 -Z no-landing-pads --target thumbv7em-none-eabi -g rustcore/src/libcore/lib.rs --out-dir libcore-thumbv7em
#rustc --crate-type=bin --crate-name=blink -C ar=arm-none-eabi-ar -C linker=arm-none-eabi-gcc -C opt-level=2 -Z no-landing-pads --target thumbv7em-none-eabi -g --emit dep-info,link -L libcore-thumbv7em -o blink.elf blink.rs --extern core=libcore-thumbv7em/libcore.rlib
rustc --crate-type=bin --crate-name=blink -C ar=arm-none-eabi-ar -C linker=arm-none-eabi-gcc -Z no-landing-pads --target thumbv7em-none-eabi -g -L libcore-thumbv7em blink.rs --extern core=libcore-thumbv7em/libcore.rlib
