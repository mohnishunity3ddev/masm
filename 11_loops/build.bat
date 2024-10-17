@echo off
REM build.bat
setlocal enabledelayedexpansion

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

ml64 /c /Zi /nologo factorials.asm
move factorials.obj "%BIN_DIR%\"
link "%BIN_DIR%\factorials.obj" /DEBUG /NOLOGO /SUBSYSTEM:console /DEFAULTLIB:kernel32.lib /DEFAULTLIB:user32.lib /DEFAULTLIB:libcmt.lib /OUT:"%BIN_DIR%\factorials.exe"

REM If successful, run the program
if %errorlevel% equ 0 (
    echo Build successful.
) else (
    echo Build failed.
)
endlocal