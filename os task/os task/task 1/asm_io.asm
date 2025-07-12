section .data
    newline db 10, 0

section .bss
    num_buffer resb 12

section .text
    global print_int
    global print_string

print_int:
    pusha
    
    cmp eax, 0
    je print_zero

    mov ebx, 10
    mov ecx, num_buffer
    add ecx, 10
    mov byte [ecx], 10
    mov byte [ecx + 1], 0

reverse_loop:
    dec ecx
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    test eax, eax
    jnz reverse_loop

    mov edx, num_buffer
    sub edx, ecx
    add edx, 1
    
    mov eax, 4
    mov ebx, 1
    mov ecx, ecx
    int 0x80

    popa
    ret

print_zero:
    mov byte [num_buffer], '0'
    mov byte [num_buffer + 1], 10
    
    mov eax, 4
    mov ebx, 1
    mov ecx, num_buffer
    mov edx, 2
    int 0x80

    popa
    ret

print_string:
    pusha
    
    mov eax, 4
    mov ebx, 1
    mov ecx, ebx
    mov edx, 100
    int 0x80
    
    popa
    ret
