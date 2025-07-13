<h1 align="center">Worksheet 1</h1>

## About this worksheet: 

Within this worksheet are 3 tasks, all of these tasks respectivly focus on enhancing Assembler Programming skill, this will include and not limited to: 
- Calling C from the assembler.
- Translating C loops into the assembler.
- Building makefiles that help compile and build executables for each task.

More indepth information will be mentioned in the following sections for the respective tasks.

### Task 1:

#### - Task Summary:

The task involves implementing programs described in the Week 8 lecture. For the first program, you must create an assembler program with a function `asm_main` (as shown on slide 18) that adds two integers stored in global memory and outputs the result using `print_int`. A supporting C driver program (`driver.c`) calls the `asm_main` function.

You compile the components (`.asm`, `.inc`, and `driver.c`) into object files using the following commands:
- `nasm` for assembling `.asm` files.
- `gcc` for compiling and assembling the C file.

Then, link the object files into an executable with:
```bash
gcc -m32 driver.o task1.o asm_io.o -o task1
```

The `-m32` flag ensures compatibility with 32-bit binaries on a 64-bit system. Once compiled, run the executable with `./task1`.

#### - Documentation:

In this task three files should exist asm_io.asm, driver.c, task1.asm. The driver.c does a specific job which calls c from the assembler. Here is an example: 

```
#include <stdio.h>

int attribute((cdecl)) asm_main(void);

int main() {
    int ret_status;
    ret_status = asm_main();  // Call the asm_main function in Assembly
    return ret_status;
}
```
The task1.asm file is responocible for adding two integers and outputting the result, here is an example: 
```
section .data
    num1 dd 6        ; First integer
    num2 dd 7        ; Second integer
    result dd 0      ; To store the result
```
*this shows the first & second integer being added & stored into a register*

The asm_io.asm file defines two functions: print_int and print_string. These functions are responsible for printing an integer and a string to the standard output.
```
print_int:
    pusha
    ; Check if the number is zero
    cmp eax, 0
    je print_zero

    mov ebx, 10             ; Divisor for base 10
    mov ecx, num_buffer     ; Address of the buffer
    add ecx, 10             ; Start from the second-to-last position of the buffer
    mov byte [ecx], 10      ; Store newline character at the end
    mov byte [ecx + 1], 0   ; Null terminate the string
```
so what the print_int function does is that it it takes an integer value in the eax register, converts it to a string, and prints it out.
If the value in eax is 0, the function jumps to the label print_zero to handle zero as a special case.
```
print_string:
    pusha
    ; Print string (ebx points to the string)
    mov eax, 4         ; Syscall number for sys_write
    mov ebx, 1         ; File descriptor (stdout)
    mov ecx, ebx       ; Pointer to the string
    mov edx, 100       ; Set a large buffer size (adjust as needed)
    int 0x80           ; Make the syscall
    popa
    ret
```
The print_string function takes a pointer to a string in ebx and prints it to the terminal.
String Printing:
- mov eax, 4 sets up the sys_write system call.
- mov ebx, 1 specifies the file descriptor (1 for stdout).
- mov ecx, ebx uses the pointer from ebx to point to the string to be printed.
- mov edx, 100 sets the buffer length. This is not dynamically calculated, so there is a risk of overflow if the string is longer than 100 characters.
- The system call int 0x80 is used to output the string to the console.
Epilogue: popa restores all registers, and ret returns to the caller.

Lastely, the second part of this task is to do everything we did above including the usage of the same compiling steps with the differences being compiling it using task2.asm instead. `task2.asm` is substracting two integers instead of adding them like in part 1. 
Here's how it works:
```
asm_main:
    mov eax, [num1]     ; Load first integer into eax
    sub eax, [num2]     ; Subtract second integer from eax
    push eax            ; Push result to stack for print_int
    call print_int      ; Call the provided print function
    add esp, 4          ; Clean up stack
    ret                 ; Return to C program
```

#### - Supported OS:

- Win10 32bit (recommended) 
- Win10 64bit (not tested)
- Win11 64bit (not tested)

#### - Installation:

To install this repo run the following commands: ***(for windows)***
- Clone the repo 
```
git clone https://gitlab.uwe.ac.uk/s2-shehata/worksheet-1.git
```
- Change git remote url to avoid accidental pushes to base project
``` 
git remote set-url origin https://gitlab.uwe.ac.uk/s2-shehata/worksheet-1.git 
git remote -v # confirms the changes made from the first command
```
- Copy the folder named `Task 1`.

#### - How to use: 

From the makefile that has been developed, this will help us run this task smoothly, here is how: 
- Enter the directory `cd "<dir>/Task 1"`
- Use the command `make`
- Use the command `./task1`
- On a separate terminal, run the commands:
```
make
./task2
 ```

Then the programs should start running with no issues.


### Task 2:

#### - Task Summary:
The task involves translating C programs involving loops and conditionals into assembly language using the PC Assembly Language book (sections 2.2 and 2.3) as a reference. Key tasks include:

- Writing an assembly program that:
   - Asks for the user's name and a number of repetitions for a welcome message.
   - Validates that the number is between 50 and 100.
   - Displays the message the specified number of times or an error if the input is out of range.

- Writing an assembly program to:
   - Define and initialize an array with numbers 1 to 100.
   - Calculate and output the sum of the array.

- Extending the array program to:
   - Ask the user for a range of indices.
   - Validate the range and output the sum of the elements within that range.


#### - Documentation: 
In this task there are 4 main files which are driver.c, sum_arry.asm, welcome_message.asm, and range_sum.asm
The driver.c file acts as a central hub that coordinates and executes the assembly routines I have created.
```
extern void welcome_message();
extern void sum_array();
extern void range_sum();
```
The extern keyword declares the functions implemented in assembly, signaling to the compiler that their definitions exist elsewhere.
```
int main() {
    welcome_message();
    sum_array();
    range_sum();
    return 0;
}
```
And the main function calls welcome_message, sum_array and range_sum.

