ideal
dosseg
model small
stack 256

dataseg
    ; Mensajes para la prueba
    msgPos  db '1. Prueba 32 bits (Esperado: 65536): ', 0
    msgNeg  db 13, 10, '2. Prueba Negativo (Esperado: -12345): ', 0
    msgCero db 13, 10, '3. Prueba Cero (Esperado: 0): ', 0
    
    ; Buffer donde ITOA escribir? el texto
    buffer  db 20 dup(?) 

codeseg
    ; Importamos tu funci?n ITOA y APUTS (de str_io)
    extrn itoa:proc
    extrn aputs:proc

inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax      ; ITOA usa STOSB, as? que ES debe apuntar a datos

    ; ==========================================
    ; CASO 1: N?mero Grande Positivo (32 bits)
    ; Valor: 65536 (10000h). 
    ; En registros: DX = 1, AX = 0
    ; ==========================================
    mov si, offset msgPos
    call aputs

    mov dx, 1           ; Parte Alta
    mov ax, 0           ; Parte Baja
    mov di, offset buffer
    call itoa           ; <--- LLAMADA A TU MODULO
    
    mov si, offset buffer
    call aputs          ; Mostrar resultado convertido

    ; ==========================================
    ; CASO 2: N?mero Negativo
    ; Valor: -12345
    ; Hex: FFFF CFC7
    ; ==========================================
    mov si, offset msgNeg
    call aputs

    mov dx, 0FFFFh      ; Parte Alta (Signo negativo extendido)
    mov ax, 0CFC7h      ; Parte Baja (-12345)
    mov di, offset buffer
    call itoa           
    
    mov si, offset buffer
    call aputs

    ; ==========================================
    ; CASO 3: El Cero
    ; ==========================================
    mov si, offset msgCero
    call aputs

    xor dx, dx
    xor ax, ax
    mov di, offset buffer
    call itoa
    
    mov si, offset buffer
    call aputs

    ; --- PAUSA PARA VER EL RESULTADO ---
    mov ah, 0Ch
    mov al, 08h
    int 21h

    ; Salir
    mov ax, 04C00h
    int 21h

end inicio