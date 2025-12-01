ideal
dosseg
model small

    codeseg
    public astrcat, astrcmp

    proc astrcat ;CONCATENA DE CADENA SI HACIA CADENA DI
    push ax
    push si
    push di

    xor al, al
    cld

@@whi:
    scasb
    jnz @@whi

    dec di

@@do:
    lodsb
    stosb
    cmp al, 0
    jne @@do

@@fin:
    pop di
    pop si
    pop ax
    ret
endp astrcat

proc astrcmp ;cOMPARA CADENAS SI - DI
    cld

@@whi:
    cmp [byte si], 0
    je @@fin
    cmpsb
    jne @@endwhi
    jmp @@whi

@@endwhi:
    dec si
    dec di

@@fin:
    mov al, [byte si]
    sub al, [byte di]
    cbw
    ret
endp astrcmp

    end