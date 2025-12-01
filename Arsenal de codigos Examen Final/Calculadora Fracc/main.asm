
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1 db 'Escriba el numero 1: ', 0
    msg2 db 'Escriba el numero 2: ',0
    msg3 db 'El MCD es: ',0
    snum1  db 21 dup(?) 
    snum2 db 21 dup(?) 
    num1 dw ?
    num2 dw ?
    Elmcd dw ?
    smcd db 21 dup(?)
    
codeseg
extrn mcd:proc
extrn agets:proc
extrn aputs:proc
extrn itoa:proc
extrn aatoi:proc

inicio:
    mov ax,@data
    mov ds,ax
    mov es,ax
    
    ; 1. Pedir dato 1
    mov si, offset msg1
    call aputs
    
    ; 2. Leer dato 1
    mov di, offset snum1
    mov cx, 20
    call agets
    
    
    
        ; pausa
    mov ah, 0Ch     ; Funci?n DOS: Limpiar buffer del teclado
    mov al, 08h     ; Funci?n DOS: Leer car?cter sin eco
    int 21h         ; Ejecutar: ?Esp?rate aqu? hasta que el usuario pulse algo!
fin:
    mov ax, 04Ch
    mov al,[codsal]
    int 21h
    
end inicio
