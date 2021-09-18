.486 ; create 32 bit code
 .model flat, stdcall ; 32 bit memory model
 option casemap :none ; case sensitive
 include \masm32\include\windows.inc ; always first
 include \masm32\macros\macros.asm ; MASM support macros
 ; -----------------------------------------------------------------
 ; include files that have MASM format prototypes for function calls
 ; -----------------------------------------------------------------
 include \masm32\include\masm32.inc
 include \masm32\include\gdi32.inc
 include \masm32\include\user32.inc
 include \masm32\include\kernel32.inc
 include \masm32\include\msvcrt.inc
includelib \masm32\lib\msvcrt.lib
 ; ------------------------------------------------
 ; Library files that have definitions for function
 ; exports and tested reliable prebuilt code.
 ; ------------------------------------------------
 includelib \masm32\lib\masm32.lib
 includelib \masm32\lib\gdi32.lib
 includelib \masm32\lib\user32.lib
 includelib \masm32\lib\kernel32.lib
.data ; директива определения данных
_temp1 dd ?,0
_temp2 dd ?,0
_const1 dd 4
_const2 dd 3
_const3 dd 1
_a dd 0
_b dd 0
_c dd 0
_d dd 0
_e dd 0
_title db "Лабораторна робота №2. операції порівнняння",0
strbuf dw ?,0
_text db "masm32. Вивід результата через MessageBox:",0ah,
"y=ax+2c x>c",0ah,
"y=ac-3x x<=c",0ah,
"Результат: %d — ціла частина",0ah, 0ah,
"Василевський С.О., ІН-103 ",0
MsgBoxCaption db "Пример окна сообщения",0
MsgBoxText_1 db "порівнняння _c <_d",0
MsgBoxText_2 db "порівнняння _c >=_d",0
.const
 NULL equ 0
 MB_OK equ 0
.code ; директива начала сегмента команд
_start:; метка начала программы с именем _start
main proc
mov _a, sval(input("input 2 a = "))
mov _b, sval(input("input 2 b = "))
mov _c, sval(input("input 2 c = "))
mov _d, sval(input("input 2 d = "))
mov _e, sval(input("input 2 e = "))
mov ebx, _c
mov eax, _d ;здесь мы записали число _d в регистр eax.

sub eax, ebx ; порівняння _c >=_d
 jle zero
; zero ;осуществляем переход на метку zero,
;если флаг ZF установлен.
;Если не , то выполнение продолжится дальше
;y=d/b-d/4c
mov eax, _d ;4
mul _const3 ;4
div _b      ;4/4=1
mov _temp1, eax ;зміст eax в _temp1=1
mov eax, _const1 ;4
mul _c      ;12
mov _temp2, eax ;12
mov eax, _d     ;4
mul _const3     ;4
div _temp2      ;4/12=0
sub _temp1, eax ;1-0=1

INVOKE MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption,
MB_OK
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1, _temp2
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0
jmp lexit ;переходим на метку exit (GOTO exit)
zero:
;y=e/3c+ac, c >= d
mov eax, _c 
mul _const2 
mov _temp1, eax 
mov eax, _e 
mul _const3 ;1
div _temp1
mov _temp1, eax
mov eax, _a
mul _c
sub _temp1, eax 
INVOKE MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR MsgBoxCaption,
MB_OK
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0
lexit:
ret
main endp
ret ; возврат управления ОС
end _start ; завершение программы с именем _start