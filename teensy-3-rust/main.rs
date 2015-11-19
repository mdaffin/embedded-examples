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

#[no_mangle]
pub unsafe fn __aeabi_unwind_cpp_pr1() -> ()
{
    loop {}
}

extern {
    fn delay(ms: i32);
}

//pub const GPIOC_PDOR: u32 = 0x400FF080 // GPIOC_PDOR - page 1334,1335
//macro_rules! GPIOC_PDOR: {() => (0x400FF080 as u16);} // GPIOC_PDOR - page 1334,1335

pub fn led_on_w() {
    let mut GPIOC_PDOR = 0x400FF080 as *mut u32; // GPIOC_PDOR - page 1334,1335
    unsafe {
        *GPIOC_PDOR = 0x20;
    }
}

pub fn led_off_w() {
    let mut GPIOC_PDOR = 0x400FF080 as *mut u32; // GPIOC_PDOR - page 1334,1335
    unsafe {
        *GPIOC_PDOR = 0x0;
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
