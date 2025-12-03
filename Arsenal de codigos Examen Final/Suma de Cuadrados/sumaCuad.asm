ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1   db 'Escribe el limite: ', 0
    msgRes db 13, 10, 'El maximo N es: ', 0
    
    buffer db 20 dup(?)
    temp   db 10 dup(?)
    
    limite dd ?     
    n_val  dw 0     

codeseg
    extrn aputs:proc, agets:proc, aatoi:proc, itoa:proc

inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; pedir limite
    mov si, offset msg1
    call aputs
    
    mov di, offset buffer
    mov cx, 19
    call agets
    
    mov si, offset buffer
    call aatoi          ; convierte a numero en ax
    
    ; guardar limite
    mov [word ptr limite], ax
    mov [word ptr limite+2], 0  
    
    ; preparar registros para comparar
    mov bx, [word ptr limite]     ; limite bajo
    mov cx, [word ptr limite+2]   ; limite alto
    
    xor ax, ax
    xor dx, dx
    xor si, si      ; si = suma acumulada baja
    xor di, di      ; di = suma acumulada alta
    mov [n_val], 0

    ; logica de suma de cuadrados
suma:
    inc [n_val]         ; n++
    
    mov ax, [n_val]
    mul [n_val]         ; ax = n * n
    
    add si, ax          ; acumular cuadrado (parte baja)
    adc di, dx          ; acumular cuadrado (parte alta)
    
    ; comparar acumulado (di:si) contra limite (cx:bx)
    cmp di, cx          
    ja pasado           ; si acumulado > limite (alta) -> te pasaste
    jb suma             ; si acumulado < limite (alta) -> siguele
    
    ; si partes altas iguales, checar bajas
    cmp si, bx
    ja pasado           ; si acumulado > limite (baja) -> te pasaste
    je salir_ciclo      ; si es exacto, terminamos
    
    jmp suma            ; si es menor, siguele

pasado:
    dec [n_val]         ; nos pasamos, regresa al ultimo valido

salir_ciclo:
    ; mostrar resultado
    mov si, offset msgRes
    call aputs
    
    mov ax, [n_val]
    xor dx, dx
    mov di, offset temp
    call itoa
    
    mov si, offset temp
    call aputs
salir:
    mov ah, 04Ch
    mov al, [codsal]
    int 21h
end inicio