%include "io64.inc"

section .data
    x: dd 5.6               ; Вещественное число для округления
    round_mode: dd 1        ; Режим округления для SSE (1 = вниз)
    
section .bss
    result_x87: resd 1      ; Результат округления с использованием x87
    result_sse: resd 1      ; Результат округления с использованием SSE

section .text
global main

; Установка режима округления вниз для x87
set_round_downward:
    sub rsp, 8
    fstcw [rsp]                 ; Сохранить текущее контрольное слово
    movzx eax, word [rsp]       ; Получить младшие 16 бит
    and eax, 0xF3FF             ; Сбросить поле RC (режим округления)
    or eax, 0x0400              ; Установить округление вниз (RC = 10)
    mov [rsp], ax               ; Записать обновленное контрольное слово
    fldcw [rsp]                 ; Загрузить обновленное контрольное слово
    add rsp, 8
    ret

; Округление через SSE 
round_with_sse:
    movd xmm0, dword [x]        ; Загрузить число в регистр XMM0
    mov eax, [round_mode]       ; Загрузить режим округления (1 = вниз) в EAX
    ; Округление вниз с использованием SSE
    roundss xmm0, xmm0, 0       ; Округление к ближайшему целому
    cvtss2si eax, xmm0          ; Преобразовать результат в целое
    mov [result_sse], eax       ; Сохранить результат в result_sse
    ret

main:
    mov rbp, rsp                ; Для отладки корректной базы стека

    ; Реализация с использованием x87
    call set_round_downward     ; Установить режим округления вниз
    fld dword [x]               ; Загрузить вещественное число
    fistp dword [result_x87]    ; Округлить и сохранить результат в result_x87
    PRINT_DEC 4,result_x87
    NEWLINE
    ; Реализация с использованием SSE
    call round_with_sse         ; Выполнить округление через SSE
    PRINT_DEC 4,result_x87

    ; Точка завершения программы
    ret
