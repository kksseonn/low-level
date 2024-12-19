section .data
    a1 dd 0.2
    a2 dd 10
    a3 dq 1.0
    a4 dq 1.0

section .text
global main
extern access5 ; -l:C:\ida\easy.a

main:
    ; access5(0.2, 10, 1.0, 1.0); access5(float, int, double, float)
    ;    float E = 0.0001;
    ;    bool cl = false;
    ;
    ;    float xmm6 = a1;
    ;    a1 = std::trunc(a1);
    ;
    ;    cl = ((xmm6 - a1) - 0.2 < E) && (a2 / a3) > a4;
    sub rsp, 40
    
    movss xmm0, [a1]    ; Загружаем a1 (float) в xmm0
    mov edx, [a2]       ; Загружаем a2 (int) в edx
    movsd xmm2, [a3]    ; Загружаем a3 (double) в xmm2
    movss xmm3, [a4]    ; Загружаем a4 (float) в xmm3
    
    call access5
    
    add rsp, 40
    xor rax, rax
    ret
