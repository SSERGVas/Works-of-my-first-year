;��������� 1.2. г�����  8d � 9d/c   �� masm32:
.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
firstfunc PROTO _const1:DWORD,_d1:DWORD,_const2:DWORD,_d2:DWORD, _c1:DWORD
.data   
const1 dd 8
d1 dd 2
const2 dd 9
d2 dd 1
c1 dd 3
_temp1 dd ?,0
_title db "����������� ������ �1. �����. ��������",0
strbuf dw ?,0
_text db "masm32. ������� ����  ��� �������� �.�.",0ah,
"  ���� ���������� 8d � 9d/c ����� MessageBox:",0ah,
"const1*d1+const2*d2/c1",0ah,
"8*2-9*1/3",0ah,
"���������: %d � ���� �������",0ah, 0ah,0
.code
firstfunc proc _const1:DWORD,_d1:DWORD,_const2:DWORD,_d2:DWORD, _c1:DWORD
;const1*d1+const2*d2/c1
;8*2-9*1/3
mov eax, _const1    ;8
mul _d1             ;8*2=16
mov _temp1, eax      ;0  ���� eax � _temp1=16
mov eax, _const2     ;9
mul _d2             ;9*1
div _c1              ;eax=9/3=3
sub _temp1, eax      ;_temp1=_temp1- eax  =16-3=13
ret
firstfunc endp

start:
invoke firstfunc, const1,d1,const2,d2,c1
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0
END start