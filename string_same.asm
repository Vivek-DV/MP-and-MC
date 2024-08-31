section .data
    msg_prompt1 db 'Enter first string: ', 0xa
    msg_prompt2 db 'Enter second string: ', 0xa
    msg_equal db 'Strings are equal', 0xa
    msg_not_equal db 'Strings are not equal', 0xa

section .bss
    str1 resb 100
    str2 resb 100

section .text
    global _start

_start:
    ; Print prompt for first string
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_prompt1
    mov edx, 20
    int 0x80

    ; Read first string from user
    mov eax, 3
    mov ebx, 0
    mov ecx, str1
    mov edx, 100
    int 0x80

    ; Print prompt for second string
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_prompt2
    mov edx, 20
    int 0x80

    ; Read second string from user
    mov eax, 3
    mov ebx, 0
    mov ecx, str2
    mov edx, 100
    int 0x80

    ; Initialize counter
    xor ecx, ecx

loop_start:
    ; Load characters from strings
    mov dl, [str1 + ecx]
    mov dh, [str2 + ecx]

    ; Compare characters
    cmp dl, dh
    jne not_equal

    ; Check for null-terminator
    cmp dl, 0
    je equal

    ; Increment counter and loop
    inc ecx
    jmp loop_start

equal:
    ; Print "Strings are equal"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_equal
    mov edx, 18
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

not_equal:
    ; Print "Strings are not equal"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_not_equal
    mov edx, 21
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
