option casemap:none

.code
shift_4_right_n proc
    mov rax, rcx
    sal rax, 4
    mov cl, dl
    sar rax, cl
    ret
shift_4_right_n endp

main proc
    mov rcx, -4
    mov rdx, 3
    call shift_4_right_n

    xor eax, eax
    ret
main endp
end