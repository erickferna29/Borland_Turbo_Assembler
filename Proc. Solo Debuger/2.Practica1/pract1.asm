    ideal
    dosseg
    model small
    stack 256

dataseg
    codsal db 0 
    dato1 dw ?
    dato2 dw ?
    resul dd ?
codeseg
inicio:
    mov ax,@data
    mov ds,ax
    
    mov ax, [dato1]
    mul [dato2]
    
    mov [word resul], ax
    mov [word resul+2],dx
    
salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    
    end inicio