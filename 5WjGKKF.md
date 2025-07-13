# Worksheet 2

## About this worksheet:

Within this worksheet are 3 tasks, all of these tasks respectivly focus on enhancing Assembler Programming Skills & Developing an OS using TinyOS, this will include and not limited to: 
- Calling C from an assembler 
- Devloping a framedriver buffer for TinyOS.
- Basics of a boot machine.


### Task 1

#### - Task Summary:
This task involves building a basic operating system that writes the value `0xCAFEBABE` to the `eax` register. Here's a summarized step-by-step breakdown:

- Directory Setup: Create a directory structure:
   - `drivers`, `source`, `iso`, `boot`, `grub`
   - Add `.gitignore`, `Makefile`, and `README.md`.

- Kernel Development:
   - Write the kernel in assembly (`loader.asm`) to initialize the system and write `0xCAFEBABE` to `eax`. Use the Multiboot specification to include magic numbers, flags, and checksum.
   - Compile with `nasm`:
     ```bash
     nasm -f elf loader.asm
     ```

- Linking:
   - Use a custom linker script (`link.ld`) to link the kernel at the memory address `0x00100000` (1 MB), as required by GRUB.
   - Link the compiled object file:
     ```bash
     ld -T ./source/link.ld -melf_i386 loader.o -o kernel.elf
     ```

- GRUB Configuration:
   - Copy `stage2_eltorito` to `iso/boot/grub`.
   - Create `menu.lst` to configure GRUB and point to `kernel.elf`.

- ISO Image Creation:
   - Use the following command to generate the ISO image:
     ```bash
     genisoimage -R \
     -b boot/grub/stage2_eltorito \
     -no-emul-boot \
     -boot-load-size 4 \
     -A os \
     -input-charset utf8 \
     -quiet \
     -boot-info-table \
     -o os.iso \
     iso
     ```

- Testing with QEMU:
   - Run the kernel using QEMU:
     ```bash
     qemu-system-i386 -nographic -boot d -cdrom os.iso -m 32 -d cpu -D logQ.txt
     ```
   - Verify that `eax` contains `0xCAFEBABE` in `logQ.txt`.

- Makefile:
   - Create a `Makefile` to automate:
     - Building the kernel.
     - Copying necessary files into the GRUB directory.
     - Generating the ISO.
   - Add a `run` rule to load and run the ISO image in QEMU.

By following these steps, you will have a bootable ISO image of your kernel that runs and outputs the expected value to the `eax` register, confirming the system boots correctly.

#### - Documentation: 
Start creating the following directories and files:
```
drivers/
source/
iso/
boot/
grub/
.gitignore
Makefile
```
These directories and files are needed to organize the different components that make up our OS.
*Linker Script:*
- This will tell the linker where to load our code in memory, particularly for booting purposes.
*Create the Bootloader Configuration:*
- We will use GRUB to load our kernel.
*Create the ISO Image:*
- We will use genisoimage to create a bootable ISO file for our OS.
*Run in QEMU:*
- Finally, we will use QEMU to test our OS.
*Write a Makefile:*
Automate all these steps for ease of building, linking, creating ISO, and running.

Then we create a file called `loader.asm` in the root directory The code initializes the eax register to 0xCAFEBABE. 

Then we create a file named link.ld in the source/ directory. This script tells the linker how to arrange sections of memory, ensuring the code is loaded at address 0x00100000 and properly aligned.

Then menu.lst file is created this file helps booy our os. menu.lst provides GRUB with the information needed to display a boot menu and load your operating system kernel.

And finally we create a makefile in the root directory as it was mentioned before the makfile helps compile and create executables which ultimately help make any program as smooth as possible. 

#### - Installation:

To install this repo run the following commands: ***(for windows)***
- Clone the repo 
```
git clone https://gitlab.uwe.ac.uk/s2-shehata/worksheet-2.git
```
- Change git remote url to avoid accidental pushes to base project
``` 
git remote set-url origin https://gitlab.uwe.ac.uk/s2-shehata/worksheet-2.git 
git remote -v # confirms the changes made from the first command
```
- Copy the folder named "Task 1"

