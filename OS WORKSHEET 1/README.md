# Worksheet 1 - Assembly Programming Tasks

## About this worksheet:

Within this worksheet are 3 tasks, all of these tasks respectively focus on enhancing Assembly Programming skills for Operating Systems development. This includes but is not limited to:
- Calling C functions from assembly language
- Implementing arithmetic operations in x86 assembly
- Building makefiles that help compile and build executables for each task
- Working with system calls and input/output operations
- Array manipulation and range calculations in assembly

More in-depth information will be mentioned in the following sections for the respective tasks.

### Task 1 - Basic Arithmetic Operations:

#### - Task Summary:

The task involves implementing basic arithmetic operations in x86 assembly language. Two separate programs are created:
- **Program 1**: Adds two integers (7 + 7 = 14)
- **Program 2**: Subtracts two integers (20 - 7 = 13)

Each program uses a C driver to call the assembly functions, demonstrating the integration between C and assembly code. The programs are compiled using:
```bash
gcc -m32 -c drivers.c -o drivers.o
nasm -f elf32 task1.asm -o task1.o
nasm -f elf32 asm_io.asm -o asm_io.o
gcc -m32 drivers.o task1.o asm_io.o -o task1
```

The `-m32` flag ensures compatibility with 32-bit binaries on a 64-bit system. Once compiled, run the executables with `./task1` and `./task2`.

#### - Documentation:

In this task three main files exist: `asm_io.asm`, `drivers.c`, and the task implementation files (`task1.asm`, `task2.asm`). The `drivers.c` file serves as the entry point that calls assembly functions:

```c
#include <stdio.h>

extern int asm_main(void);

int main() {
    int ret_status;
    ret_status = asm_main();
    return ret_status;
}
```

The `task1.asm` file implements addition of two integers:
```assembly
section .data
    num1 dd 7        ; First integer
    num2 dd 7        ; Second integer

section .text
    global asm_main
    extern print_int

asm_main:
    mov eax, [num1]     ; Load first integer into eax
    add eax, [num2]     ; Add second integer to eax
    call print_int      ; Print the result
    ret                 ; Return to C program
```

The `task2.asm` file implements subtraction:
```assembly
asm_main:
    mov eax, [num1]     ; Load first integer (20) into eax
    sub eax, [num2]     ; Subtract second integer (7) from eax
    call print_int      ; Print the result (13)
    ret                 ; Return to C program
```

The `asm_io.asm` file provides I/O functions for printing integers and strings to the console using Linux system calls.

#### - Supported OS:

- Linux x86_64 (primary target)
- Linux x86 (32-bit compatibility mode)
- CSCT Cloud environment (recommended)

#### - Installation:

To install and run this task:
```bash
# Navigate to task 1 directory
cd "OS WORKSHEET 1/os task/task 1"

# Clean previous builds
make clean

# Build all targets
make all
```

#### - How to use:

From the makefile that has been developed, this will help us run this task smoothly:
```bash
# Enter the task 1 directory
cd "OS WORKSHEET 1/os task/task 1"

# Build and run task 1 (addition: 7+7=14)
make clean && make all
./task1

# Run task 2 (subtraction: 20-7=13)
./task2
```

Expected output:
- Task 1: `14`
- Task 2: `13`

### Task 2 - Array Operations and User Input:

#### - Task Summary:

This task involves creating three interactive assembly programs that demonstrate:
- **Welcome Message Program**: Asks for user's name and displays a welcome message a specified number of times (50-100)
- **Array Sum Program**: Calculates and displays the sum of an array containing numbers 1-100 (result: 5050)
- **Range Sum Program**: Asks user for start and end indices and calculates the sum of elements within that range

All programs are integrated through a C driver that calls each assembly function in sequence, providing a comprehensive demonstration of user input handling, validation, and array operations.

#### - Documentation:

In this task there are 4 main files: `driver.c`, `sum_array.asm`, `welcome_message.asm`, and `range_sum.asm`. The `driver.c` file acts as a central coordinator:

```c
#include <stdio.h>

extern void welcome_message();
extern void sum_array();
extern void range_sum();

int main() {
    welcome_message();
    sum_array();
    range_sum();
    return 0;
}
```

**welcome_message.asm** handles user interaction and input validation:
```assembly
section .data
    prompt_name db 'Enter your name: ', 0
    prompt_num db 'Enter number of times to print welcome message (50-100): ', 0
    error_msg db 'Error: number must be between 50 and 100.', 0
    welcome_msg db 'Welcome, ', 0
    newline db 0xA, 0

section .bss
    name resb 100
    num_times resb 4

welcome_message:
    ; Prompt for name input
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, prompt_name
    mov edx, 18
    int 0x80

    ; Read user name
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, name
    mov edx, 100
    int 0x80
    
    ; ... validation and output logic
```

**sum_array.asm** demonstrates array initialization and summation:
```assembly
section .bss
    arr resd 100        ; Array of 100 integers
    sum resd 1          ; Store the sum

sum_array:
    ; Initialize array with values 1 to 100
    mov ecx, 1
    lea edi, [arr]

init_array:
    mov [edi], ecx      ; Store current value
    add edi, 4          ; Move to next array element
    inc ecx             ; Increment value
    cmp ecx, 101
    jle init_array

    ; Calculate sum of array
    xor ecx, ecx        ; Clear sum register
    lea edi, [arr]      ; Point to array start
    mov edx, 100        ; Counter for 100 elements

sum_loop:
    add ecx, [edi]      ; Add current element to sum
    add edi, 4          ; Move to next element
    dec edx             ; Decrement counter
    jnz sum_loop        ; Continue if not zero
```

