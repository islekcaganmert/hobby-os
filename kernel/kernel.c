#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include "terminal.h"

#if !defined(__i386__)
#error "This needs to be compiled with a ix86-elf compiler"
#endif

void kernel_main(void) {
    terminal_initialize();
    terminal_writestring("islekcaganmert/hobby-os 0.1 alpha\n");
    terminal_writestring("Copyright (c) 2025 Cagan Mert ISLEK\n");
}