ideal
dosseg
model small
stack 100h

msg db 'Hola estoy ensamblado$'

codeseg
inicio:
        mov ax, @data 
        mov ds, ax
        
        mov dx, offset msg
        mov ah, 09h
        int 21h
   
salir: 
        mov ax, 0C00h
        int 21h

        end inicio