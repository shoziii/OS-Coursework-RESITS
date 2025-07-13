section .data
    array db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, \
          11, 12, 13, 14, 15, 16, 17, 18, 19, 20, \
          21, 22, 23, 24, 25, 26, 27, 28, 29, 30, \
          31, 32, 33, 34, 35, 36, 37, 38, 39, 40, \
          41, 42, 43, 44, 45, 46, 47, 48, 49, 50, \
          51, 52, 53, 54, 55, 56, 57, 58, 59, 60, \
          61, 62, 63, 64, 65, 66, 67, 68, 69, 70, \
          71, 72, 73, 74, 75, 76, 77, 78, 79, 80, \
          81, 82, 83, 84, 85, 86, 87, 88, 89, 90, \
          91, 92, 93, 94, 95, 96, 97, 98, 99, 100
    prompt_start db "Enter the starting index (1-100): ", 0
    prompt_end db "Enter the ending index (1-100): ", 0
    invalid_msg db "Error: Invalid range or input!", 0xA, 0
    result_msg db "The sum of the range is: ", 0
    newline db 0xA, 0

section .bss
    start_buffer resb 10
    end_buffer resb 10
    sum resd 1
    buffer resb 12
    start_val resd 1
    end_val resd 1

section .text
    global range_sum

range_sum:
    ; Prompt for starting index
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_start
    mov edx, 34
    int 0x80

    ; Read starting index
    mov eax, 3
    mov ebx, 0
    mov ecx, start_buffer
    mov edx, 10
    int 0x80
    
    ; Convert start input to integer
    mov esi, start_buffer
    call str_to_int
    cmp eax, -1
    je invalid_input
    mov [start_val], eax
    
    ; Prompt for ending index
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_end
    mov edx, 32
    int 0x80

    ; Read ending index
    mov eax, 3
    mov ebx, 0
    mov ecx, end_buffer
    mov edx, 10
    int 0x80
    
    ; Convert end input to integer
    mov esi, end_buffer
    call str_to_int
    cmp eax, -1
    je invalid_input
    mov [end_val], eax
    
    ; Get the values
    mov ebx, [start_val]
    mov ecx, [end_val]

    ; Validate input range
    cmp ebx, 1
    jl invalid_input
    cmp ebx, 100
    jg invalid_input
    cmp ecx, 1
    jl invalid_input
    cmp ecx, 100
    jg invalid_input
    
    ; Ensure start <= end
    cmp ebx, ecx
    jle calculate_sum
    xchg ebx, ecx

calculate_sum:
    ; Convert user input (1-100) to array indices (0-99)
    dec ebx
    dec ecx
    
    ; Ensure start <= end after conversion
    cmp ebx, ecx
    jle do_sum
    xchg ebx, ecx
    
do_sum:
    ; Calculate sum from array[start] to array[end] inclusive
    xor eax, eax
    mov esi, ebx
    
sum_loop:
    movzx edx, byte [array + esi]
    add eax, edx
    inc esi
    cmp esi, ecx
    jle sum_loop
    
sum_done:
    mov [sum], eax

    ; Print result
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 25
    int 0x80

    ; Convert sum to string
    mov eax, [sum]
    mov ecx, buffer
    call int_to_str

    ; Print the sum
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 12
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ret

invalid_input:
    ; Print error message
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_msg
    mov edx, 29
    int 0x80
    ret

; Convert string to integer (ESI points to string)
; Returns: EAX = number or -1 if error
str_to_int:
    xor eax, eax
    xor ebx, ebx
    
convert_loop:
    mov bl, byte [esi]
    cmp bl, 0xA
    je convert_done
    cmp bl, 0
    je convert_done
    cmp bl, '0'
    jl convert_error
    cmp bl, '9'
    jg convert_error
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc esi
    jmp convert_loop
    
convert_done:
    ret
    
convert_error:
    mov eax, -1
    ret

; Convert integer in EAX to string in ECX
int_to_str:
    push eax
    push ebx
    push edx
    mov edi, ecx
    add edi, 11
    mov byte [edi], 0
    mov ebx, 10
convert_digit:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz convert_digit
    mov ecx, edi
    pop edx
    pop ebx
    pop eax
    ret
