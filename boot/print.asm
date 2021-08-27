
[bits 16]
print:
    push ax,
    push bx,
    mov ah, 0x0e
    .printchar:
        cmp  byte [bx], byte 0 
        je .done
        mov al, [bx]
        int 0x10
        inc bx
        jmp .printchar

    .done:
        pop bx
        pop ax
        ret

str: db 'Hello World!',0
hello_zig: db 'Hello, Zig!', 0

