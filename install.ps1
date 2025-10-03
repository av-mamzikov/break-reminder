# Break Reminder Installer
# This script installs the Break Reminder application

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

Write-Host "`n=== Break Reminder Installation ===" -ForegroundColor Cyan

# Set variables for VBScript version
$mainScript = "break-reminder.vbs"
$executablePath = "wscript.exe"
$executableArgs = "`"$installDir\$mainScript`""
$taskArgs = "`"$installDir\$mainScript`""

# Copy files to installation directory
Write-Host "`nCopying files to installation directory..." -ForegroundColor Cyan

# Copy common files
Copy-Item -Path "$sourceDir\README.md" -Destination $installDir -Force
Copy-Item -Path "$sourceDir\DOCUMENTATION.md" -Destination $installDir -Force
Copy-Item -Path "$sourceDir\LICENSE" -Destination $installDir -Force

# Copy VBScript file
Copy-Item -Path "$sourceDir\$mainScript" -Destination $installDir -Force
Write-Host "Installed Break Reminder." -ForegroundColor Green

# Copy uninstaller files
Copy-Item -Path "$sourceDir\uninstall.ps1" -Destination $installDir -Force
Copy-Item -Path "$sourceDir\Uninstall-BreakReminder.bat" -Destination $installDir -Force
Write-Host "Installed uninstaller." -ForegroundColor Green

# Create localization directory
$localizationDir = "$installDir\localization"
if (-not (Test-Path $localizationDir)) {
    New-Item -ItemType Directory -Path $localizationDir | Out-Null
}

# Copy localization files
Get-ChildItem -Path "$sourceDir\localization\*.xml" | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $localizationDir -Force
}
Write-Host "Installed localization files for multiple languages." -ForegroundColor Green

# Create desktop shortcut
$desktopShortcut = Read-Host "`nCreate desktop shortcut? (Y/N)"
if ($desktopShortcut -eq "Y") {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Break Reminder.lnk")
    $Shortcut.TargetPath = $executablePath
    $Shortcut.Arguments = $executableArgs
    $Shortcut.Save()
    Write-Host "Desktop shortcut created." -ForegroundColor Green
}

