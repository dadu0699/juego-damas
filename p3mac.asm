print macro str
    LOCAL ETIQUETAPRINT
    ETIQUETAPRINT:
        mov ah,09h
        mov dx, offset str
        int 21h
endm

getChr macro
    mov ah,01h
    int 21h
endm

getString macro buffer
    LOCAL COCAT, TERM

    xor si,si
    COCAT:
        getChr
        cmp al, 0dh
        je TERM
        mov buffer[si], al
        inc si
        jmp COCAT

    TERM:
        mov al, '$'
        mov buffer[si], al

endm

parseString macro ref, buffer
    LOCAL RestartSplit, Split, ConcatParse, FinParse
    PUSH si
    PUSH cx
    PUSH ax

	xor si, si
	xor cx, cx
	xor ax, ax
	mov ax, ref
	mov dl, 0ah
	jmp Split

	RestartSplit:
		xor ah,ah

	Split:
		div dl
		inc cx
		push ax
		cmp al, 00h
		je ConcatParse
		jmp RestartSplit

	ConcatParse:
		pop ax
		add ah, 30h
		mov buffer[si], ah
		inc si
		loop ConcatParse
		mov ah,24h
		mov buffer[si], ah
		inc si

	FinParse:
    
    POP ax
    POP cx
    POP si
endm

equalsString macro buffer, command, etq
    mov ax, ds
    mov es, ax
    mov cx, 5
    
    lea si, buffer
    lea di, command
    repe cmpsb
    je etq
endm

convertAscii macro numero
	LOCAL convI, finA
	xor ax, ax
	xor bx, bx
	xor cx, cx
	mov bx, 10
	xor si, si

	convI:
		mov cl, numero[si] 
		cmp cl, 48
		jl finA
		cmp cl, 57
		jg finA
		inc si
		sub cl, 48
		mul bx
		add ax, cx
		jmp convI
	finA:
endm



printFila macro pos, arrg
    LOCAL RecorrerArreglo

    print sigln
    print pos
    
    mov cx, 8
    XOR bx, bx
    RecorrerArreglo: 
	    mov dh, arrg[bx]
        .if (dh == 000b || dh == 111b)
            print em
        .elseif dh == 011b
            print fn
        .elseif dh == 010b
            print rn
        .elseif dh == 001b
            print fb
        .elseif dh == 100b
            print rb
        .endif
        inc bx ; add bx, 1
		LOOP RecorrerArreglo
endm

printTablero macro 
    printFila f8, arrf8
    printFila f7, arrf7
    printFila f6, arrf6
    printFila f5, arrf5
    printFila f4, arrf4
    printFila f3, arrf3
    printFila f2, arrf2
    printFila f1, arrf1

    print sigln
    print ab
    print ln
endm

printFR macro arrg
    LOCAL CICLO, CONTINUARC, FINC, EBG, EBN, EFN, EFB, ERN, ERB 
    
    xor si, si
    CICLO:
        mov dh, arrg[si]

        cmp dh, 000b
        je EBN
        cmp dh, 111b
        je EBG
        cmp dh, 001b
        je EFB
        cmp dh, 011b
        je EFN
        cmp dh, 100b
        je ERB
        cmp dh, 010b
        je ERN

        EBG:
            writingFile SIZEOF pcbg, pcbg, handleFile
            jmp CONTINUARC
        EBN:
            writingFile SIZEOF pcbn, pcbn, handleFile
            jmp CONTINUARC
        EFB:
            writingFile SIZEOF pcfb, pcfb, handleFile
            jmp CONTINUARC
        EFN:
            writingFile SIZEOF pcfn, pcfn, handleFile
            jmp CONTINUARC
        ERB:
            writingFile SIZEOF pcrb, pcrb, handleFile
            jmp CONTINUARC
        ERN:
            writingFile SIZEOF pcrn, pcrn, handleFile
            jmp CONTINUARC

        CONTINUARC: 
            inc si
            cmp si, 8
            je FINC
            jmp CICLO
    FINC:
endm

