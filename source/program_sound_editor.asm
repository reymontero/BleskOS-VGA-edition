;BleskOS

se_play_tone:
 IF al, 'C', if_C
  mov ax, 4000
  call play_freq
  ret
 ENDIF if_C

 IF al, 'D', if_D
  mov ax, 3600
  call play_freq
  ret
 ENDIF if_D

 IF al, 'E', if_E
  mov ax, 3200
  call play_freq
  ret
 ENDIF if_E

 IF al, 'F', if_F
  mov ax, 3000
  call play_freq
  ret
 ENDIF if_F

 IF al, 'G', if_G
  mov ax, 2700
  call play_freq
  ret
 ENDIF if_G

 IF al, 'A', if_A
  mov ax, 2400
  call play_freq
  ret
 ENDIF if_A

 IF al, 'H', if_H
  mov ax, 2150
  call play_freq
  ret
 ENDIF if_H

 IF al, 'c', if_c
  mov ax, 2025
  call play_freq
  ret
 ENDIF if_c

 call stop_freq

 ret

se_draw_pattern:
 mov ax, 0x5000
 mov es, ax
 mov bp, 0

 mov ah, 0x13
 mov al, 0
 mov bh, 0
 mov bl, 0x80
 mov cx, 160
 mov dh, 2
 mov dl, 0
 int 10h

 ret

sound_editor:
 DRAW_BACKGROUND 0x70

 DRAW_LINE 0, 0, 80, 0xE0
 DRAW_LINE 24, 0, 80, 0xE0
 PRINT 0, 0, str_up, 'Sound editor'
 PRINT 5, 1, str_1, 'Use C D E F G A H c as tones and arrows up and down to length of tones'
 PRINT 24, 0, str_down, '[F1] Open [F2] Save [F3] New pattern [F4] Play pattern [q] Hold for stop'

 call se_draw_pattern

 SET_CURSOR 2, 0
 SHOW_CURSOR

 mov ax, 0x5000
 mov gs, ax
 mov di, 0
 mov si, 80

 .halt:
  WAIT_FOR_KEYBOARD

  IF ah, KEY_ESC, key_esc
   jmp main_screen
  ENDIF key_esc

  IF ah, KEY_F1, key_f1
   mov ax, SOUND_FILES_FOLDER
   call file_dialog_select_folder
   mov word [file_dialog_segment], 0x5000
   call file_dialog_open
   jmp sound_editor
  ENDIF key_f1

  IF ah, KEY_F2, key_f2
   mov ax, SOUND_FILES_FOLDER
   call file_dialog_select_folder
   mov word [file_dialog_segment], 0x5000
   call file_dialog_save
   jmp sound_editor
  ENDIF key_f2

  IF ah, KEY_F3, key_f3
   mov si, 0

   mov cx, 80
   .clear_tones:
    mov byte [gs:si], 0
    inc si
   loop .clear_tones

   mov cx, 80
   .clear_length:
    mov byte [gs:si], '1'
    inc si
   loop .clear_length

   call se_draw_pattern

   mov di, 0
   mov si, 80

   jmp .halt
  ENDIF key_f3

  IF al, 'q', key_q
   call stop_freq
   jmp .halt
  ENDIF key_q

  IF ah, KEY_F4, key_f4
   push di
   push si

   mov di, 0
   mov si, 80

   mov cx, 80
   .play_pattern:
   push cx
    READ_FROM_KEYBOARD
    IF al, 'q', if_quiet
     pop cx
     jmp .stop_playing
    ENDIF if_quiet

    mov al, byte [gs:di]
    call se_play_tone

    mov ah, 0x86
    mov al, 0
    mov dl, byte [gs:si]
    IF dl, '1', if_length_1
     mov cx, 0x4
     mov dx, 0
     int 15h ;wait
     call stop_freq
    ENDIF if_length_1

    IF dl, '2', if_length_2
     mov cx, 0x8
     mov dx, 0
     int 15h ;wait
     call stop_freq
    ENDIF if_length_2

    IF dl, '4', if_length_4
     mov cx, 0x10
     mov dx, 0
     int 15h ;wait
     call stop_freq
    ENDIF if_length_4

    IF dl, '8', if_length_8
     mov cx, 0x20
     mov dx, 0
     int 15h ;wait
     call stop_freq
    ENDIF if_length_8

    inc di
    inc si
   pop cx
   loop .play_pattern

   .stop_playing:
   pop si
   pop di
   call stop_freq
  ENDIF key_f4

  IF ah, KEY_LEFT, key_left
   GET_CURSOR
   IF dl, 0, if_start_screen
    jmp .halt
   ENDIF if_start_screen
   dec dl
   SET_CURSOR dh, dl

   dec di
   dec si

   jmp .halt
  ENDIF key_left

  IF ah, KEY_RIGHT, key_right
   GET_CURSOR
   IF dl, 79, if_end_screen
    jmp .halt
   ENDIF if_end_screen
   inc dl
   SET_CURSOR dh, dl

   inc di
   inc si

   jmp .halt
  ENDIF key_right

  IF ah, KEY_UP, key_up
   mov al, byte [gs:si]

   IF al, '1', if_up_1
    mov byte [gs:si], '2'
    jmp .key_up_end
   ENDIF if_up_1

   IF al, '2', if_up_2
    mov byte [gs:si], '4'
    jmp .key_up_end
   ENDIF if_up_2

   IF al, '4', if_up_4
    mov byte [gs:si], '8'
    jmp .key_up_end
   ENDIF if_up_4

   IF al, '8', if_up_8
    jmp .key_up_end
   ENDIF if_up_8

   mov byte [gs:si], '1'

   .key_up_end:
   call se_draw_pattern
   jmp .halt
  ENDIF key_up

  IF ah, KEY_DOWN, key_down
   mov al, byte [gs:si]

   IF al, '2', if_down_2
    mov byte [gs:si], '1'
    jmp .key_down_end
   ENDIF if_down_2

   IF al, '4', if_down_4
    mov byte [gs:si], '2'
    jmp .key_down_end
   ENDIF if_down_4

   IF al, '8', if_down_8
    mov byte [gs:si], '4'
    jmp .key_down_end
   ENDIF if_down_8

   .key_down_end:
   call se_draw_pattern
   jmp .halt
  ENDIF key_down

  ;test if is pressed key whose can be written
  cmp al, 'c'
  je .write_tone
  cmp al, ' '
  je .write_tone
  cmp al, 'A'
  jl .halt
  cmp al, 'H'
  jg .halt

  .write_tone:
   mov byte [gs:di], al
   call se_draw_pattern
 jmp .halt
