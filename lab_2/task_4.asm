%include "io64.inc"

section .rodata
    a: dq 3.0                  ; константа a
    x: dq 4.0                  ; константа x
    y: dq 0.85                ; константа y
    msg_yes db "1", 0          ; сообщение "да"
    msg_no db "0", 0           ; сообщение "нет"

section .text
global main

main:
    mov rbp, rsp             

    ; 1. Вычисляем a * x
    fld qword [a]              ; st(0) = a
    fld qword [x]              ; st(0) = x, st(1) = a
    fmul                       ; st(0) = a * x

    ; 2. Вычисляем cos(a * x)
    fcos                       ; st(0) = cos(a * x)

    ; 3. Сравниваем с y
    fld qword [y]              ; st(0) = y, st(1) = cos(a * x)
    fcomip st0, st1            ; сравниваем y и cos(a * x)
    fstp st0                   ; очищаем стек

    ; 4. Выводим результат
    ja .no                     ; если y > cos(a * x), перейти к "нет"
    PRINT_STRING msg_yes       ; иначе выводим "1"
    jmp .exit

.no:
    PRINT_STRING msg_no        ; иначе выводим "1"

.exit:
    ; Завершение программы
    mov rax, 60               
    xor rdi, rdi            
    ret
