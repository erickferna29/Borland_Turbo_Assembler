ideal
dosseg
model small

    codeseg
    public sscan,aatoi,valC,atou,obtenBase,astrcat

    ;procedimiento: sscan

proc sscan
    ;guardamos si y di
    push si
    push di
    push dx
    ;di sera nuestro scanner
    mov di, si
    
    ;vamos a buscar el signo
@@buscarOp:
    mov al,[di] ;leemos el char act
    
    ;comparamos con los op
    cmp al, '+'
    je @@encontrado
    cmp al, '-'
    je @@encontrado
    cmp al, '*'
    je @@encontrado
    cmp al, '/'
    je @@encontrado
    
    ;aumentamos di para buscar en el siguiente lugar
    inc di          
    jmp @@buscarOp
    
    ;funcion donde se corta la cadena
@@encontrado:
    xor cx,cx
    ;guardamos el signo en cx
    mov cl,al
    ;lo guardamos por que s epodria ensuciar
    push cx
    
    ;cambiamos el signo por 0 para que piense que la cadena acaba ahi
    mov [byte ptr di], 0
    
    ;primer num
    call aatoi
    push ax
    
    ;segundo num
    lea si, [di+1]
    call aatoi
    mov bx, ax
    
    ; sacamos de la pila
    pop ax
    pop cx
    
@@fin:
    ;sacamos di y si
    pop dx
    pop di
    pop si
    ret
    endp sscan
    
proc    aatoi 
        push    bx                ; Preserva BX, CX, DX, SI 
        push    cx 
        push    dx 
        push    si 
                                                           
        call    astrupr           ; strup(cadena) 
        call    astrlen           ; CX = strlen(cadena) 
        call    obtenSigno        ; DX = [SI] == '-, 
                                  ; SI++, CX-- 
        call    obtenBase         ; BX = base, CX-- 
        call    atou              ; AX = atou(cadena) 
        cmp     dx, 0             ; if(dx == 0)  
        je      @@sigi             ;    goto @@sig 
        neg     ax                ; ax = -ax 
                                                           
@@sigi: 
        pop     si                ; Restaura SI, DX, CX, BX 
        pop     dx 
        pop     cx 
        pop     bx 
        ret 
endp    aatoi
 
proc    obtenSigno 
        xor     dx, dx            ; dx = 0 
        cmp     [byte si], '+'    ; if([si] == '+) 
        je      @@pos             ;    goto @@pos 
        cmp     [byte si], '-'    ; if([si] == '-) 
        je      @@nega             ;    goto @@neg 
        jmp     @@fin             ; goto @@fin 
 
@@nega:  mov     dx, 1             ; Dx = 1 
@@pos:  inc     si                ; SI++ 
        dec     cx                ; CX-- 
@@fin:  ret 
endp    obtenSigno

proc    obtenBase 
        push    si                ; Preserva SI 
        add     si, cx            ; SI = cadena + strlen(  
        dec     si                ;      cadena) ? 1 
                                                           
        mov     bx, 10            ; base = 10 
 
 
        cmp     [byte si], 'B'    ; if([si] == ') 
        je      @@bin             ;    goto @@bin  
        cmp     [byte si], 'H'    ; if([si] == ') 
        je      @@hex             ;    goto @@hex 
        cmp     [byte si], 'D'    ; if([si] == 'D) 
        je      @@decr             ;    goto @@dec 
        jmp     @@fin             ; goto @@fin 
 
@@bin:  mov     bx, 2             ; base = 2 
        jmp     @@decr             ; goto @@dec 
@@hex:  mov     bx,16             ; Base = 16 
@@decr:  dec     cx                ; CX-- 
@@fin: 
        pop     si                ; Restaura SI 
        ret 
endp    obtenBase
 
proc    atou 
        push   dx                 ; Preserva DX, DI 
        push   di  
        xor     ax, ax
        jcxz    @@fin             ; if(!CX) goto @@fin 
 
        xor     di, di            ; n = 0 
@@do:                             ; do 
                                  ; { 
        mov     ax, di            ;    AX = base*n 
        mul     bx 
        mov     dl, [byte si]     ;    DX = [SI] 
        xor     dh, dh 
        call    valC              ;    DX = val([SI]) 
        add     ax, dx            ;    AX = base*n + DX 
        mov     di, ax            ;    n = AX 
        inc     si                ;    SI++ 
        loop    @@do              ; } 
                                  ; while(--CX > 0) 
                                                           
        mov     ax, di 
@@fin:  pop     di                ; Restaura DI, DX 
        pop     dx 
        ret 
endp    atou

proc    valC 
        cmp     dx, '9' 
        ja      @@hex  
        sub     dx, '0' 
        ret 
        @@hex:  
        sub     dx, 'A' - 10 
        ret 
endp    valC 

proc    astrlen 
        push   ax                 ; Preserva AX, DI 
        push   di 
 
        mov     di, si            ; DI = SI 
        xor     al, al            ; AL = 0 
 
        cld                       ; Autoincrementa DI 
@@whi:  scasb                     ; while([DI++]); 
        jnz     @@whi 
 
        mov     cx, di            ; CX = DI - SI ? 1 
        sub     cx, si 
        dec     cx 
 
        pop    di                ; Restaura DI, AX 
        pop     ax  
        ret 
endp    astrlen 

proc    astrupr 
        push    ax                ; Preserva AX, CX, SI, DI 
        push    cx 
        push    si 
        push    di 
 
        call    astrlen           ; CX = strlen(cadena) 
 
        jcxz    @@fin             ; if(!CX) goto @@fin 
 
        mov     di, si            ; DI = SI 
 
        cld                       ; Autoincrementa SI, DI 
@@do:                             ; do 
                                  ; { 
        lodsb                     ;    AL = [SI++] 
        cmp     al, 'a'            
        jb      @@sigi          
        cmp     al, 'z'  
        ja      @@sigi 
        sub     al, 'a'-'A'       ;    AL = toupper(AL) 
 
@@sigi:  
        stosb                     ;    [DI++] = AL 
        loop    @@do              ; } 
                                  ; while(--CX > 0) 
@@fin:  pop     di                ; Restaura DI, SI, CX, AX 
        pop     si 
        pop     cx 
        pop     ax 
        ret 
endp    astrupr 
; PROCEDIMIENTO: ASTRCAT (Concatenar Cadenas)
proc astrcat
    push ax
    push si
    push di
    
    ; 1. Buscar el final de la cadena Destino (DI)
    xor al, al      ; Buscamos el 0
    cld
@@buscar_fin:
    scasb           ; Compara AL con [DI], avanza DI
    jnz @@buscar_fin
    dec di          ; Retroceder 1 para sobreescribir el 0
    
    ; 2. Copiar Fuente (SI) al final de Destino (DI)
@@copiar:
    lodsb           ; Cargar letra de SI en AL
    stosb           ; Guardar letra en DI
    cmp al, 0       ; ?Fue el terminador nulo?
    jne @@copiar    ; Si no, seguir copiando
    
    pop di
    pop si
    pop ax
    ret
endp astrcat
end