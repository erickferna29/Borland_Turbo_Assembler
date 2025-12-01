ideal
dosseg
model small

    codeseg
    public Ordenar, triang

    ; procedimiento para ordenar los lados
    ; deja los valores en ax, bx, cx de menor a mayor
proc Ordenar
    ; checar si ax es mayor que bx
    cmp ax, bx
    jbe @@paso1
    xchg ax, bx     ; si es mayor, los cambiamos
@@paso1:

    ; checar si bx es mayor que cx
    cmp bx, cx
    jbe @@paso2
    xchg bx, cx     ; cambiamos para que el mayor quede en cx
@@paso2:

    ; checar de nuevo el primero con el segundo por si cambio algo
    cmp ax, bx
    jbe @@fin_sort
    xchg ax, bx     ; acomodo final
@@fin_sort:
    ret
endp Ordenar

    ; procedimiento para saber el tipo de triangulo
    ; recibe: ax, bx, cx (ya ordenados)
    ; regresa: al con la letra 'N', 'E', 'I' o 'S'
proc triang
    push dx         ; guardar por si acaso
    
    ; regla de oro: la suma de los chicos debe ser mayor al grande
    push ax         ; guardar ax original
    add ax, bx      ; sumar los dos chicos
    cmp ax, cx      ; comparar suma contra el lado mayor
    pop ax          ; recuperar ax
    
    ja @@es_triangulo ; si suma > mayor, si se arma
    
    ; si no, no cierra el triangulo
    mov al, 'N'
    jmp @@salir_tri

@@es_triangulo:
    ; checar equilatero: todos iguales
    ; como estan ordenados, basta ver si el chico es igual al grande
    cmp ax, cx
    jne @@checar_iso
    mov al, 'E'
    jmp @@salir_tri

@@checar_iso:
    ; checar isosceles: dos iguales
    cmp ax, bx      ; son iguales el chico y el mediano?
    je @@es_iso
    cmp bx, cx      ; son iguales el mediano y el grande?
    je @@es_iso
    
    ; si no fue ninguno, es escaleno
    mov al, 'S'
    jmp @@salir_tri

@@es_iso:
    mov al, 'I'

@@salir_tri:
    pop dx
    ret
endp triang

    end