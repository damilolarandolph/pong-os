;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                             ;
;              GDT INITALIZATION              ;
;                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Reference: https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf

[bits 16]
gdt_start:


gdt_null:   ; Mandatory null descriptor
    dd 0x0
    dd 0x0

gdt_code:
    dw 0xffff       ; Lower segment limit
    dw 0x0          ; Lower base address
    db 0x0          ; Upper first byte of base address
    db 10011010b    ; 1st set of flags
    db 11001111b    ; 2nd set of flags, Upper Limit (16 - 19)
    db 0x0          ; Upper second byte of base address

gdt_data:
    dw 0xffff       ; Lower segment limit
    dw 0x0          ; Lower base address
    db 0x0          ; Upper first byte of base address
    db 10010010b    ; 1st set of flags
    db 11001111b    ; 2nd set of flags, Upper Limit (16 - 19)
    db 0x0          ; Upper second byte of base address

gdt_end:



gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

    CODE_SEG equ gdt_code - gdt_start
    DATA_SEG equ gdt_data - gdt_start



