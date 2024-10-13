OPTION CASEMAP:NONE

.DATA
negNum dd -42 ;; negNum is a dd(define double) a memory address which holds a double word(32 bits) which has value -42.
posNum dd  42

.CODE
main PROC
    ; data movement instructions
    mov eax, 4050h ; store immediate value 0x11223344 into eax
    mov sp, bp
    mov byte ptr [rdi + rcx], al    ;; store 1 byte at al to memory location (rdi+rcx)
    ; mov byte ptr [esp], -17       ;; Store -17 byte in address stored in esp
    ; mov qword ptr [rbp - 12], rax ;; Store value stored at rax (8 bytes) to address stored at rbp-12
    ; movabs rax, 0x11223344

    ; some data movement instructions modify the upper bytes to zero, some dont
    mov rax, 11223344556677h        ;; RAX = 0x0011 2233 4455 6677
    mov dl, 0AAh                    ;; RDX = 0x0011 2233 4455 66AA
    mov al, dl                      ;; RAX = 0x0011 2233 4455 66AA
    movsx rax, dl                   ;; RAX = 0xFFFF FFFF FFFF FFAA (Sign Extended Move)
    movzx rax, dl                   ;; RAX = 0x0000 0000 0000 00AA (Zero Extended Move)
    mov r8d, 11223344h
    movsx r9, r8w                  ;; movsx: when dest is quadword then src can be byte or word
    movsx r9, r8b                  ;; movsx: when dest is quadword then src can be byte or word
    movsxd r9, r8d                 ;; for double to quad or double to double movsxd is used for sign extension.
    mov r9, r8
    mov rax, -1                     ;; rax = 0xffff ffff ffff ffff
    mov eax, dword ptr posNum       ;; this will automatically zero-extend the whole rax register. rax = 0x0000 0000 0000 002a
                                    ;; Not the case for example in mov al, byte ptr posNum, in this case rax will be 0xffff ffff ffff ff2a
    mov eax, dword ptr negNum       ;; store the value stored at address (pointed to by "negNum") in this case -42 into eax
    cdqe                            ;; eax = 0x0000-0000-ffff-ffd6, cdqe converts this double word(32 bits) to quad word(64 bits) sign extended.
                                    ;; rax becomes = 0xffff-ffff-ffff-ffd6 which is still -42.


    ;; practice problem 3.3
    ; mov byte ptr [ebx], 0fh
    ; mov qword ptr [rsp], rax
    ; movw (%rax),4(%rsp)
    ; movb %al,%sl
    ; movq %rax,$0x123
    ; movl %eax,%rdx
    ; movb %si, 8(%rbp)
    xor eax, eax                    ;; clear
    ret
main ENDP
END