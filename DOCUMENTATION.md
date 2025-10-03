# Break Reminder Documentation

## Overview

Break Reminder is a lightweight application designed to help users maintain healthy computer usage habits by providing timely reminders to take breaks. Regular breaks help prevent eye strain, repetitive strain injuries, and other health issues associated with prolonged computer use.

The application is built with VBScript and supports multiple languages through a flexible XML-based localization system that automatically detects the user's system language.

## Technical Details

### Application Version

#### VBScript Implementation
The application uses a simple message box dialog with:
- No visible console window
- Standard Windows message box (MsgBox function)
- System modal dialog that stays on top of other windows
- Yes/No buttons for user interaction:
  - **Yes button**: User acknowledges the break reminder and closes
  - **No button**: Opens Windows Task Scheduler to modify the reminder schedule
  - **X button (close)**: Just closes the dialog without opening Task Scheduler
- Language-independent Task Scheduler activation using process name (mmc.exe)
- 1-second delay before activation to ensure Task Scheduler is fully loaded

### Localization System

The application implements a robust localization system:
- Language files stored in the `localization` directory as XML files (`.xml`)
- Automatic detection of the user's system language
- Manual language selection via parameters
- Fallback to English if the requested language isn't available
- Easy extensibility for adding new languages
- Full Unicode support for all languages

### System Requirements

- Windows operating system
- Windows Script Host (included in all Windows versions)
- No additional dependencies required

### Encoding

The script uses UTF-8 encoding to properly display non-ASCII characters in the reminder message.

## Configuration Options

### Installer

The installer (`install.ps1`) provides several configuration options:
- Installs to `%LOCALAPPDATA%\BreakReminder`
- Creates optional desktop shortcuts
- Sets up scheduled tasks with customizable intervals:
  - 1 hour
  - 2 hours
  - Custom interval (user-specified minutes)
- **Minute offset selection** for intervals ≥60 minutes:
  - Choose specific minute within the hour (0-59)
  - Examples: 0 = on the hour, 15 = quarter past, 45 = quarter to
  - Smart start time calculation
- Selects preferred language
- Automatically copies uninstaller files to installation directory

### Customizing the VBScript Version

You can modify the following aspects by editing the VBScript:

#### Reminder Message

To change the reminder message, modify the XML localization files in the `localization` directory.

#### Button Behavior

The No button opens Task Scheduler. You can modify the command in the script:
```vbscript
If result = vbNo Then
    WshShell.Run "taskschd.msc /s", 1, False        
    WScript.Sleep 1000
    On Error Resume Next
    WshShell.AppActivate "mmc.exe"
    On Error GoTo 0
End If
```

The implementation uses:
- `vbYesNo` buttons instead of `vbOKCancel`
- Only `vbNo` triggers Task Scheduler opening
- Closing with X button doesn't trigger any action
- `WScript.Sleep 1000` ensures Task Scheduler loads before activation
- `AppActivate "mmc.exe"` brings window to foreground (language-independent)

## Advanced Usage

### Language Parameters

The VBScript accepts a language code as a command-line argument:

```
wscript.exe "path\to\break-reminder.vbs" fr-FR
```

### Examples

```
# Run with system language (default)
wscript.exe "path\to\break-reminder.vbs"

# Run with a specific language
wscript.exe "path\to\break-reminder.vbs" fr-FR
```


## Localization Guide

### Available Languages

The application currently includes the following languages:
- English (en-US)
- Russian (ru-RU)
- German (de-DE)
- Spanish (es-ES)
- French (fr-FR)
- Japanese (ja-JP)
- Portuguese (Brazil) (pt-BR)
- Chinese (Simplified) (zh-CN)

### Adding a New Language

1. Create a new `.xml` file in the `localization` directory
2. Name the file with the appropriate culture code (e.g., `de-DE.xml` for German)
3. Use this template structure:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<resources>
  <string name="WindowTitle">Break Reminder</string>
  <string name="ReminderMessage">Take a break!

