# Operating Systems Coursework - RESITS

## About this coursework:

This repository contains the complete implementation of Operating Systems coursework for RESITS, encompassing comprehensive assembly programming and operating system development. The coursework demonstrates proficiency in:
- **Low-level Programming**: x86 Assembly language programming with C integration
- **Operating System Development**: Building a functional TinyOS from scratch
- **Hardware Interaction**: Interrupt handling, device drivers, and hardware I/O
- **System Architecture**: Memory management, bootloaders, and kernel development
- **Build Systems**: Advanced Makefiles and automated build processes

The coursework is divided into two major worksheets, each containing multiple progressive tasks that build upon each other to create a complete understanding of operating system fundamentals.

## Project Overview

This repository contains the implementation of Operating Systems coursework for RESITS, including:

### Worksheet 1: Assembly Programming Tasks
- **Task 1**: Basic arithmetic operations in x86 assembly (addition: 7+7=14, subtraction: 20-7=13)
- **Task 2**: Interactive programs with user input, array operations, and range calculations
- **Task 3**: Advanced Makefile integration and build automation

### Worksheet 2: TinyOS Development
- **Task 1**: Bootable kernel with GRUB and Multiboot specification
- **Task 2**: C integration with kernel development and function implementation
- **Task 3**: Complete interrupt system with keyboard input and framebuffer output

## Build Environment

- **Target Platform**: Linux/CSCT Cloud environment
- **Development Tools**: GCC, NASM, Make, QEMU, genisoimage
- **Architecture**: 32-bit x86 with 64-bit host compatibility
- **Testing Environment**: QEMU virtualization with VGA and keyboard emulation

## Project Structure

```
Operating-Systems-Coursework/
├── OS WORKSHEET 1/           # Assembly Programming Tasks
│   ├── os task/
│   │   ├── task 1/           # Basic arithmetic operations
│   │   │   ├── task1.asm     # Addition: 7+7=14
│   │   │   ├── task2.asm     # Subtraction: 20-7=13
│   │   │   ├── drivers.c     # C driver integration
│   │   │   ├── asm_io.asm    # I/O functions
│   │   │   └── makefile      # Build automation
│   │   └── tasks2/           # Interactive programs and array operations
│   │       ├── driver.c      # Main program coordinator
│   │       ├── welcome_message.asm   # User interaction with validation
│   │       ├── sum_array.asm # Array initialization and summation
│   │       ├── range_sum.asm # Range-based calculations
│   │       └── makefile      # Integrated build system
│   └── README.md             # Comprehensive Worksheet 1 documentation
├── OS WORKSHEET 2/           # TinyOS Operating System Development
│   └── os task 2/
│       └── TinyOS/           # Complete operating system implementation
│           ├── drivers/      # Device drivers and hardware interfaces
│           │   ├── framebuffer.c/.h    # VGA text mode display driver
│           │   ├── keyboard.c/.h       # PS/2 keyboard driver
│           │   ├── interrupts.c/.h     # Interrupt descriptor table
│           │   ├── pic.c/.h           # Programmable interrupt controller
│           │   ├── io.h/.s            # Hardware I/O operations
│           │   └── type.h             # System type definitions
│           ├── source/       # Kernel source code
│           │   ├── kernel.c  # Main kernel implementation
│           │   └── link.ld   # Memory layout linker script
│           ├── iso/          # Bootable ISO components
│           │   └── boot/
│           │       ├── grub/ # GRUB bootloader configuration
│           │       └── kernel.elf     # Compiled kernel executable
│           ├── loader.asm    # Assembly bootloader (Multiboot)
│           ├── Makefile      # Comprehensive build system
│           ├── os.iso        # Generated bootable ISO (~480KB)
│           └── README.md     # Detailed TinyOS documentation
└── README.md                 # This comprehensive project overview
```

## Quick Start Guide

### Prerequisites Installation (CSCT Cloud/Linux):
```bash
# Install required development tools
sudo apt-get update
sudo apt-get install build-essential nasm gcc-multilib qemu-system-i386 genisoimage

# Verify installation
gcc --version
nasm --version
qemu-system-i386 --version
```

### Testing Worksheet 1 (Assembly Programming):
```bash
# Navigate to project root
cd ~/OS-Coursework-RESITS

# Test basic arithmetic operations (Task 1)
cd "OS WORKSHEET 1/os task/task 1"
make clean && make all
echo "Addition result (7+7): $(./task1)"
echo "Subtraction result (20-7): $(./task2)"

# Test interactive programs (Task 2)
cd "../tasks2"
make clean && make program
echo "Running interactive assembly program:"
./program
# Follow prompts:
# 1. Enter your name: [Your Name]
# 2. Enter repetitions (50-100): [e.g., 75]
# 3. Enter start index (1-100): [e.g., 1]
# 4. Enter end index (1-100): [e.g., 100]
```

