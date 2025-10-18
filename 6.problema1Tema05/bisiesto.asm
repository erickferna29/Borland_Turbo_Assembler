    ideal
    dosseg
    model small
    stack 256
    
    dataseg
    codsal db 0
    anho dw ?
    resul db ?
    
    codeseg
inicio: 
    mov ax,@data
    mov ds,ax
    
    mov ax,[anho]
    cwd
    mov bx,4d
    
    div bx
    cmp dx,0h
    jne no_esBi
si_div4:
    mov ax,[anho]
    cwd
    mov bx,100d
    div bx
    cmp dx,0h
    jne si_esBi
si_div100:
    mov ax,[anho]
    cwd
    mov bx,400d
    div bx
    cmp dx,0h
    
    jne no_esBi
si_esBi:
    mov [resul],'S'
    jmp salir
no_esBi:
    mov [resul],'N'
salir:
    mov ah,04Ch
    mov al,[codsal]
    int 21h
    end inicio