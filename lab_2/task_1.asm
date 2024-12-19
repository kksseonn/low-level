%include "io64.inc"

section .data
    x: dd 8.2               
    
section .bss
    result_x87: resd 1      
    result_sse: resd 1      

section .text
global main

set_round_downward:
    sub rsp, 8                ; Выделяем 8 байт в стеке для временного хранения регистра состояния FPU
    fstcw [rsp]               ;сохраняем текущее состояние
    movzx eax, word [rsp]     ; Загружаем младшие 16 бит из сохранённого состояния в eax
    and eax, 0xF3FF           ; Сбрасываем 10 и 11 биты
    or eax, 0x0400            ; Устанавливаем новый 10 бит
    mov [rsp], ax             
    fldcw [rsp]               ; Загружаем обратно
    add rsp, 8                ; Освобождаем память
    ret                       

; Округление через SSE 
round_with_sse:
    movd xmm0, dword [x]      
    roundss xmm0, xmm0, 1     ; Округляем значение в `xmm0`
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
    PRINT_DEC 4, result_sse
    ret
