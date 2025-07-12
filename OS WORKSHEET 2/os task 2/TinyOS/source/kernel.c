// kernel.c
#include <stdint.h>
#include "../drivers/framebuffer.h"
#include "../drivers/interrupts.h"
#include "../drivers/hardware_interrupt_enabler.h"

// Entry point for C code called from loader.asm
void kernel_main() {
    // Initialize framebuffer
    fb_clear_screen();
    fb_write_string("TinyOS - Interrupt & Keyboard System", 0, 0, FB_WHITE);
    fb_write_string("Initializing interrupt system...", 1, 0, FB_LIGHT_GREY);
    
    // Install the Interrupt Descriptor Table
    interrupts_install_idt();
    
    // Enable hardware interrupts
    enable_hardware_interrupts();
    
    // Display ready message
    fb_write_string("System ready! Type to test keyboard input:", 3, 0, FB_LIGHT_GREEN);
    fb_write_string("Keyboard input will appear below:", 4, 0, FB_LIGHT_CYAN);
    
    // Move cursor to line 6 for user input
    fb_move_cursor(0, 6);
    
    // Keep the kernel running - interrupts will handle keyboard input
    while (1) {
        // Halt CPU until next interrupt
        __asm__("hlt");
    }
}
