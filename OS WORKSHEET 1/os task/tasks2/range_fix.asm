calculate_sum:
    ; Convert user input (1-100) to array indices (0-99)
    dec ebx  ; start index in array
    dec ecx  ; end index in array
    
    ; Ensure start <= end
    cmp ebx, ecx
    jle do_sum
    xchg ebx, ecx  ; swap if needed
    
do_sum:
    ; Calculate sum from array[start] to array[end] inclusive
    xor eax, eax      ; sum = 0
    mov esi, ebx      ; current index = start
    
sum_loop:
    movzx edx, byte [array + esi]  ; get array[current]
    add eax, edx                   ; sum += array[current]
    inc esi                        ; current++
    cmp esi, ecx                   ; compare current with end
    jle sum_loop                   ; continue if current <= end
    
sum_done:
