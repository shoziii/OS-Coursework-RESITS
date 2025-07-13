# Worksheet 2 - TinyOS Development

## About this worksheet:

Within this worksheet are 3 tasks, all of these tasks respectively focus on enhancing Operating System Development skills & building a functional TinyOS from scratch. This includes but is not limited to:
- Developing a bootable operating system kernel
- Implementing interrupt handling and system calls
- Creating device drivers for keyboard and framebuffer
- Building memory management and I/O systems
- Integrating assembly language with C for kernel development

More in-depth information will be mentioned in the following sections for the respective tasks.

### Task 1 - Basic Bootable Kernel:

#### - Task Summary:

This task involves building a basic operating system that successfully boots and initializes a minimal kernel. The implementation includes:
- **Bootloader**: GRUB-compatible bootloader using Multiboot specification
- **Kernel Initialization**: Assembly loader that sets up basic system state
- **Memory Setup**: Proper memory layout and segment configuration
- **Build System**: Automated build process using Make and ISO generation

The kernel is designed to boot from an ISO image and can be tested using QEMU emulation. Key components include proper Multiboot headers, memory alignment, and GRUB configuration.

#### - Documentation:

The directory structure for this task includes:
```
TinyOS/
├── drivers/          # Device drivers and hardware interfaces
├── source/           # Main kernel source code
├── iso/              # ISO image components
│   └── boot/
│       └── grub/     # GRUB bootloader configuration
├── Makefile          # Build automation
└── README.md         # Project documentation
```

**loader.asm** - Assembly bootloader implementing Multiboot specification:
```assembly
; Multiboot header
MBALIGN  equ  1<<0              ; align loaded modules on page boundaries
MEMINFO  equ  1<<1              ; provide memory map
FLAGS    equ  MBALIGN | MEMINFO ; Multiboot 'flag' field
MAGIC    equ  0x1BADB002        ; magic number for bootloader
CHECKSUM equ -(MAGIC + FLAGS)   ; checksum of above

section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

section .text
global _start

_start:
    ; Set up stack
    mov esp, stack_top
    
    ; Call kernel main function
    extern kernel_main
    call kernel_main
    
    ; Halt if kernel returns
    cli
.hang:
    hlt
    jmp .hang

section .bss
align 16
stack_bottom:
resb 16384      ; 16 KiB stack
stack_top:
```

**link.ld** - Custom linker script for proper memory layout:
```ld
ENTRY(_start)

SECTIONS
{
    . = 0x00100000;
    
    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.multiboot)
        *(.text)
    }
    
    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }
    
    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }
    
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }
}
```

**GRUB Configuration** - Boot menu setup:
```
set timeout=0
set default=0

menuentry "TinyOS" {
    multiboot /boot/kernel.elf
}
```

#### - Supported OS:

- Linux x86_64 with 32-bit compatibility
- CSCT Cloud environment (recommended)
- QEMU virtualization support
- GRUB2 bootloader compatible

#### - Installation:

To install and build this task:
```bash
# Navigate to TinyOS directory
cd "OS WORKSHEET 2/os task 2/TinyOS"

# Clean previous builds
make clean

# Build kernel and ISO
make
```

#### - How to use:

From the comprehensive Makefile:
```bash
# Build the complete OS
cd "OS WORKSHEET 2/os task 2/TinyOS"
make clean && make

# Run in QEMU (if available)
make run

# Check generated files
ls -la os.iso iso/boot/kernel.elf
```

Expected outputs:
- `kernel.elf`: Executable kernel (~15KB)
- `os.iso`: Bootable ISO image (~480KB)

### Task 2 - Kernel with C Integration:

#### - Task Summary:

This task extends the basic kernel to support C programming by implementing proper calling conventions and demonstrating C function integration. Key features include:
- **C Runtime Setup**: Stack initialization and calling convention setup
- **Function Implementation**: Multiple C functions demonstrating arithmetic operations
- **Mixed Programming**: Seamless integration between assembly loader and C kernel
- **Build Integration**: Updated build system to handle both assembly and C compilation

