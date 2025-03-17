@echo off
set CURDATE=%DATE%
set NAMEARH="emulator_src_"
@rar a %NAMEARH%%CURDATE:~8,2%%CURDATE:~3,2%%CURDATE:~0,2% *.pas *.res *.dpr *.ini *.dfm *.dof *.inc *.vmp *.txt *.bat *.ico *.epr
set CURDATE=
set NAMEARH=
