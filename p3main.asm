; IMPORTS MACROS
include p3mac.asm

; TIPO DE EJECUTABLE
.model small 
.stack 100h 
.data
; FIN TIPO DE EJECUTABLE

; SECCION DE DATOS 
header db 0ah,0dh,20h,20h, 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 0ah,0dh,20h,20h, 'FACULTAD DE INGENIERIA', 0ah,0dh,20h,20h, 'CIENCIAS Y SISTEMAS', 0ah,0dh,20h,20h, 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1', 0ah,0dh,20h,20h, 'NOMBRE: DIDIER ALFREDO DOMINGUEZ URIAS', 0ah,0dh,20h,20h, 'CARNET: 201801266', 0ah,0dh,20h,20h, 'SECCION: A', 0ah,0dh, '$'
options db 0ah,0dh,20h,20h, '1) Iniciar Juego', 0ah,0dh,20h,20h, '2) Cargar Juego', 0ah,0dh,20h,20h, '3) Salir', 0ah,0dh, '$'
getOPT db 0ah,0dh,20h,20h, '>>', 20h, '$'
ln db 0ah,0dh, '$'

f8 db 0ah,0dh,20h,20h, '8 |', '$'
f7 db 0ah,0dh,20h,20h, '7 |', '$'
f6 db 0ah,0dh,20h,20h, '6 |', '$'
f5 db 0ah,0dh,20h,20h, '5 |', '$'
f4 db 0ah,0dh,20h,20h, '4 |', '$'
f3 db 0ah,0dh,20h,20h, '3 |', '$'
f2 db 0ah,0dh,20h,20h, '2 |', '$'
f1 db 0ah,0dh,20h,20h, '1 |', '$'
em db 20h,20h, '|', '$'
sigln db 0ah,0dh,20h,20h,20h,20h, '-------------------------', '$'
ab db 0ah,0dh,20h,20h,20h,20h,20h, 'A  B  C  D  E  F  G  H', '$'
fb db 'FB|', '$'
fn db 'FN|', '$'
rb db 'RB|', '$'
rn db 'RN|', '$'

headerhtml db 0ah,0dh, '<!DOCTYPE html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">','$'
finheaderhtml db 0ah,0dh, '<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"><link rel="stylesheet" href="./assets/css/style.css"><title>201801266</title></head>','$'
bodyhtml db 0ah, 0dh, '<body class="container"><div class="h-100 align-items-center d-flex justify-content-center"><table><tr><th colspan="9">', '$'
titulotb db 0ah, 0dh, '<h3>TABLERO ', '$'
fintitulotb db 0ah, 0dh, '</h3></th></tr>', '$'
fintablehtml db 0ah, 0dh, '<tr><th>A</th><th>B</th><th>C</th><th>D</th><th>E</th><th>F</th><th>G</th><th>H</th></tr></table></div>', '$'
scriptshtml db 0ah, 0dh, '<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script><script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>', '$'
fnbodyhtml db 0ah, 0dh, '<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script></body></html>', '$'
sttr db 0ah, 0dh, '<tr>', '$'
fntr db 0ah, 0dh, '</tr>', '$'
pcbn db 0ah, 0dh, '<td class="no-pieceBn"></td>', '$'
pcbg db 0ah, 0dh, '<td class="no-pieceBg"></td>', '$'
pcfn db 0ah, 0dh, '<td class="black-piece"></td>', '$'
pcfb db 0ah, 0dh, '<td class="white-piece"></td>', '$'
pcrn db 0ah, 0dh, '<td class="black-queen"></td>', '$'
pcrb db 0ah, 0dh, '<td class="white-queen"></td>', '$'
th8 db 0ah, 0dh, '<th>8</th>', '$'
th7 db 0ah, 0dh, '<th>7</th>', '$'
th6 db 0ah, 0dh, '<th>6</th>', '$'
th5 db 0ah, 0dh, '<th>5</th>', '$'
th4 db 0ah, 0dh, '<th>4</th>', '$'
th3 db 0ah, 0dh, '<th>3</th>', '$'
th2 db 0ah, 0dh, '<th>2</th>', '$'
th1 db 0ah, 0dh, '<th>1</th>', '$'

arrf8 db 000b, 011b, 000b, 011b, 000b, 011b, 000b, 011b
arrf7 db 011b, 000b, 011b, 000b, 011b, 000b, 011b, 000b
arrf6 db 000b, 011b, 000b, 011b, 000b, 011b, 000b, 011b
arrf5 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
arrf4 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
arrf3 db 001b, 000b, 001b, 000b, 001b, 000b, 001b, 000b
arrf2 db 000b, 001b, 000b, 001b, 000b, 001b, 000b, 001b
arrf1 db 001b, 000b, 001b, 000b, 001b, 000b, 001b, 000b
; FIN SECCION DE DATOS 

.code ;segmento de código
; SECCION DE CODIGO
    main proc
        MOV dx, @data
        MOV ds, dx

        MENU:
            print header
            print options
            getChr

            cmp al, 49
			je INICIAR
			cmp al, 50
			je CARGAR
			cmp al, 51
			je SALIR

            jmp MENU

        INICIAR:
            jmp TABLERO
            jmp MENU

        CARGAR:
            jmp MENU

        SALIR: 
			MOV ah, 4ch
			int 21h

        TABLERO:
            printTB f8, arrf8
            printTB f7, arrf7
            printTB f6, arrf6
            printTB f5, arrf5
            printTB f4, arrf4
            printTB f3, arrf3
            printTB f2, arrf2
            printTB f1, arrf1

            print sigln
            print ab
            print ln

            getChr
            jmp MENU


    main endp
; FIN SECCION DE CODIGO
end