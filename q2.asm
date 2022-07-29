org 0x7c00
jmp 0x0000:start
%macro writechar 0
    pop ax
    call _writechar
%endmacro
%macro getchar 0
    call _getchar
    push ax
%endmacro

initvideo:
	mov al, 13h
	mov ah, 0
    mov bh, 0
	int 10h
    ret
_getchar:   
    xor ah,ah
    int 16h
    ret
_writechar:
    mov ah, 0xe
    mov bx, 1
    int 10h
    ret
putchar:
    mov bh, 1
    mov ah, 0xe
    int 10h
    ret
endl:
    mov al,0x0a
    call putchar
    mov al,0x0d
    call putchar
    ret
    
start:
    ;enquanto o caractere for diferente de enter, continua armazenando na pilha
    
    xor cx,cx;contador da quantidade de caracteres na string
    mov ds,cx
    mov bx,cx
    mov ax,cx
    call initvideo
    while_asm:
        inc cx
        getchar ;pega o caractere e armazana na pilha
        call _writechar
    mov bx,sp ; move para bx o endereço do ultimo caratere lido
    cmp byte[bx], 0x0d ; se o caractere lido for igual a enter
    jne while_asm

    call endl
    
    while2_asm:
        writechar
        dec cx
    cmp cx,0
    jne while2_asm
    

times 510-($-$$) db 0
dw 0xaa55
