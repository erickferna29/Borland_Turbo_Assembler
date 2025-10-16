ideal 
dosseg 
model small
stack 256

dataseg
codsal db 0
a dw ?
b dw ?
c dw ?
r db ?

codeseg
inicio:
   mov ax, @data
   mov ds, ax
   
   mov ax,[a]
   add ax,[b]
   cmp ax,[c]
   jbe notri
   mov ax,[b]
   add ax,[c]
   cmp ax,[a]
   jbe notri
   mov ax,[a]
   add ax,[c]
   cmp ax,[b]
   jbe notri
sitri:
   mov ax,[a]
   cmp ax,[b]
   jne verIso
   cmp ax,[c]
   jne verIso
   mov ax,[b]
   cmp ax,[c]
   jne verIso
reg:
   mov [r],'R'
   jmp salir
verIso:
   mov ax,[a]
   cmp ax,[b]
   je iso
   cmp ax,[c]
   je iso
   mov ax,[b]
   cmp ax,[c]
   je iso
esca:
   mov [r],'E'
   jmp salir
iso:
   mov [r],'I'
   jmp salir
notri:
   mov [r],'N'
salir:
   mov ah,04Ch
   mov al,[codsal]
   int 21h
    end inicio
   