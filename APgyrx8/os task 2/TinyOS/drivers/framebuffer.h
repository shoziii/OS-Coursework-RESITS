#ifndef INCLUDE_FRAMEBUFFER_H
#define INCLUDE_FRAMEBUFFER_H

#include "type.h"

/* Framebuffer color constants */
#define FB_BLACK        0
#define FB_BLUE         1
#define FB_GREEN        2
#define FB_CYAN         3
#define FB_RED          4
#define FB_MAGENTA      5
#define FB_BROWN        6
#define FB_LIGHT_GREY   7
#define FB_DARK_GREY    8
#define FB_LIGHT_BLUE   9
#define FB_LIGHT_GREEN  10
#define FB_LIGHT_CYAN   11
#define FB_LIGHT_RED    12
#define FB_LIGHT_MAGENTA 13
#define FB_LIGHT_BROWN  14
#define FB_WHITE        15

/* Framebuffer dimensions */
#define FB_ROWS         25
#define FB_COLUMNS      80

/* Function prototypes */
void fb_write_cell(unsigned int i, char c, unsigned char fg_color, unsigned char bg_color);
void fb_write_string(const char* str, unsigned int row, unsigned int col, unsigned char color);
void fb_clear_screen();
void fb_move_cursor(unsigned short x, unsigned short y);
void fb_debug_address();

#endif /* INCLUDE_FRAMEBUFFER_H */ 