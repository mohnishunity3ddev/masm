option casemap:none
externdef printf:PROC

.data
    message db 'Hello, World!', 0Ah, 0

.code
main PROC
    ; Preserve the stack alignment
    push rbp
    mov rbp, rsp
    sub rsp, 32  ; Allocate shadow space for function calls
    
    ; Call printf
    lea rcx, message
    call printf

    ; Clean up the stack
    add rsp, 32
    pop rbp

    ; Exit the process
    xor ecx, ecx  ; Exit code 0
    ret
main ENDP

END