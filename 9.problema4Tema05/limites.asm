    ideal
    dosseg
    model small
    stack 256

dataseg
    codsal db 0
    limite dd ?
    raiz dw ?
    
codeseg
inicio:
    mov ax,@data
    mov ds,ax
    mov bx,[word limite]
    mov cx,[word limite+2]
    
    xor ax,ax
    xor dx,dx
    xor si,si       
    xor di,di      
    mov [raiz], 0
suma:
    inc [raiz]
    mov ax,[raiz]
    mul [raiz]
    
    add si,ax
    adc di,dx
    
    cmp di, cx      
    ja  pasado      
    jb  suma     
    
    cmp si, bx
    jbe suma
    je salir    
pasado:
    dec [raiz]
salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    end inicio