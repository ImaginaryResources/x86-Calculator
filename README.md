# x86-Calculator
An attempt to make a calculator with custom Arithmetic Instructions such as xor, and, shifts, and rotations and using the Irvine Library to read and write to the console 

Bitwise operations will be created to add, subtract, multiply, and divide

I want to make as much as I can from scratch

## Bitwise Addition: Assembly vs C++
### Assembly
```assembly
 A1:
      mov eax, input1          ;Store input1 to perform XOR
      xor eax, input2          ;Bitwise operation XOR performs 'add' 
      mov ebx, eax             ;'Add' xor to Sum

      mov eax, input1          ;Store input1 to preform AND
      and eax, input2          ;Bitwise operation AND shows which positions need a carry

      shl eax, 1               ;Shift left to check for carries

      mov input1, ebx          ;Store 'sum' into input1
      mov input2, eax          ;Store shifted carry into input2

      jnz A1                   ;If a carry still exist loop again
      
      ;final sum is stored in input1
```
### C++
```C++
int addition(int input1, int input2) {
     while (input2 != 0) {                       //Loop until carry doesn't exist

          int xorStore = input1 ^ input2;        //Store result of xor operation from inputs
          int andStore = input1 & input2;        //Store result of and operation from inputs

          input1 = xorStore;                     //Store 'sum' into input1
          input2 = andStore << 1;                //Shift left to check for carries
     }
     return input1;                              //Return result stored in input1
}
```

## Resources: 
### For Calculator_Irvine32.asm, builtin MASM using Irvine Library
- Irvinge Library: [ASM Book](https://github.com/surferkip/asmbook)
- Setup MASM dev enviroment: [YouTube](https://www.youtube.com/watch?v=v1VROHebel8)

### For Calculator_MASM.asm, MASM
- MS-DOS Emulator: [DOSBox-X](https://dosbox-x.com/)
- Setup NASM dev enviroment: [Tutorial](https://medium.com/@axayjha/getting-started-with-masm-8086-assembly-c625478265d8)
- Check out: [Where is this 8086.zip from?](https://github.com/ImaginaryResources/x86-Calculator/blob/main/Where%20is%20this%208086.zip%20from.md)

### Understanding DOS Function Calls (int 21h)    
- List: [Function Calls](http://spike.scu.edu.au/~barry/interrupts.html#ah02)
- Examples: [Pdf](https://www.philadelphia.edu.jo/academics/qhamarsheh/uploads/Lecture%2021%20MS-DOS%20Function%20Calls%20_INT%2021h_.pdf)

Used to make UML comments: [ASCII Flow](https://asciiflow.com) 
