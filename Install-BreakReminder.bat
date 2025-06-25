@echo off
echo ===================================
echo Break Reminder Installer Launcher
echo ===================================
echo.

powershell.exe -ExecutionPolicy Bypass -File "%~dp0install.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Installation encountered an issue. Please check the error messages above.
    echo If you need help, visit: https://github.com/av-mamzikov/break-reminder/issues
    pause
) else (
    echo.
    echo Installation completed successfully!
)
