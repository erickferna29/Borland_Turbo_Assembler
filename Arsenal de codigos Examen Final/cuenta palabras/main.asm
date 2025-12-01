ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1   db 'Escribe una frase: ', 0
    msg2   db 13, 10, 'Total de palabras: ', 0
    
    frase  db 100 dup(?) 
    numStr db 10 dup(?)

codeseg
extrn aputs:proc, agets:proc,itoa:proc,countWords:proc

inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; pedir la frase
    mov si, offset msg1
    call aputs
    
    ; leer la frase
    mov di, offset frase
    mov cx, 99
    call agets

    ; llamar al modulo de conteo
    mov si, offset frase
    call countWords    ; regresa el numero en ax
    
    ; guardar el numero en la pila un momento
    push ax

    ; mostrar mensaje resultado
    mov si, offset msg2
    call aputs
    
    ; recuperar numero para convertirlo
    pop ax
    xor dx, dx      ; limpiar parte alta para itoa
    mov di, offset numStr
    call itoa       ; convierte numero a texto
    
    ; imprimir numero
    mov si, offset numStr
    call aputs

    salir:
    mov ah, 04Ch
    mov al, [codsal]
    int 21h
    
end inicio