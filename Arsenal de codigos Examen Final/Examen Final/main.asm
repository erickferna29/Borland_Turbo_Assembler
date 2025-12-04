ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1 db 'Escribe la: ', 0
    entrada  db 21 dup(?) 

codeseg
    extrn aputs:proc,astrcat:proc,agets:proc,sscan:proc,itoa:proc,itoa_hex:proc,itoa_bin:proc
inicio:
    mov ax,@data
    mov ds,ax
    mov es,ax
    
    ; 1. Pedir dato 
    mov si, offset msg1
    call aputs
    
    ; 2. Leer dato 
    mov di, offset entrada
    mov cx, 20
    call agets

fin:
    mov ah, 04Ch
    mov al,[codsal]
    int 21h
    
end inicio