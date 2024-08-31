section .data
    msg1 db 'Enter first string: ', 0xa
    msg2 db 'Enter second string: ', 0xa
    msg_eq db 'Strings are equal', 0xa
    msg_neq db 'Strings are not equal', 0xa

section .bss
    str1 resb 100
    str2 resb 100

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 20
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, str1
    mov edx, 100
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 20
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, str2
    mov edx, 100
    int 0x80

    xor ecx, ecx

loop_start:
    mov dl, [str1 + ecx]
    mov dh, [str2 + ecx]
    cmp dl, dh
    jne not_equal

    cmp dl, 0
    je equal

    inc ecx
    jmp loop_start

equal:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_eq
    mov edx, 18
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

not_equal:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_neq
    mov edx, 22
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
