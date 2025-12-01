ideal
dosseg
model small
stack 256

TAMMAX equ 100
dataseg
    codsal db 0 
    mayor dw ?
    nDatos dw ?
    datos dw TAMMAX dup(?)
codeseg
inicio:
   mov ax,@data
   mov ds,ax
   mov es,ax
   
   mov ax,[datos]
   mov bx, [nDatos]
   dec bx
   sal bx,1
   xor si, si
   
while:
    cmp si, bx
    jae endwhi
    inc si
    cmp ax,[si+datos]
    jae while
    mov ax,[si+datos]
    
    jmp while
endwhi:
    mov [mayor, ax]
    
salir:
    mov ah, 04Ch
    mov al,[codsal]
    int 21h
    
    end inicio
   
final:
   mov ah,04Ch
   mov al,[codsal]
   int 21h