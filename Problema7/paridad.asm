ideal
dosseg
model small
stack 256

dataseg
codsal db 0
dato db ?

codeseg 
inicio:
    mov ax,@data
    mov ds,ax
    
    xor ax,ax
    mov cl, 7
    mov al, [dato]
    
uno_count:
    shr al, 1           
    jnc cero       
    inc ah            
cero:
    loop uno_count 
    test ah, 1
    jz   es_par
        
    or  [dato], 80h   
    jmp salir          

es_par:

    and [dato], 7Fh     
salir:
    mov ah,04Ch
    mov al, [codsal]
    int 21h
    end inicio