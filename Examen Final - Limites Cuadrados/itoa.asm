ideal
dosseg
model small

    codeseg
    public itoa,ultoa,itoa_hex,itoa_bin

    ; itoa integer to ascii
; Convierte un numero de palabra doble a decimal
proc itoa
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    
    ; checar signo solo si es negativo dx
    test dx, 8000h
    jz @@positivo
    
    ; si es negativo poner -
    mov [byte ptr di], '-'
    inc di
    
    ; negar dx:ax
    not dx
    not ax
    add ax, 1
    adc dx, 0
    
@@positivo:
    call ultoa      ; Convertir sin signo aun
    
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp itoa

;func que convierte a ascii sin signo
proc ultoa
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    
    mov bx, 10      
    xor cx, cx      
    
    ;Si el numero es 0
    mov si, dx
    or si, ax
    jnz @@ciclo_div
    mov [byte ptr di], '0'
    inc di
    jmp @@terminar
    
@@ciclo_div:
    ;dividir parte alta, luego parte baja con residuo
    push ax         ;guardar parte baja
    mov ax, dx      ;mover parte alta a AX para dividir
    xor dx, dx      ; Limpiar DX
    div bx          ;ax = alta/10, DX = Residuo Alta
    
    mov si, ax      ;guardar cociente alto temporalmente
    pop ax          ;recuperar parte baaj original
    div bx          ; (ResiduoAlta:Baja) / 10
    
    ; Ahora: DX = Residuo final (Digito), AX = Cociente Bajo, SI = Cociente Alto
    push dx         ;guardra digito en pial (salen al reves)
    inc cx          ;contar digito
    
    ;construir el numero para la siguiente vuelta (DX:AX = Cociente)
    mov dx, si      ; Parte alta nueva
    ;ax ya tiene la parte baja nueva
    
    ; Checar si ya es cero
    mov si, dx
    or si, ax
    jnz @@ciclo_div ; Si no es cero, repetir
    
    ; Sacar digitos de la pila y guardarlos
@@sacar_pila:
    pop dx          ;recuperar digito 0 a 9
    add dl, '0'     ;convertir a ascii
    mov [di], dl    ;guardar en buffer
    inc di
    loop @@sacar_pila
    
@@terminar:
    mov [byte ptr di], 0
    
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp ultoa
;func decimal a hexa
proc itoa_hex
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    
    mov bx, 16      
    xor cx, cx      
    
    ;caso especial si 0
    mov si, dx
    or si, ax
    jnz @@ciclo_hex
    mov [byte ptr di], '0'
    inc di
    jmp @@fin_hex
    
@@ciclo_hex:
    ; Division de palabra doble (DX:AX / palabra)
    push ax         
    mov ax, dx      
    xor dx, dx      
    div bx          ; Dividir Alta
    mov si, ax      
    pop ax          
    div bx          ; Dividir Baja
    
    push dx         
    inc cx          
    
    mov dx, si      
    mov si, dx
    or si, ax
    jnz @@ciclo_hex 
    
@@sacar_hex:
    pop dx          
    cmp dl, 9
    ja @@es_letra
    add dl, '0'     
    jmp @@guardar
@@es_letra:
    add dl, 55      
    
@@guardar:
    mov [di], dl
    inc di
    loop @@sacar_hex
    
@@fin_hex:
    mov [byte ptr di], 0   
    
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp itoa_hex

; func dec a bin
proc itoa_bin
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    
    mov bx, 2     
    xor cx, cx
    
    ; Caso 0
    mov si, dx
    or si, ax
    jnz @@ciclo_bin
    mov [byte ptr di], '0'
    inc di
    jmp @@fin_bin
    
@@ciclo_bin:
    push ax
    mov ax, dx
    xor dx, dx
    div bx
    mov si, ax
    pop ax
    div bx
    
    push dx         
    inc cx
    
    mov dx, si
    mov si, dx
    or si, ax
    jnz @@ciclo_bin
    
@@sacar_bin:
    pop dx
    add dl, '0'     
    mov [di], dl
    inc di
    loop @@sacar_bin
    
@@fin_bin:
    mov [byte ptr di], 0
    
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp itoa_bin
end