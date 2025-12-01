ideal
dosseg
model small
stack 256

dataseg
codsal db 0
num1 dw ? 
num2 dw ?
denF dw ?
numF dw ? 
mcdF dw ? ; Resultado Final

codeseg
inicio:
mov ax, @data ; Inicializa el
mov ds, ax ; segmento de datos

mov ax, [num1]
mov dx, [num2]
call redfrac

salir: ; en este punto ax y dx ya deberian estar reducidas
mov ah, 04Ch
mov al, [codsal]
int 21h

proc redfrac

; Declara las variables locales en la pila

 local num: word, den: word = tamVarsLoc
 push bp ; Preserva BP
 mov bp, sp ; Crea variables
 sub sp, tamVarsLoc ; locales en la pila
 push bx ; Preserva BX
 
 ;si ax es mayor que bx, ax sera el numerador
 cmp ax,dx
 ja @@mayor
 ;de lo contrario bx sera el numerador
 mov [num], dx ; num = numerador
 mov [den], ax ; den = denominador
 mov bx, ax ; se mueve a bx el valor del denominador porqu lo ocupara mcd
 mov ax,dx ; el numerador a ax
 jmp @@continuar
 
 @@mayor: 
 mov [num], ax ; num = numerador
 mov [den], dx ; den = denominador
 mov bx, dx ; se mueve a bx el valor del denominador porqu lo ocupara mcd
 @@continuar:
 
 call mcd ; mcd(ax, bx) => ax
 
 mov bx, ax ; bx = MCD
 xor dx, dx ; liberar dx para la division
 mov ax, [num] 
 div bx
 mov [numF],ax
 
 mov ax, [den]
 div bx
 mov dx, ax    ;ASIGNAR VALORES
 mov [denF],ax
 
 mov [mcdF],bx ; Guardar el resultado final a esta variable
 
 pop bx ; Restaura BX
 mov sp, bp ; Elimina variables
 ; locales
 pop bp ; Restaura BP
 ret
 
endp redfrac

proc mcd
 push dx
 @@ciclo:
 xor dx, dx ;Eliminar el residuo de la division
 div bx ;dividir numerador entre denominador
 
 mov ax, bx ; bx es el antiguo divisor que pasa a ser dividendo
 mov bx, dx ; dx es el residuo anterior pasado como divisor
 cmp bx, 0h
 jnz @@ciclo ;mientras bx no sea 0 repetir el ciclo
 pop dx
 ret
endp mcd

end inicio