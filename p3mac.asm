print macro str
	MOV ah,09h 
	MOV dx, offset str 
	int 21h
endm

getChr macro
    print getOPT
    mov ah,01h
    int 21h
    print ln
endm