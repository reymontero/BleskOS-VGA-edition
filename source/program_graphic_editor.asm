;BleskOS VGA edition

%define PEN_UP 0
%define PEN_DOWN 1

pen_position dw 0
pen_color db 0

ge_draw_background:
 mov ax, 0x4000
 mov gs, ax
 mov ax, 0xB800
 mov fs, ax
 mov si, 0
 mov bx, 160
 mov cx, 1840
 .draw_background:
 push cx
  mov al, byte [gs:si]
  mov byte [fs:bx], ' '
  inc bx
  mov byte [fs:bx], al
  inc bx
  inc si
 pop cx
 loop .draw_background

 SET_CURSOR 1, 0

 ret

graphic_editor:
 mov ax, 0x4000
 mov gs, ax
 mov byte [pen_color], 0xF0
 mov word [pen_position], PEN_UP
 mov di, 0

 DRAW_LINE 0, 0, 80, 0x30
 PRINT 0, 0, str_up, 'Graphic editor'
 PRINT 0, 60, str_up_tools, 'Pen is up   Color:'
 DRAW_PIXEL 0, 79, 0x0F
 DRAW_LINE 24, 0, 80, 0x30
 PRINT 24, 0, str_down, '[F1] Open [F2] Save [F3] Clear screen [space] Pen down'
 DRAW_LINE 24, 71, 1, 0x0F
 DRAW_LINE 24, 72, 1, 0x1F
 DRAW_LINE 24, 73, 1, 0x20
 DRAW_LINE 24, 74, 1, 0x30
 DRAW_LINE 24, 75, 1, 0x40
 DRAW_LINE 24, 76, 1, 0x50
 DRAW_LINE 24, 77, 1, 0x60
 DRAW_LINE 24, 78, 1, 0xF0
 PRINT 24, 71, str_colors, 'ABCDEFGH'

 call ge_draw_background

 SHOW_CURSOR

 .graphic_editor_halt:
  WAIT_FOR_KEYBOARD

  IF ah, KEY_ESC, if_esc
   jmp main_screen
  ENDIF if_esc

  IF ah, KEY_F1, key_f1
   mov ax, GRAPHIC_FILES_FOLDER
   call file_dialog_select_folder
   mov word [file_dialog_segment], 0x4000
   call file_dialog_open
   jmp graphic_editor
  ENDIF key_f1

  IF ah, KEY_F2, key_f2
   mov ax, GRAPHIC_FILES_FOLDER
   call file_dialog_select_folder
   mov word [file_dialog_segment], 0x4000
   call file_dialog_save
   jmp graphic_editor
  ENDIF key_f2

  IF ah, KEY_F3, if_f3
   mov si, 0
   mov cx, 64000
   .clear_screen:
    mov byte [gs:si], 0xF0
    inc si
   loop .clear_screen
   call ge_draw_background
   jmp .graphic_editor_halt
  ENDIF if_f3

  IF ah, KEY_LEFT, if_left
   GET_CURSOR
   IF dl, 0, start_of_line
    jmp .graphic_editor_halt
   ENDIF start_of_line
   dec dl
   SET_CURSOR dh, dl
   dec di

   IF word [pen_position], PEN_UP, left_if_key_up
    jmp .graphic_editor_halt
   ENDIF left_if_key_up

   mov al, byte [pen_color]
   mov byte [gs:di], al ;draw pixel to memory

   mov ah, 0x09
   mov al, ' '
   mov bh, 0
   mov bl, byte [pen_color]
   mov cx, 1
   int 10h ;draw pixel on screen

   jmp .graphic_editor_halt
  ENDIF if_left

  IF ah, KEY_RIGHT, if_right
   GET_CURSOR
   IF dl, 79, end_of_line
    jmp .graphic_editor_halt
   ENDIF end_of_line
   inc dl
   SET_CURSOR dh, dl
   inc di

   IF word [pen_position], PEN_UP, right_if_key_up
    jmp .graphic_editor_halt
   ENDIF right_if_key_up

   mov al, byte [pen_color]
   mov byte [gs:di], al ;draw pixel to memory

   mov ah, 0x09
   mov al, ' '
   mov bh, 0
   mov bl, byte [pen_color]
   mov cx, 1
   int 10h ;draw pixel on screen

   jmp .graphic_editor_halt
  ENDIF if_right

  IF ah, KEY_UP, if_up
   GET_CURSOR
   IF dh, 1, start_of_screen
    jmp .graphic_editor_halt
   ENDIF start_of_screen
   dec dh
   SET_CURSOR dh, dl
   sub di, 80

   IF word [pen_position], PEN_UP, up_if_key_up
    jmp .graphic_editor_halt
   ENDIF up_if_key_up

   mov al, byte [pen_color]
   mov byte [gs:di], al ;draw pixel to memory

   mov ah, 0x09
   mov al, ' '
   mov bh, 0
   mov bl, byte [pen_color]
   mov cx, 1
   int 10h ;draw pixel on screen

   jmp .graphic_editor_halt
  ENDIF if_up

  IF ah, KEY_DOWN, if_down
   GET_CURSOR
   IF dh, 23, end_of_screen
    jmp .graphic_editor_halt
   ENDIF end_of_screen
   inc dh
   SET_CURSOR dh, dl
   add di, 80

   IF word [pen_position], PEN_UP, down_if_key_up
    jmp .graphic_editor_halt
   ENDIF down_if_key_up

   mov al, byte [pen_color]
   mov byte [gs:di], al ;draw pixel to memory

   mov ah, 0x09
   mov al, ' '
   mov bh, 0
   mov bl, byte [pen_color]
   mov cx, 1
   int 10h ;draw pixel on screen

   jmp .graphic_editor_halt
  ENDIF if_down

  IF al, ' ', key_space
   GET_CURSOR
   push dx
   IF word [pen_position], PEN_UP, if_pen_up
    mov word [pen_position], PEN_DOWN
    PRINT 0, 67, str_pen_is_down, 'down'
    PRINT 24, 50, str_pen_up, 'up  '
    pop dx
    SET_CURSOR dh, dl
    jmp .graphic_editor_halt
   ENDIF if_pen_up
    mov word [pen_position], PEN_UP
    PRINT 0, 67, str_pen_is_up, 'up  '
    PRINT 24, 50, str_pen_down, 'down'
    pop dx
    SET_CURSOR dh, dl
    jmp .graphic_editor_halt
  ENDIF key_space

  IF al, 'a', key_a
   mov byte [pen_color], 0x0F
   GET_CURSOR
   push dx
   DRAW_PIXEL 0, 79, 0x0F
   pop dx
   SET_CURSOR dh, dl
   jmp .graphic_editor_halt
  ENDIF key_a

  IF al, 'b', key_b
   mov byte [pen_color], 0x1F
   GET_CURSOR
   push dx
   DRAW_PIXEL 0, 79, 0x1F
   pop dx
   SET_CURSOR dh, dl
   jmp .graphic_editor_halt
  ENDIF key_b

  IF al, 'c', key_c
   mov byte [pen_color], 0x20
   GET_CURSOR
   push dx
   DRAW_PIXEL 0, 79, 0x20
   pop dx
   SET_CURSOR dh, dl
   jmp .graphic_editor_halt
  ENDIF key_c

  IF al, 'd', key_d
   mov byte [pen_color], 0x30
   GET_CURSOR
   push dx
   DRAW_PIXEL 0, 79, 0x30
   pop dx
   SET_CURSOR dh, dl
   jmp .graphic_editor_halt
  ENDIF key_d

  IF al, 'e', key_e
   mov byte [pen_color], 0x40
   GET_CURSOR
   push dx
   DRAW_PIXEL 0, 79, 0x40
   pop dx
   SET_CURSOR dh, dl
   jmp .graphic_editor_halt
  ENDIF key_e

  IF al, 'f', key_f
   mov byte [pen_color], 0x50
   GET_CURSOR
   push dx
   DRAW_PIXEL 0, 79, 0x50
   pop dx
   SET_CURSOR dh, dl
   jmp .graphic_editor_halt
  ENDIF key_f

  IF al, 'g', key_g
   mov byte [pen_color], 0x60
   GET_CURSOR
   push dx
   DRAW_PIXEL 0, 79, 0x60
   pop dx
   SET_CURSOR dh, dl
   jmp .graphic_editor_halt
  ENDIF key_g

  IF al, 'h', key_h
   mov byte [pen_color], 0xF0
   GET_CURSOR
   push dx
   DRAW_PIXEL 0, 79, 0xF0
   pop dx
   SET_CURSOR dh, dl
   jmp .graphic_editor_halt
  ENDIF key_h
 jmp .graphic_editor_halt
