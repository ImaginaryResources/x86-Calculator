;Calculator Program
;Date 6-30-22

;TODO: create printStr proc, 

.model tiny
.stack 100h

.data
;User inputs
select db ?
input1 db ?
input2 db ?

;0dh,0ah New line
;$ End of line in COM programs

;Menu prompts
prompt0 db "Select an Operation to preform:",0dh,0ah,"$"
prompt1 db "1) Addition",0dh,0ah,"$"
prompt2 db "2) Subtraction",0dh,0ah,"$"
prompt3 db "3) Multiplication",0dh,0ah,"$"
prompt4 db "4) Division",0dh,0ah,"$"
prompt5 db "5) Exit",0dh,0ah,"$"
prompt6 db "Enter selection: ","$"

;Additional console prompts
prompt7 db "Result: ",0
prompt8 db "Enter a valid selection: ","$"
prompt9 db "Enter first number: ","$"
prompt10 db "Enter second number: ","$"

.code
org 100h
main proc
	
	mov ax, @data				;Load address of data segment 
	mov ds, ax 					;Address to segment register
	
start:
	call printMenu
	
selection:	
	mov ah, 01h					;Read user input (charater)
	int 21h
	
	sub al, 48					;Changes ASCII selection into INT
	mov select, al				;Store user input
	
	call crlf
	
	;All input is read as an ASCII value
	S1:							;Selection needs to be a character
		cmp select, 1			;If selection = 1, jump to S2
		jne S5
		call getUserInput
		jmp start
	S5:
		cmp select, 5
		je theExit
		
	mov dx, offset prompt8
	;lea dx, prompt8
	mov ah, 9h
	int 21h
	
	jmp selection

theExit:
	mov ax, 4c00h
	int 21h

	;ret
main endp

crlf proc
    push bp                     ;Save Registers
    mov bp,sp
	
	mov dx, 0Dh					;Carriage return
	mov ah, 02h					;Write Char to STDOUT
	int 21h						;MS-DOS Function Call
	
	mov dx, 0Ah					;Line feed
	mov ah, 02h					;Write Char to STDOUT
	int 21h						;MS-DOS Function Call
	
    mov sp, bp
    pop bp                      ;Restore Registers
	
	ret
crlf endp

getUserInput proc
    push bp                  	;Save Registers
    mov bp,sp
	
	mov dx, offset prompt9
	;lea dx, prompt9
	mov ah, 9h
	int 21h

	mov ah, 01h					;Read user input (charater)
	int 21h
	
	sub al, 48					;Changes ASCII selection into INT
	mov input1, al				;Store user input
	
	call crlf
	
	mov dx, offset prompt10
	;lea dx, prompt10
	mov ah, 9h
	int 21h
	
	mov ah, 01h					;Read user input (charater)
	int 21h
	
	sub al, 48					;Changes ASCII selection into INT
	mov input2, al				;Store user input
	
	call crlf

    mov sp, bp
    pop bp                       ;Restore Registers
	
	ret
getUserInput endp

printMenu proc
    push bp                     ;Save Registers
    mov bp,sp

	mov dx, offset prompt0
	;lea dx, prompt0			;same as mov dx, offset prompt0
	mov ah, 9h
	int 21h
	
	mov dx, offset prompt1
	;lea dx, prompt1
	mov ah, 9h
	int 21h
	
	mov dx, offset prompt2
	;lea dx, prompt2
	mov ah, 9h
	int 21h
	
	mov dx, offset prompt3
	;lea dx, prompt3
	mov ah, 9h
	int 21h
	
	mov dx, offset prompt4
	;lea dx, prompt4
	mov ah, 9h
	int 21h
	
	mov dx, offset prompt5
	;lea dx, prompt5
	mov ah, 9h
	int 21h
	
	mov dx, offset prompt6
	;lea dx, prompt6
	mov ah, 9h
	int 21h
     
    mov sp, bp
    pop bp                       ;Restore Registers

    ret
printMenu endp

end main