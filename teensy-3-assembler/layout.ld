MEMORY {
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 512K
    RAM  (rwx) : ORIGIN = 0x1FFF8000, LENGTH = 64K
}

SECTIONS {
    . = 0x00000000;
    .text : {
        KEEP(*(.vectors))
        *(.startup)
        *(.text)
        *(.text.*)
    } > FLASH
}
