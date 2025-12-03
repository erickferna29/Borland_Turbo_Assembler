ideal
dosseg
model small
stack 256

dataseg
    msgPedir    db 'Escribe algo machin: ', 0
    msgMostrar  db 13, 10, 'Escribiste: ', 0
    buffer      db 50 dup(?)

codeseg
start:
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; --- PEDIR DATOS ---
    mov si, offset msgPedir
    call aputs

    ; --- LEER (MODO NINJA) ---
    mov di, offset buffer
    mov cx, 49
    call agets_ninja      ; <--- OJO AQUI, llamamos a la nueva funcion

    ; --- MOSTRAR ---
    mov si, offset msgMostrar
    call aputs
    
    mov si, offset buffer
    call aputs

    mov ax, 04C00h
    int 21h

; ==========================================================
; PROCEDIMIENTO: APUTS (El de siempre)
; ==========================================================
proc aputs
    push ax
    push dx
    push si
@@ciclo_puts:
    lodsb
    cmp al, 0
    jz @@fin_puts
    mov dl, al
    mov ah, 02h
    int 21h
    jmp @@ciclo_puts
@@fin_puts:
    pop si
    pop dx
    pop ax
    ret
endp aputs

; ==========================================================
; PROCEDIMIENTO: AGETS_NINJA
; Descripci?n: Lee teclado SIN ECO para tener control total.
;              El cursor NO SE MUEVE si no le damos permiso.
; ==========================================================
proc agets_ninja
    push ax
    push bx ; Guardamos BX (Nuestro Tope)
    push cx
    push di
    push dx ; Necesitamos DX para imprimir manualmente

    mov bx, di      ; BX marca el inicio (El Tope de concreto)
    cld

@@leer_ninja:
    mov ah, 08h     ; <--- CAMBIO CLAVE: 08h lee SIN imprimir nada en pantalla
    int 21h
    ; Ahora AL tiene la tecla, pero la pantalla sigue igualita.

    ; --- 1. CHECAR ENTER ---
    cmp al, 13
    je @@es_enter

    ; --- 2. CHECAR BACKSPACE ---
    cmp al, 8
    je @@es_backspace

    ; --- 3. CHECAR LIMITE ---
    jcxz @@leer_ninja ; Si no hay espacio, ignoramos la tecla

    ; --- 4. ES UNA LETRA NORMAL ---
    ; Primero la guardamos
    stosb
    dec cx
    
    ; Y AHORA SI, LA IMPRIMIMOS MANUALMENTE
    mov dl, al      ; Movemos la letra a DL para imprimirla
    mov ah, 02h     ; Funcion imprimir caracter
    int 21h
    
    jmp @@leer_ninja

@@es_backspace:
    ; AQUI ES DONDE LE PARAMOS EL CARRO AL CURSOR
    cmp di, bx      ; ?Estoy en el inicio?
    je @@leer_ninja ; SI: Ignora todo. Como estamos en modo ninja (08h),
                    ; el cursor NO SE HA MOVIDO y no se movera.
                    ; Simplemente regresa a esperar otra tecla.

    ; NO: Ah, entonces si borra.
    dec di          ; Memoria atras
    inc cx          ; Recupera espacio

    ; Efecto visual manual
    mov ah, 02h
    mov dl, 8       ; Retroceso
    int 21h
    mov dl, 32      ; Espacio (borra tinta)
    int 21h
    mov dl, 8       ; Retroceso
    int 21h
    
    jmp @@leer_ninja

@@es_enter:
    mov al, 0       ; Ponemos el 0 final
    stosb
    
    ; Imprimimos el Enter visualmente para que baje de renglon
    mov ah, 02h
    mov dl, 13      ; Retorno de carro
    int 21h
    mov dl, 10      ; Salto de linea
    int 21h

    pop dx
    pop di
    pop cx
    pop bx
    pop ax
    ret
endp agets_ninja

end start
