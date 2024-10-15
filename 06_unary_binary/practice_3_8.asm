option casemap:none

.code
main proc
    sub rsp, 32
    mov rbp, rsp
    mov qword ptr [rbp], 0ffh           ; 0x100
    mov qword ptr [rbp+8], 0abh         ; 0x108
    mov qword ptr [rbp+16], 13h         ; 0x110
    mov qword ptr [rbp+24], 11h         ; 0x118
    lea rax, [rbp]
    mov rcx, 1
    mov rdx, 3

    add [rax], rcx                      ; add 1 to value stored at rax(0x100)
    sub 8[rax], rdx                     ; subtract 3 from value stored at rax+8 (0x108)

    ; multiply value stored at rax+rdx*8 (0x118) by 16
    lea r9, [rax + rdx*8]
    mov r8, qword ptr [r9]
    imul r8, 16
    mov qword ptr [r9], r8

    inc qword ptr [rax + 16]            ; increment value stored at address rax+16(0x110) by 1
    dec rcx                             ; decrement value at rcx by 1
    sub [rax], rdx                      ; subtract 3 from value stored at rax (0x110)
    
    add rsp, 32
    xor eax, eax
    ret
main endp
end