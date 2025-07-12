# Makefile to compile and link assembly files with C driver

# Main target - build the unified program using driver.c
all: program

# Compile driver.c to object file
driver.o: driver.c
	gcc -m32 -c driver.c -o driver.o

# Assemble each .asm file to 32-bit object files
sum_array.o: sum_array.asm
	nasm -f elf32 sum_array.asm -o sum_array.o

range_sum.o: range_sum.asm
	nasm -f elf32 range_sum.asm -o range_sum.o

welcome_message.o: welcome_message.asm
	nasm -f elf32 welcome_message.asm -o welcome_message.o

# Create individual executables for testing (optional)
sum_array: sum_array.o
	gcc -m32 -nostartfiles sum_array.o -o sum_array

welcome_message: welcome_message.o
	ld -m elf_i386 -o welcome_message welcome_message.o

# Link all object files with driver to create the main program
program: driver.o range_sum.o sum_array.o welcome_message.o
	gcc -m32 driver.o range_sum.o sum_array.o welcome_message.o -o program

# Optional run target
run: program
	./program

# Clean up generated files
clean:
	rm -f *.o sum_array welcome_message program

.PHONY: all run clean

# Explanation:
# 1. Compile driver.c to driver.o using GCC with 32-bit mode
# 2. Assemble each .asm file into a 32-bit object file (.o) using NASM
# 3. Link all object files with the driver to create the main program
# 4. Individual executables can still be created for testing
# 5. The main program calls all three assembly functions through the C driver
