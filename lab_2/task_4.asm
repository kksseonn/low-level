%include "io64.inc"

section .data
    a dq 1.0                   ; константа a
    x dq 3.0                   ; константа x
    y dq 1.762                 ; константа y
    e dq 2.718281828459045     ; значение e (двойная точность)
    two dq 2.0                 ; константа 2

section .rodata
    msg_yes db "1", 0          ; сообщение "да"
    msg_no db "0", 0           ; сообщение "нет"

section .text
global main

main:
    mov rbp, rsp               ; для корректной отладки

    ; 1. Вычисляем x - a
    fld qword [x]              ; st(0) = x
    fld qword [a]              ; st(0) = a, st(1) = x
    fsub                       ; st(0) = x - a

    ; Сохраняем x - a
    fst st1                    ; st(1) = x - a

    ; 2. Вычисляем e^(x - a)
    fld st1                    ; st(0) = x - a
    fld qword [e]              ; st(0) = e, st(1) = x - a
    fyl2x                      ; st(0) = e^(x - a)

    ; Сохраняем e^(x - a)
    fst st2                    ; st(2) = e^(x - a)

    ; 3. Вычисляем e^(-(x - a))
    fld st1                    ; st(0) = x - a
    fchs                       ; st(0) = -(x - a)
    fld qword [e]              ; st(0) = e, st(1) = -(x - a)
    fyl2x                      ; st(0) = e^(-(x - a))

    ; Сохраняем e^(-(x - a))
    fst st3                    ; st(3) = e^(-(x - a)

    ; 4. Считаем (e^(x-a) + e^(-(x-a))) / 2
    fld st2                    ; st(0) = e^(x - a)
    fadd st3                   ; st(0) = e^(x - a) + e^(-(x - a))
    fld qword [two]            ; st(0) = 2
    fdiv                       ; st(0) = (e^(x - a) + e^(-(x - a))) / 2

    ; 5. Сравниваем с y
    fld qword [y]              ; st(0) = y
    fxch st1                   ; st(1) = cosh(x - a), st(0) = y
    fcomip st0, st1            ; сравниваем y с cosh(x - a)
    fstp st0                   ; очищаем стек

    ; 6. Выводим результат
    ja .no                     ; если y > cosh(x - a), перейти к "нет"
    PRINT_STRING msg_yes       ; иначе выводим "1"
    jmp .exit

.no:
    PRINT_STRING msg_no        ; выводим "0"

.exit:
    ; Завершение программы
    mov rax, 60                ; syscall: exit
    xor rdi, rdi               ; статус 0
    ret