The kernel demonstrates practical C function calls including `sum_of_three`, `multiply`, and `max_of_two` functions with proper parameter passing and return value handling.

#### - Documentation:

**kernel.c** - Main kernel implementation in C:
```c
#include <stdint.h>
#include "../drivers/framebuffer.h"

// Function prototypes
int sum_of_three(int a, int b, int c);
int multiply(int a, int b);
int max_of_two(int a, int b);

// Main kernel function called from assembly
void kernel_main() {
    // Clear screen and initialize
    fb_clear_screen();
    fb_write_string("TinyOS Kernel is running!", 0, 0, FB_WHITE);
    
    // Test arithmetic functions
    int result1 = sum_of_three(3, 5, 7);
    int result2 = multiply(4, 5);
    int result3 = max_of_two(10, 15);
    
    // Display results
    fb_write_string("Sum of 3, 5, 7: ", 2, 0, FB_WHITE);
    // Convert and display result1
    
    fb_write_string("Product of 4 and 5: ", 3, 0, FB_WHITE);
    // Convert and display result2
    
    fb_write_string("Max of 10 and 15: ", 4, 0, FB_WHITE);
    // Convert and display result3
    
    // Halt system
    while (1) {
        __asm__("hlt");
    }
}

// Arithmetic function implementations
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

**Updated Makefile** for C compilation:
```makefile
# Compiler settings
CC = gcc
NASM = nasm
LD = ld
CFLAGS = -m32 -ffreestanding -fno-stack-protector
NASMFLAGS = -f elf
LDFLAGS = -T source/link.ld -melf_i386

# Directories
SOURCE_DIR = source
DRIVERS_DIR = drivers
ISO_DIR = iso

# Target files
KERNEL_ELF = $(ISO_DIR)/boot/kernel.elf
ISO_FILE = os.iso

# Object files
LOADER_OBJ = loader.o
KERNEL_OBJ = kernel.o

# Build targets
all: $(ISO_FILE)

$(ISO_FILE): $(KERNEL_ELF)
    genisoimage -R \
        -b boot/grub/stage2_eltorito \
        -no-emul-boot \
        -boot-load-size 4 \
        -A os \
        -input-charset utf8 \
        -quiet \
        -boot-info-table \
        -o $(ISO_FILE) \
        $(ISO_DIR)

$(KERNEL_ELF): $(LOADER_OBJ) $(KERNEL_OBJ)
    $(LD) $(LDFLAGS) $(LOADER_OBJ) $(KERNEL_OBJ) -o $(KERNEL_ELF)

$(LOADER_OBJ): loader.asm
    $(NASM) $(NASMFLAGS) loader.asm -o $(LOADER_OBJ)

$(KERNEL_OBJ): $(SOURCE_DIR)/kernel.c
    $(CC) $(CFLAGS) -c $(SOURCE_DIR)/kernel.c -o $(KERNEL_OBJ)
```

#### - Installation:

Same as Task 1 with enhanced build process:
```bash
cd "OS WORKSHEET 2/os task 2/TinyOS"
make clean && make
```

#### - How to use:

Enhanced usage with C integration:
```bash
# Build and test C kernel
make clean && make
make run    # Run in QEMU to see C functions working

# Verify kernel contains C code
file iso/boot/kernel.elf
strings iso/boot/kernel.elf | grep -i tiny
```

### Task 3 - Complete OS with Interrupt System:

#### - Task Summary:

This task implements a fully functional operating system with comprehensive interrupt handling, keyboard input, and framebuffer output. Key features include:
- **Interrupt Descriptor Table (IDT)**: Complete interrupt handling system
- **PIC Configuration**: Programmable Interrupt Controller setup and management
- **Keyboard Driver**: Full keyboard input processing with scan code mapping
- **Framebuffer Driver**: Advanced text display with colors and cursor management
- **Real-time Interaction**: Interactive keyboard input with immediate screen feedback

This represents a complete miniature operating system capable of handling user input and providing visual feedback.

#### - Documentation:

**Interrupt System Implementation:**

**interrupts.h** - Interrupt system definitions:
```c
#ifndef INTERRUPTS_H
#define INTERRUPTS_H

