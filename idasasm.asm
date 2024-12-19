%include "io64.inc"
section .data
    a1 dd 2.2
    a2 dd 20
    a3 dq 5.0
    a4 dd 2.0
section .text
global CMAIN
CEXTERN access5

main:
    mov rbp, rsp; for correct debugging
;movaps  xmm6, xmm0
;mov     ebx, edx
;movapd  xmm8, xmm2
;movaps  xmm7, xmm3

    ; Подготовка стека
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32
    
    ; Загружаем значения в регистры
    movss   xmm0, dword[a1]  ; Загружаем a1 (float) в xmm0
    mov     edx, [a2]        ; Загружаем a2 (int) в edx
    movsd   xmm2, qword[a3]  ; Загружаем a3 (double) в xmm2
    movss   xmm3, dword[a4]  ; Загружаем a4 (float) в xmm3
    
    call access5
    
    add     rsp, 32
    leave
    xor     rax, rax
    ret