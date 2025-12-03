ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1   db 'Escribe la division: ', 0
    msgC   db 13, 10, 'Cociente: ', 0
    msgR   db 13, 10, 'Residuo: ', 0
    
    buffer db 30 dup(?)
    temp   db 10 dup(?)
    
    dvidendo dd ?    
    divisor  dw ?    
    residuo  dw ?
    cociente dw ?

codeseg
    extrn aputs:proc, agets:proc
    extrn aatoi:proc, itoa:proc

inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; pedir la cadena completa
    mov si, offset msg1
    call aputs
    
    mov di, offset buffer
    mov cx, 29
    call agets      

    ; buscar la diagonal para separar
    mov di, offset buffer
    
buscar_slash:
    mov al, [di]
    cmp al, 0       
    je salir      
    
    cmp al, '/'     
    je encontrado
    
    inc di
    jmp buscar_slash
    
encontrado:
    ; romper la cadena aqui
    mov [byte ptr di], 0  
    
    ; primer numero (dividendo)
    mov si, offset buffer 
    call aatoi            
    
    ; guardar en 32 bits
    mov [word ptr dvidendo], ax
    mov [word ptr dvidendo+2], 0  
    
    ; segundo numero (divisor)
    lea si, [di+1]        
    call aatoi            
    mov [divisor], ax

    ; preparar registros
    mov ax, [word ptr dvidendo]   
    mov dx, [word ptr dvidendo+2] 
    mov bx, [divisor]
    
    ; llamar a la logica interna
    call div_restas
    
    ; guardar resultados
    mov [residuo], ax
    mov [cociente], cx

    ; mostrar cociente
    mov si, offset msgC
    call aputs
    mov ax, [cociente]
    xor dx, dx          
    mov di, offset temp
    call itoa
    mov si, offset temp
    call aputs
    
    ; mostrar residuo
    mov si, offset msgR
    call aputs
    mov ax, [residuo]
    xor dx, dx
    mov di, offset temp
    call itoa
    mov si, offset temp
    call aputs

    ; pausa
    mov ah, 00h
    int 16h

salir:
    mov ah, 04Ch
    mov al, [codsal]
    int 21h

; procedimiento local de division por restas
proc div_restas
    xor cx, cx             ; limpiamos el contador (cociente)

    ; validacion division por cero
    cmp bx, 0
    je fin_div_proc

ciclo_resta:
    ; checar si dividendo >= divisor
    cmp dx, 0
    ja es_mayor            ; si tiene parte alta, es mayor
    
    cmp ax, bx
    jb fin_div_proc        ; si es menor, terminamos

es_mayor:
    sub ax, bx             ; restar parte baja
    sbb dx, 0              ; restar acarreo a parte alta
    
    inc cx                 ; sumamos 1 al cociente
    jmp ciclo_resta        

fin_div_proc:
    ret
endp div_restas

end inicio