ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1 db 'Escriba la fraccion: ', 0
    msg3 db 'El MCD es: ',0
    entrada  db 21 dup(?) 
    num1 dw ?
    num2 dw ?
    Elmcd dw ?
    smcd db 21 dup(?)
    
codeseg
extrn mcd:proc, agets:proc,aputs:proc,itoa:proc,aatoi:proc,sscan:proc

inicio:
    mov ax,@data
    mov ds,ax
    mov es,ax
    
    ; 1. Pedir dato 1
    mov si, offset msg1
    call aputs
    
    ; 2. Leer dato 1
    mov di, offset entrada
    mov cx, 20
    call agets
    
    ;3. Separar cadenas
    mov si, offset entrada
    call sscan
    
    ;4. aplicar el mcd
    ;mcd espera ax,bx
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

fin:
    mov ah, 04Ch
    mov al,[codsal]
    int 21h
    
end inicio