ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    numero dd ?
    desgaste dw ?
    pruebas dw ?
    acumulado dd ?
codeseg
inicio:
    mov ax,@data
    mov ds,ax
    
    mov cx,[pruebas]
    jcxz salir
cicloPirata:
    mov ax,[word numero]
    mov dx,[word numero+2]
    
    mov bx,[desgaste]
    
    sub ax,bx
    sbb dx,0
    
    mov [word numero],ax
    mov [word numero+2],dx
    
    div cx
    
    add [word acumulado],dx
    adc [word acumulado+2],0
    
    loop cicloPirata
salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    end inicio