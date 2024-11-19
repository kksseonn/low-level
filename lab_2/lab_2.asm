%include "io64.inc"

section .data
    x: dd 1.9               ; Вещественное число для округления
    a: dd 0.5               ; Константа для уравнения
    b: dd 1.0               ; Константа для уравнения
    y: dd 2.0               ; Координата y для проверки условия
    exp_input: dd 1.0       ; Входное значение для экспоненты
    half: dd 0.5            ; Значение 0.5 для приближенных вычислений
    two: dd 2.0             ; Константа 2.0 для операций

section .bss
    result: resd 1          ; Результат округления
    exp_result: resd 1      ; Результат экспоненты
    tan_result: resd 1      ; Результат для tan(x + a)
    cosh_result: resd 1     ; Результат для cosh(x - a)

section .text
global main

; Установка режима округления вниз
set_round_toward_zero:
    sub rsp, 8
    fstcw [rsp]                 ; Сохранить контрольное слово
    movzx eax, word [rsp]       ; Получить младшие 16 бит
    and eax, 0xF3FF             ; Сбросить поле RC (режим округления)
    or eax, 0x0400              ; Установить округление вниз
    mov [rsp], ax               ; Записать обратно
    fldcw [rsp]                 ; Загрузить обновленное контрольное слово
    add rsp, 8
    ret

; Приближенное вычисление экспоненты с использованием ряда Тейлора
calculate_exponential:
    fld dword [exp_input]       ; Загружаем x
    fld1                         ; Загружаем 1
    fadd                         ; Результат = 1 + x
    fld dword [exp_input]       ; Загружаем x снова
    fmul st0, st0               ; x^2
    fld dword [half]            ; Загружаем 0.5
    fmul                         ; x^2 / 2
    fadd                         ; Результат += x^2 / 2
    fstp dword [exp_result]     ; Сохранить результат
    ret

; Приближенное вычисление гиперболического косинуса
calculate_cosh:
    fld dword [x]               ; Загрузить x
    fsub dword [a]              ; x - a
    fmul st0, st0               ; (x - a)^2
    fld dword [half]            ; 0.5
    fmul                         ; (x - a)^2 / 2
    fld1                         ; Загрузить 1
    fadd                         ; cosh(x - a) ≈ 1 + (x - a)^2 / 2
    fstp dword [cosh_result]    ; Сохранить результат
    ret

; Основная программа
main:
    mov rbp, rsp; for correct debugging
    ; Задание 1: Округление числа вниз
    call set_round_toward_zero   ; Установка округления вниз
    fld dword [x]                ; Загрузить вещественное число
    fist dword [result]          ; Округлить до целого
    mov eax, [result]

    ; Задание 2: Приближенное вычисление экспоненты
    call calculate_exponential
    fld dword [exp_result]
    NEWLINE

    ; Задание 3: Решение уравнения log2(tan(x + a)) = b
    fld dword [b]
    fld1                         ; Загрузить 1 в стек
    fld dword [two]              ; Загрузить 2 в стек
    fyl2x                        ; 2^b
    fld dword [x]
    fadd dword [a]               ; x + a
    fptan                        ; Вычислить tan(x + a)
    fstp st0                     ; Убираем лишний результат (1.0)
    fcomip st0, st1              ; Сравнить tan(x + a) и 2^b
    fstsw ax                     ; Сохранить состояние
    sahf                         ; Перенести флаги
    jbe tan_condition_met        ; Если условие выполнено, перейти

    ; Условие не выполнено
    PRINT_STRING "0"
    NEWLINE
    jmp next_check

tan_condition_met:
    PRINT_STRING "1"
    NEWLINE

next_check:
    ; Задание 4: Проверка условия y ≤ cosh(x - a)
    call calculate_cosh          ; Вычислить cosh(x - a)
    fld dword [y]
    fld dword [cosh_result]
    fcomip st0, st1              ; Сравнить y с cosh(x - a)
    fstsw ax                     ; Сохранить состояние
    sahf                         ; Перенести флаги
    jbe cosh_condition_met       ; Если y ≤ cosh(x - a), перейти

    ; Условие не выполнено
    PRINT_STRING "0"
    NEWLINE
    jmp end_program

cosh_condition_met:
    PRINT_STRING "1"
    NEWLINE

end_program:
    xor eax, eax                 ; Завершение программы
    ret
