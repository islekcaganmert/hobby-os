#!/bin/sh

rm -rf dist
if [ -d "build" ]; then
  rm -rf build
fi
mkdir dist build build/{kernel,iso}

# Compile assembly
i686-elf-as kernel/boot.asm -o build/kernel/boot.o || exit 1

# Compile C files
i686-elf-gcc -c kernel/kernel.c -o build/kernel/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra || exit 1
i686-elf-gcc -c kernel/terminal.c -o build/kernel/terminal.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra || exit 1
i686-elf-gcc -c kernel/string.c -o build/kernel/string.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra || exit 1

# Link all object files
i686-elf-gcc -T kernel/linker.ld -o build/kernel/kernel.bin -ffreestanding -O2 -nostdlib build/kernel/*.o -lgcc || exit 1

if i686-elf-grub-file --is-x86-multiboot build/kernel/kernel.bin; then
  echo multiboot confirmed
else
  echo the file is not multiboot
  exit 1
fi

mkdir build/iso/{boot,bin,etc,lib,usr}
mkdir build/iso/boot/grub
cp build/kernel/kernel.bin build/iso/boot/kernel.bin
cp bootloader/grub.cfg build/iso/boot/grub/grub.cfg
i686-elf-grub-mkrescue -o dist/os.iso build/iso

rm -rf build