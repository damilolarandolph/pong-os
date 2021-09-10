[bits 32]
[extern main]


section .header
vbe_info: 
times 8 dw 0

section .text

global _start

_start:

call main

jmp $
