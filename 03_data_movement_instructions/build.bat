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

REM Get the name of the assembly file (without extension)
for %%F in (*.asm) do set "FILE_NAME=%%~nF"

REM Assemble the ASM file
ml64 /c /Zi /nologo %FILE_NAME%.asm

REM Move the object file to the bin directory
move %FILE_NAME%.obj %BIN_DIR%\

REM Link the object file and place the executable in the bin directory
link %BIN_DIR%\%FILE_NAME%.obj /DEBUG /NOLOGO /SUBSYSTEM:console /DEFAULTLIB:kernel32.lib /DEFAULTLIB:user32.lib /DEFAULTLIB:libcmt.lib /OUT:%BIN_DIR%\%FILE_NAME%.exe

REM If successful, run the program
if %errorlevel% equ 0 (
    echo Build successful.
) else (
    echo Build failed.
)