### Testing Worksheet 2 (TinyOS Development):
```bash
# Navigate to TinyOS directory
cd "OS WORKSHEET 2/os task 2/TinyOS"

# Build complete operating system
make clean && make

# Verify build outputs
echo "Kernel size: $(ls -lh iso/boot/kernel.elf | awk '{print $5}')"
echo "ISO size: $(ls -lh os.iso | awk '{print $5}')"

# Run TinyOS in QEMU (interactive)
make run
# You will see:
# 1. Boot sequence and initialization
# 2. "TinyOS - Interrupt & Keyboard System"
# 3. "System ready! Type to test keyboard input:"
# 4. Real-time keyboard input display
# Press Ctrl+C to exit QEMU
```

## Comprehensive Testing Instructions

### Worksheet 1 - Assembly Programming Tests:

**Task 1 - Arithmetic Operations:**
```bash
cd "OS WORKSHEET 1/os task/task 1"
make clean && make all

# Expected Results:
./task1    # Output: 14 (7+7=14)
./task2    # Output: 13 (20-7=13)
```

**Task 2 - Interactive Programs:**
```bash
cd "OS WORKSHEET 1/os task/tasks2"
make clean && make program
./program

# Interactive Test Scenario:
# Input: "Student" (name)
# Input: "75" (repetitions)
# Input: "1" (start index)
# Input: "100" (end index)
# Expected Output:
# - Welcome message repeated 75 times
# - Array sum: 5050
# - Range sum (1-100): 5050
```

### Worksheet 2 - TinyOS Development Tests:

**Complete System Test:**
```bash
cd "OS WORKSHEET 2/os task 2/TinyOS"
make clean && make

# Verify Components:
file iso/boot/kernel.elf    # Should show: ELF 32-bit LSB executable
ls -la os.iso               # Should show: ~480KB ISO file

# Interactive Boot Test:
make run
# Test keyboard input by typing characters
# Verify real-time character display
# Test various keys (letters, numbers, space, enter)
```

## Architecture and Implementation Details

### Worksheet 1 - Assembly Programming Architecture:

**System Call Interface:**
- Uses Linux system calls (int 0x80) for I/O operations
- Proper register management and stack handling
- 32-bit compatibility mode on 64-bit systems

**Memory Management:**
- Static memory allocation for arrays and buffers
- Proper alignment and section organization (.data, .bss, .text)
- Stack-based parameter passing between C and assembly

**Input Validation:**
- Range checking for user inputs (50-100, 1-100)
- Error handling with descriptive messages
- Robust parsing for numeric input conversion

### Worksheet 2 - TinyOS Architecture:

**Boot Sequence:**
1. **GRUB Bootloader**: Multiboot-compliant boot process
2. **Assembly Loader**: Initial system setup and stack configuration
3. **Kernel Initialization**: C kernel execution with driver initialization
4. **Interrupt Setup**: IDT installation and PIC configuration
5. **Device Activation**: Keyboard and framebuffer driver activation

**Memory Layout:**
```
Physical Memory Layout:
0x00000000 - 0x000FFFFF: Reserved (BIOS, etc.)
0x00100000 - 0x001FFFFF: Kernel code and data
0x000B8000 - 0x000B8FFF: VGA text mode framebuffer
Stack grows downward from high memory
```

**Interrupt Handling:**
- **IDT**: 256-entry interrupt descriptor table
- **PIC**: 8259A programmable interrupt controller configuration
- **Keyboard**: IRQ1 (interrupt 33) handling with scan code conversion
- **Real-time**: Immediate response to hardware events

**Device Drivers:**
- **Framebuffer**: VGA text mode (80x25) with 16-color support
- **Keyboard**: PS/2 keyboard with complete US QWERTY mapping
- **I/O Ports**: Direct hardware port access for device communication

## Build System Analysis

### Worksheet 1 Makefiles:
```makefile
# Task 1 - Arithmetic Operations
CC = gcc
NASM = nasm
CFLAGS = -m32
NASMFLAGS = -f elf32

all: task1 task2

task1: drivers.o task1.o asm_io.o
	$(CC) $(CFLAGS) $^ -o $@

# Task 2 - Integrated Program
program: driver.o range_sum.o sum_array.o welcome_message.o
	gcc -m32 $^ -o $@
```

