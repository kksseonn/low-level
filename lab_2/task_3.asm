section .rodata 
    a: dd 1.0       ; Коэффициент a
    b: dd 4.0       ; Коэффициент b
    c: dd 3.0       ; Коэффициент c
    k: dd 4.0       ; Коэффициент k

section .bss
    x1: resd 1      ; Первый корень
    x2: resd 1      ; Второй корень
    D:  resd 1      ; Дискриминант

section .text
global main

main:

    ; Вычисление дискриминанта
    fld dword [b] ; +1        
    fmul st0, st0       
    fld dword [a]         
    fld dword [c]       
    fmul        
    fld dword [k]         
    fmul     
    fsub         
    fst dword [D]        ; Сохранение дискриминанта


    ; Проверка дискриминанта
    
    ftst                  ; Сравнение с 0 
    fstsw ax
    sahf
    jp no_real_roots      ; Переход при D < 0
    
    ; Вычисление sqrt(D)
    fsqrt                

    ; Вычисление x1 = (-b + sqrt(D)) / (2a)
    fld dword [b]        
    fchs                 
    fadd                 
    fld dword [a]        
    fld1                 
    fadd                 
    fdiv                 
    fstp dword [x1]      ; Сохранение x1

    ; Вычисление x2 = (-b - sqrt(D)) / (2a)
    fld dword [b]        
    fchs                 
    fld dword [D]        
    fsqrt                
    fsub                 
    fld dword [a]        
    fld1                 
    fadd                 
    fdiv                 
    fstp dword [x2]      ; Сохранение x2
    jmp end_program

no_real_roots:
    ; Если дискриминант меньше 0, x1 и x2 = NaN
    fldz
    fstp dword [x1]
    fstp dword [x2]

end_program:
    
    xor eax, eax 
    ret
    