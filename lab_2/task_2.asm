section .data
    a dd 8.0                               ; Значение a
    x dd 6.0                               ; Значение x
    b dd 3.0                               ; Значение b
    c dd 2.0                               ; Значение c
    y dd 0.0                               ; Результат y

section .text
global main

main:
    ; Вычисление (a - x)
    movss xmm0, dword [a]                 
    subss xmm0, dword [x]                  
    ; Вычисление (a - x) * b
    mulss xmm0, dword [b]                  

    ; Вычисление y = ((a - x) * b) / c
    divss xmm0, dword [c]                 

    ; Сохранение результата
    movss dword [y], xmm0                 

                       ; Системный вызов exit
    xor eax, eax                          ; Код завершения 0
    ret                              
    