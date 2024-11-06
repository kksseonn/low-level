%include "io64.inc"

section .data
    P dd 499
    Q dd 547
    N dd 0
    prompt db "Enter seed (e.g., a number like 3, 7, 10, 100): ", 0
    error_msg db "Seed should be coprime with ", 0
    newline db 10, 0

section .bss
    seed resd 1
    x resd 1
    result resd 1
    count resd 1

section .text
global main

main:
    mov rbp, rsp; for correct debugging
    ; Вычисляем N
    mov eax, [P]
    imul eax, [Q]
    mov [N], eax

    ; Ввод seed с использованием GET_UDEC
    PRINT_STRING prompt
    GET_UDEC 4, [seed]  ; Читаем 4-байтовое беззнаковое число
    PRINT_UDEC 4, seed
    NEWLINE

    ; Проверка на взаимную простоту
    mov eax, [seed]
    mov ebx, [P]
    xor edx, edx
    div ebx
    test edx, edx
    jz seed_not_coprime

    mov ebx, [Q]
    mov eax, [seed]
    xor edx, edx
    div ebx
    test edx, edx
    jz seed_not_coprime

    ; Основной цикл
    mov eax, [seed]
    imul eax, eax
    mov ebx, [N]
    xor edx, edx
    div ebx
    mov [x], eax

    mov dword [count], 100

cycle_start:
    mov eax, [x]
    imul eax, eax
    mov ebx, [N]
    xor edx, edx
    div ebx
    mov [x], eax

    mov eax, [x]
    and eax, 0xFFFF
    PRINT_UDEC 4, eax  ; Печатаем результат как 4-байтовое беззнаковое число
    NEWLINE

    dec dword [count]
    jnz cycle_start

    ; Завершение программы
    mov eax, 1          ; sys_exit
    xor ebx, ebx
    ret

seed_not_coprime:
    PRINT_STRING error_msg
    mov eax, [N]
    PRINT_UDEC 4, eax    ; Печатаем N как 4-байтовое беззнаковое число
    NEWLINE
    jmp main