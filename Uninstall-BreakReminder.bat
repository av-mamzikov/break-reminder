@echo off
echo ===================================
echo Break Reminder Uninstaller Launcher
echo ===================================
echo.

powershell.exe -ExecutionPolicy Bypass -File "%~dp0uninstall.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Uninstallation encountered an issue. Please check the error messages above.
    pause
) else (
    echo.
    echo Uninstallation completed!
)
