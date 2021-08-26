SECTIONS
{

.bootloader 0x7c00 : {
    KEEP( *(.bootloader))
    }

.text : { KEEP(*(.text)) }


.data : { *(.data) }

.bss : { *(.bss) }
}