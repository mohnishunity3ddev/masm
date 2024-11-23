option casemap:none
externdef printf:proc

.data
    sstr db "factorial(%d) is %lld.", 0ah, 0
    num dw 14

.code
fact proc
    ; n in cx
    push rbp
    mov bp, cx          ; save n
    mov rax, 1          ; long result = 1
    cmp cx, 1           ; compare n:1
    jle end_label       ; if (n <= 1) return 1
    sub cx, 1           ; n -= 1
    call fact           ; call fact(n-1)
    movzx rdx, bp       ; zero extend n to 64 bit register
    imul rax, rdx       ; long result = n * fact(n-1)
end_label:
    pop rbp             ; restore rbp
    ret                 ; return result
fact endp

main proc
    mov r15w, 0

lbegin:
    mov cx, r15w
    call fact

    sub rsp, 40
    lea rcx, sstr
    movzx rdx, r15w
    mov r8, rax
    call printf
    add rsp, 40

    inc r15w
    cmp r15w, num
    jle lbegin

lend:
    ret
main endp
END