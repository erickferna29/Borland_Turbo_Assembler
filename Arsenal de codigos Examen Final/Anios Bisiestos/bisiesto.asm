ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1   db 'Escribe el anio: ', 0
    msgSi  db 13, 10, 'si, es Bisiesto', 0
    msgNo  db 13, 10, 'No, no es Bisiesto', 0
    
    buffer db 20 dup(?) ;para exactamente 20 bytes
    anho   dw ?

codeseg
    extrn aputs:proc, agets:proc, aatoi:proc

inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; pedir el anio
    mov si, offset msg1
    call aputs
    
    mov di, offset buffer
    mov cx, 19  ;se define que se podra dar entrada a 19 por que el byte 20 tendra el 0 del final de las cadenas
    call agets
    
    mov si, offset buffer
    call aatoi          ; convierte texto a numero en ax
    mov [anho], ax      ; guardamos el anio
    
    ; paso 1: divisible entre 4?
    mov ax, [anho]
    xor dx, dx          ; limpiar dx para division
    mov bx, 4
    div bx              ; dx tiene el residuo
    
    cmp dx, 0
    jne no_es           ; si sobra algo, no es bisiesto

    ; paso 2: divisible entre 100?
    mov ax, [anho]
    xor dx, dx
    mov bx, 100
    div bx
    
    cmp dx, 0
    jne si_es           ; si es div entre 4 pero NO entre 100, es bisiesto (ej. 2024)

    ; paso 3: divisible entre 400?
    ; (si llego aqui es porque es div entre 100, como 1900 o 2000)
    mov ax, [anho]
    xor dx, dx
    mov bx, 400
    div bx
    
    cmp dx, 0
    jne no_es           ; si es div entre 100 pero NO entre 400, no es (ej. 1900)
    
    ; si llego aqui, es divisible entre 400

si_es:
    mov si, offset msgSi
    call aputs
    jmp fin

no_es:
    mov si, offset msgNo
    call aputs

fin:
    mov ah, 04Ch
    mov al, [codsal]
    int 21h
end inicio