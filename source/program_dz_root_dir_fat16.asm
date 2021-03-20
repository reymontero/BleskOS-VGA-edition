;BleskOS VGA

dz_fat16_root_dir_packet:
 times 1024 db 0

dz_fat16_root_dir_disk_packet:
 dw 0x0010, 2, dz_fat16_root_dir_packet, 0x1000
 dq 2

dz_fat16_file_write_disk_packet:
 dw 0x0010, 127, 0x0000, 0x6000
dz_fat16_sector_disk_packet:
 dq 0

dz_fat16_entry dw 0
dz_fat16_name_ptr dw 0
dz_fat16_ext_ptr dw 0

dz_format_fat16_draw:
 mov ax, 0x1000
 mov es, ax

 mov bp, word [dz_fat16_name_ptr]
 mov ah, 0x13
 mov al, 0
 mov bh, 0
 mov bl, 0x60
 mov cx, 8
 mov dh, 5
 mov dl, 11

 int 10h

 mov bp, word [dz_fat16_ext_ptr]
 mov ah, 0x13
 mov al, 0
 mov bh, 0
 mov bl, 0x60
 mov cx, 3
 mov dh, 7
 mov dl, 16

 int 10h

 mov bx, word [dz_fat16_entry]
 PRINT_VAR 3, 8, bx
 mov ah, 0x0E
 mov al, ' '
 int 10h

 ret

dz_root_dir_fat16:
 mov word [dz_fat16_entry], 0
 mov word [dz_fat16_name_ptr], dz_fat16_root_dir_packet
 mov word [dz_fat16_ext_ptr], dz_fat16_root_dir_packet
 add word [dz_fat16_ext_ptr], 8

 DRAW_BACKGROUND 0x60

 mov ah, 0x42
 mov dl, 0x81
 mov si, dz_fat16_root_dir_disk_packet
 int 13h

 PRINT 1, 1, str_save, '[a] Save root dir'
 PRINT 3, 1, str_entry, 'Entry:'
 PRINT 5, 1, str_name, '[b] Name:'
 PRINT 7, 1, str_extension, '[c] Extension:'
 PRINT 9, 1, str_export, '[d] Export text file'

 call dz_format_fat16_draw

 .halt:
  WAIT_FOR_KEYBOARD

  IF ah, KEY_ESC, key_esc
   jmp developer_zone
  ENDIF key_esc

  IF ah, KEY_A, key_a
   mov ah, 0x43
   mov dl, 0x81
   mov si, dz_fat16_root_dir_disk_packet
   int 13h

   jmp .halt
  ENDIF key_a

  IF ah, KEY_UP, key_up
   cmp word [dz_fat16_entry], 15
   je .halt

   inc word [dz_fat16_entry]
   add word [dz_fat16_name_ptr], 32
   add word [dz_fat16_ext_ptr], 32

   call dz_format_fat16_draw

   jmp .halt
  ENDIF key_up

  IF ah, KEY_DOWN, key_down
   cmp word [dz_fat16_entry], 0
   je .halt

   dec word [dz_fat16_entry]
   sub word [dz_fat16_name_ptr], 32
   sub word [dz_fat16_ext_ptr], 32

   call dz_format_fat16_draw

   jmp .halt
  ENDIF key_down

  IF ah, KEY_B, key_b
   mov di, word [dz_fat16_name_ptr]
   SET_CURSOR 5, 11
   SHOW_CURSOR

   mov cx, 8
   .read_input_name:
    WAIT_FOR_KEYBOARD

    mov byte [di], al
    inc di

    mov ah, 0x0E
    int 10h ;write to screen
   loop .read_input_name

   HIDE_CURSOR
   jmp .halt
  ENDIF key_b

  IF ah, KEY_C, key_c
   mov di, word [dz_fat16_ext_ptr]
   SET_CURSOR 7, 16
   SHOW_CURSOR

   mov cx, 3
   .read_input_ext:
    WAIT_FOR_KEYBOARD

    mov byte [di], al
    inc di

    mov ah, 0x0E
    int 10h ;write to screen
   loop .read_input_ext

   HIDE_CURSOR
   jmp .halt
  ENDIF key_c

  IF ah, KEY_D, key_d
   mov ax, TEXT_FILES_FOLDER
   call file_dialog_select_folder
   mov word [file_dialog_segment], 0x6000
   call file_dialog_open

   ;convert to TXT file type
   mov ax, 0x6000
   mov gs, ax
   mov di, 79 ;end of line
   mov cx, 400
   .convert_txt:
    mov byte [gs:di], 0x0A ;enter
    add di, 80 ;next line
   loop .convert_txt

   ;write file on USB
   mov ax, word [dz_fat16_entry]
   mov bx, 128
   mul bx
   add ax, 4
   mov word [dz_fat16_sector_disk_packet], ax ;sector
   mov ah, 0x43
   mov dl, 0x81
   mov si, dz_fat16_file_write_disk_packet
   int 13h

   ;write to root entry
   mov ax, word [dz_fat16_entry]
   add ax, 2 ;need for right cluster
   mov di, word [dz_fat16_name_ptr]
   add di, 20
   mov word [di], 0
   add di, 6
   mov word [di], ax
   add di, 2
   mov dword [di], 0x0000FFFF ;size

   mov di, word [dz_fat16_name_ptr]
   add di, 11
   mov byte [di], 0x01 ;read only

   mov ah, 0x43
   mov dl, 0x81
   mov si, dz_fat16_root_dir_disk_packet
   int 13h

   jmp dz_root_dir_fat16
  ENDIF key_d
 jmp .halt
