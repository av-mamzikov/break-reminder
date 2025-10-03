# Break Reminder Uninstaller
# This script removes the Break Reminder application from your system

Write-Host "`n=== Break Reminder Uninstaller ===" -ForegroundColor Cyan
Write-Host "`nThis will remove Break Reminder from your system." -ForegroundColor Yellow
$confirm = Read-Host "Do you want to continue? (Y/N)"

if ($confirm -ne "Y") {
    Write-Host "Uninstallation cancelled." -ForegroundColor Yellow
    exit
}

# Define installation directory
$installDir = "$env:LOCALAPPDATA\BreakReminder"

# Remove scheduled tasks
Write-Host "`nRemoving scheduled tasks..." -ForegroundColor Cyan
$tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "BreakReminder*" }

if ($tasks) {
    foreach ($task in $tasks) {
        try {
            Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false -ErrorAction Stop
            Write-Host "Removed scheduled task: $($task.TaskName)" -ForegroundColor Green
        }
        catch {
            Write-Host "Could not remove scheduled task: $($task.TaskName)" -ForegroundColor Red
        }
    }
} else {
    Write-Host "No scheduled tasks found." -ForegroundColor Yellow
}

# Remove desktop shortcut
$shortcutPath = "$env:USERPROFILE\Desktop\Break Reminder.lnk"
if (Test-Path $shortcutPath) {
    try {
        Remove-Item -Path $shortcutPath -Force -ErrorAction Stop
        Write-Host "Removed desktop shortcut." -ForegroundColor Green
    }
    catch {
        Write-Host "Could not remove desktop shortcut." -ForegroundColor Red
    }
} else {
    Write-Host "No desktop shortcut found." -ForegroundColor Yellow
}

# Remove installation directory
if (Test-Path $installDir) {
    try {
        Remove-Item -Path $installDir -Recurse -Force -ErrorAction Stop
        Write-Host "Removed installation directory: $installDir" -ForegroundColor Green
    }
    catch {
        Write-Host "Could not remove installation directory. You may need to close any open files." -ForegroundColor Red
    }
} else {
    Write-Host "Installation directory not found." -ForegroundColor Yellow
}

Write-Host "`nBreak Reminder has been uninstalled successfully!" -ForegroundColor Green
Write-Host "Thank you for using Break Reminder. Stay healthy!" -ForegroundColor Cyan
pause