printTBR macro
    writingFile SIZEOF sttr, sttr, handleFile
    writingFile SIZEOF th8, th8, handleFile
    printFR arrf8
    writingFile SIZEOF fntr, fntr, handleFile

    writingFile SIZEOF sttr, sttr, handleFile
    writingFile SIZEOF th7, th7, handleFile
    printFR arrf7
    writingFile SIZEOF fntr, fntr, handleFile

    writingFile SIZEOF sttr, sttr, handleFile
    writingFile SIZEOF th6, th6, handleFile
    printFR arrf6
    writingFile SIZEOF fntr, fntr, handleFile
    
    writingFile SIZEOF sttr, sttr, handleFile
    writingFile SIZEOF th5, th5, handleFile
    printFR arrf5
    writingFile SIZEOF fntr, fntr, handleFile

    writingFile SIZEOF sttr, sttr, handleFile
    writingFile SIZEOF th4, th4, handleFile
    printFR arrf4
    writingFile SIZEOF fntr, fntr, handleFile

    writingFile SIZEOF sttr, sttr, handleFile
    writingFile SIZEOF th3, th3, handleFile
    printFR arrf3
    writingFile SIZEOF fntr, fntr, handleFile
    
    writingFile SIZEOF sttr, sttr, handleFile
    writingFile SIZEOF th2, th2, handleFile
    printFR arrf2
    writingFile SIZEOF fntr, fntr, handleFile
    
    writingFile SIZEOF sttr, sttr, handleFile
    writingFile SIZEOF th1, th1, handleFile
    printFR arrf1
    writingFile SIZEOF fntr, fntr, handleFile
endm

generateReport macro 
    getDate
    getTime
    ; currentTimestamp

    deleteFile pathFile
    createFile pathFile, handleFile
    openFile pathFile, handleFile

    writingFile SIZEOF headerhtml, headerhtml, handleFile
    writingFile SIZEOF finheaderhtml, finheaderhtml, handleFile
    writingFile SIZEOF bodyhtml, bodyhtml, handleFile
    writingFile SIZEOF titulotb, titulotb, handleFile
    
    writingFile SIZEOF fechaHora, fechaHora, handleFile

    writingFile SIZEOF fintitulotb, fintitulotb, handleFile
    printTBR
    writingFile SIZEOF fintablehtml, fintablehtml, handleFile
    writingFile SIZEOF scriptshtml, scriptshtml, handleFile
    writingFile SIZEOF fnbodyhtml, fnbodyhtml, handleFile

    closeFile handleFile
endm



getPathFile macro buffer
    LOCAL CONCATENAR, TERMINAR
    
    xor si, si
    CONCATENAR:
        getChr
        cmp al, 0dh
        je TERMINAR
        mov buffer[si], al
        inc si
        jmp CONCATENAR
    TERMINAR:
        mov buffer[si], 00h
endm

createFile macro buffer, handle
    mov ah, 3ch
    mov cx, 00h
    lea dx, buffer
    int 21h
    mov handle, ax
    jc CreationError
endm

openFile macro path, handle
    mov ah, 3dh
    mov al, 10b
    lea dx, path
    int 21h
    mov handle, ax
    jc OpeningError
endm

writingFile macro numbytes, buffer, handle
	PUSH cx
	PUSH dx

	mov ah, 40h
	mov bx, handle
	mov cx, numbytes
	lea dx, buffer
	int 21h
	jc WritingError

	POP dx
	POP cx
endm

closeFile macro handle
    mov ah, 3eh
    mov handle, bx
    int 21h
endm

deleteFile macro buffer
    mov ah, 41h
    lea dx, buffer
    jc DeleteError
endm


getDate macro
    mov ah,2ah
    int 21h
    
    mov al, dl
    call conv
    mov fechaHora[0], ah
    mov fechaHora[1], al

    mov al, dh
    call conv
    mov fechaHora[3], ah
    mov fechaHora[4], al

endm

getTime macro
    mov ah,2ch
    int 21h

    mov al, ch
    call conv
    mov fechaHora[11], ah
    mov fechaHora[12], al

    mov al, cl
    call conv
    mov fechaHora[14], ah
    mov fechaHora[15], al
endm

currentTimestamp macro
    xor ax, ax
    xor bx, bx
    getDate
    mov bx, cx
    parseString bx, anio
    
    xor bx, bx
    getDate
    mov bl, dh
    parseString bx, mes
    
    getDate
    mov bl, dl
    parseString bx, dia
    
    xor bx, bx
    getTime
    mov bl, ch
    parseString bx, hora
    
    getTime
    mov bl, cl
    parseString bx, minuto
endm



