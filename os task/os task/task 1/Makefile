# Makefile for building Task 1 executables

# build all executables
default: all

# Rule for building all executables
all: task1 task2

# ----------- TASK 1 -----------

# create task1 executable
# This executable links the compiled assembly (task1.asm) and the driver.c file, along with asm_io.o
task1: drivers.o task1.o asm_io.o
	gcc -m32 drivers.o task1.o asm_io.o -o task1

# Compile driver.c to driver.o
drivers.o: drivers.c
	gcc -m32 -c drivers.c -o drivers.o

# Assemble task1.asm to task1.o
task1.o: task1.asm
	nasm -f elf32 task1.asm -o task1.o

# Assemble asm_io.asm to asm_io.o
asm_io.o: asm_io.asm
	nasm -f elf32 asm_io.asm -o asm_io.o

# ----------- TASK 2 -----------

# create task 2 executable
# This executable links driver.c with task2.asm and asm_io.o
task2: drivers.o task2.o asm_io.o
	gcc -m32 drivers.o task2.o asm_io.o -o task2

# Assemble task2.asm to task2.o 
task2.o: task2.asm
	nasm -f elf32 task2.asm -o task2.o

# ----------- RUN TARGETS -----------

# Optional run targets for testing
run-task1: task1
	./task1

run-task2: task2
	./task2

run-all: task1 task2
	@echo "Running task1:"
	./task1
	@echo "Running task2:"
	./task2

# clean up all generated files
.PHONY: clean run-task1 run-task2 run-all
clean:
	rm -f *.o task1 task2