### Task 2

#### - Task Summary:
Extend your kernel to support calling C functions by updating loader.asm to transfer control to C. Implement sum_of_three and at least two additional C functions, then test them. Update the Makefile to handle compiling C files, linking with assembly, and building the kernel. Ensure the entire process, from setup to execution, is automated and testable in QEMU.

#### - Documentation: 
extending loader.asm to call c code, implement sum_of_three in C along with two additional C functions and Modify the Makefile to compile both assembly and C code and link them properly
Then now we create a kernel.c file in the source directory containing sum_of_three , the multiply which multiplies 2 integers and max_of_two
Which finds the maximum of two integers.

```
int sum_of_three(int a, int b, int c) {
    return a + b + c;
}

int multiply(int a, int b) {
    return a * b;
}

int max_of_two(int a, int b) {
    return (a > b) ? a : b;
}
```
finally update the makfile to be compatible with the changes. Add the compiling steps for kernel.c in the makfile.
```
KERNEL_C = $(SOURCE_DIR)/kernel.c


$(KERNEL_OBJ): $(KERNEL_C)
    $(CC) -m32 -ffreestanding -c $(KERNEL_C) -o $(KERNEL_OBJ)
```
#### - Installation:

To install this repo run the following commands: ***(for windows)***
- Clone the repo 
```
git clone https://gitlab.uwe.ac.uk/s2-shehata/worksheet-2.git
```
- Change git remote url to avoid accidental pushes to base project
``` 
git remote set-url origin https://gitlab.uwe.ac.uk/s2-shehata/worksheet-2.git 
git remote -v # confirms the changes made from the first command
```
- Copy the folder named "Task 2"

### Task 3

#### - Task Summary:
This task focuses on adding basic I/O functionality to an OS by implementing a framebuffer driver to display text on the console, followed by keyboard interaction. Two hardware interaction methods are explored: memory-mapped I/O and I/O ports. Using QEMU in Curses mode, you will configure and test the framebuffer. The goal is to create a 2D API for the framebuffer to support cursor movement, text printing, color settings, and clearing the display. The API and driver will be tested with a custom kernel, and necessary updates should be made to the Makefile for compilation and QEMU execution.

#### - Documentation: 
framebuffer.c file in the drivers directory is what interacts with video memory. The contents will be in the file
Then we update the kernel.c file to include the new framebuffer header and use it to test output.
```
#include "../drivers/framebuffer.c" 
```
Then we update the makfile to add the compilaton steps for the frambuffer.c and to run the QEMU in Curses mode.
```
FRAMEBUFFER_C = $(DRIVERS_DIR)/framebuffer.c

$(FRAMEBUFFER_OBJ): $(FRAMEBUFFER_C)
    $(CC) -m32 -ffreestanding -c $(FRAMEBUFFER_C) -o $(FRAMEBUFFER_OBJ)

run: $(ISO_FILE)
    $(QEMU) -curses -monitor telnet::65000,server,nowait -serial mon:stdio -boot d -cdrom $(ISO_FILE) -m 32 -d cpu -D logQ.txt
```
#### - Installation:
To install this repo run the following commands: ***(for windows)***
- Clone the repo 
```
git clone https://gitlab.uwe.ac.uk/s2-shehata/worksheet-2.git
```
- Change git remote url to avoid accidental pushes to base project
``` 
git remote set-url origin https://gitlab.uwe.ac.uk/s2-shehata/worksheet-2.git 
git remote -v # confirms the changes made from the first command
```
- Copy the folder named "Task 3"

### How to use *(for all task)*:

Use the following commands, after running `Make clean` re-run `Make` & `Make run`
```
Make
Make run
Make clean
```

# Author 
This project "worksheet-2" has been developed by Saif Wael & submitted to the University of West of England.