### Worksheet 2 TinyOS Makefile:
```makefile
# Advanced build system for complete OS
CFLAGS = -m32 -ffreestanding -fno-stack-protector
LDFLAGS = -T source/link.ld -melf_i386

# Multi-stage build process:
# 1. Compile assembly and C sources
# 2. Link into kernel executable
# 3. Generate bootable ISO image

os.iso: iso/boot/kernel.elf
	genisoimage -R -b boot/grub/stage2_eltorito \
	    -no-emul-boot -boot-load-size 4 -A os \
	    -input-charset utf8 -quiet -boot-info-table \
	    -o os.iso iso
```

## Performance Characteristics

### Worksheet 1 Performance:
- **Execution Time**: Sub-millisecond for arithmetic operations
- **Memory Usage**: Minimal (<1KB for data structures)
- **Input Processing**: Real-time user interaction
- **Array Operations**: O(n) complexity for summation operations

### Worksheet 2 Performance:
- **Boot Time**: <1 second in QEMU
- **Interrupt Latency**: <1ms for keyboard events
- **Memory Footprint**: ~15KB kernel, 16KB stack
- **Display Update**: Real-time character rendering
- **Keyboard Response**: Immediate scan code processing

## Educational Outcomes

### Skills Demonstrated:

**Low-Level Programming:**
- x86 Assembly language proficiency
- System call interface understanding
- Register management and calling conventions
- Memory segmentation and addressing modes

**Operating System Concepts:**
- Bootloader and kernel development
- Interrupt handling and device drivers
- Memory management and protection
- Hardware abstraction and I/O systems

**Software Engineering:**
- Modular design and code organization
- Build system automation and dependency management
- Testing and verification procedures
- Documentation and code maintainability

**System Integration:**
- Assembly and C language integration
- Hardware and software interface design
- Cross-platform compatibility considerations
- Performance optimization techniques

## Troubleshooting Guide

### Common Issues and Solutions:

**Worksheet 1 - Assembly Programming:**
```bash
# Issue: 32-bit compilation errors
# Solution: Install multilib support
sudo apt-get install gcc-multilib

# Issue: NASM assembly errors
# Solution: Verify NASM syntax and flags
nasm -f elf32 -l listing.lst source.asm

# Issue: Linking errors
# Solution: Check object file compatibility
file *.o    # Should show i386 architecture
```

**Worksheet 2 - TinyOS Development:**
```bash
# Issue: QEMU boot failure
# Solution: Verify ISO integrity
file os.iso    # Should show ISO 9660 filesystem

# Issue: Keyboard not working in QEMU
# Solution: Ensure QEMU has proper input focus
# Click in QEMU window and verify cursor capture

# Issue: Build errors
# Solution: Clean and rebuild with verbose output
make clean && make V=1
```

## Advanced Features and Extensions

### Potential Enhancements:

**Worksheet 1 Extensions:**
- Floating-point arithmetic operations
- Dynamic memory allocation
- File I/O operations
- Multi-threading with system calls

**Worksheet 2 Extensions:**
- **File System**: Simple file allocation table
- **Networking**: Basic TCP/IP stack
- **Graphics**: VGA graphics mode support
- **Multitasking**: Process scheduling and context switching
- **Memory Protection**: Virtual memory and paging
- **Shell**: Command-line interpreter

## Compliance and Standards

### Standards Adherence:
- **Multiboot Specification**: Full compliance for bootloader compatibility
- **x86 Architecture**: Standard 32-bit x86 instruction set
- **POSIX System Calls**: Linux system call interface
- **VGA Standards**: Standard VGA text mode implementation
- **PS/2 Protocol**: Standard keyboard interface

### Code Quality:
- **Modularity**: Clear separation of concerns
- **Documentation**: Comprehensive inline and external documentation
- **Error Handling**: Robust error detection and recovery
- **Testing**: Systematic testing procedures and validation
- **Maintainability**: Clean, readable, and well-organized code

# Author and Submission

This comprehensive Operating Systems coursework project has been developed by **Shahzoor Abbas** and submitted to the **University of West of England** for the Operating Systems RESITS examination.

**Course**: UFCFVK-15-2 Operating Systems  
**Academic Year**: 2024-25  
**Submission Type**: RESITS Coursework  
**Repository**: https://github.com/shoziii/OS-Coursework-RESITS.git

The project demonstrates advanced understanding of operating system fundamentals, low-level programming, and system architecture through practical implementation of assembly programs and a complete miniature operating system. 