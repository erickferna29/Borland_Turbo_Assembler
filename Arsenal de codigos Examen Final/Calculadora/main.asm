ideal
dosseg
model small
stack 256

dataseg
    codsal db 0
    msg1 db 'Escribe la operacion a realizar: ', 0
    msg2 db 'El resultado es: ',0
    soper  db 21 dup(?) 
    temp db 20 dup(?)
    sresul db 35 dup(?) 
    resul dd ?
    
    sufDec db 'd ', 0
    sufHex db 'h ', 0
    sufBin db 'b', 0

codeseg
    extrn aputs:proc,astrcat:proc,agets:proc,sscan:proc,itoa:proc,itoa_hex:proc,itoa_bin:proc
inicio:
    mov ax,@data
    mov ds,ax
    mov es,ax
    
    mov [byte ptr sresul], 0
    ; 1. Pedir dato - aprender bien a concatenar cadanas 
    mov si, offset msg1
    call aputs
    
    ; 2. Leer dato 
    mov di, offset soper
    mov cx, 20
    call agets
    ;3. Separar cadenas
    mov si, offset soper
    call sscan
    
    xor dx,dx
    
    cmp cl,'+'
    je suma
    
    cmp cl,'-'
    je resta
    
    cmp cl,'*'
    je multi
    
divi:
div bx
jmp guardar    
multi:
mul bx
jmp guardar    
suma:
add ax,bx
jmp guardar
resta:
sub ax,bx

guardar:
mov [word resul],ax
mov [word resul+2],dx 

    ; 4. Formacion de la cadena

    ; decimal
    ; Convertir numero a temp
    mov di, offset temp
    call itoa          
    
    ; Concatenar temp a sresul
    mov di, offset sresul
    mov si, offset temp
    call astrcat       
    
    ; Concatenar sufijo d
    mov si, offset sufDec
    call astrcat    
    
    ; hexa
    mov ax, [word ptr resul]    
    mov dx, [word ptr resul+2]
    
    mov di, offset temp
    call itoa_hex      
    
    mov di, offset sresul
    mov si, offset temp
    call astrcat       
    
    mov si, offset sufHex
    call astrcat       
    
    ;binario
    mov ax, [word ptr resul]
    mov dx, [word ptr resul+2]
    
    mov di, offset temp
    call itoa_bin      
    
    mov di, offset sresul
    mov si, offset temp
    call astrcat       
    
    mov si, offset sufBin
    call astrcat        
    
    ;mostramos el recultado final
    mov si, offset msg2
    call aputs
    
    mov si, offset sresul ; Imprimimos la cadena final
    call aputs
    
fin:
    mov ah, 04Ch
    mov al,[codsal]
    int 21h
    
end inicio
    
