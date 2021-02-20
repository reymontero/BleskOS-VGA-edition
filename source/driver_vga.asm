;BleskOS VGA edition

%macro SHOW_CURSOR 0
 mov ah, 0x01
 mov ch, 14
 mov cl, 15
 int 10h
%endmacro

%macro HIDE_CURSOR 0
 mov ah, 0x01
 mov ch, 15
 mov cl, 14
 int 10h
%endmacro

%macro GET_CURSOR 0
 mov ah, 0x03
 mov bh, 0
 int 10h
%endmacro

%macro SET_CURSOR 2
 mov ah, 0x02
 mov bh, 0
 mov dh, %1
 mov dl, %2
 int 10h
%endmacro

%macro DRAW_BACKGROUND 1
 mov ah, 0x02
 mov bh, 0
 mov dx, 0
 int 10h

 mov ah, 0x09
 mov al, ' '
 mov bl, %1
 mov cx, 2000
 int 10h
%endmacro

%macro DRAW_LINE 4
 mov dh, %1
 mov dl, %2
 mov cx, %3
 mov bl, %4
 call draw_line
%endmacro

%macro DRAW_COLUMN 4
 mov dh, %1
 mov dl, %2
 mov cx, %3
 mov bl, %4
 call draw_column
%endmacro

%macro DRAW_PIXEL 3
 mov dh, %1
 mov dl, %2
 mov bl, %3
 call draw_pixel
%endmacro

%macro PRINT 4
 mov ah, 0x02
 mov bh, 0
 mov dh, %1
 mov dl, %2
 int 10h

 mov si, %3
 call print
 jmp string_%3
 %3 db %4, 0
 string_%3:
%endmacro

%macro PRINT_VAR 3
 mov ah, 0x02
 mov bh, 0
 mov dh, %1
 mov dl, %2
 int 10h

 %if %3!=ax
 mov ax, %3
 %endif
 call print_var
%endmacro

%macro PRINT_HEX 3
 mov ah, 0x02
 mov bh, 0
 mov dh, %1
 mov dl, %2
 int 10h

 %if %3!=ax
 mov ax, %3
 %endif
 call print_hex
%endmacro

%macro PRINT 2
 mov si, %1
 call print
 jmp string_%1
 %1 db %2, 0
 string_%1:
%endmacro

%macro PRINT_VAR 1
 %if %1!=ax
 mov ax, %1
 %endif
 call print_var
%endmacro

%macro PRINT_HEX 1
 %if %1!=ax
 mov ax, %1
 %endif
 call print_hex
%endmacro

string_print_var db 0, 0, 0, 0, 0
string_print_hex db 0, 0, 0, 0, 0, 0

draw_line:
 mov ah, 0x02
 mov bh, 0
 int 10h

 mov ah, 0x09
 mov al, ' '
 int 10h

 ret

draw_column:
 mov ah, 0x02
 mov bh, 0
 int 10h

 .cycle_draw_column:
 push cx
  mov ah, 0x09
  mov al, ' '
  mov cx, 1
  int 10h

  mov ah, 0x02
  inc dh
  int 10h
 pop cx
 loop .cycle_draw_column

 ret

draw_pixel:
 mov ah, 0x02
 mov bh, 0
 int 10h

 mov ah, 0x09
 mov al, ' '
 mov cx, 1
 int 10h

 ret

print:
 mov ah, 0x0E

 .print_char:
  cmp byte [si], 0
  je .return

  mov al, byte [si]
  int 10h

  inc si
 jmp .print_char

 .return:
 ret

print_var:
 ;parse all numbers
 mov bx, 10
 mov dx, 0
 div bx
 mov byte [string_print_var+4], dl

 mov dx, 0
 div bx
 mov byte [string_print_var+3], dl

 mov dx, 0
 div bx
 mov byte [string_print_var+2], dl

 mov dx, 0
 div bx
 mov byte [string_print_var+1], dl

 mov dx, 0
 div bx
 mov byte [string_print_var+0], dl

 ;convert to char
 add byte [string_print_var+0], '0'
 add byte [string_print_var+1], '0'
 add byte [string_print_var+2], '0'
 add byte [string_print_var+3], '0'
 add byte [string_print_var+4], '0'

 ;skip zeroes on start of string
 cmp byte [string_print_var+0], '0'
 jne .print_5
 cmp byte [string_print_var+1], '0'
 jne .print_4
 cmp byte [string_print_var+2], '0'
 jne .print_3
 cmp byte [string_print_var+3], '0'
 jne .print_2

 jmp .print_1

 ;print
 .print_5:
 mov ah, 0x0E
 mov al, byte [string_print_var+0]
 int 10h

 .print_4:
 mov ah, 0x0E
 mov al, byte [string_print_var+1]
 int 10h

 .print_3:
 mov ah, 0x0E
 mov al, byte [string_print_var+2]
 int 10h

 .print_2:
 mov ah, 0x0E
 mov al, byte [string_print_var+3]
 int 10h

 .print_1:
 mov ah, 0x0E
 mov al, byte [string_print_var+4]
 int 10h

 ret

print_hex:
 ;parse all numbers
 mov bx, ax
 shr bx, 12
 mov byte [string_print_hex+0], bl

 mov bx, ax
 shr bx, 8
 and bx, 0x0F
 mov byte [string_print_hex+1], bl

 mov bx, ax
 shr bx, 4
 and bx, 0x0F
 mov byte [string_print_hex+2], bl

 mov bx, ax
 and bx, 0x0F
 mov byte [string_print_hex+3], bl

 ;convert to char
 add byte [string_print_hex+0], '0'
 add byte [string_print_hex+1], '0'
 add byte [string_print_hex+2], '0'
 add byte [string_print_hex+3], '0'

 cmp byte [string_print_hex+0], '9'+1
 jl .char_1
  add byte [string_print_hex+0], 7
 .char_1:

 cmp byte [string_print_hex+1], '9'+1
 jl .char_2
  add byte [string_print_hex+1], 7
 .char_2:

 cmp byte [string_print_hex+2], '9'+1
 jl .char_3
  add byte [string_print_hex+2], 7
 .char_3:

 cmp byte [string_print_hex+3], '9'+1
 jl .char_4
  add byte [string_print_hex+3], 7
 .char_4:

 ;print string
 mov ah, 0x0E
 mov al, '0'
 int 10h
 mov al, 'x'
 int 10h
 mov al, byte [string_print_hex+0]
 int 10h
 mov al, byte [string_print_hex+1]
 int 10h
 mov al, byte [string_print_hex+2]
 int 10h
 mov al, byte [string_print_hex+3]
 int 10h

 ret
