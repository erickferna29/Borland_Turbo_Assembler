ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1   db 'Escribe el numero: ', 0
    msgres db 13, 10, 'pares encontrados: ', 0
    buffer db 20 dup(?)
    
    num    dw ?
    pares  dw 0

codeseg
    ; importamos tus herramientas
    ; aatoi ya sabe leer hexa y binario sola
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
    
    ; convertir texto a numero
    mov si, offset buffer
    call aatoi          ; devuelve el valor en ax
    
    ; limpiar parte alta por si acaso (solo nos interesan 8 bits)
    and ax, 00ffh       
    mov [num], ax       
    
    ; logica de pares (00 o 11)
    mov cx, 7           ; vamos a comparar 7 veces
    mov bx, [num]       ; cargamos el numero
    xor di, di          ; contador de pares en 0

ciclo_pares:
    ; aislar los 2 ultimos bits
    mov ax, bx          ; copia de seguridad
    and ax, 3           ; mascara 0000...0011
    
    ; checar si son '11' (3)
    cmp ax, 3
    je es_par
    
    ; checar si son '00' (0)
    cmp ax, 0
    je es_par
    
    jmp siguiente       ; si es 01 o 10, no cuenta

es_par:
    inc di              ; encontramos uno

siguiente:
    shr bx, 1           ; recorremos a la derecha para ver el siguiente
    loop ciclo_pares    ; repetir

    ; mostrar resultado
    mov si, offset msgres
    call aputs
    
    mov ax, di          ; pasamos la cuenta a ax
    xor dx, dx
    mov di, offset buffer
    call itoa
    
    mov si, offset buffer
    call aputs

salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    
end inicio