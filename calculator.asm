;Calculator Program
;Date 6-12-22

INCLUDE Irvine32.inc

;TODO: Turn labels into functions. Ex: turn addition and getUserInput into a function

.data
;User input variables
select dword ?
input1 dword ?
input2 dword ?

;0dh,0ah New line
;0 End of line

;Menu variables
prompt0 byte "Select an Operation to preform:",0dh,0ah,0
prompt1 byte "1) Addition",0dh,0ah,0
prompt2 byte "2) Subtraction",0dh,0ah,0
prompt3 byte "3) Multiplication",0dh,0ah,0
prompt4 byte "4) Division",0dh,0ah,0
prompt5 byte "5) History",0dh,0ah,0
prompt6 byte "6) Exit",0dh,0ah,0
prompt7 byte "Enter selection: ",0

prompt8 byte "Result: ",0
prompt9 byte "Enter a valid selection: ",0

prompt10 byte "Enter first number: ",0
prompt11 byte "Enter second number: ",0

;Array of menu prompts
arrayTexts dword prompt0, prompt1, prompt2, prompt3, prompt4, prompt5, prompt6, prompt7, 0

;Pointer to arrayTexts
ptrT dword offset arrayTexts

counter dword 1 ;How to get rid of counter?

.code
main proc

     start:
          call printMenu                ;Print Menu to Console

     selection:
          call readInt                  ;Get users selection
          mov select, eax               ;Move user input into select variable
     
          cmp select, 1                 ;If selection = 1, jump to addition
          je userInput                  ;Get user input
          S1:
               jmp addition

          cmp select, 2                 ;If selection = 1, jump to subtraction
          je subtraction
          cmp select, 3                 ;If selection = 1, jump to multipilcation
          je multiplication
          cmp select, 4                 ;If selection = 1, jump to division
          je division
          cmp select, 5                 ;If selection = 1, show history
          je history
          cmp select, 6                 ;If selection = 1, exit program
          je theExit

          mov edx, offset prompt9       ;If invalid selection
          call writeString              ;Ask user to select again
          jmp selection
     

     userInput:
         mov edx, offset prompt10       ;Ask user for first number
         call writeString
         call readInt                   ;Get users input and move into input variable
         mov input1, eax

         mov edx, offset prompt11       ;Ask user for second number
         call writeString
         call readInt                   ;Get users input and move into input variable
         mov input2, eax
         jmp S1

     addition:
          ;EBX = Sum (input1)
          ;EAX = Carry (input2)
          L2:
               mov eax, input1          ;Store input1 to perform XOR
               xor eax, input2          ;Bitwise operation XOR performs 'add' 
               mov ebx, eax             ;'Add' xor to Sum

               mov eax, input1          ;Store input1 to preform AND
               and eax, input2          ;Bitwise operation AND shows which positions need a carry
     
               shl eax, 1               ;Shift left to check for carries
               mov input1, ebx          ;Store sum into input1
               mov input2, eax          ;Store shifted carry into input2
               jnz L2                   ;If a carry still exist loop again
     
          mov edx, offset prompt8       ;Result text
          call writeString

          mov eax, input1               ;Store result in eax
          call writeInt                 ;Print result
          call Crlf                     ;New line

          jmp start

     subtraction:
          ;TODO
          jmp start

     multiplication:
          ;TODO
          jmp start

     division:
          ;TODO
          jmp start

     history:
          jmp start

printMenu proc
     push esi
     push ecx
     mov esi, ptrT                      ;Pointer to arrayTexts
     mov ecx, [esi]                     ;[esi] is first item in arrayTexts
     
     ;Because arrayText is an array of pointers to bytes of Text
     ;we need to increment to each character until the NULL terminator
     ;then move the esi pointer to the next element in arrayTexts

     P1:
          ;TODO can probably call printStr here
          P2:
               mov al, byte ptr[ecx]    ;Move char at from element of ArrayTexts into al
               inc ecx                  ;Move to next char when called again
               call writeChar           ;Print char to console
          
               cmp al, NULL             ;If null terminated end loop, if not continue
               jnz P2

          mov ebx, counter              ;Move current counter into ebx register
          inc counter                   ;Increase the counter for next run

          mov ecx, [esi+4*ebx]          ;Dword is 4 bytes long, each 4 bytes is an element of arrayTexts
          cmp ecx, NULL                 ;4*counter gives the position of current element to print
          jnz P1                        ;If array is null terminated, end of printing menu

     mov counter, 1
     pop ecx
     pop esi
     ret

printMenu endp

printStr proc
     push esi
     push ecx

     print:
	     mov al, byte ptr[esi]         ;Move Char at esi address into al
	     inc esi                       ;Move to next char
	     call WriteChar                ;Write char
	     loop print                    ;Loop until all chars are printed

     pop ecx
     pop esi
     ret

printStr endp

     theExit:
          main endp

end main
