#![feature(lang_items,no_std)]
#![no_std]
#![crate_type="staticlib"]

//extern crate core;

#[lang="stack_exhausted"] extern fn stack_exhausted() {}
#[lang="eh_personality"] extern fn eh_personality() {}
#[lang="panic_fmt"]
pub fn panic_fmt(_fmt: &core::fmt::Arguments, _file_line: &(&'static str, usize)) -> !
{
    loop {}
}

#[no_mangle]
pub unsafe fn __aeabi_unwind_cpp_pr0() -> ()
{
    loop {}
}

extern {
    fn led_on();
    fn led_off();
    fn delay(ms: i32);
}

pub fn led_on_w() {
    unsafe {
        led_on();
    }
}

pub fn led_off_w() {
    unsafe {
        led_off();
    }
}

pub fn delay_w(ms: i32) {
    unsafe {
        delay(ms);
    }
}

#[no_mangle]
pub fn rust_loop() {
    loop {
        led_on_w();
        delay_w(1000);
        led_off_w();
        delay_w(1000);
    }
}
