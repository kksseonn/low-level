section .data
    exp_input dd 3.0                       ; Показатель степени
    exp_result dd 0.0                      ; Результат
    coefficients dd 1.0, 1.0, 0.5, 0.16666667, 0.04166667 ; Коэффициенты для 0!, 1!, 2!, 3! и 4!

section .text
global main

; Функция для приближенного вычисления экспоненты
calculate_exponential_sse:
    ; Инициализация
    movss xmm0, dword [exp_input]           ; Загружаем x в xmm0
    movss xmm1, dword [coefficients]        ; Загружаем 1 (0!) в xmm1

    ; x^1 / 1!
    movaps xmm2, xmm0                       ; Копируем x в xmm2
    mulss xmm2, dword [coefficients + 4]    ; xmm2 = x / 1
    addss xmm1, xmm2                        ; xmm1 = 1 + x / 1

    ; x^2 / 2!
    movaps xmm2, xmm0                       ; Копируем x в xmm2
    mulss xmm2, xmm0                        ; xmm2 = x^2
    mulss xmm2, dword [coefficients + 8]    ; xmm2 = x^2 / 2
    addss xmm1, xmm2                        ; xmm1 += x^2 / 2

    ; x^3 / 3!
    movaps xmm2, xmm0                       ; Копируем x в xmm2
    mulss xmm2, xmm0                        ; xmm2 = x^3
    mulss xmm2, xmm0                        ; xmm2 = x^3
    mulss xmm2, dword [coefficients + 12]   ; xmm2 = x^3 / 6
    addss xmm1, xmm2                        ; xmm1 += x^3 / 6

    ; x^4 / 4!
    movaps xmm2, xmm0                       ; Копируем x в xmm2
    mulss xmm2, xmm0                        ; xmm2 = x^4
    mulss xmm2, xmm0                        ; xmm2 = x^4
    mulss xmm2, xmm0                        ; xmm2 = x^4
    mulss xmm2, dword [coefficients + 16]   ; xmm2 = x^4 / 24
    addss xmm1, xmm2                        ; xmm1 += x^4 / 24

    ; Сохранение результата
    movss dword [exp_result], xmm1          
    ret

main:
    mov rbp, rsp
    call calculate_exponential_sse
    mov eax, 60                             
    xor edi, edi                            
    ret                                
