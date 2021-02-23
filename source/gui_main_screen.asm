;BleskOS VGA edition

main_screen:
 HIDE_CURSOR

 DRAW_BACKGROUND 0x20

 DRAW_LINE 0, 0, 80, 0x40
 DRAW_LINE 24, 0, 80, 0x40
 DRAW_COLUMN 0, 0, 25, 0x40
 DRAW_COLUMN 0, 79, 25, 0x40

 PRINT 2, 2, str_up, 'Welcome in BleskOS'

 mov ax, 0x2000
 mov gs, ax
 mov byte [gs:0], 'A'
 mov byte [gs:16], 'B'
 mov byte [gs:32], 'C'
 
 call file_dialog_save

 halt:
  WAIT_FOR_KEYBOARD
 jmp halt
