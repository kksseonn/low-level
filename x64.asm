section .rodata
  msg1: db "Enter seed:", 0
  fmt: db "%u", 0
  fmt_output: db "%u", 10, 0

extern printf
extern scanf
extern malloc
extern free

section .text
global main
main:
    push rbp
    mov rbp, rsp;

    sub rsp, 40 + 8
    mov rcx, 16 
    call malloc
    mov rbx, rax

    lea rcx, [rel msg1]
    call printf

    lea rcx, [fmt]
    lea rdx, [rsp + 8]
    call scanf
    mov r8d, [rsp + 8]

    mov dword [rbx], 0
    mov dword [rbx + 4], 0
    mov dword [rbx + 8], 0
    mov dword [rbx + 12], r8d

    xor r13d, r13d

.cycle_start:
    mov r12d, [rbx + 12]
    mov r10d, [rbx]

    mov r15d, [rbx + 8]
    mov [rbx + 12], r15d
    mov r15d, [rbx + 4]
    mov [rbx + 8], r15d
    mov [rbx + 4], r10d

    mov r11d, r12d
    shl r11d, 11

    xor r12d, r11d
    mov r11d, r12d
    shr r11d, 8

    xor r12d, r11d
    xor r12d, r10d
    mov r11d, r10d
    shr r11d, 19
    xor r12d, r11d

    mov [rbx], r12d

    sub rsp, 40
    lea rcx, [fmt_output]
    mov rdx, [rbx]
    call printf
    add rsp, 40

    add r13d, 1

    cmp r13d, 100
    jge .cycle_end

    jmp .cycle_start
.cycle_end:
    mov rcx, rbx
    call free

    leave
    ret