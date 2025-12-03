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

    shl al,1
    adc ah, 0
    shl al,1
    adc ah, 0
    shl al,1
    adc ah, 0
    shl al,1
    adc ah, 0
    shl al,1
    adc ah, 0
    shl al,1
    adc ah, 0
    shl al,1
    adc ah, 0
    shl al,1
    adc ah, 0
    
    mov [cuenta],ah
salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    end inicio
    
    
    