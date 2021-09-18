.686 ; create 32 bit code
.model flat, stdcall ; 32 bit memory model
option casemap :none ; case sensitive
include \masm32\include\windows.inc ; always first
include \masm32\macros\macros.asm ; MASM support macros
include \masm32\include\masm32.inc
include \masm32\include\gdi32.inc
include \masm32\include\fpu.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include c:\masm32\include\msvcrt.inc
includelib c:\masm32\lib\msvcrt.lib
includelib c:\masm32\lib\fpu.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
.data ; директива определения данных
x DWORD 0.0
xnow DWORD 0.0
;factor DWORD 0.0
temp DWORD 0
eps DWORD 0.0001
zero DWORD 0.0
two DWORD 2.0
_title db "Лабораторна робота №6",0
strbuf dw ?,0
_text db "masm32. Василевський С.О. КНЕУ, каф. ІІТвЕ 2020 р. ",10 ,"Вивід результата arctg(x):", 10,13
_result dt 0.0
sum DWORD 0.0
n DWORD 1.0
n1 DWORD 0.0
tmp1 DWORD 1.0
tmp2 DWORD 3.0
.const
NULL equ 0
MB_OK equ 0
include \masm32\include\masm32rt.inc
include \masm32\include\dialogs.inc
dlgproc PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetTextDialog PROTO :DWORD,:DWORD,:DWORD
.data?
hInstance dd ?
.code
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
start:
mov hInstance, rv(GetModuleHandle,NULL)
call main
invoke ExitProcess,eax
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
main proc
LOCAL hIcon :DWORD
invoke InitCommonControls
mov hIcon, rv(LoadIcon,hInstance,10)
mov x, rv(GetTextDialog," ЛАБОРАТОРНА 6 (ІТЕРАЦІЯ)"," ВВЕДЕННЯ x: ",hIcon)
;Введення Х
mov eax, sval(x) ;Конвертація зі строки в числа
mov x, eax          ;eax=x
.if x == 0          ;перевірка чи х=0
fld sum             ; st=sum
invoke FpuFLtoA, 0, 10, ADDR _result, SRC1_FPU or SRC2_DIMM ;підготовка для виведення змінної
invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
jmp b       ; переміщення на мітку b
.endif      ; завершення макросу if
finit       ; ініціалізація співпроцесора
fild x      ; st=x (ціле число)
fstp x      ; копіювання з виштовхуванням зі стеку в змінну х 
fld x       ; st=x
fstp sum        ; копіювання з виштовхуванням зі стеку в змінну sum
fld x           ; st=x
fld x           ; st=x, st(1)=x
fmul            ; st=x^2
fstp temp       ; temp=x^2
fld temp        ; temp=x^2
fld tmp1        ; st=tmp1 (2N-1)
fmul            ; st=temp*tmp1 (2N-1)x^2
;fld tmp2        ; st=tmp2 (2N+1),st(1)=temp*tmp1 (2N-1)x^2
;fxch            ; st=temp*tmp1 (2N-1)x^2 (2N+1),st(1)=tmp2
fdiv tmp2       ; st=temp*tmp1/temp2 ((2N-1)x^2)/(2N+1)
fld sum         ; st=sum st(1)=temp*tmp1/tmp2
fmul            ; st=sum*(temp*tmp1/tmp2)  x*((2N-1)x^2)/(2N+1)
fchs            ; st=-st
fstp xnow       ; копіювання з виштовхуванням зі стеку в змінну xnow
fld xnow        ; st=xnow
fstp n1         ; копіювання з виштовхуванням зі стеку в змінну n1
fld tmp1        ; st=tmp1
fadd two        ; st=tmp1+2
fstp tmp1       ; копіювання з виштовхуванням зі стеку в змінну tmp1
fld tmp2        ; st=tmp2
fadd two        ; st=tmp2+2
fstp tmp2       ; копіювання з виштовхуванням зі стеку в змінну tmp2
fld sum         ; st=sum
fld xnow        ; st=xnow, st(1)=sum
fadd            ; st=xnow+sum
fstp sum        ; копіювання з виштовхуванням зі стеку в змінну sum
    a:      ; початок мітки а
