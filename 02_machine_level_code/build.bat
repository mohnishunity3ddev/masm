@echo off
REM build.bat

if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" (
    call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
) else if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" (
    call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
) else (
    echo Error: Could not find vcvarsall.bat. Please ensure Visual Studio is installed correctly.
    pause
    exit /b 1
)
echo Visual Studio environment set up complete.

REM Set the bin directory
set BIN_DIR=bin

REM Create the bin directory if it doesn't exist
if not exist %BIN_DIR% mkdir %BIN_DIR%

REM /FA produces the assembly for the c file.
REM /FAcs produce a .cod file which has produced assembly instructions along with c code inside comments.
REM /Od produce debug info
REM /c compile only without linking.
cl /c /Od /FAcs mstore.c

REM Disassemble object file.
dumpbin /disasm mstore.obj > objdump.txt

@REM Combine and link main and mstore
cl /Od /W3 /Femain.exe main.c mstore.c

@REM dump of the main exe
dumpbin /disasm main.exe > exedump.txt
