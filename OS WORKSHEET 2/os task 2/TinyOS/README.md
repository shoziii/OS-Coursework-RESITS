# TinyOS - Worksheet 2

## Overview
This directory contains the TinyOS implementation for Worksheet 2 of the Operating Systems coursework.

## Components
- `source/` - Kernel source code
- `drivers/` - Device drivers (framebuffer, keyboard, PIC, interrupts)
- `iso/` - Bootable ISO components
- `Makefile` - Build instructions

## Building
```bash
make clean
make
```

## Running
```bash
make run    # If QEMU is available
```

## Features
- Interrupt descriptor table (IDT) setup
- PIC controller configuration
- Keyboard input handling
- Framebuffer output with colors
- Assembly interrupt handlers
- Bootable ISO generation

## Files Generated
- `kernel.elf` - Kernel executable
- `os.iso` - Bootable ISO image
