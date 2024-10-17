option casemap:none
externdef printf:proc

.data
    num1 dd 30
    msg1 db "%d! is %d.", 0ah, 0
    msg2 db "%d! is %lld.", 0ah, 0
    of db "overflow occured for %d!.", 0ah, 0
    msg32 db "32 bit integer Factorial Range: ", 0ah, 0
    msg64 db 0ah, "64 bit integer Factorial Range: ", 0ah, 0

.code
fact proc
    push rbp
    mov rbp, rsp

    mov eax, 1              ; result = 1
    do_while:
    imul eax, ecx           ; result = result*n
    jo overflow             ; if overflow occured, jump to end of the function
    dec ecx                 ; n = n-1
    cmp ecx, 1              ; compare n:1
    jg do_while                 ; if (n>1) loop back
    pop rbp
    ret
    overflow:
    xor eax, eax            ; make result = 0 if overflow occurred
    pop rbp
    ret
fact endp

fact64 proc
    push rbp
    mov rbp, rsp

    mov rax, 1              ; result = 1
    mov ecx, ecx            ; zero-extend ecx into rcx
    do_while:
    imul rax, rcx           ; result = result*n
    jo overflow             ; if overflow occured, jump to end of the function
    dec ecx                 ; n = n-1
    cmp ecx, 1              ; compare n:1
    jg do_while                 ; if (n>1) loop back
    pop rbp
    ret
    overflow:
    xor eax, eax            ; make result = 0 if overflow occurred
    pop rbp
    ret
fact64 endp

main proc
    sub rsp, 40

    lea rcx, msg32
    call printf

    mov r12d, 1
    wl1:
    mov ecx, r12d    ; calculate factorial
    call fact
    test eax, eax
    jz f1
    lea rcx, msg1
    mov edx, r12d
    mov r8d, eax
    call printf
    inc r12d
    cmp r12d, dword ptr [num1]
    jle wl1
    jmp done1
    f1:
    lea rcx, of
    mov edx, r12d
    call printf
    done1:

    ; Print out 64 bit factorials ...
    lea rcx, msg64
    call printf

    mov r12d, 1
    wl2:
    mov ecx, r12d
    call fact64
    test eax, eax
    jz f2
    lea rcx, msg2
    mov edx, r12d
    mov r8d, eax
    call printf
    inc r12d
    cmp r12d, dword ptr [num1]
    jle wl2
    jmp done2
    f2:
    lea rcx, of
    mov edx, r12d
    call printf
    done2:
    add rsp, 40
    xor eax, eax
    ret
main endp
end