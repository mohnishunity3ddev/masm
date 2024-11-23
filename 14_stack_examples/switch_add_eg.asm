option casemap:none
externdef printf:proc

.data
    string db "(1057 - 534)*(1057 + 534) = %lld.", 0ah, 0

; comment @
; long swap_add(long *xp, long *yp)
; {
;     long x = *xp;
;     long y = *yp;
;     *xp = y;
;     *yp = x;
;     return x + y;
; } @
.code
swap_add proc
    push rbp
    mov rbp, rsp

    ;; doing the actual swap.
    mov r8, qword ptr [rcx]         ; *xp
    mov r9, qword ptr [rdx]         ; *yp
    mov qword ptr [rcx], r9         ; *xp = y
    mov qword ptr [rdx], r8         ; *yp = x

    mov rax, r8
    add rax, r9                     ; return val x + y
    pop rbp
    ret
swap_add endp

; long caller()
; {
;     long arg1 = 534;
;     long arg2 = 1057;
;     long sum = swap_add(&arg1, &arg2);
;     long diff = arg1 - arg2;
;     return sum * diff;
; }
caller proc
    sub rsp, 16
    mov qword ptr [rsp+8], 1057     ; arg2 in rsp + 8
    mov qword ptr [rsp], 534        ; arg1 in rsp
    lea rcx, [rsp]                  ; &arg1
    lea rdx, [rsp+8]                ; &arg2
    call swap_add

    mov r8, rax                     ; sum = result from swap_add
    mov rax, qword ptr [rsp]        ; get arg1
    sub rax, qword ptr [rsp + 8]    ; get diff
    imul rax, r8                    ; result = diff * sum

    add rsp, 16
    ret
caller endp

main proc
    call caller
    sub rsp, 40
    lea rcx, string
    mov rdx, rax
    call printf

    add rsp, 40
    xor eax, eax
    ret
main endp


END