ideal
dosseg
model small

    codeseg
    public itoa,ultoa

; =================================================================
; PROCEDIMIENTO: ITOA (Integer to ASCII)
; Convierte un numero de 32 bits (DX:AX) a cadena decimal
; Entrada: DX:AX = Numero a convertir
;          DI    = Buffer donde guardar la cadena
; =================================================================
proc itoa
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    
    ; Checar signo (solo si DX es negativo)
    test dx, 8000h
    jz @@positivo
    
    ; Es negativo: Poner '-' y hacer complemento a 2
    mov [byte ptr di], '-'
    inc di
    
    ; Negar DX:AX (Complemento a 2 de 32 bits)
    not dx
    not ax
    add ax, 1
    adc dx, 0
    
@@positivo:
    call ultoa      ; Convertir la magnitud sin signo
    
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp itoa

; =================================================================
; SUBRUTINA: ULTOA (Unsigned Long to ASCII)
; Convierte DX:AX positivo a cadena en [DI]
; =================================================================
proc ultoa
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    
    mov bx, 10      ; Divisor = 10
    xor cx, cx      ; Contador de digitos
    
    ; Caso especial: Si el numero es 0
    mov si, dx
    or si, ax
    jnz @@ciclo_div
    mov [byte ptr di], '0'
    inc di
    jmp @@terminar
    
@@ciclo_div:
    ; Division de 32 bits entre 16 bits (DX:AX / BX)
    ; Truco: Dividir parte alta, luego parte baja con residuo
    push ax         ; Guardar parte baja
    mov ax, dx      ; Mover parte alta a AX para dividir
    xor dx, dx      ; Limpiar DX
    div bx          ; AX = Alta/10, DX = Residuo Alta
    
    mov si, ax      ; Guardar cociente alto temporalmente
    pop ax          ; Recuperar parte baja original
    div bx          ; (ResiduoAlta:Baja) / 10
    
    ; Ahora: DX = Residuo final (Digito), AX = Cociente Bajo, SI = Cociente Alto
    push dx         ; Guardar digito en pila (salen al reves)
    inc cx          ; Contar digito
    
    ; Reconstruir el numero para la siguiente vuelta (DX:AX = Cociente)
    mov dx, si      ; Parte alta nueva
    ; AX ya tiene la parte baja nueva
    
    ; Checar si ya es cero
    mov si, dx
    or si, ax
    jnz @@ciclo_div ; Si no es cero, repetir
    
    ; Sacar digitos de la pila y guardarlos
@@sacar_pila:
    pop dx          ; Recuperar digito (0-9)
    add dl, '0'     ; Convertir a ASCII
    mov [di], dl    ; Guardar en buffer
    inc di
    loop @@sacar_pila
    
@@terminar:
    mov [byte ptr di], 0 ; Terminador nulo
    
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp ultoa
end