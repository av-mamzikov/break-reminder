# Break Reminder Documentation

## Overview

Break Reminder is a lightweight application designed to help users maintain healthy computer usage habits by providing timely reminders to take breaks. Regular breaks help prevent eye strain, repetitive strain injuries, and other health issues associated with prolonged computer use.

The application comes in two versions (PowerShell and VBScript) and supports multiple languages through a flexible XML-based localization system that automatically detects the user's system language.

## Technical Details

### Application Versions

#### PowerShell Version
The PowerShell version uses Windows Forms to create a custom GUI notification with:
- A main form window that appears on top of other applications
- A message label with the break reminder text
- A close button to dismiss the notification
- TableLayoutPanel for proper element arrangement

#### VBScript Version
The VBScript version uses a simple message box dialog:
- No visible console window
- Standard Windows message box (MsgBox function)
- System modal dialog that stays on top of other windows
- Simple interface with a single OK button

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
- For PowerShell version: PowerShell 5.1 or higher
- For VBScript version: Windows Script Host (included in all Windows versions)
- No additional dependencies required

### Encoding

The script uses UTF-8 encoding to properly display non-ASCII characters in the reminder message.

## Configuration Options

### Unified Installer

The unified installer (`install.ps1`) provides several configuration options:
- Choose between PowerShell or VBScript version
- Create desktop shortcuts
- Set up scheduled tasks with customizable intervals
- Select preferred language

### Customizing the PowerShell Version

You can modify the following aspects of the PowerShell script by editing the corresponding sections:

#### Reminder Message

To change the reminder message, modify the XML localization files or modify the `$Label.Text` property in the script:

```powershell
$Label.Text = "Your custom reminder message here"
```

### Window Appearance

You can customize the window appearance by modifying these properties:
- `$Form.Text` - The window title
- `$Form.MinimumSize` - The minimum window size
- `$Form.FormBorderStyle` - The border style of the window
- `$Form.TopMost` - Whether the window stays on top of other windows

### Font and Styling

To change the font or styling of the message:
- Modify the font properties in the script where fonts are defined
- Adjust padding and margins in the TableLayoutPanel settings

## Advanced Usage

### Language Parameters

#### PowerShell Version
The PowerShell script accepts the following parameters for language customization:

```powershell
param (
    [string]$Language = "",  # Specify a language code (e.g., "en-US", "fr-FR")
    [switch]$ListLanguages    # List all available languages
)
```

#### VBScript Version
The VBScript accepts a language code as a command-line argument:

```
wscript.exe "path\to\break-reminder.vbs" fr-FR
```

### Examples

#### PowerShell Version
```powershell
# Run with system language (default)
.\break-reminder.ps1

# Run with a specific language
.\break-reminder.ps1 -Language fr-FR
```

#### VBScript Version
```
# Run with system language (default)
wscript.exe "path\to\break-reminder.vbs"

# Run with a specific language
wscript.exe "path\to\break-reminder.vbs" fr-FR
```

### Additional Parameters

You can extend the script to accept more parameters for customization:

```powershell
param(
    [string]$Language = "",
    [switch]$ListLanguages,
    [string]$Message = "Default message",
    [int]$DisplayTime = 60
)
```

### Adding Auto-Close Functionality

To make the reminder automatically close after a certain time:

```powershell
# Add this after form creation
$Timer = New-Object System.Windows.Forms.Timer
$Timer.Interval = 60000  # 60 seconds
$Timer.Add_Tick({ $Form.Close(); $Timer.Stop() })
$Timer.Start()
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

## Troubleshooting

### Common Issues

1. **PowerShell script won't run due to execution policy**
   - Solution: Use `-ExecutionPolicy Bypass` when running from Task Scheduler

2. **Window doesn't appear**
   - Check if the application is running with proper permissions
   - Verify the script isn't being blocked by security software

3. **Text displays incorrectly**
   - Ensure the XML localization files are saved with UTF-8 encoding
   - For VBScript, make sure you're using MSXML2.DOMDocument.6.0 which supports Unicode
   
4. **Language not working**
   - Verify the language file exists in the `localization` directory
   - Check that the language code is correct (e.g., "en-US", not "en")
   - Ensure the language file contains all required string elements
   
5. **Scheduled task not working**
   - Make sure you have administrator privileges when creating scheduled tasks
   - Check the task settings in Task Scheduler

## Future Enhancements

Potential improvements for future versions:
- Configuration file for easy customization
- Sound notifications
- Customizable reminder intervals
- Statistics tracking for breaks taken/skipped
- Additional language translations
- Right-to-left (RTL) language support
- Custom fonts for different scripts (e.g., Cyrillic, Arabic, CJK)
- Language-specific formatting options
- Cross-platform support (macOS, Linux)
- Mobile version
- Integration with productivity tools
- Customizable break activities and suggestions
