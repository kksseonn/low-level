section .data
    exp_input dd 1.0             ; Входное значение для exp(x)
    exp_result dd 0.0            ; Результат
    coefficients dd 1.0, 0.5     ; Коэффициенты 1 и 0.5 (1 и 1/2)

section .text
global main

; Функция для приближенного вычисления экспоненты
calculate_exponential_sse:
    movss xmm0, dword [exp_input]   ; Загружаем x в xmm0
    movaps xmm1, xmm0                ; Копируем x в xmm1
    addss xmm1, dword [coefficients] ; x + 1

    mulss xmm0, xmm0                 ; x^2
    mulss xmm0, dword [coefficients + 4] ; x^2 * 0.5
    addss xmm1, xmm0                 ; x + 1 + x^2 / 2

    movss dword [exp_result], xmm1   ; Сохранить результат
    ret

main:
    ; Вызов реализации через SSE
    call calculate_exponential_sse

    ; Завершение программы
    mov eax, 60                      ; Системный вызов exit
    xor edi, edi                     ; Код завершения 0
    ret