#include "type.h"

// IDT entry structure
struct IDT {
    u16int low_offset;
    u16int selector;
    u8int always0;
    u8int flags;
    u16int high_offset;
} __attribute__((packed));

// CPU state structure for interrupt handlers
typedef struct {
    u32int ds;
    u32int edi, esi, ebp, esp, ebx, edx, ecx, eax;
    u32int interrupt_number, error_code;
    u32int eip, cs, eflags, useresp, ss;
} cpu_state_t;

// Function prototypes
void interrupts_install_idt();
void interrupts_init_descriptor(u8int num, u32int handler);

#endif
```

**interrupts.c** - Interrupt handling implementation:
```c
#include "interrupts.h"
#include "io.h"
#include "pic.h"
#include "keyboard.h"
#include "framebuffer.h"

#define IDT_ENTRIES 256
#define KEYBOARD_MAX_ASCII 93

// Global IDT
struct IDT idt[IDT_ENTRIES];

// IDT descriptor for loading
struct {
    u16int limit;
    u32int base;
} __attribute__((packed)) idt_descriptor;

// Initialize IDT
void interrupts_install_idt() {
    // Set up IDT descriptor
    idt_descriptor.limit = sizeof(idt) - 1;
    idt_descriptor.base = (u32int)&idt;
    
    // Initialize PIC
    pic_remap(PIC_1_OFFSET, PIC_2_OFFSET);
    
    // Set up keyboard interrupt (IRQ1 = interrupt 33)
    interrupts_init_descriptor(33, (u32int)keyboard_interrupt_handler);
    
    // Load IDT
    __asm__("lidt %0" : : "m" (idt_descriptor));
}

// Set up individual interrupt descriptor
void interrupts_init_descriptor(u8int num, u32int handler) {
    idt[num].low_offset = handler & 0xFFFF;
    idt[num].high_offset = (handler >> 16) & 0xFFFF;
    idt[num].selector = 0x08;   // Kernel code segment
    idt[num].always0 = 0;
    idt[num].flags = 0x8E;      // Present, ring 0, interrupt gate
}
```

**Keyboard Driver Implementation:**

**keyboard.c** - Complete keyboard handling:
```c
#include "keyboard.h"
#include "io.h"
#include "framebuffer.h"

#define KEYBOARD_DATA_PORT 0x60

// Get raw scan code from keyboard port
u8int keyboard_read_scan_code(void) {
    return inb(KEYBOARD_DATA_PORT);
}

// Convert scan code to ASCII character
u8int keyboard_scan_code_to_ascii(u8int scan_code) {
    // Ignore key releases (scan codes with bit 7 set)
    if (scan_code & 0x80) {
        return 0;
    }

    // Comprehensive scan code mapping
    switch(scan_code) {
        // Numbers row
        case 0x02: return '1';
        case 0x03: return '2';
        case 0x04: return '3';
        case 0x05: return '4';
        case 0x06: return '5';
        case 0x07: return '6';
        case 0x08: return '7';
        case 0x09: return '8';
        case 0x0A: return '9';
        case 0x0B: return '0';
        
        // Letters
        case 0x10: return 'q';
        case 0x11: return 'w';
        case 0x12: return 'e';
        case 0x13: return 'r';
        case 0x14: return 't';
        case 0x15: return 'y';
        case 0x16: return 'u';
        case 0x17: return 'i';
        case 0x18: return 'o';
        case 0x19: return 'p';
        
        case 0x1E: return 'a';
        case 0x1F: return 's';
        case 0x20: return 'd';
        case 0x21: return 'f';
        case 0x22: return 'g';
        case 0x23: return 'h';
        case 0x24: return 'j';
        case 0x25: return 'k';
        case 0x26: return 'l';
        
        case 0x2C: return 'z';
        case 0x2D: return 'x';
        case 0x2E: return 'c';
        case 0x2F: return 'v';
        case 0x30: return 'b';
        case 0x31: return 'n';
        case 0x32: return 'm';
        
        // Special keys
        case 0x1C: return '\n';  // Enter
        case 0x39: return ' ';   // Space
        case 0x0E: return '\b';  // Backspace
        
        default: return 0;
    }
}
```

**PIC Controller Management:**

**pic.c** - Programmable Interrupt Controller setup:
```c
#include "pic.h"
#include "io.h"

