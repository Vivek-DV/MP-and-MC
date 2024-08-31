section .data
    msg1 db 'Enter string1',0xa
    len1 equ $-msg1
    msg2 db 'Enter string2',0xa
    len2 equ $-msg2
    msg3 db 'Concatenated string:',0xa
    len3 equ $-msg3
    
section .bss
    str1 resb 15
    str2 resb 15
    str3 resb 30
    
section .text
    global _start
    
_start:
    MOV eax,4
    MOV ebx,1
    MOV ecx,msg1
    MOV edx,len1
    INT 0x80
    
    MOV eax,3
    MOV ebx,0
    MOV ecx,str1
    MOV edx,15
    INT 0x80
    
    MOV eax,4
    MOV ebx,1
    MOV ecx,msg2
    MOV edx,len2
    INT 0x80
    
    MOV eax,3
    MOV ebx,0
    MOV ecx,str2
    MOV edx,15
    INT 0x80
    
    mov byte[str1+eax-1],0
    mov byte[str2+eax-1],0
    
    MOV eax,str1
    MOV ebx,str3
    
loop1:
    MOV dl,[eax]
    MOV [ebx],dl
    inc eax
    inc ebx
    test dl,dl
    jnz loop1

MOV eax,str2
    
loop2:
    MOV dl,[eax]
    MOV [ebx],dl
    inc eax
    inc ebx
    test dl,dl
    jnz loop2
    
MOV eax,4
MOV ebx,1
MOV ecx,msg3
MOV edx,len3
INT 0x80

MOV eax,4
MOV ebx,1
MOV ecx,str3
MOV edx,30
INT 0x80

MOV eax,1
xor ebx,ebx
INT 0x80
