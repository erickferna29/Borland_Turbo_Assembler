ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1 db 'Escriba el numero 1: ', 0
    msg2 db 'Escriba el numero 2: ',0
    msg3 db 'El MCD es: ',0
    snum1  db 21 dup(?) 
    snum2 db 21 dup(?) 
    num1 dw ?
    num2 dw ?
    Elmcd dw ?
    smcd db 21 dup(?)
    
codeseg
extrn mcd:proc, agets:proc,aputs:proc,itoa:proc,aatoi:proc

inicio:
    mov ax,@data
    mov ds,ax
    mov es,ax
    
    ; 1. Pedir dato 1
    mov si, offset msg1
    call aputs
    
    ; 2. Leer dato 1
    mov di, offset snum1
    mov cx, 20
    call agets
    
    ; 3. Pedir dato 2
    mov si, offset msg2
    call aputs
    
    ; 4. Leer dato 2
    mov di, offset snum2
    mov cx, 20
    call agets

    ;5. convertir a int los numeros
    ;convetir num1
    mov si, offset snum1
    call aatoi      ; Devuelve valor en AX
    mov [num1], ax
    
    ;convertir num2
    mov si, offset snum2
    call aatoi      ; Devuelve valor en AX
    mov [num2], ax
    
    ;6. aplicar el mcd
    ;mcd espera ax,dx
    mov ax, [num1]
    mov dx, [num2]
    call mcd
    mov [Elmcd],ax ;guardamos el resultado
    
    ; 7. Imprimir "Resultado: 
    mov si, offset msg3
    call aputs
    
    ;en este codigo especifico dx tiene trash
    xor dx,dx
    
    ; 8. Convertir Numero (DX:AX) a Texto en mcd
    mov di, offset smcd
    call itoa
    
    ; 9. Imprimir el numero convertido
    mov si, offset smcd
    call aputs
    
    ; pausa
    mov ah, 0Ch     ; funcion limpia buffer
    mov al, 08h     ; Funcion leer caracter
    int 21h         ; no ejecutes hasta que el usuario presione algo
fin:
    mov ax, 04Ch
    mov al,[codsal]
    int 21h
    
end inicio