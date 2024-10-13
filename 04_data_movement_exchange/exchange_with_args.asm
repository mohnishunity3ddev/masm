OPTION CASEMAP:NONE
externdef printf:proc

.data
    str1 db "numbers are num1 = %d and num2 = %d.", 0ah, 0
    str2 db "after exchange num1 = %d and num2 = %d.", 0ah, 0

.code
exchange proc
    mov rcx, [rcx]  ; Load value from first address
    mov rdx, [rdx]  ; Load value from second address
    mov [rsp+16], rcx  ; Store first value in return slot
    mov [rsp+8], rdx ; Store second value in return slot
    ret
exchange endp

main proc
    sub rsp, 56                 ; 32 bytes(calling convention) + 16 bytes for the arguments + 8 to align stack.
    mov qword ptr [rsp],    32  ; Second number
    mov qword ptr [rsp+8], -12  ; First number

    lea rcx, str1
    mov edx, dword ptr [rsp+8]
    mov r8d, dword ptr [rsp]
    sub rsp, 32
    call printf
    add rsp, 32

    lea rcx, [rsp]
    lea rdx, [rsp+8]
    call exchange

    lea rcx, str2               ; Pointer to format string
    mov edx, dword ptr [rsp+8]    ; First number (after swap)
    mov r8d, dword ptr [rsp]  ; Second number (after swap)
    call printf

    ; Clean up the stack
    add rsp, 56
    xor eax, eax
    ret
main endp
end