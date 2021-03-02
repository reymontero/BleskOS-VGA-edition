;BleskOS VGA edition

%macro NUMBER_INPUT_MULTIPLY 2
 WAIT_FOR_KEYBOARD
 cmp al, '0'
 jl .zero_%2_%1
 cmp al, '9'
 jg .zero_%2_%1
 jmp .over_zero_%2_%1

 .zero_%2_%1:
 mov al, '0'
 .over_zero_%2_%1:

 mov ah, 0x0E
 int 10h ;print on screen
 sub al, '0'
 mov ah, 0
 mov bx, %2
 mul bx
 add word [%1], ax
%endmacro

first_number dw 0
second_number dw 0
result dw 0

calculator:
 DRAW_BACKGROUND 0xF0

 DRAW_LINE 0, 0, 80, 0x0F
 DRAW_LINE 24, 0, 80, 0x0F
 PRINT 0, 0, str_up, 'Calculator'
 PRINT 2, 1, str_first, 'First number: 0000'
 PRINT 4, 1, str_second, 'Second number: 0000'
 PRINT 6, 1, str_result, 'Result:'
 PRINT 8, 1, str_type, '[a] + [b] - [c] * [d] /'
 PRINT 24, 0, str_down, '[F1] Set first number [F2] Set second number [F3] Copy result to first number'

 .halt:
  WAIT_FOR_KEYBOARD

  IF ah, KEY_ESC, key_esc
   jmp main_screen
  ENDIF key_esc

  IF ah, KEY_F1, key_f1
   mov word [first_number], 0
   SET_CURSOR 2, 15
   SHOW_CURSOR

   NUMBER_INPUT_MULTIPLY first_number, 1000
   NUMBER_INPUT_MULTIPLY first_number, 100
   NUMBER_INPUT_MULTIPLY first_number, 10
   NUMBER_INPUT_MULTIPLY first_number, 1

   HIDE_CURSOR
   jmp .halt
  ENDIF key_f1

  IF ah, KEY_F2, key_f2
   mov word [second_number], 0
   SET_CURSOR 4, 16
   SHOW_CURSOR

   NUMBER_INPUT_MULTIPLY second_number, 1000
   NUMBER_INPUT_MULTIPLY second_number, 100
   NUMBER_INPUT_MULTIPLY second_number, 10
   NUMBER_INPUT_MULTIPLY second_number, 1

   HIDE_CURSOR
   jmp .halt
  ENDIF key_f2

  IF ah, KEY_F3, key_f3
   mov ax, word [result]
   mov word [first_number], ax

   PRINT 2, 15, str_clear, '    '
   SET_CURSOR 2, 15
   mov ax, word [first_number]
   call print_var
   jmp .halt
  ENDIF key_f3

  IF ah, KEY_A, key_a
   PRINT 6, 9, str_clear_1, '      '
   SET_CURSOR 6, 9
   mov ax, word [first_number]
   add ax, word [second_number]
   mov word [result], ax
   call print_var
   jmp .halt
  ENDIF key_a

  IF ah, KEY_B, key_b
   PRINT 6, 9, str_clear_2, '      '
   SET_CURSOR 6, 9
   mov ax, word [first_number]
   sub ax, word [second_number]
   mov word [result], ax
   call print_var
   jmp .halt
  ENDIF key_b

  IF ah, KEY_C, key_c
   PRINT 6, 9, str_clear_3, '      '
   SET_CURSOR 6, 9
   mov ax, word [first_number]
   mov bx, word [second_number]
   mul bx
   mov word [result], ax
   call print_var
   jmp .halt
  ENDIF key_c

  IF ah, KEY_D, key_d
   IF word [second_number], 0, divide_zero
    PRINT 6, 9, str_error, 'Error'
    jmp .halt
   ENDIF divide_zero

   PRINT 6, 9, str_clear_4, '      '
   SET_CURSOR 6, 9
   mov ax, word [first_number]
   mov bx, word [second_number]
   mov dx, 0
   div bx
   mov word [result], ax
   call print_var
   jmp .halt
  ENDIF key_d
 jmp .halt