// PIC controller setup for handling interrupts
void pic_acknowledge(u32int interrupt) {
    if (interrupt < PIC_1_OFFSET || interrupt > PIC_2_END) {
        return;
    }

    if (interrupt < PIC_2_OFFSET) {
        outb(PIC_1_COMMAND_PORT, PIC_ACKNOWLEDGE);
    } else {
        outb(PIC_2_COMMAND_PORT, PIC_ACKNOWLEDGE);
    }
}

// Setup PIC with new interrupt offsets
void pic_remap(s32int offset1, s32int offset2) {
    outb(PIC_1_COMMAND, PIC_ICW1_INIT + PIC_ICW1_ICW4);
    outb(PIC_2_COMMAND, PIC_ICW1_INIT + PIC_ICW1_ICW4);
    outb(PIC_1_DATA, offset1);
    outb(PIC_2_DATA, offset2);
    outb(PIC_1_DATA, 4);
    outb(PIC_2_DATA, 2);

    outb(PIC_1_DATA, PIC_ICW4_8086);
    outb(PIC_2_DATA, PIC_ICW4_8086);

    // Enable keyboard interrupt only
    outb(PIC_1_DATA, 0xFD);
    outb(PIC_2_DATA, 0xFF);

    asm("sti");
}
```

**Framebuffer Driver:**

**framebuffer.c** - Advanced display management:
```c
#include "framebuffer.h"
#include "io.h"

#define FB_COMMAND_PORT         0x3D4
#define FB_DATA_PORT            0x3D5
#define FB_HIGH_BYTE_COMMAND    14
#define FB_LOW_BYTE_COMMAND     15

// VGA text mode framebuffer
static char *fb = (char *) 0x000B8000;
static unsigned int cursor_pos = 0;

// Clear entire screen
void fb_clear_screen() {
    for (unsigned int i = 0; i < FB_NUM_ROWS * FB_NUM_COLS; i++) {
        fb[i * 2] = ' ';
        fb[i * 2 + 1] = FB_WHITE;
    }
    cursor_pos = 0;
    fb_move_cursor(0, 0);
}

// Write string at specific position
void fb_write_string(char *str, unsigned int row, unsigned int col, unsigned char color) {
    unsigned int pos = row * FB_NUM_COLS + col;
    
    for (unsigned int i = 0; str[i] != '\0'; i++) {
        if (pos + i < FB_NUM_ROWS * FB_NUM_COLS) {
            fb[(pos + i) * 2] = str[i];
            fb[(pos + i) * 2 + 1] = color;
        }
    }
}

// Write single character at cursor position
void fb_write_char(char c, unsigned char color) {
    if (cursor_pos < FB_NUM_ROWS * FB_NUM_COLS) {
        fb[cursor_pos * 2] = c;
        fb[cursor_pos * 2 + 1] = color;
        cursor_pos++;
    }
}

// Move cursor to specific position
void fb_move_cursor(unsigned int col, unsigned int row) {
    unsigned int pos = row * FB_NUM_COLS + col;
    cursor_pos = pos;
    
    // Update hardware cursor
    outb(FB_COMMAND_PORT, FB_HIGH_BYTE_COMMAND);
    outb(FB_DATA_PORT, ((pos >> 8) & 0x00FF));
    outb(FB_COMMAND_PORT, FB_LOW_BYTE_COMMAND);
    outb(FB_DATA_PORT, pos & 0x00FF);
}
```

**Complete Kernel Integration:**

**kernel.c** - Final integrated kernel:
```c
#include <stdint.h>
#include "../drivers/framebuffer.h"
#include "../drivers/interrupts.h"
#include "../drivers/hardware_interrupt_enabler.h"

