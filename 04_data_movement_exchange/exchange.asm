OPTION CASEMAP:NONE
externdef printf:proc

.data
    num1 dd -12
    num2 dd  32
    str1 db "Before exchange num1 = %d and num2 = %d.", 0ah, 0
    str2 db "After exchange num1 = %d and num2 = %d.", 0ah, 0

.code
main proc
    ; print the two numbers prior to the exchange
    sub rsp, 40
    lea rcx, str1
    mov edx, num1
    mov r8d, num2
    call printf
    add rsp, 40

    mov eax, dword ptr [num1]
    mov ebx, dword ptr [num2]
    mov [num1], ebx
    mov [num2], eax

    sub rsp, 40
    lea rcx, str2
    mov edx, num1
    mov r8d, num2
    call printf
    add rsp, 40

    xor eax, eax
    ret
main endp
end