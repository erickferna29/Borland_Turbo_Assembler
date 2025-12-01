; TRIAN2.ASM
;
; Este programa determina s? tres l?neas de longitudes:
; lado1 <= lado2 <= lado3, forman un tri?ngulo y su tipo:
; equil?tero, is?sceles o escaleno. Los lados est?n en
; variables de tipo palabra no signadas. El programa guarda
; en la variable resul el car?cter:
;
; 'N' Si las l?neas no forman un tri?ngulo
; 'E' Si forman un tri?ngulo equil?tero
; 'I' Si forman un tri?ngulo is?sceles
; 'S' Si forman un tri?ngulo escaleno
ideal
dosseg
model small
stack 256
dataseg
codsal db 0
lado1 dw ?
lado2 dw ?
lado3 dw ?
tipo db ?
codeseg
inicio:
mov ax, @data ; Inicializa el
mov ds, ax ; segmento de datos
mov ax, [lado1]
mov bx, [lado2]
mov cx, [lado3]
call triang
mov [tipo], al ; tipo = AL
salir:
mov ah, 04Ch
mov al, [codsal]
int 21h
; PROCEDIMIENTO
; TRIANG
;
; Este procedimiento determina si tres l?neas forman un
; tri?ngulo y su tipo.
proc triang
push ax ; Guarda el valor de lado1
add ax, bx
cmp ax, cx ; if(lado1+lado2 > lado3)
ja @@equi ; goto equi
pop ax ; recupera lado1
mov al, 'N' ; return 'N'
ret
@@equi: pop ax ; recupera lado1
cmp ax, cx ; if(lado1 != lado3)
jne @@iso1 ; goto iso1
mov al, 'E' ; return 'E'
ret
@@iso1: cmp ax, bx ; if(lado1 != lado2)
jne @@iso2 ; goto iso2
mov al, 'I' ; return 'I'
ret
@@iso2: cmp bx, cx ; if(lado2 != lado3)
jne @@esca ; goto esca
mov al, 'I' ; return 'I'
ret
@@esca: mov al, 'S' ; return 'S'
ret
endp triang
end inicio