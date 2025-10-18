ideal
dosseg
model small
stack 256

dataseg
codsal db 0
fibo dw ?
n db ?

codeseg
inicio:
    mov ax,@data
    mov ds,ax
    
    mov ch,[n]
    cmp [n],0
    je cero
    cmp [n],1
    je uno
    mov bh,2
    mov ax,0
    mov dx,1
mientras:
    add ax,dx
    xchg ax,dx
    inc bh
    
    cmp bh,ch
    jbe mientras

    mov [fibo],dx
    jmp salir
cero:
    mov [fibo],0
    jmp salir
uno:
    mov [fibo],1
salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    end inicio
