%include "io64.inc"

section .data
    P         dd 499                          ; Константа P
    Q         dd 547                          ; Константа Q
    N         dd 0                            ; Переменная для N
    prompt    db "Enter seed (e.g., a number like 3, 7, 10, 100): ", 0 ; Сообщение для ввода

section .bss
    seed      resd 1                           ; Переменная для хранения seed
    x         resd 1                           ; Текущее значение x
    count     resd 1                           ; Счётчик цикла

section .text
    global main

main:
    ; Вычисляем N = P * Q
    mov eax, [P]                               ; Загружаем P в регистр eax
    imul eax, [Q]                              ; Умножаем P на Q
    mov [N], eax                               ; Сохраняем результат в N

    ; Ввод seed
    PRINT_STRING prompt                        ; Выводим сообщение для ввода
    GET_UDEC 4, [seed]                         ; Читаем 4-байтовое беззнаковое число (seed)
    PRINT_UDEC 4, [seed]                       ; Печатаем введённое значение seed
    NEWLINE                                    ; Печатаем новую строку
    
    ; Основной цикл
    mov eax, [seed]                            ; Загружаем seed в регистр eax
    imul eax, eax                              ; x = seed * seed
    mov ebx, [N]                               ; Загружаем N в регистр ebx
    xor edx, edx                               ; Обнуляем edx перед делением
    div ebx                                     ; x = (seed * seed) % N
    mov [x], edx                               ; Сохраняем результат в x (остаток от деления)

    mov dword [count], 100                    ; Инициализация счётчика (100 итераций)

cycle_start:
    mov eax, [x]                               ; Загружаем текущее значение x
    imul eax, eax                              ; x = x * x
    mov ebx, [N]                               ; Загружаем N в регистр ebx
    xor edx, edx                               ; Обнуляем edx перед делением
    div ebx                                     ; x = (x * x) % N
    mov [x], edx                               ; Сохраняем результат в x (остаток от деления)

    mov eax, [x]                               ; Загружаем текущее значение x
    and eax, 0xFFFF                            ; result = x & 0xFFFF
    PRINT_UDEC 4, eax                         ; Печатаем результат как 4-байтовое беззнаковое число
    NEWLINE                                   ; Печатаем новую строку

    dec dword [count]                          ; Уменьшаем счётчик на 1
    jnz cycle_start                            ; Переход к началу цикла, если count > 0

    ; Завершение программы
    mov eax, 1                                 
    xor ebx, ebx                              
    ret

