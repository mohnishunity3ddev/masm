option casemap:none
externdef printf:proc

.data
    mulString db "[Multiply Result(128 bits)]:=  [0x%016llX]:[0x%016llX]", 0ah, 0

    idivStr64 db "[Integer Divide Result(64 bits)]:=  [Quotient]:[Remainder] = [%lld]:[%lld]", 0ah, 0
    udivStr64 db "[Unsigned Divide Result(64 bits)]:=  [Quotient]:[Remainder] = [%llu]:[%llu]", 0ah, 0

.code
mult_128 proc ; x -> rcx, y -> rdx, res_high -> *[r8], res_low -> rax
    ; Prologue: preserve non-volatile registers and set up the stack frame
    push rbp                ; Save rbp
    mov rbp, rsp            ; Set rbp as the base pointer. set the start of the current function.
    sub rsp, 20h            ; Allocate 32 bytes (stack alignment + local variables)

    ; Do the 128 bit multiply op
    mov rax, rcx            ; x
    mov rbx, rdx            ; y
    imul rbx                ; mul rbx and rax. store high 64 bits in rdx, low 64 bits in rax
    mov r12, rax            ; save the lower bits of the result. rax can be changed by the callee.
    mov qword ptr [r8], rdx ; Store high 64 bits into memory location pointed by r8

    ; prepare for printf to print the result
    lea rcx, mulString      ; Load the address of the format string into rcx - first arg for printf
                            ; rdx already has high bits of mul result - second arg for printf
    mov r8, rax             ; low bits of mul result - third arg for printf
    call printf
    mov rax, r12            ; restore the lower bits of the mul result back in rax. r12 is guaranteed to not change in the printf call.

    ; Epilogue: restore non-volatile registers and clean up the stack
    ; pop rbx
    add rsp, 20h
    pop rbp
    ret
mult_128 endp

idiv_64 proc
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov rax, rcx    ; dividend stored in rcx
    mov r12, rdx    ; save the divisor
    cqo             ; sign extend rax into rdx. all 0's if rax > 0, all 1's if rax < 0
    idiv r12        ; quotient in rax, remainder in rdx.

    mov r12, rax        ; save quotient in r12
    mov r13, rdx        ; save remainder in r13
    lea rcx, idivStr64
    mov rdx, r12
    mov r8, r13
    call printf

    add rsp, 32
    pop rbp
    ret
idiv_64 endp

udiv_64 proc
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov rax, rcx    ; dividend stored in rcx
    mov r12, rdx    ; save the divisor
    xor rdx, rdx    ; zero extend rdx for unsigned division
    div r12         ; quotient in rax, remainder in rdx.

    mov r12, rax        ; save quotient in r12
    mov r13, rdx        ; save remainder in r13
    lea rcx, udivStr64
    mov rdx, r12
    mov r8, r13
    call printf

    add rsp, 32
    pop rbp
    ret
udiv_64 endp

main proc
    push rbp
    mov rbp, rsp
    sub rsp, 8

    sub rsp, 40
    mov rcx, 0ffcffefffffafff8h         ; 64 bit value inside rax
    mov rdx, 0aeaeaeae0f0f0f0fh         ; 64 bit value inside rbx
    lea r8, [rbp]                       ; mem address to store high bits of 128 bit mul result.
    call mult_128

    mov rcx, -1234                       ; dividend
    mov rdx, -13                         ; divisor -> 1234 / 13
    call idiv_64

    mov rcx, 1234                       ; dividend
    mov rdx, 13                         ; divisor -> 1234 / 13
    call udiv_64

    add rsp, 40

    add rsp, 8
    pop rbp
    xor eax, eax
    ret
main endp
end