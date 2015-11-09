MEMORY {
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 256K
    RAM  (rwx) : ORIGIN = 0x1FFF8000, LENGTH = 64K /* K20P64M72SF1RM.pdf ( Page: 90 ) */
}

SECTIONS {
    . = 0x00000000;
    .text : {
        KEEP(*(.vectors))
        *(.startup)
        . = 0x400;
        KEEP(*(.flashconfig*)) /* K20P64M72SF1RM.pdf ( Page: 569 ) */
        *(.text)
        *(.text.*)
    } > FLASH

    _estack = ORIGIN(RAM) + LENGTH(RAM); /* stack pointer start */
}
