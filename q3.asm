org 0x7c00            ; pilha é usada para salvar valores
jmp main
data:

string times 50 db 0
azul db "azul", 0
verde db "verde", 0
amarelo db "amarelo", 0
vermelho db "vermelho", 0

print_azul db "AZUL", 0
print_verde db "VERDE", 0
print_amarelo db "AMARELO", 0
print_vermelho db "VERMELHO", 0
print_falso db "NAO EXISTE", 0

main:
xor ax, ax
mov ds, ax
mov es, ax
mov ah,0xb
mov bh, 0
mov bl, 4

mov di, string
call clear 
call gets

mov si, string
mov di, azul
call comparador
je printAzul

mov si, string
mov di, verde
call comparador
je printVerde

mov si, string
mov di, amarelo
call comparador
je printAmarelo

mov si, string
mov di, vermelho
call comparador
je printVermelho

xor ax, ax
cmp ax, ax
je printFalso

jmp fim


;Funções

gets: 
	xor cx, cx

	.loop1:
		call getchar
		cmp al, 0x08
		je .backspace
		cmp al, 0x0d
		je .done
		cmp cl, 50
		je .done
		stosb
		inc cl
		mov bl, 7
		call putchar
		jmp .loop1

		.backspace:
			cmp cl, 0
			je .loop1
			dec di
			dec cl
			mov byte[di], 0
			call delchar
			jmp .loop1
	
	.done:
		mov al, 0
		stosb
		call endl
ret

comparador: 
	.loop1:
		lodsb
		cmp byte[di], 0
		jne .continue
		cmp al, 0
		jne .done
		stc
		jmp .done
		
		.continue:
			cmp al, byte[di]
    			jne .done
			clc
    			inc di
    			jmp .loop1

		.done:
			ret

printAzul:
	mov si, print_azul
	mov bl, 9
	call print
	call fim

printVerde:
	mov si, print_verde
	mov bl, 10
	call print
	call fim

printAmarelo:
	mov si, print_amarelo
	mov bl, 14
	call print
	call fim

printVermelho:
	mov si, print_vermelho
	mov bl, 4
	call print
	call fim

printFalso:
	mov si, print_falso
	mov bl, 13
	call print
	call fim

print:                    
    .loop1:       
    	lodsb	          
	cmp al, 0          
	je .fim		   
	call putchar     
	jmp .loop1        
	
    .fim:
	ret              

endl:
	mov al, 0x0a
	call putchar
	mov al, 0x0d
	call putchar

putchar:
	mov bh, 13
	mov ah, 0x0e
	int 10h
ret

getchar:
	mov ah, 0x00
	int 16h

ret

delchar:
	mov al, 0x08
	call putchar

	mov al, ''
	call putchar

	mov al, 0x08
	call putchar

ret

clear:
    mov ah, 0      
    mov al, 10h     
    int 10h
ret

fim:
	jmp $

times 510-($-$$) db 0
dw 0xaa55