
SECTIONS
{

. = 0x7c00;
.bootloader :
     AT (0x0) 
     {
          KEEP( *(.bootloader));
          end_of_boot = ABSOLUTE(.);
      }

. = 0x1000;
.kernel : AT ( ADDR(.bootloader) + SIZEOF(.bootloader) )
    {
         KEEP( *(.header));
         . = ALIGN(512);
         KEEP( *(.text*));
         KEEP( *(.data*));
         KEEP( *(.rodata*));
         end_of_text = ABSOLUTE(.);
    } = 0x0

/* Pad to 3MB */
. = 0x2DC6C0 - end_of_text;
.padding : {
     LONG(0);
}



}


