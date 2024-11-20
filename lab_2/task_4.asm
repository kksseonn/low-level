%include "io64.inc"

section .rodata
    a: dq 1.0                  ; константа a
    x: dq 3.0                  ; константа x
    y: dq 3.826                ; константа y
    e: dq 2.718281828459045    ; значение e
    two: dq 2.0                ; константа 2
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

    ; 2. Вычисляем e^(x-a)
    fld qword [e]              ; st(0) = e, st(1) = x - a
    fyl2x
    fld1
    fld st1
    fprem
    f2xm1
    fadd
    fscale
    fstp st1
    
    ; 3. Вычисляем e^(-(x-a))
    fld1                       ; st(0) = 1, st(1) = e^(x-a)
    fdiv st0, st1              ; st(0) = e^(-(x-a))

    ; 4. Суммируем e^(x-a) и e^(-(x-a))
    fadd st0, st1              ; st(0) = e^(x-a) + e^(-(x-a))

    ; 5. Делим результат на 2
    fld qword [two]            ; st(0) = 2, st(1) = e^(x-a) + e^(-(x-a))
    fdiv                       ; st(0) = cosh(x - a)

    ; 6. Сравниваем с y
    fld qword [y]              ; st(0) = y, st(1) = cosh(x - a)
    fcomip st0, st1            ; сравниваем cosh(x - a) и y
    fstp st0                   ; очищаем стек

    ; 7. Выводим результат
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
