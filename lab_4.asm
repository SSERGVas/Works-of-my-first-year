.486
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
include \masm32\include\fpu.inc
includelib \masm32\lib\msvcrt.lib
; ------------------------------------------------
; Library files that have definitions for function
; exports and tested reliable prebuilt code.
; ------------------------------------------------
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\fpu.lib
uselib kernel32
uselib user32
uselib fpu
uselib masm32
.stack
.data
z1 real10 4.0
tempnum real10 0.0
res real10 0.0
op0 real10 2.0
op1 real10 -2.0
op2 real10 2.0
op3 real10 0.5
op4 real10 0.1
op7 real10 0.47
op5 real10 2.0
op6 real10 3.0
ansline1 db "При Z = ",0
ansline2 db " значення функції V = ",0
resline db 100 dup(?)
buf2 db 100 dup(?)
titl db "Вбудовані функції співпроцесора ст. КНЕУ ІІТЕ Василевський С.О., ІН-103 ",0
.code
Begin:
finit
fld z1
fld op1
fcompp
fstsw ax
fwait
sahf
ja left

fld op2
fld z1
fcompp
fstsw ax
fwait
sahf
ja right
       
fld z1
fld op7
fmul st, st(1)      ;st=0.47*z
fld op4
fadd st, st(1)      ;st=0.47*z+0.1
fptan
fxch
fstp res
jmp outputres

left:
fld z1
fchs
fldln2                  ; st(0)=ln(2) st(1)=x
fxch    st(1)           ; st(0)=x st(1)=ln(2)
fyl2x
fld op6
fdiv

fldl2e                  ;st(0)=1/ln(2)=log2(e)
fmulp   st(1),  st(0)   ;st(0)=x/ln(2)=x*log2(e)
fld     st(0)
frndint
fsub    st(1), st(0)
fxch    st(1)
f2xm1           ;st(0)=2^(mantissa)-1
fld1            ;st(0)=2^(mantissa)-1+1=2^(mantissa)
faddp   st(1), st(0)
fscale
fchs

fld op3
fmul st, st(1)
fld z1
fadd st, st(1)
fstp res
;invoke FpuAdd, addr res, addr z1,addr res,SRC1_REAL, or SRC2_REAL or DEST_MEM
jmp outputres

right:
fld1
fld z1 
fyl2x              ; st =  log2(x)
fldl2t             ; st =  log2(10)
fdivp st(1), st(0)
fld z1
fadd
fsin 
fstp    res
jmp outputres

outputres:
mov resline,0
invoke szCatStr,addr resline,addr ansline1
invoke FpuFLtoA,addr z1,3,addr buf2,SRC1_REAL or SRC2_DIMM
invoke szCatStr,addr resline,addr buf2
invoke szCatStr,addr resline,addr ansline2
invoke FpuFLtoA,addr res,3,addr buf2,SRC1_REAL or SRC2_DIMM
invoke szCatStr,addr resline,addr buf2
invoke MessageBox,0,addr resline,addr titl,MB_ICONINFORMATION
invoke ExitProcess, 0
end Begin
