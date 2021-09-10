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
    mov [BOOT_DRIVE], dl
    mov bx, hello_zig
    call print

    ;Load kernel sector
    pusha
    mov dl, [BOOT_DRIVE]
    mov bx, 0x1000      ; Where to place read sectors 
    mov ah, 0x02        ; Select disk function
    mov al, 0x20        ; How many sectors to read.
    mov ch, 0x00        ; Cylinder 0
    mov dh, 0x00        ; Head 0
    mov cl, 0x02        ; Start reading from second sector, since first sector is the bootloader.
    int 0x13
    jc disk_error
    cmp al, 0x20
    jne disk_error2
    popa

    ;Get vbe info
    pusha 
    mov ax, 0x4f01
    mov cx, 0x0118
    push es
    mov di, 0x1000
    int 0x10
    pop es
    cmp ax, 0x004f
    je vbe_info_done
    mov bx, VBE_ERROR
    call print
    jmp $
    vbe_info_done:
    popa

    ;Set VBE Mode
    pusha 
    mov ax, 0x4f02
    mov bx, 0x4118
    int 0x10
    cmp ax, 0x004f
    je vbe_set_done
    mov bx, VBE_ERROR
    call print
    jmp $

    vbe_set_done:
    popa
    

    ; mov bx, DONE_PRINTING
    ; call print

    ;jmp $

    cli
    lgdt [gdt_descriptor]


    mov eax, cr0            ; set first bit of control register
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:init_pm    ; do a far jump to clear pipeline


[bits 16]

disk_error:
    mov bx, DISK_ERROR
    call print
    jmp $

disk_error2:
    mov bx, DISK_READ_MISMATCH
    call print
    jmp $


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

  
    call 0x1200              ; Hopefully call kernel
    jmp $


PM_MSG db "Successfully in 32 bit mode !",0
BOOT_DRIVE db 0
DISK_ERROR db "There was a disk error !",0
DISK_READ_MISMATCH db "Could not read all sectors !", 0
DONE_PRINTING db "DONE PRINTING", 0

VBE_ERROR db "VBE ERROR OCCURED", 0


%include 'print.asm'
%include 'gdt.asm'
%include 'print_pm.asm'


[bits 16]


;pad to 510 bytes
times 510-($-$$) db 0;


;Magic number makes the sector bootable
dw 0xaa55