welcome_message.asm this file basically asks the user for to enter their name the asks them to enter how many times you want your name to be outputted between 50-100
```
section .data
    prompt_name db 'Enter your name: ', 0
    prompt_num db 'Enter number of times to print welcome message (50-100): ', 0
    error_msg db 'Error: number must be between 50 and 100.', 0
    welcome_msg db 'Welcome, ', 0
    newline db 0xA, 0
```
range_sum.asm this script asks the user to Enter the starting index (1-100) and Enter the ending index (1-100) and then outputs The sum of the range is()
```
section .data
    array db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, \
          11, 12, 13, 14, 15, 16, 17, 18, 19, 20, \
          21, 22, 23, 24, 25, 26, 27, 28, 29, 30, \
          31, 32, 33, 34, 35, 36, 37, 38, 39, 40, \
          41, 42, 43, 44, 45, 46, 47, 48, 49, 50, \
          51, 52, 53, 54, 55, 56, 57, 58, 59, 60, \
          61, 62, 63, 64, 65, 66, 67, 68, 69, 70, \
          71, 72, 73, 74, 75, 76, 77, 78, 79, 80, \
          81, 82, 83, 84, 85, 86, 87, 88, 89, 90, \
          91, 92, 93, 94, 95, 96, 97, 98, 99, 100
    prompt_start db "Enter the starting index (1-100): ", 0
    prompt_end db "Enter the ending index (1-100): ", 0
    invalid_msg db "Error: Invalid range or input!", 0xA, 0
    result_msg db "The sum of the range is: ", 0
    newline db 0xA, 0
```

sum_arry.asm defines an array of 100 elements, initialize the array to the numbers 1 to 100, and then sum the that array, outputting the result.
```
_start:
    ; Initialize the array with values 1 to 100
    mov ecx, 1
    lea edi, [arr]

init_array:
    mov [edi], ecx
    add edi, 4
    inc ecx
    cmp ecx, 101
    jle init_array

    ; Calculate the sum of the array
    xor ecx, ecx
    lea edi, [arr]
    mov edx, 100
```

#### - Supported OS: 

- Win10 32bit (recommended) 
- Win10 64bit (not tested)
- Win11 64bit (not tested)

#### - Installation:

To install this repo run the following commands: ***(for windows)***
- Clone the repo 
```
git clone https://gitlab.uwe.ac.uk/s2-shehata/worksheet-1.git
```
- Change git remote url to avoid accidental pushes to base project
``` 
git remote set-url origin https://gitlab.uwe.ac.uk/s2-shehata/worksheet-1.git 
git remote -v # confirms the changes made from the first command
```
- Copy the folder named `Task 2`.

#### - How to use:

From the makefile that has been developed, this will help us run this task smoothly, here is how:
- Use the command(s):
```
make all
./welcome_message
./program
make sum_array
./sum_array
```
- To re-run everything, use command `make clean` & re-run all the previous commands.

Then the programs should start running with no issues.

### Task 3:

#### - Task Summary:

This task introduces the use of `make` and `Makefile` for managing program builds more efficiently. Instead of building each program individually, `make` automates the process based on rules defined in a `Makefile`. 

- A `Makefile` consists of **targets**, **prerequisites**, and **recipes**:
  - **Target**: The file or action to be generated (e.g., executable or object files).
  - **Prerequisites**: Input files needed to build the target.
  - **Recipe**: Commands to build the target.

For example, to compile a `hello.c` file into an executable `hello`, the rule is:
```makefile
hello: hello.c
    gcc -o hello hello.c
```

Running `make` without specifying a target defaults to the first rule, or you can specify a target like `make hello`. Rules like `all` can be used to build multiple targets at once:
```makefile
all: hello goodbye
hello: hello.c
    gcc -o hello hello.c
goodbye: goodbye.c
    gcc -o goodbye goodbye.c
```

**Task**: Create a `Makefile` in your repository's root directory with targets for building all executables from the previous two tasks. Add a default rule (`all`) to build all targets simultaneously.

#### - Documentation: 
For task 1, the make file contains all the compilation steps for the first & second part of task 1, including and not limited to building the executables which are `./task1` & `./task2`. 
```
task1: drivers.o task1.o asm_io.o
	gcc -m32 drivers.o task1.o asm_io.o -o task1
	./task1

drivers.o: drivers.c
	gcc -m32 -c drivers.c -o drivers.o

task1.o: task1.asm
	nasm -f elf32 task1.asm -o task1.o

asm_io.o: asm_io.asm
	nasm -f elf32 asm_io.asm -o asm_io.o
```
For task 2, the make file contains all the compilation steps and building the executables which are `./sum_array`, `./program` & `./welcome_message`. 
```
all: program

sum_array.o: sum_array.asm
    nasm -f elf32 sum_array.asm -o sum_array.o

range_sum.o: range_sum.asm
    nasm -f elf32 range_sum.asm -o range_sum.o

welcome_message.o: welcome_message.asm
    nasm -f elf32 welcome_message.asm -o welcome_message.o

sum_array: sum_array.o
    gcc -m32 -nostartfiles sum_array.o -o sum_array

welcome_message: welcome_message.o
    ld -m elf_i386 -o welcome_message welcome_message.o

program: range_sum.o sum_array.o welcome_message.o
    gcc -m32 -nostartfiles -Wl,--entry=start range_sum.o sum_array.o welcome_message.o -o program

clean:
    rm -f *.o sum_array range_sum welcome_message program
```

# Author 
This project "worksheet-1" has been developed by Saif Wael & submitted to the University of West of England.