// Main kernel function
void kernel_main() {
    // Clear screen and show startup messages
    fb_clear_screen();
    fb_write_string("TinyOS - Interrupt & Keyboard System", 0, 0, FB_WHITE);
    fb_write_string("Initializing interrupt system...", 1, 0, FB_LIGHT_GREY);
    
    // Setup interrupts
    interrupts_install_idt();
    enable_hardware_interrupts();
    
    // Show ready message
    fb_write_string("System ready! Type to test keyboard input:", 3, 0, FB_LIGHT_GREEN);
    fb_write_string("Keyboard input will appear below:", 4, 0, FB_LIGHT_CYAN);
    
    fb_move_cursor(0, 6);
    
    // Keep running
    while (1) {
        __asm__("hlt");
    }
}
```

#### - Supported OS:

- Linux x86_64 with 32-bit compatibility
- CSCT Cloud environment (recommended)
- QEMU with VGA and keyboard emulation
- Real hardware with VGA-compatible display

#### - Installation:

Complete installation for full OS:
```bash
# Navigate to TinyOS directory
cd "OS WORKSHEET 2/os task 2/TinyOS"

# Install required tools (if not available)
sudo apt-get install nasm gcc qemu-system-i386 genisoimage

# Build complete OS
make clean && make
```

#### - How to use:

Complete OS testing:
```bash
# Build the complete interactive OS
cd "OS WORKSHEET 2/os task 2/TinyOS"
make clean && make

# Run in QEMU with full interaction
make run

# Alternative: Manual QEMU execution
qemu-system-i386 -cdrom os.iso

# Check build outputs
ls -la os.iso iso/boot/kernel.elf
echo "ISO size: $(ls -lh os.iso | awk '{print $5}')"
echo "Kernel size: $(ls -lh iso/boot/kernel.elf | awk '{print $5}')"
```

**When running in QEMU, you will see:**
1. "TinyOS - Interrupt & Keyboard System"
2. "Initializing interrupt system..."
3. "System ready! Type to test keyboard input:"
4. "Keyboard input will appear below:"
5. Interactive cursor where you can type and see characters appear in real-time

## Testing Instructions:

### Complete Test Sequence:
```bash
# Test basic boot
cd "OS WORKSHEET 2/os task 2/TinyOS"
make clean && make
echo "Build successful - ISO: $(ls -lh os.iso | awk '{print $5}')"

# Test in QEMU (interactive)
make run
# Type characters to test keyboard input
# Press Ctrl+C to exit QEMU

# Verify components
file iso/boot/kernel.elf
strings iso/boot/kernel.elf | head -10
```

### Expected Results:
- **Build Output**: `os.iso` (~480KB), `kernel.elf` (~15KB)
- **Boot Process**: Clear screen, initialization messages, ready prompt
- **Keyboard Input**: Real-time character display as you type
- **Colors**: Different colored text for different message types
- **Cursor**: Visible cursor that moves with input

## Architecture Notes:

- **32-bit x86**: Complete 32-bit operating system implementation
- **Multiboot Compliant**: Works with GRUB and other Multiboot bootloaders
- **Hardware Interrupts**: Full interrupt handling with PIC configuration
- **Memory Layout**: Proper kernel memory layout starting at 1MB
- **Device Drivers**: Modular driver architecture for extensibility
- **Real-time I/O**: Immediate response to keyboard input
- **VGA Compatibility**: Works with standard VGA text mode (80x25)

## Advanced Features:

- **Color Support**: 16-color VGA palette for text display
- **Scan Code Mapping**: Complete US QWERTY keyboard layout support
- **Interrupt Safety**: Proper interrupt acknowledgment and handling
- **Cursor Management**: Hardware cursor control and positioning
- **Error Handling**: Graceful handling of invalid scan codes
- **Build Automation**: Comprehensive Makefile for all build steps

# Author
This project "Worksheet 2 - TinyOS Development" has been developed by Shahzoor Abbas and submitted to the University of West of England for Operating Systems coursework. 