fld xnow    ; st=xnow
fstp n      ; копіювання з виштовхуванням зі стеку в змінну n
fld temp        ; temp=x^2
fld tmp1        ; st=tmp1 (2N-1)
fmul            ; st=temp*tmp1 (2N-1)x^2
fld xnow        ; st=xnow, st(1)=temp*tmp1
fmul            ; st=xnow*temp*tmp1
;fld tmp2        ; st=tmp2 (2N+1),st(1)=xnow*temp*tmp1 
;fxch            ; st=xnow*temp*tmp1 (2N-1)x^2 (2N+1),st(1)=tmp2
fdiv tmp2       ; st=xnow*temp*tmp1/temp2 (Un(2N-1)x^2)/(2N+1)
fchs            ; st=-st
fstp xnow    ; копіювання з виштовхуванням зі стеку в змінну xnow
fld xnow     ; st=xnow   
fstp n1      ; копіювання з виштовхуванням зі стеку в змінну n1
fld sum      ; st=sum
fld xnow     ; st=xnow,st(1)=sum
fadd         ; st=xnow+sum
fstp sum     ; копіювання з виштовхуванням зі стеку в змінну sum
fld tmp1       ; st=tmp1
fld two         ; st=2, st(1)=tmp1
fadd            ; st=tmp1+2
fstp tmp1      ; копіювання з виштовхуванням зі стеку в змінну tmp1
fld tmp2       ; st=tmp2
fld two         ; st=2, st(1)=tmp1
fadd            ; st=tmp2+2
fstp tmp2      ; копіювання з виштовхуванням зі стеку в змінну tmp2
fld n        ; st=n
fsub n1      ; st=n-n1
fsub eps     ; st=n-n1-eps
fabs         ; st>=0
fcomp eps    ; порівняння st та eps
fstsw ax     ; занесення результату порівняння в регістр АХ
sahf         ; запис в регістр флагів
jae a        ; переміщення на мітку а, якщо st більше або дорівнює eps
fld sum      ; виведення результату
invoke FpuFLtoA, 0, 10, ADDR _result, SRC1_FPU or SRC2_DIMM
invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
b:
ret ; повернення з процедури
ret
ret
main endp ; завершення процедyри main
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
GetTextDialog proc dgltxt:DWORD,grptxt:DWORD,iconID:DWORD
LOCAL arg1[4]:DWORD
LOCAL parg :DWORD
lea eax, arg1
mov parg, eax
; ---------------------------------------
; load the array with the stack arguments
; ---------------------------------------
mov ecx, dgltxt
mov [eax], ecx
mov ecx, grptxt
mov [eax+4], ecx
mov ecx, iconID
mov [eax+8], ecx
Dialog "Get User Text", \ ; caption
"Arial",8, \ ; font,pointsize
WS_OVERLAPPED or \ ; styles for
WS_SYSMENU or DS_CENTER, \ ; dialog window
5, \ ; number of controls
50,50,292,80, \ ; x y co-ordinates
4096 ; memory buffer size
DlgIcon 0,250,12,299
DlgGroup 0,8,4,231,31,300
DlgEdit ES_LEFT or WS_BORDER or WS_TABSTOP,17,16,212,11,301
DlgButton "OK",WS_TABSTOP,172,42,50,13,IDOK
DlgButton "Cancel",WS_TABSTOP,225,42,50,13,IDCANCEL
CallModalDialog hInstance,0,dlgproc,parg
ret
GetTextDialog endp
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
dlgproc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
LOCAL tlen :DWORD
LOCAL hMem :DWORD
LOCAL hIcon :DWORD
switch uMsg
case WM_INITDIALOG
; -------------------------------------------------
; get the arguments from the array passed in lParam
; -------------------------------------------------
push esi
mov esi, lParam
fn SetWindowText,hWin,[esi] ; title text address
fn SetWindowText,rv(GetDlgItem,hWin,300),[esi+4] ; groupbox text address
mov eax, [esi+8] ; icon handle
.if eax == 0
mov hIcon, rv(LoadIcon,NULL,IDI_ASTERISK) ; use default system icon
.else
mov hIcon, eax ; load user icon
.endif
pop esi
fn SendMessage,hWin,WM_SETICON,1,hIcon
invoke SendMessage,rv(GetDlgItem,hWin,299),STM_SETIMAGE,IMAGE_ICON,hIcon
xor eax, eax
ret
case WM_COMMAND
switch wParam
case IDOK
mov tlen, rv(GetWindowTextLength,rv(GetDlgItem,hWin,301))
.if tlen == 0
invoke SetFocus,rv(GetDlgItem,hWin,301)
ret
.endif
add tlen, 1
mov hMem, alloc(tlen)
fn GetWindowText,rv(GetDlgItem,hWin,301),hMem,tlen
invoke EndDialog,hWin,hMem
case IDCANCEL
invoke EndDialog,hWin,0
invoke ExitProcess, 0
endsw
case WM_CLOSE
invoke EndDialog,hWin,0
endsw
xor eax, eax
ret
dlgproc endp
end start