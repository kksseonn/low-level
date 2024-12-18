section .data
    a dd 8.0                               ; Значение a
    x dd 6.0                               ; Значение x
    b dd 3.0                               ; Значение b
    c dd 2.0                               ; Значение c
    y dd 0.0                               ; Результат y

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
    movss dword [y], xmm0                  ; Сохранить y в память

    ; Завершение программы
    mov eax, 60                            ; Системный вызов exit
    xor edi, edi                           ; Код завершения 0
    ret                                    ; Вызов системного вызова


