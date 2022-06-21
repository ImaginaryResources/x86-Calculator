;Calculator Program
;Date 6-12-22

INCLUDE Irvine32.inc

;TODO: Turn labels into functions. Ex: turn addition and multipilcation into a function
;         Saving and Restoring Registers before procedures (EBP) and local variables

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

sum dword ?

.code
main proc

     start:
          call printMenu                ;Print Menu to Console

     selection:
          call readInt                  ;Get users selection
          mov select, eax               ;Move user input into select variable
     
          cmp select, 1                 ;If selection = 1, jump to addition
          je addition

          cmp select, 2                 ;If selection = 2, jump to subtraction
          je subtraction

          cmp select, 3                 ;If selection = 3, jump to multipilcation
          je multiplication

          cmp select, 4                 ;If selection = 4, jump to division
          je division

          cmp select, 5                 ;If selection = 5, show history
          je history

          cmp select, 6                 ;If selection = 6, exit program
          je theExit

          mov ecx, offset prompt9
          mov esi, lengthof prompt9
          call printStr
          jmp selection

     addition:
          call getUserInput             ;Get user input

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
     

          mov ecx, offset prompt8       ;Result Text
          mov esi, lengthof prompt8
          call printStr

          mov eax, input1               ;Store result in eax
          call writeInt                 ;Print result
          call Crlf                     ;New line

          jmp start

     subtraction:
          ;TODO
          jmp start

     multiplication:
          call getUserInput             ;Get user input

          mov eax, input1               ;Move input1 into eax
          mov ecx, 32
          mov ebx, 0

          next:
               rcr eax, 1
               jnc L1
               pushad
               mov ecx, ebx
               mov eax, input2        
               shl eax, cl
               add sum, eax             ;Use add procedure
               popad

          L1:
               inc ebx
               loop next

          mov ecx, offset prompt8       ;Result Text
          mov esi, lengthof prompt8
          call printStr

          mov eax, sum
          call writeInt
          call Crlf                     ;New line

          mov sum, 0                    ;Clear sum

          jmp start

     division:
          ;TODO
          jmp start

     history:
          jmp start

getUserInput proc

          mov ecx, offset prompt10        ;Ask user for first number
          mov esi, lengthof prompt10
          call printStr
          call readInt                   ;Get users input and move into input variable
          mov input1, eax

          
          mov ecx, offset prompt11      ;Ask user for second number
          mov esi, lengthof prompt11
          call printStr
          call readInt                   ;Get users input and move into input variable
          mov input2, eax

          ret
getUserInput endp

printMenu proc
     push esi
     push ecx
     mov esi, ptrT                      ;Pointer to arrayTexts
     mov ecx, [esi]                     ;[esi] is first item in arrayTexts
     
     ;Because arrayText is an array of pointers to bytes of Text
     ;we need to increment to each character until the NULL terminator
     ;then move the esi pointer to the next element in arrayTexts

     P1:
          call printStr                 ;Print string pointer is currently at

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
          print:
               mov al, byte ptr[ecx]    ;Move Char at ecx address into al
               inc ecx                  ;Move to next char
               call writeChar           ;Print char to console
          
               cmp al, NULL             ;If null terminated end loop, if not continue
               jnz print

          ret

printStr endp

     theExit:
          main endp

end main
