;BleskOS VGA edition

%define KEY_ESC 0x01
%define KEY_ENTER 0x1C
%define KEY_UP 0x48 
%define KEY_DOWN 0x50
%define KEY_LEFT 0x4B
%define KEY_RIGHT 0x4D
%define KEY_BACKSPACE 0x0E
%define KEY_DELETE 0x53
%define KEY_F1 0x3B
%define KEY_F2 0x3C
%define KEY_F3 0x3D
%define KEY_F4 0x3E

%define KEY_A 0x1E
%define KEY_B 0x30
%define KEY_C 0x2E
%define KEY_D 0x20
%define KEY_E 0x12
%define KEY_F 0x21
%define KEY_G 0x22
%define KEY_H 0x23

%macro WAIT_FOR_KEYBOARD 0
 mov ah, 0x00
 int 16h
%endmacro

%macro READ_FROM_KEYBOARD 0
 mov ah, 0x01
 int 16h
%endmacro
