section .data
    msg db 'The sum of the array is: ', 0
    newline db 0xA, 0
    buffer times 12 db 0

section .bss
    arr resd 100
    sum resd 1

section .text
    global sum_array

sum_array:
    ; Initialize the array with values 1 to 100
    mov ecx, 1
    lea edi, [arr]

init_array:
    mov [edi], ecx
    add edi, 4
    inc ecx
    cmp ecx, 101
    jle init_array

    ; Calculate the sum of the array
    xor ecx, ecx
    lea edi, [arr]
    mov edx, 100

sum_loop:
    add ecx, [edi]
    add edi, 4
    dec edx
    jnz sum_loop

    mov [sum], ecx

    ; Print result message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, 24
    int 0x80

    ; Convert sum to string and print
    mov eax, [sum]
    mov esi, buffer
    call int_to_string

    ; Print the sum
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 6
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Return to caller instead of exit
    ret

int_to_string:
    ; Convert integer in EAX to ASCII in the buffer
    mov edi, esi
    mov ecx, 0

convert_loop:
    xor edx, edx
    mov ebx, 10
    div ebx
    add dl, '0'
    mov [edi], dl
    inc edi
    inc ecx
    test eax, eax
    jnz convert_loop

    ; Reverse the string
    dec edi
    lea esi, [buffer]

reverse_string:
    cmp esi, edi
    jge end_reverse
    mov al, [esi]
    mov bl, [edi]
    mov [esi], bl
    mov [edi], al
    inc esi
    dec edi
    jmp reverse_string

end_reverse:
    ret

