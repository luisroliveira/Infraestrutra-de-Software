org 0x7c00            
jmp main

data:
    num times 3 db 0    ; string do numero

initVideo:
    mov al, 13h
    mov ah, 0
    int 10h
    ret

; lendo char do teclado
getchar:
    mov ah, 0x00
    int 16h
    ret

; printando char na tela
putchar:
    mov ah, 0x0e
    mov bh, 0
    mov bl, 15      ; imprimindo char sempre branco
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
        cmp al, 0x08        ; apertou para deletar char
        je .backspace
        cmp al, 0x0d        ; apertou enter
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
            jmp .loop       ; volta p/ loop

        .enter:
            mov al, 0
            stosb
            call endl
        ret

; printando string
printstring:   
    .loop:
        lodsb
        cmp al, 0
        je .endloop
        call putchar
        jmp .loop

    .endloop:
        jmp $

; convertendo string em int
stoi:
    xor cx, cx
    xor ax, ax
    .loop:
        push ax     ; coloca na pilha
        lodsb
        mov cl, al
        pop ax      ; tira da pilha
        cmp cl, 0   ; checando se e eof
        je .endloop

        sub cl, 48      
        mov bx, 10
        mul bx      
        add ax, cx     
        jmp .loop
    
    .endloop:
        ret

; revertando string
reverse:
    mov di, si
    xor cx, cx

    .loop1:
        lodsb
        cmp al, 0
        je .endloop1
        inc cl
        push ax
        jmp .loop1
    
    .endloop1:
        .loop2:
            cmp cl, 0
            je .endloop2
            dec cl
            pop ax
            stosb
            jmp .loop2

        .endloop2:
            ret


; transformando int em string
tostring:
    push di

    .loop:
        cmp ax, 0
        je .endloop
        xor dx, dx
        mov bx, 10
        div bx
        xchg ax, dx
        add ax, 48
        stosb
        xchg ax, dx
        jmp .loop

    .endloop:
        pop si
        cmp si, di
        jne .done
        mov al, 48
        stosb

    .done:
        mov al, 0
        stosb
        call reverse
        ret

; calculando numero triangular
numtriangular:
    xor bx, bx
    mov bx, ax      ; salvando ax no bx para manipular (bx = n)
    add bx, 1       ; (1 + n)
    mul bx          ; (1 + n) * n
    shr ax, 1       ; (a1 + n ) * n / 2 com shift right
    ret

main:
    call initVideo

    ; lendo input
    mov di, num
    call gets

    ; transformando input em int
    mov si, num
    call stoi   

    ; fazendo o calculo
    call numtriangular  
    
    ; transformando num em string
    mov di, num
    call tostring

    ;printando
    mov si, num
    call printstring

times 510-($-$$) db 0
dw 0xaa55