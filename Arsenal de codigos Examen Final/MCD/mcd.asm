ideal
dosseg
model small

    codeseg
    public mcd

    ; procedimiento MCD
proc mcd
    push bx
    push dx ; Guardamos DX porque lo usaremos para el residuo

    ; Queremos que AX sea siempre el dividendo y BX el divisor.
    ; Usaremos BX en lugar de DX para la division porque 'div' usa DX:AX.
    
    mov bx, dx      ; Movemos el segundo numero a BX
    
@@ciclo:
    cmp bx, 0       ; ?El divisor es 0?
    je @@fin        ; Si si, terminamos. El MCD esta en AX.
    
    ; Preparar division: DX:AX / BX
    xor dx, dx      ; Limpiamos parte alta para division de 16 bits
    div bx          ; AX = Cociente, DX = Residuo
    
    ; Euclides: A = B, B = Residuo
    mov ax, bx      ; El viejo divisor (B) pasa a ser el nuevo dividendo (A)
    mov bx, dx      ; El residuo pasa a ser el nuevo divisor (B)
    
    jmp @@ciclo     ; Repetir

@@fin:
    pop dx
    pop bx
    ret
endp mcd

    end