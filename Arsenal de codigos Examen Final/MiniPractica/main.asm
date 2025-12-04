ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1   db 'Escribe tu nombre: ', 0
    msgRes db 13, 10, 'Bienvenido sea , ', 0
    
    buffer db 30 dup(?)
    
    limite dd ?     
    n_val  dw 0     

codeseg
    extrn aputs:proc, agets:proc, aatoi:proc, itoa:proc

inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; pedir nombre
    mov si, offset msg1
    call aputs
    
    ;Recibir nombre
    mov di, offset buffer
    mov cx, 29
    call agets
    
    ;Dar bienvenida
    mov si, offset msgRes
    call aputs
    ;Dar nombre que nos dio
    mov si, offset buffer
    call aputs
    
fin:
    mov ah, 04Ch
    mov al, [codsal]
    int 21h
end inicio