Stand up, stretch, and rest your eyes from the screen.</string>
  <string name="CloseButtonText">Taking a break!</string>
</resources>
```

4. Translate all values to the target language
5. Make sure to save the file with UTF-8 encoding to ensure proper display of special characters

### Language File Structure

Each language file is an XML file (`.xml`) containing string resources. The element names must match exactly what the application expects:

| Element | Description |
|-----|-------------|
| `<string name="WindowTitle">` | The text displayed in the window title bar |
| `<string name="ReminderMessage">` | The main reminder message displayed to the user |
| `<string name="CloseButtonText">` | The text on the button that closes the reminder |

## Uninstaller

The uninstaller (`uninstall.ps1`) safely removes Break Reminder with multiple safety checks:

### Safety Features

1. **Path validation**:
   - Ensures path is not empty or whitespace
   - Verifies path contains "BreakReminder" string
   - Blocks deletion of system directories (`%LOCALAPPDATA%`, `%USERPROFILE%`, `%SystemRoot%`)

2. **File verification**:
   - Checks if `break-reminder.vbs` exists in the directory
   - Prompts for confirmation if file is missing

3. **What it removes**:
   - All scheduled tasks matching `BreakReminder*`
   - Desktop shortcut (`Break Reminder.lnk`)
   - Installation directory and all contents

### Usage

Run from installation directory:
```cmd
"%LOCALAPPDATA%\BreakReminder\Uninstall-BreakReminder.bat"
```

## Troubleshooting

### Common Issues

1. **Window doesn't appear**
   - Check if the application is running with proper permissions
   - Verify the script isn't being blocked by security software

2. **Text displays incorrectly**
   - Ensure the XML localization files are saved with UTF-8 encoding
   - Make sure you're using MSXML2.DOMDocument.6.0 which supports Unicode
   
3. **Language not working**
   - Verify the language file exists in the `localization` directory
   - Check that the language code is correct (e.g., "en-US", not "en")
   - Ensure the language file contains all required string elements
   
4. **Task Scheduler doesn't come to foreground**
   - The script uses `AppActivate "mmc.exe"` to bring Task Scheduler to front
   - This is language-independent and works across all Windows versions
   - 1-second delay ensures Task Scheduler is fully loaded

5. **Scheduled task not working**
   - Make sure you have administrator privileges when creating scheduled tasks
   - Check the task settings in Task Scheduler
   - Verify the task name matches pattern `BreakReminder_[interval]` or `BreakReminder_[interval]_at_[minute]`

6. **Minute offset not working**
   - Only available for intervals ≥60 minutes
   - Ensure you entered a valid number between 0-59
   - Check Task Scheduler to verify the trigger start time

## Advanced Features

### Minute Offset Selection

For intervals of 60 minutes or more, users can specify the exact minute within the hour:

**Examples:**
- `0` = On the hour (1:00, 2:00, 3:00...)
- `15` = Quarter past (1:15, 2:15, 3:15...)
- `30` = Half past (1:30, 2:30, 3:30...)
- `45` = Quarter to (1:45, 2:45, 3:45...)

**Implementation:**
- Calculates next occurrence automatically
- Updates task name to include offset (e.g., `BreakReminder_60_at_45`)
- Shows next reminder time during installation
- Task description includes minute offset information

### Task Naming Convention

- **Without offset**: `BreakReminder_[interval]` (e.g., `BreakReminder_60`)
- **With offset**: `BreakReminder_[interval]_at_[minute]` (e.g., `BreakReminder_60_at_45`)

## Future Enhancements

Potential improvements for future versions:
- Configuration file for easy customization
- Statistics tracking for breaks taken/skipped
- Additional language translations
- Right-to-left (RTL) language support
- Custom fonts for different scripts (e.g., Cyrillic, Arabic, CJK)
- Language-specific formatting options
- Break activity suggestions
- Integration with productivity tools
