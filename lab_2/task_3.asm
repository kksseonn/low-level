section .rodata
a: dd 0.5
b: dd 1.0

section .bss
x: resd 1
        ;log2(tg(x+a)) = b
        ;tg(x+a) = 2^b
        ;x=arctg(2^b)-a
        ;ПОЛИЗ  2 b ^ arctg a -

section .text
global main
main:
    mov rbp, rsp; for correct debugging
    fld dword [b]  ;ST(0) = b
    fld1           ;ST(0) = 1, ST(1) = b
    
    fld st1 ;  дублируем показатель в стек
    fprem ;  получаем дробную часть
    f2xm1 ; возводим в дробную часть показателя
    fadd ; прибавляем 1 из стека
    fscale  ;ST(0) = 2^b, ST(1) = b
    fstp st1

    fld1                 
    fpatan         ;ST(0) = arctan(2^b)

    fld dword [a]        
    fsub

    fstp dword[x]
    finit
            
    xor rax, rax
    ret