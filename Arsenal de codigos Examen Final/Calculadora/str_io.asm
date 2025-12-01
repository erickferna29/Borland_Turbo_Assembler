ideal
dosseg
model small

    codeseg
    public aputs, agets

; PROCEDIMIENTO: APUTS

proc aputs
    push ax
    push dx
    push si

@@ciclo_puts:
    lodsb           ; Carga byte de [SI] en AL y hace inc SI
    cmp al, 0       ; ?Es el fin de cadena?
    jz @@fin_puts
    
    mov dl, al      ; Prepara caracter para imprimir
    mov ah, 02h     ; Servicio DOS: Imprimir caracter
    int 21h
    
    jmp @@ciclo_puts

@@fin_puts:
    pop si
    pop dx
    pop ax
    ret
endp aputs

; PROCEDIMIENTO: AGETS con borrado

proc agets
    push ax
    push bx 
    push cx
    push di
    push dx 

    mov bx, di      ; Guardamos en BX la posici?n inicial (el tope de concreto)
    cld             ; Aseguramos que DI avance hacia adelante

@@leer:
    mov ah, 08h     ; SERVICIO 08h: Lee teclado SIN imprimir en pantalla
    int 21h
    
    ; --- 1. CHECAR ENTER (ASCII 13) ---
    cmp al, 13
    je @@es_enter

    ; --- 2. CHECAR BACKSPACE (ASCII 8) ---
    cmp al, 8
    je @@es_backspace

    ; --- 3. CHECAR L?MITE DEL BUFFER ---
    jcxz @@leer ; Si CX es 0 (no hay espacio), ignora la tecla

    ; --- 4. ES UNA LETRA NORMAL ---
    stosb           ; Guarda AL en [DI] y hace inc DI
    dec cx          ; Resta 1 al contador de espacio disponible
    
    ; Imprimir manualmente el caracter (Eco manual)
    mov dl, al
    mov ah, 02h
    int 21h
    
    jmp @@leer

@@es_backspace:
    ; Verificamos si estamos al principio del buffer
    cmp di, bx      
    je @@leer ; Si DI == BX, no hay nada que borrar, ignora.

    ; Si hay qu? borrar:
    dec di          ; Regresa el puntero en memoria
    inc cx          ; Recupera un espacio en el contador

    ; Efecto visual de borrado:
    mov ah, 02h
    mov dl, 8       ; Retroceso (Mueve cursor atr?s)
    int 21h
    mov dl, 32      ; Espacio (Borra la letra visualmente)
    int 21h
    mov dl, 8       ; Retroceso (Vuelve a colocar el cursor en su lugar)
    int 21h
    
    jmp @@leer

@@es_enter:
    mov al, 0       ; Agregamos el terminador nulo al final de la cadena
    stosb
    
    ; Salto de l?nea visual para que se vea ordenado
    mov ah, 02h
    mov dl, 13      ; Retorno de carro
    int 21h
    mov dl, 10      ; Salto de l?nea
    int 21h

    pop dx
    pop di
    pop cx
    pop bx
    pop ax
    ret
endp agets
    
    end