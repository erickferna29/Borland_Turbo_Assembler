ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1   db 'Dame un numero(en binario): ', 0
    msg2   db 13, 10, 'Bits encendidos (unos): ', 0
    buffer db 20 dup(?)
    
    num    dw ?
    conteo dw 0

codeseg
    extrn aputs:proc, agets:proc, aatoi:proc, itoa:proc

inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; pedir numero
    mov si, offset msg1
    call aputs
    mov di, offset buffer
    mov cx, 19
    call agets
    
    mov si, offset buffer
    call aatoi
    mov [num], ax   ; guardamos el numero
    
    ; logica de contar bits
    mov cx, 16      ; son 16 bits en una palabra (word)
    xor bx, bx      ; bx sera el contador de unos
    mov ax, [num]   ; cargamos el numero

ciclo_bits:
    shl ax, 1       ; empuja el bit mas alto al carry flag (cf)
    adc bx, 0       ; suma el carry al contador (bx = bx + cf)
    loop ciclo_bits ; repite 16 veces

    ; guardar resultado
    mov [conteo], bx

    ; mostrar resultado
    mov si, offset msg2
    call aputs
    
    mov ax, [conteo]
    xor dx, dx
    mov di, offset buffer
    call itoa
    mov si, offset buffer
    call aputs

    mov ah, 00h
    int 16h

    mov ah, 04Ch
    mov al, [codsal]
    int 21h
end inicio