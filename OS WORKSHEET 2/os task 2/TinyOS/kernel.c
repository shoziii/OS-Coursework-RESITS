#include <stdint.h>
#include "../drivers/framebuffer.c" 
// Function prototype for sum_of_three
int sum_of_three(int a, int b, int c);

// Function prototype for custom functions
int multiply(int a, int b);
int max_of_two(int a, int b);

// Function prototype for integer to string conversion
void int_to_string(int num, char* str);

// Entry point for C code called from loader.asm
void kernel_main() {
    // Clear the framebuffer to start with a clean screen
    fb_clear_screen();

    // Debug: Print framebuffer address to confirm proper access
    fb_debug_address();

    // Display a welcome message
    fb_write_string("TinyOS Kernel is running!", 3, 0, WHITE_ON_BLACK);

    // Debug: Output at different positions to ensure visibility
    fb_write_string("Debug Message 1: Check framebuffer", 5, 0, WHITE_ON_BLACK);
    fb_write_string("Debug Message 2: Writing numbers", 6, 0, WHITE_ON_BLACK);

    // Calculate the sum of three numbers
    int result1 = sum_of_three(3, 5, 7);
    char result1_str[12]; 
    int_to_string(result1, result1_str);
    fb_write_string("Sum of 3, 5, 7 is: ", 8, 0, WHITE_ON_BLACK);
    fb_write_string(result1_str, 8, 20, WHITE_ON_BLACK);

    // Example of using custom functions
    int result2 = multiply(4, 5);
    char result2_str[12]; 
    int_to_string(result2, result2_str);
    fb_write_string("Product of 4 and 5 is: ", 10, 0, WHITE_ON_BLACK);
    fb_write_string(result2_str, 10, 22, WHITE_ON_BLACK);

    int result3 = max_of_two(10, 15);
    char result3_str[12]; 
    int_to_string(result3, result3_str);
    fb_write_string("Max of 10 and 15 is: ", 12, 0, WHITE_ON_BLACK);
    fb_write_string(result3_str, 12, 21, WHITE_ON_BLACK);

    // Final debug message
    fb_write_string("Final Debug: Kernel main completed!", 14, 0, WHITE_ON_BLACK);

    // Halt the kernel to keep the output on the screen
    while (1) {
        __asm__("hlt");
    }
}

// Function to calculate the sum of three integers
int sum_of_three(int a, int b, int c) {
    return a + b + c;
}

// Function to multiply two integers
int multiply(int a, int b) {
    return a * b;
}

// Function to find the maximum of two integers
int max_of_two(int a, int b) {
    return (a > b) ? a : b;
}

// Function to convert an integer to a string
void int_to_string(int num, char* str) {
    int i = 0;
    int is_negative = 0;

    // Handle negative numbers
    if (num < 0) {
        is_negative = 1;
        num = -num;
    }

    // Convert number to string (reversed order)
    do {
        str[i++] = (num % 10) + '0';
        num /= 10;
    } while (num > 0);

    // Add negative sign if necessary
    if (is_negative) {
        str[i++] = '-';
    }

    // Null-terminate the string
    str[i] = '\0';

    // Reverse the string
    int start = 0;
    int end = i - 1;
    while (start < end) {
        char temp = str[start];
        str[start] = str[end];
        str[end] = temp;
        start++;
        end--;
    }
}