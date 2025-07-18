@echo off
setlocal enabledelayedexpansion

:: === CONFIGURATION ===
set "SOURCE_PS1=SH.ps1"
set "SOURCE_LNK=SH.lnk"
set "SOURCE_UPGRADE=update_packages.py"
set "SOURCE_UP_WIN=update_win.bat"
set "SOURCE_UP_THONNY=update_thonny.bat"
set "DEST_PROGFILES=C:\Program Files\%SOURCE_PS1%"
:: set "DEST_DESKTOP=%USERPROFILE%\Desktop\%SOURCE_LNK%"
set "DEST_DESKTOP=C:\"


:: === VALIDATE FILES ===
set "FILES_MISSING=0"
if not exist "%~dp0%SOURCE_PS1%" (
    echo ERROR: Missing "%~dp0%SOURCE_PS1%"
    echo [Check: Show file extensions, no trailing spaces]
    set "FILES_MISSING=1"
)
if not exist "%~dp0%SOURCE_LNK%" (
    echo ERROR: Missing "%~dp0%SOURCE_LNK%"
    set "FILES_MISSING=1"
)
if not exist "%~dp0%SOURCE_UPGRADE%" (
    echo ERROR: Missing "%~dp0%SOURCE_UPGRADE%"
    set "FILES_MISSING=1"
)
if %FILES_MISSING% equ 1 (
    pause
    exit /b 1
)

:: === COPY FILES ===
:: 1. Copy SH.ps1 to Program Files (admin)
net session >nul 2>&1
if %errorLevel% equ 0 (
    mkdir "C:\Program Files" >nul 2>&1
    copy /y "%~dp0%SOURCE_PS1%" "%DEST_PROGFILES%" && (
        echo SUCCESS: Copied to Program Files
    ) || (
        echo FAILED: Program Files copy (permissions?)
    )
) else (
    echo SKIPPED: Program Files (admin required)
)

:: 2. Copy SH.lnk to C:\
copy /y "%~dp0%SOURCE_LNK%" "%DEST_DESKTOP%" && (
    echo SUCCESS: Copied to C:\
) || (
    echo FAILED: SH.lnk
)

:: 3. Copy update_packages.py to C:\
copy /y "%~dp0%SOURCE_UPGRADE%" "%DEST_DESKTOP%" && (
    echo SUCCESS: Copied to C:\
) || (
    echo FAILED: update_packages.py
)

:: 4. Copy update_win.bat to C:\
copy /y "%~dp0%SOURCE_UP_WIN%" "%DEST_DESKTOP%" && (
    echo SUCCESS: Copied to C:\
) || (
    echo FAILED: update_win.bat
)

:: 5. Copy update_thonny.bat to C:\
copy /y "%~dp0%SOURCE_UP_THONNY%" "%DEST_DESKTOP%" && (
    echo SUCCESS: Copied to C:\
) || (
    echo FAILED: update_thonny.bat
)

pause
