ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1   db 'Escribe el limite: ', 0
    msg2 db 13, 10, ' <= ', 0
    msgRes db 13, 10, 'El maximo N es: ', 0
    sresul db 35 dup(?)
    
    buffer db 20 dup(?)
    temp   db 10 dup(?)
    temp2  db 10 dup(?)
    
    mas  db '+',0
    igual db '=',0
    mayor db '<',0
    limite dw ?     
    n_val  dw 0     

codeseg
    extrn aputs:proc, agets:proc, aatoi:proc, itoa:proc, astrcat:proc,astrcat2:proc

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
    mov [limite], ax  
    
    ; preparar registros para comparar
    mov bx, [limite]
    
    xor ax, ax
    xor cx,cx
    xor dx, dx
    xor si, si      ; si = suma acumulada baja
    xor di, di      ; di = suma acumulada alta
    mov [n_val], 0

    ; logica de suma de cuadrados
suma:
        ; Convertir numero a temp
    mov di, offset temp
    call itoa 
            ; Concatenar temp a sresul
    mov di, offset sresul
    mov si, offset temp
    call astrcat
    
     ;Concatenar temp a sresul
     mov di, offset sresul
     mov si, offset mas
     call astrcat
    inc [n_val]         ; n++
    
    mov ax, [n_val]
    mul [n_val]         ; ax = n * n
    
    
    add cx, ax          ; acumular cuadrado (parte baja)
    
    ; comparar acumulado (di:si) contra limite (cx:bx)
    cmp cx,bx           
    ja pasado           ; si acumulado > limite (baja) -> te pasaste
    jb suma             ; si acumulado < limite (baja) -> siguele
    je salir_ciclo      ; si es exacto, terminamos
    
    jmp suma            ; si es menor, siguele

pasado:
    dec [n_val]         ; nos pasamos, regresa al ultimo valido

salir_ciclo:
    
     ;Concatenar temp a sresul
     mov di, offset sresul
     mov si, offset mayor
     call astrcat
         ;Concatenar temp a sresul
     mov di, offset sresul
     mov si, offset igual
     call astrcat
    
    mov ax,[limite]
    ; Convertir numero a temp
    mov di, offset temp
    call itoa   
    
     ;Concatenar temp a sresul
     mov di, offset sresul
     mov si, offset temp
     call astrcat
     
    ; poner en pantalla el numero
    mov si, offset sresul
    call aputs
salir:
    mov ah, 04Ch
    mov al, [codsal]
    int 21h
end inicio