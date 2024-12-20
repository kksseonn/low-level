section .data
    a1 dd 0.2
    a2 dd 10
    a3 dq 1.0
    a4 dq 1.0

section .text
global main
extern access5 ; -l:C:\ida\easy.a

main:
    sub rsp, 40
    
    movss xmm0, [a1]   
    mov edx, [a2]       
    movsd xmm2, [a3]    
    movss xmm3, [a4]    
    
    call access5
    
    add rsp, 40
    xor rax, rax
    ret
