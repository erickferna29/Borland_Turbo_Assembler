    ideal
    dosseg
    model small
    stack 256

dataseg
    codsal db 0
    num1 dd -1
    num2 dd -2
    numM dd ?

codeseg
inicio:
     mov ax, @data 
     mov ds, ax
        
     mov ax,[word num1]
     mov dx,[word num1+2]
     mov cx,[word num2]
     mov bx,[word num2+2]
     
     cmp dx,bx
     jg num1M
     jl num2M
     
     cmp ax,cx
     ja num1M
num2M:
     mov ax,cx
     mov dx,bx
     jmp finCmp
num1M:
finCmp:
     mov [word numM],ax
     mov [word numM+2],dx 
salir: 
     mov ah, 04Ch
     mov al, [codsal]
     int 21h

        end inicio