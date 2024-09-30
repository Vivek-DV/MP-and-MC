section .data
    msg1 db 'Enter a string: ', 0
    msg2 db 'Reversed string: ', 0

section .bss
    string resb 100
    reversed resb 100

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 16
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, string
    mov edx, 100
    int 0x80

    mov ecx, eax
    dec ecx   
    mov esi, string
    mov edi, reversed
    xor ebx, ebx  

reverse:
    mov al, [esi + ecx]
    mov [edi], al
    inc edi
    dec ecx
    cmp ecx, ebx
    jge reverse

    mov byte [edi], 0

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 16
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, reversed
    mov edx, 100
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
