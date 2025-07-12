section .data
    num1 dd 7
    num2 dd 7
    result dd 0

section .text
    global asm_main
    extern print_int

asm_main:
    ; Step 1: Compute the sum of num1 and num2
    mov eax, [num1]
    add eax, [num2]
    mov [result], eax

    ; Step 2: Call print_int to print the result
    mov eax, [result]
    call print_int

    ; Step 3: Return from asm_main
    ret
