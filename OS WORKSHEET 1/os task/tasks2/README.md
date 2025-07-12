# Assembly Tasks - Worksheet 1

## Overview
This directory contains the assembly programming tasks for Worksheet 1 of the Operating Systems coursework.

## Files
- `driver.c` - Main program that calls assembly functions
- `welcome_message.asm` - Assembly function for welcome message
- `sum_array.asm` - Assembly function to sum array elements
- `range_sum.asm` - Assembly function to calculate range sum
- `makefile` - Build instructions

## Building
```bash
make clean
make program
```

## Running
```bash
./program
```

## Input Format
1. Enter your name
2. Enter number of times to print welcome message (50-100)
3. Enter starting index for range sum (1-100)
4. Enter ending index for range sum (1-100)

## Notes
- The range sum calculates the sum of numbers from start to end inclusive
- Input validation ensures values are within expected ranges
- Array sum is calculated over a predefined array of 1-100
