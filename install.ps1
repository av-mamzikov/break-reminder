# Break Reminder Installer
# This script installs the Break Reminder application and sets up basic scheduling

# Ensure we're running with appropriate permissions
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "This installer works best with administrator privileges." -ForegroundColor Yellow
    Write-Host "Some features may be limited without admin rights." -ForegroundColor Yellow
    $adminChoice = Read-Host "Continue anyway? (Y/N)"
    if ($adminChoice -ne "Y") {
        exit
    }
}

# Define installation directory
$installDir = "$env:LOCALAPPDATA\BreakReminder"
$sourceDir = $PSScriptRoot

# Create installation directory if it doesn't exist
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
    Write-Host "Created installation directory: $installDir" -ForegroundColor Green
}

# Copy files to installation directory
Write-Host "Copying files to installation directory..." -ForegroundColor Cyan
Copy-Item -Path "$sourceDir\break-reminder.ps1" -Destination $installDir -Force
Copy-Item -Path "$sourceDir\README.md" -Destination $installDir -Force
Copy-Item -Path "$sourceDir\DOCUMENTATION.md" -Destination $installDir -Force
Copy-Item -Path "$sourceDir\LICENSE" -Destination $installDir -Force

# Create localization directory
$localizationDir = "$installDir\localization"
if (-not (Test-Path $localizationDir)) {
    New-Item -ItemType Directory -Path $localizationDir | Out-Null
}

# Copy localization files
Get-ChildItem -Path "$sourceDir\localization\*.psd1" | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $localizationDir -Force
}

# Create desktop shortcut
$desktopShortcut = Read-Host "Create desktop shortcut? (Y/N)"
if ($desktopShortcut -eq "Y") {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Break Reminder.lnk")
    $Shortcut.TargetPath = "powershell.exe"
    $Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$installDir\break-reminder.ps1`""
    $Shortcut.Save()
    Write-Host "Desktop shortcut created." -ForegroundColor Green
}

# Offer to set up Task Scheduler
$setupTask = Read-Host "Would you like to set up a scheduled reminder? (Y/N)"
if ($setupTask -eq "Y") {
    $intervalOptions = @(
        "30 minutes",
        "1 hour",
        "2 hours",
        "Custom"
    )
    
    Write-Host "How often would you like to be reminded to take a break?"
    for ($i = 0; $i -lt $intervalOptions.Count; $i++) {
        Write-Host "[$($i+1)] $($intervalOptions[$i])"
    }
    
    $intervalChoice = Read-Host "Enter your choice (1-4)"
    
    switch ($intervalChoice) {
        "1" { $interval = 30 }
        "2" { $interval = 60 }
        "3" { $interval = 120 }
        "4" { $interval = Read-Host "Enter custom interval in minutes" }
        default { $interval = 60 }
    }
    
    $taskName = "BreakReminder_$interval"
    
    # Create the scheduled task
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$installDir\break-reminder.ps1`""
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes $interval)
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
    
    try {
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Description "Reminds you to take breaks from your computer every $interval minutes" -ErrorAction Stop
        Write-Host "Scheduled task created successfully. You will be reminded every $interval minutes." -ForegroundColor Green
    }
    catch {
        Write-Host "Could not create scheduled task. You may need administrator privileges." -ForegroundColor Red
        Write-Host "You can still manually create a task using Task Scheduler." -ForegroundColor Yellow
    }
}

Write-Host "`nBreak Reminder has been installed successfully!" -ForegroundColor Green
Write-Host "You can find the application at: $installDir" -ForegroundColor Cyan
Write-Host "`nTo run the application manually:" -ForegroundColor White
Write-Host "powershell.exe -ExecutionPolicy Bypass -File `"$installDir\break-reminder.ps1`"" -ForegroundColor Yellow

# Offer to run the application now
$runNow = Read-Host "`nWould you like to run Break Reminder now? (Y/N)"
if ($runNow -eq "Y") {
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$installDir\break-reminder.ps1`""
    Write-Host "Break Reminder is running. Enjoy your healthier work habits!" -ForegroundColor Green
}
