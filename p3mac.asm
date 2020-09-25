print macro str
	MOV ah,09h 
	MOV dx, offset str 
	int 21h
endm

getChr macro
    MOV ah,01h
    int 21h
endm

getCadena macro buffer
    LOCAL COCAT, TERM
    PUSH SI
    PUSH AX

    xor si,si
    COCAT:
        getChr
        cmp al, 0dh
        je TERM
        MOV buffer[si], al
        inc si
        jmp COCAT

    TERM:
        MOV al, '$'
        MOV buffer[si], al

    POP AX
    POP SI
endm

printFila macro pos, arrg
    LOCAL RecorrerArreglo

    print sigln
    print pos
    
    MOV cx, 8
    XOR bx, bx
    RecorrerArreglo: 
		MOV dh, arrg[bx]
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

generateReport macro 
    ; getPathFile pathFile
    createFile pathFile, handleFile
    
    openFile pathFile, handleFile
    writingFile SIZEOF headerhtml, headerhtml, handleFile

    closeFile handleFile
    ; jmp INICIAR
endm

getPathFile macro buffer
    LOCAL CONCATENAR, TERMINAR
    
    xor si, si
    CONCATENAR:
        getChr
        cmp al, 0dh
        je TERMINAR
        MOV buffer[si], al
        inc si
        jmp CONCATENAR
    TERMINAR:
        MOV buffer[si], 00h
endm

createFile macro buffer, handle
    MOV ah, 3ch
    MOV cx, 00h

    lea dx, buffer

    int 21h
    MOV handle, ax
    jc CreationError
endm

openFile macro path, handle
    MOV ah, 3dh
    MOV al, 10b

    lea dx, path
    
    int 21h
    MOV handle, ax
    jc OpeningError
endm

writingFile macro numbytes, buffer, handle
	MOV ah, 40h
	MOV bx, handle
	MOV cx, numbytes
	lea dx, buffer
	int 21h
	jc WritingError
endm

closeFile macro handle
    MOV ah, 3eh
    MOV handle, bx
    int 21h
endm