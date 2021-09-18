.686 ; ��������� ����������� ���� ���������������
.model flat, stdcall ; ������� �������� ������ ������
option casemap:none ; �������� ����� �� ������� ����
include \masm32\include\windows.inc ; ����� ��������, �������� �
include \masm32\macros\macros.asm
uselib user32,kernel32,fpu
.data
name_tit db "����������� ������ �5",0 ; ����� ���� MsgBox
temp DWORD 10 dup (?) ; �����
n DWORD 1.0
op1 dd 1.0
op2 dd 3.0
step dd 1.0
res DT 0.0 ; ����� ��� ���������� ����������
temp1 DD 0.0
temp2 DD 0.0

.code ; ��������� ������ �������� ������
start: ; ����� ������ ��������� � ������ start
mov ecx, 4 ; �������� ������� ���������
finit ; ����������� ������������
.WHILE ecx != 0 ; ����
fld n       ;st=n
fld op1     ;st=1, st(1)=n
fadd        ;st=n+1
fstp temp1  ;temp1=st=n+1
fld n       ;st=n
fld n       ;st=n, st(1)=n
fmul        ;st=n*n
fld op2     ;st=op2
fsub        ;st=n*n-op2
fld temp1   ;st=temp1
fxch        ;st=n*n-op2, st(1)=temp1
fdiv        ;st=n+1/n*n-op2
fld res     ;st=res
fadd        ;st=res+n+1/n*n-op2

fstp res ; ��������������� ����������
push ecx ; ��������� �� ������� �в-�������
pop ecx ; ���������� ��������� �����
fld n; ���������� ����������� k
fadd step ; ��������� ����� �� 1
fst n; ���������� ������ k
dec ecx ; ��������� ��������� �� 1
.ENDW ; ��������� ����� WHILE
invoke FpuFLtoA, ; �в-������� ������������ ������� �����
ADDR res, ; ������ �������� ��� ������������
10, ; ������� ���������� ����� ���� ���� (10)
ADDR temp, ; ������ ������ ��� �������, �� �������������
SRC1_REAL or SRC2_DIMM ; 1-� ������� � � �����, 2-� � �����
invoke MessageBox, NULL,addr temp, addr name_tit, MB_OK
invoke ExitProcess, 0 ; ���������� ��������� �� �� ����������� �������
end start ; ��������� ���������� ��������� � ������ start