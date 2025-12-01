ideal
dosseg
model small
stack 256

dataseg
    codsal  db  0
    msj1    db  'Este programa compara dos cadenas', 13, 10, 0
    msj2    db  'Dame la cadena 1: ', 0
    msj3    db  'Dame la cadena 2: ', 0
    msj4    db  ' > ', 0
    msj5    db  ' < ', 0
    msj6    db  ' == ', 0
    msj7    db  13, 10, 0
    
    cad1    db  81 dup(?)
    cad2    db  81 dup(?)
    resp    db  81 dup(?)

codeseg
    extrn astrcat:proc, astrcmp:proc
    extrn aputs:proc, agets:proc

inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; 1. Mensaje de bienvenida
    mov si, offset msj1
    call aputs

    ; 2. Pedir cadena 1
    mov si, offset msj2
    call aputs

    ; 3. Leer cadena 1
    mov di, offset cad1
    call agets

    ; 4. Pedir cadena 2
    mov si, offset msj3
    call aputs

    ; 5. Leer cadena 2
    mov di, offset cad2
    call agets

    ; 6. Comparar las cadenas
    mov si, offset cad1
    mov di, offset cad2
    call astrcmp

    ; 7. Formacion de la cadena de respuesta
    
    ; limpiar variable resp
    mov [byte resp], 0 
    
    ; concatenar cadena 1 a resp
    mov di, offset resp
    mov si, offset cad1
    call astrcat

    ; checar el resultado de la comparacion
    ; decidimos que signo poner (>, < o =)
    mov si, offset msj4   ; preparamos signo Mayor
    cmp ax, 0
    jg sigue              ; si ax > 0, saltar a pegar
    
    mov si, offset msj5   ; preparamos signo Menor
    jl sigue              ; si ax < 0, saltar a pegar

    mov si, offset msj6   ; si no, es signo Igual

sigue:
    ; concatenar el signo elegido
    call astrcat

    ; concatenar cadena 2
    mov si, offset cad2
    call astrcat
    
    ; concatenar salto de linea final
    mov si, offset msj7
    call astrcat

    ; 8. Mostrar resultado final
    mov si, di    ; DI ya apunta al inicio de resp (o usamos offset resp)
    call aputs

salir:
    mov ah, 04Ch
    mov al, [codsal]
    int 21h

end inicio