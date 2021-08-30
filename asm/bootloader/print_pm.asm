
[bits 32]
VIDEO_MEMORY equ 0xb8000

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY
    mov ah, 0x0f

    .printchar:
    mov al, [ebx]
    cmp al, 0
    je .done

    mov [edx], ax

    add edx, 2
    inc ebx

    jmp .printchar

    .done:
        popa
        ret

