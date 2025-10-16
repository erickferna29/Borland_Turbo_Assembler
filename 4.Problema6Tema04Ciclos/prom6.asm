ideal
dosseg
model small
stack 256

dataseg
codsal db 0
pares db ?
nones db ?
dato dw ?

codeseg
inicio:
    mov ax,@data
    mov ds,ax
    
    mov cx,8
    mov ax,[dato]
    jcxz salir
  
ciclo:
    shl ax,1
    rcl [pares],1
    
    shl ax,1
    rcl [nones],1
    loop ciclo
    
salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    end inicio