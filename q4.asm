org 0x07c00
jmp main

data:
    string times 10 db 0
    num times 2 db 0

initVideo:
    mov al, 13h
    mov ah, 0
    int 10h
    ret

; lendo char do teclado
getchar:
    mov ah, 0
    int 16h
    ret

; printando char na tela
putchar:
    mov ah, 0x0e
    ; imprimindo char sempre branco
    mov bh, 0
    mov bl, 15      
    int 10h
    ret

; apagando um char
delchar:
    mov al, 0x08
    call putchar

    mov al, ''
    call putchar

    mov al, 0x08
    call putchar

    ret

; quebra de linha
endl:
    mov al, 0x0a
    call putchar
    mov al, 0x0d
    call putchar
    ret

; lendo string
gets:
    xor cx, cx

    .loop:
        call getchar
        ; apertou backspace
        cmp al, 0x08        
        je .backspace
        ; apertou enter
        cmp al, 0x0d
        je .enter
        
        stosb
        inc cl
        mov ah, 0xe
        mov bh, 0
        mov bl, 15       
        call putchar
        
        jmp .loop

        .backspace:
            cmp cl, 0
            je .loop
            dec di
            dec cl
            mov byte[di], 0
            call delchar
            jmp .loop       

        .enter:
            mov al, 0
            stosb
            call endl

        ret

; convertendo string em int
stoi:
    xor cx, cx
    xor ax, ax

    .loop:
        push ax     
        lodsb
        mov cl, al
        pop ax      
        cmp cl, 0       ; checando se e eof
        je .endloop

        sub cl, 48      
        mov bx, 10
        mul bx      
        add ax, cx     
        jmp .loop
    
    .endloop:
        ret

; calculando o char na posicao indicada
numchar:
    xor bx, bx
    dec ax      ; considerando que primeiro char é o 0
    mov bx, ax

    add di, ax     ; di indicara o char
    ret

main:
    call initVideo

    ; lendo string
    mov di, string
    call gets

    ; lendo num como string
    mov di, num
    call gets

    ; transformando em num
    mov si, num
    call stoi

    mov di, string

    ; calculando char da posição
    call numchar
    mov al, [di]

    ; imprimindo char
    call putchar

    jmp $

times 510-($-$$) db 0
dw 0xaa55