print macro str
	MOV ah,09h 
	MOV dx, offset str 
	int 21h
endm

getChr macro
    print getOPT
    MOV ah,01h
    int 21h
    print ln
endm

printTB macro pos, arrg
    LOCAL RecorrerArreglo

    print sigln
    print pos
    MOV cx, 8
    XOR bx, bx

    RecorrerArreglo: 
		MOV dh, arrg[bx]
        .if dh == 000b
            print em
        .elseif dh == 011b
            print fn
        .elseif dh == 001b
            print fb
        .endif
        add bx, 1
		LOOP RecorrerArreglo
endm