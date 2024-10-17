option casemap:none
externdef printf:proc

.data
    msg db "Result of arith(%lld) is %lld.", 0ah, 0
    n1 dq 100

.code
arith proc                      ; i64 arith(i64 x) { return ((x<0) ? (x+15) : (x)) / 16; }
    push rbp
    mov rbp, rsp

    lea rax, [rcx + 15]         ; r <- x + 15
    test rcx, rcx
    cmovns rax, rcx             ; if (x > 0) r = x
    sar rax, 4                  ; r = r / 16

    pop rbp
    ret
arith endp

main proc
    mov rbp, rsp
    sub rsp, 40

    mov rcx, qword ptr [n1]
    call arith

    lea rcx, msg
    mov rdx, qword ptr [n1]
    mov r8, rax
    call printf

    add rsp, 40
    xor eax, eax
    ret
main endp
end