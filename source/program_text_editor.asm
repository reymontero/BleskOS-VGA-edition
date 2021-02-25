;BleskOS VGA edition

te_first_show_char dw 0
te_line dw 0

te_draw_text:
 mov ax, 0x3000
 mov es, ax
 mov bp, word [te_first_show_char]

 mov ah, 0x13
 mov al, 0
 mov bh, 0
 mov bl, 0x0F
 mov cx, 1840
 mov dh, 1
 mov dl, 0
 int 10h

 ret

text_editor:
 mov word [te_first_show_char], 0
 mov word [te_line], 0
 mov ax, 0x3000
 mov gs, ax
 mov di, 0
 DRAW_LINE 0, 0, 80, 0x40
 PRINT 0, 0, str_up, 'Text editor'
 DRAW_LINE 24, 0, 80, 0x40
 PRINT 24, 0, str_down, '[esc] Back [F1] Open file [F2] Save file [F3] Erase all'
 call te_draw_text
 SET_CURSOR 1, 0
 SHOW_CURSOR

 .text_editor_halt:
  WAIT_FOR_KEYBOARD

  IF ah, KEY_ESC, key_esc
   jmp main_screen
  ENDIF key_esc

  IF ah, KEY_F1, key_f1
   mov ax, TEXT_FILES_FOLDER
   call file_dialog_select_folder
   mov word [file_dialog_segment], 0x3000
   call file_dialog_open
   jmp text_editor
  ENDIF key_f1

  IF ah, KEY_F2, key_f2
   mov ax, TEXT_FILES_FOLDER
   call file_dialog_select_folder
   mov word [file_dialog_segment], 0x3000
   call file_dialog_save
   jmp text_editor
  ENDIF key_f2

  IF ah, KEY_F3, key_f3
   mov si, 0
   mov cx, 64000
   .erase_all:
    mov byte [gs:si], 0
    inc si
   loop .erase_all
   jmp text_editor
  ENDIF key_f3

  IF ah, KEY_LEFT, key_left
   GET_CURSOR
   IF dl, 0, start_of_line
    jmp .text_editor_halt
   ENDIF start_of_line
   dec di
   dec dl
   SET_CURSOR dh, dl
   jmp .text_editor_halt
  ENDIF key_left

  IF ah, KEY_RIGHT, key_right
   GET_CURSOR
   IF dl, 79, end_of_line
    jmp .text_editor_halt
   ENDIF end_of_line
   inc di
   inc dl
   SET_CURSOR dh, dl
   jmp .text_editor_halt
  ENDIF key_right

  IF ah, KEY_UP, key_up
   GET_CURSOR
   IF dh, 1, first_line
    IF word [te_line], 0, not_move_up
     jmp .text_editor_halt
    ENDIF not_move_up
    sub di, 80
    sub word [te_first_show_char], 80
    dec word [te_line]
    call te_draw_text
    jmp .text_editor_halt
   ENDIF first_line
   sub di, 80
   dec dh
   SET_CURSOR dh, dl
   jmp .text_editor_halt
  ENDIF key_up

  IF ah, KEY_DOWN, key_down
   GET_CURSOR
   IF dh, 23, last_line
    IF word [te_line], 400, not_move_down
     jmp .text_editor_halt
    ENDIF not_move_down
    add di, 80
    add word [te_first_show_char], 80
    inc word [te_line]
    call te_draw_text
    jmp .text_editor_halt
   ENDIF last_line
   add di, 80
   inc dh
   SET_CURSOR dh, dl
   jmp .text_editor_halt
  ENDIF key_down

  IF ah, KEY_BACKSPACE, key_backspace
   GET_CURSOR
   IF dl, 0, start_of_line_backspace
    jmp .text_editor_halt
   ENDIF start_of_line_backspace
   dec dl
   dec di
   SET_CURSOR dh, dl
   mov byte [gs:di], 0
   call te_draw_text
   jmp .text_editor_halt
  ENDIF key_backspace

  IF ah, KEY_DELETE, key_delete
   mov byte [gs:di], 0
   call te_draw_text
   jmp .text_editor_halt
  ENDIF key_delete

  IF ah, KEY_ENTER, key_enter
   GET_CURSOR
   IF dh, 23, end_of_screen
    jmp .text_editor_halt
   ENDIF end_of_screen
   push dx
   mov dh, 0
   sub di, dx
   add di, 80
   pop dx
   mov dl, 0
   inc dh
   SET_CURSOR dh, dl

   mov bx, 64000
   mov si, 64000-80
   mov cx, 64000-79
   sub cx, di
   .move_chars:
    mov al, byte [gs:si]
    mov byte [gs:bx], al
    dec bx
    dec si
   loop .move_chars

   mov si, di
   mov cx, 80
   .delete_line:
    mov byte [gs:si], 0
    inc si
   loop .delete_line

   call te_draw_text
   jmp .text_editor_halt
  ENDIF key_enter

  GET_CURSOR
  cmp dx, 0x1853 ;end of screen
  je .text_editor_halt
  mov byte [gs:di], al ;write char to memory
  mov ah, 0x0E
  int 10h ;print to screen
  inc di
  jmp .text_editor_halt
