section .rodata
    a: dd 0.5                   ; Константа a
    b: dd 1.0                   ; Константа b
    epsilon: dd 1.0e-6          ; Допустимая точность
    max_iter: dd 1000           ; Максимальное число итераций

section .bss
    x: resd 1                   ; Переменная x (результат вычислений)
    iter: resd 1                ; Счетчик итераций

section .text
global main

solve_equation:
    ; Инициализация
    fldz                        ; x = 0.0
    fstp dword [x]
    mov dword [iter], 0         ; iter = 0

iteration:
    ; Увеличить счетчик итераций
    mov eax, dword [iter]
    inc eax
    mov dword [iter], eax
    cmp eax, dword [max_iter]
    jge end                     ; Если iter >= max_iter, завершить

    ; Вычислить tan(x + a)
    fld dword [x]
    fadd dword [a]
    fptan
    fstp st0                    ; Удаляем лишний результат (1.0)

    ; Проверить на допустимость
    ftst
    fnstsw ax
    sahf
    je end                      ; Если tan(x + a) = 0, завершить

    ; Вычислить log2(tan(x + a))
    fld1
    fyl2x

    ; Проверить разницу с b
    fld dword [b]
    fsub
    fabs
    fld dword [epsilon]
    fcomip st0, st1
    jb solution_found

    ; Итеративное обновление x
    fld dword [x]
    fld1
    fadd
    fstp dword [x]
    jmp iteration

solution_found:
    fstp st0                    ; Очистка стека
    ret

end:
    finit
    ret

main:
    mov rbp, rsp; for correct debugging
    call solve_equation
    ret
