option casemap:none
externdef printf:proc

.data
    num1 dd 100
    msg db "Fibonacci(%d) is %lld.", 0ah, 0
    of db "overflow for %d!", 0ah, 0

.code
fact proc
    push rbp        ; caller-saved.
    push rbx        ; caller-saved.
    mov rbp, rsp
    sub rsp, 32

    mov rax, 1
    cmp ecx, 2
    jle d1

    sub ecx, 2
    mov r8d, 0      ; int i = 0 { init }
    mov r9, 1       ; int p2 = 1
    mov r10, 1      ; int p1 = 1

l1:
    mov rax, r10    ; s = p1
    add rax, r9     ; s = p1+p2
    jo overflow
    mov r9, r10     ; p2 = p1
    mov r10, rax    ; p1 = s
    inc r8d         ; i++
    cmp r8d, ecx    ; compare i:n
    jl l1           ; if ( i < n ) loop back to l1.
    add ecx, 2
d1:
    mov r12, rax     ; save s ; r12-r15 are callee-saved. saved across function calls.
    mov r13d, ecx    ; save n
    lea rcx, msg     ; first arg
    mov edx, r13d    ; second arg
    mov r8, r12      ; third arg
    call printf
    mov rax, r12
    jmp d2
overflow:
    add ecx, 2
    mov edx, ecx
    lea rcx, of
    call printf
    mov rax, 0
d2:
    add rsp, 32
    pop rbx
    pop rbp
    ret
fact endp

main proc
    mov ebx, 1      ; ebx is callee saved - saved across function calls.

l2:
    mov ecx, ebx
    call fact
    test rax, rax
    jz d3
    inc ebx
    cmp ebx, dword ptr [num1]
    jle l2
d3:
    xor eax, eax
    ret
main endp
end