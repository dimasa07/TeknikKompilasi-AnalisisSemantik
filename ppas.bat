@echo off
c:\dev-pas\bin\ldw.exe  D:\_DATA-~1\SEMEST~4\TEKKOM\Tugas\tubes\TEKNIK~1\rsrc.o -s   -o d:\_data-~1\semest~4\tekkom\tugas\tubes\teknik~1\analis~1.exe link.res exp.$$$
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
