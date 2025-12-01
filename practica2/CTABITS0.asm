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
    xor bl,bl
    mov cx,8d
    cmp cx,0
    jcxz salir
mientras:
    xor ah,ah
    shl al,1
    adc ah, 0
    
    cmp ah,0
    jne es_uno
    inc bl
es_uno:
    loop mientras
    mov [cuenta],bl
    
salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    end inicio