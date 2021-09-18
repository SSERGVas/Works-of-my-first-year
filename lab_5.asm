.686 ; директива определения типа микропроцессора
.model flat, stdcall ; задание линейной модели памяти
option casemap:none ; відмінність малих та великих літер
include \masm32\include\windows.inc ; файлы структур, констант …
include \masm32\macros\macros.asm
uselib user32,kernel32,fpu
.data
name_tit db "Лабораторна робота №5",0 ; назва вікна MsgBox
temp DWORD 10 dup (?) ; буфер
n DWORD 1.0
op1 dd 1.0
op2 dd 3.0
step dd 1.0
res DT 0.0 ; змінна для збереження результату
temp1 DD 0.0
temp2 DD 0.0

.code ; директива начала сегмента данных
start: ; метка начала программы с именем start
mov ecx, 4 ; лічильник кількості обчислень
finit ; ініціалізація співпроцесора
.WHILE ecx != 0 ; цикл
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

fstp res ; запам’ятовування результату
push ecx ; підготовка до виклику АРІ-функцій
pop ecx ; відновлення лічильника циклів
fld n; відновлення тимчасового k
fadd step ; збільшення кроку на 1
fst n; збереження нового k
dec ecx ; зменшення лічильника на 1
.ENDW ; закінчення циклу WHILE
invoke FpuFLtoA, ; АРІ-функція перетворення дійсного числа
ADDR res, ; адреса операнда для перетворення
10, ; кількість десяткових знаків після коми (10)
ADDR temp, ; адреса буфера для символів, які перетворяться
SRC1_REAL or SRC2_DIMM ; 1-й операнд – в пам’яті, 2-й – число
invoke MessageBox, NULL,addr temp, addr name_tit, MB_OK
invoke ExitProcess, 0 ; повернення управління ОС та вивельнення ресурсів
end start ; директива завершение программы с именем start