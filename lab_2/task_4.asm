%include "io64.inc"

section .rodata
<<<<<<< HEAD
    a: dq 3.0                  ; константа a
    x: dq 4.0                  ; константа x
    y: dq 0.843                ; константа y
=======
    a: dq 1.0                  ; константа a
    x: dq 3.0                  ; константа x
    y: dq 7.72                ; константа y
    e: dq 2.71828              ; значение e
    two: dq 2.0                ; константа 2
>>>>>>> be6efe46df7b98f4602dad96e3ad3725cccca52d
    msg_yes db "1", 0          ; сообщение "да"
    msg_no db "0", 0           ; сообщение "нет"

section .text
global main

main:
    mov rbp, rsp             

<<<<<<< HEAD
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
=======
    ; 1. Вычисляем x - a
    fld qword [x]              
    fld qword [a]              
    fsub                       ; st(0) = x - a

    ; 2. Вычисляем e^(x-a)
    fld qword [e]              
    fyl2x
    fld1
    fld st1
    fprem
    f2xm1
    fadd
    fscale
    fstp st1
    
    ; 3. Вычисляем e^(-(x-a))
    fld1                       
    fdiv st0, st1              

    ; 4. Суммируем e^(x-a) и e^(-(x-a))
    fadd st0, st1              

    ; 5. Делим результат на 2
    fld qword [two]            
    fdiv                       

    ; 6. Сравниваем с y
    fld qword [y]              ; st(0) = y, st(1) = cosh(x - a)
    fcomip st0, st1            ; сравниваем cosh(x - a) и y
    fstp st0                   ; очищаем стек

    ; 7. Выводим результат
    ja .no                     
    PRINT_STRING msg_yes       ; если у < cosh выводим "0"
>>>>>>> be6efe46df7b98f4602dad96e3ad3725cccca52d
    jmp .exit

.no:
    PRINT_STRING msg_no        ; иначе выводим "1"

.exit:
    ; Завершение программы
    mov rax, 60               
    xor rdi, rdi            
    ret
