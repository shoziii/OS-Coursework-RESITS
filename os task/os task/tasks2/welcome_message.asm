section .data
    prompt_name db 'Enter your name: ', 0
    prompt_num db 'Enter number of times to print welcome message (50-100): ', 0
    error_msg db 'Error: number must be between 50 and 100.', 0
    welcome_msg db 'Welcome, ', 0
    newline db 0xA, 0

section .bss
    name resb 100
    num_times resb 4

section .text
    global welcome_message

welcome_message:
    ; Ask for name
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_name
    mov edx, 18
    int 0x80

    ; Read user input for name
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 100
    int 0x80

    ; Ask for number of times to print the message
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_num
    mov edx, 58
    int 0x80

    ; Read the number input
    mov eax, 3
    mov ebx, 0
    mov ecx, num_times
    mov edx, 4
    int 0x80

    ; Convert string to integer
    xor ebx, ebx
    mov ecx, num_times

convert_loop:
    cmp byte [ecx], 0xA
    je done_convert
    cmp byte [ecx], '0'
    jl print_error
    cmp byte [ecx], '9'
    jg print_error
    movzx edx, byte [ecx]
    sub edx, '0'
    imul ebx, ebx, 10
    add ebx, edx
    inc ecx
    jmp convert_loop

done_convert:
    cmp ebx, 50
    jl print_error
    cmp ebx, 100
    jg print_error
    mov edi, ebx

print_welcome:
    mov eax, 4
    mov ebx, 1
    mov ecx, welcome_msg
    mov edx, 8
    int 0x80

    ; Print the name
    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, 100
    int 0x80

    ; Newline after the name
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    dec edi
    cmp edi, 0
    jg print_welcome

    ; Return to caller instead of exit
    ret

print_error:
    ; Print error message
    mov eax, 4
    mov ebx, 1
    mov ecx, error_msg
    mov edx, 42
    int 0x80

    ; Return to caller instead of exit
    ret
