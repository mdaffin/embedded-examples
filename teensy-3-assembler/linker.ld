OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

EXTERN(_vectors);

MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 512K
    SRAM (W!RX) : ORIGIN = 0x20000000, LENGTH = 64K
}

SECTIONS 
{
	.text :
	{
		CREATE_OBJECT_SYMBOLS
		_vectors = .;
		*(.vectors)
		*(.startup)
		*(.text)
		*(.text.*)
	} > FLASH

}
