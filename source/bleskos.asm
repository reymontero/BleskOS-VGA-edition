;BleskOS VGA edition

org 0x10000

bits 16

start:
 mov ax, 0x1000
 mov ds, ax

 mov byte [start_drive], dl
 mov byte [drive], dl

 call init_vga

 call init_mouse

 mov ax, 0
 call file_dialog_select_folder

 jmp main_screen

%include "source/macros.asm"
%include "source/driver_vga.asm"
%include "source/driver_pc_speaker.asm"
%include "source/driver_keyboard.asm"
%include "source/driver_mouse.asm"
%include "source/driver_filesystem.asm"
%include "source/gui_file_dialog.asm"
%include "source/gui_main_screen.asm"
%include "source/program_text_editor.asm"
%include "source/program_graphic_editor.asm"
%include "source/program_sound_editor.asm"
%include "source/program_dz_vga.asm"
%include "source/program_dz_pc_speaker.asm"
%include "source/program_dz_drives.asm"
