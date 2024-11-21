%include "io64.inc"

section .data
    x: dd 8.6                
    
section .bss
    result_x87: resd 1      ; Результат округления с использованием x87
    result_sse: resd 1      ; Результат округления с использованием SSE

section .text
global main

; Установка режима округления вниз для x87
set_round_downward:
    sub rsp, 8                ; Выделяем 8 байт в стеке для временного хранения регистра состояния FPU
    fstcw [rsp]               
    movzx eax, word [rsp]     ; Загружаем младшие 16 бит из сохранённого состояния в eax
    and eax, 0xF3FF           ; Сбрасываем режим округления
    or eax, 0x0400            ; Устанавливаем новый режим округления
    mov [rsp], ax             
    fldcw [rsp]               ; Загружаем обратно в x87.
    add rsp, 8                ; Освобождаем 8 байт стека.
    ret                       

; Округление через SSE 
round_with_sse:
    movd xmm0, dword [x]      
    roundss xmm0, xmm0, 0     ; Округляем значение в `xmm0`
    cvtss2si eax, xmm0        ; Преобразуем в целое
    mov [result_sse], eax     
    ret                       

main:
    mov rbp, rsp                

    ; Реализация с использованием x87
    call set_round_downward    
    fld dword [x]              
    fistp dword [result_x87]   
    PRINT_DEC 4, result_x87    
    NEWLINE                    
    
    ; Реализация с использованием SSE
    call round_with_sse         ; Выполнить округление через SSE
    PRINT_DEC 4, result_x87
    ret
