ideal
dosseg
model small
stack 256

dataseg
codsal db 0
dato dw 0

codeseg
inicio:
    mov ax,@data
    mov ds,ax
    
    mov ax,[dato]
    mov cx,16
    
    jcxz salir
    
hacer:
    shr ax,1
    rcl [dato],1
    loop hacer

salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    end inicio