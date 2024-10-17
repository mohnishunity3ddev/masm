option casemap:none
externdef printf:proc

.data
    range dd 1000
    msg db "sum of even numbers between 0 and %d is: %d", 0ah, 0

.code
even_sum proc
    push rbp
    push rbx
    push r12

    mov r12d, ecx           ; save the range

    xor eax, eax            ; sum = 0
    mov edx, 0              ; int i = 0;
l1:
    mov ebx, edx            ; tmp  = i
    and ebx, 1
    test ebx, ebx
    jnz l2                  ; if i is odd, continue to next iteration
    add eax, edx            ; sum += i (i is guaranteed to be even here)

l2:
    inc edx                 ; ++i
    cmp edx, r12d
    jl l1                   ; if (i < 10) loop back

    sub rsp, 28h
    lea rcx, msg
    mov edx, r12d
    mov r8d, eax
    call printf
    add rsp, 28h

    pop r12
    pop rbx
    pop rbp
    ret
even_sum endp

main proc
    mov ecx, dword ptr [range]
    call even_sum

    xor eax, eax
    ret
main endp
end