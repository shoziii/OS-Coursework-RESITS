section .data
    num1 dd 20
    num2 dd 7

section .text
    global asm_main
    extern print_int

asm_main:
    mov eax, [num1]
    sub eax, [num2]
    push eax
    call print_int
    add esp, 4
    ret
