; IMPORTS MACROS
include p3mac.asm

; TIPO DE EJECUTABLE
.model small 
.stack 100h 

.data ;SEGMENTO DE DATOS
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
em db 20h,20h, '|', '$' ; 000b || 111b
sigln db 0ah,0dh,20h,20h,20h,20h, '-------------------------', '$'
ab db 0ah,0dh,20h,20h,20h,20h,20h, 'A  B  C  D  E  F  G  H', '$'
fb db 'FB|', '$' ; 001b
fn db 'FN|', '$' ; 011b
rb db 'RB|', '$' ; 100b
rn db 'RN|', '$' ; 010b

headerhtml db '<!DOCTYPE html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">'
finheaderhtml db '<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"><link rel="stylesheet" href="./assets/css/style.css"><title>201801266</title></head>'
bodyhtml db '<body class="container"><div class="h-100 align-items-center d-flex justify-content-center"><table><tr><th colspan="9">'
titulotb db '<h3>TABLERO '
fintitulotb db '</h3></th></tr>'
fintablehtml db '<tr><th></th><th>A</th><th>B</th><th>C</th><th>D</th><th>E</th><th>F</th><th>G</th><th>H</th></tr></table></div>'
scriptshtml db '<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script><script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>'
fnbodyhtml db '<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script></body></html>'
sttr db '<tr>'
fntr db '</tr>'
pcbn db '<td class="no-pieceBn"></td>'
pcbg db '<td class="no-pieceBg"></td>'
pcfn db '<td class="black-piece"></td>'
pcfb db '<td class="white-piece"></td>'
pcrn db '<td class="black-queen"></td>'
pcrb db '<td class="white-queen"></td>'
th8 db '<th>8</th>'
th7 db '<th>7</th>'
th6 db '<th>6</th>'
th5 db '<th>5</th>'
th4 db '<th>4</th>'
th3 db '<th>3</th>'
th2 db '<th>2</th>'
th1 db '<th>1</th>'

arrf8 db 000b, 011b, 000b, 011b, 000b, 011b, 000b, 011b
arrf7 db 011b, 000b, 011b, 000b, 011b, 000b, 011b, 000b
arrf6 db 000b, 011b, 000b, 011b, 000b, 011b, 000b, 011b
arrf5 db 111b, 000b, 111b, 000b, 111b, 000b, 111b, 000b
arrf4 db 000b, 111b, 000b, 111b, 000b, 111b, 000b, 111b
arrf3 db 001b, 000b, 001b, 000b, 001b, 000b, 001b, 000b
arrf2 db 000b, 001b, 000b, 001b, 000b, 001b, 000b, 001b
arrf1 db 001b, 000b, 001b, 000b, 001b, 000b, 001b, 000b

comando db 5 dup('$')
comandoShow db 'SHOW', '$'
comandoExit db 'EXIT', '$'
comandoSave db 'SAVE', '$'
turno db 48; 000b Blancas | 111b Negras
turnofb db 0ah,0dh,20h,20h, 'TURNO BLANCAS: ', '$'
turnofn db 0ah,0dh,20h,20h, 'TURNO NEGRAS: ', '$'

msgOpeningError  db 0ah,0dh,20h,20h,  'ERROR: NO SE PUDO ABRIR EL ARCHIVO', '$'
msgCreationError db 0ah,0dh,20h,20h,  'ERROR: NO SE PUDO CREAR EL ARCHIVO', '$'
msgWritingError  db 0ah,0dh,20h,20h,  'ERROR: NO SE PUDO ESCRIBIR EN EL ARCHIVO', '$'

dia db ' '
mes db ' '
anio db ' '
hora db ' '
minuto db ' '
slash db '/'
space db ' '
twoP db ':'
fechaHora db 'dd/mm/2020 hh:mm'

pathFile db 'estadoTablero.html', 00h
handleFile dw ?
; FIN SECCION DE DATOS 

.code ;SEGMENTO DE CODIGO
; SECCION DE CODIGO
    main proc
        mov dx, @data
        mov ds, dx

        MENU:
            print header
            print options
    
            print getOPT
            getChr
            print ln

            cmp al, 49
			je INICIAR
			cmp al, 50
			je CARGAR
			cmp al, 51
			je SALIR

            jmp MENU

        INICIAR:
            printTablero

            .if turno == 48
                jmp AccionesBlanco
            .elseif turno == 49
                jmp AccionesNegro
            .endif

        CARGAR:
            jmp MENU

        SALIR: 
			mov ah, 4ch
			int 21h


        OpeningError: 
	    	print msgOpeningError
	    	getChr
	    	jmp INICIAR
        
        CreationError:
	    	print msgCreationError
	    	getChr
	    	jmp INICIAR
        
        WritingError:
	    	print msgWritingError
	    	getChr
	    	jmp INICIAR

        AccionesBlanco: 
            print turnofb
            getString comando
            equalsString comando, comandoShow, Reporte
            equalsString comando, comandoSave, SALIR
            equalsString comando, comandoExit, MENU

            mov [turno], 49
            jmp INICIAR

        AccionesNegro:
            print turnofn
            getString comando
            equalsString comando, comandoShow, Reporte
            equalsString comando, comandoSave, SALIR
            equalsString comando, comandoExit, MENU
            

            mov [turno], 48
            jmp INICIAR

        Reporte:
            generateReport
            jmp INICIAR

    main endp
; FIN SECCION DE CODIGO






    conv proc 
        AAM
        ADD ax, 3030h
        ret
    conv endp
end
