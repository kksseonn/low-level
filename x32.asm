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
    push ebp                          
    mov ebp, esp                     

    push msg1                         
    call printf                      
    add esp, 4                       

    sub esp, 8                       
    lea eax, [rel fmt]                
    mov [esp], eax                    ; Помещаем адрес формата в стек
    lea eax, [ebp -4]                
    mov [esp+4], eax                 
    call scanf                        
    add esp, 8                        
    mov edi, [ebp -4]                 ; Загружаем считанный seed в регистр edi

    mov eax, 16                       
    push eax                          
    call malloc                       
    add esp, 4                        
    mov ebx, eax                      ; Сохраняем адрес выделенной памяти в ebx

    ; Инициализация памяти генератора
    mov dword [ebx], 0                
    mov dword [ebx + 4], 0            
    mov dword [ebx + 8], 0            
    mov dword [ebx + 12], edi         ; Устанавливаем seed в четвёртую ячейку памяти

    xor edi, edi                      ; Обнуляем счётчик итераций

.cycle_start: 
    mov esi, [ebx + 12]               ; Загружаем текущее состояние генератора
    mov edx, [ebx]                    ; Загружаем предыдущее значение генератора

    ; Перемещаем состояние для обновления
    mov eax, [ebx + 8]
    mov [ebx + 12], eax
    mov eax, [ebx + 4]
    mov [ebx + 8], eax
    mov [ebx + 4], edx

    ; Генерация нового значения с использованием побитовых операций
    mov eax, esi
    shl eax, 11                       ; Логический сдвиг влево на 11 бит
    xor esi, eax                      ; Побитовый XOR текущего значения
    mov eax, esi
    shr eax, 8                        ; Логический сдвиг вправо на 8 бит
    xor esi, eax                      ; Побитовый XOR
    xor esi, edx                      ; XOR с предыдущим значением генератора
    mov eax, edx
    shr eax, 19                       ; Логический сдвиг вправо на 19 бит
    xor esi, eax                      ; Побитовый XOR
    mov [ebx], esi                    ; Сохраняем новое значение генератора

    ; Вывод случайного числа
    push dword [ebx]                  ; Передаём значение генератора в стек
    push fmt_output                   ; Передаём формат вывода в стек
    call printf                       ; Выводим случайное число
    add esp, 8                        ; Очищаем стек после вызова printf

    add edi, 1                        ; Увеличиваем счётчик итераций
    cmp edi, 100                      ; Проверяем, выполнено ли 100 итераций
    jge .cycle_end                    

    jmp .cycle_start                  

.cycle_end:
    push ebx                          
    call free                        
    add esp, 4                       

    leave                             
    ret                               
