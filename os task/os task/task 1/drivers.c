#include <stdio.h>

int __attribute__((cdecl)) asm_main(void);

int main() {
    int ret_status;
    ret_status = asm_main();  // Call the asm_main function in Assembly
    return ret_status;
}
