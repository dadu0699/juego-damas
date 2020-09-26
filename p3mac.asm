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