movimientos macro
    LOCAL pA,pB,pC,pD,pE,pF,pG,pH, fy,p1,p2,p3,p4,p5,p6,p7,p8, salidaP, tbl, tne
    LOCAL inicioF2, pA2,pB2,pC2,pD2,pE2,pF2,pG2,pH2, fy2,p12,p22,p32,p42,p52,p62,p72,p82, salidaP2, tbl2, tne2
    LOCAL ffin
    
    cmp comando[0], 'A'
    je pA
    cmp comando[0], 'B'
    je pB
    cmp comando[0], 'C'
    je pC
    cmp comando[0], 'D'
    je pD
    cmp comando[0], 'E'
    je pE
    cmp comando[0], 'F'
    je pF
    cmp comando[0], 'G'
    je pG
    cmp comando[0], 'H'
    je pH
    jmp CommandError
    pA:
        mov xInicial, 0
        jmp fy
    pB:
        mov xInicial, 1
        jmp fy
    pC:
        mov xInicial, 2
        jmp fy
    pD:
        mov xInicial, 3
        jmp fy
    pE:
        mov xInicial, 4
        jmp fy
    pF:
        mov xInicial, 5
        jmp fy
    pG:
        mov xInicial, 6
        jmp fy
    pH:
        mov xInicial, 7
        jmp fy


    fy:
    xor bx, bx
    mov bl, xInicial

    cmp comando[1], '1'
    je p1
    cmp comando[1], '2'
    je p2
    cmp comando[1], '3'
    je p3
    cmp comando[1], '4'
    je p4
    cmp comando[1], '5'
    je p5
    cmp comando[1], '6'
    je p6
    cmp comando[1], '7'
    je p7
    cmp comando[1], '8'
    je p8
    jmp CommandError
    p1:
        mov yInicial, 0
    	mov dh, arrf1[bx]
        jmp salidaP
    p2:
        mov yInicial, 1
    	mov dh, arrf2[bx]
        jmp salidaP
    p3:
        mov yInicial, 2
    	mov dh, arrf3[bx]
        jmp salidaP
    p4:
        mov yInicial, 3
    	mov dh, arrf4[bx]
        jmp salidaP
    p5:
        mov yInicial, 4
    	mov dh, arrf5[bx]
        jmp salidaP
    p6:
        mov yInicial, 5
    	mov dh, arrf6[bx]
        jmp salidaP
    p7:
        mov yInicial, 6
    	mov dh, arrf7[bx]
        jmp salidaP
    p8:
        mov yInicial, 7
    	mov dh, arrf8[bx]
        jmp salidaP

    salidaP: 
        xor ax, ax
        mov ah, dh
        .if turno == 48
            jmp tbl
        .elseif turno == 49
            jmp tne
        .endif

    tbl:
        .if (dh == 000b || dh == 111b)
            print msgcasillaError
            jmp INICIAR
        .elseif dh == 011b
            print msgcasillaError2
            jmp INICIAR
        .elseif dh == 010b
            print msgcasillaError2
            jmp INICIAR
        .endif
        jmp inicioF2
    tne:
        .if (dh == 000b || dh == 111b)
            print msgcasillaError
            jmp INICIAR
        .elseif dh == 001b
            print msgcasillaError2
            jmp INICIAR
        .elseif dh == 100b
            print msgcasillaError2
            jmp INICIAR
        .endif
        jmp inicioF2

    inicioF2:
    cmp comando[3], 'A'
    je pA2
    cmp comando[3], 'B'
    je pB2
    cmp comando[3], 'C'
    je pC2
    cmp comando[3], 'D'
    je pD2
    cmp comando[3], 'E'
    je pE2
    cmp comando[3], 'F'
    je pF2
    cmp comando[3], 'G'
    je pG2
    cmp comando[3], 'H'
    je pH2
    jmp CommandError
    pA2:
        mov xFinal, 0
        jmp fy2
    pB2:
        mov xFinal, 1
        jmp fy2
    pC2:
        mov xFinal, 2
        jmp fy2
    pD2:
        mov xFinal, 3
        jmp fy2
    pE2:
        mov xFinal, 4
        jmp fy2
    pF2:
        mov xFinal, 5
        jmp fy2
    pG2:
        mov xFinal, 6
        jmp fy2
    pH2:
        mov xFinal, 7
        jmp fy2


    fy2:
    xor bx, bx
    mov bl, xFinal

    cmp comando[4], '1'
    je p12
    cmp comando[4], '2'
    je p22
    cmp comando[4], '3'
    je p32
    cmp comando[4], '4'
    je p42
    cmp comando[4], '5'
    je p52
    cmp comando[4], '6'
    je p62
    cmp comando[4], '7'
    je p72
    cmp comando[4], '8'
    je p82
    jmp CommandError
    p12:
        mov yFinal, 0
    	mov dh, arrf1[bx]
        jmp salidaP2
    p22:
        mov yFinal, 1
    	mov dh, arrf2[bx]
        jmp salidaP2
    p32:
        mov yFinal, 2
    	mov dh, arrf3[bx]
        jmp salidaP2
    p42:
        mov yFinal, 3
    	mov dh, arrf4[bx]
        jmp salidaP2
    p52:
        mov yFinal, 4
    	mov dh, arrf5[bx]
        jmp salidaP2
    p62:
        mov yFinal, 5
    	mov dh, arrf6[bx]
        jmp salidaP2
    p72:
        mov yFinal, 6
    	mov dh, arrf7[bx]
        jmp salidaP2
    p82:
        mov yFinal, 7
    	mov dh, arrf8[bx]
        jmp salidaP2

    salidaP2: 
        xor ax, ax
        mov ah, dh
        .if turno == 48
            jmp tbl2
        .elseif turno == 49
            jmp tne2
        .endif


    tbl2:
        .if (dh == 000b || dh == 111b)
            hacerCero comando[0], comando[1], 111b 
            hacerCero comando[3], comando[4], 001b 
        .elseif dh == 011b
            print msgcasillaError2
            jmp INICIAR
        .elseif dh == 010b
            print msgcasillaError2
            jmp INICIAR
        .endif
        jmp ffin
    tne2:
        .if (dh == 000b || dh == 111b)
            hacerCero comando[0], comando[1], 111b 
            hacerCero comando[3], comando[4], 011b
        .elseif dh == 001b
            print msgcasillaError2
            jmp INICIAR
        .elseif dh == 100b
            print msgcasillaError2
            jmp INICIAR
        .endif
        jmp ffin
    ffin:
        generateReport
