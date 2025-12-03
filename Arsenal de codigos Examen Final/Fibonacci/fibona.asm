ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1   db 'Que numero de la sucesion fibonacci necesitas?: ', 0
    msgRes db 13, 10, 'El resultado es: ', 0
    
    buffer db 20 dup(?)
    temp   db 10 dup(?)
    
    n      dw ?      ; el numero n que pide el usuario
    fibo   dw ?      ; donde guardamos el resultado

codeseg
    extrn aputs:proc, agets:proc, aatoi:proc, itoa:proc

inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; pedir n
    mov si, offset msg1
    call aputs
    
    mov di, offset buffer
    mov cx, 19
    call agets
    
    mov si, offset buffer
    call aatoi          ; convierte texto a numero
    mov [n], ax         ; guardamos n
    
    ; cargar n en cx para comparar
    mov cx, [n]
    
    ; casos base 0 y 1
    cmp cx, 0
    je cero
    cmp cx, 1
    je uno
    
    ; preparacion del ciclo (para n >= 2)
    ; tu logica original:
    mov bx, 2           ; contador empieza en 2
    mov ax, 0           ; f(n-2)
    mov dx, 1           ; f(n-1)

mientras:
    add ax, dx          ; suma: nuevo = anterior + actual
    xchg ax, dx         ; el truco: dx se vuelve el nuevo, ax se guarda el viejo
    
    inc bx              ; contador++
    
    cmp bx, cx          ; comparamos contador con n
    jbe mientras        ; si contador <= n, repetir

    ; al salir del ciclo, el resultado quedo en dx
    mov [fibo], dx
    jmp mostrar

cero:
    mov [fibo], 0
    jmp mostrar

uno:
    mov [fibo], 1
    jmp mostrar

mostrar:
    ; imprimir mensaje
    mov si, offset msgRes
    call aputs
    
    ; convertir resultado a texto
    mov ax, [fibo]
    xor dx, dx          ; limpiar dx para itoa
    mov di, offset temp
    call itoa
    
    ; imprimir numero
    mov si, offset temp
    call aputs

salir:
    mov ah, 04Ch
    mov al, [codsal]
    int 21h
    
end inicio