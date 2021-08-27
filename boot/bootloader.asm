;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                             ;
;              PONG OS BOOT LOADER            ;
;                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[bits 16]
section .bootloader


; Setup stack
mov bp, 0x9000
mov sp, bp

switch:
    mov bx, hello_zig
    call print

    cli
    lgdt [gdt_descriptor]


    mov eax, cr0            ; set first bit of control register
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:init_pm    ; do a far jump to clear pipeline




[bits 32]
init_pm:  ; do initializations for protected mode

    mov ax, DATA_SEG
    mov ds, ax              
    mov ss, ax              ; set new data segment register value
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; update stack base
    mov esp, ebp

   ; Health check
    mov ebx, PM_MSG
    call print_string_pm
    jmp $


PM_MSG db "Successfully in 32 bit mode !",0


%include 'print.asm'
%include 'gdt.asm'
%include 'print_pm.asm'

[bits 32]
[extern main]

[bits 16]


;pad to 510 bytes
times 510-($-$$) db 0;


;Magic number makes the sector bootable
dw 0xaa55

