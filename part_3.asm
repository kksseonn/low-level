section .bss 
    x resq 1              ; Переменная для хранения состояния
    seed resq 1           ; Переменная для хранения seed

section .data
    n dq 272953           ; n = p * q
    p dq 499              ; простое число p
    q dq 547              ; простое число q
    msg db "Enter seed (e.g., a number like 3, 7, 10, 100): ", 0
    invalid_seed_msg db "Seed should be coprime with 272953. Please enter another number.", 0
    format db "%u", 10, 0 ; Формат для печати беззнакового числа с новой строки

section .text
    global main
    extern printf, scanf

main:
    ; Выравнивание стека
    sub rsp, 32                  
    lea rdi, [rel msg]           ; Загружаем адрес сообщения
    call printf                   ; Печатаем сообщение

    lea rdi, [rel format]         ; Загружаем адрес формата
    lea rsi, [seed]               ; Загружаем адрес для хранения seed
    call scanf                    ; Считываем seed

    ; Проверка на взаимную простоту с n
    mov rax, [seed]              ; Загружаем seed
    mov rbx, n                   ; Загружаем n
    xor rdx, rdx                 ; Очищаем rdx
    div rbx                       ; Делим seed на n
    test rdx, rdx                 ; Проверяем остаток
    jz invalid_seed               ; Если остаток 0, seed не взаимно прост

    ; Начало генерации чисел
    mov rax, [seed]              ; Загружаем seed
    mov rbx, n                   ; Загружаем n
    imul rax, rax                ; Квадрат seed
    mov rdx, rax
    mov rbx, p                   ; Загружаем p
    xor rax, rax
    div rbx                       ; Мод p
    mov rbx, q                   ; Загружаем q
    imul rdx, rdx                ; Квадрат результата
    xor rax, rax
    div rbx                       ; Мод q
    mov [x], rdx                 ; Сохраняем результат в x

    ; Генерация чисел
    mov ecx, 100                 ; Количество для 100 чисел
generate_loop:
    mov rax, [x]                 ; Загружаем текущее значение x
    imul rax, rax                 ; Квадрат x
    xor rdx, rdx                  ; Очищаем rdx
    div rbx                       ; Мод q
    mov [x], rdx                  ; Обновляем x

    ; Получение младших 2 байтов x
    and rdx, 0xFFFF               ; Маска для получения последних 2 байтов

    ; Печать числа
    mov rsi, rdx                  ; Загружаем число для печати
    lea rdi, [rel format]         ; Загружаем формат для printf
    xor rax, rax                  ; Очищаем rax для вариативной функции
    call printf                   ; Печатаем число

    loop generate_loop            ; Повторяем для 100 чисел

    add rsp, 32                  ; Восстановление стека
    ret

invalid_seed:
    lea rdi, [rel invalid_seed_msg] ; Загружаем адрес сообщения об ошибке
    call printf                    ; Печатаем сообщение об ошибке
    add rsp, 32                   ; Восстановление стека
    ret
