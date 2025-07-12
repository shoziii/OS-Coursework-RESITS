#include <stdint.h>
#include "framebuffer.h"

#define FB_ADDRESS 0x000B8000 
#define FB_ROWS 25            
#define FB_COLUMNS 80         
#define WHITE_ON_BLACK 0x0F   

volatile char* framebuffer = (volatile char*) FB_ADDRESS;

static inline void outb(unsigned short port, unsigned char data);

// Function to write a character with attribute to a specific position in the framebuffer
void fb_write_cell(unsigned int i, char c, unsigned char fg_color, unsigned char bg_color) {
    framebuffer[i * 2] = c;           // Write character
    framebuffer[i * 2 + 1] = (bg_color << 4) | (fg_color & 0x0F); // Write attribute byte (bg high 4 bits, fg low 4 bits)
}

// Function to write a string starting at a given position in the framebuffer
void fb_write_string(const char* str, unsigned int row, unsigned int col, unsigned char color) {
    // Make sure the position is within bounds
    if (row >= FB_ROWS || col >= FB_COLUMNS) {
        return; // Don't write out of bounds
    }

    unsigned int pos = row * FB_COLUMNS + col;

    // Write each character of the string to the framebuffer
    for (int i = 0; str[i] != '\0' && pos + i < FB_ROWS * FB_COLUMNS; i++) {
        fb_write_cell(pos + i, str[i], color, FB_BLACK);
    }
}

// Function to clear the screen by filling it with spaces with a given color
void fb_clear_screen() {
    // Clear the entire framebuffer by filling it with space characters
    for (unsigned int i = 0; i < FB_ROWS * FB_COLUMNS; i++) {
        fb_write_cell(i, ' ', FB_WHITE, FB_BLACK);
    }
}

// Function to move the cursor using I/O ports
void fb_move_cursor(unsigned short x, unsigned short y) {
    unsigned short pos = y * FB_COLUMNS + x;

    // I/O ports 0x3D4 and 0x3D5 are used to control the cursor
    outb(0x3D4, 0x0F); 
    outb(0x3D5, (unsigned char) (pos & 0xFF));
    outb(0x3D4, 0x0E); 
    outb(0x3D5, (unsigned char) ((pos >> 8) & 0xFF));
}

// Function to output a byte to an I/O port
static inline void outb(unsigned short port, unsigned char data) {
    __asm__ volatile ("outb %0, %1" : : "a"(data), "Nd"(port));
}

// Function to print the framebuffer address as a debug message
void fb_debug_address() {
    // Convert the framebuffer address to a string and write it to the framebuffer
    fb_write_string("Framebuffer Address Debug:", 0, 0, FB_WHITE);

    // Convert address to hex string
    char hex_str[12] = "0x00000000";
    uint32_t address = (uint32_t) framebuffer;

    for (int i = 9; i > 1; i--) {
        uint8_t hex_digit = address & 0xF;
        if (hex_digit < 10) {
            hex_str[i] = '0' + hex_digit;
        } else {
            hex_str[i] = 'A' + (hex_digit - 10);
        }
        address >>= 4;
    }

    fb_write_string(hex_str, 1, 0, FB_WHITE);
}