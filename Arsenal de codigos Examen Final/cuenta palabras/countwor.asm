ideal
dosseg
model small

    codeseg
    public countWords

    ; procedimiento para contar palabras
    proc countWords
    push si
    push dx
    push bx         ; guardamos bx porque lo usaremos de contador
    
    xor bx, bx      ; contador de palabras en 0
    xor dl, dl      ; estado: 0 = fuera, 1 = dentro
    
    cld             ; leer hacia adelante

ciclo:
    lodsb           ; lee caracter en al y avanza si
    
    ; checar fin de cadena
    cmp al, 0
    je fin
    
    ; checar si es espacio
    cmp al, ' '
    je es_espacio
    
    ; es una letra
    cmp dl, 1       ; ya estabamos dentro de una palabra?
    je siguiente    ; si si, ignorar
    
    ; si no, es nueva palabra
    inc bx          ; sumamos 1 al contador
    mov dl, 1       ; cambiamos estado a dentro
    jmp siguiente

es_espacio:
    mov dl, 0       ; cambiamos estado a fuera

siguiente:
    jmp ciclo

fin:
    mov ax, bx      ; pasamos el resultado final a ax
    
    pop bx          ; restauramos registros
    pop dx
    pop si
    ret
    endp countWords

    end

    end