.386
.model flat, stdcall
option casemap:none
include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\fpu.inc
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\fpu.lib
.data 
CrLf equ 0A0Dh 
_y1 dt 0.0 
_y2 dt 0.0 
_y3 dt 0.0
_y4 dt 0.0  
_x DWORD 1.0
_op1 DWORD 37.0
_op2 DWORD 7.3
_op3 DWORD 2.0
_zero DWORD 0.0
_step DWORD 2.0
info db "Студент Василевський С.О. К. КНЕУ, каф. ІІТ 2021 р.",10,10,
"Y = 37/(2x^2+7.3), де x змінюється з кроком 2",10,10, 
 "y1 = " 
 _res1 db 14 DUP(0),10,13
db "y2 = "
_res2 db 14 DUP(0),10,13
db "y3 = "
_res3 db 14 DUP(0),10,13
db "y4 = "
_res4 db 14 DUP(0),10,13
 ttl db "Обробка чисел на сопроцесоре в цикле",0 
.code 
_start: 

finit
mov ecx, 4
m1:

fld _op1
fld _x
fmul _x
fmul _op3
fadd _op2
fdivp st(1), st
fwait
fld _x
fadd _step
fstp _x
loop m1

fstp _y4
fstp _y3
fstp _y2
fstp _y1

invoke FpuFLtoA,offset _y1,10,offset _res1,SRC1_REAL or SRC2_DIMM
mov word ptr _res1 + 14, CrLf
invoke FpuFLtoA,offset _y2,10,offset _res2,SRC1_REAL or SRC2_DIMM
mov word ptr _res2 + 14, CrLf
invoke FpuFLtoA,offset _y3,10,offset _res3,SRC1_REAL or SRC2_DIMM
mov word ptr _res3 + 14, CrLf
invoke FpuFLtoA,offset _y4,10,offset _res4,SRC1_REAL or SRC2_DIMM
mov word ptr _res4 + 14, CrLf
invoke MessageBox, 0, offset info, offset ttl, MB_ICONINFORMATION
invoke ExitProcess, 0 
end _start