**range_sum.asm** implements user input for range selection and validation:
```assembly
section .data
    array db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, \
          11, 12, 13, 14, 15, 16, 17, 18, 19, 20, \
          ; ... continues to 100
    prompt_start db "Enter the starting index (1-100): ", 0
    prompt_end db "Enter the ending index (1-100): ", 0
    invalid_msg db "Error: Invalid range or input!", 0xA, 0

range_sum:
    ; Prompt for start index
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_start
    mov edx, 34
    int 0x80

    ; Read and validate input
    ; Calculate sum for specified range
    ; Display result
```

#### - Supported OS:

- Linux x86_64 (primary target)
- Linux x86 (32-bit compatibility mode)
- CSCT Cloud environment (recommended)

#### - Installation:

To install and run this task:
```bash
# Navigate to tasks2 directory
cd "OS WORKSHEET 1/os task/tasks2"

# Clean and build
make clean
make program
```

#### - How to use:

From the makefile that has been developed:
```bash
# Enter the tasks2 directory
cd "OS WORKSHEET 1/os task/tasks2"

# Build the integrated program
make clean && make program

# Run interactively (you provide inputs)
./program

# When prompted:
# 1. Enter your name: [Type your name]
# 2. Enter number of times (50-100): [Type a number between 50-100]
# 3. Enter starting index (1-100): [Type start number]
# 4. Enter ending index (1-100): [Type end number]
```

Expected outputs:
- Welcome message repeated specified number of times
- Array sum: `5050`
- Range sum: varies based on your input (e.g., 1-100 = 5050)

### Task 3 - Makefile Integration:

#### - Task Summary:

This task focuses on creating comprehensive Makefiles that automate the build process for both Task 1 and Task 2. The Makefiles handle:
- Compilation of C source files using GCC
- Assembly of .asm files using NASM
- Linking object files to create executables
- Clean-up operations for rebuilds
- Default targets and dependency management

The Makefiles demonstrate proper dependency tracking and ensure that changes to source files trigger appropriate rebuilds.

#### - Documentation:

**Task 1 Makefile** handles compilation of arithmetic operations:
```makefile
# Compiler settings
CC = gcc
NASM = nasm
CFLAGS = -m32
NASMFLAGS = -f elf32

# Default target
all: task1 task2

# Build task1 (addition)
task1: drivers.o task1.o asm_io.o
	$(CC) $(CFLAGS) drivers.o task1.o asm_io.o -o task1

# Build task2 (subtraction)  
task2: drivers.o task2.o asm_io.o
	$(CC) $(CFLAGS) drivers.o task2.o asm_io.o -o task2

# Compile C driver
drivers.o: drivers.c
	$(CC) $(CFLAGS) -c drivers.c -o drivers.o

# Assemble task files
task1.o: task1.asm
	$(NASM) $(NASMFLAGS) task1.asm -o task1.o

task2.o: task2.asm
	$(NASM) $(NASMFLAGS) task2.asm -o task2.o

asm_io.o: asm_io.asm
	$(NASM) $(NASMFLAGS) asm_io.asm -o asm_io.o

# Clean build artifacts
clean:
	rm -f *.o task1 task2

.PHONY: all clean
```

**Task 2 Makefile** manages the integrated program build:
```makefile
# Main target - build the unified program
all: program

# Link all components into final program
program: driver.o range_sum.o sum_array.o welcome_message.o
	gcc -m32 driver.o range_sum.o sum_array.o welcome_message.o -o program

# Compile C driver
driver.o: driver.c
	gcc -m32 -c driver.c -o driver.o

# Assemble individual components
range_sum.o: range_sum.asm
	nasm -f elf32 range_sum.asm -o range_sum.o

sum_array.o: sum_array.asm
	nasm -f elf32 sum_array.asm -o sum_array.o

welcome_message.o: welcome_message.asm
	nasm -f elf32 welcome_message.asm -o welcome_message.o

# Optional: run the program
run: program
	./program

# Clean up generated files
clean:
	rm -f *.o sum_array welcome_message program

.PHONY: all run clean
```

#### - How to use:

**For Task 1:**
```bash
cd "OS WORKSHEET 1/os task/task 1"
make clean      # Clean previous builds
make all        # Build both task1 and task2
./task1         # Run addition program
./task2         # Run subtraction program
```

**For Task 2:**
```bash
cd "OS WORKSHEET 1/os task/tasks2"
make clean      # Clean previous builds
make program    # Build integrated program
make run        # Build and run program
# OR
./program       # Run program directly
```

## Testing Instructions:

### Complete Test Sequence:
```bash
# Test Task 1
cd "OS WORKSHEET 1/os task/task 1"
make clean && make all
echo "Task 1 result (7+7): $(./task1)"
echo "Task 2 result (20-7): $(./task2)"

# Test Task 2 (Interactive)
cd "../tasks2"
make clean && make program
echo "Running interactive program:"
./program
# Follow prompts for name, repetitions, and range inputs
```

### Expected Results:
- **Task 1**: Outputs `14` and `13` respectively
- **Task 2**: Interactive prompts with validated input and calculated results
- **Array Sum**: Always outputs `5050`
- **Range Sum**: Varies based on user input (1-100 range = 5050)

## Architecture Notes:

- **32-bit Compatibility**: All programs use `-m32` flag for 32-bit execution
- **System Calls**: Uses Linux system calls (int 0x80) for I/O operations
- **Memory Management**: Proper stack management and register preservation
- **Input Validation**: Range checking and error handling for user inputs
- **Modular Design**: Separate assembly modules with C integration

# Author
This project "Worksheet 1 - Assembly Programming Tasks" has been developed by Shahzoor Abbas and submitted to the University of West of England for Operating Systems coursework. 