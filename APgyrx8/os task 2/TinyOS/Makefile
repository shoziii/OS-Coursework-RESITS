# Variables
NASM = nasm
CC = gcc
LD = ld
MKISO = genisoimage
QEMU = qemu-system-i386

# Directories
SOURCE_DIR = source
DRIVERS_DIR = drivers
ISO_DIR = iso
GRUB_DIR = $(ISO_DIR)/boot/grub

# Files
LOADER_ASM = loader.asm
LINKER_SCRIPT = $(SOURCE_DIR)/link.ld
KERNEL_C = $(SOURCE_DIR)/kernel.c
FRAMEBUFFER_C = $(DRIVERS_DIR)/framebuffer.c
PIC_C = $(DRIVERS_DIR)/pic.c
INTERRUPTS_C = $(DRIVERS_DIR)/interrupts.c
KEYBOARD_C = $(DRIVERS_DIR)/keyboard.c
IO_S = $(DRIVERS_DIR)/io.s
INTERRUPT_ASM_S = $(DRIVERS_DIR)/interrupt_asm.s
INTERRUPT_HANDLERS_S = $(DRIVERS_DIR)/interrupt_handlers.s
HARDWARE_INTERRUPT_ENABLER_S = $(DRIVERS_DIR)/hardware_interrupt_enabler.s
KERNEL_ELF = $(ISO_DIR)/boot/kernel.elf
ISO_FILE = os.iso
STAGE2_FILE = $(GRUB_DIR)/stage2_eltorito

# Object files
LOADER_OBJ = loader.o
KERNEL_OBJ = kernel.o
FRAMEBUFFER_OBJ = framebuffer.o
PIC_OBJ = pic.o
INTERRUPTS_OBJ = interrupts.o
KEYBOARD_OBJ = keyboard.o
IO_OBJ = io.o
INTERRUPT_ASM_OBJ = interrupt_asm.o
INTERRUPT_HANDLERS_OBJ = interrupt_handlers.o
HARDWARE_INTERRUPT_ENABLER_OBJ = hardware_interrupt_enabler.o

# All object files
ALL_OBJ = $(LOADER_OBJ) $(KERNEL_OBJ) $(FRAMEBUFFER_OBJ) $(PIC_OBJ) $(INTERRUPTS_OBJ) $(KEYBOARD_OBJ) $(IO_OBJ) $(INTERRUPT_ASM_OBJ) $(INTERRUPT_HANDLERS_OBJ) $(HARDWARE_INTERRUPT_ENABLER_OBJ)

# Rules
all: $(ISO_FILE)

# Compile the assembly file to an object file
$(LOADER_OBJ): $(LOADER_ASM)
	$(NASM) -f elf $(LOADER_ASM) -o $(LOADER_OBJ)

# Compile the kernel C file to an object file
$(KERNEL_OBJ): $(KERNEL_C)
	$(CC) -m32 -ffreestanding -c $(KERNEL_C) -o $(KERNEL_OBJ)

# Compile the framebuffer C file to an object file
$(FRAMEBUFFER_OBJ): $(FRAMEBUFFER_C)
	$(CC) -m32 -ffreestanding -c $(FRAMEBUFFER_C) -o $(FRAMEBUFFER_OBJ)

# Compile the PIC C file to an object file
$(PIC_OBJ): $(PIC_C)
	$(CC) -m32 -ffreestanding -c $(PIC_C) -o $(PIC_OBJ)

# Compile the interrupts C file to an object file
$(INTERRUPTS_OBJ): $(INTERRUPTS_C)
	$(CC) -m32 -ffreestanding -c $(INTERRUPTS_C) -o $(INTERRUPTS_OBJ)

# Compile the keyboard C file to an object file
$(KEYBOARD_OBJ): $(KEYBOARD_C)
	$(CC) -m32 -ffreestanding -c $(KEYBOARD_C) -o $(KEYBOARD_OBJ)

# Assemble the I/O assembly file to an object file
$(IO_OBJ): $(IO_S)
	$(NASM) -f elf $(IO_S) -o $(IO_OBJ)

# Assemble the interrupt assembly file to an object file
$(INTERRUPT_ASM_OBJ): $(INTERRUPT_ASM_S)
	$(NASM) -f elf $(INTERRUPT_ASM_S) -o $(INTERRUPT_ASM_OBJ)

# Assemble the interrupt handlers assembly file to an object file
$(INTERRUPT_HANDLERS_OBJ): $(INTERRUPT_HANDLERS_S)
	$(NASM) -f elf $(INTERRUPT_HANDLERS_S) -o $(INTERRUPT_HANDLERS_OBJ)

# Assemble the hardware interrupt enabler assembly file to an object file
$(HARDWARE_INTERRUPT_ENABLER_OBJ): $(HARDWARE_INTERRUPT_ENABLER_S)
	$(NASM) -f elf $(HARDWARE_INTERRUPT_ENABLER_S) -o $(HARDWARE_INTERRUPT_ENABLER_OBJ)

# Link all object files to create the kernel.elf
$(KERNEL_ELF): $(ALL_OBJ) $(LINKER_SCRIPT)
	$(LD) -T $(LINKER_SCRIPT) -melf_i386 $(ALL_OBJ) -o $(KERNEL_ELF)

# Create the ISO image containing the kernel
$(ISO_FILE): $(KERNEL_ELF)
	mkdir -p $(GRUB_DIR)
	cp $(STAGE2_FILE) $(GRUB_DIR)/
	$(MKISO) -R \
		-b boot/grub/stage2_eltorito \
		-no-emul-boot \
		-boot-load-size 4 \
		-A os \
		-input-charset utf8 \
		-quiet \
		-boot-info-table \
		-o $(ISO_FILE) \
		$(ISO_DIR)

# run the kernel in QEMU with Curses mode
run: $(ISO_FILE)
	$(QEMU) -curses -monitor telnet::65000,server,nowait -serial mon:stdio -boot d -cdrom $(ISO_FILE) -m 32 -d cpu -D logQ.txt

# clean the build files
clean:
	rm -f $(ALL_OBJ) $(KERNEL_ELF) $(ISO_FILE)

.PHONY: all run clean
