; IMPORTS MACROS
include p3mac.asm

; TIPO DE EJECUTABLE
.model small 
.stack 100h 
.data

; SECCION DE DATOS 
header db 0ah,0dh, '  UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 0ah,0dh, '  FACULTAD DE INGENIERIA', 0ah,0dh, '  CIENCIAS Y SISTEMAS', 0ah,0dh, '  ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1', 0ah,0dh, '  NOMBRE: DIDIER ALFREDO DOMINGUEZ URIAS', 0ah,0dh, '  CARNET: 201801266', 0ah,0dh, '  SECCION: A', 0ah,0dh, 0ah,0dh, '  1) Iniciar Juego', 0ah,0dh, '  2) Cargar Juego', 0ah,0dh, '  3) Salir', 0ah,0dh, '$'
init db 0ah,0dh, '  >><<', '$'
getOPT db 0ah,0dh, '  >> ', '$'
ln db 0ah,0dh, '$'

.code
; SECCION DE CODIGO
    main proc
        MOV dx,@data
        MOV ds,dx

        MENU:
            print header
            getChr

            cmp al,49
			je INICIAR
			cmp al,50
			je CARGAR
			cmp al,51
			je SALIR

            jmp MENU

        INICIAR:
            jmp MENU

        CARGAR:
            jmp MENU

        SALIR: 
			MOV ah,4ch
			int 21h
    main endp
; FIN SECCION DE CODIGO
end