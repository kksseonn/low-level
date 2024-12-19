section .data
    a dd 8.0                               ; Значение a
    x dd 6.0                               ; Значение x
    b dd 3.0                               ; Значение b
    c dd 2.0                               ; Значение c
    y dd 0.0                               ; Результат y

section .text
global main

main:
    fld dword [a]          
    fld dword [x]         
    fsub                   
    fld dword [b]       
    fmul              
    fld dword [c]         
    fdiv                  
    fstp dword [y]
    xor eax, eax 
    ret
    
    
       