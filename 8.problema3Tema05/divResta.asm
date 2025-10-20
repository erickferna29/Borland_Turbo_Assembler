ideal
dosseg
model small
stack 256

dataseg
codsal db 0
dvidendo dd ?
divisor dw ?
residuo dw ?
cociente dw ?

codeseg
inicio:
    mov ax,[word dvidendo]
    mov dx,[word dvidendo+2]
    
    mov bx,[divisor]
    
    xor cx,cx
    
mientras_div:
    cmp dx,0
    jne iniciar_div
    cmp ax,bx
    jb fin_div
iniciar_div:
    sub ax,,bx
    sbb dx,0
    inc cx
    jmp mientras_div
fin_div:
    mov [residuo], ax
    mov [cociente], cx
    
salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    end inicio