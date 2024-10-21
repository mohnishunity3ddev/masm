option casemap:none
externdef printf:proc

.data
    s db "result is %lld.", 0ah, 0

; void proc1(long a1,  long *a1p,
;            int a2,   int *a2p,
;            short a3, short *a3p,
;            char a4,  char *a4p)
; {
;     *a1p += a1;
;     *a2p += a2;
;     *a3p += a3;
;     *a4p += a4;
; }

;* long call_proc()
;* {
;*     long x1 = 1; int x2 = 2;
;*     short x3 = 3; char x4 = 4;
;*     proc1(2, &x1, 3, &x2, 400, &x3, 110, &x4);
;*     return (x1+x2)*(x3-x4);
;* }
; x1 = 1+2 = 3; x2 = 2+3 = 5; x3 = 3+400 = 403; x4 = 110+4 = 114
; (x1+x2) = 8; (x3-x4) = 289
; result = 8 * 289 = 2312

.code
proc1 proc
    ; *a1p += a1
    mov rax, qword ptr [rdx]    ; long t = *a1p (2nd arg in rdx)
    add rax, rcx                ; t += a1 (1st arg in rcx)
    mov qword ptr [rdx], rax    ; *a1p = t

    ; *a2p += a2
    mov eax, dword ptr [r9]     ; int t2 = *a2p (4th arg in r9)
    add eax, r8d                ; t2 += a2 (3rd arg in r8d)
    mov dword ptr [r9], eax     ; *a2p = t2

    lea r8, [rsp+8]             ; save pointer to the start of arguments.
                                ; +8 because return address is at the top of the stack.

    ; *a3p += a3
    mov ax,  word  ptr [r8]     ; short t3 = a3 (a3 is 5th arg)
    mov r11, qword ptr [r8+2]   ; save the addres stored in 6th arg to dereference it later
    add ax,  word  ptr [r11]    ; t3 += *a3p (short *a3p is saved in r11)
    mov word ptr[r11], ax       ; *a3p = t3

    ; *a4p += a4
    mov al,  byte  ptr [r8+10]  ; char t4 = a4 (a4 is 7th arg)
    mov r11, qword ptr [r8+11]  ; save the address in 8th arg to dereference it later.
    add al,  byte  ptr [r11]    ; t4 += *a4p (char *a4p is saved in r11)
    mov byte ptr[r11], al       ; *a4p = t4

    xor eax, eax
    ret
proc1 endp
call_proc proc
    ; there are 4 local variables whose addresses we have to send to the called function.
    ; total number of arguments are 8. 4 we can save in registers and 4 can be in stack.
    ; the current procedure requires stack spack for 4 local + 4 arguments(5th arg in the top of the stack).
    ; total space required is:
    ; last 4 args - a3(short), a3p(short*), a4(char), a4p(char*) -> 2 + 8 + 1 + 8 = 19 bytes
    ; 4 local vars - x1(long), x2(int), x3(short), x4(char) -> 8 + 4 + 2 + 1 = 15 bytes
    ; total stack space required: 19+15 = 34 bytes
    sub rsp, 34
    mov qword ptr [rsp+26], 1        ; 1st local var -> long x1 = 1
    mov dword ptr [rsp+22], 2        ; 2nd local var -> int x2 = 2
    mov word  ptr [rsp+20], 3        ; 3rd local var -> short x3 = 3
    mov byte  ptr [rsp+19], 4        ; 4th local var -> char x4 = 4

    mov word  ptr [rsp], 400         ; 5th arg to proc1 -> short a3 = 400
    lea rcx, [rsp+20]
    mov qword ptr [rsp+2],  rcx      ; 6th arg to proc1 -> short *a3p = &x3
    mov byte  ptr [rsp+10], 110      ; 7th arg to proc1 -> char a4 = 110
    lea rcx, [rsp+19]
    mov qword ptr [rsp+11], rcx      ; 8th arg to proc1 -> byte *a4p = &x4

    mov rcx, 2                       ; 1st arg to proc1 -> long a1 = 2
    lea rdx, [rsp+26]                ; 2nd arg to proc1 -> long *a1p = &x1
    mov r8d, 3                       ; 3rd arg to proc1 -> int a2 = 3
    lea r9,  [rsp+22]                ; 4th arg to proc1 -> int *a2p = &x2

    call proc1

    mov    rax, qword ptr [rsp+26]    ; save x1
    movsxd rdx, dword ptr [rsp+22]    ; save x2 sign extended into rdx
    add    rax, rdx                   ; save x1+x2
    movsx  rcx, word ptr [rsp+20]     ; save x3 sign extended into rcx
    movsx  rdx, byte ptr [rsp+19]     ; save x4 sign extended into rdx
    sub    rcx, rdx                   ; save x3-x4
    ; return (x1+x2) * (x3-x4)
    imul rax, rcx                    ; result = (x1+x2) * (x3-x4)
    add  rsp, 34                     ; cleanup the stack
    ret
call_proc endp

main proc
    call call_proc

    sub rsp, 40
    lea rcx, s
    mov rdx, rax
    call printf
    add rsp, 40

    xor eax, eax
    ret
main endp


END