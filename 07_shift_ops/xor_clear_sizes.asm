option casemap:none

.code
arith proc
    xor rax, rax
    xor eax, eax

    xor rcx, rcx
    xor ecx, ecx

    lea rax, 0ah[rax + rcx*4]

    mov rax, 0
    mov eax, 0
    ret
arith endp
end