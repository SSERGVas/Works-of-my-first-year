;Программа 1.2. Рішення  bc/a + c/ad   на masm32:
.686
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
firstfunc PROTO _b1:DWORD,_c1:DWORD,_a1:DWORD,_c2:DWORD,_a2:DWORD,_d1:DWORD
.data
b1 dd 2 
c1 dd 1
a1 dd 2
c2 dd 8
a2 dd 4
d1 dd 2
_temp1 dd ?,0
_temp2 dd ?,0
_title db "Лабораторна робота №1. Арифм. операції",0
strbuf dw ?,0
_text db "masm32. СТУДЕНТ КНЕУ ІСЕ Василевський С.О.",0ah,
"Вивід результата ae/4b – d/14c через MessageBox:",0ah,
"bc/a + c/ad",0ah,
"2*1/2+8/4*2",0ah,
"Результат: %d — ціла частина",0ah, 0ah,0
.code
firstfunc proc _b1:DWORD,_c1:DWORD,_a1:DWORD,_c2:DWORD,_a2:DWORD,_d1:DWORD
;bc/a + c/ad
;8*2-9*1/3
mov eax, _b1        ;2
mul _c1             ;2*1=2
div _a1             ;eax=2/2=1
mov _temp1, eax     ;1 , 1
mov eax, _a2        ;4 , 4
mul _d1             ;4*2=8
mov _temp2, eax     ;8 , 8
mov eax, _c2        ;8 , 8
mul _c1             ;8*1=8
div _temp2          ;eax=8/8=1
add _temp1, eax     ;_temp1+eax = 1+1=2
ret
firstfunc endp

start:
invoke firstfunc,b1,c1,a1,c2,a2,d1
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1, _temp2
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0
END start