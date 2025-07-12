# Operating Systems Coursework - RESITS

## 📚 Project Overview
This repository contains the implementation of Operating Systems coursework for RESITS, including:

- **Worksheet 1**: Assembly programming tasks (echo of assembler)
- **Worksheet 2 Part 1**: TinyOS bootloader and basic kernel
- **Worksheet 2 Part 2**: Interrupt system and keyboard handling

## 🔧 Build Environment
- **Target**: Linux/CSCT Cloud environment
- **Tools**: GCC, NASM, Make, QEMU
- **Architecture**: 32-bit x86

## 📁 Project Structure
```
OS/
├── os task/os task/           # Worksheet 1 - Assembly Tasks
│   ├── task 1/               # Basic arithmetic operations
│   └── tasks2/               # Array operations and user input
├── APgyrx8/os task 2/TinyOS/ # Worksheet 2 - TinyOS Implementation
│   ├── drivers/              # Interrupt, PIC, keyboard, framebuffer drivers
│   ├── source/               # Kernel source code
│   └── iso/                  # Bootable ISO components
└── Files and everything else/ # Original driver files and documentation
```

## 🧪 Testing Instructions

### Worksheet 1 (Assembly)
```bash
cd "os task/os task/task 1"
make clean && make all
make run-task1  # Test task 1
make run-task2  # Test task 2

cd "../tasks2"
make clean && make program
make run        # Test integrated program
```

### Worksheet 2 (TinyOS)
```bash
cd "APgyrx8/os task 2/TinyOS"
make clean && make all
make run        # Boot in QEMU (if available)
```

## ✅ Implemented Features

### Worksheet 1
- ✅ Fixed makefile auto-execution issues
- ✅ Corrected input validation in range_sum.asm
- ✅ Integrated driver.c with assembly functions

### Worksheet 2
- ✅ Complete interrupt descriptor table (IDT)
- ✅ PIC controller setup and configuration
- ✅ Keyboard input handling with scan code mapping
- ✅ Assembly interrupt handlers
- ✅ Enhanced framebuffer system with color support
- ✅ Proper kernel initialization sequence

## 📝 Status
Ready for testing in CSCT Cloud Linux environment.

---
**Course**: UFCFVK-15-2 Operating Systems  
**Student**: Shahzoor Abbas  
**Academic Year**: 2024-25 