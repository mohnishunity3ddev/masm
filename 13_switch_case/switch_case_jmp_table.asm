option casemap:none

.code
switch_eg proc
    push rbp
    mov rbp, rsp

    add rdx, -100                           ; Compute index = n-100
    cmp rdx, 6                              ; Compare index:6
    ja default_case                         ; If (n > 106) goto default_case

    lea r11, jump_table                     ; load address of jump_table(array) start
    movsxd rdx, dword ptr [r11 + rdx*4]     ; rdx: address index into the jump_table array
                                            ; (will return a negative 32 bit int) that's why
                                            ; sign extending into 64 bit rdx.
    add r11, rdx                            ; add the neg offset to jmp_table start address
                                            ; to get actual address of the label where the jump will go to
    jmp r11                                 ; unconditionally jump to the address
case_100:
    lea rax, [rcx + rcx*2]                  ; 3*x
    lea rcx, [rcx + rax*4]                  ; val = 13*x
    jmp done                                ; break
case_102:
    add rcx, 10                             ; x = x + 10
case_103:
    add rcx, 11                             ; val = x + 11
    jmp done                                ; break
case_106:
    imul rcx, rcx                           ; val = x * x
    jmp done                                ; break
default_case:
    xor ecx, ecx                            ; val = 0
done:
    mov [r8], rcx                           ; *dest = value
    pop rbp
    ret
jump_table:
    dd case_100 - jump_table                ; case 100:
    dd default_case - jump_table            ; case 101:
    dd case_102 - jump_table                ; case 102:
    dd case_103 - jump_table                ; case 103:
    dd case_106 - jump_table                ; case 104:
    dd default_case - jump_table            ; case 105:
    dd case_106 - jump_table                ; case 106:
switch_eg endp

main proc
    push rbp
    sub rsp, 8

    mov rcx, 10
    mov rdx, 102
    lea r8, qword ptr [rsp + 8]
    call switch_eg

    add rsp, 8
    xor eax, eax
    pop rbp
    ret
main endp


END