;cuantos numero hay en un byte
ideal
dosseg
model small 
stack 256

dataseg
    codsal db 0
    num db ?
    cuantosHay db ?
    hay db ?
codeseg
inicio:
    mov ax,@data
    mov ds,ax
    
    mov cl,7d
    xor bl,bl
    mov ah,[num]
    cmp cl,0
    je salir
mientras:
    shl ah,1
    rcr al,1
    cmp al,0 
    je esCero
    jne esUno

esCero:
    xor al,al
    mov bh,ah
    shl bh,1
    rcr al,1
    cmp al,0
    jne volverAlCiclo
    add [cuantosHay],1d
    jmp volverAlCiclo
esUno:
    xor al,al
    mov bh,ah
    shl bh,1
    rcr al,1
    cmp al,1
    jne volverAlCiclo
    add [cuantosHay],1d
    jmp volverAlCiclo
volverAlCiclo:
    inc bl
    cmp cl,bl
    jae mientras    
    cmp [cuantosHay],0
    je noHay
siHay:
    mov [hay],'S'
    jmp salir
noHay:
    mov [hay],'N'
salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    end inicio