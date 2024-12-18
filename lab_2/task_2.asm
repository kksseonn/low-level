section .data
<<<<<<< HEAD
    a dd 8.0                               ; Значение a
    x dd 6.0                               ; Значение x
    b dd 3.0                               ; Значение b
    c dd 2.0                               ; Значение c
    y dd 0.0                               ; Результат y
=======
    exp_input dd 3.0                       ; Показатель степени
    exp_result dd 0.0                      ; Результат
    coefficients dd 1.0, 1.0, 0.5, 0.16666667, 0.04166667 ; Коэффициенты для 0!, 1!, 2!, 3! и 4!
>>>>>>> be6efe46df7b98f4602dad96e3ad3725cccca52d

section .text
global main

main:
    mov rbp, rsp                           ; Для корректной отладки

    ; Вычисление (a - x)
    movss xmm0, dword [a]                  ; xmm0 = a
    subss xmm0, dword [x]                  ; xmm0 = a - x

    ; Вычисление (a - x) * b
    mulss xmm0, dword [b]                  ; xmm0 = (a - x) * b

    ; Вычисление y = ((a - x) * b) / c
    divss xmm0, dword [c]                  ; xmm0 = ((a - x) * b) / c

    ; Сохранение результата
<<<<<<< HEAD
    movss dword [y], xmm0                  ; Сохранить y в память

    ; Завершение программы
    mov eax, 60                            ; Системный вызов exit
    xor edi, edi                           ; Код завершения 0
    ret                                    ; Вызов системного вызова
=======
    movss dword [exp_result], xmm1          
    ret

main:
    mov rbp, rsp
    call calculate_exponential_sse
    mov eax, 60                             
    xor edi, edi                            
    ret                                
>>>>>>> be6efe46df7b98f4602dad96e3ad3725cccca52d
