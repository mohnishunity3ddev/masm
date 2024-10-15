option casemap:none
externdef printf:proc

.data
    str1 db "2*(%d) + 4*(%d) + 6*(%d) = (%d).", 0ah, 0
    n1   dd -112
    n2   dd  33
    n3   dd -57

.code
scale proc
    ; x in ecx, y in edx, z in r8d

    ; Setup the stack frame
    push rbp                    ; preserve caller's base pointer
    mov rbp, rsp                ; store start of the current stack frame for this one.
    ; now we can access local variables in the current stack by adding to this rbp.

    ; lea destination_reg, [base_reg + index_reg*scale + displacement_reg] scale can be either 1,2,4 or 8.
    ; multiple base registers and/or multiple index registers are NOT allowed.
    lea eax, [ecx + ecx]        ; eax <- 2x.
    lea eax, [eax + edx*4]      ; eax <- 2x + 4y.
    lea edx, [r8d + r8d*2]      ; r8d <- 3z.
    lea eax, [eax + edx*2]      ; return 2x + 4y + 6z stored in eax.

    ; roll back caller's stack frame.
    pop rbp                     ; restore caller's base pointer.
    ret                         ; return 2x + 4y + 6z
scale endp

main proc
    sub rsp, 40             ; shadow space (32 bytes) + align (8 bytes)
    mov ecx, [n1]           ; first arg
    mov edx, [n2]           ; second arg
    mov r8d, [n3]           ; third arg
    call scale

    lea rcx, [str1]         ; First argument: format string address
    mov edx, [n1]           ; Second argument (x)
    mov r8d, [n2]           ; Third argument (y)
    mov r9d, [n3]           ; Fourth argument (z)
    mov [rsp + 32], eax     ; Store the result of scale in fifth arg for printf: 2x + 4y + 6z
    call printf

    add rsp, 40             ; cleanup the stack
    xor eax, eax            ; clear eax register
    ret
main endp
end