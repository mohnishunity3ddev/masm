option casemap:none

.code
arith proc
    push rbp
    mov rbp, rsp

    xor rcx, rdx            ; t1 = x^y
    lea rax, [r8 + r8*2]    ; t2 = 3*z
    sal rax, 4              ; t2 = 16 * 3z = 48*z
    and rcx, 0f0f0f0fh      ; t3 = t1 & 0x0f0f0f0f
    sub rax, rcx            ; t4 = t2 - t3

    pop rbp
    ret
arith endp

main proc
    sub rsp, 40
    mov rcx, 1234h
    mov rdx, 5678h
    mov r8,  10
    call arith
    
    add rsp, 40
    xor eax, eax
    ret
main endp
end