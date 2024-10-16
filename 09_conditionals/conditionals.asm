option casemap:none
externdef printf:proc

.data
    lt_count dd 0
    gte_count dd 0
    msg db "absolute value of difference between %d and %d is: %d", 0ah, 0

.code
abs_diff proc ; rcs <- x; rdx <- y
    push rbp
    mov rbp, rsp

    cmp rcx, rdx                    ; compare x : y -> compute x - y and check the flags
    jge greater                     ; jump to greater if x >= y
    ; x < y
    add dword ptr lt_count, 1       ; lt_count++
    mov rax, rdx                    ; rax = y
    sub rax, rcx                    ; rax = y - x
    pop rbp
    ret
greater: ; x >= y
    add dword ptr gte_count, 1      ; gte_count++
    mov rax, rcx                    ; rax = x
    sub rax, rdx                    ; rax = x - y
    pop rbp
    ret
abs_diff endp

main proc
    sub rsp, 40

    mov rcx, 2
    mov rdx, 4
    call abs_diff
    lea rcx, msg
    mov rdx, 2
    mov r8, 4
    mov r9, rax
    call printf

    mov rcx, 12
    mov rdx, 10
    call abs_diff
    lea rcx, msg
    mov rdx, 12
    mov r8, 10
    mov r9, rax
    call printf

    mov rcx, 331
    mov rdx, 1022
    call abs_diff
    lea rcx, msg
    mov rdx, 331
    mov r8, 1022
    mov r9, rax
    call printf

    add rsp, 40

    xor eax, eax
    ret
main endp
end