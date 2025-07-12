global loader

MAGIC_NUMBER equ 0x1BADB002
FLAGS equ 0x0
CHECKSUM equ -(MAGIC_NUMBER + FLAGS)

section .text
align 4

dd MAGIC_NUMBER
dd FLAGS
dd CHECKSUM

loader:
    mov eax, 0xB8000
    mov ebx, eax
    mov word [ebx], 0x0F41
    add ebx, 2
    mov word [ebx], 0x0F42
    add ebx, 2
    mov word [ebx], 0x0F43
    add ebx, 2
    mov word [ebx], 0x0F44
    add ebx, 2
    mov word [ebx], 0x0F45
    add ebx, 2
    mov word [ebx], 0x0F46
    mov eax, 0xCAFEBABE
    cli
    hlt
    jmp $
