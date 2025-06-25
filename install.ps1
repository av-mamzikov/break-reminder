# Break Reminder Unified Installer
# This script installs the Break Reminder application and lets the user choose between
# PowerShell (with visible window) or VBScript (without visible window) versions

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

# Ask user which version they want to install
Write-Host "`n=== Break Reminder Installation ===" -ForegroundColor Cyan
Write-Host "`nPlease choose which version you would like to install:" -ForegroundColor White
Write-Host "[1] PowerShell version (with custom UI, visible window briefly appears)" -ForegroundColor Yellow
Write-Host "[2] VBScript version (simple message box, no visible console window)" -ForegroundColor Yellow
$versionChoice = Read-Host "`nEnter your choice (1 or 2)"

# Set variables based on user choice
if ($versionChoice -eq "1") {
    $scriptType = "PowerShell"
    $mainScript = "break-reminder.ps1"
    $executablePath = "powershell.exe"
    $executableArgs = "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$installDir\$mainScript`""
    $taskArgs = "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$installDir\$mainScript`""
} else {
    $scriptType = "VBScript"
    $mainScript = "break-reminder.vbs"
    $executablePath = "wscript.exe"
    $executableArgs = "`"$installDir\$mainScript`""
    $taskArgs = "`"$installDir\$mainScript`""
}

# Copy files to installation directory
Write-Host "`nCopying files to installation directory..." -ForegroundColor Cyan

# Copy common files
Copy-Item -Path "$sourceDir\README.md" -Destination $installDir -Force
Copy-Item -Path "$sourceDir\DOCUMENTATION.md" -Destination $installDir -Force
Copy-Item -Path "$sourceDir\LICENSE" -Destination $installDir -Force

# Copy version-specific script
Copy-Item -Path "$sourceDir\$mainScript" -Destination $installDir -Force
Write-Host "Installed $scriptType version of Break Reminder." -ForegroundColor Green

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
        "30 minutes",
        "1 hour",
        "2 hours",
        "Custom"
    )
    
    Write-Host "`nHow often would you like to be reminded to take a break?"
    for ($i = 0; $i -lt $intervalOptions.Count; $i++) {
        Write-Host "[$($i+1)] $($intervalOptions[$i])"
    }
    
    $intervalChoice = Read-Host "`nEnter your choice (1-4)"
    
    switch ($intervalChoice) {
        "1" { $interval = 30 }
        "2" { $interval = 60 }
        "3" { $interval = 120 }
        "4" { $interval = Read-Host "Enter custom interval in minutes" }
        default { $interval = 60 }
    }
    
    $taskName = "BreakReminder_$interval"
    
    # Create the scheduled task
    $action = New-ScheduledTaskAction -Execute $executablePath -Argument $taskArgs
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
            if ($scriptType -eq "PowerShell") {
                $Shortcut.Arguments = "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$installDir\$mainScript`" -Language $languageParam"
            } else {
                $Shortcut.Arguments = "`"$installDir\$mainScript`" $languageParam"
            }
            $Shortcut.Save()
            Write-Host "Desktop shortcut updated with language preference." -ForegroundColor Green
        }
        
        if ($setupTask -eq "Y") {
            try {
                $updatedArgument = if ($scriptType -eq "PowerShell") {
                    "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$installDir\$mainScript`" -Language $languageParam"
                } else {
                    "`"$installDir\$mainScript`" $languageParam"
                }
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

Write-Host "`nBreak Reminder ($scriptType version) has been installed successfully!" -ForegroundColor Green
Write-Host "You can find the application at: $installDir" -ForegroundColor Cyan
Write-Host "`nTo run the application manually:" -ForegroundColor White

if ($scriptType -eq "PowerShell") {
    if ([string]::IsNullOrEmpty($languageParam)) {
        Write-Host "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$installDir\$mainScript`"" -ForegroundColor Yellow
    } else {
        Write-Host "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$installDir\$mainScript`" -Language $languageParam" -ForegroundColor Yellow
    }
} else {
    if ([string]::IsNullOrEmpty($languageParam)) {
        Write-Host "wscript.exe `"$installDir\$mainScript`"" -ForegroundColor Yellow
    } else {
        Write-Host "wscript.exe `"$installDir\$mainScript`" $languageParam" -ForegroundColor Yellow
    }
}

# Offer to run the application now
$runNow = Read-Host "`nWould you like to run Break Reminder now? (Y/N)"
if ($runNow -eq "Y") {
    if ($scriptType -eq "PowerShell") {
        if ([string]::IsNullOrEmpty($languageParam)) {
            Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$installDir\$mainScript`""
        } else {
            Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$installDir\$mainScript`" -Language $languageParam"
        }
    } else {
        if ([string]::IsNullOrEmpty($languageParam)) {
            Start-Process wscript.exe -ArgumentList "`"$installDir\$mainScript`""
        } else {
            Start-Process wscript.exe -ArgumentList "`"$installDir\$mainScript`" $languageParam"
        }
    }
    Write-Host "Break Reminder is running. Enjoy your healthier work habits!" -ForegroundColor Green
}
