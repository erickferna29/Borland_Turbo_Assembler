ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    ; mensajes
    msg1 db 'Cuantos alumnos son?: ', 0
    msg2 db 13, 10, 'Escribe la calificacion: ', 0
    msg3 db 13, 10, 'El promedio final es: ', 0
    
    ; buffers y variables
    buffer db 20 dup(?)   ; aqui leemos lo que escribes
    
    total  dw ?           ; aqui guardamos cuantos son (el divisor)
    suma   dw 0           ; esta es la bolsa (acumulador)

codeseg
    ; importamos tus herramientas
    extrn aputs:proc, agets:proc
    extrn aatoi:proc, itoa:proc  ; necesitamos aatoi para leer numeros

inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    ; paso 1: preguntar cuantos son
    mov si, offset msg1
    call aputs
    
    mov di, offset buffer
    mov cx, 19
    call agets          ; leemos texto
    
    mov si, offset buffer
    call aatoi          ; convertimos texto a numero
    mov [total], ax     ; guardamos el total para dividir al final
    
    ; preparamos el contador de vueltas
    mov cx, ax          ; cx es el contador del ciclo
    
    ; si dijo 0 alumnos, nos vamos para no dividir entre cero
    cmp ax, 0
    je fin

    ; paso 2: el bucle (pedir y sumar)
ciclo_pedir:
    push cx             ; guardamos cx en la pila porque se ensucia
    
    ; pedir calificacion
    mov si, offset msg2
    call aputs
    
    mov di, offset buffer
    mov cx, 19
    call agets          ; leemos calificacion
    
    ; convertir a numero
    mov si, offset buffer
    call aatoi          ; ax tiene el numero
    
    ; echar a la bolsa
    add [suma], ax      ; suma = suma anterior + nueva calif
    
    pop cx              ; recuperamos el contador
    loop ciclo_pedir    ; resta 1 a cx. si no es 0, repite.

    ; paso 3: la division final
    ; promedio = suma / total
    
    mov ax, [suma]      ; cargamos el peso total de la bolsa
    xor dx, dx          ; limpiamos parte alta
    
    div [total]         ; dividimos ax / total. resultado en ax.
    
    ; guardamos el promedio en dx:ax para itoa
    xor dx, dx          
    
    ; mostrar resultado
    push ax             ; guardamos el resultado un momento
    
    mov si, offset msg3
    call aputs
    
    pop ax              ; recuperamos resultado
    mov di, offset buffer
    call itoa           ; convertimos numero a texto
    
    mov si, offset buffer
    call aputs          ; imprimimos el promedio

fin:
    mov ah, 04Ch
    mov al, [codsal]
    int 21h
    
end inicio