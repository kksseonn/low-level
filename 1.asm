%include "io64.inc"

section .bss
state: resd 4

section .rodata
    msg1:db "enter seed", 0
    
section .text
global main
main:
    PRINT_STRING [msg1]
    NEWLINE
    GET_UDEC 4, r8d
    
    mov dword [state], 0
    mov dword [state + 4], 0
    mov dword [state + 8], 0
    mov dword [state + 12], r8d
    
    xor ecx, ecx
    
.cycle_start:    
    mov r9d, [state + 12]
    mov r10d, [state]
    
    mov eax, [state + 8]
    mov [state + 12], eax
    mov eax, [state + 4]
    mov [state + 8], eax
    mov [state + 4], r10d
    
    mov r11d, r9d
    shl r11d, 11
    
    xor r9d, r11d
    mov r11d, r9d
    shr r11d, 8
    
    xor r9d, r11d
    xor r9d, r10d
    mov r11d, r10d
    shr r11d, 19
    xor r9d, r11d
    
    mov dword [state], r9d
    
    PRINT_UDEC 4, [state]
    NEWLINE
    
    add ecx, 1
    
    cmp ecx, 100
    je .cycle_end
    
    jmp .cycle_start
.cycle_end:
    ret