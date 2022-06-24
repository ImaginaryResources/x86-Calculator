;Calculator Program
;Date 6-12-22

INCLUDE Irvine32.inc

;TODO: Make local variable for sum and counter, add more comments, div procedure

.data
;User input variables
select dword ?
input1 dword ?
input2 dword ?

;0dh,0ah New line
;0 End of line

;Menu prompts
prompt0 byte "Select an Operation to preform:",0dh,0ah,0
prompt1 byte "1) Addition",0dh,0ah,0
prompt2 byte "2) Subtraction",0dh,0ah,0
prompt3 byte "3) Multiplication",0dh,0ah,0
prompt4 byte "4) Division",0dh,0ah,0
prompt5 byte "5) Exit",0dh,0ah,0
prompt6 byte "Enter selection: ",0

;Additional console prompts
prompt7 byte "Result: ",0
prompt8 byte "Enter a valid selection: ",0
prompt9 byte "Enter first number: ",0
prompt10 byte "Enter second number: ",0

;Array of menu prompts
arrayTexts dword prompt0, prompt1, prompt2, prompt3, prompt4, prompt5, prompt6, 0

;Pointer to arrayTexts
ptrT dword offset arrayTexts

;Make these local variables
counter dword 1 ;How to get rid of counter?
sum dword ?

.code
main proc
     start:
          call printMenu                ;Print Menu to Console

     selection:
          call readInt                  ;Get users selection
          mov select, eax               ;Move user input into select variable
     
          S1:
               cmp select, 1                 ;If selection != 1, jump to S2
               jne S2
               call getUserInput             ;Get user input
               call addition                 ;Complete Addition
               jmp start                     ;Go back to menu
          
          S2:
               cmp select, 2                 ;If selection != 2, jump to S3
               jne S3
               call getUserInput             ;Get user input
               call subtraction              ;Complete Subtraction
               jmp start                     ;Go back to menu
          S3:
               cmp select, 3                 ;If selection != 3, jump to S4
               jne S4
               call getUserInput             ;Get user input
               call multiplication           ;Complete Multiplication
               jmp start                     ;Go back to menu
          S4:
               cmp select, 4                 ;If selection != 4, jump to S5
               jne S5
               je division                   ;Complete Division
               jmp start                     ;Go back to menu
          S5:
               cmp select, 5                 ;If selection = 5, exit program
               je theExit

          mov ecx, offset prompt8
          mov esi, lengthof prompt8
          call printStr                      ;Inform user to enter valid selection
          
          jmp selection                      ;Ask for another selection

     division:
          ;TODO
          jmp start

addition proc
     push ebp                      ;Save Registers
     mov ebp,esp

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
     

     mov ecx, offset prompt7       ;Result Text
     mov esi, lengthof prompt7
     call printStr

     mov eax, input1               ;Store result in eax
     call writeInt                 ;Print result
     call Crlf                     ;New line

     mov esp, ebp
     pop ebp                       ;Restore Registers
     
     ret
addition endp

;Subtraction is just addition with negative signs
;Ex: 6 - 3 is the same as 6 + (-3)

subtraction proc
     push ebp                      ;Save Registers
     mov ebp,esp
     
                                   ;Perform 2's complement on input2
     xor input2, -1                ;Flip every bit in input2
     inc input2                    ;Increase by 1

     call addition

     mov esp, ebp
     pop ebp                       ;Restore Registers
     ret
subtraction endp

;Example of binary multiplication
;    input1 = 5 input2 = 3
;     5 * 3 = 5 * (2^1 + 2^0) <---- Binary rep of 3 is 0011
;           = 5 * (2 + 1) = (5 * 2) + (5 * 1)
;           = 15

multiplication proc
     push ebp                      ;Save Registers
     mov ebp,esp

     mov eax, input1               ;Move input1 (multiplicand) into eax
     mov ecx, 32                   ;Size of register
     mov ebx, 0                    ;Clear ebx register, counter

                                   ;Pushad and popad reset general registers
     next:
          rcr eax, 1               ;Rotate bits to right
          jnc M1                   ;If carry flag is 1, get position
          pushad                   ;Store all general registers
          
          mov ecx, ebx             ;Move position of on bit into ecx
          mov eax, input2          ;Move input2 (multipler) into eax
                                   ;cl is a 8 bit sub-register of ecx 
          shl eax, cl              ;Perform bitwise multiplication by shl w/ current position
          
                                   ;Use addition procedure here
          add sum, eax             ;add current input2 * 2^cl into sum
          popad                    ;Overwrites all general registers

     M1:
          inc ebx                  ;Current position that bit is on
          loop next                ;Continue to next bit

     mov ecx, offset prompt7       ;Result Text
     mov esi, lengthof prompt7
     call printStr

     mov eax, sum
     call writeInt
     call Crlf                     ;New line

     mov sum, 0                    ;Clear sum

     mov esp, ebp
     pop ebp                       ;Restore Registers

     ret
multiplication endp

getUserInput proc
     push ebp                      ;Save Registers
     mov ebp,esp

     mov ecx, offset prompt9       ;Ask user for first number
     mov esi, lengthof prompt9
     call printStr
     call readInt                  ;Get users input and move into input variable
     mov input1, eax

          
     mov ecx, offset prompt10      ;Ask user for second number
     mov esi, lengthof prompt10
     call printStr
     call readInt                  ;Get users input and move into input variable
     mov input2, eax

     mov esp, ebp
     pop ebp                       ;Restore Registers

     ret
getUserInput endp

printStr proc
     push ebp                      ;Save Registers
     mov ebp,esp

     print:
          mov al, byte ptr[ecx]    ;Move Char at ecx address into al
          inc ecx                  ;Move to next char
          call writeChar           ;Print char to console
          
          cmp al, NULL             ;If null terminated end loop, if not continue
          jnz print

     mov esp, ebp
     pop ebp                       ;Restore Registers

     ret
printStr endp

printMenu proc
     push ebp                      ;Save Registers
     mov ebp,esp

     push esi
     push ecx
     mov esi, ptrT                 ;Pointer to arrayTexts
     mov ecx, [esi]                ;[esi] is first item in arrayTexts
     
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
     
     mov esp, ebp
     pop ebp                       ;Restore Registers

     ret
printMenu endp

     theExit:
          main endp

end main
