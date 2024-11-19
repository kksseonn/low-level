%include "io64.inc"

section .data
    a dq 1.0             ; константа a
    x dq 65.0             ; константа x
    y dq 1.5             ; константа y

section .rodata
    msg_yes db "1", 0     ; сообщение "да"
    msg_no db "0", 0      ; сообщение "нет"

section .text
global main

main:
    ; Загружаем x и y в FPU
    fld qword [x]         ; st(0) = x
    fld qword [a]         ; st(0) = a, st(1) = x
    fsub                  ; st(0) = x - a, st(1) = x

    ; Вычисляем cosh(x - a)
    fld st0               ; дублируем (x-a), st(0) = x-a, st(1) = x-a
    fmul                  ; st(0) = (x-a)^2
    fld1                  ; st(0) = 1, st(1) = (x-a)^2
    fadd                  ; st(0) = (x-a)^2 + 1
    fsqrt                 ; st(0) = sqrt((x-a)^2 + 1)

    ; Проверка условия y <= cosh(x - a)
    fld qword [y]         ; st(0) = y, st(1) = cosh(x-a)
    fcomi st0, st1        ; сравниваем y с cosh(x-a)
    ja .output_no         ; если y > cosh(x-a), выводим "0"

    ; Условие выполняется, выводим "1"
    .output_yes:
    PRINT_STRING msg_yes
    jmp .exit

    ; Условие не выполняется, выводим "0"
    .output_no:
    PRINT_STRING msg_no

    ; Завершение программы
    .exit:
    finit                 ; очистка стека FPU
    mov rax, 60           ; syscall: exit
    xor rdi, rdi          ; код возврата 0
    ret
