ideal
dosseg
model small
stack 256

dataseg
    mensaje db 'Escribe tu nombre (max 20): ', 0
    buffer  db 21 dup(?)  
    saludo  db 13, 10, 'Hola, ', 0

codeseg
    ; Las ponemos DENTRO de codeseg para que sepa que son llamadas cercanas (NEAR)
    extrn aputs:proc
    extrn agets:proc

start:
    mov ax, @data
    mov ds, ax
    mov es, ax 

    ; 1. Pedir dato
    mov si, offset mensaje
    call aputs

    ; 2. Leer dato 
    mov di, offset buffer
    mov cx, 20
    call agets

    ; 3. Mostrar resultado
    mov si, offset saludo
    call aputs
    
    mov si, offset buffer
    call aputs

    mov ax, 04C00h
    int 21h
end start