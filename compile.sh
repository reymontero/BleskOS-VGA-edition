#!/bin/bash

mkdir images

nasm -f bin source/bootloader.asm -o images/bootloader.bin
nasm -f bin source/bleskos.asm -o images/bleskos.bin

dd if=/dev/zero of=images/bleskos.hdd bs=1024 count=10000
dd if=images/bootloader.bin of=images/bleskos.hdd conv=notrunc seek=0
dd if=images/bleskos.bin of=images/bleskos.hdd conv=notrunc seek=1

qemu-system-i386 -soundhw pcspk -hda images/bleskos.hdd

sleep 60
