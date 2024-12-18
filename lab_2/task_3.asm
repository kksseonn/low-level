section .rodata 
    a: dd 1.0       ; Коэффициент a
    b: dd 4.0       ; Коэффициент b
    c: dd 3.0       ; Коэффициент c
    k: dd 4.0       ; Коэффициент k

section .bss
<<<<<<< HEAD
    x1: resd 1      ; Первый корень
    x2: resd 1      ; Второй корень
    D:  resd 1      ; Дискриминант
=======
x: resd 1
>>>>>>> be6efe46df7b98f4602dad96e3ad3725cccca52d

section .text
global main

main:
<<<<<<< HEAD
    mov rbp, rsp    ; Для корректной отладки

    ; Вычисление дискриминанта
    fld dword [b]         ; ST(0) = b
    fmul st0, st0         ; ST(0) = b^2
    fld dword [a]         ; ST(0) = a, ST(1) = b^2
    fld dword [c]         ; ST(0) = c, ST(1) = a, ST(2) = b^2
    fmul st0, st1         ; ST(0) = a * c, ST(1) = b^2
    fld dword [k]         ; ST(0) = k, ST(1) = a * c, ST(2) = b^2
    fmul st0, st1         ; ST(0) = k * a * c, ST(1) = b^2
    fsub st3, st0         ; ST(0) = b^2 - k * a * c
    fxch st3
    fstp dword [D]        ; Сохранение дискриминанта

    ; Проверка дискриминанта
    fld dword [D]         ; Загрузка дискриминанта
    ftst                  ; Сравнение с 0
    fstsw ax
    sahf
    jp no_real_roots      ; Переход при D < 0
    
    ; Вычисление sqrt(D)
    fsqrt                ; ST(0) = sqrt(D)
=======
    mov rbp, rsp    
    fld dword [b]   ;ST(0) = b
    fld1            ;ST(0) = 1, ST(1) = b
    
    fld st1         ;  дублируем показатель в стек
    fprem           ;  получаем дробную часть
    f2xm1           ; возводим в дробную часть показателя
    fadd            ; прибавляем 1 из стека
    fscale          ;ST(0) = 2^b, ST(1) = b
    fstp st1
>>>>>>> be6efe46df7b98f4602dad96e3ad3725cccca52d

    ; Вычисление x1 = (-b + sqrt(D)) / (2a)
    fld dword [b]        ; ST(0) = b, ST(1) = sqrt(D)
    fchs                 ; ST(0) = -b, ST(1) = sqrt(D)
    fadd                 ; ST(0) = -b + sqrt(D)
    fld dword [a]        ; ST(0) = a, ST(1) = -b + sqrt(D)
    fld1                 ; ST(0) = 1, ST(1) = a, ST(2) = -b + sqrt(D)
    fadd                 ; ST(0) = 2a, ST(1) = -b + sqrt(D)
    fdiv                 ; ST(0) = x1
    fstp dword [x1]      ; Сохранение x1

    ; Вычисление x2 = (-b - sqrt(D)) / (2a)
    fld dword [b]        ; ST(0) = b
    fchs                 ; ST(0) = -b
    fld dword [D]        ; ST(0) = sqrt(D), ST(1) = -b
    fsqrt                ; ST(0) = sqrt(D), ST(1) = -b
    fsub                 ; ST(0) = -b - sqrt(D)
    fld dword [a]        ; ST(0) = a, ST(1) = -b - sqrt(D)
    fld1                 ; ST(0) = 1, ST(1) = a, ST(2) = -b - sqrt(D)
    fadd                 ; ST(0) = 2a, ST(1) = -b - sqrt(D)
    fdiv                 ; ST(0) = x2
    fstp dword [x2]      ; Сохранение x2

    jmp end_program

no_real_roots:
    ; Если дискриминант меньше 0, установить x1 и x2 как NaN
    fldz
    fstp dword [x1]
    fstp dword [x2]

end_program:
    finit
    xor rax, rax
    ret