endm

hacerCero macro letraC, numeroC, valorC
    LOCAL pA0,pB0,pC0,pD0,pE0,pF0,pG0,pH0, fy0,p10,p20,p30,p40,p50,p60,p70,p80, salidaP0, tbl0, tne0

    cmp letraC, 'A'
    je pA0
    cmp letraC, 'B'
    je pB0
    cmp letraC, 'C'
    je pC0
    cmp letraC, 'D'
    je pD0
    cmp letraC, 'E'
    je pE0
    cmp letraC, 'F'
    je pF0
    cmp letraC, 'G'
    je pG0
    cmp letraC, 'H'
    je pH0
    jmp CommandError
    pA0:
        mov xInicial, 0
        jmp fy0
    pB0:
        mov xInicial, 1
        jmp fy0
    pC0:
        mov xInicial, 2
        jmp fy0
    pD0:
        mov xInicial, 3
        jmp fy0
    pE0:
        mov xInicial, 4
        jmp fy0
    pF0:
        mov xInicial, 5
        jmp fy0
    pG0:
        mov xInicial, 6
        jmp fy0
    pH0:
        mov xInicial, 7
        jmp fy0


    fy0:
    xor bx, bx
    mov bl, xInicial

    cmp numeroC, '1'
    je p10
    cmp numeroC, '2'
    je p20
    cmp numeroC, '3'
    je p30
    cmp numeroC, '4'
    je p40
    cmp numeroC, '5'
    je p50
    cmp numeroC, '6'
    je p60
    cmp numeroC, '7'
    je p70
    cmp numeroC, '8'
    je p80
    jmp CommandError
    p10:
    	mov arrf1[bx], valorC
        jmp salidaP0
    p20:
    	mov arrf2[bx], valorC
        jmp salidaP0
    p30:
    	mov arrf3[bx], valorC
        jmp salidaP0
    p40:
    	mov arrf4[bx], valorC
        jmp salidaP0
    p50:
    	mov arrf5[bx], valorC
        jmp salidaP0
    p60:
    	mov arrf6[bx], valorC
        jmp salidaP0
    p70:
    	mov arrf7[bx], valorC
        jmp salidaP0
    p80:
    	mov arrf8[bx], valorC
        jmp salidaP0

    salidaP0: 
endm