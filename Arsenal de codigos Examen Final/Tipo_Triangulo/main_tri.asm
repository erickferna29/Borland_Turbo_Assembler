ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    
    ; mensajes para pedir datos
    msg1   db 13, 10, 'Lado 1: ', 0
    msg2   db 13, 10, 'Lado 2: ', 0
    msg3   db 13, 10, 'Lado 3: ', 0
    msgRes db 13, 10, 'Tipo de Triangulo: ', 0
    
    ; respuestas posibles
    strEqu db 'Equilatero', 0
    strIso db 'Isosceles', 0
    strEsc db 'Escaleno', 0
    strNot db 'No es un triangulo', 0
    
    buffer db 20 dup(?) 
    lado1  dw ?
    lado2  dw ?
    lado3  dw ?

codeseg
    ; importamos tus herramientas
    extrn aputs:proc, agets:proc
    extrn aatoi:proc
    ; importamos la logica del triangulo
    extrn Ordenar:proc, triang:proc

inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; pedir lado 1
    mov si, offset msg1
    call aputs
    mov di, offset buffer
    mov cx, 19
    call agets      
    
    ; convertir a numero
    mov si, offset buffer
    call aatoi      
    mov [lado1], ax
    
    ; pedir lado 2
    mov si, offset msg2
    call aputs
    mov di, offset buffer
    mov cx, 19
    call agets
    
    ; convertir a numero
    mov si, offset buffer
    call aatoi
    mov [lado2], ax
    
    ; pedir lado 3
    mov si, offset msg3
    call aputs
    mov di, offset buffer
    mov cx, 19
    call agets
    
    ; convertir a numero
    mov si, offset buffer
    call aatoi
    mov [lado3], ax

    ; cargar valores en registros para operar rapido
    mov ax, [lado1]
    mov bx, [lado2]
    mov cx, [lado3]
    
    call Ordenar    ; los acomoda de menor a mayor
    call triang     ; nos dice que tipo es en AL
    
    ; guardar el resultado un momento
    push ax         
    
    ; mostrar mensaje de resultado
    mov si, offset msgRes
    call aputs
    
    ; recuperar resultado
    pop ax          
    
    ; comparar para ver que mensaje imprimimos
    cmp al, 'N'
    je @@es_no
    cmp al, 'E'
    je @@es_equi
    cmp al, 'I'
    je @@es_iso
    cmp al, 'S'
    je @@es_esc
    jmp @@fin       

@@es_no:
    mov si, offset strNot
    jmp @@imprimir
@@es_equi:
    mov si, offset strEqu
    jmp @@imprimir
@@es_iso:
    mov si, offset strIso
    jmp @@imprimir
@@es_esc:
    mov si, offset strEsc
    jmp @@imprimir

@@imprimir:
    call aputs      ; imprime la palabra completa

@@fin:
    ; salir
    mov ah, 04Ch
    mov al, [codsal]
    int 21h

end inicio