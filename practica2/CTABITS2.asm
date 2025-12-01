ideal
dosseg
model small
stack 256

dataseg
codsal db 0
dato db ?
cuenta db ?

codeseg
inicio:
    mov ax,@data
    mov ds,ax
    
    mov al,[dato]
    xor ah,ah
    mov cx,8d
    cmp cx,0
    jcxz salir
mientras:
    shl al,1
    adc ah, 0
    
    loop mientras
    mov [cuenta],ah
salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    end inicio
    