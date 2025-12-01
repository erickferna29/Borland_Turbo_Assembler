ideal
dosseg
model small
stack 256

dataseg
codsal db 0
capital dd ?
n dw ?
sumaT dd ?
codeseg
inicio:
    mov ax,@data
    mov ds,ax
    
    mov cx,[n]
    xor bx,bx
    cmp cx,0
    jcxz salir
    
cicloWhile:
    inc bx
    mov ax,[word capital]
    mov dx,[word capital+2]
    div bx
    
    add [word sumaT],ax
    adc [word sumaT+2],0
    
    cmp bx,cx
    jb cicloWhile

salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    end inicio