# Offer to set up Task Scheduler
$setupTask = Read-Host "`nWould you like to set up a scheduled reminder? (Y/N)"
if ($setupTask -eq "Y") {
    $intervalOptions = @(
        "1 hour",
        "2 hours",
        "Custom"
    )
    
    Write-Host "`nHow often would you like to be reminded to take a break?"
    for ($i = 0; $i -lt $intervalOptions.Count; $i++) {
        Write-Host "[$($i+1)] $($intervalOptions[$i])"
    }
    
    $intervalChoice = Read-Host "`nEnter your choice (1-3)"
    
    switch ($intervalChoice) {
        "1" { $interval = 60 }
        "2" { $interval = 120 }
        "3" { $interval = Read-Host "Enter custom interval in minutes" }
        default { $interval = 60 }
    }
    
    # Ask for specific minute offset within the hour
    $minuteOffset = 0
    if ($interval -ge 60) {
        Write-Host "`nAt which minute of the hour would you like to be reminded?"
        Write-Host "For example: 0 = on the hour (e.g., 1:00, 2:00), 15 = quarter past (e.g., 1:15, 2:15), 45 = quarter to (e.g., 1:45, 2:45)"
        $minuteInput = Read-Host "Enter minute (0-59)"
        
        if ($minuteInput -match '^\d+$' -and [int]$minuteInput -ge 0 -and [int]$minuteInput -le 59) {
            $minuteOffset = [int]$minuteInput
        } else {
            Write-Host "Invalid input. Using 0 (on the hour)." -ForegroundColor Yellow
            $minuteOffset = 0
        }
    }
    
    $taskName = "BreakReminder_$interval" + $(if ($minuteOffset -gt 0) { "_at_$minuteOffset" } else { "" })
    
    # Calculate start time with the specified minute offset
    $now = Get-Date
    $startTime = Get-Date -Hour $now.Hour -Minute $minuteOffset -Second 0
    
    # If the minute has already passed this hour, start from next occurrence
    if ($startTime -le $now) {
        $startTime = $startTime.AddMinutes($interval)
    }
    
    # Create the scheduled task
    $action = New-ScheduledTaskAction -Execute $executablePath -Argument $taskArgs
    $trigger = New-ScheduledTaskTrigger -Once -At $startTime -RepetitionInterval (New-TimeSpan -Minutes $interval)
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
    
    try {
        $description = if ($minuteOffset -gt 0) {
            "Reminds you to take breaks from your computer every $interval minutes at :$minuteOffset past the hour"
        } else {
            "Reminds you to take breaks from your computer every $interval minutes"
        }
        
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Description $description -ErrorAction Stop
        
        if ($minuteOffset -gt 0) {
            Write-Host "Scheduled task created successfully. You will be reminded every $interval minutes at :$minuteOffset past the hour." -ForegroundColor Green
            Write-Host "Next reminder: $($startTime.ToString('HH:mm'))" -ForegroundColor Cyan
        } else {
            Write-Host "Scheduled task created successfully. You will be reminded every $interval minutes." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "Could not create scheduled task. You may need administrator privileges." -ForegroundColor Red
        Write-Host "You can still manually create a task using Task Scheduler." -ForegroundColor Yellow
    }
}

# Ask about language preference
Write-Host "`nBreak Reminder supports multiple languages. Available languages:"
Get-ChildItem -Path "$localizationDir\*.xml" | ForEach-Object {
    $langCode = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
    Write-Host "  - $langCode"
}

$setLanguage = Read-Host "`nWould you like to set a specific language? (Y/N)"
$languageParam = ""

if ($setLanguage -eq "Y") {
    $langChoice = Read-Host "Enter language code from the list above (e.g., en-US)"
    $langFile = "$localizationDir\$langChoice.xml"
    
    if (Test-Path $langFile) {
        $languageParam = $langChoice
        Write-Host "Language set to $langChoice." -ForegroundColor Green
        
        # Update shortcut and task if they were created
        if ($desktopShortcut -eq "Y") {
            $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Break Reminder.lnk")
            $Shortcut.Arguments = "`"$installDir\$mainScript`" $languageParam"
            $Shortcut.Save()
            Write-Host "Desktop shortcut updated with language preference." -ForegroundColor Green
        }
        
        if ($setupTask -eq "Y") {
            try {
                $updatedArgument = "`"$installDir\$mainScript`" $languageParam"
                $updatedAction = New-ScheduledTaskAction -Execute $executablePath -Argument $updatedArgument
                Set-ScheduledTask -TaskName $taskName -Action $updatedAction -ErrorAction Stop
                Write-Host "Scheduled task updated with language preference." -ForegroundColor Green
            }
            catch {
                Write-Host "Could not update scheduled task with language preference." -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "Language $langChoice not found. Using system default." -ForegroundColor Yellow
    }
}

Write-Host "`nBreak Reminder has been installed successfully!" -ForegroundColor Green
Write-Host "You can find the application at: $installDir" -ForegroundColor Cyan
Write-Host "`nTo run the application manually:" -ForegroundColor White

if ([string]::IsNullOrEmpty($languageParam)) {
    Write-Host "wscript.exe `"$installDir\$mainScript`"" -ForegroundColor Yellow
} else {
    Write-Host "wscript.exe `"$installDir\$mainScript`" $languageParam" -ForegroundColor Yellow
}

Write-Host "`nTo uninstall Break Reminder:" -ForegroundColor White
Write-Host "Run: `"$installDir\Uninstall-BreakReminder.bat`"" -ForegroundColor Yellow

# Offer to run the application now
$runNow = Read-Host "`nWould you like to run Break Reminder now? (Y/N)"
if ($runNow -eq "Y") {
    if ([string]::IsNullOrEmpty($languageParam)) {
        Start-Process wscript.exe -ArgumentList "`"$installDir\$mainScript`""
    } else {
        Start-Process wscript.exe -ArgumentList "`"$installDir\$mainScript`" $languageParam"
    }
    Write-Host "Break Reminder is running. Enjoy your healthier work habits!" -ForegroundColor Green
}
